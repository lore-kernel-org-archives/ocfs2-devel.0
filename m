Received: from mail-io1-f78.google.com (mail-io1-f78.google.com [209.85.166.78])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5351217C219
	for <ocfs2-devel@lists.linux.dev>; Sat, 19 Apr 2025 11:02:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.78
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745060547; cv=none; b=r6Z2IdviDT2NSjXXlEgRebRCv/CAc6pnx4H96HP0YGL7WGh4c1k8MNqI7upgFB8xNbLHnizoSVlpeCgoGgcVbADWJZ2V2fUos30raeaP/bKxYgMZNzfMAEGAG/8OJxo69zOpWueHy4B58D5EgEyX7Hb7Sh19kUBr7I6oQhqHM1Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745060547; c=relaxed/simple;
	bh=j7FwO2l9S0QmP4nxvJ2rDoyVmG4aTFv1LllhmMD3eXY=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=iAECpYNkeR6/2FSNW3C6BJxNDtjZ0OKZTqr9rWJM4tMpOSHmCr6HPwwIiws19B7CEDyyv+A344b+4ShtkesSPPkuLdkjzRQBHqufdjehiDweMvjdhgk8vxVEU4lerUWa7z5ngwU0gywT9Kz8rlbxBo6jZcAEbQs4Im7ztRl488Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.78
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-io1-f78.google.com with SMTP id ca18e2360f4ac-849d26dd331so329086139f.1
        for <ocfs2-devel@lists.linux.dev>; Sat, 19 Apr 2025 04:02:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745060544; x=1745665344;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=dnthPBfvaEqWHBvCO77erjYDeS1wsd+KvgMIgGq5O9M=;
        b=X6mgoXyWdSEQurQqliERLTplcHdGLQrhcOKGrSZlATVhJVJ9T9yJ86vb43kBMz0u0y
         HMKonoBwbiNeKvPW2oOwQzWYQxr6QoMcHsXcHkMOEZMKMFI2rK0mNEoJCehNPHVNWSq3
         DZmvxXn0ftlqDLedM7D7SS+Ey1d5aQUGBQirP1JkQGxkFMJlRz5NLxTKPRoO1ofdjYAm
         c0ay21nPm4zd6v3aUPshOFkEZ1DeegqLgkZucngq7bbiSJPDQxLEV/METK2FIzGMgDyp
         NA6rXhJyTBXQpq8j3WLSQgsA7Z9x/SvZSn7S3UVIsJOErhdjoq1htDrOcchK08y6O9wp
         gKIA==
X-Forwarded-Encrypted: i=1; AJvYcCXUYV6fRc6yXW9XaxeSd66UU5Rr+h+4RUOm1cudYGzuX0fcwDl9L7xfeqKC1DtOcDXF16Bx41ZLiAzX0g==@lists.linux.dev
X-Gm-Message-State: AOJu0Ywo3VGrUoxRJvfjF88B0uk+u4QMuwvORugVrXz4osffe2GqwosB
	tgJoG/LTI5oCD5aHGay+4HIr+EpN2HhS6xIYlPTOvMreC5a8WVyRCT0thy8j+PccoY7KGuLf4to
	ypgz3wQaaFPS9QZxaSeMakcOJ6lmsncNBCCAHX0tu2D4NNLE63R2/R+s=
X-Google-Smtp-Source: AGHT+IHBRORsgVD6xrKi3sXfub+esEBTYoU9fRFbVL8zWu6tskX1/nBiKFsUQTcGhTkgxC8U/r8RCcuWaSzq38hVVOTgeiMQnMT1
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:b41:b0:3d5:890b:d9e1 with SMTP id
 e9e14a558f8ab-3d8b694907emr41996275ab.1.1745060544423; Sat, 19 Apr 2025
 04:02:24 -0700 (PDT)
Date: Sat, 19 Apr 2025 04:02:24 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <680382c0.050a0220.297747.001b.GAE@google.com>
Subject: [syzbot] [ocfs2?] possible deadlock in ocfs2_try_to_free_truncate_log (2)
From: syzbot <syzbot+c535cfdd86331295512d@syzkaller.appspotmail.com>
To: jlbec@evilplan.org, joseph.qi@linux.alibaba.com, 
	linux-kernel@vger.kernel.org, mark@fasheh.com, ocfs2-devel@lists.linux.dev, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    834a4a689699 Merge tag 'for-linus' of git://git.kernel.org..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=171ff398580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=a972ee73c2fcf8ca
dashboard link: https://syzkaller.appspot.com/bug?extid=c535cfdd86331295512d
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/7feb34a89c2a/non_bootable_disk-834a4a68.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/4454365a3050/vmlinux-834a4a68.xz
kernel image: https://storage.googleapis.com/syzbot-assets/2d99dbd9f6f4/bzImage-834a4a68.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+c535cfdd86331295512d@syzkaller.appspotmail.com

loop0: detected capacity change from 0 to 32768
=======================================================
WARNING: The mand mount option has been deprecated and
         and is ignored by this kernel. Remove the mand
         option from the mount to silence this warning.
