Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB02F2AD25
	for <ocfs2-devel@lists.linux.dev>; Wed, 10 Dec 2025 04:14:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765340079; cv=none; b=g6JTdksSAO3e/608n/BHNcayl7F31JU8CYOq3hdpMF4Qjh8cnu9wlukHaDtWnnWhr4YKDPhdbzw9CPxb5+n+nyI8szDjqQnAdP8XEBQZZV1zz8tKJwJeKINnt8m2oIrq950gKAu8fugE8RxlfgCChjJC+dJLsVQdigjHKfO++hs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765340079; c=relaxed/simple;
	bh=mr3N2fWgLYMu6m4vq7AkQ1seEJQ+zYQhE22f65nQySw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JA91sR0mRa7/QYYdsvvq8kbMKTgkeqq1XHJCr8xYvq2+2r8cLX6Tnag4E/q+4ZVpsnG/E8Fc8ZqeygjRMf9MDOKnAspMXpHeWN+WQX+xXrYzphLBAJ201pCau4KJSIg5Sv3tEpd+buKPe7P4Stsz427d3ujVcogvrUoFUocFymM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=FydDRuMM; arc=none smtp.client-ip=209.85.128.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="FydDRuMM"
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-47798f4059fso8089205e9.2
        for <ocfs2-devel@lists.linux.dev>; Tue, 09 Dec 2025 20:14:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1765340075; x=1765944875; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=tTElslg8Yurnu7DuPZq6V5Olt+D51kChSN1kWLBr5vA=;
        b=FydDRuMMRmT5B1obCwFeIDJYhOXAqwAqhATzJGvmhafnwGE8Xwupqx0fsuBN0D/B7x
         ZqdxfP63S/FPibjb8Mvg62UacS/jVx4SSBurcWDkXd/+od8A/oN9jHukl30Hnogoy/u6
         AQrAkS0bOk7Sh1tgFJRNJjn5rp1zI/06rRZP5OSOAfLIX4NfQUYAsWHVWYFXEZftDv+k
         idv2bg9fa8ErRNcw9cI21O/7R6svzD6lpnghHCcJQgXZKOlko1nGsY1qxonNYR5r1F3Q
         KBuVS/Cm8epO6TGFjnpLe2A3ifYlhgUldCYVowhtAVNvsP2fEGMLqRQMKZ2shhYrEfSx
         ax6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765340075; x=1765944875;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=tTElslg8Yurnu7DuPZq6V5Olt+D51kChSN1kWLBr5vA=;
        b=kuVbJTXgRgkI4IXXEkY++zxGOoTyUqkr4vvqBWvijL7jrADo5BWFTflSezINx/mnNK
         NCoOHaMz4TDD2xS7thoWvB9vctjX2XbvTtBYsseWuI6dJxFLt9zfEhjddKlKJGd1KeIm
         7CNSCnEokNrVWMa1S6s1uPL+yMVvpS2tHfDFUOmeC4qLuIJNgKDchMyPyACKExZBfZw0
         67eQJpM5GFFycgimZ04lpDgYWLOXSHbNi0m9Pd979DQaE9uzQ3Oi9vck+ZVCik+EqCgw
         a6+er9iIlHYC21HBaWOVkv54ANRN4T/Fhm1iD7TUk95CP3ihM3DHIDiYDh/TTGE0Hugh
         yasg==
X-Forwarded-Encrypted: i=1; AJvYcCUBS0YAwuqQcGDrNgmoh8hQi6PChZXR0C4FCBDaR0mjH0uT96fdEycCReH/i9RFGTbC5+TsBJDXhMgkjA==@lists.linux.dev
X-Gm-Message-State: AOJu0Yy5gxDI8EgdVIZ98zqntr1E6v6ymuGSW5+wulBS3lScX6PszRmW
	fhQPEaPY8TqUm0Gg8Lga7sZbehfVZtyxkGU9HW76Oi0MS9cGDPIBGAd8QATQn/q3oVP3K8t3jQM
	vOfDu
X-Gm-Gg: ASbGncv0NaC3WKTNgARFvxx30A6otij0j6fytPNdw4Zm3UCl0gmTvQ2fjRuQHrNpUFG
	Y/v9Dg33g4DdUpgN5gWA/pg4rgu8U+ZIYxDLudOkcr+2G50mBcMzmYO2p34i83BsDrwu6wsoAFK
	dT8JpLSKH+ZS3gAzHYN0ynLSVOyhXVOLFNt49e2q7IprgrwE1IeYgtPiy7OXb4qvYn7GaUpnm5u
	QsSrOjrqTu4Z9FGq/4CVNg5NF5EISyObVf9Kimw03L/Suc0CMv8qdKmDlhxrm/wZ77uy9iVQmNH
	OYU1TBC0tA1kQmNEKiUuzWd/g2Ptmbrmsbw8Zh5o+UDjV5bIKhAQSVGq7xd+MVp50vwJDpbhjy0
	bmfqPVwSKk6Fjvl54kFPNrHpoF5ZeSntw3ZWANOv6wu9cSzfX7LaRYA5Wtn43A2a9IDqHoru6zc
	Q7a+TEzqI52A==
X-Google-Smtp-Source: AGHT+IGkKBpz/sRnl67nrCfxjtzecEq7EyeooaqZrneFpkQXorbTwXQ8QImFP4v9fUehMnmy77NfBg==
X-Received: by 2002:a05:600c:1c8e:b0:477:9fa8:bc99 with SMTP id 5b1f17b1804b1-47a838037c0mr4663045e9.4.1765340075172;
        Tue, 09 Dec 2025 20:14:35 -0800 (PST)
