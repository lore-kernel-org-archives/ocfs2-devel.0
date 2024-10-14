Received: from mail-il1-f197.google.com (mail-il1-f197.google.com [209.85.166.197])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FA8A3E47B
	for <ocfs2-devel@lists.linux.dev>; Mon, 14 Oct 2024 06:17:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.197
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728886645; cv=none; b=j5j9QOAn0dyBcPoc1kaeLXJvErv2NVZXxQ8a234eOU+NNcbUdoV3U9asIbmEHO5CQYshwAAYCYmrbhC3idim+b1/vz4xX2fLf4z4W/8o9kxJ51/2FCpHh7QGTLZyebgl+xCCRa8KyYRJrTeGZakIMrmqP3OeGlrfIEemCdYCAjY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728886645; c=relaxed/simple;
	bh=FuSlxbMfeRmXypGhWxhFJ8OCi9c5Q63HRLEBD628/+Y=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=qrYUeoh2Nkm/jF28SiATBHsn2i1QcApcjWz2T+gaxo8sczeZvHXxoSyefplxkQQce67/L056s5orGfDSLWJvNbAt9QVEnnOavbAZjBBPKPvcsIV2sGIDtD3cvQLS6NVmyXPPmY1Q6stSeoB4x/yX3XQBYupdJjQll31HjBm2qAg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.197
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f197.google.com with SMTP id e9e14a558f8ab-3a3c4554d29so5306305ab.1
        for <ocfs2-devel@lists.linux.dev>; Sun, 13 Oct 2024 23:17:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728886642; x=1729491442;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=B6SLUhu9WKh2xClqb5Vsket9NVDXVbBlHIM8iF15Kng=;
        b=imAYjjssuK9oyVCtz1kztAAZOe7lJ59lHaD2ASQwWUB97z1U5i5AcRV+fGJLJCyJ+R
         aw1tKsIAdDBp6GgQe5B2843DqKYtAfqWB7uDixmxnB0znG5x3a2Ol5vEjROkIyDuomnR
         Z4bkI3cOFEhObUiEZQMNf5LCWVs4Y7n3NUnPoRmigWdY+Sy3HBps/1N2AApNOVcU56Hd
         eiC4sg2x7Z0+GyfdpLZpGpXvcaJ5g2CiEqBs041zFo3CM8ZK/F+9ebiLPeHxJHdVyQP6
         GRCInG0e67xZoqGwuy0VvrfnJMDWCvTpyf+V5ZxxXfqkjECk1NiojGxOUe4yagxUtL4e
         FVyQ==
X-Forwarded-Encrypted: i=1; AJvYcCWKBMq8zHdWyo+5Dlu0VkklWGUK12VK27CmyBUzZirQ9+M9/CtWZp0QaEWPPTC62YrDduOtQgkqXDaYqQ==@lists.linux.dev
X-Gm-Message-State: AOJu0YzoDA1COEgD9a0J/agcIVCP4OBsY1Shb1cyOLPZPTvZrj0b4bO+
	jurlHAmHdnkhd9cyzrZ7MsNtYUk8HX9n/Yz6+brckjNMwh3zAn0K1vxrmVcXjiM/0oBS5DlYh97
	SqyMXu39MaxaXsGoB/aYsOmoIydWTZ1ZCvHgVfq5EXbs+PBp0E9bs744=
X-Google-Smtp-Source: AGHT+IF0KpBUXtqkzLwJiDpYmExyMkV1rKRbG/VoTqbvM2rsUGprgHORYYlAh+CBuRNIjWhFq9FQ7p8IMDvfTD3aHG2bRpbTQ9Fk
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:178b:b0:3a0:8d60:8b7d with SMTP id
 e9e14a558f8ab-3a3bcdbdb3emr43271045ab.11.1728886642595; Sun, 13 Oct 2024
 23:17:22 -0700 (PDT)
Date: Sun, 13 Oct 2024 23:17:22 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <670cb772.050a0220.3e960.0056.GAE@google.com>
Subject: [syzbot] [ocfs2?] general protection fault in ocfs2_evict_inode
From: syzbot <syzbot+0058ba2149d0a0c61344@syzkaller.appspotmail.com>
To: jlbec@evilplan.org, joseph.qi@linux.alibaba.com, 
	linux-kernel@vger.kernel.org, mark@fasheh.com, ocfs2-devel@lists.linux.dev, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    33ce24234fca Add linux-next specific files for 20241008
git tree:       linux-next
console output: https://syzkaller.appspot.com/x/log.txt?x=14148f07980000
kernel config:  https://syzkaller.appspot.com/x/.config?x=4750ca93740b938d
dashboard link: https://syzkaller.appspot.com/bug?extid=0058ba2149d0a0c61344
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/ee8dc2df0c57/disk-33ce2423.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/dc473c0fa06e/vmlinux-33ce2423.xz
kernel image: https://storage.googleapis.com/syzbot-assets/4671f1ca2e61/bzImage-33ce2423.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+0058ba2149d0a0c61344@syzkaller.appspotmail.com

