Received: from mail-il1-f197.google.com (mail-il1-f197.google.com [209.85.166.197])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 078EF15689A
	for <ocfs2-devel@lists.linux.dev>; Fri, 22 Nov 2024 05:26:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.197
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732253190; cv=none; b=uwsGdCQ+yli5UFNME0IDlny1sx+2Pd5V3fE3/n6AgUYQt0VBC4lDX6/zVXIThvlIpTs4zePRaeMiChNalwu5W9bIpj5qQF577rBzBKYnTseJinyUKgPF3K25d72MWcl6FlK7KIauu2Oz/W12OQb/Eh7BbAFPAbuKG1A35t2VqNY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732253190; c=relaxed/simple;
	bh=/cFnaT704CNVwV21jLJXzVKDdzKMQEhqxzrMUqSGHnY=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:
	 Content-Type; b=tUPHnUJ56Mn4zxdb3iDaRKnxdzcymoXfy6NJ1srT4rUqfqfa0DBzs+b3QW2bTe+lY+m5+pmwXXY/wlwse0vK6KlouzHLU75dC/23QfIsGgKL2ypA8WXHr59jkiNNWLlkJ1ZkDuRf4/wIhTSe8M/dQGFnQqK7n3x5frDUWCStcXM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.197
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f197.google.com with SMTP id e9e14a558f8ab-3a79088e7abso17605445ab.1
        for <ocfs2-devel@lists.linux.dev>; Thu, 21 Nov 2024 21:26:27 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732253187; x=1732857987;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=FUUsc/P2AfGevyv0MtNH0K0+BwMU/MMmxEQinFgKp14=;
        b=wgxWhSwJbitO+xjTfyDfGvQsvIA6a6OWcZKMlz2TpSW8TJOhBAFdaU+R1huix7cP00
         Mc6mxGnpBZPoOZ2qelW70mHmXVQEwBe6qDOYbNDwTWknKDsYcvpgORmSXFo0EjTnUrDH
         jPks7Xwf6XTXzFtZpzqaASMZeP90sq45IoWsxURKTTlL5rkoNPYndc5cC7HcxvSc/+Uy
         xe5X3Jxz1VBXFxhFS+6veE7y5fvfOS5cpdxC8wx9azfFp1eubFObJnujD4OuemkzlM0j
         OTSdy42kDkO8Guzsc3KofFXJ0kT7UrNAJz2286DG5unvxzAjTqDF2kqQgUmLpzOrS6cU
         jMiA==
X-Forwarded-Encrypted: i=1; AJvYcCUAp0IFs4JoA8y5VhtlnV1iDDO4SVNDIwrI6OkKrI49L4uOdFD9RqhieQ6G4y9SqicRf8ktZu48ueCPHw==@lists.linux.dev
X-Gm-Message-State: AOJu0YzaiPTsuqaHueSUfuIChs0JQDssccv3Hry+YYWProQ2P1KY8oWH
	NM0cExE+L4eN3v4RSfPFhiG8NQ5CRFmxx+MNrA6aobRBcm3pzJA/ie79X+kZqLyaWgw1XH8PH15
	f2aN+yPk0YFmw5ereBoMiZ3UAAKBNkCDgZIY6cOPKnBCCZjBCVz3CnlE=
X-Google-Smtp-Source: AGHT+IEVs/7mYLgstw7iWv/rh45UJJsFGA5KaZ75PmJrKcxsyHHtXlZy0H+lZtqfs8h5RVuuzIKouuB8UjmYBS+ODt/AD2iqSCch
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1a28:b0:3a7:85ee:fa78 with SMTP id
 e9e14a558f8ab-3a79af9bd40mr21366985ab.18.1732253187141; Thu, 21 Nov 2024
 21:26:27 -0800 (PST)
Date: Thu, 21 Nov 2024 21:26:27 -0800
In-Reply-To: <0000000000006d43c106226680dd@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <67401603.050a0220.363a1b.0134.GAE@google.com>
Subject: Re: [syzbot] [ocfs2?] possible deadlock in ocfs2_xattr_set_handle
From: syzbot <syzbot+57c4c06621ff1840eb8d@syzkaller.appspotmail.com>
To: jlbec@evilplan.org, joseph.qi@linux.alibaba.com, 
	linux-kernel@vger.kernel.org, mark@fasheh.com, ocfs2-devel@lists.linux.dev, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

