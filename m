Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc250.phx1.oracleemaildelivery.com (aib29ajc250.phx1.oracleemaildelivery.com [192.29.103.250])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 75295C4321E
	for <ocfs2-devel@archiver.kernel.org>; Sat,  9 Apr 2022 04:52:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=ZvFeJ4GbHJiAwyOuGgryPoGIKtnFMKRVGiS8xiTT7TM=;
 b=iWe+g7d/f/odv3CjV8s/Il6ECxsC21+pTFi2gHt/qq4V9qKGpD34vofvTya7Yq1HljhMqjESarMW
   NTh8lRfwvbxTrN4JGue1su6YWAvt1nF6REM6vh8n+Q2rJbQugHWWkgapmUjmp4EX/0hrCc1rF4DL
   ydiUutQueXpfz+4IGR0NK2YDWIYPoJ5u851IEscXs/PuNhtqG7ecgxPD8tR2Tk0bcB/8/BLT5cQs
   aGApB78DVkh0IKunlqbNU3WMeYzduhRDFnsCD/+JT8eIltJ7q50q5JgQqV9/+zlaQsdxjSlN74yN
   EBr1/8CNNQL/yEMMJdhr6S6noKtLawD7LFb0Jg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=ZvFeJ4GbHJiAwyOuGgryPoGIKtnFMKRVGiS8xiTT7TM=;
 b=kzBJSkd2iZz1W9hY3zwGAdBkftZBhQBbY5YMnnUtJEKox4QFmVRqDQE3ZvbkFaOjhYjhKgOHUdKY
   WkajOcLNxNmog9hI0Cii9FLp9iyFEWsrr3GPyikcE/AE8vXQ2qh4B8EAbFTAdHj0oZP2N24PTMx9
   WVqQGxIl6LKakwP2BFBFZYNGMuK01hSzxJ38JVo9QnyYxfeAmUqOOOvsQk7q120dCcY93PDHaotd
   0MUaZSxlgp0zvwEo7pvaRUuVgEb/vocFQihCB+fdSKvYP2qFSMy3Jymhz2LRbn7M0pj5FcKke2eV
   +5WeVGmTTeiV6eRLOb7Nc76PI2hL7vVMCb7UaA==
Received: by omta-ad2-fd3-201-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20220319 64bit (built Mar 19
 2022))
 with ESMTPS id <0RA2004KT2VCHE80@omta-ad2-fd3-201-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Sat, 09 Apr 2022 04:52:24 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
 MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
 :Reply-To:Content-Type:Content-ID:Content-Description;
 bh=J+DlKJplDF1Q+uvJsRC9/x84m39e7OAPqS6lbIf59go=; b=Vg9G4nec7vlw9JzY8ZelhLqst6
 ucW6GkU1kL/cckjMXF2Ml7hSDWPk0eXkPWwiYReqkgU31v2L8/TZCAwJcIAknq29ONqcGwBOqoyy/
 WYEExBpIUNCaVoczlTCCzWmGmVmLb9sdCt2/KpA+J1RiElt3I5LUNJS6TppQaHanfTgucuVfWVEqw
 AMAgeT/+i8cp5mqhw5xpCWTsnxLqKYlbYbpVf9dEsk8jlTsF0YqgExniCnZNX5XEO12khG8E+nclP
 kStumcAwUmqAnzRWuX42XMeJAWn+kUo4gGpuhFKBWVbZUS0Ww7Py5+qQcuSTLhz9CYlA7wF2hyPxg
 ePGLsb7Q==;
To: Jens Axboe <axboe@kernel.dk>
Date: Sat,  9 Apr 2022 06:50:35 +0200
Message-id: <20220409045043.23593-20-hch@lst.de>
X-Mailer: git-send-email 2.30.2
In-reply-to: <20220409045043.23593-1-hch@lst.de>
References: <20220409045043.23593-1-hch@lst.de>
MIME-version: 1.0
X-Source-IP: 127.0.0.1
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10311
 signatures=695566
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 priorityscore=85
 lowpriorityscore=0 bulkscore=0 suspectscore=0 mlxlogscore=999 spamscore=0
 malwarescore=0 mlxscore=0 adultscore=0 impostorscore=0 phishscore=0
 clxscore=237 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2204090027
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
X-Proofpoint-GUID: vJEpwNOS2OiMzmHbiG479ficb6GNBfpE
X-Proofpoint-ORIG-GUID: vJEpwNOS2OiMzmHbiG479ficb6GNBfpE
Reporting-Meta:
 AAEYvo4z6+y5JcQb/QSCQ/eLEPBi2kOmBy5cURIoBAi9Nqy1Pxrihp9MWqVJ/fK5
 hgY+CyE/nyt+slE1Ay9aWv3d3yKLlbc9+L3TiqeuQQTZr9qC8Z7LtwAhF81i9u46
 0+zhCSwgIfw5WJ8tyVLBeGhwR3cWTwj0tGoNkgXmvGSEy+Wp2ko8gaKFaJZx3n8B
 Uy7Uh0XnMINdjPbJwrp4DkJmCK5iN2G1Ve4Eu9e0MZ+x968NyuqF7G30V3TrsVDO
 lWLc+90AKZRJSD8nDXhqM1pHq4Za89JFQN0EEZkwFbsH0VeyORpRDjMD+xT/kvXs
 8o4YWsNVbRu68txcWSkW/6MZrQ8SJchvs2FoCI4tOvkUyFGyjoWow0JOwksdfCzi
 S9zmV6r4WaQ5+Tv3etpy5gmmSUzeRIv5ibkT0YP3aakXi8yFhLREstS+HicIc0sB
 4rMQGvQJIS8IJ+O/Z8+fRLFASH3jHmCxrZokLGM7r0BO94utFSH7azAU9w5hgRrA
 L+BqjU4Db0+dcGU5UI0hC2oMeWqIi26gLwFDOxuQ12c=

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
