Received: from out30-110.freemail.mail.aliyun.com (out30-110.freemail.mail.aliyun.com [115.124.30.110])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A713846F
	for <ocfs2-devel@lists.linux.dev>; Mon, 20 May 2024 02:45:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.110
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716173153; cv=none; b=hKZ9dbmKolD3pawmo27XLIeWXF5DouFpM90Dvcpw5vI85YcZBRZXpoygMNB/APBQlrHaCMT84mLJhBBMpuQySxrgS5hrU7NKWvTW87R8f/xPUI1FlNqmbIk3IWGLmGwPHXyXdWB5Ukho3GZwdOUK+x2t8jN6EOXf6wSurnWFd5g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716173153; c=relaxed/simple;
	bh=YpHoHZTDUwGvxUSffZ4j6bfVVEvavLl/wg2r46JwoQM=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=rN8AaHj86QAHlJ0oCpRbftuN8NfS74+zDT4T5lrzqvilbw94ufOrgcqY/d9MNt5GiGI+pbjELI+N18GPWCpMbdVOV0e4JB2TMsV+bCBfuwlBHg86eRhHkd8prk1WCp6jZHIMBT1MMNzMG2qy42GGNEeGKmm21gRGUTZKPqMHebQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=JHArx9KF; arc=none smtp.client-ip=115.124.30.110
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="JHArx9KF"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1716173143; h=From:To:Subject:Date:Message-Id:MIME-Version;
	bh=iNSnI6K93t30PJwSxRkWWTRedjH8+oL/2zFPwCcRsdo=;
	b=JHArx9KFHJ/sVE2a62MupvnYsCsIkPkVHiwM/uOaCEMtHEIzC6aJv7DJyX3/7rJTwuQutCjU+lvSuSy98jFJx93eRmKBK/WJmshs1RrURva5lffgrvHTtD2sbHlXKTqkPG8fDl7JYJIQPtx15NhB+agQUCjWzk7zMABsFbJurpA=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R351e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033045046011;MF=joseph.qi@linux.alibaba.com;NM=1;PH=DS;RN=4;SR=0;TI=SMTPD_---0W6kzCdu_1716172824;
Received: from localhost(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0W6kzCdu_1716172824)
          by smtp.aliyun-inc.com;
          Mon, 20 May 2024 10:40:25 +0800
From: Joseph Qi <joseph.qi@linux.alibaba.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	Ferry Meng <mengferry@linux.alibaba.com>,
	lei lu <llfamsec@gmail.com>
Cc: ocfs2-devel@lists.linux.dev
Subject: [PATCH RESEND 1/2] ocfs2: add bounds checking to ocfs2_xattr_find_entry()
Date: Mon, 20 May 2024 10:40:23 +0800
Message-Id: <20240520024024.1976129-1-joseph.qi@linux.alibaba.com>
X-Mailer: git-send-email 2.39.3
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Ferry Meng <mengferry@linux.alibaba.com>

From: Ferry Meng <mengferry@linux.alibaba.com>

Add a paranoia check to make sure it doesn't stray beyond valid memory
region containing ocfs2 xattr entries when scanning for a match.
It will prevent out-of-bound access in case of crafted images.

Reported-by: lei lu <llfamsec@gmail.com>
Signed-off-by: Ferry Meng <mengferry@linux.alibaba.com>
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
---
 fs/ocfs2/xattr.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/fs/ocfs2/xattr.c b/fs/ocfs2/xattr.c
index 3b81213ed7b8..8aea94c90739 100644
--- a/fs/ocfs2/xattr.c
+++ b/fs/ocfs2/xattr.c
@@ -1062,7 +1062,7 @@ ssize_t ocfs2_listxattr(struct dentry *dentry,
 	return i_ret + b_ret;
 }
 
-static int ocfs2_xattr_find_entry(int name_index,
+static int ocfs2_xattr_find_entry(struct inode *inode, int name_index,
 				  const char *name,
 				  struct ocfs2_xattr_search *xs)
 {
@@ -1076,6 +1076,10 @@ static int ocfs2_xattr_find_entry(int name_index,
 	name_len = strlen(name);
 	entry = xs->here;
 	for (i = 0; i < le16_to_cpu(xs->header->xh_count); i++) {
+		if ((void *)entry >= xs->end) {
+			ocfs2_error(inode->i_sb, "corrupted xattr entries");
+			return -EFSCORRUPTED;
+		}
 		cmp = name_index - ocfs2_xattr_get_type(entry);
 		if (!cmp)
 			cmp = name_len - entry->xe_name_len;
@@ -1166,7 +1170,7 @@ static int ocfs2_xattr_ibody_get(struct inode *inode,
 	xs->base = (void *)xs->header;
 	xs->here = xs->header->xh_entries;
 
-	ret = ocfs2_xattr_find_entry(name_index, name, xs);
+	ret = ocfs2_xattr_find_entry(inode, name_index, name, xs);
 	if (ret)
 		return ret;
 	size = le64_to_cpu(xs->here->xe_value_size);
@@ -2698,7 +2702,7 @@ static int ocfs2_xattr_ibody_find(struct inode *inode,
 
 	/* Find the named attribute. */
 	if (oi->ip_dyn_features & OCFS2_INLINE_XATTR_FL) {
-		ret = ocfs2_xattr_find_entry(name_index, name, xs);
+		ret = ocfs2_xattr_find_entry(inode, name_index, name, xs);
 		if (ret && ret != -ENODATA)
 			return ret;
 		xs->not_found = ret;
@@ -2833,7 +2837,7 @@ static int ocfs2_xattr_block_find(struct inode *inode,
 		xs->end = (void *)(blk_bh->b_data) + blk_bh->b_size;
 		xs->here = xs->header->xh_entries;
 
-		ret = ocfs2_xattr_find_entry(name_index, name, xs);
+		ret = ocfs2_xattr_find_entry(inode, name_index, name, xs);
 	} else
 		ret = ocfs2_xattr_index_block_find(inode, blk_bh,
 						   name_index,
-- 
2.39.3

