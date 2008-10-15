From: wangang wang <wen.gang.wang@oracle.com>
Date: Wed, 15 Oct 2008 15:04:04 +0800
Subject: [Ocfs2-devel] [PATCH 1/1] OCFS2: add block lock protecting
	vote-updating/reading the same block for NFS support
Message-ID: <200810150704.m9F744es020180@localhost.localdomain>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Ocfs2 supports exporting. Current version of ocfs2_get_dentry() reads from disk
inode when it's not in memory yet WITHOUT any cluster lock.

For inode deletion, after the vote--disk updating, on all nodes in the cluster 
domain, there shouldn't be an in-memory inode in question or the in-memory inode
is with OCFS2_INODE_DELETE flag indicating this inode is deleted from other
node.

If the ocfs2_get_dentry() happens during the process of delete-voting and disk
inode deletion. it may introduce a situation that
(1) there is the in-memory inode.
(2) this inode is without OCFS2_INODE_DELETE.

For later operations on the stale inode, this may leads to crash because of the 
mismatch of the in-memory generation against the on-disk one if a new inode 
occupied the same block.

This patch fixes the problem by adding cross cluster lock protecting vote-disk 
updating against nfs reading. It ensures the inode is with OCFS2_INODE_DELETE flag 
or there is no such an in-memory inode.

The drawback is that cluster locking is time consuming thus it kill performance.
Good news is it seems that get_dentry() function is not called very often.

By this the above fix, reading a block from ocfs2_get_dentry() may be
blocked when a different block is under vote -- updating from other nodes.
To abate that, a couple of such cross cluster locks are used. all blocs go to 
these locks. It's unlucky for the reading of a block which is goes to the same 
lock as a different block under vote--updating goes to.

Signed-off-by: Wengang wang <wen.gang.wang@oracle.com>
--
Index: fs/ocfs2/dlmglue.h
===================================================================
--- fs/ocfs2/dlmglue.h	(revision 3101)
+++ fs/ocfs2/dlmglue.h	(working copy)
@@ -79,6 +79,12 @@ void ocfs2_super_unlock(struct ocfs2_sup
 			int ex);
 int ocfs2_rename_lock(struct ocfs2_super *osb);
 void ocfs2_rename_unlock(struct ocfs2_super *osb);
+
+int ocfs2_dealloc_lock(struct ocfs2_super *osb, u64 blkno,
+		       int ex);
+void ocfs2_dealloc_unlock(struct ocfs2_super *osb, u64 blkno,
+			 int ex);
+
 void ocfs2_mark_lockres_freeing(struct ocfs2_lock_res *lockres);
 
 /* for the vote thread */
