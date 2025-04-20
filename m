Received: from mail-io1-f80.google.com (mail-io1-f80.google.com [209.85.166.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5943419307F
	for <ocfs2-devel@lists.linux.dev>; Sun, 20 Apr 2025 10:25:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745144728; cv=none; b=mgZAkVpbYRCs7bfSKej9zYtjcuK4+9ygQEQu56p91JW6DHnuG0uIQ82yNNWOnEd0y5sKuQb7MZ/ZAxT3jgHo6IAABOXYOUh+Mx/TAkh6F97taZkaAEZvjh3W5MhLMSgJ5fUBlRF8InVqNXN7LvcdBaDjKkZIKvgybdDWJR0P36E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745144728; c=relaxed/simple;
	bh=+f2+g4d3ZHgLZ0mmGUmnqU2BDI7TLnAfFFnVb0wYgFI=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:
	 Content-Type; b=E0kEMStAVdgshczXuLT97ypWYg4Y//7NR4wSG3wZxYppqoIxIt4WrqGIsiQs1MqaPQq8a/jbIxlegRRvJovT9CviexYEltVOzPfzJZ9yOLb4FMFTYox/v9zKcn5b6++Guj/5sD+fJgeAPhTF9Jb8e5pa6ak84CCknuhzG8NFojA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-io1-f80.google.com with SMTP id ca18e2360f4ac-862dda418a6so323566239f.0
        for <ocfs2-devel@lists.linux.dev>; Sun, 20 Apr 2025 03:25:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745144725; x=1745749525;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=8PlNwjKy925BoHyaIbLcXmXGo5M94WH+BOT+uMig3fU=;
        b=n/phMQTcwSqoX5bKt94gxG0XF+QpvmWJI523syLRLSKuziDMXoGqw1pyISMcyvckkK
         o189HcvwMh9isaa14Mg83+dXcsiheKw+PDZphLaltkelMKvqGj3tEOSuV/Ge5KHCdlu5
         JC9rIzroHcnpR3+c/EIa6C4i/y9eGIYOqlqXMUFWVMvMBcMXxg6zpiUoHKfrsXebTaJu
         L+hTS1udRM50hMTARwHmSZXjbfuBvnC8v1zpjo2l3s1okEzwsj6ldor1cp3rHG/9X/4X
         LcnFzjyEZuCJwBfkhrqGZs27SMg1hMSvFPvLNH93tr2aZz3jm8ASpMzUklIEA6OKj5T1
         HBpA==
X-Forwarded-Encrypted: i=1; AJvYcCV4CuFpWCc8285KNktmT/MnGQMGu1jQ3ZA7XcNSS00ZF2D41c2Y0XMR/WX0g2tMGBFAxK+uY6Y9j7MGzw==@lists.linux.dev
X-Gm-Message-State: AOJu0YyJ/i8V3GghIUaw/EjqPA6GQLxGq1OQVUZG8bSo0wAwa9S8y9P4
	QXQXtbpjfT+H3havrjETfsdZJZ7QOwXwHLCopmRzl0wrKXhdjD6IwgQORWhbuNK7RELFGkjEqHV
	mhXxqfcBqhclDEzCKuVwYZzHUGoWxW1Se2ZvHrNeAKQEoBvnmMXxM1Sw=
X-Google-Smtp-Source: AGHT+IFvg5QiqnuA3hE8MN9wictd/sMo/3ub1E8bH1KIgEpC8pTUq5BGtrGUYId8BJSZHhLscMukK1iArWkobQZ7TGSpZY+dDu+b
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:4511:b0:3d8:1e6c:523 with SMTP id
 e9e14a558f8ab-3d89428c912mr73216775ab.22.1745144725510; Sun, 20 Apr 2025
 03:25:25 -0700 (PDT)
Date: Sun, 20 Apr 2025 03:25:25 -0700
In-Reply-To: <6780316f.050a0220.25a300.01cd.GAE@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6804cb95.050a0220.243d89.0030.GAE@google.com>
Subject: Re: [syzbot] [ocfs2?] kernel BUG in ocfs2_page_mkwrite (2)
From: syzbot <syzbot+ecfa701c0b41415f36d4@syzkaller.appspotmail.com>
To: jlbec@evilplan.org, joseph.qi@linux.alibaba.com, 
	linux-kernel@vger.kernel.org, mark@fasheh.com, ocfs2-devel@lists.linux.dev, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

syzbot has found a reproducer for the following issue on:

HEAD commit:    119009db2674 Merge tag 'vfs-6.15-rc3.fixes.2' of git://git..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=15eb7bac580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=68d9f79fc685cd4
dashboard link: https://syzkaller.appspot.com/bug?extid=ecfa701c0b41415f36d4
compiler:       Debian clang version 15.0.6, Debian LLD 15.0.6
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=13bd463f980000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=136374cc580000

Downloadable assets:
disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/7feb34a89c2a/non_bootable_disk-119009db.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/1ab6d3b3b5de/vmlinux-119009db.xz
kernel image: https://storage.googleapis.com/syzbot-assets/648d06f0fb1a/bzImage-119009db.xz
mounted in repro #1: https://storage.googleapis.com/syzbot-assets/c4ac14e1235a/mount_0.gz
  fsck result: OK (log: https://syzkaller.appspot.com/x/fsck.log?x=115f6ccc580000)
mounted in repro #2: https://storage.googleapis.com/syzbot-assets/2b07efcbe0ca/mount_4.gz
  fsck result: failed (log: https://syzkaller.appspot.com/x/fsck.log?x=13523fe4580000)

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+ecfa701c0b41415f36d4@syzkaller.appspotmail.com

(syz-executor297,5383,0):ocfs2_write_end_nolock:1942 ERROR: status = -30
(syz-executor297,5383,0):ocfs2_commit_trans:382 ERROR: status = -5
------------[ cut here ]------------
kernel BUG at fs/ocfs2/mmap.c:107!
Oops: invalid opcode: 0000 [#1] SMP KASAN NOPTI
CPU: 0 UID: 0 PID: 5383 Comm: syz-executor297 Not tainted 6.15.0-rc2-syzkaller-00471-g119009db2674 #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2~bpo12+1 04/01/2014
RIP: 0010:__ocfs2_page_mkwrite fs/ocfs2/mmap.c:107 [inline]
RIP: 0010:ocfs2_page_mkwrite+0xda1/0xdb0 fs/ocfs2/mmap.c:144
Code: ff df 4d 89 fc e9 85 f3 ff ff 48 ff cb e8 c7 2e f9 fd 49 89 dc 49 be 00 00 00 00 00 fc ff df e9 6b f3 ff ff e8 b0 2e f9 fd 90 <0f> 0b cc cc cc cc cc cc cc cc cc cc cc cc cc 90 90 90 90 90 90 90
RSP: 0018:ffffc9000d3b6e00 EFLAGS: 00010293
RAX: ffffffff83c98e70 RBX: 00000000ffffffe2 RCX: ffff8880006c4880
RDX: 0000000000000000 RSI: 0000000000001000 RDI: 00000000ffffffe2
RBP: ffffc9000d3b6fc0 R08: ffffffff83c98c62 R09: 1ffffffff20bfc8e
R10: dffffc0000000000 R11: fffffbfff20bfc8f R12: 0000000000001000
R13: 0000000000008000 R14: ffffea000125c000 R15: 0000000000000000
FS:  0000555580515380(0000) GS:ffff88808c59a000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000200000008000 CR3: 000000004417a000 CR4: 0000000000352ef0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 do_page_mkwrite+0x159/0x340 mm/memory.c:3287
 do_shared_fault mm/memory.c:5594 [inline]
 do_fault mm/memory.c:5656 [inline]
 do_pte_missing mm/memory.c:4160 [inline]
 handle_pte_fault+0x10c6/0x61c0 mm/memory.c:5997
 __handle_mm_fault mm/memory.c:6140 [inline]
 handle_mm_fault+0x1129/0x1bf0 mm/memory.c:6309
 do_user_addr_fault arch/x86/mm/fault.c:1388 [inline]
 handle_page_fault arch/x86/mm/fault.c:1480 [inline]
 exc_page_fault+0x2bb/0x920 arch/x86/mm/fault.c:1538
 asm_exc_page_fault+0x26/0x30 arch/x86/include/asm/idtentry.h:623
RIP: 0010:rep_movs_alternative+0x4a/0x90 arch/x86/lib/copy_user_64.S:74
Code: cc cc cc 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 00 48 8b 06 48 89 07 48 83 c6 08 48 83 c7 08 83 e9 08 74 db 83 f9 08 73 e8 eb c5 <f3> a4 c3 cc cc cc cc 48 8b 06 48 89 07 48 8d 47 08 48 83 e0 f8 48
RSP: 0018:ffffc9000d3b76d8 EFLAGS: 00050206
RAX: ffffffff85018101 RBX: 0000200000007400 RCX: 0000000000000400
RDX: 0000000000000000 RSI: ffff888048e7fc00 RDI: 0000200000008000
RBP: ffffc9000d3b7858 R08: ffff888048e7ffff R09: 1ffff110091cffff
R10: dffffc0000000000 R11: ffffed10091d0000 R12: 1ffff92001a76fb3
R13: ffffc9000d3b7d98 R14: 0000000000001000 R15: ffff888048e7f000
 copy_user_generic arch/x86/include/asm/uaccess_64.h:126 [inline]
 raw_copy_to_user arch/x86/include/asm/uaccess_64.h:147 [inline]
 copy_to_user_iter lib/iov_iter.c:25 [inline]
 iterate_ubuf include/linux/iov_iter.h:30 [inline]
 iterate_and_advance2 include/linux/iov_iter.h:300 [inline]
 iterate_and_advance include/linux/iov_iter.h:328 [inline]
 _copy_to_iter+0x268/0x1c90 lib/iov_iter.c:185
 copy_page_to_iter+0xb1/0x160 lib/iov_iter.c:362
 copy_folio_to_iter include/linux/uio.h:198 [inline]
 filemap_read+0x88f/0x1260 mm/filemap.c:2753
 ocfs2_file_read_iter+0x42d/0xb80 fs/ocfs2/file.c:2589
 new_sync_read fs/read_write.c:489 [inline]
 vfs_read+0x9a0/0xb90 fs/read_write.c:570
 ksys_read+0x19d/0x2d0 fs/read_write.c:713
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0xf3/0x210 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f554499e529
Code: 28 00 00 00 75 05 48 83 c4 28 c3 e8 21 18 00 00 90 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 b8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007fff47d84cf8 EFLAGS: 00000246 ORIG_RAX: 0000000000000000
RAX: ffffffffffffffda RBX: 0000200000000300 RCX: 00007f554499e529
RDX: 000000000000fdef RSI: 0000200000000400 RDI: 0000000000000004
RBP: 0000000000000000 R08: 00007fff47d84d30 R09: 00007fff47d84d30
R10: 0023706f6f6c2f76 R11: 0000000000000246 R12: 00007fff47d84d1c
R13: 0000000000000018 R14: 431bde82d7b634db R15: 00007fff47d84d50
 </TASK>
Modules linked in:
---[ end trace 0000000000000000 ]---
RIP: 0010:__ocfs2_page_mkwrite fs/ocfs2/mmap.c:107 [inline]
RIP: 0010:ocfs2_page_mkwrite+0xda1/0xdb0 fs/ocfs2/mmap.c:144
Code: ff df 4d 89 fc e9 85 f3 ff ff 48 ff cb e8 c7 2e f9 fd 49 89 dc 49 be 00 00 00 00 00 fc ff df e9 6b f3 ff ff e8 b0 2e f9 fd 90 <0f> 0b cc cc cc cc cc cc cc cc cc cc cc cc cc 90 90 90 90 90 90 90
RSP: 0018:ffffc9000d3b6e00 EFLAGS: 00010293
RAX: ffffffff83c98e70 RBX: 00000000ffffffe2 RCX: ffff8880006c4880
RDX: 0000000000000000 RSI: 0000000000001000 RDI: 00000000ffffffe2
RBP: ffffc9000d3b6fc0 R08: ffffffff83c98c62 R09: 1ffffffff20bfc8e
R10: dffffc0000000000 R11: fffffbfff20bfc8f R12: 0000000000001000
R13: 0000000000008000 R14: ffffea000125c000 R15: 0000000000000000
FS:  0000555580515380(0000) GS:ffff88808c59a000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000200000008000 CR3: 000000004417a000 CR4: 0000000000352ef0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
----------------
Code disassembly (best guess):
   0:	cc                   	int3
   1:	cc                   	int3
   2:	cc                   	int3
   3:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
   a:	00 00 00
   d:	0f 1f 00             	nopl   (%rax)
  10:	48 8b 06             	mov    (%rsi),%rax
  13:	48 89 07             	mov    %rax,(%rdi)
  16:	48 83 c6 08          	add    $0x8,%rsi
  1a:	48 83 c7 08          	add    $0x8,%rdi
  1e:	83 e9 08             	sub    $0x8,%ecx
  21:	74 db                	je     0xfffffffe
  23:	83 f9 08             	cmp    $0x8,%ecx
  26:	73 e8                	jae    0x10
  28:	eb c5                	jmp    0xffffffef
* 2a:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi) <-- trapping instruction
  2c:	c3                   	ret
  2d:	cc                   	int3
  2e:	cc                   	int3
  2f:	cc                   	int3
  30:	cc                   	int3
  31:	48 8b 06             	mov    (%rsi),%rax
  34:	48 89 07             	mov    %rax,(%rdi)
  37:	48 8d 47 08          	lea    0x8(%rdi),%rax
  3b:	48 83 e0 f8          	and    $0xfffffffffffffff8,%rax
  3f:	48                   	rex.W


---
If you want syzbot to run the reproducer, reply with:
#syz test: git://repo/address.git branch-or-commit-hash
If you attach or paste a git patch, syzbot will apply it before testing.
