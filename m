Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc247.phx1.oracleemaildelivery.com (aib29ajc247.phx1.oracleemaildelivery.com [192.29.103.247])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 376D6C433EF
	for <ocfs2-devel@archiver.kernel.org>; Wed,  6 Apr 2022 06:06:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=iR0hbTGf1C9S0p0zNhml+ItRkshFKK6QfdBDuGDsr94=;
 b=wJ6JtfMteaPfirUld2hHcKXF6HN7vSRxo3iZ7sxEsXDQaBTkAvX1ShAyUMmSGo9uy/3Zdnb+LaDX
   lr9pDXshPn5byNbsQlWnqzX2w7b3MFNPgPRzjv7C0au3AOGIX96bkfhpH/kK77c2x3qIFYi5QbUm
   uy4UoLQL4ugi9InttxepL0SGJdTI1sfH2Yp/h41hk8iBiYzdNv3KY0gL8fGt1SdcrSx7cILrJJyn
   qtnsXKJECth+Zqmv0o2R0KfPlXEu3MQfqQJbz4Iu+IcycBs41FTUCvwaVHzkQvF3zYZmaQNzaFGf
   eV5fG/gIpbe8XJKD7vJE8kD+3Gx17T1u8mCIbw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=iR0hbTGf1C9S0p0zNhml+ItRkshFKK6QfdBDuGDsr94=;
 b=AiDqTYxPs9/yeqUrpo9btb0prR7uoNythmO86q+vePsh1qht6zTEDrbCxpTRVDRzN5mgnpPWG5cL
   l6Ps7eA5hAHfkbERjW4SGqXdh8w1SLdviPs/1vFfXAXcNAav8IuCGi/marzr8n/WSLTOoSHgP/Hl
   UjeRML+WtVJXXdmBivSEFp42Uf1E0h33meCkL8j9aDU4yOm2vH/qqgS33sI9bpZR+f/rgmjW4n3v
   VLtF7tUsuZh1JhNb4HsZMIkroZp4qI263drJNHZ6i2H5oZxvWSjNTnW0evL3hmQsx88uOHaCjHg7
   I6K26SmH+Ubca3wfpTX+F5AZgUWv3a7vyD/2tg==
Received: by omta-ad1-fd3-102-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20220319 64bit (built Mar 19
 2022))
 with ESMTPS id <0R9W00IMSMAW2A30@omta-ad1-fd3-102-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Wed, 06 Apr 2022 06:06:32 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
 MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
 :Reply-To:Content-Type:Content-ID:Content-Description;
 bh=6QVq+WRTbBiZAGVnN7IJPNcrDbkE5gjblRwCavAMwLY=; b=iYaG9VkUCm4D5TSOODWzio+3DR
 ytZ5+1QAyty9m+UBWG1IlrNmfBUfcieyEgGbnGvY+TeziydmDWxyUyplf08DqEXPrSA6ogGWlWBdc
 eN+NdSm2eI+GluAazic6ThRfk6EDWhUlwAFB1sgAiTcA0zTyVy4xoxDN7lNirp1PXWPDjCYKA8P/e
 a8Slx22YjqPgPpaGfnOLHtBTxMkfAK1Qngg3xOt/ieRRfzMYcYXFMoAX7pejVqOX04vm+E3B6daNl
 No56Cgl46IA8J2O0CAKFddZqGLAK02p4IZLzzaiPdfWcvculhrlYOGpmXilPV0+0lJWjaiLUMp8xe
 qYLNQzvg==;
To: Jens Axboe <axboe@kernel.dk>
Date: Wed,  6 Apr 2022 08:05:00 +0200
Message-id: <20220406060516.409838-12-hch@lst.de>
X-Mailer: git-send-email 2.30.2
In-reply-to: <20220406060516.409838-1-hch@lst.de>
References: <20220406060516.409838-1-hch@lst.de>
MIME-version: 1.0
X-Source-IP: 198.137.202.133
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10308
 signatures=695566
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 mlxscore=0
 clxscore=282 priorityscore=30 mlxlogscore=496 phishscore=0 bulkscore=0
 spamscore=0 malwarescore=0 adultscore=0 lowpriorityscore=0 suspectscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2204060026
