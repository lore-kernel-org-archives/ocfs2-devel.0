From: mfasheh at suse.com <mfasheh@suse.com>
Date: Fri, 13 Aug 2010 15:15:19 -0700
Subject: [Ocfs2-devel] [PATCH 5/5] ocfs2: Fix orphan add in
	ocfs2_create_inode_in_orphan
In-Reply-To: <1281737719-27008-5-git-send-email-mfasheh@suse.com>
References: <1281737719-27008-1-git-send-email-mfasheh@suse.com>
	<1281737719-27008-2-git-send-email-mfasheh@suse.com>
	<1281737719-27008-3-git-send-email-mfasheh@suse.com>
	<1281737719-27008-4-git-send-email-mfasheh@suse.com>
	<1281737719-27008-5-git-send-email-mfasheh@suse.com>
Message-ID: <1281737719-27008-6-git-send-email-mfasheh@suse.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

From: Mark Fasheh <mfasheh@suse.com>

ocfs2_create_inode_in_orphan() is used by reflink to create the newly
reflinked inode simultaneously in the orphan dir. This allows us to easily
handle partially-reflinked files during recovery cleanup.

We have a problem though - the orphan dir stringifies inode # to determine
a unique name under which the orphan entry dirent can be created. Since
ocfs2_create_inode_in_orphan() needs the space allocated in the orphan dir
before it can allocate the inode, we currently call into the orphan code:

       /*
        * We give the orphan dir the root blkno to fake an orphan name,
        * and allocate enough space for our insertion.
        */
       status = ocfs2_prepare_orphan_dir(osb, &orphan_dir,
                                         osb->root_blkno,
                                         orphan_name, &orphan_insert);

Using osb->root_blkno might work fine on unindexed directories, but the
orphan dir can have an index.  When it has that index, the above code fails
to allocate the proper index entry.  Later, when we try to remove the file
from the orphan dir (using the actual inode #), the reflink operation will
fail.

To fix this, I created a function ocfs2_alloc_orphaned_file() which uses the
newly split out orphan and inode alloc code to figure out what the inode
block number will be (once allocated) and then prepare the orphan dir from
that data.

Signed-off-by: Mark Fasheh <mfasheh@suse.com>
---
 fs/ocfs2/namei.c |  127 +++++++++++++++++++++++++++++++++++++++++++++--------
 1 files changed, 107 insertions(+), 20 deletions(-)

diff --git a/fs/ocfs2/namei.c b/fs/ocfs2/namei.c
index 54c6298..a00dda2 100644
--- a/fs/ocfs2/namei.c
+++ b/fs/ocfs2/namei.c
@@ -2128,6 +2128,99 @@ leave:
 	return status;
 }
 
