Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc253.phx1.oracleemaildelivery.com (aib29ajc253.phx1.oracleemaildelivery.com [192.29.103.253])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 22C38C43217
	for <ocfs2-devel@archiver.kernel.org>; Sat,  9 Apr 2022 04:51:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=HSz1naRk2kl39FlTSBip8BGG7fE0oXLO4LbV5an+Kvg=;
 b=jRo/vFk1wAd/3+qAengic/C3A/2Yh+fu8xgxkG1QDVILOrEswMtLeoKMHkjGeV2ZTeByRTsNBzRN
   JgKTeqAwG+aLywRK7NIHh5eYfd/dlYw46pwxO5Obn+MqZDvda1Si1vj0t6M0Mox0eCBDHVxDB3qP
   nTogvZFWtb/qLbMYoKM28/ySzr0sub+Pjka0ncRDqCxVOtqj8HiRTAZRL/fh7+MmRxmX36mej4VK
   BledZubn9xgovZC/rYslej19NbqVWHUZs8ERK2K6tQ+I7G/GvpNpc7qfTm/KXl1KpaGohx0yFlcA
   +XgHywl/sA5FCTBRJPBsEzWkc9fdorHQK0icIA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=HSz1naRk2kl39FlTSBip8BGG7fE0oXLO4LbV5an+Kvg=;
 b=h5nNCZjkAbuZSCScAC3pXmRQUkVFYXYRpVBkRbJL7RekId8xwszgyA6xfa3U78C6qOmmVlwN2xIy
   hZMJPRy5eE1IG01Ynq7fkbv+BVqsKgMViauK8xfLiZZT/ZA+/R+cgJLNdAUFWS2oUB/MDTk/0/Hn
   gEeqQ1grIPqbQczLICAE+MWM4xATyZfT39j3EaIQr2bW99HFHiMijT/byYI/Zewdbwuw4MbkY25o
   qMdjSjYiZXkTn5vNiuZxOZw684tmqN5m/kv3akr0r8jD/dAKE/wmtt1UzzYN3fWDmpf6ecxbuDXg
   Qk3KKTbzTlmsu8Q1zKYCJbOgrxUTqXk+DrLfew==
Received: by omta-ad3-fd1-302-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20220319 64bit (built Mar 19
 2022))
 with ESMTPS id <0RA200FH22U6X960@omta-ad3-fd1-302-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Sat, 09 Apr 2022 04:51:42 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
 MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
 :Reply-To:Content-Type:Content-ID:Content-Description;
 bh=fGcL4rT6o55inYg+xD7k4NQPOksglZvB+PFSEP+xhA8=; b=x49SryV2SEOzb+YKli0UJZwys7
 Znb1rsPTkSfYcHPVo9D6b2U83E7uqw2G98XO8zYfl/hKwrvVhicKgqjDvuZYTEB489P843L//CwDT
 gqCbBf9JUwJ6J0Nu3a/lcC/IfwnnEVdVHN84pWvuhxzJiYH6crHhPnTIzf9dIWY5MLhKlVfzyM0Vq
 bwRuU6hgXkjUYp1qcxu8V6Fo824rSDUIbNTnNROyu48YrBGf3oVsysJ9CQPrqpevcWLNQdLnu2N4C
 4XspCM6we8vYPn8dRLL0TG98f118C88z+RALpryzLlARTzoVN3y6dQTJp4lOBr41BAbVo0sl+miwh
 a6JWWqsQ==;
