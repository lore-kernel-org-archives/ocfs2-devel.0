Received: from mail-il1-f205.google.com (mail-il1-f205.google.com [209.85.166.205])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4A34335215
	for <ocfs2-devel@lists.linux.dev>; Mon,  5 May 2025 22:36:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.205
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746484592; cv=none; b=t7dY55K0iKaX8iRQmKLSe2QHEYggE4VEdQbMXz2bzqUAQ4KA7j4nIk7ufqvNrC5RwDDZAFZoaZwvnBD/f7q0ZwoCBhSC+jKS0fpPtk2gjiSmEt7LjWsnt1tOzVgyy37Gkm8Q+DJYj/gz1sIXtz+g+Ks7bZ7qDbaYsU0F2Qg/gXQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746484592; c=relaxed/simple;
	bh=9+S4sH3Oi7fBWWndhFeCVL+3b9Cj5GUO9GCYPbX1bMU=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=cRwu4Rk13gBF+w02yDqAGFH3NtqTPDqcRJ19VV6V2Q28HKjLb/dcvky88wFCJlLkQzgnqBGXs2hWr3TtCOoMs6ltBW2w1Dsikh7eO8esYCYGH5V3PPHn07So2yXovSji3vgZk+ul3kZPvsS1Qli9PYPyKwrNcKqHmB8t0xDI1RY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.205
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f205.google.com with SMTP id e9e14a558f8ab-3d90ba11afcso59602935ab.0
        for <ocfs2-devel@lists.linux.dev>; Mon, 05 May 2025 15:36:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746484590; x=1747089390;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=2z9Pd/Vk5Bhcd1MqY2txaj588GzMwMC6vNeVs624vsI=;
        b=YaKkt12W00mrN8i2nY0PkVDeImNgUlhsshd6yrCrZrok+maLCpiUfzlCD5RrbL8EzS
         ctUdM6kHfc4YilmlcmAw/quH19NhaIdDw5nHsmBDrx/Rl4iK0pflagcx8yopHM0ClfIP
         ziylO+gX6r6uI1o7NE/FecFzUvDZm0bunN5BMIEmDXPUwDi1BDPZLGyXobXVxML4qoAj
         e/ytlA94PiX6dFddxT3H+XDcKyceHmlXye2B3TaHw27J0XIDYwG3Hd5oHP/IcYqi84Lw
         F/MolBztz7dXujzr5SjZC//WadNMf1IqHxO/CIP6o5QuoG8zzTDbBAHK1qHZR1EprwF0
         j6Ng==
X-Forwarded-Encrypted: i=1; AJvYcCWUa136+RNy3PuD4tI+OunKU+a2nGjb1GREdaBrmKHiv5PQUOtgnps0ROfT9A1DBhuLa/lA0/fOcC+iWQ==@lists.linux.dev
X-Gm-Message-State: AOJu0Yzrrnzid+WdrhhwpOrN1D3Yru6gep175hmaw9LdYHzEwORH3WNk
	dLRyhzHx7Cpu1jymDm2sCpZ5Pf0kxjpsMmQkPx12kFLkZs3iGtjV9JX3Zs5/LANZY2lmtjlFAl7
	57y67+o8DwpfGupyOVA9Ol1UGxYvdg3GSpCvZvbXTZIabJpuhaWrYzaY=
X-Google-Smtp-Source: AGHT+IGdEh5Jeiw094ug/FrtdtXCU3SFK1IW7B/rMculblwE0oOjcDc7jEkhquqc+Mg6clUlieWgn78DefAh5chDC/J1OROpKeEv
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a92:ca4a:0:b0:3d5:81aa:4d0a with SMTP id
 e9e14a558f8ab-3da5b26eab9mr85526325ab.6.1746484589927; Mon, 05 May 2025
 15:36:29 -0700 (PDT)
Date: Mon, 05 May 2025 15:36:29 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <68193d6d.050a0220.37980e.0029.GAE@google.com>
Subject: [syzbot] [ocfs2?] possible deadlock in ocfs2_move_extent
From: syzbot <syzbot+68c788938ba0326046a9@syzkaller.appspotmail.com>
To: jlbec@evilplan.org, joseph.qi@linux.alibaba.com, 
	linux-kernel@vger.kernel.org, mark@fasheh.com, ocfs2-devel@lists.linux.dev, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    4f79eaa2ceac kbuild: Properly disable -Wunterminated-strin..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=172041cc580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=991cf8e2ade034c6
dashboard link: https://syzkaller.appspot.com/bug?extid=68c788938ba0326046a9
compiler:       gcc (Debian 12.2.0-14) 12.2.0, GNU ld (GNU Binutils for Debian) 2.40

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/16be56ff3915/disk-4f79eaa2.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/ba7f9a1ecd57/vmlinux-4f79eaa2.xz
kernel image: https://storage.googleapis.com/syzbot-assets/834807e42877/bzImage-4f79eaa2.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+68c788938ba0326046a9@syzkaller.appspotmail.com

