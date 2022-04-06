Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc247.phx1.oracleemaildelivery.com (aib29ajc247.phx1.oracleemaildelivery.com [192.29.103.247])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6F19FC433F5
	for <ocfs2-devel@archiver.kernel.org>; Wed,  6 Apr 2022 06:06:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=zcj+35EfvyCXFOnqbudxtZwilYswOj8TS3ByEi0ZDz4=;
 b=AOVPi+cb5FnftoMYDAdYScI2Xnqvfr5uCeDyp3YxcruL7U5BKrzUU2EQwgdPxNBO8aSvY7dwe14Q
   zgG5AwVC+3mSh9H5w3BNSGMgHvGSSO4ZXh3G+DcfTNeM0JOfedcGuC89uOpg3mmr208Q8TLdnU9/
   EQ5fzCyS59gNkxD3JtVwEtS8pU1TcnCt9VA6pFlyJuT+H8J0MyJG2waJZizYQ0k0Yv0oOT4g+78Y
   YS8+q6x5Xz/7TuVigrp+JrRf5ZzP/bi/xNfmFc9aBe30PIr9LXEKM38v1uPHQfV+OP+PC6Rjgm3l
   J8v1oh6u/LHLMPvaWkGzWvgRRIl8i7wSIOu8nw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=zcj+35EfvyCXFOnqbudxtZwilYswOj8TS3ByEi0ZDz4=;
 b=HfIOMRoD9hKSXPFzZBzLoMVBbTnMBoriUHfeRT/2o1LhNgXnWf0cwQVBZM12A72BFx7VWeuWR8Zw
   e50RLxPM2qvr9PHvJRLSm3OMxtVSZWnMAE6z70k6Nzp4b0dNcmWAwSf0siZRthEy6dN9ZbR9+CKQ
   3I3wUG7X3Qrzmnhp+s4QyVLSpWL7I4l/8QJWb/ajzfi3mOvAxuOJqRK7N17m8K6Mq8QAeTh8OOV3
   ay0Z3jFLXCr9QaQhPjw6iNQVipKyUPRC+ZZIKBaX0/nBLsdRsUPVBuRP4mRrUkSUAxBoi0iBkZhi
   W82D8q7Dl4TENhyT3byq80a4OJ0LnFgQ3qzVdQ==
Received: by omta-ad1-fd3-102-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20220319 64bit (built Mar 19
 2022))
 with ESMTPS id <0R9W00IIFMA12A30@omta-ad1-fd3-102-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Wed, 06 Apr 2022 06:06:01 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
 MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
 :Reply-To:Content-Type:Content-ID:Content-Description;
 bh=/VNrmVLKJsV7GQx7u+KW8uxbxcNBucKPfMuXZQkRDHQ=; b=jUohBlSW5WCTj76GUqjnlp1cx5
 z/8reyGnmSuZxtLQhg0+jPM694lAAGAWkh+U5eA0mLRb/AgwoytsU4FvpOxPiaD65mDm8lb2j+qF+
 t2HhJ4QddOVy3JK4d1MJddTe+d8VeGKgECeUXlf8UuGagztCqguNxvWacMCYDX5JxNW2p2RbmkW3q
 t71K7/u0ylDWs298FO9Gv20PpcvMYBl6xYylCqBoDNwcq28w+01w7woZnggq/4L3O2hqvwkL98w78
 x+x48h7Ao9LR48caKh9KX0fOy8aRUWWr0Tn3zUQaZ8j0meUpDZjDCysoSXFvl3p+a0P+BJJFXzCv6
 7D21c1Rw==;
To: Jens Axboe <axboe@kernel.dk>
Date: Wed,  6 Apr 2022 08:04:53 +0200
Message-id: <20220406060516.409838-5-hch@lst.de>
X-Mailer: git-send-email 2.30.2
In-reply-to: <20220406060516.409838-1-hch@lst.de>
References: <20220406060516.409838-1-hch@lst.de>
MIME-version: 1.0
X-Source-IP: 198.137.202.133
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10308
 signatures=695566
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 spamscore=0
 phishscore=0 mlxlogscore=803 clxscore=339 bulkscore=0 lowpriorityscore=0
 impostorscore=0 malwarescore=0 mlxscore=0 adultscore=0 suspectscore=0
 priorityscore=145 classifier=spam adjust=0 reason=mlx scancount=1
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
Subject: [Ocfs2-devel] [PATCH 04/27] drbd: remove assign_p_sizes_qlim
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
X-Proofpoint-ORIG-GUID: 64ljOtAJk8SFc1wwP6yJ2WjQfu0B-X6m
X-Proofpoint-GUID: 64ljOtAJk8SFc1wwP6yJ2WjQfu0B-X6m
Reporting-Meta:
 AAEaKWhG9lXDenwEx7H4q3zjefPW8eX36bLklhMblUJt+nyynfoHQKz7GxJyIeU/
 idSobG+N5R5kBc3YOTa//4J4PQM+ddEEduce+dThGHFGTGia3qmkD2drodgIeIjw
 8qeAeB7vLqn0Td42M/4mk4RacyXmF866fSY06zzFOu4uCZKjx6tkpSL3CPn0QlEv
 z0aKG6heNJcCxJQrh3AOaNxEhZ4+6Za/dKYu6TNx8ojvWwSXZcWM3itKaJSLdxiA
 1awuuzc6QsBWrpKAEZfG7TYUBATc32k5Y2MgFveniPRmybKW9F3n0DWjh05VzvZ7
 TMGjd7BqehChmqH1fxfJBDyyg7SSz/hWSGCvo4WAfRM1+2KEKNyAgwraAyO6awkk
 0AI2phNv7pVAsC4koVZ4CSSXpkB7bSqrt3QUG9x8EytmGarwUOPUtZqB0voH/F63
 rAsvYcd/I+5icNCCAykoBc8NL8w7wf0eofoJTGjFe5pnd17zjhQZ4jsMeEAfTFC4
 xCZry/1cEwUx0u7WJKWRwFRBm+wITfCjd0MaF7pmMP/D

