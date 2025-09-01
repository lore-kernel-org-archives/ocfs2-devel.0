Received: from mail-il1-f205.google.com (mail-il1-f205.google.com [209.85.166.205])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 504FB274671
	for <ocfs2-devel@lists.linux.dev>; Mon,  1 Sep 2025 23:57:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.205
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756771053; cv=none; b=WMF7Y8pWy1tILGBsTOzjidiOCirx5BrEnSgjYJYlYJ0PoUh3gSR80d1NxliZQG6Gj8KpflwtLejK8xEKdrYI6pD6OuQsrHBFESBmTU0xNl7gs3SoOrWYlDTzbdSlAdu3LWvj8zh5aZpS59S1YPbpKjDAKlTNCuNGNFC+Y9ztfdM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756771053; c=relaxed/simple;
	bh=pGGhDe0i6ukzp8J4HZ311zCV/VCylteEPe71pB+MH/0=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:
	 Content-Type; b=CSeinB+/Okjw0L2YhANxHa0km3bZrYBaAdA6HnwA/goj8/fT6Q+GdFjV9zLzHdTAhQr9nlslxDSHp7efqJd1AKtZPsbVrnj6LHvgi1qEUTccNwR4rCoVANZWdrsuaGkYedMngS1uzD2Rp4hV7BM5SyZNm7O3JWiKyUNtXJWqHaI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.205
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f205.google.com with SMTP id e9e14a558f8ab-3f1ebcf0863so55500285ab.2
        for <ocfs2-devel@lists.linux.dev>; Mon, 01 Sep 2025 16:57:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756771050; x=1757375850;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ljqWUGA/ZdvNr3Z30VH18f0Fqo5f4CUZ6fgrdyQLz+A=;
        b=WwT6DQUZmWsdmAQMTiQDYowDov5z1sJkFz/UUc8UIe7eKzm/GLSPq3b5TcAHXE9lGm
         xINp+3t/BZY0BLwRe8qDFUy05uoZnY/+h2R4YeBHMib+jNAf1QxdbvRpk0MVp8ctQqCh
         ukNBw4TGw2l4ruqzLd1OvZIGBo9paUELAH3wyxrJX2bquoeFI+4p5kBk7/peMVGdjZJX
         e+8lebINWnU6pNynOGTfBR5O3AtszS68u0/LKtUsiI4CDDi/f8oNiACX7Ws1SG/aunZc
         QMuhtk6R4MozC0rjvkn4zeykX9CUCv2Wd73R+5GsRhkysydGPx8BfZpFh5OiXxs/6NrH
         KzCA==
X-Forwarded-Encrypted: i=1; AJvYcCVySeqo8t2vSyNtCdJcerFCnKQD6xQUmoLRXsYDFSudzRIPW2ou5VrvUd6NV13f49tnf/EhUiAR3hXBNw==@lists.linux.dev
X-Gm-Message-State: AOJu0YydlgnKsBdFBnFDDPPSqVy6iS91scp49zYq1RmqFusvXH8/jXAX
	zNrRf7Ej8K2jLj3sq1bUqBPlJoTFz+7Lz8OuSE82eXNBNthaQnaHNl3pkrmvXilZQGwriSweRwi
	18DQhIf1kz0cNk32xCXspTuOmHcQBEkNvyx4MEQmTuClnQcGtdo3BF+My1Wo=
X-Google-Smtp-Source: AGHT+IE4bPGTKny4Gfi0vsxFW04+0/A3tZ6UdvQZ6JpzzZbh2yVW6tn5Ey93DMTq6U8DXfbEoUb9TK81Tr/2XiJKdRoZYvSnL48k
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1b0d:b0:3ef:1b56:c8ea with SMTP id
 e9e14a558f8ab-3f40028ad1dmr168200055ab.11.1756771050435; Mon, 01 Sep 2025
 16:57:30 -0700 (PDT)
