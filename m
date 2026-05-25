Received: from mail-ot1-f78.google.com (mail-ot1-f78.google.com [209.85.210.78])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 825D12F1FD7
	for <ocfs2-devel@lists.linux.dev>; Mon, 25 May 2026 15:38:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.78
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779723516; cv=none; b=RwbcWyMAI/kbDx3L4MdcZKAsR/T6xxqhrLXDX/01Dg6lA1TPtsPvVvvYnItQbn4akjM6qtzhkSjhP3NBDgi5lYb1iTs4hGMmojUOTPXjJlDZ5ev4d3wbhzGbd6if3WmrtrXNrmXk161DJpom2VvOiRHjYTbE8bZfwbUyHpvHaU4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779723516; c=relaxed/simple;
	bh=u+ohoAtMgz0kHpG867b7JhBcK4naD1MhhqbWC2DWyh8=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=TcNDgq7/RDLGipsk2zbOPPyVqXw9D8ALnhP2OTCk72lt766oZcNV1Em96RUDCHb4r3UnItCyhVsGVXLHe6+wqb4ahaJA21ckDm6hHnZWMTDasFzpvpMuZcFPYKzRHEGWvxmLgK1G2bCjOOkyY5HFwYy/tIRG8FKjShxY/AD85pM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.210.78
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-ot1-f78.google.com with SMTP id 46e09a7af769-7e4de59797fso18185823a34.3
        for <ocfs2-devel@lists.linux.dev>; Mon, 25 May 2026 08:38:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779723513; x=1780328313;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ZWUSGTKTYHhltR1HvvRe3EqnHCLwEoRx5nQFSxIuvb0=;
        b=lcM70kUyYJOFWKr3wM58rtyV9v1+tzcwg0jvSQYkFG11nX7ydD3pT4ZSQubTsaH5N0
         AL03sfpx6JO4IuE1pPTwnnguOrgoxKLZ4OHHxCsASRWG3AADzCXEop4dZdoyEpYupQA5
         oDSTbY8Rm7RWiYzdtAI36dUizDLbHMj9Brniua5yJ/Ge6HuPYu6jin9k6ts8ij7FHG61
         /jNnkXj4ovMXsgRsGTHo1hef4f5KokXJ0ebOLN1Oo/rer+0s2vGAeSXbpcG06oCgPTWc
         33rSb2x7ClgffzS1iwUHxaUGMvs9NDCeW/WKnpsOQtj1r2gV/DA2q7cePvDxPOySBvZi
         JXZg==
X-Forwarded-Encrypted: i=1; AFNElJ9iSZ7HYXfsY4BTnG2folvUgvhxfoY9O6uScDt/tIyp84yHhiwdSMwGptIOaNdeP51U/iPcGd2PmMeW5Q==@lists.linux.dev
X-Gm-Message-State: AOJu0YwH7AADiq5NJPe9LM/i3iNR8sj/VZlzk8Ng+X/yn7yMQEhlkCMu
	PNbPmboMecjfxB63Qj718FqI4eVOPyZi/psmwhcbkW8dCeuESLyt7+YEnsynpKp0IhXt+aLoyhU
	kZGTbJgkZvInZSJldFc6XYDaVHC2Kb3gCjJ+4aoijX2TGhZR+Q0ErcQCVMys=
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6820:5618:10b0:69d:9111:3eeb with SMTP id
 006d021491bc7-69d91114387mr4392399eaf.20.1779723513414; Mon, 25 May 2026
 08:38:33 -0700 (PDT)