ocfs2: Unmounting device (7,4) on (node local)
Oops: general protection fault, probably for non-canonical address 0xdffffc0000000001: 0000 [#1] PREEMPT SMP KASAN PTI
KASAN: null-ptr-deref in range [0x0000000000000008-0x000000000000000f]
CPU: 1 UID: 0 PID: 11386 Comm: syz.4.712 Not tainted 6.12.0-rc2-next-20241008-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 09/13/2024
RIP: 0010:ocfs2_clear_inode fs/ocfs2/inode.c:1208 [inline]
RIP: 0010:ocfs2_evict_inode+0xdd3/0x4680 fs/ocfs2/inode.c:1220
Code: 00 00 4c 89 e0 48 c1 e8 03 42 80 3c 30 00 74 08 4c 89 e7 e8 5f 17 71 fe 4c 01 f3 4d 8b 24 24 49 83 c4 08 4c 89 e0 48 c1 e8 03 <42> 80 3c 30 00 74 08 4c 89 e7 e8 3e 17 71 fe 49 8b 3c 24 49 81 c7
RSP: 0018:ffffc9000349ef00 EFLAGS: 00010202
RAX: 0000000000000001 RBX: fffff52000693df4 RCX: ffff88802db11e00
RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000000
RBP: ffffc9000349f650 R08: ffffffff838d937e R09: 1ffff1100bf6f616
R10: dffffc0000000000 R11: ffffed100bf6f617 R12: 0000000000000008
R13: 1ffff1100bf6f644 R14: dffffc0000000000 R15: ffff88805fb7b338
FS:  0000000000000000(0000) GS:ffff8880b8700000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000021000000 CR3: 000000002dcfc000 CR4: 00000000003526f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 evict+0x4e8/0x9b0 fs/inode.c:808
 __ocfs2_free_slot_info fs/ocfs2/slot_map.c:307 [inline]
 ocfs2_free_slot_info+0x94/0x270 fs/ocfs2/slot_map.c:443
 ocfs2_delete_osb+0x58/0x180 fs/ocfs2/super.c:2497
 ocfs2_dismount_volume+0x594/0x8f0 fs/ocfs2/super.c:1936
 generic_shutdown_super+0x139/0x2d0 fs/super.c:642
 kill_block_super+0x44/0x90 fs/super.c:1696
 deactivate_locked_super+0xc4/0x130 fs/super.c:473
 cleanup_mnt+0x41f/0x4b0 fs/namespace.c:1373
 task_work_run+0x24f/0x310 kernel/task_work.c:228
 exit_task_work include/linux/task_work.h:40 [inline]
 do_exit+0xa2f/0x28e0 kernel/exit.c:939
 do_group_exit+0x207/0x2c0 kernel/exit.c:1088
 get_signal+0x16a3/0x1740 kernel/signal.c:2917
 arch_do_signal_or_restart+0x96/0x860 arch/x86/kernel/signal.c:337
 exit_to_user_mode_loop kernel/entry/common.c:111 [inline]
 exit_to_user_mode_prepare include/linux/entry-common.h:328 [inline]
 __syscall_exit_to_user_mode_work kernel/entry/common.c:207 [inline]
 syscall_exit_to_user_mode+0xc9/0x370 kernel/entry/common.c:218
 do_syscall_64+0x100/0x230 arch/x86/entry/common.c:89
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f581257dff9
Code: Unable to access opcode bytes at 0x7f581257dfcf.
RSP: 002b:00007f5813441038 EFLAGS: 00000246 ORIG_RAX: 0000000000000000
RAX: 0000000000ffecc0 RBX: 00007f5812735f80 RCX: 00007f581257dff9
RDX: 7706c522012798af RSI: 0000000020001340 RDI: 0000000000000005
RBP: 00007f58125f0296 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 0000000000000000 R14: 00007f5812735f80 R15: 00007ffd87bff1c8
 </TASK>
Modules linked in:
---[ end trace 0000000000000000 ]---
RIP: 0010:ocfs2_clear_inode fs/ocfs2/inode.c:1208 [inline]
RIP: 0010:ocfs2_evict_inode+0xdd3/0x4680 fs/ocfs2/inode.c:1220
Code: 00 00 4c 89 e0 48 c1 e8 03 42 80 3c 30 00 74 08 4c 89 e7 e8 5f 17 71 fe 4c 01 f3 4d 8b 24 24 49 83 c4 08 4c 89 e0 48 c1 e8 03 <42> 80 3c 30 00 74 08 4c 89 e7 e8 3e 17 71 fe 49 8b 3c 24 49 81 c7
RSP: 0018:ffffc9000349ef00 EFLAGS: 00010202
RAX: 0000000000000001 RBX: fffff52000693df4 RCX: ffff88802db11e00
RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000000
RBP: ffffc9000349f650 R08: ffffffff838d937e R09: 1ffff1100bf6f616
R10: dffffc0000000000 R11: ffffed100bf6f617 R12: 0000000000000008
R13: 1ffff1100bf6f644 R14: dffffc0000000000 R15: ffff88805fb7b338
FS:  0000000000000000(0000) GS:ffff8880b8700000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000021000000 CR3: 000000002dcfc000 CR4: 00000000003526f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
----------------
Code disassembly (best guess):
   0:	00 00                	add    %al,(%rax)
   2:	4c 89 e0             	mov    %r12,%rax
   5:	48 c1 e8 03          	shr    $0x3,%rax
   9:	42 80 3c 30 00       	cmpb   $0x0,(%rax,%r14,1)
   e:	74 08                	je     0x18
  10:	4c 89 e7             	mov    %r12,%rdi
  13:	e8 5f 17 71 fe       	call   0xfe711777
  18:	4c 01 f3             	add    %r14,%rbx
  1b:	4d 8b 24 24          	mov    (%r12),%r12
  1f:	49 83 c4 08          	add    $0x8,%r12
  23:	4c 89 e0             	mov    %r12,%rax
  26:	48 c1 e8 03          	shr    $0x3,%rax
* 2a:	42 80 3c 30 00       	cmpb   $0x0,(%rax,%r14,1) <-- trapping instruction
  2f:	74 08                	je     0x39
  31:	4c 89 e7             	mov    %r12,%rdi
  34:	e8 3e 17 71 fe       	call   0xfe711777
  39:	49 8b 3c 24          	mov    (%r12),%rdi
  3d:	49                   	rex.WB
  3e:	81                   	.byte 0x81
  3f:	c7                   	.byte 0xc7


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
