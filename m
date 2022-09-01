Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc250.phx1.oracleemaildelivery.com (aib29ajc250.phx1.oracleemaildelivery.com [192.29.103.250])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 90561C0502C
	for <ocfs2-devel@archiver.kernel.org>; Thu,  1 Sep 2022 13:24:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=boVy8TY9FW4BKLBxuNuoZRnxXXdUjWOqYsm5wJUWR9s=;
 b=EPPZ8q7j232S5vRfLL8KldxLU1dF7HurpcDYTNfUHebaO0UC7QbYOnXuzlycCHm24rFmcwI8nI2E
   rgJtJeH7AY44Ba4WTO9F/y9LDUWhWScDzGYc+jm37PWfLVtcsVnwQuy9iKl0lGw2y0AAU1InBmT4
   dqv+r7VdfZXMi1CFvbiSs/2q6aOcjTsJJ23FQO41OTrrPtzUwLCPCUPgcdDspBOAbX1vLTG8TxeJ
   HRrFWNKXrXiMK2l7HMJ5LclGV3h3pmre6EWzJgSnlwpGTO7TKDUaumnhbETxcPwLhAr5eGmSB2HV
   nlmbe98xQtJ2JpQU0BmEK79PVo2w1xnfF7mB/g==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=boVy8TY9FW4BKLBxuNuoZRnxXXdUjWOqYsm5wJUWR9s=;
 b=U6dyjXXaWRQnfE5fKE9DIsCrxTSWFZnKnsBabpuRZWxmVz3coSMD8lYfV4JIGveRdpqv9KbyxIYl
   FEil5kTkfRofApl35wDz/TudeB+iFoNS2BLbHfIWHIPnPIIWy9iL3BvGJ3dpAGPFOWFo2UPRZK7J
   93mK4BmLl0IKguUtogBIpDORKZU114qysmFFJPx2+srOk95O6n6W4szLOkyFezRhNaFLbyp7V5cd
   vFoJCOz0PfcIES7mGOmlkWjYv+DVZtvOJCRznKiRrzCPynB55BDdh/le9aD/GetGNrdrrK9oSPS+
   KGEu8dCoWshkwb4FHXHsMvtC7G9bZKjm1+mvJQ==
Received: by omta-ad2-fd3-201-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20220817 64bit (built Aug 17
 2022))
 with ESMTPS id <0RHJ00KVY98WOB90@omta-ad2-fd3-201-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Thu, 01 Sep 2022 13:24:34 +0000 (GMT)
To: <linux-ext4@vger.kernel.org>, <linux-fsdevel@vger.kernel.org>,
 <linux-kernel@vger.kernel.org>, <cluster-devel@redhat.com>,
 <ntfs3@lists.linux.dev>, <ocfs2-devel@oss.oracle.com>,
 <reiserfs-devel@vger.kernel.org>, <jack@suse.cz>
Date: Thu, 1 Sep 2022 21:35:03 +0800
Message-id: <20220901133505.2510834-13-yi.zhang@huawei.com>
X-Mailer: git-send-email 2.31.1
In-reply-to: <20220901133505.2510834-1-yi.zhang@huawei.com>
References: <20220901133505.2510834-1-yi.zhang@huawei.com>
MIME-version: 1.0
X-Originating-IP: [10.175.127.227]
X-Source-IP: 45.249.212.255
X-Proofpoint-Virus-Version: vendor=nai engine=6400 definitions=10457
 signatures=596816
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 clxscore=138
 priorityscore=244 lowpriorityscore=0 adultscore=0 spamscore=0 impostorscore=0
 mlxscore=0 phishscore=0 mlxlogscore=910 suspectscore=0 malwarescore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2207270000 definitions=main-2209010060 domainage_hfrom=8269
Cc: axboe@kernel.dk, hch@infradead.org, tytso@mit.edu, agruenba@redhat.com,
 yi.zhang@huawei.com, almaz.alexandrovich@paragon-software.com,
 viro@zeniv.linux.org.uk, yukuai3@huawei.com, rpeterso@redhat.com,
 dushistov@mail.ru, chengzhihao1@huawei.com
