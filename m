Received: from mail-il1-f207.google.com (mail-il1-f207.google.com [209.85.166.207])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 029951C1F02
	for <ocfs2-devel@lists.linux.dev>; Wed, 16 Apr 2025 02:09:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744769370; cv=none; b=Q0r7/qsJLuLVdriq9Fyu0Xaq5AiTskz0jtFDnR4+7BLnmTr5Vbcw7Oq7IqDhmX8izYxa8sBG9be+1CYj5m5DV2oin6AMWzSOsEP/LP2UmfuaerMDDDhHkhpEeZiB9xzRKc+hx8T6zIwmM0V0BWHt4nlxbMOLWcQv6D55zS7Aw+k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744769370; c=relaxed/simple;
	bh=gh4Q5OI2jD51kB1ouzMitVmeY7dP7R2Lgb8/VFm23JU=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=OCC9JaEAQZEIUJyaFNWfKvWQ5YQs1F9sYBN4UOiZ7FKSfeTKSOXoJ5FNza5dAC6tXMGg1t/cLbLrqye8rNprYbr+XZH/TRgm22QAY+bLpxocKJaCkcNH6A3Vt3hjRdbx6z4HiSpr2ch/K8It+KqZACo9QqhDq/c5HNfvcB+SYqE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f207.google.com with SMTP id e9e14a558f8ab-3d443811ed2so103508415ab.3
        for <ocfs2-devel@lists.linux.dev>; Tue, 15 Apr 2025 19:09:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744769368; x=1745374168;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=10tAS0ZrAdySKIVyo27zRIx7YkYMzhlQeYEjIVo6oVs=;
        b=CMXTDNh6OqsJsTef1Lg0jl2yNH4bwmvwYVBAGNA8bMpbhYQscSwoPmZcLXtQdgvvb9
         JK5ltUVa5+1GnUXPUomn0zI/xOLp8aCm3+zZgtAQBklx9ipAxPkYcSB3vqEr0tQKpP5W
         NEvdHpjNBI5SOYRMSI/WKR0NyPRFtH1S/srNG/yrrJsIlSQgzoZ94jLzumcM2/3EvI6S
         nh1QXaz1PqGo2Zx7XBFt/ZHxV/vtB2s19LP2ElJ+7otaGVHb4AwPwwsytyzZtX+4EiUJ
         7OtY2DQ3ASmq964i07Qg+sGk5KIvscXnFLGPtItrkSd/VcjR68i+JV7RePrhUjWHVosA
         qR4w==
X-Forwarded-Encrypted: i=1; AJvYcCVfRsbTXAZrt9In6bkx35aA6cSOyWDLEb942QC2Gd3epy4qZ646u94BwmozP2Us8eR6i7NNZFKtoatinw==@lists.linux.dev
X-Gm-Message-State: AOJu0Yx1v0GHdCpELwBhSsTikl7d5R1QjQlmmUF1GZ0yYeMtP/H1FWkf
	KNcfdBn/a4si8l8+KojJ90fVvYF5aAujt5rtjbScX9zQtSFI56781LVwk0pqOZrzJH/kEZlYu0E
	f71/Pysl1YcLkPT/JrIenzw8Ys99IPyKCxJa514+bYdAELfoEmw4uAT8=
X-Google-Smtp-Source: AGHT+IEhO/o5vp+DfBEKeWGXr9Wvc+cRH/GSKNI8DbKKNq6smqwR9eXEd3K88LMZTXEWyj80IgRRGPEy1sRYwZq1Y0VuTo6npsNj
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:190c:b0:3d4:6dcf:d8f5 with SMTP id
 e9e14a558f8ab-3d815af7e5cmr44515ab.1.1744769368081; Tue, 15 Apr 2025 19:09:28
 -0700 (PDT)
Date: Tue, 15 Apr 2025 19:09:28 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <67ff1158.050a0220.d2ea7.0004.GAE@google.com>
Subject: [syzbot] [ocfs2?] kernel BUG in __ocfs2_move_extents_range
From: syzbot <syzbot+f2107d999290b8166267@syzkaller.appspotmail.com>
To: jlbec@evilplan.org, joseph.qi@linux.alibaba.com, 
	linux-kernel@vger.kernel.org, mark@fasheh.com, ocfs2-devel@lists.linux.dev, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    e618ee89561b Merge tag 'spi-fix-v6.15-rc1' of git://git.ke..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=125f1c04580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=eecd7902e39d7933
