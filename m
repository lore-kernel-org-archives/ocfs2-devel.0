Received: from mail-io1-f79.google.com (mail-io1-f79.google.com [209.85.166.79])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 216D685931
	for <ocfs2-devel@lists.linux.dev>; Sat, 15 Feb 2025 09:37:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.79
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739612239; cv=none; b=IzBOKAZfckckzYCZXc1yvv7raint2fcYbl8k3aLM/kyzONw4VcOJJeF5jFnEtzGO9spfaujZ3Kd+l8yU+xocRClidZdOSpf0jIPioTF64CQWsQzmZtLN8JK3pVJWHg4VKmTnAdjGdHjQuZrdi7Iv4poKBycCNtbt4hIh6Ub3pDk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739612239; c=relaxed/simple;
	bh=3AzwmXcD3iuQEmGVWfjJ1uHDGGBLkKMivcxDdXv8SRM=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=rYZfd17wIsLT9t6PgSiuaNUi5HSg/hnTCJ3FB2o72xzkGLYtq4l4fXCmz0NzkxtAQLH4vl57o3QMqBVMGyhBJz9PTUqwDtpM9Seqpq04g8Q9slINMSXI2KULNqDUo+CmQJ9wKJKtu3xGBgnZBv6r4dwwVBdkO6IL1lv5bp7bOfM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.79
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-io1-f79.google.com with SMTP id ca18e2360f4ac-85570fc35baso249595039f.0
        for <ocfs2-devel@lists.linux.dev>; Sat, 15 Feb 2025 01:37:17 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739612237; x=1740217037;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=fylukBOBK7wL2ZFCB5U55A14uFCcqh305hge2cYCo5w=;
        b=wes1z01JqkMXepqeeE/LB9ypPA0Vqmw3GbR5fNpe0z5Pbv1b6pxTwcGmQccCAd7xvg
         fGvlOcSiFxjQ9SEYjAbhJNkYm4BfxhHVXS1du0hEpqeZ9t18E53Wn7YxuT7X2dBKUO3p
         G9EepZSGNYRoa9YGFJ/aP0NbkWwtVtA48lI/K1bKPzmZ5cZOTzjFbsY9ttWjbZvJwgB2
         IlZSKv/Issp2poJLCTqluItdd35XIV9xe/tOtW1pnfP9t1kcfnhbcGUEibetGqf6rENY
         TJ+px7Ln7HpoPywF50xivku9mS1/y3QzcjnSmwWj/gw31uhhXG4siGyCeT3evoO1d88r
         DWNw==
X-Forwarded-Encrypted: i=1; AJvYcCVPNthH8JlixbwVAMVaD7mNx0IKUiCn8Mdr8zqEjjK5VD2wakN8rKc4jn6+R3ACFaeMCDUzRitBFqX7DA==@lists.linux.dev
X-Gm-Message-State: AOJu0YxllRgb9v30AB6xh0Iw5rUXoM3Zd9bn1+Vlkym0yy7utNxzS0cE
	Bz0VpEXYKGABmOWKGqcRqrK9RtkaqCqBYaPe5RJ5RedaSEu/MDIlM5wqEWgxOTFstBPtH0RGXh1
	SCiuFTwO39IWgk4PbMFz67Vqs1GfISxqnsW/K24R4AwSrCHukpBm58jo=
X-Google-Smtp-Source: AGHT+IE3sS6XPLtYwB1G604NGyg49j5MIjRpQYfSZTxEjvuHfkyYbUaorI9kzK/G0L1fGKzBPijpR5AXtGdtwO1A3kdrO6ZiTNWT
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1fc3:b0:3d1:9236:ca4b with SMTP id
 e9e14a558f8ab-3d2807b900amr17275845ab.8.1739612237142; Sat, 15 Feb 2025
 01:37:17 -0800 (PST)
