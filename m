Received: from mail-pg1-f195.google.com (mail-pg1-f195.google.com [209.85.215.195])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72CE63ACF04
	for <ocfs2-devel@lists.linux.dev>; Mon, 25 May 2026 07:06:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.195
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779692771; cv=none; b=jrfnyZ8xvGbm84OMKY1gKr4kGHBLMOyFtUNg8xGIGK8Tb0G87sUD2LeiZy8hdALV0xNjAI9K/sSqO54vZb53Miv80LW8zSZCMT/Cz+30umKKcvjhpBWsYZEK7dlJQ5GVWLqfcSILKJt7lz/uBXnvZWDjyjpf+kdcQZrCLzQr40I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779692771; c=relaxed/simple;
	bh=jqKRW6hgeAuhcRZTPSBO2sqnwYy2i8LVP7c9gvUoqJI=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=p/CXn+36vKRBcZI/5ssg490GjJOdv5rA0ng0KTbR1W9Hv1+mwxaD1g86p3w7hSC/QXZiurlBiqhCUcacX7U+uP7AeLhco+6ioEVG/okPOjKk4kYgjf8gcnz06QShaTHgiuDq36u1WSWx9mGXdG557U3cUhxZHst4RzHWRef2Omg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=aSXjPHfJ; arc=none smtp.client-ip=209.85.215.195
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="aSXjPHfJ"
Received: by mail-pg1-f195.google.com with SMTP id 41be03b00d2f7-c80203b9d7bso3878977a12.0
        for <ocfs2-devel@lists.linux.dev>; Mon, 25 May 2026 00:06:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779692770; x=1780297570; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=oPfVtPRYnrjjg5ONu7Az8pjVeGEIUnFn6NlP1/E/r2U=;
        b=aSXjPHfJs1d+Q9ojro252k8ZW/+LpQbeMOTx+D/t+CCL3JlGL+p8pXcF7LB6DLlobu
         gz8X9Y+XUEE1No1KhOwj4rvAeD6+7kKmTbisXwKvYClqXortEv0ZY5zza5N66upjWscm
         S8dQCKPeS/yDLxl1FfJSOiA2Lm8EKoKeXtsZVSZtLDm0L1IiROAO9bmvfOKTKURERzrU
         h3hCtnTO5uJdnXthU2zrfpx3N9+VT0Ag9tWfzEB/8lcE/qfggMdEfDleKPkngV/SbXv9
         lnL9iIfeqbfEPrAs6zOgv0AhD5g3TSUnj80ZsNA27WyZt+ZztjG7HmOGyImqph4NRTOk
         3NuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779692770; x=1780297570;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=oPfVtPRYnrjjg5ONu7Az8pjVeGEIUnFn6NlP1/E/r2U=;
        b=fGTLqIHUVJR1KCB7BzyTBiF5nxF/MRGy4W0f1PRcbouPPgq2wrNpRP+KRwrn7qpADl
         teggpq9SsINfAZBhnv4f/UUUBbVzii5+KVREmMJpCUqq7Ph1xv3JpglQSh0RftQyLkLf
         NP5VxNGA97790zRs3qZ+1a7WfbtJ6ROuB0pGmFcDJvUKB4zYPLvMUGxvyksFUZYEtjCS
         7XrmPsiHoZA9ZMt99iDJB7//ZCm2QiE5mlhiVrXmPV93KP6d/F58tL/PpA048Edrweak
         MU0VWT+N2MiBagSjMSaG5XXnAoZOdCABOkJKhrNk2rUz0wGnqh7gUGDKY/3fj1oEOrSM
         z81Q==
X-Gm-Message-State: AOJu0YyLYltXfgl/g+tCfJt4hcDpOdAGD0LQMb4Ng3TqSdkye3p7ewwz
	PFzq1yajWYm/ZDLq1ZWDtJb5I6JVJLtJDSotvGSFSsNdif2/Upa/5oD3
X-Gm-Gg: Acq92OE/l+jEUqgzwpWfL/6dLyLxdmz1RPGYoKoUqT6mclvhLlqNm8fq1NYwfTTi6B0
	25kGZE+sDf9JdKMh3TMwKd89DydoKWYWTXZqjTfFRu+nFGsMmmpK7jF6wEFpvoFz74CoostauCt
	cLk1j2yM+KL5ZMUGw3flJjtDYaOkdhOe6Td6ZDM5W5BiXB0We9MRDlpxuS+V+56/FdYOmWp5cNB
	mVTqfl+QyRyzcmZvM2lKPn+MLruFfJ5i518SuNjnwS9ISgIxa04QELZl5zOHtnb3Q0+abulygzR
	sz/YL/orx+khSHjHM8DI3v7QYs1SDBolqPEW5Jz/Xx8nP415PYx9ZwWUsIC9eDJk/3G+TyaTux7
	z2IxXxj97p2zpUUyT0+xJQ/lJPbP61Znh6A9lcpDs95j6QcbBqsaWGtr3bxMaqeJg7+sdpTniRw
	HIDRXGQ+JdOzvL/BngsoYxKh/iqErEBdM=
X-Received: by 2002:a05:6a20:a122:b0:3b3:2703:12b with SMTP id adf61e73a8af0-3b328c700aemr13222399637.3.1779692769710;
        Mon, 25 May 2026 00:06:09 -0700 (PDT)
Received: from localhost ([111.228.63.84])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-c852054d788sm6859898a12.21.2026.05.25.00.06.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 May 2026 00:06:09 -0700 (PDT)
From: Zhang Cen <rollkingzzc@gmail.com>
To: Mark Fasheh <mark@fasheh.com>,
	Joel Becker <jlbec@evilplan.org>,
	Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: ocfs2-devel@lists.linux.dev,
	zerocling0077@gmail.com,
	2045gemini@gmail.com,
	Zhang Cen <rollkingzzc@gmail.com>
