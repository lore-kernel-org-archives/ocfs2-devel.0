Received: from mail-wr1-f52.google.com (mail-wr1-f52.google.com [209.85.221.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E4355812E
	for <ocfs2-devel@lists.linux.dev>; Thu, 28 Mar 2024 08:30:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711614603; cv=none; b=SyRXdA67X805V0oc6mgHHsIT9G6jIUyST7BLH22p3aN84C17NMEdE/MB6FgOXzuQMzQI4CpOH9gziwmb/4fbuqR+y+iYz/DoNCQUrPBr6z/j4baYfde3kiD5I+O7Jp1W/Qs+Br7SS2XTbj+A7/p3HDCiTcFQCcWinFQdBaZ0nT0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711614603; c=relaxed/simple;
	bh=Q0TEkfqZ734OAkVo3eJn5DhMwPk6HWitFWXszy/6yaI=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=UJso0302THb+IvkLkXqNKALyzRGhzbXUff/w8b/5xrrC75wsqAGlxHtgCqk8EfKGI0fmJIC5Jh6MrXbh2yrCiW2P5ylPTrKwusUKotE8gjNBMvbbnpCtO0/FQVYMPMb7uXiDLEUsJX9whXGHptargC/Biz+yMLD4fGBHgfdpP+0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=WWqchexs; arc=none smtp.client-ip=209.85.221.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="WWqchexs"
Received: by mail-wr1-f52.google.com with SMTP id ffacd0b85a97d-33d90dfe73cso341781f8f.0
        for <ocfs2-devel@lists.linux.dev>; Thu, 28 Mar 2024 01:30:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1711614599; x=1712219399; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BQRe3A+3g++uHkd3C5qAgwrkUaosDRISKLrq0uWVnUg=;
        b=WWqchexs3QWnXlEsHMmq50Ng+GZiY4DEKJZHbrlqriMEY3C/6OlzgbsXtdJlosfwSf
         rjPWGcrLHFZQDHXU9mTG+PFdAUO1rVtDHyPn6vh5apUx9HWYkKIGyrgeZr+vhpdXlPZ7
         evI+hi3KdoxunyQwuAlWRFeFY2n2W6m7i4BDzd7ogxqI0keaf+mEPY8ueRkKzNVW8WEC
         49Tz51/3WYmQ3qXl6a0BuMoaVoX7azH9nyAKGxKetzo6vCjWQCkPQuxRBfQRUhDTJsMv
         ptnvPSmaMd+yAvq461Twe9Ut7dFkLw2Z8+vPbYni0H5E7qCWsWvyEfGT8+md2rElNLuA
         FXXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711614599; x=1712219399;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=BQRe3A+3g++uHkd3C5qAgwrkUaosDRISKLrq0uWVnUg=;
        b=wdq2JxdhW2G9lqrodwdSPiayINYcLgjX5GTU/eNQXZ54Nw0r5gwpSgX5LZVcJS4qAN
         J8Vqt7uNbuatakgGcf4/fEuaStaXlSdfZh7YbLw89Ke5vSMyfk5l7T2pHoX2J2qwjznL
         2rjE2MCQFGkTEbR2Cq37VHg4CY2ULdEvnPBEQZBsXeRYLX9PS8Pk0nyx22RzgryFphMd
         9IUWx4nTiHzgNKnzuSLzMUEDdnyUdzY4Hljq4vK3h+tA0ex7YONSqwbxMAAzy6HjUV07
         3d08Cd/LaXjImQYGhKUYWO8m0AonAmvpPFZtVO1aa+HC2dGRFC/o5yQ8uSMOE1hIL8gH
         pRWg==
X-Forwarded-Encrypted: i=1; AJvYcCU1A2cO+I3tVmso5YtHinVo1G4G0gTTxm53JEB+H/mbf56HQCn1LnQVn27bPrtCckGev/FKmhFL1ASWPa0p1ls7mCcJ1Ao+w++3WSI=
X-Gm-Message-State: AOJu0YzVIhFpbiH2tRyy+xW7JEJdwcwK5+dc2NaDzTVw4y/TgSpq+8rR
	QBR9/y7LsEsx5e55Kozj6/yjzOybx8vTG0uZudP0XKxOomhXlZpTVLdQSGljeUG8AZJ2ee0FedN
	3
X-Google-Smtp-Source: AGHT+IFwGtXi8qJPm1eMXbHHsnpIdFUATIwjqXdbeqhIVqjVfISfua9rLxBWNAl/Y4pQgZZyVr8F+Q==
X-Received: by 2002:a5d:4ccc:0:b0:33e:c0fc:5e4b with SMTP id c12-20020a5d4ccc000000b0033ec0fc5e4bmr1294327wrt.2.1711614598862;
        Thu, 28 Mar 2024 01:29:58 -0700 (PDT)
Received: from c73.suse.cz ([202.127.77.110])
        by smtp.gmail.com with ESMTPSA id b15-20020a170902650f00b001e014627baasm955120plk.79.2024.03.28.01.29.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Mar 2024 01:29:58 -0700 (PDT)
From: Heming Zhao <heming.zhao@suse.com>
To: joseph.qi@linux.alibaba.com
Cc: Heming Zhao <heming.zhao@suse.com>,
	ocfs2-devel@lists.linux.dev,
	ailiop@suse.com
Subject: [PATCH v5 4/4] ocfs2: fix sparse warnings
Date: Thu, 28 Mar 2024 16:29:43 +0800
Message-Id: <20240328082943.20251-5-heming.zhao@suse.com>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20240328082943.20251-1-heming.zhao@suse.com>
References: <20240328082943.20251-1-heming.zhao@suse.com>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

1.
fs/ocfs2/localalloc.c:1224:41: warning: incorrect type in argument 1 (different base types)
fs/ocfs2/localalloc.c:1224:41:    expected unsigned long long val1
fs/ocfs2/localalloc.c:1224:41:    got restricted __le32 [usertype] la_bm_off

2.
fs/ocfs2/export.c:258:32: warning: cast to restricted __le32
fs/ocfs2/export.c:259:33: warning: cast to restricted __le32
fs/ocfs2/export.c:260:32: warning: cast to restricted __le32
fs/ocfs2/export.c:272:32: warning: cast to restricted __le32
fs/ocfs2/export.c:273:33: warning: cast to restricted __le32
fs/ocfs2/export.c:274:32: warning: cast to restricted __le32

3.
fs/ocfs2/inode.c:1623:13: warning: context imbalance in 'ocfs2_inode_cache_lock' - wrong count at exit
fs/ocfs2/inode.c:1630:13: warning: context imbalance in 'ocfs2_inode_cache_unlock' - unexpected unlock

4.
fs/ocfs2/refcounttree.c:633:27: warning: incorrect type in assignment (different base types)
fs/ocfs2/refcounttree.c:633:27:    expected restricted __le32 [usertype] rf_generation
fs/ocfs2/refcounttree.c:633:27:    got unsigned int

5.
fs/ocfs2/dlm/dlmdomain.c:1316:20: warning: context imbalance in 'dlm_query_nodeinfo_handler' - different lock contexts for basic block

6.
fs/ocfs2/dlm/dlmrecovery.c:2950:9: warning: context imbalance in 'dlm_finalize_reco_handler' - different lock contexts for basic block

Signed-off-by: Heming Zhao <heming.zhao@suse.com>
---
v5: (first version)
- localalloc.c fix (No: 1) is split from v4 patch 3/3.
- new sparse warnings fixes (No: 2~6) for other files.

---
 fs/ocfs2/dlm/dlmdomain.c   | 11 +++++------
 fs/ocfs2/dlm/dlmrecovery.c |  4 ++++
 fs/ocfs2/export.c          | 12 ++++++------
 fs/ocfs2/inode.c           |  2 ++
 fs/ocfs2/localalloc.c      |  4 ++--
 fs/ocfs2/refcounttree.c    |  2 +-
 6 files changed, 20 insertions(+), 15 deletions(-)

diff --git a/fs/ocfs2/dlm/dlmdomain.c b/fs/ocfs2/dlm/dlmdomain.c
index 5c04dde99981..2e0a2f338282 100644
--- a/fs/ocfs2/dlm/dlmdomain.c
+++ b/fs/ocfs2/dlm/dlmdomain.c
@@ -1274,7 +1274,7 @@ static int dlm_query_nodeinfo_handler(struct o2net_msg *msg, u32 len,
 {
 	struct dlm_query_nodeinfo *qn;
 	struct dlm_ctxt *dlm = NULL;
-	int locked = 0, status = -EINVAL;
+	int status = -EINVAL;
 
 	qn = (struct dlm_query_nodeinfo *) msg->buf;
 
@@ -1290,12 +1290,11 @@ static int dlm_query_nodeinfo_handler(struct o2net_msg *msg, u32 len,
 	}
 
 	spin_lock(&dlm->spinlock);
-	locked = 1;
 	if (dlm->joining_node != qn->qn_nodenum) {
 		mlog(ML_ERROR, "Node %d queried nodes on domain %s but "
 		     "joining node is %d\n", qn->qn_nodenum, qn->qn_domain,
 		     dlm->joining_node);
-		goto bail;
+		goto unlock;
 	}
 
 	/* Support for node query was added in 1.1 */
@@ -1305,14 +1304,14 @@ static int dlm_query_nodeinfo_handler(struct o2net_msg *msg, u32 len,
 		     "but active dlm protocol is %d.%d\n", qn->qn_nodenum,
 		     qn->qn_domain, dlm->dlm_locking_proto.pv_major,
 		     dlm->dlm_locking_proto.pv_minor);
-		goto bail;
+		goto unlock;
 	}
 
 	status = dlm_match_nodes(dlm, qn);
 
+unlock:
+	spin_unlock(&dlm->spinlock);
 bail:
-	if (locked)
-		spin_unlock(&dlm->spinlock);
 	spin_unlock(&dlm_domain_lock);
 
 	return status;
diff --git a/fs/ocfs2/dlm/dlmrecovery.c b/fs/ocfs2/dlm/dlmrecovery.c
index 50da8af988c1..40a0e5df3de0 100644
--- a/fs/ocfs2/dlm/dlmrecovery.c
+++ b/fs/ocfs2/dlm/dlmrecovery.c
@@ -2917,8 +2917,11 @@ int dlm_finalize_reco_handler(struct o2net_msg *msg, u32 len, void *data,
 		BUG();
 	}
 
+	spin_unlock(&dlm->spinlock);
+
 	switch (stage) {
 		case 1:
+			spin_lock(&dlm->spinlock);
 			dlm_finish_local_lockres_recovery(dlm, fr->dead_node, fr->node_idx);
 			if (dlm->reco.state & DLM_RECO_STATE_FINALIZE) {
 				mlog(ML_ERROR, "%s: received finalize1 from "
@@ -2932,6 +2935,7 @@ int dlm_finalize_reco_handler(struct o2net_msg *msg, u32 len, void *data,
 			spin_unlock(&dlm->spinlock);
 			break;
 		case 2:
+			spin_lock(&dlm->spinlock);
 			if (!(dlm->reco.state & DLM_RECO_STATE_FINALIZE)) {
 				mlog(ML_ERROR, "%s: received finalize2 from "
 				     "new master %u for dead node %u, but "
diff --git a/fs/ocfs2/export.c b/fs/ocfs2/export.c
index b8b6a191b5cb..96b684763b39 100644
--- a/fs/ocfs2/export.c
+++ b/fs/ocfs2/export.c
@@ -255,9 +255,9 @@ static struct dentry *ocfs2_fh_to_dentry(struct super_block *sb,
 	if (fh_len < 3 || fh_type > 2)
 		return NULL;
 
-	handle.ih_blkno = (u64)le32_to_cpu(fid->raw[0]) << 32;
-	handle.ih_blkno |= (u64)le32_to_cpu(fid->raw[1]);
-	handle.ih_generation = le32_to_cpu(fid->raw[2]);
+	handle.ih_blkno = (u64)le32_to_cpu((__force __le32)fid->raw[0]) << 32;
+	handle.ih_blkno |= (u64)le32_to_cpu((__force __le32)fid->raw[1]);
+	handle.ih_generation = le32_to_cpu((__force __le32)fid->raw[2]);
 	return ocfs2_get_dentry(sb, &handle);
 }
 
@@ -269,9 +269,9 @@ static struct dentry *ocfs2_fh_to_parent(struct super_block *sb,
 	if (fh_type != 2 || fh_len < 6)
 		return NULL;
 
-	parent.ih_blkno = (u64)le32_to_cpu(fid->raw[3]) << 32;
-	parent.ih_blkno |= (u64)le32_to_cpu(fid->raw[4]);
-	parent.ih_generation = le32_to_cpu(fid->raw[5]);
+	parent.ih_blkno = (u64)le32_to_cpu((__force __le32)fid->raw[3]) << 32;
+	parent.ih_blkno |= (u64)le32_to_cpu((__force __le32)fid->raw[4]);
+	parent.ih_generation = le32_to_cpu((__force __le32)fid->raw[5]);
 	return ocfs2_get_dentry(sb, &parent);
 }
 
diff --git a/fs/ocfs2/inode.c b/fs/ocfs2/inode.c
index 999111bfc271..2cc5c99fe941 100644
--- a/fs/ocfs2/inode.c
+++ b/fs/ocfs2/inode.c
@@ -1621,6 +1621,7 @@ static struct super_block *ocfs2_inode_cache_get_super(struct ocfs2_caching_info
 }
 
 static void ocfs2_inode_cache_lock(struct ocfs2_caching_info *ci)
+__acquires(&oi->ip_lock)
 {
 	struct ocfs2_inode_info *oi = cache_info_to_inode(ci);
 
@@ -1628,6 +1629,7 @@ static void ocfs2_inode_cache_lock(struct ocfs2_caching_info *ci)
 }
 
 static void ocfs2_inode_cache_unlock(struct ocfs2_caching_info *ci)
+__releases(&oi->ip_lock)
 {
 	struct ocfs2_inode_info *oi = cache_info_to_inode(ci);
 
diff --git a/fs/ocfs2/localalloc.c b/fs/ocfs2/localalloc.c
index b893ef56accd..86cdd60bcaab 100644
--- a/fs/ocfs2/localalloc.c
+++ b/fs/ocfs2/localalloc.c
@@ -336,7 +336,7 @@ int ocfs2_load_local_alloc(struct ocfs2_super *osb)
 		     "found = %u, set = %u, taken = %u, off = %u\n",
 		     num_used, le32_to_cpu(alloc->id1.bitmap1.i_used),
 		     le32_to_cpu(alloc->id1.bitmap1.i_total),
-		     OCFS2_LOCAL_ALLOC(alloc)->la_bm_off);
+		     le32_to_cpu(OCFS2_LOCAL_ALLOC(alloc)->la_bm_off));
 
 		status = -EINVAL;
 		goto bail;
@@ -1221,7 +1221,7 @@ static int ocfs2_local_alloc_new_window(struct ocfs2_super *osb,
 			     OCFS2_LOCAL_ALLOC(alloc)->la_bitmap);
 
 	trace_ocfs2_local_alloc_new_window_result(
-		OCFS2_LOCAL_ALLOC(alloc)->la_bm_off,
+		le32_to_cpu(OCFS2_LOCAL_ALLOC(alloc)->la_bm_off),
 		le32_to_cpu(alloc->id1.bitmap1.i_total));
 
 bail:
diff --git a/fs/ocfs2/refcounttree.c b/fs/ocfs2/refcounttree.c
index 3f80a56d0d60..1f303b1adf1a 100644
--- a/fs/ocfs2/refcounttree.c
+++ b/fs/ocfs2/refcounttree.c
@@ -630,7 +630,7 @@ static int ocfs2_create_refcount_tree(struct inode *inode,
 	rb->rf_records.rl_count =
 			cpu_to_le16(ocfs2_refcount_recs_per_rb(osb->sb));
 	spin_lock(&osb->osb_lock);
-	rb->rf_generation = osb->s_next_generation++;
+	rb->rf_generation = cpu_to_le32(osb->s_next_generation++);
 	spin_unlock(&osb->osb_lock);
 
 	ocfs2_journal_dirty(handle, new_bh);
-- 
2.35.3

