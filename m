Received: from mail-oo2-f11.google.com (mail-oo2-f11.google.com [74.125.231.139])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6791D1F30BB
	for <ocfs2-devel@lists.linux.dev>; Sat, 19 Sep 2026 15:58:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.231.139
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789833511; cv=none; b=qrcoLZwLoMhfyv8C0eTHVWaGybb3lAXdOQWRECmohS7tNyq/wauxSB75FTmQoDHvCEjXAP54RMMWbeRfZNorYCRPtZaQ+fBi7RAS6lLGpkEqTGQfur2WdmSWeyfrcFsrJIDswhz/2YBfkNnCYqXJJjb+81REx9QGs+mWcnHxjdo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789833511; c=relaxed/simple;
	bh=yovsU51vjkoZMx1hq4SJONBpy+r/mkAWfP48yuFB7Ks=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=kjCf/6BoWvligjRuTeyPtSiJNbGxW16PfD/xHcRngkToPeDonyc3Yn6RLggdIfwaAPpSuQsE8jYHCFp2Dezq5gxdxGQwNkewPDJEkcJbDADox8TGR7TkMpiDW5TdjFIjPRULnLdKoBLHn+yFMwP7UIxdv2EDhfCM2hN7vCNmFhs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=74.125.231.139
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oo2-f11.google.com with SMTP id 006d021491bc7-6aaf6076546so946459eaf.1
        for <ocfs2-devel@lists.linux.dev>; Sat, 19 Sep 2026 08:58:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789833508; x=1790438308;
        h=content-type:to:from:subject:message-id:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=GXJsyqh43xC3K8WUE3/+Do/lplJCqQ+WF/KMqy1gCy8=;
        b=TJ3lLPok68iOTP2Rp8BDhh4MHwVfvHV8ZX0B9AVi8W2DaswC4tOD/TpW5/OzZ1+JGo
         1rCO9xDsEV0U2k9geROik3r4f5zHePflaLFhLtvnIOaKMyYyB4Ae1U9RBVibJmoLDb3a
         8TvnKjOrX2deuy1y8x8Sf5YtYCBuMJmHnTOcMkH/Dc8YsvdWshtq6a/duSXxhmV9IUIr
         JgMXIquXrrwOr5HEEgqiq+JOfV68GwSzDBHHCoev4L+mpED2o98/dmyH0PQNQ/l1Wq9I
         QXB6Xkr4H0M3clgKXId5jdzrg7mH1X1LG0ZEgMb7JcrdIzyoDYfJHdPZmP9yc4uJgN+l
         Z+LA==
X-Forwarded-Encrypted: i=1; AKwUvBxB9oZQYnIZ5MHICtcLEWtPo53y5r7CxIlueXbncU2fF7YLab5g145/slF4VwwKdxDy4I5Myx8h/28+9w==@lists.linux.dev
X-Gm-Message-State: AFuF++lTyUGHyeSfo/02fG/pRvY7zmI2jmM9n9L2Jsv+aXbt4rr9ReEY
	elsQoWGTYCahfG+wyHidQNAbT8BU7JOD+OFv8mELnIftXIHehB7r92RTcfjxlxdpSUxt09B7XOi
	NNIEliZR0ThX2u56dngshnXXn5yowZxQK67sZr4fc6owSyy5aumAoPAfQBxM=
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6820:208d:b0:6cd:3ffc:e328 with SMTP id
 006d021491bc7-6cd3ffcea32mr2568408eaf.70.1789833508290; Sat, 19 Sep 2026
 08:58:28 -0700 (PDT)
Date: Sat, 19 Sep 2026 08:58:28 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6aaeb124.71f81b7d.15fa6d.000b.GAE@google.com>
Subject: [syzbot] [ocfs2?] possible deadlock in ocfs2_nfs_sync_lock (3)
From: syzbot <syzbot+a68ce48df87b8e36e915@syzkaller.appspotmail.com>
To: jlbec@evilplan.org, joseph.qi@linux.alibaba.com, 
	linux-kernel@vger.kernel.org, mark@fasheh.com, ocfs2-devel@lists.linux.dev, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    587858367581 Merge tag 'nfsd-7.3-1' of git://git.kernel.or..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=13496501580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=e909ffe6b35dddb7
