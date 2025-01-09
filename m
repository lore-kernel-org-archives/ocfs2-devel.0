Received: from mail-il1-f208.google.com (mail-il1-f208.google.com [209.85.166.208])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6109C142E86
	for <ocfs2-devel@lists.linux.dev>; Thu,  9 Jan 2025 03:59:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.208
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736395163; cv=none; b=Sp3GRysyEmZlerTrRdVyzFtAQi378bU2T5xoSbEGsX01cjR8aQ0P2CZ6KQBHByYoFdsIG41ZxWiYpqtLSHtIovyYYiThZkF7C6LZHCjHC/POup/SltBz2EmrPiYVxJUvLAAC76fX18CiMN3Q6uuAtazP52Z4b8s1mmBKxhGGxMU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736395163; c=relaxed/simple;
	bh=73unjmQmQ5SdTwH78DfnrusQbpSIgtnoPnzH6ymccb0=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=g8fxq7BaZl0fS4DdDh98sel+L5Up3BSNLENfD23mUY2nFoEf7yacZDi3ht3zfP56XZbIBrFi4k5gmNIxGFD8BJFKgMs2iXCHpekGlxJ/e1JRGZOd3wxXY+aGbQXLu+JwJXy6SrAOcLwR1DCwgkSxCHW/J2nYZOlYXVmuP4l0ydo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.208
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f208.google.com with SMTP id e9e14a558f8ab-3cde3591dbfso4583395ab.0
        for <ocfs2-devel@lists.linux.dev>; Wed, 08 Jan 2025 19:59:21 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736395160; x=1736999960;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ON9kBCYGb6IA9BA3eM5RJo1Zmb3/fNqaXN1ugnnndDY=;
        b=P2FX5p8O5L62iPWqkEEZsYa/+Iu8njGdHZxbeCQr6mO600mM+79xDedorurBCRbgeZ
         DQtkQK6SoohamXwE6j12pgsqAJYnClGk0vxHiOSfOQ9CCwXCgUWR1K8gtuc4JXHRGC4S
         hFm4J6Xh/nKAZTNiCl0xyGR6RdWMxaM2BpOIkdpH+l3IhDwvgcXALIghywFXaa5iwdVK
         rTiZSAeJEoOTu/xWmvG6mgNlVFYWjUBI+v3qmXxJsGi2ZT4HBaKaaqpSaLj1aHwAnQX8
         EiwitjbfUmu9JRz6OCq/qI+d6KamcmX2Uy8HAWqAoSwfwJ2I5J+W4FwPqWtPMVYG/92W
         2pig==
X-Forwarded-Encrypted: i=1; AJvYcCUW3VxkHURS2Qc+T/pLBmJJ+DGPumyNqhugXCmsQVd65bJaqK+8IjHD0MmN/8s/c6XwwA9t1y0qfsQLGw==@lists.linux.dev
X-Gm-Message-State: AOJu0YyIO03BgaZhzJDjSN4PW9XlH/Ee9kmWC0TigsrELkuYZs6hoRCh
	ZNlV/lnrLI3IRYEKodAriCpp9cb+NdlRVgjtQ28UhfoFmJv21VRMX03Xu0TetqKzRDL4TDurrcJ
	kHcRjKzskTr6r2i6Rfe9ZXYJg6376GRfuWXHtTJUD8kmF/WhleyXjLAI=
X-Google-Smtp-Source: AGHT+IEJ7mr283m2LONsr8QQpzCqnXVqb0EhxcxAyn9T3UIkK+leOp2AtJqUn6ikA13tnKq4RH7ttXV4If70e9bv4LWlgFWrVx9n
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a92:cb47:0:b0:3a9:cc7f:2bc5 with SMTP id
 e9e14a558f8ab-3ce474edc85mr13500895ab.3.1736395160611; Wed, 08 Jan 2025
 19:59:20 -0800 (PST)
Date: Wed, 08 Jan 2025 19:59:20 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <677f4998.050a0220.25a300.01ac.GAE@google.com>
Subject: [syzbot] [ocfs2?] possible deadlock in ocfs2_lock_refcount_tree (2)
From: syzbot <syzbot+41cd2c009523c0f9f5b3@syzkaller.appspotmail.com>
To: jlbec@evilplan.org, joseph.qi@linux.alibaba.com, 
	linux-kernel@vger.kernel.org, mark@fasheh.com, ocfs2-devel@lists.linux.dev, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    573067a5a685 Merge branch 'for-next/core' into for-kernelci
