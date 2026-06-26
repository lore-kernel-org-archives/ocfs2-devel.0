Received: from mail-vk1-f178.google.com (mail-vk1-f178.google.com [209.85.221.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 099D63BFAEF
	for <ocfs2-devel@lists.linux.dev>; Fri, 26 Jun 2026 21:27:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782509242; cv=none; b=PdxCnJX7GtU9QNuPlIucKl47zWj5uL27PYdL6wWPF3YdB2pKnzleFfUHO1nM4fIrWCiHcrzD5GhHhNqCaBkVeRjytRnQstQ4ZX32cmFB6LFqDGRBZYZJpMAe112So6D4kro9NOEaRN0+7ncC8Bvsr11ZafljC5T09IqALHSk7zs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782509242; c=relaxed/simple;
	bh=rorb/JZtTMwfma8MtwM1cLcJxMzlSrGRa7jl5Ug+nBk=;
	h=Message-ID:Date:Subject:To:Cc:Content-Type:MIME-Version:From; b=iVIydPBuQxJTWYMKSL3cUk/ZbgeP4Uu3mO+bXLxnY7aA8xFoGTKVpO5kvlohzrSoOzRdbrCXuCGTmSIJtSEVSV2lBxCiX+o/kdi588DKtgyKRp/8ECIkVEenOjncljzrtNXdUb3zZNP8iug23rF2S7Dwy5z48BSWnt8z/FfUbLg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=rpo5WCvt; arc=none smtp.client-ip=209.85.221.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="rpo5WCvt"
Received: by mail-vk1-f178.google.com with SMTP id 71dfb90a1353d-5bd88894527so4552e0c.3
        for <ocfs2-devel@lists.linux.dev>; Fri, 26 Jun 2026 14:27:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782509240; x=1783114040; darn=lists.linux.dev;
        h=from:mime-version:content-transfer-encoding:content-type:cc:to
         :subject:date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=rgcMmZZoZ628aE4T+aHzGAIYH+I0I1CnMP0w2SkOZTY=;
        b=rpo5WCvtyy5wPXNR2nDKrusakhFClF59Jb+8W6YwWxC1M0g6bwjg5iQ+X4uQYyurxZ
         O/RjhNFuVpQhj8Zyu1chIdUvsmeX/3ZKLptLuZ84/kmYDs1I0iSUjEb99VHDe0YmqglW
         OIgQtqUMtdI50d16mE13ObtExhv5CZBEuEBfCyie+0wMO6dHae5bghR8GdNbc/wX9t6O
         JKMYrtoDnW1bl1X8Z42SGzVjH8aoj/Vtrcu/HCQm4PCdyz+DE8QsPnRpMTA1yIZZrbbj
         196Ylq8BNHIeuF/7abHE6vnctObpyYBkIwwdUiyaEj6tFr9ZOYbEE6+zKyQN6AtfRhXO
         LaKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782509240; x=1783114040;
        h=from:mime-version:content-transfer-encoding:content-type:cc:to
         :subject:date:message-id:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=rgcMmZZoZ628aE4T+aHzGAIYH+I0I1CnMP0w2SkOZTY=;
        b=migiGJUWuKIAnI1oG5wJEdrMJTZ36jJ/MsdDrnP4G76eN7t2whHqASkBDq+5sTQbQl
         mTSEECu1tz5PvFXBk+DG+KuhCBCRBa5wXrKAhJOkWZ4m7xTLoOBeFwjKWcY3xV2I1+VJ
         OYwCu90OBZEi3xhYprU/j6P/nYsuV+xyG+OGeBtJ5WtvXLyAMIa7MPfNEevbSamqkp5W
         2NVi3V7OEtbIivAKZGjVtv8QGpL7JGgoqt/jm2x5k68zRik9WnvpJAwFFRQY+CLvTaql
         BR7rEFyRrNRhgUov/RGEUxQrZOBENVvW4kUo22R6kjFBEspt6k/W4GD3EkBYfMhqVcsa
         LuwQ==
X-Forwarded-Encrypted: i=1; AHgh+Rqy80IYxeGW1Twb/X0LdH1dc2z/6YDm4/lnmvTWtEQbZfY2QVkpNPdQLnTw+A2iC5K2O6i+earb2F0M0A==@lists.linux.dev
X-Gm-Message-State: AOJu0Yz88Cz46BjUzhxBjMxVnUd0vZ8ta3W8BdmuBjgS9LdstSd+Gw+Z
	5fO3iy69AE+uWdyzll1fFnACjUa8hNNpCuAh5y3xswryckqKbzDD9HmLqTUGfxyT
X-Gm-Gg: AfdE7cnEVNov/Ogx1M0vOxCPryHwpQuLUu7S48bOK1G3CTPLkMQRtr+xO2Z97vtokxA
	70qTJn+v2DVVfiB/eYmuEqzgnaBE0yRs1IOJKOEvXqFc0Sfb77zFeyBlbgrXmasSCVUHrYlcYtY
	lhTfHgLll+W2B4ppruJFAL6bl9vWGqd7CxQ0SXFKyINyvad72LmH30dw2iNsJMhcwTnM/cvjcHV
	eOS3YeAksPV3S1+scXDmmv2ByNZ7DATUii3UfopkepItWYJ8R1o1LcUs7jZtwr/2A7iSwq0qlH0
	SIeJJXSKuu/hYZgiQpS/gqhJ4vYH3umx+XUnjeGNdMmyPewXtfUQLOfB9IUfHzj/B3vsuAF6jQn
	gVJAAFrP54iLiS4LYal22C7AmW79HyqG8i5doLc+6Qy2L2faEzi/cIEnhmUq7OyVURXvzWkhcYn
	MtsurMQ6uciELpY6pmZ0Vd974rg6L0XUviF+qz/InORrpTZQlmHLng1h+xxF9/B7cy/xXwr0ZVY
	RXvLNRGEmCx
X-Received: by 2002:a05:6122:10e5:b0:598:841f:f2f8 with SMTP id 71dfb90a1353d-5bd69dc65fdmr1202182e0c.3.1782509240016;
        Fri, 26 Jun 2026 14:27:20 -0700 (PDT)
Received: from [192.168.10.115] ([132.170.207.48])
        by smtp.gmail.com with ESMTPSA id 71dfb90a1353d-5bd78e4db40sm1877978e0c.1.2026.06.26.14.27.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 26 Jun 2026 14:27:19 -0700 (PDT)
Message-ID: <6a3eeeb7.39484e70.323465.3909@mx.google.com>
Date: Fri, 26 Jun 2026 14:27:19 -0700 (PDT)
Subject: possible deadlock in ocfs2_reserve_suballoc_bits
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
Kernel Config: <https://drive.google.com/open?id=1zJHAs5GUroGFBkxAlzfDaWAd_NVPZTfJ>
Unfortunately, we don't have any reproducer for this bug yet.
Thank you!

Best regards,
Sanan Hasanov

======================================================
WARNING: possible circular locking dependency detected
7.0.0-rc1 #1 Tainted: G             L     
------------------------------------------------------
syz.3.30336/128034 is trying to acquire lock:
ffff888058ac2640 (&ocfs2_sysfile_lock_key[EXTENT_ALLOC_SYSTEM_INODE]){+.+.}-{4:4}, at: inode_lock include/linux/fs.h:1028 [inline]
ffff888058ac2640 (&ocfs2_sysfile_lock_key[EXTENT_ALLOC_SYSTEM_INODE]){+.+.}-{4:4}, at: ocfs2_reserve_suballoc_bits+0x168/0x46a0 fs/ocfs2/suballoc.c:857

but task is already holding lock:
ffff888058a6ce38 (&oi->ip_xattr_sem){++++}-{4:4}, at: ocfs2_xattr_set+0x42c/0x1210 fs/ocfs2/xattr.c:3614

which lock already depends on the new lock.


the existing dependency chain (in reverse order) is:

-> #4 (&oi->ip_xattr_sem){++++}-{4:4}:
       down_read+0x4c/0x2e0 kernel/locking/rwsem.c:1537
       ocfs2_init_acl+0x2f7/0x7a0 fs/ocfs2/acl.c:367
       ocfs2_mknod+0x1327/0x20c0 fs/ocfs2/namei.c:414
       ocfs2_mkdir+0x181/0x470 fs/ocfs2/namei.c:660
       vfs_mkdir+0x41a/0x630 fs/namei.c:5233
       filename_mkdirat+0x27b/0x500 fs/namei.c:5266
       __do_sys_mkdirat fs/namei.c:5287 [inline]
       __se_sys_mkdirat+0x38/0x160 fs/namei.c:5284
       __x64_sys_mkdirat+0x7f/0x90 fs/namei.c:5284
       x64_sys_call+0x26a0/0x2900 arch/x86/include/generated/asm/syscalls_64.h:259
       do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
       do_syscall_64+0x160/0xfc0 arch/x86/entry/syscall_64.c:94
       entry_SYSCALL_64_after_hwframe+0x4b/0x53

-> #3 (&journal->j_trans_barrier){.+.+}-{4:4}:
       down_read+0x4c/0x2e0 kernel/locking/rwsem.c:1537
       ocfs2_start_trans+0x36a/0x6d0 fs/ocfs2/journal.c:369
       ocfs2_mknod+0xe97/0x20c0 fs/ocfs2/namei.c:365
       ocfs2_create+0x195/0x470 fs/ocfs2/namei.c:677
       lookup_open fs/namei.c:4483 [inline]
       open_last_lookups fs/namei.c:4583 [inline]
       path_openat+0x1388/0x3740 fs/namei.c:4827
       do_file_open+0x203/0x440 fs/namei.c:4859
       do_sys_openat2+0x105/0x1e0 fs/open.c:1366
       do_sys_open fs/open.c:1372 [inline]
       __do_sys_openat fs/open.c:1388 [inline]
       __se_sys_openat fs/open.c:1383 [inline]
       __x64_sys_openat+0x139/0x160 fs/open.c:1383
       x64_sys_call+0x1c0b/0x2900 arch/x86/include/generated/asm/syscalls_64.h:258
       do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
       do_syscall_64+0x160/0xfc0 arch/x86/entry/syscall_64.c:94
       entry_SYSCALL_64_after_hwframe+0x4b/0x53

-> #2 (sb_internal#2){.+.+}-{0:0}:
       percpu_down_read_internal include/linux/percpu-rwsem.h:53 [inline]
       percpu_down_read_freezable include/linux/percpu-rwsem.h:83 [inline]
       __sb_start_write include/linux/fs/super.h:19 [inline]
       sb_start_intwrite include/linux/fs/super.h:177 [inline]
       ocfs2_start_trans+0x26b/0x6d0 fs/ocfs2/journal.c:367
       ocfs2_mknod+0xe97/0x20c0 fs/ocfs2/namei.c:365
       ocfs2_create+0x195/0x470 fs/ocfs2/namei.c:677
       lookup_open fs/namei.c:4483 [inline]
       open_last_lookups fs/namei.c:4583 [inline]
       path_openat+0x1388/0x3740 fs/namei.c:4827
       do_file_open+0x203/0x440 fs/namei.c:4859
       do_sys_openat2+0x105/0x1e0 fs/open.c:1366
       do_sys_open fs/open.c:1372 [inline]
       __do_sys_openat fs/open.c:1388 [inline]
       __se_sys_openat fs/open.c:1383 [inline]
       __x64_sys_openat+0x139/0x160 fs/open.c:1383
       x64_sys_call+0x1c0b/0x2900 arch/x86/include/generated/asm/syscalls_64.h:258
       do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
       do_syscall_64+0x160/0xfc0 arch/x86/entry/syscall_64.c:94
       entry_SYSCALL_64_after_hwframe+0x4b/0x53

-> #1 (&ocfs2_sysfile_lock_key[LOCAL_ALLOC_SYSTEM_INODE]){+.+.}-{4:4}:
       down_write+0x96/0x1f0 kernel/locking/rwsem.c:1590
       inode_lock include/linux/fs.h:1028 [inline]
       ocfs2_reserve_local_alloc_bits+0x125/0x2580 fs/ocfs2/localalloc.c:636
       ocfs2_reserve_clusters_with_limit+0x1be/0xba0 fs/ocfs2/suballoc.c:1237
       ocfs2_reserve_clusters+0x30/0x40 fs/ocfs2/suballoc.c:1298
       ocfs2_mknod+0xe35/0x20c0 fs/ocfs2/namei.c:358
       ocfs2_create+0x195/0x470 fs/ocfs2/namei.c:677
       lookup_open fs/namei.c:4483 [inline]
       open_last_lookups fs/namei.c:4583 [inline]
       path_openat+0x1388/0x3740 fs/namei.c:4827
       do_file_open+0x203/0x440 fs/namei.c:4859
       do_sys_openat2+0x105/0x1e0 fs/open.c:1366
       do_sys_open fs/open.c:1372 [inline]
       __do_sys_openat fs/open.c:1388 [inline]
       __se_sys_openat fs/open.c:1383 [inline]
       __x64_sys_openat+0x139/0x160 fs/open.c:1383
       x64_sys_call+0x1c0b/0x2900 arch/x86/include/generated/asm/syscalls_64.h:258
       do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
       do_syscall_64+0x160/0xfc0 arch/x86/entry/syscall_64.c:94
       entry_SYSCALL_64_after_hwframe+0x4b/0x53

-> #0 (&ocfs2_sysfile_lock_key[EXTENT_ALLOC_SYSTEM_INODE]){+.+.}-{4:4}:
       check_prev_add kernel/locking/lockdep.c:3165 [inline]
       check_prevs_add kernel/locking/lockdep.c:3284 [inline]
       validate_chain kernel/locking/lockdep.c:3908 [inline]
       __lock_acquire+0x16f8/0x2f60 kernel/locking/lockdep.c:5237
       lock_acquire+0xf0/0x2d0 kernel/locking/lockdep.c:5868
       down_write+0x96/0x1f0 kernel/locking/rwsem.c:1590
       inode_lock include/linux/fs.h:1028 [inline]
       ocfs2_reserve_suballoc_bits+0x168/0x46a0 fs/ocfs2/suballoc.c:857
       ocfs2_reserve_new_metadata_blocks+0x403/0x940 fs/ocfs2/suballoc.c:1053
       ocfs2_init_xattr_set_ctxt+0x2e8/0x780 fs/ocfs2/xattr.c:3308
       ocfs2_xattr_set+0xb99/0x1210 fs/ocfs2/xattr.c:3665
       ocfs2_xattr_trusted_set+0x40/0x50 fs/ocfs2/xattr.c:7371
       __vfs_setxattr+0x489/0x4d0 fs/xattr.c:200
       __vfs_setxattr_noperm+0x12e/0x660 fs/xattr.c:234
       __vfs_setxattr_locked+0x113/0x2a0 fs/xattr.c:295
       vfs_setxattr+0x163/0x360 fs/xattr.c:321
       do_setxattr fs/xattr.c:636 [inline]
       filename_setxattr+0x286/0x610 fs/xattr.c:664
       path_setxattrat+0x356/0x3a0 fs/xattr.c:708
       __do_sys_setxattr fs/xattr.c:742 [inline]
       __se_sys_setxattr fs/xattr.c:738 [inline]
       __x64_sys_setxattr+0xca/0xe0 fs/xattr.c:738
       x64_sys_call+0x2836/0x2900 arch/x86/include/generated/asm/syscalls_64.h:189
       do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
       do_syscall_64+0x160/0xfc0 arch/x86/entry/syscall_64.c:94
       entry_SYSCALL_64_after_hwframe+0x4b/0x53

other info that might help us debug this:

Chain exists of:
  &ocfs2_sysfile_lock_key[EXTENT_ALLOC_SYSTEM_INODE] --> &journal->j_trans_barrier --> &oi->ip_xattr_sem

 Possible unsafe locking scenario:

       CPU0                    CPU1
       ----                    ----
  lock(&oi->ip_xattr_sem);
                               lock(&journal->j_trans_barrier);
                               lock(&oi->ip_xattr_sem);
  lock(&ocfs2_sysfile_lock_key[EXTENT_ALLOC_SYSTEM_INODE]);

 *** DEADLOCK ***

3 locks held by syz.3.30336/128034:
 #0: ffff88802382a420 (sb_writers#16){.+.+}-{0:0}, at: mnt_want_write+0x44/0x90 fs/namespace.c:493
 #1: ffff888058a6d100 (&sb->s_type->i_mutex_key#30){+.+.}-{4:4}, at: inode_lock include/linux/fs.h:1028 [inline]
 #1: ffff888058a6d100 (&sb->s_type->i_mutex_key#30){+.+.}-{4:4}, at: vfs_setxattr+0x13e/0x360 fs/xattr.c:320
 #2: ffff888058a6ce38 (&oi->ip_xattr_sem){++++}-{4:4}, at: ocfs2_xattr_set+0x42c/0x1210 fs/ocfs2/xattr.c:3614

stack backtrace:
CPU: 0 UID: 0 PID: 128034 Comm: syz.3.30336 Tainted: G             L      7.0.0-rc1 #1 PREEMPT(full) 
Tainted: [L]=SOFTLOCKUP
Hardware name: QEMU Ubuntu 24.04 PC v2 (i440FX + PIIX, arch_caps fix, 1996), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
Call Trace:
 <TASK>
 __dump_stack+0x21/0x30 lib/dump_stack.c:94
 dump_stack_lvl+0xee/0x150 lib/dump_stack.c:120
 dump_stack+0x19/0x20 lib/dump_stack.c:129
 print_circular_bug+0x2ee/0x300 kernel/locking/lockdep.c:2043
 check_noncircular+0x12f/0x150 kernel/locking/lockdep.c:2175
 check_prev_add kernel/locking/lockdep.c:3165 [inline]
 check_prevs_add kernel/locking/lockdep.c:3284 [inline]
 validate_chain kernel/locking/lockdep.c:3908 [inline]
 __lock_acquire+0x16f8/0x2f60 kernel/locking/lockdep.c:5237
 lock_acquire+0xf0/0x2d0 kernel/locking/lockdep.c:5868
 down_write+0x96/0x1f0 kernel/locking/rwsem.c:1590
 inode_lock include/linux/fs.h:1028 [inline]
 ocfs2_reserve_suballoc_bits+0x168/0x46a0 fs/ocfs2/suballoc.c:857
 ocfs2_reserve_new_metadata_blocks+0x403/0x940 fs/ocfs2/suballoc.c:1053
 ocfs2_init_xattr_set_ctxt+0x2e8/0x780 fs/ocfs2/xattr.c:3308
 ocfs2_xattr_set+0xb99/0x1210 fs/ocfs2/xattr.c:3665
 ocfs2_xattr_trusted_set+0x40/0x50 fs/ocfs2/xattr.c:7371
 __vfs_setxattr+0x489/0x4d0 fs/xattr.c:200
 __vfs_setxattr_noperm+0x12e/0x660 fs/xattr.c:234
 __vfs_setxattr_locked+0x113/0x2a0 fs/xattr.c:295
 vfs_setxattr+0x163/0x360 fs/xattr.c:321
 do_setxattr fs/xattr.c:636 [inline]
 filename_setxattr+0x286/0x610 fs/xattr.c:664
 path_setxattrat+0x356/0x3a0 fs/xattr.c:708
 __do_sys_setxattr fs/xattr.c:742 [inline]
 __se_sys_setxattr fs/xattr.c:738 [inline]
 __x64_sys_setxattr+0xca/0xe0 fs/xattr.c:738
 x64_sys_call+0x2836/0x2900 arch/x86/include/generated/asm/syscalls_64.h:189
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0x160/0xfc0 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x4b/0x53
RIP: 0033:0x7f3797fa3b6d
Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 90 f3 0f 1e fa 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 b0 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f3798d71018 EFLAGS: 00000246 ORIG_RAX: 00000000000000bc
RAX: ffffffffffffffda RBX: 00007f3798216090 RCX: 00007f3797fa3b6d
RDX: 0000000000000000 RSI: 00002000000002c0 RDI: 0000200000000240
RBP: 00007f3798047c3e R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007f3798216128 R14: 00007f3798216090 R15: 00007fff5ebf9540
 </TASK>

<<<<<<<<<<<<<<< tail report >>>>>>>>>>>>>>>
