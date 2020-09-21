From: Christoph Hellwig <hch@lst.de>
Date: Mon, 21 Sep 2020 09:19:53 +0200
Subject: [Ocfs2-devel] [PATCH 09/14] ocfs2: cleanup o2hb_region_dev_store
In-Reply-To: <20200921071958.307589-1-hch@lst.de>
References: <20200921071958.307589-1-hch@lst.de>
Message-ID: <20200921071958.307589-10-hch@lst.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Jens Axboe <axboe@kernel.dk>
Cc: Josef Bacik <josef@toxicpanda.com>, Minchan Kim <minchan@kernel.org>, Stefan Haberland <sth@linux.ibm.com>, Jan Hoeppner <hoeppner@linux.ibm.com>, Joseph Qi <joseph.qi@linux.alibaba.com>, "Rafael J. Wysocki" <rjw@rjwysocki.net>, Pavel Machek <pavel@ucw.cz>, Len Brown <len.brown@intel.com>, Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org, nbd@other.debian.org, linux-ide@vger.kernel.org, linux-s390@vger.kernel.org, linux-fsdevel@vger.kernel.org, ocfs2-devel@oss.oracle.com, linux-pm@vger.kernel.org, linux-mm@kvack.org, linux-block@vger.kernel.org

Use blkdev_get_by_dev instead of igrab (aka open coded bdgrab) +
blkdev_get.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
---
 fs/ocfs2/cluster/heartbeat.c | 28 ++++++++++------------------
 1 file changed, 10 insertions(+), 18 deletions(-)

diff --git a/fs/ocfs2/cluster/heartbeat.c b/fs/ocfs2/cluster/heartbeat.c
index 89d13e0705fe7b..0179a73a3fa2c4 100644
--- a/fs/ocfs2/cluster/heartbeat.c
+++ b/fs/ocfs2/cluster/heartbeat.c
@@ -1766,7 +1766,6 @@ static ssize_t o2hb_region_dev_store(struct config_item *item,
 	int sectsize;
 	char *p = (char *)page;
 	struct fd f;
-	struct inode *inode;
 	ssize_t ret = -EINVAL;
 	int live_threshold;
 
@@ -1793,20 +1792,16 @@ static ssize_t o2hb_region_dev_store(struct config_item *item,
 	    reg->hr_block_bytes == 0)
 		goto out2;
 
-	inode = igrab(f.file->f_mapping->host);
-	if (inode == NULL)
+	if (!S_ISBLK(f.file->f_mapping->host->i_mode))
 		goto out2;
 
-	if (!S_ISBLK(inode->i_mode))
-		goto out3;
-
-	reg->hr_bdev = I_BDEV(f.file->f_mapping->host);
-	ret = blkdev_get(reg->hr_bdev, FMODE_WRITE | FMODE_READ, NULL);
-	if (ret) {
+	reg->hr_bdev = blkdev_get_by_dev(f.file->f_mapping->host->i_rdev,
+					 FMODE_WRITE | FMODE_READ, NULL);
+	if (IS_ERR(reg->hr_bdev)) {
+		ret = PTR_ERR(reg->hr_bdev);
 		reg->hr_bdev = NULL;
-		goto out3;
+		goto out2;
 	}
-	inode = NULL;
 
 	bdevname(reg->hr_bdev, reg->hr_dev_name);
 
@@ -1909,16 +1904,13 @@ static ssize_t o2hb_region_dev_store(struct config_item *item,
 		       config_item_name(&reg->hr_item), reg->hr_dev_name);
 
 out3:
-	iput(inode);
+	if (ret < 0) {
+		blkdev_put(reg->hr_bdev, FMODE_READ | FMODE_WRITE);
+		reg->hr_bdev = NULL;
+	}
 out2:
 	fdput(f);
 out:
-	if (ret < 0) {
-		if (reg->hr_bdev) {
-			blkdev_put(reg->hr_bdev, FMODE_READ|FMODE_WRITE);
-			reg->hr_bdev = NULL;
-		}
-	}
 	return ret;
 }
 
-- 
2.28.0
