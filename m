Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.167.199
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795191175;
	b=xlBlY86cglNmGsKH2O2+l+rWO9hPreuqrfoMQ7Y7UHcR1Ysn8P8DWynEiv6sZsztvhgB
	 DGf+sAHSuj5klpgiqKtlFKf2Z7zW1keeWWnJzeMZ1wAt3Ott/2+odWgikISVRU5r+VfNq
	 +3cANahYHwVEsk+RTPEynta1srNaR+EhTeAj3WWyQByFaWB/m+FyO1UdIuumeS8Y4rxWv
	 pasIst06gXgA8sAiJq/ktgVCa8SI7P46C8BXi8jCkADUJn7baNPKNYtiJqBnmCF3D39ys
	 msK/VBh6kV5TRngFOG1VjBhFp49c8aFHnAd44oYN+kZDAnzILrDzxKoVPVcjldZb/wQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795191175;
	h=DMARC-Filter:Received:X-Google-DKIM-Signature:X-Forwarded-Encrypted:
	 X-Gm-Message-State:MIME-Version:X-Received:Date:
	 X-Google-Appengine-App-Id:X-Google-Appengine-App-Id-Alias:Message-ID:
	 Subject:From:To:Content-Type;
	bh=jrumD1kdWkfUUrfRaww3ThWCHtCjY3EIqJLPD48r0mA=;
	b=OArIKKup0aXQ/kbVShpYTghJye2JrMdY0NEjQHEVw8y7G6/odN4xDE6g4zN/nXFjqy6h
	 ub7673FfWobrQlOg3BtbNPxL8Vl9YMzHUiVZCtdfgUPbDykIEURrjG7cnrpIv2WdQkT0x
	 ehOLA29k1XEdWnoQrcGTw3LnAIuvzY8cXVivAvBOpdm4F9rDcw7sHwbwmm/0YJ9rfa27N
	 Qa9zACtVmxnB+Ebqu3le1T+2k3L+z++3/lsOBQ1owmhAQEF8NVbbb4ms5s3sf0UIGXGRr
	 KmsI5OaUHPUelm6pWgG1z+NYTjs6FKvCh3mI5thK94UCwbVAMOmZ8ENIZQp4DxL8Tqw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=fail header.from=syzkaller.appspotmail.com;
	spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com;
	arc=none smtp.remote-ip=209.85.167.199
Received: from mail-oi1-f199.google.com (mail-oi1-f199.google.com [209.85.167.199])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47416606A32A
	for <ocfs2-devel@lists.linux.dev>; Fri, 20 Nov 2026 16:12:55 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 47416606A32A
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oi1-f199.google.com with SMTP id 5614622812f47-4eb0b989f0eso1250171b6e.0
        for <ocfs2-devel@lists.linux.dev>; Fri, 20 Nov 2026 08:12:55 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795191174; x=1795795974;
        h=content-type:to:from:subject:message-id:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=jrumD1kdWkfUUrfRaww3ThWCHtCjY3EIqJLPD48r0mA=;
        b=PFWn+pg7cu+5lvExO1QZco3PI/4Ntx6sk6GwlSr1AIcuNXKku97qdoKFekYPAUHy0t
         04QwPYXZRFdSYroc/Eh/d/Q3WwmnNQF0auvt5dp2B5csT+Vc7Lo5+Hn0KUnl43Fq9GI8
         GB0BWOr1yMsbZ58dopytG1cg51sq+IyRfVC4K5I/kNRcui3ikk1G2rn9K3KAOhwnFW85
         iOHpQwpjK0mxujJbpCxAqksv8Racfzhu3uvLcecRocjb9o9fp0TQKRwzizqZQU0sPOoX
         b1vzCAREpqc5xzLFHIS+WGWIDNfepleelfdCEK1f6lpW8vQ/p/JRFS2t404U+7CfX9bB
         eVDg==
