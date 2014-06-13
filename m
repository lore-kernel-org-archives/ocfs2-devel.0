From: jiangyiwen <jiangyiwen@huawei.com>
Date: Fri, 13 Jun 2014 17:18:20 +0800
Subject: [Ocfs2-devel] [PATCH V2] ocfs2: manually do the iput once
 ocfs2_add_entry failed in ocfs2_symlink and ocfs2_mknod
Message-ID: <539AC1DC.7010201@huawei.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

When the call to ocfs2_add_entry() failed in ocfs2_symlink() and
ocfs2_mknod(), iput() will not be called during dput(dentry) because no
d_instantiate(), and this will lead to umount hung.

Signed-off-by: jiangyiwen <jiangyiwen@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---
 fs/ocfs2/namei.c | 27 +++++++++++++++++++++++++++
 1 file changed, 27 insertions(+)

diff --git a/fs/ocfs2/namei.c b/fs/ocfs2/namei.c
index 2060fc3..2270516 100644
--- a/fs/ocfs2/namei.c
+++ b/fs/ocfs2/namei.c
@@ -205,6 +205,21 @@ static struct inode *ocfs2_get_init_inode(struct inode *dir, umode_t mode)
 	return inode;
 }

+static void ocfs2_cleanup_add_entry_failure(struct ocfs2_super *osb,
+		struct dentry *dentry, struct inode *inode)
+{
+	struct ocfs2_dentry_lock *dl = dentry->d_fsdata;
+
+	ocfs2_simple_drop_lockres(osb, &dl->dl_lockres);
+	ocfs2_lock_res_free(&dl->dl_lockres);
+	BUG_ON(dl->dl_count != 1);
+	spin_lock(&dentry_attach_lock);
+	dentry->d_fsdata = NULL;
+	spin_unlock(&dentry_attach_lock);
+	kfree(dl);
+	iput(inode);
+}
+
 static int ocfs2_mknod(struct inode *dir,
 		       struct dentry *dentry,
 		       umode_t mode,
@@ -231,6 +246,7 @@ static int ocfs2_mknod(struct inode *dir,
 	sigset_t oldset;
 	int did_block_signals = 0;
 	struct posix_acl *default_acl = NULL, *acl = NULL;
+	struct ocfs2_dentry_lock *dl = NULL;

 	trace_ocfs2_mknod(dir, dentry, dentry->d_name.len, dentry->d_name.name,
 			  (unsigned long long)OCFS2_I(dir)->ip_blkno,
@@ -423,6 +439,8 @@ static int ocfs2_mknod(struct inode *dir,
 		goto leave;
 	}

+	dl = dentry->d_fsdata;
+
 	status = ocfs2_add_entry(handle, dentry, inode,
 				 OCFS2_I(inode)->ip_blkno, parent_fe_bh,
 				 &lookup);
@@ -469,6 +487,9 @@ leave:
 	 * ocfs2_delete_inode will mutex_lock again.
 	 */
 	if ((status < 0) && inode) {
+		if (dl)
+			ocfs2_cleanup_add_entry_failure(osb, dentry, inode);
+
 		OCFS2_I(inode)->ip_flags |= OCFS2_INODE_SKIP_ORPHAN_DIR;
 		clear_nlink(inode);
 		iput(inode);
@@ -1642,6 +1663,7 @@ static int ocfs2_symlink(struct inode *dir,
 	struct ocfs2_dir_lookup_result lookup = { NULL, };
 	sigset_t oldset;
 	int did_block_signals = 0;
+	struct ocfs2_dentry_lock *dl = NULL;

 	trace_ocfs2_symlink_begin(dir, dentry, symname,
 				  dentry->d_name.len, dentry->d_name.name);
@@ -1830,6 +1852,8 @@ static int ocfs2_symlink(struct inode *dir,
 		goto bail;
 	}

+	dl = dentry->d_fsdata;
+
 	status = ocfs2_add_entry(handle, dentry, inode,
 				 le64_to_cpu(fe->i_blkno), parent_fe_bh,
 				 &lookup);
@@ -1864,6 +1888,9 @@ bail:
 	if (xattr_ac)
 		ocfs2_free_alloc_context(xattr_ac);
 	if ((status < 0) && inode) {
+		if (dl)
+			ocfs2_cleanup_add_entry_failure(osb, dentry, inode);
+
 		OCFS2_I(inode)->ip_flags |= OCFS2_INODE_SKIP_ORPHAN_DIR;
 		clear_nlink(inode);
 		iput(inode);
-- 
1.8.4.3
