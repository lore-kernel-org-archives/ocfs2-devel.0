Received: from out30-124.freemail.mail.aliyun.com (out30-124.freemail.mail.aliyun.com [115.124.30.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4416F37AA72
	for <ocfs2-devel@lists.linux.dev>; Fri,  3 Apr 2026 09:08:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775207291; cv=none; b=uDyCCIt1QQNfkPEGCbFMXXnUl9DME5og+8x8UiZXcRnJOhIcKnAnRtdpOTUDEkLNgH6DgGtCa6Qs6o77C1JzpQ8X+wzctrMYjVHLNbkrMf/r9Yew6YrjQ1/QTQSCTzo77dKTLHnb8V6hgrog23/WIpm59SCfWjnASlqQPkld/14=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775207291; c=relaxed/simple;
	bh=X5aWtGjqDenZ9AOrYl+S/vhnAeXagWivNUJoo5DR29s=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=BqQDcU4Sk7jHPD6gixeVOTZPWLF1mIZC7PcrKB1tq53PN1Gs9HqGt+yDyRUnQfSii0snOxhq3MaU8OwFi8mPQ59pohKexh4gnp47x8FtQaP4zXKn3elb+DR9MQfRYgNItWFBSm5h9MDhYV4OPwxxQ3JZhMCG1YuDbaaiN6t2vkE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=TZAQsM5W; arc=none smtp.client-ip=115.124.30.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="TZAQsM5W"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1775207286; h=From:To:Subject:Date:Message-Id:MIME-Version;
	bh=30xbXXjhK+DybaqKvQxJZhjgyjkrcOWsLr3QSd7mSDY=;
	b=TZAQsM5W/dYpv9+acyZvWuoA+eJSTiQlZdxdPHNh7r3tXJ7XLBk63fvbHCLk/mM/M7u7KCUQYDlOhVCQTDLESdFVy6aKrNYiXba6oVeUdGkiyvKIaEHXNb0ITTwtablfL6u5q65yYPwoenH+P9vswLusxdtny5L66GcSJ3XKv1I=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R441e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033045098064;MF=joseph.qi@linux.alibaba.com;NM=1;PH=DS;RN=5;SR=0;TI=SMTPD_---0X0JrROp_1775207285;
Received: from localhost(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0X0JrROp_1775207285 cluster:ay36)
          by smtp.aliyun-inc.com;
          Fri, 03 Apr 2026 17:08:05 +0800
From: Joseph Qi <joseph.qi@linux.alibaba.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	Heming Zhao <heming.zhao@suse.com>,
	ZhengYuan Huang <gality369@gmail.com>
Cc: ocfs2-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: [PATCH 1/4] ocfs2: validate dx_root extent list fields during block read
Date: Fri,  3 Apr 2026 17:08:00 +0800
Message-Id: <20260403090803.3860971-2-joseph.qi@linux.alibaba.com>
X-Mailer: git-send-email 2.39.3
In-Reply-To: <20260403090803.3860971-1-joseph.qi@linux.alibaba.com>
References: <20260403090803.3860971-1-joseph.qi@linux.alibaba.com>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Move the extent list l_count validation from ocfs2_dx_dir_lookup_rec()
into ocfs2_validate_dx_root(), so that corrupted on-disk fields are
caught early at block read time rather than during directory lookups.

Additionally, add a l_next_free_rec <= l_count check to prevent
out-of-bounds access when iterating over extent records.

Both checks are skipped for inline dx roots (OCFS2_DX_FLAG_INLINE),
which use dr_entries instead of dr_list.

Signed-off-by: Joseph Qi <joseph.qi@linux.alibaba.com>
---
 fs/ocfs2/dir.c | 34 +++++++++++++++++++++++++---------
 1 file changed, 25 insertions(+), 9 deletions(-)

diff --git a/fs/ocfs2/dir.c b/fs/ocfs2/dir.c
index 1c8abf2c592c..82e720c8ba32 100644
--- a/fs/ocfs2/dir.c
+++ b/fs/ocfs2/dir.c
@@ -593,7 +593,7 @@ static int ocfs2_validate_dx_root(struct super_block *sb,
 		mlog(ML_ERROR,
 		     "Checksum failed for dir index root block %llu\n",
 		     (unsigned long long)bh->b_blocknr);
-		return ret;
+		goto bail;
 	}
 
 	if (!OCFS2_IS_VALID_DX_ROOT(dx_root)) {
@@ -601,8 +601,32 @@ static int ocfs2_validate_dx_root(struct super_block *sb,
 				  "Dir Index Root # %llu has bad signature %.*s\n",
 				  (unsigned long long)le64_to_cpu(dx_root->dr_blkno),
 				  7, dx_root->dr_signature);
+		goto bail;
+	}
+
+	if (!(dx_root->dr_flags & OCFS2_DX_FLAG_INLINE)) {
+		struct ocfs2_extent_list *el = &dx_root->dr_list;
+
+		if (le16_to_cpu(el->l_count) != ocfs2_extent_recs_per_dx_root(sb)) {
+			ret = ocfs2_error(sb,
+					  "Dir Index Root # %llu has invalid l_count %u (expected %u)\n",
+					  (unsigned long long)le64_to_cpu(dx_root->dr_blkno),
+					  le16_to_cpu(el->l_count),
+					  ocfs2_extent_recs_per_dx_root(sb));
+			goto bail;
+		}
+
+		if (le16_to_cpu(el->l_next_free_rec) > le16_to_cpu(el->l_count)) {
+			ret = ocfs2_error(sb,
+					  "Dir Index Root # %llu has invalid l_next_free_rec %u (l_count %u)\n",
+					  (unsigned long long)le64_to_cpu(dx_root->dr_blkno),
+					  le16_to_cpu(el->l_next_free_rec),
+					  le16_to_cpu(el->l_count));
+			goto bail;
+		}
 	}
 
+bail:
 	return ret;
 }
 
@@ -791,14 +815,6 @@ static int ocfs2_dx_dir_lookup_rec(struct inode *inode,
 	struct ocfs2_extent_block *eb;
 	struct ocfs2_extent_rec *rec = NULL;
 
-	if (le16_to_cpu(el->l_count) !=
-	    ocfs2_extent_recs_per_dx_root(inode->i_sb)) {
-		ret = ocfs2_error(inode->i_sb,
-				  "Inode %lu has invalid extent list length %u\n",
-				  inode->i_ino, le16_to_cpu(el->l_count));
-		goto out;
-	}
-
 	if (el->l_tree_depth) {
 		ret = ocfs2_find_leaf(INODE_CACHE(inode), el, major_hash,
 				      &eb_bh);
-- 
2.39.3