X-Forwarded-Encrypted: i=1; AL+hErE4AOClu6IAx/DY4CUWG4HVPU6a7l7aKjCiNl+a+biqqrkzMOJfz3HbKwMn5e3tHGU4k7W5iVc1Ksq1aQ==@lists.linux.dev
X-Gm-Message-State: APuU4Z9cj6dCiksFnzrcp2SjdbI6RF/Hov7OQhe6SYY6yKzld5TQGihV
	Qro8tpZ9vFqod8gh6CeNJr2DUg7mck7ykVWjpyuhK/cXLPz14t2bAYTwjMEs7ygBnSFnYnf0LGf
	2PsH1Ldt6NgqrL67c48sxSyjMiklJgsbSbWd540ChdajUIbXrduEwH33lRMI=
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Post: <mailto:ocfs2-devel@lists.linux.dev>
List-Help: <mailto:ocfs2-devel+help@lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
List-Owner: <mailto:ocfs2-devel+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
X-Received: by 2002:a05:6808:1528:b0:4fb:b543:dc3c with SMTP id
 5614622812f47-579789cf538mr4240122b6e.5.1795191174260; Fri, 20 Nov 2026
 08:12:54 -0800 (PST)
Date: Fri, 20 Nov 2026 08:12:54 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6b007186.91c4c7f9.2424d6.0003.GAE@google.com>
Subject: [syzbot] [ocfs2?] possible deadlock in shrinker_free
From: syzbot <syzbot+38fdbb551940270021f1@syzkaller.appspotmail.com>
To: akpm@linux-foundation.org, heming.zhao@suse.com, jlbec@evilplan.org, 
	joseph.qi@linux.alibaba.com, linux-kernel@vger.kernel.org, mark@fasheh.com, 
	ocfs2-devel@lists.linux.dev, syzkaller-bugs@googlegroups.com, 
	zzzccc427@gmail.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    f1715c0c0460 Merge tag 'for_linus' of git://git.kernel.org..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=17974dea580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=3cc6a7ee2d24d208
dashboard link: https://syzkaller.appspot.com/bug?extid=38fdbb551940270021f1
compiler:       Debian clang version 22.1.8 (1~deb13u4), Debian LLD 22.1.8

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/98fce4d0b21b/non_bootable_disk-f1715c0c.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/74785adb7521/vmlinux-f1715c0c.xz
kernel image: https://storage.googleapis.com/syzbot-assets/5f0383acaa50/bzImage-f1715c0c.xz

The issue was bisected by AI to:

commit f277230d002d03ed98b814b735f9d3d01b42020a
Author: Cen Zhang <zzzccc427@gmail.com>
Date:   Fri Oct 30 04:48:56 2026 +0000

    ocfs2: serialize inode journal access with shutdown

AI reasoning:   https://syzkaller.appspot.com/ai_job?id=0e68af1a-9a2b-4aad-b8ed-125ab8c4ed0a

AI-generated root cause summary:
ocfs2_journal_shutdown() holds down_write(&osb->journal_shutdown_sem) across
jbd2_journal_destroy(), which invokes shrinker_free() and acquires
shrinker_mutex, establishing &osb->journal_shutdown_sem -> shrinker_mutex.
Meanwhile, shrinker_mutex is held across GFP_KERNEL allocations (e.g.,
alloc_shrinker_info()), establishing shrinker_mutex -> fs_reclaim, and memory
reclaim can reach ocfs2_evict_inode() / ocfs2_clear_inode() via
super_cache_scan() and acquire down_read(&osb->journal_shutdown_sem),
establishing fs_reclaim -> &osb->journal_shutdown_sem. Lockdep reports this
3-lock cycle as a circular locking dependency because it does not track the
mutual exclusion provided by sb->s_umount via super_trylock_shared().

full analysis:  https://syzkaller.appspot.com/x/ai_root_cause?x=38fdbb551940270021f1

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+38fdbb551940270021f1@syzkaller.appspotmail.com

