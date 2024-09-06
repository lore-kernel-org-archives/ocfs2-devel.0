Received: from mail-io1-f71.google.com (mail-io1-f71.google.com [209.85.166.71])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 140F02D045
	for <ocfs2-devel@lists.linux.dev>; Fri,  6 Sep 2024 16:20:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.71
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725639630; cv=none; b=RHX78oulpf3PcS7B6Tu8NICJVspYR2vFKM855eodPkhaO5hYy0aFeFB6WcqkpUIebonsNjz7gk5if1uXwAqnaPfEfjGYbxm0vBgA5gWFCHIfz4vNJcqxA9jwRhT47LN3NwYahe8BQ1MVvJ9nhimid22JODaZGr+Qy7ZIKJOoNZs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725639630; c=relaxed/simple;
	bh=8phRWTUPx/h63ImVyA2fWukk+9GaTu/ewCFKTSB4t9w=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=O0FQWhyeKd3prVY/3if0xVvvXn2MBaVPgE4QfBWkhBxl7KT5XX2J0zz0WlKjhR0LeOis5HRYUYx2uMXWTO+iZ6rFq6m7RjH3fPSHJb7XIIg3xV5iwccLeeHaclOLeXqZeGJ9wwmRhvzeBfTsAy77tGj/lgzadJ9FKKp8G64Zer4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.71
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-io1-f71.google.com with SMTP id ca18e2360f4ac-82a3fa4ecd3so491626339f.1
        for <ocfs2-devel@lists.linux.dev>; Fri, 06 Sep 2024 09:20:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725639628; x=1726244428;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=OzgTD5nDx4mrru7Wd0mjDvl8Z+hQAv0pV9FuX0feNc8=;
        b=XCgcDRlTQHweOgceaSOwfWhRqCkbye38JwuOa6QbHxL4x1yO9JBDtWpCfr8nrgNd6Y
         afMnmqtxWKfVLwXHlQsJSoqF3VOhAApmu+F1+cLL/vXVVDrbAvwUeBKe2vdxTHihk2F2
         NXOjnEyTMGfgRjnXYoQ7dAw+8t4psl9JhO4NjlL3rlb1RpLin93gguC+JsYwM7nsqE/8
         5qmaTgvSjpZUsurHUC10pp482SJcg2rFoanYUupZBfO/D6INFFjqJPrbKNv7dvPQq66z
         TgBWG8V0Kwu16ZoNzA6yi/a4dq/ZbSDoIsmB0irtaA82C1Dmar6yApn7pcIrOuvVrzBT
         6eeQ==
X-Forwarded-Encrypted: i=1; AJvYcCVqFgxNI3pagF83XfFjMYy+VJEzDPlrj1kN749xQxX9jtw7S8Np0v5JOy64x2a6kA/Uz1CgG9Sw0sV1mg==@lists.linux.dev
X-Gm-Message-State: AOJu0Yx6P8mIuRnk1kuZpJssOAPrx00pITdRLsqovXQn0x0T6Pcs7s/u
	W5I/CEhrR6yPUVwXF8uHwkHEo7/bMtHFrh7xNVCuWe6yfgWomjjixWknzx7g8iTzZ54IPTztdCR
	ZmX4Q9N/fEM4leCPrkiAVPKNTCwusCKLcDveX7198LmWhOSMl+2seFk8=
X-Google-Smtp-Source: AGHT+IEuBLB1xGqeHl3LSc8yrhQ1mQowNq2ECAFReKXZ8rrxI1S6P2hl+1wpMLW6zD++2Ie21kc5uh1Dx0tOgFLy8oxrdc3opKs2
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6638:6c84:b0:4b9:e5b4:67fd with SMTP id
 8926c6da1cb9f-4d084e65b5dmr167888173.1.1725639628249; Fri, 06 Sep 2024
 09:20:28 -0700 (PDT)
