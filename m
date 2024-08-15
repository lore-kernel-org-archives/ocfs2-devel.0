Received: from mail-io1-f72.google.com (mail-io1-f72.google.com [209.85.166.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D9941B4C37
	for <ocfs2-devel@lists.linux.dev>; Thu, 15 Aug 2024 10:46:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723718788; cv=none; b=Wl5PKJDz1B0T7od7VRLsh4OYIAEcPiFDBOkZt4PQRTam+JMsAGk57CGvRNskf6/TOOSU+H5kMS3AvATtfQ+GgL02jEekQKmOq1rsi5gXfV+GVlVyGJERc9090l9kR+HUC1ATFnXjV8+sgs9Vc9KsdtrXG7lQZWaQRadEsUFQKjQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723718788; c=relaxed/simple;
	bh=c7H502c81o4LmverflfTO3Cf2DRPwhDQEorcflpL/xM=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=ZQDa5SQcabiOOhWyKLJ6iYDoaYSiaFWU/LlNWOKNuFnfu6JPIfxCIjAgICwiJQjdltdQ9fQcOR8KvuN+QAGoPB9w60PNN04T4MGV7WuaGMuE0YjT49vAqlj6ys+Ql8ynJsJvJEhZuNCS7XSaWGQXbCoF5Tu01znNqMvJCn3OkUc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-io1-f72.google.com with SMTP id ca18e2360f4ac-81f7fa42463so64803639f.0
        for <ocfs2-devel@lists.linux.dev>; Thu, 15 Aug 2024 03:46:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723718785; x=1724323585;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=6wWXZ+YGI3S/Aen/Sa9rxJMB/xMGw92Rgd9XQXXyKh0=;
        b=mlHV7wTrKMw5at6QQ+1gL6dHxuAR02jhojJ+yMPbze1unKHwQmFyuUL8jGUN9tMx1A
         ASui3L+0kb7ohks47dAzI54kpoObYYM85hy7WgA+22xESpjbbaJolabjFRKV0A0xExZG
         3ZPW0niSt52nzzrXThppi6QlSvk1/sQCuDzgnIuYefDpGJ+S/tvpZYL5dKo0psJCv+rg
         hZMcGVHn2sbRaIqlbEefR0pKharasY3Kt+blSRpCurNTy5HTUybPva2zvBpqpIGZhnEC
         95yWJnGT+d09uVmAlFnr3VJ1e/xTCYOwMvAos6vAiKUgIJ0Gs35NaT/3d8lrfLMWekZW
         4hLw==
X-Forwarded-Encrypted: i=1; AJvYcCXnyWrCTY1w3YdyF4muKq4g15U+8IgOMGW7QF4V90Haasb8paL1M/nScQVp+rpL7JDLgsNCmBsA+lAwClnHjfl+8YwyYIQ2iyUPf1E=
X-Gm-Message-State: AOJu0YzlHAerzku5mmClKvv6g93VXcVyl57n4apqwPZAf0iV8ZBvEyfG
	wMXAe7X4fo+OqWvqGeP1z1pCKczK/m0FdZu9pcdt22tMwbFpXdhtdGcqWfHYQe4wG7InT5aI/GE
	tWIjST9LAkYj2u4U/hmrmqLRxx8AJcI5zAXSOakO9fkCwdqUiBC3wxm4=
X-Google-Smtp-Source: AGHT+IFTnXu0yz178Bw9SmIihWC0Am4mDjD79uJ2+BHVh9oaQnyOEsE8FqHcdaEVhD7+SoeLtL3QF1PSHyCri7VAxpYaIXpr+r5T
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:2181:b0:39b:c00:85aa with SMTP id
 e9e14a558f8ab-39d1bd3bb90mr1591745ab.0.1723718785450; Thu, 15 Aug 2024
 03:46:25 -0700 (PDT)
Date: Thu, 15 Aug 2024 03:46:25 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000e64ead061fb68def@google.com>
Subject: [syzbot] [ocfs2?] UBSAN: shift-out-of-bounds in ocfs2_fill_super
From: syzbot <syzbot+f3fff775402751ebb471@syzkaller.appspotmail.com>
To: jlbec@evilplan.org, joseph.qi@linux.alibaba.com, 
	linux-kernel@vger.kernel.org, mark@fasheh.com, ocfs2-devel@lists.linux.dev, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    d07b43284ab3 Merge tag 'for-linus' of git://git.kernel.org..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=1397f4fd980000
kernel config:  https://syzkaller.appspot.com/x/.config?x=7229118d88b4a71b
dashboard link: https://syzkaller.appspot.com/bug?extid=f3fff775402751ebb471
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1306b191980000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=11905bd3980000

Downloadable assets:
disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/7bc7510fe41f/non_bootable_disk-d07b4328.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/91ceec6e19d3/vmlinux-d07b4328.xz
kernel image: https://storage.googleapis.com/syzbot-assets/be11646b0c05/bzImage-d07b4328.xz
mounted in repro: https://storage.googleapis.com/syzbot-assets/0847e1dfc637/mount_0.gz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+f3fff775402751ebb471@syzkaller.appspotmail.com

loop0: detected capacity change from 0 to 32768
------------[ cut here ]------------
UBSAN: shift-out-of-bounds in fs/ocfs2/super.c:2360:4
shift exponent 1548 is too large for 32-bit type 'int'
CPU: 0 UID: 0 PID: 5093 Comm: syz-executor251 Not tainted 6.11.0-rc3-syzkaller-00060-gd07b43284ab3 #0
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2~bpo12+1 04/01/2014
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:93 [inline]
 dump_stack_lvl+0x241/0x360 lib/dump_stack.c:119
 ubsan_epilogue lib/ubsan.c:231 [inline]
 __ubsan_handle_shift_out_of_bounds+0x3c8/0x420 lib/ubsan.c:468
 ocfs2_verify_volume fs/ocfs2/super.c:2360 [inline]
 ocfs2_sb_probe fs/ocfs2/super.c:792 [inline]
 ocfs2_fill_super+0x106e/0x5880 fs/ocfs2/super.c:988
 mount_bdev+0x20a/0x2d0 fs/super.c:1679
 legacy_get_tree+0xee/0x190 fs/fs_context.c:662
 vfs_get_tree+0x90/0x2a0 fs/super.c:1800
 do_new_mount+0x2be/0xb40 fs/namespace.c:3472
 do_mount fs/namespace.c:3812 [inline]
 __do_sys_mount fs/namespace.c:4020 [inline]
 __se_sys_mount+0x2d6/0x3c0 fs/namespace.c:3997
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f76bb986dea
Code: d8 64 89 02 48 c7 c0 ff ff ff ff eb a6 e8 5e 04 00 00 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 49 89 ca b8 a5 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 b8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007ffe83d62948 EFLAGS: 00000282 ORIG_RAX: 00000000000000a5
RAX: ffffffffffffffda RBX: 00007ffe83d62960 RCX: 00007f76bb986dea
RDX: 0000000020004480 RSI: 00000000200044c0 RDI: 00007ffe83d62960
RBP: 0000000000000004 R08: 00007ffe83d629a0 R09: 000000000000446c
R10: 0000000002800400 R11: 0000000000000282 R12: 0000000002800400
R13: 00007ffe83d629a0 R14: 0000000000000003 R15: 0000000001000000
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
