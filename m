From: Christoph Hellwig <hch@lst.de>
Date: Mon Jul  5 15:17:05 2004
Subject: [Ocfs2-devel] [PATCH] fix new LBD warnings
Message-ID: <20040705201649.GA5455@lst.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

looks like no one tests with CONFIG_LBD..


Index: src/dcache.c
===================================================================
--- src/dcache.c	(revision 1238)
+++ src/dcache.c	(working copy)
@@ -112,37 +112,3 @@
 	.d_revalidate		= ocfs_dentry_revalidate24,
 };
 #endif
-
-/*
- * ocfs_foreach_child()
- *
- */
-int ocfs_foreach_child (struct dentry *dentry, int (*func)(struct dentry *, void *), void *data)
-{
-	struct list_head *list;
-	int ret, done;
-
-	LOG_ENTRY_ARGS ("(0x%p, '%*s')\n", dentry,
-			dentry->d_name.len, dentry->d_name.name);
-
-	spin_lock (&dcache_lock);
-	list = dentry->d_subdirs.next;
-
-	ret = 1;
-	while (list != &dentry->d_subdirs) {
-		struct dentry *de = list_entry (list, struct dentry, d_child);
-
-		if (de->d_inode && !d_unhashed (de)) {
-			done = func(de, data);
-			if (done) {
-				ret = 0;
-				break;
-			}
-		}
-		list = list->next;
-	}
-	spin_unlock (&dcache_lock);
-
-	LOG_EXIT_INT (ret);
-	return ret;
-}
Index: src/dlm.c
===================================================================
--- src/dlm.c	(revision 1238)
+++ src/dlm.c	(working copy)
@@ -62,7 +62,6 @@
 static int ocfs_reset_voting (ocfs_super * osb);
 static int ocfs_get_vote_on_disk (ocfs_super * osb, __u64 lock_id, __u32 lock_type, __u32 flags, ocfs_node_map * got_vote_map, ocfs_node_map * vote_map, __u64 lock_seq_num, ocfs_node_map * oin_open_map);
 int ocfs_disk_release_lock (ocfs_super * osb, __u64 lock_id, __u32 lock_type, __u32 flags, struct buffer_head *bh, struct inode *inode);
-static int ocfs_zap_child_buffers_func(struct dentry *dentry, void *data);
 
 
 void ocfs_set_publish_vote_map(ocfs_super *osb, ocfs_publish *publish, ocfs_node_map *vote_map)
@@ -1268,32 +1267,10 @@
 }				/* ocfs_release_lock */
 
 
-/* inode is definitely non NULL */
-static int ocfs_zap_child_buffers_func(struct dentry *dentry, void *data)
-{
-	struct inode *inode = dentry->d_inode;
-	ocfs_super *osb = data;
-
-	ocfs_inc_inode_seq(osb, inode, 0);
-	return 0;
-}
-
 int ocfs_break_cache_lock_zap_buffers(ocfs_super * osb, struct inode * inode)
 {
-	struct list_head *iter;
-	struct dentry *dentry;
-
-	if (inode==NULL) 
-		return 0;
-
-#warning invalidating child inodes is probably inappropriate now
-#if 0
-	list_for_each(iter, &(inode->i_dentry)) {
-		dentry = list_entry (iter, struct dentry, d_alias);
-		ocfs_foreach_child (dentry, ocfs_zap_child_buffers_func, osb);
-	}
-#endif
-	ocfs_inc_inode_seq(osb, inode, 0);
+	if (inode) 
+		ocfs_inc_inode_seq(osb, inode, 0);
 	return 0;
 }
 
Index: src/dcache.h
===================================================================
--- src/dcache.h	(revision 1238)
+++ src/dcache.h	(working copy)
@@ -31,8 +31,4 @@
 
 extern struct dentry_operations ocfs_dentry_ops;
 
