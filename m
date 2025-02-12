Received: from mail-il1-f207.google.com (mail-il1-f207.google.com [209.85.166.207])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A26A7271833
	for <ocfs2-devel@lists.linux.dev>; Wed, 12 Feb 2025 03:15:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739330128; cv=none; b=iXoUWc7fYfLI405MmuCKt0Olcqv0coDhi8eT7bAOZJ92/WnSSSWfhRhVATiqqnvRcEC9KFydN6I19G9YDJCWECQfY7sPBllSEF2xsbFid5sXSuTpm5pYsssA/q7Qb+HdwrhuYDxtGeKqReKYSSw8twfe3F9xQUHPsuNbqBsrOoY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739330128; c=relaxed/simple;
	bh=JU0lrRA9iMX10XLlm8VwjoOm2bxondUWwawS1jqS8oo=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=e+J3CrdsNymekf/tw1P+HqvqaqYFsBzulPCFjuUL1352Yaxhagziosh1sTH9Sa/tD20DpNnz1fcRKyHAioX5nLGwzO2VoWFl9ZbE6cEBDuw/a5dzy2yvDxRj2fpRiV5YHZVIwYS2ehKG6m/X8OMmBjzQYbvSC2dk0gLyYpn8TxA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f207.google.com with SMTP id e9e14a558f8ab-3d1466cbaddso3507695ab.0
        for <ocfs2-devel@lists.linux.dev>; Tue, 11 Feb 2025 19:15:26 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739330126; x=1739934926;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=rcvIqZdO0vCpRiy9D+oIC5vVyuY8tnfvl1mijVVX7qg=;
        b=aN4xoIkKFG1ShqJolMU9AblfZXZxnE4VgbH6mKG8jYzQceOMhqwS22ENNI9FMPcbAb
         PW3PVTdSRm7VjB3L7BZ1qHOXp1FKEirNgG6sRidp6oDemJXO1VceyMba7X+HJY9L68sP
         AiYLKwoo6YqQsePz2tl9B58JxVd+5tcPaXTZJkgUM6tDFTesJ8uDB/MLcNKg75xK3fT8
         ZkDR0gG/szodSYAagfb30ymw+GW6S7F31b2a04QQoUvVqmCDRx9f0BybxdmlhV9OHap7
         wnOjzvlemvHYRc8TueIASQF39sE6WCZWGhETc6XDAiiWvXSFRhRo3URdO2MkIn9WgUqg
         ehiw==
X-Forwarded-Encrypted: i=1; AJvYcCWNAZtEVgD4+7137qhad45Geef3qC59KF+cl7nsdDk1ADGUGvnJCbcoIZjuc0kevvqQ+E4rW38/HKdCgg==@lists.linux.dev
X-Gm-Message-State: AOJu0Yy3tWPfanyu3fYTfV28feFLHQYQapyrDT6i7XfWjiP9TY2l+lKo
	9LYm494wxmz02ZKMsGpJr2XYAftcGg28VKgPGWLT6If0y3YuDT/AN85daZbNgwejchmSnGroGes
	7exJ+tBY56taw6Wxl9tb6/J5hYnufi/W5wlBGyIcyqEBFpqv7syVyIyc=
X-Google-Smtp-Source: AGHT+IEYcDaYOc+UTbDBH4Ix6eb9/5qRMoJ+njHYiQQm16sfujWG8ZFlfUwDEnUdRlgcoazb39siHepgPdzGD5jDP4P5Rck9mbz/
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1388:b0:3cf:ba90:6ad9 with SMTP id
 e9e14a558f8ab-3d17cb8ae22mr10587565ab.9.1739330125748; Tue, 11 Feb 2025
 19:15:25 -0800 (PST)
Date: Tue, 11 Feb 2025 19:15:25 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <67ac124d.050a0220.110943.0045.GAE@google.com>
Subject: [syzbot] [ocfs2?] kernel BUG in ocfs2_update_edge_lengths
From: syzbot <syzbot+d7bd040f4ea15e73afcd@syzkaller.appspotmail.com>
To: jlbec@evilplan.org, joseph.qi@linux.alibaba.com, 
	linux-kernel@vger.kernel.org, mark@fasheh.com, ocfs2-devel@lists.linux.dev, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    7ee983c850b4 Merge tag 'drm-fixes-2025-02-08' of https://g..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=164f0bdf980000
kernel config:  https://syzkaller.appspot.com/x/.config?x=1909f2f0d8e641ce
dashboard link: https://syzkaller.appspot.com/bug?extid=d7bd040f4ea15e73afcd
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/7feb34a89c2a/non_bootable_disk-7ee983c8.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/f2f78699fc41/vmlinux-7ee983c8.xz
kernel image: https://storage.googleapis.com/syzbot-assets/ca55e6e8dd01/bzImage-7ee983c8.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+d7bd040f4ea15e73afcd@syzkaller.appspotmail.com

