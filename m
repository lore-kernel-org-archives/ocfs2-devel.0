Received: from mail-oo1-f78.google.com (mail-oo1-f78.google.com [209.85.161.78])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C698724A046
	for <ocfs2-devel@lists.linux.dev>; Fri,  5 Dec 2025 21:17:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.78
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764969451; cv=none; b=OWdnk4prf2r1xtZMRKD0QrCqW+4EhnUjnsvPyBFUC60QFA6zDk7Vh0oLzqywBsyWdyLdJpMPGNr4mFb2XHPSR1KDLqasp7jtFJckoLWZCnbMsGZ/2a9tCVJnMjrTzFtQi0p/0W1wSFs+3J9vjIm9itvoz6PZf1IGxajVVwbsCV0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764969451; c=relaxed/simple;
	bh=eSSgVT+poFDI1eJvRMR2bKY6JA571cRPaNwT6nbOiYA=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=ArjLebcW7VOYj/QIeL+liHwVmC0LoKF7C5dkp47Qdj8ZQattGIRAZm2+oAZireDPRgnXc6LgCFM/2qAZUhDESuFmHu5BfabubaFA6Ku7pjkbS1co6LN+gOVA6glHRTdtv+ustssaGaeJ5YBXGha/9Lic3rtkT0U/dMKZ6293kPo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.161.78
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oo1-f78.google.com with SMTP id 006d021491bc7-656ceb0c967so1854074eaf.1
        for <ocfs2-devel@lists.linux.dev>; Fri, 05 Dec 2025 13:17:29 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764969449; x=1765574249;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=SMRjXmL/qzNU788d3dQbcMw5zDadOsJpZbrHucS3ONw=;
        b=G2ANBLEaltnP2Ko6sDX51WUSKCMZtPyx6NEopvmOQWkKVtoI22UjaS9jFmtLU1HNkp
         T30GvXYHBk75Gp5r8sj8po5OCbo4exdFO/DhSM6nbc+ongrXSC/z8NLdE5BSFPHURATS
         WYUj0qsL2BAPF5R1DgAltsY6Vpt/RvxjN0KkjjUsI7YrvDBwezpsYj845uDnNAsI+foi
         2dHo0N0xgTHGxdtJLUggoe8Z+MiG+FL/UmcK4RLL2rnqjZ+1bHnksw286Yw/heb36ioC
         G87D6xW5jz570yeJwPBgDWubwaN/jhcwFLlS2nRJe3Cq5KTp8TzM0cx6aD6yJ26l4fjI
         1slg==
X-Forwarded-Encrypted: i=1; AJvYcCUng5DULnuq2cgvy7jBIy680m0oX6cSFcrxaG8Y+2nIWKyKijXGcHGsC9Ufvl8xGc0d6Q+mk/NqoVpHhg==@lists.linux.dev
X-Gm-Message-State: AOJu0YzDX+MyM2XCzNr2FuOF3s32bzq7DLMLHfI4SwWgJsuJo8f++yse
	zcZKSp8pmbyZFz4wLNqg/x67UI4gbxU+pX/DhxfTGAHhqLKoZLHL3JBoyUt+dn/keQWKdqiUJs5
	9EmZmZ+FJpkF3CfpA9/El1gs2iTVMD1HpXEPG/tQhVVT3hEUMYL0ql1bM7qk=
X-Google-Smtp-Source: AGHT+IHo0FhsLsN4EutFD/YZDvrBKVEh1Q4IFuO7YAuLNXN9GicHZ/Ao/9xVHJz/DuLuC0vzeFarOkIlDoT8S4y+OmThc8b4210/
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6820:4b10:b0:659:9a49:8df5 with SMTP id
 006d021491bc7-6599a96c3c6mr253934eaf.55.1764969448793; Fri, 05 Dec 2025
 13:17:28 -0800 (PST)
Date: Fri, 05 Dec 2025 13:17:28 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <69334be8.a70a0220.243dc6.0018.GAE@google.com>
Subject: [syzbot] [ocfs2?] possible deadlock in ocfs2_xattr_ibody_set (2)
From: syzbot <syzbot+05047ffad2ec290b9480@syzkaller.appspotmail.com>
To: jlbec@evilplan.org, joseph.qi@linux.alibaba.com, 
	linux-kernel@vger.kernel.org, mark@fasheh.com, ocfs2-devel@lists.linux.dev, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    7d0a66e4bb90 Linux 6.18
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=10ab2192580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=a1db0fea040c2a9f
dashboard link: https://syzkaller.appspot.com/bug?extid=05047ffad2ec290b9480
compiler:       Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~exp1~20250708183702.136), Debian LLD 20.1.8

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/d900f083ada3/non_bootable_disk-7d0a66e4.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/d01367711788/vmlinux-7d0a66e4.xz
kernel image: https://storage.googleapis.com/syzbot-assets/5875f3299406/bzImage-7d0a66e4.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+05047ffad2ec290b9480@syzkaller.appspotmail.com

