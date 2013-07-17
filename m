From: Junxiao Bi <junxiao.bi@oracle.com>
Date: Wed, 17 Jul 2013 08:48:46 +0800
Subject: [Ocfs2-devel] [PATCH] ocfs2: using i_size_read() to access
	i_size
In-Reply-To: <51E4B86F.2040703@tao.ma>
References: <1373876172-6467-1-git-send-email-junxiao.bi@oracle.com>
	<51E4B86F.2040703@tao.ma>
Message-ID: <51E5E9EE.8040006@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi Tao,

On 07/16/2013 11:05 AM, Tao Ma wrote:
> Hi Junxiao,
> 	IIRC, in the case we use inode->i_size directly in ocfs2,
> inode->i_mutex is already locked, so no one can change i_size and it is
> safe.
Yes, but there are both inode->i_size and i_size_read/write() in the
code, I think we'd better change it to ease confuse.

Thanks,
Junxiao.
>
> Thanks,
> Tao
> On 07/15/2013 04:16 PM, Junxiao Bi wrote:
>> Signed-off-by: Junxiao Bi <junxiao.bi@oracle.com>
>> ---
>>  fs/ocfs2/aops.c         |    2 +-
>>  fs/ocfs2/extent_map.c   |   10 +++++-----
>>  fs/ocfs2/file.c         |    2 +-
>>  fs/ocfs2/ioctl.c        |    2 +-
>>  fs/ocfs2/journal.c      |    8 ++++----
>>  fs/ocfs2/move_extents.c |    2 +-
>>  fs/ocfs2/quota_global.c |    6 +++---
>>  fs/ocfs2/quota_local.c  |   12 ++++++------
>>  8 files changed, 22 insertions(+), 22 deletions(-)
>>
>> diff --git a/fs/ocfs2/aops.c b/fs/ocfs2/aops.c
>> index 20dfec7..ab3ebf3 100644
>> --- a/fs/ocfs2/aops.c
>> +++ b/fs/ocfs2/aops.c
>> @@ -2049,7 +2049,7 @@ int ocfs2_write_end_nolock(struct address_space *mapping,
>>  
>>  out_write_size:
>>  	pos += copied;
>> -	if (pos > inode->i_size) {
>> +	if (pos > i_size_read(inode)) {
>>  		i_size_write(inode, pos);
>>  		mark_inode_dirty(inode);
>>  	}
>> diff --git a/fs/ocfs2/extent_map.c b/fs/ocfs2/extent_map.c
>> index 2487116..4bf2b76 100644
>> --- a/fs/ocfs2/extent_map.c
>> +++ b/fs/ocfs2/extent_map.c
>> @@ -852,20 +852,20 @@ int ocfs2_seek_data_hole_offset(struct file *file, loff_t *offset, int whence)
>>  
>>  	down_read(&OCFS2_I(inode)->ip_alloc_sem);
>>  
>> -	if (*offset >= inode->i_size) {
>> +	if (*offset >= i_size_read(inode)) {
>>  		ret = -ENXIO;
>>  		goto out_unlock;
>>  	}
>>  
>>  	if (OCFS2_I(inode)->ip_dyn_features & OCFS2_INLINE_DATA_FL) {
>>  		if (whence == SEEK_HOLE)
>> -			*offset = inode->i_size;
>> +			*offset = i_size_read(inode);
>>  		goto out_unlock;
>>  	}
>>  
>>  	clen = 0;
>>  	cpos = *offset >> cs_bits;
>> -	cend = ocfs2_clusters_for_bytes(inode->i_sb, inode->i_size);
>> +	cend = ocfs2_clusters_for_bytes(inode->i_sb, i_size_read(inode));
>>  
>>  	while (cpos < cend && !is_last) {
>>  		ret = ocfs2_get_clusters_nocache(inode, di_bh, cpos, &hole_size,
>> @@ -904,8 +904,8 @@ int ocfs2_seek_data_hole_offset(struct file *file, loff_t *offset, int whence)
>>  		extlen = clen;
>>  		extlen <<=  cs_bits;
>>  
>> -		if ((extoff + extlen) > inode->i_size)
>> -			extlen = inode->i_size - extoff;
>> +		if ((extoff + extlen) > i_size_read(inode))
>> +			extlen = i_size_read(inode) - extoff;
>>  		extoff += extlen;
>>  		if (extoff > *offset)
>>  			*offset = extoff;
>> diff --git a/fs/ocfs2/file.c b/fs/ocfs2/file.c
>> index 3ce6a8b..7158710 100644
>> --- a/fs/ocfs2/file.c
>> +++ b/fs/ocfs2/file.c
>> @@ -2650,7 +2650,7 @@ static loff_t ocfs2_file_llseek(struct file *file, loff_t offset, int whence)
>>  	case SEEK_SET:
>>  		break;
>>  	case SEEK_END:
>> -		offset += inode->i_size;
>> +		offset += i_size_read(inode);
>>  		break;
>>  	case SEEK_CUR:
>>  		if (offset == 0) {
>> diff --git a/fs/ocfs2/ioctl.c b/fs/ocfs2/ioctl.c
>> index 0c60ef2..fa32ce9 100644
>> --- a/fs/ocfs2/ioctl.c
>> +++ b/fs/ocfs2/ioctl.c
>> @@ -303,7 +303,7 @@ int ocfs2_info_handle_journal_size(struct inode *inode,
>>  	if (o2info_from_user(oij, req))
>>  		goto bail;
>>  
>> -	oij.ij_journal_size = osb->journal->j_inode->i_size;
>> +	oij.ij_journal_size = i_size_read(osb->journal->j_inode);
>>  
>>  	o2info_set_request_filled(&oij.ij_req);
>>  
>> diff --git a/fs/ocfs2/journal.c b/fs/ocfs2/journal.c
>> index 8eccfab..b5c8c53 100644
>> --- a/fs/ocfs2/journal.c
>> +++ b/fs/ocfs2/journal.c
>> @@ -801,14 +801,14 @@ int ocfs2_journal_init(struct ocfs2_journal *journal, int *dirty)
>>  	inode_lock = 1;
>>  	di = (struct ocfs2_dinode *)bh->b_data;
>>  
>> -	if (inode->i_size <  OCFS2_MIN_JOURNAL_SIZE) {
>> +	if (i_size_read(inode) <  OCFS2_MIN_JOURNAL_SIZE) {
>>  		mlog(ML_ERROR, "Journal file size (%lld) is too small!\n",
>> -		     inode->i_size);
>> +		     i_size_read(inode));
>>  		status = -EINVAL;
>>  		goto done;
>>  	}
>>  
>> -	trace_ocfs2_journal_init(inode->i_size,
>> +	trace_ocfs2_journal_init(i_size_read(inode),
>>  				 (unsigned long long)inode->i_blocks,
>>  				 OCFS2_I(inode)->ip_clusters);
>>  
>> @@ -1096,7 +1096,7 @@ static int ocfs2_force_read_journal(struct inode *inode)
>>  
>>  	memset(bhs, 0, sizeof(struct buffer_head *) * CONCURRENT_JOURNAL_FILL);
>>  
>> -	num_blocks = ocfs2_blocks_for_bytes(inode->i_sb, inode->i_size);
>> +	num_blocks = ocfs2_blocks_for_bytes(inode->i_sb, i_size_read(inode));
>>  	v_blkno = 0;
>>  	while (v_blkno < num_blocks) {
>>  		status = ocfs2_extent_map_get_blocks(inode, v_blkno,
>> diff --git a/fs/ocfs2/move_extents.c b/fs/ocfs2/move_extents.c
>> index f1fc172..33472e4 100644
>> --- a/fs/ocfs2/move_extents.c
>> +++ b/fs/ocfs2/move_extents.c
>> @@ -845,7 +845,7 @@ static int __ocfs2_move_extents_range(struct buffer_head *di_bh,
>>  	struct ocfs2_move_extents *range = context->range;
>>  	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
>>  
>> -	if ((inode->i_size == 0) || (range->me_len == 0))
>> +	if ((i_size_read(inode) == 0) || (range->me_len == 0))
>>  		return 0;
>>  
>>  	if (OCFS2_I(inode)->ip_dyn_features & OCFS2_INLINE_DATA_FL)
>> diff --git a/fs/ocfs2/quota_global.c b/fs/ocfs2/quota_global.c
>> index 332a281..aaa5061 100644
>> --- a/fs/ocfs2/quota_global.c
>> +++ b/fs/ocfs2/quota_global.c
>> @@ -234,7 +234,7 @@ ssize_t ocfs2_quota_write(struct super_block *sb, int type,
>>  		len = sb->s_blocksize - OCFS2_QBLK_RESERVED_SPACE - offset;
>>  	}
>>  
>> -	if (gqinode->i_size < off + len) {
>> +	if (i_size_read(gqinode) < off + len) {
>>  		loff_t rounded_end =
>>  				ocfs2_align_bytes_to_blocks(sb, off + len);
>>  
>> @@ -778,8 +778,8 @@ static int ocfs2_acquire_dquot(struct dquot *dquot)
>>  		 */
>>  		WARN_ON(journal_current_handle());
>>  		status = ocfs2_extend_no_holes(gqinode, NULL,
>> -			gqinode->i_size + (need_alloc << sb->s_blocksize_bits),
>> -			gqinode->i_size);
>> +			i_size_read(gqinode) + (need_alloc << sb->s_blocksize_bits),
>> +			i_size_read(gqinode));
>>  		if (status < 0)
>>  			goto out_dq;
>>  	}
>> diff --git a/fs/ocfs2/quota_local.c b/fs/ocfs2/quota_local.c
>> index 27fe7ee..2e4344b 100644
>> --- a/fs/ocfs2/quota_local.c
>> +++ b/fs/ocfs2/quota_local.c
>> @@ -982,14 +982,14 @@ static struct ocfs2_quota_chunk *ocfs2_local_quota_add_chunk(
>>  
>>  	/* We are protected by dqio_sem so no locking needed */
>>  	status = ocfs2_extend_no_holes(lqinode, NULL,
>> -				       lqinode->i_size + 2 * sb->s_blocksize,
>> -				       lqinode->i_size);
>> +				       i_size_read(lqinode) + 2 * sb->s_blocksize,
>> +				       i_size_read(lqinode));
>>  	if (status < 0) {
>>  		mlog_errno(status);
>>  		goto out;
>>  	}
>>  	status = ocfs2_simple_size_update(lqinode, oinfo->dqi_lqi_bh,
>> -					  lqinode->i_size + 2 * sb->s_blocksize);
>> +					  i_size_read(lqinode) + 2 * sb->s_blocksize);
>>  	if (status < 0) {
>>  		mlog_errno(status);
>>  		goto out;
>> @@ -1125,14 +1125,14 @@ static struct ocfs2_quota_chunk *ocfs2_extend_local_quota_file(
>>  
>>  	/* We are protected by dqio_sem so no locking needed */
>>  	status = ocfs2_extend_no_holes(lqinode, NULL,
>> -				       lqinode->i_size + sb->s_blocksize,
>> -				       lqinode->i_size);
>> +				       i_size_read(lqinode) + sb->s_blocksize,
>> +				       i_size_read(lqinode));
>>  	if (status < 0) {
>>  		mlog_errno(status);
>>  		goto out;
>>  	}
>>  	status = ocfs2_simple_size_update(lqinode, oinfo->dqi_lqi_bh,
>> -					  lqinode->i_size + sb->s_blocksize);
>> +					  i_size_read(lqinode) + sb->s_blocksize);
>>  	if (status < 0) {
>>  		mlog_errno(status);
>>  		goto out;
>>
