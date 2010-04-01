From: Tao Ma <tao.ma@oracle.com>
Date: Thu,  1 Apr 2010 10:59:06 +0800
Subject: [Ocfs2-devel] [PATCH 09/15] ocfs2: Set suballoc_loc on allocated
	metadata.
In-Reply-To: <4BB40AB4.8040205@oracle.com>
References: <4BB40AB4.8040205@oracle.com>
Message-ID: <1270090752-18935-9-git-send-email-tao.ma@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

From: Joel Becker <joel.becker@oracle.com>

Get the suballoc_loc from ocfs2_claim_new_inode() or
ocfs2_claim_metadata().  Store it on the appropriate field of the block
we just allocated.

Signed-off-by: Joel Becker <joel.becker@oracle.com>
---
 fs/ocfs2/alloc.c        |    4 +++-
 fs/ocfs2/dir.c          |    7 ++++---
 fs/ocfs2/namei.c        |    6 ++++--
 fs/ocfs2/refcounttree.c |   15 +++++++++------
 fs/ocfs2/suballoc.c     |   16 +++++++++++++---
 fs/ocfs2/suballoc.h     |    2 ++
 fs/ocfs2/xattr.c        |    7 ++++---
 7 files changed, 39 insertions(+), 18 deletions(-)

diff --git a/fs/ocfs2/alloc.c b/fs/ocfs2/alloc.c
index 57d7f7a..6b59b6f 100644
--- a/fs/ocfs2/alloc.c
+++ b/fs/ocfs2/alloc.c
@@ -1006,7 +1006,7 @@ static int ocfs2_create_new_meta_bhs(handle_t *handle,
 	int count, status, i;
 	u16 suballoc_bit_start;
 	u32 num_got;
-	u64 first_blkno;
+	u64 suballoc_loc, first_blkno;
 	struct ocfs2_super *osb =
 		OCFS2_SB(ocfs2_metadata_cache_get_super(et->et_ci));
 	struct ocfs2_extent_block *eb;
@@ -1018,6 +1018,7 @@ static int ocfs2_create_new_meta_bhs(handle_t *handle,
 		status = ocfs2_claim_metadata(handle,
 					      meta_ac,
 					      wanted - count,
+					      &suballoc_loc,
 					      &suballoc_bit_start,
 					      &num_got,
 					      &first_blkno);
@@ -1051,6 +1052,7 @@ static int ocfs2_create_new_meta_bhs(handle_t *handle,
 			eb->h_fs_generation = cpu_to_le32(osb->fs_generation);
 			eb->h_suballoc_slot =
 				cpu_to_le16(meta_ac->ac_alloc_slot);
+			eb->h_suballoc_loc = cpu_to_le64(suballoc_loc);
 			eb->h_suballoc_bit = cpu_to_le16(suballoc_bit_start);
 			eb->h_list.l_count =
 				cpu_to_le16(ocfs2_extent_recs_per_eb(osb->sb));
diff --git a/fs/ocfs2/dir.c b/fs/ocfs2/dir.c
index 06522b5..48b591d 100644
--- a/fs/ocfs2/dir.c
+++ b/fs/ocfs2/dir.c
@@ -2404,15 +2404,15 @@ static int ocfs2_dx_dir_attach_index(struct ocfs2_super *osb,
 	int ret;
 	struct ocfs2_dinode *di = (struct ocfs2_dinode *) di_bh->b_data;
 	u16 dr_suballoc_bit;
-	u64 dr_blkno;
+	u64 suballoc_loc, dr_blkno;
 	unsigned int num_bits;
 	struct buffer_head *dx_root_bh = NULL;
 	struct ocfs2_dx_root_block *dx_root;
 	struct ocfs2_dir_block_trailer *trailer =
 		ocfs2_trailer_from_bh(dirdata_bh, dir->i_sb);
 
-	ret = ocfs2_claim_metadata(handle, meta_ac, 1, &dr_suballoc_bit,
-				   &num_bits, &dr_blkno);
+	ret = ocfs2_claim_metadata(handle, meta_ac, 1, &suballoc_loc,
+				   &dr_suballoc_bit, &num_bits, &dr_blkno);
 	if (ret) {
 		mlog_errno(ret);
 		goto out;
@@ -2440,6 +2440,7 @@ static int ocfs2_dx_dir_attach_index(struct ocfs2_super *osb,
 	memset(dx_root, 0, osb->sb->s_blocksize);
 	strcpy(dx_root->dr_signature, OCFS2_DX_ROOT_SIGNATURE);
 	dx_root->dr_suballoc_slot = cpu_to_le16(meta_ac->ac_alloc_slot);
+	dx_root->dr_suballoc_loc = cpu_to_le64(suballoc_loc);
 	dx_root->dr_suballoc_bit = cpu_to_le16(dr_suballoc_bit);
 	dx_root->dr_fs_generation = cpu_to_le32(osb->fs_generation);
 	dx_root->dr_blkno = cpu_to_le64(dr_blkno);
diff --git a/fs/ocfs2/namei.c b/fs/ocfs2/namei.c
index 9c3e1fe..6ec584e 100644
--- a/fs/ocfs2/namei.c
+++ b/fs/ocfs2/namei.c
@@ -476,14 +476,15 @@ static int ocfs2_mknod_locked(struct ocfs2_super *osb,
 	int status = 0;
 	struct ocfs2_dinode *fe = NULL;
 	struct ocfs2_extent_list *fel;
-	u64 fe_blkno = 0;
+	u64 suballoc_loc, fe_blkno = 0;
 	u16 suballoc_bit;
 	u16 feat;
 
 	*new_fe_bh = NULL;
 
 	status = ocfs2_claim_new_inode(handle, dir, parent_fe_bh,
-				       inode_ac, &suballoc_bit, &fe_blkno);
+				       inode_ac, &suballoc_loc,
+				       &suballoc_bit, &fe_blkno);
 	if (status < 0) {
 		mlog_errno(status);
 		goto leave;
@@ -520,6 +521,7 @@ static int ocfs2_mknod_locked(struct ocfs2_super *osb,
 	fe->i_generation = cpu_to_le32(inode->i_generation);
 	fe->i_fs_generation = cpu_to_le32(osb->fs_generation);
 	fe->i_blkno = cpu_to_le64(fe_blkno);
+	fe->i_suballoc_loc = cpu_to_le64(suballoc_loc);
 	fe->i_suballoc_bit = cpu_to_le16(suballoc_bit);
 	fe->i_suballoc_slot = cpu_to_le16(inode_ac->ac_alloc_slot);
 	fe->i_uid = cpu_to_le32(inode->i_uid);
diff --git a/fs/ocfs2/refcounttree.c b/fs/ocfs2/refcounttree.c
index 4fb18af..3fc675f 100644
--- a/fs/ocfs2/refcounttree.c
+++ b/fs/ocfs2/refcounttree.c
@@ -571,7 +571,7 @@ static int ocfs2_create_refcount_tree(struct inode *inode,
 	struct ocfs2_refcount_tree *new_tree = NULL, *tree = NULL;
 	u16 suballoc_bit_start;
 	u32 num_got;
-	u64 first_blkno;
+	u64 suballoc_loc, first_blkno;
 
 	BUG_ON(oi->ip_dyn_features & OCFS2_HAS_REFCOUNT_FL);
 
@@ -597,7 +597,7 @@ static int ocfs2_create_refcount_tree(struct inode *inode,
 		goto out_commit;
 	}
 
-	ret = ocfs2_claim_metadata(handle, meta_ac, 1,
+	ret = ocfs2_claim_metadata(handle, meta_ac, 1, &suballoc_loc,
 				   &suballoc_bit_start, &num_got,
 				   &first_blkno);
 	if (ret) {
@@ -627,6 +627,7 @@ static int ocfs2_create_refcount_tree(struct inode *inode,
 	memset(rb, 0, inode->i_sb->s_blocksize);
 	strcpy((void *)rb, OCFS2_REFCOUNT_BLOCK_SIGNATURE);
 	rb->rf_suballoc_slot = cpu_to_le16(meta_ac->ac_alloc_slot);
+	rb->rf_suballoc_loc = cpu_to_le64(suballoc_loc);
 	rb->rf_suballoc_bit = cpu_to_le16(suballoc_bit_start);
 	rb->rf_fs_generation = cpu_to_le32(osb->fs_generation);
 	rb->rf_blkno = cpu_to_le64(first_blkno);
@@ -1285,7 +1286,7 @@ static int ocfs2_expand_inline_ref_root(handle_t *handle,
 	int ret;
 	u16 suballoc_bit_start;
 	u32 num_got;
-	u64 blkno;
+	u64 suballoc_loc, blkno;
 	struct super_block *sb = ocfs2_metadata_cache_get_super(ci);
 	struct buffer_head *new_bh = NULL;
 	struct ocfs2_refcount_block *new_rb;
@@ -1299,7 +1300,7 @@ static int ocfs2_expand_inline_ref_root(handle_t *handle,
 		goto out;
 	}
 
-	ret = ocfs2_claim_metadata(handle, meta_ac, 1,
+	ret = ocfs2_claim_metadata(handle, meta_ac, 1, &suballoc_loc,
 				   &suballoc_bit_start, &num_got,
 				   &blkno);
 	if (ret) {
@@ -1331,6 +1332,7 @@ static int ocfs2_expand_inline_ref_root(handle_t *handle,
 
 	new_rb = (struct ocfs2_refcount_block *)new_bh->b_data;
 	new_rb->rf_suballoc_slot = cpu_to_le16(meta_ac->ac_alloc_slot);
+	new_rb->rf_suballoc_loc = cpu_to_le64(suballoc_loc);
 	new_rb->rf_suballoc_bit = cpu_to_le16(suballoc_bit_start);
 	new_rb->rf_blkno = cpu_to_le64(blkno);
 	new_rb->rf_cpos = cpu_to_le32(0);
@@ -1525,7 +1527,7 @@ static int ocfs2_new_leaf_refcount_block(handle_t *handle,
 	int ret;
 	u16 suballoc_bit_start;
 	u32 num_got, new_cpos;
-	u64 blkno;
+	u64 suballoc_loc, blkno;
 	struct super_block *sb = ocfs2_metadata_cache_get_super(ci);
 	struct ocfs2_refcount_block *root_rb =
 			(struct ocfs2_refcount_block *)ref_root_bh->b_data;
@@ -1549,7 +1551,7 @@ static int ocfs2_new_leaf_refcount_block(handle_t *handle,
 		goto out;
 	}
 
-	ret = ocfs2_claim_metadata(handle, meta_ac, 1,
+	ret = ocfs2_claim_metadata(handle, meta_ac, 1, &suballoc_loc,
 				   &suballoc_bit_start, &num_got,
 				   &blkno);
 	if (ret) {
@@ -1577,6 +1579,7 @@ static int ocfs2_new_leaf_refcount_block(handle_t *handle,
 	memset(new_rb, 0, sb->s_blocksize);
 	strcpy((void *)new_rb, OCFS2_REFCOUNT_BLOCK_SIGNATURE);
 	new_rb->rf_suballoc_slot = cpu_to_le16(meta_ac->ac_alloc_slot);
+	new_rb->rf_suballoc_loc = cpu_to_le64(suballoc_loc);
 	new_rb->rf_suballoc_bit = cpu_to_le16(suballoc_bit_start);
 	new_rb->rf_fs_generation = cpu_to_le32(OCFS2_SB(sb)->fs_generation);
 	new_rb->rf_blkno = cpu_to_le64(blkno);
diff --git a/fs/ocfs2/suballoc.c b/fs/ocfs2/suballoc.c
index 6ac9884..0ee6548 100644
--- a/fs/ocfs2/suballoc.c
+++ b/fs/ocfs2/suballoc.c
@@ -54,7 +54,9 @@
 #define OCFS2_MAX_TO_STEAL		1024
 
 struct ocfs2_suballoc_result {
-	u64		sr_bg_blkno;	/* The bg we allocated from */
+	u64		sr_bg_blkno;	/* The bg we allocated from.  Set
+					   to 0 when a block group is
+					   contiguous. */
 	u64		sr_blkno;	/* The first allocated block */
 	unsigned int	sr_bit_offset;	/* The bit in the bg */
 	unsigned int	sr_bits;	/* How many bits we claimed */
@@ -1644,6 +1646,7 @@ static void ocfs2_bg_discontig_fix_result(struct ocfs2_alloc_context *ac,
 					  struct ocfs2_suballoc_result *res)
 {
 	int i;
+	u64 bg_blkno = res->sr_bg_blkno;  /* Save off */
 	struct ocfs2_extent_rec *rec;
 	struct ocfs2_dinode *di = (struct ocfs2_dinode *)ac->ac_bh->b_data;
 	struct ocfs2_chain_list *cl = &di->id2.i_chain;
@@ -1654,14 +1657,17 @@ static void ocfs2_bg_discontig_fix_result(struct ocfs2_alloc_context *ac,
 	}
 
 	res->sr_blkno = res->sr_bg_blkno + res->sr_bit_offset;
+	res->sr_bg_blkno = 0;  /* Clear it for contig block groups */
 	if (!ocfs2_supports_discontig_bh(OCFS2_SB(ac->ac_inode->i_sb)) ||
 	    !bg->bg_list.l_next_free_rec)
 		return;
 
 	for (i = 0; i < le16_to_cpu(bg->bg_list.l_next_free_rec); i++) {
 		rec = &bg->bg_list.l_recs[i];
-		if (ocfs2_bg_discontig_fix_by_rec(res, rec, cl))
+		if (ocfs2_bg_discontig_fix_by_rec(res, rec, cl)) {
+			res->sr_bg_blkno = bg_blkno;  /* Restore */
 			break;
+		}
 	}
 }
 
@@ -1972,6 +1978,7 @@ bail:
 int ocfs2_claim_metadata(handle_t *handle,
 			 struct ocfs2_alloc_context *ac,
 			 u32 bits_wanted,
+			 u64 *suballoc_loc,
 			 u16 *suballoc_bit_start,
 			 unsigned int *num_bits,
 			 u64 *blkno_start)
@@ -1994,6 +2001,7 @@ int ocfs2_claim_metadata(handle_t *handle,
 	}
 	atomic_inc(&OCFS2_SB(ac->ac_inode->i_sb)->alloc_stats.bg_allocs);
 
+	*suballoc_loc = res.sr_bg_blkno;
 	*suballoc_bit_start = res.sr_bit_offset;
 	*blkno_start = res.sr_blkno;
 	ac->ac_bits_given += res.sr_bits;
@@ -2039,11 +2047,12 @@ int ocfs2_claim_new_inode(handle_t *handle,
 			  struct inode *dir,
 			  struct buffer_head *parent_fe_bh,
 			  struct ocfs2_alloc_context *ac,
+			  u64 *suballoc_loc,
 			  u16 *suballoc_bit,
 			  u64 *fe_blkno)
 {
 	int status;
-	struct ocfs2_suballoc_result res = { .sr_blkno = 0, };
+	struct ocfs2_suballoc_result res;
 
 	mlog_entry_void();
 
@@ -2067,6 +2076,7 @@ int ocfs2_claim_new_inode(handle_t *handle,
 
 	BUG_ON(res.sr_bits != 1);
 
+	*suballoc_loc = res.sr_bg_blkno;
 	*suballoc_bit = res.sr_bit_offset;
 	*fe_blkno = res.sr_blkno;
 	ac->ac_bits_given++;
diff --git a/fs/ocfs2/suballoc.h b/fs/ocfs2/suballoc.h
index 28096dc..c6e1ee7 100644
--- a/fs/ocfs2/suballoc.h
+++ b/fs/ocfs2/suballoc.h
@@ -84,6 +84,7 @@ int ocfs2_reserve_clusters(struct ocfs2_super *osb,
 int ocfs2_claim_metadata(handle_t *handle,
 			 struct ocfs2_alloc_context *ac,
 			 u32 bits_wanted,
+			 u64 *suballoc_loc,
 			 u16 *suballoc_bit_start,
 			 u32 *num_bits,
 			 u64 *blkno_start);
@@ -91,6 +92,7 @@ int ocfs2_claim_new_inode(handle_t *handle,
 			  struct inode *dir,
 			  struct buffer_head *parent_fe_bh,
 			  struct ocfs2_alloc_context *ac,
+			  u64 *suballoc_loc,
 			  u16 *suballoc_bit,
 			  u64 *fe_blkno);
 int ocfs2_claim_clusters(handle_t *handle,
diff --git a/fs/ocfs2/xattr.c b/fs/ocfs2/xattr.c
index e8997ca..863ad7a 100644
--- a/fs/ocfs2/xattr.c
+++ b/fs/ocfs2/xattr.c
@@ -2846,7 +2846,7 @@ static int ocfs2_create_xattr_block(struct inode *inode,
 	int ret;
 	u16 suballoc_bit_start;
 	u32 num_got;
-	u64 first_blkno;
+	u64 suballoc_loc, first_blkno;
 	struct ocfs2_dinode *di =  (struct ocfs2_dinode *)inode_bh->b_data;
 	struct buffer_head *new_bh = NULL;
 	struct ocfs2_xattr_block *xblk;
@@ -2859,8 +2859,8 @@ static int ocfs2_create_xattr_block(struct inode *inode,
 	}
 
 	ret = ocfs2_claim_metadata(ctxt->handle, ctxt->meta_ac, 1,
-				   &suballoc_bit_start, &num_got,
-				   &first_blkno);
+				   &suballoc_loc, &suballoc_bit_start,
+				   &num_got, &first_blkno);
 	if (ret < 0) {
 		mlog_errno(ret);
 		goto end;
@@ -2882,6 +2882,7 @@ static int ocfs2_create_xattr_block(struct inode *inode,
 	memset(xblk, 0, inode->i_sb->s_blocksize);
 	strcpy((void *)xblk, OCFS2_XATTR_BLOCK_SIGNATURE);
 	xblk->xb_suballoc_slot = cpu_to_le16(ctxt->meta_ac->ac_alloc_slot);
+	xblk->xb_suballoc_loc = cpu_to_le64(suballoc_loc);
 	xblk->xb_suballoc_bit = cpu_to_le16(suballoc_bit_start);
 	xblk->xb_fs_generation =
 		cpu_to_le32(OCFS2_SB(inode->i_sb)->fs_generation);
-- 
1.5.5