Date: Mon, 01 Sep 2025 16:57:30 -0700
In-Reply-To: <0000000000000f69e106206619b6@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <68b632ea.a70a0220.1c57d1.0590.GAE@google.com>
Subject: Re: [syzbot] [ocfs2?] possible deadlock in ocfs2_truncate_file
From: syzbot <syzbot+2515179cbeb82ea01c88@syzkaller.appspotmail.com>
To: jlbec@evilplan.org, joseph.qi@linux.alibaba.com, 
	linux-kernel@vger.kernel.org, mark@fasheh.com, ocfs2-devel@lists.linux.dev, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

syzbot has found a reproducer for the following issue on:

HEAD commit:    8f5ae30d69d7 Linux 6.17-rc1
git tree:       git://git.kernel.org/pub/scm/linux/kernel/git/arm64/linux.git for-kernelci
console output: https://syzkaller.appspot.com/x/log.txt?x=11684a42580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=8c5ac3d8b8abfcb
dashboard link: https://syzkaller.appspot.com/bug?extid=2515179cbeb82ea01c88
compiler:       Debian clang version 20.1.7 (++20250616065708+6146a88f6049-1~exp1~20250616065826.132), Debian LLD 20.1.7
userspace arch: arm64
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1587d662580000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1387d662580000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/18a2e4bd0c4a/disk-8f5ae30d.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/3b5395881b25/vmlinux-8f5ae30d.xz
kernel image: https://storage.googleapis.com/syzbot-assets/e875f4e3b7ff/Image-8f5ae30d.gz.xz
mounted in repro: https://storage.googleapis.com/syzbot-assets/3516a666bab0/mount_0.gz
  fsck result: OK (log: https://syzkaller.appspot.com/x/fsck.log?x=1187d662580000)

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+2515179cbeb82ea01c88@syzkaller.appspotmail.com

JBD2: Ignoring recovery information on journal
ocfs2: Mounting device (7,0) on (node local, slot 0) with ordered data mode.
======================================================
WARNING: possible circular locking dependency detected
6.17.0-rc1-syzkaller-g8f5ae30d69d7 #0 Not tainted
------------------------------------------------------
syz.0.17/6752 is trying to acquire lock:
ffff0000ca2da618 (sb_internal#2){.+.+}-{0:0}, at: ocfs2_orphan_for_truncate fs/ocfs2/file.c:396 [inline]
ffff0000ca2da618 (sb_internal#2){.+.+}-{0:0}, at: ocfs2_truncate_file+0x5b0/0x12f4 fs/ocfs2/file.c:500

but task is already holding lock:
ffff0000f3cacda0 (&oi->ip_alloc_sem){++++}-{4:4}, at: ocfs2_truncate_file+0x30c/0x12f4 fs/ocfs2/file.c:471

which lock already depends on the new lock.


the existing dependency chain (in reverse order) is:

-> #4 (&oi->ip_alloc_sem){++++}-{4:4}:
       down_read+0x58/0x2f8 kernel/locking/rwsem.c:1537
       ocfs2_xattr_ibody_find+0x100/0x668 fs/ocfs2/xattr.c:2689
       ocfs2_xattr_set_handle+0x2bc/0x5e4 fs/ocfs2/xattr.c:3503
       ocfs2_init_security_set+0xb4/0xd8 fs/ocfs2/xattr.c:7307
       ocfs2_mknod+0x106c/0x1cf0 fs/ocfs2/namei.c:422
       ocfs2_create+0x190/0x474 fs/ocfs2/namei.c:676
       lookup_open fs/namei.c:3708 [inline]
       open_last_lookups fs/namei.c:3807 [inline]
       path_openat+0x12d8/0x2c40 fs/namei.c:4043
       do_filp_open+0x18c/0x36c fs/namei.c:4073
       do_sys_openat2+0x11c/0x1b4 fs/open.c:1435
       do_sys_open fs/open.c:1450 [inline]
       __do_sys_openat fs/open.c:1466 [inline]
       __se_sys_openat fs/open.c:1461 [inline]
       __arm64_sys_openat+0x120/0x158 fs/open.c:1461
       __invoke_syscall arch/arm64/kernel/syscall.c:35 [inline]
       invoke_syscall+0x98/0x2b8 arch/arm64/kernel/syscall.c:49
       el0_svc_common+0x130/0x23c arch/arm64/kernel/syscall.c:132
       do_el0_svc+0x48/0x58 arch/arm64/kernel/syscall.c:151
       el0_svc+0x58/0x180 arch/arm64/kernel/entry-common.c:879
       el0t_64_sync_handler+0x84/0x12c arch/arm64/kernel/entry-common.c:898
       el0t_64_sync+0x198/0x19c arch/arm64/kernel/entry.S:596

-> #3 (&oi->ip_xattr_sem){++++}-{4:4}:
       down_read+0x58/0x2f8 kernel/locking/rwsem.c:1537
       ocfs2_init_acl+0x258/0x5f0 fs/ocfs2/acl.c:366
       ocfs2_mknod+0x1028/0x1cf0 fs/ocfs2/namei.c:413
       ocfs2_create+0x190/0x474 fs/ocfs2/namei.c:676
       lookup_open fs/namei.c:3708 [inline]
       open_last_lookups fs/namei.c:3807 [inline]
       path_openat+0x12d8/0x2c40 fs/namei.c:4043
       do_filp_open+0x18c/0x36c fs/namei.c:4073
       do_sys_openat2+0x11c/0x1b4 fs/open.c:1435
       do_sys_open fs/open.c:1450 [inline]
       __do_sys_openat fs/open.c:1466 [inline]
       __se_sys_openat fs/open.c:1461 [inline]
       __arm64_sys_openat+0x120/0x158 fs/open.c:1461
       __invoke_syscall arch/arm64/kernel/syscall.c:35 [inline]
       invoke_syscall+0x98/0x2b8 arch/arm64/kernel/syscall.c:49
       el0_svc_common+0x130/0x23c arch/arm64/kernel/syscall.c:132
       do_el0_svc+0x48/0x58 arch/arm64/kernel/syscall.c:151
       el0_svc+0x58/0x180 arch/arm64/kernel/entry-common.c:879
       el0t_64_sync_handler+0x84/0x12c arch/arm64/kernel/entry-common.c:898
       el0t_64_sync+0x198/0x19c arch/arm64/kernel/entry.S:596

-> #2 (jbd2_handle){++++}-{0:0}:
       start_this_handle+0xe74/0x10dc fs/jbd2/transaction.c:444
       jbd2__journal_start+0x288/0x51c fs/jbd2/transaction.c:501
       jbd2_journal_start+0x3c/0x4c fs/jbd2/transaction.c:540
       ocfs2_start_trans+0x368/0x6b0 fs/ocfs2/journal.c:374
       ocfs2_mknod+0xc50/0x1cf0 fs/ocfs2/namei.c:364
       ocfs2_create+0x190/0x474 fs/ocfs2/namei.c:676
       lookup_open fs/namei.c:3708 [inline]
       open_last_lookups fs/namei.c:3807 [inline]
       path_openat+0x12d8/0x2c40 fs/namei.c:4043
       do_filp_open+0x18c/0x36c fs/namei.c:4073
       do_sys_openat2+0x11c/0x1b4 fs/open.c:1435
       do_sys_open fs/open.c:1450 [inline]
       __do_sys_openat fs/open.c:1466 [inline]
       __se_sys_openat fs/open.c:1461 [inline]
       __arm64_sys_openat+0x120/0x158 fs/open.c:1461
       __invoke_syscall arch/arm64/kernel/syscall.c:35 [inline]
       invoke_syscall+0x98/0x2b8 arch/arm64/kernel/syscall.c:49
       el0_svc_common+0x130/0x23c arch/arm64/kernel/syscall.c:132
       do_el0_svc+0x48/0x58 arch/arm64/kernel/syscall.c:151
       el0_svc+0x58/0x180 arch/arm64/kernel/entry-common.c:879
       el0t_64_sync_handler+0x84/0x12c arch/arm64/kernel/entry-common.c:898
       el0t_64_sync+0x198/0x19c arch/arm64/kernel/entry.S:596

-> #1 (&journal->j_trans_barrier){.+.+}-{4:4}:
       down_read+0x58/0x2f8 kernel/locking/rwsem.c:1537
       ocfs2_start_trans+0x35c/0x6b0 fs/ocfs2/journal.c:372
       ocfs2_mknod+0xc50/0x1cf0 fs/ocfs2/namei.c:364
       ocfs2_create+0x190/0x474 fs/ocfs2/namei.c:676
       lookup_open fs/namei.c:3708 [inline]
       open_last_lookups fs/namei.c:3807 [inline]
       path_openat+0x12d8/0x2c40 fs/namei.c:4043
       do_filp_open+0x18c/0x36c fs/namei.c:4073
       do_sys_openat2+0x11c/0x1b4 fs/open.c:1435
       do_sys_open fs/open.c:1450 [inline]
       __do_sys_openat fs/open.c:1466 [inline]
       __se_sys_openat fs/open.c:1461 [inline]
       __arm64_sys_openat+0x120/0x158 fs/open.c:1461
       __invoke_syscall arch/arm64/kernel/syscall.c:35 [inline]
       invoke_syscall+0x98/0x2b8 arch/arm64/kernel/syscall.c:49
       el0_svc_common+0x130/0x23c arch/arm64/kernel/syscall.c:132
       do_el0_svc+0x48/0x58 arch/arm64/kernel/syscall.c:151
       el0_svc+0x58/0x180 arch/arm64/kernel/entry-common.c:879
       el0t_64_sync_handler+0x84/0x12c arch/arm64/kernel/entry-common.c:898
       el0t_64_sync+0x198/0x19c arch/arm64/kernel/entry.S:596

-> #0 (sb_internal#2){.+.+}-{0:0}:
       check_prev_add kernel/locking/lockdep.c:3165 [inline]
       check_prevs_add kernel/locking/lockdep.c:3284 [inline]
       validate_chain kernel/locking/lockdep.c:3908 [inline]
       __lock_acquire+0x1774/0x30a4 kernel/locking/lockdep.c:5237
       lock_acquire+0x14c/0x2e0 kernel/locking/lockdep.c:5868
       percpu_down_read_internal include/linux/percpu-rwsem.h:53 [inline]
       percpu_down_read_freezable include/linux/percpu-rwsem.h:83 [inline]
       __sb_start_write include/linux/fs.h:1798 [inline]
       sb_start_intwrite include/linux/fs.h:1981 [inline]
       ocfs2_start_trans+0x1f4/0x6b0 fs/ocfs2/journal.c:370
       ocfs2_orphan_for_truncate fs/ocfs2/file.c:396 [inline]
       ocfs2_truncate_file+0x5b0/0x12f4 fs/ocfs2/file.c:500
       ocfs2_setattr+0x1148/0x17a0 fs/ocfs2/file.c:1212
       notify_change+0x9a4/0xc50 fs/attr.c:552
       do_truncate+0x198/0x210 fs/open.c:68
       handle_truncate fs/namei.c:3508 [inline]
       do_open fs/namei.c:3891 [inline]
       path_openat+0x25a0/0x2c40 fs/namei.c:4046
       do_filp_open+0x18c/0x36c fs/namei.c:4073
       do_sys_openat2+0x11c/0x1b4 fs/open.c:1435
       do_sys_open fs/open.c:1450 [inline]
       __do_sys_openat fs/open.c:1466 [inline]
       __se_sys_openat fs/open.c:1461 [inline]
       __arm64_sys_openat+0x120/0x158 fs/open.c:1461
       __invoke_syscall arch/arm64/kernel/syscall.c:35 [inline]
       invoke_syscall+0x98/0x2b8 arch/arm64/kernel/syscall.c:49
       el0_svc_common+0x130/0x23c arch/arm64/kernel/syscall.c:132
       do_el0_svc+0x48/0x58 arch/arm64/kernel/syscall.c:151
       el0_svc+0x58/0x180 arch/arm64/kernel/entry-common.c:879
       el0t_64_sync_handler+0x84/0x12c arch/arm64/kernel/entry-common.c:898
       el0t_64_sync+0x198/0x19c arch/arm64/kernel/entry.S:596

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

3 locks held by syz.0.17/6752:
 #0: ffff0000ca2da428 (sb_writers#11){.+.+}-{0:0}, at: mnt_want_write+0x44/0x9c fs/namespace.c:557
 #1: ffff0000f3cad100 (&sb->s_type->i_mutex_key#20){+.+.}-{4:4}, at: inode_lock_killable include/linux/fs.h:874 [inline]
 #1: ffff0000f3cad100 (&sb->s_type->i_mutex_key#20){+.+.}-{4:4}, at: do_truncate+0x164/0x210 fs/open.c:63
 #2: ffff0000f3cacda0 (&oi->ip_alloc_sem){++++}-{4:4}, at: ocfs2_truncate_file+0x30c/0x12f4 fs/ocfs2/file.c:471

stack backtrace:
CPU: 0 UID: 0 PID: 6752 Comm: syz.0.17 Not tainted 6.17.0-rc1-syzkaller-g8f5ae30d69d7 #0 PREEMPT 
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 06/30/2025
Call trace:
 show_stack+0x2c/0x3c arch/arm64/kernel/stacktrace.c:499 (C)
 __dump_stack+0x30/0x40 lib/dump_stack.c:94
 dump_stack_lvl+0xd8/0x12c lib/dump_stack.c:120
 dump_stack+0x1c/0x28 lib/dump_stack.c:129
 print_circular_bug+0x324/0x32c kernel/locking/lockdep.c:2043
 check_noncircular+0x154/0x174 kernel/locking/lockdep.c:2175
 check_prev_add kernel/locking/lockdep.c:3165 [inline]
 check_prevs_add kernel/locking/lockdep.c:3284 [inline]
 validate_chain kernel/locking/lockdep.c:3908 [inline]
 __lock_acquire+0x1774/0x30a4 kernel/locking/lockdep.c:5237
 lock_acquire+0x14c/0x2e0 kernel/locking/lockdep.c:5868
 percpu_down_read_internal include/linux/percpu-rwsem.h:53 [inline]
 percpu_down_read_freezable include/linux/percpu-rwsem.h:83 [inline]
 __sb_start_write include/linux/fs.h:1798 [inline]
 sb_start_intwrite include/linux/fs.h:1981 [inline]
 ocfs2_start_trans+0x1f4/0x6b0 fs/ocfs2/journal.c:370
 ocfs2_orphan_for_truncate fs/ocfs2/file.c:396 [inline]
 ocfs2_truncate_file+0x5b0/0x12f4 fs/ocfs2/file.c:500
 ocfs2_setattr+0x1148/0x17a0 fs/ocfs2/file.c:1212
 notify_change+0x9a4/0xc50 fs/attr.c:552
 do_truncate+0x198/0x210 fs/open.c:68
 handle_truncate fs/namei.c:3508 [inline]
 do_open fs/namei.c:3891 [inline]
 path_openat+0x25a0/0x2c40 fs/namei.c:4046
 do_filp_open+0x18c/0x36c fs/namei.c:4073
 do_sys_openat2+0x11c/0x1b4 fs/open.c:1435
 do_sys_open fs/open.c:1450 [inline]
 __do_sys_openat fs/open.c:1466 [inline]
 __se_sys_openat fs/open.c:1461 [inline]
 __arm64_sys_openat+0x120/0x158 fs/open.c:1461
 __invoke_syscall arch/arm64/kernel/syscall.c:35 [inline]
 invoke_syscall+0x98/0x2b8 arch/arm64/kernel/syscall.c:49
 el0_svc_common+0x130/0x23c arch/arm64/kernel/syscall.c:132
 do_el0_svc+0x48/0x58 arch/arm64/kernel/syscall.c:151
 el0_svc+0x58/0x180 arch/arm64/kernel/entry-common.c:879
 el0t_64_sync_handler+0x84/0x12c arch/arm64/kernel/entry-common.c:898
 el0t_64_sync+0x198/0x19c arch/arm64/kernel/entry.S:596


---
If you want syzbot to run the reproducer, reply with:
#syz test: git://repo/address.git branch-or-commit-hash
If you attach or paste a git patch, syzbot will apply it before testing.
