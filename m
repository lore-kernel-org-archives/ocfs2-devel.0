From: Jeff Liu <jeff.liu@oracle.com>
Date: Sun, 08 Dec 2013 19:34:56 +0800
Subject: [Ocfs2-devel] [PATCH 1/3] ocfs2: Return EOPNOTSUPP if the device
 does not support discard
Message-ID: <52A45960.2050504@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

From: Jie Liu <jeff.liu@oracle.com>

For FITRIM ioctl(2), we should return EOPNOTSUPP to inform the user
that the storage device does not support discard if it is, otherwise
return success would confuse the user even though there is no free
blocks were trimmed at all.

Signed-off-by: Jie Liu <jeff.liu@oracle.com>
---
 fs/ocfs2/ioctl.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/fs/ocfs2/ioctl.c b/fs/ocfs2/ioctl.c
index fa32ce9..4de6a2a 100644
--- a/fs/ocfs2/ioctl.c
+++ b/fs/ocfs2/ioctl.c
@@ -7,6 +7,7 @@

 #include <linux/fs.h>
 #include <linux/mount.h>
+#include <linux/blkdev.h>
 #include <linux/compat.h>

 #include <cluster/masklog.h>
@@ -966,12 +967,16 @@ long ocfs2_ioctl(struct file *filp, unsigned int
cmd, unsigned long arg)
 	case FITRIM:
 	{
 		struct super_block *sb = inode->i_sb;
+		struct request_queue *q = bdev_get_queue(sb->s_bdev);
 		struct fstrim_range range;
 		int ret = 0;

 		if (!capable(CAP_SYS_ADMIN))
 			return -EPERM;

+		if (!blk_queue_discard(q))
+			return -EOPNOTSUPP;
+
 		if (copy_from_user(&range, argp, sizeof(range)))
 			return -EFAULT;

-- 
1.8.3.2
