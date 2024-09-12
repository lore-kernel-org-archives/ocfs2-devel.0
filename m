Received: from mail-il1-f198.google.com (mail-il1-f198.google.com [209.85.166.198])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A330F19E981
	for <ocfs2-devel@lists.linux.dev>; Thu, 12 Sep 2024 09:36:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.198
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726133788; cv=none; b=qZExyjoceWq5m03Qs1PgC1taga7R05QLrtPAexmx3VJP6PMmNEAPiox24Y1K8mSV70dfNJAkvrAqEAiTDEv/UB4HqAuu0i1sLnuYOICcZ9XF21K4OYXoyqmMStXq6ChK6T4STCZpCqDA35U2rg/nGzIaVFQL2OLx341H6Ixb3JU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726133788; c=relaxed/simple;
	bh=/5rCSYh3OOoOdW5qy97tWya33IRuk3CnW3Uk9vBpkhc=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=r5V63DKN5hJx+F4wS32ld+nVvnOuPdx3A+sMtPXqPXEV3I1Eiirl7xsvz18RLaUxHt+WB52c/4OVT9No1deOtstBnxL9wb76zbpQ7Uht0FaLF7198+NguVlRXA0Cl6285VcxzeMRiyBJcALOczmHjuuapmdBJ+hGB2YRZfYGNtA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.198
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f198.google.com with SMTP id e9e14a558f8ab-3a04af50632so11237675ab.2
        for <ocfs2-devel@lists.linux.dev>; Thu, 12 Sep 2024 02:36:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726133786; x=1726738586;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=wKzpwmXtJs8+zMgm8/Gj8QTmX0gdH+yJ20Wf+Bo+YBs=;
        b=jm/WoyqC4thZUryCbjSwCHhexPs+YLR0P3cDroZkNyYw9N8kjkKNdof8uwvHo3tGyE
         tuwNjAzFAnhwcV9EBWEnWqGkspJLonoWESRgrKfrFD3W6tsH5J7S4y7IIAF/CH3ZoiGx
         omWYmAOXMArC3xJpn9328jUiADGBgukNfim7VJM7gKIc+CnCBRRWz1Q051JXLWauhsnQ
         hq7LA484+OjOyu9dbJku1CZH1t/JMqJxNM2FIZ3Qj6h0zSvy0LrB2WWNV1Wc+7ejHirZ
         kxK3ZnByasMYoFX43hbsQTbKWm7S9cSrlq2wsV+nAoF3vapnWsT+CbJ2ZFYcPLB71lQq
         WEgQ==
X-Forwarded-Encrypted: i=1; AJvYcCXHCNj9CUlJ3xWdDOVi9YE0AeGgqIEOyyjfxNB0islsmgjIsDHP/EhOdeiQ36ZvjVujBD5JejV381tIQA==@lists.linux.dev
X-Gm-Message-State: AOJu0YyAW/BxhNtRpWNZD1OBt5osiuaccC5IAPYxCBcp+1icmGK38sVH
	9EbMWKCxF+traug9My2HddChYOxLwdH6yXwK9QtUX09mG9PxaLcobooKMyCylm7jHlehMVgeKfb
	UjdKRF/iSru9FjaN/H9eqSXpOa8YZa6yrZiYOT3b9jvz0sQS0Jm6+L3Y=
X-Google-Smtp-Source: AGHT+IFWRoFQcL2sK2gixMvV/dxKGVbbVQon4ElG+KkcZaHJBrsUUFilop/H7XlQ5K/0PnQsMbUhfYGSVneJZkdY6hf8mNTGQZ3L
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:174b:b0:39d:55fd:7625 with SMTP id
 e9e14a558f8ab-3a08494abbamr20889565ab.22.1726133785670; Thu, 12 Sep 2024
 02:36:25 -0700 (PDT)
Date: Thu, 12 Sep 2024 02:36:25 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000213f750621e8d7d2@google.com>
Subject: [syzbot] [ocfs2?] possible deadlock in ocfs2_read_virt_blocks
From: syzbot <syzbot+8b11b4c34ed0362b217a@syzkaller.appspotmail.com>
To: jlbec@evilplan.org, joseph.qi@linux.alibaba.com, 
	linux-kernel@vger.kernel.org, mark@fasheh.com, ocfs2-devel@lists.linux.dev, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    7c6a3a65ace7 minmax: reduce min/max macro expansion in ato..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=10b55807980000
