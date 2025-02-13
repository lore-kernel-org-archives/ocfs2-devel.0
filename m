Received: from air.basealt.ru (air.basealt.ru [193.43.8.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D48666F073
	for <ocfs2-devel@lists.linux.dev>; Thu, 13 Feb 2025 19:16:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=193.43.8.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739474220; cv=none; b=O6h2LaVP6eBfSXLI7yADVHSwf1F1jXdaZPUcYE5hO2E4z0QniAXPMknMiOXudq9eCJwN+M+KKEBA0op3GzPHgwDRWYXsQyG9cJ2wl0NJ1Novlg2Bqe122fThIsC0qf8Uw+6qnXclgE02Unac9SsulOrhak+8sFNPCQQANdSakBo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739474220; c=relaxed/simple;
	bh=QvA3KPL6cTcXNJAL8Q++bBi7XpqTvPThW7tuQ2n+tXA=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=NQ78pEHe75F2ESrx4E5XUz+JRlsrc8F9zH1tJrgoBNQuV4er5iwiGmIZy7QVtmHSPkVRyNwxPCBofmPml1ZC/l1L4/5ewvJsVfnxId02nAOhtLpnsjv9AsziXnrmmBD9p5Y3rEBcvB5BJgjMcfXrvEt9pua5RCNf5YWPrUG8RJU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=altlinux.org; spf=pass smtp.mailfrom=altlinux.org; arc=none smtp.client-ip=193.43.8.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=altlinux.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=altlinux.org
Received: from altlinux.ipa.basealt.ru (unknown [178.76.204.78])
	(Authenticated sender: kovalevvv)
	by air.basealt.ru (Postfix) with ESMTPSA id 5B05E23382;
	Thu, 13 Feb 2025 22:16:48 +0300 (MSK)
From: Vasiliy Kovalev <kovalev@altlinux.org>
To: linux-kernel@vger.kernel.org,
	ocfs2-devel@lists.linux.dev,
	Kurt Hackel <kurt.hackel@oracle.com>,
	Joseph Qi <joseph.qi@linux.alibaba.com>,
	Joel Becker <jlbec@evilplan.org>,
	Mark Fasheh <mark@fasheh.com>
Cc: kovalev@altlinux.org,
	lvc-project@linuxtesting.org,
	syzbot+66c146268dc88f4341fd@syzkaller.appspotmail.com
Subject: [PATCH] ocfs2: validate l_tree_depth to avoid out-of-bounds access
Date: Thu, 13 Feb 2025 22:16:42 +0300
Message-Id: <20250213191642.720812-1-kovalev@altlinux.org>
X-Mailer: git-send-email 2.33.8
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The l_tree_depth field in struct ocfs2_extent_list is defined
as __le16, but according to the comments in the structure
definition, the high 8 bits must not be used, meaning its
maximum valid value is 255.

Add a check to prevent out-of-bounds access if l_tree_depth
has an invalid value, which may occur when reading from a
corrupted mounted disk [1].

Fixes: ccd979bdbce9 ("[PATCH] OCFS2: The Second Oracle Cluster Filesystem")
Reported-by: syzbot+66c146268dc88f4341fd@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=66c146268dc88f4341fd [1]
Signed-off-by: Vasiliy Kovalev <kovalev@altlinux.org>
---
 fs/ocfs2/extent_map.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/fs/ocfs2/extent_map.c b/fs/ocfs2/extent_map.c
index 930150ed5db15..0d9c25fdec029 100644
--- a/fs/ocfs2/extent_map.c
+++ b/fs/ocfs2/extent_map.c
@@ -415,6 +415,15 @@ static int ocfs2_get_clusters_nocache(struct inode *inode,
 	tree_height = le16_to_cpu(el->l_tree_depth);
 
 	if (tree_height > 0) {
+		if (unlikely(tree_height > 255)) {
+			ocfs2_error(inode->i_sb,
+				    "Inode %lu has too large l_tree_depth=%u in leaf block %llu\n",
+				    inode->i_ino, tree_height,
+				    (unsigned long long)di_bh->b_blocknr);
+			ret = -EROFS;
+			goto out;
+		}
+
 		ret = ocfs2_find_leaf(INODE_CACHE(inode), el, v_cluster,
 				      &eb_bh);
 		if (ret) {
-- 
2.42.2

