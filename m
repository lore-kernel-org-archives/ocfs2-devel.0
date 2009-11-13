From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Thu, 12 Nov 2009 17:47:26 -0800
Subject: [Ocfs2-devel] [PATCH 05/18] ocfs2: Handle missing fmode_t in
	blkdev_put()
In-Reply-To: <1258076859-13538-1-git-send-email-sunil.mushran@oracle.com>
References: <1258076859-13538-1-git-send-email-sunil.mushran@oracle.com>
Message-ID: <1258076859-13538-6-git-send-email-sunil.mushran@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Mainline commit 9a1c3542768b5a58e45a9216921cd10a3bae1205 added arg fmode_t
to blkdev_put(). Patch allows building against EL5 by ignoring that argument.

Signed-off-by: Sunil Mushran <sunil.mushran@oracle.com>
---
 Makefile                         |    3 ++-
 configure.in                     |    5 +++++
 fs/ocfs2/cluster/heartbeat.c     |    4 ++--
 fs/ocfs2/cluster/kapi-default.h  |    4 ++++
 kapi-compat/include/blkdev_put.h |    6 ++++++
 5 files changed, 19 insertions(+), 3 deletions(-)
 create mode 100644 kapi-compat/include/blkdev_put.h

diff --git a/Makefile b/Makefile
index 912fb70..a94d345 100644
--- a/Makefile
+++ b/Makefile
@@ -24,7 +24,8 @@ KAPI_COMPAT_FILES = \
 	kapi-compat/include/umh_wait.h			\
 	kapi-compat/include/register_sysctl.h		\
 	kapi-compat/include/sysctl.h			\
-	kapi-compat/include/slab.h
+	kapi-compat/include/slab.h			\
+	kapi-compat/include/blkdev_put.h
 
 PATCH_FILES =
 
diff --git a/configure.in b/configure.in
index 8696935..6c93e2f 100644
--- a/configure.in
+++ b/configure.in
@@ -339,6 +339,11 @@ OCFS2_CHECK_KERNEL([	older prototype of bio_end_io_t in bio.h], bio.h,
   OLD_BIO_END_IO_T=yes, , [^typedef int (bio_end_io_t) (struct bio \*, unsigned int, int);])
 AC_SUBST(OLD_BIO_END_IO_T)
 
+blkdev_put_header=
+OCFS2_CHECK_KERNEL([	older prototype of blkdev_put() in fs.h], fs.h,
+  blkdev_put_header=blkdev_put.h, , [^extern int blkdev_put(struct block_device \*);])
+KAPI_COMPAT_HEADERS="$KAPI_COMPAT_HEADERS $blkdev_put_header"
+
 # End kapi_compat checks
 
 # using -include has two advantages:
diff --git a/fs/ocfs2/cluster/heartbeat.c b/fs/ocfs2/cluster/heartbeat.c
index d07241f..ed05786 100644
--- a/fs/ocfs2/cluster/heartbeat.c
+++ b/fs/ocfs2/cluster/heartbeat.c
@@ -1076,7 +1076,7 @@ static void o2hb_region_release(struct config_item *item)
 	}
 
 	if (reg->hr_bdev)
-		blkdev_put(reg->hr_bdev, FMODE_READ|FMODE_WRITE);
+		kapi_blkdev_put(reg->hr_bdev, FMODE_READ|FMODE_WRITE);
 
 	if (reg->hr_slots)
 		kfree(reg->hr_slots);
@@ -1459,7 +1459,7 @@ out:
 		iput(inode);
 	if (ret < 0) {
 		if (reg->hr_bdev) {
-			blkdev_put(reg->hr_bdev, FMODE_READ|FMODE_WRITE);
+			kapi_blkdev_put(reg->hr_bdev, FMODE_READ|FMODE_WRITE);
 			reg->hr_bdev = NULL;
 		}
 	}
diff --git a/fs/ocfs2/cluster/kapi-default.h b/fs/ocfs2/cluster/kapi-default.h
index 21e5e3a..ded908a 100644
--- a/fs/ocfs2/cluster/kapi-default.h
+++ b/fs/ocfs2/cluster/kapi-default.h
@@ -29,4 +29,8 @@ typedef struct work_struct kapi_work_struct_t;
 # define KAPI_INIT_DELAYED_WORK(a, b, c)	INIT_DELAYED_WORK(a, b)
 #endif
 
+#ifndef kapi_blkdev_put
+# define kapi_blkdev_put		blkdev_put
+#endif
+
 #endif
diff --git a/kapi-compat/include/blkdev_put.h b/kapi-compat/include/blkdev_put.h
new file mode 100644
index 0000000..cf30192
--- /dev/null
+++ b/kapi-compat/include/blkdev_put.h
@@ -0,0 +1,6 @@
+#ifndef KAPI_BLKDEV_PUT_H
+#define KAPI_BLKDEV_PUT_H
+
+#define kapi_blkdev_put(a, b)	blkdev_put(a)
+
+#endif
-- 
1.5.6.5
