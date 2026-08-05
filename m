Received: from out30-99.freemail.mail.aliyun.com (out30-99.freemail.mail.aliyun.com [115.124.30.99])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 291063EB0E1
	for <ocfs2-devel@lists.linux.dev>; Wed,  5 Aug 2026 11:42:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.99
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785930172; cv=none; b=O5LD19hNq7fUNv+FCQ6wO6L4aqE9bcjIpiAEnkwWBwbvkaFn2CB442o7oTBh84YJFna2jOLn85ir6DbICdJf2LThXZW1YD1WmxXEBTmY9xeS1ZqOx8iNi45KOQI6jPiprV7OoJexYGNjmBTekD2xxuKs06VW5YFi0+JQQwcmr0s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785930172; c=relaxed/simple;
	bh=ZzXr+Ds50SnU80VprDRyMDTGIWgrY2EzN64e/HsgDLU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=RmIZJORyk33x6HkVCFeNfFeAkDYy1ZwfHrGDLE2Y0p5pvVCW5dRSM+WC76A07KOhwgko2IwxyxPZzYnXeucz1IEXG0N+Um4BLSwNztcp9Cw/5pnniIE7j7oqMO7hyNGLx3f/NARNDKfkTQbYK4N96EeWL+bPjnAVJrH/uINwyl8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=kYGEaupI; arc=none smtp.client-ip=115.124.30.99
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="kYGEaupI"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1785930159; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=mleWbuJnTG61X0nVnuD8/Lge1cJ0UwOk1tdcMLCAvcE=;
	b=kYGEaupIhPItFTaKASQ72o+3/ycdZGPNLcEfPCMSHLQcyu2sOoLSIyslEFv0fTVxWF3hVUqKzbXfXFjqMiymxPWcbVZ5EbLRZlYi+DMt7TPtKG8yk5jh1opsZOtFeuLyio2E76n3J9Bfk1LNnNDwT+tD93CLqLbjBEGKGcY/95I=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R161e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033032089153;MF=joseph.qi@linux.alibaba.com;NM=1;PH=DS;RN=10;SR=0;TI=SMTPD_---0X8R8zhB_1785930157;
Received: from 30.166.0.128(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0X8R8zhB_1785930157 cluster:ay36)
          by smtp.aliyun-inc.com;
          Wed, 05 Aug 2026 19:42:38 +0800
Message-ID: <61725d38-1a5d-4390-9e63-6875a1e8245e@linux.alibaba.com>
Date: Wed, 5 Aug 2026 19:42:35 +0800
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] ocfs2: fix deadlock in inline-data truncate transactions
To: ZhengYuan Huang <gality369@gmail.com>
Cc: mark@fasheh.com, jlbec@evilplan.org, ocfs2-devel@lists.linux.dev,
 linux-kernel@vger.kernel.org, baijiaju1990@gmail.com, r33s3n6@gmail.com,
 zzzccc427@gmail.com, tom442288@tuta.io, Heming Zhao <heming.zhao@suse.com>
