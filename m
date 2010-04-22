From: Tao Ma <tao.ma@oracle.com>
Date: Thu, 22 Apr 2010 14:40:21 +0800
Subject: [Ocfs2-devel] [PATCH 07/17] ocfs2: ocfs2_claim_*() don't need an
	ocfs2_super argument.
In-Reply-To: <4BCFEF22.7080607@oracle.com>
References: <4BCFEF22.7080607@oracle.com>
Message-ID: <1271918431-8135-7-git-send-email-tao.ma@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

From: Joel Becker <joel.becker@oracle.com>

They all take an ocfs2_alloc_context, which has the allocation inode.

Signed-off-by: Joel Becker <joel.becker@oracle.com>
Signed-off-by: Tao Ma <tao.ma@oracle.com>
---
 fs/ocfs2/alloc.c        |    7 +++----
 fs/ocfs2/dir.c          |    8 ++++----
 fs/ocfs2/localalloc.c   |    4 ++--
 fs/ocfs2/namei.c        |    2 +-
 fs/ocfs2/refcounttree.c |    8 ++++----
 fs/ocfs2/suballoc.c     |   23 ++++++++++-------------
 fs/ocfs2/suballoc.h     |   12 ++++--------
 fs/ocfs2/xattr.c        |   13 ++++++-------
 8 files changed, 34 insertions(+), 43 deletions(-)

