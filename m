From: tristan <tristan.ye@oracle.com>
Date: Thu, 28 Jan 2010 09:36:17 +0800
Subject: [Ocfs2-devel] [PATCH 3/3] Ocfs2: Treat ocfs2 truncate as a
 special case of punching holes.
In-Reply-To: <4B60C10F.60900@oracle.com>
References: <1264591326-24591-1-git-send-email-tristan.ye@oracle.com>
	<1264591326-24591-3-git-send-email-tristan.ye@oracle.com>
	<4B60C10F.60900@oracle.com>
Message-ID: <4B60EA11.6010300@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

TaoMa wrote:
> Tristan Ye wrote:
>> As we known, truncate is just a special case of punching holes(from 
>> new i_size
>> to end), we therefore could take advantage of existing 
>> ocfs2_remove_btree_range()
>> codes to reduce the comlexity and redundancy in alloc.c, the goal 
>> here is to make
>> truncate codes more generic and straightforward.
>>
>> Several former functions only used by ocfs2_commit_truncate() will be 
>> simply wiped off.
>> New logic for truncating will remove extents from truncate_size to 
>> file end one by one,
>> just like punching holes did.
>>
>> v2 patch uses former sequence of records truncating(from tail to 
>> new_i_size) which keeps
>> a high efficiency in performance, also, it has the refcount support 
>> as well.
>>
>> Signed-off-by: Tristan Ye <tristan.ye@oracle.com>
>> ---
>> fs/ocfs2/alloc.c | 556 
>> +++++------------------------------------------------
>> fs/ocfs2/alloc.h | 3 +-
>> fs/ocfs2/file.c | 9 +-
>> fs/ocfs2/inode.c | 9 +-
>> 4 files changed, 56 insertions(+), 521 deletions(-)
>>
>> diff --git a/fs/ocfs2/alloc.c b/fs/ocfs2/alloc.c
>> index 6c5f1de..0c42003 100644
>> --- a/fs/ocfs2/alloc.c
>> +++ b/fs/ocfs2/alloc.c
>>
>> @@ -7422,21 +6999,25 @@ out:
>> */
>> int ocfs2_commit_truncate(struct ocfs2_super *osb,
>> struct inode *inode,
>> - struct buffer_head *fe_bh,
>> - struct ocfs2_truncate_context *tc)
>> + struct buffer_head *fe_bh)
>> {
>> - int status, i, credits, tl_sem = 0;
>> - u32 clusters_to_del, new_highest_cpos, range;
>> + int status = 0, i, credits = 0, ref_blocks = 0, flags = 0;
>> + u32 new_highest_cpos, range, trunc_cpos, trunc_len, phys_cpos, coff;
>> u64 blkno = 0;
>> struct ocfs2_extent_list *el;
>> - handle_t *handle = NULL;
>> - struct inode *tl_inode = osb->osb_tl_inode;
>> + struct ocfs2_extent_rec *rec;
>> struct ocfs2_path *path = NULL;
>> struct ocfs2_dinode *di = (struct ocfs2_dinode *)fe_bh->b_data;
>> - struct ocfs2_alloc_context *meta_ac = NULL;
>> +
>> + struct ocfs2_extent_tree et;
>> + struct ocfs2_cached_dealloc_ctxt dealloc;
>> +
>> struct ocfs2_refcount_tree *ref_tree = NULL;
>>
>> mlog_entry_void();
>> +
>> + ocfs2_init_dinode_extent_tree(&et, INODE_CACHE(inode), fe_bh);
>> + ocfs2_init_dealloc_ctxt(&dealloc);
>>
>> new_highest_cpos = ocfs2_clusters_for_bytes(osb->sb,
>> i_size_read(inode));
>> @@ -7449,8 +7030,6 @@ int ocfs2_commit_truncate(struct ocfs2_super *osb,
>> goto bail;
>> }
>>
>> - ocfs2_extent_map_trunc(inode, new_highest_cpos);
>> -
> Please keep this line. It will truncate the extent map.

I guess it's safe to remove extent map here, since ocfs2_remove_extent() 
will do the same.


>> start:
>> /*
>> * Check that we still have allocation to delete.
>> @@ -7461,6 +7040,7 @@ start:
>> }
>>
>> credits = 0;
>> + ref_blocks = 0;
>>
>> /*
>> * Truncate always works against the rightmost tree branch.
>> @@ -7496,30 +7076,47 @@ start:
>> }
>>
>> i = le16_to_cpu(el->l_next_free_rec) - 1;
>> - range = le32_to_cpu(el->l_recs[i].e_cpos) +
>> - ocfs2_rec_clusters(el, &el->l_recs[i]);
>> - if (i == 0 && ocfs2_is_empty_extent(&el->l_recs[i])) {
>> - clusters_to_del = 0;
>> - } else if (le32_to_cpu(el->l_recs[i].e_cpos) >= new_highest_cpos) {
>> - clusters_to_del = ocfs2_rec_clusters(el, &el->l_recs[i]);
>> - blkno = le64_to_cpu(el->l_recs[i].e_blkno);
>> + rec = &el->l_recs[i];
>> + flags = rec->e_flags;
>> + range = le32_to_cpu(rec->e_cpos) + ocfs2_rec_clusters(el, rec);
>> +
>> + if (i == 0 && ocfs2_is_empty_extent(rec)) {
>> + /*
>> + * Should remove this extent block.
>> + */
>> + trunc_cpos = le32_to_cpu(rec->e_cpos);
>> + trunc_len = 0;
>> + coff = 0;
>> + blkno = 0;
>> + } else if (le32_to_cpu(rec->e_cpos) >= new_highest_cpos) {
>> + /* + * Truncate entire record.
>> + */
>> + trunc_cpos = le32_to_cpu(rec->e_cpos);
>> + trunc_len = ocfs2_rec_clusters(el, rec);
>> + coff = 0;
>> + blkno = le64_to_cpu(rec->e_blkno);
>> } else if (range > new_highest_cpos) {
>> - clusters_to_del = (ocfs2_rec_clusters(el, &el->l_recs[i]) +
>> - le32_to_cpu(el->l_recs[i].e_cpos)) -
>> - new_highest_cpos;
>> - blkno = le64_to_cpu(el->l_recs[i].e_blkno) +
>> - ocfs2_clusters_to_blocks(inode->i_sb,
>> - ocfs2_rec_clusters(el, &el->l_recs[i]) -
>> - clusters_to_del);
>> + /*
>> + * Partial truncate. it also should be
>> + * the last truncate we're doing.
>> + */
>> + trunc_cpos = new_highest_cpos;
>> + trunc_len = range - new_highest_cpos;
>> + coff = new_highest_cpos - le32_to_cpu(rec->e_cpos);
>> + blkno = le64_to_cpu(rec->e_blkno) +
>> + ocfs2_clusters_to_blocks(inode->i_sb, coff);
> another reason you want to change clusters_to_del to trunc_len? The 
> calcuation is the same.

hehe, nothing fancy, they're absolutely the same, hmmm, the reason why I 
changed them may be it's more straightfoward to me


>> } else {
>> + /*
>> + * Truncate completed, leave happily.
>> + */
>> status = 0;
>> goto bail;
>> }
>>
>> - mlog(0, "clusters_to_del = %u in this pass, tail blk=%llu\n",
>> - clusters_to_del, (unsigned long long)path_leaf_bh(path)->b_blocknr);
>> + phys_cpos = ocfs2_blocks_to_clusters(inode->i_sb, blkno);
>>
>> - if (el->l_recs[i].e_flags & OCFS2_EXT_REFCOUNTED && clusters_to_del) {
>> + if (el->l_recs[i].e_flags & OCFS2_EXT_REFCOUNTED && trunc_len) {
>> BUG_ON(!(OCFS2_I(inode)->ip_dyn_features &
>> OCFS2_HAS_REFCOUNT_FL));
>>
>> @@ -7533,59 +7130,25 @@ start:
>>
>> status = ocfs2_prepare_refcount_change_for_del(inode, fe_bh,
>> blkno,
>> - clusters_to_del,
>> + trunc_len,
>> &credits,
>> - &meta_ac);
> As I said in the previous e-mail, we may add this function to the 
> ocfs2_remove_btree_range.
> And what's more, we don't need to fixing punching hole any more since 
> this function can handle refcount tree by itself.

Yes, it makes sense, so the only thing we need to do for fixing bug in 
punching holes is to COW when zeroing a partial cluster for now.



>> - if (status < 0) {
>> - mlog_errno(status);
>> - goto bail;
>> - }
>> - }
>> -
>> - mutex_lock(&tl_inode->i_mutex);
>> - tl_sem = 1;
>> - /* ocfs2_truncate_log_needs_flush guarantees us at least one
>> - * record is free for use. If there isn't any, we flush to get
>> - * an empty truncate log. */
>> - if (ocfs2_truncate_log_needs_flush(osb)) {
>> - status = __ocfs2_flush_truncate_log(osb);
>> + &ref_blocks);
>> if (status < 0) {
>> mlog_errno(status);
>> goto bail;
>> }
>> }
>>
>> - credits += ocfs2_calc_tree_trunc_credits(osb->sb, clusters_to_del,
>> - (struct ocfs2_dinode *)fe_bh->b_data,
>> - el);
>> - handle = ocfs2_start_trans(osb, credits);
>> - if (IS_ERR(handle)) {
>> - status = PTR_ERR(handle);
>> - handle = NULL;
>> - mlog_errno(status);
>> - goto bail;
>> - }
>> -
>> - status = ocfs2_do_truncate(osb, clusters_to_del, inode, fe_bh, handle,
>> - tc, path, meta_ac);
>> + status = ocfs2_remove_btree_range(inode, &et, trunc_cpos, phys_cpos,
>> + trunc_len, &dealloc, credits,
>> + ref_blocks, flags);
>> if (status < 0) {
>> mlog_errno(status);
>> goto bail;
>> }
>> -
>> - mutex_unlock(&tl_inode->i_mutex);
>> - tl_sem = 0;
>> -
>> - ocfs2_commit_trans(osb, handle);
>> - handle = NULL;
>> -
>> +
>> ocfs2_reinit_path(path, 1);
>>
>> - if (meta_ac) {
>> - ocfs2_free_alloc_context(meta_ac);
>> - meta_ac = NULL;
>> - }
>> -
>> if (ref_tree) {
>> ocfs2_unlock_refcount_tree(osb, ref_tree, 1);
>> ref_tree = NULL;
>> @@ -7598,28 +7161,15 @@ start:
>> goto start;
>>
>> bail:
>> -
>> ocfs2_schedule_truncate_log_flush(osb, 1);
>>
>> - if (tl_sem)
>> - mutex_unlock(&tl_inode->i_mutex);
>> -
>> - if (handle)
>> - ocfs2_commit_trans(osb, handle);
>> -
>> - if (meta_ac)
>> - ocfs2_free_alloc_context(meta_ac);
>> -
>> if (ref_tree)
>> ocfs2_unlock_refcount_tree(osb, ref_tree, 1);
>>
>> - ocfs2_run_deallocs(osb, &tc->tc_dealloc);
>> + ocfs2_run_deallocs(osb, &dealloc);
>>
>> ocfs2_free_path(path);
>>
>> - /* This will drop the ext_alloc cluster lock for us */
>> - ocfs2_free_truncate_context(tc);
>> -
> I would suggest you to separate the removal of tc and 
> ocfs2_prepare_truncate to another function since it has nothing to do 
> with this patch.

You mean remove this in another patch?


>
> Regards,
> Tao
