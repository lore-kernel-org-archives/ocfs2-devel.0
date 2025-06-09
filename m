Received: from mail-il1-f207.google.com (mail-il1-f207.google.com [209.85.166.207])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BF6521770D
	for <ocfs2-devel@lists.linux.dev>; Mon,  9 Jun 2025 15:57:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749484653; cv=none; b=PiJdqRitZtsTAqV65AXGzEFMSWolgluHjAgA0/bPLm+dXJ3tkP/PAwoANXPsV7itDxkarpGRs1umF4pTix2LRYm0iZCJY7B1xwJKlV/mvIOLP0RRgGLk5JN/EyD2FNFOKPptjKoXw2qa1zbG5MTGtqPkToPvAPE4OBqDOfj3gjs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749484653; c=relaxed/simple;
	bh=eBwnLg2xoAbZmZeQ6rQ/N0+wEy5r52XsJy8iLxAstT4=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=N8pTvR/7ztxEnRg4LPXr8LItF6IodxgLtHaRbpW0ojeY8zNiysN5ZcSRAS/4RFt60hUPBhwy8MR/gC41OGKUGAZZu1j8fkN9QsiWlDf5eUsTx2uz9tHXEKDP653awe6bv60boMLTdNTD70V1jJO3Tpdw+Nvhrz252o7/0+mjDks=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f207.google.com with SMTP id e9e14a558f8ab-3ddc0a6d4bdso62902915ab.0
        for <ocfs2-devel@lists.linux.dev>; Mon, 09 Jun 2025 08:57:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749484650; x=1750089450;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=JQMzVVfsh9sZSZRgT86ZYU+ugvIceGlt5LN3aAQ3nlo=;
        b=PzmoaA7iRcimqrlAg5AopfCEGmGJ6fU2WeHYJBLQ186Xf6d+6hLLoHxFINLiAlL7y0
         +mImAMNcA32n47GxtLT6kTd686MlmXXcOX2K8SjINeOzVCEWBUX+c5jIyY0T0pGqJdG4
         3ADiTaiVSe6A95E1SUOWyuWOSqVp5jTl9zp7HyUqyEdczfuEs0DZ2nA7FGs6MtNmCj2J
         q+EMvNxVBTyGslrKA7L0BKFw2I67ULyqMnw86hgLmvyn6tFIAIUNdmAEBfP80fq6fRp5
         3zZvS3OH9tSw4HQ5aHX1QYVaVC1vCEU3r2X8KI5hsqAOx9naGp+kGIBU7YuUoX/6r7G5
         HE8w==
X-Forwarded-Encrypted: i=1; AJvYcCWrr0JYcbKk52bur62WBHPlAibjXqo8MafW+TQsVNIoHy4cDTlDK+9y80S0AfPY+jz4QUpMlBBYpC0brA==@lists.linux.dev
X-Gm-Message-State: AOJu0YwzaEq8XTefNc3hKcsJAC5nnxeVP8vwE6EIslobkBEuODMRwOMp
	TL9PoBBZK+VIZiBcN8SrEWgAbVQ0SZ6tqJr8bBLPC/W0k33UOMaf0+lNiLuyCcpDWuND/dyJrlR
	zNkGUnXTp9GZnY2SvuVOzxW5RVLNlBNKDbX6atSKkINWYqEpxj/Woip9u64E=
X-Google-Smtp-Source: AGHT+IHXU59SM76wNE/ilrXZy6B5JgJJb1vDpGKej7U4GZNYikx6cKqRVs3T/9g/ml9pJxywPE6zvK5eHnR/8R1WawgvqRQkMmAQ
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a92:cd8c:0:b0:3dc:8b29:30b1 with SMTP id
 e9e14a558f8ab-3ddce42f5cbmr121291855ab.14.1749484650398; Mon, 09 Jun 2025
 08:57:30 -0700 (PDT)
Date: Mon, 09 Jun 2025 08:57:30 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6847046a.050a0220.33aa0e.02ad.GAE@google.com>
Subject: [syzbot] [ocfs2?] general protection fault in ocfs2_prepare_dir_for_insert
 (2)
