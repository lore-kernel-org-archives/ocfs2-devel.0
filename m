Received: from mail-oi1-f207.google.com (mail-oi1-f207.google.com [209.85.167.207])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF9CD2BE7BE
	for <ocfs2-devel@lists.linux.dev>; Mon, 20 Jul 2026 05:05:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784523932; cv=none; b=ueWPrYoWwQUl+AcFMQeRln3mjzt0zsXwozQW65U/xnWOwF3bSJIj8IumJvSJgvRWtZJp70J6cNd+lgoBDqK5F61mCEsO3MiBXTVDcplqt2CdRZFF+SV6TFf3uOaq96Ar6XkvunY5WVSq7V59ubwkFPSBU5RpJ1qDLPug/KmEwdw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784523932; c=relaxed/simple;
	bh=DTzlw46JOp9QfhO6bRLkxGlX+wKJzzL+wlokw6vMaDg=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=KHEUV8h1JtY94+fuemFG9zJ2ob7K1+72Qh/Bn0dwAOquC5BUPWg0tDK5BuQoz1pyebWWumUpeeAZAlMZcukc7BMqQMyCqPOZbb6G40teNdDWtHwo9Lc2OeOOrWVhh4xxoikEtFSF+crSXTrUncfTfBhMUHWdPgt1VilwMXFrxHI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.167.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oi1-f207.google.com with SMTP id 5614622812f47-4a416619e8dso6448851b6e.1
        for <ocfs2-devel@lists.linux.dev>; Sun, 19 Jul 2026 22:05:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784523929; x=1785128729;
        h=content-type:to:from:subject:message-id:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=KjXPbr6uMxu8UuAHcTYH1k4cPiBqMaTG/m9nKuj0+Y0=;
        b=stVNDMvlQ/36gkyy7l2vIUQm/+q+l9S9b1jDmCdrPTSLVp47VDy8yjBEYjqvhDjLUh
         xlp9ig/hCEL9FCS1MIzjHB28Fhrh7g89XsEQ9UZ1cqpUX/Rc1FYBh3qfnjJ6ZCh6xcRp
         /+rzVcqO4wsCdOGUa+p/qZ7MEuQlHaHIqCZ9lxLlBWNWKKfcFHxVbZACDJFXe243vkVC
         1OsdlNld5V/DtY3ajBCykIzOmppHiWNkU37Pccm8P/KLtxJ9HcjS+FRNs8vFlsoA2quJ
         aYv+DB18px0sHJ+K4EeUTR4BQidBWC8w7Vq9ucfNJkupRitl2B6YjjwzPcXqQNgH6+yM
         mbvA==
X-Forwarded-Encrypted: i=1; AHgh+RojvDdiMfTkfMN3BeK+hLRdpk3F6YYhVmfMemYXOVDhT4EXI6UPTO8BTZeknWC6cKS6hpnj5XaIZ+5Y2g==@lists.linux.dev
X-Gm-Message-State: AOJu0Yx2IuDjmt92YviMyrlQgL8eYW8H6PLFt1V/WOXA23zEQLxofcc1
	WgRv4a3OCxgcdOwxZk+5HkWm1CkJr2EZBjTF4zTxIcASXymNs+UjSJRlmeKQP6kOBPKxi5BW7Fi
	OQ1Kjy6jyttqYxRx5TcUC+8EkJtaNwlO2L49WVDyfEu3yceBsap05StvnBUs=
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6808:2388:b0:495:2580:2974 with SMTP id
 5614622812f47-4a4b23d64a4mr10366548b6e.30.1784523929606; Sun, 19 Jul 2026
 22:05:29 -0700 (PDT)
