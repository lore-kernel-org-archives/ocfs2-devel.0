Received: from mail-il1-f208.google.com (mail-il1-f208.google.com [209.85.166.208])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7A5E2248A1
	for <ocfs2-devel@lists.linux.dev>; Tue, 10 Dec 2024 07:13:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.208
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733814809; cv=none; b=CdTuRj10rsRaG86qY89MXom2zufw9HKiEDxrCCTpeN2IIyyUHTh1+sRZx02wEZ/vH4jOMvNoY1FuVSjx8t2GEsD2ZhXXi3Zwh8o2NLv2aswFh14ogyhyB4k2+OjflvjGzKB6YSbimT06RK38S4nqgtjSqti6z+p2FlAT5/2AppY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733814809; c=relaxed/simple;
	bh=jW9jS997Hfbw8eEXveSyYtgYHJxaz7pJTScM/jv25D0=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:
	 Content-Type; b=AHQ0FmDrWq4teK7LdncSvkSdFHi/BgVxrlzeC/GjiauSD1NYtQjC5Y/ZhlF0srLILBTFoTyw052UwE9RSg/zSzOHNfJmHxqoMcPDgjbmV/sJHvcBok6ujB8i2Q7SRfVnCKp0JJnYNa1pKurBjJlVtCATBuZhS6NtRhtJVuQP0A4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.208
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f208.google.com with SMTP id e9e14a558f8ab-3a81777ab57so30490115ab.2
        for <ocfs2-devel@lists.linux.dev>; Mon, 09 Dec 2024 23:13:25 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733814805; x=1734419605;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Ad0U7h1ZCgkYFN9DmZAPWSgdffEfL07q7idd0gdV9ew=;
        b=Dhfp3OsNZDniCLbUZ6i/wo3zITx3bI/5afXiBHytMb57OC/To1nz5SWLChrKrfxJ7S
         gLeftSqH7zSQkaZOdtOxdTaqZLA2zghcsStPMcpN3u8Bg7uvvJC5DmVstgmdw7LpV2bd
         xyNXtnribi7O6YpBFMsC/AoWWiL1RGbOTzadyivGv0OwHHBPKnkYbuCKnv8o2pH88Ng5
         tUb2BHzBXqpT8AxVsBFO3QiVsul6mjZk1y7yY7Zdjd7D8my8TIruO2YnbRqPohQuMrwo
         FFK+wnMmGQrlBSTVBQVdullHjza980cQ8+57mtf427jDUWrP1icS0v4HzUTHqYd9nSPb
         SFxQ==
X-Forwarded-Encrypted: i=1; AJvYcCXasGtF6/6FDRfLEOyCQaPnvUxxGoVNWu9yg8r1Ja5esgcjOX0tvUwTQDIwS11Lh+GuNQ9nHYNFZWu2rA==@lists.linux.dev
X-Gm-Message-State: AOJu0YxW+ptiMAxr68eULroCLhp15CUv5sNPfM1uvSo/0/YFrbzGyh+3
	bvkWE1ED+9IrmmVmnbBLTf8ZNkX5MCrK44mLX9TevafEctCovifo7k7SpxTBEE+uzQGNSqFGyJR
	o2XKvtsR/PT/Z8SPiNX4nWDt68NrV9wlyldq/w2hPNJ1V6wirbIu6DOw=
X-Google-Smtp-Source: AGHT+IHuqeI37mR8fIT7kGs4q1Z2Jl5oGeUxEejuvH0AqpA4Ex7ihmnVZYrEuAZwWu8seQkie1hqYeeMj34oH/k0sNxM4167Xt2I
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1a44:b0:3a7:fe8c:b015 with SMTP id
 e9e14a558f8ab-3a9dbb2b58fmr34624705ab.24.1733814804872; Mon, 09 Dec 2024
 23:13:24 -0800 (PST)
Date: Mon, 09 Dec 2024 23:13:24 -0800
In-Reply-To: <6731d26f.050a0220.1fb99c.014b.GAE@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6757ea14.050a0220.a30f1.01c5.GAE@google.com>
Subject: Re: [syzbot] [ocfs2?] KASAN: slab-use-after-free Read in ocfs2_lock_global_qf
From: syzbot <syzbot+d173bf8a5a7faeede34c@syzkaller.appspotmail.com>
To: jlbec@evilplan.org, joseph.qi@linux.alibaba.com, 
	linux-kernel@vger.kernel.org, mark@fasheh.com, ocfs2-devel@lists.linux.dev, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

