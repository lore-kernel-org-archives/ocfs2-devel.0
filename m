Received: from mail-io1-f78.google.com (mail-io1-f78.google.com [209.85.166.78])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F478319859
	for <ocfs2-devel@lists.linux.dev>; Tue, 23 Sep 2025 08:30:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.78
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758616234; cv=none; b=MSYSoEPe0xz0YdS+JofbCbJ477MAmCoxDUCQNUgPaZzWC9JCnXT1zBpzWx6Fz+vzYhYLdRdL7YIx9H3Gm8/ijhdA5xidZgksfrgKSSiyjFDa+G/YNPE4T6Uq8GmUsjeu8NnLDg+E3udns862WZTYCVj88ig6lINQ4KVUKa59BL4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758616234; c=relaxed/simple;
	bh=3Sx0qb6pJe073fqZ/xM2FgHx/cXPRpWSfKAvBZakuu0=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=PjQxcsTmELfu6u/OzozDIKiTVHjpHCdXDATdkqmUqWgyv2WONhy0k2lhCjBToiGu38xwzyrLg19itrLOiPGK0Z1Fvh5LZgkYmKf/OZ1NxBSNAzyTYsrslKinx4TlSCd9Vy/0AHoGqxhDerjuXfOc2IByqMohRwXL0ES4pju+lyo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.78
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-io1-f78.google.com with SMTP id ca18e2360f4ac-8a1e8c45f59so553410539f.1
        for <ocfs2-devel@lists.linux.dev>; Tue, 23 Sep 2025 01:30:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758616231; x=1759221031;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=OlDPtxkmI/OSzJ/w7U/dWnawvxNhDR9SR9n45BPIh2Q=;
        b=m05JJVJpZp7jvownMjEanuM4oWgBeqmF7WobNkiibUA2fSjCyOLjWzcQZnEMPIQJRW
         y1iiaqLM5xq/jNQxCFRDVIPhN6EbkR2Si8SijhQOKdRn3vrFv5O+sbYShcfF1xSn6pC+
         N+nVpTu+9BK81OiDEP6QvfXvLEpSsZRa54AWLMnV8FbzQLzasXCQ0E5ViJpkkfRD6v20
         4Dcl3ROwAZGtWu7bYpbfdTAGHB1ffdH1wRXl3u9fWsNZRGeEqRZrveIU5MacvBb41qZW
         wRQ1faotcDifZsYOOydd4ofUO8UPyXMgVfRnkWOCWEKcZfRTAmH/q/uNW+NciQawRW9Z
         fcbg==
X-Forwarded-Encrypted: i=1; AJvYcCVSyxp1tUcE5NoWiiJELDnBegn6lSqLp7EvIHK1EiCB4xjpASVrhklMuhuVEEmBpyBKQz+gslLf/MqUfg==@lists.linux.dev
X-Gm-Message-State: AOJu0Yz90Bna2wKPLaz3q/VpdhWJmUHdpJLMGecDkm6Mq+yrWrdn9aMd
	L9sJWb/mIk5hdhThQCxu4qQwJyXstfgltuyFXKcXM2QnYgT+la3bvStYWFFjE3SyPZlJrJ8pH+F
	jZDeAdsGon31LqMEJ2/GAGfPrh0pU3b7vs+P9q02sXsnA6q3RZRYOCkAuQWQ=
X-Google-Smtp-Source: AGHT+IEJ28exbZpYbWQLJLfPnPZt/tx79UoLCvoC/Lkr2uEnaa6anQVkNMT0aW9iQQrCaiBw48eP3wkMat/38/r7ZjVuw0rmcQ/P
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6602:601c:b0:88d:3818:afe9 with SMTP id
 ca18e2360f4ac-8e1c4adfa42mr336869439f.1.1758616231343; Tue, 23 Sep 2025
 01:30:31 -0700 (PDT)
