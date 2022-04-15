Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc245.phx1.oracleemaildelivery.com (aib29ajc245.phx1.oracleemaildelivery.com [192.29.103.245])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 73E0BC4707A
	for <ocfs2-devel@archiver.kernel.org>; Fri, 15 Apr 2022 04:54:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=cFZFHy2P1yEByFwgaUITjjO2DIQYosKuMDJLZz0CSPc=;
 b=IokYRnu0x2bNtBzIoweT6RjPs5v8ikVo9vCE82sYS4EpuMEbIpKVU5KLysBSpp3NHR0Zph/cXOBn
   fT/gAkj8AWpMCU1TxEel+71Zy9umbXTDLV1xv2NXdTRVE79UibX+kheKBudupoiV9PeRKKe0VVCw
   UUDZ35LkKvU+l4T/EYg3BIkGRxv7gFBhtiYOBz/6tnEMpAOWpuMkWkh5neaVWNwXyNzkc/KpcJwz
   OwcR0Eo7sL1xJcVdoms5g9Cb/SQE6LnIbJrgiYW0j4TZyFRVJIIdaiO9rFvkKZ811G26sJm1UTPy
   wvVFAfv0c4POvQMtjkmx0f93T2Cr8fhM7sxVZg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=cFZFHy2P1yEByFwgaUITjjO2DIQYosKuMDJLZz0CSPc=;
 b=pN9ZKC0dfqrXi5RpZS6e871h/kL+p5gWpXUG5kasKMLzYV++ejbEC9gSsSsOc277CEryPagf/D4Q
   VnJ80hE+Bu+tIVIjku/qFp3r2R7CwRWKbiQvTUCsBMTOnBAlQHSisp6PKFH5U6Ami86KDzDKPkIC
   gUuhAU5UDRh81Xe7atHZZpOuKtWBvvlnYQ9Ibk1KchrFvuYe6SB0Ks38xR50fjI1e6XUJ6D+/dY+
   3wqN3e8H1bgUxT3LInd3VJKY+boepmEnqqMaL7LTIO/hozKyT1hCCR6ttvrJGcfd6bSIxeVK0Igm
   +BJigaZqaAkZvyFMSekYESU9iEtody9tLHT0cg==
Received: by omta-ad1-fd1-102-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20220319 64bit (built Mar 19
 2022))
 with ESMTPS id <0RAD0030X6Z20WG0@omta-ad1-fd1-102-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Fri, 15 Apr 2022 04:54:38 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
 MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
 :Reply-To:Content-Type:Content-ID:Content-Description;
 bh=2RG8/4DncVNJBVxiwRZlDWFw3of1TwdfVdHLgkB+Spw=; b=TPuJfqXQYB+IC35ZbEz9CiQlaP
 djXIx0VTkzhzaYzpf2LZ0DDooPinTXguiju0AYCGSu3XAhEA+wzVismYaoX+3FR9eNAg3biu1OIj0
 CNWcQrqG9KwJqTbS05bqC74Hcp5G8fJ5Dpqbc41a5wovtXyrz6AnrzdO6HJSlv+co9m5WLmUX5I/2
 1vg6dJgX8fRkFI9MMSOkSfnCdkNwHb1kqsdqtSSukL34iYYeRnM6jabi2m1nx/iB0bJqJyAfSKPi1
 QfdCggnyqMztz/KBp1d+dGH+Q0SMobP0ybTMhNnUN2Xr4FneN5Nr0VM4ULPM98M5hdJ71ysDrIM3k
 XuXkKxgg==;
