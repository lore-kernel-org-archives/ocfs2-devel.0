Received: from mail-il1-f200.google.com (mail-il1-f200.google.com [209.85.166.200])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D35F1917D7
	for <ocfs2-devel@lists.linux.dev>; Mon, 28 Oct 2024 08:29:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.200
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730104178; cv=none; b=vFN2jTzVjWjRHEBuFqRhA+eFZGWhicJJypvc/P0hGE7HVqhqhxoVGh3mhl6xEnzJnLKeSBz0eU0Z9T5tj11fwGc6jqK0v8Lk+mu3qmz6DoD7Yvss+mSQAv7BUc0boNE1AhGwkMS3ytbyA1qFUHNIEBXMVeOPto4rs5PBJkutv5k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730104178; c=relaxed/simple;
	bh=Lwy81QMfHYcLmYo+8APTzyPYfA/mMsjAbII/8tFZSs0=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=SUj1B2ul/pt4FqVLyGmeZkHcF5eWdTMwKCZFSZ1cP/IY5jPyKEmSifDevocqIwR09B8Dja3onksEkgYbuNPwXlHjTvBfLCpEcLY8VIWHhVR5i5TlloueKa4cbo4fzBGiWHz7pWjbm6S7f9q31adACq8HcKZSaY7tsHZYDUtSfGU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.200
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f200.google.com with SMTP id e9e14a558f8ab-3a4e4c723c3so16697255ab.1
        for <ocfs2-devel@lists.linux.dev>; Mon, 28 Oct 2024 01:29:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730104175; x=1730708975;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=02pN1YNARKv0YMmBiHTpY0ke7fv8qBacgCzoRUX8YxU=;
        b=hq/xFORrczi1r+QFWNAellPIv7ZfbHaodmqDtAiu3+R9yauHXGIthe1f1Bwkp8S0Nz
         QNk51egfn55u1UdC89ZmcCcvKyEumuTwCjok1KbW1KVwyuyMMPyi9OaQe+17v1QizytH
         GCJd4osxHn0XNtgjSMZ44Iu9QhEpspgm0o6Z20HJrSI2pETXPo9TsWaiw4rQ2MHgcllm
         8hY6+iYzszOLFwKPn/XOP1OF6SaoemFj73/06OAoYSikkfF7mmSiXPIIXlNIV/MhL1Ke
         3ZQAJy9Vih4Nr6AJlCEs6yLZY3YejNSuip21qM8VEGq1dgsEuughsbonzR8R5XsSrv5Y
         EIkw==
X-Forwarded-Encrypted: i=1; AJvYcCXww32EBc8qxHizpFB0ghy0rd/LL1s3YSwwqMIdohL91y+oiwYz3DcKbpvxIHUqjArjvBENx6RGljMRSg==@lists.linux.dev
X-Gm-Message-State: AOJu0YxMZDvrwuoyhTenJMqQn+dG9snXI1C8DlhYLM51qYd37tWHbH56
	8zFgc9nJCEW6xgcBJMfu9dLK1W7VR2KzvU5XsQUS6yEdGZExkaobZCpjcUHO6l1eHMXNl1wB1Fr
	bDoHnTaBfmPne7dweGEHp7mCLVK4BCH9vwNoDseevxBd61QBXjsqHQmk=
X-Google-Smtp-Source: AGHT+IFBUKQnVyIZ664CYI+F1t1+/v7uZYXH8qHdx2QAxL3I0YGsSo75TgM1uu+EhptMuetMbbta9875B6RueK97HvNZbX6h/8sT
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:20c8:b0:39d:3c87:1435 with SMTP id
 e9e14a558f8ab-3a4de6f6b3dmr99859545ab.1.1730104175522; Mon, 28 Oct 2024
 01:29:35 -0700 (PDT)
Date: Mon, 28 Oct 2024 01:29:35 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <671f4b6f.050a0220.2b8c0f.0203.GAE@google.com>
Subject: [syzbot] [ocfs2?] KMSAN: uninit-value in ocfs2_file_read_iter
From: syzbot <syzbot+a73e253cca4f0230a5a5@syzkaller.appspotmail.com>
To: jlbec@evilplan.org, joseph.qi@linux.alibaba.com, 
	linux-kernel@vger.kernel.org, mark@fasheh.com, ocfs2-devel@lists.linux.dev, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    c2ee9f594da8 KVM: selftests: Fix build on on non-x86 archi..
git tree:       upstream
console+strace: https://syzkaller.appspot.com/x/log.txt?x=16057c30580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=f0a45c444eedcbdb
dashboard link: https://syzkaller.appspot.com/bug?extid=a73e253cca4f0230a5a5
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=11677640580000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=12035287980000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/f80f18f107d8/disk-c2ee9f59.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/64d58c958a32/vmlinux-c2ee9f59.xz
kernel image: https://storage.googleapis.com/syzbot-assets/7c33b64644e2/bzImage-c2ee9f59.xz
mounted in repro: https://storage.googleapis.com/syzbot-assets/36ce847202f8/mount_0.gz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+a73e253cca4f0230a5a5@syzkaller.appspotmail.com

=====================================================
BUG: KMSAN: uninit-value in ocfs2_file_read_iter+0x9a4/0xf80 fs/ocfs2/file.c:2584
 ocfs2_file_read_iter+0x9a4/0xf80 fs/ocfs2/file.c:2584
 io_iter_do_read io_uring/rw.c:771 [inline]
 __io_read+0x8d2/0x20f0 io_uring/rw.c:865
 io_read+0x3e/0xf0 io_uring/rw.c:943
 io_issue_sqe+0x429/0x22c0 io_uring/io_uring.c:1739
 io_wq_submit_work+0xaf9/0xdc0 io_uring/io_uring.c:1848
 io_worker_handle_work+0xd11/0x2110 io_uring/io-wq.c:601
 io_wq_worker+0x447/0x1410 io_uring/io-wq.c:655
 ret_from_fork+0x6d/0x90 arch/x86/kernel/process.c:147
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:244

Uninit was created at:
 __alloc_pages_noprof+0x9a7/0xe00 mm/page_alloc.c:4756
 alloc_pages_mpol_noprof+0x299/0x990 mm/mempolicy.c:2265
 alloc_pages_noprof+0x1bf/0x1e0 mm/mempolicy.c:2345
 alloc_slab_page mm/slub.c:2412 [inline]
 allocate_slab+0x33a/0x1250 mm/slub.c:2578
 new_slab mm/slub.c:2631 [inline]
 ___slab_alloc+0x12ef/0x35e0 mm/slub.c:3818
 __kmem_cache_alloc_bulk mm/slub.c:4895 [inline]
 kmem_cache_alloc_bulk_noprof+0x486/0x1330 mm/slub.c:4967
 __io_alloc_req_refill+0x84/0x560 io_uring/io_uring.c:969
 io_alloc_req io_uring/io_uring.h:406 [inline]
 io_submit_sqes+0x172f/0x2f30 io_uring/io_uring.c:2313
 __do_sys_io_uring_enter io_uring/io_uring.c:3343 [inline]
 __se_sys_io_uring_enter+0x406/0x41c0 io_uring/io_uring.c:3279
 __x64_sys_io_uring_enter+0x11f/0x1a0 io_uring/io_uring.c:3279
 x64_sys_call+0x2b54/0x3ba0 arch/x86/include/generated/asm/syscalls_64.h:427
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0xcd/0x1e0 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f

CPU: 0 UID: 0 PID: 5188 Comm: iou-wrk-5184 Not tainted 6.12.0-rc4-syzkaller-00047-gc2ee9f594da8 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 09/13/2024
=====================================================


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
