Received: from mail-ed1-f54.google.com (mail-ed1-f54.google.com [209.85.208.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDE541C2324
	for <ocfs2-devel@lists.linux.dev>; Thu,  6 Aug 2026 04:02:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.54
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785988937; cv=pass; b=GhduNue6bshAIbNaMR7Mlv7Z124/uCPEHAT3x7lzLsheb3eX1MnEDxXuoqosKzqWDyv5e6EMW1Ssvd5ANTdG+hZ8nkEuMFTOPzxaEKYe6VsLh/GYSAAFmVEih2yXfp1EioGIRNOMAZtkpPyrzyrMt1YyJnBNQXTPgGMcL/teGKM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785988937; c=relaxed/simple;
	bh=yTOj4kDIMNUO13b4hIPqjK3xbfBGYe1NjgcAAbBvE3s=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=kTadlJq0Jr4jKLFoPftn9skwlaFIWvMzUXbzqHkV69Z2UzbPUmn48IaJJd78RnWo0l1G0bCFnWcrpfMt5hiOmeetR+fiM+wgZVexllIV4mwO1zZnPS5+vhi33K89Q7hKr08wdJiDMsof5qqsJeo1z/Vmh/nzeYR+1Q/dmhiN0fc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=oeSE1e6k; arc=pass smtp.client-ip=209.85.208.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="oeSE1e6k"
Received: by mail-ed1-f54.google.com with SMTP id 4fb4d7f45d1cf-6a17cb94b26so2009147a12.3
        for <ocfs2-devel@lists.linux.dev>; Wed, 05 Aug 2026 21:02:15 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1785988934; cv=none;
        d=google.com; s=arc-20260327;
        b=Hjh+kg9a9fddIWzzBRMxjF1KNiOkYUzBQ9FZzbkln5xT89DvEoVI+ENcsvLsUwbPpY
         oA9XZXyatNpl3oxHFR4c69qK+sGOBtlYXs8ZQ+7I4Q83Pq6Ujv27n/UpUcl9qmH08won
         qSf7AJ0ceQ68WOBgvSAdw1oTDYoUABJXf4ozw95B7t8pUbaTtfXf7r01GxRTlywg4lNf
         PmuONkqzm2JWnebDJro9El/H6W33kPI5JCniQLslqtO0uTQHBcRBbaSll1eet/93gwiJ
         3r6vzxoofJJtkDm7x5BxR33JuxmpkJoxPbYBcDDt9cQxZwIubnyHrxFUqIn+1yUnqqA6
         asBw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=fg9I995Hr8Sa8JG8yfzMQiDwWh0It/LARkRHhSKy2cM=;
        fh=DZcTrgiHsjDfzNYeUlPWYvbFYbMaEhyS3Xc56xKDJWM=;
        b=EEWMYk9RxnP/NDyRbrxsSQOO2F9OMIUVBgARhGrZ3by97+JvDaDTo5Epahxj2YYr58
         fWf7OvgekXfP+10Ar6TJaudui/zTJSk6hYuq+pBItgWD60Lq+45GsgeypPrMNACtk36n
         fIExVfInezHVt77crbnfXkW6p63rr5r9RbiTepA/epoar48r8qNL/5eVz2SzakjuUqkS
         mfLntRiZ6tBftLfWuRBb6f6qDcdd+aui9XBQmJdOuDv16nPqWTjDfc1Smb3E+YTbI0ZS
         cnJPUJ3r4MZin86og9HA5Q8AnYrsmFy3XV/p9FsaSFEcgYY1+0ehU3fOnRJubEMVVUxO
         CCYg==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785988934; x=1786593734; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=fg9I995Hr8Sa8JG8yfzMQiDwWh0It/LARkRHhSKy2cM=;
        b=oeSE1e6k0lrFmlRwO1Jt8lFZGJ1JbeP3b2B+xHmrQyxjnp6VBjTB8RWN5XRsU+bJmI
         fYSOgWcLXAfwm/wKPphxrY25tM+ZptRWcMUHiYuOgB4eV5pERTepqTXIHc/hT8VsE6Nq
         /s3SUJc27mzfmaJIPm2FlHYmsG4EwvkmUIL8OEy405AUIKgLVSW7inCvMHZuB+2ptS6Q
         ULWcHTwVz+U6DnBDLdolUflA2OFB1O0lTxgSQFwKqmlVjQudVeNaXBS+ujhpaX3hkDlP
         3GkM0lYIKWD8311BVZjCPjYLqceEx+qfx6tYLkrH+rGRDalaqPxpkKXiDcSoJhuB9wVz
         uS6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785988934; x=1786593734;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=fg9I995Hr8Sa8JG8yfzMQiDwWh0It/LARkRHhSKy2cM=;
        b=UBDHMLN8KBoBgLoJlo3WtVfrTVN7xUTVyYqr9d0D/dWwwu+pALon6SoGDsmgDQBFdw
         9o6a7pWFV04fq8szBGibYhB3hHQygBfWku6Rp4riV6IM0b2mrJ4JHFf99/iGZc9r7uPO
         mYspY02V0C/t2cQ6HBHPSEAzHh4O/LSyZAuMF14b8jw9R5CTwMMxpHwNpwGcMwrhT/nc
         ck98XeQZPpU3Ke4bFuQluDWwYVL6GIi3w9tAxWt8+rYfg1HrI/yAELIEGoo1R5LBu2ct
         Wl+FTZHQDnW03nSjcVe5svqSWurZ+d5ulQpoFNsvjJVzmmB/qZAF26voy8yN4KPMphDa
         3ysQ==
X-Forwarded-Encrypted: i=1; AHgh+RrELjF9yixz/a7ZGod5O1P4Bnr9aoWpfcMY0JQBj+Yrg683cNOqrnAJDB8tLHhrDk6AtSbED2RK/1oBHg==@lists.linux.dev
X-Gm-Message-State: AOJu0YzJ5jRNEAQw/5w/hRz+Ibf+TCYX1CQqDONLTxW8hCO4ScsyfcDZ
	dBIBFqpHLkea4xFEmiIi9iYegZ5Tg2uteP/isnF+Je0P5tSew53GD31NTRchA2LkcUYeVy+waBQ
	Osscu2G0N5boX+lrfyO1plMTbYwh+oko=
X-Gm-Gg: AR+sD114XP+UQGmkf9lrR26wlL83yIoi5JnBhvx0+Lam9u9oqSmubKB322FxsQHeyFZ
	DuKXqYMFaliQKmCT8jAEkI4TVQj0UnMqqepeLN+RkSKBwrVTxmQAFusQOvf9KUAGUp3Xagx+/GT
	cZ4OXkpWqT8Tig8ZfAkhcbMabUJkoIIME8j6jusgigqX3t4Dy9ywnGWLb+WfYInmnY644w86r5R
	rC11988xWRmp25zBSOTtHrEY/Ziea5MvzINs7CBddX4bh8XR+7+QIxk1uo1MwLscAvARYMl2LNv
	nc2oov7Z5jpaVuvKkD3z43qihhXicrtQ8FT2M2OrdeHmA/g2PijBwh48uyCbGC7iLD3jUm6BGRL
	xAUW0EA4snAkzNlsHJpz1E9FwlILd
X-Received: by 2002:a05:6402:1e8e:b0:6a0:eb:ae41 with SMTP id
 4fb4d7f45d1cf-6a14f15d6a9mr5912901a12.10.1785988933605; Wed, 05 Aug 2026
 21:02:13 -0700 (PDT)
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260803032346.3997901-1-gality369@gmail.com> <61725d38-1a5d-4390-9e63-6875a1e8245e@linux.alibaba.com>
In-Reply-To: <61725d38-1a5d-4390-9e63-6875a1e8245e@linux.alibaba.com>
From: ZhengYuan Huang <gality369@gmail.com>
Date: Thu, 6 Aug 2026 12:01:47 +0800
X-Gm-Features: AUfX_mxlW9vxmnmiSMXrMIgSo2HTO7Ewoj0ljnpDW9R7hpm0YiGhNO9686UJCZo
Message-ID: <CAOmEq9XMEMhiBH9aUEtHMNXdy2qW0fhxy8cQHQOov-7sVnFS3g@mail.gmail.com>
Subject: Re: [PATCH] ocfs2: fix deadlock in inline-data truncate transactions
To: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: mark@fasheh.com, jlbec@evilplan.org, ocfs2-devel@lists.linux.dev, 
	linux-kernel@vger.kernel.org, baijiaju1990@gmail.com, r33s3n6@gmail.com, 
	zzzccc427@gmail.com, tom442288@tuta.io, Heming Zhao <heming.zhao@suse.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Aug 5, 2026 at 7:42=E2=80=AFPM Joseph Qi <joseph.qi@linux.alibaba.c=
om> wrote:
>
>
>
> On 8/3/26 11:23 AM, ZhengYuan Huang wrote:
> > [BUG]
> > Shrinking an inline-data file can trigger a real ABBA deadlock cycle an=
d
> > lockdep warning:
> >
> > WARNING: possible circular locking dependency detected
> > ------------------------------------------------------
> > syz.0.6/353 is trying to acquire lock:
> > ffff888015936610 (sb_internal#2){.+.+}-{0:0}, at: ocfs2_truncate_inline=
+0x389/0xbf0 fs/ocfs2/alloc.c:7436
> >
> > but task is already holding lock:
> > ffff888019156a20 (&ocfs2_file_ip_alloc_sem_key){++++}-{4:4}, at: ocfs2_=
truncate_file+0x23a/0x13c0 fs/ocfs2/file.c:471
> >
> > which lock already depends on the new lock.
> >
> > the existing dependency chain (in reverse order) is:
> >
> > -> #3 (&ocfs2_file_ip_alloc_sem_key){++++}-{4:4}:
> >        down_write+0x8f/0x200 kernel/locking/rwsem.c:1590
> >        ocfs2_xattr_ibody_set+0x119/0xc50 fs/ocfs2/xattr.c:2783
> >        __ocfs2_xattr_set_handle+0xdb/0xdb0 fs/ocfs2/xattr.c:3322
> >        ocfs2_xattr_set+0x1447/0x2610 fs/ocfs2/xattr.c:3650
> >        ocfs2_xattr_security_set+0x37/0x50 fs/ocfs2/xattr.c:7241
> >        __vfs_setxattr+0x14f/0x1c0 fs/xattr.c:200
> >        __vfs_setxattr_noperm+0x10b/0x5c0 fs/xattr.c:234
> >        __vfs_setxattr_locked+0x172/0x240 fs/xattr.c:295
> >        vfs_setxattr+0x167/0x390 fs/xattr.c:321
> >        do_setxattr+0x13c/0x180 fs/xattr.c:636
> >        filename_setxattr+0x16b/0x1c0 fs/xattr.c:665
> >        path_setxattrat+0x1d8/0x280 fs/xattr.c:713
> >        __do_sys_setxattr fs/xattr.c:747 [inline]
> >        __se_sys_setxattr fs/xattr.c:743 [inline]
> >        __x64_sys_setxattr+0xcd/0x150 fs/xattr.c:743
> >        x64_sys_call+0x148c/0x26a0 arch/x86/include/generated/asm/syscal=
ls_64.h:189
> >        do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
> >        do_syscall_64+0x93/0xf80 arch/x86/entry/syscall_64.c:94
> >        entry_SYSCALL_64_after_hwframe+0x76/0x7e
> >
> > -> #2 (jbd2_handle){++++}-{0:0}:
> >        start_this_handle+0x5c7/0x13c0 fs/jbd2/transaction.c:444
> >        jbd2__journal_start+0x397/0x690 fs/jbd2/transaction.c:501
> >        jbd2_journal_start+0x31/0x50 fs/jbd2/transaction.c:540
> >        ocfs2_start_trans+0x39b/0x870 fs/ocfs2/journal.c:374
> >        ocfs2_xattr_set+0x1401/0x2610 fs/ocfs2/xattr.c:3643
> >        ocfs2_xattr_security_set+0x37/0x50 fs/ocfs2/xattr.c:7241
> >        __vfs_setxattr+0x14f/0x1c0 fs/xattr.c:200
> >        __vfs_setxattr_noperm+0x10b/0x5c0 fs/xattr.c:234
> >        __vfs_setxattr_locked+0x172/0x240 fs/xattr.c:295
> >        vfs_setxattr+0x167/0x390 fs/xattr.c:321
> >        do_setxattr+0x13c/0x180 fs/xattr.c:636
> >        filename_setxattr+0x16b/0x1c0 fs/xattr.c:665
> >        path_setxattrat+0x1d8/0x280 fs/xattr.c:713
> >        __do_sys_setxattr fs/xattr.c:747 [inline]
> >        __se_sys_setxattr fs/xattr.c:743 [inline]
> >        __x64_sys_setxattr+0xcd/0x150 fs/xattr.c:743
> >        x64_sys_call+0x148c/0x26a0 arch/x86/include/generated/asm/syscal=
ls_64.h:189
> >        do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
> >        do_syscall_64+0x93/0xf80 arch/x86/entry/syscall_64.c:94
> >        entry_SYSCALL_64_after_hwframe+0x76/0x7e
> >
> > -> #1 (&journal->j_trans_barrier){.+.+}-{4:4}:
> >        down_read+0x9c/0x4a0 kernel/locking/rwsem.c:1537
> >        ocfs2_start_trans+0x390/0x870 fs/ocfs2/journal.c:372
> >        ocfs2_xattr_set+0x1401/0x2610 fs/ocfs2/xattr.c:3643
> >        ocfs2_xattr_security_set+0x37/0x50 fs/ocfs2/xattr.c:7241
> >        __vfs_setxattr+0x14f/0x1c0 fs/xattr.c:200
> >        __vfs_setxattr_noperm+0x10b/0x5c0 fs/xattr.c:234
> >        __vfs_setxattr_locked+0x172/0x240 fs/xattr.c:295
> >        vfs_setxattr+0x167/0x390 fs/xattr.c:321
> >        do_setxattr+0x13c/0x180 fs/xattr.c:636
> >        filename_setxattr+0x16b/0x1c0 fs/xattr.c:665
> >        path_setxattrat+0x1d8/0x280 fs/xattr.c:713
> >        __do_sys_setxattr fs/xattr.c:747 [inline]
> >        __se_sys_setxattr fs/xattr.c:743 [inline]
> >        __x64_sys_setxattr+0xcd/0x150 fs/xattr.c:743
> >        x64_sys_call+0x148c/0x26a0 arch/x86/include/generated/asm/syscal=
ls_64.h:189
> >        do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
> >        do_syscall_64+0x93/0xf80 arch/x86/entry/syscall_64.c:94
> >        entry_SYSCALL_64_after_hwframe+0x76/0x7e
> >
> > -> #0 (sb_internal#2){.+.+}-{0:0}:
> >        check_prev_add kernel/locking/lockdep.c:3165 [inline]
> >        check_prevs_add kernel/locking/lockdep.c:3284 [inline]
> >        validate_chain kernel/locking/lockdep.c:3908 [inline]
> >        __lock_acquire+0x14ae/0x21e0 kernel/locking/lockdep.c:5237
> >        lock_acquire kernel/locking/lockdep.c:5868 [inline]
> >        lock_acquire+0x169/0x2f0 kernel/locking/lockdep.c:5825
> >        percpu_down_read_internal include/linux/percpu-rwsem.h:53 [inlin=
e]
> >        percpu_down_read_freezable include/linux/percpu-rwsem.h:83 [inli=
ne]
> >        __sb_start_write include/linux/fs.h:1916 [inline]
> >        sb_start_intwrite include/linux/fs.h:2099 [inline]
> >        ocfs2_start_trans+0x2a8/0x870 fs/ocfs2/journal.c:370
> >        ocfs2_truncate_inline+0x389/0xbf0 fs/ocfs2/alloc.c:7436
> >        ocfs2_truncate_file+0x6d3/0x13c0 fs/ocfs2/file.c:488
> >        ocfs2_setattr+0xa6d/0x1fd0 fs/ocfs2/file.c:1212
> >        notify_change+0x4b5/0x1030 fs/attr.c:546
> >        do_truncate+0x1d2/0x230 fs/open.c:68
> >        vfs_truncate+0x56c/0x670 fs/open.c:118
> >        do_sys_truncate fs/open.c:141 [inline]
> >        __do_sys_truncate fs/open.c:153 [inline]
> >        __se_sys_truncate fs/open.c:151 [inline]
> >        __x64_sys_truncate+0x165/0x1d0 fs/open.c:151
> >        x64_sys_call+0xbc8/0x26a0 arch/x86/include/generated/asm/syscall=
s_64.h:77
> >        do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
> >        do_syscall_64+0x93/0xf80 arch/x86/entry/syscall_64.c:94
> >        entry_SYSCALL_64_after_hwframe+0x76/0x7e
> >
> > other info that might help us debug this:
> >
> > Chain exists of:
> >   sb_internal#2 --> jbd2_handle --> &ocfs2_file_ip_alloc_sem_key
> >
> >  Possible unsafe locking scenario:
> >
> >        CPU0                    CPU1
> >        ----                    ----
> >   lock(&ocfs2_file_ip_alloc_sem_key);
> >                                lock(jbd2_handle);
> >                                lock(&ocfs2_file_ip_alloc_sem_key);
> >   rlock(sb_internal#2);
> >
> >  *** DEADLOCK ***
> >
> > 3 locks held by syz.0.6/353:
> >  #0: ffff888015936420 (sb_writers#12){.+.+}-{0:0}, at: vfs_truncate+0x3=
0c/0x670 fs/open.c:96
> >  #1: ffff888019156d80 (&sb->s_type->i_mutex_key#18){+.+.}-{4:4}, at: in=
ode_lock_killable include/linux/fs.h:985 [inline]
> >  #1: ffff888019156d80 (&sb->s_type->i_mutex_key#18){+.+.}-{4:4}, at: do=
_truncate+0x139/0x230 fs/open.c:63
> >  #2: ffff888019156a20 (&ocfs2_file_ip_alloc_sem_key){++++}-{4:4}, at: o=
cfs2_truncate_file+0x23a/0x13c0 fs/ocfs2/file.c:471
> >
> > Call Trace:
> >  ...
> >  lock_acquire+0x169/0x2f0 kernel/locking/lockdep.c:5825
> >  percpu_down_read_internal include/linux/percpu-rwsem.h:53 [inline]
> >  percpu_down_read_freezable include/linux/percpu-rwsem.h:83 [inline]
> >  __sb_start_write include/linux/fs.h:1916 [inline]
> >  sb_start_intwrite include/linux/fs.h:2099 [inline]
> >  ocfs2_start_trans+0x2a8/0x870 fs/ocfs2/journal.c:370
> >  ocfs2_truncate_inline+0x389/0xbf0 fs/ocfs2/alloc.c:7436
> >  ocfs2_truncate_file+0x6d3/0x13c0 fs/ocfs2/file.c:488
> >  ocfs2_setattr+0xa6d/0x1fd0 fs/ocfs2/file.c:1212
> >  notify_change+0x4b5/0x1030 fs/attr.c:546
> >  do_truncate+0x1d2/0x230 fs/open.c:68
> >  vfs_truncate+0x56c/0x670 fs/open.c:118
> >  do_sys_truncate fs/open.c:141 [inline]
> >  __do_sys_truncate fs/open.c:153 [inline]
> >  __se_sys_truncate fs/open.c:151 [inline]
> >  __x64_sys_truncate+0x165/0x1d0 fs/open.c:151
> >  ...
> >
> > [CAUSE]
> > ocfs2_truncate_file() and inline range removal hold ip_alloc_sem when
> > calling ocfs2_truncate_inline().  The helper starts a transaction, whic=
h
> > adds an ip_alloc_sem-to-transaction dependency opposite to the existing
> > transaction-to-ip_alloc_sem order in the xattr path.
> >
> > [FIX]
> > Make ocfs2_truncate_inline() use a caller-owned transaction handle. Sta=
rt
> > the inline update transaction before taking ip_alloc_sem in the truncat=
e
>
> But most places (e.g. allocation path) all use ip_alloc_sem -> start tran=
saction.
> So I think the correct choice is to fix the xattr side.
>
> Thanks,
> Joseph

Thanks for the suggestion. I've fixed the xattr side and sent out v2
of the patch.

Thanks,
ZhengYuan Huang
