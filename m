Received: from mail-io1-f69.google.com (mail-io1-f69.google.com [209.85.166.69])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D037A1805A
	for <ocfs2-devel@lists.linux.dev>; Thu,  3 Oct 2024 02:18:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.69
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727921909; cv=none; b=DtvjzUXrbqOmRnHM1cxDcdPWUOSqKeJXU0jXQ5ysRX5hTXXgrPVnXwtmjjfpWOWpyT7PHS1FXnihrTjxmyNfLJZ8hGMYbfvs4w4zziQ9teu5Fg1YjKVmyoayWIHnfNYzNol6DGip3M5mHKynPpjD/4FZwHO8y95m7u+4AbvITqM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727921909; c=relaxed/simple;
	bh=fD8R0cO22GpEt+qvGz/KnRA2eqaODEtiWGR04ZTTH5E=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=q18ZDYwHR8WwaBzqHyl6fUETb2D6DZCGQEhGrk/6Zf96mzo8VaoAMYWsYvBrIkZWl2vNaIejKXY1thAHe+Ij1PcHQXx5txYwHDyXw9mIDmUKM+TlvJArAcebwIJDGv4M5CpeRuFB80x2xIWOicferQSV5rCs9z4J4m6obNq+xq4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.69
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-io1-f69.google.com with SMTP id ca18e2360f4ac-83243a50fc5so50499939f.2
        for <ocfs2-devel@lists.linux.dev>; Wed, 02 Oct 2024 19:18:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727921907; x=1728526707;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=zJkzRnyZZPltMM+i0Vrv+L8NTpX1Z3esRKY7GpXBDC4=;
        b=j2E9h8LcwiEV98ByM1OeVb0xX7DX835QZ7EGD7upZAVEsseL95LNCiL5v6YvnWHPaT
         0N8k8G51FwdTg9yq0dbcndv4ih8Hb0PI0dORg9jucaBzLfTxDTF1qZE/Y907enxYigKF
         ez/6fbEjClnZOo4DQIwwCNVkG6P8uVLXf8ssiDRC46AKP8hULf51Co0Eq38D4oAI9q7H
         Orq9pETSNXIxLpiZ4NXiR+DmWVJxU/VWYE775vHHbXWmZmUGIkR6yckLrsiT/1O9wp6P
         mA1HNv+C/qvTK1YiS81dI8cWWSsZNZiuUv/7mlY41PcxmAN+puSCjAPxAS8Rb9YCvPkK
         HNRw==
X-Forwarded-Encrypted: i=1; AJvYcCWIdyxWlkJ+vVLjM8aIgIi9hzpXygXiItL/VsnfoQvOXwQwcMQ2WIZkqQ/AKlCqy5+BCNPuxQBKTtsd4Q==@lists.linux.dev
X-Gm-Message-State: AOJu0YxR30m+814OaYRyBq3Hjrp9PeZVQK77tTCLuP2pYIa4mm0FOkf5
	enXge+XfpdoNPHggxFAblq31MBMwIIpf/TTH2lBijVBohnC5rFg761Dal2UHdnTpLBgIlozAgkL
	8h3GBTVRWEuWH25WHTaTZbczpH1E2/6nCa0prU0xFGLp0A9zxAlEvdvI=
X-Google-Smtp-Source: AGHT+IFUHpUDwOdUWuHjYfjqJOYUscBqehHOa5hWQfANspu/jFBlJ2vi91gqWNBql3kfmyCA0dQgO+bbNo7d4JxpzApo6/eOnJCA
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1527:b0:3a0:a71b:75e5 with SMTP id
 e9e14a558f8ab-3a36591bcd3mr49435575ab.7.1727921907045; Wed, 02 Oct 2024
 19:18:27 -0700 (PDT)
Date: Wed, 02 Oct 2024 19:18:27 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <66fdfef3.050a0220.9ec68.0031.GAE@google.com>
Subject: [syzbot] [ocfs2?] possible deadlock in ocfs2_del_inode_from_orphan
From: syzbot <syzbot+78359d5fbb04318c35e9@syzkaller.appspotmail.com>
To: jlbec@evilplan.org, joseph.qi@linux.alibaba.com, 
	linux-kernel@vger.kernel.org, mark@fasheh.com, ocfs2-devel@lists.linux.dev, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    f23aa4c0761a Merge tag 'hid-for-linus-2024090201' of git:/..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=1037e580580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=f8af0b3195caed62
dashboard link: https://syzkaller.appspot.com/bug?extid=78359d5fbb04318c35e9
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/98e7ebb9603f/disk-f23aa4c0.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/2b99ed3c1261/vmlinux-f23aa4c0.xz
kernel image: https://storage.googleapis.com/syzbot-assets/9c2b8860052e/bzImage-f23aa4c0.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+78359d5fbb04318c35e9@syzkaller.appspotmail.com

