Received: from mail-io1-f78.google.com (mail-io1-f78.google.com [209.85.166.78])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A00D248867
	for <ocfs2-devel@lists.linux.dev>; Fri, 22 Aug 2025 08:08:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.78
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755850121; cv=none; b=HGpZWbA83w75GEkn4isMRHP7lvxWO5hXo3QGN2ljJfQXqYSKU5Qm6aWkpvfdB3Nbrn19wWbDPiVdzvvpAniglElFaaW1oizI3Th5j+LvjClOMzKell1Sd7pPdsMpWhBqxk8lqkeidomVEkg/+IPOwrsZ0/8DALQfLMq2HQgiAAI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755850121; c=relaxed/simple;
	bh=/qV9ojUl0c2ishSwj13X253IhU7nJq/aWG9ozUU3H3U=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=gOlJ0iN28+CL9S7FQlWTPxbgSEOb/c4I0U9qLVSAtqoEDlEWHczKOMikY71J/GQiR3aU66+JjXb71KXPI/kiQUHv6vwQJha+3BaWEvHXXxO22/QMBiLcRm23trmzriGWSSjoAL4ddwb7SG080o9DMx30QlmbSgyA3O6CFbIOP4I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.78
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-io1-f78.google.com with SMTP id ca18e2360f4ac-88432e1c782so200177639f.2
        for <ocfs2-devel@lists.linux.dev>; Fri, 22 Aug 2025 01:08:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755850119; x=1756454919;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=T4jfPc5/LwqxyMCdCx5fX/NuBeMNQdYdZKUv9q2aiQM=;
        b=AyFMxWd6BK+C8KLHYgXjLsMr+MOrDXad4ci5SiCu/YoizqgW6JwjMEdDIQf5pT8/OL
         zNvuVeO+DHSyBb3yX82lKGmlQoYyVJENq92gCYO761dwpBYBUariAQkn41ru7XQpV32+
         HNkq81QPIwTQlGl9P1nLMJoD4QaaCrANYkn1OmXBV/58jWM2djKTCfiJsuCafbdQi9UK
         zRXfCum6JxCngCx76c/KDb8sA+W7B9BaVFbuWeTZdyK4oTy7zarUO90Iiz5buQWpbJA7
         zdRn03X/56k57VYEq+Djw3FzR79X8yiUGdRzNWEoWw1XDLmlzIz9AKY5/9J4STqCyCtn
         J9JA==
X-Forwarded-Encrypted: i=1; AJvYcCVcZXWQD6BM6pbdGAEyEEmldE+C3H/YLjaI2IMui6gCjcLLEth14jL9f1hAramUbWuJDZVju/KpPdwGcw==@lists.linux.dev
X-Gm-Message-State: AOJu0YyoUfOVOyEHIBjRSIW5lOf/cKtiVmQAlqfYoGdlv9NbrZwGT8Zp
	CErm7LpEUKKpGVGRPY25ifbYpK52KWWleAITLvLVacfmHyRb3ZFU0z1843FgBxHHKtMxESnXGZc
	03PaW4qS8WVfpg8NgtMLXQQmW+EZldTK4UfBlqiglmwYnP+JvQyvd9gZBvjs=
X-Google-Smtp-Source: AGHT+IF+9wkWuUit4MELBJX00v5+RMivFNlwd0zTu5GmvwLZmUkmq4k4bG4AqKchJ/DTMaFjVYjBQRP7Ei3OWP66qEPoY9J3W3Ob
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:3c88:b0:3e5:7281:eb6b with SMTP id
 e9e14a558f8ab-3e922ad9604mr40719995ab.23.1755850118679; Fri, 22 Aug 2025
 01:08:38 -0700 (PDT)
Date: Fri, 22 Aug 2025 01:08:38 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <68a82586.a00a0220.33401d.0250.GAE@google.com>
Subject: [syzbot] [ocfs2?] possible deadlock in ocfs2_xattr_ibody_find (2)
From: syzbot <syzbot+0f3b07683129d8b11141@syzkaller.appspotmail.com>
To: jlbec@evilplan.org, joseph.qi@linux.alibaba.com, 
	linux-kernel@vger.kernel.org, mark@fasheh.com, ocfs2-devel@lists.linux.dev, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    8f5ae30d69d7 Linux 6.17-rc1
