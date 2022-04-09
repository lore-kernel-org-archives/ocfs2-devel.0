Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc251.phx1.oracleemaildelivery.com (aib29ajc251.phx1.oracleemaildelivery.com [192.29.103.251])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1AAB4C433EF
	for <ocfs2-devel@archiver.kernel.org>; Sat,  9 Apr 2022 04:52:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=G1ccKrMxx35cTQFzgmiLaMjaByivctcqKqL7XVCZuZ8=;
 b=P2sTUZ5G18vB0LIOw9VoNLpFk2TXvI9xdIp3rYm87a2YqqpWbznuKDXqqUxXDyun+QLFneMK6qhN
   1NarSxptWl/SMNj8FJ+gjPO5NBzrp5BImIXueMERyg3HDEKTRd0CJuac6BQSU5ZNrFCg6vHm17Mn
   fhGptaRLeEzQA1822lebxV1HeH+8WZE2yUEusiHT/iF7P2I3a1lH9yI4EaQZY9sHzJs4UfrlIKfh
   5r9jmO0WckJ6zkjklRGIA7wTN7zquKngYo0RzAkIgHqHY1o4zl44o4Ksx/Q3v0BcReCrzTP2e2H+
   6qTqvAHGew5Zi7QYEvqHFxMZG6WSviAzRYJtBQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=G1ccKrMxx35cTQFzgmiLaMjaByivctcqKqL7XVCZuZ8=;
 b=eaRlrxuqktvheSYn96GTPkoVvQnly8oTCov2ukfnLREgsJtRAoHfcpNqcFSS1CWRQs6zCcVnGA08
   kjPL7u0tINdrlE2VOzpfTF6a/HzasYNR7BL/FD+cluTCyhFWlGDocdtSotytWTDoLUJOw3CKZ0bF
   VWDPtkCSGCnq76pnGNYf/u86bC65s4hlddy12BVrrIj3U3VTd0cY/lpeVaTzgmHYLlG+lLbnJVg0
   7GMPTiOQvY8hww3CiMbeoAdWs5ss+2DvRElo+Hl+ukpA7xTVGmYD59JZRAcUYutSNkX9lAPExVXz
   RWC3U6qx/YD8Lmz9+3BA0cfe5AsMK2CdzotbXQ==
Received: by omta-ad2-fd3-202-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20220319 64bit (built Mar 19
 2022))
 with ESMTPS id <0RA200AMG2VDPB70@omta-ad2-fd3-202-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Sat, 09 Apr 2022 04:52:25 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
 MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
 :Reply-To:Content-Type:Content-ID:Content-Description;
 bh=q2ranmlO4Nl6vweHnkN5W/lhAXFqjXPKY6W4cI6bGNw=; b=ZwXWqq27tMeyVdjCd9/fIV+62b
 YxoMIWLS5QBW9+N570g/a7MqnPHccUJQp/73S/ehTJ9VEsGu0nZXpLT2GsIb95dlGJnKSkFIT7WNJ
 Q2sY9of4Z8TkC7fc/FklkIOgdhls0Ao3F7MloWBwUhbTcUSp/MjOHIau/ybVaMror8iobGwcOp0AA
 +a4GNDWpu5gRhJyLqGbdZW5DNs6lIAJYj08W7f1olcpdRSmv2+7GaRf1xJ5QApQRYFU40mFosdlZy
 0ALRAEA3rIIwBWnBlj8QEgYL1eIM3It3IcCM+Tc/eC3LmnRLah4kAgVmx2WJTHuXLjilmSIpHNWrZ
 1FnhvyJg==;
To: Jens Axboe <axboe@kernel.dk>
Date: Sat,  9 Apr 2022 06:50:33 +0200
Message-id: <20220409045043.23593-18-hch@lst.de>
X-Mailer: git-send-email 2.30.2
In-reply-to: <20220409045043.23593-1-hch@lst.de>
References: <20220409045043.23593-1-hch@lst.de>
MIME-version: 1.0
X-Source-IP: 127.0.0.1
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10311
 signatures=695566
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0
 priorityscore=265 lowpriorityscore=0 bulkscore=0 suspectscore=0
 mlxlogscore=927 spamscore=0 malwarescore=0 mlxscore=0 adultscore=0
 impostorscore=0 phishscore=0 clxscore=234 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2202240000 definitions=main-2204090027
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
X-ServerName: localhost
X-Proofpoint-SPF-Result: None
X-Spam: Clean
X-Proofpoint-ORIG-GUID: sJ1REQvhlLDYPFJepbRNtMzm4OBs9ijp
X-Proofpoint-GUID: sJ1REQvhlLDYPFJepbRNtMzm4OBs9ijp
Reporting-Meta:
 AAExOUvFAqsXTEfR/OODF/yYiQm59NFG5kcqK2naHn/u8uOM32BshWMCPCWHW0Ml
 nL7xzGb/CJA5fiYE3tjv3ozJxoIFJkxJyBOJWTNwHIIR+xdPAtZOZ+9YjU4rclJx
 ANx2kcPBN6hiWOcTqmoZAYX8HmSDNY8czGnc8hM0He6//d6NuCcUiUSabdZdd/BH
 gGjrZD+j11y70klbST1w07MqooF04f8NaP5UTnmXMnjecZ1xEJCfpzPxkDiaGYVD
 JQE8jxI2sQXRRY+kYf50srbBgUgZLRF9/If67YnK+O9bgxW7oO0zkVeRVaTno5fk
 4uoprHdg5jtwByXqJxXOhIxGj97dyYpXBkShLrahg54haYIQ7+zDY8Cuxr2i5R86
 hX26FwFY5r9JWnlIVtbcYbqW1okykftH55D0d5gUHA2WVLpB3wzhMli0VAZxVAJ5
 Y327ZYZ9DRuapkXu7lob/1TmFYsljs6pBCkqp0lV7wO2elLdHqRBYbjEy/8Dj2Fx
 N1kZRoErYvVCZrX8EPB9pKHWm7Dbiow3PVaI6+Q7FrY=

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
