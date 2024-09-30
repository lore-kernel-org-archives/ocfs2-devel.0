Received: from mail-il1-f198.google.com (mail-il1-f198.google.com [209.85.166.198])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFF836FC3
	for <ocfs2-devel@lists.linux.dev>; Mon, 30 Sep 2024 01:47:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.198
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727660842; cv=none; b=m8fbTYuD8kPZxeHMRXu5HIACNVTtrchVtX+TpqEymMzP+Y0ExfEHxgN5zD0ytr3oa7rVRgXOXl7wWf/57/QXbW3g/t7TIYlHJNL2NF37VM0h31zLx92LOKw07533Y35LfWIoYATQRxUQekxz7UdYhCe+NwyGq3D6s4W5+5DYzl0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727660842; c=relaxed/simple;
	bh=5w7bvdn01DGtQmcWOweYLWywUuoaciALn65k3W9LIQ4=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=DDB1aSbrrXPZsP53FiE6oSOwlk+ZTaUvaS+foW0NAQeQRZTDI2GwmzBAXPNT8V7UYk1sicT7iJdWs14EpPN9yXP7/+pqg4tC/J8Wf5x1Uzen1azeEHhB+kFHeMUn12ZgbqF96IyZrtqSikLBWbWjw1e632sFTbFDAHNkmMIR254=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.198
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f198.google.com with SMTP id e9e14a558f8ab-3a34205e146so47930275ab.3
        for <ocfs2-devel@lists.linux.dev>; Sun, 29 Sep 2024 18:47:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727660840; x=1728265640;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=q5pnIQ0XH0sqZOejmYvmRq43SJ3jo8JaPi4wZKNRILU=;
        b=Ll7zmObC7VeTQL+yPggeOl/yYzXwkd/peu+aSOfZ7asGWEvdI7UojFTblxq20YL/fB
         RhMu/74Fuk4Gr8pF2XY87iA1UiWkjOmA6zTfe8s+btwyPP3lrMv3wTr3lagz8S/ZcTTU
         747nXiRQGOpKbZtUehnu4nBkSJyi4KK526JgnqQC+q4++hS7ywNnDkzmJb0GOa4l+9O5
         mc2kWecXTPEnKwXzlfQ8OxotBKN0RjPj1wyY5ZgDJCECHiUPUeTS/wUjXXC0JNaAjfNe
         PXpt2r6+THnhDs1kUjl4QMZFtuKU0eZil/GD5hlgJfIeG9kTFfm1KZxrZaHg4HBq3djN
         YXkg==
X-Forwarded-Encrypted: i=1; AJvYcCU+/u2UXbqh1S4mPnD9DuqrfxLo16hpHyvrjwe+AtpYdt8+0fZsTaTupYqMhosSXMLsT9dntVWHoKIGng==@lists.linux.dev
X-Gm-Message-State: AOJu0Yx/OQTLyNErdW++kaUugsXGXrRWTZ3ogk66ziNQL0wm/kO35pjs
	fnDL0We/Gv7tC4vD1GzSrEVvCIqbs3ywwXnccOg2pEKjXEQgguoFkp+QtTsDwuMToktXqFLIQBj
	ZDcripf4eYcaly9b7EmSuMCFL4/gBoe7msnN3ItwgqGrI7LL30Ymuc2M=
X-Google-Smtp-Source: AGHT+IFhX6YIBiRQtctHphDlcOa2dITtZCO+iCIut9IGiS4+w1mQDC+3U6hmvLETdXzEC2ECFFP3rGet1t0t/J+Q4Ornve3jpqTy
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1d84:b0:3a0:8c5f:90c0 with SMTP id
 e9e14a558f8ab-3a345169bd7mr87105315ab.10.1727660840136; Sun, 29 Sep 2024
 18:47:20 -0700 (PDT)
Date: Sun, 29 Sep 2024 18:47:20 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <66fa0328.050a0220.6bad9.002c.GAE@google.com>
Subject: [syzbot] [ocfs2?] possible deadlock in ocfs2_acquire_dquot
From: syzbot <syzbot+51244a05705883616c95@syzkaller.appspotmail.com>
To: jlbec@evilplan.org, joseph.qi@linux.alibaba.com, 
	linux-kernel@vger.kernel.org, mark@fasheh.com, ocfs2-devel@lists.linux.dev, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    e7ed34365879 Merge tag 'mailbox-v6.12' of git://git.kernel..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=10af8ea9980000
