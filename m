Received: from mail-io1-f77.google.com (mail-io1-f77.google.com [209.85.166.77])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFCDF2836BF
	for <ocfs2-devel@lists.linux.dev>; Wed, 18 Jun 2025 09:49:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.77
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750240173; cv=none; b=JiCdcc1F9Xm4wmbvd3i9O9pzUqIXLJsytE9SoQNmjNobtdCfgAnWEfrVhDB4ei4X11VvOXVwsstAr9eN/mtC8yvxebf9ouyW1QVWC8K0j9W/qLOgry4kqlBsrZyqGqK9QPNQary7vyVJx0NeBSxOCK4Z4JkRBZro+ZYumJPo5OA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750240173; c=relaxed/simple;
	bh=nrUwvMp60Uj4/1DqmUYif4E7pP+xe9DgCT1XIMiT3dk=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=k3fCnIfMIpD2Ovx6iltAQSG4c2asZJ8nnTVPq0crcneyVkTL9tAlkmaC8z/yPpSSMHK0zH/8b4XsIu7TaexeRWTsOc24CKDbu5OzfZeUrQmLDCi/N/rcnMrCqtahREvI58HTaoS+iw7LN4qytlTn2zIzGBEAvvzZN8DVC5pgCvE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.77
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-io1-f77.google.com with SMTP id ca18e2360f4ac-86d07ccc9ecso597261139f.0
        for <ocfs2-devel@lists.linux.dev>; Wed, 18 Jun 2025 02:49:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750240171; x=1750844971;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=69Qnpk4UwSoytmWYvYtQQU4e1h2jMSrDA0wW3I4ac0g=;
        b=Z/wQOTjcr5MkyH9UqDbumHlBrAO+KPxYPbDel+q6+yFh/UhYbIc6pe4ptoZkFTcUJe
         yisXUwniAW97Uc++HLzf/bxwKgITNPtx6Ka1RH4oXSREQjDWgAXj0bjwJYP4MN97flDU
         wAxJTqyOPWnsPKVJKtYwSkHSZZUPLnygBLZB6rM8oaduH0Rh/lIFBKC1zKu2SNOnflRF
         Tp48V628t3OFExLslXPAaBHj/WTgCqKcKRdqTYSuStHyQ6Tb7423UUbei4S53UOhCJPq
         l+x3GEUsQ2mmq090OKbaJKvuPeDDGWoKbcpO1XU+uktOoNAKxZi3yJcB5vOYzpFF8gBZ
         ZZGA==
X-Forwarded-Encrypted: i=1; AJvYcCVblto6jeK+P2ZgX/crTjsgvZ9SS6tO4baRDN3Bl7iJVa/osgunPHmW/5auSd8eKUvU9pucycneZeROtQ==@lists.linux.dev
X-Gm-Message-State: AOJu0Yz0FoQjjgSM528Vf4WmSRfdhfSYsgQyNzTueKz5Tv8U0hrSgyFe
	9AvBFbPs8Y6d2yBKq6KjyvhSJOp79PMfVIj/DsoVbMOlIYxgwVfgpUjHF/RFwEr3BEVswswI7xQ
	DlNw9sjqGSrk70SyHoKSARrREEML8Ek/+E4/jppGj4XhvS7rWEThFF4g/JAM=
X-Google-Smtp-Source: AGHT+IGbiT0mlKZJLFaMvc+YTire2FqfoDeFTF/gcfLaWQ0FxrBiA2LizRaT3Ehzi6E3vyPbEOd+JKzxl4Z7wVqg101TzgGESyAC
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:b2b:b0:3dc:90fc:282d with SMTP id
 e9e14a558f8ab-3de07d5f547mr179296275ab.16.1750240170963; Wed, 18 Jun 2025
 02:49:30 -0700 (PDT)
Date: Wed, 18 Jun 2025 02:49:30 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <68528baa.a70a0220.2da58.0003.GAE@google.com>
Subject: [syzbot] [ocfs2?] kernel BUG in ocfs2_xattr_value_truncate
From: syzbot <syzbot+960091a6411f236f2f98@syzkaller.appspotmail.com>
To: jlbec@evilplan.org, joseph.qi@linux.alibaba.com, 
	linux-kernel@vger.kernel.org, mark@fasheh.com, ocfs2-devel@lists.linux.dev, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    18531f4d1c8c Merge tag 'acpi-6.16-rc2' of git://git.kernel..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=1139c5d4580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=3a936e3316f9e2dc
