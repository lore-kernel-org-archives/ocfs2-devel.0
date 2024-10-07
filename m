Received: from mail-io1-f70.google.com (mail-io1-f70.google.com [209.85.166.70])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BEDCB18E059
	for <ocfs2-devel@lists.linux.dev>; Mon,  7 Oct 2024 09:15:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.70
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728292523; cv=none; b=WAKy2Q7bCwd3PE1FunBjsbo9BhIM/TtVCT8g13IeB+f8aYEDQPlCMkb4s7g5yh9gYAk6LptnObyHtbOIuvV4/px1YXSPa9EEmZoM89tYdr3vtQaPrz1P0LnNjKcLaR9PIJC+YgDVaYyMisk+xs2ReV9wPM/dJasdiI0O83uADTA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728292523; c=relaxed/simple;
	bh=J+H2WhR3dR3cDdUivy8O1/d/bgmeC0CQiJc1a+ZNs7o=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=QnPngmLcgZZL7LF3jxI3iCM+/hyYKfGTLpb99cIqu6ytPQKG10mBUFyRoHCrRNGk2T5gkOF7MZO6qlCuJn+wZDF21W1s1HZYmAa9hgl2IOZvS6FOE3Ug2ZGN4H/UU4QSQ2dt2mk7mewJcI59jRAT6HGjVBK8WdRzG4FdAcGphMc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.70
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-io1-f70.google.com with SMTP id ca18e2360f4ac-82cf30e0092so386581339f.3
        for <ocfs2-devel@lists.linux.dev>; Mon, 07 Oct 2024 02:15:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728292521; x=1728897321;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=6C8BeosAWbbybQdA11WLjYr0lz2A0As583HUCTx5Nao=;
        b=RxY/0wKsxTXUQ/ooUgreyi8y9UsVTO937dAMeAfhrjumsutplKKYukH8qr0gRiUP6s
         DiEPPjIMIlw8Cgcs+9BlirhLzkLq4wvjiMICC16RLc1u9QDBBTaLngGv8M1UXSsBXK1U
         lc906GD+CR5hU83cqcnQmZu2ZNERnDfxnPCHpME10CFZRbaVtlgg3B0ewcs3tfoFVSzy
         i/QkFLZWhKbgOAseKjK82EpGxVESZS6XscxirDbPQlPPvAHgXEoDsIn2jUNkjOVJ8t0y
         sYxm2FDy7ZmTnfsIc+/z3IzYERIiiVlRkUUkK61RfQv7pV3WkHOotZz575eLM3BV6JPV
         ms0g==
X-Forwarded-Encrypted: i=1; AJvYcCXyJix38DzBWpK5V+k680YX7ZhTaP3T4qfnjOJFDZqcuAYK8kQamljSg20LhGU30K9OpnDyXYs7gAO0lg==@lists.linux.dev
X-Gm-Message-State: AOJu0YwAW+j62Bl2t5cOOkSuZvwZq829eJtGJvZS0r3IfGSZgswe0mJm
	QWC6FWDjQpFLgpy9cDEqinSI3OWJJ7KY4si/mEVpBTes4kqeaBznYmGs82pwSzJxBpdeiqRb2Nl
	g0MiGv83XdVa01gp0TYrlf8ES8cH7urBdZYpBaKa24x2tl/Ze3nGJ7ZA=
X-Google-Smtp-Source: AGHT+IHOq40TCRztjfXgMYvkwY7CjGLUZWm7JsRcsHvAUwPK2wi9xUAoRzpZGOXfzXj9N2J7IXx2C48/uqkXjvMtFLA2LhlKR9Qq
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6602:2c03:b0:82c:fdc2:e25a with SMTP id
 ca18e2360f4ac-834f7a90c2cmr1158372139f.0.1728292520912; Mon, 07 Oct 2024
 02:15:20 -0700 (PDT)
