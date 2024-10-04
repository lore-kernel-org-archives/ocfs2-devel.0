Received: from mail-io1-f72.google.com (mail-io1-f72.google.com [209.85.166.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3042712C80F
	for <ocfs2-devel@lists.linux.dev>; Fri,  4 Oct 2024 07:06:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728025583; cv=none; b=unwMhC+D0tJNvYaxr4Nk5T5C4bZv7uwEqp3pB2uKwecD+IR0cK2KrvKRYeV1euJoKaKCiJRImzCgioLSUXz4gHXMBe1jbF1VmlwMuLwBQmgXcJKGGVzwKL7NjS/VyWFds62Aeo+z2lEputxIQw8XWTD68mvX/wmeaCD1unofA2Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728025583; c=relaxed/simple;
	bh=zybZiAPIOa76AoBsExSrJnXtPu5kBgBSwIYmbtYExPo=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=gmfda+RVYd6wVDtMe05o69eXRVabY7BW/OvDlO8o3u1+5uvZPgn3KC2gAymnfk+/KRXLkFyYmS8NMWssHOKWbhiv7FfuEick28n+8jMkyi4RQnw0yxTXRIu2+rH/ZhsmQdZhEqTEQadqn+M5kAkCmAzMWe6lXMCdrm6P4GdBZSM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-io1-f72.google.com with SMTP id ca18e2360f4ac-82cdb749559so291328139f.2
        for <ocfs2-devel@lists.linux.dev>; Fri, 04 Oct 2024 00:06:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728025581; x=1728630381;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=H4RgaKRUXG9iuzRH10Vq9HXdkhKb+sa0Ko+zLWfBr4k=;
        b=NQqtbVNGf1PP9DbD1ZFWAzL6QMGJA8wCYVCPrXFPOlvaQASIFdpKI9Oh6Xd9pvj1pl
         qfc6+WOlcLaOgQPWKP7FeXaXmCjAUNGWxaAQvmplnb8zjg6IX0DFnyG/vDLeDtGUErNo
         ntGslrzMSZhj8DH7M0gJ+QaoTsOopPGHih+9+koHlez47cKBdXZazsKO1+NpoQ+q8uRl
         FG16u+xFOuxP/7IYjLQztp6DpDfBto7uwFWlMM1s233QyrFQbZOV3kAvZD9lumvstiqk
         KtiwGVS314elu/zGgC5CGemQM6rufXVfYbBOv5KHZS0huN5xqQR2/U5+O1ToZZ8zjKYQ
         7FnQ==
X-Forwarded-Encrypted: i=1; AJvYcCWEnr2/d6XBN2IStPgqPBdXJSCcNwfKCLzljPNj/DtuAlE3Kml10H1kKjRXHbc5sw1QHJGniZvQC8h9EQ==@lists.linux.dev
X-Gm-Message-State: AOJu0YzOBtu+1IJNcOt2oND4nXaarp6Vkmx8TpG7ja7mwrk1Ji3o324X
	2uV7pvukxK+l3/eboLjSKxjWLxEconZ+Ms4zY3Tfy4lh0kxVQCXWVkUu6RVKTS0+Dc6GmkrX2xy
	0+PYphwJFJ2y82vmKRNZ5a0neY7sVcbYdpLQMkgaAq6/AhdHM/ELeDcM=
X-Google-Smtp-Source: AGHT+IGNIeQTXM9v8wy6wsDb0jiZtpJt4ldUKfqOWX3hPtPHNnpx2pMrgadXFzPZi0tTmrV9dOVB/8TdeLwcdK92BI14ovQP7F/g
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:16c9:b0:3a2:6ce9:19c6 with SMTP id
 e9e14a558f8ab-3a375be2ec4mr14684555ab.25.1728025581293; Fri, 04 Oct 2024
 00:06:21 -0700 (PDT)
Date: Fri, 04 Oct 2024 00:06:21 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <66ff93ed.050a0220.49194.045c.GAE@google.com>
Subject: [syzbot] [ocfs2?] possible deadlock in ocfs2_remove_inode
From: syzbot <syzbot+32016adc6d19e9612861@syzkaller.appspotmail.com>
To: jlbec@evilplan.org, joseph.qi@linux.alibaba.com, 
	linux-kernel@vger.kernel.org, mark@fasheh.com, ocfs2-devel@lists.linux.dev, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    e7ed34365879 Merge tag 'mailbox-v6.12' of git://git.kernel..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=147dfd9f980000
kernel config:  https://syzkaller.appspot.com/x/.config?x=bf263a6a5debbeef
dashboard link: https://syzkaller.appspot.com/bug?extid=32016adc6d19e9612861
compiler:       gcc (Debian 12.2.0-14) 12.2.0, GNU ld (GNU Binutils for Debian) 2.40

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/74f7ccd405cc/disk-e7ed3436.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/ef3b18bc5269/vmlinux-e7ed3436.xz
kernel image: https://storage.googleapis.com/syzbot-assets/54ef06c52fbb/bzImage-e7ed3436.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+32016adc6d19e9612861@syzkaller.appspotmail.com

======================================================
WARNING: possible circular locking dependency detected
6.11.0-syzkaller-12113-ge7ed34365879 #0 Not tainted
------------------------------------------------------
syz-executor/5236 is trying to acquire lock:
ffff88805fba5f40 (&ocfs2_sysfile_lock_key[args->fi_sysfile_type]#2){+.+.}-{3:3}, at: inode_lock include/linux/fs.h:815 [inline]
ffff88805fba5f40 (&ocfs2_sysfile_lock_key[args->fi_sysfile_type]#2){+.+.}-{3:3}, at: ocfs2_remove_inode+0x15c/0x8a0 fs/ocfs2/inode.c:655

but task is already holding lock:
ffff88807afb5f40 (&ocfs2_sysfile_lock_key[args->fi_sysfile_type]){+.+.}-{3:3}, at: inode_lock include/linux/fs.h:815 [inline]
ffff88807afb5f40 (&ocfs2_sysfile_lock_key[args->fi_sysfile_type]){+.+.}-{3:3}, at: ocfs2_wipe_inode+0x2e6/0x1220 fs/ocfs2/inode.c:776

which lock already depends on the new lock.


the existing dependency chain (in reverse order) is:

-> #3 (&ocfs2_sysfile_lock_key[args->fi_sysfile_type]){+.+.}-{3:3}:
       down_write+0x93/0x200 kernel/locking/rwsem.c:1577
       inode_lock include/linux/fs.h:815 [inline]
       ocfs2_del_inode_from_orphan+0x112/0x700 fs/ocfs2/namei.c:2726
       ocfs2_dio_end_io_write+0x2cc/0xf30 fs/ocfs2/aops.c:2329
       ocfs2_dio_end_io+0x139/0x2a0 fs/ocfs2/aops.c:2427
       dio_complete+0x21b/0x8e0 fs/direct-io.c:281
       __blockdev_direct_IO+0x3139/0x3d10 fs/direct-io.c:1303
       ocfs2_direct_IO+0x263/0x360 fs/ocfs2/aops.c:2464
       generic_file_direct_write+0x19a/0x410 mm/filemap.c:3977
       __generic_file_write_iter+0x11b/0x240 mm/filemap.c:4141
       ocfs2_file_write_iter+0xb70/0x20e0 fs/ocfs2/file.c:2456
       do_iter_readv_writev+0x535/0x7f0 fs/read_write.c:834
       vfs_writev+0x363/0xdd0 fs/read_write.c:1064
       do_pwritev+0x1b4/0x270 fs/read_write.c:1165
       __do_sys_pwritev2 fs/read_write.c:1224 [inline]
       __se_sys_pwritev2 fs/read_write.c:1215 [inline]
       __x64_sys_pwritev2+0xef/0x160 fs/read_write.c:1215
       do_syscall_x64 arch/x86/entry/common.c:52 [inline]
       do_syscall_64+0xcd/0x250 arch/x86/entry/common.c:83
       entry_SYSCALL_64_after_hwframe+0x77/0x7f

-> #2 (&ocfs2_quota_ip_alloc_sem_key){++++}-{3:3}:
       down_write+0x93/0x200 kernel/locking/rwsem.c:1577
       ocfs2_create_local_dquot+0x158/0xb40 fs/ocfs2/quota_local.c:1231
       ocfs2_acquire_dquot+0x629/0xaf0 fs/ocfs2/quota_global.c:878
       dqget+0x694/0x1160 fs/quota/dquot.c:976
       ocfs2_setattr+0x1cb0/0x2460 fs/ocfs2/file.c:1230
       notify_change+0x6a9/0x1230 fs/attr.c:503
       chown_common+0x538/0x670 fs/open.c:793
       vfs_fchown fs/open.c:861 [inline]
       vfs_fchown fs/open.c:853 [inline]
       ksys_fchown+0x11a/0x180 fs/open.c:872
       __do_sys_fchown fs/open.c:880 [inline]
       __se_sys_fchown fs/open.c:878 [inline]
       __x64_sys_fchown+0x72/0xb0 fs/open.c:878
       do_syscall_x64 arch/x86/entry/common.c:52 [inline]
       do_syscall_64+0xcd/0x250 arch/x86/entry/common.c:83
       entry_SYSCALL_64_after_hwframe+0x77/0x7f

-> #1 (&dquot->dq_lock){+.+.}-{3:3}:
       __mutex_lock_common kernel/locking/mutex.c:608 [inline]
       __mutex_lock+0x175/0x9c0 kernel/locking/mutex.c:752
       wait_on_dquot fs/quota/dquot.c:355 [inline]
       dqget+0x5f2/0x1160 fs/quota/dquot.c:971
       __dquot_initialize+0x588/0xd50 fs/quota/dquot.c:1504
       ocfs2_get_init_inode+0xe8/0x1a0 fs/ocfs2/namei.c:202
       ocfs2_mknod+0x938/0x2440 fs/ocfs2/namei.c:308
       ocfs2_create+0x185/0x450 fs/ocfs2/namei.c:672
       lookup_open.isra.0+0x1177/0x14c0 fs/namei.c:3595
       open_last_lookups fs/namei.c:3694 [inline]
       path_openat+0x904/0x2d60 fs/namei.c:3930
       do_filp_open+0x1dc/0x430 fs/namei.c:3960
       do_sys_openat2+0x17a/0x1e0 fs/open.c:1415
       do_sys_open fs/open.c:1430 [inline]
       __do_sys_openat fs/open.c:1446 [inline]
       __se_sys_openat fs/open.c:1441 [inline]
       __x64_sys_openat+0x175/0x210 fs/open.c:1441
       do_syscall_x64 arch/x86/entry/common.c:52 [inline]
       do_syscall_64+0xcd/0x250 arch/x86/entry/common.c:83
       entry_SYSCALL_64_after_hwframe+0x77/0x7f

-> #0 (&ocfs2_sysfile_lock_key[args->fi_sysfile_type]#2){+.+.}-{3:3}:
       check_prev_add kernel/locking/lockdep.c:3161 [inline]
       check_prevs_add kernel/locking/lockdep.c:3280 [inline]
       validate_chain kernel/locking/lockdep.c:3904 [inline]
       __lock_acquire+0x250b/0x3ce0 kernel/locking/lockdep.c:5202
       lock_acquire.part.0+0x11b/0x380 kernel/locking/lockdep.c:5825
       down_write+0x93/0x200 kernel/locking/rwsem.c:1577
       inode_lock include/linux/fs.h:815 [inline]
       ocfs2_remove_inode+0x15c/0x8a0 fs/ocfs2/inode.c:655
       ocfs2_wipe_inode+0x455/0x1220 fs/ocfs2/inode.c:818
       ocfs2_delete_inode fs/ocfs2/inode.c:1079 [inline]
       ocfs2_evict_inode+0x6c5/0x15d0 fs/ocfs2/inode.c:1216
       evict+0x40c/0x970 fs/inode.c:723
       iput_final fs/inode.c:1875 [inline]
       iput fs/inode.c:1901 [inline]
       iput+0x530/0x890 fs/inode.c:1887
       d_delete_notify include/linux/fsnotify.h:332 [inline]
       vfs_rmdir fs/namei.c:4353 [inline]
       vfs_rmdir+0x487/0x690 fs/namei.c:4317
       do_rmdir+0x3a2/0x410 fs/namei.c:4399
       __do_sys_unlinkat fs/namei.c:4575 [inline]
       __se_sys_unlinkat fs/namei.c:4569 [inline]
       __x64_sys_unlinkat+0xef/0x130 fs/namei.c:4569
       do_syscall_x64 arch/x86/entry/common.c:52 [inline]
       do_syscall_64+0xcd/0x250 arch/x86/entry/common.c:83
       entry_SYSCALL_64_after_hwframe+0x77/0x7f

other info that might help us debug this:

Chain exists of:
  &ocfs2_sysfile_lock_key[args->fi_sysfile_type]#2 --> &ocfs2_quota_ip_alloc_sem_key --> &ocfs2_sysfile_lock_key[args->fi_sysfile_type]

 Possible unsafe locking scenario:

       CPU0                    CPU1
       ----                    ----
  lock(&ocfs2_sysfile_lock_key[args->fi_sysfile_type]);
                               lock(&ocfs2_quota_ip_alloc_sem_key);
                               lock(&ocfs2_sysfile_lock_key[args->fi_sysfile_type]);
  lock(&ocfs2_sysfile_lock_key[args->fi_sysfile_type]#2);

 *** DEADLOCK ***

4 locks held by syz-executor/5236:
 #0: ffff8880227e2420 (sb_writers#15){.+.+}-{0:0}, at: do_rmdir+0x1e4/0x410 fs/namei.c:4383
 #1: ffff88807afb2640 (&type->i_mutex_dir_key#10/1){+.+.}-{3:3}, at: inode_lock_nested include/linux/fs.h:850 [inline]
 #1: ffff88807afb2640 (&type->i_mutex_dir_key#10/1){+.+.}-{3:3}, at: do_rmdir+0x235/0x410 fs/namei.c:4387
 #2: ffff88804f59cbd0 (&osb->nfs_sync_rwlock){.+.+}-{3:3}, at: ocfs2_nfs_sync_lock+0xe5/0x2e0 fs/ocfs2/dlmglue.c:2876
 #3: ffff88807afb5f40 (&ocfs2_sysfile_lock_key[args->fi_sysfile_type]){+.+.}-{3:3}, at: inode_lock include/linux/fs.h:815 [inline]
 #3: ffff88807afb5f40 (&ocfs2_sysfile_lock_key[args->fi_sysfile_type]){+.+.}-{3:3}, at: ocfs2_wipe_inode+0x2e6/0x1220 fs/ocfs2/inode.c:776

stack backtrace:
CPU: 0 UID: 0 PID: 5236 Comm: syz-executor Not tainted 6.11.0-syzkaller-12113-ge7ed34365879 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 09/13/2024
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:94 [inline]
 dump_stack_lvl+0x116/0x1f0 lib/dump_stack.c:120
 print_circular_bug+0x41c/0x610 kernel/locking/lockdep.c:2074
 check_noncircular+0x31a/0x400 kernel/locking/lockdep.c:2206
 check_prev_add kernel/locking/lockdep.c:3161 [inline]
 check_prevs_add kernel/locking/lockdep.c:3280 [inline]
 validate_chain kernel/locking/lockdep.c:3904 [inline]
 __lock_acquire+0x250b/0x3ce0 kernel/locking/lockdep.c:5202
 lock_acquire.part.0+0x11b/0x380 kernel/locking/lockdep.c:5825
 down_write+0x93/0x200 kernel/locking/rwsem.c:1577
 inode_lock include/linux/fs.h:815 [inline]
 ocfs2_remove_inode+0x15c/0x8a0 fs/ocfs2/inode.c:655
 ocfs2_wipe_inode+0x455/0x1220 fs/ocfs2/inode.c:818
 ocfs2_delete_inode fs/ocfs2/inode.c:1079 [inline]
 ocfs2_evict_inode+0x6c5/0x15d0 fs/ocfs2/inode.c:1216
 evict+0x40c/0x970 fs/inode.c:723
 iput_final fs/inode.c:1875 [inline]
 iput fs/inode.c:1901 [inline]
 iput+0x530/0x890 fs/inode.c:1887
 d_delete_notify include/linux/fsnotify.h:332 [inline]
 vfs_rmdir fs/namei.c:4353 [inline]
 vfs_rmdir+0x487/0x690 fs/namei.c:4317
 do_rmdir+0x3a2/0x410 fs/namei.c:4399
 __do_sys_unlinkat fs/namei.c:4575 [inline]
 __se_sys_unlinkat fs/namei.c:4569 [inline]
 __x64_sys_unlinkat+0xef/0x130 fs/namei.c:4569
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0xcd/0x250 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7fcf15b7d5d7
Code: 73 01 c3 48 c7 c1 a8 ff ff ff f7 d8 64 89 01 48 83 c8 ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 b8 07 01 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 a8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007ffff1fa0fd8 EFLAGS: 00000207 ORIG_RAX: 0000000000000107
RAX: ffffffffffffffda RBX: 0000000000000065 RCX: 00007fcf15b7d5d7
RDX: 0000000000000200 RSI: 00007ffff1fa2180 RDI: 00000000ffffff9c
RBP: 00007fcf15bf0134 R08: 0000555573d0e66b R09: 0000000000000000
R10: 0000000000001000 R11: 0000000000000207 R12: 00007ffff1fa2180
R13: 00007fcf15bf0134 R14: 0000000000042eb7 R15: 00007ffff1fa4330
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
