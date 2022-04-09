Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc246.phx1.oracleemaildelivery.com (aib29ajc246.phx1.oracleemaildelivery.com [192.29.103.246])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 01E70C433EF
	for <ocfs2-devel@archiver.kernel.org>; Sat,  9 Apr 2022 04:52:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=cFZFHy2P1yEByFwgaUITjjO2DIQYosKuMDJLZz0CSPc=;
 b=PanAfvS2rvSy/Tk3m6Ojv7Ej99OAW/h1bDRRMoYl+v7ooz5pDfPrbjyZg+AXZ2ARoSWUEpIljB6h
   RF29t/lDbmHdvSO8RuLKIckLaGxR1S9Pmn5iScYZhfC0TI24h40/8AhFIjDjAhvcEuaq4kxgB7YP
   IozsHd0I4XLNhausA7MrT5ab7TMVnX5UUEamT7epPjAS6PNWRl/Te6xpxJcxLKAzJ8yUPLNKpadV
   EpVGv8HbcuyISR0aWhvGtnWYEOhFVJ2SLMjfraRGUuMWEM7X3kPhB1roBq+gE+IeMkkbHQd4Nwv6
   kjP4MgHtaW+nzFUxRhbEdq2uk+HWZjHyt2ZD/A==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=cFZFHy2P1yEByFwgaUITjjO2DIQYosKuMDJLZz0CSPc=;
 b=ptaQGzue3eoMPTQXD2SQdS1gKvNkeqfQuDnYMhsaP67KrDMuLkFNHvXt9TeT/QLTqUsj6/KRDdyn
   0/7PX72HugN/S/hNB20EekeWP6uwo7hszG4fJZRu7OJpYo4FpdVZPiSz5oDijTpqjNeW8FvSMR47
   rN/IU8kltX7S5zvmZO9rfM46Yobq9R+UHtOCelnF8dthDxjqBgnb2sWHSvCAkGp8kEkxgV4eVY1O
   3xfIp1seLyPvwezn9hvqTHitnd0v46CR3tAESXw/FJg6ltOlfCSQFXAgLULuJzAExLiAmKu0Ecjj
   h+9noCehB7rrbJSGjf2EJR9oh/PgaQcsc8tC2g==
Received: by omta-ad1-fd3-101-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20220319 64bit (built Mar 19
 2022))
 with ESMTPS id <0RA200OH32UWKN20@omta-ad1-fd3-101-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Sat, 09 Apr 2022 04:52:08 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
 MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
 :Reply-To:Content-Type:Content-ID:Content-Description;
 bh=2RG8/4DncVNJBVxiwRZlDWFw3of1TwdfVdHLgkB+Spw=; b=bHToJbTwXX9JeK0n0FFEHck7oK
 nA96qn4tsO9VvTxVN8oChK/ZngVrRM/0RF6G9ra3tv3c4LiSpAW93VdnTUb837bG7nj26lWP035AX
 +oB1LRxVd3o4RNZBzKIPVYYv/AqgqQH13jSTRjPJXLj+fHe3sQ7lQiOs0AqFOPiV0QvmbZSG1K8qh
 9AilEZ6nzAlZEnIp9Du8I20RfuJmhuvcocvyHX9G65n9qxdF8wS5MzRNFD9kn7Nula/Xd3cMLnifm
 ikockttcbAn2ou+cROly75gq/5PqLm1F2FPp9pVf438qn2667h4Aje3z8zrXhBCgwdMkGUyOJsCBu
 B0U5qlrw==;
To: Jens Axboe <axboe@kernel.dk>
Date: Sat,  9 Apr 2022 06:50:30 +0200
Message-id: <20220409045043.23593-15-hch@lst.de>
X-Mailer: git-send-email 2.30.2
In-reply-to: <20220409045043.23593-1-hch@lst.de>
References: <20220409045043.23593-1-hch@lst.de>
MIME-version: 1.0
X-Source-IP: 127.0.0.1
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10311
 signatures=695566
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 clxscore=231
 priorityscore=30 bulkscore=0 suspectscore=0 mlxlogscore=821 lowpriorityscore=0
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
X-ServerName: localhost
X-Proofpoint-SPF-Result: None
X-Spam: Clean
X-Proofpoint-GUID: EL-gAWYWdoQkptaDOhP85Fytge0tyGaT
X-Proofpoint-ORIG-GUID: EL-gAWYWdoQkptaDOhP85Fytge0tyGaT
Reporting-Meta:
 AAGYUbwR03wnJcf9syls7qDkPkrGJquYqpqGSkvddjM4z9O9rws9yNH1OGdrJXlo
 sJEH7cRSG+Yo7QSuIMgk+XXXIBylt63VZKYMpCELIaIwEPna380OKBAU4I1s/KTo
 x6z40TIKAsSxx1VA/tELGO2mr8/BrcinNeWY6gINcbJedCAlXJhpgujov/6pT2g5
 fdRnaaVRKjk3PscLxchf3x5FZeghtjD9ceU86FaOX41c11XvfxSpfTObWquQRxAZ
 zmAvoIBFKi0I5tecbtcQ8LW3Ff83yRlVsyjlQtPwnG2FHQ41H7Pz1PfKT0iGMvkN
 L7WqbL9C/wZmoFKEXIEpopBJDGhexHPUHEGXQbmOSwQC1KMGuQcr9ELg0LWTX58+
 WefSnayxRmkqGCcalxKh7REc3AHrgQ6V9Xq4ncPEWAeDl/w4ZME5y03KaaEM+PuS
 gDkR3QosC5uVAsPQ/wOzfAvgTzbyC4AvRgUaRCN3V4dHKsXBrDfauHWe8tuhJptg
 8A6Hh6bBb9LVWFNKNPEfFUm2ZAyf/7ZD90TtarrhyRnw

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
