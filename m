Received: from mail-il1-f206.google.com (mail-il1-f206.google.com [209.85.166.206])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C97D3163
	for <ocfs2-devel@lists.linux.dev>; Fri, 14 Mar 2025 00:08:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.206
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741910915; cv=none; b=PE7xT+oscE+Iahi5HvQQvcDxbJHOfT2fnqA4rH2JY7i1MVFi1RkaZP4coSHkcmGpiYed8acihGxNoTBGR7U2nq4vmd3ZFvjdfiSZhlu2dTy3KfAP8EpGEoOmtE2/lCuzFUs/A7zkSeuQ7P9nqiRTumuc7ZupvI9uQ9XWhryIcoc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741910915; c=relaxed/simple;
	bh=pGNy51eDnoajJa2HbgSHAr7LZgBC0iiWAOJe8FITfDY=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=RitBQ08xevwKHRg1XYrHVK6NRzKRpcvb7ktVVSXigJ9qyIW7paLaQpuG7sS41T72cQUEJrhIwua/uS5V2m2ZFYNG6gL4HHnIC0C4ohfcl5w/1RwNctc4jWwMZ1Wvm9v/nAnyod8iQAK6ThqCcJvYo5lMxWxNfvF8+F9xWXMz6QE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.206
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f206.google.com with SMTP id e9e14a558f8ab-3d2b3882febso14442435ab.1
        for <ocfs2-devel@lists.linux.dev>; Thu, 13 Mar 2025 17:08:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741910913; x=1742515713;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=NMiPtOB9DsklLNfVKd75vEupRS57+byB40xw4wVgXAU=;
        b=jgFJMBTlRVVYHZOdkZk0C4TckZ+FkmwcTpWuMYNIAXCf8kkpmEi2qBxXB617m8ps67
         vFHLSblFAHBBJn91rJJKjNDbaQG+j5VPtjungXmx9jQTwFvQ5Jy69ueTlVWoIEr1piN0
         ZPV8z7nOd4AaQ9VJY73kaPLjLnt7Xnk1NRu75Hc84OzxGzndGNVh+s+kbqpas+YyHRZ8
         2g2LwiDOYSJdOo4o2CyfwLMsucRv8BTnKjFrk+kjYwuP/I4zfa8j//nKI88GuWT3qjzG
         LEHj6ZZ12FygENevsX/YS2W+kyau4fqELKx4W7jJdaxbNFu0c0W/wxZhfrzPbLnVwPPg
         +uAw==
X-Forwarded-Encrypted: i=1; AJvYcCXjl54a2Fk2LW8UZBG7D9PToH9IXFNsQ9YoWEHAqWqmfjx9/HnIakz6tZWH0CQBxH6NPoCb5Wc0sezfdg==@lists.linux.dev
X-Gm-Message-State: AOJu0YxDUK6JKjh7UcW/ay84SGWGGNBZaD9o3snAhMAWUwjBF0Py3MZJ
	iTkdJqI+tXZKPps7oViGkMOp0focPHvV3QGZWwnMPl1aezwzekHrDxJYTd1X2MHu7esbyw527if
	iIOAouFtt/3oQXh6ud+lSdMMfTvzeelQgMLQURF27+As4aBGfuNDikTo=
X-Google-Smtp-Source: AGHT+IEnA+VB5YQk0yThvvJKTYAqa2C8P8I5Vjs9/fVcf5qZmHHpwdm45B3eGrZG3nuVaAw6Rlb7mtO7DX7Xw+HbEDvrBZAK3XfG
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:2689:b0:3d4:3a45:d889 with SMTP id
 e9e14a558f8ab-3d483a6edd1mr3996435ab.14.1741910912925; Thu, 13 Mar 2025
 17:08:32 -0700 (PDT)
Date: Thu, 13 Mar 2025 17:08:32 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <67d37380.050a0220.14e108.003e.GAE@google.com>
Subject: [syzbot] [ocfs2?] possible deadlock in __ocfs2_move_extents_range
From: syzbot <syzbot+783d8c425076dd97018d@syzkaller.appspotmail.com>
To: jlbec@evilplan.org, joseph.qi@linux.alibaba.com, 
	linux-kernel@vger.kernel.org, mark@fasheh.com, ocfs2-devel@lists.linux.dev, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    0fed89a961ea Merge tag 'hyperv-fixes-signed-20250311' of g..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=1390f7a8580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=efbd4e7089941bb6
