Received: from out30-111.freemail.mail.aliyun.com (out30-111.freemail.mail.aliyun.com [115.124.30.111])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89C01413799
	for <ocfs2-devel@lists.linux.dev>; Sat, 10 Oct 2026 11:34:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.111
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791632102; cv=none; b=rWUhayJ5hWtUMGWxYeMRv0EBgqYuipghWmB4WESy0LbOe9anxouQ3gNatvfo+L+8QvwZc/S82bF2lGWtEH3KHkmdC6pW5+AZ/8zqhRbrUNvYUCf7ZPv+XrPTFAnEyPBHGj/dtogGKftvaR5FfNGhlxjp1WX+rG0taFD22T2CqPs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791632102; c=relaxed/simple;
	bh=1ArUv4zY14cXl3Wn0JayiraDc2Q4sgIMzLUJG/Lit/c=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=pW3AqmpvZP+G1cjCt5jEXnR93GOiiNP2+EtbTlJkeOjjgEQ1LYDaLsjcK4xQ2sJrPh2CZz5H2pw3Wo8z6vAGKSEsB7Ef+zsTeNUiCU7IjWilpOpJKxEIKchABGcYXPQoqjx7vi+VyWiXXLgjsOaUROQjZhtu9hz3twovsMQovpg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=oBsb2igF; arc=none smtp.client-ip=115.124.30.111
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="oBsb2igF"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1791632096; h=From:To:Subject:Date:Message-Id:MIME-Version;
	bh=I6NtQGfz6p7yd+tXSFpdwKh92GfdoMPnWxkUliZla3c=;
	b=oBsb2igF4s9IoZWV9HVXOgDVgVNuwjKIIqBcqS6OR1NpA6L/vEIm/NLTs73a9kDSwEgPki2xnlntYw6xr1aNgvup1TXw6q+OGB4a3WLtrh4TbphDtO5GUJo9qduGuvRMdx7rRg3mV0V3V367XehV+9co24jFUuAqAzg1/tOWuoc=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R931e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037033178;MF=joseph.qi@linux.alibaba.com;NM=1;PH=DS;RN=6;SR=0;TI=SMTPD_---0XCW3a.b_1791632095;
Received: from localhost(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0XCW3a.b_1791632095 cluster:ay36)
          by smtp.aliyun-inc.com;
          Sat, 10 Oct 2026 19:34:56 +0800
From: Joseph Qi <joseph.qi@linux.alibaba.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	Heming Zhao <heming.zhao@suse.com>
Cc: Mark Fasheh <mark@fasheh.com>,
	Joel Becker <jlbec@evilplan.org>,
	ocfs2-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: [PATCH 1/3] ocfs2: reserve metadata for a new xattr block and its value tree
Date: Sat, 10 Oct 2026 19:34:52 +0800
Message-Id: <20261010113454.1420939-2-joseph.qi@linux.alibaba.com>
X-Mailer: git-send-email 2.39.3
In-Reply-To: <20261010113454.1420939-1-joseph.qi@linux.alibaba.com>
References: <20261010113454.1420939-1-joseph.qi@linux.alibaba.com>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The create side of meta_guess in ocfs2_calc_xattr_set_need() reserves
metadata for the new value's extent tree and nothing for the xattr block
that will hold it:

        } else {
                credits += OCFS2_XATTR_BLOCK_CREATE_CREDITS;
                if (xi->xi_value_len > OCFS2_XATTR_INLINE_SIZE) {
                        struct ocfs2_extent_list *el = &def_xv.xv.xr_list;
                        meta_add += ocfs2_extend_meta_needed(el);
                        ...

Commit 3ed2be719eb9 ("ocfs2: allow for more than one data extent when
creating xattr") meant to add that tree on top of the meta_add += 1 the
branch already had, but it moved the 1 into the else arm instead, so the
external-value case lost it.  The 1 is not optional: it is what
ocfs2_create_xattr_block() takes from meta_ac through
ocfs2_claim_metadata(), and it is spent before the value tree exists.

ocfs2_extend_meta_needed() on the empty def_xv list returns 2, so the
branch reserves 2 where 3 are needed.  The xattr block consumes one, and
when the cluster allocator is fragmented enough that the value needs
more than one extent, ocfs2_add_clusters_in_btree() comes back around
with a full value root and ocfs2_alloc_context_bits_left() of 1 against
a threshold of 2.  It answers RESTART_META, which
ocfs2_xattr_extend_allocation() turns into a BUG_ON().
Commit 0cdc7dde00ec ("ocfs2: fix missing metadata reservation for
large xattrs") downgraded that to -ENOSPC, at the cost of leaking the
clusters already handed out: ocfs2_xa_cleanup_value_truncate() takes
its !orig_clusters arm, drops the entry and leaves the clusters for
fsck.ocfs2 to reclaim.

Reserve for the block and the tree separately.

Fixes: 3ed2be719eb9 ("ocfs2: allow for more than one data extent when creating xattr")
Cc: <stable@vger.kernel.org>
Signed-off-by: Joseph Qi <joseph.qi@linux.alibaba.com>
---
 fs/ocfs2/xattr.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/fs/ocfs2/xattr.c b/fs/ocfs2/xattr.c
index a428fe908116..801d3d311115 100644
--- a/fs/ocfs2/xattr.c
+++ b/fs/ocfs2/xattr.c
@@ -3580,7 +3580,13 @@ static int ocfs2_calc_xattr_set_need(struct inode *inode,
 		credits += OCFS2_XATTR_BLOCK_CREATE_CREDITS;
 		if (xi->xi_value_len > OCFS2_XATTR_INLINE_SIZE) {
 			struct ocfs2_extent_list *el = &def_xv.xv.xr_list;
-			meta_add += ocfs2_extend_meta_needed(el);
+			/*
+			 * One block for the xattr block we may have to
+			 * allocate, the rest for growing the value tree it
+			 * would hold.  If ocfs2_xattr_ibody_set() succeeds
+			 * instead, that first block goes unused.
+			 */
+			meta_add += 1 + ocfs2_extend_meta_needed(el);
 			credits += ocfs2_calc_extend_credits(inode->i_sb,
 							     el);
 		} else {
-- 
2.39.3

