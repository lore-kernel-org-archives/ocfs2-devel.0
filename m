Received: from mail-il1-f207.google.com (mail-il1-f207.google.com [209.85.166.207])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F14D281360
	for <ocfs2-devel@lists.linux.dev>; Thu, 13 Feb 2025 14:33:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739457204; cv=none; b=P2ZE2HYl1C0syAIdI3IiLfi1ozbKcr7PJBfEIxEjNst+V1j6efZtRVo9UA0b/PefRMeYkkulP38I+OKHueZRaG/b5OrSUGs2jlAkCR0TjF5Z5DxrbGNoWHbFBsU2Z1q7E5YL//VkQ98ogyCid8W1ErIFyZc865PLpWZp/gFibaM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739457204; c=relaxed/simple;
	bh=rQePRAk9O3bgtEyIPFCxA8t/uge4hyllj1l8pttQkp0=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=XV1F93SnMbwRX1Ww9sYPUvTLTwHU8lvZGECR7BS3FK8zq/4O7ylyYGKTxbtgux4j+Pvzh+M8NGs7IqhHWfgv/5Sq1YGvQ6EHizJejqqh9U2jrC2Bg6K/9NrSFRqgpRF19eS3a0sdjIItdTwSpvzJYIhkVzORKjbxL8QPnb8M9vc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f207.google.com with SMTP id e9e14a558f8ab-3d18f21d202so4165285ab.1
        for <ocfs2-devel@lists.linux.dev>; Thu, 13 Feb 2025 06:33:22 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739457201; x=1740062001;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=yhMh31EzK9ox60tCyEPnPow0VPpZdPcvDbsh5lGZR54=;
        b=iSZSa0yTuubnjgDTFMJaX0WdEj/PuRqnto2m76TYHrkqoVwuDwzhUDBpOkWvyLPiz1
         +RubbfZy1Tb1mz3AcYuHZ8JKzVTJFoRBMpCAnHzuOKVcxcdt84Dq5ocphmx5a3GcfF6w
         zZPdIMSRrAYqHczeObXtel2Qb2bIO9g2dUohBwpccQJfZFgYmWfJy38lxY46XWoyTsyq
         IUNdEXiXyDhKsF9wIOh4F7r4mW5qwwE2QWYsMMJYF7wgf1V44kF0oXW7nY7QQETv01Zf
         41pAhgbe7CmVb6OvvSCTGVCjowDkMcShAZCdK83ewoGTzHtWdinJ5pftyQMxz2wPlYUT
         pssQ==
X-Forwarded-Encrypted: i=1; AJvYcCX0qqf9ejXOcURrNB8ysjene0KGTM/hoPxeNZzWChbVFVuil2bIJvSTu4HHWl1c7ihvM5Xw0Fqs9hCm5Q==@lists.linux.dev
X-Gm-Message-State: AOJu0Yz80Gef+gm8hqXihYh9urqjAZecO+mwbvar3Jhi3NMtMJ0PLOst
	1rJFrI3g9II3ofDnKUyhuCi+Hpn+NCcJI/zfyaNldj7Hu4tlgd0x5o3+nO+f4OZn2pG7OqDA7ML
	MqFewEY5pY0KMHL97zxnMYf+ihTGfTrqlsnFhKQmPtliIVkNCUqh2BkQ=
X-Google-Smtp-Source: AGHT+IG9OM16VNddRLgU3t7QbHDEoBZlyJhlttVYNbAKtqq5JWiDNJU0Dzejd/oXfDjsyRRfKgb6sydyBkxNixublag2Tx6xiwnH
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:3e06:b0:3d0:443d:a5ad with SMTP id
 e9e14a558f8ab-3d18c21e821mr32795225ab.2.1739457201515; Thu, 13 Feb 2025
 06:33:21 -0800 (PST)
Date: Thu, 13 Feb 2025 06:33:21 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <67ae02b1.050a0220.110943.005e.GAE@google.com>
Subject: [syzbot] [ocfs2?] possible deadlock in ocfs2_read_folio
From: syzbot <syzbot+bd316bb736c7dc2f318e@syzkaller.appspotmail.com>
To: jlbec@evilplan.org, joseph.qi@linux.alibaba.com, 
	linux-kernel@vger.kernel.org, mark@fasheh.com, ocfs2-devel@lists.linux.dev, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    9946eaf552b1 Merge tag 'hardening-v6.14-rc2' of git://git...
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=165382a4580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=147b7d49d83b8036
dashboard link: https://syzkaller.appspot.com/bug?extid=bd316bb736c7dc2f318e
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/eac613b48ce8/disk-9946eaf5.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/a9e51f9c7777/vmlinux-9946eaf5.xz
kernel image: https://storage.googleapis.com/syzbot-assets/96f75428ab6a/bzImage-9946eaf5.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+bd316bb736c7dc2f318e@syzkaller.appspotmail.com

