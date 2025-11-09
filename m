Received: from mail-il1-f205.google.com (mail-il1-f205.google.com [209.85.166.205])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B212414A91
	for <ocfs2-devel@lists.linux.dev>; Sun,  9 Nov 2025 02:45:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.205
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762656334; cv=none; b=f9c7vl4V3sUhy9hmIp6xi1sHAGnUHLip+dCtqn0pR0CZ/m0oooWQ+LUZ7IN/PoFfkhlTIfNTIfHknhNLE2L2KZNhURTlLragsOuK4EFq9MOSA9VNdHQRjmePYkR+JXef/Ir909/vePQyOv+uEur5wjj47z8OvZRKVYO6cOjVaKg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762656334; c=relaxed/simple;
	bh=W9K8UuI+dTJUj8ft1jXazgsYHxNnCGMS8d5LTljUupk=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=NKe8LGIcpmqlq8AdapzRPYcJdFE6iP02G7L7A3J4SvK2yQ0tOR3s38n6hDgsZRNfG9ynDE/9hPDTdReDBatBweS2d4ynGT9yBXKrv/IlAR5eCZUz9lIKxJ3SjjEpmHHkhLfq0B77QqH+wss4d5ssuH8hdecI8CqI93UK1NvCIM0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.205
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f205.google.com with SMTP id e9e14a558f8ab-4330f62ef60so17981275ab.0
        for <ocfs2-devel@lists.linux.dev>; Sat, 08 Nov 2025 18:45:32 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762656332; x=1763261132;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=nQZkOge+eL+Ko0To4x+9l38MsLYNbaCXs3OAsC2wIvg=;
        b=aCjdhY1MqwfBPkesQWbM+m+ZD5E4b+Me3j/WoE8j+h0roSpAL4gSgsOIjwiAfPNnI+
         vGX/lYS+nye6F+NtYXj4WH7YZ9xAxhUYhYhe/Nr7KfL8EjklB6e8j4sX2QmmRISvRkYU
         R1sLJMeXrz7f3n5IUuFWJWyX6voAffDQ1xFvQOO0LLV6uOttrGSS9vGA0NYTPt8zxjwT
         TxlrckZ/1WCGgtUzVTjJpqhpg/YTByz31HxLVXXPUFYFLdSG/HlJ95j5GK6wHeOkBRgv
         Gyw8ANegl6G9gXnIBkI3Q7/v2Zf168xxuGzd2ADf7zuYs36nz8CK49kvy1satpVBkgbb
         o/UA==
X-Forwarded-Encrypted: i=1; AJvYcCXcGmQ+M13V0iJLCl6aQJJS7yRjAgrV+POkgpoU6ikKqAaFaJndDEcoL5svsEIvXND+ZqDEhe6TJr1JXw==@lists.linux.dev
X-Gm-Message-State: AOJu0YymkqWSjNHeI+MESUq+foEs5Sae89QuxA7lu16HJvBFy5hxZV93
	WrOVBJNvd2a8V5kNtkG1WCIH9lbVlqrQaE0Qsm2tP866q9/ae0M5+aVNmpreRLM9JDciw7/Jq1f
	xDfT3Uj/nbBxySw2XxqNYFmYUmSIE60U/jqbMH46VgMSfd1D4ghLeKgun6k0=
X-Google-Smtp-Source: AGHT+IHHPL3jqQMpF+WDdxfPCqrE6uNE9fYSmS+9D0eM70btwM4k8bsndzCBoGmIgGL4IclHG1OvtsjYsXl7mufVfMHuul81OcUz
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a92:cbc5:0:b0:433:77ee:1e3c with SMTP id
 e9e14a558f8ab-43377ee1f62mr21329945ab.2.1762656331893; Sat, 08 Nov 2025
 18:45:31 -0800 (PST)
