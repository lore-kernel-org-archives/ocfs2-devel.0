Received: from mail-oi1-f207.google.com (mail-oi1-f207.google.com [209.85.167.207])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E221E70830
	for <ocfs2-devel@lists.linux.dev>; Thu, 30 Jul 2026 00:10:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785370223; cv=none; b=Ob8pyJSl74+4GbBFRcMqgPy+iHAn0PNuC/9rv+zDuydpesMN7VCFeN+tJgAMSiTWgv8EgwD4WE6q2GAXPe16/gRXwixVrxulLEElkkex2DdxT3jlxvc2wUFnfM36j1z1AwhqT+OV7hCD2YsFSzO9jezFaVE9Lef9aogfCVCmTFo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785370223; c=relaxed/simple;
	bh=n4R98EO+RAyhKblGQKIBYDt/JWQxRkV76xyl3IsiB78=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=Pky9Yg4rZnrPN6p5SoYRvAYg7F/QltY9lIwrnt9op1wiJ9xBTBhU9iRefEmUu8Vtoodz+JXaaD5/ImWIVxenJDNvGTXELBVP3fbFLUMKm13rnInzBrVzLPeQEDi6LXnn5FOBDxO+nLJfcByYN49ClUrFOfSP6rqlpus4UHbUSkw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.167.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oi1-f207.google.com with SMTP id 5614622812f47-4ad778bacbeso1050066b6e.1
        for <ocfs2-devel@lists.linux.dev>; Wed, 29 Jul 2026 17:10:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785370221; x=1785975021;
        h=content-type:to:from:subject:message-id:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=M5YX5tMX/98Cqn5qzMKnodP/m+Ya5EooLuH+rOcJKvI=;
        b=SMVsBAveNI89Ejz/eyMNIYrDiwaunwByiJTKfQcX3zqu4PMSl5QKGWjSyDheXGIuhD
         SuAmuZr2by3LLPdmEBP/xiLxH4sm5iF1hYnHJLZNxzWxj05eQHe6HhLEZ4D0Gl4xuuKU
         FAjiPaM6HxYPSxW7TKTdHmOof+AT88pl46se09GaiiwX7BomwhHecFeRAv/c2pHRCIeH
         SbG5p6zth+qx0ws+CmoGQoO3HKGnuJ0eXydj4yODCZ8oOrueyM5yjsotI/RPRHcsDYtg
         LK7aQqJ54MzNMjfvFqe/qnI96UyAIwIljtGFxmuMkzyHJPiv0D/wPDqsdgbXaJFaLmcY
         3F7A==
X-Forwarded-Encrypted: i=1; AHgh+RoE9S10DAKo3IhH9QyBhxPPiiZQf40gpI0YuDgwMCSiMGw5lr6RIiXOKUbiu70oYDjBB3oWGymq8Y3XSA==@lists.linux.dev
X-Gm-Message-State: AOJu0YzPtsnQjS3IMcLYfu7EUapkTTCzHPC9+A7jEKwPmLF94LTIUF+Z
	afpgMdBAx+VHV3/qBYro4yWAwgyyMuuEWdcIgMa7SU/wzxKFqxpa6RLCR6JH6o6EjAOIds/IXQe
	D+kn3cHCLCyFwcPEPcjrRQhngllzRjQkYvG2yC/QPSZ+ueSX5Z1qgA1si0iQ=
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6808:168c:b0:4a4:c73:9ed with SMTP id
 5614622812f47-4ad87777c36mr341438b6e.15.1785370220918; Wed, 29 Jul 2026
 17:10:20 -0700 (PDT)
Date: Wed, 29 Jul 2026 17:10:20 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6a6a966c.86abc875.e5c3d.0055.GAE@google.com>
Subject: [syzbot] [ocfs2?] possible deadlock in ocfs2_reflink
From: syzbot <syzbot+e42eae29bba35810f43c@syzkaller.appspotmail.com>
To: jlbec@evilplan.org, joseph.qi@linux.alibaba.com, 
	linux-kernel@vger.kernel.org, mark@fasheh.com, ocfs2-devel@lists.linux.dev, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    e2a936998ab2 Merge tag 'drm-fixes-2026-07-25' of https://g..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=15e75fde580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=c05be6c9b0d36cb9
dashboard link: https://syzkaller.appspot.com/bug?extid=e42eae29bba35810f43c
compiler:       Debian clang version 22.1.8 (++20260613092233+e80beda6e255-1~exp1~20260613092250.77), Debian LLD 22.1.8

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/d900f083ada3/non_bootable_disk-e2a93699.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/b2992c347575/vmlinux-e2a93699.xz
kernel image: https://storage.googleapis.com/syzbot-assets/622a291c39d7/bzImage-e2a93699.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+e42eae29bba35810f43c@syzkaller.appspotmail.com

