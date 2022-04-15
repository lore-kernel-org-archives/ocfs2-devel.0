Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc252.phx1.oracleemaildelivery.com (aib29ajc252.phx1.oracleemaildelivery.com [192.29.103.252])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9242DC352A8
	for <ocfs2-devel@archiver.kernel.org>; Fri, 15 Apr 2022 04:54:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=DCK4VaRpGvRUDCF8GhBjD1BEFFVqBcsrtlrCNGu9fuM=;
 b=UM/YWKOKyPymPvilQPv8rPFFQWlWhjqZf4XIxqFfWeuLTQICZHH9SmZfuPAFYnLPVaOi9LGAJcWE
   OSBx/xJhD4ZSWcQDOx17RcoRUNmqUiYtJaGSfDT2Vs52PexRCWPRvTlLKyWH20kCQ1Dc5dJvxMSj
   grTbgwJOdW1dyh1X+APJLD2Bp1iG0tNrRFnxQBjsu37B/IisSxnI34eY9PsAmcuI2HIvxi4C0PcP
   YqVDCBm1bBg1+vPxmwFzF/mQa8SD0ZIbGAhlarwGHS/66TBkMj56daWB4XW+7kcyx65dv4h/ctCY
   x90QpxnXb7SOSqTzESmUgx92DN8LHApZOevmzw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=DCK4VaRpGvRUDCF8GhBjD1BEFFVqBcsrtlrCNGu9fuM=;
 b=u3YDReP4/k4Ngf96IjJ0iG2AavCZ0GyhyVXmgIdYusRSiPKQyE8s/1EaIy0ZDWwXcog4yBA1cdTL
   k5EJs1/cGrscPdjOfA4c0BchR1MnzUZq6KtAgOrwsBeF4DvOfY6Rl9fTny2K3uJFD9LKAyRDkSJm
   l6AUiZU4keCc+hnyu5KOk/wyxbNwL63IM0G12RAJsnWArtEgP2W4yyr5EfYOgWjxW3+tXczU31T8
   4RJUm4D2NibS8Vu2XIhp/NsDVNtSKAwRJ9bF08ni5qkQr2mygd4EljQtfa5Dl0SV+yqJ/+IDiZih
   2cTF8yFJGsFH7BjxMhEv+ujN+BlmIDeyocQRYQ==
Received: by omta-ad3-fd1-301-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20220319 64bit (built Mar 19
 2022))
 with ESMTPS id <0RAD005XG6Z40I10@omta-ad3-fd1-301-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Fri, 15 Apr 2022 04:54:40 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
 MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
 :Reply-To:Content-Type:Content-ID:Content-Description;
 bh=6r328luNCDNaFOT33dRflffYOj2Ig+snh5CgwFTaxcw=; b=mNuFiFjSDLbldIX31eYOuSlRR9
 8563S/h8LrxYIHowjJfVJZ76RAtIHUbU8W+hFh4MWU8WMYfdB6LyJh2COdvD/iZqFmSUWNE+zj3n8
 TjDK1RADFF2jHuhjgFvsFPr2iNfo2ZxzGPd6/D7n8+r4+csvAbreOAgnv7mb2shTRUMZRApT5F90K
 NcXEn1pmSIjxsyXRt1Q5Fpafq+pdIcKs6RGb6uD0qSORONp8YiTBWhXw1jJiMd9DQ1XNtZR7AS8Rn
 LRWZ13064QQZdYqJpwxZzURW2pQw6Vjn+9nq/BjlV+QBzJ7qa6lBovEI7n8jqfejDLm+YrLORSOW6
 48XX9zTw==;
To: Jens Axboe <axboe@kernel.dk>
Date: Fri, 15 Apr 2022 06:52:52 +0200
Message-id: <20220415045258.199825-22-hch@lst.de>
X-Mailer: git-send-email 2.30.2
In-reply-to: <20220415045258.199825-1-hch@lst.de>
References: <20220415045258.199825-1-hch@lst.de>
MIME-version: 1.0
X-Source-IP: 127.0.0.1
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10317
 signatures=695566
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 impostorscore=0
 lowpriorityscore=0 phishscore=0 priorityscore=203 adultscore=0 mlxlogscore=999
 bulkscore=0 clxscore=239 malwarescore=0 mlxscore=0 spamscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2204150029
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
X-ServerName: localhost
X-Proofpoint-SPF-Result: None
X-Spam: Clean
X-Proofpoint-ORIG-GUID: CmzQEqltmX-XRAFufn50SsBi88_lToGb
X-Proofpoint-GUID: CmzQEqltmX-XRAFufn50SsBi88_lToGb
Reporting-Meta:
 AAH+kgVZA0vYewW9kyiGXo4CGCW5cP4gge7qpYD6fzmuR/LclAi2i55MGlqe1tRD
 pb8XRffJeZ7lspVJEQ8ucd55TerMEgeiGI/63ADCSwCeyYkApiLBF6f/jYNbW1wR
 2HZUpgz7xYDQQnwtDXRW4FWEGYu+z1o0QMgGD5m75ygKPTNQxfS3ULOCYo8DuoGL
 cjVpDbMCePf7lfomjfeUXu3ieKh0jUCphEbvg9Mfcz14eyPIiWVCg+t3WgMK8o7t
 jBx4bLwYjN9UvaqCS1Gf5H6z4ZDFZiXDfRTsHbtjRmUwv0Z3GCvMllvTacxcIn3S
 hb2dsyiOjWuIau2vLhiBfSgG1mdLjj7Pqlr8COKXyBmbVUHQzgOmJp51B9u6vgCY
 jPN4ARJQhwDtXOl4mOncQriyC+U7lom20N4txZYljzKMsg3fpx1vvDgxsCF8ahOV
 4nKrM/2YETixt4uHbija7y/D8/Uq2iQYA5QQ9X5aTkvrspmvjkfCILFEydza8K47
 T0f9o0FpJV297UX8agOZQP+73KGUQNjo6+ieuI+aQ/zYOQ==

No need to inline these fairly larger helpers.  Also fix the return value
to be unsigned, just like the field in struct queue_limits.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>
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
