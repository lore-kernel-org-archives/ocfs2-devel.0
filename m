From: wengang wang <wen.gang.wang@oracle.com>
Date: Thu,  5 Mar 2009 12:21:46 +0800
Subject: [Ocfs2-devel] [PATCH 1/1] OCFS2: anti stale inode for nfs (V6.2)
Message-ID: <200903050422.n254Mmi7029700@rgminet15.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

#against V6, corrects some format problem pointed out by checkpatch.pl.

For nfs exporting, ocfs2_get_dentry() returns the dentry for fh.
ocfs2_get_dentry() may read from disk(when inode not in memory) without
any cross cluster lock. this leads to load a stale inode.

this patch fixes above problem.
solution is that in case of inode is not in memory, we get the cluster lock(PR)
of alloc inode where the inode in question is allocated from(this causes node
on which deletion is done sync the alloc inode) before reading out the inode
its self. then we check the bitmap in the group(the inode in question
allcated from) to see if the bit is clear. if it's clear then it's stale.
if the bit is set, we then check generation as the existing code does.

actually we have to read out the inode in question from disk(not cache) first
to know its alloc slot(tells alloc inode) and allot bit(tells alloc group). and
if its not stale(by above logic) we read it out using ocfs2_iget(). the second
read should from cache.

and also we have to add a per superblock nfs_sync_lock to cover the lock for
alloc inode and that for inode in question. this is because ocfs2_get_dentry()
and ocfs2_delete_inode() lock on them in reverse order. nfs_sync_lock is locked
in EX mode in ocfs2_get_dentry() and in PR mode in ocfs2_delete_inode(). so
that mutliple ocfs2_delete_inode() can run concurrently in normal case.

Signed-off-by: Wengang Wang <wen.gang.wang@oracle.com>
--
diff --git a/fs/ocfs2/dlmglue.c b/fs/ocfs2/dlmglue.c
index 206a237..740b19b 100644
--- a/fs/ocfs2/dlmglue.c
+++ b/fs/ocfs2/dlmglue.c
@@ -244,6 +244,10 @@ static struct ocfs2_lock_res_ops ocfs2_rename_lops = {
 	.flags		= 0,
 };
 
+static struct ocfs2_lock_res_ops ocfs2_nfs_sync_lops = {
+	.flags		= 0,
+};
+
 static struct ocfs2_lock_res_ops ocfs2_dentry_lops = {
 	.get_osb	= ocfs2_get_dentry_osb,
 	.post_unlock	= ocfs2_dentry_post_unlock,
@@ -617,6 +621,17 @@ static void ocfs2_rename_lock_res_init(struct ocfs2_lock_res *res,
 				   &ocfs2_rename_lops, osb);
 }
 
+static void ocfs2_nfs_sync_lock_res_init(struct ocfs2_lock_res *res,
+					 struct ocfs2_super *osb)
+{
+	/* nfs_sync lockres doesn't come from a slab so we call init
+	 * once on it manually.  */
+	ocfs2_lock_res_init_once(res);
+	ocfs2_build_lock_name(OCFS2_LOCK_TYPE_NFS_SYNC, 0, 0, res->l_name);
+	ocfs2_lock_res_init_common(osb, res, OCFS2_LOCK_TYPE_NFS_SYNC,
+				   &ocfs2_nfs_sync_lops, osb);
+}
+
 void ocfs2_file_lock_res_init(struct ocfs2_lock_res *lockres,
 			      struct ocfs2_file_private *fp)
 {
@@ -2412,6 +2427,34 @@ void ocfs2_rename_unlock(struct ocfs2_super *osb)
 		ocfs2_cluster_unlock(osb, lockres, DLM_LOCK_EX);
 }
 