loop0: detected capacity change from 0 to 32768
ocfs2: Mounting device (7,0) on (node local, slot 0) with ordered data mode.
======================================================
WARNING: possible circular locking dependency detected
6.15.0-rc4-syzkaller-00052-g4f79eaa2ceac #0 Not tainted
------------------------------------------------------
syz.0.30/6040 is trying to acquire lock:
ffff888076dd5100 (&ocfs2_sysfile_lock_key[args->fi_sysfile_type]#5){+.+.}-{4:4}, at: inode_lock include/linux/fs.h:867 [inline]
ffff888076dd5100 (&ocfs2_sysfile_lock_key[args->fi_sysfile_type]#5){+.+.}-{4:4}, at: ocfs2_move_extent+0x6ea/0x17f0 fs/ocfs2/move_extents.c:640

but task is already holding lock:
ffff88805a106d80 (&ocfs2_sysfile_lock_key[args->fi_sysfile_type]#6){+.+.}-{4:4}, at: inode_lock include/linux/fs.h:867 [inline]
ffff88805a106d80 (&ocfs2_sysfile_lock_key[args->fi_sysfile_type]#6){+.+.}-{4:4}, at: ocfs2_move_extent+0x429/0x17f0 fs/ocfs2/move_extents.c:632

which lock already depends on the new lock.


the existing dependency chain (in reverse order) is:

-> #1 (&ocfs2_sysfile_lock_key[args->fi_sysfile_type]#6){+.+.}-{4:4}:
       down_write+0x92/0x200 kernel/locking/rwsem.c:1577
       inode_lock include/linux/fs.h:867 [inline]
       __ocfs2_flush_truncate_log+0x31e/0x1160 fs/ocfs2/alloc.c:6054
       ocfs2_flush_truncate_log+0x4a/0x70 fs/ocfs2/alloc.c:6084
       ocfs2_sync_fs+0x1c6/0x3d0 fs/ocfs2/super.c:406
       sync_filesystem+0x1d0/0x290 fs/sync.c:66
       generic_shutdown_super+0x74/0x390 fs/super.c:621
       kill_block_super+0x3b/0x90 fs/super.c:1710
       deactivate_locked_super+0xc1/0x1a0 fs/super.c:473
       deactivate_super fs/super.c:506 [inline]
       deactivate_super+0xde/0x100 fs/super.c:502
       cleanup_mnt+0x225/0x450 fs/namespace.c:1435
       task_work_run+0x150/0x240 kernel/task_work.c:227
       resume_user_mode_work include/linux/resume_user_mode.h:50 [inline]
       exit_to_user_mode_loop kernel/entry/common.c:114 [inline]
       exit_to_user_mode_prepare include/linux/entry-common.h:329 [inline]
       __syscall_exit_to_user_mode_work kernel/entry/common.c:207 [inline]
       syscall_exit_to_user_mode+0x27b/0x2a0 kernel/entry/common.c:218
       do_syscall_64+0xda/0x260 arch/x86/entry/syscall_64.c:100
       entry_SYSCALL_64_after_hwframe+0x77/0x7f

-> #0 (&ocfs2_sysfile_lock_key[args->fi_sysfile_type]#5){+.+.}-{4:4}:
       check_prev_add kernel/locking/lockdep.c:3166 [inline]
       check_prevs_add kernel/locking/lockdep.c:3285 [inline]
       validate_chain kernel/locking/lockdep.c:3909 [inline]
       __lock_acquire+0x1173/0x1ba0 kernel/locking/lockdep.c:5235
       lock_acquire kernel/locking/lockdep.c:5866 [inline]
       lock_acquire+0x179/0x350 kernel/locking/lockdep.c:5823
       down_write+0x92/0x200 kernel/locking/rwsem.c:1577
       inode_lock include/linux/fs.h:867 [inline]
       ocfs2_move_extent+0x6ea/0x17f0 fs/ocfs2/move_extents.c:640
       __ocfs2_move_extents_range fs/ocfs2/move_extents.c:860 [inline]
       ocfs2_move_extents+0xd69/0x1980 fs/ocfs2/move_extents.c:927
       ocfs2_ioctl_move_extents+0x54d/0xb20 fs/ocfs2/move_extents.c:1053
       ocfs2_ioctl+0x3c6/0x6f0 fs/ocfs2/ioctl.c:946
       vfs_ioctl fs/ioctl.c:51 [inline]
       __do_sys_ioctl fs/ioctl.c:906 [inline]
       __se_sys_ioctl fs/ioctl.c:892 [inline]
       __x64_sys_ioctl+0x193/0x200 fs/ioctl.c:892
       do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
       do_syscall_64+0xcd/0x260 arch/x86/entry/syscall_64.c:94
       entry_SYSCALL_64_after_hwframe+0x77/0x7f

other info that might help us debug this:

 Possible unsafe locking scenario:

       CPU0                    CPU1
       ----                    ----
  lock(&ocfs2_sysfile_lock_key[args->fi_sysfile_type]#6);
                               lock(&ocfs2_sysfile_lock_key[args->fi_sysfile_type]#5);
                               lock(&ocfs2_sysfile_lock_key[args->fi_sysfile_type]#6);
  lock(&ocfs2_sysfile_lock_key[args->fi_sysfile_type]#5);

 *** DEADLOCK ***

5 locks held by syz.0.30/6040:
 #0: ffff88807ac9a420 (sb_writers#12){.+.+}-{0:0}, at: ocfs2_ioctl_move_extents+0xc4/0xb20 fs/ocfs2/move_extents.c:985
 #1: ffff888076dd5f40 (&sb->s_type->i_mutex_key#20){++++}-{4:4}, at: inode_lock include/linux/fs.h:867 [inline]
 #1: ffff888076dd5f40 (&sb->s_type->i_mutex_key#20){++++}-{4:4}, at: ocfs2_move_extents+0x1c3/0x1980 fs/ocfs2/move_extents.c:905
 #2: ffff888076dd5be0 (&oi->ip_alloc_sem){+.+.}-{4:4}, at: ocfs2_move_extents+0x429/0x1980 fs/ocfs2/move_extents.c:925
 #3: ffff888076dd1800 (&ocfs2_sysfile_lock_key[args->fi_sysfile_type]#3){+.+.}-{4:4}, at: inode_lock include/linux/fs.h:867 [inline]
 #3: ffff888076dd1800 (&ocfs2_sysfile_lock_key[args->fi_sysfile_type]#3){+.+.}-{4:4}, at: ocfs2_reserve_suballoc_bits+0x11c/0x48d0 fs/ocfs2/suballoc.c:786
 #4: ffff88805a106d80 (&ocfs2_sysfile_lock_key[args->fi_sysfile_type]#6){+.+.}-{4:4}, at: inode_lock include/linux/fs.h:867 [inline]
 #4: ffff88805a106d80 (&ocfs2_sysfile_lock_key[args->fi_sysfile_type]#6){+.+.}-{4:4}, at: ocfs2_move_extent+0x429/0x17f0 fs/ocfs2/move_extents.c:632

stack backtrace:
CPU: 1 UID: 0 PID: 6040 Comm: syz.0.30 Not tainted 6.15.0-rc4-syzkaller-00052-g4f79eaa2ceac #0 PREEMPT(full) 
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 04/19/2025
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:94 [inline]
 dump_stack_lvl+0x116/0x1f0 lib/dump_stack.c:120
 print_circular_bug+0x275/0x350 kernel/locking/lockdep.c:2079
 check_noncircular+0x14c/0x170 kernel/locking/lockdep.c:2211
 check_prev_add kernel/locking/lockdep.c:3166 [inline]
 check_prevs_add kernel/locking/lockdep.c:3285 [inline]
 validate_chain kernel/locking/lockdep.c:3909 [inline]
 __lock_acquire+0x1173/0x1ba0 kernel/locking/lockdep.c:5235
 lock_acquire kernel/locking/lockdep.c:5866 [inline]
 lock_acquire+0x179/0x350 kernel/locking/lockdep.c:5823
 down_write+0x92/0x200 kernel/locking/rwsem.c:1577
 inode_lock include/linux/fs.h:867 [inline]
 ocfs2_move_extent+0x6ea/0x17f0 fs/ocfs2/move_extents.c:640
 __ocfs2_move_extents_range fs/ocfs2/move_extents.c:860 [inline]
 ocfs2_move_extents+0xd69/0x1980 fs/ocfs2/move_extents.c:927
 ocfs2_ioctl_move_extents+0x54d/0xb20 fs/ocfs2/move_extents.c:1053
 ocfs2_ioctl+0x3c6/0x6f0 fs/ocfs2/ioctl.c:946
 vfs_ioctl fs/ioctl.c:51 [inline]
 __do_sys_ioctl fs/ioctl.c:906 [inline]
 __se_sys_ioctl fs/ioctl.c:892 [inline]
 __x64_sys_ioctl+0x193/0x200 fs/ioctl.c:892
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0xcd/0x260 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7fd0fd78e969
Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 a8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007fd0fe5d9038 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
RAX: ffffffffffffffda RBX: 00007fd0fd9b5fa0 RCX: 00007fd0fd78e969
RDX: 00002000000000c0 RSI: 0000000040406f06 RDI: 0000000000000004
RBP: 00007fd0fd810ab1 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 0000000000000000 R14: 00007fd0fd9b5fa0 R15: 00007ffe87be5778
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
