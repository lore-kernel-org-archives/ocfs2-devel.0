Received: from mail-oo1-f77.google.com (mail-oo1-f77.google.com [209.85.161.77])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 894C036BCC5
	for <ocfs2-devel@lists.linux.dev>; Thu, 22 Jan 2026 16:49:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.77
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769100574; cv=none; b=uzqjithskc94e8tld3ZEXkN0qNox8KYJubOOiVLNi26IwR5b/Cm19Uz0KBJS/MHyoQC9AuPDXYpmbiRnCtDgQ38K2F+RlGtU8iLF0Hhi/ltDDdAQSisBZiKu+tEZfmwwZHer4ueuUUXSW67jgkrZpFVhEcrvGYsB3zX/KkijDow=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769100574; c=relaxed/simple;
	bh=qx/GQsoMzsoYtu5sFLhJrfEjfr/RJDF/I0daSq/COE4=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=OKbPFlT0owBVS8prMMxTJWSPup853yDsNq8c06VL+MrDwwOmSLhpVduOF5CM4068kwpzqqWM6s9kkn6Zm1m2Ab7yCP4HysTZwDx7Xwuh6cY2C7zI8uBszEwoh6l/VuH63quzxfTmPX2m9UM8+n6wNlFy6EQUMN+6OvAhRWlVimI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.161.77
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oo1-f77.google.com with SMTP id 006d021491bc7-662c9283415so1178953eaf.1
        for <ocfs2-devel@lists.linux.dev>; Thu, 22 Jan 2026 08:49:28 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769100566; x=1769705366;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=oT3aBr/nUZBknq/2rcBhKUqnOr1PYxjom/gvEiWw9cg=;
        b=NM43kdwW/VBPk7+ilevZIChboBrXRBOPQbj6UFT1D4EdpH3PEwPhyJ7J0KlDO7jkEC
         XTFQoQimi5E53wKrkEgOlFByJ725HksRYxMMKO6S5yrlEKr3B3EqWBYiCLimJZKmrD7b
         hnxO/Bxh0c7ho5OGbZ10yNSdXKdr4lOrHothaZ06qs3gxAxeuY+ZAHQT1TnBfI/cXWKl
         D3ebJ8fowzSo39au5ohlJ1MD0fY7fIL0minUYztaIE5WZeoWBC20IDu5DtVm7MEnYwhH
         HSDQpm0V6ULnlJqIOhN0LL0DrB1Veq8KcUF+B9WLiUu2+yMqlP9Ngc4wvymd5ynR8F71
         CWZw==
X-Forwarded-Encrypted: i=1; AJvYcCX3fdmf4t9LlOtLU+En6MbfcVPECEtMTyxgE/1nh9AV2IfwM/JWHF6l1AxXmsMcbUPyYyPll2NjtJ/9MA==@lists.linux.dev
X-Gm-Message-State: AOJu0YycCyBp0u+vWl6VkgGnBva/b6aOBMWP9xyPuPRK8sjkSHRzAWtK
	iYpRGlthpuBkxnbM9TB24D6o1cp03oBtCiIrsEDQ1ossNULJpFHQnHc+/8OFkeY8dMwvIC0HvDq
	OMHMXqjfSxCnq4h0vU6naNko2aGZoBywXb/FfArS/Qutay4IsaZkGsMi3Mgk=
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6820:4b05:b0:662:c78f:5875 with SMTP id
 006d021491bc7-662cab7e99amr99554eaf.61.1769100566236; Thu, 22 Jan 2026
 08:49:26 -0800 (PST)
Date: Thu, 22 Jan 2026 08:49:26 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <69725516.a00a0220.3ad28e.ea7a.GAE@google.com>
Subject: [syzbot] [ocfs2?] possible deadlock in ocfs2_xattr_remove
From: syzbot <syzbot+7df4afa14aeda476a7a1@syzkaller.appspotmail.com>
To: jlbec@evilplan.org, joseph.qi@linux.alibaba.com, 
	linux-kernel@vger.kernel.org, mark@fasheh.com, ocfs2-devel@lists.linux.dev, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    54e82e93ca93 Merge tag 'core_urgent_for_v6.19_rc4' of git:..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=1091f522580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=513255d80ab78f2b
