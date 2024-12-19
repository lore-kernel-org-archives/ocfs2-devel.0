Received: from mail-il1-f207.google.com (mail-il1-f207.google.com [209.85.166.207])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 478861A2396
	for <ocfs2-devel@lists.linux.dev>; Thu, 19 Dec 2024 08:16:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734596190; cv=none; b=PC5qrg0k9mbkG3jRX5Uovpkl8uWQ3i7yEb85P1HPtpvd1mVrLWtEFNSJYOvTQ4Wh7DE+hD1v1DHOmkT3i3O3ULXFAx96Ys2IIXiKtOf4PDyOFFH6zZ1aFsQ3Rut4U6O1tMx2Ns6ANZ+rA1k27zn9dfdCB1E9NuIvQoX3jKYq/3k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734596190; c=relaxed/simple;
	bh=6Fu2Jq2QMDhzrqDcwKjUOkOR905W3HnpEd7BjJJkLpc=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:
	 Content-Type; b=WIUjSEU86On5AvMLoCbHQfYi9WamXmG0XZVjDBjYY8xXugx2RuJEaLhMLUJ4nYVRjds1xzeCamLKxyAwdJ3P6kDWdp5HTe7+8RMdokkMnzwNYvZrdr+kY5ZGCjIyLKP981OthN8DnT3g1JBnuqeFSQjqv2MjTTEKGO8m9S3s+y8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f207.google.com with SMTP id e9e14a558f8ab-3a9cbe8fea1so4640035ab.3
        for <ocfs2-devel@lists.linux.dev>; Thu, 19 Dec 2024 00:16:27 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734596187; x=1735200987;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=AeYDOlvKZsAr8i+RrolSonbVg604rX9h27Iki+qo4bg=;
        b=kkw+zmEpiRxbjKJUHkp2K/AXhrZGchmB0WxAvuBQiraPLuMjr/f9tAlhPRISnsphkB
         1kzPsCc8WvIkZY1ue8oghEYa4Ya4xhwYESA/x5psNgw73HFBQFFhy762HwbV6t2cUhiC
         DC/LxPzX/uXnM/2YCqqLfRxDi00xHKEgGR6qlFwgUBWqaogNBS+41OKggYIYSkhJPD0h
         aOQ2NwSGdmHKs3Wd1kcT6zhymmzDIUHteKzdrdak3DjN54bNDy+/D9/6GlZPqFqHZn37
         o4keF345vXjI4nIrgFOsWSfleZcLQ2f6w+GAZxpwWQKCOZk3AbSsx5nmn+2KURjSRpa3
         iQwg==
X-Forwarded-Encrypted: i=1; AJvYcCXCAk5xtNueYDijywLW4lo1SX4c6VEdrNGMrcVgWWvmqJW7IYn8iIQWr8eToggq5CBetVor9XPNyKK0FQ==@lists.linux.dev
X-Gm-Message-State: AOJu0YyP2G7etyDBfGcKEU6e/fH/d2LrUoOnnPX7QMcGgVF2eWDQU8tH
	vItDnIzt3uGIp1AGqjtzATLT3QE6PVd2gEOJZ0i/VaVNYh2dJNh0IEtj2cbp2kUN2RSSFFR0cxc
	wNrBDxy+RuqYuv0Iis3cmPXVl3yqiEFMg/m9PXlr+dvkPBkEgdcLiZ60=
X-Google-Smtp-Source: AGHT+IEsT+jdrvUEFLsYpi3bPfagIafhUr5jrEvDvnIWigiXoBIdop/uWREbjnSpA19bL5nDNc6Kel2OIer+Tv7W/yCzhM0k115W
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1c42:b0:3a7:e67f:3c5b with SMTP id
 e9e14a558f8ab-3c010629b45mr20386705ab.2.1734596187290; Thu, 19 Dec 2024
 00:16:27 -0800 (PST)
Date: Thu, 19 Dec 2024 00:16:27 -0800
In-Reply-To: <66fdfef3.050a0220.9ec68.0031.GAE@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6763d65b.050a0220.3157ee.0011.GAE@google.com>
Subject: Re: [syzbot] [ocfs2?] possible deadlock in ocfs2_del_inode_from_orphan
From: syzbot <syzbot+78359d5fbb04318c35e9@syzkaller.appspotmail.com>
To: jlbec@evilplan.org, joseph.qi@linux.alibaba.com, 
	linux-kernel@vger.kernel.org, mark@fasheh.com, ocfs2-devel@lists.linux.dev, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

