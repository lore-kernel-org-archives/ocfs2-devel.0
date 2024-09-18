Received: from mail-il1-f198.google.com (mail-il1-f198.google.com [209.85.166.198])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C88192AEEE
	for <ocfs2-devel@lists.linux.dev>; Wed, 18 Sep 2024 15:31:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.198
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726673499; cv=none; b=RBV9n2878w4PlyIQu0jHRZY5l6ADoozHXejEtuf/j/Bj85uiFezFGsNgU7YZCpP3V9myOTPxVENNq7ezUYbzajdDBfWplxeqgisxRRzQdb7qROtlpn3DCWKG1yK4ZCNNpHEP5SAv7Ygnb7Ptbg9YiwGg6EbKXFyTSFX5WcMzBDo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726673499; c=relaxed/simple;
	bh=uY3DCRxcISjZRwZtD6RQZGzEwt8n9WdAScZ85++Pm5M=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=VzptMgtU6DMk1RfT/5ZrZtc6z2VdsKVh9vRkZAHUlW8CBn58TYGjCkc4glGNU2r/zgVTK3CtFjfr6DGW7K4QsdEsRDB+hJ/w3wdMhSqoyzD6+OP3uDYy4Dyf+r1AAM3ooA5pc2WxvuD9OPPIHR0L25TEgQ4JkRhqkKulCp/Abso=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.198
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f198.google.com with SMTP id e9e14a558f8ab-39f5328fd5eso87621355ab.2
        for <ocfs2-devel@lists.linux.dev>; Wed, 18 Sep 2024 08:31:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726673497; x=1727278297;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=O6EMAZrh69yqH/o5Tq5Rbm9U2iVGuHTazZLo/+ehQ2Q=;
        b=C8gBr4dvG3AVG+eKJDo+KrTdd/ELksqtbc9aZhzYYJae3BvmJzbcYDDR/mCNeLmDN7
         knyG8/YxZ7hxjAx7wQpKQXXV9STSR1GBOCgU6t5Cb8fwtXPLFj55YuYtTAteJJfQAHp0
         nUwh+Fn+lWORV53YByMpn+nnZ5fUL1mkrF+0fltWHFlvuEhR/+/JJL25BXdhWM4S2/vD
         0t7q+qTqRcfib+mshyxw/cqNJcCyoKH1PCr1Ep68sOQGMXOA6Jw3SS23A+sMXOS1mHvU
         DFiw5UJ/ywF3PYNhm+qfEsv0AnPCdf2keMzoJT5NqjJjveo5Vj4Q65pQ+32b3i0ozEKP
         Fysg==
X-Forwarded-Encrypted: i=1; AJvYcCWWLQxlwpBDbLMR+qdTP6droRgG8fWGUZMEzH2onrHPiF8SJRIlletS7/ms1hjF+d4fRHlw7FHgoyzlmw==@lists.linux.dev
X-Gm-Message-State: AOJu0YwYw/JN7nRxsNv2azogfn36jQYukY6Meip3gK9MmrefSvmgy81j
	1KNsZdygIWWjWWlVK/FbRz5Kg6GCzbDPjFxSLXxfCxXybA9570dLAZ0+DBU1+PvVuq6RDshWdEn
	P707h2Il+gAy+viukF27JqKj6lOyr353CiFJ1i0SCTgLisSn+BZXaoTg=
X-Google-Smtp-Source: AGHT+IH9johNFMol8a6yKHS9wDIdAdGUdTfX8ZY0YyQmMfqlWM4OTfuSs2FY8zp5aGoW4y5gzGCVgIoI15Uw+WPV7eAp+34i2amm
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:184a:b0:3a0:436a:5f99 with SMTP id
 e9e14a558f8ab-3a08496173dmr209730225ab.21.1726673496911; Wed, 18 Sep 2024
 08:31:36 -0700 (PDT)
Date: Wed, 18 Sep 2024 08:31:36 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000006d43c106226680dd@google.com>
Subject: [syzbot] [ocfs2?] possible deadlock in ocfs2_xattr_set_handle
From: syzbot <syzbot+57c4c06621ff1840eb8d@syzkaller.appspotmail.com>
To: jlbec@evilplan.org, joseph.qi@linux.alibaba.com, 
	linux-kernel@vger.kernel.org, mark@fasheh.com, ocfs2-devel@lists.linux.dev, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    5f5673607153 Merge branch 'for-next/core' into for-kernelci