syzbot has found a reproducer for the following issue on:

HEAD commit:    7b1d1d4cfac0 Merge remote-tracking branch 'iommu/arm/smmu'..
git tree:       git://git.kernel.org/pub/scm/linux/kernel/git/arm64/linux.git for-kernelci
console output: https://syzkaller.appspot.com/x/log.txt?x=1504cec0580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=dfe1e340fbee3d16
dashboard link: https://syzkaller.appspot.com/bug?extid=57c4c06621ff1840eb8d
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40
userspace arch: arm64
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=140e06e8580000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/354fe38e2935/disk-7b1d1d4c.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/f12e0b1ef3fd/vmlinux-7b1d1d4c.xz
kernel image: https://storage.googleapis.com/syzbot-assets/291dbc519bb3/Image-7b1d1d4c.gz.xz
mounted in repro #1: https://storage.googleapis.com/syzbot-assets/10cf9689f0eb/mount_0.gz
mounted in repro #2: https://storage.googleapis.com/syzbot-assets/c2502d6ad71e/mount_2.gz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+57c4c06621ff1840eb8d@syzkaller.appspotmail.com

======================================================
WARNING: possible circular locking dependency detected
6.12.0-syzkaller-g7b1d1d4cfac0 #0 Not tainted
------------------------------------------------------
syz.1.388/8185 is trying to acquire lock:
ffff0000f6835c78 (&oi->ip_xattr_sem){+.+.}-{3:3}, at: ocfs2_xattr_set_handle+0x40c/0x824 fs/ocfs2/xattr.c:3501

but task is already holding lock:
ffff0000d7738958 (jbd2_handle){++++}-{0:0}, at: start_this_handle+0xf0c/0x11c4 fs/jbd2/transaction.c:446

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
       ocfs2_fill_super+0x3e30/0x48e8 fs/ocfs2/super.c:1141
       mount_bdev+0x1d4/0x2a0 fs/super.c:1693
       ocfs2_mount+0x44/0x58 fs/ocfs2/super.c:1188
       legacy_get_tree+0xd4/0x16c fs/fs_context.c:662
       vfs_get_tree+0x90/0x28c fs/super.c:1814
       do_new_mount+0x278/0x900 fs/namespace.c:3507
       path_mount+0x590/0xe04 fs/namespace.c:3834
       do_mount fs/namespace.c:3847 [inline]
       __do_sys_mount fs/namespace.c:4057 [inline]
       __se_sys_mount fs/namespace.c:4034 [inline]
       __arm64_sys_mount+0x4d4/0x5ac fs/namespace.c:4034
       __invoke_syscall arch/arm64/kernel/syscall.c:35 [inline]
       invoke_syscall+0x98/0x2b8 arch/arm64/kernel/syscall.c:49
       el0_svc_common+0x130/0x23c arch/arm64/kernel/syscall.c:132
       do_el0_svc+0x48/0x58 arch/arm64/kernel/syscall.c:151
       el0_svc+0x54/0x168 arch/arm64/kernel/entry-common.c:744
       el0t_64_sync_handler+0x84/0x108 arch/arm64/kernel/entry-common.c:762
       el0t_64_sync+0x198/0x19c arch/arm64/kernel/entry.S:600

