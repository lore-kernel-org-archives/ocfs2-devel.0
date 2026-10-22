Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.216.47
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792660133;
	b=5Sdj0qLp6+v0fQQCqEUzHMSzqk0DQJc7yLUR/cjBL4vWTdRFUYQWYKweM6s3v0FT08sE
	 B8gu+39xXPrNxoS/EVgieZfFdsPWZ5VoQ65pDwakqCBHJN6pZF/J8rtW/4myzBJi+v/ZV
	 bz5uqNfKS9EB6XIWV02DIODSAKdbcoAg24vsS05m8uJjqjOE7N75aImoZDhUXxeJWZtns
	 joGMYHr7tJAUajx6YOaiCniMG+o4kKzdmULgvu8RNZD6oB+wjQaxDA2tlnpJu5OLTKmm/
	 XMX5f/5KGN82iHI6Qb2K3joZDINAFmaWPPKBt9eG44Lu9xORnKoviF8F9xmIB7wRVPQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792660133;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-Id:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=z1KCiZXaYqBijXtyLiF7iqAfRTB1Jk4N5AT6pA0XCE0=;
	b=HdjUQYxhMR5kzpUL5wd4aIV0YOW/yGDni7ed7DQr+mu4ofeZlrykF3gdCGMalGSL/Ftr
	 pZNvG9jwuHBTuKYImGDvWVUrv0ovne9vPYyrhnTN3XTduwc3EZHsd0gxMMaFCz5zC+k3T
	 b/+T7SZlhl1gZVTkV7BKl6l2j93D6KiknA456Q3pC2l2PSWoiDJiVPGosZBiLUMiV5FTS
	 22mk9z2zm8UxBtl6YJs72gnB8dCVAbkTmXyFixRuSA19i9VH8+lIarUrSI+prDix8F86d
	 WEHTxICPQFrSYlY2E+DX8ng4XyjqJcRMV7dQusE8y/H1AAlXwqE4NpdHUNWNzTNFM+Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=M6+N2Slo;
	arc=none smtp.remote-ip=209.85.216.47
Received: from mail-pj1-f47.google.com (mail-pj1-f47.google.com [209.85.216.47])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47A55606A31B
	for <ocfs2-devel@lists.linux.dev>; Thu, 22 Oct 2026 09:08:53 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 47A55606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=M6+N2Slo
Received: by mail-pj1-f47.google.com with SMTP id 98e67ed59e1d1-3ac677668a9so1666833a91.2
        for <ocfs2-devel@lists.linux.dev>; Thu, 22 Oct 2026 02:08:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792660133; x=1793264933; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=z1KCiZXaYqBijXtyLiF7iqAfRTB1Jk4N5AT6pA0XCE0=;
        b=M6+N2Slofyb6wfuq+SyOJwUPPW+muoSkn8Oh+Ik054OcoN5mqlVtzgIM6p/c17jQdk
         jnTshXYgvRHamugqr47AM8ZxwURrWE+w6vDQueop66dBFMammS2+7VVOqm7vmyrwO7or
         fUYM6nilr1CXhc8dlmeWpjfAZ4kF1gfoBs11Pc6TdszVZbzrCV7P1fgfNgV/C7PJ5clH
         KjBxdEuCUNMvQ69P5tVqHFlC4ULK2QuKDw9uiCSozFMDnq2QCkK8ybacvts+qYavDZAQ
         tuyuVA759EVBq51LzIEZB9OMdtjSvZvNT+l/05AfEYgEM11YIa9r6NZNQetS5zgJhTnb
         i0tw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792660133; x=1793264933;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=z1KCiZXaYqBijXtyLiF7iqAfRTB1Jk4N5AT6pA0XCE0=;
        b=lwdBNJVD6GQREaRZpctrtg8CJwyFS8mrJ9xavzjbe9S0bjOqENvc8sEJY/BlZee3bM
         umPrUEt0f+6xw/jJ3YK+eUckMcKkKqLKJ0W64OSvO3EwJKV4x5v0BelUnPbr2d4ArI0M
         8UErKFkfD1LUM2a32QDo5xakCXBuDs5AOsKb7s4jHr7jViesbxa0ArJ5fxdu3X5EXRJn
         fmvItdP+uZc/O3vjPwHrI2zV/mHj2h5c0tkZLukjoqpDMhu/6k2qOwPAl4MmAWIsG8od
         AIZpteZlhhIbyBd7JjRMxXyvAGjruIhpataDToBOL4SPIw9CpAnF+GhfM4VeKTDYGbvk
         rXew==
