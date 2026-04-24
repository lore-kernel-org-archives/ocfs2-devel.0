Received: from mail-oi1-f206.google.com (mail-oi1-f206.google.com [209.85.167.206])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F189923B62B
	for <ocfs2-devel@lists.linux.dev>; Fri, 24 Apr 2026 22:32:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.206
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777069960; cv=none; b=hDnziLFoV+gkoQ68qsuuciMzyWykZKzTcqaHINoprHqhSQ3gygzX9Abt8yzOHyxajr31i0OF/tKsDN6I3MERPDfqjtApzpgR+2vaeo4m4hjLYHjF5da/rQtp7Jmmtjrmhk5sqRkrl0fvdnl8+gW7B/ogWlk0jmKWOAP0ZQIfwFg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777069960; c=relaxed/simple;
	bh=XGcSvquMD3raFZO2jjZXMKrle1wofSusvO+AzfAJ43E=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:
	 Content-Type; b=Iy35mSgEUCiJbAELhXYAttFhllxD8Lzl3Zm405lkfNjmOS5hhQi2ChoeQUYBVbZAFYatZG43sgQbEisdnN4xpE6gF8c7173ThGwQ3HUo3apXFqD6oASbcyTbpcqRBd6JtjdbU8jHUc7FP9Fjpee61KUpw2jOflK7mkFoMIA71ek=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.167.206
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oi1-f206.google.com with SMTP id 5614622812f47-46ef241b62aso6983029b6e.0
        for <ocfs2-devel@lists.linux.dev>; Fri, 24 Apr 2026 15:32:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777069958; x=1777674758;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ZVj69T/44BH4EdqyuuQdSe6wswT6vH0lrZFu73JVGa8=;
        b=TXqrMGrJa42PvHei7zvjgNxAv7tVbAEzomHLkjleOoz8YIyK8ZwLDSwmMeLzyqh3kL
         02qd0luAnnJJ6JpYA9MXiOkASmbnI9h5/KaT8PkU4DVbugTs05nRkG//5dK8lEueNDjc
         OHT5b218fUI/Qz0Ba6NwiobSVG7963jA212Owew9z7URSZwZo7yAb5vcWZZZeho81kR9
         0X2FjDrzkAzWEMqp0HRk7sQN3JMQ4Z2fyXZTS6MQvk5HUf8JUNBXj6s8eaE+Cz+c3WVR
         Z/i/cGB7pceiAjjCvO9zISpDjDnGn12rhLXvMxyvGO1Cvsjt/6G4zsrm7JbV7+mKaeLM
         PynA==
X-Forwarded-Encrypted: i=1; AFNElJ98GonJQciqvlWkBorkgR+U7zwVpBleUgt/MOfB1TRs1B96Sq9InjQwqMyewAVUYRZbRF3CvD3+dfmULg==@lists.linux.dev
X-Gm-Message-State: AOJu0YwLBeu0kAxWItrqAkPx2koOIR4yxELaFA6uutx/CAG9LkCvM1Xy
	8wB6Z2KWKVDC6p34Rn9zj2E3m5Fp0Pc0RWl/jPKNaETkMzhBEERJjCV4UmjPPWOLto7Lz/4rNYt
	h3FsLMS5XQlSDJ558WR9oIWIxdfmLW9mTM9ZaPRCZ8qC3EISfpUHpa9DxK8g=
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6820:1c9e:b0:694:921b:b1b4 with SMTP id
 006d021491bc7-694921bb3c3mr12656466eaf.31.1777069957960; Fri, 24 Apr 2026
 15:32:37 -0700 (PDT)
Date: Fri, 24 Apr 2026 15:32:37 -0700
In-Reply-To: <000000000000d7e279061ffd7610@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <69ebef85.a00a0220.7773.000a.GAE@google.com>
Subject: Re: [syzbot] [ocfs2?] possible deadlock in ocfs2_evict_inode
From: syzbot <syzbot+b225d4dfce6219600c42@syzkaller.appspotmail.com>
To: jlbec@evilplan.org, joseph.qi@linux.alibaba.com, 
	linux-kernel@vger.kernel.org, mark@fasheh.com, ocfs2-devel@lists.linux.dev, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

syzbot has found a reproducer for the following issue on:

