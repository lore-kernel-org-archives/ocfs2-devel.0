Received: from mail-io1-f77.google.com (mail-io1-f77.google.com [209.85.166.77])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC58B70821
	for <ocfs2-devel@lists.linux.dev>; Sun,  1 Dec 2024 15:11:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.77
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733065890; cv=none; b=VIHTJgHWGP5RacprS5RXRQVdj86SNPkhRf5yASyEI+oA7/+zUSHbotYcymw/IBsjLaTTfOhiToM6zvfdBWQBvyz8mhVhNjpKbcoT8YKdHX0GmmpfWnbU6yH9yQYwvEnUrgKN0ZEKDRT/3hp5OG8vt+xLu72icGDTOkpRQvjYIkU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733065890; c=relaxed/simple;
	bh=7LgfWzu/P6xTKOFg/einuJWbMME7j5fMNdqJ9p0JOA8=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=b6xAb03iL363ncYJFbgKa/gf/r+Z2oclnKY6qwKYJrK2kTlspwIHmn3W02Aj5gmBS9Og/DGsQ3THWMae23v83aie/xrbjdY9X58uvFVeS9Wqtky3KTYIcsA2QLnRUiON5Z6qOoyyGBx54EsBSPt0GqUcm8G8F8YQgt3TpCGY5Wg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.77
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-io1-f77.google.com with SMTP id ca18e2360f4ac-841896ec108so345366439f.1
        for <ocfs2-devel@lists.linux.dev>; Sun, 01 Dec 2024 07:11:28 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733065888; x=1733670688;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=anlVY+yVLn+ojDOgt5liZFf+bjNBKilcTUFDfd+hgHI=;
        b=rt3wGbbJQDfEWEZcO/cGBYGivDBxXMiFeViYaZQE0RnVumXvLrFOFJ2ADkrCQ4UnjP
         4U605+XuOrLmvNbzOKZPvyxFSces6ooV8L15YsXIV+LPDsTTzSmcyiQ5U1QDzcmq9jGR
         EOaEg+03QWNvVqmB8meesJn83zOyx5+bf98RNQ7rJa2znqM88M+Z1fTyL7Kg+t/FNZLl
         yX71M0zygKrPuUxN+xHehuriPkQbZk9ZE2sFviex+JL8fR8ajBJ0710CvQiv7G7zywJK
         MNzgMB7MymzIfhhdXriQjPhN8Obm61JiTWlXObo4ATfaeUntev4ldlJm9Yhsxs2gw20V
         pRlw==
X-Forwarded-Encrypted: i=1; AJvYcCVZA25puZD7TTsHxZ5cvC9JL/5kKCVM4Zg3Hm/ETzCuA7FUZsdjVQq/74yB6ZUnGCWXRMqQHdNmtA3QsA==@lists.linux.dev
X-Gm-Message-State: AOJu0Yxp2B/8lk0W7lL0bZn8xvr5wmY0CJBMtGZLW2rwNg/8bL7BJMLy
	hq7biexHPJC7NyaX/D7LWx36+QpkNjNKJ0LpYD7Pxrp20CuFLUOu5i8IfsSIGquu8FD0Rlq70CH
	WuvXnCEVym/geDzC6h8OitiGuBPhoBYYigm38MYhdWBfc6KGW+CbdCjw=
X-Google-Smtp-Source: AGHT+IFBkW7YCDcmjP+gJvlxa+hlJqPPJdniRhY/yGyoOR/E+QX9XLWdnhSjWUdbMXAJ1AVcrVPU9L0BrZwk+uMb9QkuEHuDauqF
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1c45:b0:3a7:d792:d6c4 with SMTP id
 e9e14a558f8ab-3a7d792dac9mr101116425ab.21.1733065887891; Sun, 01 Dec 2024
 07:11:27 -0800 (PST)
Date: Sun, 01 Dec 2024 07:11:27 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <674c7c9f.050a0220.48a03.000e.GAE@google.com>
Subject: [syzbot] [ocfs2?] possible deadlock in ocfs2_xattr_ibody_set
From: syzbot <syzbot+40ba330fa32f928caa97@syzkaller.appspotmail.com>
To: jlbec@evilplan.org, joseph.qi@linux.alibaba.com, 
	linux-kernel@vger.kernel.org, mark@fasheh.com, ocfs2-devel@lists.linux.dev, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    7af08b57bcb9 Merge tag 'trace-v6.13-2' of git://git.kernel..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=146a5bc0580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=3891b550f14aea0f
