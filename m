Received: from mail-il1-f208.google.com (mail-il1-f208.google.com [209.85.166.208])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D277026E6F3
	for <ocfs2-devel@lists.linux.dev>; Tue, 19 Aug 2025 07:31:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.208
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755588690; cv=none; b=IhZMZZIYuNUv1Vvc2AuscCl2XpP8E2pSMQ6KKdo4eh1zd3/89R3ivyGGTC2rnPsu4fi+7wyUgE6EkAJl4BMFuEXX5/q/P8M/yZtvvNwGc7ZblgOseiT5odeBGaGbYqpeCOQNJUk1J40gUnkGsFxStYT/djLjsXb5lJYe4XkeGe8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755588690; c=relaxed/simple;
	bh=B70aBMUtleNecaYVXkg05y/gH5K+DSKf0G4e8zh0iaM=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:
	 Content-Type; b=amg6KjanZ98PkM0j1psQ6momn/qNi/ZdOwsUSaF1CFklPedGE8cG6J5ADffVICtrenxvJBbbHFZxB3IQHIvqsvMoLGvH6XtmbXfz4oZwxjIx+YSWwI42v+c6kvH5ayO+peQ+sSnx2tBE/3D1WgCaLlvULZahjqPbsNUVYXblLkA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.208
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f208.google.com with SMTP id e9e14a558f8ab-3e570044f0eso149382135ab.2
        for <ocfs2-devel@lists.linux.dev>; Tue, 19 Aug 2025 00:31:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755588688; x=1756193488;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ifEgrnMlkqdeaeEbssFQNl8g8qwuviTV5kz15d+HguQ=;
        b=Ljp+gPU/zZcpQQQlkg8OFYBPuY4vjz446vKebUtJPF67uMA6qLwyDTuKZSu8a3ls8g
         7PbAbCEQeYPyC6DiYAIKX6l8l75p216+Jtle6OeY4RZt4MXsw5ZEtX7JIFTIbZPy8AjK
         zGXm5q1+8kanTzkZExxWjSBRFvpnASgPg9qZKFS2960erec1VxDn5ccf6sN/dZxmgL0K
         RUuv+xgGc3/Lf7L4hyvenFDs17qMVp+MgJtfghi/Y3MG3nq/xaGnr0czbidkZM392eyg
         Coj/4PCWXqR1dKIOp1gsvtcK7H81JdIPOz/1IDhOSKCdTSZ6xTq7fJHBNJOt2f4JG48Y
         fi6w==
X-Forwarded-Encrypted: i=1; AJvYcCXLk1IigwEuGjESy1Hj/MTlQmNKEE2EXx4LyY6p70+o42UjjWLARKDWpmEKP82uEi0bGv29Cgkgkdvefw==@lists.linux.dev
X-Gm-Message-State: AOJu0YwTdpPPiQdLZpI95zPkWqyrk8ZDYGtOZdiU0j3eRI376GSlDmL/
	nvcQ/wOWTS3SxVfoY15yaIiEttPky7RTNwBfl47wIuVsxPydD7PXbCzfcpDVhr3daBxn1ULLlqs
	3lOiIYr2TW+w7y6U14qoc4D/icDhuj9XUdTF6FANVjdxlLJnK+JECV30d/Bo=
X-Google-Smtp-Source: AGHT+IGCQsNzROSL+3amVSR5XuUvi1SYguUakVyZz4bF2HV94HJ5mmXtFjPLaTkSfEzpbsLHGi7AAu9gdfyAQBugLQh5+nKSFHFR
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:2192:b0:3e6:6487:9a9f with SMTP id
 e9e14a558f8ab-3e6765cddf6mr28458025ab.5.1755588687829; Tue, 19 Aug 2025
 00:31:27 -0700 (PDT)
Date: Tue, 19 Aug 2025 00:31:27 -0700
In-Reply-To: <687cfe02.a70a0220.693ce.00c7.GAE@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <68a4284f.050a0220.e29e5.00c0.GAE@google.com>
Subject: Re: [syzbot] [ocfs2?] possible deadlock in ocfs2_extend_allocation
From: syzbot <syzbot+2c472ed017e03a3e8bda@syzkaller.appspotmail.com>
To: jlbec@evilplan.org, joseph.qi@linux.alibaba.com, 
	linux-kernel@vger.kernel.org, mark@fasheh.com, ocfs2-devel@lists.linux.dev, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