Date: Mon, 07 Oct 2024 02:15:20 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6703a6a8.050a0220.49194.0500.GAE@google.com>
Subject: [syzbot] [ocfs2?] possible deadlock in ocfs2_write_info
From: syzbot <syzbot+94932b9f2c4c6a9e8fee@syzkaller.appspotmail.com>
To: jlbec@evilplan.org, joseph.qi@linux.alibaba.com, 
	linux-kernel@vger.kernel.org, mark@fasheh.com, ocfs2-devel@lists.linux.dev, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    f23aa4c0761a Merge tag 'hid-for-linus-2024090201' of git:/..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=119393d0580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=f8af0b3195caed62
dashboard link: https://syzkaller.appspot.com/bug?extid=94932b9f2c4c6a9e8fee
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/98e7ebb9603f/disk-f23aa4c0.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/2b99ed3c1261/vmlinux-f23aa4c0.xz
kernel image: https://storage.googleapis.com/syzbot-assets/9c2b8860052e/bzImage-f23aa4c0.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+94932b9f2c4c6a9e8fee@syzkaller.appspotmail.com

======================================================
WARNING: possible circular locking dependency detected
6.12.0-rc1-syzkaller-00042-gf23aa4c0761a #0 Not tainted
------------------------------------------------------
syz.0.149/6839 is trying to acquire lock:
ffff88806c57e610 (sb_internal#3){.+.+}-{0:0}, at: ocfs2_write_info+0x128/0x3a0 fs/ocfs2/quota_global.c:992

but task is already holding lock:
ffff88807d164da0 (&ocfs2_quota_ip_alloc_sem_key){++++}-{3:3}, at: ocfs2_lock_global_qf+0x225/0x2b0 fs/ocfs2/quota_global.c:314

which lock already depends on the new lock.


the existing dependency chain (in reverse order) is:

-> #6 (&ocfs2_quota_ip_alloc_sem_key){++++}-{3:3}:
       lock_acquire+0x1ed/0x550 kernel/locking/lockdep.c:5825
       down_write+0x99/0x220 kernel/locking/rwsem.c:1577
       ocfs2_lock_global_qf+0x225/0x2b0 fs/ocfs2/quota_global.c:314
       ocfs2_acquire_dquot+0x2b0/0xb80 fs/ocfs2/quota_global.c:823
       dqget+0x770/0xeb0 fs/quota/dquot.c:976
       ocfs2_setattr+0x1123/0x1f50 fs/ocfs2/file.c:1240
       notify_change+0xbca/0xe90 fs/attr.c:503
       chown_common+0x501/0x850 fs/open.c:793
       vfs_fchown fs/open.c:861 [inline]
       ksys_fchown+0xe3/0x160 fs/open.c:872
       __do_sys_fchown fs/open.c:880 [inline]
       __se_sys_fchown fs/open.c:878 [inline]
       __x64_sys_fchown+0x7a/0x90 fs/open.c:878
       do_syscall_x64 arch/x86/entry/common.c:52 [inline]
       do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
       entry_SYSCALL_64_after_hwframe+0x77/0x7f

-> #5 (&ocfs2_sysfile_lock_key[args->fi_sysfile_type]#2){+.+.}-{3:3}:
       lock_acquire+0x1ed/0x550 kernel/locking/lockdep.c:5825
       down_write+0x99/0x220 kernel/locking/rwsem.c:1577
       inode_lock include/linux/fs.h:815 [inline]
       ocfs2_lock_global_qf+0x206/0x2b0 fs/ocfs2/quota_global.c:313
       ocfs2_acquire_dquot+0x2b0/0xb80 fs/ocfs2/quota_global.c:823
       dqget+0x770/0xeb0 fs/quota/dquot.c:976
       ocfs2_setattr+0x1123/0x1f50 fs/ocfs2/file.c:1240
       notify_change+0xbca/0xe90 fs/attr.c:503
       chown_common+0x501/0x850 fs/open.c:793
       vfs_fchown fs/open.c:861 [inline]
       ksys_fchown+0xe3/0x160 fs/open.c:872
       __do_sys_fchown fs/open.c:880 [inline]
       __se_sys_fchown fs/open.c:878 [inline]
       __x64_sys_fchown+0x7a/0x90 fs/open.c:878
       do_syscall_x64 arch/x86/entry/common.c:52 [inline]
       do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
       entry_SYSCALL_64_after_hwframe+0x77/0x7f

-> #4 (&dquot->dq_lock){+.+.}-{3:3}:
       lock_acquire+0x1ed/0x550 kernel/locking/lockdep.c:5825
       __mutex_lock_common kernel/locking/mutex.c:608 [inline]
       __mutex_lock+0x136/0xd70 kernel/locking/mutex.c:752
       wait_on_dquot fs/quota/dquot.c:355 [inline]
       dqget+0x6e6/0xeb0 fs/quota/dquot.c:971
       dquot_transfer+0x2c2/0x6d0 fs/quota/dquot.c:2139
       ext4_setattr+0xaf3/0x1bc0 fs/ext4/inode.c:5368
       notify_change+0xbca/0xe90 fs/attr.c:503
       chown_common+0x501/0x850 fs/open.c:793
       do_fchownat+0x16a/0x240 fs/open.c:824
       __do_sys_lchown fs/open.c:849 [inline]
       __se_sys_lchown fs/open.c:847 [inline]
       __x64_sys_lchown+0x85/0xa0 fs/open.c:847
       do_syscall_x64 arch/x86/entry/common.c:52 [inline]
       do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
       entry_SYSCALL_64_after_hwframe+0x77/0x7f

-> #3 (&ei->xattr_sem){++++}-{3:3}:
       lock_acquire+0x1ed/0x550 kernel/locking/lockdep.c:5825
       down_write+0x99/0x220 kernel/locking/rwsem.c:1577
       ext4_write_lock_xattr fs/ext4/xattr.h:154 [inline]
       ext4_xattr_set_handle+0x277/0x1580 fs/ext4/xattr.c:2373
       ext4_initxattrs+0xa3/0x120 fs/ext4/xattr_security.c:44
       security_inode_init_security+0x29c/0x480 security/security.c:1846
       __ext4_new_inode+0x3635/0x4380 fs/ext4/ialloc.c:1323
       ext4_create+0x279/0x550 fs/ext4/namei.c:2834
       lookup_open fs/namei.c:3595 [inline]
       open_last_lookups fs/namei.c:3694 [inline]
       path_openat+0x1c03/0x3590 fs/namei.c:3930
       do_filp_open+0x235/0x490 fs/namei.c:3960
       do_sys_openat2+0x13e/0x1d0 fs/open.c:1415
       do_sys_open fs/open.c:1430 [inline]
       __do_sys_openat fs/open.c:1446 [inline]
       __se_sys_openat fs/open.c:1441 [inline]
       __x64_sys_openat+0x247/0x2a0 fs/open.c:1441
       do_syscall_x64 arch/x86/entry/common.c:52 [inline]
       do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
       entry_SYSCALL_64_after_hwframe+0x77/0x7f

-> #2 (jbd2_handle){++++}-{0:0}:
       lock_acquire+0x1ed/0x550 kernel/locking/lockdep.c:5825
       start_this_handle+0x1eb4/0x2110 fs/jbd2/transaction.c:448
       jbd2__journal_start+0x2da/0x5d0 fs/jbd2/transaction.c:505
       jbd2_journal_start+0x29/0x40 fs/jbd2/transaction.c:544
       ocfs2_start_trans+0x3c9/0x700 fs/ocfs2/journal.c:352
       ocfs2_modify_bh+0xed/0x4d0 fs/ocfs2/quota_local.c:101
       ocfs2_local_read_info+0x158f/0x19f0 fs/ocfs2/quota_local.c:771
       dquot_load_quota_sb+0x762/0xbb0 fs/quota/dquot.c:2458
       dquot_load_quota_inode+0x320/0x600 fs/quota/dquot.c:2495
       ocfs2_enable_quotas+0x169/0x450 fs/ocfs2/super.c:926
       ocfs2_fill_super+0x4c8d/0x5750 fs/ocfs2/super.c:1141
       mount_bdev+0x20a/0x2d0 fs/super.c:1679
       legacy_get_tree+0xee/0x190 fs/fs_context.c:662
       vfs_get_tree+0x90/0x2b0 fs/super.c:1800
       do_new_mount+0x2be/0xb40 fs/namespace.c:3507
       do_mount fs/namespace.c:3847 [inline]
       __do_sys_mount fs/namespace.c:4055 [inline]
       __se_sys_mount+0x2d6/0x3c0 fs/namespace.c:4032
       do_syscall_x64 arch/x86/entry/common.c:52 [inline]
       do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
       entry_SYSCALL_64_after_hwframe+0x77/0x7f

-> #1 (&journal->j_trans_barrier){.+.+}-{3:3}:
       lock_acquire+0x1ed/0x550 kernel/locking/lockdep.c:5825
       down_read+0xb1/0xa40 kernel/locking/rwsem.c:1524
       ocfs2_start_trans+0x3be/0x700 fs/ocfs2/journal.c:350
       ocfs2_modify_bh+0xed/0x4d0 fs/ocfs2/quota_local.c:101
       ocfs2_local_read_info+0x158f/0x19f0 fs/ocfs2/quota_local.c:771
       dquot_load_quota_sb+0x762/0xbb0 fs/quota/dquot.c:2458
       dquot_load_quota_inode+0x320/0x600 fs/quota/dquot.c:2495
       ocfs2_enable_quotas+0x169/0x450 fs/ocfs2/super.c:926
       ocfs2_fill_super+0x4c8d/0x5750 fs/ocfs2/super.c:1141
       mount_bdev+0x20a/0x2d0 fs/super.c:1679
       legacy_get_tree+0xee/0x190 fs/fs_context.c:662
       vfs_get_tree+0x90/0x2b0 fs/super.c:1800
       do_new_mount+0x2be/0xb40 fs/namespace.c:3507
       do_mount fs/namespace.c:3847 [inline]
       __do_sys_mount fs/namespace.c:4055 [inline]
       __se_sys_mount+0x2d6/0x3c0 fs/namespace.c:4032
       do_syscall_x64 arch/x86/entry/common.c:52 [inline]
       do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
       entry_SYSCALL_64_after_hwframe+0x77/0x7f

-> #0 (sb_internal#3){.+.+}-{0:0}:
       check_prev_add kernel/locking/lockdep.c:3161 [inline]
       check_prevs_add kernel/locking/lockdep.c:3280 [inline]
       validate_chain+0x18ef/0x5920 kernel/locking/lockdep.c:3904
       __lock_acquire+0x1384/0x2050 kernel/locking/lockdep.c:5202
       lock_acquire+0x1ed/0x550 kernel/locking/lockdep.c:5825
       percpu_down_read include/linux/percpu-rwsem.h:51 [inline]
       __sb_start_write include/linux/fs.h:1716 [inline]
       sb_start_intwrite include/linux/fs.h:1899 [inline]
       ocfs2_start_trans+0x2b9/0x700 fs/ocfs2/journal.c:348
       ocfs2_write_info+0x128/0x3a0 fs/ocfs2/quota_global.c:992
       quota_setinfo+0x3e1/0x500 fs/quota/quota.c:174
       __do_sys_quotactl fs/quota/quota.c:961 [inline]
       __se_sys_quotactl+0x2c4/0xa30 fs/quota/quota.c:917
       do_syscall_x64 arch/x86/entry/common.c:52 [inline]
       do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
       entry_SYSCALL_64_after_hwframe+0x77/0x7f

other info that might help us debug this:

Chain exists of:
  sb_internal#3 --> &ocfs2_sysfile_lock_key[args->fi_sysfile_type]#2 --> &ocfs2_quota_ip_alloc_sem_key

 Possible unsafe locking scenario:

       CPU0                    CPU1
       ----                    ----
  lock(&ocfs2_quota_ip_alloc_sem_key);
                               lock(&ocfs2_sysfile_lock_key[args->fi_sysfile_type]#2);
                               lock(&ocfs2_quota_ip_alloc_sem_key);
  rlock(sb_internal#3);

 *** DEADLOCK ***

3 locks held by syz.0.149/6839:
 #0: ffff88806c57e0e0 (&type->s_umount_key#79){++++}-{3:3}, at: __super_lock fs/super.c:58 [inline]
 #0: ffff88806c57e0e0 (&type->s_umount_key#79){++++}-{3:3}, at: super_lock+0x27c/0x400 fs/super.c:120
 #1: ffff88807d165100 (&ocfs2_sysfile_lock_key[args->fi_sysfile_type]#8){+.+.}-{3:3}, at: inode_lock include/linux/fs.h:815 [inline]
 #1: ffff88807d165100 (&ocfs2_sysfile_lock_key[args->fi_sysfile_type]#8){+.+.}-{3:3}, at: ocfs2_lock_global_qf+0x206/0x2b0 fs/ocfs2/quota_global.c:313
 #2: ffff88807d164da0 (&ocfs2_quota_ip_alloc_sem_key){++++}-{3:3}, at: ocfs2_lock_global_qf+0x225/0x2b0 fs/ocfs2/quota_global.c:314

stack backtrace:
CPU: 0 UID: 0 PID: 6839 Comm: syz.0.149 Not tainted 6.12.0-rc1-syzkaller-00042-gf23aa4c0761a #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 09/13/2024
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:94 [inline]
 dump_stack_lvl+0x241/0x360 lib/dump_stack.c:120
 print_circular_bug+0x13a/0x1b0 kernel/locking/lockdep.c:2074
 check_noncircular+0x36a/0x4a0 kernel/locking/lockdep.c:2206
 check_prev_add kernel/locking/lockdep.c:3161 [inline]
 check_prevs_add kernel/locking/lockdep.c:3280 [inline]
 validate_chain+0x18ef/0x5920 kernel/locking/lockdep.c:3904
 __lock_acquire+0x1384/0x2050 kernel/locking/lockdep.c:5202
 lock_acquire+0x1ed/0x550 kernel/locking/lockdep.c:5825
 percpu_down_read include/linux/percpu-rwsem.h:51 [inline]
 __sb_start_write include/linux/fs.h:1716 [inline]
 sb_start_intwrite include/linux/fs.h:1899 [inline]
 ocfs2_start_trans+0x2b9/0x700 fs/ocfs2/journal.c:348
 ocfs2_write_info+0x128/0x3a0 fs/ocfs2/quota_global.c:992
 quota_setinfo+0x3e1/0x500 fs/quota/quota.c:174
 __do_sys_quotactl fs/quota/quota.c:961 [inline]
 __se_sys_quotactl+0x2c4/0xa30 fs/quota/quota.c:917
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f330bf7dff9
Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 a8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f330cd0b038 EFLAGS: 00000246 ORIG_RAX: 00000000000000b3
RAX: ffffffffffffffda RBX: 00007f330c135f80 RCX: 00007f330bf7dff9
RDX: 0000000000000000 RSI: 0000000020000380 RDI: ffffffff80000600
RBP: 00007f330bff0296 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000020000000 R11: 0000000000000246 R12: 0000000000000000
R13: 0000000000000000 R14: 00007f330c135f80 R15: 00007ffe6a815898
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
