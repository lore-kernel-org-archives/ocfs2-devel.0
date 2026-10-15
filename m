Received: from mail-oi1-f200.google.com (mail-oi1-f200.google.com [209.85.167.200])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E20454A2A7F
	for <ocfs2-devel@lists.linux.dev>; Thu, 15 Oct 2026 07:48:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.200
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792050512; cv=none; b=HZ7m6VAaxqJ8+ntqrbyqmFiRj+a0ZjURdAkT6fXBZKuIxHP90WVA2k9SHJU65pcyWqwyVrBkf0SG5RJ/WBZ0vscC+3FpMTfDWyIgh6mY/d1UQqeAJqimVKNGbM918I+n09cBr8FRDbyhlWq6recikzTzpBE0FxbvFzAxOAkJQLs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792050512; c=relaxed/simple;
	bh=B5rHPvUMUy94Nc62agu0HJV9DdovJS5sbqwBT0crImg=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=hmRU+3IOT8fZyzsJyjAV2GMBRJs8MyP5dRS9U4JHJrPeI+16w1eWa6E/EmZQy4VJP9kc4hiLs+G69NQ3Rl90WiXG6a9ZvJXcjBvQHdx693BZA/SztcqCc1Auvms+EI0ZRgS+aQdT6jk9cQwNSRvSH9hx42gAHdieF+2J9yyxO00=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.167.200
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oi1-f200.google.com with SMTP id 5614622812f47-4cc89e86e9eso1770660b6e.3
        for <ocfs2-devel@lists.linux.dev>; Thu, 15 Oct 2026 00:48:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792050509; x=1792655309;
        h=content-type:to:from:subject:message-id:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Z1PKE5L79jyD+R9Snu6RYRvsR0qYd1dACKgpwu3b3TQ=;
        b=HMvDEbVbdhYx5842DBRjQNNKKoVsN0Xl90LVtC0tnv+cmYhuXv2oopz4rMxWNTqzqx
         Rq5KC0Nr393YhF2VhWdMpT2+1c1q3MFlLP0LYqkX9lQrmZRWKayGhFZtx8k6r6H59ZTK
         W8dGC7BxWGAnrxn83fRs/5KBBjIsJ2DtEcESuS/Ub4lWNeT8vMgSwtWd2Hjx2DedJZIo
         t9iiiIeSVBf82Qw367KQbLg66FRBMKaVky6N3npJutMV8+6lCNmgY3qn8NJF+PPGiFi+
         D3YuU7xbdQVZKcxWTCoYrrh3P9Ft+C8Yh3kXMUwfzA48+7aD1kOkDe27a2Ca6YjyBKDv
         sBxw==
X-Forwarded-Encrypted: i=1; AKwUvBze0zNFP+usOhh3rCmTwneQd1y1Ft4VorpkwVeFQhr9LcFQWfMEha6JAPG79HFxfyF7bDGGrd9DbnMPFQ==@lists.linux.dev
X-Gm-Message-State: AFq9FYKYPXz4kfRHCR5vTZzL97asEgSJ6GYAsIW2M1hNKAMI1am1rXsI
	NO+qFbOx7EXn/sO34apaA/slrzAVplyW2+/yUszGlqW+WboJMCIfIi/lHL4idc+mDw6fTXWDM+T
	wPyDQx0/2146YDMJjWQLZsEOwHvz77qRl83WGI/7y1drtsNttHVKGZTnTeK8=
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6808:6713:b0:4f6:1e12:e37d with SMTP id
 5614622812f47-50c5870a541mr16423504b6e.63.1792050508803; Thu, 15 Oct 2026
 00:48:28 -0700 (PDT)
