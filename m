Received: from mail-io1-f77.google.com (mail-io1-f77.google.com [209.85.166.77])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 437F526D4F8
	for <ocfs2-devel@lists.linux.dev>; Wed,  8 Oct 2025 19:52:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.77
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759953153; cv=none; b=BkyWtYymyabY+BLSMoJcBZ5O6BuKllUpWDOw6eOODw4f0WggB5t0wVg6YoDWuxwkzkE6A1HVHriaxHun3IIQXgNv2kKUd1d9zXLFgvVqoZorSUBFHtPy8pdgvuNKDXZhlC4RNP6j982t/9d2v/RjDn0LwfmYGZvMQaMbnFMQsno=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759953153; c=relaxed/simple;
	bh=3qvhve7Rso2XU2XgoExBwYUUKw6NRkuDdIdAxjxD/nA=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=BsG+RwZEJG5EyVo7gjAcxOyhxWf9eS+3L2vRDaySBd5ztTGme5czDbvhQ6HXaxdZwgd8EwFoC0nVzp5h/1Ppb9Y4XeYq63v9j9xyzo7vQSGofoFcpN2P0rOfepcKT69JwITd+6oGn7F/UtmS0Y+q2ZUUq78EYYrV+Y0wPJgaf7k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.77
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-io1-f77.google.com with SMTP id ca18e2360f4ac-8870219dce3so36270139f.0
        for <ocfs2-devel@lists.linux.dev>; Wed, 08 Oct 2025 12:52:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759953150; x=1760557950;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=8f8h9X2xHHXFOQHQkm3eM+Ir5Rg89jA1iRVzsZRgPdc=;
        b=auRWeKgjs/M2dkXFjlOmTJv041tjH5ft8U6drv2MfdBIy274+rWp696rkhIOJ92I7F
         1xRuEXWAJyNQ+1Kvyh+kpYPBC/OOyoJB9WsG1l05/y5HuoVFilzMGmg45BGoW9+uWdTW
         Xl6a6NJIOX2HCbdAKKFp4T/Y/Y07F4WFocUERzPcSExgd8CQ2zPhi0INUxEEyf/HkGC6
         Cyflj0K7IAGYzOh1WwY7OdoEcCq0FjMT/oS0YezEktjlPrmwSxeFsK478HUJa79YEu9C
         JaPairZfiO9iv6wQ1s6SZC1VcejPfapXivNCU9Ezd8C6PDgN6rtbXEAd+xagqiSW7FaG
         9EnQ==
X-Forwarded-Encrypted: i=1; AJvYcCXQ/urcL5qG4DRwU9z1quPUu0VkIoLhZxWszcOS0JsUd1yaAf2ok/Fzx+0GKwP2aPlCnr0vb+/HfKyuEg==@lists.linux.dev
X-Gm-Message-State: AOJu0YynDSfteQ8U2OEwhP4zJowGReuTuvNscX98rJAkB+lm/25gjdhP
	JKlgoMF9P8csHBIwX/ONhxRdWXTWx7+Sw7ieG34CLCuEFpppmRCKvzoA6B5DlmbUXntfEqsV8mX
	KFhwzKikfMk7gM5aA1sL4FOMk4KTN0Aj2/PbQKcpaIE9BGyhco8BAUkFB5Uk=
X-Google-Smtp-Source: AGHT+IHsZxV5nsNonIVmbO0X7KSK4ZaLtZ39CaA3Jtmp7pU6nOO7au7fncFTbX2qGYt8lIzIcCtE99Cnt74hdyiGtqvW5G5eld8u
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6602:6d8b:b0:91a:695a:cb61 with SMTP id
 ca18e2360f4ac-93bd199772emr474759039f.13.1759953150264; Wed, 08 Oct 2025
 12:52:30 -0700 (PDT)
Date: Wed, 08 Oct 2025 12:52:30 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <68e6c0fe.050a0220.256323.00fe.GAE@google.com>
Subject: [syzbot] [ocfs2?] possible deadlock in ocfs2_nfs_sync_lock (2)
From: syzbot <syzbot+961597646899ae06073f@syzkaller.appspotmail.com>
To: jlbec@evilplan.org, joseph.qi@linux.alibaba.com, 
	linux-kernel@vger.kernel.org, mark@fasheh.com, ocfs2-devel@lists.linux.dev, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    cbf33b8e0b36 Merge tag 'bpf-fixes' of git://git.kernel.org..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=177ec458580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=1b4263e12240e6e1
