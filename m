Received: from mail-il1-f197.google.com (mail-il1-f197.google.com [209.85.166.197])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C56512E5B
	for <ocfs2-devel@lists.linux.dev>; Fri, 11 Oct 2024 01:47:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.197
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728611251; cv=none; b=mpp4Eq09+JcMF0zRFY2457X2D2pVUNSNRn+Ynq9lzUl7sMHGEt6QMZs5uqmbawzSS8T1H0DNbqXqJgW45iRJsiCLjPySfOBMt8MfuUuDPxs86/TpMSGjI/Um9UDp16AtCyiGxk5jxYnd87nQkrKdtZAaoSS5fmIiCcOn9l2GOAM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728611251; c=relaxed/simple;
	bh=i3yMSmjLXDhHbmkc2VSFlikZewg3Y4gC8xP5xfGhl44=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=tmhMm9g8sUS7uCUa4TwVnjOJYcyNjevwfCy0v4bajTOmPvZ4EOiIZPngd9t0dCblkFIL8t4HSVH3mxrLpcB/d4M5sOuJw+yixeI24f30YmXiUOiAZK72oj4LieFjq3XyE65vpu/uDEMORDxMhHXIIls7VFQd2au0KIGejDOokzA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.197
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f197.google.com with SMTP id e9e14a558f8ab-3a0cd6a028bso13234365ab.0
        for <ocfs2-devel@lists.linux.dev>; Thu, 10 Oct 2024 18:47:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728611249; x=1729216049;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=fSmn2rGGGrEbydNqOFr5FPNPa751BGyAZdEO83gQGLo=;
        b=JMbKSYIjkx7TxW2UPd8mPthgP0Kxt2nVYaf5blVV/A+2EBccBR7GLqCgmJUbAmgNYp
         DSOuzt7KFpaNxmhqViT05hMvNi/k3hYJ2dbzLEDKNnNYKArMHXCh6UqIaMPffkjLAKmu
         dPRIKcrHpP+IxeNQcMzaBLVphRUxTvGmLZpV1GPMlNEzwNtqVDb3uWt9oTO91P9thD9D
         K2AzMooOYmFlouY1o5OdhudHgmn0XPCMgyt1ffxL9tP9l9GZp0BtapQO4JafcSAkmF4y
         mpuEst3cNtMuDd5f+GNkle8LDuP52i33nU4hX1znwNQtath5yot3klexOr4n2nVPxqsH
         3kmg==
X-Forwarded-Encrypted: i=1; AJvYcCUyEkpI7Ar06cJjpGnMkHcBzGBoT3ASgtF9Tmq2tiYhIRjuT2K6vBbBwWkoOnVOAbAgaA4YMKCqLkVDjw==@lists.linux.dev
X-Gm-Message-State: AOJu0YwI0GBND+4nJJpn1KgZoQDTG0nzPg9nDISkzNpUuOvfLzCzNRpP
	ZTHhkoGb6X7yV8io/pSx8S9q4oFhwAQYPEVOYRahMjZohZ5Wifmeq2G79nk0dftrT2fo3VEq/ol
	A6H3NIC4y9Xn3HTCekJ4eXT8PgP5B8KNavI9pRrg6dM3mgDlhopADpPg=
X-Google-Smtp-Source: AGHT+IGJSouqXtR+VyVkOuXyDuX8mFvpAJxbHq7cDUsiX6kAM9lGYfpJtYGIoAaKL2FbEe9z2JEeEj3TP2vWnur+mulvFFRAErD4
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1548:b0:3a0:a26f:7669 with SMTP id
 e9e14a558f8ab-3a3b5f28e2bmr6859205ab.7.1728611248752; Thu, 10 Oct 2024
 18:47:28 -0700 (PDT)
