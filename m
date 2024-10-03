Received: from mail-il1-f200.google.com (mail-il1-f200.google.com [209.85.166.200])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 617551A2569
	for <ocfs2-devel@lists.linux.dev>; Thu,  3 Oct 2024 18:26:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.200
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727979990; cv=none; b=jaf69MCqeJ5VEEQkz7ivoBtblHMGf27MOCur5QVUigadDcJ0HdbI+iN0QjqtkEYN+LUXf3nydrQYIuoUGNhvMlWFWFUNjY5hZTLNvdH9p/KLAhhK62D6bq8zuqdzLRD9Bg0Ou9oRZmFcO3tptXFFnJQA0XSRXbn2NjfCjI7gHKY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727979990; c=relaxed/simple;
	bh=PL33RIuntYEAQ3w2ft39mr9XAI1mgPAIj8C3+/t2R5I=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=ixFcOgp08YD3F6wkqJtaNkGUxJLkYyA17olCpY9uMTUJd8T3Mi/3kFB3njuP+5HO/CWJc7oKw4KWEV4NVEWwUw2d2XbGYGVnFfM30ptGgpvhVjASfmGRhgrG4suCx4oy0t2YfwIBkFHtEHNzPDJuBxLLgWLC3+N/uW9upGhoj4s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.200
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f200.google.com with SMTP id e9e14a558f8ab-3a344da7987so15794425ab.1
        for <ocfs2-devel@lists.linux.dev>; Thu, 03 Oct 2024 11:26:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727979987; x=1728584787;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=YDrEhbe3bonrat4K3U/wb45u8FC29nRCwGYUttup/7M=;
        b=rBgKC3pW1MwPHavyTxw6oGh1diC+Nf2AQcslTOXeAIM3KNT5WUsKnjtgK1cXKwP2SP
         ax+bJvEhGClWxSEuKnuzhb+MeyOsuOawb1HUlC5ImshhvVsPglz2tthkoFYCj/nGSb9Q
         9bG1Y7DqJxbj9BxJfhpHsYtBV1XVnNzS8D3Kkz1DYNKif1hhLk+W0yWA5KeYYjFhqJeF
         MfRI8mYGW2VEcfx2TOS2iOsmkpWSiy2p10KSE8SUY781joqWOkWZyujgaOhyBAclE+g5
         upXWY2muChl0wtDkvCkykLnq4LQ6h4TvX0IAJQv4HqDXXgi+qio54AVEg4mug/bVoiJt
         Ljig==
X-Forwarded-Encrypted: i=1; AJvYcCUnRkRI5ETZ3dK/eTv/QGJU7IAb6X6ZAJ+1n0M/ZxIzcIx+gS740Semyij8S26tNtWlVUhmfXQwczouyw==@lists.linux.dev
X-Gm-Message-State: AOJu0YzmZd9GrIRH9MDTvDvgB9jbhkyW+NOYojmZOIimiQtrHiaLvjf2
	OvFtq3msi4zWVLdx2MfBNPRttotZqcz+L/kUMVmPBYTD6YFtatY0E3m70yJBcfqarpeWUUXoZlg
	Ao8nwwZ5LGc9R3mjjKN+p/j78TqlBt404Hw928F96MwUJiXLsKDNv/m8=
X-Google-Smtp-Source: AGHT+IE+pXO3AyRnRIlT4jclXvLDSLGqy0qRhg5SPqJDCnw/NZiJzRN5Iteg+RJSlNiK6hwTgkV6OFGq6iiWGfpgJHcNvHANOKq/
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1fe4:b0:3a0:933d:d306 with SMTP id
 e9e14a558f8ab-3a37599d80emr1515405ab.9.1727979987526; Thu, 03 Oct 2024
 11:26:27 -0700 (PDT)
Date: Thu, 03 Oct 2024 11:26:27 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <66fee1d3.050a0220.9ec68.0055.GAE@google.com>
Subject: [syzbot] [ocfs2?] possible deadlock in ocfs2_lock_global_qf
From: syzbot <syzbot+b53d753ae8fb473e2397@syzkaller.appspotmail.com>
To: jlbec@evilplan.org, joseph.qi@linux.alibaba.com, 
	linux-kernel@vger.kernel.org, mark@fasheh.com, ocfs2-devel@lists.linux.dev, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    7ec462100ef9 Merge tag 'pull-work.unaligned' of git://git...
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=121a6307980000
kernel config:  https://syzkaller.appspot.com/x/.config?x=f8af0b3195caed62
dashboard link: https://syzkaller.appspot.com/bug?extid=b53d753ae8fb473e2397
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/a86fac80eb1e/disk-7ec46210.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/0166dc055df6/vmlinux-7ec46210.xz
kernel image: https://storage.googleapis.com/syzbot-assets/8601fab0f89e/bzImage-7ec46210.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+b53d753ae8fb473e2397@syzkaller.appspotmail.com

