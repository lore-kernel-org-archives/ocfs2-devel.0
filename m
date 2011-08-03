From: Goldwyn Rodrigues <rgoldwyn@gmail.com>
Date: Wed, 3 Aug 2011 17:49:44 -0500
Subject: [Ocfs2-devel] [PATCH 3/3] Disable index directory in case of an
	error
Message-ID: <CAJtY7HXsPWOSbRRMXmT09U_WLizBcfvpDvKOky+gLKmfCBKtnA@mail.gmail.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

The first encounter with index directory is while performing
ocfs2_find_entry(). An error here disables the index directory in
ocfs2_inode_info only.

If this is a write/modify operation, this is later picked up
ocfs2_delete_entry or ocfs2_prepare_dir_for_insert and disabled in the
disk structures as well.

This means a simple "ls" operation only disables in the inode_info,
which is fine. If there is an operation not covered, let me know.

Signed-off-by: Goldwyn Rodrigues <rgoldwyn@suse.de>
---
 fs/ocfs2/dir.c   |   32 +++++++++++++++++++++++++++++---
 fs/ocfs2/dir.h   |    2 +-
 fs/ocfs2/namei.c |    8 +++++---
 3 files changed, 35 insertions(+), 7 deletions(-)

diff --git a/fs/ocfs2/dir.c b/fs/ocfs2/dir.c
index 94061ab..cbae077 100644
--- a/fs/ocfs2/dir.c
+++ b/fs/ocfs2/dir.c
@@ -1102,9 +1102,15 @@ int ocfs2_find_entry(const char *name, int namelen,
 {
 	struct buffer_head *bh;
 	struct ocfs2_dir_entry *res_dir = NULL;
+	int ret;

-	if (ocfs2_dir_indexed(dir))
-		return ocfs2_find_entry_dx(name, namelen, dir, lookup);
+	if (ocfs2_dir_indexed(dir)) {
+		ret = ocfs2_find_entry_dx(name, namelen, dir, lookup);
+		if (ret == -EIO)
+			ocfs2_dx_dir_disable(dir);
+		else
+			return ret;
+	}

 	/*
 	 * The unindexed dir code only uses part of the lookup
@@ -1427,12 +1433,23 @@ static inline int
ocfs2_delete_entry_el(handle_t *handle,
  * implementation from the caller.
  */
 int ocfs2_delete_entry(handle_t *handle,
-		       struct inode *dir,
+		       struct inode *dir, struct buffer_head *di_bh,
 		       struct ocfs2_dir_lookup_result *res)
 {
+	struct ocfs2_super *osb = OCFS2_SB(dir->i_sb);
 	if (ocfs2_dir_indexed(dir))
 		return ocfs2_delete_entry_dx(handle, dir, res);

+	/* Clear Index directory references in case of dx errors during
+	 * ocfs2_find_entry()
+	 */
+	if (ocfs2_supports_indexed_dirs(osb) && !ocfs2_dir_indexed(dir)) {
+		struct ocfs2_dinode *di =
+			(struct ocfs2_dinode *)di_bh->b_data;
+		di->i_dyn_features = cpu_to_le16(OCFS2_I(dir)->ip_dyn_features);
+		di->i_dx_root = cpu_to_le64(0ULL);
+	}
+
 	if (OCFS2_I(dir)->ip_dyn_features & OCFS2_INLINE_DATA_FL)
 		return ocfs2_delete_entry_id(handle, dir, res->dl_entry,
 					     res->dl_leaf_bh);
@@ -4381,6 +4398,15 @@ int ocfs2_prepare_dir_for_insert(struct ocfs2_super *osb,
 			mlog_errno(ret);
 		goto out;
 	}
+	/* Clear Index directory references in case of dx errors during
+	 * ocfs2_find_entry()
+	 */
+	if (ocfs2_supports_indexed_dirs(osb) && !ocfs2_dir_indexed(dir)) {
+		struct ocfs2_dinode *di =
+			(struct ocfs2_dinode *)parent_fe_bh->b_data;
+		di->i_dyn_features = cpu_to_le16(OCFS2_I(dir)->ip_dyn_features);
+		di->i_dx_root = cpu_to_le64(0ULL);
+	}

 	if (OCFS2_I(dir)->ip_dyn_features & OCFS2_INLINE_DATA_FL) {
 		ret = ocfs2_find_dir_space_id(dir, parent_fe_bh, name,
diff --git a/fs/ocfs2/dir.h b/fs/ocfs2/dir.h
index e683f3d..9dd8e8a 100644
--- a/fs/ocfs2/dir.h
+++ b/fs/ocfs2/dir.h
@@ -58,7 +58,7 @@ int ocfs2_find_entry(const char *name, int namelen,
 		     struct inode *dir,
 		     struct ocfs2_dir_lookup_result *lookup);
 int ocfs2_delete_entry(handle_t *handle,
-		       struct inode *dir,
+		       struct inode *dir, struct buffer_head *di_bh,
 		       struct ocfs2_dir_lookup_result *res);
 int __ocfs2_add_entry(handle_t *handle,
 		      struct inode *dir,
diff --git a/fs/ocfs2/namei.c b/fs/ocfs2/namei.c
index 53aa41e..e14d05c 100644
--- a/fs/ocfs2/namei.c
+++ b/fs/ocfs2/namei.c
@@ -904,7 +904,7 @@ static int ocfs2_unlink(struct inode *dir,
 	}

 	/* delete the name from the parent dir */
-	status = ocfs2_delete_entry(handle, dir, &lookup);
+	status = ocfs2_delete_entry(handle, dir, parent_node_bh, &lookup);
 	if (status < 0) {
 		mlog_errno(status);
 		goto leave;
@@ -1372,7 +1372,8 @@ static int ocfs2_rename(struct inode *old_dir,
 	if (status)
 		goto bail;

-	status = ocfs2_delete_entry(handle, old_dir, &old_entry_lookup);
+	status = ocfs2_delete_entry(handle, old_dir, old_dir_bh,
+			&old_entry_lookup);
 	if (status < 0) {
 		mlog_errno(status);
 		goto bail;
@@ -2097,7 +2098,8 @@ int ocfs2_orphan_del(struct ocfs2_super *osb,
 	}

 	/* remove it from the orphan directory */
-	status = ocfs2_delete_entry(handle, orphan_dir_inode, &lookup);
+	status = ocfs2_delete_entry(handle, orphan_dir_inode, orphan_dir_bh,
+			&lookup);
 	if (status < 0) {
 		mlog_errno(status);
 		goto leave;
-- 
1.7.6
