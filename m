Received: from mail-io1-f69.google.com (mail-io1-f69.google.com [209.85.166.69])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90A0828366
	for <ocfs2-devel@lists.linux.dev>; Sat, 24 Aug 2024 04:12:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.69
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724472742; cv=none; b=gvWkvitVHCwtZ5eWqSEheXGwNo9cszhesmP6shsKGA6Cs2/5evsJQ/ej4LhCPH66AXSVm3xUbLO1sAg9bA0ZZ6TF8WH6eWzZJzuA6jjV4ZZcReDHazRn1/P7rjmJQTEz+ous/FLD986ESYgS3cHkkTlmS0yqx3OgwiwS4ddc+sM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724472742; c=relaxed/simple;
	bh=3Hg/+JdhvmmruX2BkgMzRXqN5JfcEtUFzDuqVnFsjRs=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=PHcCjqAChqpfLB5STQ+8nxVWduQYRqQSf76+Zph7knBCVXpBiPpmP8zU7VvrXwcVrEjScEptHSLW2K9/JbSbeWzlMg/0H7jzx5I4e/EnRoyDL+AMmmedDHo64cjVDHKIINoeXDOSE8A0I0K1K05kkwbeJ/qsHmWfagrjTpsenKM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.69
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-io1-f69.google.com with SMTP id ca18e2360f4ac-827878b991aso119746239f.1
        for <ocfs2-devel@lists.linux.dev>; Fri, 23 Aug 2024 21:12:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724472739; x=1725077539;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=D7YrByh8sw5nd1K2nILBCT5sL4APdAIC+GLc8U04iyk=;
        b=IEaPp0do43rPSoqOxS5J+ZsgDayNcFD9z10EIBGqNAEhIW1MfXSyvc3MZ36MdrhPW1
         G9briGWqiRJYjYYB+8lJeXDlJVgyyl7IRABvhm+TtPJG1yq9d1BsuWedZj9tIio9eMVK
         JRAOD/AC+ukErBLswYEu3prL9tUgD4e5sHIBzSO0mm0pQM1IZOKGqk/3Mxyi5iqyyGMy
         gt3me892z42507gDWNjU31fpH8XLFLkeIoKvxFf3+W223r4S4zcyM8E/KBSI9hZlaYHz
         LzQrjPy9QIpFRv9lh6WVK3tT3mShVXAEu9deVILsNPTLdrGncXSZ52uxuy4f6N0Sj/yj
         SLJA==
X-Forwarded-Encrypted: i=1; AJvYcCVfAVQeTl6bMCJ0NPBGsiOTPTlwnvTwBABk6K5qZXAS+rCskbG3GCUbCMHW+Lu434EbwxxFSLmxifX/+w==@lists.linux.dev
X-Gm-Message-State: AOJu0YwlUTagY9uQ4nV9MyNJfxD+fW3cqRV8myI9DxOCO9swxNLL2QjT
	dNZngSCs78mdnQ7lI2gML8A0vik8Eohul1PysqTUNlwh9HrigCdvfoXnpyaAHtpoHK2dpmV1nce
	60z27GibtxC5vvj/LuSa/aYW79ulmN1BLjN22GICn65NgqIAtXFPRu1A=
X-Google-Smtp-Source: AGHT+IHXQz9L47e7Uvdu0z3h/C9xAeZfrgh8DZebLI3C5M3S5ukgSLaQusRxpcjJPurh96rr3Zb3CU6sk+KiDoPqRTTTL7r02E5x
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6638:8925:b0:4b9:e5b4:67fd with SMTP id
 8926c6da1cb9f-4ce82841568mr289287173.1.1724472739452; Fri, 23 Aug 2024
 21:12:19 -0700 (PDT)
Date: Fri, 23 Aug 2024 21:12:19 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000000f69e106206619b6@google.com>
Subject: [syzbot] [ocfs2?] possible deadlock in ocfs2_truncate_file
From: syzbot <syzbot+2515179cbeb82ea01c88@syzkaller.appspotmail.com>
To: jlbec@evilplan.org, joseph.qi@linux.alibaba.com, 
	linux-kernel@vger.kernel.org, mark@fasheh.com, ocfs2-devel@lists.linux.dev, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    521b1e7f4cf0 Merge tag 'cxl-fixes-6.11-rc5' of git://git.k..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=112be5d5980000
kernel config:  https://syzkaller.appspot.com/x/.config?x=df2f0ed7e30a639d
dashboard link: https://syzkaller.appspot.com/bug?extid=2515179cbeb82ea01c88
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/7bc7510fe41f/non_bootable_disk-521b1e7f.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/fc256e887f7f/vmlinux-521b1e7f.xz
kernel image: https://storage.googleapis.com/syzbot-assets/0ecca3914e31/bzImage-521b1e7f.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+2515179cbeb82ea01c88@syzkaller.appspotmail.com