git tree:       git://git.kernel.org/pub/scm/linux/kernel/git/arm64/linux.git for-kernelci
console output: https://syzkaller.appspot.com/x/log.txt?x=1349f442580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=8c5ac3d8b8abfcb
dashboard link: https://syzkaller.appspot.com/bug?extid=0f3b07683129d8b11141
compiler:       Debian clang version 20.1.7 (++20250616065708+6146a88f6049-1~exp1~20250616065826.132), Debian LLD 20.1.7
userspace arch: arm64

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/18a2e4bd0c4a/disk-8f5ae30d.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/3b5395881b25/vmlinux-8f5ae30d.xz
kernel image: https://storage.googleapis.com/syzbot-assets/e875f4e3b7ff/Image-8f5ae30d.gz.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+0f3b07683129d8b11141@syzkaller.appspotmail.com

loop3: detected capacity change from 0 to 262144
JBD2: Ignoring recovery information on journal
ocfs2: Mounting device (7,3) on (node local, slot 0) with ordered data mode.
======================================================
WARNING: possible circular locking dependency detected
6.17.0-rc1-syzkaller-g8f5ae30d69d7 #0 Not tainted
------------------------------------------------------
syz.3.387/8571 is trying to acquire lock:
ffff0000ddea94a0 (&ocfs2_file_ip_alloc_sem_key){++++}-{4:4}, at: ocfs2_xattr_ibody_find+0x100/0x668 fs/ocfs2/xattr.c:2689

but task is already holding lock:
ffff0000ddea9538 (&oi->ip_xattr_sem){++++}-{4:4}, at: ocfs2_xattr_set_handle+0x2a8/0x5e4 fs/ocfs2/xattr.c:3501

which lock already depends on the new lock.


the existing dependency chain (in reverse order) is:

-> #6 (&oi->ip_xattr_sem){++++}-{4:4}:
       down_read+0x58/0x2f8 kernel/locking/rwsem.c:1537
       ocfs2_xattr_get+0xe8/0x220 fs/ocfs2/xattr.c:1338
       ocfs2_xattr_security_get+0x40/0x54 fs/ocfs2/xattr.c:7231
       __vfs_getxattr+0x394/0x3c0 fs/xattr.c:423
       smk_fetch+0xc4/0x150 security/smack/smack_lsm.c:289
       smack_d_instantiate+0x53c/0x7a4 security/smack/smack_lsm.c:3606
       security_d_instantiate+0x100/0x204 security/security.c:4109
       d_instantiate+0x5c/0x9c fs/dcache.c:1961
       ocfs2_mknod+0x151c/0x1cf0 fs/ocfs2/namei.c:453
       ocfs2_mkdir+0x190/0x474 fs/ocfs2/namei.c:659
       vfs_mkdir+0x284/0x424 fs/namei.c:4366
       do_mkdirat+0x1f8/0x4c8 fs/namei.c:4399
       __do_sys_mkdirat fs/namei.c:4416 [inline]
       __se_sys_mkdirat fs/namei.c:4414 [inline]
       __arm64_sys_mkdirat+0x8c/0xa4 fs/namei.c:4414
       __invoke_syscall arch/arm64/kernel/syscall.c:35 [inline]
       invoke_syscall+0x98/0x2b8 arch/arm64/kernel/syscall.c:49
       el0_svc_common+0x130/0x23c arch/arm64/kernel/syscall.c:132
       do_el0_svc+0x48/0x58 arch/arm64/kernel/syscall.c:151
       el0_svc+0x58/0x180 arch/arm64/kernel/entry-common.c:879
       el0t_64_sync_handler+0x84/0x12c arch/arm64/kernel/entry-common.c:898
       el0t_64_sync+0x198/0x19c arch/arm64/kernel/entry.S:596

