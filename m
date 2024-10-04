Received: from mail-il1-f198.google.com (mail-il1-f198.google.com [209.85.166.198])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 566231B7E9
	for <ocfs2-devel@lists.linux.dev>; Fri,  4 Oct 2024 01:35:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.198
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728005729; cv=none; b=LE2OdIyp/lvBhL4CPiGuMIkeg1L8w+6XHRIv6EICaxuqOjSFOWzOEbeoHtes9qA7zjMZrIc2aiEFypZc4bm3gDonmVdgK+o4e9so5sDA3qAZQts3K3lXQtw2lSwTOMVjh+mBlhFjHkWBc9BakSWa0rPz4u/slMWkb8BSX7xWW2Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728005729; c=relaxed/simple;
	bh=legLJrCYR7zOGX0wIR+H/cndK6PjMAlqdCmgs0Mt6NQ=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=XZFR/nDCaDF52OZXNTR9dfbnChTxP0JvQmUeiLFc2SPBSrrjshshZXjwDh0tzohNTvH7ZmuUpxsqD7QqejKMbGG44QJek+mdDzcndkNKMS9iaQna6wvBx/VMTeSfdve/CbIkN/VlblnbBf2C9s5UEbgiF++FSFgTh3ekb7faDIM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.198
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f198.google.com with SMTP id e9e14a558f8ab-3a1925177fdso18142445ab.3
        for <ocfs2-devel@lists.linux.dev>; Thu, 03 Oct 2024 18:35:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728005726; x=1728610526;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=dLeIhql/IKKeROf8ziR6GXTw3ynZAZr4UgrHA8vD87c=;
        b=HJ4hYzfAaksC1Ih+HbsW4DGdKUP+sebLG23pt9yPNPm67/E2J0VKKHggbgifx5B6ur
         GlBaxDIcYHUQE8bmRPKg3vzXn/dnUQBeAPJJxKZU4fvvdFbZnge7VYo6BO9vgM+tyij+
         4vaJpF6X32jaJATXa2Farp37rpEhTvUyfWrR4QbhBdgTp2Se7XP3QjVgz6SGs7Mw/eiX
         5+K5AaDM3m8PRjUH9Civ58etKBLxKOqWgL22ZzB2h/5nMNewzvVqG4IKtT89LzIpL9Qf
         wwK76mnkcL62QMimBXOq5g3dZqjoTKjb27Lb8Mfk4dQA8+qseMYMZkcfoTYIxCK9wrvv
         +qLg==
X-Forwarded-Encrypted: i=1; AJvYcCX1FOdA2LMLkkB/t0bBStN/pZCmM9OWPojYAA3qB+4TPAq4oT7Et+m/u0ECjFLCHDi3I9zOIQMqYYPTYA==@lists.linux.dev
X-Gm-Message-State: AOJu0YzmZCj2o6NOcj1KOLfoANcjwROwA1JXzcVn53SOagHjRA3d76AR
	VOH7Wigy8sFn9euVccx/f6XJkkFut6o2ArHh+ube6kFmwAeC4chHkG1YV/cJT70xc3IMOuVAY5k
	KQBZaXivFqoQKHUn14moaTBvMgv1dbTwFz3Ffsq4nwNxPl8ffKN6O8nw=
X-Google-Smtp-Source: AGHT+IFtzPm18aBQd8WK8eiL26MsyDEn/kSKHKieoCKO8+b5/p16Nfs6Fj+NqjsQxuADeW0j9zIj4ueQFHPQJQ7shETYVKqjix3P
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:184d:b0:3a0:451b:ade3 with SMTP id
 e9e14a558f8ab-3a375a978dbmr9465535ab.10.1728005726424; Thu, 03 Oct 2024
 18:35:26 -0700 (PDT)
Date: Thu, 03 Oct 2024 18:35:26 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <66ff465e.050a0220.49194.0403.GAE@google.com>
Subject: [syzbot] [ocfs2?] possible deadlock in ocfs2_calc_xattr_init
From: syzbot <syzbot+6f7edba4b1e2ca109d7f@syzkaller.appspotmail.com>
To: jlbec@evilplan.org, joseph.qi@linux.alibaba.com, 
	linux-kernel@vger.kernel.org, mark@fasheh.com, ocfs2-devel@lists.linux.dev, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    e7ed34365879 Merge tag 'mailbox-v6.12' of git://git.kernel..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=1000c127980000