diff --git a/fs/ocfs2/alloc.c b/fs/ocfs2/alloc.c
index a74ea70..e12c623 100644
--- a/fs/ocfs2/alloc.c
+++ b/fs/ocfs2/alloc.c
@@ -1015,8 +1015,7 @@ static int ocfs2_create_new_meta_bhs(handle_t *handle,
 
 	count = 0;
 	while (count < wanted) {
-		status = ocfs2_claim_metadata(osb,
-					      handle,
+		status = ocfs2_claim_metadata(handle,
 					      meta_ac,
 					      wanted - count,
 					      &suballoc_bit_start,
@@ -4798,7 +4797,7 @@ int ocfs2_add_clusters_in_btree(handle_t *handle,
 		goto leave;
 	}
 
-	status = __ocfs2_claim_clusters(osb, handle, data_ac, 1,
+	status = __ocfs2_claim_clusters(handle, data_ac, 1,
 					clusters_to_add, &bit_off, &num_bits);
 	if (status < 0) {
 		if (status != -ENOSPC)
@@ -7213,7 +7212,7 @@ int ocfs2_convert_inline_data_to_extents(struct inode *inode,
 
 		data_ac->ac_resv = &OCFS2_I(inode)->ip_la_data_resv;
 
-		ret = ocfs2_claim_clusters(osb, handle, data_ac, 1, &bit_off,
+		ret = ocfs2_claim_clusters(handle, data_ac, 1, &bit_off,
 					   &num);
 		if (ret) {
 			mlog_errno(ret);
diff --git a/fs/ocfs2/dir.c b/fs/ocfs2/dir.c
index 6c9a28a..02c3f22 100644
--- a/fs/ocfs2/dir.c
+++ b/fs/ocfs2/dir.c
@@ -2402,7 +2402,7 @@ static int ocfs2_dx_dir_attach_index(struct ocfs2_super *osb,
 	struct ocfs2_dir_block_trailer *trailer =
 		ocfs2_trailer_from_bh(dirdata_bh, dir->i_sb);
 
-	ret = ocfs2_claim_metadata(osb, handle, meta_ac, 1, &dr_suballoc_bit,
+	ret = ocfs2_claim_metadata(handle, meta_ac, 1, &dr_suballoc_bit,
 				   &num_bits, &dr_blkno);
 	if (ret) {
 		mlog_errno(ret);
@@ -2544,7 +2544,7 @@ static int __ocfs2_dx_dir_new_cluster(struct inode *dir,
 	 * chance of contiguousness as the directory grows in number
 	 * of entries.
 	 */
-	ret = __ocfs2_claim_clusters(osb, handle, data_ac, 1, 1, &phys, &num);
+	ret = __ocfs2_claim_clusters(handle, data_ac, 1, 1, &phys, &num);
 	if (ret) {
 		mlog_errno(ret);
 		goto out;
@@ -2979,7 +2979,7 @@ static int ocfs2_expand_inline_dir(struct inode *dir, struct buffer_head *di_bh,
 	 */
 	if (ocfs2_dir_resv_allowed(osb))
 		data_ac->ac_resv = &oi->ip_la_data_resv;
-	ret = ocfs2_claim_clusters(osb, handle, data_ac, 1, &bit_off, &len);
+	ret = ocfs2_claim_clusters(handle, data_ac, 1, &bit_off, &len);
 	if (ret) {
 		mlog_errno(ret);
 		goto out_commit;
@@ -3118,7 +3118,7 @@ static int ocfs2_expand_inline_dir(struct inode *dir, struct buffer_head *di_bh,
 	 * pass. Claim the 2nd cluster as a separate extent.
 	 */
 	if (alloc > len) {
-		ret = ocfs2_claim_clusters(osb, handle, data_ac, 1, &bit_off,
+		ret = ocfs2_claim_clusters(handle, data_ac, 1, &bit_off,
 					   &len);
 		if (ret) {
 			mlog_errno(ret);
diff --git a/fs/ocfs2/localalloc.c b/fs/ocfs2/localalloc.c
index cb06315..4aa83df 100644
--- a/fs/ocfs2/localalloc.c
+++ b/fs/ocfs2/localalloc.c
@@ -1163,7 +1163,7 @@ static int ocfs2_local_alloc_new_window(struct ocfs2_super *osb,
 	/* we used the generic suballoc reserve function, but we set
 	 * everything up nicely, so there's no reason why we can't use
 	 * the more specific cluster api to claim bits. */
-	status = ocfs2_claim_clusters(osb, handle, ac, osb->local_alloc_bits,
+	status = ocfs2_claim_clusters(handle, ac, osb->local_alloc_bits,
 				      &cluster_off, &cluster_count);
 	if (status == -ENOSPC) {
 retry_enospc:
@@ -1176,7 +1176,7 @@ retry_enospc:
 		    OCFS2_LA_DISABLED)
 			goto bail;
 
-		status = ocfs2_claim_clusters(osb, handle, ac,
+		status = ocfs2_claim_clusters(handle, ac,
 					      osb->local_alloc_bits,
 					      &cluster_off,
 					      &cluster_count);
diff --git a/fs/ocfs2/namei.c b/fs/ocfs2/namei.c
index 21d4a33..e5434a0 100644
--- a/fs/ocfs2/namei.c
+++ b/fs/ocfs2/namei.c
@@ -478,7 +478,7 @@ static int ocfs2_mknod_locked(struct ocfs2_super *osb,
 
 	*new_fe_bh = NULL;
 
-	status = ocfs2_claim_new_inode(osb, handle, dir, parent_fe_bh,
+	status = ocfs2_claim_new_inode(handle, dir, parent_fe_bh,
 				       inode_ac, &suballoc_bit, &fe_blkno);
 	if (status < 0) {
 		mlog_errno(status);
diff --git a/fs/ocfs2/refcounttree.c b/fs/ocfs2/refcounttree.c
index 44d3e1c..472db83 100644
--- a/fs/ocfs2/refcounttree.c
+++ b/fs/ocfs2/refcounttree.c
@@ -597,7 +597,7 @@ static int ocfs2_create_refcount_tree(struct inode *inode,
 		goto out_commit;
 	}
 
-	ret = ocfs2_claim_metadata(osb, handle, meta_ac, 1,
+	ret = ocfs2_claim_metadata(handle, meta_ac, 1,
 				   &suballoc_bit_start, &num_got,
 				   &first_blkno);
 	if (ret) {
@@ -1297,7 +1297,7 @@ static int ocfs2_expand_inline_ref_root(handle_t *handle,
 		goto out;
 	}
 
-	ret = ocfs2_claim_metadata(OCFS2_SB(sb), handle, meta_ac, 1,
+	ret = ocfs2_claim_metadata(handle, meta_ac, 1,
 				   &suballoc_bit_start, &num_got,
 				   &blkno);
 	if (ret) {
@@ -1547,7 +1547,7 @@ static int ocfs2_new_leaf_refcount_block(handle_t *handle,
 		goto out;
 	}
 
-	ret = ocfs2_claim_metadata(OCFS2_SB(sb), handle, meta_ac, 1,
+	ret = ocfs2_claim_metadata(handle, meta_ac, 1,
 				   &suballoc_bit_start, &num_got,
 				   &blkno);
 	if (ret) {
@@ -3271,7 +3271,7 @@ static int ocfs2_make_clusters_writable(struct super_block *sb,
 		} else {
 			delete = 1;
 
-			ret = __ocfs2_claim_clusters(osb, handle,
+			ret = __ocfs2_claim_clusters(handle,
 						     context->data_ac,
 						     1, set_len,
 						     &new_bit, &new_len);
diff --git a/fs/ocfs2/suballoc.c b/fs/ocfs2/suballoc.c
index 9e1c776..34f3fbb 100644
--- a/fs/ocfs2/suballoc.c
+++ b/fs/ocfs2/suballoc.c
@@ -443,7 +443,7 @@ ocfs2_block_group_alloc_contig(struct ocfs2_super *osb, handle_t *handle,
 	struct buffer_head *bg_bh;
 	unsigned int alloc_rec = ocfs2_find_smallest_chain(cl);
 
-	status = ocfs2_claim_clusters(osb, handle, ac,
+	status = ocfs2_claim_clusters(handle, ac,
 				      le16_to_cpu(cl->cl_cpg), &bit_off,
 				      &num_bits);
 	if (status < 0) {
@@ -485,7 +485,7 @@ static int ocfs2_block_group_claim_bits(struct ocfs2_super *osb,
 	int status;
 
 	while (min_bits) {
-		status = ocfs2_claim_clusters(osb, handle, ac, min_bits,
+		status = ocfs2_claim_clusters(handle, ac, min_bits,
 					      bit_off, num_bits);
 		if (status != -ENOSPC)
 			break;
@@ -1923,8 +1923,7 @@ bail:
 	return status;
 }
 
-int ocfs2_claim_metadata(struct ocfs2_super *osb,
-			 handle_t *handle,
+int ocfs2_claim_metadata(handle_t *handle,
 			 struct ocfs2_alloc_context *ac,
 			 u32 bits_wanted,
 			 u16 *suballoc_bit_start,
@@ -1947,7 +1946,7 @@ int ocfs2_claim_metadata(struct ocfs2_super *osb,
 		mlog_errno(status);
 		goto bail;
 	}
-	atomic_inc(&osb->alloc_stats.bg_allocs);
+	atomic_inc(&OCFS2_SB(ac->ac_inode->i_sb)->alloc_stats.bg_allocs);
 
 	*suballoc_bit_start = res.sr_bit_offset;
 	*blkno_start = res.sr_bg_blkno + (u64)(res.sr_bit_offset);
@@ -1990,8 +1989,7 @@ static inline void ocfs2_save_inode_ac_group(struct inode *dir,
 	OCFS2_I(dir)->ip_last_used_slot = ac->ac_alloc_slot;
 }
 
-int ocfs2_claim_new_inode(struct ocfs2_super *osb,
-			  handle_t *handle,
+int ocfs2_claim_new_inode(handle_t *handle,
 			  struct inode *dir,
 			  struct buffer_head *parent_fe_bh,
 			  struct ocfs2_alloc_context *ac,
@@ -2019,7 +2017,7 @@ int ocfs2_claim_new_inode(struct ocfs2_super *osb,
 		mlog_errno(status);
 		goto bail;
 	}
-	atomic_inc(&osb->alloc_stats.bg_allocs);
+	atomic_inc(&OCFS2_SB(ac->ac_inode->i_sb)->alloc_stats.bg_allocs);
 
 	BUG_ON(res.sr_bits != 1);
 
@@ -2094,8 +2092,7 @@ static inline void ocfs2_block_to_cluster_group(struct inode *inode,
  * contig. allocation, set to '1' to indicate we can deal with extents
  * of any size.
  */
-int __ocfs2_claim_clusters(struct ocfs2_super *osb,
-			   handle_t *handle,
+int __ocfs2_claim_clusters(handle_t *handle,
 			   struct ocfs2_alloc_context *ac,
 			   u32 min_clusters,
 			   u32 max_clusters,
@@ -2105,6 +2102,7 @@ int __ocfs2_claim_clusters(struct ocfs2_super *osb,
 	int status;
 	unsigned int bits_wanted = max_clusters;
 	struct ocfs2_suballoc_result res;
+	struct ocfs2_super *osb = OCFS2_SB(ac->ac_inode->i_sb);
 
 	mlog_entry_void();
 
@@ -2165,8 +2163,7 @@ bail:
 	return status;
 }
 
-int ocfs2_claim_clusters(struct ocfs2_super *osb,
-			 handle_t *handle,
+int ocfs2_claim_clusters(handle_t *handle,
 			 struct ocfs2_alloc_context *ac,
 			 u32 min_clusters,
 			 u32 *cluster_start,
@@ -2174,7 +2171,7 @@ int ocfs2_claim_clusters(struct ocfs2_super *osb,
 {
 	unsigned int bits_wanted = ac->ac_bits_wanted - ac->ac_bits_given;
 
-	return __ocfs2_claim_clusters(osb, handle, ac, min_clusters,
+	return __ocfs2_claim_clusters(handle, ac, min_clusters,
 				      bits_wanted, cluster_start, num_clusters);
 }
 
diff --git a/fs/ocfs2/suballoc.h b/fs/ocfs2/suballoc.h
index 26a5ad3..2bc505a 100644
--- a/fs/ocfs2/suballoc.h
+++ b/fs/ocfs2/suballoc.h
@@ -83,22 +83,19 @@ int ocfs2_reserve_clusters(struct ocfs2_super *osb,
 			   u32 bits_wanted,
 			   struct ocfs2_alloc_context **ac);
 
-int ocfs2_claim_metadata(struct ocfs2_super *osb,
-			 handle_t *handle,
+int ocfs2_claim_metadata(handle_t *handle,
 			 struct ocfs2_alloc_context *ac,
 			 u32 bits_wanted,
 			 u16 *suballoc_bit_start,
 			 u32 *num_bits,
 			 u64 *blkno_start);
-int ocfs2_claim_new_inode(struct ocfs2_super *osb,
-			  handle_t *handle,
+int ocfs2_claim_new_inode(handle_t *handle,
 			  struct inode *dir,
 			  struct buffer_head *parent_fe_bh,
 			  struct ocfs2_alloc_context *ac,
 			  u16 *suballoc_bit,
 			  u64 *fe_blkno);
-int ocfs2_claim_clusters(struct ocfs2_super *osb,
-			 handle_t *handle,
+int ocfs2_claim_clusters(handle_t *handle,
 			 struct ocfs2_alloc_context *ac,
 			 u32 min_clusters,
 			 u32 *cluster_start,
@@ -107,8 +104,7 @@ int ocfs2_claim_clusters(struct ocfs2_super *osb,
  * Use this variant of ocfs2_claim_clusters to specify a maxiumum
  * number of clusters smaller than the allocation reserved.
  */
-int __ocfs2_claim_clusters(struct ocfs2_super *osb,
-			   handle_t *handle,
+int __ocfs2_claim_clusters(handle_t *handle,
 			   struct ocfs2_alloc_context *ac,
 			   u32 min_clusters,
 			   u32 max_clusters,
diff --git a/fs/ocfs2/xattr.c b/fs/ocfs2/xattr.c
index 26f704c..49a15c4 100644
--- a/fs/ocfs2/xattr.c
+++ b/fs/ocfs2/xattr.c
@@ -2831,7 +2831,6 @@ static int ocfs2_create_xattr_block(struct inode *inode,
 	u32 num_got;
 	u64 first_blkno;
 	struct ocfs2_dinode *di =  (struct ocfs2_dinode *)inode_bh->b_data;
-	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
 	struct buffer_head *new_bh = NULL;
 	struct ocfs2_xattr_block *xblk;
 
@@ -2842,7 +2841,7 @@ static int ocfs2_create_xattr_block(struct inode *inode,
 		goto end;
 	}
 
-	ret = ocfs2_claim_metadata(osb, ctxt->handle, ctxt->meta_ac, 1,
+	ret = ocfs2_claim_metadata(ctxt->handle, ctxt->meta_ac, 1,
 				   &suballoc_bit_start, &num_got,
 				   &first_blkno);
 	if (ret < 0) {
@@ -2867,7 +2866,8 @@ static int ocfs2_create_xattr_block(struct inode *inode,
 	strcpy((void *)xblk, OCFS2_XATTR_BLOCK_SIGNATURE);
 	xblk->xb_suballoc_slot = cpu_to_le16(ctxt->meta_ac->ac_alloc_slot);
 	xblk->xb_suballoc_bit = cpu_to_le16(suballoc_bit_start);
-	xblk->xb_fs_generation = cpu_to_le32(osb->fs_generation);
+	xblk->xb_fs_generation =
+		cpu_to_le32(OCFS2_SB(inode->i_sb)->fs_generation);
 	xblk->xb_blkno = cpu_to_le64(first_blkno);
 	if (indexed) {
 		struct ocfs2_xattr_tree_root *xr = &xblk->xb_attrs.xb_root;
@@ -4232,7 +4232,6 @@ static int ocfs2_xattr_create_index_block(struct inode *inode,
 	u32 bit_off, len;
 	u64 blkno;
 	handle_t *handle = ctxt->handle;
-	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
 	struct ocfs2_inode_info *oi = OCFS2_I(inode);
 	struct buffer_head *xb_bh = xs->xattr_bh;
 	struct ocfs2_xattr_block *xb =
@@ -4260,7 +4259,7 @@ static int ocfs2_xattr_create_index_block(struct inode *inode,
 		goto out;
 	}
 
-	ret = __ocfs2_claim_clusters(osb, handle, ctxt->data_ac,
+	ret = __ocfs2_claim_clusters(handle, ctxt->data_ac,
 				     1, 1, &bit_off, &len);
 	if (ret) {
 		mlog_errno(ret);
@@ -5082,7 +5081,7 @@ static int ocfs2_add_new_xattr_cluster(struct inode *inode,
 		goto leave;
 	}
 
-	ret = __ocfs2_claim_clusters(osb, handle, ctxt->data_ac, 1,
+	ret = __ocfs2_claim_clusters(handle, ctxt->data_ac, 1,
 				     clusters_to_add, &bit_off, &num_bits);
 	if (ret < 0) {
 		if (ret != -ENOSPC)
@@ -6913,7 +6912,7 @@ static int ocfs2_reflink_xattr_rec(struct inode *inode,
 		goto out;
 	}
 
-	ret = ocfs2_claim_clusters(osb, handle, data_ac,
+	ret = ocfs2_claim_clusters(handle, data_ac,
 				   len, &p_cluster, &num_clusters);
 	if (ret) {
 		mlog_errno(ret);
-- 
1.5.5