git tree:       git://git.kernel.org/pub/scm/linux/kernel/git/arm64/linux.git for-kernelci
console output: https://syzkaller.appspot.com/x/log.txt?x=1749f8b0580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=cd7202b56d469648
dashboard link: https://syzkaller.appspot.com/bug?extid=41cd2c009523c0f9f5b3
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40
userspace arch: arm64

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/9d3b5c855aa0/disk-573067a5.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/0c06fc1ead83/vmlinux-573067a5.xz
kernel image: https://storage.googleapis.com/syzbot-assets/3390e59b9e4b/Image-573067a5.gz.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+41cd2c009523c0f9f5b3@syzkaller.appspotmail.com

ocfs2: Mounting device (7,3) on (node local, slot 0) with ordered data mode.
======================================================
WARNING: possible circular locking dependency detected
6.13.0-rc3-syzkaller-g573067a5a685 #0 Not tainted
------------------------------------------------------
syz.3.105/7096 is trying to acquire lock:
ffff0000d725e898 (&new->rf_sem){+.+.}-{4:4}, at: __ocfs2_lock_refcount_tree fs/ocfs2/refcounttree.c:428 [inline]
ffff0000d725e898 (&new->rf_sem){+.+.}-{4:4}, at: ocfs2_lock_refcount_tree+0x1f4/0xa48 fs/ocfs2/refcounttree.c:463

but task is already holding lock:
ffff0000f19f22e0 (&ocfs2_file_ip_alloc_sem_key){++++}-{4:4}, at: ocfs2_inode_lock_for_extent_tree+0x8c/0x1cc fs/ocfs2/file.c:2208

which lock already depends on the new lock.


the existing dependency chain (in reverse order) is:

-> #5 (&ocfs2_file_ip_alloc_sem_key){++++}-{4:4}:
       down_write+0x50/0xc0 kernel/locking/rwsem.c:1577
       ocfs2_try_remove_refcount_tree+0xb4/0x2f0 fs/ocfs2/refcounttree.c:932
       ocfs2_xattr_set+0x670/0x1448 fs/ocfs2/xattr.c:3669
       ocfs2_set_acl+0x410/0x4b4 fs/ocfs2/acl.c:254
       ocfs2_iop_set_acl+0x230/0x374 fs/ocfs2/acl.c:286
       set_posix_acl fs/posix_acl.c:954 [inline]
       vfs_remove_acl+0x470/0x6f4 fs/posix_acl.c:1241
       removexattr fs/xattr.c:1022 [inline]
       filename_removexattr fs/xattr.c:1052 [inline]
       path_removexattrat+0x2dc/0x598 fs/xattr.c:1088
       __do_sys_lremovexattr fs/xattr.c:1106 [inline]
       __se_sys_lremovexattr fs/xattr.c:1103 [inline]
       __arm64_sys_lremovexattr+0x64/0x7c fs/xattr.c:1103
       __invoke_syscall arch/arm64/kernel/syscall.c:35 [inline]
       invoke_syscall+0x98/0x2b8 arch/arm64/kernel/syscall.c:49
       el0_svc_common+0x130/0x23c arch/arm64/kernel/syscall.c:132
       do_el0_svc+0x48/0x58 arch/arm64/kernel/syscall.c:151
       el0_svc+0x54/0x168 arch/arm64/kernel/entry-common.c:744
       el0t_64_sync_handler+0x84/0x108 arch/arm64/kernel/entry-common.c:762
       el0t_64_sync+0x198/0x19c arch/arm64/kernel/entry.S:600

