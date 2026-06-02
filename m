Received: from mail-oa1-f77.google.com (mail-oa1-f77.google.com [209.85.160.77])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 782D8364E81
	for <ocfs2-devel@lists.linux.dev>; Tue,  2 Jun 2026 16:22:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.77
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780417350; cv=none; b=uEYGaHKNVt8GqfzCw9LgFzLBCQYLC9FsDb2JyN8Gpma96NCQk7Iu7LLUMaryOZpc/eTYHEmW+1W142nOqb3Yq2vkWiUYBXvzD8T/9nHarsJZ6Ba/AlZI7aCK+kQRQMrzFBZXrfrfM0b/GwHKoOGfZaboYf6AO2BFKcxNHIyJOrA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780417350; c=relaxed/simple;
	bh=xoduBMW0/n1pTJFKTKGR353VPfeLH4b45K6FPvhDBw8=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=OF+zQ+0FIfb8tqUlfBJGJCtBvrW3P13O544tqzbygg0LL+DQ1XARBL/kn9QseWkc59daGFVBdDJYSLxeI57EF2MA5Mwk1/LtYjAp9bRDu+gdsbBncOmClCIsgMOqDsplgQK9jiMKAuEiGN3R85FK7+JB5dJYNTHKNxETJf2uGfc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.160.77
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oa1-f77.google.com with SMTP id 586e51a60fabf-43ccdfac598so4385502fac.1
        for <ocfs2-devel@lists.linux.dev>; Tue, 02 Jun 2026 09:22:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780417347; x=1781022147;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=DRaHAoTRMG3LM3ghtp91tt6+4AN5BoFGpeAZZZZOjnw=;
        b=RJSvnZtfzcqUE3oysyYebp6TwAcBWlYH3ZkDGnCtzdUu1X/amA4XxePqln85nhq2eP
         kco1Uo859xVTLCziZMmdZln/HPOxBKims6m826sRZUdPgk0VOXolKV6ROywBtkUHhnIj
         DNVZC2yCZZ+fWzRAs3WvhQlWbePFlISzxeRgFBukfCEyffc1n7j2QJPpCAN4mOUiv4nF
         nC4Upmom+SpsGyaabGV7MPoSkFX/vRCEh00FxwhOrzZGZCgYCPQESdk0OekNLYtrgFf/
         Ov3MZU+t/oOl40J9qOQL2Ktt32yegOEJuQOUXJTGylAxpYqlmUGDi5GwiN3oEt7HWYF6
         jtrw==
X-Forwarded-Encrypted: i=1; AFNElJ9cDxhmHFIvMeH5h9J6v0EA8iqmgTyCk6dle52fY9/0JYFwOGlTsUCcunX9NsoJU+r5fxmEvdaExIpibw==@lists.linux.dev
X-Gm-Message-State: AOJu0YzLpLs0XC5vb7/cx03X466dWbrohQic9ysEKzcJtXctq/AV9J7J
	YpjHEvrcrmnJwOtDGMpgzT/E3cT+FOUkk7iS0aGxMw1X8gmeJAOmyGzVR2eMcgXhRfRl3f3x0Sa
	M5ZXXT6E5lsgRUXHyPNPkPBhLsuj9YjS4+lGlHQ1f+uoypo3LTqSy3RR8yDE=
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6820:134a:b0:69d:ef3c:7e34 with SMTP id
 006d021491bc7-69e4678fc46mr268821eaf.0.1780417347476; Tue, 02 Jun 2026
 09:22:27 -0700 (PDT)
Date: Tue, 02 Jun 2026 09:22:27 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6a1f0343.c1435f33.112120.04c5.GAE@google.com>
Subject: [syzbot] [ocfs2?] general protection fault in ocfs2_assure_trans_credits
 (2)
From: syzbot <syzbot+e9c15ff790cea6a0cfae@syzkaller.appspotmail.com>
To: jlbec@evilplan.org, joseph.qi@linux.alibaba.com, 
	linux-kernel@vger.kernel.org, mark@fasheh.com, ocfs2-devel@lists.linux.dev, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    6f3ed7fec72f Merge tag 'for-7.1/dm-fixes-3' of git://git.k..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=10fbe441580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=b4166e8ea5fbf7e3
dashboard link: https://syzkaller.appspot.com/bug?extid=e9c15ff790cea6a0cfae
compiler:       Debian clang version 21.1.8 (++20251221033036+2078da43e25a-1~exp1~20251221153213.50), Debian LLD 21.1.8

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/d900f083ada3/non_bootable_disk-6f3ed7fe.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/3810c8d15f8e/vmlinux-6f3ed7fe.xz
kernel image: https://storage.googleapis.com/syzbot-assets/e1a03916d507/bzImage-6f3ed7fe.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+e9c15ff790cea6a0cfae@syzkaller.appspotmail.com

