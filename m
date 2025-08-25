Received: from mail-il1-f206.google.com (mail-il1-f206.google.com [209.85.166.206])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11356230BFD
	for <ocfs2-devel@lists.linux.dev>; Mon, 25 Aug 2025 08:51:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.206
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756111892; cv=none; b=RzqepXi828dWmdpaoJGpJs38G6j8InpIolqS/MnqppC2EQVL7YFLT9W6uEXNOZEnxM1OIW4AmJ5AtwW1E7T/REWNi3UTKozwcoYPPlUw9HXBI/NakAccIfFVbmY/ihUW7CUS6i+MIlDSaWtdMTL1C/wzapfLPo5B94Uq8J3yZsY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756111892; c=relaxed/simple;
	bh=fKoL1aKCqDMmNY/de54z73Z3h1Xw92YMowOjDkBpZ4g=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=Tb6yjiKGoV74nUXrHPNBQ/hFnEQSBtaPYntSYiNfhFCt8CU3CItywKcaU44R1mHAl3jyp9Pkr/nscphr2LflZLazUkPaf2+SchlGr/aRgg035NasBdWZX2IgnTKUGP6PbG/nootgKzUpq2YBK+KekX2GRZOddCpxJbDBW3PYNHA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.206
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f206.google.com with SMTP id e9e14a558f8ab-3e6670d5bafso113922255ab.2
        for <ocfs2-devel@lists.linux.dev>; Mon, 25 Aug 2025 01:51:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756111890; x=1756716690;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=5A2yWMwuR488XjAUcE0q1TFTCJInu8XSvaIvSdC1/28=;
        b=wfSJjg9En6JKfaretsdIe8toFJGMkh98THas7eeFwsOoAoO+u3TjGDemiGXO8au961
         zZl7e4WrsFtZXxYj8ojyHd56SgQzAnoBr109qQfiOR5kLXW7OrSkeXgqkwK5FJfO3nQK
         2x0IGg0iiTZF1FcmIqtX1zDVJZyLqVUhNQ5gmaaCcsdsAvXBbl39AH3sVeTptX/3tkEV
         ERPiJq8N80/jiUraxet+uQa0EhbgEZI7L3qD/D1FvSrw8/2iFJ5e9wHXb1IVz3w8qLnP
         wuMvmMiv0ssfdJ2PQcxlrqm4rUj3TXZAVHl3OHJJMRougmXoFYXTwP8pgTNF7kPEvH4M
         XkIQ==
X-Forwarded-Encrypted: i=1; AJvYcCWgscTGtNUXa4Q+hHiismDWxW8d7KrJXweinlyKQspbR6Zj4F3jvy2k3FUDiSbO3dt8atG8VJcRr7LapA==@lists.linux.dev
X-Gm-Message-State: AOJu0YyYnwL3CItsyQAp5IbUC86va9zINMszW5mztGt91HGgqGra9xTn
	mjP+CKCmWHKNKN/63LggslbYnX7wKu6LgZa70L9zu6744A2qr1LW8lqH6qe/doFwAi1DcaF9u+/
	uJyGMnv5WuGxjzQpE/6/QbYkIP1jA/tNl77fVpyVD2/mmdiwOA/4dVErFWl4=
X-Google-Smtp-Source: AGHT+IH1/wL56jIsmuANR+PkyoX3Cm1is+eoJtATmNVSaGs6Ldp4+Ti1fRLLyHniMDeHe1MizJYkW+cPY11qaCWn30DtZCir2pET
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:170b:b0:3eb:b030:e6eb with SMTP id
 e9e14a558f8ab-3ebb030e7d0mr71193615ab.0.1756111890166; Mon, 25 Aug 2025
 01:51:30 -0700 (PDT)
