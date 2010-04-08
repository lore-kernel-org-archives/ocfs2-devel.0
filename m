From: Li Dongyang <lidongyang@novell.com>
Date: Thu, 8 Apr 2010 09:13:08 +0800
Subject: [Ocfs2-devel] [PATCH] ocfs2: alloc orphaned inode in ocfs2_symlink
Message-ID: <201004080913.08494.lidongyang@novell.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

alloc the inode orphaned in ocfs2_symlink so we can delete the inode
in the iput if we meet errors with the inode, e.g. ocfs2_add_inode_data.
or ocfs2_query_inode_wipe will complain the inode is not orphaned on disk.


Signed-off-by: Li Dongyang <lidongyang@novell.com>
---
 fs/ocfs2/namei.c |   60 +++++++++++++++++++++++++++++------------------------
 1 files changed, 33 insertions(+), 27 deletions(-)

diff --git a/fs/ocfs2/namei.c b/fs/ocfs2/namei.c
index f010b22..daf1fdf 100644
--- a/fs/ocfs2/namei.c
+++ b/fs/ocfs2/namei.c
@@ -94,6 +94,8 @@ static int ocfs2_create_symlink_data(struct ocfs2_super 
*osb,
 				     struct inode *inode,
 				     const char *symname);
 
+static int ocfs2_blkno_stringify(u64 blkno, char *name);
+
 /* An orphan dir name is an 8 byte value, printed as a hex string */
 #define OCFS2_ORPHAN_NAMELEN ((int)(2 * sizeof(u64)))
 
@@ -1579,6 +1581,7 @@ static int ocfs2_symlink(struct inode *dir,
 	u64 newsize;
 	struct ocfs2_super *osb = NULL;
 	struct inode *inode = NULL;
+	struct inode *orphan_dir = NULL;
 	struct super_block *sb;
 	struct buffer_head *new_fe_bh = NULL;
 	struct buffer_head *parent_fe_bh = NULL;
@@ -1594,7 +1597,9 @@ static int ocfs2_symlink(struct inode *dir,
 		.enable = 1,
 	};
 	int did_quota = 0, did_quota_inode = 0;
+	char orphan_name[OCFS2_ORPHAN_NAMELEN + 1];
 	struct ocfs2_dir_lookup_result lookup = { NULL, };
+	struct ocfs2_dir_lookup_result orphan_insert = { NULL, };
 
 	mlog_entry("(0x%p, 0x%p, symname='%s' actual='%.*s')\n", dir,
 		   dentry, symname, dentry->d_name.len, dentry->d_name.name);
@@ -1621,14 +1626,9 @@ static int ocfs2_symlink(struct inode *dir,
 		goto bail;
 	}
 
-	status = ocfs2_check_dir_for_entry(dir, dentry->d_name.name,
-					   dentry->d_name.len);
-	if (status)
-		goto bail;
-
-	status = ocfs2_prepare_dir_for_insert(osb, dir, parent_fe_bh,
-					      dentry->d_name.name,
-					      dentry->d_name.len, &lookup);
+	status = ocfs2_prepare_orphan_dir(osb, &orphan_dir,
+					  osb->root_blkno,
+					  orphan_name, &orphan_insert);
 	if (status < 0) {
 		mlog_errno(status);
 		goto bail;
@@ -1709,7 +1709,20 @@ static int ocfs2_symlink(struct inode *dir,
 		goto bail;
 	}
 
+	status = ocfs2_blkno_stringify(OCFS2_I(inode)->ip_blkno, orphan_name);
+	if (status < 0) {
+		mlog_errno(status);
+		goto bail;
+	}
+
 	fe = (struct ocfs2_dinode *) new_fe_bh->b_data;
+	status = ocfs2_orphan_add(osb, handle, inode, fe, orphan_name,
+				  &orphan_insert, orphan_dir);
+	if (status < 0) {
+		mlog_errno(status);
+		goto bail;
+	}
+
 	inode->i_rdev = 0;
 	newsize = l - 1;
 	if (l > ocfs2_fast_symlink_chars(sb)) {
@@ -1768,24 +1781,6 @@ static int ocfs2_symlink(struct inode *dir,
 			goto bail;
 		}
 	}
-
-	status = ocfs2_add_entry(handle, dentry, inode,
-				 le64_to_cpu(fe->i_blkno), parent_fe_bh,
-				 &lookup);
-	if (status < 0) {
-		mlog_errno(status);
-		goto bail;
-	}
-
-	status = ocfs2_dentry_attach_lock(dentry, inode, OCFS2_I(dir)->ip_blkno);
-	if (status) {
-		mlog_errno(status);
-		goto bail;
-	}
-
-	insert_inode_hash(inode);
-	dentry->d_op = &ocfs2_dentry_ops;
-	d_instantiate(dentry, inode);
 bail:
 	if (status < 0 && did_quota)
 		vfs_dq_free_space_nodirty(inode,
@@ -1802,13 +1797,24 @@ bail:
 	kfree(si.name);
 	kfree(si.value);
 	ocfs2_free_dir_lookup_result(&lookup);
+	ocfs2_free_dir_lookup_result(&orphan_insert);
 	if (inode_ac)
 		ocfs2_free_alloc_context(inode_ac);
 	if (data_ac)
 		ocfs2_free_alloc_context(data_ac);
 	if (xattr_ac)
 		ocfs2_free_alloc_context(xattr_ac);
-	if ((status < 0) && inode) {
+	if (orphan_dir) {
+		ocfs2_inode_unlock(orphan_dir, 1);
+		mutex_unlock(&orphan_dir->i_mutex);
+		iput(orphan_dir);
+	}
+	if (inode && !status) {
+		status = ocfs2_mv_orphaned_inode_to_new(dir, inode, dentry);
+		if (status)
+			mlog_errno(status);
+	}
+	if (inode && status < 0) {
 		clear_nlink(inode);
 		iput(inode);
 	}
-- 
1.7.0.3
