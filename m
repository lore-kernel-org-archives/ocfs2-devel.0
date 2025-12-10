Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E14B81917F0
	for <ocfs2-devel@lists.linux.dev>; Wed, 10 Dec 2025 14:07:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765375669; cv=none; b=K+51tXHpY4x37tKn/gIuwROGLwww34oN97x9KYQUxq3Dc2EMwOd/vRY2n62EVULNQrIgDGaq5v+OEsL+DF0McjsjbzKussAE+ojjyXqY/xnCcB0fM68NJG6CY5UR7SP0c+s4hbsQeF7HCFX3CrgT6vCZ7vyuuBX4ZNkrN1rb2u8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765375669; c=relaxed/simple;
	bh=ogZa+6arIesRWTgzodx/aR0joAhSm3iUK5N/Y2OiRzk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YAvli6Y1i29m7VTyzo3WPTgNAEWSBwDE7B6k49ck8dYD24nDSi2ksJrwfpfrc8LwXRTUWVlnFPFNEOw/ZwML7Xpoq2dW4+yCUF/vu51H1VjTdnRM0rpc4Dyj2osJoiXHp5FSmAluRoiMaqynnjykU2Qs21KeT2D0Mz5v/cm6SXI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=OCmW5oZh; arc=none smtp.client-ip=209.85.128.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="OCmW5oZh"
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-47928022b93so15008305e9.0
        for <ocfs2-devel@lists.linux.dev>; Wed, 10 Dec 2025 06:07:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1765375665; x=1765980465; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=eWLZd3M877o3u3I/11+9rGxy0fNsuMVl0QU8F5EMYTc=;
        b=OCmW5oZhfGCrTQ+Ndaie4k29wi7mHdjL4R6EnfznEQnS+757t/UyGOxeb/yUKESRGh
         MznfeEFD/BYd348OQxdGlwlg9Sqc6tq9W/7lTFJ68VJHgEZAHo+tvtVM0Fo4bLCHBxnS
         PZB9bAH3HbmMFJ1iw7PHKaCnjC9tSCuD7D+KKtRgjbGIrLue5bg8Mjm3MCr7yF3q0Wcj
         kYS3G/5tXFhP8ZZIfH4nWxEd+g3kHsJEmP5Ez9bOcClvaB39P/zlc6yZmJYg2kzENDco
         fQ/XXaxAvOk+D8T1Ir8RAU6HHXXpPrqej78a6TjQekl7fqBqe/a7FdkxFU6PmB9UGkn5
         ScqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765375665; x=1765980465;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=eWLZd3M877o3u3I/11+9rGxy0fNsuMVl0QU8F5EMYTc=;
        b=Xcruoz33jZvj8Bgw7cTRDYKNhquD8NkHGeGFvrNe7JyNPN7KfTti4JCgCYyQMyQAEa
         sAoFdR44NHnoi93ax7OnMHoTmImkT0RGwjN8rRn1DUXxMK6Sw/1Z9GLeDzuWlh/tk01w
         uAnY0GVuIMit/5Abosis+P/ZTRSbztwPi3TG/Fn092glHd0RUwZFm1WorBw9/hLxcMyw
         b15f/9WNo2y6dxF4xYVRtiz8GQjOn/wB7eXPMN7+eZ8QWp9C0oUYNONF84PBBEQPzkWw
         rUNKt8gmLfOfbq7r0gQjncdH2DKSiostJ5vVS6ieanxCBjLtugHJd2c0rSD4KuY/a9ER
         N7+A==
X-Forwarded-Encrypted: i=1; AJvYcCX42wR8zVMGAYJsU/uNfIKpKbZbzP7ZvZTP2DH5hb0JjBTqFOSewj+W+urUMrzpgalmm3zn/ri/htMo5g==@lists.linux.dev
X-Gm-Message-State: AOJu0YxcgHTng+pE+sG4gk4F5BFgJUED3mFdV8/vUEKZOQ3MO39OKBje
	uVMJcB9BBs7pcsvRb2Otori6qcLcPGXcRiOrPzx2nC64y4eruc4et+OKhAEhG0W3F0I=
