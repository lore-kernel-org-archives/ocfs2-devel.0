Received: from mail-oi1-f208.google.com (mail-oi1-f208.google.com [209.85.167.208])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E99026A1CF
	for <ocfs2-devel@lists.linux.dev>; Tue, 11 Aug 2026 00:24:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.208
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786407881; cv=none; b=Xy1n3zjCG5mofX52rbp6eIKlIYJK5DxTq4xTp8ZxQVezdDJa25tmkUNHLr7gze0JuEfcuMeBYN7WFHgqQWqUWf1kGsWTjk8xlz62fS22/wG7dfd9dIAKnbRZv/mjtEMNHkp93g05L/MnGtA2tUH8BSdWyPblLPTaKf8cSZvmE7o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786407881; c=relaxed/simple;
	bh=D5YQkfXwvjhUJyb7ob+cnfPF6nQYnRbjmvBHBQF8LgU=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=n2LVXzMyY4jqaOhgZTQcPxSRDemmXZAryiL4gER0yI0VNUOVOfkLWg3jabAKBvpjyQEkbPM3qN67nXeyaiGmvcShpRHeN+b4tp9BHF7Uku3+zY7D6w0aMIKMAWcmLLn9Tw89B0fTU9UNfA9bypZ6oEgRvNW2TTnVRohEZBTVZO8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.167.208
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oi1-f208.google.com with SMTP id 5614622812f47-4ab4ca7ce3fso2378075b6e.0
        for <ocfs2-devel@lists.linux.dev>; Mon, 10 Aug 2026 17:24:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786407878; x=1787012678;
        h=content-type:to:from:subject:message-id:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=qW5OVbb2lyOxcIwduX7ZXd6xl9lJ2H8AvjtfBnNcaSA=;
        b=JJvQ7XtJRzECgh6PPRlZCH0rcINVj9e9yuMK3A2Hn/rz8coZBYaqszDIjM/jF22Qxe
         uo7qFdh/eA6Ce96EChsBr+n00EWw0DoM7ej7xlT+Yf/0HyHtOE+ADA5fOaAunIE+StIy
         ZJibZo5MfMnMRvXVrWZ7Y3F/BM/damejdbmikyTpxBM/FSr+61o6DOtZVqQGZJ6pQfxs
         x0aoyKB2aXsQ6QcIF3cnz3T0is9BfZ2OL/b4X1a+Iu7j2doYbOKxFh0gAqyLEVJy9RvK
         1MEfybRnqqeYeAXsYaly3r2ncjrM63TWUD3rc30m5M2TT4uAcihibFducdWehIZAys9C
         Hy6Q==
X-Forwarded-Encrypted: i=1; AHgh+RoYhK+AwioWyb+NZHevk8VbywXFuUEn7a88QtppCjrbMAoKJhl7LHWd6VntPCQGFvA652l1OgAQ6bphLA==@lists.linux.dev
X-Gm-Message-State: AOJu0YzEXOUUX+dgWiNvm4ZqE2e77tZ7pha50xCTnhVo3MJpFb40ThmP
	+cNtoy/FOPfp/3gClZZ9cfA02p+NvPItmbdXRfgjHKD2F1PdOh6uzxfFVxOFM5xYoX+HpblaMuf
	IR/gbILRPgkJ9tE6X2WnGqc/reY4E60hTR+OIC+O9i5oBbIIDoYEW2iC3RTI=
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6808:130c:b0:4b1:a33a:3886 with SMTP id
 5614622812f47-4b1e796ec5fmr3003196b6e.20.1786407878339; Mon, 10 Aug 2026
 17:24:38 -0700 (PDT)
Date: Mon, 10 Aug 2026 17:24:38 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6a7a6bc6.01d0871a.3a0d52.00b2.GAE@google.com>
Subject: [syzbot] [ocfs2?] possible deadlock in ocfs2_xattr_ibody_find (3)
From: syzbot <syzbot+5d34d3019a843b1b211c@syzkaller.appspotmail.com>
To: jlbec@evilplan.org, joseph.qi@linux.alibaba.com, 
	linux-kernel@vger.kernel.org, mark@fasheh.com, ocfs2-devel@lists.linux.dev, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    848acc8ffe1b Merge tag 'fsverity-for-linus' of git://git.k..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=15786cc6580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=b7079b368dcec295