From: syzbot <syzbot+ded9116588a7b73c34bc@syzkaller.appspotmail.com>
To: jlbec@evilplan.org, joseph.qi@linux.alibaba.com, 
	linux-kernel@vger.kernel.org, mark@fasheh.com, ocfs2-devel@lists.linux.dev, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    ec7714e49479 Merge tag 'rust-6.16' of git://git.kernel.org..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=15bc2c0c580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=73696606574e3967
dashboard link: https://syzkaller.appspot.com/bug?extid=ded9116588a7b73c34bc
compiler:       Debian clang version 20.1.6 (++20250514063057+1e4d39e07757-1~exp1~20250514183223.118), Debian LLD 20.1.6
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=13bc2c0c580000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=11a50c0c580000

Downloadable assets:
disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/d900f083ada3/non_bootable_disk-ec7714e4.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/13d41a3ddb72/vmlinux-ec7714e4.xz
kernel image: https://storage.googleapis.com/syzbot-assets/ae9a3fb85228/bzImage-ec7714e4.xz
mounted in repro: https://storage.googleapis.com/syzbot-assets/31be3ccfd03b/mount_0.gz
  fsck result: OK (log: https://syzkaller.appspot.com/x/fsck.log?x=1463e570580000)

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+ded9116588a7b73c34bc@syzkaller.appspotmail.com

ocfs2: Mounting device (7,0) on (node local, slot 0) with writeback data mode.
Oops: general protection fault, probably for non-canonical address 0xdffffc0000000001: 0000 [#1] SMP KASAN NOPTI
KASAN: null-ptr-deref in range [0x0000000000000008-0x000000000000000f]
CPU: 0 UID: 0 PID: 5317 Comm: syz-executor310 Not tainted 6.15.0-syzkaller-12141-gec7714e49479 #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2~bpo12+1 04/01/2014
RIP: 0010:ocfs2_find_dir_space_id fs/ocfs2/dir.c:3424 [inline]
RIP: 0010:ocfs2_prepare_dir_for_insert+0x2f41/0x5450 fs/ocfs2/dir.c:4288
Code: ca 8b e8 52 8f 19 00 e9 fd 11 00 00 e8 b8 a4 26 fe e9 a7 02 00 00 e8 ae a4 26 fe 49 8d 7f 08 4d 8d 77 09 48 89 f8 48 c1 e8 03 <42> 0f b6 04 20 84 c0 0f 85 41 20 00 00 4c 89 f0 48 c1 e8 03 42 0f
RSP: 0018:ffffc9000d3e6320 EFLAGS: 00010202
RAX: 0000000000000001 RBX: ffff88804710de48 RCX: ffff88801a3c8000
RDX: 0000000000000000 RSI: 0000000000000400 RDI: 0000000000000008
RBP: ffffc9000d3e6a30 R08: ffffc9000d3e6c90 R09: 608b7c562adf3b03
R10: 23ec6d672c196c9a R11: 608b7c562adf3b03 R12: dffffc0000000000
R13: ffff88804710ddf8 R14: 0000000000000009 R15: 0000000000000000
FS:  00005555581f0380(0000) GS:ffff88808d255000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f8847f56100 CR3: 0000000043298000 CR4: 0000000000352ef0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 __ocfs2_prepare_orphan_dir+0x145/0x2c0 fs/ocfs2/namei.c:2176
 ocfs2_prepare_orphan_dir+0xf9/0x3f0 fs/ocfs2/namei.c:2221
 ocfs2_add_inode_to_orphan+0x1d6/0x710 fs/ocfs2/namei.c:2669
 ocfs2_dio_wr_get_block+0x7ea/0x1770 fs/ocfs2/aops.c:2183
 get_more_blocks fs/direct-io.c:648 [inline]
 do_direct_IO fs/direct-io.c:936 [inline]
 __blockdev_direct_IO+0x16da/0x33d0 fs/direct-io.c:1243
 ocfs2_direct_IO+0x25f/0x2d0 fs/ocfs2/aops.c:2438
 generic_file_direct_write+0x1db/0x3e0 mm/filemap.c:4046
 __generic_file_write_iter+0x11d/0x230 mm/filemap.c:4215
 ocfs2_file_write_iter+0x157a/0x1d10 fs/ocfs2/file.c:2469
 iter_file_splice_write+0x937/0x1000 fs/splice.c:738
 do_splice_from fs/splice.c:935 [inline]
 direct_splice_actor+0x101/0x160 fs/splice.c:1158
 splice_direct_to_actor+0x5a5/0xcc0 fs/splice.c:1102
 do_splice_direct_actor fs/splice.c:1201 [inline]
 do_splice_direct+0x181/0x270 fs/splice.c:1227
 do_sendfile+0x4da/0x7e0 fs/read_write.c:1370
 __do_sys_sendfile64 fs/read_write.c:1431 [inline]
 __se_sys_sendfile64+0x13e/0x190 fs/read_write.c:1417
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0xfa/0x3b0 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f8847edab99
Code: 28 00 00 00 75 05 48 83 c4 28 c3 e8 f1 17 00 00 90 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 b8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007ffd3d732a28 EFLAGS: 00000246 ORIG_RAX: 0000000000000028
RAX: ffffffffffffffda RBX: 0031656c69662f2e RCX: 00007f8847edab99
RDX: 0000000000000000 RSI: 0000000000000005 RDI: 0000000000000004
RBP: 00007f8847f525f0 R08: 0023706f6f6c2f76 R09: 00005555581f14c0
R10: 0000000080000002 R11: 0000000000000246 R12: 00007ffd3d732a50
R13: 00007ffd3d732c78 R14: 431bde82d7b634db R15: 00007f8847f2303b
 </TASK>
Modules linked in:
---[ end trace 0000000000000000 ]---
RIP: 0010:ocfs2_find_dir_space_id fs/ocfs2/dir.c:3424 [inline]
RIP: 0010:ocfs2_prepare_dir_for_insert+0x2f41/0x5450 fs/ocfs2/dir.c:4288
Code: ca 8b e8 52 8f 19 00 e9 fd 11 00 00 e8 b8 a4 26 fe e9 a7 02 00 00 e8 ae a4 26 fe 49 8d 7f 08 4d 8d 77 09 48 89 f8 48 c1 e8 03 <42> 0f b6 04 20 84 c0 0f 85 41 20 00 00 4c 89 f0 48 c1 e8 03 42 0f
RSP: 0018:ffffc9000d3e6320 EFLAGS: 00010202
RAX: 0000000000000001 RBX: ffff88804710de48 RCX: ffff88801a3c8000
RDX: 0000000000000000 RSI: 0000000000000400 RDI: 0000000000000008
RBP: ffffc9000d3e6a30 R08: ffffc9000d3e6c90 R09: 608b7c562adf3b03
R10: 23ec6d672c196c9a R11: 608b7c562adf3b03 R12: dffffc0000000000
R13: ffff88804710ddf8 R14: 0000000000000009 R15: 0000000000000000
FS:  00005555581f0380(0000) GS:ffff88808d255000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f8847f56100 CR3: 0000000043298000 CR4: 0000000000352ef0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
----------------
Code disassembly (best guess), 2 bytes skipped:
   0:	e8 52 8f 19 00       	call   0x198f57
   5:	e9 fd 11 00 00       	jmp    0x1207
   a:	e8 b8 a4 26 fe       	call   0xfe26a4c7
   f:	e9 a7 02 00 00       	jmp    0x2bb
  14:	e8 ae a4 26 fe       	call   0xfe26a4c7
  19:	49 8d 7f 08          	lea    0x8(%r15),%rdi
  1d:	4d 8d 77 09          	lea    0x9(%r15),%r14
  21:	48 89 f8             	mov    %rdi,%rax
  24:	48 c1 e8 03          	shr    $0x3,%rax
* 28:	42 0f b6 04 20       	movzbl (%rax,%r12,1),%eax <-- trapping instruction
  2d:	84 c0                	test   %al,%al
  2f:	0f 85 41 20 00 00    	jne    0x2076
  35:	4c 89 f0             	mov    %r14,%rax
  38:	48 c1 e8 03          	shr    $0x3,%rax
  3c:	42                   	rex.X
  3d:	0f                   	.byte 0xf


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
