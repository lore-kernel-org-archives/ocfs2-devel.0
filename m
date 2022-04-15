Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc251.phx1.oracleemaildelivery.com (aib29ajc251.phx1.oracleemaildelivery.com [192.29.103.251])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B18FBC3525B
	for <ocfs2-devel@archiver.kernel.org>; Fri, 15 Apr 2022 04:54:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=qAz5LeSM1hp2VKl1SUFUJPVNgvBxEWE8wcN0h8ayS4c=;
 b=qmyFxvzVaocGwc3Ld96JSVR6FMIcKI5IPc1Nu8Y14yG8alwiYzqPm90XTs59ALP54iVxeSkWKLH0
   8xOHzhQ+iVNsITBNBbL6S7vl79IUlq/SkOE8PkwjaYZqR/a1OUHYTvkDu08gRNr0mouBPsDbcN1e
   87n8GorAOeCnC8jz9bv3algujZI/TNIVnGZ9ZE2BsWXt6xNKC+dQYSuF+SicHmnT4lTdZmxPbZlL
   IVbwA7hI64n/47edfBKENeRfxFNdSQuWDCAjuVz5t3NUYhjwXKiGNRQKuOFVsIjJDzvvj8RyjFls
   zRQt+2lLsWgZBRMLEe/WsClU6FyCgHk+W+y3bQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=qAz5LeSM1hp2VKl1SUFUJPVNgvBxEWE8wcN0h8ayS4c=;
 b=X814eYMdDhvxQwCHv2BBFsfRdSVOrEJgLy/JlJXcyRVEkSdFq+A7eJGevYGLuz/hxNE8xUwd2OWj
   wYPRGJsH3cbQn3PnyllBC54ZFxPkG0b5PqddAqr1WoJL2oKMHq64Yg4wEQdJfX2C2lwlXYYO8HIR
   t8SKFaOOwi7eItHHB+ikErIMyc/2cANdC5A50bCPjy31gGoAVDpoiHcA4YW7oAVwS5Tz3QhWviQR
   F47X8pRZg/QMK6PmrF5t/1m+lW+NM9rPPFqUneyQ6pgzcikJrt90fg02GQYgjWWdC8rQnehOh4Fm
   o/nKZSc5QDNydY6cSLWzy58Dqa0IjHk8ylbCVg==
Received: by omta-ad2-fd3-202-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20220319 64bit (built Mar 19
 2022))
 with ESMTPS id <0RAD00HXC6YUW790@omta-ad2-fd3-202-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Fri, 15 Apr 2022 04:54:30 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
 MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
 :Reply-To:Content-Type:Content-ID:Content-Description;
 bh=ZlX6tQSx9Ltba6eWidCjog7i9CmwA2DoDl+4xkJfBJs=; b=mK5Q76NpPUvc78f6UJP6DQWA/7
 NKBjQM3eKggVVlsB90RP9nWbWfQQRf5B/jpgaA1Q9EfhEKM6lJIkbGZcu7PpXQpjIFw5FBt2pbsp/
 MOoSSA4Ia9EScAPP1GzU9Z/ZQQucRFdEcK1J7IinCMg7xBNHzYM+zhxh9/8+JGCxjva2x2nAoCRtc
 /jXC9gicBp3dw18FSq1x+PVYM/uSyKZyRhIEi86XF4FPTwvQg4pS+RVuHw79vZX329QreecldYuvL
 XgVsFKXu2B19byXqlKObQtsOc9NysNwyvK+OIp8FWlGn58YTS0dBRTNV0sUd2V4lcvAVAxYH2RH2k
 wQndRV7A==;
To: Jens Axboe <axboe@kernel.dk>
Date: Fri, 15 Apr 2022 06:52:44 +0200
Message-id: <20220415045258.199825-14-hch@lst.de>
X-Mailer: git-send-email 2.30.2
In-reply-to: <20220415045258.199825-1-hch@lst.de>
References: <20220415045258.199825-1-hch@lst.de>
MIME-version: 1.0
X-Source-IP: 198.137.202.133
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10317
 signatures=695566
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 phishscore=0
 impostorscore=0 suspectscore=0 malwarescore=0 clxscore=267 lowpriorityscore=0
 priorityscore=264 mlxscore=0 adultscore=0 mlxlogscore=761 spamscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2204150029
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
Subject: [Ocfs2-devel] [PATCH 13/27] block: add a bdev_fua helper
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
X-Proofpoint-ORIG-GUID: MXVPZDLW8KeFATKao2gxkW2DyzkbVCIp
X-Proofpoint-GUID: MXVPZDLW8KeFATKao2gxkW2DyzkbVCIp
Reporting-Meta:
 AAFomgJZ4DbE0jTlh+UyhWKHwOqbji2A/911JkcNY9g52CWEyJbHf0jBaXSfZC2u
 Og5h+qe0RVQNHopTfTQEfTvp3NqxlOzkm2cPhtbwGzf3DN1bERwdaoVC3ZklbmEH
 hdjz2AE98C7vvo17nBeyjqKb9qhQfUgj/8KP4gKN5zJhAh65cWICpT/LN3F4Y3TE
 G2sahV0Roa4+gmeYIYrdhv7OOnIEhQJvG/uk/9H6Te5W4WXkGh/6rJQQaAF3jTOm
 r+ZvbFk11xpUUK5JXPZDjSIE/6m55CCYvvF41v4gG7fJppA5DqwuuEnQi+dY/6uV
 EXGcHrARWjHHbwZ1UN5wPJhYm5ui/dbk5JjuwHYYXDlrdVHzdXhOqZux89HHDVtX
 ij9YUHzeQ0nT1fbE0DIetIYAmwaZekThstB8lmNcaQ8zEOV9ry2DhaO/eQo2bLMX
 Hk87gAm12HGEep0rl4giGH5G1gubkW9hVdcwSH/YVx6lb8U3/pshA341XYMkd0g8
 RAjVRaQRS9PNZBMFs8v8NZpEVJcKDaThHkKcLpVAFoKe9A==

