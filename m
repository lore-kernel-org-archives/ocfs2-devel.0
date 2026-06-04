Received: from mail-oo1-f77.google.com (mail-oo1-f77.google.com [209.85.161.77])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 931F33B19B4
	for <ocfs2-devel@lists.linux.dev>; Thu,  4 Jun 2026 11:18:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.77
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780571902; cv=none; b=qSm3MPokEVbB+ZLYOYm/IUn8cQblfbOiiQJfa+gy0FLjez71NCUokq6i2L1qu8prg218Z6NOblWtyCgMm16tkiy5Tpo+Vu6SuNXFmr16DU8ker4SeIFofNPIMEyH7xmyqWlYaCW+O/or6RO3Ssd8gcis0uKISBuq2R6Jest32MM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780571902; c=relaxed/simple;
	bh=d5VdWK1+H80Dsa34WO65SRkZQeGT4FmQd+DCmdv1T6c=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=aOQv/cQTwwxSOQUr6o9II8ky1Ftr9kWrV1kWWjWT1aCzPJtN5r80ox+tPfW+gQlzdgwxRIfDJqk4S/Yglbyzuyym9IVmn+vKjrXqEB799/S4wGitbAKXc1LgFAi3WbD1TuGBnY4srnTIPPmK3cWkbO0iVMWxc+TgBzT+0C/U2Wk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.161.77
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oo1-f77.google.com with SMTP id 006d021491bc7-69dc70d4b0aso1030564eaf.2
        for <ocfs2-devel@lists.linux.dev>; Thu, 04 Jun 2026 04:18:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780571899; x=1781176699;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Ubxxjku7PYwhCYZFVou8sGl7341e1/NagOd+O/zRRbI=;
        b=EZV9LacIjTa7M1cuCFyfz6sdb5AChjWHFg7RG3Z900EF81ZlwpcFtW0Hy5SHud4jfR
         BoLMGS5Eyi6jFxdRDdWe8WZUagsIQ15VDhSCZnFYVatPEgox42X7wnXxLqM0VNhZB05m
         W+EI5f09yLc06vheMetRj044nUdi+A72lbjOV1oCesFBPrne1QlX+d0Nkh8/uLuxp7VW
         GSc1Vc9nOE9ib+saUr5NGEEdCCnSJC5gEvD0lrvNblEOWe5zd3CEpwxCA4B/+NoTfNG5
         Apzw6i/cAd3xsXI9dxl9b/bhR1O4ZrOdQRfZfLmylKmmbG2s5aRkK8lN+dLVqI8HHgMI
         POUQ==
X-Forwarded-Encrypted: i=1; AFNElJ/sYCds0KKK2/0iW8GR+Auq4JFcgn94J/H3Yo12nT7xqNJMdw+lyQI4UlyzEiQSgSuiedvwni84CwQhwA==@lists.linux.dev
X-Gm-Message-State: AOJu0Yw5d1yOodDs1bc+2LAaqA1cWgYaeE5VjMQAR1Jt8pdHlrhAfJ/O
	+Xa7HgziIByryaojEqPZyLmxpOQLdVv2AM4ngr8TGjC02dtZui5OEIvZyVZX5EhBrJLZodtZpM+
	5RvpckktRw85J9scC8x5yRnySDTubDY9uaII/Y9SYNws7cMtj4+qMsQ8CS3Q=
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6820:4c14:b0:696:2480:dee0 with SMTP id
 006d021491bc7-69e47f6aac5mr4109831eaf.34.1780571899601; Thu, 04 Jun 2026
 04:18:19 -0700 (PDT)
