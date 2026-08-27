Received: from mail-oi1-f206.google.com (mail-oi1-f206.google.com [209.85.167.206])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E12B4A23
	for <ocfs2-devel@lists.linux.dev>; Thu, 27 Aug 2026 19:48:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.206
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787860107; cv=none; b=RjAb0nmNlYEZAEdIoXe/nWmm3Xn1Cbtj8Df5ZndAzFi3TylQ8EKkoazAdxwNVNtMFcP5LvhwpU+A4Z178NknzTAQUCwe/oCH99qzf6kkm8qK7OL9TBWIRRQ+mzUQwR6qnmfAk39s1W6lWS3ODrKnV67NWFZYGz35lczi6xd9i3A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787860107; c=relaxed/simple;
	bh=3CV97cb8pUXArOuTdW3ZYZQcwYa9q7iaQAsHDD+CYkE=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=PTn6xFb+q2nkFYT9CNIVm4E+dhzYyyD09D6AB6LigWhhVYMjGXE794xT9SMBlpG8KZydp1EH2RWjOQ0HHA1OJWl5+xZi97GsM6fyUYhdc9hgUhqdszBz9xHmvwBYNeATdDAPjFVwoDoofodN7UHIkHsv0JvBT9siiASefQXS8uY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.167.206
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oi1-f206.google.com with SMTP id 5614622812f47-4b28d7ffab1so363925b6e.1
        for <ocfs2-devel@lists.linux.dev>; Thu, 27 Aug 2026 12:48:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787860105; x=1788464905;
        h=content-type:to:from:subject:message-id:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=6LJLy1+DpLAVyoG5LCcawK0H77pykur+lkSPcFXB6kM=;
        b=p3EeWs+VrFOnys4DAy+uJZ6Plb5OJOj5sRBkdBNZ/f2Tb1C/QpX5enONPvDiuJSoHQ
         xf/got2f2nrmniFmzzxzSqDN2H67EdngSt0+70sUNSonOsN1xsGyu4kqwD1qxMOLIaLV
         ovhkBCotbpuY9o/8xctgYdmDVocw0Ypa8hCVLPIHB+8nQ5Zsfu9/0s44o9wtgqMFWW8A
         aXMXZJA4yGOksV5tYhEh7qMwkJ3BKSVdbcekRwJ45Nj/vsE8qXs4F+vaRF9MWP8e+oHC
         P1xJjHiAgoyuysQkHzNV+9e015Pneh5EepMuEJoWBzia1BHtPOG9VzC9OMr7GjMtCExb
         xKoQ==
X-Forwarded-Encrypted: i=1; AHgh+RqgoBHBl5VVwcLb6cMm+yj5ZCB0AwLOIGumDECB6oYZhCz17RNM58dGEPsre0Xy9uKw7oYpeclLE8lovQ==@lists.linux.dev
X-Gm-Message-State: AFuF++lkGKvtOebe1y5ocqWrBb55fB+kl01OPb/r+SuHC0UsdFABW6Zu
	h97LjRxaVR06CucaIipn5+2molxPuxe+gJ47rUt92KIKWs416VSDQU8YN29lK3P/YfBg/zAiK2Q
	DvES4TU2xO23SAVV+ZcNaXUwl6P66kU7FAMBl5l9Gbp58ygKzT8r+OxezURc=
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6808:1a21:b0:496:9ee:e538 with SMTP id
 5614622812f47-4b37c81e675mr6843349b6e.5.1787860104982; Thu, 27 Aug 2026
 12:48:24 -0700 (PDT)
Date: Thu, 27 Aug 2026 12:48:24 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6a909488.4d659fcc.734b4.0015.GAE@google.com>
Subject: [syzbot] [ocfs2?] possible deadlock in ocfs2_xattr_get (2)
From: syzbot <syzbot+c63f5bc973ab97368c21@syzkaller.appspotmail.com>
To: jlbec@evilplan.org, joseph.qi@linux.alibaba.com, 
	linux-kernel@vger.kernel.org, mark@fasheh.com, ocfs2-devel@lists.linux.dev, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    73e3f0710014 Merge tag 'nfs-for-7.3-1' of git://git.linux-..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=136a3579580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=9efed59cf70d6280
dashboard link: https://syzkaller.appspot.com/bug?extid=c63f5bc973ab97368c21
compiler:       Debian clang version 22.1.8 (++20260613092233+e80beda6e255-1~exp1~20260613092250.77), Debian LLD 22.1.8

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/ffcd3fee974f/disk-73e3f071.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/cf4f954d6b1a/vmlinux-73e3f071.xz
kernel image: https://storage.googleapis.com/syzbot-assets/45faed1d28b1/bzImage-73e3f071.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+c63f5bc973ab97368c21@syzkaller.appspotmail.com