Received: from localhost ([202.127.77.110])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-29dae49caafsm171210555ad.11.2025.12.09.20.14.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Dec 2025 20:14:34 -0800 (PST)
Date: Wed, 10 Dec 2025 12:14:31 +0800
From: Heming Zhao <heming.zhao@suse.com>
To: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: mark@fasheh.com, jlbec@evilplan.org, ocfs2-devel@lists.linux.dev, 
	linux-kernel@vger.kernel.org, glass.su@suse.com
Subject: Re: [PATCH RESEND v4 2/2] ocfs2: detect released suballocator BG for
 fh_to_[dentry|parent]
Message-ID: <jegkzhlqfygaxwthju5pijim44gurqxkpjvgxak7geacv35tdx@33lfq6jjv2dj>
References: <20251202063938.9046-1-heming.zhao@suse.com>
 <20251202063938.9046-3-heming.zhao@suse.com>
 <86fe3ab7-943d-415f-822d-ffa2e7c18640@linux.alibaba.com>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86fe3ab7-943d-415f-822d-ffa2e7c18640@linux.alibaba.com>

On Wed, Dec 10, 2025 at 09:55:03AM +0800, Joseph Qi wrote:
> 
> 
> On 2025/12/2 14:39, Heming Zhao wrote:
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
> >  fs/ocfs2/suballoc.c | 28 ++++++++++++++++++----------
> >  1 file changed, 18 insertions(+), 10 deletions(-)
> > 
> > diff --git a/fs/ocfs2/suballoc.c b/fs/ocfs2/suballoc.c
> > index de2f09217142..a126d83ddb1c 100644
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
> > +		status = -EINVAL;
> > +		goto bail;
> > +	} else if (status < 0) {
> >  		mlog(ML_ERROR, "read group %llu failed %d\n",
> > -		     (unsigned long long)bg_blkno, status);
> > +				(unsigned long long)bg_blkno, status);
> >  		goto bail;
> >  	}
> >  
> > @@ -3182,7 +3186,7 @@ static int ocfs2_test_suballoc_bit(struct ocfs2_super *osb,
> >  bail:
> >  	brelse(group_bh);
> >  
> > -	if (status)
> > +	if (status && (!quiet))
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
> > +		if (status == -EINVAL)
> 
> This seems not right, since there is other case which will also return -EINVAL.
> So how about return -ESTALE in this case?
> 
> Thanks,
> Joseph

I agree with your idea that we can get a more specific errno, but we might
introduce some slightly unnecessary work here.

The ocfs2_test_inode_bit() and ocfs2_test_suballoc_bit() only serve for NFS
export paths:

```
ocfs2_fh_to_[dentry|parent]
 ocfs2_get_dentry //converts -EINVAL to -ESTALE
  ocfs2_test_inode_bit //<== here, current returns -EINVAL
   ocfs2_test_suballoc_bit //test the released gd

ocfs2_get_parent //converts -EINVAL to -ESTALE
 ocfs2_test_inode_bit //<== here, current returns -EINVAL
  ocfs2_test_suballoc_bit
```

the current code design treats -EINVAL as a speical case, converting it to -ESTALE.

If we change the ocfs2_test_inode_bit() return value from -EINVAL to -ESTALE.
This will add another special errno in the error handling path.

The code changes are show below:

```
diff --git a/fs/ocfs2/export.c b/fs/ocfs2/export.c
index b95724b767e1..8992989b85a5 100644
--- a/fs/ocfs2/export.c
+++ b/fs/ocfs2/export.c
@@ -74,7 +74,7 @@ static struct dentry *ocfs2_get_dentry(struct super_block *sb,
              * nice
              */
             status = -ESTALE;
-        } else
+        } else if (status != -ESTALE)
             mlog(ML_ERROR, "test inode bit failed %d\n", status);
         goto unlock_nfs_sync;
     }
@@ -162,7 +162,7 @@ static struct dentry *ocfs2_get_parent(struct dentry *child)
     if (status < 0) {
         if (status == -EINVAL) {
             status = -ESTALE;
-        } else
+        } else if (status != -ESTALE)
             mlog(ML_ERROR, "test inode bit failed %d\n", status);
         parent = ERR_PTR(status);
         goto bail_unlock;

diff --git a/fs/ocfs2/suballoc.c b/fs/ocfs2/suballoc.c
index c274b649b022..ddcfa6e001e8 100644
--- a/fs/ocfs2/suballoc.c
+++ b/fs/ocfs2/suballoc.c
@@ -3172,7 +3172,7 @@ static int ocfs2_test_suballoc_bit(struct ocfs2_super *osb,
                          &group_bh, &released);
     if (released) {
         quiet = 1;
-        status = -EINVAL;
+        status = -ESTALE;
         goto bail;
     } else if (status < 0) {
         mlog(ML_ERROR, "read group %llu failed %d\n",
@@ -3249,7 +3249,7 @@ int ocfs2_test_inode_bit(struct ocfs2_super *osb, u64 blkno, int *res)
     status = ocfs2_test_suballoc_bit(osb, inode_alloc_inode, alloc_bh,
                      group_blkno, blkno, suballoc_bit, res);
     if (status < 0) {
-        if (status == -EINVAL)
+        if (status == -ESTALE)
             quiet = 1;
         else
             mlog(ML_ERROR, "test suballoc bit failed %d\n", status);
```

However, I am ok with your approach. If you think it is better to return -ESTALE,
I will fix it in the next version.

Thanks,
Heming
> 
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
