From: Tao Ma <tao.ma@oracle.com>
Date: Thu, 22 Apr 2010 14:40:16 +0800
Subject: [Ocfs2-devel] [PATCH 02/17] ocfs2: Allocate discontiguous block
	groups.
In-Reply-To: <4BCFEF22.7080607@oracle.com>
References: <4BCFEF22.7080607@oracle.com>
Message-ID: <1271918431-8135-2-git-send-email-tao.ma@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

From: Joel Becker <joel.becker@oracle.com>

If we cannot get a contiguous region for a block group, allocate a
discontiguous one when the filesystem supports it.

Signed-off-by: Joel Becker <joel.becker@oracle.com>
Signed-off-by: Tao Ma <tao.ma@oracle.com>
---
 fs/ocfs2/ocfs2.h    |    7 +
 fs/ocfs2/ocfs2_fs.h |   20 ++++
 fs/ocfs2/suballoc.c |  304 ++++++++++++++++++++++++++++++++++++++++++++-------
 3 files changed, 291 insertions(+), 40 deletions(-)

diff --git a/fs/ocfs2/ocfs2.h b/fs/ocfs2/ocfs2.h
index b6d9110..79fe984 100644
--- a/fs/ocfs2/ocfs2.h
+++ b/fs/ocfs2/ocfs2.h
@@ -491,6 +491,13 @@ static inline int ocfs2_supports_indexed_dirs(struct ocfs2_super *osb)
 	return 0;
 }
 
+static inline int ocfs2_supports_discontig_bh(struct ocfs2_super *osb)
+{
+	if (osb->s_feature_incompat & OCFS2_FEATURE_INCOMPAT_DISCONTIG_BG)
+		return 1;
+	return 0;
+}
+
 static inline unsigned int ocfs2_link_max(struct ocfs2_super *osb)
 {
 	if (ocfs2_supports_indexed_dirs(osb))
diff --git a/fs/ocfs2/ocfs2_fs.h b/fs/ocfs2/ocfs2_fs.h
index 448aa8d..888ba4e 100644
--- a/fs/ocfs2/ocfs2_fs.h
+++ b/fs/ocfs2/ocfs2_fs.h
@@ -1278,6 +1278,16 @@ static inline u16 ocfs2_extent_recs_per_eb(struct super_block *sb)
 	return size / sizeof(struct ocfs2_extent_rec);
 }
 
+static inline u16 ocfs2_extent_recs_per_gd(struct super_block *sb)
+{
+	int size;
+
+	size = sb->s_blocksize -
+		offsetof(struct ocfs2_group_desc, bg_list.l_recs);
+
+	return size / sizeof(struct ocfs2_extent_rec);
+}
+
 static inline int ocfs2_dx_entries_per_leaf(struct super_block *sb)
 {
 	int size;
@@ -1430,6 +1440,16 @@ static inline int ocfs2_extent_recs_per_eb(int blocksize)
 	return size / sizeof(struct ocfs2_extent_rec);
 }
 