Date: Tue, 23 Sep 2025 01:30:31 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <68d25aa7.a70a0220.1b52b.02a2.GAE@google.com>
Subject: [syzbot] [ocfs2?] possible deadlock in ocfs2_lock_refcount_tree (3)
From: syzbot <syzbot+322e77eae942c8a32a6c@syzkaller.appspotmail.com>
To: jlbec@evilplan.org, joseph.qi@linux.alibaba.com, 
	linux-kernel@vger.kernel.org, mark@fasheh.com, ocfs2-devel@lists.linux.dev, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    c9d61056440c Merge branch 'for-next/core' into for-kernelci
git tree:       git://git.kernel.org/pub/scm/linux/kernel/git/arm64/linux.git for-kernelci
console output: https://syzkaller.appspot.com/x/log.txt?x=166b0d04580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=b8b6789b42526d72
dashboard link: https://syzkaller.appspot.com/bug?extid=322e77eae942c8a32a6c
compiler:       Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~exp1~20250708183702.136), Debian LLD 20.1.8
userspace arch: arm64

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/4f571468ab6f/disk-c9d61056.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/3871c29d58eb/vmlinux-c9d61056.xz
kernel image: https://storage.googleapis.com/syzbot-assets/dbc62ff54c5b/Image-c9d61056.gz.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+322e77eae942c8a32a6c@syzkaller.appspotmail.com

debugfs: 'B1DE653C5FFC4D88B33B244AAB9EB3E9' already exists in 'ocfs2'
ocfs2: Mounting device (7,0) on (node local, slot 0) with ordered data mode.
======================================================
WARNING: possible circular locking dependency detected
syzkaller #0 Not tainted
------------------------------------------------------
syz.0.173/7608 is trying to acquire lock:
ffff0000c8a0b898 (&new->rf_sem){+.+.}-{4:4}, at: __ocfs2_lock_refcount_tree fs/ocfs2/refcounttree.c:428 [inline]
ffff0000c8a0b898 (&new->rf_sem){+.+.}-{4:4}, at: ocfs2_lock_refcount_tree+0x188/0x924 fs/ocfs2/refcounttree.c:463

but task is already holding lock:
ffff0000f67a22e0 (&ocfs2_file_ip_alloc_sem_key){++++}-{4:4}, at: ocfs2_truncate_file+0x30c/0x12f4 fs/ocfs2/file.c:471

which lock already depends on the new lock.


the existing dependency chain (in reverse order) is:

-> #5 (&ocfs2_file_ip_alloc_sem_key){++++}-{4:4}:
       down_write+0x50/0xc0 kernel/locking/rwsem.c:1590
       ocfs2_try_remove_refcount_tree+0xb4/0x2d8 fs/ocfs2/refcounttree.c:932
       ocfs2_xattr_set+0x460/0xe9c fs/ocfs2/xattr.c:3669
       ocfs2_set_acl+0x574/0x628 fs/ocfs2/acl.c:254
       ocfs2_iop_set_acl+0x190/0x25c fs/ocfs2/acl.c:286
       set_posix_acl fs/posix_acl.c:954 [inline]
       vfs_set_acl+0x70c/0x974 fs/posix_acl.c:1133
       do_set_acl+0xc8/0x1a8 fs/posix_acl.c:1278
       do_setxattr fs/xattr.c:633 [inline]
       filename_setxattr+0x268/0x4f8 fs/xattr.c:665
       path_setxattrat+0x2e8/0x320 fs/xattr.c:713
       __do_sys_setxattr fs/xattr.c:747 [inline]
       __se_sys_setxattr fs/xattr.c:743 [inline]
       __arm64_sys_setxattr+0xc0/0xdc fs/xattr.c:743
       __invoke_syscall arch/arm64/kernel/syscall.c:35 [inline]
       invoke_syscall+0x98/0x2b8 arch/arm64/kernel/syscall.c:49
       el0_svc_common+0x130/0x23c arch/arm64/kernel/syscall.c:132
       do_el0_svc+0x48/0x58 arch/arm64/kernel/syscall.c:151
       el0_svc+0x5c/0x254 arch/arm64/kernel/entry-common.c:744
       el0t_64_sync_handler+0x84/0x12c arch/arm64/kernel/entry-common.c:763
       el0t_64_sync+0x198/0x19c arch/arm64/kernel/entry.S:596

