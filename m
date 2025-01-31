Received: from mail-il1-f208.google.com (mail-il1-f208.google.com [209.85.166.208])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E43A6165EFC
	for <ocfs2-devel@lists.linux.dev>; Fri, 31 Jan 2025 20:55:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.208
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738356920; cv=none; b=Csa2zjstm9jT9OTc6ZM/8lxa2zEce7/R7gltFJZZtB/gAhDfrFYeuHJXhyQWTj07okoDyCH/JQ8NR/wmwgiTkg7Qe+RCr2YQ1ezE0GjVFmzMK3B9C3gxepi9Ny3xfJUwKxUrEAGXGWXs/78ybH9L8iI35ZR/wFN3tSEHl5STE00=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738356920; c=relaxed/simple;
	bh=Yv5gmhbsXPbLXOWvZRPDkMa4ffP0MNtv1qSAV1/CbHw=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=oPXVWdY9TSTrmSfMa2udgcB/qD5vGaJBZ7JuR59QliidRe2lVU1qbUfYFnVHH+7ZSr26xh4sSRajPHM9WkIUVfVg+NHqIOyb/iKVBU3/JQiEE2MQl5962fOnheQ73n2zndWtLzGKP48MpJV0uKPXyuOqS7mpyk04Y/dfEzOpimc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.208
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f208.google.com with SMTP id e9e14a558f8ab-3cf6c83560fso15974675ab.2
        for <ocfs2-devel@lists.linux.dev>; Fri, 31 Jan 2025 12:55:18 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738356918; x=1738961718;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=yzsgNdgIYd9HcrjFHxY90O435o+c5Mzw+Ck+s9qz+Lk=;
        b=L0HT1Nb7gsRfjlgj1rAoaB/C4ZnUhersAOO9DZif34DOfUlEr57mNkpsaLOIM760Ng
         3o6CWt2w8cSjb04TKJYo7vYgSM6N+bgyagonQ5tMra1ciCSdMmbGewkN3G7t1PQ0VteB
         1XsJKHsgQSKoc3hQRT7he2ppGfwQzg2GIj3Wi6fVIrxiqzfrtX6A4/NuEKDpsptHXfQI
         q6In4qdsPo3tzMU9ov2xxkHngKKASYD4FQnxt573g/mNI4NLzQT3aV04DibkjN3w3ZdR
         fLGXdMdcOG9Z9YmEb6+H+Hj4j+s01FqF62ZGOfZbKl2arSTsiJA9p330Ft9pBCknddoI
         LI3A==
X-Forwarded-Encrypted: i=1; AJvYcCW8WlI6AzKLcNdw7Ahnzi9osfp0qt8aKXrbn6u1wtoQqZe7GyeCe314oew1jE+aWkt8SDsinct4RHfQwQ==@lists.linux.dev
X-Gm-Message-State: AOJu0Yz/q3irVRnmmAxTfrDOxl2X7+WJmKH0w5YDfLfKBUivbS2r2jqt
	PMsLjjOKZT2UoEMd5l8u0UFtY3N1oYiFs3qluXgcd9ih5xYypgwJl7dfF3eBtRjF5nC3H+W/ZKy
	8pWcRvqI6McJR4ZauuRyweHJcFTEpBQeiMLiQNsiHQS/NatIdZ5FvhCQ=
X-Google-Smtp-Source: AGHT+IE7Oda+EIafkSrsWkrxHNl1hLhXlZNpdflSBASYTbkoHFGaeIoJLJJSgjAALtV2jJAP05e8dqMwvoR0aJDKFB/jgS91OY2M
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1a4c:b0:3cf:cd3c:bdfd with SMTP id
 e9e14a558f8ab-3cffe4478e9mr121503305ab.12.1738356918019; Fri, 31 Jan 2025
 12:55:18 -0800 (PST)
Date: Fri, 31 Jan 2025 12:55:18 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <679d38b6.050a0220.d7c5a.0053.GAE@google.com>
Subject: [syzbot] [ocfs2?] BUG: unable to handle kernel paging request in folio_unlock
From: syzbot <syzbot+2d57a8e099fe62bd60f0@syzkaller.appspotmail.com>
To: jlbec@evilplan.org, joseph.qi@linux.alibaba.com, 
	linux-kernel@vger.kernel.org, mark@fasheh.com, ocfs2-devel@lists.linux.dev, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    b4b0881156fb Merge tag 'docs-6.14-2' of git://git.lwn.net/..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=10139ddf980000
kernel config:  https://syzkaller.appspot.com/x/.config?x=d033b14aeef39158
dashboard link: https://syzkaller.appspot.com/bug?extid=2d57a8e099fe62bd60f0
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/7feb34a89c2a/non_bootable_disk-b4b08811.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/3efac40869da/vmlinux-b4b08811.xz
kernel image: https://storage.googleapis.com/syzbot-assets/9e9697356805/bzImage-b4b08811.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+2d57a8e099fe62bd60f0@syzkaller.appspotmail.com

