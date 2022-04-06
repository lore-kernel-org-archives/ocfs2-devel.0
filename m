Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc249.phx1.oracleemaildelivery.com (aib29ajc249.phx1.oracleemaildelivery.com [192.29.103.249])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 77F82C433F5
	for <ocfs2-devel@archiver.kernel.org>; Wed,  6 Apr 2022 06:06:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=hUMG+AmiaqvNYYQL7/mjJYrSAB+dIJaQID+LMIYv+Ig=;
 b=NLBbPeWlyA3uR3/YoPV2ku7NsesIkYj7O5hGkvXK/JZebnEmyxjGCajyaWRxNR/ibpTPFORtZMSD
   MoBYXSiu51Bcb3xn7cmNr7odujm/iDpn+S0AZbZs4bnlgybGf7bkSI5Xw/4onHPYQBPIhs5f98Yh
   8dF34mqWLoYQr0OzTdN/t/cBF/l/xfHz5ubUlQSm1wHEZwRzXGxvCFXiFj0K17vtpBaPatWF0Cjs
   Muwgt9TYgWqmUH1AJxgvqEK3u3/J1jz5W/dE13v9vPK2m9Q4iBSI7iacr7KPNQfpn4+ViOYu666X
   gq8gd6jUrvuqMh5jrGR4q4bmwDySFUp4yZ4RXw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=hUMG+AmiaqvNYYQL7/mjJYrSAB+dIJaQID+LMIYv+Ig=;
 b=FH9cRFwtggi+iUcglvAaZcYguzR1pbWU0BAOSfxXtaRSiU8RYbtxCqi8qUMcdutgwIGg+G99uMUv
   1YxhhTnTfjc34EVLEWrnFyZKfxyVZtnNDUcbcQp4p8gX9NX6lmMFi+DXWUQAYKgk/Cwpns2xkcAx
   3qYGTrkKyjua77+7Eku1BW+pclv+oTRVETS9xt6/J8WJhrjJrv6ud3G4DlpLoO0JdRRfskXHUP3R
   19XMsCc41cOyb3MaW+Qalc2CVd1u9s93QBDt3vdZQ68xwOsCg0RSFL1SUVEfiBo2b2vZ7LLT245P
   faWQfZ2/BhT8h7YheZ7A2HAK4nBo0mocIqef3A==
Received: by omta-ad2-fd1-202-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20220319 64bit (built Mar 19
 2022))
 with ESMTPS id <0R9W00OD3MABLS20@omta-ad2-fd1-202-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Wed, 06 Apr 2022 06:06:11 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
 MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
 :Reply-To:Content-Type:Content-ID:Content-Description;
 bh=8b7He7jKWHmQh3KokdF/PRePZ9Zk3nvKntDAn0vRB+A=; b=0omtD+HQtA616dFivyqA97DclF
 5MCkQ36VFGZAUVgFUJvq7ULB9RxmAnnJK9Ru4GgkOHXwFqXqRHMXQ9LCogkUlyoM9wN6+7J7DekaY
 q43/dVC7g/6yyYP+I8eJgSyycd7IVsGmMYkR1Clskvv1tDsGCaTWuQ8Rrf8sU79R1v0lw2bQt/AWB
 OsOPsydboiChznz0eGpngaPA8w2OVY6Jf3YdqyKDFL16zctVHp5+n0d+GDis8Omgb+WFkLhPwAzdn
 EsF+yQBNP9+37ibHq8jy0MV7lNP50mXC+UwgCTvOjOUrw+1nocIz3QcImLpc9EsYaF5HR/HZej/jt
 LdNiWxFQ==;
To: Jens Axboe <axboe@kernel.dk>
Date: Wed,  6 Apr 2022 08:04:55 +0200
Message-id: <20220406060516.409838-7-hch@lst.de>
X-Mailer: git-send-email 2.30.2
In-reply-to: <20220406060516.409838-1-hch@lst.de>
References: <20220406060516.409838-1-hch@lst.de>
MIME-version: 1.0
X-Source-IP: 198.137.202.133
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10308
 signatures=695566
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 mlxscore=0
 clxscore=349 priorityscore=90 mlxlogscore=999 phishscore=0 bulkscore=0
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
Subject: [Ocfs2-devel] [PATCH 06/27] drbd: cleanup decide_on_discard_support
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
X-Proofpoint-ORIG-GUID: Kle9KH0WF7VAf5n4ueiELpYqsS_gtZnr
X-Proofpoint-GUID: Kle9KH0WF7VAf5n4ueiELpYqsS_gtZnr
Reporting-Meta:
 AAHIpslJAdgF+CXMbjtQ1Sp5bSSBfhjA8d5zWm4mvQFzJ+crheHBQwsAwTZZ4JSk
 NWwKLa8baPicXp+bp556khNFEWmw4Ows3prXwg/cl5TcdDNM+mep4U9iy7t0KfRf
 zpCgxFxDWVLlIo/OJc85F5TmGM9A5+L8blY+XsrImnrNOKWS3GxoI763v+XNcAYC
 zkEqVG8q9dxtY7yLxhp/yXEP16jq+/ZHhHmzNl6T/Ru4OJf8rgRorGIVaM11mBRX
 1pvflSv0H/KLv/8T4yfWchelRrWDQc1UWYAAuKx1nDt0F72BNXjYwzLrGTQyOfVE
 zgij8OPpjY3IgvWJA2nP/ITyS2q082LRp5ll2mP0W/KchToWTXB6MDIvXGe1yJj0
 dMBKOfw63tWEnf4r0IUQH4chVlY1BPPjzdUVODUsatOapRz6F+DWPEbh8I1oqEYD
 wO6zJy8ARVupHU1hK8eCwMoidU0uamuvfSbeDRXxd3ZGSoWSI863AErxpOYL+r/7
 aISMmbFtM9fQIDZ9I04hM8CaC7gXf1bZfnSrngqFHV8=

