From: Younger Liu <younger.liucn@gmail.com>
Date: Mon, 10 Mar 2014 12:49:11 +0800
Subject: [Ocfs2-devel] [PATCH] Ocfs2: alloc_dinode counts and group bitmap
 should be update simultaneously
Message-ID: <531D4447.7060801@gmail.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com


  Updating alloc_dinode counts in ocfs2_alloc_dinode_update_counts()
and setting group bitmap in ocfs2_alloc_dinode_update_bitmap() have 
to be simultaneously.Two cases is as follow:
  (1) If ocfs2_alloc_dinode_update_counts() fails, there is no need to
set group bitmap. This case has been considered.
  (2) If ocfs2_alloc_dinode_update_bitmap() fails, alloc_dinode counts
should be rolled back. Otherwise, some clusters would never be used. 
This case is not considered.
  So, we combine two functions, and ensure simultaneity.

Signed-off-by: Younger Liu <younger.liucn@gmail.com>
---
 fs/ocfs2/move_extents.c |   11 ++--
 fs/ocfs2/ocfs2_trace.h  |    2 +-
 fs/ocfs2/suballoc.c     |  155 +++++++++++++++++++----------------------------
 fs/ocfs2/suballoc.h     |   21 +++----
 4 files changed, 77 insertions(+), 112 deletions(-)

diff --git a/fs/ocfs2/move_extents.c b/fs/ocfs2/move_extents.c
index 64c304d..9e15d8b 100644
--- a/fs/ocfs2/move_extents.c
+++ b/fs/ocfs2/move_extents.c
@@ -681,18 +681,15 @@ static int ocfs2_move_extent(struct ocfs2_move_extents_context *context,
 	}
 
 	gd = (struct ocfs2_group_desc *)gd_bh->b_data;
-	ret = ocfs2_alloc_dinode_update_counts(gb_inode, handle, gb_bh, len,
-					       le16_to_cpu(gd->bg_chain));
+	ret = ocfs2_alloc_dinode_update_bitmap(handle,
+				gb_inode, gb_bh, gd, gb_bh,
+				le16_to_cpu(gd->bg_chain),
+				goal_bit, len);
 	if (ret) {
 		mlog_errno(ret);
 		goto out_commit;
 	}
 