-> #5 (jbd2_handle){++++}-{0:0}:
       start_this_handle+0xe74/0x10dc fs/jbd2/transaction.c:444
       jbd2__journal_start+0x288/0x51c fs/jbd2/transaction.c:501
       jbd2_journal_start+0x3c/0x4c fs/jbd2/transaction.c:540
       ocfs2_start_trans+0x368/0x6b0 fs/ocfs2/journal.c:374
       ocfs2_local_alloc_slide_window fs/ocfs2/localalloc.c:1254 [inline]
       ocfs2_reserve_local_alloc_bits+0xba8/0x26a0 fs/ocfs2/localalloc.c:669
       ocfs2_reserve_clusters_with_limit+0x198/0x9e0 fs/ocfs2/suballoc.c:1168
       ocfs2_reserve_clusters+0x3c/0x50 fs/ocfs2/suballoc.c:1229
       ocfs2_mknod+0xc00/0x1cf0 fs/ocfs2/namei.c:357
       ocfs2_mkdir+0x190/0x474 fs/ocfs2/namei.c:659
       vfs_mkdir+0x284/0x424 fs/namei.c:4366
       do_mkdirat+0x1f8/0x4c8 fs/namei.c:4399
       __do_sys_mkdirat fs/namei.c:4416 [inline]
       __se_sys_mkdirat fs/namei.c:4414 [inline]
       __arm64_sys_mkdirat+0x8c/0xa4 fs/namei.c:4414
       __invoke_syscall arch/arm64/kernel/syscall.c:35 [inline]
       invoke_syscall+0x98/0x2b8 arch/arm64/kernel/syscall.c:49
       el0_svc_common+0x130/0x23c arch/arm64/kernel/syscall.c:132
       do_el0_svc+0x48/0x58 arch/arm64/kernel/syscall.c:151
       el0_svc+0x58/0x180 arch/arm64/kernel/entry-common.c:879
       el0t_64_sync_handler+0x84/0x12c arch/arm64/kernel/entry-common.c:898
       el0t_64_sync+0x198/0x19c arch/arm64/kernel/entry.S:596

-> #4 (&journal->j_trans_barrier){.+.+}-{4:4}:
       down_read+0x58/0x2f8 kernel/locking/rwsem.c:1537
       ocfs2_start_trans+0x35c/0x6b0 fs/ocfs2/journal.c:372
       ocfs2_local_alloc_slide_window fs/ocfs2/localalloc.c:1254 [inline]
       ocfs2_reserve_local_alloc_bits+0xba8/0x26a0 fs/ocfs2/localalloc.c:669
       ocfs2_reserve_clusters_with_limit+0x198/0x9e0 fs/ocfs2/suballoc.c:1168
       ocfs2_reserve_clusters+0x3c/0x50 fs/ocfs2/suballoc.c:1229
       ocfs2_mknod+0xc00/0x1cf0 fs/ocfs2/namei.c:357
       ocfs2_mkdir+0x190/0x474 fs/ocfs2/namei.c:659
       vfs_mkdir+0x284/0x424 fs/namei.c:4366
       do_mkdirat+0x1f8/0x4c8 fs/namei.c:4399
       __do_sys_mkdirat fs/namei.c:4416 [inline]
       __se_sys_mkdirat fs/namei.c:4414 [inline]
       __arm64_sys_mkdirat+0x8c/0xa4 fs/namei.c:4414
       __invoke_syscall arch/arm64/kernel/syscall.c:35 [inline]
       invoke_syscall+0x98/0x2b8 arch/arm64/kernel/syscall.c:49
       el0_svc_common+0x130/0x23c arch/arm64/kernel/syscall.c:132
       do_el0_svc+0x48/0x58 arch/arm64/kernel/syscall.c:151
       el0_svc+0x58/0x180 arch/arm64/kernel/entry-common.c:879
       el0t_64_sync_handler+0x84/0x12c arch/arm64/kernel/entry-common.c:898
       el0t_64_sync+0x198/0x19c arch/arm64/kernel/entry.S:596

-> #3 (sb_internal#6){.+.+}-{0:0}:
       percpu_down_read_internal include/linux/percpu-rwsem.h:53 [inline]
       percpu_down_read_freezable include/linux/percpu-rwsem.h:83 [inline]
       __sb_start_write include/linux/fs.h:1798 [inline]
       sb_start_intwrite include/linux/fs.h:1981 [inline]
       ocfs2_start_trans+0x1f4/0x6b0 fs/ocfs2/journal.c:370
       ocfs2_expand_inline_dir fs/ocfs2/dir.c:2875 [inline]
       ocfs2_extend_dir+0xbc0/0x3964 fs/ocfs2/dir.c:3207
       ocfs2_prepare_dir_for_insert+0x281c/0x4664 fs/ocfs2/dir.c:4312
       ocfs2_symlink+0x62c/0x1ff8 fs/ocfs2/namei.c:1875
       vfs_symlink+0x138/0x288 fs/namei.c:4730
       do_symlinkat+0x17c/0x360 fs/namei.c:4756
       __do_sys_symlinkat fs/namei.c:4772 [inline]
       __se_sys_symlinkat fs/namei.c:4769 [inline]
       __arm64_sys_symlinkat+0x9c/0xb4 fs/namei.c:4769
       __invoke_syscall arch/arm64/kernel/syscall.c:35 [inline]
       invoke_syscall+0x98/0x2b8 arch/arm64/kernel/syscall.c:49
       el0_svc_common+0x130/0x23c arch/arm64/kernel/syscall.c:132
       do_el0_svc+0x48/0x58 arch/arm64/kernel/syscall.c:151
       el0_svc+0x58/0x180 arch/arm64/kernel/entry-common.c:879
       el0t_64_sync_handler+0x84/0x12c arch/arm64/kernel/entry-common.c:898
       el0t_64_sync+0x198/0x19c arch/arm64/kernel/entry.S:596