Date: Thu, 15 Oct 2026 00:48:28 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6ad0854c.5f317f00.247b6.0064.GAE@google.com>
Subject: [syzbot] [ocfs2?] possible deadlock in ocfs2_xattr_set_handle (2)
From: syzbot <syzbot+b4732eab3dcd27c32ae6@syzkaller.appspotmail.com>
To: heming.zhao@suse.com, jlbec@evilplan.org, joseph.qi@linux.alibaba.com, 
	linux-kernel@vger.kernel.org, mark@fasheh.com, ocfs2-devel@lists.linux.dev, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    becb95e45ef0 Add linux-next specific files for 20261009
git tree:       linux-next
console output: https://syzkaller.appspot.com/x/log.txt?x=165a11d1580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=90dad226b9b89d98
dashboard link: https://syzkaller.appspot.com/bug?extid=b4732eab3dcd27c32ae6
compiler:       Debian clang version 22.1.8 (++20260613092233+e80beda6e255-1~exp1~20260613092250.77), Debian LLD 22.1.8

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/c2788d0b538b/disk-becb95e4.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/13231cbc415a/vmlinux-becb95e4.xz
kernel image: https://storage.googleapis.com/syzbot-assets/e6abf775ab73/bzImage-becb95e4.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+b4732eab3dcd27c32ae6@syzkaller.appspotmail.com

======================================================
WARNING: possible circular locking dependency detected
syzkaller #0 Tainted: G                   Y
------------------------------------------------------
syz.1.1388/11252 is trying to acquire lock:
ffff88805079b058 (&oi->ip_alloc_sem/1){+.+.}-{4:4}, at: ocfs2_xattr_set_handle+0x3fc/0x820 fs/ocfs2/xattr.c:3888

but task is already holding lock:
ffff888036ee0ce0 (&journal->j_trans_barrier){.+.+}-{4:4}, at: ocfs2_start_trans+0x3a9/0x6f0 fs/ocfs2/journal.c:370

which lock already depends on the new lock.


the existing dependency chain (in reverse order) is:

-> #2 (&journal->j_trans_barrier){.+.+}-{4:4}:
       down_read+0x45/0x320 kernel/locking/rwsem.c:1574
       ocfs2_start_trans+0x3a9/0x6f0 fs/ocfs2/journal.c:370
       ocfs2_mknod+0xf07/0x2190 fs/ocfs2/namei.c:364
       ocfs2_create+0x195/0x460 fs/ocfs2/namei.c:677
       lookup_open+0xedc/0x1970 fs/namei.c:4598
       open_last_lookups fs/namei.c:4798 [inline]
       path_openat+0x673/0x1da0 fs/namei.c:5037
       do_file_open+0x23e/0x4a0 fs/namei.c:5069
       do_sys_openat2+0x115/0x200 fs/open.c:1442
       do_sys_open fs/open.c:1448 [inline]
       __do_sys_open fs/open.c:1780 [inline]
       __se_sys_open fs/open.c:1776 [inline]
       __x64_sys_open+0x11e/0x150 fs/open.c:1776
       do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
       do_syscall_64+0x166/0x520 arch/x86/entry/syscall_64.c:84
       entry_SYSCALL_64_after_hwframe+0x77/0x7f

-> #1 (sb_internal#4){.+.+}-{0:0}:
       percpu_down_read_internal include/linux/percpu-rwsem.h:53 [inline]
       percpu_down_read_freezable include/linux/percpu-rwsem.h:83 [inline]
       __sb_start_write include/linux/fs/super.h:19 [inline]
       sb_start_intwrite include/linux/fs/super.h:177 [inline]
       ocfs2_start_trans+0x2a7/0x6f0 fs/ocfs2/journal.c:368
       ocfs2_duplicate_inline_data+0x16a/0x570 fs/ocfs2/refcounttree.c:3988
       ocfs2_reflink_remap_blocks+0x4aa/0x1ab0 fs/ocfs2/refcounttree.c:4681
       ocfs2_remap_file_range+0x451/0x6f0 fs/ocfs2/file.c:2752
       vfs_copy_file_range+0xd70/0x1340 fs/read_write.c:2309
       __do_sys_copy_file_range fs/read_write.c:2392 [inline]
       __se_sys_copy_file_range+0x2fb/0x480 fs/read_write.c:2359
       do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
       do_syscall_64+0x166/0x520 arch/x86/entry/syscall_64.c:84
       entry_SYSCALL_64_after_hwframe+0x77/0x7f

