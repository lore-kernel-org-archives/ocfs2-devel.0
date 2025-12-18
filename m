Received: from mail-oo1-f77.google.com (mail-oo1-f77.google.com [209.85.161.77])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC8C71F874C
	for <ocfs2-devel@lists.linux.dev>; Thu, 18 Dec 2025 15:15:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.77
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766070939; cv=none; b=I9HN7DIisAj6YL0KLPim8laXtuLa1VEHYUycz91wIpTXq1vo93Po1s138XEM9NDAHyXqwZX1eSy5hkzR3so9vKivL9chM12wl7619Rp+tY3qiExM8JgjtUdZyFb336rCIeKmRu4Mz5FuarJG9IEUyERlkoM1/j3jcP/BbzA2Rvo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766070939; c=relaxed/simple;
	bh=sUOFaU02Zy/kdvKtoxhBQCPrLJsVk+gO+qKT+CQgfgM=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=T5Q7fPKA7QLkMyFAr/q0L01TnT8tZ6F4mntr9G2P8WE0gfgguGbUCj6z4q4BJIMXqIhMqknzSkKm4gK1bj8W77nbSYrhwRADH7x8X2gUd0N1sZRhrMbiNiOx7Rw+yvra8XyflM583Z2mU5vnYo3eLolxGJeTu6rAr8KQ8iY1KkA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.161.77
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oo1-f77.google.com with SMTP id 006d021491bc7-6579875eaa2so819488eaf.3
        for <ocfs2-devel@lists.linux.dev>; Thu, 18 Dec 2025 07:15:33 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766070930; x=1766675730;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=26AQ1iXf+7Vt16LXqCfxdwjtkNq6rSrIyTXasEhwexc=;
        b=W2vyz+AS5qUvyRwU/1jHCEqFp583FE5kSFEDvtYWdmq4tcp24T8KMlKKqUn8QzwlH5
         WB1rloM099TY8QQBYHmbITN8AXVmXaxwCzqDZEp5sH4A9BybInauLzgIlmJmSkbA661Y
         xWbswsL4tn+/Rp3Ub5kMg3WlIUspvyUc/NMlZVk4y2FoVe4wP6/IReGVUha0x1NTKwY1
         TNFnDP/hLYedtNi21PBcvnd2+jP06XweBqA9cVD0LpPiebajf8tJlQRrJpQTB2V98530
         B57L9Ok33E8YxCFz1mvFGmFqCOHUP1faLM2WRL6FS4Y60PGs0kACZ3Cmj3u7+kDULAgl
         S2ug==
X-Forwarded-Encrypted: i=1; AJvYcCVHFNCaotVWo2eYdv4oo2vi2vuylp+IC4a4PqxR5CSL+kFYCfTyUX0Q/VsmXbaB46bjlX3qHXjmXfP/lA==@lists.linux.dev
X-Gm-Message-State: AOJu0YzRUe36XOIifmaxV1Mz9QMZ5DSZJuyWdeKRht98QTB5lba4/xJR
	kmDKnwN9XWDnWOtdPoH3z7eG28W8UCZ2dxH8tJ6tKkdbdyKcC/R/XYgjwNtU4mAgd7UrQFW1gXV
	GfuM4N5bd/pS2OIqWv6VLye1EetVkiZT/OyfNN91Z+r43MeWs+79fijPHgrU=
X-Google-Smtp-Source: AGHT+IGYQcJvWittys27dBCzKf7TNs4HmUrv+VmnEjZ/y6hYize7sN1dDrFutDLl2feOdc74pfu2ZqScJC3Is6T+St91tKBJSwyD
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a4a:d74c:0:b0:65d:5e1:ed1f with SMTP id
 006d021491bc7-65d05e1f7bamr380364eaf.29.1766070930672; Thu, 18 Dec 2025
 07:15:30 -0800 (PST)
Date: Thu, 18 Dec 2025 07:15:30 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <69441a92.a70a0220.207337.00e4.GAE@google.com>
Subject: [syzbot] [ocfs2?] kernel BUG in ocfs2_move_extents
From: syzbot <syzbot+7960178e777909060224@syzkaller.appspotmail.com>
To: jlbec@evilplan.org, joseph.qi@linux.alibaba.com, 
	linux-kernel@vger.kernel.org, mark@fasheh.com, ocfs2-devel@lists.linux.dev, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    ea1013c15392 Merge tag 'bpf-fixes' of git://git.kernel.org..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=179abdc2580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=513255d80ab78f2b
dashboard link: https://syzkaller.appspot.com/bug?extid=7960178e777909060224
compiler:       Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~exp1~20250708183702.136), Debian LLD 20.1.8

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/d900f083ada3/non_bootable_disk-ea1013c1.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/ea4d0b50128d/vmlinux-ea1013c1.xz
kernel image: https://storage.googleapis.com/syzbot-assets/f2e7f1524121/bzImage-ea1013c1.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+7960178e777909060224@syzkaller.appspotmail.com

