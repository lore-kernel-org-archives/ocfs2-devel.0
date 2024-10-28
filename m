Received: from mail-il1-f198.google.com (mail-il1-f198.google.com [209.85.166.198])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5996212B17C
	for <ocfs2-devel@lists.linux.dev>; Mon, 28 Oct 2024 00:59:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.198
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730077166; cv=none; b=ipdOOFjsUJjmCNCyh/RacTppZepGJ4lUZ1gD4QlLZFFbKE80aTt0xG6qEdz5mLcVLEAFkzXojF5O5JwjkwjrA4BeuVRSI1rR5/pzIu+VJJ/MDtCTbZf/mEVz2xYh/vPz9RtpLxWE54t/vK0ubVpMJnT+2zzUa590SOtLG/kQsxk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730077166; c=relaxed/simple;
	bh=ll6AO+1U598CesaTzlrqzSFAMGLVu4hyBengedpjb2o=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=llFbM3SoePwuk4SxGtV0mi8khoBsLdf1MRgTzZ3JyCoJuqYp3Knvd0Vgx9mdmcDEKuk6yRTl+Cv4m/KGmqA+vxLN3ppoYqA0ZroVxcc492+yKa1h/eLD64fFMsSslrJ20d2g+lMfuaIMeIstf2k+WB864IBKTVSPdJvMzqKdyNo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.198
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f198.google.com with SMTP id e9e14a558f8ab-3a4daf7174eso35271145ab.3
        for <ocfs2-devel@lists.linux.dev>; Sun, 27 Oct 2024 17:59:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730077163; x=1730681963;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=0Z1XwpGzXT+npO7AJdaCsfoc98A4ogh4XhbM7Qygs6g=;
        b=G8xGFh7JJntXtKS2r9sQ+4mE4WeIuklBxFZZ6xSEOsVkBWjGGG0VguavXJAH9lrojf
         V+qFw9LN9NJOkK9X+gRisLYBO9tu5OinPcfmFT4p9MvBbt2ostrKCh2XaiLasBsjjpRy
         kilh93U6RGDDd92hgGDEj8qnmTBSzZmkj0m6H95nWpRhzO4pBBjOGRC035PUwPZOUNl3
         YWbMThUSAQT4z03LM8n6WVWYsgIBVn9oR047V82Kl8wGt6bqUGlXK3LcWinp1gB0HAXp
         dDNGZlNP/TCIcH2waGIfRDR0ghFzOXVXgk9Akc+Xqvzsjgvn77UMl2KUxpIpsZl7ZaCv
         fVIA==
X-Forwarded-Encrypted: i=1; AJvYcCVMJ+HK7nQkVNj+Duv7DpKFlqF2TzYQB1P6LOQtaLsgRoYRmxMc2kLo5CY3oq3hkmCKuIVLxA7IJ5iWrw==@lists.linux.dev
X-Gm-Message-State: AOJu0YzEWIu9MmYtc3HgkSag80WOr0s5lRLnIDM70UmOvJ2Kk6yLsMxK
	3OcnxO9lVLR/z/BrWAse+3+sVVYzohUdyS9ZfMXAlLFpNnlSF8fAMnagGgIB99eOlxNvup4FWax
	LiPnWpA1y73DKQ4S5RR403X94Y3qOTdLo14ozxhwLbG+f2EhjhdZURWQ=
X-Google-Smtp-Source: AGHT+IEaDA2kTl1TJ8C1ZYXSLdUr5w33sMZ58lJsnLMnB9NafuQheBREbz2a9Vqd5PWGV1CFcqXe198hqszKr74yU+c2z0hPsvky
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1e0b:b0:3a4:eccc:aa5c with SMTP id
 e9e14a558f8ab-3a4ed27a9aemr56407575ab.5.1730077163529; Sun, 27 Oct 2024
 17:59:23 -0700 (PDT)
Date: Sun, 27 Oct 2024 17:59:23 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <671ee1eb.050a0220.2b8c0f.01ee.GAE@google.com>
Subject: [syzbot] [ocfs2?] possible deadlock in ocfs2_remove_btree_range
From: syzbot <syzbot+f459794c08272fdcd5b6@syzkaller.appspotmail.com>
To: jlbec@evilplan.org, joseph.qi@linux.alibaba.com, 
	linux-kernel@vger.kernel.org, mark@fasheh.com, ocfs2-devel@lists.linux.dev, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    c2ee9f594da8 KVM: selftests: Fix build on on non-x86 archi..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=112548a7980000
