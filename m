Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc244.phx1.oracleemaildelivery.com (aib29ajc244.phx1.oracleemaildelivery.com [192.29.103.244])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2F707C433FE
	for <ocfs2-devel@archiver.kernel.org>; Wed,  6 Apr 2022 06:06:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=QYsmkT4zi4VZmA9RWZhUaoHXdllwgpl67ECIlEQK660=;
 b=vRpLqgsS6mWq3u55S1IXe8U6n1ndBZIBH+UXHReZ/oAnYr9H1523jTmx7qrS62+YnQBnkdqQmuUt
   pwi5UrU1eKanrvrKvJFdv5qckbdJG9YZRuMIPRzziO3COdOd8Dej8dqbBXM5fs5x3bWtbtmAxkCW
   qN0uz31fuJx6r7coGrZBKDBJASb/ZYyd5iwUeLXLvNGlaDRXBteLRzHmbqG1RFB6qZoiuEyuaL4M
   O/DJwURYlCAfab9E0hx4TOG2mMN/zd+rF03QRVSEH93thtpXmSQJh4RiSeDYYEtlSDhBHv08nL3E
   pTouMd9Vv7awYYS7pSwlXInVYaBLjOfPEY67Aw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=QYsmkT4zi4VZmA9RWZhUaoHXdllwgpl67ECIlEQK660=;
 b=EbinWInIhltF0n9HJCUGVV8hLebX9y0LLrZiF0vgkijYYuVQVQuvgfAW6ON8LN/GI++5QyoFAWAQ
   ZTTNZKSTD1RNGH4IcQB3I2czcdViq7hrmYcy6mNfNglI5/cuMjkEwOSBA8RzPXcZaEFhWQXdIXm9
   dGSL8na0uyKGSRCwO/K7viXs4YTFy6cR3Z2gQ6IPjqd7f4lXnj4D/jUh6Xe2Wy1hFBuFwj0wncin
   jCTXT7uJNaZIV0QWD0ep/s5ehdycIaV67Nd/0F4gGW7frrhODPoUSLRsfCYrFQ3XxYs4uALdl78X
   pijdOkkqKnAmcWG5kPZ5XR/wdQ8L6vY21XD6vw==
Received: by omta-ad1-fd1-101-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20220319 64bit (built Mar 19
 2022))
 with ESMTPS id <0R9W00HH0MASEN80@omta-ad1-fd1-101-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Wed, 06 Apr 2022 06:06:28 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
 MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
 :Reply-To:Content-Type:Content-ID:Content-Description;
 bh=fS7/GWADeMq24JkrHR7r65A2kLOtCr2spfkGah3kNA8=; b=g32cCmyoUy2MRlX0jWgIKinv+J
 6HwpKjKiI/eRm+arkMK8TDswHRb73J8oTKSPnBofpTn14CEPyZoL01LqRjOtvyeXKFbsLDY3Nu7L4
 anEeb5+Aggr57EqWzZhxUaoJl9+gXGyNXHJMgbvEjwHLJg1kWbsYeqVpTbUmO0PiRUa8HmB2BNopv
 E3SfKbkMcTFFucBFZBhqgBji8PB09nLkBt9kHo7dRWBJH6O6HDJqa04XAMJtLW1qyTBz/MlzTUMIT
 UHal0RTYppwHeRMujtLS1mBLPZW+YY1ixxf0vQcYig56Z67v/avCgsL3+TyKFAe55JAIlZttPrHVS
 y4heheIQ==;