-> #4 (&oi->ip_xattr_sem){++++}-{4:4}:
       down_read+0x58/0x2f8 kernel/locking/rwsem.c:1537
       ocfs2_init_acl+0x258/0x5f0 fs/ocfs2/acl.c:366
       ocfs2_mknod+0x1028/0x1cf0 fs/ocfs2/namei.c:413
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
       invoke_syscall+0x98/0x2b8 arch/arm64/kernel/syscall.c:49
       el0_svc_common+0x130/0x23c arch/arm64/kernel/syscall.c:132
       do_el0_svc+0x48/0x58 arch/arm64/kernel/syscall.c:151
       el0_svc+0x5c/0x254 arch/arm64/kernel/entry-common.c:744
       el0t_64_sync_handler+0x84/0x12c arch/arm64/kernel/entry-common.c:763
       el0t_64_sync+0x198/0x19c arch/arm64/kernel/entry.S:596

-> #3 (jbd2_handle){++++}-{0:0}:
       start_this_handle+0xe74/0x10dc fs/jbd2/transaction.c:444
       jbd2__journal_start+0x288/0x51c fs/jbd2/transaction.c:501
       jbd2_journal_start+0x3c/0x4c fs/jbd2/transaction.c:540
       ocfs2_start_trans+0x368/0x6b0 fs/ocfs2/journal.c:374
       ocfs2_block_group_alloc fs/ocfs2/suballoc.c:685 [inline]
       ocfs2_reserve_suballoc_bits+0x630/0x3b9c fs/ocfs2/suballoc.c:834
       ocfs2_reserve_new_metadata_blocks+0x368/0x810 fs/ocfs2/suballoc.c:984
       ocfs2_mknod+0xbd8/0x1cf0 fs/ocfs2/namei.c:350
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
       invoke_syscall+0x98/0x2b8 arch/arm64/kernel/syscall.c:49
       el0_svc_common+0x130/0x23c arch/arm64/kernel/syscall.c:132
       do_el0_svc+0x48/0x58 arch/arm64/kernel/syscall.c:151
       el0_svc+0x5c/0x254 arch/arm64/kernel/entry-common.c:744
       el0t_64_sync_handler+0x84/0x12c arch/arm64/kernel/entry-common.c:763
       el0t_64_sync+0x198/0x19c arch/arm64/kernel/entry.S:596

-> #2 (&journal->j_trans_barrier){.+.+}-{4:4}:
       down_read+0x58/0x2f8 kernel/locking/rwsem.c:1537
       ocfs2_start_trans+0x35c/0x6b0 fs/ocfs2/journal.c:372
       ocfs2_block_group_alloc fs/ocfs2/suballoc.c:685 [inline]
       ocfs2_reserve_suballoc_bits+0x630/0x3b9c fs/ocfs2/suballoc.c:834
       ocfs2_reserve_new_metadata_blocks+0x368/0x810 fs/ocfs2/suballoc.c:984
       ocfs2_mknod+0xbd8/0x1cf0 fs/ocfs2/namei.c:350
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
       invoke_syscall+0x98/0x2b8 arch/arm64/kernel/syscall.c:49
       el0_svc_common+0x130/0x23c arch/arm64/kernel/syscall.c:132
       do_el0_svc+0x48/0x58 arch/arm64/kernel/syscall.c:151
       el0_svc+0x5c/0x254 arch/arm64/kernel/entry-common.c:744
       el0t_64_sync_handler+0x84/0x12c arch/arm64/kernel/entry-common.c:763
       el0t_64_sync+0x198/0x19c arch/arm64/kernel/entry.S:596

