From: Rusty Lynch <rusty@linux.co.intel.com>
Date: Thu Feb  5 23:55:59 2004
Subject: [Ocfs2-devel] [PATCH] Convert to new style set/clear funcs
Message-ID: <200402060555.i165tW0l024672@penguin.co.intel.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

The following is a small patch that pushes ocfs just a little bit 
further towards a working 2.6 port.

The mark_buffer_XXX(bh, bool) functions have been replaced with
set_buffer_XXX(bh)/clear_buffer_XXX(bh)/buffer_XXX(bh) functions
in the new linux/buffer_head.h

This patch defines the 2.6 function in a 2.4 build, and then
converts all the 2.4 calls to 2.6 calls.  I did this to reduce 
the amount of #ifdef/#endif stuff in the *.c files.

    --rusty

Index: src/super.c
===================================================================
--- src/super.c	(revision 27)
+++ src/super.c	(working copy)
@@ -707,7 +707,7 @@
 
 	OCFS_BH_PUT_DATA(bh);
 	lock_buffer(bh);
-	mark_buffer_uptodate(bh, false);
+	clear_buffer_uptodate(bh);
 	unlock_buffer(bh);
 	brelse(bh);
 
@@ -812,11 +812,7 @@
 
 		lock_buffer(bhs[i]);
 		if (!buffer_dirty(bhs[i]))
-#ifdef LINUX_2_5
 			clear_buffer_uptodate(bhs[i]);
-#else
-			mark_buffer_uptodate(bhs[i], false);
-#endif
 		unlock_buffer(bhs[i]);
 	}
 
Index: src/io.c
===================================================================
--- src/io.c	(revision 27)
+++ src/io.c	(working copy)
@@ -265,12 +265,8 @@
 		}
 
 		lock_buffer(bh);
-
-#ifdef LINUX_2_5
 		set_buffer_uptodate(bh);
-#else
-		mark_buffer_uptodate(bh, true);
-#endif
+
 		/* remove from dirty list before I/O. */
 		mark_buffer_clean(bh);
 
@@ -418,11 +414,7 @@
 			}
 
 			lock_buffer(bh);
-#ifdef LINUX_2_5
 			clear_buffer_uptodate(bh);
-#else
-			mark_buffer_uptodate(bh, false);
-#endif
 			bh->b_end_io = ocfs_end_buffer_io_sync;
 			submit_bh(READ, bh);
 			continue;
@@ -547,11 +539,7 @@
 
 		lock_buffer(bh);
 
-#ifdef LINUX_2_5
 		set_buffer_uptodate(bh);
-#else
-		mark_buffer_uptodate(bh, true);
-#endif
 		/* remove from dirty list before I/O. */
 		mark_buffer_clean(bh);
 
@@ -699,11 +687,7 @@
 			}
 
 			lock_buffer(bh);
-#ifdef LINUX_2_5
 			clear_buffer_uptodate(bh);
-#else
-			mark_buffer_uptodate(bh, false);
-#endif
 			bh->b_end_io = ocfs_end_buffer_io_sync;
 			submit_bh(READ, bh);
 			continue;
Index: src/journal.c
===================================================================
--- src/journal.c	(revision 27)
+++ src/journal.c	(working copy)
@@ -511,12 +511,8 @@
 		 * gets written to disk inadvertantly by someone
 		 * else. */
 
-#ifdef LINUX_2_5
 		clear_buffer_uptodate(bh);
-#else
-		mark_buffer_uptodate(bh, false);
-#endif
-		clear_bit(BH_Dirty, &bh->b_state);
+		clear_buffer_dirty(bh);
 
 		unlock_buffer(bh);
 		/* journal_forget will bforget the buffers for us too. */
@@ -1930,7 +1926,7 @@
 		BUFFER_TRACE(bh, "marking dirty");
 		mark_buffer_dirty(bh);
 		BUFFER_TRACE(bh, "marking uptodate");
-		mark_buffer_uptodate(bh, 1);
+		set_buffer_uptodate(bh);
 		brelse(bh);
 	}
 
Index: src/util.c
===================================================================
--- src/util.c	(revision 27)
+++ src/util.c	(working copy)
@@ -403,7 +403,10 @@
 	if (!uptodate)
 		LOG_ERROR_STATUS(-EIO);
 
-	mark_buffer_uptodate(bh, uptodate);
+	if (uptodate)
+		set_buffer_uptodate(bh);
+	else
+		clear_buffer_uptodate(bh);
 	unlock_buffer(bh);
 
 //	LOG_EXIT();
Index: src/dir.c
===================================================================
--- src/dir.c	(revision 27)
+++ src/dir.c	(working copy)
@@ -806,7 +806,7 @@
 		freeOffset = 0;
 	}
 	