Date: Fri, 06 Sep 2024 09:20:28 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000000d6e15062175c9ae@google.com>
Subject: [syzbot] [ocfs2?] possible deadlock in ocfs2_lock_refcount_tree
From: syzbot <syzbot+285cfeaeb4ba53a373aa@syzkaller.appspotmail.com>
To: jlbec@evilplan.org, joseph.qi@linux.alibaba.com, 
	linux-kernel@vger.kernel.org, mark@fasheh.com, ocfs2-devel@lists.linux.dev, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    67784a74e258 Merge tag 'ata-6.11-rc7' of git://git.kernel...
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=11ed88af980000
kernel config:  https://syzkaller.appspot.com/x/.config?x=660f6eb11f9c7dc5
dashboard link: https://syzkaller.appspot.com/bug?extid=285cfeaeb4ba53a373aa
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/7bc7510fe41f/non_bootable_disk-67784a74.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/e2f2583cf0b1/vmlinux-67784a74.xz
kernel image: https://storage.googleapis.com/syzbot-assets/0fedd864addd/bzImage-67784a74.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+285cfeaeb4ba53a373aa@syzkaller.appspotmail.com

loop0: detected capacity change from 0 to 32768
BTRFS: device fsid ed167579-eb65-4e76-9a50-61ac97e9b59d devid 1 transid 8 /dev/loop0 (7:0) scanned by syz.0.0 (5106)
BTRFS info (device loop0): first mount of filesystem ed167579-eb65-4e76-9a50-61ac97e9b59d
BTRFS info (device loop0): using sha256 (sha256-avx2) checksum algorithm
BTRFS error (device loop0): superblock checksum mismatch
BTRFS error (device loop0): open_ctree failed
loop0: detected capacity change from 0 to 32768
=======================================================
WARNING: The mand mount option has been deprecated and
         and is ignored by this kernel. Remove the mand
         option from the mount to silence this warning.
=======================================================
ocfs2: Mounting device (7,0) on (node local, slot 0) with ordered data mode.
======================================================
WARNING: possible circular locking dependency detected
6.11.0-rc6-syzkaller-00019-g67784a74e258 #0 Not tainted
------------------------------------------------------
syz.0.0/5106 is trying to acquire lock:
ffff888040fa4098 (&new->rf_sem){+.+.}-{3:3}, at: __ocfs2_lock_refcount_tree fs/ocfs2/refcounttree.c:427 [inline]
ffff888040fa4098 (&new->rf_sem){+.+.}-{3:3}, at: ocfs2_lock_refcount_tree+0x1fe/0xa70 fs/ocfs2/refcounttree.c:462

but task is already holding lock:
ffff8880413b8660 (&ocfs2_file_ip_alloc_sem_key){++++}-{3:3}, at: ocfs2_truncate_file+0x372/0x1560 fs/ocfs2/file.c:471

which lock already depends on the new lock.


the existing dependency chain (in reverse order) is:

-> #2 (&ocfs2_file_ip_alloc_sem_key){++++}-{3:3}:
       lock_acquire+0x1ed/0x550 kernel/locking/lockdep.c:5759
       down_read+0xb1/0xa40 kernel/locking/rwsem.c:1526
       ocfs2_read_virt_blocks+0x2ca/0xa50 fs/ocfs2/extent_map.c:976
       ocfs2_read_dir_block fs/ocfs2/dir.c:508 [inline]
       ocfs2_find_entry_el fs/ocfs2/dir.c:715 [inline]
       ocfs2_find_entry+0x43b/0x2780 fs/ocfs2/dir.c:1080
       ocfs2_find_files_on_disk+0xff/0x360 fs/ocfs2/dir.c:1980
       ocfs2_lookup_ino_from_name+0xb1/0x1e0 fs/ocfs2/dir.c:2002
       _ocfs2_get_system_file_inode fs/ocfs2/sysfile.c:136 [inline]
       ocfs2_get_system_file_inode+0x305/0x7b0 fs/ocfs2/sysfile.c:112
       ocfs2_init_global_system_inodes+0x32c/0x730 fs/ocfs2/super.c:457
       ocfs2_initialize_super fs/ocfs2/super.c:2250 [inline]
       ocfs2_fill_super+0x3068/0x5880 fs/ocfs2/super.c:994
       mount_bdev+0x20a/0x2d0 fs/super.c:1679
       legacy_get_tree+0xee/0x190 fs/fs_context.c:662
       vfs_get_tree+0x90/0x2b0 fs/super.c:1800
       do_new_mount+0x2be/0xb40 fs/namespace.c:3472
       do_mount fs/namespace.c:3812 [inline]
       __do_sys_mount fs/namespace.c:4020 [inline]
       __se_sys_mount+0x2d6/0x3c0 fs/namespace.c:3997
       do_syscall_x64 arch/x86/entry/common.c:52 [inline]
       do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
       entry_SYSCALL_64_after_hwframe+0x77/0x7f

