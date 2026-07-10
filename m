Received: from out30-130.freemail.mail.aliyun.com (out30-130.freemail.mail.aliyun.com [115.124.30.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB93B3C819A
	for <ocfs2-devel@lists.linux.dev>; Fri, 10 Jul 2026 07:18:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783667891; cv=none; b=g7i1sk8mxRMEq7NoH3r1VA2BvpFkJGU6LUa9yAxtyuRT7Jk3s7lpWYWPM9Bf8hD1RNcOo9OZwC0MphKlZ/X5TrDcVURjJBKWgsOsAPYfwiZ38V8xoPJ3z7HEJQp6CfSirkmKANwR8Rm+FuQLxnbXg+ImGTnKU8P/01xTea8OzP8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783667891; c=relaxed/simple;
	bh=czBy+eokThaEp9QTd0cTZBZbYYXULYcWtY4NMrW6wPc=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=Of+sh8m3eXuOc1cvUUEMxz1urfrPJGPkhYSL/+Dc51rN4Enc+HNUFHAZ4Zq/1eOeqU07uNzbC7aASQT7W9Etl5IagCa6Njg12LOz+ZGd6HOqKrwFT7P+kXIPC1R8ERS9wzHUG3hGOyY7rYGAm3Pqt9HNQBFTanXSV67OLIG8KLs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=ZJb8Q42i; arc=none smtp.client-ip=115.124.30.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="ZJb8Q42i"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1783667879; h=From:To:Subject:Date:Message-Id:MIME-Version;
	bh=CRAwQkwUF4M3FkCFqvYZhe3zoijsBR4m3xh1fk7XhHM=;
	b=ZJb8Q42is1Nfb2PvN1BxhT4YIjRL+NHV4tSskRHUVP8XGJTwd8jAYJZeOy8xpco4clqKrxRlVoHbD0ocbOAbTdjfN+oJDS8zEv5je1ra6+0FfMMrRrCIHFDptDCkl7X1s0R8TlXbZPX8lR+H3rGhZAcxMRTj6Mlxs8zF+BYRwHE=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R131e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037009110;MF=joseph.qi@linux.alibaba.com;NM=1;PH=DS;RN=6;SR=0;TI=SMTPD_---0X6mw3S4_1783667876;
Received: from localhost(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0X6mw3S4_1783667876 cluster:ay36)
          by smtp.aliyun-inc.com;
          Fri, 10 Jul 2026 15:17:57 +0800
From: Joseph Qi <joseph.qi@linux.alibaba.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	Heming Zhao <heming.zhao@suse.com>
Cc: Mark Fasheh <mark@fasheh.com>,
	Joel Becker <jlbec@evilplan.org>,
	ocfs2-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] ocfs2: cluster: use GFP_NOFS for heartbeat bio allocation
Date: Fri, 10 Jul 2026 15:17:55 +0800
Message-Id: <20260710071756.3586797-1-joseph.qi@linux.alibaba.com>
X-Mailer: git-send-email 2.39.3
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

o2hb_setup_one_bio() allocates the heartbeat bio with GFP_ATOMIC. The
disk heartbeat runs in the o2hb kernel thread (o2hb_do_disk_heartbeat),
which is process context and can sleep, so there is no atomicity
requirement here.

GFP_ATOMIC lacks __GFP_DIRECT_RECLAIM, so the allocation is not served
from the fs_bio_set mempool reserve and can return NULL under memory
pressure. A failed heartbeat allocation aborts the heartbeat and can
lead to the local node being fenced, which is exactly what the old
comment worried about.

Use GFP_NOFS instead. It keeps __GFP_DIRECT_RECLAIM so the allocation is
backed by the fs_bio_set mempool and cannot fail, while avoiding
recursion back into the filesystem during heartbeat I/O. As the
allocation can no longer fail, drop the dead ERR_PTR(-ENOMEM) path in
o2hb_setup_one_bio() and the now-redundant IS_ERR() handling in its
callers.

Signed-off-by: Joseph Qi <joseph.qi@linux.alibaba.com>
---
 fs/ocfs2/cluster/heartbeat.c | 41 +++++++-----------------------------
 1 file changed, 8 insertions(+), 33 deletions(-)

diff --git a/fs/ocfs2/cluster/heartbeat.c b/fs/ocfs2/cluster/heartbeat.c
index 6da96a374fcdf..ef6a11fdef5bc 100644
--- a/fs/ocfs2/cluster/heartbeat.c
+++ b/fs/ocfs2/cluster/heartbeat.c
@@ -522,16 +522,12 @@ static struct bio *o2hb_setup_one_bio(struct o2hb_region *reg,
 	struct bio *bio;
 	struct page *page;
 
-	/* Testing has shown this allocation to take long enough under
-	 * GFP_KERNEL that the local node can get fenced. It would be
-	 * nicest if we could pre-allocate these bios and avoid this
-	 * all together. */
-	bio = bio_alloc(reg_bdev(reg), 16, opf, GFP_ATOMIC);
-	if (!bio) {
-		mlog(ML_ERROR, "Could not alloc slots BIO!\n");
-		bio = ERR_PTR(-ENOMEM);
-		goto bail;
-	}
+	/*
+	 * The heartbeat runs in process context and can sleep, so use
+	 * GFP_NOFS. It is backed by the fs_bio_set mempool and thus cannot
+	 * fail, while avoiding recursion back into the filesystem.
+	 */
+	bio = bio_alloc(reg_bdev(reg), 16, opf, GFP_NOFS);
 
 	/* Must put everything in 512 byte sectors for the bio... */
 	bio->bi_iter.bi_sector = (reg->hr_start_block + cs) << (bits - 9);
@@ -556,7 +552,6 @@ static struct bio *o2hb_setup_one_bio(struct o2hb_region *reg,
 		vec_start = 0;
 	}
 
-bail:
 	*current_slot = cs;
 	return bio;
 }
@@ -566,7 +561,6 @@ static int o2hb_read_slots(struct o2hb_region *reg,
 			   unsigned int max_slots)
 {
 	unsigned int current_slot = begin_slot;
-	int status;
 	struct o2hb_bio_wait_ctxt wc;
 	struct bio *bio;
 
@@ -575,30 +569,18 @@ static int o2hb_read_slots(struct o2hb_region *reg,
 	while(current_slot < max_slots) {
 		bio = o2hb_setup_one_bio(reg, &wc, &current_slot, max_slots,
 					 REQ_OP_READ);
-		if (IS_ERR(bio)) {
-			status = PTR_ERR(bio);
-			mlog_errno(status);
-			goto bail_and_wait;
-		}
-
 		atomic_inc(&wc.wc_num_reqs);
 		submit_bio(bio);
 	}
 
-	status = 0;
-
-bail_and_wait:
 	o2hb_wait_on_io(&wc);
-	if (wc.wc_error && !status)
-		status = wc.wc_error;
 
-	return status;
+	return wc.wc_error;
 }
 
 static int o2hb_issue_node_write(struct o2hb_region *reg,
 				 struct o2hb_bio_wait_ctxt *write_wc)
 {
-	int status;
 	unsigned int slot;
 	struct bio *bio;
 
@@ -610,18 +592,11 @@ static int o2hb_issue_node_write(struct o2hb_region *reg,
 
 	bio = o2hb_setup_one_bio(reg, write_wc, &slot, slot+1,
 				 REQ_OP_WRITE | REQ_SYNC);
-	if (IS_ERR(bio)) {
-		status = PTR_ERR(bio);
-		mlog_errno(status);
-		goto bail;
-	}
 
 	atomic_inc(&write_wc->wc_num_reqs);
 	submit_bio(bio);
 
-	status = 0;
-bail:
-	return status;
+	return 0;
 }
 
 static u32 o2hb_compute_block_crc_le(struct o2hb_region *reg,
-- 
2.39.3