To: Jens Axboe <axboe@kernel.dk>
Date: Fri, 15 Apr 2022 06:52:45 +0200
Message-id: <20220415045258.199825-15-hch@lst.de>
X-Mailer: git-send-email 2.30.2
In-reply-to: <20220415045258.199825-1-hch@lst.de>
References: <20220415045258.199825-1-hch@lst.de>
MIME-version: 1.0
X-Source-IP: 198.137.202.133
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10317
 signatures=695566
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 phishscore=0
 impostorscore=0 suspectscore=0 malwarescore=0 clxscore=225 lowpriorityscore=0
 priorityscore=143 mlxscore=0 adultscore=0 mlxlogscore=801 spamscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
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
Subject: [Ocfs2-devel] [PATCH 14/27] block: add a bdev_stable_writes helper
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
X-Proofpoint-ORIG-GUID: NWfDYFj5zuGXbzMDtMpO409FxrWcPGRu
X-Proofpoint-GUID: NWfDYFj5zuGXbzMDtMpO409FxrWcPGRu
Reporting-Meta:
 AAGMgYTWCWlNdD649jUFdGZ9NlMto9M1/jU1tpHg9+qqgKkwmdb6x4o4RKbvH5Wg
 laJGV2b2h0KDzwYWWogNbbn3q/l4vLmgQ3IHV4v0dA0HS51So2CDBx6v4nGKm+nf
 wkDarqy+TaECxLkfnjg26LJGHoRpSX2qe3fxAiTiTuV16WDMe9comsQo2jysyzs5
 kcB1yi8+W8HW4q2ha7wrhE1j4/YZMpjQhm4ZsFNWuEWGIkRcDik9oR49ADrthI3h
 B5figsn7rw4mKi4/Fzp9LNxaupbCIh1Fk0pWozkQ1kq/v9KWZZdJjznfI0ThnNpM
 25KA55NKBzyRYg3RTlZxiXYFWICWmmX3JAjuBkrsZQ/OcbkCNXfq8GEfpQCo9gnS
 K54TClsrdAm08k0DDQlpxXYkaPI/JbMUgieLkRl7gAxjeqbgJXyFfQy4jjlDFp42
 Rr6jwwUJ1M6yapoPnAeumUpJtCW4R5AEWrnU54f9UjuGMlreWLF2OHTvhOw+z5/k
 SVa7F202SHfRAjk6PDKouEA8hsMtYsKRE9K2+8hYZYunwQ==

Add a helper to check the stable writes flag based on the block_device
instead of having to poke into the block layer internal request_queue.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>
---
 drivers/md/dm-table.c  | 4 +---
 fs/super.c             | 2 +-
 include/linux/blkdev.h | 6 ++++++
 mm/swapfile.c          | 2 +-
 4 files changed, 9 insertions(+), 5 deletions(-)

diff --git a/drivers/md/dm-table.c b/drivers/md/dm-table.c
index 5e38d0dd009d5..d46839faa0ca5 100644
--- a/drivers/md/dm-table.c
+++ b/drivers/md/dm-table.c
@@ -1950,9 +1950,7 @@ static int device_requires_stable_pages(struct dm_target *ti,
 					struct dm_dev *dev, sector_t start,
 					sector_t len, void *data)
 {
-	struct request_queue *q = bdev_get_queue(dev->bdev);
-
-	return blk_queue_stable_writes(q);
+	return bdev_stable_writes(dev->bdev);
 }
 
 int dm_table_set_restrictions(struct dm_table *t, struct request_queue *q,
diff --git a/fs/super.c b/fs/super.c
index f1d4a193602d6..60f57c7bc0a69 100644
--- a/fs/super.c
+++ b/fs/super.c
@@ -1204,7 +1204,7 @@ static int set_bdev_super(struct super_block *s, void *data)
 	s->s_dev = s->s_bdev->bd_dev;
 	s->s_bdi = bdi_get(s->s_bdev->bd_disk->bdi);
 
-	if (blk_queue_stable_writes(s->s_bdev->bd_disk->queue))
+	if (bdev_stable_writes(s->s_bdev))
 		s->s_iflags |= SB_I_STABLE_WRITES;
 	return 0;
 }
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 075b16d4560e7..a433798c3343e 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -1330,6 +1330,12 @@ static inline bool bdev_nonrot(struct block_device *bdev)
 	return blk_queue_nonrot(bdev_get_queue(bdev));
 }
 
+static inline bool bdev_stable_writes(struct block_device *bdev)
+{
+	return test_bit(QUEUE_FLAG_STABLE_WRITES,
+			&bdev_get_queue(bdev)->queue_flags);
+}
+
 static inline bool bdev_write_cache(struct block_device *bdev)
 {
 	return test_bit(QUEUE_FLAG_WC, &bdev_get_queue(bdev)->queue_flags);
diff --git a/mm/swapfile.c b/mm/swapfile.c
index d5ab7ec4d92ca..4069f17a82c8e 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -3065,7 +3065,7 @@ SYSCALL_DEFINE2(swapon, const char __user *, specialfile, int, swap_flags)
 		goto bad_swap_unlock_inode;
 	}
 
-	if (p->bdev && blk_queue_stable_writes(p->bdev->bd_disk->queue))
+	if (p->bdev && bdev_stable_writes(p->bdev))
 		p->flags |= SWP_STABLE_WRITES;
 
 	if (p->bdev && p->bdev->bd_disk->fops->rw_page)
-- 
2.30.2


_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
