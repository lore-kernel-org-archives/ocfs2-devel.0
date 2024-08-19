Received: from mail-io1-f70.google.com (mail-io1-f70.google.com [209.85.166.70])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59DF0947A
	for <ocfs2-devel@lists.linux.dev>; Mon, 19 Aug 2024 07:43:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.70
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724053403; cv=none; b=CYgeuCAypyl2L+z9NYJWY/F1tf+wDMeEwiG0c7GadJjT4JMEHSzD1ncq4TJca3HDpi6RNUpXdzkROAntuyskjBS8x5O5ddDwXhBpspZsXmRFvXgBE94/8/R+aL4hPkbtjWcfZ6/HePWU+b2ADoi3DNU44W+HfrpH28ignC0wVTw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724053403; c=relaxed/simple;
	bh=LPNuAdKeGXh4+w/Rhn+Hsn+3e6b518CbeViNedKx9wc=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=kxfaJLyXj3Vzyii3vTnMV+LSOLU6Ub0lSw+FNNFc4ZGfsCVjvQoknj/NgCIiyG8NygEqj/n4YyFOqVlhwHpt7TeI/jJym90bAzCuZ69URvEMkqcEZSF5pchvBNstp6dzCy7mx9ZeyP3zsdYwoqK+r7EdpQblyBba0QuOwaKkWwQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.70
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-io1-f70.google.com with SMTP id ca18e2360f4ac-8251eddfdd2so1213239f.0
        for <ocfs2-devel@lists.linux.dev>; Mon, 19 Aug 2024 00:43:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724053400; x=1724658200;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=BrrochKiPNa2obhLTF6jdHYqIt3FZA+Hn12wNvt6z7M=;
        b=cVwqj6KFLWCzkIGS/M/V/llQNNwEersFbZ+NXEnp+oI4wThomINyXo9mpyBI8HpLbT
         67Rf9+h5Vu8tQu4YEnD1wzKlTSGI63cvAPd+KXA5ZpOc6ECyi6meD95KiOiDr+45NJNR
         AETWY29l39racJBI1AIwkxZfVs26u2tdf+wAMFEMu8q+WyAADycNpfFVInH3ulgVp4Fq
         B5Q4nofpdSROF5Acv4HBB9epFabYXi3eYfaSoky6eZ574Arf3jjGQbJZ6fOmoVjLWM3F
         4GpHV9e46E69WEIoSmPgVTFMrhCdMY4BHTc/yloimIQIJoqnApfhzJer/rE7yXxkmoIw
         SQfQ==
X-Forwarded-Encrypted: i=1; AJvYcCUBMBmGKI+KRFcp7oxbi6Zi1mAGI3+Xv09q/lzk87ub2m6br2gO6mPj2KRjKLi0tYS4m2q7FortFclaRIJ5xKV2KypIAXz2aM4eHVI=
X-Gm-Message-State: AOJu0Yza3/ium/dU6mGbXrSjNKOwrMktBplE9XFkIB5UI+zDVvKit7AI
	d7aJ3Zv7hDrivbja9LRVTHvjAP+90M39qmDZMl67ctth5lmvEpbVByX3CqGhy+N7L7xcRlnNz3x
	1oA2KU+eORChWhFWBY4DW+rB6qYeY3zmhGnG4ET3v/DfuXJilKdcgfUY=
X-Google-Smtp-Source: AGHT+IGxwj2+bszr74+t8g0X39ZNPE26DfcsX90CEuYZQXElas+U57igtX9pKxDXOhDi0oFOVpyvxN6uohNik/R0aNuaUo813y80
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6638:379f:b0:4bb:624c:5a7f with SMTP id
 8926c6da1cb9f-4cce15bec49mr385001173.1.1724053399310; Mon, 19 Aug 2024
 00:43:19 -0700 (PDT)