Sanitize the calling conventions and use a goto label to cleanup the
code flow.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/block/drbd/drbd_nl.c | 68 +++++++++++++++++++-----------------
 1 file changed, 35 insertions(+), 33 deletions(-)

diff --git a/drivers/block/drbd/drbd_nl.c b/drivers/block/drbd/drbd_nl.c
index 02030c9c4d3b1..40bb0b356a6d6 100644
--- a/drivers/block/drbd/drbd_nl.c
+++ b/drivers/block/drbd/drbd_nl.c
@@ -1204,38 +1204,42 @@ static unsigned int drbd_max_discard_sectors(struct drbd_connection *connection)
 }
 
 static void decide_on_discard_support(struct drbd_device *device,
-			struct request_queue *q,
-			struct request_queue *b,
-			bool discard_zeroes_if_aligned)
+		struct drbd_backing_dev *bdev)
 {
-	/* q = drbd device queue (device->rq_queue)
-	 * b = backing device queue (device->ldev->backing_bdev->bd_disk->queue),
-	 *     or NULL if diskless
-	 */
-	struct drbd_connection *connection = first_peer_device(device)->connection;
-	bool can_do = b ? blk_queue_discard(b) : true;
-
-	if (can_do && connection->cstate >= C_CONNECTED && !(connection->agreed_features & DRBD_FF_TRIM)) {
-		can_do = false;
-		drbd_info(connection, "peer DRBD too old, does not support TRIM: disabling discards\n");
-	}
-	if (can_do) {
-		/* We don't care for the granularity, really.
-		 * Stacking limits below should fix it for the local
-		 * device.  Whether or not it is a suitable granularity
-		 * on the remote device is not our problem, really. If
-		 * you care, you need to use devices with similar
-		 * topology on all peers. */
-		blk_queue_discard_granularity(q, 512);
-		q->limits.max_discard_sectors = drbd_max_discard_sectors(connection);
-		blk_queue_flag_set(QUEUE_FLAG_DISCARD, q);
-		q->limits.max_write_zeroes_sectors = drbd_max_discard_sectors(connection);
-	} else {
-		blk_queue_flag_clear(QUEUE_FLAG_DISCARD, q);
-		blk_queue_discard_granularity(q, 0);
-		q->limits.max_discard_sectors = 0;
-		q->limits.max_write_zeroes_sectors = 0;
+	struct drbd_connection *connection =
+		first_peer_device(device)->connection;
+	struct request_queue *q = device->rq_queue;
+
+	if (bdev && !blk_queue_discard(bdev->backing_bdev->bd_disk->queue))
+		goto not_supported;
+
+	if (connection->cstate >= C_CONNECTED &&
+	    !(connection->agreed_features & DRBD_FF_TRIM)) {
+		drbd_info(connection,
+			"peer DRBD too old, does not support TRIM: disabling discards\n");
+		goto not_supported;
 	}
+
+	/*
+	 * We don't care for the granularity, really.
+	 *
+	 * Stacking limits below should fix it for the local device.  Whether or
+	 * not it is a suitable granularity on the remote device is not our
+	 * problem, really. If you care, you need to use devices with similar
+	 * topology on all peers.
+	 */
+	blk_queue_discard_granularity(q, 512);
+	q->limits.max_discard_sectors = drbd_max_discard_sectors(connection);
+	blk_queue_flag_set(QUEUE_FLAG_DISCARD, q);
+	q->limits.max_write_zeroes_sectors =
+		drbd_max_discard_sectors(connection);
+	return;
+
+not_supported:
+	blk_queue_flag_clear(QUEUE_FLAG_DISCARD, q);
+	blk_queue_discard_granularity(q, 0);
+	q->limits.max_discard_sectors = 0;
+	q->limits.max_write_zeroes_sectors = 0;
 }
 
 static void fixup_discard_if_not_supported(struct request_queue *q)
@@ -1273,7 +1277,6 @@ static void drbd_setup_queue_param(struct drbd_device *device, struct drbd_backi
 	unsigned int max_segments = 0;
 	struct request_queue *b = NULL;
 	struct disk_conf *dc;
-	bool discard_zeroes_if_aligned = true;
 
 	if (bdev) {
 		b = bdev->backing_bdev->bd_disk->queue;
@@ -1282,7 +1285,6 @@ static void drbd_setup_queue_param(struct drbd_device *device, struct drbd_backi
 		rcu_read_lock();
 		dc = rcu_dereference(device->ldev->disk_conf);
 		max_segments = dc->max_bio_bvecs;
-		discard_zeroes_if_aligned = dc->discard_zeroes_if_aligned;
 		rcu_read_unlock();
 
 		blk_set_stacking_limits(&q->limits);
@@ -1292,7 +1294,7 @@ static void drbd_setup_queue_param(struct drbd_device *device, struct drbd_backi
 	/* This is the workaround for "bio would need to, but cannot, be split" */
 	blk_queue_max_segments(q, max_segments ? max_segments : BLK_MAX_SEGMENTS);
 	blk_queue_segment_boundary(q, PAGE_SIZE-1);
-	decide_on_discard_support(device, q, b, discard_zeroes_if_aligned);
+	decide_on_discard_support(device, bdev);
 
 	if (b) {
 		blk_stack_limits(&q->limits, &b->limits, 0);
-- 
2.30.2


_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
