Received: from mail-io1-f72.google.com (mail-io1-f72.google.com [209.85.166.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14B8C19ABDD
	for <ocfs2-devel@lists.linux.dev>; Wed, 21 Aug 2024 07:40:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724226026; cv=none; b=cndpUK0hrH4Z3jbpBp/A+jzEUBnt084O4U4M3n/9nnh53YeLN2DDKY5c4UOBPo8LzydZ6GxU+lBNiUhH7WSiExZ+ZTK9ztvWtQW267dP9KhwfSM2lyjrUX6QUoEMZHkemPl7W9bdXS8ihwZwI9EWtiKIviyKSsilUSInO9fKKYo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724226026; c=relaxed/simple;
	bh=5JUNpur+HBN/m5UcYZvjRbz8QlalYXj52LwIsPLIk9s=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=TNuBC0s+sKwJccZe+ay1NCnyme2xQxwJB059frfbKgsKsPfCBGi+ROAY/8zsiCx/+uiD+U0LF2w/VjjLNo3YVhN0i2P09VsdG912htWdpUyvpwOEpzvk5gGZve7uHrwfA6/OWRYzrBW6JK3+TJG9V+oi5hl+SgNLaZ1LGBRoWLQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-io1-f72.google.com with SMTP id ca18e2360f4ac-81f901cd3b5so656538039f.1
        for <ocfs2-devel@lists.linux.dev>; Wed, 21 Aug 2024 00:40:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724226024; x=1724830824;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=BZYbNeKR6UQf9999tSnoPtF6sLrzU8XkW/8vGKmIgPw=;
        b=aea65Zfk9FOj+WPZwhJnLgU9/ICjGuddne6RspvboLVNkc7bNd8s9whLoS0UzMZuMu
         eINwdCC87pNZXLqQve2HgFHeH8C+1KicMFsBoocB93BTL9YGtxWmZVy9xBkR+WdI1Kl9
         HVJsJRPpNJFWrvW4rt2/7EsJUjwLFJBGumT2J6KtOCMUvKJBjAJ9awGxePn7pTd1nV4l
         5XuUu6Dt0moQJn0P2ZrMsYflpdTgufQWKiCasowvoVMsGIN/cdDn/rmcMIoZD8kVNnsX
         ivY+B1vVIKfQwzf0DqhU72HRWtVCeM830f7CBB1rSEfAIX3pfoVQ6CnVlZkzAwNjpK52
         oqlg==
X-Forwarded-Encrypted: i=1; AJvYcCWJ2qTiTLeQCZGLPiIFP5txhG9Mf9ZP0eUSOHu9hLql9ro5in5EV40tCJgnoxz0q7ZSa59a4e64RfyuDA==@lists.linux.dev
X-Gm-Message-State: AOJu0YwyMS7OMGjoJ3J4Zi7t3KJmMkSBFeRf/bZ8dNiPIdPMDnI7lcew
	iNoIX0L3DYWHZVjjtA/AoOwZZBBwH06iMSL4WOOUYGwLTl7aBMj0eN4KHguyt4ZsTcUw9/0/eFz
	m6en62vhkm4GHsTWj99zQl4MK4zw4DXPs02HUTipskq1U3WV+e7fOd2M=
X-Google-Smtp-Source: AGHT+IHzaEtUXRSWdSfVERZBXBTSBIeQ871PvdvSweVdPTexqnKwX3XOEG+GVs3ya6HGJkKRydkqdvPTCi4ZYd1kCIhVh6DFhV8M
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6638:2187:b0:4c0:838e:9fd1 with SMTP id
 8926c6da1cb9f-4ce630585dbmr54415173.5.1724226024120; Wed, 21 Aug 2024
 00:40:24 -0700 (PDT)
Date: Wed, 21 Aug 2024 00:40:24 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000ae358c06202ca726@google.com>
Subject: [syzbot] [ocfs2?] possible deadlock in ocfs2_setattr
From: syzbot <syzbot+d78497256d53041ee229@syzkaller.appspotmail.com>
To: jlbec@evilplan.org, joseph.qi@linux.alibaba.com, 
	linux-kernel@vger.kernel.org, mark@fasheh.com, ocfs2-devel@lists.linux.dev, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    521b1e7f4cf0 Merge tag 'cxl-fixes-6.11-rc5' of git://git.k..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=175453cb980000
kernel config:  https://syzkaller.appspot.com/x/.config?x=df2f0ed7e30a639d
dashboard link: https://syzkaller.appspot.com/bug?extid=d78497256d53041ee229
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1395e991980000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=13659d6b980000

Downloadable assets:
disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/7bc7510fe41f/non_bootable_disk-521b1e7f.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/fc256e887f7f/vmlinux-521b1e7f.xz
kernel image: https://storage.googleapis.com/syzbot-assets/0ecca3914e31/bzImage-521b1e7f.xz
mounted in repro: https://storage.googleapis.com/syzbot-assets/4ad0fdc1f43e/mount_0.gz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+d78497256d53041ee229@syzkaller.appspotmail.com

JBD2: Ignoring recovery information on journal
ocfs2: Mounting device (7,0) on (node local, slot 0) with writeback data mode.
======================================================
WARNING: possible circular locking dependency detected
6.11.0-rc4-syzkaller-00011-g521b1e7f4cf0 #0 Not tainted
------------------------------------------------------
syz-executor408/5110 is trying to acquire lock:
ffff888037bf6610 (sb_internal#2){.+.+}-{0:0}, at: ocfs2_setattr+0xcb1/0x1f50 fs/ocfs2/file.c:1259

but task is already holding lock:
ffff88803c2bcda0 (&oi->ip_alloc_sem){+.+.}-{3:3}, at: ocfs2_setattr+0xc9f/0x1f50 fs/ocfs2/file.c:1258

which lock already depends on the new lock.


the existing dependency chain (in reverse order) is:

-> #4 (&oi->ip_alloc_sem){+.+.}-{3:3}:
       lock_acquire+0x1ed/0x550 kernel/locking/lockdep.c:5759
       down_write+0x99/0x220 kernel/locking/rwsem.c:1579
       ocfs2_try_remove_refcount_tree+0xb6/0x330 fs/ocfs2/refcounttree.c:931
       ocfs2_xattr_set+0xa4f/0x1930 fs/ocfs2/xattr.c:3670
       ocfs2_set_acl+0x4cb/0x580 fs/ocfs2/acl.c:254
       ocfs2_iop_set_acl+0x24a/0x3c0 fs/ocfs2/acl.c:286
       set_posix_acl fs/posix_acl.c:955 [inline]
       vfs_set_acl+0x7fd/0xa60 fs/posix_acl.c:1134
       do_setxattr fs/xattr.c:626 [inline]
       path_setxattr+0x3bd/0x4d0 fs/xattr.c:658
       __do_sys_setxattr fs/xattr.c:676 [inline]
       __se_sys_setxattr fs/xattr.c:672 [inline]
       __x64_sys_setxattr+0xbb/0xd0 fs/xattr.c:672
       do_syscall_x64 arch/x86/entry/common.c:52 [inline]
       do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
       entry_SYSCALL_64_after_hwframe+0x77/0x7f

-> #3 (&oi->ip_xattr_sem){++++}-{3:3}:
       lock_acquire+0x1ed/0x550 kernel/locking/lockdep.c:5759
       down_read+0xb1/0xa40 kernel/locking/rwsem.c:1526
       ocfs2_init_acl+0x397/0x930 fs/ocfs2/acl.c:366
       ocfs2_mknod+0x1c05/0x2b40 fs/ocfs2/namei.c:408
       ocfs2_create+0x1ab/0x480 fs/ocfs2/namei.c:672
       vfs_create+0x23c/0x3d0 fs/namei.c:3280
       do_mknodat+0x447/0x5b0 fs/namei.c:4138
       __do_sys_mknodat fs/namei.c:4166 [inline]
       __se_sys_mknodat fs/namei.c:4163 [inline]
       __x64_sys_mknodat+0xa7/0xc0 fs/namei.c:4163
       do_syscall_x64 arch/x86/entry/common.c:52 [inline]
       do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
       entry_SYSCALL_64_after_hwframe+0x77/0x7f

-> #2 (jbd2_handle){.+.+}-{0:0}:
       lock_acquire+0x1ed/0x550 kernel/locking/lockdep.c:5759
       start_this_handle+0x1eb4/0x2110 fs/jbd2/transaction.c:448
       jbd2__journal_start+0x2da/0x5d0 fs/jbd2/transaction.c:505
       jbd2_journal_start+0x29/0x40 fs/jbd2/transaction.c:544
       ocfs2_start_trans+0x3c9/0x700 fs/ocfs2/journal.c:352
       ocfs2_mknod+0x150c/0x2b40 fs/ocfs2/namei.c:359
       ocfs2_create+0x1ab/0x480 fs/ocfs2/namei.c:672
       vfs_create+0x23c/0x3d0 fs/namei.c:3280
       do_mknodat+0x447/0x5b0 fs/namei.c:4138
       __do_sys_mknodat fs/namei.c:4166 [inline]
       __se_sys_mknodat fs/namei.c:4163 [inline]
       __x64_sys_mknodat+0xa7/0xc0 fs/namei.c:4163
       do_syscall_x64 arch/x86/entry/common.c:52 [inline]
       do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
       entry_SYSCALL_64_after_hwframe+0x77/0x7f

-> #1 (&journal->j_trans_barrier){.+.+}-{3:3}:
       lock_acquire+0x1ed/0x550 kernel/locking/lockdep.c:5759
       down_read+0xb1/0xa40 kernel/locking/rwsem.c:1526
       ocfs2_start_trans+0x3be/0x700 fs/ocfs2/journal.c:350
       ocfs2_mknod+0x150c/0x2b40 fs/ocfs2/namei.c:359
       ocfs2_create+0x1ab/0x480 fs/ocfs2/namei.c:672
       vfs_create+0x23c/0x3d0 fs/namei.c:3280
       do_mknodat+0x447/0x5b0 fs/namei.c:4138
       __do_sys_mknodat fs/namei.c:4166 [inline]
       __se_sys_mknodat fs/namei.c:4163 [inline]
       __x64_sys_mknodat+0xa7/0xc0 fs/namei.c:4163
       do_syscall_x64 arch/x86/entry/common.c:52 [inline]
       do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
       entry_SYSCALL_64_after_hwframe+0x77/0x7f

-> #0 (sb_internal#2){.+.+}-{0:0}:
       check_prev_add kernel/locking/lockdep.c:3133 [inline]
       check_prevs_add kernel/locking/lockdep.c:3252 [inline]
       validate_chain+0x18e0/0x5900 kernel/locking/lockdep.c:3868
       __lock_acquire+0x137a/0x2040 kernel/locking/lockdep.c:5142
       lock_acquire+0x1ed/0x550 kernel/locking/lockdep.c:5759
       percpu_down_read include/linux/percpu-rwsem.h:51 [inline]
       __sb_start_write include/linux/fs.h:1675 [inline]
       sb_start_intwrite include/linux/fs.h:1858 [inline]
       ocfs2_start_trans+0x2b9/0x700 fs/ocfs2/journal.c:348
       ocfs2_setattr+0xcb1/0x1f50 fs/ocfs2/file.c:1259
       notify_change+0xb9d/0xe70 fs/attr.c:495
       chmod_common+0x2ab/0x4c0 fs/open.c:654
       do_fchmodat fs/open.c:702 [inline]
       __do_sys_fchmodat fs/open.c:721 [inline]
       __se_sys_fchmodat fs/open.c:718 [inline]
       __x64_sys_fchmodat+0x11d/0x1c0 fs/open.c:718
       do_syscall_x64 arch/x86/entry/common.c:52 [inline]
       do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
       entry_SYSCALL_64_after_hwframe+0x77/0x7f

other info that might help us debug this:

Chain exists of:
  sb_internal#2 --> &oi->ip_xattr_sem --> &oi->ip_alloc_sem

 Possible unsafe locking scenario:

       CPU0                    CPU1
       ----                    ----
  lock(&oi->ip_alloc_sem);
                               lock(&oi->ip_xattr_sem);
                               lock(&oi->ip_alloc_sem);
  rlock(sb_internal#2);

 *** DEADLOCK ***

3 locks held by syz-executor408/5110:
 #0: ffff888037bf6420 (sb_writers#9){.+.+}-{0:0}, at: mnt_want_write+0x3f/0x90 fs/namespace.c:515
 #1: ffff88803c2bd100 (&sb->s_type->i_mutex_key#15){+.+.}-{3:3}, at: inode_lock include/linux/fs.h:799 [inline]
 #1: ffff88803c2bd100 (&sb->s_type->i_mutex_key#15){+.+.}-{3:3}, at: chmod_common+0x1bb/0x4c0 fs/open.c:648
 #2: ffff88803c2bcda0 (&oi->ip_alloc_sem){+.+.}-{3:3}, at: ocfs2_setattr+0xc9f/0x1f50 fs/ocfs2/file.c:1258

stack backtrace:
CPU: 0 UID: 0 PID: 5110 Comm: syz-executor408 Not tainted 6.11.0-rc4-syzkaller-00011-g521b1e7f4cf0 #0
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2~bpo12+1 04/01/2014
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:93 [inline]
 dump_stack_lvl+0x241/0x360 lib/dump_stack.c:119
 check_noncircular+0x36a/0x4a0 kernel/locking/lockdep.c:2186
 check_prev_add kernel/locking/lockdep.c:3133 [inline]
 check_prevs_add kernel/locking/lockdep.c:3252 [inline]
 validate_chain+0x18e0/0x5900 kernel/locking/lockdep.c:3868
 __lock_acquire+0x137a/0x2040 kernel/locking/lockdep.c:5142
 lock_acquire+0x1ed/0x550 kernel/locking/lockdep.c:5759
 percpu_down_read include/linux/percpu-rwsem.h:51 [inline]
 __sb_start_write include/linux/fs.h:1675 [inline]
 sb_start_intwrite include/linux/fs.h:1858 [inline]
 ocfs2_start_trans+0x2b9/0x700 fs/ocfs2/journal.c:348
 ocfs2_setattr+0xcb1/0x1f50 fs/ocfs2/file.c:1259
 notify_change+0xb9d/0xe70 fs/attr.c:495
 chmod_common+0x2ab/0x4c0 fs/open.c:654
 do_fchmodat fs/open.c:702 [inline]
 __do_sys_fchmodat fs/open.c:721 [inline]
 __se_sys_fchmodat fs/open.c:718 [inline]
 __x64_sys_fchmodat+0x11d/0x1c0 fs/open.c:718
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7ff865822659
Code: 28 00 00 00 75 05 48 83 c4 28 c3 e8 f1 17 00 00 90 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 b8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007fffa6552a68 EFLAGS: 00000246 ORIG_RAX: 000000000000010c
RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007ff865822659
RDX: 00000000000001ff RSI: 0000000020000440 RDI: 00000000ffffff9c
RBP: 0000000000000000 R08: 0000000000000000 R09: 00007fffa6552aa0
R10: 00007fffa6552a70 R11: 0000000000000246 R12: 00007fffa6552aa0
R13: 00007fffa6552d28 R14: 431bde82d7b634db R15: 00007ff86586b03b
 </TASK>


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