ocfs2: Slot 0 on device (7,9) was already allocated to this node!
JBD2: Ignoring recovery information on journal
ocfs2: Mounting device (7,9) on (node local, slot 0) with ordered data mode.
======================================================
WARNING: possible circular locking dependency detected
syzkaller #0 Not tainted
------------------------------------------------------
syz.9.729/14532 is trying to acquire lock:
ffff888062520858 (&oi->ip_xattr_sem){++++}-{4:4}, at: ocfs2_xattr_get+0xf4/0x260 fs/ocfs2/xattr.c:1578

but task is already holding lock:
ffff88803357f118 (&journal->j_trans_barrier){.+.+}-{4:4}, at: ocfs2_start_trans+0x3af/0x700 fs/ocfs2/journal.c:369

which lock already depends on the new lock.


the existing dependency chain (in reverse order) is:

-> #3 (&journal->j_trans_barrier){.+.+}-{4:4}:
       down_read+0x97/0x200 kernel/locking/rwsem.c:1574
       ocfs2_start_trans+0x3af/0x700 fs/ocfs2/journal.c:369
       ocfs2_block_group_alloc fs/ocfs2/suballoc.c:801 [inline]
       ocfs2_reserve_suballoc_bits+0x7b7/0x4850 fs/ocfs2/suballoc.c:950
       ocfs2_reserve_new_metadata_blocks+0x415/0x9a0 fs/ocfs2/suballoc.c:1100
       ocfs2_expand_inline_dir fs/ocfs2/dir.c:2928 [inline]
       ocfs2_extend_dir+0xd35/0x4b60 fs/ocfs2/dir.c:3290
       ocfs2_prepare_dir_for_insert+0x339a/0x5190 fs/ocfs2/dir.c:4408
       ocfs2_mknod+0x86f/0x22b0 fs/ocfs2/namei.c:299
       ocfs2_mkdir+0x180/0x430 fs/ocfs2/namei.c:667
       vfs_mkdir+0x408/0x620 fs/namei.c:5410
       filename_mkdirat+0x289/0x520 fs/namei.c:5443
       __do_sys_mkdirat fs/namei.c:5464 [inline]
       __se_sys_mkdirat+0x35/0x150 fs/namei.c:5461
       do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
       do_syscall_64+0x166/0x520 arch/x86/entry/syscall_64.c:84
       entry_SYSCALL_64_after_hwframe+0x77/0x7f

-> #2 (sb_internal#7){.+.+}-{0:0}:
       percpu_down_read_internal include/linux/percpu-rwsem.h:53 [inline]
       percpu_down_read_freezable include/linux/percpu-rwsem.h:83 [inline]
       __sb_start_write include/linux/fs/super.h:19 [inline]
       sb_start_intwrite include/linux/fs/super.h:177 [inline]
       ocfs2_start_trans+0x2ac/0x700 fs/ocfs2/journal.c:367
       ocfs2_orphan_for_truncate fs/ocfs2/file.c:397 [inline]
       ocfs2_truncate_file+0x634/0x14b0 fs/ocfs2/file.c:506
       ocfs2_setattr+0x1641/0x1d10 fs/ocfs2/file.c:1224
       notify_change+0xbb8/0xec0 fs/attr.c:556
       do_truncate+0x1c2/0x250 fs/open.c:68
       handle_truncate fs/namei.c:4300 [inline]
       do_open fs/namei.c:4841 [inline]
       path_openat+0x15ba/0x1d60 fs/namei.c:5000
       do_file_open+0x23e/0x4a0 fs/namei.c:5029
       do_sys_openat2+0x115/0x200 fs/open.c:1417
       do_sys_open fs/open.c:1423 [inline]
       __do_sys_openat fs/open.c:1439 [inline]
       __se_sys_openat fs/open.c:1434 [inline]
       __x64_sys_openat+0x138/0x170 fs/open.c:1434
       do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
       do_syscall_64+0x166/0x520 arch/x86/entry/syscall_64.c:84
       entry_SYSCALL_64_after_hwframe+0x77/0x7f

