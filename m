Received: from out30-130.freemail.mail.aliyun.com (out30-130.freemail.mail.aliyun.com [115.124.30.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F13A3C8713
	for <ocfs2-devel@lists.linux.dev>; Fri, 10 Jul 2026 07:18:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783667891; cv=none; b=l6IpUpBw3ew8IpeGTonW+Hx8RxePv8MvFv3/p+7jel0duqEG5AnuyRMqR7xzDoQofkLlvorsTry8T1YyAPcP3sZlkv6+ns5b79+1u+ij/QfjTnCRWGvzrxNK60Lnhme0nynDAu6A94I16Pr1y3LKmmgHTMejc2rAI9lwV/7oAvo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783667891; c=relaxed/simple;
	bh=VWHxZJU0UBU8YBSf510Wngm6TcX/dXC47IaRgHaQM+Q=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=oW3sBRH72V/o8y8SqS3wmFho+8Vdzuj6ewE5ShSmwMf276JCbz1mXJjUYx1LUg1S+yL8Tab2Y2dAuF8YEUSF0AjRaBCgcTEpc9fSldi1CttcypIm3/DJ1xITf33iA+QF1wfJZCn03OCm3/y3wFW/9uZRK+WGr9m2raQJGghFLrI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=T8Q6Hma4; arc=none smtp.client-ip=115.124.30.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="T8Q6Hma4"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1783667878; h=From:To:Subject:Date:Message-Id:MIME-Version;
	bh=l+/1AlQxT+eGSiNTg18UlILemhwbKI0QjnQSq/jauL0=;
	b=T8Q6Hma4T5z+Ogo532b2wSQILyNMp1r5XlCkxt6LmyT2ze6LlrrB7WbexS3Vd/d+ALAdYgaWsoqkPL8kwqRQ8zL0MxbQRtIRegTFbc/IYvcSBHu43PV7rd5bq1Ub9Po0Ohtv/et9ALaNp8+WgCWaQigwJpm1yZQoaKWgnQGbWL4=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R181e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037033178;MF=joseph.qi@linux.alibaba.com;NM=1;PH=DS;RN=6;SR=0;TI=SMTPD_---0X6mt6CH_1783667877;
Received: from localhost(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0X6mt6CH_1783667877 cluster:ay36)
          by smtp.aliyun-inc.com;
          Fri, 10 Jul 2026 15:17:58 +0800
From: Joseph Qi <joseph.qi@linux.alibaba.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	Heming Zhao <heming.zhao@suse.com>
Cc: Mark Fasheh <mark@fasheh.com>,
	Joel Becker <jlbec@evilplan.org>,
	ocfs2-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] ocfs2: cluster: use an on-stack bio for the heartbeat write
Date: Fri, 10 Jul 2026 15:17:56 +0800
Message-Id: <20260710071756.3586797-2-joseph.qi@linux.alibaba.com>
X-Mailer: git-send-email 2.39.3
In-Reply-To: <20260710071756.3586797-1-joseph.qi@linux.alibaba.com>
References: <20260710071756.3586797-1-joseph.qi@linux.alibaba.com>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The disk heartbeat write always covers this node's own single slot, i.e.
one heartbeat block that lives within a single page. It is submitted by
o2hb_issue_node_write() and waited on by the caller before the ctxt goes
out of scope, so its lifetime is well bounded.

Turn it into an on-stack bio embedded in struct o2hb_bio_wait_ctxt rather
than allocating one from the mempool. This removes any allocation from
the fence-critical write path entirely: a delayed or blocked heartbeat
write is what leads to the local node being fenced, so it should not
depend on the state of a shared bio pool.

Because the bio is embedded rather than allocated, add a dedicated
o2hb_write_bio_end_io() that does not call bio_put(), and tear the bio
down with bio_uninit() once the caller has waited on the I/O.

The read path still allocates via o2hb_setup_one_bio() with GFP_NOFS,
since it issues a variable number of bios in a loop.

Signed-off-by: Joseph Qi <joseph.qi@linux.alibaba.com>
---
 fs/ocfs2/cluster/heartbeat.c | 50 ++++++++++++++++++++++++++++++++----
 1 file changed, 45 insertions(+), 5 deletions(-)

diff --git a/fs/ocfs2/cluster/heartbeat.c b/fs/ocfs2/cluster/heartbeat.c
index ef6a11fdef5bc..29542edbc992c 100644
--- a/fs/ocfs2/cluster/heartbeat.c
+++ b/fs/ocfs2/cluster/heartbeat.c
@@ -272,6 +272,9 @@ struct o2hb_bio_wait_ctxt {
 	atomic_t          wc_num_reqs;
 	struct completion wc_io_complete;
 	int               wc_error;
+	/* On-stack bio used by the synchronous write path only. */
+	struct bio        wc_write_bio;
+	struct bio_vec    wc_write_bvec;
 };
 
 #define O2HB_NEGO_TIMEOUT_MS (O2HB_MAX_WRITE_TIMEOUT_MS/2)
@@ -507,6 +510,23 @@ static void o2hb_bio_end_io(struct bio *bio)
 	bio_put(bio);
 }
 
