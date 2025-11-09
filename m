Received: from mail-il1-f207.google.com (mail-il1-f207.google.com [209.85.166.207])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44ED843AA6
	for <ocfs2-devel@lists.linux.dev>; Sun,  9 Nov 2025 11:17:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762687052; cv=none; b=MhfKqwAYsPwrN60Q/tMvrelyqMeO/3zCKw4WzmhzBNMDNmQY1oZwVAB3vZaRiSlyer6yNSCoueq4coDemzoWkSfFqoLUTdgC5UfJ9DTiPOFznkgnAYGmSUQClMIcZFm3sB/nKDWEShXFgOhgJvXuv0BZTw/a/lOebsbmGPDPdyc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762687052; c=relaxed/simple;
	bh=bvtiiBkxU0LA/V3BYi3rHSyFc0Clea0LEfvnBJPOJs8=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:
	 Content-Type; b=gx7/eNNuGOWboMNyq5MXpoSxpLgUuTG1xNGt9GwsV4RzaVxNvCfVB5IYahb15IRDTHpU6oZoxaZIyXmDGptQHuPzPr2SgmFcpHiFx3t8Uc3oE5EXgF18dYKraqnz5wfJUP7swtRFlqB0+QZhj1KKaRtNWUnnkcS8XSOY6xlymBI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f207.google.com with SMTP id e9e14a558f8ab-43321627eabso74351985ab.3
        for <ocfs2-devel@lists.linux.dev>; Sun, 09 Nov 2025 03:17:30 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762687049; x=1763291849;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=haQMTyPIsifKChp8FfRY1dcpm+l01Ss3eACgO8b/HSs=;
        b=NMhJcMeGVowcRhK2rFjotecliSycMzb6X+T3qUzKxfBpn1NuG8DENcdIWJ8kzejL4v
         bXRD2bjeIgqptOI7PcDnXhChbKdcpTuheuv/ULYVH/vldgy+0JxC5qIeUQXMQRumHecQ
         r8anx/OjjNF5kCr3wqi6kii823SPNzADYUUPoQ1l2YguB3oNok+Rn6y5j5gsSGjhFmmK
         CVzzNE5EuxOmL7REVZbYRDj1iMs7yOrs8Q/PAxKZsfY0hYd3FIzSU3TVo7XzPJeTGRBA
         aAppYiHPLM2MprhQrQ8/xN7UhbSRwbxzoVyby4qottL+ftJGQIbWgJ84pHLqbBJKAwNt
         Dbpg==
X-Forwarded-Encrypted: i=1; AJvYcCUvbjABOLHfUNXAg+LHaF+qWMjTCeDCsFfiekpxbwRckxbtD9zs/NBL/+2OVFiGz6HmsKCGNlwdMw4Y/A==@lists.linux.dev
X-Gm-Message-State: AOJu0YyeGOAojn/9C7QdjShVa3MQSx3HtsKbELJQbS7dFLT1QCc/Q6SO
	bbZQasQir4b6ee6TR5M+eFzGIuH9TeTtrTJIj7yY9bFHeOtsOJ0JSLMIZBUkS4JIhAqluF0lIVq
	gF8iciyxiHmXLka/0PvlVA9aoM5ynpVON2EgOkqLSnQMo0N1SsSzK6EEGNWc=
X-Google-Smtp-Source: AGHT+IFyZGQavHB8D3zHcu0vw4WOGpyxjxm9N3HsSnlhZEXThikpRwEwXFR39KdPAr1r9Bv9UTWXh9/hrT2At18W+IwyxaInoQxT
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:198a:b0:433:7885:60f6 with SMTP id
 e9e14a558f8ab-43378856437mr33768445ab.17.1762687049404; Sun, 09 Nov 2025
 03:17:29 -0800 (PST)
Date: Sun, 09 Nov 2025 03:17:29 -0800
In-Reply-To: <6703a6a8.050a0220.49194.0500.GAE@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <69107849.a70a0220.22f260.00ac.GAE@google.com>
Subject: Re: [syzbot] [ocfs2?] possible deadlock in ocfs2_write_info
From: syzbot <syzbot+94932b9f2c4c6a9e8fee@syzkaller.appspotmail.com>
To: jlbec@evilplan.org, joseph.qi@linux.alibaba.com, 
	linux-kernel@vger.kernel.org, mark@fasheh.com, ocfs2-devel@lists.linux.dev, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

syzbot has found a reproducer for the following issue on:

HEAD commit:    e424ed997df8 Merge remote-tracking branch 'will/for-next/p..
git tree:       git://git.kernel.org/pub/scm/linux/kernel/git/arm64/linux.git for-kernelci
console output: https://syzkaller.appspot.com/x/log.txt?x=13831412580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=b8b659f0cab27b22
dashboard link: https://syzkaller.appspot.com/bug?extid=94932b9f2c4c6a9e8fee
compiler:       Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~exp1~20250708183702.136), Debian LLD 20.1.8
userspace arch: arm64
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=13d58412580000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=14501a58580000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/ada05b916921/disk-e424ed99.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/674414e6bfd1/vmlinux-e424ed99.xz
kernel image: https://storage.googleapis.com/syzbot-assets/67ca98bd56a6/Image-e424ed99.gz.xz
mounted in repro #1: https://storage.googleapis.com/syzbot-assets/485cd50bae2f/mount_0.gz
  fsck result: OK (log: https://syzkaller.appspot.com/x/fsck.log?x=12792412580000)
mounted in repro #2: https://storage.googleapis.com/syzbot-assets/f916e0691d68/mount_2.gz
  fsck result: OK (log: https://syzkaller.appspot.com/x/fsck.log?x=158a517c580000)

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+94932b9f2c4c6a9e8fee@syzkaller.appspotmail.com

(syz.0.52,6850,1):ocfs2_mknod:317 ERROR: status = -5
(syz.0.52,6850,1):ocfs2_mknod:505 ERROR: status = -5
(syz.0.52,6850,1):ocfs2_create:678 ERROR: status = -5
======================================================
WARNING: possible circular locking dependency detected
syzkaller #0 Not tainted
------------------------------------------------------
syz.0.52/6850 is trying to acquire lock:
ffff0000c8ae4610 (sb_internal#2){.+.+}-{0:0}, at: ocfs2_write_info+0x114/0x324 fs/ocfs2/quota_global.c:997

but task is already holding lock:
ffff0000ddce5be0 (&ocfs2_quota_ip_alloc_sem_key){++++}-{4:4}, at: ocfs2_lock_global_qf+0x1a8/0x22c fs/ocfs2/quota_global.c:314

which lock already depends on the new lock.


the existing dependency chain (in reverse order) is:

-> #6 (&ocfs2_quota_ip_alloc_sem_key){++++}-{4:4}:
       down_write+0x50/0xc0 kernel/locking/rwsem.c:1590
       ocfs2_lock_global_qf+0x1a8/0x22c fs/ocfs2/quota_global.c:314
       ocfs2_acquire_dquot+0x258/0xa10 fs/ocfs2/quota_global.c:828
       dqget+0x654/0xccc fs/quota/dquot.c:980
       __dquot_initialize+0x2d4/0xa80 fs/quota/dquot.c:1508
       dquot_initialize+0x24/0x34 fs/quota/dquot.c:1570
       ocfs2_get_init_inode+0x134/0x1a8 fs/ocfs2/namei.c:205
       ocfs2_mknod+0x734/0x1cf0 fs/ocfs2/namei.c:313
       ocfs2_create+0x190/0x474 fs/ocfs2/namei.c:676
       lookup_open fs/namei.c:3796 [inline]
       open_last_lookups fs/namei.c:3895 [inline]
       path_openat+0x12d8/0x2c40 fs/namei.c:4131
       do_filp_open+0x18c/0x36c fs/namei.c:4161
       do_sys_openat2+0x11c/0x1b4 fs/open.c:1437
       do_sys_open fs/open.c:1452 [inline]
       __do_sys_openat fs/open.c:1468 [inline]
       __se_sys_openat fs/open.c:1463 [inline]
       __arm64_sys_openat+0x120/0x158 fs/open.c:1463
       __invoke_syscall arch/arm64/kernel/syscall.c:35 [inline]
       invoke_syscall+0x98/0x254 arch/arm64/kernel/syscall.c:49
       el0_svc_common+0x130/0x23c arch/arm64/kernel/syscall.c:132
       do_el0_svc+0x48/0x58 arch/arm64/kernel/syscall.c:151
       el0_svc+0x5c/0x254 arch/arm64/kernel/entry-common.c:746
       el0t_64_sync_handler+0x84/0x12c arch/arm64/kernel/entry-common.c:765
       el0t_64_sync+0x198/0x19c arch/arm64/kernel/entry.S:596

-> #5 (&ocfs2_sysfile_lock_key[USER_QUOTA_SYSTEM_INODE]){+.+.}-{4:4}:
       down_write+0x50/0xc0 kernel/locking/rwsem.c:1590
       inode_lock include/linux/fs.h:980 [inline]
       ocfs2_lock_global_qf+0x18c/0x22c fs/ocfs2/quota_global.c:313
       ocfs2_acquire_dquot+0x258/0xa10 fs/ocfs2/quota_global.c:828
       dqget+0x654/0xccc fs/quota/dquot.c:980
       __dquot_initialize+0x2d4/0xa80 fs/quota/dquot.c:1508
       dquot_initialize+0x24/0x34 fs/quota/dquot.c:1570
       ocfs2_get_init_inode+0x134/0x1a8 fs/ocfs2/namei.c:205
       ocfs2_mknod+0x734/0x1cf0 fs/ocfs2/namei.c:313
       ocfs2_create+0x190/0x474 fs/ocfs2/namei.c:676
       lookup_open fs/namei.c:3796 [inline]
       open_last_lookups fs/namei.c:3895 [inline]
       path_openat+0x12d8/0x2c40 fs/namei.c:4131
       do_filp_open+0x18c/0x36c fs/namei.c:4161
       do_sys_openat2+0x11c/0x1b4 fs/open.c:1437
       do_sys_open fs/open.c:1452 [inline]
       __do_sys_openat fs/open.c:1468 [inline]
       __se_sys_openat fs/open.c:1463 [inline]
       __arm64_sys_openat+0x120/0x158 fs/open.c:1463
       __invoke_syscall arch/arm64/kernel/syscall.c:35 [inline]
       invoke_syscall+0x98/0x254 arch/arm64/kernel/syscall.c:49
       el0_svc_common+0x130/0x23c arch/arm64/kernel/syscall.c:132
       do_el0_svc+0x48/0x58 arch/arm64/kernel/syscall.c:151
       el0_svc+0x5c/0x254 arch/arm64/kernel/entry-common.c:746
       el0t_64_sync_handler+0x84/0x12c arch/arm64/kernel/entry-common.c:765
       el0t_64_sync+0x198/0x19c arch/arm64/kernel/entry.S:596

-> #4 (&dquot->dq_lock){+.+.}-{4:4}:
       __mutex_lock_common+0x1d0/0x2678 kernel/locking/mutex.c:598
       __mutex_lock kernel/locking/mutex.c:760 [inline]
       mutex_lock_nested+0x2c/0x38 kernel/locking/mutex.c:812
       wait_on_dquot fs/quota/dquot.c:357 [inline]
       dqget+0x5e4/0xccc fs/quota/dquot.c:975
       __dquot_initialize+0x2d4/0xa80 fs/quota/dquot.c:1508
       dquot_initialize+0x24/0x34 fs/quota/dquot.c:1570
       __ext4_new_inode+0x618/0x3190 fs/ext4/ialloc.c:994
       ext4_xattr_inode_create fs/ext4/xattr.c:1483 [inline]
       ext4_xattr_inode_lookup_create+0x830/0x176c fs/ext4/xattr.c:1593
       ext4_xattr_block_set+0x1bc/0x24bc fs/ext4/xattr.c:1913
       ext4_xattr_set_handle+0xde8/0x1260 fs/ext4/xattr.c:2452
       ext4_xattr_set+0x1e4/0x2b8 fs/ext4/xattr.c:2554
       ext4_xattr_trusted_set+0x4c/0x64 fs/ext4/xattr_trusted.c:38
       __vfs_setxattr+0x3d8/0x400 fs/xattr.c:200
       __vfs_setxattr_noperm+0x120/0x5c4 fs/xattr.c:234
       __vfs_setxattr_locked+0x1ec/0x218 fs/xattr.c:295
       vfs_setxattr+0x158/0x2ac fs/xattr.c:321
       do_setxattr fs/xattr.c:636 [inline]
       filename_setxattr+0x20c/0x4f8 fs/xattr.c:665
       path_setxattrat+0x2e8/0x320 fs/xattr.c:713
       __do_sys_setxattr fs/xattr.c:747 [inline]
       __se_sys_setxattr fs/xattr.c:743 [inline]
       __arm64_sys_setxattr+0xc0/0xdc fs/xattr.c:743
       __invoke_syscall arch/arm64/kernel/syscall.c:35 [inline]
       invoke_syscall+0x98/0x254 arch/arm64/kernel/syscall.c:49
       el0_svc_common+0x130/0x23c arch/arm64/kernel/syscall.c:132
       do_el0_svc+0x48/0x58 arch/arm64/kernel/syscall.c:151
       el0_svc+0x5c/0x254 arch/arm64/kernel/entry-common.c:746
       el0t_64_sync_handler+0x84/0x12c arch/arm64/kernel/entry-common.c:765
       el0t_64_sync+0x198/0x19c arch/arm64/kernel/entry.S:596

-> #3 (&ei->xattr_sem){++++}-{4:4}:
       down_write+0x50/0xc0 kernel/locking/rwsem.c:1590
       ext4_write_lock_xattr fs/ext4/xattr.h:157 [inline]
       ext4_xattr_set_handle+0x11c/0x1260 fs/ext4/xattr.c:2367
       ext4_initxattrs+0xa4/0x11c fs/ext4/xattr_security.c:44
       security_inode_init_security+0x6dc/0x7f4 security/security.c:1891
       ext4_init_security+0x44/0x58 fs/ext4/xattr_security.c:58
       __ext4_new_inode+0x27f4/0x3190 fs/ext4/ialloc.c:1325
       ext4_create+0x1f8/0x3fc fs/ext4/namei.c:2822
       lookup_open fs/namei.c:3796 [inline]
       open_last_lookups fs/namei.c:3895 [inline]
       path_openat+0x12d8/0x2c40 fs/namei.c:4131
       do_filp_open+0x18c/0x36c fs/namei.c:4161
       do_sys_openat2+0x11c/0x1b4 fs/open.c:1437
       do_sys_open fs/open.c:1452 [inline]
       __do_sys_openat fs/open.c:1468 [inline]
       __se_sys_openat fs/open.c:1463 [inline]
       __arm64_sys_openat+0x120/0x158 fs/open.c:1463
       __invoke_syscall arch/arm64/kernel/syscall.c:35 [inline]
       invoke_syscall+0x98/0x254 arch/arm64/kernel/syscall.c:49
       el0_svc_common+0x130/0x23c arch/arm64/kernel/syscall.c:132
       do_el0_svc+0x48/0x58 arch/arm64/kernel/syscall.c:151
       el0_svc+0x5c/0x254 arch/arm64/kernel/entry-common.c:746
       el0t_64_sync_handler+0x84/0x12c arch/arm64/kernel/entry-common.c:765
       el0t_64_sync+0x198/0x19c arch/arm64/kernel/entry.S:596

-> #2 (jbd2_handle){++++}-{0:0}:
       start_this_handle+0xe74/0x10dc fs/jbd2/transaction.c:444
       jbd2__journal_start+0x288/0x51c fs/jbd2/transaction.c:501
       jbd2_journal_start+0x3c/0x4c fs/jbd2/transaction.c:540
       ocfs2_start_trans+0x368/0x6b0 fs/ocfs2/journal.c:374
       ocfs2_modify_bh+0xe4/0x43c fs/ocfs2/quota_local.c:101
       ocfs2_local_read_info+0x104c/0x1364 fs/ocfs2/quota_local.c:767
       dquot_load_quota_sb+0x6bc/0xa90 fs/quota/dquot.c:2462
       dquot_load_quota_inode+0x274/0x4e4 fs/quota/dquot.c:2499
       ocfs2_enable_quotas+0x17c/0x3b4 fs/ocfs2/super.c:930
       ocfs2_fill_super+0x4004/0x532c fs/ocfs2/super.c:1140
       get_tree_bdev_flags+0x360/0x414 fs/super.c:1691
       get_tree_bdev+0x2c/0x3c fs/super.c:1714
       ocfs2_get_tree+0x28/0x38 fs/ocfs2/super.c:1184
       vfs_get_tree+0x90/0x28c fs/super.c:1751
       fc_mount fs/namespace.c:1208 [inline]
       do_new_mount_fc fs/namespace.c:3651 [inline]
       do_new_mount+0x284/0x944 fs/namespace.c:3727
       path_mount+0x5b4/0xdfc fs/namespace.c:4037
       do_mount fs/namespace.c:4050 [inline]
       __do_sys_mount fs/namespace.c:4238 [inline]
       __se_sys_mount fs/namespace.c:4215 [inline]
       __arm64_sys_mount+0x3e8/0x468 fs/namespace.c:4215
       __invoke_syscall arch/arm64/kernel/syscall.c:35 [inline]
       invoke_syscall+0x98/0x254 arch/arm64/kernel/syscall.c:49
       el0_svc_common+0x130/0x23c arch/arm64/kernel/syscall.c:132
       do_el0_svc+0x48/0x58 arch/arm64/kernel/syscall.c:151
       el0_svc+0x5c/0x254 arch/arm64/kernel/entry-common.c:746
       el0t_64_sync_handler+0x84/0x12c arch/arm64/kernel/entry-common.c:765
       el0t_64_sync+0x198/0x19c arch/arm64/kernel/entry.S:596

-> #1 (&journal->j_trans_barrier){.+.+}-{4:4}:
       down_read+0x58/0x2f8 kernel/locking/rwsem.c:1537
       ocfs2_start_trans+0x35c/0x6b0 fs/ocfs2/journal.c:372
       ocfs2_modify_bh+0xe4/0x43c fs/ocfs2/quota_local.c:101
       ocfs2_local_read_info+0x104c/0x1364 fs/ocfs2/quota_local.c:767
       dquot_load_quota_sb+0x6bc/0xa90 fs/quota/dquot.c:2462
       dquot_load_quota_inode+0x274/0x4e4 fs/quota/dquot.c:2499
       ocfs2_enable_quotas+0x17c/0x3b4 fs/ocfs2/super.c:930
       ocfs2_fill_super+0x4004/0x532c fs/ocfs2/super.c:1140
       get_tree_bdev_flags+0x360/0x414 fs/super.c:1691
       get_tree_bdev+0x2c/0x3c fs/super.c:1714
       ocfs2_get_tree+0x28/0x38 fs/ocfs2/super.c:1184
       vfs_get_tree+0x90/0x28c fs/super.c:1751
       fc_mount fs/namespace.c:1208 [inline]
       do_new_mount_fc fs/namespace.c:3651 [inline]
       do_new_mount+0x284/0x944 fs/namespace.c:3727
       path_mount+0x5b4/0xdfc fs/namespace.c:4037
       do_mount fs/namespace.c:4050 [inline]
       __do_sys_mount fs/namespace.c:4238 [inline]
       __se_sys_mount fs/namespace.c:4215 [inline]
       __arm64_sys_mount+0x3e8/0x468 fs/namespace.c:4215
       __invoke_syscall arch/arm64/kernel/syscall.c:35 [inline]
       invoke_syscall+0x98/0x254 arch/arm64/kernel/syscall.c:49
       el0_svc_common+0x130/0x23c arch/arm64/kernel/syscall.c:132
       do_el0_svc+0x48/0x58 arch/arm64/kernel/syscall.c:151
       el0_svc+0x5c/0x254 arch/arm64/kernel/entry-common.c:746
       el0t_64_sync_handler+0x84/0x12c arch/arm64/kernel/entry-common.c:765
       el0t_64_sync+0x198/0x19c arch/arm64/kernel/entry.S:596

-> #0 (sb_internal#2){.+.+}-{0:0}:
       check_prev_add kernel/locking/lockdep.c:3165 [inline]
       check_prevs_add kernel/locking/lockdep.c:3284 [inline]
       validate_chain kernel/locking/lockdep.c:3908 [inline]
       __lock_acquire+0x1774/0x30a4 kernel/locking/lockdep.c:5237
       lock_acquire+0x14c/0x2e0 kernel/locking/lockdep.c:5868
       percpu_down_read_internal include/linux/percpu-rwsem.h:53 [inline]
       percpu_down_read_freezable include/linux/percpu-rwsem.h:83 [inline]
       __sb_start_write include/linux/fs.h:1916 [inline]
       sb_start_intwrite include/linux/fs.h:2099 [inline]
       ocfs2_start_trans+0x1f4/0x6b0 fs/ocfs2/journal.c:370
       ocfs2_write_info+0x114/0x324 fs/ocfs2/quota_global.c:997
       dquot_set_dqinfo+0x370/0x5d4 fs/quota/dquot.c:2900
       quota_setinfo+0x2c4/0x2cc fs/quota/quota.c:174
       do_quotactl+0x59c/0x738 fs/quota/quota.c:796
       __do_sys_quotactl fs/quota/quota.c:961 [inline]
       __se_sys_quotactl fs/quota/quota.c:917 [inline]
       __arm64_sys_quotactl+0x298/0xb34 fs/quota/quota.c:917
       __invoke_syscall arch/arm64/kernel/syscall.c:35 [inline]
       invoke_syscall+0x98/0x254 arch/arm64/kernel/syscall.c:49
       el0_svc_common+0x130/0x23c arch/arm64/kernel/syscall.c:132
       do_el0_svc+0x48/0x58 arch/arm64/kernel/syscall.c:151
       el0_svc+0x5c/0x254 arch/arm64/kernel/entry-common.c:746
       el0t_64_sync_handler+0x84/0x12c arch/arm64/kernel/entry-common.c:765
       el0t_64_sync+0x198/0x19c arch/arm64/kernel/entry.S:596

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

3 locks held by syz.0.52/6850:
 #0: ffff0000c8ae40e0 (&type->s_umount_key#54){.+.+}-{4:4}, at: __super_lock fs/super.c:59 [inline]
 #0: ffff0000c8ae40e0 (&type->s_umount_key#54){.+.+}-{4:4}, at: super_lock+0x240/0x32c fs/super.c:121
 #1: ffff0000ddce5f40 (&ocfs2_sysfile_lock_key[USER_QUOTA_SYSTEM_INODE]){+.+.}-{4:4}, at: inode_lock include/linux/fs.h:980 [inline]
 #1: ffff0000ddce5f40 (&ocfs2_sysfile_lock_key[USER_QUOTA_SYSTEM_INODE]){+.+.}-{4:4}, at: ocfs2_lock_global_qf+0x18c/0x22c fs/ocfs2/quota_global.c:313
 #2: ffff0000ddce5be0 (&ocfs2_quota_ip_alloc_sem_key){++++}-{4:4}, at: ocfs2_lock_global_qf+0x1a8/0x22c fs/ocfs2/quota_global.c:314

stack backtrace:
CPU: 1 UID: 0 PID: 6850 Comm: syz.0.52 Not tainted syzkaller #0 PREEMPT 
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 10/03/2025
Call trace:
 show_stack+0x2c/0x3c arch/arm64/kernel/stacktrace.c:499 (C)
 __dump_stack+0x30/0x40 lib/dump_stack.c:94
 dump_stack_lvl+0xd8/0x12c lib/dump_stack.c:120
 dump_stack+0x1c/0x28 lib/dump_stack.c:129
 print_circular_bug+0x324/0x32c kernel/locking/lockdep.c:2043
 check_noncircular+0x154/0x174 kernel/locking/lockdep.c:2175
 check_prev_add kernel/locking/lockdep.c:3165 [inline]
 check_prevs_add kernel/locking/lockdep.c:3284 [inline]
 validate_chain kernel/locking/lockdep.c:3908 [inline]
 __lock_acquire+0x1774/0x30a4 kernel/locking/lockdep.c:5237
 lock_acquire+0x14c/0x2e0 kernel/locking/lockdep.c:5868
 percpu_down_read_internal include/linux/percpu-rwsem.h:53 [inline]
 percpu_down_read_freezable include/linux/percpu-rwsem.h:83 [inline]
 __sb_start_write include/linux/fs.h:1916 [inline]
 sb_start_intwrite include/linux/fs.h:2099 [inline]
 ocfs2_start_trans+0x1f4/0x6b0 fs/ocfs2/journal.c:370
 ocfs2_write_info+0x114/0x324 fs/ocfs2/quota_global.c:997
 dquot_set_dqinfo+0x370/0x5d4 fs/quota/dquot.c:2900
 quota_setinfo+0x2c4/0x2cc fs/quota/quota.c:174
 do_quotactl+0x59c/0x738 fs/quota/quota.c:796
 __do_sys_quotactl fs/quota/quota.c:961 [inline]
 __se_sys_quotactl fs/quota/quota.c:917 [inline]
 __arm64_sys_quotactl+0x298/0xb34 fs/quota/quota.c:917
 __invoke_syscall arch/arm64/kernel/syscall.c:35 [inline]
 invoke_syscall+0x98/0x254 arch/arm64/kernel/syscall.c:49
 el0_svc_common+0x130/0x23c arch/arm64/kernel/syscall.c:132
 do_el0_svc+0x48/0x58 arch/arm64/kernel/syscall.c:151
 el0_svc+0x5c/0x254 arch/arm64/kernel/entry-common.c:746
 el0t_64_sync_handler+0x84/0x12c arch/arm64/kernel/entry-common.c:765
 el0t_64_sync+0x198/0x19c arch/arm64/kernel/entry.S:596


---
If you want syzbot to run the reproducer, reply with:
#syz test: git://repo/address.git branch-or-commit-hash
If you attach or paste a git patch, syzbot will apply it before testing.