git tree:       git://git.kernel.org/pub/scm/linux/kernel/git/arm64/linux.git for-kernelci
console output: https://syzkaller.appspot.com/x/log.txt?x=10c2e7c7980000
kernel config:  https://syzkaller.appspot.com/x/.config?x=dedbcb1ff4387972
dashboard link: https://syzkaller.appspot.com/bug?extid=57c4c06621ff1840eb8d
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40
userspace arch: arm64

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/40172aed5414/disk-5f567360.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/58372f305e9d/vmlinux-5f567360.xz
kernel image: https://storage.googleapis.com/syzbot-assets/d2aae6fa798f/Image-5f567360.gz.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+57c4c06621ff1840eb8d@syzkaller.appspotmail.com

JBD2: Ignoring recovery information on journal
ocfs2: Mounting device (7,4) on (node local, slot 0) with ordered data mode.
======================================================
WARNING: possible circular locking dependency detected
6.11.0-rc7-syzkaller-g5f5673607153 #0 Not tainted
------------------------------------------------------
syz.4.366/8699 is trying to acquire lock:
ffff0000db5b3ff8 (&oi->ip_xattr_sem){+.+.}-{3:3}, at: ocfs2_xattr_set_handle+0x40c/0x824 fs/ocfs2/xattr.c:3502

but task is already holding lock:
ffff0000ee34c958 (jbd2_handle){++++}-{0:0}, at: start_this_handle+0xf0c/0x11c4 fs/jbd2/transaction.c:446

which lock already depends on the new lock.


the existing dependency chain (in reverse order) is:

-> #5 (jbd2_handle){++++}-{0:0}:
       start_this_handle+0xf34/0x11c4 fs/jbd2/transaction.c:448
       jbd2__journal_start+0x298/0x544 fs/jbd2/transaction.c:505
       jbd2_journal_start+0x3c/0x4c fs/jbd2/transaction.c:544
       ocfs2_start_trans+0x3d0/0x71c fs/ocfs2/journal.c:352
       ocfs2_block_group_alloc fs/ocfs2/suballoc.c:685 [inline]
       ocfs2_reserve_suballoc_bits+0x840/0x4288 fs/ocfs2/suballoc.c:832
       ocfs2_reserve_new_metadata_blocks+0x384/0x848 fs/ocfs2/suballoc.c:982
       ocfs2_init_xattr_set_ctxt+0x394/0x968 fs/ocfs2/xattr.c:3278
       ocfs2_xattr_set+0xbe0/0x1448 fs/ocfs2/xattr.c:3635
       ocfs2_set_acl+0x410/0x4b4 fs/ocfs2/acl.c:254
       ocfs2_iop_set_acl+0x230/0x374 fs/ocfs2/acl.c:286
       set_posix_acl fs/posix_acl.c:955 [inline]
       vfs_set_acl+0x7a0/0xa24 fs/posix_acl.c:1134
       do_set_acl+0xe4/0x1ac fs/posix_acl.c:1279
       do_setxattr fs/xattr.c:626 [inline]
       path_setxattr+0x334/0x428 fs/xattr.c:658
       __do_sys_lsetxattr fs/xattr.c:683 [inline]
       __se_sys_lsetxattr fs/xattr.c:679 [inline]
       __arm64_sys_lsetxattr+0xbc/0xd8 fs/xattr.c:679
       __invoke_syscall arch/arm64/kernel/syscall.c:35 [inline]
       invoke_syscall+0x98/0x2b8 arch/arm64/kernel/syscall.c:49
       el0_svc_common+0x130/0x23c arch/arm64/kernel/syscall.c:132
       do_el0_svc+0x48/0x58 arch/arm64/kernel/syscall.c:151
       el0_svc+0x54/0x168 arch/arm64/kernel/entry-common.c:712
       el0t_64_sync_handler+0x84/0xfc arch/arm64/kernel/entry-common.c:730
       el0t_64_sync+0x190/0x194 arch/arm64/kernel/entry.S:598