-> #3 (&journal->j_trans_barrier){.+.+}-{3:3}:
       down_read+0x58/0x2fc kernel/locking/rwsem.c:1524
       ocfs2_start_trans+0x3c4/0x71c fs/ocfs2/journal.c:350
       ocfs2_modify_bh+0xe4/0x484 fs/ocfs2/quota_local.c:101
       ocfs2_local_read_info+0x1220/0x15bc fs/ocfs2/quota_local.c:771
       dquot_load_quota_sb+0x6e4/0xb24 fs/quota/dquot.c:2458
       dquot_load_quota_inode+0x280/0x4f4 fs/quota/dquot.c:2495
       ocfs2_enable_quotas+0x17c/0x3cc fs/ocfs2/super.c:926
       ocfs2_fill_super+0x3e30/0x48e8 fs/ocfs2/super.c:1141
       mount_bdev+0x1d4/0x2a0 fs/super.c:1693
       ocfs2_mount+0x44/0x58 fs/ocfs2/super.c:1188
       legacy_get_tree+0xd4/0x16c fs/fs_context.c:662
       vfs_get_tree+0x90/0x28c fs/super.c:1814
       do_new_mount+0x278/0x900 fs/namespace.c:3507
       path_mount+0x590/0xe04 fs/namespace.c:3834
       do_mount fs/namespace.c:3847 [inline]
       __do_sys_mount fs/namespace.c:4057 [inline]
       __se_sys_mount fs/namespace.c:4034 [inline]
       __arm64_sys_mount+0x4d4/0x5ac fs/namespace.c:4034
       __invoke_syscall arch/arm64/kernel/syscall.c:35 [inline]
       invoke_syscall+0x98/0x2b8 arch/arm64/kernel/syscall.c:49
       el0_svc_common+0x130/0x23c arch/arm64/kernel/syscall.c:132
       do_el0_svc+0x48/0x58 arch/arm64/kernel/syscall.c:151
       el0_svc+0x54/0x168 arch/arm64/kernel/entry-common.c:744
       el0t_64_sync_handler+0x84/0x108 arch/arm64/kernel/entry-common.c:762
       el0t_64_sync+0x198/0x19c arch/arm64/kernel/entry.S:600

-> #2 (sb_internal#2){.+.+}-{0:0}:
       percpu_down_read include/linux/percpu-rwsem.h:51 [inline]
       __sb_start_write include/linux/fs.h:1716 [inline]
       sb_start_intwrite include/linux/fs.h:1899 [inline]
       ocfs2_start_trans+0x244/0x71c fs/ocfs2/journal.c:348
       ocfs2_xattr_set+0xdac/0x1448 fs/ocfs2/xattr.c:3643
       ocfs2_set_acl+0x410/0x4b4 fs/ocfs2/acl.c:254
       ocfs2_iop_set_acl+0x230/0x374 fs/ocfs2/acl.c:286
       set_posix_acl fs/posix_acl.c:955 [inline]
       vfs_set_acl+0x7a0/0xa24 fs/posix_acl.c:1134
       do_set_acl+0xe4/0x1ac fs/posix_acl.c:1279
       do_setxattr fs/xattr.c:626 [inline]
       path_setxattr+0x334/0x428 fs/xattr.c:658
       __do_sys_setxattr fs/xattr.c:676 [inline]
       __se_sys_setxattr fs/xattr.c:672 [inline]
       __arm64_sys_setxattr+0xbc/0xd8 fs/xattr.c:672
       __invoke_syscall arch/arm64/kernel/syscall.c:35 [inline]
       invoke_syscall+0x98/0x2b8 arch/arm64/kernel/syscall.c:49
       el0_svc_common+0x130/0x23c arch/arm64/kernel/syscall.c:132
       do_el0_svc+0x48/0x58 arch/arm64/kernel/syscall.c:151
       el0_svc+0x54/0x168 arch/arm64/kernel/entry-common.c:744
       el0t_64_sync_handler+0x84/0x108 arch/arm64/kernel/entry-common.c:762
       el0t_64_sync+0x198/0x19c arch/arm64/kernel/entry.S:600

