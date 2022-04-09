Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc246.phx1.oracleemaildelivery.com (aib29ajc246.phx1.oracleemaildelivery.com [192.29.103.246])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 72934C4321E
	for <ocfs2-devel@archiver.kernel.org>; Sat,  9 Apr 2022 04:52:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=PhDHsGMKQQqInfcK4NFKdoStLqrIw5x3XhmJbdsGIrk=;
 b=daJxywWh8mGxpC3UGIYlY164k+NizWepxXQTlsblmupr5669BkGO1trkSaIBtF8W3cWLzpoR86wW
   mZuPfXc43vlr1kQ2pX4EPKv+Npyd+KGfsec/ENzd+L9CKnLAWFaP/qyqPmt4Fam6ZrCdlYTT1bwB
   EBXQV/hd2qEkXYcE/dDb/uCxCnCD3czF+WkLQ2+fzFREe4IEabhW/fuDdJmyVMa/oFnUMOWmPNyj
   MtiI1v6+5tEDrugLl/yHyr117tEprymWF/Ci7EyF5BFDWffPHPfPoGtdKSNARXAbkC1TYa6bSKjS
   bfaTipzZzWzfQmidW+Rq8uwCXQDKY/dp+5ZHRA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=PhDHsGMKQQqInfcK4NFKdoStLqrIw5x3XhmJbdsGIrk=;
 b=rj4mNU9LBEBoTLee6mWqjMxYunLRsnp9LYB5wNkKgflOLziEA/0qid2iDQ+ztTR5d91O2lVgyz16
   h3ls2k/AA6Nhiao4OhEBpcTuPnj7/U8am6f4c2NUXrh67nJZlJZFwUmyNuSoU2FEHC1X7C3SA7kj
   bTfvp/GKsOlX2D3AG8uXrZMXQqVc/qqfbhg/K9OBAB7xZBFYVMxrrUNdStnMVfuBTx0qkTSTvBR9
   GS6H/dmT9cAPFs4l6Sayj2S+E9ECURvzkNBFtnDOpcDcZCcQ4S+M8ec5FzOWfe4+SA7BaXnliiho
   hEHLxSD5trtwI7uPoSXmcVcVPUIhX+4g3Nt1HA==
Received: by omta-ad1-fd3-101-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20220319 64bit (built Mar 19
 2022))
 with ESMTPS id <0RA200OL62W7KN20@omta-ad1-fd3-101-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Sat, 09 Apr 2022 04:52:55 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
 MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
 :Reply-To:Content-Type:Content-ID:Content-Description;
 bh=eypoqjBCbHteIGJMjEE77faduCfiNIsAQ0ydQeu7OQ0=; b=nqH1nBV8lOr2r5wyOjol3g7s8X
 NGopilIp147x4XNnQqzR5o2YWkY6IO58VVUojmV/ASvSDXVzRQHv+BqUNN8ISkIuVH5Huq+5W/+g6
 Fx9NKN7nsNjG6IaaR01B6x8gfqb84JVGaMt2Mch/XsNqmw38mh/kWIOczl1+aSfojYjwvPWnkVT0z
 zeBYxWSj02o09fDuqh1c1ftABUKI9QxyXU2GCBR2V2aNbgjbyvKcSUL75+QEIgn+hIxNaN3b6eMN+
 HQ75AhIB7YFYQ9KIFGF2dUiaHQ4ZLNQzEzLlTd1WzYc4Lz5oFphMfcUxRdKyObtKnqHpozib+pvzE
 Et/uKlCg==;
