Received: from mail-il1-f199.google.com (mail-il1-f199.google.com [209.85.166.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B63DD1A0BD1
	for <ocfs2-devel@lists.linux.dev>; Tue,  3 Sep 2024 10:29:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725359361; cv=none; b=OuxrNGTBfDqu3EbWjzkhc46cTi6HcjRjfxIu1zgseMZKcYAo94N02vKn5/ghHUKgpH4SURdiYA0wxn8+Piyebx0+rKKb2EX48m+Emgv69YZhe6x+QS8zFTYE9vCdlRVPrn2D5u+AU1Jtj5abjsJGMne68RLEI+6HayGyQy32ymo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725359361; c=relaxed/simple;
	bh=gT/LQY3fBKa033x1eX0blsHMmEV5xanZCc19O2q6ctc=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=YCWo2p3ZuVtFB7ZtZFpLNCIaFQHeNgYHwQI46OryuwcaAKWUnNS34XdNxmVKoOHTKZRDhy7bRNd/uStayvdRFBFRnYULtGbvoxD7cBhS4qe6qL1cTyVaabbPgbUTEODvYZvp1ySF8F6bmg66+dCzuHiGw1l70RVwojb7/PZuZpo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f199.google.com with SMTP id e9e14a558f8ab-39d17abca55so52560865ab.1
        for <ocfs2-devel@lists.linux.dev>; Tue, 03 Sep 2024 03:29:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725359359; x=1725964159;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=NRNSBzYEnJABwE8WtqjmxFldyu3O9FP/lLXmT6XD040=;
        b=DKxdjuvG73wfjNQNbgyYS6hfnnO9xTLuSvGepx4aNyN7vp70Amc0aD/+sUBkndyQVE
         3GTZb/OPRsGy9UDtybkNaubhoGEEyb/VrRCRDWR8JmpzgyUu3N2pE20+A/EuMN0xKTyN
         8JsEnArH2ZFX83BYw/3mqSRKXNJsEhdfqpr88IIAucFlttFU6oYbaGHxUr6r/1AySCXq
         5ObH88bSqkH7HA4CCmglcafyAE7BY4QyqWVQCAX9t7SnWSF68guofm3etAzrZh6b88bs
         +jFa1hkqDzsEiQBq/gOVGobQeVEuoO6dcE0ChayYtL18CR4g4SKMrJccpza64gNIJf+u
         MoRQ==
X-Forwarded-Encrypted: i=1; AJvYcCVcHpOBCuKUu73Me/SX0DZgmvW1ywVQ35ehwTFvCyofW9o5lOR0MIBNhMBneD7GxriAEFaVMi5fxD/A+w==@lists.linux.dev
X-Gm-Message-State: AOJu0Yzit6fQ9FELftyELiYQYaOSHtqS/YuFO+z8uK31JwjKjkNzon+t
	8yDIXxbom7iOtFFb8d8UjndZ2AJz7vHmKtG8SREdSif5UFp/4uwo9RkAFJnPp64RsjLKut4MrvM
	4CatlZHdwDNvjp+nV6aKw3Tn3gL4IZbvcv2qp5En+kWZh0sgrUgabkfA=
X-Google-Smtp-Source: AGHT+IFeZfDs8CAVVuo3iOfw+zRbjQNXVj5CQ4Ca9iK16vQ+xoGOS7zZQ9MCAXOwAakDR063imPgNTb5emeSjH7+JjQ2qRjtwEvr
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:198f:b0:396:dc3a:72f2 with SMTP id
 e9e14a558f8ab-39f410602bamr10312555ab.3.1725359358801; Tue, 03 Sep 2024
 03:29:18 -0700 (PDT)
Date: Tue, 03 Sep 2024 03:29:18 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000b10c48062134870d@google.com>
Subject: [syzbot] [ocfs2?] kernel BUG in _ocfs2_free_suballoc_bits
From: syzbot <syzbot+2d6d9df993967dde8297@syzkaller.appspotmail.com>
To: jlbec@evilplan.org, joseph.qi@linux.alibaba.com, 
	linux-kernel@vger.kernel.org, mark@fasheh.com, ocfs2-devel@lists.linux.dev, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    fb24560f31f9 Merge tag 'lsm-pr-20240830' of git://git.kern..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=15107925980000
kernel config:  https://syzkaller.appspot.com/x/.config?x=996585887acdadb3
dashboard link: https://syzkaller.appspot.com/bug?extid=2d6d9df993967dde8297
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/7bc7510fe41f/non_bootable_disk-fb24560f.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/2d39db26a2bc/vmlinux-fb24560f.xz
kernel image: https://storage.googleapis.com/syzbot-assets/8910481ae16e/bzImage-fb24560f.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+2d6d9df993967dde8297@syzkaller.appspotmail.com

loop0: detected capacity change from 0 to 32768
=======================================================
WARNING: The mand mount option has been deprecated and
         and is ignored by this kernel. Remove the mand
         option from the mount to silence this warning.
=======================================================
JBD2: Ignoring recovery information on journal
ocfs2: Mounting device (7,0) on (node local, slot 0) with ordered data mode.
------------[ cut here ]------------
kernel BUG at fs/ocfs2/suballoc.c:2542!
Oops: invalid opcode: 0000 [#1] PREEMPT SMP KASAN NOPTI
CPU: 0 UID: 0 PID: 5120 Comm: syz.0.0 Not tainted 6.11.0-rc5-syzkaller-00207-gfb24560f31f9 #0
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2~bpo12+1 04/01/2014
RIP: 0010:_ocfs2_free_suballoc_bits+0x11a2/0x14a0 fs/ocfs2/suballoc.c:2542
Code: 18 e9 8f fb ff ff 44 89 e1 80 e1 07 80 c1 03 38 c1 0f 8c 92 fb ff ff 4c 89 e7 e8 39 c7 6a fe e9 85 fb ff ff e8 7f 7b 03 fe 90 <0f> 0b e8 77 7b 03 fe 90 0f 0b f3 0f 1e fa 65 8b 1d 45 c6 73 7c bf
RSP: 0018:ffffc90002e5f840 EFLAGS: 00010287
RAX: ffffffff839010b1 RBX: 00000000ffffffff RCX: 0000000000040000
RDX: ffffc9000b849000 RSI: 000000000001fa9e RDI: 000000000001fa9f
RBP: ffffc90002e5f9e8 R08: ffffffff8390000c R09: 0000000000000001
R10: dffffc0000000000 R11: fffffbfff2030dbe R12: ffff88804098f0e8
R13: dffffc0000000000 R14: ffff888013113e00 R15: dffffc0000000000
FS:  00007f44d49666c0(0000) GS:ffff88801fe00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f44d4923f98 CR3: 000000000072c000 CR4: 0000000000350ef0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 _ocfs2_free_clusters+0x5ff/0xad0 fs/ocfs2/suballoc.c:2646
 ocfs2_replay_truncate_records fs/ocfs2/alloc.c:5971 [inline]
 __ocfs2_flush_truncate_log+0x760/0x1250 fs/ocfs2/alloc.c:6054
 ocfs2_flush_truncate_log+0x4f/0x70 fs/ocfs2/alloc.c:6076
 ocfs2_sync_fs+0x125/0x390 fs/ocfs2/super.c:402
 iterate_supers+0xc6/0x190 fs/super.c:934
 ksys_sync+0xdb/0x1c0 fs/sync.c:104
 __do_sys_sync+0xe/0x20 fs/sync.c:113
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f44d3b79eb9
Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 a8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f44d4966038 EFLAGS: 00000246 ORIG_RAX: 00000000000000a2
RAX: ffffffffffffffda RBX: 00007f44d3d15f80 RCX: 00007f44d3b79eb9
RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000000
RBP: 00007f44d3be793e R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 0000000000000000 R14: 00007f44d3d15f80 R15: 00007ffee36f9688
 </TASK>
Modules linked in:
---[ end trace 0000000000000000 ]---
RIP: 0010:_ocfs2_free_suballoc_bits+0x11a2/0x14a0 fs/ocfs2/suballoc.c:2542
Code: 18 e9 8f fb ff ff 44 89 e1 80 e1 07 80 c1 03 38 c1 0f 8c 92 fb ff ff 4c 89 e7 e8 39 c7 6a fe e9 85 fb ff ff e8 7f 7b 03 fe 90 <0f> 0b e8 77 7b 03 fe 90 0f 0b f3 0f 1e fa 65 8b 1d 45 c6 73 7c bf
RSP: 0018:ffffc90002e5f840 EFLAGS: 00010287
RAX: ffffffff839010b1 RBX: 00000000ffffffff RCX: 0000000000040000
RDX: ffffc9000b849000 RSI: 000000000001fa9e RDI: 000000000001fa9f
RBP: ffffc90002e5f9e8 R08: ffffffff8390000c R09: 0000000000000001
R10: dffffc0000000000 R11: fffffbfff2030dbe R12: ffff88804098f0e8
R13: dffffc0000000000 R14: ffff888013113e00 R15: dffffc0000000000
FS:  00007f44d49666c0(0000) GS:ffff88801fe00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f44d4923f98 CR3: 000000000072c000 CR4: 0000000000350ef0
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