syzbot has found a reproducer for the following issue on:

HEAD commit:    c061cf420ded Merge tag 'trace-v6.13-rc3' of git://git.kern..
git tree:       upstream
console+strace: https://syzkaller.appspot.com/x/log.txt?x=10cc2e0f980000
kernel config:  https://syzkaller.appspot.com/x/.config?x=6a2b862bf4a5409f
dashboard link: https://syzkaller.appspot.com/bug?extid=78359d5fbb04318c35e9
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=113277e8580000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=17bdef44580000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/d015858e49d6/disk-c061cf42.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/8af783cbffc2/vmlinux-c061cf42.xz
kernel image: https://storage.googleapis.com/syzbot-assets/33b1bb739ed8/bzImage-c061cf42.xz
mounted in repro: https://storage.googleapis.com/syzbot-assets/9303ddff3347/mount_0.gz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+78359d5fbb04318c35e9@syzkaller.appspotmail.com

ocfs2: Mounting device (7,0) on (node local, slot 0) with ordered data mode.
======================================================
WARNING: possible circular locking dependency detected
6.13.0-rc3-syzkaller-00062-gc061cf420ded #0 Not tainted
------------------------------------------------------
syz-executor257/6003 is trying to acquire lock:
ffff88806f6d5100 (&ocfs2_sysfile_lock_key[args->fi_sysfile_type]){+.+.}-{4:4}, at: inode_lock include/linux/fs.h:818 [inline]
ffff88806f6d5100 (&ocfs2_sysfile_lock_key[args->fi_sysfile_type]){+.+.}-{4:4}, at: ocfs2_del_inode_from_orphan+0x159/0x800 fs/ocfs2/namei.c:2728

but task is already holding lock:
ffff888076616a20 (&ocfs2_quota_ip_alloc_sem_key){++++}-{4:4}, at: ocfs2_dio_end_io_write fs/ocfs2/aops.c:2321 [inline]
ffff888076616a20 (&ocfs2_quota_ip_alloc_sem_key){++++}-{4:4}, at: ocfs2_dio_end_io+0x44a/0x1250 fs/ocfs2/aops.c:2427

which lock already depends on the new lock.


the existing dependency chain (in reverse order) is:

-> #3 (&ocfs2_quota_ip_alloc_sem_key){++++}-{4:4}:
       lock_acquire+0x1ed/0x550 kernel/locking/lockdep.c:5849
       down_write+0x99/0x220 kernel/locking/rwsem.c:1577
       ocfs2_create_local_dquot+0x1de/0x1d70 fs/ocfs2/quota_local.c:1231
       ocfs2_acquire_dquot+0x833/0xb70 fs/ocfs2/quota_global.c:878
       dqget+0x772/0xeb0 fs/quota/dquot.c:977
       __dquot_initialize+0x2e3/0xec0 fs/quota/dquot.c:1505
       ocfs2_get_init_inode+0x158/0x1d0 fs/ocfs2/namei.c:202
       ocfs2_mknod+0xcfa/0x2b30 fs/ocfs2/namei.c:310
       ocfs2_mkdir+0x1ab/0x470 fs/ocfs2/namei.c:657
       vfs_mkdir+0x2fb/0x4f0 fs/namei.c:4311
       do_mkdirat+0x264/0x3a0 fs/namei.c:4334
       __do_sys_mkdir fs/namei.c:4354 [inline]
       __se_sys_mkdir fs/namei.c:4352 [inline]
       __x64_sys_mkdir+0x6c/0x80 fs/namei.c:4352
       do_syscall_x64 arch/x86/entry/common.c:52 [inline]
       do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
       entry_SYSCALL_64_after_hwframe+0x77/0x7f

