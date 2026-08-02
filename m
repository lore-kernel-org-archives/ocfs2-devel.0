Received: from mail-oi1-f208.google.com (mail-oi1-f208.google.com [209.85.167.208])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 971021C28E
	for <ocfs2-devel@lists.linux.dev>; Sun,  2 Aug 2026 00:06:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.208
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785629193; cv=none; b=BkZc52mx8qa1sLrdcbUjjbHfy2wmJ4bLJbAI0FBimWJaVD0CzJCma2wTbR776sduD/lymRKO+45G9snEN0vgM6m9/6v7gIgcp14rHPT8WkQ0fr182GLtjSjRP0JHZNoC9nzEE7d8+yBZycpZ4EzQNPIUBJEP/vBJSPygvlhRbRk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785629193; c=relaxed/simple;
	bh=iq27bakHMm3rBoPTU/pWtZ9V7ffgLLnax96ko/4qpxA=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=WQMx4hXUkEm7Qgc30EAPGa/ZvOSDjtGPbBPz24BEmlKjDk55U/WH7A4G4ssAKNINw/K6TFO1/qGWadXabKhYEwf1ce2Wwg/IPVrM+xriOR1p+Mpl6tZ7MlP4NKbQbvcEVXxNA1DByJkYbyYW18K6JJow+9YdayUY60aNVyg4CVo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.167.208
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oi1-f208.google.com with SMTP id 5614622812f47-4ab8b646492so3880770b6e.0
        for <ocfs2-devel@lists.linux.dev>; Sat, 01 Aug 2026 17:06:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785629190; x=1786233990;
        h=content-type:to:from:subject:message-id:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Stc/Lk2NZGeObM5ubP9xhnzxA5KhG9DijZd7avRweew=;
        b=dUY4yr6YCkmkplS0NoLKs9fxIarPG+jTSbGZoZfz/s/OA8T0dFrnmeNK6lPM0plbLh
         +zPe8DzAAQ8HufZYZl9Qisv6T7uB+PfC6VFsPM4YKHIz9uJpQGjqv//IFC/5uJhBVGy1
         IopEFQK6JvzVpGFFHsXa/3yHUviyb4hptgXDKGH5v67tme1hsTdu860cryOnT8N1NLYN
         9cupLk4IWE5n6iKd8KuLaXjaVgeKOiCOE4hes47nm73M/UsiiXcjUox8RLcvNlTREc+r
         DG5uk73BcAWDjyGp8ww7Z2d6XM0Uo9Ia7Nejk/VkArQn5drNIroNDy4WxGFRBavVLPvN
         665g==
X-Forwarded-Encrypted: i=1; AHgh+RriCWD50e2uWasagzTJ3I7mqNPSZHxwsZj4pyzVwgWr3TQPli+D+BPOvNRfaB3t1M+py+0DutgJkm2CZA==@lists.linux.dev
X-Gm-Message-State: AOJu0Ywk9JUXBXx7Yoal4+MjCJe7TVcPVNagyyuFkFcxVBIhUEDww2Uz
	8mQzYtRMayOWglt7m7W1LarALlwcIfZorfmHQQ8LzpWz7yPt7H1TpB/hVdnOygOSZHK7mDaUjk+
	1yLWfANh4vpqWwFivxRPVW8qI/hq4hftVldgwfuZ3+9XLoTYfBSibnmIis4E=
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6808:250e:b0:495:f74a:b572 with SMTP id
 5614622812f47-4af5e031fb3mr8526583b6e.5.1785629190629; Sat, 01 Aug 2026
 17:06:30 -0700 (PDT)
Date: Sat, 01 Aug 2026 17:06:30 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6a6e8a06.6ce73036.24301b.0016.GAE@google.com>
Subject: [syzbot] [ocfs2?] possible deadlock in __ocfs2_reflink
From: syzbot <syzbot+7845c7b269ac2d175080@syzkaller.appspotmail.com>
To: jlbec@evilplan.org, joseph.qi@linux.alibaba.com, 
	linux-kernel@vger.kernel.org, mark@fasheh.com, ocfs2-devel@lists.linux.dev, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    3b5f4b83c4ab Merge tag 'for-7.2-rc5-tag' of git://git.kern..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=178e72a9580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=c05be6c9b0d36cb9
