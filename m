Received: from mail-oo1-f80.google.com (mail-oo1-f80.google.com [209.85.161.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B1A230DEDC
	for <ocfs2-devel@lists.linux.dev>; Thu,  2 Apr 2026 10:40:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775126427; cv=none; b=hAxpUQVoeC4FKa0EgItBoBHKqqlBug3QKN88cYba5xRYszltWMh7z+eSoRTr8BunwEF8agYone1YnsZI0+Xn1/Ero9UqTZjW+CbmYJVLupZg+Dlj3bLd89nZWVtPja1g2L0Ti6+K2QzGgdzA9xC9L5pr8SVXNr9uvyOUFmDF5TU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775126427; c=relaxed/simple;
	bh=tiR985HdEQrbaoerAM1P5XF8T+CB3QSZQTCLPRT8/7s=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=cQL+StoiDnRiMVzCaYJ/OTDYhb3iN4e4aPjl+pORKDz4SEd0fY/DWGhxAs3wsZNIvGkrbOSlVc7xVvbMtHjV9fgIa/v+EYeNJuV321xiqmdAgL5Z18MnrQ1JEiE+aYpcyuAzFaGTPgNknBqEE/cVtSUJskacFuzz0zt6hc7STsg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.161.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oo1-f80.google.com with SMTP id 006d021491bc7-680b7befb84so1224398eaf.3
        for <ocfs2-devel@lists.linux.dev>; Thu, 02 Apr 2026 03:40:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775126425; x=1775731225;
        h=content-transfer-encoding:to:from:subject:message-id:date
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=JzBqfEUVhlwH4mFgFBsMGv4JSiXOFzpAI2nq4E1o5vY=;
        b=dDzvCX0Q9ZJjt8qc6SNH45IYsKK9PvhHz9tPqoERwNzUFMRBFj78VB1oVRdDxCehM5
         bpqNHAr1APzSYFnnCewR8B6Z70YDzoyJc5y7huVNJ6IlB4lflbyzvTO+IGWf2Md717/+
         9rfRI2bwVEClnKO1x2394L6WFDzVIBVGkaQwm7Kc0LiqqnDHcr4n9hk5tWJn4CHLiceU
         auVmUBPUV4lZEAphz8DkIv2Q3R9PmJm8K/3dW9W0ji1zCCNDKknprNJx2BBvKddaV0y0
         oiqFieDFAhEWDHqhbwVVbG7qtUjCJh/v9q4D8cUNYezO945wXIMWf3S5wXu1pRFwCKSx
         g4qQ==
X-Forwarded-Encrypted: i=1; AJvYcCWRuJsPSygU3yfbhJIdtcPAiYQzsVTnDzTo30PdC5yHaNey5LBsAg114hHM/Jpwafz4CmSgpAL8HMIiHQ==@lists.linux.dev
X-Gm-Message-State: AOJu0YxC0cE7ES4MMiRvO3XG+50B6Tpxnlm3+THAfg1yCFgy1cV5XhwK
	Vm6q7BLSD4xmSmlVLtCoGGd4xoxQsheEjbs8fDxq/TJ8bJuQnrpO75tyt7vXcFpIOGie0gayhP2
	OjFj/VF912Mu0gS7FOUWApSoms4Z7Lr2Ol81g6VkiNbZbaKpTWuCdC3ScLQw=
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6820:997:b0:680:17e0:4435 with SMTP id
 006d021491bc7-680a796f195mr1631189eaf.31.1775126425317; Thu, 02 Apr 2026
 03:40:25 -0700 (PDT)
Date: Thu, 02 Apr 2026 03:40:25 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <69ce4799.050a0220.2dbe29.0003.GAE@google.com>
Subject: [syzbot] [ocfs2?] KASAN: use-after-free Write in ocfs2_write_end_nolock
From: syzbot <syzbot+62c1793956716ea8b28a@syzkaller.appspotmail.com>
To: jlbec@evilplan.org, joseph.qi@linux.alibaba.com, 
	linux-kernel@vger.kernel.org, mark@fasheh.com, ocfs2-devel@lists.linux.dev, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hello,

syzbot found the following issue on:

HEAD commit:    9147566d8016 Merge tag 'sched_ext-for-7.0-rc6-fixes' of gi.=
.
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=3D13ec1516580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=3Dd46eab0cfd31c21=
4
dashboard link: https://syzkaller.appspot.com/bug?extid=3D62c1793956716ea8b=
28a
compiler:       Debian clang version 21.1.8 (++20251221033036+2078da43e25a-=
1~exp1~20251221153213.50), Debian LLD 21.1.8

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/d90=
0f083ada3/non_bootable_disk-9147566d.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/ccabfb43ed2d/vmlinux-=
9147566d.xz
kernel image: https://storage.googleapis.com/syzbot-assets/2106f2f69253/bzI=
mage-9147566d.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit=
:
Reported-by: syzbot+62c1793956716ea8b28a@syzkaller.appspotmail.com

loop0: detected capacity change from 0 to 32768
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D
WARNING: The mand mount option has been deprecated and
         and is ignored by this kernel. Remove the mand
         option from the mount to silence this warning.
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D
JBD2: Ignoring recovery information on journal
ocfs2: Mounting device (7,0) on (node local, slot 0) with ordered data mode=
.
(syz.0.0,5322,0):ocfs2_check_set_options:1244 ERROR: Invalid heartbeat moun=
t options
loop0: detected capacity change from 32768 to 32767
OCFS2: ERROR (device loop0): int ocfs2_validate_inode_block(struct super_bl=
ock *, struct buffer_head *): Invalid dinode #17058: signature =3D =EF=BF=
=BD=EF=BF=BD=1A=EF=BF=BD
On-disk corruption discovered. Please run fsck.ocfs2 once the filesystem is=
 unmounted.
OCFS2: File system is now read-only.
(syz.0.0,5322,0):ocfs2_assign_bh:2417 ERROR: status =3D -30
(syz.0.0,5322,0):ocfs2_inode_lock_full_nested:2512 ERROR: status =3D -30
(syz.0.0,5322,0):ocfs2_reflink_inodes_lock:4748 ERROR: status =3D -30
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
BUG: KASAN: use-after-free in memcpy_from_folio include/linux/highmem.h:586=
 [inline]
BUG: KASAN: use-after-free in ocfs2_write_end_inline fs/ocfs2/aops.c:1915 [=
inline]
BUG: KASAN: use-after-free in ocfs2_write_end_nolock+0xbd9/0x18f0 fs/ocfs2/=
aops.c:1949
Write of size 4086 at addr ffff888056da54d2 by task syz.0.0/5322

CPU: 0 UID: 0 PID: 5322 Comm: syz.0.0 Not tainted syzkaller #0 PREEMPT(full=
)=20
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16=
.3-2 04/01/2014
Call Trace:
 <TASK>
 dump_stack_lvl+0xe8/0x150 lib/dump_stack.c:120
 print_address_description mm/kasan/report.c:378 [inline]
 print_report+0xba/0x230 mm/kasan/report.c:482
 kasan_report+0x117/0x150 mm/kasan/report.c:595
 check_region_inline mm/kasan/generic.c:-1 [inline]
 kasan_check_range+0x264/0x2c0 mm/kasan/generic.c:200
 __asan_memcpy+0x40/0x70 mm/kasan/shadow.c:106
 memcpy_from_folio include/linux/highmem.h:586 [inline]
 ocfs2_write_end_inline fs/ocfs2/aops.c:1915 [inline]
 ocfs2_write_end_nolock+0xbd9/0x18f0 fs/ocfs2/aops.c:1949
 ocfs2_write_end+0x58/0x90 fs/ocfs2/aops.c:2059
 generic_perform_write+0x620/0x8f0 mm/filemap.c:4340
 ocfs2_file_write_iter+0x1663/0x1ed0 fs/ocfs2/file.c:2476
 iter_file_splice_write+0x9a1/0x10f0 fs/splice.c:736
 do_splice_from fs/splice.c:936 [inline]
 direct_splice_actor+0x101/0x160 fs/splice.c:1159
 splice_direct_to_actor+0x53a/0xc70 fs/splice.c:1103
 do_splice_direct_actor fs/splice.c:1202 [inline]
 do_splice_direct+0x195/0x290 fs/splice.c:1228
 vfs_copy_file_range+0xb02/0x1370 fs/read_write.c:1634
 __do_sys_copy_file_range fs/read_write.c:1683 [inline]
 __se_sys_copy_file_range+0x2fb/0x480 fs/read_write.c:1650
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0x14d/0xf80 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f08bb59c819
Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f7 =
48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff f=
f 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f08bc45dfe8 EFLAGS: 00000246 ORIG_RAX: 0000000000000146
RAX: ffffffffffffffda RBX: 00007f08bb815fa0 RCX: 00007f08bb59c819
RDX: 0000000000000004 RSI: 00002000000001c0 RDI: 0000000000000005
RBP: 00007f08bb632c91 R08: ffffffffa003e45b R09: 0700000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007f08bb816038 R14: 00007f08bb815fa0 R15: 00007ffcc83fcca8
 </TASK>

The buggy address belongs to the physical page:
page: refcount:2 mapcount:0 mapping:ffff88801cc2e6c8 index:0x854 pfn:0x56da=
5
memcg:ffff88801c6c0d40
aops:def_blk_aops ino:700000 dentry name(?):""
flags: 0x4fff38000004224(referenced|lru|workingset|private|node=3D1|zone=3D=
1|lastcpupid=3D0x7ff)
raw: 04fff38000004224 ffffea000112e0c8 ffff8880304509e0 ffff88801cc2e6c8
raw: 0000000000000854 ffff888055d47488 00000002ffffffff ffff88801c6c0d40
page dumped because: kasan: bad access detected
page_owner tracks the page as allocated
page last allocated via order 0, migratetype Movable, gfp_mask 0x148c48(GFP=
_NOFS|__GFP_MOVABLE|__GFP_NOFAIL|__GFP_COMP|__GFP_HARDWALL), pid 5322, tgid=
 5321 (syz.0.0), ts 84485822747, free_ts 84440366295
 set_page_owner include/linux/page_owner.h:32 [inline]
 post_alloc_hook+0x231/0x280 mm/page_alloc.c:1889
 prep_new_page mm/page_alloc.c:1897 [inline]
 get_page_from_freelist+0x24dc/0x2580 mm/page_alloc.c:3962
 __alloc_frozen_pages_noprof+0x18d/0x380 mm/page_alloc.c:5250
 alloc_pages_mpol+0x232/0x4a0 mm/mempolicy.c:2490
 alloc_frozen_pages_noprof mm/mempolicy.c:2561 [inline]
 alloc_pages_noprof+0xa8/0x1a0 mm/mempolicy.c:2581
 folio_alloc_noprof+0x1e/0x30 mm/mempolicy.c:2591
 filemap_alloc_folio_noprof+0x111/0x470 mm/filemap.c:1013
 __filemap_get_folio_mpol+0x3fc/0xb00 mm/filemap.c:2011
 __filemap_get_folio include/linux/pagemap.h:763 [inline]
 grow_dev_folio fs/buffer.c:1047 [inline]
 grow_buffers fs/buffer.c:1113 [inline]
 __getblk_slow fs/buffer.c:1131 [inline]
 bdev_getblk+0x1f6/0x6e0 fs/buffer.c:1458
 __getblk include/linux/buffer_head.h:380 [inline]
 sb_getblk include/linux/buffer_head.h:386 [inline]
 ocfs2_read_blocks+0x57e/0x15e0 fs/ocfs2/buffer_head_io.c:236
 ocfs2_read_inode_block_full fs/ocfs2/inode.c:1735 [inline]
 ocfs2_read_inode_block+0xec/0x1d0 fs/ocfs2/inode.c:1749
 ocfs2_assign_bh fs/ocfs2/dlmglue.c:2415 [inline]
 ocfs2_inode_lock_full_nested+0x2ac/0x1bd0 fs/ocfs2/dlmglue.c:2510
 ocfs2_reflink_inodes_lock+0x477/0xc50 fs/ocfs2/refcounttree.c:4744
 ocfs2_remap_file_range+0x236/0x6f0 fs/ocfs2/file.c:2721
 vfs_copy_file_range+0xd80/0x1370 fs/read_write.c:1600
 __do_sys_copy_file_range fs/read_write.c:1683 [inline]
 __se_sys_copy_file_range+0x2fb/0x480 fs/read_write.c:1650
page last free pid 5322 tgid 5321 stack trace:
 reset_page_owner include/linux/page_owner.h:25 [inline]
 __free_pages_prepare mm/page_alloc.c:1433 [inline]
 free_unref_folios+0xed5/0x16d0 mm/page_alloc.c:3040
 folios_put_refs+0x789/0x8d0 mm/swap.c:1002
 folio_batch_release include/linux/pagevec.h:101 [inline]
 mapping_try_invalidate+0x3c2/0x4c0 mm/truncate.c:579
 loop_set_status+0x29b/0xe40 drivers/block/loop.c:1246
 loop_set_status_old drivers/block/loop.c:1362 [inline]
 lo_ioctl+0xce6/0x1fb0 drivers/block/loop.c:1551
 blkdev_ioctl+0x5e3/0x740 block/ioctl.c:804
 vfs_ioctl fs/ioctl.c:51 [inline]
 __do_sys_ioctl fs/ioctl.c:597 [inline]
 __se_sys_ioctl+0xfc/0x170 fs/ioctl.c:583
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0x14d/0xf80 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f

Memory state around the buggy address:
 ffff888056da5f00: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
 ffff888056da5f80: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
>ffff888056da6000: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
                   ^
 ffff888056da6080: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
 ffff888056da6100: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D


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