Date: Mon, 19 Aug 2024 00:43:19 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000070a44a0620047696@google.com>
Subject: [syzbot] [ocfs2?] possible deadlock in ocfs2_reserve_suballoc_bits
From: syzbot <syzbot+5d516fba7bc3c966c9a9@syzkaller.appspotmail.com>
To: jlbec@evilplan.org, joseph.qi@linux.alibaba.com, 
	linux-kernel@vger.kernel.org, mark@fasheh.com, ocfs2-devel@lists.linux.dev, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    670c12ce09a8 Merge tag 'for-6.11/dm-fixes' of git://git.ke..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=14c78c5b980000
kernel config:  https://syzkaller.appspot.com/x/.config?x=7229118d88b4a71b
dashboard link: https://syzkaller.appspot.com/bug?extid=5d516fba7bc3c966c9a9
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=125d01d5980000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=15be6bf3980000

Downloadable assets:
disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/7bc7510fe41f/non_bootable_disk-670c12ce.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/fdc54e331300/vmlinux-670c12ce.xz
kernel image: https://storage.googleapis.com/syzbot-assets/e69f58032670/bzImage-670c12ce.xz
mounted in repro: https://storage.googleapis.com/syzbot-assets/52ffc309994f/mount_0.gz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+5d516fba7bc3c966c9a9@syzkaller.appspotmail.com

