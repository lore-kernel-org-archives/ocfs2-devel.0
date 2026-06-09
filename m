Received: from mail-oa1-f80.google.com (mail-oa1-f80.google.com [209.85.160.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5FF73CAE9B
	for <ocfs2-devel@lists.linux.dev>; Tue,  9 Jun 2026 21:26:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781040389; cv=none; b=ub9QFdfI+V0a8fsUbG4tGy6vJsfJsdVlqR/88sEhhv+2ijX+b/nZmDhD0N+W8Qb6kZZ4nygaVYJUjSVViyBVppdbpmEm9j+p+/hehE9zfE11yqVi2RviMG8NeMD82MGPa3Ea7L+if5c2b3G3EZzsMRTUk8LXL6eJL0PlnXv+yWA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781040389; c=relaxed/simple;
	bh=jwFXNhSWqpaBrPJ+vIm4/2BwUKOciGxznJnCDNvAjmM=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:
	 Content-Type; b=t1i0nPdGHa/r/kroZ2Q+oz4Kg8tt0uPUhxi+0F10a82Xste1LBqKcVbntIAclNrRgL0N84h96Up2yeLj0o2flXFuibBZ/ZzhsGSBZB8uOdyDwqhdLQklUYFlXZHrTkUUmUFcuSrptPZ31a35mNgDsj7Wp+gjf1rDj9L16PS8gxg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.160.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oa1-f80.google.com with SMTP id 586e51a60fabf-43cce86b0c4so9532280fac.3
        for <ocfs2-devel@lists.linux.dev>; Tue, 09 Jun 2026 14:26:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781040387; x=1781645187;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=e6filxemhl2Zfw261M1uKHJMLW9xktwLRLrcx+rGOgo=;
        b=Hk7HRbJhWtc0TAPbbLooSFqNV32pvv78zHq/GkiBdSX8B2lcClkuMK9VkYmr4ZEu9B
         9KRJ/XzYZDkq42FwgItIv+s7/ov/SR8dmMLk4JYTh2QvQr67UPz7894toAUiUm8ZPxJS
         iJX7UoAu9AlGwhJS/uU2fIBTGz49fZrRw23xfNu712F5hytwhhhHudaD/GbKkfSSYhlc
         TW1KyxcYSTdfPSoLTb8J5QXGSFRrh7KT7mkWVXJw38HpIbMsYkHyUjSEICJZO02tS9cz
         2w2o35UNjOcoJuUo4cOo6bOQq0FfqAccDAga3kyD0jQSiwOyprpQx5vBjhqOW+9FtpwW
         l0VA==
X-Forwarded-Encrypted: i=1; AFNElJ+Zn/iVeUOKSzNyc/xm9Ys+2Bu7ltpaFgNNtKASPewtSFTqgLGc+xg6a9R3ytv6lU11H7grF/r+7KghBA==@lists.linux.dev
X-Gm-Message-State: AOJu0YwzOFm91lmplRbT+TJiwqwtHj8JAJq67oX3o8KHlTtPkH2dwxpB
	O0bJwDDVquWvyaMYANLPMkuRS9q5dUCc2CMkbA8o/B0GbB/+3yebh4DlaYzARBzOuFcCENRX4lO
	C/CxNRdaEJzequrRM2TEWvRGykPE37vWTpWdYo0g4tFAZaoWCvPDNI92/2/E=
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6820:1c8f:b0:69d:fee4:2381 with SMTP id
 006d021491bc7-69eacaacdbemr2777849eaf.55.1781040386791; Tue, 09 Jun 2026
 14:26:26 -0700 (PDT)
Date: Tue, 09 Jun 2026 14:26:26 -0700
In-Reply-To: <678e8256.050a0220.303755.0081.GAE@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6a288502.39669fcc.33b062.00a5.GAE@google.com>
Subject: Re: [syzbot] [ocfs2?] possible deadlock in ocfs2_remove_inode (2)
From: syzbot <syzbot+ddde294b94666bb51266@syzkaller.appspotmail.com>
To: jlbec@evilplan.org, joseph.qi@linux.alibaba.com, 
	linux-kernel@vger.kernel.org, mark@fasheh.com, ocfs2-devel@lists.linux.dev, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

syzbot has found a reproducer for the following issue on:

HEAD commit:    2d3090a8aeb5 Merge tag 'v7.1-p5' of git://git.kernel.org/p..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=13d090ae580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=f9e42545d0c4344f
dashboard link: https://syzkaller.appspot.com/bug?extid=ddde294b94666bb51266
compiler:       gcc (Debian 14.2.0-19) 14.2.0, GNU ld (GNU Binutils for Debian) 2.44
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=157bb0ae580000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=15c4e0ae580000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/a3b55b39a1ae/disk-2d3090a8.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/e28dc81f5c8b/vmlinux-2d3090a8.xz
kernel image: https://storage.googleapis.com/syzbot-assets/979afa9a8a33/bzImage-2d3090a8.xz
mounted in repro: https://storage.googleapis.com/syzbot-assets/9da69034f0c7/mount_0.gz
  fsck result: OK (log: https://syzkaller.appspot.com/x/fsck.log?x=11c4e0ae580000)

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+ddde294b94666bb51266@syzkaller.appspotmail.com

======================================================
WARNING: possible circular locking dependency detected
syzkaller #0 Not tainted
------------------------------------------------------
syz-executor/5782 is trying to acquire lock:
ffff8880712c6ba0 (&ocfs2_sysfile_lock_key[INODE_ALLOC_SYSTEM_INODE]){+.+.}-{4:4}, at: inode_lock include/linux/fs.h:1029 [inline]
ffff8880712c6ba0 (&ocfs2_sysfile_lock_key[INODE_ALLOC_SYSTEM_INODE]){+.+.}-{4:4}, at: ocfs2_remove_inode+0x15b/0x860 fs/ocfs2/inode.c:733

but task is already holding lock:
ffff88805a4f89a0 (&ocfs2_sysfile_lock_key[ORPHAN_DIR_SYSTEM_INODE]){+.+.}-{4:4}, at: inode_lock include/linux/fs.h:1029 [inline]
ffff88805a4f89a0 (&ocfs2_sysfile_lock_key[ORPHAN_DIR_SYSTEM_INODE]){+.+.}-{4:4}, at: ocfs2_wipe_inode+0x2ce/0x1250 fs/ocfs2/inode.c:854

which lock already depends on the new lock.


the existing dependency chain (in reverse order) is:

-> #2 (&ocfs2_sysfile_lock_key[ORPHAN_DIR_SYSTEM_INODE]){+.+.}-{4:4}:
       down_write+0x8b/0x1f0 kernel/locking/rwsem.c:1625
       inode_lock include/linux/fs.h:1029 [inline]
       ocfs2_del_inode_from_orphan+0x112/0x700 fs/ocfs2/namei.c:2728
       ocfs2_dio_end_io_write+0x711/0x1130 fs/ocfs2/aops.c:2379
       ocfs2_dio_end_io+0x136/0x2c0 fs/ocfs2/aops.c:2418
       dio_complete+0x224/0x950 fs/direct-io.c:281
       __blockdev_direct_IO+0x2a2d/0x33d0 fs/direct-io.c:1303
       ocfs2_direct_IO+0x263/0x360 fs/ocfs2/aops.c:2455
       generic_file_direct_write+0x198/0x410 mm/filemap.c:4259
       __generic_file_write_iter+0x11b/0x240 mm/filemap.c:4428
       ocfs2_file_write_iter+0xdbb/0x2240 fs/ocfs2/file.c:2476
       iter_file_splice_write+0x830/0x10a0 fs/splice.c:736
       do_splice_from fs/splice.c:936 [inline]
       direct_splice_actor+0x192/0x6c0 fs/splice.c:1159
       splice_direct_to_actor+0x345/0xa30 fs/splice.c:1103
       do_splice_direct_actor fs/splice.c:1202 [inline]
       do_splice_direct+0x174/0x240 fs/splice.c:1228
       do_sendfile+0xadc/0xe20 fs/read_write.c:1372
       __do_sys_sendfile64 fs/read_write.c:1433 [inline]
       __se_sys_sendfile64 fs/read_write.c:1419 [inline]
       __x64_sys_sendfile64+0x1d8/0x220 fs/read_write.c:1419
       do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
       do_syscall_64+0x115/0x870 arch/x86/entry/syscall_64.c:94
       entry_SYSCALL_64_after_hwframe+0x77/0x7f

-> #1 (&ocfs2_sysfile_lock_key[EXTENT_ALLOC_SYSTEM_INODE]){+.+.}-{4:4}:
       down_write+0x8b/0x1f0 kernel/locking/rwsem.c:1625
       inode_lock include/linux/fs.h:1029 [inline]
       ocfs2_reserve_suballoc_bits+0x11c/0x4b50 fs/ocfs2/suballoc.c:882
       ocfs2_reserve_new_metadata_blocks+0x506/0xbe0 fs/ocfs2/suballoc.c:1078
       ocfs2_mknod+0xead/0x27b0 fs/ocfs2/namei.c:351
       ocfs2_create+0xf4/0x450 fs/ocfs2/namei.c:677
       lookup_open.isra.0+0xc47/0x11b0 fs/namei.c:4511
       open_last_lookups fs/namei.c:4611 [inline]
       path_openat+0x2291/0x31a0 fs/namei.c:4855
       do_file_open+0x20e/0x430 fs/namei.c:4887
       do_sys_openat2+0x10d/0x1e0 fs/open.c:1364
       do_sys_open fs/open.c:1370 [inline]
       __do_sys_openat fs/open.c:1386 [inline]
       __se_sys_openat fs/open.c:1381 [inline]
       __x64_sys_openat+0x12d/0x210 fs/open.c:1381
       do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
       do_syscall_64+0x115/0x870 arch/x86/entry/syscall_64.c:94
       entry_SYSCALL_64_after_hwframe+0x77/0x7f

-> #0 (&ocfs2_sysfile_lock_key[INODE_ALLOC_SYSTEM_INODE]){+.+.}-{4:4}:
       check_prev_add kernel/locking/lockdep.c:3165 [inline]
       check_prevs_add kernel/locking/lockdep.c:3284 [inline]
       validate_chain kernel/locking/lockdep.c:3908 [inline]
       __lock_acquire+0x14b8/0x2630 kernel/locking/lockdep.c:5237
       lock_acquire kernel/locking/lockdep.c:5868 [inline]
       lock_acquire+0x1b1/0x370 kernel/locking/lockdep.c:5825
       down_write+0x8b/0x1f0 kernel/locking/rwsem.c:1625
       inode_lock include/linux/fs.h:1029 [inline]
       ocfs2_remove_inode+0x15b/0x860 fs/ocfs2/inode.c:733
       ocfs2_wipe_inode+0x6dd/0x1250 fs/ocfs2/inode.c:896
       ocfs2_delete_inode fs/ocfs2/inode.c:1157 [inline]
       ocfs2_evict_inode+0x7f9/0x1550 fs/ocfs2/inode.c:1299
       evict+0x3c2/0xad0 fs/inode.c:841
       iput_final fs/inode.c:1960 [inline]
       iput.part.0+0x605/0xf50 fs/inode.c:2009
       iput+0x35/0x40 fs/inode.c:1975
       d_delete_notify include/linux/fsnotify.h:377 [inline]
       vfs_rmdir fs/namei.c:5389 [inline]
       vfs_rmdir+0x5c8/0x8a0 fs/namei.c:5349
       filename_rmdir+0x31a/0x5c0 fs/namei.c:5431
       __do_sys_unlinkat fs/namei.c:5606 [inline]
       __se_sys_unlinkat fs/namei.c:5599 [inline]
       __x64_sys_unlinkat+0xf5/0x130 fs/namei.c:5599
       do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
       do_syscall_64+0x115/0x870 arch/x86/entry/syscall_64.c:94
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

4 locks held by syz-executor/5782:
 #0: ffff888037c18410 (sb_writers#12){.+.+}-{0:0}, at: filename_rmdir+0x1ff/0x5c0 fs/namei.c:5420
 #1: ffff8880712c25a0 (&type->i_mutex_dir_key#8/1){+.+.}-{4:4}, at: inode_lock_nested include/linux/fs.h:1074 [inline]
 #1: ffff8880712c25a0 (&type->i_mutex_dir_key#8/1){+.+.}-{4:4}, at: __start_dirop fs/namei.c:2914 [inline]
 #1: ffff8880712c25a0 (&type->i_mutex_dir_key#8/1){+.+.}-{4:4}, at: start_dirop fs/namei.c:2938 [inline]
 #1: ffff8880712c25a0 (&type->i_mutex_dir_key#8/1){+.+.}-{4:4}, at: filename_rmdir+0x258/0x5c0 fs/namei.c:5424
 #2: ffff8880355b8bc0 (&osb->nfs_sync_rwlock){.+.+}-{4:4}, at: ocfs2_nfs_sync_lock+0xe4/0x2e0 fs/ocfs2/dlmglue.c:2875
 #3: ffff88805a4f89a0 (&ocfs2_sysfile_lock_key[ORPHAN_DIR_SYSTEM_INODE]){+.+.}-{4:4}, at: inode_lock include/linux/fs.h:1029 [inline]
 #3: ffff88805a4f89a0 (&ocfs2_sysfile_lock_key[ORPHAN_DIR_SYSTEM_INODE]){+.+.}-{4:4}, at: ocfs2_wipe_inode+0x2ce/0x1250 fs/ocfs2/inode.c:854

stack backtrace:
CPU: 1 UID: 0 PID: 5782 Comm: syz-executor Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 04/18/2026
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:94 [inline]
 dump_stack_lvl+0x100/0x190 lib/dump_stack.c:120
 print_circular_bug.cold+0x178/0x1c7 kernel/locking/lockdep.c:2043
 check_noncircular+0x146/0x160 kernel/locking/lockdep.c:2175
 check_prev_add kernel/locking/lockdep.c:3165 [inline]
 check_prevs_add kernel/locking/lockdep.c:3284 [inline]
 validate_chain kernel/locking/lockdep.c:3908 [inline]
 __lock_acquire+0x14b8/0x2630 kernel/locking/lockdep.c:5237
 lock_acquire kernel/locking/lockdep.c:5868 [inline]
 lock_acquire+0x1b1/0x370 kernel/locking/lockdep.c:5825
 down_write+0x8b/0x1f0 kernel/locking/rwsem.c:1625
 inode_lock include/linux/fs.h:1029 [inline]
 ocfs2_remove_inode+0x15b/0x860 fs/ocfs2/inode.c:733
 ocfs2_wipe_inode+0x6dd/0x1250 fs/ocfs2/inode.c:896
 ocfs2_delete_inode fs/ocfs2/inode.c:1157 [inline]
 ocfs2_evict_inode+0x7f9/0x1550 fs/ocfs2/inode.c:1299
 evict+0x3c2/0xad0 fs/inode.c:841
 iput_final fs/inode.c:1960 [inline]
 iput.part.0+0x605/0xf50 fs/inode.c:2009
 iput+0x35/0x40 fs/inode.c:1975
 d_delete_notify include/linux/fsnotify.h:377 [inline]
 vfs_rmdir fs/namei.c:5389 [inline]
 vfs_rmdir+0x5c8/0x8a0 fs/namei.c:5349
 filename_rmdir+0x31a/0x5c0 fs/namei.c:5431
 __do_sys_unlinkat fs/namei.c:5606 [inline]
 __se_sys_unlinkat fs/namei.c:5599 [inline]
 __x64_sys_unlinkat+0xf5/0x130 fs/namei.c:5599
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0x115/0x870 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f7319b9bf77
Code: 77 01 c3 48 c7 c2 e8 ff ff ff f7 d8 64 89 02 b8 ff ff ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 b8 07 01 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007fffc0104e08 EFLAGS: 00000207 ORIG_RAX: 0000000000000107
RAX: ffffffffffffffda RBX: 0000000000000065 RCX: 00007f7319b9bf77
RDX: 0000000000000200 RSI: 00007fffc0105fb0 RDI: 00000000ffffff9c
RBP: 00007f7319c321ca R08: 0000000000018550 R09: 0000000000000001
R10: 0000000000000000 R11: 0000000000000207 R12: 00007fffc0105fb0
R13: 00007f7319c321ca R14: 000000000001aa05 R15: 00007fffc0108170
 </TASK>
ocfs2: Unmounting device (7,0) on (node local)
ocfs2: Unmounting device (7,0) on (node local)
ocfs2: Unmounting device (7,0) on (node local)
ocfs2: Unmounting device (7,0) on (node local)
ocfs2: Unmounting device (7,0) on (node local)
ocfs2: Unmounting device (7,0) on (node local)
ocfs2: Unmounting device (7,0) on (node local)
ocfs2: Unmounting device (7,0) on (node local)
ocfs2: Unmounting device (7,0) on (node local)
ocfs2: Unmounting device (7,0) on (node local)
ocfs2: Unmounting device (7,0) on (node local)
ocfs2: Unmounting device (7,0) on (node local)
ocfs2: Unmounting device (7,0) on (node local)
ocfs2: Unmounting device (7,0) on (node local)
ocfs2: Unmounting device (7,0) on (node local)
ocfs2: Unmounting device (7,0) on (node local)
ocfs2: Unmounting device (7,0) on (node local)
ocfs2: Unmounting device (7,0) on (node local)
ocfs2: Unmounting device (7,0) on (node local)
ocfs2: Unmounting device (7,0) on (node local)
ocfs2: Unmounting device (7,0) on (node local)
ocfs2: Unmounting device (7,0) on (node local)
ocfs2: Unmounting device (7,0) on (node local)


---
If you want syzbot to run the reproducer, reply with:
#syz test: git://repo/address.git branch-or-commit-hash
If you attach or paste a git patch, syzbot will apply it before testing.