Date: Thu, 10 Oct 2024 18:47:28 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <670883b0.050a0220.3e960.0008.GAE@google.com>
Subject: [syzbot] [ocfs2?] possible deadlock in ocfs2_xattr_get
From: syzbot <syzbot+10133a1caa039cc78415@syzkaller.appspotmail.com>
To: jlbec@evilplan.org, joseph.qi@linux.alibaba.com, 
	linux-kernel@vger.kernel.org, mark@fasheh.com, ocfs2-devel@lists.linux.dev, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    80cb3fb61135 Merge branch 'for-next/core', remote-tracking..
git tree:       git://git.kernel.org/pub/scm/linux/kernel/git/arm64/linux.git for-kernelci
console output: https://syzkaller.appspot.com/x/log.txt?x=129b27d0580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=b9f31443a725c681
dashboard link: https://syzkaller.appspot.com/bug?extid=10133a1caa039cc78415
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40
userspace arch: arm64

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/f883f65fbfeb/disk-80cb3fb6.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/d950aa1c78a2/vmlinux-80cb3fb6.xz
kernel image: https://storage.googleapis.com/syzbot-assets/972c4d758a0b/Image-80cb3fb6.gz.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+10133a1caa039cc78415@syzkaller.appspotmail.com

ocfs2: Mounting device (7,0) on (node local, slot 0) with ordered data mode.
======================================================
WARNING: possible circular locking dependency detected
6.12.0-rc1-syzkaller-g80cb3fb61135 #0 Not tainted
------------------------------------------------------
syz.0.103/7015 is trying to acquire lock:
ffff0000ee9abff8 (&oi->ip_xattr_sem){++++}-{3:3}, at: ocfs2_xattr_get+0x104/0x28c fs/ocfs2/xattr.c:1338

but task is already holding lock:
ffff0000f69fe958 (jbd2_handle){++++}-{0:0}, at: start_this_handle+0xf0c/0x11c4 fs/jbd2/transaction.c:446

which lock already depends on the new lock.


the existing dependency chain (in reverse order) is:

-> #4 (jbd2_handle){++++}-{0:0}:
       start_this_handle+0xf34/0x11c4 fs/jbd2/transaction.c:448
       jbd2__journal_start+0x298/0x544 fs/jbd2/transaction.c:505
       jbd2_journal_start+0x3c/0x4c fs/jbd2/transaction.c:544
       ocfs2_start_trans+0x3d0/0x71c fs/ocfs2/journal.c:352
       ocfs2_modify_bh+0xe4/0x484 fs/ocfs2/quota_local.c:101
       ocfs2_local_read_info+0x1220/0x15bc fs/ocfs2/quota_local.c:771
       dquot_load_quota_sb+0x6e4/0xb24 fs/quota/dquot.c:2458
       dquot_load_quota_inode+0x280/0x4f4 fs/quota/dquot.c:2495
       ocfs2_enable_quotas+0x17c/0x3cc fs/ocfs2/super.c:926
       ocfs2_fill_super+0x3f04/0x49d0 fs/ocfs2/super.c:1141
       mount_bdev+0x1d4/0x2a0 fs/super.c:1679
       ocfs2_mount+0x44/0x58 fs/ocfs2/super.c:1188
       legacy_get_tree+0xd4/0x16c fs/fs_context.c:662
       vfs_get_tree+0x90/0x28c fs/super.c:1800
       do_new_mount+0x278/0x900 fs/namespace.c:3507
       path_mount+0x590/0xe04 fs/namespace.c:3834
       do_mount fs/namespace.c:3847 [inline]
       __do_sys_mount fs/namespace.c:4055 [inline]
       __se_sys_mount fs/namespace.c:4032 [inline]
       __arm64_sys_mount+0x45c/0x5a8 fs/namespace.c:4032
       __invoke_syscall arch/arm64/kernel/syscall.c:35 [inline]
       invoke_syscall+0x98/0x2b8 arch/arm64/kernel/syscall.c:49
       el0_svc_common+0x130/0x23c arch/arm64/kernel/syscall.c:132
       do_el0_svc+0x48/0x58 arch/arm64/kernel/syscall.c:151
       el0_svc+0x54/0x168 arch/arm64/kernel/entry-common.c:732
       el0t_64_sync_handler+0x84/0x108 arch/arm64/kernel/entry-common.c:750
       el0t_64_sync+0x190/0x194 arch/arm64/kernel/entry.S:598

