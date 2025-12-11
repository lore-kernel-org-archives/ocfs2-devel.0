Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D0E570824
	for <ocfs2-devel@lists.linux.dev>; Thu, 11 Dec 2025 03:37:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765424242; cv=none; b=O8KQOwnBfb2Fv0nHHwCGFzKixyZY6G4JaOl0/X0IfiBKy6PhPnnpB1QKce3sEzbJzLWCjjK4WrAe4ih9GmmlNhLs3N5wNWR07lO+xUC7qc/uOH68+ba/fKl1OZn+zSTyo6MHBoK38VlqIa5fv4fKd2+nqXTXfugwUdjidbLwTdU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765424242; c=relaxed/simple;
	bh=pMBryqspFGllY2yB7iZj5z7TWvNF9BMTFEPlAc5MA3g=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LPyl16erawLLzH1aursKda2zHM8b16pLyBAsvo6Bke9zPHog1eNopsym/l/JpHaM2LkllwSR5GosDzDFpIYipsrWVdnqNX+TU2lrsg5iM5kNpSqnx7fiuDCIIeBoww1gntY7jzpOZUXnW71uhNVyE3/tIItn0UCVJfUH/DSAidk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=EZSXyW7N; arc=none smtp.client-ip=209.85.128.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="EZSXyW7N"
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-4779c9109ceso392575e9.1
        for <ocfs2-devel@lists.linux.dev>; Wed, 10 Dec 2025 19:37:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1765424237; x=1766029037; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=BTWozHyERVsSfZD/GG7cmjqGInwvtH0SsjVp3DyLhLo=;
        b=EZSXyW7NG6PO+vRhQ65+Xl1On4tsj0rlqLwejz/U5jbgH91D/1+eCqcLtDXllwRTj9
         cxTIRJTzc8b5OvjBqwVju0L3aP4pfyg2tOnY6qOpkOs+CicTENZQteuKzoAir0hYcLVm
         v+7XeK/UFZIXMOf6q1fRu/kAsRCaEpzLC8Yz9f1q5YWU+lP35DJUyztHXYhCTNdYBk5N
         N5j3A3fXkUzhb2rQgI6Hh+tw+nUqU3eFSWv8h/B+x3hvM6BwAUSwkSSnHt13a+cFvYem
         CYJXN19XED/gSNno7wL5dE4AKpPmjgjmeSjWeIKjjTKskLmNuXfrH4Cyj38XsOBUDxgz
         DC8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765424237; x=1766029037;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=BTWozHyERVsSfZD/GG7cmjqGInwvtH0SsjVp3DyLhLo=;
        b=uyfpnFGprvo/j3gLCtTguXpmOEqxCzoJGH1e1qsu9PUADyR+wR8w2D8IkJaYrjRauk
         TW9NdlJAArfJYBC5sQWHVYQKJIN46EQMMm+rE0WMX2guK/UrVjszjp6uJpUxrGe3mVEp
         hxhkKsjgaPyrbcYpVYkKE9slE69UqUeMrvuZoopQ5U+rS75KTgIptEaMFAlnQbVijJcD
         CF3llsLIxtE1Rra8m5MaI1l00ESy8HkfvhaQOAPIvQLDsj0NAFQlpqBVIm7800AjXxLb
         41YztNZ4+UjsoPLrV0tm4B0xbsW7ficisHKGNlVxny0mUV0+ROGwBZD7xcTc1ZFufdHs
         CTCg==
X-Forwarded-Encrypted: i=1; AJvYcCX/TA607ZBquXxBxH78fyZr6QkEU7f5mb4U6KY1S+fkt51Rbl3AiwSBR+9dE1TYvTcdS/j1CMrIRldLjw==@lists.linux.dev
X-Gm-Message-State: AOJu0Yw+7zalo70LTo6aGWjc4vGmJO5D1m3bIRvPyACR1J+nsR7C2Sis
	Worwg/SdvAkF3A5KYra58faRrsOg3KWIKAe28vQUeTsqnoqqTwISDAUAQLaaStLg/cZqLHu03t6
	JYawXVdI=
