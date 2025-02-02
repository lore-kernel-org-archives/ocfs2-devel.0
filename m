Received: from mail-il1-f205.google.com (mail-il1-f205.google.com [209.85.166.205])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0D971F76C5
	for <ocfs2-devel@lists.linux.dev>; Sun,  2 Feb 2025 14:09:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.205
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738505361; cv=none; b=fjZ0yG7Ku3mWeomh8hkvpImuqN3UVJzjmQFtAAJ2XLGymw3+gONOZ34jwzAWxrH+fxCbB3bVI3oeKet1NqdFduT49e7zh10M9864L10vnJlxOYa8FkBQFpKvmglW+ukMZGg35gflzE9Umg1KrsRgnATxGUUp38uURl8vF2DkRcc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738505361; c=relaxed/simple;
	bh=on8aON62O3WR2jXYZbvYKhrYnxupv+OAlYzHflLErME=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=RxBarMalSgJtC1z48YwNF5m+Hdq1qWo96FSmUSqMmXGS8xHpkIae824b+fYcgw1NahWuHncW29vtG6ib5pQEFV2rSDPVHBmJNpIbchBT7B14P9ovGBbtqGxzqqhyWq6o3aJT8SkszMYLtpiNEGsM4VrZiEG2H9sHiDRBY6+BKrM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.205
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f205.google.com with SMTP id e9e14a558f8ab-3a7e0d5899bso66783285ab.0
        for <ocfs2-devel@lists.linux.dev>; Sun, 02 Feb 2025 06:09:19 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738505359; x=1739110159;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=4z268rVCJ0WKRdRjuKqy7vB9s5VzlGVcUGLPLUoYTG4=;
        b=Py0/n1HE+s19wSb+3hi0jAO5Fm0CEU9ER/Mm7yM+SSg7iphCH90M/mrATo3KQwzmry
         b16GiUkOBWFVYhp6p/6CMHQYcse/iIuhwpTfXYMZvlIFmJqPiwPI7W/BmeljJwjI1k5V
         BZYFIHPfSOZKtFnPg02mnXftdzHsrxdphA9kI7V7tZrJJRqYXCQHBm+bcuRiTCNq3rJi
         jqep/i547GbTpO49dCAikKO7zfWa3QAs0XrYU1hdI+JKdM1e2QPQ+euKKU0GRJ1y2p2A
         Q4ayMgM/8G6CC/pKZvK8L9HZx3+3Nf9lo4tFjxOTi6JYGIJ6oQg9eEMJlDOLTYLbJGsG
         ubzQ==
X-Forwarded-Encrypted: i=1; AJvYcCVJX10d7+N5YpJW6eTIqpEda8hcf0BDZ6RyblmLvHSRJSAO+EzYuM245/SDc6vVelC77MbmOrTXsLFAvQ==@lists.linux.dev
X-Gm-Message-State: AOJu0YzGZGFNT6l9wIqgCkeM25UKwgNYcgdNwZOq43mk1fCa+J7x1hOk
	V4Ksyo8yLMS6eRXSGK5VNdpfNQNDKAnOURzOd/HmSdr5xdEfNczLhmS7FonpVDjxWPFLUQeDOKW
	+nvTKrWL9semiAezmqb7MGC5Ogo8h91nOXNh3gVGqgPJajoSAcQNv5Fw=
X-Google-Smtp-Source: AGHT+IGGRO4qxitEhI0cxcsK3gf9IIf+4zvwL+S87G/tNh9cuuq3upih/O3GxgwB2xJ3+73C5GBmRwydX6zJGNPJP1LC9+kB0yYP
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a92:c567:0:b0:3cf:fb97:c313 with SMTP id
 e9e14a558f8ab-3cffe4679dbmr184117375ab.18.1738505358805; Sun, 02 Feb 2025
 06:09:18 -0800 (PST)