-> #2 (&dquot->dq_lock){+.+.}-{4:4}:
       lock_acquire+0x1ed/0x550 kernel/locking/lockdep.c:5849
       __mutex_lock_common kernel/locking/mutex.c:585 [inline]
       __mutex_lock+0x1ac/0xee0 kernel/locking/mutex.c:735
       wait_on_dquot fs/quota/dquot.c:354 [inline]
       dqget+0x6e6/0xeb0 fs/quota/dquot.c:972
       __dquot_initialize+0x2e3/0xec0 fs/quota/dquot.c:1505
       ocfs2_get_init_inode+0x158/0x1d0 fs/ocfs2/namei.c:202
       ocfs2_mknod+0xcfa/0x2b30 fs/ocfs2/namei.c:310
       ocfs2_mkdir+0x1ab/0x470 fs/ocfs2/namei.c:657
       vfs_mkdir+0x2fb/0x4f0 fs/namei.c:4311
       do_mkdirat+0x264/0x3a0 fs/namei.c:4334
       __do_sys_mkdir fs/namei.c:4354 [inline]
       __se_sys_mkdir fs/namei.c:4352 [inline]
       __x64_sys_mkdir+0x6c/0x80 fs/namei.c:4352
       do_syscall_x64 arch/x86/entry/common.c:52 [inline]
       do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
       entry_SYSCALL_64_after_hwframe+0x77/0x7f

-> #1 (&ocfs2_sysfile_lock_key[args->fi_sysfile_type]#2){+.+.}-{4:4}:
       lock_acquire+0x1ed/0x550 kernel/locking/lockdep.c:5849
       down_write+0x99/0x220 kernel/locking/rwsem.c:1577
       inode_lock include/linux/fs.h:818 [inline]
       ocfs2_remove_inode fs/ocfs2/inode.c:655 [inline]
       ocfs2_wipe_inode fs/ocfs2/inode.c:818 [inline]
       ocfs2_delete_inode fs/ocfs2/inode.c:1079 [inline]
       ocfs2_evict_inode+0x209f/0x4630 fs/ocfs2/inode.c:1216
       evict+0x4ea/0x9a0 fs/inode.c:796
       d_delete_notify include/linux/fsnotify.h:332 [inline]
       vfs_rmdir+0x3d7/0x510 fs/namei.c:4407
       do_rmdir+0x3b5/0x580 fs/namei.c:4453
       __do_sys_unlinkat fs/namei.c:4629 [inline]
       __se_sys_unlinkat fs/namei.c:4623 [inline]
       __x64_sys_unlinkat+0xde/0xf0 fs/namei.c:4623
       do_syscall_x64 arch/x86/entry/common.c:52 [inline]
       do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
       entry_SYSCALL_64_after_hwframe+0x77/0x7f

-> #0 (&ocfs2_sysfile_lock_key[args->fi_sysfile_type]){+.+.}-{4:4}:
       check_prev_add kernel/locking/lockdep.c:3161 [inline]
       check_prevs_add kernel/locking/lockdep.c:3280 [inline]
       validate_chain+0x18ef/0x5920 kernel/locking/lockdep.c:3904
       __lock_acquire+0x1397/0x2100 kernel/locking/lockdep.c:5226
       lock_acquire+0x1ed/0x550 kernel/locking/lockdep.c:5849
       down_write+0x99/0x220 kernel/locking/rwsem.c:1577
       inode_lock include/linux/fs.h:818 [inline]
       ocfs2_del_inode_from_orphan+0x159/0x800 fs/ocfs2/namei.c:2728
       ocfs2_dio_end_io_write fs/ocfs2/aops.c:2329 [inline]
       ocfs2_dio_end_io+0x55b/0x1250 fs/ocfs2/aops.c:2427
       dio_complete+0x253/0x6b0 fs/direct-io.c:281
       __blockdev_direct_IO+0x3eb6/0x4890 fs/direct-io.c:1303
       ocfs2_direct_IO+0x255/0x2c0 fs/ocfs2/aops.c:2464
       generic_file_direct_write+0x1e8/0x400 mm/filemap.c:3978
       __generic_file_write_iter+0x126/0x230 mm/filemap.c:4142
       ocfs2_file_write_iter+0x19af/0x2180 fs/ocfs2/file.c:2469
       new_sync_write fs/read_write.c:586 [inline]
       vfs_write+0xaed/0xd30 fs/read_write.c:679
       ksys_write+0x18f/0x2b0 fs/read_write.c:731
       do_syscall_x64 arch/x86/entry/common.c:52 [inline]
       do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
       entry_SYSCALL_64_after_hwframe+0x77/0x7f

other info that might help us debug this:

Chain exists of:
  &ocfs2_sysfile_lock_key[args->fi_sysfile_type] --> &dquot->dq_lock --> &ocfs2_quota_ip_alloc_sem_key

 Possible unsafe locking scenario:

       CPU0                    CPU1
       ----                    ----
  lock(&ocfs2_quota_ip_alloc_sem_key);
                               lock(&dquot->dq_lock);
                               lock(&ocfs2_quota_ip_alloc_sem_key);
  lock(&ocfs2_sysfile_lock_key[args->fi_sysfile_type]);

 *** DEADLOCK ***