Add a helper to check the FUA flag based on the block_device instead of
having to poke into the block layer internal request_queue.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>
---
 drivers/block/rnbd/rnbd-srv.c       | 3 +--
 drivers/target/target_core_iblock.c | 3 +--
 fs/iomap/direct-io.c                | 3 +--
 include/linux/blkdev.h              | 6 +++++-
 4 files changed, 8 insertions(+), 7 deletions(-)

diff --git a/drivers/block/rnbd/rnbd-srv.c b/drivers/block/rnbd/rnbd-srv.c
index f8cc3c5fecb4b..beaef43a67b9d 100644
--- a/drivers/block/rnbd/rnbd-srv.c
+++ b/drivers/block/rnbd/rnbd-srv.c
@@ -533,7 +533,6 @@ static void rnbd_srv_fill_msg_open_rsp(struct rnbd_msg_open_rsp *rsp,
 					struct rnbd_srv_sess_dev *sess_dev)
 {
 	struct rnbd_dev *rnbd_dev = sess_dev->rnbd_dev;
-	struct request_queue *q = bdev_get_queue(rnbd_dev->bdev);
 
 	rsp->hdr.type = cpu_to_le16(RNBD_MSG_OPEN_RSP);
 	rsp->device_id =
@@ -560,7 +559,7 @@ static void rnbd_srv_fill_msg_open_rsp(struct rnbd_msg_open_rsp *rsp,
 	rsp->cache_policy = 0;
 	if (bdev_write_cache(rnbd_dev->bdev))
 		rsp->cache_policy |= RNBD_WRITEBACK;
-	if (blk_queue_fua(q))
+	if (bdev_fua(rnbd_dev->bdev))
 		rsp->cache_policy |= RNBD_FUA;
 }
 
diff --git a/drivers/target/target_core_iblock.c b/drivers/target/target_core_iblock.c
index 03013e85ffc03..c4a903b8a47fc 100644
--- a/drivers/target/target_core_iblock.c
+++ b/drivers/target/target_core_iblock.c
@@ -727,14 +727,13 @@ iblock_execute_rw(struct se_cmd *cmd, struct scatterlist *sgl, u32 sgl_nents,
 
 	if (data_direction == DMA_TO_DEVICE) {
 		struct iblock_dev *ib_dev = IBLOCK_DEV(dev);
-		struct request_queue *q = bdev_get_queue(ib_dev->ibd_bd);
 		/*
 		 * Force writethrough using REQ_FUA if a volatile write cache
 		 * is not enabled, or if initiator set the Force Unit Access bit.
 		 */
 		opf = REQ_OP_WRITE;
 		miter_dir = SG_MITER_TO_SG;
-		if (test_bit(QUEUE_FLAG_FUA, &q->queue_flags)) {
+		if (bdev_fua(ib_dev->ibd_bd)) {
 			if (cmd->se_cmd_flags & SCF_FUA)
 				opf |= REQ_FUA;
 			else if (!bdev_write_cache(ib_dev->ibd_bd))
diff --git a/fs/iomap/direct-io.c b/fs/iomap/direct-io.c
index b08f5dc31780d..62da020d02a11 100644
--- a/fs/iomap/direct-io.c
+++ b/fs/iomap/direct-io.c
@@ -265,8 +265,7 @@ static loff_t iomap_dio_bio_iter(const struct iomap_iter *iter,
 		 * cache flushes on IO completion.
 		 */
 		if (!(iomap->flags & (IOMAP_F_SHARED|IOMAP_F_DIRTY)) &&
-		    (dio->flags & IOMAP_DIO_WRITE_FUA) &&
-		    blk_queue_fua(bdev_get_queue(iomap->bdev)))
+		    (dio->flags & IOMAP_DIO_WRITE_FUA) && bdev_fua(iomap->bdev))
 			use_fua = true;
 	}
 
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 807a49aa5a27a..075b16d4560e7 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -602,7 +602,6 @@ bool blk_queue_flag_test_and_set(unsigned int flag, struct request_queue *q);
 			     REQ_FAILFAST_DRIVER))
 #define blk_queue_quiesced(q)	test_bit(QUEUE_FLAG_QUIESCED, &(q)->queue_flags)
 #define blk_queue_pm_only(q)	atomic_read(&(q)->pm_only)
-#define blk_queue_fua(q)	test_bit(QUEUE_FLAG_FUA, &(q)->queue_flags)
 #define blk_queue_registered(q)	test_bit(QUEUE_FLAG_REGISTERED, &(q)->queue_flags)
 #define blk_queue_nowait(q)	test_bit(QUEUE_FLAG_NOWAIT, &(q)->queue_flags)
 
@@ -1336,6 +1335,11 @@ static inline bool bdev_write_cache(struct block_device *bdev)
 	return test_bit(QUEUE_FLAG_WC, &bdev_get_queue(bdev)->queue_flags);
 }
 
+static inline bool bdev_fua(struct block_device *bdev)
+{
+	return test_bit(QUEUE_FLAG_FUA, &bdev_get_queue(bdev)->queue_flags);
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
