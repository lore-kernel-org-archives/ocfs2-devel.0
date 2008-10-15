From: Mark Fasheh <mfasheh@suse.com>
Date: Tue, 14 Oct 2008 17:20:44 -0700
Subject: [Ocfs2-devel] [PATCH] ocfs2: Wrap inode block reads in a
	dedicated function.
Message-ID: <20081015002044.GM15154@wotan.suse.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Ooops, last one didn't CC ocfs2-devel.

On Mon, Oct 13, 2008 at 06:16:15PM -0700, Joel Becker wrote:
> @@ -232,25 +231,17 @@ int ocfs2_populate_inode(struct inode *inode, struct ocfs2_dinode *fe,
>  	    ocfs2_mount_local(osb) || !ocfs2_stack_supports_plocks())
>  		use_plocks = 0;
>  
> -	/* this means that read_inode cannot create a superblock inode
> -	 * today.  change if needed. */
> -	if (!OCFS2_IS_VALID_DINODE(fe) ||
> -	    !(fe->i_flags & cpu_to_le32(OCFS2_VALID_FL))) {
> -		mlog(0, "Invalid dinode: i_ino=%lu, i_blkno=%llu, "
> -		     "signature = %.*s, flags = 0x%x\n",
> -		     inode->i_ino,
> -		     (unsigned long long)le64_to_cpu(fe->i_blkno), 7,
> -		     fe->i_signature, le32_to_cpu(fe->i_flags));
> -		goto bail;
> -	}
> +	/*
> +	 * These have all been checked by ocfs2_read_inode_block() or set
> +	 * by ocfs2_mknod_locked(), so a failure is a code bug.
> +	 */
> +	BUG_ON(!OCFS2_IS_VALID_DINODE(fe));  /* This means that read_inode
> +						cannot create a superblock
> +						inode today.  change if
> +						that is needed. */
> +	BUG_ON(!(fe->i_flags & cpu_to_le32(OCFS2_VALID_FL)));
> +	BUG_ON(le32_to_cpu(fe->i_fs_generation) != osb->fs_generation);
>  
> -	if (le32_to_cpu(fe->i_fs_generation) != osb->fs_generation) {
> -		mlog(ML_ERROR, "file entry generation does not match "
> -		     "superblock! osb->fs_generation=%x, "
> -		     "fe->i_fs_generation=%x\n",
> -		     osb->fs_generation, le32_to_cpu(fe->i_fs_generation));
> -		goto bail;
> -	}

These changes to ocfs2_populate_inode() look great.


