Received: from mail-il1-f198.google.com (mail-il1-f198.google.com [209.85.166.198])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62A1114D29D
	for <ocfs2-devel@lists.linux.dev>; Sat, 12 Oct 2024 09:51:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.198
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728726690; cv=none; b=O2O+wDqhRu68Hds0LZQ/XgY1acy3KFsKTepOj3+JcR+u6yIkM1uMQNwXuD60+xGqK4o2UMk5Hh5SSOzDyqna3ffnCQTTq1b4yazjYqUdTWOSfC2k/bZDUOrfFE4YpryBDz7YEYXZZYE7SP3McssozFLATw2iqM0ZIlUDHC5yQl4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728726690; c=relaxed/simple;
	bh=1wZHRsNIL3b+zY4gZFxYiMfK+2HIge8wzhwItDkcSuo=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=Er0pIyIkKtHXOGsoAO7lqh0TCRway0xAc1cbPRgURDS1hgi55hbQdi+ohJgz1BIKX0iEAHwu00uqll/Z/INwxwLQ6nQnqysus2SdBETXMXbTN5qaotp8FQfI3k+31HeDyRjYhGw6HruiSQrHupCgZbjbFbUztZwkywePg09u2DQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.198
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f198.google.com with SMTP id e9e14a558f8ab-3a3bcae85a5so4290475ab.1
        for <ocfs2-devel@lists.linux.dev>; Sat, 12 Oct 2024 02:51:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728726688; x=1729331488;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ISkzNIwcxKCi4MsIw6vsqZY/ns0b+a54JSlHPYleXCs=;
        b=pPCOUGTIhxR5voW+JTjildBy3tLmXmNDIgMaGGhmtWknBnJ+NIX7+tqEtl8Zkyrms5
         JyscBSA7MK+aNvPohmnBVKcFhaIKTOGVebgVWZTiPX93n0F5cUIkrQ9k5U+K9wkQ4HmU
         xmmlyi5HC6LyA8HdiVTdZHdtY6fj7cQClsGPUgcj8swwS2Vs2FwxfUjWZDooeKgDpP3p
         aLOsN1sU4MyIyOyAE//IBfgBziDAVjKR6UBhQFQFQiy2U81yRir5pYSvODpAWPP+XSaM
         PqinTKTL0CweWOd3BIsOeOGS7b6kgSBVH2N7wsgJOnuQ8p9kVpV51lLHxbz4zqSMx64G
         w4uQ==
X-Forwarded-Encrypted: i=1; AJvYcCUgLd+g/TpPukR+aYdep2X2ciP5O6FHm8uUOYvh0hKMHMow3y1uajPUu7eHeuoenv5fDo2sseRl6jZAew==@lists.linux.dev
X-Gm-Message-State: AOJu0YzwUC1z3HgcComGDiX3tgfkoywlSbbPR6i2NmaN91cfrPOYCAPl
	/eNYcUd2P+WWO9ZkIP9f/c6NVXhOAzLaPaLY92hhuNBNs93IE522iwGMftulQU7jU5FIA1bAflH
	95T0Y+mD3Dx8kbb9syBQwavE+K9qAx3VUhpggOhvLynH2Dk0qVsMuh7A=
X-Google-Smtp-Source: AGHT+IGDY6tlmGxCjDErUZ9fIN/FYDK4Wwk0kUq8g8AHRcmWNkYpH1TsCAhMU+P84G9sojLNsiW3h/yfBnvicxZjfeUzvnES7gLV
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a92:ca4b:0:b0:395:e85e:f2fa with SMTP id
 e9e14a558f8ab-3a3b5844745mr39881005ab.1.1728726688320; Sat, 12 Oct 2024
 02:51:28 -0700 (PDT)
Date: Sat, 12 Oct 2024 02:51:28 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <670a46a0.050a0220.4cbc0.001e.GAE@google.com>
Subject: [syzbot] [ocfs2?] kernel BUG in ocfs2_read_virt_blocks
From: syzbot <syzbot+797d4829dafe3f11dce7@syzkaller.appspotmail.com>
To: jlbec@evilplan.org, joseph.qi@linux.alibaba.com, 
	linux-kernel@vger.kernel.org, mark@fasheh.com, ocfs2-devel@lists.linux.dev, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    87d6aab2389e Merge tag 'for_linus' of git://git.kernel.org..
git tree:       upstream
console+strace: https://syzkaller.appspot.com/x/log.txt?x=17fbbb80580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=7a3fccdd0bb995
dashboard link: https://syzkaller.appspot.com/bug?extid=797d4829dafe3f11dce7
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=13c117d0580000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1007bb80580000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/47c26a185f6d/disk-87d6aab2.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/fe82dfdaaac4/vmlinux-87d6aab2.xz
kernel image: https://storage.googleapis.com/syzbot-assets/ecaba119a5f0/bzImage-87d6aab2.xz
mounted in repro: https://storage.googleapis.com/syzbot-assets/197dcbc41fea/mount_0.gz