To: Jens Axboe <axboe@kernel.dk>
Date: Wed,  6 Apr 2022 08:04:59 +0200
Message-id: <20220406060516.409838-11-hch@lst.de>
X-Mailer: git-send-email 2.30.2
In-reply-to: <20220406060516.409838-1-hch@lst.de>
References: <20220406060516.409838-1-hch@lst.de>
MIME-version: 1.0
X-Source-IP: 198.137.202.133
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10308
 signatures=695566
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 suspectscore=0
 priorityscore=95 clxscore=268 impostorscore=0 malwarescore=0 mlxlogscore=819
 spamscore=0 phishscore=0 adultscore=0 bulkscore=0 mlxscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
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
Subject: [Ocfs2-devel] [PATCH 10/27] block: add a bdev_nonrot helper
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
X-Proofpoint-GUID: Qib8VI_w6_PtOYoUnTWPQS-0zjxK1Aca
X-Proofpoint-ORIG-GUID: Qib8VI_w6_PtOYoUnTWPQS-0zjxK1Aca
Reporting-Meta:
 AAG7octwdjZkja8Mm1fLuSxNK9W8ri2OgDimeKiPp3Nh5yWFGYcP0Vh6K5uyxV/T
 gH8veL7G3tZvT3Wa+4qvgf8sDMLMlLmHkL7Ciqtm38iwjZeXdXt+JC3gaQrXZDKZ
 Txhf2D2cWm0R6aKZOnDKbL9JU/LdAEvtK4nnOAsySqsMtseGryZ7QF+g8nc8nu+z
 srOAXKJrsu/7+9YKPHYLXYPWgdtm1p7wfRjJd6BpnTYsZQX/N8geCHALOPzglPpl
 ubHoZjwHAoEBw28OMzu3o3KOjxcAhgt8JfJaVSsUSbyZBis2oX0JM+iotGzAnWTo
 zCqCptQrm1+WrmbDGoGZo/t432jXjZpQU33cRLutbjtUwuNqJMA1ZehhI3V4kGEs
 /MvfjwPN1s58UipbVTif9DtRE+/WE6p8gMcFTZsi7D/FBtGGrM61fffLWSaJr6ka
 oGoWWtDMtRtab//0Hzm5a82OhHRmuN4wO1uKlN6new43rSgvkVJBhexHRjev+oE2
 UHa8lcXG4zLTXD9gqnRY5aDUOSVt14EsAHgO9HgUL5i9

Add a helper to check the nonrot flag based on the block_device instead
of having to poke into the block layer internal request_queue.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 block/ioctl.c                       | 2 +-
 drivers/block/loop.c                | 2 +-
 drivers/md/dm-table.c               | 4 +---
 drivers/md/md.c                     | 3 +--
 drivers/md/raid1.c                  | 2 +-
 drivers/md/raid10.c                 | 2 +-
 drivers/md/raid5.c                  | 2 +-
 drivers/target/target_core_file.c   | 3 +--
 drivers/target/target_core_iblock.c | 2 +-
 fs/btrfs/volumes.c                  | 4 ++--
 fs/ext4/mballoc.c                   | 2 +-
 include/linux/blkdev.h              | 5 +++++
 mm/swapfile.c                       | 4 ++--
 13 files changed, 19 insertions(+), 18 deletions(-)

diff --git a/block/ioctl.c b/block/ioctl.c
index 4a86340133e46..ad3771b268b81 100644
--- a/block/ioctl.c
+++ b/block/ioctl.c
@@ -489,7 +489,7 @@ static int blkdev_common_ioctl(struct block_device *bdev, fmode_t mode,
 				    queue_max_sectors(bdev_get_queue(bdev)));
 		return put_ushort(argp, max_sectors);
 	case BLKROTATIONAL:
-		return put_ushort(argp, !blk_queue_nonrot(bdev_get_queue(bdev)));
+		return put_ushort(argp, !bdev_nonrot(bdev));
 	case BLKRASET:
 	case BLKFRASET:
 		if(!capable(CAP_SYS_ADMIN))
diff --git a/drivers/block/loop.c b/drivers/block/loop.c
index a58595f5ee2c8..8d800d46e4985 100644
--- a/drivers/block/loop.c
+++ b/drivers/block/loop.c
@@ -903,7 +903,7 @@ static void loop_update_rotational(struct loop_device *lo)
 
 	/* not all filesystems (e.g. tmpfs) have a sb->s_bdev */
 	if (file_bdev)
-		nonrot = blk_queue_nonrot(bdev_get_queue(file_bdev));
+		nonrot = bdev_nonrot(file_bdev);
 
 	if (nonrot)
 		blk_queue_flag_set(QUEUE_FLAG_NONROT, q);
