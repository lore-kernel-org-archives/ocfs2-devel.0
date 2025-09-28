Received: from mail-io1-f79.google.com (mail-io1-f79.google.com [209.85.166.79])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F35FC259498
	for <ocfs2-devel@lists.linux.dev>; Sun, 28 Sep 2025 18:52:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.79
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759085545; cv=none; b=vBBdwXshIjMQtEr0hVhy1ZMzc6PXjQfjZ1T31U3Ul9SNVJJZ9YMDniSMy0Yr2SojxPNYfI0T0meJP0yB4sHHlR/sr5fYQWie66u/aZHgFk1o+dT4qNkM/6SJnQrO8DuEfUkisjN+rhJp85JKo0gYHXF6oETlw9rwsw6CKEwJxms=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759085545; c=relaxed/simple;
	bh=rZGMB9pF6hvo0j1IPcKwCnSDybmR1NwZ6ETUZUSCWWM=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:
	 Content-Type; b=ecs01a6Fxm6lJYGw7/3lmbGk6Kmhb68ANt1TcubnMsGbiF5dBoDbm6ggQRLVa+mTSBqUr2VNOy9bsmBv3S9vJg5CKL7dxKb3ipXtieraPq0onUV6v/gY2hkpKckh654fSdTDT+Sm5SZz/psJNmcGplqPcBdI6Pglz3cAjcZDvdE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.79
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-io1-f79.google.com with SMTP id ca18e2360f4ac-927f4207211so28703339f.3
        for <ocfs2-devel@lists.linux.dev>; Sun, 28 Sep 2025 11:52:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759085543; x=1759690343;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=a1Hbj/Q/0j3dhCeZd8yjarDwJJpV7AiIa5PgOSevyTE=;
        b=Wi1IDUm7V1Hd988CIq3FQkLNDmYytySUif0JbkpmyXYfLkXeygEKZSeIctdMXA98R1
         Oqzdz56aVTpCSerVwdOiA90mOFMaroKKIzhe0gxsaQOwXntxyxDCEJw997SZ4LcmmIkq
         Dm02KaCSts/jTwzWEw/GMmjSBxRKkbgJbPqdcVMg/U+H3D9tbqEwPx1W7gfkcrkV+8HM
         qqHFeGGTSisq0L1Nc4bevXR3QP1vMwWPq8AVeqdufVT7nX6DNgNvy1nj7+P9A1ndJ3Jt
         x+ZPuVTgGrygck0Ei4f2boybJ9Ozx7CKffX9B/en7JAHpmXl9XuKQ98GEFOOkOzASZBn
         B3zA==
X-Forwarded-Encrypted: i=1; AJvYcCVPwrVptvstMjcNIeZ4NXNj7BNBm35ffoq7SHi5dMeT9yZ9uUzU1R8XznJbb0jsV1LeaCEWlBNgTmNRNg==@lists.linux.dev
X-Gm-Message-State: AOJu0YyeXj1+3vlvEZ6wS/EF1Wxs00zzsQdYmoieKc6AZDG+zrpS1lM+
	SZmL0puNRSAxMGnXI6WWlYw+upA7+7Wabt4BFJfxr5zhDNs2Hcj2tl3k697t06JfLBTM8XCUWrZ
	pAobFcVf+gbiBEL3bcoui2ij1vzlrFRwYQzFZxPhotjCA0FodOI0SnGJIC+s=
X-Google-Smtp-Source: AGHT+IH8Po7cPe4MUjsNiwHA7u0PB5oldgb/pMbAItalTT5twE31rc8z4uFf6baZTfk5WEfkZG3VT28DDy19HLm41jGvCoOvkqlv
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:164a:b0:429:6c5a:61f3 with SMTP id
 e9e14a558f8ab-4296c5a6457mr59623025ab.8.1759085543060; Sun, 28 Sep 2025
 11:52:23 -0700 (PDT)
