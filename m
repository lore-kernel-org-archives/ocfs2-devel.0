Received: from mail-io1-f70.google.com (mail-io1-f70.google.com [209.85.166.70])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73AB2188910
	for <ocfs2-devel@lists.linux.dev>; Thu, 12 Sep 2024 09:35:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.70
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726133728; cv=none; b=iJ6fXghb16GTeu+a5YitQdsGqHGGY72YMoI9s5IX9fh8PLj6mWd0LvWjIxKa/gk+n9og2AIRNnzsNpQ/BZi6RcIRWNMNc7iWEziPHINseHWBcZ2vIQZ1uOFMk7n1/8uk5qUS+3am/7vAJdmbV7D9vhYCWFQS1b8/WniGEhcfmy4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726133728; c=relaxed/simple;
	bh=wFhCi5VmSJlgtwgAu7Pd9/mRRVOe5wUKgRfaHpKkULc=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=Tl90fnM0AF+bbor3lw9HccxxKqvtjYLwFIUaS7yp8D/WYKvOf0zJz7Gc0SMEjoVIz4/+wFGGuEhUJ0psNMw9fo7irRIli6si6i8wgxR/CK55iTthleNje6LpAH/u+INWiM6a7dSXHktI/ugnK6vrIKdsumQpnNBO0y5WY4ZqU5w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.70
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-io1-f70.google.com with SMTP id ca18e2360f4ac-82cd682f1d2so113671839f.3
        for <ocfs2-devel@lists.linux.dev>; Thu, 12 Sep 2024 02:35:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726133725; x=1726738525;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=leSsjH7jxikPbIcZP28apZ0TC6eXU6I+eLmVefOLtzo=;
        b=Qib6l7wQExyatcp3YKrFnTQbzwk0My0rh/SBD2XsHg4jZ9/+bkYdQunxijZ7OGlREx
         RuDaJTvAEeAV9k/4WIUdBto4wqqt5c1OfefrfnOsHlQBO0EnnEqGij0ETDipcsWT46Bd
         1W5Tt/RL8SiTTtevdN5ntH5W34xjn2pcta1OGPHIowbmO2kd3OvqgjN6fgqJDRfFx0CT
         fBnigAAOSYdJJFORir+pPwBwmwcL9F0xiv/y3aAY4JUvmVsAJiKskfWsfLxvVlBo88bA
         6t0aEHtipFBTdEETnL6qDjxb/mW11VSb0hr0Qhz9XTQ8KcbYAAraOoGQUCTn41lVBiOa
         sv+w==
X-Forwarded-Encrypted: i=1; AJvYcCUeIiy+hzoS8cUSz+cNhNkz1GuZl+7cI6A9oIxXVW3OaefkvphT2mbrJd6BQ1pEBitBg0Id6wyifzgVog==@lists.linux.dev
X-Gm-Message-State: AOJu0YwT36G3vLkhfCwgus4X+yN7eUKXfr+i2IR/zxyJ1PudpizRt7ja
	XskpLI5O1bLda+bNipSGmAJwIGt5BtBMSqpnaQz4SA8LYTsOldIYMiLIHe4mmGQtMYFv04eD3Rm
	Cx00lvvLGspS9xsu6IAzKobMEfTQG1ok4OTVElQEcGGADc5o1TVNCjRU=
X-Google-Smtp-Source: AGHT+IFik8hWZiJnMlHkx+JEQxGT2Dx65fwyeW5mk+X4+YSP+S0+4WFY4ge97ftbPXpTKomBGErXddjbhpqp9R3Ksf5UA5KuiOeH
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a92:c267:0:b0:39d:47cf:2c7f with SMTP id
 e9e14a558f8ab-3a08494dc27mr19692185ab.24.1726133725471; Thu, 12 Sep 2024
 02:35:25 -0700 (PDT)