(syz.0.0,5328,0):ocfs2_extend_trans:457 ERROR: status = -30
(syz.0.0,5328,0):ocfs2_try_to_merge_extent:3826 ERROR: status = -30
Oops: general protection fault, probably for non-canonical address 0xdffffc0000000000: 0000 [#1] SMP KASAN NOPTI
KASAN: null-ptr-deref in range [0x0000000000000000-0x0000000000000007]
CPU: 0 UID: 0 PID: 5328 Comm: syz.0.0 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
RIP: 0010:jbd2_handle_buffer_credits include/linux/jbd2.h:-1 [inline]
RIP: 0010:ocfs2_assure_trans_credits+0x7d/0x370 fs/ocfs2/journal.c:476
Code: 4c 89 f0 48 c1 e8 03 42 80 3c 28 00 74 08 4c 89 f7 e8 67 a9 6b fe 4d 8b 3e eb 08 e8 5d c5 fe fd 4d 89 f7 4c 89 f8 48 c1 e8 03 <42> 80 3c 28 00 74 08 4c 89 ff e8 44 a9 6b fe 4d 8b 3f 49 8d 7e 10
RSP: 0018:ffffc9000df36c88 EFLAGS: 00010246
RAX: 0000000000000000 RBX: 000000000000000a RCX: 0000000000100000
RDX: ffffc90020001000 RSI: 000000000001bbb3 RDI: 000000000001bbb4
RBP: 0000000000000000 R08: ffff88801f8bca80 R09: 0000000000000006
R10: 00000000fffffffc R11: 0000000000000002 R12: 0000000000000001
R13: dffffc0000000000 R14: ffff88805584b9a0 R15: 0000000000000000
FS:  00007f40eb90b6c0(0000) GS:ffff88808c891000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007fc50904de9c CR3: 000000001faf7000 CR4: 0000000000352ef0
Call Trace:
 <TASK>
 ocfs2_dio_end_io_write fs/ocfs2/aops.c:2334 [inline]
 ocfs2_dio_end_io+0x7d2/0x1370 fs/ocfs2/aops.c:2418
 dio_complete+0x25b/0x790 fs/direct-io.c:281
 __blockdev_direct_IO+0x2e5d/0x34e0 fs/direct-io.c:1303
 ocfs2_direct_IO+0x251/0x2c0 fs/ocfs2/aops.c:2455
 generic_file_direct_write+0x1db/0x3e0 mm/filemap.c:4259
 __generic_file_write_iter+0x11d/0x230 mm/filemap.c:4428
 ocfs2_file_write_iter+0x1663/0x1e70 fs/ocfs2/file.c:2476
 iter_file_splice_write+0x9a1/0x10f0 fs/splice.c:736
 do_splice_from fs/splice.c:936 [inline]
 direct_splice_actor+0x101/0x160 fs/splice.c:1159
 splice_direct_to_actor+0x53a/0xc70 fs/splice.c:1103
 do_splice_direct_actor fs/splice.c:1202 [inline]
 do_splice_direct+0x195/0x290 fs/splice.c:1228
 do_sendfile+0x535/0x7d0 fs/read_write.c:1372
 __do_sys_sendfile64 fs/read_write.c:1433 [inline]
 __se_sys_sendfile64+0x144/0x1a0 fs/read_write.c:1419
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0x174/0x580 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f40ea99ce59
Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f40eb90afe8 EFLAGS: 00000246 ORIG_RAX: 0000000000000028
RAX: ffffffffffffffda RBX: 00007f40eac16090 RCX: 00007f40ea99ce59
RDX: 0000000000000000 RSI: 000000000000000a RDI: 0000000000000009
RBP: 00007f40eaa32d6f R08: 0000000000000000 R09: 0000000000000000
R10: 0000000020fffe82 R11: 0000000000000246 R12: 0000000000000000
R13: 00007f40eac16128 R14: 00007f40eac16090 R15: 00007fffd1b83c38
 </TASK>
Modules linked in:
---[ end trace 0000000000000000 ]---
RIP: 0010:jbd2_handle_buffer_credits include/linux/jbd2.h:-1 [inline]
RIP: 0010:ocfs2_assure_trans_credits+0x7d/0x370 fs/ocfs2/journal.c:476
Code: 4c 89 f0 48 c1 e8 03 42 80 3c 28 00 74 08 4c 89 f7 e8 67 a9 6b fe 4d 8b 3e eb 08 e8 5d c5 fe fd 4d 89 f7 4c 89 f8 48 c1 e8 03 <42> 80 3c 28 00 74 08 4c 89 ff e8 44 a9 6b fe 4d 8b 3f 49 8d 7e 10
RSP: 0018:ffffc9000df36c88 EFLAGS: 00010246
RAX: 0000000000000000 RBX: 000000000000000a RCX: 0000000000100000
RDX: ffffc90020001000 RSI: 000000000001bbb3 RDI: 000000000001bbb4
RBP: 0000000000000000 R08: ffff88801f8bca80 R09: 0000000000000006
R10: 00000000fffffffc R11: 0000000000000002 R12: 0000000000000001
R13: dffffc0000000000 R14: ffff88805584b9a0 R15: 0000000000000000
FS:  00007f40eb90b6c0(0000) GS:ffff88808c891000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007fd362a6f000 CR3: 000000001faf7000 CR4: 0000000000352ef0
----------------
Code disassembly (best guess):
   0:	4c 89 f0             	mov    %r14,%rax
   3:	48 c1 e8 03          	shr    $0x3,%rax
   7:	42 80 3c 28 00       	cmpb   $0x0,(%rax,%r13,1)
   c:	74 08                	je     0x16
   e:	4c 89 f7             	mov    %r14,%rdi
  11:	e8 67 a9 6b fe       	call   0xfe6ba97d
  16:	4d 8b 3e             	mov    (%r14),%r15
  19:	eb 08                	jmp    0x23
  1b:	e8 5d c5 fe fd       	call   0xfdfec57d
  20:	4d 89 f7             	mov    %r14,%r15
  23:	4c 89 f8             	mov    %r15,%rax
  26:	48 c1 e8 03          	shr    $0x3,%rax
* 2a:	42 80 3c 28 00       	cmpb   $0x0,(%rax,%r13,1) <-- trapping instruction
  2f:	74 08                	je     0x39
  31:	4c 89 ff             	mov    %r15,%rdi
  34:	e8 44 a9 6b fe       	call   0xfe6ba97d
  39:	4d 8b 3f             	mov    (%r15),%r15
  3c:	49 8d 7e 10          	lea    0x10(%r14),%rdi


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
