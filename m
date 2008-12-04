From: wengang wang <wen.gang.wang@oracle.com>
Date: Thu, 4 Dec 2008 18:58:08 +0800
Subject: [Ocfs2-devel] [PATCH 1/1] OCFS2: anti stale inode for nfs (V1).
Message-ID: <200812041058.mB4Aw8dj032344@localhost.localdomain>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

this patch is to fix nfs getting stale inode bug.

        Right after we validate ih_blkno at the top we will use
ilookup5() to see if we have the inode in memory.  If we have the inode
in memory, we know we have the open lock, and the inode must be valid.
We can check the generation number and look up the alias as we normally
do.  
        If the inode is not found via ilookup5() -- that is, it is not
in memory -- we do something different.  First, we do a dirty read of
the inode block.  We use that inode block to find it's suballocator 
(i_suballoc_slot).  Then we take the cluster lock on that suballocator
system file.  By locking that file, we will have ensured the other nodes
have written out any changes.  We then check that suballocator to see if
the inode bit is actually set (i_suballoc_bit).  If the bit is set, we know
an inode is still valid on disk, and we then call ocfs2_iget().  If the bit
is not set, we know the inode is not valid, and we return -ESTALE.  At the
bottom of ocfs2_get_dentry() we can release the lock on the suballocator. 
We either have the inode (via iget) or don't (-ESTALE).

        second change is in ocfs2_inode_lock_update().  we don't panic
kernel when generation mismatches or the on disk inode is deleted. Instead,
we return -ESTALE.
	the last change is that we change the lock order against inode its
self and the suballcator. at above paragraph, we take locks in order of
	suballotor(in ocfs2_get_dentry())
	inode(in ocfs2_iget())
while, the inode deleting procedure locks in reverse order. to avoid deadlock,
we change the order of inode deleting procedure.

the patch is against 1.4 git.
#please ignore the svn info in patch -- I used a local svn for version
#management.

Signed-off-by: Wengang Wang <wen.gang.wang@oracle.com>
--
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
@@ -216,6 +216,11 @@ extern struct mlog_bits mlog_and_bits, m
 		mlog(ML_ERROR, "status = %lld\n", (long long)_st);	\
 } while (0)
 
