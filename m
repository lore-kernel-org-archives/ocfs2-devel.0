Received: from mail-il1-f208.google.com (mail-il1-f208.google.com [209.85.166.208])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6858166F34
	for <ocfs2-devel@lists.linux.dev>; Thu, 23 Jan 2025 16:46:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.208
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737650790; cv=none; b=gDZabzmtbo+5HzmW/BX3UMvYZMsdcdFyybuoxcCQPSsYGtpKEcmDebCkSvLpMztBsgbo35ga/tMCqgiiYHRi8DeSYdkFDf0yOqtxOfUGj+3KkQqETMc67HKK/7yifi3mYfcx+VmRpOYEjFTMRNwqjxDe9MH7pNPto5Dz9ZC1DCM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737650790; c=relaxed/simple;
	bh=i4LI1clNG+ih9gCVCKDOwUKiC8YhJ+z3xaQpSNhLONI=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=fA3P1gNPNT3qiVwVLZPZnv/wo8T/ooGeIpglH/Y3XcJBqkGSwICwKUgbwupZczlG8u+i1XNLGwL5FxrZan6lxxGIt2ImynEQl37B1/K1LvoBIjPoxpKd8wVkDQPDxZCZiABNnvgdsTCGmL0Bgnz/2UL7V5wXO4hOoAj/SVmg298=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.208
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f208.google.com with SMTP id e9e14a558f8ab-3ce3bbb2b9dso6795525ab.3
        for <ocfs2-devel@lists.linux.dev>; Thu, 23 Jan 2025 08:46:28 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737650788; x=1738255588;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=CZzNx5mG8TaLDYGfjVI8CK45XXIlLTp5v2J/Fa9dekA=;
        b=LNNlS0C36sem2ZUvLyS2Joy1w1Q0YdV0QiP7DjQhe4GIACHoWJAeWwN2aRt4VuM1/G
         hHAdD3fZXE4BHKwaE6mlNj9UiWGq8pihgiM2rEwjiJlSFBrD+t2jMqKYBiNmM6Lk4fRO
         9f54oQ1bOB0bjEYqaCSqTbyDoL7faZlnGI1hi+Qdl75Se3NhK9A/2UuVHTFSKrLdZRNp
         +5RcMQFGNFhIZGlFMK96ZUKsVAQVX3XomKvXo4nIv8YKideGA2xVmOFc789ThqzVx/ke
         0IdUiNMJbCJ1xElh5z9J0Ph3hoK4U1MS7zb0YRA4PFHU2whGJyZg7YRvZjqTbui+AhlV
         5geQ==
X-Forwarded-Encrypted: i=1; AJvYcCX3IpgNdVO4Me2EP2rdVapuXptPdpos+mRfQ2gTMtJgs2wbTyhywfHtZTFwot5U+jZlWbJQxT3dalq6wQ==@lists.linux.dev
X-Gm-Message-State: AOJu0YxZZRtWe1viAkksOFE593J+ELVdIKED1b5nGRiZwppL9Bg9ZbKf
	oEge5ye6TENJgAS4FfN1kWqvWLt2IqyyKJ0pn03VqaSSzdXCBq7nssL4HVMi3GREgVfNitiMAZI
	Qukq5nuUH1nxx4YG/kNPAG1gCj7J3+pDtZPHDIpOhRbOQbVPh4u7gLbc=
X-Google-Smtp-Source: AGHT+IEfWwcUa7tKy/NMOQrvk1szHh9MoK1q0GdSsq18mjXe53ExNaJIWmn/ufw8j1XiQYHr5tOD6sRD713m1nUPA6qYH6HkEJ8h
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1a67:b0:3ce:856b:e451 with SMTP id
 e9e14a558f8ab-3cf743ab5d9mr187672845ab.5.1737650787899; Thu, 23 Jan 2025
 08:46:27 -0800 (PST)
Date: Thu, 23 Jan 2025 08:46:27 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <67927263.050a0220.2eae65.0010.GAE@google.com>
Subject: [syzbot] [ocfs2?] kernel BUG in ocfs2_remove_btree_range
From: syzbot <syzbot+08d94b4c1f72cc5fdaec@syzkaller.appspotmail.com>
To: jlbec@evilplan.org, joseph.qi@linux.alibaba.com, 
	linux-kernel@vger.kernel.org, mark@fasheh.com, ocfs2-devel@lists.linux.dev, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    fda5e3f28400 Merge tag 'trace-v6.13-rc7-2' of git://git.ke..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=102be024580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=aadf89e2f6db86cc
dashboard link: https://syzkaller.appspot.com/bug?extid=08d94b4c1f72cc5fdaec
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/7feb34a89c2a/non_bootable_disk-fda5e3f2.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/b1c9760eb9a5/vmlinux-fda5e3f2.xz
kernel image: https://storage.googleapis.com/syzbot-assets/69b879da720e/bzImage-fda5e3f2.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+08d94b4c1f72cc5fdaec@syzkaller.appspotmail.com

loop0: detected capacity change from 0 to 32768
=======================================================
WARNING: The mand mount option has been deprecated and
         and is ignored by this kernel. Remove the mand
         option from the mount to silence this warning.