To: Jens Axboe <axboe@kernel.dk>
Date: Sat,  9 Apr 2022 06:50:24 +0200
Message-id: <20220409045043.23593-9-hch@lst.de>
X-Mailer: git-send-email 2.30.2
In-reply-to: <20220409045043.23593-1-hch@lst.de>
References: <20220409045043.23593-1-hch@lst.de>
MIME-version: 1.0
X-Source-IP: 198.137.202.133
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10311
 signatures=695566
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 priorityscore=60
 lowpriorityscore=0 bulkscore=0 suspectscore=0 mlxlogscore=775 spamscore=0
 malwarescore=0 mlxscore=0 adultscore=0 impostorscore=0 phishscore=0
 clxscore=238 classifier=spam adjust=0 reason=mlx scancount=1
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
 Johannes Thumshirn <johannes.thumshirn@wdc.com>, linux-mmc@vger.kernel.org,
 linux-f2fs-devel@lists.sourceforge.net, linux-xfs@vger.kernel.org,
 ocfs2-devel@oss.oracle.com, linux-fsdevel@vger.kernel.org,
 ntfs3@lists.linux.dev, linux-btrfs@vger.kernel.org
Subject: [Ocfs2-devel] [PATCH 08/27] btrfs: use bdev_max_active_zones	instead
 of open coding it
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
X-Proofpoint-ORIG-GUID: zzXZ320nUrzl2Qffxdysba8NVXNeBkGH
X-Proofpoint-GUID: zzXZ320nUrzl2Qffxdysba8NVXNeBkGH
Reporting-Meta:
 AAHdc3hUrSXKHm+eKxeq86a5UhRuFmxwX4y4jhnVeChEx4HABo6YOjg+3FB7yETs
 s8+zPhjlUfVbrdzYlM0NS7eG0UMxOK9CLbi8I6AMbij00VkaI4Wa7t9XGTXL6wSJ
 sODIqaDqR4LACW/WEV+/qmu9nC2HeZtrhPVapnWpgOve+t/LMPGxKYJWdLCnloeI
 s6C+NOLK03XAphRNZ8xXk42xmUEAhRthps8chPxfWRLkjJ2HO72ZyhJ2UQRhlZFT
 bGx3tJAd6nmUHZ+ySCQy6KysVnDqoSB8QKigzd8CrgifRL/q6cNYnbWqXXYSeBf+
 TFXvom2C8g0f1fB8xniecBk6E4fgkjlX1DM+fIVD+pdK1jdsqjtNs0A6mAn+4ky4
 eSzsQMsZjKykohX5XgIifP1fSLcnjedHF7B7iyXi+axrOrSSkGPcA6j7eZEynX6d
 FC3U8BPI7myMi+TiXY94BjJgxV96xUlqE5QYdBdQtooRftrJazGa7WGKYUpJzaDg
 1nUwlzx0+DdckOg5ZAOSIOLC228Revv399OHcXkN9c/h

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
---
 fs/btrfs/zoned.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/fs/btrfs/zoned.c b/fs/btrfs/zoned.c
index 1b1b310c3c510..f72cad7391a11 100644
--- a/fs/btrfs/zoned.c
+++ b/fs/btrfs/zoned.c
@@ -350,7 +350,6 @@ int btrfs_get_dev_zone_info(struct btrfs_device *device, bool populate_cache)
 	struct btrfs_fs_info *fs_info = device->fs_info;
 	struct btrfs_zoned_device_info *zone_info = NULL;
 	struct block_device *bdev = device->bdev;
-	struct request_queue *queue = bdev_get_queue(bdev);
 	unsigned int max_active_zones;
 	unsigned int nactive;
 	sector_t nr_sectors;
@@ -410,7 +409,7 @@ int btrfs_get_dev_zone_info(struct btrfs_device *device, bool populate_cache)
 	if (!IS_ALIGNED(nr_sectors, zone_sectors))
 		zone_info->nr_zones++;
 
-	max_active_zones = queue_max_active_zones(queue);
+	max_active_zones = bdev_max_active_zones(bdev);
 	if (max_active_zones && max_active_zones < BTRFS_MIN_ACTIVE_ZONES) {
 		btrfs_err_in_rcu(fs_info,
 "zoned: %s: max active zones %u is too small, need at least %u active zones",
-- 
2.30.2


_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