loop0: detected capacity change from 0 to 32768
JBD2: Ignoring recovery information on journal
ocfs2: Mounting device (7,0) on (node local, slot 0) with writeback data mode.
======================================================
WARNING: possible circular locking dependency detected
6.11.0-rc4-syzkaller-00011-g521b1e7f4cf0 #0 Not tainted
------------------------------------------------------
syz.0.0/5103 is trying to acquire lock:
ffff88803a9dc610 (sb_internal#2){.+.+}-{0:0}, at: ocfs2_orphan_for_truncate fs/ocfs2/file.c:396 [inline]
ffff88803a9dc610 (sb_internal#2){.+.+}-{0:0}, at: ocfs2_truncate_file+0x68c/0x1560 fs/ocfs2/file.c:500

but task is already holding lock:
ffff888011bbcda0 (&oi->ip_alloc_sem){+.+.}-{3:3}, at: ocfs2_truncate_file+0x372/0x1560 fs/ocfs2/file.c:471

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

-> #2 (jbd2_handle){++++}-{0:0}:
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
       ocfs2_orphan_for_truncate fs/ocfs2/file.c:396 [inline]
       ocfs2_truncate_file+0x68c/0x1560 fs/ocfs2/file.c:500
       ocfs2_setattr+0x1217/0x1f50 fs/ocfs2/file.c:1208
       notify_change+0xb9d/0xe70 fs/attr.c:495
       do_truncate+0x220/0x310 fs/open.c:65
       handle_truncate fs/namei.c:3381 [inline]
       do_open fs/namei.c:3731 [inline]
       path_openat+0x2ced/0x3470 fs/namei.c:3886
       do_filp_open+0x235/0x490 fs/namei.c:3913
       do_sys_openat2+0x13e/0x1d0 fs/open.c:1416
       do_sys_open fs/open.c:1431 [inline]
       __do_sys_openat fs/open.c:1447 [inline]
       __se_sys_openat fs/open.c:1442 [inline]
       __x64_sys_openat+0x247/0x2a0 fs/open.c:1442
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

3 locks held by syz.0.0/5103:
 #0: ffff88803a9dc420 (sb_writers#10){.+.+}-{0:0}, at: mnt_want_write+0x3f/0x90 fs/namespace.c:515
 #1: ffff888011bbd100 (&sb->s_type->i_mutex_key#19){+.+.}-{3:3}, at: inode_lock include/linux/fs.h:799 [inline]
 #1: ffff888011bbd100 (&sb->s_type->i_mutex_key#19){+.+.}-{3:3}, at: do_truncate+0x20c/0x310 fs/open.c:63
 #2: ffff888011bbcda0 (&oi->ip_alloc_sem){+.+.}-{3:3}, at: ocfs2_truncate_file+0x372/0x1560 fs/ocfs2/file.c:471

stack backtrace:
CPU: 0 UID: 0 PID: 5103 Comm: syz.0.0 Not tainted 6.11.0-rc4-syzkaller-00011-g521b1e7f4cf0 #0
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
 ocfs2_orphan_for_truncate fs/ocfs2/file.c:396 [inline]
 ocfs2_truncate_file+0x68c/0x1560 fs/ocfs2/file.c:500
 ocfs2_setattr+0x1217/0x1f50 fs/ocfs2/file.c:1208
 notify_change+0xb9d/0xe70 fs/attr.c:495
 do_truncate+0x220/0x310 fs/open.c:65
 handle_truncate fs/namei.c:3381 [inline]
 do_open fs/namei.c:3731 [inline]
 path_openat+0x2ced/0x3470 fs/namei.c:3886
 do_filp_open+0x235/0x490 fs/namei.c:3913
 do_sys_openat2+0x13e/0x1d0 fs/open.c:1416
 do_sys_open fs/open.c:1431 [inline]
 __do_sys_openat fs/open.c:1447 [inline]
 __se_sys_openat fs/open.c:1442 [inline]
 __x64_sys_openat+0x247/0x2a0 fs/open.c:1442
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f5ba4979e79
Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 a8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f5ba57cc038 EFLAGS: 00000246 ORIG_RAX: 0000000000000101
RAX: ffffffffffffffda RBX: 00007f5ba4b16058 RCX: 00007f5ba4979e79
RDX: 0000000000004240 RSI: 0000000020000040 RDI: ffffffffffffff9c
RBP: 00007f5ba49e7916 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000001 R11: 0000000000000246 R12: 0000000000000000
R13: 0000000000000000 R14: 00007f5ba4b16058 R15: 00007fff4df94e18
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