-> #0 (&oi->ip_alloc_sem/1){+.+.}-{4:4}:
       check_prev_add kernel/locking/lockdep.c:3209 [inline]
       check_prevs_add kernel/locking/lockdep.c:3328 [inline]
       validate_chain kernel/locking/lockdep.c:3952 [inline]
       __lock_acquire+0x164c/0x2de0 kernel/locking/lockdep.c:5288
       lock_acquire+0x115/0x350 kernel/locking/lockdep.c:5942
       down_write_nested+0x98/0x200 kernel/locking/rwsem.c:1757
       ocfs2_xattr_set_handle+0x3fc/0x820 fs/ocfs2/xattr.c:3888
       ocfs2_set_acl+0x6d1/0x7b0 fs/ocfs2/acl.c:250
       ocfs2_init_acl+0x1fe/0x420 fs/ocfs2/acl.c:428
       ocfs2_mknod+0x1383/0x2190 fs/ocfs2/namei.c:413
       ocfs2_mkdir+0x180/0x430 fs/ocfs2/namei.c:661
       vfs_mkdir+0x40e/0x630 fs/namei.c:5452
       filename_mkdirat+0x285/0x510 fs/namei.c:5485
       __do_sys_mkdirat fs/namei.c:5506 [inline]
       __se_sys_mkdirat+0x35/0x150 fs/namei.c:5503
       do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
       do_syscall_64+0x166/0x520 arch/x86/entry/syscall_64.c:84
       entry_SYSCALL_64_after_hwframe+0x77/0x7f

other info that might help us debug this:

Chain exists of:
  &oi->ip_alloc_sem/1 --> sb_internal#4 --> &journal->j_trans_barrier

 Possible unsafe locking scenario:

       CPU0                    CPU1
       ----                    ----
  rlock(&journal->j_trans_barrier);
                               lock(sb_internal#4);
                               lock(&journal->j_trans_barrier);
  lock(&oi->ip_alloc_sem/1);

 *** DEADLOCK ***

locks held by syz.1.1388/11252: 8, last CPU#1:
 #0: ffff888067e4c460 (sb_writers#24){.+.+}-{0:0}, at: mnt_want_write+0x41/0x90 fs/namespace.c:527
 #1: ffff8880507db3a0 (&type->i_mutex_dir_key#11/1){+.+.}-{4:4}, at: inode_lock_nested include/linux/fs.h:1069 [inline]
 #1: ffff8880507db3a0 (&type->i_mutex_dir_key#11/1){+.+.}-{4:4}, at: __start_dirop fs/namei.c:2947 [inline]
 #1: ffff8880507db3a0 (&type->i_mutex_dir_key#11/1){+.+.}-{4:4}, at: start_dirop fs/namei.c:2971 [inline]
 #1: ffff8880507db3a0 (&type->i_mutex_dir_key#11/1){+.+.}-{4:4}, at: filename_create+0x200/0x370 fs/namei.c:5132
 #2: ffff8880507e4fa0 (&ocfs2_sysfile_lock_key[INODE_ALLOC_SYSTEM_INODE]){+.+.}-{4:4}, at: inode_lock include/linux/fs.h:1024 [inline]
 #2: ffff8880507e4fa0 (&ocfs2_sysfile_lock_key[INODE_ALLOC_SYSTEM_INODE]){+.+.}-{4:4}, at: ocfs2_reserve_suballoc_bits+0x170/0x4850 fs/ocfs2/suballoc.c:904
 #3: ffff8880507e5da0 (&ocfs2_sysfile_lock_key[EXTENT_ALLOC_SYSTEM_INODE]){+.+.}-{4:4}, at: inode_lock include/linux/fs.h:1024 [inline]
 #3: ffff8880507e5da0 (&ocfs2_sysfile_lock_key[EXTENT_ALLOC_SYSTEM_INODE]){+.+.}-{4:4}, at: ocfs2_reserve_suballoc_bits+0x170/0x4850 fs/ocfs2/suballoc.c:904
 #4: ffff8880507e33a0 (&ocfs2_sysfile_lock_key[LOCAL_ALLOC_SYSTEM_INODE]){+.+.}-{4:4}, at: inode_lock include/linux/fs.h:1024 [inline]
 #4: ffff8880507e33a0 (&ocfs2_sysfile_lock_key[LOCAL_ALLOC_SYSTEM_INODE]){+.+.}-{4:4}, at: ocfs2_reserve_local_alloc_bits+0x11f/0x2680 fs/ocfs2/localalloc.c:636
 #5: ffff888067e4c650 (sb_internal#4){.+.+}-{0:0}, at: ocfs2_mknod+0xf07/0x2190 fs/ocfs2/namei.c:364
 #6: ffff888036ee0ce0 (&journal->j_trans_barrier){.+.+}-{4:4}, at: ocfs2_start_trans+0x3a9/0x6f0 fs/ocfs2/journal.c:370
 #7: ffff88802ecae950 (jbd2_handle#2){.+.+}-{0:0}, at: start_this_handle+0x1fb0/0x21f0 fs/jbd2/transaction.c:444

stack backtrace:
CPU: 1 UID: 0 PID: 11252 Comm: syz.1.1388 Tainted: G                   Y syzkaller #0 PREEMPT(full) 
Tainted: [Y]=FORCED_BIND
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 07/24/2026
Call Trace:
 <TASK>
 dump_stack_lvl+0xe8/0x150 lib/dump_stack.c:120
 print_circular_bug+0x2e2/0x300 kernel/locking/lockdep.c:2087
 check_noncircular+0x12f/0x150 kernel/locking/lockdep.c:2219
 check_prev_add kernel/locking/lockdep.c:3209 [inline]
 check_prevs_add kernel/locking/lockdep.c:3328 [inline]
 validate_chain kernel/locking/lockdep.c:3952 [inline]
 __lock_acquire+0x164c/0x2de0 kernel/locking/lockdep.c:5288
 lock_acquire+0x115/0x350 kernel/locking/lockdep.c:5942
 down_write_nested+0x98/0x200 kernel/locking/rwsem.c:1757
 ocfs2_xattr_set_handle+0x3fc/0x820 fs/ocfs2/xattr.c:3888
 ocfs2_set_acl+0x6d1/0x7b0 fs/ocfs2/acl.c:250
 ocfs2_init_acl+0x1fe/0x420 fs/ocfs2/acl.c:428
 ocfs2_mknod+0x1383/0x2190 fs/ocfs2/namei.c:413
 ocfs2_mkdir+0x180/0x430 fs/ocfs2/namei.c:661
 vfs_mkdir+0x40e/0x630 fs/namei.c:5452
 filename_mkdirat+0x285/0x510 fs/namei.c:5485
 __do_sys_mkdirat fs/namei.c:5506 [inline]
 __se_sys_mkdirat+0x35/0x150 fs/namei.c:5503
 do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
 do_syscall_64+0x166/0x520 arch/x86/entry/syscall_64.c:84
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7fbdd239e1d9
Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007fbdd3317028 EFLAGS: 00000246 ORIG_RAX: 0000000000000102
RAX: ffffffffffffffda RBX: 00007fbdd2626090 RCX: 00007fbdd239e1d9
RDX: 00000000000001ff RSI: 0000200000000040 RDI: ffffffffffffff9c
RBP: 00007fbdd2435888 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007fbdd2626128 R14: 00007fbdd2626090 R15: 00007ffdaf0dd208
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
