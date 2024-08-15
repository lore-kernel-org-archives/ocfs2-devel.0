Received: from mail-il1-f200.google.com (mail-il1-f200.google.com [209.85.166.200])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13B731B4C44
	for <ocfs2-devel@lists.linux.dev>; Thu, 15 Aug 2024 10:46:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.200
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723718788; cv=none; b=OPUsuNZCEgOtVFbem8MwvzlUhgdN++g/GGs/z3V+f6deGpeuh326JJZgvTEvl2J7u9Jl+p8DoHP/E1rywQMc8ki0+mgTQ7qk3JK6K5Qjc4jQ1AzoEqnd+MZ6rWhU+KXV6mQmIttwXrDlnGGg+SWRmfs7M2z4Axk1VHcSQFo1h+8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723718788; c=relaxed/simple;
	bh=mP4ScK7hh1W56yidWUx0ATcHKQlC9uV2m12vu2vS3P8=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=RXZT3rqrUJKOqLoC5ax2bLQFOGS8uUcihBEa5E6XAVXYDWm6sNbFhZSF6f+f7qJSe4WjrO6gIEjs/EMYPRwY/bty5G0+nVbUkZjcyK+ukdXOV3vY1qLhHRrmdrt9s/jH2AChm/IQhKyYBSdk9Fif2nlhjFywXQsfcBDQi/fo9rI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.200
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f200.google.com with SMTP id e9e14a558f8ab-37642e69d7eso7786195ab.3
        for <ocfs2-devel@lists.linux.dev>; Thu, 15 Aug 2024 03:46:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723718785; x=1724323585;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=JVLaZKEKcteBqWT8eJdYwIYyBwWx3q/n5Ssw9A93I8w=;
        b=JjPy2AzjEURInAdDYXkfjKciLjElwsmNfjbRUqYYRpkux+aN4qJVfxGdpnQv1suJex
         nCnqf8JCSYZOitHo020XJkAmBypErkXkgsfSXqk909f0OilFbmvGTRUTiKs5Fyre4zDT
         ikHpeLzaqcd/YUcf/sB1aHPPeBr4hk/oHTuNPSkj2ZIrAf4xUISVTR+QQZQTdwF425hN
         uBJvL+Bn89C4FSbaNZIJgwOJIrUav2odHSQOy8b5wRylM54ye4q8ZnT60jim/NwDbFcN
         dRDk3p5Yd5bSS27De1Z9g9h25Yei5MFMZEnWI5rONcIl4H/pxJqrCGdmWhiw/X7jcg0V
         YcCQ==
X-Forwarded-Encrypted: i=1; AJvYcCXT60UWIHZ9PpUHVx0nCzuRt+Xisa/MqX9MUNfox6VZcht9iCK5sHfivm9LPEnSEy2VmTVIP9wEmByzpWcwgOKVFX2NMazEDTrHTQg=
X-Gm-Message-State: AOJu0Yy77EmU4lfdP/1a/xtKAwpBUjMeGCc6x/hc0DXhwWmx3cMvVldW
	dUK2L9FE9EMb4OycuTw/0yG5T56Sa9LoxOB+StaVD6BVDW/xHmfxCoEYX16EJa4iM1iQQD50Hgi
	iIlj2gcec2VyTYC9LtwlaWGYmv7fxgg+WLiToyfb2F2GVVpL4SYLJpis=
X-Google-Smtp-Source: AGHT+IEcXtSrUOPmZgkLZ/0aDN/tLi5peLXpbFTolAgjONXXAY1LQ1YqRijm4E1xoEv2mmDK3NABaVKkT3AIVT4HUAkd3ybMs3+f
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:b23:b0:39d:1236:a9c0 with SMTP id
 e9e14a558f8ab-39d12443c4emr4143195ab.1.1723718785199; Thu, 15 Aug 2024
 03:46:25 -0700 (PDT)
Date: Thu, 15 Aug 2024 03:46:25 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000e28810061fb68dd0@google.com>
Subject: [syzbot] [ocfs2?] possible deadlock in ocfs2_get_system_file_inode
From: syzbot <syzbot+e0055ea09f1f5e6fabdd@syzkaller.appspotmail.com>
To: jlbec@evilplan.org, joseph.qi@linux.alibaba.com, 
	linux-kernel@vger.kernel.org, mark@fasheh.com, ocfs2-devel@lists.linux.dev, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    d07b43284ab3 Merge tag 'for-linus' of git://git.kernel.org..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=17e20ad5980000
kernel config:  https://syzkaller.appspot.com/x/.config?x=7229118d88b4a71b
dashboard link: https://syzkaller.appspot.com/bug?extid=e0055ea09f1f5e6fabdd
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=13a439f3980000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=16d03409980000

