Received: from mail-oo1-f78.google.com (mail-oo1-f78.google.com [209.85.161.78])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8627E1F12F8
	for <ocfs2-devel@lists.linux.dev>; Sat,  3 Jan 2026 22:53:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.78
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767480802; cv=none; b=P+gkVsE2E+qw99CsQlvgvjqNyMMRZLk73Cz9kLrQ6HNKrnzIS6FjDhkxhFn5ybp6ZT5ogic+wi0kvU9aFPlgnQJ38ECKp4cF/lY5gw5tJO7e+IsebtadrYm2eTHFzZUMrTmAUt44lCz4cE/GXtcFLJ5g/aUPl7QhvDk9GNa+HpU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767480802; c=relaxed/simple;
	bh=mGs1bRVeSh+t4py1Gfv7FfzT4HdDCsHUyftLVmmZSFU=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=oPXDd+aGyPgrHSlljJguC7FsKiSMEl2+alhshNDXfZSeAyizYuUfxcL0bvZw/fivbIP2vIhfvIwDdDmWW91+ZBFt7RsqG2aRmuEdqqAorAWcecuXD9bx3M6wzt68ZQCU9Bb//acAt0wTD71/8ngRRng6TouUnTq0Te4qF1cQrlc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.161.78
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oo1-f78.google.com with SMTP id 006d021491bc7-65ec1bb9db9so22956742eaf.0
        for <ocfs2-devel@lists.linux.dev>; Sat, 03 Jan 2026 14:53:20 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767480799; x=1768085599;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=flIXbE021FeCMcmFlqoisZsta6Sm7CPdwvsH3rttcQs=;
        b=gM8D2OIZQj9CGvrXncilHXPKjkGDuVlxL8g4+06LLcMjt9uvSD0eIfadlICIgLztGb
         QdjuFXA10xycJXfA6baBSgvITIO6wJlvBaNkeOCr4yV0BhGgGDBPPIMM9weNDRQ4u/jZ
         lNxDc4NKsJgyKGv5RxwTTLTvQZluVWh91AJA26z5xFcoZP+fdMYXBG7acMtXkL1WSmDl
         PiBNQHvktgVq3QfUTpmI1HoT1p/BHryz2quaFgxv5wzp8VGYfF6l4osHYdSGF9Nh8Nas
         0eypNEKXV+iBDR//lMlUy1f2FVa+zDsAYFQWloK0BM6u4niwPYa2FauRt2bRreInwGte
         RbyQ==
X-Forwarded-Encrypted: i=1; AJvYcCXZaqe/ZLdfa+eLVpAr3o0XXm8MehngYMnO6dUD+p6+udMR76lnmV7Oji8yS7ZCy1hoq00cdi7t0QzWHw==@lists.linux.dev
X-Gm-Message-State: AOJu0Yz7fbWmteYDI8vClbYzetetu0SNP0fKrvzhd23i2nwTO/MTkDwW
	aijeuPMkzAsYrjvhGwANf1lc1Vy8MrsHRXcRNFTgvyHCUU4D44GvYmLFMi38z2s1HI+vr84l94Y
	cZNO9adJYXRlxX4vFNQ9gbgvJcB4ZbBxHuDNpQxap2Oj/J+u8tCGgBGxsdrM=
X-Google-Smtp-Source: AGHT+IH2BdaFrqbM39x2lPWkSMiuGBRHMptrduW1lB4/t4JbnKVpEehidnncN6Vo+wRrjwQqEjbzTPDCtW3XjcbXgPEMkUC+9p4m
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a4a:d84b:0:b0:659:9a49:8fbc with SMTP id
 006d021491bc7-65d0eb2ffcdmr17182359eaf.53.1767480799398; Sat, 03 Jan 2026
 14:53:19 -0800 (PST)
Date: Sat, 03 Jan 2026 14:53:19 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <69599ddf.050a0220.1c9965.0014.GAE@google.com>
Subject: [syzbot] [ocfs2?] kernel BUG in ocfs2_block_group_search
From: syzbot <syzbot+44c564a3cb08605f34a1@syzkaller.appspotmail.com>
To: jlbec@evilplan.org, joseph.qi@linux.alibaba.com, 
	linux-kernel@vger.kernel.org, mark@fasheh.com, ocfs2-devel@lists.linux.dev, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    dbf8fe85a16a Merge tag 'net-6.19-rc4' of git://git.kernel...
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=16b19792580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=513255d80ab78f2b
dashboard link: https://syzkaller.appspot.com/bug?extid=44c564a3cb08605f34a1
compiler:       Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~exp1~20250708183702.136), Debian LLD 20.1.8
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=10ef2422580000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=11b19792580000