X-Forwarded-Encrypted: i=1; AKwUvBxqBNKCWjcymNGAqXJtkmm5oYpB7mnv5IWGMXVvP91z5mxnUEZkmoqjOmfyR+8aU1uZ7XTQkS7hPV0q5w==@lists.linux.dev
X-Gm-Message-State: AFq9FYJLEEf8ty+d21Td+9Co46lGUDXFQJJ5TqtHuZkMiYiuYqBQZ46P
	J+KVrEA2lx8JxgnN1SdMR7lPhY05+s5Hy1grnEESgnNdqMllK0jPhCwm
X-Gm-Gg: AYBFou2bHjhvWb0Eq8QetR9wuxL3916nClFAKiYwMVTEA92FFYMwXKw1dN5ah+d58cP
	XX3VjvoQL+Zya1AGQ51OGuNoPOhipumjQPN84REUV8RcwGGoGFSNMq/+XAgsYwtxJTdvyY/WN98
	tD8S8j223OTocAfyXVdQTPsbS/bFoliidvbPP0rv7uT2lLwWZVpXQ1WnD2hEe88dv8CZrFHxszE
	vho+BsavLfjPklzdgqZJNA/qqdrLPCIFzmzvln5TDiUbvW9ZM3VCGFIfBE/GXgIglrkyZB2JL+J
	fK5xY3x395xE/gnqvRUHIvCTpRKHHmD6WtDxj47m8axn3ZkQkJxiT3YvV90ifs67EQYA0g4i9aS
	pa/fPEN1R1Qg8UMptpDe+qvlr1W2EQXFb3mTCxcb6Mfg4HawiYV8VEQwciT6QgxFtCzlLdH59bD
	83zt1Dn65yJbFHJw2WZcD0wKHZ+GUAIuvdU5H5ZuS/F9YKo6nZFSjcNopvCksPhvdM4r4gdCuGV
	4QIf8W0dYiojyy1ET0ciDn7x6vQe3moL4YXHJrhFVvoQ7f168XWtHouhYpW9gB9zD5Lpxhj
X-Received: by 2002:a17:90b:c0b:b0:3ad:8ecc:5907 with SMTP id 98e67ed59e1d1-3ad8ecc5cf2mr2334684a91.56.1792660132383;
        Thu, 22 Oct 2026 02:08:52 -0700 (PDT)
Received: from localhost ([111.228.63.84])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3ada490c096sm3325111a91.7.2026.10.22.02.08.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Oct 2026 02:08:52 -0700 (PDT)
From: Cen Zhang <zzzccc427@gmail.com>
To: mark@fasheh.com,
	jlbec@evilplan.org,
	joseph.qi@linux.alibaba.com
Cc: heming.zhao@suse.com,
	ocfs2-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org,
	baijiaju1990@gmail.com,
	jjzuming@gmail.com,
	zzzccc427@gmail.com
Subject: [PATCH v4 1/2] ocfs2: snapshot dentry names in file and setattr traces
Date: Thu, 22 Oct 2026 17:08:41 +0800
Message-Id: <pm-ocfs2-objects-candidate-0088-v7-6324344256f0c3b1c3d8-1@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <pm-ocfs2-objects-candidate-0088-v7-6324344256f0c3b1c3d8-0@gmail.com>
References: <pm-ocfs2-objects-candidate-0088-v7-6324344256f0c3b1c3d8-0@gmail.com>
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Post: <mailto:ocfs2-devel@lists.linux.dev>
List-Help: <mailto:ocfs2-devel+help@lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
List-Owner: <mailto:ocfs2-devel+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The open, fsync, read, write and splice-read trace calls pass the live
dentry name and length to the shared ocfs2__file_ops event class.
ocfs2_setattr() passes the same unprotected arguments to its own event.
Both events size and copy a __string field separately. A reference to
the dentry does not pin the external storage backing an individual name.

