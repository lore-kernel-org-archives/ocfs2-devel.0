From: Christoph Hellwig <hch@lst.de>
Date: Sun Jun 20 09:18:36 2004
Subject: [Ocfs2-devel] [PATCH] reduce the read_inode ifdef mess a little
Message-ID: <20040620141832.GA15872@lst.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com


--- src/inode.c	(revision 1156)
+++ src/inode.c	(working copy)
@@ -87,13 +85,13 @@
 static int ocfs_get_block (struct inode *inode, sector_t iblock, struct buffer_head *bh_result, int create);
 static int ocfs_symlink_get_block (struct inode *inode, sector_t iblock, struct buffer_head *bh_result, int create);
 
+static void ocfs_read_locked_inode(struct inode *inode, ocfs_find_inode_args *args);
 #if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,0)
 static sector_t ocfs_bmap(struct address_space *mapping, sector_t block);
 static int ocfs_writepage (struct page *page, struct writeback_control *wbc);
 static ssize_t ocfs_direct_IO(int rw, struct kiocb *iocb, const struct iovec *iov, loff_t offset, unsigned long nr_segs);
 static int ocfs_init_locked_inode(struct inode * inode, void * opaque);
 static int ocfs_find_actor (struct inode *inode, void *opaque);
-static void ocfs_read_locked_inode (struct inode *inode, ocfs_find_inode_args *args);
 #else /* 2.4 kernel */
 static int ocfs_find_inode (struct inode *inode, unsigned long ino, void *opaque);
 static int ocfs_bmap(struct address_space *mapping, long block);
@@ -256,15 +220,63 @@
 	return(inode);
 } /* ocfs_iget */
 
+
+#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,0)
 /*
  * here's how inodes get read from disk:
+ * iget5_locked -> find_actor -> OCFS_FIND_ACTOR
+ * found? : return the in-memory inode
+ * not found? : get_new_inode -> OCFS_INIT_LOCKED_INODE
+ */
+
+static int ocfs_find_actor(struct inode *inode, void *opaque)
+{
+	ocfs_find_inode_args *args = NULL;
+	int ret = 0;
+
+	LOG_ENTRY_ARGS ("(0x%p, %lu, %llu, 0x%p)\n", inode, inode->i_ino, GET_INODE_FEOFF(inode), opaque);
+
+	if (inode == NULL)
+		goto bail;
+
+	args = opaque;
+
+	if (GET_INODE_FEOFF(inode) != args->feoff) {
+		LOG_ERROR_STATUS(-EINVAL);
+		goto bail;
+	}
+
+	ret = 1;
+bail:
+	LOG_EXIT_INT (ret);
+	return ret;
+}
+
+/*
+ * initialize the new inode, but don't do anything that would cause 
+ * us to sleep.
+ * return 0 on success, 1 on failure
+ */
+static int ocfs_init_locked_inode(struct inode * inode, void * opaque) 
+{
+	ocfs_find_inode_args *args = opaque;
+	LOG_ENTRY_ARGS("inode = %p, opaque = %p\n", inode, opaque);
+
+	inode->i_ino = args->ino;
+
+	LOG_EXIT_STATUS(0);
+	return(0);
+}
+
+#else /* 2.4 kernel stuff */
+
+/*
+ * here's how inodes get read from disk:
  * iget4 -> find_inode -> OCFS_FIND_INODE
  * found? : return the in-memory inode
  * not found? : get_new_inode -> OCFS_READ_INODE2
  */
 
-#if LINUX_VERSION_CODE < KERNEL_VERSION(2,5,0)
-
 /*
  * ocfs_find_inode()
  *
@@ -293,9 +305,21 @@
 bail:
 	LOG_EXIT_INT (ret);
 	return ret;
-}				/* ocfs_find_inode */
+}
+
+void ocfs_read_inode2(struct inode *inode, void *opaque)
+{
+	ocfs_read_locked_inode(inode, opaque);
+}
+
+void ocfs_read_inode(struct inode *inode)
+{
+	make_bad_inode(inode);
+}
+
 #endif /* LINUX_VERSION_CODE < KERNEL_VERSION(2,5,0) */
 
+
 /*
  * ocfs_inode_init_private()
  *
@@ -454,45 +478,8 @@
 	return;
 }				/* ocfs_populate_inode */
 
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,0)
-/*
- * ocfs_read_locked_inode()
- *
- * by this point, i_sb, i_dev, i_ino are filled in
- *
- */
-static void ocfs_read_locked_inode (struct inode *inode, ocfs_find_inode_args *args)
+static void ocfs_read_locked_inode(struct inode *inode, ocfs_find_inode_args *args)
 {
-	__ocfs_read_inode2(inode, args);
-	return;
-}				/* ocfs_read_locked_inode */
-
-#else
-
-/*
- * ocfs_read_inode2()
- *
- * by this point, i_sb, i_dev, i_ino are filled in
- *
- */
-void ocfs_read_inode2 (struct inode *inode, void *opaque)
-{
-	__ocfs_read_inode2(inode, opaque);
-	return;
-}				/* ocfs_read_inode2 */
-
-/*
- * ocfs_read_inode()
- * Only used in Linux 2.4
- */
-void ocfs_read_inode (struct inode *inode)
-{
-	make_bad_inode (inode);
-}				/* ocfs_read_inode() */
-#endif
-
-static void __ocfs_read_inode2(struct inode *inode, ocfs_find_inode_args *args)
-{
 	struct super_block *sb;
 	ocfs_super *osb;
 	__u64 feoff = 0ULL;
@@ -552,63 +539,7 @@
 	return;
 }
 
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,0)
 /*
- * here's how inodes get read from disk:
- * iget5_locked -> find_actor -> OCFS_FIND_ACTOR
- * found? : return the in-memory inode
- * not found? : get_new_inode -> OCFS_INIT_LOCKED_INODE
- */
-
-/*
- * ocfs_find_actor()
- *
- * This is the iget5_locked helper function. It used to be ocfs_find_inode()
- */
-static int ocfs_find_actor (struct inode *inode, void *opaque)
-{
-	ocfs_find_inode_args *args = NULL;
-	int ret = 0;
-
-	LOG_ENTRY_ARGS ("(0x%p, %lu, %llu, 0x%p)\n", inode, inode->i_ino, GET_INODE_FEOFF(inode), opaque);
-
-	if (inode == NULL)
-		goto bail;
-
-	args = opaque;
-
-	if (GET_INODE_FEOFF(inode) != args->feoff) {
-		LOG_ERROR_STATUS(-EINVAL);
-		goto bail;
-	}
-
-	ret = 1;
-bail:
-	LOG_EXIT_INT (ret);
-	return ret;
-}				/* ocfs_find_actor */
-
-
-/*
- * initialize the new inode, but don't do anything that would cause 
- * us to sleep.
- * return 0 on success, 1 on failure
- */
-static int ocfs_init_locked_inode(struct inode * inode, void * opaque) 
-{
-	ocfs_find_inode_args *args = opaque;
-	LOG_ENTRY_ARGS("inode = %p, opaque = %p\n", inode, opaque);
-
-	inode->i_ino = args->ino;
-
-	LOG_EXIT_STATUS(0);
-	return(0);
-}
-
-#endif /* 2.6 kernel stuff */
-
-
-/*
  * ocfs_put_inode()
  *
  */