Bisection is inconclusive: the issue happens on the oldest tested release.

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=114db707980000
final oops:     https://syzkaller.appspot.com/x/report.txt?x=134db707980000
console output: https://syzkaller.appspot.com/x/log.txt?x=154db707980000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+797d4829dafe3f11dce7@syzkaller.appspotmail.com

JBD2: Ignoring recovery information on journal
ocfs2: Mounting device (7,0) on (node local, slot 0) with ordered data mode.
------------[ cut here ]------------
kernel BUG at fs/ocfs2/extent_map.c:971!
Oops: invalid opcode: 0000 [#1] PREEMPT SMP KASAN PTI
CPU: 1 UID: 0 PID: 5221 Comm: syz-executor117 Not tainted 6.12.0-rc2-syzkaller-00006-g87d6aab2389e #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 09/13/2024
RIP: 0010:ocfs2_read_virt_blocks+0xaa3/0xb20 fs/ocfs2/extent_map.c:971
Code: 8b 54 24 30 8b 4c 24 1c 4c 8b 44 24 38 45 89 e1 ff 74 24 48 e8 7e 0a 0c 00 48 83 c4 08 eb 25 e8 43 d2 34 08 e8 ee d1 0c fe 90 <0f> 0b e8 e6 d1 0c fe 4c 89 e8 45 89 e5 49 89 c4 e9 01 f7 ff ff e8
RSP: 0018:ffffc90002e2e820 EFLAGS: 00010293
RAX: ffffffff83881432 RBX: 0000000000000000 RCX: ffff88802d3e9e00
RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000000
RBP: ffffc90002e2e9f0 R08: ffffffff83880eae R09: 1ffffffff203781d
R10: dffffc0000000000 R11: fffffbfff203781e R12: ffff8880764d8878
R13: 0000000000000000 R14: 0000000000000000 R15: 1ffff920005c5d18
FS:  000055557cd55380(0000) GS:ffff8880b8700000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00005628fd41e058 CR3: 000000002d2e6000 CR4: 00000000003526f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 ocfs2_read_dir_block+0x106/0x5c0 fs/ocfs2/dir.c:508
 ocfs2_find_dir_space_el fs/ocfs2/dir.c:3427 [inline]
 ocfs2_prepare_dir_for_insert+0x3f2/0x5c60 fs/ocfs2/dir.c:4274
 ocfs2_mknod+0xcaf/0x2b40 fs/ocfs2/namei.c:292
 ocfs2_create+0x1ab/0x480 fs/ocfs2/namei.c:672
 lookup_open fs/namei.c:3595 [inline]
 open_last_lookups fs/namei.c:3694 [inline]
 path_openat+0x1c03/0x3590 fs/namei.c:3930
 do_filp_open+0x235/0x490 fs/namei.c:3960
 do_sys_openat2+0x13e/0x1d0 fs/open.c:1415
 do_sys_open fs/open.c:1430 [inline]
 __do_sys_openat fs/open.c:1446 [inline]
 __se_sys_openat fs/open.c:1441 [inline]
 __x64_sys_openat+0x247/0x2a0 fs/open.c:1441
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7fa356467d59
Code: 28 00 00 00 75 05 48 83 c4 28 c3 e8 f1 17 00 00 90 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 b8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007ffe912bab08 EFLAGS: 00000246 ORIG_RAX: 0000000000000101
RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007fa356467d59
RDX: 000000000000275a RSI: 0000000020000040 RDI: 00000000ffffff9c
RBP: 00007fa3564e05f0 R08: 0000000000004472 R09: 000055557cd564c0
R10: 0000000000000000 R11: 0000000000000246 R12: 00007ffe912bab30
R13: 00007ffe912bad58 R14: 431bde82d7b634db R15: 00007fa3564b103b
 </TASK>
Modules linked in:
---[ end trace 0000000000000000 ]---
RIP: 0010:ocfs2_read_virt_blocks+0xaa3/0xb20 fs/ocfs2/extent_map.c:971
Code: 8b 54 24 30 8b 4c 24 1c 4c 8b 44 24 38 45 89 e1 ff 74 24 48 e8 7e 0a 0c 00 48 83 c4 08 eb 25 e8 43 d2 34 08 e8 ee d1 0c fe 90 <0f> 0b e8 e6 d1 0c fe 4c 89 e8 45 89 e5 49 89 c4 e9 01 f7 ff ff e8
RSP: 0018:ffffc90002e2e820 EFLAGS: 00010293
RAX: ffffffff83881432 RBX: 0000000000000000 RCX: ffff88802d3e9e00
RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000000
RBP: ffffc90002e2e9f0 R08: ffffffff83880eae R09: 1ffffffff203781d
R10: dffffc0000000000 R11: fffffbfff203781e R12: ffff8880764d8878
R13: 0000000000000000 R14: 0000000000000000 R15: 1ffff920005c5d18
FS:  000055557cd55380(0000) GS:ffff8880b8700000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00005628fd41e058 CR3: 000000002d2e6000 CR4: 00000000003526f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
For information about bisection process see: https://goo.gl/tpsmEJ#bisection

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