loop0: detected capacity change from 0 to 32768
BTRFS: device fsid c9fe44da-de57-406a-8241-57ec7d4412cf devid 1 transid 8 /dev/loop0 (7:0) scanned by syz.0.0 (5321)
BTRFS info (device loop0): first mount of filesystem c9fe44da-de57-406a-8241-57ec7d4412cf
BTRFS info (device loop0): using crc32c checksum algorithm
BTRFS error (device loop0): failed to load root extent
BTRFS error (device loop0): open_ctree failed: -5
loop0: detected capacity change from 0 to 32768
(syz.0.0,5321,0):ocfs2_block_check_validate:402 ERROR: CRC32 failed: stored: 0xb3775c19, computed 0x2dd1c265. Applying ECC.
(syz.0.0,5321,0):ocfs2_block_check_validate:402 ERROR: CRC32 failed: stored: 0xb3775c19, computed 0x2dd1c265. Applying ECC.
JBD2: Ignoring recovery information on journal
ocfs2: Mounting device (7,0) on (node local, slot 0) with ordered data mode.
kvm: kvm [5320]: vcpu0, guest rIP: 0xfff0 Unhandled WRMSR(0xc0010001) = 0x400003

======================================================
WARNING: possible circular locking dependency detected
syzkaller #0 Not tainted
------------------------------------------------------
syz.0.0/5321 is trying to acquire lock:
ffff888013228658 (&oi->ip_alloc_sem){++++}-{4:4}, at: ocfs2_reflink+0x4d2/0x920 fs/ocfs2/refcounttree.c:4272

but task is already holding lock:
ffff8880132286e8 (&oi->ip_xattr_sem){++++}-{4:4}, at: ocfs2_reflink+0x4c3/0x920 fs/ocfs2/refcounttree.c:4271

which lock already depends on the new lock.


the existing dependency chain (in reverse order) is:

-> #3 (&oi->ip_xattr_sem){++++}-{4:4}:
       down_read+0x4a/0x330 kernel/locking/rwsem.c:1574
       ocfs2_init_acl+0x2fd/0x7e0 fs/ocfs2/acl.c:367
       ocfs2_mknod+0x166a/0x2240 fs/ocfs2/namei.c:414
       ocfs2_create+0x195/0x460 fs/ocfs2/namei.c:677
       lookup_open fs/namei.c:4508 [inline]
       open_last_lookups fs/namei.c:4608 [inline]
       path_openat+0x133a/0x3830 fs/namei.c:4860
       do_file_open+0x23e/0x4a0 fs/namei.c:4892
       do_sys_openat2+0x115/0x200 fs/open.c:1368
       do_sys_open fs/open.c:1374 [inline]
       __do_sys_open fs/open.c:1382 [inline]
       __se_sys_open fs/open.c:1378 [inline]
       __x64_sys_open+0x11e/0x150 fs/open.c:1378
       do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
       do_syscall_64+0x174/0x580 arch/x86/entry/syscall_64.c:94
       entry_SYSCALL_64_after_hwframe+0x77/0x7f

-> #2 (&journal->j_trans_barrier){.+.+}-{4:4}:
       down_read+0x4a/0x330 kernel/locking/rwsem.c:1574
       ocfs2_start_trans+0x3ab/0x700 fs/ocfs2/journal.c:369
       ocfs2_modify_bh+0xe3/0x4d0 fs/ocfs2/quota_local.c:101
       ocfs2_local_read_info+0x146b/0x1830 fs/ocfs2/quota_local.c:767
       dquot_load_quota_sb+0x76f/0xb70 fs/quota/dquot.c:2484
       dquot_load_quota_inode+0x2dc/0x5d0 fs/quota/dquot.c:2521
       ocfs2_enable_quotas+0x1c3/0x4a0 fs/ocfs2/super.c:930
       ocfs2_fill_super+0x530c/0x6840 fs/ocfs2/super.c:1140
       get_tree_bdev_flags+0x430/0x4f0 fs/super.c:1634
       vfs_get_tree+0x92/0x2a0 fs/super.c:1694
       fc_mount fs/namespace.c:1198 [inline]
       do_new_mount_fc fs/namespace.c:3765 [inline]
       do_new_mount+0x319/0xdc0 fs/namespace.c:3841
       do_mount fs/namespace.c:4174 [inline]
       __do_sys_mount fs/namespace.c:4390 [inline]
       __se_sys_mount+0x31d/0x420 fs/namespace.c:4367
       do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
       do_syscall_64+0x174/0x580 arch/x86/entry/syscall_64.c:94
       entry_SYSCALL_64_after_hwframe+0x77/0x7f