kernel config:  https://syzkaller.appspot.com/x/.config?x=41330fd2db03893d
dashboard link: https://syzkaller.appspot.com/bug?extid=f459794c08272fdcd5b6
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/d116f71ad0eb/disk-c2ee9f59.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/bdd6f545b105/vmlinux-c2ee9f59.xz
kernel image: https://storage.googleapis.com/syzbot-assets/0d26b05e3d7c/bzImage-c2ee9f59.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+f459794c08272fdcd5b6@syzkaller.appspotmail.com

======================================================
WARNING: possible circular locking dependency detected
6.12.0-rc4-syzkaller-00047-gc2ee9f594da8 #0 Not tainted
------------------------------------------------------
syz.4.35/5492 is trying to acquire lock:
ffff888025bb0610 (sb_internal#2){.+.+}-{0:0}, at: ocfs2_remove_btree_range+0x8e4/0x1860 fs/ocfs2/alloc.c:5752

but task is already holding lock:
ffff88805ecb5100 (&ocfs2_sysfile_lock_key[args->fi_sysfile_type]#6){+.+.}-{3:3}, at: inode_lock include/linux/fs.h:815 [inline]
ffff88805ecb5100 (&ocfs2_sysfile_lock_key[args->fi_sysfile_type]#6){+.+.}-{3:3}, at: ocfs2_remove_btree_range+0x737/0x1860 fs/ocfs2/alloc.c:5742

which lock already depends on the new lock.


the existing dependency chain (in reverse order) is:

-> #4 (&ocfs2_sysfile_lock_key[args->fi_sysfile_type]#6){+.+.}-{3:3}:
       lock_acquire+0x1ed/0x550 kernel/locking/lockdep.c:5825
       down_write+0x99/0x220 kernel/locking/rwsem.c:1577
       inode_lock include/linux/fs.h:815 [inline]
       ocfs2_xattr_set+0xe9e/0x1930 fs/ocfs2/xattr.c:3623
       __vfs_setxattr+0x468/0x4a0 fs/xattr.c:200
       __vfs_setxattr_noperm+0x12e/0x660 fs/xattr.c:234
       vfs_setxattr+0x221/0x430 fs/xattr.c:321
       ovl_do_setxattr fs/overlayfs/overlayfs.h:314 [inline]
       ovl_setxattr fs/overlayfs/overlayfs.h:326 [inline]
       ovl_make_workdir fs/overlayfs/super.c:696 [inline]
       ovl_get_workdir+0xd90/0x1920 fs/overlayfs/super.c:808
       ovl_fill_super+0x12a8/0x3560 fs/overlayfs/super.c:1376
       vfs_get_super fs/super.c:1280 [inline]
       get_tree_nodev+0xb7/0x140 fs/super.c:1299
       vfs_get_tree+0x90/0x2b0 fs/super.c:1800
       do_new_mount+0x2be/0xb40 fs/namespace.c:3507
       do_mount fs/namespace.c:3847 [inline]
       __do_sys_mount fs/namespace.c:4057 [inline]
       __se_sys_mount+0x2d6/0x3c0 fs/namespace.c:4034
       do_syscall_x64 arch/x86/entry/common.c:52 [inline]
       do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
       entry_SYSCALL_64_after_hwframe+0x77/0x7f

-> #3 (&oi->ip_xattr_sem){++++}-{3:3}:
       lock_acquire+0x1ed/0x550 kernel/locking/lockdep.c:5825
       down_read+0xb1/0xa40 kernel/locking/rwsem.c:1524
       ocfs2_init_acl+0x397/0x930 fs/ocfs2/acl.c:366
       ocfs2_mknod+0x1c05/0x2b40 fs/ocfs2/namei.c:408
       ocfs2_create+0x1ab/0x480 fs/ocfs2/namei.c:672
       lookup_open fs/namei.c:3595 [inline]
       open_last_lookups fs/namei.c:3694 [inline]
       path_openat+0x1c03/0x3590 fs/namei.c:3930
       do_filp_open+0x235/0x490 fs/namei.c:3960
       do_sys_openat2+0x13e/0x1d0 fs/open.c:1415
       do_sys_open fs/open.c:1430 [inline]
       __do_sys_creat fs/open.c:1508 [inline]
       __se_sys_creat fs/open.c:1502 [inline]
       __x64_sys_creat+0x123/0x170 fs/open.c:1502
       do_syscall_x64 arch/x86/entry/common.c:52 [inline]
       do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
       entry_SYSCALL_64_after_hwframe+0x77/0x7f

-> #2 (jbd2_handle){++++}-{0:0}:
       lock_acquire+0x1ed/0x550 kernel/locking/lockdep.c:5825
       start_this_handle+0x1eb4/0x2110 fs/jbd2/transaction.c:448
       jbd2__journal_start+0x2da/0x5d0 fs/jbd2/transaction.c:505
       jbd2_journal_start+0x29/0x40 fs/jbd2/transaction.c:544
       ocfs2_start_trans+0x3c9/0x700 fs/ocfs2/journal.c:352
       ocfs2_block_group_alloc fs/ocfs2/suballoc.c:685 [inline]
       ocfs2_reserve_suballoc_bits+0x9f6/0x4eb0 fs/ocfs2/suballoc.c:832
       ocfs2_reserve_new_metadata_blocks+0x41c/0x9c0 fs/ocfs2/suballoc.c:982
       ocfs2_mknod+0x143a/0x2b40 fs/ocfs2/namei.c:345
       ocfs2_create+0x1ab/0x480 fs/ocfs2/namei.c:672
       lookup_open fs/namei.c:3595 [inline]
       open_last_lookups fs/namei.c:3694 [inline]
       path_openat+0x1c03/0x3590 fs/namei.c:3930
       do_filp_open+0x235/0x490 fs/namei.c:3960
       do_sys_openat2+0x13e/0x1d0 fs/open.c:1415
       do_sys_open fs/open.c:1430 [inline]
       __do_sys_creat fs/open.c:1508 [inline]
       __se_sys_creat fs/open.c:1502 [inline]
       __x64_sys_creat+0x123/0x170 fs/open.c:1502
       do_syscall_x64 arch/x86/entry/common.c:52 [inline]
       do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
       entry_SYSCALL_64_after_hwframe+0x77/0x7f

-> #1 (&journal->j_trans_barrier){.+.+}-{3:3}:
       lock_acquire+0x1ed/0x550 kernel/locking/lockdep.c:5825
       down_read+0xb1/0xa40 kernel/locking/rwsem.c:1524
       ocfs2_start_trans+0x3be/0x700 fs/ocfs2/journal.c:350
       ocfs2_block_group_alloc fs/ocfs2/suballoc.c:685 [inline]
       ocfs2_reserve_suballoc_bits+0x9f6/0x4eb0 fs/ocfs2/suballoc.c:832
       ocfs2_reserve_new_metadata_blocks+0x41c/0x9c0 fs/ocfs2/suballoc.c:982
       ocfs2_mknod+0x143a/0x2b40 fs/ocfs2/namei.c:345
       ocfs2_create+0x1ab/0x480 fs/ocfs2/namei.c:672
       lookup_open fs/namei.c:3595 [inline]
       open_last_lookups fs/namei.c:3694 [inline]
       path_openat+0x1c03/0x3590 fs/namei.c:3930
       do_filp_open+0x235/0x490 fs/namei.c:3960
       do_sys_openat2+0x13e/0x1d0 fs/open.c:1415
       do_sys_open fs/open.c:1430 [inline]
       __do_sys_creat fs/open.c:1508 [inline]
       __se_sys_creat fs/open.c:1502 [inline]
       __x64_sys_creat+0x123/0x170 fs/open.c:1502
       do_syscall_x64 arch/x86/entry/common.c:52 [inline]
       do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
       entry_SYSCALL_64_after_hwframe+0x77/0x7f

-> #0 (sb_internal#2){.+.+}-{0:0}:
       check_prev_add kernel/locking/lockdep.c:3161 [inline]
       check_prevs_add kernel/locking/lockdep.c:3280 [inline]
       validate_chain+0x18ef/0x5920 kernel/locking/lockdep.c:3904
       __lock_acquire+0x1384/0x2050 kernel/locking/lockdep.c:5202
       lock_acquire+0x1ed/0x550 kernel/locking/lockdep.c:5825
       percpu_down_read include/linux/percpu-rwsem.h:51 [inline]
       __sb_start_write include/linux/fs.h:1716 [inline]
       sb_start_intwrite include/linux/fs.h:1899 [inline]
       ocfs2_start_trans+0x2b9/0x700 fs/ocfs2/journal.c:348
       ocfs2_remove_btree_range+0x8e4/0x1860 fs/ocfs2/alloc.c:5752
       ocfs2_remove_inode_range+0x166d/0x2690 fs/ocfs2/file.c:1899
       __ocfs2_change_file_space+0x8e4/0xfd0 fs/ocfs2/file.c:2020
       ocfs2_fallocate+0x2e4/0x350 fs/ocfs2/file.c:2130
       vfs_fallocate+0x569/0x6e0 fs/open.c:333
       do_vfs_ioctl+0x2583/0x2e40 fs/ioctl.c:886
       __do_sys_ioctl fs/ioctl.c:905 [inline]
       __se_sys_ioctl+0x81/0x170 fs/ioctl.c:893
       do_syscall_x64 arch/x86/entry/common.c:52 [inline]
       do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
       entry_SYSCALL_64_after_hwframe+0x77/0x7f

other info that might help us debug this:

Chain exists of:
  sb_internal#2 --> &oi->ip_xattr_sem --> &ocfs2_sysfile_lock_key[args->fi_sysfile_type]#6

 Possible unsafe locking scenario:

       CPU0                    CPU1
       ----                    ----
  lock(&ocfs2_sysfile_lock_key[args->fi_sysfile_type]#6);
                               lock(&oi->ip_xattr_sem);
                               lock(&ocfs2_sysfile_lock_key[args->fi_sysfile_type]#6);
  rlock(sb_internal#2);

 *** DEADLOCK ***

4 locks held by syz.4.35/5492:
 #0: ffff888025bb0420 (sb_writers#16){.+.+}-{0:0}, at: file_start_write include/linux/fs.h:2931 [inline]
 #0: ffff888025bb0420 (sb_writers#16){.+.+}-{0:0}, at: vfs_fallocate+0x4fe/0x6e0 fs/open.c:332
 #1: ffff88805ecb6d80 (&sb->s_type->i_mutex_key#23){++++}-{3:3}, at: inode_lock include/linux/fs.h:815 [inline]
 #1: ffff88805ecb6d80 (&sb->s_type->i_mutex_key#23){++++}-{3:3}, at: __ocfs2_change_file_space+0x201/0xfd0 fs/ocfs2/file.c:1941
 #2: ffff88805ecb6a20 (&oi->ip_alloc_sem){++++}-{3:3}, at: __ocfs2_change_file_space+0x7ff/0xfd0 fs/ocfs2/file.c:2007
 #3: ffff88805ecb5100 (&ocfs2_sysfile_lock_key[args->fi_sysfile_type]#6){+.+.}-{3:3}, at: inode_lock include/linux/fs.h:815 [inline]
 #3: ffff88805ecb5100 (&ocfs2_sysfile_lock_key[args->fi_sysfile_type]#6){+.+.}-{3:3}, at: ocfs2_remove_btree_range+0x737/0x1860 fs/ocfs2/alloc.c:5742

stack backtrace:
CPU: 1 UID: 0 PID: 5492 Comm: syz.4.35 Not tainted 6.12.0-rc4-syzkaller-00047-gc2ee9f594da8 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 09/13/2024
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:94 [inline]
 dump_stack_lvl+0x241/0x360 lib/dump_stack.c:120
 print_circular_bug+0x13a/0x1b0 kernel/locking/lockdep.c:2074
 check_noncircular+0x36a/0x4a0 kernel/locking/lockdep.c:2206
 check_prev_add kernel/locking/lockdep.c:3161 [inline]
 check_prevs_add kernel/locking/lockdep.c:3280 [inline]
 validate_chain+0x18ef/0x5920 kernel/locking/lockdep.c:3904
 __lock_acquire+0x1384/0x2050 kernel/locking/lockdep.c:5202
 lock_acquire+0x1ed/0x550 kernel/locking/lockdep.c:5825
 percpu_down_read include/linux/percpu-rwsem.h:51 [inline]
 __sb_start_write include/linux/fs.h:1716 [inline]
 sb_start_intwrite include/linux/fs.h:1899 [inline]
 ocfs2_start_trans+0x2b9/0x700 fs/ocfs2/journal.c:348
 ocfs2_remove_btree_range+0x8e4/0x1860 fs/ocfs2/alloc.c:5752
 ocfs2_remove_inode_range+0x166d/0x2690 fs/ocfs2/file.c:1899
 __ocfs2_change_file_space+0x8e4/0xfd0 fs/ocfs2/file.c:2020
 ocfs2_fallocate+0x2e4/0x350 fs/ocfs2/file.c:2130
 vfs_fallocate+0x569/0x6e0 fs/open.c:333
 do_vfs_ioctl+0x2583/0x2e40 fs/ioctl.c:886
 __do_sys_ioctl fs/ioctl.c:905 [inline]
 __se_sys_ioctl+0x81/0x170 fs/ioctl.c:893
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7fe59c97dff9
Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 a8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007fe59d7a1038 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
RAX: ffffffffffffffda RBX: 00007fe59cb36058 RCX: 00007fe59c97dff9
RDX: 00000000200000c0 RSI: 0000000040305829 RDI: 0000000000000005
RBP: 00007fe59c9f0296 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 0000000000000000 R14: 00007fe59cb36058 R15: 00007ffeff1e25a8
 </TASK>


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