-> #1 (&osb->system_file_mutex){+.+.}-{3:3}:
       lock_acquire+0x1ed/0x550 kernel/locking/lockdep.c:5759
       __mutex_lock_common kernel/locking/mutex.c:608 [inline]
       __mutex_lock+0x136/0xd70 kernel/locking/mutex.c:752
       ocfs2_get_system_file_inode+0x18f/0x7b0 fs/ocfs2/sysfile.c:101
       ocfs2_reserve_suballoc_bits+0x16f/0x4eb0 fs/ocfs2/suballoc.c:780
       ocfs2_reserve_new_metadata_blocks+0x41c/0x9c0 fs/ocfs2/suballoc.c:982
       ocfs2_add_refcount_flag+0x4a0/0x1150 fs/ocfs2/refcounttree.c:3683
       ocfs2_reflink_remap_extent fs/ocfs2/refcounttree.c:4542 [inline]
       ocfs2_reflink_remap_blocks+0xe58/0x1f30 fs/ocfs2/refcounttree.c:4669
       ocfs2_remap_file_range+0x600/0x8e0 fs/ocfs2/file.c:2724
       vfs_copy_file_range+0xc1f/0x1530 fs/read_write.c:1522
       __do_sys_copy_file_range fs/read_write.c:1612 [inline]
       __se_sys_copy_file_range+0x3f2/0x5d0 fs/read_write.c:1575
       do_syscall_x64 arch/x86/entry/common.c:52 [inline]
       do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
       entry_SYSCALL_64_after_hwframe+0x77/0x7f

-> #0 (&new->rf_sem){+.+.}-{3:3}:
       check_prev_add kernel/locking/lockdep.c:3133 [inline]
       check_prevs_add kernel/locking/lockdep.c:3252 [inline]
       validate_chain+0x18e0/0x5900 kernel/locking/lockdep.c:3868
       __lock_acquire+0x137a/0x2040 kernel/locking/lockdep.c:5142
       lock_acquire+0x1ed/0x550 kernel/locking/lockdep.c:5759
       down_write+0x99/0x220 kernel/locking/rwsem.c:1579
       __ocfs2_lock_refcount_tree fs/ocfs2/refcounttree.c:427 [inline]
       ocfs2_lock_refcount_tree+0x1fe/0xa70 fs/ocfs2/refcounttree.c:462
       ocfs2_commit_truncate+0xc78/0x2560 fs/ocfs2/alloc.c:7345
       ocfs2_truncate_file+0xd0e/0x1560 fs/ocfs2/file.c:509
       ocfs2_setattr+0x1217/0x1f50 fs/ocfs2/file.c:1208
       notify_change+0xbca/0xe90 fs/attr.c:503
       do_truncate+0x220/0x310 fs/open.c:65
       handle_truncate fs/namei.c:3381 [inline]
       do_open fs/namei.c:3731 [inline]
       path_openat+0x2ced/0x3470 fs/namei.c:3886
       do_filp_open+0x235/0x490 fs/namei.c:3913
       do_sys_openat2+0x13e/0x1d0 fs/open.c:1416
       do_sys_open fs/open.c:1431 [inline]
       __do_sys_open fs/open.c:1439 [inline]
       __se_sys_open fs/open.c:1435 [inline]
       __x64_sys_open+0x225/0x270 fs/open.c:1435
       do_syscall_x64 arch/x86/entry/common.c:52 [inline]
       do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
       entry_SYSCALL_64_after_hwframe+0x77/0x7f

