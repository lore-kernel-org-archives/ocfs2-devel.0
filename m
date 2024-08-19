Received: from mail-io1-f70.google.com (mail-io1-f70.google.com [209.85.166.70])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C3BD15B968
	for <ocfs2-devel@lists.linux.dev>; Mon, 19 Aug 2024 08:48:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.70
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724057307; cv=none; b=md3zJm16IHwgcIHHhLsZJZekAaSi+iEDzzlZMg/DoqM0mhARkkc2UIz9uI/o/aPgFe90NuuC4MAi0sJIXwdSymhliA6951Cg/puVPdixnzqQVZqOVry2uU90Hhe7A5XelZ5L8EG9hspN7/TS6kK9VUuhFma7KfJqnxW78SCXwuc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724057307; c=relaxed/simple;
	bh=R6H7Es9RCBQpwcskZEs1dtk0RpC3DRtLdco/IhuDDSg=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=c6pjSVT2SpcEJg3j+zQNdf4XMCkbKMvtYSLdGSEk3ocBstY/y2YgpBn7/8I3neqtm67hm9b98QI0k38b6HREeqZwqsy+IcHFkUrJrq8hHhtR+kO+pYShr+5xCHb1buwzqpLLg3WntpnJaazfZyOYBYQnParpWih64UuDv3DdwIE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.70
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-io1-f70.google.com with SMTP id ca18e2360f4ac-81f81da0972so439394639f.1
        for <ocfs2-devel@lists.linux.dev>; Mon, 19 Aug 2024 01:48:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724057304; x=1724662104;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=3p5g+TH+VzqpJpBP6TerND5UJrOhxEVsSjOHu5Sz3qY=;
        b=PU/NX6g2RZBzcbEhynOtwM+qZLs9FoC/YvARpEz9MpgI+78Bb0jF6SlIzIySEVOy56
         8g7tKpD6meZLvsWy+JQf/ZdFui2NZm5/GuzD8oc69m2iab2jxMJuLP9c2fs/vM1W0lgg
         Y1Zp/oiD/KL2Q3Lu87adnoNihj+mYkaiYqHKEHYbHTqyl9Eq5WMxzJAG3WrKSB9T/iqU
         ypoENkKnDBHMfjHszRL+DURdpilk/hNBLQb8Ij7k3DDoesFXceE6KX14MF3EgmHZgMiR
         lRR/u/PJspKlvSnJV6qya1bMWyT6Lu9siGsBDSu4bd8Zx/PQmOgzJE6+HgSBZ0yngNUy
         DQKw==
X-Forwarded-Encrypted: i=1; AJvYcCVFpTkGRH3GCT01LZX+flDk2qvu7hKMH/Jd2J2tnIrqVqmPMkCCfrEZqxEokJzI9mCHZosGlBH7QFNjp4id8uL+BCftBa8y/LWEy4U=
X-Gm-Message-State: AOJu0Yx7wCE6ttXNSnUjdfZzbGwYJUPlE/d/Hg2SZitJgtwf6vjXfXjs
	bosaC3VITOlFBlALy2ypIcqxnO1ErduK6Ygp80ctfcITeDQ+kz+xXaPeEjrfZ6i1kKS1yfUYWgh
	mXk4VMmoppuaURiOKlJDIQy/i+RCxjQnq9UqwPCn8vtLvlAYiVCVBoR4=
X-Google-Smtp-Source: AGHT+IFudLdgBWMzo9HAvZTedaYxrVc4P9a9G4CjiTdxXdQZxj8sP4yydbQpJM8zE6l/77uoFjiMJ41unUUgnuN1CXmxuH5Fp8eS
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6638:3494:b0:4bf:2453:3a48 with SMTP id
 8926c6da1cb9f-4cce16fd377mr542034173.5.1724057304352; Mon, 19 Aug 2024
 01:48:24 -0700 (PDT)
