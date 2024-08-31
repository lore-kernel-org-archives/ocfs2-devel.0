Received: from mail-il1-f199.google.com (mail-il1-f199.google.com [209.85.166.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CABB165EEB
	for <ocfs2-devel@lists.linux.dev>; Sat, 31 Aug 2024 09:46:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725097583; cv=none; b=WMRzsLKtoOz7qGF82bWiHHwGpK/hYPiRxtiiVgvldUE4gPqL6fLwvdNaDL1qcq8ITEX5RmwXYzpHjrHdfPUIS3cxjOWUiJ0niJSjs4SPaeYOPX85sBA5Ofy+ojUgRILtcBQZlm8PaXsaWXXHahXSvTSm33gyact+dR9F/Uu+wbE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725097583; c=relaxed/simple;
	bh=y+nQ9ckUEpyTXkCBPb96pK9GQiwkBPlLjdgkq1lZz8M=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=Ac7YJIDq7sJg5LaTng5aTVTrG0TvU1u/G4JgFHHcn538pYkLi6WEmmc1a58quH+6Sz6WyVNiqWsmz7P6OguixGXGuDQswnJToWF20i01uNyFGODsG/zTZ7ZONOes8j4V4/olYu71C0tIRwpBLeJcAVQObRYFzkvuVtX+vMuaghY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f199.google.com with SMTP id e9e14a558f8ab-39d4c0fc036so32155575ab.2
        for <ocfs2-devel@lists.linux.dev>; Sat, 31 Aug 2024 02:46:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725097580; x=1725702380;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=hI/G5sYoTAeTbwptilSZT5M3Vb0t/cnOsIYLjYvvkgo=;
        b=vOhk3cHFhq1RPIkDly32OtLGIzUxjotNos2mq1dLm27//cd3rWc3hYSH4o03xicSRL
         FqGi14vzXxOVy1TNpBGSU7qGnR9cX9UoH7GGFLu7+ym5pr9NpHivy3ks0mp4PZnpIFGB
         E0FE4smtVdtH6EEkdGyBXUAEHLd41rRSGvl+JsE+T/2p16ri0M+8tJrp9JYO1btzeZfm
         bsIJmWmHb7fs/EMS1XOi1qin4uCBFiKKi/lTPtjCTKpoH/gaTHmzaso8tt2JoUZkRncu
         n6RuzCshI8KNwU/AstyHAUvUiXnInwXeA1Q/uGPXiB7biMfLFkzmnUDQm7BwYOl8/VLo
         Bzbw==
X-Forwarded-Encrypted: i=1; AJvYcCUOYipjM53GeXzJBA57OdPqjIcY4s9WLtPf4/bTwDeeLK1U1pXLt10nY/uKMWxQIe2vDa/4f1xf1xFAGA==@lists.linux.dev
X-Gm-Message-State: AOJu0Yw1C0ee1jXhLA+Xk84ocIdghxnLORPr/VNTOHANjcotUBvkMjrp
	B1tTzW158g58MjD9X76GQD9xiffAqdrYiB2U/iI+m+JCOArARXoqBWvScdD4DFq/NAnffAr9sr1
	Wwyb3u/Udf6Y0OXFqVfbSbOAx8Ka3Icl9K3COfu+2oaNSDER7LjrlWPw=
X-Google-Smtp-Source: AGHT+IEhDnz7g1NuPCWMKEQbij/3781pHsjQ5jfHlIS4wdd/T/j/L0z0MobyZtv7nwSjNRbZFkIXYIsE4u9mbfYGjOYsRjfk/cfR
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1385:b0:39f:50c7:9749 with SMTP id
 e9e14a558f8ab-39f50c797a0mr584305ab.2.1725097580461; Sat, 31 Aug 2024
 02:46:20 -0700 (PDT)
Date: Sat, 31 Aug 2024 02:46:20 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000007c90b60620f79447@google.com>
Subject: [syzbot] [ocfs2?] possible deadlock in ocfs2_nfs_sync_lock
From: syzbot <syzbot+fcb79916dcfe2a4ed10a@syzkaller.appspotmail.com>
To: jlbec@evilplan.org, joseph.qi@linux.alibaba.com, 
	linux-kernel@vger.kernel.org, mark@fasheh.com, ocfs2-devel@lists.linux.dev, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    a18093afa393 Merge tag 'nfsd-6.11-2' of git://git.kernel.o..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=1360ffa3980000
kernel config:  https://syzkaller.appspot.com/x/.config?x=8605cd35ddc8ff3c
dashboard link: https://syzkaller.appspot.com/bug?extid=fcb79916dcfe2a4ed10a
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=11f51063980000

Downloadable assets:
disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/7bc7510fe41f/non_bootable_disk-a18093af.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/7a0438eadb72/vmlinux-a18093af.xz
kernel image: https://storage.googleapis.com/syzbot-assets/5abb97d0ea06/bzImage-a18093af.xz
mounted in repro: https://storage.googleapis.com/syzbot-assets/0d242ba7af55/mount_0.gz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+fcb79916dcfe2a4ed10a@syzkaller.appspotmail.com

======================================================
WARNING: possible circular locking dependency detected
6.11.0-rc5-syzkaller-00069-ga18093afa393 #0 Not tainted
------------------------------------------------------
kswapd0/79 is trying to acquire lock:
ffff8880526ecbd0 (&osb->nfs_sync_rwlock){.+.+}-{3:3}, at: ocfs2_nfs_sync_lock+0x109/0x260 fs/ocfs2/dlmglue.c:2876

but task is already holding lock:
ffffffff8ea2fd60 (fs_reclaim){+.+.}-{0:0}, at: balance_pgdat mm/vmscan.c:6841 [inline]
ffffffff8ea2fd60 (fs_reclaim){+.+.}-{0:0}, at: kswapd+0xbb4/0x35a0 mm/vmscan.c:7223

which lock already depends on the new lock.


the existing dependency chain (in reverse order) is:

-> #3 (fs_reclaim){+.+.}-{0:0}:
       lock_acquire+0x1ed/0x550 kernel/locking/lockdep.c:5759
       __fs_reclaim_acquire mm/page_alloc.c:3818 [inline]
       fs_reclaim_acquire+0x88/0x140 mm/page_alloc.c:3832
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

-> #2 (&ocfs2_sysfile_lock_key[args->fi_sysfile_type]#2){+.+.}-{3:3}:
       lock_acquire+0x1ed/0x550 kernel/locking/lockdep.c:5759
       down_write+0x99/0x220 kernel/locking/rwsem.c:1579
       inode_lock include/linux/fs.h:800 [inline]
       ocfs2_remove_inode fs/ocfs2/inode.c:655 [inline]
       ocfs2_wipe_inode fs/ocfs2/inode.c:818 [inline]
       ocfs2_delete_inode fs/ocfs2/inode.c:1079 [inline]
       ocfs2_evict_inode+0x209f/0x4680 fs/ocfs2/inode.c:1216
       evict+0x532/0x950 fs/inode.c:704
       ocfs2_dentry_iput+0x232/0x380 fs/ocfs2/dcache.c:411
       __dentry_kill+0x20d/0x630 fs/dcache.c:610
       dput+0x19f/0x2b0 fs/dcache.c:852
       do_renameat2+0xda1/0x13f0 fs/namei.c:5125
       __do_sys_renameat2 fs/namei.c:5157 [inline]
       __se_sys_renameat2 fs/namei.c:5154 [inline]
       __x64_sys_renameat2+0xce/0xe0 fs/namei.c:5154
       do_syscall_x64 arch/x86/entry/common.c:52 [inline]
       do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
       entry_SYSCALL_64_after_hwframe+0x77/0x7f

-> #1 (&ocfs2_sysfile_lock_key[args->fi_sysfile_type]){+.+.}-{3:3}:
       lock_acquire+0x1ed/0x550 kernel/locking/lockdep.c:5759
       down_write+0x99/0x220 kernel/locking/rwsem.c:1579
       inode_lock include/linux/fs.h:800 [inline]
       ocfs2_wipe_inode fs/ocfs2/inode.c:776 [inline]
       ocfs2_delete_inode fs/ocfs2/inode.c:1079 [inline]
       ocfs2_evict_inode+0x1b17/0x4680 fs/ocfs2/inode.c:1216
       evict+0x532/0x950 fs/inode.c:704
       ocfs2_dentry_iput+0x232/0x380 fs/ocfs2/dcache.c:411
       __dentry_kill+0x20d/0x630 fs/dcache.c:610
       dput+0x19f/0x2b0 fs/dcache.c:852
       do_renameat2+0xda1/0x13f0 fs/namei.c:5125
       __do_sys_renameat2 fs/namei.c:5157 [inline]
       __se_sys_renameat2 fs/namei.c:5154 [inline]
       __x64_sys_renameat2+0xce/0xe0 fs/namei.c:5154
       do_syscall_x64 arch/x86/entry/common.c:52 [inline]
       do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
       entry_SYSCALL_64_after_hwframe+0x77/0x7f

-> #0 (&osb->nfs_sync_rwlock){.+.+}-{3:3}:
       check_prev_add kernel/locking/lockdep.c:3133 [inline]
       check_prevs_add kernel/locking/lockdep.c:3252 [inline]
       validate_chain+0x18e0/0x5900 kernel/locking/lockdep.c:3868
       __lock_acquire+0x137a/0x2040 kernel/locking/lockdep.c:5142
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
       shrink_slab_memcg mm/shrinker.c:548 [inline]
       shrink_slab+0x878/0x14d0 mm/shrinker.c:626
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
  &osb->nfs_sync_rwlock --> &ocfs2_sysfile_lock_key[args->fi_sysfile_type]#2 --> fs_reclaim

 Possible unsafe locking scenario:

       CPU0                    CPU1
       ----                    ----
  lock(fs_reclaim);
                               lock(&ocfs2_sysfile_lock_key[args->fi_sysfile_type]#2);
                               lock(fs_reclaim);
  rlock(&osb->nfs_sync_rwlock);

 *** DEADLOCK ***

2 locks held by kswapd0/79:
 #0: ffffffff8ea2fd60 (fs_reclaim){+.+.}-{0:0}, at: balance_pgdat mm/vmscan.c:6841 [inline]
 #0: ffffffff8ea2fd60 (fs_reclaim){+.+.}-{0:0}, at: kswapd+0xbb4/0x35a0 mm/vmscan.c:7223
 #1: ffff8880504be0e0 (&type->s_umount_key#54){++++}-{3:3}, at: super_trylock_shared fs/super.c:562 [inline]
 #1: ffff8880504be0e0 (&type->s_umount_key#54){++++}-{3:3}, at: super_cache_scan+0x94/0x4b0 fs/super.c:196

stack backtrace:
CPU: 0 UID: 0 PID: 79 Comm: kswapd0 Not tainted 6.11.0-rc5-syzkaller-00069-ga18093afa393 #0
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
 shrink_slab_memcg mm/shrinker.c:548 [inline]
 shrink_slab+0x878/0x14d0 mm/shrinker.c:626
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
