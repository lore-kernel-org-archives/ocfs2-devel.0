Received: from mail-il1-f206.google.com (mail-il1-f206.google.com [209.85.166.206])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77434269AFA
	for <ocfs2-devel@lists.linux.dev>; Tue, 18 Feb 2025 13:25:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.206
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739885126; cv=none; b=YgtZNLGSYN7C2e/k3a/yP8rlPoa1Aq5/JTx4w9idyOvqJ+k5Lh65E6zs/nFNCAwG/iP+7RV9PmGsWisni3+CYCL5NVxm4+Ylw3WC24X56YmBCdXUQl9yMdrInJr9rbcxbf58/hvDu6ga+rE8poXTV44F2MImdyG2Xu28f4SGNuw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739885126; c=relaxed/simple;
	bh=3ZNa4ZrGhk5MBbV0uH5n9LxtqBxX7sXsiPWe+IqaZbs=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=f4iTzWKSombgHpK4rFvduT4Qn/PXli8rsiAjSCM4EulWkIQ2g+KQSdXH/EDD3rULxIS+6ReMXsFAeeND18LRsO+QGN0r3pRqXBPWQOHgj1ZmRMsfK+QnCtVMHzhQLdMM6EE/B3qlV3EfIEENXjH6uZzSRjzMr1g6V1aQUNwX/Dg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.206
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f206.google.com with SMTP id e9e14a558f8ab-3ce843b51c3so101518455ab.0
        for <ocfs2-devel@lists.linux.dev>; Tue, 18 Feb 2025 05:25:24 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739885123; x=1740489923;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=G+7/q1jM1Bvz9DI85BsMkac8Pe2d6tQdTj4wf8JkTzY=;
        b=uo8Mr8ZCFnE69G1/pzPHMQX9/zIYwAdlbDoZ5kr6z4dZhb+REn+mcBTKBssRQsvaH8
         8JC9PqM/I+3Wmej+DO0vpVNcc2mCE3XUi2aXrjLR9osC19bNyUk3ERyqPkmRlTMPY8ge
         50vTBkean6E7RkDh9PiQsBq6dWXKDUduFj7HsxZEs0F1zterF9z+61Zgjn6nyeeOTQib
         ywneZtTxxwaPf35pe1KHOohJQczcJxCpUzMliddOSA3L8p3EPx8eHi7GFBbKW7fQ9wxH
         bAwipAS4JOxnPZGERn1mflAJZaUsZzPg+/bGR3jorYBRrnVDR9x+4qpic538u4ARqNHU
         u8vw==
X-Forwarded-Encrypted: i=1; AJvYcCVXcgwTtIzE6VjDR8VP7zq1yquoaxpN2ouCJtSWsvMUHnSMWD/audxmhAUVugog+7mYqyQeIal/epcu6w==@lists.linux.dev
X-Gm-Message-State: AOJu0YwyTDwx2+USkbvakCoNGIIA5LvGVkDr0AwdRH8ypyaUow+wquh6
	5ABHPHXU20oaxg7hOr4ez7432ohCgOA+ZFz5PxlrBFwagIDsj7woraRfhcTkpGIvATWC48sr9DO
	EKKXR7PeVsGaW3cso66tNZocXQ/4k7ucWaUQDCOHRObm3Tz0dzO6g8i8=
X-Google-Smtp-Source: AGHT+IHtu/68U23foJWFnuOE2J2caAS5yJ4zrsjwodgLGFo04BYktL8Hu3M9iEvfi/Unm894kHuC2gTA/Tl2NnTI7w40QqMopTz2
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1c0f:b0:3d0:f31:3657 with SMTP id
 e9e14a558f8ab-3d2796b6803mr122202265ab.0.1739885123611; Tue, 18 Feb 2025
 05:25:23 -0800 (PST)
Date: Tue, 18 Feb 2025 05:25:23 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <67b48a43.050a0220.173698.0062.GAE@google.com>
Subject: [syzbot] [ocfs2?] kernel BUG in __ocfs2_rotate_tree_left
From: syzbot <syzbot+7508211c42e6e7c9f2f8@syzkaller.appspotmail.com>
To: jlbec@evilplan.org, joseph.qi@linux.alibaba.com, 
	linux-kernel@vger.kernel.org, mark@fasheh.com, ocfs2-devel@lists.linux.dev, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    2408a807bfc3 Merge tag 'vfs-6.14-rc4.fixes' of git://git.k..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=12261898580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=b7bde34acd8f53b1
dashboard link: https://syzkaller.appspot.com/bug?extid=7508211c42e6e7c9f2f8
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/7feb34a89c2a/non_bootable_disk-2408a807.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/f62d1e4db390/vmlinux-2408a807.xz
kernel image: https://storage.googleapis.com/syzbot-assets/eb24d3a710ff/bzImage-2408a807.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+7508211c42e6e7c9f2f8@syzkaller.appspotmail.com

