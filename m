From: Tao Ma <tao.ma@oracle.com>
Date: Wed, 27 Jan 2010 10:21:52 +0800
Subject: [Ocfs2-devel] [PATCH] ocfs2: Use compat_ptr in reflink_arguments.
Message-ID: <1264558912-14451-1-git-send-email-tao.ma@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Although we use u64 to pass userspace pointers to the kernel
to avoid compat_ioctl, it doesn't work in some ppc platform.
So wrap them with compat_ptr and add compat_ioctl.

The detailed discussion about compat_ptr can be found in thread
http://lkml.org/lkml/2009/10/27/423.

We indeed met with a bug when testing on ppc(-EFAULT is returned
when using old_path). This patch try to fix this.
I have tested in ppc64(with 32 bit reflink) and x86_64(with i686
reflink), both works.

Signed-off-by: Tao Ma <tao.ma@oracle.com>
---
 fs/ocfs2/ioctl.c |   14 +++++++++++++-
 1 files changed, 13 insertions(+), 1 deletions(-)

diff --git a/fs/ocfs2/ioctl.c b/fs/ocfs2/ioctl.c
index 31fbb06..7d9d9c1 100644
--- a/fs/ocfs2/ioctl.c
+++ b/fs/ocfs2/ioctl.c
@@ -7,6 +7,7 @@
 
 #include <linux/fs.h>
 #include <linux/mount.h>
+#include <linux/compat.h>
 
 #define MLOG_MASK_PREFIX ML_INODE
 #include <cluster/masklog.h>
@@ -181,6 +182,10 @@ long ocfs2_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
 #ifdef CONFIG_COMPAT
 long ocfs2_compat_ioctl(struct file *file, unsigned cmd, unsigned long arg)
 {
+	bool preserve;
+	struct reflink_arguments args;
+	struct inode *inode = file->f_path.dentry->d_inode;
+
 	switch (cmd) {
 	case OCFS2_IOC32_GETFLAGS:
 		cmd = OCFS2_IOC_GETFLAGS;
@@ -195,8 +200,15 @@ long ocfs2_compat_ioctl(struct file *file, unsigned cmd, unsigned long arg)
 	case OCFS2_IOC_GROUP_EXTEND:
 	case OCFS2_IOC_GROUP_ADD:
 	case OCFS2_IOC_GROUP_ADD64:
-	case OCFS2_IOC_REFLINK:
 		break;
+	case OCFS2_IOC_REFLINK:
+		if (copy_from_user(&args, (struct reflink_arguments *)arg,
+				   sizeof(args)))
+			return -EFAULT;
+		preserve = (args.preserve != 0);
+
+		return ocfs2_reflink_ioctl(inode, compat_ptr(args.old_path),
+					   compat_ptr(args.new_path), preserve);
 	default:
 		return -ENOIOCTLCMD;
 	}
-- 
1.5.5
