Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc254.phx1.oracleemaildelivery.com (aib29ajc254.phx1.oracleemaildelivery.com [192.29.103.254])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 658BBC43219
	for <ocfs2-devel@archiver.kernel.org>; Sat,  9 Apr 2022 04:52:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=sSjlXjg7KmkVW1i0AI0Q/zXrduiZUudWSBbrqF7bIHM=;
 b=TA3XIrp3M38mbygXVIN9LLyOswCcHH8BMuM4Y5Q2U/JEwGwLyn6YQo2rijJXAMjcsqpIRgZBGf9B
   k3bBTGqupHXSzH7FYqBvOcs5J/JikaZ3ldOpYD9VfYhcf2yj6GKobJxuFIJHWAHU1ZbRz6sRa0qF
   loUAgiOxTx683DvJNrDYupeO0AelKnt4iGODQdwl1CaB32nWSnwBfZggNkVn1NXDsvlZwSPp74y2
   /pH9GchlMawUTo9LkfiBGggS8KkAoh2ht0Yv3qSO0UaUk5FmSfV4DJtXaziM5ePau/yh0I85hiwU
   jS4OJx+N4KJhmwL7l/v3qJKOFCMLurlxClKISg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=sSjlXjg7KmkVW1i0AI0Q/zXrduiZUudWSBbrqF7bIHM=;
 b=c37DhvLUSJepeeOAPr9oaotRc2nTcpJmI+RHlIPA6CYAeUlfUae4czWvaCl2FgCZDTO6+9Tv0+uG
   CIs4hPF/EzYJVisBVKfmGcushh5cIrbblYlxHKq/XTRZ78uFkxSgNXYIvrgupPxbl4K4LSAx3hkA
   oxIvBGJJBtTcgtuWfi1jCgr4TO14Sj2+LsUP/0f7ixjZ/+Usj69e8fZQ6+i0W/QZkvIvlmlhGk6U
   ZL/kxlyeyYnMu6qxfCMkkef9XYiuM6pDXGh6NtjpSlCXCfozHh2YvIuUJzyuut0M6yzNk2gyDrT5
   KFssMigGJitgYecUJu+sG4Y0DHtunw+gxqiU0Q==
Received: by omta-ad3-fd3-301-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20220319 64bit (built Mar 19
 2022))
 with ESMTPS id <0RA2006G72VCY7B0@omta-ad3-fd3-301-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Sat, 09 Apr 2022 04:52:24 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
 MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
 :Reply-To:Content-Type:Content-ID:Content-Description;
 bh=LA03+v2RMrt5LLwAfTBpcNFXpYhSXKyM/LEXrkZN1Tc=; b=TToQ+IG68ZTma6i9nDz6xx4LYK
 D0aw9uFluTWmoLPN8wS4Tw4ptzJ/n+LwG2AuHxcLmQEWYx1aZe+l+/EUb07HA13ebYd+zXWtHqs00
 wx9o5AAPH2KJPl0+jag4OLclg/JD37wQiqgJHq6T1H6FWx+UFz58+SDkab9YWBuWtwT6h/pIgt6FR
 AzrhjmPB8W4cd/F2sRVPHfKdDw0YBBrQTFPQ9a74BSKEWHHl6H0cqEhdUPbu4a8zWq2vD/QaSCtLv
 QCIx9f2iUsf6SUo5Q4SNMv/t99ukC9ZdAasasKnk54ghRUz188l1onQf3RFgK9e1sPw7Yo1mCiQup
 PdxOz5qQ==;
To: Jens Axboe <axboe@kernel.dk>
Date: Sat,  9 Apr 2022 06:50:34 +0200
Message-id: <20220409045043.23593-19-hch@lst.de>
X-Mailer: git-send-email 2.30.2
In-reply-to: <20220409045043.23593-1-hch@lst.de>
References: <20220409045043.23593-1-hch@lst.de>
MIME-version: 1.0
X-Source-IP: 127.0.0.1
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10311
 signatures=695566
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 clxscore=230
 priorityscore=78 bulkscore=0 suspectscore=0 mlxlogscore=999 lowpriorityscore=0
 phishscore=0 spamscore=0 mlxscore=0 adultscore=0 impostorscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
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
X-Proofpoint-ORIG-GUID: Emmi3gecAujEh3p71foqIjRBa1BNrcVp
X-Proofpoint-GUID: Emmi3gecAujEh3p71foqIjRBa1BNrcVp
Reporting-Meta:
 AAEbaJwZyG7UVotcEmXCMu7Q49e2rTl+1K7MjNzxvfdj2Z8qeibhBa+5VuSsHX0h
 CAbfHP7oljkPrpgS+pvfeKsN1DCGDCeic0zcV6h4WSDmY9gM85qhsDvgaQcIRF46
 2S+lOvY5VJcw6O8WIr1hz3b1k2d5906VjMTrzwTpXs5Ay85TXEFHCUuOzkrPvjxv
 UQOBbXfZIewfRroRFROoTRc5W3CtVtxQZZeF1JbjeKokh/VS/CeydnNT7Iv3Bh8B
 ue+ArXC3CGM+AYXAUdOGr1sZ/rQ5d+nNSTjXb+XeIxqWpVNnTvlaE8MP6qY25JFT
 x55dMqwz7HYoCRv6eSq+/coEDSlTZooqUMEML7riwywqoRsIWozb1Aa29WZHNK7z
 1bhBZvamDR19/PK0x/V/pj4ecgqYIwfc2SOW5bv07Kw6wH6qRcnhgKLgFrRA7giZ
 Vi+MDk/B5XVe48/pgoYF7MeyPiEhbMUbuydhsaEO0VeZHit9wijHBUZB2P4m9Rx1
 /agyHscuE+zNsPirylSWFAqJ6TjDQL7Fj+JvDjHc39ZO

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
