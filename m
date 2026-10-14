Received: from out30-133.freemail.mail.aliyun.com (out30-133.freemail.mail.aliyun.com [115.124.30.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73FFD4F4733
	for <ocfs2-devel@lists.linux.dev>; Wed, 14 Oct 2026 10:59:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791975550; cv=none; b=FCdjV9A6nSDuufIOS3sTiDmx4JU6a+Mnb2mT2rm+Gg1vwh0hO7aYvOJW4k8y+9pa9Tc85Nl7yk0f5/PoySazd6jfnF3OaseDjzsnzHd7aAmIP8sMImIRVTVVsMMEWIjkF7QyDIqabrHG6gH3e/8Zvylva//sPVx+/ivwmd7oBi0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791975550; c=relaxed/simple;
	bh=417w7jdr8/JtcTR9w5nwo2+nrWj9hzZx+/UzqdkcbhE=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=omHgZngcMFyoL6tScVz3tdX6UVeIK84xzm+s4uZ4V4dEjs/vzjawumin+bSDc4BzDKtVol8nQPlmGwEB9wbIOBSBUATkzJOpvgqAJccSEsfJvTOy8P+0J2nsyj1G2Q3Cym4MnSZDU9vz/SWEEgLC+cGD+8LgoBh7xipU5U1GJ6s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=h0/IMugg; arc=none smtp.client-ip=115.124.30.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="h0/IMugg"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1791975537; h=From:To:Subject:Date:Message-Id:MIME-Version;
	bh=q3somswdShAOyMSlpC93YH8hrkAIpb7NJfgX6GZayW4=;
	b=h0/IMugglzkyThX4r4AA/UW1v3ENQCzPtIZRt0J2yrHF26SfFKoVixkT6OQDB69lwZBC7fayzWWCNXY0spqPgZnquSZwBX06U2BzqnSV0pIBAKpbITWSp7/7Wl+JtC3WkajmFHRH6z7OlP2XhYwUNlWmBzUgVHp1QIf+BISpf+A=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R211e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037033178;MF=joseph.qi@linux.alibaba.com;NM=1;PH=DS;RN=6;SR=0;TI=SMTPD_---0XComWrS_1791975536;
Received: from localhost(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0XComWrS_1791975536 cluster:ay36)
          by smtp.aliyun-inc.com;
          Wed, 14 Oct 2026 18:58:57 +0800
From: Joseph Qi <joseph.qi@linux.alibaba.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	Heming Zhao <heming.zhao@suse.com>
Cc: Mark Fasheh <mark@fasheh.com>,
	Joel Becker <jlbec@evilplan.org>,
	ocfs2-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: [PATCH] ocfs2: validate the xattr tree root of an indexed xattr block
Date: Wed, 14 Oct 2026 18:58:56 +0800
Message-Id: <20261014105856.2909777-1-joseph.qi@linux.alibaba.com>
X-Mailer: git-send-email 2.39.3
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

ocfs2_validate_xattr_block() checks an xattr block's signature, blkno,
generation and suballocator fields, and for a non-indexed block the entry
array it carries.  An indexed block is passed straight through, so the
extent list in its xattr tree root is never looked at.

Both fields that describe the list are bounded.  The two places that
create a root set l_count from ocfs2_xattr_recs_per_xb() and nothing
rewrites it, and the insert path asserts in ocfs2_rotate_leaf() that
l_next_free_rec stays within l_count.  Check both when the block is
first read, so a root that disagrees with the block size, or claims more
records than it has room for, is caught before anything indexes into
l_recs[].

An empty root is deliberately not rejected.  Emptying the tree leaves it
that way: ocfs2_rm_xattr_cluster() removes one extent per transaction,
and the last one ends in ocfs2_truncate_rec(), whose closing
ocfs2_rotate_tree_left() reaches ocfs2_remove_empty_extent() on the
depth-zero root and takes l_next_free_rec to zero.  That transaction
commits before ocfs2_xattr_free_block() frees the block, and before
ocfs2_xattr_remove() clears i_xattr_loc, in two later transactions, so a
crash in between leaves an orphan inode pointing at an xattr block whose
root has no extents.  Both readers already cope with it:
__ocfs2_xattr_index_block_find() answers -ENODATA, and
ocfs2_iterate_xattr_index_block() returns without iterating.

Signed-off-by: Joseph Qi <joseph.qi@linux.alibaba.com>
---
 fs/ocfs2/xattr.c | 25 +++++++++++++++++++++++++
 1 file changed, 25 insertions(+)

diff --git a/fs/ocfs2/xattr.c b/fs/ocfs2/xattr.c
index 18d920b30602..b2bd06083a14 100644
--- a/fs/ocfs2/xattr.c
+++ b/fs/ocfs2/xattr.c
@@ -491,6 +491,7 @@ static int ocfs2_validate_xattr_block(struct super_block *sb,
 				      struct buffer_head *bh)
 {
 	int rc;
+	struct ocfs2_extent_list *el;
 	struct ocfs2_xattr_block *xb =
 		(struct ocfs2_xattr_block *)bh->b_data;
 
@@ -573,6 +574,30 @@ static int ocfs2_validate_xattr_block(struct super_block *sb,
 							 region_offset);
 	}
 
+	/*
+	 * An indexed xattr block carries the root of the xattr tree.  Its
+	 * record count is fixed by the block size and l_next_free_rec never
+	 * exceeds it.  A zero l_next_free_rec is valid: emptying the tree on
+	 * the inode deletion path leaves the root with no extents.
+	 */
+	el = &xb->xb_attrs.xb_root.xt_list;
+
+	if (le16_to_cpu(el->l_count) != ocfs2_xattr_recs_per_xb(sb)) {
+		return ocfs2_error(sb,
+				   "Xattr tree root #%llu has invalid l_count %u (expected %u)\n",
+				   (unsigned long long)bh->b_blocknr,
+				   le16_to_cpu(el->l_count),
+				   ocfs2_xattr_recs_per_xb(sb));
+	}
+
+	if (le16_to_cpu(el->l_next_free_rec) > le16_to_cpu(el->l_count)) {
+		return ocfs2_error(sb,
+				   "Xattr tree root #%llu has l_next_free_rec %u past the end of its list (l_count %u)\n",
+				   (unsigned long long)bh->b_blocknr,
+				   le16_to_cpu(el->l_next_free_rec),
+				   le16_to_cpu(el->l_count));
+	}
+
 	return 0;
 }
 
-- 
2.39.3

