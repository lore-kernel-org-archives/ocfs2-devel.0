From: Mark Fasheh <mark.fasheh@oracle.com>
Date: Wed Jan 23 19:15:36 2008
Subject: [Ocfs2-devel] Re: [PATCH 12/30] ocfs2: Add group extend for online
	resize
In-Reply-To: <20080123140548.95c5bbdf.akpm@linux-foundation.org>
References: <1200609356-17788-1-git-send-email-mark.fasheh@oracle.com>
	<1200609356-17788-13-git-send-email-mark.fasheh@oracle.com>
	<20080123140548.95c5bbdf.akpm@linux-foundation.org>
Message-ID: <20080124031454.GQ23506@ca-server1.us.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, ocfs2-devel@oss.oracle.com, tao.ma@oracle.com

On Wed, Jan 23, 2008 at 02:05:48PM -0800, Andrew Morton wrote:
> > On Thu, 17 Jan 2008 14:35:38 -0800 Mark Fasheh <mark.fasheh@oracle.com> wrote:
> > From: Tao Ma <tao.ma@oracle.com>
> > 
> > This patch adds the ability for a userspace program to request an extend of
> > last cluster group on an Ocfs2 file system. The request is made via ioctl,
> > OCFS2_IOC_GROUP_EXTEND. This is derived from EXT3_IOC_GROUP_EXTEND, but is
> > obviously Ocfs2 specific.
> > 
> > tunefs.ocfs2 would call this for an online-resize operation if the last
> > cluster group isn't full.
> > 
> > ...
> >
> > +/* Check whether the blkno is the super block or one of the backups. */
> > +static inline void ocfs2_check_super_or_backup(struct super_block *sb,
> > +					       sector_t blkno)
> > +{
> > +	int i;
> > +	u64 backup_blkno;
> > +
> > +	if (blkno == OCFS2_SUPER_BLOCK_BLKNO)
> > +		return;
> > +
> > +	for (i = 0; i < OCFS2_MAX_BACKUP_SUPERBLOCKS; i++) {
> > +		backup_blkno = ocfs2_backup_super_blkno(sb, i);
> > +		if (backup_blkno == blkno)
> > +			return;
> > +	}
> > +
> > +	BUG();
> 
> ow, harsh.
> 
> > +}
> 
> ocfs2_check_super_or_backup() is too large to inline.  As is
> ocfs2_backup_super_blkno() and probably lots of other stuff.

Ok, I added a patch to un-inline ocfs2_check_super_or_backup().

Give me some time to fix up ocfs2_backup_super_blkno() - I'll need to update
the ocfs2-tools tree accordingly.


> Should ocfs2_backup_super_blkno() return sector_t?

Possibly? I think we're safe as-is because a 32 bit machine should not be
able to mount a file system where overflow of this could happen. Internally,
ocfs2 uses u64 to describe file system blocks, which is why
ocfs2_backup_super_blkno() returns that.


> > + * so we don't need to lock ip_io_mutex and inode doesn't need to bea passed
> > + * into this function.
> > + */
> > +int ocfs2_write_super_or_backup(struct ocfs2_super *osb,
> > +				struct buffer_head *bh)
> > +{
> > +	int ret = 0;
> > +
> > +	mlog_entry_void();
> > +
> > +	BUG_ON(buffer_jbd(bh));
> > +	ocfs2_check_super_or_backup(osb->sb, bh->b_blocknr);
> > +
> > +	if (ocfs2_is_hard_readonly(osb) || ocfs2_is_soft_readonly(osb)) {
> > +		ret = -EROFS;
> > +		goto out;
> > +	}
> > +
> > +	lock_buffer(bh);
> > +	set_buffer_uptodate(bh);
> > +
> > +	/* remove from dirty list before I/O. */
> > +	clear_buffer_dirty(bh);
> > +
> > +	get_bh(bh); /* for end_buffer_write_sync() */
> > +	bh->b_end_io = end_buffer_write_sync;
> > +	submit_bh(WRITE, bh);
> > +
> > +	wait_on_buffer(bh);
> > +
> > +	if (!buffer_uptodate(bh)) {
> > +		ret = -EIO;
> > +		brelse(bh);
> 
> Only use brelse() when the bh might be NULL.  put_bh() is cleaner and quicker.

Ok, fixed. There was other places in fs/ocfs2/buffer_head_io.c which got the
same cleanup.

I also took care of the new:

if (bh)
	brelse(bh);

patterns in resize.c. Unfortunately, Ocfs2 is littered with this code pattern.


> > +	}
> > +
> > +out:
> > +	mlog_exit(ret);
> > +	return ret;
> > +}
> 
> Did we just reimplement sync_dirty_buffer()?

