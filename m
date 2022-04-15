Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc254.phx1.oracleemaildelivery.com (aib29ajc254.phx1.oracleemaildelivery.com [192.29.103.254])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9F407C43217
	for <ocfs2-devel@archiver.kernel.org>; Fri, 15 Apr 2022 04:54:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=CYOKr4BuEDIgu6mtOpngSR+y44eWhkvjqAA79C4jwRo=;
 b=vPDNjs/GfF6dz2bR8Pnb562h05HPUyzN0bpexdP8gXjh/fABFmcDweadg0EFmckIeQ7hIAnCNlZ3
   8JrSRKOuKvekjE/GmoyrNPJwsGqy+3URMgwcYDrrzt98uPKhbSpC6uQtwrU5qwV7NkbAl/yRnYbQ
   opBE1fiv0108ZxWlL05+WeH55ySotJhTyjPu390vl9t3gmycBRKz264aoggAZ0fGmujW2w7dEsbN
   H9pIOnEIcQn+ox3FYTLq3U7OBCxTfhxBTNrImcnZOB6wZn+Kdz2MYf7IeDhVb6teoA9643X4rnw4
   DEhE4EB3f1H51Ix0DwyzsSiBuDAZrCpJ9M3LAA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=CYOKr4BuEDIgu6mtOpngSR+y44eWhkvjqAA79C4jwRo=;
 b=mM/ZrM+Y0can5TFwV65vUp35GMrPcB5K+HOGk/EKABO6Y6se45FlzID+0xu/8J2Br95Znf7pGvlv
   Gf6sAqIqZrVVU52sglpsOleDJyKJ4VOnllUpg/+R5iHna0MuwOALlENUwr1I9QtiFhNAkNvK5NjK
   bQCG6lO0HLhVEQBTGI75Od07/zisphYNfFNv/zdCLwi/+ipPCAOm1uysALd+j70pGWi9HunmhBzG
   Te9uBaFPUPmHM7C9sjaU563ouSBfJAyXaIN6F+F0Ij6UFBHYvZz2MB88433CzeLDl8LBkQQEQrFO
   9Dt8ANqhgSrW23gFCDvIT8GOVFqE/ppwDOwrAw==
Received: by omta-ad3-fd3-301-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20220319 64bit (built Mar 19
 2022))
 with ESMTPS id <0RAD00MA46Z2GK40@omta-ad3-fd3-301-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Fri, 15 Apr 2022 04:54:38 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
 MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
 :Reply-To:Content-Type:Content-ID:Content-Description;
 bh=6JVZQz23Gg3oLV4oYc05UwmOH+nGeMd1Qpin5+I9KgM=; b=p4/UQY65J530pBrFxSnyzz+s1S
 20vQFpTrN15G6NO5F9VDuyGriDpCNyWjbyKgPkMSrLLko0Q4FtJ1eCzi+YOgwapAyJib+3l/z0nqL
 +NYMVQXNHIEHx4U8dz9u48TnCqPcYXyNXVQmQKYJgAexB2zuX97VLPbrU2HmJIKE7g1fg+Kmpeu2X
 7In2j9JZDuGthZuxusAdOOuAjghMTjSwC/AdUlo5SnfFd1vgrm4uEPQ78/HVr7y9+RCydI3REXKPH
 s1r/AwsdOouUPRQPQY3Kuv+Zv/88cYk9RfHpmYADsU3re53XPeDNlC3OFKsZfaMhZuxBpfzjqoDMO
 ifzKUlSQ==;
To: Jens Axboe <axboe@kernel.dk>
Date: Fri, 15 Apr 2022 06:52:33 +0200
Message-id: <20220415045258.199825-3-hch@lst.de>
X-Mailer: git-send-email 2.30.2
In-reply-to: <20220415045258.199825-1-hch@lst.de>
References: <20220415045258.199825-1-hch@lst.de>
MIME-version: 1.0
X-Source-IP: 127.0.0.1
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10317
 signatures=695566
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 clxscore=248
 mlxlogscore=999 impostorscore=0 priorityscore=95 mlxscore=0 adultscore=0
 bulkscore=0 spamscore=0 suspectscore=0 lowpriorityscore=0 phishscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
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
Subject: [Ocfs2-devel] [PATCH 02/27] target: pass a block_device to
	target_configure_unmap_from_queue
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
X-Proofpoint-ORIG-GUID: RudrZSvd7p2HmTg-Qot04R30lmq7EswK
X-Proofpoint-GUID: RudrZSvd7p2HmTg-Qot04R30lmq7EswK
Reporting-Meta:
 AAGszEMYCAXZJZGdNiJaZM7w2FwKscQaK4SVrGzgNYbfxolmO/AXDp8MAswptKh4
 EUxxdw4H3K6p60XZV41kQqarTsJ40BgX0WQHRoVKDmZ0iYU5BA6aszReEsF9InHg
 XdiXqt8rIdPn0yAbZk45W7R5WrCBC47d9TzTRXs+U8xs51aV704R0sG6Mc5+GDZu
 4B8JhZAzl7Yc8fGf1Ez9BTOsHZgUgAFNkqp4kyFTMe/BcO1m8jT1eOpv/j7azdYm
 tU8dWflOc6iYj2CIfnCjWKaHGou+2WWAze3VfBV24kxgfRVsIJ2jgrQwIo9NWS1n
 v2sMG+VRJL/zRwX7CzpoHirHDuEMaYvLpO7qmOD9uM5mbnuFa6VGG4tvtw0kecqL
 vAxwuqs06MmmNT10pkLL8mu6F98lsRN4hxJieNXjdaZoZ++qOj2JYT14heLg94o9
 +zgJPr1y7DJQsCv9QTq3FyJY4G3llVke3Fm0xDiAsWAhAqhYvaTbDuq2/vS27ZoC
 oEvGC0yRf1bnuBuCNTbZeY04q6cBl6Uzi+4hlRUTYIvMhA==

