From: Joseph Qi <joseph.qi@huawei.com>
Date: Mon, 16 Sep 2013 19:42:14 +0800
Subject: [Ocfs2-devel] [PATCH RESEND 1/2] ocfs2: return ENOMEM while
 sb_getblk failing
In-Reply-To: <20130906164446.GX31381@wotan.suse.de>
References: <1378369735-12168-1-git-send-email-rui.xiang@huawei.com>
	<20130906164446.GX31381@wotan.suse.de>
Message-ID: <5236EE96.2070205@huawei.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On 2013/9/7 0:44, Mark Fasheh wrote:
> This looks great, thank you.
> 
> Reviewed-by: Mark Fasheh <mfasheh@suse.de>
> 
> On Thu, Sep 05, 2013 at 04:28:54PM +0800, Rui Xiang wrote:
>> The only reason for sb_getblk() failing is if it can't allocate
>> the buffer_head. So return ENOMEM instead when it fails.
>>
>> Signed-off-by: Rui Xiang <rui.xiang@huawei.com>
>> Reviewed-by: Jie Liu <jeff.liu@oracle.com>
>> ---
>>  fs/ocfs2/alloc.c        | 2 +-
>>  fs/ocfs2/dir.c          | 8 ++++----
>>  fs/ocfs2/namei.c        | 2 +-
>>  fs/ocfs2/refcounttree.c | 6 +++---
>>  fs/ocfs2/suballoc.c     | 4 ++--
>>  fs/ocfs2/super.c        | 4 ++--
>>  fs/ocfs2/xattr.c        | 2 +-
>>  7 files changed, 14 insertions(+), 14 deletions(-)
>>
>> diff --git a/fs/ocfs2/alloc.c b/fs/ocfs2/alloc.c
>> index 17e6bdd..dc7411f 100644
>> --- a/fs/ocfs2/alloc.c
>> +++ b/fs/ocfs2/alloc.c
>> @@ -1025,7 +1025,7 @@ static int ocfs2_create_new_meta_bhs(handle_t *handle,
>>  		for(i = count;  i < (num_got + count); i++) {
>>  			bhs[i] = sb_getblk(osb->sb, first_blkno);
>>  			if (bhs[i] == NULL) {
>> -				status = -EIO;
>> +				status = -ENOMEM;
>>  				mlog_errno(status);
>>  				goto bail;
>>  			}
>> diff --git a/fs/ocfs2/dir.c b/fs/ocfs2/dir.c
>> index 30544ce..5354743 100644
>> --- a/fs/ocfs2/dir.c
>> +++ b/fs/ocfs2/dir.c
>> @@ -2349,7 +2349,7 @@ static int ocfs2_dx_dir_attach_index(struct ocfs2_super *osb,
>>  
>>  	dx_root_bh = sb_getblk(osb->sb, dr_blkno);
>>  	if (dx_root_bh == NULL) {
>> -		ret = -EIO;
>> +		ret = -ENOMEM;
>>  		goto out;
>>  	}
>>  	ocfs2_set_new_buffer_uptodate(INODE_CACHE(dir), dx_root_bh);
>> @@ -2422,7 +2422,7 @@ static int ocfs2_dx_dir_format_cluster(struct ocfs2_super *osb,
>>  	for (i = 0; i < num_dx_leaves; i++) {
>>  		bh = sb_getblk(osb->sb, start_blk + i);
>>  		if (bh == NULL) {
>> -			ret = -EIO;
>> +			ret = -ENOMEM;
>>  			goto out;
>>  		}
>>  		dx_leaves[i] = bh;
>> @@ -2929,7 +2929,7 @@ static int ocfs2_expand_inline_dir(struct inode *dir, struct buffer_head *di_bh,
>>  	blkno = ocfs2_clusters_to_blocks(dir->i_sb, bit_off);
>>  	dirdata_bh = sb_getblk(sb, blkno);
>>  	if (!dirdata_bh) {
>> -		ret = -EIO;
>> +		ret = -ENOMEM;
>>  		mlog_errno(ret);
>>  		goto out_commit;
>>  	}
>> @@ -3159,7 +3159,7 @@ static int ocfs2_do_extend_dir(struct super_block *sb,
>>  
>>  	*new_bh = sb_getblk(sb, p_blkno);
>>  	if (!*new_bh) {
>> -		status = -EIO;
>> +		status = -ENOMEM;
>>  		mlog_errno(status);
>>  		goto bail;
>>  	}
>> diff --git a/fs/ocfs2/namei.c b/fs/ocfs2/namei.c
>> index be3f867..4f791f6 100644
>> --- a/fs/ocfs2/namei.c
>> +++ b/fs/ocfs2/namei.c
>> @@ -489,7 +489,7 @@ static int __ocfs2_mknod_locked(struct inode *dir,
>>  
>>  	*new_fe_bh = sb_getblk(osb->sb, fe_blkno);
>>  	if (!*new_fe_bh) {
>> -		status = -EIO;
>> +		status = -ENOMEM;
>>  		mlog_errno(status);
>>  		goto leave;
>>  	}
>> diff --git a/fs/ocfs2/refcounttree.c b/fs/ocfs2/refcounttree.c
>> index a70d604..50c1796 100644
>> --- a/fs/ocfs2/refcounttree.c
>> +++ b/fs/ocfs2/refcounttree.c
>> @@ -1310,7 +1310,7 @@ static int ocfs2_expand_inline_ref_root(handle_t *handle,
>>  
>>  	new_bh = sb_getblk(sb, blkno);
>>  	if (new_bh == NULL) {
>> -		ret = -EIO;
>> +		ret = -ENOMEM;
>>  		mlog_errno(ret);
>>  		goto out;
>>  	}
>> @@ -1561,7 +1561,7 @@ static int ocfs2_new_leaf_refcount_block(handle_t *handle,
>>  
>>  	new_bh = sb_getblk(sb, blkno);
>>  	if (new_bh == NULL) {
>> -		ret = -EIO;
>> +		ret = -ENOMEM;
>>  		mlog_errno(ret);
>>  		goto out;
>>  	}
>> @@ -3031,7 +3031,7 @@ int ocfs2_duplicate_clusters_by_jbd(handle_t *handle,
>>  	for (i = 0; i < blocks; i++, old_block++, new_block++) {
>>  		new_bh = sb_getblk(osb->sb, new_block);
>>  		if (new_bh == NULL) {
>> -			ret = -EIO;
>> +			ret = -ENOMEM;
>>  			mlog_errno(ret);
>>  			break;
>>  		}
>> diff --git a/fs/ocfs2/suballoc.c b/fs/ocfs2/suballoc.c
>> index 5397c07..2c91452 100644
>> --- a/fs/ocfs2/suballoc.c
>> +++ b/fs/ocfs2/suballoc.c
>> @@ -481,7 +481,7 @@ ocfs2_block_group_alloc_contig(struct ocfs2_super *osb, handle_t *handle,
>>  
>>  	bg_bh = sb_getblk(osb->sb, bg_blkno);
>>  	if (!bg_bh) {
>> -		status = -EIO;
>> +		status = -ENOMEM;
>>  		mlog_errno(status);
>>  		goto bail;
>>  	}
>> @@ -661,7 +661,7 @@ ocfs2_block_group_alloc_discontig(handle_t *handle,
>>  
>>  	bg_bh = sb_getblk(osb->sb, bg_blkno);
>>  	if (!bg_bh) {
>> -		status = -EIO;
>> +		status = -ENOMEM;
>>  		mlog_errno(status);
>>  		goto bail;
>>  	}
>> diff --git a/fs/ocfs2/super.c b/fs/ocfs2/super.c
>> index 121da2d..cac4987 100644
>> --- a/fs/ocfs2/super.c
>> +++ b/fs/ocfs2/super.c
>> @@ -1848,8 +1848,8 @@ static int ocfs2_get_sector(struct super_block *sb,
>>  
>>  	*bh = sb_getblk(sb, block);
>>  	if (!*bh) {
>> -		mlog_errno(-EIO);
>> -		return -EIO;
>> +		mlog_errno(-ENOMEM);
>> +		return -ENOMEM;
>>  	}
>>  	lock_buffer(*bh);
>>  	if (!buffer_dirty(*bh))
>> diff --git a/fs/ocfs2/xattr.c b/fs/ocfs2/xattr.c
>> index 317ef0a..e8b41e1 100644
>> --- a/fs/ocfs2/xattr.c
>> +++ b/fs/ocfs2/xattr.c
>> @@ -377,7 +377,7 @@ static int ocfs2_init_xattr_bucket(struct ocfs2_xattr_bucket *bucket,
>>  		bucket->bu_bhs[i] = sb_getblk(bucket->bu_inode->i_sb,
>>  					      xb_blkno + i);
>>  		if (!bucket->bu_bhs[i]) {
>> -			rc = -EIO;
>> +			rc = -ENOMEM;
>>  			mlog_errno(rc);
>>  			break;
>>  		}
>> -- 
>> 1.8.2.2
>>
>>
> --
> Mark Fasheh
> 
> _______________________________________________
> Ocfs2-devel mailing list
> Ocfs2-devel at oss.oracle.com
> https://oss.oracle.com/mailman/listinfo/ocfs2-devel
> 
> .
> 

ocfs2_symlink_get_block in aops.c, and ocfs2_read_blocks_sync and
ocfs2_read_blocks in buffer_head_io.c need do the same change for
consistency.

diff --git a/fs/ocfs2/aops.c b/fs/ocfs2/aops.c
index 20dfec7..b9ed571 100644
--- a/fs/ocfs2/aops.c
+++ b/fs/ocfs2/aops.c
@@ -92,6 +92,7 @@ static int ocfs2_symlink_get_block(struct inode *inode, sector_t iblock,
 			    iblock;
 		buffer_cache_bh = sb_getblk(osb->sb, blkno);
 		if (!buffer_cache_bh) {
+			err = -ENOMEM;
 			mlog(ML_ERROR, "couldn't getblock for symlink!\n");
 			goto bail;
 		}
diff --git a/fs/ocfs2/buffer_head_io.c b/fs/ocfs2/buffer_head_io.c
index 5d18ad1..5b704c6 100644
--- a/fs/ocfs2/buffer_head_io.c
+++ b/fs/ocfs2/buffer_head_io.c
@@ -115,7 +115,7 @@ int ocfs2_read_blocks_sync(struct ocfs2_super *osb, u64 block,
 		if (bhs[i] == NULL) {
 			bhs[i] = sb_getblk(osb->sb, block++);
 			if (bhs[i] == NULL) {
-				status = -EIO;
+				status = -ENOMEM;
 				mlog_errno(status);
 				goto bail;
 			}
@@ -214,7 +214,7 @@ int ocfs2_read_blocks(struct ocfs2_caching_info *ci, u64 block, int nr,
 			bhs[i] = sb_getblk(sb, block++);
 			if (bhs[i] == NULL) {
 				ocfs2_metadata_cache_io_unlock(ci);
-				status = -EIO;
+				status = -ENOMEM;
 				mlog_errno(status);
 				goto bail;
 			}