Date: Sun, 19 Jul 2026 22:05:29 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6a5dac99.42649fcc.6186.007f.GAE@google.com>
Subject: [syzbot] [ocfs2?] possible deadlock in ocfs2_evict_inode (2)
From: syzbot <syzbot+99ed7f9e22e83c1eaea1@syzkaller.appspotmail.com>
To: jlbec@evilplan.org, joseph.qi@linux.alibaba.com, 
	linux-kernel@vger.kernel.org, mark@fasheh.com, ocfs2-devel@lists.linux.dev, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    58717b2a1365 Merge tag 'sound-7.2-rc4' of git://git.kernel..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=100354b9580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=20c9876b0f77b546
dashboard link: https://syzkaller.appspot.com/bug?extid=99ed7f9e22e83c1eaea1
compiler:       Debian clang version 22.1.8 (++20260613092233+e80beda6e255-1~exp1~20260613092250.77), Debian LLD 22.1.8

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/d900f083ada3/non_bootable_disk-58717b2a.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/c55a804d84b6/vmlinux-58717b2a.xz
kernel image: https://storage.googleapis.com/syzbot-assets/9e654c04764e/bzImage-58717b2a.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+99ed7f9e22e83c1eaea1@syzkaller.appspotmail.com


======================================================
WARNING: possible circular locking dependency detected
syzkaller #0 Not tainted
------------------------------------------------------
kswapd0/70 is trying to acquire lock:
ffff8880444617a0 (&ocfs2_sysfile_lock_key[INODE_ALLOC_SYSTEM_INODE]){+.+.}-{4:4}, at: inode_lock include/linux/fs.h:1024 [inline]
ffff8880444617a0 (&ocfs2_sysfile_lock_key[INODE_ALLOC_SYSTEM_INODE]){+.+.}-{4:4}, at: ocfs2_remove_inode fs/ocfs2/inode.c:767 [inline]
ffff8880444617a0 (&ocfs2_sysfile_lock_key[INODE_ALLOC_SYSTEM_INODE]){+.+.}-{4:4}, at: ocfs2_wipe_inode fs/ocfs2/inode.c:930 [inline]
ffff8880444617a0 (&ocfs2_sysfile_lock_key[INODE_ALLOC_SYSTEM_INODE]){+.+.}-{4:4}, at: ocfs2_delete_inode fs/ocfs2/inode.c:1191 [inline]
ffff8880444617a0 (&ocfs2_sysfile_lock_key[INODE_ALLOC_SYSTEM_INODE]){+.+.}-{4:4}, at: ocfs2_evict_inode+0x1489/0x4390 fs/ocfs2/inode.c:1333

but task is already holding lock:
ffff8880444633a0 (&ocfs2_sysfile_lock_key[ORPHAN_DIR_SYSTEM_INODE]){+.+.}-{4:4}, at: inode_lock include/linux/fs.h:1024 [inline]
ffff8880444633a0 (&ocfs2_sysfile_lock_key[ORPHAN_DIR_SYSTEM_INODE]){+.+.}-{4:4}, at: ocfs2_wipe_inode fs/ocfs2/inode.c:888 [inline]
ffff8880444633a0 (&ocfs2_sysfile_lock_key[ORPHAN_DIR_SYSTEM_INODE]){+.+.}-{4:4}, at: ocfs2_delete_inode fs/ocfs2/inode.c:1191 [inline]
ffff8880444633a0 (&ocfs2_sysfile_lock_key[ORPHAN_DIR_SYSTEM_INODE]){+.+.}-{4:4}, at: ocfs2_evict_inode+0xe39/0x4390 fs/ocfs2/inode.c:1333

which lock already depends on the new lock.


the existing dependency chain (in reverse order) is:

-> #3 (&ocfs2_sysfile_lock_key[ORPHAN_DIR_SYSTEM_INODE]){+.+.}-{4:4}:
       down_write+0x96/0x200 kernel/locking/rwsem.c:1631
       inode_lock include/linux/fs.h:1024 [inline]
       ocfs2_wipe_inode fs/ocfs2/inode.c:888 [inline]
       ocfs2_delete_inode fs/ocfs2/inode.c:1191 [inline]
       ocfs2_evict_inode+0xe39/0x4390 fs/ocfs2/inode.c:1333
       evict+0x624/0xb50 fs/inode.c:825
       ocfs2_dentry_iput+0x24d/0x390 fs/ocfs2/dcache.c:407
       dentry_kill+0x1b9/0x880 fs/dcache.c:826
       shrink_kill fs/dcache.c:1275 [inline]
       shrink_dentry_list+0x209/0x310 fs/dcache.c:1292
       prune_dcache_sb+0x119/0x180 fs/dcache.c:1374
       super_cache_scan+0x35c/0x4a0 fs/super.c:223
       do_shrink_slab+0x6d0/0x10e0 mm/shrinker.c:443
       shrink_slab_memcg mm/shrinker.c:560 [inline]
       shrink_slab+0x838/0x1220 mm/shrinker.c:638
       shrink_one+0x2a2/0x730 mm/vmscan.c:5026
       shrink_many mm/vmscan.c:5087 [inline]
       lru_gen_shrink_node mm/vmscan.c:5165 [inline]
       shrink_node+0x3303/0x3b60 mm/vmscan.c:6154
       kswapd_shrink_node mm/vmscan.c:7008 [inline]
       balance_pgdat mm/vmscan.c:7186 [inline]
       kswapd+0x17b6/0x31c0 mm/vmscan.c:7462
       kthread+0x388/0x470 kernel/kthread.c:436
       ret_from_fork+0x514/0xb70 arch/x86/kernel/process.c:158
       ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245

-> #2 (&osb->nfs_sync_rwlock){.+.+}-{4:4}:
       down_read+0x4a/0x330 kernel/locking/rwsem.c:1574
       ocfs2_nfs_sync_lock+0x106/0x270 fs/ocfs2/dlmglue.c:2875
       ocfs2_delete_inode fs/ocfs2/inode.c:1142 [inline]
       ocfs2_evict_inode+0x3a6/0x4390 fs/ocfs2/inode.c:1333
       evict+0x624/0xb50 fs/inode.c:825
       ocfs2_dentry_iput+0x24d/0x390 fs/ocfs2/dcache.c:407
       dentry_kill+0x1b9/0x880 fs/dcache.c:826
       shrink_kill fs/dcache.c:1275 [inline]
       shrink_dentry_list+0x209/0x310 fs/dcache.c:1292
       prune_dcache_sb+0x119/0x180 fs/dcache.c:1374
       super_cache_scan+0x35c/0x4a0 fs/super.c:223
       do_shrink_slab+0x6d0/0x10e0 mm/shrinker.c:443
       shrink_slab_memcg mm/shrinker.c:560 [inline]
       shrink_slab+0x838/0x1220 mm/shrinker.c:638
       shrink_one+0x2a2/0x730 mm/vmscan.c:5026
       shrink_many mm/vmscan.c:5087 [inline]
       lru_gen_shrink_node mm/vmscan.c:5165 [inline]
       shrink_node+0x3303/0x3b60 mm/vmscan.c:6154
       kswapd_shrink_node mm/vmscan.c:7008 [inline]
       balance_pgdat mm/vmscan.c:7186 [inline]
       kswapd+0x17b6/0x31c0 mm/vmscan.c:7462
       kthread+0x388/0x470 kernel/kthread.c:436
       ret_from_fork+0x514/0xb70 arch/x86/kernel/process.c:158
       ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245