Date: Mon, 19 Aug 2024 01:48:24 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000032dd730620055fde@google.com>
Subject: [syzbot] [ocfs2?] possible deadlock in ocfs2_try_remove_refcount_tree
From: syzbot <syzbot+1fed2de07d8e11a3ec1b@syzkaller.appspotmail.com>
To: jlbec@evilplan.org, joseph.qi@linux.alibaba.com, 
	linux-kernel@vger.kernel.org, mark@fasheh.com, ocfs2-devel@lists.linux.dev, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    1fb918967b56 Merge tag 'for-6.11-rc3-tag' of git://git.ker..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=14b8bbd9980000
kernel config:  https://syzkaller.appspot.com/x/.config?x=7229118d88b4a71b
dashboard link: https://syzkaller.appspot.com/bug?extid=1fed2de07d8e11a3ec1b
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1142e5ed980000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=14aa396b980000

Downloadable assets:
disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/7bc7510fe41f/non_bootable_disk-1fb91896.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/cd6e8883313a/vmlinux-1fb91896.xz
kernel image: https://storage.googleapis.com/syzbot-assets/87b718d2d1df/bzImage-1fb91896.xz
mounted in repro: https://storage.googleapis.com/syzbot-assets/6b8f724adfab/mount_0.gz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+1fed2de07d8e11a3ec1b@syzkaller.appspotmail.com

Code: c4 28 c3 e8 01 1a 00 00 90 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 48 3d 01 f0 ff ff 73 01 <c3> 48 c7 c1 b8 ff ff ff f7 d8 64 89 01 48 83 c8 ff c3 66 2e 0f 1f
======================================================
WARNING: possible circular locking dependency detected
6.11.0-rc3-syzkaller-00066-g1fb918967b56 #0 Not tainted
------------------------------------------------------
syz-executor622/5097 is trying to acquire lock:
ffff88803ec0bf60 (&oi->ip_alloc_sem){+.+.}-{3:3}, at: ocfs2_try_remove_refcount_tree+0xb6/0x330 fs/ocfs2/refcounttree.c:931

but task is already holding lock:
ffff88803ec0bff8 (&oi->ip_xattr_sem){++++}-{3:3}, at: ocfs2_try_remove_refcount_tree+0xa5/0x330 fs/ocfs2/refcounttree.c:930

which lock already depends on the new lock.


the existing dependency chain (in reverse order) is:

-> #4 (&oi->ip_xattr_sem){++++}-{3:3}:
       lock_acquire+0x1ed/0x550 kernel/locking/lockdep.c:5759
       down_read+0xb1/0xa40 kernel/locking/rwsem.c:1526
       ocfs2_init_acl+0x397/0x930 fs/ocfs2/acl.c:366
       ocfs2_mknod+0x1c05/0x2b40 fs/ocfs2/namei.c:408
       ocfs2_create+0x1ab/0x480 fs/ocfs2/namei.c:672
       lookup_open fs/namei.c:3578 [inline]
       open_last_lookups fs/namei.c:3647 [inline]
       path_openat+0x1a9a/0x3470 fs/namei.c:3883
       do_filp_open+0x235/0x490 fs/namei.c:3913
       file_open_name fs/open.c:1361 [inline]
       filp_open+0x261/0x2d0 fs/open.c:1381
       do_coredump+0x2259/0x2a30 fs/coredump.c:708
       get_signal+0x13fa/0x1740 kernel/signal.c:2902
       arch_do_signal_or_restart+0x96/0x860 arch/x86/kernel/signal.c:310
       exit_to_user_mode_loop kernel/entry/common.c:111 [inline]
       exit_to_user_mode_prepare include/linux/entry-common.h:328 [inline]
       irqentry_exit_to_user_mode+0x79/0x280 kernel/entry/common.c:231
       exc_page_fault+0x590/0x8c0 arch/x86/mm/fault.c:1542
       asm_exc_page_fault+0x26/0x30 arch/x86/include/asm/idtentry.h:623