syzbot has found a reproducer for the following issue on:

HEAD commit:    7cb1b4663150 Merge tag 'locking_urgent_for_v6.13_rc3' of g..
git tree:       upstream
console+strace: https://syzkaller.appspot.com/x/log.txt?x=15a034df980000
kernel config:  https://syzkaller.appspot.com/x/.config?x=c7c9f223bfe8924e
dashboard link: https://syzkaller.appspot.com/bug?extid=d173bf8a5a7faeede34c
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=11e0eb30580000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=179853e8580000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/a883190d5c75/disk-7cb1b466.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/238e5eeeb128/vmlinux-7cb1b466.xz
kernel image: https://storage.googleapis.com/syzbot-assets/8bc8850a6795/bzImage-7cb1b466.xz
mounted in repro: https://storage.googleapis.com/syzbot-assets/ac761c5756ee/mount_0.gz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+d173bf8a5a7faeede34c@syzkaller.appspotmail.com

(syz-executor353,5820,1):ocfs2_block_check_validate:402 ERROR: CRC32 failed: stored: 0xcfdff595, computed 0xefed4a20. Applying ECC.
JBD2: Ignoring recovery information on journal
ocfs2: Mounting device (7,0) on (node local, slot 0) with ordered data mode.
==================================================================
BUG: KASAN: slab-use-after-free in ocfs2_lock_global_qf+0xb8/0x2b0 fs/ocfs2/quota_global.c:303
Read of size 8 at addr ffff888035461028 by task syz-executor353/5820

CPU: 0 UID: 0 PID: 5820 Comm: syz-executor353 Not tainted 6.13.0-rc2-syzkaller-00018-g7cb1b4663150 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 09/13/2024
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:94 [inline]
 dump_stack_lvl+0x241/0x360 lib/dump_stack.c:120
 print_address_description mm/kasan/report.c:378 [inline]
 print_report+0x169/0x550 mm/kasan/report.c:489
 kasan_report+0x143/0x180 mm/kasan/report.c:602
 ocfs2_lock_global_qf+0xb8/0x2b0 fs/ocfs2/quota_global.c:303
 ocfs2_get_next_id+0x22c/0x740 fs/ocfs2/quota_global.c:900
 dquot_get_next_dqblk+0x73/0x3a0 fs/quota/dquot.c:2702
 quota_getnextquota+0x2c5/0x6c0 fs/quota/quota.c:250
 __do_sys_quotactl fs/quota/quota.c:961 [inline]
 __se_sys_quotactl+0x2c4/0xa30 fs/quota/quota.c:917
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f3d54632b99
Code: 28 00 00 00 75 05 48 83 c4 28 c3 e8 f1 17 00 00 90 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 b8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007ffe711e58a8 EFLAGS: 00000246 ORIG_RAX: 00000000000000b3
RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007f3d54632b99
RDX: 0000000000000000 RSI: 00000000200001c0 RDI: ffffffff80000900
RBP: 00007f3d546aa5f0 R08: 0000000020000c40 R09: 000055556b9fb4c0
R10: 0000000000000000 R11: 0000000000000246 R12: 00007ffe711e58d0
R13: 00007ffe711e5af8 R14: 431bde82d7b634db R15: 00007f3d5467b03b
 </TASK>

Allocated by task 5820:
 kasan_save_stack mm/kasan/common.c:47 [inline]
 kasan_save_track+0x3f/0x80 mm/kasan/common.c:68
 poison_kmalloc_redzone mm/kasan/common.c:377 [inline]
 __kasan_kmalloc+0x98/0xb0 mm/kasan/common.c:394
 kasan_kmalloc include/linux/kasan.h:260 [inline]
 __kmalloc_cache_noprof+0x243/0x390 mm/slub.c:4314
 kmalloc_noprof include/linux/slab.h:901 [inline]
 ocfs2_local_read_info+0x1ee/0x19f0 fs/ocfs2/quota_local.c:699
 dquot_load_quota_sb+0x762/0xbb0 fs/quota/dquot.c:2459
 dquot_load_quota_inode+0x320/0x600 fs/quota/dquot.c:2496
 ocfs2_enable_quotas+0x169/0x450 fs/ocfs2/super.c:926
 ocfs2_fill_super+0x4ca1/0x5760 fs/ocfs2/super.c:1141
 mount_bdev+0x20a/0x2d0 fs/super.c:1693
 legacy_get_tree+0xee/0x190 fs/fs_context.c:662
 vfs_get_tree+0x90/0x2b0 fs/super.c:1814
 do_new_mount+0x2be/0xb40 fs/namespace.c:3507
 do_mount fs/namespace.c:3847 [inline]
 __do_sys_mount fs/namespace.c:4057 [inline]
 __se_sys_mount+0x2d6/0x3c0 fs/namespace.c:4034
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f

