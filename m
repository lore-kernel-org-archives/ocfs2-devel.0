From: Jan Kara <jack@suse.cz>
Date: Tue, 25 Nov 2008 12:20:30 +0100
Subject: [Ocfs2-devel] [PATCH] ocfs2: Fix ocfs2_read_quota_block() error
	handling.
In-Reply-To: <20081125021632.GA6361@mail.oracle.com>
References: <20081125021632.GA6361@mail.oracle.com>
Message-ID: <20081125112030.GB460@duck.suse.cz>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

  Hi,

On Mon 24-11-08 18:16:32, Joel Becker wrote:
> ocfs2_bread() has become ocfs2_read_virt_blocks(), with a prototype to
> match ocfs2_read_blocks().  The quota code, converting from
> ocfs2_bread(), wraps the call to ocfs2_read_virt_blocks() in
> ocfs2_read_quota_block().  Unfortunately, the prototype of
> ocfs2_read_quota_block() matches the old prototype of ocfs2_bread().
> 
> The problem is that ocfs2_bread() returned the buffer head, and callers
> assumed that a NULL pointer was indicative of error.  It wasn't.  This
> is why ocfs2_bread() took an int*err argument as well.
> 
> The new prototype of ocfs2_read_virt_blocks() avoids this error handling
> confusion.  Let's change ocfs2_read_quota_block() to match.
> 
> Signed-off-by: Joel Becker <joel.becker@oracle.com>
  OK, thanks. Tha patch looks fine.

  Acked-by: Jan Kara <jack@suse.cz>

									Honza
