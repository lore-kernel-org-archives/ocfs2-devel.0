From: Christoph Hellwig <hch@lst.de>
Date: Mon, 21 Sep 2020 09:19:55 +0200
Subject: [Ocfs2-devel] [PATCH 11/14] PM: rewrite is_hibernate_resume_dev to
	not require an inode
In-Reply-To: <20200921071958.307589-1-hch@lst.de>
References: <20200921071958.307589-1-hch@lst.de>
Message-ID: <20200921071958.307589-12-hch@lst.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Jens Axboe <axboe@kernel.dk>
Cc: Josef Bacik <josef@toxicpanda.com>, Minchan Kim <minchan@kernel.org>, Stefan Haberland <sth@linux.ibm.com>, Jan Hoeppner <hoeppner@linux.ibm.com>, Joseph Qi <joseph.qi@linux.alibaba.com>, "Rafael J. Wysocki" <rjw@rjwysocki.net>, Pavel Machek <pavel@ucw.cz>, Len Brown <len.brown@intel.com>, Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org, nbd@other.debian.org, linux-ide@vger.kernel.org, linux-s390@vger.kernel.org, linux-fsdevel@vger.kernel.org, ocfs2-devel@oss.oracle.com, linux-pm@vger.kernel.org, linux-mm@kvack.org, linux-block@vger.kernel.org, "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>

Just check the dev_t to help simplifying the code.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Acked-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
---
 fs/block_dev.c          |  2 +-
 include/linux/suspend.h |  4 ++--
 kernel/power/user.c     | 12 ++++++------
 3 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/fs/block_dev.c b/fs/block_dev.c
index 1a9325f4315769..2898d69be6b3e4 100644
--- a/fs/block_dev.c
+++ b/fs/block_dev.c
@@ -1885,7 +1885,7 @@ ssize_t blkdev_write_iter(struct kiocb *iocb, struct iov_iter *from)
 	if (bdev_read_only(I_BDEV(bd_inode)))
 		return -EPERM;
 
-	if (IS_SWAPFILE(bd_inode) && !is_hibernate_resume_dev(bd_inode))
+	if (IS_SWAPFILE(bd_inode) && !is_hibernate_resume_dev(bd_inode->i_rdev))
 		return -ETXTBSY;
 
 	if (!iov_iter_count(from))
diff --git a/include/linux/suspend.h b/include/linux/suspend.h
index cb9afad82a90c8..8af13ba60c7e45 100644
--- a/include/linux/suspend.h
+++ b/include/linux/suspend.h
@@ -473,9 +473,9 @@ static inline int hibernate_quiet_exec(int (*func)(void *data), void *data) {
 #endif /* CONFIG_HIBERNATION */
 
 #ifdef CONFIG_HIBERNATION_SNAPSHOT_DEV
-int is_hibernate_resume_dev(const struct inode *);
+int is_hibernate_resume_dev(dev_t dev);
 #else
-static inline int is_hibernate_resume_dev(const struct inode *i) { return 0; }
+static inline int is_hibernate_resume_dev(dev_t dev) { return 0; }
 #endif
 
 /* Hibernation and suspend events */
diff --git a/kernel/power/user.c b/kernel/power/user.c
index d5eedc2baa2a10..b5815685b944fe 100644
--- a/kernel/power/user.c
+++ b/kernel/power/user.c
@@ -35,12 +35,12 @@ static struct snapshot_data {
 	bool ready;
 	bool platform_support;
 	bool free_bitmaps;
-	struct inode *bd_inode;
+	dev_t dev;
 } snapshot_state;
 
-int is_hibernate_resume_dev(const struct inode *bd_inode)
+int is_hibernate_resume_dev(dev_t dev)
 {
-	return hibernation_available() && snapshot_state.bd_inode == bd_inode;
+	return hibernation_available() && snapshot_state.dev == dev;
 }
 
 static int snapshot_open(struct inode *inode, struct file *filp)
@@ -101,7 +101,7 @@ static int snapshot_open(struct inode *inode, struct file *filp)
 	data->frozen = false;
 	data->ready = false;
 	data->platform_support = false;
-	data->bd_inode = NULL;
+	data->dev = 0;
 
  Unlock:
 	unlock_system_sleep();
@@ -117,7 +117,7 @@ static int snapshot_release(struct inode *inode, struct file *filp)
 
 	swsusp_free();
 	data = filp->private_data;
-	data->bd_inode = NULL;
+	data->dev = 0;
 	free_all_swap_pages(data->swap);
 	if (data->frozen) {
 		pm_restore_gfp_mask();
@@ -245,7 +245,7 @@ static int snapshot_set_swap_area(struct snapshot_data *data,
 	if (data->swap < 0)
 		return -ENODEV;
 
-	data->bd_inode = bdev->bd_inode;
+	data->dev = bdev->bd_dev;
 	bdput(bdev);
 	return 0;
 }
-- 
2.28.0
