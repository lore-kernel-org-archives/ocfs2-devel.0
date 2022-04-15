Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc255.phx1.oracleemaildelivery.com (aib29ajc255.phx1.oracleemaildelivery.com [192.29.103.255])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D5CB8C3527D
	for <ocfs2-devel@archiver.kernel.org>; Fri, 15 Apr 2022 04:54:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=PhDHsGMKQQqInfcK4NFKdoStLqrIw5x3XhmJbdsGIrk=;
 b=b7Q5RNjKYC0F0Bv9eP4x7uPXrbUiBoZteMrGCSJtZb2+36JfjRqVuaJKlQBWdCy31IVQCGDhpNPO
   JcQ/rQG7UXIBsRHoxz+LR8O6GyJmbUIvyNjYHyXnGdfyLXcSbthgNh1I4Aw+0P+TdWDHC3rR+r5p
   BEcFNrq2GVs9Wh4KG2qs8a1ZDaR64DxsTpxLy9yTSStake52A36r1HKi2fvgImpGFvfHmzUXaKLZ
   b6AX/RTxHgniqyR19C31kBDuUmNsOyXvqz+53I+trmVNEJqMSy0EvJqsWrLcbSKIVv9eLs3fhyP1
   tzEmoIAY/CFFX+Yr3th0BwzPGJnp2NG9Bx+mgw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=PhDHsGMKQQqInfcK4NFKdoStLqrIw5x3XhmJbdsGIrk=;
 b=kv3G0Kpx29dSAJh2gxK4if7xx1SjRY4ioDbSVgnzjH3CBaVuFvkhkCBw27S/Qnl/IB5DBWupCOB7
   QaVmJYVK5Uxx6pKz9kDwMeTmjJsNv9PC6Bf4fLauO4t1q8wSxdGmXreB/a7YlRwgjonfutHC+B2Z
   3cKCwAwaqG/2Z/L/vnKFDzQmnI1M0eVEd5mTumANr+cEsPqk2X2RHJyCyfBgSdYcIT36DMzgxWLt
   uC8w9LsOSGnVkVBRPh312jDA9NWqDMoAD5s0LuO2PEGfqTtyjS5StoXoLTk1g9AjoqKaEe5YDe22
   mihRdIopxtIuM+Oz/z9Oicor11gQm9J/baQEhw==
Received: by omta-ad3-fd3-302-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20220319 64bit (built Mar 19
 2022))
 with ESMTPS id <0RAD00B5D6ZBE2C0@omta-ad3-fd3-302-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Fri, 15 Apr 2022 04:54:47 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
 MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
 :Reply-To:Content-Type:Content-ID:Content-Description;
 bh=eypoqjBCbHteIGJMjEE77faduCfiNIsAQ0ydQeu7OQ0=; b=yel/I7wJHKQGgU++DGlNr4s6By
 PhYVQZj76IsIJmZMeImq5Q6B2/aQRkMD3ug5dWOU3Jeh5aspjbtIuEjPut08JeM1WmCeQvYQ+tJ0f
 U696Xi8dd1qtuDaSpjLkD+EO876944juvaQn7mqYu4AmZhVRFKFIBWZURNzhkvK80mkS4SdYE8ghg
 5kwkeIFA+dIpz0sffz1xoP4BK6LoTUtTMKLOpm6yB1H7oV7nfL4grqbNBsJP5+jCEy6k9Hq/bQASA
 9dlkqzozrnkdCC5ckIaWKU5KZigzG6TnQjnKvn/KI4zIY9eR4oRyKCNwIxfdzpwno3WYuY2QxxbuI
 z9ygJJXA==;
To: Jens Axboe <axboe@kernel.dk>
Date: Fri, 15 Apr 2022 06:52:58 +0200
Message-id: <20220415045258.199825-28-hch@lst.de>
X-Mailer: git-send-email 2.30.2
In-reply-to: <20220415045258.199825-1-hch@lst.de>
References: <20220415045258.199825-1-hch@lst.de>
MIME-version: 1.0
X-Source-IP: 198.137.202.133
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10317
 signatures=695566
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 clxscore=250
 bulkscore=0 phishscore=0 adultscore=0 malwarescore=0 lowpriorityscore=0
 suspectscore=0 mlxlogscore=336 priorityscore=229 spamscore=0 impostorscore=0
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
X-Proofpoint-ORIG-GUID: Bkt2NuFynF2AOy0ZlriW6-jHVko_WJEU
X-Proofpoint-GUID: Bkt2NuFynF2AOy0ZlriW6-jHVko_WJEU
Reporting-Meta:
 AAENtVkpLmB6B7oaOjtZITnqizDGjLPjg163VXmTGnNHKiZrrmV6yaudRlZCw7QE
 oFJondEe35bUEiXyW3Nmlbw7s5QWOcRCaiZApFQ5kP7oEVaBPwzwGDXq8WBxGSYG
 TNsqn5aZOLhDSjyTt0+GkU9ijhisQ421wFIFuiT8GLQ2OQyGufnKgLpxTBQPb2an
 uYiiyhywuNtIl19wdj9VhPeDk/WEtWosIczNZ4+/Fu9c00jvJ4HzvhnrDCWBXjLi
 9w6kZBRH8Xd9RA955F4MWX3JROme6smOfOMVjYPSNpZWmpHW145OzVHP9+B2GNYN
 tk9MhdMtRZOdvwC0mfhoFLMgasJ6ey0cQvp+41w5LQiP7LYCy5lWtWnzPVASVq+U
 1dQg1Akw35JoLdHdGDEgmr6KnIEvuPVe3V6QzZ0YZ97Tjb3P14dchwEfc4JFfzN+
 yIutRaAxzNDYcosfUzOcKkMAa/zi5SPf3dFydGBYoUoE6Tt+iGpsEgDg0pWMAgFd
 xw8ZlLBeLa9iQ+XWkkXo2727uDh8reBJTmmDbeW2tVR3Ow==

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