dashboard link: https://syzkaller.appspot.com/bug?extid=960091a6411f236f2f98
compiler:       Debian clang version 20.1.6 (++20250514063057+1e4d39e07757-1~exp1~20250514183223.118), Debian LLD 20.1.6

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/d900f083ada3/non_bootable_disk-18531f4d.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/aa1e5854fc49/vmlinux-18531f4d.xz
kernel image: https://storage.googleapis.com/syzbot-assets/ca38347f64b2/bzImage-18531f4d.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+960091a6411f236f2f98@syzkaller.appspotmail.com

loop0: detected capacity change from 0 to 32768
=======================================================
WARNING: The mand mount option has been deprecated and
         and is ignored by this kernel. Remove the mand
         option from the mount to silence this warning.
=======================================================
ocfs2: Mounting device (7,0) on (node local, slot 0) with writeback data mode.
(syz.0.0,5331,0):ocfs2_dio_end_io:2398 ERROR: Direct IO failed, bytes = -28
getblk(): invalid block size 512 requested
logical block size: 2048
CPU: 0 UID: 0 PID: 5331 Comm: syz.0.0 Not tainted 6.16.0-rc1-syzkaller-00182-g18531f4d1c8c #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2~bpo12+1 04/01/2014
Call Trace:
 <TASK>
 dump_stack_lvl+0x189/0x250 lib/dump_stack.c:120
 __getblk_slow fs/buffer.c:1133 [inline]
 bdev_getblk+0x5b0/0x690 fs/buffer.c:1467
 __getblk include/linux/buffer_head.h:382 [inline]
 sb_getblk include/linux/buffer_head.h:388 [inline]
 ocfs2_read_blocks+0x533/0x1540 fs/ocfs2/buffer_head_io.c:236
 ocfs2_read_block fs/ocfs2/buffer_head_io.h:52 [inline]
 ocfs2_read_extent_block fs/ocfs2/alloc.c:934 [inline]
 __ocfs2_find_path+0x300/0x880 fs/ocfs2/alloc.c:1850
 ocfs2_find_path fs/ocfs2/alloc.c:1914 [inline]
 ocfs2_commit_truncate+0x4fb/0x21d0 fs/ocfs2/alloc.c:7276
 ocfs2_truncate_file+0xca2/0x1420 fs/ocfs2/file.c:509
 ocfs2_setattr+0x1520/0x1b40 fs/ocfs2/file.c:1212
 notify_change+0xb33/0xe40 fs/attr.c:552
 do_truncate+0x1a4/0x220 fs/open.c:68
 handle_truncate fs/namei.c:3508 [inline]
 do_open fs/namei.c:3891 [inline]
 path_openat+0x306c/0x3830 fs/namei.c:4046
 do_filp_open+0x1fa/0x410 fs/namei.c:4073
 do_sys_openat2+0x121/0x1c0 fs/open.c:1437
 do_sys_open fs/open.c:1452 [inline]
 __do_sys_creat fs/open.c:1530 [inline]
 __se_sys_creat fs/open.c:1524 [inline]
 __x64_sys_creat+0x8f/0xc0 fs/open.c:1524
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0xfa/0x3b0 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f6c0a38e929
Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 a8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f6c0b245038 EFLAGS: 00000246 ORIG_RAX: 0000000000000055
RAX: ffffffffffffffda RBX: 00007f6c0a5b5fa0 RCX: 00007f6c0a38e929
RDX: 0000000000000000 RSI: 0000000000000011 RDI: 00002000000002c0
RBP: 00007f6c0a410b39 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 0000000000000000 R14: 00007f6c0a5b5fa0 R15: 00007fffa516ea98
 </TASK>
