Received: from mail-il1-f200.google.com (mail-il1-f200.google.com [209.85.166.200])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D66E1D88A7
	for <ocfs2-devel@lists.linux.dev>; Fri, 13 Sep 2024 12:03:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.200
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726229010; cv=none; b=haoD8Np5Ys8JDe0hr+GrbK0NPXf81i6a1cI98bbyEIueaZBFER0qNul42h94pZXeEmUONNfnczdNFkfZFDUMApcxS/7pPmIatgASqYbuVYh+zY4pBvvetzPtH7lz5pd4B6X9wwbZMC5QVOK8q1fsBuB0XKZDNlbq2c9yCgNIE6Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726229010; c=relaxed/simple;
	bh=tNgeMXjDvL+TiCNwcR0o27mAcbyPcG76nRJvv8yT4N4=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:
	 Content-Type; b=Sy8cJuU1alRmltXO4VZeL7RVNlbODfca3hs21+FyBDQiLWwNCKp1zblZb6VAzclOdFGMoDxBslv4yMs91zv8nlrR8oCgt8Rnkaycci5unhruFfAnq0zuNDCVdCrYQ6l+Z3HcA5KWXdCEis3jTxODYqLD7is0oz8NyjIRL3Xxc6Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.200
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f200.google.com with SMTP id e9e14a558f8ab-3a050af2717so31758205ab.0
        for <ocfs2-devel@lists.linux.dev>; Fri, 13 Sep 2024 05:03:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726229007; x=1726833807;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=0CuCss4hcQXYo8gXczpusioqUfuxAee/T4Hca5JUlQU=;
        b=S1iLYojedJ0X1+WWe7iCheFL3kXnlCSTbEXhu4wm151lpS+DfyAxVOC84XqBuwurJA
         9UNuRQ35+p8Cj0fnS9a03/zwiBE+5MN4qFd//EyC+QQRPudjJPvFjg7m3+4ii6s1h/Yx
         /6vKRdDtLBa7w8kLt4P6D6tuBADweqxqYJyHMNfX7WJiWQ94Z6AAgJ5iHUl0dxAN2eRk
         PJ14moaOYtO/1wdgC6CIgMvCpoXIjPUwBooVbpVDg+6LYOTvBRwIip+E8omID882HRhF
         byNj6z3SKIZMUoxAC6L4WGpAPg1w5OKMiJs0eov3K67y4y4eMAliU6i6wHdAMTInxWKf
         qVpw==
X-Forwarded-Encrypted: i=1; AJvYcCVT884f6F1DYgPBAvlFU08eLOy5PhSY6fWgxvnjyfnVSFtRFOugJ10SYjkNsjpwqa2KK+cCqXq8khq1IQ==@lists.linux.dev
X-Gm-Message-State: AOJu0YygJxvrq33toMSvJKLtqJG08f25yhGlOeLerEbTA0qHbfGNo5Fs
	DgOofFtYzp50ib4p85Mor7Dt8+fUecS2BvimH7ywj/9XnKSfq4XUhDAXQkExiPcVlhGxN3Z6RJk
	dcJqnOCRFgi8qN4lWAi98WNmNbNB3sW4Vt7kFinjxM11BTLPNEvgMw4Q=
X-Google-Smtp-Source: AGHT+IGGaUN+oyMIHh+Qc1534VLV8yzOBew362REdz+8Ssxd+a36G1/CAVGK60TTQ6eX9OsBxlCqIVYfccQR+K9InqaZpz7vb4aJ
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:2145:b0:39f:7183:adfb with SMTP id
 e9e14a558f8ab-3a0848aff16mr57967665ab.2.1726229007457; Fri, 13 Sep 2024
 05:03:27 -0700 (PDT)
Date: Fri, 13 Sep 2024 05:03:27 -0700
In-Reply-To: <000000000000ac4a9d062044e498@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000ca7a2a0621ff0292@google.com>
Subject: Re: [syzbot] [ocfs2?] possible deadlock in ocfs2_reserve_local_alloc_bits
From: syzbot <syzbot+843fa26882088a9ee7e3@syzkaller.appspotmail.com>
To: jlbec@evilplan.org, joseph.qi@linux.alibaba.com, 
	linux-kernel@vger.kernel.org, mark@fasheh.com, ocfs2-devel@lists.linux.dev, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

