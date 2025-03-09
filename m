Received: from mail-il1-f205.google.com (mail-il1-f205.google.com [209.85.166.205])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3D3118CC15
	for <ocfs2-devel@lists.linux.dev>; Sun,  9 Mar 2025 11:40:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.205
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741520428; cv=none; b=LCfNI6nQIlC9KdixF8VDqorC4D1gs48ly0OFCHk/26nvdeXqrrlQuTkDIMgT3MpDE3iptvvHHM0PBsIDQo0TKpROxgHfuWMQpvoeIsuARRZTXwHoP9nx9PYFZA8S1EkrTj8oZAgWaPaslie0pjmsZ4j+P007jt4l+12/C4lsu0k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741520428; c=relaxed/simple;
	bh=A7jmwshfHMtHvmApSaG25IVfOUzBcuAuyZmSDluHo48=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:
	 Content-Type; b=guUIx8D5DTkBT2bLtNSvvN+TuZKJZFod5ddm310O4cXVMYDp2YtoOfifMmEbMi1WsJurSpYVewM9BLeMpoHNmNH5+NXDaH0fsPvZcezw42ddUEBN2yMTv7E8qZpa87r95JP/u/8g2vuDtsqg4fyuwFfa25Z97bQMRgwfMYJoTrk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.205
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f205.google.com with SMTP id e9e14a558f8ab-3d4578fbaf4so9873835ab.0
        for <ocfs2-devel@lists.linux.dev>; Sun, 09 Mar 2025 04:40:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741520426; x=1742125226;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=p9PJXD/jSiwFyiuecIvnhM1qNW/tF7+/fyvR00xRfU0=;
        b=Hs+WlbI7TYbgMH8bmCt60Ay8RX6sCWy3/FF0XejzoLenvYRaWlebs08y4NSVrkltMt
         T25X50BVF4p5oFpLmcbjw64nFfsOMRQV3hoCDUL/cXIAyO5sZI880sgCVplwQ06AFFf+
         OCF8H58gmCwOSPgOPr7wE0qBkmWkYs08mZYbmUsit1b9WhpceEOjY+6hXFkGhMyvIYzF
         72x6TyJvMl1UdPbHJZEaNpsseN07Cn48wNcxBq2hqT/QlCaoQX6RSlQZ4XDP0Z9VgJip
         oMJmKOKI7Kl+hrq6Ekdqz5jw5Z+dlvO47iQ3oLHn1nOGKlhDhPpoCsR6YsfVS3/4VmtP
         8r5w==
X-Forwarded-Encrypted: i=1; AJvYcCW50tH8i9KtVcYv/NXpXxUJubdC5O14+CG5/6xwt+xEhK8t2qMQjPgr1FJUGq+fVxxIb0ewf9N5DSzZMA==@lists.linux.dev
X-Gm-Message-State: AOJu0Yz8tmMxe6fgcBv3nzDwYHtI97qtZkOTLjg72MFoBPO25Qp0CTnX
	bagcC6SVNzFwe1lslOLhWMraYvz2/dolcsx5LN85Z6vlEoZI4+J9Hu2s5IBgPBI6eBGuxOb+iID
	41cHiGRZft5DWLnI3bKf4U/s8vYbJy27O1E40DqsNfCSHGp90hvVY2v4=
X-Google-Smtp-Source: AGHT+IErptT0tInK262zP60/UqsMh6kXrpP3aaCRPMgoIPi1iPw09F23416AriWDQdT2Iz6XIGCs2mgG3fb80/3Zuwfh7m6Xy5CY
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:3008:b0:3d3:d07d:20a3 with SMTP id
 e9e14a558f8ab-3d4418cf719mr115685665ab.10.1741520425780; Sun, 09 Mar 2025
 04:40:25 -0700 (PDT)
