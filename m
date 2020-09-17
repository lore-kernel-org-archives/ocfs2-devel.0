From: Christoph Hellwig <hch@lst.de>
Date: Thu, 17 Sep 2020 18:57:08 +0200
Subject: [Ocfs2-devel] [PATCH 02/14] block: switch register_disk to use
	blkdev_get_by_dev
In-Reply-To: <20200917165720.3285256-1-hch@lst.de>
References: <20200917165720.3285256-1-hch@lst.de>
Message-ID: <20200917165720.3285256-3-hch@lst.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Jens Axboe <axboe@kernel.dk>
Cc: Josef Bacik <josef@toxicpanda.com>, Minchan Kim <minchan@kernel.org>, Stefan Haberland <sth@linux.ibm.com>, Jan Hoeppner <hoeppner@linux.ibm.com>, Joseph Qi <joseph.qi@linux.alibaba.com>, "Rafael J. Wysocki" <rjw@rjwysocki.net>, Pavel Machek <pavel@ucw.cz>, Len Brown <len.brown@intel.com>, Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org, nbd@other.debian.org, linux-ide@vger.kernel.org, linux-s390@vger.kernel.org, linux-fsdevel@vger.kernel.org, ocfs2-devel@oss.oracle.com, linux-pm@vger.kernel.org, linux-mm@kvack.org, linux-block@vger.kernel.org

Use blkdev_get_by_dev instead of open coding it using bdget_disk +
blkdev_get.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 block/genhd.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/block/genhd.c b/block/genhd.c
index 7b56203c90a303..f778716fac6cde 100644
--- a/block/genhd.c
+++ b/block/genhd.c
@@ -732,10 +732,9 @@ static void register_disk(struct device *parent, struct gendisk *disk,
 		goto exit;
 
 	set_bit(GD_NEED_PART_SCAN, &disk->state);
-	err = blkdev_get(bdev, FMODE_READ, NULL);
-	if (err < 0)
-		goto exit;
-	blkdev_put(bdev, FMODE_READ);
+	bdev = blkdev_get_by_dev(disk_devt(disk), FMODE_READ, NULL);
+	if (!IS_ERR(bdev))
+		blkdev_put(bdev, FMODE_READ);
 
 exit:
 	/* announce disk after possible partitions are created */
-- 
2.28.0
