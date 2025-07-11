Received: from mail-io1-f78.google.com (mail-io1-f78.google.com [209.85.166.78])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B5E7158DAC
	for <ocfs2-devel@lists.linux.dev>; Fri, 11 Jul 2025 16:45:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.78
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752252336; cv=none; b=hzIGQ0dD+NpqXamk9Ayln8Xj+bXIXAunp8gojHeWQP3d/x5cHbNIztB55hx+xuqVojZRKffICyo1Tuhoy96Kn/MexNAITFJfMaOG+9sEgndld8PQfe9koS1ZKPmLjrQY8/QVwzyOGMcaP/h4ZUzGvsfO5aJEDkkvgv+Z4GTY/fo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752252336; c=relaxed/simple;
	bh=U8rtxlH0XaZDEaBMRNa2KGvLQ/MK49Be3B3sLYvwd5Q=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=V9UtBrc6rn3kc6025OhQFvBX1GT0hBgCee3xfsv8W2odVM5LEST/9GexXseU3CT09hDXPzjLJoWS339zf5v2oV8bj4Q2GDjsymNMTyq2wnSdKRKP5+tZCHkdPGsIpo0p7uJC90d2L9kw04CTvzpoDh6CFGdCG1OMIa16UgnTvgw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.78
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-io1-f78.google.com with SMTP id ca18e2360f4ac-875bd5522e9so215507539f.2
        for <ocfs2-devel@lists.linux.dev>; Fri, 11 Jul 2025 09:45:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752252333; x=1752857133;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=VABQq6clAbkWUdOYNzYc9iQd65dtpXS3iY2Z8Y1HDsU=;
        b=r7McWrk17ijvOfFB+Pg8QnF4cAoG+hYZBNhreXgdR0+p+j6bsP6Vxsd2UYtjUc2GsK
         W/d0LWyBJ07AJV0EnA1pFi9MJ3fb5bGcwjcDWhAP4PE79LKgR4vSdvv813xgQhEp4ID3
         v4zUpUnxyu8jWdb1qVPRY39jg2LFukky+/Kfkq6Aqv9bYJx+8jI6eLYy/MTlXQm3+gnm
         NKygyZznpfBuMMz9aYjgby1xR9BPH7r754eswS0g9y29v6COII4rMQDYO18oBdIyoIMO
         ZpjYTqZvrxhUpCe27KSOjTVziXgVa/0EG4LUSRT3no/hiP0U9dObwg3ilnz+M/Eiia3J
         /TCg==
X-Forwarded-Encrypted: i=1; AJvYcCVaGOzyuJEt4WhqIa2GH57wFDrdGs/eB6WF3n3HKrbO9QTLoZ4Ybqwkup6WaELl+cWA+mpscWaE+0gkJg==@lists.linux.dev
X-Gm-Message-State: AOJu0YxbhsfKVqu4HDc0LWa42dErnc3OLQP3ZowXtpUJn8SBGvgVKx9o
	/4agCKxXZIPNkPnsNQqqFC7thFiX6u+Em8EEx1iwbFEWMy+MWwNYfvEcMyQgmomO0naKn3pavBv
	u1HGW4ys+s0w5P7h6RS7LSqCBTQC2iV3fpG9y/NugfzEaUIEABO4vBq+xBSs=
X-Google-Smtp-Source: AGHT+IEwK4QlIslDs3x7cwpRkWnuKvamjsjEMwyTySNMtTCxZaSuKOm07E/6SIHV/FPLFPUFmpkd3YCu8qwGO0ZheCPftccMVIaf
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6602:4804:b0:873:1cc0:ae59 with SMTP id
 ca18e2360f4ac-879787fc64emr482396539f.5.1752252333610; Fri, 11 Jul 2025
 09:45:33 -0700 (PDT)
Date: Fri, 11 Jul 2025 09:45:33 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <68713fad.a00a0220.26a83e.0057.GAE@google.com>
Subject: [syzbot] [ocfs2?] kernel BUG in ocfs2_truncate_log_needs_flush (2)
From: syzbot <syzbot+c24237f0eee59c0c2abb@syzkaller.appspotmail.com>
To: jlbec@evilplan.org, joseph.qi@linux.alibaba.com, 
	linux-kernel@vger.kernel.org, mark@fasheh.com, ocfs2-devel@lists.linux.dev, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    8c2e52ebbe88 eventpoll: don't decrement ep refcount while ..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=177cea8c580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=b309c907eaab29da
dashboard link: https://syzkaller.appspot.com/bug?extid=c24237f0eee59c0c2abb
compiler:       Debian clang version 20.1.7 (++20250616065708+6146a88f6049-1~exp1~20250616065826.132), Debian LLD 20.1.7
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=12e99bd4580000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1702c0f0580000

