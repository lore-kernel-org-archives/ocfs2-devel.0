Received: from mail-oa1-f78.google.com (mail-oa1-f78.google.com [209.85.160.78])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBC4D2AD16
	for <ocfs2-devel@lists.linux.dev>; Wed,  4 Feb 2026 00:52:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.78
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770166364; cv=none; b=e+Nzc6VXajAR8whwMZKSh/OmwSBfVd3T7z0gu9VzjddHthcqjoJH92MPofBr/WmopICJFEDvXlfsUlrE0kbRiPvVXRhe7tEc73as0gp/g2K/Ge+nW4fiPODcPvyjpQ3NK5gcwb5/fRZR5u+ShUviKYdJNAJMk3yAPVYz6mZvTts=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770166364; c=relaxed/simple;
	bh=mBG11paB0SpduwLeXCNERwXHJtCK7FCqAbSILRgwzgk=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=JyE9GXowLHW9ZNl7vPskxVV1NOI34YD2olnuHq4IMVDvc0XjGGKwfMFq2J3j/AyQzQPvFMgJpOVSITqlSdTpVF2IAVp4Al3mkLmdID29OvIhRwBg/jjI4nm6Eq+iInmhmG4wv1jP1PP6oGcJcWxpUg0BFwmHJFbf6/7y5Wd3gT8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.160.78
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oa1-f78.google.com with SMTP id 586e51a60fabf-4042a16a369so13982306fac.2
        for <ocfs2-devel@lists.linux.dev>; Tue, 03 Feb 2026 16:52:42 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770166362; x=1770771162;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=UAyljm+bx1mXbo5sDIthmt+TwGoTVIcjd3g0+pjNoxo=;
        b=nvi41kZxzRXzfoxhsxS8SluRe1ky+jSZXYhB1lCVvx8J2ewjRvsasZ2Qqk97eIK3OU
         +n4bgj7DfiEAxx7x2D6xO7HHxdf2SOa8prgyr0wIXZNoSLo0Xbpx01iC84mWlTK8Lb8W
         UauUFsoQq3olBgCCx7IQPnW/GJCdu7yGCNKAZw+aDSpe3m1eKlEfJVOGUe0hrGLDyDmG
         mRPCytPTJ3SjRo2B6qlbwEYvWMmtDdqCusjrvaBZ/Mco13iyS6yQVGro0Em/CHVBq83h
         Y4ZM4s4PCVCzFc8UAP0DTiN5H4ZbebU5vpEZFC1Q/vrurXTwNb93+oUTs2zPiMnaml7N
         UHRA==
X-Forwarded-Encrypted: i=1; AJvYcCXcJo/eOm7c95SufvMieLEYFgrRiP+v6yWRhW0rEcwH9WWpTn+y/j+Q3C6Dlmihx8LbxfUYUhNcZLBZdA==@lists.linux.dev
X-Gm-Message-State: AOJu0YwODetHvCBALzKtLNIiR3dZoiGcnnd+i8T8RPMhtZx9+84EVyO2
	w/58UWycs99zhoBHaW+eYbcCtkF+EsizjB2hj3ISd7OwrE5qCi1x/a/ozisgbBSk9GK8/ylhkBs
	ZZ85+YWGa11d93xWGaUv1EoAZMnlSkkB/yVL5aboPcFYhZ/5wjSau9saIah0=
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6820:150b:b0:664:86ce:df3a with SMTP id
 006d021491bc7-66a200bac0emr673347eaf.9.1770166361789; Tue, 03 Feb 2026
 16:52:41 -0800 (PST)
Date: Tue, 03 Feb 2026 16:52:41 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <69829859.a00a0220.37c87e.0016.GAE@google.com>
Subject: [syzbot] [ocfs2?] possible deadlock in ocfs2_simple_size_update
From: syzbot <syzbot+26712dd1e036494d98de@syzkaller.appspotmail.com>
To: jlbec@evilplan.org, joseph.qi@linux.alibaba.com, 
	linux-kernel@vger.kernel.org, mark@fasheh.com, ocfs2-devel@lists.linux.dev, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    193579fe0138 Add linux-next specific files for 20260202
