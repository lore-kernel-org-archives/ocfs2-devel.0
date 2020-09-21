From: Christoph Hellwig <hch@lst.de>
Date: Mon, 21 Sep 2020 09:19:47 +0200
Subject: [Ocfs2-devel] [PATCH 03/14] block: cleanup blkdev_bszset
In-Reply-To: <20200921071958.307589-1-hch@lst.de>
References: <20200921071958.307589-1-hch@lst.de>
Message-ID: <20200921071958.307589-4-hch@lst.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Jens Axboe <axboe@kernel.dk>
Cc: Josef Bacik <josef@toxicpanda.com>, Minchan Kim <minchan@kernel.org>, Stefan Haberland <sth@linux.ibm.com>, Jan Hoeppner <hoeppner@linux.ibm.com>, Joseph Qi <joseph.qi@linux.alibaba.com>, "Rafael J. Wysocki" <rjw@rjwysocki.net>, Pavel Machek <pavel@ucw.cz>, Len Brown <len.brown@intel.com>, Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org, nbd@other.debian.org, linux-ide@vger.kernel.org, linux-s390@vger.kernel.org, linux-fsdevel@vger.kernel.org, ocfs2-devel@oss.oracle.com, linux-pm@vger.kernel.org, linux-mm@kvack.org, linux-block@vger.kernel.org

Use blkdev_get_by_dev instead of bdgrab + blkdev_get.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 block/ioctl.c | 13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

diff --git a/block/ioctl.c b/block/ioctl.c
index ae74d0409afab9..06262c28f0c6c1 100644
--- a/block/ioctl.c
+++ b/block/ioctl.c
@@ -478,15 +478,14 @@ static int blkdev_bszset(struct block_device *bdev, fmode_t mode,
 	if (get_user(n, argp))
 		return -EFAULT;
 
-	if (!(mode & FMODE_EXCL)) {
-		bdgrab(bdev);
-		if (blkdev_get(bdev, mode | FMODE_EXCL, &bdev) < 0)
-			return -EBUSY;
-	}
+	if (mode & FMODE_EXCL)
+		return set_blocksize(bdev, n);
 
+	if (IS_ERR(blkdev_get_by_dev(bdev->bd_dev, mode | FMODE_EXCL, &bdev)))
+		return -EBUSY;
 	ret = set_blocksize(bdev, n);
-	if (!(mode & FMODE_EXCL))
-		blkdev_put(bdev, mode | FMODE_EXCL);
+	blkdev_put(bdev, mode | FMODE_EXCL);
+
 	return ret;
 }
 
-- 
2.28.0
