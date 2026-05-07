Received: from mail-oo1-f80.google.com (mail-oo1-f80.google.com [209.85.161.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 015B5372B32
	for <ocfs2-devel@lists.linux.dev>; Thu,  7 May 2026 10:52:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778151145; cv=none; b=jwOjfoAYpfH0M76iV8ebhHgHPcPJ2WOaamNhrPnJQePy8iz4EY/3KigaNckVTvSSUdbhQXcHyaG9GCV0AzIQik0ULMnu9TO2zziEj9OuJdDfdqcQcRNm+QZYaGS2IKZJ/lt58rMOpxgPPhzhJVxZOTnXToSLCLa3lOlclPeDfM4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778151145; c=relaxed/simple;
	bh=blcleb5e4Nj4mz99PrF2LOCWL7qJQU4Hcjc8RLzSazI=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:
	 Content-Type; b=oE/5kF4hlgeMCQWcfzn/jS3cAGLaHo3fADz5SG5HsuUYJbSedRm9HumJhVncn2oqK5KpwMFjTYcShcvK8kASGLbhT18WXv8ffMmmptGT1zYmgiYVZ6qBzlI+eEWjmV4NqQW6vVyBa0P6wDDvNThG28lkP4aVzVQcNko3mhpLdaU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.161.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oo1-f80.google.com with SMTP id 006d021491bc7-698229e6b62so1074866eaf.3
        for <ocfs2-devel@lists.linux.dev>; Thu, 07 May 2026 03:52:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778151140; x=1778755940;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=qOeFBMeRVV5QS4igEQcMPe595PDIn6vrYZEqo+2jyb4=;
        b=kG9qcMchpDgjKPp3EkYoxkwM0URlcOoqB14gR7MiX/OyVd4L0pEt17B5fzbKogQZTu
         /0P+9GHO5uFKwE2OCmnZ/MybN8kK63x57j+IsOQZ0aUD/MfVkUYzj3A+sA3V9eC/Gcnl
         1tOS7SzQHGGLL+m5miz1qhrImphM2DNozVgJfr9x+S5pKHpJdamWJlKs0lHIGVtt0Pwf
         afLGS0Tpn0QXF9YC4ycfoVEXf4wjhBzCJ1RfdXrDGd2pzOE2MnqxUrunQ8mEi2/7pgmO
         mT0DJfJZxk6UHJ1x/Ij4di66KYjIqboe57GF34ClZOaMo6tIvzKhkOvZCxKSd18N/Eu8
         fQwA==
X-Forwarded-Encrypted: i=1; AFNElJ+KLzjA0yZ0b0k9MYnoa5mY/qoGEU5mauc6wwmi4LduLxjDex1sc80c/Zk0WvOZamm5BBDcDcjD7sCdKw==@lists.linux.dev
X-Gm-Message-State: AOJu0YxMBXuJZCadjWq+dJZPxy7TUmXjp3CkbANhnRR7qXCzCww7Iy0U
	5jnen9kbZTMZxY5GKePDdlOiUYo3QNfcXDgZqGQkPncYT6+Sx/Qge2bj4vA8wlZYI5KQHImisDa
	TGkIktgvAYtKzGmvX7+6d/TrPfb/U2h7lBG3fFGYTmJafjhaFlqp+ISdKjtg=
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a4a:e918:0:b0:696:573c:9f0b with SMTP id
 006d021491bc7-69998c9523cmr4238951eaf.14.1778151139819; Thu, 07 May 2026
 03:52:19 -0700 (PDT)
Date: Thu, 07 May 2026 03:52:19 -0700
In-Reply-To: <69725516.a00a0220.3ad28e.ea7a.GAE@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <69fc6ee3.050a0220.4a049.0005.GAE@google.com>
Subject: Re: [syzbot] [ocfs2?] possible deadlock in ocfs2_xattr_remove
From: syzbot <syzbot+7df4afa14aeda476a7a1@syzkaller.appspotmail.com>
To: jlbec@evilplan.org, joseph.qi@linux.alibaba.com, 
	linux-kernel@vger.kernel.org, mark@fasheh.com, ocfs2-devel@lists.linux.dev, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

syzbot has found a reproducer for the following issue on:

HEAD commit:    5862221fdded Merge tag 'parisc-for-7.1-rc3' of git://git.k..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=170d4dce580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=f2e8ebfec4636d32
dashboard link: https://syzkaller.appspot.com/bug?extid=7df4afa14aeda476a7a1
compiler:       Debian clang version 21.1.8 (++20251221033036+2078da43e25a-1~exp1~20251221153213.50), Debian LLD 21.1.8
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=10f2200e580000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=11ae9636580000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/0ada769d7944/disk-5862221f.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/c1c3b35a476a/vmlinux-5862221f.xz
kernel image: https://storage.googleapis.com/syzbot-assets/c21f5409f0eb/bzImage-5862221f.xz
mounted in repro #1: https://storage.googleapis.com/syzbot-assets/7e53d3c6583b/mount_0.gz
  fsck result: OK (log: https://syzkaller.appspot.com/x/fsck.log?x=130d4dce580000)
mounted in repro #2: https://storage.googleapis.com/syzbot-assets/d0514ae376c6/mount_2.gz
  fsck result: failed (log: https://syzkaller.appspot.com/x/fsck.log?x=11850950580000)

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+7df4afa14aeda476a7a1@syzkaller.appspotmail.com

======================================================
WARNING: possible circular locking dependency detected
syzkaller #0 Not tainted
------------------------------------------------------
syz.0.17/5891 is trying to acquire lock:
ffff88805bafad00 (&ocfs2_sysfile_lock_key[EXTENT_ALLOC_SYSTEM_INODE]){+.+.}-{4:4}, at: inode_lock include/linux/fs.h:1029 [inline]
ffff88805bafad00 (&ocfs2_sysfile_lock_key[EXTENT_ALLOC_SYSTEM_INODE]){+.+.}-{4:4}, at: ocfs2_xattr_free_block fs/ocfs2/xattr.c:2556 [inline]
ffff88805bafad00 (&ocfs2_sysfile_lock_key[EXTENT_ALLOC_SYSTEM_INODE]){+.+.}-{4:4}, at: ocfs2_xattr_remove+0x94e/0x1650 fs/ocfs2/xattr.c:2631

but task is already holding lock:
ffff88805bafbdc0 (&ocfs2_sysfile_lock_key[ORPHAN_DIR_SYSTEM_INODE]){+.+.}-{4:4}, at: inode_lock include/linux/fs.h:1029 [inline]
ffff88805bafbdc0 (&ocfs2_sysfile_lock_key[ORPHAN_DIR_SYSTEM_INODE]){+.+.}-{4:4}, at: ocfs2_wipe_inode fs/ocfs2/inode.c:854 [inline]
ffff88805bafbdc0 (&ocfs2_sysfile_lock_key[ORPHAN_DIR_SYSTEM_INODE]){+.+.}-{4:4}, at: ocfs2_delete_inode fs/ocfs2/inode.c:1157 [inline]
ffff88805bafbdc0 (&ocfs2_sysfile_lock_key[ORPHAN_DIR_SYSTEM_INODE]){+.+.}-{4:4}, at: ocfs2_evict_inode+0xe97/0x4390 fs/ocfs2/inode.c:1299

which lock already depends on the new lock.


the existing dependency chain (in reverse order) is:

-> #1 (&ocfs2_sysfile_lock_key[ORPHAN_DIR_SYSTEM_INODE]){+.+.}-{4:4}:
       down_write+0x3a/0x50 kernel/locking/rwsem.c:1625
       inode_lock include/linux/fs.h:1029 [inline]
       ocfs2_del_inode_from_orphan+0x12e/0x7a0 fs/ocfs2/namei.c:2728
       ocfs2_dio_end_io_write fs/ocfs2/aops.c:2379 [inline]
       ocfs2_dio_end_io+0xf9e/0x1370 fs/ocfs2/aops.c:2418
       dio_complete+0x25e/0x790 fs/direct-io.c:281
       __blockdev_direct_IO+0x2e12/0x3470 fs/direct-io.c:1303
       ocfs2_direct_IO+0x253/0x2c0 fs/ocfs2/aops.c:2455
       generic_file_direct_write+0x1dc/0x3e0 mm/filemap.c:4259
       __generic_file_write_iter+0x120/0x240 mm/filemap.c:4428
       ocfs2_file_write_iter+0x1666/0x1e70 fs/ocfs2/file.c:2476
       do_iter_readv_writev+0x62b/0x8d0 fs/read_write.c:-1
       vfs_writev+0x345/0x9a0 fs/read_write.c:1059
       do_pwritev fs/read_write.c:1155 [inline]
       __do_sys_pwritev2 fs/read_write.c:1213 [inline]
       __se_sys_pwritev2+0x187/0x2b0 fs/read_write.c:1204
       do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
       do_syscall_64+0x15f/0xf80 arch/x86/entry/syscall_64.c:94
       entry_SYSCALL_64_after_hwframe+0x77/0x7f

-> #0 (&ocfs2_sysfile_lock_key[EXTENT_ALLOC_SYSTEM_INODE]){+.+.}-{4:4}:
       check_prev_add kernel/locking/lockdep.c:3165 [inline]
       check_prevs_add kernel/locking/lockdep.c:3284 [inline]
       validate_chain kernel/locking/lockdep.c:3908 [inline]
       __lock_acquire+0x15a5/0x2cf0 kernel/locking/lockdep.c:5237
       lock_acquire+0x106/0x350 kernel/locking/lockdep.c:5868
       down_write+0x3a/0x50 kernel/locking/rwsem.c:1625
       inode_lock include/linux/fs.h:1029 [inline]
       ocfs2_xattr_free_block fs/ocfs2/xattr.c:2556 [inline]
       ocfs2_xattr_remove+0x94e/0x1650 fs/ocfs2/xattr.c:2631
       ocfs2_wipe_inode fs/ocfs2/inode.c:884 [inline]
       ocfs2_delete_inode fs/ocfs2/inode.c:1157 [inline]
       ocfs2_evict_inode+0x140b/0x4390 fs/ocfs2/inode.c:1299
       evict+0x61e/0xb10 fs/inode.c:841
       ocfs2_dentry_iput+0x24d/0x390 fs/ocfs2/dcache.c:407
       __dentry_kill+0x1a2/0x690 fs/dcache.c:718
       finish_dput+0xc9/0x480 fs/dcache.c:927
       __fput+0x6a3/0xa70 fs/file_table.c:518
       task_work_run+0x1d9/0x270 kernel/task_work.c:233
       resume_user_mode_work include/linux/resume_user_mode.h:50 [inline]
       __exit_to_user_mode_loop kernel/entry/common.c:67 [inline]
       exit_to_user_mode_loop+0xed/0x480 kernel/entry/common.c:98
       __exit_to_user_mode_prepare include/linux/irq-entry-common.h:207 [inline]
       syscall_exit_to_user_mode_prepare include/linux/irq-entry-common.h:238 [inline]
       syscall_exit_to_user_mode include/linux/entry-common.h:318 [inline]
       do_syscall_64+0x33e/0xf80 arch/x86/entry/syscall_64.c:100
       entry_SYSCALL_64_after_hwframe+0x77/0x7f

other info that might help us debug this:

 Possible unsafe locking scenario:

       CPU0                    CPU1
       ----                    ----
  lock(&ocfs2_sysfile_lock_key[ORPHAN_DIR_SYSTEM_INODE]);
                               lock(&ocfs2_sysfile_lock_key[EXTENT_ALLOC_SYSTEM_INODE]);
                               lock(&ocfs2_sysfile_lock_key[ORPHAN_DIR_SYSTEM_INODE]);
  lock(&ocfs2_sysfile_lock_key[EXTENT_ALLOC_SYSTEM_INODE]);

 *** DEADLOCK ***

2 locks held by syz.0.17/5891:
 #0: ffff88803907ce30 (&osb->nfs_sync_rwlock){.+.+}-{4:4}, at: ocfs2_nfs_sync_lock+0x106/0x270 fs/ocfs2/dlmglue.c:2875
 #1: ffff88805bafbdc0 (&ocfs2_sysfile_lock_key[ORPHAN_DIR_SYSTEM_INODE]){+.+.}-{4:4}, at: inode_lock include/linux/fs.h:1029 [inline]
 #1: ffff88805bafbdc0 (&ocfs2_sysfile_lock_key[ORPHAN_DIR_SYSTEM_INODE]){+.+.}-{4:4}, at: ocfs2_wipe_inode fs/ocfs2/inode.c:854 [inline]
 #1: ffff88805bafbdc0 (&ocfs2_sysfile_lock_key[ORPHAN_DIR_SYSTEM_INODE]){+.+.}-{4:4}, at: ocfs2_delete_inode fs/ocfs2/inode.c:1157 [inline]
 #1: ffff88805bafbdc0 (&ocfs2_sysfile_lock_key[ORPHAN_DIR_SYSTEM_INODE]){+.+.}-{4:4}, at: ocfs2_evict_inode+0xe97/0x4390 fs/ocfs2/inode.c:1299

stack backtrace:
CPU: 1 UID: 0 PID: 5891 Comm: syz.0.17 Not tainted syzkaller #0 PREEMPT_{RT,(full)} 
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
 down_write+0x3a/0x50 kernel/locking/rwsem.c:1625
 inode_lock include/linux/fs.h:1029 [inline]
 ocfs2_xattr_free_block fs/ocfs2/xattr.c:2556 [inline]
 ocfs2_xattr_remove+0x94e/0x1650 fs/ocfs2/xattr.c:2631
 ocfs2_wipe_inode fs/ocfs2/inode.c:884 [inline]
 ocfs2_delete_inode fs/ocfs2/inode.c:1157 [inline]
 ocfs2_evict_inode+0x140b/0x4390 fs/ocfs2/inode.c:1299
 evict+0x61e/0xb10 fs/inode.c:841
 ocfs2_dentry_iput+0x24d/0x390 fs/ocfs2/dcache.c:407
 __dentry_kill+0x1a2/0x690 fs/dcache.c:718
 finish_dput+0xc9/0x480 fs/dcache.c:927
 __fput+0x6a3/0xa70 fs/file_table.c:518
 task_work_run+0x1d9/0x270 kernel/task_work.c:233
 resume_user_mode_work include/linux/resume_user_mode.h:50 [inline]
 __exit_to_user_mode_loop kernel/entry/common.c:67 [inline]
 exit_to_user_mode_loop+0xed/0x480 kernel/entry/common.c:98
 __exit_to_user_mode_prepare include/linux/irq-entry-common.h:207 [inline]
 syscall_exit_to_user_mode_prepare include/linux/irq-entry-common.h:238 [inline]
 syscall_exit_to_user_mode include/linux/entry-common.h:318 [inline]
 do_syscall_64+0x33e/0xf80 arch/x86/entry/syscall_64.c:100
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f9bde88cdd9
Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007ffcabe6e818 EFLAGS: 00000246 ORIG_RAX: 00000000000001b4
RAX: 0000000000000000 RBX: 00007ffcabe6e900 RCX: 00007f9bde88cdd9
RDX: 0000000000000000 RSI: 000000000000001e RDI: 0000000000000003
RBP: 0000000000018ef8 R08: 0000000000000001 R09: 0000000000000000
R10: 0000001b32b20000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007f9bdeb05fac R14: 00007f9bdeb05fa8 R15: 00007f9bdeb05fa0
 </TASK>


---
If you want syzbot to run the reproducer, reply with:
#syz test: git://repo/address.git branch-or-commit-hash
If you attach or paste a git patch, syzbot will apply it before testing.
