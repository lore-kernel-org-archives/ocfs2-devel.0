Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.215.181
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792501340;
	b=l7MggRq6IGLyQWHP5C8s0qzVzVIl9cB0Eon8Duk7T4AFhm4RF/+kvnkQZY88NCHvGf9a
	 mY2zwT0oRTPMbma/NVHWIi9RKUImLxE363Bpzj5YWcBA9wwQLkwDxDpd+NoFxRRL4hCvw
	 oCEf+rsPxYQn07t3kJjXM6zdlPAhuxaYnJsXTQFMYKcdSWxuz+WDJDBc/v2yUm3gtfoE4
	 b/G0tNWF3fc44L8AcV7IE2Hes45SJFEtVlzVELX9TS2YV1z2vhsPYKnjMBS8VUVZ0v/MT
	 EB2SNS4rxeAZn0ierhk2nVN6T5RJ4i/NTJEx3Vc2g0v5zJ+iWUjqbSxlWCkrGeFeFYg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792501340;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-Id:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=gjjyIg7yw0eyGLg8RRhVnBYmkPs2Yv+fCMF7oLmX6WU=;
	b=TaNe9GbefmNup3eYvXXOMA1pTpan3CnnT/kgQh7Ac1OnqniNd07FlybDZwnuCwzEzMNS
	 I3jZAtCex/X9lR4+5PCTf6nFdMc/NlVtenxmFa8iTZVnWtV5rBb92PytS1yyYOrELdfiv
	 Vj8p+jDt0s5cJpj5g6uwnmSslFOr/GZQ4PyZzq4fCV9p0p/h0L06dgMxFT7c2JD4q0su6
	 cIH8LrshDYvsR9gJXOfPuW/QQfl0lsrrLyJg/YZAVwd1cF/0xQR08KpwpY6R5+xvUg/Hv
	 ZYWLxxfVKPOdi0ZUfjhs4WtqGSGsGd9O+GQCoSd2euecDt0ebeqyoUwAcukLwZpmx1Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=KWHtBZFX;
	arc=none smtp.remote-ip=209.85.215.181
Received: from mail-pg1-f181.google.com (mail-pg1-f181.google.com [209.85.215.181])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 214EA606A31F
	for <ocfs2-devel@lists.linux.dev>; Tue, 20 Oct 2026 13:02:19 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 214EA606A31F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=KWHtBZFX
Received: by mail-pg1-f181.google.com with SMTP id 41be03b00d2f7-cc1bc88a20eso2060710a12.3
        for <ocfs2-devel@lists.linux.dev>; Tue, 20 Oct 2026 06:02:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792501338; x=1793106138; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=gjjyIg7yw0eyGLg8RRhVnBYmkPs2Yv+fCMF7oLmX6WU=;
        b=KWHtBZFXYYp85ygYsAx+SNWA1GUJ/7z20UhfeEl0XxbAM815PLLR7xZXOVebxPCtHJ
         NK8lSsp8ofMpEoftIkvNdHEc6nm6mK+FV1w4Sp/u+xZbl/6IAyVsGt8+RlXLqhYptAW5
         XJbFL89v6CAzzGwQDFzw4H6eWCH/c0qgi5krxX5rTGmwOuBwLFnXjF4xoIF9VF8LuT/l
         CwGkPblWHjAxyzO27f8jDT9PNPnVoc/2SRsVwJUaQUzmcGhAA8/a60rDIfHp8FIoCE2k
         1EvwmE4Ms82zkCRInc9mpKu/UJmCvTHxux/GYu+q25iGs8hSsF8K+Z60Nh88DA+RI6Zv
         Kn4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792501338; x=1793106138;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=gjjyIg7yw0eyGLg8RRhVnBYmkPs2Yv+fCMF7oLmX6WU=;
        b=dUcAW5eqOp1HZN7uB0ybgZ30kz8LUhhYxzJdJHMAXrSY3xzT9LhHD6Y/m1lVUbmFL2
         lUPQQS2Nc8Xdsisin6CreD95HXiNlDaeBfHosXSOrnJ0YTckUamC+uZHI6YPW8NkaUzQ
         YZUUyuHPEvDWetaIEYca42mEYMFdKctO38epcUqmFlyeWTdWvrWsfbTrU1ljn+ylhAYs
         bePpIhQZrakPn4aov3qNy5mhZieKuKpri+/38zWUdWMlRozcunvr4TE6X5PwONH5QoXA
         QQu6+vSs8KTjvNN2oZBX0P5LetqvJeMrYxcJE/GtdtFh294uaf6+HMBOitLQ8VPhz08I
         MpaQ==