======================================================
WARNING: possible circular locking dependency detected
6.12.0-rc1-syzkaller-00042-gf23aa4c0761a #0 Not tainted
------------------------------------------------------
syz.1.311/8974 is trying to acquire lock:
ffff88805d22c2c0 (&ocfs2_sysfile_lock_key[args->fi_sysfile_type]#2){+.+.}-{3:3}, at: inode_lock include/linux/fs.h:815 [inline]
ffff88805d22c2c0 (&ocfs2_sysfile_lock_key[args->fi_sysfile_type]#2){+.+.}-{3:3}, at: ocfs2_del_inode_from_orphan+0x159/0x800 fs/ocfs2/namei.c:2726

but task is already holding lock:
ffff88805d0dbf60 (&ocfs2_quota_ip_alloc_sem_key){++++}-{3:3}, at: ocfs2_dio_end_io_write fs/ocfs2/aops.c:2321 [inline]
ffff88805d0dbf60 (&ocfs2_quota_ip_alloc_sem_key){++++}-{3:3}, at: ocfs2_dio_end_io+0x44a/0x1250 fs/ocfs2/aops.c:2427

which lock already depends on the new lock.


the existing dependency chain (in reverse order) is:

-> #3 (&ocfs2_quota_ip_alloc_sem_key){++++}-{3:3}:
       lock_acquire+0x1ed/0x550 kernel/locking/lockdep.c:5825
       down_write+0x99/0x220 kernel/locking/rwsem.c:1577
       ocfs2_create_local_dquot+0x1de/0x1d70 fs/ocfs2/quota_local.c:1231
       ocfs2_acquire_dquot+0x833/0xb80 fs/ocfs2/quota_global.c:878
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

-> #2 (&dquot->dq_lock){+.+.}-{3:3}:
       lock_acquire+0x1ed/0x550 kernel/locking/lockdep.c:5825
       __mutex_lock_common kernel/locking/mutex.c:608 [inline]
       __mutex_lock+0x136/0xd70 kernel/locking/mutex.c:752
       wait_on_dquot fs/quota/dquot.c:355 [inline]
       dqget+0x6e6/0xeb0 fs/quota/dquot.c:971
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

-> #1 (&ocfs2_sysfile_lock_key[args->fi_sysfile_type]){+.+.}-{3:3}:
       lock_acquire+0x1ed/0x550 kernel/locking/lockdep.c:5825
       down_write+0x99/0x220 kernel/locking/rwsem.c:1577
       inode_lock include/linux/fs.h:815 [inline]
       ocfs2_remove_inode fs/ocfs2/inode.c:655 [inline]
       ocfs2_wipe_inode fs/ocfs2/inode.c:818 [inline]
       ocfs2_delete_inode fs/ocfs2/inode.c:1079 [inline]
       ocfs2_evict_inode+0x209f/0x4680 fs/ocfs2/inode.c:1216
       evict+0x4e8/0x9b0 fs/inode.c:723
       d_delete_notify include/linux/fsnotify.h:332 [inline]
       vfs_rmdir+0x3d7/0x510 fs/namei.c:4353
       do_rmdir+0x3b5/0x580 fs/namei.c:4399
       __do_sys_unlinkat fs/namei.c:4575 [inline]
       __se_sys_unlinkat fs/namei.c:4569 [inline]
       __x64_sys_unlinkat+0xde/0xf0 fs/namei.c:4569
       do_syscall_x64 arch/x86/entry/common.c:52 [inline]
       do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
       entry_SYSCALL_64_after_hwframe+0x77/0x7f

-> #0 (&ocfs2_sysfile_lock_key[args->fi_sysfile_type]#2){+.+.}-{3:3}:
       check_prev_add kernel/locking/lockdep.c:3161 [inline]
       check_prevs_add kernel/locking/lockdep.c:3280 [inline]
       validate_chain+0x18ef/0x5920 kernel/locking/lockdep.c:3904
       __lock_acquire+0x1384/0x2050 kernel/locking/lockdep.c:5202
       lock_acquire+0x1ed/0x550 kernel/locking/lockdep.c:5825
       down_write+0x99/0x220 kernel/locking/rwsem.c:1577
       inode_lock include/linux/fs.h:815 [inline]
       ocfs2_del_inode_from_orphan+0x159/0x800 fs/ocfs2/namei.c:2726
       ocfs2_dio_end_io_write fs/ocfs2/aops.c:2329 [inline]
       ocfs2_dio_end_io+0x55b/0x1250 fs/ocfs2/aops.c:2427
       dio_complete+0x251/0x6b0 fs/direct-io.c:281
       __blockdev_direct_IO+0x3ebd/0x4890 fs/direct-io.c:1303
       ocfs2_direct_IO+0x255/0x2c0 fs/ocfs2/aops.c:2464
       generic_file_direct_write+0x17a/0x390 mm/filemap.c:3977
       __generic_file_write_iter+0x126/0x230 mm/filemap.c:4141
       ocfs2_file_write_iter+0x17b1/0x1f50 fs/ocfs2/file.c:2456
       do_iter_readv_writev+0x600/0x880
       vfs_writev+0x376/0xba0 fs/read_write.c:1064
       do_pwritev fs/read_write.c:1165 [inline]
       __do_sys_pwritev2 fs/read_write.c:1224 [inline]
       __se_sys_pwritev2+0x1ca/0x2d0 fs/read_write.c:1215
       do_syscall_x64 arch/x86/entry/common.c:52 [inline]
       do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
       entry_SYSCALL_64_after_hwframe+0x77/0x7f

other info that might help us debug this:

Chain exists of:
  &ocfs2_sysfile_lock_key[args->fi_sysfile_type]#2 --> &dquot->dq_lock --> &ocfs2_quota_ip_alloc_sem_key

 Possible unsafe locking scenario:

       CPU0                    CPU1
       ----                    ----
  lock(&ocfs2_quota_ip_alloc_sem_key);
                               lock(&dquot->dq_lock);
                               lock(&ocfs2_quota_ip_alloc_sem_key);
  lock(&ocfs2_sysfile_lock_key[args->fi_sysfile_type]#2);

 *** DEADLOCK ***

3 locks held by syz.1.311/8974:
 #0: ffff888031bd2420 (sb_writers#14){.+.+}-{0:0}, at: file_start_write include/linux/fs.h:2931 [inline]
 #0: ffff888031bd2420 (sb_writers#14){.+.+}-{0:0}, at: vfs_writev+0x2d1/0xba0 fs/read_write.c:1062
 #1: ffff88805d0dc2c0 (&sb->s_type->i_mutex_key#22){+.+.}-{3:3}, at: inode_lock include/linux/fs.h:815 [inline]
 #1: ffff88805d0dc2c0 (&sb->s_type->i_mutex_key#22){+.+.}-{3:3}, at: ocfs2_file_write_iter+0x467/0x1f50 fs/ocfs2/file.c:2388
 #2: ffff88805d0dbf60 (&ocfs2_quota_ip_alloc_sem_key){++++}-{3:3}, at: ocfs2_dio_end_io_write fs/ocfs2/aops.c:2321 [inline]
 #2: ffff88805d0dbf60 (&ocfs2_quota_ip_alloc_sem_key){++++}-{3:3}, at: ocfs2_dio_end_io+0x44a/0x1250 fs/ocfs2/aops.c:2427

stack backtrace:
CPU: 0 UID: 0 PID: 8974 Comm: syz.1.311 Not tainted 6.12.0-rc1-syzkaller-00042-gf23aa4c0761a #0
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
 inode_lock include/linux/fs.h:815 [inline]
 ocfs2_del_inode_from_orphan+0x159/0x800 fs/ocfs2/namei.c:2726
 ocfs2_dio_end_io_write fs/ocfs2/aops.c:2329 [inline]
 ocfs2_dio_end_io+0x55b/0x1250 fs/ocfs2/aops.c:2427
 dio_complete+0x251/0x6b0 fs/direct-io.c:281
 __blockdev_direct_IO+0x3ebd/0x4890 fs/direct-io.c:1303
 ocfs2_direct_IO+0x255/0x2c0 fs/ocfs2/aops.c:2464
 generic_file_direct_write+0x17a/0x390 mm/filemap.c:3977
 __generic_file_write_iter+0x126/0x230 mm/filemap.c:4141
 ocfs2_file_write_iter+0x17b1/0x1f50 fs/ocfs2/file.c:2456
 do_iter_readv_writev+0x600/0x880
 vfs_writev+0x376/0xba0 fs/read_write.c:1064
 do_pwritev fs/read_write.c:1165 [inline]
 __do_sys_pwritev2 fs/read_write.c:1224 [inline]
 __se_sys_pwritev2+0x1ca/0x2d0 fs/read_write.c:1215
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f56b9d7dff9
Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 a8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f56bac44038 EFLAGS: 00000246 ORIG_RAX: 0000000000000148
RAX: ffffffffffffffda RBX: 00007f56b9f35f80 RCX: 00007f56b9d7dff9
RDX: 0000000000000002 RSI: 0000000020000240 RDI: 0000000000000005
RBP: 00007f56b9df0296 R08: 0000000000041001 R09: 0000000000000003
R10: 0000000000001200 R11: 0000000000000246 R12: 0000000000000000
R13: 0000000000000000 R14: 00007f56b9f35f80 R15: 00007fff80cd2c88
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