kernel config:  https://syzkaller.appspot.com/x/.config?x=61d235cb8d15001c
dashboard link: https://syzkaller.appspot.com/bug?extid=8b11b4c34ed0362b217a
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/7bc7510fe41f/non_bootable_disk-7c6a3a65.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/1a9a78c56595/vmlinux-7c6a3a65.xz
kernel image: https://storage.googleapis.com/syzbot-assets/1b4e1f2187a1/bzImage-7c6a3a65.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+8b11b4c34ed0362b217a@syzkaller.appspotmail.com

======================================================
WARNING: possible circular locking dependency detected
6.11.0-rc7-syzkaller-00021-g7c6a3a65ace7 #0 Not tainted
------------------------------------------------------
syz.0.0/5120 is trying to acquire lock:
ffff88804b8c3f60 (&oi->ip_alloc_sem){++++}-{3:3}, at: ocfs2_read_virt_blocks+0x2ca/0xa50 fs/ocfs2/extent_map.c:976

but task is already holding lock:
ffff88803d352958 (jbd2_handle){++++}-{0:0}, at: start_this_handle+0x1e94/0x2110 fs/jbd2/transaction.c:448

which lock already depends on the new lock.


the existing dependency chain (in reverse order) is:

-> #5 (jbd2_handle){++++}-{0:0}:
       lock_acquire+0x1ed/0x550 kernel/locking/lockdep.c:5759
       start_this_handle+0x1eb4/0x2110 fs/jbd2/transaction.c:448
       jbd2__journal_start+0x2da/0x5d0 fs/jbd2/transaction.c:505
       jbd2_journal_start+0x29/0x40 fs/jbd2/transaction.c:544
       ocfs2_start_trans+0x3c9/0x700 fs/ocfs2/journal.c:352
       ocfs2_mknod+0x150c/0x2b40 fs/ocfs2/namei.c:359
       ocfs2_mkdir+0x1ab/0x480 fs/ocfs2/namei.c:655
       vfs_mkdir+0x2f9/0x4f0 fs/namei.c:4210
       do_mkdirat+0x264/0x3a0 fs/namei.c:4233
       __do_sys_mkdirat fs/namei.c:4248 [inline]
       __se_sys_mkdirat fs/namei.c:4246 [inline]
       __x64_sys_mkdirat+0x87/0xa0 fs/namei.c:4246
       do_syscall_x64 arch/x86/entry/common.c:52 [inline]
       do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
       entry_SYSCALL_64_after_hwframe+0x77/0x7f

-> #4 (&journal->j_trans_barrier){.+.+}-{3:3}:
       lock_acquire+0x1ed/0x550 kernel/locking/lockdep.c:5759
       down_read+0xb1/0xa40 kernel/locking/rwsem.c:1526
       ocfs2_start_trans+0x3be/0x700 fs/ocfs2/journal.c:350
       ocfs2_mknod+0x150c/0x2b40 fs/ocfs2/namei.c:359
       ocfs2_mkdir+0x1ab/0x480 fs/ocfs2/namei.c:655
       vfs_mkdir+0x2f9/0x4f0 fs/namei.c:4210
       do_mkdirat+0x264/0x3a0 fs/namei.c:4233
       __do_sys_mkdirat fs/namei.c:4248 [inline]
       __se_sys_mkdirat fs/namei.c:4246 [inline]
       __x64_sys_mkdirat+0x87/0xa0 fs/namei.c:4246
       do_syscall_x64 arch/x86/entry/common.c:52 [inline]
       do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
       entry_SYSCALL_64_after_hwframe+0x77/0x7f

-> #3 (sb_internal#2){.+.+}-{0:0}:
       lock_acquire+0x1ed/0x550 kernel/locking/lockdep.c:5759
       percpu_down_read include/linux/percpu-rwsem.h:51 [inline]
       __sb_start_write include/linux/fs.h:1676 [inline]
       sb_start_intwrite include/linux/fs.h:1859 [inline]
       ocfs2_start_trans+0x2b9/0x700 fs/ocfs2/journal.c:348
       ocfs2_mknod+0x150c/0x2b40 fs/ocfs2/namei.c:359
       ocfs2_mkdir+0x1ab/0x480 fs/ocfs2/namei.c:655
       vfs_mkdir+0x2f9/0x4f0 fs/namei.c:4210
       do_mkdirat+0x264/0x3a0 fs/namei.c:4233
       __do_sys_mkdirat fs/namei.c:4248 [inline]
       __se_sys_mkdirat fs/namei.c:4246 [inline]
       __x64_sys_mkdirat+0x87/0xa0 fs/namei.c:4246
       do_syscall_x64 arch/x86/entry/common.c:52 [inline]
       do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
       entry_SYSCALL_64_after_hwframe+0x77/0x7f

