Received: from mail-il1-f206.google.com (mail-il1-f206.google.com [209.85.166.206])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6AFB0153BE4
	for <ocfs2-devel@lists.linux.dev>; Mon, 16 Dec 2024 03:18:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.206
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734319106; cv=none; b=cMpRGmhWVD+f9eV+H26mi/WYF0fNwBQodjOb4BssMvmj70JxuCLZdcsg8Rq0R1p7Q9Tb/vpsOmiDkD6ikte0NPuO9xIVK1gNRNfb1Ppg1HL21GD7xcv+0Jy8uxdwZQViQApMmMDquLaed8S8ExIo/PY7o1Cc95HPcRICLBqUVFY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734319106; c=relaxed/simple;
	bh=kmAWXnbtT9NzwjnEWpzrLsWh7ZK74Mgu0/hZZAp6dSs=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=spIh+oQcLH7cokeWhV8DS4HelS1AM3Zvjkzc4WORg1pugfUPg3jCmHBcCfx9hf+wtyIImTFueEq8hAoqeObQOs1gWf81uOR+QrR8kYlb3F1wOCXTy05P/fvw377rn517ENpK5jQeGzxQ3IdjcPj+vhhE4Qpxrstv8UqfRr2Y/o8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.206
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f206.google.com with SMTP id e9e14a558f8ab-3a7e0d5899bso77363115ab.0
        for <ocfs2-devel@lists.linux.dev>; Sun, 15 Dec 2024 19:18:24 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734319103; x=1734923903;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=2vyW7h4tI2ttFZnEo3UNmq+9L9o+39KwN49S1Tu9cLI=;
        b=a2m0IZWHVqZXv0Y3xi8SqqiJj+jQBQ1gsY2hnS6BI70SXb9FQ32Gu3XXj0LzZj2cTf
         +yDN5C5g56S/CLYGXLZVBDI5HRtjJVZ55Ggb2kSzlP3M2mPZgjTt3F6S76/kB1AsqCuP
         UaeiGOrsPmpy4g4yc04/72csdcAVSErfhhBk5YEIcHRLOiiMo31ZiJ1ZXfGBaflk1wIk
         tmlSb4zRChnqPt1NfvVJ0kKWolBebXU547WqN7okj5ttCdxvPd7H3mDmMfRaUs32rWMg
         W65TzMNG/159Oc0aSDmCSU0pP/GOwPtOqzE8SmpVxKMOytnUWkFoE7onUTZlCK3t+P5T
         NeZQ==
X-Forwarded-Encrypted: i=1; AJvYcCX90GuzAMzsIae+4Th+79PAVhf6z5URfeVAWcB9KKHiOAUQ8NGUwdrH80LfaThPlmELaJU5peAokvSKdQ==@lists.linux.dev
X-Gm-Message-State: AOJu0YynrMXHEkas4jSI9nYMb659pbOyAdMDeOQ/FVwOD83+Exul5Ycr
	/8vLXjwti53dvGNKCqd2qrsEBpsbFfdbgi69sz31jxOl6XtifuHv7YzavBsymHRh0AAAF00KDWK
	6e7RLmGUc/TB4Kr/Ka8yknmPzHgQGWSv62aoFXI6m9Os8mg4cWjWuCeo=
X-Google-Smtp-Source: AGHT+IFHXQrW+EoGo3IQaAnlR5d+tL1at3QcM50Ph5wlejJH5kYna5ujukASVh51EW8QnSTRHpWhyrI23oE2Ii1S0E9QGo61PmSW
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1d03:b0:3a7:e83c:2d08 with SMTP id
 e9e14a558f8ab-3aff19b773bmr104591705ab.22.1734319103735; Sun, 15 Dec 2024
 19:18:23 -0800 (PST)