-> #3 (jbd2_handle){.+.+}-{0:0}:
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
       file_open_name fs/open.c:1361 [inline]
       filp_open+0x261/0x2d0 fs/open.c:1381
       do_coredump+0x2259/0x2a30 fs/coredump.c:708
       get_signal+0x13fa/0x1740 kernel/signal.c:2902
       arch_do_signal_or_restart+0x96/0x860 arch/x86/kernel/signal.c:310
       exit_to_user_mode_loop kernel/entry/common.c:111 [inline]
       exit_to_user_mode_prepare include/linux/entry-common.h:328 [inline]
       irqentry_exit_to_user_mode+0x79/0x280 kernel/entry/common.c:231
       exc_page_fault+0x590/0x8c0 arch/x86/mm/fault.c:1542
       asm_exc_page_fault+0x26/0x30 arch/x86/include/asm/idtentry.h:623

-> #2 (&journal->j_trans_barrier){.+.+}-{3:3}:
       lock_acquire+0x1ed/0x550 kernel/locking/lockdep.c:5759
       down_read+0xb1/0xa40 kernel/locking/rwsem.c:1526
       ocfs2_start_trans+0x3be/0x700 fs/ocfs2/journal.c:350
       ocfs2_mknod+0x150c/0x2b40 fs/ocfs2/namei.c:359
       ocfs2_create+0x1ab/0x480 fs/ocfs2/namei.c:672
       lookup_open fs/namei.c:3578 [inline]
       open_last_lookups fs/namei.c:3647 [inline]
       path_openat+0x1a9a/0x3470 fs/namei.c:3883
       do_filp_open+0x235/0x490 fs/namei.c:3913
       file_open_name fs/open.c:1361 [inline]
       filp_open+0x261/0x2d0 fs/open.c:1381
       do_coredump+0x2259/0x2a30 fs/coredump.c:708
       get_signal+0x13fa/0x1740 kernel/signal.c:2902
       arch_do_signal_or_restart+0x96/0x860 arch/x86/kernel/signal.c:310
       exit_to_user_mode_loop kernel/entry/common.c:111 [inline]
       exit_to_user_mode_prepare include/linux/entry-common.h:328 [inline]
       irqentry_exit_to_user_mode+0x79/0x280 kernel/entry/common.c:231
       exc_page_fault+0x590/0x8c0 arch/x86/mm/fault.c:1542
       asm_exc_page_fault+0x26/0x30 arch/x86/include/asm/idtentry.h:623

-> #1 (sb_internal#2){.+.+}-{0:0}:
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
       do_coredump+0x2702/0x2a30 fs/coredump.c:744
       get_signal+0x13fa/0x1740 kernel/signal.c:2902
       arch_do_signal_or_restart+0x96/0x860 arch/x86/kernel/signal.c:310
       exit_to_user_mode_loop kernel/entry/common.c:111 [inline]
       exit_to_user_mode_prepare include/linux/entry-common.h:328 [inline]
       irqentry_exit_to_user_mode+0x79/0x280 kernel/entry/common.c:231
       exc_page_fault+0x590/0x8c0 arch/x86/mm/fault.c:1542
       asm_exc_page_fault+0x26/0x30 arch/x86/include/asm/idtentry.h:623