dashboard link: https://syzkaller.appspot.com/bug?extid=961597646899ae06073f
compiler:       Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~exp1~20250708183702.136), Debian LLD 20.1.8

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/d900f083ada3/non_bootable_disk-cbf33b8e.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/54786e46ef23/vmlinux-cbf33b8e.xz
kernel image: https://storage.googleapis.com/syzbot-assets/dd6f88ce083b/bzImage-cbf33b8e.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+961597646899ae06073f@syzkaller.appspotmail.com

======================================================
WARNING: possible circular locking dependency detected
syzkaller #0 Not tainted
------------------------------------------------------
kswapd0/77 is trying to acquire lock:
ffff888032ee4bd0 (&osb->nfs_sync_rwlock){.+.+}-{4:4}, at: ocfs2_nfs_sync_lock+0x106/0x250 fs/ocfs2/dlmglue.c:2875

but task is already holding lock:
ffffffff8de44f40 (fs_reclaim){+.+.}-{0:0}, at: balance_pgdat mm/vmscan.c:7015 [inline]
ffffffff8de44f40 (fs_reclaim){+.+.}-{0:0}, at: kswapd+0x951/0x2800 mm/vmscan.c:7389

which lock already depends on the new lock.


the existing dependency chain (in reverse order) is:

-> #3 (fs_reclaim){+.+.}-{0:0}:
       lock_acquire+0x120/0x360 kernel/locking/lockdep.c:5868
       __fs_reclaim_acquire mm/page_alloc.c:4269 [inline]
       fs_reclaim_acquire+0x72/0x100 mm/page_alloc.c:4283
       might_alloc include/linux/sched/mm.h:318 [inline]
       slab_pre_alloc_hook mm/slub.c:4897 [inline]
       slab_alloc_node mm/slub.c:5221 [inline]
       __kmalloc_cache_noprof+0x40/0x6f0 mm/slub.c:5719
       kmalloc_noprof include/linux/slab.h:957 [inline]
       kzalloc_noprof include/linux/slab.h:1094 [inline]
       ocfs2_reserve_new_metadata_blocks+0x113/0x940 fs/ocfs2/suballoc.c:968
       ocfs2_mknod+0xe08/0x2050 fs/ocfs2/namei.c:350
       ocfs2_mkdir+0x191/0x440 fs/ocfs2/namei.c:659
       vfs_mkdir+0x303/0x510 fs/namei.c:4453
       do_mkdirat+0x247/0x590 fs/namei.c:4486
       __do_sys_mkdirat fs/namei.c:4503 [inline]
       __se_sys_mkdirat fs/namei.c:4501 [inline]
       __x64_sys_mkdirat+0x87/0xa0 fs/namei.c:4501
       do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
       do_syscall_64+0xfa/0x3b0 arch/x86/entry/syscall_64.c:94
       entry_SYSCALL_64_after_hwframe+0x77/0x7f

-> #2 (&ocfs2_sysfile_lock_key[INODE_ALLOC_SYSTEM_INODE]){+.+.}-{4:4}:
       lock_acquire+0x120/0x360 kernel/locking/lockdep.c:5868
       down_write+0x96/0x1f0 kernel/locking/rwsem.c:1590
       inode_lock include/linux/fs.h:979 [inline]
       ocfs2_remove_inode fs/ocfs2/inode.c:731 [inline]
       ocfs2_wipe_inode fs/ocfs2/inode.c:894 [inline]
       ocfs2_delete_inode fs/ocfs2/inode.c:1155 [inline]
       ocfs2_evict_inode+0x153d/0x4100 fs/ocfs2/inode.c:1295
       evict+0x504/0x9c0 fs/inode.c:810
       ocfs2_dentry_iput+0x247/0x370 fs/ocfs2/dcache.c:407
       __dentry_kill+0x209/0x660 fs/dcache.c:669
       dput+0x19f/0x2b0 fs/dcache.c:911
       ovl_check_rename_whiteout fs/overlayfs/super.c:619 [inline]
       ovl_make_workdir fs/overlayfs/super.c:714 [inline]
       ovl_get_workdir+0xac3/0x17b0 fs/overlayfs/super.c:837
       ovl_fill_super+0x154a/0x3da0 fs/overlayfs/super.c:1468
       vfs_get_super fs/super.c:1324 [inline]
       get_tree_nodev+0xb8/0x150 fs/super.c:1343
       vfs_get_tree+0x8f/0x2b0 fs/super.c:1751
       fc_mount fs/namespace.c:1208 [inline]
       do_new_mount_fc fs/namespace.c:3651 [inline]
       do_new_mount+0x302/0xa10 fs/namespace.c:3727
       do_mount fs/namespace.c:4050 [inline]
       __do_sys_mount fs/namespace.c:4238 [inline]
       __se_sys_mount+0x313/0x410 fs/namespace.c:4215
       do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
       do_syscall_64+0xfa/0x3b0 arch/x86/entry/syscall_64.c:94
       entry_SYSCALL_64_after_hwframe+0x77/0x7f