Date: Mon, 25 Aug 2025 01:51:30 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <68ac2412.050a0220.37038e.0088.GAE@google.com>
Subject: [syzbot] [ocfs2?] KASAN: use-after-free Read in ocfs2_get_system_file_inode
From: syzbot <syzbot+900962ac9bf1860033f2@syzkaller.appspotmail.com>
To: akpm@linux-foundation.org, heming.zhao@suse.com, jlbec@evilplan.org, 
	joseph.qi@linux.alibaba.com, linux-kernel@vger.kernel.org, mark@fasheh.com, 
	ocfs2-devel@lists.linux.dev, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    8f5ae30d69d7 Linux 6.17-rc1
git tree:       git://git.kernel.org/pub/scm/linux/kernel/git/arm64/linux.git for-kernelci
console output: https://syzkaller.appspot.com/x/log.txt?x=1171aa34580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=8c5ac3d8b8abfcb
dashboard link: https://syzkaller.appspot.com/bug?extid=900962ac9bf1860033f2
compiler:       Debian clang version 20.1.7 (++20250616065708+6146a88f6049-1~exp1~20250616065826.132), Debian LLD 20.1.7
userspace arch: arm64
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=14460ef0580000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=12055062580000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/18a2e4bd0c4a/disk-8f5ae30d.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/3b5395881b25/vmlinux-8f5ae30d.xz
kernel image: https://storage.googleapis.com/syzbot-assets/e875f4e3b7ff/Image-8f5ae30d.gz.xz
mounted in repro: https://storage.googleapis.com/syzbot-assets/b8731c8da9c9/mount_0.gz
  fsck result: OK (log: https://syzkaller.appspot.com/x/fsck.log?x=10460ef0580000)

The issue was bisected to:

commit bd1261b16d9131d79723d982d54295e7f309797a
Author: Heming Zhao <heming.zhao@suse.com>
Date:   Mon Apr 14 06:01:23 2025 +0000

    ocfs2: fix the issue with discontiguous allocation in the global_bitmap

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=11473062580000
final oops:     https://syzkaller.appspot.com/x/report.txt?x=13473062580000
console output: https://syzkaller.appspot.com/x/log.txt?x=15473062580000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+900962ac9bf1860033f2@syzkaller.appspotmail.com
Fixes: bd1261b16d91 ("ocfs2: fix the issue with discontiguous allocation in the global_bitmap")

==================================================================
BUG: KASAN: slab-use-after-free in ocfs2_get_system_file_inode+0x17c/0x650 fs/ocfs2/sysfile.c:102
Read of size 8 at addr ffff0000dea2ae10 by task syz-executor/6666

CPU: 1 UID: 0 PID: 6666 Comm: syz-executor Not tainted 6.17.0-rc1-syzkaller-g8f5ae30d69d7 #0 PREEMPT 
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 06/30/2025
Call trace:
 show_stack+0x2c/0x3c arch/arm64/kernel/stacktrace.c:499 (C)
 __dump_stack+0x30/0x40 lib/dump_stack.c:94
 dump_stack_lvl+0xd8/0x12c lib/dump_stack.c:120
 print_address_description+0xa8/0x238 mm/kasan/report.c:378
 print_report+0x68/0x84 mm/kasan/report.c:482
 kasan_report+0xb0/0x110 mm/kasan/report.c:595
 __asan_report_load8_noabort+0x20/0x2c mm/kasan/report_generic.c:381
 ocfs2_get_system_file_inode+0x17c/0x650 fs/ocfs2/sysfile.c:102
 ocfs2_remove_inode fs/ocfs2/inode.c:723 [inline]
 ocfs2_wipe_inode fs/ocfs2/inode.c:894 [inline]
 ocfs2_delete_inode fs/ocfs2/inode.c:1155 [inline]
 ocfs2_evict_inode+0x12e8/0x3bf8 fs/ocfs2/inode.c:1292
 evict+0x414/0x928 fs/inode.c:810
 iput_final fs/inode.c:1897 [inline]
 iput+0x6e4/0x83c fs/inode.c:1923
 d_delete_notify include/linux/fsnotify.h:377 [inline]
 vfs_rmdir+0x358/0x464 fs/namei.c:4474
 do_rmdir+0x214/0x4c4 fs/namei.c:4516
 __do_sys_unlinkat fs/namei.c:4690 [inline]
 __se_sys_unlinkat fs/namei.c:4684 [inline]
 __arm64_sys_unlinkat+0xc8/0xf8 fs/namei.c:4684
 __invoke_syscall arch/arm64/kernel/syscall.c:35 [inline]
 invoke_syscall+0x98/0x2b8 arch/arm64/kernel/syscall.c:49
 el0_svc_common+0x130/0x23c arch/arm64/kernel/syscall.c:132
 do_el0_svc+0x48/0x58 arch/arm64/kernel/syscall.c:151
 el0_svc+0x58/0x180 arch/arm64/kernel/entry-common.c:879
 el0t_64_sync_handler+0x84/0x12c arch/arm64/kernel/entry-common.c:898
 el0t_64_sync+0x198/0x19c arch/arm64/kernel/entry.S:596

Allocated by task 6734:
 kasan_save_stack mm/kasan/common.c:47 [inline]
 kasan_save_track+0x40/0x78 mm/kasan/common.c:68
 kasan_save_alloc_info+0x44/0x54 mm/kasan/generic.c:562
 unpoison_slab_object mm/kasan/common.c:330 [inline]
 __kasan_slab_alloc+0x70/0x88 mm/kasan/common.c:356
 kasan_slab_alloc include/linux/kasan.h:250 [inline]
 slab_post_alloc_hook mm/slub.c:4180 [inline]
 slab_alloc_node mm/slub.c:4229 [inline]
 kmem_cache_alloc_noprof+0x238/0x3e8 mm/slub.c:4236
 anon_vma_chain_alloc mm/rmap.c:142 [inline]
 __anon_vma_prepare+0xc4/0x3fc mm/rmap.c:195
 __vmf_anon_prepare mm/memory.c:3506 [inline]
 vmf_anon_prepare mm/internal.h:432 [inline]
 do_anonymous_page mm/memory.c:5050 [inline]
 do_pte_missing mm/memory.c:4232 [inline]
 handle_pte_fault mm/memory.c:6052 [inline]
 __handle_mm_fault mm/memory.c:6195 [inline]
 handle_mm_fault+0x4308/0x4d34 mm/memory.c:6364
 do_page_fault+0x410/0x13cc arch/arm64/mm/fault.c:653
 do_translation_fault+0xc4/0x114 arch/arm64/mm/fault.c:789
 do_mem_abort+0x70/0x194 arch/arm64/mm/fault.c:929
 el0_da+0x64/0x164 arch/arm64/kernel/entry-common.c:697
 el0t_64_sync_handler+0x90/0x12c arch/arm64/kernel/entry-common.c:901
 el0t_64_sync+0x198/0x19c arch/arm64/kernel/entry.S:596

Freed by task 6734:
 kasan_save_stack mm/kasan/common.c:47 [inline]
 kasan_save_track+0x40/0x78 mm/kasan/common.c:68
 kasan_save_free_info+0x58/0x70 mm/kasan/generic.c:576
 poison_slab_object mm/kasan/common.c:243 [inline]
 __kasan_slab_free+0x74/0x98 mm/kasan/common.c:275
 kasan_slab_free include/linux/kasan.h:233 [inline]
 slab_free_hook mm/slub.c:2417 [inline]
 slab_free mm/slub.c:4680 [inline]
 kmem_cache_free+0x184/0x550 mm/slub.c:4782
 anon_vma_chain_free mm/rmap.c:147 [inline]
 unlink_anon_vmas+0x48c/0x520 mm/rmap.c:447
 free_pgtables+0x3c8/0x5d4 mm/memory.c:413
 exit_mmap+0x350/0xabc mm/mmap.c:1291
 __mmput+0xec/0x3f4 kernel/fork.c:1130
 mmput+0x70/0xac kernel/fork.c:1152
 exit_mm+0x13c/0x200 kernel/exit.c:582
 do_exit+0x4bc/0x1a14 kernel/exit.c:949
 do_group_exit+0x194/0x22c kernel/exit.c:1102
 __do_sys_exit_group kernel/exit.c:1113 [inline]
 __se_sys_exit_group kernel/exit.c:1111 [inline]
 pid_child_should_wake+0x0/0x1dc kernel/exit.c:1111
 __invoke_syscall arch/arm64/kernel/syscall.c:35 [inline]
 invoke_syscall+0x98/0x2b8 arch/arm64/kernel/syscall.c:49
 el0_svc_common+0x130/0x23c arch/arm64/kernel/syscall.c:132
 do_el0_svc+0x48/0x58 arch/arm64/kernel/syscall.c:151
 el0_svc+0x58/0x180 arch/arm64/kernel/entry-common.c:879
 el0t_64_sync_handler+0x84/0x12c arch/arm64/kernel/entry-common.c:898
 el0t_64_sync+0x198/0x19c arch/arm64/kernel/entry.S:596

The buggy address belongs to the object at ffff0000dea2ae00
 which belongs to the cache anon_vma_chain of size 80
The buggy address is located 16 bytes inside of
 freed 80-byte region [ffff0000dea2ae00, ffff0000dea2ae50)

The buggy address belongs to the physical page:
page: refcount:0 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x11ea2a
flags: 0x5ffc00000000000(node=0|zone=2|lastcpupid=0x7ff)
page_type: f5(slab)
raw: 05ffc00000000000 ffff0000c18ad280 fffffdffc37a8980 0000000000000002
raw: 0000000000000000 0000000000240024 00000000f5000000 0000000000000000
page dumped because: kasan: bad access detected

Memory state around the buggy address:
 ffff0000dea2ad00: fc fc fc fc fa fb fb fb fb fb fb fb fb fb fc fc
 ffff0000dea2ad80: fc fc fa fb fb fb fb fb fb fb fb fb fc fc fc fc
>ffff0000dea2ae00: fa fb fb fb fb fb fb fb fb fb fc fc fc fc fa fb
                         ^
 ffff0000dea2ae80: fb fb fb fb fb fb fb fb fc fc fc fc fa fb fb fb
 ffff0000dea2af00: fb fb fb fb fb fb fc fc fc fc fa fb fb fb fb fb
==================================================================
Unable to handle kernel paging request at virtual address fbd5200000000030
KASAN: maybe wild-memory-access in range [0xdead000000000180-0xdead000000000187]
Mem abort info:
  ESR = 0x0000000096000004
  EC = 0x25: DABT (current EL), IL = 32 bits
  SET = 0, FnV = 0
  EA = 0, S1PTW = 0
  FSC = 0x04: level 0 translation fault
Data abort info:
  ISV = 0, ISS = 0x00000004, ISS2 = 0x00000000
  CM = 0, WnR = 0, TnD = 0, TagAccess = 0
  GCS = 0, Overlay = 0, DirtyBit = 0, Xs = 0
[fbd5200000000030] address between user and kernel address ranges
Internal error: Oops: 0000000096000004 [#1]  SMP
Modules linked in:
CPU: 1 UID: 0 PID: 6666 Comm: syz-executor Tainted: G    B               6.17.0-rc1-syzkaller-g8f5ae30d69d7 #0 PREEMPT 
Tainted: [B]=BAD_PAGE
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 06/30/2025
pstate: 63400005 (nZCv daif +PAN -UAO +TCO +DIT -SSBS BTYPE=--)
pc : debug_spin_lock_before kernel/locking/spinlock_debug.c:86 [inline]
pc : do_raw_spin_lock+0x84/0x2cc kernel/locking/spinlock_debug.c:115
lr : __raw_spin_lock include/linux/spinlock_api_smp.h:134 [inline]
lr : _raw_spin_lock+0x50/0x60 kernel/locking/spinlock.c:154
sp : ffff8000a28a7040
x29: ffff8000a28a70c0 x28: 0000000000000000 x27: ffff8000a28a7180
x26: dfff800000000000 x25: ffff700014514e30 x24: dfff800000000000
x23: 0000000000000800 x22: ffff0000dea2ae10 x21: ffff0000c68f0000
x20: dead000000000184 x19: dead000000000180 x18: 00000000ffffffff
x17: 3d3d3d3d3d3d3d3d x16: ffff8000805354d8 x15: 0000000000000001
x14: 1ffff0001260d8fc x13: 0000000000000000 x12: 0000000000000000
x11: 1ffff00014514e0c x10: ffff80008efad53b x9 : f3f3f304f1f1f1f1
x8 : 1bd5a00000000030 x7 : 0000000000000001 x6 : ffff800080dd7c18
x5 : 0000000000000000 x4 : 0000000000000001 x3 : 0000000000000000
x2 : 0000000000000000 x1 : ffff80008b6577c0 x0 : dead000000000180
Call trace:
 debug_spin_lock_before kernel/locking/spinlock_debug.c:-1 [inline] (P)
 do_raw_spin_lock+0x84/0x2cc kernel/locking/spinlock_debug.c:115 (P)
 __raw_spin_lock include/linux/spinlock_api_smp.h:134 [inline]
 _raw_spin_lock+0x50/0x60 kernel/locking/spinlock.c:154
 spin_lock include/linux/spinlock.h:351 [inline]
 igrab+0x20/0xd8 fs/inode.c:1540
 ocfs2_get_system_file_inode+0x188/0x650 fs/ocfs2/sysfile.c:104
 ocfs2_remove_inode fs/ocfs2/inode.c:723 [inline]
 ocfs2_wipe_inode fs/ocfs2/inode.c:894 [inline]
 ocfs2_delete_inode fs/ocfs2/inode.c:1155 [inline]
 ocfs2_evict_inode+0x12e8/0x3bf8 fs/ocfs2/inode.c:1292
 evict+0x414/0x928 fs/inode.c:810
 iput_final fs/inode.c:1897 [inline]
 iput+0x6e4/0x83c fs/inode.c:1923
 d_delete_notify include/linux/fsnotify.h:377 [inline]
 vfs_rmdir+0x358/0x464 fs/namei.c:4474
 do_rmdir+0x214/0x4c4 fs/namei.c:4516
 __do_sys_unlinkat fs/namei.c:4690 [inline]
 __se_sys_unlinkat fs/namei.c:4684 [inline]
 __arm64_sys_unlinkat+0xc8/0xf8 fs/namei.c:4684
 __invoke_syscall arch/arm64/kernel/syscall.c:35 [inline]
 invoke_syscall+0x98/0x2b8 arch/arm64/kernel/syscall.c:49
 el0_svc_common+0x130/0x23c arch/arm64/kernel/syscall.c:132
 do_el0_svc+0x48/0x58 arch/arm64/kernel/syscall.c:151
 el0_svc+0x58/0x180 arch/arm64/kernel/entry-common.c:879
 el0t_64_sync_handler+0x84/0x12c arch/arm64/kernel/entry-common.c:898
 el0t_64_sync+0x198/0x19c arch/arm64/kernel/entry.S:596
Code: aa0003f3 f9000feb f2fe7e69 f8386969 (38f86908) 
---[ end trace 0000000000000000 ]---
----------------
Code disassembly (best guess):
   0:	aa0003f3 	mov	x19, x0
   4:	f9000feb 	str	x11, [sp, #24]
   8:	f2fe7e69 	movk	x9, #0xf3f3, lsl #48
   c:	f8386969 	str	x9, [x11, x24]
* 10:	38f86908 	ldrsb	w8, [x8, x24] <-- trapping instruction


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
