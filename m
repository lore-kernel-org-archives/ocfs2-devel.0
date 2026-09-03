Received: from out30-97.freemail.mail.aliyun.com (out30-97.freemail.mail.aliyun.com [115.124.30.97])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B05BE4A841C
	for <ocfs2-devel@lists.linux.dev>; Thu,  3 Sep 2026 13:13:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.97
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788441235; cv=none; b=pTKcKBRp1f82VTHp3zur4eV9Rukk8zEOEZPnltNVWEFXA6JIdjPrPn/PVr2/vLHHnkVQTBaIc7MrylOM2UgxLFwXoxl/aw1Yc8sBIF3FjUMu3zbUVIF2Qmlr4xYGNmHVFpmvqsReXIx3PXf3E3aW7uLt8WF2yWleAzCmcQEDWUQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788441235; c=relaxed/simple;
	bh=PW1aEYp2EBCpok59cbahHhJPmxsO3WMcbauEQwC+1uU=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=TEt9XIgwj9INaJ5fgCKTsw4FxmOyoDcNzdnl/o67emNb0ETviuoiHykJhG9d6gjpfEs4TFbDUuyiZWjvX7g+sEeC/COO3ngwHAY1Ta4OgejZ0Y2GrDEemjtb8T8SYBDMxrgpIuRObXzyUId5IPI5gjZboI4XuSWcqinog9gXtPw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=kJecAw9C; arc=none smtp.client-ip=115.124.30.97
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="kJecAw9C"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1788441196; h=From:To:Subject:Date:Message-Id:MIME-Version;
	bh=cqWubPGEU/FPOPqgpAtMLiOUZDsKRRTnlyUd+Vcv6eA=;
	b=kJecAw9CuNNbki9n+DzVfkfX2KQpvcRuMpoLamS4oW5zd9qXyiMncgQoLVlYJPgY/jhe4kBbll1rhpWSG0GtFJ5x5Y8GVmBzWWhLYoaeoTAzEaYOGELHtGV9oc2vO78gYz83gLmnYs+cDEA0A5BDzcpe9zZGrUuHXehcFy/Gk9E=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R511e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033045098064;MF=joseph.qi@linux.alibaba.com;NM=1;PH=DS;RN=6;SR=0;TI=SMTPD_---0XAG3g6q_1788441194;
Received: from localhost(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0XAG3g6q_1788441194 cluster:ay36)
          by smtp.aliyun-inc.com;
          Thu, 03 Sep 2026 21:13:15 +0800
From: Joseph Qi <joseph.qi@linux.alibaba.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	Heming Zhao <heming.zhao@suse.com>
Cc: Mark Fasheh <mark@fasheh.com>,
	Joel Becker <jlbec@evilplan.org>,
	ocfs2-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2 1/2] ocfs2: allow xattr bucket entries to span multiple blocks
Date: Thu,  3 Sep 2026 21:13:12 +0800
Message-Id: <20260903131313.2396208-2-joseph.qi@linux.alibaba.com>
X-Mailer: git-send-email 2.39.3
In-Reply-To: <20260903131313.2396208-1-joseph.qi@linux.alibaba.com>
References: <20260902124109.27775-1-joseph.qi@linux.alibaba.com>
 <20260903131313.2396208-1-joseph.qi@linux.alibaba.com>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

ocfs2_validate_xattr_bucket() limits the entry array to the first
bucket block, but the write path stores entries across the whole
OCFS2_XATTR_BUCKET_SIZE region.  With 512-byte blocks a bucket spans
eight blocks, and a bucket filled with small xattrs places its last
entries past offset 512.  Reading such a bucket back errors out:

  OCFS2: ERROR (device loop0): ocfs2_validate_xattr_bucket: Invalid xattr bucket 86072: entry count 32 exceeds maximum 31
  On-disk corruption discovered. Please run fsck.ocfs2 once the filesystem is unmounted.
  OCFS2: File system is now read-only.

This is reproducible by setting ~33 xattrs with 100-byte values on a
file on a blocksize-512 volume; fsck.ocfs2 reports the resulting
image clean.

Check the entry count against the full bucket region instead.  The
per-block bounds checks for names and values stay as they are, since
ocfs2_bucket_align_free_start() keeps each name+value pair within a
single block.

The entry array is one contiguous region, so a bucket from a corrupted
xattr tree whose first block is not aligned to OCFS2_XATTR_BUCKET_SIZE
could straddle a page and make the validation loop read out of bounds.
Buckets allocated within clusters are always aligned, so reject any
other block number while validating.

Fixes: 2cf82b46d5e4 ("ocfs2: validate external xattr entries when reading metadata")
Signed-off-by: Joseph Qi <joseph.qi@linux.alibaba.com>
---
 fs/ocfs2/xattr.c | 21 ++++++++++++++++++++-
 1 file changed, 20 insertions(+), 1 deletion(-)

diff --git a/fs/ocfs2/xattr.c b/fs/ocfs2/xattr.c
index 34f102db2a0e..c71fa7983b73 100644
--- a/fs/ocfs2/xattr.c
+++ b/fs/ocfs2/xattr.c
@@ -1153,11 +1153,30 @@ static int ocfs2_validate_xattr_bucket(struct ocfs2_xattr_bucket *bucket,
 	struct ocfs2_xattr_header *xh = bucket_xh(bucket);
 	u16 xattr_count = le16_to_cpu(xh->xh_count);
 	size_t region_size = (size_t)sb->s_blocksize * bucket->bu_blocks;
-	size_t entries_limit = sb->s_blocksize;
+	/*
+	 * The entry array grows up from the header across the whole
+	 * bucket region, so it may extend beyond the first bucket block
+	 * when the blocksize is smaller than OCFS2_XATTR_BUCKET_SIZE.
+	 * Name/value pairs, however, always live within a single block.
+	 */
+	size_t entries_limit = region_size;
 	size_t nv_limit = sb->s_blocksize;
 	size_t max_entries;
 	int i, ret;
 
+	/*
+	 * The entry array is one contiguous region that may span the
+	 * bucket's buffer_heads.  Buckets are allocated within clusters,
+	 * so their first block is always aligned to
+	 * OCFS2_XATTR_BUCKET_SIZE and the whole bucket fits in one page.
+	 * A corrupted xattr tree can point a bucket at blocks straddling
+	 * a page, so reject it before touching the entry array.
+	 */
+	if (blkno & (bucket->bu_blocks - 1))
+		return ocfs2_error(sb,
+				   "Invalid xattr bucket %llu: unaligned block number\n",
+				   (unsigned long long)blkno);
+
 	if (region_size < sizeof(*xh))
 		return ocfs2_error(sb,
 				   "Invalid xattr bucket %llu: region size %zu is too small\n",
-- 
2.39.3

