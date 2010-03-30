From: tristan <tristan.ye@oracle.com>
Date: Tue, 30 Mar 2010 15:47:26 +0800
Subject: [Ocfs2-devel] [PATCH 1/1] Ocfs2: Optimize punching-hole codes
 v3.
In-Reply-To: <4BB1A0A7.9030209@oracle.com>
References: <1269928186-5037-1-git-send-email-tristan.ye@oracle.com>
	<4BB1A0A7.9030209@oracle.com>
Message-ID: <4BB1AC8E.9040707@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Thanks for your so quick review;)


Tao Ma wrote:
> Hi Tristan,
> here comes the review.
>
> Tristan Ye wrote:
>> Changes from v2 to v3:
>>
> <snip>
>> +/*
>> + * Hepler to find the rightmost record which contains 'pos' cpos,
>> + * skip the holes if any, also adjust the 'pos' accordingly.
> You don't mentioned what 'pos' indicates here, so it is very hard to 
> read this function and I have to guess. ;) So please describe it in 
> detail.

Nod,

I'll elaborate this with more inks;)

>> + */
>> +static void ocfs2_find_rec_with_pos(struct ocfs2_extent_list *el,
>> + struct ocfs2_extent_rec **rec_got,
>> + u32 *pos)
>> +{
>> + int i;
>> + u32 range;
>> + struct ocfs2_extent_rec *rec = NULL;
>> +
>> + for (i = le16_to_cpu(el->l_next_free_rec) - 1; i >= 0; i--) {
>> +
>> + rec = &el->l_recs[i];
>> + range = le32_to_cpu(rec->e_cpos) +
>> + ocfs2_rec_clusters(el, rec);
>> +
>> + if (le32_to_cpu(rec->e_cpos) < *pos) {
>> + /*
>> + * Skip a hole.
>> + */
>> + if (range < *pos)
>> + *pos = range;
>> +
>> + break;
>> + }
>> +
>> + /*
>> + * Simply jump to previous record if the pos is
>> + * the start of a record.
>> + */
>> + if (le32_to_cpu(rec->e_cpos) == *pos) {
>> + i--;
>> + if (i < 0) {
>> + *rec_got = NULL;
>> + return;
>> + }
>> +
>> + rec = &el->l_recs[i];
>> + range = le32_to_cpu(rec->e_cpos) +
>> + ocfs2_rec_clusters(el, rec);
>> + /*
>> + * Skip a hole.
>> + */
>> + if (range < *pos)
>> + *pos = range;
> do we still need to check range < *pos? As you have already check
> le32_to_cpu(rec->e_cpos) == *pos.

I'm afraid we have to,

See we decreased the 'i' in the if clause;) so the rec here is not the 
same as previous one.

>> +
>> + break;
>> + }
>> + }
>> +
>> + *rec_got = &el->l_recs[i];
>> +}
>> +
>> +/*
>> + * Helper to calculate the punching pos and length in one run, we 
>> handle the
>> + * following three cases in order:
>> + *
>> + * - remove the entire record
>> + * - remove a partial record
>> + * - no record needs to be removed (hole-punching completed)
>> +*/
>> +static void ocfs2_calc_trunc_pos(struct inode *inode,
>> + struct ocfs2_extent_list *el,
>> + struct ocfs2_extent_rec *rec,
>> + u32 trunc_start, u32 *trunc_cpos,
>> + u32 *trunc_len, u32 *trunc_end,
>> + u64 *blkno, int *done)
>> +{
>> + int ret = 0;
>> + u32 coff, range;
>> +
>> + range = le32_to_cpu(rec->e_cpos) + ocfs2_rec_clusters(el, rec);
>> +
>> + if (le32_to_cpu(rec->e_cpos) >= trunc_start) {
>> + *trunc_cpos = le32_to_cpu(rec->e_cpos);
>> + *trunc_len = *trunc_end - le32_to_cpu(rec->e_cpos);
>> + *blkno = le64_to_cpu(rec->e_blkno);
>> + *trunc_end = le32_to_cpu(rec->e_cpos);
>> + } else if (range > trunc_start) {
>> + *trunc_cpos = trunc_start;
>> + *trunc_len = range - trunc_start;
>> + coff = trunc_start - le32_to_cpu(rec->e_cpos);
>> + *blkno = le64_to_cpu(rec->e_blkno) +
>> + ocfs2_clusters_to_blocks(inode->i_sb, coff);
>> + *trunc_end = trunc_start;
>> + } else {
>> + /*
>> + * It may have two following possibilities:
>> + *
>> + * - last record has been removed
> what do you mean last record here? Sorry, I don't understand this case.

Here we reached the 'trunc_start', means we've got nothing to truncate;)

It's the case when 'range == trunc_start'

>> + * - trunc_start was within a hole

So here is the case when 'range < trunc_start'

>> + *
>> + * both two cases mean the completion of hole punching.
>> + */
>> + ret = 1;
>> + }
>> +
>> + *done = ret;
>> +}
>> +
>> static int ocfs2_remove_inode_range(struct inode *inode,
>> struct buffer_head *di_bh, u64 byte_start,
>> u64 byte_len)
>> {
>> - int ret = 0, flags = 0;
>> - u32 trunc_start, trunc_len, cpos, phys_cpos, alloc_size;
>> + int ret = 0, flags = 0, done = 0;
>> + u32 trunc_start, trunc_len, trunc_end, trunc_cpos, phys_cpos;
>> + u32 cluster_within_list;
>> struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
>> struct ocfs2_cached_dealloc_ctxt dealloc;
>> struct address_space *mapping = inode->i_mapping;
>> struct ocfs2_extent_tree et;
>> + struct ocfs2_path *path = NULL;
>> + struct ocfs2_extent_list *el = NULL;
>> + struct ocfs2_extent_rec *rec = NULL;
>> struct ocfs2_dinode *di = (struct ocfs2_dinode *)di_bh->b_data;
>> - u64 refcount_loc = le64_to_cpu(di->i_refcount_loc);
>> + u64 blkno, refcount_loc = le64_to_cpu(di->i_refcount_loc);
>>
>> ocfs2_init_dinode_extent_tree(&et, INODE_CACHE(inode), di_bh);
>> ocfs2_init_dealloc_ctxt(&dealloc);
>> @@ -1482,16 +1588,13 @@ static int ocfs2_remove_inode_range(struct 
>> inode *inode,
>> }
>>
>> trunc_start = ocfs2_clusters_for_bytes(osb->sb, byte_start);
>> - trunc_len = (byte_start + byte_len) >> osb->s_clustersize_bits;
>> - if (trunc_len >= trunc_start)
>> - trunc_len -= trunc_start;
>> - else
>> - trunc_len = 0;
>> + trunc_end = (byte_start + byte_len) >> osb->s_clustersize_bits;
>> + cluster_within_list = trunc_end;
> You said in the comments below that "we want to find a path which 
> contains (trunc_end - 1)". So we also need to set trunc_end -1 here? 
> Otherwise you may enter the wrong extent block in some case?

No, I'm afraid we'd rather do like this, since 'trunc_end - 1' is used 
for finding the next extent block when crossing the blocks, trunc_end is 
for contiguous truncating..

>>
>> - mlog(0, "Inode: %llu, start: %llu, len: %llu, cstart: %u, clen: %u\n",
>> + mlog(0, "Inode: %llu, start: %llu, len: %llu, cstart: %u, cend: %u\n",
>> (unsigned long long)OCFS2_I(inode)->ip_blkno,
>> (unsigned long long)byte_start,
>> - (unsigned long long)byte_len, trunc_start, trunc_len);
>> + (unsigned long long)byte_len, trunc_start, trunc_end);
>>
>> ret = ocfs2_zero_partial_clusters(inode, byte_start, byte_len);
>> if (ret) {
>> @@ -1499,32 +1602,65 @@ static int ocfs2_remove_inode_range(struct 
>> inode *inode,
>> goto out;
>> }
>>
>> - cpos = trunc_start;
>> - while (trunc_len) {
>> - ret = ocfs2_get_clusters(inode, cpos, &phys_cpos,
>> - &alloc_size, &flags);
>> + path = ocfs2_new_path_from_et(&et);
>> + if (!path) {
>> + ret = -ENOMEM;
>> + mlog_errno(ret);
>> + goto out;
>> + }
>> +
>> + while (trunc_end > 0) {
> I am just curious of this check. trunc_end seems to be a cluster 
> offset. So how could it be 0 in case we don't punch from the 0 and 
> where do you set it to 0?

Yes, trunc_end is an offset in clusters. a 'trunc_end > 0' check looks 
like overkill, since we actually always get out of the while loop from:

+ ocfs2_calc_trunc_pos(inode, el, rec, trunc_start, &trunc_cpos,
+ &trunc_len, &trunc_end, &blkno, &done);
+ if (done)
+ break;

trunc_end > trunc_start will make more sense, thanks.


>> + /*
>> + * Unlike truncate codes, here we want to find a path which
>> + * contains (trunc_end - 1) cpos, and then trunc_end will be
>> + * decreased after each removal of a record range.
>> + *
>> + * Why not using trunc_end to search the path?
>> + * The reason is simple, think about the situation of crossing
>> + * the extent block, we need to find the adjacent block by
>> + * decreasing one cluster, otherwise, it will run into a loop.
>> + */
>> + ret = ocfs2_find_path(INODE_CACHE(inode), path,
>> + cluster_within_list);
>> if (ret) {
>> mlog_errno(ret);
>> goto out;
>> }
>>
>> - if (alloc_size > trunc_len)
>> - alloc_size = trunc_len;
>> + el = path_leaf_el(path);
>>
>> - /* Only do work for non-holes */
>> - if (phys_cpos != 0) {
>> - ret = ocfs2_remove_btree_range(inode, &et, cpos,
>> - phys_cpos, alloc_size,
>> - &dealloc, refcount_loc,
>> - flags);
>> - if (ret) {
>> - mlog_errno(ret);
>> - goto out;
>> - }
>> + ocfs2_find_rec_with_pos(el, &rec, &trunc_end);
>> + /*
>> + * Go to next extent block directly when last rec was truncated.
>> + */
>> + if (!rec) {
>> + cluster_within_list = trunc_end - 1;
>> + ocfs2_reinit_path(path, 1);
>> + break;
> ocfs2_find_rec_with_pos will find a rec contains trunc_end and if 
> there is no such rec and trunc_end < el->l_recs[0].e_cpos, rec will be 
> set NULL, right?

Correct.

> So what if the el is in the left most extent block? Your function will 
> iterate again and again with every time trunc_end--?

Cool, you've found a bug here:

OCFS2: ERROR (device sda8): ocfs2_remove_extent: Owner 66050 has an 
extent at cpos 1245184 which can no longer be found.

File system is now read-only due to the potential of on-disk corruption. 
Please run fsck.ocfs2 once the file system is unmounted.
(5975,0):ocfs2_remove_btree_range:5799 ERROR: status = -30
(5975,0):ocfs2_remove_inode_range:1654 ERROR: status = -30
(5975,0):__ocfs2_change_file_space:1778 ERROR: status = -30


Thanks for pointing this out.

This happens when we've alreay have a hole from 0 to the first extent block.


> another problem is that your comments is "Go to next extent block 
> directly when last rec was truncated", I guess you mean 'previous'? 
> And you 'break'

I hate being a moron to make such a mistake, it definitely should be 
'previous' extent block.

> here, so how could the previous extent block get punched? Am I wrong 
> somehow?


>> }
>>
>> - cpos += alloc_size;
>> - trunc_len -= alloc_size;
>> + ocfs2_calc_trunc_pos(inode, el, rec, trunc_start, &trunc_cpos,
>> + &trunc_len, &trunc_end, &blkno, &done);
>> + if (done)
>> + break;
>> +
>> + flags = rec->e_flags;
>> + phys_cpos = ocfs2_blocks_to_clusters(inode->i_sb, blkno);
>> +
>> + ret = ocfs2_remove_btree_range(inode, &et, trunc_cpos,
>> + phys_cpos, trunc_len, &dealloc,
>> + refcount_loc, flags);
>> + if (ret < 0) {
>> + mlog_errno(ret);
>> + goto out;
>> + }
>> +
>> + if (trunc_end > 0)
>> + cluster_within_list = trunc_end - 1;
>> + else
>> + break;
>> +
>> + ocfs2_reinit_path(path, 1);
>> }
>>
>> ocfs2_truncate_cluster_pages(inode, byte_start, byte_len);
>
> Regards,
> Tao
