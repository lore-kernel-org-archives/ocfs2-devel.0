Received: from mail-il1-f199.google.com (mail-il1-f199.google.com [209.85.166.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 154361DB53A
	for <ocfs2-devel@lists.linux.dev>; Mon, 28 Oct 2024 16:23:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730132607; cv=none; b=ipaqb1IF92Pxz4iVHLSh4/t8y+KOq5EaUZRBfuqruqgwwlu+mLbCgF5nM34WkfOb372xFv304FPgFOsoxBFB6B3J7j0P7joGCZfAWo18cFxJSbjXoL6dKcIyjYrfGPfhgGVXjor4ZwyVzcuBrwg6H0fZG/+CGJL48ju+nlKJBdE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730132607; c=relaxed/simple;
	bh=KWWSUgavmZeYBvzGGdcQ4JK+soB8sssdz3uvY5BTVTU=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=bZzA42sFf7kCKcp88lpwnYj4Lr52ZzAc4Kv9+Vc6kVfvAkFvihNstAHOevAWYdjB28q2Y6z3GLJB/2Ivvw6PR/fKfhP6SCOIxHZUned6f9xlJnYpHu1+gUkBFmvbZY/JPke2ruPrfFDsFGlsVB4YxYgP/KgOZxn+cB4/2VzxC7s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f199.google.com with SMTP id e9e14a558f8ab-3a4f113d2c8so19438035ab.1
        for <ocfs2-devel@lists.linux.dev>; Mon, 28 Oct 2024 09:23:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730132604; x=1730737404;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=kG9B6e846ZPDBlAb5BPpyJk5ZSk3i1+AlWQpqphc6Sw=;
        b=iHh/IsYttf1UUz3V1rInr160pkbfbsEzTp5pUF/jCP8OnZxZyEImFIMj7MWYLZig+N
         Soyh6KFbPbTAb/phBLHtH7zGfnKaPv3Kjt40kwGVjlEIvxflu/6JgRKp2AshDG2sZ4rW
         zeBim4uLhTJVotJXA0UYwcY9ig+MSfsuq0CdctxnBMa4Ej3Jzazbz75bzPH4MyPLkXar
         YvuAeRTOaYJwEwZyu7XZDIpvkO52a3bkd3crmchF6FqCgQLmeju6spppHCYofPlm+qry
         IjeI0tuNa8Joo9PoAg0YPT8yWc2PBPHxbDmxm1HRCovHOQRQ+O5LluyHbLUXwKKXrLjh
         38EA==
X-Forwarded-Encrypted: i=1; AJvYcCWxZiVq8mf1oYawtwYXFOJNxwEbsmjpzaWB+1lUNSwQEDc8JyECnyKCCnZCVMc0aVXbQM8bqUn+aLLJ6g==@lists.linux.dev
X-Gm-Message-State: AOJu0YxwPvlPTRvgG71Ti9f3Nq8+XwE+5lNZZPEwcRezA9zwDClETTMe
	9NMsrbdC18AL7Ei8P21hCHzS64Nl9FKsSGtOBoelpYaUj/yPBhg7nDT2QWZQZtpTCAo52QpE6Or
	KR9RPkFikg5QRif57T9JtkPOj8don1bGvpXJUbZFmh3H8aXIMs2sbXwo=
X-Google-Smtp-Source: AGHT+IHFx2SQFhyYV9myLsFoNcIZAbjaRkp/I8ZSavR75n+lVFW/tQ29LYTriL6xamM2YBNbrdY4UAQQmKJnIs8gwPNm89IVs8qm
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:2183:b0:3a3:4391:24e9 with SMTP id
 e9e14a558f8ab-3a4ed2dfafdmr82600365ab.20.1730132604186; Mon, 28 Oct 2024
 09:23:24 -0700 (PDT)
Date: Mon, 28 Oct 2024 09:23:24 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <671fba7c.050a0220.21b2f.0006.GAE@google.com>
Subject: [syzbot] [ocfs2?] kernel BUG in ocfs2_group_extend
From: syzbot <syzbot+ce0c7bd35d4b7c7300cd@syzkaller.appspotmail.com>
To: jlbec@evilplan.org, joseph.qi@linux.alibaba.com, 
	linux-kernel@vger.kernel.org, mark@fasheh.com, ocfs2-devel@lists.linux.dev, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    c2ee9f594da8 KVM: selftests: Fix build on on non-x86 archi..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=17baf640580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=fc6f8ce8c5369043
dashboard link: https://syzkaller.appspot.com/bug?extid=ce0c7bd35d4b7c7300cd
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/7feb34a89c2a/non_bootable_disk-c2ee9f59.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/8a3541902b13/vmlinux-c2ee9f59.xz
kernel image: https://storage.googleapis.com/syzbot-assets/a00efacc2604/bzImage-c2ee9f59.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+ce0c7bd35d4b7c7300cd@syzkaller.appspotmail.com

loop0: detected capacity change from 32768 to 32767
------------[ cut here ]------------
kernel BUG at fs/ocfs2/resize.c:308!
Oops: invalid opcode: 0000 [#1] PREEMPT SMP KASAN NOPTI
CPU: 0 UID: 0 PID: 5104 Comm: syz.0.0 Not tainted 6.12.0-rc4-syzkaller-00047-gc2ee9f594da8 #0
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2~bpo12+1 04/01/2014
RIP: 0010:ocfs2_group_extend+0xb28/0xb30 fs/ocfs2/resize.c:308
Code: ff ff 44 89 f9 80 e1 07 fe c1 38 c1 0f 8c 30 f9 ff ff 4c 89 ff e8 68 c8 69 fe e9 23 f9 ff ff e8 4e 92 31 08 e8 49 03 00 fe 90 <0f> 0b 66 0f 1f 44 00 00 90 90 90 90 90 90 90 90 90 90 90 90 90 90
RSP: 0018:ffffc9000b2a7b20 EFLAGS: 00010283
RAX: ffffffff8394d497 RBX: 00000000ffffffff RCX: 0000000000040000
RDX: ffffc9000ba49000 RSI: 000000000000055d RDI: 000000000000055e
RBP: ffffc9000b2a7cf0 R08: ffffffff8394cc23 R09: 1ffffffff2039fdd
R10: dffffc0000000000 R11: fffffbfff2039fde R12: ffff888041644fb8
R13: dffffc0000000000 R14: 1ffff92001654f74 R15: ffff88804c4d6e00
FS:  00007fd5c99936c0(0000) GS:ffff88801fc00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000562c6b6f9b08 CR3: 000000003a86c000 CR4: 0000000000352ef0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 ocfs2_ioctl+0x771/0x7d0 fs/ocfs2/ioctl.c:873
 vfs_ioctl fs/ioctl.c:51 [inline]
 __do_sys_ioctl fs/ioctl.c:907 [inline]
 __se_sys_ioctl+0xf9/0x170 fs/ioctl.c:893
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7fd5c8b7dff9
Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 a8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007fd5c9993038 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
RAX: ffffffffffffffda RBX: 00007fd5c8d36058 RCX: 00007fd5c8b7dff9
RDX: 0000000020000100 RSI: 0000000040046f01 RDI: 0000000000000004
RBP: 00007fd5c8bf0296 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 0000000000000000 R14: 00007fd5c8d36058 R15: 00007ffd7b458dc8
 </TASK>
Modules linked in:
---[ end trace 0000000000000000 ]---
RIP: 0010:ocfs2_group_extend+0xb28/0xb30 fs/ocfs2/resize.c:308
Code: ff ff 44 89 f9 80 e1 07 fe c1 38 c1 0f 8c 30 f9 ff ff 4c 89 ff e8 68 c8 69 fe e9 23 f9 ff ff e8 4e 92 31 08 e8 49 03 00 fe 90 <0f> 0b 66 0f 1f 44 00 00 90 90 90 90 90 90 90 90 90 90 90 90 90 90
RSP: 0018:ffffc9000b2a7b20 EFLAGS: 00010283
RAX: ffffffff8394d497 RBX: 00000000ffffffff RCX: 0000000000040000
RDX: ffffc9000ba49000 RSI: 000000000000055d RDI: 000000000000055e
RBP: ffffc9000b2a7cf0 R08: ffffffff8394cc23 R09: 1ffffffff2039fdd
R10: dffffc0000000000 R11: fffffbfff2039fde R12: ffff888041644fb8
R13: dffffc0000000000 R14: 1ffff92001654f74 R15: ffff88804c4d6e00
FS:  00007fd5c99936c0(0000) GS:ffff88801fc00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007fd5c9971f98 CR3: 000000003a86c000 CR4: 0000000000352ef0
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