-	mark_buffer_uptodate(bhs[freeOffset+1], true);
+	set_buffer_uptodate(bhs[freeOffset+1]);
 	status = ocfs_journal_access(handle, bhs[freeOffset+1], 
 				     OCFS_JOURNAL_ACCESS_WRITE);
 	if (status < 0) {
@@ -1248,7 +1248,7 @@
 				newbhs[i] = getblk(OCFS_GET_BLOCKDEV(osb->sb),
 						   blk++, 
 						   osb->sb->s_blocksize);
-				mark_buffer_uptodate(newbhs[i], true);
+				set_buffer_uptodate(newbhs[i]);
 				/* clear all 128k, all garbage currently */
 				status = ocfs_journal_access(handle, newbhs[i],
 						    OCFS_JOURNAL_ACCESS_WRITE);
Index: src/oin.c
===================================================================
--- src/oin.c	(revision 27)
+++ src/oin.c	(working copy)
@@ -576,7 +576,7 @@
 
 	if (hdr_bh) {
 		lock_buffer(hdr_bh);
-		mark_buffer_uptodate(hdr_bh, false);
+		clear_buffer_uptodate(hdr_bh);
 		unlock_buffer(hdr_bh);
 		brelse(hdr_bh);
 	}
Index: src/inc/io.h
===================================================================
--- src/inc/io.h	(revision 27)
+++ src/inc/io.h	(working copy)
@@ -50,11 +50,41 @@
 #define OCFS_NONCACHED(osb,off)  ((off) < (osb)->vol_layout.data_start_off)
 
 #define BH_Modified 18
-#define buffer_modified(bh)		__buffer_state((bh),Modified)
-#define set_buffer_modified(bh)		set_bit(BH_Modified, &(bh)->b_state);
-#define clear_buffer_modified(bh)	clear_bit(BH_Modified, &(bh)->b_state);
 
+#if LINUX_VERSION_CODE > KERNEL_VERSION(2,5,0)
+/* 
+ * BUFFER_FNS is the new marcro magic intruduced in 2.5.x kernel for defining
+ * set_buffer_XXX, clear_buffer_XXX, and buffer_XXX functions
+ */
+BUFFER_FNS(Modified, modified)
 
+#else /* 2.4.x kernel */
+
+/*
+ * Copied right out of the 2.6.2 kernel's buffer_head.h:
+ * macro tricks to expand the set_buffer_foo(), clear_buffer_foo()
+ * and buffer_foo() functions.
+ */
+#define BUFFER_FNS(bit, name)						\
+static inline void set_buffer_##name(struct buffer_head *bh)		\
+{									\
+	set_bit(BH_##bit, &(bh)->b_state);				\
+}									\
+static inline void clear_buffer_##name(struct buffer_head *bh)		\
+{									\
+	clear_bit(BH_##bit, &(bh)->b_state);				\
+}									\
+static inline int buffer_##name(struct buffer_head *bh)			\
+{									\
+	return test_bit(BH_##bit, &(bh)->b_state);			\
+}
+
+#undef buffer_uptodate
+BUFFER_FNS(Uptodate, uptodate)
+BUFFER_FNS(Modified, modified)
+
+#endif /* 2.4.x kernel */
+
 static inline void * OCFS_BH_GET_DATA_READ(struct buffer_head *bh)
 {
 	unsigned char *kaddr;
Index: src/namei.c
===================================================================
--- src/namei.c	(revision 27)
+++ src/namei.c	(working copy)
@@ -425,7 +425,7 @@
 			dirbhs[i] = getblk (OCFS_GET_BLOCKDEV(osb->sb), 
 					    blk++, osb->sb->s_blocksize);
 
-			mark_buffer_uptodate(dirbhs[i], true);
+			set_buffer_uptodate(dirbhs[i]);
 			status = ocfs_journal_access(handle, dirbhs[i], 
 					     OCFS_JOURNAL_ACCESS_WRITE);
 			if (status < 0) {
Index: src/alloc.c
===================================================================
--- src/alloc.c	(revision 27)
+++ src/alloc.c	(working copy)
@@ -673,11 +673,7 @@
 		memset(buff, 0, osb->sect_size);
 
 		/* TODO: Do we really need to do this? */
-#ifdef LINUX_2_5
 		set_buffer_uptodate(header_bhs[i]);
-#else
-		mark_buffer_uptodate(header_bhs[i], true);
-#endif
 		OCFS_BH_PUT_DATA(header_bhs[i]);
 	}
 
@@ -901,11 +897,7 @@
 		}
 		buf = OCFS_BH_GET_DATA_WRITE(bhs[i]);  /* write */
 		memset(buf, 0, osb->sect_size);
-#ifdef LINUX_2_5
 		set_buffer_uptodate(bhs[i]);
-#else
-		mark_buffer_uptodate(bhs[i], true);
-#endif
 		OCFS_BH_PUT_DATA(bhs[i]);
 	}
 
