Received: from mail-il1-f207.google.com (mail-il1-f207.google.com [209.85.166.207])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECFC71DF97F
	for <ocfs2-devel@lists.linux.dev>; Sun, 20 Jul 2025 14:32:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753021958; cv=none; b=p+qADu8Pc19eQXH0kAdKApvciK6eCKDwB7YzqCRNg2c0jiyGciYGmbsQdEmOAo5x6PXmHDk0x6q8QzSdPiV1KyRNAf5n939liripUpm6hxSzuBqzLfpxetaksZ2OnZtSvedGEY7leAcSrUrWKyyi4rA41d50ZkC68SxBry/ZLwY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753021958; c=relaxed/simple;
	bh=fcotWFUbAA3L1KK6Gpc3Kmhs2lMWl4H9cpJ6Rtm6Cg4=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=KbXFYCnI1rPWPm6SXGwtOupHAqBVSALHlkhAnvu3r01juEKR9myXO7slg9+ndM73U9Oe7yiaI2DsSdoMOOWybb/kKFd1CnNV8tkorU+4kRpxM63C0DR91+1HOLWdQFUW8jCBSY0MBkbfCR9JwlWTkmOHfOv8suwqi4Ubc6W+bIM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f207.google.com with SMTP id e9e14a558f8ab-3e05997f731so73755765ab.3
        for <ocfs2-devel@lists.linux.dev>; Sun, 20 Jul 2025 07:32:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753021955; x=1753626755;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=I1jcLm+5ivfDCOsHgxaG1ojL+45sBPnm8iB5q9AJr70=;
        b=os5xBc80EfBrhe22lliXMdl7zYunK/579ChpCpAci2z7tk/iwFPB2GIR7ohLtjsaRt
         jFc4KJPIZhoczh2MusCWejF/OjqM/xZK6lzsdDHpGsFqKDVtrjneejEQDDketpQuLQLO
         DD3/mUZo/oTbx4/T2n9q2esXmlUuSabeD/yqSz/Wb/u61pa7c4Maqphr77iojFMhgkdI
         860jWAt79kqWuHSKhDAi5vO3asswQfbXc1nfsYVPR+lH313DTx4DJazC8N27OAQJVsub
         qIemteZT+qnEJjleNIqtCkwGrJlWROEievO/m8io0pOxmgsMs7RTm3BmDs1/nnFhBNol
         UG4Q==
X-Forwarded-Encrypted: i=1; AJvYcCWxuchuIb7NnRzoJgl97QWNkJ2sONR4eRcveyMb1U8X84idTpkJwj4rUBgowG31/M5raZGieeF9lrxGkw==@lists.linux.dev
X-Gm-Message-State: AOJu0YwEywUbVo0CsbxTBFKZavZgK3dAWySk4eDTmZJ5ajwihK02A74x
	AfSurIzCT3jAWPp4+o5YetxEZbuMsc2TRd0mGchM941bkUrjBYXWdz6XPzwTw4EzMKd1WiJyL2I
	IEcTDs0MuXDSzFBQX+NT2t8I8WufZl9XYsuvT8OBIsdh8CCHfWUoQXfjPWPA=
X-Google-Smtp-Source: AGHT+IGiX6/70Km6mzsGii/V0WRMpJ+U+scQtbrSPwbYQFcuu9FtoReHLC4EFZBSXp3MS66kA50XFp1rhcKYZ4+ocCq55Iihm9UX
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1f86:b0:3dd:b808:be74 with SMTP id
 e9e14a558f8ab-3e282e39759mr174598075ab.13.1753021954995; Sun, 20 Jul 2025
 07:32:34 -0700 (PDT)