Subject: [Ocfs2-devel] [PATCH v2 12/14] fs/buffer: remove ll_rw_block()	helper
X-BeenThere: ocfs2-devel@oss.oracle.com
X-Mailman-Version: 2.1.15
Precedence: list
List-Id: <ocfs2-devel.oss.oracle.com>
List-Unsubscribe: <https://oss.oracle.com/mailman/options/ocfs2-devel>,
 <mailto:ocfs2-devel-request@oss.oracle.com?subject=unsubscribe>
List-Archive: <http://oss.oracle.com/pipermail/ocfs2-devel/>
List-Post: <mailto:ocfs2-devel@oss.oracle.com>
List-Help: <mailto:ocfs2-devel-request@oss.oracle.com?subject=help>
List-Subscribe: <https://oss.oracle.com/mailman/listinfo/ocfs2-devel>,
 <mailto:ocfs2-devel-request@oss.oracle.com?subject=subscribe>
From: Zhang Yi via Ocfs2-devel <ocfs2-devel@oss.oracle.com>
Reply-to: Zhang Yi <yi.zhang@huawei.com>
Content-type: text/plain; charset="us-ascii"
Content-transfer-encoding: 7bit
Errors-to: ocfs2-devel-bounces@oss.oracle.com
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 canpemm500005.china.huawei.com (7.192.104.229)
X-CFilter-Loop: Reflected
X-ServerName: szxga08-in.huawei.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 ip4:45.249.212.32 ip4:45.249.212.35
 ip4:45.249.212.255 ip4:45.249.212.187/29 ip4:45.249.212.191 ip4:168.195.93.47
 ip4:185.176.79.56 ip4:119.8.179.247 ip4:119.8.89.136/31 ip4:119.8.89.135
 ip4:119.8.177.36/31 ip4:119.8.177.38 -all
X-Spam: Clean
X-Proofpoint-ORIG-GUID: yobtq7M516eOYZ9rhL9pPz0uMLvtfjnf
X-Proofpoint-GUID: yobtq7M516eOYZ9rhL9pPz0uMLvtfjnf
Reporting-Meta:
 AAHz86uIGYaCXzeJ64tcaSWcdP6CcNW1SXJyYWEpRFqt/Hw15iqb2HDsCZa5aXWC
 slMVf8xFytDvzQAgeJaQ31lro7gqF9YfqFk6c1YgwsR3AOGnWCCgfdhjFbkQMutj
 5Mk/9Wd/PNMQ+VaJ2HvfsX36sAzJd2daGLVghXy0uu5YNLbQegX3+htwIvVTtZ0I
 aAncLK3V3baWCzub9BBotBGjqh61n7AB4NXigr1YJXQ4Qs7ExftG3y6U3D3SRqEB
 etgMz+wkqtUQflmEE7shodVKSvDktlUhh6AAF/JyY9erVmPlHfyoY+wBMlp5X5gg
 Evs1TPHQ2dF/Rg1QRAPsEMssk7mvRy2Q/wlYLc1XBrBlSxBCYGwMZYwmXMfDF0xh
 O3RWoubipZs+wXabkgnSaQM1fysh+QLla8psCGTd5xUpcZDzxsJ8ADyVRrX5sXnF
 VNiwxPETEW3lbtG+0ZF+Kt5coR078DwRC3Lscvz2tZn6lHpnhvXtpJaP4SKjVyHV
 s7m5aa0135LM0iAj53WVyyRX5rGt80kAlqg4WdAMzwrz

Now that all ll_rw_block() users has been replaced to new safe helpers,
we just remove it here.

Signed-off-by: Zhang Yi <yi.zhang@huawei.com>
Reviewed-by: Jan Kara <jack@suse.cz>
---
 fs/buffer.c                 | 63 +++----------------------------------
 include/linux/buffer_head.h |  1 -
 2 files changed, 4 insertions(+), 60 deletions(-)