Freed by task 5820:
 kasan_save_stack mm/kasan/common.c:47 [inline]
 kasan_save_track+0x3f/0x80 mm/kasan/common.c:68
 kasan_save_free_info+0x40/0x50 mm/kasan/generic.c:582
 poison_slab_object mm/kasan/common.c:247 [inline]
 __kasan_slab_free+0x59/0x70 mm/kasan/common.c:264
 kasan_slab_free include/linux/kasan.h:233 [inline]
 slab_free_hook mm/slub.c:2338 [inline]
 slab_free mm/slub.c:4598 [inline]
 kfree+0x196/0x430 mm/slub.c:4746
 ocfs2_local_free_info+0x81f/0x9a0 fs/ocfs2/quota_local.c:869
 dquot_disable+0x1160/0x1cd0 fs/quota/dquot.c:2304
 dquot_suspend include/linux/quotaops.h:85 [inline]
 ocfs2_susp_quotas+0x16c/0x340 fs/ocfs2/super.c:892
 ocfs2_remount+0x576/0xc30 fs/ocfs2/super.c:647
 reconfigure_super+0x43a/0x870 fs/super.c:1083
 do_remount fs/namespace.c:3047 [inline]
 path_mount+0xc22/0xfa0 fs/namespace.c:3826
 do_mount fs/namespace.c:3847 [inline]
 __do_sys_mount fs/namespace.c:4057 [inline]
 __se_sys_mount+0x2d6/0x3c0 fs/namespace.c:4034
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f

The buggy address belongs to the object at ffff888035461000
 which belongs to the cache kmalloc-1k of size 1024
The buggy address is located 40 bytes inside of
 freed 1024-byte region [ffff888035461000, ffff888035461400)

The buggy address belongs to the physical page:
page: refcount:1 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x35460
head: order:3 mapcount:0 entire_mapcount:0 nr_pages_mapped:0 pincount:0
flags: 0xfff00000000040(head|node=0|zone=1|lastcpupid=0x7ff)
page_type: f5(slab)
raw: 00fff00000000040 ffff88801ac41dc0 ffffea000533c600 0000000000000002
raw: 0000000000000000 0000000080100010 00000001f5000000 0000000000000000
head: 00fff00000000040 ffff88801ac41dc0 ffffea000533c600 0000000000000002
head: 0000000000000000 0000000080100010 00000001f5000000 0000000000000000
head: 00fff00000000003 ffffea0000d51801 ffffffffffffffff 0000000000000000
head: 0000000000000008 0000000000000000 00000000ffffffff 0000000000000000
page dumped because: kasan: bad access detected
page_owner tracks the page as allocated
page last allocated via order 3, migratetype Unmovable, gfp_mask 0xd2040(__GFP_IO|__GFP_NOWARN|__GFP_NORETRY|__GFP_COMP|__GFP_NOMEMALLOC), pid 5485, tgid 5485 (S41dhcpcd), ts 36970568324, free_ts 36970094811
 set_page_owner include/linux/page_owner.h:32 [inline]
 post_alloc_hook+0x1f3/0x230 mm/page_alloc.c:1556
 prep_new_page mm/page_alloc.c:1564 [inline]
 get_page_from_freelist+0x3651/0x37a0 mm/page_alloc.c:3474
 __alloc_pages_noprof+0x292/0x710 mm/page_alloc.c:4751
 alloc_pages_mpol_noprof+0x3e8/0x680 mm/mempolicy.c:2269
 alloc_slab_page+0x6a/0x110 mm/slub.c:2408
 allocate_slab+0x5a/0x2b0 mm/slub.c:2574
 new_slab mm/slub.c:2627 [inline]
 ___slab_alloc+0xc27/0x14a0 mm/slub.c:3815
 __slab_alloc+0x58/0xa0 mm/slub.c:3905
 __slab_alloc_node mm/slub.c:3980 [inline]
 slab_alloc_node mm/slub.c:4141 [inline]
 __do_kmalloc_node mm/slub.c:4282 [inline]
 __kmalloc_noprof+0x2e6/0x4c0 mm/slub.c:4295
 kmalloc_noprof include/linux/slab.h:905 [inline]
 kzalloc_noprof include/linux/slab.h:1037 [inline]
 tomoyo_init_log+0x1b3d/0x2050 security/tomoyo/audit.c:275
 tomoyo_supervisor+0x38a/0x11f0 security/tomoyo/common.c:2089
 tomoyo_audit_env_log security/tomoyo/environ.c:36 [inline]
 tomoyo_env_perm+0x178/0x210 security/tomoyo/environ.c:63
 tomoyo_environ security/tomoyo/domain.c:672 [inline]
 tomoyo_find_next_domain+0x146e/0x1d40 security/tomoyo/domain.c:881
 tomoyo_bprm_check_security+0x117/0x180 security/tomoyo/tomoyo.c:102
 security_bprm_check+0x86/0x250 security/security.c:1296
 search_binary_handler fs/exec.c:1736 [inline]
 exec_binprm fs/exec.c:1790 [inline]
 bprm_execve+0xa53/0x17a0 fs/exec.c:1842