=======================================================
ocfs2: Mounting device (7,0) on (node local, slot 0) with ordered data mode.
netlink: 'syz.0.0': attribute type 15 has an invalid length.
(syz.0.0,5322,0):ocfs2_dio_end_io:2398 ERROR: Direct IO failed, bytes = -28
============================================
WARNING: possible recursive locking detected
6.15.0-rc2-syzkaller-00037-g834a4a689699 #0 Not tainted
--------------------------------------------
syz.0.0/5322 is trying to acquire lock:
ffff888045d83480 (&ocfs2_sysfile_lock_key[args->fi_sysfile_type]#6){+.+.}-{4:4}, at: inode_lock include/linux/fs.h:867 [inline]
ffff888045d83480 (&ocfs2_sysfile_lock_key[args->fi_sysfile_type]#6){+.+.}-{4:4}, at: ocfs2_try_to_free_truncate_log+0xd8/0x430 fs/ocfs2/alloc.c:6132

but task is already holding lock:
ffff888045d83480 (&ocfs2_sysfile_lock_key[args->fi_sysfile_type]#6){+.+.}-{4:4}, at: inode_lock include/linux/fs.h:867 [inline]
ffff888045d83480 (&ocfs2_sysfile_lock_key[args->fi_sysfile_type]#6){+.+.}-{4:4}, at: ocfs2_defrag_extent fs/ocfs2/move_extents.c:247 [inline]
ffff888045d83480 (&ocfs2_sysfile_lock_key[args->fi_sysfile_type]#6){+.+.}-{4:4}, at: __ocfs2_move_extents_range+0x1540/0x4470 fs/ocfs2/move_extents.c:857

other info that might help us debug this:
 Possible unsafe locking scenario:

       CPU0
       ----
  lock(&ocfs2_sysfile_lock_key[args->fi_sysfile_type]#6);
  lock(&ocfs2_sysfile_lock_key[args->fi_sysfile_type]#6);

 *** DEADLOCK ***

 May be due to missing lock nesting notation

5 locks held by syz.0.0/5322:
 #0: ffff88803ee5c420 (sb_writers#12){.+.+}-{0:0}, at: mnt_want_write_file+0x5e/0x200 fs/namespace.c:600
 #1: ffff888045d842c0 (&sb->s_type->i_mutex_key#20){+.+.}-{4:4}, at: inode_lock include/linux/fs.h:867 [inline]
 #1: ffff888045d842c0 (&sb->s_type->i_mutex_key#20){+.+.}-{4:4}, at: ocfs2_move_extents+0x1c7/0xac0 fs/ocfs2/move_extents.c:905
 #2: ffff888045d83f60 (&oi->ip_alloc_sem){++++}-{4:4}, at: ocfs2_move_extents+0x3cd/0xac0 fs/ocfs2/move_extents.c:925
 #3: ffff888045d7ed80 (&ocfs2_sysfile_lock_key[args->fi_sysfile_type]#3){+.+.}-{4:4}, at: inode_lock include/linux/fs.h:867 [inline]
 #3: ffff888045d7ed80 (&ocfs2_sysfile_lock_key[args->fi_sysfile_type]#3){+.+.}-{4:4}, at: ocfs2_reserve_suballoc_bits+0x18d/0x4f30 fs/ocfs2/suballoc.c:786
 #4: ffff888045d83480 (&ocfs2_sysfile_lock_key[args->fi_sysfile_type]#6){+.+.}-{4:4}, at: inode_lock include/linux/fs.h:867 [inline]
 #4: ffff888045d83480 (&ocfs2_sysfile_lock_key[args->fi_sysfile_type]#6){+.+.}-{4:4}, at: ocfs2_defrag_extent fs/ocfs2/move_extents.c:247 [inline]
 #4: ffff888045d83480 (&ocfs2_sysfile_lock_key[args->fi_sysfile_type]#6){+.+.}-{4:4}, at: __ocfs2_move_extents_range+0x1540/0x4470 fs/ocfs2/move_extents.c:857

stack backtrace:
CPU: 0 UID: 0 PID: 5322 Comm: syz.0.0 Not tainted 6.15.0-rc2-syzkaller-00037-g834a4a689699 #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2~bpo12+1 04/01/2014
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:94 [inline]
 dump_stack_lvl+0x241/0x360 lib/dump_stack.c:120
 print_deadlock_bug+0x2be/0x2d0 kernel/locking/lockdep.c:3042
 check_deadlock kernel/locking/lockdep.c:3094 [inline]
 validate_chain+0x928/0x24e0 kernel/locking/lockdep.c:3896
 __lock_acquire+0xad5/0xd80 kernel/locking/lockdep.c:5235
 lock_acquire+0x116/0x2f0 kernel/locking/lockdep.c:5866
 down_write+0x9c/0x220 kernel/locking/rwsem.c:1577
 inode_lock include/linux/fs.h:867 [inline]
 ocfs2_try_to_free_truncate_log+0xd8/0x430 fs/ocfs2/alloc.c:6132
 ocfs2_reserve_clusters_with_limit+0x4ec/0xb60 fs/ocfs2/suballoc.c:1184
 ocfs2_defrag_extent fs/ocfs2/move_extents.c:266 [inline]
 __ocfs2_move_extents_range+0x19c8/0x4470 fs/ocfs2/move_extents.c:857
 ocfs2_move_extents+0x3f0/0xac0 fs/ocfs2/move_extents.c:927
 ocfs2_ioctl_move_extents+0x61c/0x840 fs/ocfs2/move_extents.c:1053
 ocfs2_ioctl+0x19b/0x7f0 fs/ocfs2/ioctl.c:946
 vfs_ioctl fs/ioctl.c:51 [inline]
 __do_sys_ioctl fs/ioctl.c:906 [inline]
 __se_sys_ioctl+0xf1/0x160 fs/ioctl.c:892
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0xf3/0x230 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7fe8d0d8d169
Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 a8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007fe8d1b27038 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
RAX: ffffffffffffffda RBX: 00007fe8d0fa5fa0 RCX: 00007fe8d0d8d169
RDX: 00002000000000c0 RSI: 0000000040406f06 RDI: 0000000000000004
RBP: 00007fe8d0e0e990 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 0000000000000000 R14: 00007fe8d0fa5fa0 R15: 00007ffc184f1808
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