diff --git a/fs/buffer.c b/fs/buffer.c
index aec568b3ae52..2cccc7586b99 100644
--- a/fs/buffer.c
+++ b/fs/buffer.c
@@ -152,7 +152,7 @@ static void __end_buffer_read_notouch(struct buffer_head *bh, int uptodate)
 
 /*
  * Default synchronous end-of-IO handler..  Just mark it up-to-date and
- * unlock the buffer. This is what ll_rw_block uses too.
+ * unlock the buffer.
  */
 void end_buffer_read_sync(struct buffer_head *bh, int uptodate)
 {
@@ -491,8 +491,8 @@ int inode_has_buffers(struct inode *inode)
  * all already-submitted IO to complete, but does not queue any new
  * writes to the disk.
  *
- * To do O_SYNC writes, just queue the buffer writes with ll_rw_block as
- * you dirty the buffers, and then use osync_inode_buffers to wait for
+ * To do O_SYNC writes, just queue the buffer writes with write_dirty_buffer
+ * as you dirty the buffers, and then use osync_inode_buffers to wait for
  * completion.  Any other dirty buffers which are not yet queued for
  * write will not be flushed to disk by the osync.
  */
@@ -1806,7 +1806,7 @@ int __block_write_full_page(struct inode *inode, struct page *page,
 		/*
 		 * The page was marked dirty, but the buffers were
 		 * clean.  Someone wrote them back by hand with
-		 * ll_rw_block/submit_bh.  A rare case.
+		 * write_dirty_buffer/submit_bh.  A rare case.
 		 */
 		end_page_writeback(page);
 
@@ -2713,61 +2713,6 @@ int submit_bh(blk_opf_t opf, struct buffer_head *bh)
 }
 EXPORT_SYMBOL(submit_bh);
 
-/**
- * ll_rw_block: low-level access to block devices (DEPRECATED)
- * @opf: block layer request operation and flags.
- * @nr: number of &struct buffer_heads in the array
- * @bhs: array of pointers to &struct buffer_head
- *
- * ll_rw_block() takes an array of pointers to &struct buffer_heads, and
- * requests an I/O operation on them, either a %REQ_OP_READ or a %REQ_OP_WRITE.
- * @opf contains flags modifying the detailed I/O behavior, most notably
- * %REQ_RAHEAD.
- *
- * This function drops any buffer that it cannot get a lock on (with the
- * BH_Lock state bit), any buffer that appears to be clean when doing a write
- * request, and any buffer that appears to be up-to-date when doing read
- * request.  Further it marks as clean buffers that are processed for
- * writing (the buffer cache won't assume that they are actually clean
- * until the buffer gets unlocked).
- *
- * ll_rw_block sets b_end_io to simple completion handler that marks
- * the buffer up-to-date (if appropriate), unlocks the buffer and wakes
- * any waiters. 
- *
- * All of the buffers must be for the same device, and must also be a
- * multiple of the current approved size for the device.
- */
-void ll_rw_block(const blk_opf_t opf, int nr, struct buffer_head *bhs[])
-{
-	const enum req_op op = opf & REQ_OP_MASK;
-	int i;
-
-	for (i = 0; i < nr; i++) {
-		struct buffer_head *bh = bhs[i];
-
-		if (!trylock_buffer(bh))
-			continue;
-		if (op == REQ_OP_WRITE) {
-			if (test_clear_buffer_dirty(bh)) {
-				bh->b_end_io = end_buffer_write_sync;
-				get_bh(bh);
-				submit_bh(opf, bh);
-				continue;
-			}
-		} else {
-			if (!buffer_uptodate(bh)) {
-				bh->b_end_io = end_buffer_read_sync;
-				get_bh(bh);
-				submit_bh(opf, bh);
-				continue;
-			}
-		}
-		unlock_buffer(bh);
-	}
-}
-EXPORT_SYMBOL(ll_rw_block);
-
 void write_dirty_buffer(struct buffer_head *bh, blk_opf_t op_flags)
 {
 	lock_buffer(bh);
diff --git a/include/linux/buffer_head.h b/include/linux/buffer_head.h
index 6d09785bed9f..b415d8bc2a09 100644
--- a/include/linux/buffer_head.h
+++ b/include/linux/buffer_head.h
@@ -223,7 +223,6 @@ struct buffer_head *alloc_buffer_head(gfp_t gfp_flags);
 void free_buffer_head(struct buffer_head * bh);
 void unlock_buffer(struct buffer_head *bh);
 void __lock_buffer(struct buffer_head *bh);
-void ll_rw_block(blk_opf_t, int, struct buffer_head * bh[]);
 int sync_dirty_buffer(struct buffer_head *bh);
 int __sync_dirty_buffer(struct buffer_head *bh, blk_opf_t op_flags);
 void write_dirty_buffer(struct buffer_head *bh, blk_opf_t op_flags);
-- 
2.31.1


_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
