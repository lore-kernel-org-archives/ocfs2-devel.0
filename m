From: Goldwyn Rodrigues <rgoldwyn@gmail.com>
Date: Wed, 15 Jun 2011 10:57:54 -0500
Subject: [Ocfs2-devel] [PATCH 1/2] Disable indexing for directory with
	corrupt index
Message-ID: <BANLkTimpmS9GKwCvzBdswkzcaAY5YiugSw@mail.gmail.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Introduces ocfs2_dx_disable() to disable the index of a directory.
This function is called when a index directory is encountered.
Calling function must try and revert to regular directory handling,
instead of using indexes, in order to complete the operation.


Signed-off-by: Goldwyn Rodrigues <rgoldwyn@suse.de>
---
 fs/ocfs2/dir.c |   44 +++++++++++++++++++++++++++++++++++++++-----
 1 files changed, 39 insertions(+), 5 deletions(-)

diff --git a/fs/ocfs2/dir.c b/fs/ocfs2/dir.c
index 8582e3f..3a6f6e4 100644
--- a/fs/ocfs2/dir.c
+++ b/fs/ocfs2/dir.c
@@ -605,7 +605,7 @@ static int ocfs2_validate_dx_root(struct super_block *sb,
 	}

 	if (!OCFS2_IS_VALID_DX_ROOT(dx_root)) {
-		ocfs2_error(sb,
+		mlog(ML_ERROR,
 			    "Dir Index Root # %llu has bad signature %.*s",
 			    (unsigned long long)le64_to_cpu(dx_root->dr_blkno),
 			    7, dx_root->dr_signature);
@@ -649,9 +649,9 @@ static int ocfs2_validate_dx_leaf(struct super_block *sb,
 	}

 	if (!OCFS2_IS_VALID_DX_LEAF(dx_leaf)) {
-		ocfs2_error(sb, "Dir Index Leaf has bad signature %.*s",
-			    7, dx_leaf->dl_signature);
-		return -EROFS;
+		mlog(ML_ERROR, "Dir Index Leaf has bad signature %.*s",
+				7, dx_leaf->dl_signature);
+		return -EINVAL;
 	}

 	return 0;
@@ -1070,6 +1070,34 @@ out:
 	return ret;
 }

+/* Called only when an error occurs with reading indexed directories.
+ * The function just disables the directory indexing, and does not try
+ * delete it because it might be a corruption and the blocks useful to
+ * other structures.
+ *
+ * Must request user to run fsck.
+ */
+
+static void ocfs2_dx_disable(struct inode *dir, struct buffer_head *di_bh)
+{
+	struct ocfs2_inode_info *oi = OCFS2_I(dir);
+	struct ocfs2_dinode *di;
+	if (!di_bh) {
+		mlog(ML_ERROR, "Index directory corruption but unable "
+			"to disable dx_dir for <%llu>. Please execute "
+			"fsck.ocfs2\n",	OCFS2_I(dir)->ip_blkno);
+		return;
+	}
+	di = (struct ocfs2_dinode *)di_bh->b_data;
+	BUG_ON(di->i_blkno != oi->ip_blkno);
+	mlog(ML_ERROR, "Disabling index for directory <%llu> due to"
+		" corruption. Please execute fsck.ocfs2\n", oi->ip_blkno);
+	oi->ip_dyn_features &= ~OCFS2_INDEXED_DIR_FL;
+	di->i_dyn_features = cpu_to_le16(OCFS2_I(dir)->ip_dyn_features);
+	di->i_dx_root = cpu_to_le64(0ULL);
+}
+
+
 /*
  * Try to find an entry of the provided name within 'dir'.
  *
@@ -4364,11 +4392,17 @@ int ocfs2_prepare_dir_for_insert(struct
ocfs2_super *osb,
 	if (ocfs2_dir_indexed(dir)) {
 		ret = ocfs2_prepare_dx_dir_for_insert(dir, parent_fe_bh,
 						      name, namelen, lookup);
-		if (ret)
+		if (ret == -EINVAL) {
+			ocfs2_dx_disable(dir, parent_fe_bh);
+			/* Reset ret */
+			ret = 0;
+			goto no_index;
+		} else if (ret)
 			mlog_errno(ret);
 		goto out;
 	}

+no_index:
 	if (OCFS2_I(dir)->ip_dyn_features & OCFS2_INLINE_DATA_FL) {
 		ret = ocfs2_find_dir_space_id(dir, parent_fe_bh, name,
 					      namelen, &bh, &blocks_wanted);
-- 
1.7.5.3


-- 
Goldwyn
