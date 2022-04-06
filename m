Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc253.phx1.oracleemaildelivery.com (aib29ajc253.phx1.oracleemaildelivery.com [192.29.103.253])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6BBD1C4332F
	for <ocfs2-devel@archiver.kernel.org>; Wed,  6 Apr 2022 06:06:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=vzrVn007Qq/F2VFg7XvhTSurLndCGay5tFjboFfyZig=;
 b=SFru24HHQOP3+D+eTMt2D6Im3+QkCFAc94fKDYn3xN+oTU1SA+5g7B502QURSuV7Nt+rKJU8LZrd
   qHO8dZtLLDCo/tBdNxjnpi5Gd7NzStf+I6EasePCTDi8CGesY68oYdagyvAN46wdytYR411JXABd
   T/a36ALirxzOm5JsGZvXfeTZqDGbr03YeVVCfhNzz/I4PN7x24rc0Y4GVVA868qjRs6U8jFTwHmx
   /YDhliVWOho0jnG4/PblQ3+Gxmze561WWmfGMbWFSlheLQw7OEJDB8wiBOEmtxADb5clMMHuybxs
   /XcE+wVmAXsgkLP22qp3b8b3OnR02G15lXksgw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=vzrVn007Qq/F2VFg7XvhTSurLndCGay5tFjboFfyZig=;
 b=N4H8TMBPx2FatAT3MA9jcKxtR4hvCWiI/5tIElLd+0FhXa4BXcJILD99zev1GFkYvG2mGPbRzMom
   6lnAK1RYuxutzp4FrMsQy4onhxeM2UvUOu/kWgyJyGj30zksjkDHgH3b8SgUhCFChUaSBRRE0j12
   5/OBsmmtYX3OMDuYrnVXuA79Fo7Z+oaAULb0jqqF20ratvJovOL+YSN6z2XzZcpipY6XDaWQs9TK
   OOzKSFYCp/wYpGIYMXa7zjhMe2mMledDAH3fnh9ZJt0MZLC21GcVzpe5kCI3XDh2ZyvEYxUT/c8g
   qVXyNSARgLy2QtkIyFnWMCHaMXXzLdPNBnPVfw==
Received: by omta-ad3-fd1-302-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20220319 64bit (built Mar 19
 2022))
 with ESMTPS id <0R9W003JXMBCD4A0@omta-ad3-fd1-302-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Wed, 06 Apr 2022 06:06:48 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
 MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
 :Reply-To:Content-Type:Content-ID:Content-Description;
 bh=65vdZDv/Oyhj9d7BIFQpxpieHFePRtIOo5rSsdbnvJY=; b=fnclFxf748Yk+HJEP8iaRVW3WB
 aWWIhphvzxhVY6FZKXEjV9bmsgZxn1Kj0ojlUoEizIay0h/EV1KlYq6LYsLwUZoiL+Fz08VFbrmWJ
 BYNbJJT671L+8hPCaASzQ9hicWQta9jTVuyI55rgNvXk3KOf4lbIG1gDSvXVJwm3aMnDnl4JurT3R
 S8cYXnLnqA9S0vlUcqmBeds07qoRbn35ezQfJ8pyS1RE387ITcgzq6PHUXXwRZqcO/Sk1L5arJMLy
 E+9ofKyWiYPnidQ8zD5I0ZyEozinv4MmGtOr/LudVUr7xp27guzf7u4zI6ERWqMoK3aOeUdBrl0mu
 xcCu0PRw==;
To: Jens Axboe <axboe@kernel.dk>
Date: Wed,  6 Apr 2022 08:05:06 +0200
Message-id: <20220406060516.409838-18-hch@lst.de>
X-Mailer: git-send-email 2.30.2
In-reply-to: <20220406060516.409838-1-hch@lst.de>
References: <20220406060516.409838-1-hch@lst.de>
MIME-version: 1.0
X-Source-IP: 198.137.202.133
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10308
 signatures=695566
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 mlxscore=0
 clxscore=321 priorityscore=90 mlxlogscore=515 phishscore=0 bulkscore=0
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
Subject: [Ocfs2-devel] [PATCH 17/27] block: use bdev_alignment_offset in
	disk_alignment_offset_show
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
X-Proofpoint-GUID: tTp3WReojwhRQYPkn_x7aq439K77xDuK
X-Proofpoint-ORIG-GUID: tTp3WReojwhRQYPkn_x7aq439K77xDuK
Reporting-Meta:
 AAFOqKCdCiqtbTFhLLCzU3MyvZ+JznA2KyHTZQrvS7tK2i+IExuvgP0R9W9HRrjB
 JCHLc4jdo+uQXo5Fiw46t7K/ytZLsBvSbGpSL07qodjWnQgM2d0p4piJbiZgujAc
 1Kcmo1fJcEBrudujqtBVryP0cpK9yuZNV6CxBLpZb/EnNri8gUf798TB2Oji7Vsg
 U9htoSn8GLlCcavgZdG1tY05wrKvbS5vXlnwiGRF3OAOUGIFXMCZ9vOQ05zTWxNZ
 IdciTjv4B+03M0p3Uw1ZDxLaMQtCxBe+yse3+v70wz4Hm2xHaVoURrsj3o/LabhA
 XD3iQVrJ4jOrs7y/5MAebWtZ9KLph9KF1WTGdCw7jUtStnX/mY7GwQxG8JpbH/ER
 r3w6e4WsfkNqfVLt4Uz1VjVflE07kS3kGKBnA6mEkjelGIRodj88pelV3MTzS3fq
 8+nh4Qses4NxuE3cYqsKluDgqN8g3SP6E1SqUHMNh79DIuZ64yq7CAtQcuECMF9g
 nDXGX3zT52u5otFpjJwTLlvmW3DsY1hUJWagHPjOZdcq

This does the same as the open coded variant except for an extra branch,
and allows to remove queue_alignment_offset entirely.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 block/genhd.c          | 2 +-
 include/linux/blkdev.h | 8 --------
 2 files changed, 1 insertion(+), 9 deletions(-)

diff --git a/block/genhd.c b/block/genhd.c
index b8b6759d670f0..712031ce19070 100644
--- a/block/genhd.c
+++ b/block/genhd.c
@@ -1010,7 +1010,7 @@ static ssize_t disk_alignment_offset_show(struct device *dev,
 {
 	struct gendisk *disk = dev_to_disk(dev);
 
-	return sprintf(buf, "%d\n", queue_alignment_offset(disk->queue));
+	return sprintf(buf, "%d\n", bdev_alignment_offset(disk->part0));
 }
 
 static ssize_t disk_discard_alignment_show(struct device *dev,
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index f8c50b77543eb..d5346e72e3645 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -1251,14 +1251,6 @@ bdev_zone_write_granularity(struct block_device *bdev)
 	return queue_zone_write_granularity(bdev_get_queue(bdev));
 }
 
-static inline int queue_alignment_offset(const struct request_queue *q)
-{
-	if (q->limits.misaligned)
-		return -1;
-
-	return q->limits.alignment_offset;
-}
-
 static inline int queue_limit_alignment_offset(struct queue_limits *lim, sector_t sector)
 {
 	unsigned int granularity = max(lim->physical_block_size, lim->io_min);
-- 
2.30.2


_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