loop0: detected capacity change from 0 to 32768
=======================================================
WARNING: The mand mount option has been deprecated and
         and is ignored by this kernel. Remove the mand
         option from the mount to silence this warning.
=======================================================
ocfs2: Mounting device (7,0) on (node local, slot 0) with writeback data mode.
FAULT_INJECTION: forcing a failure.
name fail_page_alloc, interval 1, probability 0, space 0, times 1
CPU: 0 UID: 0 PID: 5324 Comm: syz.0.0 Not tainted 6.13.0-syzkaller-09585-gb4b0881156fb #0
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2~bpo12+1 04/01/2014
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:94 [inline]
 dump_stack_lvl+0x241/0x360 lib/dump_stack.c:120
 fail_dump lib/fault-inject.c:73 [inline]
 should_fail_ex+0x40a/0x550 lib/fault-inject.c:174
 prepare_alloc_pages+0x1da/0x5b0 mm/page_alloc.c:4514
 __alloc_frozen_pages_noprof+0x16f/0x710 mm/page_alloc.c:4728
 alloc_pages_mpol+0x311/0x660 mm/mempolicy.c:2270
 alloc_frozen_pages_noprof mm/mempolicy.c:2341 [inline]
 alloc_pages_noprof+0x121/0x190 mm/mempolicy.c:2361
 folio_alloc_noprof+0x1e/0x30 mm/mempolicy.c:2371
 filemap_alloc_folio_noprof+0xe1/0x540 mm/filemap.c:1019
 __filemap_get_folio+0x438/0xae0 mm/filemap.c:1970
 ocfs2_grab_folios_for_write+0x562/0xda0 fs/ocfs2/aops.c:1075
 ocfs2_write_begin_nolock+0x3476/0x4e40 fs/ocfs2/aops.c:1783
 ocfs2_write_begin+0x205/0x3a0 fs/ocfs2/aops.c:1889
 generic_perform_write+0x346/0x990 mm/filemap.c:4189
 __generic_file_write_iter+0x1b5/0x230 mm/filemap.c:4287
 ocfs2_file_write_iter+0x19af/0x2180 fs/ocfs2/file.c:2469
 aio_write+0x56b/0x7c0 fs/aio.c:1633
 io_submit_one+0x8a7/0x18a0 fs/aio.c:2052
 __do_sys_io_submit fs/aio.c:2111 [inline]
 __se_sys_io_submit+0x171/0x2e0 fs/aio.c:2081
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7fdec0b8cda9
Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 a8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007fdec1acd038 EFLAGS: 00000246 ORIG_RAX: 00000000000000d1
RAX: ffffffffffffffda RBX: 00007fdec0da5fa0 RCX: 00007fdec0b8cda9
RDX: 0000000020000540 RSI: 000000000000003b RDI: 00007fdec1a83000
RBP: 00007fdec1acd090 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000002
R13: 0000000000000000 R14: 00007fdec0da5fa0 R15: 00007fff1ee8e6b8
 </TASK>