Date: Sun, 02 Feb 2025 06:09:18 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <679f7c8e.050a0220.163cdc.002f.GAE@google.com>
Subject: [syzbot] [ocfs2?] possible deadlock in deactivate_super (2)
From: syzbot <syzbot+180dd013ba371eabc162@syzkaller.appspotmail.com>
To: jlbec@evilplan.org, joseph.qi@linux.alibaba.com, 
	linux-kernel@vger.kernel.org, mark@fasheh.com, ocfs2-devel@lists.linux.dev, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    69b8923f5003 Merge tag 'for-linus-6.14-ofs4' of git://git...
git tree:       upstream
console+strace: https://syzkaller.appspot.com/x/log.txt?x=13fc4eb0580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=57ab43c279fa614d
dashboard link: https://syzkaller.appspot.com/bug?extid=180dd013ba371eabc162
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=17cdcb24580000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=132c2d18580000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/ea84ac864e92/disk-69b8923f.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/6a465997b4e0/vmlinux-69b8923f.xz
kernel image: https://storage.googleapis.com/syzbot-assets/d72b67b2bd15/bzImage-69b8923f.xz
mounted in repro: https://storage.googleapis.com/syzbot-assets/48dd26198522/mount_0.gz

Bisection is inconclusive: the first bad commit could be any of:

309a43165077 rcu/kvfree: Use consistent krcp when growing kfree_rcu() page cache
021a5ff84743 rcu/kvfree: Do not run a page work if a cache is disabled
1e237994d9c9 rcu/kvfree: Invoke debug_rcu_bhead_unqueue() after checking bnode->gp_snap
60888b77a06e rcu/kvfree: Make fill page cache start from krcp->nr_bkv_objs
f32276a37652 rcu/kvfree: Add debug check for GP complete for kfree_rcu_cpu list
6b706e5603c4 rcu/kvfree: Make drain_page_cache() take early return if cache is disabled
cdfa0f6fa6b7 rcu/kvfree: Add debug to check grace periods
2e31da752c6d Merge branches 'doc.2023.05.10a', 'fixes.2023.05.11a', 'kvfree.2023.05.10a', 'nocb.2023.05.11a', 'rcu-tasks.2023.05.10a', 'torture.2023.05.15a' and 'rcu-urgent.2023.06.06a' into HEAD
7e3f926bf453 rcu/kvfree: Eliminate k[v]free_rcu() single argument macro
af96134dc856 Merge tag 'rcu.2023.06.22a' of git://git.kernel.org/pub/scm/linux/kernel/git/paulmck/linux-rcu

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=11821724580000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+180dd013ba371eabc162@syzkaller.appspotmail.com

ocfs2: Mounting device (7,0) on (node local, slot 0) with ordered data mode.
======================================================
WARNING: possible circular locking dependency detected
6.13.0-syzkaller-09793-g69b8923f5003 #0 Not tainted
------------------------------------------------------
syz-executor651/5821 is trying to acquire lock:
ffff8880270c2948 ((wq_completion)ocfs2_wq){+.+.}-{0:0}, at: touch_wq_lockdep_map+0xb1/0x170 kernel/workqueue.c:3905

