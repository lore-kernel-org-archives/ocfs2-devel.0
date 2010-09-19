From: Tao Ma <tao.ma@oracle.com>
Date: Sun, 19 Sep 2010 13:42:29 +0800
Subject: [Ocfs2-devel] [PATCH] ocfs2: Sync inode flags with ext2.
In-Reply-To: <1284874949-3352-1-git-send-email-tao.ma@oracle.com>
References: <1284874949-3352-1-git-send-email-tao.ma@oracle.com>
Message-ID: <1284874949-3352-2-git-send-email-tao.ma@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

We sync our inode flags with ext2 and define them by hex
values. But actually in commit 3669567(4 years ago), all
these values are moved to include/linux/fs.h. So we'd
better also use them as what ext2 did. So sync our inode
flags with ext2 by using FS_*.

Signed-off-by: Tao Ma <tao.ma@oracle.com>
---
 fs/ocfs2/ocfs2_fs.h    |   37 +++++++++++++++++++++++++------------
 fs/ocfs2/ocfs2_ioctl.h |    8 ++++----
 2 files changed, 29 insertions(+), 16 deletions(-)

diff --git a/fs/ocfs2/ocfs2_fs.h b/fs/ocfs2/ocfs2_fs.h
index 33f1c9a..fa31d05 100644
--- a/fs/ocfs2/ocfs2_fs.h
+++ b/fs/ocfs2/ocfs2_fs.h
@@ -235,18 +235,31 @@
 #define OCFS2_HAS_REFCOUNT_FL   (0x0010)
 
 /* Inode attributes, keep in sync with EXT2 */
-#define OCFS2_SECRM_FL		(0x00000001)	/* Secure deletion */
-#define OCFS2_UNRM_FL		(0x00000002)	/* Undelete */
-#define OCFS2_COMPR_FL		(0x00000004)	/* Compress file */
-#define OCFS2_SYNC_FL		(0x00000008)	/* Synchronous updates */
-#define OCFS2_IMMUTABLE_FL	(0x00000010)	/* Immutable file */
-#define OCFS2_APPEND_FL		(0x00000020)	/* writes to file may only append */
-#define OCFS2_NODUMP_FL		(0x00000040)	/* do not dump file */
-#define OCFS2_NOATIME_FL	(0x00000080)	/* do not update atime */
-#define OCFS2_DIRSYNC_FL	(0x00010000)	/* dirsync behaviour (directories only) */
-
-#define OCFS2_FL_VISIBLE	(0x000100FF)	/* User visible flags */
-#define OCFS2_FL_MODIFIABLE	(0x000100FF)	/* User modifiable flags */
+#define OCFS2_SECRM_FL			FS_SECRM_FL	/* Secure deletion */
+#define OCFS2_UNRM_FL			FS_UNRM_FL	/* Undelete */
+#define OCFS2_COMPR_FL			FS_COMPR_FL	/* Compress file */
+#define OCFS2_SYNC_FL			FS_SYNC_FL	/* Synchronous updates */
+#define OCFS2_IMMUTABLE_FL		FS_IMMUTABLE_FL	/* Immutable file */
+#define OCFS2_APPEND_FL			FS_APPEND_FL	/* writes to file may only append */
+#define OCFS2_NODUMP_FL			FS_NODUMP_FL	/* do not dump file */
+#define OCFS2_NOATIME_FL		FS_NOATIME_FL	/* do not update atime */
+/* Reserved for compression usage... */
+#define OCFS2_DIRTY_FL			FS_DIRTY_FL
+#define OCFS2_COMPRBLK_FL		FS_COMPRBLK_FL	/* One or more compressed clusters */
+#define OCFS2_NOCOMP_FL			FS_NOCOMP_FL	/* Don't compress */
+#define OCFS2_ECOMPR_FL			FS_ECOMPR_FL	/* Compression error */
+/* End compression flags --- maybe not all used */
+#define OCFS2_BTREE_FL			FS_BTREE_FL	/* btree format dir */
+#define OCFS2_INDEX_FL			FS_INDEX_FL	/* hash-indexed directory */
+#define OCFS2_IMAGIC_FL			FS_IMAGIC_FL	/* AFS directory */
+#define OCFS2_JOURNAL_DATA_FL		FS_JOURNAL_DATA_FL /* Reserved for ext3 */
+#define OCFS2_NOTAIL_FL			FS_NOTAIL_FL	/* file tail should not be merged */
+#define OCFS2_DIRSYNC_FL		FS_DIRSYNC_FL	/* dirsync behaviour (directories only) */
+#define OCFS2_TOPDIR_FL			FS_TOPDIR_FL	/* Top of directory hierarchies*/
+#define OCFS2_RESERVED_FL		FS_RESERVED_FL	/* reserved for ext2 lib */
+
+#define OCFS2_FL_VISIBLE		FS_FL_USER_VISIBLE	/* User visible flags */
+#define OCFS2_FL_MODIFIABLE		FS_FL_USER_MODIFIABLE	/* User modifiable flags */
 
 /*
  * Extent record flags (e_node.leaf.flags)
diff --git a/fs/ocfs2/ocfs2_ioctl.h b/fs/ocfs2/ocfs2_ioctl.h
index 2d3420a..5d24150 100644
--- a/fs/ocfs2/ocfs2_ioctl.h
+++ b/fs/ocfs2/ocfs2_ioctl.h
@@ -23,10 +23,10 @@
 /*
  * ioctl commands
  */
-#define OCFS2_IOC_GETFLAGS	_IOR('f', 1, long)
-#define OCFS2_IOC_SETFLAGS	_IOW('f', 2, long)
-#define OCFS2_IOC32_GETFLAGS	_IOR('f', 1, int)
-#define OCFS2_IOC32_SETFLAGS	_IOW('f', 2, int)
+#define OCFS2_IOC_GETFLAGS	FS_IOC_GETFLAGS
+#define OCFS2_IOC_SETFLAGS	FS_IOC_SETFLAGS
+#define OCFS2_IOC32_GETFLAGS	FS_IOC32_GETFLAGS
+#define OCFS2_IOC32_SETFLAGS	FS_IOC32_SETFLAGS
 
 /*
  * Space reservation / allocation / free ioctls and argument structure
-- 
1.7.1.GIT