dashboard link: https://syzkaller.appspot.com/bug?extid=5d34d3019a843b1b211c
compiler:       gcc (Debian 14.2.0-19) 14.2.0, GNU ld (GNU Binutils for Debian) 2.44

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/25bde0bfecb5/disk-848acc8f.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/8a5ebf809884/vmlinux-848acc8f.xz
kernel image: https://storage.googleapis.com/syzbot-assets/1d1810845ac3/bzImage-848acc8f.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+5d34d3019a843b1b211c@syzkaller.appspotmail.com

======================================================
WARNING: possible circular locking dependency detected
syzkaller #0 Not tainted
------------------------------------------------------
syz.5.129/6534 is trying to acquire lock:
ffff8880539d2258 (&ocfs2_file_ip_alloc_sem_key){++++}-{4:4}, at: ocfs2_xattr_ibody_find.constprop.0+0x381/0x4b0 fs/ocfs2/xattr.c:2731

but task is already holding lock:
ffff8880539d22e8 (&oi->ip_xattr_sem){++++}-{4:4}, at: ocfs2_xattr_set+0x429/0x2bb0 fs/ocfs2/xattr.c:3627

which lock already depends on the new lock.


the existing dependency chain (in reverse order) is:

-> #3 (&oi->ip_xattr_sem){++++}-{4:4}:
       lock_acquire kernel/locking/lockdep.c:5868 [inline]
       lock_acquire+0x1b9/0x370 kernel/locking/lockdep.c:5825
       down_read+0x99/0x4c0 kernel/locking/rwsem.c:1574
       ocfs2_init_acl+0x35b/0x840 fs/ocfs2/acl.c:367
       ocfs2_mknod+0x173c/0x2770 fs/ocfs2/namei.c:414
       ocfs2_create+0xf4/0x430 fs/ocfs2/namei.c:677
       vfs_create+0x301/0x6c0 fs/namei.c:4202
       filename_mknodat+0x2de/0x7f0 fs/namei.c:5185
       __do_sys_mknodat fs/namei.c:5216 [inline]
       __se_sys_mknodat fs/namei.c:5212 [inline]
       __x64_sys_mknodat+0xb5/0xf0 fs/namei.c:5212
       do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
       do_syscall_64+0x115/0x870 arch/x86/entry/syscall_64.c:94
       entry_SYSCALL_64_after_hwframe+0x77/0x7f

-> #2 (&journal->j_trans_barrier){.+.+}-{4:4}:
       lock_acquire kernel/locking/lockdep.c:5868 [inline]
       lock_acquire+0x1b9/0x370 kernel/locking/lockdep.c:5825
       down_read+0x99/0x4c0 kernel/locking/rwsem.c:1574
       ocfs2_start_trans+0x5cc/0x8f0 fs/ocfs2/journal.c:369
       ocfs2_block_group_alloc fs/ocfs2/suballoc.c:801 [inline]
       ocfs2_reserve_suballoc_bits+0x49e/0x4b00 fs/ocfs2/suballoc.c:950
       ocfs2_reserve_new_metadata_blocks+0x506/0xbe0 fs/ocfs2/suballoc.c:1100
       ocfs2_expand_inline_dir.constprop.0+0xe21/0x3ff0 fs/ocfs2/dir.c:2873
       ocfs2_extend_dir+0x1dc/0x1bf0 fs/ocfs2/dir.c:3235
       ocfs2_prepare_dir_for_insert+0x130d/0x1770 fs/ocfs2/dir.c:4353
       ocfs2_mknod+0x8c1/0x2770 fs/ocfs2/namei.c:298
       ocfs2_create+0xf4/0x430 fs/ocfs2/namei.c:677
       vfs_create+0x301/0x6c0 fs/namei.c:4202
       filename_mknodat+0x2de/0x7f0 fs/namei.c:5185
       __do_sys_mknodat fs/namei.c:5216 [inline]
       __se_sys_mknodat fs/namei.c:5212 [inline]
       __x64_sys_mknodat+0xb5/0xf0 fs/namei.c:5212
       do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
       do_syscall_64+0x115/0x870 arch/x86/entry/syscall_64.c:94
       entry_SYSCALL_64_after_hwframe+0x77/0x7f