-> #1 (&ocfs2_sysfile_lock_key[args->fi_sysfile_type]#3){+.+.}-{3:3}:
       down_write+0x50/0xc0 kernel/locking/rwsem.c:1577
       inode_lock include/linux/fs.h:815 [inline]
       ocfs2_reserve_suballoc_bits+0x164/0x4288 fs/ocfs2/suballoc.c:786
       ocfs2_reserve_new_metadata_blocks+0x384/0x848 fs/ocfs2/suballoc.c:982
       ocfs2_init_xattr_set_ctxt+0x394/0x968 fs/ocfs2/xattr.c:3277
       ocfs2_xattr_set+0xbe0/0x1448 fs/ocfs2/xattr.c:3634
       ocfs2_set_acl+0x410/0x4b4 fs/ocfs2/acl.c:254
       ocfs2_iop_set_acl+0x230/0x374 fs/ocfs2/acl.c:286
       set_posix_acl fs/posix_acl.c:955 [inline]
       vfs_set_acl+0x7a0/0xa24 fs/posix_acl.c:1134
       do_set_acl+0xe4/0x1ac fs/posix_acl.c:1279
       do_setxattr fs/xattr.c:626 [inline]
       path_setxattr+0x334/0x428 fs/xattr.c:658
       __do_sys_setxattr fs/xattr.c:676 [inline]
       __se_sys_setxattr fs/xattr.c:672 [inline]
       __arm64_sys_setxattr+0xbc/0xd8 fs/xattr.c:672
       __invoke_syscall arch/arm64/kernel/syscall.c:35 [inline]
       invoke_syscall+0x98/0x2b8 arch/arm64/kernel/syscall.c:49
       el0_svc_common+0x130/0x23c arch/arm64/kernel/syscall.c:132
       do_el0_svc+0x48/0x58 arch/arm64/kernel/syscall.c:151
       el0_svc+0x54/0x168 arch/arm64/kernel/entry-common.c:744
       el0t_64_sync_handler+0x84/0x108 arch/arm64/kernel/entry-common.c:762
       el0t_64_sync+0x198/0x19c arch/arm64/kernel/entry.S:600

-> #0 (&oi->ip_xattr_sem){+.+.}-{3:3}:
       check_prev_add kernel/locking/lockdep.c:3161 [inline]
       check_prevs_add kernel/locking/lockdep.c:3280 [inline]
       validate_chain kernel/locking/lockdep.c:3904 [inline]
       __lock_acquire+0x33f8/0x77c8 kernel/locking/lockdep.c:5202
       lock_acquire+0x240/0x728 kernel/locking/lockdep.c:5825
       down_write+0x50/0xc0 kernel/locking/rwsem.c:1577
       ocfs2_xattr_set_handle+0x40c/0x824 fs/ocfs2/xattr.c:3501
       ocfs2_init_security_set+0xb4/0xd8 fs/ocfs2/xattr.c:7307
       ocfs2_mknod+0x1408/0x243c fs/ocfs2/namei.c:417
       ocfs2_mkdir+0x194/0x4e0 fs/ocfs2/namei.c:655
       vfs_mkdir+0x27c/0x410 fs/namei.c:4257
       do_mkdirat+0x248/0x574 fs/namei.c:4280
       __do_sys_mkdirat fs/namei.c:4295 [inline]
       __se_sys_mkdirat fs/namei.c:4293 [inline]
       __arm64_sys_mkdirat+0x8c/0xa4 fs/namei.c:4293
       __invoke_syscall arch/arm64/kernel/syscall.c:35 [inline]
       invoke_syscall+0x98/0x2b8 arch/arm64/kernel/syscall.c:49
       el0_svc_common+0x130/0x23c arch/arm64/kernel/syscall.c:132
       do_el0_svc+0x48/0x58 arch/arm64/kernel/syscall.c:151
       el0_svc+0x54/0x168 arch/arm64/kernel/entry-common.c:744
       el0t_64_sync_handler+0x84/0x108 arch/arm64/kernel/entry-common.c:762
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
  lock(&oi->ip_xattr_sem);

 *** DEADLOCK ***

