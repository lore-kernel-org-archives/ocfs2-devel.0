From: tristan <tristan.ye@oracle.com>
Date: Fri, 05 Feb 2010 11:08:12 +0800
Subject: [Ocfs2-devel] [PATCH 1/3] Ocfs2: Optimize truncting codes for
 ocfs2 to use ocfs2_remove_btree_range instead.
In-Reply-To: <4B6B8145.7000203@oracle.com>
References: <1265282482-4915-1-git-send-email-tristan.ye@oracle.com>
	<4B6B8145.7000203@oracle.com>
Message-ID: <4B6B8B9C.6070807@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Tao Ma wrote:
>
>
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
>>
>> ocfs2_remove_btree_range() was originally used by punching holes 
>> codes, which didn't
>> take refcount into account(definitely it's a BUG), we therefore need 
>> to change that
>> func a bit to handle refcount treee lock, calculate and reserve block 
>> for refcount
>> tree changes, also decrease refcount at the end, to move these logics 
>> in, we needs
>> to replace the ocfs2_lock_allocators() by adding a new func 
>> ocfs2_reserve_blocks_for_rec_trunc()
>> which accepts some extra blocks to reserve. such changes will not 
>> hurt any other codes
>> who're using ocfs2_remove_btree_range(such as dir truncate and 
>> punching holes), actually
>> punching holes codes do benefit from this.
>>
>> I merge the following steps into one patch since they may be 
>> logically doing one thing,
>> Though I knew it looks a little bit fat to review.
>>
>> 1). Remove redundant codes used by ocfs2_commit_truncate before, 
>> since we're moving to
>>     ocfs2_remove_btree_range anyway.
>>
>> 2). Add a new func ocfs2_reserve_blocks_for_rec_trunc() for purpose 
>> of accepting  some
>>     extra blocks to reserve.
>>
>> 3). Change ocfs2_prepare_refcount_change_for_del() a bit to fit our 
>> needs, it's safe to
>>     do this since it's only being called by truncating codes.
>>
>> 4). Change ocfs2_remove_btree_range() a bit to take refcount case 
>> into account.
>>
>> 5). Finally, we change ocfs2_commit_truncate() to call 
>> ocfs2_remove_btree_range() in
>>     a proper way.
>>
>> The patch has been tested normally for sanity check, stress tests 
>> with heavier workload
>> will be expected.
>>
>> Based on this patch, our fixing to punching holes bug will be fairly 
>> easy.
>>
>> Signed-off-by: Tristan Ye <tristan.ye@oracle.com>
>> ---
>>  fs/ocfs2/alloc.c        |  695 
>> +++++++++++------------------------------------
>>  fs/ocfs2/alloc.h        |    6 +-
>>  fs/ocfs2/dir.c          |    2 +-
>>  fs/ocfs2/file.c         |   11 +-
>>  fs/ocfs2/inode.c        |    9 +-
>>  fs/ocfs2/refcounttree.c |   29 +--
>>  fs/ocfs2/refcounttree.h |    4 +-
>>  7 files changed, 177 insertions(+), 579 deletions(-)
>>
>> diff --git a/fs/ocfs2/alloc.c b/fs/ocfs2/alloc.c
>> index 38a42f5..b0689c1 100644
>> --- a/fs/ocfs2/alloc.c
>> +++ b/fs/ocfs2/alloc.c
>> @@ -5670,19 +5670,97 @@ out:
>>      return ret;
>>  }
>>  
>> +/*
>> + * ocfs2_reserve_blocks_for_rec_trunc() would look basically the
>> + * same as ocfs2_lock_alloctors(), except for it accepts a blocks
>> + * number to reserve some extra blocks, and it only handles meta
>> + * data allocations.
>> + *
>> + * Currently, only ocfs2_remove_btree_range() uses it for truncating
>> + * and punching holes.
>> + */
>> +static int ocfs2_reserve_blocks_for_rec_trunc(struct inode *inode,
>> +                          struct ocfs2_extent_tree *et,
>> +                          u32 extents_to_split,
>> +                          struct ocfs2_alloc_context **ac,
>> +                          int extra_blocks)
>> +{
>> +    int ret = 0, num_free_extents, blocks = extra_blocks;
>> +    unsigned int max_recs_needed = 2 * extents_to_split;
>> +    struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
>> +
>> +    *ac = NULL;
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
>> max_recs_needed))
>> +        blocks += ocfs2_extend_meta_needed(et->et_root_el);
>> +
>> +    if (blocks) {
>> +        ret = ocfs2_reserve_new_metadata_blocks(osb, blocks, ac);
>> +        if (ret < 0) {
>> +            if (ret != -ENOSPC)
>> +                mlog_errno(ret);
>> +            goto out;
>> +        }
>> +    }
>> +
>> +out:
>> +    if (ret) {
>> +        if (*ac) {
>> +            ocfs2_free_alloc_context(*ac);
>> +            *ac = NULL;
>> +        }
>> +    }
>> +
>> +    return ret;
>> +}
>> +
>>  int ocfs2_remove_btree_range(struct inode *inode,
>>                   struct ocfs2_extent_tree *et,
>>                   u32 cpos, u32 phys_cpos, u32 len,
>> -                 struct ocfs2_cached_dealloc_ctxt *dealloc)
>> +                 struct ocfs2_cached_dealloc_ctxt *dealloc,
>> +                 u64 refcount_loc, int flags)
>>  {
>> -    int ret;
>> +    int ret, credits = 0, extra_blocks = 0;
>>      u64 phys_blkno = ocfs2_clusters_to_blocks(inode->i_sb, phys_cpos);
>>      struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
>>      struct inode *tl_inode = osb->osb_tl_inode;
>>      handle_t *handle;
>>      struct ocfs2_alloc_context *meta_ac = NULL;
>> +    struct ocfs2_refcount_tree *ref_tree = NULL;
>> +
>> +    if (flags & OCFS2_EXT_REFCOUNTED && len) {
> As I have discussed with Joel and Mark recently, we need to put a 
> parenthesis around the check of & for readability although & is 
> precedent than &&. Check irc and my recent patch. 
> http://oss.oracle.com/pipermail/ocfs2-devel/2010-February/005822.html

Yes, I saw this:), make sense!


>> +        BUG_ON(!(OCFS2_I(inode)->ip_dyn_features &
>> +             OCFS2_HAS_REFCOUNT_FL));
>> +
>> +        ret = ocfs2_lock_refcount_tree(osb, refcount_loc, 1,
>> +                           &ref_tree, NULL);
>> +        if (ret) {
>> +            mlog_errno(ret);
>> +            goto out;
>> +        }
>> +
>> +        ret = ocfs2_prepare_refcount_change_for_del(inode,
>> +                                refcount_loc,
>> +                                phys_blkno,
>> +                                len,
>> +                                &credits,
>> +                                &extra_blocks);
>> +        if (ret < 0) {
>> +            mlog_errno(ret);
>> +            goto out;
>> +        }
>> +    }
>>  
>> -    ret = ocfs2_lock_allocators(inode, et, 0, 1, NULL, &meta_ac);
>> +    ret = ocfs2_reserve_blocks_for_rec_trunc(inode, et, 1, &meta_ac,
>> +                         extra_blocks);
>>      if (ret) {
>>          mlog_errno(ret);
>>          return ret;
>> @@ -5698,7 +5776,8 @@ int ocfs2_remove_btree_range(struct inode *inode,
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
>> @@ -5729,9 +5808,22 @@ int ocfs2_remove_btree_range(struct inode *inode,
>>          goto out_commit;
>>      }
>>  
>> -    ret = ocfs2_truncate_log_append(osb, handle, phys_blkno, len);
>> -    if (ret)
>> -        mlog_errno(ret);
>> +    if (phys_blkno) {
>> +        if (flags & OCFS2_EXT_REFCOUNTED) {
>> +            ret = ocfs2_decrease_refcount(inode, handle,
>> +                    ocfs2_blocks_to_clusters(osb->sb,
>> +                                 phys_blkno),
>> +                    len, meta_ac,
>> +                    dealloc, 1);
>> +        }
>> +
>> +        else
> I just noticed that you don't follow the code style here. We should do
> } else
> Check Linux coding style. And also please remove the above brackets.

Really? That's a typo..my fault.


>> +            ret = ocfs2_truncate_log_append(osb, handle,
>> +                            phys_blkno, len);
>> +        if (ret)
>> +            mlog_errno(ret);
>> +
>> +    }
>>  
>>  out_commit:
>>      ocfs2_commit_trans(osb, handle);
>> @@ -5741,6 +5833,9 @@ out:
>>      if (meta_ac)
>>          ocfs2_free_alloc_context(meta_ac);
>>  
>> +    if (ref_tree)
>> +        ocfs2_unlock_refcount_tree(osb, ref_tree, 1);
>> +
>>      return ret;
>>  }
>>  
>> @@ -7480,101 +7152,65 @@ start:
>>      }
>>  
>>      i = le16_to_cpu(el->l_next_free_rec) - 1;
>> -    range = le32_to_cpu(el->l_recs[i].e_cpos) +
>> -        ocfs2_rec_clusters(el, &el->l_recs[i]);
>> -    if (i == 0 && ocfs2_is_empty_extent(&el->l_recs[i])) {
>> -        clusters_to_del = 0;
>> -    } else if (le32_to_cpu(el->l_recs[i].e_cpos) >= new_highest_cpos) {
>> -        clusters_to_del = ocfs2_rec_clusters(el, &el->l_recs[i]);
>> -        blkno = le64_to_cpu(el->l_recs[i].e_blkno);
>> +    rec = &el->l_recs[i];
>> +    flags = rec->e_flags;
>> +    range = le32_to_cpu(rec->e_cpos) + ocfs2_rec_clusters(el, rec);
>> +
>> +    if (i == 0 && ocfs2_is_empty_extent(rec)) {
>> +        /*
>> +         * Lower levels depend on this never happening, but it's best
>> +         * to check it up here before changing the tree.
>> +        */
>> +        if (el->l_tree_depth && rec->e_int_clusters == 0) {
> You copied the code from ocfs2_do_truncate, that's ok, but the context 
> is wrong. el here is the path_leaf_el, so el->l_tree_depth is always 
> 0, the old ocfs2_do_truncate has el=&(fe->id2.i_list); so here you 
> need to use the root_el, not el. Be careful of the magic el. ;)

Great catch..


>> +            ocfs2_error(inode->i_sb, "Inode %lu has an empty "
>> +                    "extent record, depth %u\n", inode->i_ino,
>> +                    le16_to_cpu(el->l_tree_depth));
>> +            status = -EROFS;
>> +            goto bail;
>> +        }
>> +        /*
>> +         * Should remove this extent block.
>> +         */
> The comment isn't good any more since if it is an extent block, the 
> above check will go bail already.

Going to change this accordingly.

>> +        trunc_cpos = le32_to_cpu(rec->e_cpos);
>> +        trunc_len = 0;
>> +        blkno = 0;
>
> Regards,
> Tao
