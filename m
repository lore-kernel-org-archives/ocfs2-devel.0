Received: from mail-il1-f200.google.com (mail-il1-f200.google.com [209.85.166.200])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3B8618E74D
	for <ocfs2-devel@lists.linux.dev>; Mon, 28 Oct 2024 20:47:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.200
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730148445; cv=none; b=qxYSVtVXZSVr66t5ZfHFJNPrYDqhzVqrdlSgCy8GSyrki9mSj0iTYDO2A81c2/KmqHwfVDt+GkSykYRzXVDQ3Le4+gFkkiRGQDnQ1AQbgaVvGJlk+jVQpesj3vc0Vf9yquaa7PV/z4vCy2ixu9qupVyAhDK6afdHdUcdU6jAl8I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730148445; c=relaxed/simple;
	bh=N6bOlJD7PbaacOZTLVaB5y/OgJJV366J1EHzdDh+e7k=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=DM0Rn2t2fu7ClPUfKO7NH3l5N8zLzaq/4V9LLCLI16Q80jdh4J7DMCWGJrcJP2nEKhbl6JGJKO9Gf1YoXYSSUKUxAMf65LXs8ikkz6xYoUu90uad3+qdQdka6OabE43tv72KwIhHyKjvP3hbzt4v1ASWjIOwBwNwez+6vq9kyDU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.200
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f200.google.com with SMTP id e9e14a558f8ab-3a3fa97f09cso49619075ab.0
        for <ocfs2-devel@lists.linux.dev>; Mon, 28 Oct 2024 13:47:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730148443; x=1730753243;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=TDyEXl6HR/2DQ7b9MMx8HahR7q5lnqMBfeBQrEM3ITU=;
        b=Dc9Il3yaxNcpBwgaqSShNYau2sYEQYoygsnC5FGE30i8Zfq/jp9cPs7tlyWdDCMd+F
         B7ThT+WWZgaeL4Y4PpqHcDCnYjyQoYMPSdFU/8bqWneuyAJpTnWEWTYpLmYF1Tvu4hLW
         j8c6A1gS/HKy1i7Pxw9yDwMSAygEBGUsI1ER4G9x2jq7Xuc6ZlxcnerqWNBYcKDOVIIV
         2RTQzg2iiztoaBibgtIkdUi3JEdxL/7tOCmFZLoL8de8tFpNG2JmjJpen9BnAig0gpYa
         WW+vKE9zpYIC2W8vT9xmYZ7IJeSAirJyp9kRx78tSf8ED7dfcHuCqn22axbvzZ6s0yM6
         ZcgQ==
X-Forwarded-Encrypted: i=1; AJvYcCV8nNTwUz7GrfnZiiigk7mlaxupZa7GNdBkvJpaPXXWwPL/8T13Pw2orx+8W+9ol7gVW2Y4L9P4YgRR7w==@lists.linux.dev
X-Gm-Message-State: AOJu0YzTU6mRTeOdo3gVm0Z/+bTeEzRUSw6SIDAFrP+G/btKwKfmZl1O
	4rH96qw2V/A6ADGmScEZAW5MxYRtcAAxAfOruW4J76JkavAaALPmjOWhzhNpm7boz7mFm7CzMuE
	/uKaQkefoQjFGnTsm51yJhdzotBF5P694Rk+ydFkdKrdrkGhcBDugBX0=
X-Google-Smtp-Source: AGHT+IEqKIMGfSjyyjY6QtkQx5kwG+mIIJfbiQmQGjUtL8Qj5HaR4eL70NEuw1NB9njNAx2zusEYsdswkk3aYsyvNlW+y1cYfCN8
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:b2b:b0:3a3:a5c5:3915 with SMTP id
 e9e14a558f8ab-3a4ed32f502mr85967235ab.16.1730148442850; Mon, 28 Oct 2024
 13:47:22 -0700 (PDT)
Date: Mon, 28 Oct 2024 13:47:22 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <671ff85a.050a0220.11b624.04b3.GAE@google.com>
Subject: [syzbot] [ocfs2?] kernel BUG in ocfs2_journal_toggle_dirty
From: syzbot <syzbot+ea8d1726e1e3367085ce@syzkaller.appspotmail.com>
To: jlbec@evilplan.org, joseph.qi@linux.alibaba.com, 
	linux-kernel@vger.kernel.org, mark@fasheh.com, ocfs2-devel@lists.linux.dev, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    c2ee9f594da8 KVM: selftests: Fix build on on non-x86 archi..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=15c128a7980000
kernel config:  https://syzkaller.appspot.com/x/.config?x=fc6f8ce8c5369043
dashboard link: https://syzkaller.appspot.com/bug?extid=ea8d1726e1e3367085ce
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=16b9d287980000

Downloadable assets:
disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/7feb34a89c2a/non_bootable_disk-c2ee9f59.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/8a3541902b13/vmlinux-c2ee9f59.xz
kernel image: https://storage.googleapis.com/syzbot-assets/a00efacc2604/bzImage-c2ee9f59.xz
mounted in repro: https://storage.googleapis.com/syzbot-assets/7a179d67c0cd/mount_0.gz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+ea8d1726e1e3367085ce@syzkaller.appspotmail.com

