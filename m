Received: from mail-vk1-f179.google.com (mail-vk1-f179.google.com [209.85.221.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5A9736C5AE
	for <ocfs2-devel@lists.linux.dev>; Fri, 26 Jun 2026 21:29:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782509381; cv=none; b=s6fZ9Q/1GFr98VvcPnuQal4heRAN/18vdhLal3LbSW1QgrnkS5jE1M13B2DAmzHEls5hB+WnTLBCmvTRSx2xdpMTl58lMamubHQI0t/+GVYEltV4tQLgOEUG2eO6ZVltN04DDkUJu2q8z3ok8zaqmKYWb+/tqkZTa31aFiKEoeA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782509381; c=relaxed/simple;
	bh=Te7Qe9n5KeqWSkzz0wWLJQkHy7C8DdO2hnA5VVMwWrw=;
	h=Message-ID:Date:Subject:To:Cc:Content-Type:MIME-Version:From; b=sRTR8nPxKfYJcIIUr08mf/NxDQAqJWGvQCPDsSklKZ/KPtjXSAzZwc7xLzfGNungPaek78915jDW8CRlPvEAxUbJ+Wpe08pbCQZK2qw8DGR74SwinS7wE2nhYMY+Ii4wQs0yYeUiLXUpVYn1M/WO9Dt5C2HCgIReCRfXDq1nHCY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=T4o5sySG; arc=none smtp.client-ip=209.85.221.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="T4o5sySG"
Received: by mail-vk1-f179.google.com with SMTP id 71dfb90a1353d-5bd6d636ac8so44894e0c.2
        for <ocfs2-devel@lists.linux.dev>; Fri, 26 Jun 2026 14:29:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782509379; x=1783114179; darn=lists.linux.dev;
        h=from:mime-version:content-transfer-encoding:content-type:cc:to
         :subject:date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=zXnOx3ea0LltqK75INcyd259m4s/13Ts31nbNGHd9Ig=;
        b=T4o5sySGZYr8TIyd7jNDIW02r2tmCTz1JLLK4XSzy58gzjp/1i+C/1EVSGfougXExG
         Ospm4zQLNttFyMUDYozhZZaVSjwOYnBtM2U2gtf0J+/dfryqSWwc1YVtTSTyjyRRjNzr
         q8npOP9v45DrltAIY6vW8fZxOrjJqz/JNv/DO2hCmSppntil+R0sERq9GdC/6AxShRkH
         jochjevEaDWjl5Ru8XTwtquDyTbRbGJM0e2ezJopJvDSP7zKiEBXZZw85n8VrG2VKT6H
         QjKGBonedqFng1mfDVIg5V6h89Yu0ut4eoYpjBXfd+PXMYeqfiCNeCzvskXhYZaeCkHb
         4CbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782509379; x=1783114179;
        h=from:mime-version:content-transfer-encoding:content-type:cc:to
         :subject:date:message-id:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=zXnOx3ea0LltqK75INcyd259m4s/13Ts31nbNGHd9Ig=;
        b=CjhcK1MssK088kjxKzYjKxp/PzMtDuRDv55yFDy/ztuv3MMEOtdKveVcGcZDzUvXzy
         Vi3vkjq59sBhpO/1wfsjFQ4S3dBW2Mgc7ipGaNxMFaKKiDPc3u3PglG4dlKRN34QhyDW
         pu/6tjrqHo4RJ4nM3Tl0nsMju9HGgz08Tql1Az+y169p5efXVZlbyjVeDGqmuGSb+6us
         rXzfLgCPrGoi1vJJB6xFrd97Jk0bjNVTxGdj76iUCRYOUgdOSoiVMQH1ugDeTyF8fCOw
         4TsF2juUVRthUgjdFYIF8ZreLZ5tXOafnDJaPoc6nQx2LurNcaG8Ohs5QxgM1s220eBp
         EMnA==
X-Forwarded-Encrypted: i=1; AHgh+RrwRjfeeDHhovFBibG3nfwC4WKbYKDX/gzmy7MUk9JSOiFVT0I68d3N0OJN+jdKqSMTngfYn6sssBmGJg==@lists.linux.dev
X-Gm-Message-State: AOJu0YxHCrf81NN+g2gv19aGTZl6vhrsvXvPbIiYfUjOQrpaJE3d/Qts
	vNpHU6tWl9vwABOQS3O1KMfZ+nQuyrlaz1xhS+Rm0bFyl7ckoBk2jXFk
X-Gm-Gg: AfdE7clmLRqRPsMlTIBuD0MT5dRejKSBGOBXNhs/88UL0zBBQL2BhxtYJUW6KKem7fh
	ykdhPtO5QWS7qKeAPLmm4Y2osTei38uTD9m2alII8L57j18DAVHHtu4bFHbCTx0bSTGt5PBzayz
	VnM4aQVAc0n9LdrZrjPA8WROIYif987k0WkPbno6R9fE4F1zOL18I+2yAeK78LOyEBAuYb0NwZu
	uXtVkK3ZrAqNZCUDYE/PIbJoMTItix9dnhhOLbsgSHWg7+qzNrd7sAeFC0ygrgfdHGPzKRZXKHR
	uyLlKY3Vj6PPHV0/bo6I3qNvqbUiZw4aorJqDBKaXnDjgD7ZV/HuT8FbFPJ4ZD3eY2N6E4qk6SA
	ynY4N1UWCcfL56jWZhPsEyhsdoGcefIabrQi6z93huOiF9oQxqRZ440xITVZp5/2KD4Y9uQQ+bn
	AWVAZ7qAnPOZvYTCM295FTz+ATDpvbw1/YmsTMJSFiJqvYFlo6LeK2qEtG/FHI7tPUYW2Nx+1aY
	VzJLChahv7+
X-Received: by 2002:a05:6122:10e5:b0:5bd:68f6:31c9 with SMTP id 71dfb90a1353d-5bd69e0d598mr1250282e0c.3.1782509378949;
        Fri, 26 Jun 2026 14:29:38 -0700 (PDT)
Received: from [192.168.10.115] ([132.170.207.48])
        by smtp.gmail.com with ESMTPSA id 71dfb90a1353d-5bd78e4c6cbsm1893124e0c.4.2026.06.26.14.29.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 26 Jun 2026 14:29:38 -0700 (PDT)
Message-ID: <6a3eef42.4ad61264.123291.6877@mx.google.com>
Date: Fri, 26 Jun 2026 14:29:38 -0700 (PDT)
Subject: possible deadlock in ocfs2_xattr_set
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
Kernel Config: <https://drive.google.com/open?id=1mAp3gxor4yGtL0ZArdrc1E7ufSn4T841>
Unfortunately, we don't have any reproducer for this bug yet.
Thank you!

Best regards,
Sanan Hasanov

======================================================
WARNING: possible circular locking dependency detected
7.0.0-rc1 #1 Tainted: G             L     
------------------------------------------------------
syz.2.3024/27235 is trying to acquire lock:
ffff88804960df40 (&ocfs2_sysfile_lock_key[TRUNCATE_LOG_SYSTEM_INODE]){+.+.}-{4:4}, at: inode_lock include/linux/fs.h:1028 [inline]
ffff88804960df40 (&ocfs2_sysfile_lock_key[TRUNCATE_LOG_SYSTEM_INODE]){+.+.}-{4:4}, at: ocfs2_xattr_set+0xb12/0x1220 fs/ocfs2/xattr.c:3653

but task is already holding lock:
ffff888062436ab8 (&oi->ip_xattr_sem){++++}-{4:4}, at: ocfs2_xattr_set+0x42d/0x1220 fs/ocfs2/xattr.c:3614

which lock already depends on the new lock.


the existing dependency chain (in reverse order) is:

-> #3 (&oi->ip_xattr_sem){++++}-{4:4}:
       down_read+0x47/0x2e0 kernel/locking/rwsem.c:1537
       ocfs2_init_acl+0x2f7/0x7a0 fs/ocfs2/acl.c:367
       ocfs2_mknod+0x1327/0x20c0 fs/ocfs2/namei.c:414
       ocfs2_mkdir+0x181/0x470 fs/ocfs2/namei.c:660
       vfs_mkdir+0x408/0x620 fs/namei.c:5233
       filename_mkdirat+0x27b/0x500 fs/namei.c:5266
       __do_sys_mkdir fs/namei.c:5293 [inline]
       __se_sys_mkdir+0x34/0x150 fs/namei.c:5290
       do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
       do_syscall_64+0x160/0xfc0 arch/x86/entry/syscall_64.c:94
       entry_SYSCALL_64_after_hwframe+0x4b/0x53

-> #2 (&journal->j_trans_barrier){.+.+}-{4:4}:
       down_read+0x47/0x2e0 kernel/locking/rwsem.c:1537
       ocfs2_start_trans+0x36a/0x6d0 fs/ocfs2/journal.c:369
       ocfs2_mknod+0xe97/0x20c0 fs/ocfs2/namei.c:365
       vfs_mknod+0x43d/0x600 fs/namei.c:5092
       filename_mknodat+0x3bf/0x640 fs/namei.c:-1
       __do_sys_mknodat fs/namei.c:5173 [inline]
       __se_sys_mknodat+0x3b/0x150 fs/namei.c:5169
       do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
       do_syscall_64+0x160/0xfc0 arch/x86/entry/syscall_64.c:94
       entry_SYSCALL_64_after_hwframe+0x4b/0x53

-> #1 (sb_internal#3){.+.+}-{0:0}:
       percpu_down_read_internal include/linux/percpu-rwsem.h:53 [inline]
       percpu_down_read_freezable include/linux/percpu-rwsem.h:83 [inline]
       __sb_start_write include/linux/fs/super.h:19 [inline]
       sb_start_intwrite include/linux/fs/super.h:177 [inline]
       ocfs2_start_trans+0x26b/0x6d0 fs/ocfs2/journal.c:367
       ocfs2_remove_btree_range+0x7e2/0x1480 fs/ocfs2/alloc.c:5760
       ocfs2_commit_truncate+0xbb4/0x22f0 fs/ocfs2/alloc.c:7374
       ocfs2_truncate_for_delete fs/ocfs2/inode.c:701 [inline]
       ocfs2_wipe_inode fs/ocfs2/inode.c:868 [inline]
       ocfs2_delete_inode fs/ocfs2/inode.c:1157 [inline]
       ocfs2_evict_inode+0x1111/0x4260 fs/ocfs2/inode.c:1299
       evict+0x5ed/0xad0 fs/inode.c:846
       filename_unlinkat+0x42d/0x5e0 fs/namei.c:5544
       __do_sys_unlink fs/namei.c:5575 [inline]
       __se_sys_unlink+0x2e/0x140 fs/namei.c:5572
       do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
       do_syscall_64+0x160/0xfc0 arch/x86/entry/syscall_64.c:94
       entry_SYSCALL_64_after_hwframe+0x4b/0x53

-> #0 (&ocfs2_sysfile_lock_key[TRUNCATE_LOG_SYSTEM_INODE]){+.+.}-{4:4}:
       check_prev_add kernel/locking/lockdep.c:3165 [inline]
       check_prevs_add kernel/locking/lockdep.c:3284 [inline]
       validate_chain kernel/locking/lockdep.c:3908 [inline]
       __lock_acquire+0x159d/0x2ce0 kernel/locking/lockdep.c:5237
       lock_acquire+0xf1/0x2e0 kernel/locking/lockdep.c:5868
       down_write+0x96/0x1f0 kernel/locking/rwsem.c:1590
       inode_lock include/linux/fs.h:1028 [inline]
       ocfs2_xattr_set+0xb12/0x1220 fs/ocfs2/xattr.c:3653
       ocfs2_set_acl+0x701/0x7b0 fs/ocfs2/acl.c:255
       ocfs2_iop_set_acl+0x1aa/0x2a0 fs/ocfs2/acl.c:287
       set_posix_acl fs/posix_acl.c:955 [inline]
       vfs_set_acl+0x8f9/0xbf0 fs/posix_acl.c:1134
       do_set_acl+0xf6/0x180 fs/posix_acl.c:1279
       do_setxattr fs/xattr.c:633 [inline]
       filename_setxattr+0x2f4/0x610 fs/xattr.c:664
       path_setxattrat+0x356/0x3a0 fs/xattr.c:708
       __do_sys_lsetxattr fs/xattr.c:749 [inline]
       __se_sys_lsetxattr fs/xattr.c:745 [inline]
       __x64_sys_lsetxattr+0xbf/0xd0 fs/xattr.c:745
       do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
       do_syscall_64+0x160/0xfc0 arch/x86/entry/syscall_64.c:94
       entry_SYSCALL_64_after_hwframe+0x4b/0x53

other info that might help us debug this:

Chain exists of:
  &ocfs2_sysfile_lock_key[TRUNCATE_LOG_SYSTEM_INODE] --> &journal->j_trans_barrier --> &oi->ip_xattr_sem

 Possible unsafe locking scenario:

       CPU0                    CPU1
       ----                    ----
  lock(&oi->ip_xattr_sem);
                               lock(&journal->j_trans_barrier);
                               lock(&oi->ip_xattr_sem);
  lock(&ocfs2_sysfile_lock_key[TRUNCATE_LOG_SYSTEM_INODE]);

 *** DEADLOCK ***

3 locks held by syz.2.3024/27235:
 #0: ffff8880637a2420 (sb_writers#19){.+.+}-{0:0}, at: mnt_want_write+0x41/0x90 fs/namespace.c:493
 #1: ffff888062436d80 (&type->i_mutex_dir_key#13){++++}-{4:4}, at: inode_lock include/linux/fs.h:1028 [inline]
 #1: ffff888062436d80 (&type->i_mutex_dir_key#13){++++}-{4:4}, at: vfs_set_acl+0x3af/0xbf0 fs/posix_acl.c:1115
 #2: ffff888062436ab8 (&oi->ip_xattr_sem){++++}-{4:4}, at: ocfs2_xattr_set+0x42d/0x1220 fs/ocfs2/xattr.c:3614

stack backtrace:
CPU: 0 UID: 0 PID: 27235 Comm: syz.2.3024 Tainted: G             L      7.0.0-rc1 #1 PREEMPT(full) 
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
 down_write+0x96/0x1f0 kernel/locking/rwsem.c:1590
 inode_lock include/linux/fs.h:1028 [inline]
 ocfs2_xattr_set+0xb12/0x1220 fs/ocfs2/xattr.c:3653
 ocfs2_set_acl+0x701/0x7b0 fs/ocfs2/acl.c:255
 ocfs2_iop_set_acl+0x1aa/0x2a0 fs/ocfs2/acl.c:287
 set_posix_acl fs/posix_acl.c:955 [inline]
 vfs_set_acl+0x8f9/0xbf0 fs/posix_acl.c:1134
 do_set_acl+0xf6/0x180 fs/posix_acl.c:1279
 do_setxattr fs/xattr.c:633 [inline]
 filename_setxattr+0x2f4/0x610 fs/xattr.c:664
 path_setxattrat+0x356/0x3a0 fs/xattr.c:708
 __do_sys_lsetxattr fs/xattr.c:749 [inline]
 __se_sys_lsetxattr fs/xattr.c:745 [inline]
 __x64_sys_lsetxattr+0xbf/0xd0 fs/xattr.c:745
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0x160/0xfc0 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x4b/0x53
RIP: 0033:0x7f23845a3b6d
Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 90 f3 0f 1e fa 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 b0 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f23827f6018 EFLAGS: 00000246 ORIG_RAX: 00000000000000bd
RAX: ffffffffffffffda RBX: 00007f2384815fa0 RCX: 00007f23845a3b6d
RDX: 00002000000000c0 RSI: 0000200000000440 RDI: 0000200000000400
RBP: 00007f2384647c3e R08: 0000000000000000 R09: 0000000000000000
R10: 000000000000005c R11: 0000000000000246 R12: 0000000000000000
R13: 00007f2384816038 R14: 00007f2384815fa0 R15: 00007fff10fbf4c0
 </TASK>

<<<<<<<<<<<<<<< tail report >>>>>>>>>>>>>>>
