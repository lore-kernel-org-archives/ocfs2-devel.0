From: Christoph Hellwig <hch@lst.de>
Date: Thu, 17 Sep 2020 18:57:11 +0200
Subject: [Ocfs2-devel] [PATCH 05/14] pktcdvd: use blkdev_get_by_dev instead
	of open coding it
In-Reply-To: <20200917165720.3285256-1-hch@lst.de>
References: <20200917165720.3285256-1-hch@lst.de>
Message-ID: <20200917165720.3285256-6-hch@lst.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Jens Axboe <axboe@kernel.dk>
Cc: Josef Bacik <josef@toxicpanda.com>, Minchan Kim <minchan@kernel.org>, Stefan Haberland <sth@linux.ibm.com>, Jan Hoeppner <hoeppner@linux.ibm.com>, Joseph Qi <joseph.qi@linux.alibaba.com>, "Rafael J. Wysocki" <rjw@rjwysocki.net>, Pavel Machek <pavel@ucw.cz>, Len Brown <len.brown@intel.com>, Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org, nbd@other.debian.org, linux-ide@vger.kernel.org, linux-s390@vger.kernel.org, linux-fsdevel@vger.kernel.org, ocfs2-devel@oss.oracle.com, linux-pm@vger.kernel.org, linux-mm@kvack.org, linux-block@vger.kernel.org

Replace bdget + blkdev_get by blkdev_get_by_dev.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/block/pktcdvd.c | 25 +++++++++++--------------
 1 file changed, 11 insertions(+), 14 deletions(-)

diff --git a/drivers/block/pktcdvd.c b/drivers/block/pktcdvd.c
index bc870a5f15f77b..467dbd06b7cdb1 100644
--- a/drivers/block/pktcdvd.c
+++ b/drivers/block/pktcdvd.c
@@ -2110,16 +2110,18 @@ static int pkt_open_dev(struct pktcdvd_device *pd, fmode_t write)
 	int ret;
 	long lba;
 	struct request_queue *q;
+	struct block_device *bdev;
 
 	/*
 	 * We need to re-open the cdrom device without O_NONBLOCK to be able
 	 * to read/write from/to it. It is already opened in O_NONBLOCK mode
-	 * so bdget() can't fail.
+	 * so open should not fail.
 	 */
-	bdget(pd->bdev->bd_dev);
-	ret = blkdev_get(pd->bdev, FMODE_READ | FMODE_EXCL, pd);
-	if (ret)
+	bdev = blkdev_get_by_dev(pd->bdev->bd_dev, FMODE_READ | FMODE_EXCL, pd);
+	if (IS_ERR(bdev)) {
+		ret = PTR_ERR(bdev);
 		goto out;
+	}
 
 	ret = pkt_get_last_written(pd, &lba);
 	if (ret) {
@@ -2163,7 +2165,7 @@ static int pkt_open_dev(struct pktcdvd_device *pd, fmode_t write)
 	return 0;
 
 out_putdev:
-	blkdev_put(pd->bdev, FMODE_READ | FMODE_EXCL);
+	blkdev_put(bdev, FMODE_READ | FMODE_EXCL);
 out:
 	return ret;
 }
@@ -2500,7 +2502,6 @@ static int pkt_seq_show(struct seq_file *m, void *p)
 static int pkt_new_dev(struct pktcdvd_device *pd, dev_t dev)
 {
 	int i;
-	int ret = 0;
 	char b[BDEVNAME_SIZE];
 	struct block_device *bdev;
 
@@ -2523,12 +2524,9 @@ static int pkt_new_dev(struct pktcdvd_device *pd, dev_t dev)
 		}
 	}
 
-	bdev = bdget(dev);
-	if (!bdev)
-		return -ENOMEM;
-	ret = blkdev_get(bdev, FMODE_READ | FMODE_NDELAY, NULL);
-	if (ret)
-		return ret;
+	bdev = blkdev_get_by_dev(dev, FMODE_READ | FMODE_NDELAY, NULL);
+	if (IS_ERR(bdev))
+		return PTR_ERR(bdev);
 	if (!blk_queue_scsi_passthrough(bdev_get_queue(bdev))) {
 		blkdev_put(bdev, FMODE_READ | FMODE_NDELAY);
 		return -EINVAL;
@@ -2546,7 +2544,6 @@ static int pkt_new_dev(struct pktcdvd_device *pd, dev_t dev)
 	pd->cdrw.thread = kthread_run(kcdrwd, pd, "%s", pd->name);
 	if (IS_ERR(pd->cdrw.thread)) {
 		pkt_err(pd, "can't start kernel thread\n");
-		ret = -ENOMEM;
 		goto out_mem;
 	}
 
@@ -2558,7 +2555,7 @@ static int pkt_new_dev(struct pktcdvd_device *pd, dev_t dev)
 	blkdev_put(bdev, FMODE_READ | FMODE_NDELAY);
 	/* This is safe: open() is still holding a reference. */
 	module_put(THIS_MODULE);
-	return ret;
+	return -ENOMEM;
 }
 
 static int pkt_ioctl(struct block_device *bdev, fmode_t mode, unsigned int cmd, unsigned long arg)
-- 
2.28.0