-> #3 (&journal->j_trans_barrier){.+.+}-{3:3}:
       down_read+0x58/0x2fc kernel/locking/rwsem.c:1524
       ocfs2_start_trans+0x3c4/0x71c fs/ocfs2/journal.c:350
       ocfs2_modify_bh+0xe4/0x484 fs/ocfs2/quota_local.c:101
       ocfs2_local_read_info+0x1220/0x15bc fs/ocfs2/quota_local.c:771
       dquot_load_quota_sb+0x6e4/0xb24 fs/quota/dquot.c:2458
       dquot_load_quota_inode+0x280/0x4f4 fs/quota/dquot.c:2495
       ocfs2_enable_quotas+0x17c/0x3cc fs/ocfs2/super.c:926
       ocfs2_fill_super+0x3f04/0x49d0 fs/ocfs2/super.c:1141
       mount_bdev+0x1d4/0x2a0 fs/super.c:1679
       ocfs2_mount+0x44/0x58 fs/ocfs2/super.c:1188
       legacy_get_tree+0xd4/0x16c fs/fs_context.c:662
       vfs_get_tree+0x90/0x28c fs/super.c:1800
       do_new_mount+0x278/0x900 fs/namespace.c:3507
       path_mount+0x590/0xe04 fs/namespace.c:3834
       do_mount fs/namespace.c:3847 [inline]
       __do_sys_mount fs/namespace.c:4055 [inline]
       __se_sys_mount fs/namespace.c:4032 [inline]
       __arm64_sys_mount+0x45c/0x5a8 fs/namespace.c:4032
       __invoke_syscall arch/arm64/kernel/syscall.c:35 [inline]
       invoke_syscall+0x98/0x2b8 arch/arm64/kernel/syscall.c:49
       el0_svc_common+0x130/0x23c arch/arm64/kernel/syscall.c:132
       do_el0_svc+0x48/0x58 arch/arm64/kernel/syscall.c:151
       el0_svc+0x54/0x168 arch/arm64/kernel/entry-common.c:732
       el0t_64_sync_handler+0x84/0x108 arch/arm64/kernel/entry-common.c:750
       el0t_64_sync+0x190/0x194 arch/arm64/kernel/entry.S:598

-> #2 (sb_internal#2){.+.+}-{0:0}:
       percpu_down_read include/linux/percpu-rwsem.h:51 [inline]
       __sb_start_write include/linux/fs.h:1716 [inline]
       sb_start_intwrite include/linux/fs.h:1899 [inline]
       ocfs2_start_trans+0x244/0x71c fs/ocfs2/journal.c:348
       ocfs2_xattr_set+0xdac/0x1448 fs/ocfs2/xattr.c:3644
       ocfs2_xattr_security_set+0x4c/0x64 fs/ocfs2/xattr.c:7242
       __vfs_setxattr+0x3d8/0x400 fs/xattr.c:200
       __vfs_setxattr_noperm+0x110/0x578 fs/xattr.c:234
       __vfs_setxattr_locked+0x1ec/0x218 fs/xattr.c:295
       vfs_setxattr+0x1a8/0x344 fs/xattr.c:321
       do_setxattr fs/xattr.c:629 [inline]
       path_setxattr+0x30c/0x428 fs/xattr.c:658
       __do_sys_lsetxattr fs/xattr.c:683 [inline]
       __se_sys_lsetxattr fs/xattr.c:679 [inline]
       __arm64_sys_lsetxattr+0xbc/0xd8 fs/xattr.c:679
       __invoke_syscall arch/arm64/kernel/syscall.c:35 [inline]
       invoke_syscall+0x98/0x2b8 arch/arm64/kernel/syscall.c:49
       el0_svc_common+0x130/0x23c arch/arm64/kernel/syscall.c:132
       do_el0_svc+0x48/0x58 arch/arm64/kernel/syscall.c:151
       el0_svc+0x54/0x168 arch/arm64/kernel/entry-common.c:732
       el0t_64_sync_handler+0x84/0x108 arch/arm64/kernel/entry-common.c:750
       el0t_64_sync+0x190/0x194 arch/arm64/kernel/entry.S:598