Downloadable assets:
disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/7bc7510fe41f/non_bootable_disk-d07b4328.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/91ceec6e19d3/vmlinux-d07b4328.xz
kernel image: https://storage.googleapis.com/syzbot-assets/be11646b0c05/bzImage-d07b4328.xz
mounted in repro: https://storage.googleapis.com/syzbot-assets/74389c5ef0e9/mount_0.gz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+e0055ea09f1f5e6fabdd@syzkaller.appspotmail.com

JBD2: Ignoring recovery information on journal
ocfs2: Mounting device (7,0) on (node local, slot 0) with ordered data mode.
======================================================
WARNING: possible circular locking dependency detected
6.11.0-rc3-syzkaller-00060-gd07b43284ab3 #0 Not tainted
------------------------------------------------------
syz-executor524/5089 is trying to acquire lock:
ffff8880122695a8 (&osb->system_file_mutex){+.+.}-{3:3}, at: ocfs2_get_system_file_inode+0x18f/0x7b0 fs/ocfs2/sysfile.c:101

but task is already holding lock:
ffff88803a7f0660 (&ocfs2_file_ip_alloc_sem_key){++++}-{3:3}, at: ocfs2_expand_inline_dir fs/ocfs2/dir.c:2800 [inline]
ffff88803a7f0660 (&ocfs2_file_ip_alloc_sem_key){++++}-{3:3}, at: ocfs2_extend_dir+0x7f4/0x53d0 fs/ocfs2/dir.c:3181

which lock already depends on the new lock.


the existing dependency chain (in reverse order) is:

-> #1 (&ocfs2_file_ip_alloc_sem_key){++++}-{3:3}:
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
       vfs_get_tree+0x90/0x2a0 fs/super.c:1800
       do_new_mount+0x2be/0xb40 fs/namespace.c:3472
       do_mount fs/namespace.c:3812 [inline]
       __do_sys_mount fs/namespace.c:4020 [inline]
       __se_sys_mount+0x2d6/0x3c0 fs/namespace.c:3997
       do_syscall_x64 arch/x86/entry/common.c:52 [inline]
       do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
       entry_SYSCALL_64_after_hwframe+0x77/0x7f

-> #0 (&osb->system_file_mutex){+.+.}-{3:3}:
       check_prev_add kernel/locking/lockdep.c:3133 [inline]
       check_prevs_add kernel/locking/lockdep.c:3252 [inline]
       validate_chain+0x18e0/0x5900 kernel/locking/lockdep.c:3868
       __lock_acquire+0x137a/0x2040 kernel/locking/lockdep.c:5142
       lock_acquire+0x1ed/0x550 kernel/locking/lockdep.c:5759
       __mutex_lock_common kernel/locking/mutex.c:608 [inline]
       __mutex_lock+0x136/0xd70 kernel/locking/mutex.c:752
       ocfs2_get_system_file_inode+0x18f/0x7b0 fs/ocfs2/sysfile.c:101
       ocfs2_reserve_suballoc_bits+0x16f/0x4eb0 fs/ocfs2/suballoc.c:780
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
       __do_sys_creat fs/open.c:1507 [inline]
       __se_sys_creat fs/open.c:1501 [inline]
       __x64_sys_creat+0x123/0x170 fs/open.c:1501
       do_syscall_x64 arch/x86/entry/common.c:52 [inline]
       do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
       entry_SYSCALL_64_after_hwframe+0x77/0x7f

other info that might help us debug this:

 Possible unsafe locking scenario:

       CPU0                    CPU1
       ----                    ----
  lock(&ocfs2_file_ip_alloc_sem_key);
                               lock(&osb->system_file_mutex);
                               lock(&ocfs2_file_ip_alloc_sem_key);
  lock(&osb->system_file_mutex);

 *** DEADLOCK ***

3 locks held by syz-executor524/5089:
 #0: ffff88803a0de420 (sb_writers#9){.+.+}-{0:0}, at: mnt_want_write+0x3f/0x90 fs/namespace.c:515
 #1: ffff88803a7f09c0 (&type->i_mutex_dir_key#6){+.+.}-{3:3}, at: inode_lock include/linux/fs.h:799 [inline]
 #1: ffff88803a7f09c0 (&type->i_mutex_dir_key#6){+.+.}-{3:3}, at: open_last_lookups fs/namei.c:3644 [inline]
 #1: ffff88803a7f09c0 (&type->i_mutex_dir_key#6){+.+.}-{3:3}, at: path_openat+0x7fb/0x3470 fs/namei.c:3883
 #2: ffff88803a7f0660 (&ocfs2_file_ip_alloc_sem_key){++++}-{3:3}, at: ocfs2_expand_inline_dir fs/ocfs2/dir.c:2800 [inline]
 #2: ffff88803a7f0660 (&ocfs2_file_ip_alloc_sem_key){++++}-{3:3}, at: ocfs2_extend_dir+0x7f4/0x53d0 fs/ocfs2/dir.c:3181