X-Forwarded-Encrypted: i=1; AKwUvBzCpjPLxH30p2dwaSTZ3ZZKoUZY97IhcEdICLm5CGZj90qfER7VPDIML04PPr3KglUL7uFjhQfYlAYIcw==@lists.linux.dev
X-Gm-Message-State: AFq9FYIr+iMJvANCDjV9IyorFklstBrhNBnGWwrZ5ObtVFaueDfwsXej
	oc1J5dioj/k1QQfEzA/z0EMPClBGaENyibGpp7WDdfbPiXJC+ly19WjE
X-Gm-Gg: AYBFou0qvp4N554wnEURh/QLEICcX1GUBkew8SGmQuVFrT1UolfkZqniKPmUm3o4nT3
	rPHyWEKJIR1jbkpLZUhosLNV0H5u0rsunZeCqGKnoW6sFiaU3QSnaS+LO1Tc0aNBj5IvGdjkuSZ
	nLMfue9Mr/0BarKq0uucmOahx9RJbigJFV+z8S1PIESBjttNGkav+cgbl2u9gX0z2zJ8zV5x0DF
	6WeSIgll58Gv8pZOfYDa6zPmq0RRctC2zjh/YKedQSEdQozOuxmafJWta17wSrZnJdnUFt1Kooa
	XwxYabbG8noXjJjlDTBdig316pznytziKxFnpp7ByHCvntj1vVClWEkP8gACBk0zUR8MMMbcGha
	Q8xh+FJNZCf8fDS1HHoHzgizimVka1sak3DzOgDBZNDsxQwS+VXepufUXcQxHXuyKLbxBJKrnOS
	WJjfYZiV1JOedfPvac6AjSFr8eUeg2pXUXVAh09QZIXJDtAe0/g9YkdzzSr/SNhRGNkg==
X-Received: by 2002:a05:6a21:7a8e:b0:3e1:a769:9620 with SMTP id adf61e73a8af0-3e226424957mr7969858637.71.1792501337859;
        Tue, 20 Oct 2026 06:02:17 -0700 (PDT)
Received: from localhost ([111.228.63.84])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-89f58017c70sm4817600b3a.48.2026.10.20.06.02.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Oct 2026 06:02:17 -0700 (PDT)
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
Subject: [PATCH v3] ocfs2: protect dentry lock callbacks during inode teardown
Date: Tue, 20 Oct 2026 21:02:09 +0800
Message-Id: <pm-ocfs2-objects-candidate-0012-v8-d01e30cb3f465e294c0a@gmail.com>
X-Mailer: git-send-email 2.34.1
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

ocfs2_drop_dentry_lock() drops the inode reference before releasing
the DENTRY lock. This lets inode eviction release the local inode
and open locks before a remote unlink proceeds past the DENTRY lock.

A DLM callback can still arrive before the DENTRY lock has been
dropped. ocfs2_get_dentry_osb() obtains the mount context through
dl_inode->i_sb, which can access an inode already released by the
downconvert thread in its post-unlock callback:

  Downconvert thread                   DLM callback thread
  ------------------                   -------------------
  ocfs2_dentry_post_unlock()
    ocfs2_dentry_lock_put()
      ocfs2_drop_dentry_lock()
        iput(dl->dl_inode)
        [inode reclaimed after RCU]
                                       ocfs2_blocking_ast()
                                         ocfs2_get_dentry_osb()
                                           dl->dl_inode->i_sb
        ocfs2_simple_drop_lockres()

Store the mount context in the DENTRY lock resource's existing
l_priv field and use the default mount-context lookup. Recover the
containing dentry lock with container_of(), as for refcount locks.
The mount context remains valid until DLM shutdown completes.

The dentry convert worker also accesses dl_inode before checking
OCFS2_LOCK_FREEING and dl_count. Its early MAYBE_ORPHANED update
therefore precedes the reference that is meant to protect the inode.
ocfs2_unblock_lock() can invoke the worker without a FREEING test.