syzbot has found a reproducer for the following issue on:

HEAD commit:    df54f4a16f82 Merge branch 'for-next/core' into for-kernelci
git tree:       git://git.kernel.org/pub/scm/linux/kernel/git/arm64/linux.git for-kernelci
console output: https://syzkaller.appspot.com/x/log.txt?x=1297f100580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=dde5a5ba8d41ee9e
dashboard link: https://syzkaller.appspot.com/bug?extid=843fa26882088a9ee7e3
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40
userspace arch: arm64
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=10e127c7980000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=13587807980000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/aa2eb06e0aea/disk-df54f4a1.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/14728733d385/vmlinux-df54f4a1.xz
kernel image: https://storage.googleapis.com/syzbot-assets/99816271407d/Image-df54f4a1.gz.xz
mounted in repro: https://storage.googleapis.com/syzbot-assets/421959d04855/mount_0.gz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+843fa26882088a9ee7e3@syzkaller.appspotmail.com

=======================================================
ocfs2: Mounting device (7,0) on (node local, slot 0) with ordered data mode.
======================================================
WARNING: possible circular locking dependency detected
6.11.0-rc5-syzkaller-gdf54f4a16f82 #0 Not tainted
------------------------------------------------------
syz-executor319/6389 is trying to acquire lock:
ffff0000dee22640 (&ocfs2_sysfile_lock_key[args->fi_sysfile_type]#5){+.+.}-{3:3}, at: inode_lock include/linux/fs.h:799 [inline]
ffff0000dee22640 (&ocfs2_sysfile_lock_key[args->fi_sysfile_type]#5){+.+.}-{3:3}, at: ocfs2_reserve_local_alloc_bits+0xfc/0x247c fs/ocfs2/localalloc.c:636

but task is already holding lock:
ffff0000dee231b8 (&oi->ip_xattr_sem){+.+.}-{3:3}, at: ocfs2_xattr_set+0x4e0/0x1448 fs/ocfs2/xattr.c:3584

which lock already depends on the new lock.


the existing dependency chain (in reverse order) is:

-> #4 (&oi->ip_xattr_sem){+.+.}-{3:3}:
       down_write+0x50/0xc0 kernel/locking/rwsem.c:1579
       ocfs2_xattr_set_handle+0x40c/0x824 fs/ocfs2/xattr.c:3502
       ocfs2_init_security_set+0xb4/0xd8 fs/ocfs2/xattr.c:7326
       ocfs2_mknod+0x1408/0x243c fs/ocfs2/namei.c:417
       ocfs2_create+0x194/0x4e0 fs/ocfs2/namei.c:672
       lookup_open fs/namei.c:3578 [inline]
       open_last_lookups fs/namei.c:3647 [inline]
       path_openat+0xfb4/0x29f8 fs/namei.c:3883
       do_filp_open+0x1bc/0x3cc fs/namei.c:3913
       do_sys_openat2+0x124/0x1b8 fs/open.c:1416
       do_sys_open fs/open.c:1431 [inline]
       __do_sys_openat fs/open.c:1447 [inline]
       __se_sys_openat fs/open.c:1442 [inline]
       __arm64_sys_openat+0x1f0/0x240 fs/open.c:1442
       __invoke_syscall arch/arm64/kernel/syscall.c:35 [inline]
       invoke_syscall+0x98/0x2b8 arch/arm64/kernel/syscall.c:49
       el0_svc_common+0x130/0x23c arch/arm64/kernel/syscall.c:132
       do_el0_svc+0x48/0x58 arch/arm64/kernel/syscall.c:151
       el0_svc+0x54/0x168 arch/arm64/kernel/entry-common.c:712
       el0t_64_sync_handler+0x84/0xfc arch/arm64/kernel/entry-common.c:730
       el0t_64_sync+0x190/0x194 arch/arm64/kernel/entry.S:598

-> #3 (jbd2_handle){.+.+}-{0:0}:
       start_this_handle+0xf34/0x11c4 fs/jbd2/transaction.c:448
       jbd2__journal_start+0x298/0x544 fs/jbd2/transaction.c:505
       jbd2_journal_start+0x3c/0x4c fs/jbd2/transaction.c:544
       ocfs2_start_trans+0x3d0/0x71c fs/ocfs2/journal.c:352
       ocfs2_block_group_alloc fs/ocfs2/suballoc.c:685 [inline]
       ocfs2_reserve_suballoc_bits+0x840/0x4288 fs/ocfs2/suballoc.c:832
       ocfs2_reserve_new_metadata_blocks+0x384/0x848 fs/ocfs2/suballoc.c:982
       ocfs2_mknod+0xdc8/0x243c fs/ocfs2/namei.c:345
       ocfs2_create+0x194/0x4e0 fs/ocfs2/namei.c:672
       lookup_open fs/namei.c:3578 [inline]
       open_last_lookups fs/namei.c:3647 [inline]
       path_openat+0xfb4/0x29f8 fs/namei.c:3883
       do_filp_open+0x1bc/0x3cc fs/namei.c:3913
       do_sys_openat2+0x124/0x1b8 fs/open.c:1416
       do_sys_open fs/open.c:1431 [inline]
       __do_sys_openat fs/open.c:1447 [inline]
       __se_sys_openat fs/open.c:1442 [inline]
       __arm64_sys_openat+0x1f0/0x240 fs/open.c:1442
       __invoke_syscall arch/arm64/kernel/syscall.c:35 [inline]
       invoke_syscall+0x98/0x2b8 arch/arm64/kernel/syscall.c:49
       el0_svc_common+0x130/0x23c arch/arm64/kernel/syscall.c:132
       do_el0_svc+0x48/0x58 arch/arm64/kernel/syscall.c:151
       el0_svc+0x54/0x168 arch/arm64/kernel/entry-common.c:712
       el0t_64_sync_handler+0x84/0xfc arch/arm64/kernel/entry-common.c:730
       el0t_64_sync+0x190/0x194 arch/arm64/kernel/entry.S:598

-> #2 (&journal->j_trans_barrier){.+.+}-{3:3}:
       down_read+0x58/0x2fc kernel/locking/rwsem.c:1526
       ocfs2_start_trans+0x3c4/0x71c fs/ocfs2/journal.c:350
       ocfs2_block_group_alloc fs/ocfs2/suballoc.c:685 [inline]
       ocfs2_reserve_suballoc_bits+0x840/0x4288 fs/ocfs2/suballoc.c:832
       ocfs2_reserve_new_metadata_blocks+0x384/0x848 fs/ocfs2/suballoc.c:982
       ocfs2_mknod+0xdc8/0x243c fs/ocfs2/namei.c:345
       ocfs2_create+0x194/0x4e0 fs/ocfs2/namei.c:672
       lookup_open fs/namei.c:3578 [inline]
       open_last_lookups fs/namei.c:3647 [inline]
       path_openat+0xfb4/0x29f8 fs/namei.c:3883
       do_filp_open+0x1bc/0x3cc fs/namei.c:3913
       do_sys_openat2+0x124/0x1b8 fs/open.c:1416
       do_sys_open fs/open.c:1431 [inline]
       __do_sys_openat fs/open.c:1447 [inline]
       __se_sys_openat fs/open.c:1442 [inline]
       __arm64_sys_openat+0x1f0/0x240 fs/open.c:1442
       __invoke_syscall arch/arm64/kernel/syscall.c:35 [inline]
       invoke_syscall+0x98/0x2b8 arch/arm64/kernel/syscall.c:49
       el0_svc_common+0x130/0x23c arch/arm64/kernel/syscall.c:132
       do_el0_svc+0x48/0x58 arch/arm64/kernel/syscall.c:151
       el0_svc+0x54/0x168 arch/arm64/kernel/entry-common.c:712
       el0t_64_sync_handler+0x84/0xfc arch/arm64/kernel/entry-common.c:730
       el0t_64_sync+0x190/0x194 arch/arm64/kernel/entry.S:598

-> #1 (sb_internal#2){.+.+}-{0:0}:
       percpu_down_read include/linux/percpu-rwsem.h:51 [inline]
       __sb_start_write include/linux/fs.h:1675 [inline]
       sb_start_intwrite include/linux/fs.h:1858 [inline]
       ocfs2_start_trans+0x244/0x71c fs/ocfs2/journal.c:348
       ocfs2_mknod+0xe58/0x243c fs/ocfs2/namei.c:359
       ocfs2_create+0x194/0x4e0 fs/ocfs2/namei.c:672
       lookup_open fs/namei.c:3578 [inline]
       open_last_lookups fs/namei.c:3647 [inline]
       path_openat+0xfb4/0x29f8 fs/namei.c:3883
       do_filp_open+0x1bc/0x3cc fs/namei.c:3913
       do_sys_openat2+0x124/0x1b8 fs/open.c:1416
       do_sys_open fs/open.c:1431 [inline]
       __do_sys_openat fs/open.c:1447 [inline]
       __se_sys_openat fs/open.c:1442 [inline]
       __arm64_sys_openat+0x1f0/0x240 fs/open.c:1442
       __invoke_syscall arch/arm64/kernel/syscall.c:35 [inline]
       invoke_syscall+0x98/0x2b8 arch/arm64/kernel/syscall.c:49
       el0_svc_common+0x130/0x23c arch/arm64/kernel/syscall.c:132
       do_el0_svc+0x48/0x58 arch/arm64/kernel/syscall.c:151
       el0_svc+0x54/0x168 arch/arm64/kernel/entry-common.c:712
       el0t_64_sync_handler+0x84/0xfc arch/arm64/kernel/entry-common.c:730
       el0t_64_sync+0x190/0x194 arch/arm64/kernel/entry.S:598

-> #0 (&ocfs2_sysfile_lock_key[args->fi_sysfile_type]#5){+.+.}-{3:3}:
       check_prev_add kernel/locking/lockdep.c:3133 [inline]
       check_prevs_add kernel/locking/lockdep.c:3252 [inline]
       validate_chain kernel/locking/lockdep.c:3868 [inline]
       __lock_acquire+0x33d8/0x779c kernel/locking/lockdep.c:5142
       lock_acquire+0x240/0x728 kernel/locking/lockdep.c:5759
       down_write+0x50/0xc0 kernel/locking/rwsem.c:1579
       inode_lock include/linux/fs.h:799 [inline]
       ocfs2_reserve_local_alloc_bits+0xfc/0x247c fs/ocfs2/localalloc.c:636
       ocfs2_reserve_clusters_with_limit+0x194/0xabc fs/ocfs2/suballoc.c:1166
       ocfs2_reserve_clusters+0x3c/0x50 fs/ocfs2/suballoc.c:1227
       ocfs2_init_xattr_set_ctxt+0x404/0x968 fs/ocfs2/xattr.c:3287
       ocfs2_xattr_set+0xbe0/0x1448 fs/ocfs2/xattr.c:3635
       ocfs2_xattr_trusted_set+0x4c/0x64 fs/ocfs2/xattr.c:7355
       __vfs_setxattr+0x3d8/0x400 fs/xattr.c:200
       __vfs_setxattr_noperm+0x110/0x578 fs/xattr.c:234
       __vfs_setxattr_locked+0x1ec/0x218 fs/xattr.c:295
       vfs_setxattr+0x1a8/0x344 fs/xattr.c:321
       do_setxattr fs/xattr.c:629 [inline]
       path_setxattr+0x30c/0x428 fs/xattr.c:658
       __do_sys_setxattr fs/xattr.c:676 [inline]
       __se_sys_setxattr fs/xattr.c:672 [inline]
       __arm64_sys_setxattr+0xbc/0xd8 fs/xattr.c:672
       __invoke_syscall arch/arm64/kernel/syscall.c:35 [inline]
       invoke_syscall+0x98/0x2b8 arch/arm64/kernel/syscall.c:49
       el0_svc_common+0x130/0x23c arch/arm64/kernel/syscall.c:132
       do_el0_svc+0x48/0x58 arch/arm64/kernel/syscall.c:151
       el0_svc+0x54/0x168 arch/arm64/kernel/entry-common.c:712
       el0t_64_sync_handler+0x84/0xfc arch/arm64/kernel/entry-common.c:730
       el0t_64_sync+0x190/0x194 arch/arm64/kernel/entry.S:598

other info that might help us debug this:

Chain exists of:
  &ocfs2_sysfile_lock_key[args->fi_sysfile_type]#5 --> jbd2_handle --> &oi->ip_xattr_sem

 Possible unsafe locking scenario:

       CPU0                    CPU1
       ----                    ----
  lock(&oi->ip_xattr_sem);
                               lock(jbd2_handle);
                               lock(&oi->ip_xattr_sem);
  lock(&ocfs2_sysfile_lock_key[args->fi_sysfile_type]#5);

 *** DEADLOCK ***

3 locks held by syz-executor319/6389:
 #0: ffff0000d9cc4420 (sb_writers#8){.+.+}-{0:0}, at: mnt_want_write+0x44/0x9c fs/namespace.c:515
 #1: ffff0000dee23480 (&sb->s_type->i_mutex_key#16){+.+.}-{3:3}, at: inode_lock include/linux/fs.h:799 [inline]
 #1: ffff0000dee23480 (&sb->s_type->i_mutex_key#16){+.+.}-{3:3}, at: vfs_setxattr+0x17c/0x344 fs/xattr.c:320
 #2: ffff0000dee231b8 (&oi->ip_xattr_sem){+.+.}-{3:3}, at: ocfs2_xattr_set+0x4e0/0x1448 fs/ocfs2/xattr.c:3584

stack backtrace:
CPU: 1 UID: 0 PID: 6389 Comm: syz-executor319 Not tainted 6.11.0-rc5-syzkaller-gdf54f4a16f82 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 08/06/2024
Call trace:
 dump_backtrace+0x1b8/0x1e4 arch/arm64/kernel/stacktrace.c:317
 show_stack+0x2c/0x3c arch/arm64/kernel/stacktrace.c:324
 __dump_stack lib/dump_stack.c:93 [inline]
 dump_stack_lvl+0xe4/0x150 lib/dump_stack.c:119
 dump_stack+0x1c/0x28 lib/dump_stack.c:128
 print_circular_bug+0x150/0x1b8 kernel/locking/lockdep.c:2059
 check_noncircular+0x310/0x404 kernel/locking/lockdep.c:2186
 check_prev_add kernel/locking/lockdep.c:3133 [inline]
 check_prevs_add kernel/locking/lockdep.c:3252 [inline]
 validate_chain kernel/locking/lockdep.c:3868 [inline]
 __lock_acquire+0x33d8/0x779c kernel/locking/lockdep.c:5142
 lock_acquire+0x240/0x728 kernel/locking/lockdep.c:5759
 down_write+0x50/0xc0 kernel/locking/rwsem.c:1579
 inode_lock include/linux/fs.h:799 [inline]
 ocfs2_reserve_local_alloc_bits+0xfc/0x247c fs/ocfs2/localalloc.c:636
 ocfs2_reserve_clusters_with_limit+0x194/0xabc fs/ocfs2/suballoc.c:1166
 ocfs2_reserve_clusters+0x3c/0x50 fs/ocfs2/suballoc.c:1227
 ocfs2_init_xattr_set_ctxt+0x404/0x968 fs/ocfs2/xattr.c:3287
 ocfs2_xattr_set+0xbe0/0x1448 fs/ocfs2/xattr.c:3635
 ocfs2_xattr_trusted_set+0x4c/0x64 fs/ocfs2/xattr.c:7355
 __vfs_setxattr+0x3d8/0x400 fs/xattr.c:200
 __vfs_setxattr_noperm+0x110/0x578 fs/xattr.c:234
 __vfs_setxattr_locked+0x1ec/0x218 fs/xattr.c:295
 vfs_setxattr+0x1a8/0x344 fs/xattr.c:321
 do_setxattr fs/xattr.c:629 [inline]
 path_setxattr+0x30c/0x428 fs/xattr.c:658
 __do_sys_setxattr fs/xattr.c:676 [inline]
 __se_sys_setxattr fs/xattr.c:672 [inline]
 __arm64_sys_setxattr+0xbc/0xd8 fs/xattr.c:672
 __invoke_syscall arch/arm64/kernel/syscall.c:35 [inline]
 invoke_syscall+0x98/0x2b8 arch/arm64/kernel/syscall.c:49
 el0_svc_common+0x130/0x23c arch/arm64/kernel/syscall.c:132
 do_el0_svc+0x48/0x58 arch/arm64/kernel/syscall.c:151
 el0_svc+0x54/0x168 arch/arm64/kernel/entry-common.c:712
 el0t_64_sync_handler+0x84/0xfc arch/arm64/kernel/entry-common.c:730
 el0t_64_sync+0x190/0x194 arch/arm64/kernel/entry.S:598


---
If you want syzbot to run the reproducer, reply with:
#syz test: git://repo/address.git branch-or-commit-hash
If you attach or paste a git patch, syzbot will apply it before testing.
