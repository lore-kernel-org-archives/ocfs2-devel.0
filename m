Received: from mail-il1-f205.google.com (mail-il1-f205.google.com [209.85.166.205])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 323472F3B
	for <ocfs2-devel@lists.linux.dev>; Sun,  2 Feb 2025 09:01:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.205
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738486886; cv=none; b=U8my+TY67SaPi4zupnrXYyfrTqiokFXPbLTvZWcWYeJU2ectEAkmK6ClLV35qnA2IsKvRNF7h3qRmKYiy38kjj9SFKhcCLX8+vOMrFNcJYH6TWeOKGf9PXpp6Hvvq+niYHkordRcYenwtuPoJLGGCjMw0XHejDl0r1LOhGZ5LcA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738486886; c=relaxed/simple;
	bh=9iGKCcRBaEhUImdQIY9K0fjLjHWMCRaAT/OSx18ySQw=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=GAOK5yVXUjzZDfRImzFC9mgM5CQEje+4BdMZ4sWuLcQNoJBNjeP7GgaHqqhkZrDwYa4P1v60DB3lXSZrquULyG48TFVzNKowfinyJEGiL+0qfvv3/reDaOc8RQlev5i9qB4NX325Q4uumv3WqzChbA9P3HBzaIqY+cSlKuGWnVg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.205
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f205.google.com with SMTP id e9e14a558f8ab-3cfb20d74b5so22568085ab.3
        for <ocfs2-devel@lists.linux.dev>; Sun, 02 Feb 2025 01:01:24 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738486884; x=1739091684;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=V57rJ3ELYBRW5+QuiDo9Cfsx+p4tjsLmtCQ2LZVd8lw=;
        b=fABfX2F2rgmpyPvdO6UGRzYj7pb9gPCyEegLEswvESeI9kJMRmh4UgQVD60AUazvOS
         scauO/uLighXbnQ/ECeAZnpvbDYFBjqtbc25f3BP2PftRs18Lrxv4fpq+Xl2RA2KWC9u
         JWMReiTh6KkSDW5Rvi226lqw+X1vwLHM5kHIDpUylaw0Sah4buILNV/+PHtWFLHBPMGJ
         e8ueq15X8j4ig1iW/eaftkw/2DLS9PLF6MJ0eQFIL4loGqfyW6X5LYLjg/0/zwwaywM+
         Ec5DVH37KlVTPJAsP5gtrPkYx1j643k/Rz1YanPnNg12d0xMDeJDnJJS1SAsW24Rh9GC
         I9CA==
X-Forwarded-Encrypted: i=1; AJvYcCUrL50u5AViLt8uD+fi9bEXCKVtqIUcKH9ozNWV2fYVuyo5pA3RCNGB+n/H8Miw4OGXS7ryM5/zy2i9EA==@lists.linux.dev
X-Gm-Message-State: AOJu0YwBrTNK6WcdbuNxS/VpkZwdPV8Me7wSU1JOZc7YkS3DvB+Z0HUc
	U4j7wIMLCfphwjKdHn4rivs3EtajrsEDPeOAqEm4FMjm2WxvYpuN1c8ZzKUIwZ8RMrgTAW2eZQU
	Ai6XsUxQqiQ7jyuNDTVLLjbyyr2bNHr5pytQVlM0tNdksOvxcRUrMv5c=
X-Google-Smtp-Source: AGHT+IGvwTTHiVO2StBHXLQBe5FpZoqsxclhJQlr/hq9CdU4cPRKT1xx/PgN2JrXLU+KIa4saOjuHVkr6lkskkN4JX4EmpzTsXWS
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:2149:b0:3cf:cbac:3ba6 with SMTP id
 e9e14a558f8ab-3cffe37cef5mr165348165ab.5.1738486884265; Sun, 02 Feb 2025
 01:01:24 -0800 (PST)
Date: Sun, 02 Feb 2025 01:01:24 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <679f3464.050a0220.d7c5a.006d.GAE@google.com>
Subject: [syzbot] [ocfs2?] possible deadlock in ocfs2_finish_quota_recovery
From: syzbot <syzbot+f59a1ae7b7227c859b8f@syzkaller.appspotmail.com>
To: jlbec@evilplan.org, joseph.qi@linux.alibaba.com, 
	linux-kernel@vger.kernel.org, mark@fasheh.com, ocfs2-devel@lists.linux.dev, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    69b8923f5003 Merge tag 'for-linus-6.14-ofs4' of git://git...
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=100c4eb0580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=57ab43c279fa614d
dashboard link: https://syzkaller.appspot.com/bug?extid=f59a1ae7b7227c859b8f
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/ea84ac864e92/disk-69b8923f.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/6a465997b4e0/vmlinux-69b8923f.xz
kernel image: https://storage.googleapis.com/syzbot-assets/d72b67b2bd15/bzImage-69b8923f.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+f59a1ae7b7227c859b8f@syzkaller.appspotmail.com