======================================================
WARNING: possible circular locking dependency detected
6.14.0-rc1-syzkaller-00235-g9946eaf552b1 #0 Not tainted
------------------------------------------------------
syz.2.361/9103 is trying to acquire lock:
ffff88807fd822e0 (&ocfs2_file_ip_alloc_sem_key){++++}-{4:4}, at: ocfs2_read_folio+0x36a/0x980 fs/ocfs2/aops.c:294

but task is already holding lock:
ffff88807fd827e0 (mapping.invalidate_lock#13){.+.+}-{4:4}, at: filemap_invalidate_lock_shared include/linux/fs.h:932 [inline]
ffff88807fd827e0 (mapping.invalidate_lock#13){.+.+}-{4:4}, at: filemap_create_folio mm/filemap.c:2516 [inline]
ffff88807fd827e0 (mapping.invalidate_lock#13){.+.+}-{4:4}, at: filemap_get_pages+0xdc3/0x1fb0 mm/filemap.c:2586

which lock already depends on the new lock.


the existing dependency chain (in reverse order) is:

-> #2 (mapping.invalidate_lock#13){.+.+}-{4:4}:
       lock_acquire+0x1ed/0x550 kernel/locking/lockdep.c:5851
       down_read+0xb1/0xa40 kernel/locking/rwsem.c:1524
       filemap_invalidate_lock_shared include/linux/fs.h:932 [inline]
       filemap_fault+0x7f8/0x16c0 mm/filemap.c:3435
       ocfs2_fault+0xbb/0x3d0 fs/ocfs2/mmap.c:38
       __do_fault+0x135/0x390 mm/memory.c:4977
       do_read_fault mm/memory.c:5392 [inline]
       do_fault mm/memory.c:5526 [inline]
       do_pte_missing mm/memory.c:4047 [inline]
       handle_pte_fault mm/memory.c:5889 [inline]
       __handle_mm_fault+0x4c44/0x70f0 mm/memory.c:6032
       handle_mm_fault+0x2c1/0x7e0 mm/memory.c:6201
       do_user_addr_fault arch/x86/mm/fault.c:1388 [inline]
       handle_page_fault arch/x86/mm/fault.c:1480 [inline]
       exc_page_fault+0x2b9/0x8b0 arch/x86/mm/fault.c:1538
       asm_exc_page_fault+0x26/0x30 arch/x86/include/asm/idtentry.h:623

-> #1 (&mm->mmap_lock){++++}-{4:4}:
       lock_acquire+0x1ed/0x550 kernel/locking/lockdep.c:5851
       __might_fault+0xc6/0x120 mm/memory.c:6840
       _inline_copy_to_user include/linux/uaccess.h:192 [inline]
       _copy_to_user+0x2c/0xb0 lib/usercopy.c:26
       copy_to_user include/linux/uaccess.h:225 [inline]
       fiemap_fill_next_extent+0x235/0x410 fs/ioctl.c:145
       ocfs2_fiemap+0x9f1/0xf80 fs/ocfs2/extent_map.c:806
       ioctl_fiemap fs/ioctl.c:220 [inline]
       do_vfs_ioctl+0x1c01/0x2e40 fs/ioctl.c:840
       __do_sys_ioctl fs/ioctl.c:904 [inline]
       __se_sys_ioctl+0x80/0x170 fs/ioctl.c:892
       do_syscall_x64 arch/x86/entry/common.c:52 [inline]
       do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
       entry_SYSCALL_64_after_hwframe+0x77/0x7f

-> #0 (&ocfs2_file_ip_alloc_sem_key){++++}-{4:4}:
       check_prev_add kernel/locking/lockdep.c:3163 [inline]
       check_prevs_add kernel/locking/lockdep.c:3282 [inline]
       validate_chain+0x18ef/0x5920 kernel/locking/lockdep.c:3906
       __lock_acquire+0x1397/0x2100 kernel/locking/lockdep.c:5228
       lock_acquire+0x1ed/0x550 kernel/locking/lockdep.c:5851
       down_read+0xb1/0xa40 kernel/locking/rwsem.c:1524
       ocfs2_read_folio+0x36a/0x980 fs/ocfs2/aops.c:294
       filemap_read_folio+0x148/0x3b0 mm/filemap.c:2390
       filemap_create_folio mm/filemap.c:2525 [inline]
       filemap_get_pages+0x1042/0x1fb0 mm/filemap.c:2586
       filemap_splice_read+0x68e/0xef0 mm/filemap.c:2971
       do_splice_read fs/splice.c:985 [inline]
       splice_direct_to_actor+0x4af/0xc80 fs/splice.c:1089
       do_splice_direct_actor fs/splice.c:1207 [inline]
       do_splice_direct+0x289/0x3e0 fs/splice.c:1233
       do_sendfile+0x564/0x8a0 fs/read_write.c:1363
       __do_sys_sendfile64 fs/read_write.c:1424 [inline]
       __se_sys_sendfile64+0x17c/0x1e0 fs/read_write.c:1410
       do_syscall_x64 arch/x86/entry/common.c:52 [inline]
       do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
       entry_SYSCALL_64_after_hwframe+0x77/0x7f

other info that might help us debug this:

Chain exists of:
  &ocfs2_file_ip_alloc_sem_key --> &mm->mmap_lock --> mapping.invalidate_lock#13

 Possible unsafe locking scenario:

       CPU0                    CPU1
       ----                    ----
  rlock(mapping.invalidate_lock#13);
                               lock(&mm->mmap_lock);
                               lock(mapping.invalidate_lock#13);
  rlock(&ocfs2_file_ip_alloc_sem_key);

 *** DEADLOCK ***

1 lock held by syz.2.361/9103:
 #0: ffff88807fd827e0 (mapping.invalidate_lock#13){.+.+}-{4:4}, at: filemap_invalidate_lock_shared include/linux/fs.h:932 [inline]
 #0: ffff88807fd827e0 (mapping.invalidate_lock#13){.+.+}-{4:4}, at: filemap_create_folio mm/filemap.c:2516 [inline]
 #0: ffff88807fd827e0 (mapping.invalidate_lock#13){.+.+}-{4:4}, at: filemap_get_pages+0xdc3/0x1fb0 mm/filemap.c:2586

stack backtrace:
CPU: 0 UID: 0 PID: 9103 Comm: syz.2.361 Not tainted 6.14.0-rc1-syzkaller-00235-g9946eaf552b1 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 12/27/2024
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:94 [inline]
 dump_stack_lvl+0x241/0x360 lib/dump_stack.c:120
 print_circular_bug+0x13a/0x1b0 kernel/locking/lockdep.c:2076
 check_noncircular+0x36a/0x4a0 kernel/locking/lockdep.c:2208
 check_prev_add kernel/locking/lockdep.c:3163 [inline]
 check_prevs_add kernel/locking/lockdep.c:3282 [inline]
 validate_chain+0x18ef/0x5920 kernel/locking/lockdep.c:3906
 __lock_acquire+0x1397/0x2100 kernel/locking/lockdep.c:5228
 lock_acquire+0x1ed/0x550 kernel/locking/lockdep.c:5851
 down_read+0xb1/0xa40 kernel/locking/rwsem.c:1524
 ocfs2_read_folio+0x36a/0x980 fs/ocfs2/aops.c:294
 filemap_read_folio+0x148/0x3b0 mm/filemap.c:2390
 filemap_create_folio mm/filemap.c:2525 [inline]
 filemap_get_pages+0x1042/0x1fb0 mm/filemap.c:2586
 filemap_splice_read+0x68e/0xef0 mm/filemap.c:2971
 do_splice_read fs/splice.c:985 [inline]
 splice_direct_to_actor+0x4af/0xc80 fs/splice.c:1089
 do_splice_direct_actor fs/splice.c:1207 [inline]
 do_splice_direct+0x289/0x3e0 fs/splice.c:1233
 do_sendfile+0x564/0x8a0 fs/read_write.c:1363
 __do_sys_sendfile64 fs/read_write.c:1424 [inline]
 __se_sys_sendfile64+0x17c/0x1e0 fs/read_write.c:1410
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f943158cde9
Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 a8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f9432389038 EFLAGS: 00000246 ORIG_RAX: 0000000000000028
RAX: ffffffffffffffda RBX: 00007f94317a6080 RCX: 00007f943158cde9
RDX: 0000000000000000 RSI: 0000000000000004 RDI: 0000000000000008
RBP: 00007f943160e2a0 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000fffe83 R11: 0000000000000246 R12: 0000000000000000
R13: 0000000000000000 R14: 00007f94317a6080 R15: 00007ffd6d546fb8
 </TASK>


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