+int ocfs2_nfs_sync_lock(struct ocfs2_super *osb, int ex)
+{
+	int status;
+	struct ocfs2_lock_res *lockres = &osb->osb_nfs_sync_lockres;
+
+	if (ocfs2_is_hard_readonly(osb))
+		return -EROFS;
+
+	if (ocfs2_mount_local(osb))
+		return 0;
+
+	status = ocfs2_cluster_lock(osb, lockres, ex ? LKM_EXMODE : LKM_PRMODE,
+				    0, 0);
+	if (status < 0)
+		mlog(ML_ERROR, "lock on nfs sync lock failed %d\n", status);
+
+	return status;
+}
+
+void ocfs2_nfs_sync_unlock(struct ocfs2_super *osb, int ex)
+{
+	struct ocfs2_lock_res *lockres = &osb->osb_nfs_sync_lockres;
+
+	if (!ocfs2_mount_local(osb))
+		ocfs2_cluster_unlock(osb, lockres,
+				     ex ? LKM_EXMODE : LKM_PRMODE);
+}
+
 int ocfs2_dentry_lock(struct dentry *dentry, int ex)
 {
 	int ret;
@@ -2793,6 +2836,7 @@ int ocfs2_dlm_init(struct ocfs2_super *osb)
 local:
 	ocfs2_super_lock_res_init(&osb->osb_super_lockres, osb);
 	ocfs2_rename_lock_res_init(&osb->osb_rename_lockres, osb);
+	ocfs2_nfs_sync_lock_res_init(&osb->osb_nfs_sync_lockres, osb);
 
 	osb->cconn = conn;
 
@@ -2828,6 +2872,7 @@ void ocfs2_dlm_shutdown(struct ocfs2_super *osb,
 
 	ocfs2_lock_res_free(&osb->osb_super_lockres);
 	ocfs2_lock_res_free(&osb->osb_rename_lockres);
+	ocfs2_lock_res_free(&osb->osb_nfs_sync_lockres);
 
 	ocfs2_cluster_disconnect(osb->cconn, hangup_pending);
 	osb->cconn = NULL;
@@ -3010,6 +3055,7 @@ static void ocfs2_drop_osb_locks(struct ocfs2_super *osb)
 {
 	ocfs2_simple_drop_lockres(osb, &osb->osb_super_lockres);
 	ocfs2_simple_drop_lockres(osb, &osb->osb_rename_lockres);
+	ocfs2_simple_drop_lockres(osb, &osb->osb_nfs_sync_lockres);
 }
 
 int ocfs2_drop_inode_locks(struct inode *inode)
diff --git a/fs/ocfs2/dlmglue.h b/fs/ocfs2/dlmglue.h
index 3f8d998..e1fd572 100644
--- a/fs/ocfs2/dlmglue.h
+++ b/fs/ocfs2/dlmglue.h
@@ -115,6 +115,8 @@ void ocfs2_super_unlock(struct ocfs2_super *osb,
 			int ex);
 int ocfs2_rename_lock(struct ocfs2_super *osb);
 void ocfs2_rename_unlock(struct ocfs2_super *osb);
+int ocfs2_nfs_sync_lock(struct ocfs2_super *osb, int ex);
+void ocfs2_nfs_sync_unlock(struct ocfs2_super *osb, int ex);
 int ocfs2_dentry_lock(struct dentry *dentry, int ex);
 void ocfs2_dentry_unlock(struct dentry *dentry, int ex);
 int ocfs2_file_lock(struct file *file, int ex, int trylock);
diff --git a/fs/ocfs2/export.c b/fs/ocfs2/export.c
index 2f27b33..e28ff06 100644
--- a/fs/ocfs2/export.c
+++ b/fs/ocfs2/export.c
@@ -38,6 +38,7 @@
 #include "inode.h"
 
 #include "buffer_head_io.h"
+#include "suballoc.h"
 
 struct ocfs2_inode_handle
 {
@@ -49,29 +50,88 @@ static struct dentry *ocfs2_get_dentry(struct super_block *sb,
 		struct ocfs2_inode_handle *handle)
 {
 	struct inode *inode;
+	struct ocfs2_super *osb = OCFS2_SB(sb);
+	u64 blkno = handle->ih_blkno;
+	int status, set;
 	struct dentry *result;
 
 	mlog_entry("(0x%p, 0x%p)\n", sb, handle);
 
-	if (handle->ih_blkno == 0) {
-		mlog_errno(-ESTALE);
-		return ERR_PTR(-ESTALE);
+	if (blkno == 0) {
+		mlog(0, "nfs wants inode with blkno: 0\n");
+		result = ERR_PTR(-ESTALE);
+		goto bail;
+	}
+
+	inode = ocfs2_ilookup(sb, blkno);
+	/* found in-memory inode, goes to check generation */
+	if (inode)
+		goto check_gen;
+
+	/* takes nfs_sync_lock in EX mode */
+	status = ocfs2_nfs_sync_lock(osb, 1);
+	if (status < 0) {
+		mlog(ML_ERROR, "getting nfs sync lock(EX) failed %d\n", status);
+		goto check_err;
+	}
+
+	status = ocfs2_test_inode_bit(osb, blkno, &set);
+	if (status < 0) {
+		if (status == -EINVAL) {
+			/* meta block never be re-allocated as data block.
+			 * nfs gives us wrong blkno, we return ESTALE though */
+			mlog(0, "test inode bit failed %d\n", status);
+			status = -ESTALE;
+		} else {
+			mlog(ML_ERROR, "test inode bit failed %d\n", status);
+		}
+		goto unlock_nfs_sync;
+	}
+
+	/* allocate bit is clear, inode is a stale inode */
+	if (!set) {
+		mlog(0, "inode %llu suballoc bit is clear\n", blkno);
+		status = -ESTALE;
+		goto unlock_nfs_sync;
 	}
 
-	inode = ocfs2_iget(OCFS2_SB(sb), handle->ih_blkno, 0, 0);
+	inode = ocfs2_iget(osb, blkno, 0, 0);
 
-	if (IS_ERR(inode))
-		return (void *)inode;
+unlock_nfs_sync:
+	ocfs2_nfs_sync_unlock(osb, 1);
 
+check_err:
+	if (status < 0) {
+		if (status == -ESTALE) {
+			mlog(0, "stale inode ino: %llu generation: %u\n",
+			     blkno, handle->ih_generation);
+		}
+		result = ERR_PTR(status);
+		goto bail;
+	}
+
+	if (IS_ERR(inode)) {
+		mlog_errno(PTR_ERR(inode));
+		result = (void *)inode;
+		goto bail;
+	}
+
+check_gen:
 	if (handle->ih_generation != inode->i_generation) {
 		iput(inode);
-		return ERR_PTR(-ESTALE);
+		mlog(0, "stale inode ino: %llu generation: %u\n", blkno,
+		     handle->ih_generation);
+		result = ERR_PTR(-ESTALE);
+		goto bail;
 	}
 
 	result = d_obtain_alias(inode);
 	if (!IS_ERR(result))
 		result->d_op = &ocfs2_dentry_ops;
+	else
+		mlog_errno(PTR_ERR(result));
 
+bail:
 	mlog_exit_ptr(result);
 	return result;
 }
diff --git a/fs/ocfs2/inode.c b/fs/ocfs2/inode.c
index 229e707..84f7a60 100644
--- a/fs/ocfs2/inode.c
+++ b/fs/ocfs2/inode.c
@@ -112,6 +112,17 @@ void ocfs2_get_inode_flags(struct ocfs2_inode_info *oi)
 		oi->ip_attr |= OCFS2_DIRSYNC_FL;
 }
 
+struct inode *ocfs2_ilookup(struct super_block *sb, u64 blkno)
+{
+	struct ocfs2_find_inode_args args;
+
+	args.fi_blkno = blkno;
+	args.fi_flags = 0;
+	args.fi_ino = ino_from_blkno(sb, blkno);
+	args.fi_sysfile_type = 0;
+
+	return ilookup5(sb, blkno, ocfs2_find_actor, &args);
+}
 struct inode *ocfs2_iget(struct ocfs2_super *osb, u64 blkno, unsigned flags,
 			 int sysfile_type)
 {
@@ -949,6 +960,13 @@ void ocfs2_delete_inode(struct inode *inode)
 		goto bail;
 	}
 
+	/* Lock down the nfs_sync lock in PR mode */
+	status = ocfs2_nfs_sync_lock(OCFS2_SB(inode->i_sb), 0);
+	if (status < 0) {
+		mlog(ML_ERROR, "getting nfs sync lock(PR) failed %d\n", status);
+		ocfs2_cleanup_delete_inode(inode, 0);
+		goto bail_unblock;
+	}
 	/* Lock down the inode. This gives us an up to date view of
 	 * it's metadata (for verification), and allows us to
 	 * serialize delete_inode on multiple nodes.
@@ -962,7 +980,7 @@ void ocfs2_delete_inode(struct inode *inode)
 		if (status != -ENOENT)
 			mlog_errno(status);
 		ocfs2_cleanup_delete_inode(inode, 0);
-		goto bail_unblock;
+		goto bail_unlock_nfs_sync;
 	}
 
 	/* Query the cluster. This will be the final decision made
@@ -1005,6 +1023,10 @@ void ocfs2_delete_inode(struct inode *inode)
 bail_unlock_inode:
 	ocfs2_inode_unlock(inode, 1);
 	brelse(di_bh);
+
+bail_unlock_nfs_sync:
+	ocfs2_nfs_sync_unlock(OCFS2_SB(inode->i_sb), 0);
+
 bail_unblock:
 	status = sigprocmask(SIG_SETMASK, &oldset, NULL);
 	if (status < 0)
diff --git a/fs/ocfs2/inode.h b/fs/ocfs2/inode.h
index eb3c302..1c543f0 100644
--- a/fs/ocfs2/inode.h
+++ b/fs/ocfs2/inode.h
@@ -124,6 +124,7 @@ void ocfs2_drop_inode(struct inode *inode);
 /* Flags for ocfs2_iget() */
 #define OCFS2_FI_FLAG_SYSFILE		0x1
 #define OCFS2_FI_FLAG_ORPHAN_RECOVERY	0x2
+struct inode *ocfs2_ilookup(struct super_block *sb, u64 feoff);
 struct inode *ocfs2_iget(struct ocfs2_super *osb, u64 feoff, unsigned flags,
 			 int sysfile_type);
 int ocfs2_inode_init_private(struct inode *inode);
diff --git a/fs/ocfs2/ocfs2.h b/fs/ocfs2/ocfs2.h
index 0773841..8e7b15d 100644
--- a/fs/ocfs2/ocfs2.h
+++ b/fs/ocfs2/ocfs2.h
@@ -305,6 +305,7 @@ struct ocfs2_super
 	struct ocfs2_cluster_connection *cconn;
 	struct ocfs2_lock_res osb_super_lockres;
 	struct ocfs2_lock_res osb_rename_lockres;
+	struct ocfs2_lock_res osb_nfs_sync_lockres;
 	struct ocfs2_dlm_debug *osb_dlm_debug;
 
 	struct dentry *osb_debug_root;
diff --git a/fs/ocfs2/ocfs2_lockid.h b/fs/ocfs2/ocfs2_lockid.h
index eb6f50c..a53ce87 100644
--- a/fs/ocfs2/ocfs2_lockid.h
+++ b/fs/ocfs2/ocfs2_lockid.h
@@ -47,6 +47,7 @@ enum ocfs2_lock_type {
 	OCFS2_LOCK_TYPE_OPEN,
 	OCFS2_LOCK_TYPE_FLOCK,
 	OCFS2_LOCK_TYPE_QINFO,
+	OCFS2_LOCK_TYPE_NFS_SYNC,
 	OCFS2_NUM_LOCK_TYPES
 };
 
@@ -81,6 +82,9 @@ static inline char ocfs2_lock_type_char(enum ocfs2_lock_type type)
 		case OCFS2_LOCK_TYPE_QINFO:
 			c = 'Q';
 			break;
+		case OCFS2_LOCK_TYPE_NFS_SYNC:
+			c = 'Y';
+			break;
 		default:
 			c = '\0';
 	}
diff --git a/fs/ocfs2/suballoc.c b/fs/ocfs2/suballoc.c
index a696286..ce0fbc9 100644
--- a/fs/ocfs2/suballoc.c
+++ b/fs/ocfs2/suballoc.c
@@ -2116,3 +2116,155 @@ out:
 
 	return ret;
 }
+
+/* reads(hit disk) the inode specified by blkno to get suballoc_slot
+ * and suballoc_bit
+ * */
+static int ocfs2_get_suballoc_slot_bit(struct ocfs2_super *osb, u64 blkno,
+				u16 *suballoc_slot, u16 *suballoc_bit)
+{
+	int status;
+	struct buffer_head *inode_bh = NULL;
+	struct ocfs2_dinode *inode_fe;
+
+	mlog_entry("blkno: %llu\n", blkno);
+
+	/* dirty read disk */
+	status = ocfs2_read_blocks_sync(osb, blkno, 1, &inode_bh);
+	if (status < 0) {
+		mlog(ML_ERROR, "read block %llu failed %d\n", blkno, status);
+		goto bail;
+	}
+
+	inode_fe = (struct ocfs2_dinode *) inode_bh->b_data;
+	if (!OCFS2_IS_VALID_DINODE(inode_fe)) {
+		mlog(ML_ERROR, "invalid inode %llu requested\n", blkno);
+		status = -EINVAL;
+		goto bail;
+	}
+
+	if (le16_to_cpu(inode_fe->i_suballoc_slot) != OCFS2_INVALID_SLOT &&
+	    (u32)le16_to_cpu(inode_fe->i_suballoc_slot) > osb->max_slots - 1) {
+		mlog(ML_ERROR, "inode %llu has invalid suballoc slot %u\n",
+		     blkno, (u32)le16_to_cpu(inode_fe->i_suballoc_slot));
+		status = -EINVAL;
+		goto bail;
+	}
+	if (suballoc_slot)
+		*suballoc_slot = le16_to_cpu(inode_fe->i_suballoc_slot);
+	if (suballoc_bit)
+		*suballoc_bit = le16_to_cpu(inode_fe->i_suballoc_bit);
+
+bail:
+	brelse(inode_bh);
+
+	mlog_exit(status);
+	return status;
+}
+
+/* test whether bit is SET in allocator bitmap or not.
+ * on success, 0 is returned and *res is 1 for SET; 0 otherwise.
+ * when fails, errno is returned and *res is meaningless.
+ * calls this after you have cluster locked against suballoc, or you may
+ * get a result based on non-up2date contents
+ * */
+static int ocfs2_test_suballoc_bit(struct ocfs2_super *osb,
+				   struct inode *suballoc,
+				   struct buffer_head *alloc_bh, u64 blkno,
+				   u16 bit, int *res)
+{
+	struct ocfs2_dinode *alloc_fe;
+	struct ocfs2_group_desc *group;
+	struct buffer_head *group_bh = NULL;
+	u64 bg_blkno;
+	int status;
+
+	mlog_entry("blkno: %llu bit: %u\n", blkno, (unsigned int)bit);
+
+	alloc_fe = (struct ocfs2_dinode *)alloc_bh->b_data;
+	if ((bit + 1) > ocfs2_bits_per_group(&alloc_fe->id2.i_chain)) {
+		mlog(ML_ERROR, "suballoc bit %u out of range of %u\n",
+		     (unsigned int)bit,
+		     ocfs2_bits_per_group(&alloc_fe->id2.i_chain));
+		status = -EINVAL;
+		goto bail;
+	}
+
+	bg_blkno = ocfs2_which_suballoc_group(blkno, bit);
+	status = ocfs2_read_group_descriptor(suballoc, alloc_fe, bg_blkno,
+					     &group_bh);
+	if (status < 0) {
+		mlog(ML_ERROR, "read group %llu failed %d\n", bg_blkno, status);
+		goto bail;
+	}
+
+	group = (struct ocfs2_group_desc *) group_bh->b_data;
+	*res = ocfs2_test_bit(bit, (unsigned long *)group->bg_bitmap);
+
+bail:
+	brelse(group_bh);
+
+	mlog_exit(status);
+	return status;
+}
+
+/* test if the bit, which is for the inode specified by blkno, in suballoc is
+ * set or not.
+ * on success, 0 is returned and *res is 1 for SET; 0 otherwise.
+ * when fails, errno is returned and *res is meaningless.
+ * MAKE SURE to hold nfs_sync_lock to revent ocfs2_delete_inode() on another
+ * node from accessing the same suballoc concurrently.
+ * */
+int ocfs2_test_inode_bit(struct ocfs2_super *osb, u64 blkno, int *res)
+{
+	int status;
+	u16 suballoc_bit = 0, suballoc_slot = 0;
+	struct inode *inode_alloc_inode;
+	struct buffer_head *alloc_bh = NULL;
+
+	/* MAKE SURE nfs_sync_lock is held */
+
+	mlog_entry("blkno: %llu", blkno);
+
+	status = ocfs2_get_suballoc_slot_bit(osb, blkno, &suballoc_slot,
+					     &suballoc_bit);
+	if (status < 0) {
+		mlog(ML_ERROR, "get alloc slot and bit failed %d\n", status);
+		goto bail;
+	}
+
+	inode_alloc_inode =
+		ocfs2_get_system_file_inode(osb, INODE_ALLOC_SYSTEM_INODE,
+					    suballoc_slot);
+	if (!inode_alloc_inode) {
+		/* the error code could be inaccurate, but we are not able to
+		 * get the correct one. */
+		status = -EINVAL;
+		mlog(ML_ERROR, "unable to get alloc inode in slot %u\n",
+		     (u32)suballoc_slot);
+		goto bail;
+	}
+
+	mutex_lock(&inode_alloc_inode->i_mutex);
+	status = ocfs2_inode_lock(inode_alloc_inode, &alloc_bh, 0);
+	if (status < 0) {
+		mutex_unlock(&inode_alloc_inode->i_mutex);
+		mlog(ML_ERROR, "lock on alloc inode on slot %u failed %d\n",
+		     (u32)suballoc_slot, status);
+		goto bail;
+	}
+
+	status = ocfs2_test_suballoc_bit(osb, inode_alloc_inode, alloc_bh,
+					 blkno, suballoc_bit, res);
+	if (status < 0)
+		mlog(ML_ERROR, "test suballoc bit failed %d\n", status);
+
+	ocfs2_inode_unlock(inode_alloc_inode, 0);
+	mutex_unlock(&inode_alloc_inode->i_mutex);
+
+	iput(inode_alloc_inode);
+	brelse(alloc_bh);
+bail:
+	mlog_exit(status);
+	return status;
+}
diff --git a/fs/ocfs2/suballoc.h b/fs/ocfs2/suballoc.h
index e3c13c7..62d1f94 100644
--- a/fs/ocfs2/suballoc.h
+++ b/fs/ocfs2/suballoc.h
@@ -186,4 +186,6 @@ int ocfs2_lock_allocators(struct inode *inode, struct ocfs2_extent_tree *et,
 			  u32 clusters_to_add, u32 extents_to_split,
 			  struct ocfs2_alloc_context **data_ac,
 			  struct ocfs2_alloc_context **meta_ac);
+
+int ocfs2_test_inode_bit(struct ocfs2_super *osb, u64 blkno, int *res);
 #endif /* _CHAINALLOC_H_ */