dashboard link: https://syzkaller.appspot.com/bug?extid=7df4afa14aeda476a7a1
compiler:       Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~exp1~20250708183702.136), Debian LLD 20.1.8

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/d900f083ada3/non_bootable_disk-54e82e93.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/f3befb5f53a4/vmlinux-54e82e93.xz
kernel image: https://storage.googleapis.com/syzbot-assets/92820ca1dbd8/bzImage-54e82e93.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+7df4afa14aeda476a7a1@syzkaller.appspotmail.com

======================================================
WARNING: possible circular locking dependency detected
syzkaller #0 Not tainted
------------------------------------------------------
kswapd0/74 is trying to acquire lock:
ffff8880474c6d80 (&ocfs2_sysfile_lock_key[EXTENT_ALLOC_SYSTEM_INODE]){+.+.}-{4:4}, at: inode_lock include/linux/fs.h:1027 [inline]
ffff8880474c6d80 (&ocfs2_sysfile_lock_key[EXTENT_ALLOC_SYSTEM_INODE]){+.+.}-{4:4}, at: ocfs2_xattr_free_block fs/ocfs2/xattr.c:2555 [inline]
ffff8880474c6d80 (&ocfs2_sysfile_lock_key[EXTENT_ALLOC_SYSTEM_INODE]){+.+.}-{4:4}, at: ocfs2_xattr_remove+0x8f4/0x1530 fs/ocfs2/xattr.c:2630

but task is already holding lock:
ffff8880474c5f40 (&ocfs2_sysfile_lock_key[ORPHAN_DIR_SYSTEM_INODE]){+.+.}-{4:4}, at: inode_lock include/linux/fs.h:1027 [inline]
ffff8880474c5f40 (&ocfs2_sysfile_lock_key[ORPHAN_DIR_SYSTEM_INODE]){+.+.}-{4:4}, at: ocfs2_wipe_inode fs/ocfs2/inode.c:854 [inline]
ffff8880474c5f40 (&ocfs2_sysfile_lock_key[ORPHAN_DIR_SYSTEM_INODE]){+.+.}-{4:4}, at: ocfs2_delete_inode fs/ocfs2/inode.c:1157 [inline]
ffff8880474c5f40 (&ocfs2_sysfile_lock_key[ORPHAN_DIR_SYSTEM_INODE]){+.+.}-{4:4}, at: ocfs2_evict_inode+0xf6c/0x4040 fs/ocfs2/inode.c:1299

which lock already depends on the new lock.


the existing dependency chain (in reverse order) is:

-> #3 (&ocfs2_sysfile_lock_key[ORPHAN_DIR_SYSTEM_INODE]){+.+.}-{4:4}:
       down_write+0x96/0x1f0 kernel/locking/rwsem.c:1590
       inode_lock include/linux/fs.h:1027 [inline]
       ocfs2_wipe_inode fs/ocfs2/inode.c:854 [inline]
       ocfs2_delete_inode fs/ocfs2/inode.c:1157 [inline]
       ocfs2_evict_inode+0xf6c/0x4040 fs/ocfs2/inode.c:1299
       evict+0x5f4/0xae0 fs/inode.c:837
       ocfs2_dentry_iput+0x247/0x370 fs/ocfs2/dcache.c:407
       __dentry_kill+0x209/0x660 fs/dcache.c:670
       shrink_kill+0xa9/0x2c0 fs/dcache.c:1137
       shrink_dentry_list+0x2e0/0x5e0 fs/dcache.c:1164
       prune_dcache_sb+0x10e/0x180 fs/dcache.c:1246
       super_cache_scan+0x369/0x4b0 fs/super.c:222
       do_shrink_slab+0x6df/0x10d0 mm/shrinker.c:437
       shrink_slab_memcg mm/shrinker.c:550 [inline]
       shrink_slab+0x7ef/0x10d0 mm/shrinker.c:628
       shrink_one+0x2d9/0x720 mm/vmscan.c:4921
       shrink_many mm/vmscan.c:4982 [inline]
       lru_gen_shrink_node mm/vmscan.c:5060 [inline]
       shrink_node+0x2f7d/0x35b0 mm/vmscan.c:6047
       kswapd_shrink_node mm/vmscan.c:6901 [inline]
       balance_pgdat mm/vmscan.c:7084 [inline]
       kswapd+0x145a/0x2820 mm/vmscan.c:7354
       kthread+0x711/0x8a0 kernel/kthread.c:463
       ret_from_fork+0x510/0xa50 arch/x86/kernel/process.c:158
       ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:246

