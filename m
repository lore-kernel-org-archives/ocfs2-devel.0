Received: from mail-ed1-f50.google.com (mail-ed1-f50.google.com [209.85.208.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43483200C2
	for <ocfs2-devel@lists.linux.dev>; Wed,  3 Dec 2025 00:46:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764722780; cv=none; b=E2Rrr2s1kqvotbVeJovk2Uz+QPqM+jxMQFepYPMzWR6tufkFlq54e7VzUc4NWKOYpRrDCE+1TZ5ud1EW/QlXgayjg1CdnxovELLUs/kRuVwbNPFoM0eIwbg3TqX/W6QHqQCnWso8ejJg6HCtvBeklrhRI8s81rGtBmz5Ja/4Uyg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764722780; c=relaxed/simple;
	bh=nHdt84ZjEzBqNYLxZmCgeYQL14OE7DgE4baxn++S2R0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Ibycyg3UuC+nV01199UPhC65q3l4taZjFGYpvEt/2KOkNLjSmdiOhTFHxBmZ7W2fiMynLCPKHpS+yE+GncIl16AUBIvVzECuz2RuqJL3b0TJMtVvmr/bqgD4ZKUhUPDe4OZYIQ5Nqvzx9xKDmBa0qOlDyoKPzBs73fsev3p0VrY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=k8fpebND; arc=none smtp.client-ip=209.85.208.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="k8fpebND"
Received: by mail-ed1-f50.google.com with SMTP id 4fb4d7f45d1cf-6418738efa0so10064257a12.1
        for <ocfs2-devel@lists.linux.dev>; Tue, 02 Dec 2025 16:46:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764722776; x=1765327576; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=a+0LCODfOxuHDhxUd2wstZZd7HqWgVnU+nY6DXuITbM=;
        b=k8fpebNDIQp29bpaGxv+bU8qhJ20YHN7ea0SW6UHCnvF1Wj5Ap4EB/oRPJq3NIMeRp
         bMRFfZU2l4LH9JEigOn8SGkJhf+4zRtPcFbwsOUTKnRv9nnuSakd05TOB4939ozS19o8
         exzNB7D/QXe9QiImoEGBS5rNfDUO90PXZI/UKgd72L1KkVWiAdcbPIZHLsxNlyOEITHY
         cuqJ0gIZp1eeRQpvhlwTPRrp3KzmRWVMRyuTpfLFJH4TLu5PpFtpw/L07Lzfiq57oHTS
         AOz6QkJU3MOhj0KrOpCP4SYZZkfrlxnTOo84QNNlsUuYrX8B6UFQ0nK0RoY6MDC3D/G9
         EHfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764722776; x=1765327576;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=a+0LCODfOxuHDhxUd2wstZZd7HqWgVnU+nY6DXuITbM=;
        b=ap8xDS+eyciVyRXV20D+Xv6wOTlPyV61QjEijA0OwU5n2H9IfIPxQHim6iFQx5qWSz
         aoIYLzuiAI3JL6o337I9U7EfuAHRkdRm8N1it5l4ugMScMRdMJDn69vIexkM8nvU2nGH
         z2Gb10n5RNVAm/pbreg6mgZXQVbgykEJuCkVhhK2fSNIc7qwBXY60DRzDv4sPD/SDktH
         saI59At2m9ue0kcno72df9odT0t9S4HobtGnZxKcGQtNdKqcFeazzc8YzASiCSmYRzBp
         6obEvWjNhy4JWBY0uWLtpDk/W8+RhEAoTS2HVJ6Uv0mc+Dq8XP0hS6jVYZ9I5VKGjj0D
         CyUA==
X-Forwarded-Encrypted: i=1; AJvYcCU3awkciL8RwiXP2MbG8ATOx2S/1UiPd4UisR1N1cnj9zcqwfC4ooL1lBxWKVZgjQGI+IUzxv4JFItsPA==@lists.linux.dev
X-Gm-Message-State: AOJu0YyegHFtCmUP072D66ZRpa/UNTT4cQnzMGwXOIvix3Rehq9s1OWN
	/CW4RrctwxlfjCdgke0LR1xtpUJnh4DkYgZj1VORYISsr2T9wGTxmSUq
X-Gm-Gg: ASbGncsShTak3IJYFYD8Ou/Sb1O8N8L4UtMwlPJnl1tsiNFnRypTjDQ8urZOguBgIE7
	qbN4PcldIE2W58fWHWOz1pkH28kXbhcPEN3AVFFqGLP+d9JWDFWTbWFbo2D5MGZ1HG9Q23AuV5h
	4knDfdTelNKDRhr/Gcy1abl7UcAgUFj0rx3vNGHL8Fef8USfuGOSJmMaP6wkZI3OE2YKgklH3pg
	Qcn6AigJIy6dRWW1CWg6Ijd+2XA+zlDX925Aqh1EBFIRG54c9tF5jAAMS56AV24lyjdhkTGwVpP
	kYJKz8/wD/0OmGn6sDLFgcTh+4c9iji6Jloxnm4sAjGmUB+rwQPsxHbNXea3oxGIQK8Cs5wAvbE
	go++5Ytfsl7wkoEsfm3nZAIC1lv18tmtz1lTL9pY44l8rCEgukchtkVAWev/OWMfoWCO5Tv95pq
	2GezT0K1gW
X-Google-Smtp-Source: AGHT+IHUOwfxYIkkf2qb/suy5KRJyZ1inkjKkPvQQHII4vqEiu9VOrvDZwF6puZHMAyJWWV8TyPORw==
X-Received: by 2002:a17:907:60cb:b0:b76:23df:c997 with SMTP id a640c23a62f3a-b79dc7bca81mr30441166b.54.1764722776238;
        Tue, 02 Dec 2025 16:46:16 -0800 (PST)
Received: from eray-kasa ([2a02:4e0:2d14:1a1:acf7:8de5:59bc:44c3])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b76f51c8393sm1645524866b.31.2025.12.02.16.46.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Dec 2025 16:46:15 -0800 (PST)
Date: Wed, 3 Dec 2025 03:46:13 +0300
From: Ahmet Eray Karadag <eraykrdg1@gmail.com>
To: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: mark@fasheh.com, jlbec@evilplan.org, Heming Zhao <heming.zhao@suse.com>,
	ocfs2-devel@lists.linux.dev, linux-kernel@vger.kernel.org,
	david.hunter.linux@gmail.com, skhan@linuxfoundation.org,
	Albin Babu Varghese <albinbabuvarghese20@gmail.com>
Subject: Re: [PATCH v3 2/2] ocfs2: Convert remaining read-only checks to
 ocfs2_emergency_state
Message-ID: <aS-IVZyCZgE115f6@eray-kasa>
References: <cover.1764643790.git.eraykrdg1@gmail.com>
 <1f329fa8f8b0496ecb88c6c48174ca3d8e339f8d.1764643790.git.eraykrdg1@gmail.com>
 <1636840d-0b22-4df7-8a54-2795583ae83d@linux.alibaba.com>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1636840d-0b22-4df7-8a54-2795583ae83d@linux.alibaba.com>

On Tue, Dec 02, 2025 at 03:39:30PM +0800, Joseph Qi wrote:
> 
> 
> On 2025/12/2 10:54, Ahmet Eray Karadag wrote:
> > To centralize error checking, follow the pattern of other filesystems
> > like ext4 (which uses `ext4_emergency_state()`), and prepare for
> > future enhancements, this patch introduces a new helper function:
> > `ocfs2_emergency_state()`.
> > 
> > The purpose of this helper is to provide a single, unified location
> > for checking all filesystem-level emergency conditions. In this
> > initial implementation, the function only checks for the existing
> > hard and soft read-only modes, returning -EROFS if either is set.
> > 
> > This provides a foundation where future checks (e.g., for fatal error
> > states returning -EIO, or shutdown states) can be easily added in
> > one place.
> > 
> > This patch also adds this new check to the beginning of
> > `ocfs2_setattr()`. This ensures that operations like `ftruncate`
> > (which triggered the original BUG) fail-fast with -EROFS when the
> > filesystem is already in a read-only state.
> > 
> 
> The above commit log is the same with patch 1 and doesn't reflect
> the following changes.
> 
> > Co-developed-by: Albin Babu Varghese <albinbabuvarghese20@gmail.com>
> > Signed-off-by: Albin Babu Varghese <albinbabuvarghese20@gmail.com>
> > Signed-off-by: Ahmet Eray Karadag <eraykrdg1@gmail.com>
> > ---
> > v2:
> >  - Use `unlikely()` for status check
> > ---
> >  fs/ocfs2/buffer_head_io.c |  4 ++--
> >  fs/ocfs2/file.c           | 17 ++++++++++-------
> >  fs/ocfs2/inode.c          |  3 +--
> >  fs/ocfs2/move_extents.c   |  5 +++--
> >  fs/ocfs2/resize.c         |  8 +++++---
> >  fs/ocfs2/super.c          |  2 +-
> >  6 files changed, 22 insertions(+), 17 deletions(-)
> > 
> > diff --git a/fs/ocfs2/buffer_head_io.c b/fs/ocfs2/buffer_head_io.c
> > index 8f714406528d..61a0f522c673 100644
> > --- a/fs/ocfs2/buffer_head_io.c
> > +++ b/fs/ocfs2/buffer_head_io.c
> > @@ -434,8 +434,8 @@ int ocfs2_write_super_or_backup(struct ocfs2_super *osb,
> >  	BUG_ON(buffer_jbd(bh));
> >  	ocfs2_check_super_or_backup(osb->sb, bh->b_blocknr);
> >  
> > -	if (ocfs2_is_hard_readonly(osb) || ocfs2_is_soft_readonly(osb)) {
> > -		ret = -EROFS;
> > +	ret = ocfs2_emergency_state(osb);
> > +	if (unlikely(ret)) {
> 
> I'd like use the following style:
> if (ocfs2_emergency_state(osb)) {
> 	ret = -EROFS;
> 	...
> }
> 
> So that ocfs2_emergency_state() can be expended with other cases(properly
> other return code), without touching these code flows.

In the future, there might be other return codes added to ocfs2_emergency_state().
Correct me if I'm wrong, but with your proposed style, we would only return
-EROFS in any case. Shouldn't we consider future improvements?

Thanks,
Ahmet Eray
> 
> Joseph
> 
> >  		mlog_errno(ret);
> >  		goto out;
> >  	}
> > diff --git a/fs/ocfs2/file.c b/fs/ocfs2/file.c
> > index 253b4f300127..540b35ec02e2 100644
> > --- a/fs/ocfs2/file.c
> > +++ b/fs/ocfs2/file.c
> > @@ -179,8 +179,9 @@ static int ocfs2_sync_file(struct file *file, loff_t start, loff_t end,
> >  			      file->f_path.dentry->d_name.name,
> >  			      (unsigned long long)datasync);
> >  
> > -	if (ocfs2_is_hard_readonly(osb) || ocfs2_is_soft_readonly(osb))
> > -		return -EROFS;
> > +	ret = ocfs2_emergency_state(osb);
> > +	if (unlikely(ret))
> > +		return ret;
> >  
> >  	err = file_write_and_wait_range(file, start, end);
> >  	if (err)
> > @@ -209,7 +210,7 @@ int ocfs2_should_update_atime(struct inode *inode,
> >  	struct timespec64 now;
> >  	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
> >  
> > -	if (ocfs2_is_hard_readonly(osb) || ocfs2_is_soft_readonly(osb))
> > +	if (unlikely(ocfs2_emergency_state(osb)))
> >  		return 0;
> >  
> >  	if ((inode->i_flags & S_NOATIME) ||
> > @@ -1949,8 +1950,9 @@ static int __ocfs2_change_file_space(struct file *file, struct inode *inode,
> >  	handle_t *handle;
> >  	unsigned long long max_off = inode->i_sb->s_maxbytes;
> >  
> > -	if (ocfs2_is_hard_readonly(osb) || ocfs2_is_soft_readonly(osb))
> > -		return -EROFS;
> > +	ret = ocfs2_emergency_state(osb);
> > +	if (unlikely(ret))
> > +		return ret;
> >  
> >  	inode_lock(inode);
> >  
> > @@ -2713,8 +2715,9 @@ static loff_t ocfs2_remap_file_range(struct file *file_in, loff_t pos_in,
> >  		return -EINVAL;
> >  	if (!ocfs2_refcount_tree(osb))
> >  		return -EOPNOTSUPP;
> > -	if (ocfs2_is_hard_readonly(osb) || ocfs2_is_soft_readonly(osb))
> > -		return -EROFS;
> > +	ret = ocfs2_emergency_state(osb);
> > +	if (unlikely(ret))
> > +		return ret;
> >  
> >  	/* Lock both files against IO */
> >  	ret = ocfs2_reflink_inodes_lock(inode_in, &in_bh, inode_out, &out_bh);
> > diff --git a/fs/ocfs2/inode.c b/fs/ocfs2/inode.c
> > index fcc89856ab95..b7dad049cfa3 100644
> > --- a/fs/ocfs2/inode.c
> > +++ b/fs/ocfs2/inode.c
> > @@ -1586,8 +1586,7 @@ static int ocfs2_filecheck_repair_inode_block(struct super_block *sb,
> >  	trace_ocfs2_filecheck_repair_inode_block(
> >  		(unsigned long long)bh->b_blocknr);
> >  
> > -	if (ocfs2_is_hard_readonly(OCFS2_SB(sb)) ||
> > -	    ocfs2_is_soft_readonly(OCFS2_SB(sb))) {
> > +	if (unlikely(ocfs2_emergency_state(OCFS2_SB(sb)))) {
> >  		mlog(ML_ERROR,
> >  		     "Filecheck: cannot repair dinode #%llu "
> >  		     "on readonly filesystem\n",
> > diff --git a/fs/ocfs2/move_extents.c b/fs/ocfs2/move_extents.c
> > index 86f2631e6360..9d2a2d054aa1 100644
> > --- a/fs/ocfs2/move_extents.c
> > +++ b/fs/ocfs2/move_extents.c
> > @@ -898,8 +898,9 @@ static int ocfs2_move_extents(struct ocfs2_move_extents_context *context)
> >  	struct buffer_head *di_bh = NULL;
> >  	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
> >  
> > -	if (ocfs2_is_hard_readonly(osb) || ocfs2_is_soft_readonly(osb))
> > -		return -EROFS;
> > +	status = ocfs2_emergency_state(osb);
> > +	if (unlikely(status))
> > +		return status;
> >  
> >  	inode_lock(inode);
> >  
> > diff --git a/fs/ocfs2/resize.c b/fs/ocfs2/resize.c
> > index b0733c08ed13..ae30ae67e220 100644
> > --- a/fs/ocfs2/resize.c
> > +++ b/fs/ocfs2/resize.c
> > @@ -276,8 +276,9 @@ int ocfs2_group_extend(struct inode * inode, int new_clusters)
> >  	u32 first_new_cluster;
> >  	u64 lgd_blkno;
> >  
> > -	if (ocfs2_is_hard_readonly(osb) || ocfs2_is_soft_readonly(osb))
> > -		return -EROFS;
> > +	ret = ocfs2_emergency_state(osb);
> > +	if (unlikely(ret))
> > +		return ret;
> >  
> >  	if (new_clusters < 0)
> >  		return -EINVAL;
> > @@ -466,7 +467,8 @@ int ocfs2_group_add(struct inode *inode, struct ocfs2_new_group_input *input)
> >  	u16 cl_bpc;
> >  	u64 bg_ptr;
> >  
> > -	if (ocfs2_is_hard_readonly(osb) || ocfs2_is_soft_readonly(osb))
> > +	ret = ocfs2_emergency_state(osb);
> > +	if (unlikely(ret))
> >  		return -EROFS;
> >  
> >  	main_bm_inode = ocfs2_get_system_file_inode(osb,
> > diff --git a/fs/ocfs2/super.c b/fs/ocfs2/super.c
> > index 53daa4482406..c6019d260efc 100644
> > --- a/fs/ocfs2/super.c
> > +++ b/fs/ocfs2/super.c
> > @@ -2487,7 +2487,7 @@ static int ocfs2_handle_error(struct super_block *sb)
> >  		rv = -EIO;
> >  	} else { /* default option */
> >  		rv = -EROFS;
> > -		if (sb_rdonly(sb) && (ocfs2_is_soft_readonly(osb) || ocfs2_is_hard_readonly(osb)))
> > +		if (sb_rdonly(sb) && ocfs2_emergency_state(osb))
> >  			return rv;
> >  
> >  		pr_crit("OCFS2: File system is now read-only.\n");
> 
