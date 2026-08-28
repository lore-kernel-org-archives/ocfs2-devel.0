Received: from mail-oi2-f8.google.com (mail-oi2-f8.google.com [74.125.231.200])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 998152D7BF
	for <ocfs2-devel@lists.linux.dev>; Fri, 28 Aug 2026 02:12:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.231.200
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787883153; cv=none; b=EkmnMVvA4RWNpzo2G2xIXONu/O//MUOblgvUujuoAv4VK5AMlAD4/Shn92XMyIOA0PEJkL89PTt1IJm+YyqKx40uPsAemwao10RW+CTDq38pP+KA7d0G34nNIITi+8E7tFv/X5WE8Tw1z3gVoGl9TATUM/ao/yCgoNrxAxSPSb4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787883153; c=relaxed/simple;
	bh=1hj/OJUPVgN/qtjAcfKjFM4OTZS4RU71LNIa3Vsl+FE=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=eWBdrvx6ELeMDeYJJRLON2MTyQ9q5ou9TPfRDtKxQRqToJs3GKvDwYfHI79Rv5evjaaG5SQioR4Xi05CQgMVSwab0WGDJEVPvcBTcRpoczCXYCug5YfU2oehtgyle+Xb3x0lpkwgJYJf8Pr8a7bGzazmCXDsGDO7hiyANLlFcuo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=74.125.231.200
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oi2-f8.google.com with SMTP id 46e09a7af769-7f0355eb4b3so190329a34.0
        for <ocfs2-devel@lists.linux.dev>; Thu, 27 Aug 2026 19:12:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787883150; x=1788487950;
        h=content-type:to:from:subject:message-id:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=j631KfuXT7Q6Z7MHV3kuKtSJxOKHdXGjbHFa8rcKGNM=;
        b=KV6xaUWAP05vOMGbQdiR98bffwj8+KR5xQD3tNWKjFTMZX/dtmavvIyLH43aUPO+OF
         qGbVpDjczdes5LpFkitxfF+JxKZZh/K1jF36I0+sQXE+5LnFYA/iAfYJVnmH/m5Wg0We
         7KS+5V2ghCDY5Ap2nC6h0hr7kEiHrvvcL8AvUVDDwT/95LLk6cAYnWiQ67ygdkzdZU3H
         If+e8Kojfq+WZkjolAWxh0OVnzFAKNm5PvfX8cvhpvFRydu50FhYHm1m/M5bg3+Phcip
         TReNYbkUvnY9moC8av02e55DvQMq/U+6tmAotFCg8j6nfwJl2HyuEkOFFI/mfc+TQc+r
         kSPw==
X-Forwarded-Encrypted: i=1; AHgh+RoaIj1Tro9OFhw8ooWsyW9K006Y6w5iAt8kxiZaefgGKZ/ukk4mk5V3l/jfaL/cq3nwk7okcqS6Emr9fQ==@lists.linux.dev
X-Gm-Message-State: AFuF++k+w/Ds3V5fBmPGtj+cTyiqS9WSXt/Lp6+0vOVxcU+W5asNBN1C
	QfoR/7szKCDNGtK6haN7kSOQ1bXRyYIRmhadHDqooE7Hx/ja9MlRcQdeMUylafc6b+g1DSFHhbc
	HWrwMKzZBFGRKpuo+NS63hyiQt/xQxbRSoxg8lC2I60UgeH3tuGwQLcBgYNE=
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6820:26a:b0:6ae:c68b:3a7 with SMTP id
 006d021491bc7-6b1c6753623mr2478306eaf.16.1787883150511; Thu, 27 Aug 2026
 19:12:30 -0700 (PDT)
Date: Thu, 27 Aug 2026 19:12:30 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6a90ee8e.1d9ded08.62e62.00e1.GAE@google.com>
Subject: [syzbot] [ocfs2?] kernel BUG in ocfs2_write_begin_nolock (3)
From: syzbot <syzbot+fd44623201beb5f3b462@syzkaller.appspotmail.com>
To: jlbec@evilplan.org, joseph.qi@linux.alibaba.com, 
	linux-kernel@vger.kernel.org, mark@fasheh.com, ocfs2-devel@lists.linux.dev, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    4352b8aee980 Merge tag 'i3c/for-7.3' of git://git.kernel.o..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=14fc3549580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=335632b21d0ce540
dashboard link: https://syzkaller.appspot.com/bug?extid=fd44623201beb5f3b462
compiler:       Debian clang version 22.1.8 (++20260613092233+e80beda6e255-1~exp1~20260613092250.77), Debian LLD 22.1.8

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/8491c9d0d35e/disk-4352b8ae.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/51cc3aee80d1/vmlinux-4352b8ae.xz
kernel image: https://storage.googleapis.com/syzbot-assets/e0bcbebdbede/bzImage-4352b8ae.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+fd44623201beb5f3b462@syzkaller.appspotmail.com

