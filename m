From: Christoph Hellwig <hch@lst.de>
Date: Fri Sep  3 04:12:33 2004
Subject: [Ocfs2-devel] [PATCH] remove pre-2.4.21 compat code
Message-ID: <20040903091228.GC32029@lst.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com


Index: src/ocfs_compat.h
===================================================================
--- src/ocfs_compat.h	(revision 1418)
+++ src/ocfs_compat.h	(working copy)
@@ -63,38 +63,6 @@
 #define generic_file_write_nolock do_generic_file_write
 #endif
 
-#if LINUX_VERSION_CODE < KERNEL_VERSION(2,4,18)
-#define unlock_page(p)         UnlockPage(p)
-
-static inline struct buffer_head * sb_getblk(struct super_block *sb, int block)
-{
-	return getblk(sb->s_dev, block, sb->s_blocksize);
-}
-
-/* Assumes that blocksize is > 256 */
-static inline unsigned int blksize_bits(unsigned int size)
-{
-	unsigned int bits = 8;
-	do {
-		bits++;
-		size >>= 1;
-	} while (size > 256);
-	return bits;
-}
-
-static inline int sb_set_blocksize(struct super_block *sb, int size)
-{
-	int bits;
-
-	set_blocksize(sb->s_dev, size);
-	sb->s_blocksize = size;
-	for (bits = 9, size >>= 9; size >>= 1; bits++)
-		;
-	sb->s_blocksize_bits = bits;
-	return sb->s_blocksize;
-}
-#endif
-
 typedef long sector_t;
 
 #define map_bh(bh, sb, blk) \
@@ -120,10 +88,8 @@
 	int error;
 
 	error = fsync_inode_buffers(inode);
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,4,18)
 	if (!error)
 		error = fsync_inode_data_buffers(inode);
-#endif
 	return error;
 }
 
Index: src/aops.c
===================================================================
--- src/aops.c	(revision 1418)
+++ src/aops.c	(working copy)
@@ -609,8 +609,8 @@
 	LOG_CLEAR_CONTEXT();
 	return ret;
 }				/* ocfs_direct_IO */
+#else
 
-#elif LINUX_VERSION_CODE >= KERNEL_VERSION(2,4,10)
 /*
  * ocfs_direct_IO()
  *
@@ -618,7 +618,7 @@
  * we should never get here any more
  * so let's just BUG(), hint from sct@redhat.com
  */
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,4,20) || defined(SUSE)
+#ifdef SUSE
 static int ocfs_direct_IO (int rw, struct file *filp, struct kiobuf *iobuf, unsigned long blocknr, int blocksize)
 {
 	BUG();
@@ -631,7 +631,7 @@
 	return 0;
 }				/* ocfs_direct_IO */
 #endif
-#endif  /* version >= 2.4.10 */
+#endif
 
 
 struct address_space_operations ocfs_aops = {
@@ -649,7 +649,5 @@
 	 * For a 2.6 system, this is the way a filesystem provides
 	 * direct-io support. 
 	 */
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,4,10)
 	.direct_IO	= ocfs_direct_IO
-#endif
 };
Index: src/24io.c
===================================================================
--- src/24io.c	(revision 1418)
+++ src/24io.c	(working copy)
@@ -36,22 +36,8 @@
 
 #define OCFS_DEBUG_CONTEXT    OCFS_DEBUG_CONTEXT_INODE
 
-
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,4,18)
-# define free_kiovec_sz(nr, buf, bh)     free_kiovec(nr, buf)
-# define alloc_kiovec_sz(nr, buf, bh)    alloc_kiovec(nr, buf)
-#endif
-
-#if defined(SUSE) && LINUX_VERSION_CODE < KERNEL_VERSION(2,4,20)
-#define OCFS_KIO_BLOCKS(_iobuf)  ((_iobuf)->kio_blocks)
-#else
-#define OCFS_KIO_BLOCKS(_iobuf)  ((_iobuf)->blocks)
-#endif
-
-#if LINUX_VERSION_CODE <= KERNEL_VERSION(2,4,10)
+#ifdef SUSE
 #define KERNEL_NO_F_IOBUF 1
-#elif defined(SUSE) && LINUX_VERSION_CODE >= KERNEL_VERSION(2,4,20)
-#define KERNEL_NO_F_IOBUF 1
 #endif
 
 static int ocfs_get_block2 (struct inode *inode, long iblock, long *oblock, int len)
@@ -246,7 +232,7 @@
 			nbhs = max_sectors;
 
 #ifdef KERNEL_NO_F_IOBUF
-		err = alloc_kiovec_sz (1, &iobuf, &nbhs);
+		err = alloc_kiovec(1, &iobuf);
 		if (err)
 			goto out;
 #else
@@ -255,7 +241,7 @@
 			* A parallel read/write is using the preallocated iobuf
 			* so just run slow and allocate a new one.
 			*/
-			err = alloc_kiovec_sz (1, &iobuf, &nbhs);
+			err = alloc_kiovec(1, &iobuf);
 			if (err)
 				goto out;
 			new_iobuf = 1;
@@ -285,11 +271,11 @@
 				break;
 			/* get the blocknr depending on io size for all blocks */
 			/* since we are awlays within the extent we only need to get the first block */
-			OCFS_KIO_BLOCKS(iobuf)[0] = firstphys + totalioblocks;
+			iobuf->blocks[0] = firstphys + totalioblocks;
 
 			if (large_io) {
 				blocknr += sectors_per_page;
-				OCFS_KIO_BLOCKS(iobuf)[0] = OCFS_KIO_BLOCKS(iobuf)[0] / sectors_per_page;
+				iobuf->blocks[0] = iobuf->blocks[0] / sectors_per_page;
 			} else {
 				blocknr++;
 			}
@@ -300,9 +286,9 @@
 				} else {
 					blocknr++;
 				}
-				OCFS_KIO_BLOCKS(iobuf)[i] = OCFS_KIO_BLOCKS(iobuf)[0] + i;
+				iobuf->blocks[i] = iobuf->blocks[0] + i;
 			}
-			err = brw_kiovec (rw, 1, &iobuf, inode->i_dev, OCFS_KIO_BLOCKS(iobuf),
+			err = brw_kiovec(rw, 1, &iobuf, inode->i_dev, iobuf->blocks,
 					large_io ? PAGE_SIZE : sector_size);
 #ifdef SUSE
 			if (rw == READ &&  err > 0)
@@ -327,12 +313,12 @@
 				break;
 		}
 #ifdef KERNEL_NO_F_IOBUF
-		free_kiovec_sz(1, &iobuf, &nbhs);
+		free_kiovec(1, &iobuf);
 #else
 		if (!new_iobuf)
 			clear_bit(0, &filp->f_iobuf_lock);
 		else
-			free_kiovec_sz(1, &iobuf, &nbhs);
+			free_kiovec(1, &iobuf);
 #endif
 		inuse = 0;
 		totalioblocks = 0;
@@ -347,13 +333,13 @@
 out:
 #ifdef KERNEL_NO_F_IOBUF
 	if (inuse)
-	   free_kiovec_sz (1, &iobuf, &nbhs);
+	   free_kiovec(1, &iobuf);
 #else
 	if (inuse) {
 		if (!new_iobuf)
 			clear_bit(0, &filp->f_iobuf_lock);
 		else
-			free_kiovec_sz(1, &iobuf, &nbhs);
+			free_kiovec(1, &iobuf);
 	}
 #endif
 	return err;