-> #1 (&ocfs2_sysfile_lock_key[args->fi_sysfile_type]#3){+.+.}-{3:3}:
       down_write+0x50/0xc0 kernel/locking/rwsem.c:1577
       inode_lock include/linux/fs.h:815 [inline]
       ocfs2_reserve_suballoc_bits+0x164/0x4288 fs/ocfs2/suballoc.c:786
       ocfs2_reserve_new_metadata_blocks+0x384/0x848 fs/ocfs2/suballoc.c:982
       ocfs2_init_xattr_set_ctxt+0x394/0x968 fs/ocfs2/xattr.c:3278
       ocfs2_xattr_set+0xbe0/0x1448 fs/ocfs2/xattr.c:3635
       ocfs2_xattr_security_set+0x4c/0x64 fs/ocfs2/xattr.c:7242
       __vfs_setxattr+0x3d8/0x400 fs/xattr.c:200
       __vfs_setxattr_noperm+0x110/0x578 fs/xattr.c:234
       __vfs_setxattr_locked+0x1ec/0x218 fs/xattr.c:295
       vfs_setxattr+0x1a8/0x344 fs/xattr.c:321
       do_setxattr fs/xattr.c:629 [inline]
       path_setxattr+0x30c/0x428 fs/xattr.c:658
       __do_sys_lsetxattr fs/xattr.c:683 [inline]
       __se_sys_lsetxattr fs/xattr.c:679 [inline]
       __arm64_sys_lsetxattr+0xbc/0xd8 fs/xattr.c:679
       __invoke_syscall arch/arm64/kernel/syscall.c:35 [inline]
       invoke_syscall+0x98/0x2b8 arch/arm64/kernel/syscall.c:49
       el0_svc_common+0x130/0x23c arch/arm64/kernel/syscall.c:132
       do_el0_svc+0x48/0x58 arch/arm64/kernel/syscall.c:151
       el0_svc+0x54/0x168 arch/arm64/kernel/entry-common.c:732
       el0t_64_sync_handler+0x84/0x108 arch/arm64/kernel/entry-common.c:750
       el0t_64_sync+0x190/0x194 arch/arm64/kernel/entry.S:598

-> #0 (&oi->ip_xattr_sem){++++}-{3:3}:
       check_prev_add kernel/locking/lockdep.c:3161 [inline]
       check_prevs_add kernel/locking/lockdep.c:3280 [inline]
       validate_chain kernel/locking/lockdep.c:3904 [inline]
       __lock_acquire+0x33f8/0x77c8 kernel/locking/lockdep.c:5202
       lock_acquire+0x240/0x728 kernel/locking/lockdep.c:5825
       down_read+0x58/0x2fc kernel/locking/rwsem.c:1524
       ocfs2_xattr_get+0x104/0x28c fs/ocfs2/xattr.c:1338
       ocfs2_xattr_security_get+0x40/0x54 fs/ocfs2/xattr.c:7232
       __vfs_getxattr+0x394/0x3c0 fs/xattr.c:423
       smk_fetch+0xc8/0x150 security/smack/smack_lsm.c:306
       smack_d_instantiate+0x594/0x880 security/smack/smack_lsm.c:3606
       security_d_instantiate+0x100/0x204 security/security.c:4061
       d_instantiate+0x5c/0xa0 fs/dcache.c:1892
       ocfs2_mknod+0x1998/0x243c fs/ocfs2/namei.c:448
       ocfs2_create+0x194/0x4e0 fs/ocfs2/namei.c:672
       lookup_open fs/namei.c:3595 [inline]
       open_last_lookups fs/namei.c:3694 [inline]
       path_openat+0x13e4/0x2b14 fs/namei.c:3930
       do_filp_open+0x1bc/0x3cc fs/namei.c:3960
       do_sys_openat2+0x124/0x1b8 fs/open.c:1415
       do_sys_open fs/open.c:1430 [inline]
       __do_sys_openat fs/open.c:1446 [inline]
       __se_sys_openat fs/open.c:1441 [inline]
       __arm64_sys_openat+0x1f0/0x240 fs/open.c:1441
       __invoke_syscall arch/arm64/kernel/syscall.c:35 [inline]
       invoke_syscall+0x98/0x2b8 arch/arm64/kernel/syscall.c:49
       el0_svc_common+0x130/0x23c arch/arm64/kernel/syscall.c:132
       do_el0_svc+0x48/0x58 arch/arm64/kernel/syscall.c:151
       el0_svc+0x54/0x168 arch/arm64/kernel/entry-common.c:732
       el0t_64_sync_handler+0x84/0x108 arch/arm64/kernel/entry-common.c:750
       el0t_64_sync+0x190/0x194 arch/arm64/kernel/entry.S:598