Date: Sun, 09 Mar 2025 04:40:25 -0700
In-Reply-To: <67483b75.050a0220.253251.007c.GAE@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <67cd7e29.050a0220.e1a89.0007.GAE@google.com>
Subject: Re: [syzbot] [ocfs2?] KASAN: slab-out-of-bounds Read in ocfs2_dx_dir_lookup_rec
From: syzbot <syzbot+20282c1b2184a857ac4c@syzkaller.appspotmail.com>
To: jlbec@evilplan.org, joseph.qi@linux.alibaba.com, 
	linux-kernel@vger.kernel.org, mark@fasheh.com, ocfs2-devel@lists.linux.dev, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

syzbot has found a reproducer for the following issue on:

HEAD commit:    b7c90e3e717a Merge tag 'x86-urgent-2025-03-08' of git://gi..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=14f8fa54580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=2040405600e83619
dashboard link: https://syzkaller.appspot.com/bug?extid=20282c1b2184a857ac4c
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=17c58664580000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=17b1d878580000

Downloadable assets:
disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/7feb34a89c2a/non_bootable_disk-b7c90e3e.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/b1f83f46f4b5/vmlinux-b7c90e3e.xz
kernel image: https://storage.googleapis.com/syzbot-assets/7d502ab93205/bzImage-b7c90e3e.xz
mounted in repro: https://storage.googleapis.com/syzbot-assets/e57bf738b48c/mount_7.gz
  fsck result: OK (log: https://syzkaller.appspot.com/x/fsck.log?x=171a1fa0580000)

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+20282c1b2184a857ac4c@syzkaller.appspotmail.com

On-disk corruption discovered. Please run fsck.ocfs2 once the filesystem is unmounted.
OCFS2: File system is now read-only.
(syz-executor398,5304,0):ocfs2_find_entry_dx:1029 ERROR: status = -30
Oops: general protection fault, probably for non-canonical address 0xdffffc0000000000: 0000 [#1] PREEMPT SMP KASAN NOPTI
KASAN: null-ptr-deref in range [0x0000000000000000-0x0000000000000007]
CPU: 0 UID: 0 PID: 5304 Comm: syz-executor398 Not tainted 6.14.0-rc5-syzkaller-00234-gb7c90e3e717a #0
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2~bpo12+1 04/01/2014
RIP: 0010:ocfs2_dx_dir_lookup_rec+0x325/0x810 fs/ocfs2/dir.c:812
Code: 20 48 83 c3 40 48 89 d8 48 c1 e8 03 42 80 3c 28 00 74 08 48 89 df e8 4a 4b 6f fe 48 8b 03 48 89 44 24 30 4c 89 e0 48 c1 e8 03 <42> 0f b6 04 28 84 c0 0f 85 c0 03 00 00 45 8b 3c 24 4c 89 f0 48 c1
RSP: 0018:ffffc9000d14eb40 EFLAGS: 00010246
RAX: 0000000000000000 RBX: ffff8880447788b8 RCX: ffff8880006f2440
RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffff8880447788a0
RBP: ffffc9000d14ec50 R08: ffffffff83b9ce2e R09: ffffc9000d14ece0
R10: 23ec6d672c196c9a R11: 608b7c562adf3b03 R12: 0000000000000000
R13: dffffc0000000000 R14: ffff8880491092c0 R15: ffff8880491092c0
FS:  000055556a600380(0000) GS:ffff88801fc00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 000055721be84000 CR3: 000000003ef6e000 CR4: 0000000000352ef0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 ocfs2_dx_dir_lookup+0x163/0x930 fs/ocfs2/dir.c:860
 ocfs2_dx_dir_search fs/ocfs2/dir.c:920 [inline]
 ocfs2_find_entry_dx fs/ocfs2/dir.c:1034 [inline]
 ocfs2_find_entry+0x1309/0x2570 fs/ocfs2/dir.c:1071
 ocfs2_check_dir_for_entry+0x17b/0x4a0 fs/ocfs2/dir.c:2040
 ocfs2_mknod+0x83c/0x2b30 fs/ocfs2/namei.c:288
 ocfs2_create+0x1ab/0x470 fs/ocfs2/namei.c:673
 lookup_open fs/namei.c:3651 [inline]
 open_last_lookups fs/namei.c:3750 [inline]
 path_openat+0x193c/0x3590 fs/namei.c:3986
 do_filp_open+0x27f/0x4e0 fs/namei.c:4016
 do_sys_openat2+0x13e/0x1d0 fs/open.c:1428
 do_sys_open fs/open.c:1443 [inline]
 __do_sys_openat fs/open.c:1459 [inline]
 __se_sys_openat fs/open.c:1454 [inline]
 __x64_sys_openat+0x247/0x2a0 fs/open.c:1454
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f4c42698bf9
Code: 28 00 00 00 75 05 48 83 c4 28 c3 e8 61 17 00 00 90 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 b8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007ffef4145088 EFLAGS: 00000246 ORIG_RAX: 0000000000000101
RAX: ffffffffffffffda RBX: 00007f4c426649e3 RCX: 00007f4c42698bf9
RDX: 0000000000105042 RSI: 0000400000000080 RDI: 00000000ffffff9c
RBP: 0000400000000040 R08: 00000000000b45f8 R09: 00000000000b45f8
R10: 00000000000001ff R11: 0000000000000246 R12: 0000000000000001
R13: 00007ffef4145258 R14: 0000000000000001 R15: 0000000000000001
 </TASK>
Modules linked in:
---[ end trace 0000000000000000 ]---
RIP: 0010:ocfs2_dx_dir_lookup_rec+0x325/0x810 fs/ocfs2/dir.c:812
Code: 20 48 83 c3 40 48 89 d8 48 c1 e8 03 42 80 3c 28 00 74 08 48 89 df e8 4a 4b 6f fe 48 8b 03 48 89 44 24 30 4c 89 e0 48 c1 e8 03 <42> 0f b6 04 28 84 c0 0f 85 c0 03 00 00 45 8b 3c 24 4c 89 f0 48 c1
RSP: 0018:ffffc9000d14eb40 EFLAGS: 00010246
RAX: 0000000000000000 RBX: ffff8880447788b8 RCX: ffff8880006f2440
RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffff8880447788a0
RBP: ffffc9000d14ec50 R08: ffffffff83b9ce2e R09: ffffc9000d14ece0
R10: 23ec6d672c196c9a R11: 608b7c562adf3b03 R12: 0000000000000000
R13: dffffc0000000000 R14: ffff8880491092c0 R15: ffff8880491092c0
FS:  000055556a600380(0000) GS:ffff88801fc00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 000055721bea2000 CR3: 000000003ef6e000 CR4: 0000000000352ef0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
----------------
Code disassembly (best guess):
   0:	20 48 83             	and    %cl,-0x7d(%rax)
   3:	c3                   	ret
   4:	40                   	rex
   5:	48 89 d8             	mov    %rbx,%rax
   8:	48 c1 e8 03          	shr    $0x3,%rax
   c:	42 80 3c 28 00       	cmpb   $0x0,(%rax,%r13,1)
  11:	74 08                	je     0x1b
  13:	48 89 df             	mov    %rbx,%rdi
  16:	e8 4a 4b 6f fe       	call   0xfe6f4b65
  1b:	48 8b 03             	mov    (%rbx),%rax
  1e:	48 89 44 24 30       	mov    %rax,0x30(%rsp)
  23:	4c 89 e0             	mov    %r12,%rax
  26:	48 c1 e8 03          	shr    $0x3,%rax
* 2a:	42 0f b6 04 28       	movzbl (%rax,%r13,1),%eax <-- trapping instruction
  2f:	84 c0                	test   %al,%al
  31:	0f 85 c0 03 00 00    	jne    0x3f7
  37:	45 8b 3c 24          	mov    (%r12),%r15d
  3b:	4c 89 f0             	mov    %r14,%rax
  3e:	48                   	rex.W
  3f:	c1                   	.byte 0xc1


---
If you want syzbot to run the reproducer, reply with:
#syz test: git://repo/address.git branch-or-commit-hash
If you attach or paste a git patch, syzbot will apply it before testing.
