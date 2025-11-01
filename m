Received: from mail-il1-f206.google.com (mail-il1-f206.google.com [209.85.166.206])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 435A022173D
	for <ocfs2-devel@lists.linux.dev>; Sat,  1 Nov 2025 09:03:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.206
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761987805; cv=none; b=E88JGAa7HSqPD+8buRQZvO2wVjCsOES9rNn6r0366CWuVs5angwzezjPmVWyAq+dx5GeAoTySokEXqHIJWmuYJOkmJXl/7/RbULS3QDNPxaTvE8eOPydntj/RbA7xOR4DF4+vSbDf/PtMs6GgxX0khCWIdKOesT5VaGef2KgAw4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761987805; c=relaxed/simple;
	bh=9zw0fQzkZU069VpAF7zgk3WnsFPUO7hjMuj1hwtJVf8=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=AfdCWn5OKAWUk80kphNhWDojrpIcqIrLfBKUVWPo8aybXiGn0rUN2+ZApTfwgATROlPcgJDGJEWS30mrH0gpCQ/RwGjCEXKgiBHoPHUCgV6qe1+9j+ga49M1mVeO0Gvlcn9ieYiOLxgkyjLdZIxqVH1fAdW+rawX+Mx0+KrVueQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.206
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f206.google.com with SMTP id e9e14a558f8ab-4332249d8baso9326985ab.0
        for <ocfs2-devel@lists.linux.dev>; Sat, 01 Nov 2025 02:03:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761987802; x=1762592602;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=pf76Hd5vgGJ7oxkL6ijeQHPMEy2GLQx6R0KPYx0hzk8=;
        b=H7g8/EdndjNsENFg2Ia9df2mOT3Pi1JtG31L09y7TNmLoSflvR4nyTb2joKKStYU70
         jHyxZDSv0Rd2k1u9yE+jiXbZkTFwndVjRgE14Rvk42K/kxdUVrlHHnVspzxRq3UEqWq7
         6g5hSc4274EfxO4aZWJB1yGoSJJGSjgVNXTtZW/ZhPaWtBmpVmPLaQzQB68Dz4iAVkW4
         gR75UvCUslH448P6VxMrw1rUSV9g8SWR3DSSI1pxYbAJNUzvb7Sbt9Bye3imOdnHb+oH
         RvbjN9juXUD9/ic00FSvYwusCnognrd8PcuBsNBwoDJrUgExxfsT/kWEaz5YDUsWNV44
         8Buw==
X-Forwarded-Encrypted: i=1; AJvYcCXcq90UPO+JiwMpfSAD0koINmXxdB/xm4/pk7tDYoSW4Rxlre6YPPf8nCvMxSpL/72mfpMa6t5p3JFt9w==@lists.linux.dev
X-Gm-Message-State: AOJu0YxTskmjAJQPSVJ1bEDgrdH0hJdtzeQDJOjDTV+iBHzptsQ7wQU1
	V26tKJpGgnZ+vexxmNnF/foR8J4PeEVCp3EVslpm/n6/nnAxoWmAJ4J77nDszzCh/mb1zH7dZca
	5N1UHqUzJXSTkyIPpRQb8g22g84uZgWF8Woi/9yLl/Jp5Ox1rLYkEkOAhSzo=
X-Google-Smtp-Source: AGHT+IHzuXjQVbm0BA4RqY95jTn5np8kTxqmPkk8uQd662dfLL9TQw8TvH1JR8qeGSB57Hdyifkn6bCZisJPo2Tymh2KmmVOdIl0
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1a28:b0:432:fbe2:35f2 with SMTP id
 e9e14a558f8ab-4330d125b9dmr95820205ab.4.1761987802311; Sat, 01 Nov 2025
 02:03:22 -0700 (PDT)