-int ocfs_foreach_child(struct dentry *dentry,
-		       int (*func)(struct dentry *, void *),
-		       void *data);
-
 #endif /* OCFS2_DCACHE_H */
Index: src/namei.c
===================================================================
--- src/namei.c	(revision 1238)
+++ src/namei.c	(working copy)
@@ -85,7 +85,7 @@
 
 static int ocfs_mknod_locked(ocfs_super *osb, struct inode *dir, 
 			     struct dentry *dentry, int mode, 
-			     ocfs_dev dev,
+			     dev_t dev,
 			     struct buffer_head **new_fe_bh, 
 			     struct buffer_head *parent_fe_bh,
 			     ocfs_journal_handle *handle,
@@ -178,8 +178,8 @@
 	return ret;
 }				/* ocfs_lookup */
 
-static int ocfs_mknod(struct inode *dir, struct dentry *dentry, int mode, 
-	       ocfs_dev dev)
+static int ocfs_mknod(struct inode *dir, struct dentry *dentry,
+		int mode, dev_t dev)
 {
 	int status = 0;
 	struct buffer_head *parent_fe_bh = NULL;
@@ -254,8 +254,10 @@
 	fe = (ocfs2_dinode *)new_fe_bh->b_data;
 
 	if (ocfs_populate_inode(inode, fe, 1) < 0) {
-		LOG_ERROR_ARGS("populate inode failed! bh->b_blocknr=%lu, i_blkno=%llu, i_ino=%lu\n",
-			       new_fe_bh->b_blocknr, fe->i_blkno, inode->i_ino);
+		LOG_ERROR_ARGS("populate inode failed! bh->b_blocknr=%llu, "
+			       "i_blkno=%llu, i_ino=%lu\n",
+			       (unsigned long long)new_fe_bh->b_blocknr,
+			       fe->i_blkno, inode->i_ino);
 		BUG();
 	}
 
@@ -359,7 +361,7 @@
  */
 static int ocfs_mknod_locked(ocfs_super *osb, struct inode *dir, 
 			     struct dentry *dentry, int mode, 
-			     ocfs_dev dev,
+			     dev_t dev,
 			     struct buffer_head **new_fe_bh, 
 			     struct buffer_head *parent_fe_bh,
 			     ocfs_journal_handle *handle,
@@ -502,7 +504,7 @@
 
 	LOG_ENTRY_ARGS ("(0x%p, 0x%p, %d, '%*s')\n", dir, dentry, mode,
 			dentry->d_name.len, dentry->d_name.name);
-	ret = ocfs_mknod (dir, dentry, mode | S_IFDIR, OCFS_NODEV);
+	ret = ocfs_mknod (dir, dentry, mode | S_IFDIR, 0);
 	LOG_EXIT_INT (ret);
 
 	LOG_CLEAR_CONTEXT();
@@ -521,7 +523,7 @@
 
 	LOG_ENTRY_ARGS ("(0x%p, 0x%p, %d, '%*s')\n", dir, dentry, mode,
 			dentry->d_name.len, dentry->d_name.name);
-	ret = ocfs_mknod (dir, dentry, mode | S_IFREG, OCFS_NODEV);
+	ret = ocfs_mknod (dir, dentry, mode | S_IFREG, 0);
 	LOG_EXIT_INT (ret);
 
 	LOG_CLEAR_CONTEXT();
@@ -1556,7 +1558,7 @@
 	got_lock = 1;
 
 	status = ocfs_mknod_locked(osb, dir, dentry, 
- 				   S_IFLNK | S_IRWXUGO, OCFS_NODEV,
+ 				   S_IFLNK | S_IRWXUGO, 0,
  				   &new_fe_bh, parent_fe_bh, handle,
 				   inode);
 	if (status < 0) {
@@ -1567,8 +1569,10 @@
 	fe = (ocfs2_dinode *) new_fe_bh->b_data;
 	
 	if (ocfs_populate_inode (inode, fe, 1) < 0) {
-		LOG_ERROR_ARGS("populate inode failed! bh->b_blocknr=%lu, i_blkno=%llu, i_ino=%lu\n",
-			       new_fe_bh->b_blocknr, fe->i_blkno, inode->i_ino);
+		LOG_ERROR_ARGS("populate inode failed! bh->b_blocknr=%llu, "
+			       "i_blkno=%llu, i_ino=%lu\n",
+			       (unsigned long long)new_fe_bh->b_blocknr,
+			       fe->i_blkno, inode->i_ino);
 		BUG();
 	}
 
@@ -1584,7 +1588,7 @@
 		}
 		goto abort_trans;
 	}
-	inode->i_rdev = OCFS_NODEV;
+	inode->i_rdev = 0;
 	inode->i_size = newsize;
 	inode->i_blocks = (newsize + sb->s_blocksize - 1) >> sb->s_blocksize_bits;
 
@@ -2181,6 +2185,12 @@
 	return ocfs_create(dir, dentry, mode, NULL);
 }
 
