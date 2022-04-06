Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc248.phx1.oracleemaildelivery.com (aib29ajc248.phx1.oracleemaildelivery.com [192.29.103.248])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 009D0C433FE
	for <ocfs2-devel@archiver.kernel.org>; Wed,  6 Apr 2022 06:07:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=DXqs6vxY2YU+OeodSXDccuOZECaE6Y3L4wGX7lCSg1c=;
 b=T7Fswk+2CO8megVWo30EbwjEshfjk5WstaCeUOk1pMOBlKVTQCOFD/J9+bzvY+tE6tPxAFSmdzvf
   8O9c4zoKJjqaYkHD+XlC3YeBX+Vs43N4xDdDB6+uQGXzF2A18CVQnmeB+I53Bb1+TyGevmueG45t
   Gg8ZguK5FO8oovzbXf3omwJWi2wDm5hfBfZF3bQnVI4fkyUADbd9STRFsKcr2gmad0AdKEaKN9uE
   1mZHWlHfx9iDhFZ4FxPNpUYDbV7z1QyM7zcjn7Z2zZwaPz58CQxVG5b6J/TlCRolRq/QFWOqxv5e
   g4Qbhg6/WZKyasjtTyWC6pOfymrZNUQ3DStNRw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=DXqs6vxY2YU+OeodSXDccuOZECaE6Y3L4wGX7lCSg1c=;
 b=I/PF54VvV/UD6vM2HsmN7zYPBA3fU5ZJfGauuKYpMKH8TbZAFaOi1Bf6EwxpJLfGlSq3sJqL/iiq
   AQmV26bow+XKzoYgbIvT0RnfQsDz42twi9Mx66o9VWNwPipEl/Vqc6cnNIyXZ01DNnA4Mj/vt1eE
   WMNzUW5h4qEihSMlQkiAEsyQvWge99wYZc/dpGTPZ0zF+4i8JlDHYOlVjmJ+vg2dTgtFoA272jHN
   l3TKFx4QmZSPJG6+S6psuxhTj1MNvZWNLBtGYdE312sBIkvUB6wF32khhuc5sA2uJJWnLPdy1CMz
   v0s2WcCcsxyQxrRd0Ol//nt19JlEz/8K4xlkmg==
Received: by omta-ad2-fd1-201-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20220319 64bit (built Mar 19
 2022))
 with ESMTPS id <0R9W00HODMBYU4C0@omta-ad2-fd1-201-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Wed, 06 Apr 2022 06:07:10 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
 MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
 :Reply-To:Content-Type:Content-ID:Content-Description;
 bh=M87611C6i/ov1/eZb42tZHfhB+4TDGyoM3tVyFqdBW8=; b=K8zhFyJNpfgn61EWvQNSpZGhoz
 IsW4d6jPg/o8RKdUEsY2I/0tp3DUigRRARrtQZS25XHPg6Ev8uZ5v/1QUVxcxn0UGRSq3QsUvtq8v
 m/wMNTUuZ0otna4wKyCKR9KuxhJuJrTxMCeQTsVHCLUaBLTq/yY7C/2YjXGPofV9QR6/pigrTQvyL
 +7FqGR+5akCXPC49M0KmVYykqYBaCN6qbVITFsaW/p3jcsFmAJQrrYOqAHtx2ogkbDQplnGNGSG9t
 hp4bnoEMlp1dxurHyPf38IfpaJHQv16bHjbw1cMsHDW5/ZArceH5PRjetepYbBzoAtUPy5j6Xetj9
 Onlv8nZg==;
To: Jens Axboe <axboe@kernel.dk>
Date: Wed,  6 Apr 2022 08:05:10 +0200
Message-id: <20220406060516.409838-22-hch@lst.de>
X-Mailer: git-send-email 2.30.2
In-reply-to: <20220406060516.409838-1-hch@lst.de>
References: <20220406060516.409838-1-hch@lst.de>
MIME-version: 1.0
X-Source-IP: 198.137.202.133
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10308
 signatures=695566
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 mlxscore=0
 clxscore=295 priorityscore=90 mlxlogscore=818 phishscore=0 bulkscore=0
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
Subject: [Ocfs2-devel] [PATCH 21/27] block: move {bdev,
	queue_limit}_discard_alignment out of line
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
X-Proofpoint-ORIG-GUID: 4z4IYZLP517dLGjKlcZxe8Hey7Yvrxr7
X-Proofpoint-GUID: 4z4IYZLP517dLGjKlcZxe8Hey7Yvrxr7
Reporting-Meta:
 AAELJ+jiixwTZPV6n3UfCKTtjekvnTSddfbMwuTajImxmGQWw0CABB7DF4m1GwHs
 vkFYhQqkQVn6jovVmWVIfNbxYzc8Ws53pc5yGTHy5E8JGVit5HUvobZq+ee0uOog
 4SZ4entu5vuw1xThXFlqpCFXSsXURbpMOkj1wGOPUN+x9yaOaMRc40bMaNIkDvay
 kyE1b7qzo3jG56BZMLMhQUp3FckbpS+uCInflbXsLhOVIjMr4aMZ8+HuwTc9hi48
 s7q7U9PrEfbkCX1z25UFXQMamAjhOBPjpzcYq1DI4YG6cew3hhjEIKE2J06ewCg2
 ibpHR9zTvqssTafreLSkkRMaYvYrdOW4tJqCPN6rfI5+wMwa7WfdJyVH/1qvENRZ
 83d9SLbYJfinDh2zTfNMf454dxC+2wzgIhIYDGSN8dEs2SdkRTnwMfYipEDf5yZB
 kdfdVBoZEWCvmR19TnWzUBLiatVUvJT8NQxRDLQO+jo7LsDw7un55qxduP4P1Y8S
 CHaP5HjUUF8T7RmZBSJRPM0M6fUtwUy0obUGwKcxtdk=