diff --git a/drivers/md/dm-table.c b/drivers/md/dm-table.c
index 03541cfc2317c..5e38d0dd009d5 100644
--- a/drivers/md/dm-table.c
+++ b/drivers/md/dm-table.c
@@ -1820,9 +1820,7 @@ static int device_dax_write_cache_enabled(struct dm_target *ti,
 static int device_is_rotational(struct dm_target *ti, struct dm_dev *dev,
 				sector_t start, sector_t len, void *data)
 {
-	struct request_queue *q = bdev_get_queue(dev->bdev);
-
-	return !blk_queue_nonrot(q);
+	return !bdev_nonrot(dev->bdev);
 }
 
 static int device_is_not_random(struct dm_target *ti, struct dm_dev *dev,
diff --git a/drivers/md/md.c b/drivers/md/md.c
index 309b3af906ad3..19636c2f2cda4 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -5991,8 +5991,7 @@ int md_run(struct mddev *mddev)
 		bool nonrot = true;
 
 		rdev_for_each(rdev, mddev) {
-			if (rdev->raid_disk >= 0 &&
-			    !blk_queue_nonrot(bdev_get_queue(rdev->bdev))) {
+			if (rdev->raid_disk >= 0 && !bdev_nonrot(rdev->bdev)) {
 				nonrot = false;
 				break;
 			}
diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index 99d5464a51f81..d81b896855f9f 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -704,7 +704,7 @@ static int read_balance(struct r1conf *conf, struct r1bio *r1_bio, int *max_sect
 			/* At least two disks to choose from so failfast is OK */
 			set_bit(R1BIO_FailFast, &r1_bio->state);
 
-		nonrot = blk_queue_nonrot(bdev_get_queue(rdev->bdev));
+		nonrot = bdev_nonrot(rdev->bdev);
 		has_nonrot_disk |= nonrot;
 		pending = atomic_read(&rdev->nr_pending);
 		dist = abs(this_sector - conf->mirrors[disk].head_position);
diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index dfe7d62d3fbdd..7816c8b2e8087 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -796,7 +796,7 @@ static struct md_rdev *read_balance(struct r10conf *conf,
 		if (!do_balance)
 			break;
 
-		nonrot = blk_queue_nonrot(bdev_get_queue(rdev->bdev));
+		nonrot = bdev_nonrot(rdev->bdev);
 		has_nonrot_disk |= nonrot;
 		pending = atomic_read(&rdev->nr_pending);
 		if (min_pending > pending && nonrot) {
diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 351d341a1ffa4..0bbae0e638666 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -7242,7 +7242,7 @@ static struct r5conf *setup_conf(struct mddev *mddev)
 	rdev_for_each(rdev, mddev) {
 		if (test_bit(Journal, &rdev->flags))
 			continue;
-		if (blk_queue_nonrot(bdev_get_queue(rdev->bdev))) {
+		if (bdev_nonrot(rdev->bdev)) {
 			conf->batch_bio_dispatch = false;
 			break;
 		}
diff --git a/drivers/target/target_core_file.c b/drivers/target/target_core_file.c
index 8d191fdc33217..b6ba582b06775 100644
--- a/drivers/target/target_core_file.c
+++ b/drivers/target/target_core_file.c
@@ -135,7 +135,6 @@ static int fd_configure_device(struct se_device *dev)
 	inode = file->f_mapping->host;
 	if (S_ISBLK(inode->i_mode)) {
 		struct block_device *bdev = I_BDEV(inode);
-		struct request_queue *q = bdev_get_queue(bdev);
 		unsigned long long dev_size;
 
 		fd_dev->fd_block_size = bdev_logical_block_size(bdev);
@@ -160,7 +159,7 @@ static int fd_configure_device(struct se_device *dev)
 		 */
 		dev->dev_attrib.max_write_same_len = 0xFFFF;
 
-		if (blk_queue_nonrot(q))
+		if (bdev_nonrot(bdev))
 			dev->dev_attrib.is_nonrot = 1;
 	} else {
 		if (!(fd_dev->fbd_flags & FBDF_HAS_SIZE)) {
diff --git a/drivers/target/target_core_iblock.c b/drivers/target/target_core_iblock.c
index b886ce1770bfd..b41ee5c3b5b82 100644
--- a/drivers/target/target_core_iblock.c
+++ b/drivers/target/target_core_iblock.c
@@ -133,7 +133,7 @@ static int iblock_configure_device(struct se_device *dev)
 	else
 		dev->dev_attrib.max_write_same_len = 0xFFFF;
 
-	if (blk_queue_nonrot(q))
+	if (bdev_nonrot(bd))
 		dev->dev_attrib.is_nonrot = 1;
 
 	bi = bdev_get_integrity(bd);
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 1be7cb2f955fc..1e68674e2cd82 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -643,7 +643,7 @@ static int btrfs_open_one_device(struct btrfs_fs_devices *fs_devices,
 			set_bit(BTRFS_DEV_STATE_WRITEABLE, &device->dev_state);
 	}
 
-	if (!blk_queue_nonrot(bdev_get_queue(bdev)))
+	if (!bdev_nonrot(bdev))
 		fs_devices->rotating = true;
 
 	device->bdev = bdev;
@@ -2715,7 +2715,7 @@ int btrfs_init_new_device(struct btrfs_fs_info *fs_info, const char *device_path
 
 	atomic64_add(device->total_bytes, &fs_info->free_chunk_space);
 
-	if (!blk_queue_nonrot(bdev_get_queue(bdev)))
+	if (!bdev_nonrot(bdev))
 		fs_devices->rotating = true;
 
 	orig_super_total_bytes = btrfs_super_total_bytes(fs_info->super_copy);
diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index 252c168454c7f..c3668c977cd99 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -3498,7 +3498,7 @@ int ext4_mb_init(struct super_block *sb)
 		spin_lock_init(&lg->lg_prealloc_lock);
 	}
 
-	if (blk_queue_nonrot(bdev_get_queue(sb->s_bdev)))
+	if (bdev_nonrot(sb->s_bdev))
 		sbi->s_mb_max_linear_groups = 0;
 	else
 		sbi->s_mb_max_linear_groups = MB_DEFAULT_LINEAR_LIMIT;
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 60d0161389971..3a9578e14a6b0 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -1326,6 +1326,11 @@ static inline unsigned int bdev_write_zeroes_sectors(struct block_device *bdev)
 	return 0;
 }
 
+static inline bool bdev_nonrot(struct block_device *bdev)
+{
+	return blk_queue_nonrot(bdev_get_queue(bdev));
+}
+
 static inline enum blk_zoned_model bdev_zoned_model(struct block_device *bdev)
 {
 	struct request_queue *q = bdev_get_queue(bdev);
diff --git a/mm/swapfile.c b/mm/swapfile.c
index 4c7537162af5e..d5ab7ec4d92ca 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -2466,7 +2466,7 @@ SYSCALL_DEFINE1(swapoff, const char __user *, specialfile)
 	if (p->flags & SWP_CONTINUED)
 		free_swap_count_continuations(p);
 
-	if (!p->bdev || !blk_queue_nonrot(bdev_get_queue(p->bdev)))
+	if (!p->bdev || !bdev_nonrot(p->bdev))
 		atomic_dec(&nr_rotate_swap);
 
 	mutex_lock(&swapon_mutex);
@@ -3071,7 +3071,7 @@ SYSCALL_DEFINE2(swapon, const char __user *, specialfile, int, swap_flags)
 	if (p->bdev && p->bdev->bd_disk->fops->rw_page)
 		p->flags |= SWP_SYNCHRONOUS_IO;
 
-	if (p->bdev && blk_queue_nonrot(bdev_get_queue(p->bdev))) {
+	if (p->bdev && bdev_nonrot(p->bdev)) {
 		int cpu;
 		unsigned long ci, nr_cluster;
 
-- 
2.30.2


_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