Date: Sat, 01 Nov 2025 02:03:22 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6905ccda.a70a0220.eb9ff.003f.GAE@google.com>
Subject: [syzbot] [ocfs2?] kernel BUG in ocfs2_page_mkwrite (3)
From: syzbot <syzbot+ea5aff81e35d189b9335@syzkaller.appspotmail.com>
To: jlbec@evilplan.org, joseph.qi@linux.alibaba.com, 
	linux-kernel@vger.kernel.org, mark@fasheh.com, ocfs2-devel@lists.linux.dev, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    fd57572253bc Merge tag 'sched_ext-for-6.18-rc3-fixes' of g..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=11bc6c92580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=929790bc044e87d7
dashboard link: https://syzkaller.appspot.com/bug?extid=ea5aff81e35d189b9335
compiler:       Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~exp1~20250708183702.136), Debian LLD 20.1.8

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/d900f083ada3/non_bootable_disk-fd575722.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/6e170eb91da3/vmlinux-fd575722.xz
kernel image: https://storage.googleapis.com/syzbot-assets/0a3532363786/bzImage-fd575722.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+ea5aff81e35d189b9335@syzkaller.appspotmail.com

loop0: detected capacity change from 0 to 32768
=======================================================
WARNING: The mand mount option has been deprecated and
         and is ignored by this kernel. Remove the mand
         option from the mount to silence this warning.
