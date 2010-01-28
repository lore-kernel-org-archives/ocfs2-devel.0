From: tristan <tristan.ye@oracle.com>
Date: Thu, 28 Jan 2010 10:17:46 +0800
Subject: [Ocfs2-devel] [PATCH 1/3] Ocfs2: Change
 ocfs2_remove_btree_range() a bit to consider refcount case.
In-Reply-To: <4B60BA80.1090508@oracle.com>
References: <1264591326-24591-1-git-send-email-tristan.ye@oracle.com>
	<4B60BA80.1090508@oracle.com>
Message-ID: <4B60F3CA.1020306@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Thanks for your so quick review:)

TaoMa wrote:
> Hi Tristan,
>    Thanks for the quick coding. Here are some comments.
> Tristan Ye wrote:
>> Truncating and punching holes codes need to take refcount into 
>> account when
>> removing a extent record, it has to decrease refcount on refcount tree.
>>
>> As in, credits and blocks reserved from allocator for refcount should 
>> be calculated
>> beforehand in caller who revokes ocfs2_remove_btree_range(), it will 
>> not hurt anyone
>> who're using this function, if you want an extra credits and reserved 
>> blocks be taken
>> into account, just pass in, otherwise, leave it as 0.
>>
>> Originally it's made for truncating codes who is being optimized to 
>> use ocfs2_remove_btree_range
>> for straightfoward purpose, our punching holes codes however, will 
>> also benenfit from this patch
>> as well.
>>
>> The patch also add a new func 
>> ocfs2_lock_allocator_with_extra_blocks() in suballoc.c,
>> which was almost the same as ocfs2_lock_allocators(), except it 
>> accepts some blocks
>> for extra use(e.g. we may need more blocks to reserve when truncating 
>> a file to consider
>> refcount case), and and it only handles meta data allocations, for 
>> now, it's only called
>> by ocfs2_remove_btree_range() to handle truncating and punching holes.
>>
>> Signed-off-by: Tristan Ye <tristan.ye@oracle.com>
>> ---
>>  fs/ocfs2/alloc.c    |   28 ++++++++++++++++++++++------
>>  fs/ocfs2/alloc.h    |    3 ++-
>>  fs/ocfs2/dir.c      |    2 +-
>>  fs/ocfs2/file.c     |    2 +-
>>  fs/ocfs2/suballoc.c |   51 
>> +++++++++++++++++++++++++++++++++++++++++++++++++++
>>  fs/ocfs2/suballoc.h |    6 ++++++
>>  6 files changed, 83 insertions(+), 9 deletions(-)
>>
>> diff --git a/fs/ocfs2/alloc.c b/fs/ocfs2/alloc.c
>> index 38a42f5..6c5f1de 100644
>> --- a/fs/ocfs2/alloc.c
>> +++ b/fs/ocfs2/alloc.c
>> @@ -5673,7 +5673,8 @@ out:
>>  int ocfs2_remove_btree_range(struct inode *inode,
>>                   struct ocfs2_extent_tree *et,
>>                   u32 cpos, u32 phys_cpos, u32 len,
>> -                 struct ocfs2_cached_dealloc_ctxt *dealloc)
>> +                 struct ocfs2_cached_dealloc_ctxt *dealloc,
>> +                 int credits, int extra_blocks, int flags)
>>  {
>>      int ret;
>>      u64 phys_blkno = ocfs2_clusters_to_blocks(inode->i_sb, phys_cpos);
>>   
> I just think that we should let this function handle the work of 
> lock/unlock refcount tree.
> It is a necessary part of ocfs2_remove_btree_range.  The caller should 
> knows nothing about
> whether the refcount tree need locked or not.

Make sense.


>> @@ -5682,7 +5683,8 @@ int ocfs2_remove_btree_range(struct inode *inode,
>>      handle_t *handle;
>>      struct ocfs2_alloc_context *meta_ac = NULL;
>>  
>> -    ret = ocfs2_lock_allocators(inode, et, 0, 1, NULL, &meta_ac);
>> +    ret = ocfs2_lock_allocator_with_extra_blocks(inode, et, 1,
>> +                             &meta_ac, extra_blocks);
>>      if (ret) {
>>          mlog_errno(ret);
>>          return ret;
>> @@ -5698,7 +5700,8 @@ int ocfs2_remove_btree_range(struct inode *inode,
>>          }
>>      }
>>  
>> -    handle = ocfs2_start_trans(osb, 
>> ocfs2_remove_extent_credits(osb->sb));
>> +    handle = ocfs2_start_trans(osb,
>> +            ocfs2_remove_extent_credits(osb->sb) + credits);
>>      if (IS_ERR(handle)) {
>>          ret = PTR_ERR(handle);
>>          mlog_errno(ret);
>> @@ -5729,9 +5732,22 @@ int ocfs2_remove_btree_range(struct inode *inode,
>>          goto out_commit;
>>      }
>>  
>> -    ret = ocfs2_truncate_log_append(osb, handle, phys_blkno, len);
>> -    if (ret)
>> -        mlog_errno(ret);
>> +    if (phys_blkno) {
>> +        if (flags & OCFS2_EXT_REFCOUNTED) {
>> +            ret = ocfs2_decrease_refcount(inode, handle,
>> +                                        
>> ocfs2_blocks_to_clusters(osb->sb,
>> +                                                                 
>> phys_blkno),
>> +                                        len, meta_ac,
>> +                                        dealloc, 1);
>> +        }
>> +
>> +        else
>> +            ret = ocfs2_truncate_log_append(osb, handle,
>> +                            phys_blkno, len);
>> +        if (ret)
>> +                        mlog_errno(ret );
>> +
>> +    }
>>  
>>  out_commit:
>>      ocfs2_commit_trans(osb, handle);
>> diff --git a/fs/ocfs2/alloc.h b/fs/ocfs2/alloc.h
>> index 9c122d5..483cdf1 100644
>> --- a/fs/ocfs2/alloc.h
>> +++ b/fs/ocfs2/alloc.h
>> @@ -141,7 +141,8 @@ int ocfs2_remove_extent(handle_t *handle, struct 
>> ocfs2_extent_tree *et,
>>  int ocfs2_remove_btree_range(struct inode *inode,
>>                   struct ocfs2_extent_tree *et,
>>                   u32 cpos, u32 phys_cpos, u32 len,
>> -                 struct ocfs2_cached_dealloc_ctxt *dealloc);
>> +                 struct ocfs2_cached_dealloc_ctxt *dealloc,
>> +                 int credits, int ref_blocks, int flags);
>>  
>>  int ocfs2_num_free_extents(struct ocfs2_super *osb,
>>                 struct ocfs2_extent_tree *et);
>> diff --git a/fs/ocfs2/dir.c b/fs/ocfs2/dir.c
>> index 28c3ec2..3aff1e1 100644
>> --- a/fs/ocfs2/dir.c
>> +++ b/fs/ocfs2/dir.c
>> @@ -4557,7 +4557,7 @@ int ocfs2_dx_dir_truncate(struct inode *dir, 
>> struct buffer_head *di_bh)
>>          p_cpos = ocfs2_blocks_to_clusters(dir->i_sb, blkno);
>>  
>>          ret = ocfs2_remove_btree_range(dir, &et, cpos, p_cpos, clen,
>> -                           &dealloc);
>> +                           &dealloc, 0, 0, 0);
>>          if (ret) {
>>              mlog_errno(ret);
>>              goto out;
>> diff --git a/fs/ocfs2/file.c b/fs/ocfs2/file.c
>> index 89fc8ee..3bebb3b 100644
>> --- a/fs/ocfs2/file.c
>> +++ b/fs/ocfs2/file.c
>> @@ -1499,7 +1499,7 @@ static int ocfs2_remove_inode_range(struct 
>> inode *inode,
>>          if (phys_cpos != 0) {
>>              ret = ocfs2_remove_btree_range(inode, &et, cpos,
>>                                 phys_cpos, alloc_size,
>> -                               &dealloc);
>> +                               &dealloc, 0, 0, 0);
>>              if (ret) {
>>                  mlog_errno(ret);
>>                  goto out;
>> diff --git a/fs/ocfs2/suballoc.c b/fs/ocfs2/suballoc.c
>> index c30b644..8bf4523 100644
>> --- a/fs/ocfs2/suballoc.c
>> +++ b/fs/ocfs2/suballoc.c
>> @@ -2208,6 +2208,57 @@ out:
>>  }
>>  
>>  /*
>> + * ocfs2_lock_allocator_with_extra_blocks() would look almost the
>> + * same as ocfs2_lock_alloctors(), except for it accepts a blocks
>> + * number to reserve some extra blocks, and it only handles meta
>> + * data allocations.
>> + *
>> + * Currently, only ocfs2_remove_btree_range() uses it for truncating
>> + * and punching holes.
>> + */
>> +int ocfs2_lock_allocator_with_extra_blocks(struct inode *inode,
>> +                       struct ocfs2_extent_tree *et,
>> +                       u32 extents_to_split,
>> +                       struct ocfs2_alloc_context **meta_ac,
>> +                       int extra_blocks)
>>   
> I am just curious about this function.
> So if you want to make it as a generic function, why you remove 
> another parameter clusters_to_add?
> On the other hand, if you only want it to be used in 
> ocfs2_remove_btree_range, why not remove extents_to_split also since 
> we know that function only works for one extent record?


The reason why I remove clusters_to_add is, this function only handles 
allocation reservation for metadata.


>> +{
>> +    int ret = 0, num_free_extents, blocks;
>> +    unsigned int max_recs_needed = 2 * extents_to_split;
>> +    struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
>> +
>> +    *meta_ac = NULL;
>> +
>> +    num_free_extents = ocfs2_num_free_extents(osb, et);
>> +    if (num_free_extents < 0) {
>> +        ret = num_free_extents;
>> +        mlog_errno(ret);
>> +        goto out;
>> +    }
>> +
>> +    if (!num_free_extents ||
>> +        (ocfs2_sparse_alloc(osb) && num_free_extents < 
>> max_recs_needed)) {
>> +        blocks = ocfs2_extend_meta_needed(et->et_root_el) +
>> +                extra_blocks;
>> +        ret = ocfs2_reserve_new_metadata_blocks(osb, blocks, meta_ac);
>> +        if (ret < 0) {
>> +            if (ret != -ENOSPC)
>> +                mlog_errno(ret);
>> +            goto out;
>> +        }
>> +    }
>>   
> here is a bug. You should calculate the 'blocks' in the 'if' while 
> call ocfs2_reserve_new_metadata_blocks after if.
> consider the case num_free_extents > 0 and extra_blocks > 0.
> In your code, we won't reserve new metadatas which is false.

Good catch!

>
> Regards,
> Tao
>
