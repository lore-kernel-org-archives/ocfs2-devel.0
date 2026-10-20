Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.214.182
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792467843;
	b=N5NrEN3b8UoGV6zmSGdO1t4Y47h/O6fl6BjhPUfa4pJ7WJRo8LawD6A2dE7X24sa4sJm
	 TCR17QQsNtvC8rznO77viL2mRYeJaTrhQ2XUwTfw/Dij/QuQE2WP+9FAqmvZ+v3xz+pIi
	 8uwXbE8iCxyHVxz0yslsucjSM6dwmBSFk+BmlP1WMD/0Ln0Xm6AuJeH+KYhmZxElxoOJb
	 Qk/x8i5Bvh+LLYrhTZjVUmFHn1jXNEZMmurFXvAPATSHBM7T1D8yAMWoY65gUQVT6hDUs
	 R0HeV2Ex6IaHmtRBJxAmoGZwRD59BiodgwLbyTWmfF3Sb3ULA3KsZ7u68jX13yxm4fw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792467843;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-Id:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=7G78s70fxYPpMVHiegw9OWYXdiOyfEaNVnOA7iPMn0o=;
	b=CRdl+M2sieLrcoKURjTs1mm0GOM04EjnmxfZbt8vRD7lL/bxxUQSykaVbwCqqnlY0s+V
	 WnRcZuuYCRiEQDhQGRFdIhK9WwrkFgfBpVsmsrZhOeHfW2gwbcZe6HD6e13TZFSiUc12B
	 Oa63j8VbEozSVW2G4ViBvRH/n+cGS8YXg7FJpAi+rq2QaNuZOzo8ZglaZuEHnVFaO7xMU
	 yEavYkzBqTbGT3Kie2xwHg6rA9fjbZ5M99zMxN6gdLx1RroVKFrp9Iz5cpErsPGjZg+j2
	 dfXQ/2vm7nF8V3IvFBB26msa6Fi9K/6DFcJslIL0Zh4Fb33+BqH0fXESgdQUl9Cr6nw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=b6J9AgZr;
	arc=none smtp.remote-ip=209.85.214.182
Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0EF15606A321
	for <ocfs2-devel@lists.linux.dev>; Tue, 20 Oct 2026 03:44:02 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 0EF15606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=b6J9AgZr
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-2e9eb579c0eso9837715ad.3
        for <ocfs2-devel@lists.linux.dev>; Mon, 19 Oct 2026 20:44:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792467842; x=1793072642; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=7G78s70fxYPpMVHiegw9OWYXdiOyfEaNVnOA7iPMn0o=;
        b=b6J9AgZrlzvGHm4TMrZb4IbIRtImRuUjHvruDzhZfTf6vYudY8r1E5yN9wIBXF9xIX
         i3L7nix84sjZiAPeT8w8irHC1+Ol7RJWG9QE6tpKiUm543OS38X5RLy4/Shp7EG06JUS
         Hv7FDnG9I+RY7KjcOuIzF9n7T8GDIIjzY9Jsr0ecj20/k6c7mpIzVlCG0Jor+ffLGWxD
         /Ylj+CImAtBy/NzMvRnCXRmHRysL8mMjopdFhgMG4vnfIdZu+KdhxZGkqoA1N9y1PWsP
         is/3SpVj46Z+Ap2pYzDf8ABayvzrMm6UNMiOpsJ6o2Pn4f86f1dndHeTXAaovwizR2L+
         Ymrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792467842; x=1793072642;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=7G78s70fxYPpMVHiegw9OWYXdiOyfEaNVnOA7iPMn0o=;
        b=Y1XuSA+Dkn6bTynrMu3X4nvrcG5kcRyOkf8iy1BBwMVXBCiX2ImKpxj60Kc/jLY0CQ
         RabreEIL0JGVqXonE4kIPFPNF7nGDH3fz6DVFccEuP+fCBEWPtKL1TqgtFi7AlUUqzts
         QwfcAs9U2C28JgXb3wjchIfcnt18ig1Y+rBzHTudL4PXaGx8E4PAW9Hg7ytcZJO0Z+fM
         F0vzWA9Yi2SZMIGRC+jlyXxDnRK0FHqIM6kKKgv2Z49md+zMBCgNkGRgncHxsPrwyDRH
         T0ceua2NiaTtAXLmgKMkSjMVXrbFKQPh73yDJ9jx7srYvix0TsykW3JgZ87I1v7sApyT
         rtIQ==
X-Forwarded-Encrypted: i=1; AKwUvBzCTswa9nufs2LqFWfRDm5rrQ9209p3tB8aWtUOsSsDE9bkExw2SCH7KNldXlBiJH6NdQnGJlJ2dIzpIA==@lists.linux.dev
X-Gm-Message-State: AFq9FYLznIP621ICgpr9815njdipzbUoa4m+xdOENSO//e9MKwFkpMZn
	Um1MEt0FQww+20PjYj42JD1XtwIpdrJ/yqxbUyT/vojIz7UCpQjSuMWM