ocfs2: Mounting device (7,1) on (node local, slot 0) with ordered data mode.
======================================================
WARNING: possible circular locking dependency detected
6.12.0-rc1-syzkaller-00046-g7ec462100ef9 #0 Not tainted
------------------------------------------------------
syz.1.818/13312 is trying to acquire lock:
ffff88807f914da0 (&ocfs2_quota_ip_alloc_sem_key){++++}-{3:3}, at: ocfs2_lock_global_qf+0x225/0x2b0 fs/ocfs2/quota_global.c:314

but task is already holding lock:
ffff88807f915100 (&ocfs2_sysfile_lock_key[args->fi_sysfile_type]#7){+.+.}-{3:3}, at: inode_lock include/linux/fs.h:815 [inline]
ffff88807f915100 (&ocfs2_sysfile_lock_key[args->fi_sysfile_type]#7){+.+.}-{3:3}, at: ocfs2_lock_global_qf+0x206/0x2b0 fs/ocfs2/quota_global.c:313

which lock already depends on the new lock.


the existing dependency chain (in reverse order) is:

-> #5 (&ocfs2_sysfile_lock_key[args->fi_sysfile_type]#7){+.+.}-{3:3}:
       lock_acquire+0x1ed/0x550 kernel/locking/lockdep.c:5825
       down_write+0x99/0x220 kernel/locking/rwsem.c:1577
       inode_lock include/linux/fs.h:815 [inline]
       ocfs2_lock_global_qf+0x206/0x2b0 fs/ocfs2/quota_global.c:313
       ocfs2_acquire_dquot+0x2b0/0xb80 fs/ocfs2/quota_global.c:823
       dqget+0x770/0xeb0 fs/quota/dquot.c:976
       dquot_set_dqblk+0x2b/0xf30 fs/quota/dquot.c:2819
       quota_setquota+0x6dc/0x850 fs/quota/quota.c:310
       __do_sys_quotactl fs/quota/quota.c:961 [inline]
       __se_sys_quotactl+0x2c4/0xa30 fs/quota/quota.c:917
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
       __do_sys_chown fs/open.c:844 [inline]
       __se_sys_chown fs/open.c:842 [inline]
       __x64_sys_chown+0x82/0x90 fs/open.c:842
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
       jbd2_journal_lock_updates+0xaa/0x380 fs/jbd2/transaction.c:865
       __ocfs2_flush_truncate_log+0x2ea/0x1250 fs/ocfs2/alloc.c:6029
       ocfs2_flush_truncate_log+0x4f/0x70 fs/ocfs2/alloc.c:6076
       ocfs2_sync_fs+0x125/0x390 fs/ocfs2/super.c:402
       sync_filesystem+0x1c8/0x230 fs/sync.c:66
       generic_shutdown_super+0x72/0x2d0 fs/super.c:621
       kill_block_super+0x44/0x90 fs/super.c:1696
       deactivate_locked_super+0xc4/0x130 fs/super.c:473
       cleanup_mnt+0x41f/0x4b0 fs/namespace.c:1373
       task_work_run+0x24f/0x310 kernel/task_work.c:228
       resume_user_mode_work include/linux/resume_user_mode.h:50 [inline]
       exit_to_user_mode_loop kernel/entry/common.c:114 [inline]
       exit_to_user_mode_prepare include/linux/entry-common.h:328 [inline]
       __syscall_exit_to_user_mode_work kernel/entry/common.c:207 [inline]
       syscall_exit_to_user_mode+0x168/0x370 kernel/entry/common.c:218
       do_syscall_64+0x100/0x230 arch/x86/entry/common.c:89
       entry_SYSCALL_64_after_hwframe+0x77/0x7f

-> #1 (&ocfs2_sysfile_lock_key[args->fi_sysfile_type]#6){+.+.}-{3:3}:
       lock_acquire+0x1ed/0x550 kernel/locking/lockdep.c:5825
       down_write+0x99/0x220 kernel/locking/rwsem.c:1577
       inode_lock include/linux/fs.h:815 [inline]
       ocfs2_remove_btree_range+0x737/0x1860 fs/ocfs2/alloc.c:5742
       ocfs2_remove_inode_range+0x166d/0x2690 fs/ocfs2/file.c:1896
       __ocfs2_change_file_space+0x8e4/0xfd0 fs/ocfs2/file.c:2017
       ocfs2_fallocate+0x2e4/0x350 fs/ocfs2/file.c:2127
       vfs_fallocate+0x569/0x6e0 fs/open.c:333
       ksys_fallocate fs/open.c:356 [inline]
       __do_sys_fallocate fs/open.c:364 [inline]
       __se_sys_fallocate fs/open.c:362 [inline]
       __x64_sys_fallocate+0xbd/0x110 fs/open.c:362
       do_syscall_x64 arch/x86/entry/common.c:52 [inline]
       do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
       entry_SYSCALL_64_after_hwframe+0x77/0x7f

-> #0 (&ocfs2_quota_ip_alloc_sem_key){++++}-{3:3}:
       check_prev_add kernel/locking/lockdep.c:3161 [inline]
       check_prevs_add kernel/locking/lockdep.c:3280 [inline]
       validate_chain+0x18ef/0x5920 kernel/locking/lockdep.c:3904
       __lock_acquire+0x1384/0x2050 kernel/locking/lockdep.c:5202
       lock_acquire+0x1ed/0x550 kernel/locking/lockdep.c:5825
       down_write+0x99/0x220 kernel/locking/rwsem.c:1577
       ocfs2_lock_global_qf+0x225/0x2b0 fs/ocfs2/quota_global.c:314
       ocfs2_acquire_dquot+0x2b0/0xb80 fs/ocfs2/quota_global.c:823
       dqget+0x770/0xeb0 fs/quota/dquot.c:976
       dquot_set_dqblk+0x2b/0xf30 fs/quota/dquot.c:2819
       quota_setquota+0x6dc/0x850 fs/quota/quota.c:310
       __do_sys_quotactl fs/quota/quota.c:961 [inline]
       __se_sys_quotactl+0x2c4/0xa30 fs/quota/quota.c:917
       do_syscall_x64 arch/x86/entry/common.c:52 [inline]
       do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
       entry_SYSCALL_64_after_hwframe+0x77/0x7f

other info that might help us debug this:

Chain exists of:
  &ocfs2_quota_ip_alloc_sem_key --> &dquot->dq_lock --> &ocfs2_sysfile_lock_key[args->fi_sysfile_type]#7

 Possible unsafe locking scenario:

       CPU0                    CPU1
       ----                    ----
  lock(&ocfs2_sysfile_lock_key[args->fi_sysfile_type]#7);
                               lock(&dquot->dq_lock);
                               lock(&ocfs2_sysfile_lock_key[args->fi_sysfile_type]#7);
  lock(&ocfs2_quota_ip_alloc_sem_key);

 *** DEADLOCK ***

3 locks held by syz.1.818/13312:
 #0: ffff888052da60e0 (&type->s_umount_key#56){++++}-{3:3}, at: __super_lock fs/super.c:58 [inline]
 #0: ffff888052da60e0 (&type->s_umount_key#56){++++}-{3:3}, at: super_lock+0x27c/0x400 fs/super.c:120
 #1: ffff888079a3a0a8 (&dquot->dq_lock){+.+.}-{3:3}
, at: ocfs2_acquire_dquot+0x2a3/0xb80 fs/ocfs2/quota_global.c:818
 #2: ffff88807f915100 (&ocfs2_sysfile_lock_key[args->fi_sysfile_type]#7){+.+.}-{3:3}
, at: inode_lock include/linux/fs.h:815 [inline]
, at: ocfs2_lock_global_qf+0x206/0x2b0 fs/ocfs2/quota_global.c:313

stack backtrace:
CPU: 1 UID: 0 PID: 13312 Comm: syz.1.818 Not tainted 6.12.0-rc1-syzkaller-00046-g7ec462100ef9 #0
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
 down_write+0x99/0x220 kernel/locking/rwsem.c:1577
 ocfs2_lock_global_qf+0x225/0x2b0 fs/ocfs2/quota_global.c:314
 ocfs2_acquire_dquot+0x2b0/0xb80 fs/ocfs2/quota_global.c:823
 dqget+0x770/0xeb0 fs/quota/dquot.c:976
 dquot_set_dqblk+0x2b/0xf30 fs/quota/dquot.c:2819
 quota_setquota+0x6dc/0x850 fs/quota/quota.c:310
 __do_sys_quotactl fs/quota/quota.c:961 [inline]
 __se_sys_quotactl+0x2c4/0xa30 fs/quota/quota.c:917
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f2c12f7dff9
Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 a8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f2c13e59038 EFLAGS: 00000246 ORIG_RAX: 00000000000000b3
RAX: ffffffffffffffda RBX: 00007f2c13135f80 RCX: 00007f2c12f7dff9
RDX: 0000000000000000 RSI: 0000000020000080 RDI: ffffffff80000800
RBP: 00007f2c12ff0296 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000020000240 R11: 0000000000000246 R12: 0000000000000000
R13: 0000000000000000 R14: 00007f2c13135f80 R15: 00007ffeac575038
 </TASK>
ocfs2: Unmounting device (7,1) on (node local)


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
