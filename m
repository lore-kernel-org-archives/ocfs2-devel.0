Received: from mail-vs1-f49.google.com (mail-vs1-f49.google.com [209.85.217.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E8CE3BFE2D
	for <ocfs2-devel@lists.linux.dev>; Fri, 26 Jun 2026 21:28:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.217.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782509332; cv=none; b=mATOQyEITVJoYN7jbhjUWKdrqsWkhMe4lkwdCX2PEqIZR9fEGMvO3enLiu7W25KZ2bcpK0EPyXVtU1Z6aHOyNDASYxyDuuWuxdP7PE/vngadgsO9EmOxFmiXjWBFM6vhA1j0Xrl2Y1TeYU1shDhSBCqPqxVnyC44/gTx9GTFBgI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782509332; c=relaxed/simple;
	bh=wQtj4LZInbvuEoZfkOGZc+RfZ0Noln+2rzblAbUPRX8=;
	h=Message-ID:Date:Subject:To:Cc:Content-Type:MIME-Version:From; b=hf6wMZ6ZAC1EyCj6EK42K9Ab/hw24/bZzK/SCxSGfqmegTvl2kHRvPx/TBglmfDpnS76E2bXy11chjRJJHjs027LZ2KFVTjVJj6GJV46sBFhGBcdSdHspOGWXnvpwqzxgTNi42h88Ze46WGZJOujSAt+4UxS7sDiV1l0bJ8tGls=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=TvXlUe2J; arc=none smtp.client-ip=209.85.217.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="TvXlUe2J"
Received: by mail-vs1-f49.google.com with SMTP id ada2fe7eead31-735acdad080so147506137.0
        for <ocfs2-devel@lists.linux.dev>; Fri, 26 Jun 2026 14:28:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782509330; x=1783114130; darn=lists.linux.dev;
        h=from:mime-version:content-transfer-encoding:content-type:cc:to
         :subject:date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Ms/crckulkRnF+lzLkjAqxS5YcPi02baczyfI0qsEVs=;
        b=TvXlUe2J/QooPIHee2TfWGuu8dGIJ1pH4JBiFIk9YYenwQ3k4nRqH0mFqEhcNKgQSp
         EetzsR3LJ6iLV8XUs6VRIjEJWX/x0PQPRXASxMgjAUcFnlYJwlHteWLK3zxitgJgko2x
         Y0a+iHDBlooaK6Bs9/xzWVju+/xCq7eHHpY16yRn++oIJeq/KPCaPzHJxaW0QdvH9Qei
         SHGthvgoPiopaWUX+oBY0clDZTbKOo2jYjxjleg1XhMpaTYWv6Qtd0XmF7jsHwveWXHM
         BR8pYrxb7d5JInB5XsETdI0kSvXTm8IySGdvZo9ZK7x1cPNWVH2zxhavmhbnDaxLh4Fo
         KEJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782509330; x=1783114130;
        h=from:mime-version:content-transfer-encoding:content-type:cc:to
         :subject:date:message-id:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=Ms/crckulkRnF+lzLkjAqxS5YcPi02baczyfI0qsEVs=;
        b=JDZLv3qU7LNgUs1eycn91w7gqce8TjeMmanxjDyPqvPXwM82/CzpOqkVfzF+Q/IYCm
         bgZbzFjePPkep28wbRyV9/EBNXT+/YH9zoJf3OW49OsNnDyyjuRwD6EiGAOozxOQ7IVy
         8oppVYuYdzpWfgAWkw79sgRSTZtOTdhECbMBvnQicVVMURqmbyKSKl4BPvTXDcKLCe+F
         IswTcF5mcNidmOOFJXe82N9gsab4mz02ROCC2Q2cCm2Jdorbhi15DP8UorrJ3c4PPKj9
         mQzdqR8ANAOBUfEBs1kIdkvDwmHJFXOVMXzGCdTfcSM3iC7uuov7r19+aTu5Gv8VVXAH
         FwEg==
X-Forwarded-Encrypted: i=1; AHgh+RoSj9ADNjGo8dQs24qiFe3n6HUHufDwo4J9V3H9eCX0EkzQYFhFi6MkpxyMdHUsrPzrChgNzDrH53rvUg==@lists.linux.dev
X-Gm-Message-State: AOJu0YzDIrDZjkiuZ9W7O3KX5eZtAFwIUBqQwL/nQf2IK8D2Wm4vMqLx
	2j5QLzn94/tyfGwguZ6XqotBlx7WtJSzsxh5WBuKEpkLvjluAlKUDsQE
X-Gm-Gg: AfdE7cm6m3qFyfKxk5BWy7YvnuyrBCyPpFhgpV4Gr+uww62yy9gZSJ+o/4vyQ+yoks0
	WiCvvXYR6jaCjj1ewOPXuAGIK0JXxCgLBxPzj4EFGAIN+pNl3N755dvDTavVLzYXG2ZZCDdQwth
	sLw6vylMutQZ85WuMqbz+qGLYnyWqOaZ8JhkXBfspvfTXImOxto/cbpfyGsjHllDoy/56kefnUE
	SkxgMI3h9UTJXxfUIVrM1LZF8UbxgsKAm499y/0OTej8NXK8aNZJqLNuEfHfF5IalmotuRX/ueZ
	lwpVzUH+0m3H1wmZ7LcymsajVPGOyafFc55/tuY3YUkvyPXFXwNDH2HXhu5TWSBWbr2uxafU8Zm
	ch6ftTpk0ULu0PfW4iohb0Jrw7mZlip73xPM0aMedV7zlA1sxLoL6qmP4d3aspUehaEt0nEv1hC
	WjDGkE9QODqDbusxtdaRJymrPy648a1wcgQNbnumDlCAKMQez0Cyf1yXhjZMUms+PqaAP4YrRtK
	27sVSrGXMyM
X-Received: by 2002:a05:6102:f83:b0:674:d57b:fcb4 with SMTP id ada2fe7eead31-7343619bffdmr1641740137.4.1782509330131;
        Fri, 26 Jun 2026 14:28:50 -0700 (PDT)
Received: from [192.168.10.115] ([132.170.207.48])
        by smtp.gmail.com with ESMTPSA id ada2fe7eead31-735638689dcsm1989665137.0.2026.06.26.14.28.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 26 Jun 2026 14:28:49 -0700 (PDT)
Message-ID: <6a3eef11.26dcea81.1cc135.d63b@mx.google.com>
Date: Fri, 26 Jun 2026 14:28:49 -0700 (PDT)
Subject: possible deadlock in ocfs2_reserve_local_alloc_bits
To: mark@fasheh.com, jlbec@evilplan.org, joseph.qi@linux.alibaba.com,
 ocfs2-devel@lists.linux.dev, linux-kernel@vger.kernel.org
Cc: syzkaller@googlegroups.com, contact@pgazz.com
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
From: sanan.hasanou@gmail.com

Good day, dear maintainers,

We found a bug using a modified version of syzkaller.

Kernel Branch: 7.0-rc1
Kernel Config: <https://drive.google.com/open?id=1pN21FuDB9QSbn_3jaZGO1S5v7x7Qe-yl>
Reproducer: <https://drive.google.com/open?id=1ImQo8kSKiuXjxNHmTGYAguyy132NdzzR>
Thank you!

Best regards,
Sanan Hasanov

ocfs2: Mounting device (7,2) on (node local, slot 0) with ordered data mode.
======================================================
WARNING: possible circular locking dependency detected
7.0.0-rc1 #1 Not tainted
------------------------------------------------------
syz.2.9439/46503 is trying to acquire lock:
ffff88803c839800 (&ocfs2_sysfile_lock_key[LOCAL_ALLOC_SYSTEM_INODE]){+.+.}-{4:4}, at: inode_lock include/linux/fs.h:1028 [inline]
ffff88803c839800 (&ocfs2_sysfile_lock_key[LOCAL_ALLOC_SYSTEM_INODE]){+.+.}-{4:4}, at: ocfs2_reserve_local_alloc_bits+0x12a/0x2980 fs/ocfs2/localalloc.c:636

but task is already holding lock:
ffff88802ced6a20 (&ocfs2_file_ip_alloc_sem_key){++++}-{4:4}, at: ocfs2_expand_inline_dir fs/ocfs2/dir.c:2846 [inline]
ffff88802ced6a20 (&ocfs2_file_ip_alloc_sem_key){++++}-{4:4}, at: ocfs2_extend_dir+0x623/0x4780 fs/ocfs2/dir.c:3227

which lock already depends on the new lock.


the existing dependency chain (in reverse order) is:

-> #4 (&ocfs2_file_ip_alloc_sem_key){++++}-{4:4}:
       down_write+0x96/0x1e0 kernel/locking/rwsem.c:1590
       ocfs2_try_remove_refcount_tree+0xb6/0x320 fs/ocfs2/refcounttree.c:933
       ocfs2_xattr_set+0x5c1/0x1220 fs/ocfs2/xattr.c:3700
       ocfs2_set_acl+0x701/0x7b0 fs/ocfs2/acl.c:255
       ocfs2_iop_set_acl+0x1aa/0x2a0 fs/ocfs2/acl.c:287
       set_posix_acl fs/posix_acl.c:955 [inline]
       vfs_set_acl+0x8f9/0xbf0 fs/posix_acl.c:1134
       do_setxattr fs/xattr.c:633 [inline]
       filename_setxattr+0x2f4/0x610 fs/xattr.c:664
       path_setxattrat+0x356/0x3a0 fs/xattr.c:708
       __do_sys_setxattr fs/xattr.c:742 [inline]
       __se_sys_setxattr fs/xattr.c:738 [inline]
       __x64_sys_setxattr+0xbc/0xd0 fs/xattr.c:738
       do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
       do_syscall_64+0x11c/0x800 arch/x86/entry/syscall_64.c:94
       entry_SYSCALL_64_after_hwframe+0x4b/0x53

-> #3 (&oi->ip_xattr_sem){++++}-{4:4}:
       down_read+0x97/0x2c0 kernel/locking/rwsem.c:1537
       ocfs2_init_acl+0x2f7/0x7a0 fs/ocfs2/acl.c:367
       ocfs2_mknod+0x128d/0x20d0 fs/ocfs2/namei.c:414
       ocfs2_create+0x160/0x3e0 fs/ocfs2/namei.c:677
       lookup_open fs/namei.c:4483 [inline]
       open_last_lookups fs/namei.c:4583 [inline]
       path_openat+0x1388/0x3730 fs/namei.c:4827
       do_file_open+0x203/0x440 fs/namei.c:4859
       do_sys_openat2+0x105/0x1d0 fs/open.c:1366
       do_sys_open fs/open.c:1372 [inline]
       __do_sys_openat fs/open.c:1388 [inline]
       __se_sys_openat fs/open.c:1383 [inline]
       __x64_sys_openat+0x138/0x160 fs/open.c:1383
       do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
       do_syscall_64+0x11c/0x800 arch/x86/entry/syscall_64.c:94
       entry_SYSCALL_64_after_hwframe+0x4b/0x53

-> #2 (&journal->j_trans_barrier){.+.+}-{4:4}:
       down_read+0x97/0x2c0 kernel/locking/rwsem.c:1537
       ocfs2_start_trans+0x36a/0x6d0 fs/ocfs2/journal.c:369
       ocfs2_modify_bh+0xe8/0x470 fs/ocfs2/quota_local.c:101
       ocfs2_local_read_info+0x1460/0x17e0 fs/ocfs2/quota_local.c:767
       dquot_load_quota_sb+0x78b/0xba0 fs/quota/dquot.c:2462
       dquot_load_quota_inode+0x2dc/0x5d0 fs/quota/dquot.c:2499
       ocfs2_enable_quotas+0x1c6/0x440 fs/ocfs2/super.c:930
       ocfs2_fill_super+0x5085/0x6370 fs/ocfs2/super.c:1140
       get_tree_bdev_flags+0x402/0x4c0 fs/super.c:1694
       vfs_get_tree+0x8d/0x1d0 fs/super.c:1754
       fc_mount fs/namespace.c:1193 [inline]
       do_new_mount_fc fs/namespace.c:3760 [inline]
       do_new_mount+0x31a/0xce0 fs/namespace.c:3836
       do_mount fs/namespace.c:4159 [inline]
       __do_sys_mount fs/namespace.c:4348 [inline]
       __se_sys_mount+0x313/0x400 fs/namespace.c:4325
       do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
       do_syscall_64+0x11c/0x800 arch/x86/entry/syscall_64.c:94
       entry_SYSCALL_64_after_hwframe+0x4b/0x53

-> #1 (sb_internal#3){.+.+}-{0:0}:
       percpu_down_read_internal include/linux/percpu-rwsem.h:53 [inline]
       percpu_down_read_freezable include/linux/percpu-rwsem.h:83 [inline]
       __sb_start_write include/linux/fs/super.h:19 [inline]
       sb_start_intwrite include/linux/fs/super.h:177 [inline]
       ocfs2_start_trans+0x26b/0x6d0 fs/ocfs2/journal.c:367
       ocfs2_mknod+0xdfb/0x20d0 fs/ocfs2/namei.c:365
       ocfs2_create+0x160/0x3e0 fs/ocfs2/namei.c:677
       lookup_open fs/namei.c:4483 [inline]
       open_last_lookups fs/namei.c:4583 [inline]
       path_openat+0x1388/0x3730 fs/namei.c:4827
       do_file_open+0x203/0x440 fs/namei.c:4859
       do_sys_openat2+0x105/0x1d0 fs/open.c:1366
       do_sys_open fs/open.c:1372 [inline]
       __do_sys_openat fs/open.c:1388 [inline]
       __se_sys_openat fs/open.c:1383 [inline]
       __x64_sys_openat+0x138/0x160 fs/open.c:1383
       do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
       do_syscall_64+0x11c/0x800 arch/x86/entry/syscall_64.c:94
       entry_SYSCALL_64_after_hwframe+0x4b/0x53

-> #0 (&ocfs2_sysfile_lock_key[LOCAL_ALLOC_SYSTEM_INODE]){+.+.}-{4:4}:
       check_prev_add kernel/locking/lockdep.c:3165 [inline]
       check_prevs_add kernel/locking/lockdep.c:3284 [inline]
       validate_chain kernel/locking/lockdep.c:3908 [inline]
       __lock_acquire+0x1591/0x2870 kernel/locking/lockdep.c:5237
       lock_acquire+0xe0/0x290 kernel/locking/lockdep.c:5868
       down_write+0x96/0x1e0 kernel/locking/rwsem.c:1590
       inode_lock include/linux/fs.h:1028 [inline]
       ocfs2_reserve_local_alloc_bits+0x12a/0x2980 fs/ocfs2/localalloc.c:636
       ocfs2_reserve_clusters_with_limit+0x1be/0xba0 fs/ocfs2/suballoc.c:1237
       ocfs2_expand_inline_dir fs/ocfs2/dir.c:2882 [inline]
       ocfs2_extend_dir+0x6dd/0x4780 fs/ocfs2/dir.c:3227
       ocfs2_prepare_dir_for_insert+0x3080/0x4e90 fs/ocfs2/dir.c:4345
       ocfs2_symlink+0xb13/0x2520 fs/ocfs2/namei.c:1876
       vfs_symlink+0x18a/0x330 fs/namei.c:5615
       filename_symlinkat+0x19c/0x3e0 fs/namei.c:5640
       __do_sys_symlink fs/namei.c:5667 [inline]
       __se_sys_symlink+0x4d/0x280 fs/namei.c:5663
       do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
       do_syscall_64+0x11c/0x800 arch/x86/entry/syscall_64.c:94
       entry_SYSCALL_64_after_hwframe+0x4b/0x53

other info that might help us debug this:

Chain exists of:
  &ocfs2_sysfile_lock_key[LOCAL_ALLOC_SYSTEM_INODE] --> &oi->ip_xattr_sem --> &ocfs2_file_ip_alloc_sem_key

 Possible unsafe locking scenario:

       CPU0                    CPU1
       ----                    ----
  lock(&ocfs2_file_ip_alloc_sem_key);
                               lock(&oi->ip_xattr_sem);
                               lock(&ocfs2_file_ip_alloc_sem_key);
  lock(&ocfs2_sysfile_lock_key[LOCAL_ALLOC_SYSTEM_INODE]);

 *** DEADLOCK ***

3 locks held by syz.2.9439/46503:
 #0: ffff88801c57e410 (sb_writers#19){.+.+}-{0:0}, at: mnt_want_write+0x41/0x90 fs/namespace.c:493
 #1: ffff88802ced6d80 (&type->i_mutex_dir_key#12/1){+.+.}-{4:4}, at: inode_lock_nested include/linux/fs.h:1073 [inline]
 #1: ffff88802ced6d80 (&type->i_mutex_dir_key#12/1){+.+.}-{4:4}, at: __start_dirop fs/namei.c:2923 [inline]
 #1: ffff88802ced6d80 (&type->i_mutex_dir_key#12/1){+.+.}-{4:4}, at: start_dirop fs/namei.c:2934 [inline]
 #1: ffff88802ced6d80 (&type->i_mutex_dir_key#12/1){+.+.}-{4:4}, at: filename_create+0x1fb/0x360 fs/namei.c:4922
 #2: ffff88802ced6a20 (&ocfs2_file_ip_alloc_sem_key){++++}-{4:4}, at: ocfs2_expand_inline_dir fs/ocfs2/dir.c:2846 [inline]
 #2: ffff88802ced6a20 (&ocfs2_file_ip_alloc_sem_key){++++}-{4:4}, at: ocfs2_extend_dir+0x623/0x4780 fs/ocfs2/dir.c:3227

stack backtrace:
CPU: 0 UID: 0 PID: 46503 Comm: syz.2.9439 Not tainted 7.0.0-rc1 #1 PREEMPT(full) 
Hardware name: QEMU Ubuntu 24.04 PC v2 (i440FX + PIIX, arch_caps fix, 1996), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
Call Trace:
 <TASK>
 dump_stack_lvl+0xe8/0x150 lib/dump_stack.c:120
 print_circular_bug+0x2f8/0x340 kernel/locking/lockdep.c:2043
 check_noncircular+0x109/0x130 kernel/locking/lockdep.c:2175
 check_prev_add kernel/locking/lockdep.c:3165 [inline]
 check_prevs_add kernel/locking/lockdep.c:3284 [inline]
 validate_chain kernel/locking/lockdep.c:3908 [inline]
 __lock_acquire+0x1591/0x2870 kernel/locking/lockdep.c:5237
 lock_acquire+0xe0/0x290 kernel/locking/lockdep.c:5868
 down_write+0x96/0x1e0 kernel/locking/rwsem.c:1590
 inode_lock include/linux/fs.h:1028 [inline]
 ocfs2_reserve_local_alloc_bits+0x12a/0x2980 fs/ocfs2/localalloc.c:636
 ocfs2_reserve_clusters_with_limit+0x1be/0xba0 fs/ocfs2/suballoc.c:1237
 ocfs2_expand_inline_dir fs/ocfs2/dir.c:2882 [inline]
 ocfs2_extend_dir+0x6dd/0x4780 fs/ocfs2/dir.c:3227
 ocfs2_prepare_dir_for_insert+0x3080/0x4e90 fs/ocfs2/dir.c:4345
 ocfs2_symlink+0xb13/0x2520 fs/ocfs2/namei.c:1876
 vfs_symlink+0x18a/0x330 fs/namei.c:5615
 filename_symlinkat+0x19c/0x3e0 fs/namei.c:5640
 __do_sys_symlink fs/namei.c:5667 [inline]
 __se_sys_symlink+0x4d/0x280 fs/namei.c:5663
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0x11c/0x800 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x4b/0x53
RIP: 0033:0x7f9e2e9a3b6d
Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 90 f3 0f 1e fa 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 b0 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f9e2f830018 EFLAGS: 00000246 ORIG_RAX: 0000000000000058
RAX: ffffffffffffffda RBX: 00007f9e2ec15fa0 RCX: 00007f9e2e9a3b6d
RDX: 0000000000000000 RSI: 00002000000001c0 RDI: 0000200000000300
RBP: 00007f9e2ea47c3e R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007f9e2ec16038 R14: 00007f9e2ec15fa0 R15: 00007fff50e045a0
 </TASK>
syz.2.9439 (46503) used greatest stack depth: 19688 bytes left

<<<<<<<<<<<<<<< tail report >>>>>>>>>>>>>>>