-> #4 (&journal->j_trans_barrier){.+.+}-{3:3}:
       down_read+0x58/0x2fc kernel/locking/rwsem.c:1526
       ocfs2_start_trans+0x3c4/0x71c fs/ocfs2/journal.c:350
       ocfs2_block_group_alloc fs/ocfs2/suballoc.c:685 [inline]
       ocfs2_reserve_suballoc_bits+0x840/0x4288 fs/ocfs2/suballoc.c:832
       ocfs2_reserve_new_metadata_blocks+0x384/0x848 fs/ocfs2/suballoc.c:982
       ocfs2_init_xattr_set_ctxt+0x394/0x968 fs/ocfs2/xattr.c:3278
       ocfs2_xattr_set+0xbe0/0x1448 fs/ocfs2/xattr.c:3635
       ocfs2_set_acl+0x410/0x4b4 fs/ocfs2/acl.c:254
       ocfs2_iop_set_acl+0x230/0x374 fs/ocfs2/acl.c:286
       set_posix_acl fs/posix_acl.c:955 [inline]
       vfs_set_acl+0x7a0/0xa24 fs/posix_acl.c:1134
       do_set_acl+0xe4/0x1ac fs/posix_acl.c:1279
       do_setxattr fs/xattr.c:626 [inline]
       path_setxattr+0x334/0x428 fs/xattr.c:658
       __do_sys_lsetxattr fs/xattr.c:683 [inline]
       __se_sys_lsetxattr fs/xattr.c:679 [inline]
       __arm64_sys_lsetxattr+0xbc/0xd8 fs/xattr.c:679
       __invoke_syscall arch/arm64/kernel/syscall.c:35 [inline]
       invoke_syscall+0x98/0x2b8 arch/arm64/kernel/syscall.c:49
       el0_svc_common+0x130/0x23c arch/arm64/kernel/syscall.c:132
       do_el0_svc+0x48/0x58 arch/arm64/kernel/syscall.c:151
       el0_svc+0x54/0x168 arch/arm64/kernel/entry-common.c:712
       el0t_64_sync_handler+0x84/0xfc arch/arm64/kernel/entry-common.c:730
       el0t_64_sync+0x190/0x194 arch/arm64/kernel/entry.S:598

-> #3 (sb_internal#5){.+.+}-{0:0}:
       percpu_down_read include/linux/percpu-rwsem.h:51 [inline]
       __sb_start_write include/linux/fs.h:1676 [inline]
       sb_start_intwrite include/linux/fs.h:1859 [inline]
       ocfs2_start_trans+0x244/0x71c fs/ocfs2/journal.c:348
       ocfs2_block_group_alloc fs/ocfs2/suballoc.c:685 [inline]
       ocfs2_reserve_suballoc_bits+0x840/0x4288 fs/ocfs2/suballoc.c:832
       ocfs2_reserve_new_metadata_blocks+0x384/0x848 fs/ocfs2/suballoc.c:982
       ocfs2_init_xattr_set_ctxt+0x394/0x968 fs/ocfs2/xattr.c:3278
       ocfs2_xattr_set+0xbe0/0x1448 fs/ocfs2/xattr.c:3635
       ocfs2_set_acl+0x410/0x4b4 fs/ocfs2/acl.c:254
       ocfs2_iop_set_acl+0x230/0x374 fs/ocfs2/acl.c:286
       set_posix_acl fs/posix_acl.c:955 [inline]
       vfs_set_acl+0x7a0/0xa24 fs/posix_acl.c:1134
       do_set_acl+0xe4/0x1ac fs/posix_acl.c:1279
       do_setxattr fs/xattr.c:626 [inline]
       path_setxattr+0x334/0x428 fs/xattr.c:658
       __do_sys_lsetxattr fs/xattr.c:683 [inline]
       __se_sys_lsetxattr fs/xattr.c:679 [inline]
       __arm64_sys_lsetxattr+0xbc/0xd8 fs/xattr.c:679
       __invoke_syscall arch/arm64/kernel/syscall.c:35 [inline]
       invoke_syscall+0x98/0x2b8 arch/arm64/kernel/syscall.c:49
       el0_svc_common+0x130/0x23c arch/arm64/kernel/syscall.c:132
       do_el0_svc+0x48/0x58 arch/arm64/kernel/syscall.c:151
       el0_svc+0x54/0x168 arch/arm64/kernel/entry-common.c:712
       el0t_64_sync_handler+0x84/0xfc arch/arm64/kernel/entry-common.c:730
       el0t_64_sync+0x190/0x194 arch/arm64/kernel/entry.S:598

