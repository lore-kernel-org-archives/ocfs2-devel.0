Received: from out30-113.freemail.mail.aliyun.com (out30-113.freemail.mail.aliyun.com [115.124.30.113])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB3733A7F54
	for <ocfs2-devel@lists.linux.dev>; Tue,  1 Sep 2026 12:52:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.113
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788267152; cv=none; b=Up6KC4eesrUOsVpAg4zbn6rZw3YH9Vcsmd8QGINy5VlLRPczBeFCmVZri9ZqeKKVz0qtIv21olnBVP4dB3cZzLgDz/7lWS4DEKL91IvT9xalr7JOkSJkxOlyrmH0CT1QwBT0mSt/m6ROJss6W18yBlh6Y0r8QkNnarozh7WKuYQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788267152; c=relaxed/simple;
	bh=VwqZK90dxuLVjGg6rgDcQEloreeN/ku+546Mw+4DdCI=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=LuKP91ooYWE491v35GkDaogGFcUR4Ec5kJSbRMtNkmprOOMvRRgNQOrp+SIRlJa2g1PhQiaypeT3JRtfhIf3098QhlZ5CHspH+TNiZ4qvMF88ccMpRrhWo3AaP6dTV4BiypT8NqPhgwf3EadfW3EV/5CcGZH3hP7BRQ2QgdoNJ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=rCR2Fphx; arc=none smtp.client-ip=115.124.30.113
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="rCR2Fphx"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1788267146; h=From:To:Subject:Date:Message-Id:MIME-Version;
	bh=lO05Xg2Ij7GojObgHIN9IulfmzcQf0TBixu99pXyXZ0=;
	b=rCR2FphxkqQRYdRP8SptrDv/R4sf5SDClFpBQZvSVetbHOHAR70m3PespsDXZVdGepYHsSqJohRPFK+QHXxpJnb69Bn9JK+CMiICG/M5jaTZDFqT0aQNWpTu5JliL8q4qk3/ZdkuRCVC3C8InF0sreOtAW6/QB2GlW0WtUFAkcQ=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R391e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037009110;MF=joseph.qi@linux.alibaba.com;NM=1;PH=DS;RN=6;SR=0;TI=SMTPD_---0XA8SdjK_1788267145;
Received: from localhost(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0XA8SdjK_1788267145 cluster:ay36)
          by smtp.aliyun-inc.com;
          Tue, 01 Sep 2026 20:52:25 +0800
From: Joseph Qi <joseph.qi@linux.alibaba.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	Heming Zhao <heming.zhao@suse.com>
Cc: Mark Fasheh <mark@fasheh.com>,
	Joel Becker <jlbec@evilplan.org>,
	ocfs2-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: [PATCH v3 4/4] ocfs2: validate suballoc slot and bit of extent and refcount blocks
Date: Tue,  1 Sep 2026 20:52:21 +0800
Message-Id: <20260901125221.1634686-5-joseph.qi@linux.alibaba.com>
X-Mailer: git-send-email 2.39.3
In-Reply-To: <20260901125221.1634686-1-joseph.qi@linux.alibaba.com>
References: <20260901125221.1634686-1-joseph.qi@linux.alibaba.com>
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
bit will error out the filesystem in _ocfs2_free_suballoc_bits().

Furthermore group descriptor validation only guarantees bg_bits within
the physical bitmap size, so a corrupted image can still carry a
suballoc bit beyond bg_bits, which would let
ocfs2_block_group_clear_bits() clear bits beyond bg_bitmap.  Convert
the remaining BUG_ON against group->bg_bits in
_ocfs2_free_suballoc_bits() to ocfs2_error() as well.

Reject out-of-range suballoc slots and oversized suballoc bits during
validation.

Signed-off-by: Joseph Qi <joseph.qi@linux.alibaba.com>
---
 fs/ocfs2/alloc.c        | 27 +++++++++++++++++++++++++++
 fs/ocfs2/refcounttree.c | 27 +++++++++++++++++++++++++++
 fs/ocfs2/suballoc.c     | 15 ++++++++++++++-
 3 files changed, 68 insertions(+), 1 deletion(-)

diff --git a/fs/ocfs2/alloc.c b/fs/ocfs2/alloc.c
index be09e766ac1f..2fdc5403b10b 100644
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
+	 * _ocfs2_free_suballoc_bits() and trigger ocfs2_error() there.
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
index d9f22b4a2654..3e9cccf06e48 100644
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
+	 * _ocfs2_free_suballoc_bits() and trigger ocfs2_error() there.
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
diff --git a/fs/ocfs2/suballoc.c b/fs/ocfs2/suballoc.c
index ce22d0c3d287..624152e4f7fe 100644
--- a/fs/ocfs2/suballoc.c
+++ b/fs/ocfs2/suballoc.c
@@ -3070,7 +3070,20 @@ static int _ocfs2_free_suballoc_bits(handle_t *handle,
 	}
 	group = (struct ocfs2_group_desc *) group_bh->b_data;
 
-	BUG_ON((count + start_bit) > le16_to_cpu(group->bg_bits));
+	/*
+	 * Group descriptor validation only guarantees bg_bits within the
+	 * physical bitmap size, so double check the freeing range here.
+	 * Otherwise ocfs2_block_group_clear_bits() would clear bits beyond
+	 * bg_bitmap.
+	 */
+	if ((count + start_bit) > le16_to_cpu(group->bg_bits)) {
+		status = ocfs2_error(alloc_inode->i_sb,
+				     "Group descriptor #%llu has %u bits, cannot free bits %u+%u\n",
+				     (unsigned long long)le64_to_cpu(group->bg_blkno),
+				     le16_to_cpu(group->bg_bits),
+				     count, start_bit);
+		goto bail;
+	}
 
 	if (ocfs2_is_cluster_bitmap(alloc_inode))
 		old_bg_contig_free_bits = group->bg_contig_free_bits;
-- 
2.39.3

