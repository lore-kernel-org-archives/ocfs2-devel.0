Received: from out30-113.freemail.mail.aliyun.com (out30-113.freemail.mail.aliyun.com [115.124.30.113])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C63937998C
	for <ocfs2-devel@lists.linux.dev>; Tue,  1 Sep 2026 06:33:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.113
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788244396; cv=none; b=VfJn9n8n8+0ptirj1sWvYcv61JqzjFbbtNfdV4f3N1Ts0jvbPJbwIwFPsQqjWdrgl6TBIJHCMSUE90g3rd6V29j7/onBMwCUZRub/0Djy8H013uGRe4ZzW9pXY/sWWuWBtadqfOEh63FN+fLYMwa7Duux1FSPy4PfuNUAKYfNAM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788244396; c=relaxed/simple;
	bh=zq+dBOR9pu3uUy3aiwRsKoY192nzaH3ZtvrLvS3g5zE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=ROYZbTTnGPV/XV+t3PR6kqGu8MNWCyEyJPXj8BjIOaQivJ/cbVurtKTnc+z3RvPE41KVXA65xYmVt54z1ARtif0JCKUmE6tJ/lYDDDmunmJo+S+IXxGgv+tgb+fx7SqyHu4NoxxIFRyZxwyjGgzWZHel+wP1QnkgVPyqH40w0sM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=fX8V/zhy; arc=none smtp.client-ip=115.124.30.113
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="fX8V/zhy"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1788244386; h=From:To:Subject:Date:Message-Id:MIME-Version;
	bh=U3YQzZeMlyQnz6ajZaVTDD69Hg0YteEmTq0IsPrfcV0=;
	b=fX8V/zhyM+NcC+ek680h03Y1MJWh1FU4BL7YX3hrHU3vwQshJRqK+d2bQnIa5a0VncMmR1fReWozXBZ1M2DCLbcufLxpOr9tqTSbXP9yuXdLUtDwgu/1tngkQFu0+0iffpzZfNLkPHinddrzM+rdv6F1GxlLLpd81SULtxvWigI=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R171e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037026112;MF=joseph.qi@linux.alibaba.com;NM=1;PH=DS;RN=6;SR=0;TI=SMTPD_---0XA3vCjE_1788244385;
Received: from localhost(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0XA3vCjE_1788244385 cluster:ay36)
          by smtp.aliyun-inc.com;
          Tue, 01 Sep 2026 14:33:06 +0800
From: Joseph Qi <joseph.qi@linux.alibaba.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	Heming Zhao <heming.zhao@suse.com>
Cc: Mark Fasheh <mark@fasheh.com>,
	Joel Becker <jlbec@evilplan.org>,
	ocfs2-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2 4/4] ocfs2: validate suballoc slot and bit of extent and refcount blocks
Date: Tue,  1 Sep 2026 14:33:01 +0800
Message-Id: <20260901063301.984933-5-joseph.qi@linux.alibaba.com>
X-Mailer: git-send-email 2.39.3
In-Reply-To: <20260901063301.984933-1-joseph.qi@linux.alibaba.com>
References: <20260901063301.984933-1-joseph.qi@linux.alibaba.com>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

ocfs2_validate_extent_block() and ocfs2_validate_refcount_block() do
not validate h_suballoc_slot, h_suballoc_bit, rf_suballoc_slot and
rf_suballoc_bit at all.  Since extent blocks and refcount blocks are
allocated from a per-slot suballocator at runtime, their suballoc
slots must be within range and their suballoc bits must fit in a block
group bitmap.

Otherwise a corrupted image can carry an out-of-range slot.  When the
extent block is freed, ocfs2_cache_extent_block_free() caches it and
ocfs2_free_cached_blocks() later passes the unvalidated slot to
ocfs2_get_system_file_inode(); when the refcount block is freed,
ocfs2_remove_refcount_extent() passes it via ocfs2_cache_block_dealloc().
get_local_system_inode() will then either hit
BUG_ON(slot == OCFS2_INVALID_SLOT) or compute an out-of-bounds index
into the local_system_inodes array.  Similarly an oversized suballoc
bit will trigger BUG_ON((count + start_bit) > ocfs2_bits_per_group(cl))
in _ocfs2_free_suballoc_bits().

Reject out-of-range suballoc slots and oversized suballoc bits during
validation.

