Received: from out30-133.freemail.mail.aliyun.com (out30-133.freemail.mail.aliyun.com [115.124.30.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3EE823CF12
	for <ocfs2-devel@lists.linux.dev>; Sat, 25 Oct 2025 12:32:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761395545; cv=none; b=EoPF48KarvapsSQsjZX3Ap695EiI8cq4PGS8D6hY2kgWIHD4/ylZoG1dyRxWLjG5T7i5zsWZfnydQpa45lsomwljDkS7PuPjD7dW/OZ1qeF3ADlDEbICV2t0VwVlyzX5kj7Kz2CDhlxYqW3lgz9VbvgfzhzP1GcjwqBKjV3BZn0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761395545; c=relaxed/simple;
	bh=eXNqJ0qt2xmVZDZUwXofW6NOaqwAgZoH+08wiNKX6WY=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=DptBgb+lf0TjQPEyr+26Bbg1tptbApj1uRSFMZTZ+mGD0vMUzrmUeB07wE7ec0T6VLERFkfIwNkn8YDor1eon6HxFqxcIgdX/gBGZTBvkmiBQvl1dRss8ba5TFAtICx0fsCsfJif7sTjQ0guDi2DMSpQ8JE6TCt2h6h8gyyNBY0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=Eo8xSdW8; arc=none smtp.client-ip=115.124.30.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="Eo8xSdW8"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1761395539; h=From:To:Subject:Date:Message-Id:MIME-Version;
	bh=wcRTelGjBmgONINlSQ4eKFl5kyEcojenXhCrepr1r2Q=;
	b=Eo8xSdW8QZB19qj5B4cEv3hA3RsurfWJQPblhFBCpCJZcrlN2DqyVpjh9z/XsJahnfh6Np+zktRtOm6pqRO29prCX6UwOHMqwJz/eW0TGQgfY88cr9TcFfq2ijK1tEF1ZCA4KEHcBDBxvc1lLSER1sMA1Q8QYenx29ga0yvIuP4=
Received: from localhost(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0Wqx-592_1761395538 cluster:ay36)
          by smtp.aliyun-inc.com;
          Sat, 25 Oct 2025 20:32:18 +0800
From: Joseph Qi <joseph.qi@linux.alibaba.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	Heming Zhao <heming.zhao@suse.com>
Cc: ocfs2-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] ocfs2: use correct endian in ocfs2_dinode_has_extents
Date: Sat, 25 Oct 2025 20:32:17 +0800
Message-Id: <20251025123218.3997866-1-joseph.qi@linux.alibaba.com>
X-Mailer: git-send-email 2.39.3
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Fields in ocfs2_dinode is little endian, covert to host endian when
checking those contents.

Fixes: fdbb6cd96ed5 ("ocfs2: correct l_next_free_rec in online check")
Signed-off-by: Joseph Qi <joseph.qi@linux.alibaba.com>
---
 fs/ocfs2/inode.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/fs/ocfs2/inode.c b/fs/ocfs2/inode.c
index fcc89856ab95..0a0a96054bfe 100644
--- a/fs/ocfs2/inode.c
+++ b/fs/ocfs2/inode.c
@@ -201,13 +201,15 @@ struct inode *ocfs2_iget(struct ocfs2_super *osb, u64 blkno, unsigned flags,
 static int ocfs2_dinode_has_extents(struct ocfs2_dinode *di)
 {
 	/* inodes flagged with other stuff in id2 */
-	if (di->i_flags & (OCFS2_SUPER_BLOCK_FL | OCFS2_LOCAL_ALLOC_FL |
-			   OCFS2_CHAIN_FL | OCFS2_DEALLOC_FL))
+	if (le32_to_cpu(di->i_flags) &
+	    (OCFS2_SUPER_BLOCK_FL | OCFS2_LOCAL_ALLOC_FL | OCFS2_CHAIN_FL |
+	     OCFS2_DEALLOC_FL))
 		return 0;
 	/* i_flags doesn't indicate when id2 is a fast symlink */
-	if (S_ISLNK(di->i_mode) && di->i_size && di->i_clusters == 0)
+	if (S_ISLNK(le16_to_cpu(di->i_mode)) && le64_to_cpu(di->i_size) &&
+	    !le32_to_cpu(di->i_clusters))
 		return 0;
-	if (di->i_dyn_features & OCFS2_INLINE_DATA_FL)
+	if (le16_to_cpu(di->i_dyn_features) & OCFS2_INLINE_DATA_FL)
 		return 0;
 
 	return 1;
-- 
2.39.3

