Received: from mail-il1-f206.google.com (mail-il1-f206.google.com [209.85.166.206])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE9A32BDC00
	for <ocfs2-devel@lists.linux.dev>; Mon, 25 Aug 2025 08:52:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.206
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756111956; cv=none; b=IjDq8PqgTQ+Y3n4uHXkMwl0QAl6QN5DaDvZ0qtjc5N/t6ARIz67ssUYFAmcGJ68Ttoq0escHeNzKrTE2kOoPqAn1ZESAMmlNEy2UzmXWZddt3iuhFO9UB81/eYVC7HW5Gu8hWgUwIocUDzdjVbTW6Z+75G2d/ymb+ITGHDSjEYg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756111956; c=relaxed/simple;
	bh=d1kMZCy4s3ot760+3EUIG3Y2P3CSxMYzQz2dzjRe/30=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=jV2IXspeSSj/cUQMu8rKWIgBSu36NClJIAnzL0dW3kWHkPSsSvtml+npA4K/9ajWOUQacpnS7TSnqwWNAGQ3nC0XbhFdrBQIy/bAzv2sOr5Ijf1KzzUpl0jv1F79ad1x2sV+2ReeeD7FPlcGXCp+927vaeDX8dM/fJtqVrymdy0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.206
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f206.google.com with SMTP id e9e14a558f8ab-3eca67caa2bso7025125ab.0
        for <ocfs2-devel@lists.linux.dev>; Mon, 25 Aug 2025 01:52:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756111954; x=1756716754;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=SaqTA63u0ICb1ykvyZOrN9Io3Gc7RdfxjoSxnWfYBE4=;
        b=sTqyY+usaN3AfX98LeFVtOA9xcmm6n9jXNpESrf7lFMd+ct4aQP13Y9E6Z8EU0YlaA
         ZXhvetYlDOBpzP0yW1arweh9+K9LMxBiyVFQBHPlYzw9WS56we2rakvTHymwqnojxWWJ
         6XmUjxWQQ6+nJBuorlgfsIXr0x+jIw4JKtH8ASTaBI8ZSbt3+/U9L2jfMB8zgOEf2Pvd
         6ZajbYDeYQIGtZAVUOz1tF2yiFlVat7Vrn/ud23YRXTonSgPOr9zQHkFiaKoUnyYvyzb
         Nk/tdcIDuNvamDLGx8OL1fYF8R5bdn0PWH+4M4JS7QEZt5KRNsvk/Di/w+bgKJmoTtMP
         Tmeg==
X-Forwarded-Encrypted: i=1; AJvYcCVvcO7oneMVndyG6AaKl2VWdgMuyDDEr3/3WK+Y9IOHZ3rGSPmaFuHvxYy4qfBjFVz6jK4eUy2cTSwh9A==@lists.linux.dev
X-Gm-Message-State: AOJu0YwsbfcIuYoNmlP5Kvtvn3kLgJGz2uIeV35Vyo4Xxzq+NIv+MgYD
	rGep84XgjPjCSnThkF0TrHUNxIXlYztE2Ugh/SMK6jiy4GIM7PQUM6RjVGTBzR9pTuyNzt8hSzv
	1Jddww73MkuUGvlEx/eVdvKeoLaz92dL+q2ZQSjVovuJdP7aOz0xkALuPZBk=
X-Google-Smtp-Source: AGHT+IHt7B+JmTBOL5nSn8lOXEieu9lsYol7NiVI+oPG8cJqPDGdKYThx2PBejydsM+OBn0cevyW+D0xO3+toPcfsRWk1A83VJrn
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a92:ca4e:0:b0:3ec:4ada:a532 with SMTP id
 e9e14a558f8ab-3ec4adab87bmr42842385ab.1.1756111953966; Mon, 25 Aug 2025
 01:52:33 -0700 (PDT)
Date: Mon, 25 Aug 2025 01:52:33 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <68ac2451.050a0220.37038e.008b.GAE@google.com>
Subject: [syzbot] [ocfs2?] KASAN: slab-out-of-bounds Read in igrab
From: syzbot <syzbot+a77d690840e60bc2ddd8@syzkaller.appspotmail.com>
To: akpm@linux-foundation.org, heming.zhao@suse.com, jlbec@evilplan.org, 
	joseph.qi@linux.alibaba.com, linux-kernel@vger.kernel.org, mark@fasheh.com, 
	ocfs2-devel@lists.linux.dev, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    8f5ae30d69d7 Linux 6.17-rc1