For a bit of background: What Tao did was copy a small core from the other
I/O functions into a new one for backup super block writes. This was done
for cleanliness. The actual method used for buffer_head I/O in Ocfs2 has
been unchanged for years.

At first glance, there *does* seem to be some similarity to
sync_dirty_buffer(), but there are key differences in that dirty/uptodate
state is forced in the ocfs2/buffer_head_io.c case. As such, I'm not sure
that sync_dirty_buffer() is a drop-in replacement.


> > +						     first_new_cluster,
> > +						     cl_cpg, 1);
> > +		le16_add_cpu(&group->bg_free_bits_count, -1 * backups);
> > +	}
> > +
> > +	ret = ocfs2_journal_dirty(handle, group_bh);
> > +	if (ret < 0) {
> > +		mlog_errno(ret);
> > +		goto out_rollback;
> > +	}
> > +
> > +	/* update the inode accordingly. */
> > +	ret = ocfs2_journal_access(handle, bm_inode, bm_bh,
> > +				   OCFS2_JOURNAL_ACCESS_WRITE);
> > +	if (ret < 0) {
> > +		mlog_errno(ret);
> > +		goto out_rollback;
> > +	}
> > +
> > +	chain = le16_to_cpu(group->bg_chain);
> > +	cr = (&cl->cl_recs[chain]);
> > +	le32_add_cpu(&cr->c_total, num_bits);
> > +	le32_add_cpu(&cr->c_free, num_bits);
> > +	le32_add_cpu(&fe->id1.bitmap1.i_total, num_bits);
> > +	le32_add_cpu(&fe->i_clusters, new_clusters);
> > +
> > +	if (backups) {
> > +		le32_add_cpu(&cr->c_free, -1 * backups);
> > +		le32_add_cpu(&fe->id1.bitmap1.i_used, backups);
> > +	}
> > +
> > +	spin_lock(&OCFS2_I(bm_inode)->ip_lock);
> > +	OCFS2_I(bm_inode)->ip_clusters = le32_to_cpu(fe->i_clusters);
> > +	le64_add_cpu(&fe->i_size, new_clusters << osb->s_clustersize_bits);
> > +	spin_unlock(&OCFS2_I(bm_inode)->ip_lock);
> > +	i_size_write(bm_inode, le64_to_cpu(fe->i_size));
> 
> Is i_mutex held here?  If not, i_size_write() can cause i_size_read()
> deadlocks.

Yeah - this is called from ocfs2_group_extend() which takes i_mutex after
looking up the bitmap inode.


> > +static int update_backups(struct inode * inode, u32 clusters, char *data)
> > +{
> > +	int i, ret = 0;
> > +	u32 cluster;
> > +	u64 blkno;
> > +	struct buffer_head *backup = NULL;
> > +	struct ocfs2_dinode *backup_di = NULL;
> > +	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
> > +
> > +	/* calculate the real backups we need to update. */
> > +	for (i = 0; i < OCFS2_MAX_BACKUP_SUPERBLOCKS; i++) {
> > +		blkno = ocfs2_backup_super_blkno(inode->i_sb, i);
> > +		cluster = ocfs2_blocks_to_clusters(inode->i_sb, blkno);
> > +		 if (cluster > clusters)
> 
> stray whitespace here.  checkpatch doesn't (probably can't) detect this. 
> But you apparently don't run checkpatch anwyay..

Not enough, no. And you're right - I should. I'll be much more strict about
running it in the future, thanks for pointing this out.
	--Mark

--
Mark Fasheh
Principal Software Developer, Oracle
mark.fasheh@oracle.com
