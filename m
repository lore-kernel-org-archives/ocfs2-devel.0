Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc248.phx1.oracleemaildelivery.com (aib29ajc248.phx1.oracleemaildelivery.com [192.29.103.248])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7C788C433FE
	for <ocfs2-devel@archiver.kernel.org>; Wed,  6 Apr 2022 06:06:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=nitABGBatfw5GUBEtEmFBmurm3W9XyKTWZBl2yZHXcg=;
 b=xfyADPtg75C+si3ZDYP2liKUg72RxI6vD7G1Q3c/dLcek9FffXI6xM+Za4DyU0dA9R3qENyMi2Rm
   7ErxyFOn51Z5BmN3gO3rs+h2FScIH/CFtM+m2Q2D5eB1ymxFyysxyDjDn7QYJna1Ksp07e6ldo90
   UgpXLquffiOrQn3CLVeyMv3lL0lXmX1t9Z28ejq3tv9zIJrckCrA0/TOUnuPJ+d1Rvaz/LGMjcvN
   eu89QYSmk8FRWJ90QWjycJCY05XeCX5tLJTckGWYXJY531VgtgWQBpxMCWyrqKqBVd0X/rxO8zPZ
   +sIdEcHNzNlW16wjUNOyl7XPx+adjX+uGNR06Q==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=nitABGBatfw5GUBEtEmFBmurm3W9XyKTWZBl2yZHXcg=;
 b=q2K44x+KZUEduKwdUA5yxHaldSGYgTvJ6AJc08QSyAlD24BIOImybmpzj6hmnuemz9JBStX+4fQf
   W0FVAccYCI0CpPBtzxwSQ+FoX6F3bS3eamWGVRtJQTs6FZ88ZyddLWW6DvlU7mlNrY8G47CmV0bm
   tyH4h8RC0/jSpgOi1+vyY5sbF2sbdA++V9d81iRAs5wjSA7GaxH63fl4zdn7bu+WtbyOSgVNDUmO
   QxioVJvDTOHlSZ13hmrU30Sd3JBgaXKc186UbxegkJpDdtn4fbCxQ0h7JhwENLebmLLsoex/CJUF
   6VuGcZrZcAbo0h0LaE8oPzMnKjJbORyfbONHSg==
Received: by omta-ad2-fd1-201-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20220319 64bit (built Mar 19
 2022))
 with ESMTPS id <0R9W00HHBMACU4C0@omta-ad2-fd1-201-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Wed, 06 Apr 2022 06:06:12 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
 MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
 :Reply-To:Content-Type:Content-ID:Content-Description;
 bh=WTqESTvtfO4RX0qAqhs2oFd2Ik59q54vLqp/V/y7bnI=; b=FyJUmCuIohn+Rc7Inqu3BniYMO
 qIbi7WgRq0N7qblPyTDtikeMFm5V1dbLiaJQYES35HwVVDM5F002rNedhKojSjZSangf3g4TTB5H8
 ose/VQW92oLsoNNnrgmuQ76bdKKE4T6Y3dmmZVsUWsnsPjVGMnUiPjquePmKO+IeMAi+ZQQvMCCYS
 5PMGec+vFR133rAMQYM0lD1ltqCTBtpWog3Ko4h+ioJJRDUI+WLYZoytyDGy8Ig1GoZQ2cZVQBaiq
 VeAMRPUX1EVBht4ncdSOvQy0zHk56lci0PZ4ia4LUpztUXudJZTNfnXGvXSxvvSo+c89mmlg6GRYS
 FB4ItY+g==;
To: Jens Axboe <axboe@kernel.dk>
Date: Wed,  6 Apr 2022 08:04:56 +0200
Message-id: <20220406060516.409838-8-hch@lst.de>
X-Mailer: git-send-email 2.30.2
In-reply-to: <20220406060516.409838-1-hch@lst.de>
References: <20220406060516.409838-1-hch@lst.de>
MIME-version: 1.0
X-Source-IP: 198.137.202.133
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10308
 signatures=695566
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 mlxlogscore=765
 malwarescore=0 impostorscore=0 phishscore=0 spamscore=0 adultscore=0
 suspectscore=0 priorityscore=138 clxscore=349 lowpriorityscore=0 mlxscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
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
Subject: [Ocfs2-devel] [PATCH 07/27] btrfs: use bdev_max_active_zones	instead
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
X-Proofpoint-GUID: eFUanbdPMqmePdh8nzPCAfwKdcbttFgf
X-Proofpoint-ORIG-GUID: eFUanbdPMqmePdh8nzPCAfwKdcbttFgf
Reporting-Meta:
 AAEaKWhG9lXDenwEx7H4q3zjefPW8eX36bLklhMblUJt+nyynfoHQKz7GxJyIeU/
 idSobG+N5R5kBc3YOTbT/4J4PQM+ddEEdue373o79stdxxjpA7SciA7MgKSgXmDr
 DsyuAEl5oQisOpbI1IVP3BHbdEhZQvGeoIImsXT2N6fBn0xOkfBhDmzXsAIl0POb
 KnHHNk1skgaMI57jxIWmmJsHn6KM9hEysHgjTS67rU5LWCAIpV22cOAXt8aWW3yT
 YSHUIBufFiC0ZJuunBtIERgT0U3b/ywGS32x+cafvDV79kjaZGfmf93YsT2GQhsZ
 u5+aI9naem88JkOPbHTWQ8iBukS6GrK1o7ojoI7b1zJF5jpJ0WZT5OVknG3nZDNn
 FUQWn0ETpwUYiMDPcTmqs0Fz17aUROgIS7sSp24VhaWfUQuA8+Tf5pL8odLLslEj
 1QdY6W6dAHPeCUPhx9Z4J2tzCnzegjH+n3KjZlKTf3wKV2v3K8bi9SK9CXwkyzLg
 8x41imGUABZoBq2z+j+6pMIkvWDjtp2C+V8knP0oYzs=

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/btrfs/zoned.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/fs/btrfs/zoned.c b/fs/btrfs/zoned.c
index b7b5fac1c7790..5b85004d85d6c 100644
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