X-Gm-Gg: AY/fxX5mdaUMzOkasIpMBnSO+PEPpRQhNKw0daJ20tCD2ekTbEsuqTHTk5GackWSKNd
	YAj9+7omqzwfLV8g3rXoOMxYVV+0vs5L2UuQhUXoJ3Gqt3Tv1Eye5XDRjCuvK/NoB1pU3a4f+t8
	d3UeB08CITaaH+RC654dudGgT8WMJUSOwcjb9UzDP57w+ak5wy2CP/n11oEZkGPpF6gV63GD9Xt
	hjQbKEqXMUEchHmCTVKKiXKKXWVm5m1Ks5tdDFQ6d6Goj1hgVClUfcL9+ylCCF3bduVtMbHv9N+
	Ggn1vOD7By8MEVt17aqZShGaXWLuoQzq8O3XqXwRMxzdcHg/njzEkR6RKqEGc3ysaBCKOpM3FvM
	nHiXfJRPazpWRniO+BxgtCBfzGdihnT0Ybk5L12zmzeJc0e5yAOSXW4O1coGV7ZsdHNx4HoiMMH
	YFvYBiKpH2tftqABYLsigm
X-Google-Smtp-Source: AGHT+IEKNM5pFaL1eE859/V8+0dvqpkKtMHvVhOYXMBAfdD1Iaeq5RTolZblsYBmv1d+NjOVbg9Kmw==
X-Received: by 2002:a05:600c:524c:b0:477:5ca6:4d51 with SMTP id 5b1f17b1804b1-47a8991d0eemr3635895e9.3.1765424236530;
        Wed, 10 Dec 2025 19:37:16 -0800 (PST)
Received: from localhost ([202.127.77.110])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-29eea040376sm7645925ad.72.2025.12.10.19.37.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Dec 2025 19:37:15 -0800 (PST)
Date: Thu, 11 Dec 2025 11:37:12 +0800
From: Heming Zhao <heming.zhao@suse.com>
To: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: mark@fasheh.com, jlbec@evilplan.org, ocfs2-devel@lists.linux.dev, 
	linux-kernel@vger.kernel.org, glass.su@suse.com
Subject: Re: [PATCH RESEND v4 2/2] ocfs2: detect released suballocator BG for
 fh_to_[dentry|parent]
Message-ID: <zp76bdiyzcmff2hidrygqvmfnpm2eyxfm5gkjgvb4grogpipvd@26hl3vb3hg3a>
References: <20251202063938.9046-1-heming.zhao@suse.com>
 <20251202063938.9046-3-heming.zhao@suse.com>
 <86fe3ab7-943d-415f-822d-ffa2e7c18640@linux.alibaba.com>
 <jegkzhlqfygaxwthju5pijim44gurqxkpjvgxak7geacv35tdx@33lfq6jjv2dj>
 <99870b4d-8fdf-4690-93a2-a206fbb223fe@linux.alibaba.com>
 <totiw3xkf67vewj3o4bittuk3lhec6sfehmyl7vhd44dhndgkl@76s5s2lcesiw>
 <349ce103-8cab-4df4-9768-bfb9c805badd@linux.alibaba.com>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <349ce103-8cab-4df4-9768-bfb9c805badd@linux.alibaba.com>