-> #1 (sb_internal#3){.+.+}-{0:0}:
       lock_acquire kernel/locking/lockdep.c:5868 [inline]
       lock_acquire+0x1b9/0x370 kernel/locking/lockdep.c:5825
       percpu_down_read_internal include/linux/percpu-rwsem.h:53 [inline]
       percpu_down_read_freezable include/linux/percpu-rwsem.h:83 [inline]
       __sb_start_write include/linux/fs/super.h:19 [inline]
       sb_start_intwrite include/linux/fs/super.h:177 [inline]
       ocfs2_start_trans+0x4bb/0x8f0 fs/ocfs2/journal.c:367
       ocfs2_extend_dir+0x630/0x1bf0 fs/ocfs2/dir.c:3322
       ocfs2_prepare_dx_dir_for_insert.isra.0+0x823/0xfb0 fs/ocfs2/dir.c:4273
       ocfs2_prepare_dir_for_insert+0xf1c/0x1770 fs/ocfs2/dir.c:4329
       ocfs2_mknod+0x8c1/0x2770 fs/ocfs2/namei.c:298
       ocfs2_create+0xf4/0x430 fs/ocfs2/namei.c:677
       vfs_create+0x301/0x6c0 fs/namei.c:4202
       filename_mknodat+0x2de/0x7f0 fs/namei.c:5185
       __do_sys_mknodat fs/namei.c:5216 [inline]
       __se_sys_mknodat fs/namei.c:5212 [inline]
       __x64_sys_mknodat+0xb5/0xf0 fs/namei.c:5212
       do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
       do_syscall_64+0x115/0x870 arch/x86/entry/syscall_64.c:94
       entry_SYSCALL_64_after_hwframe+0x77/0x7f

-> #0 (&ocfs2_file_ip_alloc_sem_key){++++}-{4:4}:
       check_prev_add+0xeb/0xe60 kernel/locking/lockdep.c:3165
       check_prevs_add kernel/locking/lockdep.c:3284 [inline]
       validate_chain kernel/locking/lockdep.c:3908 [inline]
       __lock_acquire+0x136c/0x1a40 kernel/locking/lockdep.c:5237
       lock_acquire kernel/locking/lockdep.c:5868 [inline]
       lock_acquire+0x1b9/0x370 kernel/locking/lockdep.c:5825
       down_read+0x99/0x4c0 kernel/locking/rwsem.c:1574
       ocfs2_xattr_ibody_find.constprop.0+0x381/0x4b0 fs/ocfs2/xattr.c:2731
       ocfs2_xattr_set+0x441/0x2bb0 fs/ocfs2/xattr.c:3632
       ocfs2_xattr_user_set+0xbd/0x100 fs/ocfs2/xattr.c:7430
       __vfs_setxattr+0x175/0x1e0 fs/xattr.c:223
       __vfs_setxattr_noperm+0x127/0x660 fs/xattr.c:257
       __vfs_setxattr_locked+0x127/0x2b0 fs/xattr.c:318
       vfs_setxattr+0x14a/0x390 fs/xattr.c:344
       do_setxattr+0x145/0x180 fs/xattr.c:662
       filename_setxattr+0x167/0x1d0 fs/xattr.c:690
       path_setxattrat+0x1ff/0x3b0 fs/xattr.c:734
       __do_sys_setxattr fs/xattr.c:768 [inline]
       __se_sys_setxattr fs/xattr.c:764 [inline]
       __x64_sys_setxattr+0xc6/0x140 fs/xattr.c:764
       do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
       do_syscall_64+0x115/0x870 arch/x86/entry/syscall_64.c:94
       entry_SYSCALL_64_after_hwframe+0x77/0x7f