-> #0 (&oi->ip_alloc_sem){+.+.}-{3:3}:
       check_prev_add kernel/locking/lockdep.c:3133 [inline]
       check_prevs_add kernel/locking/lockdep.c:3252 [inline]
       validate_chain+0x18e0/0x5900 kernel/locking/lockdep.c:3868
       __lock_acquire+0x137a/0x2040 kernel/locking/lockdep.c:5142
       lock_acquire+0x1ed/0x550 kernel/locking/lockdep.c:5759
       down_write+0x99/0x220 kernel/locking/rwsem.c:1579
       ocfs2_try_remove_refcount_tree+0xb6/0x330 fs/ocfs2/refcounttree.c:931
       ocfs2_truncate_file+0xe08/0x1560 fs/ocfs2/file.c:521
       ocfs2_setattr+0x1217/0x1f50 fs/ocfs2/file.c:1208
       notify_change+0xb9d/0xe70 fs/attr.c:495
       do_truncate+0x220/0x310 fs/open.c:65
       do_coredump+0x2702/0x2a30 fs/coredump.c:744
       get_signal+0x13fa/0x1740 kernel/signal.c:2902
       arch_do_signal_or_restart+0x96/0x860 arch/x86/kernel/signal.c:310
       exit_to_user_mode_loop kernel/entry/common.c:111 [inline]
       exit_to_user_mode_prepare include/linux/entry-common.h:328 [inline]
       irqentry_exit_to_user_mode+0x79/0x280 kernel/entry/common.c:231
       exc_page_fault+0x590/0x8c0 arch/x86/mm/fault.c:1542
       asm_exc_page_fault+0x26/0x30 arch/x86/include/asm/idtentry.h:623

other info that might help us debug this:

Chain exists of:
  &oi->ip_alloc_sem --> jbd2_handle --> &oi->ip_xattr_sem

 Possible unsafe locking scenario:

       CPU0                    CPU1
       ----                    ----
  lock(&oi->ip_xattr_sem);
                               lock(jbd2_handle);
                               lock(&oi->ip_xattr_sem);
  lock(&oi->ip_alloc_sem);

 *** DEADLOCK ***

2 locks held by syz-executor622/5097:
 #0: ffff88803ec0c2c0 (&sb->s_type->i_mutex_key#17){+.+.}-{3:3}, at: inode_lock include/linux/fs.h:799 [inline]
 #0: ffff88803ec0c2c0 (&sb->s_type->i_mutex_key#17){+.+.}-{3:3}, at: do_truncate+0x20c/0x310 fs/open.c:63
 #1: ffff88803ec0bff8 (&oi->ip_xattr_sem){++++}-{3:3}, at: ocfs2_try_remove_refcount_tree+0xa5/0x330 fs/ocfs2/refcounttree.c:930

stack backtrace:
CPU: 0 UID: 0 PID: 5097 Comm: syz-executor622 Not tainted 6.11.0-rc3-syzkaller-00066-g1fb918967b56 #0
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
 ocfs2_try_remove_refcount_tree+0xb6/0x330 fs/ocfs2/refcounttree.c:931
 ocfs2_truncate_file+0xe08/0x1560 fs/ocfs2/file.c:521
 ocfs2_setattr+0x1217/0x1f50 fs/ocfs2/file.c:1208
 notify_change+0xb9d/0xe70 fs/attr.c:495
 do_truncate+0x220/0x310 fs/open.c:65
 do_coredump+0x2702/0x2a30 fs/coredump.c:744
 get_signal+0x13fa/0x1740 kernel/signal.c:2902
 arch_do_signal_or_restart+0x96/0x860 arch/x86/kernel/signal.c:310
 exit_to_user_mode_loop kernel/entry/common.c:111 [inline]
 exit_to_user_mode_prepare include/linux/entry-common.h:328 [inline]
 irqentry_exit_to_user_mode+0x79/0x280 kernel/entry/common.c:231
 exc_page_fault+0x590/0x8c0 arch/x86/mm/fault.c:1542
 asm_exc_page_fault+0x26/0x30 arch/x86/include/asm/idtentry.h:623
