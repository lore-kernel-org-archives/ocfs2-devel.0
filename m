Received: from mail-io1-f70.google.com (mail-io1-f70.google.com [209.85.166.70])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37C4414F12F
	for <ocfs2-devel@lists.linux.dev>; Sun, 18 Aug 2024 23:22:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.70
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724023344; cv=none; b=Jh+ojWwfkfM/8sqRGIM+iZ4ZbJMbZsE5MQ1sgZJaHG74tDCUIjnCmlnImjmgY0PRefJob1I2bR0/eDzu/quaCjMBXP0e5Q/EhDyDVcgNECEMpbxEtxX6cmXdF3CRWjIeppaBrHOvTOWyLCd2BgY14ciCghmUmBhQl/JLt697p9U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724023344; c=relaxed/simple;
	bh=BH2BMr4GHTwNAt3MET8S0hR8r4nrj5DypS0AqXAJ0js=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=fQpULpCCoFHDnyFsqaF1Wm7+tOC2rAjQAPOl6gpVu2D0o+1i80VUXG5/46nPsBUlBLFyOVKcTtK50I2kr2OrnD5F8KppTRP33wUQcpOjwdkepaikKQRPRhhXI0jwJ5BdrGn5kx1xr89Tpt1OLMKVNrqeDMQro/x5/By3LCSck8Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.70
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-io1-f70.google.com with SMTP id ca18e2360f4ac-81f9053ac4dso389854639f.0
        for <ocfs2-devel@lists.linux.dev>; Sun, 18 Aug 2024 16:22:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724023341; x=1724628141;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=cFETBmQxO3AboMC0uEMbJaW2odUMVjwePpXJQCbblJ4=;
        b=PZbZ8G3eo5aEieJvXkZjU0dJCKJIzZcHQTBtx4OqNNoIpFCRnb7wVvK/sEcVCOWyS1
         g++mJZqRmeGAHMhYvbII/brVw4xe+ZgEN6aMNi1TV8BGeenSs0UAeXy2e7c5OgXOM2YY
         jbn3Hrt8EmE7CdegeKORT6DxF+Tk0Y1Dg/ysNZdKW1C2pjwSCfOSKvatedVChtxBWEJ8
         us3V0I7i9NU6Q64mIJ/IpBZLbNw32WTE1LNQZvmGM9WyhGcPOoFa5RJK3hgKGiHt2Jiy
         msZ9aLkNOGFI/Dytk0Jj0Wa+n6ypeGNR1XiFFt9xGTnjb75U+UixGoaBzWdNKpajr5Jb
         aFyw==
X-Forwarded-Encrypted: i=1; AJvYcCUjQ/TCpbmSCE9IN6htNnPw/IgdZTFsSWCAQqmI+WGNPKRZbMg95JZbZp8N9nJ/EF4Q96A41cDarJaL6O/Sf4etQbLNLc4ZG0MLnPc=
X-Gm-Message-State: AOJu0YwS/u/T/lv/tDywq16Yq3YYZg3NXrkhzT46vbie2HF6twsJ/rAq
	YOlULEUh8HPKuE6uh16N1+eN6WCmqLXmsRXAqXZ1esPGKwSQJChUH0ZyAtyKmYwwbmR8wloWaHD
	q+DRnZJr4A0R3EJwlzW6mJmGCXWv3XNfrRA8KIb6qWfp9qARVIsMZ0FI=
X-Google-Smtp-Source: AGHT+IGxEP1urpslxP2JwDwSUMDLDWicgTGmKzsmu9Pq39vz2ZwyPyWLwuA0ErVTSEoGSJGVJn8d2wmFaQixQ9AD2vaZBUSy30Xn
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6602:2cc3:b0:81f:904a:51b1 with SMTP id
 ca18e2360f4ac-8250f4bf8acmr10368039f.1.1724023341305; Sun, 18 Aug 2024
 16:22:21 -0700 (PDT)
