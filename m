Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc251.phx1.oracleemaildelivery.com (aib29ajc251.phx1.oracleemaildelivery.com [192.29.103.251])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 79012C433EF
	for <ocfs2-devel@archiver.kernel.org>; Wed,  6 Apr 2022 06:06:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=TCNB8SjoWoExbbBYnWMfq095ddZGpH+dgL7jzddr3Ss=;
 b=yoFH3BWe2+3oDK0OTvDMbOICGPwYnCBxb6wjG5eyHy8wwMH9bWTGwvy9fq0+b1MllXSATz9VEn9F
   kauOWS2iQUU8ZdwU64ZJYw7DGufqL6+h0kOV66evf9cqCo4L2Tgxx8goxCHhbnujoGFqLrwz37ZW
   1SSOIjfCorg4QNq+fzzKWUEkKRkjtA+/O48qcYLJ1Udmld2oN1hKCzs3sfiOAIQEPeOaGoeqOQwf
   rOXg/2HxZ/n4Tp5QkMB0U0GVDQ8aWkuXuZkEj5eEddevW8JWJVma7WFKZ2lUDYfATFeRFohEg/AU
   aoWMwkVBKcNTxFW4L11/LWIg6b7lRCuA5yK6QA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=TCNB8SjoWoExbbBYnWMfq095ddZGpH+dgL7jzddr3Ss=;
 b=L5ro/kqCKjeL/IzyQzGtLNUMS2NLhEHZQMfGaK6cC3442zwBXtpmCsfpyemKIjB1nr2zN5drS3a3
   VLt5K23MmhesZ9C4aKLwMFVLv+jz4RFqI1MEFIvEPcHNbml41R1WPiAuPkbVxexUzkrfSY/DrsjV
   QdMsk+0Y0Nfqu3s1Jq7QMr8ELy/8c1B8idIEg5ONf8pOrNXIEyc029zrq2hZm24Pgq3PQrACu8Gd
   lUECtgnRGtdQrnfOzkXVq3vDu2GtFj5xN4hXAglvPUqki/QnB1j96Dvoy1Sjf9pKw43r4vca4Wwy
   QRgj77RlBlLKKKofH/vWZEaM1PmKNIx+cFBm2g==
Received: by omta-ad2-fd3-202-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20220319 64bit (built Mar 19
 2022))
 with ESMTPS id <0R9W00AO0MBM4F80@omta-ad2-fd3-202-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Wed, 06 Apr 2022 06:06:58 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
 MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
 :Reply-To:Content-Type:Content-ID:Content-Description;
 bh=d3sJ7l3Ux9SIWrKAiUmyBkG0qOnuM50cLv7WOo5iKv8=; b=U2k/JlDotMbinK7/JDeqSo6/XP
 Bs6ySJFC9su858GHk30OJaJoPB8rDR3fvqdgMURXO1OQquTgsv4KE+byWZoWhPXIJrPHFRYb57htY
 5kZ+Tj1EaeX24yHzNVPsnH8vK+56pifogbah/qUjzUOJyGboKhFS3X1qob8eCfNE75hF6DRia35U9
 qUd69uVjtYbl+AqrDw3m1Y45lEPmXYcMS6cMXqiqEpwL10Cir9JTLmDF/dQj22I6ypwBu1ciZGVg0
 rsksxrk+RgNjFNzHV8WMNg8RMAo9CfrbuDS6Y2JIjcM3aNVVcHFf8/GoINpy91AK7PBW/D671mulY
 8/TSMjOw==;
To: Jens Axboe <axboe@kernel.dk>
Date: Wed,  6 Apr 2022 08:05:08 +0200
Message-id: <20220406060516.409838-20-hch@lst.de>
X-Mailer: git-send-email 2.30.2
In-reply-to: <20220406060516.409838-1-hch@lst.de>
References: <20220406060516.409838-1-hch@lst.de>
MIME-version: 1.0
X-Source-IP: 198.137.202.133
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10308
 signatures=695566
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 spamscore=0
 phishscore=0 mlxlogscore=918 clxscore=323 bulkscore=0 lowpriorityscore=0
 impostorscore=0 malwarescore=0 mlxscore=0 adultscore=0 suspectscore=0
 priorityscore=90 classifier=spam adjust=0 reason=mlx scancount=1
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
Subject: [Ocfs2-devel] [PATCH 19/27] block: remove queue_discard_alignment
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
X-Proofpoint-GUID: upHijZtieAyjZMSD1RbDxmmftcahPqyv
X-Proofpoint-ORIG-GUID: upHijZtieAyjZMSD1RbDxmmftcahPqyv
Reporting-Meta:
 AAGPkQwKT9ckqRBDGbpWRNZKymZkD/5HhF/AyhiglRo24XQln7vAJoy4QZu78Os/
 SQH/EjWbBYeh/ODzDQvKVdpsM3v85SXH8sMW1BIsBIKoDLHjRQ2QfUABril12pYD
 CCXOgIcatfA+wdRP7WEq5Og0tBnuItrqu+u5wH1X/YByQpz2qlbufz67UYn40hxe
 UfPB/03WUqYeiyMJOp0aVxtkBonyPqvABpp8X6bNA+zRQWwUGRPHXt9mVfWJjqGW
 dPGyH3ljz2zIhLlFvOt3SdzYrrAxlLs0p2nee9SJiBXNq6dLMOVWxJ4/4dXr3+Rv
 efTKeHtxWkUNOi/P5rcXd1zY6vxzD1HwWZxj7AlVt2IKoU2k3WxtJs24aHvXN7s/
 3cfiPG5WGWZlQqr1IpKCpiIJUe54RTNptSPmli6I9n2p6SHl3mPa0cH7XJa0Ztau
 d3rHW0FhsRpYrYmBozNWJ7lQ1S0FQPwAQmRgyQzbtIMN1bkG+842fUGiiDfzb30v
 CyAJjGVT9BGSZplHWtgv+QDuQk8jrExJPQlWiYAjgSG6

Just use bdev_alignment_offset in disk_discard_alignment_show instead.
That helpers is the same except for an always false branch that doesn't
matter in this slow path.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 block/genhd.c          | 2 +-
 include/linux/blkdev.h | 8 --------
 2 files changed, 1 insertion(+), 9 deletions(-)

diff --git a/block/genhd.c b/block/genhd.c
index 712031ce19070..36532b9318419 100644
--- a/block/genhd.c
+++ b/block/genhd.c
@@ -1019,7 +1019,7 @@ static ssize_t disk_discard_alignment_show(struct device *dev,
 {
 	struct gendisk *disk = dev_to_disk(dev);
 
-	return sprintf(buf, "%d\n", queue_discard_alignment(disk->queue));
+	return sprintf(buf, "%d\n", bdev_alignment_offset(disk->part0));
 }
 
 static ssize_t diskseq_show(struct device *dev,
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 0a1795ac26275..5a9b7aeda010b 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -1253,14 +1253,6 @@ bdev_zone_write_granularity(struct block_device *bdev)
 
 int bdev_alignment_offset(struct block_device *bdev);
 
-static inline int queue_discard_alignment(const struct request_queue *q)
-{
-	if (q->limits.discard_misaligned)
-		return -1;
-
-	return q->limits.discard_alignment;
-}
-
 static inline int queue_limit_discard_alignment(struct queue_limits *lim, sector_t sector)
 {
 	unsigned int alignment, granularity, offset;
-- 
2.30.2


_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