-> #2 (&ocfs2_sysfile_lock_key[args->fi_sysfile_type]#4){+.+.}-{3:3}:
       down_write+0x50/0xc0 kernel/locking/rwsem.c:1579
       inode_lock include/linux/fs.h:800 [inline]
       ocfs2_reserve_suballoc_bits+0x164/0x4288 fs/ocfs2/suballoc.c:786
       ocfs2_reserve_cluster_bitmap_bits fs/ocfs2/suballoc.c:1132 [inline]
       ocfs2_reserve_clusters_with_limit+0x2ac/0xabc fs/ocfs2/suballoc.c:1177
       ocfs2_block_group_alloc fs/ocfs2/suballoc.c:674 [inline]
       ocfs2_reserve_suballoc_bits+0x820/0x4288 fs/ocfs2/suballoc.c:832
       ocfs2_reserve_new_metadata_blocks+0x384/0x848 fs/ocfs2/suballoc.c:982
       ocfs2_init_xattr_set_ctxt+0x394/0x968 fs/ocfs2/xattr.c:3278
       ocfs2_xattr_set+0xbe0/0x1448 fs/ocfs2/xattr.c:3635
       ocfs2_set_acl+0x410/0x4b4 fs/ocfs2/acl.c:254
       ocfs2_iop_set_acl+0x230/0x374 fs/ocfs2/acl.c:286
       set_posix_acl fs/posix_acl.c:955 [inline]
       vfs_set_acl+0x7a0/0xa24 fs/posix_acl.c:1134
       do_set_acl+0xe4/0x1ac fs/posix_acl.c:1279
       do_setxattr fs/xattr.c:626 [inline]
       path_setxattr+0x334/0x428 fs/xattr.c:658
       __do_sys_lsetxattr fs/xattr.c:683 [inline]
       __se_sys_lsetxattr fs/xattr.c:679 [inline]
       __arm64_sys_lsetxattr+0xbc/0xd8 fs/xattr.c:679
       __invoke_syscall arch/arm64/kernel/syscall.c:35 [inline]
       invoke_syscall+0x98/0x2b8 arch/arm64/kernel/syscall.c:49
       el0_svc_common+0x130/0x23c arch/arm64/kernel/syscall.c:132
       do_el0_svc+0x48/0x58 arch/arm64/kernel/syscall.c:151
       el0_svc+0x54/0x168 arch/arm64/kernel/entry-common.c:712
       el0t_64_sync_handler+0x84/0xfc arch/arm64/kernel/entry-common.c:730
       el0t_64_sync+0x190/0x194 arch/arm64/kernel/entry.S:598

-> #1 (&ocfs2_sysfile_lock_key[args->fi_sysfile_type]#3){+.+.}-{3:3}:
       down_write+0x50/0xc0 kernel/locking/rwsem.c:1579
       inode_lock include/linux/fs.h:800 [inline]
       ocfs2_reserve_suballoc_bits+0x164/0x4288 fs/ocfs2/suballoc.c:786
       ocfs2_reserve_new_metadata_blocks+0x384/0x848 fs/ocfs2/suballoc.c:982
       ocfs2_init_xattr_set_ctxt+0x394/0x968 fs/ocfs2/xattr.c:3278
       ocfs2_xattr_set+0xbe0/0x1448 fs/ocfs2/xattr.c:3635
       ocfs2_set_acl+0x410/0x4b4 fs/ocfs2/acl.c:254
       ocfs2_iop_set_acl+0x230/0x374 fs/ocfs2/acl.c:286
       set_posix_acl fs/posix_acl.c:955 [inline]
       vfs_set_acl+0x7a0/0xa24 fs/posix_acl.c:1134
       do_set_acl+0xe4/0x1ac fs/posix_acl.c:1279
       do_setxattr fs/xattr.c:626 [inline]
       path_setxattr+0x334/0x428 fs/xattr.c:658
       __do_sys_lsetxattr fs/xattr.c:683 [inline]
       __se_sys_lsetxattr fs/xattr.c:679 [inline]
       __arm64_sys_lsetxattr+0xbc/0xd8 fs/xattr.c:679
       __invoke_syscall arch/arm64/kernel/syscall.c:35 [inline]
       invoke_syscall+0x98/0x2b8 arch/arm64/kernel/syscall.c:49
       el0_svc_common+0x130/0x23c arch/arm64/kernel/syscall.c:132
       do_el0_svc+0x48/0x58 arch/arm64/kernel/syscall.c:151
       el0_svc+0x54/0x168 arch/arm64/kernel/entry-common.c:712
       el0t_64_sync_handler+0x84/0xfc arch/arm64/kernel/entry-common.c:730
       el0t_64_sync+0x190/0x194 arch/arm64/kernel/entry.S:598