Downloadable assets:
disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/d900f083ada3/non_bootable_disk-dbf8fe85.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/86d0a4a4173a/vmlinux-dbf8fe85.xz
kernel image: https://storage.googleapis.com/syzbot-assets/23bd847a572d/bzImage-dbf8fe85.xz
mounted in repro: https://storage.googleapis.com/syzbot-assets/97470b986566/mount_0.gz
  fsck result: OK (log: https://syzkaller.appspot.com/x/fsck.log?x=1047329a580000)

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+44c564a3cb08605f34a1@syzkaller.appspotmail.com

=======================================================
JBD2: Ignoring recovery information on journal
ocfs2: Mounting device (7,0) on (node local, slot 0) with ordered data mode.
------------[ cut here ]------------
kernel BUG at fs/ocfs2/suballoc.c:1611!
Oops: invalid opcode: 0000 [#1] SMP KASAN NOPTI
CPU: 0 UID: 0 PID: 5527 Comm: syz.0.17 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2~bpo12+1 04/01/2014
RIP: 0010:ocfs2_block_group_search+0x367/0x490 fs/ocfs2/suballoc.c:1611
Code: d9 80 e1 07 80 c1 03 38 c1 0f 8c c5 fe ff ff 48 89 df e8 0c 40 77 fe e9 b8 fe ff ff e8 92 95 0f fe 90 0f 0b e8 8a 95 0f fe 90 <0f> 0b f3 0f 1e fa 65 44 8b 3d 4f 2e cf 0e bf 07 00 00 00 44 89 fe
RSP: 0018:ffffc90002616bb8 EFLAGS: 00010293
RAX: ffffffff83b171d6 RBX: 000000000000004a RCX: ffff888000b70000
RDX: 0000000000000000 RSI: 000000000000004a RDI: 000000000000004a
RBP: 0000000000000001 R08: 00000000ffffffff R09: ffffc900026171a0
R10: dffffc0000000000 R11: ffffffff83b16e70 R12: ffff8880470b0740
R13: ffff88804453c740 R14: ffff8880230d7000 R15: 000000000000004a
FS:  000055556aa08500(0000) GS:ffff88808d416000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007fbdcf97f000 CR3: 00000000113be000 CR4: 0000000000352ef0
Call Trace:
 <TASK>
 ocfs2_search_chain+0x5f3/0x1d60 fs/ocfs2/suballoc.c:1836
 ocfs2_claim_suballoc_bits+0xc1e/0x1f60 fs/ocfs2/suballoc.c:2011
 ocfs2_claim_new_inode+0x332/0x7a0 fs/ocfs2/suballoc.c:2303
 ocfs2_mknod_locked+0x100/0x250 fs/ocfs2/namei.c:638
 ocfs2_mknod+0x10a5/0x2030 fs/ocfs2/namei.c:385
 ocfs2_create+0x195/0x420 fs/ocfs2/namei.c:677
 lookup_open fs/namei.c:4440 [inline]
 open_last_lookups fs/namei.c:4540 [inline]
 path_openat+0x18bb/0x3dd0 fs/namei.c:4784
 do_filp_open+0x1fa/0x410 fs/namei.c:4814
 do_sys_openat2+0x121/0x200 fs/open.c:1430
 do_sys_open fs/open.c:1436 [inline]
 __do_sys_openat fs/open.c:1452 [inline]
 __se_sys_openat fs/open.c:1447 [inline]
 __x64_sys_openat+0x138/0x170 fs/open.c:1447
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0xec/0xf80 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7fe1e2d8f7c9
Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 a8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007fff02afc7a8 EFLAGS: 00000246 ORIG_RAX: 0000000000000101
RAX: ffffffffffffffda RBX: 00007fe1e2fe5fa0 RCX: 00007fe1e2d8f7c9
RDX: 000000000000275a RSI: 0000200000000040 RDI: ffffffffffffff9c
RBP: 00007fe1e2e13f91 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007fe1e2fe5fa0 R14: 00007fe1e2fe5fa0 R15: 0000000000000004
 </TASK>
Modules linked in:
---[ end trace 0000000000000000 ]---
RIP: 0010:ocfs2_block_group_search+0x367/0x490 fs/ocfs2/suballoc.c:1611
Code: d9 80 e1 07 80 c1 03 38 c1 0f 8c c5 fe ff ff 48 89 df e8 0c 40 77 fe e9 b8 fe ff ff e8 92 95 0f fe 90 0f 0b e8 8a 95 0f fe 90 <0f> 0b f3 0f 1e fa 65 44 8b 3d 4f 2e cf 0e bf 07 00 00 00 44 89 fe
RSP: 0018:ffffc90002616bb8 EFLAGS: 00010293
RAX: ffffffff83b171d6 RBX: 000000000000004a RCX: ffff888000b70000
RDX: 0000000000000000 RSI: 000000000000004a RDI: 000000000000004a
RBP: 0000000000000001 R08: 00000000ffffffff R09: ffffc900026171a0
R10: dffffc0000000000 R11: ffffffff83b16e70 R12: ffff8880470b0740
R13: ffff88804453c740 R14: ffff8880230d7000 R15: 000000000000004a
FS:  000055556aa08500(0000) GS:ffff88808d416000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007fd8f777e286 CR3: 00000000113be000 CR4: 0000000000352ef0


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
