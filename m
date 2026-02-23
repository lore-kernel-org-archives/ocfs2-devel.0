Received: from mail-pf1-f180.google.com (mail-pf1-f180.google.com [209.85.210.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D2A33375CB
	for <ocfs2-devel@lists.linux.dev>; Mon, 23 Feb 2026 05:05:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771823150; cv=none; b=Py7We9ZJSVi16tZdLbOPvOPXFqmDd/jNic2SPLa2X/CCupnuoKFfZ48lZ2LxVRSmzC/kMcAlT+H063VsRSMQGdlP6Kq11CJgEChhY+DxvhArtdJH7Ae1ROQpypKAcprZkGo7Ve5VS7S6Hdwjt9E73qpsgHpVL79BTulHD7mH3hs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771823150; c=relaxed/simple;
	bh=A9slZ5N0/UsQdOKw3tWJ+4nAFnrshsaCbHTVfHuGwBw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fSq59ommFoEUdbVMVswlDtqFR8uRPvs+dp0TiGTvBNAbVzk3qiP06bvyWlow58lbGXx2mmk4ubbOwO+b9m4E0BLihFLRX5mUUoOVO4sQKf04mrqPtjVzG2SstfxDYQRfYZWw5zqOHv+jEYs+vrUOzPTRBhYkLZLE2ftU52dIO6Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=HW9cneCT; arc=none smtp.client-ip=209.85.210.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="HW9cneCT"
Received: by mail-pf1-f180.google.com with SMTP id d2e1a72fcca58-823075fed75so1674176b3a.1
        for <ocfs2-devel@lists.linux.dev>; Sun, 22 Feb 2026 21:05:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1771823149; x=1772427949; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=5hhZ5RweDCuGAhrMmpm5vtWlUVrdoNXDwump054BM6A=;
        b=HW9cneCTA4eEraxnhO95I6L2DEJq9dJZEMgsY3IGxqCccZAvMCXY8t0r/3J55ctbQ/
         SR8CZI4UI3yXMjuSlJGVG59+BghKTTwPgouWoMnBTpyGJDTj5fANzsRsPRShUI401+Lv
         B6eVEghvO8k7cjQUBzp/mlfky3yUKYprbEunPK/po+Lm+vDOdBH2aF0hGktRj/8L1UEv
         GO5PHJIYPKsmIKU4TDiNOmqf7bkJ/SPA7k5k21Xc6yyNet2a35gu0ToDLL7nBv0WI6OE
         Yr/FBzfP+F8+vleRexgW0j8cb9dGSG8QIOZLP8G2gJ+W8AeRM6x5cfa7MuJ02hkfTnXh
         ZJQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771823149; x=1772427949;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=5hhZ5RweDCuGAhrMmpm5vtWlUVrdoNXDwump054BM6A=;
        b=uvjSrBkQbmi43ZEBlmD91hH4rEzz0+yjChRauY2UK+Iu+pi2ouRqqaeSMWRyheqIKG
         bDkoe6gsAwXBlRqts+Xfktk49eW+HR+1xnsxER08YrLa4AO0Ho0lZHTSwZQqx9wfUbUc
         sY+JaV0+UWQQyM/PPNc+2SsfYmZ6EVnaJ+OUDOg0rOt6lV2uhIYmR1AyE+RJhNHMd9xe
         t5+pHfXxDC5aDpvCPc7ii6/MR5GcMhnQCIuUfwgvcnmMrWzc0FujJbcae4Bhs/NwgE2x
         Tq3daWH47mkC7tszMEgmCPeE5UUiesPhTlSzVFh3GKqxaeB+zl9RgRmKUoiSXJ4oK4zO
         tEXg==
X-Forwarded-Encrypted: i=1; AJvYcCWEm7kQFPr1aiYipTH9zerl9P34YxYlkFiwOqHe+gVH3FN04aScsnwKR7XgoHEwfw7DB3Z0v2w037TlGA==@lists.linux.dev
X-Gm-Message-State: AOJu0YzRpApHHOdjocBUH0hUmHV0l8rcz5oUG8l5LtUatSbYb9tupIB6
	g5tMMTW94RnxKaMExt7ilVw1i3PWjAkno5a+SZjtLWPmj4l+GnuIR+uh
X-Gm-Gg: AZuq6aJqDe5RZZZshvwwb5SCP+bKZVFOzoluZXKasxwLAyscoASQlkxkWnZVR1JK04X
	TW7ky8fAkzHZURLDZzcYv7jwruCxVPdCkSXnltBHF5b/0okaI7ouGDnurpAXKwlhh5xEw/v06N+
	Yop639fH9UwaST7HJAEe3Tku8T0Nb2RWpk8ATYvfAp+4pfNYiLbO6+j4N2EvovDSrQpz2j6kxfA
	n2vRssIq3Kl6Glcq98LJnc45xsxdnbhe8PT8KknG1A+UKlDeZaoWTuS+F8g+KNuTOKhk/vSqrle
	Sft3JUDwhYmeGUtNhF+J8F5tb3pWPAEvWBkusSNYmzyuDDxcfSqmlOyQAZF4riJ03pSGPRHz7rM
	hDAYT90Tb+OgvW8TePIKtsFf161yGhVw8Av3pyPSpFTw1MCnsMoDqNN8E5cfn1C+Tekhv8ai5Yg
	u1novLcllCKruRWXBZEDLpXL4=
X-Received: by 2002:a05:6a00:ab0b:b0:7a2:7058:ab89 with SMTP id d2e1a72fcca58-826db7a962dmr5491545b3a.7.1771823148751;
        Sun, 22 Feb 2026 21:05:48 -0800 (PST)
Received: from inspiron ([111.125.235.136])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-826dd8bc0c8sm5745980b3a.54.2026.02.22.21.05.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 22 Feb 2026 21:05:48 -0800 (PST)
Date: Mon, 23 Feb 2026 10:35:40 +0530
From: Prithvi <activprithvi@gmail.com>
To: willy@infradead.org, joseph.qi@linux.alibaba.com
Cc: mark@fasheh.com, jlbec@evilplan.org, heming.zhao@suse.com,
	ocfs2-devel@lists.linux.dev, linux-kernel@vger.kernel.org,
	linux-kernel-mentees@lists.linux.dev, skhan@linuxfoundation.org,
	david.hunter.linux@gmail.com, khalid@kernel.org
Subject: Re: [PATCH] ocfs2: Fix circular locking dependency in
 ocfs2_del_inode_from_orphan()
Message-ID: <20260223050540.2g44esrm32kpcega@inspiron>
References: <20260106125100.327980-1-activprithvi@gmail.com>
 <94b4189d-dfb6-4443-a336-abbae89d36ad@linux.alibaba.com>
 <20260108183652.ro4xueuj6itfaph3@inspiron>
 <20260115031809.w7ksrj2ostwyxa54@inspiron>
 <aWhxfLwUvHDswsIY@casper.infradead.org>
 <20260216041659.plgrj5tiseeqwbkl@inspiron>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260216041659.plgrj5tiseeqwbkl@inspiron>

On Mon, Feb 16, 2026 at 09:47:08AM +0530, Prithvi wrote:
> On Thu, Jan 15, 2026 at 04:47:56AM +0000, Matthew Wilcox wrote:
> > On Thu, Jan 15, 2026 at 08:48:09AM +0530, Prithvi wrote:
> > > On Fri, Jan 09, 2026 at 12:07:00AM +0530, Prithvi wrote:
> > > > IIUC that would be the case when ocfs2_dio_end_io_write() operates on normal
> > > > files. However, according to the report of the bug, ocfs2_dio_end_io_write()
> > > > is holding &ocfs2_quota_ip_alloc_sem_key so I think due to random fuzzing by 
> > > > syzkaller, the function is curently operating on a quota file.
> > 
> > So the right fix is probably to disallow DIO to a quota file, wouldn't
> > you say?
> 
> Hello all,
> 
> Firstly I apologize for the delay...I was trying to understand the bug in
> detail and few strange things I noticed. I have now confirmed the bug is
> due to uninitialized locks during slab reuse. Here are the deatils:
> 
> According to earlier observations, we knew that a file with a quota lock
> was trying to enter DIO path which is not permitted. I observed that
> that in spite of adding checks like IS_NOQUOTA(inode) since I observed:
> 
> else if (fe->i_flags & cpu_to_le32(OCFS2_QUOTA_FL)) {
>         inode->i_flags |= S_NOQUOTA;
> }
> 
> in ocfs2_populate_inode(). However with this change also the issue didn't
> seem to get resolved.
> 
> I found that it was some inode numbered 16979 which was entering DIO.
> However, upon investigation I noticed that inode 16979 passed through
> ocfs2_populate_inode() only when create_ino = 1. Upon adding a few printk
> statements in __ocfs2_mknod_locked() I found that the inode 16979 strangely
> held ocfs2_quota_ip_allc_sem lock at the mknod stage. I suspected it to be
> a lock cleanup issue in the slab object when inodes are returned to the slab.
> 
> I found that in one mount session, an inode was mounted as a quota file,
> with a very small number (mostly <50) then later on in another mount session
> that same slab object is reused for the inode with number 16979 which
> immediately causes the lockdep warning to occur since it still holds the
> quota_ip_alloc_sem lock.
> 
> IIUC, I did not find any way the semaphore is cleaned when an inode is
> evicted. Hence I think to add init_rwsem() to the ocfs2_clear_inode() to
> stop the warning, since now that inode held ip_alloc_sem lock only, thus
> no quota lock acquired during DIO and the issue never occurs, even if same
> slab object is used which retains the lock identity. In addition, a check
> can be added to block DIO on quota files.
> 
> Thus, I think the following change should work:
> 
> diff --git a/fs/ocfs2/aops.c b/fs/ocfs2/aops.c
> index 76c86f1c2b1c..372c198afa25 100644
> --- a/fs/ocfs2/aops.c
> +++ b/fs/ocfs2/aops.c
> @@ -2420,7 +2420,13 @@ static ssize_t ocfs2_direct_IO(struct kiocb *iocb, struct iov_iter *iter)
>         struct inode *inode = file->f_mapping->host;
>         struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
>         get_block_t *get_block;
> -
> +
> +       if(IS_NOQUOTA(inode)) {
> +               mlog(ML_ERROR, "Direct IO is not allowed for Quota inode %lu\n",
> +                    inode->i_ino);
> +               return -ENOTSUP;
> +       }
> +
>         /*
>          * Fallback to buffered I/O if we see an inode without
>          * extents.
> diff --git a/fs/ocfs2/inode.c b/fs/ocfs2/inode.c
> index b5fcc2725a29..3e36da2ca5d0 100644
> --- a/fs/ocfs2/inode.c
> +++ b/fs/ocfs2/inode.c
> @@ -1268,7 +1268,8 @@ static void ocfs2_clear_inode(struct inode *inode)
>                         "Clear inode of %llu, alloc_sem is locked\n",
>                         (unsigned long long)oi->ip_blkno);
>         up_write(&oi->ip_alloc_sem);
> -
> +       init_rwsem(&oi->ip_alloc_sem);
> +
>         mlog_bug_on_msg(oi->ip_open_count,
>                         "Clear inode of %llu has open count %d\n",
>                         (unsigned long long)oi->ip_blkno, oi->ip_open_count);
> 
> What do you think?
> 
> Thank you and best regards,
> Prithvi

Hello everyone,

Just a gentle ping on this thread...I wanted to seek feedback regarding the
analysis of uninitialized locks during slab reuse. If the proposed fix is 
correct, I can go ahead and send a v2 patch for the same.

In addition, I also realised using -EPERM in the if condition in 
ocfs2_direct_IO() might be more relevant so I tested a patch with that change 
and it doesn't trigger any issue with the testing with reproducer program as 
tested here :
https://lore.kernel.org/all/66fdfef3.050a0220.9ec68.0031.GAE@google.com/T/#m00f39888c9cfdb78b2c5eff8d1e2cba82e4fd9cc

Thanks,
Prithvi