-> #0 (&oi->ip_xattr_sem){+.+.}-{3:3}:
       check_prev_add kernel/locking/lockdep.c:3133 [inline]
       check_prevs_add kernel/locking/lockdep.c:3252 [inline]
       validate_chain kernel/locking/lockdep.c:3868 [inline]
       __lock_acquire+0x33d8/0x779c kernel/locking/lockdep.c:5142
       lock_acquire+0x240/0x728 kernel/locking/lockdep.c:5759
       down_write+0x50/0xc0 kernel/locking/rwsem.c:1579
       ocfs2_xattr_set_handle+0x40c/0x824 fs/ocfs2/xattr.c:3502
       ocfs2_init_security_set+0xb4/0xd8 fs/ocfs2/xattr.c:7326
       ocfs2_mknod+0x1408/0x243c fs/ocfs2/namei.c:417
       ocfs2_create+0x194/0x4e0 fs/ocfs2/namei.c:672
       lookup_open fs/namei.c:3578 [inline]
       open_last_lookups fs/namei.c:3647 [inline]
       path_openat+0xfb4/0x29f8 fs/namei.c:3883
       do_filp_open+0x1bc/0x3cc fs/namei.c:3913
       do_sys_openat2+0x124/0x1b8 fs/open.c:1416
       do_sys_open fs/open.c:1431 [inline]
       __do_sys_openat fs/open.c:1447 [inline]
       __se_sys_openat fs/open.c:1442 [inline]
       __arm64_sys_openat+0x1f0/0x240 fs/open.c:1442
       __invoke_syscall arch/arm64/kernel/syscall.c:35 [inline]
       invoke_syscall+0x98/0x2b8 arch/arm64/kernel/syscall.c:49
       el0_svc_common+0x130/0x23c arch/arm64/kernel/syscall.c:132
       do_el0_svc+0x48/0x58 arch/arm64/kernel/syscall.c:151
       el0_svc+0x54/0x168 arch/arm64/kernel/entry-common.c:712
       el0t_64_sync_handler+0x84/0xfc arch/arm64/kernel/entry-common.c:730
       el0t_64_sync+0x190/0x194 arch/arm64/kernel/entry.S:598

other info that might help us debug this:

Chain exists of:
  &oi->ip_xattr_sem --> &journal->j_trans_barrier --> jbd2_handle

 Possible unsafe locking scenario:

       CPU0                    CPU1
       ----                    ----
  rlock(jbd2_handle);
                               lock(&journal->j_trans_barrier);
                               lock(jbd2_handle);
  lock(&oi->ip_xattr_sem);

 *** DEADLOCK ***