dashboard link: https://syzkaller.appspot.com/bug?extid=a68ce48df87b8e36e915
compiler:       Debian clang version 22.1.8 (++20260613092233+e80beda6e255-1~exp1~20260613092250.77), Debian LLD 22.1.8

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/d900f083ada3/non_bootable_disk-58785836.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/0d7169e6099c/vmlinux-58785836.xz
kernel image: https://storage.googleapis.com/syzbot-assets/ced6ee748d49/bzImage-58785836.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+a68ce48df87b8e36e915@syzkaller.appspotmail.com


======================================================
WARNING: possible circular locking dependency detected
syzkaller #0 Not tainted
------------------------------------------------------
kswapd0/70 is trying to acquire lock:
ffff88800e994bc0 (&osb->nfs_sync_rwlock){.+.+}-{4:4}, at: ocfs2_nfs_sync_lock+0x106/0x270 fs/ocfs2/dlmglue.c:2875

but task is already holding lock:
ffffffff8ee92540 (fs_reclaim){+.+.}-{0:0}, at: balance_pgdat mm/vmscan.c:7177 [inline]
ffffffff8ee92540 (fs_reclaim){+.+.}-{0:0}, at: kswapd+0xa08/0x32c0 mm/vmscan.c:7555

which lock already depends on the new lock.


the existing dependency chain (in reverse order) is:

-> #3 (fs_reclaim){+.+.}-{0:0}:
       __fs_reclaim_acquire mm/page_alloc.c:4375 [inline]
       fs_reclaim_acquire+0x71/0x100 mm/page_alloc.c:4389
       might_alloc include/linux/sched/mm.h:316 [inline]
       slab_pre_alloc_hook mm/slub.c:4636 [inline]
       slab_alloc_node mm/slub.c:4974 [inline]
       __kmalloc_cache_noprof+0x61/0x600 mm/slub.c:5559
       _kmalloc_noprof include/linux/slab.h:991 [inline]
       _kzalloc_noprof include/linux/slab.h:1312 [inline]
       ocfs2_reserve_new_metadata_blocks+0x10c/0x9a0 fs/ocfs2/suballoc.c:1084
       ocfs2_mknod+0xee4/0x22b0 fs/ocfs2/namei.c:356
       ocfs2_mkdir+0x180/0x430 fs/ocfs2/namei.c:667
       vfs_mkdir+0x40c/0x620 fs/namei.c:5410
       filename_mkdirat+0x285/0x510 fs/namei.c:5443
       __do_sys_mkdirat fs/namei.c:5464 [inline]
       __se_sys_mkdirat+0x35/0x150 fs/namei.c:5461
       do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
       do_syscall_64+0x166/0x520 arch/x86/entry/syscall_64.c:84
       entry_SYSCALL_64_after_hwframe+0x77/0x7f

-> #2 (&ocfs2_sysfile_lock_key[INODE_ALLOC_SYSTEM_INODE]){+.+.}-{4:4}:
       down_write+0x96/0x200 kernel/locking/rwsem.c:1631
       inode_lock include/linux/fs.h:1024 [inline]
       ocfs2_remove_inode fs/ocfs2/inode.c:767 [inline]
       ocfs2_wipe_inode fs/ocfs2/inode.c:930 [inline]
       ocfs2_delete_inode fs/ocfs2/inode.c:1191 [inline]
       ocfs2_evict_inode+0x1489/0x4390 fs/ocfs2/inode.c:1333
       evict+0x624/0xb50 fs/inode.c:822
       ocfs2_dentry_iput+0x24d/0x390 fs/ocfs2/dcache.c:407
       dentry_kill+0x1b9/0x880 fs/dcache.c:826
       finish_dput+0x1a/0x260 fs/dcache.c:1001
       ovl_check_rename_whiteout fs/overlayfs/super.c:617 [inline]
       ovl_make_workdir fs/overlayfs/super.c:713 [inline]
       ovl_get_workdir+0xba2/0x1980 fs/overlayfs/super.c:836
       ovl_fill_super_creds fs/overlayfs/super.c:1449 [inline]
       ovl_fill_super+0x1702/0x4360 fs/overlayfs/super.c:1561
       vfs_get_super fs/super.c:1391 [inline]
       get_tree_nodev+0xbb/0x150 fs/super.c:1410
       vfs_get_tree+0x92/0x2a0 fs/super.c:1933
       fc_mount fs/namespace.c:1198 [inline]
       do_new_mount_fc fs/namespace.c:3772 [inline]
       do_new_mount+0x319/0xdc0 fs/namespace.c:3848
       do_mount fs/namespace.c:4181 [inline]
       __do_sys_mount fs/namespace.c:4397 [inline]
       __se_sys_mount+0x31d/0x420 fs/namespace.c:4374
       do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
       do_syscall_64+0x166/0x520 arch/x86/entry/syscall_64.c:84
       entry_SYSCALL_64_after_hwframe+0x77/0x7f