syzbot has found a reproducer for the following issue on:

HEAD commit:    8f5ae30d69d7 Linux 6.17-rc1
git tree:       git://git.kernel.org/pub/scm/linux/kernel/git/arm64/linux.git for-kernelci
console output: https://syzkaller.appspot.com/x/log.txt?x=1437c6f0580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=8c5ac3d8b8abfcb
dashboard link: https://syzkaller.appspot.com/bug?extid=2c472ed017e03a3e8bda
compiler:       Debian clang version 20.1.7 (++20250616065708+6146a88f6049-1~exp1~20250616065826.132), Debian LLD 20.1.7
userspace arch: arm64
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1237c6f0580000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=104b5ba2580000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/18a2e4bd0c4a/disk-8f5ae30d.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/3b5395881b25/vmlinux-8f5ae30d.xz
kernel image: https://storage.googleapis.com/syzbot-assets/e875f4e3b7ff/Image-8f5ae30d.gz.xz
mounted in repro #1: https://storage.googleapis.com/syzbot-assets/97c3dc76fbdd/mount_0.gz
  fsck result: OK (log: https://syzkaller.appspot.com/x/fsck.log?x=178b5ba2580000)
mounted in repro #2: https://storage.googleapis.com/syzbot-assets/0eab8e48ed5e/mount_1.gz
  fsck result: OK (log: https://syzkaller.appspot.com/x/fsck.log?x=1037c6f0580000)

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+2c472ed017e03a3e8bda@syzkaller.appspotmail.com

(syz.3.28,6801,1):ocfs2_block_check_validate:402 ERROR: CRC32 failed: stored: 0xb3775c19, computed 0x2dd1c265. Applying ECC.
JBD2: Ignoring recovery information on journal
ocfs2: Mounting device (7,3) on (node local, slot 0) with ordered data mode.
(syz.3.28,6801,1):ocfs2_block_check_validate:402 ERROR: CRC32 failed: stored: 0x98842a5e, computed 0xe74db1cd. Applying ECC.
======================================================
WARNING: possible circular locking dependency detected
6.17.0-rc1-syzkaller-g8f5ae30d69d7 #0 Not tainted
------------------------------------------------------
syz.3.28/6801 is trying to acquire lock:
ffff0000cc700618 (sb_internal#2){.+.+}-{0:0}, at: ocfs2_extend_allocation+0x5d4/0x14cc fs/ocfs2/file.c:597

but task is already holding lock:
ffff0000f6f05100 (&ocfs2_sysfile_lock_key[GLOBAL_BITMAP_SYSTEM_INODE]){+.+.}-{4:4}, at: inode_lock include/linux/fs.h:869 [inline]
ffff0000f6f05100 (&ocfs2_sysfile_lock_key[GLOBAL_BITMAP_SYSTEM_INODE]){+.+.}-{4:4}, at: ocfs2_reserve_suballoc_bits+0x12c/0x3b9c fs/ocfs2/suballoc.c:788

which lock already depends on the new lock.


the existing dependency chain (in reverse order) is:

-> #7 (&ocfs2_sysfile_lock_key[GLOBAL_BITMAP_SYSTEM_INODE]){+.+.}-{4:4}:
       down_write+0x50/0xc0 kernel/locking/rwsem.c:1590
       inode_lock include/linux/fs.h:869 [inline]
       ocfs2_reserve_suballoc_bits+0x12c/0x3b9c fs/ocfs2/suballoc.c:788
       ocfs2_reserve_cluster_bitmap_bits fs/ocfs2/suballoc.c:1134 [inline]
       ocfs2_reserve_clusters_with_limit+0x290/0x9e0 fs/ocfs2/suballoc.c:1179
       ocfs2_reserve_clusters fs/ocfs2/suballoc.c:1229 [inline]
       ocfs2_lock_allocators+0x27c/0x518 fs/ocfs2/suballoc.c:2772
       ocfs2_extend_allocation+0x328/0x14cc fs/ocfs2/file.c:589
       ocfs2_extend_no_holes+0x1a8/0x424 fs/ocfs2/file.c:1027
       ocfs2_acquire_dquot+0x530/0xa10 fs/ocfs2/quota_global.c:853
       dqget+0x654/0xccc fs/quota/dquot.c:977
       ocfs2_setattr+0xb30/0x17a0 fs/ocfs2/file.c:1233
       notify_change+0x9a4/0xc50 fs/attr.c:552
       chown_common+0x374/0x4dc fs/open.c:791
       vfs_fchown fs/open.c:859 [inline]
       ksys_fchown+0xe0/0x158 fs/open.c:871
       __do_sys_fchown fs/open.c:876 [inline]
       __se_sys_fchown fs/open.c:874 [inline]
       __arm64_sys_fchown+0x7c/0x94 fs/open.c:874
       __invoke_syscall arch/arm64/kernel/syscall.c:35 [inline]
       invoke_syscall+0x98/0x2b8 arch/arm64/kernel/syscall.c:49
       el0_svc_common+0x130/0x23c arch/arm64/kernel/syscall.c:132
       do_el0_svc+0x48/0x58 arch/arm64/kernel/syscall.c:151
       el0_svc+0x58/0x180 arch/arm64/kernel/entry-common.c:879
       el0t_64_sync_handler+0x84/0x12c arch/arm64/kernel/entry-common.c:898
       el0t_64_sync+0x198/0x19c arch/arm64/kernel/entry.S:596

-> #6 (&ocfs2_quota_ip_alloc_sem_key){++++}-{4:4}:
       down_write+0x50/0xc0 kernel/locking/rwsem.c:1590
       ocfs2_lock_global_qf+0x1a8/0x22c fs/ocfs2/quota_global.c:314
       ocfs2_acquire_dquot+0x258/0xa10 fs/ocfs2/quota_global.c:828
       dqget+0x654/0xccc fs/quota/dquot.c:977
       ocfs2_setattr+0xb30/0x17a0 fs/ocfs2/file.c:1233
       notify_change+0x9a4/0xc50 fs/attr.c:552
       chown_common+0x374/0x4dc fs/open.c:791
       vfs_fchown fs/open.c:859 [inline]
       ksys_fchown+0xe0/0x158 fs/open.c:871
       __do_sys_fchown fs/open.c:876 [inline]
       __se_sys_fchown fs/open.c:874 [inline]
       __arm64_sys_fchown+0x7c/0x94 fs/open.c:874
       __invoke_syscall arch/arm64/kernel/syscall.c:35 [inline]
       invoke_syscall+0x98/0x2b8 arch/arm64/kernel/syscall.c:49
       el0_svc_common+0x130/0x23c arch/arm64/kernel/syscall.c:132
       do_el0_svc+0x48/0x58 arch/arm64/kernel/syscall.c:151
       el0_svc+0x58/0x180 arch/arm64/kernel/entry-common.c:879
       el0t_64_sync_handler+0x84/0x12c arch/arm64/kernel/entry-common.c:898
       el0t_64_sync+0x198/0x19c arch/arm64/kernel/entry.S:596

-> #5 (&ocfs2_sysfile_lock_key[USER_QUOTA_SYSTEM_INODE]){+.+.}-{4:4}:
       down_write+0x50/0xc0 kernel/locking/rwsem.c:1590
       inode_lock include/linux/fs.h:869 [inline]
       ocfs2_lock_global_qf+0x18c/0x22c fs/ocfs2/quota_global.c:313
       ocfs2_acquire_dquot+0x258/0xa10 fs/ocfs2/quota_global.c:828
       dqget+0x654/0xccc fs/quota/dquot.c:977
       ocfs2_setattr+0xb30/0x17a0 fs/ocfs2/file.c:1233
       notify_change+0x9a4/0xc50 fs/attr.c:552
       chown_common+0x374/0x4dc fs/open.c:791
       vfs_fchown fs/open.c:859 [inline]
       ksys_fchown+0xe0/0x158 fs/open.c:871
       __do_sys_fchown fs/open.c:876 [inline]
       __se_sys_fchown fs/open.c:874 [inline]
       __arm64_sys_fchown+0x7c/0x94 fs/open.c:874
       __invoke_syscall arch/arm64/kernel/syscall.c:35 [inline]
       invoke_syscall+0x98/0x2b8 arch/arm64/kernel/syscall.c:49
       el0_svc_common+0x130/0x23c arch/arm64/kernel/syscall.c:132
       do_el0_svc+0x48/0x58 arch/arm64/kernel/syscall.c:151
       el0_svc+0x58/0x180 arch/arm64/kernel/entry-common.c:879
       el0t_64_sync_handler+0x84/0x12c arch/arm64/kernel/entry-common.c:898
       el0t_64_sync+0x198/0x19c arch/arm64/kernel/entry.S:596

-> #4 (&dquot->dq_lock){+.+.}-{4:4}:
       __mutex_lock_common+0x1d0/0x24ac kernel/locking/mutex.c:598
       __mutex_lock kernel/locking/mutex.c:760 [inline]
       mutex_lock_nested+0x2c/0x38 kernel/locking/mutex.c:812
       wait_on_dquot fs/quota/dquot.c:354 [inline]
       dqget+0x5e4/0xccc fs/quota/dquot.c:972
       dquot_transfer+0x238/0x560 fs/quota/dquot.c:2140
       ext4_setattr+0x738/0x1810 fs/ext4/inode.c:5902
       notify_change+0x9a4/0xc50 fs/attr.c:552
       chown_common+0x374/0x4dc fs/open.c:791
       vfs_fchown fs/open.c:859 [inline]
       ksys_fchown+0xe0/0x158 fs/open.c:871
       __do_sys_fchown fs/open.c:876 [inline]
       __se_sys_fchown fs/open.c:874 [inline]
       __arm64_sys_fchown+0x7c/0x94 fs/open.c:874
       __invoke_syscall arch/arm64/kernel/syscall.c:35 [inline]
       invoke_syscall+0x98/0x2b8 arch/arm64/kernel/syscall.c:49
       el0_svc_common+0x130/0x23c arch/arm64/kernel/syscall.c:132
       do_el0_svc+0x48/0x58 arch/arm64/kernel/syscall.c:151
       el0_svc+0x58/0x180 arch/arm64/kernel/entry-common.c:879
       el0t_64_sync_handler+0x84/0x12c arch/arm64/kernel/entry-common.c:898
       el0t_64_sync+0x198/0x19c arch/arm64/kernel/entry.S:596

-> #3 (&ei->xattr_sem){++++}-{4:4}:
       down_write+0x50/0xc0 kernel/locking/rwsem.c:1590
       ext4_write_lock_xattr fs/ext4/xattr.h:157 [inline]
       ext4_xattr_set_handle+0x11c/0x1260 fs/ext4/xattr.c:2362
       ext4_initxattrs+0xa4/0x11c fs/ext4/xattr_security.c:44
       security_inode_init_security+0x6dc/0x7f4 security/security.c:1852
       ext4_init_security+0x44/0x58 fs/ext4/xattr_security.c:58
       __ext4_new_inode+0x27f4/0x3190 fs/ext4/ialloc.c:1325
       ext4_create+0x1f8/0x3fc fs/ext4/namei.c:2822
       lookup_open fs/namei.c:3708 [inline]
       open_last_lookups fs/namei.c:3807 [inline]
       path_openat+0x12d8/0x2c40 fs/namei.c:4043
       do_filp_open+0x18c/0x36c fs/namei.c:4073
       do_sys_openat2+0x11c/0x1b4 fs/open.c:1435
       do_sys_open fs/open.c:1450 [inline]
       __do_sys_openat fs/open.c:1466 [inline]
       __se_sys_openat fs/open.c:1461 [inline]
       __arm64_sys_openat+0x120/0x158 fs/open.c:1461
       __invoke_syscall arch/arm64/kernel/syscall.c:35 [inline]
       invoke_syscall+0x98/0x2b8 arch/arm64/kernel/syscall.c:49
       el0_svc_common+0x130/0x23c arch/arm64/kernel/syscall.c:132
       do_el0_svc+0x48/0x58 arch/arm64/kernel/syscall.c:151
       el0_svc+0x58/0x180 arch/arm64/kernel/entry-common.c:879
       el0t_64_sync_handler+0x84/0x12c arch/arm64/kernel/entry-common.c:898
       el0t_64_sync+0x198/0x19c arch/arm64/kernel/entry.S:596

-> #2 (jbd2_handle){++++}-{0:0}:
       start_this_handle+0xe74/0x10dc fs/jbd2/transaction.c:444
       jbd2__journal_start+0x288/0x51c fs/jbd2/transaction.c:501
       jbd2_journal_start+0x3c/0x4c fs/jbd2/transaction.c:540
       ocfs2_start_trans+0x368/0x6b0 fs/ocfs2/journal.c:374
       ocfs2_modify_bh+0xe4/0x43c fs/ocfs2/quota_local.c:101
       ocfs2_local_read_info+0x104c/0x1364 fs/ocfs2/quota_local.c:767
       dquot_load_quota_sb+0x6bc/0xa90 fs/quota/dquot.c:2459
       dquot_load_quota_inode+0x274/0x4e4 fs/quota/dquot.c:2496
       ocfs2_enable_quotas+0x17c/0x3b4 fs/ocfs2/super.c:930
       ocfs2_fill_super+0x4004/0x532c fs/ocfs2/super.c:1140
       get_tree_bdev_flags+0x360/0x414 fs/super.c:1692
       get_tree_bdev+0x2c/0x3c fs/super.c:1715
       ocfs2_get_tree+0x28/0x38 fs/ocfs2/super.c:1184
       vfs_get_tree+0x90/0x28c fs/super.c:1815
       do_new_mount+0x278/0x7f4 fs/namespace.c:3805
       path_mount+0x5b4/0xde0 fs/namespace.c:4120
       do_mount fs/namespace.c:4133 [inline]
       __do_sys_mount fs/namespace.c:4344 [inline]
       __se_sys_mount fs/namespace.c:4321 [inline]
       __arm64_sys_mount+0x3e8/0x468 fs/namespace.c:4321
       __invoke_syscall arch/arm64/kernel/syscall.c:35 [inline]
       invoke_syscall+0x98/0x2b8 arch/arm64/kernel/syscall.c:49
       el0_svc_common+0x130/0x23c arch/arm64/kernel/syscall.c:132
       do_el0_svc+0x48/0x58 arch/arm64/kernel/syscall.c:151
       el0_svc+0x58/0x180 arch/arm64/kernel/entry-common.c:879
       el0t_64_sync_handler+0x84/0x12c arch/arm64/kernel/entry-common.c:898
       el0t_64_sync+0x198/0x19c arch/arm64/kernel/entry.S:596

-> #1 (&journal->j_trans_barrier){.+.+}-{4:4}:
       down_read+0x58/0x2f8 kernel/locking/rwsem.c:1537
       ocfs2_start_trans+0x35c/0x6b0 fs/ocfs2/journal.c:372
       ocfs2_modify_bh+0xe4/0x43c fs/ocfs2/quota_local.c:101
       ocfs2_local_read_info+0x104c/0x1364 fs/ocfs2/quota_local.c:767
       dquot_load_quota_sb+0x6bc/0xa90 fs/quota/dquot.c:2459
       dquot_load_quota_inode+0x274/0x4e4 fs/quota/dquot.c:2496
       ocfs2_enable_quotas+0x17c/0x3b4 fs/ocfs2/super.c:930
       ocfs2_fill_super+0x4004/0x532c fs/ocfs2/super.c:1140
       get_tree_bdev_flags+0x360/0x414 fs/super.c:1692
       get_tree_bdev+0x2c/0x3c fs/super.c:1715
       ocfs2_get_tree+0x28/0x38 fs/ocfs2/super.c:1184
       vfs_get_tree+0x90/0x28c fs/super.c:1815
       do_new_mount+0x278/0x7f4 fs/namespace.c:3805
       path_mount+0x5b4/0xde0 fs/namespace.c:4120
       do_mount fs/namespace.c:4133 [inline]
       __do_sys_mount fs/namespace.c:4344 [inline]
       __se_sys_mount fs/namespace.c:4321 [inline]
       __arm64_sys_mount+0x3e8/0x468 fs/namespace.c:4321
       __invoke_syscall arch/arm64/kernel/syscall.c:35 [inline]
       invoke_syscall+0x98/0x2b8 arch/arm64/kernel/syscall.c:49
       el0_svc_common+0x130/0x23c arch/arm64/kernel/syscall.c:132
       do_el0_svc+0x48/0x58 arch/arm64/kernel/syscall.c:151
       el0_svc+0x58/0x180 arch/arm64/kernel/entry-common.c:879
       el0t_64_sync_handler+0x84/0x12c arch/arm64/kernel/entry-common.c:898
       el0t_64_sync+0x198/0x19c arch/arm64/kernel/entry.S:596

-> #0 (sb_internal#2){.+.+}-{0:0}:
       check_prev_add kernel/locking/lockdep.c:3165 [inline]
       check_prevs_add kernel/locking/lockdep.c:3284 [inline]
       validate_chain kernel/locking/lockdep.c:3908 [inline]
       __lock_acquire+0x1774/0x30a4 kernel/locking/lockdep.c:5237
       lock_acquire+0x14c/0x2e0 kernel/locking/lockdep.c:5868
       percpu_down_read_internal include/linux/percpu-rwsem.h:53 [inline]
       percpu_down_read_freezable include/linux/percpu-rwsem.h:83 [inline]
       __sb_start_write include/linux/fs.h:1798 [inline]
       sb_start_intwrite include/linux/fs.h:1981 [inline]
       ocfs2_start_trans+0x1f4/0x6b0 fs/ocfs2/journal.c:370
       ocfs2_extend_allocation+0x5d4/0x14cc fs/ocfs2/file.c:597
       ocfs2_extend_no_holes+0x1a8/0x424 fs/ocfs2/file.c:1027
       ocfs2_acquire_dquot+0x530/0xa10 fs/ocfs2/quota_global.c:853
       dqget+0x654/0xccc fs/quota/dquot.c:977
       ocfs2_setattr+0xb30/0x17a0 fs/ocfs2/file.c:1233
       notify_change+0x9a4/0xc50 fs/attr.c:552
       chown_common+0x374/0x4dc fs/open.c:791
       vfs_fchown fs/open.c:859 [inline]
       ksys_fchown+0xe0/0x158 fs/open.c:871
       __do_sys_fchown fs/open.c:876 [inline]
       __se_sys_fchown fs/open.c:874 [inline]
       __arm64_sys_fchown+0x7c/0x94 fs/open.c:874
       __invoke_syscall arch/arm64/kernel/syscall.c:35 [inline]
       invoke_syscall+0x98/0x2b8 arch/arm64/kernel/syscall.c:49
       el0_svc_common+0x130/0x23c arch/arm64/kernel/syscall.c:132
       do_el0_svc+0x48/0x58 arch/arm64/kernel/syscall.c:151
       el0_svc+0x58/0x180 arch/arm64/kernel/entry-common.c:879
       el0t_64_sync_handler+0x84/0x12c arch/arm64/kernel/entry-common.c:898
       el0t_64_sync+0x198/0x19c arch/arm64/kernel/entry.S:596

other info that might help us debug this:

Chain exists of:
  sb_internal#2 --> &ocfs2_quota_ip_alloc_sem_key --> &ocfs2_sysfile_lock_key[GLOBAL_BITMAP_SYSTEM_INODE]

 Possible unsafe locking scenario:

       CPU0                    CPU1
       ----                    ----
  lock(&ocfs2_sysfile_lock_key[GLOBAL_BITMAP_SYSTEM_INODE]);
                               lock(&ocfs2_quota_ip_alloc_sem_key);
                               lock(&ocfs2_sysfile_lock_key[GLOBAL_BITMAP_SYSTEM_INODE]);
  rlock(sb_internal#2);

 *** DEADLOCK ***

6 locks held by syz.3.28/6801:
 #0: ffff0000cc700428 (sb_writers#11){.+.+}-{0:0}, at: mnt_want_write_file+0x64/0x1e8 fs/namespace.c:601
 #1: ffff0000f6f009c0 (&type->i_mutex_dir_key#8){+.+.}-{4:4}, at: inode_lock_killable include/linux/fs.h:874 [inline]
 #1: ffff0000f6f009c0 (&type->i_mutex_dir_key#8){+.+.}-{4:4}, at: chown_common+0x290/0x4dc fs/open.c:779
 #2: ffff0000e2d2a0a8 (&dquot->dq_lock){+.+.}-{4:4}, at: ocfs2_acquire_dquot+0x24c/0xa10 fs/ocfs2/quota_global.c:823
 #3: ffff0000f6f05f40 (&ocfs2_sysfile_lock_key[USER_QUOTA_SYSTEM_INODE]){+.+.}-{4:4}, at: inode_lock include/linux/fs.h:869 [inline]
 #3: ffff0000f6f05f40 (&ocfs2_sysfile_lock_key[USER_QUOTA_SYSTEM_INODE]){+.+.}-{4:4}, at: ocfs2_lock_global_qf+0x18c/0x22c fs/ocfs2/quota_global.c:313
 #4: ffff0000f6f05be0 (&ocfs2_quota_ip_alloc_sem_key){++++}-{4:4}, at: ocfs2_lock_global_qf+0x1a8/0x22c fs/ocfs2/quota_global.c:314
 #5: ffff0000f6f05100 (&ocfs2_sysfile_lock_key[GLOBAL_BITMAP_SYSTEM_INODE]){+.+.}-{4:4}, at: inode_lock include/linux/fs.h:869 [inline]
 #5: ffff0000f6f05100 (&ocfs2_sysfile_lock_key[GLOBAL_BITMAP_SYSTEM_INODE]){+.+.}-{4:4}, at: ocfs2_reserve_suballoc_bits+0x12c/0x3b9c fs/ocfs2/suballoc.c:788

stack backtrace:
CPU: 1 UID: 0 PID: 6801 Comm: syz.3.28 Not tainted 6.17.0-rc1-syzkaller-g8f5ae30d69d7 #0 PREEMPT 
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 06/30/2025
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
 __sb_start_write include/linux/fs.h:1798 [inline]
 sb_start_intwrite include/linux/fs.h:1981 [inline]
 ocfs2_start_trans+0x1f4/0x6b0 fs/ocfs2/journal.c:370
 ocfs2_extend_allocation+0x5d4/0x14cc fs/ocfs2/file.c:597
 ocfs2_extend_no_holes+0x1a8/0x424 fs/ocfs2/file.c:1027
 ocfs2_acquire_dquot+0x530/0xa10 fs/ocfs2/quota_global.c:853
 dqget+0x654/0xccc fs/quota/dquot.c:977
 ocfs2_setattr+0xb30/0x17a0 fs/ocfs2/file.c:1233
 notify_change+0x9a4/0xc50 fs/attr.c:552
 chown_common+0x374/0x4dc fs/open.c:791
 vfs_fchown fs/open.c:859 [inline]
 ksys_fchown+0xe0/0x158 fs/open.c:871
 __do_sys_fchown fs/open.c:876 [inline]
 __se_sys_fchown fs/open.c:874 [inline]
 __arm64_sys_fchown+0x7c/0x94 fs/open.c:874
 __invoke_syscall arch/arm64/kernel/syscall.c:35 [inline]
 invoke_syscall+0x98/0x2b8 arch/arm64/kernel/syscall.c:49
 el0_svc_common+0x130/0x23c arch/arm64/kernel/syscall.c:132
 do_el0_svc+0x48/0x58 arch/arm64/kernel/syscall.c:151
 el0_svc+0x58/0x180 arch/arm64/kernel/entry-common.c:879
 el0t_64_sync_handler+0x84/0x12c arch/arm64/kernel/entry-common.c:898
 el0t_64_sync+0x198/0x19c arch/arm64/kernel/entry.S:596
(syz.3.28,6801,1):ocfs2_block_check_validate:402 ERROR: CRC32 failed: stored: 0xdf8356d3, computed 0xb8c23ae4. Applying ECC.
(syz.3.28,6801,1):ocfs2_block_check_validate:416 ERROR: Fixed CRC32 failed: stored: 0xdf8356d3, computed 0x2acb7e3c
(syz.3.28,6801,1):ocfs2_read_quota_phys_block:160 ERROR: status = -5
(syz.3.28,6801,1):ocfs2_quota_read:201 ERROR: status = -5
Quota error (device loop3): qtree_write_dquot: Error -5 occurred while creating quota
(syz.3.28,6801,1):ocfs2_acquire_dquot:890 ERROR: status = -5


---
If you want syzbot to run the reproducer, reply with:
#syz test: git://repo/address.git branch-or-commit-hash
If you attach or paste a git patch, syzbot will apply it before testing.
