From: Tristan Ye <tristan.ye@oracle.com>
Date: Fri, 27 Aug 2010 10:46:09 +0800
Subject: [Ocfs2-devel] [PATCH 1/1] Ocfs2: Add missing
	ocfs2_journal_acces_*() for couple of funcs in dir.c
Message-ID: <1282877169-4921-1-git-send-email-tristan.ye@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

To correctly journal the metadata in ocfs2, it's known for us to call
ocfs2_journal_access_*() and ocfs2_journal_dirty()to mark buffer dirty,
they are expected to exist in a pair.

Whereas several funcs for dx-dirs manipulation were forgeting to call
appropriate ocfs2_journal_access*() to correctly journal the dirty
metadata, which may cause a BUG in jbd2, reporting a NULL pointer
gets ASSERTED in the journal buffer head.

Currently, we found three functions being hurt in dir.c, all serving
for dx-dirs:

    - ocfs2_dx_dir_transfer_leaf()
    - ocfs2_remove_block_from_free_list()
    - ocfs2_recalc_free_list()

Signed-off-by: Tristan Ye <tristan.ye@oracle.com>
---
 fs/ocfs2/dir.c |  109 +++++++++++++++++++++++++++++++++++++++++++++-----------
 1 files changed, 88 insertions(+), 21 deletions(-)

diff --git a/fs/ocfs2/dir.c b/fs/ocfs2/dir.c
index f04ebcf..fe89136 100644
--- a/fs/ocfs2/dir.c
+++ b/fs/ocfs2/dir.c
@@ -1556,41 +1556,67 @@ out:
 	return ret;
 }
 
-static void ocfs2_remove_block_from_free_list(struct inode *dir,
-				       handle_t *handle,
-				       struct ocfs2_dir_lookup_result *lookup)
+static int ocfs2_remove_block_from_free_list(struct inode *dir,
+					handle_t *handle,
+					struct ocfs2_dir_lookup_result *lookup)
 {
+	int status = 0;
 	struct ocfs2_dir_block_trailer *trailer, *prev;
 	struct ocfs2_dx_root_block *dx_root;
 	struct buffer_head *bh;
+	ocfs2_journal_access_func access = ocfs2_journal_access_dr;
 
 	trailer = ocfs2_trailer_from_bh(lookup->dl_leaf_bh, dir->i_sb);
 
 	if (ocfs2_free_list_at_root(lookup)) {
 		bh = lookup->dl_dx_root_bh;
+		status = access(handle, INODE_CACHE(dir), bh,
+				OCFS2_JOURNAL_ACCESS_WRITE);
+		if (status < 0) {
+			mlog_errno(status);
+			return status;
+		}
 		dx_root = (struct ocfs2_dx_root_block *)bh->b_data;
 		dx_root->dr_free_blk = trailer->db_free_next;
 	} else {
+		access = ocfs2_journal_access_db;
 		bh = lookup->dl_prev_leaf_bh;
+		status = access(handle, INODE_CACHE(dir), bh,
+				OCFS2_JOURNAL_ACCESS_WRITE);
+		if (status < 0) {
+			mlog_errno(status);
+			return status;
+		}
 		prev = ocfs2_trailer_from_bh(bh, dir->i_sb);
 		prev->db_free_next = trailer->db_free_next;
 	}
 
+	ocfs2_journal_dirty(handle, bh);
+
+	status = ocfs2_journal_access_db(handle, INODE_CACHE(dir),
+					 lookup->dl_leaf_bh,
+					 OCFS2_JOURNAL_ACCESS_WRITE);
+	if (status < 0) {
+		mlog_errno(status);
+		return status;
+	}
+
 	trailer->db_free_rec_len = cpu_to_le16(0);
 	trailer->db_free_next = cpu_to_le64(0);
 
-	ocfs2_journal_dirty(handle, bh);
 	ocfs2_journal_dirty(handle, lookup->dl_leaf_bh);
+
+	return status;
 }
 
 /*
  * This expects that a journal write has been reserved on
  * lookup->dl_prev_leaf_bh or lookup->dl_dx_root_bh
  */