Signed-off-by: Joseph Qi <joseph.qi@linux.alibaba.com>
---
 fs/ocfs2/alloc.c        | 27 +++++++++++++++++++++++++++
 fs/ocfs2/refcounttree.c | 27 +++++++++++++++++++++++++++
 2 files changed, 54 insertions(+)

diff --git a/fs/ocfs2/alloc.c b/fs/ocfs2/alloc.c
index be09e766ac1f..9f5e94e734e9 100644
--- a/fs/ocfs2/alloc.c
+++ b/fs/ocfs2/alloc.c
@@ -925,6 +925,33 @@ static int ocfs2_validate_extent_block(struct super_block *sb,
 		goto bail;
 	}
 
+	/*
+	 * Extent blocks are allocated from a per-slot suballocator, so the
+	 * slot must be in range.  Otherwise freeing the block passes it to
+	 * get_local_system_inode(), which hits BUG_ON() for
+	 * OCFS2_INVALID_SLOT or computes an out-of-bounds index otherwise.
+	 */
+	if ((u32)le16_to_cpu(eb->h_suballoc_slot) >= OCFS2_SB(sb)->max_slots) {
+		rc = ocfs2_error(sb,
+				 "Extent block #%llu has an invalid h_suballoc_slot of %u\n",
+				 (unsigned long long)bh->b_blocknr,
+				 le16_to_cpu(eb->h_suballoc_slot));
+		goto bail;
+	}
+
+	/*
+	 * Similarly the suballoc bit must fit in a block group bitmap.
+	 * Otherwise freeing the block will pass the oversized bit to
+	 * _ocfs2_free_suballoc_bits() and trigger BUG_ON() there.
+	 */
+	if (le16_to_cpu(eb->h_suballoc_bit) >= ocfs2_suballoc_bits_per_block(sb)) {
+		rc = ocfs2_error(sb,
+				 "Extent block #%llu has an invalid h_suballoc_bit of %u\n",
+				 (unsigned long long)bh->b_blocknr,
+				 le16_to_cpu(eb->h_suballoc_bit));
+		goto bail;
+	}
+
 	if (le16_to_cpu(eb->h_list.l_count) != ocfs2_extent_recs_per_eb(sb)) {
 		rc = ocfs2_error(sb,
 				 "Extent block #%llu has invalid l_count %u (expected %u)\n",
diff --git a/fs/ocfs2/refcounttree.c b/fs/ocfs2/refcounttree.c
index d9f22b4a2654..3c8f2b64a8e1 100644
--- a/fs/ocfs2/refcounttree.c
+++ b/fs/ocfs2/refcounttree.c
@@ -117,6 +117,33 @@ static int ocfs2_validate_refcount_block(struct super_block *sb,
 		goto out;
 	}
 
+	/*
+	 * Refcount blocks are allocated from a per-slot suballocator, so the
+	 * slot must be in range.  Otherwise freeing the block passes it to
+	 * get_local_system_inode(), which hits BUG_ON() for
+	 * OCFS2_INVALID_SLOT or computes an out-of-bounds index otherwise.
+	 */
+	if ((u32)le16_to_cpu(rb->rf_suballoc_slot) >= OCFS2_SB(sb)->max_slots) {
+		rc = ocfs2_error(sb,
+				 "Refcount block #%llu has an invalid rf_suballoc_slot of %u\n",
+				 (unsigned long long)bh->b_blocknr,
+				 le16_to_cpu(rb->rf_suballoc_slot));
+		goto out;
+	}
+
+	/*
+	 * Similarly the suballoc bit must fit in a block group bitmap.
+	 * Otherwise freeing the block will pass the oversized bit to
+	 * _ocfs2_free_suballoc_bits() and trigger BUG_ON() there.
+	 */
+	if (le16_to_cpu(rb->rf_suballoc_bit) >= ocfs2_suballoc_bits_per_block(sb)) {
+		rc = ocfs2_error(sb,
+				 "Refcount block #%llu has an invalid rf_suballoc_bit of %u\n",
+				 (unsigned long long)bh->b_blocknr,
+				 le16_to_cpu(rb->rf_suballoc_bit));
+		goto out;
+	}
+
 	/*
 	 * rf_records (rl_count/rl_used/rl_recs[]) is only meaningful when
 	 * this block is not an interior tree block (OCFS2_REFCOUNT_TREE_FL);
-- 
2.39.3