=======================================================
JBD2: Ignoring recovery information on journal
ocfs2: Mounting device (7,0) on (node local, slot 0) with ordered data mode.
(syz.0.0,5316,0):__ocfs2_journal_access:727 ERROR: Error -30 getting 1 access to buffer!
(syz.0.0,5316,0):ocfs2_write_end_nolock:1944 ERROR: status = -30
(syz.0.0,5316,0):ocfs2_commit_trans:404 ERROR: status = -5
------------[ cut here ]------------
kernel BUG at fs/ocfs2/mmap.c:107!
Oops: invalid opcode: 0000 [#1] SMP KASAN NOPTI
CPU: 0 UID: 0 PID: 5316 Comm: syz.0.0 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2~bpo12+1 04/01/2014
RIP: 0010:__ocfs2_page_mkwrite fs/ocfs2/mmap.c:107 [inline]
RIP: 0010:ocfs2_page_mkwrite+0xc37/0xc40 fs/ocfs2/mmap.c:144
Code: 07 e8 9d 45 17 fe eb 0d 48 ff cb e8 93 45 17 fe 48 89 5c 24 08 49 be 00 00 00 00 00 fc ff df e9 cb f4 ff ff e8 7a 45 17 fe 90 <0f> 0b cc cc cc cc cc cc cc 90 90 90 90 90 90 90 90 90 90 90 90 90
RSP: 0018:ffffc9000f557320 EFLAGS: 00010246
RAX: ffffffff83a8ce96 RBX: 00000000ffffffe2 RCX: 0000000000100000
RDX: ffffc9000dcfa000 RSI: 00000000000fffff RDI: 0000000000100000
RBP: ffffc9000f5574c0 R08: ffffffff8f7cf477 R09: 1ffffffff1ef9e8e
R10: dffffc0000000000 R11: fffffbfff1ef9e8f R12: ffffea00014b1ac0
R13: 0000000000002fff R14: 0000000000000000 R15: 0000000000001000
FS:  00007f9f7161c6c0(0000) GS:ffff88808d733000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00002000000d0e40 CR3: 000000004258c000 CR4: 0000000000352ef0
Call Trace:
 <TASK>
 do_page_mkwrite+0x14d/0x310 mm/memory.c:3488
 wp_page_shared mm/memory.c:3889 [inline]
 do_wp_page+0x268d/0x5800 mm/memory.c:4108
 handle_pte_fault mm/memory.c:6193 [inline]
 __handle_mm_fault+0x1033/0x5400 mm/memory.c:6318
 handle_mm_fault+0x40a/0x8e0 mm/memory.c:6487
 do_user_addr_fault+0x764/0x1380 arch/x86/mm/fault.c:1387
 handle_page_fault arch/x86/mm/fault.c:1476 [inline]
 exc_page_fault+0x82/0x100 arch/x86/mm/fault.c:1532
 asm_exc_page_fault+0x26/0x30 arch/x86/include/asm/idtentry.h:618
RIP: 0010:rep_movs_alternative+0x4a/0x90 arch/x86/lib/copy_user_64.S:74
Code: 31 04 00 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 00 48 8b 06 48 89 07 48 83 c6 08 48 83 c7 08 83 e9 08 74 db 83 f9 08 73 e8 eb c5 <f3> a4 c3 cc cc cc cc 48 8b 06 48 89 07 48 8d 47 08 48 83 e0 f8 48
RSP: 0018:ffffc9000f557ae8 EFLAGS: 00050246
RAX: ffffffff848b1901 RBX: 0000000000000040 RCX: 0000000000000040
RDX: 0000000000000000 RSI: ffffc9000f557b80 RDI: 00002000000d0e40
RBP: ffffc9000f557c30 R08: ffffc9000f557bbf R09: 1ffff92001eaaf77
R10: dffffc0000000000 R11: fffff52001eaaf78 R12: 00002000000d0e80
R13: 00007ffffffff000 R14: ffffc9000f557b80 R15: 00002000000d0e40
 copy_user_generic arch/x86/include/asm/uaccess_64.h:126 [inline]
 raw_copy_to_user arch/x86/include/asm/uaccess_64.h:147 [inline]
 _inline_copy_to_user include/linux/uaccess.h:197 [inline]
 _copy_to_user+0x8a/0xb0 lib/usercopy.c:26
 copy_to_user include/linux/uaccess.h:225 [inline]
 rng_dev_read+0x3f2/0x770 drivers/char/hw_random/core.c:258
 do_loop_readv_writev fs/read_write.c:847 [inline]
 vfs_readv+0x5aa/0x850 fs/read_write.c:1020
 do_preadv fs/read_write.c:1132 [inline]
 __do_sys_preadv fs/read_write.c:1179 [inline]
 __se_sys_preadv fs/read_write.c:1174 [inline]
 __x64_sys_preadv+0x197/0x2a0 fs/read_write.c:1174
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0xfa/0xfa0 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f9f7078efc9
Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 a8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f9f7161c038 EFLAGS: 00000246 ORIG_RAX: 0000000000000127
RAX: ffffffffffffffda RBX: 00007f9f709e5fa0 RCX: 00007f9f7078efc9
RDX: 0000000000000001 RSI: 0000200000000240 RDI: 0000000000000008
RBP: 00007f9f70811f91 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007f9f709e6038 R14: 00007f9f709e5fa0 R15: 00007ffde7cc2f48
 </TASK>
Modules linked in:
---[ end trace 0000000000000000 ]---
RIP: 0010:__ocfs2_page_mkwrite fs/ocfs2/mmap.c:107 [inline]
RIP: 0010:ocfs2_page_mkwrite+0xc37/0xc40 fs/ocfs2/mmap.c:144
Code: 07 e8 9d 45 17 fe eb 0d 48 ff cb e8 93 45 17 fe 48 89 5c 24 08 49 be 00 00 00 00 00 fc ff df e9 cb f4 ff ff e8 7a 45 17 fe 90 <0f> 0b cc cc cc cc cc cc cc 90 90 90 90 90 90 90 90 90 90 90 90 90
RSP: 0018:ffffc9000f557320 EFLAGS: 00010246
RAX: ffffffff83a8ce96 RBX: 00000000ffffffe2 RCX: 0000000000100000
RDX: ffffc9000dcfa000 RSI: 00000000000fffff RDI: 0000000000100000
RBP: ffffc9000f5574c0 R08: ffffffff8f7cf477 R09: 1ffffffff1ef9e8e
R10: dffffc0000000000 R11: fffffbfff1ef9e8f R12: ffffea00014b1ac0
R13: 0000000000002fff R14: 0000000000000000 R15: 0000000000001000
FS:  00007f9f7161c6c0(0000) GS:ffff88808d733000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00002000000d0e40 CR3: 000000004258c000 CR4: 0000000000352ef0
----------------
Code disassembly (best guess):
   0:	31 04 00             	xor    %eax,(%rax,%rax,1)
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