3 locks held by syz-executor257/6003:
 #0: ffff88807cfd6420 (sb_writers#9){.+.+}-{0:0}, at: file_start_write include/linux/fs.h:2964 [inline]
 #0: ffff88807cfd6420 (sb_writers#9){.+.+}-{0:0}, at: vfs_write+0x225/0xd30 fs/read_write.c:675
 #1: ffff888076616d80 (&sb->s_type->i_mutex_key#15){+.+.}-{4:4}, at: inode_lock include/linux/fs.h:818 [inline]
 #1: ffff888076616d80 (&sb->s_type->i_mutex_key#15){+.+.}-{4:4}, at: ocfs2_file_write_iter+0x445/0x2180 fs/ocfs2/file.c:2399
 #2: ffff888076616a20 (&ocfs2_quota_ip_alloc_sem_key){++++}-{4:4}, at: ocfs2_dio_end_io_write fs/ocfs2/aops.c:2321 [inline]
 #2: ffff888076616a20 (&ocfs2_quota_ip_alloc_sem_key){++++}-{4:4}, at: ocfs2_dio_end_io+0x44a/0x1250 fs/ocfs2/aops.c:2427

stack backtrace:
CPU: 0 UID: 0 PID: 6003 Comm: syz-executor257 Not tainted 6.13.0-rc3-syzkaller-00062-gc061cf420ded #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 11/25/2024
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:94 [inline]
 dump_stack_lvl+0x241/0x360 lib/dump_stack.c:120
 print_circular_bug+0x13a/0x1b0 kernel/locking/lockdep.c:2074
 check_noncircular+0x36a/0x4a0 kernel/locking/lockdep.c:2206
 check_prev_add kernel/locking/lockdep.c:3161 [inline]
 check_prevs_add kernel/locking/lockdep.c:3280 [inline]
 validate_chain+0x18ef/0x5920 kernel/locking/lockdep.c:3904
 __lock_acquire+0x1397/0x2100 kernel/locking/lockdep.c:5226
 lock_acquire+0x1ed/0x550 kernel/locking/lockdep.c:5849
 down_write+0x99/0x220 kernel/locking/rwsem.c:1577
 inode_lock include/linux/fs.h:818 [inline]
 ocfs2_del_inode_from_orphan+0x159/0x800 fs/ocfs2/namei.c:2728
 ocfs2_dio_end_io_write fs/ocfs2/aops.c:2329 [inline]
 ocfs2_dio_end_io+0x55b/0x1250 fs/ocfs2/aops.c:2427
 dio_complete+0x253/0x6b0 fs/direct-io.c:281
 __blockdev_direct_IO+0x3eb6/0x4890 fs/direct-io.c:1303
 ocfs2_direct_IO+0x255/0x2c0 fs/ocfs2/aops.c:2464
 generic_file_direct_write+0x1e8/0x400 mm/filemap.c:3978
 __generic_file_write_iter+0x126/0x230 mm/filemap.c:4142
 ocfs2_file_write_iter+0x19af/0x2180 fs/ocfs2/file.c:2469
 new_sync_write fs/read_write.c:586 [inline]
 vfs_write+0xaed/0xd30 fs/read_write.c:679
 ksys_write+0x18f/0x2b0 fs/read_write.c:731
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f84076eb969
Code: 28 00 00 00 75 05 48 83 c4 28 c3 e8 21 18 00 00 90 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 b8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007ffe891e4fb8 EFLAGS: 00000246 ORIG_RAX: 0000000000000001
RAX: ffffffffffffffda RBX: 0000000000000003 RCX: 00007f84076eb969
RDX: 000000000000f000 RSI: 0000000020000200 RDI: 0000000000000006
RBP: 0000000000000000 R08: 00007ffe891e4d57 R09: 00007ffe891e4fec
R10: 0000000000000012 R11: 0000000000000246 R12: 00007ffe891e4fec
R13: 000000000000002b R14: 431bde82d7b634db R15: 00007ffe891e5020
 </TASK>


---
If you want syzbot to run the reproducer, reply with:
#syz test: git://repo/address.git branch-or-commit-hash
If you attach or paste a git patch, syzbot will apply it before testing.