Date: Sun, 15 Dec 2024 19:18:23 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <675f9bff.050a0220.37aaf.0112.GAE@google.com>
Subject: [syzbot] [ocfs2?] possible deadlock in ocfs2_try_to_free_truncate_log
From: syzbot <syzbot+add928625d526457dc43@syzkaller.appspotmail.com>
To: jlbec@evilplan.org, joseph.qi@linux.alibaba.com, 
	linux-kernel@vger.kernel.org, mark@fasheh.com, ocfs2-devel@lists.linux.dev, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    231825b2e1ff Revert "unicode: Don't special case ignorable..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=101cacdf980000
kernel config:  https://syzkaller.appspot.com/x/.config?x=fee25f93665c89ac
dashboard link: https://syzkaller.appspot.com/bug?extid=add928625d526457dc43
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/7feb34a89c2a/non_bootable_disk-231825b2.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/7a10119326d2/vmlinux-231825b2.xz
kernel image: https://storage.googleapis.com/syzbot-assets/52c921795be0/bzImage-231825b2.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+add928625d526457dc43@syzkaller.appspotmail.com

loop0: detected capacity change from 0 to 32768
=======================================================
WARNING: The mand mount option has been deprecated and
         and is ignored by this kernel. Remove the mand
         option from the mount to silence this warning.
