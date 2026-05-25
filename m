Received: from mail-ot1-f79.google.com (mail-ot1-f79.google.com [209.85.210.79])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5658B1A38F9
	for <ocfs2-devel@lists.linux.dev>; Mon, 25 May 2026 05:10:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.79
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779685836; cv=none; b=RNQCwjoh+Ml/WgozB0sI2tb+8rn22E8MgusYiqcNqCCYS+mbaCxVCqv/LIuSyHJzxNxFYhrFAzR65maI9ptFY9t0oV2rmyrNMogm9Xwd3flyYe55kf/H3BhK9tSXFRjr212oNpWcHv9i3ULRk22whMMxvsi+vj5zwe0zfdE153Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779685836; c=relaxed/simple;
	bh=v30aYATmuDmrmNd8RtDhFM1+gSZszQ/uAM7pRiV54dU=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=KOkx2CUmNcc7JGNhG2Gcjj+ZaBqmWVziRuAAsXWX8XLGjlV/Z8RAsyRkQBzQ+SHfBYdWNOaNOvslGIIJAX9KRK+H4zD4NHPfFdYWq0DU6/0wC3tP0oHQknf5+K39Vbm5ZchTKLIt5/GEbkT4EJ9Hd8cG2M2KeUH/SHVWZ7msaUs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.210.79
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-ot1-f79.google.com with SMTP id 46e09a7af769-7e61d8d99dfso2783200a34.2
        for <ocfs2-devel@lists.linux.dev>; Sun, 24 May 2026 22:10:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779685834; x=1780290634;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=SFYnM5zzJUJ9FQeHeE81pgk1IUuW0SaM4j3QYHTx9AI=;
        b=WCsfOFuANGu0pmGPl1cBd3Lbr8vb9BIjKNFt9rEqZxuL2+EyHR86ZENGw4H+KW2BYu
         w1XmDGAmnZ2kd05+D6F71exgc8ZIki+sv5xcdfTv1Yc7k1qxnffnCJHhBmWAdoQQzHkt
         s3eWNgEYxcxw0YRAkAgakRaPxaGpL7OsB4kV+gGUaRb1Gwvc6bUjr3yJ2a8RJmxKS47u
         qBfnOGYJPQpwspU060znHbycQ7OW3rWf39Zw14NToBiw1uuAAFzBvj0jr5yA/jX5ex7L
         ct4s0v6iKFQjmxH2yDmVUBu2UMVsIbFbQN8XVD5extEEIX354+o0jjyr2jxjfnfpA73y
         HuWQ==
X-Forwarded-Encrypted: i=1; AFNElJ+ypzQkJN40CLFV4VPtfHkbVnFE2WHlhgqx3VQ83OLEWM1ta3Xtl9LKQJ0j79+LNu0riqfQsgRj6aQV0g==@lists.linux.dev
X-Gm-Message-State: AOJu0Yxs7ev9K4324J6Po7I1Fhgp8Kl5c2cqmynXROehWQfsW+0HLaRG
	GK2LrLZHOtx0S3oEAeSp7kMyYw2I8616Rx4B/iFVzbo3egWzlu2Hg4EE2IVbmnYM7ZQbYLju7/8
	FL3QID7POR4M3m9UU9J2honlR5cPQy/mFU6zna6YATt3L9nK3XGFWTOKkhsg=
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6820:2d05:b0:69d:ad9a:290e with SMTP id
 006d021491bc7-69dad9a2c71mr1992949eaf.6.1779685834268; Sun, 24 May 2026
 22:10:34 -0700 (PDT)
Date: Sun, 24 May 2026 22:10:34 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6a13d9ca.050a0220.7dd1.0000.GAE@google.com>
Subject: [syzbot] [ocfs2?] kernel BUG in ocfs2_page_mkwrite (4)
From: syzbot <syzbot+42984127d45ad96219de@syzkaller.appspotmail.com>
To: jlbec@evilplan.org, joseph.qi@linux.alibaba.com, 
	linux-kernel@vger.kernel.org, mark@fasheh.com, ocfs2-devel@lists.linux.dev, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    df685633c3db Merge tag 'rcu-fixes.v7.1-20260519a' of git:/..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=14674c2e580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=7f195f6be48c12ec
dashboard link: https://syzkaller.appspot.com/bug?extid=42984127d45ad96219de
compiler:       Debian clang version 21.1.8 (++20251221033036+2078da43e25a-1~exp1~20251221153213.50), Debian LLD 21.1.8

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/d900f083ada3/non_bootable_disk-df685633.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/0d8ce459af2e/vmlinux-df685633.xz
kernel image: https://storage.googleapis.com/syzbot-assets/5f8a4c255465/bzImage-df685633.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+42984127d45ad96219de@syzkaller.appspotmail.com

