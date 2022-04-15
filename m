Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc250.phx1.oracleemaildelivery.com (aib29ajc250.phx1.oracleemaildelivery.com [192.29.103.250])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B6BC6C38161
	for <ocfs2-devel@archiver.kernel.org>; Fri, 15 Apr 2022 04:54:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=ZvFeJ4GbHJiAwyOuGgryPoGIKtnFMKRVGiS8xiTT7TM=;
 b=rbu6ZQGfW0XsnO2TCerw/Turvw2NP9Pa/5Pj5O1zspaQsh6LPmKYSlkV5SgabXw82G6ATGYKQVKi
   VY+qHwwTpWe4fRDXPY+ynQB2WZ+4ysuha1wARPyUGJGhgZeSMtX1IdN3STnR9fi9O9Sqx0rKFjw7
   r3MAbSw0kvnsNaFQjIOKkzl1TYJc8sZGs8xhddXDi249Ngy4L1N8n/5JgD3pwjjisy1joidUL7cy
   h9PKAIg+ioKacgjoW+Apj5qoM37cNtHHn649IWnx25BL6wA46h6aAj1XhJRzC8jeaUHT37ygXJXh
   X62kLWAmDHsDI2fECum2ePu/EfU7H10dKs/aEw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=ZvFeJ4GbHJiAwyOuGgryPoGIKtnFMKRVGiS8xiTT7TM=;
 b=QASV9QRtTo9EV7Bt/69mWgBadvNOrOxTUwpK2EIyNejb58GIQuHlhm9NYd6BhXftD59Qonqnfq/p
   V65xCid/PA+ruUIbW0cUeCtarPq/tP8+mlGqEf0hlPe4FyKLV31HJb0SIslY+El7ktv7jMIbbDTK
   d3tU8G8bCoTk5rIDwIL9X9F/JVdWnVaX/CCevzHsKMH7UXruxADh2ir4LoRiCL9sT0dSxgYJYUkP
   aMHaZU7acSA2SmkP9Q+MTn7fVBfyv7LJGQcKNjI5pKzYiIa7rr5NEQkMz5paQ6TLjRxrmY8H4Spp
   hkwlTgCuoIYcD+bb4q9tmL0uOaRbfP86pP9gFw==
Received: by omta-ad2-fd3-201-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20220319 64bit (built Mar 19
 2022))
 with ESMTPS id <0RAD002KX6Z2H560@omta-ad2-fd3-201-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Fri, 15 Apr 2022 04:54:38 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
 MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
 :Reply-To:Content-Type:Content-ID:Content-Description;
 bh=J+DlKJplDF1Q+uvJsRC9/x84m39e7OAPqS6lbIf59go=; b=SEeH/79eKPqdW8SzrNl3V2nOHl
 ZWhXxUOKMmxbomD4h47qxDHhmZR1AcrilsdsHynv3whZecHSbjPQD1q9d/FU6+E8K/5xf+VTFPZEC
 yjptUXDEOozEKnhNef4pA/iH+U6X5UT2a4kDQV1dcB4OMBiR7EqjwvZGUpUqzaw/ctS1BK7jfj0ET
 6bEbZ634DG1jUBSD4gMSefXlbHX9s1oVYHaM3eb8uWhP4KXYOa4yPkTPaEVS3k17D/+asg++w51Tw
 tL9Bw3UnRO/ROF9NNLI3S4GrxiqTSBVA9Nyw52Y9tkIfGW9lfoR4Uoz9tWbp7jnXJX8faoVQRTg4x
 Z/Iw+o9w==;
To: Jens Axboe <axboe@kernel.dk>
Date: Fri, 15 Apr 2022 06:52:50 +0200
Message-id: <20220415045258.199825-20-hch@lst.de>
X-Mailer: git-send-email 2.30.2
In-reply-to: <20220415045258.199825-1-hch@lst.de>
References: <20220415045258.199825-1-hch@lst.de>
MIME-version: 1.0
X-Source-IP: 127.0.0.1
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10317
 signatures=695566
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 impostorscore=0
 lowpriorityscore=0 phishscore=0 priorityscore=256 adultscore=0 mlxlogscore=999
 bulkscore=0 clxscore=247 malwarescore=0 mlxscore=0 spamscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2204150029
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
X-ServerName: localhost
X-Proofpoint-SPF-Result: None
X-Spam: Clean
X-Proofpoint-ORIG-GUID: XQKQaSG3gKLTXOKw-Vko0u0HEgjFlCzv
X-Proofpoint-GUID: XQKQaSG3gKLTXOKw-Vko0u0HEgjFlCzv
Reporting-Meta:
 AAG+S/XNNmQGZHkcv4NFa7HZil/q/KEs/JbbmTjs4A/Phf96O8XZXq60q55M3YDu
 uC5rTMunGyPO3vSnSS4sBNQMjY7rbC2lF5TNwY8CYVI1i0EXTL/LdZ1JV/GicC3Y
 7Aggn8x16gpmF6cRASwCWNxT7WUPyqjGXq95MwEJdxUItsBAZ4PCGEsMaoNwlSYB
 6i5GPpOd9obviWkHQ0U7x5Hy0gkcsiqXKfAHWSWMniHcUtp82IW0+QGqt8RtKZXq
 NmJ8UGJCC7OIX/CCmev0NafyVKZWGaZ/M5K8ZmmXm55SvWqR9Z0W+f0RtRXdRNKg
 wWc+hqKghOZ3Pnrz6012F2sjKBWCx9HZv3wHCZU6MKLOr4FlnpeJHf/ZBjul0cRe
 jpCm0371Qxk+0zeYy9qvbbjDefAISvgcfuwPHOB4VyobGy/pBbyLxBTJYl/brGZC
 JsUS6F4Xc0rKEU7eg6Aq9Q/1iCvRSRLftbQKJE5j2UPc79GtZY+kMq5x4SKyrY7U
 E8+LAd0JRu6EbAxu8PtdFr0S6jT9clGRBLjCIFvmZp6T+g==

Just use bdev_alignment_offset in disk_discard_alignment_show instead.
That helpers is the same except for an always false branch that doesn't
matter in this slow path.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>
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
