Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc244.phx1.oracleemaildelivery.com (aib29ajc244.phx1.oracleemaildelivery.com [192.29.103.244])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B53ABC43217
	for <ocfs2-devel@archiver.kernel.org>; Wed,  6 Apr 2022 06:06:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=CujI9o07ZjZr+qH5+5sr9gHRYcoxIVLhC+xnEhBuSNI=;
 b=GumUM5m8w6a+gg4d1Ir1VJkl9tQIFfjcTwmgpUJXyGqePTK0vINwW/LI9hYkssp0Y5VIMc0m/B3c
   xSKJDM+lE1g7c3hSU3SKwwNYr6lb9/qmRa6R9nDTpeaKm84w6or1u/WqYzGNXL84trwnQsaju3Iu
   GwfAu2KK/RRQC+9gp+4uTOVT3WQJMBCiGsLjNUmIaIGR765O9vVpTu5AzRHsSGuQjkVfYfTJC4Fr
   ZJS0mNCJzn4GpIs2PUa5zmUoDVpPbUKZlCBUWMRT8pl4FHWHq4eXrtQqZyM2E2eByD63WD8ACsPF
   VIN5kVZoYFRdyi/c0E/vr6LcgnmixGin9OeUWw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=CujI9o07ZjZr+qH5+5sr9gHRYcoxIVLhC+xnEhBuSNI=;
 b=NXYNrtd0qzsh9hsxtKwEr62UGlJ7KgjRs6GAeJj8V502CZhCeTgpRcrfcOxMm46V3g/tswYkCC+Z
   bzX0cErYn81Oj3WBrFXq32MGKQaoib1eO8yB2v8rK8PS1bQooGynvpvzEtnhqDsyQfGeV0tNcCyQ
   nALsV4MdkWwInrinDZa5a8waswc5/RI187KfRPplXz0C/2iONz2MhMXFjLwSZJ8oMHjO/C8EWkhy
   ei0njsY3dzovpbVhcWuGtPRbAItu9Oc9mpft3tDC2A0rzNc0dm/lx7Fif3iwPj41x6EM/OVXTa6v
   UssZvOzYeFYk4e7CBCO/vMNaO/uCdqfmPfCC0A==
Received: by omta-ad1-fd1-101-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20220319 64bit (built Mar 19
 2022))
 with ESMTPS id <0R9W00HEMMA6EN80@omta-ad1-fd1-101-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Wed, 06 Apr 2022 06:06:06 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
 MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
 :Reply-To:Content-Type:Content-ID:Content-Description;
 bh=cTLTfYr7duFMbl13zCRXcRUBgEmH7Snqn+WlWdpEWNo=; b=ZV/CVrUb4qbpXBUImFAvqmY7OC
 YR/KmNB2+lAjq+EqA8oBYfyehyx3Nq+YwtV4TxCIA5A8L2WVXtNlev4guWoUuadGmFOwtgMiNwq9i
 yqX5G6E2+zNceTQVJtjM3l08MHhteYnLHXffM4/jtc5yfz/GeuE8HPUJ4reOje5U615tM7p768ryF
 Y/h9+5h+K+8NlHUqGExK7MtGefB5aNgyMmSmLlNaZTgeiyQAt5+xaIpSgQ/+zSSJmDjA+IoRmYh1L
 IwncIh14NoCZ6DbOmIaikx8OL30Ru/YZRUBoYvofpcHUxFXkbbQXdd7v+XeVl55WVE6NwYrNNaEln
 SKW/g4CA==;
