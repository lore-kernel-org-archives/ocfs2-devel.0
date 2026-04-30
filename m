Received: from mail-ot1-f78.google.com (mail-ot1-f78.google.com [209.85.210.78])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D5A5369211
	for <ocfs2-devel@lists.linux.dev>; Thu, 30 Apr 2026 09:11:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.78
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777540298; cv=none; b=uRNpvvhQuMN5J7cAMaz0Cv9tMgG57v4dhbcq7HIcs4hzH2/+KsU4ikpbCvfJEqgsVXjqPVT8iUsy1mX722fqQcpeasEu4okIOuQh5R7Ai0uut2hfU3HPkGqpCAk890ECUlz7sV37llmuctrTdrjQwduSdmqhorJ2c/D4AU1Bho8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777540298; c=relaxed/simple;
	bh=3BSCt88zZlpmGmS47nv6cpCD1qtmtY7WEFQc/YVXqb8=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=c86TEd4p74tqjw4dWDBVSCuzB4dWy85KloyAuiVZicIhV6pV6UxGTuvtVY/gmPFV3pOPreEWio2T/BvRVTBQjDGuAZrXzy7pcJqg2q4s8EmeIGtj1dhagcFToNGgTPHsW0rva/D16+Dzrpm3/u18B8bQn8gXP85SJAql7VnSMY8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.210.78
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-ot1-f78.google.com with SMTP id 46e09a7af769-7dcd9061254so1321164a34.0
        for <ocfs2-devel@lists.linux.dev>; Thu, 30 Apr 2026 02:11:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777540295; x=1778145095;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=vUU2FtZCTW5Ga8oe0Uhyc+HS3f+VnrJmma00GTuz3iE=;
        b=DaOOVCjzqgkxD+Abinn5dNO08XwrUoMyvNEHXljNq0CVGUzY8b2XM2z9CAKTewvYGN
         qwMR3nZGeWSZCYfRhpMna4oE1PiK2rYDP45kSNXEBQ0Qk77QfLF/IIGmD2vUuDr2yQTG
         bvdhz57W9+U/ZOdDVY14svXk9fccdXcIZQgmAkBmvcvEWIm1zrGuVaPx/cn/K+ZiBVs3
         jpJDuyXk8U14DyH56UhHMHr1mDv4flUMAiKNKDhE3U5NYq2OZ+K4fzFHOpljPknD9Xaj
         GphSmRYkTIm0lbOKxr/79XyzOCZwKmmD0IlHgg+iIYmSzICnNjpeMPexv9a30HwAxslc
         qALw==
X-Forwarded-Encrypted: i=1; AFNElJ9NbbnFBeK35nrZwIC8+n3prvvYIXBvy9Bx8dnIWeTQDeL0MBqCtU0xIH3BUSnuD3WGp23UcucyjAxwFg==@lists.linux.dev
X-Gm-Message-State: AOJu0YyfHFvcaHCCom6BmOUKcteNU8rMyuMbTAIvmbp+MY3KZIChhFZK
	Pfx/gbaIR3xcMiE6UhO4lgfbylzD7rL60+iCemGBxvwu5f5UqTlsdE2Lbqj/qG15IB1RkQOpRnP
	5wmmKhaFTtVAN/BQmZ7M5S92mvf/9YdwQrURifhg7GlnAPC+KGcW8lYfZqPQ=
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6820:4dfb:b0:685:3561:8926 with SMTP id
 006d021491bc7-6967a61ea2dmr891570eaf.45.1777540295477; Thu, 30 Apr 2026
 02:11:35 -0700 (PDT)
Date: Thu, 30 Apr 2026 02:11:35 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <69f31cc7.170a0220.3c4978.0019.GAE@google.com>
Subject: [syzbot] [ocfs2?] possible deadlock in ocfs2_run_deallocs
From: syzbot <syzbot+407d2fec3cdeb646c8f3@syzkaller.appspotmail.com>
To: jlbec@evilplan.org, joseph.qi@linux.alibaba.com, 
	linux-kernel@vger.kernel.org, mark@fasheh.com, ocfs2-devel@lists.linux.dev, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    897d54018cc9 Merge tag 'fbdev-for-7.1-rc1-2' of git://git...
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=15bfd36c580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=7f195f6be48c12ec
dashboard link: https://syzkaller.appspot.com/bug?extid=407d2fec3cdeb646c8f3
compiler:       Debian clang version 21.1.8 (++20251221033036+2078da43e25a-1~exp1~20251221153213.50), Debian LLD 21.1.8

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/d900f083ada3/non_bootable_disk-897d5401.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/6bb8e6a5e82e/vmlinux-897d5401.xz
kernel image: https://storage.googleapis.com/syzbot-assets/f5faa1e95a32/bzImage-897d5401.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+407d2fec3cdeb646c8f3@syzkaller.appspotmail.com

