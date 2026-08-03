Received: from mail-pj1-f51.google.com (mail-pj1-f51.google.com [209.85.216.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CE2E351C10
	for <ocfs2-devel@lists.linux.dev>; Mon,  3 Aug 2026 03:24:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785727445; cv=none; b=Ax6WPXGXMT7mJ2ZyKncz/v1RBD346YLpq852f3+BCpU/jxOL64FVuME/7wcN7sp98dPhG53kAPWR40AK4vHALfGWSZsawvt1tcEK1D/xmRRtG7qeCoHBthSuH/CHzOoasgqmDVrtP0IiAincfkrDU9FXC9BSxYTPtC/jh8agcSU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785727445; c=relaxed/simple;
	bh=wT/ZhFhK+kLCQBc5rT/djlAn7s2lqJOwPfPYoZUNVTM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Z8TALCuu+87UzUSvT8zsFWjqOXKE/0SrDo6X1GCFMIuRsut3oEjYo9dQr1r/Io9rrR8ddgBN6YmzYa+q1wGMMWioesgWun8phBJuVDom0RhnUZNxG7w3FqEYUeC2y1KohF7IMOoC/2l5Plwjso4t5OccNz09XfcLB+k5P+3Hljw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=NPjQRL+i; arc=none smtp.client-ip=209.85.216.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="NPjQRL+i"
Received: by mail-pj1-f51.google.com with SMTP id 98e67ed59e1d1-38e071ed6aeso2219263a91.0
        for <ocfs2-devel@lists.linux.dev>; Sun, 02 Aug 2026 20:24:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785727442; x=1786332242; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=5x71MvKcEUQWSFGSc8xrlurSQDNIUsKqcpDiITXMRwA=;
        b=NPjQRL+iXj68OxxHYzuiXS918sGDIUWAOl0GRDWQJcta+DpUZbTzFEXhiiU0H7Q7c6
         DYxnrJKlLkalCuyVJEjjesKdgKKdfg5dZh/3ZpuAmh1p9WOSVcAMKuXRD22QeO7updvG
         TwNSxVyGbhxJEEPnAN1lgVD1gIZ+1cS0h6TAnyUwhKxqEoQkLhvBpgGiEtzHNJi3ZY6a
         S6zN3DoXJ4iM71lE8TUtF1GYVD6rrg7DbZSSmtLDZGZb0V8mtWwgayqly5QobXrlu0VI
         blOwRNRlpu8nSooHwwMTIXxTQPxM43Gpwm29tT1e5DMSsJwi3iuHs0BHXpPFtIK/FLvX
         nM8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785727442; x=1786332242;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=5x71MvKcEUQWSFGSc8xrlurSQDNIUsKqcpDiITXMRwA=;
        b=jhbj4Su1bwlkirUxoBh4+j1c0LUSdP+UhlV0GlLcpxc0pWr26BhLPwKzSPzi4KuB3D
         kulf4pEAsso0yGyqfvamQLrKmJkeSoktgQTvxSNtRJi2DJhqHO0zzEtJJ3r9xyCtVhGW
         R2WZbjqjmNv1TtebpVRvDhzd5MzddwSawJ07mdC/QkRLctYMbEQsGc2wmgZl1NXH5stT
         RjvwW4UVb0vLky9CjfIUz3Rb5CPSuC4yQSXxjSReyBw63dLkdcvQ354+aRznDm+zA8UK
         WNhcbD4yBsvjF2+u4WQsfRcGIvgIAg38bIahJC8KT5Oz37IT1uRjWWItOcTV3z9KC1A3
         WxMA==
X-Gm-Message-State: AOJu0Yy3AaHaHHsaoWvRG4w7tPJkHj4SXR282OEmUHzoAfhbkn/yei1c
	CIVc4HFhnLD+5uhwhxQd2dvyPAdJ313W70s6+h1xEqGw7SCaCnIaz35j
X-Gm-Gg: AR+sD13upcNEiIVcCmgc5MOQU3U9UkBGOTEY/lYMyimB1p1pGEoGTWKPJyPQNzSHnSc
	PBBw2+p+ICwuWoOGAUrj84kxMFNV848iz+Khk98HEnoG6vetZYCUy2jh/nKNJrvBfAMyv23n9/N
	DwF5Ga3LTEpba47jOzKoStkuYbx7ZC8ioPWiCncYcMlTuitTRBNRXZsIz1BdnWtjnBHgnAvx6RP
	ViWB/qtZV9cGxmO4hfqK7W4OuGhPbf6hMYHhQ0OyEu4xmjmb3UrBA8f+b51qQQl9YrbQONMBrPW
	dRXkSBgd1l3o85ydsyIwf2HZm/RLnHhO5MjTHwFy65xk4Rh9n0VOuPg5nl3zNU8yMCDuY4/Jfxo
	oV9al3wm7xMo7XSmZ81072Qj1b+w78u2ZP9MY+bomoaOsWUFJ0VAdv/PFZCthXDfaRYDrPgnJFb
	U6quWzg7/ZxuIEyLYKhviDyym2PZ5fDoszYZnRKZngP6vhBuIPFNYYLT4+ToZvzf/T8XV63Btio
	26snu8+e6tez1vs2rshFKFO6xNsng==
X-Received: by 2002:a17:90b:1f92:b0:387:e0db:3d8e with SMTP id 98e67ed59e1d1-38fbc5607camr7953847a91.41.1785727441703;
        Sun, 02 Aug 2026 20:24:01 -0700 (PDT)
Received: from gmail.com ([138.199.21.246])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-38fb2d19f7fsm3277781a91.17.2026.08.02.20.23.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 02 Aug 2026 20:24:01 -0700 (PDT)
From: ZhengYuan Huang <gality369@gmail.com>
To: mark@fasheh.com,
	jlbec@evilplan.org,
	joseph.qi@linux.alibaba.com
Cc: ocfs2-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	baijiaju1990@gmail.com,
	r33s3n6@gmail.com,
	zzzccc427@gmail.com,
	tom442288@tuta.io,
	ZhengYuan Huang <gality369@gmail.com>
Subject: [PATCH] ocfs2: fix deadlock in inline-data truncate transactions
Date: Mon,  3 Aug 2026 11:23:46 +0800
Message-ID: <20260803032346.3997901-1-gality369@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

[BUG]
Shrinking an inline-data file can trigger a real ABBA deadlock cycle and
lockdep warning:

WARNING: possible circular locking dependency detected
------------------------------------------------------
syz.0.6/353 is trying to acquire lock:
ffff888015936610 (sb_internal#2){.+.+}-{0:0}, at: ocfs2_truncate_inline+0x389/0xbf0 fs/ocfs2/alloc.c:7436

but task is already holding lock:
ffff888019156a20 (&ocfs2_file_ip_alloc_sem_key){++++}-{4:4}, at: ocfs2_truncate_file+0x23a/0x13c0 fs/ocfs2/file.c:471

which lock already depends on the new lock.

the existing dependency chain (in reverse order) is:

-> #3 (&ocfs2_file_ip_alloc_sem_key){++++}-{4:4}:
       down_write+0x8f/0x200 kernel/locking/rwsem.c:1590
       ocfs2_xattr_ibody_set+0x119/0xc50 fs/ocfs2/xattr.c:2783
       __ocfs2_xattr_set_handle+0xdb/0xdb0 fs/ocfs2/xattr.c:3322
       ocfs2_xattr_set+0x1447/0x2610 fs/ocfs2/xattr.c:3650
       ocfs2_xattr_security_set+0x37/0x50 fs/ocfs2/xattr.c:7241
       __vfs_setxattr+0x14f/0x1c0 fs/xattr.c:200
       __vfs_setxattr_noperm+0x10b/0x5c0 fs/xattr.c:234
       __vfs_setxattr_locked+0x172/0x240 fs/xattr.c:295
       vfs_setxattr+0x167/0x390 fs/xattr.c:321
       do_setxattr+0x13c/0x180 fs/xattr.c:636
       filename_setxattr+0x16b/0x1c0 fs/xattr.c:665
       path_setxattrat+0x1d8/0x280 fs/xattr.c:713
       __do_sys_setxattr fs/xattr.c:747 [inline]
       __se_sys_setxattr fs/xattr.c:743 [inline]
       __x64_sys_setxattr+0xcd/0x150 fs/xattr.c:743
       x64_sys_call+0x148c/0x26a0 arch/x86/include/generated/asm/syscalls_64.h:189
       do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
       do_syscall_64+0x93/0xf80 arch/x86/entry/syscall_64.c:94
       entry_SYSCALL_64_after_hwframe+0x76/0x7e

-> #2 (jbd2_handle){++++}-{0:0}:
       start_this_handle+0x5c7/0x13c0 fs/jbd2/transaction.c:444
       jbd2__journal_start+0x397/0x690 fs/jbd2/transaction.c:501
       jbd2_journal_start+0x31/0x50 fs/jbd2/transaction.c:540
       ocfs2_start_trans+0x39b/0x870 fs/ocfs2/journal.c:374
       ocfs2_xattr_set+0x1401/0x2610 fs/ocfs2/xattr.c:3643
       ocfs2_xattr_security_set+0x37/0x50 fs/ocfs2/xattr.c:7241
       __vfs_setxattr+0x14f/0x1c0 fs/xattr.c:200
       __vfs_setxattr_noperm+0x10b/0x5c0 fs/xattr.c:234
       __vfs_setxattr_locked+0x172/0x240 fs/xattr.c:295
       vfs_setxattr+0x167/0x390 fs/xattr.c:321
       do_setxattr+0x13c/0x180 fs/xattr.c:636
       filename_setxattr+0x16b/0x1c0 fs/xattr.c:665
       path_setxattrat+0x1d8/0x280 fs/xattr.c:713
       __do_sys_setxattr fs/xattr.c:747 [inline]
       __se_sys_setxattr fs/xattr.c:743 [inline]
       __x64_sys_setxattr+0xcd/0x150 fs/xattr.c:743
       x64_sys_call+0x148c/0x26a0 arch/x86/include/generated/asm/syscalls_64.h:189
       do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
       do_syscall_64+0x93/0xf80 arch/x86/entry/syscall_64.c:94
       entry_SYSCALL_64_after_hwframe+0x76/0x7e

-> #1 (&journal->j_trans_barrier){.+.+}-{4:4}:
       down_read+0x9c/0x4a0 kernel/locking/rwsem.c:1537
       ocfs2_start_trans+0x390/0x870 fs/ocfs2/journal.c:372
       ocfs2_xattr_set+0x1401/0x2610 fs/ocfs2/xattr.c:3643
       ocfs2_xattr_security_set+0x37/0x50 fs/ocfs2/xattr.c:7241
       __vfs_setxattr+0x14f/0x1c0 fs/xattr.c:200
       __vfs_setxattr_noperm+0x10b/0x5c0 fs/xattr.c:234
       __vfs_setxattr_locked+0x172/0x240 fs/xattr.c:295
       vfs_setxattr+0x167/0x390 fs/xattr.c:321
       do_setxattr+0x13c/0x180 fs/xattr.c:636
       filename_setxattr+0x16b/0x1c0 fs/xattr.c:665
       path_setxattrat+0x1d8/0x280 fs/xattr.c:713
       __do_sys_setxattr fs/xattr.c:747 [inline]
       __se_sys_setxattr fs/xattr.c:743 [inline]
       __x64_sys_setxattr+0xcd/0x150 fs/xattr.c:743
       x64_sys_call+0x148c/0x26a0 arch/x86/include/generated/asm/syscalls_64.h:189
       do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
       do_syscall_64+0x93/0xf80 arch/x86/entry/syscall_64.c:94
       entry_SYSCALL_64_after_hwframe+0x76/0x7e

-> #0 (sb_internal#2){.+.+}-{0:0}:
       check_prev_add kernel/locking/lockdep.c:3165 [inline]
       check_prevs_add kernel/locking/lockdep.c:3284 [inline]
       validate_chain kernel/locking/lockdep.c:3908 [inline]
       __lock_acquire+0x14ae/0x21e0 kernel/locking/lockdep.c:5237
       lock_acquire kernel/locking/lockdep.c:5868 [inline]
       lock_acquire+0x169/0x2f0 kernel/locking/lockdep.c:5825
       percpu_down_read_internal include/linux/percpu-rwsem.h:53 [inline]
       percpu_down_read_freezable include/linux/percpu-rwsem.h:83 [inline]
       __sb_start_write include/linux/fs.h:1916 [inline]
       sb_start_intwrite include/linux/fs.h:2099 [inline]
       ocfs2_start_trans+0x2a8/0x870 fs/ocfs2/journal.c:370
       ocfs2_truncate_inline+0x389/0xbf0 fs/ocfs2/alloc.c:7436
       ocfs2_truncate_file+0x6d3/0x13c0 fs/ocfs2/file.c:488
       ocfs2_setattr+0xa6d/0x1fd0 fs/ocfs2/file.c:1212
       notify_change+0x4b5/0x1030 fs/attr.c:546
       do_truncate+0x1d2/0x230 fs/open.c:68
       vfs_truncate+0x56c/0x670 fs/open.c:118
       do_sys_truncate fs/open.c:141 [inline]
       __do_sys_truncate fs/open.c:153 [inline]
       __se_sys_truncate fs/open.c:151 [inline]
       __x64_sys_truncate+0x165/0x1d0 fs/open.c:151
       x64_sys_call+0xbc8/0x26a0 arch/x86/include/generated/asm/syscalls_64.h:77
       do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
       do_syscall_64+0x93/0xf80 arch/x86/entry/syscall_64.c:94
       entry_SYSCALL_64_after_hwframe+0x76/0x7e

other info that might help us debug this:

Chain exists of:
  sb_internal#2 --> jbd2_handle --> &ocfs2_file_ip_alloc_sem_key

 Possible unsafe locking scenario:

       CPU0                    CPU1
       ----                    ----
  lock(&ocfs2_file_ip_alloc_sem_key);
                               lock(jbd2_handle);
                               lock(&ocfs2_file_ip_alloc_sem_key);
  rlock(sb_internal#2);

 *** DEADLOCK ***

3 locks held by syz.0.6/353:
 #0: ffff888015936420 (sb_writers#12){.+.+}-{0:0}, at: vfs_truncate+0x30c/0x670 fs/open.c:96
 #1: ffff888019156d80 (&sb->s_type->i_mutex_key#18){+.+.}-{4:4}, at: inode_lock_killable include/linux/fs.h:985 [inline]
 #1: ffff888019156d80 (&sb->s_type->i_mutex_key#18){+.+.}-{4:4}, at: do_truncate+0x139/0x230 fs/open.c:63
 #2: ffff888019156a20 (&ocfs2_file_ip_alloc_sem_key){++++}-{4:4}, at: ocfs2_truncate_file+0x23a/0x13c0 fs/ocfs2/file.c:471

Call Trace:
 ...
 lock_acquire+0x169/0x2f0 kernel/locking/lockdep.c:5825
 percpu_down_read_internal include/linux/percpu-rwsem.h:53 [inline]
 percpu_down_read_freezable include/linux/percpu-rwsem.h:83 [inline]
 __sb_start_write include/linux/fs.h:1916 [inline]
 sb_start_intwrite include/linux/fs.h:2099 [inline]
 ocfs2_start_trans+0x2a8/0x870 fs/ocfs2/journal.c:370
 ocfs2_truncate_inline+0x389/0xbf0 fs/ocfs2/alloc.c:7436
 ocfs2_truncate_file+0x6d3/0x13c0 fs/ocfs2/file.c:488
 ocfs2_setattr+0xa6d/0x1fd0 fs/ocfs2/file.c:1212
 notify_change+0x4b5/0x1030 fs/attr.c:546
 do_truncate+0x1d2/0x230 fs/open.c:68
 vfs_truncate+0x56c/0x670 fs/open.c:118
 do_sys_truncate fs/open.c:141 [inline]
 __do_sys_truncate fs/open.c:153 [inline]
 __se_sys_truncate fs/open.c:151 [inline]
 __x64_sys_truncate+0x165/0x1d0 fs/open.c:151
 ...

[CAUSE]
ocfs2_truncate_file() and inline range removal hold ip_alloc_sem when
calling ocfs2_truncate_inline().  The helper starts a transaction, which
adds an ip_alloc_sem-to-transaction dependency opposite to the existing
transaction-to-ip_alloc_sem order in the xattr path.

[FIX]
Make ocfs2_truncate_inline() use a caller-owned transaction handle. Start
the inline update transaction before taking ip_alloc_sem in the truncate
and range-removal callers, and release an unused handle if inline data was
converted to extents while waiting for the semaphore. This keeps the
inline update serialized by ip_alloc_sem while preserving a single
transaction-before-ip_alloc_sem order.

Fixes: 85db90e77806 ("ocfs2/xattr: Merge xattr set transaction.")
Signed-off-by: ZhengYuan Huang <gality369@gmail.com>
---
 fs/ocfs2/alloc.c        | 18 ++-------
 fs/ocfs2/alloc.h        |  5 ++-
 fs/ocfs2/file.c         | 83 +++++++++++++++++++++++++++++++++++------
 fs/ocfs2/file.h         |  2 +-
 fs/ocfs2/refcounttree.c |  2 +-
 5 files changed, 81 insertions(+), 29 deletions(-)

diff --git a/fs/ocfs2/alloc.c b/fs/ocfs2/alloc.c
index be09e766ac1f..2f00ab2e2b76 100644
--- a/fs/ocfs2/alloc.c
+++ b/fs/ocfs2/alloc.c
@@ -7412,12 +7412,12 @@ int ocfs2_commit_truncate(struct ocfs2_super *osb,
 /*
  * 'start' is inclusive, 'end' is not.
  */
-int ocfs2_truncate_inline(struct inode *inode, struct buffer_head *di_bh,
-			  unsigned int start, unsigned int end, int trunc)
+int ocfs2_truncate_inline(handle_t *handle, struct inode *inode,
+			  struct buffer_head *di_bh, unsigned int start,
+			  unsigned int end, int trunc)
 {
 	int ret;
 	unsigned int numbytes;
-	handle_t *handle;
 	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
 	struct ocfs2_dinode *di = (struct ocfs2_dinode *)di_bh->b_data;
 	struct ocfs2_inline_data *idata = &di->id2.i_data;
@@ -7444,18 +7444,11 @@ int ocfs2_truncate_inline(struct inode *inode, struct buffer_head *di_bh,
 		goto out;
 	}
 
-	handle = ocfs2_start_trans(osb, OCFS2_INODE_UPDATE_CREDITS);
-	if (IS_ERR(handle)) {
-		ret = PTR_ERR(handle);
-		mlog_errno(ret);
-		goto out;
-	}
-
 	ret = ocfs2_journal_access_di(handle, INODE_CACHE(inode), di_bh,
 				      OCFS2_JOURNAL_ACCESS_WRITE);
 	if (ret) {
 		mlog_errno(ret);
-		goto out_commit;
+		goto out;
 	}
 
 	numbytes = end - start;
@@ -7481,9 +7474,6 @@ int ocfs2_truncate_inline(struct inode *inode, struct buffer_head *di_bh,
 	ocfs2_update_inode_fsync_trans(handle, inode, 1);
 	ocfs2_journal_dirty(handle, di_bh);
 
-out_commit:
-	ocfs2_commit_trans(osb, handle);
-
 out:
 	return ret;
 }
diff --git a/fs/ocfs2/alloc.h b/fs/ocfs2/alloc.h
index 1c0c83362904..95e7f1a7a365 100644
--- a/fs/ocfs2/alloc.h
+++ b/fs/ocfs2/alloc.h
@@ -217,8 +217,9 @@ int ocfs2_zero_range_for_truncate(struct inode *inode, handle_t *handle,
 int ocfs2_commit_truncate(struct ocfs2_super *osb,
 			  struct inode *inode,
 			  struct buffer_head *di_bh);
-int ocfs2_truncate_inline(struct inode *inode, struct buffer_head *di_bh,
-			  unsigned int start, unsigned int end, int trunc);
+int ocfs2_truncate_inline(handle_t *handle, struct inode *inode,
+			  struct buffer_head *di_bh, unsigned int start,
+			  unsigned int end, int trunc);
 
 int ocfs2_find_leaf(struct ocfs2_caching_info *ci,
 		    struct ocfs2_extent_list *root_el, u32 cpos,
diff --git a/fs/ocfs2/file.c b/fs/ocfs2/file.c
index d6e977ba6565..78b039b1a67d 100644
--- a/fs/ocfs2/file.c
+++ b/fs/ocfs2/file.c
@@ -441,6 +441,7 @@ int ocfs2_truncate_file(struct inode *inode,
 			       u64 new_i_size)
 {
 	int status = 0;
+	handle_t *handle = NULL;
 	struct ocfs2_dinode *fe = NULL;
 	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
 
@@ -474,7 +475,23 @@ int ocfs2_truncate_file(struct inode *inode,
 		goto bail;
 	}
 
+	if ((OCFS2_I(inode)->ip_dyn_features & OCFS2_INLINE_DATA_FL) &&
+	    new_i_size < i_size_read(inode)) {
+		handle = ocfs2_start_trans(osb, OCFS2_INODE_UPDATE_CREDITS);
+		if (IS_ERR(handle)) {
+			status = PTR_ERR(handle);
+			handle = NULL;
+			mlog_errno(status);
+			goto bail;
+		}
+	}
+
 	down_write(&OCFS2_I(inode)->ip_alloc_sem);
+	if (!(OCFS2_I(inode)->ip_dyn_features & OCFS2_INLINE_DATA_FL) &&
+	    handle) {
+		ocfs2_commit_trans(osb, handle);
+		handle = NULL;
+	}
 
 	ocfs2_resv_discard(&osb->osb_la_resmap,
 			   &OCFS2_I(inode)->ip_la_data_resv);
@@ -491,10 +508,19 @@ int ocfs2_truncate_file(struct inode *inode,
 		unmap_mapping_range(inode->i_mapping,
 				    new_i_size + PAGE_SIZE - 1, 0, 1);
 		truncate_inode_pages(inode->i_mapping, new_i_size);
-		status = ocfs2_truncate_inline(inode, di_bh, new_i_size,
-					       i_size_read(inode), 1);
-		if (status)
-			mlog_errno(status);
+		if (new_i_size < i_size_read(inode)) {
+			if (unlikely(!handle)) {
+				status = -EIO;
+				mlog_errno(status);
+				goto bail_unlock_sem;
+			}
+
+			status = ocfs2_truncate_inline(handle, inode, di_bh,
+						       new_i_size,
+						       i_size_read(inode), 1);
+			if (status)
+				mlog_errno(status);
+		}
 
 		goto bail_unlock_sem;
 	}
@@ -521,6 +547,8 @@ int ocfs2_truncate_file(struct inode *inode,
 	/* TODO: orphan dir cleanup here. */
 bail_unlock_sem:
 	up_write(&OCFS2_I(inode)->ip_alloc_sem);
+	if (handle)
+		ocfs2_commit_trans(osb, handle);
 
 bail:
 	if (!status && OCFS2_I(inode)->ip_clusters == 0)
@@ -1772,7 +1800,7 @@ static void ocfs2_calc_trunc_pos(struct inode *inode,
 
 int ocfs2_remove_inode_range(struct inode *inode,
 			     struct buffer_head *di_bh, u64 byte_start,
-			     u64 byte_len)
+			     u64 byte_len, handle_t *inline_handle)
 {
 	int ret = 0, flags = 0, done = 0, i;
 	u32 trunc_start, trunc_len, trunc_end, trunc_cpos, phys_cpos;
@@ -1807,11 +1835,20 @@ int ocfs2_remove_inode_range(struct inode *inode,
 			goto out;
 		}
 
-		ret = ocfs2_truncate_inline(inode, di_bh, byte_start,
-					    byte_start + byte_len, 0);
-		if (ret) {
-			mlog_errno(ret);
-			goto out;
+		if (byte_start < i_size_read(inode)) {
+			if (!inline_handle) {
+				ret = -EINVAL;
+				mlog_errno(ret);
+				goto out;
+			}
+
+			ret = ocfs2_truncate_inline(inline_handle, inode,
+						    di_bh, byte_start,
+						    byte_start + byte_len, 0);
+			if (ret) {
+				mlog_errno(ret);
+				goto out;
+			}
 		}
 		/*
 		 * There's no need to get fancy with the page cache
@@ -1953,6 +1990,7 @@ static int __ocfs2_change_file_space(struct file *file, struct inode *inode,
 	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
 	struct buffer_head *di_bh = NULL;
 	handle_t *handle;
+	handle_t *inline_handle = NULL;
 	unsigned long long max_off = inode->i_sb->s_maxbytes;
 
 	if (unlikely(ocfs2_emergency_state(osb)))
@@ -2024,7 +2062,26 @@ static int __ocfs2_change_file_space(struct file *file, struct inode *inode,
 		}
 	}
 
+	if ((cmd == OCFS2_IOC_UNRESVSP || cmd == OCFS2_IOC_UNRESVSP64) &&
+	    (OCFS2_I(inode)->ip_dyn_features & OCFS2_INLINE_DATA_FL) &&
+	    sr->l_start < i_size_read(inode)) {
+		inline_handle = ocfs2_start_trans(osb,
+						  OCFS2_INODE_UPDATE_CREDITS);
+		if (IS_ERR(inline_handle)) {
+			ret = PTR_ERR(inline_handle);
+			inline_handle = NULL;
+			mlog_errno(ret);
+			goto out_inode_unlock;
+		}
+	}
+
 	down_write(&OCFS2_I(inode)->ip_alloc_sem);
+	if (!(OCFS2_I(inode)->ip_dyn_features & OCFS2_INLINE_DATA_FL) &&
+	    inline_handle) {
+		ocfs2_commit_trans(osb, inline_handle);
+		inline_handle = NULL;
+	}
+
 	switch (cmd) {
 	case OCFS2_IOC_RESVSP:
 	case OCFS2_IOC_RESVSP64:
@@ -2038,7 +2095,7 @@ static int __ocfs2_change_file_space(struct file *file, struct inode *inode,
 	case OCFS2_IOC_UNRESVSP:
 	case OCFS2_IOC_UNRESVSP64:
 		ret = ocfs2_remove_inode_range(inode, di_bh, sr->l_start,
-					       sr->l_len);
+					       sr->l_len, inline_handle);
 		break;
 	default:
 		ret = -EINVAL;
@@ -2053,6 +2110,10 @@ static int __ocfs2_change_file_space(struct file *file, struct inode *inode,
 			i_size_write(inode, size);
 	}
 	up_write(&OCFS2_I(inode)->ip_alloc_sem);
+	if (inline_handle) {
+		ocfs2_commit_trans(osb, inline_handle);
+		inline_handle = NULL;
+	}
 	if (ret) {
 		mlog_errno(ret);
 		goto out_inode_unlock;
diff --git a/fs/ocfs2/file.h b/fs/ocfs2/file.h
index 41e65e45a9f3..de6d56aadd2a 100644
--- a/fs/ocfs2/file.h
+++ b/fs/ocfs2/file.h
@@ -70,5 +70,5 @@ int ocfs2_check_range_for_refcount(struct inode *inode, loff_t pos,
 				   size_t count);
 int ocfs2_remove_inode_range(struct inode *inode,
 			     struct buffer_head *di_bh, u64 byte_start,
-			     u64 byte_len);
+			     u64 byte_len, handle_t *inline_handle);
 #endif /* OCFS2_FILE_H */
diff --git a/fs/ocfs2/refcounttree.c b/fs/ocfs2/refcounttree.c
index d9f22b4a2654..e191a62db91d 100644
--- a/fs/ocfs2/refcounttree.c
+++ b/fs/ocfs2/refcounttree.c
@@ -4560,7 +4560,7 @@ static loff_t ocfs2_reflink_remap_extent(struct inode *s_inode,
 		/* Punch out the dest range. */
 		pstart = ocfs2_clusters_to_bytes(t_inode->i_sb, tpos);
 		plen = ocfs2_clusters_to_bytes(t_inode->i_sb, num_clusters);
-		ret = ocfs2_remove_inode_range(t_inode, t_bh, pstart, plen);
+		ret = ocfs2_remove_inode_range(t_inode, t_bh, pstart, plen, NULL);
 		if (ret) {
 			mlog_errno(ret);
 			goto out;
-- 
2.43.0