Date: Sun, 28 Sep 2025 11:52:23 -0700
In-Reply-To: <66fee1d3.050a0220.9ec68.0055.GAE@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <68d983e7.050a0220.1696c6.0007.GAE@google.com>
Subject: Re: [syzbot] [ocfs2?] possible deadlock in ocfs2_lock_global_qf
From: syzbot <syzbot+b53d753ae8fb473e2397@syzkaller.appspotmail.com>
To: jlbec@evilplan.org, joseph.qi@linux.alibaba.com, 
	linux-kernel@vger.kernel.org, mark@fasheh.com, ocfs2-devel@lists.linux.dev, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

syzbot has found a reproducer for the following issue on:

HEAD commit:    2213e57a69f0 Merge branch 'for-next/core' into for-kernelci
git tree:       git://git.kernel.org/pub/scm/linux/kernel/git/arm64/linux.git for-kernelci
console output: https://syzkaller.appspot.com/x/log.txt?x=177a0334580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=714d45b6135c308e
dashboard link: https://syzkaller.appspot.com/bug?extid=b53d753ae8fb473e2397
compiler:       Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~exp1~20250708183702.136), Debian LLD 20.1.8
userspace arch: arm64
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=15f4bf12580000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=14840ae2580000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/bf4625d47a8f/disk-2213e57a.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/270abffcbf3c/vmlinux-2213e57a.xz
kernel image: https://storage.googleapis.com/syzbot-assets/1f0f6eb3e385/Image-2213e57a.gz.xz
mounted in repro #1: https://storage.googleapis.com/syzbot-assets/bd16abd3a6ee/mount_0.gz
  fsck result: OK (log: https://syzkaller.appspot.com/x/fsck.log?x=15a3f142580000)
mounted in repro #2: https://storage.googleapis.com/syzbot-assets/6b6e68c02efc/mount_5.gz
  fsck result: OK (log: https://syzkaller.appspot.com/x/fsck.log?x=11096ae2580000)

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+b53d753ae8fb473e2397@syzkaller.appspotmail.com

ocfs2: Mounting device (7,4) on (node local, slot 0) with ordered data mode.
======================================================
WARNING: possible circular locking dependency detected
syzkaller #0 Not tainted
------------------------------------------------------
syz.4.50/6831 is trying to acquire lock:
ffff0000faf15100 (&ocfs2_sysfile_lock_key[USER_QUOTA_SYSTEM_INODE]){+.+.}-{4:4}, at: inode_lock include/linux/fs.h:870 [inline]
ffff0000faf15100 (&ocfs2_sysfile_lock_key[USER_QUOTA_SYSTEM_INODE]){+.+.}-{4:4}, at: ocfs2_lock_global_qf+0x18c/0x22c fs/ocfs2/quota_global.c:313

but task is already holding lock:
ffff0000e39a00a8 (&dquot->dq_lock){+.+.}-{4:4}, at: ocfs2_acquire_dquot+0x24c/0xa10 fs/ocfs2/quota_global.c:823

which lock already depends on the new lock.


the existing dependency chain (in reverse order) is:

-> #6 (&dquot->dq_lock){+.+.}-{4:4}:
       __mutex_lock_common+0x1d0/0x2678 kernel/locking/mutex.c:598
       __mutex_lock kernel/locking/mutex.c:760 [inline]
       mutex_lock_nested+0x2c/0x38 kernel/locking/mutex.c:812
       wait_on_dquot fs/quota/dquot.c:354 [inline]
       dqget+0x5e4/0xccc fs/quota/dquot.c:972
       dquot_transfer+0x238/0x560 fs/quota/dquot.c:2140
       ext4_setattr+0x738/0x1810 fs/ext4/inode.c:5902
       notify_change+0x9a4/0xc50 fs/attr.c:552
       chown_common+0x374/0x4dc fs/open.c:791
       vfs_fchown fs/open.c:859 [inline]
       ksys_fchown+0xe0/0x158 fs/open.c:871
       __do_sys_fchown fs/open.c:876 [inline]
       __se_sys_fchown fs/open.c:874 [inline]
       __arm64_sys_fchown+0x7c/0x94 fs/open.c:874
       __invoke_syscall arch/arm64/kernel/syscall.c:35 [inline]
       invoke_syscall+0x98/0x254 arch/arm64/kernel/syscall.c:49
       el0_svc_common+0x130/0x23c arch/arm64/kernel/syscall.c:132
       do_el0_svc+0x48/0x58 arch/arm64/kernel/syscall.c:151
       el0_svc+0x5c/0x254 arch/arm64/kernel/entry-common.c:744
       el0t_64_sync_handler+0x84/0x12c arch/arm64/kernel/entry-common.c:763
       el0t_64_sync+0x198/0x19c arch/arm64/kernel/entry.S:596

-> #5 (&ei->xattr_sem){++++}-{4:4}:
       down_write+0x50/0xc0 kernel/locking/rwsem.c:1590
       ext4_write_lock_xattr fs/ext4/xattr.h:157 [inline]
       ext4_xattr_set_handle+0x11c/0x1260 fs/ext4/xattr.c:2362
       ext4_initxattrs+0xa4/0x11c fs/ext4/xattr_security.c:44
       security_inode_init_security+0x6dc/0x7f4 security/security.c:1852
       ext4_init_security+0x44/0x58 fs/ext4/xattr_security.c:58
       __ext4_new_inode+0x27f4/0x3190 fs/ext4/ialloc.c:1325
       ext4_create+0x1f8/0x3fc fs/ext4/namei.c:2822
       lookup_open fs/namei.c:3708 [inline]
       open_last_lookups fs/namei.c:3807 [inline]
       path_openat+0x12d8/0x2c40 fs/namei.c:4043
       do_filp_open+0x18c/0x36c fs/namei.c:4073
       do_sys_openat2+0x11c/0x1b4 fs/open.c:1435
       do_sys_open fs/open.c:1450 [inline]
       __do_sys_openat fs/open.c:1466 [inline]
       __se_sys_openat fs/open.c:1461 [inline]
       __arm64_sys_openat+0x120/0x158 fs/open.c:1461
       __invoke_syscall arch/arm64/kernel/syscall.c:35 [inline]
       invoke_syscall+0x98/0x254 arch/arm64/kernel/syscall.c:49
       el0_svc_common+0x130/0x23c arch/arm64/kernel/syscall.c:132
       do_el0_svc+0x48/0x58 arch/arm64/kernel/syscall.c:151
       el0_svc+0x5c/0x254 arch/arm64/kernel/entry-common.c:744
       el0t_64_sync_handler+0x84/0x12c arch/arm64/kernel/entry-common.c:763
       el0t_64_sync+0x198/0x19c arch/arm64/kernel/entry.S:596

-> #4 (jbd2_handle){++++}-{0:0}:
       start_this_handle+0xe74/0x10dc fs/jbd2/transaction.c:444
       jbd2__journal_start+0x288/0x51c fs/jbd2/transaction.c:501
       jbd2_journal_start+0x3c/0x4c fs/jbd2/transaction.c:540
       ocfs2_start_trans+0x368/0x6b0 fs/ocfs2/journal.c:374
       ocfs2_modify_bh+0xe4/0x43c fs/ocfs2/quota_local.c:101
       ocfs2_local_read_info+0x104c/0x1364 fs/ocfs2/quota_local.c:767
       dquot_load_quota_sb+0x6bc/0xa90 fs/quota/dquot.c:2459
       dquot_load_quota_inode+0x274/0x4e4 fs/quota/dquot.c:2496
       ocfs2_enable_quotas+0x17c/0x3b4 fs/ocfs2/super.c:930
       ocfs2_fill_super+0x4004/0x532c fs/ocfs2/super.c:1140
       get_tree_bdev_flags+0x360/0x414 fs/super.c:1692
       get_tree_bdev+0x2c/0x3c fs/super.c:1715
       ocfs2_get_tree+0x28/0x38 fs/ocfs2/super.c:1184
       vfs_get_tree+0x90/0x28c fs/super.c:1815
       do_new_mount+0x278/0x7f4 fs/namespace.c:3808
       path_mount+0x5b4/0xde0 fs/namespace.c:4123
       do_mount fs/namespace.c:4136 [inline]
       __do_sys_mount fs/namespace.c:4347 [inline]
       __se_sys_mount fs/namespace.c:4324 [inline]
       __arm64_sys_mount+0x3e8/0x468 fs/namespace.c:4324
       __invoke_syscall arch/arm64/kernel/syscall.c:35 [inline]
       invoke_syscall+0x98/0x254 arch/arm64/kernel/syscall.c:49
       el0_svc_common+0x130/0x23c arch/arm64/kernel/syscall.c:132
       do_el0_svc+0x48/0x58 arch/arm64/kernel/syscall.c:151
       el0_svc+0x5c/0x254 arch/arm64/kernel/entry-common.c:744
       el0t_64_sync_handler+0x84/0x12c arch/arm64/kernel/entry-common.c:763
       el0t_64_sync+0x198/0x19c arch/arm64/kernel/entry.S:596

-> #3 (&journal->j_trans_barrier){.+.+}-{4:4}:
       down_read+0x58/0x2f8 kernel/locking/rwsem.c:1537
       ocfs2_start_trans+0x35c/0x6b0 fs/ocfs2/journal.c:372
       ocfs2_modify_bh+0xe4/0x43c fs/ocfs2/quota_local.c:101
       ocfs2_local_read_info+0x104c/0x1364 fs/ocfs2/quota_local.c:767
       dquot_load_quota_sb+0x6bc/0xa90 fs/quota/dquot.c:2459
       dquot_load_quota_inode+0x274/0x4e4 fs/quota/dquot.c:2496
       ocfs2_enable_quotas+0x17c/0x3b4 fs/ocfs2/super.c:930
       ocfs2_fill_super+0x4004/0x532c fs/ocfs2/super.c:1140
       get_tree_bdev_flags+0x360/0x414 fs/super.c:1692
       get_tree_bdev+0x2c/0x3c fs/super.c:1715
       ocfs2_get_tree+0x28/0x38 fs/ocfs2/super.c:1184
       vfs_get_tree+0x90/0x28c fs/super.c:1815
       do_new_mount+0x278/0x7f4 fs/namespace.c:3808
       path_mount+0x5b4/0xde0 fs/namespace.c:4123
       do_mount fs/namespace.c:4136 [inline]
       __do_sys_mount fs/namespace.c:4347 [inline]
       __se_sys_mount fs/namespace.c:4324 [inline]
       __arm64_sys_mount+0x3e8/0x468 fs/namespace.c:4324
       __invoke_syscall arch/arm64/kernel/syscall.c:35 [inline]
       invoke_syscall+0x98/0x254 arch/arm64/kernel/syscall.c:49
       el0_svc_common+0x130/0x23c arch/arm64/kernel/syscall.c:132
       do_el0_svc+0x48/0x58 arch/arm64/kernel/syscall.c:151
       el0_svc+0x5c/0x254 arch/arm64/kernel/entry-common.c:744
       el0t_64_sync_handler+0x84/0x12c arch/arm64/kernel/entry-common.c:763
       el0t_64_sync+0x198/0x19c arch/arm64/kernel/entry.S:596

-> #2 (sb_internal#2){.+.+}-{0:0}:
       percpu_down_read_internal include/linux/percpu-rwsem.h:53 [inline]
       percpu_down_read_freezable include/linux/percpu-rwsem.h:83 [inline]
       __sb_start_write include/linux/fs.h:1799 [inline]
       sb_start_intwrite include/linux/fs.h:1982 [inline]
       ocfs2_start_trans+0x1f4/0x6b0 fs/ocfs2/journal.c:370
       ocfs2_write_info+0x114/0x324 fs/ocfs2/quota_global.c:997
       dquot_set_dqinfo+0x370/0x5d4 fs/quota/dquot.c:2897
       quota_setinfo+0x2c4/0x2cc fs/quota/quota.c:174
       do_quotactl+0x59c/0x738 fs/quota/quota.c:796
       __do_sys_quotactl fs/quota/quota.c:961 [inline]
       __se_sys_quotactl fs/quota/quota.c:917 [inline]
       __arm64_sys_quotactl+0x298/0xb34 fs/quota/quota.c:917
       __invoke_syscall arch/arm64/kernel/syscall.c:35 [inline]
       invoke_syscall+0x98/0x254 arch/arm64/kernel/syscall.c:49
       el0_svc_common+0x130/0x23c arch/arm64/kernel/syscall.c:132
       do_el0_svc+0x48/0x58 arch/arm64/kernel/syscall.c:151
       el0_svc+0x5c/0x254 arch/arm64/kernel/entry-common.c:744
       el0t_64_sync_handler+0x84/0x12c arch/arm64/kernel/entry-common.c:763
       el0t_64_sync+0x198/0x19c arch/arm64/kernel/entry.S:596

-> #1 (&ocfs2_quota_ip_alloc_sem_key){++++}-{4:4}:
       down_write+0x50/0xc0 kernel/locking/rwsem.c:1590
       ocfs2_lock_global_qf+0x1a8/0x22c fs/ocfs2/quota_global.c:314
       ocfs2_write_info+0xdc/0x324 fs/ocfs2/quota_global.c:994
       dquot_set_dqinfo+0x370/0x5d4 fs/quota/dquot.c:2897
       quota_setinfo+0x2c4/0x2cc fs/quota/quota.c:174
       do_quotactl+0x59c/0x738 fs/quota/quota.c:796
       __do_sys_quotactl fs/quota/quota.c:961 [inline]
       __se_sys_quotactl fs/quota/quota.c:917 [inline]
       __arm64_sys_quotactl+0x298/0xb34 fs/quota/quota.c:917
       __invoke_syscall arch/arm64/kernel/syscall.c:35 [inline]
       invoke_syscall+0x98/0x254 arch/arm64/kernel/syscall.c:49
       el0_svc_common+0x130/0x23c arch/arm64/kernel/syscall.c:132
       do_el0_svc+0x48/0x58 arch/arm64/kernel/syscall.c:151
       el0_svc+0x5c/0x254 arch/arm64/kernel/entry-common.c:744
       el0t_64_sync_handler+0x84/0x12c arch/arm64/kernel/entry-common.c:763
       el0t_64_sync+0x198/0x19c arch/arm64/kernel/entry.S:596

-> #0 (&ocfs2_sysfile_lock_key[USER_QUOTA_SYSTEM_INODE]){+.+.}-{4:4}:
       check_prev_add kernel/locking/lockdep.c:3165 [inline]
       check_prevs_add kernel/locking/lockdep.c:3284 [inline]
       validate_chain kernel/locking/lockdep.c:3908 [inline]
       __lock_acquire+0x1774/0x30a4 kernel/locking/lockdep.c:5237
       lock_acquire+0x14c/0x2e0 kernel/locking/lockdep.c:5868
       down_write+0x50/0xc0 kernel/locking/rwsem.c:1590
       inode_lock include/linux/fs.h:870 [inline]
       ocfs2_lock_global_qf+0x18c/0x22c fs/ocfs2/quota_global.c:313
       ocfs2_acquire_dquot+0x258/0xa10 fs/ocfs2/quota_global.c:828
       dqget+0x654/0xccc fs/quota/dquot.c:977
       __dquot_initialize+0x2d4/0xa80 fs/quota/dquot.c:1505
       dquot_initialize+0x24/0x34 fs/quota/dquot.c:1567
       ocfs2_get_init_inode+0x134/0x1a8 fs/ocfs2/namei.c:205
       ocfs2_mknod+0x734/0x1cf0 fs/ocfs2/namei.c:313
       ocfs2_create+0x190/0x474 fs/ocfs2/namei.c:676
       lookup_open fs/namei.c:3708 [inline]
       open_last_lookups fs/namei.c:3807 [inline]
       path_openat+0x12d8/0x2c40 fs/namei.c:4043
       do_filp_open+0x18c/0x36c fs/namei.c:4073
       do_sys_openat2+0x11c/0x1b4 fs/open.c:1435
       do_sys_open fs/open.c:1450 [inline]
       __do_sys_openat fs/open.c:1466 [inline]
       __se_sys_openat fs/open.c:1461 [inline]
       __arm64_sys_openat+0x120/0x158 fs/open.c:1461
       __invoke_syscall arch/arm64/kernel/syscall.c:35 [inline]
       invoke_syscall+0x98/0x254 arch/arm64/kernel/syscall.c:49
       el0_svc_common+0x130/0x23c arch/arm64/kernel/syscall.c:132
       do_el0_svc+0x48/0x58 arch/arm64/kernel/syscall.c:151
       el0_svc+0x5c/0x254 arch/arm64/kernel/entry-common.c:744
       el0t_64_sync_handler+0x84/0x12c arch/arm64/kernel/entry-common.c:763
       el0t_64_sync+0x198/0x19c arch/arm64/kernel/entry.S:596

other info that might help us debug this:

Chain exists of:
  &ocfs2_sysfile_lock_key[USER_QUOTA_SYSTEM_INODE] --> &ei->xattr_sem --> &dquot->dq_lock

 Possible unsafe locking scenario:

       CPU0                    CPU1
       ----                    ----
  lock(&dquot->dq_lock);
                               lock(&ei->xattr_sem);
                               lock(&dquot->dq_lock);
  lock(&ocfs2_sysfile_lock_key[USER_QUOTA_SYSTEM_INODE]);

 *** DEADLOCK ***

4 locks held by syz.4.50/6831:
 #0: ffff0000c92ca428 (sb_writers#11){.+.+}-{0:0}, at: mnt_want_write+0x44/0x9c fs/namespace.c:557
 #1: ffff0000faf109c0 (&type->i_mutex_dir_key#8){+.+.}-{4:4}, at: inode_lock include/linux/fs.h:870 [inline]
 #1: ffff0000faf109c0 (&type->i_mutex_dir_key#8){+.+.}-{4:4}, at: open_last_lookups fs/namei.c:3804 [inline]
 #1: ffff0000faf109c0 (&type->i_mutex_dir_key#8){+.+.}-{4:4}, at: path_openat+0x638/0x2c40 fs/namei.c:4043
 #2: ffff0000fad09800 (&ocfs2_sysfile_lock_key[INODE_ALLOC_SYSTEM_INODE]){+.+.}-{4:4}, at: inode_lock include/linux/fs.h:870 [inline]
 #2: ffff0000fad09800 (&ocfs2_sysfile_lock_key[INODE_ALLOC_SYSTEM_INODE]){+.+.}-{4:4}, at: ocfs2_reserve_suballoc_bits+0x12c/0x3b9c fs/ocfs2/suballoc.c:788
 #3: ffff0000e39a00a8 (&dquot->dq_lock){+.+.}-{4:4}, at: ocfs2_acquire_dquot+0x24c/0xa10 fs/ocfs2/quota_global.c:823

stack backtrace:
CPU: 0 UID: 0 PID: 6831 Comm: syz.4.50 Not tainted syzkaller #0 PREEMPT 
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 06/30/2025
Call trace:
 show_stack+0x2c/0x3c arch/arm64/kernel/stacktrace.c:499 (C)
 __dump_stack+0x30/0x40 lib/dump_stack.c:94
 dump_stack_lvl+0xd8/0x12c lib/dump_stack.c:120
 dump_stack+0x1c/0x28 lib/dump_stack.c:129
 print_circular_bug+0x324/0x32c kernel/locking/lockdep.c:2043
 check_noncircular+0x154/0x174 kernel/locking/lockdep.c:2175
 check_prev_add kernel/locking/lockdep.c:3165 [inline]
 check_prevs_add kernel/locking/lockdep.c:3284 [inline]
 validate_chain kernel/locking/lockdep.c:3908 [inline]
 __lock_acquire+0x1774/0x30a4 kernel/locking/lockdep.c:5237
 lock_acquire+0x14c/0x2e0 kernel/locking/lockdep.c:5868
 down_write+0x50/0xc0 kernel/locking/rwsem.c:1590
 inode_lock include/linux/fs.h:870 [inline]
 ocfs2_lock_global_qf+0x18c/0x22c fs/ocfs2/quota_global.c:313
 ocfs2_acquire_dquot+0x258/0xa10 fs/ocfs2/quota_global.c:828
 dqget+0x654/0xccc fs/quota/dquot.c:977
 __dquot_initialize+0x2d4/0xa80 fs/quota/dquot.c:1505
 dquot_initialize+0x24/0x34 fs/quota/dquot.c:1567
 ocfs2_get_init_inode+0x134/0x1a8 fs/ocfs2/namei.c:205
 ocfs2_mknod+0x734/0x1cf0 fs/ocfs2/namei.c:313
 ocfs2_create+0x190/0x474 fs/ocfs2/namei.c:676
 lookup_open fs/namei.c:3708 [inline]
 open_last_lookups fs/namei.c:3807 [inline]
 path_openat+0x12d8/0x2c40 fs/namei.c:4043
 do_filp_open+0x18c/0x36c fs/namei.c:4073
 do_sys_openat2+0x11c/0x1b4 fs/open.c:1435
 do_sys_open fs/open.c:1450 [inline]
 __do_sys_openat fs/open.c:1466 [inline]
 __se_sys_openat fs/open.c:1461 [inline]
 __arm64_sys_openat+0x120/0x158 fs/open.c:1461
 __invoke_syscall arch/arm64/kernel/syscall.c:35 [inline]
 invoke_syscall+0x98/0x254 arch/arm64/kernel/syscall.c:49
 el0_svc_common+0x130/0x23c arch/arm64/kernel/syscall.c:132
 do_el0_svc+0x48/0x58 arch/arm64/kernel/syscall.c:151
 el0_svc+0x5c/0x254 arch/arm64/kernel/entry-common.c:744
 el0t_64_sync_handler+0x84/0x12c arch/arm64/kernel/entry-common.c:763
 el0t_64_sync+0x198/0x19c arch/arm64/kernel/entry.S:596
(syz.4.50,6831,0):ocfs2_block_check_validate:402 ERROR: CRC32 failed: stored: 0x2c7b5077, computed 0x28030c75. Applying ECC.
(syz.4.50,6831,0):ocfs2_block_check_validate:416 ERROR: Fixed CRC32 failed: stored: 0x2c7b5077, computed 0x28d1d8ae
(syz.4.50,6831,0):ocfs2_read_quota_phys_block:160 ERROR: status = -5
(syz.4.50,6831,0):ocfs2_quota_read:201 ERROR: status = -5
Quota error (device loop4): find_tree_dqentry: Can't read quota tree block 5
Quota error (device loop4): qtree_read_dquot: Can't read quota structure for id 0
(syz.4.50,6831,0):ocfs2_acquire_dquot:890 ERROR: status = -5
(syz.4.50,6831,0):ocfs2_mknod:317 ERROR: status = -5
(syz.4.50,6831,0):ocfs2_mknod:505 ERROR: status = -5
(syz.4.50,6831,0):ocfs2_create:678 ERROR: status = -5


---
If you want syzbot to run the reproducer, reply with:
#syz test: git://repo/address.git branch-or-commit-hash
If you attach or paste a git patch, syzbot will apply it before testing.
