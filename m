Received: from mail-oa1-f80.google.com (mail-oa1-f80.google.com [209.85.160.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F97621CC71
	for <ocfs2-devel@lists.linux.dev>; Thu, 11 Dec 2025 06:22:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765434145; cv=none; b=eRWjxL1crxuy32fVppXM9w2/vffquJ2JkvxcNBzkPFS++m0G20TBUJLxLi9Lz24+v8F7HW5wnnwtmAaaebVyoRAGgX/gtGTvh9w3WFtvVxW1MBM6D4W+zpDdkorbgTk4Z8lWdHDpT7vNKjtZPEplR1Dc7aMa4ZexCDh9w5k5ex0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765434145; c=relaxed/simple;
	bh=/YiReAxBCpeWdRo3bAgvtKLPsDensEj5oTKPz94UIbg=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=O+rpYQf/cXVbEvwdNqf0fSo/Zu4saBSeVdPsT2XkfTDopHRlua6ZXo8omCiS7oux6BMq7nfQNpPWPbI1OKS1MFVP/zi6lk7nnluxNsEpxp6C/doHwsUybBVYhL1b48KWUzCpE4oowb2fc1ydKlHzJd/qXK1LftZz+JiUQpLSW0I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.160.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oa1-f80.google.com with SMTP id 586e51a60fabf-3f578b8136fso837437fac.0
        for <ocfs2-devel@lists.linux.dev>; Wed, 10 Dec 2025 22:22:23 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765434142; x=1766038942;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=SP9rduGqQqvyOFgqoix+vuKTjDQGXT/fswvFmZxXUFk=;
        b=ZWBi/pVi7ZIrn+IuOQ9NkRbNiwPdTjnbdTqmDXbsF7tx5QUqj2TTL/qpfwON0FR+q6
         VdIQIc8G5G5Uu1CyQBleGJD/f6K1XBGXuuue6TXyuWUI+4ByeRHOkPrqfYX8X0U8HN50
         cD106f7krdP61kHVxPJ5iZ97qI30qANRKnKGJvwMSmaknrtKlZI/r4wqH+C4IjIagx5q
         AcLYJcE9Iw4e67G2x7J8ZfTKCGUQrs68OvCkrRo3QWCCIElTWZBzjIMoSWDQCi9Ue7yl
         KG7djcW8+nKIl955gLGH8ZtbBpO7u4aGUS8QeArH0rlS+IfH72wUKLjxHJTF+1E4yi67
         5hsQ==
X-Forwarded-Encrypted: i=1; AJvYcCXiUNxCGFbN4xhNZFTg++KfimJZ3EwOQzFg4ieGXN0WLqae/trq8OjAVeA747wH/iDzEkKc99cLPOYDug==@lists.linux.dev
X-Gm-Message-State: AOJu0YzXljW73U3xqH5jqVKdPBTWznp3T9fOIsc6VnJBl3FidfJAQ/+o
	STVKcGU2NIFPai0v3r0ea0n+Z+8q8AeWgCE1K7BgUTC2xWB1BK4HS1NOwKtSA19l2yCvoYzh1Vy
	dC2lCAk/TklIzAj5dw1E1Wb81F9tlTs6YKgzbKDCAmUXMstLaninIre4FDD0=
X-Google-Smtp-Source: AGHT+IEmgVf+Fl6Do0mxfv1Qpm3U7SOdnWocUThAOoIUtE2ynxcuEQXfbhYJljDYIJSYm9gnsATPFXcTCiYO5TH5oTS9q3eO02vH
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6820:180f:b0:659:9a49:8f94 with SMTP id
 006d021491bc7-65b2abc1776mr3075999eaf.13.1765434142736; Wed, 10 Dec 2025
 22:22:22 -0800 (PST)
Date: Wed, 10 Dec 2025 22:22:22 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <693a631e.a70a0220.33cd7b.0027.GAE@google.com>
Subject: [syzbot] [ocfs2?] UBSAN: array-index-out-of-bounds in ocfs2_xa_remove_entry
From: syzbot <syzbot+cf96bc82a588a27346a8@syzkaller.appspotmail.com>
To: jlbec@evilplan.org, joseph.qi@linux.alibaba.com, 
	linux-kernel@vger.kernel.org, mark@fasheh.com, ocfs2-devel@lists.linux.dev, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    c2f2b01b74be Merge tag 'i3c/for-6.19' of git://git.kernel...
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=11a4eeb4580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=cf15a4b50e1152e3
dashboard link: https://syzkaller.appspot.com/bug?extid=cf96bc82a588a27346a8
compiler:       Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~exp1~20250708183702.136), Debian LLD 20.1.8
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=16e89992580000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=15a4eeb4580000

Downloadable assets:
disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/d900f083ada3/non_bootable_disk-c2f2b01b.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/753c2b596a8a/vmlinux-c2f2b01b.xz
kernel image: https://storage.googleapis.com/syzbot-assets/9e3ad31aad53/bzImage-c2f2b01b.xz
mounted in repro #1: https://storage.googleapis.com/syzbot-assets/befacb04d20d/mount_0.gz
  fsck result: OK (log: https://syzkaller.appspot.com/x/fsck.log?x=12e89992580000)
mounted in repro #2: https://storage.googleapis.com/syzbot-assets/08da0e96bc06/mount_4.gz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+cf96bc82a588a27346a8@syzkaller.appspotmail.com

=======================================================
JBD2: Ignoring recovery information on journal
ocfs2: Mounting device (7,0) on (node local, slot 0) with ordered data mode.
------------[ cut here ]------------
UBSAN: array-index-out-of-bounds in fs/ocfs2/xattr.c:1955:3
index 2 is out of range for type 'struct ocfs2_xattr_entry[] __counted_by(xh_count)' (aka 'struct ocfs2_xattr_entry[]')
CPU: 0 UID: 0 PID: 5508 Comm: syz.0.17 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2~bpo12+1 04/01/2014
Call Trace:
 <TASK>
 dump_stack_lvl+0x189/0x250 lib/dump_stack.c:120
 ubsan_epilogue+0xa/0x40 lib/ubsan.c:233
 __ubsan_handle_out_of_bounds+0xe9/0xf0 lib/ubsan.c:455
 ocfs2_xa_remove_entry+0x36d/0x3e0 fs/ocfs2/xattr.c:1955
 ocfs2_xa_remove fs/ocfs2/xattr.c:2043 [inline]
 ocfs2_xa_set+0xaf4/0x2a70 fs/ocfs2/xattr.c:2247
 ocfs2_xattr_block_set+0x3ca/0x31b0 fs/ocfs2/xattr.c:2985
 __ocfs2_xattr_set_handle+0x27e/0xf20 fs/ocfs2/xattr.c:-1
 ocfs2_xattr_set+0xde8/0x11f0 fs/ocfs2/xattr.c:3650
 __vfs_removexattr+0x431/0x470 fs/xattr.c:518
 __vfs_removexattr_locked+0x1e8/0x230 fs/xattr.c:553
 vfs_removexattr+0x80/0x1b0 fs/xattr.c:575
 removexattr fs/xattr.c:1023 [inline]
 filename_removexattr fs/xattr.c:1052 [inline]
 path_removexattrat+0x35d/0x690 fs/xattr.c:1088
 __do_sys_lremovexattr fs/xattr.c:1106 [inline]
 __se_sys_lremovexattr fs/xattr.c:1103 [inline]
 __x64_sys_lremovexattr+0x65/0x80 fs/xattr.c:1103
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0xfa/0xf80 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f65fcd8f7c9
Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 a8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007ffc4fa4bdb8 EFLAGS: 00000246 ORIG_RAX: 00000000000000c6
RAX: ffffffffffffffda RBX: 00007f65fcfe5fa0 RCX: 00007f65fcd8f7c9
RDX: 0000000000000000 RSI: 0000200000000280 RDI: 0000200000000240
RBP: 00007f65fce13f91 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007f65fcfe5fa0 R14: 00007f65fcfe5fa0 R15: 0000000000000002
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