loop0: detected capacity change from 0 to 32768
=======================================================
WARNING: The mand mount option has been deprecated and
         and is ignored by this kernel. Remove the mand
         option from the mount to silence this warning.
=======================================================
JBD2: Ignoring recovery information on journal
ocfs2: Mounting device (7,0) on (node local, slot 0) with ordered data mode.
(syz.0.0,5341,0):ocfs2_dio_end_io:2401 ERROR: Direct IO failed, bytes = -28
------------[ cut here ]------------
kernel BUG at fs/ocfs2/suballoc.c:1383!
Oops: invalid opcode: 0000 [#1] SMP KASAN NOPTI
CPU: 0 UID: 0 PID: 5341 Comm: syz.0.0 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2~bpo12+1 04/01/2014
RIP: 0010:ocfs2_block_group_set_bits+0x857/0x980 fs/ocfs2/suballoc.c:1383
Code: 07 fe c1 38 c1 0f 8c b8 fe ff ff 4c 89 e7 89 f3 e8 ce ae 76 fe 89 de e9 a7 fe ff ff e8 82 c7 0e fe 90 0f 0b e8 7a c7 0e fe 90 <0f> 0b f3 0f 1e fa 65 8b 1d b0 65 ec 0e bf 07 00 00 00 89 de e8 a0
RSP: 0018:ffffc9000ec973e0 EFLAGS: 00010246
RAX: ffffffff83b2fa76 RBX: 0000000000000001 RCX: 0000000000100000
RDX: ffffc90020802000 RSI: 00000000000fffff RDI: 0000000000100000
RBP: ffffc9000ec97500 R08: 0000000000000007 R09: 00000000000000f8
R10: 00000000fffffffc R11: 0000000000000002 R12: 1ffff1100253aa01
R13: 00000000000000f8 R14: ffff8880478e4fb8 R15: dffffc0000000000
FS:  00007f460e7df6c0(0000) GS:ffff88808d22a000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f46027ff000 CR3: 0000000011427000 CR4: 0000000000352ef0
Call Trace:
 <TASK>
 ocfs2_move_extent fs/ocfs2/move_extents.c:693 [inline]
 __ocfs2_move_extents_range fs/ocfs2/move_extents.c:865 [inline]
 ocfs2_move_extents+0x2c39/0x3dd0 fs/ocfs2/move_extents.c:937
 ocfs2_ioctl_move_extents+0x568/0x740 fs/ocfs2/move_extents.c:1069
 ocfs2_ioctl+0x191/0x750 fs/ocfs2/ioctl.c:942
 vfs_ioctl fs/ioctl.c:51 [inline]
 __do_sys_ioctl fs/ioctl.c:597 [inline]
 __se_sys_ioctl+0xfc/0x170 fs/ioctl.c:583
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0xfa/0xf80 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f460d98f7c9
Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 a8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f460e7df038 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
RAX: ffffffffffffffda RBX: 00007f460dbe5fa0 RCX: 00007f460d98f7c9
RDX: 00002000000000c0 RSI: 0000000040406f06 RDI: 0000000000000004
RBP: 00007f460da13f91 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007f460dbe6038 R14: 00007f460dbe5fa0 R15: 00007fff6d300b38
 </TASK>
Modules linked in:
---[ end trace 0000000000000000 ]---
RIP: 0010:ocfs2_block_group_set_bits+0x857/0x980 fs/ocfs2/suballoc.c:1383
Code: 07 fe c1 38 c1 0f 8c b8 fe ff ff 4c 89 e7 89 f3 e8 ce ae 76 fe 89 de e9 a7 fe ff ff e8 82 c7 0e fe 90 0f 0b e8 7a c7 0e fe 90 <0f> 0b f3 0f 1e fa 65 8b 1d b0 65 ec 0e bf 07 00 00 00 89 de e8 a0
RSP: 0018:ffffc9000ec973e0 EFLAGS: 00010246
RAX: ffffffff83b2fa76 RBX: 0000000000000001 RCX: 0000000000100000
RDX: ffffc90020802000 RSI: 00000000000fffff RDI: 0000000000100000
RBP: ffffc9000ec97500 R08: 0000000000000007 R09: 00000000000000f8
R10: 00000000fffffffc R11: 0000000000000002 R12: 1ffff1100253aa01
R13: 00000000000000f8 R14: ffff8880478e4fb8 R15: dffffc0000000000
FS:  00007f460e7df6c0(0000) GS:ffff88808d22a000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f46027ff000 CR3: 0000000011427000 CR4: 0000000000352ef0


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
