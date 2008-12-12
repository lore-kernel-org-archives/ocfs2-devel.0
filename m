From: wengang wang <wen.gang.wang@oracle.com>
Date: Fri, 12 Dec 2008 17:00:44 +0800
Subject: [Ocfs2-devel] [PATCH 1/1] OCFS2: anti stale inode for nfs (V2).
Message-ID: <200812120900.mBC90imR012722@localhost.localdomain>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Changes from V1:
1) separate lines into sub-functions.
2) use mlog(0, .. instead of mlog(ML_NOTICE, .. for stale error.

#patch based on ocfs2 1.4 git.

Signed-off-by: Wengang Wang <wen.gang.wang@oracle.com>
--
 cluster/masklog.h |    2 -
 dlmglue.c         |   31 +++++++++------
 export.c          |   92 +++++++++++++++++++++++++++++++++++++++++-----
 inode.c           |  107 +++++++++++++++++++++++++++++++++++-------------------
 inode.h           |    1 
 suballoc.c        |   80 ++++++++++++++++++++++++++++++++++++++++
 suballoc.h        |    9 ++++
 7 files changed, 262 insertions(+), 60 deletions(-)

Index: fs/ocfs2/cluster/masklog.h
===================================================================
--- fs/ocfs2/cluster/masklog.h	(revision 38)
+++ fs/ocfs2/cluster/masklog.h	(working copy)
@@ -114,7 +114,7 @@
 #define ML_EXPORT	0x0000000010000000ULL /* ocfs2 export operations */
 /* bits that are infrequently given and frequently matched in the high word */
 #define ML_ERROR	0x0000000100000000ULL /* sent to KERN_ERR */
-#define ML_NOTICE	0x0000000200000000ULL /* setn to KERN_NOTICE */
+#define ML_NOTICE	0x0000000200000000ULL /* sent to KERN_NOTICE */
 #define ML_KTHREAD	0x0000000400000000ULL /* kernel thread activity */
 
 #define MLOG_INITIAL_AND_MASK (ML_ERROR|ML_NOTICE)
Index: fs/ocfs2/export.c
===================================================================
--- fs/ocfs2/export.c	(revision 38)
+++ fs/ocfs2/export.c	(working copy)
@@ -38,6 +38,8 @@
 #include "inode.h"
 
 #include "buffer_head_io.h"
+#include "sysfile.h"
+#include "suballoc.h"
 
 struct ocfs2_inode_handle
 {
@@ -48,24 +50,92 @@ struct ocfs2_inode_handle
 static struct dentry *ocfs2_get_dentry(struct super_block *sb, void *vobjp)
 {
 	struct ocfs2_inode_handle *handle = vobjp;
-	struct inode *inode;
+	struct ocfs2_super *osb = OCFS2_SB(sb);
 	struct dentry *result;
-
+	struct inode *inode, *inode_alloc_inode;
+	struct buffer_head *alloc_bh = NULL;
+	u64 blkno = handle->ih_blkno;
+	unsigned short suballoc_bit, suballoc_slot;
+	int status, set;
+	
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
+	inode = ocfs2_ilookup(sb, ino_from_blkno(sb, blkno));
+	/* found in-memory inode, goes to check generation */
+	if (inode)
+		goto check_gen;
+
+	status = ocfs2_get_suballoc_slot_bit(osb, blkno, &suballoc_slot,
+					     &suballoc_bit, 1);
+	if (status < 0) 
+		goto check_err;
+
+	inode_alloc_inode =
+		ocfs2_get_system_file_inode(osb, INODE_ALLOC_SYSTEM_INODE,
+					    suballoc_slot);
+	if (!inode_alloc_inode) {
+		status = -EEXIST;
+		goto check_err;
 	}
 
-	inode = ocfs2_iget(OCFS2_SB(sb), handle->ih_blkno, 0, 0);
+	mutex_lock(&inode_alloc_inode->i_mutex);
+	status = ocfs2_inode_lock(inode_alloc_inode, &alloc_bh, 0);
+	if (status < 0) 
+		goto unlock_mutex;
+
+	status = ocfs2_test_suballoc_bit(osb, inode_alloc_inode, alloc_bh,
+					 blkno, suballoc_bit, &set);
+	if (status < 0)
+		goto inode_unlock;
+
+	/* allocate bit is clear, inode is a stale inode */
+	if (!set) {
+		status = -ESTALE;
+		goto inode_unlock;
+	}
+
+	inode = ocfs2_iget(OCFS2_SB(sb), blkno, 0, 0);
+
+inode_unlock:
+	ocfs2_inode_unlock(inode_alloc_inode, 0);
+unlock_mutex:
+	mutex_unlock(&inode_alloc_inode->i_mutex);
+	iput(inode_alloc_inode);
+	brelse(alloc_bh);
+
+check_err:
+
+	if (status < 0) {
+		if (status == -ESTALE) {
+			mlog(0, "stale inode ino: %llu generation: %u\n",
+			     blkno, handle->ih_generation);
+		} else {
+			mlog_errno(status);
+		}
 
-	if (IS_ERR(inode))
-		return (void *)inode;
+		result = ERR_PTR(status);
+		goto bail;
+	}
 
+	if (IS_ERR(inode)) {
+		mlog_errno((int)inode);
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
 
 	result = d_alloc_anon(inode);
@@ -73,10 +143,12 @@ static struct dentry *ocfs2_get_dentry(s
 	if (!result) {
 		iput(inode);
 		mlog_errno(-ENOMEM);
-		return ERR_PTR(-ENOMEM);
+		result = ERR_PTR(-ENOMEM);
+		goto bail;
 	}
 	result->d_op = &ocfs2_dentry_ops;
 
+bail:
 	mlog_exit_ptr(result);
 	return result;
 }
Index: fs/ocfs2/inode.c
===================================================================
--- fs/ocfs2/inode.c	(revision 38)
+++ fs/ocfs2/inode.c	(working copy)
@@ -111,6 +111,17 @@ void ocfs2_get_inode_flags(struct ocfs2_
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
@@ -571,41 +582,26 @@ out:
 	return status;
 }
 
-static int ocfs2_remove_inode(struct inode *inode,
+/* callers must have cluster lock inode_alloc_inode taken before calling
+ * ocfs2_remove_inode
+ * */
+static int ocfs2_remove_inode(struct inode *inode_alloc_inode,
+			      struct buffer_head *suballoc_bh,
+			      struct inode *inode,
 			      struct buffer_head *di_bh,
 			      struct inode *orphan_dir_inode,
 			      struct buffer_head *orphan_dir_bh)
 {
 	int status;
-	struct inode *inode_alloc_inode = NULL;
-	struct buffer_head *inode_alloc_bh = NULL;
 	handle_t *handle;
 	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
 	struct ocfs2_dinode *di = (struct ocfs2_dinode *) di_bh->b_data;
 
-	inode_alloc_inode =
-		ocfs2_get_system_file_inode(osb, INODE_ALLOC_SYSTEM_INODE,
-					    le16_to_cpu(di->i_suballoc_slot));
-	if (!inode_alloc_inode) {
-		status = -EEXIST;
-		mlog_errno(status);
-		goto bail;
-	}
-
-	mutex_lock(&inode_alloc_inode->i_mutex);
-	status = ocfs2_inode_lock(inode_alloc_inode, &inode_alloc_bh, 1);
-	if (status < 0) {
-		mutex_unlock(&inode_alloc_inode->i_mutex);
-
-		mlog_errno(status);
-		goto bail;
-	}
-
 	handle = ocfs2_start_trans(osb, OCFS2_DELETE_INODE_CREDITS);
 	if (IS_ERR(handle)) {
 		status = PTR_ERR(handle);
 		mlog_errno(status);
-		goto bail_unlock;
+		goto bail;
 	}
 
 	status = ocfs2_orphan_del(osb, handle, orphan_dir_inode, inode,
@@ -635,19 +631,13 @@ static int ocfs2_remove_inode(struct ino
 	ocfs2_remove_from_cache(inode, di_bh);
 
 	status = ocfs2_free_dinode(handle, inode_alloc_inode,
-				   inode_alloc_bh, di);
+				   suballoc_bh, di);
 	if (status < 0)
 		mlog_errno(status);
 
 bail_commit:
 	ocfs2_commit_trans(osb, handle);
-bail_unlock:
-	ocfs2_inode_unlock(inode_alloc_inode, 1);
-	mutex_unlock(&inode_alloc_inode->i_mutex);
-	brelse(inode_alloc_bh);
 bail:
-	iput(inode_alloc_inode);
-
 	return status;
 }
 
@@ -687,7 +677,9 @@ static void ocfs2_signal_wipe_completion
 	wake_up(&osb->osb_wipe_event);
 }
 
-static int ocfs2_wipe_inode(struct inode *inode,
+static int ocfs2_wipe_inode(struct inode *inode_alloc_inode,
+			    struct buffer_head *suballoc_bh,
+			    struct inode *inode,
 			    struct buffer_head *di_bh)
 {
 	int status, orphaned_slot;
@@ -734,8 +726,8 @@ static int ocfs2_wipe_inode(struct inode
 		goto bail_unlock_dir;
 	}
 
-	status = ocfs2_remove_inode(inode, di_bh, orphan_dir_inode,
-				    orphan_dir_bh);
+	status = ocfs2_remove_inode(inode_alloc_inode, suballoc_bh, inode,
+				    di_bh, orphan_dir_inode, orphan_dir_bh);
 	if (status < 0)
 		mlog_errno(status);
 
@@ -904,7 +896,9 @@ void ocfs2_delete_inode(struct inode *in
 {
 	int wipe, status;
 	sigset_t blocked, oldset;
-	struct buffer_head *di_bh = NULL;
+	struct buffer_head *di_bh = NULL, *suballoc_bh = NULL;
+	struct inode *inode_alloc_inode = NULL;
+	unsigned short suballoc_slot;
 
 	mlog_entry("(inode->i_ino = %lu)\n", inode->i_ino);
 
@@ -933,6 +927,40 @@ void ocfs2_delete_inode(struct inode *in
 		goto bail;
 	}
 
+	/* lock the suballoc inode first before locking against inode
+	 * its self 
+	 * */
+
+	/* here we don't have cluster locked against inode, so we may
+	 * reads out non-up2date contents.
+	 * but because suballoc_slot never changes, reading out non-up2date
+	 * contents is no problem.
+	 * */
+	status = ocfs2_get_suballoc_slot_bit(OCFS2_SB(inode->i_sb),
+					     OCFS2_I(inode)->ip_blkno,
+					     &suballoc_slot, NULL, 0);
+	if (status < 0) {
+		mlog_errno(status);
+		goto bail_sigmask;
+	}
+
+	inode_alloc_inode =
+		ocfs2_get_system_file_inode(OCFS2_SB(inode->i_sb),
+					    INODE_ALLOC_SYSTEM_INODE,
+					    suballoc_slot);
+	if (!inode_alloc_inode) {
+		status = -EEXIST;
+		mlog_errno(status);
+		goto bail_sigmask;
+	}
+	
+	mutex_lock(&inode_alloc_inode->i_mutex);
+	status = ocfs2_inode_lock(inode_alloc_inode, &suballoc_bh, 1);
+	if (status < 0) {
+		mlog_errno(status);
+		goto bail_mutex;
+	}
+
 	/* Lock down the inode. This gives us an up to date view of
 	 * it's metadata (for verification), and allows us to
 	 * serialize delete_inode on multiple nodes.
@@ -946,7 +974,7 @@ void ocfs2_delete_inode(struct inode *in
 		if (status != -ENOENT)
 			mlog_errno(status);
 		ocfs2_cleanup_delete_inode(inode, 0);
-		goto bail_unblock;
+		goto bail_unlock_alloc_inode;
 	}
 
 	/* Query the cluster. This will be the final decision made
@@ -968,7 +996,8 @@ void ocfs2_delete_inode(struct inode *in
 
 	ocfs2_cleanup_delete_inode(inode, 0);
 
-	status = ocfs2_wipe_inode(inode, di_bh);
+	status = ocfs2_wipe_inode(inode_alloc_inode, suballoc_bh, inode,
+				  di_bh);
 	if (status < 0) {
 		if (status != -EDEADLK)
 			mlog_errno(status);
@@ -989,7 +1018,13 @@ void ocfs2_delete_inode(struct inode *in
 bail_unlock_inode:
 	ocfs2_inode_unlock(inode, 1);
 	brelse(di_bh);
-bail_unblock:
+bail_unlock_alloc_inode:
+	ocfs2_inode_unlock(inode_alloc_inode, 1);
+	brelse(suballoc_bh);
+bail_mutex:
+	mutex_unlock(&inode_alloc_inode->i_mutex);
+	iput(inode_alloc_inode);
+bail_sigmask:
 	status = sigprocmask(SIG_SETMASK, &oldset, NULL);
 	if (status < 0)
 		mlog_errno(status);
Index: fs/ocfs2/suballoc.c
===================================================================
--- fs/ocfs2/suballoc.c	(revision 38)
+++ fs/ocfs2/suballoc.c	(working copy)
@@ -1891,3 +1891,83 @@ static inline void ocfs2_debug_suballoc_
 		       (unsigned long long)fe->id2.i_chain.cl_recs[i].c_blkno);
 	}
 }
+
+/* reads(hit disk when dirty_read is true) the inode specified by blkno to get
+ * suballoc_slot and suballoc_bit
+ * */
+int ocfs2_get_suballoc_slot_bit(struct ocfs2_super *osb, u64 blkno,
+				unsigned short *suballoc_slot,
+				unsigned short *suballoc_bit,
+				int dirty_read)
+{
+	int status;
+	struct buffer_head *inode_bh = NULL;
+	struct ocfs2_dinode *inode_fe;
+	int flags = 0;
+
+	mlog_entry("blkno: %llu\n", blkno);
+	if (!dirty_read)
+		flags |= OCFS2_BH_CACHED;
+	status = ocfs2_read_block(osb, blkno, &inode_bh, flags, NULL);
+	if (status < 0)
+		goto bail;
+
+	inode_fe = (struct ocfs2_dinode *) inode_bh->b_data;
+	if (!OCFS2_IS_VALID_DINODE(inode_fe)) {
+		status = -EINVAL;
+		goto bail;
+	}
+
+	if (suballoc_slot)
+		*suballoc_slot = le16_to_cpu(inode_fe->i_suballoc_slot);
+	if (suballoc_bit)
+		*suballoc_bit= le16_to_cpu(inode_fe->i_suballoc_bit);
+
+bail:
+	brelse(inode_bh);
+
+	mlog_exit(status);
+	return status;
+}
+
+/* test bit bit is SET in allocator bitmap or not.
+ * on success, 0 is returned and *res is 1 for SET; 0 otherwise.
+ * when fails, errno is returned and *res is meaningless.
+ * calls this after you have cluster locked against suballoc, or you may
+ * get a result based on non-up2date contents
+ * */
+int ocfs2_test_suballoc_bit(struct ocfs2_super *osb, struct inode *suballoc,
+			    struct buffer_head *alloc_bh, u64 blkno,
+			    unsigned short bit, int *res)
+{
+	struct ocfs2_dinode *alloc_fe;
+	struct ocfs2_group_desc *group;
+	struct buffer_head *group_bh = NULL;
+	u64 bg_blkno;
+	int status;
+
+	mlog_entry("blkno: %llu bit: %u\n", blkno, (unsigned int)bit);
+	BUG_ON(!res);
+
+	alloc_fe = (struct ocfs2_dinode *)alloc_bh->b_data;
+	BUG_ON((bit + 1) >
+			ocfs2_bits_per_group(&alloc_fe->id2.i_chain));
+
+	bg_blkno = ocfs2_which_suballoc_group(blkno, bit);
+	status = ocfs2_read_block(osb, bg_blkno, &group_bh, OCFS2_BH_CACHED,
+				  suballoc);
+	if (status < 0)
+		goto bail;
+
+	group = (struct ocfs2_group_desc *) group_bh->b_data;
+	status = ocfs2_check_group_descriptor(osb->sb, alloc_fe, group);
+	if (status < 0)
+		goto bail;
+
+	*res = ocfs2_test_bit(bit, (unsigned long *)group->bg_bitmap);
+bail:
+	brelse(group_bh);
+
+	mlog_exit(status);
+	return status;
+}
Index: fs/ocfs2/suballoc.h
===================================================================
--- fs/ocfs2/suballoc.h	(revision 38)
+++ fs/ocfs2/suballoc.h	(working copy)
@@ -156,4 +156,13 @@ u64 ocfs2_which_cluster_group(struct ino
 int ocfs2_check_group_descriptor(struct super_block *sb,
 				 struct ocfs2_dinode *di,
 				 struct ocfs2_group_desc *gd);
+
+int ocfs2_get_suballoc_slot_bit(struct ocfs2_super *osb, u64 blkno,
+				unsigned short *suballoc_slot,
+				unsigned short *suballoc_bit,
+				int dirty_read);
+
+int ocfs2_test_suballoc_bit(struct ocfs2_super *osb, struct inode *suballoc,
+			    struct buffer_head *alloc_bh, u64 blkno,
+			    unsigned short bit, int *res);
 #endif /* _CHAINALLOC_H_ */
Index: fs/ocfs2/dlmglue.c
===================================================================
--- fs/ocfs2/dlmglue.c	(revision 38)
+++ fs/ocfs2/dlmglue.c	(working copy)
@@ -1940,19 +1940,24 @@ static int ocfs2_inode_lock_update(struc
 			status = -EIO;
 			goto bail_refresh;
 		}
-		mlog_bug_on_msg(inode->i_generation !=
-				le32_to_cpu(fe->i_generation),
-				"Invalid dinode %llu disk generation: %u "
-				"inode->i_generation: %u\n",
-				(unsigned long long)oi->ip_blkno,
-				le32_to_cpu(fe->i_generation),
-				inode->i_generation);
-		mlog_bug_on_msg(le64_to_cpu(fe->i_dtime) ||
-				!(fe->i_flags & cpu_to_le32(OCFS2_VALID_FL)),
-				"Stale dinode %llu dtime: %llu flags: 0x%x\n",
-				(unsigned long long)oi->ip_blkno,
-				(unsigned long long)le64_to_cpu(fe->i_dtime),
-				le32_to_cpu(fe->i_flags));
+		if (inode->i_generation != le32_to_cpu(fe->i_generation)) {
+			mlog(0, "Stale inode %llu disk generation: %u "
+			     "inode generation: %u\n",
+			     (unsigned long long)oi->ip_blkno,
+			     le32_to_cpu(fe->i_generation),
+			     inode->i_generation);
+			status = -ESTALE;
+			goto bail_refresh;
+		}
+		if (le64_to_cpu(fe->i_dtime) ||
+		    !(fe->i_flags & cpu_to_le32(OCFS2_VALID_FL))) {
+			mlog(0, "Stale inode %llu dtime: %llu flags: 0x%x\n",
+			     (unsigned long long)oi->ip_blkno,
+			     (unsigned long long)le64_to_cpu(fe->i_dtime),
+			     le32_to_cpu(fe->i_flags));
+			status = -ESTALE;
+			goto bail_refresh;
+		}
 
 		ocfs2_refresh_inode(inode, fe);
 		ocfs2_track_lock_refresh(lockres);
Index: fs/ocfs2/inode.h
===================================================================
--- fs/ocfs2/inode.h	(revision 38)
+++ fs/ocfs2/inode.h	(working copy)
@@ -126,6 +126,7 @@ void ocfs2_drop_inode(struct inode *inod
 /* Flags for ocfs2_iget() */
 #define OCFS2_FI_FLAG_SYSFILE		0x1
 #define OCFS2_FI_FLAG_ORPHAN_RECOVERY	0x2
+struct inode *ocfs2_ilookup(struct super_block *sb, u64 feoff);
 struct inode *ocfs2_iget(struct ocfs2_super *osb, u64 feoff, unsigned flags,
 			 int sysfile_type);
 int ocfs2_inode_init_private(struct inode *inode);
