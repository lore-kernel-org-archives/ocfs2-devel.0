Received: from mail-ot1-f80.google.com (mail-ot1-f80.google.com [209.85.210.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 971D91E521A
	for <ocfs2-devel@lists.linux.dev>; Fri,  2 Jan 2026 15:39:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767368366; cv=none; b=m2m+jCesrwtz9r3lhthZpQSOacwnwY/7m//Q/GfqcY2c0qob88CO8T6yCWoWGlboTZdqL6I2MEUP6ePBw9GwY7SHC6FRaQW2MRDwui/m5p9DZ4Uvpseav1BQFM6Tul8X9HEV1wRX2aLF/dEN17wtjHRaItkPh9415/nJdcuHmUk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767368366; c=relaxed/simple;
	bh=JYQ5MXBduPBH32Wc7ZnUl5GYirGfXK0sgJnA2dIkwlY=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=j3aiImuluIfRaTHqpHjDbkftW2gO1Y7lVy1yE+kajI56L73/fUSv7kRWI+pvMDu6lVZBaq2Wd+uvpebitxMG0Z+yTKj2wIJn3hI5WmOum+GFT7toF9c0US9qzv31v4HzNNg2Pk4Ni10/K05lolrGXsE2RetRk9g1nOV0gjzb+Rk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.210.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-ot1-f80.google.com with SMTP id 46e09a7af769-7c702347c6eso14728514a34.1
        for <ocfs2-devel@lists.linux.dev>; Fri, 02 Jan 2026 07:39:23 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767368362; x=1767973162;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=S9RR1etedDUNsh2HjwO80X5kjZ6c6Eh1rNJxCt2ZlFc=;
        b=nam2PRPqIQE7WbC13nSCjkZtN/jz5gaMOviAz9YOuOfQIc82LEgWosGKoHu0fLoPF7
         XFlyN1fJRO0GrDl8UJQMZakycGjkej8NEFL0l48u/OECpJt4zQzp0632pPg2WrCe+528
         xLzX/B8eTb/TkpCVL9/CExGzEY1mSuI0LWJVtxHjOvOHyFxH5SRz7rdjbOjQcXqPmLFK
         AnYMcsbE6YvKao5glLup7buRMEh3+ptMR0jdReqCTpKwtUYbaSPWJj43IDR2HLl+FSe4
         xoZjaMQ0SOAHR2cq6QXycsBqpWuiFL8/FS1eYMrT4qSU/eifKxcjIIETCT5zzsBQq686
         BYPg==
X-Forwarded-Encrypted: i=1; AJvYcCW2tSOWzam2dU8Y7dg4rIWx1DZ27t7o2zKc599z06ljKGzVHZ8moGtK7Xj/ADwNDadG0FM59rB66dHTOw==@lists.linux.dev
X-Gm-Message-State: AOJu0YyM0TN3HaSOpVkJNyLBYQ/Nu6nx9daGNywdXHpao4Zqvg5Tx5W/
	UyL2QCZ+D6AbVr2mEALzN0YcjsLakGxalFZw9Qxu+MEEYBMKSAm3rxmIdI1/ZaFx8BJHMGMsIK5
	IMx5WLDxBOv+HhjbOTtoW4AnvOGah3cTqB4GBdNDd3L9jztodW8f/O8KxdhU=
X-Google-Smtp-Source: AGHT+IEPD545U2SSvzbu/cbWUk8DZNvb+gsxbkZOaUQ9yy2e+/Ifp1WPNRWv6srsGMVGIBeRYypIeH2BT5HXJbP0xcKKqu15kL3c
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6820:8505:b0:659:9a49:8e84 with SMTP id
 006d021491bc7-65d0eb58aa8mr10282850eaf.84.1767368362363; Fri, 02 Jan 2026
 07:39:22 -0800 (PST)
Date: Fri, 02 Jan 2026 07:39:22 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6957e6aa.050a0220.1c9965.0003.GAE@google.com>
Subject: [syzbot] [ocfs2?] possible deadlock in _ocfs2_free_suballoc_bits
From: syzbot <syzbot+73d1166b94ed9875af54@syzkaller.appspotmail.com>
To: akpm@linux-foundation.org, glass.su@suse.com, heming.zhao@suse.com, 
	jlbec@evilplan.org, joseph.qi@linux.alibaba.com, linux-kernel@vger.kernel.org, 
	mark@fasheh.com, ocfs2-devel@lists.linux.dev, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    cc3aa43b44bd Add linux-next specific files for 20251219
git tree:       linux-next
console output: https://syzkaller.appspot.com/x/log.txt?x=17c5b792580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=da1bc82c6189c463
dashboard link: https://syzkaller.appspot.com/bug?extid=73d1166b94ed9875af54
compiler:       Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~exp1~20250708183702.136), Debian LLD 20.1.8
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=164b0a9a580000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=123c329a580000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/30bf539e6f28/disk-cc3aa43b.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/0e2f8b08e342/vmlinux-cc3aa43b.xz
kernel image: https://storage.googleapis.com/syzbot-assets/ec7ee6ece11f/bzImage-cc3aa43b.xz
mounted in repro: https://storage.googleapis.com/syzbot-assets/9340ba13ff7c/mount_0.gz
  fsck result: OK (log: https://syzkaller.appspot.com/x/fsck.log?x=144b0a9a580000)

The issue was bisected to:

commit e6f7b6feb0d2a913e28218a51d63230be2effdf2
Author: Heming Zhao <heming.zhao@suse.com>
Date:   Fri Dec 12 07:45:03 2025 +0000

    ocfs2: give ocfs2 the ability to reclaim suballocator free bg

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=120d0a22580000
final oops:     https://syzkaller.appspot.com/x/report.txt?x=110d0a22580000
console output: https://syzkaller.appspot.com/x/log.txt?x=160d0a22580000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+73d1166b94ed9875af54@syzkaller.appspotmail.com
Fixes: e6f7b6feb0d2 ("ocfs2: give ocfs2 the ability to reclaim suballocator free bg")

======================================================
WARNING: possible circular locking dependency detected
syzkaller #0 Not tainted
------------------------------------------------------
syz-executor/5944 is trying to acquire lock:
ffff88805e3ad100 (&ocfs2_sysfile_lock_key[GLOBAL_BITMAP_SYSTEM_INODE]){+.+.}-{4:4}, at: inode_lock include/linux/fs.h:1028 [inline]
ffff88805e3ad100 (&ocfs2_sysfile_lock_key[GLOBAL_BITMAP_SYSTEM_INODE]){+.+.}-{4:4}, at: _ocfs2_reclaim_suballoc_to_main fs/ocfs2/suballoc.c:2757 [inline]
ffff88805e3ad100 (&ocfs2_sysfile_lock_key[GLOBAL_BITMAP_SYSTEM_INODE]){+.+.}-{4:4}, at: _ocfs2_free_suballoc_bits+0x13f1/0x2130 fs/ocfs2/suballoc.c:2911

but task is already holding lock:
ffff88801df660e8 (&journal->j_trans_barrier){.+.+}-{4:4}, at: ocfs2_start_trans+0x36a/0x6d0 fs/ocfs2/journal.c:372

which lock already depends on the new lock.


the existing dependency chain (in reverse order) is:

-> #2 (&journal->j_trans_barrier){.+.+}-{4:4}:
       down_read+0x47/0x2e0 kernel/locking/rwsem.c:1537
       ocfs2_start_trans+0x36a/0x6d0 fs/ocfs2/journal.c:372
       ocfs2_block_group_alloc fs/ocfs2/suballoc.c:754 [inline]
       ocfs2_reserve_suballoc_bits+0x722/0x4600 fs/ocfs2/suballoc.c:903
       ocfs2_reserve_new_inode+0x4f4/0xc90 fs/ocfs2/suballoc.c:1143
       ocfs2_mknod+0x831/0x2030 fs/ocfs2/namei.c:307
       ocfs2_mkdir+0x181/0x420 fs/ocfs2/namei.c:660
       vfs_mkdir+0x414/0x630 fs/namei.c:5196
       do_mkdirat+0x276/0x500 fs/namei.c:5230
       __do_sys_mkdirat fs/namei.c:5252 [inline]
       __se_sys_mkdirat fs/namei.c:5250 [inline]
       __x64_sys_mkdirat+0x87/0xa0 fs/namei.c:5250
       do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
       do_syscall_64+0xfa/0xf80 arch/x86/entry/syscall_64.c:94
       entry_SYSCALL_64_after_hwframe+0x77/0x7f

-> #1 (sb_internal#2){.+.+}-{0:0}:
       percpu_down_read_internal include/linux/percpu-rwsem.h:53 [inline]
       percpu_down_read_freezable include/linux/percpu-rwsem.h:83 [inline]
       __sb_start_write include/linux/fs/super.h:19 [inline]
       sb_start_intwrite include/linux/fs/super.h:177 [inline]
       ocfs2_start_trans+0x26b/0x6d0 fs/ocfs2/journal.c:370
       ocfs2_block_group_alloc fs/ocfs2/suballoc.c:754 [inline]
       ocfs2_reserve_suballoc_bits+0x722/0x4600 fs/ocfs2/suballoc.c:903
       ocfs2_reserve_new_inode+0x4f4/0xc90 fs/ocfs2/suballoc.c:1143
       ocfs2_mknod+0x831/0x2030 fs/ocfs2/namei.c:307
       ocfs2_mkdir+0x181/0x420 fs/ocfs2/namei.c:660
       vfs_mkdir+0x414/0x630 fs/namei.c:5196
       do_mkdirat+0x276/0x500 fs/namei.c:5230
       __do_sys_mkdirat fs/namei.c:5252 [inline]
       __se_sys_mkdirat fs/namei.c:5250 [inline]
       __x64_sys_mkdirat+0x87/0xa0 fs/namei.c:5250
       do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
       do_syscall_64+0xfa/0xf80 arch/x86/entry/syscall_64.c:94
       entry_SYSCALL_64_after_hwframe+0x77/0x7f

-> #0 (&ocfs2_sysfile_lock_key[GLOBAL_BITMAP_SYSTEM_INODE]){+.+.}-{4:4}:
       check_prev_add kernel/locking/lockdep.c:3165 [inline]
       check_prevs_add kernel/locking/lockdep.c:3284 [inline]
       validate_chain kernel/locking/lockdep.c:3908 [inline]
       __lock_acquire+0x15a6/0x2cf0 kernel/locking/lockdep.c:5237
       lock_acquire+0x117/0x340 kernel/locking/lockdep.c:5868
       down_write+0x96/0x1f0 kernel/locking/rwsem.c:1590
       inode_lock include/linux/fs.h:1028 [inline]
       _ocfs2_reclaim_suballoc_to_main fs/ocfs2/suballoc.c:2757 [inline]
       _ocfs2_free_suballoc_bits+0x13f1/0x2130 fs/ocfs2/suballoc.c:2911
       ocfs2_free_suballoc_bits fs/ocfs2/suballoc.c:2925 [inline]
       ocfs2_free_dinode+0xb1/0xe0 fs/ocfs2/suballoc.c:2940
       ocfs2_remove_inode fs/ocfs2/inode.c:774 [inline]
       ocfs2_wipe_inode fs/ocfs2/inode.c:896 [inline]
       ocfs2_delete_inode fs/ocfs2/inode.c:1157 [inline]
       ocfs2_evict_inode+0x1d84/0x4040 fs/ocfs2/inode.c:1299
       evict+0x5f4/0xae0 fs/inode.c:837
       d_delete_notify include/linux/fsnotify.h:377 [inline]
       vfs_rmdir+0x427/0x6e0 fs/namei.c:5315
       do_rmdir+0x281/0x500 fs/namei.c:5357
       __do_sys_unlinkat fs/namei.c:5534 [inline]
       __se_sys_unlinkat fs/namei.c:5528 [inline]
       __x64_sys_unlinkat+0xc2/0xf0 fs/namei.c:5528
       do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
       do_syscall_64+0xfa/0xf80 arch/x86/entry/syscall_64.c:94
       entry_SYSCALL_64_after_hwframe+0x77/0x7f

other info that might help us debug this:

Chain exists of:
  &ocfs2_sysfile_lock_key[GLOBAL_BITMAP_SYSTEM_INODE] --> sb_internal#2 --> &journal->j_trans_barrier

 Possible unsafe locking scenario:

       CPU0                    CPU1
       ----                    ----
  rlock(&journal->j_trans_barrier);
                               lock(sb_internal#2);
                               lock(&journal->j_trans_barrier);
  lock(&ocfs2_sysfile_lock_key[GLOBAL_BITMAP_SYSTEM_INODE]);

 *** DEADLOCK ***

8 locks held by syz-executor/5944:
 #0: ffff888033eda420 (sb_writers#12){.+.+}-{0:0}, at: mnt_want_write+0x41/0x90 fs/namespace.c:499
 #1: ffff88805e3a89c0 (&type->i_mutex_dir_key#8/1){+.+.}-{4:4}, at: inode_lock_nested include/linux/fs.h:1073 [inline]
 #1: ffff88805e3a89c0 (&type->i_mutex_dir_key#8/1){+.+.}-{4:4}, at: __start_dirop fs/namei.c:2864 [inline]
 #1: ffff88805e3a89c0 (&type->i_mutex_dir_key#8/1){+.+.}-{4:4}, at: start_dirop fs/namei.c:2875 [inline]
 #1: ffff88805e3a89c0 (&type->i_mutex_dir_key#8/1){+.+.}-{4:4}, at: do_rmdir+0x1be/0x500 fs/namei.c:5350
 #2: ffff88802ab80bd0 (&osb->nfs_sync_rwlock){.+.+}-{4:4}, at: ocfs2_nfs_sync_lock+0x106/0x250 fs/ocfs2/dlmglue.c:2875
 #3: ffff88805e3adf40 (&ocfs2_sysfile_lock_key[ORPHAN_DIR_SYSTEM_INODE]){+.+.}-{4:4}, at: inode_lock include/linux/fs.h:1028 [inline]
 #3: ffff88805e3adf40 (&ocfs2_sysfile_lock_key[ORPHAN_DIR_SYSTEM_INODE]){+.+.}-{4:4}, at: ocfs2_wipe_inode fs/ocfs2/inode.c:854 [inline]
 #3: ffff88805e3adf40 (&ocfs2_sysfile_lock_key[ORPHAN_DIR_SYSTEM_INODE]){+.+.}-{4:4}, at: ocfs2_delete_inode fs/ocfs2/inode.c:1157 [inline]
 #3: ffff88805e3adf40 (&ocfs2_sysfile_lock_key[ORPHAN_DIR_SYSTEM_INODE]){+.+.}-{4:4}, at: ocfs2_evict_inode+0xf6c/0x4040 fs/ocfs2/inode.c:1299
 #4: ffff88805e3b09c0 (&ocfs2_sysfile_lock_key[INODE_ALLOC_SYSTEM_INODE]){+.+.}-{4:4}, at: inode_lock include/linux/fs.h:1028 [inline]
 #4: ffff88805e3b09c0 (&ocfs2_sysfile_lock_key[INODE_ALLOC_SYSTEM_INODE]){+.+.}-{4:4}, at: ocfs2_remove_inode fs/ocfs2/inode.c:733 [inline]
 #4: ffff88805e3b09c0 (&ocfs2_sysfile_lock_key[INODE_ALLOC_SYSTEM_INODE]){+.+.}-{4:4}, at: ocfs2_wipe_inode fs/ocfs2/inode.c:896 [inline]
 #4: ffff88805e3b09c0 (&ocfs2_sysfile_lock_key[INODE_ALLOC_SYSTEM_INODE]){+.+.}-{4:4}, at: ocfs2_delete_inode fs/ocfs2/inode.c:1157 [inline]
 #4: ffff88805e3b09c0 (&ocfs2_sysfile_lock_key[INODE_ALLOC_SYSTEM_INODE]){+.+.}-{4:4}, at: ocfs2_evict_inode+0x1507/0x4040 fs/ocfs2/inode.c:1299
 #5: ffff888033eda610 (sb_internal#2){.+.+}-{0:0}, at: ocfs2_remove_inode fs/ocfs2/inode.c:742 [inline]
 #5: ffff888033eda610 (sb_internal#2){.+.+}-{0:0}, at: ocfs2_wipe_inode fs/ocfs2/inode.c:896 [inline]
 #5: ffff888033eda610 (sb_internal#2){.+.+}-{0:0}, at: ocfs2_delete_inode fs/ocfs2/inode.c:1157 [inline]
 #5: ffff888033eda610 (sb_internal#2){.+.+}-{0:0}, at: ocfs2_evict_inode+0x15ea/0x4040 fs/ocfs2/inode.c:1299
 #6: ffff88801df660e8 (&journal->j_trans_barrier){.+.+}-{4:4}, at: ocfs2_start_trans+0x36a/0x6d0 fs/ocfs2/journal.c:372
 #7: ffff88807945a950 (jbd2_handle#2){.+.+}-{0:0}, at: start_this_handle+0x1f87/0x21c0 fs/jbd2/transaction.c:444

stack backtrace:
CPU: 0 UID: 0 PID: 5944 Comm: syz-executor Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 10/25/2025
Call Trace:
 <TASK>
 dump_stack_lvl+0x189/0x250 lib/dump_stack.c:120
 print_circular_bug+0x2e2/0x300 kernel/locking/lockdep.c:2043
 check_noncircular+0x12e/0x150 kernel/locking/lockdep.c:2175
 check_prev_add kernel/locking/lockdep.c:3165 [inline]
 check_prevs_add kernel/locking/lockdep.c:3284 [inline]
 validate_chain kernel/locking/lockdep.c:3908 [inline]
 __lock_acquire+0x15a6/0x2cf0 kernel/locking/lockdep.c:5237
 lock_acquire+0x117/0x340 kernel/locking/lockdep.c:5868
 down_write+0x96/0x1f0 kernel/locking/rwsem.c:1590
 inode_lock include/linux/fs.h:1028 [inline]
 _ocfs2_reclaim_suballoc_to_main fs/ocfs2/suballoc.c:2757 [inline]
 _ocfs2_free_suballoc_bits+0x13f1/0x2130 fs/ocfs2/suballoc.c:2911
 ocfs2_free_suballoc_bits fs/ocfs2/suballoc.c:2925 [inline]
 ocfs2_free_dinode+0xb1/0xe0 fs/ocfs2/suballoc.c:2940
 ocfs2_remove_inode fs/ocfs2/inode.c:774 [inline]
 ocfs2_wipe_inode fs/ocfs2/inode.c:896 [inline]
 ocfs2_delete_inode fs/ocfs2/inode.c:1157 [inline]
 ocfs2_evict_inode+0x1d84/0x4040 fs/ocfs2/inode.c:1299
 evict+0x5f4/0xae0 fs/inode.c:837
 d_delete_notify include/linux/fsnotify.h:377 [inline]
 vfs_rmdir+0x427/0x6e0 fs/namei.c:5315
 do_rmdir+0x281/0x500 fs/namei.c:5357
 __do_sys_unlinkat fs/namei.c:5534 [inline]
 __se_sys_unlinkat fs/namei.c:5528 [inline]
 __x64_sys_unlinkat+0xc2/0xf0 fs/namei.c:5528
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0xfa/0xf80 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f742998ed27
Code: 73 01 c3 48 c7 c1 a8 ff ff ff f7 d8 64 89 01 48 83 c8 ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 b8 07 01 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 a8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007ffe40bbd268 EFLAGS: 00000207 ORIG_RAX: 0000000000000107
RAX: ffffffffffffffda RBX: 0000000000000065 RCX: 00007f742998ed27
RDX: 0000000000000200 RSI: 00007ffe40bbe410 RDI: 00000000ffffff9c
RBP: 00007f7429a13d7d R08: 000055555e6c066b R09: 0000000000000000
R10: 0000000000001000 R11: 0000000000000207 R12: 00007ffe40bbe410
R13: 00007f7429a13d7d R14: 0000000000016c75 R15: 00007ffe40bc05d0
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
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
For information about bisection process see: https://goo.gl/tpsmEJ#bisection

If the report is already addressed, let syzbot know by replying with:
#syz fix: exact-commit-title

If you want syzbot to run the reproducer, reply with:
#syz test: git://repo/address.git branch-or-commit-hash
If you attach or paste a git patch, syzbot will apply it before testing.

If you want to overwrite report's subsystems, reply with:
#syz set subsystems: new-subsystem
(See the list of subsystem names on the web dashboard)

If the report is a duplicate of another one, reply with:
#syz dup: exact-subject-of-another-report

If you want to undo deduplication, reply with:
#syz undup