+static inline int ocfs2_extent_recs_per_gd(int blocksize)
+{
+	int size;
+
+	size = blocksize -
+		offsetof(struct ocfs2_group_desc, bg_list.l_recs);
+
+	return size / sizeof(struct ocfs2_extent_rec);
+}
+
 static inline int ocfs2_local_alloc_size(int blocksize)
 {
 	int size;
diff --git a/fs/ocfs2/suballoc.c b/fs/ocfs2/suballoc.c
index b82a667..9f985c5 100644
--- a/fs/ocfs2/suballoc.c
+++ b/fs/ocfs2/suballoc.c
@@ -60,6 +60,7 @@ static int ocfs2_block_group_fill(handle_t *handle,
 				  struct inode *alloc_inode,
 				  struct buffer_head *bg_bh,
 				  u64 group_blkno,
+				  unsigned int group_clusters,
 				  u16 my_chain,
 				  struct ocfs2_chain_list *cl);
 static int ocfs2_block_group_alloc(struct ocfs2_super *osb,
@@ -330,14 +331,36 @@ out:
 	return rc;
 }
 
+static void ocfs2_bg_discontig_add_extent(struct ocfs2_super *osb,
+					  struct ocfs2_group_desc *bg,
+					  struct ocfs2_chain_list *cl,
+					  u64 p_blkno, u32 clusters)
+{
+	struct ocfs2_extent_list *el = &bg->bg_list;
+	struct ocfs2_extent_rec *rec;
+
+	BUG_ON(!ocfs2_supports_discontig_bh(osb));
+	if (!el->l_next_free_rec)
+		el->l_count = cpu_to_le16(ocfs2_extent_recs_per_gd(osb->sb));
+	rec = &el->l_recs[le16_to_cpu(el->l_next_free_rec)];
+	rec->e_blkno = p_blkno;
+	rec->e_cpos = cpu_to_le32(le16_to_cpu(bg->bg_bits) /
+				  le16_to_cpu(cl->cl_bpc));
+	rec->e_leaf_clusters = cpu_to_le32(clusters);
+	le16_add_cpu(&bg->bg_bits, clusters * le16_to_cpu(cl->cl_bpc));
+	le16_add_cpu(&el->l_next_free_rec, 1);
+}
+
 static int ocfs2_block_group_fill(handle_t *handle,
 				  struct inode *alloc_inode,
 				  struct buffer_head *bg_bh,
 				  u64 group_blkno,
+				  unsigned int group_clusters,
 				  u16 my_chain,
 				  struct ocfs2_chain_list *cl)
 {
 	int status = 0;
+	struct ocfs2_super *osb = OCFS2_SB(alloc_inode->i_sb);
 	struct ocfs2_group_desc *bg = (struct ocfs2_group_desc *) bg_bh->b_data;
 	struct super_block * sb = alloc_inode->i_sb;
 
@@ -365,11 +388,16 @@ static int ocfs2_block_group_fill(handle_t *handle,
 	strcpy(bg->bg_signature, OCFS2_GROUP_DESC_SIGNATURE);
 	bg->bg_generation = cpu_to_le32(OCFS2_SB(sb)->fs_generation);
 	bg->bg_size = cpu_to_le16(ocfs2_group_bitmap_size(sb, 1));
-	bg->bg_bits = cpu_to_le16(ocfs2_bits_per_group(cl));
 	bg->bg_chain = cpu_to_le16(my_chain);
 	bg->bg_next_group = cl->cl_recs[my_chain].c_blkno;
 	bg->bg_parent_dinode = cpu_to_le64(OCFS2_I(alloc_inode)->ip_blkno);
 	bg->bg_blkno = cpu_to_le64(group_blkno);
+	if (group_clusters == le16_to_cpu(cl->cl_cpg))
+		bg->bg_bits = cpu_to_le16(ocfs2_bits_per_group(cl));
+	else
+		ocfs2_bg_discontig_add_extent(osb, bg, cl, bg->bg_blkno,
+					      group_clusters);
+
 	/* set the 1st bit in the bitmap to account for the descriptor block */
 	ocfs2_set_bit(0, (unsigned long *)bg->bg_bitmap);
 	bg->bg_free_bits_count = cpu_to_le16(le16_to_cpu(bg->bg_bits) - 1);
@@ -400,6 +428,218 @@ static inline u16 ocfs2_find_smallest_chain(struct ocfs2_chain_list *cl)
 	return best;
 }
 
+static struct buffer_head *
+ocfs2_block_group_alloc_contig(struct ocfs2_super *osb, handle_t *handle,
+			       struct inode *alloc_inode,
+			       struct ocfs2_alloc_context *ac,
+			       struct ocfs2_chain_list *cl)
+{
+	int status;
+	u32 bit_off, num_bits;
+	u64 bg_blkno;
+	struct buffer_head *bg_bh;
+	unsigned int alloc_rec = ocfs2_find_smallest_chain(cl);
+
+	status = ocfs2_claim_clusters(osb, handle, ac,
+				      le16_to_cpu(cl->cl_cpg), &bit_off,
+				      &num_bits);
+	if (status < 0) {
+		if (status != -ENOSPC)
+			mlog_errno(status);
+		goto bail;
+	}
+
+	/* setup the group */
+	bg_blkno = ocfs2_clusters_to_blocks(osb->sb, bit_off);
+	mlog(0, "new descriptor, record %u, at block %llu\n",
+	     alloc_rec, (unsigned long long)bg_blkno);
+
+	bg_bh = sb_getblk(osb->sb, bg_blkno);
+	if (!bg_bh) {
+		status = -EIO;
+		mlog_errno(status);
+		goto bail;
+	}
+	ocfs2_set_new_buffer_uptodate(INODE_CACHE(alloc_inode), bg_bh);
+
+	status = ocfs2_block_group_fill(handle, alloc_inode, bg_bh,
+					bg_blkno, num_bits, alloc_rec, cl);
+	if (status < 0) {
+		brelse(bg_bh);
+		mlog_errno(status);
+	}
+
+bail:
+	return status ? ERR_PTR(status) : bg_bh;
+}
+
+static int ocfs2_block_group_claim_bits(struct ocfs2_super *osb,
+					handle_t *handle,
+					struct ocfs2_alloc_context *ac,
+					unsigned int min_bits,
+					u32 *bit_off, u32 *num_bits)
+{
+	int status;
+
+	while (min_bits) {
+		status = ocfs2_claim_clusters(osb, handle, ac, min_bits,
+					      bit_off, num_bits);
+		if (status != -ENOSPC)
+			break;
+
+		min_bits >>= 1;
+	}
+
+	return status;
+}
+
+static int ocfs2_block_group_grow_discontig(handle_t *handle,
+					    struct inode *alloc_inode,
+					    struct buffer_head *bg_bh,
+					    struct ocfs2_alloc_context *ac,
+					    struct ocfs2_chain_list *cl,
+					    unsigned int min_bits)
+{
+	int status;
+	struct ocfs2_super *osb = OCFS2_SB(alloc_inode->i_sb);
+	struct ocfs2_group_desc *bg =
+		(struct ocfs2_group_desc *)bg_bh->b_data;
+	unsigned int needed =
+		ocfs2_bits_per_group(cl) - le16_to_cpu(bg->bg_bits);
+	u32 p_cpos, clusters;
+	u64 p_blkno;
+	struct ocfs2_extent_list *el = &bg->bg_list;
+
+	status = ocfs2_journal_access_gd(handle,
+					 INODE_CACHE(alloc_inode),
+					 bg_bh,
+					 OCFS2_JOURNAL_ACCESS_CREATE);
+	if (status < 0) {
+		mlog_errno(status);
+		goto bail;
+	}
+
+	while ((needed > 0) && (le16_to_cpu(el->l_next_free_rec) <
+				le16_to_cpu(el->l_count))) {
+		status = ocfs2_extend_trans(handle, OCFS2_SUBALLOC_ALLOC);
+		if (status) {
+			mlog_errno(status);
+			goto bail;
+		}
+
+		if (min_bits > needed)
+			min_bits = needed;
+		status = ocfs2_block_group_claim_bits(osb, handle, ac,
+						      min_bits, &p_cpos,
+						      &clusters);
+		if (status < 0) {
+			if (status != -ENOSPC)
+				mlog_errno(status);
+			goto bail;
+		}
+		p_blkno = ocfs2_clusters_to_blocks(osb->sb, p_cpos);
+		ocfs2_bg_discontig_add_extent(osb, bg, cl, p_blkno,
+					      clusters);
+
+		min_bits = clusters;
+		needed = ocfs2_bits_per_group(cl) - le16_to_cpu(bg->bg_bits);
+	}
+
+	if (needed > 0) {
+	}
+
+	ocfs2_journal_dirty(handle, bg_bh);
+
+bail:
+	return status;
+}
+
+static void ocfs2_bg_alloc_cleanup(struct inode *alloc_inode,
+				   struct buffer_head *bg_bh,
+				   struct ocfs2_cached_dealloc_ctxt *dealloc)
+{
+	int i;
+	struct ocfs2_group_desc *bg;
+	struct ocfs2_extent_list *el;
+	struct ocfs2_extent_rec *rec;
+
+	if (!bg_bh)
+		return;
+
+	bg = (struct ocfs2_group_desc *)bg_bh->b_data;
+	el = &bg->bg_list;
+	for (i = 0; i < le16_to_cpu(el->l_next_free_rec); i++) {
+		rec = &el->l_recs[i];
+		ocfs2_cache_cluster_dealloc(dealloc,
+					    le64_to_cpu(rec->e_blkno),
+					    le32_to_cpu(rec->e_leaf_clusters));
+	}
+
+	ocfs2_remove_from_cache(INODE_CACHE(alloc_inode), bg_bh);
+	brelse(bg_bh);
+}
+
+static struct buffer_head *
+ocfs2_block_group_alloc_discontig(handle_t *handle,
+				  struct inode *alloc_inode,
+				  struct ocfs2_alloc_context *ac,
+				  struct ocfs2_chain_list *cl,
+				  struct ocfs2_cached_dealloc_ctxt *dealloc)
+{
+	int status;
+	u32 bit_off, num_bits;
+	u64 bg_blkno;
+	unsigned int min_bits = le16_to_cpu(cl->cl_cpg) >> 1;
+	struct buffer_head *bg_bh = NULL;
+	unsigned int alloc_rec = ocfs2_find_smallest_chain(cl);
+	struct ocfs2_super *osb = OCFS2_SB(alloc_inode->i_sb);
+
+	if (!ocfs2_supports_discontig_bh(osb)) {
+		status = -ENOSPC;
+		goto bail;
+	}
+
+	/* Claim the first region */
+	status = ocfs2_block_group_claim_bits(osb, handle, ac, min_bits,
+					      &bit_off, &num_bits);
+	if (status < 0) {
+		if (status != -ENOSPC)
+			mlog_errno(status);
+		goto bail;
+	}
+	min_bits = num_bits;
+
+	/* setup the group */
+	bg_blkno = ocfs2_clusters_to_blocks(osb->sb, bit_off);
+	mlog(0, "new descriptor, record %u, at block %llu\n",
+	     alloc_rec, (unsigned long long)bg_blkno);
+
+	bg_bh = sb_getblk(osb->sb, bg_blkno);
+	if (!bg_bh) {
+		status = -EIO;
+		mlog_errno(status);
+		goto bail;
+	}
+	ocfs2_set_new_buffer_uptodate(INODE_CACHE(alloc_inode), bg_bh);
+
+	status = ocfs2_block_group_fill(handle, alloc_inode, bg_bh,
+					bg_blkno, num_bits, alloc_rec, cl);
+	if (status < 0) {
+		mlog_errno(status);
+		goto bail;
+	}
+
+	status = ocfs2_block_group_grow_discontig(handle, alloc_inode,
+						  bg_bh, ac, cl, min_bits);
+	if (status)
+		mlog_errno(status);
+
+bail:
+	if (status)
+		ocfs2_bg_alloc_cleanup(alloc_inode, bg_bh, dealloc);
+	return status ? ERR_PTR(status) : bg_bh;
+}
+
 /*
  * We expect the block group allocator to already be locked.
  */
@@ -415,16 +655,17 @@ static int ocfs2_block_group_alloc(struct ocfs2_super *osb,
 	struct ocfs2_chain_list *cl;
 	struct ocfs2_alloc_context *ac = NULL;
 	handle_t *handle = NULL;
-	u32 bit_off, num_bits;
-	u16 alloc_rec;
 	u64 bg_blkno;
 	struct buffer_head *bg_bh = NULL;
 	struct ocfs2_group_desc *bg;
+	struct ocfs2_cached_dealloc_ctxt dealloc;
 
 	BUG_ON(ocfs2_is_cluster_bitmap(alloc_inode));
 
 	mlog_entry_void();
 
+	ocfs2_init_dealloc_ctxt(&dealloc);
+
 	cl = &fe->id2.i_chain;
 	status = ocfs2_reserve_clusters_with_limit(osb,
 						   le16_to_cpu(cl->cl_cpg),
@@ -450,44 +691,21 @@ static int ocfs2_block_group_alloc(struct ocfs2_super *osb,
 		     (unsigned long long)*last_alloc_group);
 		ac->ac_last_group = *last_alloc_group;
 	}
-	status = ocfs2_claim_clusters(osb,
-				      handle,
-				      ac,
-				      le16_to_cpu(cl->cl_cpg),
-				      &bit_off,
-				      &num_bits);
-	if (status < 0) {
+
+	bg_bh = ocfs2_block_group_alloc_contig(osb, handle, alloc_inode,
+					       ac, cl);
+	if (IS_ERR(bg_bh) && (PTR_ERR(bg_bh) == -ENOSPC))
+		bg_bh = ocfs2_block_group_alloc_discontig(handle,
+							  alloc_inode,
+							  ac, cl,
+							  &dealloc);
+	if (IS_ERR(bg_bh)) {
+		status = PTR_ERR(bg_bh);
+		bg_bh = NULL;
 		if (status != -ENOSPC)
 			mlog_errno(status);
 		goto bail;
 	}
-
-	alloc_rec = ocfs2_find_smallest_chain(cl);
-
-	/* setup the group */
-	bg_blkno = ocfs2_clusters_to_blocks(osb->sb, bit_off);
-	mlog(0, "new descriptor, record %u, at block %llu\n",
-	     alloc_rec, (unsigned long long)bg_blkno);
-
-	bg_bh = sb_getblk(osb->sb, bg_blkno);
-	if (!bg_bh) {
-		status = -EIO;
-		mlog_errno(status);
-		goto bail;
-	}
-	ocfs2_set_new_buffer_uptodate(INODE_CACHE(alloc_inode), bg_bh);
-
-	status = ocfs2_block_group_fill(handle,
-					alloc_inode,
-					bg_bh,
-					bg_blkno,
-					alloc_rec,
-					cl);
-	if (status < 0) {
-		mlog_errno(status);
-		goto bail;
-	}
-
 	bg = (struct ocfs2_group_desc *) bg_bh->b_data;
 
 	status = ocfs2_journal_access_di(handle, INODE_CACHE(alloc_inode),
@@ -497,10 +715,11 @@ static int ocfs2_block_group_alloc(struct ocfs2_super *osb,
 		goto bail;
 	}
 
-	le32_add_cpu(&cl->cl_recs[alloc_rec].c_free,
+	le32_add_cpu(&cl->cl_recs[bg->bg_chain].c_free,
 		     le16_to_cpu(bg->bg_free_bits_count));
-	le32_add_cpu(&cl->cl_recs[alloc_rec].c_total, le16_to_cpu(bg->bg_bits));
-	cl->cl_recs[alloc_rec].c_blkno  = cpu_to_le64(bg_blkno);
+	le32_add_cpu(&cl->cl_recs[bg->bg_chain].c_total,
+		     le16_to_cpu(bg->bg_bits));
+	cl->cl_recs[bg->bg_chain].c_blkno  = cpu_to_le64(bg_blkno);
 	if (le16_to_cpu(cl->cl_next_free_rec) < le16_to_cpu(cl->cl_count))
 		le16_add_cpu(&cl->cl_next_free_rec, 1);
 
@@ -529,6 +748,11 @@ bail:
 	if (handle)
 		ocfs2_commit_trans(osb, handle);
 
+	if (ocfs2_dealloc_has_cluster(&dealloc)) {
+		ocfs2_schedule_truncate_log_flush(osb, 1);
+		ocfs2_run_deallocs(osb, &dealloc);
+	}
+
 	if (ac)
 		ocfs2_free_alloc_context(ac);
 
-- 
1.5.5