+static int ocfs_mknod_24(struct inode *dir, struct dentry *dentry,
+		int mode, int dev)
+{
+	return ocfs_mknod(dir, dentry, mode, dev);
+}
+
 struct inode_operations ocfs_dir_iops = {
 	.create		= ocfs_create_24,
 	.lookup		= ocfs_lookup_24,
@@ -2189,7 +2199,7 @@
 	.rmdir		= ocfs_unlink,
 	.symlink	= ocfs_symlink,
 	.mkdir		= ocfs_mkdir,
-	.mknod		= ocfs_mknod,
+	.mknod		= ocfs_mknod_24,
 	.rename		= ocfs_rename,
 	.setattr	= ocfs_setattr,
 	.revalidate	= ocfs_inode_revalidate,
Index: src/inode.c
===================================================================
--- src/inode.c	(revision 1238)
+++ src/inode.c	(working copy)
@@ -2010,7 +2010,7 @@
 	       	    S_ISBLK(fe->i_mode) ||
 	      	    S_ISFIFO(fe->i_mode) ||
 	     	    S_ISSOCK(fe->i_mode)) {
-			inode->i_rdev = OCFS_NODEV;
+			inode->i_rdev = 0;
 			init_special_inode(inode, inode->i_mode,
 					   huge_decode_dev(le64_to_cpu(fe->id1.dev1.i_rdev)));
 		}
Index: src/ocfs.h
===================================================================
--- src/ocfs.h	(revision 1238)
+++ src/ocfs.h	(working copy)
@@ -306,15 +306,6 @@
 #define  OCFS_IOC_MAGIC          'O'
 #define  OCFS_IOC_GETTYPE        _IOR(OCFS_IOC_MAGIC, 1, struct ocfs_ioc)
 
-
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,0)
-typedef dev_t ocfs_dev;
-#define OCFS_NODEV     0
-#else /* 2.4 kernel */
-typedef int ocfs_dev;
-#define OCFS_NODEV     NODEV
-#endif
-
 #define OCFS_SB(sb)	    ((ocfs_super *)OCFS_GENERIC_SB_MEMBER(sb))
 #define OCFS2_SB(sb)	    ((ocfs_super *)OCFS_GENERIC_SB_MEMBER(sb))
 
Index: src/file.c
===================================================================
--- src/file.c	(revision 1238)
+++ src/file.c	(working copy)
@@ -1260,7 +1260,8 @@
 					LOG_ERROR_STATUS(status=-EIO);
 					goto leave;
 				}
-				LOG_TRACE_ARGS("setting block %lu as new!\n", block);
+				LOG_TRACE_ARGS("setting block %llu as new!\n",
+					       (unsigned long long)block);
 				alloc_bh->b_state |= (1UL << BH_New);
 				brelse(alloc_bh);
 			}