-> #1 (fs_reclaim){+.+.}-{0:0}:
       __fs_reclaim_acquire mm/page_alloc.c:4329 [inline]
       fs_reclaim_acquire+0x71/0x100 mm/page_alloc.c:4343
       might_alloc include/linux/sched/mm.h:317 [inline]
       slab_pre_alloc_hook mm/slub.c:4565 [inline]
       slab_alloc_node mm/slub.c:4925 [inline]
       __kmalloc_cache_noprof+0x61/0x660 mm/slub.c:5511
       _kmalloc_noprof include/linux/slab.h:969 [inline]
       _kzalloc_noprof include/linux/slab.h:1290 [inline]
       ocfs2_reserve_new_metadata_blocks+0x10c/0x9a0 fs/ocfs2/suballoc.c:1084
       ocfs2_mknod+0x10e1/0x2240 fs/ocfs2/namei.c:351
       ocfs2_mkdir+0x181/0x460 fs/ocfs2/namei.c:660
       vfs_mkdir+0x406/0x620 fs/namei.c:5276
       filename_mkdirat+0x285/0x510 fs/namei.c:5309
       __do_sys_mkdirat fs/namei.c:5330 [inline]
       __se_sys_mkdirat+0x35/0x150 fs/namei.c:5327
       do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
       do_syscall_64+0x174/0x580 arch/x86/entry/syscall_64.c:94
       entry_SYSCALL_64_after_hwframe+0x77/0x7f

-> #0 (&ocfs2_sysfile_lock_key[INODE_ALLOC_SYSTEM_INODE]){+.+.}-{4:4}:
       check_prev_add kernel/locking/lockdep.c:3165 [inline]
       check_prevs_add kernel/locking/lockdep.c:3284 [inline]
       validate_chain kernel/locking/lockdep.c:3908 [inline]
       __lock_acquire+0x1520/0x2cf0 kernel/locking/lockdep.c:5237
       lock_acquire+0x106/0x350 kernel/locking/lockdep.c:5868
       down_write+0x96/0x200 kernel/locking/rwsem.c:1631
       inode_lock include/linux/fs.h:1024 [inline]
       ocfs2_remove_inode fs/ocfs2/inode.c:767 [inline]
       ocfs2_wipe_inode fs/ocfs2/inode.c:930 [inline]
       ocfs2_delete_inode fs/ocfs2/inode.c:1191 [inline]
       ocfs2_evict_inode+0x1489/0x4390 fs/ocfs2/inode.c:1333
       evict+0x624/0xb50 fs/inode.c:825
       ocfs2_dentry_iput+0x24d/0x390 fs/ocfs2/dcache.c:407
       dentry_kill+0x1b9/0x880 fs/dcache.c:826
       shrink_kill fs/dcache.c:1275 [inline]
       shrink_dentry_list+0x209/0x310 fs/dcache.c:1292
       prune_dcache_sb+0x119/0x180 fs/dcache.c:1374
       super_cache_scan+0x35c/0x4a0 fs/super.c:223
       do_shrink_slab+0x6d0/0x10e0 mm/shrinker.c:443
       shrink_slab_memcg mm/shrinker.c:560 [inline]
       shrink_slab+0x838/0x1220 mm/shrinker.c:638
       shrink_one+0x2a2/0x730 mm/vmscan.c:5026
       shrink_many mm/vmscan.c:5087 [inline]
       lru_gen_shrink_node mm/vmscan.c:5165 [inline]
       shrink_node+0x3303/0x3b60 mm/vmscan.c:6154
       kswapd_shrink_node mm/vmscan.c:7008 [inline]
       balance_pgdat mm/vmscan.c:7186 [inline]
       kswapd+0x17b6/0x31c0 mm/vmscan.c:7462
       kthread+0x388/0x470 kernel/kthread.c:436
       ret_from_fork+0x514/0xb70 arch/x86/kernel/process.c:158
       ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245

other info that might help us debug this:

Chain exists of:
  &ocfs2_sysfile_lock_key[INODE_ALLOC_SYSTEM_INODE] --> &osb->nfs_sync_rwlock --> &ocfs2_sysfile_lock_key[ORPHAN_DIR_SYSTEM_INODE]

 Possible unsafe locking scenario:

       CPU0                    CPU1
       ----                    ----
  lock(&ocfs2_sysfile_lock_key[ORPHAN_DIR_SYSTEM_INODE]);
                               lock(&osb->nfs_sync_rwlock);
                               lock(&ocfs2_sysfile_lock_key[ORPHAN_DIR_SYSTEM_INODE]);
  lock(&ocfs2_sysfile_lock_key[INODE_ALLOC_SYSTEM_INODE]);

 *** DEADLOCK ***