-> #2 (&ocfs2_sysfile_lock_key[args->fi_sysfile_type]#4){+.+.}-{3:3}:
       lock_acquire+0x1ed/0x550 kernel/locking/lockdep.c:5759
       down_write+0x99/0x220 kernel/locking/rwsem.c:1579
       inode_lock include/linux/fs.h:800 [inline]
       ocfs2_reserve_local_alloc_bits+0x132/0x2870 fs/ocfs2/localalloc.c:636
       ocfs2_reserve_clusters_with_limit+0x1b8/0xb60 fs/ocfs2/suballoc.c:1166
       ocfs2_mknod+0x1486/0x2b40 fs/ocfs2/namei.c:352
       ocfs2_mkdir+0x1ab/0x480 fs/ocfs2/namei.c:655
       vfs_mkdir+0x2f9/0x4f0 fs/namei.c:4210
       do_mkdirat+0x264/0x3a0 fs/namei.c:4233
       __do_sys_mkdirat fs/namei.c:4248 [inline]
       __se_sys_mkdirat fs/namei.c:4246 [inline]
       __x64_sys_mkdirat+0x87/0xa0 fs/namei.c:4246
       do_syscall_x64 arch/x86/entry/common.c:52 [inline]
       do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
       entry_SYSCALL_64_after_hwframe+0x77/0x7f

-> #1 (&ocfs2_sysfile_lock_key[args->fi_sysfile_type]#3){+.+.}-{3:3}:
       lock_acquire+0x1ed/0x550 kernel/locking/lockdep.c:5759
       down_write+0x99/0x220 kernel/locking/rwsem.c:1579
       inode_lock include/linux/fs.h:800 [inline]
       ocfs2_reserve_suballoc_bits+0x192/0x4eb0 fs/ocfs2/suballoc.c:786
       ocfs2_reserve_new_metadata_blocks+0x41c/0x9c0 fs/ocfs2/suballoc.c:982
       ocfs2_expand_inline_dir fs/ocfs2/dir.c:2819 [inline]
       ocfs2_extend_dir+0xdef/0x53d0 fs/ocfs2/dir.c:3181
       ocfs2_prepare_dir_for_insert+0x33d1/0x5c70 fs/ocfs2/dir.c:4296
       ocfs2_mknod+0xcaf/0x2b40 fs/ocfs2/namei.c:292
       ocfs2_create+0x1ab/0x480 fs/ocfs2/namei.c:672
       lookup_open fs/namei.c:3578 [inline]
       open_last_lookups fs/namei.c:3647 [inline]
       path_openat+0x1a9a/0x3470 fs/namei.c:3883
       do_filp_open+0x235/0x490 fs/namei.c:3913
       do_sys_openat2+0x13e/0x1d0 fs/open.c:1416
       do_sys_open fs/open.c:1431 [inline]
       __do_sys_openat fs/open.c:1447 [inline]
       __se_sys_openat fs/open.c:1442 [inline]
       __x64_sys_openat+0x247/0x2a0 fs/open.c:1442
       do_syscall_x64 arch/x86/entry/common.c:52 [inline]
       do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
       entry_SYSCALL_64_after_hwframe+0x77/0x7f

-> #0 (&oi->ip_alloc_sem){++++}-{3:3}:
       check_prev_add kernel/locking/lockdep.c:3133 [inline]
       check_prevs_add kernel/locking/lockdep.c:3252 [inline]
       validate_chain+0x18e0/0x5900 kernel/locking/lockdep.c:3868
       __lock_acquire+0x137a/0x2040 kernel/locking/lockdep.c:5142
       lock_acquire+0x1ed/0x550 kernel/locking/lockdep.c:5759
       down_read+0xb1/0xa40 kernel/locking/rwsem.c:1526
       ocfs2_read_virt_blocks+0x2ca/0xa50 fs/ocfs2/extent_map.c:976
       ocfs2_read_dir_block+0x106/0x5c0 fs/ocfs2/dir.c:508
       ocfs2_dir_foreach_blk_el fs/ocfs2/dir.c:1827 [inline]
       ocfs2_dir_foreach_blk+0x2ca/0x1b20 fs/ocfs2/dir.c:1913
       ocfs2_dir_foreach fs/ocfs2/dir.c:1923 [inline]
       ocfs2_empty_dir+0x134/0x800 fs/ocfs2/dir.c:2137
       ocfs2_rename+0x25f1/0x4210 fs/ocfs2/namei.c:1498
       vfs_rename+0xbdb/0xf00 fs/namei.c:4966
       do_renameat2+0xd94/0x13f0 fs/namei.c:5123
       __do_sys_rename fs/namei.c:5170 [inline]
       __se_sys_rename fs/namei.c:5168 [inline]
       __x64_sys_rename+0x82/0x90 fs/namei.c:5168
       do_syscall_x64 arch/x86/entry/common.c:52 [inline]
       do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
       entry_SYSCALL_64_after_hwframe+0x77/0x7f

