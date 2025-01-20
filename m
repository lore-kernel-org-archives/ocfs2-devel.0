Received: from mail-il1-f208.google.com (mail-il1-f208.google.com [209.85.166.208])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C7051494CC
	for <ocfs2-devel@lists.linux.dev>; Mon, 20 Jan 2025 17:05:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.208
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737392729; cv=none; b=s1qMAFO4b4KPTS8CPvdICSgrRxECR5jb8NLbtVeE+PT5dJdGa85SpyzO3acK1MSzc2tymFNneb7vMrBe7PSKZ+o7gpezcboUU9W+U7sR/Rgm7eQIc5KfIOpWTIh425p+42jNORo1dHdAGu2YqA/Xp4CbUhGnU63hzSqKA68mgvA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737392729; c=relaxed/simple;
	bh=0fghYnTscaiafxQ5tITebCzfUWtmgj9llamysNJx1s4=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=Um7bffekgBCVbPoUSmWnU6YnDeZTQAhfN8rOpy7KKK3jGJKUFhaLWALUoUgPKiGEUq6XmU3qO/lAFqAyAz9lcgUzi8PEXeJ9VjbM4LU8/vgMdnUYmconKmv6krKSa8M3EL5ErBDkyi5xsstIrLuqGCSNR7+a+vxS1sJkrdsdy1U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.208
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f208.google.com with SMTP id e9e14a558f8ab-3a7e4bfae54so36217385ab.0
        for <ocfs2-devel@lists.linux.dev>; Mon, 20 Jan 2025 09:05:27 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737392726; x=1737997526;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=b4n1awa7GIrAQql6WgsmmOyaIB8WzNikjc6vy7jSryA=;
        b=oVY8cuhxmQzhz/XWP/iYWbpmsnatmvyQxudHqfeBrfeKZpkzEgvPj6b6BhvRH1Fb2t
         wyRyO2ICp4o9EsqnEYKnNyBMXz+a+Au5rMc17+cTH3w2covbYAuoss4P4hoLp3OtSRX8
         45hOwQ0oqjj/VJbIS415anhNKA/atqn9YrIr51zftSV6bTNFFd+vL1g4f4EonkbJ8aCg
         mgnvKF2C0BcOkeSBH2QgyNV4IQJU2/QQfcQN8tvbHji6GZGTB1dZoDC4x0d+ENGFDq0W
         xiCCMtpRydjfN/h2gbw0zkuMhTmGCq2yXe8tkhn9aDxpGeJbAJ3JY9EloWJAb5EeG1zg
         T2bw==
X-Forwarded-Encrypted: i=1; AJvYcCUmbxP1qvC08yKuy160D/qEGVc+whzV1PT2F23caghhhc7RVziE/9f12IEef05xXJcB9X1YBMpteklnDg==@lists.linux.dev
X-Gm-Message-State: AOJu0YyG90X0dJ9gCnbgf2DLVEBNAyd6MgtG2LlPxAKLkszwrcdowW8M
	js601P5HSAm+RVNk1SWTXchIOOfxqGbS/lFXuioWMmYUpLj3erAmmoUm8Pn7RrsYKJKl3/tuZuD
	qF17+XSMiU7W5S1cECXAlX9edZAbDKYNVVFgtts1PP/3iLrGPRY90YZw=
X-Google-Smtp-Source: AGHT+IGjWg4JThARQOZouQWBfT0EEpuADynPy+Hffa9Cn1nUW2jZO4yvUZofFRDkhBmFn2Kp/+dhrH5CqFLP7pvtXuIm3fd+4Z4k
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1c07:b0:3a7:8208:b847 with SMTP id
 e9e14a558f8ab-3cf74491fadmr109817505ab.22.1737392726477; Mon, 20 Jan 2025
 09:05:26 -0800 (PST)
Date: Mon, 20 Jan 2025 09:05:26 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <678e8256.050a0220.303755.0081.GAE@google.com>
Subject: [syzbot] [ocfs2?] possible deadlock in ocfs2_remove_inode (2)
From: syzbot <syzbot+ddde294b94666bb51266@syzkaller.appspotmail.com>
To: jlbec@evilplan.org, joseph.qi@linux.alibaba.com, 
	linux-kernel@vger.kernel.org, mark@fasheh.com, ocfs2-devel@lists.linux.dev, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    619f0b6fad52 Merge tag 'seccomp-v6.13-rc8' of git://git.ke..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=10a027c4580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=ca46bfa06efdf147
