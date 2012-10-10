From: Tiger Yang <tiger.yang@oracle.com>
Date: Wed, 10 Oct 2012 14:22:10 +0800
Subject: [Ocfs2-devel] [PATCH] ocfs2: fix NULL pointer dereference in
 ocfs2_duplicate_clusters_by_page
In-Reply-To: <50654CBC.3020406@tao.ma>
References: <1348815422-1868-1-git-send-email-tiger.yang@oracle.com>
	<50654CBC.3020406@tao.ma>
Message-ID: <50751412.3010908@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On 09/28/2012 03:07 PM, Tao Ma wrote:
> Hi Tiger,
> 	Interesting.
> 	why we never find it in the old reflink test? A little big strange.
> Could you please tell me the test case to trigger this issue?
just the reflink test in single_run-WIP.sh.
> Another thing I want to say is that now your patch removes all the
> readahead during CoW. Why? If you want to avoid the dereference of a
> NULL pointer, I guess just skip the call of ocfs2_readahead_for_cow if
> file = NULL should work?
thanks for review, I made v2 patch which add check of the pointer to fix 
this issue.

Thanks,
tiger
> Thanks
> Tao
> On 09/28/2012 02:57 PM, Tiger Yang wrote:
>> Since ocfs2_cow_file_pos will invoke ocfs2_refcount_cow with a NULL
>> as the struct file pointer, it finally result in a null pointer
>> dereference in ocfs2_duplicate_clusters_by_page.
>> This patch replace file pointer with inode pointer in
>> cow_duplicate_clusters to fix this issue.
>>
>> Signed-off-by: Tiger Yang<tiger.yang@oracle.com>
>> ---
>>   fs/ocfs2/aops.c         |    2 +-
>>   fs/ocfs2/file.c         |    6 ++--
>>   fs/ocfs2/move_extents.c |    2 +-
>>   fs/ocfs2/refcounttree.c |   53 +++++++---------------------------------------
>>   fs/ocfs2/refcounttree.h |    6 ++--
>>   5 files changed, 16 insertions(+), 53 deletions(-)
>>
>> diff --git a/fs/ocfs2/aops.c b/fs/ocfs2/aops.c
>> index 6577432..8cc8cad 100644
>> --- a/fs/ocfs2/aops.c
>> +++ b/fs/ocfs2/aops.c
>> @@ -1755,7 +1755,7 @@ try_again:
>>   		goto out;
>>   	} else if (ret == 1) {
>>   		clusters_need = wc->w_clen;
>> -		ret = ocfs2_refcount_cow(inode, filp, di_bh,
>> +		ret = ocfs2_refcount_cow(inode, di_bh,
>>   					 wc->w_cpos, wc->w_clen, UINT_MAX);
>>   		if (ret) {
>>   			mlog_errno(ret);
>> diff --git a/fs/ocfs2/file.c b/fs/ocfs2/file.c
>> index 46a1f6d..e26cd20 100644
>> --- a/fs/ocfs2/file.c
>> +++ b/fs/ocfs2/file.c
>> @@ -370,7 +370,7 @@ static int ocfs2_cow_file_pos(struct inode *inode,
>>   	if (!(ext_flags&  OCFS2_EXT_REFCOUNTED))
>>   		goto out;
>>
>> -	return ocfs2_refcount_cow(inode, NULL, fe_bh, cpos, 1, cpos+1);
>> +	return ocfs2_refcount_cow(inode, fe_bh, cpos, 1, cpos+1);
>>
>>   out:
>>   	return status;
>> @@ -899,7 +899,7 @@ static int ocfs2_zero_extend_get_range(struct inode *inode,
>>   		zero_clusters = last_cpos - zero_cpos;
>>
>>   	if (needs_cow) {
>> -		rc = ocfs2_refcount_cow(inode, NULL, di_bh, zero_cpos,
>> +		rc = ocfs2_refcount_cow(inode, di_bh, zero_cpos,
>>   					zero_clusters, UINT_MAX);
>>   		if (rc) {
>>   			mlog_errno(rc);
>> @@ -2097,7 +2097,7 @@ static int ocfs2_prepare_inode_for_refcount(struct inode *inode,
>>
>>   	*meta_level = 1;
>>
>> -	ret = ocfs2_refcount_cow(inode, file, di_bh, cpos, clusters, UINT_MAX);
>> +	ret = ocfs2_refcount_cow(inode, di_bh, cpos, clusters, UINT_MAX);
>>   	if (ret)
>>   		mlog_errno(ret);
>>   out:
>> diff --git a/fs/ocfs2/move_extents.c b/fs/ocfs2/move_extents.c
>> index 6083432..8519926 100644
>> --- a/fs/ocfs2/move_extents.c
>> +++ b/fs/ocfs2/move_extents.c
>> @@ -69,7 +69,7 @@ static int __ocfs2_move_extent(handle_t *handle,
>>   	u64 ino = ocfs2_metadata_cache_owner(context->et.et_ci);
>>   	u64 old_blkno = ocfs2_clusters_to_blocks(inode->i_sb, p_cpos);
>>
>> -	ret = ocfs2_duplicate_clusters_by_page(handle, context->file, cpos,
>> +	ret = ocfs2_duplicate_clusters_by_page(handle, inode, cpos,
>>   					       p_cpos, new_p_cpos, len);
>>   	if (ret) {
>>   		mlog_errno(ret);
>> diff --git a/fs/ocfs2/refcounttree.c b/fs/ocfs2/refcounttree.c
>> index 30a0550..2d1bb91 100644
>> --- a/fs/ocfs2/refcounttree.c
>> +++ b/fs/ocfs2/refcounttree.c
>> @@ -49,7 +49,6 @@
>>
>>   struct ocfs2_cow_context {
>>   	struct inode *inode;
>> -	struct file *file;
>>   	u32 cow_start;
>>   	u32 cow_len;
>>   	struct ocfs2_extent_tree data_et;
>> @@ -66,7 +65,7 @@ struct ocfs2_cow_context {
>>   			    u32 *num_clusters,
>>   			    unsigned int *extent_flags);
>>   	int (*cow_duplicate_clusters)(handle_t *handle,
>> -				      struct file *file,
>> +				      struct inode *inode,
>>   				      u32 cpos, u32 old_cluster,
>>   				      u32 new_cluster, u32 new_len);
>>   };
>> @@ -2922,14 +2921,12 @@ static int ocfs2_clear_cow_buffer(handle_t *handle, struct buffer_head *bh)
>>   }
>>
>>   int ocfs2_duplicate_clusters_by_page(handle_t *handle,
>> -				     struct file *file,
>> +				     struct inode *inode,
>>   				     u32 cpos, u32 old_cluster,
>>   				     u32 new_cluster, u32 new_len)
>>   {
>>   	int ret = 0, partial;
>> -	struct inode *inode = file->f_path.dentry->d_inode;
>> -	struct ocfs2_caching_info *ci = INODE_CACHE(inode);
>> -	struct super_block *sb = ocfs2_metadata_cache_get_super(ci);
>> +	struct super_block *sb = inode->i_sb;
>>   	u64 new_block = ocfs2_clusters_to_blocks(sb, new_cluster);
>>   	struct page *page;
>>   	pgoff_t page_index;
>> @@ -2973,13 +2970,6 @@ int ocfs2_duplicate_clusters_by_page(handle_t *handle,
>>   		if (PAGE_CACHE_SIZE<= OCFS2_SB(sb)->s_clustersize)
>>   			BUG_ON(PageDirty(page));
>>
>> -		if (PageReadahead(page)) {
>> -			page_cache_async_readahead(mapping,
>> -						&file->f_ra, file,
>> -						   page, page_index,
>> -						   readahead_pages);
>> -		}
>> -
>>   		if (!PageUptodate(page)) {
>>   			ret = block_read_full_page(page, ocfs2_get_block);
>>   			if (ret) {
>> @@ -2999,7 +2989,8 @@ int ocfs2_duplicate_clusters_by_page(handle_t *handle,
>>   			}
>>   		}
>>
>> -		ocfs2_map_and_dirty_page(inode, handle, from, to,
>> +		ocfs2_map_and_dirty_page(inode,
>> +					 handle, from, to,
>>   					 page, 0,&new_block);
>>   		mark_page_accessed(page);
>>   unlock:
>> @@ -3015,12 +3006,11 @@ unlock:
>>   }
>>
>>   int ocfs2_duplicate_clusters_by_jbd(handle_t *handle,
>> -				    struct file *file,
>> +				    struct inode *inode,
>>   				    u32 cpos, u32 old_cluster,
>>   				    u32 new_cluster, u32 new_len)
>>   {
>>   	int ret = 0;
>> -	struct inode *inode = file->f_path.dentry->d_inode;
>>   	struct super_block *sb = inode->i_sb;
>>   	struct ocfs2_caching_info *ci = INODE_CACHE(inode);
>>   	int i, blocks = ocfs2_clusters_to_blocks(sb, new_len);
>> @@ -3145,7 +3135,7 @@ static int ocfs2_replace_clusters(handle_t *handle,
>>
>>   	/*If the old clusters is unwritten, no need to duplicate. */
>>   	if (!(ext_flags&  OCFS2_EXT_UNWRITTEN)) {
>> -		ret = context->cow_duplicate_clusters(handle, context->file,
>> +		ret = context->cow_duplicate_clusters(handle, context->inode,
>>   						      cpos, old, new, len);
>>   		if (ret) {
>>   			mlog_errno(ret);
>> @@ -3423,35 +3413,12 @@ static int ocfs2_replace_cow(struct ocfs2_cow_context *context)
>>   	return ret;
>>   }
>>
>> -static void ocfs2_readahead_for_cow(struct inode *inode,
>> -				    struct file *file,
>> -				    u32 start, u32 len)
>> -{
>> -	struct address_space *mapping;
>> -	pgoff_t index;
>> -	unsigned long num_pages;
>> -	int cs_bits = OCFS2_SB(inode->i_sb)->s_clustersize_bits;
>> -
>> -	if (!file)
>> -		return;
>> -
>> -	mapping = file->f_mapping;
>> -	num_pages = (len<<  cs_bits)>>  PAGE_CACHE_SHIFT;
>> -	if (!num_pages)
>> -		num_pages = 1;
>> -
>> -	index = ((loff_t)start<<  cs_bits)>>  PAGE_CACHE_SHIFT;
>> -	page_cache_sync_readahead(mapping,&file->f_ra, file,
>> -				  index, num_pages);
>> -}
>> -
>>   /*
>>    * Starting at cpos, try to CoW write_len clusters.  Don't CoW
>>    * past max_cpos.  This will stop when it runs into a hole or an
>>    * unrefcounted extent.
>>    */
>>   static int ocfs2_refcount_cow_hunk(struct inode *inode,
>> -				   struct file *file,
>>   				   struct buffer_head *di_bh,
>>   				   u32 cpos, u32 write_len, u32 max_cpos)
>>   {
>> @@ -3480,8 +3447,6 @@ static int ocfs2_refcount_cow_hunk(struct inode *inode,
>>
>>   	BUG_ON(cow_len == 0);
>>
>> -	ocfs2_readahead_for_cow(inode, file, cow_start, cow_len);
>> -
>>   	context = kzalloc(sizeof(struct ocfs2_cow_context), GFP_NOFS);
>>   	if (!context) {
>>   		ret = -ENOMEM;
>> @@ -3503,7 +3468,6 @@ static int ocfs2_refcount_cow_hunk(struct inode *inode,
>>   	context->ref_root_bh = ref_root_bh;
>>   	context->cow_duplicate_clusters = ocfs2_duplicate_clusters_by_page;
>>   	context->get_clusters = ocfs2_di_get_clusters;
>> -	context->file = file;
>>
>>   	ocfs2_init_dinode_extent_tree(&context->data_et,
>>   				      INODE_CACHE(inode), di_bh);
>> @@ -3532,7 +3496,6 @@ out:
>>    * clusters between cpos and cpos+write_len are safe to modify.
>>    */
>>   int ocfs2_refcount_cow(struct inode *inode,
>> -		       struct file *file,
>>   		       struct buffer_head *di_bh,
>>   		       u32 cpos, u32 write_len, u32 max_cpos)
>>   {
>> @@ -3552,7 +3515,7 @@ int ocfs2_refcount_cow(struct inode *inode,
>>   			num_clusters = write_len;
>>
>>   		if (ext_flags&  OCFS2_EXT_REFCOUNTED) {
>> -			ret = ocfs2_refcount_cow_hunk(inode, file, di_bh, cpos,
>> +			ret = ocfs2_refcount_cow_hunk(inode, di_bh, cpos,
>>   						      num_clusters, max_cpos);
>>   			if (ret) {
>>   				mlog_errno(ret);
>> diff --git a/fs/ocfs2/refcounttree.h b/fs/ocfs2/refcounttree.h
>> index 7754608..6422bbc 100644
>> --- a/fs/ocfs2/refcounttree.h
>> +++ b/fs/ocfs2/refcounttree.h
>> @@ -53,7 +53,7 @@ int ocfs2_prepare_refcount_change_for_del(struct inode *inode,
>>   					  int *credits,
>>   					  int *ref_blocks);
>>   int ocfs2_refcount_cow(struct inode *inode,
>> -		       struct file *filep, struct buffer_head *di_bh,
>> +		       struct buffer_head *di_bh,
>>   		       u32 cpos, u32 write_len, u32 max_cpos);
>>
>>   typedef int (ocfs2_post_refcount_func)(struct inode *inode,
>> @@ -85,11 +85,11 @@ int ocfs2_refcount_cow_xattr(struct inode *inode,
>>   			     u32 cpos, u32 write_len,
>>   			     struct ocfs2_post_refcount *post);
>>   int ocfs2_duplicate_clusters_by_page(handle_t *handle,
>> -				     struct file *file,
>> +				     struct inode *inode,
>>   				     u32 cpos, u32 old_cluster,
>>   				     u32 new_cluster, u32 new_len);
>>   int ocfs2_duplicate_clusters_by_jbd(handle_t *handle,
>> -				    struct file *file,
>> +				    struct inode *inode,
>>   				    u32 cpos, u32 old_cluster,
>>   				    u32 new_cluster, u32 new_len);
>>   int ocfs2_cow_sync_writeback(struct super_block *sb,
>>
