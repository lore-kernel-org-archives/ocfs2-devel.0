Received: from mail-il1-f199.google.com (mail-il1-f199.google.com [209.85.166.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9B64139D1B
	for <ocfs2-devel@lists.linux.dev>; Fri, 27 Sep 2024 14:22:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727446954; cv=none; b=eD7rd2IT8gzIV62Nsvs8MfXBSSNZosB/NsDGwjobv7BGYRPqzUlIEF5qJFQrQAjKznYaRSc84g5abp2pJ12pyha95MhDkNkCVq6P8f4XtV+zZdFPZIBQa/Kg8OsZWlIz6avQ2C95fNLMAMhDskGcYgUMRfqRqFaXMiKPruHT5B8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727446954; c=relaxed/simple;
	bh=3FczA7AobfLgZQr28zdTwGPi8mMRJ9sE+8Oe5Ra701g=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=IFso/7UjNdKwQNE5TGNUOSxzELNlpyXm3mNGVLZfdK9mHw5DR3ZzIzwoGKG2DH27Riz5r/kzk1pQaNgLkwtyv2WUFcUnddht6dN9EUxSDnyRL4Fz06em2b7lLHQlqr+0LVKRNRfhrWBr7L2IT6W21UqRADlFLYQQ0OZtx5RckPo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f199.google.com with SMTP id e9e14a558f8ab-3a0cadb1536so23934075ab.3
        for <ocfs2-devel@lists.linux.dev>; Fri, 27 Sep 2024 07:22:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727446952; x=1728051752;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Fw4xmU6GpRJTjF1S/NmnMFH01B1zeuNXnSIGAPqNETA=;
        b=V0pdqKfH+rp969GYf8gTVh1L3K8tiUWPNgheQ1+n9A6g1kL102mqw5V6uioRRp4BBj
         Mo5/uhFr2hc8BpaRlJ0RIee6QHr2NpcoLzxSCy+e2c7bh6BV5AM4eAUUbQ1bsEtEkZuo
         rUBMmMwauiXDAuH8OAjuuCKiqFSdqNzStJRxFdaarO+HQzlkOYhaoCYIM7BhIK4BKaqL
         +C0NKR6nT+r2YPDc/3sXDK+zqZWuiKNB1AGVuTkuW8VHtgZBsjdtnMh0hZx+xKesCNJN
         I7cA6Xd2TfqHNOvi+v14/MeR0ztHl1nZ3XTtcufkSc14sjdFcvg3aysEu35Wo4fuxrgQ
         jpbA==
X-Forwarded-Encrypted: i=1; AJvYcCXaF7AMB0i0hc6foudre8UJFjKG5/RYxT5gQR35TyNbVuhHCi+ChLW//LznLvsjPZeFExzh8eosZZsPAA==@lists.linux.dev
X-Gm-Message-State: AOJu0YwM4Fq9VgyGLDu0DWwePl1XjoDHeX+3teERcuFczwPcL1OuXyAV
	AdgyNDI3hIaws9GHjtw+df+AETMWA0447CQya55Iot7c9li3Q5gvPp4o5w2LAMVc6+P0XFN6rxB
	0lrgN/phuwiVGNaP1pz+PrpMDq53uIqBFx66UQ4bKc2IDvNXEaF3AJ28=
X-Google-Smtp-Source: AGHT+IGB8L7l5TJGmygAtpk/EFeIknJHc0WE28kgq1N/sYGnTQuUlRyrxEIZWqIBFMg0Is9QROkpKwVHbQ5gD8hqkjV4fvV9bTPY
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a92:ca0c:0:b0:3a0:533e:3c0a with SMTP id
 e9e14a558f8ab-3a345165300mr38449615ab.7.1727446952044; Fri, 27 Sep 2024
 07:22:32 -0700 (PDT)
Date: Fri, 27 Sep 2024 07:22:31 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <66f6bfa7.050a0220.38ace9.001a.GAE@google.com>
Subject: [syzbot] [ocfs2?] KASAN: use-after-free Read in ocfs2_dir_foreach_blk
From: syzbot <syzbot+b20bbf680bb0f2ecedae@syzkaller.appspotmail.com>
To: jlbec@evilplan.org, joseph.qi@linux.alibaba.com, 
	linux-kernel@vger.kernel.org, mark@fasheh.com, ocfs2-devel@lists.linux.dev, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    88264981f208 Merge tag 'sched_ext-for-6.12' of git://git.k..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=15e9de9f980000
kernel config:  https://syzkaller.appspot.com/x/.config?x=e851828834875d6f
dashboard link: https://syzkaller.appspot.com/bug?extid=b20bbf680bb0f2ecedae
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/7bc7510fe41f/non_bootable_disk-88264981.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/df2a0a047a7a/vmlinux-88264981.xz
kernel image: https://storage.googleapis.com/syzbot-assets/bbdb25081712/bzImage-88264981.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+b20bbf680bb0f2ecedae@syzkaller.appspotmail.com

loop0: detected capacity change from 0 to 32768
=======================================================
WARNING: The mand mount option has been deprecated and
         and is ignored by this kernel. Remove the mand
         option from the mount to silence this warning.
=======================================================
ocfs2: Mounting device (7,0) on (node local, slot 0) with ordered data mode.
overlayfs: upper fs does not support tmpfile.
overlayfs: upper fs does not support RENAME_WHITEOUT.
overlayfs: upper fs missing required features.
==================================================================
BUG: KASAN: use-after-free in ocfs2_check_dir_entry fs/ocfs2/dir.c:305 [inline]
BUG: KASAN: use-after-free in ocfs2_dir_foreach_blk_id fs/ocfs2/dir.c:1784 [inline]
BUG: KASAN: use-after-free in ocfs2_dir_foreach_blk+0x1704/0x1b20 fs/ocfs2/dir.c:1912
Read of size 2 at addr ffff88804d20b008 by task syz.0.0/5119

CPU: 0 UID: 0 PID: 5119 Comm: syz.0.0 Not tainted 6.11.0-syzkaller-08481-g88264981f208 #0
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2~bpo12+1 04/01/2014
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:94 [inline]
 dump_stack_lvl+0x241/0x360 lib/dump_stack.c:120
 print_address_description mm/kasan/report.c:377 [inline]
 print_report+0x169/0x550 mm/kasan/report.c:488
 kasan_report+0x143/0x180 mm/kasan/report.c:601
 ocfs2_check_dir_entry fs/ocfs2/dir.c:305 [inline]
 ocfs2_dir_foreach_blk_id fs/ocfs2/dir.c:1784 [inline]
 ocfs2_dir_foreach_blk+0x1704/0x1b20 fs/ocfs2/dir.c:1912
 ocfs2_readdir+0x2a1/0x5e0 fs/ocfs2/dir.c:1956
 wrap_directory_iterator+0x91/0xd0 fs/readdir.c:65
 iterate_dir+0x571/0x800 fs/readdir.c:108
 __do_sys_getdents64 fs/readdir.c:407 [inline]
 __se_sys_getdents64+0x20d/0x4f0 fs/readdir.c:392
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f9e2d77def9
Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 a8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f9e2e4f8038 EFLAGS: 00000246 ORIG_RAX: 00000000000000d9
RAX: ffffffffffffffda RBX: 00007f9e2d935f80 RCX: 00007f9e2d77def9
RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000008
RBP: 00007f9e2d7f0b76 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 0000000000000000 R14: 00007f9e2d935f80 R15: 00007ffd76550ee8
 </TASK>

The buggy address belongs to the physical page:
page: refcount:0 mapcount:0 mapping:0000000000000000 index:0x20001 pfn:0x4d20b
flags: 0x4fff00000000000(node=1|zone=1|lastcpupid=0x7ff)
raw: 04fff00000000000 ffffea0001347788 ffffea0001347808 0000000000000000
raw: 0000000000020001 0000000000000000 00000000ffffffff 0000000000000000
page dumped because: kasan: bad access detected
page_owner tracks the page as freed
page last allocated via order 0, migratetype Movable, gfp_mask 0x140cca(GFP_HIGHUSER_MOVABLE|__GFP_COMP), pid 5119, tgid 5118 (syz.0.0), ts 141582230460, free_ts 141702836739
 set_page_owner include/linux/page_owner.h:32 [inline]
 post_alloc_hook+0x1f3/0x230 mm/page_alloc.c:1537
 prep_new_page mm/page_alloc.c:1545 [inline]
 get_page_from_freelist+0x3045/0x3190 mm/page_alloc.c:3457
 __alloc_pages_noprof+0x256/0x6c0 mm/page_alloc.c:4733
 alloc_pages_mpol_noprof+0x3e8/0x680 mm/mempolicy.c:2265
 folio_alloc_mpol_noprof+0x36/0x50 mm/mempolicy.c:2283
 __read_swap_cache_async+0x250/0x8e0 mm/swap_state.c:477
 swap_cluster_readahead+0x674/0x7f0 mm/swap_state.c:703
 swapin_readahead+0x1bb/0xdf0 mm/swap_state.c:882
 do_swap_page+0x584/0x7b30 mm/memory.c:4324
 handle_pte_fault+0x61d/0x6800 mm/memory.c:5754
 __handle_mm_fault mm/memory.c:5894 [inline]
 handle_mm_fault+0x1106/0x1bb0 mm/memory.c:6062
 do_user_addr_fault arch/x86/mm/fault.c:1389 [inline]
 handle_page_fault arch/x86/mm/fault.c:1481 [inline]
 exc_page_fault+0x2b9/0x8c0 arch/x86/mm/fault.c:1539
 asm_exc_page_fault+0x26/0x30 arch/x86/include/asm/idtentry.h:623
page last free pid 5119 tgid 5118 stack trace:
 reset_page_owner include/linux/page_owner.h:25 [inline]
 free_pages_prepare mm/page_alloc.c:1108 [inline]
 free_unref_folios+0xf12/0x18d0 mm/page_alloc.c:2686
 folios_put_refs+0x76c/0x860 mm/swap.c:1007
 free_pages_and_swap_cache+0x5c8/0x690 mm/swap_state.c:335
 __tlb_batch_free_encoded_pages mm/mmu_gather.c:136 [inline]
 tlb_batch_pages_flush mm/mmu_gather.c:149 [inline]
 tlb_flush_mmu_free mm/mmu_gather.c:366 [inline]
 tlb_flush_mmu+0x3a3/0x680 mm/mmu_gather.c:373
 tlb_finish_mmu+0xd4/0x200 mm/mmu_gather.c:465
 vms_clear_ptes+0x437/0x530 mm/vma.c:1096
 vms_clean_up_area+0x62/0x1c0 mm/vma.c:1108
 mmap_region+0x1a84/0x2990 mm/mmap.c:1439
 do_mmap+0x8f0/0x1000 mm/mmap.c:496
 vm_mmap_pgoff+0x1dd/0x3d0 mm/util.c:588
 ksys_mmap_pgoff+0x4eb/0x720 mm/mmap.c:542
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f

Memory state around the buggy address:
 ffff88804d20af00: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
 ffff88804d20af80: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
>ffff88804d20b000: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
                      ^
 ffff88804d20b080: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
 ffff88804d20b100: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
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