Date: Mon, 25 May 2026 08:38:33 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6a146cf9.170a0220.22ae77.0008.GAE@google.com>
Subject: [syzbot] [ocfs2?] possible deadlock in ocfs2_del_inode_from_orphan (2)
From: syzbot <syzbot+0cc53e247e48f3b60f4d@syzkaller.appspotmail.com>
To: jlbec@evilplan.org, joseph.qi@linux.alibaba.com, 
	linux-kernel@vger.kernel.org, mark@fasheh.com, ocfs2-devel@lists.linux.dev, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    e7ae89a0c97c Linux 7.1-rc5
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=13d232a6580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=8d24a1331e060dda
dashboard link: https://syzkaller.appspot.com/bug?extid=0cc53e247e48f3b60f4d
compiler:       Debian clang version 21.1.8 (++20251221033036+2078da43e25a-1~exp1~20251221153213.50), Debian LLD 21.1.8

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/60848c96a4f9/disk-e7ae89a0.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/7c3d913edd61/vmlinux-e7ae89a0.xz
kernel image: https://storage.googleapis.com/syzbot-assets/fa9417a180e6/bzImage-e7ae89a0.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+0cc53e247e48f3b60f4d@syzkaller.appspotmail.com

======================================================
WARNING: possible circular locking dependency detected
syzkaller #0 Tainted: G             L     
------------------------------------------------------
syz.0.2196/15247 is trying to acquire lock:
ffff8880489941a0 (&ocfs2_sysfile_lock_key[ORPHAN_DIR_SYSTEM_INODE]){+.+.}-{4:4}, at: inode_lock include/linux/fs.h:1029 [inline]
ffff8880489941a0 (&ocfs2_sysfile_lock_key[ORPHAN_DIR_SYSTEM_INODE]){+.+.}-{4:4}, at: ocfs2_del_inode_from_orphan+0x12e/0x7a0 fs/ocfs2/namei.c:2728

but task is already holding lock:
ffff8880489933a0 (&ocfs2_sysfile_lock_key[EXTENT_ALLOC_SYSTEM_INODE]){+.+.}-{4:4}, at: inode_lock include/linux/fs.h:1029 [inline]
ffff8880489933a0 (&ocfs2_sysfile_lock_key[EXTENT_ALLOC_SYSTEM_INODE]){+.+.}-{4:4}, at: ocfs2_reserve_suballoc_bits+0x16d/0x4840 fs/ocfs2/suballoc.c:882

which lock already depends on the new lock.


the existing dependency chain (in reverse order) is:

-> #2 (&ocfs2_sysfile_lock_key[EXTENT_ALLOC_SYSTEM_INODE]){+.+.}-{4:4}:
       down_write+0x96/0x200 kernel/locking/rwsem.c:1625
       inode_lock include/linux/fs.h:1029 [inline]
       ocfs2_reserve_suballoc_bits+0x16d/0x4840 fs/ocfs2/suballoc.c:882
       ocfs2_reserve_new_metadata_blocks+0x415/0x9a0 fs/ocfs2/suballoc.c:1078
       ocfs2_mknod+0x10f3/0x2260 fs/ocfs2/namei.c:351
       ocfs2_mkdir+0x181/0x460 fs/ocfs2/namei.c:660
       vfs_mkdir+0x413/0x630 fs/namei.c:5261
       filename_mkdirat+0x285/0x510 fs/namei.c:5294
       __do_sys_mkdirat fs/namei.c:5315 [inline]
       __se_sys_mkdirat+0x35/0x150 fs/namei.c:5312
       do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
       do_syscall_64+0x15f/0x560 arch/x86/entry/syscall_64.c:94
       entry_SYSCALL_64_after_hwframe+0x77/0x7f

