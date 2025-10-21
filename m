Received: from mail-il1-f205.google.com (mail-il1-f205.google.com [209.85.166.205])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D573C23A9AD
	for <ocfs2-devel@lists.linux.dev>; Tue, 21 Oct 2025 12:09:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.205
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761048571; cv=none; b=PlNHvvpK0/7sDuW5aEiyQU4+wzCs7z6qGJxb3BsjfbbSXnRnXfY91Z/23t9TbXoLdrumpvSzrWZFTH3cfmaD8K9vsRkO5OIr75QSdADsSetxOLbdBxjNMwTuCam1LaXkeaSsUZsnPqM4qfAPysUpoif+Xj0fIOp/KIkBSFvvW90=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761048571; c=relaxed/simple;
	bh=8DZKaKowd43gZVTMVHK2bM8w3cFQfAeiIqIewPTkAb0=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=SXxXWH662rlVIS5+oCI6rzzvhN8aHjAykqWme2gLm5n75bVvyLbIkDi3XvEWR+8i5a9FpqcnLR3BpW3CSft2USse63t0s8iTPdytx5RHfMwNIkdWCFsdD0Iz4nx7WouHU5qODaOo5jbRiZzr8ovxnq0DAQKb1RRwXIK4cU7YZmQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.205
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f205.google.com with SMTP id e9e14a558f8ab-430cec27637so42731645ab.2
        for <ocfs2-devel@lists.linux.dev>; Tue, 21 Oct 2025 05:09:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761048569; x=1761653369;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=7HSvrBYgqDO0ztUIY/t6QRupb1FILIM60kvawj7pDCo=;
        b=A9ORxA/LkzuizQKT/IFCwotxfxXy4LHJ2+vkBSgf9ix+SAit/82b4RlHUKt7htYHjH
         Y1FyLSStN5TanWV7vNud0cAjNNjZBSEPemUfsrXRMjTmO6X1uw3fXOlOdhLcOpkKwEPs
         xazDEN0WVtxKgVkxH9EqXx0haChYofwY8wsCWdbN8Y3FXSWGirRLp5H9YvKhVv3LC2nM
         ibuCNls7NiDMxAAcl982Ks2DLGUJYcy7+t+67k+XSptzdRbUrViqLMidTLOEOPeSqQq1
         ZJZGTxTSwX12/HT40Qk03dt3G71rYpwnwMpNfKUYjHIoHB8O+GI5xCdAAUx/jrX/ZdMB
         9BhA==
X-Forwarded-Encrypted: i=1; AJvYcCV3zPqzZ07Q/A+r/90yQx+kfz3hCH2g5T9D3OtXwS2CkU8iZfZV+iKxkVREG/o4dXtOQ8mHVT6/TVIyGw==@lists.linux.dev
X-Gm-Message-State: AOJu0YxBp03W82tLjad3r5PJdo6BGeR1sLLfh9UzksVq2X964AkbG2yM
	xnAAq5nuGzyq3g2yRKxFnNpzk3xW1QWSodLo86w1ZwxqD5kWQiXR/7MFPU8EGvpFbMkuzD9sOJ5
	uWvrj+2pIBqFVMBSUmgwV0gq6fOhAnI2Vr8wOlcWvfK1v2JV5eVT8ShPtH/g=
X-Google-Smtp-Source: AGHT+IF3JAZJiINBZTz2bqbyvxAHIkBUkDS04Du54uXjTFpmVY/Ay7YwMdHR8T701b2FCIb8njzEM3sJkS1YViH9g57IVlOz+64W
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:441b:10b0:430:c6b3:b03f with SMTP id
 e9e14a558f8ab-430c6b3b240mr199350495ab.28.1761048569000; Tue, 21 Oct 2025
 05:09:29 -0700 (PDT)
Date: Tue, 21 Oct 2025 05:09:28 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <68f777f8.050a0220.346f24.0016.GAE@google.com>
Subject: [syzbot] [ocfs2?] kernel BUG in __ocfs2_claim_clusters
From: syzbot <syzbot+d937c5714fc8cd6d39df@syzkaller.appspotmail.com>
To: jlbec@evilplan.org, joseph.qi@linux.alibaba.com, 
	linux-kernel@vger.kernel.org, mark@fasheh.com, ocfs2-devel@lists.linux.dev, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    98ac9cc4b445 Merge tag 'f2fs-fix-6.18-rc2' of git://git.ke..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=1754ede2580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=c2d7b4143707d3a0
dashboard link: https://syzkaller.appspot.com/bug?extid=d937c5714fc8cd6d39df
compiler:       Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~exp1~20250708183702.136), Debian LLD 20.1.8

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/d900f083ada3/non_bootable_disk-98ac9cc4.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/4a2afc96e189/vmlinux-98ac9cc4.xz
kernel image: https://storage.googleapis.com/syzbot-assets/92d24cde05de/bzImage-98ac9cc4.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+d937c5714fc8cd6d39df@syzkaller.appspotmail.com