git tree:       git://git.kernel.org/pub/scm/linux/kernel/git/arm64/linux.git for-kernelci
console output: https://syzkaller.appspot.com/x/log.txt?x=11120ef0580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=8c5ac3d8b8abfcb
dashboard link: https://syzkaller.appspot.com/bug?extid=a77d690840e60bc2ddd8
compiler:       Debian clang version 20.1.7 (++20250616065708+6146a88f6049-1~exp1~20250616065826.132), Debian LLD 20.1.7
userspace arch: arm64
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=17ce8c42580000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=101eaa34580000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/18a2e4bd0c4a/disk-8f5ae30d.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/3b5395881b25/vmlinux-8f5ae30d.xz
kernel image: https://storage.googleapis.com/syzbot-assets/e875f4e3b7ff/Image-8f5ae30d.gz.xz
mounted in repro: https://storage.googleapis.com/syzbot-assets/46dfd4b00375/mount_0.gz
  fsck result: OK (log: https://syzkaller.appspot.com/x/fsck.log?x=17eeaa34580000)

The issue was bisected to:

commit bd1261b16d9131d79723d982d54295e7f309797a
Author: Heming Zhao <heming.zhao@suse.com>
Date:   Mon Apr 14 06:01:23 2025 +0000

    ocfs2: fix the issue with discontiguous allocation in the global_bitmap

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=16f17062580000
final oops:     https://syzkaller.appspot.com/x/report.txt?x=15f17062580000
console output: https://syzkaller.appspot.com/x/log.txt?x=11f17062580000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+a77d690840e60bc2ddd8@syzkaller.appspotmail.com
Fixes: bd1261b16d91 ("ocfs2: fix the issue with discontiguous allocation in the global_bitmap")

==================================================================
BUG: KASAN: slab-out-of-bounds in __raw_spin_lock include/linux/spinlock_api_smp.h:133 [inline]
BUG: KASAN: slab-out-of-bounds in _raw_spin_lock+0x48/0x60 kernel/locking/spinlock.c:154
Read of size 1 at addr ffff0000d14d4d09 by task syz-executor/6658

CPU: 0 UID: 0 PID: 6658 Comm: syz-executor Not tainted 6.17.0-rc1-syzkaller-g8f5ae30d69d7 #0 PREEMPT 
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 06/30/2025
Call trace:
 show_stack+0x2c/0x3c arch/arm64/kernel/stacktrace.c:499 (C)
 __dump_stack+0x30/0x40 lib/dump_stack.c:94
 dump_stack_lvl+0xd8/0x12c lib/dump_stack.c:120
 print_address_description+0xa8/0x238 mm/kasan/report.c:378
 print_report+0x68/0x84 mm/kasan/report.c:482
 kasan_report+0xb0/0x110 mm/kasan/report.c:595
 __kasan_check_byte+0x3c/0x54 mm/kasan/common.c:568
 kasan_check_byte include/linux/kasan.h:399 [inline]
 lock_acquire+0xb0/0x2e0 kernel/locking/lockdep.c:5842
 __raw_spin_lock include/linux/spinlock_api_smp.h:133 [inline]
 _raw_spin_lock+0x48/0x60 kernel/locking/spinlock.c:154
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

Allocated by task 1:
 kasan_save_stack mm/kasan/common.c:47 [inline]
 kasan_save_track+0x40/0x78 mm/kasan/common.c:68
 kasan_save_alloc_info+0x44/0x54 mm/kasan/generic.c:562
 unpoison_slab_object mm/kasan/common.c:330 [inline]
 __kasan_slab_alloc+0x70/0x88 mm/kasan/common.c:356
 kasan_slab_alloc include/linux/kasan.h:250 [inline]
 slab_post_alloc_hook mm/slub.c:4180 [inline]
 slab_alloc_node mm/slub.c:4229 [inline]
 kmem_cache_alloc_noprof+0x238/0x3e8 mm/slub.c:4236
 __kernfs_new_node+0xe4/0x5c4 fs/kernfs/dir.c:637
 kernfs_new_node+0xe8/0x1f4 fs/kernfs/dir.c:713
 __kernfs_create_file+0x60/0x2d4 fs/kernfs/file.c:1039
 sysfs_add_file_mode_ns+0x1d8/0x294 fs/sysfs/file.c:319
 create_files fs/sysfs/group.c:76 [inline]
 internal_create_group+0x5c0/0xe28 fs/sysfs/group.c:183
 internal_create_groups fs/sysfs/group.c:223 [inline]
 sysfs_create_groups+0x60/0x134 fs/sysfs/group.c:249
 device_add_groups drivers/base/core.c:2836 [inline]
 device_add_attrs+0xd8/0x6e8 drivers/base/core.c:2900
 device_add+0x490/0xa60 drivers/base/core.c:3643
 netdev_register_kobject+0x15c/0x2e0 net/core/net-sysfs.c:2356
 register_netdevice+0xb58/0x1248 net/core/dev.c:11189
 __ip_tunnel_create+0x358/0x4a0 net/ipv4/ip_tunnel.c:268
 ip_tunnel_init_net+0x22c/0x630 net/ipv4/ip_tunnel.c:1161
 ipgre_tap_init_net+0x38/0x48 net/ipv4/ip_gre.c:1751
 ops_init+0x310/0x544 net/core/net_namespace.c:136
 __register_pernet_operations net/core/net_namespace.c:1314 [inline]
 register_pernet_operations+0x2c0/0x6bc net/core/net_namespace.c:1391
 register_pernet_device+0x3c/0x9c net/core/net_namespace.c:1478
 ipgre_init+0x38/0x140 net/ipv4/ip_gre.c:1796
 do_one_initcall+0x250/0x990 init/main.c:1269
 do_initcall_level+0x128/0x1c4 init/main.c:1331
 do_initcalls+0x70/0xd0 init/main.c:1347
 do_basic_setup+0x78/0x8c init/main.c:1366
 kernel_init_freeable+0x268/0x39c init/main.c:1579
 kernel_init+0x24/0x1dc init/main.c:1469
 ret_from_fork+0x10/0x20 arch/arm64/kernel/entry.S:844

The buggy address belongs to the object at ffff0000d14d4c30
 which belongs to the cache kernfs_node_cache of size 176
The buggy address is located 41 bytes to the right of
 allocated 176-byte region [ffff0000d14d4c30, ffff0000d14d4ce0)

The buggy address belongs to the physical page:
page: refcount:0 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x1114d4
flags: 0x5ffc00000000000(node=0|zone=2|lastcpupid=0x7ff)
page_type: f5(slab)
raw: 05ffc00000000000 ffff0000c18b9000 dead000000000122 0000000000000000
raw: 0000000000000000 0000000000110011 00000000f5000000 0000000000000000
page dumped because: kasan: bad access detected

Memory state around the buggy address:
 ffff0000d14d4c00: fc fc fc fc fc fc 00 00 00 00 00 00 00 00 00 00
 ffff0000d14d4c80: 00 00 00 00 00 00 00 00 00 00 00 00 fc fc fc fc
>ffff0000d14d4d00: fc fc fc fc 00 00 00 00 00 00 00 00 00 00 00 00
                      ^
 ffff0000d14d4d80: 00 00 00 00 00 00 00 00 00 00 fc fc fc fc fc fc
 ffff0000d14d4e00: fc fc 00 00 00 00 00 00 00 00 00 00 00 00 00 00
==================================================================
Unable to handle kernel paging request at virtual address ffff0000d14d4d49
KASAN: maybe wild-memory-access in range [0xfffc00068a6a6a48-0xfffc00068a6a6a4f]
Mem abort info:
  ESR = 0x0000000096000021
  EC = 0x25: DABT (current EL), IL = 32 bits
  SET = 0, FnV = 0
  EA = 0, S1PTW = 0
  FSC = 0x21: alignment fault
Data abort info:
  ISV = 0, ISS = 0x00000021, ISS2 = 0x00000000
  CM = 0, WnR = 0, TnD = 0, TagAccess = 0
  GCS = 0, Overlay = 0, DirtyBit = 0, Xs = 0
swapper pgtable: 4k pages, 48-bit VAs, pgdp=0000000206ec9000
[ffff0000d14d4d49] pgd=0000000000000000, p4d=180000023ffff403, pud=180000023f41b403, pmd=180000023f390403, pte=00680001114d4707
Internal error: Oops: 0000000096000021 [#1]  SMP
Modules linked in:
CPU: 0 UID: 0 PID: 6658 Comm: syz-executor Tainted: G    B               6.17.0-rc1-syzkaller-g8f5ae30d69d7 #0 PREEMPT 
Tainted: [B]=BAD_PAGE
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 06/30/2025
pstate: 63400005 (nZCv daif +PAN -UAO +TCO +DIT -SSBS BTYPE=--)
pc : __lse__cmpxchg_case_acq_64 arch/arm64/include/asm/atomic_lse.h:272 [inline]
pc : __cmpxchg_case_acq_64 arch/arm64/include/asm/cmpxchg.h:121 [inline]
pc : __cmpxchg_acq arch/arm64/include/asm/cmpxchg.h:169 [inline]
pc : raw_atomic64_cmpxchg_acquire include/linux/atomic/atomic-arch-fallback.h:4181 [inline]
pc : raw_atomic64_try_cmpxchg_acquire include/linux/atomic/atomic-arch-fallback.h:4299 [inline]
pc : raw_atomic_long_try_cmpxchg_acquire include/linux/atomic/atomic-long.h:1482 [inline]
pc : atomic_long_try_cmpxchg_acquire include/linux/atomic/atomic-instrumented.h:4458 [inline]
pc : rwsem_write_trylock+0x9c/0x34c kernel/locking/rwsem.c:268
lr : instrument_atomic_read_write include/linux/instrumented.h:96 [inline]
lr : atomic_long_try_cmpxchg_acquire include/linux/atomic/atomic-instrumented.h:4457 [inline]
lr : rwsem_write_trylock+0x8c/0x34c kernel/locking/rwsem.c:268
sp : ffff8000a7467200
x29: ffff8000a7467270 x28: ffff0000e9958878 x27: ffff0000d72b8000
x26: ffff0000d72b8000 x25: ffff700014e8ce6c x24: 0000000000000000
x23: 0000000000000000 x22: 1ffff00014e8ce44 x21: dfff800000000000
x20: ffff8000a7467220 x19: ffff0000d14d4d49 x18: 1fffe0003379be88
x17: ffff80008f7be000 x16: ffff800080525c58 x15: 0000000000000001
x14: 1ffff00014e8ce48 x13: 0000000000000000 x12: 0000000000000000
x11: ffff700014e8ce49 x10: dfff800000000000 x9 : 1ffff00014e8ce48
x8 : 0000000000000001 x7 : 0000000000000000 x6 : ffff800082140010
x5 : 0000000000000000 x4 : 0000000000000001 x3 : ffff800080525ce4
x2 : 0000000000000001 x1 : 0000000000000008 x0 : 0000000000000001
Call trace:
 __lse__cmpxchg_case_acq_64 arch/arm64/include/asm/atomic_lse.h:272 [inline] (P)
 __cmpxchg_case_acq_64 arch/arm64/include/asm/cmpxchg.h:121 [inline] (P)
 __cmpxchg_acq arch/arm64/include/asm/cmpxchg.h:169 [inline] (P)
 raw_atomic64_cmpxchg_acquire include/linux/atomic/atomic-arch-fallback.h:4181 [inline] (P)
 raw_atomic64_try_cmpxchg_acquire include/linux/atomic/atomic-arch-fallback.h:4299 [inline] (P)
 raw_atomic_long_try_cmpxchg_acquire include/linux/atomic/atomic-long.h:1482 [inline] (P)
 atomic_long_try_cmpxchg_acquire include/linux/atomic/atomic-instrumented.h:4458 [inline] (P)
 rwsem_write_trylock+0x9c/0x34c kernel/locking/rwsem.c:268 (P)
 __down_write_common kernel/locking/rwsem.c:1316 [inline]
 __down_write kernel/locking/rwsem.c:1326 [inline]
 down_write+0x60/0xc0 kernel/locking/rwsem.c:1591
 inode_lock include/linux/fs.h:869 [inline]
 ocfs2_remove_inode fs/ocfs2/inode.c:731 [inline]
 ocfs2_wipe_inode fs/ocfs2/inode.c:894 [inline]
 ocfs2_delete_inode fs/ocfs2/inode.c:1155 [inline]
 ocfs2_evict_inode+0x1300/0x3bf8 fs/ocfs2/inode.c:1292
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
Code: f94023f7 d503201f aa1703f8 52800028 (c8f87e68) 
---[ end trace 0000000000000000 ]---
----------------
Code disassembly (best guess):
   0:	f94023f7 	ldr	x23, [sp, #64]
   4:	d503201f 	nop
   8:	aa1703f8 	mov	x24, x23
   c:	52800028 	mov	w8, #0x1                   	// #1
* 10:	c8f87e68 	casa	x24, x8, [x19] <-- trapping instruction


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