The cause commit was identified by AI and may be wrong.
If you agree with it, please also add:
Fixes: f277230d002d ("ocfs2: serialize inode journal access with shutdown")

loop0: detected capacity change from 0 to 32768
(syz.0.0,5351,0):ocfs2_block_check_validate:402 ERROR: CRC32 failed: stored: 0xb3775c19, computed 0x2dd1c265. Applying ECC.
(syz.0.0,5351,0):ocfs2_block_check_validate:402 ERROR: CRC32 failed: stored: 0xb3775c19, computed 0x2dd1c265. Applying ECC.
JBD2: Ignoring recovery information on journal
ocfs2: Mounting device (7,0) on (node local, slot 0) with ordered data mode.
(syz.0.0,5351,0):ocfs2_read_blocks_sync:112 ERROR: status = -12
(syz.0.0,5351,0):update_backups:196 ERROR: status = -12
ocfs2: Failed to update super blocks on 7,0 during fs resize. This condition is not fatal, but fsck.ocfs2 should be run to fix it

======================================================
WARNING: possible circular locking dependency detected
syzkaller #0 Not tainted
------------------------------------------------------
syz.0.0/5351 is trying to acquire lock:
ffffffff90261520 (shrinker_mutex){+.+.}-{4:4}, at: shrinker_free+0xdb/0x3b0 mm/shrinker.c:809

but task is already holding lock:
ffff88804228c2f8 (&osb->journal_shutdown_sem){++++}-{4:4}, at: ocfs2_journal_shutdown+0x4ec/0xb40 fs/ocfs2/journal.c:1122

which lock already depends on the new lock.


the existing dependency chain (in reverse order) is:

-> #2 (&osb->journal_shutdown_sem){++++}-{4:4}:
       down_read+0x45/0x320 kernel/locking/rwsem.c:1574
       ocfs2_clear_inode fs/ocfs2/inode.c:1326 [inline]
       ocfs2_evict_inode+0x2dd8/0x43c0 fs/ocfs2/inode.c:1343
       evict+0x6bf/0xc20 fs/inode.c:829
       ocfs2_dentry_iput+0x24d/0x390 fs/ocfs2/dcache.c:407
       dentry_kill+0x1b9/0x910 fs/dcache.c:857
       shrink_kill fs/dcache.c:1317 [inline]
       shrink_dentry_list+0x209/0x310 fs/dcache.c:1334
       prune_dcache_sb+0x119/0x180 fs/dcache.c:1416
       super_cache_scan+0x362/0x4a0 fs/super.c:225
       do_shrink_slab+0x6d0/0x10d0 mm/shrinker.c:452
       shrink_slab_memcg mm/shrinker.c:569 [inline]
       shrink_slab+0x838/0x1210 mm/shrinker.c:647
       shrink_one+0x396/0x10f0 mm/vmscan.c:5320
       shrink_many mm/vmscan.c:5381 [inline]
       lru_gen_shrink_node mm/vmscan.c:5459 [inline]
       shrink_node+0x631e/0x6c50 mm/vmscan.c:6465
       kswapd_shrink_node mm/vmscan.c:7258 [inline]
       balance_pgdat mm/vmscan.c:7429 [inline]
       kswapd+0x1ff4/0x3a20 mm/vmscan.c:7705
       kthread+0x38b/0x480 kernel/kthread.c:436
       ret_from_fork+0x514/0xb70 arch/x86/kernel/process.c:158
       ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245