overlayfs: upper fs does not support tmpfile.
overlayfs: upper fs does not support RENAME_WHITEOUT.
======================================================
WARNING: possible circular locking dependency detected
syzkaller #0 Not tainted
------------------------------------------------------
syz.0.0/5322 is trying to acquire lock:
ffff888040028660 (&oi->ip_alloc_sem){++++}-{4:4}, at: ocfs2_xattr_ibody_set+0x12c/0xb90 fs/ocfs2/xattr.c:2783

but task is already holding lock:
ffff8880110cc950 (jbd2_handle){++++}-{0:0}, at: start_this_handle+0x1f87/0x21c0 fs/jbd2/transaction.c:444

which lock already depends on the new lock.


the existing dependency chain (in reverse order) is:

-> #3 (jbd2_handle){++++}-{0:0}:
       lock_acquire+0x120/0x360 kernel/locking/lockdep.c:5868
       start_this_handle+0x1fa7/0x21c0 fs/jbd2/transaction.c:444
       jbd2__journal_start+0x2c1/0x5b0 fs/jbd2/transaction.c:501
       jbd2_journal_start+0x2a/0x40 fs/jbd2/transaction.c:540
       ocfs2_start_trans+0x376/0x6d0 fs/ocfs2/journal.c:374
       ocfs2_mknod+0xe93/0x2050 fs/ocfs2/namei.c:364
       ocfs2_create+0x1a5/0x440 fs/ocfs2/namei.c:676
       lookup_open fs/namei.c:3796 [inline]
       open_last_lookups fs/namei.c:3895 [inline]
       path_openat+0x14f4/0x3830 fs/namei.c:4131
       do_filp_open+0x1fa/0x410 fs/namei.c:4161
       do_sys_openat2+0x121/0x1c0 fs/open.c:1437
       do_sys_open fs/open.c:1452 [inline]
       __do_sys_openat fs/open.c:1468 [inline]
       __se_sys_openat fs/open.c:1463 [inline]
       __x64_sys_openat+0x138/0x170 fs/open.c:1463
       do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
       do_syscall_64+0xfa/0xfa0 arch/x86/entry/syscall_64.c:94
       entry_SYSCALL_64_after_hwframe+0x77/0x7f

-> #2 (&journal->j_trans_barrier){.+.+}-{4:4}:
       lock_acquire+0x120/0x360 kernel/locking/lockdep.c:5868
       down_read+0x46/0x2e0 kernel/locking/rwsem.c:1537
       ocfs2_start_trans+0x36a/0x6d0 fs/ocfs2/journal.c:372
       ocfs2_mknod+0xe93/0x2050 fs/ocfs2/namei.c:364
       ocfs2_create+0x1a5/0x440 fs/ocfs2/namei.c:676
       lookup_open fs/namei.c:3796 [inline]
       open_last_lookups fs/namei.c:3895 [inline]
       path_openat+0x14f4/0x3830 fs/namei.c:4131
       do_filp_open+0x1fa/0x410 fs/namei.c:4161
       do_sys_openat2+0x121/0x1c0 fs/open.c:1437
       do_sys_open fs/open.c:1452 [inline]
       __do_sys_openat fs/open.c:1468 [inline]
       __se_sys_openat fs/open.c:1463 [inline]
       __x64_sys_openat+0x138/0x170 fs/open.c:1463
       do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
       do_syscall_64+0xfa/0xfa0 arch/x86/entry/syscall_64.c:94
       entry_SYSCALL_64_after_hwframe+0x77/0x7f

