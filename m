Received: from out30-124.freemail.mail.aliyun.com (out30-124.freemail.mail.aliyun.com [115.124.30.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C579D3B79F
	for <ocfs2-devel@lists.linux.dev>; Wed, 15 May 2024 13:29:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715779799; cv=none; b=c5a75vtXKbKd4f2Hy8WcyvBo7JFk9rEY5p+FuJAMXxQqh8gTb1HI8cTmKbORJafk2PbluzK38SAEscuk2Nt7GGo2sxRe17WORcyPMaV0I81OYMxzVLoK4bVlcW7dAZtj3cj4gO6eh6RmJT/EYXTydaxCWlk8hKma3zH8glqJ2uA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715779799; c=relaxed/simple;
	bh=gz0ggfN6+8zfLHC6A1tTQMN9AyVLIKPJ0bhOy7smPrU=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=u6fj+yNM7dGuUZeQ54wPIOD+OPAD0f8AnrRn1MNy7HkHucBbwhYO/UJeC2XThat0RIX1A0phmabhDuXC8MRLKyf2p5O8SYrQgB92oj6Z1ofhYzz8EjPG0YKrUE9hz6M/3jreEMhepWNubA5XOoTZfHGLr9HKPMLixX5uv6bhcB0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=j3qSWeB1; arc=none smtp.client-ip=115.124.30.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="j3qSWeB1"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1715779789; h=From:To:Subject:Date:Message-Id:MIME-Version;
	bh=51HpooU0DkeKvMgR87mxZX64g8YR7tYzfAIqWRzGG0o=;
	b=j3qSWeB1b7PgB787B5JiLrjNs3fM1W7ImvnYRJu4tgjdUx8vuwhgdmct/HXES6CHibs4ZV2q3RLRYuKM3qOs/fhj623Xj4FTJKPgnILZA52HGt/gWtCcz2GDMFYnrJ7+Q0t1c0aOdTMxTSsuKLPRI6hsAc8zg1GnL5q1gglvJKQ=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R381e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037067111;MF=mengferry@linux.alibaba.com;NM=1;PH=DS;RN=6;SR=0;TI=SMTPD_---0W6YDIFU_1715779785;
Received: from j66c13357.sqa.eu95.tbsite.net(mailfrom:mengferry@linux.alibaba.com fp:SMTPD_---0W6YDIFU_1715779785)
          by smtp.aliyun-inc.com;
          Wed, 15 May 2024 21:29:48 +0800
From: Ferry Meng <mengferry@linux.alibaba.com>
To: Mark Fasheh <mark@fasheh.com>,
	Joel Becker <jlbec@evilplan.org>,
	Joseph Qi <joseph.qi@linux.alibaba.com>,
	ocfs2-devel@lists.linux.dev
Cc: linux-kernel@vger.kernel.org,
	Ferry Meng <mengferry@linux.alibaba.com>
Subject: [PATCH 1/2] ocfs2: add bounds checking to ocfs2_xattr_find_entry()
Date: Wed, 15 May 2024 21:29:33 +0800
Message-Id: <20240515132934.69511-2-mengferry@linux.alibaba.com>
X-Mailer: git-send-email 2.32.0.3.g01195cf9f
In-Reply-To: <20240515132934.69511-1-mengferry@linux.alibaba.com>
References: <20240515132934.69511-1-mengferry@linux.alibaba.com>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Just add redundant (perhaps paranoia) checks to make sure it doesn't
stray beyond valid meory region of ocfs2 xattr entry array during a
single match.

Maybe this patch can prevent some crash caused by crafted poison images.

Signed-off-by: Ferry Meng <mengferry@linux.alibaba.com>
---
 fs/ocfs2/xattr.c | 14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

diff --git a/fs/ocfs2/xattr.c b/fs/ocfs2/xattr.c
index 3b81213ed7b8..37be4a286faf 100644
--- a/fs/ocfs2/xattr.c
+++ b/fs/ocfs2/xattr.c
@@ -1062,8 +1062,8 @@ ssize_t ocfs2_listxattr(struct dentry *dentry,
 	return i_ret + b_ret;
 }
 
-static int ocfs2_xattr_find_entry(int name_index,
-				  const char *name,
+static int ocfs2_xattr_find_entry(struct inode *inode, void *end,
+				  int name_index, const char *name,
 				  struct ocfs2_xattr_search *xs)
 {
 	struct ocfs2_xattr_entry *entry;
@@ -1076,6 +1076,10 @@ static int ocfs2_xattr_find_entry(int name_index,
 	name_len = strlen(name);
 	entry = xs->here;
 	for (i = 0; i < le16_to_cpu(xs->header->xh_count); i++) {
+		if ((void *)entry >= end) {
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
+	ret = ocfs2_xattr_find_entry(inode, xs->end, name_index, name, xs);
 	if (ret)
 		return ret;
 	size = le64_to_cpu(xs->here->xe_value_size);
@@ -2698,7 +2702,7 @@ static int ocfs2_xattr_ibody_find(struct inode *inode,
 
 	/* Find the named attribute. */
 	if (oi->ip_dyn_features & OCFS2_INLINE_XATTR_FL) {
-		ret = ocfs2_xattr_find_entry(name_index, name, xs);
+		ret = ocfs2_xattr_find_entry(inode, xs->end, name_index, name, xs);
 		if (ret && ret != -ENODATA)
 			return ret;
 		xs->not_found = ret;
@@ -2833,7 +2837,7 @@ static int ocfs2_xattr_block_find(struct inode *inode,
 		xs->end = (void *)(blk_bh->b_data) + blk_bh->b_size;
 		xs->here = xs->header->xh_entries;
 
-		ret = ocfs2_xattr_find_entry(name_index, name, xs);
+		ret = ocfs2_xattr_find_entry(inode, xs->end, name_index, name, xs);
 	} else
 		ret = ocfs2_xattr_index_block_find(inode, blk_bh,
 						   name_index,
-- 
2.32.0.3.g01195cf9f