-> #1 (sb_internal#3){.+.+}-{0:0}:
       percpu_down_read_internal include/linux/percpu-rwsem.h:53 [inline]
       percpu_down_read_freezable include/linux/percpu-rwsem.h:83 [inline]
       __sb_start_write include/linux/fs.h:1799 [inline]
       sb_start_intwrite include/linux/fs.h:1982 [inline]
       ocfs2_start_trans+0x1f4/0x6b0 fs/ocfs2/journal.c:370
       ocfs2_set_refcount_tree+0x1f8/0x624 fs/ocfs2/refcounttree.c:713
       ocfs2_reflink_remap_blocks+0x518/0x14b0 fs/ocfs2/refcounttree.c:4663
       ocfs2_remap_file_range+0x3fc/0x638 fs/ocfs2/file.c:2740
       vfs_copy_file_range+0xb24/0x1058 fs/read_write.c:1591
       __do_sys_copy_file_range fs/read_write.c:1677 [inline]
       __se_sys_copy_file_range fs/read_write.c:1644 [inline]
       __arm64_sys_copy_file_range+0x308/0x5d4 fs/read_write.c:1644
       __invoke_syscall arch/arm64/kernel/syscall.c:35 [inline]
       invoke_syscall+0x98/0x2b8 arch/arm64/kernel/syscall.c:49
       el0_svc_common+0x130/0x23c arch/arm64/kernel/syscall.c:132
       do_el0_svc+0x48/0x58 arch/arm64/kernel/syscall.c:151
       el0_svc+0x5c/0x254 arch/arm64/kernel/entry-common.c:744
       el0t_64_sync_handler+0x84/0x12c arch/arm64/kernel/entry-common.c:763
       el0t_64_sync+0x198/0x19c arch/arm64/kernel/entry.S:596

-> #0 (&new->rf_sem){+.+.}-{4:4}:
       check_prev_add kernel/locking/lockdep.c:3165 [inline]
       check_prevs_add kernel/locking/lockdep.c:3284 [inline]
       validate_chain kernel/locking/lockdep.c:3908 [inline]
       __lock_acquire+0x1774/0x30a4 kernel/locking/lockdep.c:5237
       lock_acquire+0x14c/0x2e0 kernel/locking/lockdep.c:5868
       down_write+0x50/0xc0 kernel/locking/rwsem.c:1590
       __ocfs2_lock_refcount_tree fs/ocfs2/refcounttree.c:428 [inline]
       ocfs2_lock_refcount_tree+0x188/0x924 fs/ocfs2/refcounttree.c:463
       ocfs2_refcount_cow_hunk fs/ocfs2/refcounttree.c:3406 [inline]
       ocfs2_refcount_cow+0x4a4/0xb6c fs/ocfs2/refcounttree.c:3467
       ocfs2_cow_file_pos+0x2b4/0x314 fs/ocfs2/file.c:366
       ocfs2_orphan_for_truncate fs/ocfs2/file.c:387 [inline]
       ocfs2_truncate_file+0x354/0x12f4 fs/ocfs2/file.c:500
       ocfs2_setattr+0x1148/0x17a0 fs/ocfs2/file.c:1212
       notify_change+0x9a4/0xc50 fs/attr.c:552
       do_truncate+0x198/0x210 fs/open.c:68
       vfs_truncate+0x398/0x444 fs/open.c:118
       do_sys_truncate+0xe4/0x1a8 fs/open.c:141
       __do_sys_truncate fs/open.c:153 [inline]
       __se_sys_truncate fs/open.c:151 [inline]
       __arm64_sys_truncate+0x5c/0x74 fs/open.c:151
       __invoke_syscall arch/arm64/kernel/syscall.c:35 [inline]
       invoke_syscall+0x98/0x2b8 arch/arm64/kernel/syscall.c:49
       el0_svc_common+0x130/0x23c arch/arm64/kernel/syscall.c:132
       do_el0_svc+0x48/0x58 arch/arm64/kernel/syscall.c:151
       el0_svc+0x5c/0x254 arch/arm64/kernel/entry-common.c:744
       el0t_64_sync_handler+0x84/0x12c arch/arm64/kernel/entry-common.c:763
       el0t_64_sync+0x198/0x19c arch/arm64/kernel/entry.S:596