Date: Sun, 18 Aug 2024 16:22:21 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000d7e279061ffd7610@google.com>
Subject: [syzbot] [ocfs2?] possible deadlock in ocfs2_evict_inode
From: syzbot <syzbot+b225d4dfce6219600c42@syzkaller.appspotmail.com>
To: jlbec@evilplan.org, joseph.qi@linux.alibaba.com, 
	linux-kernel@vger.kernel.org, mark@fasheh.com, ocfs2-devel@lists.linux.dev, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    d7a5aa4b3c00 Merge tag 'perf-tools-fixes-for-v6.11-2024-08..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=10490ad5980000
kernel config:  https://syzkaller.appspot.com/x/.config?x=7229118d88b4a71b
dashboard link: https://syzkaller.appspot.com/bug?extid=b225d4dfce6219600c42
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/7bc7510fe41f/non_bootable_disk-d7a5aa4b.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/af15738cca6c/vmlinux-d7a5aa4b.xz
kernel image: https://storage.googleapis.com/syzbot-assets/62dacb1384ee/bzImage-d7a5aa4b.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+b225d4dfce6219600c42@syzkaller.appspotmail.com

======================================================
WARNING: possible circular locking dependency detected
6.11.0-rc3-syzkaller-00156-gd7a5aa4b3c00 #0 Not tainted
------------------------------------------------------
kswapd0/78 is trying to acquire lock:
ffff888011f589c0 (&ocfs2_sysfile_lock_key[args->fi_sysfile_type]#2){+.+.}-{3:3}, at: inode_lock include/linux/fs.h:799 [inline]
ffff888011f589c0 (&ocfs2_sysfile_lock_key[args->fi_sysfile_type]#2){+.+.}-{3:3}, at: ocfs2_remove_inode fs/ocfs2/inode.c:655 [inline]
ffff888011f589c0 (&ocfs2_sysfile_lock_key[args->fi_sysfile_type]#2){+.+.}-{3:3}, at: ocfs2_wipe_inode fs/ocfs2/inode.c:818 [inline]
ffff888011f589c0 (&ocfs2_sysfile_lock_key[args->fi_sysfile_type]#2){+.+.}-{3:3}, at: ocfs2_delete_inode fs/ocfs2/inode.c:1079 [inline]
ffff888011f589c0 (&ocfs2_sysfile_lock_key[args->fi_sysfile_type]#2){+.+.}-{3:3}, at: ocfs2_evict_inode+0x209f/0x4680 fs/ocfs2/inode.c:1216

but task is already holding lock:
ffff88803a3f5f40 (&ocfs2_sysfile_lock_key[args->fi_sysfile_type]){+.+.}-{3:3}, at: inode_lock include/linux/fs.h:799 [inline]
ffff88803a3f5f40 (&ocfs2_sysfile_lock_key[args->fi_sysfile_type]){+.+.}-{3:3}, at: ocfs2_wipe_inode fs/ocfs2/inode.c:776 [inline]
ffff88803a3f5f40 (&ocfs2_sysfile_lock_key[args->fi_sysfile_type]){+.+.}-{3:3}, at: ocfs2_delete_inode fs/ocfs2/inode.c:1079 [inline]
ffff88803a3f5f40 (&ocfs2_sysfile_lock_key[args->fi_sysfile_type]){+.+.}-{3:3}, at: ocfs2_evict_inode+0x1b17/0x4680 fs/ocfs2/inode.c:1216

which lock already depends on the new lock.


the existing dependency chain (in reverse order) is:

-> #3 (&ocfs2_sysfile_lock_key[args->fi_sysfile_type]){+.+.}-{3:3}:
       lock_acquire+0x1ed/0x550 kernel/locking/lockdep.c:5759
       down_write+0x99/0x220 kernel/locking/rwsem.c:1579
       inode_lock include/linux/fs.h:799 [inline]
       ocfs2_wipe_inode fs/ocfs2/inode.c:776 [inline]
       ocfs2_delete_inode fs/ocfs2/inode.c:1079 [inline]
       ocfs2_evict_inode+0x1b17/0x4680 fs/ocfs2/inode.c:1216
       evict+0x532/0x950 fs/inode.c:704
       ocfs2_dentry_iput+0x232/0x380 fs/ocfs2/dcache.c:411
       __dentry_kill+0x20d/0x630 fs/dcache.c:610
       shrink_kill+0xa9/0x2c0 fs/dcache.c:1055
       shrink_dentry_list+0x2c0/0x5b0 fs/dcache.c:1082
       prune_dcache_sb+0x10f/0x180 fs/dcache.c:1163
       super_cache_scan+0x34f/0x4b0 fs/super.c:221
       do_shrink_slab+0x701/0x1160 mm/shrinker.c:435
       shrink_slab+0x1093/0x14d0 mm/shrinker.c:662
       shrink_one+0x43b/0x850 mm/vmscan.c:4815
       shrink_many mm/vmscan.c:4876 [inline]
       lru_gen_shrink_node mm/vmscan.c:4954 [inline]
       shrink_node+0x3799/0x3de0 mm/vmscan.c:5934
       kswapd_shrink_node mm/vmscan.c:6762 [inline]
       balance_pgdat mm/vmscan.c:6954 [inline]
       kswapd+0x1bcd/0x35a0 mm/vmscan.c:7223
       kthread+0x2f0/0x390 kernel/kthread.c:389
       ret_from_fork+0x4b/0x80 arch/x86/kernel/process.c:147
       ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:244

-> #2 (&osb->nfs_sync_rwlock){.+.+}-{3:3}:
       lock_acquire+0x1ed/0x550 kernel/locking/lockdep.c:5759
       down_read+0xb1/0xa40 kernel/locking/rwsem.c:1526
       ocfs2_nfs_sync_lock+0x109/0x260 fs/ocfs2/dlmglue.c:2876
       ocfs2_delete_inode fs/ocfs2/inode.c:1030 [inline]
       ocfs2_evict_inode+0x3e5/0x4680 fs/ocfs2/inode.c:1216
       evict+0x532/0x950 fs/inode.c:704
       ocfs2_dentry_iput+0x232/0x380 fs/ocfs2/dcache.c:411
       __dentry_kill+0x20d/0x630 fs/dcache.c:610
       shrink_kill+0xa9/0x2c0 fs/dcache.c:1055
       shrink_dentry_list+0x2c0/0x5b0 fs/dcache.c:1082
       prune_dcache_sb+0x10f/0x180 fs/dcache.c:1163
       super_cache_scan+0x34f/0x4b0 fs/super.c:221
       do_shrink_slab+0x701/0x1160 mm/shrinker.c:435
       shrink_slab+0x1093/0x14d0 mm/shrinker.c:662
       shrink_one+0x43b/0x850 mm/vmscan.c:4815
       shrink_many mm/vmscan.c:4876 [inline]
       lru_gen_shrink_node mm/vmscan.c:4954 [inline]
       shrink_node+0x3799/0x3de0 mm/vmscan.c:5934
       kswapd_shrink_node mm/vmscan.c:6762 [inline]
       balance_pgdat mm/vmscan.c:6954 [inline]
       kswapd+0x1bcd/0x35a0 mm/vmscan.c:7223
       kthread+0x2f0/0x390 kernel/kthread.c:389
       ret_from_fork+0x4b/0x80 arch/x86/kernel/process.c:147
       ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:244

-> #1 (fs_reclaim){+.+.}-{0:0}:
       lock_acquire+0x1ed/0x550 kernel/locking/lockdep.c:5759
       __fs_reclaim_acquire mm/page_alloc.c:3823 [inline]
       fs_reclaim_acquire+0x88/0x140 mm/page_alloc.c:3837
       might_alloc include/linux/sched/mm.h:334 [inline]
       slab_pre_alloc_hook mm/slub.c:3939 [inline]
       slab_alloc_node mm/slub.c:4017 [inline]
       __kmalloc_cache_noprof+0x3d/0x2c0 mm/slub.c:4184
       kmalloc_noprof include/linux/slab.h:681 [inline]
       kzalloc_noprof include/linux/slab.h:807 [inline]
       ocfs2_reserve_new_metadata_blocks+0x117/0x9c0 fs/ocfs2/suballoc.c:966
       ocfs2_mknod+0x143a/0x2b40 fs/ocfs2/namei.c:345
       ocfs2_mkdir+0x1ab/0x480 fs/ocfs2/namei.c:655
       vfs_mkdir+0x2f9/0x4f0 fs/namei.c:4210
       do_mkdirat+0x264/0x3a0 fs/namei.c:4233
       __do_sys_mkdirat fs/namei.c:4248 [inline]
       __se_sys_mkdirat fs/namei.c:4246 [inline]
       __x64_sys_mkdirat+0x87/0xa0 fs/namei.c:4246
       do_syscall_x64 arch/x86/entry/common.c:52 [inline]
       do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
       entry_SYSCALL_64_after_hwframe+0x77/0x7f

-> #0 (&ocfs2_sysfile_lock_key[args->fi_sysfile_type]#2){+.+.}-{3:3}:
       check_prev_add kernel/locking/lockdep.c:3133 [inline]
       check_prevs_add kernel/locking/lockdep.c:3252 [inline]
       validate_chain+0x18e0/0x5900 kernel/locking/lockdep.c:3868
       __lock_acquire+0x137a/0x2040 kernel/locking/lockdep.c:5142
       lock_acquire+0x1ed/0x550 kernel/locking/lockdep.c:5759
       down_write+0x99/0x220 kernel/locking/rwsem.c:1579
       inode_lock include/linux/fs.h:799 [inline]
       ocfs2_remove_inode fs/ocfs2/inode.c:655 [inline]
       ocfs2_wipe_inode fs/ocfs2/inode.c:818 [inline]
       ocfs2_delete_inode fs/ocfs2/inode.c:1079 [inline]
       ocfs2_evict_inode+0x209f/0x4680 fs/ocfs2/inode.c:1216
       evict+0x532/0x950 fs/inode.c:704
       ocfs2_dentry_iput+0x232/0x380 fs/ocfs2/dcache.c:411
       __dentry_kill+0x20d/0x630 fs/dcache.c:610
       shrink_kill+0xa9/0x2c0 fs/dcache.c:1055
       shrink_dentry_list+0x2c0/0x5b0 fs/dcache.c:1082
       prune_dcache_sb+0x10f/0x180 fs/dcache.c:1163
       super_cache_scan+0x34f/0x4b0 fs/super.c:221
       do_shrink_slab+0x701/0x1160 mm/shrinker.c:435
       shrink_slab+0x1093/0x14d0 mm/shrinker.c:662
       shrink_one+0x43b/0x850 mm/vmscan.c:4815
       shrink_many mm/vmscan.c:4876 [inline]
       lru_gen_shrink_node mm/vmscan.c:4954 [inline]
       shrink_node+0x3799/0x3de0 mm/vmscan.c:5934
       kswapd_shrink_node mm/vmscan.c:6762 [inline]
       balance_pgdat mm/vmscan.c:6954 [inline]
       kswapd+0x1bcd/0x35a0 mm/vmscan.c:7223
       kthread+0x2f0/0x390 kernel/kthread.c:389
       ret_from_fork+0x4b/0x80 arch/x86/kernel/process.c:147
       ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:244

other info that might help us debug this:

Chain exists of:
  &ocfs2_sysfile_lock_key[args->fi_sysfile_type]#2 --> &osb->nfs_sync_rwlock --> &ocfs2_sysfile_lock_key[args->fi_sysfile_type]

 Possible unsafe locking scenario:

       CPU0                    CPU1
       ----                    ----
  lock(&ocfs2_sysfile_lock_key[args->fi_sysfile_type]);
                               lock(&osb->nfs_sync_rwlock);
                               lock(&ocfs2_sysfile_lock_key[args->fi_sysfile_type]);
  lock(&ocfs2_sysfile_lock_key[args->fi_sysfile_type]#2);

 *** DEADLOCK ***

4 locks held by kswapd0/78:
 #0: ffffffff8ea2fce0 (fs_reclaim){+.+.}-{0:0}, at: balance_pgdat mm/vmscan.c:6841 [inline]
 #0: ffffffff8ea2fce0 (fs_reclaim){+.+.}-{0:0}, at: kswapd+0xbb4/0x35a0 mm/vmscan.c:7223
 #1: ffff8880460f20e0 (&type->s_umount_key#47){.+.+}-{3:3}, at: super_trylock_shared fs/super.c:562 [inline]
 #1: ffff8880460f20e0 (&type->s_umount_key#47){.+.+}-{3:3}, at: super_cache_scan+0x94/0x4b0 fs/super.c:196
 #2: ffff88803b050bd0 (&osb->nfs_sync_rwlock){.+.+}-{3:3}, at: ocfs2_nfs_sync_lock+0x109/0x260 fs/ocfs2/dlmglue.c:2876
 #3: ffff88803a3f5f40 (&ocfs2_sysfile_lock_key[args->fi_sysfile_type]){+.+.}-{3:3}, at: inode_lock include/linux/fs.h:799 [inline]
 #3: ffff88803a3f5f40 (&ocfs2_sysfile_lock_key[args->fi_sysfile_type]){+.+.}-{3:3}, at: ocfs2_wipe_inode fs/ocfs2/inode.c:776 [inline]
 #3: ffff88803a3f5f40 (&ocfs2_sysfile_lock_key[args->fi_sysfile_type]){+.+.}-{3:3}, at: ocfs2_delete_inode fs/ocfs2/inode.c:1079 [inline]
 #3: ffff88803a3f5f40 (&ocfs2_sysfile_lock_key[args->fi_sysfile_type]){+.+.}-{3:3}, at: ocfs2_evict_inode+0x1b17/0x4680 fs/ocfs2/inode.c:1216

stack backtrace:
CPU: 0 UID: 0 PID: 78 Comm: kswapd0 Not tainted 6.11.0-rc3-syzkaller-00156-gd7a5aa4b3c00 #0
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2~bpo12+1 04/01/2014
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:93 [inline]
 dump_stack_lvl+0x241/0x360 lib/dump_stack.c:119
 check_noncircular+0x36a/0x4a0 kernel/locking/lockdep.c:2186
 check_prev_add kernel/locking/lockdep.c:3133 [inline]
 check_prevs_add kernel/locking/lockdep.c:3252 [inline]
 validate_chain+0x18e0/0x5900 kernel/locking/lockdep.c:3868
 __lock_acquire+0x137a/0x2040 kernel/locking/lockdep.c:5142
 lock_acquire+0x1ed/0x550 kernel/locking/lockdep.c:5759
 down_write+0x99/0x220 kernel/locking/rwsem.c:1579
 inode_lock include/linux/fs.h:799 [inline]
 ocfs2_remove_inode fs/ocfs2/inode.c:655 [inline]
 ocfs2_wipe_inode fs/ocfs2/inode.c:818 [inline]
 ocfs2_delete_inode fs/ocfs2/inode.c:1079 [inline]
 ocfs2_evict_inode+0x209f/0x4680 fs/ocfs2/inode.c:1216
 evict+0x532/0x950 fs/inode.c:704
 ocfs2_dentry_iput+0x232/0x380 fs/ocfs2/dcache.c:411
 __dentry_kill+0x20d/0x630 fs/dcache.c:610
 shrink_kill+0xa9/0x2c0 fs/dcache.c:1055
 shrink_dentry_list+0x2c0/0x5b0 fs/dcache.c:1082
 prune_dcache_sb+0x10f/0x180 fs/dcache.c:1163
 super_cache_scan+0x34f/0x4b0 fs/super.c:221
 do_shrink_slab+0x701/0x1160 mm/shrinker.c:435
 shrink_slab+0x1093/0x14d0 mm/shrinker.c:662
 shrink_one+0x43b/0x850 mm/vmscan.c:4815
 shrink_many mm/vmscan.c:4876 [inline]
 lru_gen_shrink_node mm/vmscan.c:4954 [inline]
 shrink_node+0x3799/0x3de0 mm/vmscan.c:5934
 kswapd_shrink_node mm/vmscan.c:6762 [inline]
 balance_pgdat mm/vmscan.c:6954 [inline]
 kswapd+0x1bcd/0x35a0 mm/vmscan.c:7223
 kthread+0x2f0/0x390 kernel/kthread.c:389
 ret_from_fork+0x4b/0x80 arch/x86/kernel/process.c:147
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:244
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