other info that might help us debug this:

Chain exists of:
  &oi->ip_xattr_sem --> &journal->j_trans_barrier --> jbd2_handle

 Possible unsafe locking scenario:

       CPU0                    CPU1
       ----                    ----
  rlock(jbd2_handle);
                               lock(&journal->j_trans_barrier);
                               lock(jbd2_handle);
  rlock(&oi->ip_xattr_sem);

 *** DEADLOCK ***

8 locks held by syz.0.103/7015:
 #0: ffff0000cbed0420 (sb_writers#15){.+.+}-{0:0}, at: mnt_want_write+0x44/0x9c fs/namespace.c:515
 #1: ffff0000eea209c0 (&type->i_mutex_dir_key#12){+.+.}-{3:3}, at: inode_lock include/linux/fs.h:815 [inline]
 #1: ffff0000eea209c0 (&type->i_mutex_dir_key#12){+.+.}-{3:3}, at: open_last_lookups fs/namei.c:3691 [inline]
 #1: ffff0000eea209c0 (&type->i_mutex_dir_key#12){+.+.}-{3:3}, at: path_openat+0x684/0x2b14 fs/namei.c:3930
 #2: ffff0000ee9ab480 (&ocfs2_sysfile_lock_key[args->fi_sysfile_type]#5){+.+.}-{3:3}, at: inode_lock include/linux/fs.h:815 [inline]
 #2: ffff0000ee9ab480 (&ocfs2_sysfile_lock_key[args->fi_sysfile_type]#5){+.+.}-{3:3}, at: ocfs2_reserve_suballoc_bits+0x164/0x4288 fs/ocfs2/suballoc.c:786
 #3: ffff0000eea22640 (&ocfs2_sysfile_lock_key[args->fi_sysfile_type]#3){+.+.}-{3:3}, at: inode_lock include/linux/fs.h:815 [inline]
 #3: ffff0000eea22640 (&ocfs2_sysfile_lock_key[args->fi_sysfile_type]#3){+.+.}-{3:3}, at: ocfs2_reserve_suballoc_bits+0x164/0x4288 fs/ocfs2/suballoc.c:786
 #4: ffff0000ee9adf40 (&ocfs2_sysfile_lock_key[args->fi_sysfile_type]#6){+.+.}-{3:3}, at: inode_lock include/linux/fs.h:815 [inline]
 #4: ffff0000ee9adf40 (&ocfs2_sysfile_lock_key[args->fi_sysfile_type]#6){+.+.}-{3:3}, at: ocfs2_reserve_local_alloc_bits+0xfc/0x247c fs/ocfs2/localalloc.c:636
 #5: ffff0000cbed0610 (sb_internal#2){.+.+}-{0:0}, at: ocfs2_mknod+0xe58/0x243c fs/ocfs2/namei.c:359
 #6: ffff0000cf0760e8 (&journal->j_trans_barrier){.+.+}-{3:3}, at: ocfs2_start_trans+0x3c4/0x71c fs/ocfs2/journal.c:350
 #7: ffff0000f69fe958 (jbd2_handle){++++}-{0:0}, at: start_this_handle+0xf0c/0x11c4 fs/jbd2/transaction.c:446

