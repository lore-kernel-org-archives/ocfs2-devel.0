From: Christoph Hellwig <hch@lst.de>
Date: Fri Jul 16 16:32:26 2004
Subject: [Ocfs2-devel] [PATCH] provide sync_mapping_buffers stub for 2.4
Message-ID: <20040716213221.GB10617@lst.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Two issues here:

(a) two places were using only fsync_inode_buffers but not
    fsync_inode_data_buffers in 2.4.  This looks like a bug to me, but
    if it was intentional the patch needs rework.
(b) by moving the sync_mapping_buffers from ocfs_inc_inode_seq into
    the only caller that actually wants it it can lose a parameter.


diff -u src/dlm.c src/dlm.c
--- src/dlm.c	(working copy)
+++ src/dlm.c	(working copy)
@@ -1410,7 +1410,7 @@
 		ocfs_node_map_set(&lockres->oin_openmap, &open_map);
 
 	if (need_to_zap_buffers)
-		ocfs_inc_inode_seq(osb, inode, 0);
+		ocfs_inc_inode_seq(osb, inode);
 	
 	/* just alerting owner on open */
 	if (flags & (FLAG_ADD_OIN_MAP | FLAG_TRUNCATE_PAGES))
diff -u src/nm.c src/nm.c
--- src/nm.c	(working copy)
+++ src/nm.c	(working copy)
@@ -951,11 +951,7 @@
 
 			inode->i_nlink = 0;
 			d_prune_aliases (inode);
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,0)
 			sync_mapping_buffers(inode->i_mapping);
-#else
-			fsync_inode_buffers (inode);
-#endif
 			ocfs_truncate_inode_pages(inode, 0);
 			/* Alright, for the YES case, we're done here. */
 			break;
@@ -986,14 +982,7 @@
 
 			// if the requestor just wants to do readdir, we 
 			// drop our buffers, so switch to readonly and done
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,0)
 			sync_mapping_buffers(inode->i_mapping);
-#else
-			fsync_inode_buffers(inode);
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,4,18)
-			fsync_inode_data_buffers(inode);
-#endif
-#endif
 
 			ocfs_node_map_set_bit(&lockres->readonly_map, node_num);
 			lockres->readonly_node = osb->node_num;
@@ -1059,14 +1048,7 @@
 				lockres->readonly_node = OCFS_INVALID_NODE_NUM;
 			}
 
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,0)
 			sync_mapping_buffers(inode->i_mapping);
-#else
-			fsync_inode_buffers(inode);
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,4,18)
-			fsync_inode_data_buffers(inode);
-#endif
-#endif
 
 #warning do we need a truncate_inode_pages here?
 
@@ -1099,7 +1081,7 @@
 			}
 
 			if (is_dir && vote_type == RELEASE_CACHE)
-				ocfs_inc_inode_seq(osb, inode, 0);
+				ocfs_inc_inode_seq(osb, inode);
 
 			/* need to do the write only if fe lock values need to change */
 			if (is_locked || vote_type == CHANGE_MASTER) {
@@ -1297,8 +1279,10 @@
 
 leave:
 	if (inode) {
-		if (inc_inode_seq)
-			ocfs_inc_inode_seq(osb, inode, 1);
+		if (inc_inode_seq) {
+			ocfs_inc_inode_seq(osb, inode);
+			sync_mapping_buffers(inode->i_mapping);
+		}
 		if (have_io_sem)
 			up_write(&OCFS_I(inode)->ip_io_sem);
 		iput(inode);
@@ -1313,7 +1297,7 @@
 
 
 /* inode is definitely non NULL */
-void ocfs_inc_inode_seq(ocfs_super *osb, struct inode *inode, int sync_buffers)
+void ocfs_inc_inode_seq(ocfs_super *osb, struct inode *inode)
 {
 	atomic_t *seq = GET_INODE_CLEAN_SEQ(inode);
 
@@ -1334,17 +1318,6 @@
 	
 	LOG_TRACE_ARGS("done incrementing inode seq... new is %d\n", 
 		       atomic_read(seq));
-
-	if (sync_buffers) {
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,0)
-		sync_mapping_buffers(inode->i_mapping);
-#else
-		fsync_inode_buffers(inode);
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,4,18)
-		fsync_inode_data_buffers(inode);
-#endif
-#endif
-	}
 }
 
 
only in patch2:
unchanged:
--- src/ocfs_compat.h	(revision 1280)
+++ src/ocfs_compat.h	(working copy)
@@ -108,6 +108,20 @@
 #define INIT_WORK(w, f, d)	INIT_TQUEUE(w, f, d)
 #define schedule_work(w)	schedule_task(w)
 
+static inline int sync_mapping_buffers(struct adress_space *mapping)
+{       
+	struct inode = mapping->host;
+	int error;
+
+	error = fsync_inode_buffers(inode);
+#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,4,18)
+	if (!error)
+		error = fsync_inode_data_buffers(inode);
+#endif
+	return error;
+}
+
+
 #ifdef HAVE_NPTL
 static inline void dequeue_signal_lock(struct task_struct *task,
 				       sigset_t *blocked, siginfo_t *info)
@@ -143,9 +157,6 @@
 
 #define ocfs_get_seconds(t) ((t).tv_sec)
 
-#define fsync_inode_buffers(inode) \
-	sync_mapping_buffers((inode)->i_mapping)
-
 #endif  /* LINUX_VERSION_CODE < 2.6 */
 
 #ifndef BITS_TO_LONGS
only in patch2:
unchanged:
--- src/namei.c	(revision 1280)
+++ src/namei.c	(working copy)
@@ -1314,7 +1314,7 @@
 	ocfs_commit_trans(handle);
 
 	if (new_inode)
-		fsync_inode_buffers(old_inode);
+		sync_mapping_buffers(old_inode->i_mapping);
 
 	status = 0;
 
only in patch2:
unchanged:
--- src/file.c	(revision 1280)
+++ src/file.c	(working copy)
@@ -80,19 +80,12 @@
 
 int ocfs_sync_inode(struct inode *inode)
 {
-	int status;
 #if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,0)
 	filemap_fdatawrite(inode->i_mapping);
-	status = sync_mapping_buffers(inode->i_mapping);
 #else
 	filemap_fdatasync(inode->i_mapping);
-	status = fsync_inode_buffers(inode);
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,4,18)
-	if (!status)	       
-		status = fsync_inode_data_buffers(inode);
 #endif
-#endif
-	return status;
+	return sync_mapping_buffers(inode->i_mapping);
 }
 
 /* 
only in patch2:
unchanged:
--- src/nm.h	(revision 1280)
+++ src/nm.h	(working copy)
@@ -31,8 +31,7 @@
 
 int ocfs_drop_readonly_cache_lock(ocfs_super *osb, struct inode *inode,
 				  int yield);
-void ocfs_inc_inode_seq(ocfs_super *osb, struct inode *inode,
-			int sync_buffers);
+void ocfs_inc_inode_seq(ocfs_super *osb, struct inode *inode);
 int ocfs_process_vote(ocfs_super *osb, ocfs_vote_request_ctxt *ctxt);
 int ocfs_recv_thread(void *unused);
 void ocfs_recover_oin_locks(ocfs_super *osb, __u32 node_num);