-> #1 (fs_reclaim){+.+.}-{0:0}:
       __fs_reclaim_acquire mm/page_alloc.c:4388 [inline]
       fs_reclaim_acquire+0x71/0x100 mm/page_alloc.c:4402
       might_alloc include/linux/sched/mm.h:316 [inline]
       slab_pre_alloc_hook mm/slub.c:4673 [inline]
       slab_alloc_node mm/slub.c:5011 [inline]
       __do_kmalloc_node mm/slub.c:5530 [inline]
       __kvmalloc_node_noprof+0x134/0x820 mm/slub.c:7143
       alloc_shrinker_info+0xe9/0x400 mm/shrinker.c:101
       mem_cgroup_css_online+0x84/0x7b0 mm/memcontrol.c:4396
       online_css+0xbf/0x310 kernel/cgroup/cgroup.c:5903
       css_create kernel/cgroup/cgroup.c:5983 [inline]
       cgroup_apply_control_enable+0x9ed/0xda0 kernel/cgroup/cgroup.c:3474
       cgroup_mkdir+0x1220/0x14b0 kernel/cgroup/cgroup.c:6188
       kernfs_iop_mkdir+0x213/0x360 fs/kernfs/dir.c:1304
       vfs_mkdir+0x411/0x660 fs/namei.c:5428
       filename_mkdirat+0x284/0x550 fs/namei.c:5461
       __do_sys_mkdirat fs/namei.c:5482 [inline]
       __se_sys_mkdirat+0x35/0x150 fs/namei.c:5479
       do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
       do_syscall_64+0x171/0x540 arch/x86/entry/syscall_64.c:89
       entry_SYSCALL_64_after_hwframe+0x77/0x7f

-> #0 (shrinker_mutex){+.+.}-{4:4}:
       check_prev_add kernel/locking/lockdep.c:3209 [inline]
       check_prevs_add kernel/locking/lockdep.c:3328 [inline]
       validate_chain kernel/locking/lockdep.c:3952 [inline]
       __lock_acquire+0x164c/0x2de0 kernel/locking/lockdep.c:5288
       lock_acquire+0x115/0x350 kernel/locking/lockdep.c:5942
       __mutex_lock_common kernel/locking/mutex.c:646 [inline]
       __mutex_lock+0x197/0x15a0 kernel/locking/mutex.c:821
       shrinker_free+0xdb/0x3b0 mm/shrinker.c:809
       jbd2_journal_destroy+0x606/0x7e0 fs/jbd2/journal.c:2178
       ocfs2_journal_shutdown+0x517/0xb40 fs/ocfs2/journal.c:1125
       ocfs2_dismount_volume+0x3c9/0x860 fs/ocfs2/super.c:1874
       generic_shutdown_super+0x140/0x2d0 fs/super.c:723
       kill_block_super+0x44/0xa0 fs/super.c:1852
       deactivate_locked_super+0xbe/0x110 fs/super.c:558
       cleanup_mnt+0x204/0x2a0 fs/namespace.c:1396
       task_work_run+0x1d9/0x260 kernel/task_work.c:233
       exit_task_work include/linux/task_work.h:40 [inline]
       do_exit+0x705/0x2360 kernel/exit.c:980
       do_group_exit+0x22d/0x2f0 kernel/exit.c:1123
       get_signal+0x136a/0x1430 kernel/signal.c:3113
       arch_do_signal_or_restart+0xbb/0x860 arch/x86/kernel/signal.c:337
       __exit_to_user_mode_loop kernel/entry/common.c:66 [inline]
       exit_to_user_mode_loop+0x10e/0x770 kernel/entry/common.c:101
       __exit_to_user_mode_prepare include/linux/irq-entry-common.h:207 [inline]
       syscall_exit_to_user_mode_prepare include/linux/irq-entry-common.h:230 [inline]
       syscall_exit_to_user_mode include/linux/entry-common.h:343 [inline]
       do_syscall_64+0x336/0x540 arch/x86/entry/syscall_64.c:107
       entry_SYSCALL_64_after_hwframe+0x77/0x7f

other info that might help us debug this:

Chain exists of:
  shrinker_mutex --> fs_reclaim --> &osb->journal_shutdown_sem

 Possible unsafe locking scenario:

       CPU0                    CPU1
       ----                    ----
  lock(&osb->journal_shutdown_sem);
                               lock(fs_reclaim);
                               lock(&osb->journal_shutdown_sem);
  lock(shrinker_mutex);

 *** DEADLOCK ***

