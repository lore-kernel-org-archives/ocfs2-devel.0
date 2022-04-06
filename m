Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc244.phx1.oracleemaildelivery.com (aib29ajc244.phx1.oracleemaildelivery.com [192.29.103.244])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 68028C4332F
	for <ocfs2-devel@archiver.kernel.org>; Wed,  6 Apr 2022 06:06:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=K8ti0vyUtzrbnt3fXFDcNLTrTIR3nKpcdqo2OVJ7cVo=;
 b=2Rkcu7Zc0jJ8if78JoMJlVTyJU8zmS+b4ZDQzviaHfJV8VxXXoc/BZGKDsTaTS5/ZblQeZa9P0/Z
   yE7WUT3rBYYwmHexKn8TA3xzIU3cUQxa+TIHJxRhYizzQHYayD3rwVeLwbFmvqkSvinrdqEG3tXd
   76eCkza35qZWZ5MOFnHS5wZVFg/du3GeLfcNh+YEQIAGWSnJ36EyCXEhh59jtHwyPQ7p+iVeMx7I
   tC/dQGrv2D3SyX8QsIsNbjAjHU62n4a6RBDSdNvj2wn62BsKlx5sZ46I5+Zm53FglExFi7SclQQ4
   Xs69SK02efX4dThr4yn741MxC02p0mqOEH78EQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=K8ti0vyUtzrbnt3fXFDcNLTrTIR3nKpcdqo2OVJ7cVo=;
 b=chppg4IvgiKrxEU+E+TTqKz70S0obj3MzKyZDsBbCkqOYojvvlQb3Fx+wLAoAHmX2GdFwZclhG/k
   5+VVD5bkJi6rFboYZIl8MsqONBHs1HdkSenY0coCFtCIpaX49eDpSg6rnlHSZeiqcn8kYYzARuQg
   F58YqcoEAc29rLwrvwcYPP1VEZtdN2HKvt2FC6dSEoIXTmJwZ0LjTaFNmHbHplftzeXFVN7Fk9g0
   dwR8EkZbwox0ARWZXHW8rOCe/oZhr/Hgc8uCegKDVWG4pOCd5n2QwSzd5x5/kT2nPH2g6P3sAfQJ
   JojjRwA5lyjRmil3vD6XNo7PCaGAAkIgCEdujA==
Received: by omta-ad1-fd1-101-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20220319 64bit (built Mar 19
 2022))
 with ESMTPS id <0R9W00HJ5MB4EN80@omta-ad1-fd1-101-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Wed, 06 Apr 2022 06:06:40 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
 MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
 :Reply-To:Content-Type:Content-ID:Content-Description;
 bh=P8BTzfbZzMhTwk+O/5Q9S2IjdA/Er5Nl5Yd1FdZzPNs=; b=jmLLAFsmpP/kGZ+yrDJsbaGT90
 3PwfbbG3wYKmDjHmMy+UJOFVGL4TGDhECV3MOyV3UV8eSqcB0oTUed5n8oqNZktxd33ScowUP7QGh
 zbHFLMbrLKGeYKPMV8S63E/RRGEzhJrhrEAo36bmKxr9IL3fiqhq4h4HV/PV2BMnFoSisR8vXTGSe
 pm93ugKsrwSXqQ5J/PUF18cWu1plS4ueu1I2pDS3596vDa7E3hJWQLYJIHPBT5CXRTFQ5Q3FfKMQJ
 gbNfl56sQdKYZDUFA7Rmbrh+TTmjlhI2tnHxRO3P8MOrLI7+hAjFr/PXAnmPHqK5dQh0zlvNaSpaR
 rj8Pm/Qw==;
