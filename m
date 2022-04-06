Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc253.phx1.oracleemaildelivery.com (aib29ajc253.phx1.oracleemaildelivery.com [192.29.103.253])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B09AFC433FE
	for <ocfs2-devel@archiver.kernel.org>; Wed,  6 Apr 2022 06:07:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=lMzpNCkpWaf7Nm2ftALv7eGvCDsKfs+hSjRE/NGxueQ=;
 b=hdwSXZFd7mfV1OqI/KfakYO3jgSxvfdpC4pajDulGSvbzCZKNao/uL6yNzXqEiUKVyN3KkEDQRS4
   KkIgkt2c4b3xfnU7anlBxnrsPRBoUsZ0N7adXR3/VLeGta0L9yBzPnaot1K5rMRwkB9tmbgjVNn0
   4TJbqu0MtR1XpM7xr9ivLrcSB+tZKGZcufvTZPDpkdzTQe1snfP+fSfVq5vsr5kshFltf/lc+hEg
   X1Tof98o/s89+iAYoiunh9XEtlEdxmBZ2Y/J86apcZqRTRVNdzpvNdnLt8DKZ2xU9xBHB/LalU++
   GEsF4EG/imPQczzvqI4CvCOfM9aAVlGkmCtIEQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=lMzpNCkpWaf7Nm2ftALv7eGvCDsKfs+hSjRE/NGxueQ=;
 b=qX8Z8lg95MzTGBGfKGxBQr0xchjRyXDhSqxC9HVw4qCPHYIYeNI4VMSfePPOaTy4IkFXk7A4Kca6
   0R397zXxaEjNIteCZPS7W4A/AA2+XpjE5C7xAqqebftbVk41M4AuZ4rLds7NsQcGcX+msNgWMHCv
   8PqVQf0HmLWwLc/GobCShANEhUcxwEDIp+4MIra9n+oJ+tmpDCME69H4rsNaOToNUOJjYk2z3ldw
   gN6XN22i1pqnftH17YTjfFO1QPwx/vSJwY5xlqjEaY7H9AcxprtgAkh5CtOw4CX0hlyGbgwVmLXI
   8ia5I9Y5j8VlxLpWgtRYbznTvzb1dY8jRtF30A==
Received: by omta-ad3-fd1-302-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20220319 64bit (built Mar 19
 2022))
 with ESMTPS id <0R9W003LVMC2D4A0@omta-ad3-fd1-302-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Wed, 06 Apr 2022 06:07:14 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
 MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
 :Reply-To:Content-Type:Content-ID:Content-Description;
 bh=QrovNweyJZRj1GFp6iCnhs45fbus+PzPDKXpCmbtDwo=; b=z5LFDFUbPWb3WO37mO8MwjoQU9
 uS3ZTdwAnf66Lx+zcAQQUC3qALjNiBk8vq/QdAnBrT+kiIx7+bGfq0K3/JsrX94g6GOI1PxnGLDP0
 TpbSMnVMCM12vlH2ieULysyOQ8eqGhAM7WSZgubyaijH46PkBLtZHwMl/DJ+SL/fL62RhXRHRBZ07
 gPidH4d0GBhOycIbS6/qs679s/JDzVaH5pxN2YMNY1qvOfu3TMWQ9LeQbRMDybW1HFyANyEbyeoY8
 bjiiLGRwO/33fN9Ma7LaMPzza6Yu9DF6RQqn94ZGs2knBiL0yIxk5iak06Qk6gWjflRAaNPj9+l6R
 kccMsInA==;
To: Jens Axboe <axboe@kernel.dk>
Date: Wed,  6 Apr 2022 08:05:11 +0200
Message-id: <20220406060516.409838-23-hch@lst.de>
X-Mailer: git-send-email 2.30.2
In-reply-to: <20220406060516.409838-1-hch@lst.de>
References: <20220406060516.409838-1-hch@lst.de>
MIME-version: 1.0
X-Source-IP: 198.137.202.133
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10308
 signatures=695566
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 mlxscore=0
 clxscore=347 priorityscore=60 mlxlogscore=711 phishscore=0 bulkscore=0
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
Subject: [Ocfs2-devel] [PATCH 22/27] block: refactor discard bio size	limiting
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
X-Proofpoint-ORIG-GUID: Qx_XohVQW1XAe7lc7fdCLsnfElxdVgg3
X-Proofpoint-GUID: Qx_XohVQW1XAe7lc7fdCLsnfElxdVgg3
Reporting-Meta:
 AAFOqKCdCiqtbTFhLLCzU3MyvZ+JznA2KyHTZQrvS7tK2i+IExuvgP0R9W9HRrjB
 JCHLc4jdo+uQXo5Fiw5Zt7K/ytZLsBvSbGo4Si7D7cHZwArd3vutVJFFZjgsmtwK
 TmiYxiOzzsEnS88yMCwZ9hW3P87s9nedtbLQMmWMiP6sgNfPf6ui7SUSzt/FCjbI
 1/yxynV1rFFDbRy6xPaBymCZhyE3C3Y9NvKeBXgTIZbCLMI4Ui01OxslpAMq+H84
 y9g7eyLVfIaFkSbdq5r+gScTfTCuc+EV+353AO/Upd0ccqkjUIoGL1Xr8PYI4hss
 7qLB5fplp7XLcopNME35UsDSuEdofutcKaW1jigclfDhmJ2ua0tkM5Zh9Z9Fa8fa
 uWN9hou07RajU70v2dKLuBTq7go3elKNLb5xW5WgGx86ivihqbAn6y4T3aH7E8mH
 TyKHE4mqPtMjkRUZNK1WHQ3y/whr8nbMsvgiN69gTW6V1otIVOb0URWC+MYINKln
 4Geqh3v4lxMmBFaVfmdsWm2QAq5UnstiHxiqS9gUIHA=

