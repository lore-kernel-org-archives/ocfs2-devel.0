Received: from mail-il1-f200.google.com (mail-il1-f200.google.com [209.85.166.200])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9199E149E14
	for <ocfs2-devel@lists.linux.dev>; Thu, 22 Aug 2024 12:35:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.200
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724330129; cv=none; b=AdbXQ8yWkpxdURxCyUASwPwpZ2tBdZd4w08jGQsyoQe3lXH86AVGpZq5A5FOnx0oEWaz185H/V7oyLINKgiLmAnV6b81IcbXf1f0yEajzfj1jm/8L3KrrJDkbvLLDjMJ7bbhGXpC+eHsKBy+/cGcCsfJmx28OVbRBNUUzmwp19k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724330129; c=relaxed/simple;
	bh=IkZxBXj/CXklXxDuvbSJXRW3y5ayUqHyzd0lkixiaKU=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=e9Wo5CB3ouYzu2xcoafn/Pexpf4vBvkOtIRRe5hEShhW98Wl85ncPF8uLeI7Cqea/cLimwXRx1zusG9rqmZap+J4xscOxvsuviA7sDFnrwmLIGBlq1RQ5NE5Er3YI4IcYHccnzlNFXOsfJnhMSera6RKO0Xs9Ak83yP554BCgaY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.200
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f200.google.com with SMTP id e9e14a558f8ab-39d4cef7aa7so8091505ab.0
        for <ocfs2-devel@lists.linux.dev>; Thu, 22 Aug 2024 05:35:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724330126; x=1724934926;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=lwC46UPBLj+jM4bWPN3/Khsl8q35sVPzcbgMlt0tEQc=;
        b=ryXl2A29KxMriWQDAQ9JfapdiO6jsDy/WWuDC6Muhaf7GKu+PXueEwvLcggCGiCMHd
         zEDqayLxEG/czM1F4gYhVIwigyKHmhjtgo3zlkF+dKC+Lyz1BpqjkUeVDgyXe1DRAdG3
         avASQO8FNz3rQQUFBmq+BphBHsZH3A6+9YhuoGV+w2wURLjw0XmGlHJdENthUFr0eArc
         wHqfRql/VdHyK1PIOicwHxOMOYrXUVExKXDBONYtma41pISE0ArX25cQ4dkXmEFRe92f
         N1YTgFS+ZnHaKfSTIq2WDlGxJK2zsRU31BnA4ke1qeE5OeK5DfB7PoQA5Bf7Y98kCdkI
         cUpQ==
X-Forwarded-Encrypted: i=1; AJvYcCVMsfMMQTGWzjIouVTDr5dFMSTt0FI9hqmmMIzHp7Qd9RbL/uTIveAInYlC5+JSD/oNt1hJ1F8P041DRQ==@lists.linux.dev
X-Gm-Message-State: AOJu0YxAVQ2oUnugmpFJff46FAmbsqmDQIvU5By0aTczcm4iXS0Fz3Kp
	LK1e/3LhJdkMa6dfTUJIzs/vCpBRlFLlPTOCeyDNu2dnP0kYfQKHvOEhc7xy7DZgjNwY9SWyDnK
	kKUTkfRCKLaxwbh0pfi3k/UUhqhTz9xjngw6fgg1ffCnl0b4GYJMzRF0=
X-Google-Smtp-Source: AGHT+IGvIzWcbPLH1AntE5Y6kTojLEcexcJIH4sb+HNCUNm0ghHMPsL4lzlzbwre8OC7RD1/TW5pjoerg8m90KQhzMCi0QjIghL4
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1646:b0:39d:300f:e91c with SMTP id
 e9e14a558f8ab-39d6c5db5b7mr4041665ab.5.1724330126620; Thu, 22 Aug 2024
 05:35:26 -0700 (PDT)
Date: Thu, 22 Aug 2024 05:35:26 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000ac4a9d062044e498@google.com>
Subject: [syzbot] [ocfs2?] possible deadlock in ocfs2_reserve_local_alloc_bits
From: syzbot <syzbot+843fa26882088a9ee7e3@syzkaller.appspotmail.com>
To: jlbec@evilplan.org, joseph.qi@linux.alibaba.com, 
	linux-kernel@vger.kernel.org, mark@fasheh.com, ocfs2-devel@lists.linux.dev, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    c3f2d783a459 Merge tag 'mm-hotfixes-stable-2024-08-17-19-3..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=12ee0d83980000
kernel config:  https://syzkaller.appspot.com/x/.config?x=7229118d88b4a71b
dashboard link: https://syzkaller.appspot.com/bug?extid=843fa26882088a9ee7e3
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/7bc7510fe41f/non_bootable_disk-c3f2d783.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/4d927f7c3cfd/vmlinux-c3f2d783.xz
kernel image: https://storage.googleapis.com/syzbot-assets/ea54bdfad24b/bzImage-c3f2d783.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+843fa26882088a9ee7e3@syzkaller.appspotmail.com

