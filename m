Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc246.phx1.oracleemaildelivery.com (aib29ajc246.phx1.oracleemaildelivery.com [192.29.103.246])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C52E6C433F5
	for <ocfs2-devel@archiver.kernel.org>; Wed,  6 Apr 2022 06:07:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=PhDHsGMKQQqInfcK4NFKdoStLqrIw5x3XhmJbdsGIrk=;
 b=mfaSO9Pq7jDoEdaEYwAZwJjFQz0EEZEsz90MmkFedgEgLOe1tw1Chs8f5ay7AgB2hgtfi4VxFVWg
   zaLMFzrlKGUXarS8SgMpJ75LpmzhJ0pp1TGarho4ds3Lrdp/c0F1G4IRVAe5Zh1ZlgfphsvyKlOB
   w+Thjf6/k6qrSTLK0bAq3SeyEPonszObW2W+QijinVwP0wEeJCUbeYj2uQSYDuiT4aR95CZvLZ6Z
   TcsUBuKPRw9q+dusQq6idwbvp6CSKDd0J2gXCGNnfC+T8SUoD5VCh+14YdKPk+YBQLLIyaDtWq+X
   dwd+EuxQS+kaiaVy64HtGxZZeqJw5HwQaH703g==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=PhDHsGMKQQqInfcK4NFKdoStLqrIw5x3XhmJbdsGIrk=;
 b=Kb5WY7gOso6WwVqwfi4D59YPuzSEAfxOrGkd3GPK5KgpDWK7/0pmilGoqD/AqqyEUHfwaar5SHkn
   mxGEFj8hqM2fCHJjWoZocpfbhqSIHHzL9RtP7vbekPZ+eYHNmRQ+pZnxTYCQ+OV6tij8KhQ561x8
   g/cZM88YUvzrip2NMxbIEnTd88qiyjQuVYoF7RghTgw9YU1wWNljAfRerBYgk/S+rwlOuaW/ltaj
   dHWO+uw9Xlr9cd9hEC0C03HRQNMpWXAmGypbA84hdatn+lRK2Rp75awiuzCRUWjOns31Kv3ZXIxd
   H4lWCMg7RrU3qaJoe+hx3STVaM/imrc31nRlLw==
Received: by omta-ad1-fd3-101-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20220319 64bit (built Mar 19
 2022))
 with ESMTPS id <0R9W00L6WMCOSQ50@omta-ad1-fd3-101-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Wed, 06 Apr 2022 06:07:36 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
 MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
 :Reply-To:Content-Type:Content-ID:Content-Description;
 bh=eypoqjBCbHteIGJMjEE77faduCfiNIsAQ0ydQeu7OQ0=; b=VptJyLJo1YdsSUby4Fd8E+r4Wf
 u75rPubQZZ/yn7kcXtNA66cq//o6wORmNO306ozoa8JQt9/98VP+qYdEokdi0gKerj4PE3OuPTu8Q
 h26M8bnuUyy+YQCYjo1RqpA3/aCzFHGcLsWag2ZHixgBhRcZoEIlcW3opNjmON+bZ+OgC/YI0u6sz
 aGLKxbaAYtZUWCf6s02YkSBuNI+7SEUA0M0G1MZlz1sCKQq4Roo8U5n9rz4bFVVcw6Xtsem6nRg0D
 kLp1HHY2R8qfLsl/g0pBVddgXjUpubdbXmsxIgH4DU7KvKflDKEXJplNCCWhXhcgX+rKhGC3+ptTE
 sV6rOXrg==;
To: Jens Axboe <axboe@kernel.dk>
Date: Wed,  6 Apr 2022 08:05:16 +0200
Message-id: <20220406060516.409838-28-hch@lst.de>
X-Mailer: git-send-email 2.30.2
In-reply-to: <20220406060516.409838-1-hch@lst.de>
References: <20220406060516.409838-1-hch@lst.de>
MIME-version: 1.0
X-Source-IP: 198.137.202.133
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10308
 signatures=695566
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 mlxlogscore=288
 malwarescore=0 impostorscore=0 phishscore=0 spamscore=0 adultscore=0
 suspectscore=0 priorityscore=138 clxscore=347 lowpriorityscore=0 mlxscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
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
X-Proofpoint-ORIG-GUID: 1StqgTOPNcEKirA1yDUwvTE6220Mgnf2
X-Proofpoint-GUID: 1StqgTOPNcEKirA1yDUwvTE6220Mgnf2
Reporting-Meta:
 AAESXCyu5G+oWT7tOzMMlshTBBBU3IH9TcYRfenjQhh9dLJhrFT36KXfG8cXThvw
 A9z6bY2a7YL+7ykSQU+VJ6eXrqrY4/gSjFLNxBHxeba7fvlADkHJ7+DC6GtUpE6R
 ij+uHW7HhGFnlpBESWXgOpIIDM2FWfJ0ZdJ9p3YRBL/+s1vVWOyg3qME76W0Buka
 7ybrLl7JsI9yvNMGmG13/FplfCX2aOeOAyqs4vcYL5jhFOI/b7zr2TqHXx1l0CKE
 aJZ+IYMk2EJ8aG+gPbsC4sz6rbZ/I4WzQQOXddQk73Qom+KCiXlXXXb9Hk1D1ufu
 Q5VZTBO4boTSkhlLK/FsKnDmvuW4hA+vyT6mfGEKeCnGcGNLFf+G9CT/gF0cbjtW
 /HVrjxT/DzuJ6qSVcfb0XPshdloQhip3Ek237AvEtpVMbuNa4SCrTTGwmuZdPVc2
 l7xdmA6ettBlZ8VBZYyXvwL4TPqhMsica9t0+RJrv+ZPd4bJ1D6lkMu7gOyIdVZB
 Y7eoI8lrEk2h70u4TO2sshuWn/9RTi3YsU9iUONr1ek=

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
