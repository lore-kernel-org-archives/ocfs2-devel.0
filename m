Received: from mail-il1-f205.google.com (mail-il1-f205.google.com [209.85.166.205])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4C41212F89
	for <ocfs2-devel@lists.linux.dev>; Mon,  7 Apr 2025 20:33:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.205
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744058003; cv=none; b=t0280ShnAnQ3YCUhc4Gb4Dgsli9cy1bYfHToaknntg0ZKhhBeWDBb2a5b+ecwEme3XCNi/AQEQBfynaD/iPe0IRA1Jo+bIlNArAfnLSbxt/bB9NcVaN4AEjn2Q+zbQA/aQiRS+Y4XisZ1swTrARmmgDDOYaUpRTmf1buAmQi6Rw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744058003; c=relaxed/simple;
	bh=z+1ety+BYZoWQNC1G2cnfOohyDPEeayeqwlYoH1bchA=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=WHWZoF6Qcd/LfymdwdYgg3SHEPRquWyKWrKO7Qc2Hl10HLYxk25OavAtC+9bmotTK/OvNFw5Nus33EuClP5hromkCRb+xwcVUKj1iW2ljX9sZ2qUPe9FJhK/jScBiMMuyC+HUFjBaRmeqAUy7MO91uFwi+D5fdRzIDAjJ47nl5Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.205
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f205.google.com with SMTP id e9e14a558f8ab-3d43621bb7eso60412685ab.1
        for <ocfs2-devel@lists.linux.dev>; Mon, 07 Apr 2025 13:33:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744058001; x=1744662801;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Hp3udhiTLZ9ONskS//1YT4JHpFRSDe2zobki5hjkXh0=;
        b=menrGEZDb5H8CthWArUoxn6TYlunW1zBeqQpy7CjH0aN4w1ZCdHobF6vg26GlOAEy2
         9N3fn2nULdHfx0eRqRIytxZGIHPrbAp1hQxWxuptq23lb5TjqlqZDtiOiRf7LeIRa148
         eiDHD6WAsQ/DfN74nUPNmrGfNR+1nMyRYEvaIbDv+4u19PNtveSa5LFstjS919yoa8ZI
         fzEx0AsDew80l8Ypsy8jj74wiZYLAeK53sloXBgS6a5CWuKgzRVhjI/QJgyMiDbxlIYB
         lMXJKY7bAo/VOh5g+Z2ZEzeoQaPTgqQe/jtWG3/wfJ9gz6KLZw6XGtWOzQ9qY8cx3WX9
         VccQ==
X-Forwarded-Encrypted: i=1; AJvYcCXQne61B2Q7JouRRT83PQPyhSDtQhdt7ZH6dHIJZxWm9Ij7MSLSFI+lSREUql/1++FP5QSJHEPJdsCJvg==@lists.linux.dev
X-Gm-Message-State: AOJu0Yxi5/aa9/zgaqT4/pwUMxG4Rz7/ao4JTLj9THWxdDiD+hYP5P9B
	QbR432JpbTGRLqDHufCWV8pcX8jfd4iht/AQcWhzUmtoCK0e8xWIKcX9eDtiWUjPi8lohqF2cse
	tAgPJ0U3oHRM9qYUCSs2T4IKO3WVbzgcuDmyJMvp6ZAWgWje/ISRLuKQ=
X-Google-Smtp-Source: AGHT+IHn47cfxJ7KxGKIc/QvGgxrGz6Wm/xKGS83PC06Bu6jewrogB5/NVupTpXes8r+EKHcdg8S1sQFvcRD3U4F9Ohgz9IBZ8i5
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:4404:10b0:3d3:d344:2a1a with SMTP id
 e9e14a558f8ab-3d7035ebdecmr8162225ab.0.1744058000816; Mon, 07 Apr 2025
 13:33:20 -0700 (PDT)
