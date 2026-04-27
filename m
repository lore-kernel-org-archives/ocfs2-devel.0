Received: from mail-oo1-f80.google.com (mail-oo1-f80.google.com [209.85.161.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B8C23AEF2A
	for <ocfs2-devel@lists.linux.dev>; Mon, 27 Apr 2026 09:02:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777280557; cv=none; b=LSUOPDY/wSF1jnr6xBthSkv36ANJRIqcHJjlId7qw28W0veRaexe4c3wCqqtI7WfVbBZ62WjkvFgiPd/q0MD1KJY1Wr4PH6LMGBoM0Eqd4Hp9q44tdKZleODTawNxIxhrrqiHm9Ud0r6ajRiK1ao/HmD8UY/0V4zku9SfcfFxZg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777280557; c=relaxed/simple;
	bh=9NRtnhDZW8sJfTw3PlYPDpps3rncC/mTovxKDRNC2qE=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=WqXkbcCEfSJ0hWHF4HKL7emhxgX6gK/HOfwix2r19dhSXciljBU3UBAPafnBxeql9Hp+bGl2uRuV7BRlEByAnY88PzkvODdSfQMoOF3ex6ZhzvFGlRUPlJc0SaMomZNLMz0Py2ukqtv14pQIPpUlTttIaAkFbuk4sxz02KXYuUU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.161.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oo1-f80.google.com with SMTP id 006d021491bc7-69634bfdfebso2430824eaf.0
        for <ocfs2-devel@lists.linux.dev>; Mon, 27 Apr 2026 02:02:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777280555; x=1777885355;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=hsOM1laSWB56O77T3tBRyWe9C3mTU2Mp54Uk7h9ygKc=;
        b=BNOFcUxC8lzESzuKRVeRmc2A2jLoB2u2CaK7jdh5QemmzYuHemS3p3WTXkXYPUeUv/
         bvTWnux07YJ1ok7YHgQkLh93fujBvmV2N1iHcZnSThRESHIBwMbR+l8Cy3PPjCHNzJGY
         I9L2gfDOYundiZzgHwAbNcZKj7ftNCjV4imkXoMiOP1Tm0lMQ7SigD8XItU1SGmvPxsy
         7E8j3EZrBgGYuDygHe2UgxZRPGtePqrg4ZHxvovfpDcM283rS5UBis1iH8lRFvSji04z
         5j799e3Cl596RR7iPvH9WxI8PrQM/oXmVb55fFmj98N809RhosklidWDbQRP9c+Fw+B+
         f6eQ==
X-Forwarded-Encrypted: i=1; AFNElJ+cC7P/9F6xtQVYGHEq2SrbMIJVTniHhh5CzDwW3mqCPrGvHxvPph0i5zdEhLQsgs6cCaahfwwvwJQ60Q==@lists.linux.dev
X-Gm-Message-State: AOJu0YyMoTMqnjvsd8/3Hr96SomZuL1otraHd0b5+C++Uw16Iw6U3Fou
	lDz19kpFs0td2jbAgm/SCg33anfEsFUd9GrOf7VfzaGk2qGxRc7YHbC/5L46A+RsRRk5x//4k34
	vtC4yZTFX5yH7o8dSBrHeMWmh1wobXuYRPiTVlPmRqtmpphuasbmSe3F6XRg=
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6820:55cf:b0:696:2b58:4ac0 with SMTP id
 006d021491bc7-6962b58521emr3397976eaf.35.1777280555043; Mon, 27 Apr 2026
 02:02:35 -0700 (PDT)
Date: Mon, 27 Apr 2026 02:02:35 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <69ef262b.170a0220.11de9.0019.GAE@google.com>
Subject: [syzbot] [ocfs2?] kernel BUG in ocfs2_truncate_file (2)
From: syzbot <syzbot+83b3e2bb16ee8eaf0e68@syzkaller.appspotmail.com>
To: jlbec@evilplan.org, joseph.qi@linux.alibaba.com, 
	linux-kernel@vger.kernel.org, mark@fasheh.com, ocfs2-devel@lists.linux.dev, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    2e6803928193 Merge tag 'tracefs-v7.1-2' of git://git.kerne..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=152aecce580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=893fe4d237c86ed2
dashboard link: https://syzkaller.appspot.com/bug?extid=83b3e2bb16ee8eaf0e68
compiler:       Debian clang version 21.1.8 (++20251221033036+2078da43e25a-1~exp1~20251221153213.50), Debian LLD 21.1.8

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/d900f083ada3/non_bootable_disk-2e680392.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/c172e9d12fe6/vmlinux-2e680392.xz
kernel image: https://storage.googleapis.com/syzbot-assets/27e7e7afc115/bzImage-2e680392.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+83b3e2bb16ee8eaf0e68@syzkaller.appspotmail.com

Buffer I/O error on dev loop0, logical block 19904, async page read
Buffer I/O error on dev loop0, logical block 19905, async page read
Buffer I/O error on dev loop0, logical block 19906, async page read
Buffer I/O error on dev loop0, logical block 19907, async page read
Buffer I/O error on dev loop0, logical block 19908, async page read
Buffer I/O error on dev loop0, logical block 19909, async page read
Buffer I/O error on dev loop0, logical block 19910, async page read
Buffer I/O error on dev loop0, logical block 19911, async page read
(syz.0.0,5344,0):ocfs2_truncate_file:461 ERROR: bug expression: le64_to_cpu(fe->i_size) != i_size_read(inode)
(syz.0.0,5344,0):ocfs2_truncate_file:461 ERROR: Inode 17058, inode i_size = 1048576 != di i_size = 983040, i_flags = 0x2001
------------[ cut here ]------------
kernel BUG at fs/ocfs2/file.c:461!
Oops: invalid opcode: 0000 [#1] SMP KASAN NOPTI
CPU: 0 UID: 0 PID: 5344 Comm: syz.0.0 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
RIP: 0010:ocfs2_truncate_file+0x1313/0x14e0 fs/ocfs2/file.c:455
Code: d8 12 8c 49 89 d8 4d 89 f9 50 41 54 e8 c6 cb 17 00 48 83 c4 10 48 b8 00 00 00 00 00 fc ff df 48 8b 4c 24 20 c6 44 01 18 f8 90 <0f> 0b 89 d9 80 e1 07 80 c1 03 38 c1 0f 8c 5c f8 ff ff 48 89 df e8
RSP: 0018:ffffc9000df872e0 EFLAGS: 00010282
RAX: dffffc0000000000 RBX: 00000000000042a2 RCX: 1ffff92001bf0e6c
RDX: ffffc90020011000 RSI: 0000000000018631 RDI: 0000000000018632
RBP: ffffc9000df87510 R08: ffff88801fc247d3 R09: 1ffff11003f848fa
R10: dffffc0000000000 R11: ffffed1003f848fb R12: 00000000000f0000
R13: ffff8880004c842c R14: ffffc9000df87420 R15: 0000000000100000
FS:  00007fc100fc96c0(0000) GS:ffff88808c809000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007fc10040d6b8 CR3: 0000000041e52000 CR4: 0000000000352ef0
Call Trace:
 <TASK>
 ocfs2_setattr+0x15e5/0x1ca0 fs/ocfs2/file.c:1219
 notify_change+0xc1a/0xf40 fs/attr.c:556
 do_truncate+0x1c2/0x250 fs/open.c:68
 handle_truncate fs/namei.c:4307 [inline]
 do_open fs/namei.c:4703 [inline]
 path_openat+0x2f89/0x3860 fs/namei.c:4858
 do_file_open+0x23e/0x4a0 fs/namei.c:4887
 do_sys_openat2+0x113/0x200 fs/open.c:1364
 do_sys_open fs/open.c:1370 [inline]
 __do_sys_open fs/open.c:1378 [inline]
 __se_sys_open fs/open.c:1374 [inline]
 __x64_sys_open+0x11e/0x150 fs/open.c:1374
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0x15f/0xf80 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7fc10019c819
Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007fc100fc8fe8 EFLAGS: 00000246 ORIG_RAX: 0000000000000002
RAX: ffffffffffffffda RBX: 00007fc100416090 RCX: 00007fc10019c819
RDX: 0000000000000111 RSI: 000000000014937e RDI: 0000200000000180
RBP: 00007fc100232c91 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007fc100416128 R14: 00007fc100416090 R15: 00007fff135c7a78
 </TASK>
Modules linked in:
---[ end trace 0000000000000000 ]---
RIP: 0010:ocfs2_truncate_file+0x1313/0x14e0 fs/ocfs2/file.c:455
Code: d8 12 8c 49 89 d8 4d 89 f9 50 41 54 e8 c6 cb 17 00 48 83 c4 10 48 b8 00 00 00 00 00 fc ff df 48 8b 4c 24 20 c6 44 01 18 f8 90 <0f> 0b 89 d9 80 e1 07 80 c1 03 38 c1 0f 8c 5c f8 ff ff 48 89 df e8
RSP: 0018:ffffc9000df872e0 EFLAGS: 00010282
RAX: dffffc0000000000 RBX: 00000000000042a2 RCX: 1ffff92001bf0e6c
RDX: ffffc90020011000 RSI: 0000000000018631 RDI: 0000000000018632
RBP: ffffc9000df87510 R08: ffff88801fc247d3 R09: 1ffff11003f848fa
R10: dffffc0000000000 R11: ffffed1003f848fb R12: 00000000000f0000
R13: ffff8880004c842c R14: ffffc9000df87420 R15: 0000000000100000
FS:  00007fc100fc96c0(0000) GS:ffff88808c809000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f11c872aa30 CR3: 0000000041e52000 CR4: 0000000000352ef0


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
