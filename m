Received: from mail-wr1-f51.google.com (mail-wr1-f51.google.com [209.85.221.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D16B34250E
	for <ocfs2-devel@lists.linux.dev>; Mon,  2 Mar 2026 06:07:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772431647; cv=none; b=K1zL6ag+c5mzlfEguw0V7vnEYtwm9Y8fgG4GgRWzBm82btzkW7vhHOS+rBhZX4uA9klboGl1JD1aY8VZPfSQBACUmCirKkkLxjks4cZiwBpK260whSBxmD9J+3qW+OiBvblXWQATpJTpqFgb2cHczDBN8+F4aczWt+uPadGWz7s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772431647; c=relaxed/simple;
	bh=bPX0Wm0bopa+3pSDkChB8clwt47J7sdt4d8EXF4+uMg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ONODlEk+h0OwL69hvxE+PU+V7TRN4vGauBAxTHO4qE5Giu3ugXFBVeVZtIymqm0QwkkTFwCBw4pEXoGhs7jjPPMPm6vUAKCr6GFqj1eZyCJjYxSkcZkYSS6D2SZXMdLb4s8O3rWMuE0j57Mfex84n6d6VgsWwEVZkYXlMR9W+YA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=TRvfqNCT; arc=none smtp.client-ip=209.85.221.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="TRvfqNCT"
Received: by mail-wr1-f51.google.com with SMTP id ffacd0b85a97d-439bc832351so1716f8f.1
        for <ocfs2-devel@lists.linux.dev>; Sun, 01 Mar 2026 22:07:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1772431640; x=1773036440; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=R1a5fdwIwqyrI7Uo03ss2vIA2HYN9DnyZY59D+jlov4=;
        b=TRvfqNCTLJNRv0KiyxMauS/XBvBEQWLy7EANW7qYAoYcSX5CjuWdDq+vm/4ALPR5+s
         Q/lKbWez3mTDTUctTH+xhZR2YeCcS1gIWhriitc2Sx3fOw4Gqyva8sluLacqo+KD3lkH
         ATLUhk7+rv5vJQZFJ1eBQJ3LZPfB6UVJCkzBsQ5j5Ve0CxR68NsjyEm1hemLHzX4gQPn
         N6TvmV5wUVSsYkXWHkBEbhXl7eOJKKgyqfZzTdVYSaWF0PCP21e/OMp1SVOigC3zSSKK
         l+9wqPayt5Nd6jp0FgH4IG33rOOBrSbGYvaXpAj2TWru0wa8VsZcKB2iSpLM031Lfc6D
         x5/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772431640; x=1773036440;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=R1a5fdwIwqyrI7Uo03ss2vIA2HYN9DnyZY59D+jlov4=;
        b=kaVSplZCsxktNdFlDdix+FxW3/7dn1R3i0MRlxBP0/qdcUrY82vatos4p9bSWqulx0
         iOeXXMr6ZwIT8LPJ4Y7CHzIE/Dp8bXG6fbpJR3VdXtEvSk5slrjAolv9d9im9AgfYCIZ
         lEF9fP6MRpvrh0Npr1kyuUuUD36+NCiH9bBqwg/RAl1Er02Re99X8vp6zAN07ZgNSW27
         uKaIbD5ohSv9+AURMlN85OJRLUMgWm1JlRX+CZKGsXI4kRr4XHeWUl3wPvgJUKl3pcKl
         YUlUTuW+Z6E1KmUSlRwuMXeAAa25LGfNc11++Ldc11zB4A1o0mDkR19ahjS/YDGX0ji5
         09Jw==
X-Gm-Message-State: AOJu0YwehyumEx3ITIAYLxYM4Q70YU6k8y2qzFzVBPWUtfnCbRPrRvNq
	8BYs57ce4PdACbB3qjJ7AJBFLKwHy99+7nMWQ1qnnZeCa4zuGgenBpBsx8PFqBl8yBE=
X-Gm-Gg: ATEYQzyZxMcuq9AXRFAupo9lTledjD4/PHwqpN8ootKRTY+nWPNRYfhJropSafbcVhp
	TZzciTL8mgwVmeA9dhKNzHNnshOVv5n/aRFXROayzXRny3MBgzS49dGl8e9B93AxEsF1tbuor9O
	9m9A+Dsb4ZhrrUn/13f2QUZJiA0sRGN5Vch9Cr52qUfWC1c9+01v/jt+m7FKir+zPa4j5V5SQUA
	V7yTB2fXs+TvYiyLg5aPz9HgkKFd41vEE8G3o9pVuINxIMlZwbixeqAL+IMXJNxyxvI+91oJIUZ
	qYv8YK4lZGNX26dMHDTAWbZ6DFkJySsPzxWIb/uDu1ufvpM7vd7HqgN0IicNl4R/5E5w0jAnUoe
	azyNpQOSD7M1HeSPwXcfVkXSO2QrfZ3xVsS2qL2tR5c4toHoC9eZVxwvzhfbK+t+Oul8cr6qpiW
	kI2Z3dfj3kWeWEGGRgiLf7YA==
X-Received: by 2002:a05:600c:4e8a:b0:483:887:6e32 with SMTP id 5b1f17b1804b1-483c9bd9eaemr111567885e9.8.1772431640076;
        Sun, 01 Mar 2026 22:07:20 -0800 (PST)
Received: from localhost ([202.127.77.110])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-82739d94de6sm12032736b3a.24.2026.03.01.22.07.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 01 Mar 2026 22:07:19 -0800 (PST)
Date: Mon, 2 Mar 2026 14:07:16 +0800
From: Heming Zhao <heming.zhao@suse.com>
To: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: ocfs2-devel@lists.linux.dev, linux-kernel@vger.kernel.org, 
	activprithvi@gmail.com, syzbot+78359d5fbb04318c35e9@syzkaller.appspotmail.com
Subject: Re: [PATCH] ocfs2: fix deadlock when creating quota file
Message-ID: <zt4aslz7ul66vzg3jollvfeyeqtb4g7fyuhc5zvxtppo6nul26@6m7sc67ok6qs>
References: <20260224084909.28361-1-heming.zhao@suse.com>
 <d5b1842e-ba46-4bb3-b4e6-c0d45cf900a6@linux.alibaba.com>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d5b1842e-ba46-4bb3-b4e6-c0d45cf900a6@linux.alibaba.com>

On Sat, Feb 28, 2026 at 06:53:34PM +0800, Joseph Qi wrote:
> 
> 
> On 2/24/26 4:48 PM, Heming Zhao wrote:
> > syzbot detected a circular locking dependency. the scenarios:
> > 
> >         CPU0                    CPU1
> >         ----                    ----
> >    lock(&ocfs2_quota_ip_alloc_sem_key);
> >                                 lock(&ocfs2_sysfile_lock_key[USER_QUOTA_SYSTEM_INODE]);
> >                                 lock(&ocfs2_quota_ip_alloc_sem_key);
> >    lock(&ocfs2_sysfile_lock_key[ORPHAN_DIR_SYSTEM_INODE]);
> > 
> > or:
> >        CPU0                    CPU1
> >        ----                    ----
> >   lock(&ocfs2_quota_ip_alloc_sem_key);
> >                                lock(&dquot->dq_lock);
> >                                lock(&ocfs2_quota_ip_alloc_sem_key);
> >   lock(&ocfs2_sysfile_lock_key[ORPHAN_DIR_SYSTEM_INODE]);
> > 
> > Following are the code paths for above scenarios:
> > 
> > path_openat
> >  ocfs2_create
> >   ocfs2_mknod
> >   + ocfs2_reserve_new_inode
> >   |  ocfs2_reserve_suballoc_bits
> >   |   inode_lock(alloc_inode) //C0: hold INODE_ALLOC_SYSTEM_INODE
> >   |    //at end of this func, ocfs2_free_alloc_context(inode_ac) calls inode_unlock

for clarity, above should be changed:                                            
ocfs2_free_alloc_context(inode_ac) is called at the end of caller ocfs2_mknod to 
handle the release.

> >   |
> >   + ocfs2_get_init_inode
> >      __dquot_initialize
> >       dqget
> >        ocfs2_acquire_dquot
> >        + ocfs2_lock_global_qf
> >        |  down_write(&OCFS2_I(oinfo->dqi_gqinode)->ip_alloc_sem)//A2:grabbing
> >        + ocfs2_create_local_dquot
> >           down_write(&OCFS2_I(lqinode)->ip_alloc_sem)//A3:grabbing
> > 
> > evict
> >  ocfs2_evict_inode
> >   ocfs2_delete_inode
> >    ocfs2_wipe_inode
> >     + inode_lock(orphan_dir_inode) //B0:hold
> >     + ...
> >     + ocfs2_remove_inode
> >        inode_lock(inode_alloc_inode) //INODE_ALLOC_SYSTEM_INODE
> >         down_write(&inode->i_rwsem) //C1:grabbing
> > 
> > generic_file_direct_write
> >  ocfs2_direct_IO
> >   __blockdev_direct_IO
> >    dio_complete
> >     ocfs2_dio_end_io
> >      ocfs2_dio_end_io_write
> >      + down_write(&oi->ip_alloc_sem) //A0:hold
> >      + ocfs2_del_inode_from_orphan
> >         inode_lock(orphan_dir_inode) //B1:grabbing
> > 
> > Root cause for the circular locking:
> > 
> > DIO completion path:
> >  holds oi->ip_alloc_sem and is trying to acquire the orphan_dir_inode lock.
> > 
> > evict path:
> >  holds the orphan_dir_inode lock and is trying to acquire the
> >  inode_alloc_inode lock.
> > 
> > ocfs2_mknod path:
> >  Holds the inode_alloc_inode lock (to allocate a new quota file) and is
> >  blocked waiting for oi->ip_alloc_sem in ocfs2_acquire_dquot().
> > 
> > How to fix:
> > 
> > Replace down_write() with down_write_trylock() in ocfs2_acquire_dquot().
> > If acquiring oi->ip_alloc_sem fails, return -EBUSY to abort the file creation
> > routine and break the deadlock.
> > 
> > Reported-by: syzbot+78359d5fbb04318c35e9@syzkaller.appspotmail.com
> > Closes: https://syzkaller.appspot.com/bug?extid=78359d5fbb04318c35e9
> > Signed-off-by: Heming Zhao <heming.zhao@suse.com>
> > ---
> >  fs/ocfs2/quota_global.c | 5 ++++-
> >  fs/ocfs2/quota_local.c  | 5 ++++-
> >  2 files changed, 8 insertions(+), 2 deletions(-)
> > 
> > diff --git a/fs/ocfs2/quota_global.c b/fs/ocfs2/quota_global.c
> > index e85b1ccf81be..4321d8f59402 100644
> > --- a/fs/ocfs2/quota_global.c
> > +++ b/fs/ocfs2/quota_global.c
> > @@ -311,7 +311,10 @@ int ocfs2_lock_global_qf(struct ocfs2_mem_dqinfo *oinfo, int ex)
> >  	spin_unlock(&dq_data_lock);
> >  	if (ex) {
> >  		inode_lock(oinfo->dqi_gqinode);
> > -		down_write(&OCFS2_I(oinfo->dqi_gqinode)->ip_alloc_sem);
> > +		if (!down_write_trylock(&OCFS2_I(oinfo->dqi_gqinode)->ip_alloc_sem)) {
> > +			inode_unlock(oinfo->dqi_gqinode);
> 
> You've missed the oinfo->dqi_gqinode cleanup.
> 
> > +			return -EBUSY;
> > +		}
> >  	} else {
> >  		down_read(&OCFS2_I(oinfo->dqi_gqinode)->ip_alloc_sem);
> >  	}
> > diff --git a/fs/ocfs2/quota_local.c b/fs/ocfs2/quota_local.c
> > index c4e0117d8977..e451f3d96037 100644
> > --- a/fs/ocfs2/quota_local.c
> > +++ b/fs/ocfs2/quota_local.c
> > @@ -1224,7 +1224,10 @@ int ocfs2_create_local_dquot(struct dquot *dquot)
> >  	int status;
> >  	u64 pcount;
> >  
> > -	down_write(&OCFS2_I(lqinode)->ip_alloc_sem);
> > +	if (!down_write_trylock(&OCFS2_I(lqinode)->ip_alloc_sem)) {
> > +		status = -EBUSY;
> > +		goto out;
> 
> We cannot goto out here since it does up_write.
> It seems we can return EBUSY directly.
> 
> Joseph

Thanks for the review comments, I will send v2 to fix these mistakes.

Heming
> 
> > +	}
> >  	chunk = ocfs2_find_free_entry(sb, type, &offset);
> >  	if (!chunk) {
> >  		chunk = ocfs2_extend_local_quota_file(sb, type, &offset);
> 