ocfs2: Finishing quota recovery on device (7,0) for slot 0
======================================================
WARNING: possible circular locking dependency detected
6.13.0-syzkaller-09793-g69b8923f5003 #0 Not tainted
------------------------------------------------------
kworker/u8:6/1142 is trying to acquire lock:
ffff888055ab40e0 (&type->s_umount_key#51){++++}-{4:4}, at: ocfs2_finish_quota_recovery+0x15c/0x22a0 fs/ocfs2/quota_local.c:603

but task is already holding lock:
ffffc90003c4fc60 ((work_completion)(&journal->j_recovery_work)){+.+.}-{0:0}, at: process_one_work kernel/workqueue.c:3212 [inline]
ffffc90003c4fc60 ((work_completion)(&journal->j_recovery_work)){+.+.}-{0:0}, at: process_scheduled_works+0x976/0x1840 kernel/workqueue.c:3317

which lock already depends on the new lock.


the existing dependency chain (in reverse order) is:

-> #2 ((work_completion)(&journal->j_recovery_work)){+.+.}-{0:0}:
       lock_acquire+0x1ed/0x550 kernel/locking/lockdep.c:5851
       process_one_work kernel/workqueue.c:3212 [inline]
       process_scheduled_works+0x994/0x1840 kernel/workqueue.c:3317
       worker_thread+0x870/0xd30 kernel/workqueue.c:3398
       kthread+0x7a9/0x920 kernel/kthread.c:464
       ret_from_fork+0x4b/0x80 arch/x86/kernel/process.c:148
       ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:244

-> #1 ((wq_completion)ocfs2_wq){+.+.}-{0:0}:
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
       resume_user_mode_work include/linux/resume_user_mode.h:50 [inline]
       exit_to_user_mode_loop kernel/entry/common.c:114 [inline]
       exit_to_user_mode_prepare include/linux/entry-common.h:329 [inline]
       __syscall_exit_to_user_mode_work kernel/entry/common.c:207 [inline]
       syscall_exit_to_user_mode+0x13f/0x340 kernel/entry/common.c:218
       do_syscall_64+0x100/0x230 arch/x86/entry/common.c:89
       entry_SYSCALL_64_after_hwframe+0x77/0x7f

-> #0 (&type->s_umount_key#51){++++}-{4:4}:
       check_prev_add kernel/locking/lockdep.c:3163 [inline]
       check_prevs_add kernel/locking/lockdep.c:3282 [inline]
       validate_chain+0x18ef/0x5920 kernel/locking/lockdep.c:3906
       __lock_acquire+0x1397/0x2100 kernel/locking/lockdep.c:5228
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

other info that might help us debug this:

Chain exists of:
  &type->s_umount_key#51 --> (wq_completion)ocfs2_wq --> (work_completion)(&journal->j_recovery_work)

 Possible unsafe locking scenario:

       CPU0                    CPU1
       ----                    ----
  lock((work_completion)(&journal->j_recovery_work));
                               lock((wq_completion)ocfs2_wq);
                               lock((work_completion)(&journal->j_recovery_work));
  rlock(&type->s_umount_key#51);

 *** DEADLOCK ***

2 locks held by kworker/u8:6/1142:
 #0: ffff88802420b148 ((wq_completion)ocfs2_wq){+.+.}-{0:0}, at: process_one_work kernel/workqueue.c:3211 [inline]
 #0: ffff88802420b148 ((wq_completion)ocfs2_wq){+.+.}-{0:0}, at: process_scheduled_works+0x93b/0x1840 kernel/workqueue.c:3317
 #1: ffffc90003c4fc60 ((work_completion)(&journal->j_recovery_work)){+.+.}-{0:0}, at: process_one_work kernel/workqueue.c:3212 [inline]
 #1: ffffc90003c4fc60 ((work_completion)(&journal->j_recovery_work)){+.+.}-{0:0}, at: process_scheduled_works+0x976/0x1840 kernel/workqueue.c:3317

stack backtrace:
CPU: 0 UID: 0 PID: 1142 Comm: kworker/u8:6 Not tainted 6.13.0-syzkaller-09793-g69b8923f5003 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 12/27/2024
Workqueue: ocfs2_wq ocfs2_complete_recovery
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
 down_read+0xb1/0xa40 kernel/locking/rwsem.c:1524
 ocfs2_finish_quota_recovery+0x15c/0x22a0 fs/ocfs2/quota_local.c:603
 ocfs2_complete_recovery+0x17c1/0x25c0 fs/ocfs2/journal.c:1357
 process_one_work kernel/workqueue.c:3236 [inline]
 process_scheduled_works+0xa66/0x1840 kernel/workqueue.c:3317
 worker_thread+0x870/0xd30 kernel/workqueue.c:3398
 kthread+0x7a9/0x920 kernel/kthread.c:464
 ret_from_fork+0x4b/0x80 arch/x86/kernel/process.c:148
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:244
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