stack backtrace:
CPU: 0 UID: 0 PID: 5089 Comm: syz-executor524 Not tainted 6.11.0-rc3-syzkaller-00060-gd07b43284ab3 #0
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
 __mutex_lock_common kernel/locking/mutex.c:608 [inline]
 __mutex_lock+0x136/0xd70 kernel/locking/mutex.c:752
 ocfs2_get_system_file_inode+0x18f/0x7b0 fs/ocfs2/sysfile.c:101
 ocfs2_reserve_suballoc_bits+0x16f/0x4eb0 fs/ocfs2/suballoc.c:780
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
 __do_sys_creat fs/open.c:1507 [inline]
 __se_sys_creat fs/open.c:1501 [inline]
 __x64_sys_creat+0x123/0x170 fs/open.c:1501
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f4da5400a99
Code: 28 00 00 00 75 05 48 83 c4 28 c3 e8 f1 17 00 00 90 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 b8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007ffc633808a8 EFLAGS: 00000246 ORIG_RAX: 0000000000000055
RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007f4da5400a99
RDX: 0000000000000000 RSI: 0000000000000000 RDI: 00000000200001c0
RBP: 00007f4da54785f0 R08: 0000000000004466 R09: 0000555565ef54c0
R10: 00007ffc63380770 R11: 0000000000000246 R12: 00007ffc633808d0
R13: 00007ffc63380af8 R14: 431bde82d7b634db R15: 00007f4da544903b
 </TASK>
OCFS2: ERROR (device loop0): int ocfs2_claim_suballoc_bits(struct ocfs2_alloc_context *, handle_t *, u32, u32, struct ocfs2_suballoc_result *): Chain allocator dinode 23 has 4294967295 used bits but only 16777215 total
On-disk corruption discovered. Please run fsck.ocfs2 once the filesystem is unmounted.
OCFS2: Returning error to the calling process.
(syz-executor524,5089,0):ocfs2_claim_suballoc_bits:2038 ERROR: status = -5
(syz-executor524,5089,0):__ocfs2_claim_clusters:2412 ERROR: status = -5
(syz-executor524,5089,0):__ocfs2_claim_clusters:2420 ERROR: status = -5
(syz-executor524,5089,0):ocfs2_block_group_alloc_contig:437 ERROR: status = -5
(syz-executor524,5089,0):ocfs2_block_group_alloc:709 ERROR: status = -5
(syz-executor524,5089,0):ocfs2_block_group_alloc:762 ERROR: status = -5
(syz-executor524,5089,0):ocfs2_reserve_suballoc_bits:837 ERROR: status = -5
(syz-executor524,5089,0):ocfs2_reserve_suballoc_bits:854 ERROR: status = -5
(syz-executor524,5089,0):ocfs2_reserve_new_metadata_blocks:994 ERROR: status = -5
(syz-executor524,5089,0):ocfs2_reserve_new_metadata_blocks:1017 ERROR: status = -5
(syz-executor524,5089,0):ocfs2_expand_inline_dir:2821 ERROR: status = -5
(syz-executor524,5089,0):ocfs2_extend_dir:3185 ERROR: status = -5
(syz-executor524,5089,0):ocfs2_prepare_dir_for_insert:4300 ERROR: status = -5
(syz-executor524,5089,0):ocfs2_mknod:296 ERROR: status = -5
(syz-executor524,5089,0):ocfs2_mknod:500 ERROR: status = -5
(syz-executor524,5089,0):ocfs2_create:674 ERROR: status = -5
syz-executor524 (5089) used greatest stack depth: 16912 bytes left


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.

If the report is already addressed, let syzbot know by replying with:
#syz fix: exact-commit-title

If you want syzbot to run the reproducer, reply with:
#syz test: git://repo/address.git branch-or-commit-hash
If you attach or paste a git patch, syzbot will apply it before testing.

If you want to overwrite report's subsystems, reply with:
#syz set subsystems: new-subsystem
(See the list of subsystem names on the web dashboard)

If the report is a duplicate of another one, reply with:
#syz dup: exact-subject-of-another-report

If you want to undo deduplication, reply with:
#syz undup
