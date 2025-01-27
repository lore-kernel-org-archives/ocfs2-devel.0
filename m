Received: from mail-il1-f205.google.com (mail-il1-f205.google.com [209.85.166.205])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 427B34A1D
	for <ocfs2-devel@lists.linux.dev>; Mon, 27 Jan 2025 00:18:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.205
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737937108; cv=none; b=QXwJV4G3cClwVPyJG6LYRHUyJMcd05XxlxpmfqqkOSoyS/zjsERtAtrZngo49/xk8/JZXuCp/jmlQR1ceqXsmo4MOoGayyVpzBeqsO6zY1XW/sagvWInf1EwCDQI89v1TBHATbGOarUi6IIkEdE8iGVEgBLSM2lV5rnqT/f2acc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737937108; c=relaxed/simple;
	bh=tR8TQCyE1OYqYzOYaFHghl/rUMAVkzzehS24LZbCgi0=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:
	 Content-Type; b=hFSJ+pCSpM9wd9Bwa1QCwb9tYKtMKlcIEDn5b+LzPGRssr7hodRLAZ5zjZVhl6NvRXpcIArHMZKiuyX87vVahZPk5U+6b4OfG/Kt9iypKJDWujp5KyCuT62t/2Ny9RzU670DtA8OMfEgQGxY3JhiE+MncibRexDOEj0u0Wg1Ixw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.205
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f205.google.com with SMTP id e9e14a558f8ab-3a814bfb77bso36341465ab.0
        for <ocfs2-devel@lists.linux.dev>; Sun, 26 Jan 2025 16:18:25 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737937105; x=1738541905;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ozMTB8psgZOlSJzcqt++GK47tQT6lwIf8I3YFtf+7wk=;
        b=lW/bg/mxQEdedV8IQFDwfRHdNHzeZXpXSoLiuzda/ZRbLA0rg8eiyyRQqor6umXmeo
         1zfDh4Vuf3aZReoMUHZI+kJePhSPmZonehCvPsA5jLE/OIMptqHUHjpPVq2aNJSpsFMi
         mDN6zBxlIelYDEx8635Bc584BuTkd9VooDpm2le8KiRum60OYjAZvZef/2dLGBIUlhpO
         lQvoU6kc7TsoLXn4atcAwMwq7MCG6W0O8j6/tcD7wfg4DL5yR3THn4PVuT8cZ60qGYyg
         +LW45S8I5L0SMXm4HRLJxExn6WAAozLe+1SCbHL8B/gFkxbjZR/EJ/SAUkAbKHIkL0Dc
         FDTA==
X-Forwarded-Encrypted: i=1; AJvYcCXKKLOyfa5/Fd5BL8TrNJv5k7SJRgNjFW0be7DevASrdWjqOrwcQpvuSNoeP4MiVuTPzqcEQtDczM/bWQ==@lists.linux.dev
X-Gm-Message-State: AOJu0Yxa4lircloFVMxDDiu0Y4Ed0A+dSAnoxeNBnfOj8rBkhp/FelGp
	NlhRmhAMVLppaco/bzSYi+UFiHeNjSzB2SIjMHUK76BfOhDJtxFxmBwxReQcAHnVCu+dpVZQCxW
	RBpRSmfkha+ie8AtYXxCAgXUbsJTgTVQjpMufbOUV1EUanZpFYJgGRXw=
X-Google-Smtp-Source: AGHT+IHByie6pOlCpOa1f4geNLnUUlzZ5CG320VzrRkK5/Ee3CA7k5Lp0hULsnKWdoiHvCxbesLzvYVzadpj+UH5z0nX3o0zuWXR
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:148a:b0:3cf:b2ca:39b7 with SMTP id
 e9e14a558f8ab-3cfbc12fc2cmr126503855ab.3.1737937105388; Sun, 26 Jan 2025
 16:18:25 -0800 (PST)
Date: Sun, 26 Jan 2025 16:18:25 -0800
In-Reply-To: <0000000000006d43c106226680dd@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6796d0d1.050a0220.11b1bb.0080.GAE@google.com>
Subject: Re: [syzbot] [ocfs2?] possible deadlock in ocfs2_xattr_set_handle
From: syzbot <syzbot+57c4c06621ff1840eb8d@syzkaller.appspotmail.com>
To: jlbec@evilplan.org, joseph.qi@linux.alibaba.com, 
	linux-kernel@vger.kernel.org, mark@fasheh.com, ocfs2-devel@lists.linux.dev, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

syzbot has found a reproducer for the following issue on:

HEAD commit:    1950a0af2d55 Merge tag 'arm64-upstream' into for-kernelci
git tree:       git://git.kernel.org/pub/scm/linux/kernel/git/arm64/linux.git for-kernelci
console output: https://syzkaller.appspot.com/x/log.txt?x=158dc6b0580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=cd5bb525e2b2bae
dashboard link: https://syzkaller.appspot.com/bug?extid=57c4c06621ff1840eb8d
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40
userspace arch: arm64
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=13a1f5df980000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1131b624580000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/1ebe061fa55c/disk-1950a0af.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/943902875907/vmlinux-1950a0af.xz
kernel image: https://storage.googleapis.com/syzbot-assets/9b5110e82096/Image-1950a0af.gz.xz
mounted in repro: https://storage.googleapis.com/syzbot-assets/eef5374d78f0/mount_0.gz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+57c4c06621ff1840eb8d@syzkaller.appspotmail.com

JBD2: Ignoring recovery information on journal
ocfs2: Mounting device (7,0) on (node local, slot 0) with ordered data mode.
======================================================
WARNING: possible circular locking dependency detected
6.13.0-rc7-syzkaller-g1950a0af2d55 #0 Not tainted
------------------------------------------------------
syz-executor418/6412 is trying to acquire lock:
ffff0000de2f3ff8 (&oi->ip_xattr_sem){+.+.}-{4:4}, at: ocfs2_xattr_set_handle+0x40c/0x824 fs/ocfs2/xattr.c:3501

but task is already holding lock:
ffff0000c2e18958 (jbd2_handle){.+.+}-{0:0}, at: start_this_handle+0xf0c/0x11c4 fs/jbd2/transaction.c:446

which lock already depends on the new lock.


the existing dependency chain (in reverse order) is:

-> #4 (jbd2_handle){.+.+}-{0:0}:
       start_this_handle+0xf34/0x11c4 fs/jbd2/transaction.c:448
       jbd2__journal_start+0x298/0x544 fs/jbd2/transaction.c:505
       jbd2_journal_start+0x3c/0x4c fs/jbd2/transaction.c:544
       ocfs2_start_trans+0x3d0/0x71c fs/ocfs2/journal.c:352
       ocfs2_acl_set_mode+0x22c/0x794 fs/ocfs2/acl.c:174
       ocfs2_iop_set_acl+0x308/0x374 fs/ocfs2/acl.c:282
       set_posix_acl fs/posix_acl.c:954 [inline]
       vfs_set_acl+0x7a0/0xa24 fs/posix_acl.c:1133
       do_set_acl+0xe4/0x1ac fs/posix_acl.c:1278
       do_setxattr fs/xattr.c:633 [inline]
       file_setxattr+0x208/0x284 fs/xattr.c:646
       path_setxattrat+0x3b0/0x41c fs/xattr.c:711
       __do_sys_fsetxattr fs/xattr.c:761 [inline]
       __se_sys_fsetxattr fs/xattr.c:758 [inline]
       __arm64_sys_fsetxattr+0xc0/0xdc fs/xattr.c:758
       __invoke_syscall arch/arm64/kernel/syscall.c:35 [inline]
       invoke_syscall+0x98/0x2b8 arch/arm64/kernel/syscall.c:49
       el0_svc_common+0x130/0x23c arch/arm64/kernel/syscall.c:132
       do_el0_svc+0x48/0x58 arch/arm64/kernel/syscall.c:151
       el0_svc+0x54/0x168 arch/arm64/kernel/entry-common.c:744
       el0t_64_sync_handler+0x84/0x108 arch/arm64/kernel/entry-common.c:762
       el0t_64_sync+0x198/0x19c arch/arm64/kernel/entry.S:600

-> #3 (&journal->j_trans_barrier){.+.+}-{4:4}:
       down_read+0x58/0x2fc kernel/locking/rwsem.c:1524
       ocfs2_start_trans+0x3c4/0x71c fs/ocfs2/journal.c:350
       ocfs2_acl_set_mode+0x22c/0x794 fs/ocfs2/acl.c:174
       ocfs2_iop_set_acl+0x308/0x374 fs/ocfs2/acl.c:282
       set_posix_acl fs/posix_acl.c:954 [inline]
       vfs_set_acl+0x7a0/0xa24 fs/posix_acl.c:1133
       do_set_acl+0xe4/0x1ac fs/posix_acl.c:1278
       do_setxattr fs/xattr.c:633 [inline]
       file_setxattr+0x208/0x284 fs/xattr.c:646
       path_setxattrat+0x3b0/0x41c fs/xattr.c:711
       __do_sys_fsetxattr fs/xattr.c:761 [inline]
       __se_sys_fsetxattr fs/xattr.c:758 [inline]
       __arm64_sys_fsetxattr+0xc0/0xdc fs/xattr.c:758
       __invoke_syscall arch/arm64/kernel/syscall.c:35 [inline]
       invoke_syscall+0x98/0x2b8 arch/arm64/kernel/syscall.c:49
       el0_svc_common+0x130/0x23c arch/arm64/kernel/syscall.c:132
       do_el0_svc+0x48/0x58 arch/arm64/kernel/syscall.c:151
       el0_svc+0x54/0x168 arch/arm64/kernel/entry-common.c:744
       el0t_64_sync_handler+0x84/0x108 arch/arm64/kernel/entry-common.c:762
       el0t_64_sync+0x198/0x19c arch/arm64/kernel/entry.S:600

