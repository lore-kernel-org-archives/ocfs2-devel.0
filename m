From: Christoph Hellwig <hch@lst.de>
Date: Mon, 21 Sep 2020 09:19:46 +0200
Subject: [Ocfs2-devel] [PATCH 02/14] block: cleanup partition scanning in
	register_disk
In-Reply-To: <20200921071958.307589-1-hch@lst.de>
References: <20200921071958.307589-1-hch@lst.de>
Message-ID: <20200921071958.307589-3-hch@lst.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Jens Axboe <axboe@kernel.dk>
Cc: Josef Bacik <josef@toxicpanda.com>, Minchan Kim <minchan@kernel.org>, Stefan Haberland <sth@linux.ibm.com>, Jan Hoeppner <hoeppner@linux.ibm.com>, Joseph Qi <joseph.qi@linux.alibaba.com>, "Rafael J. Wysocki" <rjw@rjwysocki.net>, Pavel Machek <pavel@ucw.cz>, Len Brown <len.brown@intel.com>, Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org, nbd@other.debian.org, linux-ide@vger.kernel.org, linux-s390@vger.kernel.org, linux-fsdevel@vger.kernel.org, ocfs2-devel@oss.oracle.com, linux-pm@vger.kernel.org, linux-mm@kvack.org, linux-block@vger.kernel.org

Use blkdev_get_by_dev instead of open coding it using bdget_disk +
blkdev_get, and split the code to read the partition table into a
separate helper to make it a little more obvious.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 block/genhd.c | 33 ++++++++++++++-------------------
 1 file changed, 14 insertions(+), 19 deletions(-)

diff --git a/block/genhd.c b/block/genhd.c
index 7b56203c90a303..05fb27cbb66784 100644
--- a/block/genhd.c
+++ b/block/genhd.c
@@ -673,11 +673,23 @@ static int exact_lock(dev_t devt, void *data)
 	return 0;
 }
 
+static void disk_scan_partitions(struct gendisk *disk)
+{
+	struct block_device *bdev;
+
+	if (!get_capacity(disk) || !disk_part_scan_enabled(disk))
+		return;
+
+	set_bit(GD_NEED_PART_SCAN, &disk->state);
+	bdev = blkdev_get_by_dev(disk_devt(disk), FMODE_READ, NULL);
+	if (!IS_ERR(bdev))
+		blkdev_put(bdev, FMODE_READ);
+}
+
 static void register_disk(struct device *parent, struct gendisk *disk,
 			  const struct attribute_group **groups)
 {
 	struct device *ddev = disk_to_dev(disk);
-	struct block_device *bdev;
 	struct disk_part_iter piter;
 	struct hd_struct *part;
 	int err;
@@ -719,25 +731,8 @@ static void register_disk(struct device *parent, struct gendisk *disk,
 		return;
 	}
 
-	/* No minors to use for partitions */
-	if (!disk_part_scan_enabled(disk))
-		goto exit;
-
-	/* No such device (e.g., media were just removed) */
-	if (!get_capacity(disk))
-		goto exit;
-
-	bdev = bdget_disk(disk, 0);
-	if (!bdev)
-		goto exit;
-
-	set_bit(GD_NEED_PART_SCAN, &disk->state);
-	err = blkdev_get(bdev, FMODE_READ, NULL);
-	if (err < 0)
-		goto exit;
-	blkdev_put(bdev, FMODE_READ);
+	disk_scan_partitions(disk);
 
-exit:
 	/* announce disk after possible partitions are created */
 	dev_set_uevent_suppress(ddev, 0);
 	kobject_uevent(&ddev->kobj, KOBJ_ADD);
-- 
2.28.0