Date: Sat, 08 Nov 2025 18:45:31 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6910004b.a70a0220.22f260.0095.GAE@google.com>
Subject: [syzbot] [ocfs2?] possible deadlock in ocfs2_remove_btree_range (2)
From: syzbot <syzbot+d83fe3748c366683cd55@syzkaller.appspotmail.com>
To: jlbec@evilplan.org, joseph.qi@linux.alibaba.com, 
	linux-kernel@vger.kernel.org, mark@fasheh.com, ocfs2-devel@lists.linux.dev, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    dcb6fa37fd7b Linux 6.18-rc3
git tree:       git://git.kernel.org/pub/scm/linux/kernel/git/arm64/linux.git for-kernelci
console output: https://syzkaller.appspot.com/x/log.txt?x=12859812580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=b8b659f0cab27b22
dashboard link: https://syzkaller.appspot.com/bug?extid=d83fe3748c366683cd55
compiler:       Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~exp1~20250708183702.136), Debian LLD 20.1.8
userspace arch: arm64

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/ae6bec0d0398/disk-dcb6fa37.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/dcc732da66c3/vmlinux-dcb6fa37.xz
kernel image: https://storage.googleapis.com/syzbot-assets/301d1bbdecc2/Image-dcb6fa37.gz.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+d83fe3748c366683cd55@syzkaller.appspotmail.com