Cc: jfs-discussion@lists.sourceforge.net, linux-nvme@lists.infradead.org,
 virtualization@lists.linux-foundation.org, linux-mm@kvack.org,
 dm-devel@redhat.com, target-devel@vger.kernel.org,
 linux-mtd@lists.infradead.org, drbd-dev@lists.linbit.com,
 linux-s390@vger.kernel.org, linux-nilfs@vger.kernel.org,
 linux-scsi@vger.kernel.org, cluster-devel@redhat.com,
 xen-devel@lists.xenproject.org, linux-ext4@vger.kernel.org,
 linux-um@lists.infradead.org, nbd@other.debian.org,
 linux-block@vger.kernel.org, linux-bcache@vger.kernel.org,
 ceph-devel@vger.kernel.org, linux-raid@vger.kernel.org,
 linux-mmc@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
 linux-xfs@vger.kernel.org, ocfs2-devel@oss.oracle.com,
 linux-fsdevel@vger.kernel.org, ntfs3@lists.linux.dev,
 linux-btrfs@vger.kernel.org
Subject: [Ocfs2-devel] [PATCH 11/27] block: add a bdev_write_cache helper
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
From: Christoph Hellwig via Ocfs2-devel <ocfs2-devel@oss.oracle.com>
Reply-to: Christoph Hellwig <hch@lst.de>
Content-type: text/plain; charset="us-ascii"
Content-transfer-encoding: 7bit
Errors-to: ocfs2-devel-bounces@oss.oracle.com
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by
 bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-ServerName: bombadil.infradead.org
X-Proofpoint-SPF-Result: None
X-Spam: Clean
X-Proofpoint-GUID: qIGmAqbJWWpfyWzjMlx81lB_omsyGesY
X-Proofpoint-ORIG-GUID: qIGmAqbJWWpfyWzjMlx81lB_omsyGesY
Reporting-Meta:
 AAF7uyk5Gce/jWnxvKYp39grIAGEaNhjvaBe7nA1Qg76ewvLwwcVf0dZwNYT7RJt
 sFGnai1/0qjdaiSbjJSdQoZahcwstcMHpUBATQIBnapOJ7P/4UT+TUHTOnLzOPO/
 9KG/DNqyXLYipYYHVERVxe9uOY64JuMJ98pl1TBW33WVyEqR/yhEO0i8LCItdDu5
 DgTM7EiIQisQNI8Y4p1MnjWZv+IcguXSB6tjfIsye5h8Wk36H6ooj2QsrQqijGMa
 lnuSRVr1KLnmJMXuTLtZ31f0+fHzR2YLDL9COUWawnElOVq603BgVqo0sv1AH+rF
 3lnW7fJpzAnsFZrC6My24DbgcwwAxF9NDRpqRt76QeyK8bMA347Lssm8v1PIwWlv
 zsQq3AD2jmdLd11PIAyFS/mL6ByVK+mu51B1UqwyxElW1tcuN4+op3q40rbza7Ew
 OQlfAPE36tffZRM2HI4P1K0OeHfbjsyogzMl3AiX4EbQ/tKL3Eo5ohGpi6El60CZ
 xcklWzzulX+pJK72YNH5lGFGnipJXQy1HLkqywbn2dNa

Add a helper to check the write cache flag based on the block_device
instead of having to poke into the block layer internal request_queue.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/block/rnbd/rnbd-srv.c       | 2 +-
 drivers/block/xen-blkback/xenbus.c  | 2 +-
 drivers/target/target_core_iblock.c | 8 ++------
 fs/btrfs/disk-io.c                  | 3 +--
 include/linux/blkdev.h              | 5 +++++
 5 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/drivers/block/rnbd/rnbd-srv.c b/drivers/block/rnbd/rnbd-srv.c
