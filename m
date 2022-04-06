Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc245.phx1.oracleemaildelivery.com (aib29ajc245.phx1.oracleemaildelivery.com [192.29.103.245])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D2B59C4332F
	for <ocfs2-devel@archiver.kernel.org>; Wed,  6 Apr 2022 06:06:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=yMGQbWAPheDPDU4vhEZwac1nUdSs9nwlsRhCu2+GwUc=;
 b=GwzeSgOQZ45hCmmY9ZDxQBICHO5V07NC+KkTtNpBqSK7WSGTg++nmzgztCNLgjKMpGV6wudWD9RH
   my/83RBdLnuUCQwoqWgHDSralx3o2Zv6ORWPIZE9/sELxGJoiOihqV+BuRLi6veP17i07vWHiHID
   EEG+Af7MV5ISpEw6wUr1r95y8zdIXeRma8dPw7EuiEwPO6cpSCzXBUE8I5myR/QryekzslN6X4Gd
   qYz5Ms0n2ihdVlSBEw18oj0Y0qhaoVs4kebmTLI2/8kP4TMPfY6xi51Epa78bbPFK7rhHYWHFPc7
   Cz/qlcWeG+58zuvrTEa3E4Yv3jtSjeGVCVx0SQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=yMGQbWAPheDPDU4vhEZwac1nUdSs9nwlsRhCu2+GwUc=;
 b=YiPKsVtj2Vc2uRSa1WM7nIwBGiERMLWYU7l7e4ExMOQzveFvmCbQ8ty2p5lfz9hZ8nZRTgVdzfzy
   ez7fi07ofbPoLpTQEHPt2O0dG1KlIuTI56AnRBOo+/R2vN2/dvNqxrSKyuN90fso+algUyvqPfiM
   hSzsNgLrY9UI+234TtGZdONQwiCzCCL/r3T3XHmRbN1KTBbQKK7WlN2rZla+q4WfFf8tOjRkM4DM
   JDaj73zwY3HdiDQAo6NidtFMQKb7VydUF2NMobMHKXbdvO0MoqxGUV+iOWe76fW3Z3XUxLmtANJ2
   +YBHTCpOxm9TjUxzIlUwF5lV7P/pbD+J5QIM2Q==
Received: by omta-ad1-fd1-102-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20220319 64bit (built Mar 19
 2022))
 with ESMTPS id <0R9W000DIMBAXX10@omta-ad1-fd1-102-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Wed, 06 Apr 2022 06:06:46 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
 MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
 :Reply-To:Content-Type:Content-ID:Content-Description;
 bh=TxXl3MdplxU9MCO/Q7D4FJYRsok6DDTDVaSg962eOWw=; b=rucC9iJZF0nT1xLRSKT9tqQoP5
 nL0SBYR/iPNSHB6wdcFxgaOg4ge9C2M4FP2p1JxUqmGG9zNBcpvn8l2ImaqSWUruwic5SBL+1Ka0A
 N9OC/cngiat+LW2SmmgQgik6umVCvLvTWe7LVYau+JKoIVcB5LAd/jZAV15/t6fN+UTCCe2AFXibt
 E1V1T10hMp3lTxlmDK2XsJoN/x/84A5CsbNWzJR1vr4eEH4n9FywvazpXPuwcYDJ3oSJzJmHtYcSR
 fBAUwkO6DmJcsI89V/f7f2YpyrUwGe49T4osq7oE4lAOjncY7dpUANpsFS6qbMzskbxkKi/9ab/Dz
 RphmF5Bw==;
To: Jens Axboe <axboe@kernel.dk>
Date: Wed,  6 Apr 2022 08:05:05 +0200
Message-id: <20220406060516.409838-17-hch@lst.de>
X-Mailer: git-send-email 2.30.2
In-reply-to: <20220406060516.409838-1-hch@lst.de>
References: <20220406060516.409838-1-hch@lst.de>
MIME-version: 1.0
X-Source-IP: 198.137.202.133
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10308
 signatures=695566
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 mlxscore=0
 clxscore=344 priorityscore=60 mlxlogscore=508 phishscore=0 bulkscore=0
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
Subject: [Ocfs2-devel] [PATCH 16/27] drbd: use bdev_alignment_offset instead	of
 queue_alignment_offset
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
X-Proofpoint-ORIG-GUID: bRnrZonHyxoRqvxmt6FpsHTZesqdgEXb
X-Proofpoint-GUID: bRnrZonHyxoRqvxmt6FpsHTZesqdgEXb
Reporting-Meta:
 AAFA3RAva8NK0F4DU7GXDKMNv8F81v+/T8cnfcu1pR8JL379nfcep1yVbQ456sbM
 zV01fI0nfl5FvXqvW5PZFi2Uq27gBWiifPSTZYKa5a5RDz+LEMwA2GqDeWINi0Fa
 K/K2znBt8H1lpp+CxpPLhWIqkJ29JDPgHkog+S7b6Mwnm1Cdja4NIFzdhnS80jcg
 5+2sgz3kRMWHMCjRDbxxyYnx9Nl8fV76pMK4MJPQykd5YUQAOUHxEClaLL4SBFR+
 WYjUfNBxXfsEKHU3IKEATkT593STFth+zTqT+TeQofD3DlwnPSQ45hBmOBrY3Xty
 XTxDxXg3eBYo7WWhCnStaEGKedBOLNz6Kt/B2VJ2DnZt69kEbttAGgAbtNsJF06O
 k/qLMRdeYNFdmZXRiFY7KFIpVAj8ikTuVAJ1yVDamOqX6V4YlRSo/RQj3lk74S4g
 si07TiGSuNCwKuFzigHsO8ZxgPIimfj9s63iAFWo/rJsEAIMYH2DFrrul1WeJpVI
 73OcMqqYx/KJg93tIg6sSG7UmDjX63kRhgpsSUYvwOw2

The bdev version does the right thing for partitions, so use that.

Fixes: 9104d31a759f ("drbd: introduce WRITE_SAME support")
Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/block/drbd/drbd_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/block/drbd/drbd_main.c b/drivers/block/drbd/drbd_main.c
index d20d84ee7a88e..9d43aadde19ad 100644
--- a/drivers/block/drbd/drbd_main.c
+++ b/drivers/block/drbd/drbd_main.c
@@ -939,7 +939,7 @@ int drbd_send_sizes(struct drbd_peer_device *peer_device, int trigger_reply, enu
 		p->qlim->logical_block_size =
 			cpu_to_be32(bdev_logical_block_size(bdev));
 		p->qlim->alignment_offset =
-			cpu_to_be32(queue_alignment_offset(q));
+			cpu_to_be32(bdev_alignment_offset(bdev));
 		p->qlim->io_min = cpu_to_be32(bdev_io_min(bdev));
 		p->qlim->io_opt = cpu_to_be32(bdev_io_opt(bdev));
 		p->qlim->discard_enabled = blk_queue_discard(q);
-- 
2.30.2


_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