-> #2 (&osb->nfs_sync_rwlock){.+.+}-{4:4}:
       down_read+0x47/0x2e0 kernel/locking/rwsem.c:1537
       ocfs2_nfs_sync_lock+0x106/0x250 fs/ocfs2/dlmglue.c:2875
       ocfs2_delete_inode fs/ocfs2/inode.c:1108 [inline]
       ocfs2_evict_inode+0x38d/0x4040 fs/ocfs2/inode.c:1299
       evict+0x5f4/0xae0 fs/inode.c:837
       ocfs2_dentry_iput+0x247/0x370 fs/ocfs2/dcache.c:407
       __dentry_kill+0x209/0x660 fs/dcache.c:670
       shrink_kill+0xa9/0x2c0 fs/dcache.c:1137
       shrink_dentry_list+0x2e0/0x5e0 fs/dcache.c:1164
       prune_dcache_sb+0x10e/0x180 fs/dcache.c:1246
       super_cache_scan+0x369/0x4b0 fs/super.c:222
       do_shrink_slab+0x6df/0x10d0 mm/shrinker.c:437
       shrink_slab_memcg mm/shrinker.c:550 [inline]
       shrink_slab+0x7ef/0x10d0 mm/shrinker.c:628
       shrink_one+0x2d9/0x720 mm/vmscan.c:4921
       shrink_many mm/vmscan.c:4982 [inline]
       lru_gen_shrink_node mm/vmscan.c:5060 [inline]
       shrink_node+0x2f7d/0x35b0 mm/vmscan.c:6047
       kswapd_shrink_node mm/vmscan.c:6901 [inline]
       balance_pgdat mm/vmscan.c:7084 [inline]
       kswapd+0x145a/0x2820 mm/vmscan.c:7354
       kthread+0x711/0x8a0 kernel/kthread.c:463
       ret_from_fork+0x510/0xa50 arch/x86/kernel/process.c:158
       ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:246

-> #1 (fs_reclaim){+.+.}-{0:0}:
       __fs_reclaim_acquire mm/page_alloc.c:4301 [inline]
       fs_reclaim_acquire+0x72/0x100 mm/page_alloc.c:4315
       might_alloc include/linux/sched/mm.h:317 [inline]
       slab_pre_alloc_hook mm/slub.c:4904 [inline]
       slab_alloc_node mm/slub.c:5239 [inline]
       __kmalloc_cache_noprof+0x40/0x700 mm/slub.c:5771
       kmalloc_noprof include/linux/slab.h:957 [inline]
       kzalloc_noprof include/linux/slab.h:1094 [inline]
       ocfs2_reserve_clusters_with_limit+0xea/0xba0 fs/ocfs2/suballoc.c:1156
       ocfs2_mknod+0xe10/0x2030 fs/ocfs2/namei.c:358
       ocfs2_create+0x195/0x420 fs/ocfs2/namei.c:677
       lookup_open fs/namei.c:4440 [inline]
       open_last_lookups fs/namei.c:4540 [inline]
       path_openat+0x18bb/0x3dd0 fs/namei.c:4784
       do_filp_open+0x1fa/0x410 fs/namei.c:4814
       do_sys_openat2+0x121/0x200 fs/open.c:1430
       do_sys_open fs/open.c:1436 [inline]
       __do_sys_open fs/open.c:1444 [inline]
       __se_sys_open fs/open.c:1440 [inline]
       __x64_sys_open+0x11e/0x150 fs/open.c:1440
       do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
       do_syscall_64+0xec/0xf80 arch/x86/entry/syscall_64.c:94
       entry_SYSCALL_64_after_hwframe+0x77/0x7f