dashboard link: https://syzkaller.appspot.com/bug?extid=f2107d999290b8166267
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/7feb34a89c2a/non_bootable_disk-e618ee89.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/2ce493533ba3/vmlinux-e618ee89.xz
kernel image: https://storage.googleapis.com/syzbot-assets/3c0d2abdecc5/bzImage-e618ee89.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+f2107d999290b8166267@syzkaller.appspotmail.com

------------[ cut here ]------------
kernel BUG at fs/ocfs2/suballoc.c:1380!
Oops: invalid opcode: 0000 [#1] SMP KASAN NOPTI
CPU: 0 UID: 0 PID: 5328 Comm: syz.0.0 Not tainted 6.15.0-rc1-syzkaller-00288-ge618ee89561b #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2~bpo12+1 04/01/2014
RIP: 0010:ocfs2_block_group_set_bits+0x891/0x9d0 fs/ocfs2/suballoc.c:1380
Code: 89 f1 80 e1 07 fe c1 38 c1 0f 8c ef fe ff ff 4c 89 f7 e8 52 05 5d fe e9 e2 fe ff ff e8 28 dd f2 fd 90 0f 0b e8 20 dd f2 fd 90 <0f> 0b f3 0f 1e fa 65 44 8b 35 15 48 98 0f bf 07 00 00 00 44 89 f6
RSP: 0018:ffffc9000d407300 EFLAGS: 00010293
RAX: ffffffff83d07810 RBX: 0000000000000054 RCX: ffff888000c08000
RDX: 0000000000000000 RSI: 0000000000000116 RDI: 0000000000000054
RBP: ffffc9000d407420 R08: ffffffff83d070bf R09: 0000000000000116
R10: 0000000000000006 R11: ffff888000c08000 R12: 0000000000000116
R13: dffffc0000000000 R14: ffff888042da4000 R15: ffff88804594cfb8
FS:  00007f60de8656c0(0000) GS:ffff88808c594000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f6ef7f74580 CR3: 0000000042f8c000 CR4: 0000000000352ef0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 ocfs2_move_extent fs/ocfs2/move_extents.c:687 [inline]
 __ocfs2_move_extents_range+0x3517/0x4470 fs/ocfs2/move_extents.c:860
 ocfs2_move_extents+0x3f0/0xac0 fs/ocfs2/move_extents.c:927
 ocfs2_ioctl_move_extents+0x61c/0x840 fs/ocfs2/move_extents.c:1053
 ocfs2_ioctl+0x19b/0x7f0 fs/ocfs2/ioctl.c:946
 vfs_ioctl fs/ioctl.c:51 [inline]
 __do_sys_ioctl fs/ioctl.c:906 [inline]
 __se_sys_ioctl+0xf1/0x160 fs/ioctl.c:892
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0xf3/0x230 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f60dd98d169
Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 a8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f60de865038 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
RAX: ffffffffffffffda RBX: 00007f60ddba6080 RCX: 00007f60dd98d169
RDX: 00002000000000c0 RSI: 0000000040406f06 RDI: 0000000000000005
RBP: 00007f60dda0e990 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 0000000000000000 R14: 00007f60ddba6080 R15: 00007ffe756de308
 </TASK>
Modules linked in:
---[ end trace 0000000000000000 ]---
RIP: 0010:ocfs2_block_group_set_bits+0x891/0x9d0 fs/ocfs2/suballoc.c:1380
Code: 89 f1 80 e1 07 fe c1 38 c1 0f 8c ef fe ff ff 4c 89 f7 e8 52 05 5d fe e9 e2 fe ff ff e8 28 dd f2 fd 90 0f 0b e8 20 dd f2 fd 90 <0f> 0b f3 0f 1e fa 65 44 8b 35 15 48 98 0f bf 07 00 00 00 44 89 f6
RSP: 0018:ffffc9000d407300 EFLAGS: 00010293
RAX: ffffffff83d07810 RBX: 0000000000000054 RCX: ffff888000c08000
RDX: 0000000000000000 RSI: 0000000000000116 RDI: 0000000000000054
RBP: ffffc9000d407420 R08: ffffffff83d070bf R09: 0000000000000116
R10: 0000000000000006 R11: ffff888000c08000 R12: 0000000000000116
R13: dffffc0000000000 R14: ffff888042da4000 R15: ffff88804594cfb8
FS:  00007f60de8656c0(0000) GS:ffff88808c594000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f6ef7f74580 CR3: 0000000042f8c000 CR4: 0000000000352ef0
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
