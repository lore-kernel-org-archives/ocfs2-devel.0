From: Christoph Hellwig <hch@lst.de>
Date: Fri Aug 13 16:59:08 2004
Subject: [Ocfs2-devel] [PATCH] kill compat clutter for statfs
Message-ID: <20040813215903.GA15397@lst.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com


Index: src/super.c
===================================================================
--- src/super.c	(revision 1355)
+++ src/super.c	(working copy)
@@ -170,11 +170,11 @@
 static void ocfs_free_mem_lists (void);
 static void ocfs_delete_osb (ocfs_super * osb);
 
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,0)
 static int ocfs_statfs (struct super_block *sb, struct kstatfs *buf);
+
+#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,0)
 static int ocfs_sync_fs(struct super_block *sb, int wait);
 #else
-static int ocfs_statfs (struct super_block *sb, struct statfs *buf);
 static int ocfs_sync_fs(struct super_block *sb);
 #endif
 
@@ -725,11 +725,7 @@
  * ocfs_statfs()
  *
  */
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,0)
 static int ocfs_statfs(struct super_block *sb, struct kstatfs *buf)
-#else
-static int ocfs_statfs(struct super_block *sb, struct statfs *buf)
-#endif
 {
 	ocfs_super *osb;
 	__u32 numbits, freebits;
@@ -780,27 +776,15 @@
 	buf->f_bsize = sb->s_blocksize;
 	buf->f_namelen = OCFS2_MAX_FILENAME_LENGTH;
 	buf->f_bavail = buf->f_bfree;
-#if LINUX_VERSION_CODE < KERNEL_VERSION(2,6,0)
-	buf->f_blocks =
-		(unsigned long) ((unsigned long) (numbits) *
-				 (unsigned long) (osb->s_clustersize >> osb->sb->s_blocksize_bits) -
-				 reserved_bits);
-	buf->f_bfree =
-	    (unsigned long) (freebits * (osb->s_clustersize >> osb->sb->s_blocksize_bits));
+	buf->f_blocks = (sector_t) ((unsigned long) (numbits) *
+			(unsigned long) (osb->s_clustersize >>
+					 osb->sb->s_blocksize_bits) -
+				reserved_bits);
+	buf->f_bfree = (sector_t) (freebits *
+			(osb->s_clustersize >> osb->sb->s_blocksize_bits));
 	buf->f_bavail = buf->f_bfree;
-	buf->f_files = (unsigned long) (numbits);
-	buf->f_ffree = (unsigned long) (numbits) - freebits;
-#else
-	buf->f_blocks =
-		(sector_t) ((unsigned long) (numbits) *
-			    (unsigned long) (osb->s_clustersize >> osb->sb->s_blocksize_bits) -
-			    reserved_bits);
-	buf->f_bfree =
-	    (sector_t) (freebits * (osb->s_clustersize >> osb->sb->s_blocksize_bits));
-	buf->f_bavail = buf->f_bfree;
 	buf->f_files = (sector_t) (numbits);
 	buf->f_ffree = (sector_t) (numbits) - freebits;
-#endif
 
 	brelse(bh);
 
Index: src/ocfs_compat.h
===================================================================
--- src/ocfs_compat.h	(revision 1355)
+++ src/ocfs_compat.h	(working copy)
@@ -153,6 +153,8 @@
 	return (u64)((MAJOR(dev) << 8) | MINOR(dev));
 }
 
+#define kstatfs statfs
+
 #else /* LINUX_VERSION_CODE < 2.6 */
 
 #define OCFS_GENERIC_SB_MEMBER(sb)  ((sb)->s_fs_info)
