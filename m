Received: from mail-il1-f199.google.com (mail-il1-f199.google.com [209.85.166.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 091E9C8D7
	for <ocfs2-devel@lists.linux.dev>; Fri, 25 Oct 2024 01:08:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729818511; cv=none; b=H4MHDf7p/EjLr+XtWYnNyG3HHNp0S5NgfNle0wXwjbLvPLbM3EcZXW2vgwLkGb7KyrSA7SbDa0kJdTh4vYHwBTosfJQgBLVoMf7ru7vA5ymGkwDyidGP1VSffzxuGktgWbVMhMV+PuF99NhRPZAp6696EfyyW16WMkgMJHW072Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729818511; c=relaxed/simple;
	bh=sAQ0ZmVoGtksxsZsfHPitllYpir1CyxYAHmLSaO+Xa8=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:
	 Content-Type; b=NAFkX12g9xewkQEfxBB7Qr9Pv0Qdi9BUBge4VscTjKHZML5pvMYON1fxcgyy3itEMXPmiAVhDKqJTsJbKdCs9LYl8/wBwDBI/wLqfSqWExSmm3VP6iAA9SfgrX8MB94vSCa6zHMVekgZvlDcFZQkcdKMQcTnR7azXQ7dXvMyY8A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f199.google.com with SMTP id e9e14a558f8ab-3a3e1ef9102so15324115ab.3
        for <ocfs2-devel@lists.linux.dev>; Thu, 24 Oct 2024 18:08:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729818506; x=1730423306;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=zd7YoS9mP4B0qTt5gp7Qe+Qka8zrL4imRUzcFT2ibmU=;
        b=JGlgLDEjnt8CRJbYhHQq3Geb2rAAxDSyNgk9p/Y1emqcUS09WFHNFT51WO15Dh9F+h
         h6QpFA+vfENqTlczKW6hiwqeVZZWS3m175DtNzkAwRe4+BNA7BGiRU91wEPg9wuwKXvK
         n9J8J4kzwunwWakKNrKXydyuVUz66KaorPKhzwcmtNx0gp4u+RefOcDPTW0PPQeAdns0
         niRzPFtWSXsV+6V7a/vq/NB623/nO0vl2LEIAwmhOXrxUvm2Rc1Laikpfp5Qm/aSKyOw
         dJ7pKHdl2A4SE7Jpjhc4dobLl8pbFbGW0TtQDO97Tgmre5sVqGaIqfvf9R3hVtkUqX+H
         Ahnw==
X-Forwarded-Encrypted: i=1; AJvYcCWptcu3ckxj+h+MVadAYy9XWwhBrjpjvG/p34JgBGdMJvpA/YxwwsR4Jh3hOIn886Txu84FLrdkM2dQPw==@lists.linux.dev
X-Gm-Message-State: AOJu0Yxftzvt9fnRm/0Qs6UY2cHdZDxOxC0FanEuVPCsCF4A9s+leRBG
	rlnLwgB5eLZ13F7IFIdLyeMSATYsTG2/pIzeOiTGNCW8kG2z7YBsPpsRtfPlu2vAh1J2fRLxP5E
	6qeB24baQcIGO8Tu6bPgj4Sc2MxvBGWPJYA1oh1xtLMjAiRXzBARW3Vs=
X-Google-Smtp-Source: AGHT+IFi7BB+HlRY3wTU5TekDqwiIja3HmDU9x3Nfb+ZfXA5G0/JE244utElCytCHiwpfQ0U4WOYdkRlqDia9cyB+YYzAo7kMcxc
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1c4e:b0:3a0:90d6:1f39 with SMTP id
 e9e14a558f8ab-3a4d592cc9bmr83546765ab.2.1729818505852; Thu, 24 Oct 2024
 18:08:25 -0700 (PDT)
Date: Thu, 24 Oct 2024 18:08:25 -0700
In-Reply-To: <66fa0328.050a0220.6bad9.002c.GAE@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <671aef89.050a0220.381c35.0006.GAE@google.com>
Subject: Re: [syzbot] [ocfs2?] possible deadlock in ocfs2_acquire_dquot
From: syzbot <syzbot+51244a05705883616c95@syzkaller.appspotmail.com>
To: jlbec@evilplan.org, joseph.qi@linux.alibaba.com, 
	linux-kernel@vger.kernel.org, mark@fasheh.com, ocfs2-devel@lists.linux.dev, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

syzbot has found a reproducer for the following issue on:

HEAD commit:    ce8e69898653 Merge remote-tracking branch 'tip/irq/core' i..
git tree:       git://git.kernel.org/pub/scm/linux/kernel/git/arm64/linux.git for-kernelci
console output: https://syzkaller.appspot.com/x/log.txt?x=12bfe65f980000
kernel config:  https://syzkaller.appspot.com/x/.config?x=cf20d4aad28662c6
dashboard link: https://syzkaller.appspot.com/bug?extid=51244a05705883616c95
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40
userspace arch: arm64
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=15ca5e40580000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=14583287980000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/c4140162bfaa/disk-ce8e6989.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/9cc02a082c01/vmlinux-ce8e6989.xz
kernel image: https://storage.googleapis.com/syzbot-assets/4ca0d2cc7b00/Image-ce8e6989.gz.xz
mounted in repro #1: https://storage.googleapis.com/syzbot-assets/fae7f4b73536/mount_0.gz
mounted in repro #2: https://storage.googleapis.com/syzbot-assets/60abe9617ec0/mount_3.gz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+51244a05705883616c95@syzkaller.appspotmail.com

======================================================
WARNING: possible circular locking dependency detected
6.12.0-rc4-syzkaller-gce8e69898653 #0 Not tainted
------------------------------------------------------
syz-executor217/6496 is trying to acquire lock:
ffff0000d451e610 (sb_internal#2){.+.+}-{0:0}, at: ocfs2_acquire_dquot+0x3c4/0xa8c fs/ocfs2/quota_global.c:855

but task is already holding lock:
ffff0000e202dbe0 (&ocfs2_quota_ip_alloc_sem_key){++++}-{3:3}, at: ocfs2_lock_global_qf+0x1d4/0x260 fs/ocfs2/quota_global.c:314

which lock already depends on the new lock.


the existing dependency chain (in reverse order) is:

-> #6 (&ocfs2_quota_ip_alloc_sem_key){++++}-{3:3}:
       down_write+0x50/0xc0 kernel/locking/rwsem.c:1577
       ocfs2_lock_global_qf+0x1d4/0x260 fs/ocfs2/quota_global.c:314
       ocfs2_acquire_dquot+0x268/0xa8c fs/ocfs2/quota_global.c:823
       dqget+0x660/0xcec fs/quota/dquot.c:976
       __dquot_initialize+0x344/0xc04 fs/quota/dquot.c:1504
       dquot_initialize+0x24/0x34 fs/quota/dquot.c:1566
       ocfs2_get_init_inode+0x14c/0x1b8 fs/ocfs2/namei.c:202
       ocfs2_mknod+0x878/0x243c fs/ocfs2/namei.c:308
       ocfs2_create+0x194/0x4e0 fs/ocfs2/namei.c:672
       lookup_open fs/namei.c:3595 [inline]
       open_last_lookups fs/namei.c:3694 [inline]
       path_openat+0x13e4/0x2b14 fs/namei.c:3930
       do_filp_open+0x1bc/0x3cc fs/namei.c:3960
       do_sys_openat2+0x124/0x1b8 fs/open.c:1415
       do_sys_open fs/open.c:1430 [inline]
       __do_sys_openat fs/open.c:1446 [inline]
       __se_sys_openat fs/open.c:1441 [inline]
       __arm64_sys_openat+0x1f0/0x240 fs/open.c:1441
       __invoke_syscall arch/arm64/kernel/syscall.c:35 [inline]
       invoke_syscall+0x98/0x2b8 arch/arm64/kernel/syscall.c:49
       el0_svc_common+0x130/0x23c arch/arm64/kernel/syscall.c:132
       do_el0_svc+0x48/0x58 arch/arm64/kernel/syscall.c:151
       el0_svc+0x54/0x168 arch/arm64/kernel/entry-common.c:744
       el0t_64_sync_handler+0x84/0x108 arch/arm64/kernel/entry-common.c:762
       el0t_64_sync+0x198/0x19c arch/arm64/kernel/entry.S:600

-> #5 (&ocfs2_sysfile_lock_key[args->fi_sysfile_type]#3){+.+.}-{3:3}:
       down_write+0x50/0xc0 kernel/locking/rwsem.c:1577
       inode_lock include/linux/fs.h:815 [inline]
       ocfs2_lock_global_qf+0x1b8/0x260 fs/ocfs2/quota_global.c:313
       ocfs2_acquire_dquot+0x268/0xa8c fs/ocfs2/quota_global.c:823
       dqget+0x660/0xcec fs/quota/dquot.c:976
       __dquot_initialize+0x344/0xc04 fs/quota/dquot.c:1504
       dquot_initialize+0x24/0x34 fs/quota/dquot.c:1566
       ocfs2_get_init_inode+0x14c/0x1b8 fs/ocfs2/namei.c:202
       ocfs2_mknod+0x878/0x243c fs/ocfs2/namei.c:308
       ocfs2_create+0x194/0x4e0 fs/ocfs2/namei.c:672
       lookup_open fs/namei.c:3595 [inline]
       open_last_lookups fs/namei.c:3694 [inline]
       path_openat+0x13e4/0x2b14 fs/namei.c:3930
       do_filp_open+0x1bc/0x3cc fs/namei.c:3960
       do_sys_openat2+0x124/0x1b8 fs/open.c:1415
       do_sys_open fs/open.c:1430 [inline]
       __do_sys_openat fs/open.c:1446 [inline]
       __se_sys_openat fs/open.c:1441 [inline]
       __arm64_sys_openat+0x1f0/0x240 fs/open.c:1441
       __invoke_syscall arch/arm64/kernel/syscall.c:35 [inline]
       invoke_syscall+0x98/0x2b8 arch/arm64/kernel/syscall.c:49
       el0_svc_common+0x130/0x23c arch/arm64/kernel/syscall.c:132
       do_el0_svc+0x48/0x58 arch/arm64/kernel/syscall.c:151
       el0_svc+0x54/0x168 arch/arm64/kernel/entry-common.c:744
       el0t_64_sync_handler+0x84/0x108 arch/arm64/kernel/entry-common.c:762
       el0t_64_sync+0x198/0x19c arch/arm64/kernel/entry.S:600

-> #4 (&dquot->dq_lock){+.+.}-{3:3}:
       __mutex_lock_common+0x190/0x21a0 kernel/locking/mutex.c:608
       __mutex_lock kernel/locking/mutex.c:752 [inline]
       mutex_lock_nested+0x2c/0x38 kernel/locking/mutex.c:804
       wait_on_dquot fs/quota/dquot.c:355 [inline]
       dqget+0x5f0/0xcec fs/quota/dquot.c:971
       dquot_transfer+0x3a8/0x5c0 fs/quota/dquot.c:2153
       ext4_setattr+0x8bc/0x1624 fs/ext4/inode.c:5368
       notify_change+0x9f0/0xca0 fs/attr.c:503
       chown_common+0x438/0x700 fs/open.c:793
       vfs_fchown fs/open.c:861 [inline]
       ksys_fchown+0xe0/0x158 fs/open.c:872
       __do_sys_fchown fs/open.c:880 [inline]
       __se_sys_fchown fs/open.c:878 [inline]
       __arm64_sys_fchown+0x7c/0x94 fs/open.c:878
       __invoke_syscall arch/arm64/kernel/syscall.c:35 [inline]
       invoke_syscall+0x98/0x2b8 arch/arm64/kernel/syscall.c:49
       el0_svc_common+0x130/0x23c arch/arm64/kernel/syscall.c:132
       do_el0_svc+0x48/0x58 arch/arm64/kernel/syscall.c:151
       el0_svc+0x54/0x168 arch/arm64/kernel/entry-common.c:744
       el0t_64_sync_handler+0x84/0x108 arch/arm64/kernel/entry-common.c:762
       el0t_64_sync+0x198/0x19c arch/arm64/kernel/entry.S:600

-> #3 (&ei->xattr_sem){++++}-{3:3}:
       down_write+0x50/0xc0 kernel/locking/rwsem.c:1577
       ext4_write_lock_xattr fs/ext4/xattr.h:154 [inline]
       ext4_xattr_set_handle+0x1dc/0x12d0 fs/ext4/xattr.c:2373
       ext4_initxattrs+0xa4/0x11c fs/ext4/xattr_security.c:44
       security_inode_init_security+0x73c/0x908 security/security.c:1848
       ext4_init_security+0x44/0x58 fs/ext4/xattr_security.c:58
       __ext4_new_inode+0x2be8/0x3830 fs/ext4/ialloc.c:1323
       ext4_create+0x234/0x480 fs/ext4/namei.c:2834
       lookup_open fs/namei.c:3595 [inline]
       open_last_lookups fs/namei.c:3694 [inline]
       path_openat+0x13e4/0x2b14 fs/namei.c:3930
       do_filp_open+0x1bc/0x3cc fs/namei.c:3960
       do_sys_openat2+0x124/0x1b8 fs/open.c:1415
       do_sys_open fs/open.c:1430 [inline]
       __do_sys_openat fs/open.c:1446 [inline]
       __se_sys_openat fs/open.c:1441 [inline]
       __arm64_sys_openat+0x1f0/0x240 fs/open.c:1441
       __invoke_syscall arch/arm64/kernel/syscall.c:35 [inline]
       invoke_syscall+0x98/0x2b8 arch/arm64/kernel/syscall.c:49
       el0_svc_common+0x130/0x23c arch/arm64/kernel/syscall.c:132
       do_el0_svc+0x48/0x58 arch/arm64/kernel/syscall.c:151
       el0_svc+0x54/0x168 arch/arm64/kernel/entry-common.c:744
       el0t_64_sync_handler+0x84/0x108 arch/arm64/kernel/entry-common.c:762
       el0t_64_sync+0x198/0x19c arch/arm64/kernel/entry.S:600

-> #2 (jbd2_handle){.+.+}-{0:0}:
       start_this_handle+0xf34/0x11c4 fs/jbd2/transaction.c:448
       jbd2__journal_start+0x298/0x544 fs/jbd2/transaction.c:505
       jbd2_journal_start+0x3c/0x4c fs/jbd2/transaction.c:544
       ocfs2_start_trans+0x3d0/0x71c fs/ocfs2/journal.c:352
       ocfs2_modify_bh+0xe4/0x484 fs/ocfs2/quota_local.c:101
       ocfs2_local_read_info+0x1220/0x15bc fs/ocfs2/quota_local.c:771
       dquot_load_quota_sb+0x6e4/0xb24 fs/quota/dquot.c:2458
       dquot_load_quota_inode+0x280/0x4f4 fs/quota/dquot.c:2495
       ocfs2_enable_quotas+0x17c/0x3cc fs/ocfs2/super.c:926
       ocfs2_fill_super+0x3f04/0x49d0 fs/ocfs2/super.c:1141
       mount_bdev+0x1d4/0x2a0 fs/super.c:1679
       ocfs2_mount+0x44/0x58 fs/ocfs2/super.c:1188
       legacy_get_tree+0xd4/0x16c fs/fs_context.c:662
       vfs_get_tree+0x90/0x28c fs/super.c:1800
       do_new_mount+0x278/0x900 fs/namespace.c:3507
       path_mount+0x590/0xe04 fs/namespace.c:3834
       do_mount fs/namespace.c:3847 [inline]
       __do_sys_mount fs/namespace.c:4055 [inline]
       __se_sys_mount fs/namespace.c:4032 [inline]
       __arm64_sys_mount+0x45c/0x5a8 fs/namespace.c:4032
       __invoke_syscall arch/arm64/kernel/syscall.c:35 [inline]
       invoke_syscall+0x98/0x2b8 arch/arm64/kernel/syscall.c:49
       el0_svc_common+0x130/0x23c arch/arm64/kernel/syscall.c:132
       do_el0_svc+0x48/0x58 arch/arm64/kernel/syscall.c:151
       el0_svc+0x54/0x168 arch/arm64/kernel/entry-common.c:744
       el0t_64_sync_handler+0x84/0x108 arch/arm64/kernel/entry-common.c:762
       el0t_64_sync+0x198/0x19c arch/arm64/kernel/entry.S:600

-> #1 (&journal->j_trans_barrier){.+.+}-{3:3}:
       down_read+0x58/0x2fc kernel/locking/rwsem.c:1524
       ocfs2_start_trans+0x3c4/0x71c fs/ocfs2/journal.c:350
       ocfs2_modify_bh+0xe4/0x484 fs/ocfs2/quota_local.c:101
       ocfs2_local_read_info+0x1220/0x15bc fs/ocfs2/quota_local.c:771
       dquot_load_quota_sb+0x6e4/0xb24 fs/quota/dquot.c:2458
       dquot_load_quota_inode+0x280/0x4f4 fs/quota/dquot.c:2495
       ocfs2_enable_quotas+0x17c/0x3cc fs/ocfs2/super.c:926
       ocfs2_fill_super+0x3f04/0x49d0 fs/ocfs2/super.c:1141
       mount_bdev+0x1d4/0x2a0 fs/super.c:1679
       ocfs2_mount+0x44/0x58 fs/ocfs2/super.c:1188
       legacy_get_tree+0xd4/0x16c fs/fs_context.c:662
       vfs_get_tree+0x90/0x28c fs/super.c:1800
       do_new_mount+0x278/0x900 fs/namespace.c:3507
       path_mount+0x590/0xe04 fs/namespace.c:3834
       do_mount fs/namespace.c:3847 [inline]
       __do_sys_mount fs/namespace.c:4055 [inline]
       __se_sys_mount fs/namespace.c:4032 [inline]
       __arm64_sys_mount+0x45c/0x5a8 fs/namespace.c:4032
       __invoke_syscall arch/arm64/kernel/syscall.c:35 [inline]
       invoke_syscall+0x98/0x2b8 arch/arm64/kernel/syscall.c:49
       el0_svc_common+0x130/0x23c arch/arm64/kernel/syscall.c:132
       do_el0_svc+0x48/0x58 arch/arm64/kernel/syscall.c:151
       el0_svc+0x54/0x168 arch/arm64/kernel/entry-common.c:744
       el0t_64_sync_handler+0x84/0x108 arch/arm64/kernel/entry-common.c:762
       el0t_64_sync+0x198/0x19c arch/arm64/kernel/entry.S:600

-> #0 (sb_internal#2){.+.+}-{0:0}:
       check_prev_add kernel/locking/lockdep.c:3161 [inline]
       check_prevs_add kernel/locking/lockdep.c:3280 [inline]
       validate_chain kernel/locking/lockdep.c:3904 [inline]
       __lock_acquire+0x33f8/0x77c8 kernel/locking/lockdep.c:5202
       lock_acquire+0x240/0x728 kernel/locking/lockdep.c:5825
       percpu_down_read include/linux/percpu-rwsem.h:51 [inline]
       __sb_start_write include/linux/fs.h:1716 [inline]
       sb_start_intwrite include/linux/fs.h:1899 [inline]
       ocfs2_start_trans+0x244/0x71c fs/ocfs2/journal.c:348
       ocfs2_acquire_dquot+0x3c4/0xa8c fs/ocfs2/quota_global.c:855
       dqget+0x660/0xcec fs/quota/dquot.c:976
       __dquot_initialize+0x344/0xc04 fs/quota/dquot.c:1504
       dquot_initialize+0x24/0x34 fs/quota/dquot.c:1566
       ocfs2_get_init_inode+0x14c/0x1b8 fs/ocfs2/namei.c:202
       ocfs2_mknod+0x878/0x243c fs/ocfs2/namei.c:308
       ocfs2_create+0x194/0x4e0 fs/ocfs2/namei.c:672
       lookup_open fs/namei.c:3595 [inline]
       open_last_lookups fs/namei.c:3694 [inline]
       path_openat+0x13e4/0x2b14 fs/namei.c:3930
       do_filp_open+0x1bc/0x3cc fs/namei.c:3960
       do_sys_openat2+0x124/0x1b8 fs/open.c:1415
       do_sys_open fs/open.c:1430 [inline]
       __do_sys_openat fs/open.c:1446 [inline]
       __se_sys_openat fs/open.c:1441 [inline]
       __arm64_sys_openat+0x1f0/0x240 fs/open.c:1441
       __invoke_syscall arch/arm64/kernel/syscall.c:35 [inline]
       invoke_syscall+0x98/0x2b8 arch/arm64/kernel/syscall.c:49
       el0_svc_common+0x130/0x23c arch/arm64/kernel/syscall.c:132
       do_el0_svc+0x48/0x58 arch/arm64/kernel/syscall.c:151
       el0_svc+0x54/0x168 arch/arm64/kernel/entry-common.c:744
       el0t_64_sync_handler+0x84/0x108 arch/arm64/kernel/entry-common.c:762
       el0t_64_sync+0x198/0x19c arch/arm64/kernel/entry.S:600

other info that might help us debug this:

Chain exists of:
  sb_internal#2 --> &ocfs2_sysfile_lock_key[args->fi_sysfile_type]#3 --> &ocfs2_quota_ip_alloc_sem_key

 Possible unsafe locking scenario:

       CPU0                    CPU1
       ----                    ----
  lock(&ocfs2_quota_ip_alloc_sem_key);
                               lock(&ocfs2_sysfile_lock_key[args->fi_sysfile_type]#3);
                               lock(&ocfs2_quota_ip_alloc_sem_key);
  rlock(sb_internal#2);

 *** DEADLOCK ***

6 locks held by syz-executor217/6496:
 #0: ffff0000d451e420 (sb_writers#10){.+.+}-{0:0}, at: mnt_want_write+0x44/0x9c fs/namespace.c:515
 #1: ffff0000e20289c0 (&type->i_mutex_dir_key#8){+.+.}-{3:3}, at: inode_lock include/linux/fs.h:815 [inline]
 #1: ffff0000e20289c0 (&type->i_mutex_dir_key#8){+.+.}-{3:3}, at: open_last_lookups fs/namei.c:3691 [inline]
 #1: ffff0000e20289c0 (&type->i_mutex_dir_key#8){+.+.}-{3:3}, at: path_openat+0x684/0x2b14 fs/namei.c:3930
 #2: ffff0000e21a9800 (&ocfs2_sysfile_lock_key[args->fi_sysfile_type]#2){+.+.}-{3:3}, at: inode_lock include/linux/fs.h:815 [inline]
 #2: ffff0000e21a9800 (&ocfs2_sysfile_lock_key[args->fi_sysfile_type]#2){+.+.}-{3:3}, at: ocfs2_reserve_suballoc_bits+0x164/0x4288 fs/ocfs2/suballoc.c:786
 #3: ffff0000e20400a8 (&dquot->dq_lock){+.+.}-{3:3}, at: ocfs2_acquire_dquot+0x25c/0xa8c fs/ocfs2/quota_global.c:818
 #4: ffff0000e202df40 (&ocfs2_sysfile_lock_key[args->fi_sysfile_type]#3){+.+.}-{3:3}, at: inode_lock include/linux/fs.h:815 [inline]
 #4: ffff0000e202df40 (&ocfs2_sysfile_lock_key[args->fi_sysfile_type]#3){+.+.}-{3:3}, at: ocfs2_lock_global_qf+0x1b8/0x260 fs/ocfs2/quota_global.c:313
 #5: ffff0000e202dbe0 (&ocfs2_quota_ip_alloc_sem_key){++++}-{3:3}, at: ocfs2_lock_global_qf+0x1d4/0x260 fs/ocfs2/quota_global.c:314

stack backtrace:
CPU: 1 UID: 0 PID: 6496 Comm: syz-executor217 Not tainted 6.12.0-rc4-syzkaller-gce8e69898653 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 09/13/2024
Call trace:
 show_stack+0x2c/0x3c arch/arm64/kernel/stacktrace.c:484 (C)
 __dump_stack lib/dump_stack.c:94 [inline]
 dump_stack_lvl+0xe4/0x150 lib/dump_stack.c:120
 dump_stack+0x1c/0x28 lib/dump_stack.c:129
 print_circular_bug+0x154/0x1c0 kernel/locking/lockdep.c:2074
 check_noncircular+0x310/0x404 kernel/locking/lockdep.c:2206
 check_prev_add kernel/locking/lockdep.c:3161 [inline]
 check_prevs_add kernel/locking/lockdep.c:3280 [inline]
 validate_chain kernel/locking/lockdep.c:3904 [inline]
 __lock_acquire+0x33f8/0x77c8 kernel/locking/lockdep.c:5202
 lock_acquire+0x240/0x728 kernel/locking/lockdep.c:5825
 percpu_down_read include/linux/percpu-rwsem.h:51 [inline]
 __sb_start_write include/linux/fs.h:1716 [inline]
 sb_start_intwrite include/linux/fs.h:1899 [inline]
 ocfs2_start_trans+0x244/0x71c fs/ocfs2/journal.c:348
 ocfs2_acquire_dquot+0x3c4/0xa8c fs/ocfs2/quota_global.c:855
 dqget+0x660/0xcec fs/quota/dquot.c:976
 __dquot_initialize+0x344/0xc04 fs/quota/dquot.c:1504
 dquot_initialize+0x24/0x34 fs/quota/dquot.c:1566
 ocfs2_get_init_inode+0x14c/0x1b8 fs/ocfs2/namei.c:202
 ocfs2_mknod+0x878/0x243c fs/ocfs2/namei.c:308
 ocfs2_create+0x194/0x4e0 fs/ocfs2/namei.c:672
 lookup_open fs/namei.c:3595 [inline]
 open_last_lookups fs/namei.c:3694 [inline]
 path_openat+0x13e4/0x2b14 fs/namei.c:3930
 do_filp_open+0x1bc/0x3cc fs/namei.c:3960
 do_sys_openat2+0x124/0x1b8 fs/open.c:1415
 do_sys_open fs/open.c:1430 [inline]
 __do_sys_openat fs/open.c:1446 [inline]
 __se_sys_openat fs/open.c:1441 [inline]
 __arm64_sys_openat+0x1f0/0x240 fs/open.c:1441
 __invoke_syscall arch/arm64/kernel/syscall.c:35 [inline]
 invoke_syscall+0x98/0x2b8 arch/arm64/kernel/syscall.c:49
 el0_svc_common+0x130/0x23c arch/arm64/kernel/syscall.c:132
 do_el0_svc+0x48/0x58 arch/arm64/kernel/syscall.c:151
 el0_svc+0x54/0x168 arch/arm64/kernel/entry-common.c:744
 el0t_64_sync_handler+0x84/0x108 arch/arm64/kernel/entry-common.c:762
 el0t_64_sync+0x198/0x19c arch/arm64/kernel/entry.S:600


---
If you want syzbot to run the reproducer, reply with:
#syz test: git://repo/address.git branch-or-commit-hash
If you attach or paste a git patch, syzbot will apply it before testing.
