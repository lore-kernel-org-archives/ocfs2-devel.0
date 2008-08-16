From: TaoMa <tao.ma@oracle.com>
Date: Sat, 16 Aug 2008 18:40:00 +0800
Subject: [Ocfs2-devel] [PATCH 07/15] Add extent tree operation for xattr
 value.v3
In-Reply-To: <20080816021854.GA31499@mail.oracle.com>
References: <489A94F4.90903@oracle.com>
	<1218061894-7693-7-git-send-email-tao.ma@oracle.com>
	<20080816021854.GA31499@mail.oracle.com>
Message-ID: <48A6AE80.3040003@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Joel Becker wrote:
> On Thu, Aug 07, 2008 at 06:31:29AM +0800, Tao Ma wrote:
>   
>
>> @@ -495,7 +541,8 @@ struct ocfs2_merge_ctxt {
>>  int ocfs2_num_free_extents(struct ocfs2_super *osb,
>>  			   struct inode *inode,
>>  			   struct buffer_head *root_bh,
>> -			   enum ocfs2_extent_tree_type type)
>> +			   enum ocfs2_extent_tree_type type,
>> +			   void *private)
>>  {
>>  	int retval;
>>  	struct ocfs2_extent_list *el = NULL;
>> @@ -517,6 +564,12 @@ int ocfs2_num_free_extents(struct ocfs2_super *osb,
>>  		if (fe->i_last_eb_blk)
>>  			last_eb_blk = le64_to_cpu(fe->i_last_eb_blk);
>>  		el = &fe->id2.i_list;
>> +	} else if (type == OCFS2_XATTR_VALUE_EXTENT) {
>> +		struct ocfs2_xattr_value_root *xv =
>> +			(struct ocfs2_xattr_value_root *) private;
>> +
>> +		last_eb_blk = le64_to_cpu(xv->xr_last_eb_blk);
>> +		el = &xv->xr_list;
>>     
>
> 	Again, just to avoid the extent_tree object, you are
> hand-accessing the last_eb_block and el entries.  I really think you
> should be passing an *et into this function.
>   
You have mentioned this in your previous review. Thanks. :)
>   
>> -int ocfs2_insert_extent(struct ocfs2_super *osb,
>> -			handle_t *handle,
>> -			struct inode *inode,
>> -			struct buffer_head *root_bh,
>> -			u32 cpos,
>> -			u64 start_blk,
>> -			u32 new_clusters,
>> -			u8 flags,
>> -			struct ocfs2_alloc_context *meta_ac,
>> -			enum ocfs2_extent_tree_type et_type)
>> +static int ocfs2_insert_extent(struct ocfs2_super *osb,
>> +			       handle_t *handle,
>> +			       struct inode *inode,
>> +			       struct buffer_head *root_bh,
>> +			       u32 cpos,
>> +			       u64 start_blk,
>> +			       u32 new_clusters,
>> +			       u8 flags,
>> +			       struct ocfs2_alloc_context *meta_ac,
>> +			       struct ocfs2_extent_tree *et)
>>     
>
> 	Here you are passing in the et, so you don't need root_bh
> anymore, right
>
>   
>> @@ -4554,7 +4658,8 @@ int ocfs2_mark_extent_written(struct inode *inode, struct buffer_head *root_bh,
>>  			      handle_t *handle, u32 cpos, u32 len, u32 phys,
>>  			      struct ocfs2_alloc_context *meta_ac,
>>  			      struct ocfs2_cached_dealloc_ctxt *dealloc,
>> -			      enum ocfs2_extent_tree_type et_type)
>> +			      enum ocfs2_extent_tree_type et_type,
>> +			      void *private)
>>     
>
> 	Here again you're passing root_bh, et_type, and private.  Why
> not just pass in the et?
>   
All these are described in my previous e-mail: I'd like to limit 
ocfs2_extent_tree only in alloc.c so that other 
files(suballoc.c,file.c,dir.c,aops.c) don't need to know this structure 
and only give the parameter and I don't need to touch this structure 
everywhere. So is it object-oriented or am I misunderstand it? ;)
>   
>> diff --git a/fs/ocfs2/suballoc.c b/fs/ocfs2/suballoc.c
>> index d82a9a0..00d0fff 100644
>> --- a/fs/ocfs2/suballoc.c
>> +++ b/fs/ocfs2/suballoc.c
>> @@ -1906,7 +1906,8 @@ int ocfs2_lock_allocators(struct inode *inode, struct buffer_head *root_bh,
>>  			  struct ocfs2_extent_list *root_el,
>>  			  u32 clusters_to_add, u32 extents_to_split,
>>  			  struct ocfs2_alloc_context **data_ac,
>> -			  struct ocfs2_alloc_context **meta_ac)
>> +			  struct ocfs2_alloc_context **meta_ac,
>> +			  enum ocfs2_extent_tree_type type, void *private)
>>     
>
> 	Pass in a struct ocfs2_extent_list and you don't have to pass
> root_bh. root_el, type, or private.
>
>   
