Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A66F97262D
	for <ocfs2-devel@lists.linux.dev>; Fri, 12 Dec 2025 07:36:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765524978; cv=none; b=Mf631lnqNzBvKyYiW7lWXIYsFrCptoy7OtlOvVeXfissBRdBT/FSsc9kJpBMxkBvrYYvDktCH+lCtMF0eyC3CTFcwl/je4lzvfatchL4l8uCAT9G6ce2Dbz+RMH0rax5PJY7DGmmzS9dDkY4NwvtXUhTTCNYK6uk2Ct3FNZblZM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765524978; c=relaxed/simple;
	bh=b37QwQGWCIgUdpzizHalyzwMGx3pftjUGIeI6JoRWbA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=eVu+dS78u9aot+1gPfhFlFN918p32cP9nczM48XFmjLjrdRlmCxVqX4urEAEgwV773apUV2x+BKjPWTRG/rcfjm+dPX51Xyq1k635lgsfYeuRt8OeA5UA21OSPPq2LbnG2S9PGXH6DuGC97KQkN3ksnCGQnO/VTcthILBtBjvCY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=eRxCUyk+; arc=none smtp.client-ip=209.85.128.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="eRxCUyk+"
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-4779f9696e7so864295e9.2
        for <ocfs2-devel@lists.linux.dev>; Thu, 11 Dec 2025 23:36:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1765524974; x=1766129774; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=tcHLwHqu4x+0zKO6/tEJ0XbaeG2IUqs/hu6xtHkH+5A=;
        b=eRxCUyk+yRHRJxmV9fXJhu6Im1ZgcJqacj3uy3yw+Cbhkdi6mebY2WI/DMR5EJcOr2
         X1LBZazbGprEzfHKNz6rJ0myyIbgdAFp5bgCTI1ydrABHNX31Ke5SU5W/ry0tU5THcQS
         qrzqmkqGtSCBS9Z3OKZp85euigRg6NLLWqvigV/TZqzaH38UbegiM867I/YJPf/uMdhB
         fi0ukXUExAT9nW5XxxFIz69Yq3ytSPYO2kmb1ewngUncszqxyiQjAX+7hLASflYR6+aO
         JJBfMf16vhDImWe5p7hVr4DeZqqUuRc/+GJgzqGjalcV7fI5QXEWHzvRBvNWjai4Zi1/
         PQPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765524974; x=1766129774;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=tcHLwHqu4x+0zKO6/tEJ0XbaeG2IUqs/hu6xtHkH+5A=;
        b=Cu+gP6VJaEwSzsg53gzC577eddxvMgAAHAatPy4TqRSJKChVRm89aBWnAw1pf0xEcW
         J39lHaIg/C+rP9g2BOmajwVoFQHnbgOOw8z5CfG7pcoMz/BQpTylh9p+x9dMw/meqjSQ
         FyR0z5OwgOtMYVU1xCcnhVMrm1mDI+xXsSVAaVOiNUDmmu2D1XhDoAHiRsXNwabd8CAU
         YTdPVNdAC4fMSHYQSLUfkxvBEqYdCKwuJtjExwTWS/IiLl1MfJjuNlTOFyX0CrWmVDeF
         Xg/0ABNSA+INxMi3zp9Kcolof4M7aqi6dqT7p9UnB905uqhBxLCdm9YG+nG3ih7sVbW7
         nczw==
X-Forwarded-Encrypted: i=1; AJvYcCWqUg/FOxFesdKTBtnl1TCOpkMi9KUokFqdptBrmOspZjIJ/V6LZUkkFeVJaEbOJLjoDxUbB1jIAdPyzQ==@lists.linux.dev
X-Gm-Message-State: AOJu0YxOywhdvPKs3L4YcBAY9mrozsfbYwkxMiCqI4X/pIV13fbtWnXy
	g/g4Hl6HXXCceWziVxZzTdfeyQzPsNpVH+D1R3eWTMq5CDM4vucyXSlb2lLJ6hoKlC0=
X-Gm-Gg: AY/fxX4yArbhmneVQmUVCFubQ8v2EPE899rXv83zDsSBadvhIxL0dL98qa0qJ0//8vE
	eCPmcCNtJofJ93JzcsXABiwyx3FlrzRjWq3begMFdcqTeQIMbRjaWJPkQHUgSeQNv607cMiMQYd
	iy1TAWyoeIRqxWsDp3aDogYJzNK1xxZDAyiTbJO5TGUB6w5MASiWoe6oJis+PDAOe1/K0M/C0oR
	9+K25M2lcvThkz1jKSOBdtRf+PXRNWjUCJV8b3NdThhhpOw2Mv7K4HvJNV3mMjWx0Kon2yI7S72
	HKINsInQh/5ExuVRv8t+JQk60OLqIoB7/Q7eoPUlVH1iqajiMKujD7lrrxNkQjYwalVNkUTt7pB
	d9RBPMUd4wQyRalbt3TDwXI9CLfhT4C3pnPtFAh2lLZ7h28Ejn4kC3r3nXpBJmRpcil01/GgNEN
	fma/NonJCRlA==