(syz.0.0,5323,0):__ocfs2_journal_access:724 ERROR: Error -30 getting 1 access to buffer!
(syz.0.0,5323,0):ocfs2_write_end_nolock:1945 ERROR: status = -30
(syz.0.0,5323,0):ocfs2_commit_trans:401 ERROR: status = -5
------------[ cut here ]------------
kernel BUG at fs/ocfs2/mmap.c:106!
Oops: invalid opcode: 0000 [#1] SMP KASAN NOPTI
CPU: 0 UID: 0 PID: 5323 Comm: syz.0.0 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
RIP: 0010:__ocfs2_page_mkwrite fs/ocfs2/mmap.c:106 [inline]
RIP: 0010:ocfs2_page_mkwrite+0xb53/0xb60 fs/ocfs2/mmap.c:143
Code: 87 6a fe e9 bc fd ff ff e8 9a 0b e3 07 e8 d5 bb fd fd 4c 89 f7 48 c7 c6 e0 1c 13 8c e8 26 f6 5f fd 90 0f 0b e8 be bb fd fd 90 <0f> 0b cc cc cc cc cc cc cc cc cc cc cc 90 90 90 90 90 90 90 90 90
RSP: 0018:ffffc9000f937940 EFLAGS: 00010293
RAX: ffffffff83c81872 RBX: 00000000ffffffe2 RCX: ffff88801cf4a500
RDX: 0000000000000000 RSI: 0000000000001000 RDI: 00000000ffffffe2
RBP: ffffc9000f937ae0 R08: ffffffff9030f0f7 R09: 1ffffffff2061e1e
R10: dffffc0000000000 R11: fffffbfff2061e1f R12: 000000000000c000
R13: dffffc0000000000 R14: 0000000000000000 R15: 0000000000001000
FS:  0000555567afd540(0000) GS:ffff88808c87e000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 000020000000c000 CR3: 0000000041fff000 CR4: 0000000000352ef0
Call Trace:
 <TASK>
 do_page_mkwrite+0x14d/0x310 mm/memory.c:3684
 do_shared_fault mm/memory.c:5985 [inline]
 do_fault mm/memory.c:6047 [inline]
 do_pte_missing+0x6dc/0x33f0 mm/memory.c:4566
 handle_pte_fault mm/memory.c:6427 [inline]
 __handle_mm_fault mm/memory.c:6565 [inline]
 handle_mm_fault+0x1bd9/0x3170 mm/memory.c:6734
 do_user_addr_fault+0x75b/0x1340 arch/x86/mm/fault.c:1385
 handle_page_fault arch/x86/mm/fault.c:1474 [inline]
 exc_page_fault+0x6a/0xc0 arch/x86/mm/fault.c:1527
 asm_exc_page_fault+0x26/0x30 arch/x86/include/asm/idtentry.h:618
RIP: 0033:0x7f762596d749
Code: dd 00 01 74 a3 83 f9 c0 0f 87 59 fe ff ff 62 e1 fe 28 6f 4e 01 48 29 fe 48 83 c7 3f 49 8d 0c 10 48 83 e7 c0 48 01 fe 48 29 f9 <f3> a4 62 c1 fe 28 7f 00 62 c1 fe 28 7f 48 01 c3 0f 1f 80 00 00 00
RSP: 002b:00007ffda9016b28 EFLAGS: 00010202
RAX: 00002000000079c0 RBX: 0000000000000004 RCX: 0000000000000ecb
RDX: 000000000000550b RSI: 00007f762540c53f RDI: 000020000000c000
RBP: fffffffffffffffe R08: 00002000000079c0 R09: 0000000000000002
R10: 000000000000550b R11: 0000000000000002 R12: 00007ffda9016c50
R13: 00007f7625c15fac R14: 0000000000014e7a R15: 00007f7625c15fa0
 </TASK>
Modules linked in:
---[ end trace 0000000000000000 ]---
RIP: 0010:__ocfs2_page_mkwrite fs/ocfs2/mmap.c:106 [inline]
RIP: 0010:ocfs2_page_mkwrite+0xb53/0xb60 fs/ocfs2/mmap.c:143
Code: 87 6a fe e9 bc fd ff ff e8 9a 0b e3 07 e8 d5 bb fd fd 4c 89 f7 48 c7 c6 e0 1c 13 8c e8 26 f6 5f fd 90 0f 0b e8 be bb fd fd 90 <0f> 0b cc cc cc cc cc cc cc cc cc cc cc 90 90 90 90 90 90 90 90 90
RSP: 0018:ffffc9000f937940 EFLAGS: 00010293
RAX: ffffffff83c81872 RBX: 00000000ffffffe2 RCX: ffff88801cf4a500
RDX: 0000000000000000 RSI: 0000000000001000 RDI: 00000000ffffffe2
RBP: ffffc9000f937ae0 R08: ffffffff9030f0f7 R09: 1ffffffff2061e1e
R10: dffffc0000000000 R11: fffffbfff2061e1f R12: 000000000000c000
R13: dffffc0000000000 R14: 0000000000000000 R15: 0000000000001000
FS:  0000555567afd540(0000) GS:ffff88808c87e000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 000020000000c000 CR3: 0000000041fff000 CR4: 0000000000352ef0


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
