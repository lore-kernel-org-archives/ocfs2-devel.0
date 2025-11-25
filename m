Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF0281E5B7A
	for <ocfs2-devel@lists.linux.dev>; Tue, 25 Nov 2025 03:02:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764039745; cv=none; b=BwWBimIAzp1OAJUf3aRLCMTMyPaFNtPOS8eCKem6sBm7nVWPENJa635SsR12RLXJ/73dywUM/YdnElEt33rdOKGQPKmRGTkc0KNHFTYRqRpq6cC8BJ3z6NDMAZu5kfriE/jK+mZ9kyoSIQmnck1Kt/P3ZFJni3UDOJR1ZnIJ3Fo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764039745; c=relaxed/simple;
	bh=Q8oReu8m8zqUMdoEBRANuZwKzTRc/2+yf/58UA4s2KU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=pzeGjQeUfRgtYbCprjxPWlsC3jbWOswBZaVVzMv7bn4qcYuruaj644JkVKk9PVLso5QqRPqt9dNU1NCjiBvTJjPBeZeHWMG4oU+9QoGZB0SX1DoIHcljtswmM1wEnMkbg5/WQ2/6igixzz+sopvi/EoV1rOcaU9AZko3GrItEJs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=YDsGNSbu; arc=none smtp.client-ip=209.85.128.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="YDsGNSbu"
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-4779cd413b4so3038625e9.2
        for <ocfs2-devel@lists.linux.dev>; Mon, 24 Nov 2025 19:02:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1764039740; x=1764644540; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=sNgFZnZJ7gmuiwt4bnxdcBeTElkaDQB3eu7I/Iqqfx8=;
        b=YDsGNSbuYUiU1eDV0lyoEfnSBYbbiGigr11pNIVzWWCYfy+Gdqo6GLC4P2CnUsmz8S
         KNuBm8WsPeV2100sA3lLJPgwA3SJLIPbsbGKnr03u1qR/fLRibJIrwP6Ml+38p7hTiBg
         5fEt7RZMzY8OemfrVboRxqu1HJh72iav26BemPDCIv7rLICMawXh7c3fOf4TSyGWNb7M
         n9lDxScPGPVDU9TTQ1x7gsKXZOWjmxg1iaJGNpXglrprOESc8aWOd/d9tl8ns8cPs+/R
         RcOo+jL3V8ObuystdvaW7MlhTaNUk1YBvApe+goYM2HFW7U8dVocE4R7vT0koZ9CUgum
         wpBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764039740; x=1764644540;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=sNgFZnZJ7gmuiwt4bnxdcBeTElkaDQB3eu7I/Iqqfx8=;
        b=qO+Jkp/E4cQlLRTNgqrTfmKjsZQ8qK/48o7PP2R0HrTl4o3h/x/0S4Q1Vc5jtme+zN
         a9Nc80svUAid0bvopa4bozwhJjh1A6KpNZgvju6CsxBRHKSdJDuIDGbmHqhe4WIZwIcp
         kyTtMctQYEnNlzUuPm/3FnZdxs5CzZ86BpB6j3fpwJ8PNK7yVkcJ9DY2UcbvL4DzB3Uk
         fNTYxocrE0jL0JrRBIfZepUtS6uKwowSg2RrwqvCLLleNUA2X7yf78xzhYLbmcxCWw1f
         XS8SjBNWKydAGrkneAHvw/9OVwiFeXgF7yVMeEafjeCq0pWRItydyRwrEGARpPfuU8tP
         t/Pw==
X-Forwarded-Encrypted: i=1; AJvYcCWpekkKI0r6REgZNsyfW8lIWvxwj1ywU2jUej/1/Xg9Lt9NOFAUpvcAqNLtb/JptddKTryuVJGcA/a8Kw==@lists.linux.dev
X-Gm-Message-State: AOJu0YycPnMPJ36+91ZZN4ns0zaZXtJNgHefN58r5HeJUouIYWj/p8yb
	+kgI6IcTWc9zCspqtOrs4VbC651tKTUAn8cQAYFkoO59qgKAzYiN7eldm7H09mNBOjoKLdCXahJ
	xCB824uY=