stack backtrace:
CPU: 0 UID: 0 PID: 7015 Comm: syz.0.103 Not tainted 6.12.0-rc1-syzkaller-g80cb3fb61135 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 08/06/2024
Call trace:
 dump_backtrace+0x1b8/0x1e4 arch/arm64/kernel/stacktrace.c:319
 show_stack+0x2c/0x3c arch/arm64/kernel/stacktrace.c:326
 __dump_stack lib/dump_stack.c:94 [inline]
 dump_stack_lvl+0xe4/0x150 lib/dump_stack.c:120
 dump_stack+0x1c/0x28 lib/dump_stack.c:129
 print_circular_bug+0x154/0x1c0 kernel/locking/lockdep.c:2074
 check_noncircular+0x310/0x404 kernel/locking/lockdep.c:2206
 check_prev_add kernel/locking/lockdep.c:3161 [inline]
 check_prevs_add kernel/locking/lockdep.c:3280 [inline]
 validate_chain kernel/locking/lockdep.c:3904 [inline]
 __lock_acquire+0x33f8/0x77c8 kernel/locking/lockdep.c:5202
 lock_acquire+0x240/0x728 kernel/locking/lockdep.c:5825
 down_read+0x58/0x2fc kernel/locking/rwsem.c:1524
 ocfs2_xattr_get+0x104/0x28c fs/ocfs2/xattr.c:1338
 ocfs2_xattr_security_get+0x40/0x54 fs/ocfs2/xattr.c:7232
 __vfs_getxattr+0x394/0x3c0 fs/xattr.c:423
 smk_fetch+0xc8/0x150 security/smack/smack_lsm.c:306
 smack_d_instantiate+0x594/0x880 security/smack/smack_lsm.c:3606
 security_d_instantiate+0x100/0x204 security/security.c:4061
 d_instantiate+0x5c/0xa0 fs/dcache.c:1892
 ocfs2_mknod+0x1998/0x243c fs/ocfs2/namei.c:448
 ocfs2_create+0x194/0x4e0 fs/ocfs2/namei.c:672
 lookup_open fs/namei.c:3595 [inline]
 open_last_lookups fs/namei.c:3694 [inline]
 path_openat+0x13e4/0x2b14 fs/namei.c:3930
 do_filp_open+0x1bc/0x3cc fs/namei.c:3960
 do_sys_openat2+0x124/0x1b8 fs/open.c:1415
 do_sys_open fs/open.c:1430 [inline]
 __do_sys_openat fs/open.c:1446 [inline]
 __se_sys_openat fs/open.c:1441 [inline]
 __arm64_sys_openat+0x1f0/0x240 fs/open.c:1441
 __invoke_syscall arch/arm64/kernel/syscall.c:35 [inline]
 invoke_syscall+0x98/0x2b8 arch/arm64/kernel/syscall.c:49
 el0_svc_common+0x130/0x23c arch/arm64/kernel/syscall.c:132
 do_el0_svc+0x48/0x58 arch/arm64/kernel/syscall.c:151
 el0_svc+0x54/0x168 arch/arm64/kernel/entry-common.c:732
 el0t_64_sync_handler+0x84/0x108 arch/arm64/kernel/entry-common.c:750
 el0t_64_sync+0x190/0x194 arch/arm64/kernel/entry.S:598


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.

If the report is already addressed, let syzbot know by replying with:
#syz fix: exact-commit-title

If you want to overwrite report's subsystems, reply with:
#syz set subsystems: new-subsystem
(See the list of subsystem names on the web dashboard)

If the report is a duplicate of another one, reply with:
#syz dup: exact-subject-of-another-report

If you want to undo deduplication, reply with:
#syz undup