-> #1 (sb_internal#2){.+.+}-{0:0}:
       __lock_release kernel/locking/lockdep.c:5574 [inline]
       lock_release+0x199/0x3c0 kernel/locking/lockdep.c:5889
       up_write+0x2d/0x4a0 kernel/locking/rwsem.c:1687
       inode_unlock include/linux/fs.h:1034 [inline]
       ocfs2_free_ac_resource fs/ocfs2/suballoc.c:131 [inline]
       ocfs2_free_alloc_context+0x97/0x1a0 fs/ocfs2/suballoc.c:145
       ocfs2_write_begin_nolock+0x4164/0x41f0 fs/ocfs2/aops.c:1805
       __ocfs2_page_mkwrite fs/ocfs2/mmap.c:92 [inline]
       ocfs2_page_mkwrite+0x63d/0xb60 fs/ocfs2/mmap.c:143
       do_page_mkwrite+0x147/0x310 mm/memory.c:3684
       wp_page_shared mm/memory.c:4085 [inline]
       do_wp_page+0x1973/0x4c70 mm/memory.c:4304
       handle_pte_fault mm/memory.c:6395 [inline]
       __handle_mm_fault mm/memory.c:6517 [inline]
       handle_mm_fault+0x1490/0x3080 mm/memory.c:6686
       do_user_addr_fault+0x744/0x1340 arch/x86/mm/fault.c:1394
       handle_page_fault arch/x86/mm/fault.c:1483 [inline]
       exc_page_fault+0x6a/0xc0 arch/x86/mm/fault.c:1536
       asm_exc_page_fault+0x26/0x30 arch/x86/include/asm/idtentry.h:595

-> #0 (&oi->ip_alloc_sem){++++}-{4:4}:
       check_prev_add kernel/locking/lockdep.c:3165 [inline]
       check_prevs_add kernel/locking/lockdep.c:3284 [inline]
       validate_chain kernel/locking/lockdep.c:3908 [inline]
       __lock_acquire+0x1520/0x2cf0 kernel/locking/lockdep.c:5237
       lock_acquire+0x106/0x350 kernel/locking/lockdep.c:5868
       down_write+0x96/0x200 kernel/locking/rwsem.c:1631
       ocfs2_reflink+0x4d2/0x920 fs/ocfs2/refcounttree.c:4272
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
  &oi->ip_alloc_sem --> &journal->j_trans_barrier --> &oi->ip_xattr_sem

 Possible unsafe locking scenario:

       CPU0                    CPU1
       ----                    ----
  lock(&oi->ip_xattr_sem);
                               lock(&journal->j_trans_barrier);
                               lock(&oi->ip_xattr_sem);
  lock(&oi->ip_alloc_sem);

 *** DEADLOCK ***

4 locks held by syz.0.0/5321:
 #0: ffff88801c3bc450 (sb_writers#12){.+.+}-{0:0}, at: mnt_want_write+0x41/0x90 fs/namespace.c:494
 #1: ffff8880132325a0 (&type->i_mutex_dir_key#8/1){+.+.}-{4:4}, at: inode_lock_nested include/linux/fs.h:1069 [inline]
 #1: ffff8880132325a0 (&type->i_mutex_dir_key#8/1){+.+.}-{4:4}, at: __start_dirop fs/namei.c:2918 [inline]
 #1: ffff8880132325a0 (&type->i_mutex_dir_key#8/1){+.+.}-{4:4}, at: start_dirop fs/namei.c:2942 [inline]
 #1: ffff8880132325a0 (&type->i_mutex_dir_key#8/1){+.+.}-{4:4}, at: filename_create+0x200/0x370 fs/namei.c:4955
 #2: ffff8880132289a0 (&sb->s_type->i_mutex_key#24){+.+.}-{4:4}, at: inode_lock include/linux/fs.h:1024 [inline]
 #2: ffff8880132289a0 (&sb->s_type->i_mutex_key#24){+.+.}-{4:4}, at: ocfs2_vfs_reflink+0x2f8/0x450 fs/ocfs2/refcounttree.c:4396
 #3: ffff8880132286e8 (&oi->ip_xattr_sem){++++}-{4:4}, at: ocfs2_reflink+0x4c3/0x920 fs/ocfs2/refcounttree.c:4271

stack backtrace:
CPU: 0 UID: 0 PID: 5321 Comm: syz.0.0 Not tainted syzkaller #0 PREEMPT(full) 
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
 down_write+0x96/0x200 kernel/locking/rwsem.c:1631
 ocfs2_reflink+0x4d2/0x920 fs/ocfs2/refcounttree.c:4272
 ocfs2_vfs_reflink+0x338/0x450 fs/ocfs2/refcounttree.c:4399
 ocfs2_reflink_ioctl+0x3a0/0x450 fs/ocfs2/refcounttree.c:4439
 ocfs2_ioctl+0x5b5/0x7e0 fs/ocfs2/ioctl.c:920
 vfs_ioctl fs/ioctl.c:51 [inline]
 __do_sys_ioctl fs/ioctl.c:597 [inline]
 __se_sys_ioctl+0xfc/0x170 fs/ioctl.c:583
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0x174/0x580 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7fbc3639de99
Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007fbc371f4fe8 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
RAX: ffffffffffffffda RBX: 00007fbc36625fa0 RCX: 00007fbc3639de99
RDX: 00002000000001c0 RSI: 0000000040186f04 RDI: 000000000000008c
RBP: 00007fbc36433eaf R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007fbc36626038 R14: 00007fbc36625fa0 R15: 00007ffff2ca6ac8
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
