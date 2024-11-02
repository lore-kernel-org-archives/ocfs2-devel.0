Received: from mail-il1-f199.google.com (mail-il1-f199.google.com [209.85.166.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 092A0189B83
	for <ocfs2-devel@lists.linux.dev>; Sat,  2 Nov 2024 15:20:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730560830; cv=none; b=MXLUqSAjTtuAWwdG3Vn7o5Pn6buBSok9dXGKnCI5RvwLCkH9kyM7dbsN/bVdwGg2AVfWx4icycZSqz0TrwWFs7ts/MhkSnxsT9GUTJfqIi/tWv6vaf5PTwIeTqkAsbkNdkyyz/Xo/+xqoXHc9EHOgmRGznTUhS7T3jsCN7rfcak=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730560830; c=relaxed/simple;
	bh=SE+UejIIw7guWlCHmlLV8jKvYrjuu+FVrvTdhOk6+VM=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=K2k6blBkUNHIByKLtfCGGTr9VryA0FyRjvjoCdVwYbGGVHSMrUkBVVBolG86JQhz7DTwBbrY/NAndGmJG8Zjgdmeq6OcqvJpCS+BN3sqtqbJOPqaawr/e9m9RfNIbm/MFtGRi5LnSZxxC1BW8KZgpJD4s52UrT7f6+QKCti2WYA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f199.google.com with SMTP id e9e14a558f8ab-3a6c01d8df2so4077855ab.1
        for <ocfs2-devel@lists.linux.dev>; Sat, 02 Nov 2024 08:20:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730560826; x=1731165626;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=GPbCcDZUmMc+SUllfLOvhJhEseXUk6sH+qYujrmJpgA=;
        b=AC3daw+MjjcRGhHu/eGzXbJ05o92U9zmvSSrxRNrqJ/9obDeqj8Z//Pn/GHp7SQIMZ
         3aT2pO3sB9bLScJLDdX3uzg98upRJ2Osv7Nv3qrV4aQagReI88ZgX728uvzltx1o9N2v
         eEeYVGuZQyyK+tNwo2Yq4zkXj5c0B1K3r7aihcI6yG/p2B88OhbrXtg+Ui3pPkB9xx82
         KBclwM1Wgey17Xp4Ufc7Puw4Lx6kmlXOITTfxKcd3GLuprL/tnuy+U459fDZdRLOItCw
         UtqB3Ep2FdnsqKP8EuVyz2sR6fDRDvjWzZ94N813vTxNzH2QWhU3SVoVaWkIKzoFsrTr
         1wuA==
X-Forwarded-Encrypted: i=1; AJvYcCXJY+3pgWPqvJiDDpetXJOW04b+pLea0AjEoKnR5PFkrWx1jrMgTXB9i7u7SBYzKy3kxLWuRGk0h0boLQ==@lists.linux.dev
X-Gm-Message-State: AOJu0Yyfvq5pW0L+9NrriYkYaNmoxFyN8YFv72RMWaDkVJhphRhA1MgK
	eV6+fANZri+Zcf2lcktKgoAbb0bAWUPc9pJvlKsJBqyHIy3Yx1eV6R+K4EtqxEIbzoY+9AnMRoH
	ggDNLlaalPmdvPH50nmDP940iWAVn4p7kFjJIG+ei9txEl+Tbv/lmBFY=
X-Google-Smtp-Source: AGHT+IFfU4AOS+HWFYx+VSBAEM9J9ZISG7JXaZekn5ttTdEZ1r+SoXDDuteckTmysyEjiw+wB30Mdq0rnnokoXZcI6xqDTNK9qmA
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1fc6:b0:3a6:abb0:59a0 with SMTP id
 e9e14a558f8ab-3a6abb05ca3mr71457325ab.0.1730560825978; Sat, 02 Nov 2024
 08:20:25 -0700 (PDT)
Date: Sat, 02 Nov 2024 08:20:25 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <67264339.050a0220.35b515.0184.GAE@google.com>
Subject: [syzbot] [ocfs2?] possible deadlock in __ocfs2_write_remove_suid
From: syzbot <syzbot+61eb9f5be190a23ea4df@syzkaller.appspotmail.com>
To: jlbec@evilplan.org, joseph.qi@linux.alibaba.com, 
	linux-kernel@vger.kernel.org, mark@fasheh.com, ocfs2-devel@lists.linux.dev, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    1bf329c696cf Merge remote-tracking branch 'tip/irq/core' i..
git tree:       git://git.kernel.org/pub/scm/linux/kernel/git/arm64/linux.git for-kernelci
console output: https://syzkaller.appspot.com/x/log.txt?x=137c815f980000
kernel config:  https://syzkaller.appspot.com/x/.config?x=9bfadfb661dcd85e
dashboard link: https://syzkaller.appspot.com/bug?extid=61eb9f5be190a23ea4df
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40
userspace arch: arm64

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/ce371aa5cd38/disk-1bf329c6.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/d9b9cedf697e/vmlinux-1bf329c6.xz
kernel image: https://storage.googleapis.com/syzbot-assets/9376f54faf55/Image-1bf329c6.gz.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+61eb9f5be190a23ea4df@syzkaller.appspotmail.com

loop5: detected capacity change from 0 to 32768
ocfs2: Mounting device (7,5) on (node local, slot 0) with ordered data mode.
======================================================
WARNING: possible circular locking dependency detected
6.12.0-rc5-syzkaller-g1bf329c696cf #0 Not tainted
------------------------------------------------------
syz.5.170/7612 is trying to acquire lock:
ffff0000dfae4610 (sb_internal#4){.+.+}-{0:0}, at: __ocfs2_write_remove_suid+0x1ac/0x7b0 fs/ocfs2/file.c:1385

but task is already holding lock:
ffff0000ef3294a0 (&oi->ip_alloc_sem){++++}-{3:3}, at: ocfs2_inode_lock_for_extent_tree+0xf0/0x1cc fs/ocfs2/file.c:2202

which lock already depends on the new lock.


the existing dependency chain (in reverse order) is:

-> #4 (&oi->ip_alloc_sem){++++}-{3:3}:
       down_write+0x50/0xc0 kernel/locking/rwsem.c:1577
       ocfs2_try_remove_refcount_tree+0xb4/0x2f0 fs/ocfs2/refcounttree.c:932
       ocfs2_xattr_set+0x670/0x1448 fs/ocfs2/xattr.c:3670
       ocfs2_set_acl+0x410/0x4b4 fs/ocfs2/acl.c:254
       ocfs2_iop_set_acl+0x230/0x374 fs/ocfs2/acl.c:286
       set_posix_acl fs/posix_acl.c:955 [inline]
       vfs_set_acl+0x7a0/0xa24 fs/posix_acl.c:1134
       do_set_acl+0xc8/0x1ac fs/posix_acl.c:1279
       do_setxattr fs/xattr.c:626 [inline]
       path_setxattr+0x334/0x428 fs/xattr.c:658
       __do_sys_lsetxattr fs/xattr.c:683 [inline]
       __se_sys_lsetxattr fs/xattr.c:679 [inline]
       __arm64_sys_lsetxattr+0xbc/0xd8 fs/xattr.c:679
       __invoke_syscall arch/arm64/kernel/syscall.c:35 [inline]
       invoke_syscall+0x98/0x2b8 arch/arm64/kernel/syscall.c:49
       el0_svc_common+0x130/0x23c arch/arm64/kernel/syscall.c:132
       do_el0_svc+0x48/0x58 arch/arm64/kernel/syscall.c:151
       el0_svc+0x54/0x168 arch/arm64/kernel/entry-common.c:744
       el0t_64_sync_handler+0x84/0x108 arch/arm64/kernel/entry-common.c:762
       el0t_64_sync+0x198/0x19c arch/arm64/kernel/entry.S:600

-> #3 (&oi->ip_xattr_sem){++++}-{3:3}:
       down_read+0x58/0x2fc kernel/locking/rwsem.c:1524
       ocfs2_init_acl+0x2c8/0x764 fs/ocfs2/acl.c:366
       ocfs2_mknod+0x1388/0x243c fs/ocfs2/namei.c:408
       ocfs2_create+0x194/0x4e0 fs/ocfs2/namei.c:672
       lookup_open fs/namei.c:3595 [inline]
       open_last_lookups fs/namei.c:3694 [inline]
       path_openat+0x13e4/0x2b14 fs/namei.c:3930
       do_filp_open+0x1bc/0x3cc fs/namei.c:3960
       do_sys_openat2+0x124/0x1b8 fs/open.c:1415
       do_sys_open fs/open.c:1430 [inline]
       __do_sys_openat fs/open.c:1446 [inline]
       __se_sys_openat fs/open.c:1441 [inline]
       __arm64_sys_openat+0x1f0/0x240 fs/open.c:1441
       __invoke_syscall arch/arm64/kernel/syscall.c:35 [inline]
       invoke_syscall+0x98/0x2b8 arch/arm64/kernel/syscall.c:49
       el0_svc_common+0x130/0x23c arch/arm64/kernel/syscall.c:132
       do_el0_svc+0x48/0x58 arch/arm64/kernel/syscall.c:151
       el0_svc+0x54/0x168 arch/arm64/kernel/entry-common.c:744
       el0t_64_sync_handler+0x84/0x108 arch/arm64/kernel/entry-common.c:762
       el0t_64_sync+0x198/0x19c arch/arm64/kernel/entry.S:600

-> #2 (jbd2_handle){++++}-{0:0}:
       start_this_handle+0xf34/0x11c4 fs/jbd2/transaction.c:448
       jbd2__journal_start+0x298/0x544 fs/jbd2/transaction.c:505
       jbd2_journal_start+0x3c/0x4c fs/jbd2/transaction.c:544
       ocfs2_start_trans+0x3d0/0x71c fs/ocfs2/journal.c:352
       ocfs2_block_group_alloc fs/ocfs2/suballoc.c:685 [inline]
       ocfs2_reserve_suballoc_bits+0x840/0x4288 fs/ocfs2/suballoc.c:832
       ocfs2_reserve_new_metadata_blocks+0x384/0x848 fs/ocfs2/suballoc.c:982
       ocfs2_mknod+0xdc8/0x243c fs/ocfs2/namei.c:345
       ocfs2_create+0x194/0x4e0 fs/ocfs2/namei.c:672
       lookup_open fs/namei.c:3595 [inline]
       open_last_lookups fs/namei.c:3694 [inline]
       path_openat+0x13e4/0x2b14 fs/namei.c:3930
       do_filp_open+0x1bc/0x3cc fs/namei.c:3960
       do_sys_openat2+0x124/0x1b8 fs/open.c:1415
       do_sys_open fs/open.c:1430 [inline]
       __do_sys_openat fs/open.c:1446 [inline]
       __se_sys_openat fs/open.c:1441 [inline]
       __arm64_sys_openat+0x1f0/0x240 fs/open.c:1441
       __invoke_syscall arch/arm64/kernel/syscall.c:35 [inline]
       invoke_syscall+0x98/0x2b8 arch/arm64/kernel/syscall.c:49
       el0_svc_common+0x130/0x23c arch/arm64/kernel/syscall.c:132
       do_el0_svc+0x48/0x58 arch/arm64/kernel/syscall.c:151
       el0_svc+0x54/0x168 arch/arm64/kernel/entry-common.c:744
       el0t_64_sync_handler+0x84/0x108 arch/arm64/kernel/entry-common.c:762
       el0t_64_sync+0x198/0x19c arch/arm64/kernel/entry.S:600

-> #1 (&journal->j_trans_barrier){.+.+}-{3:3}:
       down_read+0x58/0x2fc kernel/locking/rwsem.c:1524
       ocfs2_start_trans+0x3c4/0x71c fs/ocfs2/journal.c:350
       ocfs2_block_group_alloc fs/ocfs2/suballoc.c:685 [inline]
       ocfs2_reserve_suballoc_bits+0x840/0x4288 fs/ocfs2/suballoc.c:832
       ocfs2_reserve_new_metadata_blocks+0x384/0x848 fs/ocfs2/suballoc.c:982
       ocfs2_mknod+0xdc8/0x243c fs/ocfs2/namei.c:345
       ocfs2_create+0x194/0x4e0 fs/ocfs2/namei.c:672
       lookup_open fs/namei.c:3595 [inline]
       open_last_lookups fs/namei.c:3694 [inline]
       path_openat+0x13e4/0x2b14 fs/namei.c:3930
       do_filp_open+0x1bc/0x3cc fs/namei.c:3960
       do_sys_openat2+0x124/0x1b8 fs/open.c:1415
       do_sys_open fs/open.c:1430 [inline]
       __do_sys_openat fs/open.c:1446 [inline]
       __se_sys_openat fs/open.c:1441 [inline]
       __arm64_sys_openat+0x1f0/0x240 fs/open.c:1441
       __invoke_syscall arch/arm64/kernel/syscall.c:35 [inline]
       invoke_syscall+0x98/0x2b8 arch/arm64/kernel/syscall.c:49
       el0_svc_common+0x130/0x23c arch/arm64/kernel/syscall.c:132
       do_el0_svc+0x48/0x58 arch/arm64/kernel/syscall.c:151
       el0_svc+0x54/0x168 arch/arm64/kernel/entry-common.c:744
       el0t_64_sync_handler+0x84/0x108 arch/arm64/kernel/entry-common.c:762
       el0t_64_sync+0x198/0x19c arch/arm64/kernel/entry.S:600

-> #0 (sb_internal#4){.+.+}-{0:0}:
       check_prev_add kernel/locking/lockdep.c:3161 [inline]
       check_prevs_add kernel/locking/lockdep.c:3280 [inline]
       validate_chain kernel/locking/lockdep.c:3904 [inline]
       __lock_acquire+0x33f8/0x77c8 kernel/locking/lockdep.c:5202
       lock_acquire+0x240/0x728 kernel/locking/lockdep.c:5825
       percpu_down_read include/linux/percpu-rwsem.h:51 [inline]
       __sb_start_write include/linux/fs.h:1716 [inline]
       sb_start_intwrite include/linux/fs.h:1899 [inline]
       ocfs2_start_trans+0x244/0x71c fs/ocfs2/journal.c:348
       __ocfs2_write_remove_suid+0x1ac/0x7b0 fs/ocfs2/file.c:1385
       ocfs2_write_remove_suid fs/ocfs2/file.c:1426 [inline]
       ocfs2_prepare_inode_for_write fs/ocfs2/file.c:2303 [inline]
       ocfs2_file_write_iter+0x8ac/0x1e10 fs/ocfs2/file.c:2441
       new_sync_write fs/read_write.c:590 [inline]
       vfs_write+0x920/0xcf4 fs/read_write.c:683
       ksys_write+0x15c/0x26c fs/read_write.c:736
       __do_sys_write fs/read_write.c:748 [inline]
       __se_sys_write fs/read_write.c:745 [inline]
       __arm64_sys_write+0x7c/0x90 fs/read_write.c:745
       __invoke_syscall arch/arm64/kernel/syscall.c:35 [inline]
       invoke_syscall+0x98/0x2b8 arch/arm64/kernel/syscall.c:49
       el0_svc_common+0x130/0x23c arch/arm64/kernel/syscall.c:132
       do_el0_svc+0x48/0x58 arch/arm64/kernel/syscall.c:151
       el0_svc+0x54/0x168 arch/arm64/kernel/entry-common.c:744
       el0t_64_sync_handler+0x84/0x108 arch/arm64/kernel/entry-common.c:762
       el0t_64_sync+0x198/0x19c arch/arm64/kernel/entry.S:600

other info that might help us debug this:

Chain exists of:
  sb_internal#4 --> &oi->ip_xattr_sem --> &oi->ip_alloc_sem

 Possible unsafe locking scenario:

       CPU0                    CPU1
       ----                    ----
  rlock(&oi->ip_alloc_sem);
                               lock(&oi->ip_xattr_sem);
                               lock(&oi->ip_alloc_sem);
  rlock(sb_internal#4);

 *** DEADLOCK ***

4 locks held by syz.5.170/7612:
 #0: ffff0000d1ba95f8 (&f->f_pos_lock){+.+.}-{3:3}, at: fdget_pos+0x214/0x2a0 fs/file.c:1160
 #1: ffff0000dfae4420 (sb_writers#19){.+.+}-{0:0}, at: file_start_write include/linux/fs.h:2931 [inline]
 #1: ffff0000dfae4420 (sb_writers#19){.+.+}-{0:0}, at: vfs_write+0x354/0xcf4 fs/read_write.c:679
 #2: ffff0000ef329800 (&sb->s_type->i_mutex_key#26){+.+.}-{3:3}, at: inode_lock include/linux/fs.h:815 [inline]
 #2: ffff0000ef329800 (&sb->s_type->i_mutex_key#26){+.+.}-{3:3}, at: ocfs2_file_write_iter+0x390/0x1e10 fs/ocfs2/file.c:2391
 #3: ffff0000ef3294a0 (&oi->ip_alloc_sem){++++}-{3:3}, at: ocfs2_inode_lock_for_extent_tree+0xf0/0x1cc fs/ocfs2/file.c:2202

stack backtrace:
CPU: 0 UID: 60928 PID: 7612 Comm: syz.5.170 Not tainted 6.12.0-rc5-syzkaller-g1bf329c696cf #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 09/13/2024
Call trace:
 show_stack+0x2c/0x3c arch/arm64/kernel/stacktrace.c:484 (C)
 __dump_stack lib/dump_stack.c:94 [inline]
 dump_stack_lvl+0xe4/0x150 lib/dump_stack.c:120
 dump_stack+0x1c/0x28 lib/dump_stack.c:129
 print_circular_bug+0x154/0x1c0 kernel/locking/lockdep.c:2074
 check_noncircular+0x310/0x404 kernel/locking/lockdep.c:2206
 check_prev_add kernel/locking/lockdep.c:3161 [inline]
 check_prevs_add kernel/locking/lockdep.c:3280 [inline]
 validate_chain kernel/locking/lockdep.c:3904 [inline]
 __lock_acquire+0x33f8/0x77c8 kernel/locking/lockdep.c:5202
 lock_acquire+0x240/0x728 kernel/locking/lockdep.c:5825
 percpu_down_read include/linux/percpu-rwsem.h:51 [inline]
 __sb_start_write include/linux/fs.h:1716 [inline]
 sb_start_intwrite include/linux/fs.h:1899 [inline]
 ocfs2_start_trans+0x244/0x71c fs/ocfs2/journal.c:348
 __ocfs2_write_remove_suid+0x1ac/0x7b0 fs/ocfs2/file.c:1385
 ocfs2_write_remove_suid fs/ocfs2/file.c:1426 [inline]
 ocfs2_prepare_inode_for_write fs/ocfs2/file.c:2303 [inline]
 ocfs2_file_write_iter+0x8ac/0x1e10 fs/ocfs2/file.c:2441
 new_sync_write fs/read_write.c:590 [inline]
 vfs_write+0x920/0xcf4 fs/read_write.c:683
 ksys_write+0x15c/0x26c fs/read_write.c:736
 __do_sys_write fs/read_write.c:748 [inline]
 __se_sys_write fs/read_write.c:745 [inline]
 __arm64_sys_write+0x7c/0x90 fs/read_write.c:745
 __invoke_syscall arch/arm64/kernel/syscall.c:35 [inline]
 invoke_syscall+0x98/0x2b8 arch/arm64/kernel/syscall.c:49
 el0_svc_common+0x130/0x23c arch/arm64/kernel/syscall.c:132
 do_el0_svc+0x48/0x58 arch/arm64/kernel/syscall.c:151
 el0_svc+0x54/0x168 arch/arm64/kernel/entry-common.c:744
 el0t_64_sync_handler+0x84/0x108 arch/arm64/kernel/entry-common.c:762
 el0t_64_sync+0x198/0x19c arch/arm64/kernel/entry.S:600


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