(syz.0.0,5324,0):ocfs2_grab_folios_for_write:1080 ERROR: status = -12
(syz.0.0,5324,0):ocfs2_write_begin_nolock:1798 ERROR: status = -12
BUG: unable to handle page fault for address: fffffffffffffffc
#PF: supervisor read access in kernel mode
#PF: error_code(0x0000) - not-present page
PGD e73c067 P4D e73c067 PUD e73e067 PMD 0 
Oops: Oops: 0000 [#1] PREEMPT SMP KASAN NOPTI
CPU: 0 UID: 0 PID: 5324 Comm: syz.0.0 Not tainted 6.13.0-syzkaller-09585-gb4b0881156fb #0
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2~bpo12+1 04/01/2014
RIP: 0010:const_folio_flags include/linux/page-flags.h:310 [inline]
RIP: 0010:folio_test_locked include/linux/page-flags.h:510 [inline]
RIP: 0010:folio_unlock+0x3b/0x170 mm/filemap.c:1499
Code: 49 bf 00 00 00 00 00 fc ff df e8 b0 56 c7 ff 4d 8d 66 08 4d 89 e5 49 c1 ed 03 43 80 7c 3d 00 00 74 08 4c 89 e7 e8 95 eb 2d 00 <49> 8b 1c 24 48 89 de 48 83 e6 01 31 ff e8 63 5b c7 ff 48 83 e3 01
RSP: 0018:ffffc9000d286e68 EFLAGS: 00010246
RAX: ffffffff81f815e0 RBX: 1ffff1100a540006 RCX: ffff88801d06a440
RDX: 0000000000000000 RSI: 0000000000000001 RDI: fffffffffffffff4
RBP: ffff888052a00030 R08: ffffffff83ad8522 R09: 1ffffffff20367ee
R10: dffffc0000000000 R11: fffffbfff20367ef R12: fffffffffffffffc
R13: 1fffffffffffffff R14: fffffffffffffff4 R15: dffffc0000000000
FS:  00007fdec1acd6c0(0000) GS:ffff88801fc00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: fffffffffffffffc CR3: 0000000043fb0000 CR4: 0000000000352ef0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 ocfs2_unlock_and_free_folios+0x71/0x1a0 fs/ocfs2/aops.c:772
 ocfs2_free_write_ctxt fs/ocfs2/aops.c:820 [inline]
 ocfs2_write_begin_nolock+0x3908/0x4e40 fs/ocfs2/aops.c:1837
 ocfs2_write_begin+0x205/0x3a0 fs/ocfs2/aops.c:1889
 generic_perform_write+0x346/0x990 mm/filemap.c:4189
 __generic_file_write_iter+0x1b5/0x230 mm/filemap.c:4287
 ocfs2_file_write_iter+0x19af/0x2180 fs/ocfs2/file.c:2469
 aio_write+0x56b/0x7c0 fs/aio.c:1633
 io_submit_one+0x8a7/0x18a0 fs/aio.c:2052
 __do_sys_io_submit fs/aio.c:2111 [inline]
 __se_sys_io_submit+0x171/0x2e0 fs/aio.c:2081
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7fdec0b8cda9
Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 a8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007fdec1acd038 EFLAGS: 00000246 ORIG_RAX: 00000000000000d1
RAX: ffffffffffffffda RBX: 00007fdec0da5fa0 RCX: 00007fdec0b8cda9
RDX: 0000000020000540 RSI: 000000000000003b RDI: 00007fdec1a83000
RBP: 00007fdec1acd090 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000002
R13: 0000000000000000 R14: 00007fdec0da5fa0 R15: 00007fff1ee8e6b8
 </TASK>
Modules linked in:
CR2: fffffffffffffffc
---[ end trace 0000000000000000 ]---
RIP: 0010:const_folio_flags include/linux/page-flags.h:310 [inline]
RIP: 0010:folio_test_locked include/linux/page-flags.h:510 [inline]
RIP: 0010:folio_unlock+0x3b/0x170 mm/filemap.c:1499
Code: 49 bf 00 00 00 00 00 fc ff df e8 b0 56 c7 ff 4d 8d 66 08 4d 89 e5 49 c1 ed 03 43 80 7c 3d 00 00 74 08 4c 89 e7 e8 95 eb 2d 00 <49> 8b 1c 24 48 89 de 48 83 e6 01 31 ff e8 63 5b c7 ff 48 83 e3 01
RSP: 0018:ffffc9000d286e68 EFLAGS: 00010246
RAX: ffffffff81f815e0 RBX: 1ffff1100a540006 RCX: ffff88801d06a440
RDX: 0000000000000000 RSI: 0000000000000001 RDI: fffffffffffffff4
RBP: ffff888052a00030 R08: ffffffff83ad8522 R09: 1ffffffff20367ee
R10: dffffc0000000000 R11: fffffbfff20367ef R12: fffffffffffffffc
R13: 1fffffffffffffff R14: fffffffffffffff4 R15: dffffc0000000000
FS:  00007fdec1acd6c0(0000) GS:ffff88801fc00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: fffffffffffffffc CR3: 0000000043fb0000 CR4: 0000000000352ef0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
----------------
Code disassembly (best guess):
   0:	49 bf 00 00 00 00 00 	movabs $0xdffffc0000000000,%r15
   7:	fc ff df
   a:	e8 b0 56 c7 ff       	call   0xffc756bf
   f:	4d 8d 66 08          	lea    0x8(%r14),%r12
  13:	4d 89 e5             	mov    %r12,%r13
  16:	49 c1 ed 03          	shr    $0x3,%r13
  1a:	43 80 7c 3d 00 00    	cmpb   $0x0,0x0(%r13,%r15,1)
  20:	74 08                	je     0x2a
  22:	4c 89 e7             	mov    %r12,%rdi
  25:	e8 95 eb 2d 00       	call   0x2debbf
* 2a:	49 8b 1c 24          	mov    (%r12),%rbx <-- trapping instruction
  2e:	48 89 de             	mov    %rbx,%rsi
  31:	48 83 e6 01          	and    $0x1,%rsi
  35:	31 ff                	xor    %edi,%edi
  37:	e8 63 5b c7 ff       	call   0xffc75b9f
  3c:	48 83 e3 01          	and    $0x1,%rbx


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