X-Google-Smtp-Source: AGHT+IE6b7l182EdK/83vGk8Gfkhs8c/cIWaHVwTl8O88vPcgAGPie+m8gldcK/sS3+iP49jG/BIAw==
X-Received: by 2002:a05:600c:4f84:b0:477:a6f1:499d with SMTP id 5b1f17b1804b1-47a8f9187c7mr6433285e9.3.1765524973925;
        Thu, 11 Dec 2025 23:36:13 -0800 (PST)
Received: from localhost ([202.127.77.110])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-29ee9b36a8csm44782395ad.1.2025.12.11.23.36.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Dec 2025 23:36:13 -0800 (PST)
Date: Fri, 12 Dec 2025 15:36:11 +0800
From: Heming Zhao <heming.zhao@suse.com>
To: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: mark@fasheh.com, jlbec@evilplan.org, ocfs2-devel@lists.linux.dev, 
	linux-kernel@vger.kernel.org, glass.su@suse.com
Subject: Re: [PATCH v5 2/2] ocfs2: detect released suballocator BG for
 fh_to_[dentry|parent]
Message-ID: <llq2ndi7kod5sencvhhf5g4cu7xsr4j4xgxigatwby6a6pr7tm@ngstdzk7th22>
References: <20251212070016.24235-1-heming.zhao@suse.com>
 <20251212070016.24235-3-heming.zhao@suse.com>
 <62b99931-75c4-4a13-8d79-98f71ed46718@linux.alibaba.com>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <62b99931-75c4-4a13-8d79-98f71ed46718@linux.alibaba.com>