loop0: detected capacity change from 0 to 32768
=======================================================
WARNING: The mand mount option has been deprecated and
         and is ignored by this kernel. Remove the mand
         option from the mount to silence this warning.
=======================================================
JBD2: Ignoring recovery information on journal
ocfs2: Mounting device (7,0) on (node local, slot 0) with ordered data mode.
======================================================
WARNING: possible circular locking dependency detected
syzkaller #0 Not tainted
------------------------------------------------------
syz.0.0/5325 is trying to acquire lock:
ffff8880463a41a0 (&ocfs2_sysfile_lock_key[EXTENT_ALLOC_SYSTEM_INODE]){+.+.}-{4:4}, at: inode_lock include/linux/fs.h:1029 [inline]
ffff8880463a41a0 (&ocfs2_sysfile_lock_key[EXTENT_ALLOC_SYSTEM_INODE]){+.+.}-{4:4}, at: ocfs2_free_cached_blocks fs/ocfs2/alloc.c:6445 [inline]
ffff8880463a41a0 (&ocfs2_sysfile_lock_key[EXTENT_ALLOC_SYSTEM_INODE]){+.+.}-{4:4}, at: ocfs2_run_deallocs+0x2c4/0x1570 fs/ocfs2/alloc.c:6588

but task is already holding lock:
ffff8880463a4fa0 (&ocfs2_sysfile_lock_key[ORPHAN_DIR_SYSTEM_INODE]){+.+.}-{4:4}, at: inode_lock include/linux/fs.h:1029 [inline]
ffff8880463a4fa0 (&ocfs2_sysfile_lock_key[ORPHAN_DIR_SYSTEM_INODE]){+.+.}-{4:4}, at: ocfs2_wipe_inode fs/ocfs2/inode.c:854 [inline]
ffff8880463a4fa0 (&ocfs2_sysfile_lock_key[ORPHAN_DIR_SYSTEM_INODE]){+.+.}-{4:4}, at: ocfs2_delete_inode fs/ocfs2/inode.c:1157 [inline]
ffff8880463a4fa0 (&ocfs2_sysfile_lock_key[ORPHAN_DIR_SYSTEM_INODE]){+.+.}-{4:4}, at: ocfs2_evict_inode+0xe97/0x43b0 fs/ocfs2/inode.c:1299

which lock already depends on the new lock.


the existing dependency chain (in reverse order) is:

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
       do_iter_readv_writev+0x619/0x8c0 fs/read_write.c:-1
       vfs_writev+0x33c/0x990 fs/read_write.c:1059
       do_pwritev fs/read_write.c:1155 [inline]
       __do_sys_pwritev2 fs/read_write.c:1213 [inline]
       __se_sys_pwritev2+0x184/0x2a0 fs/read_write.c:1204
       do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
       do_syscall_64+0x15f/0xf80 arch/x86/entry/syscall_64.c:94
       entry_SYSCALL_64_after_hwframe+0x77/0x7f

-> #0 (&ocfs2_sysfile_lock_key[EXTENT_ALLOC_SYSTEM_INODE]){+.+.}-{4:4}:
       check_prev_add kernel/locking/lockdep.c:3165 [inline]
       check_prevs_add kernel/locking/lockdep.c:3284 [inline]
       validate_chain kernel/locking/lockdep.c:3908 [inline]
       __lock_acquire+0x15a5/0x2cf0 kernel/locking/lockdep.c:5237
       lock_acquire+0x106/0x350 kernel/locking/lockdep.c:5868
       down_write+0x96/0x200 kernel/locking/rwsem.c:1625
       inode_lock include/linux/fs.h:1029 [inline]
       ocfs2_free_cached_blocks fs/ocfs2/alloc.c:6445 [inline]
       ocfs2_run_deallocs+0x2c4/0x1570 fs/ocfs2/alloc.c:6588
       ocfs2_remove_value_outside+0x4dd/0x710 fs/ocfs2/xattr.c:2450
       ocfs2_xattr_block_remove fs/ocfs2/xattr.c:2502 [inline]
       ocfs2_xattr_free_block fs/ocfs2/xattr.c:2534 [inline]
       ocfs2_xattr_remove+0x684/0x1650 fs/ocfs2/xattr.c:2631
       ocfs2_wipe_inode fs/ocfs2/inode.c:884 [inline]
       ocfs2_delete_inode fs/ocfs2/inode.c:1157 [inline]
       ocfs2_evict_inode+0x140b/0x43b0 fs/ocfs2/inode.c:1299
       evict+0x61e/0xb10 fs/inode.c:841
       d_delete_notify include/linux/fsnotify.h:377 [inline]
       vfs_rmdir+0x42a/0x6e0 fs/namei.c:5379
       filename_rmdir+0x292/0x520 fs/namei.c:5421
       __do_sys_rmdir fs/namei.c:5444 [inline]
       __se_sys_rmdir+0x2e/0x140 fs/namei.c:5441
       do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
       do_syscall_64+0x15f/0xf80 arch/x86/entry/syscall_64.c:94
       entry_SYSCALL_64_after_hwframe+0x77/0x7f

