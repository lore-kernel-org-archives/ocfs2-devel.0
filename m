From: Christoph Hellwig <hch@lst.de>
Date: Thu, 17 Sep 2020 18:57:14 +0200
Subject: [Ocfs2-devel] [PATCH 08/14] dasd: cleanup dasd_scan_partitions
In-Reply-To: <20200917165720.3285256-1-hch@lst.de>
References: <20200917165720.3285256-1-hch@lst.de>
Message-ID: <20200917165720.3285256-9-hch@lst.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Jens Axboe <axboe@kernel.dk>
Cc: Josef Bacik <josef@toxicpanda.com>, Minchan Kim <minchan@kernel.org>, Stefan Haberland <sth@linux.ibm.com>, Jan Hoeppner <hoeppner@linux.ibm.com>, Joseph Qi <joseph.qi@linux.alibaba.com>, "Rafael J. Wysocki" <rjw@rjwysocki.net>, Pavel Machek <pavel@ucw.cz>, Len Brown <len.brown@intel.com>, Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org, nbd@other.debian.org, linux-ide@vger.kernel.org, linux-s390@vger.kernel.org, linux-fsdevel@vger.kernel.org, ocfs2-devel@oss.oracle.com, linux-pm@vger.kernel.org, linux-mm@kvack.org, linux-block@vger.kernel.org

Use blkdev_get_by_dev instead of bdget_disk + blkdev_get.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/s390/block/dasd_genhd.c | 13 +++----------
 1 file changed, 3 insertions(+), 10 deletions(-)

diff --git a/drivers/s390/block/dasd_genhd.c b/drivers/s390/block/dasd_genhd.c
index af5b0ecb8f8923..70c09a46d22806 100644
--- a/drivers/s390/block/dasd_genhd.c
+++ b/drivers/s390/block/dasd_genhd.c
@@ -101,18 +101,11 @@ int dasd_scan_partitions(struct dasd_block *block)
 	struct block_device *bdev;
 	int rc;
 
-	bdev = bdget_disk(block->gdp, 0);
-	if (!bdev) {
-		DBF_DEV_EVENT(DBF_ERR, block->base, "%s",
-			      "scan partitions error, bdget returned NULL");
-		return -ENODEV;
-	}
-
-	rc = blkdev_get(bdev, FMODE_READ, NULL);
-	if (rc < 0) {
+	bdev = blkdev_get_by_dev(disk_devt(block->gdp), FMODE_READ, NULL);
+	if (IS_ERR(bdev)) {
 		DBF_DEV_EVENT(DBF_ERR, block->base,
 			      "scan partitions error, blkdev_get returned %d",
-			      rc);
+			      IS_ERR(bdev));
 		return -ENODEV;
 	}
 
-- 
2.28.0