To: Jens Axboe <axboe@kernel.dk>
Date: Wed,  6 Apr 2022 08:04:54 +0200
Message-id: <20220406060516.409838-6-hch@lst.de>
X-Mailer: git-send-email 2.30.2
In-reply-to: <20220406060516.409838-1-hch@lst.de>
References: <20220406060516.409838-1-hch@lst.de>
MIME-version: 1.0
X-Source-IP: 198.137.202.133
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10308
 signatures=695566
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 mlxscore=0
 clxscore=349 priorityscore=60 mlxlogscore=739 phishscore=0 bulkscore=0
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
Subject: [Ocfs2-devel] [PATCH 05/27] drbd: use bdev based limit helpers in
	drbd_send_sizes
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
X-Proofpoint-GUID: sXAhAXmseLgls-njW0EW4CWlENAGH3vW
X-Proofpoint-ORIG-GUID: sXAhAXmseLgls-njW0EW4CWlENAGH3vW
Reporting-Meta:
 AAFlSDaM+Mj9sXmHdhW4acBOHw33/92ryK8g4IaW8iqakILVtuQBIxVtqSqCG9I3
 k+K71cC0ilw3tmLnZUwIq3c4TAiPZMcIt8Htfoe/wWvMouNS9GNzXk8kXat4AYN9
 WRd8D/3/rL8wcPc3ZUPjE4aOGd3qPSXJx5Qaeod/knYL7z1nzq50K+a1EZMk/oaL
 /fz2lE5mljCVv9hUBMZ6iq9DyG5VySYefEG8Qq+SitYTD7r1JGR4LAtWAlLD2G+U
 FvFOMchJei4o5axzBh0pGxO+i0zVQUv2BFVGbOUKSxLcpBDS/7EjK5X/T8xE3BHG
 dCXArzMHxwURllprCFQojXtCAUfi/2Ba+qfeigd0GpNyvbkG3KOR+5I1SJA2tRAD
 O82XEcDn91iXVLVNCIQn/mrat2pBWhvbAWkmDqao/wqyl9B8I3RpexzCoxLT0Hh7
 DflOG273DG37oGrrhXAxVdt6P9XGDnfvYO8wRmL43unS7vRiucfE+spYBBocXWwj
 +TM/pJhE/vjZNoBMGuw0AyLBVu4e5Mr7NGL6Di2etsU=

Use the bdev based limits helpers where they exist.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/block/drbd/drbd_main.c | 15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

diff --git a/drivers/block/drbd/drbd_main.c b/drivers/block/drbd/drbd_main.c
index 74b1b2424efff..d20d84ee7a88e 100644
--- a/drivers/block/drbd/drbd_main.c
+++ b/drivers/block/drbd/drbd_main.c
@@ -924,7 +924,9 @@ int drbd_send_sizes(struct drbd_peer_device *peer_device, int trigger_reply, enu
 
 	memset(p, 0, packet_size);
 	if (get_ldev_if_state(device, D_NEGOTIATING)) {
-		struct request_queue *q = bdev_get_queue(device->ldev->backing_bdev);
+		struct block_device *bdev = device->ldev->backing_bdev;
+		struct request_queue *q = bdev_get_queue(bdev);
+
 		d_size = drbd_get_max_capacity(device->ldev);
 		rcu_read_lock();
 		u_size = rcu_dereference(device->ldev->disk_conf)->disk_size;
@@ -933,16 +935,15 @@ int drbd_send_sizes(struct drbd_peer_device *peer_device, int trigger_reply, enu
 		max_bio_size = queue_max_hw_sectors(q) << 9;
 		max_bio_size = min(max_bio_size, DRBD_MAX_BIO_SIZE);
 		p->qlim->physical_block_size =
-			cpu_to_be32(queue_physical_block_size(q));
+			cpu_to_be32(bdev_physical_block_size(bdev));
 		p->qlim->logical_block_size =
-			cpu_to_be32(queue_logical_block_size(q));
+			cpu_to_be32(bdev_logical_block_size(bdev));
 		p->qlim->alignment_offset =
 			cpu_to_be32(queue_alignment_offset(q));
-		p->qlim->io_min = cpu_to_be32(queue_io_min(q));
-		p->qlim->io_opt = cpu_to_be32(queue_io_opt(q));
+		p->qlim->io_min = cpu_to_be32(bdev_io_min(bdev));
+		p->qlim->io_opt = cpu_to_be32(bdev_io_opt(bdev));
 		p->qlim->discard_enabled = blk_queue_discard(q);
-		p->qlim->write_same_capable =
-			!!q->limits.max_write_same_sectors;
+		p->qlim->write_same_capable = 0;
 		put_ldev(device);
 	} else {
 		struct request_queue *q = device->rq_queue;
-- 
2.30.2


_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