Date: Sun, 20 Jul 2025 07:32:34 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <687cfe02.a70a0220.693ce.00c7.GAE@google.com>
Subject: [syzbot] [ocfs2?] possible deadlock in ocfs2_extend_allocation
From: syzbot <syzbot+2c472ed017e03a3e8bda@syzkaller.appspotmail.com>
To: jlbec@evilplan.org, joseph.qi@linux.alibaba.com, 
	linux-kernel@vger.kernel.org, mark@fasheh.com, ocfs2-devel@lists.linux.dev, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    155a3c003e55 Merge tag 'for-6.16/dm-fixes-2' of git://git...
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=10a7658c580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=f09d04131ef56b22
dashboard link: https://syzkaller.appspot.com/bug?extid=2c472ed017e03a3e8bda
compiler:       Debian clang version 20.1.7 (++20250616065708+6146a88f6049-1~exp1~20250616065826.132), Debian LLD 20.1.7

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/8b4489a1d2de/disk-155a3c00.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/1c498d4c0c85/vmlinux-155a3c00.xz
kernel image: https://storage.googleapis.com/syzbot-assets/ea8acdf1d890/bzImage-155a3c00.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+2c472ed017e03a3e8bda@syzkaller.appspotmail.com

JBD2: Ignoring recovery information on journal
ocfs2: Mounting device (7,2) on (node local, slot 0) with ordered data mode.
(syz.2.45,6361,1):ocfs2_block_check_validate:402 ERROR: CRC32 failed: stored: 0x98842a5e, computed 0xe74db1cd. Applying ECC.
======================================================
WARNING: possible circular locking dependency detected
6.16.0-rc6-syzkaller-00002-g155a3c003e55 #0 Not tainted
------------------------------------------------------
syz.2.45/6361 is trying to acquire lock:
ffff888052a28618 (sb_internal#6){.+.+}-{0:0}, at: ocfs2_extend_allocation+0x6d4/0x17a0 fs/ocfs2/file.c:597

but task is already holding lock:
ffff888076345100 (&ocfs2_sysfile_lock_key[args->fi_sysfile_type]#3){+.+.}-{4:4}, at: inode_lock include/linux/fs.h:869 [inline]
ffff888076345100 (&ocfs2_sysfile_lock_key[args->fi_sysfile_type]#3){+.+.}-{4:4}, at: ocfs2_reserve_suballoc_bits+0x15e/0x4640 fs/ocfs2/suballoc.c:788

which lock already depends on the new lock.


the existing dependency chain (in reverse order) is:

-> #7 (&ocfs2_sysfile_lock_key[args->fi_sysfile_type]#3){+.+.}-{4:4}:
       lock_acquire+0x120/0x360 kernel/locking/lockdep.c:5871
       down_write+0x96/0x1f0 kernel/locking/rwsem.c:1577
       inode_lock include/linux/fs.h:869 [inline]
       ocfs2_reserve_suballoc_bits+0x15e/0x4640 fs/ocfs2/suballoc.c:788
       ocfs2_reserve_cluster_bitmap_bits fs/ocfs2/suballoc.c:1134 [inline]
       ocfs2_reserve_clusters_with_limit+0x2fb/0xba0 fs/ocfs2/suballoc.c:1179
       ocfs2_reserve_clusters fs/ocfs2/suballoc.c:1229 [inline]
       ocfs2_lock_allocators+0x2fa/0x5c0 fs/ocfs2/suballoc.c:2772
       ocfs2_extend_allocation+0x39b/0x17a0 fs/ocfs2/file.c:589
       ocfs2_extend_no_holes+0x20e/0x4a0 fs/ocfs2/file.c:1027
       ocfs2_acquire_dquot+0x6c6/0xb30 fs/ocfs2/quota_global.c:853
       dqget+0x7ae/0xf10 fs/quota/dquot.c:977
       ocfs2_setattr+0xd72/0x1b40 fs/ocfs2/file.c:1233
       notify_change+0xb36/0xe40 fs/attr.c:552
       chown_common+0x40c/0x5c0 fs/open.c:790
       vfs_fchown fs/open.c:858 [inline]
       ksys_fchown+0xea/0x160 fs/open.c:870
       __do_sys_fchown fs/open.c:875 [inline]
       __se_sys_fchown fs/open.c:873 [inline]
       __x64_sys_fchown+0x7a/0x90 fs/open.c:873
       do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
       do_syscall_64+0xfa/0x3b0 arch/x86/entry/syscall_64.c:94
       entry_SYSCALL_64_after_hwframe+0x77/0x7f

-> #6 (&ocfs2_quota_ip_alloc_sem_key){++++}-{4:4}:
       lock_acquire+0x120/0x360 kernel/locking/lockdep.c:5871
       down_write+0x96/0x1f0 kernel/locking/rwsem.c:1577
       ocfs2_lock_global_qf+0x1e8/0x270 fs/ocfs2/quota_global.c:314
       ocfs2_acquire_dquot+0x2b0/0xb30 fs/ocfs2/quota_global.c:828
       dqget+0x7ae/0xf10 fs/quota/dquot.c:977
       ocfs2_setattr+0xd72/0x1b40 fs/ocfs2/file.c:1233
       notify_change+0xb36/0xe40 fs/attr.c:552
       chown_common+0x40c/0x5c0 fs/open.c:790
       vfs_fchown fs/open.c:858 [inline]
       ksys_fchown+0xea/0x160 fs/open.c:870
       __do_sys_fchown fs/open.c:875 [inline]
       __se_sys_fchown fs/open.c:873 [inline]
       __x64_sys_fchown+0x7a/0x90 fs/open.c:873
       do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
       do_syscall_64+0xfa/0x3b0 arch/x86/entry/syscall_64.c:94
       entry_SYSCALL_64_after_hwframe+0x77/0x7f

-> #5 (&ocfs2_sysfile_lock_key[args->fi_sysfile_type]#2){+.+.}-{4:4}:
       lock_acquire+0x120/0x360 kernel/locking/lockdep.c:5871
       down_write+0x96/0x1f0 kernel/locking/rwsem.c:1577
       inode_lock include/linux/fs.h:869 [inline]
       ocfs2_lock_global_qf+0x1ca/0x270 fs/ocfs2/quota_global.c:313
       ocfs2_acquire_dquot+0x2b0/0xb30 fs/ocfs2/quota_global.c:828
       dqget+0x7ae/0xf10 fs/quota/dquot.c:977
       ocfs2_setattr+0xd72/0x1b40 fs/ocfs2/file.c:1233
       notify_change+0xb36/0xe40 fs/attr.c:552
       chown_common+0x40c/0x5c0 fs/open.c:790
       vfs_fchown fs/open.c:858 [inline]
       ksys_fchown+0xea/0x160 fs/open.c:870
       __do_sys_fchown fs/open.c:875 [inline]
       __se_sys_fchown fs/open.c:873 [inline]
       __x64_sys_fchown+0x7a/0x90 fs/open.c:873
       do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
       do_syscall_64+0xfa/0x3b0 arch/x86/entry/syscall_64.c:94
       entry_SYSCALL_64_after_hwframe+0x77/0x7f

-> #4 (&dquot->dq_lock){+.+.}-{4:4}:
       lock_acquire+0x120/0x360 kernel/locking/lockdep.c:5871
       __mutex_lock_common kernel/locking/mutex.c:602 [inline]
       __mutex_lock+0x182/0xe80 kernel/locking/mutex.c:747
       wait_on_dquot fs/quota/dquot.c:354 [inline]
       dqget+0x72a/0xf10 fs/quota/dquot.c:972
       dquot_transfer+0x2f8/0x6d0 fs/quota/dquot.c:2140
       ext4_setattr+0x865/0x1bc0 fs/ext4/inode.c:5817
       notify_change+0xb36/0xe40 fs/attr.c:552
       chown_common+0x40c/0x5c0 fs/open.c:790
       vfs_fchown fs/open.c:858 [inline]
       ksys_fchown+0xea/0x160 fs/open.c:870
       __do_sys_fchown fs/open.c:875 [inline]
       __se_sys_fchown fs/open.c:873 [inline]
       __x64_sys_fchown+0x7a/0x90 fs/open.c:873
       do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
       do_syscall_64+0xfa/0x3b0 arch/x86/entry/syscall_64.c:94
       entry_SYSCALL_64_after_hwframe+0x77/0x7f

-> #3 (&ei->xattr_sem){++++}-{4:4}:
       lock_acquire+0x120/0x360 kernel/locking/lockdep.c:5871
       down_write+0x96/0x1f0 kernel/locking/rwsem.c:1577
       ext4_write_lock_xattr fs/ext4/xattr.h:157 [inline]
       ext4_xattr_set_handle+0x165/0x1590 fs/ext4/xattr.c:2362
       ext4_initxattrs+0x9f/0x110 fs/ext4/xattr_security.c:44
       security_inode_init_security+0x2a0/0x3f0 security/security.c:1852
       __ext4_new_inode+0x3257/0x3c50 fs/ext4/ialloc.c:1325
       ext4_create+0x22d/0x460 fs/ext4/namei.c:2822
       lookup_open fs/namei.c:3717 [inline]
       open_last_lookups fs/namei.c:3816 [inline]
       path_openat+0x14f4/0x3830 fs/namei.c:4052
       do_filp_open+0x1fa/0x410 fs/namei.c:4082
       do_sys_openat2+0x121/0x1c0 fs/open.c:1437
       do_sys_open fs/open.c:1452 [inline]
       __do_sys_openat fs/open.c:1468 [inline]
       __se_sys_openat fs/open.c:1463 [inline]
       __x64_sys_openat+0x138/0x170 fs/open.c:1463
       do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
       do_syscall_64+0xfa/0x3b0 arch/x86/entry/syscall_64.c:94
       entry_SYSCALL_64_after_hwframe+0x77/0x7f

-> #2 (jbd2_handle){++++}-{0:0}:
       lock_acquire+0x120/0x360 kernel/locking/lockdep.c:5871
       start_this_handle+0x1fa7/0x21c0 fs/jbd2/transaction.c:444
       jbd2__journal_start+0x2c1/0x5b0 fs/jbd2/transaction.c:501
       jbd2_journal_start+0x2a/0x40 fs/jbd2/transaction.c:540
       ocfs2_start_trans+0x376/0x6d0 fs/ocfs2/journal.c:374
       ocfs2_modify_bh+0xe8/0x470 fs/ocfs2/quota_local.c:101
       ocfs2_local_read_info+0x1465/0x17e0 fs/ocfs2/quota_local.c:767
       dquot_load_quota_sb+0x78e/0xbd0 fs/quota/dquot.c:2459
       dquot_load_quota_inode+0x2e1/0x5d0 fs/quota/dquot.c:2496
       ocfs2_enable_quotas+0x1c6/0x450 fs/ocfs2/super.c:930
       ocfs2_fill_super+0x5115/0x63d0 fs/ocfs2/super.c:1140
       get_tree_bdev_flags+0x40e/0x4d0 fs/super.c:1681
       vfs_get_tree+0x92/0x2b0 fs/super.c:1804
       do_new_mount+0x24a/0xa40 fs/namespace.c:3902
       do_mount fs/namespace.c:4239 [inline]
       __do_sys_mount fs/namespace.c:4450 [inline]
       __se_sys_mount+0x317/0x410 fs/namespace.c:4427
       do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
       do_syscall_64+0xfa/0x3b0 arch/x86/entry/syscall_64.c:94
       entry_SYSCALL_64_after_hwframe+0x77/0x7f

-> #1 (&journal->j_trans_barrier){.+.+}-{4:4}:
       lock_acquire+0x120/0x360 kernel/locking/lockdep.c:5871
       down_read+0x46/0x2e0 kernel/locking/rwsem.c:1524
       ocfs2_start_trans+0x36a/0x6d0 fs/ocfs2/journal.c:372
       ocfs2_modify_bh+0xe8/0x470 fs/ocfs2/quota_local.c:101
       ocfs2_local_read_info+0x1465/0x17e0 fs/ocfs2/quota_local.c:767
       dquot_load_quota_sb+0x78e/0xbd0 fs/quota/dquot.c:2459
       dquot_load_quota_inode+0x2e1/0x5d0 fs/quota/dquot.c:2496
       ocfs2_enable_quotas+0x1c6/0x450 fs/ocfs2/super.c:930
       ocfs2_fill_super+0x5115/0x63d0 fs/ocfs2/super.c:1140
       get_tree_bdev_flags+0x40e/0x4d0 fs/super.c:1681
       vfs_get_tree+0x92/0x2b0 fs/super.c:1804
       do_new_mount+0x24a/0xa40 fs/namespace.c:3902
       do_mount fs/namespace.c:4239 [inline]
       __do_sys_mount fs/namespace.c:4450 [inline]
       __se_sys_mount+0x317/0x410 fs/namespace.c:4427
       do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
       do_syscall_64+0xfa/0x3b0 arch/x86/entry/syscall_64.c:94
       entry_SYSCALL_64_after_hwframe+0x77/0x7f

-> #0 (sb_internal#6){.+.+}-{0:0}:
       check_prev_add kernel/locking/lockdep.c:3168 [inline]
       check_prevs_add kernel/locking/lockdep.c:3287 [inline]
       validate_chain+0xb9b/0x2140 kernel/locking/lockdep.c:3911
       __lock_acquire+0xab9/0xd20 kernel/locking/lockdep.c:5240
       lock_acquire+0x120/0x360 kernel/locking/lockdep.c:5871
       percpu_down_read_internal include/linux/percpu-rwsem.h:53 [inline]
       percpu_down_read_freezable include/linux/percpu-rwsem.h:83 [inline]
       __sb_start_write include/linux/fs.h:1795 [inline]
       sb_start_intwrite include/linux/fs.h:1978 [inline]
       ocfs2_start_trans+0x26b/0x6d0 fs/ocfs2/journal.c:370
       ocfs2_extend_allocation+0x6d4/0x17a0 fs/ocfs2/file.c:597
       ocfs2_extend_no_holes+0x20e/0x4a0 fs/ocfs2/file.c:1027
       ocfs2_acquire_dquot+0x6c6/0xb30 fs/ocfs2/quota_global.c:853
       dqget+0x7ae/0xf10 fs/quota/dquot.c:977
       ocfs2_setattr+0xd72/0x1b40 fs/ocfs2/file.c:1233
       notify_change+0xb36/0xe40 fs/attr.c:552
       chown_common+0x40c/0x5c0 fs/open.c:790
       vfs_fchown fs/open.c:858 [inline]
       ksys_fchown+0xea/0x160 fs/open.c:870
       __do_sys_fchown fs/open.c:875 [inline]
       __se_sys_fchown fs/open.c:873 [inline]
       __x64_sys_fchown+0x7a/0x90 fs/open.c:873
       do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
       do_syscall_64+0xfa/0x3b0 arch/x86/entry/syscall_64.c:94
       entry_SYSCALL_64_after_hwframe+0x77/0x7f

other info that might help us debug this:

Chain exists of:
  sb_internal#6 --> &ocfs2_quota_ip_alloc_sem_key --> &ocfs2_sysfile_lock_key[args->fi_sysfile_type]#3

 Possible unsafe locking scenario:

       CPU0                    CPU1
       ----                    ----
  lock(&ocfs2_sysfile_lock_key[args->fi_sysfile_type]#3);
                               lock(&ocfs2_quota_ip_alloc_sem_key);
                               lock(&ocfs2_sysfile_lock_key[args->fi_sysfile_type]#3);
  rlock(sb_internal#6);

 *** DEADLOCK ***

6 locks held by syz.2.45/6361:
 #0: ffff888052a28428 (sb_writers#23){.+.+}-{0:0}, at: mnt_want_write_file+0x60/0x200 fs/namespace.c:601
 #1: ffff8880763409c0 (&type->i_mutex_dir_key#16){++++}-{4:4}, at: inode_lock_killable include/linux/fs.h:874 [inline]
 #1: ffff8880763409c0 (&type->i_mutex_dir_key#16){++++}-{4:4}, at: chown_common+0x313/0x5c0 fs/open.c:778
 #2: ffff88807607e0a8 (&dquot->dq_lock){+.+.}-{4:4}, at: ocfs2_acquire_dquot+0x2a3/0xb30 fs/ocfs2/quota_global.c:823
 #3: ffff888076345f40 (&ocfs2_sysfile_lock_key[args->fi_sysfile_type]#2){+.+.}-{4:4}, at: inode_lock include/linux/fs.h:869 [inline]
 #3: ffff888076345f40 (&ocfs2_sysfile_lock_key[args->fi_sysfile_type]#2){+.+.}-{4:4}, at: ocfs2_lock_global_qf+0x1ca/0x270 fs/ocfs2/quota_global.c:313
 #4: ffff888076345be0 (&ocfs2_quota_ip_alloc_sem_key){++++}-{4:4}, at: ocfs2_lock_global_qf+0x1e8/0x270 fs/ocfs2/quota_global.c:314
 #5: ffff888076345100 (&ocfs2_sysfile_lock_key[args->fi_sysfile_type]#3){+.+.}-{4:4}, at: inode_lock include/linux/fs.h:869 [inline]
 #5: ffff888076345100 (&ocfs2_sysfile_lock_key[args->fi_sysfile_type]#3){+.+.}-{4:4}, at: ocfs2_reserve_suballoc_bits+0x15e/0x4640 fs/ocfs2/suballoc.c:788

stack backtrace:
CPU: 1 UID: 0 PID: 6361 Comm: syz.2.45 Not tainted 6.16.0-rc6-syzkaller-00002-g155a3c003e55 #0 PREEMPT(full) 
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 05/07/2025
Call Trace:
 <TASK>
 dump_stack_lvl+0x189/0x250 lib/dump_stack.c:120
 print_circular_bug+0x2ee/0x310 kernel/locking/lockdep.c:2046
 check_noncircular+0x134/0x160 kernel/locking/lockdep.c:2178
 check_prev_add kernel/locking/lockdep.c:3168 [inline]
 check_prevs_add kernel/locking/lockdep.c:3287 [inline]
 validate_chain+0xb9b/0x2140 kernel/locking/lockdep.c:3911
 __lock_acquire+0xab9/0xd20 kernel/locking/lockdep.c:5240
 lock_acquire+0x120/0x360 kernel/locking/lockdep.c:5871
 percpu_down_read_internal include/linux/percpu-rwsem.h:53 [inline]
 percpu_down_read_freezable include/linux/percpu-rwsem.h:83 [inline]
 __sb_start_write include/linux/fs.h:1795 [inline]
 sb_start_intwrite include/linux/fs.h:1978 [inline]
 ocfs2_start_trans+0x26b/0x6d0 fs/ocfs2/journal.c:370
 ocfs2_extend_allocation+0x6d4/0x17a0 fs/ocfs2/file.c:597
 ocfs2_extend_no_holes+0x20e/0x4a0 fs/ocfs2/file.c:1027
 ocfs2_acquire_dquot+0x6c6/0xb30 fs/ocfs2/quota_global.c:853
 dqget+0x7ae/0xf10 fs/quota/dquot.c:977
 ocfs2_setattr+0xd72/0x1b40 fs/ocfs2/file.c:1233
 notify_change+0xb36/0xe40 fs/attr.c:552
 chown_common+0x40c/0x5c0 fs/open.c:790
 vfs_fchown fs/open.c:858 [inline]
 ksys_fchown+0xea/0x160 fs/open.c:870
 __do_sys_fchown fs/open.c:875 [inline]
 __se_sys_fchown fs/open.c:873 [inline]
 __x64_sys_fchown+0x7a/0x90 fs/open.c:873
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0xfa/0x3b0 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7feefbb8e929
Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 a8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007feefc940038 EFLAGS: 00000246 ORIG_RAX: 000000000000005d
RAX: ffffffffffffffda RBX: 00007feefbdb5fa0 RCX: 00007feefbb8e929
RDX: 000000002108420a RSI: 000000003a736e6f RDI: 0000000000000004
RBP: 00007feefbc10b39 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 0000000000000000 R14: 00007feefbdb5fa0 R15: 00007ffcf2ccc4d8
 </TASK>
(syz.2.45,6361,0):ocfs2_block_check_validate:402 ERROR: CRC32 failed: stored: 0xdf8356d3, computed 0xb8c23ae4. Applying ECC.
(syz.2.45,6361,0):ocfs2_block_check_validate:416 ERROR: Fixed CRC32 failed: stored: 0xdf8356d3, computed 0x2acb7e3c
(syz.2.45,6361,0):ocfs2_read_quota_phys_block:160 ERROR: status = -5
(syz.2.45,6361,1):ocfs2_quota_read:201 ERROR: status = -5
Quota error (device loop2): qtree_write_dquot: Error -5 occurred while creating quota
(syz.2.45,6361,0):ocfs2_acquire_dquot:890 ERROR: status = -5


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