other info that might help us debug this:

Chain exists of:
  &new->rf_sem --> &oi->ip_xattr_sem --> &ocfs2_file_ip_alloc_sem_key

 Possible unsafe locking scenario:

       CPU0                    CPU1
       ----                    ----
  lock(&ocfs2_file_ip_alloc_sem_key);
                               lock(&oi->ip_xattr_sem);
                               lock(&ocfs2_file_ip_alloc_sem_key);
  lock(&new->rf_sem);

 *** DEADLOCK ***

3 locks held by syz.0.173/7608:
 #0: ffff0000ff98e428 (sb_writers#17){.+.+}-{0:0}, at: mnt_want_write+0x44/0x9c fs/namespace.c:557
 #1: ffff0000f67a2640 (&sb->s_type->i_mutex_key#24){+.+.}-{4:4}, at: inode_lock_killable include/linux/fs.h:875 [inline]
 #1: ffff0000f67a2640 (&sb->s_type->i_mutex_key#24){+.+.}-{4:4}, at: do_truncate+0x164/0x210 fs/open.c:63
 #2: ffff0000f67a22e0 (&ocfs2_file_ip_alloc_sem_key){++++}-{4:4}, at: ocfs2_truncate_file+0x30c/0x12f4 fs/ocfs2/file.c:471

stack backtrace:
CPU: 0 UID: 0 PID: 7608 Comm: syz.0.173 Not tainted syzkaller #0 PREEMPT 
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
 __ocfs2_lock_refcount_tree fs/ocfs2/refcounttree.c:428 [inline]
 ocfs2_lock_refcount_tree+0x188/0x924 fs/ocfs2/refcounttree.c:463
 ocfs2_refcount_cow_hunk fs/ocfs2/refcounttree.c:3406 [inline]
 ocfs2_refcount_cow+0x4a4/0xb6c fs/ocfs2/refcounttree.c:3467
 ocfs2_cow_file_pos+0x2b4/0x314 fs/ocfs2/file.c:366
 ocfs2_orphan_for_truncate fs/ocfs2/file.c:387 [inline]
 ocfs2_truncate_file+0x354/0x12f4 fs/ocfs2/file.c:500
 ocfs2_setattr+0x1148/0x17a0 fs/ocfs2/file.c:1212
 notify_change+0x9a4/0xc50 fs/attr.c:552
 do_truncate+0x198/0x210 fs/open.c:68
 vfs_truncate+0x398/0x444 fs/open.c:118
 do_sys_truncate+0xe4/0x1a8 fs/open.c:141
 __do_sys_truncate fs/open.c:153 [inline]
 __se_sys_truncate fs/open.c:151 [inline]
 __arm64_sys_truncate+0x5c/0x74 fs/open.c:151
 __invoke_syscall arch/arm64/kernel/syscall.c:35 [inline]
 invoke_syscall+0x98/0x2b8 arch/arm64/kernel/syscall.c:49
 el0_svc_common+0x130/0x23c arch/arm64/kernel/syscall.c:132
 do_el0_svc+0x48/0x58 arch/arm64/kernel/syscall.c:151
 el0_svc+0x5c/0x254 arch/arm64/kernel/entry-common.c:744
 el0t_64_sync_handler+0x84/0x12c arch/arm64/kernel/entry-common.c:763
 el0t_64_sync+0x198/0x19c arch/arm64/kernel/entry.S:596


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