dashboard link: https://syzkaller.appspot.com/bug?extid=783d8c425076dd97018d
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/34fe3a1cd06b/disk-0fed89a9.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/7b9d33db76c1/vmlinux-0fed89a9.xz
kernel image: https://storage.googleapis.com/syzbot-assets/3f513f3da6de/bzImage-0fed89a9.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+783d8c425076dd97018d@syzkaller.appspotmail.com

ocfs2: Mounting device (7,5) on (node local, slot 0) with ordered data mode.
======================================================
WARNING: possible circular locking dependency detected
6.14.0-rc6-syzkaller-00016-g0fed89a961ea #0 Not tainted
------------------------------------------------------
syz.5.525/7461 is trying to acquire lock:
ffff88806d75b480 (&ocfs2_sysfile_lock_key[args->fi_sysfile_type]#6){+.+.}-{4:4}, at: inode_lock include/linux/fs.h:877 [inline]
ffff88806d75b480 (&ocfs2_sysfile_lock_key[args->fi_sysfile_type]#6){+.+.}-{4:4}, at: ocfs2_move_extent fs/ocfs2/move_extents.c:640 [inline]
ffff88806d75b480 (&ocfs2_sysfile_lock_key[args->fi_sysfile_type]#6){+.+.}-{4:4}, at: __ocfs2_move_extents_range+0x1f0b/0x4440 fs/ocfs2/move_extents.c:860

but task is already holding lock:
ffff888057c05f40 (&ocfs2_sysfile_lock_key[args->fi_sysfile_type]#5){+.+.}-{4:4}, at: inode_lock include/linux/fs.h:877 [inline]
ffff888057c05f40 (&ocfs2_sysfile_lock_key[args->fi_sysfile_type]#5){+.+.}-{4:4}, at: ocfs2_move_extent fs/ocfs2/move_extents.c:632 [inline]
ffff888057c05f40 (&ocfs2_sysfile_lock_key[args->fi_sysfile_type]#5){+.+.}-{4:4}, at: __ocfs2_move_extents_range+0x168f/0x4440 fs/ocfs2/move_extents.c:860

which lock already depends on the new lock.


the existing dependency chain (in reverse order) is:

-> #1 (&ocfs2_sysfile_lock_key[args->fi_sysfile_type]#5){+.+.}-{4:4}:
       lock_acquire+0x1ed/0x550 kernel/locking/lockdep.c:5851
       down_write+0x99/0x220 kernel/locking/rwsem.c:1577
       inode_lock include/linux/fs.h:877 [inline]
       __ocfs2_flush_truncate_log+0x388/0x1240 fs/ocfs2/alloc.c:6046
       ocfs2_flush_truncate_log+0x4f/0x70 fs/ocfs2/alloc.c:6076
       ocfs2_sync_fs+0x125/0x390 fs/ocfs2/super.c:406
       sync_filesystem+0x1ca/0x230 fs/sync.c:66
       generic_shutdown_super+0x72/0x2d0 fs/super.c:621
       kill_block_super+0x44/0x90 fs/super.c:1710
       deactivate_locked_super+0xc6/0x130 fs/super.c:473
       cleanup_mnt+0x41f/0x4b0 fs/namespace.c:1413
       task_work_run+0x251/0x310 kernel/task_work.c:227
       resume_user_mode_work include/linux/resume_user_mode.h:50 [inline]
       exit_to_user_mode_loop kernel/entry/common.c:114 [inline]
       exit_to_user_mode_prepare include/linux/entry-common.h:329 [inline]
       __syscall_exit_to_user_mode_work kernel/entry/common.c:207 [inline]
       syscall_exit_to_user_mode+0x13f/0x340 kernel/entry/common.c:218
       do_syscall_64+0x100/0x230 arch/x86/entry/common.c:89
       entry_SYSCALL_64_after_hwframe+0x77/0x7f

-> #0 (&ocfs2_sysfile_lock_key[args->fi_sysfile_type]#6){+.+.}-{4:4}:
       check_prev_add kernel/locking/lockdep.c:3163 [inline]
       check_prevs_add kernel/locking/lockdep.c:3282 [inline]
       validate_chain+0x18ef/0x5920 kernel/locking/lockdep.c:3906
       __lock_acquire+0x1397/0x2100 kernel/locking/lockdep.c:5228
       lock_acquire+0x1ed/0x550 kernel/locking/lockdep.c:5851
       down_write+0x99/0x220 kernel/locking/rwsem.c:1577
       inode_lock include/linux/fs.h:877 [inline]
       ocfs2_move_extent fs/ocfs2/move_extents.c:640 [inline]
       __ocfs2_move_extents_range+0x1f0b/0x4440 fs/ocfs2/move_extents.c:860
       ocfs2_move_extents+0x3ee/0xac0 fs/ocfs2/move_extents.c:927
       ocfs2_ioctl_move_extents+0x61a/0x830 fs/ocfs2/move_extents.c:1053
       ocfs2_ioctl+0x196/0x7d0 fs/ocfs2/ioctl.c:946
       vfs_ioctl fs/ioctl.c:51 [inline]
       __do_sys_ioctl fs/ioctl.c:906 [inline]
       __se_sys_ioctl+0xf7/0x170 fs/ioctl.c:892
       do_syscall_x64 arch/x86/entry/common.c:52 [inline]
       do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
       entry_SYSCALL_64_after_hwframe+0x77/0x7f

other info that might help us debug this:

 Possible unsafe locking scenario:

       CPU0                    CPU1
       ----                    ----
  lock(&ocfs2_sysfile_lock_key[args->fi_sysfile_type]#5);
                               lock(&ocfs2_sysfile_lock_key[args->fi_sysfile_type]#6);
                               lock(&ocfs2_sysfile_lock_key[args->fi_sysfile_type]#5);
  lock(&ocfs2_sysfile_lock_key[args->fi_sysfile_type]#6);

 *** DEADLOCK ***

5 locks held by syz.5.525/7461:
 #0: ffff888029ea2420 (sb_writers#14){.+.+}-{0:0}, at: mnt_want_write_file+0x5e/0x200 fs/namespace.c:591
 #1: ffff88806d75c2c0 (&sb->s_type->i_mutex_key#22){++++}-{4:4}, at: inode_lock include/linux/fs.h:877 [inline]
 #1: ffff88806d75c2c0 (&sb->s_type->i_mutex_key#22){++++}-{4:4}, at: ocfs2_move_extents+0x1c5/0xac0 fs/ocfs2/move_extents.c:905
 #2: ffff88806d75bf60 (&ocfs2_file_ip_alloc_sem_key){++++}-{4:4}, at: ocfs2_move_extents+0x3cb/0xac0 fs/ocfs2/move_extents.c:925
 #3: ffff888057c01800 (&ocfs2_sysfile_lock_key[args->fi_sysfile_type]#3){+.+.}-{4:4}, at: inode_lock include/linux/fs.h:877 [inline]
 #3: ffff888057c01800 (&ocfs2_sysfile_lock_key[args->fi_sysfile_type]#3){+.+.}-{4:4}, at: ocfs2_reserve_suballoc_bits+0x192/0x4e70 fs/ocfs2/suballoc.c:786
 #4: ffff888057c05f40 (&ocfs2_sysfile_lock_key[args->fi_sysfile_type]#5){+.+.}-{4:4}, at: inode_lock include/linux/fs.h:877 [inline]
 #4: ffff888057c05f40 (&ocfs2_sysfile_lock_key[args->fi_sysfile_type]#5){+.+.}-{4:4}, at: ocfs2_move_extent fs/ocfs2/move_extents.c:632 [inline]
 #4: ffff888057c05f40 (&ocfs2_sysfile_lock_key[args->fi_sysfile_type]#5){+.+.}-{4:4}, at: __ocfs2_move_extents_range+0x168f/0x4440 fs/ocfs2/move_extents.c:860

stack backtrace:
CPU: 1 UID: 0 PID: 7461 Comm: syz.5.525 Not tainted 6.14.0-rc6-syzkaller-00016-g0fed89a961ea #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 02/12/2025
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
 down_write+0x99/0x220 kernel/locking/rwsem.c:1577
 inode_lock include/linux/fs.h:877 [inline]
 ocfs2_move_extent fs/ocfs2/move_extents.c:640 [inline]
 __ocfs2_move_extents_range+0x1f0b/0x4440 fs/ocfs2/move_extents.c:860
 ocfs2_move_extents+0x3ee/0xac0 fs/ocfs2/move_extents.c:927
 ocfs2_ioctl_move_extents+0x61a/0x830 fs/ocfs2/move_extents.c:1053
 ocfs2_ioctl+0x196/0x7d0 fs/ocfs2/ioctl.c:946
 vfs_ioctl fs/ioctl.c:51 [inline]
 __do_sys_ioctl fs/ioctl.c:906 [inline]
 __se_sys_ioctl+0xf7/0x170 fs/ioctl.c:892
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f34aa38d169
Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 a8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f34ab23c038 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
RAX: ffffffffffffffda RBX: 00007f34aa5a5fa0 RCX: 00007f34aa38d169
RDX: 00004000000000c0 RSI: 0000000040406f06 RDI: 0000000000000004
RBP: 00007f34aa40e2a0 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 0000000000000000 R14: 00007f34aa5a5fa0 R15: 00007fff34a1f218
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