locks held by syz.0.0/5351: 2, on CPU#0:
 #0: ffff88801342e100 (&type->s_umount_key#53){++++}-{4:4}, at: __super_lock fs/super.c:60 [inline]
 #0: ffff88801342e100 (&type->s_umount_key#53){++++}-{4:4}, at: __super_lock_excl fs/super.c:75 [inline]
 #0: ffff88801342e100 (&type->s_umount_key#53){++++}-{4:4}, at: deactivate_super+0xac/0xe0 fs/super.c:585
 #1: ffff88804228c2f8 (&osb->journal_shutdown_sem){++++}-{4:4}, at: ocfs2_journal_shutdown+0x4ec/0xb40 fs/ocfs2/journal.c:1122

stack backtrace:
CPU: 0 UID: 0 PID: 5351 Comm: syz.0.0 Not tainted syzkaller #0 PREEMPT(full) 
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
 __mutex_lock_common kernel/locking/mutex.c:646 [inline]
 __mutex_lock+0x197/0x15a0 kernel/locking/mutex.c:821
 shrinker_free+0xdb/0x3b0 mm/shrinker.c:809
 jbd2_journal_destroy+0x606/0x7e0 fs/jbd2/journal.c:2178
 ocfs2_journal_shutdown+0x517/0xb40 fs/ocfs2/journal.c:1125
 ocfs2_dismount_volume+0x3c9/0x860 fs/ocfs2/super.c:1874
 generic_shutdown_super+0x140/0x2d0 fs/super.c:723
 kill_block_super+0x44/0xa0 fs/super.c:1852
 deactivate_locked_super+0xbe/0x110 fs/super.c:558
 cleanup_mnt+0x204/0x2a0 fs/namespace.c:1396
 task_work_run+0x1d9/0x260 kernel/task_work.c:233
 exit_task_work include/linux/task_work.h:40 [inline]
 do_exit+0x705/0x2360 kernel/exit.c:980
 do_group_exit+0x22d/0x2f0 kernel/exit.c:1123
 get_signal+0x136a/0x1430 kernel/signal.c:3113
 arch_do_signal_or_restart+0xbb/0x860 arch/x86/kernel/signal.c:337
 __exit_to_user_mode_loop kernel/entry/common.c:66 [inline]
 exit_to_user_mode_loop+0x10e/0x770 kernel/entry/common.c:101
 __exit_to_user_mode_prepare include/linux/irq-entry-common.h:207 [inline]
 syscall_exit_to_user_mode_prepare include/linux/irq-entry-common.h:230 [inline]
 syscall_exit_to_user_mode include/linux/entry-common.h:343 [inline]
 do_syscall_64+0x336/0x540 arch/x86/entry/syscall_64.c:107
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f27f09a9559
Code: Unable to access opcode bytes at 0x7f27f09a952f.
RSP: 002b:00007f27f182a0a8 EFLAGS: 00000246 ORIG_RAX: 00000000000000ca
RAX: fffffffffffffe00 RBX: 00007f27f0c25fa8 RCX: 00007f27f09a9559
RDX: 0000000000000000 RSI: 0000000000000080 RDI: 00007f27f0c25fa8
RBP: 00007f27f0c25fa0 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007f27f0c26038 R14: 00007ffd3e516330 R15: 00007ffd3e516418
 </TASK>
ocfs2: Unmounting device (7,0) on (node local)


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
For information about AI bisection see: https://goo.gl/tpsmEJ#ai-bisection

If the report is already addressed, let syzbot know by replying with:
#syz fix: exact-commit-title

If you want to overwrite report's subsystems, reply with:
#syz set subsystems: new-subsystem
(See the list of subsystem names on the web dashboard)

If the report is a duplicate of another one, reply with:
#syz dup: exact-subject-of-another-report

If you want to undo deduplication, reply with:
#syz undup