kernel config:  https://syzkaller.appspot.com/x/.config?x=bf263a6a5debbeef
dashboard link: https://syzkaller.appspot.com/bug?extid=6f7edba4b1e2ca109d7f
compiler:       gcc (Debian 12.2.0-14) 12.2.0, GNU ld (GNU Binutils for Debian) 2.40

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/74f7ccd405cc/disk-e7ed3436.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/ef3b18bc5269/vmlinux-e7ed3436.xz
kernel image: https://storage.googleapis.com/syzbot-assets/54ef06c52fbb/bzImage-e7ed3436.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+6f7edba4b1e2ca109d7f@syzkaller.appspotmail.com

======================================================
WARNING: possible circular locking dependency detected
6.11.0-syzkaller-12113-ge7ed34365879 #0 Not tainted
------------------------------------------------------
syz.0.131/5956 is trying to acquire lock:
ffff888051572378 (&oi->ip_xattr_sem){++++}-{3:3}, at: ocfs2_calc_xattr_init+0x5e7/0xcc0 fs/ocfs2/xattr.c:627

but task is already holding lock:
ffff8880542c5f40 (&ocfs2_sysfile_lock_key[args->fi_sysfile_type]#4){+.+.}-{3:3}, at: inode_lock include/linux/fs.h:815 [inline]
ffff8880542c5f40 (&ocfs2_sysfile_lock_key[args->fi_sysfile_type]#4){+.+.}-{3:3}, at: ocfs2_reserve_suballoc_bits+0x11d/0x4940 fs/ocfs2/suballoc.c:786

which lock already depends on the new lock.


the existing dependency chain (in reverse order) is:

-> #3 (&ocfs2_sysfile_lock_key[args->fi_sysfile_type]#4){+.+.}-{3:3}:
       down_write+0x93/0x200 kernel/locking/rwsem.c:1577
       inode_lock include/linux/fs.h:815 [inline]
       ocfs2_remove_inode+0x15c/0x8a0 fs/ocfs2/inode.c:655
       ocfs2_wipe_inode+0x455/0x1220 fs/ocfs2/inode.c:818
       ocfs2_delete_inode fs/ocfs2/inode.c:1079 [inline]
       ocfs2_evict_inode+0x6c5/0x15d0 fs/ocfs2/inode.c:1216
       evict+0x40c/0x970 fs/inode.c:723
       iput_final fs/inode.c:1875 [inline]
       iput fs/inode.c:1901 [inline]
       iput+0x530/0x890 fs/inode.c:1887
       ocfs2_dentry_iput+0x13a/0x340 fs/ocfs2/dcache.c:411
       dentry_unlink_inode+0x282/0x480 fs/dcache.c:410
       __dentry_kill+0x1d0/0x600 fs/dcache.c:615
       dput.part.0+0x4b1/0x9b0 fs/dcache.c:857
       dput+0x1f/0x30 fs/dcache.c:847
       ovl_check_rename_whiteout fs/overlayfs/super.c:586 [inline]
       ovl_make_workdir fs/overlayfs/super.c:685 [inline]
       ovl_get_workdir fs/overlayfs/super.c:808 [inline]
       ovl_fill_super+0x1300/0x6720 fs/overlayfs/super.c:1376
       vfs_get_super fs/super.c:1280 [inline]
       get_tree_nodev+0xdd/0x190 fs/super.c:1299
       vfs_get_tree+0x92/0x380 fs/super.c:1800
       do_new_mount fs/namespace.c:3507 [inline]
       path_mount+0x14e6/0x1f20 fs/namespace.c:3834
       do_mount fs/namespace.c:3847 [inline]
       __do_sys_mount fs/namespace.c:4055 [inline]
       __se_sys_mount fs/namespace.c:4032 [inline]
       __x64_sys_mount+0x294/0x320 fs/namespace.c:4032
       do_syscall_x64 arch/x86/entry/common.c:52 [inline]
       do_syscall_64+0xcd/0x250 arch/x86/entry/common.c:83
       entry_SYSCALL_64_after_hwframe+0x77/0x7f

-> #2 (&ocfs2_sysfile_lock_key[args->fi_sysfile_type]){+.+.}-{3:3}:
       down_write+0x93/0x200 kernel/locking/rwsem.c:1577
       inode_lock include/linux/fs.h:815 [inline]
       ocfs2_del_inode_from_orphan+0x112/0x700 fs/ocfs2/namei.c:2726
       ocfs2_dio_end_io_write+0x2cc/0xf30 fs/ocfs2/aops.c:2329
       ocfs2_dio_end_io+0x139/0x2a0 fs/ocfs2/aops.c:2427
       dio_complete+0x21b/0x8e0 fs/direct-io.c:281
       __blockdev_direct_IO+0x3139/0x3d10 fs/direct-io.c:1303
       ocfs2_direct_IO+0x263/0x360 fs/ocfs2/aops.c:2464
       generic_file_direct_write+0x19a/0x410 mm/filemap.c:3977
       __generic_file_write_iter+0x11b/0x240 mm/filemap.c:4141
       ocfs2_file_write_iter+0xb70/0x20e0 fs/ocfs2/file.c:2456
       do_iter_readv_writev+0x535/0x7f0 fs/read_write.c:834
       vfs_writev+0x363/0xdd0 fs/read_write.c:1064
       do_pwritev+0x1b4/0x270 fs/read_write.c:1165
       __do_sys_pwritev2 fs/read_write.c:1224 [inline]
       __se_sys_pwritev2 fs/read_write.c:1215 [inline]
       __x64_sys_pwritev2+0xef/0x160 fs/read_write.c:1215
       do_syscall_x64 arch/x86/entry/common.c:52 [inline]
       do_syscall_64+0xcd/0x250 arch/x86/entry/common.c:83
       entry_SYSCALL_64_after_hwframe+0x77/0x7f

-> #1 (&oi->ip_alloc_sem){++++}-{3:3}:
       down_write+0x93/0x200 kernel/locking/rwsem.c:1577
       ocfs2_try_remove_refcount_tree+0xa8/0x320 fs/ocfs2/refcounttree.c:932
       ocfs2_xattr_set+0x103c/0x2a30 fs/ocfs2/xattr.c:3670
       __vfs_removexattr+0x156/0x1c0 fs/xattr.c:518
       __vfs_removexattr_locked+0x166/0x480 fs/xattr.c:553
       vfs_removexattr+0xcf/0x270 fs/xattr.c:575
       ovl_do_removexattr fs/overlayfs/overlayfs.h:332 [inline]
       ovl_removexattr fs/overlayfs/overlayfs.h:340 [inline]
       ovl_make_workdir fs/overlayfs/super.c:728 [inline]
       ovl_get_workdir fs/overlayfs/super.c:808 [inline]
       ovl_fill_super+0x4fb3/0x6720 fs/overlayfs/super.c:1376
       vfs_get_super fs/super.c:1280 [inline]
       get_tree_nodev+0xdd/0x190 fs/super.c:1299
       vfs_get_tree+0x92/0x380 fs/super.c:1800
       do_new_mount fs/namespace.c:3507 [inline]
       path_mount+0x14e6/0x1f20 fs/namespace.c:3834
       do_mount fs/namespace.c:3847 [inline]
       __do_sys_mount fs/namespace.c:4055 [inline]
       __se_sys_mount fs/namespace.c:4032 [inline]
       __x64_sys_mount+0x294/0x320 fs/namespace.c:4032
       do_syscall_x64 arch/x86/entry/common.c:52 [inline]
       do_syscall_64+0xcd/0x250 arch/x86/entry/common.c:83
       entry_SYSCALL_64_after_hwframe+0x77/0x7f

-> #0 (&oi->ip_xattr_sem){++++}-{3:3}:
       check_prev_add kernel/locking/lockdep.c:3161 [inline]
       check_prevs_add kernel/locking/lockdep.c:3280 [inline]
       validate_chain kernel/locking/lockdep.c:3904 [inline]
       __lock_acquire+0x250b/0x3ce0 kernel/locking/lockdep.c:5202
       lock_acquire.part.0+0x11b/0x380 kernel/locking/lockdep.c:5825
       down_read+0x9a/0x330 kernel/locking/rwsem.c:1524
       ocfs2_calc_xattr_init+0x5e7/0xcc0 fs/ocfs2/xattr.c:627
       ocfs2_mknod+0x9f2/0x2440 fs/ocfs2/namei.c:328
       ocfs2_create+0x185/0x450 fs/ocfs2/namei.c:672
       vfs_create fs/namei.c:3294 [inline]
       vfs_create+0x4c5/0x770 fs/namei.c:3278
       do_mknodat+0x3d5/0x5d0 fs/namei.c:4185
       __do_sys_mknod fs/namei.c:4218 [inline]
       __se_sys_mknod fs/namei.c:4216 [inline]
       __x64_sys_mknod+0x87/0xb0 fs/namei.c:4216
       do_syscall_x64 arch/x86/entry/common.c:52 [inline]
       do_syscall_64+0xcd/0x250 arch/x86/entry/common.c:83
       entry_SYSCALL_64_after_hwframe+0x77/0x7f

other info that might help us debug this:

Chain exists of:
  &oi->ip_xattr_sem --> &ocfs2_sysfile_lock_key[args->fi_sysfile_type] --> &ocfs2_sysfile_lock_key[args->fi_sysfile_type]#4

 Possible unsafe locking scenario:

       CPU0                    CPU1
       ----                    ----
  lock(&ocfs2_sysfile_lock_key[args->fi_sysfile_type]#4);
                               lock(&ocfs2_sysfile_lock_key[args->fi_sysfile_type]);
                               lock(&ocfs2_sysfile_lock_key[args->fi_sysfile_type]#4);
  rlock(&oi->ip_xattr_sem);

 *** DEADLOCK ***

3 locks held by syz.0.131/5956:
 #0: ffff88807f8de420 (sb_writers#19){.+.+}-{0:0}, at: filename_create+0x10d/0x530 fs/namei.c:4019
 #1: ffff888051572640 (&type->i_mutex_dir_key#13/1){+.+.}-{3:3}, at: inode_lock_nested include/linux/fs.h:850 [inline]
 #1: ffff888051572640 (&type->i_mutex_dir_key#13/1){+.+.}-{3:3}, at: filename_create+0x1c2/0x530 fs/namei.c:4026
 #2: ffff8880542c5f40 (&ocfs2_sysfile_lock_key[args->fi_sysfile_type]#4){+.+.}-{3:3}, at: inode_lock include/linux/fs.h:815 [inline]
 #2: ffff8880542c5f40 (&ocfs2_sysfile_lock_key[args->fi_sysfile_type]#4){+.+.}-{3:3}, at: ocfs2_reserve_suballoc_bits+0x11d/0x4940 fs/ocfs2/suballoc.c:786

stack backtrace:
CPU: 1 UID: 0 PID: 5956 Comm: syz.0.131 Not tainted 6.11.0-syzkaller-12113-ge7ed34365879 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 09/13/2024
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:94 [inline]
 dump_stack_lvl+0x116/0x1f0 lib/dump_stack.c:120
 print_circular_bug+0x41c/0x610 kernel/locking/lockdep.c:2074
 check_noncircular+0x31a/0x400 kernel/locking/lockdep.c:2206
 check_prev_add kernel/locking/lockdep.c:3161 [inline]
 check_prevs_add kernel/locking/lockdep.c:3280 [inline]
 validate_chain kernel/locking/lockdep.c:3904 [inline]
 __lock_acquire+0x250b/0x3ce0 kernel/locking/lockdep.c:5202
 lock_acquire.part.0+0x11b/0x380 kernel/locking/lockdep.c:5825
 down_read+0x9a/0x330 kernel/locking/rwsem.c:1524
 ocfs2_calc_xattr_init+0x5e7/0xcc0 fs/ocfs2/xattr.c:627
 ocfs2_mknod+0x9f2/0x2440 fs/ocfs2/namei.c:328
 ocfs2_create+0x185/0x450 fs/ocfs2/namei.c:672
 vfs_create fs/namei.c:3294 [inline]
 vfs_create+0x4c5/0x770 fs/namei.c:3278
 do_mknodat+0x3d5/0x5d0 fs/namei.c:4185
 __do_sys_mknod fs/namei.c:4218 [inline]
 __se_sys_mknod fs/namei.c:4216 [inline]
 __x64_sys_mknod+0x87/0xb0 fs/namei.c:4216
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0xcd/0x250 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f9c6537dff9
Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 a8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f9c661e3038 EFLAGS: 00000246 ORIG_RAX: 0000000000000085
RAX: ffffffffffffffda RBX: 00007f9c65535f80 RCX: 00007f9c6537dff9
RDX: 0000000000000701 RSI: 0000000000000800 RDI: 0000000020000500
RBP: 00007f9c653f0296 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 0000000000000000 R14: 00007f9c65535f80 R15: 00007ffcd340d568
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
