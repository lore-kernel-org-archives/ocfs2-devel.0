From: Joseph Qi <joseph.qi@huawei.com>
Date: Thu, 30 Jul 2015 19:30:59 +0800
Subject: [Ocfs2-devel] PATCH] ocfs2: adjust code to match locking/unlocking
	order
Message-ID: <55BA0AF3.8010909@huawei.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Unlocking order in ocfs2_unlink and ocfs2_rename mismatches the
corresponding locking order, although it won't cause issues, adjust the
code so that it looks more reasonable.

Signed-off-by: Joseph Qi <joseph.qi@huawei.com>
---
 fs/ocfs2/namei.c | 34 +++++++++++++++++-----------------
 1 file changed, 17 insertions(+), 17 deletions(-)

diff --git a/fs/ocfs2/namei.c b/fs/ocfs2/namei.c
index 38b3336..49435b1 100644
--- a/fs/ocfs2/namei.c
+++ b/fs/ocfs2/namei.c
@@ -1018,11 +1018,6 @@ leave:
 	if (handle)
 		ocfs2_commit_trans(osb, handle);

-	if (child_locked)
-		ocfs2_inode_unlock(inode, 1);
-
-	ocfs2_inode_unlock(dir, 1);
-
 	if (orphan_dir) {
 		/* This was locked for us in ocfs2_prepare_orphan_dir() */
 		ocfs2_inode_unlock(orphan_dir, 1);
@@ -1030,6 +1025,11 @@ leave:
 		iput(orphan_dir);
 	}

+	if (child_locked)
+		ocfs2_inode_unlock(inode, 1);
+
+	ocfs2_inode_unlock(dir, 1);
+
 	brelse(fe_bh);
 	brelse(parent_node_bh);

@@ -1608,21 +1608,9 @@ static int ocfs2_rename(struct inode *old_dir,
 	ocfs2_dentry_move(old_dentry, new_dentry, old_dir, new_dir);
 	status = 0;
 bail:
-	if (rename_lock)
-		ocfs2_rename_unlock(osb);
-
 	if (handle)
 		ocfs2_commit_trans(osb, handle);

-	if (parents_locked)
-		ocfs2_double_unlock(old_dir, new_dir);
-
-	if (old_child_locked)
-		ocfs2_inode_unlock(old_inode, 1);
-
-	if (new_child_locked)
-		ocfs2_inode_unlock(new_inode, 1);
-
 	if (orphan_dir) {
 		/* This was locked for us in ocfs2_prepare_orphan_dir() */
 		ocfs2_inode_unlock(orphan_dir, 1);
@@ -1630,6 +1618,18 @@ bail:
 		iput(orphan_dir);
 	}

+	if (new_child_locked)
+		ocfs2_inode_unlock(new_inode, 1);
+
+	if (old_child_locked)
+		ocfs2_inode_unlock(old_inode, 1);
+
+	if (parents_locked)
+		ocfs2_double_unlock(old_dir, new_dir);
+
+	if (rename_lock)
+		ocfs2_rename_unlock(osb);
+
 	if (new_inode)
 		sync_mapping_buffers(old_inode->i_mapping);

-- 
1.8.4.3
