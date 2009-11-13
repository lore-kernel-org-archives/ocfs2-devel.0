From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Thu, 12 Nov 2009 17:47:38 -0800
Subject: [Ocfs2-devel] [PATCH 17/18] ocfs2: Handle missing
	filemap_fdatawait_range()
In-Reply-To: <1258076859-13538-1-git-send-email-sunil.mushran@oracle.com>
References: <1258076859-13538-1-git-send-email-sunil.mushran@oracle.com>
Message-ID: <1258076859-13538-18-git-send-email-sunil.mushran@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Mainline commit 918941a3f3d46c2a69971b4718aaf13b1be2f1a7 replaced
generic_file_aio_write_nolock() with __generic_file_aio_write()
and made use of helpers filemap_fdatawrite_range() and filemap_fdatawait_range().

Patch adds macros to allow building with current and older EL5 kernels.

Signed-off-by: Sunil Mushran <sunil.mushran@oracle.com>
---
 Makefile                                      |    3 ++-
 configure.in                                  |    5 +++++
 fs/ocfs2/file.c                               |    6 +++---
 fs/ocfs2/kapi-default.h                       |    6 ++++++
 kapi-compat/include/filemap_fdatawait_range.h |    8 ++++++++
 5 files changed, 24 insertions(+), 4 deletions(-)
 create mode 100644 kapi-compat/include/filemap_fdatawait_range.h

diff --git a/Makefile b/Makefile
index 3447409..7d9e0a9 100644
--- a/Makefile
+++ b/Makefile
@@ -34,7 +34,8 @@ KAPI_COMPAT_FILES = \
 	kapi-compat/include/bdi_define.h		\
 	kapi-compat/include/inode_permission.h		\
 	kapi-compat/include/should_remove_suid.h	\
-	kapi-compat/include/user_path_at.h
+	kapi-compat/include/user_path_at.h		\
+	kapi-compat/include/filemap_fdatawait_range.h
 
 PATCH_FILES =
 
diff --git a/configure.in b/configure.in
index 86dc11b..a992f4b 100644
--- a/configure.in
+++ b/configure.in
@@ -404,6 +404,11 @@ OCFS2_CHECK_KERNEL([struct path in struct nameidata in namei.h], namei.h,
  , user_path_header=user_path_at.h, [struct path.*path;])
 KAPI_COMPAT_HEADERS="$KAPI_COMPAT_HEADERS $user_path_header"
 
+fdatawait_header=
+OCFS2_CHECK_KERNEL([filemap_fdatawait_range() in fs.h], fs.h,
+ , fdatawait_header=filemap_fdatawait_range.h, [extern int filemap_fdatawait_range(struct address_space \*,])
+KAPI_COMPAT_HEADERS="$KAPI_COMPAT_HEADERS $fdatawait_header"
+
 # End kapi_compat checks
 
 # using -include has two advantages:
diff --git a/fs/ocfs2/file.c b/fs/ocfs2/file.c
index 4c12c2d..1367586 100644
--- a/fs/ocfs2/file.c
+++ b/fs/ocfs2/file.c
@@ -2002,7 +2002,7 @@ relock:
 			goto out_dio;
 		}
 	} else {
-		written = __generic_file_aio_write(iocb, iov, nr_segs, ppos);
+		written = kapi_generic_file_aio_write(iocb, iov, nr_segs, ppos);
 	}
 
 out_dio:
@@ -2010,7 +2010,7 @@ out_dio:
 	BUG_ON(ret == -EIOCBQUEUED && !(file->f_flags & O_DIRECT));
 
 	if ((file->f_flags & O_SYNC && !direct_io) || IS_SYNC(inode)) {
-		ret = filemap_fdatawrite_range(file->f_mapping, pos,
+		ret = kapi_filemap_fdatawrite_range(file->f_mapping, pos,
 					       pos + count - 1);
 		if (ret < 0)
 			written = ret;
@@ -2023,7 +2023,7 @@ out_dio:
 		}
 
 		if (!ret)
-			ret = filemap_fdatawait_range(file->f_mapping, pos,
+			ret = kapi_filemap_fdatawait_range(file->f_mapping, pos,
 						      pos + count - 1);
 	}
 
diff --git a/fs/ocfs2/kapi-default.h b/fs/ocfs2/kapi-default.h
index 7b16678..b1afdcf 100644
--- a/fs/ocfs2/kapi-default.h
+++ b/fs/ocfs2/kapi-default.h
@@ -63,4 +63,10 @@ typedef u64 f_version_t;
 # define kapi_to_path_ptr(a)		(&(a).path)
 #endif
 
+#ifndef kapi_generic_file_aio_write
+# define kapi_generic_file_aio_write		__generic_file_aio_write
+# define kapi_filemap_fdatawrite_range		filemap_fdatawrite_range
+# define kapi_filemap_fdatawait_range		filemap_fdatawait_range
+#endif
+
 #endif
diff --git a/kapi-compat/include/filemap_fdatawait_range.h b/kapi-compat/include/filemap_fdatawait_range.h
new file mode 100644
index 0000000..47840af
--- /dev/null
+++ b/kapi-compat/include/filemap_fdatawait_range.h
@@ -0,0 +1,8 @@
+#ifndef FILEMAP_FDATAWAIT_RANGE_H
+#define FILEMAP_FDATAWAIT_RANGE_H
+
+#define kapi_generic_file_aio_write		generic_file_aio_write_nolock
+#define kapi_filemap_fdatawrite_range(a, b, c)	0
+#define kapi_filemap_fdatawait_range(a, b, c)	0
+
+#endif
-- 
1.5.6.5