-> #2 (&ocfs2_sysfile_lock_key[LOCAL_ALLOC_SYSTEM_INODE]){+.+.}-{4:4}:
       down_write+0x50/0xc0 kernel/locking/rwsem.c:1590
       inode_lock include/linux/fs.h:869 [inline]
       ocfs2_reserve_local_alloc_bits+0x104/0x26a0 fs/ocfs2/localalloc.c:636
       ocfs2_reserve_clusters_with_limit+0x198/0x9e0 fs/ocfs2/suballoc.c:1168
       ocfs2_reserve_clusters+0x3c/0x50 fs/ocfs2/suballoc.c:1229
       ocfs2_mknod+0xc00/0x1cf0 fs/ocfs2/namei.c:357
       ocfs2_mkdir+0x190/0x474 fs/ocfs2/namei.c:659
       vfs_mkdir+0x284/0x424 fs/namei.c:4366
       do_mkdirat+0x1f8/0x4c8 fs/namei.c:4399
       __do_sys_mkdirat fs/namei.c:4416 [inline]
       __se_sys_mkdirat fs/namei.c:4414 [inline]
       __arm64_sys_mkdirat+0x8c/0xa4 fs/namei.c:4414
       __invoke_syscall arch/arm64/kernel/syscall.c:35 [inline]
       invoke_syscall+0x98/0x2b8 arch/arm64/kernel/syscall.c:49
       el0_svc_common+0x130/0x23c arch/arm64/kernel/syscall.c:132
       do_el0_svc+0x48/0x58 arch/arm64/kernel/syscall.c:151
       el0_svc+0x58/0x180 arch/arm64/kernel/entry-common.c:879
       el0t_64_sync_handler+0x84/0x12c arch/arm64/kernel/entry-common.c:898
       el0t_64_sync+0x198/0x19c arch/arm64/kernel/entry.S:596

-> #1 (&ocfs2_sysfile_lock_key[EXTENT_ALLOC_SYSTEM_INODE]){+.+.}-{4:4}:
       down_write+0x50/0xc0 kernel/locking/rwsem.c:1590
       inode_lock include/linux/fs.h:869 [inline]
       ocfs2_reserve_suballoc_bits+0x12c/0x3b9c fs/ocfs2/suballoc.c:788
       ocfs2_reserve_new_metadata_blocks+0x368/0x810 fs/ocfs2/suballoc.c:984
       ocfs2_expand_inline_dir fs/ocfs2/dir.c:2845 [inline]
       ocfs2_extend_dir+0x970/0x3964 fs/ocfs2/dir.c:3207
       ocfs2_prepare_dir_for_insert+0x281c/0x4664 fs/ocfs2/dir.c:4312
       ocfs2_mknod+0x6ec/0x1cf0 fs/ocfs2/namei.c:297
       ocfs2_mkdir+0x190/0x474 fs/ocfs2/namei.c:659
       vfs_mkdir+0x284/0x424 fs/namei.c:4366
       do_mkdirat+0x1f8/0x4c8 fs/namei.c:4399
       __do_sys_mkdirat fs/namei.c:4416 [inline]
       __se_sys_mkdirat fs/namei.c:4414 [inline]
       __arm64_sys_mkdirat+0x8c/0xa4 fs/namei.c:4414
       __invoke_syscall arch/arm64/kernel/syscall.c:35 [inline]
       invoke_syscall+0x98/0x2b8 arch/arm64/kernel/syscall.c:49
       el0_svc_common+0x130/0x23c arch/arm64/kernel/syscall.c:132
       do_el0_svc+0x48/0x58 arch/arm64/kernel/syscall.c:151
       el0_svc+0x58/0x180 arch/arm64/kernel/entry-common.c:879
       el0t_64_sync_handler+0x84/0x12c arch/arm64/kernel/entry-common.c:898
       el0t_64_sync+0x198/0x19c arch/arm64/kernel/entry.S:596