JBD2: Ignoring recovery information on journal
ocfs2: Mounting device (7,0) on (node local, slot 0) with ordered data mode.
======================================================
WARNING: possible circular locking dependency detected
6.11.0-rc3-syzkaller-00221-g670c12ce09a8 #0 Not tainted
------------------------------------------------------
syz-executor327/5097 is trying to acquire lock:
ffff8880127b5f40 (&ocfs2_sysfile_lock_key[args->fi_sysfile_type]#3){+.+.}-{3:3}, at: inode_lock include/linux/fs.h:799 [inline]
ffff8880127b5f40 (&ocfs2_sysfile_lock_key[args->fi_sysfile_type]#3){+.+.}-{3:3}, at: ocfs2_reserve_suballoc_bits+0x192/0x4eb0 fs/ocfs2/suballoc.c:786

but task is already holding lock:
ffff8880119131b8 (&oi->ip_xattr_sem){++++}-{3:3}, at: ocfs2_xattr_set+0x633/0x1930 fs/ocfs2/xattr.c:3584

which lock already depends on the new lock.


the existing dependency chain (in reverse order) is:

-> #5 (&oi->ip_xattr_sem){++++}-{3:3}:
       lock_acquire+0x1ed/0x550 kernel/locking/lockdep.c:5759
       down_read+0xb1/0xa40 kernel/locking/rwsem.c:1526
       ocfs2_init_acl+0x397/0x930 fs/ocfs2/acl.c:366
       ocfs2_mknod+0x1c05/0x2b40 fs/ocfs2/namei.c:408
       ocfs2_create+0x1ab/0x480 fs/ocfs2/namei.c:672
       lookup_open fs/namei.c:3578 [inline]
       open_last_lookups fs/namei.c:3647 [inline]
       path_openat+0x1a9a/0x3470 fs/namei.c:3883
       do_filp_open+0x235/0x490 fs/namei.c:3913
       do_sys_openat2+0x13e/0x1d0 fs/open.c:1416
       do_sys_open fs/open.c:1431 [inline]
       __do_sys_openat fs/open.c:1447 [inline]
       __se_sys_openat fs/open.c:1442 [inline]
       __x64_sys_openat+0x247/0x2a0 fs/open.c:1442
       do_syscall_x64 arch/x86/entry/common.c:52 [inline]
       do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
       entry_SYSCALL_64_after_hwframe+0x77/0x7f

-> #4 (jbd2_handle){.+.+}-{0:0}:
       lock_acquire+0x1ed/0x550 kernel/locking/lockdep.c:5759
       start_this_handle+0x1eb4/0x2110 fs/jbd2/transaction.c:448
       jbd2__journal_start+0x2da/0x5d0 fs/jbd2/transaction.c:505
       jbd2_journal_start+0x29/0x40 fs/jbd2/transaction.c:544
       ocfs2_start_trans+0x3c9/0x700 fs/ocfs2/journal.c:352
       ocfs2_mknod+0x150c/0x2b40 fs/ocfs2/namei.c:359
       ocfs2_create+0x1ab/0x480 fs/ocfs2/namei.c:672
       lookup_open fs/namei.c:3578 [inline]
       open_last_lookups fs/namei.c:3647 [inline]
       path_openat+0x1a9a/0x3470 fs/namei.c:3883
       do_filp_open+0x235/0x490 fs/namei.c:3913
       do_sys_openat2+0x13e/0x1d0 fs/open.c:1416
       do_sys_open fs/open.c:1431 [inline]
       __do_sys_openat fs/open.c:1447 [inline]
       __se_sys_openat fs/open.c:1442 [inline]
       __x64_sys_openat+0x247/0x2a0 fs/open.c:1442
       do_syscall_x64 arch/x86/entry/common.c:52 [inline]
       do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
       entry_SYSCALL_64_after_hwframe+0x77/0x7f

-> #3 (&journal->j_trans_barrier){.+.+}-{3:3}:
       lock_acquire+0x1ed/0x550 kernel/locking/lockdep.c:5759
       down_read+0xb1/0xa40 kernel/locking/rwsem.c:1526
       ocfs2_start_trans+0x3be/0x700 fs/ocfs2/journal.c:350
       ocfs2_mknod+0x150c/0x2b40 fs/ocfs2/namei.c:359
       ocfs2_create+0x1ab/0x480 fs/ocfs2/namei.c:672
       lookup_open fs/namei.c:3578 [inline]
       open_last_lookups fs/namei.c:3647 [inline]
       path_openat+0x1a9a/0x3470 fs/namei.c:3883
       do_filp_open+0x235/0x490 fs/namei.c:3913
       do_sys_openat2+0x13e/0x1d0 fs/open.c:1416
       do_sys_open fs/open.c:1431 [inline]
       __do_sys_openat fs/open.c:1447 [inline]
       __se_sys_openat fs/open.c:1442 [inline]
       __x64_sys_openat+0x247/0x2a0 fs/open.c:1442
       do_syscall_x64 arch/x86/entry/common.c:52 [inline]
       do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
       entry_SYSCALL_64_after_hwframe+0x77/0x7f

-> #2 (sb_internal#2){.+.+}-{0:0}:
       lock_acquire+0x1ed/0x550 kernel/locking/lockdep.c:5759
       percpu_down_read include/linux/percpu-rwsem.h:51 [inline]
       __sb_start_write include/linux/fs.h:1675 [inline]
       sb_start_intwrite include/linux/fs.h:1858 [inline]
       ocfs2_start_trans+0x2b9/0x700 fs/ocfs2/journal.c:348
       ocfs2_mknod+0x150c/0x2b40 fs/ocfs2/namei.c:359
       ocfs2_create+0x1ab/0x480 fs/ocfs2/namei.c:672
       lookup_open fs/namei.c:3578 [inline]
       open_last_lookups fs/namei.c:3647 [inline]
       path_openat+0x1a9a/0x3470 fs/namei.c:3883
       do_filp_open+0x235/0x490 fs/namei.c:3913
       do_sys_openat2+0x13e/0x1d0 fs/open.c:1416
       do_sys_open fs/open.c:1431 [inline]
       __do_sys_openat fs/open.c:1447 [inline]
       __se_sys_openat fs/open.c:1442 [inline]
       __x64_sys_openat+0x247/0x2a0 fs/open.c:1442
       do_syscall_x64 arch/x86/entry/common.c:52 [inline]
       do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
       entry_SYSCALL_64_after_hwframe+0x77/0x7f

-> #1 (&ocfs2_sysfile_lock_key[args->fi_sysfile_type]#4){+.+.}-{3:3}:
       lock_acquire+0x1ed/0x550 kernel/locking/lockdep.c:5759
       down_write+0x99/0x220 kernel/locking/rwsem.c:1579
       inode_lock include/linux/fs.h:799 [inline]
       ocfs2_reserve_local_alloc_bits+0x132/0x2870 fs/ocfs2/localalloc.c:636
       ocfs2_reserve_clusters_with_limit+0x1b8/0xb60 fs/ocfs2/suballoc.c:1166
       ocfs2_mknod+0x1486/0x2b40 fs/ocfs2/namei.c:352
       ocfs2_create+0x1ab/0x480 fs/ocfs2/namei.c:672
       lookup_open fs/namei.c:3578 [inline]
       open_last_lookups fs/namei.c:3647 [inline]
       path_openat+0x1a9a/0x3470 fs/namei.c:3883
       do_filp_open+0x235/0x490 fs/namei.c:3913
       do_sys_openat2+0x13e/0x1d0 fs/open.c:1416
       do_sys_open fs/open.c:1431 [inline]
       __do_sys_openat fs/open.c:1447 [inline]
       __se_sys_openat fs/open.c:1442 [inline]
       __x64_sys_openat+0x247/0x2a0 fs/open.c:1442
       do_syscall_x64 arch/x86/entry/common.c:52 [inline]
       do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
       entry_SYSCALL_64_after_hwframe+0x77/0x7f

-> #0 (&ocfs2_sysfile_lock_key[args->fi_sysfile_type]#3){+.+.}-{3:3}:
       check_prev_add kernel/locking/lockdep.c:3133 [inline]
       check_prevs_add kernel/locking/lockdep.c:3252 [inline]
       validate_chain+0x18e0/0x5900 kernel/locking/lockdep.c:3868
       __lock_acquire+0x137a/0x2040 kernel/locking/lockdep.c:5142
       lock_acquire+0x1ed/0x550 kernel/locking/lockdep.c:5759
       down_write+0x99/0x220 kernel/locking/rwsem.c:1579
       inode_lock include/linux/fs.h:799 [inline]
       ocfs2_reserve_suballoc_bits+0x192/0x4eb0 fs/ocfs2/suballoc.c:786
       ocfs2_reserve_new_metadata_blocks+0x41c/0x9c0 fs/ocfs2/suballoc.c:982
       ocfs2_init_xattr_set_ctxt+0x3a6/0x900 fs/ocfs2/xattr.c:3278
       ocfs2_xattr_set+0xf4e/0x1930 fs/ocfs2/xattr.c:3635
       __vfs_setxattr+0x468/0x4a0 fs/xattr.c:200
       __vfs_setxattr_noperm+0x12e/0x660 fs/xattr.c:234
       vfs_setxattr+0x221/0x430 fs/xattr.c:321
       do_setxattr fs/xattr.c:629 [inline]
       path_setxattr+0x37e/0x4d0 fs/xattr.c:658
       __do_sys_setxattr fs/xattr.c:676 [inline]
       __se_sys_setxattr fs/xattr.c:672 [inline]
       __x64_sys_setxattr+0xbb/0xd0 fs/xattr.c:672
       do_syscall_x64 arch/x86/entry/common.c:52 [inline]
       do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
       entry_SYSCALL_64_after_hwframe+0x77/0x7f

other info that might help us debug this:

Chain exists of:
  &ocfs2_sysfile_lock_key[args->fi_sysfile_type]#3 --> jbd2_handle --> &oi->ip_xattr_sem

 Possible unsafe locking scenario:

       CPU0                    CPU1
       ----                    ----
  lock(&oi->ip_xattr_sem);
                               lock(jbd2_handle);
                               lock(&oi->ip_xattr_sem);
  lock(&ocfs2_sysfile_lock_key[args->fi_sysfile_type]#3);

 *** DEADLOCK ***

3 locks held by syz-executor327/5097:
 #0: ffff8880380d6420 (sb_writers#9){.+.+}-{0:0}, at: mnt_want_write+0x3f/0x90 fs/namespace.c:515
 #1: ffff888011913480 (&sb->s_type->i_mutex_key#15){+.+.}-{3:3}, at: inode_lock include/linux/fs.h:799 [inline]
 #1: ffff888011913480 (&sb->s_type->i_mutex_key#15){+.+.}-{3:3}, at: vfs_setxattr+0x1e1/0x430 fs/xattr.c:320
 #2: ffff8880119131b8 (&oi->ip_xattr_sem){++++}-{3:3}, at: ocfs2_xattr_set+0x633/0x1930 fs/ocfs2/xattr.c:3584

stack backtrace:
CPU: 0 UID: 0 PID: 5097 Comm: syz-executor327 Not tainted 6.11.0-rc3-syzkaller-00221-g670c12ce09a8 #0
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
 ocfs2_reserve_suballoc_bits+0x192/0x4eb0 fs/ocfs2/suballoc.c:786
 ocfs2_reserve_new_metadata_blocks+0x41c/0x9c0 fs/ocfs2/suballoc.c:982
 ocfs2_init_xattr_set_ctxt+0x3a6/0x900 fs/ocfs2/xattr.c:3278
 ocfs2_xattr_set+0xf4e/0x1930 fs/ocfs2/xattr.c:3635
 __vfs_setxattr+0x468/0x4a0 fs/xattr.c:200
 __vfs_setxattr_noperm+0x12e/0x660 fs/xattr.c:234
 vfs_setxattr+0x221/0x430 fs/xattr.c:321
 do_setxattr fs/xattr.c:629 [inline]
 path_setxattr+0x37e/0x4d0 fs/xattr.c:658
 __do_sys_setxattr fs/xattr.c:676 [inline]
 __se_sys_setxattr fs/xattr.c:672 [inline]
 __x64_sys_setxattr+0xbb/0xd0 fs/xattr.c:672
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7eff22d82ed9
Code: 28 00 00 00 75 05 48 83 c4 28 c3 e8 f1 17 00 00 90 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 b8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007fff9ba303c8 EFLAGS: 00000246 ORIG_RAX: 00000000000000bc
RAX: ffffffffffffffda RBX: 0030656c69662f2e RCX: 00007eff22d82ed9
RDX: 0000000000000000 RSI: 0000000020000300 RDI: 00000000200002c0
RBP: 00007eff22dcc095 R08: 0000000000000000 R09: 0000555556a234c0
R10: 0000000000000000 R11: 0000000000000246 R12: 00007fff9ba303f0
R13: 00007fff9ba30618 R14: 431bde82d7b634db R15: 00007eff22dcc03b
 </TASK>
OCFS2: ERROR (device loop0): int ocfs2_claim_suballoc_bits(struct ocfs2_alloc_context *, handle_t *, u32, u32, struct ocfs2_suballoc_result *): Chain allocator dinode 23 has 4294967295 used bits but only 16777215 total
On-disk corruption discovered. Please run fsck.ocfs2 once the filesystem is unmounted.
OCFS2: File system is now read-only.
(syz-executor327,5097,0):ocfs2_claim_suballoc_bits:2038 ERROR: status = -30
(syz-executor327,5097,0):__ocfs2_claim_clusters:2412 ERROR: status = -30
(syz-executor327,5097,0):__ocfs2_claim_clusters:2420 ERROR: status = -30
(syz-executor327,5097,0):ocfs2_block_group_alloc_contig:437 ERROR: status = -30
(syz-executor327,5097,0):ocfs2_block_group_alloc:709 ERROR: status = -30
(syz-executor327,5097,0):ocfs2_block_group_alloc:762 ERROR: status = -30
(syz-executor327,5097,0):ocfs2_reserve_suballoc_bits:837 ERROR: status = -30
(syz-executor327,5097,0):ocfs2_reserve_suballoc_bits:854 ERROR: status = -30
(syz-executor327,5097,0):ocfs2_reserve_new_metadata_blocks:994 ERROR: status = -30
(syz-executor327,5097,0):ocfs2_reserve_new_metadata_blocks:1017 ERROR: status = -30
(syz-executor327,5097,0):ocfs2_init_xattr_set_ctxt:3281 ERROR: status = -30
(syz-executor327,5097,0):ocfs2_xattr_set:3638 ERROR: status = -30


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
