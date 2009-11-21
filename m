From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Fri, 20 Nov 2009 17:12:51 -0800
Subject: [Ocfs2-devel] [PATCH 04/10] ocfs2: Handle missing
	bdev_logical_block_size()
In-Reply-To: <1258765977-4334-1-git-send-email-sunil.mushran@oracle.com>
References: <1258765977-4334-1-git-send-email-sunil.mushran@oracle.com>
Message-ID: <1258765977-4334-5-git-send-email-sunil.mushran@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Mainline commit e1defc4ff0cf57aca6c5e3ff99fa503f5943c1f1 does away with the
notion of hardsect_size and replaces it with physical and logical block sizes.

This patch adds a macro to plumb the new bdev_logical_block_size() to the old
bdev_hardsect_size() when building on EL5.

Signed-off-by: Sunil Mushran <sunil.mushran@oracle.com>
---
 Makefile                       |    3 ++-
 configure.in                   |    5 +++++
 kapi-compat/include/hardsect.h |    6 ++++++
 3 files changed, 13 insertions(+), 1 deletions(-)
 create mode 100644 kapi-compat/include/hardsect.h

diff --git a/Makefile b/Makefile
index a642c13..8e8b63f 100644
--- a/Makefile
+++ b/Makefile
@@ -36,7 +36,8 @@ KAPI_COMPAT_FILES = \
 	kapi-compat/include/should_remove_suid.h	\
 	kapi-compat/include/user_path_at.h		\
 	kapi-compat/include/filemap_fdatawait_range.h	\
-	kapi-compat/include/mnt_want_write.h
+	kapi-compat/include/mnt_want_write.h		\
+	kapi-compat/include/hardsect.h
 
 PATCH_FILES =
 
diff --git a/configure.in b/configure.in
index c9ddf88..2826cec 100644
--- a/configure.in
+++ b/configure.in
@@ -424,6 +424,11 @@ OCFS2_CHECK_KERNEL([mnt_want_write.h() and mnt_drop_write() in mount.h], mount.h
  , mnt_want_write=mnt_want_write.h, [^extern int mnt_want_write(])
 KAPI_COMPAT_HEADERS="$KAPI_COMPAT_HEADERS $mnt_want_write"
 
+bdev_hardsect_header=
+OCFS2_CHECK_KERNEL([	bdev_hardsect_size() in blkdev.h], blkdev.h,
+ bdev_hardsect_header=hardsect.h, , [static inline int bdev_hardsect_size(struct block_device \*bdev)])
+KAPI_COMPAT_HEADERS="$KAPI_COMPAT_HEADERS $bdev_hardsect_header"
+
 # End kapi_compat checks
 
 # using -include has two advantages:
diff --git a/kapi-compat/include/hardsect.h b/kapi-compat/include/hardsect.h
new file mode 100644
index 0000000..7c59c00
--- /dev/null
+++ b/kapi-compat/include/hardsect.h
@@ -0,0 +1,6 @@
+#ifndef KAPI_HARDSECT_H
+#define KAPI_HARDSECT_H
+
+#define bdev_logical_block_size(a)	bdev_hardsect_size(a)
+
+#endif
-- 
1.5.6.5
