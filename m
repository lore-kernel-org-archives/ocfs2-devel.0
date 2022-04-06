Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc247.phx1.oracleemaildelivery.com (aib29ajc247.phx1.oracleemaildelivery.com [192.29.103.247])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6D769C433F5
	for <ocfs2-devel@archiver.kernel.org>; Wed,  6 Apr 2022 06:06:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=+3UJOaM1ROewhAuVA0NnSlpgw1wi/YXxOxLSHS9Sf60=;
 b=ksmSUhdbQCs6aVsw+c0vZMVFYZamLbJ61KullfzWagGfC0/J6Hxa+s204OwqzIwCYAm+Ovm7m20l
   XSGKls8KihcICW2nueqoBH7EIF6+zMPgyzRSilH5gYlYQtEwz5vntuPd9s5syYdFdpsSlSJjLQkl
   vpN72LD81neZo9dlz/FCn1BjW+FfLSQSsIcvyDI2rDowl5sbL4m9acxm/nvnMT64bWukEL2/mEQN
   Li6Nmi9rHgTYnmdVPHyL4kdiisLeekrv/B/J5Om+MV7F6IVVOh8Iv0WA5rKbH0jVstOfNH1oChro
   YrdxAaJWdgX345c/wFQQVH33jHz09vVGUy212g==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=+3UJOaM1ROewhAuVA0NnSlpgw1wi/YXxOxLSHS9Sf60=;
 b=EOqf8b3DS1lyUZ0sCVASvXNHYy0H9qRkjuMc15KW/xy8ofIGjMVnliG94e5YQYvoQEAU4PrFeZw5
   LfQG6aI07gpU+Fa/+9AHsxr91wM9pxRGM83jsTAPFz766frxJiqZ7e0A3Cbzq24dgfrykII5R+qv
   X380BCZUg6ZLtDin8MsGLmpCJ6kUazsR6kujVchNH5NU9pBsY4MncjVBy5Pis79sLEz+QaTcYfqV
   G09xShtFHnTuIHtORl15YDA6mHt5+Ws0qLGxcZnA+zt5XrO8J4YICmHa34a+upwXlj+lBbVPXe96
   LnsUUr1Imu3rW/i+T5Sr5ZR89xwK9/AEZjsgIA==
Received: by omta-ad1-fd3-102-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20220319 64bit (built Mar 19
 2022))
 with ESMTPS id <0R9W00IQ5MBG2A30@omta-ad1-fd3-102-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Wed, 06 Apr 2022 06:06:53 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
 MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
 :Reply-To:Content-Type:Content-ID:Content-Description;
 bh=rlsVeHMg1hHe1r1+YuPgwXRF4/8zJamKMsqI05vg2XQ=; b=dEa4kNFmwX0SYcUFcc8Xi9cZiL
 0YHBnhtVe3qzqowCIKMRB3fv14qh0IEapvyOiw9f3P2TSmik6xnIn650HHnwvUXy84tiN3zbnssTg
 bDH/a8s5U5AtH87Q46R+MdZn/5zNmDyW2XAGsRKbf666enqb4maEJBeBUKRiT5IBnUoONGC/RElhk
 R2OL8L7AkB7Ubnk5lUhjB16LEYlI2jSitkdlJ7GTrHY/8Pee2MpDAWz1qn3WxE7V0lFGXbe3hSOHh
 45Avy2PKid7ei173qk3MzQTEY8YnmjD/8olfy3eNuGejl5sdeK7uQvol+EUTRrVgtV4C0kFycxISR
 GBDMxuEg==;