-> #0 (&ocfs2_file_ip_alloc_sem_key){++++}-{4:4}:
       check_prev_add kernel/locking/lockdep.c:3165 [inline]
       check_prevs_add kernel/locking/lockdep.c:3284 [inline]
       validate_chain kernel/locking/lockdep.c:3908 [inline]
       __lock_acquire+0x1774/0x30a4 kernel/locking/lockdep.c:5237
       lock_acquire+0x14c/0x2e0 kernel/locking/lockdep.c:5868
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

other info that might help us debug this:

Chain exists of:
  &ocfs2_file_ip_alloc_sem_key --> jbd2_handle --> &oi->ip_xattr_sem

 Possible unsafe locking scenario:

       CPU0                    CPU1
       ----                    ----
  lock(&oi->ip_xattr_sem);
                               lock(jbd2_handle);
                               lock(&oi->ip_xattr_sem);
  rlock(&ocfs2_file_ip_alloc_sem_key);

 *** DEADLOCK ***

9 locks held by syz.3.387/8571:
 #0: ffff0000d7d5c428 (sb_writers#23){.+.+}-{0:0}, at: mnt_want_write+0x44/0x9c fs/namespace.c:557
 #1: ffff0000ddc03480 (&type->i_mutex_dir_key#18){++++}-{4:4}, at: inode_lock include/linux/fs.h:869 [inline]
 #1: ffff0000ddc03480 (&type->i_mutex_dir_key#18){++++}-{4:4}, at: open_last_lookups fs/namei.c:3804 [inline]
 #1: ffff0000ddc03480 (&type->i_mutex_dir_key#18){++++}-{4:4}, at: path_openat+0x638/0x2c40 fs/namei.c:4043
 #2: ffff0000f7d19800 (&ocfs2_sysfile_lock_key[INODE_ALLOC_SYSTEM_INODE]){+.+.}-{4:4}, at: inode_lock include/linux/fs.h:869 [inline]
 #2: ffff0000f7d19800 (&ocfs2_sysfile_lock_key[INODE_ALLOC_SYSTEM_INODE]){+.+.}-{4:4}, at: ocfs2_reserve_suballoc_bits+0x12c/0x3b9c fs/ocfs2/suballoc.c:788
 #3: ffff0000f7d1a640 (&ocfs2_sysfile_lock_key[EXTENT_ALLOC_SYSTEM_INODE]){+.+.}-{4:4}, at: inode_lock include/linux/fs.h:869 [inline]
 #3: ffff0000f7d1a640 (&ocfs2_sysfile_lock_key[EXTENT_ALLOC_SYSTEM_INODE]){+.+.}-{4:4}, at: ocfs2_reserve_suballoc_bits+0x12c/0x3b9c fs/ocfs2/suballoc.c:788
 #4: ffff0000ddeaed80 (&ocfs2_sysfile_lock_key[LOCAL_ALLOC_SYSTEM_INODE]){+.+.}-{4:4}, at: inode_lock include/linux/fs.h:869 [inline]
 #4: ffff0000ddeaed80 (&ocfs2_sysfile_lock_key[LOCAL_ALLOC_SYSTEM_INODE]){+.+.}-{4:4}, at: ocfs2_reserve_local_alloc_bits+0x104/0x26a0 fs/ocfs2/localalloc.c:636
 #5: ffff0000d7d5c618 (sb_internal#6){.+.+}-{0:0}, at: ocfs2_mknod+0xc50/0x1cf0 fs/ocfs2/namei.c:364
 #6: ffff0000db9fc8e8 (&journal->j_trans_barrier){.+.+}-{4:4}, at: ocfs2_start_trans+0x35c/0x6b0 fs/ocfs2/journal.c:372
 #7: ffff0000c7ed0950 (jbd2_handle){++++}-{0:0}, at: start_this_handle+0xe4c/0x10dc fs/jbd2/transaction.c:442
 #8: ffff0000ddea9538 (&oi->ip_xattr_sem){++++}-{4:4}, at: ocfs2_xattr_set_handle+0x2a8/0x5e4 fs/ocfs2/xattr.c:3501

stack backtrace:
CPU: 0 UID: 0 PID: 8571 Comm: syz.3.387 Not tainted 6.17.0-rc1-syzkaller-g8f5ae30d69d7 #0 PREEMPT 
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