-> #1 (&ocfs2_sysfile_lock_key[INODE_ALLOC_SYSTEM_INODE]){+.+.}-{4:4}:
       down_write+0x96/0x200 kernel/locking/rwsem.c:1625
       inode_lock include/linux/fs.h:1029 [inline]
       ocfs2_remove_inode fs/ocfs2/inode.c:733 [inline]
       ocfs2_wipe_inode fs/ocfs2/inode.c:896 [inline]
       ocfs2_delete_inode fs/ocfs2/inode.c:1157 [inline]
       ocfs2_evict_inode+0x1539/0x43b0 fs/ocfs2/inode.c:1299
       evict+0x61e/0xb10 fs/inode.c:841
       ocfs2_dentry_iput+0x24d/0x390 fs/ocfs2/dcache.c:407
       __dentry_kill+0x1a2/0x690 fs/dcache.c:718
       finish_dput+0xc9/0x480 fs/dcache.c:927
       __fput+0x691/0xa60 fs/file_table.c:518
       task_work_run+0x1d9/0x270 kernel/task_work.c:233
       resume_user_mode_work include/linux/resume_user_mode.h:50 [inline]
       __exit_to_user_mode_loop kernel/entry/common.c:67 [inline]
       exit_to_user_mode_loop+0xf3/0x4d0 kernel/entry/common.c:98
       __exit_to_user_mode_prepare include/linux/irq-entry-common.h:207 [inline]
       syscall_exit_to_user_mode_prepare include/linux/irq-entry-common.h:230 [inline]
       syscall_exit_to_user_mode include/linux/entry-common.h:318 [inline]
       do_syscall_64+0x33e/0x560 arch/x86/entry/syscall_64.c:100
       entry_SYSCALL_64_after_hwframe+0x77/0x7f

-> #0 (&ocfs2_sysfile_lock_key[ORPHAN_DIR_SYSTEM_INODE]){+.+.}-{4:4}:
       check_prev_add kernel/locking/lockdep.c:3165 [inline]
       check_prevs_add kernel/locking/lockdep.c:3284 [inline]
       validate_chain kernel/locking/lockdep.c:3908 [inline]
       __lock_acquire+0x15a5/0x2cf0 kernel/locking/lockdep.c:5237
       lock_acquire+0x106/0x350 kernel/locking/lockdep.c:5868
       down_write+0x96/0x200 kernel/locking/rwsem.c:1625
       inode_lock include/linux/fs.h:1029 [inline]
       ocfs2_del_inode_from_orphan+0x12e/0x7a0 fs/ocfs2/namei.c:2728
       ocfs2_dio_end_io_write fs/ocfs2/aops.c:2379 [inline]
       ocfs2_dio_end_io+0xf9c/0x1370 fs/ocfs2/aops.c:2418
       dio_complete+0x25b/0x790 fs/direct-io.c:281
       __blockdev_direct_IO+0x2e5d/0x34e0 fs/direct-io.c:1303
       ocfs2_direct_IO+0x251/0x2c0 fs/ocfs2/aops.c:2455
       generic_file_direct_write+0x1db/0x3e0 mm/filemap.c:4259
       __generic_file_write_iter+0x11d/0x230 mm/filemap.c:4428
       ocfs2_file_write_iter+0x1663/0x1e70 fs/ocfs2/file.c:2476
       new_sync_write fs/read_write.c:595 [inline]
       vfs_write+0x61d/0xb90 fs/read_write.c:688
       ksys_write+0x150/0x270 fs/read_write.c:740
       do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
       do_syscall_64+0x15f/0x560 arch/x86/entry/syscall_64.c:94
       entry_SYSCALL_64_after_hwframe+0x77/0x7f

other info that might help us debug this:

Chain exists of:
  &ocfs2_sysfile_lock_key[ORPHAN_DIR_SYSTEM_INODE] --> &ocfs2_sysfile_lock_key[INODE_ALLOC_SYSTEM_INODE] --> &ocfs2_sysfile_lock_key[EXTENT_ALLOC_SYSTEM_INODE]

 Possible unsafe locking scenario:

       CPU0                    CPU1
       ----                    ----
  lock(&ocfs2_sysfile_lock_key[EXTENT_ALLOC_SYSTEM_INODE]);
                               lock(&ocfs2_sysfile_lock_key[INODE_ALLOC_SYSTEM_INODE]);
                               lock(&ocfs2_sysfile_lock_key[EXTENT_ALLOC_SYSTEM_INODE]);
  lock(&ocfs2_sysfile_lock_key[ORPHAN_DIR_SYSTEM_INODE]);

 *** DEADLOCK ***