X-Gm-Gg: ASbGncsaFVcel+wZMmbfjCKxYijFGtLfXRbVVQgQ2ApCYCcaF1glK3Z39jg9rrFPBSw
	ftDzE1n2VLl3SRLhyhosB0/jxlyEaSIrRCNo3L+xXtekQ7cqN3gj2u2gp1/ozfVO1rybo0cAk+4
	wHZOlpXK/NbZiclEeuHnqCvMK4LgZsvIUFptxPMuE5WTbGGn4BU1VFHoqSlhCFHfRzoHAo5WwUr
	AeMAetUGCKuGoWNFoiIQZEgX4m0QIVlrAQESU9zTjTRaMaU1E/rKGB9PpCzGnDm9nT6TiM25EdS
	0gdC5h663q1WNwanf612wWWvM8PgFfPbaHfSBQyeh5WojwyFb1UAgE0H47DrroDe++TX0YDHWIi
	+Xfg8OhqfqJOO27UsWy/g0PJuxwQGOdNnY2SWyaoBVurnjKNacFVy/LKkreq2m4kPjpUzW/7utl
	k6Fo+dA25bfA==
X-Google-Smtp-Source: AGHT+IFweWxI+8pwyHqFwX9vehmOGakZEjPcTXxauVC0OJARw7mO9h7+Qar+RclAZy5FCpnPdqCXpQ==
X-Received: by 2002:a05:600c:4ecb:b0:477:9c40:2fa1 with SMTP id 5b1f17b1804b1-47a837a9226mr12700335e9.4.1765375665077;
        Wed, 10 Dec 2025 06:07:45 -0800 (PST)
Received: from localhost ([202.127.77.110])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-29dae99fa59sm187939115ad.58.2025.12.10.06.07.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Dec 2025 06:07:44 -0800 (PST)
Date: Wed, 10 Dec 2025 22:07:41 +0800
From: Heming Zhao <heming.zhao@suse.com>
To: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: mark@fasheh.com, jlbec@evilplan.org, ocfs2-devel@lists.linux.dev, 
	linux-kernel@vger.kernel.org, glass.su@suse.com
Subject: Re: [PATCH RESEND v4 2/2] ocfs2: detect released suballocator BG for
 fh_to_[dentry|parent]
Message-ID: <totiw3xkf67vewj3o4bittuk3lhec6sfehmyl7vhd44dhndgkl@76s5s2lcesiw>
References: <20251202063938.9046-1-heming.zhao@suse.com>
 <20251202063938.9046-3-heming.zhao@suse.com>
 <86fe3ab7-943d-415f-822d-ffa2e7c18640@linux.alibaba.com>
 <jegkzhlqfygaxwthju5pijim44gurqxkpjvgxak7geacv35tdx@33lfq6jjv2dj>
 <99870b4d-8fdf-4690-93a2-a206fbb223fe@linux.alibaba.com>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <99870b4d-8fdf-4690-93a2-a206fbb223fe@linux.alibaba.com>