On Fri, Dec 12, 2025 at 03:12:53PM +0800, Joseph Qi wrote:
> 
> 
> On 2025/12/12 15:00, Heming Zhao wrote:
> > After ocfs2 gained the ability to reclaim suballocator free block
> > group (BGs), a suballocator block group may be released. This change
> > causes the xfstest case generic/426 to fail.
> > 
> > generic/426 expects return value -ENOENT or -ESTALE, but the current
> > code triggers -EROFS.
> > 
> > Call stack before ocfs2 gained the ability to reclaim bg:
> > 
> > ocfs2_fh_to_dentry //or ocfs2_fh_to_parent
> >  ocfs2_get_dentry
> >   + ocfs2_test_inode_bit
> >   |  ocfs2_test_suballoc_bit
> >   |   + ocfs2_read_group_descriptor //Since ocfs2 never releases the bg,
> >   |   |                             //the bg block was always found.
> >   |   + *res = ocfs2_test_bit //unlink was called, and the bit is zero
> >   |
> >   + if (!set) //because the above *res is 0
> >      status = -ESTALE //the generic/426 expected return value
> > 
> > Current call stack that triggers -EROFS:
> > 
> > ocfs2_get_dentry
> >  ocfs2_test_inode_bit
> >   ocfs2_test_suballoc_bit
> >    ocfs2_read_group_descriptor
> >     + if reading a released bg, validation fails and triggers -EROFS
> > 
> > How to fix:
> > Since the read BG is already released, we must avoid triggering -EROFS.
> > With this commit, we use ocfs2_read_hint_group_descriptor() to detect
> > the released BG block. This approach quietly handles this type of error
> > and returns -EINVAL, which triggers the caller's existing conversion
> > path to -ESTALE.
> > 
> > Signed-off-by: Heming Zhao <heming.zhao@suse.com>
> > Reviewed-by: Su Yue <glass.su@suse.com>
> > ---
> >  fs/ocfs2/export.c   |  6 ++++--
> >  fs/ocfs2/suballoc.c | 28 ++++++++++++++++++----------
> >  2 files changed, 22 insertions(+), 12 deletions(-)
> > 
> > diff --git a/fs/ocfs2/export.c b/fs/ocfs2/export.c
> > index b95724b767e1..9c2665dd24e2 100644
> > --- a/fs/ocfs2/export.c
> > +++ b/fs/ocfs2/export.c
> > @@ -74,8 +74,9 @@ static struct dentry *ocfs2_get_dentry(struct super_block *sb,
> >  			 * nice
> >  			 */
> >  			status = -ESTALE;
> > -		} else
> > +		} else if (status != -ESTALE) {
> >  			mlog(ML_ERROR, "test inode bit failed %d\n", status);
> > +		}
> >  		goto unlock_nfs_sync;
> >  	}
> >  
> > @@ -162,8 +163,9 @@ static struct dentry *ocfs2_get_parent(struct dentry *child)
> >  	if (status < 0) {
> >  		if (status == -EINVAL) {
> >  			status = -ESTALE;
> > -		} else
> > +		} else if (status != -ESTALE) {
> >  			mlog(ML_ERROR, "test inode bit failed %d\n", status);
> > +		}
> >  		parent = ERR_PTR(status);
> >  		goto bail_unlock;
> >  	}
> > diff --git a/fs/ocfs2/suballoc.c b/fs/ocfs2/suballoc.c
> > index 9a19f5230c8c..ddcfa6e001e8 100644
> > --- a/fs/ocfs2/suballoc.c
> > +++ b/fs/ocfs2/suballoc.c
> > @@ -3152,7 +3152,7 @@ static int ocfs2_test_suballoc_bit(struct ocfs2_super *osb,
> >  	struct ocfs2_group_desc *group;
> >  	struct buffer_head *group_bh = NULL;
> >  	u64 bg_blkno;
> > -	int status;
> > +	int status, quiet = 0, released;
> >  
> >  	trace_ocfs2_test_suballoc_bit((unsigned long long)blkno,
> >  				      (unsigned int)bit);
> > @@ -3168,11 +3168,15 @@ static int ocfs2_test_suballoc_bit(struct ocfs2_super *osb,
> >  
> >  	bg_blkno = group_blkno ? group_blkno :
> >  		   ocfs2_which_suballoc_group(blkno, bit);
> > -	status = ocfs2_read_group_descriptor(suballoc, alloc_di, bg_blkno,
> > -					     &group_bh);
> > -	if (status < 0) {
> > +	status = ocfs2_read_hint_group_descriptor(suballoc, alloc_di, bg_blkno,
> > +					     &group_bh, &released);
> > +	if (released) {
> > +		quiet = 1;
> > +		status = -ESTALE;
> > +		goto bail;
> > +	} else if (status < 0) {
> >  		mlog(ML_ERROR, "read group %llu failed %d\n",
> > -		     (unsigned long long)bg_blkno, status);
> > +				(unsigned long long)bg_blkno, status);

OK
> 
> This can be kept untouched.
> 
> >  		goto bail;
> >  	}
> >  
> > @@ -3182,7 +3186,7 @@ static int ocfs2_test_suballoc_bit(struct ocfs2_super *osb,
> >  bail:
> >  	brelse(group_bh);
> >  
> > -	if (status)
> > +	if (status && (!quiet))
> 
> '!quiet' is enough, the parentheses is unneeded.

OK. Very interesting, this is not my code style.
Thanks for your careful review.

Heming
> 
> Other looks good to me.
> 
> Thanks,
> Joseph
> 
> >  		mlog_errno(status);
> >  	return status;
> >  }
> > @@ -3202,7 +3206,7 @@ static int ocfs2_test_suballoc_bit(struct ocfs2_super *osb,
> >   */
> >  int ocfs2_test_inode_bit(struct ocfs2_super *osb, u64 blkno, int *res)
> >  {
> > -	int status;
> > +	int status, quiet = 0;
> >  	u64 group_blkno = 0;
> >  	u16 suballoc_bit = 0, suballoc_slot = 0;
> >  	struct inode *inode_alloc_inode;
> > @@ -3244,8 +3248,12 @@ int ocfs2_test_inode_bit(struct ocfs2_super *osb, u64 blkno, int *res)
> >  
> >  	status = ocfs2_test_suballoc_bit(osb, inode_alloc_inode, alloc_bh,
> >  					 group_blkno, blkno, suballoc_bit, res);
> > -	if (status < 0)
> > -		mlog(ML_ERROR, "test suballoc bit failed %d\n", status);
> > +	if (status < 0) {
> > +		if (status == -ESTALE)
> > +			quiet = 1;
> > +		else
> > +			mlog(ML_ERROR, "test suballoc bit failed %d\n", status);
> > +	}
> >  
> >  	ocfs2_inode_unlock(inode_alloc_inode, 0);
> >  	inode_unlock(inode_alloc_inode);
> > @@ -3253,7 +3261,7 @@ int ocfs2_test_inode_bit(struct ocfs2_super *osb, u64 blkno, int *res)
> >  	iput(inode_alloc_inode);
> >  	brelse(alloc_bh);
> >  bail:
> > -	if (status)
> > +	if (status && !quiet)
> >  		mlog_errno(status);
> >  	return status;
> >  }
> 
