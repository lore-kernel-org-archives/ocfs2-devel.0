Received: from mail-pf1-f178.google.com (mail-pf1-f178.google.com [209.85.210.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B88CB327C0D
	for <ocfs2-devel@lists.linux.dev>; Tue,  6 Jan 2026 12:51:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767703873; cv=none; b=tlOXhvE+JNM95ABBY4clr2F+YDNCH7fH6HI09ylUgOCJeu4XasNGTRVBhmj64KOpqPEvIZ6hcbNHAoBlAXqvwhwTgjcKu73aX4HDAptufX2lrM1+uI/X5JV3l2+DLyNCLPn7EhJVGSWhOtGakH09AXEF9ptDbR3PKEN5Gqa0L2Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767703873; c=relaxed/simple;
	bh=SMBn3qc7wB4wuZsb2/dh15IMXtMy4x0ctVbgY/rCLAs=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=qV9xXko9jTTmd/+mXbTk3sjDfUysfzB5qStRBp2tKqtBKVBmu2UHWQcbpaY8I23i4tiWnyAuLE2u+vpVj09qGkmzDJImSesQLIE3y16BDj0bp8EVwkuPEC9hMsXwftf7UK6vGVNKGYB/UBSnzrhkJbPeJUd0vlqSfimKO7BwAlI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=coLUwRoK; arc=none smtp.client-ip=209.85.210.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="coLUwRoK"
Received: by mail-pf1-f178.google.com with SMTP id d2e1a72fcca58-7baf61be569so1000047b3a.3
        for <ocfs2-devel@lists.linux.dev>; Tue, 06 Jan 2026 04:51:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1767703871; x=1768308671; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=GVK5kWaBMcajGCM2MQuu99bRAxIqubDUOyWaqhW9gcw=;
        b=coLUwRoK7ADSi+sXtruX9IizIXHe0D6DGF4N5KRC+3UOLrpRwR1x0XBdum8ZVI4rUq
         RgnsmSOw9PcJxAeP/hXZAesQwfk2M+vWTJBTIWEsdJ17oIM2kJKdxVoX2GzkGC8yXuJ1
         KZadc18J/l8OalMUPueEtsaKsl+VSv/J9q6lEPXWFf+Wr4rm+76mDv0QTRHx2PLmkSEg
         CGgBFTiero2KQ14S8W3xITeNWPknm29ynwdxHQyLvdRABa4Bkev69uyriU+hSv0oNhHc
         nesTtSE72mAcxCcg7HV4l8LOqSZQm87HnglVxz4qamwFj69eJTRCrM1u2fJdhwAPlED9
         M/8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767703871; x=1768308671;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GVK5kWaBMcajGCM2MQuu99bRAxIqubDUOyWaqhW9gcw=;
        b=dEJOF723le2zSEvM/6eQ9c4/XRhG6Yk7FOC9TCpRHfp9HAQP6JnvSo51B7i3GFTEDO
         /Ru4dB9qJ0I1kwb8RiKwpswtzSIHk0cs08qebyD3jvvehtAiXPGqFMNflm1YzcOMBfym
         LUDdzKfZJ9xAY/riOec/yPMKGogCMYCBRFaFGbdSUW/DoiV6xMnst1axi2ImNmeP9xtC
         jAAjx2t62K6fdiHWm2E5wRLcKzwhXPutve/hVbtH6ZmAd+X4u0PfNg4qPopWeYrot0c2
         lIEFybRh6kbK/vSseOBGg26NDiFSfu/SprWagIYno4CXBYnVOkZzC8mEPbFTOd+2efC2
         dzgw==
X-Forwarded-Encrypted: i=1; AJvYcCWvs6/tpz4+A45O9aLmNEtbqmwjBwtKO/mhtTj3H+2kayBs1H1gh5m4fgjhDYUvPUYicocghmtPmmAujw==@lists.linux.dev
X-Gm-Message-State: AOJu0YzpmABlODTGKTrWwPPoBPziyzCGlxNjfxkN76KWWLvNmWwfLybK
	a7pnWeQVd7OJ/p4VeTERZC4C6Q8goqw3ASvW1sB8J4qXeuOPuKK7PZeD
X-Gm-Gg: AY/fxX4LDdt4cwPV3h8qkkmGh/2+gbUHOvGVs4s7t4g5jp+5ydu+7HtYhukh+RkYWpg
	F5hYJTl1W4K2WkPZmt2OBVkAaGLS1zL8P4Chvp5cjImXD4RXT9fPIJFTIXIWYt2twj4Dbxxal2N
	RRsJitDx422fOT9Mu2eechMzAfFbmN+M/FThJvlhnO7H3BL540IrxxhNA5m2ADDFDp5Oxmpr+0G
	h4BzzyxaUXQpoVkl+5QSv9JGcSYNozhBeIHnQpSxB+jV0G5LynMgyLdP8+3dl01VcVwB7CKCMaF
	zHBgJCH5583acv+H8p5xWLDO4o28GdK21IxCSSkeUA6d0BYSUzR2PDEH4dra4fAYoSLQ/7x5WxU
	rYetc0bqYhKrCDqc7KOWSDPsdrdKf2+C9iM7i2OH+XqfDE1vjmtI5ziInw2qVEPzBsJNBwjmu6A
	0P2MBSwpjz5VY6Ea4WwtmAsUxzmjk=
X-Google-Smtp-Source: AGHT+IEjQzLUI06ataF4NA4gtv9rTNIhw0H4aBknRuszy3wKP+MD6pswMmHdIke2pPvGi7BAN6fGHw==
X-Received: by 2002:a05:6a20:2451:b0:350:7238:7e2e with SMTP id adf61e73a8af0-3898237bbfcmr2368266637.45.1767703870927;
        Tue, 06 Jan 2026 04:51:10 -0800 (PST)
Received: from localhost.localdomain ([111.125.210.92])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2a3e3cc88fcsm22465845ad.83.2026.01.06.04.51.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Jan 2026 04:51:10 -0800 (PST)
From: Prithvi Tambewagh <activprithvi@gmail.com>
To: mark@fasheh.com,
	jlbec@evilplan.org,
	joseph.qi@linux.alibaba.com
Cc: heming.zhao@suse.com,
	ocfs2-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-kernel-mentees@lists.linux.dev,
	skhan@linuxfoundation.org,
	david.hunter.linux@gmail.com,
	khalid@kernel.org,
	Prithvi Tambewagh <activprithvi@gmail.com>,
	syzbot+78359d5fbb04318c35e9@syzkaller.appspotmail.com,
	stable@vger.kernel.org
Subject: [PATCH] ocfs2: Fix circular locking dependency in ocfs2_del_inode_from_orphan()
Date: Tue,  6 Jan 2026 18:21:00 +0530
Message-Id: <20260106125100.327980-1-activprithvi@gmail.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

A possible circular locking dependency in ocfs2_del_inode_from_orphan()
is detected by syzbot, which occurs due to change in the sequence of
acquiring locks. The existing chain is:

&ocfs2_sysfile_lock_key[ORPHAN_DIR_SYSTEM_INODE] --> &dquot->dq_lock --> 
&ocfs2_quota_ip_alloc_sem_key

In ocfs2_dio_end_io_write(), &ocfs2_quota_ip_alloc_sem_key is acquired,
and then ocfs2_del_inode_from_orphan() is called, which acquires
&ocfs2_sysfile_lock_key[ORPHAN_DIR_SYSTEM_INODE]. This opposes the
existing dependency chain:

-> #3 (&ocfs2_quota_ip_alloc_sem_key){++++}-{4:4}:
       lock_acquire+0x120/0x360 kernel/locking/lockdep.c:5868
       down_write+0x3a/0x50 kernel/locking/rwsem.c:1590
       ocfs2_create_local_dquot+0x19d/0x1a40 fs/ocfs2/quota_local.c:1227
       ocfs2_acquire_dquot+0x80f/0xb30 fs/ocfs2/quota_global.c:883
       dqget+0x7c1/0xf20 fs/quota/dquot.c:980
       __dquot_initialize+0x3b3/0xcb0 fs/quota/dquot.c:1508
       ocfs2_get_init_inode+0x13b/0x1b0 fs/ocfs2/namei.c:205
       ocfs2_mknod+0x863/0x2050 fs/ocfs2/namei.c:313
       ocfs2_create+0x1a5/0x440 fs/ocfs2/namei.c:676
       lookup_open fs/namei.c:3796 [inline]
       open_last_lookups fs/namei.c:3895 [inline]
       path_openat+0x1500/0x3840 fs/namei.c:4131
       do_filp_open+0x1fa/0x410 fs/namei.c:4161
       do_sys_openat2+0x121/0x1c0 fs/open.c:1437
       do_sys_open fs/open.c:1452 [inline]
       __do_sys_openat fs/open.c:1468 [inline]
       __se_sys_openat fs/open.c:1463 [inline]
       __x64_sys_openat+0x138/0x170 fs/open.c:1463
       do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
       do_syscall_64+0xfa/0xfa0 arch/x86/entry/syscall_64.c:94
       entry_SYSCALL_64_after_hwframe+0x77/0x7f

-> #2 (&dquot->dq_lock){+.+.}-{4:4}:
       lock_acquire+0x120/0x360 kernel/locking/lockdep.c:5868
       __mutex_lock_common kernel/locking/rtmutex_api.c:535 [inline]
       mutex_lock_nested+0x5a/0x1d0 kernel/locking/rtmutex_api.c:547
       wait_on_dquot fs/quota/dquot.c:357 [inline]
       dqget+0x73a/0xf20 fs/quota/dquot.c:975
       __dquot_initialize+0x3b3/0xcb0 fs/quota/dquot.c:1508
       ocfs2_get_init_inode+0x13b/0x1b0 fs/ocfs2/namei.c:205
       ocfs2_mknod+0x863/0x2050 fs/ocfs2/namei.c:313
       ocfs2_create+0x1a5/0x440 fs/ocfs2/namei.c:676
       lookup_open fs/namei.c:3796 [inline]
       open_last_lookups fs/namei.c:3895 [inline]
       path_openat+0x1500/0x3840 fs/namei.c:4131
       do_filp_open+0x1fa/0x410 fs/namei.c:4161
       do_sys_openat2+0x121/0x1c0 fs/open.c:1437
       do_sys_open fs/open.c:1452 [inline]
       __do_sys_openat fs/open.c:1468 [inline]
       __se_sys_openat fs/open.c:1463 [inline]
       __x64_sys_openat+0x138/0x170 fs/open.c:1463
       do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
       do_syscall_64+0xfa/0xfa0 arch/x86/entry/syscall_64.c:94
       entry_SYSCALL_64_after_hwframe+0x77/0x7f

-> #1 (&ocfs2_sysfile_lock_key[INODE_ALLOC_SYSTEM_INODE]){+.+.}-{4:4}:
       lock_acquire+0x120/0x360 kernel/locking/lockdep.c:5868
       down_write+0x3a/0x50 kernel/locking/rwsem.c:1590
       inode_lock include/linux/fs.h:980 [inline]
       ocfs2_remove_inode fs/ocfs2/inode.c:731 [inline]
       ocfs2_wipe_inode fs/ocfs2/inode.c:894 [inline]
       ocfs2_delete_inode fs/ocfs2/inode.c:1155 [inline]
       ocfs2_evict_inode+0x153d/0x40d0 fs/ocfs2/inode.c:1295
       evict+0x504/0x9c0 fs/inode.c:810
       do_unlinkat+0x39f/0x570 fs/namei.c:4744
       __do_sys_unlinkat fs/namei.c:4778 [inline]
       __se_sys_unlinkat fs/namei.c:4771 [inline]
       __x64_sys_unlinkat+0xd3/0xf0 fs/namei.c:4771
       do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
       do_syscall_64+0xfa/0xfa0 arch/x86/entry/syscall_64.c:94
       entry_SYSCALL_64_after_hwframe+0x77/0x7f

-> #0 (&ocfs2_sysfile_lock_key[ORPHAN_DIR_SYSTEM_INODE]){+.+.}-{4:4}:
       check_prev_add kernel/locking/lockdep.c:3165 [inline]
       check_prevs_add kernel/locking/lockdep.c:3284 [inline]
       validate_chain+0xb9b/0x2140 kernel/locking/lockdep.c:3908
       __lock_acquire+0xab9/0xd20 kernel/locking/lockdep.c:5237
       lock_acquire+0x120/0x360 kernel/locking/lockdep.c:5868
       down_write+0x3a/0x50 kernel/locking/rwsem.c:1590
       inode_lock include/linux/fs.h:980 [inline]
       ocfs2_del_inode_from_orphan+0x134/0x740 fs/ocfs2/namei.c:2730
       ocfs2_dio_end_io_write fs/ocfs2/aops.c:2306 [inline]
       ocfs2_dio_end_io+0x47b/0x1100 fs/ocfs2/aops.c:2404
       dio_complete+0x25e/0x790 fs/direct-io.c:281
       __blockdev_direct_IO+0x2bc0/0x31f0 fs/direct-io.c:1303
       ocfs2_direct_IO+0x260/0x2d0 fs/ocfs2/aops.c:2441
       generic_file_direct_write+0x1dc/0x3e0 mm/filemap.c:4189
       __generic_file_write_iter+0x120/0x240 mm/filemap.c:4358
       ocfs2_file_write_iter+0x157d/0x1d20 fs/ocfs2/file.c:2469
       iter_file_splice_write+0x97a/0x10f0 fs/splice.c:738
       do_splice_from fs/splice.c:938 [inline]
       direct_splice_actor+0x104/0x160 fs/splice.c:1161
       splice_direct_to_actor+0x5b3/0xcd0 fs/splice.c:1105
       do_splice_direct_actor fs/splice.c:1204 [inline]
       do_splice_direct+0x187/0x270 fs/splice.c:1230
       do_sendfile+0x4ec/0x7f0 fs/read_write.c:1370
       __do_sys_sendfile64 fs/read_write.c:1431 [inline]
       __se_sys_sendfile64+0x13e/0x190 fs/read_write.c:1417
       do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
       do_syscall_64+0xfa/0xfa0 arch/x86/entry/syscall_64.c:94
       entry_SYSCALL_64_after_hwframe+0x77/0x7f

Fix this by acquiring &ocfs2_quota_ip_alloc_sem_key after acquiring
&ocfs2_sysfile_lock_key[ORPHAN_DIR_SYSTEM_INODE], effectively calling
down_write(&oi->ip_alloc_sem) after the call to
ocfs2_del_inode_from_orphan().

Reported-by: syzbot+78359d5fbb04318c35e9@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=78359d5fbb04318c35e9
Tested-by: syzbot+78359d5fbb04318c35e9@syzkaller.appspotmail.com
Cc: stable@vger.kernel.org
Signed-off-by: Prithvi Tambewagh <activprithvi@gmail.com>
---
 fs/ocfs2/aops.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/ocfs2/aops.c b/fs/ocfs2/aops.c
index 76c86f1c2b1c..586e3b74d782 100644
--- a/fs/ocfs2/aops.c
+++ b/fs/ocfs2/aops.c
@@ -2295,8 +2295,6 @@ static int ocfs2_dio_end_io_write(struct inode *inode,
 		goto out;
 	}
 
-	down_write(&oi->ip_alloc_sem);
-
 	/* Delete orphan before acquire i_rwsem. */
 	if (dwc->dw_orphaned) {
 		BUG_ON(dwc->dw_writer_pid != task_pid_nr(current));
@@ -2309,6 +2307,8 @@ static int ocfs2_dio_end_io_write(struct inode *inode,
 			mlog_errno(ret);
 	}
 
+	down_write(&oi->ip_alloc_sem);
+
 	di = (struct ocfs2_dinode *)di_bh->b_data;
 
 	ocfs2_init_dinode_extent_tree(&et, INODE_CACHE(inode), di_bh);

base-commit: 765e56e41a5af2d456ddda6cbd617b9d3295ab4e
-- 
2.34.1