8 locks held by syz.4.366/8699:
 #0: ffff0000d3e98420 (sb_writers#17){.+.+}-{0:0}, at: mnt_want_write+0x44/0x9c fs/namespace.c:515
 #1: ffff0000dc8189c0 (&type->i_mutex_dir_key#12){+.+.}-{3:3}, at: inode_lock include/linux/fs.h:800 [inline]
 #1: ffff0000dc8189c0 (&type->i_mutex_dir_key#12){+.+.}-{3:3}, at: open_last_lookups fs/namei.c:3644 [inline]
 #1: ffff0000dc8189c0 (&type->i_mutex_dir_key#12){+.+.}-{3:3}, at: path_openat+0x5f4/0x29f8 fs/namei.c:3883
 #2: ffff0000db5b5100 (&ocfs2_sysfile_lock_key[args->fi_sysfile_type]#6){+.+.}-{3:3}, at: inode_lock include/linux/fs.h:800 [inline]
 #2: ffff0000db5b5100 (&ocfs2_sysfile_lock_key[args->fi_sysfile_type]#6){+.+.}-{3:3}, at: ocfs2_reserve_suballoc_bits+0x164/0x4288 fs/ocfs2/suballoc.c:786
 #3: ffff0000dc81ed80 (&ocfs2_sysfile_lock_key[args->fi_sysfile_type]#3){+.+.}-{3:3}, at: inode_lock include/linux/fs.h:800 [inline]
 #3: ffff0000dc81ed80 (&ocfs2_sysfile_lock_key[args->fi_sysfile_type]#3){+.+.}-{3:3}, at: ocfs2_reserve_suballoc_bits+0x164/0x4288 fs/ocfs2/suballoc.c:786
 #4: ffff0000db5b3480 (&ocfs2_sysfile_lock_key[args->fi_sysfile_type]#5){+.+.}-{3:3}, at: inode_lock include/linux/fs.h:800 [inline]
 #4: ffff0000db5b3480 (&ocfs2_sysfile_lock_key[args->fi_sysfile_type]#5){+.+.}-{3:3}, at: ocfs2_reserve_local_alloc_bits+0xfc/0x247c fs/ocfs2/localalloc.c:636
 #5: ffff0000d3e98610 (sb_internal#5){.+.+}-{0:0}, at: ocfs2_mknod+0xe58/0x243c fs/ocfs2/namei.c:359
 #6: ffff0000ed7c30e8 (&journal->j_trans_barrier){.+.+}-{3:3}, at: ocfs2_start_trans+0x3c4/0x71c fs/ocfs2/journal.c:350
 #7: ffff0000ee34c958 (jbd2_handle){++++}-{0:0}, at: start_this_handle+0xf0c/0x11c4 fs/jbd2/transaction.c:446

stack backtrace:
CPU: 1 UID: 0 PID: 8699 Comm: syz.4.366 Not tainted 6.11.0-rc7-syzkaller-g5f5673607153 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 08/06/2024
Call trace:
 dump_backtrace+0x1b8/0x1e4 arch/arm64/kernel/stacktrace.c:319
 show_stack+0x2c/0x3c arch/arm64/kernel/stacktrace.c:326
 __dump_stack lib/dump_stack.c:93 [inline]
 dump_stack_lvl+0xe4/0x150 lib/dump_stack.c:119
 dump_stack+0x1c/0x28 lib/dump_stack.c:128
 print_circular_bug+0x150/0x1b8 kernel/locking/lockdep.c:2059
 check_noncircular+0x310/0x404 kernel/locking/lockdep.c:2186
 check_prev_add kernel/locking/lockdep.c:3133 [inline]
 check_prevs_add kernel/locking/lockdep.c:3252 [inline]
 validate_chain kernel/locking/lockdep.c:3868 [inline]
 __lock_acquire+0x33d8/0x779c kernel/locking/lockdep.c:5142
 lock_acquire+0x240/0x728 kernel/locking/lockdep.c:5759
 down_write+0x50/0xc0 kernel/locking/rwsem.c:1579
 ocfs2_xattr_set_handle+0x40c/0x824 fs/ocfs2/xattr.c:3502
 ocfs2_init_security_set+0xb4/0xd8 fs/ocfs2/xattr.c:7326
 ocfs2_mknod+0x1408/0x243c fs/ocfs2/namei.c:417
 ocfs2_create+0x194/0x4e0 fs/ocfs2/namei.c:672
 lookup_open fs/namei.c:3578 [inline]
 open_last_lookups fs/namei.c:3647 [inline]
 path_openat+0xfb4/0x29f8 fs/namei.c:3883
 do_filp_open+0x1bc/0x3cc fs/namei.c:3913
 do_sys_openat2+0x124/0x1b8 fs/open.c:1416
 do_sys_open fs/open.c:1431 [inline]
 __do_sys_openat fs/open.c:1447 [inline]
 __se_sys_openat fs/open.c:1442 [inline]
 __arm64_sys_openat+0x1f0/0x240 fs/open.c:1442
 __invoke_syscall arch/arm64/kernel/syscall.c:35 [inline]
 invoke_syscall+0x98/0x2b8 arch/arm64/kernel/syscall.c:49
 el0_svc_common+0x130/0x23c arch/arm64/kernel/syscall.c:132
 do_el0_svc+0x48/0x58 arch/arm64/kernel/syscall.c:151
 el0_svc+0x54/0x168 arch/arm64/kernel/entry-common.c:712
 el0t_64_sync_handler+0x84/0xfc arch/arm64/kernel/entry-common.c:730
 el0t_64_sync+0x190/0x194 arch/arm64/kernel/entry.S:598


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
