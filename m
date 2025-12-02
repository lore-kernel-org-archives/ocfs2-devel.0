Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E698218BC3D
	for <ocfs2-devel@lists.linux.dev>; Tue,  2 Dec 2025 03:16:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764645400; cv=none; b=llj+msCSsJvKejX3oYijJWBRlDW8/FDqdtWBgXLz4ro6l3TUM3WJmg6Pq25Ra9eeBjA3kKDQ7BwnqW6VOnVOmRKTheBGgBXL3s+UNqRjRblrXzeAgYVr+GT9Wvnl6lkg3YFHOH3THZ2pz0NGr3AFJ/QO127SgQjPelYP9e06J+I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764645400; c=relaxed/simple;
	bh=NlbmbMTSICJKWZIdiXkEcvIRQOJ6Eavm9WAA09pSNWk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=WcxqVjuH8QzVPcHT3skMiokqGmcspCo5B6t2B5+NN6rzOWWOpwupWe1C+CESGsWlbG7+9wIfPjZtno6wGsIQm6S0Ixgq+GRQL8uQnPfoiLVg12Ilxi9Y4c4bPXh0cIA7TGuSJPiTKQlEk90JCRGrn03mY7uVOxy6NE7Fehkyoqw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=BLFvh9QY; arc=none smtp.client-ip=209.85.128.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="BLFvh9QY"
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-4779ebfa91aso5351155e9.3
        for <ocfs2-devel@lists.linux.dev>; Mon, 01 Dec 2025 19:16:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1764645396; x=1765250196; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=VQDyKwBq5m6XTsJqgI7626l+haKjnFZqzX+xZeZ5VII=;
        b=BLFvh9QY34UxvYv1tRSZAwdJUyKV/PIRvsMsG7rIqOcuHx/jgQ/ghffMLnFPPoBprT
         1OlHynkqsvuzoniJ0yRhJ72AgSnYESSd9/Cz5aiZDGxfNuRTEKSJQ0SscoJVpuwyozYO
         KSYZ6nRW4mfHEYcCTr7Xh4BLirxpqVvacKg3hZjBwActX8UqHd46EI2q32umti2wHkMa
         jxuEIFbNuvQ5ML/USh6nM45yXwNCwH6w1iBrilPY3eNABqEWKMMp1HAj7BLrY5gWhW9M
         5m7OW+MRnw0gcd3JBwAy60L+Eq1eRGhLMBD7lXnHw7JQVUcXyD4zOlzaaPrHAq9wRigv
         UFjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764645396; x=1765250196;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=VQDyKwBq5m6XTsJqgI7626l+haKjnFZqzX+xZeZ5VII=;
        b=BpoRhEXVzH4okIH/Ptiv9IeakNVhQ7QWxC1QVzfcTV8qW8nJXD3qeuCtmwaoKL81Ai
         3tglGkck+RtNmFTTIcCHcj578mG1vPJbFslFm0kR2TFSkKf8XaYj3dXNe/gO/vKbYiw4
         ByPIoilT5AIOwG44dBnk0Rj0o/gexHXSAsHgu5jMM77u3Tob36B701W9MoLx2AKXYk3h
         xe72Ho2i4taAA6mMJizMKzFDZd26HYOEw/AbaZb5/BWFKT5cgzO4buGKGtaKHg/1NOdW
         RkpY+/51pAH83U4gOGIbIxmLadAXSfn3ie01DAs+KTJFRR2yKbQRzto5D+YpUTo3GyOI
         645w==
X-Forwarded-Encrypted: i=1; AJvYcCXBCn0gwUn/TBs0lFyJ4KgzvjhczUIyqtA0E+4dFsYYVQQAg6J5nS8X/iFkcNl7pHUcKQf9XEN8BPevOg==@lists.linux.dev
X-Gm-Message-State: AOJu0YyfPNTg//3oAn9xn3KGwhZ/BxOmuDdfdttqsiXjJiHwxPeNSecA
	B9qE5JdarWIimnq17n6cVmT8NgPm3JpesVG/IV+jMRBy8hI4YxHu4r7OQN0S7hqb+bk=