-> #1 (&ocfs2_sysfile_lock_key[ORPHAN_DIR_SYSTEM_INODE]){+.+.}-{4:4}:
       down_write+0x96/0x200 kernel/locking/rwsem.c:1631
       inode_lock include/linux/fs.h:1024 [inline]
       ocfs2_wipe_inode fs/ocfs2/inode.c:888 [inline]
       ocfs2_delete_inode fs/ocfs2/inode.c:1191 [inline]
       ocfs2_evict_inode+0xe39/0x4390 fs/ocfs2/inode.c:1333
       evict+0x624/0xb50 fs/inode.c:822
       ocfs2_dentry_iput+0x24d/0x390 fs/ocfs2/dcache.c:407
       dentry_kill+0x1b9/0x880 fs/dcache.c:826
       finish_dput+0x1a/0x260 fs/dcache.c:1001
       ovl_check_rename_whiteout fs/overlayfs/super.c:617 [inline]
       ovl_make_workdir fs/overlayfs/super.c:713 [inline]
       ovl_get_workdir+0xba2/0x1980 fs/overlayfs/super.c:836
       ovl_fill_super_creds fs/overlayfs/super.c:1449 [inline]
       ovl_fill_super+0x1702/0x4360 fs/overlayfs/super.c:1561
       vfs_get_super fs/super.c:1391 [inline]
       get_tree_nodev+0xbb/0x150 fs/super.c:1410
       vfs_get_tree+0x92/0x2a0 fs/super.c:1933
       fc_mount fs/namespace.c:1198 [inline]
       do_new_mount_fc fs/namespace.c:3772 [inline]
       do_new_mount+0x319/0xdc0 fs/namespace.c:3848
       do_mount fs/namespace.c:4181 [inline]
       __do_sys_mount fs/namespace.c:4397 [inline]
       __se_sys_mount+0x31d/0x420 fs/namespace.c:4374
       do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
       do_syscall_64+0x166/0x520 arch/x86/entry/syscall_64.c:84
       entry_SYSCALL_64_after_hwframe+0x77/0x7f

-> #0 (&osb->nfs_sync_rwlock){.+.+}-{4:4}:
       check_prev_add kernel/locking/lockdep.c:3209 [inline]
       check_prevs_add kernel/locking/lockdep.c:3328 [inline]
       validate_chain kernel/locking/lockdep.c:3952 [inline]
       __lock_acquire+0x164c/0x2de0 kernel/locking/lockdep.c:5288
       lock_acquire+0x115/0x350 kernel/locking/lockdep.c:5942
       down_read+0x4a/0x330 kernel/locking/rwsem.c:1574
       ocfs2_nfs_sync_lock+0x106/0x270 fs/ocfs2/dlmglue.c:2875
       ocfs2_delete_inode fs/ocfs2/inode.c:1142 [inline]
       ocfs2_evict_inode+0x3a6/0x4390 fs/ocfs2/inode.c:1333
       evict+0x624/0xb50 fs/inode.c:822
       ocfs2_dentry_iput+0x24d/0x390 fs/ocfs2/dcache.c:407
       dentry_kill+0x1b9/0x880 fs/dcache.c:826
       shrink_kill fs/dcache.c:1275 [inline]
       shrink_dentry_list+0x209/0x310 fs/dcache.c:1292
       prune_dcache_sb+0x119/0x180 fs/dcache.c:1374
       super_cache_scan+0x35f/0x4a0 fs/super.c:225
       do_shrink_slab+0x6d0/0x10e0 mm/shrinker.c:445
       shrink_slab_memcg mm/shrinker.c:562 [inline]
       shrink_slab+0x838/0x1220 mm/shrinker.c:640
       shrink_one+0x2a2/0x730 mm/vmscan.c:5119
       shrink_many mm/vmscan.c:5180 [inline]
       lru_gen_shrink_node mm/vmscan.c:5258 [inline]
       shrink_node+0x35d0/0x3e30 mm/vmscan.c:6247
       kswapd_shrink_node mm/vmscan.c:7101 [inline]
       balance_pgdat mm/vmscan.c:7279 [inline]
       kswapd+0x185e/0x32c0 mm/vmscan.c:7555
       kthread+0x38b/0x480 kernel/kthread.c:436
       ret_from_fork+0x514/0xb70 arch/x86/kernel/process.c:158
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