dashboard link: https://syzkaller.appspot.com/bug?extid=ddde294b94666bb51266
compiler:       gcc (Debian 12.2.0-14) 12.2.0, GNU ld (GNU Binutils for Debian) 2.40

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/82cabf193b6a/disk-619f0b6f.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/848d3b4e7a8f/vmlinux-619f0b6f.xz
kernel image: https://storage.googleapis.com/syzbot-assets/4c8f2fdc1676/bzImage-619f0b6f.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+ddde294b94666bb51266@syzkaller.appspotmail.com

======================================================
WARNING: possible circular locking dependency detected
6.13.0-rc7-syzkaller-00043-g619f0b6fad52 #0 Not tainted
------------------------------------------------------
syz.3.1383/16527 is trying to acquire lock:
ffff8880840ec2c0 (&ocfs2_sysfile_lock_key[args->fi_sysfile_type]#4){+.+.}-{4:4}, at: inode_lock include/linux/fs.h:818 [inline]
ffff8880840ec2c0 (&ocfs2_sysfile_lock_key[args->fi_sysfile_type]#4){+.+.}-{4:4}, at: ocfs2_remove_inode+0x15c/0x8a0 fs/ocfs2/inode.c:655

but task is already holding lock:
ffff8880840ea640 (&ocfs2_sysfile_lock_key[args->fi_sysfile_type]){+.+.}-{4:4}, at: inode_lock include/linux/fs.h:818 [inline]
ffff8880840ea640 (&ocfs2_sysfile_lock_key[args->fi_sysfile_type]){+.+.}-{4:4}, at: ocfs2_wipe_inode+0x2e6/0x1220 fs/ocfs2/inode.c:776

which lock already depends on the new lock.


the existing dependency chain (in reverse order) is:

-> #3 (&ocfs2_sysfile_lock_key[args->fi_sysfile_type]){+.+.}-{4:4}:
       down_write+0x93/0x200 kernel/locking/rwsem.c:1577
       inode_lock include/linux/fs.h:818 [inline]
       ocfs2_del_inode_from_orphan+0x112/0x700 fs/ocfs2/namei.c:2728
       ocfs2_dio_end_io_write+0x2cc/0xf30 fs/ocfs2/aops.c:2329
       ocfs2_dio_end_io+0x139/0x2a0 fs/ocfs2/aops.c:2427
       dio_complete+0x21b/0x8e0 fs/direct-io.c:281
       __blockdev_direct_IO+0x3412/0x40b0 fs/direct-io.c:1303
       ocfs2_direct_IO+0x263/0x360 fs/ocfs2/aops.c:2464
       generic_file_direct_write+0x19a/0x410 mm/filemap.c:3969
       __generic_file_write_iter+0x11b/0x240 mm/filemap.c:4133
       ocfs2_file_write_iter+0xbd0/0x21d0 fs/ocfs2/file.c:2469
       do_iter_readv_writev+0x535/0x7f0 fs/read_write.c:820
       vfs_writev+0x363/0xdd0 fs/read_write.c:1050
       do_pwritev+0x1b1/0x270 fs/read_write.c:1146
       __do_sys_pwritev2 fs/read_write.c:1204 [inline]
       __se_sys_pwritev2 fs/read_write.c:1195 [inline]
       __x64_sys_pwritev2+0xef/0x160 fs/read_write.c:1195
       do_syscall_x64 arch/x86/entry/common.c:52 [inline]
       do_syscall_64+0xcd/0x250 arch/x86/entry/common.c:83
       entry_SYSCALL_64_after_hwframe+0x77/0x7f

-> #2 (&ocfs2_quota_ip_alloc_sem_key){++++}-{4:4}:
       down_write+0x93/0x200 kernel/locking/rwsem.c:1577
       ocfs2_create_local_dquot+0x158/0xb40 fs/ocfs2/quota_local.c:1232
       ocfs2_acquire_dquot+0x628/0xaf0 fs/ocfs2/quota_global.c:878
       dqget+0x694/0x1160 fs/quota/dquot.c:977
       dquot_set_dqblk+0x2b/0x1230 fs/quota/dquot.c:2820
       quota_setquota+0x4c8/0x5f0 fs/quota/quota.c:310
       do_quotactl+0xb00/0x13d0 fs/quota/quota.c:802
       __do_sys_quotactl fs/quota/quota.c:961 [inline]
       __se_sys_quotactl fs/quota/quota.c:917 [inline]
       __x64_sys_quotactl+0x1b4/0x440 fs/quota/quota.c:917
       do_syscall_x64 arch/x86/entry/common.c:52 [inline]
       do_syscall_64+0xcd/0x250 arch/x86/entry/common.c:83
       entry_SYSCALL_64_after_hwframe+0x77/0x7f

-> #1 (&dquot->dq_lock){+.+.}-{4:4}:
       __mutex_lock_common kernel/locking/mutex.c:585 [inline]
       __mutex_lock+0x19b/0xa60 kernel/locking/mutex.c:735
       wait_on_dquot fs/quota/dquot.c:354 [inline]
       dqget+0x5f2/0x1160 fs/quota/dquot.c:972
       __dquot_initialize+0x588/0xd50 fs/quota/dquot.c:1505
       ocfs2_get_init_inode+0xe8/0x1b0 fs/ocfs2/namei.c:202
       ocfs2_mknod+0x93f/0x2440 fs/ocfs2/namei.c:310
       ocfs2_mkdir+0x185/0x450 fs/ocfs2/namei.c:657
       vfs_mkdir+0x580/0x860 fs/namei.c:4311
       do_mkdirat+0x301/0x3a0 fs/namei.c:4334
       __do_sys_mkdirat fs/namei.c:4349 [inline]
       __se_sys_mkdirat fs/namei.c:4347 [inline]
       __x64_sys_mkdirat+0x83/0xb0 fs/namei.c:4347
       do_syscall_x64 arch/x86/entry/common.c:52 [inline]
       do_syscall_64+0xcd/0x250 arch/x86/entry/common.c:83
       entry_SYSCALL_64_after_hwframe+0x77/0x7f

-> #0 (&ocfs2_sysfile_lock_key[args->fi_sysfile_type]#4){+.+.}-{4:4}:
       check_prev_add kernel/locking/lockdep.c:3161 [inline]
       check_prevs_add kernel/locking/lockdep.c:3280 [inline]
       validate_chain kernel/locking/lockdep.c:3904 [inline]
       __lock_acquire+0x249e/0x3c40 kernel/locking/lockdep.c:5226
       lock_acquire.part.0+0x11b/0x380 kernel/locking/lockdep.c:5849
       down_write+0x93/0x200 kernel/locking/rwsem.c:1577
       inode_lock include/linux/fs.h:818 [inline]
       ocfs2_remove_inode+0x15c/0x8a0 fs/ocfs2/inode.c:655
       ocfs2_wipe_inode+0x455/0x1220 fs/ocfs2/inode.c:818
       ocfs2_delete_inode fs/ocfs2/inode.c:1079 [inline]
       ocfs2_evict_inode+0x6da/0x1610 fs/ocfs2/inode.c:1216
       evict+0x40c/0x960 fs/inode.c:796
       iput_final fs/inode.c:1946 [inline]
       iput fs/inode.c:1972 [inline]
       iput+0x52a/0x890 fs/inode.c:1958
       ocfs2_dentry_iput+0x13a/0x340 fs/ocfs2/dcache.c:411
       dentry_unlink_inode+0x282/0x480 fs/dcache.c:420
       __dentry_kill+0x1d0/0x600 fs/dcache.c:625
       dput.part.0+0x4b1/0x9b0 fs/dcache.c:867
       dput+0x1f/0x30 fs/dcache.c:857
       __fput+0x515/0xb60 fs/file_table.c:458
       task_work_run+0x151/0x250 kernel/task_work.c:239
       resume_user_mode_work include/linux/resume_user_mode.h:50 [inline]
       exit_to_user_mode_loop kernel/entry/common.c:114 [inline]
       exit_to_user_mode_prepare include/linux/entry-common.h:329 [inline]
       __syscall_exit_to_user_mode_work kernel/entry/common.c:207 [inline]
       syscall_exit_to_user_mode+0x27b/0x2a0 kernel/entry/common.c:218
       do_syscall_64+0xda/0x250 arch/x86/entry/common.c:89
       entry_SYSCALL_64_after_hwframe+0x77/0x7f

other info that might help us debug this:

Chain exists of:
  &ocfs2_sysfile_lock_key[args->fi_sysfile_type]#4 --> &ocfs2_quota_ip_alloc_sem_key --> &ocfs2_sysfile_lock_key[args->fi_sysfile_type]

 Possible unsafe locking scenario:

       CPU0                    CPU1
       ----                    ----
  lock(&ocfs2_sysfile_lock_key[args->fi_sysfile_type]);
                               lock(&ocfs2_quota_ip_alloc_sem_key);
                               lock(&ocfs2_sysfile_lock_key[args->fi_sysfile_type]);
  lock(&ocfs2_sysfile_lock_key[args->fi_sysfile_type]#4);

 *** DEADLOCK ***

2 locks held by syz.3.1383/16527:
 #0: ffff88806127cbd0 (&osb->nfs_sync_rwlock){.+.+}-{4:4}, at: ocfs2_nfs_sync_lock+0xe5/0x2e0 fs/ocfs2/dlmglue.c:2876
 #1: ffff8880840ea640 (&ocfs2_sysfile_lock_key[args->fi_sysfile_type]){+.+.}-{4:4}, at: inode_lock include/linux/fs.h:818 [inline]
 #1: ffff8880840ea640 (&ocfs2_sysfile_lock_key[args->fi_sysfile_type]){+.+.}-{4:4}, at: ocfs2_wipe_inode+0x2e6/0x1220 fs/ocfs2/inode.c:776

stack backtrace:
CPU: 1 UID: 0 PID: 16527 Comm: syz.3.1383 Not tainted 6.13.0-rc7-syzkaller-00043-g619f0b6fad52 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 12/27/2024
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:94 [inline]
 dump_stack_lvl+0x116/0x1f0 lib/dump_stack.c:120
 print_circular_bug+0x419/0x5d0 kernel/locking/lockdep.c:2074
 check_noncircular+0x31a/0x400 kernel/locking/lockdep.c:2206
 check_prev_add kernel/locking/lockdep.c:3161 [inline]
 check_prevs_add kernel/locking/lockdep.c:3280 [inline]
 validate_chain kernel/locking/lockdep.c:3904 [inline]
 __lock_acquire+0x249e/0x3c40 kernel/locking/lockdep.c:5226
 lock_acquire.part.0+0x11b/0x380 kernel/locking/lockdep.c:5849
 down_write+0x93/0x200 kernel/locking/rwsem.c:1577
 inode_lock include/linux/fs.h:818 [inline]
 ocfs2_remove_inode+0x15c/0x8a0 fs/ocfs2/inode.c:655
 ocfs2_wipe_inode+0x455/0x1220 fs/ocfs2/inode.c:818
 ocfs2_delete_inode fs/ocfs2/inode.c:1079 [inline]
 ocfs2_evict_inode+0x6da/0x1610 fs/ocfs2/inode.c:1216
 evict+0x40c/0x960 fs/inode.c:796
 iput_final fs/inode.c:1946 [inline]
 iput fs/inode.c:1972 [inline]
 iput+0x52a/0x890 fs/inode.c:1958
 ocfs2_dentry_iput+0x13a/0x340 fs/ocfs2/dcache.c:411
 dentry_unlink_inode+0x282/0x480 fs/dcache.c:420
 __dentry_kill+0x1d0/0x600 fs/dcache.c:625
 dput.part.0+0x4b1/0x9b0 fs/dcache.c:867
 dput+0x1f/0x30 fs/dcache.c:857
 __fput+0x515/0xb60 fs/file_table.c:458
 task_work_run+0x151/0x250 kernel/task_work.c:239
 resume_user_mode_work include/linux/resume_user_mode.h:50 [inline]
 exit_to_user_mode_loop kernel/entry/common.c:114 [inline]
 exit_to_user_mode_prepare include/linux/entry-common.h:329 [inline]
 __syscall_exit_to_user_mode_work kernel/entry/common.c:207 [inline]
 syscall_exit_to_user_mode+0x27b/0x2a0 kernel/entry/common.c:218
 do_syscall_64+0xda/0x250 arch/x86/entry/common.c:89
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7fc4a9785d29
Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 a8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007fff1350af08 EFLAGS: 00000246 ORIG_RAX: 00000000000001b4
RAX: 0000000000000000 RBX: 000000000009e9e5 RCX: 00007fc4a9785d29
RDX: 0000000000000000 RSI: 000000000000001e RDI: 0000000000000003
RBP: 00007fc4a9977ba0 R08: 0000000000000001 R09: 00007fff1350b1ff
R10: 00007fc4a9600000 R11: 0000000000000246 R12: 000000000009f0ae
R13: 00007fc4a9975fa0 R14: 0000000000000032 R15: ffffffffffffffff
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
