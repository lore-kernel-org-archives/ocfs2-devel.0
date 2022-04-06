Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc251.phx1.oracleemaildelivery.com (aib29ajc251.phx1.oracleemaildelivery.com [192.29.103.251])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4D108C433F5
	for <ocfs2-devel@archiver.kernel.org>; Wed,  6 Apr 2022 06:06:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=cc8G9UBqifY4Bg9BvgjY/2oEQxyxX6YBGoaWfjpRKYs=;
 b=uT3KxlR8Z79rMIm7oFR+dtk1Yj05A4P+1ztoFNnt9P411YXbwhcrRWFkFuWP8Yu+8Sm5Pen/TAkL
   sgPl/pjX+6ImkzxPf8H3jXA9cYj1nF/al7pWTZhGqaeZciLdI2hkIqugpZXoPgyhr/cnujRoWefD
   um/+2F62Y4vKr5oYD13/gSF+VDuczTEVAsXWGGp7XKBDVt3CWaCGer1EjSG5ABL+GhUHbFo7uHPe
   33nqF4iKIgkJIjlB/ory1x2FfjPTCRcrZPKM3NxgF/ibHU12CRkKkFlt3fL81BQ/FRSbGvaTe+o0
   n8J4hvsFh3ejR4Q1YQfqwhkDLs9usQ0pj0eqVg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=cc8G9UBqifY4Bg9BvgjY/2oEQxyxX6YBGoaWfjpRKYs=;
 b=bH9M4+l9z9oNdUm68liSO+diHbAT6YshNDWW/5x8FRimg/y6m8tcp96ySz9fnNn5r+gB0u+BkKdB
   jUB65kPPUqJOL9gg9hhdxwhb/wIjqSoHbQgW5YPrj7t2bq5tAzgYXRL7SOV7wNvEzgD34XazGmDV
   9sQ4pJTkSX3lHiRClhSUqDCSHqt8+G5GIbVkNc6M6Tb2XNq/im+7LBO3XB4S6NkSvg9+nfIwP0MD
   DC4I/hre3QN+dFtdOU3j2edncoV4877hhMh/OGhnQnHffmpf068oMQ/1YdPRvGgvmfOgR1mKPtXo
   qw6pIHmoZilvgFMOo76GLvmKszGlftHMMVecdQ==
Received: by omta-ad2-fd3-202-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20220319 64bit (built Mar 19
 2022))
 with ESMTPS id <0R9W00ALSMAZ4F80@omta-ad2-fd3-202-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Wed, 06 Apr 2022 06:06:35 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
 MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
 :Reply-To:Content-Type:Content-ID:Content-Description;
 bh=h9nRIyL4wrpJ3ypc009/z3A2dTvKLKo4vnaU7ryfwvk=; b=a9oCdCdHg2UWHjdBX3bxPs2eKR
 5hve9tuJweiHtNscXmQk+Ivzu2Q7V3Mhv54LpOAbMMyQCJFe1pzLSFTspFhvQH5RSd3zutfvDVBle
 gc7aQWZ1G4DVpBQSlfEnNf2ldCbJPt3gAAT/HH2ojp1/M3c6g9Su6hdyodjAivFbD+KIhySRZQL+J
 uMGgYqy0Bvib+9naGiIp1U//m5d564u8ZAFKPpmnTrgGDKoliPoyKaR90tTLnVja4b5oVEZAers0q
 p77NmZVl/ZfqKctngEgkCmQ/GGwXLM4DulJii5cEYj/W60uypGBwfA+RHY+qWe7ISyRLJtvjwNf2V
 jwMR1eTA==;
To: Jens Axboe <axboe@kernel.dk>
Date: Wed,  6 Apr 2022 08:05:02 +0200
Message-id: <20220406060516.409838-14-hch@lst.de>
X-Mailer: git-send-email 2.30.2
In-reply-to: <20220406060516.409838-1-hch@lst.de>
References: <20220406060516.409838-1-hch@lst.de>
MIME-version: 1.0
X-Source-IP: 198.137.202.133
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10308
 signatures=695566
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 mlxlogscore=404
 malwarescore=0 impostorscore=0 phishscore=0 spamscore=0 adultscore=0
 suspectscore=0 priorityscore=172 clxscore=321 lowpriorityscore=0 mlxscore=0
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
Subject: [Ocfs2-devel] [PATCH 13/27] block: add a bdev_stable_writes helper
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
X-Proofpoint-ORIG-GUID: ZuP7x4uhWJDfRQruu-DTOjrsO9mwxuEl
X-Proofpoint-GUID: ZuP7x4uhWJDfRQruu-DTOjrsO9mwxuEl
Reporting-Meta:
 AAFOqKCdCiqtbTFhLLCzU3MyvZ+JznA2KyHTZQrvS7tK2i+IExuvgP0R9W9HRrjB
 JCHLc4jdo+uQXo5Fiw4bt7K/ytZLsBvSbGrFa62pyn/N1bcwNrqOafTnvx1jWvGO
 Cei+si6aOVg9zhBr0NRyu/RPV4mpYq//pdEAFGhDgRSpH9ZtWthKKVAU1xapBovg
 9lfURYyk2/JlvTGrBKjb2HBs5DIVUk8c8MgP9ib5rSrWbgmG2cEJptW592dMpIfF
 yIj84vhj9Dd/ul9ImIERh7KUtC7bCvJ6Qc8fCMXCdCeDRApTO5F+PEKW6LEC+O7B
 baF8UBBoO4wPmZYlNVVCmxxW6hPy1zhWSCiqO29PNoUDiv5l94sO6g2utn8iYgi3
 vNjfcu85aGkxcckPaLYmOCfoZhHb/bDcwa9E1GX05x+S+IXnNHqV2UzoHSIHCRF3
 FuhjDePi75VTzSWBw6JWrVCF7UcwkI2f3owemmikscA19J9xoYNQ+OxvTFV8ZvrH
 0CfElUI9SY6QTH7A4LfcUNBNYziPE1TYIfqhaW+pqBg=

Add a helper to check the stable writes flag based on the block_device
instead of having to poke into the block layer internal request_queue.

Signed-off-by: Christoph Hellwig <hch@lst.de>
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
