Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc251.phx1.oracleemaildelivery.com (aib29ajc251.phx1.oracleemaildelivery.com [192.29.103.251])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5B869C43219
	for <ocfs2-devel@archiver.kernel.org>; Fri, 15 Apr 2022 04:54:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=G1ccKrMxx35cTQFzgmiLaMjaByivctcqKqL7XVCZuZ8=;
 b=ns7qCoW4XfIbBn2ihLSDvtlzgGj1ZNRPf+GEV8vliRLDM53r3eUAj7+Pd2ZtzBEwWPNjj6YudYgr
   oZF2GpRkkbnOcrfdK4Ji5G53Kzk1jaJLnT10QrilRMxZCzzwAZcHjUtvC5RNSNW1XLr43Z+f4T85
   bifwiN+BiJE0HApeKE4iDQtJ014PVQOYKo+QAOAFhvmMO83o3IyPJ2dQkb5eSjuYPYGRAxndo03P
   rfKRm+Ejt6d+uqr2hKriSQhB+sbI6o1WjxaNuC7dYDKvgFjZiLhLokOgpGCB3FXcfG6bXLIrkI69
   PUvF6IGNOHsDf16E6yUX6JFWRHrelLs5jiYHkw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=G1ccKrMxx35cTQFzgmiLaMjaByivctcqKqL7XVCZuZ8=;
 b=FIArWuqOSYQmvVY8xzbF2gIhAo22CtNhSERCkKBfxfjjxRggHP09o/kZ3HydrxPwOfCQ8t3wuZ1l
   9xdYduAsPWvA5kF9epVMKgbZfxcbyHyCb6VI36DhF6PFSxTgn5+9YN4deNEEhh46H5haPqfg5eot
   rIqJ38J4hZVrnLP77BHW7waGdQjE1+ihxvHcs6cmB6mzk9siNqLkG4LJ2d4WT9wbdRnsSbV9oElL
   l5xDN1hluNNhsFiNNF980ulDriwonedmmRVHZxQwqOGNAFVtofWdnuC/zwmwve2QgfInRYNUxhxn
   85OFmxepitlP5io6hsj86q5b3ohlzEYaLclVzw==
Received: by omta-ad2-fd3-202-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20220319 64bit (built Mar 19
 2022))
 with ESMTPS id <0RAD00H0P6Z2KTA0@omta-ad2-fd3-202-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Fri, 15 Apr 2022 04:54:38 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
 MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
 :Reply-To:Content-Type:Content-ID:Content-Description;
 bh=q2ranmlO4Nl6vweHnkN5W/lhAXFqjXPKY6W4cI6bGNw=; b=Imm4Yfj4lK8os56GTjHtESv8Ln
 /f/n//I9UVgO0gz0loVNZo7Kx8U2lN8GWuypT8815hL/Cbxkr3GIfFYT2oap2P7u27ZNlfV4ESUm3
 nUKYekUTiCtdte0HtVU0mfHtnc1JSUCyagOIpbgNEzqbzUQNiwlEp8m5sb47dsYKebQL4R3A3Igsy
 dTbWNMbYDJIYjtYyj8uxb8rBDcOQ+bzOZSC1SBOJPEIu1iXFYJPGOni5DOCC7FW8wOycr+QifG/Wg
 MwWy7d+vMvWLfxa4iMbFhmkTIzHqao0ZRSaYQGzHa37lKAGUhFr/qfO/PDwSf9PSBl8O2KxhcHtX4
 P2d5tlXw==;
To: Jens Axboe <axboe@kernel.dk>
Date: Fri, 15 Apr 2022 06:52:48 +0200
Message-id: <20220415045258.199825-18-hch@lst.de>
X-Mailer: git-send-email 2.30.2
In-reply-to: <20220415045258.199825-1-hch@lst.de>
References: <20220415045258.199825-1-hch@lst.de>
MIME-version: 1.0
X-Source-IP: 198.137.202.133
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10317
 signatures=695566
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 clxscore=220
 bulkscore=0 phishscore=0 adultscore=0 malwarescore=0 lowpriorityscore=0
 suspectscore=0 mlxlogscore=909 priorityscore=120 spamscore=0 impostorscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2204150029
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
X-Proofpoint-ORIG-GUID: tS0wx3qk3-bMwBErTQa2xfEfptMv0E7_
X-Proofpoint-GUID: tS0wx3qk3-bMwBErTQa2xfEfptMv0E7_
Reporting-Meta:
 AAHubPBLBEdBMwcFxWjeXCkxAe4em2Ltg69laooP3SJu4VNHZydgzL8IZZLTc/Tp
 4KG91DkOwT61+rjv636B9DD7ieTBlX2ltYKb7spwAwJohKDZH3l6VXchHTZA5V1q
 qF6qsv5mOjaSsrdvp+GkGPJEBmn3SAgbqz8XguiVq5u3bvBYOO89IdeXLIyARGQm
 CNPJxtPIe85NLVMre53bWlK0yupSViyULpIQrjrxAXRsBXeilIinFRWnqSmy5VNo
 P7vi1ckN8H9j2vUHIm1OcMLZmeX3mXGzbOsVS9F2a5ewP2wAsJ+76cYX4/23UayL
 gcj0AsM4I8FsfTpjrLzrzIxsnGLhfRLjM0NT05MCQIbKSW+i7yTUvg3+RY281bEB
 jedYBxf/UWUOPVjse5IYH46V/E8Bt17HPSjgiA9YRtMJDehXOe5An6qn+qlXSE6/
 fR3UnINovAhvDmNrefW5ON1MtYncu1jcMUpdoZg8NrFOThbtCkANxwSqy0/WyUn0
 iqjmzWdeAkB4dXFCyXxT3Kkr4itdzwOzAas2mE1DLGTV

This does the same as the open coded variant except for an extra branch,
and allows to remove queue_alignment_offset entirely.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>
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
