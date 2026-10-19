Received: from mail-pj1-f44.google.com (mail-pj1-f44.google.com [209.85.216.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 760174F6490
	for <ocfs2-devel@lists.linux.dev>; Mon, 19 Oct 2026 13:50:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792417806; cv=none; b=gqgOo+jBRdH4jOl6RBrfWLA8/OcBEcWrDqH+B4h9rtY+W8wfSc0eXsHNFjoaPUhfVeWkEv9npBYAm3cbE8kcD57+90FMZKU5RJVXzOUWamJz2BsZdqBvDd4wZBX/Njry1ZKAkI04ry5rtPwpx9kadF6kXBQo090D/GS8Q/CGHhM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792417806; c=relaxed/simple;
	bh=mrAS8F2+28qGCNLp50PxVrDYefFqK+LB1R+oI6CY7E4=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=uY5OGxiBTlXpc48Lx00/ac7DQPNiHXQ+utMjIL4Qcx0NTLFZnz8lirpthxhEIuVMug+KX9dhlLYM43pPnW1u988eciTqfyB2e22o9GPQPNEidRZPDNU0D39FSeIxv41qFcP2kLuIoACnoXHTg8Am04fx9dS+5G8yIEQ7adDahnw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=VqhtyMWB; arc=none smtp.client-ip=209.85.216.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="VqhtyMWB"
Received: by mail-pj1-f44.google.com with SMTP id 98e67ed59e1d1-398b3c37877so1214233a91.0
        for <ocfs2-devel@lists.linux.dev>; Mon, 19 Oct 2026 06:50:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792417804; x=1793022604; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=bDmQIm+N7Da6j83Yqrg/UI5yb0CX5Q6JMZKoKt0rve4=;
        b=VqhtyMWBK4yDPJwppU8WOMO/Hs1M8KBFTxfGakw0FbYVqPU6/AvgfHH76RWD2UGYYz
         PfUQ51Ul4x2izC3EcK9iF53RB/qeF5v/MvcyxXNJ+LGMaHrM9ZYbRWfa+jRulq1XQjLz
         4VP/ODOdmxe/gTJDayQnE0CuIRTmrDefl36t7ITPDY8rN+2jQnmDilaAHB/OcN7wTEuB
         MV2qMWlxXnJG8XDYo0vFu6jS0WD0nutPcvz3V5tPlRWVSJOOJQfbcL9hcyvd7jGCKHPb
         qOJe2iGL6pLLhwN9ZG8DsctFywGeEum3IjSG9FODYzyaapq6D2/PiFkb+HxFJf6fDRfY
         YUEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792417804; x=1793022604;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=bDmQIm+N7Da6j83Yqrg/UI5yb0CX5Q6JMZKoKt0rve4=;
        b=e8/eZcxVaarQ+5ix63hHmlCMUdeCpNFK3WZED0lDVG8pWDQlKFx8msX6XDm8TdqpT3
         Sd9gkLxv0HRliwH13hbtRhtCisDv9LBeavqzOuJkHyxYsxh3gnLXov8oMzHSCbmufsAP
         rbQNVBTQBfcWXPYn8dT1PGAuFv5NTYbvtLPIxqqUlhQRVCHxEier2P5sGGuHVYV4AfWU
         6ge9nbKc9R739FlOgSMU8Vz54AJnPfBrF3fuWTBvRhwEqf/9bkyOXuaoqgCz1D61pltW
         Ih0ss63WN2ydPeo8EqgWSihpa+e+gF7pLDzOh7BkL1Q0HrhMpEJ9z7dawRSSrNg55h2b
         qF+A==
X-Forwarded-Encrypted: i=1; AKwUvBydSyDDs23UZ5l4zMghvUs6UDYaAs7JglQ4S9fyBCVxlYoYB04WVgRR71+c+HXfTPdrSq04Ram1P5B6qA==@lists.linux.dev
X-Gm-Message-State: AFq9FYKacTYA8s1nY7Pnl2skdfvVUaEF7l6oyvNK1kTrsdc1TtZlbuB4
	KEUn2Er0ze+PspqBuKSkmOyvahUr80pMPzPPhAGyC4mnCWLuXzUULN8q
X-Gm-Gg: AYBFou0YjzHCVAXtDd5x0/T7oPpRCzzsqpV5Q/CVNYyzCQY45lX4xX6GkoSJsmHFHQP
	cul+TGNT4oCI4eCOeYWKEnZ/EJy1mBt2q7942i/TkbA5GS5Jce/7H28eqSnJKNSd+iNqsnXC6Zw
	hxN60CMwjuS8Eqiw2Vc/uQw+piKrpKEMzKokOvy3TVafBhXFjcZOaK6WqJGJkfYJjzL82yxZUyt
	cMif3b5BWh1WELWgraTARHhhHsS5lA7zmD1AiP/EcVRGFI5ksdUY/XVhEWY5Q2EwnhxcBJN2WQ0
	TazvgD13DehDdUblnk0bWgULvfMJ1BNNZfIh4/hHHLXFZJA4MKse6ho1X0WJPKYNr1YiJ0j2h0u
	O8QI80FFY6BbcwkRZFgOMP7w5cl2nb/qAeiqGjC83UWqie+BWU9wpNAeBSDgeSLdq0lhJ+jpEkq
	BJzhzJPIwsR/dCeJUTFRSTickzZBlaoiyjfjNlCZ98WNf4nVhPC2zFeDRSF4MmrSNvVg==
X-Received: by 2002:a17:90b:3892:b0:3a7:250:333e with SMTP id 98e67ed59e1d1-3aceefc176fmr7701283a91.11.1792417803488;
        Mon, 19 Oct 2026 06:50:03 -0700 (PDT)
Received: from localhost ([111.228.63.84])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3ad42878d72sm2792278a91.5.2026.10.19.06.50.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Oct 2026 06:50:03 -0700 (PDT)
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
Subject: [PATCH v2] ocfs2: Cache the mount context for dentry lock callbacks
Date: Mon, 19 Oct 2026 21:49:56 +0800
Message-Id: <pm-ocfs2-objects-candidate-0012-v6-17b58652a3505eeecb0c@gmail.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

ocfs2_drop_dentry_lock() drops the inode reference before releasing the
DENTRY lock. This lets inode eviction release the local inode and open
locks before a remote unlink can proceed past the DENTRY lock.

A DLM callback can still arrive before the DENTRY lock has been dropped.
ocfs2_get_dentry_osb() obtains the mount context through dl_inode->i_sb,
which can access a freed inode when the downconvert thread drops the
last inode reference in its post-unlock callback:

  Downconvert thread                     DLM callback thread
  ------------------                     -------------------
  ocfs2_process_blocked_lock()
    ocfs2_dentry_post_unlock()
      ocfs2_dentry_lock_put()
        ocfs2_drop_dentry_lock()
          iput(dl->dl_inode)
          [inode reclaimed after RCU]
                                         ocfs2_blocking_ast()
                                           ocfs2_get_dentry_osb()
                                             dl->dl_inode->i_sb
          ocfs2_simple_drop_lockres()

Store the mount context in the DENTRY lock resource's l_priv field and
use the default mount-context lookup. Recover the containing dentry
lock with container_of(), as already done for refcount locks, and remove
ocfs2_get_dentry_osb(). ocfs2_dismount_volume() shuts down the DLM before
freeing the mount context, so callbacks can use it without accessing the
inode. Preserve the existing iput-before-unlock order to avoid delaying
local inode and open lock release until after the DENTRY lock is released.

Fixes: 8ed6b23709b3 ("ocfs2: revert iput deferring code in ocfs2_drop_dentry_lock")
Cc: stable@vger.kernel.org
Assisted-by: LLM
Signed-off-by: Cen Zhang <zzzccc427@gmail.com>
---
Changes in v2:
- Preserve the existing iput-before-unlock order and cache the mount context
  in the lock resource's existing l_priv field instead.
- Recover the containing dentry lock with container_of() and remove the
  inode-dependent mount-context lookup.
- Correct the comment describing the dentry lock's inode reference.

Link to v1: https://lore.kernel.org/r/pm-ocfs2-objects-candidate-0012-v5-a0413a339b72c02fc885@gmail.com

 fs/ocfs2/dcache.h  |  5 ++---
 fs/ocfs2/dlmglue.c | 16 ++++------------
 2 files changed, 6 insertions(+), 15 deletions(-)

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
index 6bc4a21cf5f0..d12635c4db95 100644
--- a/fs/ocfs2/dlmglue.c
+++ b/fs/ocfs2/dlmglue.c
@@ -57,7 +57,6 @@ struct ocfs2_mask_waiter {
 #endif
 };
 
-static struct ocfs2_super *ocfs2_get_dentry_osb(struct ocfs2_lock_res *lockres);
 static struct ocfs2_super *ocfs2_get_inode_osb(struct ocfs2_lock_res *lockres);
 static struct ocfs2_super *ocfs2_get_file_osb(struct ocfs2_lock_res *lockres);
 static struct ocfs2_super *ocfs2_get_qinfo_osb(struct ocfs2_lock_res *lockres);
@@ -257,7 +256,6 @@ static const struct ocfs2_lock_res_ops ocfs2_orphan_scan_lops = {
 };
 
 static const struct ocfs2_lock_res_ops ocfs2_dentry_lops = {
-	.get_osb	= ocfs2_get_dentry_osb,
 	.post_unlock	= ocfs2_dentry_post_unlock,
 	.downconvert_worker = ocfs2_dentry_convert_worker,
 	.flags		= 0,
@@ -308,7 +306,7 @@ static inline struct ocfs2_dentry_lock *ocfs2_lock_res_dl(struct ocfs2_lock_res
 {
 	BUG_ON(lockres->l_type != OCFS2_LOCK_TYPE_DENTRY);
 
-	return (struct ocfs2_dentry_lock *)lockres->l_priv;
+	return container_of(lockres, struct ocfs2_dentry_lock, dl_lockres);
 }
 
 static inline struct ocfs2_mem_dqinfo *ocfs2_lock_res_qinfo(struct ocfs2_lock_res *lockres)
@@ -609,13 +607,6 @@ static __u64 ocfs2_get_dentry_lock_ino(struct ocfs2_lock_res *lockres)
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
@@ -623,6 +614,7 @@ void ocfs2_dentry_lock_res_init(struct ocfs2_dentry_lock *dl,
 	u64 inode_blkno = OCFS2_I(inode)->ip_blkno;
 	__be64 inode_blkno_be = cpu_to_be64(inode_blkno);
 	struct ocfs2_lock_res *lockres = &dl->dl_lockres;
+	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
 
 	ocfs2_lock_res_init_once(lockres);
 
@@ -651,9 +643,9 @@ void ocfs2_dentry_lock_res_init(struct ocfs2_dentry_lock *dl,
 	memcpy(&lockres->l_name[OCFS2_DENTRY_LOCK_INO_START], &inode_blkno_be,
 	       sizeof(__be64));
 
-	ocfs2_lock_res_init_common(OCFS2_SB(inode->i_sb), lockres,
+	ocfs2_lock_res_init_common(osb, lockres,
 				   OCFS2_LOCK_TYPE_DENTRY, &ocfs2_dentry_lops,
-				   dl);
+				   osb);
 }
 
 static void ocfs2_super_lock_res_init(struct ocfs2_lock_res *res,
-- 
2.43.0
