From: Tao Ma <tao.ma@oracle.com>
Date: Tue, 16 Mar 2010 17:17:35 +0800
Subject: [Ocfs2-devel] [PATCH 1/4] ocfs2: allocation reservations
In-Reply-To: <1268188148-5253-2-git-send-email-mfasheh@suse.com>
References: <1268188148-5253-1-git-send-email-mfasheh@suse.com>
	<1268188148-5253-2-git-send-email-mfasheh@suse.com>
Message-ID: <4B9F4CAF.6090904@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi Mark,
	The idea is cool. Some comments inlined.
Mark Fasheh wrote:
> This patch improves Ocfs2 allocation policy by allowing an inode to
> reserve a portion of the local alloc bitmap for itself. The reserved
> portion (allocation window) is advisory in that other allocation
> windows might steal it if the local alloc bitmap becomes
> full. Otherwise, the reservations are honored and guaranteed to be
> free. When the local alloc window is moved to a different portion of
> the bitmap, existing reservations are discarded.
> 
> Reservation windows are represented internally by a red-black
> tree. Within that tree, each node represents the reservation window of
> one inode. An LRU of active reservations is also maintained. When new
> data is written, we allocate it from the inodes window. When all bits
> in a window are exhausted, we allocate a new one as close to the
> previous one as possible. Should we not find free space, an existing
> reservation is pulled off the LRU and cannibalized.
> 
> Signed-off-by: Mark Fasheh <mfasheh@suse.com>
<snip>
> +static void ocfs2_check_resmap(struct ocfs2_reservation_map *resmap)
> +{
> +	unsigned int off = 0;
> +	int i = 0;
> +	struct rb_node *node;
> +	struct ocfs2_alloc_reservation *resv;
> +
> +	node = rb_first(&resmap->m_reservations);
> +	while (node) {
> +		resv = rb_entry(node, struct ocfs2_alloc_reservation, r_node);
> +
> +		if (i > 0 && resv->r_start <= off) {
> +			mlog(ML_ERROR, "reservation %d has bad start off!\n",
> +			     i);
> +			goto bad;
> +		}
> +
> +		if (resv->r_len == 0) {
> +			mlog(ML_ERROR, "reservation %d has no length!\n",
> +			     i);
> +			goto bad;
> +		}
> +
> +		if (resv->r_start > ocfs2_resv_end(resv)) {
> +			mlog(ML_ERROR, "reservation %d has invalid range!\n",
> +			     i);
> +			goto bad;
> +		}
> +
> +		if (ocfs2_resv_end(resv) > resmap->m_bitmap_len) {
I guess here should be ocfs2_resv_end(resv) >= resmap->m_bitmap_len?
> +			mlog(ML_ERROR, "reservation %d extends past bitmap!\n",
> +			     i);
> +			goto bad;
> +		}
> +
> +		if (ocfs2_validate_resmap_bits(resmap, i, resv))
> +			goto bad;
> +
> +		off = ocfs2_resv_end(resv);
> +		node = rb_next(node);
> +
> +		i++;
> +	}
> +	return;
> +
> +bad:
> +	ocfs2_dump_resv(resmap);
> +	BUG();
> +}
<snip>
> +static void ocfs2_resv_insert(struct ocfs2_reservation_map *resmap,
> +			      struct ocfs2_alloc_reservation *new)
> +{
> +	struct rb_root *root = &resmap->m_reservations;
> +	struct rb_node *parent = NULL;
> +	struct rb_node **p = &root->rb_node;
> +	struct ocfs2_alloc_reservation *tmp;
> +
> +	assert_spin_locked(&resv_lock);
> +
> +	mlog(0, "Insert reservation start: %u len: %u\n", new->r_start,
> +	     new->r_len);
> +
> +	while(*p) {
> +		parent = *p;
> +
> +		tmp = rb_entry(parent, struct ocfs2_alloc_reservation, r_node);
> +
> +		if (new->r_start < tmp->r_start)
> +			p = &(*p)->rb_left;
> +		else if (new->r_start > ocfs2_resv_end(tmp))
> +			p = &(*p)->rb_right;
> +		else {
> +			/* This should never happen! */
> +			mlog(ML_ERROR, "Duplicate reservation window!\n");
> +			BUG();
We bug out here in case r_start is in [tmp->r_start, 
ocfs2_resv_end(tmp)]. Do we need to check ocfs2_resv_end(new) somewhere?
> +		}
> +	}
> +
> +	rb_link_node(&new->r_node, parent, p);
> +	rb_insert_color(&new->r_node, root);
> +	new->r_inuse = 1;
> +
> +	ocfs2_resv_mark_lru(resmap, new);
> +
> +	ocfs2_check_resmap(resmap);
> +}
<snip>
> +static void __ocfs2_resv_find_window(struct ocfs2_reservation_map *resmap,
> +				     struct ocfs2_alloc_reservation *resv,
> +				     unsigned int goal, unsigned int wanted)
<snip>
> +{
> +	/* Now we do a linear search for a window, starting at 'prev_rsv' */
> +	while (1) {
> +		next = rb_next(prev);
> +		if (next) {
> +			mlog(0, "One more resv found in linear search\n");
> +			next_resv = rb_entry(next,
> +					     struct ocfs2_alloc_reservation,
> +					     r_node);
> +
> +			gap_start = ocfs2_resv_end(prev_resv) + 1;
> +			gap_end = next_resv->r_start - 1;
> +			gap_len = gap_end - gap_start + 1;
> +		} else {
> +			mlog(0, "No next node\n");
> +			/*
> +			 * We're at the rightmost edge of the
> +			 * tree. See if a reservation between this
> +			 * window and the end of the bitmap will work.
> +			 */
> +			gap_start = ocfs2_resv_end(prev_resv) + 1;
> +			gap_len = resmap->m_bitmap_len - gap_start;
> +			gap_end = resmap->m_bitmap_len - 1;
> +		}
> +
> +		clen = ocfs2_resmap_find_free_bits(resmap, wanted, gap_start,
> +						   gap_len, &cstart, &clen);
I guess we can have some improvement here? In case gap_len <= best_len, 
we don't need to call this function actually and just loop to the next 
round.
> +		if (clen == wanted) {
> +			best_len = clen;
> +			best_start = cstart;
> +			goto out_insert;
> +		} else if (clen > best_len) {
> +			best_len = clen;
> +			best_start = cstart;
> +		}
> +
> +		if (!next)
> +			break;
> +
> +		prev = next;
> +		prev_resv = rb_entry(prev, struct ocfs2_alloc_reservation,
> +				     r_node);
> +	}
> +
> +out_insert:
> +	if (best_len) {
> +		resv->r_start = best_start;
> +		resv->r_len = best_len;
> +		ocfs2_resv_insert(resmap, resv);
> +	}
> +}
> +static void ocfs2_cannibalize_resv(struct ocfs2_reservation_map *resmap,
> +				   struct ocfs2_alloc_reservation *resv,
> +				   unsigned int wanted)
> +{
<snip>
> +	} else {
> +		unsigned int shrink = lru_resv->r_len / 2;
> +
> +		mlog(0, "shrink lru resv by %u\n", shrink);
> +
> +		lru_resv->r_len -= shrink;
Do we need to change lru_resv->r_last_len here so that the next search 
can start right after the shrinked zone? I am not sure.
> +
> +		resv->r_start = ocfs2_resv_end(lru_resv) + 1;
> +		resv->r_len = shrink;
> +	}
> +
<snip>
> +void ocfs2_resmap_claimed_bits(struct ocfs2_reservation_map *resmap,
> +			       struct ocfs2_alloc_reservation *resv,
> +			       u32 cstart, u32 clen)
> +{
> +	unsigned int cend = cstart + clen - 1;
> +	int search, used_resv = 0;
> +
> +	if (resmap == NULL || ocfs2_resmap_disabled(resmap))
> +		return;
> +
> +	if (resv == NULL)
> +		return;
> +
> +	spin_lock(&resv_lock);
> +
> +	mlog(0, "claim bits: cstart: %u cend: %u clen: %u r_start: %u "
> +	     "r_end: %u r_len: %u, r_last_start: %u r_last_len: %u\n",
> +	     cstart, cend, clen, resv->r_start, ocfs2_resv_end(resv),
> +	     resv->r_len, resv->r_last_start, resv->r_last_len);
> +
> +	/*
> +	 * Find all reservations which contain (cstart-clen). This
> +	 * could potentially be multiple ones, depending on the
> +	 * allocation.
I am just curious how this could happen with multiple reservations. ;)
> +	 *
> +	 * Each one needs to be adjusted. If the allocation overwrites
> +	 * the whole window, we should just discard that reservation.
> +	 *
> +	 * If we hit the one passed in ('resv'), we treat it slightly
> +	 * special by trying to extend it after adjustments have been
> +	 * made.
> +	 */
> +
> +	search = cstart;
> +	while (search <= cend) {
> +		struct ocfs2_alloc_reservation *r;
> +		int inc;
> +
> +		/*
> +		 * This will find us the leftmost resv containing any
> +		 * bits between 'search' and 'cend'
> +		 */
> +		r = ocfs2_find_resv_containing(resmap, search, cend);
> +		if (!r)
> +			break;
> +
> +		inc = ocfs2_adjust_resv_from_alloc(resmap, r, search, cend);
> +
> +		/*
> +		 * This will signal the next set of code that 'resv'
> +		 * was used at least partially by the allocation.
> +		 */
> +		if (r == resv) {
> +			used_resv = 1;
I just found that used_resv isn't used anymore later.
> +			resv->r_last_start = search;
> +			resv->r_last_len = inc;
> +
> +			/*
> +			 * May have been discarded above from
> +			 * ocfs2_adjust_resv_from_alloc().
> +			 */
> +			if (!ocfs2_resv_empty(resv))
> +				ocfs2_resv_mark_lru(resmap, resv);
> +		}
> +
> +		search += inc;
> +	}
> +
<snip>
> +struct ocfs2_reservation_map {
> +	struct rb_root		m_reservations;
> +	char			*m_disk_bitmap;
> +
> +	struct ocfs2_super	*m_osb;
> +
> +	/* The following are not initialized to meaningful values until a disk
> +	 * bitmap is provided. */
> +	u32			m_bitmap_len;	/* Number of valid
> +						 * bits available */
> +
> +	unsigned int		m_search_start;	/* Records the end
> +						 * location of our
> +						 * most recent
> +						 * allocation. */
oh, this member isn't used actually.
> +
> +	struct list_head	m_lru;		/* LRU of reservations
> +						 * structures. */
> +
> +};
<snip>
> @@ -1429,6 +1434,17 @@ static int ocfs2_parse_options(struct super_block *sb,
>  			mopt->mount_opt |= OCFS2_MOUNT_NO_POSIX_ACL;
>  			mopt->mount_opt &= ~OCFS2_MOUNT_POSIX_ACL;
>  			break;
> +		case Opt_resv_level:
> +			if (is_remount)
> +				break;
> +			if (match_int(&args[0], &option)) {
> +				status = 0;
> +				goto bail;
> +			}
> +			if (option >= OCFS2_MIN_RESV_LEVEL &&
> +			    option < OCFS2_MAX_RESV_LEVEL)
> +				mopt->resv_level = option;
Do we need to check cluster size here? I guess with a large cluster 
size, say 1M, we need a very small window or even no window.
ok, that's all for the codes.

Besides the comments, I have some other thoughts.
1. Do we need to some additional check in 
ocfs2_reserve_local_alloc_bits? The old schema just check the condition 
bits_wanted <= free_bits since local_alloc is contiguous enough. But 
with reservation window, we can have a fragmented local alloc actually.
2. Current codes don't handle with space reservations(unwritten 
extents). Maybe it is because unwritten will allocate contiguous clusters?

With these 2 problems, I corrupted the system somehow by the following 
scripts(Sorry, Mark, ;) ).