Downloadable assets:
disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/d900f083ada3/non_bootable_disk-8c2e52eb.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/fd9c3cb36878/vmlinux-8c2e52eb.xz
kernel image: https://storage.googleapis.com/syzbot-assets/0f323b0a9d42/bzImage-8c2e52eb.xz
mounted in repro: https://storage.googleapis.com/syzbot-assets/d0ab42c91b28/mount_0.gz
  fsck result: OK (log: https://syzkaller.appspot.com/x/fsck.log?x=14e99bd4580000)

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+c24237f0eee59c0c2abb@syzkaller.appspotmail.com

(syz.0.16,5478,0):ocfs2_truncate_log_needs_flush:5830 ERROR: bug expression: le16_to_cpu(tl->tl_used) > le16_to_cpu(tl->tl_count)
(syz.0.16,5478,0):ocfs2_truncate_log_needs_flush:5830 ERROR: slot 0, invalid truncate log parameters: used = 128, count = 39
------------[ cut here ]------------
kernel BUG at fs/ocfs2/alloc.c:5830!
Oops: invalid opcode: 0000 [#1] SMP KASAN NOPTI
CPU: 0 UID: 0 PID: 5478 Comm: syz.0.16 Not tainted 6.16.0-rc5-syzkaller-00053-g8c2e52ebbe88 #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2~bpo12+1 04/01/2014
RIP: 0010:ocfs2_truncate_log_needs_flush+0x2d8/0x2e0 fs/ocfs2/alloc.c:5827
Code: 0f b7 00 4c 89 e7 48 c7 c6 35 c0 a6 8d ba c6 16 00 00 48 c7 c1 c0 23 ca 8b 45 89 e8 45 89 f9 50 e8 5d 11 1e 00 48 83 c4 08 90 <0f> 0b 66 0f 1f 44 00 00 90 90 90 90 90 90 90 90 90 90 90 90 90 90
RSP: 0018:ffffc90002c7f540 EFLAGS: 00010292
RAX: c11493c73e537600 RBX: ffff888031704174 RCX: c11493c73e537600
RDX: 0000000000000000 RSI: 0000000080000000 RDI: 0000000000000000
RBP: ffffc90002c7f610 R08: ffffc90002c7f107 R09: 1ffff9200058fe20
R10: dffffc0000000000 R11: fffff5200058fe21 R12: ffffc90002c7f5a0
R13: 0000000000000000 R14: 1ffff11007d6bf58 R15: 0000000000000080
FS:  000055557c057500(0000) GS:ffff88808d21b000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000200000001400 CR3: 000000004f209000 CR4: 0000000000352ef0
Call Trace:
 <TASK>
 ocfs2_xattr_set+0xaea/0x11f0 fs/ocfs2/xattr.c:3624
 __vfs_setxattr+0x439/0x480 fs/xattr.c:200
 __vfs_setxattr_noperm+0x12d/0x660 fs/xattr.c:234
 vfs_setxattr+0x16b/0x2f0 fs/xattr.c:321
 do_setxattr fs/xattr.c:636 [inline]
 filename_setxattr+0x274/0x600 fs/xattr.c:665
 path_setxattrat+0x364/0x3a0 fs/xattr.c:713
 __do_sys_setxattr fs/xattr.c:747 [inline]
 __se_sys_setxattr fs/xattr.c:743 [inline]
 __x64_sys_setxattr+0xbc/0xe0 fs/xattr.c:743
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0xfa/0x3b0 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f0edcd8e929
Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 a8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007ffd28be2a78 EFLAGS: 00000246 ORIG_RAX: 00000000000000bc
RAX: ffffffffffffffda RBX: 00007f0edcfb5fa0 RCX: 00007f0edcd8e929
RDX: 0000200000001400 RSI: 0000200000000240 RDI: 00002000000001c0
RBP: 00007f0edce10b39 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000841 R11: 0000000000000246 R12: 0000000000000000
R13: 00007f0edcfb5fa0 R14: 00007f0edcfb5fa0 R15: 0000000000000005
 </TASK>
Modules linked in:
---[ end trace 0000000000000000 ]---
RIP: 0010:ocfs2_truncate_log_needs_flush+0x2d8/0x2e0 fs/ocfs2/alloc.c:5827
Code: 0f b7 00 4c 89 e7 48 c7 c6 35 c0 a6 8d ba c6 16 00 00 48 c7 c1 c0 23 ca 8b 45 89 e8 45 89 f9 50 e8 5d 11 1e 00 48 83 c4 08 90 <0f> 0b 66 0f 1f 44 00 00 90 90 90 90 90 90 90 90 90 90 90 90 90 90
RSP: 0018:ffffc90002c7f540 EFLAGS: 00010292
RAX: c11493c73e537600 RBX: ffff888031704174 RCX: c11493c73e537600
RDX: 0000000000000000 RSI: 0000000080000000 RDI: 0000000000000000
RBP: ffffc90002c7f610 R08: ffffc90002c7f107 R09: 1ffff9200058fe20
R10: dffffc0000000000 R11: fffff5200058fe21 R12: ffffc90002c7f5a0
R13: 0000000000000000 R14: 1ffff11007d6bf58 R15: 0000000000000080
FS:  000055557c057500(0000) GS:ffff88808d21b000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000200000001400 CR3: 000000004f209000 CR4: 0000000000352ef0


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