but task is already holding lock:
ffff88807ea340e0 (&type->s_umount_key#45){++++}-{4:4}, at: __super_lock fs/super.c:56 [inline]
ffff88807ea340e0 (&type->s_umount_key#45){++++}-{4:4}, at: __super_lock_excl fs/super.c:71 [inline]
ffff88807ea340e0 (&type->s_umount_key#45){++++}-{4:4}, at: deactivate_super+0xb5/0xf0 fs/super.c:505

which lock already depends on the new lock.


the existing dependency chain (in reverse order) is:

-> #2 (&type->s_umount_key#45){++++}-{4:4}:
       lock_acquire+0x1ed/0x550 kernel/locking/lockdep.c:5851
       down_read+0xb1/0xa40 kernel/locking/rwsem.c:1524
       ocfs2_finish_quota_recovery+0x15c/0x22a0 fs/ocfs2/quota_local.c:603
       ocfs2_complete_recovery+0x17c1/0x25c0 fs/ocfs2/journal.c:1357
       process_one_work kernel/workqueue.c:3236 [inline]
       process_scheduled_works+0xa66/0x1840 kernel/workqueue.c:3317
       worker_thread+0x870/0xd30 kernel/workqueue.c:3398
       kthread+0x7a9/0x920 kernel/kthread.c:464
       ret_from_fork+0x4b/0x80 arch/x86/kernel/process.c:148
       ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:244

-> #1 ((work_completion)(&journal->j_recovery_work)){+.+.}-{0:0}:
       lock_acquire+0x1ed/0x550 kernel/locking/lockdep.c:5851
       process_one_work kernel/workqueue.c:3212 [inline]
       process_scheduled_works+0x994/0x1840 kernel/workqueue.c:3317
       worker_thread+0x870/0xd30 kernel/workqueue.c:3398
       kthread+0x7a9/0x920 kernel/kthread.c:464
       ret_from_fork+0x4b/0x80 arch/x86/kernel/process.c:148
       ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:244

-> #0 ((wq_completion)ocfs2_wq){+.+.}-{0:0}:
       check_prev_add kernel/locking/lockdep.c:3163 [inline]
       check_prevs_add kernel/locking/lockdep.c:3282 [inline]
       validate_chain+0x18ef/0x5920 kernel/locking/lockdep.c:3906
       __lock_acquire+0x1397/0x2100 kernel/locking/lockdep.c:5228
       lock_acquire+0x1ed/0x550 kernel/locking/lockdep.c:5851
       touch_wq_lockdep_map+0xc7/0x170 kernel/workqueue.c:3905
       __flush_workqueue+0x14a/0x1280 kernel/workqueue.c:3947
       ocfs2_shutdown_local_alloc+0x109/0xa90 fs/ocfs2/localalloc.c:380
       ocfs2_dismount_volume+0x202/0x910 fs/ocfs2/super.c:1822
       generic_shutdown_super+0x139/0x2d0 fs/super.c:642
       kill_block_super+0x44/0x90 fs/super.c:1710
       deactivate_locked_super+0xc4/0x130 fs/super.c:473
       cleanup_mnt+0x41f/0x4b0 fs/namespace.c:1413
       task_work_run+0x24f/0x310 kernel/task_work.c:227
       exit_task_work include/linux/task_work.h:40 [inline]
       do_exit+0xa2a/0x28e0 kernel/exit.c:938
       do_group_exit+0x207/0x2c0 kernel/exit.c:1087
       __do_sys_exit_group kernel/exit.c:1098 [inline]
       __se_sys_exit_group kernel/exit.c:1096 [inline]
       __x64_sys_exit_group+0x3f/0x40 kernel/exit.c:1096
       x64_sys_call+0x26a8/0x26b0 arch/x86/include/generated/asm/syscalls_64.h:232
       do_syscall_x64 arch/x86/entry/common.c:52 [inline]
       do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
       entry_SYSCALL_64_after_hwframe+0x77/0x7f

other info that might help us debug this:

Chain exists of:
  (wq_completion)ocfs2_wq --> (work_completion)(&journal->j_recovery_work) --> &type->s_umount_key#45

 Possible unsafe locking scenario:

       CPU0                    CPU1
       ----                    ----
  lock(&type->s_umount_key#45);
                               lock((work_completion)(&journal->j_recovery_work));
                               lock(&type->s_umount_key#45);
  lock((wq_completion)ocfs2_wq);

 *** DEADLOCK ***

1 lock held by syz-executor651/5821:
 #0: ffff88807ea340e0 (&type->s_umount_key#45){++++}-{4:4}, at: __super_lock fs/super.c:56 [inline]
 #0: ffff88807ea340e0 (&type->s_umount_key#45){++++}-{4:4}, at: __super_lock_excl fs/super.c:71 [inline]
 #0: ffff88807ea340e0 (&type->s_umount_key#45){++++}-{4:4}, at: deactivate_super+0xb5/0xf0 fs/super.c:505

stack backtrace:
CPU: 1 UID: 0 PID: 5821 Comm: syz-executor651 Not tainted 6.13.0-syzkaller-09793-g69b8923f5003 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 12/27/2024
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:94 [inline]
 dump_stack_lvl+0x241/0x360 lib/dump_stack.c:120
 print_circular_bug+0x13a/0x1b0 kernel/locking/lockdep.c:2076
 check_noncircular+0x36a/0x4a0 kernel/locking/lockdep.c:2208
 check_prev_add kernel/locking/lockdep.c:3163 [inline]
 check_prevs_add kernel/locking/lockdep.c:3282 [inline]
 validate_chain+0x18ef/0x5920 kernel/locking/lockdep.c:3906
 __lock_acquire+0x1397/0x2100 kernel/locking/lockdep.c:5228
 lock_acquire+0x1ed/0x550 kernel/locking/lockdep.c:5851
 touch_wq_lockdep_map+0xc7/0x170 kernel/workqueue.c:3905
 __flush_workqueue+0x14a/0x1280 kernel/workqueue.c:3947
 ocfs2_shutdown_local_alloc+0x109/0xa90 fs/ocfs2/localalloc.c:380
 ocfs2_dismount_volume+0x202/0x910 fs/ocfs2/super.c:1822
 generic_shutdown_super+0x139/0x2d0 fs/super.c:642
 kill_block_super+0x44/0x90 fs/super.c:1710
 deactivate_locked_super+0xc4/0x130 fs/super.c:473
 cleanup_mnt+0x41f/0x4b0 fs/namespace.c:1413
 task_work_run+0x24f/0x310 kernel/task_work.c:227
 exit_task_work include/linux/task_work.h:40 [inline]
 do_exit+0xa2a/0x28e0 kernel/exit.c:938
 do_group_exit+0x207/0x2c0 kernel/exit.c:1087
 __do_sys_exit_group kernel/exit.c:1098 [inline]
 __se_sys_exit_group kernel/exit.c:1096 [inline]
 __x64_sys_exit_group+0x3f/0x40 kernel/exit.c:1096
 x64_sys_call+0x26a8/0x26b0 arch/x86/include/generated/asm/syscalls_64.h:232
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7fefe6fc9b89
Code: Unable to access opcode bytes at 0x7fefe6fc9b5f.
RSP: 002b:00007ffcff91e9b8 EFLAGS: 00000246 ORIG_RAX: 00000000000000e7
RAX: ffffffffffffffda RBX: 0000000000000001 RCX: 00007fefe6fc9b89
RDX: 000000000000003c RSI: 00000000000000e7 RDI: 0000000000000001
RBP: 00007fefe704a2b0 R08: ffffffffffffffb8 R09: 0000000000004701
R10: 0000000000000000 R11: 0000000000000246 R12: 00007fefe704a2b0
R13: 0000000000000000 R14: 00007fefe704b020 R15: 00007fefe6f980


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
For information about bisection process see: https://goo.gl/tpsmEJ#bisection

If the report is already addressed, let syzbot know by replying with:
#syz fix: exact-commit-title

If you want syzbot to run the reproducer, reply with:
#syz test: git://repo/address.git branch-or-commit-hash
If you attach or paste a git patch, syzbot will apply it before testing.

If you want to overwrite report's subsystems, reply with:
#syz set subsystems: new-subsystem
(See the list of subsystem names on the web dashboard)

If the report is a duplicate of another one, reply with:
#syz dup: exact-subject-of-another-report

If you want to undo deduplication, reply with:
#syz undup