other info that might help us debug this:

Chain exists of:
  &new->rf_sem --> &osb->system_file_mutex --> &ocfs2_file_ip_alloc_sem_key

 Possible unsafe locking scenario:

       CPU0                    CPU1
       ----                    ----
  lock(&ocfs2_file_ip_alloc_sem_key);
                               lock(&osb->system_file_mutex);
                               lock(&ocfs2_file_ip_alloc_sem_key);
  lock(&new->rf_sem);

 *** DEADLOCK ***

3 locks held by syz.0.0/5106:
 #0: ffff888040330420 (sb_writers#10){.+.+}-{0:0}, at: mnt_want_write+0x3f/0x90 fs/namespace.c:515
 #1: ffff8880413b89c0 (&sb->s_type->i_mutex_key#19){+.+.}-{3:3}, at: inode_lock include/linux/fs.h:800 [inline]
 #1: ffff8880413b89c0 (&sb->s_type->i_mutex_key#19){+.+.}-{3:3}, at: do_truncate+0x20c/0x310 fs/open.c:63
 #2: ffff8880413b8660 (&ocfs2_file_ip_alloc_sem_key){++++}-{3:3}, at: ocfs2_truncate_file+0x372/0x1560 fs/ocfs2/file.c:471

stack backtrace:
CPU: 0 UID: 0 PID: 5106 Comm: syz.0.0 Not tainted 6.11.0-rc6-syzkaller-00019-g67784a74e258 #0
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2~bpo12+1 04/01/2014
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:93 [inline]
 dump_stack_lvl+0x241/0x360 lib/dump_stack.c:119
 check_noncircular+0x36a/0x4a0 kernel/locking/lockdep.c:2186
 check_prev_add kernel/locking/lockdep.c:3133 [inline]
 check_prevs_add kernel/locking/lockdep.c:3252 [inline]
 validate_chain+0x18e0/0x5900 kernel/locking/lockdep.c:3868
 __lock_acquire+0x137a/0x2040 kernel/locking/lockdep.c:5142
 lock_acquire+0x1ed/0x550 kernel/locking/lockdep.c:5759
 down_write+0x99/0x220 kernel/locking/rwsem.c:1579
 __ocfs2_lock_refcount_tree fs/ocfs2/refcounttree.c:427 [inline]
 ocfs2_lock_refcount_tree+0x1fe/0xa70 fs/ocfs2/refcounttree.c:462
 ocfs2_commit_truncate+0xc78/0x2560 fs/ocfs2/alloc.c:7345
 ocfs2_truncate_file+0xd0e/0x1560 fs/ocfs2/file.c:509
 ocfs2_setattr+0x1217/0x1f50 fs/ocfs2/file.c:1208
 notify_change+0xbca/0xe90 fs/attr.c:503
 do_truncate+0x220/0x310 fs/open.c:65
 handle_truncate fs/namei.c:3381 [inline]
 do_open fs/namei.c:3731 [inline]
 path_openat+0x2ced/0x3470 fs/namei.c:3886
 do_filp_open+0x235/0x490 fs/namei.c:3913
 do_sys_openat2+0x13e/0x1d0 fs/open.c:1416
 do_sys_open fs/open.c:1431 [inline]
 __do_sys_open fs/open.c:1439 [inline]
 __se_sys_open fs/open.c:1435 [inline]
 __x64_sys_open+0x225/0x270 fs/open.c:1435
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f4924979eb9
Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 a8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f4925732038 EFLAGS: 00000246 ORIG_RAX: 0000000000000002
RAX: ffffffffffffffda RBX: 00007f4924b15f80 RCX: 00007f4924979eb9
RDX: 0000000000000000 RSI: 000000000014d27e RDI: 0000000020000180
RBP: 00007f49249e793e R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 0000000000000000 R14: 00007f4924b15f80 R15: 00007ffd762ef968
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
