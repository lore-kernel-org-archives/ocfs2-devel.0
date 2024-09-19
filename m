Received: from mail-io1-f69.google.com (mail-io1-f69.google.com [209.85.166.69])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BBF81E535
	for <ocfs2-devel@lists.linux.dev>; Thu, 19 Sep 2024 00:02:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.69
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726704145; cv=none; b=pS84xT2RZDHGWXVZUc5kq8ywTKXN3PCCK/zcd7NvQev9vpte67cZnOk5SoHJRsD2DPwbqkWwtIkiUq4NYv5FCtz66RrP3eLAq1pOLB+RR9dy2G+te/fvLLO7y9MIcGgm8wrtl6qGBjux2VASUCOwwDVrf1v7RhhE+RQzqOmWiY8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726704145; c=relaxed/simple;
	bh=ZTxC7AaXLIB75VyF0TEPKzM/vX5Znv39MB+YUsTkYzU=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=S1PurmT0dzavZ6TVGeY/4sno3X3Qn6L7s39EK7+Ls4PVNY17QkXJl+M7SqO4hVSz8vwyZoP6/o6Qdebd6MIDSpqhFcaYETiyQ4bnXsow2sSTX8XLqIzi/SM4aLhukRILLaLrR9FliMXVThzVRxuh3tcXoVkvQLYk0fRKi6kgrBE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.69
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-io1-f69.google.com with SMTP id ca18e2360f4ac-82cdc7b7debso52082039f.3
        for <ocfs2-devel@lists.linux.dev>; Wed, 18 Sep 2024 17:02:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726704143; x=1727308943;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=w9kbYILkEEYeAUGYf/4TIJeP3dxrvi0b2gc2BycPd9E=;
        b=rHGCkQkfbvXuZwm62E+ZklPUUCggCeSnhkEigd+Yi02HuR3CcyjVUwar7IGjQ6qyr4
         xkoeK0T21ocee/vTB+8RIQ0hPvQMXP7f2BrZ5RE9B0vSIzFi/8tb+jCPWYKJxrFAf073
         9YGLHF2bRMhsTGBSAekAx3lQtnjtyhNtN3pYLCZSRCIZKlboZ4t64wzMduSTl5Xuvhjn
         EWmFStt+d10RbMWRV+2dfLQGdHjxW5KMYtg/SHIVHJPYEzsyYNlxzX2mYDqRPhWFv5wJ
         K5CtVI0qAN2DMrWa5vHHg4pEFNJwjJw8xOLRDWMVfZzssGtEi/GUMOHoFu6YpVYEQgjY
         mYvw==
X-Forwarded-Encrypted: i=1; AJvYcCXNykY5uaTxp/ykGD2zHLUvvP/luNa/C1gil3QRvcLD5BJhFIreupslh+KVaruevfYiyNdyvz1xinfT1g==@lists.linux.dev
X-Gm-Message-State: AOJu0YwSTCVpVIWfOGit1835F6gUvF6Lo2Ouk13YedlMhO1SixnZVRhu
	zpqYzcw4FzkoY03iuyoUG+Ms6p6kMtYIIVQ0z2AmxKbAQwmzS+0PXnreOzmiAjPsiVqwDQ9xVxi
	cdcCMDZAYwk1C0huZb4uDr5bb3HjaLKP4dnkYoynOxrgdzdgmyNY8JM4=
X-Google-Smtp-Source: AGHT+IFoImkwLmz1usdAyLsXBXuv7np6r1Gm7VSNbf/IPLTLMIGl0igrd8we1wIiYG+Iw9exH367fVNHQeZRqZcr9Md1yV/jc6jM
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:19cb:b0:3a0:56c8:f7ef with SMTP id
 e9e14a558f8ab-3a0848c92f9mr244834225ab.8.1726704142741; Wed, 18 Sep 2024
 17:02:22 -0700 (PDT)
Date: Wed, 18 Sep 2024 17:02:22 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <66eb6a0e.050a0220.115905.001b.GAE@google.com>
Subject: [syzbot] [ocfs2?] kernel BUG in ocfs2_write_block
From: syzbot <syzbot+c818e5c4559444f88aa0@syzkaller.appspotmail.com>
To: jlbec@evilplan.org, joseph.qi@linux.alibaba.com, 
	linux-kernel@vger.kernel.org, mark@fasheh.com, ocfs2-devel@lists.linux.dev, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    d42f7708e27c Merge tag 'for-linus-6.11' of git://git.kerne..
git tree:       upstream
console+strace: https://syzkaller.appspot.com/x/log.txt?x=16d197c7980000
kernel config:  https://syzkaller.appspot.com/x/.config?x=1c9e296880039df9
dashboard link: https://syzkaller.appspot.com/bug?extid=c818e5c4559444f88aa0
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=17c3e407980000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=12bb9900580000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/b879ea3b7dd4/disk-d42f7708.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/812a7fb7bfcc/vmlinux-d42f7708.xz
kernel image: https://storage.googleapis.com/syzbot-assets/806a22d4adbf/bzImage-d42f7708.xz
mounted in repro: https://storage.googleapis.com/syzbot-assets/e983237a6366/mount_0.gz

