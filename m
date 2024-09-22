Received: from mail-il1-f198.google.com (mail-il1-f198.google.com [209.85.166.198])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D100F63C
	for <ocfs2-devel@lists.linux.dev>; Sun, 22 Sep 2024 23:08:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.198
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727046503; cv=none; b=shBjN5Me58qZBEkn/yrNTmPRjklPLwPB/7kIfTYlsPeGFKY9sVQRsIthj+/8Xfoxy2Yg1hePzLvrr8DeXVWr/bsUJk5cwU8rJ5nbL+aDdZsMQCbnAkTKweo2ID90sNzsndv7GMDnZfBpxtK7S7yAoA0sxwL55LUdK3yFigNXRfA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727046503; c=relaxed/simple;
	bh=rUa9EFClsvfyt2NZuiWReC6iCj1gDwPT59fvYhl4aBs=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=tVM8rIb7Z7n0gw9+CNVb/WwH2tebQBjo3gqc5IkvqakHEMEuDEkRSncCYkQTUrfw/1/D/FDuFX8fWhBhJlGro8YmN3Zxrvy0hhOABubt8N04xsUwnOQ2kMXfNmtDSnrvA/Msk3WP6v3L9DfIzQJEtrTld3zrLluGTKWilD0cAxk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.198
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f198.google.com with SMTP id e9e14a558f8ab-3a04af50632so34686115ab.2
        for <ocfs2-devel@lists.linux.dev>; Sun, 22 Sep 2024 16:08:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727046501; x=1727651301;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=189c+GqSoxNF0lHpzbMHiD/SgorbPgCvDdH1tZjf+90=;
        b=FqkRUh8aC55d+l9cyjp1k6u04QxrGvIcxV2HGtbeB9tzovaywt7rfmRZQZUAudKvcR
         yNNCffFIET4uDvMmvXgkOCTbKu800aovVM5npYplnuHR+jwALf/ZR46mCRboXIEz7TJl
         I1NL8SzLGwDVM2QN2oh28nZjLk5CbD/ToawSD2GiUU1XmDu/02MBayHosPTEDqu62eq3
         AqMwiMxc0Fum8yWi59AbmprxT/udv4vhXOR95Inq+0SbjZE82ral2NGAFi412FmieZ2g
         1pMgaBTQ3nI6wTE4E0ZgloibRGIQo5cuSiZRNPJZwEaFEC9v9pI5pjYXGIgmsY5YQc+j
         u3aw==
X-Forwarded-Encrypted: i=1; AJvYcCW8qWq3pTIhVcip82hyCU0auOY6c4E2+Zvz366B+q3ct1EqsbTxO6hpLWaZTQPYJdMYFsmtcnYD1U7pvw==@lists.linux.dev
X-Gm-Message-State: AOJu0YxsUTiqBdPHFpufy3IDXUBvh2jOhxn9f6iYpnW7gYgxyrn63phE
	SnVrOYJgfnMcOV8y52rseXVjt4vfbpZwUXkfK5cRP2T6xolpQp0CRqtYU/X4seX5uV4s/Voz31M
	qvxPAddHZMNBqupJpAzgZLkrNA4hDbO6plYNCEXmVGIpGhFwYeDlcK6o=
X-Google-Smtp-Source: AGHT+IF2UGVMv5HlwCYWWQv9n1GABvmzsN0BiMbdRV80sAEd9zP7bjeJRN7W8Vuz+XBpVFFxr3jra1Lzb+TejzN9FkNR02Va5iaL
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:13aa:b0:3a0:97ba:d1e with SMTP id
 e9e14a558f8ab-3a0c9d3839cmr80362295ab.13.1727046500931; Sun, 22 Sep 2024
 16:08:20 -0700 (PDT)
Date: Sun, 22 Sep 2024 16:08:20 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <66f0a364.050a0220.a27de.0009.GAE@google.com>
Subject: [syzbot] [ocfs2?] kernel BUG in ocfs2_truncate_file
From: syzbot <syzbot+b93b65ee321c97861072@syzkaller.appspotmail.com>
To: jlbec@evilplan.org, joseph.qi@linux.alibaba.com, 
	linux-kernel@vger.kernel.org, mark@fasheh.com, ocfs2-devel@lists.linux.dev, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    1ec6d097897a Merge tag 's390-6.12-1' of git://git.kernel.o..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=178e6c27980000
kernel config:  https://syzkaller.appspot.com/x/.config?x=6265dd30e362bb47
dashboard link: https://syzkaller.appspot.com/bug?extid=b93b65ee321c97861072
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/7bc7510fe41f/non_bootable_disk-1ec6d097.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/0b74fa2b2b4e/vmlinux-1ec6d097.xz
kernel image: https://storage.googleapis.com/syzbot-assets/1ed852a3c5d1/bzImage-1ec6d097.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+b93b65ee321c97861072@syzkaller.appspotmail.com

netlink: 'syz.0.0': attribute type 61 has an invalid length.
loop0: detected capacity change from 0 to 32768
=======================================================
WARNING: The mand mount option has been deprecated and
         and is ignored by this kernel. Remove the mand
         option from the mount to silence this warning.
