From: Jie Liu <jeff.liu@oracle.com>
Date: Mon, 20 Sep 2010 15:11:52 +0800
Subject: [Ocfs2-devel] [PATCH 2/3] build: distribute new file, fiemap.h v4
In-Reply-To: <>
References: <>
Message-ID: <1284966712-24926-1-git-send-email-jeff.liu@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Add fiemap header to src.

* src/Makefile.am (noinst_HEADERS): Add fiemap.h.

Signed-off-by: Jie Liu <jeff.liu@oracle.com>
---
 coreutils-6.9/src/Makefile.am |    3 +-
 coreutils-6.9/src/fiemap.h    |  102 +++++++++++++++++++++++++++++++++++++++++
 2 files changed, 104 insertions(+), 1 deletions(-)
 create mode 100644 coreutils-6.9/src/fiemap.h

diff --git a/coreutils-6.9/src/Makefile.am b/coreutils-6.9/src/Makefile.am
index 863a32b..af132e1 100644
--- a/coreutils-6.9/src/Makefile.am
+++ b/coreutils-6.9/src/Makefile.am
@@ -43,7 +43,8 @@ noinst_HEADERS = \
   remove.h \
   system.h \
   wheel-size.h \
-  wheel.h
+  wheel.h \
+  fiemap.h
 
 EXTRA_DIST = dcgen dircolors.hin tac-pipe.c \
   groups.sh wheel-gen.pl extract-magic c99-to-c89.diff
diff --git a/coreutils-6.9/src/fiemap.h b/coreutils-6.9/src/fiemap.h
new file mode 100644
index 0000000..c5d8424
--- /dev/null
+++ b/coreutils-6.9/src/fiemap.h
@@ -0,0 +1,102 @@
+/* FS_IOC_FIEMAP ioctl infrastructure.
+   Some portions copyright (C) 2007 Cluster File Systems, Inc
+   Authors: Mark Fasheh <mfasheh@suse.com>
+            Kalpak Shah <kalpak.shah@sun.com>
+            Andreas Dilger <adilger@sun.com>.  */
+
+/* Copy from kernel, modified to respect GNU code style by Jie Liu.  */
+
+#ifndef _LINUX_FIEMAP_H
+# define _LINUX_FIEMAP_H
+
+# include <stdint.h>
+
+struct fiemap_extent
+{
+  /* Logical offset in bytes for the start of the extent
+     from the beginning of the file.  */
+  uint64_t fe_logical;
+
+  /* Physical offset in bytes for the start of the extent
+     from the beginning of the disk.  */
+  uint64_t fe_physical;
+
+  /* Length in bytes for this extent.  */
+  uint64_t fe_length;
+
+  uint64_t fe_reserved64[2];
+
+  /* FIEMAP_EXTENT_* flags for this extent.  */
+  uint32_t fe_flags;
+
+  uint32_t fe_reserved[3];
+};
+
+struct fiemap
+{
+  /* Logical offset(inclusive) at which to start mapping(in).  */
+  uint64_t fm_start;
+
+  /* Logical length of mapping which userspace wants(in).  */
+  uint64_t fm_length;
+
+  /* FIEMAP_FLAG_* flags for request(in/out).  */
+  uint32_t fm_flags;
+
+  /* Number of extents that were mapped(out).  */
+  uint32_t fm_mapped_extents;
+
+  /* Size of fm_extents array(in).  */
+  uint32_t fm_extent_count;
+
+  uint32_t fm_reserved;
+
+  /* Array of mapped extents(out).  */
+  struct fiemap_extent fm_extents[0];
+};
+
+/* The maximum offset can be mapped for a file.  */
+# define FIEMAP_MAX_OFFSET       (~0ULL)
+
+/* Sync file data before map.  */
+# define FIEMAP_FLAG_SYNC        0x00000001
+
+/* Map extented attribute tree.  */
+# define FIEMAP_FLAG_XATTR       0x00000002
+
+# define FIEMAP_FLAGS_COMPAT     (FIEMAP_FLAG_SYNC | FIEMAP_FLAG_XATTR)
+
+/* Last extent in file.  */
+# define FIEMAP_EXTENT_LAST              0x00000001
+
+/* Data location unknown.  */
+# define FIEMAP_EXTENT_UNKNOWN           0x00000002
+
+/* Location still pending, Sets EXTENT_UNKNOWN.  */
+# define FIEMAP_EXTENT_DELALLOC          0x00000004
+
+/* Data can not be read while fs is unmounted.  */
+# define FIEMAP_EXTENT_ENCODED           0x00000008
+
+/* Data is encrypted by fs.  Sets EXTENT_NO_BYPASS.  */
+# define FIEMAP_EXTENT_DATA_ENCRYPTED    0x00000080
+
+/* Extent offsets may not be block aligned.  */
+# define FIEMAP_EXTENT_NOT_ALIGNED       0x00000100
+
+/* Data mixed with metadata.  Sets EXTENT_NOT_ALIGNED.  */
+# define FIEMAP_EXTENT_DATA_INLINE       0x00000200
+
+/* Multiple files in block.  Set EXTENT_NOT_ALIGNED.  */
+# define FIEMAP_EXTENT_DATA_TAIL         0x00000400
+
+/* Space allocated, but not data (i.e. zero).  */
+# define FIEMAP_EXTENT_UNWRITTEN         0x00000800
+
+/* File does not natively support extents.  Result merged for efficiency.  */
+# define FIEMAP_EXTENT_MERGED		0x00001000
+
+/* Space shared with other files.  */
+# define FIEMAP_EXTENT_SHARED            0x00002000
+
+#endif
-- 
1.5.4.3