Bisection is inconclusive: the issue happens on the oldest tested release.

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=16fa229f980000
final oops:     https://syzkaller.appspot.com/x/report.txt?x=15fa229f980000
console output: https://syzkaller.appspot.com/x/log.txt?x=11fa229f980000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+c818e5c4559444f88aa0@syzkaller.appspotmail.com

loop0: detected capacity change from 0 to 32768
=======================================================
WARNING: The mand mount option has been deprecated and
         and is ignored by this kernel. Remove the mand
         option from the mount to silence this warning.
=======================================================
------------[ cut here ]------------
kernel BUG at fs/ocfs2/buffer_head_io.c:45!
Oops: invalid opcode: 0000 [#1] PREEMPT SMP KASAN PTI
CPU: 0 UID: 0 PID: 5224 Comm: syz-executor227 Not tainted 6.11.0-rc7-syzkaller-00151-gd42f7708e27c #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 08/06/2024
RIP: 0010:ocfs2_write_block+0x62a/0x6b0 fs/ocfs2/buffer_head_io.c:45
Code: fc ff df 80 3c 08 00 74 08 4c 89 ef e8 5f 41 7a fe 49 8b 7d 00 48 89 de 48 8b 54 24 08 e8 de 44 11 00 eb 2e e8 97 1d 16 fe 90 <0f> 0b e8 8f 1d 16 fe 90 0f 0b e8 97 aa 33 08 e8 82 1d 16 fe 49 bd
RSP: 0018:ffffc90003326dc0 EFLAGS: 00010293
RAX: ffffffff837d6ec9 RBX: 0000000000000000 RCX: ffff88801b318000
RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000002
RBP: ffffc90003326e90 R08: ffffffff837d6a20 R09: 1ffffffff1fee945
R10: dffffc0000000000 R11: fffffbfff1fee946 R12: ffff88807e9ef2d0
R13: dffffc0000000000 R14: ffff88807e9ef2b8 R15: ffff888011958000
FS:  0000555580ce5380(0000) GS:ffff8880b8800000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007fae84395ed8 CR3: 0000000078dfe000 CR4: 00000000003506f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 ocfs2_update_disk_slot+0x498/0x690 fs/ocfs2/slot_map.c:197
 ocfs2_find_slot+0x4cb/0xaa0 fs/ocfs2/slot_map.c:482
 ocfs2_mount_volume+0x1a0/0x1940 fs/ocfs2/super.c:1806
 ocfs2_fill_super+0x483b/0x5880 fs/ocfs2/super.c:1084
 mount_bdev+0x20a/0x2d0 fs/super.c:1679
 legacy_get_tree+0xee/0x190 fs/fs_context.c:662
 vfs_get_tree+0x90/0x2b0 fs/super.c:1800
 do_new_mount+0x2be/0xb40 fs/namespace.c:3472
 do_mount fs/namespace.c:3812 [inline]
 __do_sys_mount fs/namespace.c:4020 [inline]
 __se_sys_mount+0x2d6/0x3c0 fs/namespace.c:3997
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f2a220a1dea
Code: d8 64 89 02 48 c7 c0 ff ff ff ff eb a6 e8 5e 04 00 00 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 49 89 ca b8 a5 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 b8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007ffc219a6e28 EFLAGS: 00000282 ORIG_RAX: 00000000000000a5
RAX: ffffffffffffffda RBX: 00007ffc219a6e40 RCX: 00007f2a220a1dea
RDX: 0000000020000280 RSI: 0000000020000040 RDI: 00007ffc219a6e40
RBP: 0000000000000004 R08: 00007ffc219a6e80 R09: 0000000000004440
R10: 00000000000008c0 R11: 0000000000000282 R12: 00000000000008c0
R13: 00007ffc219a6e80 R14: 0000000000000003 R15: 0000000001000000
 </TASK>
Modules linked in:
---[ end trace 0000000000000000 ]---
RIP: 0010:ocfs2_write_block+0x62a/0x6b0 fs/ocfs2/buffer_head_io.c:45
Code: fc ff df 80 3c 08 00 74 08 4c 89 ef e8 5f 41 7a fe 49 8b 7d 00 48 89 de 48 8b 54 24 08 e8 de 44 11 00 eb 2e e8 97 1d 16 fe 90 <0f> 0b e8 8f 1d 16 fe 90 0f 0b e8 97 aa 33 08 e8 82 1d 16 fe 49 bd
RSP: 0018:ffffc90003326dc0 EFLAGS: 00010293
RAX: ffffffff837d6ec9 RBX: 0000000000000000 RCX: ffff88801b318000
RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000002
RBP: ffffc90003326e90 R08: ffffffff837d6a20 R09: 1ffffffff1fee945
R10: dffffc0000000000 R11: fffffbfff1fee946 R12: ffff88807e9ef2d0
R13: dffffc0000000000 R14: ffff88807e9ef2b8 R15: ffff888011958000
FS:  0000555580ce5380(0000) GS:ffff8880b8900000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000560086f89778 CR3: 0000000078dfe000 CR4: 00000000003506f0
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