(syz.0.0,5331,0):ocfs2_read_blocks:239 ERROR: status = -12
(syz.0.0,5331,0):__ocfs2_find_path:1852 ERROR: status = -12
(syz.0.0,5331,0):ocfs2_commit_truncate:7278 ERROR: status = -12
(syz.0.0,5331,0):ocfs2_truncate_file:511 ERROR: status = -12
(syz.0.0,5331,0):ocfs2_setattr:1217 ERROR: status = -12
------------[ cut here ]------------
kernel BUG at fs/ocfs2/xattr.c:743!
Oops: invalid opcode: 0000 [#1] SMP KASAN NOPTI
CPU: 0 UID: 0 PID: 5331 Comm: syz.0.0 Not tainted 6.16.0-rc1-syzkaller-00182-g18531f4d1c8c #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2~bpo12+1 04/01/2014
RIP: 0010:ocfs2_xattr_extend_allocation fs/ocfs2/xattr.c:743 [inline]
RIP: 0010:ocfs2_xattr_value_truncate+0x1518/0x1520 fs/ocfs2/xattr.c:864
Code: 07 89 d9 80 e1 07 80 c1 03 38 c1 0f 8c 85 ed ff ff 48 89 df 49 89 f6 e8 46 43 74 fe 4c 89 f6 e9 72 ed ff ff e8 f9 cb 10 fe 90 <0f> 0b 66 0f 1f 44 00 00 90 90 90 90 90 90 90 90 90 90 90 90 90 90
RSP: 0018:ffffc9000d1de940 EFLAGS: 00010287
RAX: ffffffff83af9047 RBX: 00000000fffffff5 RCX: 0000000000100000
RDX: ffffc9000de2a000 RSI: 00000000000010dd RDI: 00000000000010de
RBP: ffffc9000d1dec70 R08: ffff888000eb2440 R09: 0000000000000006
R10: 00000000fffffffc R11: 0000000000000002 R12: ffff8880537353d0
R13: dffffc0000000000 R14: 0000000000000002 R15: 0000000000000003
FS:  00007f6c0b2456c0(0000) GS:ffff88808d252000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000200000003000 CR3: 0000000043015000 CR4: 0000000000352ef0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 ocfs2_xa_value_truncate+0x295/0x3d0 fs/ocfs2/xattr.c:1915
 ocfs2_xa_prepare_entry fs/ocfs2/xattr.c:2173 [inline]
 ocfs2_xa_set+0x2371/0x3050 fs/ocfs2/xattr.c:2251
 ocfs2_xattr_block_set+0x3c4/0x2bc0 fs/ocfs2/xattr.c:2985
 __ocfs2_xattr_set_handle+0x661/0xf20 fs/ocfs2/xattr.c:3387
 ocfs2_xattr_set+0xde8/0x11f0 fs/ocfs2/xattr.c:3650
 __vfs_setxattr+0x439/0x480 fs/xattr.c:200
 __vfs_setxattr_noperm+0x12d/0x660 fs/xattr.c:234
 vfs_setxattr+0x16b/0x2f0 fs/xattr.c:321
 do_setxattr fs/xattr.c:636 [inline]
 filename_setxattr+0x274/0x600 fs/xattr.c:665
 path_setxattrat+0x364/0x3a0 fs/xattr.c:713
 __do_sys_lsetxattr fs/xattr.c:754 [inline]
 __se_sys_lsetxattr fs/xattr.c:750 [inline]
 __x64_sys_lsetxattr+0xbf/0xe0 fs/xattr.c:750
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0xfa/0x3b0 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f6c0a38e929
Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 a8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f6c0b245038 EFLAGS: 00000246 ORIG_RAX: 00000000000000bd
RAX: ffffffffffffffda RBX: 00007f6c0a5b5fa0 RCX: 00007f6c0a38e929
RDX: 0000200000000040 RSI: 00002000000000c0 RDI: 0000200000000100
RBP: 00007f6c0a410b39 R08: 0000000000000000 R09: 0000000000000000
R10: 000000000000fe37 R11: 0000000000000246 R12: 0000000000000000
R13: 0000000000000000 R14: 00007f6c0a5b5fa0 R15: 00007fffa516ea98
 </TASK>
Modules linked in:
---[ end trace 0000000000000000 ]---
RIP: 0010:ocfs2_xattr_extend_allocation fs/ocfs2/xattr.c:743 [inline]
RIP: 0010:ocfs2_xattr_value_truncate+0x1518/0x1520 fs/ocfs2/xattr.c:864
Code: 07 89 d9 80 e1 07 80 c1 03 38 c1 0f 8c 85 ed ff ff 48 89 df 49 89 f6 e8 46 43 74 fe 4c 89 f6 e9 72 ed ff ff e8 f9 cb 10 fe 90 <0f> 0b 66 0f 1f 44 00 00 90 90 90 90 90 90 90 90 90 90 90 90 90 90
RSP: 0018:ffffc9000d1de940 EFLAGS: 00010287
RAX: ffffffff83af9047 RBX: 00000000fffffff5 RCX: 0000000000100000
RDX: ffffc9000de2a000 RSI: 00000000000010dd RDI: 00000000000010de
RBP: ffffc9000d1dec70 R08: ffff888000eb2440 R09: 0000000000000006
R10: 00000000fffffffc R11: 0000000000000002 R12: ffff8880537353d0
R13: dffffc0000000000 R14: 0000000000000002 R15: 0000000000000003
FS:  00007f6c0b2456c0(0000) GS:ffff88808d252000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000200000003000 CR3: 0000000043015000 CR4: 0000000000352ef0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400


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
