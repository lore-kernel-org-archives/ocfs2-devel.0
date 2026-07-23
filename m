Received: from mail-oi1-f205.google.com (mail-oi1-f205.google.com [209.85.167.205])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A74C23655CE
	for <ocfs2-devel@lists.linux.dev>; Thu, 23 Jul 2026 07:48:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.205
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784792918; cv=none; b=R0EXilFzGfmw7Sj7It3+cAI+t13yIkAfoFHAsygaWI+Q1cjL/9wkeG/f2u3cBs5ql+6tBM83m6hk18Bdn0Eb8LS0ogIKySUoXuvmZRX3gbmKX5oAjJnNSkTWb0oupPivulGDuNoK9KvCbKQ+XUDpEt8vS/MdhGPX0JkGyBmk4Bo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784792918; c=relaxed/simple;
	bh=HOSzlMbhKgCv0I52AS+IR3w18Qhf+7mjen1aa73eGlU=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=E+xLHhn5XSUWsBIVA0R7C8rHMuku4zk2X93TCp2s7stuJnJZM7U753WnCykcKhBnr1qmcJSExHORdv7R7bvVKUFSyrQ0Cl5W4D5L7uTyt5o6Pc+Pv1OU8xGok0lmn3O2kynpXZnyUZwGcH6+rKe5VH1x3c1HO1R6co9vjFa81kA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.167.205
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oi1-f205.google.com with SMTP id 5614622812f47-495f637105eso515922b6e.2
        for <ocfs2-devel@lists.linux.dev>; Thu, 23 Jul 2026 00:48:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784792915; x=1785397715;
        h=content-type:to:from:subject:message-id:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=/VVWvwcmfPleJGHbn0WwR04ZH2r/GqSFRjT4zKIARNg=;
        b=jGApbSBmP9Yit+/h7ryrWSW/32xuN88S/+JrU3BR0klNc5+7i4JxjVacSQbldO3qu2
         6QhUoVnXelfZrTs4v/WD+90czB+kOH0g8vA8AhrN2fuP6z7toESDmuHmwt4JeRUMRsP+
         2w0hz6uw/6CmuMmZ2LPQbK4W5tKYhWrtDRELu60cGKRhW0g1JwQbnya4MKVdLBkXsdbJ
         YNOBOumv81i4mWM0/QnsS3g/Aw1CKoG4U7HGCPMnD98Wj/5S52/s/yacYfTWjNbI09tf
         DSCkDCvbA+/W98WsZk0iaiFqwsv0Bk4TI3Gt0FuOomNLoj8ADo2lzXwmPoPivNjpo7WH
         3W8A==
X-Forwarded-Encrypted: i=1; AHgh+RqngmsoPpCMEnx02kjLI0rR0Mmt6vrRN7JLQNyw16Pe0tSt/CQKyJSZaKk3weLrwiqnkRX4eFscPmvQUA==@lists.linux.dev
X-Gm-Message-State: AOJu0YxflD2spoGkLamXkALZgPoeqjngmhaBeOkmO1K3T6tpWjIGHHFr
	9A/zmPRhqaFqAsgtWQzEptOSju+8znAxtod76EtjCTjtMAuXAYMlpJAiu/oVRu+C5HsIlKEBGzm
	HTxcA9UgwSVbzxWq507tt72Y5dQWljjG/6WiInx8b0XXegjjq5NURubp/8LI=
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6808:1705:b0:493:e2bb:2eaf with SMTP id
 5614622812f47-4ab3560c757mr979372b6e.39.1784792915525; Thu, 23 Jul 2026
 00:48:35 -0700 (PDT)
Date: Thu, 23 Jul 2026 00:48:35 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6a61c753.4c7b7f70.2b0f85.0001.GAE@google.com>
Subject: [syzbot] [ocfs2?] kernel BUG in ocfs2_xattr_value_truncate (3)
From: syzbot <syzbot+1542b94cc3d81b71110d@syzkaller.appspotmail.com>
To: jlbec@evilplan.org, joseph.qi@linux.alibaba.com, 
	linux-kernel@vger.kernel.org, mark@fasheh.com, ocfs2-devel@lists.linux.dev, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    f2ec6312bf71 Merge tag 'scsi-fixes' of git://git.kernel.or..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=12cb5789580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=20c9876b0f77b546
dashboard link: https://syzkaller.appspot.com/bug?extid=1542b94cc3d81b71110d
compiler:       Debian clang version 22.1.8 (++20260613092233+e80beda6e255-1~exp1~20260613092250.77), Debian LLD 22.1.8

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/d900f083ada3/non_bootable_disk-f2ec6312.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/89734a3b39bd/vmlinux-f2ec6312.xz
kernel image: https://storage.googleapis.com/syzbot-assets/48a3e1cd63f9/bzImage-f2ec6312.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+1542b94cc3d81b71110d@syzkaller.appspotmail.com

loop0: detected capacity change from 0 to 32768
=======================================================
WARNING: The mand mount option has been deprecated and
         and is ignored by this kernel. Remove the mand
         option from the mount to silence this warning.