Fold each branch into its only caller.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/block/drbd/drbd_main.c | 50 ++++++++++++++++------------------
 1 file changed, 23 insertions(+), 27 deletions(-)

diff --git a/drivers/block/drbd/drbd_main.c b/drivers/block/drbd/drbd_main.c
index 9676a1d214bc5..74b1b2424efff 100644
--- a/drivers/block/drbd/drbd_main.c
+++ b/drivers/block/drbd/drbd_main.c
@@ -903,31 +903,6 @@ void drbd_gen_and_send_sync_uuid(struct drbd_peer_device *peer_device)
 	}
 }
 
-/* communicated if (agreed_features & DRBD_FF_WSAME) */
-static void
-assign_p_sizes_qlim(struct drbd_device *device, struct p_sizes *p,
-					struct request_queue *q)
-{
-	if (q) {
-		p->qlim->physical_block_size = cpu_to_be32(queue_physical_block_size(q));
-		p->qlim->logical_block_size = cpu_to_be32(queue_logical_block_size(q));
-		p->qlim->alignment_offset = cpu_to_be32(queue_alignment_offset(q));
-		p->qlim->io_min = cpu_to_be32(queue_io_min(q));
-		p->qlim->io_opt = cpu_to_be32(queue_io_opt(q));
-		p->qlim->discard_enabled = blk_queue_discard(q);
-		p->qlim->write_same_capable = 0;
-	} else {
-		q = device->rq_queue;
-		p->qlim->physical_block_size = cpu_to_be32(queue_physical_block_size(q));
-		p->qlim->logical_block_size = cpu_to_be32(queue_logical_block_size(q));
-		p->qlim->alignment_offset = 0;
-		p->qlim->io_min = cpu_to_be32(queue_io_min(q));
-		p->qlim->io_opt = cpu_to_be32(queue_io_opt(q));
-		p->qlim->discard_enabled = 0;
-		p->qlim->write_same_capable = 0;
-	}
-}
-
 int drbd_send_sizes(struct drbd_peer_device *peer_device, int trigger_reply, enum dds_flags flags)
 {
 	struct drbd_device *device = peer_device->device;
@@ -957,14 +932,35 @@ int drbd_send_sizes(struct drbd_peer_device *peer_device, int trigger_reply, enu
 		q_order_type = drbd_queue_order_type(device);
 		max_bio_size = queue_max_hw_sectors(q) << 9;
 		max_bio_size = min(max_bio_size, DRBD_MAX_BIO_SIZE);
-		assign_p_sizes_qlim(device, p, q);
+		p->qlim->physical_block_size =
+			cpu_to_be32(queue_physical_block_size(q));
+		p->qlim->logical_block_size =
+			cpu_to_be32(queue_logical_block_size(q));
+		p->qlim->alignment_offset =
+			cpu_to_be32(queue_alignment_offset(q));
+		p->qlim->io_min = cpu_to_be32(queue_io_min(q));
+		p->qlim->io_opt = cpu_to_be32(queue_io_opt(q));
+		p->qlim->discard_enabled = blk_queue_discard(q);
+		p->qlim->write_same_capable =
+			!!q->limits.max_write_same_sectors;
 		put_ldev(device);
 	} else {
+		struct request_queue *q = device->rq_queue;
+
+		p->qlim->physical_block_size =
+			cpu_to_be32(queue_physical_block_size(q));
+		p->qlim->logical_block_size =
+			cpu_to_be32(queue_logical_block_size(q));
+		p->qlim->alignment_offset = 0;
+		p->qlim->io_min = cpu_to_be32(queue_io_min(q));
+		p->qlim->io_opt = cpu_to_be32(queue_io_opt(q));
+		p->qlim->discard_enabled = 0;
+		p->qlim->write_same_capable = 0;
+
 		d_size = 0;
 		u_size = 0;
 		q_order_type = QUEUE_ORDERED_NONE;
 		max_bio_size = DRBD_MAX_BIO_SIZE; /* ... multiple BIOs per peer_request */
-		assign_p_sizes_qlim(device, p, NULL);
 	}
 
 	if (peer_device->connection->agreed_pro_version <= 94)
-- 
2.30.2


_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