echo 'y'|mkfs.ocfs2 -b 4K -C 4K --fs-features=local $DEVICE
mount -t ocfs2 $DEVICE $MNT_DIR
for((j=0;j<32;j++))
do
         FILE_NAME=$MNT_DIR/$RANDOM
         for((i=0;i<63;i++))
         do
         cat /mnt/4096 >> $FILE_NAME #4096 is a file with 4096 bytes.
         done
done
FILE_NAME=$MNT_DIR/$RANDOM
./rw_test -f $FILE_NAME -l 0 -u 8192 #this will create a file with an 
unwritten extent of 2 clusters length at offset 0.
umount $MNT_DIR

Now run fsck.ocfs2, you will find duplicated clusters.
This is caused by the code here.
 >	start = ocfs2_local_alloc_find_clear_bits(osb, alloc, bits_wanted,
 >                                                  ac->ac_resv);
 >        if (start == -1) {
 >                /* TODO: Shouldn't we just BUG here? */
 >                status = -ENOSPC;
 >                mlog_errno(status);
 >                goto bail;
 >        }
 >        printk("end of start %d\n", start);
 >
 >        bitmap = la->la_bitmap;
 >        *bit_off = le32_to_cpu(la->la_bm_off) + start;
 >        /* local alloc is always contiguous by nature -- we never
 >         * delete bits from it! */
 >        *num_bits = bits_wanted;

See here? bit_wanted is 2, while with the script, the local alloc is 
divided into 32 parts and every part only have 1 clusters left. But this 
code deem that we can always get bits_wanted. :)

Regards,
Tao