-	ret = ocfs2_block_group_set_bits(handle, gb_inode, gd, gd_bh,
-					 goal_bit, len);
-	if (ret)
-		mlog_errno(ret);
-
 	/*
 	 * Here we should write the new page out first if we are
 	 * in write-back mode.
diff --git a/fs/ocfs2/ocfs2_trace.h b/fs/ocfs2/ocfs2_trace.h
index 1b60c62..90c997e 100644
--- a/fs/ocfs2/ocfs2_trace.h
+++ b/fs/ocfs2/ocfs2_trace.h
@@ -788,7 +788,7 @@ DEFINE_OCFS2_UINT_UINT_UINT_EVENT(ocfs2_reserve_suballoc_bits_no_new_group);
 
 DEFINE_OCFS2_ULL_EVENT(ocfs2_reserve_new_inode_new_group);
 
-DEFINE_OCFS2_UINT_UINT_EVENT(ocfs2_block_group_set_bits);
+DEFINE_OCFS2_UINT_UINT_EVENT(ocfs2_alloc_dinode_update_bitmap);
 
 TRACE_EVENT(ocfs2_relink_block_group,
 	TP_PROTO(unsigned long long i_blkno, unsigned int chain,
diff --git a/fs/ocfs2/suballoc.c b/fs/ocfs2/suballoc.c
index 47ae266..4b80b19 100644
--- a/fs/ocfs2/suballoc.c
+++ b/fs/ocfs2/suballoc.c
@@ -1337,54 +1337,6 @@ static int ocfs2_block_group_find_clear_bits(struct ocfs2_super *osb,
 	return status;
 }
 
-int ocfs2_block_group_set_bits(handle_t *handle,
-					     struct inode *alloc_inode,
-					     struct ocfs2_group_desc *bg,
-					     struct buffer_head *group_bh,
-					     unsigned int bit_off,
-					     unsigned int num_bits)
-{
-	int status;
-	void *bitmap = bg->bg_bitmap;
-	int journal_type = OCFS2_JOURNAL_ACCESS_WRITE;
-
-	/* All callers get the descriptor via
-	 * ocfs2_read_group_descriptor().  Any corruption is a code bug. */
-	BUG_ON(!OCFS2_IS_VALID_GROUP_DESC(bg));
-	BUG_ON(le16_to_cpu(bg->bg_free_bits_count) < num_bits);
-
-	trace_ocfs2_block_group_set_bits(bit_off, num_bits);
-
-	if (ocfs2_is_cluster_bitmap(alloc_inode))
-		journal_type = OCFS2_JOURNAL_ACCESS_UNDO;
-
-	status = ocfs2_journal_access_gd(handle,
-					 INODE_CACHE(alloc_inode),
-					 group_bh,
-					 journal_type);
-	if (status < 0) {
-		mlog_errno(status);
-		goto bail;
-	}
-
-	le16_add_cpu(&bg->bg_free_bits_count, -num_bits);
-	if (le16_to_cpu(bg->bg_free_bits_count) > le16_to_cpu(bg->bg_bits)) {
-		ocfs2_error(alloc_inode->i_sb, "Group descriptor # %llu has bit"
-			    " count %u but claims %u are freed. num_bits %d",
-			    (unsigned long long)le64_to_cpu(bg->bg_blkno),
-			    le16_to_cpu(bg->bg_bits),
-			    le16_to_cpu(bg->bg_free_bits_count), num_bits);
-		return -EROFS;
-	}
-	while(num_bits--)
-		ocfs2_set_bit(bit_off++, bitmap);
-
-	ocfs2_journal_dirty(handle, group_bh);
-
-bail:
-	return status;
-}
-
 /* find the one with the most empty bits */
 static inline u16 ocfs2_find_victim_chain(struct ocfs2_chain_list *cl)
 {
@@ -1580,31 +1532,78 @@ static int ocfs2_block_group_search(struct inode *inode,
 	return ret;
 }
 
-int ocfs2_alloc_dinode_update_counts(struct inode *inode,
-				       handle_t *handle,
-				       struct buffer_head *di_bh,
-				       u32 num_bits,
-				       u16 chain)
+int ocfs2_alloc_dinode_update_bitmap(handle_t *handle,
+				struct inode *alloc_inode,
+				struct buffer_head *di_bh,
+				struct ocfs2_group_desc *bg,
+				struct buffer_head *group_bh,
+				u16 chain, u32 bit_off, u32 num_bits)
 {
 	int ret;
 	u32 tmp_used;
 	struct ocfs2_dinode *di = (struct ocfs2_dinode *) di_bh->b_data;
 	struct ocfs2_chain_list *cl = (struct ocfs2_chain_list *) &di->id2.i_chain;
+	void *bitmap = bg->bg_bitmap;
+	int journal_type = OCFS2_JOURNAL_ACCESS_WRITE;
 
-	ret = ocfs2_journal_access_di(handle, INODE_CACHE(inode), di_bh,
-				      OCFS2_JOURNAL_ACCESS_WRITE);
+	/*
+	 * All callers get the descriptor via
+	 * ocfs2_read_group_descriptor().  Any corruption is a code bug.
+	 */
+	BUG_ON(!OCFS2_IS_VALID_GROUP_DESC(bg));
+	BUG_ON(le16_to_cpu(bg->bg_free_bits_count) < num_bits);
+
+	trace_ocfs2_alloc_dinode_update_bitmap(bit_off, num_bits);
+
+	ret = ocfs2_journal_access_di(handle,
+			INODE_CACHE(alloc_inode), di_bh, journal_type);
+	if (ret < 0) {
+		mlog_errno(ret);
+		goto out;
+	}
+
+	if (ocfs2_is_cluster_bitmap(alloc_inode))
+		journal_type = OCFS2_JOURNAL_ACCESS_UNDO;
+
+	ret = ocfs2_journal_access_gd(handle,
+			INODE_CACHE(alloc_inode), group_bh, journal_type);
 	if (ret < 0) {
 		mlog_errno(ret);
 		goto out;
 	}
 
+	/* update alloc_dinode counts */
 	tmp_used = le32_to_cpu(di->id1.bitmap1.i_used);
 	di->id1.bitmap1.i_used = cpu_to_le32(num_bits + tmp_used);
 	le32_add_cpu(&cl->cl_recs[chain].c_free, -num_bits);
+
+	/* update bg counts and bitmap*/
+	le16_add_cpu(&bg->bg_free_bits_count, -num_bits);
+	if (le16_to_cpu(bg->bg_free_bits_count) > le16_to_cpu(bg->bg_bits)) {
+		ocfs2_error(alloc_inode->i_sb, "Group descriptor # %llu has bit"
+			" count %u but claims %u are freed. num_bits %d",
+			(unsigned long long)le64_to_cpu(bg->bg_blkno),
+			le16_to_cpu(bg->bg_bits),
+			le16_to_cpu(bg->bg_free_bits_count), num_bits);
+		ret = -EROFS;
+		goto out_rollback;
+	}
+	while (num_bits--)
+		ocfs2_set_bit(bit_off++, bitmap);
+
 	ocfs2_journal_dirty(handle, di_bh);
+	ocfs2_journal_dirty(handle, group_bh);
 
 out:
 	return ret;
+
+out_rollback:
+	le16_add_cpu(&bg->bg_free_bits_count, num_bits);
+
+	di->id1.bitmap1.i_used = cpu_to_le32(tmp_used - num_bits);
+	le32_add_cpu(&cl->cl_recs[chain].c_free, num_bits);
+
+	return ret;
 }
 
 static int ocfs2_bg_discontig_fix_by_rec(struct ocfs2_suballoc_result *res,
@@ -1697,19 +1696,15 @@ static int ocfs2_search_one_group(struct ocfs2_alloc_context *ac,
 	if (ac->ac_find_loc_only)
 		goto out_loc_only;
 
-	ret = ocfs2_alloc_dinode_update_counts(alloc_inode, handle, ac->ac_bh,
-					       res->sr_bits,
-					       le16_to_cpu(gd->bg_chain));
+	ret = ocfs2_alloc_dinode_update_bitmap(handle,
+			alloc_inode, ac->ac_bh, gd, group_bh,
+			le16_to_cpu(gd->bg_chain),
+			res->sr_bit_offset, res->sr_bits);
 	if (ret < 0) {
 		mlog_errno(ret);
 		goto out;
 	}
 
-	ret = ocfs2_block_group_set_bits(handle, alloc_inode, gd, group_bh,
-					 res->sr_bit_offset, res->sr_bits);
-	if (ret < 0)
-		mlog_errno(ret);
-
 out_loc_only:
 	*bits_left = le16_to_cpu(gd->bg_free_bits_count);
 
@@ -1823,20 +1818,9 @@ static int ocfs2_search_chain(struct ocfs2_alloc_context *ac,
 	if (ac->ac_find_loc_only)
 		goto out_loc_only;
 
-	status = ocfs2_alloc_dinode_update_counts(alloc_inode, handle,
-						  ac->ac_bh, res->sr_bits,
-						  chain);
-	if (status) {
-		mlog_errno(status);
-		goto bail;
-	}
-
-	status = ocfs2_block_group_set_bits(handle,
-					    alloc_inode,
-					    bg,
-					    group_bh,
-					    res->sr_bit_offset,
-					    res->sr_bits);
+	status = ocfs2_alloc_dinode_update_bitmap(handle,
+			alloc_inode, ac->ac_bh, bg, group_bh,
+			chain, res->sr_bit_offset, res->sr_bits);
 	if (status < 0) {
 		mlog_errno(status);
 		goto bail;
@@ -2134,20 +2118,9 @@ int ocfs2_claim_new_inode_at_loc(handle_t *handle,
 	bg = (struct ocfs2_group_desc *) bg_bh->b_data;
 	chain = le16_to_cpu(bg->bg_chain);
 
-	ret = ocfs2_alloc_dinode_update_counts(ac->ac_inode, handle,
-					       ac->ac_bh, res->sr_bits,
-					       chain);
-	if (ret) {
-		mlog_errno(ret);
-		goto out;
-	}
-
-	ret = ocfs2_block_group_set_bits(handle,
-					 ac->ac_inode,
-					 bg,
-					 bg_bh,
-					 res->sr_bit_offset,
-					 res->sr_bits);
+	ret = ocfs2_alloc_dinode_update_bitmap(handle,
+			ac->ac_inode, ac->ac_bh, bg, bg_bh,
+			chain, res->sr_bit_offset, res->sr_bits);
 	if (ret < 0) {
 		mlog_errno(ret);
 		goto out;
diff --git a/fs/ocfs2/suballoc.h b/fs/ocfs2/suballoc.h
index 218d803..f704f3a 100644
--- a/fs/ocfs2/suballoc.h
+++ b/fs/ocfs2/suballoc.h
@@ -85,19 +85,14 @@ int ocfs2_reserve_new_inode(struct ocfs2_super *osb,
 int ocfs2_reserve_clusters(struct ocfs2_super *osb,
 			   u32 bits_wanted,
 			   struct ocfs2_alloc_context **ac);
-
-int ocfs2_alloc_dinode_update_counts(struct inode *inode,
-			 handle_t *handle,
-			 struct buffer_head *di_bh,
-			 u32 num_bits,
-			 u16 chain);
-int ocfs2_block_group_set_bits(handle_t *handle,
-			 struct inode *alloc_inode,
-			 struct ocfs2_group_desc *bg,
-			 struct buffer_head *group_bh,
-			 unsigned int bit_off,
-			 unsigned int num_bits);
-
+int ocfs2_alloc_dinode_update_bitmap(handle_t *handle,
+				struct inode *alloc_inode,
+				struct buffer_head *di_bh,
+				struct ocfs2_group_desc *bg,
+				struct buffer_head *group_bh,
+				u16 chain,
+				u32 bit_off,
+				u32 num_bits);
 int ocfs2_claim_metadata(handle_t *handle,
 			 struct ocfs2_alloc_context *ac,
 			 u32 bits_wanted,
-- 
1.7.9.5
