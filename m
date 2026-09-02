Received: from out30-97.freemail.mail.aliyun.com (out30-97.freemail.mail.aliyun.com [115.124.30.97])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9A0B49482E
	for <ocfs2-devel@lists.linux.dev>; Wed,  2 Sep 2026 12:41:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.97
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788352882; cv=none; b=gJbGohBQXgXwOLNXB1xZC43iDxJ2CjIeLApB9M/73QbLIWE4ah1VVAWKkzBrNo434L/Gc0Zrh/Uj7EcMThp/o8SjIYsn0ehh3Qj1ksojbRuzVEf3IdNb4Mu+3YVGdm1x3zThUOIkUGiHg6iEIoDUzXDCA1lfqUmYREuTpN2fvA0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788352882; c=relaxed/simple;
	bh=KaPsbpcvVQswWwzAhO+0povn4bTp/xVzNTLdjwbsh8E=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=lczbCx+sfkt2N7rrXswBTgjFTKLbUSNcBz2vzdCHalyhETK+qzcl/M0hZnLSRHIngUxKWZmxxbd9VtKdvuLy0x9zPdOTQB4hgyGE1bN6cq4FcD9onLAu+c557bxXjVCF2NVfOcyb+w6xRjo+tM+c1gesoSEzbwwOrtfPr40M+/E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=ik/h+d1+; arc=none smtp.client-ip=115.124.30.97
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="ik/h+d1+"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1788352871; h=From:To:Subject:Date:Message-Id:MIME-Version;
	bh=IjSwswSbVJ59LUR4S1FB7rVUxhTmzFzHw6cz0sTJxRo=;
	b=ik/h+d1+zC0FjEgFsXep6iknJkixus7wdNP97QLnz4EobHhoAJHZKCrss5jcUpQYDiqDnTkvTna9yRt2Qp6MjFWUoQlY2J4HW3b4+IMBhnJ6q9c3a0LQbaQtI5Mhxu92IRfoZOcXhhZuq+VLWw5p14jx1CCTk1O8Z7mW3de6ynA=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R531e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033045133197;MF=joseph.qi@linux.alibaba.com;NM=1;PH=DS;RN=6;SR=0;TI=SMTPD_---0XACjwKa_1788352870;
Received: from localhost(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0XACjwKa_1788352870 cluster:ay36)
          by smtp.aliyun-inc.com;
          Wed, 02 Sep 2026 20:41:10 +0800
From: Joseph Qi <joseph.qi@linux.alibaba.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	Heming Zhao <heming.zhao@suse.com>
Cc: Mark Fasheh <mark@fasheh.com>,
	Joel Becker <jlbec@evilplan.org>,
	ocfs2-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: [PATCH] ocfs2: allow xattr bucket entries to span multiple blocks
Date: Wed,  2 Sep 2026 20:41:09 +0800
Message-Id: <20260902124109.27775-1-joseph.qi@linux.alibaba.com>
X-Mailer: git-send-email 2.39.3
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

Fixes: 2cf82b46d5e4 ("ocfs2: validate external xattr entries when reading metadata")
Signed-off-by: Joseph Qi <joseph.qi@linux.alibaba.com>
---
 fs/ocfs2/xattr.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/fs/ocfs2/xattr.c b/fs/ocfs2/xattr.c
index 34f102db2a0e..c73628484b50 100644
--- a/fs/ocfs2/xattr.c
+++ b/fs/ocfs2/xattr.c
@@ -1153,7 +1153,13 @@ static int ocfs2_validate_xattr_bucket(struct ocfs2_xattr_bucket *bucket,
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
-- 
2.39.3

