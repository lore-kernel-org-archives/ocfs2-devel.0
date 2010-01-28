From: tristan <tristan.ye@oracle.com>
Date: Thu, 28 Jan 2010 14:52:04 +0800
Subject: [Ocfs2-devel] [PATCH 1/1] Ocfs2: Optimize truncting codes for
 ocfs2 to use ocfs2_remove_btree_range instead.
In-Reply-To: <4B613051.9090007@oracle.com>
References: <1264658048-32524-1-git-send-email-tristan.ye@oracle.com>
	<4B613051.9090007@oracle.com>
Message-ID: <4B613414.40404@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Tao Ma wrote:
> Tristan Ye wrote:
>> diff --git a/fs/ocfs2/alloc.c b/fs/ocfs2/alloc.c
>> index 38a42f5..e9f998e 100644
>> --- a/fs/ocfs2/alloc.c
>> +++ b/fs/ocfs2/alloc.c
>> @@ -5670,19 +5670,100 @@ out:
>> return ret;
>> }
> <snip>
>> int ocfs2_remove_btree_range(struct inode *inode,
>> struct ocfs2_extent_tree *et,
>> u32 cpos, u32 phys_cpos, u32 len,
>> - struct ocfs2_cached_dealloc_ctxt *dealloc)
>> + struct ocfs2_cached_dealloc_ctxt *dealloc,
>> + struct buffer_head *bh, int flags)
>> {
>> - int ret;
>> + int ret, credits = 0, extra_blocks = 0;
>> u64 phys_blkno = ocfs2_clusters_to_blocks(inode->i_sb, phys_cpos);
>> struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
>> struct inode *tl_inode = osb->osb_tl_inode;
>> + struct ocfs2_dinode *di = (struct ocfs2_dinode *) bh->b_data;
> oh, you can't do that. remove_btree_range is a generic function for 
> all the b-tree users. So how could you think a refcount tree have an 
> ocfs2_dinode to pass in? I just checked that you only use 
> di->i_refcount_loc, so please put it in directly.

Yes, you're right, it makes thing clearer. buffer_head here is just for 
refcount use, while refcount codes only use refcount_loc indeed, so it 
will be better
passing refcount_loc directly.

>> handle_t *handle;
>> +
> we don't need an extra line here.
>> struct ocfs2_alloc_context *meta_ac = NULL;
>> + struct ocfs2_refcount_tree *ref_tree = NULL;
>> +
>> + if (flags & OCFS2_EXT_REFCOUNTED && len) {
>> + BUG_ON(!(OCFS2_I(inode)->ip_dyn_features &
>> + OCFS2_HAS_REFCOUNT_FL));
>>
>> - ret = ocfs2_lock_allocators(inode, et, 0, 1, NULL, &meta_ac);
>> + ret = ocfs2_lock_refcount_tree(osb,
>> + le64_to_cpu(di->i_refcount_loc),
>> + 1, &ref_tree, NULL);
>> + if (ret) {
>> + mlog_errno(ret);
>> + goto out;
>> + }
>> +
>> + ret = ocfs2_prepare_refcount_change_for_del(inode, bh,
>> + phys_blkno,
>> + len,
>> + &credits,
>> + &extra_blocks);
> oh, I just see you pass bh into that function. So please pass in 
> refcount_loc also.

According to your comment, ocfs2_prepare_refcount_change_for_del() can 
be changed a bit to accept refcount_loc instead of a buffer_head.



>> + if (ret < 0) {
>> + mlog_errno(ret);
>> + goto out;
>> + }
>> + }
>> +
>> +
>> + ret = ocfs2_reserve_blocks_for_rec_trunc(inode, et, 1, &meta_ac,
>> + extra_blocks);
>> if (ret) {
>> mlog_errno(ret);
>> return ret;
>> @@ -5698,7 +5779,8 @@ int ocfs2_remove_btree_range(struct inode *inode,
>> }
>> }
>>
>> - handle = ocfs2_start_trans(osb, ocfs2_remove_extent_credits(osb->sb));
>> + handle = ocfs2_start_trans(osb,
>> + ocfs2_remove_extent_credits(osb->sb) + credits);
>> if (IS_ERR(handle)) {
>> ret = PTR_ERR(handle);
>> mlog_errno(ret);
> Regards,
> Tao