=======================================================
ocfs2: Mounting device (7,0) on (node local, slot 0) with ordered data mode.
(syz.0.0,5315,0):ocfs2_truncate_log_needs_flush:5822 ERROR: bug expression: le16_to_cpu(tl->tl_used) > le16_to_cpu(tl->tl_count)
(syz.0.0,5315,0):ocfs2_truncate_log_needs_flush:5822 ERROR: slot 0, invalid truncate log parameters: used = 240, count = 39
------------[ cut here ]------------
kernel BUG at fs/ocfs2/alloc.c:5822!
Oops: invalid opcode: 0000 [#1] PREEMPT SMP KASAN NOPTI
CPU: 0 UID: 0 PID: 5315 Comm: syz.0.0 Not tainted 6.13.0-rc7-syzkaller-00191-gfda5e3f28400 #0
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2~bpo12+1 04/01/2014
RIP: 0010:ocfs2_truncate_log_needs_flush fs/ocfs2/alloc.c:5819 [inline]
RIP: 0010:ocfs2_remove_btree_range+0x1859/0x1860 fs/ocfs2/alloc.c:5744
Code: 0f b7 00 4c 89 ff 48 c7 c6 84 b6 0e 8e ba be 16 00 00 48 c7 c1 20 43 48 8c 45 89 e0 41 89 d9 50 e8 5c a0 20 00 48 83 c4 08 90 <0f> 0b 0f 1f 44 00 00 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90
RSP: 0018:ffffc9000d426c40 EFLAGS: 00010292
RAX: 235f97fc7a573600 RBX: 00000000000000f0 RCX: 235f97fc7a573600
RDX: ffffc9000ecba000 RSI: 00000000000023ad RDI: 00000000000023ae
RBP: ffffc9000d426f18 R08: ffffffff817f1b5c R09: 1ffff92001a84cf8
R10: dffffc0000000000 R11: fffff52001a84cf9 R12: 0000000000000000
R13: ffff8880537b6ac2 R14: 1ffff1100a6f6d58 R15: ffffc9000d426d00
FS:  00007f41eea816c0(0000) GS:ffff88801fc00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f9bda395ed8 CR3: 0000000042cca000 CR4: 0000000000352ef0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 ocfs2_commit_truncate+0xcca/0x2550 fs/ocfs2/alloc.c:7353
 ocfs2_truncate_file+0xd21/0x1560 fs/ocfs2/file.c:509
 ocfs2_setattr+0x1890/0x1ef0 fs/ocfs2/file.c:1212
 notify_change+0xbca/0xe90 fs/attr.c:552
 do_truncate+0x220/0x310 fs/open.c:65
 handle_truncate fs/namei.c:3449 [inline]
 do_open fs/namei.c:3832 [inline]
 path_openat+0x2e1e/0x3590 fs/namei.c:3987
 do_filp_open+0x27f/0x4e0 fs/namei.c:4014
 do_sys_openat2+0x13e/0x1d0 fs/open.c:1402
 do_sys_open fs/open.c:1417 [inline]
 __do_sys_open fs/open.c:1425 [inline]
 __se_sys_open fs/open.c:1421 [inline]
 __x64_sys_open+0x225/0x270 fs/open.c:1421
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f41edb85d29
Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 a8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f41eea81038 EFLAGS: 00000246 ORIG_RAX: 0000000000000002
RAX: ffffffffffffffda RBX: 00007f41edd75fa0 RCX: 00007f41edb85d29
RDX: 0000000000000010 RSI: 0000000000000282 RDI: 0000000020000140
RBP: 00007f41edc01b08 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 0000000000000000 R14: 00007f41edd75fa0 R15: 00007fffbe9c4a28
 </TASK>
Modules linked in:
---[ end trace 0000000000000000 ]---
RIP: 0010:ocfs2_truncate_log_needs_flush fs/ocfs2/alloc.c:5819 [inline]
RIP: 0010:ocfs2_remove_btree_range+0x1859/0x1860 fs/ocfs2/alloc.c:5744
Code: 0f b7 00 4c 89 ff 48 c7 c6 84 b6 0e 8e ba be 16 00 00 48 c7 c1 20 43 48 8c 45 89 e0 41 89 d9 50 e8 5c a0 20 00 48 83 c4 08 90 <0f> 0b 0f 1f 44 00 00 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90
RSP: 0018:ffffc9000d426c40 EFLAGS: 00010292
RAX: 235f97fc7a573600 RBX: 00000000000000f0 RCX: 235f97fc7a573600
RDX: ffffc9000ecba000 RSI: 00000000000023ad RDI: 00000000000023ae
RBP: ffffc9000d426f18 R08: ffffffff817f1b5c R09: 1ffff92001a84cf8
R10: dffffc0000000000 R11: fffff52001a84cf9 R12: 0000000000000000
R13: ffff8880537b6ac2 R14: 1ffff1100a6f6d58 R15: ffffc9000d426d00
FS:  00007f41eea816c0(0000) GS:ffff88801fc00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00005565fc1ee068 CR3: 0000000042cca000 CR4: 0000000000352ef0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400


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