Date: Thu, 04 Jun 2026 04:18:19 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6a215efb.e4db5ad2.5fee4.005e.GAE@google.com>
Subject: [syzbot] [ocfs2?] possible deadlock in ocfs2_remove_refcount_tree
From: syzbot <syzbot+ad7eca1cdf5d9c9db672@syzkaller.appspotmail.com>
To: jlbec@evilplan.org, joseph.qi@linux.alibaba.com, 
	linux-kernel@vger.kernel.org, mark@fasheh.com, ocfs2-devel@lists.linux.dev, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    174914ea5513 Merge tag 'v7.1-rc6-smb3-client-fixes' of git..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=15dbad2e580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=b4166e8ea5fbf7e3
dashboard link: https://syzkaller.appspot.com/bug?extid=ad7eca1cdf5d9c9db672
compiler:       Debian clang version 21.1.8 (++20251221033036+2078da43e25a-1~exp1~20251221153213.50), Debian LLD 21.1.8

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/d900f083ada3/non_bootable_disk-174914ea.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/343eb2c4ac93/vmlinux-174914ea.xz
kernel image: https://storage.googleapis.com/syzbot-assets/b9e6c020ebad/bzImage-174914ea.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+ad7eca1cdf5d9c9db672@syzkaller.appspotmail.com

======================================================
WARNING: possible circular locking dependency detected
syzkaller #0 Not tainted
------------------------------------------------------
syz.0.0/5329 is trying to acquire lock:
ffff888047a9c1a0 (&ocfs2_sysfile_lock_key[EXTENT_ALLOC_SYSTEM_INODE]){+.+.}-{4:4}, at: inode_lock include/linux/fs.h:1029 [inline]
ffff888047a9c1a0 (&ocfs2_sysfile_lock_key[EXTENT_ALLOC_SYSTEM_INODE]){+.+.}-{4:4}, at: ocfs2_remove_refcount_tree+0x58d/0xe50 fs/ocfs2/refcounttree.c:803

but task is already holding lock:
ffff888012277090 (&new->rf_sem){+.+.}-{4:4}, at: __ocfs2_lock_refcount_tree fs/ocfs2/refcounttree.c:428 [inline]
ffff888012277090 (&new->rf_sem){+.+.}-{4:4}, at: ocfs2_lock_refcount_tree+0x1b7/0xa40 fs/ocfs2/refcounttree.c:463

which lock already depends on the new lock.


the existing dependency chain (in reverse order) is:

-> #2 (&new->rf_sem){+.+.}-{4:4}:
       down_write+0x96/0x200 kernel/locking/rwsem.c:1625
       __ocfs2_lock_refcount_tree fs/ocfs2/refcounttree.c:428 [inline]
       ocfs2_lock_refcount_tree+0x1b7/0xa40 fs/ocfs2/refcounttree.c:463
       ocfs2_remove_refcount_tree+0x245/0xe50 fs/ocfs2/refcounttree.c:775
       ocfs2_wipe_inode fs/ocfs2/inode.c:890 [inline]
       ocfs2_delete_inode fs/ocfs2/inode.c:1157 [inline]
       ocfs2_evict_inode+0x142b/0x43b0 fs/ocfs2/inode.c:1299
       evict+0x61e/0xb10 fs/inode.c:841
       ocfs2_dentry_iput+0x24d/0x390 fs/ocfs2/dcache.c:407
       __dentry_kill+0x1a2/0x690 fs/dcache.c:718
       finish_dput+0xc9/0x480 fs/dcache.c:927
       __fput+0x691/0xa60 fs/file_table.c:518
       task_work_run+0x1d9/0x270 kernel/task_work.c:233
       resume_user_mode_work include/linux/resume_user_mode.h:50 [inline]
       __exit_to_user_mode_loop kernel/entry/common.c:67 [inline]
       exit_to_user_mode_loop+0x193/0x680 kernel/entry/common.c:98
       __exit_to_user_mode_prepare include/linux/irq-entry-common.h:207 [inline]
       syscall_exit_to_user_mode_prepare include/linux/irq-entry-common.h:230 [inline]
       syscall_exit_to_user_mode include/linux/entry-common.h:318 [inline]
       do_syscall_64+0x353/0x580 arch/x86/entry/syscall_64.c:100
       entry_SYSCALL_64_after_hwframe+0x77/0x7f

