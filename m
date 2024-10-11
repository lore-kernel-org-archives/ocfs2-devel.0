Received: from mail-io1-f72.google.com (mail-io1-f72.google.com [209.85.166.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 173691922C4
	for <ocfs2-devel@lists.linux.dev>; Fri, 11 Oct 2024 04:40:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728621627; cv=none; b=XWpfpOPwsOk0k7mL4gJTXAbdLVrasG7RmX3Qn4TUmCAmf/k5TlecEzVklua3VJPHz73V9VgnQS8XCuf2X1LCr0NOgF8tFAdQx07j+pRGVh5Pw4vJI3z53Tr19KaZ60SknDZ1WBVJgfQ0ocUR8s91nFludyikjz/J8RtVF1vjujc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728621627; c=relaxed/simple;
	bh=YF4hzy+ZL843CcRICPoWzGtN6ayPkYu1mTdqfk1xZT4=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:
	 Content-Type; b=dImMjEYIKL3Gu9s600WfuFU3AW45JtdVrtItdF2pVNWyTuKAIAjAk5RwRSdRZivSLyvqUvU1NGWtUtQEbr4poHbWZF9ZKyMnTzwSebw3pnYxSTIbRhz80e5rpHITY24EazKCnzT8g9wDcb3OeHd+mwm4YtUvvq5/gx5jKVaqZf4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-io1-f72.google.com with SMTP id ca18e2360f4ac-8377cfbca87so86644639f.3
        for <ocfs2-devel@lists.linux.dev>; Thu, 10 Oct 2024 21:40:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728621625; x=1729226425;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=sZmcCu8U0/gwEL0HqZ7YGSGA/yrgjZCQ5DNgydXdV4A=;
        b=P7GGA0YzuHQ6qzxzCU9AqpVvqjfWpQpxoAUfUN4GDHtT63qhmU1m40z9kNRNAwX7BE
         354SqVwVRuoSaa+TyNVSXbCkF0Wm/QRqZ0Hn5ptEq29lgK1lnR3i5zNNxQ6VB3e6r2xZ
         Pg54MrhJaBdt13dZLOAbx2XfFgqYb2J++ZjBymQvS+sEE+SS4P542qytCtBWryiNAG5T
         Jzqj4VdA1sGxeMPN5AIf/+pA21e8mEhZrn1Aewx3kI8ICY2A6n5E5gQ1I6OUVyH4B23Z
         zQQmZoAKswjyJQxdCaO4p60VDIyEiC6iF1jPUkPbU7XzTsN+qhJjLYs7odRdiQfVeMJl
         c5UA==
X-Forwarded-Encrypted: i=1; AJvYcCXQ1cNAf86lN0kAmxPzyMDWr1nGzqZlpb6l0jpIL0RLKv4CdUu6glRaC1uDSvxcLcPxSfXpiVHpjgS7zw==@lists.linux.dev
X-Gm-Message-State: AOJu0YwNMSulIpUKVjqBAHT/MwJAA7Ge5Z7ngzY8LGtxxH5tXXYmpMOM
	QUfPYNnfw7BFLUkBA9XB8YSJrc1OLmgit90dvvH7jRHJWP3/F5r806szJUD6Ypfd1LkG06xNlv5
	T61SH1WKCia7Q3+F24RPdLbt5WygvCurAnqXqPbnVDBiCW5WDBILtVcs=
X-Google-Smtp-Source: AGHT+IH4ZFqFNodq9jP7irIb93XqgdQL7DhXOiQ8+33BVyFnPswQBHiCb9MnCvMTffNmS34ys+sk69cUAW93UBh7qEx0XssWTHJC
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1c82:b0:3a3:b1dd:c30b with SMTP id
 e9e14a558f8ab-3a3b5fb651bmr10837505ab.18.1728621625161; Thu, 10 Oct 2024
 21:40:25 -0700 (PDT)
Date: Thu, 10 Oct 2024 21:40:25 -0700
In-Reply-To: <000000000000c7e54f0621e8a14f@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6708ac39.050a0220.3e960.000b.GAE@google.com>
Subject: Re: [syzbot] [ocfs2?] KASAN: slab-use-after-free Read in ocfs2_fault
From: syzbot <syzbot+a49010a0e8fcdeea075f@syzkaller.appspotmail.com>
To: jlbec@evilplan.org, joseph.qi@linux.alibaba.com, 
	linux-kernel@vger.kernel.org, mark@fasheh.com, ocfs2-devel@lists.linux.dev, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

syzbot has found a reproducer for the following issue on:

HEAD commit:    2d8bce6e34be KVM: arm64: Shave a few bytes from the EL2 id..
git tree:       git://git.kernel.org/pub/scm/linux/kernel/git/arm64/linux.git for-kernelci
console output: https://syzkaller.appspot.com/x/log.txt?x=145a1fd0580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=b9f31443a725c681
dashboard link: https://syzkaller.appspot.com/bug?extid=a49010a0e8fcdeea075f
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40
userspace arch: arm64
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=13ed405f980000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=139cab27980000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/8b2745aa8707/disk-2d8bce6e.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/c62ee63d102f/vmlinux-2d8bce6e.xz
kernel image: https://storage.googleapis.com/syzbot-assets/d3b601037e8f/Image-2d8bce6e.gz.xz
mounted in repro #1: https://storage.googleapis.com/syzbot-assets/f3b54e377488/mount_0.gz
mounted in repro #2: https://storage.googleapis.com/syzbot-assets/24fadc57f66d/mount_1.gz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+a49010a0e8fcdeea075f@syzkaller.appspotmail.com

==================================================================
BUG: KASAN: slab-use-after-free in ocfs2_fault+0xe0/0x49c fs/ocfs2/mmap.c:41
Read of size 8 at addr ffff0000cf14e938 by task syz-executor309/8708

CPU: 1 UID: 0 PID: 8708 Comm: syz-executor309 Not tainted 6.12.0-rc1-syzkaller-g2d8bce6e34be #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 08/06/2024
Call trace:
 dump_backtrace+0x1b8/0x1e4 arch/arm64/kernel/stacktrace.c:319
 show_stack+0x2c/0x3c arch/arm64/kernel/stacktrace.c:326
 __dump_stack lib/dump_stack.c:94 [inline]
 dump_stack_lvl+0xe4/0x150 lib/dump_stack.c:120
 print_address_description mm/kasan/report.c:377 [inline]
 print_report+0x198/0x538 mm/kasan/report.c:488
 kasan_report+0xd8/0x138 mm/kasan/report.c:601
 __asan_report_load8_noabort+0x20/0x2c mm/kasan/report_generic.c:381
 ocfs2_fault+0xe0/0x49c fs/ocfs2/mmap.c:41
 __do_fault+0x11c/0x374 mm/memory.c:4876
 do_shared_fault mm/memory.c:5346 [inline]
 do_fault mm/memory.c:5420 [inline]
 do_pte_missing mm/memory.c:3965 [inline]
 handle_pte_fault mm/memory.c:5751 [inline]
 __handle_mm_fault+0x1d30/0x66c0 mm/memory.c:5894
 handle_mm_fault+0x29c/0x8b4 mm/memory.c:6062
 do_page_fault+0x570/0x10a8 arch/arm64/mm/fault.c:690
 do_translation_fault+0xc4/0x114 arch/arm64/mm/fault.c:783
 do_mem_abort+0x74/0x200 arch/arm64/mm/fault.c:919
 el1_abort+0x3c/0x5c arch/arm64/kernel/entry-common.c:432
 el1h_64_sync_handler+0x60/0xbc arch/arm64/kernel/entry-common.c:501
 el1h_64_sync+0x64/0x68 arch/arm64/kernel/entry.S:593
 __arch_copy_to_user+0x190/0x234 arch/arm64/lib/copy_template.S:158
 copy_page_to_iter+0x204/0x2fc lib/iov_iter.c:362
 copy_folio_to_iter include/linux/uio.h:189 [inline]
 filemap_read+0x6c0/0xc84 mm/filemap.c:2696
 generic_file_read_iter+0x9c/0x34c mm/filemap.c:2833
 ocfs2_file_read_iter+0x408/0xbd4 fs/ocfs2/file.c:2574
 do_iter_readv_writev+0x490/0x6d4
 vfs_readv+0x238/0x844 fs/read_write.c:1025
 do_preadv fs/read_write.c:1142 [inline]
 __do_sys_preadv fs/read_write.c:1192 [inline]
 __se_sys_preadv fs/read_write.c:1187 [inline]
 __arm64_sys_preadv+0x18c/0x29c fs/read_write.c:1187
 __invoke_syscall arch/arm64/kernel/syscall.c:35 [inline]
 invoke_syscall+0x98/0x2b8 arch/arm64/kernel/syscall.c:49
 el0_svc_common+0x130/0x23c arch/arm64/kernel/syscall.c:132
 do_el0_svc+0x48/0x58 arch/arm64/kernel/syscall.c:151
 el0_svc+0x54/0x168 arch/arm64/kernel/entry-common.c:732
 el0t_64_sync_handler+0x84/0x108 arch/arm64/kernel/entry-common.c:750
 el0t_64_sync+0x190/0x194 arch/arm64/kernel/entry.S:598

Allocated by task 8719:
 kasan_save_stack mm/kasan/common.c:47 [inline]
 kasan_save_track+0x40/0x78 mm/kasan/common.c:68
 kasan_save_alloc_info+0x40/0x50 mm/kasan/generic.c:565
 unpoison_slab_object mm/kasan/common.c:319 [inline]
 __kasan_slab_alloc+0x74/0x8c mm/kasan/common.c:345
 kasan_slab_alloc include/linux/kasan.h:247 [inline]
 slab_post_alloc_hook mm/slub.c:4086 [inline]
 slab_alloc_node mm/slub.c:4135 [inline]
 kmem_cache_alloc_noprof+0x1c0/0x354 mm/slub.c:4142
 vm_area_alloc+0x30/0x1bc kernel/fork.c:472
 mmap_region+0xccc/0x1e28 mm/mmap.c:1424
 do_mmap+0x7e0/0xe00 mm/mmap.c:496
 vm_mmap_pgoff+0x1a0/0x38c mm/util.c:588
 ksys_mmap_pgoff+0x3a4/0x5c8 mm/mmap.c:542
 __do_sys_mmap arch/arm64/kernel/sys.c:28 [inline]
 __se_sys_mmap arch/arm64/kernel/sys.c:21 [inline]
 __arm64_sys_mmap+0xf8/0x110 arch/arm64/kernel/sys.c:21
 __invoke_syscall arch/arm64/kernel/syscall.c:35 [inline]
 invoke_syscall+0x98/0x2b8 arch/arm64/kernel/syscall.c:49
 el0_svc_common+0x130/0x23c arch/arm64/kernel/syscall.c:132
 do_el0_svc+0x48/0x58 arch/arm64/kernel/syscall.c:151
 el0_svc+0x54/0x168 arch/arm64/kernel/entry-common.c:732
 el0t_64_sync_handler+0x84/0x108 arch/arm64/kernel/entry-common.c:750
 el0t_64_sync+0x190/0x194 arch/arm64/kernel/entry.S:598

Freed by task 8710:
 kasan_save_stack mm/kasan/common.c:47 [inline]
 kasan_save_track+0x40/0x78 mm/kasan/common.c:68
 kasan_save_free_info+0x54/0x6c mm/kasan/generic.c:579
 poison_slab_object mm/kasan/common.c:247 [inline]
 __kasan_slab_free+0x64/0x8c mm/kasan/common.c:264
 kasan_slab_free include/linux/kasan.h:230 [inline]
 slab_free_hook mm/slub.c:2343 [inline]
 slab_free mm/slub.c:4580 [inline]
 kmem_cache_free+0x19c/0x560 mm/slub.c:4682
 __vm_area_free+0xfc/0x148 kernel/fork.c:515
 vm_area_free_rcu_cb+0x80/0xa4 kernel/fork.c:526
 rcu_do_batch kernel/rcu/tree.c:2567 [inline]
 rcu_core+0x898/0x1b5c kernel/rcu/tree.c:2823
 rcu_core_si+0x10/0x1c kernel/rcu/tree.c:2840
 handle_softirqs+0x2e0/0xbf8 kernel/softirq.c:554
 __do_softirq+0x14/0x20 kernel/softirq.c:588

Last potentially related work creation:
 kasan_save_stack+0x40/0x6c mm/kasan/common.c:47
 __kasan_record_aux_stack+0xd0/0xec mm/kasan/generic.c:541
 kasan_record_aux_stack_noalloc+0x14/0x20 mm/kasan/generic.c:551
 __call_rcu_common kernel/rcu/tree.c:3086 [inline]
 call_rcu+0x104/0xb00 kernel/rcu/tree.c:3190
 vm_area_free+0x28/0x38 kernel/fork.c:533
 remove_vma mm/vma.c:337 [inline]
 vms_complete_munmap_vmas+0x5c4/0x840 mm/vma.c:1156
 mmap_region+0xc68/0x1e28 mm/mmap.c:1533
 do_mmap+0x7e0/0xe00 mm/mmap.c:496
 vm_mmap_pgoff+0x1a0/0x38c mm/util.c:588
 ksys_mmap_pgoff+0x3a4/0x5c8 mm/mmap.c:542
 __do_sys_mmap arch/arm64/kernel/sys.c:28 [inline]
 __se_sys_mmap arch/arm64/kernel/sys.c:21 [inline]
 __arm64_sys_mmap+0xf8/0x110 arch/arm64/kernel/sys.c:21
 __invoke_syscall arch/arm64/kernel/syscall.c:35 [inline]
 invoke_syscall+0x98/0x2b8 arch/arm64/kernel/syscall.c:49
 el0_svc_common+0x130/0x23c arch/arm64/kernel/syscall.c:132
 do_el0_svc+0x48/0x58 arch/arm64/kernel/syscall.c:151
 el0_svc+0x54/0x168 arch/arm64/kernel/entry-common.c:732
 el0t_64_sync_handler+0x84/0x108 arch/arm64/kernel/entry-common.c:750
 el0t_64_sync+0x190/0x194 arch/arm64/kernel/entry.S:598

The buggy address belongs to the object at ffff0000cf14e8b8
 which belongs to the cache vm_area_struct of size 184
The buggy address is located 128 bytes inside of
 freed 184-byte region [ffff0000cf14e8b8, ffff0000cf14e970)

The buggy address belongs to the physical page:
page: refcount:1 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x10f14e
ksm flags: 0x5ffc00000000000(node=0|zone=2|lastcpupid=0x7ff)
page_type: f5(slab)
raw: 05ffc00000000000 ffff0000c182eb40 fffffdffc3620bc0 dead000000000007
raw: 0000000000000000 0000000000100010 00000001f5000000 0000000000000000
page dumped because: kasan: bad access detected

Memory state around the buggy address:
 ffff0000cf14e800: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 fc
 ffff0000cf14e880: fc fc fc fc fc fc fc fa fb fb fb fb fb fb fb fb
>ffff0000cf14e900: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fc fc
                                        ^
 ffff0000cf14e980: fc fc fc fc fc fc fa fb fb fb fb fb fb fb fb fb
 ffff0000cf14ea00: fb fb fb fb fb fb fb fb fb fb fb fb fb fc fc fc
==================================================================


---
If you want syzbot to run the reproducer, reply with:
#syz test: git://repo/address.git branch-or-commit-hash
If you attach or paste a git patch, syzbot will apply it before testing.