loop0: detected capacity change from 0 to 32768
JBD2: Ignoring recovery information on journal
ocfs2: Mounting device (7,0) on (node local, slot 0) with writeback data mode.
loop0: detected capacity change from 32768 to 0
======================================================
WARNING: possible circular locking dependency detected
6.11.0-rc3-syzkaller-00338-gc3f2d783a459 #0 Not tainted
------------------------------------------------------
syz.0.0/5109 is trying to acquire lock:
ffff88801da72640 (&ocfs2_sysfile_lock_key[args->fi_sysfile_type]#4){+.+.}-{3:3}, at: inode_lock include/linux/fs.h:799 [inline]
ffff88801da72640 (&ocfs2_sysfile_lock_key[args->fi_sysfile_type]#4){+.+.}-{3:3}, at: ocfs2_reserve_local_alloc_bits+0x132/0x2870 fs/ocfs2/localalloc.c:636

but task is already holding lock:
ffff88801da74da0 (&oi->ip_alloc_sem){+.+.}-{3:3}, at: __ocfs2_change_file_space+0x802/0xfd0 fs/ocfs2/file.c:2003

which lock already depends on the new lock.


the existing dependency chain (in reverse order) is:

-> #5 (&oi->ip_alloc_sem){+.+.}-{3:3}:
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

-> #4 (&oi->ip_xattr_sem){++++}-{3:3}:
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

-> #3 (jbd2_handle){++++}-{0:0}:
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

-> #2 (&journal->j_trans_barrier){.+.+}-{3:3}:
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

-> #1 (sb_internal#2){.+.+}-{0:0}:
       lock_acquire+0x1ed/0x550 kernel/locking/lockdep.c:5759
       percpu_down_read include/linux/percpu-rwsem.h:51 [inline]
       __sb_start_write include/linux/fs.h:1675 [inline]
       sb_start_intwrite include/linux/fs.h:1858 [inline]
       ocfs2_start_trans+0x2b9/0x700 fs/ocfs2/journal.c:348
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

-> #0 (&ocfs2_sysfile_lock_key[args->fi_sysfile_type]#4){+.+.}-{3:3}:
       check_prev_add kernel/locking/lockdep.c:3133 [inline]
       check_prevs_add kernel/locking/lockdep.c:3252 [inline]
       validate_chain+0x18e0/0x5900 kernel/locking/lockdep.c:3868
       __lock_acquire+0x137a/0x2040 kernel/locking/lockdep.c:5142
       lock_acquire+0x1ed/0x550 kernel/locking/lockdep.c:5759
       down_write+0x99/0x220 kernel/locking/rwsem.c:1579
       inode_lock include/linux/fs.h:799 [inline]
       ocfs2_reserve_local_alloc_bits+0x132/0x2870 fs/ocfs2/localalloc.c:636
       ocfs2_reserve_clusters_with_limit+0x1b8/0xb60 fs/ocfs2/suballoc.c:1166
       ocfs2_reserve_clusters fs/ocfs2/suballoc.c:1227 [inline]
       ocfs2_lock_allocators+0x30a/0x630 fs/ocfs2/suballoc.c:2746
       ocfs2_extend_allocation+0x4ed/0x1c20 fs/ocfs2/file.c:589
       ocfs2_allocate_unwritten_extents+0x398/0x9f0 fs/ocfs2/file.c:1492
       __ocfs2_change_file_space+0x980/0xfd0 fs/ocfs2/file.c:2011
       ocfs2_fallocate+0x2e7/0x350 fs/ocfs2/file.c:2126
       vfs_fallocate+0x553/0x6c0 fs/open.c:334
       do_vfs_ioctl+0x2592/0x2e50 fs/ioctl.c:886
       __do_sys_ioctl fs/ioctl.c:905 [inline]
       __se_sys_ioctl+0x81/0x170 fs/ioctl.c:893
       do_syscall_x64 arch/x86/entry/common.c:52 [inline]
       do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
       entry_SYSCALL_64_after_hwframe+0x77/0x7f

other info that might help us debug this:

Chain exists of:
  &ocfs2_sysfile_lock_key[args->fi_sysfile_type]#4 --> &oi->ip_xattr_sem --> &oi->ip_alloc_sem

 Possible unsafe locking scenario:

       CPU0                    CPU1
       ----                    ----
  lock(&oi->ip_alloc_sem);
                               lock(&oi->ip_xattr_sem);
                               lock(&oi->ip_alloc_sem);
  lock(&ocfs2_sysfile_lock_key[args->fi_sysfile_type]#4);

 *** DEADLOCK ***

3 locks held by syz.0.0/5109:
 #0: ffff888046ed4420 (sb_writers#10){.+.+}-{0:0}, at: file_start_write include/linux/fs.h:2881 [inline]
 #0: ffff888046ed4420 (sb_writers#10){.+.+}-{0:0}, at: vfs_fallocate+0x4ea/0x6c0 fs/open.c:333
 #1: ffff88801da75100 (&sb->s_type->i_mutex_key#19){+.+.}-{3:3}, at: inode_lock include/linux/fs.h:799 [inline]
 #1: ffff88801da75100 (&sb->s_type->i_mutex_key#19){+.+.}-{3:3}, at: __ocfs2_change_file_space+0x201/0xfd0 fs/ocfs2/file.c:1937
 #2: ffff88801da74da0 (&oi->ip_alloc_sem){+.+.}-{3:3}, at: __ocfs2_change_file_space+0x802/0xfd0 fs/ocfs2/file.c:2003

stack backtrace:
CPU: 0 UID: 0 PID: 5109 Comm: syz.0.0 Not tainted 6.11.0-rc3-syzkaller-00338-gc3f2d783a459 #0
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
 down_write+0x99/0x220 kernel/locking/rwsem.c:1579
 inode_lock include/linux/fs.h:799 [inline]
 ocfs2_reserve_local_alloc_bits+0x132/0x2870 fs/ocfs2/localalloc.c:636
 ocfs2_reserve_clusters_with_limit+0x1b8/0xb60 fs/ocfs2/suballoc.c:1166
 ocfs2_reserve_clusters fs/ocfs2/suballoc.c:1227 [inline]
 ocfs2_lock_allocators+0x30a/0x630 fs/ocfs2/suballoc.c:2746
 ocfs2_extend_allocation+0x4ed/0x1c20 fs/ocfs2/file.c:589
 ocfs2_allocate_unwritten_extents+0x398/0x9f0 fs/ocfs2/file.c:1492
 __ocfs2_change_file_space+0x980/0xfd0 fs/ocfs2/file.c:2011
 ocfs2_fallocate+0x2e7/0x350 fs/ocfs2/file.c:2126
 vfs_fallocate+0x553/0x6c0 fs/open.c:334
 do_vfs_ioctl+0x2592/0x2e50 fs/ioctl.c:886
 __do_sys_ioctl fs/ioctl.c:905 [inline]
 __se_sys_ioctl+0x81/0x170 fs/ioctl.c:893
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7fb1255799b9
Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 a8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007fb12633d038 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
RAX: ffffffffffffffda RBX: 00007fb125715f80 RCX: 00007fb1255799b9
RDX: 00000000200007c0 RSI: 0000000040305828 RDI: 0000000000000005
RBP: 00007fb1255e78d8 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 0000000000000000 R14: 00007fb125715f80 R15: 00007ffd9437cdb8
 </TASK>
syz.0.0: attempt to access beyond end of device
loop0: rw=0, sector=23, nr_sectors = 1 limit=0
(syz.0.0,5109,0):ocfs2_assign_bh:2416 ERROR: status = -5
(syz.0.0,5109,0):ocfs2_inode_lock_full_nested:2511 ERROR: status = -5
(syz.0.0,5109,0):ocfs2_reserve_suballoc_bits:793 ERROR: status = -5
(syz.0.0,5109,0):ocfs2_reserve_cluster_bitmap_bits:1137 ERROR: status = -5
(syz.0.0,5109,0):ocfs2_local_alloc_reserve_for_window:1117 ERROR: status = -5
(syz.0.0,5109,0):ocfs2_local_alloc_reserve_for_window:1133 ERROR: status = -5
(syz.0.0,5109,0):ocfs2_local_alloc_slide_window:1248 ERROR: status = -5
(syz.0.0,5109,0):ocfs2_local_alloc_slide_window:1315 ERROR: status = -5
(syz.0.0,5109,0):ocfs2_reserve_local_alloc_bits:672 ERROR: status = -5
(syz.0.0,5109,0):ocfs2_reserve_local_alloc_bits:710 ERROR: status = -5
(syz.0.0,5109,0):ocfs2_reserve_clusters_with_limit:1170 ERROR: status = -5
(syz.0.0,5109,0):ocfs2_reserve_clusters_with_limit:1219 ERROR: status = -5
(syz.0.0,5109,0):ocfs2_lock_allocators:2749 ERROR: status = -5
(syz.0.0,5109,0):ocfs2_extend_allocation:592 ERROR: status = -5
(syz.0.0,5109,0):ocfs2_allocate_unwritten_extents:1495 ERROR: status = -5
(syz.0.0,5109,0):__ocfs2_change_file_space:2033 ERROR: status = -5


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