page last free pid 5485 tgid 5485 stack trace:
 reset_page_owner include/linux/page_owner.h:25 [inline]
 free_pages_prepare mm/page_alloc.c:1127 [inline]
 free_unref_page+0xd2c/0x1000 mm/page_alloc.c:2657
 discard_slab mm/slub.c:2673 [inline]
 __put_partials+0x160/0x1c0 mm/slub.c:3142
 put_cpu_partial+0x17c/0x250 mm/slub.c:3217
 __slab_free+0x290/0x380 mm/slub.c:4468
 qlink_free mm/kasan/quarantine.c:163 [inline]
 qlist_free_all+0x9a/0x140 mm/kasan/quarantine.c:179
 kasan_quarantine_reduce+0x14f/0x170 mm/kasan/quarantine.c:286
 __kasan_slab_alloc+0x23/0x80 mm/kasan/common.c:329
 kasan_slab_alloc include/linux/kasan.h:250 [inline]
 slab_post_alloc_hook mm/slub.c:4104 [inline]
 slab_alloc_node mm/slub.c:4153 [inline]
 __do_kmalloc_node mm/slub.c:4282 [inline]
 __kmalloc_noprof+0x236/0x4c0 mm/slub.c:4295
 kmalloc_noprof include/linux/slab.h:905 [inline]
 tomoyo_add_entry security/tomoyo/common.c:2023 [inline]
 tomoyo_supervisor+0xe0d/0x11f0 security/tomoyo/common.c:2095
 tomoyo_audit_env_log security/tomoyo/environ.c:36 [inline]
 tomoyo_env_perm+0x178/0x210 security/tomoyo/environ.c:63
 tomoyo_environ security/tomoyo/domain.c:672 [inline]
 tomoyo_find_next_domain+0x146e/0x1d40 security/tomoyo/domain.c:881
 tomoyo_bprm_check_security+0x117/0x180 security/tomoyo/tomoyo.c:102
 security_bprm_check+0x86/0x250 security/security.c:1296
 search_binary_handler fs/exec.c:1736 [inline]
 exec_binprm fs/exec.c:1790 [inline]
 bprm_execve+0xa53/0x17a0 fs/exec.c:1842
 do_execveat_common+0x55f/0x6f0 fs/exec.c:1949
 do_execve fs/exec.c:2023 [inline]
 __do_sys_execve fs/exec.c:2099 [inline]
 __se_sys_execve fs/exec.c:2094 [inline]
 __x64_sys_execve+0x92/0xb0 fs/exec.c:2094

Memory state around the buggy address:
 ffff888035460f00: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
 ffff888035460f80: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
>ffff888035461000: fa fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
                                  ^
 ffff888035461080: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
 ffff888035461100: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
==================================================================


---
If you want syzbot to run the reproducer, reply with:
#syz test: git://repo/address.git branch-or-commit-hash
If you attach or paste a git patch, syzbot will apply it before testing.