-> #1 (&ocfs2_sysfile_lock_key[ORPHAN_DIR_SYSTEM_INODE]){+.+.}-{4:4}:
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
       iter_file_splice_write+0x9a1/0x10f0 fs/splice.c:736
       do_splice_from fs/splice.c:936 [inline]
       direct_splice_actor+0x101/0x160 fs/splice.c:1159
       splice_direct_to_actor+0x53a/0xc70 fs/splice.c:1103
       do_splice_direct_actor fs/splice.c:1202 [inline]
       do_splice_direct+0x195/0x290 fs/splice.c:1228
       do_sendfile+0x535/0x7d0 fs/read_write.c:1372
       __do_sys_sendfile64 fs/read_write.c:1433 [inline]
       __se_sys_sendfile64+0x144/0x1a0 fs/read_write.c:1419
       do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
       do_syscall_64+0x174/0x580 arch/x86/entry/syscall_64.c:94
       entry_SYSCALL_64_after_hwframe+0x77/0x7f

-> #0 (&ocfs2_sysfile_lock_key[EXTENT_ALLOC_SYSTEM_INODE]){+.+.}-{4:4}:
       check_prev_add kernel/locking/lockdep.c:3165 [inline]
       check_prevs_add kernel/locking/lockdep.c:3284 [inline]
       validate_chain kernel/locking/lockdep.c:3908 [inline]
       __lock_acquire+0x15a5/0x2cf0 kernel/locking/lockdep.c:5237
       lock_acquire+0x106/0x350 kernel/locking/lockdep.c:5868
       down_write+0x96/0x200 kernel/locking/rwsem.c:1625
       inode_lock include/linux/fs.h:1029 [inline]
       ocfs2_remove_refcount_tree+0x58d/0xe50 fs/ocfs2/refcounttree.c:803
       ocfs2_wipe_inode fs/ocfs2/inode.c:890 [inline]
       ocfs2_delete_inode fs/ocfs2/inode.c:1157 [inline]
       ocfs2_evict_inode+0x142b/0x43b0 fs/ocfs2/inode.c:1299
       evict+0x61e/0xb10 fs/inode.c:841
       ocfs2_dentry_iput+0x24d/0x390 fs/ocfs2/dcache.c:407
       __dentry_kill+0x1a2/0x690 fs/dcache.c:718
       finish_dput+0xc9/0x480 fs/dcache.c:927
       __fput+0x691/0xa60 fs/file_table.c:518
       task_work_run+0x1d9/0x270 kernel/task_work.c:233
       resume_user_mode_work include/linux/resume_user_mode.h:50 [inline]
       __exit_to_user_mode_loop kernel/entry/common.c:67 [inline]
       exit_to_user_mode_loop+0x193/0x680 kernel/entry/common.c:98
       __exit_to_user_mode_prepare include/linux/irq-entry-common.h:207 [inline]
       syscall_exit_to_user_mode_prepare include/linux/irq-entry-common.h:230 [inline]
       syscall_exit_to_user_mode include/linux/entry-common.h:318 [inline]
       do_syscall_64+0x353/0x580 arch/x86/entry/syscall_64.c:100
       entry_SYSCALL_64_after_hwframe+0x77/0x7f

other info that might help us debug this:

Chain exists of:
  &ocfs2_sysfile_lock_key[EXTENT_ALLOC_SYSTEM_INODE] --> &ocfs2_sysfile_lock_key[ORPHAN_DIR_SYSTEM_INODE] --> &new->rf_sem

 Possible unsafe locking scenario:

       CPU0                    CPU1
       ----                    ----
  lock(&new->rf_sem);
                               lock(&ocfs2_sysfile_lock_key[ORPHAN_DIR_SYSTEM_INODE]);
                               lock(&new->rf_sem);
  lock(&ocfs2_sysfile_lock_key[EXTENT_ALLOC_SYSTEM_INODE]);

 *** DEADLOCK ***

