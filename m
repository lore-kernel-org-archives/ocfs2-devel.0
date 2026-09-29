Received: from m16.mail.163.com (m16.mail.163.com [117.135.210.4])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A61952B1DB
	for <ocfs2-devel@lists.linux.dev>; Tue, 29 Sep 2026 13:29:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=117.135.210.4
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790688545; cv=none; b=twygPDMddjEDcbGnIRTP4gnFgZ10GQv9HjtRVNdRyAzLZKWrjIJle1/GEeI5xxZBEJ4FMYFSXjpOTRYc8qblzp0gzahyTK38kxNqdF4Tx2M/85f+us2zfM5T5B9IxfBIRFXi1kqinh0vZy3PdRrANzaYps5ZfgXY3DflPcH1Pzw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790688545; c=relaxed/simple;
	bh=b6dtydot1Y3sBNWDKv0mtPcqf7Msy3SOQlDk7dsZ8kQ=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=mbH2XgJEpOiKj+lAF51sBr9WebdA2l5Xx54fifwk7OKCs3M2r2YEuwFpTFPoTkw2ylUZRto8E6UxpuDEDfc2W+I7vftuK/jjZTrhdWx7T288h2GRvMADnXcwQsTq0/hWbp3YEBDfafvF1MDGY2ks03/N8K/m6eG4MWNoDWLVo5I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=KizNvOUt; arc=none smtp.client-ip=117.135.210.4
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="KizNvOUt"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-Id:MIME-Version; bh=24
	UNBIhr4var2GRTsyPMGr9P6r96ICM0WyKu+yZVWMg=; b=KizNvOUtR/wqP/vUZA
	aHtA6O6nSZsvslFVG+cWRxDrXa/QQ0jpgn2nzwyGq7+CffmOfZZYwTmmU9IQaGcQ
	jfNW8FhX8cpEnE9xPvcgI4nKzl/wlmFUxd39l0Tf8AgclsJAWvhV3aZB0z6K8rNR
	yFR0N6EoJ3DpdtYsfa7YlZ0ns=
Received: from pc.localdomain (unknown [])
	by gzsmtp3 (Coremail) with SMTP id PigvCgB3X630vLtq97U4CA--.7358S2;
	Tue, 29 Sep 2026 21:28:22 +0800 (CST)
From: Jiale Yao <yaojiale02@163.com>
To: Mark Fasheh <mark@fasheh.com>,
	Joel Becker <jlbec@evilplan.org>,
	Joseph Qi <joseph.qi@linux.alibaba.com>,
	ocfs2-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org
Cc: Jiale Yao <yaojiale02@163.com>
Subject: [PATCH v2] ocfs2: extend extent list validation in filecheck
Date: Tue, 29 Sep 2026 21:28:18 +0800
Message-Id: <20260929132818.259870-1-yaojiale02@163.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:PigvCgB3X630vLtq97U4CA--.7358S2
X-Coremail-Antispam: 1Uf129KBjvJXoW3GrWxZr4kZr4rJry5XFW7CFg_yoW7CFWxpF
	1S9rn0gr48Ja4xu3s3t34rXr1fKF47Aa9rG393A3sxtFnIyF90kF1qqa42gF4FqrZ5Jr1a
	9F4YgrsrC3WxAaDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x0piVbyAUUUUU=
X-CM-SenderInfo: x1dryxhdohiji6rwjhhfrp/xtbC8Bb1MGq7vPblTwAA3S

Online filecheck validates general dinode fields but does not check the
embedded extent list.  The normal inode read path requires l_count to be
nonzero.  It also limits l_count to the number of records that fit in the
inode and requires l_next_free_rec not to exceed l_count.

Teach filecheck validation to check the same conditions.  Share predicate
helpers with the normal inode validator.  Each path retains its own logging
and return-code handling.  The repair path rejects an invalid l_count while
continuing to clamp an invalid l_next_free_rec.

Signed-off-by: Jiale Yao <yaojiale02@163.com>
---

Notes:
    Changes in v2:
    - Treat the change as new filecheck functionality and drop the Fixes tag.
    - Extract shared predicates from ocfs2_validate_inode_block() instead of
      duplicating the extent-list checks.
    - Drop enum ocfs2_extent_list_status.

 fs/ocfs2/inode.c | 92 +++++++++++++++++++++++++++++++++++-------------
 1 file changed, 68 insertions(+), 24 deletions(-)

diff --git a/fs/ocfs2/inode.c b/fs/ocfs2/inode.c
index 180107a11046..6b038554e373 100644
--- a/fs/ocfs2/inode.c
+++ b/fs/ocfs2/inode.c
@@ -249,6 +249,36 @@ static int ocfs2_dinode_has_extents(struct ocfs2_dinode *di)
 	return 1;
 }
 