dashboard link: https://syzkaller.appspot.com/bug?extid=40ba330fa32f928caa97
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/7feb34a89c2a/non_bootable_disk-7af08b57.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/63d6781734c3/vmlinux-7af08b57.xz
kernel image: https://storage.googleapis.com/syzbot-assets/f3bd17982594/bzImage-7af08b57.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+40ba330fa32f928caa97@syzkaller.appspotmail.com

loop0: detected capacity change from 0 to 262144
JBD2: Ignoring recovery information on journal
ocfs2: Mounting device (7,0) on (node local, slot 0) with ordered data mode.
warning: `syz.0.0' uses wireless extensions which will stop working for Wi-Fi 7 hardware; use nl80211
overlayfs: upper fs does not support tmpfile.
overlayfs: upper fs does not support RENAME_WHITEOUT.
======================================================
WARNING: possible circular locking dependency detected
6.12.0-syzkaller-10689-g7af08b57bcb9 #0 Not tainted
------------------------------------------------------
syz.0.0/5339 is trying to acquire lock:
ffff88805843dbe0 (&oi->ip_alloc_sem){++++}-{4:4}, at: ocfs2_xattr_ibody_set+0x12c/0xd00 fs/ocfs2/xattr.c:2783

but task is already holding lock:
ffff888040a06958 (jbd2_handle){++++}-{0:0}, at: start_this_handle+0x1e94/0x2110 fs/jbd2/transaction.c:448

which lock already depends on the new lock.


the existing dependency chain (in reverse order) is:

-> #3 (jbd2_handle){++++}-{0:0}:
       lock_acquire+0x1ed/0x550 kernel/locking/lockdep.c:5849
       start_this_handle+0x1eb4/0x2110 fs/jbd2/transaction.c:448
       jbd2__journal_start+0x2da/0x5d0 fs/jbd2/transaction.c:505
       jbd2_journal_start+0x29/0x40 fs/jbd2/transaction.c:544
       ocfs2_start_trans+0x3c9/0x700 fs/ocfs2/journal.c:352
       ocfs2_modify_bh+0xed/0x4d0 fs/ocfs2/quota_local.c:101
       ocfs2_local_read_info+0x158f/0x19f0 fs/ocfs2/quota_local.c:771
       dquot_load_quota_sb+0x762/0xbb0 fs/quota/dquot.c:2457
       dquot_load_quota_inode+0x320/0x600 fs/quota/dquot.c:2494
       ocfs2_enable_quotas+0x169/0x450 fs/ocfs2/super.c:926
       ocfs2_fill_super+0x4ca1/0x5760 fs/ocfs2/super.c:1141
       mount_bdev+0x20a/0x2d0 fs/super.c:1693
       legacy_get_tree+0xee/0x190 fs/fs_context.c:662
       vfs_get_tree+0x90/0x2b0 fs/super.c:1814
       do_new_mount+0x2be/0xb40 fs/namespace.c:3507
       do_mount fs/namespace.c:3847 [inline]
       __do_sys_mount fs/namespace.c:4057 [inline]
       __se_sys_mount+0x2d6/0x3c0 fs/namespace.c:4034
       do_syscall_x64 arch/x86/entry/common.c:52 [inline]
       do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
       entry_SYSCALL_64_after_hwframe+0x77/0x7f

-> #2 (&journal->j_trans_barrier){.+.+}-{4:4}:
       lock_acquire+0x1ed/0x550 kernel/locking/lockdep.c:5849
       down_read+0xb1/0xa40 kernel/locking/rwsem.c:1524
       ocfs2_start_trans+0x3be/0x700 fs/ocfs2/journal.c:350
       ocfs2_modify_bh+0xed/0x4d0 fs/ocfs2/quota_local.c:101
       ocfs2_local_read_info+0x158f/0x19f0 fs/ocfs2/quota_local.c:771
       dquot_load_quota_sb+0x762/0xbb0 fs/quota/dquot.c:2457
       dquot_load_quota_inode+0x320/0x600 fs/quota/dquot.c:2494
       ocfs2_enable_quotas+0x169/0x450 fs/ocfs2/super.c:926
       ocfs2_fill_super+0x4ca1/0x5760 fs/ocfs2/super.c:1141
       mount_bdev+0x20a/0x2d0 fs/super.c:1693
       legacy_get_tree+0xee/0x190 fs/fs_context.c:662
       vfs_get_tree+0x90/0x2b0 fs/super.c:1814
       do_new_mount+0x2be/0xb40 fs/namespace.c:3507
       do_mount fs/namespace.c:3847 [inline]
       __do_sys_mount fs/namespace.c:4057 [inline]
       __se_sys_mount+0x2d6/0x3c0 fs/namespace.c:4034
       do_syscall_x64 arch/x86/entry/common.c:52 [inline]
       do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
       entry_SYSCALL_64_after_hwframe+0x77/0x7f

-> #1 (sb_internal#2){.+.+}-{0:0}:
       lock_acquire+0x1ed/0x550 kernel/locking/lockdep.c:5849
       percpu_down_read include/linux/percpu-rwsem.h:51 [inline]
       __sb_start_write include/linux/fs.h:1725 [inline]
       sb_start_intwrite include/linux/fs.h:1908 [inline]
       ocfs2_start_trans+0x2b9/0x700 fs/ocfs2/journal.c:348
       ocfs2_setattr+0x9dd/0x1ef0 fs/ocfs2/file.c:1263
       notify_change+0xbca/0xe90 fs/attr.c:552
       ovl_do_notify_change fs/overlayfs/overlayfs.h:203 [inline]
       ovl_workdir_create+0x782/0x980 fs/overlayfs/super.c:344
       ovl_make_workdir fs/overlayfs/super.c:650 [inline]
       ovl_get_workdir+0x311/0x1920 fs/overlayfs/super.c:808
       ovl_fill_super+0x12a8/0x3560 fs/overlayfs/super.c:1376
       vfs_get_super fs/super.c:1280 [inline]
       get_tree_nodev+0xb7/0x140 fs/super.c:1299
       vfs_get_tree+0x90/0x2b0 fs/super.c:1814
       do_new_mount+0x2be/0xb40 fs/namespace.c:3507
       do_mount fs/namespace.c:3847 [inline]
       __do_sys_mount fs/namespace.c:4057 [inline]
       __se_sys_mount+0x2d6/0x3c0 fs/namespace.c:4034
       do_syscall_x64 arch/x86/entry/common.c:52 [inline]
       do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
       entry_SYSCALL_64_after_hwframe+0x77/0x7f

-> #0 (&oi->ip_alloc_sem){++++}-{4:4}:
       check_prev_add kernel/locking/lockdep.c:3161 [inline]
       check_prevs_add kernel/locking/lockdep.c:3280 [inline]
       validate_chain+0x18ef/0x5920 kernel/locking/lockdep.c:3904
       __lock_acquire+0x1397/0x2100 kernel/locking/lockdep.c:5226
       lock_acquire+0x1ed/0x550 kernel/locking/lockdep.c:5849
       down_write+0x99/0x220 kernel/locking/rwsem.c:1577
       ocfs2_xattr_ibody_set+0x12c/0xd00 fs/ocfs2/xattr.c:2783
       __ocfs2_xattr_set_handle+0x128/0x10a0 fs/ocfs2/xattr.c:3322
       ocfs2_xattr_set+0x128c/0x1930 fs/ocfs2/xattr.c:3650
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
       vfs_get_tree+0x90/0x2b0 fs/super.c:1814
       do_new_mount+0x2be/0xb40 fs/namespace.c:3507
       do_mount fs/namespace.c:3847 [inline]
       __do_sys_mount fs/namespace.c:4057 [inline]
       __se_sys_mount+0x2d6/0x3c0 fs/namespace.c:4034
       do_syscall_x64 arch/x86/entry/common.c:52 [inline]
       do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
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

8 locks held by syz.0.0/5339:
 #0: ffff8880522e20e0 (&type->s_umount_key#46/1){+.+.}-{4:4}, at: alloc_super+0x221/0x9d0 fs/super.c:344
 #1: ffff888000d92420 (sb_writers#11){.+.+}-{0:0}, at: mnt_want_write+0x3f/0x90 fs/namespace.c:515
 #2: ffff88805843df40 (&sb->s_type->i_mutex_key#19){++++}-{4:4}, at: inode_lock include/linux/fs.h:818 [inline]
 #2: ffff88805843df40 (&sb->s_type->i_mutex_key#19){++++}-{4:4}, at: vfs_setxattr+0x1e1/0x430 fs/xattr.c:320
 #3: ffff88805843dc78 (&oi->ip_xattr_sem){++++}-{4:4}, at: ocfs2_xattr_set+0x633/0x1930 fs/ocfs2/xattr.c:3583
 #4: ffff888058431800 (&ocfs2_sysfile_lock_key[args->fi_sysfile_type]#7){+.+.}-{4:4}, at: inode_lock include/linux/fs.h:818 [inline]
 #4: ffff888058431800 (&ocfs2_sysfile_lock_key[args->fi_sysfile_type]#7){+.+.}-{4:4}, at: ocfs2_reserve_suballoc_bits+0x192/0x4e70 fs/ocfs2/suballoc.c:786
 #5: ffff888000d92610 (sb_internal#2){.+.+}-{0:0}, at: ocfs2_xattr_set+0x1192/0x1930 fs/ocfs2/xattr.c:3643
 #6: ffff88801ce3d8e8 (&journal->j_trans_barrier){.+.+}-{4:4}, at: ocfs2_start_trans+0x3be/0x700 fs/ocfs2/journal.c:350
 #7: ffff888040a06958 (jbd2_handle){++++}-{0:0}, at: start_this_handle+0x1e94/0x2110 fs/jbd2/transaction.c:448

stack backtrace:
CPU: 0 UID: 0 PID: 5339 Comm: syz.0.0 Not tainted 6.12.0-syzkaller-10689-g7af08b57bcb9 #0
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2~bpo12+1 04/01/2014
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:94 [inline]
 dump_stack_lvl+0x241/0x360 lib/dump_stack.c:120
 print_circular_bug+0x13a/0x1b0 kernel/locking/lockdep.c:2074
 check_noncircular+0x36a/0x4a0 kernel/locking/lockdep.c:2206
 check_prev_add kernel/locking/lockdep.c:3161 [inline]
 check_prevs_add kernel/locking/lockdep.c:3280 [inline]
 validate_chain+0x18ef/0x5920 kernel/locking/lockdep.c:3904
 __lock_acquire+0x1397/0x2100 kernel/locking/lockdep.c:5226
 lock_acquire+0x1ed/0x550 kernel/locking/lockdep.c:5849
 down_write+0x99/0x220 kernel/locking/rwsem.c:1577
 ocfs2_xattr_ibody_set+0x12c/0xd00 fs/ocfs2/xattr.c:2783
 __ocfs2_xattr_set_handle+0x128/0x10a0 fs/ocfs2/xattr.c:3322
 ocfs2_xattr_set+0x128c/0x1930 fs/ocfs2/xattr.c:3650
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
 vfs_get_tree+0x90/0x2b0 fs/super.c:1814
 do_new_mount+0x2be/0xb40 fs/namespace.c:3507
 do_mount fs/namespace.c:3847 [inline]
 __do_sys_mount fs/namespace.c:4057 [inline]
 __se_sys_mount+0x2d6/0x3c0 fs/namespace.c:4034
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f091ef80849
Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 a8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f091fd9b058 EFLAGS: 00000246 ORIG_RAX: 00000000000000a5
RAX: ffffffffffffffda RBX: 00007f091f145fa0 RCX: 00007f091ef80849
RDX: 0000000020000080 RSI: 00000000200000c0 RDI: 0000000000000000
RBP: 00007f091eff3986 R08: 0000000020000400 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 0000000000000000 R14: 00007f091f145fa0 R15: 00007ffcd52320d8
 </TASK>
overlayfs: upper fs missing required features.
syz.0.0 (5339) used greatest stack depth: 17176 bytes left


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