=======================================================
ocfs2: Mounting device (7,0) on (node local, slot 0) with writeback data mode.
(syz.0.0,5313,0):ocfs2_dio_end_io:2424 ERROR: Direct IO failed, bytes = -28
loop0: detected capacity change from 32768 to 0
============================================
WARNING: possible recursive locking detected
6.13.0-rc2-syzkaller-00036-g231825b2e1ff #0 Not tainted
--------------------------------------------
syz.0.0/5313 is trying to acquire lock:
ffff888045563480 (&ocfs2_sysfile_lock_key[args->fi_sysfile_type]#5){+.+.}-{4:4}, at: inode_lock include/linux/fs.h:818 [inline]
ffff888045563480 (&ocfs2_sysfile_lock_key[args->fi_sysfile_type]#5){+.+.}-{4:4}, at: ocfs2_try_to_free_truncate_log+0xd6/0x410 fs/ocfs2/alloc.c:6124

but task is already holding lock:
ffff888045563480 (&ocfs2_sysfile_lock_key[args->fi_sysfile_type]#5){+.+.}-{4:4}, at: inode_lock include/linux/fs.h:818 [inline]
ffff888045563480 (&ocfs2_sysfile_lock_key[args->fi_sysfile_type]#5){+.+.}-{4:4}, at: ocfs2_defrag_extent fs/ocfs2/move_extents.c:247 [inline]
ffff888045563480 (&ocfs2_sysfile_lock_key[args->fi_sysfile_type]#5){+.+.}-{4:4}, at: __ocfs2_move_extents_range+0x1543/0x4440 fs/ocfs2/move_extents.c:857

other info that might help us debug this:
 Possible unsafe locking scenario:

       CPU0
       ----
  lock(&ocfs2_sysfile_lock_key[args->fi_sysfile_type]#5);
  lock(&ocfs2_sysfile_lock_key[args->fi_sysfile_type]#5);

 *** DEADLOCK ***

 May be due to missing lock nesting notation

6 locks held by syz.0.0/5313:
 #0: ffff888043d2a420 (sb_writers#13){.+.+}-{0:0}, at: mnt_want_write_file+0x5e/0x200 fs/namespace.c:559
 #1: ffff8880455642c0 (&sb->s_type->i_mutex_key#21){+.+.}-{4:4}, at: inode_lock include/linux/fs.h:818 [inline]
 #1: ffff8880455642c0 (&sb->s_type->i_mutex_key#21){+.+.}-{4:4}, at: ocfs2_move_extents+0x1c5/0xac0 fs/ocfs2/move_extents.c:905
 #2: ffff888045563f60 (&oi->ip_alloc_sem){++++}-{4:4}, at: ocfs2_move_extents+0x3cb/0xac0 fs/ocfs2/move_extents.c:925
 #3: ffff8880126a4898 (&new->rf_sem){+.+.}-{4:4}, at: __ocfs2_lock_refcount_tree fs/ocfs2/refcounttree.c:428 [inline]
 #3: ffff8880126a4898 (&new->rf_sem){+.+.}-{4:4}, at: ocfs2_lock_refcount_tree+0x1fe/0xa70 fs/ocfs2/refcounttree.c:463
 #4: ffff88804555ed80 (&ocfs2_sysfile_lock_key[args->fi_sysfile_type]#3){+.+.}-{4:4}, at: inode_lock include/linux/fs.h:818 [inline]
 #4: ffff88804555ed80 (&ocfs2_sysfile_lock_key[args->fi_sysfile_type]#3){+.+.}-{4:4}, at: ocfs2_reserve_suballoc_bits+0x192/0x4e70 fs/ocfs2/suballoc.c:786
 #5: ffff888045563480 (&ocfs2_sysfile_lock_key[args->fi_sysfile_type]#5){+.+.}-{4:4}, at: inode_lock include/linux/fs.h:818 [inline]
 #5: ffff888045563480 (&ocfs2_sysfile_lock_key[args->fi_sysfile_type]#5){+.+.}-{4:4}, at: ocfs2_defrag_extent fs/ocfs2/move_extents.c:247 [inline]
 #5: ffff888045563480 (&ocfs2_sysfile_lock_key[args->fi_sysfile_type]#5){+.+.}-{4:4}, at: __ocfs2_move_extents_range+0x1543/0x4440 fs/ocfs2/move_extents.c:857

stack backtrace:
CPU: 0 UID: 0 PID: 5313 Comm: syz.0.0 Not tainted 6.13.0-rc2-syzkaller-00036-g231825b2e1ff #0
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2~bpo12+1 04/01/2014
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:94 [inline]
 dump_stack_lvl+0x241/0x360 lib/dump_stack.c:120
 print_deadlock_bug+0x483/0x620 kernel/locking/lockdep.c:3037
 check_deadlock kernel/locking/lockdep.c:3089 [inline]
 validate_chain+0x15e2/0x5920 kernel/locking/lockdep.c:3891
 __lock_acquire+0x1397/0x2100 kernel/locking/lockdep.c:5226
 lock_acquire+0x1ed/0x550 kernel/locking/lockdep.c:5849
 down_write+0x99/0x220 kernel/locking/rwsem.c:1577
 inode_lock include/linux/fs.h:818 [inline]
 ocfs2_try_to_free_truncate_log+0xd6/0x410 fs/ocfs2/alloc.c:6124
 ocfs2_reserve_clusters_with_limit+0x4ea/0xb60 fs/ocfs2/suballoc.c:1184
 ocfs2_defrag_extent fs/ocfs2/move_extents.c:266 [inline]
 __ocfs2_move_extents_range+0x19bf/0x4440 fs/ocfs2/move_extents.c:857
 ocfs2_move_extents+0x3ee/0xac0 fs/ocfs2/move_extents.c:927
 ocfs2_ioctl_move_extents+0x61a/0x830 fs/ocfs2/move_extents.c:1053
 ocfs2_ioctl+0x196/0x7d0 fs/ocfs2/ioctl.c:946
 vfs_ioctl fs/ioctl.c:51 [inline]
 __do_sys_ioctl fs/ioctl.c:906 [inline]
 __se_sys_ioctl+0xf5/0x170 fs/ioctl.c:892
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7fdccd185d19
Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 a8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007fdcce07e038 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
RAX: ffffffffffffffda RBX: 00007fdccd375fa0 RCX: 00007fdccd185d19
RDX: 0000000020000000 RSI: 0000000040406f06 RDI: 0000000000000009
RBP: 00007fdccd201a20 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 0000000000000000 R14: 00007fdccd375fa0 R15: 00007ffd50e125a8
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