-> #1 (sb_internal#2){.+.+}-{0:0}:
       reacquire_held_locks+0x127/0x1d0 kernel/locking/lockdep.c:5385
       __lock_release kernel/locking/lockdep.c:5574 [inline]
       lock_release+0x1b4/0x3e0 kernel/locking/lockdep.c:5889
       up_write+0x2d/0x420 kernel/locking/rwsem.c:1642
       inode_unlock include/linux/fs.h:990 [inline]
       ocfs2_free_ac_resource fs/ocfs2/suballoc.c:130 [inline]
       ocfs2_free_alloc_context+0x97/0x1a0 fs/ocfs2/suballoc.c:144
       ocfs2_write_begin_nolock+0x4296/0x4340 fs/ocfs2/aops.c:1804
       ocfs2_write_begin+0x1bb/0x310 fs/ocfs2/aops.c:1884
       generic_perform_write+0x2c5/0x900 mm/filemap.c:4255
       ocfs2_file_write_iter+0x157a/0x1d10 fs/ocfs2/file.c:2469
       new_sync_write fs/read_write.c:593 [inline]
       vfs_write+0x5c9/0xb30 fs/read_write.c:686
       ksys_write+0x145/0x250 fs/read_write.c:738
       do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
       do_syscall_64+0xfa/0xfa0 arch/x86/entry/syscall_64.c:94
       entry_SYSCALL_64_after_hwframe+0x77/0x7f

-> #0 (&oi->ip_alloc_sem){++++}-{4:4}:
       check_prev_add kernel/locking/lockdep.c:3165 [inline]
       check_prevs_add kernel/locking/lockdep.c:3284 [inline]
       validate_chain+0xb9b/0x2140 kernel/locking/lockdep.c:3908
       __lock_acquire+0xab9/0xd20 kernel/locking/lockdep.c:5237
       lock_acquire+0x120/0x360 kernel/locking/lockdep.c:5868
       down_write+0x96/0x1f0 kernel/locking/rwsem.c:1590
       ocfs2_xattr_ibody_set+0x12c/0xb90 fs/ocfs2/xattr.c:2783
       __ocfs2_xattr_set_handle+0xf4/0xf20 fs/ocfs2/xattr.c:3322
       ocfs2_xattr_set+0xde8/0x11f0 fs/ocfs2/xattr.c:3650
       __vfs_setxattr+0x43c/0x480 fs/xattr.c:200
       __vfs_setxattr_noperm+0x12d/0x660 fs/xattr.c:234
       vfs_setxattr+0x16b/0x2f0 fs/xattr.c:321
       ovl_do_setxattr fs/overlayfs/overlayfs.h:317 [inline]
       ovl_setxattr fs/overlayfs/overlayfs.h:329 [inline]
       ovl_make_workdir fs/overlayfs/super.c:725 [inline]
       ovl_get_workdir+0xbfa/0x17b0 fs/overlayfs/super.c:837
       ovl_fill_super+0x154a/0x3da0 fs/overlayfs/super.c:1468
       vfs_get_super fs/super.c:1331 [inline]
       get_tree_nodev+0xbb/0x150 fs/super.c:1350
       vfs_get_tree+0x92/0x2b0 fs/super.c:1758
       fc_mount fs/namespace.c:1199 [inline]
       do_new_mount_fc fs/namespace.c:3642 [inline]
       do_new_mount+0x302/0xa10 fs/namespace.c:3718
       do_mount fs/namespace.c:4041 [inline]
       __do_sys_mount fs/namespace.c:4229 [inline]
       __se_sys_mount+0x313/0x410 fs/namespace.c:4206
       do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
       do_syscall_64+0xfa/0xfa0 arch/x86/entry/syscall_64.c:94
       entry_SYSCALL_64_after_hwframe+0x77/0x7f

other info that might help us debug this:

Chain exists of:
  &oi->ip_alloc_sem --> &journal->j_trans_barrier --> jbd2_handle

 Possible unsafe locking scenario:

       CPU0                    CPU1
       ----                    ----
  rlock(jbd2_handle);
                               lock(&journal->j_trans_barrier);
                               lock(jbd2_handle);
  lock(&oi->ip_alloc_sem);

 *** DEADLOCK ***