other info that might help us debug this:

 Possible unsafe locking scenario:

       CPU0                    CPU1
       ----                    ----
  lock(&ocfs2_sysfile_lock_key[ORPHAN_DIR_SYSTEM_INODE]);
                               lock(&ocfs2_sysfile_lock_key[EXTENT_ALLOC_SYSTEM_INODE]);
                               lock(&ocfs2_sysfile_lock_key[ORPHAN_DIR_SYSTEM_INODE]);
  lock(&ocfs2_sysfile_lock_key[EXTENT_ALLOC_SYSTEM_INODE]);

 *** DEADLOCK ***

4 locks held by syz.0.0/5325:
 #0: ffff8880121f4410 (sb_writers#12){.+.+}-{0:0}, at: mnt_want_write+0x41/0x90 fs/namespace.c:493
 #1: ffff8880478ea5a0 (&type->i_mutex_dir_key#8/1){+.+.}-{4:4}, at: inode_lock_nested include/linux/fs.h:1074 [inline]
 #1: ffff8880478ea5a0 (&type->i_mutex_dir_key#8/1){+.+.}-{4:4}, at: __start_dirop fs/namei.c:2914 [inline]
 #1: ffff8880478ea5a0 (&type->i_mutex_dir_key#8/1){+.+.}-{4:4}, at: start_dirop fs/namei.c:2938 [inline]
 #1: ffff8880478ea5a0 (&type->i_mutex_dir_key#8/1){+.+.}-{4:4}, at: filename_rmdir+0x1cd/0x520 fs/namei.c:5414
 #2: ffff88801f538bc0 (&osb->nfs_sync_rwlock){.+.+}-{4:4}, at: ocfs2_nfs_sync_lock+0x106/0x270 fs/ocfs2/dlmglue.c:2875
 #3: ffff8880463a4fa0 (&ocfs2_sysfile_lock_key[ORPHAN_DIR_SYSTEM_INODE]){+.+.}-{4:4}, at: inode_lock include/linux/fs.h:1029 [inline]
 #3: ffff8880463a4fa0 (&ocfs2_sysfile_lock_key[ORPHAN_DIR_SYSTEM_INODE]){+.+.}-{4:4}, at: ocfs2_wipe_inode fs/ocfs2/inode.c:854 [inline]
 #3: ffff8880463a4fa0 (&ocfs2_sysfile_lock_key[ORPHAN_DIR_SYSTEM_INODE]){+.+.}-{4:4}, at: ocfs2_delete_inode fs/ocfs2/inode.c:1157 [inline]
 #3: ffff8880463a4fa0 (&ocfs2_sysfile_lock_key[ORPHAN_DIR_SYSTEM_INODE]){+.+.}-{4:4}, at: ocfs2_evict_inode+0xe97/0x43b0 fs/ocfs2/inode.c:1299

stack backtrace:
CPU: 0 UID: 0 PID: 5325 Comm: syz.0.0 Not tainted syzkaller #0 PREEMPT(full) 
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
 ocfs2_free_cached_blocks fs/ocfs2/alloc.c:6445 [inline]
 ocfs2_run_deallocs+0x2c4/0x1570 fs/ocfs2/alloc.c:6588
 ocfs2_remove_value_outside+0x4dd/0x710 fs/ocfs2/xattr.c:2450
 ocfs2_xattr_block_remove fs/ocfs2/xattr.c:2502 [inline]
 ocfs2_xattr_free_block fs/ocfs2/xattr.c:2534 [inline]
 ocfs2_xattr_remove+0x684/0x1650 fs/ocfs2/xattr.c:2631
 ocfs2_wipe_inode fs/ocfs2/inode.c:884 [inline]
 ocfs2_delete_inode fs/ocfs2/inode.c:1157 [inline]
 ocfs2_evict_inode+0x140b/0x43b0 fs/ocfs2/inode.c:1299
 evict+0x61e/0xb10 fs/inode.c:841
 d_delete_notify include/linux/fsnotify.h:377 [inline]
 vfs_rmdir+0x42a/0x6e0 fs/namei.c:5379
 filename_rmdir+0x292/0x520 fs/namei.c:5421
 __do_sys_rmdir fs/namei.c:5444 [inline]
 __se_sys_rmdir+0x2e/0x140 fs/namei.c:5441
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0x15f/0xf80 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f199c39cdd9
Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f199d1c2fe8 EFLAGS: 00000246 ORIG_RAX: 0000000000000054
RAX: ffffffffffffffda RBX: 00007f199c615fa0 RCX: 00007f199c39cdd9
RDX: 0000000000000000 RSI: 0000000000000000 RDI: 00002000000004c0
RBP: 00007f199c432d69 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007f199c616038 R14: 00007f199c615fa0 R15: 00007ffc64349488
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