8 locks held by syz.1.388/8185:
 #0: ffff0000ec0e4420 (sb_writers#12){.+.+}-{0:0}, at: mnt_want_write+0x44/0x9c fs/namespace.c:515
 #1: ffff0000e64fd100 (&type->i_mutex_dir_key#8/1){+.+.}-{3:3}, at: inode_lock_nested include/linux/fs.h:850 [inline]
 #1: ffff0000e64fd100 (&type->i_mutex_dir_key#8/1){+.+.}-{3:3}, at: filename_create+0x204/0x468 fs/namei.c:4026
 #2: ffff0000f6835100 (&ocfs2_sysfile_lock_key[args->fi_sysfile_type]#5){+.+.}-{3:3}, at: inode_lock include/linux/fs.h:815 [inline]
 #2: ffff0000f6835100 (&ocfs2_sysfile_lock_key[args->fi_sysfile_type]#5){+.+.}-{3:3}, at: ocfs2_reserve_suballoc_bits+0x164/0x4288 fs/ocfs2/suballoc.c:786
 #3: ffff0000f0c51800 (&ocfs2_sysfile_lock_key[args->fi_sysfile_type]#3){+.+.}-{3:3}, at: inode_lock include/linux/fs.h:815 [inline]
 #3: ffff0000f0c51800 (&ocfs2_sysfile_lock_key[args->fi_sysfile_type]#3){+.+.}-{3:3}, at: ocfs2_reserve_suballoc_bits+0x164/0x4288 fs/ocfs2/suballoc.c:786
 #4: ffff0000f68309c0 (&ocfs2_sysfile_lock_key[args->fi_sysfile_type]#6){+.+.}-{3:3}, at: inode_lock include/linux/fs.h:815 [inline]
 #4: ffff0000f68309c0 (&ocfs2_sysfile_lock_key[args->fi_sysfile_type]#6){+.+.}-{3:3}, at: ocfs2_reserve_local_alloc_bits+0xfc/0x247c fs/ocfs2/localalloc.c:636
 #5: ffff0000ec0e4610 (sb_internal#2){.+.+}-{0:0}, at: ocfs2_mknod+0xe58/0x243c fs/ocfs2/namei.c:359
 #6: ffff0000c8e370e8 (&journal->j_trans_barrier){.+.+}-{3:3}, at: ocfs2_start_trans+0x3c4/0x71c fs/ocfs2/journal.c:350
 #7: ffff0000d7738958 (jbd2_handle){++++}-{0:0}, at: start_this_handle+0xf0c/0x11c4 fs/jbd2/transaction.c:446

stack backtrace:
CPU: 0 UID: 0 PID: 8185 Comm: syz.1.388 Not tainted 6.12.0-syzkaller-g7b1d1d4cfac0 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 09/13/2024
Call trace:
 show_stack+0x2c/0x3c arch/arm64/kernel/stacktrace.c:484 (C)
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
 down_write+0x50/0xc0 kernel/locking/rwsem.c:1577
 ocfs2_xattr_set_handle+0x40c/0x824 fs/ocfs2/xattr.c:3501
 ocfs2_init_security_set+0xb4/0xd8 fs/ocfs2/xattr.c:7307
 ocfs2_mknod+0x1408/0x243c fs/ocfs2/namei.c:417
 ocfs2_mkdir+0x194/0x4e0 fs/ocfs2/namei.c:655
 vfs_mkdir+0x27c/0x410 fs/namei.c:4257
 do_mkdirat+0x248/0x574 fs/namei.c:4280
 __do_sys_mkdirat fs/namei.c:4295 [inline]
 __se_sys_mkdirat fs/namei.c:4293 [inline]
 __arm64_sys_mkdirat+0x8c/0xa4 fs/namei.c:4293
 __invoke_syscall arch/arm64/kernel/syscall.c:35 [inline]
 invoke_syscall+0x98/0x2b8 arch/arm64/kernel/syscall.c:49
 el0_svc_common+0x130/0x23c arch/arm64/kernel/syscall.c:132
 do_el0_svc+0x48/0x58 arch/arm64/kernel/syscall.c:151
 el0_svc+0x54/0x168 arch/arm64/kernel/entry-common.c:744
 el0t_64_sync_handler+0x84/0x108 arch/arm64/kernel/entry-common.c:762
 el0t_64_sync+0x198/0x19c arch/arm64/kernel/entry.S:600


---
If you want syzbot to run the reproducer, reply with:
#syz test: git://repo/address.git branch-or-commit-hash
If you attach or paste a git patch, syzbot will apply it before testing.