git tree:       linux-next
console output: https://syzkaller.appspot.com/x/log.txt?x=150d5252580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=9cdc86e72cf2268b
dashboard link: https://syzkaller.appspot.com/bug?extid=26712dd1e036494d98de
compiler:       Debian clang version 21.1.8 (++20251221033036+2078da43e25a-1~exp1~20251221153213.50), Debian LLD 21.1.8
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=10b3625a580000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=10d5cf2a580000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/796c5916cada/disk-193579fe.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/fd0dbd8c1346/vmlinux-193579fe.xz
kernel image: https://storage.googleapis.com/syzbot-assets/bcec7f593a21/bzImage-193579fe.xz
mounted in repro: https://storage.googleapis.com/syzbot-assets/35ef7015f796/mount_0.gz
  fsck result: OK (log: https://syzkaller.appspot.com/x/fsck.log?x=1337fbfa580000)

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+26712dd1e036494d98de@syzkaller.appspotmail.com

(syz.0.17,5979,0):ocfs2_block_check_validate:402 ERROR: CRC32 failed: stored: 0xbec99099, computed 0x3881d996. Applying ECC.
ocfs2: Mounting device (7,0) on (node local, slot 0) with ordered data mode.
(syz.0.17,5979,0):ocfs2_block_check_validate:402 ERROR: CRC32 failed: stored: 0x93f628a2, computed 0x2aee8be5. Applying ECC.
(syz.0.17,5979,1):ocfs2_block_check_validate:402 ERROR: CRC32 failed: stored: 0x98842a5e, computed 0xe74db1cd. Applying ECC.
(syz.0.17,5979,1):ocfs2_block_check_validate:402 ERROR: CRC32 failed: stored: 0x1cec3d0f, computed 0xd2ffbdfe. Applying ECC.
======================================================
WARNING: possible circular locking dependency detected
syzkaller #0 Not tainted
------------------------------------------------------
syz.0.17/5979 is trying to acquire lock:
ffff888033b66610 (sb_internal#2){.+.+}-{0:0}, at: ocfs2_simple_size_update+0xd6/0x4a0 fs/ocfs2/file.c:322

but task is already holding lock:
ffff88805e61cda0 (&ocfs2_quota_ip_alloc_sem_key){++++}-{4:4}, at: ocfs2_create_local_dquot+0x1a5/0x1af0 fs/ocfs2/quota_local.c:1227

which lock already depends on the new lock.


the existing dependency chain (in reverse order) is:

-> #3 (&ocfs2_quota_ip_alloc_sem_key){++++}-{4:4}:
       down_write+0x96/0x200 kernel/locking/rwsem.c:1590
       ocfs2_lock_global_qf+0x201/0x290 fs/ocfs2/quota_global.c:314
       ocfs2_acquire_dquot+0x3fa/0xb30 fs/ocfs2/quota_global.c:850
       dqget+0x7b1/0xf10 fs/quota/dquot.c:980
       __dquot_initialize+0x3ba/0xd30 fs/quota/dquot.c:1508
       ocfs2_get_init_inode+0x147/0x1c0 fs/ocfs2/namei.c:206
       ocfs2_mknod+0xa67/0x2290 fs/ocfs2/namei.c:314
       ocfs2_create+0x195/0x490 fs/ocfs2/namei.c:677
       lookup_open fs/namei.c:4483 [inline]
       open_last_lookups fs/namei.c:4583 [inline]
       path_openat+0x1395/0x3860 fs/namei.c:4827
       do_file_open+0x23e/0x4a0 fs/namei.c:4859
       do_sys_openat2+0x113/0x200 fs/open.c:1366
       do_sys_open fs/open.c:1372 [inline]
       __do_sys_creat fs/open.c:1450 [inline]
       __se_sys_creat fs/open.c:1444 [inline]
       __x64_sys_creat+0x8f/0xc0 fs/open.c:1444
       do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
       do_syscall_64+0x14d/0xf80 arch/x86/entry/syscall_64.c:94
       entry_SYSCALL_64_after_hwframe+0x77/0x7f

-> #2 (&ocfs2_sysfile_lock_key[USER_QUOTA_SYSTEM_INODE]){+.+.}-{4:4}:
       down_write+0x96/0x200 kernel/locking/rwsem.c:1590
       inode_lock include/linux/fs.h:1028 [inline]
       ocfs2_lock_global_qf+0x1da/0x290 fs/ocfs2/quota_global.c:313
       ocfs2_acquire_dquot+0x3fa/0xb30 fs/ocfs2/quota_global.c:850
       dqget+0x7b1/0xf10 fs/quota/dquot.c:980
       __dquot_initialize+0x3ba/0xd30 fs/quota/dquot.c:1508
       ocfs2_get_init_inode+0x147/0x1c0 fs/ocfs2/namei.c:206
       ocfs2_mknod+0xa67/0x2290 fs/ocfs2/namei.c:314
       ocfs2_create+0x195/0x490 fs/ocfs2/namei.c:677
       lookup_open fs/namei.c:4483 [inline]
       open_last_lookups fs/namei.c:4583 [inline]
       path_openat+0x1395/0x3860 fs/namei.c:4827
       do_file_open+0x23e/0x4a0 fs/namei.c:4859
       do_sys_openat2+0x113/0x200 fs/open.c:1366
       do_sys_open fs/open.c:1372 [inline]
       __do_sys_creat fs/open.c:1450 [inline]
       __se_sys_creat fs/open.c:1444 [inline]
       __x64_sys_creat+0x8f/0xc0 fs/open.c:1444
       do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
       do_syscall_64+0x14d/0xf80 arch/x86/entry/syscall_64.c:94
       entry_SYSCALL_64_after_hwframe+0x77/0x7f

-> #1 (&journal->j_trans_barrier){.+.+}-{4:4}:
       down_read+0x47/0x2e0 kernel/locking/rwsem.c:1537
       ocfs2_start_trans+0x3ab/0x700 fs/ocfs2/journal.c:372
       ocfs2_modify_bh+0xe3/0x4d0 fs/ocfs2/quota_local.c:101
       ocfs2_local_read_info+0x1454/0x1810 fs/ocfs2/quota_local.c:767
       dquot_load_quota_sb+0x791/0xbd0 fs/quota/dquot.c:2462
       dquot_load_quota_inode+0x2e1/0x5d0 fs/quota/dquot.c:2499
       ocfs2_enable_quotas+0x1c8/0x4a0 fs/ocfs2/super.c:930
       ocfs2_fill_super+0x5305/0x6900 fs/ocfs2/super.c:1140
       get_tree_bdev_flags+0x431/0x4f0 fs/super.c:1694
       vfs_get_tree+0x92/0x2a0 fs/super.c:1754
       fc_mount fs/namespace.c:1193 [inline]
       do_new_mount_fc fs/namespace.c:3760 [inline]
       do_new_mount+0x341/0xd30 fs/namespace.c:3836
       do_mount fs/namespace.c:4159 [inline]
       __do_sys_mount fs/namespace.c:4348 [inline]
       __se_sys_mount+0x31d/0x420 fs/namespace.c:4325
       do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
       do_syscall_64+0x14d/0xf80 arch/x86/entry/syscall_64.c:94
       entry_SYSCALL_64_after_hwframe+0x77/0x7f

-> #0 (sb_internal#2){.+.+}-{0:0}:
       check_prev_add kernel/locking/lockdep.c:3165 [inline]
       check_prevs_add kernel/locking/lockdep.c:3284 [inline]
       validate_chain kernel/locking/lockdep.c:3908 [inline]
       __lock_acquire+0x15a5/0x2cf0 kernel/locking/lockdep.c:5237
       lock_acquire+0xf0/0x2e0 kernel/locking/lockdep.c:5868
       percpu_down_read_internal include/linux/percpu-rwsem.h:53 [inline]
       percpu_down_read_freezable include/linux/percpu-rwsem.h:83 [inline]
       __sb_start_write include/linux/fs/super.h:19 [inline]
       sb_start_intwrite include/linux/fs/super.h:177 [inline]
       ocfs2_start_trans+0x2ac/0x700 fs/ocfs2/journal.c:370
       ocfs2_simple_size_update+0xd6/0x4a0 fs/ocfs2/file.c:322
       ocfs2_extend_local_quota_file fs/ocfs2/quota_local.c:1126 [inline]
       ocfs2_create_local_dquot+0x70d/0x1af0 fs/ocfs2/quota_local.c:1230
       ocfs2_acquire_dquot+0x6d7/0xb30 fs/ocfs2/quota_global.c:888
       dqget+0x7b1/0xf10 fs/quota/dquot.c:980
       __dquot_initialize+0x3ba/0xd30 fs/quota/dquot.c:1508
       ocfs2_get_init_inode+0x147/0x1c0 fs/ocfs2/namei.c:206
       ocfs2_mknod+0xa67/0x2290 fs/ocfs2/namei.c:314
       ocfs2_create+0x195/0x490 fs/ocfs2/namei.c:677
       lookup_open fs/namei.c:4483 [inline]
       open_last_lookups fs/namei.c:4583 [inline]
       path_openat+0x1395/0x3860 fs/namei.c:4827
       do_file_open+0x23e/0x4a0 fs/namei.c:4859
       do_sys_openat2+0x113/0x200 fs/open.c:1366
       do_sys_open fs/open.c:1372 [inline]
       __do_sys_creat fs/open.c:1450 [inline]
       __se_sys_creat fs/open.c:1444 [inline]
       __x64_sys_creat+0x8f/0xc0 fs/open.c:1444
       do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
       do_syscall_64+0x14d/0xf80 arch/x86/entry/syscall_64.c:94
       entry_SYSCALL_64_after_hwframe+0x77/0x7f

other info that might help us debug this:

Chain exists of:
  sb_internal#2 --> &ocfs2_sysfile_lock_key[USER_QUOTA_SYSTEM_INODE] --> &ocfs2_quota_ip_alloc_sem_key

 Possible unsafe locking scenario:

       CPU0                    CPU1
       ----                    ----
  lock(&ocfs2_quota_ip_alloc_sem_key);
                               lock(&ocfs2_sysfile_lock_key[USER_QUOTA_SYSTEM_INODE]);
                               lock(&ocfs2_quota_ip_alloc_sem_key);
  rlock(sb_internal#2);

 *** DEADLOCK ***

5 locks held by syz.0.17/5979:
 #0: ffff888033b66420 (sb_writers#12){.+.+}-{0:0}, at: mnt_want_write+0x41/0x90 fs/namespace.c:493
 #1: ffff88805e613480 (&type->i_mutex_dir_key#8){+.+.}-{4:4}, at: inode_lock include/linux/fs.h:1028 [inline]
 #1: ffff88805e613480 (&type->i_mutex_dir_key#8){+.+.}-{4:4}, at: open_last_lookups fs/namei.c:4580 [inline]
 #1: ffff88805e613480 (&type->i_mutex_dir_key#8){+.+.}-{4:4}, at: path_openat+0xb4c/0x3860 fs/namei.c:4827
 #2: ffff88805e609800 (&ocfs2_sysfile_lock_key[INODE_ALLOC_SYSTEM_INODE]){+.+.}-{4:4}, at: inode_lock include/linux/fs.h:1028 [inline]
 #2: ffff88805e609800 (&ocfs2_sysfile_lock_key[INODE_ALLOC_SYSTEM_INODE]){+.+.}-{4:4}, at: ocfs2_reserve_suballoc_bits+0x16a/0x4940 fs/ocfs2/suballoc.c:857
 #3: ffff88805e44b6a8 (&dquot->dq_lock){+.+.}-{4:4}, at: ocfs2_acquire_dquot+0x271/0xb30 fs/ocfs2/quota_global.c:823
 #4: ffff88805e61cda0 (&ocfs2_quota_ip_alloc_sem_key){++++}-{4:4}, at: ocfs2_create_local_dquot+0x1a5/0x1af0 fs/ocfs2/quota_local.c:1227

stack backtrace:
CPU: 0 UID: 0 PID: 5979 Comm: syz.0.17 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/24/2026
Call Trace:
 <TASK>
 dump_stack_lvl+0xe8/0x150 lib/dump_stack.c:120
 print_circular_bug+0x2e1/0x300 kernel/locking/lockdep.c:2043
 check_noncircular+0x12e/0x150 kernel/locking/lockdep.c:2175
 check_prev_add kernel/locking/lockdep.c:3165 [inline]
 check_prevs_add kernel/locking/lockdep.c:3284 [inline]
 validate_chain kernel/locking/lockdep.c:3908 [inline]
 __lock_acquire+0x15a5/0x2cf0 kernel/locking/lockdep.c:5237
 lock_acquire+0xf0/0x2e0 kernel/locking/lockdep.c:5868
 percpu_down_read_internal include/linux/percpu-rwsem.h:53 [inline]
 percpu_down_read_freezable include/linux/percpu-rwsem.h:83 [inline]
 __sb_start_write include/linux/fs/super.h:19 [inline]
 sb_start_intwrite include/linux/fs/super.h:177 [inline]
 ocfs2_start_trans+0x2ac/0x700 fs/ocfs2/journal.c:370
 ocfs2_simple_size_update+0xd6/0x4a0 fs/ocfs2/file.c:322
 ocfs2_extend_local_quota_file fs/ocfs2/quota_local.c:1126 [inline]
 ocfs2_create_local_dquot+0x70d/0x1af0 fs/ocfs2/quota_local.c:1230
 ocfs2_acquire_dquot+0x6d7/0xb30 fs/ocfs2/quota_global.c:888
 dqget+0x7b1/0xf10 fs/quota/dquot.c:980
 __dquot_initialize+0x3ba/0xd30 fs/quota/dquot.c:1508
 ocfs2_get_init_inode+0x147/0x1c0 fs/ocfs2/namei.c:206
 ocfs2_mknod+0xa67/0x2290 fs/ocfs2/namei.c:314
 ocfs2_create+0x195/0x490 fs/ocfs2/namei.c:677
 lookup_open fs/namei.c:4483 [inline]
 open_last_lookups fs/namei.c:4583 [inline]
 path_openat+0x1395/0x3860 fs/namei.c:4827
 do_file_open+0x23e/0x4a0 fs/namei.c:4859
 do_sys_openat2+0x113/0x200 fs/open.c:1366
 do_sys_open fs/open.c:1372 [inline]
 __do_sys_creat fs/open.c:1450 [inline]
 __se_sys_creat fs/open.c:1444 [inline]
 __x64_sys_creat+0x8f/0xc0 fs/open.c:1444
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0x14d/0xf80 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f179d59aeb9
Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007fff2b7c4428 EFLAGS: 00000246 ORIG_RAX: 0000000000000055
RAX: ffffffffffffffda RBX: 00007f179d815fa0 RCX: 00007f179d59aeb9
RDX: 0000000000000000 RSI: 0000000000000000 RDI: 00002000000002c0
RBP: 00007f179d608c1f R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007f179d815fac R14: 00007f179d815fa0 R15: 00007f179d815fa0
 </TASK>
(syz.0.17,5979,0):ocfs2_block_check_validate:402 ERROR: CRC32 failed: stored: 0x2c7b5077, computed 0x4d558a87. Applying ECC.
(syz.0.17,5979,0):ocfs2_block_check_validate:416 ERROR: Fixed CRC32 failed: stored: 0x2c7b5077, computed 0x5d2751af
(syz.0.17,5979,0):ocfs2_read_quota_phys_block:160 ERROR: status = -5
(syz.0.17,5979,0):ocfs2_quota_read:201 ERROR: status = -5
Quota error (device loop0): find_tree_dqentry: Can't read quota tree block 5
Quota error (device loop0): qtree_read_dquot: Can't read quota structure for id 0
(syz.0.17,5979,1):ocfs2_acquire_dquot:895 ERROR: status = -5
(syz.0.17,5979,1):ocfs2_mknod:318 ERROR: status = -5
(syz.0.17,5979,1):ocfs2_mknod:506 ERROR: status = -5
(syz.0.17,5979,1):ocfs2_create:679 ERROR: status = -5


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