-> #4 (&oi->ip_xattr_sem){++++}-{4:4}:
       down_read+0x58/0x2fc kernel/locking/rwsem.c:1524
       ocfs2_init_acl+0x2c8/0x764 fs/ocfs2/acl.c:366
       ocfs2_mknod+0x1388/0x2438 fs/ocfs2/namei.c:410
       ocfs2_create+0x194/0x4d4 fs/ocfs2/namei.c:674
       lookup_open fs/namei.c:3649 [inline]
       open_last_lookups fs/namei.c:3748 [inline]
       path_openat+0x13e4/0x2b14 fs/namei.c:3984
       do_filp_open+0x1e8/0x404 fs/namei.c:4014
       do_sys_openat2+0x124/0x1b8 fs/open.c:1402
       do_sys_open fs/open.c:1417 [inline]
       __do_sys_openat fs/open.c:1433 [inline]
       __se_sys_openat fs/open.c:1428 [inline]
       __arm64_sys_openat+0x1f0/0x240 fs/open.c:1428
       __invoke_syscall arch/arm64/kernel/syscall.c:35 [inline]
       invoke_syscall+0x98/0x2b8 arch/arm64/kernel/syscall.c:49
       el0_svc_common+0x130/0x23c arch/arm64/kernel/syscall.c:132
       do_el0_svc+0x48/0x58 arch/arm64/kernel/syscall.c:151
       el0_svc+0x54/0x168 arch/arm64/kernel/entry-common.c:744
       el0t_64_sync_handler+0x84/0x108 arch/arm64/kernel/entry-common.c:762
       el0t_64_sync+0x198/0x19c arch/arm64/kernel/entry.S:600

-> #3 (jbd2_handle){++++}-{0:0}:
       start_this_handle+0xf34/0x11c4 fs/jbd2/transaction.c:448
       jbd2__journal_start+0x298/0x544 fs/jbd2/transaction.c:505
       jbd2_journal_start+0x3c/0x4c fs/jbd2/transaction.c:544
       ocfs2_start_trans+0x3d0/0x71c fs/ocfs2/journal.c:352
       ocfs2_block_group_alloc fs/ocfs2/suballoc.c:685 [inline]
       ocfs2_reserve_suballoc_bits+0x840/0x4254 fs/ocfs2/suballoc.c:832
       ocfs2_reserve_new_metadata_blocks+0x384/0x848 fs/ocfs2/suballoc.c:982
       ocfs2_mknod+0xdc8/0x2438 fs/ocfs2/namei.c:347
       ocfs2_create+0x194/0x4d4 fs/ocfs2/namei.c:674
       lookup_open fs/namei.c:3649 [inline]
       open_last_lookups fs/namei.c:3748 [inline]
       path_openat+0x13e4/0x2b14 fs/namei.c:3984
       do_filp_open+0x1e8/0x404 fs/namei.c:4014
       do_sys_openat2+0x124/0x1b8 fs/open.c:1402
       do_sys_open fs/open.c:1417 [inline]
       __do_sys_openat fs/open.c:1433 [inline]
       __se_sys_openat fs/open.c:1428 [inline]
       __arm64_sys_openat+0x1f0/0x240 fs/open.c:1428
       __invoke_syscall arch/arm64/kernel/syscall.c:35 [inline]
       invoke_syscall+0x98/0x2b8 arch/arm64/kernel/syscall.c:49
       el0_svc_common+0x130/0x23c arch/arm64/kernel/syscall.c:132
       do_el0_svc+0x48/0x58 arch/arm64/kernel/syscall.c:151
       el0_svc+0x54/0x168 arch/arm64/kernel/entry-common.c:744
       el0t_64_sync_handler+0x84/0x108 arch/arm64/kernel/entry-common.c:762
       el0t_64_sync+0x198/0x19c arch/arm64/kernel/entry.S:600

-> #2 (&journal->j_trans_barrier){.+.+}-{4:4}:
       down_read+0x58/0x2fc kernel/locking/rwsem.c:1524
       ocfs2_start_trans+0x3c4/0x71c fs/ocfs2/journal.c:350
       ocfs2_block_group_alloc fs/ocfs2/suballoc.c:685 [inline]
       ocfs2_reserve_suballoc_bits+0x840/0x4254 fs/ocfs2/suballoc.c:832
       ocfs2_reserve_new_metadata_blocks+0x384/0x848 fs/ocfs2/suballoc.c:982
       ocfs2_mknod+0xdc8/0x2438 fs/ocfs2/namei.c:347
       ocfs2_create+0x194/0x4d4 fs/ocfs2/namei.c:674
       lookup_open fs/namei.c:3649 [inline]
       open_last_lookups fs/namei.c:3748 [inline]
       path_openat+0x13e4/0x2b14 fs/namei.c:3984
       do_filp_open+0x1e8/0x404 fs/namei.c:4014
       do_sys_openat2+0x124/0x1b8 fs/open.c:1402
       do_sys_open fs/open.c:1417 [inline]
       __do_sys_openat fs/open.c:1433 [inline]
       __se_sys_openat fs/open.c:1428 [inline]
       __arm64_sys_openat+0x1f0/0x240 fs/open.c:1428
       __invoke_syscall arch/arm64/kernel/syscall.c:35 [inline]
       invoke_syscall+0x98/0x2b8 arch/arm64/kernel/syscall.c:49
       el0_svc_common+0x130/0x23c arch/arm64/kernel/syscall.c:132
       do_el0_svc+0x48/0x58 arch/arm64/kernel/syscall.c:151
       el0_svc+0x54/0x168 arch/arm64/kernel/entry-common.c:744
       el0t_64_sync_handler+0x84/0x108 arch/arm64/kernel/entry-common.c:762
       el0t_64_sync+0x198/0x19c arch/arm64/kernel/entry.S:600