-static void ocfs2_recalc_free_list(struct inode *dir, handle_t *handle,
-				   struct ocfs2_dir_lookup_result *lookup)
+static int ocfs2_recalc_free_list(struct inode *dir, handle_t *handle,
+				  struct ocfs2_dir_lookup_result *lookup)
 {
-	int max_rec_len;
+	int max_rec_len, status = 0;
 	struct ocfs2_dir_block_trailer *trailer;
 
 	/* Walk dl_leaf_bh to figure out what the new free rec_len is. */
@@ -1601,12 +1627,24 @@ static void ocfs2_recalc_free_list(struct inode *dir, handle_t *handle,
 		 * from the free list. In this case, we just want to update
 		 * the rec len accounting.
 		 */
+		status = ocfs2_journal_access_db(handle, INODE_CACHE(dir),
+						 lookup->dl_leaf_bh,
+						 OCFS2_JOURNAL_ACCESS_WRITE);
+		if (status < 0) {
+			mlog_errno(status);
+			return status;
+		}
+
 		trailer = ocfs2_trailer_from_bh(lookup->dl_leaf_bh, dir->i_sb);
 		trailer->db_free_rec_len = cpu_to_le16(max_rec_len);
 		ocfs2_journal_dirty(handle, lookup->dl_leaf_bh);
 	} else {
-		ocfs2_remove_block_from_free_list(dir, handle, lookup);
+		status = ocfs2_remove_block_from_free_list(dir, handle, lookup);
+		if (status < 0)
+			mlog_errno(status);
 	}
+
+	return status;
 }
 
 /* we don't always have a dentry for what we want to add, so people
@@ -1748,8 +1786,14 @@ int __ocfs2_add_entry(handle_t *handle,
 			de->name_len = namelen;
 			memcpy(de->name, name, namelen);
 
-			if (ocfs2_dir_indexed(dir))
-				ocfs2_recalc_free_list(dir, handle, lookup);
+			if (ocfs2_dir_indexed(dir)) {
+				retval = ocfs2_recalc_free_list(dir, handle,
+								lookup);
+				if (retval < 0) {
+					mlog_errno(retval);
+					goto bail;
+				}
+			}
 
 			dir->i_version++;
 			ocfs2_journal_dirty(handle, insert_bh);
@@ -3736,14 +3780,14 @@ static int ocfs2_dx_dir_find_leaf_split(struct ocfs2_dx_leaf *dx_leaf,
  * of minor_hash, we can optimize - an item at block offset X within
  * the original cluster, will be at offset X within the new cluster.
  */
-static void ocfs2_dx_dir_transfer_leaf(struct inode *dir, u32 split_hash,
-				       handle_t *handle,
-				       struct ocfs2_dx_leaf *tmp_dx_leaf,
-				       struct buffer_head **orig_dx_leaves,
-				       struct buffer_head **new_dx_leaves,
-				       int num_dx_leaves)
+static int ocfs2_dx_dir_transfer_leaf(struct inode *dir, u32 split_hash,
+				      handle_t *handle,
+				      struct ocfs2_dx_leaf *tmp_dx_leaf,
+				      struct buffer_head **orig_dx_leaves,
+				      struct buffer_head **new_dx_leaves,
+				      int num_dx_leaves)
 {
-	int i, j, num_used;
+	int i, j, num_used, status = 0;
 	u32 major_hash;
 	struct ocfs2_dx_leaf *orig_dx_leaf, *new_dx_leaf;
 	struct ocfs2_dx_entry_list *orig_list, *new_list, *tmp_list;
@@ -3763,6 +3807,14 @@ static void ocfs2_dx_dir_transfer_leaf(struct inode *dir, u32 split_hash,
 		tmp_list->de_num_used = cpu_to_le16(0);
 		memset(&tmp_list->de_entries, 0, sizeof(*dx_entry)*num_used);
 
+		status = ocfs2_journal_access_dl(handle, INODE_CACHE(dir),
+						 new_dx_leaves[i],
+						 OCFS2_JOURNAL_ACCESS_WRITE);
+		if (status < 0) {
+			mlog_errno(status);
+			return status;
+		}
+
 		for (j = 0; j < num_used; j++) {
 			dx_entry = &orig_list->de_entries[j];
 			major_hash = le32_to_cpu(dx_entry->dx_major_hash);
@@ -3773,11 +3825,23 @@ static void ocfs2_dx_dir_transfer_leaf(struct inode *dir, u32 split_hash,
 				ocfs2_dx_dir_leaf_insert_tail(tmp_dx_leaf,
 							      dx_entry);
 		}
+
+		ocfs2_journal_dirty(handle, new_dx_leaves[i]);
+
+		status = ocfs2_journal_access_dl(handle, INODE_CACHE(dir),
+						 orig_dx_leaves[i],
+						 OCFS2_JOURNAL_ACCESS_WRITE);
+		if (status < 0) {
+			mlog_errno(status);
+			return status;
+		}
+
 		memcpy(orig_dx_leaf, tmp_dx_leaf, dir->i_sb->s_blocksize);
 
 		ocfs2_journal_dirty(handle, orig_dx_leaves[i]);
-		ocfs2_journal_dirty(handle, new_dx_leaves[i]);
 	}
+
+	return status;
 }
 
 static int ocfs2_dx_dir_rebalance_credits(struct ocfs2_super *osb,
@@ -3950,8 +4014,11 @@ static int ocfs2_dx_dir_rebalance(struct ocfs2_super *osb, struct inode *dir,
 		goto out_commit;
 	}
 
-	ocfs2_dx_dir_transfer_leaf(dir, split_hash, handle, tmp_dx_leaf,
-				   orig_dx_leaves, new_dx_leaves, num_dx_leaves);
+	ret = ocfs2_dx_dir_transfer_leaf(dir, split_hash, handle, tmp_dx_leaf,
+					 orig_dx_leaves, new_dx_leaves,
+					 num_dx_leaves);
+	if (ret)
+		mlog_errno(ret);
 
 out_commit:
 	if (ret < 0 && did_quota)
-- 
1.5.5