To: Jens Axboe <axboe@kernel.dk>
Date: Sat,  9 Apr 2022 06:50:43 +0200
Message-id: <20220409045043.23593-28-hch@lst.de>
X-Mailer: git-send-email 2.30.2
In-reply-to: <20220409045043.23593-1-hch@lst.de>
References: <20220409045043.23593-1-hch@lst.de>
MIME-version: 1.0
X-Source-IP: 198.137.202.133
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10311
 signatures=695566
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 clxscore=235
 priorityscore=78 bulkscore=0 suspectscore=0 mlxlogscore=286 lowpriorityscore=0
 phishscore=0 spamscore=0 mlxscore=0 adultscore=0 impostorscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
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
Subject: [Ocfs2-devel] [PATCH 27/27] direct-io: remove random prefetches
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
X-Proofpoint-ORIG-GUID: a7uiHKUx0YCjqEejn87R6xlOE6kYHc0O
X-Proofpoint-GUID: a7uiHKUx0YCjqEejn87R6xlOE6kYHc0O
Reporting-Meta:
 AAGhaL4M+/DEyn7at3aDmubE/idP4OdjFw3MIw+utXEBBfLptMUDE/2NdiX0GMFA
 fYMhaK869vnHWcZbvHGDsh9ebxT97mQxvlcUPkeCx22sQCa1GWuHdate6JtQSLRY
 JWGc2G7OuUkeQCg93t4qS7tclQzx8gM+M++SUGeWiaoq21GGMJ3kJ2Udlmveqopc
 tuGiPwrby6tdyNdaZEe8NMGSGf/kJUa/h4dCt6n7omZu3dW02TpvwjS4Ifj5WMUQ
 JuxH9YJUmug+rwzQtUe6RB7Xr9gyN2y8TlW+u4H6qx9iAlphz7SWAfTVPRzawYpq
 ai35GxfTTFHYjdr3MXC5ilSZcgnBE18BCqhNDFjSCNMhdlrfHxiWKgrP1nEwoK8Z
 9xZbyIJWoTMgEZrIh8oz543JXgQD5cxHe20GJwcG+xkMcUuCNLFWt402vCIs8XYR
 yVQr2w5717TIlf6cpxc+ZJk+/2+uxBIej/rAImqlE616S41pYKCC1cWoRP0XWMMj
 CpnoM0FUg6q3Bflps5Nc7aEgoP9zYCiLOC1wXNa4dJ+o

Randomly poking into block device internals for manual prefetches isn't
exactly a very maintainable thing to do.  And none of the performance
criticil direct I/O implementations still use this library function
anyway, so just drop it.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/direct-io.c | 32 ++++----------------------------
 1 file changed, 4 insertions(+), 28 deletions(-)

diff --git a/fs/direct-io.c b/fs/direct-io.c
index aef06e607b405..840752006f601 100644
--- a/fs/direct-io.c
+++ b/fs/direct-io.c
@@ -1115,11 +1115,10 @@ static inline int drop_refcount(struct dio *dio)
  * individual fields and will generate much worse code. This is important
  * for the whole file.
  */
-static inline ssize_t
-do_blockdev_direct_IO(struct kiocb *iocb, struct inode *inode,
-		      struct block_device *bdev, struct iov_iter *iter,
-		      get_block_t get_block, dio_iodone_t end_io,
-		      dio_submit_t submit_io, int flags)
+ssize_t __blockdev_direct_IO(struct kiocb *iocb, struct inode *inode,
+		struct block_device *bdev, struct iov_iter *iter,
+		get_block_t get_block, dio_iodone_t end_io,
+		dio_submit_t submit_io, int flags)
 {
 	unsigned i_blkbits = READ_ONCE(inode->i_blkbits);
 	unsigned blkbits = i_blkbits;
@@ -1334,29 +1333,6 @@ do_blockdev_direct_IO(struct kiocb *iocb, struct inode *inode,
 	kmem_cache_free(dio_cache, dio);
 	return retval;
 }
-
-ssize_t __blockdev_direct_IO(struct kiocb *iocb, struct inode *inode,
-			     struct block_device *bdev, struct iov_iter *iter,
-			     get_block_t get_block,
-			     dio_iodone_t end_io, dio_submit_t submit_io,
-			     int flags)
-{
-	/*
-	 * The block device state is needed in the end to finally
-	 * submit everything.  Since it's likely to be cache cold
-	 * prefetch it here as first thing to hide some of the
-	 * latency.
-	 *
-	 * Attempt to prefetch the pieces we likely need later.
-	 */
-	prefetch(&bdev->bd_disk->part_tbl);
-	prefetch(bdev->bd_disk->queue);
-	prefetch((char *)bdev->bd_disk->queue + SMP_CACHE_BYTES);
-
-	return do_blockdev_direct_IO(iocb, inode, bdev, iter, get_block,
-				     end_io, submit_io, flags);
-}
-
 EXPORT_SYMBOL(__blockdev_direct_IO);
 
 static __init int dio_init(void)
-- 
2.30.2


_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