Move both the inode lookup and the flag update after the existing
guard has acquired an extra dentry lock reference. The check and
increment are serialized with final put by dentry_attach_lock, and
with FREEING by l_lock. A zero count also stops inode access in the
window before teardown sets FREEING. Once the extra reference is
held, final put cannot release dl_inode until the worker's existing
post-unlock path drops it.

Preserve iput-before-unlock ordering, normal orphan marking and the
existing extra-reference/post-unlock pairing.

Fixes: 8ed6b23709b3 ("ocfs2: revert iput deferring code in ocfs2_drop_dentry_lock")
Cc: stable@vger.kernel.org
Assisted-by: LLM
Suggested-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Signed-off-by: Cen Zhang <zzzccc427@gmail.com>

---
Changes in v3:
- Move the inode lookup and MAYBE_ORPHANED update after the existing
  FREEING/dl_count guard and successful extra-reference acquisition,
  addressing Joseph Qi's review.
- Keep the osb cache from v2 and preserve iput-before-unlock ordering.

Changes in v2:
- Preserve the existing iput-before-unlock order and cache the mount context
  in the lock resource's existing l_priv field instead.
- Recover the containing dentry lock with container_of() and remove the
  inode-dependent mount-context lookup.
- Correct the comment describing the dentry lock's inode reference.

Link to v1: https://lore.kernel.org/r/pm-ocfs2-objects-candidate-0012-v5-a0413a339b72c02fc885@gmail.com
Link to v2: https://lore.kernel.org/r/pm-ocfs2-objects-candidate-0012-v6-17b58652a3505eeecb0c@gmail.com

 fs/ocfs2/dcache.h  |  5 ++---
 fs/ocfs2/dlmglue.c | 38 ++++++++++++++++----------------------
 2 files changed, 18 insertions(+), 25 deletions(-)

