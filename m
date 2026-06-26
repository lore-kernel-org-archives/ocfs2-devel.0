Received: from mail-vk1-f171.google.com (mail-vk1-f171.google.com [209.85.221.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E12023BFE20
	for <ocfs2-devel@lists.linux.dev>; Fri, 26 Jun 2026 21:26:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782509215; cv=none; b=EfET69y+V4KcxLebo/XxryAEEUdigIZT5RriKogndwdLUMBEVQE+M8JUsDfbbi3aFIDZDyMWMQdH3BXSvwUMD712W+45QYwndeITVh3z1uGEabPMdbrI5tUEcdVzr5P59aDJfHp+35+6hGi72VhYCTmAz14IBluo3F1DEp+UdXs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782509215; c=relaxed/simple;
	bh=sxX6Cdl55r277AKR7hnTz2xgfvgXwCPmbvoRGPFvrHY=;
	h=Message-ID:Date:Subject:To:Cc:Content-Type:MIME-Version:From; b=iQn8rbqm8NP7FXG4RJlUTj2eEIZJ8QIwJzAqw1jnZoMAwpHxe+yVmyHLQjytdoDAXayApaYp4PYGH1sstwvlsvHEkqIsqvSjZ/58cgX6MhocrQa0IftNHDJdG/M4KV8Z5/Jgc1CwGbwL7Gv3bIIq2mHvx8zhOpY1NHZdkPsyNsk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=X5lcKTQO; arc=none smtp.client-ip=209.85.221.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="X5lcKTQO"
Received: by mail-vk1-f171.google.com with SMTP id 71dfb90a1353d-5bd6cf9ee13so42569e0c.2
        for <ocfs2-devel@lists.linux.dev>; Fri, 26 Jun 2026 14:26:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782509213; x=1783114013; darn=lists.linux.dev;
        h=from:mime-version:content-transfer-encoding:content-type:cc:to
         :subject:date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=+7GWc8Odun69XK84kBWN/GoXB+HAGy83XNhHgT6liQo=;
        b=X5lcKTQO1EUG80/6IobKBQs9JN0TEACNYkNnPdNzqX3mbvM1+XjNzDLphERAtaXVAx
         Ej2O1Gqc22TSsGlGRwMTPYx2C0CfNBEaG/gWlNwCc7/8qsj9Qrans8oXpKkScYhgOikg
         eEjK/zN+WXoV5kX4YyD2OdkZI5tuLCJn+UPHla4orU1KbqNu/Z/0UyfFwnOsThDTDFP7
         dHZDr0jrS9+n0eg1YiICKcPtHcU1wl/OCxQmBi7Ec55djIUmMyteKUq2efzaT/GYfMsK
         VJ7RVNlai31KFb5YwxsS9nyl60x+OF/HGz/MFU3NchbDCbldhvaKoZFJGjPiY+Eb1wFX
         Krsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782509213; x=1783114013;
        h=from:mime-version:content-transfer-encoding:content-type:cc:to
         :subject:date:message-id:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=+7GWc8Odun69XK84kBWN/GoXB+HAGy83XNhHgT6liQo=;
        b=Lore785O8RBm68K5lQc6MGFYXy3yPUGa91yKiaB6xQfnuxSL+TSP506PLlCwqAuQB3
         G2nwaBXUSmbndTA2hIVGdQRjP9lSfqdP8aP8E1CXuQQHyml97QDXolRqtPvGbNCVleCu
         UkLDedEuI8w0uIQH6lAsQJlhrtOlzsWeJMav97dJi9mAZtf2iATL+MtLhsEAn/0Lz4Nf
         uWFJMhHpCjVVBSHPefqYJ3UtVqVFnDjpp2PakT+PhbnCZILyNyXm1JBhmTmZUzxufmmZ
         zvhmczEDdfJmW8yH6pfByNqBgPnjcLeSZrZ9WELpBXfYmHZl79QZy3EyU8xNp8WCqP26
         9dAA==
X-Forwarded-Encrypted: i=1; AHgh+RoCC9mB0F9MhxPEbmcUNP0nUWUhxO1Q6HZSov3q3RScK7fywPKmplPXM0qwN/hD0DMw1W9h9PUzJlMIaw==@lists.linux.dev
X-Gm-Message-State: AOJu0Yy7p7AE+wRLeg/T403vgLu7KCS3icSeR/L/M5uWxNOYCOkM+UmX
	mFn/LpqOISYRLmJexp9kmSko575GFTzBVpb5VSBv4XPfou2XaE/vP/gm
X-Gm-Gg: AfdE7ckljY8vwMNLPlETfvZLvrI9qb3C1yWGkj11ACxwv/uZ58FEbmVuAwmiqRLh4aJ
	3/HhATjT8KfWFWIdsz2WzOkWTLYh0YYIBHQbu7RrtgIg9uzAZgl5cIkliuteCVFVoJqXhKSl9aJ
	w0WnEvhe1l4/XmEXJ0GxSBOC4tzFr2akcmyewUtVp4OzCfSb/bMkgTVANVDdkHsWF/NRLNk9szZ
	hECP1cKDKdNdBidRUPxwSKWwh+wnPNhOvLkBErlnbnx+j3I5spIsOs98AzD5yUqdjEmPu851IJq
	CYcQyvEZXW+BcKPM5qETyJXrWbeb8XCUDqXyP208bq3L6Jz6hN5c/avAIDfJ21vuPo5tEdvItjc
	kBGe8Suz85kEx+po01hTEqOj+S7u4T/Kym6gF02pXKu9wI2UAsNeZC2i9ddcyBY6e3sU+xBtpWB
	WHtKeksawRLv2Kdgqip7NdRInv5RN8JDZToh/65y6wRoE8rITJMKeqvCfSfBeei6ALurkLzTqmM
	p8HfKk4Czbk
X-Received: by 2002:ac5:c7cd:0:b0:56f:8cf9:33c8 with SMTP id 71dfb90a1353d-5bd69d7efbcmr1211323e0c.2.1782509212838;
        Fri, 26 Jun 2026 14:26:52 -0700 (PDT)
Received: from [192.168.10.115] ([132.170.207.48])
        by smtp.gmail.com with ESMTPSA id 71dfb90a1353d-5bd78ebc2dfsm1907575e0c.7.2026.06.26.14.26.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 26 Jun 2026 14:26:51 -0700 (PDT)
Message-ID: <6a3eee9b.2993ad8c.bcd12.9c5f@mx.google.com>
Date: Fri, 26 Jun 2026 14:26:51 -0700 (PDT)
Subject: possible deadlock in ocfs2_init_acl
To: mark@fasheh.com, jlbec@evilplan.org, joseph.qi@linux.alibaba.com,
 ocfs2-devel@lists.linux.dev, linux-kernel@vger.kernel.org
Cc: syzkaller@googlegroups.com, contact@pgazz.com
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
From: sanan.hasanou@gmail.com

Good day, dear maintainers,

We found a bug using a modified version of syzkaller.

Kernel Branch: 7.0-rc1
Kernel Config: <https://drive.google.com/open?id=1sVxTU3tztwbXVxVud4pFzl2EIDdR3aOC>
Unfortunately, we don't have any reproducer for this bug yet.
Thank you!

Best regards,
Sanan Hasanov

======================================================
WARNING: possible circular locking dependency detected
7.0.0-rc1 #1 Tainted: G             L     
------------------------------------------------------
syz.6.5469/41562 is trying to acquire lock:
ffff88804e21bff8 (&oi->ip_xattr_sem){++++}-{4:4}, at: ocfs2_init_acl+0x2f7/0x7a0 fs/ocfs2/acl.c:367

but task is already holding lock:
ffff8880655f28e8 (&journal->j_trans_barrier){.+.+}-{4:4}, at: ocfs2_start_trans+0x36a/0x6d0 fs/ocfs2/journal.c:369

which lock already depends on the new lock.


the existing dependency chain (in reverse order) is:

-> #3 (&journal->j_trans_barrier){.+.+}-{4:4}:
       down_read+0x47/0x2e0 kernel/locking/rwsem.c:1537
       ocfs2_start_trans+0x36a/0x6d0 fs/ocfs2/journal.c:369
       ocfs2_local_alloc_slide_window fs/ocfs2/localalloc.c:1252 [inline]
       ocfs2_reserve_local_alloc_bits+0xaef/0x2580 fs/ocfs2/localalloc.c:669
       ocfs2_reserve_clusters_with_limit+0x1be/0xba0 fs/ocfs2/suballoc.c:1237
       ocfs2_expand_inline_dir fs/ocfs2/dir.c:2882 [inline]
       ocfs2_extend_dir+0x700/0x47f0 fs/ocfs2/dir.c:3227
       ocfs2_prepare_dir_for_insert+0x3098/0x4f00 fs/ocfs2/dir.c:4345
       ocfs2_mknod+0x803/0x20c0 fs/ocfs2/namei.c:298
       ocfs2_mkdir+0x181/0x470 fs/ocfs2/namei.c:660
       vfs_mkdir+0x408/0x620 fs/namei.c:5233
       filename_mkdirat+0x27b/0x500 fs/namei.c:5266
       __do_sys_mkdirat fs/namei.c:5287 [inline]
       __se_sys_mkdirat+0x35/0x150 fs/namei.c:5284
       do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
       do_syscall_64+0x160/0xfc0 arch/x86/entry/syscall_64.c:94
       entry_SYSCALL_64_after_hwframe+0x4b/0x53

-> #2 (sb_internal#5){.+.+}-{0:0}:
       percpu_down_read_internal include/linux/percpu-rwsem.h:53 [inline]
       percpu_down_read_freezable include/linux/percpu-rwsem.h:83 [inline]
       __sb_start_write include/linux/fs/super.h:19 [inline]
       sb_start_intwrite include/linux/fs/super.h:177 [inline]
       ocfs2_start_trans+0x26b/0x6d0 fs/ocfs2/journal.c:367
       ocfs2_write_begin_inline fs/ocfs2/aops.c:1458 [inline]
       ocfs2_try_to_write_inline_data fs/ocfs2/aops.c:1562 [inline]
       ocfs2_write_begin_nolock+0x1c90/0x3f60 fs/ocfs2/aops.c:1648
       ocfs2_write_begin+0x1bb/0x310 fs/ocfs2/aops.c:1883
       generic_perform_write+0x2be/0x8f0 mm/filemap.c:4314
       ocfs2_file_write_iter+0x1555/0x1d80 fs/ocfs2/file.c:2476
       new_sync_write fs/read_write.c:595 [inline]
       vfs_write+0x5dc/0xb40 fs/read_write.c:688
       ksys_write+0x143/0x250 fs/read_write.c:740
       do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
       do_syscall_64+0x160/0xfc0 arch/x86/entry/syscall_64.c:94
       entry_SYSCALL_64_after_hwframe+0x4b/0x53

-> #1 (&oi->ip_alloc_sem){++++}-{4:4}:
       down_write+0x96/0x1f0 kernel/locking/rwsem.c:1590
       ocfs2_try_remove_refcount_tree+0xb6/0x320 fs/ocfs2/refcounttree.c:933
       ocfs2_truncate_file+0xd9d/0x14a0 fs/ocfs2/file.c:522
       ocfs2_setattr+0x15ff/0x1cc0 fs/ocfs2/file.c:1219
       notify_change+0xc13/0xf30 fs/attr.c:556
       do_truncate+0x1a4/0x210 fs/open.c:68
       handle_truncate fs/namei.c:4279 [inline]
       do_open fs/namei.c:4675 [inline]
       path_openat+0x2e84/0x3740 fs/namei.c:4830
       do_file_open+0x203/0x440 fs/namei.c:4859
       do_sys_openat2+0x105/0x1e0 fs/open.c:1366
       do_sys_open fs/open.c:1372 [inline]
       __do_sys_openat fs/open.c:1388 [inline]
       __se_sys_openat fs/open.c:1383 [inline]
       __x64_sys_openat+0x138/0x160 fs/open.c:1383
       do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
       do_syscall_64+0x160/0xfc0 arch/x86/entry/syscall_64.c:94
       entry_SYSCALL_64_after_hwframe+0x4b/0x53

-> #0 (&oi->ip_xattr_sem){++++}-{4:4}:
       check_prev_add kernel/locking/lockdep.c:3165 [inline]
       check_prevs_add kernel/locking/lockdep.c:3284 [inline]
       validate_chain kernel/locking/lockdep.c:3908 [inline]
       __lock_acquire+0x159d/0x2ce0 kernel/locking/lockdep.c:5237
       lock_acquire+0xf1/0x2e0 kernel/locking/lockdep.c:5868
       down_read+0x47/0x2e0 kernel/locking/rwsem.c:1537
       ocfs2_init_acl+0x2f7/0x7a0 fs/ocfs2/acl.c:367
       ocfs2_mknod+0x1327/0x20c0 fs/ocfs2/namei.c:414
       ocfs2_mkdir+0x181/0x470 fs/ocfs2/namei.c:660
       vfs_mkdir+0x408/0x620 fs/namei.c:5233
       filename_mkdirat+0x27b/0x500 fs/namei.c:5266
       __do_sys_mkdirat fs/namei.c:5287 [inline]
       __se_sys_mkdirat+0x35/0x150 fs/namei.c:5284
       do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
       do_syscall_64+0x160/0xfc0 arch/x86/entry/syscall_64.c:94
       entry_SYSCALL_64_after_hwframe+0x4b/0x53

other info that might help us debug this:

Chain exists of:
  &oi->ip_xattr_sem --> sb_internal#5 --> &journal->j_trans_barrier

 Possible unsafe locking scenario:

       CPU0                    CPU1
       ----                    ----
  rlock(&journal->j_trans_barrier);
                               lock(sb_internal#5);
                               lock(&journal->j_trans_barrier);
  rlock(&oi->ip_xattr_sem);

 *** DEADLOCK ***

8 locks held by syz.6.5469/41562:
 #0: ffff8880280e6410 (sb_writers#24){.+.+}-{0:0}, at: mnt_want_write+0x41/0x90 fs/namespace.c:493
 #1: ffff88804e21c2c0 (&type->i_mutex_dir_key#15/1){+.+.}-{4:4}, at: inode_lock_nested include/linux/fs.h:1073 [inline]
 #1: ffff88804e21c2c0 (&type->i_mutex_dir_key#15/1){+.+.}-{4:4}, at: __start_dirop fs/namei.c:2923 [inline]
 #1: ffff88804e21c2c0 (&type->i_mutex_dir_key#15/1){+.+.}-{4:4}, at: start_dirop fs/namei.c:2934 [inline]
 #1: ffff88804e21c2c0 (&type->i_mutex_dir_key#15/1){+.+.}-{4:4}, at: filename_create+0x1fb/0x360 fs/namei.c:4922
 #2: ffff888059a65f40 (&ocfs2_sysfile_lock_key[INODE_ALLOC_SYSTEM_INODE]){+.+.}-{4:4}, at: inode_lock include/linux/fs.h:1028 [inline]
 #2: ffff888059a65f40 (&ocfs2_sysfile_lock_key[INODE_ALLOC_SYSTEM_INODE]){+.+.}-{4:4}, at: ocfs2_reserve_suballoc_bits+0x168/0x46a0 fs/ocfs2/suballoc.c:857
 #3: ffff888059a66d80 (&ocfs2_sysfile_lock_key[EXTENT_ALLOC_SYSTEM_INODE]){+.+.}-{4:4}, at: inode_lock include/linux/fs.h:1028 [inline]
 #3: ffff888059a66d80 (&ocfs2_sysfile_lock_key[EXTENT_ALLOC_SYSTEM_INODE]){+.+.}-{4:4}, at: ocfs2_reserve_suballoc_bits+0x168/0x46a0 fs/ocfs2/suballoc.c:857
 #4: ffff888059a642c0 (&ocfs2_sysfile_lock_key[LOCAL_ALLOC_SYSTEM_INODE]){+.+.}-{4:4}, at: inode_lock include/linux/fs.h:1028 [inline]
 #4: ffff888059a642c0 (&ocfs2_sysfile_lock_key[LOCAL_ALLOC_SYSTEM_INODE]){+.+.}-{4:4}, at: ocfs2_reserve_local_alloc_bits+0x125/0x2580 fs/ocfs2/localalloc.c:636
 #5: ffff8880280e6600 (sb_internal#5){.+.+}-{0:0}, at: ocfs2_mknod+0xe97/0x20c0 fs/ocfs2/namei.c:365
 #6: ffff8880655f28e8 (&journal->j_trans_barrier){.+.+}-{4:4}, at: ocfs2_start_trans+0x36a/0x6d0 fs/ocfs2/journal.c:369
 #7: ffff88801cd92950 (jbd2_handle#2){.+.+}-{0:0}, at: start_this_handle+0x1f82/0x21c0 fs/jbd2/transaction.c:444

stack backtrace:
CPU: 0 UID: 0 PID: 41562 Comm: syz.6.5469 Tainted: G             L      7.0.0-rc1 #1 PREEMPT(full) 
Tainted: [L]=SOFTLOCKUP
Hardware name: QEMU Ubuntu 24.04 PC v2 (i440FX + PIIX, arch_caps fix, 1996), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
Call Trace:
 <TASK>
 dump_stack_lvl+0xe8/0x150 lib/dump_stack.c:120
 print_circular_bug+0x2dd/0x2f0 kernel/locking/lockdep.c:2043
 check_noncircular+0x129/0x150 kernel/locking/lockdep.c:2175
 check_prev_add kernel/locking/lockdep.c:3165 [inline]
 check_prevs_add kernel/locking/lockdep.c:3284 [inline]
 validate_chain kernel/locking/lockdep.c:3908 [inline]
 __lock_acquire+0x159d/0x2ce0 kernel/locking/lockdep.c:5237
 lock_acquire+0xf1/0x2e0 kernel/locking/lockdep.c:5868
 down_read+0x47/0x2e0 kernel/locking/rwsem.c:1537
 ocfs2_init_acl+0x2f7/0x7a0 fs/ocfs2/acl.c:367
 ocfs2_mknod+0x1327/0x20c0 fs/ocfs2/namei.c:414
 ocfs2_mkdir+0x181/0x470 fs/ocfs2/namei.c:660
 vfs_mkdir+0x408/0x620 fs/namei.c:5233
 filename_mkdirat+0x27b/0x500 fs/namei.c:5266
 __do_sys_mkdirat fs/namei.c:5287 [inline]
 __se_sys_mkdirat+0x35/0x150 fs/namei.c:5284
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0x160/0xfc0 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x4b/0x53
RIP: 0033:0x7f14167a25cb
Code: 0f 1e fa 48 89 f2 b9 00 01 00 00 48 89 fe bf 9c ff ff ff e9 17 f7 ff ff 0f 1f 80 00 00 00 00 f3 0f 1e fa b8 02 01 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 b0 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f14149f5e28 EFLAGS: 00000246 ORIG_RAX: 0000000000000102
RAX: ffffffffffffffda RBX: 00002000000002c0 RCX: 00007f14167a25cb
RDX: 00000000000001ff RSI: 00002000000000c0 RDI: 00000000ffffff9c
RBP: 0000200000000200 R08: 0000000000000001 R09: 0000000000000000
R10: 0000200000000200 R11: 0000000000000246 R12: 00002000000000c0
R13: 00007f14149f5e80 R14: 0000000000000000 R15: 0000000000000000
 </TASK>

<<<<<<<<<<<<<<< tail report >>>>>>>>>>>>>>>
