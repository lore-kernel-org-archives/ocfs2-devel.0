From: Christoph Hellwig <hch@lst.de>
Date: Mon, 21 Sep 2020 09:19:51 +0200
Subject: [Ocfs2-devel] [PATCH 07/14] raw: don't keep unopened block device
	around
In-Reply-To: <20200921071958.307589-1-hch@lst.de>
References: <20200921071958.307589-1-hch@lst.de>
Message-ID: <20200921071958.307589-8-hch@lst.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Jens Axboe <axboe@kernel.dk>
Cc: Josef Bacik <josef@toxicpanda.com>, Minchan Kim <minchan@kernel.org>, Stefan Haberland <sth@linux.ibm.com>, Jan Hoeppner <hoeppner@linux.ibm.com>, Joseph Qi <joseph.qi@linux.alibaba.com>, "Rafael J. Wysocki" <rjw@rjwysocki.net>, Pavel Machek <pavel@ucw.cz>, Len Brown <len.brown@intel.com>, Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org, nbd@other.debian.org, linux-ide@vger.kernel.org, linux-s390@vger.kernel.org, linux-fsdevel@vger.kernel.org, ocfs2-devel@oss.oracle.com, linux-pm@vger.kernel.org, linux-mm@kvack.org, linux-block@vger.kernel.org

Turn binding into a normal dev_t as the struct block device doesn't
buy us anything and use blkdev_open_by_dev to actually open it.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/char/raw.c | 51 +++++++++++++++++-----------------------------
 1 file changed, 19 insertions(+), 32 deletions(-)

diff --git a/drivers/char/raw.c b/drivers/char/raw.c
index ccf5bd528642da..5d52a1f4738c76 100644
--- a/drivers/char/raw.c
+++ b/drivers/char/raw.c
@@ -28,7 +28,8 @@
 #include <linux/uaccess.h>
 
 struct raw_device_data {
-	struct block_device *binding;
+	dev_t binding;
+	struct block_device *bdev;
 	int inuse;
 };
 
@@ -73,14 +74,15 @@ static int raw_open(struct inode *inode, struct file *filp)
 	/*
 	 * All we need to do on open is check that the device is bound.
 	 */
-	bdev = raw_devices[minor].binding;
 	err = -ENODEV;
-	if (!bdev)
+	if (!raw_devices[minor].binding)
 		goto out;
-	bdgrab(bdev);
-	err = blkdev_get(bdev, filp->f_mode | FMODE_EXCL, raw_open);
-	if (err)
+	bdev = blkdev_get_by_dev(raw_devices[minor].binding,
+				 filp->f_mode | FMODE_EXCL, raw_open);
+	if (IS_ERR(bdev)) {
+		err = PTR_ERR(bdev);
 		goto out;
+	}
 	err = set_blocksize(bdev, bdev_logical_block_size(bdev));
 	if (err)
 		goto out1;
@@ -90,6 +92,7 @@ static int raw_open(struct inode *inode, struct file *filp)
 		file_inode(filp)->i_mapping =
 			bdev->bd_inode->i_mapping;
 	filp->private_data = bdev;
+	raw_devices[minor].bdev = bdev;
 	mutex_unlock(&raw_mutex);
 	return 0;
 
@@ -110,7 +113,7 @@ static int raw_release(struct inode *inode, struct file *filp)
 	struct block_device *bdev;
 
 	mutex_lock(&raw_mutex);
-	bdev = raw_devices[minor].binding;
+	bdev = raw_devices[minor].bdev;
 	if (--raw_devices[minor].inuse == 0)
 		/* Here  inode->i_mapping == bdev->bd_inode->i_mapping  */
 		inode->i_mapping = &inode->i_data;
@@ -133,6 +136,7 @@ raw_ioctl(struct file *filp, unsigned int command, unsigned long arg)
 static int bind_set(int number, u64 major, u64 minor)
 {
 	dev_t dev = MKDEV(major, minor);
+	dev_t raw = MKDEV(RAW_MAJOR, number);
 	struct raw_device_data *rawdev;
 	int err = 0;
 
@@ -166,25 +170,17 @@ static int bind_set(int number, u64 major, u64 minor)
 		mutex_unlock(&raw_mutex);
 		return -EBUSY;
 	}
-	if (rawdev->binding) {
-		bdput(rawdev->binding);
+	if (rawdev->binding)
 		module_put(THIS_MODULE);
-	}
+
+	rawdev->binding = dev;
 	if (!dev) {
 		/* unbind */
-		rawdev->binding = NULL;
-		device_destroy(raw_class, MKDEV(RAW_MAJOR, number));
+		device_destroy(raw_class, raw);
 	} else {
-		rawdev->binding = bdget(dev);
-		if (rawdev->binding == NULL) {
-			err = -ENOMEM;
-		} else {
-			dev_t raw = MKDEV(RAW_MAJOR, number);
-			__module_get(THIS_MODULE);
-			device_destroy(raw_class, raw);
-			device_create(raw_class, NULL, raw, NULL,
-				      "raw%d", number);
-		}
+		__module_get(THIS_MODULE);
+		device_destroy(raw_class, raw);
+		device_create(raw_class, NULL, raw, NULL, "raw%d", number);
 	}
 	mutex_unlock(&raw_mutex);
 	return err;
@@ -192,18 +188,9 @@ static int bind_set(int number, u64 major, u64 minor)
 
 static int bind_get(int number, dev_t *dev)
 {
-	struct raw_device_data *rawdev;
-	struct block_device *bdev;
-
 	if (number <= 0 || number >= max_raw_minors)
 		return -EINVAL;
-
-	rawdev = &raw_devices[number];
-
-	mutex_lock(&raw_mutex);
-	bdev = rawdev->binding;
-	*dev = bdev ? bdev->bd_dev : 0;
-	mutex_unlock(&raw_mutex);
+	*dev = raw_devices[number].binding;
 	return 0;
 }
 
-- 
2.28.0