X-Gm-Gg: ASbGncsLJFsgHPBxV1LYsna5wb5GzWE1ecMa7o1S5w0b1d9SXF1bjWxak5N61VIsvhO
	YQ6HGCj3bNYqyZyLL3+NyIlypjZh67ECHDrWDLy0fDP2f6Y666ii9h4Qy3Dl8bTtr8bV+UsgzLQ
	vspofTxABCOJg7YSZL/E2/W3Ne1t9XTBeAgHiaaYq3Khk8/fVrhGHmdr3utyG3tikM+voEgQHNy
	vD1u30W+qCyMzvhtNTRV/yk2CidMeKNT0wpNQf+apcR9LczeGTKuRf2+fqGkN5cPuBM6ei4qyXD
	HzgqlS+wOvPpiPnMxfY+h08A1SsGrZwj5DKAEy/rYd75r/JeufD54AH7OxLsqLl3kFlFLlpzN5y
	bjBHE3qh2sI9PvIbBl+awtJ4iN8M/TbulG4gkW+v9YBp2UcKnl10Nv2xM2dpWPPSv+0rBH6sN7a
	v9P4ATvaDj7g==
X-Google-Smtp-Source: AGHT+IHaWBm/6NC7vOCd+kLR3V11auqoOg1lVnmFuYO/V96JH7ybePbxLyrqiGurhr52IkrOfdfgig==
X-Received: by 2002:a05:600c:4f51:b0:477:a977:b8a0 with SMTP id 5b1f17b1804b1-477c01ba7d6mr255924385e9.3.1764645396282;
        Mon, 01 Dec 2025 19:16:36 -0800 (PST)
Received: from localhost ([202.127.77.110])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-29bce46ca9bsm138875925ad.38.2025.12.01.19.16.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Dec 2025 19:16:35 -0800 (PST)
Date: Tue, 2 Dec 2025 11:16:33 +0800
From: Heming Zhao <heming.zhao@suse.com>
To: Ahmet Eray Karadag <eraykrdg1@gmail.com>
Cc: mark@fasheh.com, jlbec@evilplan.org, joseph.qi@linux.alibaba.com, 
	ocfs2-devel@lists.linux.dev, linux-kernel@vger.kernel.org, david.hunter.linux@gmail.com, 
	skhan@linuxfoundation.org, Albin Babu Varghese <albinbabuvarghese20@gmail.com>
Subject: Re: [PATCH v3 2/2] ocfs2: Convert remaining read-only checks to
 ocfs2_emergency_state
Message-ID: <3xvyigbaszsu5e3h45kcke6taadvvcqyjx2qex277wqtjx4r56@fhhuasdg6ruy>
References: <cover.1764643790.git.eraykrdg1@gmail.com>
 <1f329fa8f8b0496ecb88c6c48174ca3d8e339f8d.1764643790.git.eraykrdg1@gmail.com>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1f329fa8f8b0496ecb88c6c48174ca3d8e339f8d.1764643790.git.eraykrdg1@gmail.com>

On Tue, Dec 02, 2025 at 05:54:58AM +0300, Ahmet Eray Karadag wrote:
> To centralize error checking, follow the pattern of other filesystems
> like ext4 (which uses `ext4_emergency_state()`), and prepare for
> future enhancements, this patch introduces a new helper function:
> `ocfs2_emergency_state()`.
> 
> The purpose of this helper is to provide a single, unified location
> for checking all filesystem-level emergency conditions. In this
> initial implementation, the function only checks for the existing
> hard and soft read-only modes, returning -EROFS if either is set.
> 
> This provides a foundation where future checks (e.g., for fatal error
> states returning -EIO, or shutdown states) can be easily added in
> one place.
> 
> This patch also adds this new check to the beginning of
> `ocfs2_setattr()`. This ensures that operations like `ftruncate`
> (which triggered the original BUG) fail-fast with -EROFS when the
> filesystem is already in a read-only state.
> 
> Co-developed-by: Albin Babu Varghese <albinbabuvarghese20@gmail.com>
> Signed-off-by: Albin Babu Varghese <albinbabuvarghese20@gmail.com>
> Signed-off-by: Ahmet Eray Karadag <eraykrdg1@gmail.com>