(syz.0.0,5328,0):ocfs2_read_blocks_sync:112 ERROR: status = -12
(syz.0.0,5328,0):update_backups:196 ERROR: status = -12
ocfs2: Failed to update super blocks on 7,0 during fs resize. This condition is not fatal, but fsck.ocfs2 should be run to fix it
------------[ cut here ]------------
kernel BUG at fs/ocfs2/suballoc.c:2390!
Oops: invalid opcode: 0000 [#1] SMP KASAN NOPTI
CPU: 0 UID: 0 PID: 5328 Comm: syz.0.0 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2~bpo12+1 04/01/2014
RIP: 0010:__ocfs2_claim_clusters+0x8d1/0x8f0 fs/ocfs2/suballoc.c:2390
Code: db 78 fe e9 9b fc ff ff e8 3c a2 11 fe 48 c7 c7 a0 a6 66 8e 48 89 de 4c 89 fa e8 ea 7c 1c 01 e9 a2 fc ff ff e8 20 a2 11 fe 90 <0f> 0b e8 18 a2 11 fe 90 0f 0b e8 10 a2 11 fe 90 0f 0b e8 08 a2 11
RSP: 0018:ffffc9000d3ae8c0 EFLAGS: 00010283
RAX: ffffffff83aeb170 RBX: 1ffff110024f0010 RCX: 0000000000100000
RDX: ffffc9000e7eb000 RSI: 00000000000823b8 RDI: 00000000000823b9
RBP: ffffc9000d3aea50 R08: ffffc9000d3ae967 R09: 0000000000000000
R10: ffffc9000d3ae940 R11: fffff52001a75d2d R12: 0000000000000000
R13: ffff888033b90000 R14: 0000000000000000 R15: ffff888012780080
FS:  00007f6b80dd76c0(0000) GS:ffff88808d300000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 000020000012d000 CR3: 00000000428be000 CR4: 0000000000352ef0
Call Trace:
 <TASK>
 ocfs2_claim_clusters fs/ocfs2/suballoc.c:2458 [inline]
 ocfs2_block_group_alloc_contig fs/ocfs2/suballoc.c:432 [inline]
 ocfs2_block_group_alloc fs/ocfs2/suballoc.c:699 [inline]
 ocfs2_reserve_suballoc_bits+0xf1e/0x4640 fs/ocfs2/suballoc.c:834
 ocfs2_reserve_new_metadata_blocks+0x403/0x940 fs/ocfs2/suballoc.c:984
 ocfs2_reserve_new_metadata fs/ocfs2/suballoc.c:1027 [inline]
 ocfs2_lock_allocators+0x29e/0x5c0 fs/ocfs2/suballoc.c:2761
 ocfs2_write_begin_nolock+0x2279/0x4340 fs/ocfs2/aops.c:1719
 ocfs2_write_begin+0x1bb/0x310 fs/ocfs2/aops.c:1884
 generic_perform_write+0x2c5/0x900 mm/filemap.c:4242
 ocfs2_file_write_iter+0x157a/0x1d10 fs/ocfs2/file.c:2469
 new_sync_write fs/read_write.c:593 [inline]
 vfs_write+0x5c9/0xb30 fs/read_write.c:686
 ksys_write+0x145/0x250 fs/read_write.c:738
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0xfa/0xfa0 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f6b7ff8efc9
Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 a8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f6b80dd7038 EFLAGS: 00000246 ORIG_RAX: 0000000000000001
RAX: ffffffffffffffda RBX: 00007f6b801e6090 RCX: 00007f6b7ff8efc9
RDX: 00000000fffffec6 RSI: 0000200000000180 RDI: 000000000000000d
RBP: 00007f6b80011f91 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007f6b801e6128 R14: 00007f6b801e6090 R15: 00007ffd51891f88
 </TASK>
Modules linked in:
---[ end trace 0000000000000000 ]---
RIP: 0010:__ocfs2_claim_clusters+0x8d1/0x8f0 fs/ocfs2/suballoc.c:2390
Code: db 78 fe e9 9b fc ff ff e8 3c a2 11 fe 48 c7 c7 a0 a6 66 8e 48 89 de 4c 89 fa e8 ea 7c 1c 01 e9 a2 fc ff ff e8 20 a2 11 fe 90 <0f> 0b e8 18 a2 11 fe 90 0f 0b e8 10 a2 11 fe 90 0f 0b e8 08 a2 11
RSP: 0018:ffffc9000d3ae8c0 EFLAGS: 00010283
RAX: ffffffff83aeb170 RBX: 1ffff110024f0010 RCX: 0000000000100000
RDX: ffffc9000e7eb000 RSI: 00000000000823b8 RDI: 00000000000823b9
RBP: ffffc9000d3aea50 R08: ffffc9000d3ae967 R09: 0000000000000000
R10: ffffc9000d3ae940 R11: fffff52001a75d2d R12: 0000000000000000
R13: ffff888033b90000 R14: 0000000000000000 R15: ffff888012780080
FS:  00007f6b80dd76c0(0000) GS:ffff88808d300000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 000020000012d000 CR3: 00000000428be000 CR4: 0000000000352ef0


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