+static int
+ocfs2_dinode_has_invalid_extent_count(struct super_block *sb,
+				      struct ocfs2_dinode *di)
+{
+	struct ocfs2_extent_list *el = &di->id2.i_list;
+	u16 count;
+
+	if (!ocfs2_dinode_has_extents(di))
+		return 0;
+
+	count = le16_to_cpu(el->l_count);
+	/*
+	 * The exact capacity depends on i_xattr_inline_size, another
+	 * unvalidated on-disk field. Inline xattrs only shrink the
+	 * list, so the no-xattr maximum is a safe upper bound that a
+	 * valid l_count never exceeds.
+	 */
+	return !count || count > ocfs2_extent_recs_per_inode(sb);
+}
+
+static int ocfs2_dinode_has_invalid_extent_index(struct ocfs2_dinode *di)
+{
+	struct ocfs2_extent_list *el = &di->id2.i_list;
+
+	if (!ocfs2_dinode_has_extents(di))
+		return 0;
+
+	return le16_to_cpu(el->l_next_free_rec) > le16_to_cpu(el->l_count);
+}
+
 /*
  * here's how inodes get read from disk:
  * iget5_locked -> find_actor -> OCFS2_FIND_ACTOR
@@ -1716,36 +1746,28 @@ int ocfs2_validate_inode_block(struct super_block *sb,
 		goto bail;
 	}
 
-	if (ocfs2_dinode_has_extents(di)) {
-		struct ocfs2_extent_list *el = &di->id2.i_list;
-		u16 count = le16_to_cpu(el->l_count);
-		u16 next_free = le16_to_cpu(el->l_next_free_rec);
+	if (ocfs2_dinode_has_invalid_extent_count(sb, di)) {
+		u16 count = le16_to_cpu(di->id2.i_list.l_count);
 
-		if (count == 0) {
+		if (!count)
 			rc = ocfs2_error(sb,
 					 "Invalid dinode %llu: extent list l_count is zero\n",
 					 (unsigned long long)bh->b_blocknr);
-			goto bail;
-		}
-		/*
-		 * The exact capacity depends on i_xattr_inline_size, another
-		 * unvalidated on-disk field. Inline xattrs only shrink the
-		 * list, so the no-xattr maximum is a safe upper bound that a
-		 * valid l_count never exceeds.
-		 */
-		if (count > ocfs2_extent_recs_per_inode(sb)) {
+		else
 			rc = ocfs2_error(sb,
 					 "Invalid dinode %llu: extent list l_count %u exceeds max %u\n",
 					 (unsigned long long)bh->b_blocknr, count,
 					 ocfs2_extent_recs_per_inode(sb));
-			goto bail;
-		}
-		if (next_free > count) {
-			rc = ocfs2_error(sb,
-					 "Invalid dinode %llu: extent list l_next_free_rec %u exceeds l_count %u\n",
-					 (unsigned long long)bh->b_blocknr, next_free, count);
-			goto bail;
-		}
+		goto bail;
+	}
+
+	if (ocfs2_dinode_has_invalid_extent_index(di)) {
+		rc = ocfs2_error(sb,
+				 "Invalid dinode %llu: extent list l_next_free_rec %u exceeds l_count %u\n",
+				 (unsigned long long)bh->b_blocknr,
+				 le16_to_cpu(di->id2.i_list.l_next_free_rec),
+				 le16_to_cpu(di->id2.i_list.l_count));
+		goto bail;
 	}
 
 	rc = 0;
@@ -1835,6 +1857,26 @@ static int ocfs2_filecheck_validate_inode_block(struct super_block *sb,
 		goto bail;
 	}
 
+	if (ocfs2_dinode_has_invalid_extent_count(sb, di)) {
+		mlog(ML_ERROR,
+		     "Filecheck: invalid dinode #%llu: extent list l_count %u is invalid (max %u)\n",
+		     (unsigned long long)bh->b_blocknr,
+		     le16_to_cpu(di->id2.i_list.l_count),
+		     ocfs2_extent_recs_per_inode(sb));
+		rc = -OCFS2_FILECHECK_ERR_INVALIDINO;
+		goto bail;
+	}
+
+	if (ocfs2_dinode_has_invalid_extent_index(di)) {
+		mlog(ML_ERROR,
+		     "Filecheck: invalid dinode #%llu: extent list l_next_free_rec %u exceeds l_count %u\n",
+		     (unsigned long long)bh->b_blocknr,
+		     le16_to_cpu(di->id2.i_list.l_next_free_rec),
+		     le16_to_cpu(di->id2.i_list.l_count));
+		rc = -OCFS2_FILECHECK_ERR_INVALIDINO;
+		goto bail;
+	}
+
 	if (ocfs2_dinode_has_size_without_clusters(sb, di)) {
 		if (S_ISDIR(le16_to_cpu(di->i_mode)))
 			mlog(ML_ERROR,
@@ -1893,6 +1935,9 @@ static int ocfs2_filecheck_repair_inode_block(struct super_block *sb,
 		return -OCFS2_FILECHECK_ERR_VALIDFLAG;
 	}
 
+	if (ocfs2_dinode_has_invalid_extent_count(sb, di))
+		return -OCFS2_FILECHECK_ERR_INVALIDINO;
+
 	if (le64_to_cpu(di->i_blkno) != bh->b_blocknr) {
 		di->i_blkno = cpu_to_le64(bh->b_blocknr);
 		changed = 1;
@@ -1912,8 +1957,7 @@ static int ocfs2_filecheck_repair_inode_block(struct super_block *sb,
 		     le32_to_cpu(di->i_fs_generation));
 	}
 
-	if (ocfs2_dinode_has_extents(di) &&
-	    le16_to_cpu(di->id2.i_list.l_next_free_rec) > le16_to_cpu(di->id2.i_list.l_count)) {
+	if (ocfs2_dinode_has_invalid_extent_index(di)) {
 		di->id2.i_list.l_next_free_rec = di->id2.i_list.l_count;
 		changed = 1;
 		mlog(ML_ERROR,
-- 
2.34.1