4 locks held by syz.0.2196/15247:
 #0: ffff888079d71cf0 (&f->f_pos_lock){+.+.}-{4:4}, at: fdget_pos+0x246/0x320 fs/file.c:1261
 #1: ffff888050d30410 (sb_writers#26){.+.+}-{0:0}, at: file_start_write include/linux/fs.h:2724 [inline]
 #1: ffff888050d30410 (sb_writers#26){.+.+}-{0:0}, at: vfs_write+0x227/0xb90 fs/read_write.c:684
 #2: ffff88806b11eba0 (&sb->s_type->i_mutex_key#38){+.+.}-{4:4}, at: inode_lock include/linux/fs.h:1029 [inline]
 #2: ffff88806b11eba0 (&sb->s_type->i_mutex_key#38){+.+.}-{4:4}, at: ocfs2_file_write_iter+0x429/0x1e70 fs/ocfs2/file.c:2406
 #3: ffff8880489933a0 (&ocfs2_sysfile_lock_key[EXTENT_ALLOC_SYSTEM_INODE]){+.+.}-{4:4}, at: inode_lock include/linux/fs.h:1029 [inline]
 #3: ffff8880489933a0 (&ocfs2_sysfile_lock_key[EXTENT_ALLOC_SYSTEM_INODE]){+.+.}-{4:4}, at: ocfs2_reserve_suballoc_bits+0x16d/0x4840 fs/ocfs2/suballoc.c:882

stack backtrace:
CPU: 0 UID: 0 PID: 15247 Comm: syz.0.2196 Tainted: G             L      syzkaller #0 PREEMPT(full) 
Tainted: [L]=SOFTLOCKUP
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 04/18/2026
Call Trace:
 <TASK>
 dump_stack_lvl+0xe8/0x150 lib/dump_stack.c:120
 print_circular_bug+0x2e1/0x300 kernel/locking/lockdep.c:2043
 check_noncircular+0x12e/0x150 kernel/locking/lockdep.c:2175
 check_prev_add kernel/locking/lockdep.c:3165 [inline]
 check_prevs_add kernel/locking/lockdep.c:3284 [inline]
 validate_chain kernel/locking/lockdep.c:3908 [inline]
 __lock_acquire+0x15a5/0x2cf0 kernel/locking/lockdep.c:5237
 lock_acquire+0x106/0x350 kernel/locking/lockdep.c:5868
 down_write+0x96/0x200 kernel/locking/rwsem.c:1625
 inode_lock include/linux/fs.h:1029 [inline]
 ocfs2_del_inode_from_orphan+0x12e/0x7a0 fs/ocfs2/namei.c:2728
 ocfs2_dio_end_io_write fs/ocfs2/aops.c:2379 [inline]
 ocfs2_dio_end_io+0xf9c/0x1370 fs/ocfs2/aops.c:2418
 dio_complete+0x25b/0x790 fs/direct-io.c:281
 __blockdev_direct_IO+0x2e5d/0x34e0 fs/direct-io.c:1303
 ocfs2_direct_IO+0x251/0x2c0 fs/ocfs2/aops.c:2455
 generic_file_direct_write+0x1db/0x3e0 mm/filemap.c:4259
 __generic_file_write_iter+0x11d/0x230 mm/filemap.c:4428
 ocfs2_file_write_iter+0x1663/0x1e70 fs/ocfs2/file.c:2476
 new_sync_write fs/read_write.c:595 [inline]
 vfs_write+0x61d/0xb90 fs/read_write.c:688
 ksys_write+0x150/0x270 fs/read_write.c:740
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0x15f/0x560 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7efe9c19ce59
Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007efe9d09b028 EFLAGS: 00000246 ORIG_RAX: 0000000000000001
RAX: ffffffffffffffda RBX: 00007efe9c416090 RCX: 00007efe9c19ce59
RDX: 00000000ffffffd7 RSI: 0000200000000000 RDI: 0000000000000004
RBP: 00007efe9c232d6f R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007efe9c416128 R14: 00007efe9c416090 R15: 00007ffdb4582448
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