loop0: detected capacity change from 32768 to 32767
(syz.0.0,5337,0):ocfs2_commit_truncate:7313 ERROR: Inode 17058 has an empty extent record, depth 1
------------[ cut here ]------------
kernel BUG at fs/ocfs2/alloc.c:2549!
Oops: invalid opcode: 0000 [#1] PREEMPT SMP KASAN NOPTI
CPU: 0 UID: 0 PID: 5337 Comm: syz.0.0 Not tainted 6.14.0-rc1-syzkaller-00181-g7ee983c850b4 #0
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2~bpo12+1 04/01/2014
RIP: 0010:ocfs2_update_edge_lengths+0x62d/0x630 fs/ocfs2/alloc.c:2549
Code: ee 11 fe 44 89 e6 48 c7 c7 60 3d e2 8e e8 cb 9d 73 01 e9 86 fb ff ff e8 41 68 48 08 e8 fc ed 11 fe 90 0f 0b e8 f4 ed 11 fe 90 <0f> 0b 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 f3 0f 1e
RSP: 0018:ffffc9000d49ecc0 EFLAGS: 00010283
RAX: ffffffff83ad702c RBX: 0000000000000000 RCX: 0000000000100000
RDX: ffffc90020001000 RSI: 00000000000016d2 RDI: 00000000000016d3
RBP: ffffc9000d49ed90 R08: ffffffff83ad6c44 R09: ffffffff83ad6ab3
R10: 0000000000000006 R11: ffff8880009e2440 R12: dffffc0000000000
R13: ffff888035bb5280 R14: ffff88805412ac00 R15: 1ffff92001a93da0
FS:  00007f41b89da6c0(0000) GS:ffff88801fc00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f41b89b8fe0 CR3: 0000000043d1a000 CR4: 0000000000352ef0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 ocfs2_remove_rightmost_path+0x887/0xae0 fs/ocfs2/alloc.c:3077
 ocfs2_remove_rightmost_empty_extent fs/ocfs2/alloc.c:3126 [inline]
 ocfs2_commit_truncate+0x10fb/0x2550 fs/ocfs2/alloc.c:7314
 ocfs2_truncate_file+0xd21/0x1560 fs/ocfs2/file.c:509
 ocfs2_setattr+0x1890/0x1ef0 fs/ocfs2/file.c:1212
 notify_change+0xbca/0xe90 fs/attr.c:552
 do_truncate+0x220/0x310 fs/open.c:65
 handle_truncate fs/namei.c:3451 [inline]
 do_open fs/namei.c:3834 [inline]
 path_openat+0x2e1b/0x3590 fs/namei.c:3989
 do_filp_open+0x27f/0x4e0 fs/namei.c:4016
 do_sys_openat2+0x13e/0x1d0 fs/open.c:1428
 do_sys_open fs/open.c:1443 [inline]
 __do_sys_creat fs/open.c:1521 [inline]
 __se_sys_creat fs/open.c:1515 [inline]
 __x64_sys_creat+0x123/0x170 fs/open.c:1515
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f41b7b8cde9
Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 a8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f41b89da038 EFLAGS: 00000246 ORIG_RAX: 0000000000000055
RAX: ffffffffffffffda RBX: 00007f41b7da6240 RCX: 00007f41b7b8cde9
RDX: 0000000000000000 RSI: 0000000000000027 RDI: 0000400000000040
RBP: 00007f41b7c0e2a0 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 0000000000000000 R14: 00007f41b7da6240 R15: 00007ffcf1848b28
 </TASK>
Modules linked in:
---[ end trace 0000000000000000 ]---
RIP: 0010:ocfs2_update_edge_lengths+0x62d/0x630 fs/ocfs2/alloc.c:2549
Code: ee 11 fe 44 89 e6 48 c7 c7 60 3d e2 8e e8 cb 9d 73 01 e9 86 fb ff ff e8 41 68 48 08 e8 fc ed 11 fe 90 0f 0b e8 f4 ed 11 fe 90 <0f> 0b 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 f3 0f 1e
RSP: 0018:ffffc9000d49ecc0 EFLAGS: 00010283
RAX: ffffffff83ad702c RBX: 0000000000000000 RCX: 0000000000100000
RDX: ffffc90020001000 RSI: 00000000000016d2 RDI: 00000000000016d3
RBP: ffffc9000d49ed90 R08: ffffffff83ad6c44 R09: ffffffff83ad6ab3
R10: 0000000000000006 R11: ffff8880009e2440 R12: dffffc0000000000
R13: ffff888035bb5280 R14: ffff88805412ac00 R15: 1ffff92001a93da0
FS:  00007f41b89da6c0(0000) GS:ffff88801fc00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 000055df893bc028 CR3: 0000000043d1a000 CR4: 0000000000352ef0
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