------------[ cut here ]------------
kernel BUG at fs/ocfs2/aops.c:1391!
Oops: invalid opcode: 0000 [#1] SMP KASAN NOPTI
CPU: 0 UID: 0 PID: 7883 Comm: syz.6.469 Tainted: G             L      syzkaller #0 PREEMPT(full) 
Tainted: [L]=SOFTLOCKUP
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 07/16/2026
RIP: 0010:ocfs2_populate_write_desc fs/ocfs2/aops.c:1391 [inline]
RIP: 0010:ocfs2_write_begin_nolock+0x41b2/0x41f0 fs/ocfs2/aops.c:1689
Code: 84 3a e3 fd 49 bf 00 00 00 00 00 fc ff df 4c 8b 24 24 e9 62 fe ff ff e8 7c 50 fc 07 e8 67 3a e3 fd 90 0f 0b e8 5f 3a e3 fd 90 <0f> 0b e8 57 3a e3 fd 90 0f 0b e8 4f 3a e3 fd 90 0f 0b e8 47 3a e3
RSP: 0018:ffffc900060df2e0 EFLAGS: 00010293
RAX: ffffffff83e3f321 RBX: ffff88802a26c010 RCX: ffff88802ec5be80
RDX: 0000000000000000 RSI: 0000000000000002 RDI: 0000000000000000
RBP: ffffc900060df880 R08: ffff88802ec5be80 R09: 0000000000000006
R10: 00000000fffffffc R11: 0000000000000000 R12: ffff88802a26c000
R13: 1ffff110041ec81f R14: 0000000000000003 R15: 0000000000000000
FS:  0000555591908500(0000) GS:ffff888124cf3000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007fc5117ed158 CR3: 000000005a889000 CR4: 0000000000350ef0
Call Trace:
 <TASK>
 __ocfs2_page_mkwrite fs/ocfs2/mmap.c:92 [inline]
 ocfs2_page_mkwrite+0x640/0xb60 fs/ocfs2/mmap.c:143
 do_page_mkwrite+0x147/0x310 mm/memory.c:3754
 wp_page_shared mm/memory.c:4155 [inline]
 do_wp_page+0x1a9c/0x4b80 mm/memory.c:4378
 handle_pte_fault mm/memory.c:6520 [inline]
 __handle_mm_fault mm/memory.c:6645 [inline]
 handle_mm_fault+0x1576/0x3720 mm/memory.c:6814
 do_user_addr_fault+0x746/0x1340 arch/x86/mm/fault.c:1394
 handle_page_fault arch/x86/mm/fault.c:1483 [inline]
 exc_page_fault+0x6a/0xc0 arch/x86/mm/fault.c:1536
 asm_exc_page_fault+0x26/0x30 arch/x86/include/asm/idtentry.h:595
RIP: 0033:0x7f5f73c67682
Code: 30 48 8b 14 24 48 85 d2 74 17 8b 44 24 10 0f c8 89 c0 48 89 44 24 10 48 83 fa 01 0f 85 aa 02 00 00 48 8b 44 24 18 8b 74 24 10 <89> 30 e9 1e fe ff ff 48 8b 44 24 18 8b 10 48 8b 04 24 48 85 c0 0f
RSP: 002b:00007ffd7d7d31a0 EFLAGS: 00010246
RAX: 0000200000000180 RBX: 0000000000000004 RCX: 0000000000000000
RDX: 0000000000000000 RSI: 0000000000000000 RDI: 00005555919083d8
RBP: 00007ffd7d7d32c0 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000000 R12: 00007ffd7d7d3300
R13: 00007f5f7402609c R14: 000000000002ae89 R15: 00007ffd7d7d32e0
 </TASK>
Modules linked in:
---[ end trace 0000000000000000 ]---
RIP: 0010:ocfs2_populate_write_desc fs/ocfs2/aops.c:1391 [inline]
RIP: 0010:ocfs2_write_begin_nolock+0x41b2/0x41f0 fs/ocfs2/aops.c:1689
Code: 84 3a e3 fd 49 bf 00 00 00 00 00 fc ff df 4c 8b 24 24 e9 62 fe ff ff e8 7c 50 fc 07 e8 67 3a e3 fd 90 0f 0b e8 5f 3a e3 fd 90 <0f> 0b e8 57 3a e3 fd 90 0f 0b e8 4f 3a e3 fd 90 0f 0b e8 47 3a e3
RSP: 0018:ffffc900060df2e0 EFLAGS: 00010293
RAX: ffffffff83e3f321 RBX: ffff88802a26c010 RCX: ffff88802ec5be80
RDX: 0000000000000000 RSI: 0000000000000002 RDI: 0000000000000000
RBP: ffffc900060df880 R08: ffff88802ec5be80 R09: 0000000000000006
R10: 00000000fffffffc R11: 0000000000000000 R12: ffff88802a26c000
R13: 1ffff110041ec81f R14: 0000000000000003 R15: 0000000000000000
FS:  0000555591908500(0000) GS:ffff888124cf3000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007ffc50359f6c CR3: 000000005a889000 CR4: 0000000000350ef0


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
