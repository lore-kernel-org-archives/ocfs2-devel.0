Received: from mail-io1-f72.google.com (mail-io1-f72.google.com [209.85.166.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9704E13AA2D
	for <ocfs2-devel@lists.linux.dev>; Thu, 22 Aug 2024 08:11:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724314285; cv=none; b=bQAPoRZFK70tDDgb1dzFfe6vfM3h+HMIm8IdodjIky0PFyb3YrOM2XEQeMwYT56FSUrIvstGtQ3cp1EWtXcQfhz6RWwSg+tlu1r9SyfTL3f2FhI+1Q6eT4oVq1E1BwS0qL2ecfFRUNjdEUJCy0h7RivYO0G7gGnlogMOWirgfHo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724314285; c=relaxed/simple;
	bh=oAknn9Dsa6Ik3z8NrOXaSG2udHLkqfw2Maz4eJvLLIg=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=QxYEewurQtkQIT0wwkSNc/aez42J4k1mtxWUWKJYIKNQPeUf1sdNJeN6kyCO952HhllVMFKrCvdOlRXfyZE8D1/q4co2/yDypCN1RAPPBMwCYycS4zKzhdAjC8zfxcBE5HK1hklooabPCeMKy3AYvOAHostP8jpRTMYAzJzkOss=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-io1-f72.google.com with SMTP id ca18e2360f4ac-81f93601444so57886839f.2
        for <ocfs2-devel@lists.linux.dev>; Thu, 22 Aug 2024 01:11:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724314283; x=1724919083;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=mwf2VFpHpemmZsVA0ErCv0gLaiIe3p+EtIo1ylL9PF4=;
        b=deAsVVKYH5nF7wX2B7EB/RtWtQGuYM2QQxkiXWRRW7as3WjwhLgy702Abza03rW4wB
         kLvIug3695ELSs1zLKzvxTuUDAeyL4j8TYM0frxpvW4u3ce8oPkxH/1a8QGSm6w+/ceM
         aZAc/UuisNX5kH1pGIDslYqZ/dUrGj0eCerykx7RwiFr0eLQA5b1Wa8QfQ5gspI3TplP
         SmmxYCGU6r76tthTmbWWYyNS1tn31pPFppRQvR586TmxV4OVGRm+AZfs4CmrGhvwxP5r
         RzKnTcaXQXIj0m+KJZxyzwWokq+ot0hSouG5WElbT3UbxGUxubluH2GslVQeWy6RQpV6
         xuOQ==
X-Forwarded-Encrypted: i=1; AJvYcCVQG75W/kkEAsdWLdHPWXenVt0kkWH55cj432KwYsHh4s3ViMed5zwcymKy6SXnfOKsZdefbUgGybR2KQ==@lists.linux.dev
X-Gm-Message-State: AOJu0YxibUy6DAViSW+hvb4b5a/RvKkAPWnsLFt9zn1D61dO2lMsrD73
	E7vPXBq5dg7/6OAklws+D8c3n/zP/s8DhIIfkDpNTKEkxGs21w1AH/y2apxNXaoQNrrnpU0eF3l
	+SGo2MwAyZ43QDFod6V8eDW6ky9hHYzyVr3muEdUz/K8PpWD4fQUX47o=
X-Google-Smtp-Source: AGHT+IGxH/bu03XT3JgrNR6jE0gee1DGKXYwEK13mClm1bH5RAqHyqq/SkS5cvBJDuUnDnG2vU3T2tP3+GLftJXzHoo48IRAuofV
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6638:270c:b0:4c0:7f0f:b42e with SMTP id
 8926c6da1cb9f-4ce62d769efmr158681173.1.1724314282774; Thu, 22 Aug 2024
 01:11:22 -0700 (PDT)
Date: Thu, 22 Aug 2024 01:11:22 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000004e67af0620413459@google.com>
Subject: [syzbot] [ocfs2?] possible deadlock in ocfs2_init_acl
From: syzbot <syzbot+4007ab5229e732466d9f@syzkaller.appspotmail.com>
To: jlbec@evilplan.org, joseph.qi@linux.alibaba.com, 
	linux-kernel@vger.kernel.org, mark@fasheh.com, ocfs2-devel@lists.linux.dev, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    b311c1b497e5 Merge tag '6.11-rc4-server-fixes' of git://gi..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=11491305980000
kernel config:  https://syzkaller.appspot.com/x/.config?x=df2f0ed7e30a639d
dashboard link: https://syzkaller.appspot.com/bug?extid=4007ab5229e732466d9f
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=147ce7d5980000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=10925a7b980000

Downloadable assets:
disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/7bc7510fe41f/non_bootable_disk-b311c1b4.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/1c99fa48192f/vmlinux-b311c1b4.xz
kernel image: https://storage.googleapis.com/syzbot-assets/16d5710a012a/bzImage-b311c1b4.xz
mounted in repro: https://storage.googleapis.com/syzbot-assets/d933977af46c/mount_0.gz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+4007ab5229e732466d9f@syzkaller.appspotmail.com

=======================================================
ocfs2: Mounting device (7,0) on (node local, slot 0) with ordered data mode.
======================================================
WARNING: possible circular locking dependency detected
6.11.0-rc4-syzkaller-00019-gb311c1b497e5 #0 Not tainted
------------------------------------------------------
syz-executor815/5091 is trying to acquire lock:
ffff88803ca086f8 (&oi->ip_xattr_sem){++++}-{3:3}, at: ocfs2_init_acl+0x397/0x930 fs/ocfs2/acl.c:366

but task is already holding lock:
ffff888038692958 (jbd2_handle){.+.+}-{0:0}, at: start_this_handle+0x1e94/0x2110 fs/jbd2/transaction.c:448

which lock already depends on the new lock.


the existing dependency chain (in reverse order) is:

-> #4 (jbd2_handle){.+.+}-{0:0}:
       lock_acquire+0x1ed/0x550 kernel/locking/lockdep.c:5759
       start_this_handle+0x1eb4/0x2110 fs/jbd2/transaction.c:448
       jbd2__journal_start+0x2da/0x5d0 fs/jbd2/transaction.c:505
       jbd2_journal_start+0x29/0x40 fs/jbd2/transaction.c:544
       ocfs2_start_trans+0x3c9/0x700 fs/ocfs2/journal.c:352
       ocfs2_acl_set_mode+0x2c9/0x8c0 fs/ocfs2/acl.c:174
       ocfs2_iop_set_acl+0x33b/0x3c0 fs/ocfs2/acl.c:282
       set_posix_acl fs/posix_acl.c:955 [inline]
       vfs_set_acl+0x7fd/0xa60 fs/posix_acl.c:1134
       do_set_acl+0xf4/0x180 fs/posix_acl.c:1279
       do_setxattr fs/xattr.c:626 [inline]
       __do_sys_fsetxattr fs/xattr.c:710 [inline]
       __se_sys_fsetxattr+0x3b5/0x480 fs/xattr.c:686
       do_syscall_x64 arch/x86/entry/common.c:52 [inline]
       do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
       entry_SYSCALL_64_after_hwframe+0x77/0x7f

-> #3 (&journal->j_trans_barrier){.+.+}-{3:3}:
       lock_acquire+0x1ed/0x550 kernel/locking/lockdep.c:5759
       down_read+0xb1/0xa40 kernel/locking/rwsem.c:1526
       ocfs2_start_trans+0x3be/0x700 fs/ocfs2/journal.c:350
       ocfs2_acl_set_mode+0x2c9/0x8c0 fs/ocfs2/acl.c:174
       ocfs2_iop_set_acl+0x33b/0x3c0 fs/ocfs2/acl.c:282
       set_posix_acl fs/posix_acl.c:955 [inline]
       vfs_set_acl+0x7fd/0xa60 fs/posix_acl.c:1134
       do_set_acl+0xf4/0x180 fs/posix_acl.c:1279
       do_setxattr fs/xattr.c:626 [inline]
       __do_sys_fsetxattr fs/xattr.c:710 [inline]
       __se_sys_fsetxattr+0x3b5/0x480 fs/xattr.c:686
       do_syscall_x64 arch/x86/entry/common.c:52 [inline]
       do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
       entry_SYSCALL_64_after_hwframe+0x77/0x7f

-> #2 (sb_internal#2){.+.+}-{0:0}:
       lock_acquire+0x1ed/0x550 kernel/locking/lockdep.c:5759
       percpu_down_read include/linux/percpu-rwsem.h:51 [inline]
       __sb_start_write include/linux/fs.h:1675 [inline]
       sb_start_intwrite include/linux/fs.h:1858 [inline]
       ocfs2_start_trans+0x2b9/0x700 fs/ocfs2/journal.c:348
       ocfs2_xattr_set+0x1192/0x1930 fs/ocfs2/xattr.c:3644
       ocfs2_set_acl+0x4cb/0x580 fs/ocfs2/acl.c:254
       ocfs2_iop_set_acl+0x24a/0x3c0 fs/ocfs2/acl.c:286
       set_posix_acl fs/posix_acl.c:955 [inline]
       vfs_set_acl+0x7fd/0xa60 fs/posix_acl.c:1134
       do_set_acl+0xf4/0x180 fs/posix_acl.c:1279
       do_setxattr fs/xattr.c:626 [inline]
       __do_sys_fsetxattr fs/xattr.c:710 [inline]
       __se_sys_fsetxattr+0x3b5/0x480 fs/xattr.c:686
       do_syscall_x64 arch/x86/entry/common.c:52 [inline]
       do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
       entry_SYSCALL_64_after_hwframe+0x77/0x7f

-> #1 (&ocfs2_sysfile_lock_key[args->fi_sysfile_type]#3){+.+.}-{3:3}:
       lock_acquire+0x1ed/0x550 kernel/locking/lockdep.c:5759
       down_write+0x99/0x220 kernel/locking/rwsem.c:1579
       inode_lock include/linux/fs.h:799 [inline]
       ocfs2_reserve_suballoc_bits+0x192/0x4eb0 fs/ocfs2/suballoc.c:786
       ocfs2_reserve_new_metadata_blocks+0x41c/0x9c0 fs/ocfs2/suballoc.c:982
       ocfs2_init_xattr_set_ctxt+0x3a6/0x900 fs/ocfs2/xattr.c:3278
       ocfs2_xattr_set+0xf4e/0x1930 fs/ocfs2/xattr.c:3635
       ocfs2_set_acl+0x4cb/0x580 fs/ocfs2/acl.c:254
       ocfs2_iop_set_acl+0x24a/0x3c0 fs/ocfs2/acl.c:286
       set_posix_acl fs/posix_acl.c:955 [inline]
       vfs_set_acl+0x7fd/0xa60 fs/posix_acl.c:1134
       do_set_acl+0xf4/0x180 fs/posix_acl.c:1279
       do_setxattr fs/xattr.c:626 [inline]
       __do_sys_fsetxattr fs/xattr.c:710 [inline]
       __se_sys_fsetxattr+0x3b5/0x480 fs/xattr.c:686
       do_syscall_x64 arch/x86/entry/common.c:52 [inline]
       do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
       entry_SYSCALL_64_after_hwframe+0x77/0x7f

-> #0 (&oi->ip_xattr_sem){++++}-{3:3}:
       check_prev_add kernel/locking/lockdep.c:3133 [inline]
       check_prevs_add kernel/locking/lockdep.c:3252 [inline]
       validate_chain+0x18e0/0x5900 kernel/locking/lockdep.c:3868
       __lock_acquire+0x137a/0x2040 kernel/locking/lockdep.c:5142
       lock_acquire+0x1ed/0x550 kernel/locking/lockdep.c:5759
       down_read+0xb1/0xa40 kernel/locking/rwsem.c:1526
       ocfs2_init_acl+0x397/0x930 fs/ocfs2/acl.c:366
       ocfs2_mknod+0x1c05/0x2b40 fs/ocfs2/namei.c:408
       ocfs2_mkdir+0x1ab/0x480 fs/ocfs2/namei.c:655
       vfs_mkdir+0x2f9/0x4f0 fs/namei.c:4210
       do_mkdirat+0x264/0x3a0 fs/namei.c:4233
       __do_sys_mkdirat fs/namei.c:4248 [inline]
       __se_sys_mkdirat fs/namei.c:4246 [inline]
       __x64_sys_mkdirat+0x87/0xa0 fs/namei.c:4246
       do_syscall_x64 arch/x86/entry/common.c:52 [inline]
       do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
       entry_SYSCALL_64_after_hwframe+0x77/0x7f

other info that might help us debug this:

Chain exists of:
  &oi->ip_xattr_sem --> &journal->j_trans_barrier --> jbd2_handle

 Possible unsafe locking scenario:

       CPU0                    CPU1
       ----                    ----
  rlock(jbd2_handle);
                               lock(&journal->j_trans_barrier);
                               lock(jbd2_handle);
  rlock(&oi->ip_xattr_sem);

 *** DEADLOCK ***

8 locks held by syz-executor815/5091:
 #0: ffff88803a882420 (sb_writers#9){.+.+}-{0:0}, at: mnt_want_write+0x3f/0x90 fs/namespace.c:515
 #1: ffff88803ca089c0 (&type->i_mutex_dir_key#6/1){+.+.}-{3:3}, at: inode_lock_nested include/linux/fs.h:834 [inline]
 #1: ffff88803ca089c0 (&type->i_mutex_dir_key#6/1){+.+.}-{3:3}, at: filename_create+0x260/0x540 fs/namei.c:3979
 #2: ffff88803ca109c0 (&ocfs2_sysfile_lock_key[args->fi_sysfile_type]#5){+.+.}-{3:3}, at: inode_lock include/linux/fs.h:799 [inline]
 #2: ffff88803ca109c0 (&ocfs2_sysfile_lock_key[args->fi_sysfile_type]#5){+.+.}-{3:3}, at: ocfs2_reserve_suballoc_bits+0x192/0x4eb0 fs/ocfs2/suballoc.c:786
 #3: ffff88803ca0ed80 (&ocfs2_sysfile_lock_key[args->fi_sysfile_type]#3){+.+.}-{3:3}, at: inode_lock include/linux/fs.h:799 [inline]
 #3: ffff88803ca0ed80 (&ocfs2_sysfile_lock_key[args->fi_sysfile_type]#3){+.+.}-{3:3}, at: ocfs2_reserve_suballoc_bits+0x192/0x4eb0 fs/ocfs2/suballoc.c:786
 #4: ffff88803ca12640 (&ocfs2_sysfile_lock_key[args->fi_sysfile_type]#6){+.+.}-{3:3}, at: inode_lock include/linux/fs.h:799 [inline]
 #4: ffff88803ca12640 (&ocfs2_sysfile_lock_key[args->fi_sysfile_type]#6){+.+.}-{3:3}, at: ocfs2_reserve_local_alloc_bits+0x132/0x2870 fs/ocfs2/localalloc.c:636
 #5: ffff88803a882610 (sb_internal#2){.+.+}-{0:0}, at: ocfs2_mknod+0x150c/0x2b40 fs/ocfs2/namei.c:359
 #6: ffff8880207cece8 (&journal->j_trans_barrier){.+.+}-{3:3}, at: ocfs2_start_trans+0x3be/0x700 fs/ocfs2/journal.c:350
 #7: ffff888038692958 (jbd2_handle){.+.+}-{0:0}, at: start_this_handle+0x1e94/0x2110 fs/jbd2/transaction.c:448

stack backtrace:
CPU: 0 UID: 0 PID: 5091 Comm: syz-executor815 Not tainted 6.11.0-rc4-syzkaller-00019-gb311c1b497e5 #0
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2~bpo12+1 04/01/2014
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:93 [inline]
 dump_stack_lvl+0x241/0x360 lib/dump_stack.c:119
 check_noncircular+0x36a/0x4a0 kernel/locking/lockdep.c:2186
 check_prev_add kernel/locking/lockdep.c:3133 [inline]
 check_prevs_add kernel/locking/lockdep.c:3252 [inline]
 validate_chain+0x18e0/0x5900 kernel/locking/lockdep.c:3868
 __lock_acquire+0x137a/0x2040 kernel/locking/lockdep.c:5142
 lock_acquire+0x1ed/0x550 kernel/locking/lockdep.c:5759
 down_read+0xb1/0xa40 kernel/locking/rwsem.c:1526
 ocfs2_init_acl+0x397/0x930 fs/ocfs2/acl.c:366
 ocfs2_mknod+0x1c05/0x2b40 fs/ocfs2/namei.c:408
 ocfs2_mkdir+0x1ab/0x480 fs/ocfs2/namei.c:655
 vfs_mkdir+0x2f9/0x4f0 fs/namei.c:4210
 do_mkdirat+0x264/0x3a0 fs/namei.c:4233
 __do_sys_mkdirat fs/namei.c:4248 [inline]
 __se_sys_mkdirat fs/namei.c:4246 [inline]
 __x64_sys_mkdirat+0x87/0xa0 fs/namei.c:4246
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f023db07b99
Code: 28 00 00 00 75 05 48 83 c4 28 c3 e8 f1 17 00 00 90 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 b8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007ffddccc5018 EFLAGS: 00000246 ORIG_RAX: 0000000000000102
RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007f023db07b99
RDX: 0000000000000000 RSI: 0000000020000080 RDI: 00000000ffffff9c
RBP: 00007f023db7f5f0 R08: 00005555929264c0 R09: 00005555929264c0
R10: 0000000000000000 R11: 0000000000000246 R12: 00007ffddccc5040
R13: 00007ffddccc5268 R14: 431bde82d7b634db R15: 00007f023db5003b
 </TASK>


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.

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