With an event enabled, a caller can be preempted after loading the name
pointer. A long-to-short rename can then replace the name and reclaim its
old external allocation before the trace callback sizes or copies it,
provided no other snapshot retains that allocation.

The setattr inode lock does not exclude every rename: a same-directory
rename of a source directory need not take that directory's inode lock.
It can therefore change the dentry name while setattr records its event.
Inline names and separately loaded lengths can also change during trace
record sizing and copying.

Take a dentry name snapshot around each of these six trace calls and
pass both the string and length from the snapshot. Check event enablement
before taking a snapshot. Keep the event classes and formats unchanged.

Also remove the redundant NULL-inode check in the read callback.
file_inode() returns the open file's inode, which is already used by the
trace call above the check.

The historical report below is from the read path.

KASAN report as below:

    BUG: KASAN: slab-use-after-free in strlen+0x85/0xa0
    Read of size 1 at addr ffff88810a5b2b18 by task python3/496

    [CPU and host details omitted.]
    Call Trace:
     <TASK>
     dump_stack_lvl+0x93/0xd0
     print_report+0xce/0x630
     ? strlen+0x85/0xa0
     ? srso_alias_return_thunk+0x5/0xfbef5
     ? __virt_addr_valid+0x20e/0x420
     ? strlen+0x85/0xa0
     kasan_report+0xe0/0x110
     ? strlen+0x85/0xa0
     strlen+0x85/0xa0
     trace_event_raw_event_ocfs2__file_ops+0xf0/0x480
     ? __pfx_trace_event_raw_event_ocfs2__file_ops+0x10/0x10
     ? srso_alias_return_thunk+0x5/0xfbef5
     ? pmbd_probe_hit_cookie+0xe7/0x1c0
     ? srso_alias_return_thunk+0x5/0xfbef5
     ? __pfx_pmbd_probe_hit_cookie+0x10/0x10
     ocfs2_file_read_iter+0x6cd/0xb30
     ? __pfx_ocfs2_file_read_iter+0x10/0x10
     ? selinux_file_permission+0x11d/0x540
     ? srso_alias_return_thunk+0x5/0xfbef5
     ? security_file_permission+0x26/0x80
     vfs_read+0x7d2/0xc20
     ? __pfx_vfs_read+0x10/0x10
     ? srso_alias_return_thunk+0x5/0xfbef5
     ? __pfx_do_sys_openat2+0x10/0x10
     ksys_read+0x111/0x200
     ? __pfx_ksys_read+0x10/0x10
     ? irqentry_exit+0xbe/0x820
     ? srso_alias_return_thunk+0x5/0xfbef5
     ? trace_hardirqs_on_prepare+0x11d/0x150
     ? srso_alias_return_thunk+0x5/0xfbef5
     do_syscall_64+0x114/0x620
     entry_SYSCALL_64_after_hwframe+0x77/0x7f
    [User register dump omitted.]
     </TASK>

    Allocated by task 489:
     kasan_save_stack+0x33/0x60
     kasan_save_track+0x14/0x30
     __kasan_kmalloc+0xaa/0xb0
     __kmalloc_noprof+0x2de/0x780
     __d_alloc+0x5fc/0x8c0
     d_alloc_parallel+0x106/0x11d0
     lookup_open+0x3ff/0x13e0
     path_openat+0x95e/0x2020
     do_file_open+0x21e/0x470
     do_sys_openat2+0xf4/0x1b0
     __x64_sys_openat+0x136/0x1e0
     do_syscall_64+0x114/0x620
     entry_SYSCALL_64_after_hwframe+0x77/0x7f

    Freed by task 0:
     kasan_save_stack+0x33/0x60
     kasan_save_track+0x14/0x30
     kasan_save_free_info+0x3b/0x60
     __kasan_slab_free+0x5f/0x80
     __rcu_free_sheaf_prepare+0x65/0x2a0
     rcu_free_sheaf_nobarn+0x1d/0x50
     rcu_core+0x6be/0x1ed0
     handle_softirqs+0x1fa/0x8d0
     __irq_exit_rcu+0x113/0x1e0
     irq_exit_rcu+0xe/0x20
     sysvec_apic_timer_interrupt+0x6c/0x80
     asm_sysvec_apic_timer_interrupt+0x1a/0x20

    The buggy address belongs to the object at ffff88810a5b2b00
     which belongs to the cache kmalloc-rcl-192 of size 192
    The buggy address is located 24 bytes inside of
     freed 192-byte region [ffff88810a5b2b00, ffff88810a5b2bc0)

    [Page and shadow-memory dumps omitted.]