loop0: detected capacity change from 32768 to 0
------------[ cut here ]------------
kernel BUG at fs/ocfs2/alloc.c:2721!
Oops: invalid opcode: 0000 [#1] PREEMPT SMP KASAN NOPTI
CPU: 0 UID: 0 PID: 5326 Comm: syz.0.0 Not tainted 6.14.0-rc3-syzkaller-00012-g2408a807bfc3 #0
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2~bpo12+1 04/01/2014
RIP: 0010:ocfs2_rotate_subtree_left fs/ocfs2/alloc.c:2721 [inline]
RIP: 0010:__ocfs2_rotate_tree_left+0x2fd5/0x3010 fs/ocfs2/alloc.c:2977
Code: fe 90 0f 0b e8 cc 7e 0b fe 90 0f 0b e8 c4 7e 0b fe 90 0f 0b e8 bc 7e 0b fe 90 0f 0b e8 b4 7e 0b fe 90 0f 0b e8 ac 7e 0b fe 90 <0f> 0b 48 8b 0c 24 80 e1 07 80 c1 03 38 c1 0f 8c 8c fd ff ff 48 8b
RSP: 0018:ffffc9000d4b6500 EFLAGS: 00010283
RAX: ffffffff83b63be4 RBX: 0000000000000000 RCX: 0000000000100000
RDX: ffffc9000edbb000 RSI: 0000000000001224 RDI: 0000000000001225
RBP: ffffc9000d4b68d0 R08: ffffffff83b6241d R09: ffffffff83b62036
R10: 0000000000000006 R11: ffff88800024a440 R12: ffff8880544c6700
R13: 1ffff92001a96ccc R14: 0000000000000000 R15: dffffc0000000000
FS:  00007f16019f56c0(0000) GS:ffff88801fc00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000000000010 CR3: 00000000339fc000 CR4: 0000000000352ef0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 ocfs2_rotate_tree_left+0x326/0xdc0 fs/ocfs2/alloc.c:3229
 ocfs2_truncate_rec+0x1547/0x1c90 fs/ocfs2/alloc.c:5502
 ocfs2_remove_extent+0x106f/0x26f0 fs/ocfs2/alloc.c:5581
 ocfs2_remove_btree_range+0xfde/0x1860 fs/ocfs2/alloc.c:5770
 ocfs2_remove_inode_range+0xff3/0x29c0 fs/ocfs2/file.c:1907
 ocfs2_reflink_remap_extent fs/ocfs2/refcounttree.c:4534 [inline]
 ocfs2_reflink_remap_blocks+0xcd4/0x1f30 fs/ocfs2/refcounttree.c:4681
 ocfs2_remap_file_range+0x5fa/0x8d0 fs/ocfs2/file.c:2740
 vfs_copy_file_range+0xc07/0x14f0 fs/read_write.c:1584
 __do_sys_copy_file_range fs/read_write.c:1670 [inline]
 __se_sys_copy_file_range+0x3fa/0x600 fs/read_write.c:1637
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f160558cde9
Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 a8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f16019f5038 EFLAGS: 00000246 ORIG_RAX: 0000000000000146
RAX: ffffffffffffffda RBX: 00007f16057a6080 RCX: 00007f160558cde9
RDX: 0000000000000005 RSI: 0000000000000000 RDI: 000000000000000c
RBP: 00007f160560e2a0 R08: fffffbffa003e45c R09: 0700000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 0000000000000000 R14: 00007f16057a6080 R15: 00007ffd149b49b8
 </TASK>
Modules linked in:
---[ end trace 0000000000000000 ]---
RIP: 0010:ocfs2_rotate_subtree_left fs/ocfs2/alloc.c:2721 [inline]
RIP: 0010:__ocfs2_rotate_tree_left+0x2fd5/0x3010 fs/ocfs2/alloc.c:2977
Code: fe 90 0f 0b e8 cc 7e 0b fe 90 0f 0b e8 c4 7e 0b fe 90 0f 0b e8 bc 7e 0b fe 90 0f 0b e8 b4 7e 0b fe 90 0f 0b e8 ac 7e 0b fe 90 <0f> 0b 48 8b 0c 24 80 e1 07 80 c1 03 38 c1 0f 8c 8c fd ff ff 48 8b
RSP: 0018:ffffc9000d4b6500 EFLAGS: 00010283
RAX: ffffffff83b63be4 RBX: 0000000000000000 RCX: 0000000000100000
RDX: ffffc9000edbb000 RSI: 0000000000001224 RDI: 0000000000001225
RBP: ffffc9000d4b68d0 R08: ffffffff83b6241d R09: ffffffff83b62036
R10: 0000000000000006 R11: ffff88800024a440 R12: ffff8880544c6700
R13: 1ffff92001a96ccc R14: 0000000000000000 R15: dffffc0000000000
FS:  00007f16019f56c0(0000) GS:ffff88801fc00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 000055bc228e30b8 CR3: 00000000339fc000 CR4: 0000000000352ef0
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
