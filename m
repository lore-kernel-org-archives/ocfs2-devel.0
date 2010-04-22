From: Li Dongyang <lidongyang@novell.com>
Date: Thu, 22 Apr 2010 16:11:19 +0800
Subject: [Ocfs2-devel] [PATCH 1/3] ocfs2: add OCFS2_INODE_SKIP_ORPHAN_DIR
	flag and honor it in the inode wipe code
Message-ID: <201004221611.19307.lidongyang@novell.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

currently in the error path of ocfs2_symlink and ocfs2_mknod,
we just call iput with the inode we failed with, but the inode wipe code will
complain because we don't add the inode to orphan dir.
however, adding the inode to orphan dir requires additional transaction 
credits
which is too heavy for an error path, so we just use the
OCFS2_INODE_SKIP_ORPHAN_DIR flag and tell inode wipe code to go on with it.

Signed-off-by: Li Dongyang <lidongyang@novell.com>
---
 fs/ocfs2/inode.c |   65 +++++++++++++++++++++++++++++------------------------
 fs/ocfs2/inode.h |    2 +
 fs/ocfs2/namei.c |    1 +
 3 files changed, 39 insertions(+), 29 deletions(-)

diff --git a/fs/ocfs2/inode.c b/fs/ocfs2/inode.c
index 0297fb8..494f0a2 100644
--- a/fs/ocfs2/inode.c
+++ b/fs/ocfs2/inode.c
@@ -640,11 +640,13 @@ static int ocfs2_remove_inode(struct inode *inode,
 		goto bail_unlock;
 	}
 
-	status = ocfs2_orphan_del(osb, handle, orphan_dir_inode, inode,
-				  orphan_dir_bh);
-	if (status < 0) {
-		mlog_errno(status);
-		goto bail_commit;
+	if (!(OCFS2_I(inode)->ip_flags & OCFS2_INODE_SKIP_ORPHAN_DIR)) {
+		status = ocfs2_orphan_del(osb, handle, orphan_dir_inode, inode,
+					  orphan_dir_bh);
+		if (status < 0) {
+			mlog_errno(status);
+			goto bail_commit;
+		}
 	}
 
 	/* set the inodes dtime */
@@ -727,34 +729,35 @@ static int ocfs2_wipe_inode(struct inode *inode,
 	struct inode *orphan_dir_inode = NULL;
 	struct buffer_head *orphan_dir_bh = NULL;
 	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
-	struct ocfs2_dinode *di;
+	struct ocfs2_dinode *di = (struct ocfs2_dinode *) di_bh->b_data;
 
-	di = (struct ocfs2_dinode *) di_bh->b_data;
-	orphaned_slot = le16_to_cpu(di->i_orphaned_slot);
+	if (!(OCFS2_I(inode)->ip_flags & OCFS2_INODE_SKIP_ORPHAN_DIR)) {
+		orphaned_slot = le16_to_cpu(di->i_orphaned_slot);
 
-	status = ocfs2_check_orphan_recovery_state(osb, orphaned_slot);
-	if (status)
-		return status;
+		status = ocfs2_check_orphan_recovery_state(osb, orphaned_slot);
+		if (status)
+			return status;
 
-	orphan_dir_inode = ocfs2_get_system_file_inode(osb,
-						       ORPHAN_DIR_SYSTEM_INODE,
-						       orphaned_slot);
-	if (!orphan_dir_inode) {
-		status = -EEXIST;
-		mlog_errno(status);
-		goto bail;
-	}
+		orphan_dir_inode = ocfs2_get_system_file_inode(osb,
+							       ORPHAN_DIR_SYSTEM_INODE,
+							       orphaned_slot);
+		if (!orphan_dir_inode) {
+			status = -EEXIST;
+			mlog_errno(status);
+			goto bail;
+		}
 
-	/* Lock the orphan dir. The lock will be held for the entire
-	 * delete_inode operation. We do this now to avoid races with
-	 * recovery completion on other nodes. */
-	mutex_lock(&orphan_dir_inode->i_mutex);
-	status = ocfs2_inode_lock(orphan_dir_inode, &orphan_dir_bh, 1);
-	if (status < 0) {
-		mutex_unlock(&orphan_dir_inode->i_mutex);
+		/* Lock the orphan dir. The lock will be held for the entire
+		 * delete_inode operation. We do this now to avoid races with
+		 * recovery completion on other nodes. */
+		mutex_lock(&orphan_dir_inode->i_mutex);
+		status = ocfs2_inode_lock(orphan_dir_inode, &orphan_dir_bh, 1);
+		if (status < 0) {
+			mutex_unlock(&orphan_dir_inode->i_mutex);
 
-		mlog_errno(status);
-		goto bail;
+			mlog_errno(status);
+			goto bail;
+		}
 	}
 
 	/* we do this while holding the orphan dir lock because we
@@ -795,6 +798,9 @@ static int ocfs2_wipe_inode(struct inode *inode,
 		mlog_errno(status);
 
 bail_unlock_dir:
+	if (OCFS2_I(inode)->ip_flags & OCFS2_INODE_SKIP_ORPHAN_DIR)
+		return status;
+
 	ocfs2_inode_unlock(orphan_dir_inode, 1);
 	mutex_unlock(&orphan_dir_inode->i_mutex);
 	brelse(orphan_dir_bh);
@@ -890,7 +896,8 @@ static int ocfs2_query_inode_wipe(struct inode *inode,
 
 	/* Do some basic inode verification... */
 	di = (struct ocfs2_dinode *) di_bh->b_data;
-	if (!(di->i_flags & cpu_to_le32(OCFS2_ORPHANED_FL))) {
+	if (!(di->i_flags & cpu_to_le32(OCFS2_ORPHANED_FL)) &&
+	    !(oi->ip_flags & OCFS2_INODE_SKIP_ORPHAN_DIR)) {
 		/* for lack of a better error? */
 		status = -EEXIST;
 		mlog(ML_ERROR,
diff --git a/fs/ocfs2/inode.h b/fs/ocfs2/inode.h
index ba4fe07..0b28e19 100644
--- a/fs/ocfs2/inode.h
+++ b/fs/ocfs2/inode.h
@@ -100,6 +100,8 @@ struct ocfs2_inode_info
 #define OCFS2_INODE_MAYBE_ORPHANED	0x00000020
 /* Does someone have the file open O_DIRECT */
 #define OCFS2_INODE_OPEN_DIRECT		0x00000040
+/* Tell the inode wipe code it's not in orphan dir */
+#define OCFS2_INODE_SKIP_ORPHAN_DIR     0x00000080
 
 static inline struct ocfs2_inode_info *OCFS2_I(struct inode *inode)
 {
diff --git a/fs/ocfs2/namei.c b/fs/ocfs2/namei.c
index f010b22..b2a8ed5 100644
--- a/fs/ocfs2/namei.c
+++ b/fs/ocfs2/namei.c
@@ -1958,6 +1958,7 @@ static int ocfs2_orphan_add(struct ocfs2_super *osb,
 	}
 
 	le32_add_cpu(&fe->i_flags, OCFS2_ORPHANED_FL);
+	OCFS2_I(inode)->ip_flags &= ~OCFS2_INODE_SKIP_ORPHAN_DIR;
 
 	/* Record which orphan dir our inode now resides
 	 * in. delete_inode will use this to determine which orphan
-- 
1.6.4.2