RIP: 0033:0x7f27cd76b711
Code: c4 28 c3 e8 01 1a 00 00 90 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 48 3d 01 f0 ff ff 73 01 <c3> 48 c7 c1 b8 ff ff ff f7 d8 64 89 01 48 83 c8 ff c3 66 2e 0f 1f
RSP: 002b:ffffffffffffffe0 EFLAGS: 00010217
RAX: 0000000000000000 RBX: 0000000000000003 RCX: 00007f27cd76b709
RDX: 0000000000000000 RSI: ffffffffffffffe0 RDI: 0000000004008011
RBP: 65756e69746e6f63 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 633d73726f727265
R13: 00007ffd27cfc3fc R14: 00007ffd27cfc440 R15: 00007ffd27cfc430
 </TASK>
OCFS2: ERROR (device loop0): int ocfs2_claim_suballoc_bits(struct ocfs2_alloc_context *, handle_t *, u32, u32, struct ocfs2_suballoc_result *): Chain allocator dinode 23 has 4294967295 used bits but only 16777215 total
On-disk corruption discovered. Please run fsck.ocfs2 once the filesystem is unmounted.
OCFS2: Returning error to the calling process.
(syz-executor622,5097,0):ocfs2_claim_suballoc_bits:2038 ERROR: status = -5
(syz-executor622,5097,0):__ocfs2_claim_clusters:2412 ERROR: status = -5
(syz-executor622,5097,0):__ocfs2_claim_clusters:2420 ERROR: status = -5
(syz-executor622,5097,0):ocfs2_local_alloc_new_window:1197 ERROR: status = -5
(syz-executor622,5097,0):ocfs2_local_alloc_new_window:1222 ERROR: status = -5
(syz-executor622,5097,0):ocfs2_local_alloc_slide_window:1296 ERROR: status = -5
(syz-executor622,5097,0):ocfs2_local_alloc_slide_window:1315 ERROR: status = -5
(syz-executor622,5097,0):ocfs2_reserve_local_alloc_bits:672 ERROR: status = -5
(syz-executor622,5097,0):ocfs2_reserve_local_alloc_bits:710 ERROR: status = -5
(syz-executor622,5097,0):ocfs2_reserve_clusters_with_limit:1170 ERROR: status = -5
(syz-executor622,5097,0):ocfs2_reserve_clusters_with_limit:1219 ERROR: status = -5
(syz-executor622,5097,0):ocfs2_convert_inline_data_to_extents:7080 ERROR: status = -5
(syz-executor622,5097,0):ocfs2_try_to_write_inline_data:1564 ERROR: status = -5
(syz-executor622,5097,0):ocfs2_write_begin_nolock:1676 ERROR: status = -5
(syz-executor622,5097,0):ocfs2_write_begin:1906 ERROR: status = -5
syz-executor622 (5097) used greatest stack depth: 17712 bytes left
----------------
Code disassembly (best guess), 1 bytes skipped:
   0:	28 c3                	sub    %al,%bl
   2:	e8 01 1a 00 00       	call   0x1a08
   7:	90                   	nop
   8:	48 89 f8             	mov    %rdi,%rax
   b:	48 89 f7             	mov    %rsi,%rdi
   e:	48 89 d6             	mov    %rdx,%rsi
  11:	48 89 ca             	mov    %rcx,%rdx
  14:	4d 89 c2             	mov    %r8,%r10
  17:	4d 89 c8             	mov    %r9,%r8
  1a:	4c 8b 4c 24 08       	mov    0x8(%rsp),%r9
  1f:	0f 05                	syscall
  21:	48 3d 01 f0 ff ff    	cmp    $0xfffffffffffff001,%rax
  27:	73 01                	jae    0x2a
* 29:	c3                   	ret <-- trapping instruction
  2a:	48 c7 c1 b8 ff ff ff 	mov    $0xffffffffffffffb8,%rcx
  31:	f7 d8                	neg    %eax
  33:	64 89 01             	mov    %eax,%fs:(%rcx)
  36:	48 83 c8 ff          	or     $0xffffffffffffffff,%rax
  3a:	c3                   	ret
  3b:	66                   	data16
  3c:	2e                   	cs
  3d:	0f                   	.byte 0xf
  3e:	1f                   	(bad)


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