On Thu, Dec 11, 2025 at 09:12:34AM +0800, Joseph Qi wrote:
> 
> 
> On 2025/12/10 22:07, Heming Zhao wrote:
> > On Wed, Dec 10, 2025 at 05:00:09PM +0800, Joseph Qi wrote:
> >>
> >>
> >> On 2025/12/10 12:14, Heming Zhao wrote:
> >>> On Wed, Dec 10, 2025 at 09:55:03AM +0800, Joseph Qi wrote:
> >>>>
> >>>>
> >>>> On 2025/12/2 14:39, Heming Zhao wrote:
> >>>>> After ocfs2 gained the ability to reclaim suballocator free block
> >>>>> group (BGs), a suballocator block group may be released. This change
> >>>>> causes the xfstest case generic/426 to fail.
> >>>>>
> >>>>> generic/426 expects return value -ENOENT or -ESTALE, but the current
> >>>>> code triggers -EROFS.
> >>>>>
> >>>>> Call stack before ocfs2 gained the ability to reclaim bg:
> >>>>>
> >>>>> ocfs2_fh_to_dentry //or ocfs2_fh_to_parent
> >>>>>  ocfs2_get_dentry
> >>>>>   + ocfs2_test_inode_bit
> >>>>>   |  ocfs2_test_suballoc_bit
> >>>>>   |   + ocfs2_read_group_descriptor //Since ocfs2 never releases the bg,
> >>>>>   |   |                             //the bg block was always found.
> >>>>>   |   + *res = ocfs2_test_bit //unlink was called, and the bit is zero
> >>>>>   |
> >>>>>   + if (!set) //because the above *res is 0
> >>>>>      status = -ESTALE //the generic/426 expected return value
> >>>>>
> >>>>> Current call stack that triggers -EROFS:
> >>>>>
> >>>>> ocfs2_get_dentry
> >>>>>  ocfs2_test_inode_bit
> >>>>>   ocfs2_test_suballoc_bit
> >>>>>    ocfs2_read_group_descriptor
> >>>>>     + if reading a released bg, validation fails and triggers -EROFS
> >>>>>
> >>>>> How to fix:
> >>>>> Since the read BG is already released, we must avoid triggering -EROFS.
> >>>>> With this commit, we use ocfs2_read_hint_group_descriptor() to detect
> >>>>> the released BG block. This approach quietly handles this type of error
> >>>>> and returns -EINVAL, which triggers the caller's existing conversion
> >>>>> path to -ESTALE.
> >>>>>
> >>>>> Signed-off-by: Heming Zhao <heming.zhao@suse.com>
> >>>>> Reviewed-by: Su Yue <glass.su@suse.com>
> >>>>> ---
> >>>>>  fs/ocfs2/suballoc.c | 28 ++++++++++++++++++----------
> >>>>>  1 file changed, 18 insertions(+), 10 deletions(-)
> >>>>>
> >>>>> diff --git a/fs/ocfs2/suballoc.c b/fs/ocfs2/suballoc.c
> >>>>> index de2f09217142..a126d83ddb1c 100644
> >>>>> --- a/fs/ocfs2/suballoc.c
> >>>>> +++ b/fs/ocfs2/suballoc.c
> >>>>> @@ -3152,7 +3152,7 @@ static int ocfs2_test_suballoc_bit(struct ocfs2_super *osb,
> >>>>>  	struct ocfs2_group_desc *group;
> >>>>>  	struct buffer_head *group_bh = NULL;
> >>>>>  	u64 bg_blkno;
> >>>>> -	int status;
> >>>>> +	int status, quiet = 0, released;
> >>>>>  
> >>>>>  	trace_ocfs2_test_suballoc_bit((unsigned long long)blkno,
> >>>>>  				      (unsigned int)bit);
> >>>>> @@ -3168,11 +3168,15 @@ static int ocfs2_test_suballoc_bit(struct ocfs2_super *osb,
> >>>>>  
> >>>>>  	bg_blkno = group_blkno ? group_blkno :
> >>>>>  		   ocfs2_which_suballoc_group(blkno, bit);
> >>>>> -	status = ocfs2_read_group_descriptor(suballoc, alloc_di, bg_blkno,
> >>>>> -					     &group_bh);
> >>>>> -	if (status < 0) {
> >>>>> +	status = ocfs2_read_hint_group_descriptor(suballoc, alloc_di, bg_blkno,
> >>>>> +					     &group_bh, &released);
> >>>>> +	if (released) {
> >>>>> +		quiet = 1;
> >>>>> +		status = -EINVAL;
> >>>>> +		goto bail;
> >>>>> +	} else if (status < 0) {
> >>>>>  		mlog(ML_ERROR, "read group %llu failed %d\n",
> >>>>> -		     (unsigned long long)bg_blkno, status);
> >>>>> +				(unsigned long long)bg_blkno, status);
> >>>>>  		goto bail;
> >>>>>  	}
> >>>>>  
> >>>>> @@ -3182,7 +3186,7 @@ static int ocfs2_test_suballoc_bit(struct ocfs2_super *osb,
> >>>>>  bail:
> >>>>>  	brelse(group_bh);
> >>>>>  
> >>>>> -	if (status)
> >>>>> +	if (status && (!quiet))
> >>>>>  		mlog_errno(status);
> >>>>>  	return status;
> >>>>>  }
> >>>>> @@ -3202,7 +3206,7 @@ static int ocfs2_test_suballoc_bit(struct ocfs2_super *osb,
> >>>>>   */
> >>>>>  int ocfs2_test_inode_bit(struct ocfs2_super *osb, u64 blkno, int *res)
> >>>>>  {
> >>>>> -	int status;
> >>>>> +	int status, quiet = 0;
> >>>>>  	u64 group_blkno = 0;
> >>>>>  	u16 suballoc_bit = 0, suballoc_slot = 0;
> >>>>>  	struct inode *inode_alloc_inode;
> >>>>> @@ -3244,8 +3248,12 @@ int ocfs2_test_inode_bit(struct ocfs2_super *osb, u64 blkno, int *res)
> >>>>>  
> >>>>>  	status = ocfs2_test_suballoc_bit(osb, inode_alloc_inode, alloc_bh,
> >>>>>  					 group_blkno, blkno, suballoc_bit, res);
> >>>>> -	if (status < 0)
> >>>>> -		mlog(ML_ERROR, "test suballoc bit failed %d\n", status);
> >>>>> +	if (status < 0) {
> >>>>> +		if (status == -EINVAL)
> >>>>
> >>>> This seems not right, since there is other case which will also return -EINVAL.
> >>>> So how about return -ESTALE in this case?
> >>>>
> >>>> Thanks,
> >>>> Joseph
> >>>
> >>> I agree with your idea that we can get a more specific errno, but we might
> >>> introduce some slightly unnecessary work here.
> >>>
> >>> The ocfs2_test_inode_bit() and ocfs2_test_suballoc_bit() only serve for NFS
> >>> export paths:
> >>>
> >>> ```
> >>> ocfs2_fh_to_[dentry|parent]
> >>>  ocfs2_get_dentry //converts -EINVAL to -ESTALE
> >>>   ocfs2_test_inode_bit //<== here, current returns -EINVAL
> >>>    ocfs2_test_suballoc_bit //test the released gd
> >>>
> >>> ocfs2_get_parent //converts -EINVAL to -ESTALE
> >>>  ocfs2_test_inode_bit //<== here, current returns -EINVAL
> >>>   ocfs2_test_suballoc_bit
> >>> ```
> >>>
> >>> the current code design treats -EINVAL as a speical case, converting it to -ESTALE.
> >>>
> >>> If we change the ocfs2_test_inode_bit() return value from -EINVAL to -ESTALE.
> >>> This will add another special errno in the error handling path.
> >>>
> >>> The code changes are show below:
> >>>
> >>> ```
> >>> diff --git a/fs/ocfs2/export.c b/fs/ocfs2/export.c
> >>> index b95724b767e1..8992989b85a5 100644
> >>> --- a/fs/ocfs2/export.c
> >>> +++ b/fs/ocfs2/export.c
> >>> @@ -74,7 +74,7 @@ static struct dentry *ocfs2_get_dentry(struct super_block *sb,
> >>>               * nice
> >>>               */
> >>>              status = -ESTALE;
> >>> -        } else
> >>> +        } else if (status != -ESTALE)
> >>>              mlog(ML_ERROR, "test inode bit failed %d\n", status);
> >>>          goto unlock_nfs_sync;
> >>>      }
> >>> @@ -162,7 +162,7 @@ static struct dentry *ocfs2_get_parent(struct dentry *child)
> >>>      if (status < 0) {
> >>>          if (status == -EINVAL) {
> >>>              status = -ESTALE;
> >>> -        } else
> >>> +        } else if (status != -ESTALE)
> >>>              mlog(ML_ERROR, "test inode bit failed %d\n", status);
> >>>          parent = ERR_PTR(status);
> >>>          goto bail_unlock;
> >>>
> >>> diff --git a/fs/ocfs2/suballoc.c b/fs/ocfs2/suballoc.c
> >>> index c274b649b022..ddcfa6e001e8 100644
> >>> --- a/fs/ocfs2/suballoc.c
> >>> +++ b/fs/ocfs2/suballoc.c
> >>> @@ -3172,7 +3172,7 @@ static int ocfs2_test_suballoc_bit(struct ocfs2_super *osb,
> >>>                           &group_bh, &released);
> >>>      if (released) {
> >>>          quiet = 1;
> >>> -        status = -EINVAL;
> >>> +        status = -ESTALE;
> >>>          goto bail;
> >>>      } else if (status < 0) {
> >>>          mlog(ML_ERROR, "read group %llu failed %d\n",
> >>> @@ -3249,7 +3249,7 @@ int ocfs2_test_inode_bit(struct ocfs2_super *osb, u64 blkno, int *res)
> >>>      status = ocfs2_test_suballoc_bit(osb, inode_alloc_inode, alloc_bh,
> >>>                       group_blkno, blkno, suballoc_bit, res);
> >>>      if (status < 0) {
> >>> -        if (status == -EINVAL)
> >>> +        if (status == -ESTALE)
> >>>              quiet = 1;
> >>>          else
> >>>              mlog(ML_ERROR, "test suballoc bit failed %d\n", status);
> >>> ```
> >>>
> >>> However, I am ok with your approach. If you think it is better to return -ESTALE,
> >>> I will fix it in the next version.
> >>>
> >>
> >> Okay, it seems -EINVAL is also fine. But why you silent the error log
> >> for -EINVAL? This will also silent another case, which is different from
> >> before.
> > 
> > You are right, the patch code silents all -EINVAL cases, which is
> > incorrect logic.
> > 
> >> BTW, why can't we just return 0 in case of release?
> >>
> >> Joseph
> >>
> > 
> > There are two reasons why we should return an errno:
> > 1> This is still an abnormal case where user is searching for an inode that
> >    is already deleted.
> > 
> > 2> I am not familiar with NFS. However, the meaning from the xfstests
> >    generic/426 source code, which calls "open_by_handle -d", and the comment
> >    at the beginning of the src/open_by_handle.c [1]:
> > 
> >    ```
> >    6. Get file handles for existing test set, unlink all test files,
> >       remove test_dir, drop caches, try to open all files by handle
> >       and expect ESTALE:
> >    
> >       open_by_handle -dp <test_dir> [N]
> >    ```
> > 
> >    The expected return value is '-ESTALE', not '0' (success).
> > 
> > Returning to my patch, I think your previous idea (to return specific
> > -ESTALE) makes sense. Although we are adding another special error case,
> > this change keeps the existing error path working as before.
> > 
> > May I sent the v5 patch which includes the change for -ESTALE (using code
> > similar to my previous email in this thread)?
> > 
> Or reuse the existing -EINVAL logic but without silent error log?
> It seems log this case also make sense.
> 
> Joseph

The ext4 doesn't output any warning/error messages during generic/426, and before
this patch set (where ocfs2 never released suballocator space), ocfs2 also never
output any messages. So, I suggest ocfs2 should remain quite.
Adding -ESTALE makes sense, because the new behavior, where ocfs2 can release bg,
introduces a new error handling path.

- Heming