=======================================================
JBD2: Ignoring recovery information on journal
ocfs2: Mounting device (7,0) on (node local, slot 0) with ordered data mode.
(syz.0.0,5327,0):ocfs2_dio_end_io:2420 ERROR: Direct IO failed, bytes = -28
------------[ cut here ]------------
kernel BUG at fs/ocfs2/xattr.c:747!
Oops: invalid opcode: 0000 [#1] SMP KASAN NOPTI
CPU: 0 UID: 0 PID: 5327 Comm: syz.0.0 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
RIP: 0010:ocfs2_xattr_extend_allocation fs/ocfs2/xattr.c:747 [inline]
RIP: 0010:ocfs2_xattr_value_truncate+0x1738/0x1740 fs/ocfs2/xattr.c:868
Code: 44 89 f1 80 e1 07 80 c1 03 38 c1 0f 8c be eb ff ff 4c 89 f7 48 89 f3 e8 d6 44 3d fe 48 89 de e9 ab eb ff ff e8 c9 19 ce fd 90 <0f> 0b 66 0f 1f 44 00 00 90 90 90 90 90 90 90 90 90 90 90 90 90 90
RSP: 0018:ffffc9000f78e940 EFLAGS: 00010283
RAX: ffffffff83f86807 RBX: 0000000000000002 RCX: 0000000000100000
RDX: ffffc9000ee51000 RSI: 0000000000001097 RDI: 0000000000001098
RBP: ffffc9000f78ec70 R08: ffff888000ec2540 R09: 0000000000000006
R10: 00000000fffffffc R11: 0000000000000002 R12: fffff52001ef1d3c
R13: 0000000000000002 R14: 00000000fffffff5 R15: ffff88805486a5d0
FS:  00007f4b34b836c0(0000) GS:ffff88808c549000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 000020000000f000 CR3: 0000000040786000 CR4: 0000000000352ef0
Call Trace:
 <TASK>
 ocfs2_xa_value_truncate+0x2d6/0x420 fs/ocfs2/xattr.c:1956
 ocfs2_xa_prepare_entry fs/ocfs2/xattr.c:2215 [inline]
 ocfs2_xa_set+0x23dd/0x2ef0 fs/ocfs2/xattr.c:2293
 ocfs2_xattr_block_set+0x3d2/0x3330 fs/ocfs2/xattr.c:3029
 __ocfs2_xattr_set_handle+0x6b2/0xf40 fs/ocfs2/xattr.c:3431
 ocfs2_xattr_set+0xf20/0x13a0 fs/ocfs2/xattr.c:3694
 __vfs_setxattr+0x442/0x480 fs/xattr.c:223
 __vfs_setxattr_noperm+0x12a/0x660 fs/xattr.c:257
 vfs_setxattr+0x163/0x360 fs/xattr.c:344
 do_setxattr fs/xattr.c:662 [inline]
 filename_setxattr+0x296/0x630 fs/xattr.c:690
 path_setxattrat+0x408/0x450 fs/xattr.c:734
 __do_sys_lsetxattr fs/xattr.c:775 [inline]
 __se_sys_lsetxattr fs/xattr.c:771 [inline]
 __x64_sys_lsetxattr+0xbf/0xe0 fs/xattr.c:771
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0x174/0x580 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f4b33d9de99
Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f4b34b82fe8 EFLAGS: 00000246 ORIG_RAX: 00000000000000bd
RAX: ffffffffffffffda RBX: 00007f4b34025fa0 RCX: 00007f4b33d9de99
RDX: 0000200000000080 RSI: 00002000000000c0 RDI: 0000200000000100
RBP: 00007f4b33e33eaf R08: 0000000000000000 R09: 0000000000000000
R10: 000000000000fe37 R11: 0000000000000246 R12: 0000000000000000
R13: 00007f4b34026038 R14: 00007f4b34025fa0 R15: 00007ffd4526fe68
 </TASK>
Modules linked in:
---[ end trace 0000000000000000 ]---
RIP: 0010:ocfs2_xattr_extend_allocation fs/ocfs2/xattr.c:747 [inline]
RIP: 0010:ocfs2_xattr_value_truncate+0x1738/0x1740 fs/ocfs2/xattr.c:868
Code: 44 89 f1 80 e1 07 80 c1 03 38 c1 0f 8c be eb ff ff 4c 89 f7 48 89 f3 e8 d6 44 3d fe 48 89 de e9 ab eb ff ff e8 c9 19 ce fd 90 <0f> 0b 66 0f 1f 44 00 00 90 90 90 90 90 90 90 90 90 90 90 90 90 90
RSP: 0018:ffffc9000f78e940 EFLAGS: 00010283
RAX: ffffffff83f86807 RBX: 0000000000000002 RCX: 0000000000100000
RDX: ffffc9000ee51000 RSI: 0000000000001097 RDI: 0000000000001098
RBP: ffffc9000f78ec70 R08: ffff888000ec2540 R09: 0000000000000006
R10: 00000000fffffffc R11: 0000000000000002 R12: fffff52001ef1d3c
R13: 0000000000000002 R14: 00000000fffffff5 R15: ffff88805486a5d0
FS:  00007f4b34b836c0(0000) GS:ffff88808c549000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000200000001480 CR3: 0000000040786000 CR4: 0000000000352ef0


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
