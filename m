Received: from mail-pg1-f178.google.com (mail-pg1-f178.google.com [209.85.215.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34D151A9F85
	for <ocfs2-devel@lists.linux.dev>; Thu,  6 Aug 2026 03:59:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785988800; cv=none; b=SCXB+UJhWhvFv8k92XxFfzoJXuLkT/hRpWnSu+r9yplVTsKHXmwflmTyxl+SdPjfBcBugiDY9s8i0KEQ2Y3KdvpVk++Mmo2wqjo080NlbVYkjhrTSZsVB4YDJATh299ZB2IRzEB+2zkGvIHSFZ1r1SNc25080Jq+D1iCMHbyv0c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785988800; c=relaxed/simple;
	bh=f6VOjzmU/FxU0pVahdirIg5iehCeWXaXEEVHrptSSqY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=lbGwQfK5NrrVX+geaL4Wgc3fAg9LDzbCKIzxv6KihmqvXKZBRXla/sLvdhuSMClp34r4AVy9AAIqRzN8TWAfpuTs/iWNQvycKWIjqieOUNpECwW0TSDStrendCeWDMUvSwy3wOVt6I0YsketIFM3x4XDbRkjafe7vRZwdKjbDME=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Xep+nNW4; arc=none smtp.client-ip=209.85.215.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Xep+nNW4"
Received: by mail-pg1-f178.google.com with SMTP id 41be03b00d2f7-ca97d139d5fso1418225a12.0
        for <ocfs2-devel@lists.linux.dev>; Wed, 05 Aug 2026 20:59:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785988798; x=1786593598; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=hS/qPjj+0KSIiFYCj9hbSyZbsQtcF1h6Wy0FklLZWy8=;
        b=Xep+nNW4ZXrBO2LvzBujZvJPrI2W0h7eZquJzFVUb6PvjNcCK1kNf7KKvWgNKDducw
         orBw5/MKu6c74Q/dJp/MktezQz/SI7VOBuAPfA1oRfr9FSu2KSIfmHtBsjfCNf2mdsk4
         InzRicScYGeihzFjZgOppKrbaS11Lj1bH2SuHtLPHHY+EzL7EetqRFTO0gF1y9YWSoDa
         Ux1607VkebdEMXNNS502HJFqYGoxVLbyxtw4M8AIzt078V0YOhjH6nmzveT1Oj8T2Ctv
         aI5GiAc9QMNVxl+ZLdIgQ9Rt7v57oXgf8ZJ5gBR/dTo9XuByLLn8OjpJJv9kAYsEYG7Y
         FfYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785988798; x=1786593598;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=hS/qPjj+0KSIiFYCj9hbSyZbsQtcF1h6Wy0FklLZWy8=;
        b=BTMJrbVzxvdTeIYvcskh+2zYD8dV5dYiISoFlAbMQxgOdpFYbu5HISmk+fzfLXxdC5
         aHHVXzlLqEJJgnvo/fYTKWNhkEZfLZ92GqidYXlnJnmWw1SAxXJ9Nu0DpQr7CRNarQ8+
         WMGP2pZtOibqlu3W5smcWhBoeu4jkt5vz1DslghiZEWykL3xuBeuLM8Si1KvyLgVT7AJ
         /f9mYuPUNB+biofcZB0PL8CuQQaawvqtdYlGlNIS1Hrf8PEJH6i8jZ43VFVCPKkLFtPI
         xT7zXeC1nfbfEVnL0s/jdGI7mwyrd39FmLsTbh+1rfLs6U0n7iJ9WhV7bgVUNlRjHoQ7
         d/nA==
X-Gm-Message-State: AOJu0YxIv5OBANRqHgRWeuz8SqwT3qbnqkdNrGlL/u+fbOxjo+bcSMB8
	XhFQuougPbU7e5PEIUfYPbM6cA39KmubWI2pZTr7DcFDs4whf7u2D/Ru
X-Gm-Gg: AR+sD113AvM+vrzhKIiOikOawmB0QN9+Oz9f+dlI2T+fxqo6DK3e8wfW9HMomYX3aHq
	3jvh1IyiCRsg/sBYqEPMSJjUtIa+yBxsUVYbIwVEx+C3lrS8E1msGT0FYggM9HqiYA59duVZAOy
	4CVpSGqMpbK63eG/kQEbhPnT/lFxabLymRmFNu7LAfExcn9pPT9ojoWaUo/Il+aE09GudV0eATc
	643RFcYwQqQNySCyRryLqJd5GULH9NVk8O374KYaK9lja8nYj0HypvbTTp7zXoKzuz/3ICW+b+8
	kK4D9vLL+toIt+sWZJOy2AeH2JeHG1cvT1CxBvuF+EeplCf/nOTL0kkfhOYZzImPkwwt95eS9dj
	ltPBAmS9SZRH6bIaTBxYRaw8eGsEGpkgrKpBgKRplaXNAYBeFsEijOsOSGClnp4CCyOiTi7ekR1
	9dq/535mHF/GoXOv/bV7RdLrsYMc9gnm8LmihblYvmVUArcTwRKqUvQlqeYmm4SliyTOMEnTp1N
	UIWBqbt8sWTOLYkGhHkRuaPK/Y13A==
X-Received: by 2002:a05:6a00:2e18:b0:848:2c6c:dfe3 with SMTP id d2e1a72fcca58-84f2dffd75emr12304981b3a.17.1785988798184;
        Wed, 05 Aug 2026 20:59:58 -0700 (PDT)
Received: from gmail.com ([138.199.21.246])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-84f459ba36csm420171b3a.49.2026.08.05.20.59.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Aug 2026 20:59:57 -0700 (PDT)
From: ZhengYuan Huang <gality369@gmail.com>
To: mark@fasheh.com,
	jlbec@evilplan.org,
	joseph.qi@linux.alibaba.com
Cc: ocfs2-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	baijiaju1990@gmail.com,
	r33s3n6@gmail.com,
	zzzccc427@gmail.com,
	ZhengYuan Huang <gality369@gmail.com>
Subject: [PATCH v2] ocfs2: fix deadlock in inline-data truncate transactions
Date: Thu,  6 Aug 2026 11:59:47 +0800
Message-ID: <20260806035947.2451857-1-gality369@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

[BUG]
Updating an inode xattr can cause an ABBA deadlock with 
inline file truncation.

  ocfs2_truncate_file()
    down_write(&oi->ip_alloc_sem)
    ocfs2_truncate_inline()
      ocfs2_start_trans()

  ocfs2_xattr_set()
    ocfs2_start_trans()
    ocfs2_xattr_ibody_set()
      down_write(&oi->ip_alloc_sem)

[CAUSE]
The xattr set path starts its merged transaction before the helpers which
modify inode-body xattrs acquire ip_alloc_sem. This creates the reverse of
the ip_alloc_sem -> transaction order used by the allocation and truncate
paths. The transaction merge in 
commit 85db90e77806 ("ocfs2/xattr: Merge xattr set transaction.")
introduced this ordering for ordinary xattr updates.

The create-time transaction -> ip_xattr_sem dependency is a separate case.
The fix in 
commit c13024342c82 ("ocfs2: fix circular locking dependency in ocfs2_init_acl()")
prepares the parent ACL before the create transaction and avoids the xattr
semaphore for initial xattrs on an unpublished inode. That change does not
cover ordinary ocfs2_xattr_set().

[FIX]
Acquire ip_alloc_sem in ocfs2_xattr_set() before xattr preparation,
allocation reservations, and transaction start.  Tell the inode-body and
indexed-block helpers when the semaphore is already held, while preserving
their local locking for callers that do not provide outer protection.

Keep the existing ip_alloc_sem -> transaction order in allocation and
truncate paths; fixing the xattr side avoids changing that established
ordering.

Fixes: 85db90e77806 ("ocfs2/xattr: Merge xattr set transaction.")
Signed-off-by: ZhengYuan Huang <gality369@gmail.com>
---
v2:
- Fix the xattr side of the lock ordering based on Joseph's feedback.
- Explain why the remaining fix belongs on the ordinary xattr side.
---
 fs/ocfs2/xattr.c | 49 ++++++++++++++++++++++++++++++++----------------
 1 file changed, 33 insertions(+), 16 deletions(-)

diff --git a/fs/ocfs2/xattr.c b/fs/ocfs2/xattr.c
index 35bcbb0ff607..27bea1f360a1 100644
--- a/fs/ocfs2/xattr.c
+++ b/fs/ocfs2/xattr.c
@@ -74,6 +74,7 @@ struct ocfs2_xattr_set_ctxt {
 	struct ocfs2_alloc_context *data_ac;
 	struct ocfs2_cached_dealloc_ctxt dealloc;
 	int set_abort;
+	int alloc_sem_protected;
 };
 
 #define OCFS2_XATTR_ROOT_SIZE	(sizeof(struct ocfs2_xattr_def_value_root))
@@ -2916,7 +2917,8 @@ static int ocfs2_xattr_has_space_inline(struct inode *inode,
 static int ocfs2_xattr_ibody_find(struct inode *inode,
 				  int name_index,
 				  const char *name,
-				  struct ocfs2_xattr_search *xs)
+				  struct ocfs2_xattr_search *xs,
+				  int lock_alloc_sem)
 {
 	struct ocfs2_inode_info *oi = OCFS2_I(inode);
 	struct ocfs2_dinode *di = (struct ocfs2_dinode *)xs->inode_bh->b_data;
@@ -2927,9 +2929,11 @@ static int ocfs2_xattr_ibody_find(struct inode *inode,
 		return 0;
 
 	if (!(oi->ip_dyn_features & OCFS2_INLINE_XATTR_FL)) {
-		down_read(&oi->ip_alloc_sem);
+		if (lock_alloc_sem)
+			down_read(&oi->ip_alloc_sem);
 		has_space = ocfs2_xattr_has_space_inline(inode, di);
-		up_read(&oi->ip_alloc_sem);
+		if (lock_alloc_sem)
+			up_read(&oi->ip_alloc_sem);
 		if (!has_space)
 			return 0;
 	}
@@ -3016,14 +3020,17 @@ static int ocfs2_xattr_ibody_set(struct inode *inode,
 				 struct ocfs2_xattr_search *xs,
 				 struct ocfs2_xattr_set_ctxt *ctxt)
 {
-	int ret;
+	int ret, took_alloc_sem = 0;
 	struct ocfs2_inode_info *oi = OCFS2_I(inode);
 	struct ocfs2_xa_loc loc;
 
 	if (inode->i_sb->s_blocksize == OCFS2_MIN_BLOCKSIZE)
 		return -ENOSPC;
 
-	down_write(&oi->ip_alloc_sem);
+	if (!ctxt->alloc_sem_protected) {
+		down_write(&oi->ip_alloc_sem);
+		took_alloc_sem = 1;
+	}
 	if (!(oi->ip_dyn_features & OCFS2_INLINE_XATTR_FL)) {
 		ret = ocfs2_xattr_ibody_init(inode, xs->inode_bh, ctxt);
 		if (ret) {
@@ -3044,7 +3051,8 @@ static int ocfs2_xattr_ibody_set(struct inode *inode,
 	xs->here = loc.xl_entry;
 
 out:
-	up_write(&oi->ip_alloc_sem);
+	if (took_alloc_sem)
+		up_write(&oi->ip_alloc_sem);
 
 	return ret;
 }
@@ -3729,6 +3737,7 @@ int ocfs2_xattr_set_handle(handle_t *handle,
 		.handle = handle,
 		.meta_ac = meta_ac,
 		.data_ac = data_ac,
+		.alloc_sem_protected = 1,
 	};
 
 	if (!ocfs2_supports_xattr(OCFS2_SB(inode->i_sb)))
@@ -3750,7 +3759,7 @@ int ocfs2_xattr_set_handle(handle_t *handle,
 	xis.inode_bh = xbs.inode_bh = di_bh;
 	di = (struct ocfs2_dinode *)di_bh->b_data;
 
-	ret = ocfs2_xattr_ibody_find(inode, name_index, name, &xis);
+	ret = ocfs2_xattr_ibody_find(inode, name_index, name, &xis, 0);
 	if (ret)
 		goto cleanup;
 	if (xis.not_found) {
@@ -3834,7 +3843,7 @@ int ocfs2_xattr_set(struct inode *inode,
 	 * Scan inode and external block to find the same name
 	 * extended attribute and collect search information.
 	 */
-	ret = ocfs2_xattr_ibody_find(inode, name_index, name, &xis);
+	ret = ocfs2_xattr_ibody_find(inode, name_index, name, &xis, 1);
 	if (ret)
 		goto cleanup;
 	if (xis.not_found) {
@@ -3856,6 +3865,8 @@ int ocfs2_xattr_set(struct inode *inode,
 			goto cleanup;
 	}
 
+	down_write(&OCFS2_I(inode)->ip_alloc_sem);
+
 	/* Check whether the value is refcounted and do some preparation. */
 	if (ocfs2_is_refcount_inode(inode) &&
 	    (!xis.not_found || !xbs.not_found)) {
@@ -3864,7 +3875,7 @@ int ocfs2_xattr_set(struct inode *inode,
 						   &ref_meta, &ref_credits);
 		if (ret) {
 			mlog_errno(ret);
-			goto cleanup;
+			goto out_unlock_alloc;
 		}
 	}
 
@@ -3875,7 +3886,7 @@ int ocfs2_xattr_set(struct inode *inode,
 		if (ret < 0) {
 			inode_unlock(tl_inode);
 			mlog_errno(ret);
-			goto cleanup;
+			goto out_unlock_alloc;
 		}
 	}
 	inode_unlock(tl_inode);
@@ -3884,8 +3895,9 @@ int ocfs2_xattr_set(struct inode *inode,
 					&xbs, &ctxt, ref_meta, &credits);
 	if (ret) {
 		mlog_errno(ret);
-		goto cleanup;
+		goto out_unlock_alloc;
 	}
+	ctxt.alloc_sem_protected = 1;
 
 	/* we need to update inode's ctime field, so add credit for it. */
 	credits += OCFS2_INODE_UPDATE_CREDITS;
@@ -3893,15 +3905,15 @@ int ocfs2_xattr_set(struct inode *inode,
 	if (IS_ERR(ctxt.handle)) {
 		ret = PTR_ERR(ctxt.handle);
 		mlog_errno(ret);
-		goto out_free_ac;
+		goto out_unlock_alloc;
 	}
 
 	ret = __ocfs2_xattr_set_handle(inode, di, &xi, &xis, &xbs, &ctxt);
 	ocfs2_update_inode_fsync_trans(ctxt.handle, inode, 0);
 
 	ocfs2_commit_trans(osb, ctxt.handle);
-
-out_free_ac:
+out_unlock_alloc:
+	up_write(&OCFS2_I(inode)->ip_alloc_sem);
 	if (ctxt.data_ac)
 		ocfs2_free_alloc_context(ctxt.data_ac);
 	if (ctxt.meta_ac)
@@ -4520,6 +4532,7 @@ static int ocfs2_xattr_create_index_block(struct inode *inode,
 	u64 blkno;
 	handle_t *handle = ctxt->handle;
 	struct ocfs2_inode_info *oi = OCFS2_I(inode);
+	int took_alloc_sem = 0;
 	struct buffer_head *xb_bh = xs->xattr_bh;
 	struct ocfs2_xattr_block *xb =
 			(struct ocfs2_xattr_block *)xb_bh->b_data;
@@ -4537,7 +4550,10 @@ static int ocfs2_xattr_create_index_block(struct inode *inode,
 	 * We can use this lock for now, and maybe move to a dedicated mutex
 	 * if performance becomes a problem later.
 	 */
-	down_write(&oi->ip_alloc_sem);
+	if (!ctxt->alloc_sem_protected) {
+		down_write(&oi->ip_alloc_sem);
+		took_alloc_sem = 1;
+	}
 
 	ret = ocfs2_journal_access_xb(handle, INODE_CACHE(inode), xb_bh,
 				      OCFS2_JOURNAL_ACCESS_WRITE);
@@ -4600,7 +4616,8 @@ static int ocfs2_xattr_create_index_block(struct inode *inode,
 	ocfs2_journal_dirty(handle, xb_bh);
 
 out:
-	up_write(&oi->ip_alloc_sem);
+	if (took_alloc_sem)
+		up_write(&oi->ip_alloc_sem);
 
 	return ret;
 }