Move all the logic to limit the discard bio size into a common helper
so that it is better documented.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 block/blk-lib.c | 59 ++++++++++++++++++++++++-------------------------
 block/blk.h     | 14 ------------
 2 files changed, 29 insertions(+), 44 deletions(-)

diff --git a/block/blk-lib.c b/block/blk-lib.c
index 237d60d8b5857..2ae32a722851c 100644
--- a/block/blk-lib.c
+++ b/block/blk-lib.c
@@ -10,6 +10,32 @@
 
 #include "blk.h"
 
+static sector_t bio_discard_limit(struct block_device *bdev, sector_t sector)
+{
+	unsigned int discard_granularity =
+		bdev_get_queue(bdev)->limits.discard_granularity;
+	sector_t granularity_aligned_sector;
+
+	if (bdev_is_partition(bdev))
+		sector += bdev->bd_start_sect;
+
+	granularity_aligned_sector =
+		round_up(sector, discard_granularity >> SECTOR_SHIFT);
+
+	/*
+	 * Make sure subsequent bios start aligned to the discard granularity if
+	 * it needs to be split.
+	 */
+	if (granularity_aligned_sector != sector)
+		return granularity_aligned_sector - sector;
+
+	/*
+	 * Align the bio size to the discard granularity to make splitting the bio
+	 * at discard granularity boundaries easier in the driver if needed.
+	 */
+	return round_down(UINT_MAX, discard_granularity) >> SECTOR_SHIFT;
+}
+
 int __blkdev_issue_discard(struct block_device *bdev, sector_t sector,
 		sector_t nr_sects, gfp_t gfp_mask, int flags,
 		struct bio **biop)
@@ -17,7 +43,7 @@ int __blkdev_issue_discard(struct block_device *bdev, sector_t sector,
 	struct request_queue *q = bdev_get_queue(bdev);
 	struct bio *bio = *biop;
 	unsigned int op;
-	sector_t bs_mask, part_offset = 0;
+	sector_t bs_mask;
 
 	if (bdev_read_only(bdev))
 		return -EPERM;
@@ -48,36 +74,9 @@ int __blkdev_issue_discard(struct block_device *bdev, sector_t sector,
 	if (!nr_sects)
 		return -EINVAL;
 
-	/* In case the discard request is in a partition */
-	if (bdev_is_partition(bdev))
-		part_offset = bdev->bd_start_sect;
-
 	while (nr_sects) {
-		sector_t granularity_aligned_lba, req_sects;
-		sector_t sector_mapped = sector + part_offset;
-
-		granularity_aligned_lba = round_up(sector_mapped,
-				q->limits.discard_granularity >> SECTOR_SHIFT);
-
-		/*
-		 * Check whether the discard bio starts at a discard_granularity
-		 * aligned LBA,
-		 * - If no: set (granularity_aligned_lba - sector_mapped) to
-		 *   bi_size of the first split bio, then the second bio will
-		 *   start at a discard_granularity aligned LBA on the device.
-		 * - If yes: use bio_aligned_discard_max_sectors() as the max
-		 *   possible bi_size of the first split bio. Then when this bio
-		 *   is split in device drive, the split ones are very probably
-		 *   to be aligned to discard_granularity of the device's queue.
-		 */
-		if (granularity_aligned_lba == sector_mapped)
-			req_sects = min_t(sector_t, nr_sects,
-					  bio_aligned_discard_max_sectors(q));
-		else
-			req_sects = min_t(sector_t, nr_sects,
-					  granularity_aligned_lba - sector_mapped);
-
-		WARN_ON_ONCE((req_sects << 9) > UINT_MAX);
+		sector_t req_sects =
+			min(nr_sects, bio_discard_limit(bdev, sector));
 
 		bio = blk_next_bio(bio, bdev, 0, op, gfp_mask);
 		bio->bi_iter.bi_sector = sector;
diff --git a/block/blk.h b/block/blk.h
index 8ccbc6e076369..1fdc1d28e6d60 100644
--- a/block/blk.h
+++ b/block/blk.h
@@ -346,20 +346,6 @@ static inline unsigned int bio_allowed_max_sectors(struct request_queue *q)
 	return round_down(UINT_MAX, queue_logical_block_size(q)) >> 9;
 }
 
-/*
- * The max bio size which is aligned to q->limits.discard_granularity. This
- * is a hint to split large discard bio in generic block layer, then if device
- * driver needs to split the discard bio into smaller ones, their bi_size can
- * be very probably and easily aligned to discard_granularity of the device's
- * queue.
- */
-static inline unsigned int bio_aligned_discard_max_sectors(
-					struct request_queue *q)
-{
-	return round_down(UINT_MAX, q->limits.discard_granularity) >>
-			SECTOR_SHIFT;
-}
-
 /*
  * Internal io_context interface
  */
-- 
2.30.2


_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