dashboard link: https://syzkaller.appspot.com/bug?extid=7845c7b269ac2d175080
compiler:       Debian clang version 22.1.8 (++20260613092233+e80beda6e255-1~exp1~20260613092250.77), Debian LLD 22.1.8

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/d900f083ada3/non_bootable_disk-3b5f4b83.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/bc8222697dfb/vmlinux-3b5f4b83.xz
kernel image: https://storage.googleapis.com/syzbot-assets/24ab3896211c/bzImage-3b5f4b83.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+7845c7b269ac2d175080@syzkaller.appspotmail.com


======================================================
WARNING: possible circular locking dependency detected
syzkaller #0 Not tainted
------------------------------------------------------
syz.0.0/5337 is trying to acquire lock:
ffff888044266ba0 (&sb->s_type->i_mutex_key#24/2){+.+.}-{4:4}, at: inode_lock_nested include/linux/fs.h:1069 [inline]
ffff888044266ba0 (&sb->s_type->i_mutex_key#24/2){+.+.}-{4:4}, at: __ocfs2_reflink+0xace/0x16f0 fs/ocfs2/refcounttree.c:4174

but task is already holding lock:
ffff88804426a258 (&oi->ip_alloc_sem){++++}-{4:4}, at: ocfs2_reflink+0x4d2/0x920 fs/ocfs2/refcounttree.c:4272

which lock already depends on the new lock.


the existing dependency chain (in reverse order) is:

-> #2 (&oi->ip_alloc_sem){++++}-{4:4}:
       down_read+0x4a/0x330 kernel/locking/rwsem.c:1574
       ocfs2_inode_lock_for_extent_tree+0xd6/0x190 fs/ocfs2/file.c:2222
       ocfs2_prepare_inode_for_write fs/ocfs2/file.c:2278 [inline]
       ocfs2_file_write_iter+0x6d5/0x1f10 fs/ocfs2/file.c:2463
       new_sync_write fs/read_write.c:595 [inline]
       vfs_write+0x612/0xba0 fs/read_write.c:687
       ksys_write+0x150/0x270 fs/read_write.c:739
       do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
       do_syscall_64+0x174/0x580 arch/x86/entry/syscall_64.c:94
       entry_SYSCALL_64_after_hwframe+0x77/0x7f

-> #1 (&sb->s_type->i_mutex_key#24){+.+.}-{4:4}:
       down_write+0x96/0x200 kernel/locking/rwsem.c:1631
       inode_lock include/linux/fs.h:1024 [inline]
       vfs_rename+0x6e3/0xef0 fs/namei.c:-1
       filename_renameat2+0x533/0x9a0 fs/namei.c:6192
       __do_sys_renameat2 fs/namei.c:6221 [inline]
       __se_sys_renameat2+0x5a/0x2c0 fs/namei.c:6216
       do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
       do_syscall_64+0x174/0x580 arch/x86/entry/syscall_64.c:94
       entry_SYSCALL_64_after_hwframe+0x77/0x7f

-> #0 (&sb->s_type->i_mutex_key#24/2){+.+.}-{4:4}:
       check_prev_add kernel/locking/lockdep.c:3165 [inline]
       check_prevs_add kernel/locking/lockdep.c:3284 [inline]
       validate_chain kernel/locking/lockdep.c:3908 [inline]
       __lock_acquire+0x1520/0x2cf0 kernel/locking/lockdep.c:5237
       lock_acquire+0x106/0x350 kernel/locking/lockdep.c:5868
       down_write_nested+0x9d/0x210 kernel/locking/rwsem.c:1757
       inode_lock_nested include/linux/fs.h:1069 [inline]
       __ocfs2_reflink+0xace/0x16f0 fs/ocfs2/refcounttree.c:4174
       ocfs2_reflink+0x4eb/0x920 fs/ocfs2/refcounttree.c:4273
       ocfs2_vfs_reflink+0x338/0x450 fs/ocfs2/refcounttree.c:4399
       ocfs2_reflink_ioctl+0x3a0/0x450 fs/ocfs2/refcounttree.c:4439
       ocfs2_ioctl+0x5b5/0x7e0 fs/ocfs2/ioctl.c:920
       vfs_ioctl fs/ioctl.c:51 [inline]
       __do_sys_ioctl fs/ioctl.c:597 [inline]
       __se_sys_ioctl+0xfc/0x170 fs/ioctl.c:583
       do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
       do_syscall_64+0x174/0x580 arch/x86/entry/syscall_64.c:94
       entry_SYSCALL_64_after_hwframe+0x77/0x7f

other info that might help us debug this:

Chain exists of:
  &sb->s_type->i_mutex_key#24/2 --> &sb->s_type->i_mutex_key#24 --> &oi->ip_alloc_sem

 Possible unsafe locking scenario:

       CPU0                    CPU1
       ----                    ----
  lock(&oi->ip_alloc_sem);
                               lock(&sb->s_type->i_mutex_key#24);
                               lock(&oi->ip_alloc_sem);
  lock(&sb->s_type->i_mutex_key#24/2);

 *** DEADLOCK ***

5 locks held by syz.0.0/5337:
 #0: ffff888032e58450 (sb_writers#12){.+.+}-{0:0}, at: mnt_want_write+0x41/0x90 fs/namespace.c:494
 #1: ffff88804425a5a0 (&type->i_mutex_dir_key#8/1){+.+.}-{4:4}, at: inode_lock_nested include/linux/fs.h:1069 [inline]
 #1: ffff88804425a5a0 (&type->i_mutex_dir_key#8/1){+.+.}-{4:4}, at: __start_dirop fs/namei.c:2918 [inline]
 #1: ffff88804425a5a0 (&type->i_mutex_dir_key#8/1){+.+.}-{4:4}, at: start_dirop fs/namei.c:2942 [inline]
 #1: ffff88804425a5a0 (&type->i_mutex_dir_key#8/1){+.+.}-{4:4}, at: filename_create+0x200/0x370 fs/namei.c:4955
 #2: ffff88804426a5a0 (&sb->s_type->i_mutex_key#24){+.+.}-{4:4}, at: inode_lock include/linux/fs.h:1024 [inline]
 #2: ffff88804426a5a0 (&sb->s_type->i_mutex_key#24){+.+.}-{4:4}, at: ocfs2_vfs_reflink+0x2f8/0x450 fs/ocfs2/refcounttree.c:4396
 #3: ffff88804426a2e8 (&oi->ip_xattr_sem){++++}-{4:4}, at: ocfs2_reflink+0x4c3/0x920 fs/ocfs2/refcounttree.c:4271
 #4: ffff88804426a258 (&oi->ip_alloc_sem){++++}-{4:4}, at: ocfs2_reflink+0x4d2/0x920 fs/ocfs2/refcounttree.c:4272

stack backtrace:
CPU: 0 UID: 0 PID: 5337 Comm: syz.0.0 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
Call Trace:
 <TASK>
 dump_stack_lvl+0xe8/0x150 lib/dump_stack.c:120
 print_circular_bug+0x2e1/0x300 kernel/locking/lockdep.c:2043
 check_noncircular+0x12e/0x150 kernel/locking/lockdep.c:2175
 check_prev_add kernel/locking/lockdep.c:3165 [inline]
 check_prevs_add kernel/locking/lockdep.c:3284 [inline]
 validate_chain kernel/locking/lockdep.c:3908 [inline]
 __lock_acquire+0x1520/0x2cf0 kernel/locking/lockdep.c:5237
 lock_acquire+0x106/0x350 kernel/locking/lockdep.c:5868
 down_write_nested+0x9d/0x210 kernel/locking/rwsem.c:1757
 inode_lock_nested include/linux/fs.h:1069 [inline]
 __ocfs2_reflink+0xace/0x16f0 fs/ocfs2/refcounttree.c:4174
 ocfs2_reflink+0x4eb/0x920 fs/ocfs2/refcounttree.c:4273
 ocfs2_vfs_reflink+0x338/0x450 fs/ocfs2/refcounttree.c:4399
 ocfs2_reflink_ioctl+0x3a0/0x450 fs/ocfs2/refcounttree.c:4439
 ocfs2_ioctl+0x5b5/0x7e0 fs/ocfs2/ioctl.c:920
 vfs_ioctl fs/ioctl.c:51 [inline]
 __do_sys_ioctl fs/ioctl.c:597 [inline]
 __se_sys_ioctl+0xfc/0x170 fs/ioctl.c:583
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0x174/0x580 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f690739de99
Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f69037b2fe8 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
RAX: ffffffffffffffda RBX: 00007f6907626180 RCX: 00007f690739de99
RDX: 00002000000001c0 RSI: 0000000040186f04 RDI: 0000000000000004
RBP: 00007f6907433eaf R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007f6907626218 R14: 00007f6907626180 R15: 00007ffc041371e8
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