=======================================================
JBD2: Ignoring recovery information on journal
ocfs2: Mounting device (7,0) on (node local, slot 0) with ordered data mode.
loop0: detected capacity change from 32768 to 0
syz.0.0: attempt to access beyond end of device
loop0: rw=0, sector=17058, nr_sectors = 1 limit=0
(syz.0.0,5105,0):ocfs2_assign_bh:2416 ERROR: status = -5
(syz.0.0,5105,0):ocfs2_inode_lock_full_nested:2511 ERROR: status = -5
(syz.0.0,5105,0):ocfs2_prepare_inode_for_write:2262 ERROR: status = -5
(syz.0.0,5105,0):ocfs2_file_write_iter:2441 ERROR: status = -5
loop0: detected capacity change from 0 to 32767
OCFS2: ERROR (device loop0): int ocfs2_validate_inode_block(struct super_block *, struct buffer_head *): Invalid dinode #17058: signature = DE01
On-disk corruption discovered. Please run fsck.ocfs2 once the filesystem is unmounted.
OCFS2: File system is now read-only.
(syz.0.0,5105,0):ocfs2_assign_bh:2416 ERROR: status = -30
(syz.0.0,5105,0):ocfs2_inode_lock_full_nested:2511 ERROR: status = -30
(syz.0.0,5105,0):ocfs2_inode_lock_tracker:2695 ERROR: status = -30
(syz.0.0,5105,0):ocfs2_xattr_get:1335 ERROR: status = -30
(syz.0.0,5105,0):ocfs2_truncate_file:460 ERROR: bug expression: le64_to_cpu(fe->i_size) != i_size_read(inode)
(syz.0.0,5105,0):ocfs2_truncate_file:460 ERROR: Inode 17058, inode i_size = 0 != di i_size = 108086391056891904, i_flags = 0xeef82700
------------[ cut here ]------------
kernel BUG at fs/ocfs2/file.c:460!
Oops: invalid opcode: 0000 [#1] PREEMPT SMP KASAN NOPTI
CPU: 0 UID: 0 PID: 5105 Comm: syz.0.0 Not tainted 6.11.0-syzkaller-08068-g1ec6d097897a #0
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2~bpo12+1 04/01/2014
RIP: 0010:ocfs2_truncate_file+0x1381/0x1560 fs/ocfs2/file.c:454
Code: 40 01 00 00 48 c7 c6 57 c7 11 8e ba cc 01 00 00 48 c7 c1 60 54 49 8c 4d 89 e8 4d 89 f9 50 41 56 e8 04 32 18 00 48 83 c4 10 90 <0f> 0b e8 c8 b6 37 08 f3 0f 1e fa 65 44 8b 3d 98 6b 7a 7c bf 07 00
RSP: 0018:ffffc90002ddf280 EFLAGS: 00010282
RAX: f6e02d0dd3845c00 RBX: ffff88801237542c RCX: f6e02d0dd3845c00
RDX: ffffc9000b6e1000 RSI: 0000000000004984 RDI: 0000000000004985
RBP: ffffc90002ddf4b0 R08: ffffffff81746dac R09: 1ffff11003f8519a
R10: dffffc0000000000 R11: ffffed1003f8519b R12: 1ffff1100246ea84
R13: 00000000000042a2 R14: 0180000000000000 R15: 0000000000000000
FS:  00007f29d21ff6c0(0000) GS:ffff88801fc00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f29d24b84b8 CR3: 0000000011ee4000 CR4: 0000000000350ef0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 ocfs2_setattr+0x1217/0x1f50 fs/ocfs2/file.c:1209
 notify_change+0xbca/0xe90 fs/attr.c:503
 do_truncate+0x220/0x310 fs/open.c:65
 handle_truncate fs/namei.c:3395 [inline]
 do_open fs/namei.c:3778 [inline]
 path_openat+0x2e1e/0x3590 fs/namei.c:3933
 do_filp_open+0x235/0x490 fs/namei.c:3960
 do_sys_openat2+0x13e/0x1d0 fs/open.c:1415
 do_sys_open fs/open.c:1430 [inline]
 __do_sys_creat fs/open.c:1506 [inline]
 __se_sys_creat fs/open.c:1500 [inline]
 __x64_sys_creat+0x123/0x170 fs/open.c:1500
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f29d237def9
Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 a8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f29d21ff038 EFLAGS: 00000246 ORIG_RAX: 0000000000000055
RAX: ffffffffffffffda RBX: 00007f29d2535f80 RCX: 00007f29d237def9
RDX: 0000000000000000 RSI: 000000000000000a RDI: 0000000020000240
RBP: 00007f29d23f0b76 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 0000000000000000 R14: 00007f29d2535f80 R15: 00007ffc3f5b0328
 </TASK>
Modules linked in:
---[ end trace 0000000000000000 ]---
RIP: 0010:ocfs2_truncate_file+0x1381/0x1560 fs/ocfs2/file.c:454
Code: 40 01 00 00 48 c7 c6 57 c7 11 8e ba cc 01 00 00 48 c7 c1 60 54 49 8c 4d 89 e8 4d 89 f9 50 41 56 e8 04 32 18 00 48 83 c4 10 90 <0f> 0b e8 c8 b6 37 08 f3 0f 1e fa 65 44 8b 3d 98 6b 7a 7c bf 07 00
RSP: 0018:ffffc90002ddf280 EFLAGS: 00010282
RAX: f6e02d0dd3845c00 RBX: ffff88801237542c RCX: f6e02d0dd3845c00
RDX: ffffc9000b6e1000 RSI: 0000000000004984 RDI: 0000000000004985
RBP: ffffc90002ddf4b0 R08: ffffffff81746dac R09: 1ffff11003f8519a
R10: dffffc0000000000 R11: ffffed1003f8519b R12: 1ffff1100246ea84
R13: 00000000000042a2 R14: 0180000000000000 R15: 0000000000000000
FS:  00007f29d21ff6c0(0000) GS:ffff88801fc00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f29d21bd9a0 CR3: 0000000011ee4000 CR4: 0000000000350ef0
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