X-Gm-Gg: ASbGnctlu8jkD2jHNU+s+aWkRHFJVnhpfTAZuzU7KX4xnKmWl4qCHw4A53wa5SNLobD
	GypwC2KF4GKHs2W/M5EufQ9copj7MYzAAdVgS48w2sSAVsiqEyX0aDyCzVbXy6K7WGfP0jjlt3V
	P9WwYHJNODNRaSblbr6IAknCFWCJQ9cmidFUNTp/R7gZ3aQdTckBavmz5C9rMt8VpmszEMt7Tas
	attwZ1V9x2syzCljBni6M3+BU1xKmFLF742w7aZDUTqM2QrVH7hri/3ucox0cv7CF786M2Jrwvr
	HvYnlNKc9httvU8Ce1GLR2wJdu+nitNDEcENWTiG+MYqYbbbdW3yblsnNFHudxo/+yMcEMiYhCc
	L7hoQaPLM5Fpn2ffZcpHif795W+RCtHY+mlXOidVxYyFOrsuP5URWbDm8WuFehDVUoMaMYOGZ/S
	vttX0ptC9scA==
X-Google-Smtp-Source: AGHT+IGbEACqgxDC4ONVqIkl/F3R98NtQX8Q2ulzvrLG/bXglNo4029TZkLPv2rbRtkNkY8n8EJaYQ==
X-Received: by 2002:a05:600c:1c23:b0:477:5c70:e14e with SMTP id 5b1f17b1804b1-477c01d92cdmr89138365e9.5.1764039739951;
        Mon, 24 Nov 2025 19:02:19 -0800 (PST)
Received: from localhost ([202.127.77.110])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7c3ecf7dc6asm16452471b3a.4.2025.11.24.19.02.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Nov 2025 19:02:19 -0800 (PST)
Date: Tue, 25 Nov 2025 11:02:16 +0800
From: Heming Zhao <heming.zhao@suse.com>
To: Ahmet Eray Karadag <eraykrdg1@gmail.com>
Cc: mark@fasheh.com, jlbec@evilplan.org, joseph.qi@linux.alibaba.com, 
	ocfs2-devel@lists.linux.dev, linux-kernel@vger.kernel.org, david.hunter.linux@gmail.com, 
	skhan@linuxfoundation.org, Albin Babu Varghese <albinbabuvarghese20@gmail.com>
Subject: Re: [PATCH 2/2] ocfs2: Convert remaining read-only checks to
 ocfs2_emergency_state
Message-ID: <imphvje3duazyc3xhzst5rze5j6bkevbia5jb6gylct34umx4m@3afjqfeab6iw>
References: <cover.1763337347.git.eraykrdg1@gmail.com>
 <025589c07fd51a0693fffe8337184e14ec6d92bc.1763337347.git.eraykrdg1@gmail.com>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <025589c07fd51a0693fffe8337184e14ec6d92bc.1763337347.git.eraykrdg1@gmail.com>