Date: Mon, 07 Apr 2025 13:33:20 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <67f43690.050a0220.107db6.05a3.GAE@google.com>
Subject: [syzbot] [ocfs2?] general protection fault in ocfs2_assure_trans_credits
From: syzbot <syzbot+8497452549365f8d1c37@syzkaller.appspotmail.com>
To: jlbec@evilplan.org, joseph.qi@linux.alibaba.com, 
	linux-kernel@vger.kernel.org, mark@fasheh.com, ocfs2-devel@lists.linux.dev, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    a2cc6ff5ec8f Merge tag 'firewire-updates-6.15' of git://gi..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=1011d404580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=6fe3b5e6a2cb1cc2
dashboard link: https://syzkaller.appspot.com/bug?extid=8497452549365f8d1c37
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=17b8c94c580000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=11e927cf980000

Downloadable assets:
disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/7feb34a89c2a/non_bootable_disk-a2cc6ff5.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/c58c1555aab7/vmlinux-a2cc6ff5.xz
kernel image: https://storage.googleapis.com/syzbot-assets/61fb9d013359/bzImage-a2cc6ff5.xz
mounted in repro: https://storage.googleapis.com/syzbot-assets/778ae9eeaba6/mount_3.gz
  fsck result: OK (log: https://syzkaller.appspot.com/x/fsck.log?x=1268194c580000)

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+8497452549365f8d1c37@syzkaller.appspotmail.com

(syz-executor410,5357,0):ocfs2_extend_trans:438 ERROR: status = -30
(syz-executor410,5357,0):ocfs2_try_to_merge_extent:3817 ERROR: status = -30
Oops: general protection fault, probably for non-canonical address 0xdffffc0000000000: 0000 [#1] SMP KASAN NOPTI
KASAN: null-ptr-deref in range [0x0000000000000000-0x0000000000000007]
CPU: 0 UID: 0 PID: 5357 Comm: syz-executor410 Not tainted 6.14.0-syzkaller-12966-ga2cc6ff5ec8f #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2~bpo12+1 04/01/2014
RIP: 0010:jbd2_handle_buffer_credits include/linux/jbd2.h:-1 [inline]
RIP: 0010:ocfs2_assure_trans_credits+0x80/0x3a0 fs/ocfs2/journal.c:457
Code: 89 e0 48 c1 e8 03 42 80 3c 28 00 74 08 4c 89 e7 e8 45 11 65 fe 49 8b 1c 24 eb 08 e8 ba ec fa fd 4c 89 e3 48 89 d8 48 c1 e8 03 <42> 80 3c 28 00 74 08 48 89 df e8 21 11 65 fe 48 8b 2b 49 8d 7c 24
RSP: 0018:ffffc9000d466e88 EFLAGS: 00010246
RAX: 0000000000000000 RBX: 0000000000000000 RCX: ffff888000ab8000
RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000000
RBP: ffff888047cd0b24 R08: ffffffff83c86a9b R09: ffffffff83bd1493
R10: 0000000000000006 R11: ffff888000ab8000 R12: ffff888047cd0b00
R13: dffffc0000000000 R14: 000000000000000a R15: ffff888040fb3b80
FS:  00007fe48a49b6c0(0000) GS:ffff88808c599000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007fe48a47ad58 CR3: 0000000035e16000 CR4: 0000000000352ef0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 ocfs2_dio_end_io_write fs/ocfs2/aops.c:2342 [inline]
 ocfs2_dio_end_io+0xc36/0x1330 fs/ocfs2/aops.c:2401
 dio_complete+0x250/0x720 fs/direct-io.c:281
 __blockdev_direct_IO+0x3baf/0x4540 fs/direct-io.c:1303
 ocfs2_direct_IO+0x255/0x2c0 fs/ocfs2/aops.c:2438
 generic_file_direct_write+0x1e8/0x400 mm/filemap.c:4036
 __generic_file_write_iter+0x126/0x230 mm/filemap.c:4205
 ocfs2_file_write_iter+0x190f/0x20d0 fs/ocfs2/file.c:2469
 do_iter_readv_writev+0x71f/0x9d0 fs/read_write.c:-1
 vfs_writev+0x38d/0xbc0 fs/read_write.c:1055
 do_pwritev fs/read_write.c:1151 [inline]
 __do_sys_pwritev2 fs/read_write.c:1209 [inline]
 __se_sys_pwritev2+0x1b8/0x2d0 fs/read_write.c:1200
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0xf3/0x230 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7fe48a508a99
Code: 28 00 00 00 75 05 48 83 c4 28 c3 e8 b1 18 00 00 90 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 b0 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007fe48a49b208 EFLAGS: 00000246 ORIG_RAX: 0000000000000148
RAX: ffffffffffffffda RBX: 00007fe48a595718 RCX: 00007fe48a508a99
RDX: 0000000000000001 RSI: 0000200000000240 RDI: 000000000000000a
RBP: 00007fe48a595710 R08: 0000000000000000 R09: 0000000000000003
R10: 0000000000007800 R11: 0000000000000246 R12: 00007fe48a56158c
R13: 0000200000000000 R14: 0000200000000180 R15: 0000200000000240
 </TASK>
Modules linked in:
---[ end trace 0000000000000000 ]---
RIP: 0010:jbd2_handle_buffer_credits include/linux/jbd2.h:-1 [inline]
RIP: 0010:ocfs2_assure_trans_credits+0x80/0x3a0 fs/ocfs2/journal.c:457
Code: 89 e0 48 c1 e8 03 42 80 3c 28 00 74 08 4c 89 e7 e8 45 11 65 fe 49 8b 1c 24 eb 08 e8 ba ec fa fd 4c 89 e3 48 89 d8 48 c1 e8 03 <42> 80 3c 28 00 74 08 48 89 df e8 21 11 65 fe 48 8b 2b 49 8d 7c 24
RSP: 0018:ffffc9000d466e88 EFLAGS: 00010246
RAX: 0000000000000000 RBX: 0000000000000000 RCX: ffff888000ab8000
RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000000
RBP: ffff888047cd0b24 R08: ffffffff83c86a9b R09: ffffffff83bd1493
R10: 0000000000000006 R11: ffff888000ab8000 R12: ffff888047cd0b00
R13: dffffc0000000000 R14: 000000000000000a R15: ffff888040fb3b80
FS:  00007fe48a49b6c0(0000) GS:ffff88808c599000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007fe48a544990 CR3: 0000000035e16000 CR4: 0000000000352ef0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
----------------
Code disassembly (best guess):
   0:	89 e0                	mov    %esp,%eax
   2:	48 c1 e8 03          	shr    $0x3,%rax
   6:	42 80 3c 28 00       	cmpb   $0x0,(%rax,%r13,1)
   b:	74 08                	je     0x15
   d:	4c 89 e7             	mov    %r12,%rdi
  10:	e8 45 11 65 fe       	call   0xfe65115a
  15:	49 8b 1c 24          	mov    (%r12),%rbx
  19:	eb 08                	jmp    0x23
  1b:	e8 ba ec fa fd       	call   0xfdfaecda
  20:	4c 89 e3             	mov    %r12,%rbx
  23:	48 89 d8             	mov    %rbx,%rax
  26:	48 c1 e8 03          	shr    $0x3,%rax
* 2a:	42 80 3c 28 00       	cmpb   $0x0,(%rax,%r13,1) <-- trapping instruction
  2f:	74 08                	je     0x39
  31:	48 89 df             	mov    %rbx,%rdi
  34:	e8 21 11 65 fe       	call   0xfe65115a
  39:	48 8b 2b             	mov    (%rbx),%rbp
  3c:	49                   	rex.WB
  3d:	8d                   	.byte 0x8d
  3e:	7c 24                	jl     0x64


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
