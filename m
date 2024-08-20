Received: from mail-il1-f199.google.com (mail-il1-f199.google.com [209.85.166.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40FBD188CBD
	for <ocfs2-devel@lists.linux.dev>; Tue, 20 Aug 2024 07:58:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724140709; cv=none; b=PKue9CQaVPzjwgYqth3BZ66WrFLWX0GasGxbpPi1KzTU3624atJEPKCR6+ubDnDYBxQTgnKPNOevsBrpOf76OkM/Ca5qQzjy4GChg3G9hfIZdRKzD3B+gMLydng9V/YCZRer6W8n/SLuzNG3c0U0Rh8WI51GooAvZqA6BjXauUc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724140709; c=relaxed/simple;
	bh=67qmrw0+WQj84veMh1dqkYoXrsITVb16oR9I5LOUV/s=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=bWk9xhQMUVspgNp0ZRjV5o+jtDr4DVN0mXdLqAdcqvNiKrZt/6MrlEEyoTa16ScG3B75gj79U7pPMenVLwtCNsxMN4pVOsp2ZK5cHgNFdwPG2+TVfmUFaeWXvshe66yEepWr9bBtb+iwlmDrnvNS2U9SWF/4aKxvzYZNYcSXCz8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f199.google.com with SMTP id e9e14a558f8ab-39d47fe875cso35077395ab.2
        for <ocfs2-devel@lists.linux.dev>; Tue, 20 Aug 2024 00:58:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724140707; x=1724745507;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=hhNCGOb6XK7oobwH0gSQwHyu2zFQ7pAJNf8SQsyUj7M=;
        b=jnNxGgnvYWy3LcSlm/zLQxF7DTRFF1sV35VkOLhomW+S0XG4wlhEAUecwTN6T2aMC2
         L2ArsNeZ4/B/Qno56ShOA7Y10I04/b3MmMc+/011v+mWc7b/zuYNC8SfBENx2KnWLriq
         iOJ2vqviyn6tdp/CVzRgq2VB8whaqIyJdO85zFE9KDRPv2Xgy8eeNYXY/TH2o8cJi1d3
         q+iRolxXvtCfCfO7cznHRylXGBoFHxtdPgxn/MOgAsZ3m3lWE1UOi7dQn+txla5JjXex
         xe7imwOT46FxS8BE15HOFYKLEhoE/r9NfGVF5kM40IRJK3VVwktRzrk/4VbjgprT3Rtv
         aGng==
X-Forwarded-Encrypted: i=1; AJvYcCXGW9GPBDeBpKQHhUsCBVsHRLAUXwsOQW/X9MyhRaYGb6aSAfE0K7ifaiRGvrH2NY+0r7RgthBA2kWWxmItbJF0rIHIPkPlUv8cFlE=
X-Gm-Message-State: AOJu0YzbjwQGWzxZqLf4r4B44XE96SLoeLEzzpTLVpsEVs7Sy9bC0AaT
	s4LZUZ4F7NqEkCqmZ/6ocEuuEOzQM1c2WVWObMrf6MJxODlYyds2lmpKv2xRvXle8TPd3iYajWQ
	HcXIXtRiapl1sKytvbJrxzSGdUn2xXHdeF+cJIaCI4yusy1O0ySDDEyU=
X-Google-Smtp-Source: AGHT+IGBIuavGhgArxoh4WRlwWK6QZx0hVSiwxAc21Pg24ZpJerRdwk6wk1OorjljvTLkmUNY50tBOWJJbLWSVEN+kqZenLrJmZo
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a92:c54b:0:b0:397:b509:6441 with SMTP id
 e9e14a558f8ab-39d26ceb6a7mr11949705ab.2.1724140706365; Tue, 20 Aug 2024
 00:58:26 -0700 (PDT)
Date: Tue, 20 Aug 2024 00:58:26 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000005894f3062018caf1@google.com>
Subject: [syzbot] [ocfs2?] general protection fault in ocfs2_prepare_dir_for_insert
From: syzbot <syzbot+5a64828fcc4c2ad9b04f@syzkaller.appspotmail.com>
To: jlbec@evilplan.org, joseph.qi@linux.alibaba.com, 
	linux-kernel@vger.kernel.org, mark@fasheh.com, ocfs2-devel@lists.linux.dev, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    b0da640826ba Merge tag 'printk-for-6.11-rc5' of git://git...
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=10d2076b980000
kernel config:  https://syzkaller.appspot.com/x/.config?x=df2f0ed7e30a639d
dashboard link: https://syzkaller.appspot.com/bug?extid=5a64828fcc4c2ad9b04f
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1680ffcb980000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=153aec05980000

Downloadable assets:
disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/7bc7510fe41f/non_bootable_disk-b0da6408.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/f630005f615b/vmlinux-b0da6408.xz
kernel image: https://storage.googleapis.com/syzbot-assets/4e3e4edbec91/bzImage-b0da6408.xz
mounted in repro: https://storage.googleapis.com/syzbot-assets/1a3cbd9c01e6/mount_0.gz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+5a64828fcc4c2ad9b04f@syzkaller.appspotmail.com

loop0: detected capacity change from 0 to 32768
JBD2: Ignoring recovery information on journal
ocfs2: Mounting device (7,0) on (node local, slot 0) with ordered data mode.
Oops: general protection fault, probably for non-canonical address 0xdffffc0000000001: 0000 [#1] PREEMPT SMP KASAN NOPTI
KASAN: null-ptr-deref in range [0x0000000000000008-0x000000000000000f]
CPU: 0 UID: 0 PID: 5096 Comm: syz-executor792 Not tainted 6.11.0-rc4-syzkaller-00002-gb0da640826ba #0
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2~bpo12+1 04/01/2014
RIP: 0010:ocfs2_find_dir_space_id fs/ocfs2/dir.c:3406 [inline]
RIP: 0010:ocfs2_prepare_dir_for_insert+0x3309/0x5c70 fs/ocfs2/dir.c:4280
Code: 00 00 e8 2a 25 13 fe e9 ba 06 00 00 e8 20 25 13 fe e9 4f 01 00 00 e8 16 25 13 fe 49 8d 7f 08 49 8d 5f 09 48 89 f8 48 c1 e8 03 <42> 0f b6 04 20 84 c0 0f 85 bd 23 00 00 48 89 d8 48 c1 e8 03 42 0f
RSP: 0018:ffffc9000af9f020 EFLAGS: 00010202
RAX: 0000000000000001 RBX: 0000000000000009 RCX: ffff88801e27a440
RDX: 0000000000000000 RSI: 0000000000000400 RDI: 0000000000000008
RBP: ffffc9000af9f830 R08: ffffffff8380395b R09: ffffffff838090a7
R10: 0000000000000002 R11: ffff88801e27a440 R12: dffffc0000000000
R13: ffff88803c660878 R14: f700000000000088 R15: 0000000000000000
FS:  000055555a677380(0000) GS:ffff888020800000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000560bce569178 CR3: 000000001de5a000 CR4: 0000000000350ef0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 ocfs2_mknod+0xcaf/0x2b40 fs/ocfs2/namei.c:292
 vfs_mknod+0x36d/0x3b0 fs/namei.c:4088
 do_mknodat+0x3ec/0x5b0
 __do_sys_mknodat fs/namei.c:4166 [inline]
 __se_sys_mknodat fs/namei.c:4163 [inline]
 __x64_sys_mknodat+0xa7/0xc0 fs/namei.c:4163
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f2dafda3a99
Code: 28 00 00 00 75 05 48 83 c4 28 c3 e8 f1 17 00 00 90 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 b8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007ffe336a6658 EFLAGS: 00000246 ORIG_RAX: 0000000000000103
RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007f2dafda3a99
RDX: 00000000000021c0 RSI: 0000000020000040 RDI: 00000000ffffff9c
RBP: 00007f2dafe1b5f0 R08: 0000000000004480 R09: 000055555a6784c0
R10: 0000000000000103 R11: 0000000000000246 R12: 00007ffe336a6680
R13: 00007ffe336a68a8 R14: 431bde82d7b634db R15: 00007f2dafdec03b
 </TASK>
Modules linked in:
---[ end trace 0000000000000000 ]---
RIP: 0010:ocfs2_find_dir_space_id fs/ocfs2/dir.c:3406 [inline]
RIP: 0010:ocfs2_prepare_dir_for_insert+0x3309/0x5c70 fs/ocfs2/dir.c:4280
Code: 00 00 e8 2a 25 13 fe e9 ba 06 00 00 e8 20 25 13 fe e9 4f 01 00 00 e8 16 25 13 fe 49 8d 7f 08 49 8d 5f 09 48 89 f8 48 c1 e8 03 <42> 0f b6 04 20 84 c0 0f 85 bd 23 00 00 48 89 d8 48 c1 e8 03 42 0f
RSP: 0018:ffffc9000af9f020 EFLAGS: 00010202
RAX: 0000000000000001 RBX: 0000000000000009 RCX: ffff88801e27a440
RDX: 0000000000000000 RSI: 0000000000000400 RDI: 0000000000000008
RBP: ffffc9000af9f830 R08: ffffffff8380395b R09: ffffffff838090a7
R10: 0000000000000002 R11: ffff88801e27a440 R12: dffffc0000000000
R13: ffff88803c660878 R14: f700000000000088 R15: 0000000000000000
FS:  000055555a677380(0000) GS:ffff888020800000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000560bce569178 CR3: 000000001de5a000 CR4: 0000000000350ef0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
----------------
Code disassembly (best guess):
   0:	00 00                	add    %al,(%rax)
   2:	e8 2a 25 13 fe       	call   0xfe132531
   7:	e9 ba 06 00 00       	jmp    0x6c6
   c:	e8 20 25 13 fe       	call   0xfe132531
  11:	e9 4f 01 00 00       	jmp    0x165
  16:	e8 16 25 13 fe       	call   0xfe132531
  1b:	49 8d 7f 08          	lea    0x8(%r15),%rdi
  1f:	49 8d 5f 09          	lea    0x9(%r15),%rbx
  23:	48 89 f8             	mov    %rdi,%rax
  26:	48 c1 e8 03          	shr    $0x3,%rax
* 2a:	42 0f b6 04 20       	movzbl (%rax,%r12,1),%eax <-- trapping instruction
  2f:	84 c0                	test   %al,%al
  31:	0f 85 bd 23 00 00    	jne    0x23f4
  37:	48 89 d8             	mov    %rbx,%rax
  3a:	48 c1 e8 03          	shr    $0x3,%rax
  3e:	42                   	rex.X
  3f:	0f                   	.byte 0xf


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