index f04df6294650b..f8cc3c5fecb4b 100644
--- a/drivers/block/rnbd/rnbd-srv.c
+++ b/drivers/block/rnbd/rnbd-srv.c
@@ -558,7 +558,7 @@ static void rnbd_srv_fill_msg_open_rsp(struct rnbd_msg_open_rsp *rsp,
 	rsp->secure_discard =
 		cpu_to_le16(rnbd_dev_get_secure_discard(rnbd_dev));
 	rsp->cache_policy = 0;
-	if (test_bit(QUEUE_FLAG_WC, &q->queue_flags))
+	if (bdev_write_cache(rnbd_dev->bdev))
 		rsp->cache_policy |= RNBD_WRITEBACK;
 	if (blk_queue_fua(q))
 		rsp->cache_policy |= RNBD_FUA;
diff --git a/drivers/block/xen-blkback/xenbus.c b/drivers/block/xen-blkback/xenbus.c
index f09040435e2e5..8b691fe50475f 100644
--- a/drivers/block/xen-blkback/xenbus.c
+++ b/drivers/block/xen-blkback/xenbus.c
@@ -517,7 +517,7 @@ static int xen_vbd_create(struct xen_blkif *blkif, blkif_vdev_t handle,
 		vbd->type |= VDISK_REMOVABLE;
 
 	q = bdev_get_queue(bdev);
-	if (q && test_bit(QUEUE_FLAG_WC, &q->queue_flags))
+	if (bdev_write_cache(bdev))
 		vbd->flush_support = true;
 
 	if (q && blk_queue_secure_erase(q))
diff --git a/drivers/target/target_core_iblock.c b/drivers/target/target_core_iblock.c
index b41ee5c3b5b82..03013e85ffc03 100644
--- a/drivers/target/target_core_iblock.c
+++ b/drivers/target/target_core_iblock.c
@@ -737,7 +737,7 @@ iblock_execute_rw(struct se_cmd *cmd, struct scatterlist *sgl, u32 sgl_nents,
 		if (test_bit(QUEUE_FLAG_FUA, &q->queue_flags)) {
 			if (cmd->se_cmd_flags & SCF_FUA)
 				opf |= REQ_FUA;
-			else if (!test_bit(QUEUE_FLAG_WC, &q->queue_flags))
+			else if (!bdev_write_cache(ib_dev->ibd_bd))
 				opf |= REQ_FUA;
 		}
 	} else {
@@ -886,11 +886,7 @@ iblock_parse_cdb(struct se_cmd *cmd)
 
 static bool iblock_get_write_cache(struct se_device *dev)
 {
-	struct iblock_dev *ib_dev = IBLOCK_DEV(dev);
-	struct block_device *bd = ib_dev->ibd_bd;
-	struct request_queue *q = bdev_get_queue(bd);
-
-	return test_bit(QUEUE_FLAG_WC, &q->queue_flags);
+	return bdev_write_cache(IBLOCK_DEV(dev)->ibd_bd);
 }
 
 static const struct target_backend_ops iblock_ops = {
diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index b30309f187cf0..d80adee32128d 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -4247,8 +4247,7 @@ static void write_dev_flush(struct btrfs_device *device)
 	 * of simplicity, since this is a debug tool and not meant for use in
 	 * non-debug builds.
 	 */
-	struct request_queue *q = bdev_get_queue(device->bdev);
-	if (!test_bit(QUEUE_FLAG_WC, &q->queue_flags))
+	if (bdev_write_cache(device->bdev))
 		return;
 #endif
 
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 3a9578e14a6b0..807a49aa5a27a 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -1331,6 +1331,11 @@ static inline bool bdev_nonrot(struct block_device *bdev)
 	return blk_queue_nonrot(bdev_get_queue(bdev));
 }
 
+static inline bool bdev_write_cache(struct block_device *bdev)
+{
+	return test_bit(QUEUE_FLAG_WC, &bdev_get_queue(bdev)->queue_flags);
+}
+
 static inline enum blk_zoned_model bdev_zoned_model(struct block_device *bdev)
 {
 	struct request_queue *q = bdev_get_queue(bdev);
-- 
2.30.2


_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