-> #0 (&ocfs2_sysfile_lock_key[EXTENT_ALLOC_SYSTEM_INODE]){+.+.}-{4:4}:
       check_prev_add kernel/locking/lockdep.c:3165 [inline]
       check_prevs_add kernel/locking/lockdep.c:3284 [inline]
       validate_chain kernel/locking/lockdep.c:3908 [inline]
       __lock_acquire+0x15a6/0x2cf0 kernel/locking/lockdep.c:5237
       lock_acquire+0x107/0x340 kernel/locking/lockdep.c:5868
       down_write+0x96/0x1f0 kernel/locking/rwsem.c:1590
       inode_lock include/linux/fs.h:1027 [inline]
       ocfs2_xattr_free_block fs/ocfs2/xattr.c:2555 [inline]
       ocfs2_xattr_remove+0x8f4/0x1530 fs/ocfs2/xattr.c:2630
       ocfs2_wipe_inode fs/ocfs2/inode.c:884 [inline]
       ocfs2_delete_inode fs/ocfs2/inode.c:1157 [inline]
       ocfs2_evict_inode+0x1407/0x4040 fs/ocfs2/inode.c:1299
       evict+0x5f4/0xae0 fs/inode.c:837
       ocfs2_dentry_iput+0x247/0x370 fs/ocfs2/dcache.c:407
       __dentry_kill+0x209/0x660 fs/dcache.c:670
       shrink_kill+0xa9/0x2c0 fs/dcache.c:1137
       shrink_dentry_list+0x2e0/0x5e0 fs/dcache.c:1164
       prune_dcache_sb+0x10e/0x180 fs/dcache.c:1246
       super_cache_scan+0x369/0x4b0 fs/super.c:222
       do_shrink_slab+0x6df/0x10d0 mm/shrinker.c:437
       shrink_slab_memcg mm/shrinker.c:550 [inline]
       shrink_slab+0x7ef/0x10d0 mm/shrinker.c:628
       shrink_one+0x2d9/0x720 mm/vmscan.c:4921
       shrink_many mm/vmscan.c:4982 [inline]
       lru_gen_shrink_node mm/vmscan.c:5060 [inline]
       shrink_node+0x2f7d/0x35b0 mm/vmscan.c:6047
       kswapd_shrink_node mm/vmscan.c:6901 [inline]
       balance_pgdat mm/vmscan.c:7084 [inline]
       kswapd+0x145a/0x2820 mm/vmscan.c:7354
       kthread+0x711/0x8a0 kernel/kthread.c:463
       ret_from_fork+0x510/0xa50 arch/x86/kernel/process.c:158
       ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:246

other info that might help us debug this:

Chain exists of:
  &ocfs2_sysfile_lock_key[EXTENT_ALLOC_SYSTEM_INODE] --> &osb->nfs_sync_rwlock --> &ocfs2_sysfile_lock_key[ORPHAN_DIR_SYSTEM_INODE]

 Possible unsafe locking scenario:

       CPU0                    CPU1
       ----                    ----
  lock(&ocfs2_sysfile_lock_key[ORPHAN_DIR_SYSTEM_INODE]);
                               lock(&osb->nfs_sync_rwlock);
                               lock(&ocfs2_sysfile_lock_key[ORPHAN_DIR_SYSTEM_INODE]);
  lock(&ocfs2_sysfile_lock_key[EXTENT_ALLOC_SYSTEM_INODE]);

 *** DEADLOCK ***

