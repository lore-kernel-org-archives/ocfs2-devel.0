From: mfasheh at suse.com <mfasheh@suse.com>
Date: Fri, 13 Aug 2010 15:15:18 -0700
Subject: [Ocfs2-devel] [PATCH 4/5] ocfs2: split out
	ocfs2_prepare_orphan_dir() into locking and prep functions
In-Reply-To: <1281737719-27008-4-git-send-email-mfasheh@suse.com>
References: <1281737719-27008-1-git-send-email-mfasheh@suse.com>
	<1281737719-27008-2-git-send-email-mfasheh@suse.com>
	<1281737719-27008-3-git-send-email-mfasheh@suse.com>
	<1281737719-27008-4-git-send-email-mfasheh@suse.com>
Message-ID: <1281737719-27008-5-git-send-email-mfasheh@suse.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

From: Mark Fasheh <mfasheh@suse.com>

We do this because ocfs2_create_inode_in_orphan() wants to order locking of
the orphan dir with respect to locking of the inode allocator *before*
making any changes to the directory.

Signed-off-by: Mark Fasheh <mfasheh@suse.com>
---
 fs/ocfs2/namei.c |  120 +++++++++++++++++++++++++++++++++++++++--------------
 1 files changed, 88 insertions(+), 32 deletions(-)

diff --git a/fs/ocfs2/namei.c b/fs/ocfs2/namei.c
index 2aa66b6..54c6298 100644
--- a/fs/ocfs2/namei.c
+++ b/fs/ocfs2/namei.c
@@ -1871,61 +1871,117 @@ bail:
 	return status;
 }
 
-static int ocfs2_prepare_orphan_dir(struct ocfs2_super *osb,
-				    struct inode **ret_orphan_dir,
-				    u64 blkno,
-				    char *name,
-				    struct ocfs2_dir_lookup_result *lookup)
+static int ocfs2_lookup_lock_orphan_dir(struct ocfs2_super *osb,
+					struct inode **ret_orphan_dir,
+					struct buffer_head **ret_orphan_dir_bh)
 {
 	struct inode *orphan_dir_inode;
 	struct buffer_head *orphan_dir_bh = NULL;
-	int status = 0;
-
-	status = ocfs2_blkno_stringify(blkno, name);
-	if (status < 0) {
-		mlog_errno(status);
-		return status;
-	}
+	int ret = 0;
 
 	orphan_dir_inode = ocfs2_get_system_file_inode(osb,
 						       ORPHAN_DIR_SYSTEM_INODE,
 						       osb->slot_num);
 	if (!orphan_dir_inode) {
-		status = -ENOENT;
-		mlog_errno(status);
-		return status;
+		ret = -ENOENT;
+		mlog_errno(ret);
+		return ret;
 	}
 
 	mutex_lock(&orphan_dir_inode->i_mutex);
 
-	status = ocfs2_inode_lock(orphan_dir_inode, &orphan_dir_bh, 1);
-	if (status < 0) {
-		mlog_errno(status);
-		goto leave;
+	ret = ocfs2_inode_lock(orphan_dir_inode, &orphan_dir_bh, 1);
+	if (ret < 0) {
+		mutex_unlock(&orphan_dir_inode->i_mutex);
+		iput(orphan_dir_inode);
+
+		mlog_errno(ret);
+		return ret;
 	}
 
-	status = ocfs2_prepare_dir_for_insert(osb, orphan_dir_inode,
-					      orphan_dir_bh, name,
-					      OCFS2_ORPHAN_NAMELEN, lookup);
-	if (status < 0) {
-		ocfs2_inode_unlock(orphan_dir_inode, 1);
+	*ret_orphan_dir = orphan_dir_inode;
+	*ret_orphan_dir_bh = orphan_dir_bh;
 
-		mlog_errno(status);
-		goto leave;
+	return 0;
+}
+
+static int __ocfs2_prepare_orphan_dir(struct inode *orphan_dir_inode,
+				      struct buffer_head *orphan_dir_bh,
+				      u64 blkno,
+				      char *name,
+				      struct ocfs2_dir_lookup_result *lookup)
+{
+	int ret;
+	struct ocfs2_super *osb = OCFS2_SB(orphan_dir_inode->i_sb);
+
+	ret = ocfs2_blkno_stringify(blkno, name);
+	if (ret < 0) {
+		mlog_errno(ret);
+		return ret;
+	}
+
+	ret = ocfs2_prepare_dir_for_insert(osb, orphan_dir_inode,
+					   orphan_dir_bh, name,
+					   OCFS2_ORPHAN_NAMELEN, lookup);
+	if (ret < 0) {
+		mlog_errno(ret);
+		return ret;
+	}
+
+	return 0;
+}
+
+/**
+ * ocfs2_prepare_orphan_dir() - Prepare an orphan directory for
+ * insertion of an orphan.
+ * @osb: ocfs2 file system
+ * @ret_orphan_dir: Orphan dir inode - returned locked!
+ * @blkno: Actual block number of the inode to be inserted into orphan dir.
+ * @lookup: dir lookup result, to be passed back into functions like
+ *          ocfs2_orphan_add
+ *
+ * Returns zero on success and the ret_orphan_dir, name and lookup
+ * fields will be populated.
+ *
+ * Returns non-zero on failure. 
+ */
+static int ocfs2_prepare_orphan_dir(struct ocfs2_super *osb,
+				    struct inode **ret_orphan_dir,
+				    u64 blkno,
+				    char *name,
+				    struct ocfs2_dir_lookup_result *lookup)
+{
+	struct inode *orphan_dir_inode = NULL;
+	struct buffer_head *orphan_dir_bh = NULL;
+	int ret = 0;
+
+	ret = ocfs2_lookup_lock_orphan_dir(osb, &orphan_dir_inode,
+					   &orphan_dir_bh);
+	if (ret < 0) {
+		mlog_errno(ret);
+		return ret;
+	}
+
+	ret = __ocfs2_prepare_orphan_dir(orphan_dir_inode, orphan_dir_bh,
+					 blkno, name, lookup);
+	if (ret < 0) {
+		mlog_errno(ret);
+		goto out;
 	}
 
 	*ret_orphan_dir = orphan_dir_inode;
 
-leave:
-	if (status) {
+out:
+	brelse(orphan_dir_bh);
+
+	if (ret) {
+		ocfs2_inode_unlock(orphan_dir_inode, 1);
 		mutex_unlock(&orphan_dir_inode->i_mutex);
 		iput(orphan_dir_inode);
 	}
 
-	brelse(orphan_dir_bh);
-
-	mlog_exit(status);
-	return status;
+	mlog_exit(ret);
+	return ret;
 }
 
 static int ocfs2_orphan_add(struct ocfs2_super *osb,
-- 
1.6.4.2