> ---
>  fs/ocfs2/dlmglue.c      |    6 ++--
>  fs/ocfs2/quota.h        |    4 +-
>  fs/ocfs2/quota_global.c |   34 ++++++++++++++----------
>  fs/ocfs2/quota_local.c  |   64 +++++++++++++++++++++++++---------------------
>  4 files changed, 60 insertions(+), 48 deletions(-)
> 
> diff --git a/fs/ocfs2/dlmglue.c b/fs/ocfs2/dlmglue.c
> index 095dc37..c479fb7 100644
> --- a/fs/ocfs2/dlmglue.c
> +++ b/fs/ocfs2/dlmglue.c
> @@ -3520,7 +3520,7 @@ static int ocfs2_refresh_qinfo(struct ocfs2_mem_dqinfo *oinfo)
>  					    oinfo->dqi_gi.dqi_type);
>  	struct ocfs2_lock_res *lockres = &oinfo->dqi_gqlock;
>  	struct ocfs2_qinfo_lvb *lvb = ocfs2_dlm_lvb(&lockres->l_lksb);
> -	struct buffer_head *bh;
> +	struct buffer_head *bh = NULL;
>  	struct ocfs2_global_disk_dqinfo *gdinfo;
>  	int status = 0;
>  
> @@ -3533,8 +3533,8 @@ static int ocfs2_refresh_qinfo(struct ocfs2_mem_dqinfo *oinfo)
>  		oinfo->dqi_gi.dqi_free_entry =
>  					be32_to_cpu(lvb->lvb_free_entry);
>  	} else {
> -		bh = ocfs2_read_quota_block(oinfo->dqi_gqinode, 0, &status);
> -		if (!bh) {
> +		status = ocfs2_read_quota_block(oinfo->dqi_gqinode, 0, &bh);
> +		if (status) {
>  			mlog_errno(status);
>  			goto bail;
>  		}
> diff --git a/fs/ocfs2/quota.h b/fs/ocfs2/quota.h
> index 84c50a1..abf6941 100644
> --- a/fs/ocfs2/quota.h
> +++ b/fs/ocfs2/quota.h
> @@ -108,8 +108,8 @@ static inline int ocfs2_global_release_dquot(struct dquot *dquot)
>  
>  int ocfs2_lock_global_qf(struct ocfs2_mem_dqinfo *oinfo, int ex);
>  void ocfs2_unlock_global_qf(struct ocfs2_mem_dqinfo *oinfo, int ex);
> -struct buffer_head *ocfs2_read_quota_block(struct inode *inode,
> -					   int block, int *err);
> +int ocfs2_read_quota_block(struct inode *inode, u64 v_block,
> +			   struct buffer_head **bh);
>  
>  extern struct dquot_operations ocfs2_quota_operations;
>  extern struct quota_format_type ocfs2_quota_format;
> diff --git a/fs/ocfs2/quota_global.c b/fs/ocfs2/quota_global.c
> index d2a5bfa..bc4b3f1 100644
> --- a/fs/ocfs2/quota_global.c
> +++ b/fs/ocfs2/quota_global.c
> @@ -85,16 +85,21 @@ struct qtree_fmt_operations ocfs2_global_ops = {
>  	.is_id = ocfs2_global_is_id,
>  };
>  
> -struct buffer_head *ocfs2_read_quota_block(struct inode *inode,
> -					   int block, int *err)
> +int ocfs2_read_quota_block(struct inode *inode, u64 v_block,
> +			   struct buffer_head **bh)
>  {
> -	struct buffer_head *tmp = NULL;
> +	int rc = 0;
> +	struct buffer_head *tmp = *bh;
>  
> -	*err = ocfs2_read_virt_blocks(inode, block, 1, &tmp, 0, NULL);
> -	if (*err)
> -		mlog_errno(*err);
> +	rc = ocfs2_read_virt_blocks(inode, v_block, 1, &tmp, 0, NULL);
> +	if (rc)
> +		mlog_errno(rc);
> +
> +	/* If ocfs2_read_virt_blocks() got us a new bh, pass it up. */
> +	if (!rc && !*bh)
> +		*bh = tmp;
>  
> -	return tmp;
> +	return rc;
>  }
>  
>  static struct buffer_head *ocfs2_get_quota_block(struct inode *inode,
> @@ -141,8 +146,9 @@ ssize_t ocfs2_quota_read(struct super_block *sb, int type, char *data,
>  	toread = len;
>  	while (toread > 0) {
>  		tocopy = min((size_t)(sb->s_blocksize - offset), toread);
> -		bh = ocfs2_read_quota_block(gqinode, blk, &err);
> -		if (!bh) {
> +		bh = NULL;
> +		err = ocfs2_read_quota_block(gqinode, blk, &bh);
> +		if (err) {
>  			mlog_errno(err);
>  			return err;
>  		}
> @@ -167,7 +173,7 @@ ssize_t ocfs2_quota_write(struct super_block *sb, int type,
>  	int offset = off & (sb->s_blocksize - 1);
>  	sector_t blk = off >> sb->s_blocksize_bits;
>  	int err = 0, new = 0;
> -	struct buffer_head *bh;
> +	struct buffer_head *bh = NULL;
>  	handle_t *handle = journal_current_handle();
>  
>  	if (!handle) {
> @@ -198,13 +204,13 @@ ssize_t ocfs2_quota_write(struct super_block *sb, int type,
>  	/* Not rewriting whole block? */
>  	if ((offset || len < sb->s_blocksize - OCFS2_QBLK_RESERVED_SPACE) &&
>  	    !new) {
> -		bh = ocfs2_read_quota_block(gqinode, blk, &err);
> -		if (!bh) {
> +		err = ocfs2_read_quota_block(gqinode, blk, &bh);
> +		if (err) {
>  			mlog_errno(err);
>  			return err;
>  		}
>  		err = ocfs2_journal_access(handle, gqinode, bh,
> -						OCFS2_JOURNAL_ACCESS_WRITE);
> +					   OCFS2_JOURNAL_ACCESS_WRITE);
>  	} else {
>  		bh = ocfs2_get_quota_block(gqinode, blk, &err);
>  		if (!bh) {
> @@ -212,7 +218,7 @@ ssize_t ocfs2_quota_write(struct super_block *sb, int type,
>  			return err;
>  		}
>  		err = ocfs2_journal_access(handle, gqinode, bh,
> -						OCFS2_JOURNAL_ACCESS_CREATE);
> +					   OCFS2_JOURNAL_ACCESS_CREATE);
>  	}
>  	if (err < 0) {
>  		brelse(bh);
> diff --git a/fs/ocfs2/quota_local.c b/fs/ocfs2/quota_local.c
> index 54e8788..c008dd9 100644
> --- a/fs/ocfs2/quota_local.c
> +++ b/fs/ocfs2/quota_local.c
> @@ -139,15 +139,15 @@ static int ocfs2_local_check_quota_file(struct super_block *sb, int type)
>  	unsigned int gversions[MAXQUOTAS] = OCFS2_GLOBAL_QVERSIONS;
>  	unsigned int ino[MAXQUOTAS] = { USER_QUOTA_SYSTEM_INODE,
>  					GROUP_QUOTA_SYSTEM_INODE };
> -	struct buffer_head *bh;
> +	struct buffer_head *bh = NULL;
>  	struct inode *linode = sb_dqopt(sb)->files[type];
>  	struct inode *ginode = NULL;
>  	struct ocfs2_disk_dqheader *dqhead;
>  	int status, ret = 0;
>  
>  	/* First check whether we understand local quota file */
> -	bh = ocfs2_read_quota_block(linode, 0, &status);
> -	if (!bh) {
> +	status = ocfs2_read_quota_block(linode, 0, &bh);
> +	if (status) {
>  		mlog_errno(status);
>  		mlog(ML_ERROR, "failed to read quota file header (type=%d)\n",
>  			type);
> @@ -178,8 +178,8 @@ static int ocfs2_local_check_quota_file(struct super_block *sb, int type)
>  		goto out_err;
>  	}
>  	/* Since the header is read only, we don't care about locking */
> -	bh = ocfs2_read_quota_block(ginode, 0, &status);
> -	if (!bh) {
> +	status = ocfs2_read_quota_block(ginode, 0, &bh);
> +	if (status) {
>  		mlog_errno(status);
>  		mlog(ML_ERROR, "failed to read global quota file header "
>  				"(type=%d)\n", type);
> @@ -235,10 +235,11 @@ static int ocfs2_load_local_quota_bitmaps(struct inode *inode,
>  			return -ENOMEM;
>  		}
>  		newchunk->qc_num = i;
> -		newchunk->qc_headerbh = ocfs2_read_quota_block(inode,
> +		newchunk->qc_headerbh = NULL;
> +		status = ocfs2_read_quota_block(inode,
>  				ol_quota_chunk_block(inode->i_sb, i),
> -				&status);
> -		if (!newchunk->qc_headerbh) {
> +				&newchunk->qc_headerbh);
> +		if (status) {
>  			mlog_errno(status);
>  			kmem_cache_free(ocfs2_qf_chunk_cachep, newchunk);
>  			ocfs2_release_local_quota_bitmaps(head);
> @@ -320,10 +321,11 @@ static int ocfs2_recovery_load_quota(struct inode *lqinode,
>  	int status = 0;
>  
>  	for (i = 0; i < chunks; i++) {
> -		hbh = ocfs2_read_quota_block(lqinode,
> -					     ol_quota_chunk_block(sb, i),
> -					     &status);
> -		if (!hbh) {
> +		hbh = NULL;
> +		status = ocfs2_read_quota_block(lqinode,
> +						ol_quota_chunk_block(sb, i),
> +						&hbh);
> +		if (status) {
>  			mlog_errno(status);
>  			break;
>  		}
> @@ -392,8 +394,9 @@ struct ocfs2_quota_recovery *ocfs2_begin_quota_recovery(
>  			goto out_put;
>  		}
>  		/* Now read local header */
> -		bh = ocfs2_read_quota_block(lqinode, 0, &status);
> -		if (!bh) {
> +		bh = NULL;
> +		status = ocfs2_read_quota_block(lqinode, 0, &bh);
> +		if (status) {
>  			mlog_errno(status);
>  			mlog(ML_ERROR, "failed to read quota file info header "
>  				"(slot=%d type=%d)\n", slot_num, type);
> @@ -447,19 +450,21 @@ static int ocfs2_recover_local_quota_file(struct inode *lqinode,
>  
>  	list_for_each_entry_safe(rchunk, next, &(rec->r_list[type]), rc_list) {
>  		chunk = rchunk->rc_chunk;
> -		hbh = ocfs2_read_quota_block(lqinode,
> -					     ol_quota_chunk_block(sb, chunk),
> -					     &status);
> -		if (!hbh) {
> +		hbh = NULL;
> +		status = ocfs2_read_quota_block(lqinode,
> +						ol_quota_chunk_block(sb, chunk),
> +						&hbh);
> +		if (status) {
>  			mlog_errno(status);
>  			break;
>  		}
>  		dchunk = (struct ocfs2_local_disk_chunk *)hbh->b_data;
>  		for_each_bit(bit, rchunk->rc_bitmap, ol_chunk_entries(sb)) {
> -			qbh = ocfs2_read_quota_block(lqinode,
> +			qbh = NULL;
> +			status = ocfs2_read_quota_block(lqinode,
>  						ol_dqblk_block(sb, chunk, bit),
> -						&status);
> -			if (!qbh) {
> +						&qbh);
> +			if (status) {
>  				mlog_errno(status);
>  				break;
>  			}
> @@ -581,8 +586,9 @@ int ocfs2_finish_quota_recovery(struct ocfs2_super *osb,
>  			goto out_put;
>  		}
>  		/* Now read local header */
> -		bh = ocfs2_read_quota_block(lqinode, 0, &status);
> -		if (!bh) {
> +		bh = NULL;
> +		status = ocfs2_read_quota_block(lqinode, 0, &bh);
> +		if (status) {
>  			mlog_errno(status);
>  			mlog(ML_ERROR, "failed to read quota file info header "
>  				"(slot=%d type=%d)\n", slot_num, type);
> @@ -676,8 +682,8 @@ static int ocfs2_local_read_info(struct super_block *sb, int type)
>  	locked = 1;
>  
>  	/* Now read local header */
> -	bh = ocfs2_read_quota_block(lqinode, 0, &status);
> -	if (!bh) {
> +	status = ocfs2_read_quota_block(lqinode, 0, &bh);
> +	if (status) {
>  		mlog_errno(status);
>  		mlog(ML_ERROR, "failed to read quota file info header "
>  			"(type=%d)\n", type);
> @@ -850,13 +856,13 @@ static int ocfs2_local_write_dquot(struct dquot *dquot)
>  {
>  	struct super_block *sb = dquot->dq_sb;
>  	struct ocfs2_dquot *od = OCFS2_DQUOT(dquot);
> -	struct buffer_head *bh;
> +	struct buffer_head *bh = NULL;
>  	int status;
>  
> -	bh = ocfs2_read_quota_block(sb_dqopt(sb)->files[dquot->dq_type],
> +	status = ocfs2_read_quota_block(sb_dqopt(sb)->files[dquot->dq_type],
>  				    ol_dqblk_file_block(sb, od->dq_local_off),
> -				    &status);
> -	if (!bh) {
> +				    &bh);
> +	if (status) {
>  		mlog_errno(status);
>  		goto out;
>  	}
> -- 
> 1.5.6.5
> 
> 
> -- 
> 
>  "I'm living so far beyond my income that we may almost be said
>  to be living apart."
>          - e e cummings
> 
> Joel Becker
> Principal Software Developer
> Oracle
> E-mail: joel.becker at oracle.com
> Phone: (650) 506-8127
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