+/*
+ * End I/O for the synchronous write path. The write bio is embedded in
+ * the wait ctxt rather than allocated, so it must not be freed here; it
+ * is torn down with bio_uninit() once the caller has waited on it.
+ */
+static void o2hb_write_bio_end_io(struct bio *bio)
+{
+	struct o2hb_bio_wait_ctxt *wc = bio->bi_private;
+
+	if (bio->bi_status) {
+		mlog(ML_ERROR, "IO Error %d\n", bio->bi_status);
+		wc->wc_error = blk_status_to_errno(bio->bi_status);
+	}
+
+	o2hb_bio_wait_dec(wc, 1);
+}
+
 /* Setup a Bio to cover I/O against num_slots slots starting at
  * start_slot. */
 static struct bio *o2hb_setup_one_bio(struct o2hb_region *reg,
@@ -582,7 +602,11 @@ static int o2hb_issue_node_write(struct o2hb_region *reg,
 				 struct o2hb_bio_wait_ctxt *write_wc)
 {
 	unsigned int slot;
-	struct bio *bio;
+	unsigned int bits = reg->hr_block_bits;
+	unsigned int spp = reg->hr_slots_per_page;
+	unsigned int vec_start, vec_len;
+	struct page *page;
+	struct bio *bio = &write_wc->wc_write_bio;
 
 	o2hb_bio_wait_init(write_wc);
 
@@ -590,8 +614,21 @@ static int o2hb_issue_node_write(struct o2hb_region *reg,
 	if (slot >= O2NM_MAX_NODES)
 		return -EINVAL;
 
-	bio = o2hb_setup_one_bio(reg, write_wc, &slot, slot+1,
-				 REQ_OP_WRITE | REQ_SYNC);
+	/*
+	 * The heartbeat write always covers our own single slot, i.e. one
+	 * block that lives within a single page. Use an on-stack bio (embedded
+	 * in write_wc) so this fence-critical path never has to allocate.
+	 */
+	bio_init(bio, reg_bdev(reg), &write_wc->wc_write_bvec, 1,
+		 REQ_OP_WRITE | REQ_SYNC);
+	bio->bi_iter.bi_sector = (reg->hr_start_block + slot) << (bits - 9);
+	bio->bi_private = write_wc;
+	bio->bi_end_io = o2hb_write_bio_end_io;
+
+	page = reg->hr_slot_data[slot / spp];
+	vec_start = (slot << bits) % PAGE_SIZE;
+	vec_len = PAGE_SIZE / spp;
+	__bio_add_page(bio, page, vec_len, vec_start);
 
 	atomic_inc(&write_wc->wc_num_reqs);
 	submit_bio(bio);
@@ -1133,6 +1170,7 @@ static int o2hb_do_disk_heartbeat(struct o2hb_region *reg)
 	 * people we find in our steady state have seen us.
 	 */
 	o2hb_wait_on_io(&write_wc);
+	bio_uninit(&write_wc.wc_write_bio);
 	if (write_wc.wc_error) {
 		/* Do not re-arm the write timeout on I/O error - we
 		 * can't be sure that the new block ever made it to
@@ -1245,10 +1283,12 @@ static int o2hb_thread(void *data)
 	if (!reg->hr_unclean_stop && !reg->hr_aborted_start) {
 		o2hb_prepare_block(reg, 0);
 		ret = o2hb_issue_node_write(reg, &write_wc);
-		if (ret == 0)
+		if (ret == 0) {
 			o2hb_wait_on_io(&write_wc);
-		else
+			bio_uninit(&write_wc.wc_write_bio);
+		} else {
 			mlog_errno(ret);
+		}
 	}
 
 	/* Unpin node */
-- 
2.39.3

