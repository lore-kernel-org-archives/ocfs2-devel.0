Received: from mail-io1-f80.google.com (mail-io1-f80.google.com [209.85.166.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40C46757EB
	for <ocfs2-devel@lists.linux.dev>; Sun,  1 Dec 2024 13:09:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733058570; cv=none; b=JM6eF9AnN8A6oj2YlfiU95yk+ssGmSTUpRUOkYLMmU/H3NBa0iz6ATXRdZk8rmbYVFP8xRnsRoyyxGWRsNhCBXvSbswUZa2KHcY0mSM+tBU240DYJI8ercTCcee0MrfOWy6VZ076fcweNXvw/YEYmHDDPLA8JSyDVVkhi/9Gd14=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733058570; c=relaxed/simple;
	bh=GJdRNx9dlDVmVy5TMl9XqXIJ8bpgOR+y+VStV5o94Cc=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=Hr3wNeovLZykiqyadg9/PSrn+ZF1pSmUd21e4XjudNA99gwGI4o00lDpK7I733ZccQu867BprWlMI8b80NnHXB3POCIAXSq9nnDPOa09KcVzGmBumb/AqayEq/8D/a1Y/Zk0o2dScU9nxr5Oz/XEwccumzaLBmwG+VlqUdtSLBI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-io1-f80.google.com with SMTP id ca18e2360f4ac-8418307b4f9so326553039f.1
        for <ocfs2-devel@lists.linux.dev>; Sun, 01 Dec 2024 05:09:27 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733058566; x=1733663366;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ahc1VDdttklxMk7f2s3sjJ1up9GsgDsjKAXEq4eqgkE=;
        b=FBPNaGenBrh0wDWukEkqHc6yNo8tFBES5ERnKxa9H1L4a03McsIagM2Hi8u3eAGiAB
         354pKmg7kW5muMPLF5VRamBqIZ49oX6gEdwgNStHSIq6f1YfemgOM7XeAKsg76Q1FoD0
         XuUknxv7Cfxl62GoqeYaKTpPYnqb2Dx61m+V+E/lJnNQ1HRgp6Cz85/egKAsHckeI9yb
         fasXjFmVp4zpXEofXG5dc5mMj/5DrehKccV1Ne1ckHL+ZSMH1MhbVpchXbGylcP/scJf
         xpC71DaDaVcGBp+TBXW0bFziRcl7653pwP5KSzXToWqs42ItfMQtX9RN8wXDSIB1koik
         bTPQ==
X-Forwarded-Encrypted: i=1; AJvYcCVYbJabNLf/VYfVE/Gt0U/CVAO/Q9uURSuDxRM5VTMO+rs7+JlODAH4S+lfvpxJMPr3Ts5pZHg0msMFYg==@lists.linux.dev
X-Gm-Message-State: AOJu0Yy/qaslEdqwTtK8z9RFp9qafVVRtsInbyD+9NunlVUJeYKJ3DrH
	CzYh7znpesoSAfsOf4Y9wXRQItArZShqv8WhsbA1Mgg4E38a0wo2+5FML7LDasNgmkIPrPR1jzo
	oORqavh2wwXun65l9L/0KAE2VJfhj9WSAOmGeOPYauTM6SW0208thCns=
X-Google-Smtp-Source: AGHT+IGuTa+mvEd0Y6YfdFA8NVG+Azqprg+/0rOmcrRNNTe2WWqlhmvYqYNKTzkSAmLDWTB0u/WF5Hs0W8OUBUiqfenQpmdrhHp+
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:12cc:b0:3a7:7ad4:fe78 with SMTP id
 e9e14a558f8ab-3a7c55d3e94mr196879045ab.19.1733058566358; Sun, 01 Dec 2024
 05:09:26 -0800 (PST)
Date: Sun, 01 Dec 2024 05:09:26 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <674c6006.050a0220.ad585.0036.GAE@google.com>
Subject: [syzbot] [ocfs2?] possible deadlock in ocfs2_xattr_ibody_find
From: syzbot <syzbot+2471d99ca242f0f7a2a3@syzkaller.appspotmail.com>
To: jlbec@evilplan.org, joseph.qi@linux.alibaba.com, 
	linux-kernel@vger.kernel.org, mark@fasheh.com, ocfs2-devel@lists.linux.dev, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    798bb342e041 Merge tag 'rust-6.13' of https://github.com/R..
git tree:       upstream
console+strace: https://syzkaller.appspot.com/x/log.txt?x=1025e1e8580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=8df9bf3383f5970
dashboard link: https://syzkaller.appspot.com/bug?extid=2471d99ca242f0f7a2a3
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=11033530580000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=13137778580000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/0c248a1aba4a/disk-798bb342.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/6254303dc885/vmlinux-798bb342.xz
kernel image: https://storage.googleapis.com/syzbot-assets/60e099a4ee5f/bzImage-798bb342.xz
mounted in repro: https://storage.googleapis.com/syzbot-assets/768a41dc7c14/mount_0.gz

Bisection is inconclusive: the first bad commit could be any of:

309a43165077 rcu/kvfree: Use consistent krcp when growing kfree_rcu() page cache
021a5ff84743 rcu/kvfree: Do not run a page work if a cache is disabled
1e237994d9c9 rcu/kvfree: Invoke debug_rcu_bhead_unqueue() after checking bnode->gp_snap
60888b77a06e rcu/kvfree: Make fill page cache start from krcp->nr_bkv_objs
f32276a37652 rcu/kvfree: Add debug check for GP complete for kfree_rcu_cpu list
6b706e5603c4 rcu/kvfree: Make drain_page_cache() take early return if cache is disabled
cdfa0f6fa6b7 rcu/kvfree: Add debug to check grace periods
2e31da752c6d Merge branches 'doc.2023.05.10a', 'fixes.2023.05.11a', 'kvfree.2023.05.10a', 'nocb.2023.05.11a', 'rcu-tasks.2023.05.10a', 'torture.2023.05.15a' and 'rcu-urgent.2023.06.06a' into HEAD
7e3f926bf453 rcu/kvfree: Eliminate k[v]free_rcu() single argument macro
af96134dc856 Merge tag 'rcu.2023.06.22a' of git://git.kernel.org/pub/scm/linux/kernel/git/paulmck/linux-rcu

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=10f90f78580000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+2471d99ca242f0f7a2a3@syzkaller.appspotmail.com

JBD2: Ignoring recovery information on journal
ocfs2: Mounting device (7,0) on (node local, slot 0) with ordered data mode.
======================================================
WARNING: possible circular locking dependency detected
6.12.0-syzkaller-09837-g798bb342e041 #0 Not tainted
------------------------------------------------------
syz-executor980/5976 is trying to acquire lock:
ffff888077f96a20 (&ocfs2_quota_ip_alloc_sem_key){++++}-{4:4}, at: ocfs2_xattr_ibody_find+0x134/0x7c0 fs/ocfs2/xattr.c:2689

but task is already holding lock:
ffff888077f96ab8 (&oi->ip_xattr_sem){++++}-{4:4}, at: ocfs2_xattr_set_handle+0x539/0xa10 fs/ocfs2/xattr.c:3501

which lock already depends on the new lock.


the existing dependency chain (in reverse order) is:

-> #4 (&oi->ip_xattr_sem){++++}-{4:4}:
       lock_acquire+0x1ed/0x550 kernel/locking/lockdep.c:5849
       down_write+0x99/0x220 kernel/locking/rwsem.c:1577
       ocfs2_xattr_set_handle+0x539/0xa10 fs/ocfs2/xattr.c:3501
       ocfs2_init_security_set+0xbd/0xd0 fs/ocfs2/xattr.c:7307
       ocfs2_mknod+0x1ccf/0x2b40 fs/ocfs2/namei.c:417
       ocfs2_create+0x1ab/0x480 fs/ocfs2/namei.c:672
       lookup_open fs/namei.c:3649 [inline]
       open_last_lookups fs/namei.c:3748 [inline]
       path_openat+0x1c03/0x3590 fs/namei.c:3984
       do_filp_open+0x27f/0x4e0 fs/namei.c:4014
       do_sys_openat2+0x13e/0x1d0 fs/open.c:1402
       do_sys_open fs/open.c:1417 [inline]
       __do_sys_openat fs/open.c:1433 [inline]
       __se_sys_openat fs/open.c:1428 [inline]
       __x64_sys_openat+0x247/0x2a0 fs/open.c:1428
       do_syscall_x64 arch/x86/entry/common.c:52 [inline]
       do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
       entry_SYSCALL_64_after_hwframe+0x77/0x7f

-> #3 (jbd2_handle){++++}-{0:0}:
       lock_acquire+0x1ed/0x550 kernel/locking/lockdep.c:5849
       start_this_handle+0x1eb4/0x2110 fs/jbd2/transaction.c:448
       jbd2__journal_start+0x2da/0x5d0 fs/jbd2/transaction.c:505
       jbd2_journal_start+0x29/0x40 fs/jbd2/transaction.c:544
       ocfs2_start_trans+0x3c9/0x700 fs/ocfs2/journal.c:352
       ocfs2_modify_bh+0xed/0x4d0 fs/ocfs2/quota_local.c:101
       ocfs2_local_read_info+0x158f/0x19f0 fs/ocfs2/quota_local.c:771
       dquot_load_quota_sb+0x762/0xbb0 fs/quota/dquot.c:2457
       dquot_load_quota_inode+0x320/0x600 fs/quota/dquot.c:2494
       ocfs2_enable_quotas+0x169/0x450 fs/ocfs2/super.c:926
       ocfs2_fill_super+0x4ca1/0x5760 fs/ocfs2/super.c:1141
       mount_bdev+0x20a/0x2d0 fs/super.c:1693
       legacy_get_tree+0xee/0x190 fs/fs_context.c:662
       vfs_get_tree+0x90/0x2b0 fs/super.c:1814
       do_new_mount+0x2be/0xb40 fs/namespace.c:3507
       do_mount fs/namespace.c:3847 [inline]
       __do_sys_mount fs/namespace.c:4057 [inline]
       __se_sys_mount+0x2d6/0x3c0 fs/namespace.c:4034
       do_syscall_x64 arch/x86/entry/common.c:52 [inline]
       do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
       entry_SYSCALL_64_after_hwframe+0x77/0x7f

-> #2 (&journal->j_trans_barrier){.+.+}-{4:4}:
       lock_acquire+0x1ed/0x550 kernel/locking/lockdep.c:5849
       down_read+0xb1/0xa40 kernel/locking/rwsem.c:1524
       ocfs2_start_trans+0x3be/0x700 fs/ocfs2/journal.c:350
       ocfs2_modify_bh+0xed/0x4d0 fs/ocfs2/quota_local.c:101
       ocfs2_local_read_info+0x158f/0x19f0 fs/ocfs2/quota_local.c:771
       dquot_load_quota_sb+0x762/0xbb0 fs/quota/dquot.c:2457
       dquot_load_quota_inode+0x320/0x600 fs/quota/dquot.c:2494
       ocfs2_enable_quotas+0x169/0x450 fs/ocfs2/super.c:926
       ocfs2_fill_super+0x4ca1/0x5760 fs/ocfs2/super.c:1141
       mount_bdev+0x20a/0x2d0 fs/super.c:1693
       legacy_get_tree+0xee/0x190 fs/fs_context.c:662
       vfs_get_tree+0x90/0x2b0 fs/super.c:1814
       do_new_mount+0x2be/0xb40 fs/namespace.c:3507
       do_mount fs/namespace.c:3847 [inline]
       __do_sys_mount fs/namespace.c:4057 [inline]
       __se_sys_mount+0x2d6/0x3c0 fs/namespace.c:4034
       do_syscall_x64 arch/x86/entry/common.c:52 [inline]
       do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
       entry_SYSCALL_64_after_hwframe+0x77/0x7f

-> #1 (sb_internal#2){.+.+}-{0:0}:
       lock_acquire+0x1ed/0x550 kernel/locking/lockdep.c:5849
       percpu_down_read include/linux/percpu-rwsem.h:51 [inline]
       __sb_start_write include/linux/fs.h:1725 [inline]
       sb_start_intwrite include/linux/fs.h:1908 [inline]
       ocfs2_start_trans+0x2b9/0x700 fs/ocfs2/journal.c:348
       ocfs2_acquire_dquot+0x6df/0xb80 fs/ocfs2/quota_global.c:855
       dqget+0x770/0xeb0 fs/quota/dquot.c:975
       __dquot_initialize+0x2e3/0xec0 fs/quota/dquot.c:1503
       ocfs2_get_init_inode+0x158/0x1c0 fs/ocfs2/namei.c:202
       ocfs2_mknod+0xcfa/0x2b40 fs/ocfs2/namei.c:308
       ocfs2_create+0x1ab/0x480 fs/ocfs2/namei.c:672
       lookup_open fs/namei.c:3649 [inline]
       open_last_lookups fs/namei.c:3748 [inline]
       path_openat+0x1c03/0x3590 fs/namei.c:3984
       do_filp_open+0x27f/0x4e0 fs/namei.c:4014
       do_sys_openat2+0x13e/0x1d0 fs/open.c:1402
       do_sys_open fs/open.c:1417 [inline]
       __do_sys_openat fs/open.c:1433 [inline]
       __se_sys_openat fs/open.c:1428 [inline]
       __x64_sys_openat+0x247/0x2a0 fs/open.c:1428
       do_syscall_x64 arch/x86/entry/common.c:52 [inline]
       do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
       entry_SYSCALL_64_after_hwframe+0x77/0x7f

-> #0 (&ocfs2_quota_ip_alloc_sem_key){++++}-{4:4}:
       check_prev_add kernel/locking/lockdep.c:3161 [inline]
       check_prevs_add kernel/locking/lockdep.c:3280 [inline]
       validate_chain+0x18ef/0x5920 kernel/locking/lockdep.c:3904
       __lock_acquire+0x1397/0x2100 kernel/locking/lockdep.c:5226
       lock_acquire+0x1ed/0x550 kernel/locking/lockdep.c:5849
       down_read+0xb1/0xa40 kernel/locking/rwsem.c:1524
       ocfs2_xattr_ibody_find+0x134/0x7c0 fs/ocfs2/xattr.c:2689
       ocfs2_xattr_set_handle+0x552/0xa10 fs/ocfs2/xattr.c:3503
       ocfs2_init_security_set+0xbd/0xd0 fs/ocfs2/xattr.c:7307
       ocfs2_mknod+0x1ccf/0x2b40 fs/ocfs2/namei.c:417
       ocfs2_create+0x1ab/0x480 fs/ocfs2/namei.c:672
       lookup_open fs/namei.c:3649 [inline]
       open_last_lookups fs/namei.c:3748 [inline]
       path_openat+0x1c03/0x3590 fs/namei.c:3984
       do_filp_open+0x27f/0x4e0 fs/namei.c:4014
       do_sys_openat2+0x13e/0x1d0 fs/open.c:1402
       do_sys_open fs/open.c:1417 [inline]
       __do_sys_openat fs/open.c:1433 [inline]
       __se_sys_openat fs/open.c:1428 [inline]
       __x64_sys_openat+0x247/0x2a0 fs/open.c:1428
       do_syscall_x64 arch/x86/entry/common.c:52 [inline]
       do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
       entry_SYSCALL_64_after_hwframe+0x77/0x7f

other info that might help us debug this:

Chain exists of:
  &ocfs2_quota_ip_alloc_sem_key --> jbd2_handle --> &oi->ip_xattr_sem

 Possible unsafe locking scenario:

       CPU0                    CPU1
       ----                    ----
  lock(&oi->ip_xattr_sem);
                               lock(jbd2_handle);
                               lock(&oi->ip_xattr_sem);
  rlock(&ocfs2_quota_ip_alloc_sem_key);

 *** DEADLOCK ***

9 locks held by syz-executor980/5976:
 #0: ffff8880357ce420 (sb_writers#9){.+.+}-{0:0}, at: mnt_want_write+0x3f/0x90 fs/namespace.c:515
 #1: ffff888077f99800 (&type->i_mutex_dir_key#6){+.+.}-{4:4}, at: inode_lock include/linux/fs.h:818 [inline]
 #1: ffff888077f99800 (&type->i_mutex_dir_key#6){+.+.}-{4:4}, at: open_last_lookups fs/namei.c:3745 [inline]
 #1: ffff888077f99800 (&type->i_mutex_dir_key#6){+.+.}-{4:4}, at: path_openat+0x89a/0x3590 fs/namei.c:3984
 #2: ffff888072491800 (&ocfs2_sysfile_lock_key[args->fi_sysfile_type]#2){+.+.}-{4:4}, at: inode_lock include/linux/fs.h:818 [inline]
 #2: ffff888072491800 (&ocfs2_sysfile_lock_key[args->fi_sysfile_type]#2){+.+.}-{4:4}, at: ocfs2_reserve_suballoc_bits+0x192/0x4eb0 fs/ocfs2/suballoc.c:786
 #3: ffff888072492640 (&ocfs2_sysfile_lock_key[args->fi_sysfile_type]#7){+.+.}-{4:4}, at: inode_lock include/linux/fs.h:818 [inline]
 #3: ffff888072492640 (&ocfs2_sysfile_lock_key[args->fi_sysfile_type]#7){+.+.}-{4:4}, at: ocfs2_reserve_suballoc_bits+0x192/0x4eb0 fs/ocfs2/suballoc.c:786
 #4: ffff888072499800 (&ocfs2_sysfile_lock_key[args->fi_sysfile_type]#4){+.+.}-{4:4}, at: inode_lock include/linux/fs.h:818 [inline]
 #4: ffff888072499800 (&ocfs2_sysfile_lock_key[args->fi_sysfile_type]#4){+.+.}-{4:4}, at: ocfs2_reserve_local_alloc_bits+0x132/0x2870 fs/ocfs2/localalloc.c:636
 #5: ffff8880357ce610 (sb_internal#2){.+.+}-{0:0}, at: ocfs2_mknod+0x150c/0x2b40 fs/ocfs2/namei.c:359
 #6: ffff88802978dce8 (&journal->j_trans_barrier){.+.+}-{4:4}, at: ocfs2_start_trans+0x3be/0x700 fs/ocfs2/journal.c:350
 #7: ffff88807c7d8958 (jbd2_handle){++++}-{0:0}, at: start_this_handle+0x1e94/0x2110 fs/jbd2/transaction.c:448
 #8: ffff888077f96ab8 (&oi->ip_xattr_sem){++++}-{4:4}, at: ocfs2_xattr_set_handle+0x539/0xa10 fs/ocfs2/xattr.c:3501

stack backtrace:
CPU: 1 UID: 0 PID: 5976 Comm: syz-executor980 Not tainted 6.12.0-syzkaller-09837-g798bb342e041 #0
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
 __lock_acquire+0x1397/0x2100 kernel/locking/lockdep.c:5226
 lock_acquire+0x1ed/0x550 kernel/locking/lockdep.c:5849
 down_read+0xb1/0xa40 kernel/locking/rwsem.c:1524
 ocfs2_xattr_ibody_find+0x134/0x7c0 fs/ocfs2/xattr.c:2689
 ocfs2_xattr_set_handle+0x552/0xa10 fs/ocfs2/xattr.c:3503
 ocfs2_init_security_set+0xbd/0xd0 fs/ocfs2/xattr.c:7307
 ocfs2_mknod+0x1ccf/0x2b40 fs/ocfs2/namei.c:417
 ocfs2_create+0x1ab/0x480 fs/ocfs2/namei.c:672
 lookup_open fs/namei.c:3649 [inline]
 open_last_lookups fs/namei.c:3748 [inline]
 path_openat+0x1c03/0x3590 fs/namei.c:3984
 do_filp_open+0x27f/0x4e0 fs/namei.c:4014
 do_sys_openat2+0x13e/0x1d0 fs/open.c:1402
 do_sys_open fs/open.c:1417 [inline]
 __do_sys_openat fs/open.c:1433 [inline]
 __se_sys_openat fs/open.c:1428 [inline]
 __x64_sys_openat+0x247/0x2a0 fs/open.c:1428
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f99367550e9
Code: 28 00 00 00 75 05 48 83 c4 28 c3 e8 21 18 00 00 90 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 b8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007ffd28caa088 EFLAGS: 00000246 ORIG_RAX: 0000000000000101
RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007f99367550e9
RDX: 000000000000275a RSI: 0000000020000280 RDI: 00000000ffffff9c
RBP: 00000000ffffffff R08: 0000000000020663 R09: 0000000000200004
R10: 0000000000000000 R11: 0000000000000246 R12: 00007ffd28caa0d0
R13: 00007ffd28caa110 R14: 0000000008000000 R15: 0000000000000003
 </TASK>


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
For information about bisection process see: https://goo.gl/tpsmEJ#bisection

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
