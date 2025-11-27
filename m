Received: from mail-il1-f205.google.com (mail-il1-f205.google.com [209.85.166.205])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00561298CC0
	for <ocfs2-devel@lists.linux.dev>; Thu, 27 Nov 2025 01:11:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.205
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764205891; cv=none; b=Oy6cyBscGNkTK0YuGqF0cYzSDOECiAaroihU9bCagr7ZsAyFxX8XxMpfrilpUTuwKjzsrnEeBq45GXz4Jzcv4BTpK/x/yD77Hy1nNZJkBwbcsX0AVfSHzflnsUqmu5YaQewcv6kgUgghwU9+d8hO8yfwvTtixhWypt0QiYojeNg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764205891; c=relaxed/simple;
	bh=7R0ZQoOJyk4uySIpYyAxesSIrAHhVTUMOTKlpzL4+8g=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=J8HDfcDz5k9X6weoWwy9ye4fc6Q1o3VyWWZKf4T0HddaelzQEVWj2F7zd9DnMsiY8dV3giGqabRTRFeCPLGuNHXu//ZxPlu7zA/ZGIM8hIlrPonxLBjd+LaBw5IcOYVrRqDDs3DC+hcczwMFddFv1DjgqFvUQR/z59kklTYfRjg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.205
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f205.google.com with SMTP id e9e14a558f8ab-43335646758so3048265ab.3
        for <ocfs2-devel@lists.linux.dev>; Wed, 26 Nov 2025 17:11:29 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764205889; x=1764810689;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ixp5c2x+LqidjC6Ae0RydcerYlBBw1F/PXAVHMKgpG4=;
        b=LMqdhpo4tHPjtwqi9SYWd2ueAI8hGKWeDS/5HiYZn5DpIjtWnaLDr3BbO48VbTAiDn
         kk9OLoLqLFwE77SaxjAgXGOAaL49Z7KedO0No8kRFES9xMVl12lgllTSCYF2UJJSbGCm
         qG1x3yZ4ZpiouylCaVd1JIwNPYZjt7MENjjrxJkbdbXvdwP4VjjXJ7FUtOMhiDO2xROs
         fFyq08xLATkxKGENuyQR5FL85f7T+tioYvEGgeGXG+25MSNRUWuCFv5BrfNglfD0sOY0
         IwMuFvuPxMWLx+yokxz/fYHanvWEo5xXN83ow0ywuTAX8ZF+0US+LWgKcj7lYO8CRr8W
         P2CQ==
X-Forwarded-Encrypted: i=1; AJvYcCXGrTs6AnFUmmRWehRU5K4Z8RYlULb8uE+7d0cse/wnu0lixcJ3k81gP2hXBD0OtQCLVEtDo1r9r7wwdA==@lists.linux.dev
X-Gm-Message-State: AOJu0Ywz9SV+Cou/+TSeNzgEn15GRRIgSj3F3tNcjRHH73BJOzaltwWt
	Pn4NIQvbhus6c/Ymy0Np2DXQ0pGi0frKXvh6Sj5off4DJj1qKnVBTJYgTygF17pVVwZOE2VlVtt
	O+ktaza2p/KzXtuNlayiNzklWsSQ8RTZHt+3jUoRjnrt9nFlBsdIrKe1E/kA=
X-Google-Smtp-Source: AGHT+IGEE8/pnrzhnYX8ck5AaL7N8EXrIB8yaZoRaPRxPFHiPwaNcRerhbtfQu+8Y6DUqA/SQFLgjFD9BabAut3t1w6+cXtYqEWp
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1806:b0:42d:8b25:47ed with SMTP id
 e9e14a558f8ab-435b8e3d9f4mr192384765ab.6.1764205889191; Wed, 26 Nov 2025
 17:11:29 -0800 (PST)
Date: Wed, 26 Nov 2025 17:11:29 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6927a541.a70a0220.d98e3.00e5.GAE@google.com>
Subject: [syzbot] [ocfs2?] kernel BUG in ocfs2_remove_btree_range (2)
From: syzbot <syzbot+f82afc4d4e74d0ef7a89@syzkaller.appspotmail.com>
To: jlbec@evilplan.org, joseph.qi@linux.alibaba.com, 
	linux-kernel@vger.kernel.org, mark@fasheh.com, ocfs2-devel@lists.linux.dev, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    89edd36fd801 Merge tag 'xfs-fixes-6.18-rc7' of git://git.k..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=1235397c580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=a1db0fea040c2a9f
dashboard link: https://syzkaller.appspot.com/bug?extid=f82afc4d4e74d0ef7a89
compiler:       Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~exp1~20250708183702.136), Debian LLD 20.1.8
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=134d0612580000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=15c03a12580000