other info that might help us debug this:

Chain exists of:
  &oi->ip_alloc_sem --> &journal->j_trans_barrier --> jbd2_handle

 Possible unsafe locking scenario:

       CPU0                    CPU1
       ----                    ----
  rlock(jbd2_handle);
                               lock(&journal->j_trans_barrier);
                               lock(jbd2_handle);
  rlock(&oi->ip_alloc_sem);

 *** DEADLOCK ***

7 locks held by syz.0.0/5120:
 #0: ffff8880120d2420 (sb_writers#10){.+.+}-{0:0}, at: mnt_want_write+0x3f/0x90 fs/namespace.c:515
 #1: ffff88804b8f89c0 (&type->i_mutex_dir_key#6/1){+.+.}-{3:3}, at: inode_lock_nested include/linux/fs.h:835 [inline]
 #1: ffff88804b8f89c0 (&type->i_mutex_dir_key#6/1){+.+.}-{3:3}, at: lock_rename fs/namei.c:3147 [inline]
 #1: ffff88804b8f89c0 (&type->i_mutex_dir_key#6/1){+.+.}-{3:3}, at: do_renameat2+0x62c/0x13f0 fs/namei.c:5058
 #2: ffff88804b8c42c0 (&sb->s_type->i_mutex_key#20){+.+.}-{3:3}, at: inode_lock include/linux/fs.h:800 [inline]
 #2: ffff88804b8c42c0 (&sb->s_type->i_mutex_key#20){+.+.}-{3:3}, at: vfs_rename+0x6cb/0xf00 fs/namei.c:4931
 #3: ffff88804b8fdf40 (&ocfs2_sysfile_lock_key[args->fi_sysfile_type]){+.+.}-{3:3}, at: inode_lock include/linux/fs.h:800 [inline]
 #3: ffff88804b8fdf40 (&ocfs2_sysfile_lock_key[args->fi_sysfile_type]){+.+.}-{3:3}, at: ocfs2_lookup_lock_orphan_dir+0x102/0x350 fs/ocfs2/namei.c:2127
 #4: ffff8880120d2610 (sb_internal#2){.+.+}-{0:0}, at: ocfs2_rename+0x1ebe/0x4210 fs/ocfs2/namei.c:1487
 #5: ffff88801259bce8 (&journal->j_trans_barrier){.+.+}-{3:3}, at: ocfs2_start_trans+0x3be/0x700 fs/ocfs2/journal.c:350
 #6: ffff88803d352958 (jbd2_handle){++++}-{0:0}, at: start_this_handle+0x1e94/0x2110 fs/jbd2/transaction.c:448

stack backtrace:
CPU: 0 UID: 0 PID: 5120 Comm: syz.0.0 Not tainted 6.11.0-rc7-syzkaller-00021-g7c6a3a65ace7 #0
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
 down_read+0xb1/0xa40 kernel/locking/rwsem.c:1526
 ocfs2_read_virt_blocks+0x2ca/0xa50 fs/ocfs2/extent_map.c:976
 ocfs2_read_dir_block+0x106/0x5c0 fs/ocfs2/dir.c:508
 ocfs2_dir_foreach_blk_el fs/ocfs2/dir.c:1827 [inline]
 ocfs2_dir_foreach_blk+0x2ca/0x1b20 fs/ocfs2/dir.c:1913
 ocfs2_dir_foreach fs/ocfs2/dir.c:1923 [inline]
 ocfs2_empty_dir+0x134/0x800 fs/ocfs2/dir.c:2137
 ocfs2_rename+0x25f1/0x4210 fs/ocfs2/namei.c:1498
 vfs_rename+0xbdb/0xf00 fs/namei.c:4966
 do_renameat2+0xd94/0x13f0 fs/namei.c:5123
 __do_sys_rename fs/namei.c:5170 [inline]
 __se_sys_rename fs/namei.c:5168 [inline]
 __x64_sys_rename+0x82/0x90 fs/namei.c:5168
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f0ffc77def9
Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 a8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f0ffd512038 EFLAGS: 00000246 ORIG_RAX: 0000000000000052
RAX: ffffffffffffffda RBX: 00007f0ffc936058 RCX: 00007f0ffc77def9
RDX: 0000000000000000 RSI: 00000000200000c0 RDI: 0000000020000200
RBP: 00007f0ffc7f0b76 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 0000000000000000 R14: 00007f0ffc936058 R15: 00007ffcf5c18e98
 </TASK>
(syz.0.0,5120,0):ocfs2_rename:1698 ERROR: status = -39


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