other info that might help us debug this:

Chain exists of:
  &ocfs2_file_ip_alloc_sem_key --> &journal->j_trans_barrier --> &oi->ip_xattr_sem

 Possible unsafe locking scenario:

       CPU0                    CPU1
       ----                    ----
  lock(&oi->ip_xattr_sem);
                               lock(&journal->j_trans_barrier);
                               lock(&oi->ip_xattr_sem);
  rlock(&ocfs2_file_ip_alloc_sem_key);

 *** DEADLOCK ***

3 locks held by syz.5.129/6534:
 #0: ffff888035dd2450 (sb_writers#16){.+.+}-{0:0}, at: filename_setxattr+0xbf/0x1d0 fs/xattr.c:688
 #1: ffff8880539d25a0 (&type->i_mutex_dir_key#10){+.+.}-{4:4}, at: inode_lock include/linux/fs.h:1024 [inline]
 #1: ffff8880539d25a0 (&type->i_mutex_dir_key#10){+.+.}-{4:4}, at: vfs_setxattr+0x120/0x390 fs/xattr.c:343
 #2: ffff8880539d22e8 (&oi->ip_xattr_sem){++++}-{4:4}, at: ocfs2_xattr_set+0x429/0x2bb0 fs/ocfs2/xattr.c:3627

stack backtrace:
CPU: 0 UID: 0 PID: 6534 Comm: syz.5.129 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 07/16/2026
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:94 [inline]
 dump_stack_lvl+0x100/0x190 lib/dump_stack.c:120
 print_circular_bug.cold+0x178/0x1c7 kernel/locking/lockdep.c:2043
 check_noncircular+0x146/0x160 kernel/locking/lockdep.c:2175
 check_prev_add+0xeb/0xe60 kernel/locking/lockdep.c:3165
 check_prevs_add kernel/locking/lockdep.c:3284 [inline]
 validate_chain kernel/locking/lockdep.c:3908 [inline]
 __lock_acquire+0x136c/0x1a40 kernel/locking/lockdep.c:5237
 lock_acquire kernel/locking/lockdep.c:5868 [inline]
 lock_acquire+0x1b9/0x370 kernel/locking/lockdep.c:5825
 down_read+0x99/0x4c0 kernel/locking/rwsem.c:1574
 ocfs2_xattr_ibody_find.constprop.0+0x381/0x4b0 fs/ocfs2/xattr.c:2731
 ocfs2_xattr_set+0x441/0x2bb0 fs/ocfs2/xattr.c:3632
 ocfs2_xattr_user_set+0xbd/0x100 fs/ocfs2/xattr.c:7430
 __vfs_setxattr+0x175/0x1e0 fs/xattr.c:223
 __vfs_setxattr_noperm+0x127/0x660 fs/xattr.c:257
 __vfs_setxattr_locked+0x127/0x2b0 fs/xattr.c:318
 vfs_setxattr+0x14a/0x390 fs/xattr.c:344
 do_setxattr+0x145/0x180 fs/xattr.c:662
 filename_setxattr+0x167/0x1d0 fs/xattr.c:690
 path_setxattrat+0x1ff/0x3b0 fs/xattr.c:734
 __do_sys_setxattr fs/xattr.c:768 [inline]
 __se_sys_setxattr fs/xattr.c:764 [inline]
 __x64_sys_setxattr+0xc6/0x140 fs/xattr.c:764
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0x115/0x870 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f2bbd19e019
Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f2bbe057028 EFLAGS: 00000246 ORIG_RAX: 00000000000000bc
RAX: ffffffffffffffda RBX: 00007f2bbd425fa0 RCX: 00007f2bbd19e019
RDX: 0000200000000200 RSI: 0000200000000100 RDI: 0000200000000000
RBP: 00007f2bbd23500c R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000005 R11: 0000000000000246 R12: 0000000000000000
R13: 00007f2bbd426038 R14: 00007f2bbd425fa0 R15: 00007fff84a2eb78
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