(syz.0.130,5573,0):ocfs2_assign_bh:2416 ERROR: status = -30
(syz.0.130,5573,0):ocfs2_inode_lock_full_nested:2511 ERROR: status = -30
(syz.0.130,5573,0):ocfs2_shutdown_local_alloc:412 ERROR: status = -30
------------[ cut here ]------------
kernel BUG at fs/ocfs2/journal.c:1012!
Oops: invalid opcode: 0000 [#1] PREEMPT SMP KASAN NOPTI
CPU: 0 UID: 0 PID: 5573 Comm: syz.0.130 Not tainted 6.12.0-rc4-syzkaller-00047-gc2ee9f594da8 #0
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2~bpo12+1 04/01/2014
RIP: 0010:ocfs2_journal_toggle_dirty+0x397/0x3a0 fs/ocfs2/journal.c:1012
Code: 70 fe e9 f7 fd ff ff 89 d9 80 e1 07 80 c1 03 38 c1 0f 8c 2a fe ff ff 48 89 df e8 24 12 70 fe e9 1d fe ff ff e8 da 4c 06 fe 90 <0f> 0b e8 d2 db 37 08 66 90 90 90 90 90 90 90 90 90 90 90 90 90 90
RSP: 0018:ffffc9000b916ee0 EFLAGS: 00010293
RAX: ffffffff838e8b06 RBX: 00000000ffffffff RCX: ffff8880009d2440
RDX: 0000000000000000 RSI: 00000000ffffffff RDI: 0000000000000000
RBP: ffffc9000b916fb0 R08: ffffffff838e8870 R09: 1ffffffff2859322
R10: dffffc0000000000 R11: fffffbfff2859323 R12: dffffc0000000000
R13: ffff8880416cc570 R14: ffff888051214600 R15: 1ffff92001722de4
FS:  000055558215b500(0000) GS:ffff88801fc00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007fcefd324000 CR3: 000000004b2fc000 CR4: 0000000000352ef0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 ocfs2_journal_shutdown+0x479/0xc30 fs/ocfs2/journal.c:1094
 ocfs2_mount_volume+0x169f/0x1940 fs/ocfs2/super.c:1840
 ocfs2_fill_super+0x475a/0x5750 fs/ocfs2/super.c:1084
 mount_bdev+0x20a/0x2d0 fs/super.c:1679
 legacy_get_tree+0xee/0x190 fs/fs_context.c:662
 vfs_get_tree+0x90/0x2b0 fs/super.c:1800
 do_new_mount+0x2be/0xb40 fs/namespace.c:3507
 do_mount fs/namespace.c:3847 [inline]
 __do_sys_mount fs/namespace.c:4057 [inline]
 __se_sys_mount+0x2d6/0x3c0 fs/namespace.c:4034
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7fb70397f79a
Code: d8 64 89 02 48 c7 c0 ff ff ff ff eb a6 e8 de 1a 00 00 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 49 89 ca b8 a5 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 a8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007ffe031589e8 EFLAGS: 00000246 ORIG_RAX: 00000000000000a5
RAX: ffffffffffffffda RBX: 00007ffe03158a70 RCX: 00007fb70397f79a
RDX: 0000000020004440 RSI: 0000000020000040 RDI: 00007ffe03158a30
RBP: 0000000020004440 R08: 00007ffe03158a70 R09: 00000000000008c0
R10: 00000000000008c0 R11: 0000000000000246 R12: 0000000020000040
R13: 00007ffe03158a30 R14: 0000000000004436 R15: 0000000020000180
 </TASK>
Modules linked in:
---[ end trace 0000000000000000 ]---
RIP: 0010:ocfs2_journal_toggle_dirty+0x397/0x3a0 fs/ocfs2/journal.c:1012
Code: 70 fe e9 f7 fd ff ff 89 d9 80 e1 07 80 c1 03 38 c1 0f 8c 2a fe ff ff 48 89 df e8 24 12 70 fe e9 1d fe ff ff e8 da 4c 06 fe 90 <0f> 0b e8 d2 db 37 08 66 90 90 90 90 90 90 90 90 90 90 90 90 90 90
RSP: 0018:ffffc9000b916ee0 EFLAGS: 00010293
RAX: ffffffff838e8b06 RBX: 00000000ffffffff RCX: ffff8880009d2440
RDX: 0000000000000000 RSI: 00000000ffffffff RDI: 0000000000000000
RBP: ffffc9000b916fb0 R08: ffffffff838e8870 R09: 1ffffffff2859322
R10: dffffc0000000000 R11: fffffbfff2859323 R12: dffffc0000000000
R13: ffff8880416cc570 R14: ffff888051214600 R15: 1ffff92001722de4
FS:  000055558215b500(0000) GS:ffff88801fc00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000000000000 CR3: 000000004b2fc000 CR4: 0000000000352ef0
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