>  	OCFS2_I(inode)->ip_clusters = le32_to_cpu(fe->i_clusters);
>  	OCFS2_I(inode)->ip_attr = le32_to_cpu(fe->i_attr);
> @@ -354,10 +345,7 @@ int ocfs2_populate_inode(struct inode *inode, struct ocfs2_dinode *fe,
>  
>  	ocfs2_set_inode_flags(inode);
>  
> -	status = 0;
> -bail:
> -	mlog_exit(status);
> -	return status;
> +	mlog_exit_void();
>  }
>  
>  static int ocfs2_read_locked_inode(struct inode *inode,
> @@ -460,11 +448,15 @@ static int ocfs2_read_locked_inode(struct inode *inode,
>  		}
>  	}
>  
> -	if (can_lock)
> -		status = ocfs2_read_blocks(inode, args->fi_blkno, 1, &bh,
> -					   OCFS2_BH_IGNORE_CACHE);
> -	else
> +	if (can_lock) {
> +		status = ocfs2_read_inode_block_full(inode, args->fi_blkno,
> +						     &bh,
> +						     OCFS2_BH_IGNORE_CACHE);
> +	} else {
>  		status = ocfs2_read_blocks_sync(osb, args->fi_blkno, 1, &bh);
> +		if (!status)
> +			status = ocfs2_validate_inode_block(osb->sb, bh);
> +	}
>  	if (status < 0) {
>  		mlog_errno(status);
>  		goto bail;
> @@ -472,12 +464,6 @@ static int ocfs2_read_locked_inode(struct inode *inode,
>  
>  	status = -EINVAL;
>  	fe = (struct ocfs2_dinode *) bh->b_data;
> -	if (!OCFS2_IS_VALID_DINODE(fe)) {
> -		mlog(0, "Invalid dinode #%llu: signature = %.*s\n",
> -		     (unsigned long long)args->fi_blkno, 7,
> -		     fe->i_signature);
> -		goto bail;
> -	}
>  
>  	/*
>  	 * This is a code bug. Right now the caller needs to
> @@ -491,10 +477,9 @@ static int ocfs2_read_locked_inode(struct inode *inode,
>  
>  	if (S_ISCHR(le16_to_cpu(fe->i_mode)) ||
>  	    S_ISBLK(le16_to_cpu(fe->i_mode)))
> -    		inode->i_rdev = huge_decode_dev(le64_to_cpu(fe->id1.dev1.i_rdev));
> +		inode->i_rdev = huge_decode_dev(le64_to_cpu(fe->id1.dev1.i_rdev));
>  
> -	if (ocfs2_populate_inode(inode, fe, 0) < 0)
> -		goto bail;
> +	ocfs2_populate_inode(inode, fe, 0);
>  
>  	BUG_ON(args->fi_blkno != le64_to_cpu(fe->i_blkno));
>  
> @@ -1258,3 +1243,66 @@ void ocfs2_refresh_inode(struct inode *inode,
>  
>  	spin_unlock(&OCFS2_I(inode)->ip_lock);
>  }
> +
> +int ocfs2_validate_inode_block(struct super_block *sb,
> +			       struct buffer_head *bh)
> +{
> +	int rc = -EINVAL;
> +	struct ocfs2_dinode *di = (struct ocfs2_dinode *)bh->b_data;
> +
> +	BUG_ON(!buffer_uptodate(bh));
> +
> +	if (!OCFS2_IS_VALID_DINODE(di)) {
> +		ocfs2_error(sb, "Invalid dinode #%llu: signature = %.*s\n",
> +			    (unsigned long long)bh->b_blocknr, 7,
> +			    di->i_signature);
> +		goto bail;
> +	}
> +
> +	if (le64_to_cpu(di->i_blkno) != bh->b_blocknr) {
> +		ocfs2_error(sb, "Invalid dinode #%llu: i_blkno is %llu\n",
> +			    (unsigned long long)bh->b_blocknr,
> +			    (unsigned long long)le64_to_cpu(di->i_blkno));
> +		goto bail;
> +	}
> +
> +	if (!(di->i_flags & cpu_to_le32(OCFS2_VALID_FL))) {
> +		ocfs2_error(sb,
> +			    "Invalid dinode #%llu: OCFS2_VALID_FL not set\n",
> +			    (unsigned long long)bh->b_blocknr);
> +		goto bail;
> +	}
> +
> +	if (le32_to_cpu(di->i_fs_generation) !=
> +	    OCFS2_SB(sb)->fs_generation) {
> +		ocfs2_error(sb,
> +			    "Invalid dinode #%llu: fs_generation is %u\n",
> +			    (unsigned long long)bh->b_blocknr,
> +			    le32_to_cpu(di->i_fs_generation));
> +		goto bail;
> +	}
> +
> +	rc = 0;
> +
> +bail:
> +	return rc;
> +}
> +
> +int ocfs2_read_inode_block_full(struct inode *inode, u64 blkno,
> +				struct buffer_head **bh, int flags)
> +{
> +	int rc;
> +
> +	rc = ocfs2_read_blocks(inode, blkno, 1, bh, flags);
> +	if (rc)
> +		return rc;
> +
> +	rc = ocfs2_validate_inode_block(inode->i_sb, *bh);
> +	return rc;
> +}
> +
> +int ocfs2_read_inode_block(struct inode *inode, u64 blkno,
> +			   struct buffer_head **bh)
> +{

Can we get rid of the blkno argument here, and just get it from
OCFS2_I(inode)->ip_blkno? Getting it out of ocfs2_read_inode_block_full()
might be nice too, but not as big a deal since it isn't called as much.


API-wise, this is a very nice change. It makes the checks we have more
consistent. I think it'd be worth the time though to figure out how to
execute the validation code only when we've actually read the disk.
	--Mark

--
Mark Fasheh
