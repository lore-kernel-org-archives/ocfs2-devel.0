Received: from mail-io1-f80.google.com (mail-io1-f80.google.com [209.85.166.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B6A02EB10
	for <ocfs2-devel@lists.linux.dev>; Mon, 12 May 2025 01:11:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747012289; cv=none; b=JR0XJbBocpw8PE0Xq15V4afC2xGPjeeM7rrRRNOmZwu6mvWzjBrcFLgLUyZQykBxkj65WHHfOYQzSae6z28chHb0/pJSenMc4+kEF4G2j0Bc9J0Qi8lVFcgxMPQd4ECNsiHpTp3V5Oni9AOqE+4z1XWhE9YwkutxuBULUwu6u8Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747012289; c=relaxed/simple;
	bh=laDRDqRRQ6KyMBx9xH1M40k6iV5vNVAsdAF27UtqYW0=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:
	 Content-Type; b=k3iOUdX/lhSgJ/vDYsBo9EE6AE5rOL/4t+9GGN2buYciNag7bqpv+Za6xvSoBoqPBlsyc5124le2KTE3eUdACh0MbElZK3HoyDMsS1HvCxjzKpPEHNe/VXBVlThZS+nA1Gz1eep5PqBYjBLwguoF/VZOSunWFdkRAAFZHXix6O0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-io1-f80.google.com with SMTP id ca18e2360f4ac-85e7f5129d5so313838139f.0
        for <ocfs2-devel@lists.linux.dev>; Sun, 11 May 2025 18:11:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747012286; x=1747617086;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ti3SVYQ7xmbF22vrNX3d2k8OgxSqWveGh4KYvXytORU=;
        b=V16PldcIU3IJYvEf/mmGfxi/HQ/UG3u1yiEKk0uAbcG6jXMEFjQ0gw60c8LZygmmwa
         KtkL0qeE+xOOesq4VKntwCyPm4WVLk5n8nTyQMazRmt7r1e4ZAI1YWCV/inBg4sYrnh4
         NKdnV8WfzZgpEqfHJ2EKqfcvrzwOAG5+LfTLbRrS0wDmEQ2A4r5e4gqAN/0bqWmkiI6x
         2CJWb8yBr2egIdap7nZpI4ay/HdDdTlAKNPFSJlWtEQEcMeV7dUuIpfn4m3x9r4xHGxB
         vrI5UkRPJdRXb6GSTdkzU76bqAfMCZN1TW/X4Sgx4KIVAVQ0YnWmyPxfGrOzznykn3ZC
         B5UQ==
X-Forwarded-Encrypted: i=1; AJvYcCUjAa2maiVrytjNM4ClWxApBmmOoa3g03fm4lzZuncQOAa5U75H7okEMlf/VwKvfdpVlTpGsMrfqJjMQA==@lists.linux.dev
X-Gm-Message-State: AOJu0Ywt+bqhEmot101APnCdMKGkb98B6p6tXBznsstrFS8/DcS6MDlO
	T50aSfe348syb1+cWIukuZV7AQIzFns3b8T1pWHAtaveeEAnGmg+Fkh4ccW2X+7PWbfYGAYS8iT
	mCCcwLr3Al41wiGjQDOOb7Is9B8co4Fq159rIQ/UoyXLjoe8DLcrjyHo=
X-Google-Smtp-Source: AGHT+IGrLSXaOECMI24X8I34sPsUqeO+X+PP/wlw7LsOjgvRLdi5JACK3f8Jp7D5I+ITmXs7bs4SMTfWKUV2/0Ep4ILpLDn/e5Xs
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6602:13d0:b0:861:6f49:626 with SMTP id
 ca18e2360f4ac-867635668e0mr1397676339f.6.1747012286204; Sun, 11 May 2025
 18:11:26 -0700 (PDT)
Date: Sun, 11 May 2025 18:11:26 -0700
In-Reply-To: <670883b0.050a0220.3e960.0008.GAE@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <68214abe.050a0220.f2294.0047.GAE@google.com>
Subject: Re: [syzbot] [ocfs2?] possible deadlock in ocfs2_xattr_get
From: syzbot <syzbot+10133a1caa039cc78415@syzkaller.appspotmail.com>
To: jlbec@evilplan.org, joseph.qi@linux.alibaba.com, 
	linux-kernel@vger.kernel.org, mark@fasheh.com, ocfs2-devel@lists.linux.dev, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

syzbot has found a reproducer for the following issue on:

HEAD commit:    c32f8dc5aaf9 Merge branch 'for-next/core' into for-kernelci
git tree:       git://git.kernel.org/pub/scm/linux/kernel/git/arm64/linux.git for-kernelci
console output: https://syzkaller.appspot.com/x/log.txt?x=16f112f4580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=ea4635ffd6ad5b4a
dashboard link: https://syzkaller.appspot.com/bug?extid=10133a1caa039cc78415
compiler:       Debian clang version 20.1.2 (++20250402124445+58df0ef89dd6-1~exp1~20250402004600.97), Debian LLD 20.1.2
userspace arch: arm64
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=15f112f4580000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=11303670580000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/b921498959d4/disk-c32f8dc5.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/04e6ad946c4b/vmlinux-c32f8dc5.xz
kernel image: https://storage.googleapis.com/syzbot-assets/d4f0d8db50ee/Image-c32f8dc5.gz.xz
mounted in repro #1: https://storage.googleapis.com/syzbot-assets/2e309eebe0ec/mount_0.gz
  fsck result: OK (log: https://syzkaller.appspot.com/x/fsck.log?x=16303670580000)
mounted in repro #2: https://storage.googleapis.com/syzbot-assets/2c0ac144c602/mount_2.gz
  fsck result: OK (log: https://syzkaller.appspot.com/x/fsck.log?x=143922f4580000)

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+10133a1caa039cc78415@syzkaller.appspotmail.com

ocfs2: Slot 0 on device (7,0) was already allocated to this node!
ocfs2: Mounting device (7,0) on (node local, slot 0) with ordered data mode.
======================================================
WARNING: possible circular locking dependency detected
6.15.0-rc5-syzkaller-gc32f8dc5aaf9 #0 Not tainted
------------------------------------------------------
syz-executor168/6538 is trying to acquire lock:
ffff0000ea8806f8 (&oi->ip_xattr_sem){++++}-{4:4}, at: ocfs2_xattr_get+0xe8/0x220 fs/ocfs2/xattr.c:1338

but task is already holding lock:
ffff0000dc4a4950 (jbd2_handle){++++}-{0:0}, at: start_this_handle+0xe4c/0x10dc fs/jbd2/transaction.c:442

which lock already depends on the new lock.


the existing dependency chain (in reverse order) is:

-> #5 (jbd2_handle){++++}-{0:0}:
       start_this_handle+0xe74/0x10dc fs/jbd2/transaction.c:444
       jbd2__journal_start+0x288/0x51c fs/jbd2/transaction.c:501
       jbd2_journal_start+0x3c/0x4c fs/jbd2/transaction.c:540
       ocfs2_start_trans+0x368/0x6ac fs/ocfs2/journal.c:352
       ocfs2_modify_bh+0xe4/0x43c fs/ocfs2/quota_local.c:101
       ocfs2_local_read_info+0x104c/0x1364 fs/ocfs2/quota_local.c:771
       dquot_load_quota_sb+0x6bc/0xa90 fs/quota/dquot.c:2459
       dquot_load_quota_inode+0x274/0x4e4 fs/quota/dquot.c:2496
       ocfs2_enable_quotas+0x17c/0x3b4 fs/ocfs2/super.c:930
       ocfs2_fill_super+0x4018/0x5340 fs/ocfs2/super.c:1140
       get_tree_bdev_flags+0x360/0x414 fs/super.c:1636
       get_tree_bdev+0x2c/0x3c fs/super.c:1659
       ocfs2_get_tree+0x28/0x38 fs/ocfs2/super.c:1184
       vfs_get_tree+0x90/0x28c fs/super.c:1759
       do_new_mount+0x228/0x814 fs/namespace.c:3884
       path_mount+0x5b4/0xde0 fs/namespace.c:4211
       do_mount fs/namespace.c:4224 [inline]
       __do_sys_mount fs/namespace.c:4435 [inline]
       __se_sys_mount fs/namespace.c:4412 [inline]
       __arm64_sys_mount+0x3e8/0x468 fs/namespace.c:4412
       __invoke_syscall arch/arm64/kernel/syscall.c:35 [inline]
       invoke_syscall+0x98/0x2b8 arch/arm64/kernel/syscall.c:49
       el0_svc_common+0x130/0x23c arch/arm64/kernel/syscall.c:132
       do_el0_svc+0x48/0x58 arch/arm64/kernel/syscall.c:151
       el0_svc+0x58/0x17c arch/arm64/kernel/entry-common.c:767
       el0t_64_sync_handler+0x78/0x108 arch/arm64/kernel/entry-common.c:786
       el0t_64_sync+0x198/0x19c arch/arm64/kernel/entry.S:600

-> #4 (&journal->j_trans_barrier){.+.+}-{4:4}:
       down_read+0x58/0x2f8 kernel/locking/rwsem.c:1524
       ocfs2_start_trans+0x35c/0x6ac fs/ocfs2/journal.c:350
       ocfs2_modify_bh+0xe4/0x43c fs/ocfs2/quota_local.c:101
       ocfs2_local_read_info+0x104c/0x1364 fs/ocfs2/quota_local.c:771
       dquot_load_quota_sb+0x6bc/0xa90 fs/quota/dquot.c:2459
       dquot_load_quota_inode+0x274/0x4e4 fs/quota/dquot.c:2496
       ocfs2_enable_quotas+0x17c/0x3b4 fs/ocfs2/super.c:930
       ocfs2_fill_super+0x4018/0x5340 fs/ocfs2/super.c:1140
       get_tree_bdev_flags+0x360/0x414 fs/super.c:1636
       get_tree_bdev+0x2c/0x3c fs/super.c:1659
       ocfs2_get_tree+0x28/0x38 fs/ocfs2/super.c:1184
       vfs_get_tree+0x90/0x28c fs/super.c:1759
       do_new_mount+0x228/0x814 fs/namespace.c:3884
       path_mount+0x5b4/0xde0 fs/namespace.c:4211
       do_mount fs/namespace.c:4224 [inline]
       __do_sys_mount fs/namespace.c:4435 [inline]
       __se_sys_mount fs/namespace.c:4412 [inline]
       __arm64_sys_mount+0x3e8/0x468 fs/namespace.c:4412
       __invoke_syscall arch/arm64/kernel/syscall.c:35 [inline]
       invoke_syscall+0x98/0x2b8 arch/arm64/kernel/syscall.c:49
       el0_svc_common+0x130/0x23c arch/arm64/kernel/syscall.c:132
       do_el0_svc+0x48/0x58 arch/arm64/kernel/syscall.c:151
       el0_svc+0x58/0x17c arch/arm64/kernel/entry-common.c:767
       el0t_64_sync_handler+0x78/0x108 arch/arm64/kernel/entry-common.c:786
       el0t_64_sync+0x198/0x19c arch/arm64/kernel/entry.S:600

-> #3 (sb_internal#2){.+.+}-{0:0}:
       percpu_down_read include/linux/percpu-rwsem.h:52 [inline]
       __sb_start_write include/linux/fs.h:1783 [inline]
       sb_start_intwrite include/linux/fs.h:1966 [inline]
       ocfs2_start_trans+0x1f4/0x6ac fs/ocfs2/journal.c:348
       ocfs2_block_group_alloc fs/ocfs2/suballoc.c:685 [inline]
       ocfs2_reserve_suballoc_bits+0x630/0x3b60 fs/ocfs2/suballoc.c:832
       ocfs2_reserve_new_metadata_blocks+0x368/0x810 fs/ocfs2/suballoc.c:982
       ocfs2_init_xattr_set_ctxt+0x318/0x774 fs/ocfs2/xattr.c:3277
       ocfs2_xattr_set+0x920/0xe9c fs/ocfs2/xattr.c:3634
       ocfs2_xattr_trusted_set+0x4c/0x64 fs/ocfs2/xattr.c:7336
       __vfs_setxattr+0x3d8/0x400 fs/xattr.c:200
       __vfs_setxattr_noperm+0x120/0x5c4 fs/xattr.c:234
       __vfs_setxattr_locked+0x1ec/0x218 fs/xattr.c:295
       vfs_setxattr+0x158/0x2ac fs/xattr.c:321
       do_setxattr fs/xattr.c:636 [inline]
       filename_setxattr+0x20c/0x4f8 fs/xattr.c:665
       path_setxattrat+0x2e8/0x320 fs/xattr.c:713
       __do_sys_setxattr fs/xattr.c:747 [inline]
       __se_sys_setxattr fs/xattr.c:743 [inline]
       __arm64_sys_setxattr+0xc0/0xdc fs/xattr.c:743
       __invoke_syscall arch/arm64/kernel/syscall.c:35 [inline]
       invoke_syscall+0x98/0x2b8 arch/arm64/kernel/syscall.c:49
       el0_svc_common+0x130/0x23c arch/arm64/kernel/syscall.c:132
       do_el0_svc+0x48/0x58 arch/arm64/kernel/syscall.c:151
       el0_svc+0x58/0x17c arch/arm64/kernel/entry-common.c:767
       el0t_64_sync_handler+0x78/0x108 arch/arm64/kernel/entry-common.c:786
       el0t_64_sync+0x198/0x19c arch/arm64/kernel/entry.S:600

-> #2 (&ocfs2_sysfile_lock_key[args->fi_sysfile_type]#4){+.+.}-{4:4}:
       down_write+0x50/0xc0 kernel/locking/rwsem.c:1577
       inode_lock include/linux/fs.h:867 [inline]
       ocfs2_reserve_suballoc_bits+0x12c/0x3b60 fs/ocfs2/suballoc.c:786
       ocfs2_reserve_cluster_bitmap_bits fs/ocfs2/suballoc.c:1132 [inline]
       ocfs2_reserve_clusters_with_limit+0x290/0x9e0 fs/ocfs2/suballoc.c:1177
       ocfs2_block_group_alloc fs/ocfs2/suballoc.c:674 [inline]
       ocfs2_reserve_suballoc_bits+0x610/0x3b60 fs/ocfs2/suballoc.c:832
       ocfs2_reserve_new_metadata_blocks+0x368/0x810 fs/ocfs2/suballoc.c:982
       ocfs2_init_xattr_set_ctxt+0x318/0x774 fs/ocfs2/xattr.c:3277
       ocfs2_xattr_set+0x920/0xe9c fs/ocfs2/xattr.c:3634
       ocfs2_xattr_trusted_set+0x4c/0x64 fs/ocfs2/xattr.c:7336
       __vfs_setxattr+0x3d8/0x400 fs/xattr.c:200
       __vfs_setxattr_noperm+0x120/0x5c4 fs/xattr.c:234
       __vfs_setxattr_locked+0x1ec/0x218 fs/xattr.c:295
       vfs_setxattr+0x158/0x2ac fs/xattr.c:321
       do_setxattr fs/xattr.c:636 [inline]
       filename_setxattr+0x20c/0x4f8 fs/xattr.c:665
       path_setxattrat+0x2e8/0x320 fs/xattr.c:713
       __do_sys_setxattr fs/xattr.c:747 [inline]
       __se_sys_setxattr fs/xattr.c:743 [inline]
       __arm64_sys_setxattr+0xc0/0xdc fs/xattr.c:743
       __invoke_syscall arch/arm64/kernel/syscall.c:35 [inline]
       invoke_syscall+0x98/0x2b8 arch/arm64/kernel/syscall.c:49
       el0_svc_common+0x130/0x23c arch/arm64/kernel/syscall.c:132
       do_el0_svc+0x48/0x58 arch/arm64/kernel/syscall.c:151
       el0_svc+0x58/0x17c arch/arm64/kernel/entry-common.c:767
       el0t_64_sync_handler+0x78/0x108 arch/arm64/kernel/entry-common.c:786
       el0t_64_sync+0x198/0x19c arch/arm64/kernel/entry.S:600

-> #1 (&ocfs2_sysfile_lock_key[args->fi_sysfile_type]#3){+.+.}-{4:4}:
       down_write+0x50/0xc0 kernel/locking/rwsem.c:1577
       inode_lock include/linux/fs.h:867 [inline]
       ocfs2_reserve_suballoc_bits+0x12c/0x3b60 fs/ocfs2/suballoc.c:786
       ocfs2_reserve_new_metadata_blocks+0x368/0x810 fs/ocfs2/suballoc.c:982
       ocfs2_init_xattr_set_ctxt+0x318/0x774 fs/ocfs2/xattr.c:3277
       ocfs2_xattr_set+0x920/0xe9c fs/ocfs2/xattr.c:3634
       ocfs2_xattr_trusted_set+0x4c/0x64 fs/ocfs2/xattr.c:7336
       __vfs_setxattr+0x3d8/0x400 fs/xattr.c:200
       __vfs_setxattr_noperm+0x120/0x5c4 fs/xattr.c:234
       __vfs_setxattr_locked+0x1ec/0x218 fs/xattr.c:295
       vfs_setxattr+0x158/0x2ac fs/xattr.c:321
       do_setxattr fs/xattr.c:636 [inline]
       filename_setxattr+0x20c/0x4f8 fs/xattr.c:665
       path_setxattrat+0x2e8/0x320 fs/xattr.c:713
       __do_sys_setxattr fs/xattr.c:747 [inline]
       __se_sys_setxattr fs/xattr.c:743 [inline]
       __arm64_sys_setxattr+0xc0/0xdc fs/xattr.c:743
       __invoke_syscall arch/arm64/kernel/syscall.c:35 [inline]
       invoke_syscall+0x98/0x2b8 arch/arm64/kernel/syscall.c:49
       el0_svc_common+0x130/0x23c arch/arm64/kernel/syscall.c:132
       do_el0_svc+0x48/0x58 arch/arm64/kernel/syscall.c:151
       el0_svc+0x58/0x17c arch/arm64/kernel/entry-common.c:767
       el0t_64_sync_handler+0x78/0x108 arch/arm64/kernel/entry-common.c:786
       el0t_64_sync+0x198/0x19c arch/arm64/kernel/entry.S:600

-> #0 (&oi->ip_xattr_sem){++++}-{4:4}:
       check_prev_add kernel/locking/lockdep.c:3166 [inline]
       check_prevs_add kernel/locking/lockdep.c:3285 [inline]
       validate_chain kernel/locking/lockdep.c:3909 [inline]
       __lock_acquire+0x1728/0x3058 kernel/locking/lockdep.c:5235
       lock_acquire+0x14c/0x2e0 kernel/locking/lockdep.c:5866
       down_read+0x58/0x2f8 kernel/locking/rwsem.c:1524
       ocfs2_xattr_get+0xe8/0x220 fs/ocfs2/xattr.c:1338
       ocfs2_xattr_security_get+0x40/0x54 fs/ocfs2/xattr.c:7231
       __vfs_getxattr+0x394/0x3c0 fs/xattr.c:423
       smk_fetch+0xc4/0x150 security/smack/smack_lsm.c:290
       smack_d_instantiate+0x53c/0x7a4 security/smack/smack_lsm.c:3607
       security_d_instantiate+0x100/0x204 security/security.c:4079
       d_instantiate+0x5c/0x9c fs/dcache.c:1936
       ocfs2_mknod+0x151c/0x1cf0 fs/ocfs2/namei.c:450
       ocfs2_create+0x190/0x474 fs/ocfs2/namei.c:673
       lookup_open fs/namei.c:3701 [inline]
       open_last_lookups fs/namei.c:3800 [inline]
       path_openat+0x12d8/0x2c40 fs/namei.c:4036
       do_filp_open+0x18c/0x36c fs/namei.c:4066
       do_sys_openat2+0x11c/0x1b4 fs/open.c:1429
       do_sys_open fs/open.c:1444 [inline]
       __do_sys_openat fs/open.c:1460 [inline]
       __se_sys_openat fs/open.c:1455 [inline]
       __arm64_sys_openat+0x120/0x158 fs/open.c:1455
       __invoke_syscall arch/arm64/kernel/syscall.c:35 [inline]
       invoke_syscall+0x98/0x2b8 arch/arm64/kernel/syscall.c:49
       el0_svc_common+0x130/0x23c arch/arm64/kernel/syscall.c:132
       do_el0_svc+0x48/0x58 arch/arm64/kernel/syscall.c:151
       el0_svc+0x58/0x17c arch/arm64/kernel/entry-common.c:767
       el0t_64_sync_handler+0x78/0x108 arch/arm64/kernel/entry-common.c:786
       el0t_64_sync+0x198/0x19c arch/arm64/kernel/entry.S:600

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

8 locks held by syz-executor168/6538:
 #0: ffff0000d0f54420 (sb_writers#9){.+.+}-{0:0}, at: mnt_want_write+0x44/0x9c fs/namespace.c:556
 #1: ffff0000e45589c0 (&type->i_mutex_dir_key#8){+.+.}-{4:4}, at: inode_lock include/linux/fs.h:867 [inline]
 #1: ffff0000e45589c0 (&type->i_mutex_dir_key#8){+.+.}-{4:4}, at: open_last_lookups fs/namei.c:3797 [inline]
 #1: ffff0000e45589c0 (&type->i_mutex_dir_key#8){+.+.}-{4:4}, at: path_openat+0x638/0x2c40 fs/namei.c:4036
 #2: ffff0000ea8689c0 (&ocfs2_sysfile_lock_key[args->fi_sysfile_type]#6){+.+.}-{4:4}, at: inode_lock include/linux/fs.h:867 [inline]
 #2: ffff0000ea8689c0 (&ocfs2_sysfile_lock_key[args->fi_sysfile_type]#6){+.+.}-{4:4}, at: ocfs2_reserve_suballoc_bits+0x12c/0x3b60 fs/ocfs2/suballoc.c:786
 #3: ffff0000e455ed80 (&ocfs2_sysfile_lock_key[args->fi_sysfile_type]#3){+.+.}-{4:4}, at: inode_lock include/linux/fs.h:867 [inline]
 #3: ffff0000e455ed80 (&ocfs2_sysfile_lock_key[args->fi_sysfile_type]#3){+.+.}-{4:4}, at: ocfs2_reserve_suballoc_bits+0x12c/0x3b60 fs/ocfs2/suballoc.c:786
 #4: ffff0000ea86a640 (&ocfs2_sysfile_lock_key[args->fi_sysfile_type]#5){+.+.}-{4:4}, at: inode_lock include/linux/fs.h:867 [inline]
 #4: ffff0000ea86a640 (&ocfs2_sysfile_lock_key[args->fi_sysfile_type]#5){+.+.}-{4:4}, at: ocfs2_reserve_local_alloc_bits+0x104/0x26a0 fs/ocfs2/localalloc.c:636
 #5: ffff0000d0f54610 (sb_internal#2){.+.+}-{0:0}, at: ocfs2_mknod+0xc50/0x1cf0 fs/ocfs2/namei.c:361
 #6: ffff0000c9f350e8 (&journal->j_trans_barrier){.+.+}-{4:4}, at: ocfs2_start_trans+0x35c/0x6ac fs/ocfs2/journal.c:350
 #7: ffff0000dc4a4950 (jbd2_handle){++++}-{0:0}, at: start_this_handle+0xe4c/0x10dc fs/jbd2/transaction.c:442

stack backtrace:
CPU: 0 UID: 0 PID: 6538 Comm: syz-executor168 Not tainted 6.15.0-rc5-syzkaller-gc32f8dc5aaf9 #0 PREEMPT 
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 02/12/2025
Call trace:
 show_stack+0x2c/0x3c arch/arm64/kernel/stacktrace.c:466 (C)
 __dump_stack+0x30/0x40 lib/dump_stack.c:94
 dump_stack_lvl+0xd8/0x12c lib/dump_stack.c:120
 dump_stack+0x1c/0x28 lib/dump_stack.c:129
 print_circular_bug+0x324/0x32c kernel/locking/lockdep.c:2079
 check_noncircular+0x154/0x174 kernel/locking/lockdep.c:2211
 check_prev_add kernel/locking/lockdep.c:3166 [inline]
 check_prevs_add kernel/locking/lockdep.c:3285 [inline]
 validate_chain kernel/locking/lockdep.c:3909 [inline]
 __lock_acquire+0x1728/0x3058 kernel/locking/lockdep.c:5235
 lock_acquire+0x14c/0x2e0 kernel/locking/lockdep.c:5866
 down_read+0x58/0x2f8 kernel/locking/rwsem.c:1524
 ocfs2_xattr_get+0xe8/0x220 fs/ocfs2/xattr.c:1338
 ocfs2_xattr_security_get+0x40/0x54 fs/ocfs2/xattr.c:7231
 __vfs_getxattr+0x394/0x3c0 fs/xattr.c:423
 smk_fetch+0xc4/0x150 security/smack/smack_lsm.c:290
 smack_d_instantiate+0x53c/0x7a4 security/smack/smack_lsm.c:3607
 security_d_instantiate+0x100/0x204 security/security.c:4079
 d_instantiate+0x5c/0x9c fs/dcache.c:1936
 ocfs2_mknod+0x151c/0x1cf0 fs/ocfs2/namei.c:450
 ocfs2_create+0x190/0x474 fs/ocfs2/namei.c:673
 lookup_open fs/namei.c:3701 [inline]
 open_last_lookups fs/namei.c:3800 [inline]
 path_openat+0x12d8/0x2c40 fs/namei.c:4036
 do_filp_open+0x18c/0x36c fs/namei.c:4066
 do_sys_openat2+0x11c/0x1b4 fs/open.c:1429
 do_sys_open fs/open.c:1444 [inline]
 __do_sys_openat fs/open.c:1460 [inline]
 __se_sys_openat fs/open.c:1455 [inline]
 __arm64_sys_openat+0x120/0x158 fs/open.c:1455
 __invoke_syscall arch/arm64/kernel/syscall.c:35 [inline]
 invoke_syscall+0x98/0x2b8 arch/arm64/kernel/syscall.c:49
 el0_svc_common+0x130/0x23c arch/arm64/kernel/syscall.c:132
 do_el0_svc+0x48/0x58 arch/arm64/kernel/syscall.c:151
 el0_svc+0x58/0x17c arch/arm64/kernel/entry-common.c:767
 el0t_64_sync_handler+0x78/0x108 arch/arm64/kernel/entry-common.c:786
 el0t_64_sync+0x198/0x19c arch/arm64/kernel/entry.S:600


---
If you want syzbot to run the reproducer, reply with:
#syz test: git://repo/address.git branch-or-commit-hash
If you attach or paste a git patch, syzbot will apply it before testing.