-> #1 (&ocfs2_sysfile_lock_key[ORPHAN_DIR_SYSTEM_INODE]){+.+.}-{4:4}:
       lock_acquire+0x120/0x360 kernel/locking/lockdep.c:5868
       down_write+0x96/0x1f0 kernel/locking/rwsem.c:1590
       inode_lock include/linux/fs.h:979 [inline]
       ocfs2_wipe_inode fs/ocfs2/inode.c:852 [inline]
       ocfs2_delete_inode fs/ocfs2/inode.c:1155 [inline]
       ocfs2_evict_inode+0xf86/0x4100 fs/ocfs2/inode.c:1295
       evict+0x504/0x9c0 fs/inode.c:810
       ocfs2_dentry_iput+0x247/0x370 fs/ocfs2/dcache.c:407
       __dentry_kill+0x209/0x660 fs/dcache.c:669
       dput+0x19f/0x2b0 fs/dcache.c:911
       ovl_check_rename_whiteout fs/overlayfs/super.c:619 [inline]
       ovl_make_workdir fs/overlayfs/super.c:714 [inline]
       ovl_get_workdir+0xac3/0x17b0 fs/overlayfs/super.c:837
       ovl_fill_super+0x154a/0x3da0 fs/overlayfs/super.c:1468
       vfs_get_super fs/super.c:1324 [inline]
       get_tree_nodev+0xb8/0x150 fs/super.c:1343
       vfs_get_tree+0x8f/0x2b0 fs/super.c:1751
       fc_mount fs/namespace.c:1208 [inline]
       do_new_mount_fc fs/namespace.c:3651 [inline]
       do_new_mount+0x302/0xa10 fs/namespace.c:3727
       do_mount fs/namespace.c:4050 [inline]
       __do_sys_mount fs/namespace.c:4238 [inline]
       __se_sys_mount+0x313/0x410 fs/namespace.c:4215
       do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
       do_syscall_64+0xfa/0x3b0 arch/x86/entry/syscall_64.c:94
       entry_SYSCALL_64_after_hwframe+0x77/0x7f

-> #0 (&osb->nfs_sync_rwlock){.+.+}-{4:4}:
       check_prev_add kernel/locking/lockdep.c:3165 [inline]
       check_prevs_add kernel/locking/lockdep.c:3284 [inline]
       validate_chain+0xb9b/0x2140 kernel/locking/lockdep.c:3908
       __lock_acquire+0xab9/0xd20 kernel/locking/lockdep.c:5237
       lock_acquire+0x120/0x360 kernel/locking/lockdep.c:5868
       down_read+0x46/0x2e0 kernel/locking/rwsem.c:1537
       ocfs2_nfs_sync_lock+0x106/0x250 fs/ocfs2/dlmglue.c:2875
       ocfs2_delete_inode fs/ocfs2/inode.c:1106 [inline]
       ocfs2_evict_inode+0x390/0x4100 fs/ocfs2/inode.c:1295
       evict+0x504/0x9c0 fs/inode.c:810
       ocfs2_dentry_iput+0x247/0x370 fs/ocfs2/dcache.c:407
       __dentry_kill+0x209/0x660 fs/dcache.c:669
       shrink_kill+0xa9/0x2c0 fs/dcache.c:1114
       shrink_dentry_list+0x2e0/0x5e0 fs/dcache.c:1141
       prune_dcache_sb+0x10e/0x180 fs/dcache.c:1222
       super_cache_scan+0x369/0x4b0 fs/super.c:222
       do_shrink_slab+0x6ef/0x1110 mm/shrinker.c:437
       shrink_slab_memcg mm/shrinker.c:550 [inline]
       shrink_slab+0x7ef/0x10d0 mm/shrinker.c:628
       shrink_one+0x28a/0x7c0 mm/vmscan.c:4955
       shrink_many mm/vmscan.c:5016 [inline]
       lru_gen_shrink_node mm/vmscan.c:5094 [inline]
       shrink_node+0x315d/0x3780 mm/vmscan.c:6081
       kswapd_shrink_node mm/vmscan.c:6941 [inline]
       balance_pgdat mm/vmscan.c:7124 [inline]
       kswapd+0x147c/0x2800 mm/vmscan.c:7389
       kthread+0x70e/0x8a0 kernel/kthread.c:463
       ret_from_fork+0x436/0x7d0 arch/x86/kernel/process.c:148
       ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245