+#define mlog_warnno(st) do {						\
+	int _st = (st);							\
+	mlog(ML_NOTICE, "status = %lld\n", (long long)_st);		\
+} while (0)
+
 #if defined(CONFIG_OCFS2_DEBUG_MASKLOG)
 #define mlog_entry(fmt, args...) do {					\
 	mlog(ML_ENTRY, "ENTRY:" fmt , ##args);				\
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
@@ -48,23 +50,125 @@ struct ocfs2_inode_handle
 static struct dentry *ocfs2_get_dentry(struct super_block *sb, void *vobjp)
 {
 	struct ocfs2_inode_handle *handle = vobjp;
-	struct inode *inode;
+	struct ocfs2_super *osb = OCFS2_SB(sb);
 	struct dentry *result;
-
+	struct inode *inode, *inode_alloc_inode;
+	struct buffer_head *inode_bh = NULL, *alloc_bh = NULL;
+	struct buffer_head *group_bh = NULL;
+	struct ocfs2_dinode *inode_fe, *alloc_fe;
+	struct ocfs2_group_desc *group;
+	u64 blkno = handle->ih_blkno, bg_blkno;
+	unsigned short suballoc_bit, suballoc_slot;
+	int status;
+	
 	mlog_entry("(0x%p, 0x%p)\n", sb, handle);
 
-	if (handle->ih_blkno == 0) {
-		mlog_errno(-ESTALE);
+	if (blkno == 0) {
+		mlog_warnno(-ESTALE);
 		return ERR_PTR(-ESTALE);
 	}
 
+	inode = ocfs2_ilookup(sb, ino_from_blkno(sb, blkno));
+	/* found in-memory inode, goes to check generation */
+	if (inode)
+		goto check_gen;
+
+	/* dirty reads(hit disk) the inode to get suballoc_slot and
+	 * suballoc_bit 
+	 * */
+	status = ocfs2_read_block(osb, blkno, &inode_bh, 0, NULL);
+	if (status < 0) {
+		mlog_errno(status);
+		return ERR_PTR(status);
+	}
+
+	inode_fe = (struct ocfs2_dinode *) inode_bh->b_data;
+	if (!OCFS2_IS_VALID_DINODE(inode_fe)) {
+		mlog(0, "Invalid dinode #%llu: signature = %.*s\n",
+		     (unsigned long long)blkno, 7, inode_fe->i_signature);
+		status = -EINVAL;
+		goto rls_bh;
+	}
+
+	suballoc_slot = le16_to_cpu(inode_fe->i_suballoc_slot);
+	suballoc_bit = le16_to_cpu(inode_fe->i_suballoc_bit);
+
+	/* checks suballoc_bit in bitmap is still SET */
+	inode_alloc_inode =
+		ocfs2_get_system_file_inode(osb, INODE_ALLOC_SYSTEM_INODE,
+					    suballoc_slot);
+	if (!inode_alloc_inode) {
+		status = -EEXIST;
+		goto rls_bh;
+	}
+
+	mutex_lock(&inode_alloc_inode->i_mutex);
+	status = ocfs2_inode_lock(inode_alloc_inode, &alloc_bh, 0);
+	if (status < 0) 
+		goto unlock_mutex;
+
+	alloc_fe = (struct ocfs2_dinode *)alloc_bh->b_data;
+	BUG_ON((suballoc_bit + 1) >
+			ocfs2_bits_per_group(&alloc_fe->id2.i_chain));
+
+	bg_blkno = ocfs2_which_suballoc_group(blkno, suballoc_bit);
+	status = ocfs2_read_block(osb, bg_blkno, &group_bh, OCFS2_BH_CACHED, 
+				  inode_alloc_inode);
+	if (status < 0) 
+		goto inode_unlock;
+
+	group = (struct ocfs2_group_desc *) group_bh->b_data;
+	status = ocfs2_check_group_descriptor(sb, alloc_fe, group);
+	if (status < 0) 
+		goto rls_group_bh;
+
+	/* if the bit is clear, it's a stale inode */
+	if (!ocfs2_test_bit(suballoc_bit, (unsigned long *)group->bg_bitmap)) {
+		status = -ESTALE;
+		goto rls_group_bh;
+	}
+
 	inode = ocfs2_iget(OCFS2_SB(sb), handle->ih_blkno, 0, 0);
 
-	if (IS_ERR(inode))
+	/* if suballoc slot changed since last ocfs2_read_block(), we may have
+	 * the lock on a wrong suballoc inode. but if so, since the inode was 
+	 * changed, the inode we want must be stale then. 
+	 * while, we don't check that here(since ocfs2_iget() doesn't bring
+	 * ocfs2_dinode to us, if we do check, we needs other code). instead,
+	 * we check on generation later. that is because if the suballoc slot
+	 * changed, the generation must changed(since they are in the same disk
+	 * sector). 
+	 * */ 
+
+rls_group_bh:
+	brelse(group_bh);
+inode_unlock:
+	ocfs2_inode_unlock(inode_alloc_inode, 0);
+unlock_mutex:
+	mutex_unlock(&inode_alloc_inode->i_mutex);
+	iput(inode_alloc_inode);
+	brelse(alloc_bh);
+rls_bh:
+	brelse(inode_bh);
+
+	if (status < 0) {
+		if (status == -ESTALE) {
+			mlog_warnno(status);
+		} else {
+			mlog_errno(status);
+		}
+		return ERR_PTR(status);
+	}
+
+	if (IS_ERR(inode)) {
+		mlog_errno((int)inode);
 		return (void *)inode;
+	}
 
+check_gen:
 	if (handle->ih_generation != inode->i_generation) {
 		iput(inode);
+		mlog_warnno(-ESTALE);
 		return ERR_PTR(-ESTALE);
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
@@ -571,6 +582,9 @@ out:
 	return status;
 }
 
+/* callers must have cluster lock inode_alloc_inode taken before calling
+ * ocfs2_remove_inode
+ * */
 static int ocfs2_remove_inode(struct inode *inode,
 			      struct buffer_head *di_bh,
 			      struct inode *orphan_dir_inode,
@@ -592,11 +606,12 @@ static int ocfs2_remove_inode(struct ino
 		goto bail;
 	}
 
-	mutex_lock(&inode_alloc_inode->i_mutex);
-	status = ocfs2_inode_lock(inode_alloc_inode, &inode_alloc_bh, 1);
+	status = ocfs2_read_block(OCFS2_SB(inode_alloc_inode->i_sb),
+				  OCFS2_I(inode_alloc_inode)->ip_blkno,
+				  &inode_alloc_bh,
+				  OCFS2_BH_CACHED,
+				  inode_alloc_inode);
 	if (status < 0) {
-		mutex_unlock(&inode_alloc_inode->i_mutex);
-
 		mlog_errno(status);
 		goto bail;
 	}
@@ -642,8 +657,6 @@ static int ocfs2_remove_inode(struct ino
 bail_commit:
 	ocfs2_commit_trans(osb, handle);
 bail_unlock:
-	ocfs2_inode_unlock(inode_alloc_inode, 1);
-	mutex_unlock(&inode_alloc_inode->i_mutex);
 	brelse(inode_alloc_bh);
 bail:
 	iput(inode_alloc_inode);
@@ -905,6 +918,8 @@ void ocfs2_delete_inode(struct inode *in
 	int wipe, status;
 	sigset_t blocked, oldset;
 	struct buffer_head *di_bh = NULL;
+	struct inode *inode_alloc_inode = NULL;
+	struct ocfs2_dinode *di = NULL;
 
 	mlog_entry("(inode->i_ino = %lu)\n", inode->i_ino);
 
@@ -933,6 +948,52 @@ void ocfs2_delete_inode(struct inode *in
 		goto bail;
 	}
 
+	/* lock the alloc group first before locking against inode
+	 * its self 
+	 * */
+	status = ocfs2_read_block(OCFS2_SB(inode->i_sb),
+				  OCFS2_I(inode)->ip_blkno,
+				  &di_bh,
+				  OCFS2_BH_CACHED,
+				  inode);
+	if (status < 0) {
+		mlog_errno(status);
+		goto bail_unblock;
+	}
+
+	di = (struct ocfs2_dinode *)di_bh->b_data;
+	if (!OCFS2_IS_VALID_DINODE(di)) {
+		mlog(0, "Invalid dinode #%llu: signature = %.*s\n",
+		     (unsigned long long)OCFS2_I(inode)->ip_blkno,
+		     7, di->i_signature);
+		status = -EINVAL;
+		brelse(di_bh);
+		mlog_errno(status);
+		goto bail_unblock;
+	}
+
+	inode_alloc_inode =
+		ocfs2_get_system_file_inode(OCFS2_SB(inode->i_sb),
+					    INODE_ALLOC_SYSTEM_INODE,
+					    le16_to_cpu(di->i_suballoc_slot));
+
+	brelse(di_bh);
+	di_bh = NULL;
+
+	if (!inode_alloc_inode) {
+		status = -EEXIST;
+		mlog_errno(status);
+		goto bail_unblock;
+	}
+	
+	mutex_lock(&inode_alloc_inode->i_mutex);
+	status = ocfs2_inode_lock(inode_alloc_inode, NULL, 1);
+	if (status < 0) {
+		mutex_unlock(&inode_alloc_inode->i_mutex);
+		mlog_errno(status);
+		goto bail_unblock;
+	}
+
 	/* Lock down the inode. This gives us an up to date view of
 	 * it's metadata (for verification), and allows us to
 	 * serialize delete_inode on multiple nodes.
@@ -946,7 +1007,7 @@ void ocfs2_delete_inode(struct inode *in
 		if (status != -ENOENT)
 			mlog_errno(status);
 		ocfs2_cleanup_delete_inode(inode, 0);
-		goto bail_unblock;
+		goto bail_unlock_alloc_inode;
 	}
 
 	/* Query the cluster. This will be the final decision made
@@ -989,6 +1050,10 @@ void ocfs2_delete_inode(struct inode *in
 bail_unlock_inode:
 	ocfs2_inode_unlock(inode, 1);
 	brelse(di_bh);
+bail_unlock_alloc_inode:
+	ocfs2_inode_unlock(inode_alloc_inode, 1);
+	mutex_unlock(&inode_alloc_inode->i_mutex);
+	iput(inode_alloc_inode);
 bail_unblock:
 	status = sigprocmask(SIG_SETMASK, &oldset, NULL);
 	if (status < 0)
Index: fs/ocfs2/dlmglue.c
===================================================================
--- fs/ocfs2/dlmglue.c	(revision 38)
+++ fs/ocfs2/dlmglue.c	(working copy)
@@ -1940,19 +1940,25 @@ static int ocfs2_inode_lock_update(struc
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
+			mlog(ML_NOTICE, "Invalid dinode %llu "
+			     "disk generation: %u inode->i_generation: %u\n",
+			     (unsigned long long)oi->ip_blkno,
+			     le32_to_cpu(fe->i_generation),
+			     inode->i_generation);
+			status = -ESTALE;
+			goto bail_refresh;
+		}
+		if (le64_to_cpu(fe->i_dtime) ||
+		    !(fe->i_flags & cpu_to_le32(OCFS2_VALID_FL))) {
+			mlog(ML_NOTICE,
+			     "Stale dinode %llu dtime: %llu flags: 0x%x\n",
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
Index: fs/ocfs2/suballoc.c
===================================================================
--- fs/ocfs2/suballoc.c	(revision 38)
+++ fs/ocfs2/suballoc.c	(working copy)
@@ -136,7 +136,7 @@ void ocfs2_free_alloc_context(struct ocf
 	kfree(ac);
 }
 
-static u32 ocfs2_bits_per_group(struct ocfs2_chain_list *cl)
+u32 ocfs2_bits_per_group(struct ocfs2_chain_list *cl)
 {
 	return (u32)le16_to_cpu(cl->cl_cpg) * (u32)le16_to_cpu(cl->cl_bpc);
 }
Index: fs/ocfs2/suballoc.h
===================================================================
--- fs/ocfs2/suballoc.h	(revision 38)
+++ fs/ocfs2/suballoc.h	(working copy)
@@ -53,6 +53,7 @@ struct ocfs2_alloc_context {
 	u64    ac_last_group;
 };
 
+u32 ocfs2_bits_per_group(struct ocfs2_chain_list *cl);
 void ocfs2_free_alloc_context(struct ocfs2_alloc_context *ac);
 static inline int ocfs2_alloc_context_bits_left(struct ocfs2_alloc_context *ac)
 {