To: Jens Axboe <axboe@kernel.dk>
Date: Wed,  6 Apr 2022 08:05:07 +0200
Message-id: <20220406060516.409838-19-hch@lst.de>
X-Mailer: git-send-email 2.30.2
In-reply-to: <20220406060516.409838-1-hch@lst.de>
References: <20220406060516.409838-1-hch@lst.de>
MIME-version: 1.0
X-Source-IP: 198.137.202.133
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10308
 signatures=695566
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 impostorscore=0
 priorityscore=60 spamscore=0 mlxscore=0 adultscore=0 mlxlogscore=975
 suspectscore=0 phishscore=0 bulkscore=0 malwarescore=0 lowpriorityscore=0
 clxscore=321 classifier=spam adjust=0 reason=mlx scancount=1
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
Subject: [Ocfs2-devel] [PATCH 18/27] block: move bdev_alignment_offset and
	queue_limit_alignment_offset out of line
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
X-Proofpoint-ORIG-GUID: M3Ig5vvyjvdiW8YapPnGTavjm-p1Itd8
X-Proofpoint-GUID: M3Ig5vvyjvdiW8YapPnGTavjm-p1Itd8
Reporting-Meta:
 AAHmGpPeWskFdxA9XN8dNQDMCMHjBjq3ZDgFMVYtsfZirvADX0Y9QelhtaO708g9
 jAmjss6qKwXhNWJkyZT36fFbvMOpH2X+h1OAwTYb1Rb4+P9/CUj3ELqz8l1Ly9Pr
 Khp6EwqbxdwPml5+n/Tx6u06TO+bjtN1iLpXyFsZC80VhgibqQaKKVq2D2glA+OP
 R+iw9weERkFytT1xo1OC6YC7vOhvy7KF4+yAzdZHe7DZ26+EU1T9NYqscWDASWOs
 SwjjM2BZ6qrR5i1/frZia9cGRWxozDRsIjhJmMDCDJw+SyD4o7q+kUss/vQuiaUZ
 1wdwqEnlmWrh96n2AreEgn/ZNQs/t7WgNoywwvF59nkzuPSgCHLgTceCuOlk7wFA
 xN/h3KFd+NdT4wen+f8fA/WM1ayoFCMyfhYrZMbHU8KfMe/Ax6e4TIGnsVbiWG0B
 F4AGcz8liayL/8xpfUakJ94+pYVBLBjCi9AaCLJkkyg7NyblgfgkNn3F+zwEhikn
 PCrHdVsuNHhtHtmAG1KgxuU02QcEFgvY33IsWQToI+qS

No need to inline these fairly larger helpers.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 block/blk-settings.c   | 23 +++++++++++++++++++++++
 include/linux/blkdev.h | 21 +--------------------
 2 files changed, 24 insertions(+), 20 deletions(-)

diff --git a/block/blk-settings.c b/block/blk-settings.c
index b83df3d2eebca..94410a13c0dee 100644
--- a/block/blk-settings.c
+++ b/block/blk-settings.c
@@ -468,6 +468,16 @@ void blk_queue_io_opt(struct request_queue *q, unsigned int opt)
 }
 EXPORT_SYMBOL(blk_queue_io_opt);
 
+static int queue_limit_alignment_offset(struct queue_limits *lim,
+		sector_t sector)
+{
+	unsigned int granularity = max(lim->physical_block_size, lim->io_min);
+	unsigned int alignment = sector_div(sector, granularity >> SECTOR_SHIFT)
+		<< SECTOR_SHIFT;
+
+	return (granularity + lim->alignment_offset - alignment) % granularity;
+}
+
 static unsigned int blk_round_down_sectors(unsigned int sectors, unsigned int lbs)
 {
 	sectors = round_down(sectors, lbs >> SECTOR_SHIFT);
@@ -901,3 +911,16 @@ void blk_queue_set_zoned(struct gendisk *disk, enum blk_zoned_model model)
 	}
 }
 EXPORT_SYMBOL_GPL(blk_queue_set_zoned);
+
+int bdev_alignment_offset(struct block_device *bdev)
+{
+	struct request_queue *q = bdev_get_queue(bdev);
+
+	if (q->limits.misaligned)
+		return -1;
+	if (bdev_is_partition(bdev))
+		return queue_limit_alignment_offset(&q->limits,
+				bdev->bd_start_sect);
+	return q->limits.alignment_offset;
+}
+EXPORT_SYMBOL_GPL(bdev_alignment_offset);
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index d5346e72e3645..0a1795ac26275 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -1251,26 +1251,7 @@ bdev_zone_write_granularity(struct block_device *bdev)
 	return queue_zone_write_granularity(bdev_get_queue(bdev));
 }
 
-static inline int queue_limit_alignment_offset(struct queue_limits *lim, sector_t sector)
-{
-	unsigned int granularity = max(lim->physical_block_size, lim->io_min);
-	unsigned int alignment = sector_div(sector, granularity >> SECTOR_SHIFT)
-		<< SECTOR_SHIFT;
-
-	return (granularity + lim->alignment_offset - alignment) % granularity;
-}
-
-static inline int bdev_alignment_offset(struct block_device *bdev)
-{
-	struct request_queue *q = bdev_get_queue(bdev);
-
-	if (q->limits.misaligned)
-		return -1;
-	if (bdev_is_partition(bdev))
-		return queue_limit_alignment_offset(&q->limits,
-				bdev->bd_start_sect);
-	return q->limits.alignment_offset;
-}
+int bdev_alignment_offset(struct block_device *bdev);
 
 static inline int queue_discard_alignment(const struct request_queue *q)
 {
-- 
2.30.2


_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
