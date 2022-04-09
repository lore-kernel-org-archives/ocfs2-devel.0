Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc252.phx1.oracleemaildelivery.com (aib29ajc252.phx1.oracleemaildelivery.com [192.29.103.252])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 84F37C433FE
	for <ocfs2-devel@archiver.kernel.org>; Sat,  9 Apr 2022 04:52:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=DCK4VaRpGvRUDCF8GhBjD1BEFFVqBcsrtlrCNGu9fuM=;
 b=X6vmY7q1f19rWVvniGuNgkDQ1LgwKP9GuhfmShssINC+nnZeXJOFVBimcb++/aiHZveZmUw3YYqz
   vmwautoWIrzf780pCDXbcpYEUrRUQaS5HXB0FckvI7DKycOaYdTI5I4OeryTaiHoZiAt7hlrIZh8
   szTtz8eTI0uKSluRehTgvic8VAxw06Sx6p5lUFudkqxd39DrBNnEznLr5R6bOmRByUaW9dq72qpm
   GswfdJ51IXK2v6xctplBGktWblO2166HtzrF9IjGBJyu0EJ46Ktos6dhhbvq2CIIe+mMf9kxYwuX
   ALdkrHKGy/Qxu1iSvEze86aLyXM2Taa2Lkv8sQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=DCK4VaRpGvRUDCF8GhBjD1BEFFVqBcsrtlrCNGu9fuM=;
 b=EAmfNjhRXWCW2ftha0QVN9QYm57YlWwHpuQC1py1J066y2f0992Xn972YpJTs802Hy80lW7fruPm
   7t+euv5HTmdb9mdbrrks/YcWJ12jvATw+yGTOQcsO9IxadWk7vT3J/ppNY2DhojgJL0cZg6U+vx9
   5fxVZicRCVhNVlZVWZo13LKhMSXZYxaJvSSRAbCUGOl9SZ4/bcWO1ZWbaNNfSSOexqyemhW3YVVY
   G3LdGGyM7geX3qnHIqHIMYhNc47GZCxs0/mcFvgOrWF4Wb1rIxviuwjz0IXaXCMQ7cCaoUNJJd/T
   OMN20yrJliEWWwcWo/+50aKZnqjvcxev+Ch14g==
Received: by omta-ad3-fd1-301-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20220319 64bit (built Mar 19
 2022))
 with ESMTPS id <0RA200H692VMAE40@omta-ad3-fd1-301-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Sat, 09 Apr 2022 04:52:34 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
 MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
 :Reply-To:Content-Type:Content-ID:Content-Description;
 bh=6r328luNCDNaFOT33dRflffYOj2Ig+snh5CgwFTaxcw=; b=y5la5uK0xpIhSXtbBy/onPBwBU
 FwHrEP+WgCDZWr9RLCmtiWZSBy3JZlP6LxFpLTBM+Nd9/2cM4fDgGet2bc0H2JEDJaYCnGjCubDq2
 Hs9FWJmFBvCUS8AQuenxCnFR0cA41FyTmlSTltbkCVEHfSM9sSnD7oPEGCN8ZX07uJjnHoINaZAsZ
 npSJrgPfthjgK/j1zKU81zTY86HdQv5lyyod3YfTKkYVFRwo/gHNLmU33ucR809tSrrS9oMBFQRBz
 lw/QH9mmRBGuHmyXN8YuW/Z648JV/+xEquH5iy/QTyXSZMkqO0YMVV1cNnL6OuVpWP4hui/t8N1mQ
 LEn+3oVA==;
To: Jens Axboe <axboe@kernel.dk>
Date: Sat,  9 Apr 2022 06:50:37 +0200
Message-id: <20220409045043.23593-22-hch@lst.de>
X-Mailer: git-send-email 2.30.2
In-reply-to: <20220409045043.23593-1-hch@lst.de>
References: <20220409045043.23593-1-hch@lst.de>
MIME-version: 1.0
X-Source-IP: 127.0.0.1
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10311
 signatures=695566
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 impostorscore=0
 suspectscore=0 malwarescore=0 bulkscore=0 adultscore=0 mlxlogscore=999
 spamscore=0 clxscore=235 mlxscore=0 phishscore=0 priorityscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2204090027
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
X-Proofpoint-GUID: EZDxTRl3U3B_zk5y76i5ZIV8szW5yEwf
X-Proofpoint-ORIG-GUID: EZDxTRl3U3B_zk5y76i5ZIV8szW5yEwf
Reporting-Meta:
 AAEkcv24sjpkyNU35BOp+ETJ2rWlvMR3b4Mhqs397MlYdLaQ9bTXpG5J4mBLulWK
 hRfdMQLTHJkFw7ebVKCWt5UIzQcriSnXI3cltjQZkIXQErA2GJ1F04BhiJKo7ezf
 z6X7G3Y9Lme8Kx8wrPdcWYhknjvwYBP2BjCx+X0AKgE9H5BNclgyd07B+3aDBeLi
 dGA9gHkItT6Y9gUyi5y7QskTLoEQ6/8qMYoxSXMnank0Puu+37K5aixctCb6eZDp
 1YVC75jSgkTs9M1dUlPHXFg/G9jJyJaRMWMn+32WlwxBMqrgnianiQB0x2K5Hmi1
 ZvJopugQREaVPzL+D7CNjaAgGoK/BmNotYu432CS6YjnrOQfBHzjjWmeJ+d301NS
 x8fiHb6+6d6t5GK9Z5Qz1IYF0m0Bjx15oWGqBkREvRCy1AOIY05Vw2aTfFeYQXlB
 UO6Wy/F20KWb9i1z90umHl29/rZS1XjO3Gu7XRA7fvfHEe2S8/L5TVOKwX9JzBRg
 BFV/YSghWntXG+/uS9SivYj7kiuSZgNdLAjCnTQDhv1T

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
