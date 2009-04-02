From: Tao Ma <tao.ma@oracle.com>
Date: Fri,  3 Apr 2009 07:45:48 +0800
Subject: [Ocfs2-devel] [PATCH 09/42] ocfs2: Pass ocfs2_insert_extent an
	inserted leaf record.
In-Reply-To: <49D5CAC2.4010201@oracle.com>
References: <49D5CAC2.4010201@oracle.com>
Message-ID: <1238715981-21488-9-git-send-email-tao.ma@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

In old b-tree operation, ocfs2_insert_extent organize an inserted
leaf extent record by itself. So pull the creation of ocfs2_extent_rec
up into the caller so that it can handle ocfs2_extent_rec in a refcount
tree also.

Signed-off-by: Tao Ma <tao.ma@oracle.com>
---
 fs/ocfs2/alloc.c |   40 +++++++++++++++++++---------------------
 fs/ocfs2/alloc.h |    5 +----
 fs/ocfs2/dir.c   |   14 ++++++++++----
 fs/ocfs2/xattr.c |    9 +++++++--
 4 files changed, 37 insertions(+), 31 deletions(-)

diff --git a/fs/ocfs2/alloc.c b/fs/ocfs2/alloc.c
index e88c949..d79a62e 100644
--- a/fs/ocfs2/alloc.c
+++ b/fs/ocfs2/alloc.c
@@ -4593,34 +4593,21 @@ out:
  */
 int ocfs2_insert_extent(handle_t *handle,
 			struct ocfs2_extent_tree *et,
-			u32 cpos,
-			u64 start_blk,
-			u32 new_clusters,
-			u8 flags,
+			struct ocfs2_extent_rec *rec,
 			struct ocfs2_alloc_context *meta_ac)
 {
 	int status;
 	int uninitialized_var(free_records);
 	struct buffer_head *last_eb_bh = NULL;
 	struct ocfs2_insert_type insert = {0, };
-	struct ocfs2_extent_rec rec;
-
-	mlog(0, "add %u clusters at position %u to owner %llu\n",
-	     new_clusters, cpos,
-	     (unsigned long long)ocfs2_metadata_cache_owner(et->et_ci));
 
-	memset(&rec, 0, sizeof(rec));
-	rec.e_cpos = cpu_to_le32(cpos);
-	rec.e_blkno = cpu_to_le64(start_blk);
-	rec.e_leaf_clusters = cpu_to_le16(new_clusters);
-	rec.e_flags = flags;
-	status = ocfs2_et_insert_check(et, &rec);
+	status = ocfs2_et_insert_check(et, rec);
 	if (status) {
 		mlog_errno(status);
 		goto bail;
 	}
 
-	status = ocfs2_figure_insert_type(et, &last_eb_bh, &rec,
+	status = ocfs2_figure_insert_type(et, &last_eb_bh, rec,
 					  &free_records, &insert);
 	if (status < 0) {
 		mlog_errno(status);
@@ -4644,11 +4631,11 @@ int ocfs2_insert_extent(handle_t *handle,
 	}
 
 	/* Finally, we can add clusters. This might rotate the tree for us. */
-	status = ocfs2_do_insert_extent(handle, et, &rec, &insert);
+	status = ocfs2_do_insert_extent(handle, et, rec, &insert);
 	if (status < 0)
 		mlog_errno(status);
 	else
-		ocfs2_et_extent_map_insert(et, &rec);
+		ocfs2_et_extent_map_insert(et, rec);
 
 bail:
 	brelse(last_eb_bh);
@@ -4681,6 +4668,7 @@ int ocfs2_add_clusters_in_btree(handle_t *handle,
 	u8 flags = 0;
 	struct ocfs2_super *osb =
 		OCFS2_SB(ocfs2_metadata_cache_get_super(et->et_ci));
+	struct ocfs2_extent_rec rec;
 
 	BUG_ON(!clusters_to_add);
 
@@ -4735,8 +4723,13 @@ int ocfs2_add_clusters_in_btree(handle_t *handle,
 	mlog(0, "Allocating %u clusters at block %u for owner %llu\n",
 	     num_bits, bit_off,
 	     (unsigned long long)ocfs2_metadata_cache_owner(et->et_ci));
-	status = ocfs2_insert_extent(handle, et, *logical_offset, block,
-				     num_bits, flags, meta_ac);
+
+	memset(&rec, 0, sizeof(rec));
+	rec.e_cpos = cpu_to_le32(*logical_offset);
+	rec.e_blkno = cpu_to_le64(block);
+	rec.e_leaf_clusters = cpu_to_le16(num_bits);
+	rec.e_flags = flags;
+	status = ocfs2_insert_extent(handle, et, &rec, meta_ac);
 	if (status < 0) {
 		mlog_errno(status);
 		goto leave;
@@ -7183,13 +7176,18 @@ int ocfs2_convert_inline_data_to_extents(struct inode *inode,
 	ocfs2_journal_dirty(handle, di_bh);
 
 	if (has_data) {
+		struct ocfs2_extent_rec rec;
+
 		/*
 		 * An error@this point should be extremely rare. If
 		 * this proves to be false, we could always re-build
 		 * the in-inode data from our pages.
 		 */
 		ocfs2_init_dinode_extent_tree(&et, INODE_CACHE(inode), di_bh);
-		ret = ocfs2_insert_extent(handle, &et, 0, block, 1, 0, NULL);
+		memset(&rec, 0, sizeof(rec));
+		rec.e_blkno = cpu_to_le64(block);
+		rec.e_leaf_clusters = cpu_to_le16(1);
+		ret = ocfs2_insert_extent(handle, &et, &rec, NULL);
 		if (ret) {
 			mlog_errno(ret);
 			goto out_commit;
diff --git a/fs/ocfs2/alloc.h b/fs/ocfs2/alloc.h
index cd80410..4eeb59f 100644
--- a/fs/ocfs2/alloc.h
+++ b/fs/ocfs2/alloc.h
@@ -89,10 +89,7 @@ int ocfs2_read_extent_block(struct ocfs2_caching_info *ci, u64 eb_blkno,
 struct ocfs2_alloc_context;
 int ocfs2_insert_extent(handle_t *handle,
 			struct ocfs2_extent_tree *et,
-			u32 cpos,
-			u64 start_blk,
-			u32 new_clusters,
-			u8 flags,
+			struct ocfs2_extent_rec *rec,
 			struct ocfs2_alloc_context *meta_ac);
 
 enum ocfs2_alloc_restarted {
diff --git a/fs/ocfs2/dir.c b/fs/ocfs2/dir.c
index b361bfb..7020bfa 100644
--- a/fs/ocfs2/dir.c
+++ b/fs/ocfs2/dir.c
@@ -1412,6 +1412,7 @@ static int ocfs2_expand_inline_dir(struct inode *dir, struct buffer_head *di_bh,
 	struct ocfs2_dinode *di = (struct ocfs2_dinode *)di_bh->b_data;
 	handle_t *handle;
 	struct ocfs2_extent_tree et;
+	struct ocfs2_extent_rec rec;
 	int did_quota = 0;
 
 	ocfs2_init_dinode_extent_tree(&et, INODE_CACHE(dir), di_bh);
@@ -1535,8 +1536,10 @@ static int ocfs2_expand_inline_dir(struct inode *dir, struct buffer_head *di_bh,
 	 * This should never fail as our extent list is empty and all
 	 * related blocks have been journaled already.
 	 */
-	ret = ocfs2_insert_extent(handle, &et, 0, blkno, len,
-				  0, NULL);
+	memset(&rec, 0, sizeof(rec));
+	rec.e_blkno = cpu_to_le64(blkno);
+	rec.e_leaf_clusters = cpu_to_le16(len);
+	ret = ocfs2_insert_extent(handle, &et, &rec, NULL);
 	if (ret) {
 		mlog_errno(ret);
 		goto out_commit;
@@ -1567,8 +1570,11 @@ static int ocfs2_expand_inline_dir(struct inode *dir, struct buffer_head *di_bh,
 		}
 		blkno = ocfs2_clusters_to_blocks(dir->i_sb, bit_off);
 
-		ret = ocfs2_insert_extent(handle, &et, 1,
-					  blkno, len, 0, NULL);
+		memset(&rec, 0, sizeof(rec));
+		rec.e_cpos = cpu_to_le32(1);
+		rec.e_blkno = cpu_to_le64(blkno);
+		rec.e_leaf_clusters = cpu_to_le16(len);
+		ret = ocfs2_insert_extent(handle, &et, &rec, NULL);
 		if (ret) {
 			mlog_errno(ret);
 			goto out_commit;
diff --git a/fs/ocfs2/xattr.c b/fs/ocfs2/xattr.c
index f324c65..291ca13 100644
--- a/fs/ocfs2/xattr.c
+++ b/fs/ocfs2/xattr.c
@@ -4253,6 +4253,7 @@ static int ocfs2_add_new_xattr_cluster(struct inode *inode,
 	handle_t *handle = ctxt->handle;
 	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
 	struct ocfs2_extent_tree et;
+	struct ocfs2_extent_rec rec;
 
 	mlog(0, "Add new xattr cluster for %llu, previous xattr hash = %u, "
 	     "previous xattr blkno = %llu\n",
@@ -4315,8 +4316,12 @@ static int ocfs2_add_new_xattr_cluster(struct inode *inode,
 
 	mlog(0, "Insert %u clusters at block %llu for xattr at %u\n",
 	     num_bits, (unsigned long long)block, v_start);
-	ret = ocfs2_insert_extent(handle, &et, v_start, block,
-				  num_bits, 0, ctxt->meta_ac);
+
+	memset(&rec, 0, sizeof(rec));
+	rec.e_cpos = cpu_to_le32(v_start);
+	rec.e_blkno = cpu_to_le64(block);
+	rec.e_leaf_clusters = cpu_to_le16(num_bits);
+	ret = ocfs2_insert_extent(handle, &et, &rec, ctxt->meta_ac);
 	if (ret < 0) {
 		mlog_errno(ret);
 		goto leave;
-- 
1.6.2.rc2.16.gf474c