4 locks held by kswapd0/74:
 #0: ffffffff8e051900 (fs_reclaim){+.+.}-{0:0}, at: balance_pgdat mm/vmscan.c:6975 [inline]
 #0: ffffffff8e051900 (fs_reclaim){+.+.}-{0:0}, at: kswapd+0x92a/0x2820 mm/vmscan.c:7354
 #1: ffff8880112f60e0 (&type->s_umount_key#51){.+.+}-{4:4}, at: super_trylock_shared fs/super.c:563 [inline]
 #1: ffff8880112f60e0 (&type->s_umount_key#51){.+.+}-{4:4}, at: super_cache_scan+0x91/0x4b0 fs/super.c:197
 #2: ffff888037e50bd0 (&osb->nfs_sync_rwlock){.+.+}-{4:4}, at: ocfs2_nfs_sync_lock+0x106/0x250 fs/ocfs2/dlmglue.c:2875
 #3: ffff8880474c5f40 (&ocfs2_sysfile_lock_key[ORPHAN_DIR_SYSTEM_INODE]){+.+.}-{4:4}, at: inode_lock include/linux/fs.h:1027 [inline]
 #3: ffff8880474c5f40 (&ocfs2_sysfile_lock_key[ORPHAN_DIR_SYSTEM_INODE]){+.+.}-{4:4}, at: ocfs2_wipe_inode fs/ocfs2/inode.c:854 [inline]
 #3: ffff8880474c5f40 (&ocfs2_sysfile_lock_key[ORPHAN_DIR_SYSTEM_INODE]){+.+.}-{4:4}, at: ocfs2_delete_inode fs/ocfs2/inode.c:1157 [inline]
 #3: ffff8880474c5f40 (&ocfs2_sysfile_lock_key[ORPHAN_DIR_SYSTEM_INODE]){+.+.}-{4:4}, at: ocfs2_evict_inode+0xf6c/0x4040 fs/ocfs2/inode.c:1299

stack backtrace:
CPU: 0 UID: 0 PID: 74 Comm: kswapd0 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2~bpo12+1 04/01/2014
Call Trace:
 <TASK>
 dump_stack_lvl+0xe8/0x150 lib/dump_stack.c:120
 print_circular_bug+0x2e2/0x300 kernel/locking/lockdep.c:2043
 check_noncircular+0x12e/0x150 kernel/locking/lockdep.c:2175
 check_prev_add kernel/locking/lockdep.c:3165 [inline]
 check_prevs_add kernel/locking/lockdep.c:3284 [inline]
 validate_chain kernel/locking/lockdep.c:3908 [inline]
 __lock_acquire+0x15a6/0x2cf0 kernel/locking/lockdep.c:5237
 lock_acquire+0x107/0x340 kernel/locking/lockdep.c:5868
 down_write+0x96/0x1f0 kernel/locking/rwsem.c:1590
 inode_lock include/linux/fs.h:1027 [inline]
 ocfs2_xattr_free_block fs/ocfs2/xattr.c:2555 [inline]
 ocfs2_xattr_remove+0x8f4/0x1530 fs/ocfs2/xattr.c:2630
 ocfs2_wipe_inode fs/ocfs2/inode.c:884 [inline]
 ocfs2_delete_inode fs/ocfs2/inode.c:1157 [inline]
 ocfs2_evict_inode+0x1407/0x4040 fs/ocfs2/inode.c:1299
 evict+0x5f4/0xae0 fs/inode.c:837
 ocfs2_dentry_iput+0x247/0x370 fs/ocfs2/dcache.c:407
 __dentry_kill+0x209/0x660 fs/dcache.c:670
 shrink_kill+0xa9/0x2c0 fs/dcache.c:1137
 shrink_dentry_list+0x2e0/0x5e0 fs/dcache.c:1164
 prune_dcache_sb+0x10e/0x180 fs/dcache.c:1246
 super_cache_scan+0x369/0x4b0 fs/super.c:222
 do_shrink_slab+0x6df/0x10d0 mm/shrinker.c:437
 shrink_slab_memcg mm/shrinker.c:550 [inline]
 shrink_slab+0x7ef/0x10d0 mm/shrinker.c:628
 shrink_one+0x2d9/0x720 mm/vmscan.c:4921
 shrink_many mm/vmscan.c:4982 [inline]
 lru_gen_shrink_node mm/vmscan.c:5060 [inline]
 shrink_node+0x2f7d/0x35b0 mm/vmscan.c:6047
 kswapd_shrink_node mm/vmscan.c:6901 [inline]
 balance_pgdat mm/vmscan.c:7084 [inline]
 kswapd+0x145a/0x2820 mm/vmscan.c:7354
 kthread+0x711/0x8a0 kernel/kthread.c:463
 ret_from_fork+0x510/0xa50 arch/x86/kernel/process.c:158
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:246
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