4 locks held by kswapd0/70:
 #0: ffffffff8ec86cc0 (fs_reclaim){+.+.}-{0:0}, at: balance_pgdat mm/vmscan.c:7084 [inline]
 #0: ffffffff8ec86cc0 (fs_reclaim){+.+.}-{0:0}, at: kswapd+0x9b6/0x31c0 mm/vmscan.c:7462
 #1: ffff88803236c0d8 (&type->s_umount_key#53){.+.+}-{4:4}, at: super_trylock_shared fs/super.c:566 [inline]
 #1: ffff88803236c0d8 (&type->s_umount_key#53){.+.+}-{4:4}, at: super_cache_scan+0x91/0x4a0 fs/super.c:198
 #2: ffff888012bb4bc0 (&osb->nfs_sync_rwlock){.+.+}-{4:4}, at: ocfs2_nfs_sync_lock+0x106/0x270 fs/ocfs2/dlmglue.c:2875
 #3: ffff8880444633a0 (&ocfs2_sysfile_lock_key[ORPHAN_DIR_SYSTEM_INODE]){+.+.}-{4:4}, at: inode_lock include/linux/fs.h:1024 [inline]
 #3: ffff8880444633a0 (&ocfs2_sysfile_lock_key[ORPHAN_DIR_SYSTEM_INODE]){+.+.}-{4:4}, at: ocfs2_wipe_inode fs/ocfs2/inode.c:888 [inline]
 #3: ffff8880444633a0 (&ocfs2_sysfile_lock_key[ORPHAN_DIR_SYSTEM_INODE]){+.+.}-{4:4}, at: ocfs2_delete_inode fs/ocfs2/inode.c:1191 [inline]
 #3: ffff8880444633a0 (&ocfs2_sysfile_lock_key[ORPHAN_DIR_SYSTEM_INODE]){+.+.}-{4:4}, at: ocfs2_evict_inode+0xe39/0x4390 fs/ocfs2/inode.c:1333

stack backtrace:
CPU: 0 UID: 0 PID: 70 Comm: kswapd0 Not tainted syzkaller #0 PREEMPT(full) 
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
 inode_lock include/linux/fs.h:1024 [inline]
 ocfs2_remove_inode fs/ocfs2/inode.c:767 [inline]
 ocfs2_wipe_inode fs/ocfs2/inode.c:930 [inline]
 ocfs2_delete_inode fs/ocfs2/inode.c:1191 [inline]
 ocfs2_evict_inode+0x1489/0x4390 fs/ocfs2/inode.c:1333
 evict+0x624/0xb50 fs/inode.c:825
 ocfs2_dentry_iput+0x24d/0x390 fs/ocfs2/dcache.c:407
 dentry_kill+0x1b9/0x880 fs/dcache.c:826
 shrink_kill fs/dcache.c:1275 [inline]
 shrink_dentry_list+0x209/0x310 fs/dcache.c:1292
 prune_dcache_sb+0x119/0x180 fs/dcache.c:1374
 super_cache_scan+0x35c/0x4a0 fs/super.c:223
 do_shrink_slab+0x6d0/0x10e0 mm/shrinker.c:443
 shrink_slab_memcg mm/shrinker.c:560 [inline]
 shrink_slab+0x838/0x1220 mm/shrinker.c:638
 shrink_one+0x2a2/0x730 mm/vmscan.c:5026
 shrink_many mm/vmscan.c:5087 [inline]
 lru_gen_shrink_node mm/vmscan.c:5165 [inline]
 shrink_node+0x3303/0x3b60 mm/vmscan.c:6154
 kswapd_shrink_node mm/vmscan.c:7008 [inline]
 balance_pgdat mm/vmscan.c:7186 [inline]
 kswapd+0x17b6/0x31c0 mm/vmscan.c:7462
 kthread+0x388/0x470 kernel/kthread.c:436
 ret_from_fork+0x514/0xb70 arch/x86/kernel/process.c:158
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
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