-> #1 (sb_internal#4){.+.+}-{0:0}:
       percpu_down_read include/linux/percpu-rwsem.h:51 [inline]
       __sb_start_write include/linux/fs.h:1725 [inline]
       sb_start_intwrite include/linux/fs.h:1908 [inline]
       ocfs2_start_trans+0x244/0x71c fs/ocfs2/journal.c:348
       ocfs2_set_refcount_tree+0x24c/0x720 fs/ocfs2/refcounttree.c:713
       ocfs2_reflink_remap_blocks+0x558/0x1a50 fs/ocfs2/refcounttree.c:4666
       ocfs2_remap_file_range+0x504/0x794 fs/ocfs2/file.c:2740
       vfs_copy_file_range+0xe64/0x1300 fs/read_write.c:1584
       __do_sys_copy_file_range fs/read_write.c:1670 [inline]
       __se_sys_copy_file_range fs/read_write.c:1637 [inline]
       __arm64_sys_copy_file_range+0x490/0x8c8 fs/read_write.c:1637
       __invoke_syscall arch/arm64/kernel/syscall.c:35 [inline]
       invoke_syscall+0x98/0x2b8 arch/arm64/kernel/syscall.c:49
       el0_svc_common+0x130/0x23c arch/arm64/kernel/syscall.c:132
       do_el0_svc+0x48/0x58 arch/arm64/kernel/syscall.c:151
       el0_svc+0x54/0x168 arch/arm64/kernel/entry-common.c:744
       el0t_64_sync_handler+0x84/0x108 arch/arm64/kernel/entry-common.c:762
       el0t_64_sync+0x198/0x19c arch/arm64/kernel/entry.S:600

-> #0 (&new->rf_sem){+.+.}-{4:4}:
       check_prev_add kernel/locking/lockdep.c:3161 [inline]
       check_prevs_add kernel/locking/lockdep.c:3280 [inline]
       validate_chain kernel/locking/lockdep.c:3904 [inline]
       __lock_acquire+0x34f0/0x7904 kernel/locking/lockdep.c:5226
       lock_acquire+0x23c/0x724 kernel/locking/lockdep.c:5849
       down_write+0x50/0xc0 kernel/locking/rwsem.c:1577
       __ocfs2_lock_refcount_tree fs/ocfs2/refcounttree.c:428 [inline]
       ocfs2_lock_refcount_tree+0x1f4/0xa48 fs/ocfs2/refcounttree.c:463
       ocfs2_refcount_cow_hunk fs/ocfs2/refcounttree.c:3409 [inline]
       ocfs2_refcount_cow+0x5d4/0xf30 fs/ocfs2/refcounttree.c:3470
       ocfs2_prepare_inode_for_write fs/ocfs2/file.c:2340 [inline]
       ocfs2_file_write_iter+0xe14/0x1f3c fs/ocfs2/file.c:2451
       new_sync_write fs/read_write.c:586 [inline]
       vfs_write+0x920/0xcf4 fs/read_write.c:679
       ksys_write+0x15c/0x26c fs/read_write.c:731
       __do_sys_write fs/read_write.c:742 [inline]
       __se_sys_write fs/read_write.c:739 [inline]
       __arm64_sys_write+0x7c/0x90 fs/read_write.c:739
       __invoke_syscall arch/arm64/kernel/syscall.c:35 [inline]
       invoke_syscall+0x98/0x2b8 arch/arm64/kernel/syscall.c:49
       el0_svc_common+0x130/0x23c arch/arm64/kernel/syscall.c:132
       do_el0_svc+0x48/0x58 arch/arm64/kernel/syscall.c:151
       el0_svc+0x54/0x168 arch/arm64/kernel/entry-common.c:744
       el0t_64_sync_handler+0x84/0x108 arch/arm64/kernel/entry-common.c:762
       el0t_64_sync+0x198/0x19c arch/arm64/kernel/entry.S:600

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

