From: Christoph Hellwig <hch@lst.de>
Date: Sun Jun 20 09:29:17 2004
Subject: [Ocfs2-devel] [PATCH] provide 2.4 version of sb_set_blocksize
Message-ID: <20040620142913.GA15961@lst.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

IIRC I added sb_set_blocksize to later 2.4, you might need to
conditionalize the helper depending on whether you want to support
latest 2.4 mainline, too.


Index: src/super.c
===================================================================
--- src/super.c	(revision 1156)
+++ src/super.c	(working copy)
@@ -208,28 +208,6 @@
 
 };
 
-static inline int ocfs_set_blocksize(struct super_block *sb,
-				     int blksize, int blksize_bits)
-{
-	int status = 0;
-
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,0)
-	if (!sb_set_blocksize(sb, blksize))
-		status = -EIO;
-#else
-	/* TODO: fix this */
-	sb->s_blocksize = blksize;
-	sb->s_blocksize_bits = blksize_bits;
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,4,18)
-	status = set_blocksize (sb->s_dev, blksize);
-#else
-	set_blocksize (sb->s_dev, blksize);
-#endif /* < 2.4.18 */
-#endif /* < 2.6.0 */
-
-	return status;
-}
-
 /*
  * ocfs_init_global_system_inodes()
  */
@@ -906,21 +884,9 @@
 
 static int ocfs2_get_sector(struct super_block *sb, struct buffer_head **bh, int block, int sect_size)
 {
-	int i, bits=0, status = 0;
-
-	for (i=32; i>=0; i--) {
-		if ((1 << i) == sect_size)
-			bits = i;
-	}
-	if (!bits) {
-		LOG_ERROR_STR("unable to get blocksize bits");
-		return -EINVAL;
-	}
-	
-	status = ocfs_set_blocksize(sb, sect_size, bits);
-	if (status < 0) {
+	if (!sb_set_blocksize(sb, sect_size)) {
 		LOG_ERROR_STR("unable to set blocksize");
-		return status;
+		return -EIO;
 	}
 
 	*bh = sb_getblk(sb, block);
Index: src/ocfs_compat.h
===================================================================
--- src/ocfs_compat.h	(revision 1156)
+++ src/ocfs_compat.h	(working copy)
@@ -77,6 +77,23 @@
 }
 #endif
 
+static inline int sb_set_blocksize(struct super_block *sb, int blksize)
+{
+	int bits;
+
+#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,4,18)
+	if (set_blocksize(sb->s_dev, blksize))
+		return 0;
+#else
+	set_blocksize(sb->s_dev, blksize);
+#endif
+	sb->s_blocksize = blksize;
+	for (bits = 9, size >>= 9; size >>= 1; bits++)
+		;
+	sb->s_blocksize_bits = bits;
+	return sb->s_blocksize;
+}
+
 typedef long sector_t;
 
 #define map_bh(bh, sb, blk) \