8 locks held by syz.0.0/5322:
 #0: ffff88803348e0e0 (&type->s_umount_key#52/1){+.+.}-{4:4}, at: alloc_super+0x1bb/0x930 fs/super.c:344
 #1: ffff888000fbe420 (sb_writers#12){.+.+}-{0:0}, at: mnt_want_write+0x41/0x90 fs/namespace.c:499
 #2: ffff8880400289c0 (&sb->s_type->i_mutex_key#20){++++}-{4:4}, at: inode_lock include/linux/fs.h:980 [inline]
 #2: ffff8880400289c0 (&sb->s_type->i_mutex_key#20){++++}-{4:4}, at: vfs_setxattr+0x144/0x2f0 fs/xattr.c:320
 #3: ffff8880400286f8 (&oi->ip_xattr_sem){++++}-{4:4}, at: ocfs2_xattr_set+0x40f/0x11f0 fs/ocfs2/xattr.c:3583
 #4: ffff888041ed6d80 (&ocfs2_sysfile_lock_key[EXTENT_ALLOC_SYSTEM_INODE]){+.+.}-{4:4}, at: inode_lock include/linux/fs.h:980 [inline]
 #4: ffff888041ed6d80 (&ocfs2_sysfile_lock_key[EXTENT_ALLOC_SYSTEM_INODE]){+.+.}-{4:4}, at: ocfs2_reserve_suballoc_bits+0x15e/0x4640 fs/ocfs2/suballoc.c:788
 #5: ffff888000fbe610 (sb_internal#2){.+.+}-{0:0}, at: ocfs2_xattr_set+0xd69/0x11f0 fs/ocfs2/xattr.c:3643
 #6: ffff888032c6fce8 (&journal->j_trans_barrier){.+.+}-{4:4}, at: ocfs2_start_trans+0x36a/0x6d0 fs/ocfs2/journal.c:372
 #7: ffff8880110cc950 (jbd2_handle){++++}-{0:0}, at: start_this_handle+0x1f87/0x21c0 fs/jbd2/transaction.c:444

stack backtrace:
CPU: 0 UID: 0 PID: 5322 Comm: syz.0.0 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2~bpo12+1 04/01/2014
Call Trace:
 <TASK>
 dump_stack_lvl+0x189/0x250 lib/dump_stack.c:120
 print_circular_bug+0x2ee/0x310 kernel/locking/lockdep.c:2043
 check_noncircular+0x134/0x160 kernel/locking/lockdep.c:2175
 check_prev_add kernel/locking/lockdep.c:3165 [inline]
 check_prevs_add kernel/locking/lockdep.c:3284 [inline]
 validate_chain+0xb9b/0x2140 kernel/locking/lockdep.c:3908
 __lock_acquire+0xab9/0xd20 kernel/locking/lockdep.c:5237
 lock_acquire+0x120/0x360 kernel/locking/lockdep.c:5868
 down_write+0x96/0x1f0 kernel/locking/rwsem.c:1590
 ocfs2_xattr_ibody_set+0x12c/0xb90 fs/ocfs2/xattr.c:2783
 __ocfs2_xattr_set_handle+0xf4/0xf20 fs/ocfs2/xattr.c:3322
 ocfs2_xattr_set+0xde8/0x11f0 fs/ocfs2/xattr.c:3650
 __vfs_setxattr+0x43c/0x480 fs/xattr.c:200
 __vfs_setxattr_noperm+0x12d/0x660 fs/xattr.c:234
 vfs_setxattr+0x16b/0x2f0 fs/xattr.c:321
 ovl_do_setxattr fs/overlayfs/overlayfs.h:317 [inline]
 ovl_setxattr fs/overlayfs/overlayfs.h:329 [inline]
 ovl_make_workdir fs/overlayfs/super.c:725 [inline]
 ovl_get_workdir+0xbfa/0x17b0 fs/overlayfs/super.c:837
 ovl_fill_super+0x154a/0x3da0 fs/overlayfs/super.c:1468
 vfs_get_super fs/super.c:1331 [inline]
 get_tree_nodev+0xbb/0x150 fs/super.c:1350
 vfs_get_tree+0x92/0x2b0 fs/super.c:1758
 fc_mount fs/namespace.c:1199 [inline]
 do_new_mount_fc fs/namespace.c:3642 [inline]
 do_new_mount+0x302/0xa10 fs/namespace.c:3718
 do_mount fs/namespace.c:4041 [inline]
 __do_sys_mount fs/namespace.c:4229 [inline]
 __se_sys_mount+0x313/0x410 fs/namespace.c:4206
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0xfa/0xfa0 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f790f18f7c9
Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 a8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f790b5d4038 EFLAGS: 00000246 ORIG_RAX: 00000000000000a5
RAX: ffffffffffffffda RBX: 00007f790f3e6090 RCX: 00007f790f18f7c9
RDX: 0000200000000000 RSI: 0000200000000100 RDI: 0000000000000000
RBP: 00007f790f213f91 R08: 0000200000000240 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007f790f3e6128 R14: 00007f790f3e6090 R15: 00007ffdfd095238
 </TASK>
overlayfs: upper fs missing required features.


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
