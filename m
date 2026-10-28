Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=117.135.210.5
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793163774;
	b=JKsp0iHOhBT5mKBrxN2vi5Ym/G6aCUQO7ldwZ6U5R/1rzozQpZnjYhOND9Nw9ZTYkfbq
	 W5i+YuByZTzGWxOO8DiKU3v65RYNRr1UnQ4Qu7bc3CrRYfYp1OStGIF6M73sclYI21OiG
	 TNBj1ZlHEAq/ZAjMp2InjZJ4kyCVvL7ZYI0BIB1rWItMjF/HXuCtdCJNDFP+F4zhkA9a9
	 MFgRMK7U8u0GP3kjxvgY8Lw0dwogFmjIqCslRGAFPJCKJReSqN8Jn0JZWpS49qLd1Zy6K
	 uPTwJXdMcKxEEBqjG0jLd45hC9DrzqpJgE9LzVxCGi2LOCirfZXdDs0ez1Tu+gQtbAA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793163774;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-Id:X-Mailer:MIME-Version:Content-Transfer-Encoding:
	 X-CM-TRANSID:X-Coremail-Antispam:X-CM-SenderInfo;
	bh=IzFdRn+VOrybJgWWFDYuFapdxaKrHzcUaO5PvHVqwZk=;
	b=iuq1ZjRSZ8xUH3KHpXsTpe5uyym0oBEYTBZ3ZXryfW6s9ECZCBn7JMPN3CqZtaYxXiz1
	 guZ7KzgI7cYISCi2NiKB7ne/bxucYvaP5vndmt3h9Xyh5csoB9uKxn54qFcxTEr6gu4So
	 9QUhXCgXJUIwnpGwYU2OKa3U+7NGleDp+8W2pOpPeqnZKn15pLn9rEuUnfplglHEucmEd
	 k+pNxbbMllQu/fEJevwrllOMLRGJXK1XGIWw7o7S8N0rcLdJGz49uT0AZFGX4hyQB05Tl
	 dr9MEc62jkpDg2GtubIe1y/7d1Y4zR01iiWSsxH3rKV3z7c6opmQzBdv5xdE2LXhDUA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=163.com;
	spf=pass smtp.mailfrom=163.com;
	dkim=pass header.d=163.com header.i=@163.com header.a=rsa-sha256 header.s=s110527 header.b=dKdpHICL;
	arc=none smtp.remote-ip=117.135.210.5
Received: from m16.mail.163.com (m16.mail.163.com [117.135.210.5])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BDE6606A31D
	for <ocfs2-devel@lists.linux.dev>; Wed, 28 Oct 2026 05:02:52 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 2BDE6606A31D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=163.com header.i=@163.com header.a=rsa-sha256 header.s=s110527 header.b=dKdpHICL
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-Id:MIME-Version; bh=Iz
	FdRn+VOrybJgWWFDYuFapdxaKrHzcUaO5PvHVqwZk=; b=dKdpHICLW5v4MJxocm
	ZRQy2kT3QnLqf923RYGRzbTStMOP2aOfEeKg61ucQ/pK6M6jx3wcyQDLh6+5mPTB
	hD86Ji/mjlaHGGO+wRtbGnjcdY+zRtVX6YytcvtLiquBs0XrUMbfV/BQzkv0yleY
	zbb42XM/ip5GwtHHV/E8IYeeE=
Received: from pc.localdomain (unknown [])
	by gzga-smtp-mtada-g0-4 (Coremail) with SMTP id _____wDX35fTgeFqLgVkDg--.10775S2;
	Wed, 28 Oct 2026 13:02:12 +0800 (CST)
From: Jiale Yao <yaojiale02@163.com>
To: Mark Fasheh <mark@fasheh.com>,
	Joel Becker <jlbec@evilplan.org>,
	Joseph Qi <joseph.qi@linux.alibaba.com>,
	Heming Zhao <heming.zhao@suse.com>,
	ocfs2-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] ocfs2: validate the xattr tree root of an indexed xattr block
Date: Wed, 28 Oct 2026 13:02:10 +0800
Message-Id: <20261028050210.123904-1-yaojiale02@163.com>
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
X-CM-TRANSID:_____wDX35fTgeFqLgVkDg--.10775S2
X-Coremail-Antispam: 1Uf129KBjvJXoWxCFW8GrWDCF1DCFy8ZFW7XFb_yoW5uw4xpF
	nrCw1rtr4UGr1xur9xA34UWw1F9ws8GFnrJryxJr9xZFW7J3WIvr9Iv3WY9Fn09rZ3JrnI
	qF45Kr1UCa43ua7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07jwdb8UUUUU=
X-CM-SenderInfo: x1dryxhdohiji6rwjhhfrp/xtbC8BSo4mrhgdReNwAA3Z

From: Joseph Qi <joseph.qi@linux.alibaba.com>

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

Link: https://lore.kernel.org/20261014105856.2909777-1-joseph.qi@linux.alibaba.com
Signed-off-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Heming Zhao <heming.zhao@suse.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
---
 fs/ocfs2/xattr.c | 25 +++++++++++++++++++++++++
 1 file changed, 25 insertions(+)

diff --git a/fs/ocfs2/xattr.c b/fs/ocfs2/xattr.c
index 52e46d1b8763..8b7a382dc2ff 100644
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
2.34.1

