From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Thu, 12 Nov 2009 17:47:27 -0800
Subject: [Ocfs2-devel] [PATCH 06/18] ocfs2: Handle older prototype of
	blkdev_get()
In-Reply-To: <1258076859-13538-1-git-send-email-sunil.mushran@oracle.com>
References: <1258076859-13538-1-git-send-email-sunil.mushran@oracle.com>
Message-ID: <1258076859-13538-7-git-send-email-sunil.mushran@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Mainline commit 572c48921574dbe6dceb958cf965aa962baefde4 removed the flags
argument in blkdev_get(). Patch allows building against EL5 by forcing a 0
in place of that argument. This is ok as we are not using that argument.

Signed-off-by: Sunil Mushran <sunil.mushran@oracle.com>
---
 Makefile                         |    3 ++-
 configure.in                     |    5 +++++
 fs/ocfs2/cluster/heartbeat.c     |    2 +-
 fs/ocfs2/cluster/kapi-default.h  |    4 ++++
 kapi-compat/include/blkdev_get.h |    6 ++++++
 5 files changed, 18 insertions(+), 2 deletions(-)
 create mode 100644 kapi-compat/include/blkdev_get.h

diff --git a/Makefile b/Makefile
index a94d345..5e1bb62 100644
--- a/Makefile
+++ b/Makefile
@@ -25,7 +25,8 @@ KAPI_COMPAT_FILES = \
 	kapi-compat/include/register_sysctl.h		\
 	kapi-compat/include/sysctl.h			\
 	kapi-compat/include/slab.h			\
-	kapi-compat/include/blkdev_put.h
+	kapi-compat/include/blkdev_put.h		\
+	kapi-compat/include/blkdev_get.h
 
 PATCH_FILES =
 
diff --git a/configure.in b/configure.in
index 6c93e2f..8ce5e67 100644
--- a/configure.in
+++ b/configure.in
@@ -344,6 +344,11 @@ OCFS2_CHECK_KERNEL([	older prototype of blkdev_put() in fs.h], fs.h,
   blkdev_put_header=blkdev_put.h, , [^extern int blkdev_put(struct block_device \*);])
 KAPI_COMPAT_HEADERS="$KAPI_COMPAT_HEADERS $blkdev_put_header"
 
+blkdev_get_header=
+OCFS2_CHECK_KERNEL([	older prototype of blkdev_get() in fs.h], fs.h,
+  blkdev_get_header=blkdev_get.h, , [^extern int blkdev_get(struct block_device \*, mode_t, unsigned);])
+KAPI_COMPAT_HEADERS="$KAPI_COMPAT_HEADERS $blkdev_get_header"
+
 # End kapi_compat checks
 
 # using -include has two advantages:
diff --git a/fs/ocfs2/cluster/heartbeat.c b/fs/ocfs2/cluster/heartbeat.c
index ed05786..3d3e306 100644
--- a/fs/ocfs2/cluster/heartbeat.c
+++ b/fs/ocfs2/cluster/heartbeat.c
@@ -1368,7 +1368,7 @@ static ssize_t o2hb_region_dev_write(struct o2hb_region *reg,
 		goto out;
 
 	reg->hr_bdev = I_BDEV(filp->f_mapping->host);
-	ret = blkdev_get(reg->hr_bdev, FMODE_WRITE | FMODE_READ);
+	ret = kapi_blkdev_get(reg->hr_bdev, FMODE_WRITE | FMODE_READ);
 	if (ret) {
 		reg->hr_bdev = NULL;
 		goto out;
diff --git a/fs/ocfs2/cluster/kapi-default.h b/fs/ocfs2/cluster/kapi-default.h
index ded908a..fc3da05 100644
--- a/fs/ocfs2/cluster/kapi-default.h
+++ b/fs/ocfs2/cluster/kapi-default.h
@@ -33,4 +33,8 @@ typedef struct work_struct kapi_work_struct_t;
 # define kapi_blkdev_put		blkdev_put
 #endif
 
+#ifndef kapi_blkdev_get
+# define kapi_blkdev_get		blkdev_get
+#endif
+
 #endif
diff --git a/kapi-compat/include/blkdev_get.h b/kapi-compat/include/blkdev_get.h
new file mode 100644
index 0000000..dcf7425
--- /dev/null
+++ b/kapi-compat/include/blkdev_get.h
@@ -0,0 +1,6 @@
+#ifndef KAPI_BLKDEV_GET_H
+#define KAPI_BLKDEV_GET_H
+
+#define kapi_blkdev_get(a, b)	blkdev_get(a, b, 0)
+
+#endif
-- 
1.5.6.5
