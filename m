Received: from mail-oo1-f72.google.com (mail-oo1-f72.google.com [209.85.161.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31547384230
	for <ocfs2-devel@lists.linux.dev>; Wed,  4 Mar 2026 20:58:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772657920; cv=none; b=a15Lue7OOmPF+JibL4c/pNZMvBeVpeqiNmBMXKdN3cjJZS2eS6SUD2Yvz280BHlnv+iysH2HJt+/NVXfjjy1dWN/2pTA7SNvv2/wRE06vkJhdQs/2TlxKx0Jzm8oq6FeUXDHLnsvrI15D60fgOS56E6GXlsYaiSXAZk3C6kwFvs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772657920; c=relaxed/simple;
	bh=0utRhRmleW6SQkEzMjQyFcMc8Ew/geM3492MRgidt4k=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=ay0MB41jWlUbBO6X68zwEkNBr/AyJwTEjLt+rZHpbJTr3nejIfGd6I4iQF3Thtzs75gQGyxnVMi3X4ypHO8/n0S4zYIxte82bGm13YgQ7SPC2WVXHTc133v3oxGKZQVU1RlW+K2SQ2Zvq+7Q78Wzkqc89gI/i8d07YV1qD544QI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.161.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oo1-f72.google.com with SMTP id 006d021491bc7-679deba5e9fso100424117eaf.0
        for <ocfs2-devel@lists.linux.dev>; Wed, 04 Mar 2026 12:58:38 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772657918; x=1773262718;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=cA8/vyGSKpOPFaKzlotHOcV2J/W3EVIT8QaAApRLICc=;
        b=Ig2USKW63ezFvQPr+zPVI8UIKwF2Jl+a1AfRY9J8YLTHbM2SOwhn8DCLdDzgzRl7C2
         GttOHnrMnzyUaHvnEUUBEYuCUF1Y3SRrnbBofAOvZ8BW4rYP+uoBUcXUI9fMsCL2xpM3
         mAwkRcl3EIaG3t/e6AJFywMnQ+9u36pYHROIOUepripWy3InO+5G5UGfnE7gXfOhGmsd
         1BtqQ/lLdNTqyiwVcgySdNCyKwYMCTOQ0/aFQg80sc1M558fPw272RlEsQb3nRU6Qf8F
         dDs5KdgL2Wx1FFSazpPTAQ5eE6MzNb7Sz2BwM4YpJbsTG3Ku3HHPM1GOS2LDgtULyKkg
         9jTQ==
X-Forwarded-Encrypted: i=1; AJvYcCWmL8YLWwLczOIC5XwDphpdqXaIL4LI8ktH3x4oO65m3TAp8YY6qlit1HZWsOjLRIYIjp+wX/nXWU9AAw==@lists.linux.dev
X-Gm-Message-State: AOJu0YxFiTHxqoEjw+sIfBubw12SjpoTwZyW+sutFGGVIS/uCDzn6S+2
	Ff8+tPPuVJB80+K5GeWUjDM3hL+zt90uvl9iFnjFgmDWXMaqgOL93mqekhcuU5+6Ksl3yW+LBJN
	PLEkvVnSNfOS9ea1UjYa2bl+RIXo03lqfQywJuDMQbnd15hbzXk73e2K09KE=
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6820:627:b0:679:ef25:3369 with SMTP id
 006d021491bc7-67b17744d3bmr2136729eaf.36.1772657918179; Wed, 04 Mar 2026
 12:58:38 -0800 (PST)
Date: Wed, 04 Mar 2026 12:58:38 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <69a89cfe.a70a0220.b118c.0026.GAE@google.com>
Subject: [syzbot] [ocfs2?] possible deadlock in ocfs2_extend_dir
From: syzbot <syzbot+67b90111784a3eac8c04@syzkaller.appspotmail.com>
To: jlbec@evilplan.org, joseph.qi@linux.alibaba.com, 
	linux-kernel@vger.kernel.org, mark@fasheh.com, ocfs2-devel@lists.linux.dev, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    4d349ee5c778 Merge tag 'arm64-fixes' of git://git.kernel.o..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=12e42d5a580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=93740e6c6567fcec
dashboard link: https://syzkaller.appspot.com/bug?extid=67b90111784a3eac8c04
compiler:       Debian clang version 21.1.8 (++20251221033036+2078da43e25a-1~exp1~20251221153213.50), Debian LLD 21.1.8

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/07750ef5994f/disk-4d349ee5.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/1dcac8a91bbe/vmlinux-4d349ee5.xz
kernel image: https://storage.googleapis.com/syzbot-assets/9818acdf7c39/bzImage-4d349ee5.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+67b90111784a3eac8c04@syzkaller.appspotmail.com

======================================================
WARNING: possible circular locking dependency detected
syzkaller #0 Tainted: G             L     
------------------------------------------------------
syz-executor/22669 is trying to acquire lock:
ffff88807a2dea20 (&ocfs2_file_ip_alloc_sem_key){++++}-{4:4}, at: ocfs2_expand_inline_dir fs/ocfs2/dir.c:2846 [inline]
ffff88807a2dea20 (&ocfs2_file_ip_alloc_sem_key){++++}-{4:4}, at: ocfs2_extend_dir+0x69a/0x4a60 fs/ocfs2/dir.c:3227

but task is already holding lock:
ffff88807a2ded80 (&ocfs2_sysfile_lock_key[ORPHAN_DIR_SYSTEM_INODE]){+.+.}-{4:4}, at: inode_lock include/linux/fs.h:1028 [inline]
ffff88807a2ded80 (&ocfs2_sysfile_lock_key[ORPHAN_DIR_SYSTEM_INODE]){+.+.}-{4:4}, at: ocfs2_lookup_lock_orphan_dir+0xec/0x2e0 fs/ocfs2/namei.c:2132

which lock already depends on the new lock.


the existing dependency chain (in reverse order) is:

-> #1 (&ocfs2_sysfile_lock_key[ORPHAN_DIR_SYSTEM_INODE]){+.+.}-{4:4}:
       down_write+0x96/0x200 kernel/locking/rwsem.c:1590
       inode_lock include/linux/fs.h:1028 [inline]
       ocfs2_del_inode_from_orphan+0x12e/0x7a0 fs/ocfs2/namei.c:2731
       ocfs2_dio_end_io_write fs/ocfs2/aops.c:2305 [inline]
       ocfs2_dio_end_io+0x543/0x1210 fs/ocfs2/aops.c:2403
       dio_complete+0x25b/0x790 fs/direct-io.c:281
       __blockdev_direct_IO+0x2cb0/0x32f0 fs/direct-io.c:1303
       ocfs2_direct_IO+0x251/0x2c0 fs/ocfs2/aops.c:2440
       generic_file_direct_write+0x1db/0x3e0 mm/filemap.c:4248
       __generic_file_write_iter+0x11d/0x230 mm/filemap.c:4417
       ocfs2_file_write_iter+0x1663/0x1ed0 fs/ocfs2/file.c:2476
       iter_file_splice_write+0x9a1/0x10f0 fs/splice.c:736
       do_splice_from fs/splice.c:936 [inline]
       direct_splice_actor+0x101/0x160 fs/splice.c:1159
       splice_direct_to_actor+0x53a/0xc70 fs/splice.c:1103
       do_splice_direct_actor fs/splice.c:1202 [inline]
       do_splice_direct+0x195/0x290 fs/splice.c:1228
       do_sendfile+0x535/0x7d0 fs/read_write.c:1372
       __do_sys_sendfile64 fs/read_write.c:1433 [inline]
       __se_sys_sendfile64+0x144/0x1a0 fs/read_write.c:1419
       do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
       do_syscall_64+0x14d/0xf80 arch/x86/entry/syscall_64.c:94
       entry_SYSCALL_64_after_hwframe+0x77/0x7f

-> #0 (&ocfs2_file_ip_alloc_sem_key){++++}-{4:4}:
       check_prev_add kernel/locking/lockdep.c:3165 [inline]
       check_prevs_add kernel/locking/lockdep.c:3284 [inline]
       validate_chain kernel/locking/lockdep.c:3908 [inline]
       __lock_acquire+0x15a5/0x2cf0 kernel/locking/lockdep.c:5237
       lock_acquire+0xf0/0x2e0 kernel/locking/lockdep.c:5868
       down_write+0x96/0x200 kernel/locking/rwsem.c:1590
       ocfs2_expand_inline_dir fs/ocfs2/dir.c:2846 [inline]
       ocfs2_extend_dir+0x69a/0x4a60 fs/ocfs2/dir.c:3227
       ocfs2_prepare_dir_for_insert+0x34b0/0x5360 fs/ocfs2/dir.c:4345
       __ocfs2_prepare_orphan_dir+0x144/0x310 fs/ocfs2/namei.c:2180
       ocfs2_prepare_orphan_dir+0xf0/0x420 fs/ocfs2/namei.c:2225
       ocfs2_unlink+0xba5/0x1bf0 fs/ocfs2/namei.c:963
       vfs_unlink+0x272/0x6c0 fs/namei.c:5470
       filename_unlinkat+0x3cd/0x610 fs/namei.c:5540
       __do_sys_unlink fs/namei.c:5575 [inline]
       __se_sys_unlink+0x2e/0x140 fs/namei.c:5572
       do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
       do_syscall_64+0x14d/0xf80 arch/x86/entry/syscall_64.c:94
       entry_SYSCALL_64_after_hwframe+0x77/0x7f

other info that might help us debug this:

 Possible unsafe locking scenario:

       CPU0                    CPU1
       ----                    ----
  lock(&ocfs2_sysfile_lock_key[ORPHAN_DIR_SYSTEM_INODE]);
                               lock(&ocfs2_file_ip_alloc_sem_key);
                               lock(&ocfs2_sysfile_lock_key[ORPHAN_DIR_SYSTEM_INODE]);
  lock(&ocfs2_file_ip_alloc_sem_key);

 *** DEADLOCK ***

4 locks held by syz-executor/22669:
 #0: ffff8880434d4420 (sb_writers#34){.+.+}-{0:0}, at: mnt_want_write+0x41/0x90 fs/namespace.c:493
 #1: ffff88807a2ad100 (&type->i_mutex_dir_key#22/1){+.+.}-{4:4}, at: inode_lock_nested include/linux/fs.h:1073 [inline]
 #1: ffff88807a2ad100 (&type->i_mutex_dir_key#22/1){+.+.}-{4:4}, at: __start_dirop fs/namei.c:2923 [inline]
 #1: ffff88807a2ad100 (&type->i_mutex_dir_key#22/1){+.+.}-{4:4}, at: start_dirop fs/namei.c:2934 [inline]
 #1: ffff88807a2ad100 (&type->i_mutex_dir_key#22/1){+.+.}-{4:4}, at: filename_unlinkat+0x2a7/0x610 fs/namei.c:5521
 #2: ffff888079e23480 (&sb->s_type->i_mutex_key#43){+.+.}-{4:4}, at: inode_lock include/linux/fs.h:1028 [inline]
 #2: ffff888079e23480 (&sb->s_type->i_mutex_key#43){+.+.}-{4:4}, at: vfs_unlink+0xed/0x6c0 fs/namei.c:5456
 #3: ffff88807a2ded80 (&ocfs2_sysfile_lock_key[ORPHAN_DIR_SYSTEM_INODE]){+.+.}-{4:4}, at: inode_lock include/linux/fs.h:1028 [inline]
 #3: ffff88807a2ded80 (&ocfs2_sysfile_lock_key[ORPHAN_DIR_SYSTEM_INODE]){+.+.}-{4:4}, at: ocfs2_lookup_lock_orphan_dir+0xec/0x2e0 fs/ocfs2/namei.c:2132

stack backtrace:
CPU: 1 UID: 0 PID: 22669 Comm: syz-executor Tainted: G             L      syzkaller #0 PREEMPT(full) 
Tainted: [L]=SOFTLOCKUP
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 02/12/2026
Call Trace:
 <TASK>
 dump_stack_lvl+0xe8/0x150 lib/dump_stack.c:120
 print_circular_bug+0x2e1/0x300 kernel/locking/lockdep.c:2043
 check_noncircular+0x12e/0x150 kernel/locking/lockdep.c:2175
 check_prev_add kernel/locking/lockdep.c:3165 [inline]
 check_prevs_add kernel/locking/lockdep.c:3284 [inline]
 validate_chain kernel/locking/lockdep.c:3908 [inline]
 __lock_acquire+0x15a5/0x2cf0 kernel/locking/lockdep.c:5237
 lock_acquire+0xf0/0x2e0 kernel/locking/lockdep.c:5868
 down_write+0x96/0x200 kernel/locking/rwsem.c:1590
 ocfs2_expand_inline_dir fs/ocfs2/dir.c:2846 [inline]
 ocfs2_extend_dir+0x69a/0x4a60 fs/ocfs2/dir.c:3227
 ocfs2_prepare_dir_for_insert+0x34b0/0x5360 fs/ocfs2/dir.c:4345
 __ocfs2_prepare_orphan_dir+0x144/0x310 fs/ocfs2/namei.c:2180
 ocfs2_prepare_orphan_dir+0xf0/0x420 fs/ocfs2/namei.c:2225
 ocfs2_unlink+0xba5/0x1bf0 fs/ocfs2/namei.c:963
 vfs_unlink+0x272/0x6c0 fs/namei.c:5470
 filename_unlinkat+0x3cd/0x610 fs/namei.c:5540
 __do_sys_unlink fs/namei.c:5575 [inline]
 __se_sys_unlink+0x2e/0x140 fs/namei.c:5572
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0x14d/0xf80 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7fea5b19b887
Code: 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48 83 c8 ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 b8 57 00 00 00 0f 05 <48> 3d 00 f0 ff ff 77 01 c3 48 c7 c2 e8 ff ff ff f7 d8 64 89 02 b8
RSP: 002b:00007ffcb7171a28 EFLAGS: 00000206 ORIG_RAX: 0000000000000057
RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007fea5b19b887
RDX: 00007ffcb7171a50 RSI: 00007ffcb7171ae0 RDI: 00007ffcb7171ae0
RBP: 00007ffcb7171ae0 R08: 00007ffcb7172ae0 R09: 00000000ffffffff
R10: 0000000000000100 R11: 0000000000000206 R12: 00007ffcb7172bd0
R13: 00007fea5b231f90 R14: 00000000001589a0 R15: 00007ffcb7173ca0
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