Date: Sat, 15 Feb 2025 01:37:17 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <67b0604d.050a0220.47157.0004.GAE@google.com>
Subject: [syzbot] [ocfs2?] divide error in ocfs2_block_group_fill
From: syzbot <syzbot+e41e83af7a07a4df8051@syzkaller.appspotmail.com>
To: jlbec@evilplan.org, joseph.qi@linux.alibaba.com, 
	linux-kernel@vger.kernel.org, mark@fasheh.com, ocfs2-devel@lists.linux.dev, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    febbc555cf0f Merge tag 'nfsd-6.14-1' of git://git.kernel.o..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=14f678e4580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=3c2347dd6174fbe2
dashboard link: https://syzkaller.appspot.com/bug?extid=e41e83af7a07a4df8051
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/7feb34a89c2a/non_bootable_disk-febbc555.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/b3f419dfe94d/vmlinux-febbc555.xz
kernel image: https://storage.googleapis.com/syzbot-assets/6e1814568eab/bzImage-febbc555.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+e41e83af7a07a4df8051@syzkaller.appspotmail.com

loop0: detected capacity change from 0 to 32768
=======================================================
WARNING: The mand mount option has been deprecated and
         and is ignored by this kernel. Remove the mand
         option from the mount to silence this warning.
=======================================================
JBD2: Ignoring recovery information on journal
ocfs2: Mounting device (7,0) on (node local, slot 0) with ordered data mode.
Oops: divide error: 0000 [#1] PREEMPT SMP KASAN NOPTI
CPU: 0 UID: 0 PID: 5324 Comm: syz.0.0 Not tainted 6.14.0-rc2-syzkaller-00034-gfebbc555cf0f #0
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2~bpo12+1 04/01/2014
RIP: 0010:ocfs2_bg_discontig_add_extent fs/ocfs2/suballoc.c:335 [inline]
RIP: 0010:ocfs2_block_group_fill+0x5fa/0xbe0 fs/ocfs2/suballoc.c:386
Code: 00 4f 8d b4 35 50 01 00 00 45 0f b7 20 48 83 c6 02 49 89 f7 49 c1 ef 03 41 0f b6 04 3f 84 c0 0f 85 6e 04 00 00 44 89 e0 31 d2 <66> f7 36 0f b7 d8 4c 89 f0 48 c1 e8 03 0f b6 04 38 84 c0 0f 85 8e
RSP: 0018:ffffc9000d24ec20 EFLAGS: 00010246
RAX: 0000000000000000 RBX: ffff8880551e0158 RCX: 0000000000100000
RDX: 0000000000000000 RSI: ffff88804052a2c2 RDI: dffffc0000000000
RBP: ffffc9000d24ed28 R08: ffff8880551e000a R09: 1ffff1100aa3c001
R10: ffff8880551e0000 R11: ffffed100aa3c040 R12: 0000000000000000
R13: ffff8880551e0000 R14: ffff8880551e0150 R15: 1ffff110080a5458
FS:  00007f2117db36c0(0000) GS:ffff88801fc00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f210bdff000 CR3: 00000000402e4000 CR4: 0000000000352ef0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 ocfs2_block_group_alloc_discontig fs/ocfs2/suballoc.c:634 [inline]
 ocfs2_block_group_alloc fs/ocfs2/suballoc.c:702 [inline]
 ocfs2_reserve_suballoc_bits+0x2358/0x4e70 fs/ocfs2/suballoc.c:832
 ocfs2_reserve_new_metadata_blocks+0x41c/0x9c0 fs/ocfs2/suballoc.c:982
 ocfs2_init_xattr_set_ctxt+0x3a6/0x8e0 fs/ocfs2/xattr.c:3277
 ocfs2_xattr_set+0xf4e/0x1930 fs/ocfs2/xattr.c:3634
 __vfs_setxattr+0x468/0x4a0 fs/xattr.c:200
 __vfs_setxattr_noperm+0x12e/0x660 fs/xattr.c:234
 vfs_setxattr+0x221/0x430 fs/xattr.c:321
 do_setxattr fs/xattr.c:636 [inline]
 filename_setxattr+0x2af/0x430 fs/xattr.c:665
 path_setxattrat+0x440/0x510 fs/xattr.c:713
 __do_sys_setxattr fs/xattr.c:747 [inline]
 __se_sys_setxattr fs/xattr.c:743 [inline]
 __x64_sys_setxattr+0xbc/0xe0 fs/xattr.c:743
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f2116f8cde9
Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 a8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f2117db3038 EFLAGS: 00000246 ORIG_RAX: 00000000000000bc
RAX: ffffffffffffffda RBX: 00007f21171a5fa0 RCX: 00007f2116f8cde9
RDX: 0000000000000000 RSI: 00004000000003c0 RDI: 0000400000000180
RBP: 00007f211700e2a0 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 0000000000000000 R14: 00007f21171a5fa0 R15: 00007ffd982bc2e8
 </TASK>
Modules linked in:
---[ end trace 0000000000000000 ]---
RIP: 0010:ocfs2_bg_discontig_add_extent fs/ocfs2/suballoc.c:335 [inline]
RIP: 0010:ocfs2_block_group_fill+0x5fa/0xbe0 fs/ocfs2/suballoc.c:386
Code: 00 4f 8d b4 35 50 01 00 00 45 0f b7 20 48 83 c6 02 49 89 f7 49 c1 ef 03 41 0f b6 04 3f 84 c0 0f 85 6e 04 00 00 44 89 e0 31 d2 <66> f7 36 0f b7 d8 4c 89 f0 48 c1 e8 03 0f b6 04 38 84 c0 0f 85 8e
RSP: 0018:ffffc9000d24ec20 EFLAGS: 00010246
RAX: 0000000000000000 RBX: ffff8880551e0158 RCX: 0000000000100000
RDX: 0000000000000000 RSI: ffff88804052a2c2 RDI: dffffc0000000000
RBP: ffffc9000d24ed28 R08: ffff8880551e000a R09: 1ffff1100aa3c001
R10: ffff8880551e0000 R11: ffffed100aa3c040 R12: 0000000000000000
R13: ffff8880551e0000 R14: ffff8880551e0150 R15: 1ffff110080a5458
FS:  00007f2117db36c0(0000) GS:ffff88801fc00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f210bc7c000 CR3: 00000000402e4000 CR4: 0000000000352ef0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
----------------
Code disassembly (best guess):
   0:	00 4f 8d             	add    %cl,-0x73(%rdi)
   3:	b4 35                	mov    $0x35,%ah
   5:	50                   	push   %rax
   6:	01 00                	add    %eax,(%rax)
   8:	00 45 0f             	add    %al,0xf(%rbp)
   b:	b7 20                	mov    $0x20,%bh
   d:	48 83 c6 02          	add    $0x2,%rsi
  11:	49 89 f7             	mov    %rsi,%r15
  14:	49 c1 ef 03          	shr    $0x3,%r15
  18:	41 0f b6 04 3f       	movzbl (%r15,%rdi,1),%eax
  1d:	84 c0                	test   %al,%al
  1f:	0f 85 6e 04 00 00    	jne    0x493
  25:	44 89 e0             	mov    %r12d,%eax
  28:	31 d2                	xor    %edx,%edx
* 2a:	66 f7 36             	divw   (%rsi) <-- trapping instruction
  2d:	0f b7 d8             	movzwl %ax,%ebx
  30:	4c 89 f0             	mov    %r14,%rax
  33:	48 c1 e8 03          	shr    $0x3,%rax
  37:	0f b6 04 38          	movzbl (%rax,%rdi,1),%eax
  3b:	84 c0                	test   %al,%al
  3d:	0f                   	.byte 0xf
  3e:	85                   	.byte 0x85
  3f:	8e                   	.byte 0x8e


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