HEAD commit:    dd6c438c3e64 Merge tag 'vfs-7.1-rc1.fixes' of git://git.ke..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=14af7702580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=1665c021ac0093f6
dashboard link: https://syzkaller.appspot.com/bug?extid=b225d4dfce6219600c42
compiler:       Debian clang version 21.1.8 (++20251221033036+2078da43e25a-1~exp1~20251221153213.50), Debian LLD 21.1.8
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=12d41c36580000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=12af7702580000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/138864bfed4d/disk-dd6c438c.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/b31918ea24c9/vmlinux-dd6c438c.xz
kernel image: https://storage.googleapis.com/syzbot-assets/7215f6e52175/bzImage-dd6c438c.xz
mounted in repro: https://storage.googleapis.com/syzbot-assets/faa689fc730f/mount_0.gz
  fsck result: OK (log: https://syzkaller.appspot.com/x/fsck.log?x=12f6fcce580000)

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+b225d4dfce6219600c42@syzkaller.appspotmail.com

======================================================
WARNING: possible circular locking dependency detected
syzkaller #0 Not tainted
------------------------------------------------------
syz-executor/5944 is trying to acquire lock:
ffff88805b5c6ba0 (&ocfs2_sysfile_lock_key[INODE_ALLOC_SYSTEM_INODE]){+.+.}-{4:4}, at: inode_lock include/linux/fs.h:1029 [inline]
ffff88805b5c6ba0 (&ocfs2_sysfile_lock_key[INODE_ALLOC_SYSTEM_INODE]){+.+.}-{4:4}, at: ocfs2_remove_inode fs/ocfs2/inode.c:733 [inline]
ffff88805b5c6ba0 (&ocfs2_sysfile_lock_key[INODE_ALLOC_SYSTEM_INODE]){+.+.}-{4:4}, at: ocfs2_wipe_inode fs/ocfs2/inode.c:896 [inline]
ffff88805b5c6ba0 (&ocfs2_sysfile_lock_key[INODE_ALLOC_SYSTEM_INODE]){+.+.}-{4:4}, at: ocfs2_delete_inode fs/ocfs2/inode.c:1157 [inline]
ffff88805b5c6ba0 (&ocfs2_sysfile_lock_key[INODE_ALLOC_SYSTEM_INODE]){+.+.}-{4:4}, at: ocfs2_evict_inode+0x1539/0x43b0 fs/ocfs2/inode.c:1299

but task is already holding lock:
ffff88805b5c89a0 (&ocfs2_sysfile_lock_key[ORPHAN_DIR_SYSTEM_INODE]){+.+.}-{4:4}, at: inode_lock include/linux/fs.h:1029 [inline]
ffff88805b5c89a0 (&ocfs2_sysfile_lock_key[ORPHAN_DIR_SYSTEM_INODE]){+.+.}-{4:4}, at: ocfs2_wipe_inode fs/ocfs2/inode.c:854 [inline]
ffff88805b5c89a0 (&ocfs2_sysfile_lock_key[ORPHAN_DIR_SYSTEM_INODE]){+.+.}-{4:4}, at: ocfs2_delete_inode fs/ocfs2/inode.c:1157 [inline]
ffff88805b5c89a0 (&ocfs2_sysfile_lock_key[ORPHAN_DIR_SYSTEM_INODE]){+.+.}-{4:4}, at: ocfs2_evict_inode+0xe97/0x43b0 fs/ocfs2/inode.c:1299

which lock already depends on the new lock.


the existing dependency chain (in reverse order) is:

-> #2 (&ocfs2_sysfile_lock_key[ORPHAN_DIR_SYSTEM_INODE]){+.+.}-{4:4}:
       down_write+0x96/0x200 kernel/locking/rwsem.c:1625
       inode_lock include/linux/fs.h:1029 [inline]
       ocfs2_del_inode_from_orphan+0x12e/0x7a0 fs/ocfs2/namei.c:2728
       ocfs2_dio_end_io_write fs/ocfs2/aops.c:2379 [inline]
       ocfs2_dio_end_io+0xf9c/0x1370 fs/ocfs2/aops.c:2418
       dio_complete+0x25b/0x790 fs/direct-io.c:281
       __blockdev_direct_IO+0x2e5d/0x34e0 fs/direct-io.c:1303
       ocfs2_direct_IO+0x251/0x2c0 fs/ocfs2/aops.c:2455
       generic_file_direct_write+0x1db/0x3e0 mm/filemap.c:4259
       __generic_file_write_iter+0x11d/0x230 mm/filemap.c:4428
       ocfs2_file_write_iter+0x1663/0x1e70 fs/ocfs2/file.c:2476
       do_iter_readv_writev+0x619/0x8c0 fs/read_write.c:-1
       vfs_writev+0x33c/0x990 fs/read_write.c:1059
       do_writev+0x154/0x2e0 fs/read_write.c:1105
       do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
       do_syscall_64+0x15f/0xf80 arch/x86/entry/syscall_64.c:94
       entry_SYSCALL_64_after_hwframe+0x77/0x7f

-> #1 (&ocfs2_sysfile_lock_key[EXTENT_ALLOC_SYSTEM_INODE]){+.+.}-{4:4}:
       down_write+0x96/0x200 kernel/locking/rwsem.c:1625
       inode_lock include/linux/fs.h:1029 [inline]
       ocfs2_reserve_suballoc_bits+0x16d/0x4840 fs/ocfs2/suballoc.c:882
       ocfs2_reserve_new_metadata_blocks+0x415/0x9a0 fs/ocfs2/suballoc.c:1078
       ocfs2_mknod+0x10f3/0x2260 fs/ocfs2/namei.c:351
       ocfs2_create+0x195/0x460 fs/ocfs2/namei.c:677
       lookup_open fs/namei.c:4511 [inline]
       open_last_lookups fs/namei.c:4611 [inline]
       path_openat+0x1395/0x3860 fs/namei.c:4855
       do_file_open+0x23e/0x4a0 fs/namei.c:4887
       do_sys_openat2+0x113/0x200 fs/open.c:1364
       do_sys_open fs/open.c:1370 [inline]
       __do_sys_openat fs/open.c:1386 [inline]
       __se_sys_openat fs/open.c:1381 [inline]
       __x64_sys_openat+0x138/0x170 fs/open.c:1381
       do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
       do_syscall_64+0x15f/0xf80 arch/x86/entry/syscall_64.c:94
       entry_SYSCALL_64_after_hwframe+0x77/0x7f

-> #0 (&ocfs2_sysfile_lock_key[INODE_ALLOC_SYSTEM_INODE]){+.+.}-{4:4}:
       check_prev_add kernel/locking/lockdep.c:3165 [inline]
       check_prevs_add kernel/locking/lockdep.c:3284 [inline]
       validate_chain kernel/locking/lockdep.c:3908 [inline]
       __lock_acquire+0x15a5/0x2cf0 kernel/locking/lockdep.c:5237
       lock_acquire+0x106/0x350 kernel/locking/lockdep.c:5868
       down_write+0x96/0x200 kernel/locking/rwsem.c:1625
       inode_lock include/linux/fs.h:1029 [inline]
       ocfs2_remove_inode fs/ocfs2/inode.c:733 [inline]
       ocfs2_wipe_inode fs/ocfs2/inode.c:896 [inline]
       ocfs2_delete_inode fs/ocfs2/inode.c:1157 [inline]
       ocfs2_evict_inode+0x1539/0x43b0 fs/ocfs2/inode.c:1299
       evict+0x61e/0xb10 fs/inode.c:841
       d_delete_notify include/linux/fsnotify.h:377 [inline]
       vfs_rmdir+0x42a/0x6e0 fs/namei.c:5379
       filename_rmdir+0x292/0x520 fs/namei.c:5421
       __do_sys_unlinkat fs/namei.c:5596 [inline]
       __se_sys_unlinkat+0x71/0x1a0 fs/namei.c:5589
       do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
       do_syscall_64+0x15f/0xf80 arch/x86/entry/syscall_64.c:94
       entry_SYSCALL_64_after_hwframe+0x77/0x7f

other info that might help us debug this:

Chain exists of:
  &ocfs2_sysfile_lock_key[INODE_ALLOC_SYSTEM_INODE] --> &ocfs2_sysfile_lock_key[EXTENT_ALLOC_SYSTEM_INODE] --> &ocfs2_sysfile_lock_key[ORPHAN_DIR_SYSTEM_INODE]

 Possible unsafe locking scenario:

       CPU0                    CPU1
       ----                    ----
  lock(&ocfs2_sysfile_lock_key[ORPHAN_DIR_SYSTEM_INODE]);
                               lock(&ocfs2_sysfile_lock_key[EXTENT_ALLOC_SYSTEM_INODE]);
                               lock(&ocfs2_sysfile_lock_key[ORPHAN_DIR_SYSTEM_INODE]);
  lock(&ocfs2_sysfile_lock_key[INODE_ALLOC_SYSTEM_INODE]);

 *** DEADLOCK ***

4 locks held by syz-executor/5944:
 #0: ffff888036d96410 (sb_writers#12){.+.+}-{0:0}, at: mnt_want_write+0x41/0x90 fs/namespace.c:493
 #1: ffff88805b5ca5a0 (&type->i_mutex_dir_key#8/1){+.+.}-{4:4}, at: inode_lock_nested include/linux/fs.h:1074 [inline]
 #1: ffff88805b5ca5a0 (&type->i_mutex_dir_key#8/1){+.+.}-{4:4}, at: __start_dirop fs/namei.c:2914 [inline]
 #1: ffff88805b5ca5a0 (&type->i_mutex_dir_key#8/1){+.+.}-{4:4}, at: start_dirop fs/namei.c:2938 [inline]
 #1: ffff88805b5ca5a0 (&type->i_mutex_dir_key#8/1){+.+.}-{4:4}, at: filename_rmdir+0x1cd/0x520 fs/namei.c:5414
 #2: ffff888062a38bc0 (&osb->nfs_sync_rwlock){.+.+}-{4:4}, at: ocfs2_nfs_sync_lock+0x106/0x270 fs/ocfs2/dlmglue.c:2875
 #3: ffff88805b5c89a0 (&ocfs2_sysfile_lock_key[ORPHAN_DIR_SYSTEM_INODE]){+.+.}-{4:4}, at: inode_lock include/linux/fs.h:1029 [inline]
 #3: ffff88805b5c89a0 (&ocfs2_sysfile_lock_key[ORPHAN_DIR_SYSTEM_INODE]){+.+.}-{4:4}, at: ocfs2_wipe_inode fs/ocfs2/inode.c:854 [inline]
 #3: ffff88805b5c89a0 (&ocfs2_sysfile_lock_key[ORPHAN_DIR_SYSTEM_INODE]){+.+.}-{4:4}, at: ocfs2_delete_inode fs/ocfs2/inode.c:1157 [inline]
 #3: ffff88805b5c89a0 (&ocfs2_sysfile_lock_key[ORPHAN_DIR_SYSTEM_INODE]){+.+.}-{4:4}, at: ocfs2_evict_inode+0xe97/0x43b0 fs/ocfs2/inode.c:1299

stack backtrace:
CPU: 1 UID: 0 PID: 5944 Comm: syz-executor Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 04/18/2026
Call Trace:
 <TASK>
 dump_stack_lvl+0xe8/0x150 lib/dump_stack.c:120
 print_circular_bug+0x2e1/0x300 kernel/locking/lockdep.c:2043
 check_noncircular+0x12e/0x150 kernel/locking/lockdep.c:2175
 check_prev_add kernel/locking/lockdep.c:3165 [inline]
 check_prevs_add kernel/locking/lockdep.c:3284 [inline]
 validate_chain kernel/locking/lockdep.c:3908 [inline]
 __lock_acquire+0x15a5/0x2cf0 kernel/locking/lockdep.c:5237
 lock_acquire+0x106/0x350 kernel/locking/lockdep.c:5868
 down_write+0x96/0x200 kernel/locking/rwsem.c:1625
 inode_lock include/linux/fs.h:1029 [inline]
 ocfs2_remove_inode fs/ocfs2/inode.c:733 [inline]
 ocfs2_wipe_inode fs/ocfs2/inode.c:896 [inline]
 ocfs2_delete_inode fs/ocfs2/inode.c:1157 [inline]
 ocfs2_evict_inode+0x1539/0x43b0 fs/ocfs2/inode.c:1299
 evict+0x61e/0xb10 fs/inode.c:841
 d_delete_notify include/linux/fsnotify.h:377 [inline]
 vfs_rmdir+0x42a/0x6e0 fs/namei.c:5379
 filename_rmdir+0x292/0x520 fs/namei.c:5421
 __do_sys_unlinkat fs/namei.c:5596 [inline]
 __se_sys_unlinkat+0x71/0x1a0 fs/namei.c:5589
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0x15f/0xf80 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7fb2cbd9bef7
Code: 77 01 c3 48 c7 c2 e8 ff ff ff f7 d8 64 89 02 b8 ff ff ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 b8 07 01 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007ffeba63dcf8 EFLAGS: 00000207 ORIG_RAX: 0000000000000107
RAX: ffffffffffffffda RBX: 0000000000000065 RCX: 00007fb2cbd9bef7
RDX: 0000000000000200 RSI: 00007ffeba63eea0 RDI: 00000000ffffff9c
RBP: 00007fb2cbe32120 R08: 0000000000018560 R09: 0000000000000001
R10: 0000000000000000 R11: 0000000000000207 R12: 00007ffeba63eea0
R13: 00007fb2cbe32120 R14: 00000000000192e7 R15: 00007ffeba641060
 </TASK>


---
If you want syzbot to run the reproducer, reply with:
#syz test: git://repo/address.git branch-or-commit-hash
If you attach or paste a git patch, syzbot will apply it before testing.