On Wed, Dec 10, 2025 at 05:00:09PM +0800, Joseph Qi wrote:
> 
> 
> On 2025/12/10 12:14, Heming Zhao wrote:
> > On Wed, Dec 10, 2025 at 09:55:03AM +0800, Joseph Qi wrote:
> >>
> >>
> >> On 2025/12/2 14:39, Heming Zhao wrote:
> >>> After ocfs2 gained the ability to reclaim suballocator free block
> >>> group (BGs), a suballocator block group may be released. This change
> >>> causes the xfstest case generic/426 to fail.
> >>>
> >>> generic/426 expects return value -ENOENT or -ESTALE, but the current
> >>> code triggers -EROFS.
> >>>
> >>> Call stack before ocfs2 gained the ability to reclaim bg:
> >>>
> >>> ocfs2_fh_to_dentry //or ocfs2_fh_to_parent
> >>>  ocfs2_get_dentry
> >>>   + ocfs2_test_inode_bit
> >>>   |  ocfs2_test_suballoc_bit
> >>>   |   + ocfs2_read_group_descriptor //Since ocfs2 never releases the bg,
> >>>   |   |                             //the bg block was always found.
> >>>   |   + *res = ocfs2_test_bit //unlink was called, and the bit is zero
> >>>   |
> >>>   + if (!set) //because the above *res is 0
> >>>      status = -ESTALE //the generic/426 expected return value
> >>>
> >>> Current call stack that triggers -EROFS:
> >>>
> >>> ocfs2_get_dentry
> >>>  ocfs2_test_inode_bit
> >>>   ocfs2_test_suballoc_bit
> >>>    ocfs2_read_group_descriptor
> >>>     + if reading a released bg, validation fails and triggers -EROFS
> >>>
> >>> How to fix:
> >>> Since the read BG is already released, we must avoid triggering -EROFS.
> >>> With this commit, we use ocfs2_read_hint_group_descriptor() to detect
> >>> the released BG block. This approach quietly handles this type of error
> >>> and returns -EINVAL, which triggers the caller's existing conversion
> >>> path to -ESTALE.
> >>>
> >>> Signed-off-by: Heming Zhao <heming.zhao@suse.com>
> >>> Reviewed-by: Su Yue <glass.su@suse.com>
> >>> ---
> >>>  fs/ocfs2/suballoc.c | 28 ++++++++++++++++++----------
> >>>  1 file changed, 18 insertions(+), 10 deletions(-)
> >>>
> >>> diff --git a/fs/ocfs2/suballoc.c b/fs/ocfs2/suballoc.c
> >>> index de2f09217142..a126d83ddb1c 100644
> >>> --- a/fs/ocfs2/suballoc.c
> >>> +++ b/fs/ocfs2/suballoc.c
> >>> @@ -3152,7 +3152,7 @@ static int ocfs2_test_suballoc_bit(struct ocfs2_super *osb,
> >>>  	struct ocfs2_group_desc *group;
> >>>  	struct buffer_head *group_bh = NULL;
> >>>  	u64 bg_blkno;
> >>> -	int status;
> >>> +	int status, quiet = 0, released;
> >>>  
> >>>  	trace_ocfs2_test_suballoc_bit((unsigned long long)blkno,
> >>>  				      (unsigned int)bit);
> >>> @@ -3168,11 +3168,15 @@ static int ocfs2_test_suballoc_bit(struct ocfs2_super *osb,
> >>>  
> >>>  	bg_blkno = group_blkno ? group_blkno :
> >>>  		   ocfs2_which_suballoc_group(blkno, bit);
> >>> -	status = ocfs2_read_group_descriptor(suballoc, alloc_di, bg_blkno,
> >>> -					     &group_bh);
> >>> -	if (status < 0) {
> >>> +	status = ocfs2_read_hint_group_descriptor(suballoc, alloc_di, bg_blkno,
> >>> +					     &group_bh, &released);
> >>> +	if (released) {
> >>> +		quiet = 1;
> >>> +		status = -EINVAL;
> >>> +		goto bail;
> >>> +	} else if (status < 0) {
> >>>  		mlog(ML_ERROR, "read group %llu failed %d\n",
> >>> -		     (unsigned long long)bg_blkno, status);
> >>> +				(unsigned long long)bg_blkno, status);
> >>>  		goto bail;
> >>>  	}
> >>>  
> >>> @@ -3182,7 +3186,7 @@ static int ocfs2_test_suballoc_bit(struct ocfs2_super *osb,
> >>>  bail:
> >>>  	brelse(group_bh);
> >>>  
> >>> -	if (status)
> >>> +	if (status && (!quiet))
> >>>  		mlog_errno(status);
> >>>  	return status;
> >>>  }
> >>> @@ -3202,7 +3206,7 @@ static int ocfs2_test_suballoc_bit(struct ocfs2_super *osb,
> >>>   */
> >>>  int ocfs2_test_inode_bit(struct ocfs2_super *osb, u64 blkno, int *res)
> >>>  {
> >>> -	int status;
> >>> +	int status, quiet = 0;
> >>>  	u64 group_blkno = 0;
> >>>  	u16 suballoc_bit = 0, suballoc_slot = 0;
> >>>  	struct inode *inode_alloc_inode;
> >>> @@ -3244,8 +3248,12 @@ int ocfs2_test_inode_bit(struct ocfs2_super *osb, u64 blkno, int *res)
> >>>  
> >>>  	status = ocfs2_test_suballoc_bit(osb, inode_alloc_inode, alloc_bh,
> >>>  					 group_blkno, blkno, suballoc_bit, res);
> >>> -	if (status < 0)
> >>> -		mlog(ML_ERROR, "test suballoc bit failed %d\n", status);
> >>> +	if (status < 0) {
> >>> +		if (status == -EINVAL)
> >>
> >> This seems not right, since there is other case which will also return -EINVAL.
> >> So how about return -ESTALE in this case?
> >>
> >> Thanks,
> >> Joseph
> > 
> > I agree with your idea that we can get a more specific errno, but we might
> > introduce some slightly unnecessary work here.
> > 
> > The ocfs2_test_inode_bit() and ocfs2_test_suballoc_bit() only serve for NFS
> > export paths:
> > 
> > ```
> > ocfs2_fh_to_[dentry|parent]
> >  ocfs2_get_dentry //converts -EINVAL to -ESTALE
> >   ocfs2_test_inode_bit //<== here, current returns -EINVAL
> >    ocfs2_test_suballoc_bit //test the released gd
> > 
> > ocfs2_get_parent //converts -EINVAL to -ESTALE
> >  ocfs2_test_inode_bit //<== here, current returns -EINVAL
> >   ocfs2_test_suballoc_bit
> > ```
> > 
> > the current code design treats -EINVAL as a speical case, converting it to -ESTALE.
> > 
> > If we change the ocfs2_test_inode_bit() return value from -EINVAL to -ESTALE.
> > This will add another special errno in the error handling path.
> > 
> > The code changes are show below:
> > 
> > ```
> > diff --git a/fs/ocfs2/export.c b/fs/ocfs2/export.c
> > index b95724b767e1..8992989b85a5 100644
> > --- a/fs/ocfs2/export.c
> > +++ b/fs/ocfs2/export.c
> > @@ -74,7 +74,7 @@ static struct dentry *ocfs2_get_dentry(struct super_block *sb,
> >               * nice
> >               */
> >              status = -ESTALE;
> > -        } else
> > +        } else if (status != -ESTALE)
> >              mlog(ML_ERROR, "test inode bit failed %d\n", status);
> >          goto unlock_nfs_sync;
> >      }
> > @@ -162,7 +162,7 @@ static struct dentry *ocfs2_get_parent(struct dentry *child)
> >      if (status < 0) {
> >          if (status == -EINVAL) {
> >              status = -ESTALE;
> > -        } else
> > +        } else if (status != -ESTALE)
> >              mlog(ML_ERROR, "test inode bit failed %d\n", status);
> >          parent = ERR_PTR(status);
> >          goto bail_unlock;
> > 
> > diff --git a/fs/ocfs2/suballoc.c b/fs/ocfs2/suballoc.c
> > index c274b649b022..ddcfa6e001e8 100644
> > --- a/fs/ocfs2/suballoc.c
> > +++ b/fs/ocfs2/suballoc.c
> > @@ -3172,7 +3172,7 @@ static int ocfs2_test_suballoc_bit(struct ocfs2_super *osb,
> >                           &group_bh, &released);
> >      if (released) {
> >          quiet = 1;
> > -        status = -EINVAL;
> > +        status = -ESTALE;
> >          goto bail;
> >      } else if (status < 0) {
> >          mlog(ML_ERROR, "read group %llu failed %d\n",
> > @@ -3249,7 +3249,7 @@ int ocfs2_test_inode_bit(struct ocfs2_super *osb, u64 blkno, int *res)
> >      status = ocfs2_test_suballoc_bit(osb, inode_alloc_inode, alloc_bh,
> >                       group_blkno, blkno, suballoc_bit, res);
> >      if (status < 0) {
> > -        if (status == -EINVAL)
> > +        if (status == -ESTALE)
> >              quiet = 1;
> >          else
> >              mlog(ML_ERROR, "test suballoc bit failed %d\n", status);
> > ```
> > 
> > However, I am ok with your approach. If you think it is better to return -ESTALE,
> > I will fix it in the next version.
> > 
> 
> Okay, it seems -EINVAL is also fine. But why you silent the error log
> for -EINVAL? This will also silent another case, which is different from
> before.

You are right, the patch code silents all -EINVAL cases, which is
incorrect logic.

> BTW, why can't we just return 0 in case of release?
> 
> Joseph
> 

There are two reasons why we should return an errno:
1> This is still an abnormal case where user is searching for an inode that
   is already deleted.

2> I am not familiar with NFS. However, the meaning from the xfstests
   generic/426 source code, which calls "open_by_handle -d", and the comment
   at the beginning of the src/open_by_handle.c [1]:

   ```
   6. Get file handles for existing test set, unlink all test files,
      remove test_dir, drop caches, try to open all files by handle
      and expect ESTALE:
   
      open_by_handle -dp <test_dir> [N]
   ```

   The expected return value is '-ESTALE', not '0' (success).

Returning to my patch, I think your previous idea (to return specific
-ESTALE) makes sense. Although we are adding another special error case,
this change keeps the existing error path working as before.

May I sent the v5 patch which includes the change for -ESTALE (using code
similar to my previous email in this thread)?

[1]: https://git.kernel.org/pub/scm/fs/xfs/xfstests-dev.git/tree/src/open_by_handle.c

- Heming