+/**
+ * ocfs2_prep_new_orphaned_file() - Prepare the orphan dir to recieve a newly
+ * allocated file. This is different from the typical 'add to orphan dir'
+ * operation in that the inode does not yet exist. This is a problem because
+ * the orphan dir stringifies the inode block number to come up with it's
+ * dirent. Obviously if the inode does not yet exist we have a chicken and egg
+ * problem. This function works around it by calling deeper into the orphan
+ * and suballoc code than other callers. Use this only by necessity.
+ * @dir: The directory which this inode will ultimately wind up under - not the
+ * orphan dir!
+ * @dir_bh: buffer_head the @dir inode block
+ * @orphan_name: string of length (CFS2_ORPHAN_NAMELEN + 1). Will be filled
+ * with the string to be used for orphan dirent. Pass back to the orphan dir
+ * code.
+ * @ret_orphan_dir: orphan dir inode returned to be passed back into orphan
+ * dir code.
+ * @ret_di_blkno: block number where the new inode will be allocated.
+ * @orphan_insert: Dir insert context to be passed back into orphan dir code.
+ * @ret_inode_ac: Inode alloc context to be passed back to the allocator.
+ *
+ * Returns zero on success and the ret_orphan_dir, name and lookup
+ * fields will be populated.
+ *
+ * Returns non-zero on failure. 
+ */
+static int ocfs2_prep_new_orphaned_file(struct inode *dir,
+					struct buffer_head *dir_bh,
+					char *orphan_name,
+					struct inode **ret_orphan_dir,
+					u64 *ret_di_blkno,
+					struct ocfs2_dir_lookup_result *orphan_insert,
+					struct ocfs2_alloc_context **ret_inode_ac)
+{
+	int ret;
+	u64 di_blkno;
+	struct ocfs2_super *osb = OCFS2_SB(dir->i_sb);
+	struct inode *orphan_dir = NULL;
+	struct buffer_head *orphan_dir_bh = NULL;
+	struct ocfs2_alloc_context *inode_ac = NULL;
+
+	ret = ocfs2_lookup_lock_orphan_dir(osb, &orphan_dir, &orphan_dir_bh);
+	if (ret < 0) {
+		mlog_errno(ret);
+		return ret;
+	}
+
+	/* reserve an inode spot */
+	ret = ocfs2_reserve_new_inode(osb, &inode_ac);
+	if (ret < 0) {
+		if (ret != -ENOSPC)
+			mlog_errno(ret);
+		goto out;
+	}
+
+	ret = ocfs2_find_new_inode_loc(dir, dir_bh, inode_ac,
+				       &di_blkno);
+	if (ret) {
+		mlog_errno(ret);
+		goto out;
+	}
+
+	ret = __ocfs2_prepare_orphan_dir(orphan_dir, orphan_dir_bh,
+					 di_blkno, orphan_name, orphan_insert);
+	if (ret < 0) {
+		mlog_errno(ret);
+		goto out;
+	}
+
+out:
+	if (ret == 0) {
+		*ret_orphan_dir = orphan_dir;
+		*ret_di_blkno = di_blkno;
+		*ret_inode_ac = inode_ac;
+		/*
+		 * orphan_name and orphan_insert are already up to
+		 * date via prepare_orphan_dir
+		 */
+	} else {
+		/* Unroll reserve_new_inode* */
+		if (inode_ac)
+			ocfs2_free_alloc_context(inode_ac);
+
+		/* Unroll orphan dir locking */
+		mutex_unlock(&orphan_dir->i_mutex);
+		ocfs2_inode_unlock(orphan_dir, 1);
+		iput(orphan_dir);
+	}
+
+	brelse(orphan_dir_bh);
+
+	return 0;
+}
+
 int ocfs2_create_inode_in_orphan(struct inode *dir,
 				 int mode,
 				 struct inode **new_inode)
@@ -2143,6 +2236,8 @@ int ocfs2_create_inode_in_orphan(struct inode *dir,
 	struct buffer_head *new_di_bh = NULL;
 	struct ocfs2_alloc_context *inode_ac = NULL;
 	struct ocfs2_dir_lookup_result orphan_insert = { NULL, };
+	u64 uninitialized_var(di_blkno), suballoc_loc;
+	u16 suballoc_bit;
 
 	status = ocfs2_inode_lock(dir, &parent_di_bh, 1);
 	if (status < 0) {
@@ -2151,20 +2246,9 @@ int ocfs2_create_inode_in_orphan(struct inode *dir,
 		return status;
 	}
 
-	/*
-	 * We give the orphan dir the root blkno to fake an orphan name,
-	 * and allocate enough space for our insertion.
-	 */
-	status = ocfs2_prepare_orphan_dir(osb, &orphan_dir,
-					  osb->root_blkno,
-					  orphan_name, &orphan_insert);
-	if (status < 0) {
-		mlog_errno(status);
-		goto leave;
-	}
-
-	/* reserve an inode spot */
-	status = ocfs2_reserve_new_inode(osb, &inode_ac);
+	status = ocfs2_prep_new_orphaned_file(dir, parent_di_bh,
+					      orphan_name, &orphan_dir,
+					      &di_blkno, &orphan_insert, &inode_ac);
 	if (status < 0) {
 		if (status != -ENOSPC)
 			mlog_errno(status);
@@ -2191,17 +2275,20 @@ int ocfs2_create_inode_in_orphan(struct inode *dir,
 		goto leave;
 	did_quota_inode = 1;
 
-	inode->i_nlink = 0;
-	/* do the real work now. */
-	status = ocfs2_mknod_locked(osb, dir, inode,
-				    0, &new_di_bh, parent_di_bh, handle,
-				    inode_ac);
+	status = ocfs2_claim_new_inode_at_loc(handle, dir, inode_ac,
+					      &suballoc_loc,
+					      &suballoc_bit, di_blkno);
 	if (status < 0) {
 		mlog_errno(status);
 		goto leave;
 	}
 
-	status = ocfs2_blkno_stringify(OCFS2_I(inode)->ip_blkno, orphan_name);
+	inode->i_nlink = 0;
+	/* do the real work now. */
+	status = __ocfs2_mknod_locked(dir, inode,
+				      0, &new_di_bh, parent_di_bh, handle,
+				      inode_ac, di_blkno, suballoc_loc,
+				      suballoc_bit);
 	if (status < 0) {
 		mlog_errno(status);
 		goto leave;
-- 
1.6.4.2
