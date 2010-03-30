From: Tao Ma <tao.ma@oracle.com>
Date: Tue, 30 Mar 2010 16:05:07 +0800
Subject: [Ocfs2-devel] [PATCH 1/1] Ocfs2: Optimize punching-hole codes
 v3.
In-Reply-To: <4BB1AC8E.9040707@oracle.com>
References: <1269928186-5037-1-git-send-email-tristan.ye@oracle.com>
	<4BB1A0A7.9030209@oracle.com> <4BB1AC8E.9040707@oracle.com>
Message-ID: <4BB1B0B3.4030501@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi Tristan,

tristan wrote:
> Thanks for your so quick review;)
> 
> 
> Tao Ma wrote:
>> Hi Tristan,
>> here comes the review.
>>
>> Tristan Ye wrote:
>>> Changes from v2 to v3:
>>>
>> <snip>
>>> + /*
>>> + * Simply jump to previous record if the pos is
>>> + * the start of a record.
>>> + */
>>> + if (le32_to_cpu(rec->e_cpos) == *pos) {
>>> + i--;
>>> + if (i < 0) {
>>> + *rec_got = NULL;
>>> + return;
>>> + }
>>> +
>>> + rec = &el->l_recs[i];
>>> + range = le32_to_cpu(rec->e_cpos) +
>>> + ocfs2_rec_clusters(el, rec);
>>> + /*
>>> + * Skip a hole.
>>> + */
>>> + if (range < *pos)
>>> + *pos = range;
>> do we still need to check range < *pos? As you have already check
>> le32_to_cpu(rec->e_cpos) == *pos.
> 
> I'm afraid we have to,
> 
> See we decreased the 'i' in the if clause;) so the rec here is not the 
> same as previous one.
yes, we have decreased. so we should have range < old_rec->e_cpos(range 
now is the previous rec's end). And *pos == old_rec->e_cpos. That is of 
course range < *pos.
> 
>>> +
>>> + break;
>>> + }
>>> + }
>>> +
>>> + *rec_got = &el->l_recs[i];
>>> +}
>>> +
>>> +/*
>>> + * Helper to calculate the punching pos and length in one run, we 
>>> handle the
>>> + * following three cases in order:
>>> + *
>>> + * - remove the entire record
>>> + * - remove a partial record
>>> + * - no record needs to be removed (hole-punching completed)
>>> +*/
>>> +static void ocfs2_calc_trunc_pos(struct inode *inode,
>>> + struct ocfs2_extent_list *el,
>>> + struct ocfs2_extent_rec *rec,
>>> + u32 trunc_start, u32 *trunc_cpos,
>>> + u32 *trunc_len, u32 *trunc_end,
>>> + u64 *blkno, int *done)
>>> +{
>>> + int ret = 0;
>>> + u32 coff, range;
>>> +
>>> + range = le32_to_cpu(rec->e_cpos) + ocfs2_rec_clusters(el, rec);
>>> +
>>> + if (le32_to_cpu(rec->e_cpos) >= trunc_start) {
>>> + *trunc_cpos = le32_to_cpu(rec->e_cpos);
>>> + *trunc_len = *trunc_end - le32_to_cpu(rec->e_cpos);
>>> + *blkno = le64_to_cpu(rec->e_blkno);
>>> + *trunc_end = le32_to_cpu(rec->e_cpos);
>>> + } else if (range > trunc_start) {
>>> + *trunc_cpos = trunc_start;
>>> + *trunc_len = range - trunc_start;
>>> + coff = trunc_start - le32_to_cpu(rec->e_cpos);
>>> + *blkno = le64_to_cpu(rec->e_blkno) +
>>> + ocfs2_clusters_to_blocks(inode->i_sb, coff);
>>> + *trunc_end = trunc_start;
>>> + } else {
>>> + /*
>>> + * It may have two following possibilities:
>>> + *
>>> + * - last record has been removed
>> what do you mean last record here? Sorry, I don't understand this case.
> 
> Here we reached the 'trunc_start', means we've got nothing to truncate;)
> 
> It's the case when 'range == trunc_start'
> 
>>> + * - trunc_start was within a hole
> 
> So here is the case when 'range < trunc_start'
oh, so do please change 'last record has been removed' somehow, I can't 
understand what it means actually.
>>> @@ -1482,16 +1588,13 @@ static int ocfs2_remove_inode_range(struct 
>>> inode *inode,
>>> }
>>>
>>> trunc_start = ocfs2_clusters_for_bytes(osb->sb, byte_start);
>>> - trunc_len = (byte_start + byte_len) >> osb->s_clustersize_bits;
>>> - if (trunc_len >= trunc_start)
>>> - trunc_len -= trunc_start;
>>> - else
>>> - trunc_len = 0;
>>> + trunc_end = (byte_start + byte_len) >> osb->s_clustersize_bits;
>>> + cluster_within_list = trunc_end;
>> You said in the comments below that "we want to find a path which 
>> contains (trunc_end - 1)". So we also need to set trunc_end -1 here? 
>> Otherwise you may enter the wrong extent block in some case?
> 
> No, I'm afraid we'd rather do like this, since 'trunc_end - 1' is used 
> for finding the next extent block when crossing the blocks, trunc_end is 
> for contiguous truncating..
why? you use cluster_with_list to search the path. So consider trunc_end 
is just the cpos for a extent block(not the leaf extent rec). You go to 
the wrong extent block actually in the first ocfs2_find_path. But you 
will find that the first rec->e_cpos == trunc_end and go to the previous 
extent block. So an extra loop here.
>>> + /*
>>> + * Unlike truncate codes, here we want to find a path which
>>> + * contains (trunc_end - 1) cpos, and then trunc_end will be
>>> + * decreased after each removal of a record range.
>>> + *
>>> + * Why not using trunc_end to search the path?
>>> + * The reason is simple, think about the situation of crossing
>>> + * the extent block, we need to find the adjacent block by
>>> + * decreasing one cluster, otherwise, it will run into a loop.
>>> + */
>>> + ret = ocfs2_find_path(INODE_CACHE(inode), path,
>>> + cluster_within_list);
>>> if (ret) {
>>> mlog_errno(ret);
>>> goto out;
>>> }
>>>
>>> - if (alloc_size > trunc_len)
>>> - alloc_size = trunc_len;
>>> + el = path_leaf_el(path);
>>>
>>> - /* Only do work for non-holes */
>>> - if (phys_cpos != 0) {
>>> - ret = ocfs2_remove_btree_range(inode, &et, cpos,
>>> - phys_cpos, alloc_size,
>>> - &dealloc, refcount_loc,
>>> - flags);
>>> - if (ret) {
>>> - mlog_errno(ret);
>>> - goto out;
>>> - }
>>> + ocfs2_find_rec_with_pos(el, &rec, &trunc_end);
>>> + /*
>>> + * Go to next extent block directly when last rec was truncated.
>>> + */
>>> + if (!rec) {
>>> + cluster_within_list = trunc_end - 1;
>>> + ocfs2_reinit_path(path, 1);
>>> + break;
>> ocfs2_find_rec_with_pos will find a rec contains trunc_end and if 
>> there is no such rec and trunc_end < el->l_recs[0].e_cpos, rec will be 
>> set NULL, right?
> 
> Correct.
> 
>> So what if the el is in the left most extent block? Your function will 
>> iterate again and again with every time trunc_end--?
> 
> Cool, you've found a bug here:
> 
> OCFS2: ERROR (device sda8): ocfs2_remove_extent: Owner 66050 has an 
> extent at cpos 1245184 which can no longer be found.
> 
> File system is now read-only due to the potential of on-disk corruption. 
> Please run fsck.ocfs2 once the file system is unmounted.
> (5975,0):ocfs2_remove_btree_range:5799 ERROR: status = -30
> (5975,0):ocfs2_remove_inode_range:1654 ERROR: status = -30
> (5975,0):__ocfs2_change_file_space:1778 ERROR: status = -30
> 
> 
> Thanks for pointing this out.
> 
> This happens when we've alreay have a hole from 0 to the first extent 
> block.
> 
> 
>> another problem is that your comments is "Go to next extent block 
>> directly when last rec was truncated", I guess you mean 'previous'? 
>> And you 'break'
> 
> I hate being a moron to make such a mistake, it definitely should be 
> 'previous' extent block.
And we need to change 'break' to 'contiue' also, right?

Regards,
Tao
