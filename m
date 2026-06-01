Received: from mail-ot1-f78.google.com (mail-ot1-f78.google.com [209.85.210.78])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82AA3220F2A
	for <ocfs2-devel@lists.linux.dev>; Mon,  1 Jun 2026 22:52:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.78
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780354347; cv=none; b=QEqYc0QPopnxv7r79tMFWJu2hnOJ2tN48pa5rmek80pEbnea/vr+m2Xt1HOo+JLYqk3rWYgezsVd8/kmQR+LbxOhOSRAIzAe9ieHSGJUVEgyWjk3Bg5oLOmsOspjraDY9BpG+QtU8tEJJXtkJO/TcwTjJxqXjnfSkYQznh5KgEw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780354347; c=relaxed/simple;
	bh=UeQMpUkqVdo4pTtCcOKSAKn2rF59ddXOniBS4mGYuBw=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=XQB5SbcVcgsAT1zCUng0Z/EglPX+4ThMXMFeeCSIqUmU+MgXx9jPw2v85OJ3F4P02g/MMQ3DP5cDwtoC4j64ucakhfrZxs/cWmjHT9lF9j3wMgsRMfPfn4uYu9afDkXEFq72QtNKIg5hSnJHsxjRQFWCEqQvS5V28vJNVV6RdAs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.210.78
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-ot1-f78.google.com with SMTP id 46e09a7af769-7e666c30bdeso8174863a34.3
        for <ocfs2-devel@lists.linux.dev>; Mon, 01 Jun 2026 15:52:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780354344; x=1780959144;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=J+YfRQnNaCiD2QGi+7y21W59p3JLuXPZr9+AimKqDsk=;
        b=nSwyN4BEDMwhhL/OS52pfCl8+IaMQiQeP3pAcxrxb4t8nrB6gcxWPld32gd6hzeECJ
         OCS9wZigS+BGbVoOnfkt0XFtIiEjbtniyS48ZtGISLLJ5xNrPKMoAXIA7ROnAN9RLBmD
         pGX1ILwRK9/L90R3wK9fXfDXQBduSHypHzOygFpray7zU7cLbRFfy5duHOfxrR2FPtb2
         4+i+pR2x1l8kNqCCZ7QyFNFouFQrRXfs4YbkfA9O+OTim/28ZBtoe/Sbvj3QznbxoKJd
         fUGliBQiqLL5N9Xs368VM7nROHlzqwyijUjRmfxy5R4WtHXCN/viBzQHnkgu7WsMKkUa
         pnkA==
X-Forwarded-Encrypted: i=1; AFNElJ8mZM8nGN2bCuHYfjqltZWoExhyjAgihaIrFYXJNgYGbLpOEqK+V7dgT49GoBgE72JX+7Nt+wKolQwh+g==@lists.linux.dev
X-Gm-Message-State: AOJu0Ywr8sZMKjLIFUdSWiJ/fH5wPUgdyYR/Y6ZXEhsiTjByg4Z0cIpm
	hZasklGDi/Zpi6W0twud4eicUhFvbSDeKSbBo7t8rji3CkXN8ZiLdkX93zAns3XNL5cl8uO5R+q
	Sqx/gkta8WqqRXNg4R7L4wmaHW3VK9k32wPzZERLSGrOx1bvhKELhl8DComI=
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6820:1c81:b0:69d:9a17:deaf with SMTP id
 006d021491bc7-69e104770b8mr7116316eaf.11.1780354344561; Mon, 01 Jun 2026
 15:52:24 -0700 (PDT)
Date: Mon, 01 Jun 2026 15:52:24 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6a1e0d28.3b158e77.2846f8.0586.GAE@google.com>
Subject: [syzbot] [ocfs2?] KASAN: use-after-free Read in ocfs2_duplicate_inline_data
From: syzbot <syzbot+e400b192d6ca035354ee@syzkaller.appspotmail.com>
To: jlbec@evilplan.org, joseph.qi@linux.alibaba.com, 
	linux-kernel@vger.kernel.org, mark@fasheh.com, ocfs2-devel@lists.linux.dev, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    e5d505e3664b Merge tag 'trace-v7.1-rc3' of git://git.kerne..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=1713302e580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=7f195f6be48c12ec
dashboard link: https://syzkaller.appspot.com/bug?extid=e400b192d6ca035354ee
compiler:       Debian clang version 21.1.8 (++20251221033036+2078da43e25a-1~exp1~20251221153213.50), Debian LLD 21.1.8

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/d900f083ada3/non_bootable_disk-e5d505e3.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/e34834fd8b3d/vmlinux-e5d505e3.xz
kernel image: https://storage.googleapis.com/syzbot-assets/83271095636f/bzImage-e5d505e3.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+e400b192d6ca035354ee@syzkaller.appspotmail.com

==================================================================
BUG: KASAN: use-after-free in ocfs2_duplicate_inline_data+0x3ae/0x570 fs/ocfs2/refcounttree.c:3946
Read of size 8483 at addr ffff88800bbc56c8 by task syz.0.0/5335