Fixes: 468eedde23d6 ("ocfs2: Remove mlog(0) from fs/ocfs2/file.c")
Cc: stable@vger.kernel.org
Assisted-by: LLM
Signed-off-by: Cen Zhang <zzzccc427@gmail.com>
---
 fs/ocfs2/file.c | 100 +++++++++++++++++++++++++++++++-----------------
 1 file changed, 64 insertions(+), 36 deletions(-)

diff --git a/fs/ocfs2/file.c b/fs/ocfs2/file.c
index d6e977ba6565..c6e7606ff9e1 100644
--- a/fs/ocfs2/file.c
+++ b/fs/ocfs2/file.c
@@ -85,10 +85,17 @@ static int ocfs2_file_open(struct inode *inode, struct file *file)
 	int mode = file->f_flags;
 	struct ocfs2_inode_info *oi = OCFS2_I(inode);
 
-	trace_ocfs2_file_open(inode, file, file->f_path.dentry,
-			      (unsigned long long)oi->ip_blkno,
-			      file->f_path.dentry->d_name.len,
-			      file->f_path.dentry->d_name.name, mode);
+	if (trace_ocfs2_file_open_enabled()) {
+		struct dentry *dentry = file->f_path.dentry;
+		struct name_snapshot name;
+
+		take_dentry_name_snapshot(&name, dentry);
+		trace_ocfs2_file_open(inode, file, dentry,
+				      oi->ip_blkno,
+				      name.name.len, name.name.name,
+				      mode);
+		release_dentry_name_snapshot(&name);
+	}
 
 	if (file->f_mode & FMODE_WRITE) {
 		status = dquot_initialize(inode);
@@ -174,11 +181,17 @@ static int ocfs2_sync_file(struct file *file, loff_t start, loff_t end,
 	tid_t commit_tid;
 	bool needs_barrier = false;
 
-	trace_ocfs2_sync_file(inode, file, file->f_path.dentry,
-			      oi->ip_blkno,
-			      file->f_path.dentry->d_name.len,
-			      file->f_path.dentry->d_name.name,
-			      (unsigned long long)datasync);
+	if (trace_ocfs2_sync_file_enabled()) {
+		struct dentry *dentry = file->f_path.dentry;
+		struct name_snapshot name;
+
+		take_dentry_name_snapshot(&name, dentry);
+		trace_ocfs2_sync_file(inode, file, dentry,
+				      oi->ip_blkno,
+				      name.name.len, name.name.name,
+				      (unsigned long long)datasync);
+		release_dentry_name_snapshot(&name);
+	}
 
 	if (unlikely(ocfs2_emergency_state(osb)))
 		return -EROFS;
@@ -1132,15 +1145,19 @@ int ocfs2_setattr(struct mnt_idmap *idmap, struct dentry *dentry,
 	int had_lock;
 	struct ocfs2_lock_holder oh;
 
-	trace_ocfs2_setattr(inode, dentry,
-			    (unsigned long long)OCFS2_I(inode)->ip_blkno,
-			    dentry->d_name.len, dentry->d_name.name,
-			    attr->ia_valid,
-				attr->ia_valid & ATTR_MODE ? attr->ia_mode : 0,
-				attr->ia_valid & ATTR_UID ?
+	if (trace_ocfs2_setattr_enabled()) {
+		struct name_snapshot name;
+
+		take_dentry_name_snapshot(&name, dentry);
+		trace_ocfs2_setattr(inode, dentry, OCFS2_I(inode)->ip_blkno,
+				    name.name.len, name.name.name, attr->ia_valid,
+				    attr->ia_valid & ATTR_MODE ? attr->ia_mode : 0,
+				    attr->ia_valid & ATTR_UID ?
 					from_kuid(&init_user_ns, attr->ia_uid) : 0,
-				attr->ia_valid & ATTR_GID ?
+				    attr->ia_valid & ATTR_GID ?
 					from_kgid(&init_user_ns, attr->ia_gid) : 0);
+		release_dentry_name_snapshot(&name);
+	}
 
 	status = ocfs2_emergency_state(osb);
 	if (unlikely(status)) {
@@ -2392,11 +2409,17 @@ static ssize_t ocfs2_file_write_iter(struct kiocb *iocb,
 	int direct_io = iocb->ki_flags & IOCB_DIRECT ? 1 : 0;
 	int nowait = iocb->ki_flags & IOCB_NOWAIT ? 1 : 0;
 
-	trace_ocfs2_file_write_iter(inode, file, file->f_path.dentry,
-		(unsigned long long)OCFS2_I(inode)->ip_blkno,
-		file->f_path.dentry->d_name.len,
-		file->f_path.dentry->d_name.name,
-		(unsigned int)from->nr_segs);	/* GRRRRR */
+	if (trace_ocfs2_file_write_iter_enabled()) {
+		struct dentry *dentry = file->f_path.dentry;
+		struct name_snapshot name;
+
+		take_dentry_name_snapshot(&name, dentry);
+		trace_ocfs2_file_write_iter(inode, file, dentry,
+					    OCFS2_I(inode)->ip_blkno,
+					    name.name.len, name.name.name,
+					    (unsigned int)from->nr_segs);
+		release_dentry_name_snapshot(&name);
+	}
 
 	if (!direct_io && nowait)
 		return -EOPNOTSUPP;
@@ -2542,17 +2565,16 @@ static ssize_t ocfs2_file_read_iter(struct kiocb *iocb,
 	int direct_io = iocb->ki_flags & IOCB_DIRECT ? 1 : 0;
 	int nowait = iocb->ki_flags & IOCB_NOWAIT ? 1 : 0;
 
-	trace_ocfs2_file_read_iter(inode, filp, filp->f_path.dentry,
-			(unsigned long long)OCFS2_I(inode)->ip_blkno,
-			filp->f_path.dentry->d_name.len,
-			filp->f_path.dentry->d_name.name,
-			to->nr_segs);	/* GRRRRR */
-
+	if (trace_ocfs2_file_read_iter_enabled()) {
+		struct dentry *dentry = filp->f_path.dentry;
+		struct name_snapshot name;
 
-	if (!inode) {
-		ret = -EINVAL;
-		mlog_errno(ret);
-		goto bail;
+		take_dentry_name_snapshot(&name, dentry);
+		trace_ocfs2_file_read_iter(inode, filp, dentry,
+					   OCFS2_I(inode)->ip_blkno,
+					   name.name.len, name.name.name,
+					   to->nr_segs);
+		release_dentry_name_snapshot(&name);
 	}
 
 	if (!direct_io && nowait)
@@ -2624,11 +2646,17 @@ static ssize_t ocfs2_file_splice_read(struct file *in, loff_t *ppos,
 	ssize_t ret = 0;
 	int lock_level = 0;
 
-	trace_ocfs2_file_splice_read(inode, in, in->f_path.dentry,
-				     (unsigned long long)OCFS2_I(inode)->ip_blkno,
-				     in->f_path.dentry->d_name.len,
-				     in->f_path.dentry->d_name.name,
-				     flags);
+	if (trace_ocfs2_file_splice_read_enabled()) {
+		struct dentry *dentry = in->f_path.dentry;
+		struct name_snapshot name;
+
+		take_dentry_name_snapshot(&name, dentry);
+		trace_ocfs2_file_splice_read(inode, in, dentry,
+					     OCFS2_I(inode)->ip_blkno,
+					     name.name.len, name.name.name,
+					     flags);
+		release_dentry_name_snapshot(&name);
+	}
 
 	/*
 	 * We're fine letting folks race truncates and extending writes with

