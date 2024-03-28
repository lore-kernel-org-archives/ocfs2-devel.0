Received: from mail-lj1-f171.google.com (mail-lj1-f171.google.com [209.85.208.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDD587F7D5
	for <ocfs2-devel@lists.linux.dev>; Thu, 28 Mar 2024 12:52:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711630343; cv=none; b=mYtsaubJhPEHTUWp6Ac0eCUM2PiZX0qoWXkV2cCHJboQ9LbEhoWTwnrna2i/RpG5S17xQ2J4i1a35Z6TkJEks8CBlFEoZ+AsljRqj1ufaYmC2tuQ+2Ke24jqADtoJtQ8eyW2b23TwhqaD+nO+9IjZ6YJnm/B5rNzmQMiCLoBhp8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711630343; c=relaxed/simple;
	bh=4qAbtu7FC5oW6nCPkQEd2hw3p58+fVIsK3SHKEIsP+8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=OTQ4MsOw2e0JRtLkSM9vW3WiOIPr2vcoJdPoH1f02cECp+TnU+sPVLPGqDfHyUTLG5/WX4iZnO0Gx4qeD/CrUDFToKxq9epckFKLyDGGLv86Rbtb5u4wulM91yNJoHKFdJfhXWxJIzncOQePTS5Kle83FYcYNFH6mnDtbcvW298=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=ObpyLL3s; arc=none smtp.client-ip=209.85.208.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="ObpyLL3s"
Received: by mail-lj1-f171.google.com with SMTP id 38308e7fff4ca-2d476d7972aso14073511fa.1
        for <ocfs2-devel@lists.linux.dev>; Thu, 28 Mar 2024 05:52:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1711630338; x=1712235138; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=aeIVdSIQ3vPuE5f2AnPiX76qckzruvyY7WupSUKfbbA=;
        b=ObpyLL3s+R/fD8kmPut9+MGhud4c18VCxsBbZucvopNHpDNtGYbEDe+IKIaSVAu2cV
         osoqKFg19EAxNkFYgXqTP362B8Cl4Z4zx8H9unMJG1ErqXmaXEJoqoddrqGowtdEVztV
         z+GnisdeLwN/bcbeWgmq63H9ccVB8qgHPC2N+CtHhw1qGoDH85Ba8bQMZM2W+QY8sD8z
         c6Hk7GTHV6R0Fx/GQnuOg97ry8J6Wi65vpAhJvDSvPbDZOjwu7iUqVlG3vLlubiUVn0o
         J+E8XtCdytDQKMTOM/L8n8gCGT/xZNmlK0MiDiXrXpu1fcvU312oI7SNKl+LKQKU1MgH
         mqYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711630338; x=1712235138;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=aeIVdSIQ3vPuE5f2AnPiX76qckzruvyY7WupSUKfbbA=;
        b=eVeJya4aDC7E6ewEumoNZ3NSQIZcn6NN5cB3spWBedX25M5bIic3dBvvHHOrjFfrJH
         GEAwapy5hscsqWUtSr4HXjNXLWc4YDWshQgwEEXtgW7O+e9rrJYmb3KoPdrSkHxVS9qQ
         Iq/pNTsTp6FGgxtzgvZmRqtUDqwajRtxpQKmI93L/EnkRqzmPqvKMfBwfgYIjXBO0xft
         CR/2hUheXAxgEEBDuQ1m8qHtMQcAgRyinXrjwpZs/b/ro6vOm/kM+CizRagsq61TIppw
         69i6e9vxuBbXcZPLgDXKleYQZtYeUK8l2y4/CYRAfXuz70LFVckqyAuTTWl1lVuQ73u1
         u6tA==
X-Forwarded-Encrypted: i=1; AJvYcCUBPvbGzNXyGOfOUro1OIssGF9wMPdBc5E8hpFsafO2az2BD2nC07/WBJGLBV/415fxuV5VNYvm4HJ78eXqnjFIIdPIAzR5ceHMDKk=
X-Gm-Message-State: AOJu0Ywh0rqlEe/ieuqOYw+wSs1j2+nO7BN2r2gW8w/eCogYurvc8Fyr
	cdGqOVaNIPzhyVDShr9dJbcIqiFOIDwOoFhgk1h9j0Vu4KVxn6TVZ2q7C4ZSRiA=
X-Google-Smtp-Source: AGHT+IHh+IznnHHyPx3I358EjPHLe8xKNM1fMpaxbdC7SbMMfEK2A5YIcUklVcGJcOHti5GcZrIW+Q==
X-Received: by 2002:a2e:a721:0:b0:2d6:8ac7:455 with SMTP id s33-20020a2ea721000000b002d68ac70455mr1919686lje.40.1711630338181;
        Thu, 28 Mar 2024 05:52:18 -0700 (PDT)
Received: from c73.suse.cz ([202.127.77.110])
        by smtp.gmail.com with ESMTPSA id mo4-20020a1709030a8400b001dd8d298693sm1485010plb.23.2024.03.28.05.52.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Mar 2024 05:52:17 -0700 (PDT)
From: Heming Zhao <heming.zhao@suse.com>
To: joseph.qi@linux.alibaba.com
Cc: Heming Zhao <heming.zhao@suse.com>,
	ocfs2-devel@lists.linux.dev,
	ailiop@suse.com
Subject: [PATCH v6 4/4] ocfs2: fix sparse warnings
Date: Thu, 28 Mar 2024 20:52:03 +0800
Message-Id: <20240328125203.20892-5-heming.zhao@suse.com>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20240328125203.20892-1-heming.zhao@suse.com>
References: <20240328125203.20892-1-heming.zhao@suse.com>
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

Signed-off-by: Heming Zhao <heming.zhao@suse.com>
---
v6:
- restore the original code in dlm/dlmrecovery.c

v5: (first version)
- localalloc.c fix (No: 1) is split from v4 patch 3/3.
- new sparse warnings fixes (No: 2~6) for other files.

---
 fs/ocfs2/dlm/dlmdomain.c | 11 +++++------
 fs/ocfs2/export.c        | 12 ++++++------
 fs/ocfs2/inode.c         |  2 ++
 fs/ocfs2/localalloc.c    |  4 ++--
 fs/ocfs2/refcounttree.c  |  2 +-
 5 files changed, 16 insertions(+), 15 deletions(-)

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