Index: fs/ocfs2/export.c
===================================================================
--- fs/ocfs2/export.c	(revision 3101)
+++ fs/ocfs2/export.c	(working copy)
@@ -49,6 +49,7 @@ static struct dentry *ocfs2_get_dentry(s
 	struct ocfs2_inode_handle *handle = vobjp;
 	struct inode *inode;
 	struct dentry *result;
+	int status;
 
 	mlog_entry("(0x%p, 0x%p)\n", sb, handle);
 
@@ -57,7 +58,14 @@ static struct dentry *ocfs2_get_dentry(s
 		return ERR_PTR(-ESTALE);
 	}
 
+	/* lock this disk block against updating it from other nodes */
+	status = ocfs2_dealloc_lock(OCFS2_SB(sb), (u64)handle->ih_blkno, 0);
+	if (status < 0) {
+		mlog_errno(status);
+		return ERR_PTR(status);
+	}
 	inode = ocfs2_iget(OCFS2_SB(sb), handle->ih_blkno);
+	ocfs2_dealloc_unlock(OCFS2_SB(sb), (u64)handle->ih_blkno, 0);
 
 	if (IS_ERR(inode))
 		return (void *)inode;
Index: fs/ocfs2/inode.c
===================================================================
--- fs/ocfs2/inode.c	(revision 3101)
+++ fs/ocfs2/inode.c	(working copy)
@@ -829,6 +829,16 @@ void ocfs2_delete_inode(struct inode *in
 		goto bail;
 	}
 
+	/* prevents reading this disk block during the vote 
+	 * and disk updating */
+	status = ocfs2_dealloc_lock(OCFS2_SB(inode->i_sb),
+				    (u64)inode->i_ino, 1);
+	if (status < 0) {
+		mlog_errno(status);
+		ocfs2_cleanup_delete_inode(inode, 0);
+		goto bail_unblock;
+	}
+
 	/* Lock down the inode. This gives us an up to date view of
 	 * it's metadata (for verification), and allows us to
 	 * serialize delete_inode votes. */
@@ -837,7 +847,7 @@ void ocfs2_delete_inode(struct inode *in
 		if (status != -ENOENT)
 			mlog_errno(status);
 		ocfs2_cleanup_delete_inode(inode, 0);
-		goto bail_unblock;
+		goto bail_unlock_dealloc_lock;
 	}
 
 	/* Query the cluster. This will be the final decision made
@@ -874,6 +884,9 @@ void ocfs2_delete_inode(struct inode *in
 bail_unlock_inode:
 	ocfs2_meta_unlock(inode, 1);
 	brelse(di_bh);
+bail_unlock_dealloc_lock:
+	ocfs2_dealloc_unlock(OCFS2_SB(inode->i_sb),
+			     (u64)inode->i_ino, 1);
 bail_unblock:
 	status = sigprocmask(SIG_SETMASK, &oldset, NULL);
 	if (status < 0)
Index: fs/ocfs2/ocfs2_lockid.h
===================================================================
--- fs/ocfs2/ocfs2_lockid.h	(revision 3101)
+++ fs/ocfs2/ocfs2_lockid.h	(working copy)
@@ -40,6 +40,7 @@ enum ocfs2_lock_type {
 	OCFS2_LOCK_TYPE_DATA,
 	OCFS2_LOCK_TYPE_SUPER,
 	OCFS2_LOCK_TYPE_RENAME,
+	OCFS2_LOCK_TYPE_DEALLOC,
 	OCFS2_NUM_LOCK_TYPES
 };
 
@@ -59,6 +60,9 @@ static inline char ocfs2_lock_type_char(
 		case OCFS2_LOCK_TYPE_RENAME:
 			c = 'R';
 			break;
+		case OCFS2_LOCK_TYPE_DEALLOC:
+			c = 'E';
+			break;
 		default:
 			c = '\0';
 	}
Index: fs/ocfs2/ocfs2.h
===================================================================
--- fs/ocfs2/ocfs2.h	(revision 3101)
+++ fs/ocfs2/ocfs2.h	(working copy)
@@ -44,6 +44,8 @@
 #include "endian.h"
 #include "ocfs2_lockid.h"
 
+#define OCFS2_DEALLOC_NR     16
+
 struct ocfs2_extent_map {
 	u32		em_clusters;
 	struct rb_root	em_extents;
@@ -267,6 +269,11 @@ struct ocfs2_super
 	struct dlm_ctxt *dlm;
 	struct ocfs2_lock_res osb_super_lockres;
 	struct ocfs2_lock_res osb_rename_lockres;
+
+	/* holds block locks which protect updating/reading 
+ 	 * on the same disk block*/
+	struct ocfs2_lock_res osb_dealloc_lockres[OCFS2_DEALLOC_NR];
+
 	struct dlm_eviction_cb osb_eviction_cb;
 	struct ocfs2_dlm_debug *osb_dlm_debug;
 
Index: fs/ocfs2/dlmglue.c
===================================================================
--- fs/ocfs2/dlmglue.c	(revision 3101)
+++ fs/ocfs2/dlmglue.c	(working copy)
@@ -66,6 +66,9 @@ static void ocfs2_super_bast_func(void *
 static void ocfs2_rename_ast_func(void *opaque);
 static void ocfs2_rename_bast_func(void *opaque,
 				   int level);
+static void ocfs2_dealloc_ast_func(void *opaque);
+static void ocfs2_dealloc_bast_func(void *opaquei,
+				    int level);
 
 /* so far, all locks have gotten along with the same unlock ast */
 static void ocfs2_unlock_ast_func(void *opaque,
@@ -122,6 +125,13 @@ static struct ocfs2_lock_res_ops ocfs2_r
 	.unblock	= ocfs2_unblock_osb_lock,
 };
 
+static struct ocfs2_lock_res_ops ocfs2_dealloc_lops = {
+	.ast		= ocfs2_dealloc_ast_func,
+	.bast		= ocfs2_dealloc_bast_func,
+	.unlock_ast	= ocfs2_unlock_ast_func,
+	.unblock	= ocfs2_unblock_osb_lock,
+};
+
 static inline int ocfs2_is_inode_lock(struct ocfs2_lock_res *lockres)
 {
 	return lockres->l_type == OCFS2_LOCK_TYPE_META ||
@@ -138,10 +148,16 @@ static inline int ocfs2_is_rename_lock(s
 	return lockres->l_type == OCFS2_LOCK_TYPE_RENAME;
 }
 
+static inline int ocfs2_is_dealloc_lock(struct ocfs2_lock_res *lockres)
+{
+	return lockres->l_type == OCFS2_LOCK_TYPE_DEALLOC;
+}
+
 static inline struct ocfs2_super *ocfs2_lock_res_super(struct ocfs2_lock_res *lockres)
 {
 	BUG_ON(!ocfs2_is_super_lock(lockres)
-	       && !ocfs2_is_rename_lock(lockres));
+	       && !ocfs2_is_rename_lock(lockres)
+	       && !ocfs2_is_dealloc_lock(lockres));
 
 	return (struct ocfs2_super *) lockres->l_priv;
 }
@@ -314,6 +330,16 @@ static void ocfs2_rename_lock_res_init(s
 				   &ocfs2_rename_lops, osb);
 }
 
+static void ocfs2_dealloc_lock_res_init(struct ocfs2_lock_res *res,
+					u64 blkno,
+					struct ocfs2_super *osb)
+{
+	/* Dealloc lockreses don't come from a slab so we call init
+	 * once on it manually.  */
+	ocfs2_lock_res_init_once(res);
+	ocfs2_lock_res_init_common(osb, res, OCFS2_LOCK_TYPE_DEALLOC, blkno,
+					0, &ocfs2_dealloc_lops, osb);
+}
 void ocfs2_lock_res_free(struct ocfs2_lock_res *res)
 {
 	mlog_entry_void();
@@ -727,6 +753,36 @@ static void ocfs2_rename_bast_func(void 
 	mlog_exit_void();
 }
 
+static void ocfs2_dealloc_ast_func(void *opaque)
+{
+	struct ocfs2_lock_res *lockres = opaque;
+
+	mlog_entry_void();
+	mlog(0, "Dealloc AST fired\n");
+
+	BUG_ON(!ocfs2_is_dealloc_lock(lockres));
+
+	ocfs2_generic_ast_func(lockres, 1);
+	mlog_exit_void();
+}
+
+static void ocfs2_dealloc_bast_func(void *opaque,
+				   int level)
+{
+	struct ocfs2_lock_res *lockres = opaque;
+	struct ocfs2_super *osb;
+
+	mlog_entry_void();
+	mlog(0, "Dealloc BAST fired\n");
+
+	BUG_ON(!ocfs2_is_dealloc_lock(lockres));
+
+	osb = ocfs2_lock_res_super(lockres);
+	ocfs2_generic_bast_func(osb, lockres, level);
+
+	mlog_exit_void();
+}
+
 static inline void ocfs2_recover_from_dlm_error(struct ocfs2_lock_res *lockres,
 						int convert)
 {
@@ -1729,6 +1785,39 @@ void ocfs2_rename_unlock(struct ocfs2_su
 		ocfs2_cluster_unlock(osb, lockres, LKM_EXMODE);
 }
 
+/* protects reading/updating the same block
+ * all blocks go to OCFS2_DEALLOC_NR locks
+ */
+int ocfs2_dealloc_lock(struct ocfs2_super *osb, u64 blkno, int ex)
+{
+	int status;
+	int level = ex ? LKM_EXMODE : LKM_PRMODE;
+	struct ocfs2_lock_res *lockres;
+	
+	if (ocfs2_is_hard_readonly(osb))
+		return -EROFS;
+
+	if (ocfs2_mount_local(osb))
+		return 0;
+
+	lockres = &osb->osb_dealloc_lockres[blkno % OCFS2_DEALLOC_NR];
+	status = ocfs2_cluster_lock(osb, lockres, level, 0, NULL, 0);
+	if (status < 0)
+		mlog_errno(status);
+
+	return status;
+}
+
+void ocfs2_dealloc_unlock(struct ocfs2_super *osb, u64 blkno, int ex)
+{
+	struct ocfs2_lock_res *lockres;
+	int level = ex ? LKM_EXMODE : LKM_PRMODE;
+
+	lockres = &osb->osb_dealloc_lockres[blkno % OCFS2_DEALLOC_NR];
+	if (!ocfs2_mount_local(osb))
+		ocfs2_cluster_unlock(osb, lockres, level);
+}
+
 /* Reference counting of the dlm debug structure. We want this because
  * open references on the debug inodes can live on after a mount, so
  * we can't rely on the ocfs2_super to always exist. */
@@ -1989,6 +2078,7 @@ static void ocfs2_dlm_shutdown_debug(str
 int ocfs2_dlm_init(struct ocfs2_super *osb)
 {
 	int status;
+	int i;
 	u32 dlm_key;
 	struct dlm_ctxt *dlm = NULL;
 
@@ -2030,6 +2120,11 @@ int ocfs2_dlm_init(struct ocfs2_super *o
 local:
 	ocfs2_super_lock_res_init(&osb->osb_super_lockres, osb);
 	ocfs2_rename_lock_res_init(&osb->osb_rename_lockres, osb);
+	
+	for(i=0; i<OCFS2_DEALLOC_NR; i++) {
+		ocfs2_dealloc_lock_res_init(&osb->osb_dealloc_lockres[i],
+					    (u64)i, osb);
+	}
 
 	osb->dlm = dlm;
 
@@ -2047,6 +2142,8 @@ bail:
 
 void ocfs2_dlm_shutdown(struct ocfs2_super *osb)
 {
+	int i;
+
 	mlog_entry_void();
 
 	dlm_unregister_eviction_cb(&osb->osb_eviction_cb);
@@ -2060,6 +2157,9 @@ void ocfs2_dlm_shutdown(struct ocfs2_sup
 
 	ocfs2_lock_res_free(&osb->osb_super_lockres);
 	ocfs2_lock_res_free(&osb->osb_rename_lockres);
+	for(i=0; i<OCFS2_DEALLOC_NR; i++) {
+		ocfs2_lock_res_free(&osb->osb_dealloc_lockres[i]);
+	}
 
 	dlm_unregister_domain(osb->dlm);
 	osb->dlm = NULL;
@@ -2255,6 +2355,7 @@ void ocfs2_mark_lockres_freeing(struct o
 static void ocfs2_drop_osb_locks(struct ocfs2_super *osb)
 {
 	int status;
+	int i;
 
 	mlog_entry_void();
 
@@ -2269,7 +2370,15 @@ static void ocfs2_drop_osb_locks(struct 
 	status = ocfs2_drop_lock(osb, &osb->osb_rename_lockres, NULL);
 	if (status < 0)
 		mlog_errno(status);
-
+        
+	for(i=0; i<OCFS2_DEALLOC_NR; i++) {
+		ocfs2_mark_lockres_freeing(&osb->osb_dealloc_lockres[i]);
+		status = ocfs2_drop_lock(osb, &osb->osb_dealloc_lockres[i],
+					 NULL);
+		if (status < 0)
+			mlog_errno(status);
+        }
+	
 	mlog_exit(status);
 }
 