other info that might help us debug this:

Chain exists of:
  &osb->nfs_sync_rwlock --> &ocfs2_sysfile_lock_key[INODE_ALLOC_SYSTEM_INODE] --> fs_reclaim

 Possible unsafe locking scenario:

       CPU0                    CPU1
       ----                    ----
  lock(fs_reclaim);
                               lock(&ocfs2_sysfile_lock_key[INODE_ALLOC_SYSTEM_INODE]);
                               lock(fs_reclaim);
  rlock(&osb->nfs_sync_rwlock);

 *** DEADLOCK ***

2 locks held by kswapd0/77:
 #0: ffffffff8de44f40 (fs_reclaim){+.+.}-{0:0}, at: balance_pgdat mm/vmscan.c:7015 [inline]
 #0: ffffffff8de44f40 (fs_reclaim){+.+.}-{0:0}, at: kswapd+0x951/0x2800 mm/vmscan.c:7389
 #1: ffff88803b1de0e0 (&type->s_umount_key#51){.+.+}-{4:4}, at: super_trylock_shared fs/super.c:562 [inline]
 #1: ffff88803b1de0e0 (&type->s_umount_key#51){.+.+}-{4:4}, at: super_cache_scan+0x91/0x4b0 fs/super.c:197

stack backtrace:
CPU: 0 UID: 0 PID: 77 Comm: kswapd0 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2~bpo12+1 04/01/2014
Call Trace:
 <TASK>
 dump_stack_lvl+0x189/0x250 lib/dump_stack.c:120
 print_circular_bug+0x2ee/0x310 kernel/locking/lockdep.c:2043
 check_noncircular+0x134/0x160 kernel/locking/lockdep.c:2175
 check_prev_add kernel/locking/lockdep.c:3165 [inline]
 check_prevs_add kernel/locking/lockdep.c:3284 [inline]
 validate_chain+0xb9b/0x2140 kernel/locking/lockdep.c:3908
 __lock_acquire+0xab9/0xd20 kernel/locking/lockdep.c:5237
 lock_acquire+0x120/0x360 kernel/locking/lockdep.c:5868
 down_read+0x46/0x2e0 kernel/locking/rwsem.c:1537
 ocfs2_nfs_sync_lock+0x106/0x250 fs/ocfs2/dlmglue.c:2875
 ocfs2_delete_inode fs/ocfs2/inode.c:1106 [inline]
 ocfs2_evict_inode+0x390/0x4100 fs/ocfs2/inode.c:1295
 evict+0x504/0x9c0 fs/inode.c:810
 ocfs2_dentry_iput+0x247/0x370 fs/ocfs2/dcache.c:407
 __dentry_kill+0x209/0x660 fs/dcache.c:669
 shrink_kill+0xa9/0x2c0 fs/dcache.c:1114
 shrink_dentry_list+0x2e0/0x5e0 fs/dcache.c:1141
 prune_dcache_sb+0x10e/0x180 fs/dcache.c:1222
 super_cache_scan+0x369/0x4b0 fs/super.c:222
 do_shrink_slab+0x6ef/0x1110 mm/shrinker.c:437
 shrink_slab_memcg mm/shrinker.c:550 [inline]
 shrink_slab+0x7ef/0x10d0 mm/shrinker.c:628
 shrink_one+0x28a/0x7c0 mm/vmscan.c:4955
 shrink_many mm/vmscan.c:5016 [inline]
 lru_gen_shrink_node mm/vmscan.c:5094 [inline]
 shrink_node+0x315d/0x3780 mm/vmscan.c:6081
 kswapd_shrink_node mm/vmscan.c:6941 [inline]
 balance_pgdat mm/vmscan.c:7124 [inline]
 kswapd+0x147c/0x2800 mm/vmscan.c:7389
 kthread+0x70e/0x8a0 kernel/kthread.c:463
 ret_from_fork+0x436/0x7d0 arch/x86/kernel/process.c:148
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