The SCSI target drivers is a consumer of the block layer and shoul
d generally work on struct block_device.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>
---
 drivers/target/target_core_device.c  | 5 +++--
 drivers/target/target_core_file.c    | 7 ++++---
 drivers/target/target_core_iblock.c  | 2 +-
 include/target/target_core_backend.h | 4 ++--
 4 files changed, 10 insertions(+), 8 deletions(-)

diff --git a/drivers/target/target_core_device.c b/drivers/target/target_core_device.c
index fa866acef5bb2..3a1ec705cd80b 100644
--- a/drivers/target/target_core_device.c
+++ b/drivers/target/target_core_device.c
@@ -834,9 +834,10 @@ struct se_device *target_alloc_device(struct se_hba *hba, const char *name)
  * in ATA and we need to set TPE=1
  */
 bool target_configure_unmap_from_queue(struct se_dev_attrib *attrib,
-				       struct request_queue *q)
+				       struct block_device *bdev)
 {
-	int block_size = queue_logical_block_size(q);
+	struct request_queue *q = bdev_get_queue(bdev);
+	int block_size = bdev_logical_block_size(bdev);
 
 	if (!blk_queue_discard(q))
 		return false;
diff --git a/drivers/target/target_core_file.c b/drivers/target/target_core_file.c
index 8190b840065f3..8d191fdc33217 100644
--- a/drivers/target/target_core_file.c
+++ b/drivers/target/target_core_file.c
@@ -134,10 +134,11 @@ static int fd_configure_device(struct se_device *dev)
 	 */
 	inode = file->f_mapping->host;
 	if (S_ISBLK(inode->i_mode)) {
-		struct request_queue *q = bdev_get_queue(I_BDEV(inode));
+		struct block_device *bdev = I_BDEV(inode);
+		struct request_queue *q = bdev_get_queue(bdev);
 		unsigned long long dev_size;
 
-		fd_dev->fd_block_size = bdev_logical_block_size(I_BDEV(inode));
+		fd_dev->fd_block_size = bdev_logical_block_size(bdev);
 		/*
 		 * Determine the number of bytes from i_size_read() minus
 		 * one (1) logical sector from underlying struct block_device
@@ -150,7 +151,7 @@ static int fd_configure_device(struct se_device *dev)
 			dev_size, div_u64(dev_size, fd_dev->fd_block_size),
 			fd_dev->fd_block_size);
 
-		if (target_configure_unmap_from_queue(&dev->dev_attrib, q))
+		if (target_configure_unmap_from_queue(&dev->dev_attrib, bdev))
 			pr_debug("IFILE: BLOCK Discard support available,"
 				 " disabled by default\n");
 		/*
diff --git a/drivers/target/target_core_iblock.c b/drivers/target/target_core_iblock.c
index 87ede165ddba4..b886ce1770bfd 100644
--- a/drivers/target/target_core_iblock.c
+++ b/drivers/target/target_core_iblock.c
@@ -119,7 +119,7 @@ static int iblock_configure_device(struct se_device *dev)
 	dev->dev_attrib.hw_max_sectors = queue_max_hw_sectors(q);
 	dev->dev_attrib.hw_queue_depth = q->nr_requests;
 
-	if (target_configure_unmap_from_queue(&dev->dev_attrib, q))
+	if (target_configure_unmap_from_queue(&dev->dev_attrib, bd))
 		pr_debug("IBLOCK: BLOCK Discard support available,"
 			 " disabled by default\n");
 
diff --git a/include/target/target_core_backend.h b/include/target/target_core_backend.h
index 675f3a1fe6139..773963a1e0b53 100644
--- a/include/target/target_core_backend.h
+++ b/include/target/target_core_backend.h
@@ -14,7 +14,7 @@
 #define TRANSPORT_FLAG_PASSTHROUGH_ALUA		0x2
 #define TRANSPORT_FLAG_PASSTHROUGH_PGR          0x4
 
-struct request_queue;
+struct block_device;
 struct scatterlist;
 
 struct target_backend_ops {
@@ -117,7 +117,7 @@ sense_reason_t passthrough_parse_cdb(struct se_cmd *cmd,
 bool target_sense_desc_format(struct se_device *dev);
 sector_t target_to_linux_sector(struct se_device *dev, sector_t lb);
 bool target_configure_unmap_from_queue(struct se_dev_attrib *attrib,
-				       struct request_queue *q);
+				       struct block_device *bdev);
 
 static inline bool target_dev_configured(struct se_device *se_dev)
 {
-- 
2.30.2


_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