-> #2 (sb_internal#2){.+.+}-{0:0}:
       percpu_down_read include/linux/percpu-rwsem.h:51 [inline]
       __sb_start_write include/linux/fs.h:1725 [inline]
       sb_start_intwrite include/linux/fs.h:1908 [inline]
       ocfs2_start_trans+0x244/0x71c fs/ocfs2/journal.c:348
       ocfs2_xattr_set+0xdac/0x1448 fs/ocfs2/xattr.c:3643
       ocfs2_set_acl+0x410/0x4b4 fs/ocfs2/acl.c:254
       ocfs2_iop_set_acl+0x230/0x374 fs/ocfs2/acl.c:286
       set_posix_acl fs/posix_acl.c:954 [inline]
       vfs_set_acl+0x7a0/0xa24 fs/posix_acl.c:1133
       do_set_acl+0xe4/0x1ac fs/posix_acl.c:1278
       do_setxattr fs/xattr.c:633 [inline]
       file_setxattr+0x208/0x284 fs/xattr.c:646
       path_setxattrat+0x3b0/0x41c fs/xattr.c:711
       __do_sys_fsetxattr fs/xattr.c:761 [inline]
       __se_sys_fsetxattr fs/xattr.c:758 [inline]
       __arm64_sys_fsetxattr+0xc0/0xdc fs/xattr.c:758
       __invoke_syscall arch/arm64/kernel/syscall.c:35 [inline]
       invoke_syscall+0x98/0x2b8 arch/arm64/kernel/syscall.c:49
       el0_svc_common+0x130/0x23c arch/arm64/kernel/syscall.c:132
       do_el0_svc+0x48/0x58 arch/arm64/kernel/syscall.c:151
       el0_svc+0x54/0x168 arch/arm64/kernel/entry-common.c:744
       el0t_64_sync_handler+0x84/0x108 arch/arm64/kernel/entry-common.c:762
       el0t_64_sync+0x198/0x19c arch/arm64/kernel/entry.S:600

-> #1 (&ocfs2_sysfile_lock_key[args->fi_sysfile_type]#3){+.+.}-{4:4}:
       down_write+0x50/0xc0 kernel/locking/rwsem.c:1577
       inode_lock include/linux/fs.h:818 [inline]
       ocfs2_reserve_suballoc_bits+0x164/0x4254 fs/ocfs2/suballoc.c:786
       ocfs2_reserve_new_metadata_blocks+0x384/0x848 fs/ocfs2/suballoc.c:982
       ocfs2_init_xattr_set_ctxt+0x38c/0x95c fs/ocfs2/xattr.c:3277
       ocfs2_xattr_set+0xbe0/0x1448 fs/ocfs2/xattr.c:3634
       ocfs2_set_acl+0x410/0x4b4 fs/ocfs2/acl.c:254
       ocfs2_iop_set_acl+0x230/0x374 fs/ocfs2/acl.c:286
       set_posix_acl fs/posix_acl.c:954 [inline]
       vfs_set_acl+0x7a0/0xa24 fs/posix_acl.c:1133
       do_set_acl+0xe4/0x1ac fs/posix_acl.c:1278
       do_setxattr fs/xattr.c:633 [inline]
       file_setxattr+0x208/0x284 fs/xattr.c:646
       path_setxattrat+0x3b0/0x41c fs/xattr.c:711
       __do_sys_fsetxattr fs/xattr.c:761 [inline]
       __se_sys_fsetxattr fs/xattr.c:758 [inline]
       __arm64_sys_fsetxattr+0xc0/0xdc fs/xattr.c:758
       __invoke_syscall arch/arm64/kernel/syscall.c:35 [inline]
       invoke_syscall+0x98/0x2b8 arch/arm64/kernel/syscall.c:49
       el0_svc_common+0x130/0x23c arch/arm64/kernel/syscall.c:132
       do_el0_svc+0x48/0x58 arch/arm64/kernel/syscall.c:151
       el0_svc+0x54/0x168 arch/arm64/kernel/entry-common.c:744
       el0t_64_sync_handler+0x84/0x108 arch/arm64/kernel/entry-common.c:762
       el0t_64_sync+0x198/0x19c arch/arm64/kernel/entry.S:600

