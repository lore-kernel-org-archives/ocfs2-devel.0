Received: from mail-io1-f72.google.com (mail-io1-f72.google.com [209.85.166.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0AFE188596
	for <ocfs2-devel@lists.linux.dev>; Thu, 12 Sep 2024 20:21:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726172490; cv=none; b=NQj+pko0lb5VcSfWDCOVZPkVpTdE+5Hnkc5cePi6UPfVKzky81aqhI9JOUkWzaNsKs7nmjQIC5X81v2UM+tJbX6o8Ucnh/qT95bMi/WC3ucUyJAp6bS5dU1dtpcYPkPiu9sj6Q3i68rfEC7uUNg345g5MFT6bsQzC/7pDBK4d7g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726172490; c=relaxed/simple;
	bh=WJbU0yjfqD7F0VB8xTsKc/oaaUQEPb2hckBBfqTt6fA=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:
	 Content-Type; b=kKiTUFgLy3NFOBuWUOYA2KYyPKWYTX4Ol3ndUTrtZTk+5MKwMF/9TZfpG2/ctGJMUdBqG3dBBABLUD6/vYiQ4b5kXKPZzhE8DSItUvR1yEN+gzG3ZaAYJYWhYFkKjPt+dVTP+ufqxaQnomdfFVAg0R31cPuDd1VSNLbbmQKpgaU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-io1-f72.google.com with SMTP id ca18e2360f4ac-82b930cd6b2so30738639f.1
        for <ocfs2-devel@lists.linux.dev>; Thu, 12 Sep 2024 13:21:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726172488; x=1726777288;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=mw15KW7hW4yDCOMtnMTKG7+cerWG5MFarCG+RcQVqFo=;
        b=srqQ5ucBCgt+O3E7L5KzB5i68+aYXCTW1q1Fqv+NrFdEwqrP2+Y0KQsfQ48d7m5tOT
         xzVWuG1+graCP70ORz8NJFx9dJCVi+5wPtG553M5/w6w5ArLCr+jngMUVu9fThkmjgl1
         MXhMOUi4VmkXTaZhibURXgIBDcIHRRdpRcKfaJ+QIxJVBcW+cFo40fklFfqKji8+1aCc
         QaImx96IU3KOsu4gbe+xTFiY0kO8qCAV+ZHhRzhEj9TTyOx64NRIPeI/szc6Pq7xVypK
         q1DhkZr4iMV9M4f2mVUdlaVgKPWod99nx/FWU2+2kr9TA5ml/owwpoD/fGIOwziUGDYa
         py/Q==
X-Forwarded-Encrypted: i=1; AJvYcCWeQh6ofRVmlRc4J0srMeLHvdi3xYK91sQMzIuQKDGL7MTiFZOZy58m4VYSfKFWJFB57HuXawl4hAyVpg==@lists.linux.dev
X-Gm-Message-State: AOJu0Yxrzn2DbAmjB/fX1DncvX7MwgA/RpybZ6wzvujyZk1jrl0h1VRG
	u+I7t51+ARXJfZUCVxxroU7VDrVbbUIQBB4EUIF3Hx7zwBY6+o5GtVu57kZH0PaIp3KllvUlTpb
	sYatXI3kIztxtiMrKajpaGpQEkByaSO/PPZyxczyE4fgM2w7zl1by+84=
X-Google-Smtp-Source: AGHT+IEYwWAd0Ju3M2C14q7ab3xijDlwYPSs7hGRzMf2tQ+Gkymaca8alaH/IhF1nfS92extg8cDfgT/iPalR4amnuQIWGWMbHO9
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a92:c54f:0:b0:39b:2ceb:1a23 with SMTP id
 e9e14a558f8ab-3a08b6eaf31mr4766065ab.3.1726172487813; Thu, 12 Sep 2024
 13:21:27 -0700 (PDT)
Date: Thu, 12 Sep 2024 13:21:27 -0700
In-Reply-To: <0000000000008abaa00621e8d340@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000f51ea80621f1d98f@google.com>
Subject: Re: [syzbot] [ocfs2?] possible deadlock in ocfs2_write_begin_nolock
From: syzbot <syzbot+cf0ed67a79e4fadd9f91@syzkaller.appspotmail.com>
To: jlbec@evilplan.org, joseph.qi@linux.alibaba.com, 
	linux-kernel@vger.kernel.org, mark@fasheh.com, ocfs2-devel@lists.linux.dev, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

syzbot has found a reproducer for the following issue on:

HEAD commit:    77f587896757 Merge tag 'arm-fixes-6.11-3' of git://git.ker..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=16f960a9980000
kernel config:  https://syzkaller.appspot.com/x/.config?x=61d235cb8d15001c
dashboard link: https://syzkaller.appspot.com/bug?extid=cf0ed67a79e4fadd9f91
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=17343807980000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1325149f980000

Downloadable assets:
disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/7bc7510fe41f/non_bootable_disk-77f58789.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/984b5a502ad8/vmlinux-77f58789.xz
kernel image: https://storage.googleapis.com/syzbot-assets/4bea7acc421c/bzImage-77f58789.xz
mounted in repro: https://storage.googleapis.com/syzbot-assets/a71deb151482/mount_0.gz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+cf0ed67a79e4fadd9f91@syzkaller.appspotmail.com

=======================================================
ocfs2: Mounting device (7,0) on (node local, slot 0) with ordered data mode.
======================================================
WARNING: possible circular locking dependency detected
6.11.0-rc7-syzkaller-00039-g77f587896757 #0 Not tainted
------------------------------------------------------
syz-executor271/5102 is trying to acquire lock:
ffff88804048a610 (sb_internal#2){.+.+}-{0:0}, at: ocfs2_write_begin_inline fs/ocfs2/aops.c:1480 [inline]
ffff88804048a610 (sb_internal#2){.+.+}-{0:0}, at: ocfs2_try_to_write_inline_data fs/ocfs2/aops.c:1583 [inline]
ffff88804048a610 (sb_internal#2){.+.+}-{0:0}, at: ocfs2_write_begin_nolock+0x226b/0x4d30 fs/ocfs2/aops.c:1669

but task is already holding lock:
ffff888041fdcda0 (&oi->ip_alloc_sem){++++}-{3:3}, at: ocfs2_write_begin+0x1d1/0x3a0 fs/ocfs2/aops.c:1901

which lock already depends on the new lock.


the existing dependency chain (in reverse order) is:

-> #4 (&oi->ip_alloc_sem){++++}-{3:3}:
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
       __do_sys_lsetxattr fs/xattr.c:683 [inline]
       __se_sys_lsetxattr fs/xattr.c:679 [inline]
       __x64_sys_lsetxattr+0xb8/0xd0 fs/xattr.c:679
       do_syscall_x64 arch/x86/entry/common.c:52 [inline]
       do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
       entry_SYSCALL_64_after_hwframe+0x77/0x7f

-> #3 (&oi->ip_xattr_sem){++++}-{3:3}:
       lock_acquire+0x1ed/0x550 kernel/locking/lockdep.c:5759
       down_read+0xb1/0xa40 kernel/locking/rwsem.c:1526
       ocfs2_init_acl+0x397/0x930 fs/ocfs2/acl.c:366
       ocfs2_mknod+0x1c05/0x2b40 fs/ocfs2/namei.c:408
       ocfs2_mkdir+0x1ab/0x480 fs/ocfs2/namei.c:655
       vfs_mkdir+0x2f9/0x4f0 fs/namei.c:4210
       do_mkdirat+0x264/0x3a0 fs/namei.c:4233
       __do_sys_mkdirat fs/namei.c:4248 [inline]
       __se_sys_mkdirat fs/namei.c:4246 [inline]
       __x64_sys_mkdirat+0x87/0xa0 fs/namei.c:4246
       do_syscall_x64 arch/x86/entry/common.c:52 [inline]
       do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
       entry_SYSCALL_64_after_hwframe+0x77/0x7f

-> #2 (jbd2_handle){++++}-{0:0}:
       lock_acquire+0x1ed/0x550 kernel/locking/lockdep.c:5759
       start_this_handle+0x1eb4/0x2110 fs/jbd2/transaction.c:448
       jbd2__journal_start+0x2da/0x5d0 fs/jbd2/transaction.c:505
       jbd2_journal_start+0x29/0x40 fs/jbd2/transaction.c:544
       ocfs2_start_trans+0x3c9/0x700 fs/ocfs2/journal.c:352
       ocfs2_mknod+0x150c/0x2b40 fs/ocfs2/namei.c:359
       ocfs2_mkdir+0x1ab/0x480 fs/ocfs2/namei.c:655
       vfs_mkdir+0x2f9/0x4f0 fs/namei.c:4210
       do_mkdirat+0x264/0x3a0 fs/namei.c:4233
       __do_sys_mkdirat fs/namei.c:4248 [inline]
       __se_sys_mkdirat fs/namei.c:4246 [inline]
       __x64_sys_mkdirat+0x87/0xa0 fs/namei.c:4246
       do_syscall_x64 arch/x86/entry/common.c:52 [inline]
       do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
       entry_SYSCALL_64_after_hwframe+0x77/0x7f

-> #1 (&journal->j_trans_barrier){.+.+}-{3:3}:
       lock_acquire+0x1ed/0x550 kernel/locking/lockdep.c:5759
       down_read+0xb1/0xa40 kernel/locking/rwsem.c:1526
       ocfs2_start_trans+0x3be/0x700 fs/ocfs2/journal.c:350
       ocfs2_mknod+0x150c/0x2b40 fs/ocfs2/namei.c:359
       ocfs2_mkdir+0x1ab/0x480 fs/ocfs2/namei.c:655
       vfs_mkdir+0x2f9/0x4f0 fs/namei.c:4210
       do_mkdirat+0x264/0x3a0 fs/namei.c:4233
       __do_sys_mkdirat fs/namei.c:4248 [inline]
       __se_sys_mkdirat fs/namei.c:4246 [inline]
       __x64_sys_mkdirat+0x87/0xa0 fs/namei.c:4246
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
       __sb_start_write include/linux/fs.h:1676 [inline]
       sb_start_intwrite include/linux/fs.h:1859 [inline]
       ocfs2_start_trans+0x2b9/0x700 fs/ocfs2/journal.c:348
       ocfs2_write_begin_inline fs/ocfs2/aops.c:1480 [inline]
       ocfs2_try_to_write_inline_data fs/ocfs2/aops.c:1583 [inline]
       ocfs2_write_begin_nolock+0x226b/0x4d30 fs/ocfs2/aops.c:1669
       ocfs2_write_begin+0x205/0x3a0 fs/ocfs2/aops.c:1903
       generic_perform_write+0x399/0x840 mm/filemap.c:4019
       ocfs2_file_write_iter+0x17b4/0x1f60 fs/ocfs2/file.c:2455
       new_sync_write fs/read_write.c:497 [inline]
       vfs_write+0xa72/0xc90 fs/read_write.c:590
       ksys_write+0x1a0/0x2c0 fs/read_write.c:643
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

3 locks held by syz-executor271/5102:
 #0: ffff88804048a420 (sb_writers#9){.+.+}-{0:0}, at: file_start_write include/linux/fs.h:2882 [inline]
 #0: ffff88804048a420 (sb_writers#9){.+.+}-{0:0}, at: vfs_write+0x227/0xc90 fs/read_write.c:586
 #1: ffff888041fdd100 (&sb->s_type->i_mutex_key#15){+.+.}-{3:3}, at: inode_lock include/linux/fs.h:800 [inline]
 #1: ffff888041fdd100 (&sb->s_type->i_mutex_key#15){+.+.}-{3:3}, at: ocfs2_file_write_iter+0x46a/0x1f60 fs/ocfs2/file.c:2387
 #2: ffff888041fdcda0 (&oi->ip_alloc_sem){++++}-{3:3}, at: ocfs2_write_begin+0x1d1/0x3a0 fs/ocfs2/aops.c:1901

stack backtrace:
CPU: 0 UID: 0 PID: 5102 Comm: syz-executor271 Not tainted 6.11.0-rc7-syzkaller-00039-g77f587896757 #0
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
 __sb_start_write include/linux/fs.h:1676 [inline]
 sb_start_intwrite include/linux/fs.h:1859 [inline]
 ocfs2_start_trans+0x2b9/0x700 fs/ocfs2/journal.c:348
 ocfs2_write_begin_inline fs/ocfs2/aops.c:1480 [inline]
 ocfs2_try_to_write_inline_data fs/ocfs2/aops.c:1583 [inline]
 ocfs2_write_begin_nolock+0x226b/0x4d30 fs/ocfs2/aops.c:1669
 ocfs2_write_begin+0x205/0x3a0 fs/ocfs2/aops.c:1903
 generic_perform_write+0x399/0x840 mm/filemap.c:4019
 ocfs2_file_write_iter+0x17b4/0x1f60 fs/ocfs2/file.c:2455
 new_sync_write fs/read_write.c:497 [inline]
 vfs_write+0xa72/0xc90 fs/read_write.c:590
 ksys_write+0x1a0/0x2c0 fs/read_write.c:643
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7fa601be8f19
Code: 28 00 00 00 75 05 48 83 c4 28 c3 e8 f1 17 00 00 90 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 b8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007ffc8af27958 EFLAGS: 00000246 ORIG_RAX: 0000000000000001
RAX: ffffffffffffffda RBX: 0031656c69662f2e RCX: 00007fa601be8f19
RDX: 0000000000000020 RSI: 0000000020000840 RDI: 0000000000000004
RBP: 00007fa601c615f0 R08: 000055556916e4c0 R09: 000055556916e4c0
R10: 000055556916e4c0 R11: 0000000000000246 R12: 00007ffc8af27980
R13: 00007ffc8af27ba8 R14: 431bde82d7b634db R15: 00007fa601c3203b
 </TASK>


---
If you want syzbot to run the reproducer, reply with:
#syz test: git://repo/address.git branch-or-commit-hash
If you attach or paste a git patch, syzbot will apply it before testing.