X-Gm-Gg: AYBFou199lax07VhmES4bMH5SpQMn/q49114nokGO5Zf6lqnRNy/KUq5ylqjv3U5CBV
	gDwGSizru4B3A3YeT91yidWWfxzTlXru0oIIpR4/MtFQuWpU6qaOhq29X1G/lMy0S36AdVxe0nG
	/ZUaoIf//1lrO3j1dKglx/A0HbOjPadqqVxJopNcGEj7AGCm2eIOjwMBT/Y3gzi3GkHMl7BKAK+
	9Ee9FHafelDjuln5OO9aGJ3fr5iL2NEchnNCKqZuuT1Ac4q6+d9K7WJUGeqQ8vTS2/rruhnJZgW
	gNU9TjSJ8ep1EcNP/NuH+10lrg/AAqQAO+DdvTFmgrqJ0NiDmpwCapNsokXWGMjtlPUfT7D/JV2
	hSee3UIxeRKiXFBFLmCoLM73yfOUrs6qxiaaebGd54lBrALnVAFvFh4gZpogGOyaWJYL+fuQsrg
	DYqzH/zUJKm99T2HVYdOiMPRkwU8Bc3nIj4nDEuUbycM7pmQUScpI15/tr5cyycAu6hw==
X-Received: by 2002:a17:902:f693:b0:2e9:5b20:1c2b with SMTP id d9443c01a7336-2e9a682f478mr79240345ad.5.1792467842240;
        Mon, 19 Oct 2026 20:44:02 -0700 (PDT)
Received: from localhost ([111.228.63.84])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2ea14caa857sm8143885ad.12.2026.10.19.20.43.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Oct 2026 20:44:01 -0700 (PDT)
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
Subject: [PATCH v3 1/2] ocfs2: snapshot dentry names in file-operation traces
Date: Tue, 20 Oct 2026 11:43:51 +0800
Message-Id: <pm-ocfs2-objects-candidate-0088-v6-d3056754af7e660155d9-1@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <pm-ocfs2-objects-candidate-0088-v6-d3056754af7e660155d9-0@gmail.com>
References: <pm-ocfs2-objects-candidate-0088-v6-d3056754af7e660155d9-0@gmail.com>
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
dentry name and length to the shared ocfs2__file_ops event class. A
file reference pins the dentry, but not the external allocation backing
an individual name. The event needs those bytes when sizing its
__string field and when copying the string into the trace record.

With the relevant event enabled, a caller can be preempted after
evaluating its name argument. A concurrent long-to-short rename of
the same dentry can replace and reclaim the external name before
the trace callback uses it, provided no other snapshot retains it:

  File-operation caller                Renamer
  ---------------------                -------
  load d_name.name
  <preempted>
                                       vfs_rename()
                                         ocfs2_rename()
                                           ocfs2_dentry_move()
                                             d_move()/copy_name()
                                       release rename name snapshot
                                       RCU reclamation completes
  trace callback sizes/copies
    through the old name pointer

The pointer argument is evaluated before the trace wrapper protects
probe execution, so that protection does not cover the old name
across this window. Inline names and separately read lengths can also
change while the event is being recorded.

Take a dentry name snapshot around each of these five trace calls and
pass both the string and its length from the snapshot. Inline names
are copied and external names stay referenced until the trace call
finishes. Check each event-enabled flag before taking a snapshot so
disabled tracing does not incur snapshot work. The trace event class
and its format stay unchanged.

The report below is from the read path; the other four call sites
have the same unprotected name argument.

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
 fs/ocfs2/file.c | 79 ++++++++++++++++++++++++++++++++++---------------
 1 file changed, 55 insertions(+), 24 deletions(-)

diff --git a/fs/ocfs2/file.c b/fs/ocfs2/file.c
index d6e977ba6565..3c4637b32c09 100644
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
@@ -2392,11 +2405,17 @@ static ssize_t ocfs2_file_write_iter(struct kiocb *iocb,
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
@@ -2542,11 +2561,17 @@ static ssize_t ocfs2_file_read_iter(struct kiocb *iocb,
 	int direct_io = iocb->ki_flags & IOCB_DIRECT ? 1 : 0;
 	int nowait = iocb->ki_flags & IOCB_NOWAIT ? 1 : 0;
 
-	trace_ocfs2_file_read_iter(inode, filp, filp->f_path.dentry,
-			(unsigned long long)OCFS2_I(inode)->ip_blkno,
-			filp->f_path.dentry->d_name.len,
-			filp->f_path.dentry->d_name.name,
-			to->nr_segs);	/* GRRRRR */
+	if (trace_ocfs2_file_read_iter_enabled()) {
+		struct dentry *dentry = filp->f_path.dentry;
+		struct name_snapshot name;
+
+		take_dentry_name_snapshot(&name, dentry);
+		trace_ocfs2_file_read_iter(inode, filp, dentry,
+					   OCFS2_I(inode)->ip_blkno,
+					   name.name.len, name.name.name,
+					   to->nr_segs);
+		release_dentry_name_snapshot(&name);
+	}
 
 
 	if (!inode) {
@@ -2624,11 +2649,17 @@ static ssize_t ocfs2_file_splice_read(struct file *in, loff_t *ppos,
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