References: <20260803032346.3997901-1-gality369@gmail.com>
From: Joseph Qi <joseph.qi@linux.alibaba.com>
In-Reply-To: <20260803032346.3997901-1-gality369@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 8/3/26 11:23 AM, ZhengYuan Huang wrote:
> [BUG]
> Shrinking an inline-data file can trigger a real ABBA deadlock cycle and
> lockdep warning:
> 
> WARNING: possible circular locking dependency detected
> ------------------------------------------------------
> syz.0.6/353 is trying to acquire lock:
> ffff888015936610 (sb_internal#2){.+.+}-{0:0}, at: ocfs2_truncate_inline+0x389/0xbf0 fs/ocfs2/alloc.c:7436
> 
> but task is already holding lock:
> ffff888019156a20 (&ocfs2_file_ip_alloc_sem_key){++++}-{4:4}, at: ocfs2_truncate_file+0x23a/0x13c0 fs/ocfs2/file.c:471
> 
> which lock already depends on the new lock.
> 
> the existing dependency chain (in reverse order) is:
> 
> -> #3 (&ocfs2_file_ip_alloc_sem_key){++++}-{4:4}:
>        down_write+0x8f/0x200 kernel/locking/rwsem.c:1590
>        ocfs2_xattr_ibody_set+0x119/0xc50 fs/ocfs2/xattr.c:2783
>        __ocfs2_xattr_set_handle+0xdb/0xdb0 fs/ocfs2/xattr.c:3322
>        ocfs2_xattr_set+0x1447/0x2610 fs/ocfs2/xattr.c:3650
>        ocfs2_xattr_security_set+0x37/0x50 fs/ocfs2/xattr.c:7241
>        __vfs_setxattr+0x14f/0x1c0 fs/xattr.c:200
>        __vfs_setxattr_noperm+0x10b/0x5c0 fs/xattr.c:234
>        __vfs_setxattr_locked+0x172/0x240 fs/xattr.c:295
>        vfs_setxattr+0x167/0x390 fs/xattr.c:321
>        do_setxattr+0x13c/0x180 fs/xattr.c:636
>        filename_setxattr+0x16b/0x1c0 fs/xattr.c:665
>        path_setxattrat+0x1d8/0x280 fs/xattr.c:713
>        __do_sys_setxattr fs/xattr.c:747 [inline]
>        __se_sys_setxattr fs/xattr.c:743 [inline]
>        __x64_sys_setxattr+0xcd/0x150 fs/xattr.c:743
>        x64_sys_call+0x148c/0x26a0 arch/x86/include/generated/asm/syscalls_64.h:189
>        do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>        do_syscall_64+0x93/0xf80 arch/x86/entry/syscall_64.c:94
>        entry_SYSCALL_64_after_hwframe+0x76/0x7e
> 
> -> #2 (jbd2_handle){++++}-{0:0}:
>        start_this_handle+0x5c7/0x13c0 fs/jbd2/transaction.c:444
>        jbd2__journal_start+0x397/0x690 fs/jbd2/transaction.c:501
>        jbd2_journal_start+0x31/0x50 fs/jbd2/transaction.c:540
>        ocfs2_start_trans+0x39b/0x870 fs/ocfs2/journal.c:374
>        ocfs2_xattr_set+0x1401/0x2610 fs/ocfs2/xattr.c:3643
>        ocfs2_xattr_security_set+0x37/0x50 fs/ocfs2/xattr.c:7241
>        __vfs_setxattr+0x14f/0x1c0 fs/xattr.c:200
>        __vfs_setxattr_noperm+0x10b/0x5c0 fs/xattr.c:234
>        __vfs_setxattr_locked+0x172/0x240 fs/xattr.c:295
>        vfs_setxattr+0x167/0x390 fs/xattr.c:321
>        do_setxattr+0x13c/0x180 fs/xattr.c:636
>        filename_setxattr+0x16b/0x1c0 fs/xattr.c:665
>        path_setxattrat+0x1d8/0x280 fs/xattr.c:713
>        __do_sys_setxattr fs/xattr.c:747 [inline]
>        __se_sys_setxattr fs/xattr.c:743 [inline]
>        __x64_sys_setxattr+0xcd/0x150 fs/xattr.c:743
>        x64_sys_call+0x148c/0x26a0 arch/x86/include/generated/asm/syscalls_64.h:189
>        do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>        do_syscall_64+0x93/0xf80 arch/x86/entry/syscall_64.c:94
>        entry_SYSCALL_64_after_hwframe+0x76/0x7e
> 
> -> #1 (&journal->j_trans_barrier){.+.+}-{4:4}:
>        down_read+0x9c/0x4a0 kernel/locking/rwsem.c:1537
>        ocfs2_start_trans+0x390/0x870 fs/ocfs2/journal.c:372
>        ocfs2_xattr_set+0x1401/0x2610 fs/ocfs2/xattr.c:3643
>        ocfs2_xattr_security_set+0x37/0x50 fs/ocfs2/xattr.c:7241
>        __vfs_setxattr+0x14f/0x1c0 fs/xattr.c:200
>        __vfs_setxattr_noperm+0x10b/0x5c0 fs/xattr.c:234
>        __vfs_setxattr_locked+0x172/0x240 fs/xattr.c:295
>        vfs_setxattr+0x167/0x390 fs/xattr.c:321
>        do_setxattr+0x13c/0x180 fs/xattr.c:636
>        filename_setxattr+0x16b/0x1c0 fs/xattr.c:665
>        path_setxattrat+0x1d8/0x280 fs/xattr.c:713
>        __do_sys_setxattr fs/xattr.c:747 [inline]
>        __se_sys_setxattr fs/xattr.c:743 [inline]
>        __x64_sys_setxattr+0xcd/0x150 fs/xattr.c:743
>        x64_sys_call+0x148c/0x26a0 arch/x86/include/generated/asm/syscalls_64.h:189
>        do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>        do_syscall_64+0x93/0xf80 arch/x86/entry/syscall_64.c:94
>        entry_SYSCALL_64_after_hwframe+0x76/0x7e
> 
> -> #0 (sb_internal#2){.+.+}-{0:0}:
>        check_prev_add kernel/locking/lockdep.c:3165 [inline]
>        check_prevs_add kernel/locking/lockdep.c:3284 [inline]
>        validate_chain kernel/locking/lockdep.c:3908 [inline]
>        __lock_acquire+0x14ae/0x21e0 kernel/locking/lockdep.c:5237
>        lock_acquire kernel/locking/lockdep.c:5868 [inline]
>        lock_acquire+0x169/0x2f0 kernel/locking/lockdep.c:5825
>        percpu_down_read_internal include/linux/percpu-rwsem.h:53 [inline]
>        percpu_down_read_freezable include/linux/percpu-rwsem.h:83 [inline]
>        __sb_start_write include/linux/fs.h:1916 [inline]
>        sb_start_intwrite include/linux/fs.h:2099 [inline]
>        ocfs2_start_trans+0x2a8/0x870 fs/ocfs2/journal.c:370
>        ocfs2_truncate_inline+0x389/0xbf0 fs/ocfs2/alloc.c:7436
>        ocfs2_truncate_file+0x6d3/0x13c0 fs/ocfs2/file.c:488
>        ocfs2_setattr+0xa6d/0x1fd0 fs/ocfs2/file.c:1212
>        notify_change+0x4b5/0x1030 fs/attr.c:546
>        do_truncate+0x1d2/0x230 fs/open.c:68
>        vfs_truncate+0x56c/0x670 fs/open.c:118
>        do_sys_truncate fs/open.c:141 [inline]
>        __do_sys_truncate fs/open.c:153 [inline]
>        __se_sys_truncate fs/open.c:151 [inline]
>        __x64_sys_truncate+0x165/0x1d0 fs/open.c:151
>        x64_sys_call+0xbc8/0x26a0 arch/x86/include/generated/asm/syscalls_64.h:77
>        do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>        do_syscall_64+0x93/0xf80 arch/x86/entry/syscall_64.c:94
>        entry_SYSCALL_64_after_hwframe+0x76/0x7e
> 
> other info that might help us debug this:
> 
> Chain exists of:
>   sb_internal#2 --> jbd2_handle --> &ocfs2_file_ip_alloc_sem_key
> 
>  Possible unsafe locking scenario:
> 
>        CPU0                    CPU1
>        ----                    ----
>   lock(&ocfs2_file_ip_alloc_sem_key);
>                                lock(jbd2_handle);
>                                lock(&ocfs2_file_ip_alloc_sem_key);
>   rlock(sb_internal#2);
> 
>  *** DEADLOCK ***
> 
> 3 locks held by syz.0.6/353:
>  #0: ffff888015936420 (sb_writers#12){.+.+}-{0:0}, at: vfs_truncate+0x30c/0x670 fs/open.c:96
>  #1: ffff888019156d80 (&sb->s_type->i_mutex_key#18){+.+.}-{4:4}, at: inode_lock_killable include/linux/fs.h:985 [inline]
>  #1: ffff888019156d80 (&sb->s_type->i_mutex_key#18){+.+.}-{4:4}, at: do_truncate+0x139/0x230 fs/open.c:63
>  #2: ffff888019156a20 (&ocfs2_file_ip_alloc_sem_key){++++}-{4:4}, at: ocfs2_truncate_file+0x23a/0x13c0 fs/ocfs2/file.c:471
> 
> Call Trace:
>  ...
>  lock_acquire+0x169/0x2f0 kernel/locking/lockdep.c:5825
>  percpu_down_read_internal include/linux/percpu-rwsem.h:53 [inline]
>  percpu_down_read_freezable include/linux/percpu-rwsem.h:83 [inline]
>  __sb_start_write include/linux/fs.h:1916 [inline]
>  sb_start_intwrite include/linux/fs.h:2099 [inline]
>  ocfs2_start_trans+0x2a8/0x870 fs/ocfs2/journal.c:370
>  ocfs2_truncate_inline+0x389/0xbf0 fs/ocfs2/alloc.c:7436
>  ocfs2_truncate_file+0x6d3/0x13c0 fs/ocfs2/file.c:488
>  ocfs2_setattr+0xa6d/0x1fd0 fs/ocfs2/file.c:1212
>  notify_change+0x4b5/0x1030 fs/attr.c:546
>  do_truncate+0x1d2/0x230 fs/open.c:68
>  vfs_truncate+0x56c/0x670 fs/open.c:118
>  do_sys_truncate fs/open.c:141 [inline]
>  __do_sys_truncate fs/open.c:153 [inline]
>  __se_sys_truncate fs/open.c:151 [inline]
>  __x64_sys_truncate+0x165/0x1d0 fs/open.c:151
>  ...
> 
> [CAUSE]
> ocfs2_truncate_file() and inline range removal hold ip_alloc_sem when
> calling ocfs2_truncate_inline().  The helper starts a transaction, which
> adds an ip_alloc_sem-to-transaction dependency opposite to the existing
> transaction-to-ip_alloc_sem order in the xattr path.
> 
> [FIX]
> Make ocfs2_truncate_inline() use a caller-owned transaction handle. Start
> the inline update transaction before taking ip_alloc_sem in the truncate

But most places (e.g. allocation path) all use ip_alloc_sem -> start transaction.
So I think the correct choice is to fix the xattr side.

Thanks,
Joseph

> and range-removal callers, and release an unused handle if inline data was
> converted to extents while waiting for the semaphore. This keeps the
> inline update serialized by ip_alloc_sem while preserving a single
> transaction-before-ip_alloc_sem order.
> 
> Fixes: 85db90e77806 ("ocfs2/xattr: Merge xattr set transaction.")
> Signed-off-by: ZhengYuan Huang <gality369@gmail.com>