3 locks held by syz.0.0/5329:
 #0: ffff888012048bc0 (&osb->nfs_sync_rwlock){.+.+}-{4:4}, at: ocfs2_nfs_sync_lock+0x106/0x270 fs/ocfs2/dlmglue.c:2875
 #1: ffff888047a9cfa0 (&ocfs2_sysfile_lock_key[ORPHAN_DIR_SYSTEM_INODE]){+.+.}-{4:4}, at: inode_lock include/linux/fs.h:1029 [inline]
 #1: ffff888047a9cfa0 (&ocfs2_sysfile_lock_key[ORPHAN_DIR_SYSTEM_INODE]){+.+.}-{4:4}, at: ocfs2_wipe_inode fs/ocfs2/inode.c:854 [inline]
 #1: ffff888047a9cfa0 (&ocfs2_sysfile_lock_key[ORPHAN_DIR_SYSTEM_INODE]){+.+.}-{4:4}, at: ocfs2_delete_inode fs/ocfs2/inode.c:1157 [inline]
 #1: ffff888047a9cfa0 (&ocfs2_sysfile_lock_key[ORPHAN_DIR_SYSTEM_INODE]){+.+.}-{4:4}, at: ocfs2_evict_inode+0xe97/0x43b0 fs/ocfs2/inode.c:1299
 #2: ffff888012277090 (&new->rf_sem){+.+.}-{4:4}, at: __ocfs2_lock_refcount_tree fs/ocfs2/refcounttree.c:428 [inline]
 #2: ffff888012277090 (&new->rf_sem){+.+.}-{4:4}, at: ocfs2_lock_refcount_tree+0x1b7/0xa40 fs/ocfs2/refcounttree.c:463

stack backtrace:
CPU: 0 UID: 0 PID: 5329 Comm: syz.0.0 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
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
 ocfs2_remove_refcount_tree+0x58d/0xe50 fs/ocfs2/refcounttree.c:803
 ocfs2_wipe_inode fs/ocfs2/inode.c:890 [inline]
 ocfs2_delete_inode fs/ocfs2/inode.c:1157 [inline]
 ocfs2_evict_inode+0x142b/0x43b0 fs/ocfs2/inode.c:1299
 evict+0x61e/0xb10 fs/inode.c:841
 ocfs2_dentry_iput+0x24d/0x390 fs/ocfs2/dcache.c:407
 __dentry_kill+0x1a2/0x690 fs/dcache.c:718
 finish_dput+0xc9/0x480 fs/dcache.c:927
 __fput+0x691/0xa60 fs/file_table.c:518
 task_work_run+0x1d9/0x270 kernel/task_work.c:233
 resume_user_mode_work include/linux/resume_user_mode.h:50 [inline]
 __exit_to_user_mode_loop kernel/entry/common.c:67 [inline]
 exit_to_user_mode_loop+0x193/0x680 kernel/entry/common.c:98
 __exit_to_user_mode_prepare include/linux/irq-entry-common.h:207 [inline]
 syscall_exit_to_user_mode_prepare include/linux/irq-entry-common.h:230 [inline]
 syscall_exit_to_user_mode include/linux/entry-common.h:318 [inline]
 do_syscall_64+0x353/0x580 arch/x86/entry/syscall_64.c:100
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f1074f9ce59
Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007ffcfa6825f8 EFLAGS: 00000246 ORIG_RAX: 00000000000001b4
RAX: 0000000000000000 RBX: 00007ffcfa6826e0 RCX: 00007f1074f9ce59
RDX: 0000000000000000 RSI: 000000000000001e RDI: 0000000000000003
RBP: 0000000000012125 R08: 0000000000000001 R09: 0000000000000000
R10: 00007f1074dff030 R11: 0000000000000246 R12: 00007ffcfa682720
R13: 00007f1075215fac R14: 0000000000012813 R15: 00007f1075215fa0
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