Subject: [PATCH] ocfs2: remove debugfs before shutting down recovery
Date: Mon, 25 May 2026 15:06:04 +0800
Message-Id: <20260525070604.360875-1-rollkingzzc@gmail.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

ocfs2_osb_debug_open() builds the per-mount fs_state snapshot by calling
ocfs2_osb_dump(), which reads osb->recovery_map. During normal unmount,
ocfs2_dismount_volume() currently calls ocfs2_recovery_exit() before it
removes osb->osb_debug_root, so a concurrent fs_state open can still
enter ocfs2_osb_dump() after the recovery map has been freed.

operations, so moving it ahead of ocfs2_recovery_exit() closes the
post-free/pre-remove window without changing the recovery-state logic.
This also makes the normal unmount path match the existing mount-error
state.

The buggy scenario involves two paths, with each column showing the
order within that path:

1. Open the per-mount fs_state file      1. ocfs2_dismount_volume() starts
2. ocfs2_osb_debug_open() calls          2. ocfs2_recovery_exit() frees
   ocfs2_osb_dump()                         osb->recovery_map
   osb->recovery_map                        runs later

Validation reproduced this kernel report:
KASAN slab-use-after-free in ocfs2_osb_debug_open+0x478/0xaa0
RIP: 0033:0x7f65fc97a001
The buggy address belongs to the object at ffff8881049c3da0 which belongs
to the cache kmalloc-8 of size 8
The buggy address is located 0 bytes inside of freed 8-byte region
[ffff8881049c3da0, ffff8881049c3da8)
Read of size 4
Call trace:
  dump_stack_lvl+0x66/0xa0 (?:?)
  print_report+0xd0/0x630 (?:?)
  ocfs2_osb_debug_open+0x478/0xaa0 (fs/ocfs2/super.c:343)
  srso_alias_return_thunk+0x5/0xfbef5 (?:?)
  __virt_addr_valid+0x188/0x2f0 (?:?)
  kasan_report+0xe4/0x120 (?:?)
  full_proxy_open_regular+0x113/0x170 (?:?)
  do_dentry_open+0x233/0x7f0 (?:?)
  vfs_open+0x5a/0x1b0 (?:?)
  security_inode_permission+0x19/0x60 (?:?)
  path_openat+0x679/0x1540 (?:?)
  kmem_cache_alloc_noprof+0x1ea/0x5f0 (?:?)
  do_getname+0x2e/0x1d0 (?:?)
  do_sys_openat2+0xa4/0x150 (?:?)
  __x64_sys_openat+0xd0/0x140 (?:?)
  do_syscall_64+0x10c/0x640 (arch/x86/entry/syscall_64.c:87)
  entry_SYSCALL_64_after_hwframe+0x77/0x7f (?:?)
  do_file_open+0x190/0x2a0 (?:?)
  __lock_acquire+0x42f/0x1a60 (?:?)
  _raw_spin_unlock+0x23/0x40 (?:?)
  alloc_fd+0x210/0x350 (?:?)
  do_sys_openat2+0xce/0x150 (?:?)
  irqentry_exit+0xac/0x6e0 (?:?)
Freed by task stack:
  kasan_save_stack+0x33/0x60 (?:?)
  kasan_save_track+0x14/0x30 (?:?)
  kasan_save_free_info+0x3b/0x60 (?:?)
  __kasan_slab_free+0x5f/0x80 (?:?)
  kfree+0x30f/0x580 (?:?)
  ocfs2_dismount_volume+0x168/0x560 (fs/ocfs2/super.c:1868)
  generic_shutdown_super+0xc3/0x220 (fs/ocfs2/super.c:?)
  kill_block_super+0x29/0x60 (fs/ocfs2/super.c:?)
  deactivate_locked_super+0x66/0xe0 (fs/ocfs2/super.c:?)
  cleanup_mnt+0x13d/0x210 (?:?)
  task_work_run+0xfa/0x170 (?:?)
  exit_to_user_mode_loop+0xd6/0x430 (?:?)
  do_syscall_64+0x3cb/0x640 (arch/x86/entry/syscall_64.c:87)
  entry_SYSCALL_64_after_hwframe+0x77/0x7f (?:?)

Fixes: 5e7a3ed9f1a6 ("ocfs2: further debugfs cleanups")
Assisted-by: Codex:gpt-5.5
Signed-off-by: Zhang Cen <rollkingzzc@gmail.com>
---
 fs/ocfs2/super.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/ocfs2/super.c b/fs/ocfs2/super.c
index b875f01c9756..357f210b6a43 100644
--- a/fs/ocfs2/super.c
+++ b/fs/ocfs2/super.c
@@ -1826,6 +1826,9 @@ static void ocfs2_dismount_volume(struct super_block *sb, int mnt_err)
 
 	ocfs2_truncate_log_shutdown(osb);
 
+	ocfs2_blockcheck_stats_debugfs_remove(&osb->osb_ecc_stats);
+	debugfs_remove_recursive(osb->osb_debug_root);
+
 	/* This will disable recovery and flush any recovery work. */
 	ocfs2_recovery_exit(osb);
 
@@ -1865,9 +1868,6 @@ static void ocfs2_dismount_volume(struct super_block *sb, int mnt_err)
 
 	ocfs2_dlm_shutdown(osb, hangup_needed);
 
-	ocfs2_blockcheck_stats_debugfs_remove(&osb->osb_ecc_stats);
-	debugfs_remove_recursive(osb->osb_debug_root);
-
 	if (hangup_needed)
 		ocfs2_cluster_hangup(osb->uuid_str, strlen(osb->uuid_str));
 
-- 
2.43.0