diff --git a/fs/ocfs2/dcache.h b/fs/ocfs2/dcache.h
index 7f246c5692d8..046ab9a80769 100644
--- a/fs/ocfs2/dcache.h
+++ b/fs/ocfs2/dcache.h
@@ -17,9 +17,8 @@ struct ocfs2_dentry_lock {
 	u64			dl_parent_blkno;
 
 	/*
-	 * The ocfs2_dentry_lock keeps an inode reference until
-	 * dl_lockres has been destroyed. This is usually done in
-	 * ->d_iput() anyway, so there should be minimal impact.
+	 * The inode reference is dropped before dl_lockres is unlocked.
+	 * Callbacks must not use it to find the mount context during teardown.
 	 */
 	struct inode		*dl_inode;
 	struct ocfs2_lock_res	dl_lockres;
diff --git a/fs/ocfs2/dlmglue.c b/fs/ocfs2/dlmglue.c
index 88d946466083..b0b649b0d471 100644
--- a/fs/ocfs2/dlmglue.c
+++ b/fs/ocfs2/dlmglue.c
@@ -58,7 +58,6 @@ struct ocfs2_mask_waiter {
 #endif
 };
 
-static struct ocfs2_super *ocfs2_get_dentry_osb(struct ocfs2_lock_res *lockres);
 static struct ocfs2_super *ocfs2_get_inode_osb(struct ocfs2_lock_res *lockres);
 static struct ocfs2_super *ocfs2_get_file_osb(struct ocfs2_lock_res *lockres);
 static struct ocfs2_super *ocfs2_get_qinfo_osb(struct ocfs2_lock_res *lockres);
@@ -258,7 +257,6 @@ static const struct ocfs2_lock_res_ops ocfs2_orphan_scan_lops = {
 };
 
 static const struct ocfs2_lock_res_ops ocfs2_dentry_lops = {
-	.get_osb	= ocfs2_get_dentry_osb,
 	.post_unlock	= ocfs2_dentry_post_unlock,
 	.downconvert_worker = ocfs2_dentry_convert_worker,
 	.flags		= 0,
@@ -309,7 +307,7 @@ static inline struct ocfs2_dentry_lock *ocfs2_lock_res_dl(struct ocfs2_lock_res
 {
 	BUG_ON(lockres->l_type != OCFS2_LOCK_TYPE_DENTRY);
 
-	return (struct ocfs2_dentry_lock *)lockres->l_priv;
+	return container_of(lockres, struct ocfs2_dentry_lock, dl_lockres);
 }
 
 static inline struct ocfs2_mem_dqinfo *ocfs2_lock_res_qinfo(struct ocfs2_lock_res *lockres)
@@ -610,13 +608,6 @@ static __u64 ocfs2_get_dentry_lock_ino(struct ocfs2_lock_res *lockres)
 	return be64_to_cpu(inode_blkno_be);
 }
 
-static struct ocfs2_super *ocfs2_get_dentry_osb(struct ocfs2_lock_res *lockres)
-{
-	struct ocfs2_dentry_lock *dl = lockres->l_priv;
-
-	return OCFS2_SB(dl->dl_inode->i_sb);
-}
-
 void ocfs2_dentry_lock_res_init(struct ocfs2_dentry_lock *dl,
 				u64 parent, struct inode *inode)
 {
@@ -624,6 +615,7 @@ void ocfs2_dentry_lock_res_init(struct ocfs2_dentry_lock *dl,
 	u64 inode_blkno = OCFS2_I(inode)->ip_blkno;
 	__be64 inode_blkno_be = cpu_to_be64(inode_blkno);
 	struct ocfs2_lock_res *lockres = &dl->dl_lockres;
+	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
 
 	ocfs2_lock_res_init_once(lockres);
 
@@ -652,9 +644,9 @@ void ocfs2_dentry_lock_res_init(struct ocfs2_dentry_lock *dl,
 	memcpy(&lockres->l_name[OCFS2_DENTRY_LOCK_INO_START], &inode_blkno_be,
 	       sizeof(__be64));
 
-	ocfs2_lock_res_init_common(OCFS2_SB(inode->i_sb), lockres,
+	ocfs2_lock_res_init_common(osb, lockres,
 				   OCFS2_LOCK_TYPE_DENTRY, &ocfs2_dentry_lops,
-				   dl);
+				   osb);
 }
 
 static void ocfs2_super_lock_res_init(struct ocfs2_lock_res *res,
@@ -4099,7 +4091,7 @@ static int ocfs2_dentry_convert_worker(struct ocfs2_lock_res *lockres,
 				       int blocking)
 {
 	struct ocfs2_dentry_lock *dl = ocfs2_lock_res_dl(lockres);
-	struct ocfs2_inode_info *oi = OCFS2_I(dl->dl_inode);
+	struct ocfs2_inode_info *oi;
 	struct dentry *dentry;
 	unsigned long flags;
 	int extra_ref = 0;
@@ -4115,15 +4107,6 @@ static int ocfs2_dentry_convert_worker(struct ocfs2_lock_res *lockres,
 	if (blocking == DLM_LOCK_PR)
 		return UNBLOCK_CONTINUE;
 
-	/*
-	 * Mark this inode as potentially orphaned. The code in
-	 * ocfs2_delete_inode() will figure out whether it actually
-	 * needs to be freed or not.
-	 */
-	spin_lock(&oi->ip_lock);
-	oi->ip_flags |= OCFS2_INODE_MAYBE_ORPHANED;
-	spin_unlock(&oi->ip_lock);
-
 	/*
 	 * Yuck. We need to make sure however that the check of
 	 * OCFS2_LOCK_FREEING and the extra reference are atomic with
@@ -4150,6 +4133,17 @@ static int ocfs2_dentry_convert_worker(struct ocfs2_lock_res *lockres,
 	if (!extra_ref)
 		return UNBLOCK_CONTINUE;
 
+	/* The extra dentry lock reference keeps dl_inode alive. */
+	oi = OCFS2_I(dl->dl_inode);
+	/*
+	 * Mark this inode as potentially orphaned. The code in
+	 * ocfs2_delete_inode() will figure out whether it actually
+	 * needs to be freed or not.
+	 */
+	spin_lock(&oi->ip_lock);
+	oi->ip_flags |= OCFS2_INODE_MAYBE_ORPHANED;
+	spin_unlock(&oi->ip_lock);
+
 	spin_lock(&dentry_attach_lock);
 	while (1) {
 		dentry = ocfs2_find_local_alias(dl->dl_inode,
