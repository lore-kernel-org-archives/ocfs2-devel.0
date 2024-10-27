Received: from mail-il1-f197.google.com (mail-il1-f197.google.com [209.85.166.197])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD3DD801
	for <ocfs2-devel@lists.linux.dev>; Sun, 27 Oct 2024 00:25:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.197
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729988747; cv=none; b=nlmKcTjRxmCgMxUKDKFKks/4ze1Wnccq8efZYHK5hIUtPr/XCR81ZhjynQP0AwGJ50pB/SgOwxLJ0YU9aAqZeYsuWfXMper0Z56P6epaQUgmBLU/O+kv9LKWP507bKtLBB0MaLn06oc/VvAvYEjVGKroW72+yVotYJHhd5FU29g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729988747; c=relaxed/simple;
	bh=/Dz0/d5w67CSdo3+dmDTCiDWI/7BiZScEDMO4L/XjYg=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=Ykk/qd12m6Jt9r+xSLsqWrUi91NDuCoLlQOuDfENMHx8FCPfejUxKHdNl0p+JByJ4LRf3iwWHgRCiUjXGHihBGMYRdjMJkOZECw97IOuk7CgNTTa4+F1cC9tIa9BqCZFlvSUD3Ufhh0Kn1VdU4yZt9mcuY5MGAeZGpY5zitPkCI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.197
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f197.google.com with SMTP id e9e14a558f8ab-3a4f113d2c8so6052215ab.1
        for <ocfs2-devel@lists.linux.dev>; Sat, 26 Oct 2024 17:25:44 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729988744; x=1730593544;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=/wPn9P5b5vRdI9Ux1xI18zAb0ubyp9U/n0ZDH/tkeYQ=;
        b=aT+z0XaCCCAEsWCPHKe+QADUm4BopxSwZFYzBIStOQUfp5Ko1xHMwtDU9VeT1L8oWy
         ESpoqHiNqXEv4p8/537jIsB0yeoR8/VC0g62vKfZdkHkh2cVttxo4iK1MYR0X/mpUg1b
         YgZOnTRiX3171AYi6GfOnP0cVn5b1/+/rh6aBIit13DNWRsJHB0NhB+mpzT3PsXlvkPz
         dL1l+B9LYVAei5p66kyfy3gYRJ8ALGD3ZMooqhxEv2TcUB8qgN1V/F5D4j0wt7WRbROH
         +pE5DAxQl5BtGYmeCim6yMYHhmkGAwTqXCtAXG57WmLXE/VczaWZID2fzjG4CH+LRB9T
         v44g==
X-Forwarded-Encrypted: i=1; AJvYcCWqOWT1kYWAeAyjdcVi+zxk6pSW0uBSf+BScqX4Ifq5RB0Nh9BTSkWpkiRzfRaR0w9/jtoHUv+Ao2g2Fw==@lists.linux.dev
X-Gm-Message-State: AOJu0YxNpH/uUNq/bZ1VIdRSp0UYmKZ1Bs+qwKqrDQcHZofkEsy7ZM/h
	GuN3uLPkuF6HN6VDq4pW92tomSDpIg4wS17A+W6ELTMEH4MrKNFapYNTixm3K1+y7erpxgNcDuK
	3lY1JvYfo6hirqm9bWhk7teLRzrZ5CkShyTeteZjwMroiLCUjNroPo48=
X-Google-Smtp-Source: AGHT+IFKz3qq5JWqjtEfBzq7Yotyr0psAF60CECWfQOLXUndQt09QTmYffuM9gK/Jslc3fAXndx4+oF32trZS5T/ODSraA1sWCel
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1606:b0:39b:3894:9298 with SMTP id
 e9e14a558f8ab-3a4ed1bd7demr37436595ab.0.1729988743946; Sat, 26 Oct 2024
 17:25:43 -0700 (PDT)
Date: Sat, 26 Oct 2024 17:25:43 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <671d8887.050a0220.2fdf0c.0230.GAE@google.com>
Subject: [syzbot] [ocfs2?] UBSAN: shift-out-of-bounds in ocfs2_fill_super (2)
From: syzbot <syzbot+56f7cd1abe4b8e475180@syzkaller.appspotmail.com>
To: jlbec@evilplan.org, joseph.qi@linux.alibaba.com, 
	linux-kernel@vger.kernel.org, mark@fasheh.com, ocfs2-devel@lists.linux.dev, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    c2ee9f594da8 KVM: selftests: Fix build on on non-x86 archi..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=14008c30580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=fc6f8ce8c5369043
dashboard link: https://syzkaller.appspot.com/bug?extid=56f7cd1abe4b8e475180
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=16ced0a7980000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=12008c30580000

Downloadable assets:
disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/7feb34a89c2a/non_bootable_disk-c2ee9f59.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/8a3541902b13/vmlinux-c2ee9f59.xz
kernel image: https://storage.googleapis.com/syzbot-assets/a00efacc2604/bzImage-c2ee9f59.xz
mounted in repro: https://storage.googleapis.com/syzbot-assets/4065d12afe1f/mount_0.gz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+56f7cd1abe4b8e475180@syzkaller.appspotmail.com

WARNING: The mand mount option has been deprecated and
         and is ignored by this kernel. Remove the mand
         option from the mount to silence this warning.
=======================================================
------------[ cut here ]------------
UBSAN: shift-out-of-bounds in fs/ocfs2/super.c:2336:10
shift exponent 32768 is too large for 32-bit type 'int'
CPU: 0 UID: 0 PID: 5093 Comm: syz-executor204 Not tainted 6.12.0-rc4-syzkaller-00047-gc2ee9f594da8 #0
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2~bpo12+1 04/01/2014
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:94 [inline]
 dump_stack_lvl+0x241/0x360 lib/dump_stack.c:120
 ubsan_epilogue lib/ubsan.c:231 [inline]
 __ubsan_handle_shift_out_of_bounds+0x3c8/0x420 lib/ubsan.c:468
 ocfs2_verify_volume fs/ocfs2/super.c:2336 [inline]
 ocfs2_sb_probe fs/ocfs2/super.c:792 [inline]
 ocfs2_fill_super+0xf9c/0x5750 fs/ocfs2/super.c:988
 mount_bdev+0x20a/0x2d0 fs/super.c:1679
 legacy_get_tree+0xee/0x190 fs/fs_context.c:662
 vfs_get_tree+0x90/0x2b0 fs/super.c:1800
 do_new_mount+0x2be/0xb40 fs/namespace.c:3507
 do_mount fs/namespace.c:3847 [inline]
 __do_sys_mount fs/namespace.c:4057 [inline]
 __se_sys_mount+0x2d6/0x3c0 fs/namespace.c:4034
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f8c48e89c7a
Code: d8 64 89 02 48 c7 c0 ff ff ff ff eb a6 e8 5e 04 00 00 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 49 89 ca b8 a5 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 b8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007ffd10baf0f8 EFLAGS: 00000282 ORIG_RAX: 00000000000000a5
RAX: ffffffffffffffda RBX: 00007ffd10baf110 RCX: 00007f8c48e89c7a
RDX: 00000000200002c0 RSI: 0000000020000040 RDI: 00007ffd10baf110
RBP: 0000000000000004 R08: 00007ffd10baf150 R09: 0000000000004434
R10: 00000000000008c0 R11: 0000000000000282 R12: 00000000000008c0
R13: 00007ffd10baf150 R14: 0000000000000003 R15: 0000000001000000
 </TASK>
---[ end trace ]---


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
