Received: from mail-pj1-f52.google.com (mail-pj1-f52.google.com [209.85.216.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32CFA472764
	for <ocfs2-devel@lists.linux.dev>; Thu,  2 Jul 2026 09:05:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782983121; cv=none; b=CjmPLgB7iYmxTmROaPBcweMY5ALZMnBnfWV2YXJBFwUXh/adf3HN/tDtcpHBiavSdMg8KYoAHLstuiY5XBnAqToWt4eQDha0oQaTPgdpZHl2Q1IGGxaZ0n9AVKk1VFZJnbxstyy8KaL2svFHShreUfzEZQ8i6FjTS2MmOazvDLg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782983121; c=relaxed/simple;
	bh=z9sSS6tsKQyOYNXwp2CjAyC141FIigl+nIIpfsWFryY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fQV/blKJow4CfMYAmWRmb60RvaLqSAYQfkg/MrOJ5Kgg+O5LdrksX7NA9Eoof8vCTFh6xLmEdEpjqdJ6GABc8PsLhUbcyhoRRv17A/chdesKRHOXvrro4GCAWNrQYRsUSDcDnyPPkzNI2Qf2KFzkaOlGs+92eD9EKUrQoKMRqLE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=QjLLQ8ki; arc=none smtp.client-ip=209.85.216.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="QjLLQ8ki"
Received: by mail-pj1-f52.google.com with SMTP id 98e67ed59e1d1-36b9d265355so1073640a91.2
        for <ocfs2-devel@lists.linux.dev>; Thu, 02 Jul 2026 02:05:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782983118; x=1783587918; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Q+C54p5Ymr/bpJsR5kkPFExyrn14Aop0wKq7d6xuByU=;
        b=QjLLQ8kiVSLIMNhvBXGiTgCQNtXrJIgYB5Tbjk4xdTZGoqBR4hr8y9GwLY5tSXt+68
         6NqZUzWdfGY/zhbfbEVxPsQyAHEtPhud34FKeHcSzCV6unp3uyck068vD2tGYNfqXU6d
         UesDkmiNRLEUIf2uVOM3DfvfkRKizhLv3fuqjDnwaKa9AgRDBVDwFadt9+EshNm4vC5B
         Ekx0JxsLXPYwKb1KwQ4wTCBA3vC5hgnmXENrnZum23r62lU+VViXqIDxCDgiEJVt+myE
         a6tSNFljy2oHgYZspGncmB/GivlgaR4oi1zqdNJ4kFuY/I2hJ35BS5bZpRgRb+YaVc4o
         jttQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782983118; x=1783587918;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=Q+C54p5Ymr/bpJsR5kkPFExyrn14Aop0wKq7d6xuByU=;
        b=Sz2zec6Kng1PmOunsSpz1XgmlbxPgnLUhCKrCwPL9tGObqIMKIVu210njp5NOfBnt/
         c/dAB/IylZx/2mue/8E2KeocFENS/M3pMpsWLymhTrA1qHZ49vZngsKel0p5qIX1ngUL
         KCa+A257Ll6RXMCurFmid5GR4koTf51tn6qJU2YSVznejKOZ1D9Wkfwoy1wM6biFCJR/
         mciEKl+VWSVvc1P72IfVzGozRqrruem2qOdclNKGkV7hgeBCScWat7iijYoe0P8MmdPR
         FlUXO8FBD0GrNqfpEEzhwE2q76r4RlvUJ6hoH4qQ4jw1SKJHh1WP8Z1GpUCZ/aozPQg9
         TjzA==
X-Forwarded-Encrypted: i=1; AHgh+RrsXMHM5iGtAw0e2jn3MG2Z6wYNPzqs0aT2p6u619Wih1kSacs6xFNnv8G+xO7VXZ6EMzxnm+4K/9m1IQ==@lists.linux.dev
X-Gm-Message-State: AOJu0YyDNaDrDMtnp0qVSaMZ/QhYnTigCmLsytKmX4SbQCLiAzqZ7+IY
	3GtYKYtEsdO0tlkBhBupauRR152oUSscJ02+uZkPfzmSr8AKwyMByFrA
X-Gm-Gg: AfdE7ckf91LmpVwN97Qtmz3EKJHmSdgXpcAOht4iqsZ44gObBwFFr6mXzVHons6woAx
	9f7Lj3Z6AhCBefIHrFUMizGCqC39hqeOi2Tof9yfvSNWkVjDxOGVnnlNIX3pv/Rv+0C9J6nCNip
	1J2fFEz2UVC+jSU1aPCiMirZAV13S1O+xOwO1iIVb5tbkyl6IC34r2PN6uc8C6arUr6dAX0rqpz
	RzpIvoJXZURWZKS52kJP/HKgya/UmS7E2mEgwK1pCNM6tT6AM39ILtnX3B75S0rtOVjHfA7ErQc
	dXGZmjh0oVd0HZ6AsnrZFo+zdOGGxhdEhF6hgFBraM2e5DXJT1LyF/YxcS7QXiMCI2eV/Ibqf/Y
	isKMbZ7ZIdoTqTk6vN9ENuJRt1XllGFunwqGeHSOw/1t7qDqRcfSA/MkcyNP7JsMnHJkzkKmYcI
	lpVQ5rB7Tsnpad9z1wbigc773b
X-Received: by 2002:a17:90b:3a47:b0:37e:2005:6507 with SMTP id 98e67ed59e1d1-380ba84865cmr4227283a91.15.1782983117993;
        Thu, 02 Jul 2026 02:05:17 -0700 (PDT)
Received: from ustb520lab-MS-7E07.. ([123.124.147.27])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-380d830884esm528583a91.2.2026.07.02.02.05.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Jul 2026 02:05:17 -0700 (PDT)
From: Jiaming Zhang <r772577952@gmail.com>
To: joseph.qi@linux.alibaba.com
Cc: jlbec@evilplan.org,
	linux-kernel@vger.kernel.org,
	mark@fasheh.com,
	ocfs2-devel@lists.linux.dev,
	r772577952@gmail.com,
	syzkaller@googlegroups.com
Subject: [PATCH v2] ocfs2: fix hung task in orphan recovery
Date: Thu,  2 Jul 2026 17:05:07 +0800
Message-ID: <20260702090507.446517-1-r772577952@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <fc9e15ad-5e53-4aab-88f0-61c73e6739c9@linux.alibaba.com>
References: <fc9e15ad-5e53-4aab-88f0-61c73e6739c9@linux.alibaba.com>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

A crafted OCFS2 image with corrupted orphan-directory extent metadata can make
umount hang.

During unmount, ocfs2_recovery_disable() waits for the ocfs2_complete_recovery
work item to finish. The worker scans the orphan directory through
ocfs2_queue_orphans() and ocfs2_dir_foreach(). If ocfs2_read_dir_block() fails
on a corrupted directory block, ocfs2_dir_foreach_blk_el() skips the block and
continues walking. On a badly corrupted directory this can keep orphan recovery
busy for a long time, leaving umount blocked while flushing osb->ocfs2_wq.

Return the read error immediately for full directory scans and propagate the
error from ocfs2_dir_foreach(). When ocfs2_empty_dir() receives such an error,
report the directory as non-empty so unlink/rmdir does not proceed on an
unreadable directory.

Closes: https://lore.kernel.org/lkml/CANypQFbWH76Y6LWHEwAvTP7aQL04uMJ=dDyL6YDmxa3fv3Tyjg@mail.gmail.com/
Assisted-by: Codex:gpt-5.5-xhigh
Signed-off-by: Jiaming Zhang <r772577952@gmail.com>
---
Changes in v2:
- Propagate the actual error from ocfs2_empty_dir() to caller.
- Update ocfs2_unlink() and ocfs2_rename() to distinguish errors from a
  non-empty directory result.

 fs/ocfs2/dir.c   | 20 ++++++++++++++------
 fs/ocfs2/namei.c | 11 ++++++++---
 2 files changed, 22 insertions(+), 9 deletions(-)

diff --git a/fs/ocfs2/dir.c b/fs/ocfs2/dir.c
index 8e6b03238327..baf3eca7b4e4 100644
--- a/fs/ocfs2/dir.c
+++ b/fs/ocfs2/dir.c
@@ -1866,6 +1866,7 @@ static int ocfs2_dir_foreach_blk_el(struct inode *inode,
 	struct super_block * sb = inode->i_sb;
 	unsigned int ra_sectors = 16;
 	int stored = 0;
+	int ret;
 
 	bh = NULL;
 
@@ -1873,9 +1874,13 @@ static int ocfs2_dir_foreach_blk_el(struct inode *inode,
 
 	while (ctx->pos < i_size_read(inode)) {
 		blk = ctx->pos >> sb->s_blocksize_bits;
-		if (ocfs2_read_dir_block(inode, blk, &bh, 0)) {
+		ret = ocfs2_read_dir_block(inode, blk, &bh, 0);
+		if (ret) {
+			if (persist)
+				return ret;
 			/* Skip the corrupt dirblock and keep trying */
 			ctx->pos += sb->s_blocksize - offset;
+			offset = 0;
 			continue;
 		}
 
@@ -1969,8 +1974,7 @@ static int ocfs2_dir_foreach_blk(struct inode *inode, u64 *f_version,
 int ocfs2_dir_foreach(struct inode *inode, struct dir_context *ctx)
 {
 	u64 version = inode_query_iversion(inode);
-	ocfs2_dir_foreach_blk(inode, &version, ctx, true);
-	return 0;
+	return ocfs2_dir_foreach_blk(inode, &version, ctx, true);
 }
 
 /*
@@ -2167,7 +2171,7 @@ static int ocfs2_empty_dir_dx(struct inode *inode,
 /*
  * routine to check that the specified directory is empty (for rmdir)
  *
- * Returns 1 if dir is empty, zero otherwise.
+ * Returns 1 if dir is empty, zero if not, and a negative errno on error.
  *
  * XXX: This is a performance problem for unindexed directories.
  */
@@ -2180,8 +2184,10 @@ int ocfs2_empty_dir(struct inode *inode)
 
 	if (ocfs2_dir_indexed(inode)) {
 		ret = ocfs2_empty_dir_dx(inode, &priv);
-		if (ret)
+		if (ret) {
 			mlog_errno(ret);
+			return ret;
+		}
 		/*
 		 * We still run ocfs2_dir_foreach to get the checks
 		 * for "." and "..".
@@ -2189,8 +2195,10 @@ int ocfs2_empty_dir(struct inode *inode)
 	}
 
 	ret = ocfs2_dir_foreach(inode, &priv.ctx);
-	if (ret)
+	if (ret) {
 		mlog_errno(ret);
+		return ret;
+	}
 
 	if (!priv.seen_dot || !priv.seen_dot_dot) {
 		mlog(ML_ERROR, "bad directory (dir #%llu) - no `.' or `..'\n",
diff --git a/fs/ocfs2/namei.c b/fs/ocfs2/namei.c
index 1277666c77cd..abce59e1f180 100644
--- a/fs/ocfs2/namei.c
+++ b/fs/ocfs2/namei.c
@@ -945,7 +945,10 @@ static int ocfs2_unlink(struct inode *dir,
 	child_locked = 1;
 
 	if (S_ISDIR(inode->i_mode)) {
-		if (inode->i_nlink != 2 || !ocfs2_empty_dir(inode)) {
+		status = ocfs2_empty_dir(inode);
+		if (status < 0)
+			goto leave;
+		if (inode->i_nlink != 2 || !status) {
 			status = -ENOTEMPTY;
 			goto leave;
 		}
@@ -1499,8 +1502,10 @@ static int ocfs2_rename(struct mnt_idmap *idmap,
 
 	if (target_exists) {
 		if (S_ISDIR(new_inode->i_mode)) {
-			if (new_inode->i_nlink != 2 ||
-			    !ocfs2_empty_dir(new_inode)) {
+			status = ocfs2_empty_dir(new_inode);
+			if (status < 0)
+				goto bail;
+			if (new_inode->i_nlink != 2 || !status) {
 				status = -ENOTEMPTY;
 				goto bail;
 			}
-- 
2.43.0