4 locks held by syz.3.105/7096:
 #0: ffff0000d5ce6478 (&f->f_pos_lock){+.+.}-{4:4}, at: fdget_pos+0x220/0x2ac fs/file.c:1191
 #1: ffff0000eff00420 (sb_writers#18){.+.+}-{0:0}, at: file_start_write include/linux/fs.h:2964 [inline]
 #1: ffff0000eff00420 (sb_writers#18){.+.+}-{0:0}, at: vfs_write+0x354/0xcf4 fs/read_write.c:675
 #2: ffff0000f19f2640 (&sb->s_type->i_mutex_key#23){+.+.}-{4:4}, at: inode_lock include/linux/fs.h:818 [inline]
 #2: ffff0000f19f2640 (&sb->s_type->i_mutex_key#23){+.+.}-{4:4}, at: ocfs2_file_write_iter+0x3a4/0x1f3c fs/ocfs2/file.c:2399
 #3: ffff0000f19f22e0 (&ocfs2_file_ip_alloc_sem_key){++++}-{4:4}, at: ocfs2_inode_lock_for_extent_tree+0x8c/0x1cc fs/ocfs2/file.c:2208

stack backtrace:
CPU: 0 UID: 0 PID: 7096 Comm: syz.3.105 Not tainted 6.13.0-rc3-syzkaller-g573067a5a685 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 09/13/2024
Call trace:
 show_stack+0x2c/0x3c arch/arm64/kernel/stacktrace.c:466 (C)
 __dump_stack lib/dump_stack.c:94 [inline]
 dump_stack_lvl+0xe4/0x150 lib/dump_stack.c:120
 dump_stack+0x1c/0x28 lib/dump_stack.c:129
 print_circular_bug+0x154/0x1c0 kernel/locking/lockdep.c:2074
 check_noncircular+0x310/0x404 kernel/locking/lockdep.c:2206
 check_prev_add kernel/locking/lockdep.c:3161 [inline]
 check_prevs_add kernel/locking/lockdep.c:3280 [inline]
 validate_chain kernel/locking/lockdep.c:3904 [inline]
 __lock_acquire+0x34f0/0x7904 kernel/locking/lockdep.c:5226
 lock_acquire+0x23c/0x724 kernel/locking/lockdep.c:5849
 down_write+0x50/0xc0 kernel/locking/rwsem.c:1577
 __ocfs2_lock_refcount_tree fs/ocfs2/refcounttree.c:428 [inline]
 ocfs2_lock_refcount_tree+0x1f4/0xa48 fs/ocfs2/refcounttree.c:463
 ocfs2_refcount_cow_hunk fs/ocfs2/refcounttree.c:3409 [inline]
 ocfs2_refcount_cow+0x5d4/0xf30 fs/ocfs2/refcounttree.c:3470
 ocfs2_prepare_inode_for_write fs/ocfs2/file.c:2340 [inline]
 ocfs2_file_write_iter+0xe14/0x1f3c fs/ocfs2/file.c:2451
 new_sync_write fs/read_write.c:586 [inline]
 vfs_write+0x920/0xcf4 fs/read_write.c:679
 ksys_write+0x15c/0x26c fs/read_write.c:731
 __do_sys_write fs/read_write.c:742 [inline]
 __se_sys_write fs/read_write.c:739 [inline]
 __arm64_sys_write+0x7c/0x90 fs/read_write.c:739
 __invoke_syscall arch/arm64/kernel/syscall.c:35 [inline]
 invoke_syscall+0x98/0x2b8 arch/arm64/kernel/syscall.c:49
 el0_svc_common+0x130/0x23c arch/arm64/kernel/syscall.c:132
 do_el0_svc+0x48/0x58 arch/arm64/kernel/syscall.c:151
 el0_svc+0x54/0x168 arch/arm64/kernel/entry-common.c:744
 el0t_64_sync_handler+0x84/0x108 arch/arm64/kernel/entry-common.c:762
 el0t_64_sync+0x198/0x19c arch/arm64/kernel/entry.S:600


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