Downloadable assets:
disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/d900f083ada3/non_bootable_disk-89edd36f.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/80049f7c5ae9/vmlinux-89edd36f.xz
kernel image: https://storage.googleapis.com/syzbot-assets/edfae2c36891/bzImage-89edd36f.xz
mounted in repro: https://storage.googleapis.com/syzbot-assets/9eefce186dc7/mount_0.gz
  fsck result: OK (log: https://syzkaller.appspot.com/x/fsck.log?x=16024e92580000)

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+f82afc4d4e74d0ef7a89@syzkaller.appspotmail.com

(syz.0.17,5491,0):ocfs2_truncate_log_needs_flush:5830 ERROR: bug expression: le16_to_cpu(tl->tl_used) > le16_to_cpu(tl->tl_count)
(syz.0.17,5491,0):ocfs2_truncate_log_needs_flush:5830 ERROR: slot 0, invalid truncate log parameters: used = 129, count = 39
------------[ cut here ]------------
kernel BUG at fs/ocfs2/alloc.c:5830!
Oops: invalid opcode: 0000 [#1] SMP KASAN NOPTI
CPU: 0 UID: 0 PID: 5491 Comm: syz.0.17 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2~bpo12+1 04/01/2014
RIP: 0010:ocfs2_truncate_log_needs_flush fs/ocfs2/alloc.c:5827 [inline]
RIP: 0010:ocfs2_remove_btree_range+0x152f/0x1540 fs/ocfs2/alloc.c:5752
Code: b7 45 00 4c 89 e7 48 c7 c6 16 10 7e 8d ba c6 16 00 00 48 c7 c1 80 d4 aa 8b 41 89 d8 45 89 f9 50 e8 46 20 1e 00 48 83 c4 08 90 <0f> 0b 66 66 66 66 66 66 2e 0f 1f 84 00 00 00 00 00 90 90 90 90 90
RSP: 0018:ffffc90002b6ecc0 EFLAGS: 00010296
RAX: 1c4f3c72a1dda200 RBX: 0000000000000000 RCX: 1c4f3c72a1dda200
RDX: 0000000000000000 RSI: 0000000080000000 RDI: 0000000000000000
RBP: ffffc90002b6ef98 R08: ffff88801fe24293 R09: 1ffff11003fc4852
R10: dffffc0000000000 R11: ffffed1003fc4853 R12: ffffc90002b6ed80
R13: ffff88804c09fac0 R14: 1ffff11009813f58 R15: 0000000000000081
FS:  000055556b844500(0000) GS:ffff88808d72f000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000557f72160e20 CR3: 0000000059e03000 CR4: 0000000000352ef0
Call Trace:
 <TASK>
 ocfs2_commit_truncate+0xb64/0x21d0 fs/ocfs2/alloc.c:7372
 ocfs2_truncate_file+0xca2/0x1420 fs/ocfs2/file.c:509
 ocfs2_setattr+0x1520/0x1b40 fs/ocfs2/file.c:1212
 notify_change+0xc1a/0xf40 fs/attr.c:546
 do_truncate+0x1a4/0x220 fs/open.c:68
 handle_truncate fs/namei.c:3596 [inline]
 do_open fs/namei.c:3979 [inline]
 path_openat+0x306c/0x3830 fs/namei.c:4134
 do_filp_open+0x1fa/0x410 fs/namei.c:4161
 do_sys_openat2+0x121/0x1c0 fs/open.c:1437
 do_sys_open fs/open.c:1452 [inline]
 __do_sys_openat fs/open.c:1468 [inline]
 __se_sys_openat fs/open.c:1463 [inline]
 __x64_sys_openat+0x138/0x170 fs/open.c:1463
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0xfa/0xfa0 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7fe596b8f749
Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 a8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007ffe6dee1248 EFLAGS: 00000246 ORIG_RAX: 0000000000000101
RAX: ffffffffffffffda RBX: 00007fe596de5fa0 RCX: 00007fe596b8f749
RDX: 000000000000275a RSI: 0000200000000040 RDI: ffffffffffffff9c
RBP: 00007fe596c13f91 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007fe596de5fa0 R14: 00007fe596de5fa0 R15: 0000000000000004
 </TASK>
Modules linked in:
---[ end trace 0000000000000000 ]---
RIP: 0010:ocfs2_truncate_log_needs_flush fs/ocfs2/alloc.c:5827 [inline]
RIP: 0010:ocfs2_remove_btree_range+0x152f/0x1540 fs/ocfs2/alloc.c:5752
Code: b7 45 00 4c 89 e7 48 c7 c6 16 10 7e 8d ba c6 16 00 00 48 c7 c1 80 d4 aa 8b 41 89 d8 45 89 f9 50 e8 46 20 1e 00 48 83 c4 08 90 <0f> 0b 66 66 66 66 66 66 2e 0f 1f 84 00 00 00 00 00 90 90 90 90 90
RSP: 0018:ffffc90002b6ecc0 EFLAGS: 00010296
RAX: 1c4f3c72a1dda200 RBX: 0000000000000000 RCX: 1c4f3c72a1dda200
RDX: 0000000000000000 RSI: 0000000080000000 RDI: 0000000000000000
RBP: ffffc90002b6ef98 R08: ffff88801fe24293 R09: 1ffff11003fc4852
R10: dffffc0000000000 R11: ffffed1003fc4853 R12: ffffc90002b6ed80
R13: ffff88804c09fac0 R14: 1ffff11009813f58 R15: 0000000000000081
FS:  000055556b844500(0000) GS:ffff88808d72f000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000557f7216a138 CR3: 0000000059e03000 CR4: 0000000000352ef0


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
