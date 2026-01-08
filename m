Received: from mail-pf1-f182.google.com (mail-pf1-f182.google.com [209.85.210.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B629931A55F
	for <ocfs2-devel@lists.linux.dev>; Thu,  8 Jan 2026 18:37:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767897423; cv=none; b=fU4Em0ELDYh1foc/jXIROLClLbKWGg1R33M/5tJgqtq0tOJSZjoyDT/rGS1tEi9O6YowX3xskBCFq2bGN1A88KlLVPKk2saqOV/RLpuRW32hdUQIflbC1rIwnz7mWdrE9mVeSWLx0rYHUxc8CXcVu/f/YFOvB+BfmtpczwJQuFQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767897423; c=relaxed/simple;
	bh=mHA1GF9bez1pCm0xV24EI1E7f5M9rBD/QlYB1DXCeQ8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=K1P+CZfOpdJDW1yKLvlD34C+hnNTXyHLMSVSBejfTMqJUYY6yoLkJbpwNIzTrVnDi3YPB4lTHSqWanoSfpGMoDavJSExOYB2/zAxlyKZcClDXGgzHQuNUAkUxczjDUf7iPNN4mh3ueLGjbKG+/M2ySe7JjhvAtnk+ltW70PlUSI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=UX9ADC9+; arc=none smtp.client-ip=209.85.210.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="UX9ADC9+"
Received: by mail-pf1-f182.google.com with SMTP id d2e1a72fcca58-7b8eff36e3bso3595432b3a.2
        for <ocfs2-devel@lists.linux.dev>; Thu, 08 Jan 2026 10:37:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1767897420; x=1768502220; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=tOTrrp6DxwoMuhEXtlgHUxnCLn1aE8DvDhD9G7ICuig=;
        b=UX9ADC9+bh3+ZbC8cyWtWc5HFdmMfGQblz5ix62wXVmXlzdnbBIzjQXKKpYonxR+l8
         g08jh7+RLOHJK6enPJKwDCVaO8XXaF2wPP3nDjkiR5sN4kdCWDscLZ8AjZdSOauwTDmJ
         Wteho7RSLSBEMDVfTuoT/OQnsLBiLnAwdzzH3xyseK5nIqeI4eTx3nFpqlCzM1hR7Q5T
         pHMfMTuIqh9l/hOt4yKiGt+mVo0E/+pjiA3HSf2IBngJHQy4n9vOx+28AtxGiHZpji3/
         wzM5VKES0LnKkXyQBZ4H3xTXLJVHt7BmfoKI6ed40o1tmymqgkO0eL8OAO8gBTsA9xZl
         Z+8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767897420; x=1768502220;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=tOTrrp6DxwoMuhEXtlgHUxnCLn1aE8DvDhD9G7ICuig=;
        b=mhmKSE5FEHnfIDI67ZwG/i0qoyxf+u1rtbqmFPmMNbfzbJpkd2aJIHWHllF8lc1czU
         31LGXJP6GTK9o4Trzz+u0alYjTolowregF7pFG0L4/pLeHdL3itjlP/KXF4lr39aw0KF
         RZQs8yBCfbMsARZ+h0toARcQeZLmhxF0qil+YTkpDCJWnJqui1m5PZ4zfodzHHoAuSHd
         Oky01n6h2JRu4jbj7qNQtuMRTe3TAvLoqOUd2lVnegnd3vHpEjUHB1KnCE1XqS3vO1I4
         15Mp1LRjkdE1uOhwGfH1h8MTZfa8sOjLqFnTyQX6k8m4ooETEUFjk3GlOiVgStMJjvNR
         o8Lw==
X-Forwarded-Encrypted: i=1; AJvYcCUah5EtryWswYb/4zYRA1tUUx/0Q/K0BNvZs1NSBUu8uxZF73JCHJ0FTmok6HbyG36BuqTncadGfCCgEg==@lists.linux.dev
X-Gm-Message-State: AOJu0Yw6K9/KgMvcQp4zAniQtSPBn8c6EpUpJByt1VBsNpjbMwco9ABX
	8irfccaZWlnzU2+0RNx0zxwlIHutcYrBDXo0Hoon5jakUrw0BENmRkcB
X-Gm-Gg: AY/fxX4db+fdThDlMVYyBfO33fV3qWU6NbjD7erjHakXNXDTrrwAfwKoRX9K9omr5sO
	eBK4fJt1IlVse8Uu/ue2axaUfisL+1mnIEhrjidez+ICMYPThxCpZjvub5U+FkjmhZKS9JeDuWF
	BUKQi2jagejjJwI1/Yc88SGNlcA1N+HgueMsNaICel/5pFcS7Gb+YKyW1sU3eEX/8LrrP28QA+b
	uxNdlVMJgbK0o9LRsGx28sAK+0JgkoTbAH3YYg+6/VHRKtcujp5wG/YLtOaXAWMSiqTDq/wIAOy
	ta+em24esro2ZXSmuS3dz4Lm1ex68R7gNq1BedH5iuaWNBsY0aJILbP/7at3CZ5K6OZBRjkxeam
	YyNkrUt+8qvRKfyvLfo6mCWOSWHBUSecFfJUe3YnC+5FMY5HXHricvnU63UAPNlTtdGiYudZInd
	HhVL5mUKH+MA==
X-Google-Smtp-Source: AGHT+IH+6cVcawveoJkth6vp33hUD2WOmQtwWH3EaQ41noQOW/Spw8advCkQhytRvzH1tx1AdnNXWw==
X-Received: by 2002:a05:6a20:9193:b0:35d:3523:c90d with SMTP id adf61e73a8af0-3898f757a29mr6873169637.0.1767897419908;
        Thu, 08 Jan 2026 10:36:59 -0800 (PST)
Received: from inspiron ([111.125.210.92])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-34f5fb7419csm8623327a91.13.2026.01.08.10.36.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Jan 2026 10:36:59 -0800 (PST)
Date: Fri, 9 Jan 2026 00:06:52 +0530
From: Prithvi <activprithvi@gmail.com>
To: joseph.qi@linux.alibaba.com
Cc: mark@fasheh.com, jlbec@evilplan.org, heming.zhao@suse.com,
	ocfs2-devel@lists.linux.dev, linux-kernel@vger.kernel.org,
	linux-kernel-mentees@lists.linux.dev, skhan@linuxfoundation.org,
	david.hunter.linux@gmail.com, khalid@kernel.org
Subject: Re: [PATCH] ocfs2: Fix circular locking dependency in
 ocfs2_del_inode_from_orphan()
Message-ID: <20260108183652.ro4xueuj6itfaph3@inspiron>
References: <20260106125100.327980-1-activprithvi@gmail.com>
 <94b4189d-dfb6-4443-a336-abbae89d36ad@linux.alibaba.com>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <94b4189d-dfb6-4443-a336-abbae89d36ad@linux.alibaba.com>

On Thu, Jan 08, 2026 at 09:29:11AM +0800, Joseph Qi wrote:
> 
> 
> On 2026/1/6 20:51, Prithvi Tambewagh wrote:
> > A possible circular locking dependency in ocfs2_del_inode_from_orphan()
> > is detected by syzbot, which occurs due to change in the sequence of
> > acquiring locks. The existing chain is:
> > 
> > &ocfs2_sysfile_lock_key[ORPHAN_DIR_SYSTEM_INODE] --> &dquot->dq_lock --> 
> > &ocfs2_quota_ip_alloc_sem_key
> > 
> > In ocfs2_dio_end_io_write(), &ocfs2_quota_ip_alloc_sem_key is acquired,
> > and then ocfs2_del_inode_from_orphan() is called, which acquires
> > &ocfs2_sysfile_lock_key[ORPHAN_DIR_SYSTEM_INODE]. This opposes the
> > existing dependency chain:
> > 
> 
> IIUC, ocfs2_dio_end_io_write() only gets the &ocfs2_file_ip_alloc_sem_key.
> So how it happens?
> 
> Thanks,
> Joseph
> 

IIUC that would be the case when ocfs2_dio_end_io_write() operates on normal
files. However, according to the report of the bug, ocfs2_dio_end_io_write()
is holding &ocfs2_quota_ip_alloc_sem_key so I think due to random fuzzing by 
syzkaller, the function is curently operating on a quota file.

Then it calls ocfs2_del_inode_from_orphan() which tries to acquire
&ocfs2_sysfile_lock_key[ORPHAN_DIR_SYSTEM_INODE]. According to the existing
dependency chain, after acquiring it, &ocfs2_quota_ip_alloc_sem_key can be
acquired. But the existing code in ocfs2_dio_end_io_write() first acquires
&ocfs2_quota_ip_alloc_sem_key, thus triggering the circular dependency
warning. 

Thanks,
Prithvi

> > -> #3 (&ocfs2_quota_ip_alloc_sem_key){++++}-{4:4}:
> >        lock_acquire+0x120/0x360 kernel/locking/lockdep.c:5868
> >        down_write+0x3a/0x50 kernel/locking/rwsem.c:1590
> >        ocfs2_create_local_dquot+0x19d/0x1a40 fs/ocfs2/quota_local.c:1227
> >        ocfs2_acquire_dquot+0x80f/0xb30 fs/ocfs2/quota_global.c:883
> >        dqget+0x7c1/0xf20 fs/quota/dquot.c:980
> >        __dquot_initialize+0x3b3/0xcb0 fs/quota/dquot.c:1508
> >        ocfs2_get_init_inode+0x13b/0x1b0 fs/ocfs2/namei.c:205
> >        ocfs2_mknod+0x863/0x2050 fs/ocfs2/namei.c:313
> >        ocfs2_create+0x1a5/0x440 fs/ocfs2/namei.c:676
> >        lookup_open fs/namei.c:3796 [inline]
> >        open_last_lookups fs/namei.c:3895 [inline]
> >        path_openat+0x1500/0x3840 fs/namei.c:4131
> >        do_filp_open+0x1fa/0x410 fs/namei.c:4161
> >        do_sys_openat2+0x121/0x1c0 fs/open.c:1437
> >        do_sys_open fs/open.c:1452 [inline]
> >        __do_sys_openat fs/open.c:1468 [inline]
> >        __se_sys_openat fs/open.c:1463 [inline]
> >        __x64_sys_openat+0x138/0x170 fs/open.c:1463
> >        do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
> >        do_syscall_64+0xfa/0xfa0 arch/x86/entry/syscall_64.c:94
> >        entry_SYSCALL_64_after_hwframe+0x77/0x7f
> > 
> > -> #2 (&dquot->dq_lock){+.+.}-{4:4}:
> >        lock_acquire+0x120/0x360 kernel/locking/lockdep.c:5868
> >        __mutex_lock_common kernel/locking/rtmutex_api.c:535 [inline]
> >        mutex_lock_nested+0x5a/0x1d0 kernel/locking/rtmutex_api.c:547
> >        wait_on_dquot fs/quota/dquot.c:357 [inline]
> >        dqget+0x73a/0xf20 fs/quota/dquot.c:975
> >        __dquot_initialize+0x3b3/0xcb0 fs/quota/dquot.c:1508
> >        ocfs2_get_init_inode+0x13b/0x1b0 fs/ocfs2/namei.c:205
> >        ocfs2_mknod+0x863/0x2050 fs/ocfs2/namei.c:313
> >        ocfs2_create+0x1a5/0x440 fs/ocfs2/namei.c:676
> >        lookup_open fs/namei.c:3796 [inline]
> >        open_last_lookups fs/namei.c:3895 [inline]
> >        path_openat+0x1500/0x3840 fs/namei.c:4131
> >        do_filp_open+0x1fa/0x410 fs/namei.c:4161
> >        do_sys_openat2+0x121/0x1c0 fs/open.c:1437
> >        do_sys_open fs/open.c:1452 [inline]
> >        __do_sys_openat fs/open.c:1468 [inline]
> >        __se_sys_openat fs/open.c:1463 [inline]
> >        __x64_sys_openat+0x138/0x170 fs/open.c:1463
> >        do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
> >        do_syscall_64+0xfa/0xfa0 arch/x86/entry/syscall_64.c:94
> >        entry_SYSCALL_64_after_hwframe+0x77/0x7f
> > 
> > -> #1 (&ocfs2_sysfile_lock_key[INODE_ALLOC_SYSTEM_INODE]){+.+.}-{4:4}:
> >        lock_acquire+0x120/0x360 kernel/locking/lockdep.c:5868
> >        down_write+0x3a/0x50 kernel/locking/rwsem.c:1590
> >        inode_lock include/linux/fs.h:980 [inline]
> >        ocfs2_remove_inode fs/ocfs2/inode.c:731 [inline]
> >        ocfs2_wipe_inode fs/ocfs2/inode.c:894 [inline]
> >        ocfs2_delete_inode fs/ocfs2/inode.c:1155 [inline]
> >        ocfs2_evict_inode+0x153d/0x40d0 fs/ocfs2/inode.c:1295
> >        evict+0x504/0x9c0 fs/inode.c:810
> >        do_unlinkat+0x39f/0x570 fs/namei.c:4744
> >        __do_sys_unlinkat fs/namei.c:4778 [inline]
> >        __se_sys_unlinkat fs/namei.c:4771 [inline]
> >        __x64_sys_unlinkat+0xd3/0xf0 fs/namei.c:4771
> >        do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
> >        do_syscall_64+0xfa/0xfa0 arch/x86/entry/syscall_64.c:94
> >        entry_SYSCALL_64_after_hwframe+0x77/0x7f
> > 
> > -> #0 (&ocfs2_sysfile_lock_key[ORPHAN_DIR_SYSTEM_INODE]){+.+.}-{4:4}:
> >        check_prev_add kernel/locking/lockdep.c:3165 [inline]
> >        check_prevs_add kernel/locking/lockdep.c:3284 [inline]
> >        validate_chain+0xb9b/0x2140 kernel/locking/lockdep.c:3908
> >        __lock_acquire+0xab9/0xd20 kernel/locking/lockdep.c:5237
> >        lock_acquire+0x120/0x360 kernel/locking/lockdep.c:5868
> >        down_write+0x3a/0x50 kernel/locking/rwsem.c:1590
> >        inode_lock include/linux/fs.h:980 [inline]
> >        ocfs2_del_inode_from_orphan+0x134/0x740 fs/ocfs2/namei.c:2730
> >        ocfs2_dio_end_io_write fs/ocfs2/aops.c:2306 [inline]
> >        ocfs2_dio_end_io+0x47b/0x1100 fs/ocfs2/aops.c:2404
> >        dio_complete+0x25e/0x790 fs/direct-io.c:281
> >        __blockdev_direct_IO+0x2bc0/0x31f0 fs/direct-io.c:1303
> >        ocfs2_direct_IO+0x260/0x2d0 fs/ocfs2/aops.c:2441
> >        generic_file_direct_write+0x1dc/0x3e0 mm/filemap.c:4189
> >        __generic_file_write_iter+0x120/0x240 mm/filemap.c:4358
> >        ocfs2_file_write_iter+0x157d/0x1d20 fs/ocfs2/file.c:2469
> >        iter_file_splice_write+0x97a/0x10f0 fs/splice.c:738
> >        do_splice_from fs/splice.c:938 [inline]
> >        direct_splice_actor+0x104/0x160 fs/splice.c:1161
> >        splice_direct_to_actor+0x5b3/0xcd0 fs/splice.c:1105
> >        do_splice_direct_actor fs/splice.c:1204 [inline]
> >        do_splice_direct+0x187/0x270 fs/splice.c:1230
> >        do_sendfile+0x4ec/0x7f0 fs/read_write.c:1370
> >        __do_sys_sendfile64 fs/read_write.c:1431 [inline]
> >        __se_sys_sendfile64+0x13e/0x190 fs/read_write.c:1417
> >        do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
> >        do_syscall_64+0xfa/0xfa0 arch/x86/entry/syscall_64.c:94
> >        entry_SYSCALL_64_after_hwframe+0x77/0x7f
> > 
> > Fix this by acquiring &ocfs2_quota_ip_alloc_sem_key after acquiring
> > &ocfs2_sysfile_lock_key[ORPHAN_DIR_SYSTEM_INODE], effectively calling
> > down_write(&oi->ip_alloc_sem) after the call to
> > ocfs2_del_inode_from_orphan().
> > 
> > Reported-by: syzbot+78359d5fbb04318c35e9@syzkaller.appspotmail.com
> > Closes: https://syzkaller.appspot.com/bug?extid=78359d5fbb04318c35e9
> > Tested-by: syzbot+78359d5fbb04318c35e9@syzkaller.appspotmail.com
> > Cc: stable@vger.kernel.org
> > Signed-off-by: Prithvi Tambewagh <activprithvi@gmail.com>
> > ---
> >  fs/ocfs2/aops.c | 4 ++--
> >  1 file changed, 2 insertions(+), 2 deletions(-)
> > 
> > diff --git a/fs/ocfs2/aops.c b/fs/ocfs2/aops.c
> > index 76c86f1c2b1c..586e3b74d782 100644
> > --- a/fs/ocfs2/aops.c
> > +++ b/fs/ocfs2/aops.c
> > @@ -2295,8 +2295,6 @@ static int ocfs2_dio_end_io_write(struct inode *inode,
> >  		goto out;
> >  	}
> >  
> > -	down_write(&oi->ip_alloc_sem);
> > -
> >  	/* Delete orphan before acquire i_rwsem. */
> >  	if (dwc->dw_orphaned) {
> >  		BUG_ON(dwc->dw_writer_pid != task_pid_nr(current));
> > @@ -2309,6 +2307,8 @@ static int ocfs2_dio_end_io_write(struct inode *inode,
> >  			mlog_errno(ret);
> >  	}
> >  
> > +	down_write(&oi->ip_alloc_sem);
> > +
> >  	di = (struct ocfs2_dinode *)di_bh->b_data;
> >  
> >  	ocfs2_init_dinode_extent_tree(&et, INODE_CACHE(inode), di_bh);
> > 
> > base-commit: 765e56e41a5af2d456ddda6cbd617b9d3295ab4e
> 