On Tue, Nov 18, 2025 at 03:26:46AM +0300, Ahmet Eray Karadag wrote:
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
> index 8f714406528d..c43d4a58aa9a 100644
> --- a/fs/ocfs2/buffer_head_io.c
> +++ b/fs/ocfs2/buffer_head_io.c
> @@ -434,8 +434,8 @@ int ocfs2_write_super_or_backup(struct ocfs2_super *osb,
>  	BUG_ON(buffer_jbd(bh));
>  	ocfs2_check_super_or_backup(osb->sb, bh->b_blocknr);
>  
> -	if (ocfs2_is_hard_readonly(osb) || ocfs2_is_soft_readonly(osb)) {
> -		ret = -EROFS;
> +	ret = ocfs2_emergency_state(osb);
> +	if (ret < 0) {
>  		mlog_errno(ret);
>  		goto out;
>  	}

as comment in patch [1/2], I prefer "if (unlikely(ret))" here.

> diff --git a/fs/ocfs2/file.c b/fs/ocfs2/file.c
> index 03a98985ac92..c299b73cf4ec 100644
> --- a/fs/ocfs2/file.c
> +++ b/fs/ocfs2/file.c
> @@ -179,8 +179,9 @@ static int ocfs2_sync_file(struct file *file, loff_t start, loff_t end,
>  			      file->f_path.dentry->d_name.name,
>  			      (unsigned long long)datasync);
>  
> -	if (ocfs2_is_hard_readonly(osb) || ocfs2_is_soft_readonly(osb))
> -		return -EROFS;
> +	ret = ocfs2_emergency_state(osb);
> +	if (ret < 0)
> +		return ret;

ditto 
>  
>  	err = file_write_and_wait_range(file, start, end);
>  	if (err)
> @@ -209,7 +210,7 @@ int ocfs2_should_update_atime(struct inode *inode,
>  	struct timespec64 now;
>  	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
>  
> -	if (ocfs2_is_hard_readonly(osb) || ocfs2_is_soft_readonly(osb))
> +	if (ocfs2_emergency_state(osb))
>  		return 0;

ditto
>  
>  	if ((inode->i_flags & S_NOATIME) ||
> @@ -1949,8 +1950,9 @@ static int __ocfs2_change_file_space(struct file *file, struct inode *inode,
>  	handle_t *handle;
>  	unsigned long long max_off = inode->i_sb->s_maxbytes;
>  
> -	if (ocfs2_is_hard_readonly(osb) || ocfs2_is_soft_readonly(osb))
> -		return -EROFS;
> +	ret = ocfs2_emergency_state(osb);
> +	if (ret < 0)
> +		return ret;

ditto
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
> +	if (ret < 0)
> +		return ret;

ditto
>  
>  	/* Lock both files against IO */
>  	ret = ocfs2_reflink_inodes_lock(inode_in, &in_bh, inode_out, &out_bh);
> diff --git a/fs/ocfs2/inode.c b/fs/ocfs2/inode.c
> index 415ad29ec758..dca8db61bc0f 100644
> --- a/fs/ocfs2/inode.c
> +++ b/fs/ocfs2/inode.c
> @@ -1586,8 +1586,7 @@ static int ocfs2_filecheck_repair_inode_block(struct super_block *sb,
>  	trace_ocfs2_filecheck_repair_inode_block(
>  		(unsigned long long)bh->b_blocknr);
>  
> -	if (ocfs2_is_hard_readonly(OCFS2_SB(sb)) ||
> -	    ocfs2_is_soft_readonly(OCFS2_SB(sb))) {
> +	if (ocfs2_emergency_state(OCFS2_SB(sb))) {

ditto
>  		mlog(ML_ERROR,
>  		     "Filecheck: cannot repair dinode #%llu "
>  		     "on readonly filesystem\n",
> diff --git a/fs/ocfs2/move_extents.c b/fs/ocfs2/move_extents.c
> index 86f2631e6360..f586593b3a63 100644
> --- a/fs/ocfs2/move_extents.c
> +++ b/fs/ocfs2/move_extents.c
> @@ -898,8 +898,9 @@ static int ocfs2_move_extents(struct ocfs2_move_extents_context *context)
>  	struct buffer_head *di_bh = NULL;
>  	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
>  
> -	if (ocfs2_is_hard_readonly(osb) || ocfs2_is_soft_readonly(osb))
> -		return -EROFS;
> +	status = ocfs2_emergency_state(osb);
> +	if (status < 0)
> +		return status;

ditto
>  
>  	inode_lock(inode);
>  
> diff --git a/fs/ocfs2/resize.c b/fs/ocfs2/resize.c
> index b0733c08ed13..d9f5e1d065b4 100644
> --- a/fs/ocfs2/resize.c
> +++ b/fs/ocfs2/resize.c
> @@ -276,8 +276,9 @@ int ocfs2_group_extend(struct inode * inode, int new_clusters)
>  	u32 first_new_cluster;
>  	u64 lgd_blkno;
>  
> -	if (ocfs2_is_hard_readonly(osb) || ocfs2_is_soft_readonly(osb))
> -		return -EROFS;
> +	ret = ocfs2_emergency_state(osb);
> +	if (ret < 0)
> +		return ret;

ditto
>  
>  	if (new_clusters < 0)
>  		return -EINVAL;
> @@ -466,7 +467,8 @@ int ocfs2_group_add(struct inode *inode, struct ocfs2_new_group_input *input)
>  	u16 cl_bpc;
>  	u64 bg_ptr;
>  
> -	if (ocfs2_is_hard_readonly(osb) || ocfs2_is_soft_readonly(osb))
> +	ret = ocfs2_emergency_state(osb);
> +	if (ret < 0)
>  		return -EROFS;

ditto

Thanks,
Heming

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
