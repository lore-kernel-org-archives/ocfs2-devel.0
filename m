From: Tao Ma <tao.ma@oracle.com>
Date: Thu, 5 Jun 2008 15:33:09 +0800
Subject: [Ocfs2-devel] [PATCH 4/8] Make extend allocation generic.v1
In-Reply-To: <484792D1.3080802@oracle.com>
Message-ID: <20080605073309.GA19782@tma-pc2.cn.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

The old ocfs2_do_extend_allocation is restrictly to be used in file
extension. Now a new function named ocfs2_do_cluster_allocation will
handle the issue of generic extend allocation and it is created in
suballoc.c.

Signed-off-by: Tao Ma <tao.ma@oracle.com>
---
 fs/ocfs2/file.c     |   94 +++-------------------------------------------
 fs/ocfs2/file.h     |    6 +--
 fs/ocfs2/suballoc.c |  103 +++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/ocfs2/suballoc.h |   18 +++++++++
 4 files changed, 128 insertions(+), 93 deletions(-)

diff --git a/fs/ocfs2/file.c b/fs/ocfs2/file.c
index cc292ee..69ef6ba 100644
--- a/fs/ocfs2/file.c
+++ b/fs/ocfs2/file.c
@@ -508,96 +508,14 @@ int ocfs2_do_extend_allocation(struct ocfs2_super *osb,
 			       struct ocfs2_alloc_context *meta_ac,
 			       enum ocfs2_alloc_restarted *reason_ret)
 {
-	int status = 0;
-	int free_extents;
 	struct ocfs2_dinode *fe = (struct ocfs2_dinode *) fe_bh->b_data;
-	enum ocfs2_alloc_restarted reason = RESTART_NONE;
-	u32 bit_off, num_bits;
-	u64 block;
-	u8 flags = 0;
-
-	BUG_ON(!clusters_to_add);
-
-	if (mark_unwritten)
-		flags = OCFS2_EXT_UNWRITTEN;
-
-	free_extents = ocfs2_num_free_extents(osb, inode, fe_bh,
-					      OCFS2_DINODE_EXTENT);
-	if (free_extents < 0) {
-		status = free_extents;
-		mlog_errno(status);
-		goto leave;
-	}
-
-	/* there are two cases which could cause us to EAGAIN in the
-	 * we-need-more-metadata case:
-	 * 1) we haven't reserved *any*
-	 * 2) we are so fragmented, we've needed to add metadata too
-	 *    many times. */
-	if (!free_extents && !meta_ac) {
-		mlog(0, "we haven't reserved any metadata!\n");
-		status = -EAGAIN;
-		reason = RESTART_META;
-		goto leave;
-	} else if ((!free_extents)
-		   && (ocfs2_alloc_context_bits_left(meta_ac)
-		       < ocfs2_extend_meta_needed(&fe->id2.i_list))) {
-		mlog(0, "filesystem is really fragmented...\n");
-		status = -EAGAIN;
-		reason = RESTART_META;
-		goto leave;
-	}
+	struct ocfs2_extent_list *el = &fe->id2.i_list;
 
-	status = __ocfs2_claim_clusters(osb, handle, data_ac, 1,
-					clusters_to_add, &bit_off, &num_bits);
-	if (status < 0) {
-		if (status != -ENOSPC)
-			mlog_errno(status);
-		goto leave;
-	}
-
-	BUG_ON(num_bits > clusters_to_add);
-
-	/* reserve our write early -- insert_extent may update the inode */
-	status = ocfs2_journal_access(handle, inode, fe_bh,
-				      OCFS2_JOURNAL_ACCESS_WRITE);
-	if (status < 0) {
-		mlog_errno(status);
-		goto leave;
-	}
-
-	block = ocfs2_clusters_to_blocks(osb->sb, bit_off);
-	mlog(0, "Allocating %u clusters at block %u for inode %llu\n",
-	     num_bits, bit_off, (unsigned long long)OCFS2_I(inode)->ip_blkno);
-	status = ocfs2_insert_extent(osb, handle, inode, fe_bh,
-				     *logical_offset, block, num_bits,
-				     flags, meta_ac, OCFS2_DINODE_EXTENT);
-	if (status < 0) {
-		mlog_errno(status);
-		goto leave;
-	}
-
-	status = ocfs2_journal_dirty(handle, fe_bh);
-	if (status < 0) {
-		mlog_errno(status);
-		goto leave;
-	}
-
-	clusters_to_add -= num_bits;
-	*logical_offset += num_bits;
-
-	if (clusters_to_add) {
-		mlog(0, "need to alloc once more, clusters = %u, wanted = "
-		     "%u\n", fe->i_clusters, clusters_to_add);
-		status = -EAGAIN;
-		reason = RESTART_TRANS;
-	}
-
-leave:
-	mlog_exit(status);
-	if (reason_ret)
-		*reason_ret = reason;
-	return status;
+	return ocfs2_do_cluster_allocation(osb, inode, logical_offset,
+					   &clusters_to_add, mark_unwritten,
+					   fe_bh, el, handle,
+					   data_ac, meta_ac, reason_ret,
+					   OCFS2_DINODE_EXTENT);
 }
 
 static int __ocfs2_extend_allocation(struct inode *inode, u32 logical_start,
diff --git a/fs/ocfs2/file.h b/fs/ocfs2/file.h
index e090ff2..1ef2ac3 100644
--- a/fs/ocfs2/file.h
+++ b/fs/ocfs2/file.h
@@ -31,6 +31,7 @@ extern const struct file_operations ocfs2_dops;
 extern const struct inode_operations ocfs2_file_iops;
 extern const struct inode_operations ocfs2_special_file_iops;
 struct ocfs2_alloc_context;
+enum ocfs2_alloc_restarted;
 
 struct ocfs2_file_private {
 	struct file		*fp_file;
@@ -38,11 +39,6 @@ struct ocfs2_file_private {
 	struct ocfs2_lock_res	fp_flock;
 };
 
-enum ocfs2_alloc_restarted {
-	RESTART_NONE = 0,
-	RESTART_TRANS,
-	RESTART_META
-};
 int ocfs2_do_extend_allocation(struct ocfs2_super *osb,
 			       struct inode *inode,
 			       u32 *logical_offset,
diff --git a/fs/ocfs2/suballoc.c b/fs/ocfs2/suballoc.c
index 1992a6a..c953796 100644
--- a/fs/ocfs2/suballoc.c
+++ b/fs/ocfs2/suballoc.c
@@ -1973,3 +1973,106 @@ out:
 
 	return ret;
 }
+
+int ocfs2_do_cluster_allocation(struct ocfs2_super *osb,
+				struct inode *inode,
+				u32 *logical_offset,
+				u32 *clusters_to_add,
+				int mark_unwritten,
+				struct buffer_head *root_bh,
+				struct ocfs2_extent_list *root_el,
+				handle_t *handle,
+				struct ocfs2_alloc_context *data_ac,
+				struct ocfs2_alloc_context *meta_ac,
+				enum ocfs2_alloc_restarted *reason_ret,
+				enum ocfs2_extent_tree_type type)
+{
+	int status = 0;
+	int free_extents;
+	enum ocfs2_alloc_restarted reason = RESTART_NONE;
+	u32 bit_off, num_bits;
+	u64 block;
+	u8 flags = 0;
+
+	BUG_ON(!clusters_to_add);
+
+	if (mark_unwritten)
+		flags = OCFS2_EXT_UNWRITTEN;
+
+	free_extents = ocfs2_num_free_extents(osb, inode, root_bh, type);
+	if (free_extents < 0) {
+		status = free_extents;
+		mlog_errno(status);
+		goto leave;
+	}
+
+	/* there are two cases which could cause us to EAGAIN in the
+	 * we-need-more-metadata case:
+	 * 1) we haven't reserved *any*
+	 * 2) we are so fragmented, we've needed to add metadata too
+	 *    many times. */
+	if (!free_extents && !meta_ac) {
+		mlog(0, "we haven't reserved any metadata!\n");
+		status = -EAGAIN;
+		reason = RESTART_META;
+		goto leave;
+	} else if ((!free_extents)
+		   && (ocfs2_alloc_context_bits_left(meta_ac)
+		       < ocfs2_extend_meta_needed(root_el))) {
+		mlog(0, "filesystem is really fragmented...\n");
+		status = -EAGAIN;
+		reason = RESTART_META;
+		goto leave;
+	}
+
+	status = __ocfs2_claim_clusters(osb, handle, data_ac, 1,
+					*clusters_to_add, &bit_off, &num_bits);
+	if (status < 0) {
+		if (status != -ENOSPC)
+			mlog_errno(status);
+		goto leave;
+	}
+
+	BUG_ON(num_bits > *clusters_to_add);
+
+	/* reserve our write early -- insert_extent may update the inode */
+	status = ocfs2_journal_access(handle, inode, root_bh,
+				      OCFS2_JOURNAL_ACCESS_WRITE);
+	if (status < 0) {
+		mlog_errno(status);
+		goto leave;
+	}
+
+	block = ocfs2_clusters_to_blocks(osb->sb, bit_off);
+	mlog(0, "Allocating %u clusters at block %u for inode %llu\n",
+	     num_bits, bit_off, (unsigned long long)OCFS2_I(inode)->ip_blkno);
+	status = ocfs2_insert_extent(osb, handle, inode, root_bh,
+				     *logical_offset, block, num_bits,
+				     flags, meta_ac, type);
+	if (status < 0) {
+		mlog_errno(status);
+		goto leave;
+	}
+
+	status = ocfs2_journal_dirty(handle, root_bh);
+	if (status < 0) {
+		mlog_errno(status);
+		goto leave;
+	}
+
+	*clusters_to_add -= num_bits;
+	*logical_offset += num_bits;
+
+	if (*clusters_to_add) {
+		mlog(0, "need to alloc once more, wanted = %u\n",
+		     *clusters_to_add);
+		status = -EAGAIN;
+		reason = RESTART_TRANS;
+	}
+
+leave:
+	mlog_exit(status);
+	if (reason_ret)
+		*reason_ret = reason;
+	return status;
+}
diff --git a/fs/ocfs2/suballoc.h b/fs/ocfs2/suballoc.h
index df19591..fff02f9 100644
--- a/fs/ocfs2/suballoc.h
+++ b/fs/ocfs2/suballoc.h
@@ -166,4 +166,22 @@ int ocfs2_lock_allocators(struct inode *inode, struct buffer_head *root_bh,
 			  u32 clusters_to_add, u32 extents_to_split,
 			  struct ocfs2_alloc_context **data_ac,
 			  struct ocfs2_alloc_context **meta_ac);
+
+enum ocfs2_alloc_restarted {
+	RESTART_NONE = 0,
+	RESTART_TRANS,
+	RESTART_META
+};
+int ocfs2_do_cluster_allocation(struct ocfs2_super *osb,
+				struct inode *inode,
+				u32 *logical_offset,
+				u32 *clusters_to_add,
+				int mark_unwritten,
+				struct buffer_head *root_bh,
+				struct ocfs2_extent_list *root_el,
+				handle_t *handle,
+				struct ocfs2_alloc_context *data_ac,
+				struct ocfs2_alloc_context *meta_ac,
+				enum ocfs2_alloc_restarted *reason_ret,
+			       enum ocfs2_extent_tree_type type);
 #endif /* _CHAINALLOC_H_ */
-- 
1.5.4.GIT