kernel config:  https://syzkaller.appspot.com/x/.config?x=84a3f3ed29aaafa0
dashboard link: https://syzkaller.appspot.com/bug?extid=51244a05705883616c95
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/eb021424c7db/disk-e7ed3436.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/2f5f0d22ea96/vmlinux-e7ed3436.xz
kernel image: https://storage.googleapis.com/syzbot-assets/47176809b11c/bzImage-e7ed3436.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+51244a05705883616c95@syzkaller.appspotmail.com

ocfs2: Mounting device (7,0) on (node local, slot 0) with ordered data mode.
======================================================
WARNING: possible circular locking dependency detected
6.11.0-syzkaller-12113-ge7ed34365879 #0 Not tainted
------------------------------------------------------
syz.0.286/7825 is trying to acquire lock:
ffff88807a27a610 (sb_internal#4){.+.+}-{0:0}, at: ocfs2_acquire_dquot+0x6df/0xb80 fs/ocfs2/quota_global.c:855

but task is already holding lock:
ffff88805ca04da0 (&ocfs2_quota_ip_alloc_sem_key){++++}-{3:3}, at: ocfs2_lock_global_qf+0x225/0x2b0 fs/ocfs2/quota_global.c:314

which lock already depends on the new lock.


the existing dependency chain (in reverse order) is:

-> #6 (&ocfs2_quota_ip_alloc_sem_key){++++}-{3:3}:
       lock_acquire+0x1ed/0x550 kernel/locking/lockdep.c:5825
       down_write+0x99/0x220 kernel/locking/rwsem.c:1577
       ocfs2_lock_global_qf+0x225/0x2b0 fs/ocfs2/quota_global.c:314
       ocfs2_acquire_dquot+0x2b0/0xb80 fs/ocfs2/quota_global.c:823
       dqget+0x770/0xeb0 fs/quota/dquot.c:976
       __dquot_initialize+0x2e3/0xec0 fs/quota/dquot.c:1504
       ocfs2_get_init_inode+0x158/0x1c0 fs/ocfs2/namei.c:202
       ocfs2_mknod+0xcfa/0x2b40 fs/ocfs2/namei.c:308
       ocfs2_mkdir+0x1ab/0x480 fs/ocfs2/namei.c:655
       vfs_mkdir+0x2f9/0x4f0 fs/namei.c:4257
       do_mkdirat+0x264/0x3a0 fs/namei.c:4280
       __do_sys_mkdir fs/namei.c:4300 [inline]
       __se_sys_mkdir fs/namei.c:4298 [inline]
       __x64_sys_mkdir+0x6c/0x80 fs/namei.c:4298
       do_syscall_x64 arch/x86/entry/common.c:52 [inline]
       do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
       entry_SYSCALL_64_after_hwframe+0x77/0x7f

-> #5 (&ocfs2_sysfile_lock_key[args->fi_sysfile_type]#7){+.+.}-{3:3}:
       lock_acquire+0x1ed/0x550 kernel/locking/lockdep.c:5825
       down_write+0x99/0x220 kernel/locking/rwsem.c:1577
       inode_lock include/linux/fs.h:815 [inline]
       ocfs2_lock_global_qf+0x206/0x2b0 fs/ocfs2/quota_global.c:313
       ocfs2_acquire_dquot+0x2b0/0xb80 fs/ocfs2/quota_global.c:823
       dqget+0x770/0xeb0 fs/quota/dquot.c:976
       __dquot_initialize+0x2e3/0xec0 fs/quota/dquot.c:1504
       ocfs2_get_init_inode+0x158/0x1c0 fs/ocfs2/namei.c:202
       ocfs2_mknod+0xcfa/0x2b40 fs/ocfs2/namei.c:308
       ocfs2_mkdir+0x1ab/0x480 fs/ocfs2/namei.c:655
       vfs_mkdir+0x2f9/0x4f0 fs/namei.c:4257
       do_mkdirat+0x264/0x3a0 fs/namei.c:4280
       __do_sys_mkdir fs/namei.c:4300 [inline]
       __se_sys_mkdir fs/namei.c:4298 [inline]
       __x64_sys_mkdir+0x6c/0x80 fs/namei.c:4298
       do_syscall_x64 arch/x86/entry/common.c:52 [inline]
       do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
       entry_SYSCALL_64_after_hwframe+0x77/0x7f

-> #4 (&dquot->dq_lock){+.+.}-{3:3}:
       lock_acquire+0x1ed/0x550 kernel/locking/lockdep.c:5825
       __mutex_lock_common kernel/locking/mutex.c:608 [inline]
       __mutex_lock+0x136/0xd70 kernel/locking/mutex.c:752
       wait_on_dquot fs/quota/dquot.c:355 [inline]
       dqget+0x6e6/0xeb0 fs/quota/dquot.c:971
       dquot_transfer+0x2c2/0x6d0 fs/quota/dquot.c:2139
       ext4_setattr+0xaf3/0x1bc0 fs/ext4/inode.c:5368
       notify_change+0xbca/0xe90 fs/attr.c:503
       chown_common+0x501/0x850 fs/open.c:793
       do_fchownat+0x16a/0x240 fs/open.c:824
       __do_sys_lchown fs/open.c:849 [inline]
       __se_sys_lchown fs/open.c:847 [inline]
       __x64_sys_lchown+0x85/0xa0 fs/open.c:847
       do_syscall_x64 arch/x86/entry/common.c:52 [inline]
       do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
       entry_SYSCALL_64_after_hwframe+0x77/0x7f

-> #3 (&ei->xattr_sem){++++}-{3:3}:
       lock_acquire+0x1ed/0x550 kernel/locking/lockdep.c:5825
       down_write+0x99/0x220 kernel/locking/rwsem.c:1577
       ext4_write_lock_xattr fs/ext4/xattr.h:154 [inline]
       ext4_xattr_set_handle+0x277/0x1580 fs/ext4/xattr.c:2373
       ext4_initxattrs+0xa3/0x120 fs/ext4/xattr_security.c:44
       security_inode_init_security+0x29c/0x480 security/security.c:1846
       __ext4_new_inode+0x3635/0x4380 fs/ext4/ialloc.c:1323
       ext4_create+0x279/0x550 fs/ext4/namei.c:2834
       lookup_open fs/namei.c:3595 [inline]
       open_last_lookups fs/namei.c:3694 [inline]
       path_openat+0x1c03/0x3590 fs/namei.c:3930
       do_filp_open+0x235/0x490 fs/namei.c:3960
       do_sys_openat2+0x13e/0x1d0 fs/open.c:1415
       do_sys_open fs/open.c:1430 [inline]
       __do_sys_openat fs/open.c:1446 [inline]
       __se_sys_openat fs/open.c:1441 [inline]
       __x64_sys_openat+0x247/0x2a0 fs/open.c:1441
       do_syscall_x64 arch/x86/entry/common.c:52 [inline]
       do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
       entry_SYSCALL_64_after_hwframe+0x77/0x7f

-> #2 (jbd2_handle){++++}-{0:0}:
       lock_acquire+0x1ed/0x550 kernel/locking/lockdep.c:5825
       start_this_handle+0x1eb4/0x2110 fs/jbd2/transaction.c:448
       jbd2__journal_start+0x2da/0x5d0 fs/jbd2/transaction.c:505
       jbd2_journal_start+0x29/0x40 fs/jbd2/transaction.c:544
       ocfs2_start_trans+0x3c9/0x700 fs/ocfs2/journal.c:352
       ocfs2_block_group_alloc fs/ocfs2/suballoc.c:685 [inline]
       ocfs2_reserve_suballoc_bits+0x9f6/0x4eb0 fs/ocfs2/suballoc.c:832
       ocfs2_reserve_new_metadata_blocks+0x41c/0x9c0 fs/ocfs2/suballoc.c:982
       ocfs2_mknod+0x143a/0x2b40 fs/ocfs2/namei.c:345
       ocfs2_create+0x1ab/0x480 fs/ocfs2/namei.c:672
       lookup_open fs/namei.c:3595 [inline]
       open_last_lookups fs/namei.c:3694 [inline]
       path_openat+0x1c03/0x3590 fs/namei.c:3930
       do_filp_open+0x235/0x490 fs/namei.c:3960
       do_sys_openat2+0x13e/0x1d0 fs/open.c:1415
       do_sys_open fs/open.c:1430 [inline]
       __do_sys_creat fs/open.c:1506 [inline]
       __se_sys_creat fs/open.c:1500 [inline]
       __x64_sys_creat+0x123/0x170 fs/open.c:1500
       do_syscall_x64 arch/x86/entry/common.c:52 [inline]
       do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
       entry_SYSCALL_64_after_hwframe+0x77/0x7f

-> #1 (&journal->j_trans_barrier){.+.+}-{3:3}:
       lock_acquire+0x1ed/0x550 kernel/locking/lockdep.c:5825
       down_read+0xb1/0xa40 kernel/locking/rwsem.c:1524
       ocfs2_start_trans+0x3be/0x700 fs/ocfs2/journal.c:350
       ocfs2_block_group_alloc fs/ocfs2/suballoc.c:685 [inline]
       ocfs2_reserve_suballoc_bits+0x9f6/0x4eb0 fs/ocfs2/suballoc.c:832
       ocfs2_reserve_new_metadata_blocks+0x41c/0x9c0 fs/ocfs2/suballoc.c:982
       ocfs2_mknod+0x143a/0x2b40 fs/ocfs2/namei.c:345
       ocfs2_create+0x1ab/0x480 fs/ocfs2/namei.c:672
       lookup_open fs/namei.c:3595 [inline]
       open_last_lookups fs/namei.c:3694 [inline]
       path_openat+0x1c03/0x3590 fs/namei.c:3930
       do_filp_open+0x235/0x490 fs/namei.c:3960
       do_sys_openat2+0x13e/0x1d0 fs/open.c:1415
       do_sys_open fs/open.c:1430 [inline]
       __do_sys_creat fs/open.c:1506 [inline]
       __se_sys_creat fs/open.c:1500 [inline]
       __x64_sys_creat+0x123/0x170 fs/open.c:1500
       do_syscall_x64 arch/x86/entry/common.c:52 [inline]
       do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
       entry_SYSCALL_64_after_hwframe+0x77/0x7f

-> #0 (sb_internal#4){.+.+}-{0:0}:
       check_prev_add kernel/locking/lockdep.c:3161 [inline]
       check_prevs_add kernel/locking/lockdep.c:3280 [inline]
       validate_chain+0x18ef/0x5920 kernel/locking/lockdep.c:3904
       __lock_acquire+0x1384/0x2050 kernel/locking/lockdep.c:5202
       lock_acquire+0x1ed/0x550 kernel/locking/lockdep.c:5825
       percpu_down_read include/linux/percpu-rwsem.h:51 [inline]
       __sb_start_write include/linux/fs.h:1716 [inline]
       sb_start_intwrite include/linux/fs.h:1899 [inline]
       ocfs2_start_trans+0x2b9/0x700 fs/ocfs2/journal.c:348
       ocfs2_acquire_dquot+0x6df/0xb80 fs/ocfs2/quota_global.c:855
       dqget+0x770/0xeb0 fs/quota/dquot.c:976
       __dquot_initialize+0x2e3/0xec0 fs/quota/dquot.c:1504
       ocfs2_get_init_inode+0x158/0x1c0 fs/ocfs2/namei.c:202
       ocfs2_mknod+0xcfa/0x2b40 fs/ocfs2/namei.c:308
       ocfs2_mkdir+0x1ab/0x480 fs/ocfs2/namei.c:655
       vfs_mkdir+0x2f9/0x4f0 fs/namei.c:4257
       do_mkdirat+0x264/0x3a0 fs/namei.c:4280
       __do_sys_mkdir fs/namei.c:4300 [inline]
       __se_sys_mkdir fs/namei.c:4298 [inline]
       __x64_sys_mkdir+0x6c/0x80 fs/namei.c:4298
       do_syscall_x64 arch/x86/entry/common.c:52 [inline]
       do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
       entry_SYSCALL_64_after_hwframe+0x77/0x7f

other info that might help us debug this:

Chain exists of:
  sb_internal#4 --> &ocfs2_sysfile_lock_key[args->fi_sysfile_type]#7 --> &ocfs2_quota_ip_alloc_sem_key

 Possible unsafe locking scenario:

       CPU0                    CPU1
       ----                    ----
  lock(&ocfs2_quota_ip_alloc_sem_key);
                               lock(&ocfs2_sysfile_lock_key[args->fi_sysfile_type]#7);
                               lock(&ocfs2_quota_ip_alloc_sem_key);
  rlock(sb_internal#4);

 *** DEADLOCK ***

6 locks held by syz.0.286/7825:
 #0: ffff88807a27a420 (sb_writers#16){.+.+}-{0:0}, at: mnt_want_write+0x3f/0x90 fs/namespace.c:515
 #1: ffff888059d289c0 (&type->i_mutex_dir_key#10/1){+.+.}-{3:3}, at: inode_lock_nested include/linux/fs.h:850 [inline]
 #1: ffff888059d289c0 (&type->i_mutex_dir_key#10/1){+.+.}-{3:3}, at: filename_create+0x260/0x540 fs/namei.c:4026
 #2: ffff8880574e1800 (&ocfs2_sysfile_lock_key[args->fi_sysfile_type]#3){+.+.}-{3:3}, at: inode_lock include/linux/fs.h:815 [inline]
 #2: ffff8880574e1800 (&ocfs2_sysfile_lock_key[args->fi_sysfile_type]#3){+.+.}-{3:3}, at: ocfs2_reserve_suballoc_bits+0x192/0x4eb0 fs/ocfs2/suballoc.c:786
 #3: ffff88805cbf20a8 (&dquot->dq_lock){+.+.}-{3:3}, at: ocfs2_acquire_dquot+0x2a3/0xb80 fs/ocfs2/quota_global.c:818
 #4: ffff88805ca05100 (&ocfs2_sysfile_lock_key[args->fi_sysfile_type]#7){+.+.}-{3:3}, at: inode_lock include/linux/fs.h:815 [inline]
 #4: ffff88805ca05100 (&ocfs2_sysfile_lock_key[args->fi_sysfile_type]#7){+.+.}-{3:3}, at: ocfs2_lock_global_qf+0x206/0x2b0 fs/ocfs2/quota_global.c:313
 #5: ffff88805ca04da0 (&ocfs2_quota_ip_alloc_sem_key){++++}-{3:3}, at: ocfs2_lock_global_qf+0x225/0x2b0 fs/ocfs2/quota_global.c:314

stack backtrace:
CPU: 0 UID: 0 PID: 7825 Comm: syz.0.286 Not tainted 6.11.0-syzkaller-12113-ge7ed34365879 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 09/13/2024
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:94 [inline]
 dump_stack_lvl+0x241/0x360 lib/dump_stack.c:120
 print_circular_bug+0x13a/0x1b0 kernel/locking/lockdep.c:2074
 check_noncircular+0x36a/0x4a0 kernel/locking/lockdep.c:2206
 check_prev_add kernel/locking/lockdep.c:3161 [inline]
 check_prevs_add kernel/locking/lockdep.c:3280 [inline]
 validate_chain+0x18ef/0x5920 kernel/locking/lockdep.c:3904
 __lock_acquire+0x1384/0x2050 kernel/locking/lockdep.c:5202
 lock_acquire+0x1ed/0x550 kernel/locking/lockdep.c:5825
 percpu_down_read include/linux/percpu-rwsem.h:51 [inline]
 __sb_start_write include/linux/fs.h:1716 [inline]
 sb_start_intwrite include/linux/fs.h:1899 [inline]
 ocfs2_start_trans+0x2b9/0x700 fs/ocfs2/journal.c:348
 ocfs2_acquire_dquot+0x6df/0xb80 fs/ocfs2/quota_global.c:855
 dqget+0x770/0xeb0 fs/quota/dquot.c:976
 __dquot_initialize+0x2e3/0xec0 fs/quota/dquot.c:1504
 ocfs2_get_init_inode+0x158/0x1c0 fs/ocfs2/namei.c:202
 ocfs2_mknod+0xcfa/0x2b40 fs/ocfs2/namei.c:308
 ocfs2_mkdir+0x1ab/0x480 fs/ocfs2/namei.c:655
 vfs_mkdir+0x2f9/0x4f0 fs/namei.c:4257
 do_mkdirat+0x264/0x3a0 fs/namei.c:4280
 __do_sys_mkdir fs/namei.c:4300 [inline]
 __se_sys_mkdir fs/namei.c:4298 [inline]
 __x64_sys_mkdir+0x6c/0x80 fs/namei.c:4298
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f61b017dff9
Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 a8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f61afbff038 EFLAGS: 00000246 ORIG_RAX: 0000000000000053
RAX: ffffffffffffffda RBX: 00007f61b0335f80 RCX: 00007f61b017dff9
RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000020000000
RBP: 00007f61b01f0296 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 0000000000000000 R14: 00007f61b0335f80 R15: 00007ffdf22d8ec8
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
