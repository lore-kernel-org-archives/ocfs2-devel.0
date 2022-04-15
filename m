Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc245.phx1.oracleemaildelivery.com (aib29ajc245.phx1.oracleemaildelivery.com [192.29.103.245])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BF304C41535
	for <ocfs2-devel@archiver.kernel.org>; Fri, 15 Apr 2022 04:54:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=sSjlXjg7KmkVW1i0AI0Q/zXrduiZUudWSBbrqF7bIHM=;
 b=npLRa6Lt+d9GFz1r2i2R/yHjzjU/BGmIBSWoPxLI3rBwfL9F9u6dVXFUK41ZzOIx6X2S6vG8juOe
   J+eMLZX+cGNaTyQ4xfvqHK5GR1ySNaP4xs3UcUNGGvhgh2BTKa+bryQ0q97VcDL6914f2GQqNaLr
   Kfx8kc0MaBLt8NZNr8IDNAWm8XWp5dYwRbaaoSOr5WmAmsV/FGhiWDSzEDnWbKRB0vPqv9X8fYMr
   AvdvIubN7rVrtDzD4mf/0ivXkKklY75vSfv8JO12t3vdR94WFOn69GX88EYlkEUEZ+MK8ndF2mS8
   ao0EHz0W0e8duIn60HZrb+5XM3H6Msa1K6UhdA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=sSjlXjg7KmkVW1i0AI0Q/zXrduiZUudWSBbrqF7bIHM=;
 b=b7q5mUc/VljCWxzRgKJcf5ji9pT9Hjc0tOt3o5ZHQVuJTbGP7rFH4iDjM7AoL1TXntnX55lI5XBr
   BDLc+9PvHGaC7vLELPMXn6bJJctGdKhYteAwbQ/oTbbVSWGyA0ALGnUwF6clgcgT6W4r8peELgKJ
   8GAGEQnKKzkv2eWdSzwgc1r7QAB1biZ2LlHvgIYhHEC7ZZnRNX0U8CLcaCZrAIcMN72IvwACh4xQ
   TJlNTuVq8OxcZsPQ3bQCboEfVgbeSMP64L/Ni/tx0m+VBpNsOQHwZqPnLt3bumsFzqxPR4UUdhbt
   BynXZswr2GAVj0RXGBR4O6MgxOt1x6VvvhwvTA==
Received: by omta-ad1-fd1-102-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20220319 64bit (built Mar 19
 2022))
 with ESMTPS id <0RAD003R56Z4OHF0@omta-ad1-fd1-102-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Fri, 15 Apr 2022 04:54:40 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
 MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
 :Reply-To:Content-Type:Content-ID:Content-Description;
 bh=LA03+v2RMrt5LLwAfTBpcNFXpYhSXKyM/LEXrkZN1Tc=; b=LADyBsuLQpSvZVOI9iNu3zFf2Z
 SEH5za8/XrvPRuwh4TwHe7OlvnSu6j9qkRRGGecLPPLsoWIvS7KxzQE5AizDIz9MvjgfVsuNp13Eq
 ZByoLLOiZSAgO2FmaZjLKmy35f7AqZ0bRkQXyFt0KFpuATixmIymK5iv+aV8uMY/BiO9z1ISlyebq
 wDQWs1lYdYUlF31lbm99N6Kdbl82pDjKi5m2oYGDMZ/ESoukEtgyT6rpjPpocnNkNMxqHhSPxrha3
 uTQvCNZSoso625zW5i+ex0gK0vrdhQ8qDshZOw3gMwuVl8MKqYXFvH6egXHkAdYDBWWCkoyT5Gevx
 A5jRU7mg==;
To: Jens Axboe <axboe@kernel.dk>
Date: Fri, 15 Apr 2022 06:52:49 +0200
Message-id: <20220415045258.199825-19-hch@lst.de>
X-Mailer: git-send-email 2.30.2
In-reply-to: <20220415045258.199825-1-hch@lst.de>
References: <20220415045258.199825-1-hch@lst.de>
MIME-version: 1.0
X-Source-IP: 127.0.0.1
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10317
 signatures=695566
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 clxscore=229
 mlxlogscore=999 impostorscore=0 priorityscore=156 mlxscore=0 adultscore=0
 bulkscore=0 spamscore=0 suspectscore=0 lowpriorityscore=0 phishscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
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
X-ServerName: localhost
X-Proofpoint-SPF-Result: None
X-Spam: Clean
X-Proofpoint-ORIG-GUID: sglBcUNvAZ78WArYw49R8pWkcXikg2Dz
X-Proofpoint-GUID: sglBcUNvAZ78WArYw49R8pWkcXikg2Dz
Reporting-Meta:
 AAHKeIfm/+AiVKvx5RFUVy7DTxiNUAeOvGhGjKn6X5de4dESgmMy/PsmArzAvPMj
 k9S/s/nWN4AL9YrcfLfWvSgT/95QBdn5Zh3JNV7J7ifeI0RTHATkbuneghgSx6Qv
 ENBnY4qQ9fjDnEVuqeY9laGwS4/Pne+du0KGsciVhQ+BG7YEINzKCEV/mczUfpfI
 p4TisTVYsNhcmIHhg/lWbi7bNhcsDUX8+ECRNZqAmB3vp0Mte2+pV3SG06l2zIAL
 JpPULL8FjIj8NCMhYsaNk9CWPsbgZhqF8i2cbPLlfNwjF/mlzSH8JpNr3i2CpP9J
 AaJDQvne1TnMZ+FQiqzuZJIXx7VwgHFIAI3W+/EkNCfTBKcFbkO7ptWOThAbBP4v
 Zds15pe+voq832rVvzPKaKCVLONDOdD2wLY1wKURw6XG0RkEpH1J0611gqZrzb2U
 Dzr6uZ/riyVDfXYW/rTLwwjgzMTad47WTHaZdN8K3Uvt49zsF40rX95u2jw+e41q
 zCNQkg0NbU9UddYa3kl/04amHxf9yxFHz0kcery0UrdLFQ==

No need to inline these fairly larger helpers.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>
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
