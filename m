From: Xue jiufei <xuejiufei@huawei.com>
Date: Fri, 19 Dec 2014 18:07:45 +0800
Subject: [Ocfs2-devel] [PATCH] ocfs2: fix the wrong directory passed to
 ocfs2_lookup_ino_from_name() when link file
Message-ID: <5493F8F1.3020602@huawei.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

In function ocfs2_link(), parent directory inode passed to function
ocfs2_lookup_ino_from_name() is wrong. Parameter dir is the parent
of new_dentry not old_dentry. We should get old_dir from old_dentry
and lookup old_dentry in old_dir in case another node remove the old dentry.

Reported-by: Szabo Aron - UBIT <aron@ubit.hu>
Signed-off-by: joyce.xue <xuejiufei@huawei.com>
---
 fs/ocfs2/namei.c | 43 +++++++++++++++++++++++++++++++++++--------
 1 file changed, 35 insertions(+), 8 deletions(-)

diff --git a/fs/ocfs2/namei.c b/fs/ocfs2/namei.c
index b931e04..914c121 100644
--- a/fs/ocfs2/namei.c
+++ b/fs/ocfs2/namei.c
@@ -94,6 +94,14 @@ static int ocfs2_create_symlink_data(struct ocfs2_super *osb,
 				     struct inode *inode,
 				     const char *symname);
 
+static int ocfs2_double_lock(struct ocfs2_super *osb,
+			     struct buffer_head **bh1,
+			     struct inode *inode1,
+			     struct buffer_head **bh2,
+			     struct inode *inode2,
+			     int rename);
+
+static void ocfs2_double_unlock(struct inode *inode1, struct inode *inode2);
 /* An orphan dir name is an 8 byte value, printed as a hex string */
 #define OCFS2_ORPHAN_NAMELEN ((int)(2 * sizeof(u64)))
 
@@ -678,8 +686,10 @@ static int ocfs2_link(struct dentry *old_dentry,
 {
 	handle_t *handle;
 	struct inode *inode = old_dentry->d_inode;
+	struct inode *old_dir = old_dentry->d_parent->d_inode;
 	int err;
 	struct buffer_head *fe_bh = NULL;
+	struct buffer_head *old_dir_bh = NULL;
 	struct buffer_head *parent_fe_bh = NULL;
 	struct ocfs2_dinode *fe = NULL;
 	struct ocfs2_super *osb = OCFS2_SB(dir->i_sb);
@@ -696,19 +706,33 @@ static int ocfs2_link(struct dentry *old_dentry,
 
 	dquot_initialize(dir);
 
-	err = ocfs2_inode_lock_nested(dir, &parent_fe_bh, 1, OI_LS_PARENT);
+	err = ocfs2_double_lock(osb, &old_dir_bh, old_dir,
+			&parent_fe_bh, dir, 0);
 	if (err < 0) {
 		if (err != -ENOENT)
 			mlog_errno(err);
 		return err;
 	}
 
+	/* make sure both dirs have bhs
+	 * get an extra ref on old_dir_bh if old==new */
+	if (!parent_fe_bh) {
+		if (old_dir_bh) {
+			parent_fe_bh = old_dir_bh;
+			get_bh(parent_fe_bh);
+		} else {
+			mlog(ML_ERROR, "%s: no old_dir_bh!\n", osb->uuid_str);
+			err = -EIO;
+			goto out;
+		}
+	}
+
 	if (!dir->i_nlink) {
 		err = -ENOENT;
 		goto out;
 	}
 
-	err = ocfs2_lookup_ino_from_name(dir, old_dentry->d_name.name,
+	err = ocfs2_lookup_ino_from_name(old_dir, old_dentry->d_name.name,
 			old_dentry->d_name.len, &old_de_ino);
 	if (err) {
 		err = -ENOENT;
@@ -801,10 +825,11 @@ out_unlock_inode:
 	ocfs2_inode_unlock(inode, 1);
 
 out:
-	ocfs2_inode_unlock(dir, 1);
+	ocfs2_double_unlock(old_dir, dir);
 
 	brelse(fe_bh);
 	brelse(parent_fe_bh);
+	brelse(old_dir_bh);
 
 	ocfs2_free_dir_lookup_result(&lookup);
 
@@ -1072,14 +1097,15 @@ static int ocfs2_check_if_ancestor(struct ocfs2_super *osb,
 }
 
 /*
- * The only place this should be used is rename!
+ * The only place this should be used is rename and link!
  * if they have the same id, then the 1st one is the only one locked.
  */
 static int ocfs2_double_lock(struct ocfs2_super *osb,
 			     struct buffer_head **bh1,
 			     struct inode *inode1,
 			     struct buffer_head **bh2,
-			     struct inode *inode2)
+			     struct inode *inode2,
+			     int rename)
 {
 	int status;
 	int inode1_is_ancestor, inode2_is_ancestor;
@@ -1127,7 +1153,7 @@ static int ocfs2_double_lock(struct ocfs2_super *osb,
 		}
 		/* lock id2 */
 		status = ocfs2_inode_lock_nested(inode2, bh2, 1,
-						 OI_LS_RENAME1);
+				rename == 1 ? OI_LS_RENAME1 : OI_LS_PARENT);
 		if (status < 0) {
 			if (status != -ENOENT)
 				mlog_errno(status);
@@ -1136,7 +1162,8 @@ static int ocfs2_double_lock(struct ocfs2_super *osb,
 	}
 
 	/* lock id1 */
-	status = ocfs2_inode_lock_nested(inode1, bh1, 1, OI_LS_RENAME2);
+	status = ocfs2_inode_lock_nested(inode1, bh1, 1,
+			rename == 1 ?  OI_LS_RENAME2 : OI_LS_PARENT);
 	if (status < 0) {
 		/*
 		 * An error return must mean that no cluster locks
@@ -1252,7 +1279,7 @@ static int ocfs2_rename(struct inode *old_dir,
 
 	/* if old and new are the same, this'll just do one lock. */
 	status = ocfs2_double_lock(osb, &old_dir_bh, old_dir,
-				   &new_dir_bh, new_dir);
+				   &new_dir_bh, new_dir, 1);
 	if (status < 0) {
 		mlog_errno(status);
 		goto bail;
-- 
1.8.4.3