CPU: 0 UID: 0 PID: 5335 Comm: syz.0.0 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
Call Trace:
 <TASK>
 dump_stack_lvl+0xe8/0x150 lib/dump_stack.c:120
 print_address_description+0x55/0x1e0 mm/kasan/report.c:378
 print_report+0x58/0x70 mm/kasan/report.c:482
 kasan_report+0x117/0x150 mm/kasan/report.c:595
 check_region_inline mm/kasan/generic.c:-1 [inline]
 kasan_check_range+0x264/0x2c0 mm/kasan/generic.c:200
 __asan_memcpy+0x29/0x70 mm/kasan/shadow.c:105
 ocfs2_duplicate_inline_data+0x3ae/0x570 fs/ocfs2/refcounttree.c:3946
 ocfs2_reflink_remap_blocks+0xfcf/0x1a30 fs/ocfs2/refcounttree.c:4625
 ocfs2_remap_file_range+0x451/0x6f0 fs/ocfs2/file.c:2747
 vfs_copy_file_range+0xd80/0x1370 fs/read_write.c:1600
 __do_sys_copy_file_range fs/read_write.c:1683 [inline]
 __se_sys_copy_file_range+0x2fb/0x480 fs/read_write.c:1650
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0x15f/0xf80 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7feeb9d9ce59
Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007feebacb8fe8 EFLAGS: 00000246 ORIG_RAX: 0000000000000146
RAX: ffffffffffffffda RBX: 00007feeba016090 RCX: 00007feeb9d9ce59
RDX: 0000000000000005 RSI: 00002000000001c0 RDI: 0000000000000006
RBP: 00007feeb9e32d6f R08: ffffffffa003e45b R09: 0700000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007feeba016128 R14: 00007feeba016090 R15: 00007ffccb81aac8
 </TASK>

The buggy address belongs to the physical page:
page: refcount:2 mapcount:0 mapping:ffff88801cc25940 index:0x854 pfn:0xbbc5
memcg:ffff888036579480
aops:def_blk_aops ino:700000 dentry name(?):""
flags: 0xfff98000004224(referenced|lru|workingset|private|node=0|zone=1|lastcpupid=0x7ff)
raw: 00fff98000004224 ffff88801c6e5600 ffffea00004a7b48 ffff88801cc25940
raw: 0000000000000854 ffff888046e8c1d0 00000002ffffffff ffff888036579480
page dumped because: kasan: bad access detected
page_owner tracks the page as allocated
page last allocated via order 0, migratetype Movable, gfp_mask 0x148c48(GFP_NOFS|__GFP_MOVABLE|__GFP_NOFAIL|__GFP_COMP|__GFP_HARDWALL), pid 5334, tgid 5333 (syz.0.0), ts 85585712597, free_ts 85544039740
 set_page_owner include/linux/page_owner.h:32 [inline]
 post_alloc_hook+0x231/0x280 mm/page_alloc.c:1858
 prep_new_page mm/page_alloc.c:1866 [inline]
 get_page_from_freelist+0x24ba/0x2540 mm/page_alloc.c:3946
 __alloc_frozen_pages_noprof+0x18d/0x380 mm/page_alloc.c:5226
 alloc_pages_mpol+0x235/0x490 mm/mempolicy.c:2490
 alloc_frozen_pages_noprof mm/mempolicy.c:2561 [inline]
 alloc_pages_noprof+0xac/0x2a0 mm/mempolicy.c:2581
 folio_alloc_noprof+0x1e/0x30 mm/mempolicy.c:2591
 filemap_alloc_folio_noprof+0x111/0x470 mm/filemap.c:1014
 __filemap_get_folio_mpol+0x3fc/0xb00 mm/filemap.c:2012
 __filemap_get_folio include/linux/pagemap.h:763 [inline]
 grow_dev_folio fs/buffer.c:954 [inline]
 grow_buffers fs/buffer.c:1020 [inline]
 __getblk_slow fs/buffer.c:1038 [inline]
 bdev_getblk+0x1f6/0x6e0 fs/buffer.c:1358
 __getblk include/linux/buffer_head.h:380 [inline]
 sb_getblk include/linux/buffer_head.h:386 [inline]
 ocfs2_read_blocks+0x56d/0x1530 fs/ocfs2/buffer_head_io.c:236
 ocfs2_read_inode_block_full fs/ocfs2/inode.c:1745 [inline]
 ocfs2_read_inode_block+0xec/0x1d0 fs/ocfs2/inode.c:1759
 ocfs2_assign_bh fs/ocfs2/dlmglue.c:2415 [inline]
 ocfs2_inode_lock_full_nested+0x2ac/0x1bd0 fs/ocfs2/dlmglue.c:2510
 ocfs2_reflink_inodes_lock+0x489/0xc20 fs/ocfs2/refcounttree.c:4743
 ocfs2_remap_file_range+0x236/0x6f0 fs/ocfs2/file.c:2721
 vfs_copy_file_range+0xd80/0x1370 fs/read_write.c:1600
 __do_sys_copy_file_range fs/read_write.c:1683 [inline]
 __se_sys_copy_file_range+0x2fb/0x480 fs/read_write.c:1650
page last free pid 5338 tgid 5333 stack trace:
 reset_page_owner include/linux/page_owner.h:25 [inline]
 __free_pages_prepare mm/page_alloc.c:1402 [inline]
 free_unref_folios+0xcec/0x1480 mm/page_alloc.c:3004
 folios_put_refs+0x9ff/0xb40 mm/swap.c:1008
 folio_batch_release include/linux/folio_batch.h:101 [inline]
 mapping_try_invalidate+0x3c2/0x4c0 mm/truncate.c:579
 loop_set_status+0x29b/0xe40 drivers/block/loop.c:1246
 loop_set_status_old drivers/block/loop.c:1362 [inline]
 lo_ioctl+0xce6/0x1fb0 drivers/block/loop.c:1551
 blkdev_ioctl+0x5e3/0x740 block/ioctl.c:797
 vfs_ioctl fs/ioctl.c:51 [inline]
 __do_sys_ioctl fs/ioctl.c:597 [inline]
 __se_sys_ioctl+0xfc/0x170 fs/ioctl.c:583
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0x15f/0xf80 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f

Memory state around the buggy address:
 ffff88800bbc5f00: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
 ffff88800bbc5f80: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
>ffff88800bbc6000: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
                   ^
 ffff88800bbc6080: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
 ffff88800bbc6100: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
==================================================================


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