-> #0 (&oi->ip_xattr_sem){+.+.}-{4:4}:
       check_prev_add kernel/locking/lockdep.c:3161 [inline]
       check_prevs_add kernel/locking/lockdep.c:3280 [inline]
       validate_chain kernel/locking/lockdep.c:3904 [inline]
       __lock_acquire+0x34f0/0x7904 kernel/locking/lockdep.c:5226
       lock_acquire+0x23c/0x724 kernel/locking/lockdep.c:5849
       down_write+0x50/0xc0 kernel/locking/rwsem.c:1577
       ocfs2_xattr_set_handle+0x40c/0x824 fs/ocfs2/xattr.c:3501
       ocfs2_init_security_set+0xb4/0xd8 fs/ocfs2/xattr.c:7307
       ocfs2_symlink+0x1a34/0x24d0 fs/ocfs2/namei.c:2011
       vfs_symlink+0x138/0x28c fs/namei.c:4669
       do_symlinkat+0x1bc/0x45c fs/namei.c:4695
       __do_sys_symlinkat fs/namei.c:4711 [inline]
       __se_sys_symlinkat fs/namei.c:4708 [inline]
       __arm64_sys_symlinkat+0x9c/0xb4 fs/namei.c:4708
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

8 locks held by syz-executor418/6412:
 #0: ffff0000d6e26420 (sb_writers#8){.+.+}-{0:0}, at: mnt_want_write+0x44/0x9c fs/namespace.c:516
 #1: ffff0000de1589c0 (&type->i_mutex_dir_key#6/1){+.+.}-{4:4}, at: inode_lock_nested include/linux/fs.h:853 [inline]
 #1: ffff0000de1589c0 (&type->i_mutex_dir_key#6/1){+.+.}-{4:4}, at: filename_create+0x204/0x468 fs/namei.c:4080
 #2: ffff0000de2f09c0 (&ocfs2_sysfile_lock_key[args->fi_sysfile_type]#5){+.+.}-{4:4}, at: inode_lock include/linux/fs.h:818 [inline]
 #2: ffff0000de2f09c0 (&ocfs2_sysfile_lock_key[args->fi_sysfile_type]#5){+.+.}-{4:4}, at: ocfs2_reserve_suballoc_bits+0x164/0x4254 fs/ocfs2/suballoc.c:786
 #3: ffff0000de15ed80 (&ocfs2_sysfile_lock_key[args->fi_sysfile_type]#3){+.+.}-{4:4}, at: inode_lock include/linux/fs.h:818 [inline]
 #3: ffff0000de15ed80 (&ocfs2_sysfile_lock_key[args->fi_sysfile_type]#3){+.+.}-{4:4}, at: ocfs2_reserve_suballoc_bits+0x164/0x4254 fs/ocfs2/suballoc.c:786
 #4: ffff0000de2f2640 (&ocfs2_sysfile_lock_key[args->fi_sysfile_type]#6){+.+.}-{4:4}, at: inode_lock include/linux/fs.h:818 [inline]
 #4: ffff0000de2f2640 (&ocfs2_sysfile_lock_key[args->fi_sysfile_type]#6){+.+.}-{4:4}, at: ocfs2_reserve_local_alloc_bits+0x108/0x24cc fs/ocfs2/localalloc.c:636
 #5: ffff0000d6e26610 (sb_internal#2){.+.+}-{0:0}, at: ocfs2_symlink+0xc68/0x24d0 fs/ocfs2/namei.c:1928
 #6: ffff0000cda110e8 (&journal->j_trans_barrier){.+.+}-{4:4}, at: ocfs2_start_trans+0x3c4/0x71c fs/ocfs2/journal.c:350
 #7: ffff0000c2e18958 (jbd2_handle){.+.+}-{0:0}, at: start_this_handle+0xf0c/0x11c4 fs/jbd2/transaction.c:446

stack backtrace:
CPU: 1 UID: 0 PID: 6412 Comm: syz-executor418 Not tainted 6.13.0-rc7-syzkaller-g1950a0af2d55 #0
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
 ocfs2_xattr_set_handle+0x40c/0x824 fs/ocfs2/xattr.c:3501
 ocfs2_init_security_set+0xb4/0xd8 fs/ocfs2/xattr.c:7307
 ocfs2_symlink+0x1a34/0x24d0 fs/ocfs2/namei.c:2011
 vfs_symlink+0x138/0x28c fs/namei.c:4669
 do_symlinkat+0x1bc/0x45c fs/namei.c:4695
 __do_sys_symlinkat fs/namei.c:4711 [inline]
 __se_sys_symlinkat fs/namei.c:4708 [inline]
 __arm64_sys_symlinkat+0x9c/0xb4 fs/namei.c:4708
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
