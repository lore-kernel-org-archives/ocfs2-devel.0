Received: from out30-98.freemail.mail.aliyun.com (out30-98.freemail.mail.aliyun.com [115.124.30.98])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 737973B9DA5
	for <ocfs2-devel@lists.linux.dev>; Mon, 31 Aug 2026 06:34:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.98
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788158055; cv=none; b=GQoNo+5BS4wRLSPxgZRcP8i9TELiQ/p/YgAYmI27dR3LeAci4BoYF84HJzF/xBwVNsqDUJAWFNBzxfIcAzQULVFykGKfoKJkz0yXDhsxAephgQfTpG2AavubNpD+hlfqDdI+MRVG+YmpTIu1kVzDKRrFdY26QtujY31YZJyHXw8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788158055; c=relaxed/simple;
	bh=sz1qtavqVpjumr11ifp5nSRRLPo5NpbwtYYTBvJ5pJU=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=YVzwd+ddOsYTm5VP9/ucMaMRHv2q4miQHHlu7XuomR0mkntgYemovTPJgMIoV32HdMT6TwdYNjxP0BK/cu3EF1IvzVzybHrZIViRWDDJiIAh7UnIvfOShaTPAPu9WFJrG9PMUkkTKLvz5y7g5oVL0ZjXvVGt7zyjkCqhYVEPn+g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=KpIaqz0F; arc=none smtp.client-ip=115.124.30.98
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="KpIaqz0F"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1788158051; h=From:To:Subject:Date:Message-Id:MIME-Version;
	bh=+3WI6Z3MQlNOMD6y8+KdeslGPCDGj3g1sR9InW0B9K8=;
	b=KpIaqz0FZlGDfqT0t3+pkOjafBmqAebWcOnv7qok3N5S8doChGMLsjbVLHi1tBWtjRVvhWTuApB39V/JzHcg7uRGKd+Ouvap7rzlTZ/gAW+ykOWeRyNgI66B3wCVsZGmm+pUT3fN1/zfYYEc2LfbNnodyX/oSk84+8e+wUERm7c=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R111e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037033178;MF=joseph.qi@linux.alibaba.com;NM=1;PH=DS;RN=6;SR=0;TI=SMTPD_---0X9tzGq5_1788157732;
Received: from localhost(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0X9tzGq5_1788157732 cluster:ay36)
          by smtp.aliyun-inc.com;
          Mon, 31 Aug 2026 14:28:53 +0800
From: Joseph Qi <joseph.qi@linux.alibaba.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	Heming Zhao <heming.zhao@suse.com>
Cc: Mark Fasheh <mark@fasheh.com>,
	Joel Becker <jlbec@evilplan.org>,
	ocfs2-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: [PATCH 4/4] ocfs2: validate suballoc slot of extent blocks
Date: Mon, 31 Aug 2026 14:28:48 +0800
Message-Id: <20260831062848.2743436-5-joseph.qi@linux.alibaba.com>
X-Mailer: git-send-email 2.39.3
In-Reply-To: <20260831062848.2743436-1-joseph.qi@linux.alibaba.com>
References: <20260831062848.2743436-1-joseph.qi@linux.alibaba.com>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

ocfs2_validate_extent_block() does not validate h_suballoc_slot against
the mounted filesystem's slot range.  Since extent blocks are allocated
from a per-slot suballocator at runtime, their suballoc slot must be
within range.

Otherwise a corrupted image can carry an out-of-range slot.  When the
extent block is freed, ocfs2_cache_extent_block_free() caches it and
ocfs2_free_cached_blocks() later passes the unvalidated slot to
ocfs2_get_system_file_inode(), so get_local_system_inode() will either
hit BUG_ON(slot == OCFS2_INVALID_SLOT) or compute an out-of-bounds
index into the local_system_inodes array.

Reject out-of-range suballoc slots during validation.

Signed-off-by: Joseph Qi <joseph.qi@linux.alibaba.com>
---
 fs/ocfs2/alloc.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/fs/ocfs2/alloc.c b/fs/ocfs2/alloc.c
index be09e766ac1f..2abd242a438f 100644
--- a/fs/ocfs2/alloc.c
+++ b/fs/ocfs2/alloc.c
@@ -925,6 +925,20 @@ static int ocfs2_validate_extent_block(struct super_block *sb,
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
 	if (le16_to_cpu(eb->h_list.l_count) != ocfs2_extent_recs_per_eb(sb)) {
 		rc = ocfs2_error(sb,
 				 "Extent block #%llu has invalid l_count %u (expected %u)\n",
-- 
2.39.3