======================================================
WARNING: possible circular locking dependency detected
syzkaller #0 Not tainted
------------------------------------------------------
syz.0.278/8010 is trying to acquire lock:
ffff0000d6dbc610 (sb_internal#3){.+.+}-{0:0}, at: ocfs2_remove_btree_range+0x67c/0x11cc fs/ocfs2/alloc.c:5760

but task is already holding lock:
ffff0000f676a640 (&ocfs2_sysfile_lock_key[TRUNCATE_LOG_SYSTEM_INODE]){+.+.}-{4:4}, at: inode_lock include/linux/fs.h:980 [inline]
ffff0000f676a640 (&ocfs2_sysfile_lock_key[TRUNCATE_LOG_SYSTEM_INODE]){+.+.}-{4:4}, at: ocfs2_remove_btree_range+0x524/0x11cc fs/ocfs2/alloc.c:5750

which lock already depends on the new lock.


the existing dependency chain (in reverse order) is:

-> #4 (&ocfs2_sysfile_lock_key[TRUNCATE_LOG_SYSTEM_INODE]){+.+.}-{4:4}:
       down_write+0x50/0xc0 kernel/locking/rwsem.c:1590
       inode_lock include/linux/fs.h:980 [inline]
       ocfs2_xattr_set+0x8a8/0xe9c fs/ocfs2/xattr.c:3622
       ocfs2_xattr_trusted_set+0x4c/0x64 fs/ocfs2/xattr.c:7336
       __vfs_setxattr+0x3d8/0x400 fs/xattr.c:200
       __vfs_setxattr_noperm+0x120/0x5c4 fs/xattr.c:234
       __vfs_setxattr_locked+0x1ec/0x218 fs/xattr.c:295
       vfs_setxattr+0x158/0x2ac fs/xattr.c:321
       ovl_do_setxattr fs/overlayfs/overlayfs.h:317 [inline]
       ovl_setxattr fs/overlayfs/overlayfs.h:329 [inline]
       ovl_make_workdir fs/overlayfs/super.c:725 [inline]
       ovl_get_workdir+0x9d4/0x1270 fs/overlayfs/super.c:837
       ovl_fill_super+0x10d8/0x3118 fs/overlayfs/super.c:1468
       vfs_get_super fs/super.c:1324 [inline]
       get_tree_nodev+0xb4/0x144 fs/super.c:1343
       ovl_get_tree+0x28/0x38 fs/overlayfs/params.c:708
       vfs_get_tree+0x90/0x28c fs/super.c:1751
       fc_mount fs/namespace.c:1208 [inline]
       do_new_mount_fc fs/namespace.c:3651 [inline]
       do_new_mount+0x284/0x944 fs/namespace.c:3727
       path_mount+0x5b4/0xdfc fs/namespace.c:4037
       do_mount fs/namespace.c:4050 [inline]
       __do_sys_mount fs/namespace.c:4238 [inline]
       __se_sys_mount fs/namespace.c:4215 [inline]
       __arm64_sys_mount+0x3e8/0x468 fs/namespace.c:4215
       __invoke_syscall arch/arm64/kernel/syscall.c:35 [inline]
       invoke_syscall+0x98/0x254 arch/arm64/kernel/syscall.c:49
       el0_svc_common+0x130/0x23c arch/arm64/kernel/syscall.c:132
       do_el0_svc+0x48/0x58 arch/arm64/kernel/syscall.c:151
       el0_svc+0x5c/0x254 arch/arm64/kernel/entry-common.c:746
       el0t_64_sync_handler+0x84/0x12c arch/arm64/kernel/entry-common.c:765
       el0t_64_sync+0x198/0x19c arch/arm64/kernel/entry.S:596

-> #3 (&oi->ip_xattr_sem){++++}-{4:4}:
       down_write+0x50/0xc0 kernel/locking/rwsem.c:1590
       ocfs2_xattr_set_handle+0x2a8/0x5e4 fs/ocfs2/xattr.c:3501
       ocfs2_init_security_set+0xb4/0xd8 fs/ocfs2/xattr.c:7307
       ocfs2_mknod+0x106c/0x1cf0 fs/ocfs2/namei.c:422
       ocfs2_create+0x190/0x474 fs/ocfs2/namei.c:676
       lookup_open fs/namei.c:3796 [inline]
       open_last_lookups fs/namei.c:3895 [inline]
       path_openat+0x12d8/0x2c40 fs/namei.c:4131
       do_filp_open+0x18c/0x36c fs/namei.c:4161
       do_sys_openat2+0x11c/0x1b4 fs/open.c:1437
       do_sys_open fs/open.c:1452 [inline]
       __do_sys_openat fs/open.c:1468 [inline]
       __se_sys_openat fs/open.c:1463 [inline]
       __arm64_sys_openat+0x120/0x158 fs/open.c:1463
       __invoke_syscall arch/arm64/kernel/syscall.c:35 [inline]
       invoke_syscall+0x98/0x254 arch/arm64/kernel/syscall.c:49
       el0_svc_common+0x130/0x23c arch/arm64/kernel/syscall.c:132
       do_el0_svc+0x48/0x58 arch/arm64/kernel/syscall.c:151
       el0_svc+0x5c/0x254 arch/arm64/kernel/entry-common.c:746
       el0t_64_sync_handler+0x84/0x12c arch/arm64/kernel/entry-common.c:765
       el0t_64_sync+0x198/0x19c arch/arm64/kernel/entry.S:596

-> #2 (jbd2_handle){++++}-{0:0}:
       start_this_handle+0xe74/0x10dc fs/jbd2/transaction.c:444
       jbd2__journal_start+0x288/0x51c fs/jbd2/transaction.c:501
       jbd2_journal_start+0x3c/0x4c fs/jbd2/transaction.c:540
       ocfs2_start_trans+0x368/0x6b0 fs/ocfs2/journal.c:374
       ocfs2_block_group_alloc fs/ocfs2/suballoc.c:685 [inline]
       ocfs2_reserve_suballoc_bits+0x630/0x3b9c fs/ocfs2/suballoc.c:834
       ocfs2_reserve_new_metadata_blocks+0x368/0x810 fs/ocfs2/suballoc.c:984
       ocfs2_mknod+0xbd8/0x1cf0 fs/ocfs2/namei.c:350
       ocfs2_create+0x190/0x474 fs/ocfs2/namei.c:676
       lookup_open fs/namei.c:3796 [inline]
       open_last_lookups fs/namei.c:3895 [inline]
       path_openat+0x12d8/0x2c40 fs/namei.c:4131
       do_filp_open+0x18c/0x36c fs/namei.c:4161
       do_sys_openat2+0x11c/0x1b4 fs/open.c:1437
       do_sys_open fs/open.c:1452 [inline]
       __do_sys_openat fs/open.c:1468 [inline]
       __se_sys_openat fs/open.c:1463 [inline]
       __arm64_sys_openat+0x120/0x158 fs/open.c:1463
       __invoke_syscall arch/arm64/kernel/syscall.c:35 [inline]
       invoke_syscall+0x98/0x254 arch/arm64/kernel/syscall.c:49
       el0_svc_common+0x130/0x23c arch/arm64/kernel/syscall.c:132
       do_el0_svc+0x48/0x58 arch/arm64/kernel/syscall.c:151
       el0_svc+0x5c/0x254 arch/arm64/kernel/entry-common.c:746
       el0t_64_sync_handler+0x84/0x12c arch/arm64/kernel/entry-common.c:765
       el0t_64_sync+0x198/0x19c arch/arm64/kernel/entry.S:596

-> #1 (&journal->j_trans_barrier){.+.+}-{4:4}:
       down_read+0x58/0x2f8 kernel/locking/rwsem.c:1537
       ocfs2_start_trans+0x35c/0x6b0 fs/ocfs2/journal.c:372
       ocfs2_block_group_alloc fs/ocfs2/suballoc.c:685 [inline]
       ocfs2_reserve_suballoc_bits+0x630/0x3b9c fs/ocfs2/suballoc.c:834
       ocfs2_reserve_new_metadata_blocks+0x368/0x810 fs/ocfs2/suballoc.c:984
       ocfs2_mknod+0xbd8/0x1cf0 fs/ocfs2/namei.c:350
       ocfs2_create+0x190/0x474 fs/ocfs2/namei.c:676
       lookup_open fs/namei.c:3796 [inline]
       open_last_lookups fs/namei.c:3895 [inline]
       path_openat+0x12d8/0x2c40 fs/namei.c:4131
       do_filp_open+0x18c/0x36c fs/namei.c:4161
       do_sys_openat2+0x11c/0x1b4 fs/open.c:1437
       do_sys_open fs/open.c:1452 [inline]
       __do_sys_openat fs/open.c:1468 [inline]
       __se_sys_openat fs/open.c:1463 [inline]
       __arm64_sys_openat+0x120/0x158 fs/open.c:1463
       __invoke_syscall arch/arm64/kernel/syscall.c:35 [inline]
       invoke_syscall+0x98/0x254 arch/arm64/kernel/syscall.c:49
       el0_svc_common+0x130/0x23c arch/arm64/kernel/syscall.c:132
       do_el0_svc+0x48/0x58 arch/arm64/kernel/syscall.c:151
       el0_svc+0x5c/0x254 arch/arm64/kernel/entry-common.c:746
       el0t_64_sync_handler+0x84/0x12c arch/arm64/kernel/entry-common.c:765
       el0t_64_sync+0x198/0x19c arch/arm64/kernel/entry.S:596

-> #0 (sb_internal#3){.+.+}-{0:0}:
       check_prev_add kernel/locking/lockdep.c:3165 [inline]
       check_prevs_add kernel/locking/lockdep.c:3284 [inline]
       validate_chain kernel/locking/lockdep.c:3908 [inline]
       __lock_acquire+0x1774/0x30a4 kernel/locking/lockdep.c:5237
       lock_acquire+0x14c/0x2e0 kernel/locking/lockdep.c:5868
       percpu_down_read_internal include/linux/percpu-rwsem.h:53 [inline]
       percpu_down_read_freezable include/linux/percpu-rwsem.h:83 [inline]
       __sb_start_write include/linux/fs.h:1916 [inline]
       sb_start_intwrite include/linux/fs.h:2099 [inline]
       ocfs2_start_trans+0x1f4/0x6b0 fs/ocfs2/journal.c:370
       ocfs2_remove_btree_range+0x67c/0x11cc fs/ocfs2/alloc.c:5760
       ocfs2_remove_inode_range+0xbc0/0x2174 fs/ocfs2/file.c:1907
       ocfs2_reflink_remap_extent fs/ocfs2/refcounttree.c:4534 [inline]
       ocfs2_reflink_remap_blocks+0x950/0x14b0 fs/ocfs2/refcounttree.c:4681
       ocfs2_remap_file_range+0x3fc/0x638 fs/ocfs2/file.c:2740
       vfs_copy_file_range+0xbc4/0x10f8 fs/read_write.c:1598
       __do_sys_copy_file_range fs/read_write.c:1681 [inline]
       __se_sys_copy_file_range fs/read_write.c:1648 [inline]
       __arm64_sys_copy_file_range+0x308/0x5d4 fs/read_write.c:1648
       __invoke_syscall arch/arm64/kernel/syscall.c:35 [inline]
       invoke_syscall+0x98/0x254 arch/arm64/kernel/syscall.c:49
       el0_svc_common+0x130/0x23c arch/arm64/kernel/syscall.c:132
       do_el0_svc+0x48/0x58 arch/arm64/kernel/syscall.c:151
       el0_svc+0x5c/0x254 arch/arm64/kernel/entry-common.c:746
       el0t_64_sync_handler+0x84/0x12c arch/arm64/kernel/entry-common.c:765
       el0t_64_sync+0x198/0x19c arch/arm64/kernel/entry.S:596

other info that might help us debug this:

Chain exists of:
  sb_internal#3 --> &oi->ip_xattr_sem --> &ocfs2_sysfile_lock_key[TRUNCATE_LOG_SYSTEM_INODE]

 Possible unsafe locking scenario:

       CPU0                    CPU1
       ----                    ----
  lock(&ocfs2_sysfile_lock_key[TRUNCATE_LOG_SYSTEM_INODE]);
                               lock(&oi->ip_xattr_sem);
                               lock(&ocfs2_sysfile_lock_key[TRUNCATE_LOG_SYSTEM_INODE]);
  rlock(sb_internal#3);

 *** DEADLOCK ***

7 locks held by syz.0.278/8010:
 #0: ffff0000d6dbc420 (sb_writers#15){.+.+}-{0:0}, at: file_start_write include/linux/fs.h:3111 [inline]
 #0: ffff0000d6dbc420 (sb_writers#15){.+.+}-{0:0}, at: vfs_copy_file_range+0x868/0x10f8 fs/read_write.c:1586
 #1: ffff0000f66289c0 (&sb->s_type->i_mutex_key#25){++++}-{4:4}, at: inode_lock include/linux/fs.h:980 [inline]
 #1: ffff0000f66289c0 (&sb->s_type->i_mutex_key#25){++++}-{4:4}, at: lock_two_nondirectories+0xc4/0x150 fs/inode.c:1232
 #2: ffff0000f81709c0 (&sb->s_type->i_mutex_key#25/4){+.+.}-{4:4}, at: inode_lock_nested include/linux/fs.h:1025 [inline]
 #2: ffff0000f81709c0 (&sb->s_type->i_mutex_key#25/4){+.+.}-{4:4}, at: lock_two_nondirectories+0xf0/0x150 fs/inode.c:1234
 #3: ffff0000f8170660 (&ocfs2_file_ip_alloc_sem_key){++++}-{4:4}, at: ocfs2_remap_file_range+0x344/0x638 fs/ocfs2/file.c:2730
 #4: ffff0000f6628660 (&ocfs2_file_ip_alloc_sem_key/1){+.+.}-{4:4}, at: ocfs2_remap_file_range+0x35c/0x638 fs/ocfs2/file.c:2732
 #5: ffff0000d0555098 (&new->rf_sem){+.+.}-{4:4}, at: __ocfs2_lock_refcount_tree fs/ocfs2/refcounttree.c:428 [inline]
 #5: ffff0000d0555098 (&new->rf_sem){+.+.}-{4:4}, at: ocfs2_lock_refcount_tree+0x188/0x924 fs/ocfs2/refcounttree.c:463
 #6: ffff0000f676a640 (&ocfs2_sysfile_lock_key[TRUNCATE_LOG_SYSTEM_INODE]){+.+.}-{4:4}, at: inode_lock include/linux/fs.h:980 [inline]
 #6: ffff0000f676a640 (&ocfs2_sysfile_lock_key[TRUNCATE_LOG_SYSTEM_INODE]){+.+.}-{4:4}, at: ocfs2_remove_btree_range+0x524/0x11cc fs/ocfs2/alloc.c:5750

stack backtrace:
CPU: 0 UID: 0 PID: 8010 Comm: syz.0.278 Not tainted syzkaller #0 PREEMPT 
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 10/03/2025
Call trace:
 show_stack+0x2c/0x3c arch/arm64/kernel/stacktrace.c:499 (C)
 __dump_stack+0x30/0x40 lib/dump_stack.c:94
 dump_stack_lvl+0xd8/0x12c lib/dump_stack.c:120
 dump_stack+0x1c/0x28 lib/dump_stack.c:129
 print_circular_bug+0x324/0x32c kernel/locking/lockdep.c:2043
 check_noncircular+0x154/0x174 kernel/locking/lockdep.c:2175
 check_prev_add kernel/locking/lockdep.c:3165 [inline]
 check_prevs_add kernel/locking/lockdep.c:3284 [inline]
 validate_chain kernel/locking/lockdep.c:3908 [inline]
 __lock_acquire+0x1774/0x30a4 kernel/locking/lockdep.c:5237
 lock_acquire+0x14c/0x2e0 kernel/locking/lockdep.c:5868
 percpu_down_read_internal include/linux/percpu-rwsem.h:53 [inline]
 percpu_down_read_freezable include/linux/percpu-rwsem.h:83 [inline]
 __sb_start_write include/linux/fs.h:1916 [inline]
 sb_start_intwrite include/linux/fs.h:2099 [inline]
 ocfs2_start_trans+0x1f4/0x6b0 fs/ocfs2/journal.c:370
 ocfs2_remove_btree_range+0x67c/0x11cc fs/ocfs2/alloc.c:5760
 ocfs2_remove_inode_range+0xbc0/0x2174 fs/ocfs2/file.c:1907
 ocfs2_reflink_remap_extent fs/ocfs2/refcounttree.c:4534 [inline]
 ocfs2_reflink_remap_blocks+0x950/0x14b0 fs/ocfs2/refcounttree.c:4681
 ocfs2_remap_file_range+0x3fc/0x638 fs/ocfs2/file.c:2740
 vfs_copy_file_range+0xbc4/0x10f8 fs/read_write.c:1598
 __do_sys_copy_file_range fs/read_write.c:1681 [inline]
 __se_sys_copy_file_range fs/read_write.c:1648 [inline]
 __arm64_sys_copy_file_range+0x308/0x5d4 fs/read_write.c:1648
 __invoke_syscall arch/arm64/kernel/syscall.c:35 [inline]
 invoke_syscall+0x98/0x254 arch/arm64/kernel/syscall.c:49
 el0_svc_common+0x130/0x23c arch/arm64/kernel/syscall.c:132
 do_el0_svc+0x48/0x58 arch/arm64/kernel/syscall.c:151
 el0_svc+0x5c/0x254 arch/arm64/kernel/entry-common.c:746
 el0t_64_sync_handler+0x84/0x12c arch/arm64/kernel/entry-common.c:765
 el0t_64_sync+0x198/0x19c arch/arm64/kernel/entry.S:596


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
