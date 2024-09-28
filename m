Received: from mail-il1-f199.google.com (mail-il1-f199.google.com [209.85.166.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E03238F97
	for <ocfs2-devel@lists.linux.dev>; Sat, 28 Sep 2024 19:49:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727552971; cv=none; b=txBP14W90/TPpCiXTO8bGGFZf/+wxLvGIQP9sqcbHm+y+QPpg58QNqfdcyipfT6NcODduSXwdT9S2p2dloFnOLGA+pB+UvDSjR4hNvzQD7OIhlWUczIlW/w9uD2aIaDp6h4TOnu7HUGZZbi7afUDuOY4ytpSPkWtCOV5hA39chk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727552971; c=relaxed/simple;
	bh=6FlHeSW3PTIX1u1iE/uqFaOyn9oWo+au0hXrLQrWoE8=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=lWfpZW47F56Zy27YnSM7tMXmW7I6WXCK2G3c8j34EifYnrP6FvQV3HdYhoiR7bF7CTxLmDrcgf7V1Te402Bb787QleIu9T155fg5c7gnzpmvsHdBbYTzc8OomkD2M5EL6HQipn9LtZIkTKrhIgNkwinSPzvIlE3sroBu92AZJA8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f199.google.com with SMTP id e9e14a558f8ab-3a342e7e49cso41332535ab.0
        for <ocfs2-devel@lists.linux.dev>; Sat, 28 Sep 2024 12:49:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727552969; x=1728157769;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=U1Y2nY2DxZJa6WbAmluQE8FAM91TucuqHCkoV2WObGQ=;
        b=XA1oYlFqFq99EaGvin1OOrxL3lDqi3rRgb3pZWVXaUPpod2qyg5v3Zxr3lftKITzFC
         /oJUOzm+HKlDV9XQQPzVOXHiLR+NmnI+by9iQwE5jLi8SZbd/5Y5OLovY0sN4EKkJ40j
         UqgevufCfyv4UsEtrsdKii+mtpsp8t6znCoKbOGqek3wVyfpBTg5BTQuo8bSngUNUeu9
         a+kZfv/YWTYHV+98/54qh0yLajumvosfw7VQU3bopMSXkYWOub3JZcyLebNJ0lATIANZ
         5lWNGsXXUArSfzIR+9OmHVQaxDp7nLPsVtuKGXh+QkQJbCmKMrbmKQdntD2A/4tY74qF
         mfag==
X-Forwarded-Encrypted: i=1; AJvYcCUmUEnG1KtwaPeAU4ou1Ny85ggtOKE63Q5RkqhcQNXroZCG7Q5zZeAKqro3nFxL/R7aZZxwoVl3VfSmmg==@lists.linux.dev
X-Gm-Message-State: AOJu0Yw3SF903/QEIsi7QYA2Ci0/IA0OxXq4Iz3kpH10hLLDG8JYwZa2
	Ilq9na7lmVyLE5ZCcoPKbLugQwzcAOzuFD2DKFojPAa2jSaM+eylEJdk62zDlqEF4kR0zDyQjLh
	hNMNTun1J/SxhE4hpcEPNDRSgBWdYFe70sNupRPEAE+N4v3fSiRNeiSA=
X-Google-Smtp-Source: AGHT+IFNfHhNY9rbX5RHJ0LgkrEPamonjFF/fhkhcNKiv6P24aCAbDGYkjwgj18jKn3Ou1vN17MuARB28mvMQ15cKR8lGlhmnMDc
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1445:b0:3a0:933d:d307 with SMTP id
 e9e14a558f8ab-3a34516a172mr58437585ab.8.1727552969544; Sat, 28 Sep 2024
 12:49:29 -0700 (PDT)
Date: Sat, 28 Sep 2024 12:49:29 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <66f85dc9.050a0220.aab67.0007.GAE@google.com>
Subject: [syzbot] [ocfs2?] kernel BUG in ocfs2_truncate_log_needs_flush
From: syzbot <syzbot+e1e7130b99d8a4ac02e4@syzkaller.appspotmail.com>
To: jlbec@evilplan.org, joseph.qi@linux.alibaba.com, 
	linux-kernel@vger.kernel.org, mark@fasheh.com, ocfs2-devel@lists.linux.dev, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    abf2050f51fd Merge tag 'media/v6.12-1' of git://git.kernel..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=10f9b107980000
kernel config:  https://syzkaller.appspot.com/x/.config?x=bc30a30374b0753
dashboard link: https://syzkaller.appspot.com/bug?extid=e1e7130b99d8a4ac02e4
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/7bc7510fe41f/non_bootable_disk-abf2050f.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/2179ebeade58/vmlinux-abf2050f.xz
kernel image: https://storage.googleapis.com/syzbot-assets/f05289b5cf7c/bzImage-abf2050f.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+e1e7130b99d8a4ac02e4@syzkaller.appspotmail.com

(syz.0.0,5112,0):ocfs2_truncate_log_needs_flush:5822 ERROR: bug expression: le16_to_cpu(tl->tl_used) > le16_to_cpu(tl->tl_count)
(syz.0.0,5112,0):ocfs2_truncate_log_needs_flush:5822 ERROR: slot 0, invalid truncate log parameters: used = 64512, count = 39
------------[ cut here ]------------
kernel BUG at fs/ocfs2/alloc.c:5822!
Oops: invalid opcode: 0000 [#1] PREEMPT SMP KASAN NOPTI
CPU: 0 UID: 0 PID: 5112 Comm: syz.0.0 Not tainted 6.11.0-syzkaller-09959-gabf2050f51fd #0
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2~bpo12+1 04/01/2014
RIP: 0010:ocfs2_truncate_log_needs_flush+0x312/0x320 fs/ocfs2/alloc.c:5819
Code: 0f b7 00 4c 89 f7 48 c7 c6 42 42 11 8e ba be 16 00 00 48 c7 c1 60 0a 49 8c 45 89 e0 41 89 d9 50 e8 d3 aa 20 00 48 83 c4 08 90 <0f> 0b e8 c7 30 41 08 0f 1f 80 00 00 00 00 90 90 90 90 90 90 90 90
RSP: 0018:ffffc90003727540 EFLAGS: 00010292
RAX: 72ffad2bcd159b00 RBX: 000000000000fc00 RCX: 72ffad2bcd159b00
RDX: 0000000000000000 RSI: 0000000080000000 RDI: 0000000000000000
RBP: ffffc90003727610 R08: ffffffff81746c8c R09: 1ffff920006e4e18
R10: dffffc0000000000 R11: fffff520006e4e19 R12: 0000000000000000
R13: ffff888000503ac2 R14: ffffc900037275a0 R15: 1000000000000000
FS:  00007f582a3f36c0(0000) GS:ffff88801fc00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f582a3f2f98 CR3: 000000003f8ac000 CR4: 0000000000350ef0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 ocfs2_xattr_set+0xeab/0x1930 fs/ocfs2/xattr.c:3625
 __vfs_setxattr+0x468/0x4a0 fs/xattr.c:200
 __vfs_setxattr_noperm+0x12e/0x660 fs/xattr.c:234
 vfs_setxattr+0x221/0x430 fs/xattr.c:321
 do_setxattr fs/xattr.c:629 [inline]
 path_setxattr+0x37e/0x4d0 fs/xattr.c:658
 __do_sys_setxattr fs/xattr.c:676 [inline]
 __se_sys_setxattr fs/xattr.c:672 [inline]
 __x64_sys_setxattr+0xbb/0xd0 fs/xattr.c:672
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f582957def9
Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 a8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f582a3f3038 EFLAGS: 00000246 ORIG_RAX: 00000000000000bc
RAX: ffffffffffffffda RBX: 00007f5829736058 RCX: 00007f582957def9
RDX: 00000000200013c0 RSI: 0000000020000140 RDI: 0000000020000100
RBP: 00007f58295f0b76 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000700 R11: 0000000000000246 R12: 0000000000000000
R13: 0000000000000001 R14: 00007f5829736058 R15: 00007ffca764d158
 </TASK>
Modules linked in:
---[ end trace 0000000000000000 ]---
RIP: 0010:ocfs2_truncate_log_needs_flush+0x312/0x320 fs/ocfs2/alloc.c:5819
Code: 0f b7 00 4c 89 f7 48 c7 c6 42 42 11 8e ba be 16 00 00 48 c7 c1 60 0a 49 8c 45 89 e0 41 89 d9 50 e8 d3 aa 20 00 48 83 c4 08 90 <0f> 0b e8 c7 30 41 08 0f 1f 80 00 00 00 00 90 90 90 90 90 90 90 90
RSP: 0018:ffffc90003727540 EFLAGS: 00010292
RAX: 72ffad2bcd159b00 RBX: 000000000000fc00 RCX: 72ffad2bcd159b00
RDX: 0000000000000000 RSI: 0000000080000000 RDI: 0000000000000000
RBP: ffffc90003727610 R08: ffffffff81746c8c R09: 1ffff920006e4e18
R10: dffffc0000000000 R11: fffff520006e4e19 R12: 0000000000000000
R13: ffff888000503ac2 R14: ffffc900037275a0 R15: 1000000000000000
FS:  00007f582a3f36c0(0000) GS:ffff88801fc00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000000000000 CR3: 000000003f8ac000 CR4: 0000000000350ef0
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
