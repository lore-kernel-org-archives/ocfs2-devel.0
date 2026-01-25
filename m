Received: from mail-oo1-f80.google.com (mail-oo1-f80.google.com [209.85.161.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94F77301471
	for <ocfs2-devel@lists.linux.dev>; Sun, 25 Jan 2026 20:20:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769372435; cv=none; b=e3dsCUdvAKcHicjacAdvCmSmAFnlBoK8r/vgvCducD1XaOUgJsZR+/VYYxRpv1BwG/sejx8FvFgYjAhWZX0hGLEo0Zi1spmSQbKMnpfpQQMzBoi3U64xoeHMjYe7gHkbCAvHyea2Cfwfs1cpEY0c5fdYSxERnx2aTLOfIs/1LZA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769372435; c=relaxed/simple;
	bh=HPg+NR7q0IFDdg2ecsx98lE4bUzXXggL8Re9+huZX5Q=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=WpH9PAUU09xdwbmI0w1qcWGbvqqKci0O8BXy3NnGCN0c54KwM6fIcRhEhXT7Oc3f/dR9oj9AvzbXXAjn0u0N5YL31nDUEsVGxQzMQZ0/oAglWXMUZy2/MKelTrwaWYKSEM0Z/AjiTDjr+C3CKpqKsk4jbQpo5e3Ze49oteO17+o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.161.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oo1-f80.google.com with SMTP id 006d021491bc7-662c4cee18fso9378549eaf.0
        for <ocfs2-devel@lists.linux.dev>; Sun, 25 Jan 2026 12:20:33 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769372432; x=1769977232;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=YjbTfUdkQwsSRwb9Gy+TOWjjAJc3Y5pGGI/4TtUsNHg=;
        b=bJdQE8hR1yvLo9EVH+2ehi5G5Z6HAg/StgCn+bMgz8Ypk3iFWoFVc/M/2C8aXToVvH
         5HQoM5bG1AntVQ7BhMdrT0OL0VQ9lLo8Al8kkf5Ya61Dk84KvUzLfit6LfTPRjU5dxvA
         niTkbwaHxQvtlqNtn6+OB4PXs1n+/VfuUc2SOAsfBoJ9AsjSUeJMxAKh+KssRydR3/zf
         niKX+/DygZF1dx/LU/LiYPq6Vpnxq1bInHKcRPAgC/gry5C12xTHnv6d82lYmW1TSMwb
         YR3X2SRQZrHwLXLkVAYtr0WuJveN/0LPIoI/ZqcLZMmbdIJZyA6L7vPhUWOWePcEilhJ
         T88w==
X-Forwarded-Encrypted: i=1; AJvYcCXzZYTiaYQ4lxivHxm+AXzq2AV3MofSTgs2Lw6jFlPbXvAJyg/YlR5nQXKqNRVXmwcIZB43So13LlObIQ==@lists.linux.dev
X-Gm-Message-State: AOJu0YwuZw1xtLWq3crbD3SZebKfIZC1LuRPKiwadHd1nuDM+EWsqQ+s
	SHGmHFw9KKs0Mdb/00BuoXWaRhcTUy9KR1iccmJYxi5DS49HkS86hv1BlFFxk9gm+MfUFTLV+Ai
	a/p5VRCtvXm3LCecmOQrPKPtL4AOJ4hLoxyY7ymLFGdxnnpnJsucsdLKGqxo=
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6820:4b04:b0:659:9a49:8f34 with SMTP id
 006d021491bc7-662e046bebbmr1209226eaf.69.1769372432635; Sun, 25 Jan 2026
 12:20:32 -0800 (PST)
Date: Sun, 25 Jan 2026 12:20:32 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <69767b10.a00a0220.33ccc7.0029.GAE@google.com>
Subject: [syzbot] [ocfs2?] possible deadlock in __ocfs2_write_remove_suid (2)
From: syzbot <syzbot+599b88d7230f19850fe5@syzkaller.appspotmail.com>
To: jlbec@evilplan.org, joseph.qi@linux.alibaba.com, 
	linux-kernel@vger.kernel.org, mark@fasheh.com, ocfs2-devel@lists.linux.dev, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    59e4d31a0470 Merge branches 'for-next/core' and 'for-next/..
git tree:       git://git.kernel.org/pub/scm/linux/kernel/git/arm64/linux.git for-kernelci
console output: https://syzkaller.appspot.com/x/log.txt?x=159c1e3a580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=8a8594efdc14f07a
dashboard link: https://syzkaller.appspot.com/bug?extid=599b88d7230f19850fe5
compiler:       Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~exp1~20250708183702.136), Debian LLD 20.1.8
userspace arch: arm64

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/746a1d5c4188/disk-59e4d31a.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/2eefade79f10/vmlinux-59e4d31a.xz
kernel image: https://storage.googleapis.com/syzbot-assets/140624ef24ed/Image-59e4d31a.gz.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+599b88d7230f19850fe5@syzkaller.appspotmail.com

ocfs2: Mounting device (7,5) on (node local, slot 0) with ordered data mode.
======================================================
WARNING: possible circular locking dependency detected
syzkaller #0 Tainted: G             L     
------------------------------------------------------
syz.5.322/8565 is trying to acquire lock:
ffff0000f98c0610 (sb_internal#5){.+.+}-{0:0}, at: __ocfs2_write_remove_suid+0x194/0x730 fs/ocfs2/file.c:1391

but task is already holding lock:
ffff0000fe99b120 (&ocfs2_file_ip_alloc_sem_key){++++}-{4:4}, at: ocfs2_inode_lock_for_extent_tree+0xf0/0x1cc fs/ocfs2/file.c:2216

which lock already depends on the new lock.


the existing dependency chain (in reverse order) is:

-> #3 (&ocfs2_file_ip_alloc_sem_key){++++}-{4:4}:
       down_write+0x50/0xc0 kernel/locking/rwsem.c:1590
       ocfs2_try_remove_refcount_tree+0xb4/0x2d8 fs/ocfs2/refcounttree.c:933
       ocfs2_xattr_set+0x460/0xe9c fs/ocfs2/xattr.c:3699
       ocfs2_set_acl+0x574/0x628 fs/ocfs2/acl.c:255
       ocfs2_iop_set_acl+0x190/0x25c fs/ocfs2/acl.c:287
       set_posix_acl fs/posix_acl.c:954 [inline]
       vfs_set_acl+0x704/0x96c fs/posix_acl.c:1133
       do_set_acl+0xc8/0x1a8 fs/posix_acl.c:1278
       do_setxattr fs/xattr.c:633 [inline]
       filename_setxattr+0x268/0x4f8 fs/xattr.c:665
       path_setxattrat+0x2e8/0x320 fs/xattr.c:713
       __do_sys_setxattr fs/xattr.c:747 [inline]
       __se_sys_setxattr fs/xattr.c:743 [inline]
       __arm64_sys_setxattr+0xc0/0xdc fs/xattr.c:743
       __invoke_syscall arch/arm64/kernel/syscall.c:35 [inline]
       invoke_syscall+0x98/0x254 arch/arm64/kernel/syscall.c:49
       el0_svc_common+0xe8/0x23c arch/arm64/kernel/syscall.c:132
       do_el0_svc+0x48/0x58 arch/arm64/kernel/syscall.c:151
       el0_svc+0x5c/0x26c arch/arm64/kernel/entry-common.c:724
       el0t_64_sync_handler+0x84/0x12c arch/arm64/kernel/entry-common.c:743
       el0t_64_sync+0x198/0x19c arch/arm64/kernel/entry.S:596

-> #2 (&oi->ip_xattr_sem){++++}-{4:4}:
       down_read+0x58/0x308 kernel/locking/rwsem.c:1537
       ocfs2_init_acl+0x258/0x63c fs/ocfs2/acl.c:367
       ocfs2_mknod+0x1008/0x1cf0 fs/ocfs2/namei.c:414
       ocfs2_create+0x178/0x474 fs/ocfs2/namei.c:677
       lookup_open fs/namei.c:4440 [inline]
       open_last_lookups fs/namei.c:4540 [inline]
       path_openat+0x143c/0x3114 fs/namei.c:4784
       do_filp_open+0x18c/0x36c fs/namei.c:4814
       do_sys_openat2+0x11c/0x1f0 fs/open.c:1430
       do_sys_open fs/open.c:1436 [inline]
       __do_sys_openat fs/open.c:1452 [inline]
       __se_sys_openat fs/open.c:1447 [inline]
       __arm64_sys_openat+0x120/0x158 fs/open.c:1447
       __invoke_syscall arch/arm64/kernel/syscall.c:35 [inline]
       invoke_syscall+0x98/0x254 arch/arm64/kernel/syscall.c:49
       el0_svc_common+0xe8/0x23c arch/arm64/kernel/syscall.c:132
       do_el0_svc+0x48/0x58 arch/arm64/kernel/syscall.c:151
       el0_svc+0x5c/0x26c arch/arm64/kernel/entry-common.c:724
       el0t_64_sync_handler+0x84/0x12c arch/arm64/kernel/entry-common.c:743
       el0t_64_sync+0x198/0x19c arch/arm64/kernel/entry.S:596

-> #1 (&journal->j_trans_barrier){.+.+}-{4:4}:
       down_read+0x58/0x308 kernel/locking/rwsem.c:1537
       ocfs2_start_trans+0x35c/0x6b0 fs/ocfs2/journal.c:372
       ocfs2_modify_bh+0xe4/0x43c fs/ocfs2/quota_local.c:101
       ocfs2_local_read_info+0x104c/0x1364 fs/ocfs2/quota_local.c:767
       dquot_load_quota_sb+0x6bc/0xa90 fs/quota/dquot.c:2462
       dquot_load_quota_inode+0x274/0x4e4 fs/quota/dquot.c:2499
       ocfs2_enable_quotas+0x17c/0x3b4 fs/ocfs2/super.c:930
       ocfs2_fill_super+0x3fe4/0x532c fs/ocfs2/super.c:1140
       get_tree_bdev_flags+0x360/0x414 fs/super.c:1691
       get_tree_bdev+0x2c/0x3c fs/super.c:1714
       ocfs2_get_tree+0x28/0x38 fs/ocfs2/super.c:1184
       vfs_get_tree+0x90/0x28c fs/super.c:1751
       fc_mount fs/namespace.c:1199 [inline]
       do_new_mount_fc fs/namespace.c:3636 [inline]
       do_new_mount+0x284/0x944 fs/namespace.c:3712
       path_mount+0x5b4/0xdfc fs/namespace.c:4022
       do_mount fs/namespace.c:4035 [inline]
       __do_sys_mount fs/namespace.c:4224 [inline]
       __se_sys_mount fs/namespace.c:4201 [inline]
       __arm64_sys_mount+0x3e8/0x468 fs/namespace.c:4201
       __invoke_syscall arch/arm64/kernel/syscall.c:35 [inline]
       invoke_syscall+0x98/0x254 arch/arm64/kernel/syscall.c:49
       el0_svc_common+0xe8/0x23c arch/arm64/kernel/syscall.c:132
       do_el0_svc+0x48/0x58 arch/arm64/kernel/syscall.c:151
       el0_svc+0x5c/0x26c arch/arm64/kernel/entry-common.c:724
       el0t_64_sync_handler+0x84/0x12c arch/arm64/kernel/entry-common.c:743
       el0t_64_sync+0x198/0x19c arch/arm64/kernel/entry.S:596

-> #0 (sb_internal#5){.+.+}-{0:0}:
       check_prev_add kernel/locking/lockdep.c:3165 [inline]
       check_prevs_add kernel/locking/lockdep.c:3284 [inline]
       validate_chain kernel/locking/lockdep.c:3908 [inline]
       __lock_acquire+0x1774/0x30a4 kernel/locking/lockdep.c:5237
       lock_acquire+0x140/0x2e0 kernel/locking/lockdep.c:5868
       percpu_down_read_internal include/linux/percpu-rwsem.h:53 [inline]
       percpu_down_read_freezable include/linux/percpu-rwsem.h:83 [inline]
       __sb_start_write include/linux/fs/super.h:19 [inline]
       sb_start_intwrite include/linux/fs/super.h:177 [inline]
       ocfs2_start_trans+0x1f4/0x6b0 fs/ocfs2/journal.c:370
       __ocfs2_write_remove_suid+0x194/0x730 fs/ocfs2/file.c:1391
       ocfs2_write_remove_suid fs/ocfs2/file.c:1432 [inline]
       ocfs2_prepare_inode_for_write fs/ocfs2/file.c:2317 [inline]
       ocfs2_file_write_iter+0x868/0x1b8c fs/ocfs2/file.c:2457
       new_sync_write fs/read_write.c:593 [inline]
       vfs_write+0x540/0xa3c fs/read_write.c:686
       ksys_pwrite64 fs/read_write.c:793 [inline]
       __do_sys_pwrite64 fs/read_write.c:801 [inline]
       __se_sys_pwrite64 fs/read_write.c:798 [inline]
       __arm64_sys_pwrite64+0x170/0x208 fs/read_write.c:798
       __invoke_syscall arch/arm64/kernel/syscall.c:35 [inline]
       invoke_syscall+0x98/0x254 arch/arm64/kernel/syscall.c:49
       el0_svc_common+0xe8/0x23c arch/arm64/kernel/syscall.c:132
       do_el0_svc+0x48/0x58 arch/arm64/kernel/syscall.c:151
       el0_svc+0x5c/0x26c arch/arm64/kernel/entry-common.c:724
       el0t_64_sync_handler+0x84/0x12c arch/arm64/kernel/entry-common.c:743
       el0t_64_sync+0x198/0x19c arch/arm64/kernel/entry.S:596

other info that might help us debug this:

Chain exists of:
  sb_internal#5 --> &oi->ip_xattr_sem --> &ocfs2_file_ip_alloc_sem_key

 Possible unsafe locking scenario:

       CPU0                    CPU1
       ----                    ----
  rlock(&ocfs2_file_ip_alloc_sem_key);
                               lock(&oi->ip_xattr_sem);
                               lock(&ocfs2_file_ip_alloc_sem_key);
  rlock(sb_internal#5);

 *** DEADLOCK ***

3 locks held by syz.5.322/8565:
 #0: ffff0000f98c0420 (sb_writers#21){.+.+}-{0:0}, at: file_start_write include/linux/fs.h:2681 [inline]
 #0: ffff0000f98c0420 (sb_writers#21){.+.+}-{0:0}, at: vfs_write+0x24c/0xa3c fs/read_write.c:682
 #1: ffff0000fe99b480 (&sb->s_type->i_mutex_key#33){+.+.}-{4:4}, at: inode_lock include/linux/fs.h:1027 [inline]
 #1: ffff0000fe99b480 (&sb->s_type->i_mutex_key#33){+.+.}-{4:4}, at: ocfs2_file_write_iter+0x388/0x1b8c fs/ocfs2/file.c:2405
 #2: ffff0000fe99b120 (&ocfs2_file_ip_alloc_sem_key){++++}-{4:4}, at: ocfs2_inode_lock_for_extent_tree+0xf0/0x1cc fs/ocfs2/file.c:2216

stack backtrace:
CPU: 0 UID: 0 PID: 8565 Comm: syz.5.322 Tainted: G             L      syzkaller #0 PREEMPT 
Tainted: [L]=SOFTLOCKUP
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
 lock_acquire+0x140/0x2e0 kernel/locking/lockdep.c:5868
 percpu_down_read_internal include/linux/percpu-rwsem.h:53 [inline]
 percpu_down_read_freezable include/linux/percpu-rwsem.h:83 [inline]
 __sb_start_write include/linux/fs/super.h:19 [inline]
 sb_start_intwrite include/linux/fs/super.h:177 [inline]
 ocfs2_start_trans+0x1f4/0x6b0 fs/ocfs2/journal.c:370
 __ocfs2_write_remove_suid+0x194/0x730 fs/ocfs2/file.c:1391
 ocfs2_write_remove_suid fs/ocfs2/file.c:1432 [inline]
 ocfs2_prepare_inode_for_write fs/ocfs2/file.c:2317 [inline]
 ocfs2_file_write_iter+0x868/0x1b8c fs/ocfs2/file.c:2457
 new_sync_write fs/read_write.c:593 [inline]
 vfs_write+0x540/0xa3c fs/read_write.c:686
 ksys_pwrite64 fs/read_write.c:793 [inline]
 __do_sys_pwrite64 fs/read_write.c:801 [inline]
 __se_sys_pwrite64 fs/read_write.c:798 [inline]
 __arm64_sys_pwrite64+0x170/0x208 fs/read_write.c:798
 __invoke_syscall arch/arm64/kernel/syscall.c:35 [inline]
 invoke_syscall+0x98/0x254 arch/arm64/kernel/syscall.c:49
 el0_svc_common+0xe8/0x23c arch/arm64/kernel/syscall.c:132
 do_el0_svc+0x48/0x58 arch/arm64/kernel/syscall.c:151
 el0_svc+0x5c/0x26c arch/arm64/kernel/entry-common.c:724
 el0t_64_sync_handler+0x84/0x12c arch/arm64/kernel/entry-common.c:743
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