No need to inline these fairly larger helpers.  Also fix the return value
to be unsigned, just like the field in struct queue_limits.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 block/blk-settings.c   | 35 +++++++++++++++++++++++++++++++++++
 include/linux/blkdev.h | 34 +---------------------------------
 2 files changed, 36 insertions(+), 33 deletions(-)

diff --git a/block/blk-settings.c b/block/blk-settings.c
index 94410a13c0dee..fd83d674afd0a 100644
--- a/block/blk-settings.c
+++ b/block/blk-settings.c
@@ -478,6 +478,30 @@ static int queue_limit_alignment_offset(struct queue_limits *lim,
 	return (granularity + lim->alignment_offset - alignment) % granularity;
 }
 
+static unsigned int queue_limit_discard_alignment(struct queue_limits *lim,
+		sector_t sector)
+{
+	unsigned int alignment, granularity, offset;
+
+	if (!lim->max_discard_sectors)
+		return 0;
+
+	/* Why are these in bytes, not sectors? */
+	alignment = lim->discard_alignment >> SECTOR_SHIFT;
+	granularity = lim->discard_granularity >> SECTOR_SHIFT;
+	if (!granularity)
+		return 0;
+
+	/* Offset of the partition start in 'granularity' sectors */
+	offset = sector_div(sector, granularity);
+
+	/* And why do we do this modulus *again* in blkdev_issue_discard()? */
+	offset = (granularity + alignment - offset) % granularity;
+
+	/* Turn it back into bytes, gaah */
+	return offset << SECTOR_SHIFT;
+}
+
 static unsigned int blk_round_down_sectors(unsigned int sectors, unsigned int lbs)
 {
 	sectors = round_down(sectors, lbs >> SECTOR_SHIFT);
@@ -924,3 +948,14 @@ int bdev_alignment_offset(struct block_device *bdev)
 	return q->limits.alignment_offset;
 }
 EXPORT_SYMBOL_GPL(bdev_alignment_offset);
+
+unsigned int bdev_discard_alignment(struct block_device *bdev)
+{
+	struct request_queue *q = bdev_get_queue(bdev);
+
+	if (bdev_is_partition(bdev))
+		return queue_limit_discard_alignment(&q->limits,
+				bdev->bd_start_sect);
+	return q->limits.discard_alignment;
+}
+EXPORT_SYMBOL_GPL(bdev_discard_alignment);
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 5a9b7aeda010b..34b1cfd067421 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -1252,39 +1252,7 @@ bdev_zone_write_granularity(struct block_device *bdev)
 }
 
 int bdev_alignment_offset(struct block_device *bdev);
-
-static inline int queue_limit_discard_alignment(struct queue_limits *lim, sector_t sector)
-{
-	unsigned int alignment, granularity, offset;
-
-	if (!lim->max_discard_sectors)
-		return 0;
-
-	/* Why are these in bytes, not sectors? */
-	alignment = lim->discard_alignment >> SECTOR_SHIFT;
-	granularity = lim->discard_granularity >> SECTOR_SHIFT;
-	if (!granularity)
-		return 0;
-
-	/* Offset of the partition start in 'granularity' sectors */
-	offset = sector_div(sector, granularity);
-
-	/* And why do we do this modulus *again* in blkdev_issue_discard()? */
-	offset = (granularity + alignment - offset) % granularity;
-
-	/* Turn it back into bytes, gaah */
-	return offset << SECTOR_SHIFT;
-}
-
-static inline int bdev_discard_alignment(struct block_device *bdev)
-{
-	struct request_queue *q = bdev_get_queue(bdev);
-
-	if (bdev_is_partition(bdev))
-		return queue_limit_discard_alignment(&q->limits,
-				bdev->bd_start_sect);
-	return q->limits.discard_alignment;
-}
+unsigned int bdev_discard_alignment(struct block_device *bdev);
 
 static inline unsigned int bdev_write_zeroes_sectors(struct block_device *bdev)
 {
-- 
2.30.2


_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
