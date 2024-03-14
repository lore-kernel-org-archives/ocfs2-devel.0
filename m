Received: from out30-131.freemail.mail.aliyun.com (out30-131.freemail.mail.aliyun.com [115.124.30.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6782F610B
	for <ocfs2-devel@lists.linux.dev>; Thu, 14 Mar 2024 02:17:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710382646; cv=none; b=IFgvD5QyuBGbm8P0trvcFwG02A0yRWCLm/yNRHlPp6x2DSi2av6+/+VrCt9lK5eNSxXxr1ZqWvFZHRoCBOdIl4U4upcr5zjjpFEIYsrio1qS+AFzSE67B09UyaVInxiZB590e41AzqSB5riHum0/MeFeHoyqcCwlbSdEqtaejIc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710382646; c=relaxed/simple;
	bh=JRryJf1Piro+jJ6Z6etQCq8qhV5fBTKG6O/q478MeW0=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=ke/DaiiqNZjAaZS3hi/dY5CJ2lFV7VxtoRxjL+GnZyJTtop8OJ5KySjyVPrt+nJZ0vYMKjAFZP+OeOusRaQsJGuKrnaMzt/OfPyif2stGVHvOM1gZTFv30wwevYn8iPbBYqf9YwOojYLg5Q6+xznqCyVBVEdJYyxgujpi9FlYTc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=D95l+7hd; arc=none smtp.client-ip=115.124.30.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="D95l+7hd"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1710382635; h=From:To:Subject:Date:Message-Id:MIME-Version;
	bh=mrJfJYfIa2eTrlhCitDfDspSqJl4KQJVhtNTo16c30E=;
	b=D95l+7hdL3dXEIh1RhFTDl2qQdXfHfhxMceELb2wshLZzthxgE/tcygvPYiq1TfndkKLPPWCh8dKyK6bBrM/BKN+UvshrdKNIp9NuZmMqVt+1FtEmJpzq0tBZJOFbplB/8ooKBffq+V6+qBoW57r/dZQ8hBWCfLX3tZqqydcVw8=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R491e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018046051;MF=joseph.qi@linux.alibaba.com;NM=1;PH=DS;RN=3;SR=0;TI=SMTPD_---0W2QaTja_1710382633;
Received: from localhost(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0W2QaTja_1710382633)
          by smtp.aliyun-inc.com;
          Thu, 14 Mar 2024 10:17:14 +0800
From: Joseph Qi <joseph.qi@linux.alibaba.com>
To: ocfs2-devel@lists.linux.dev
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Heming Zhao <heming.zhao@suse.com>
Subject: [PATCH] ocfs2: correctly use ocfs2_find_next_zero_bit()
Date: Thu, 14 Mar 2024 10:17:13 +0800
Message-Id: <20240314021713.240796-1-joseph.qi@linux.alibaba.com>
X-Mailer: git-send-email 2.24.4
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

If no bits are zero, ocfs2_find_next_zero_bit() will return max size, so
check the return value with -1 is meaningless.
Correct this usage and cleanup the code.

Signed-off-by: Joseph Qi <joseph.qi@linux.alibaba.com>
---
 fs/ocfs2/localalloc.c   | 19 ++++++-------------
 fs/ocfs2/reservations.c |  2 +-
 fs/ocfs2/suballoc.c     |  6 ++----
 3 files changed, 9 insertions(+), 18 deletions(-)

diff --git a/fs/ocfs2/localalloc.c b/fs/ocfs2/localalloc.c
index c803c10dd97e..33aeaaa056d7 100644
--- a/fs/ocfs2/localalloc.c
+++ b/fs/ocfs2/localalloc.c
@@ -863,14 +863,8 @@ static int ocfs2_local_alloc_find_clear_bits(struct ocfs2_super *osb,
 
 	numfound = bitoff = startoff = 0;
 	left = le32_to_cpu(alloc->id1.bitmap1.i_total);
-	while ((bitoff = ocfs2_find_next_zero_bit(bitmap, left, startoff)) != -1) {
-		if (bitoff == left) {
-			/* mlog(0, "bitoff (%d) == left", bitoff); */
-			break;
-		}
-		/* mlog(0, "Found a zero: bitoff = %d, startoff = %d, "
-		   "numfound = %d\n", bitoff, startoff, numfound);*/
-
+	while ((bitoff = ocfs2_find_next_zero_bit(bitmap, left, startoff)) <
+	       left) {
 		/* Ok, we found a zero bit... is it contig. or do we
 		 * start over?*/
 		if (bitoff == startoff) {
@@ -976,9 +970,9 @@ static int ocfs2_sync_local_to_main(struct ocfs2_super *osb,
 	start = count = 0;
 	left = le32_to_cpu(alloc->id1.bitmap1.i_total);
 
-	while ((bit_off = ocfs2_find_next_zero_bit(bitmap, left, start))
-	       != -1) {
-		if ((bit_off < left) && (bit_off == start)) {
+	while ((bit_off = ocfs2_find_next_zero_bit(bitmap, left, start)) <
+	       left) {
+		if (bit_off == start) {
 			count++;
 			start++;
 			continue;
@@ -1002,8 +996,7 @@ static int ocfs2_sync_local_to_main(struct ocfs2_super *osb,
 				goto bail;
 			}
 		}
-		if (bit_off >= left)
-			break;
+
 		count = 1;
 		start = bit_off + 1;
 	}
diff --git a/fs/ocfs2/reservations.c b/fs/ocfs2/reservations.c
index a9d1296d736d..1fe61974d9f0 100644
--- a/fs/ocfs2/reservations.c
+++ b/fs/ocfs2/reservations.c
@@ -414,7 +414,7 @@ static int ocfs2_resmap_find_free_bits(struct ocfs2_reservation_map *resmap,
 
 	start = search_start;
 	while ((offset = ocfs2_find_next_zero_bit(bitmap, resmap->m_bitmap_len,
-						 start)) != -1) {
+					start)) < resmap->m_bitmap_len) {
 		/* Search reached end of the region */
 		if (offset >= (search_start + search_len))
 			break;
diff --git a/fs/ocfs2/suballoc.c b/fs/ocfs2/suballoc.c
index 166c8918c825..961998415308 100644
--- a/fs/ocfs2/suballoc.c
+++ b/fs/ocfs2/suballoc.c
@@ -1290,10 +1290,8 @@ static int ocfs2_block_group_find_clear_bits(struct ocfs2_super *osb,
 	found = start = best_offset = best_size = 0;
 	bitmap = bg->bg_bitmap;
 
-	while((offset = ocfs2_find_next_zero_bit(bitmap, total_bits, start)) != -1) {
-		if (offset == total_bits)
-			break;
-
+	while ((offset = ocfs2_find_next_zero_bit(bitmap, total_bits, start)) <
+	       total_bits) {
 		if (!ocfs2_test_bg_bit_allocatable(bg_bh, offset)) {
 			/* We found a zero, but we can't use it as it
 			 * hasn't been put to disk yet! */
-- 
2.24.4