Date: Thu, 12 Sep 2024 02:35:25 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000008abaa00621e8d340@google.com>
Subject: [syzbot] [ocfs2?] possible deadlock in ocfs2_write_begin_nolock
From: syzbot <syzbot+cf0ed67a79e4fadd9f91@syzkaller.appspotmail.com>
To: jlbec@evilplan.org, joseph.qi@linux.alibaba.com, 
	linux-kernel@vger.kernel.org, mark@fasheh.com, ocfs2-devel@lists.linux.dev, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    8d8d276ba2fb Merge tag 'trace-v6.11-rc6' of git://git.kern..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=1478649f980000
kernel config:  https://syzkaller.appspot.com/x/.config?x=61d235cb8d15001c
dashboard link: https://syzkaller.appspot.com/bug?extid=cf0ed67a79e4fadd9f91
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/7bc7510fe41f/non_bootable_disk-8d8d276b.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/d23708af23a4/vmlinux-8d8d276b.xz
kernel image: https://storage.googleapis.com/syzbot-assets/1aed2837c105/bzImage-8d8d276b.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+cf0ed67a79e4fadd9f91@syzkaller.appspotmail.com

loop0: detected capacity change from 0 to 32768
=======================================================
WARNING: The mand mount option has been deprecated and
         and is ignored by this kernel. Remove the mand
         option from the mount to silence this warning.
=======================================================
ocfs2: Mounting device (7,0) on (node local, slot 0) with ordered data mode.
======================================================
WARNING: possible circular locking dependency detected
6.11.0-rc7-syzkaller-00020-g8d8d276ba2fb #0 Not tainted
------------------------------------------------------
syz.0.0/5113 is trying to acquire lock:
ffff88803dd20610 (sb_internal#2){.+.+}-{0:0}, at: ocfs2_write_begin_inline fs/ocfs2/aops.c:1480 [inline]
ffff88803dd20610 (sb_internal#2){.+.+}-{0:0}, at: ocfs2_try_to_write_inline_data fs/ocfs2/aops.c:1583 [inline]
ffff88803dd20610 (sb_internal#2){.+.+}-{0:0}, at: ocfs2_write_begin_nolock+0x226b/0x4d30 fs/ocfs2/aops.c:1669

but task is already holding lock:
ffff88803d8adbe0 (&oi->ip_alloc_sem){++++}-{3:3}, at: ocfs2_write_begin+0x1d1/0x3a0 fs/ocfs2/aops.c:1901

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

4 locks held by syz.0.0/5113:
 #0: ffff8880127505c8 (&f->f_pos_lock){+.+.}-{3:3}, at: __fdget_pos+0x24e/0x310 fs/file.c:1187
 #1: ffff88803dd20420 (sb_writers#10){.+.+}-{0:0}, at: file_start_write include/linux/fs.h:2882 [inline]
 #1: ffff88803dd20420 (sb_writers#10){.+.+}-{0:0}, at: vfs_write+0x227/0xc90 fs/read_write.c:586
 #2: ffff88803d8adf40 (&sb->s_type->i_mutex_key#19){+.+.}-{3:3}, at: inode_lock include/linux/fs.h:800 [inline]
 #2: ffff88803d8adf40 (&sb->s_type->i_mutex_key#19){+.+.}-{3:3}, at: ocfs2_file_write_iter+0x46a/0x1f60 fs/ocfs2/file.c:2387
 #3: ffff88803d8adbe0 (&oi->ip_alloc_sem){++++}-{3:3}, at: ocfs2_write_begin+0x1d1/0x3a0 fs/ocfs2/aops.c:1901

stack backtrace:
CPU: 0 UID: 0 PID: 5113 Comm: syz.0.0 Not tainted 6.11.0-rc7-syzkaller-00020-g8d8d276ba2fb #0
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
RIP: 0033:0x7f082557def9
Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 a8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f08263b3038 EFLAGS: 00000246 ORIG_RAX: 0000000000000001
RAX: ffffffffffffffda RBX: 00007f0825735f80 RCX: 00007f082557def9
RDX: 0000000000000004 RSI: 0000000020000300 RDI: 0000000000000005
RBP: 00007f08255f0b56 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 0000000000000000 R14: 00007f0825735f80 R15: 00007ffcf3da0618
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