Reviewed-by: Heming Zhao <heming.zhao@suse.com>
> ---
> v2:
>  - Use `unlikely()` for status check
> ---
>  fs/ocfs2/buffer_head_io.c |  4 ++--
>  fs/ocfs2/file.c           | 17 ++++++++++-------
>  fs/ocfs2/inode.c          |  3 +--
>  fs/ocfs2/move_extents.c   |  5 +++--
>  fs/ocfs2/resize.c         |  8 +++++---
>  fs/ocfs2/super.c          |  2 +-
>  6 files changed, 22 insertions(+), 17 deletions(-)
> 
> diff --git a/fs/ocfs2/buffer_head_io.c b/fs/ocfs2/buffer_head_io.c
> index 8f714406528d..61a0f522c673 100644
> --- a/fs/ocfs2/buffer_head_io.c
> +++ b/fs/ocfs2/buffer_head_io.c
> @@ -434,8 +434,8 @@ int ocfs2_write_super_or_backup(struct ocfs2_super *osb,
>  	BUG_ON(buffer_jbd(bh));
>  	ocfs2_check_super_or_backup(osb->sb, bh->b_blocknr);
>  
> -	if (ocfs2_is_hard_readonly(osb) || ocfs2_is_soft_readonly(osb)) {
> -		ret = -EROFS;
> +	ret = ocfs2_emergency_state(osb);
> +	if (unlikely(ret)) {
>  		mlog_errno(ret);
>  		goto out;
>  	}
> diff --git a/fs/ocfs2/file.c b/fs/ocfs2/file.c
> index 253b4f300127..540b35ec02e2 100644
> --- a/fs/ocfs2/file.c
> +++ b/fs/ocfs2/file.c
> @@ -179,8 +179,9 @@ static int ocfs2_sync_file(struct file *file, loff_t start, loff_t end,
>  			      file->f_path.dentry->d_name.name,
>  			      (unsigned long long)datasync);
>  
> -	if (ocfs2_is_hard_readonly(osb) || ocfs2_is_soft_readonly(osb))
> -		return -EROFS;
> +	ret = ocfs2_emergency_state(osb);
> +	if (unlikely(ret))
> +		return ret;
>  
>  	err = file_write_and_wait_range(file, start, end);
>  	if (err)
> @@ -209,7 +210,7 @@ int ocfs2_should_update_atime(struct inode *inode,
>  	struct timespec64 now;
>  	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
>  
> -	if (ocfs2_is_hard_readonly(osb) || ocfs2_is_soft_readonly(osb))
> +	if (unlikely(ocfs2_emergency_state(osb)))
>  		return 0;
>  
>  	if ((inode->i_flags & S_NOATIME) ||
> @@ -1949,8 +1950,9 @@ static int __ocfs2_change_file_space(struct file *file, struct inode *inode,
>  	handle_t *handle;
>  	unsigned long long max_off = inode->i_sb->s_maxbytes;
>  
> -	if (ocfs2_is_hard_readonly(osb) || ocfs2_is_soft_readonly(osb))
> -		return -EROFS;
> +	ret = ocfs2_emergency_state(osb);
> +	if (unlikely(ret))
> +		return ret;
>  
>  	inode_lock(inode);
>  
> @@ -2713,8 +2715,9 @@ static loff_t ocfs2_remap_file_range(struct file *file_in, loff_t pos_in,
>  		return -EINVAL;
>  	if (!ocfs2_refcount_tree(osb))
>  		return -EOPNOTSUPP;
> -	if (ocfs2_is_hard_readonly(osb) || ocfs2_is_soft_readonly(osb))
> -		return -EROFS;
> +	ret = ocfs2_emergency_state(osb);
> +	if (unlikely(ret))
> +		return ret;
>  
>  	/* Lock both files against IO */
>  	ret = ocfs2_reflink_inodes_lock(inode_in, &in_bh, inode_out, &out_bh);
> diff --git a/fs/ocfs2/inode.c b/fs/ocfs2/inode.c
> index fcc89856ab95..b7dad049cfa3 100644
> --- a/fs/ocfs2/inode.c
> +++ b/fs/ocfs2/inode.c
> @@ -1586,8 +1586,7 @@ static int ocfs2_filecheck_repair_inode_block(struct super_block *sb,
>  	trace_ocfs2_filecheck_repair_inode_block(
>  		(unsigned long long)bh->b_blocknr);
>  
> -	if (ocfs2_is_hard_readonly(OCFS2_SB(sb)) ||
> -	    ocfs2_is_soft_readonly(OCFS2_SB(sb))) {
> +	if (unlikely(ocfs2_emergency_state(OCFS2_SB(sb)))) {
>  		mlog(ML_ERROR,
>  		     "Filecheck: cannot repair dinode #%llu "
>  		     "on readonly filesystem\n",
> diff --git a/fs/ocfs2/move_extents.c b/fs/ocfs2/move_extents.c
> index 86f2631e6360..9d2a2d054aa1 100644
> --- a/fs/ocfs2/move_extents.c
> +++ b/fs/ocfs2/move_extents.c
> @@ -898,8 +898,9 @@ static int ocfs2_move_extents(struct ocfs2_move_extents_context *context)
>  	struct buffer_head *di_bh = NULL;
>  	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
>  
> -	if (ocfs2_is_hard_readonly(osb) || ocfs2_is_soft_readonly(osb))
> -		return -EROFS;
> +	status = ocfs2_emergency_state(osb);
> +	if (unlikely(status))
> +		return status;
>  
>  	inode_lock(inode);
>  
> diff --git a/fs/ocfs2/resize.c b/fs/ocfs2/resize.c
> index b0733c08ed13..ae30ae67e220 100644
> --- a/fs/ocfs2/resize.c
> +++ b/fs/ocfs2/resize.c
> @@ -276,8 +276,9 @@ int ocfs2_group_extend(struct inode * inode, int new_clusters)
>  	u32 first_new_cluster;
>  	u64 lgd_blkno;
>  
> -	if (ocfs2_is_hard_readonly(osb) || ocfs2_is_soft_readonly(osb))
> -		return -EROFS;
> +	ret = ocfs2_emergency_state(osb);
> +	if (unlikely(ret))
> +		return ret;
>  
>  	if (new_clusters < 0)
>  		return -EINVAL;
> @@ -466,7 +467,8 @@ int ocfs2_group_add(struct inode *inode, struct ocfs2_new_group_input *input)
>  	u16 cl_bpc;
>  	u64 bg_ptr;
>  
> -	if (ocfs2_is_hard_readonly(osb) || ocfs2_is_soft_readonly(osb))
> +	ret = ocfs2_emergency_state(osb);
> +	if (unlikely(ret))
>  		return -EROFS;
>  
>  	main_bm_inode = ocfs2_get_system_file_inode(osb,
> diff --git a/fs/ocfs2/super.c b/fs/ocfs2/super.c
> index 53daa4482406..c6019d260efc 100644
> --- a/fs/ocfs2/super.c
> +++ b/fs/ocfs2/super.c
> @@ -2487,7 +2487,7 @@ static int ocfs2_handle_error(struct super_block *sb)
>  		rv = -EIO;
>  	} else { /* default option */
>  		rv = -EROFS;
> -		if (sb_rdonly(sb) && (ocfs2_is_soft_readonly(osb) || ocfs2_is_hard_readonly(osb)))
> +		if (sb_rdonly(sb) && ocfs2_emergency_state(osb))
>  			return rv;
>  
>  		pr_crit("OCFS2: File system is now read-only.\n");
> -- 
> 2.43.0
> 
> 
