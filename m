From: Tao Ma <tao.ma@oracle.com>
Date: Thu,  1 Apr 2010 10:59:04 +0800
Subject: [Ocfs2-devel] [PATCH 07/15] ocfs2: ocfs2_claim_*() don't need an
	ocfs2_super argument.
In-Reply-To: <4BB40AB4.8040205@oracle.com>
References: <4BB40AB4.8040205@oracle.com>
Message-ID: <1270090752-18935-7-git-send-email-tao.ma@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

From: Joel Becker <joel.becker@oracle.com>

They all take an ocfs2_alloc_context, which has the allocation inode.

Signed-off-by: Joel Becker <joel.becker@oracle.com>
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
index 9f8bd91..57d7f7a 100644
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
@@ -4866,7 +4865,7 @@ int ocfs2_add_clusters_in_btree(handle_t *handle,
 		goto leave;
 	}
 
-	status = __ocfs2_claim_clusters(osb, handle, data_ac, 1,
+	status = __ocfs2_claim_clusters(handle, data_ac, 1,
 					clusters_to_add, &bit_off, &num_bits);
 	if (status < 0) {
 		if (status != -ENOSPC)
@@ -7307,7 +7306,7 @@ int ocfs2_convert_inline_data_to_extents(struct inode *inode,
 			goto out_commit;
 		did_quota = 1;
 
-		ret = ocfs2_claim_clusters(osb, handle, data_ac, 1, &bit_off,
+		ret = ocfs2_claim_clusters(handle, data_ac, 1, &bit_off,
 					   &num);
 		if (ret) {
 			mlog_errno(ret);
diff --git a/fs/ocfs2/dir.c b/fs/ocfs2/dir.c
index efd77d0..06522b5 100644
--- a/fs/ocfs2/dir.c
+++ b/fs/ocfs2/dir.c
@@ -2411,7 +2411,7 @@ static int ocfs2_dx_dir_attach_index(struct ocfs2_super *osb,
 	struct ocfs2_dir_block_trailer *trailer =
 		ocfs2_trailer_from_bh(dirdata_bh, dir->i_sb);
 
-	ret = ocfs2_claim_metadata(osb, handle, meta_ac, 1, &dr_suballoc_bit,
+	ret = ocfs2_claim_metadata(handle, meta_ac, 1, &dr_suballoc_bit,
 				   &num_bits, &dr_blkno);
 	if (ret) {
 		mlog_errno(ret);
@@ -2558,7 +2558,7 @@ static int __ocfs2_dx_dir_new_cluster(struct inode *dir,
 	 * chance of contiguousness as the directory grows in number
 	 * of entries.
 	 */
-	ret = __ocfs2_claim_clusters(osb, handle, data_ac, 1, 1, &phys, &num);
+	ret = __ocfs2_claim_clusters(handle, data_ac, 1, 1, &phys, &num);
 	if (ret) {
 		mlog_errno(ret);
 		goto out;
@@ -2991,7 +2991,7 @@ static int ocfs2_expand_inline_dir(struct inode *dir, struct buffer_head *di_bh,
 	 * if we only get one now, that's enough to continue. The rest
 	 * will be claimed after the conversion to extents.
 	 */
-	ret = ocfs2_claim_clusters(osb, handle, data_ac, 1, &bit_off, &len);
+	ret = ocfs2_claim_clusters(handle, data_ac, 1, &bit_off, &len);
 	if (ret) {
 		mlog_errno(ret);
 		goto out_commit;
@@ -3138,7 +3138,7 @@ static int ocfs2_expand_inline_dir(struct inode *dir, struct buffer_head *di_bh,
 	 * pass. Claim the 2nd cluster as a separate extent.
 	 */
 	if (alloc > len) {
-		ret = ocfs2_claim_clusters(osb, handle, data_ac, 1, &bit_off,
+		ret = ocfs2_claim_clusters(handle, data_ac, 1, &bit_off,
 					   &len);
 		if (ret) {
 			mlog_errno(ret);
diff --git a/fs/ocfs2/localalloc.c b/fs/ocfs2/localalloc.c
index ca992d9..e51d75c 100644
--- a/fs/ocfs2/localalloc.c
+++ b/fs/ocfs2/localalloc.c
@@ -1048,7 +1048,7 @@ static int ocfs2_local_alloc_new_window(struct ocfs2_super *osb,
 	/* we used the generic suballoc reserve function, but we set
 	 * everything up nicely, so there's no reason why we can't use
 	 * the more specific cluster api to claim bits. */
-	status = ocfs2_claim_clusters(osb, handle, ac, osb->local_alloc_bits,
+	status = ocfs2_claim_clusters(handle, ac, osb->local_alloc_bits,
 				      &cluster_off, &cluster_count);
 	if (status == -ENOSPC) {
 retry_enospc:
@@ -1061,7 +1061,7 @@ retry_enospc:
 		    OCFS2_LA_DISABLED)
 			goto bail;
 
-		status = ocfs2_claim_clusters(osb, handle, ac,
+		status = ocfs2_claim_clusters(handle, ac,
 					      osb->local_alloc_bits,
 					      &cluster_off,
 					      &cluster_count);
diff --git a/fs/ocfs2/namei.c b/fs/ocfs2/namei.c
index d9cd4e3..9c3e1fe 100644
--- a/fs/ocfs2/namei.c
+++ b/fs/ocfs2/namei.c
@@ -482,7 +482,7 @@ static int ocfs2_mknod_locked(struct ocfs2_super *osb,
 
 	*new_fe_bh = NULL;
 
-	status = ocfs2_claim_new_inode(osb, handle, dir, parent_fe_bh,
+	status = ocfs2_claim_new_inode(handle, dir, parent_fe_bh,
 				       inode_ac, &suballoc_bit, &fe_blkno);
 	if (status < 0) {
 		mlog_errno(status);
diff --git a/fs/ocfs2/refcounttree.c b/fs/ocfs2/refcounttree.c
index 9e96921..4fb18af 100644
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
@@ -1299,7 +1299,7 @@ static int ocfs2_expand_inline_ref_root(handle_t *handle,
 		goto out;
 	}
 
-	ret = ocfs2_claim_metadata(OCFS2_SB(sb), handle, meta_ac, 1,
+	ret = ocfs2_claim_metadata(handle, meta_ac, 1,
 				   &suballoc_bit_start, &num_got,
 				   &blkno);
 	if (ret) {
@@ -1549,7 +1549,7 @@ static int ocfs2_new_leaf_refcount_block(handle_t *handle,
 		goto out;
 	}
 
-	ret = ocfs2_claim_metadata(OCFS2_SB(sb), handle, meta_ac, 1,
+	ret = ocfs2_claim_metadata(handle, meta_ac, 1,
 				   &suballoc_bit_start, &num_got,
 				   &blkno);
 	if (ret) {
@@ -3283,7 +3283,7 @@ static int ocfs2_make_clusters_writable(struct super_block *sb,
 		} else {
 			delete = 1;
 
-			ret = __ocfs2_claim_clusters(osb, handle,
+			ret = __ocfs2_claim_clusters(handle,
 						     context->data_ac,
 						     1, set_len,
 						     &new_bit, &new_len);
diff --git a/fs/ocfs2/suballoc.c b/fs/ocfs2/suballoc.c
index 1910f09..0fd0357 100644
--- a/fs/ocfs2/suballoc.c
+++ b/fs/ocfs2/suballoc.c
@@ -444,7 +444,7 @@ ocfs2_block_group_alloc_contig(struct ocfs2_super *osb, handle_t *handle,
 	struct buffer_head *bg_bh;
 	unsigned int alloc_rec = ocfs2_find_smallest_chain(cl);
 
-	status = ocfs2_claim_clusters(osb, handle, ac,
+	status = ocfs2_claim_clusters(handle, ac,
 				      le16_to_cpu(cl->cl_cpg), &bit_off,
 				      &num_bits);
 	if (status < 0) {
@@ -486,7 +486,7 @@ static int ocfs2_block_group_claim_bits(struct ocfs2_super *osb,
 	int status;
 
 	while (min_bits) {
-		status = ocfs2_claim_clusters(osb, handle, ac, min_bits,
+		status = ocfs2_claim_clusters(handle, ac, min_bits,
 					      bit_off, num_bits);
 		if (status != -ENOSPC)
 			break;
@@ -1965,8 +1965,7 @@ bail:
 	return status;
 }
 
-int ocfs2_claim_metadata(struct ocfs2_super *osb,
-			 handle_t *handle,
+int ocfs2_claim_metadata(handle_t *handle,
 			 struct ocfs2_alloc_context *ac,
 			 u32 bits_wanted,
 			 u16 *suballoc_bit_start,
@@ -1989,7 +1988,7 @@ int ocfs2_claim_metadata(struct ocfs2_super *osb,
 		mlog_errno(status);
 		goto bail;
 	}
-	atomic_inc(&osb->alloc_stats.bg_allocs);
+	atomic_inc(&OCFS2_SB(ac->ac_inode->i_sb)->alloc_stats.bg_allocs);
 
 	*suballoc_bit_start = res.sr_bit_offset;
 	*blkno_start = res.sr_bg_blkno + (u64)(res.sr_bit_offset);
@@ -2032,8 +2031,7 @@ static inline void ocfs2_save_inode_ac_group(struct inode *dir,
 	OCFS2_I(dir)->ip_last_used_slot = ac->ac_alloc_slot;
 }
 
-int ocfs2_claim_new_inode(struct ocfs2_super *osb,
-			  handle_t *handle,
+int ocfs2_claim_new_inode(handle_t *handle,
 			  struct inode *dir,
 			  struct buffer_head *parent_fe_bh,
 			  struct ocfs2_alloc_context *ac,
@@ -2061,7 +2059,7 @@ int ocfs2_claim_new_inode(struct ocfs2_super *osb,
 		mlog_errno(status);
 		goto bail;
 	}
-	atomic_inc(&osb->alloc_stats.bg_allocs);
+	atomic_inc(&OCFS2_SB(ac->ac_inode->i_sb)->alloc_stats.bg_allocs);
 
 	BUG_ON(res.sr_bits != 1);
 
@@ -2136,8 +2134,7 @@ static inline void ocfs2_block_to_cluster_group(struct inode *inode,
  * contig. allocation, set to '1' to indicate we can deal with extents
  * of any size.
  */
-int __ocfs2_claim_clusters(struct ocfs2_super *osb,
-			   handle_t *handle,
+int __ocfs2_claim_clusters(handle_t *handle,
 			   struct ocfs2_alloc_context *ac,
 			   u32 min_clusters,
 			   u32 max_clusters,
@@ -2147,6 +2144,7 @@ int __ocfs2_claim_clusters(struct ocfs2_super *osb,
 	int status;
 	unsigned int bits_wanted = max_clusters;
 	struct ocfs2_suballoc_result res;
+	struct ocfs2_super *osb = OCFS2_SB(ac->ac_inode->i_sb);
 
 	mlog_entry_void();
 
@@ -2205,8 +2203,7 @@ bail:
 	return status;
 }
 
-int ocfs2_claim_clusters(struct ocfs2_super *osb,
-			 handle_t *handle,
+int ocfs2_claim_clusters(handle_t *handle,
 			 struct ocfs2_alloc_context *ac,
 			 u32 min_clusters,
 			 u32 *cluster_start,
@@ -2214,7 +2211,7 @@ int ocfs2_claim_clusters(struct ocfs2_super *osb,
 {
 	unsigned int bits_wanted = ac->ac_bits_wanted - ac->ac_bits_given;
 
-	return __ocfs2_claim_clusters(osb, handle, ac, min_clusters,
+	return __ocfs2_claim_clusters(handle, ac, min_clusters,
 				      bits_wanted, cluster_start, num_clusters);
 }
 
diff --git a/fs/ocfs2/suballoc.h b/fs/ocfs2/suballoc.h
index fbf7f17..28096dc 100644
--- a/fs/ocfs2/suballoc.h
+++ b/fs/ocfs2/suballoc.h
@@ -81,22 +81,19 @@ int ocfs2_reserve_clusters(struct ocfs2_super *osb,
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
@@ -105,8 +102,7 @@ int ocfs2_claim_clusters(struct ocfs2_super *osb,
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
index d1b0d38..e8997ca 100644
--- a/fs/ocfs2/xattr.c
+++ b/fs/ocfs2/xattr.c
@@ -2848,7 +2848,6 @@ static int ocfs2_create_xattr_block(struct inode *inode,
 	u32 num_got;
 	u64 first_blkno;
 	struct ocfs2_dinode *di =  (struct ocfs2_dinode *)inode_bh->b_data;
-	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
 	struct buffer_head *new_bh = NULL;
 	struct ocfs2_xattr_block *xblk;
 
@@ -2859,7 +2858,7 @@ static int ocfs2_create_xattr_block(struct inode *inode,
 		goto end;
 	}
 
-	ret = ocfs2_claim_metadata(osb, ctxt->handle, ctxt->meta_ac, 1,
+	ret = ocfs2_claim_metadata(ctxt->handle, ctxt->meta_ac, 1,
 				   &suballoc_bit_start, &num_got,
 				   &first_blkno);
 	if (ret < 0) {
@@ -2884,7 +2883,8 @@ static int ocfs2_create_xattr_block(struct inode *inode,
 	strcpy((void *)xblk, OCFS2_XATTR_BLOCK_SIGNATURE);
 	xblk->xb_suballoc_slot = cpu_to_le16(ctxt->meta_ac->ac_alloc_slot);
 	xblk->xb_suballoc_bit = cpu_to_le16(suballoc_bit_start);
-	xblk->xb_fs_generation = cpu_to_le32(osb->fs_generation);
+	xblk->xb_fs_generation =
+		cpu_to_le32(OCFS2_SB(inode->i_sb)->fs_generation);
 	xblk->xb_blkno = cpu_to_le64(first_blkno);
 	if (indexed) {
 		struct ocfs2_xattr_tree_root *xr = &xblk->xb_attrs.xb_root;
@@ -4249,7 +4249,6 @@ static int ocfs2_xattr_create_index_block(struct inode *inode,
 	u32 bit_off, len;
 	u64 blkno;
 	handle_t *handle = ctxt->handle;
-	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
 	struct ocfs2_inode_info *oi = OCFS2_I(inode);
 	struct buffer_head *xb_bh = xs->xattr_bh;
 	struct ocfs2_xattr_block *xb =
@@ -4277,7 +4276,7 @@ static int ocfs2_xattr_create_index_block(struct inode *inode,
 		goto out;
 	}
 
-	ret = __ocfs2_claim_clusters(osb, handle, ctxt->data_ac,
+	ret = __ocfs2_claim_clusters(handle, ctxt->data_ac,
 				     1, 1, &bit_off, &len);
 	if (ret) {
 		mlog_errno(ret);
@@ -5099,7 +5098,7 @@ static int ocfs2_add_new_xattr_cluster(struct inode *inode,
 		goto leave;
 	}
 
-	ret = __ocfs2_claim_clusters(osb, handle, ctxt->data_ac, 1,
+	ret = __ocfs2_claim_clusters(handle, ctxt->data_ac, 1,
 				     clusters_to_add, &bit_off, &num_bits);
 	if (ret < 0) {
 		if (ret != -ENOSPC)
@@ -6937,7 +6936,7 @@ static int ocfs2_reflink_xattr_rec(struct inode *inode,
 		goto out;
 	}
 
-	ret = ocfs2_claim_clusters(osb, handle, data_ac,
+	ret = ocfs2_claim_clusters(handle, data_ac,
 				   len, &p_cluster, &num_clusters);
 	if (ret) {
 		mlog_errno(ret);
-- 
1.5.5