-> #1 (&ocfs2_file_ip_alloc_sem_key){++++}-{4:4}:
       down_write+0x3a/0x50 kernel/locking/rwsem.c:1631
       ocfs2_try_remove_refcount_tree+0xb6/0x360 fs/ocfs2/refcounttree.c:959
       ocfs2_truncate_file+0xe91/0x14b0 fs/ocfs2/file.c:527
       ocfs2_setattr+0x1641/0x1d10 fs/ocfs2/file.c:1224
       notify_change+0xbb8/0xec0 fs/attr.c:556
       do_truncate+0x1c2/0x250 fs/open.c:68
       handle_truncate fs/namei.c:4300 [inline]
       do_open fs/namei.c:4841 [inline]
       path_openat+0x15ba/0x1d60 fs/namei.c:5000
       do_file_open+0x23e/0x4a0 fs/namei.c:5029
       do_sys_openat2+0x115/0x200 fs/open.c:1417
       do_sys_open fs/open.c:1423 [inline]
       __do_sys_openat fs/open.c:1439 [inline]
       __se_sys_openat fs/open.c:1434 [inline]
       __x64_sys_openat+0x138/0x170 fs/open.c:1434
       do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
       do_syscall_64+0x166/0x520 arch/x86/entry/syscall_64.c:84
       entry_SYSCALL_64_after_hwframe+0x77/0x7f

-> #0 (&oi->ip_xattr_sem){++++}-{4:4}:
       check_prev_add kernel/locking/lockdep.c:3181 [inline]
       check_prevs_add kernel/locking/lockdep.c:3300 [inline]
       validate_chain kernel/locking/lockdep.c:3924 [inline]
       __lock_acquire+0x1520/0x2ce0 kernel/locking/lockdep.c:5253
       lock_acquire+0x106/0x350 kernel/locking/lockdep.c:5886
       down_read+0x97/0x200 kernel/locking/rwsem.c:1574
       ocfs2_xattr_get+0xf4/0x260 fs/ocfs2/xattr.c:1578
       __vfs_getxattr+0x412/0x440 fs/xattr.c:446
       smk_fetch+0xb4/0x140 security/smack/smack_lsm.c:298
       smack_d_instantiate+0x757/0x990 security/smack/smack_lsm.c:3679
       security_d_instantiate+0x106/0x1d0 security/security.c:3703
       d_instantiate+0x54/0xb0 fs/dcache.c:2176
       ocfs2_mknod+0x1acb/0x22b0 fs/ocfs2/namei.c:459
       ocfs2_mkdir+0x180/0x430 fs/ocfs2/namei.c:667
       vfs_mkdir+0x408/0x620 fs/namei.c:5410
       filename_mkdirat+0x289/0x520 fs/namei.c:5443
       __do_sys_mkdirat fs/namei.c:5464 [inline]
       __se_sys_mkdirat+0x35/0x150 fs/namei.c:5461
       do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
       do_syscall_64+0x166/0x520 arch/x86/entry/syscall_64.c:84
       entry_SYSCALL_64_after_hwframe+0x77/0x7f

other info that might help us debug this:

Chain exists of:
  &oi->ip_xattr_sem --> sb_internal#7 --> &journal->j_trans_barrier

 Possible unsafe locking scenario:

       CPU0                    CPU1
       ----                    ----
  rlock(&journal->j_trans_barrier);
                               lock(sb_internal#7);
                               lock(&journal->j_trans_barrier);
  rlock(&oi->ip_xattr_sem);

 *** DEADLOCK ***

locks held by syz.9.729/14532: 8, last CPU#0:
 #0: ffff888063998510 (sb_writers#34){.+.+}-{0:0}, at: mnt_want_write+0x41/0x90 fs/namespace.c:494
 #1: ffff88806243f000 (&type->i_mutex_dir_key#24/1){+.+.}-{4:4}, at: inode_lock_nested include/linux/fs.h:1070 [inline]
 #1: ffff88806243f000 (&type->i_mutex_dir_key#24/1){+.+.}-{4:4}, at: __start_dirop fs/namei.c:2918 [inline]
 #1: ffff88806243f000 (&type->i_mutex_dir_key#24/1){+.+.}-{4:4}, at: start_dirop fs/namei.c:2942 [inline]
 #1: ffff88806243f000 (&type->i_mutex_dir_key#24/1){+.+.}-{4:4}, at: filename_create+0x200/0x370 fs/namei.c:5092
 #2: ffff888056ebbdc0 (&ocfs2_sysfile_lock_key[INODE_ALLOC_SYSTEM_INODE]){+.+.}-{4:4}, at: inode_lock include/linux/fs.h:1025 [inline]
 #2: ffff888056ebbdc0 (&ocfs2_sysfile_lock_key[INODE_ALLOC_SYSTEM_INODE]){+.+.}-{4:4}, at: ocfs2_reserve_suballoc_bits+0x170/0x4850 fs/ocfs2/suballoc.c:904
 #3: ffff888056ebce80 (&ocfs2_sysfile_lock_key[EXTENT_ALLOC_SYSTEM_INODE]){+.+.}-{4:4}, at: inode_lock include/linux/fs.h:1025 [inline]
 #3: ffff888056ebce80 (&ocfs2_sysfile_lock_key[EXTENT_ALLOC_SYSTEM_INODE]){+.+.}-{4:4}, at: ocfs2_reserve_suballoc_bits+0x170/0x4850 fs/ocfs2/suballoc.c:904
 #4: ffff888056eb8b80 (&ocfs2_sysfile_lock_key[LOCAL_ALLOC_SYSTEM_INODE]){+.+.}-{4:4}, at: inode_lock include/linux/fs.h:1025 [inline]
 #4: ffff888056eb8b80 (&ocfs2_sysfile_lock_key[LOCAL_ALLOC_SYSTEM_INODE]){+.+.}-{4:4}, at: ocfs2_reserve_local_alloc_bits+0x11f/0x2680 fs/ocfs2/localalloc.c:636
 #5: ffff888063998800 (sb_internal#7){.+.+}-{0:0}, at: ocfs2_mknod+0xf72/0x22b0 fs/ocfs2/namei.c:370
 #6: ffff88803357f118 (&journal->j_trans_barrier){.+.+}-{4:4}, at: ocfs2_start_trans+0x3af/0x700 fs/ocfs2/journal.c:369
 #7: ffff888028f16bb0 (jbd2_handle#2){.+.+}-{0:0}, at: start_this_handle+0x1fbf/0x2200 fs/jbd2/transaction.c:444

stack backtrace:
CPU: 0 UID: 0 PID: 14532 Comm: syz.9.729 Not tainted syzkaller #0 PREEMPT_{RT,(full)} 
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 07/24/2026
Call Trace:
 <TASK>
 dump_stack_lvl+0xe8/0x150 lib/dump_stack.c:120
 print_circular_bug+0x2e1/0x300 kernel/locking/lockdep.c:2059
 check_noncircular+0x12e/0x150 kernel/locking/lockdep.c:2191
 check_prev_add kernel/locking/lockdep.c:3181 [inline]
 check_prevs_add kernel/locking/lockdep.c:3300 [inline]
 validate_chain kernel/locking/lockdep.c:3924 [inline]
 __lock_acquire+0x1520/0x2ce0 kernel/locking/lockdep.c:5253
 lock_acquire+0x106/0x350 kernel/locking/lockdep.c:5886
 down_read+0x97/0x200 kernel/locking/rwsem.c:1574
 ocfs2_xattr_get+0xf4/0x260 fs/ocfs2/xattr.c:1578
 __vfs_getxattr+0x412/0x440 fs/xattr.c:446
 smk_fetch+0xb4/0x140 security/smack/smack_lsm.c:298
 smack_d_instantiate+0x757/0x990 security/smack/smack_lsm.c:3679
 security_d_instantiate+0x106/0x1d0 security/security.c:3703
 d_instantiate+0x54/0xb0 fs/dcache.c:2176
 ocfs2_mknod+0x1acb/0x22b0 fs/ocfs2/namei.c:459
 ocfs2_mkdir+0x180/0x430 fs/ocfs2/namei.c:667
 vfs_mkdir+0x408/0x620 fs/namei.c:5410
 filename_mkdirat+0x289/0x520 fs/namei.c:5443
 __do_sys_mkdirat fs/namei.c:5464 [inline]
 __se_sys_mkdirat+0x35/0x150 fs/namei.c:5461
 do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
 do_syscall_64+0x166/0x520 arch/x86/entry/syscall_64.c:84
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f98c067cf47
Code: 00 66 90 48 89 f2 b9 00 01 00 00 48 89 fe bf 9c ff ff ff e9 db f7 ff ff 66 2e 0f 1f 84 00 00 00 00 00 90 b8 02 01 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f98be8d5e58 EFLAGS: 00000246 ORIG_RAX: 0000000000000102
RAX: ffffffffffffffda RBX: 00007f98be8d5ee0 RCX: 00007f98c067cf47
RDX: 00000000000001ff RSI: 00002000000001c0 RDI: 00000000ffffff9c
RBP: 0000200000000040 R08: 0000200000000240 R09: 0000000000000000
R10: 0000200000000040 R11: 0000000000000246 R12: 00002000000001c0
R13: 00007f98be8d5ea0 R14: 0000000000000000 R15: 0000000000000000
 </TASK>
gadgetfs: bound to dummy_udc driver


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