To: Jens Axboe <axboe@kernel.dk>
Date: Wed,  6 Apr 2022 08:05:03 +0200
Message-id: <20220406060516.409838-15-hch@lst.de>
X-Mailer: git-send-email 2.30.2
In-reply-to: <20220406060516.409838-1-hch@lst.de>
References: <20220406060516.409838-1-hch@lst.de>
MIME-version: 1.0
X-Source-IP: 198.137.202.133
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10308
 signatures=695566
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 impostorscore=0
 malwarescore=0 spamscore=0 priorityscore=30 phishscore=0 mlxscore=0
 suspectscore=0 bulkscore=0 lowpriorityscore=0 adultscore=0 clxscore=265
 mlxlogscore=527 classifier=spam adjust=0 reason=mlx scancount=1
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
Subject: [Ocfs2-devel] [PATCH 14/27] block: add a	bdev_max_zone_append_sectors
 helper
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
X-Proofpoint-ORIG-GUID: -1C9JCaoYgnZNBtTPQGkL7PbGk7dnDFF
X-Proofpoint-GUID: -1C9JCaoYgnZNBtTPQGkL7PbGk7dnDFF
Reporting-Meta:
 AAEE3yOUBLVwI+2dxe/NvwC+4Okb1pW354QI0597fU9azEKSAM4SouIdXunHDl7r
 SamEo7AAGWzRow0yIEqyhV5RgvKlfQgCwEBN1BHRhgYCJjq/twgV8WHVLIJZMXGp
 YI6nzvPYACDuNuQOQiZoppdJxFFjrTMBy/G1ejWSsIEGvtY1zTyNFXiEsQ40MuC5
 N3UN8SFIhHasAYyozc1Q+On5tcN33u2LKofjwK/FoTlWkdb5XjcPIkiL6GgJ/RxN
 FHG7H7mMlA7ZILGAgpJRs5FNNMkNMWzGCDvxRYqL6BgyH90DkXo0CkDw89s66Iym
 PxcXKtNdijlyX6si4ZsT6v5/rLeddKy5IXRv5+zi2etueWCMBBT5iw9G1l4VTT4f
 ltUKX5RiH+Cb7hDIlaIthXME/i7tYe1CcJ0NXg3cGq/0jxkT9u75NkG2xdu2Im25
 O+xrvmqPEpKu+l7OA+DThXppfZbB9l6xjp1nOG8NiBcL76aGTWSS6iuYmpTYN8Sq
 FM+Wy6hy96IoTUO3YN27tekZ4iG6zVNHbEVu/llrWGj+

Add a helper to check the max supported sectors for zone append based on
the block_device instead of having to poke into the block layer internal
request_queue.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/nvme/target/zns.c | 3 +--
 fs/zonefs/super.c         | 3 +--
 include/linux/blkdev.h    | 6 ++++++
 3 files changed, 8 insertions(+), 4 deletions(-)

diff --git a/drivers/nvme/target/zns.c b/drivers/nvme/target/zns.c
index e34718b095504..82b61acf7a72b 100644
--- a/drivers/nvme/target/zns.c
+++ b/drivers/nvme/target/zns.c
@@ -34,8 +34,7 @@ static int validate_conv_zones_cb(struct blk_zone *z,
 
 bool nvmet_bdev_zns_enable(struct nvmet_ns *ns)
 {
-	struct request_queue *q = ns->bdev->bd_disk->queue;
-	u8 zasl = nvmet_zasl(queue_max_zone_append_sectors(q));
+	u8 zasl = nvmet_zasl(bdev_max_zone_append_sectors(ns->bdev));
 	struct gendisk *bd_disk = ns->bdev->bd_disk;
 	int ret;
 
diff --git a/fs/zonefs/super.c b/fs/zonefs/super.c
index 3614c7834007d..7a63807b736c4 100644
--- a/fs/zonefs/super.c
+++ b/fs/zonefs/super.c
@@ -678,13 +678,12 @@ static ssize_t zonefs_file_dio_append(struct kiocb *iocb, struct iov_iter *from)
 	struct inode *inode = file_inode(iocb->ki_filp);
 	struct zonefs_inode_info *zi = ZONEFS_I(inode);
 	struct block_device *bdev = inode->i_sb->s_bdev;
-	unsigned int max;
+	unsigned int max = bdev_max_zone_append_sectors(bdev);
 	struct bio *bio;
 	ssize_t size;
 	int nr_pages;
 	ssize_t ret;
 
-	max = queue_max_zone_append_sectors(bdev_get_queue(bdev));
 	max = ALIGN_DOWN(max << SECTOR_SHIFT, inode->i_sb->s_blocksize);
 	iov_iter_truncate(from, max);
 
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index a433798c3343e..f8c50b77543eb 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -1188,6 +1188,12 @@ static inline unsigned int queue_max_zone_append_sectors(const struct request_qu
 	return min(l->max_zone_append_sectors, l->max_sectors);
 }
 
+static inline unsigned int
+bdev_max_zone_append_sectors(struct block_device *bdev)
+{
+	return queue_max_zone_append_sectors(bdev_get_queue(bdev));
+}
+
 static inline unsigned queue_logical_block_size(const struct request_queue *q)
 {
 	int retval = 512;
-- 
2.30.2


_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