locks held by kswapd0/70: 2, last CPU#0:
 #0: ffffffff8ee92540 (fs_reclaim){+.+.}-{0:0}, at: balance_pgdat mm/vmscan.c:7177 [inline]
 #0: ffffffff8ee92540 (fs_reclaim){+.+.}-{0:0}, at: kswapd+0xa08/0x32c0 mm/vmscan.c:7555
 #1: ffff888012c380e8 (&type->s_umount_key#55){.+.+}-{4:4}, at: super_trylock_shared fs/super.c:674 [inline]
 #1: ffff888012c380e8 (&type->s_umount_key#55){.+.+}-{4:4}, at: super_cache_scan+0x94/0x4a0 fs/super.c:200

stack backtrace:
CPU: 0 UID: 0 PID: 70 Comm: kswapd0 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
Call Trace:
 <TASK>
 dump_stack_lvl+0xe8/0x150 lib/dump_stack.c:120
 print_circular_bug+0x2e2/0x300 kernel/locking/lockdep.c:2087
 check_noncircular+0x12f/0x150 kernel/locking/lockdep.c:2219
 check_prev_add kernel/locking/lockdep.c:3209 [inline]
 check_prevs_add kernel/locking/lockdep.c:3328 [inline]
 validate_chain kernel/locking/lockdep.c:3952 [inline]
 __lock_acquire+0x164c/0x2de0 kernel/locking/lockdep.c:5288
 lock_acquire+0x115/0x350 kernel/locking/lockdep.c:5942
 down_read+0x4a/0x330 kernel/locking/rwsem.c:1574
 ocfs2_nfs_sync_lock+0x106/0x270 fs/ocfs2/dlmglue.c:2875
 ocfs2_delete_inode fs/ocfs2/inode.c:1142 [inline]
 ocfs2_evict_inode+0x3a6/0x4390 fs/ocfs2/inode.c:1333
 evict+0x624/0xb50 fs/inode.c:822
 ocfs2_dentry_iput+0x24d/0x390 fs/ocfs2/dcache.c:407
 dentry_kill+0x1b9/0x880 fs/dcache.c:826
 shrink_kill fs/dcache.c:1275 [inline]
 shrink_dentry_list+0x209/0x310 fs/dcache.c:1292
 prune_dcache_sb+0x119/0x180 fs/dcache.c:1374
 super_cache_scan+0x35f/0x4a0 fs/super.c:225
 do_shrink_slab+0x6d0/0x10e0 mm/shrinker.c:445
 shrink_slab_memcg mm/shrinker.c:562 [inline]
 shrink_slab+0x838/0x1220 mm/shrinker.c:640
 shrink_one+0x2a2/0x730 mm/vmscan.c:5119
 shrink_many mm/vmscan.c:5180 [inline]
 lru_gen_shrink_node mm/vmscan.c:5258 [inline]
 shrink_node+0x35d0/0x3e30 mm/vmscan.c:6247
 kswapd_shrink_node mm/vmscan.c:7101 [inline]
 balance_pgdat mm/vmscan.c:7279 [inline]
 kswapd+0x185e/0x32c0 mm/vmscan.c:7555
 kthread+0x38b/0x480 kernel/kthread.c:436
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
