From: Joel Becker <joel.becker@oracle.com>
Date: Fri, 13 Feb 2009 14:16:22 -0800
Subject: [Ocfs2-devel] [PATCH 35/40] ocfs2: ocfs2_insert_extent() no longer
	needs struct inode.
In-Reply-To: <1234563387-17101-1-git-send-email-joel.becker@oracle.com>
References: <1234563387-17101-1-git-send-email-joel.becker@oracle.com>
Message-ID: <1234563387-17101-36-git-send-email-joel.becker@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

One more function down, no inode in the entire insert-extent chain.

Signed-off-by: Joel Becker <joel.becker@oracle.com>
---
 fs/ocfs2/alloc.c |   19 ++++++++-----------
 fs/ocfs2/alloc.h |    4 +---
 fs/ocfs2/dir.c   |    4 ++--
 fs/ocfs2/xattr.c |    2 +-
 4 files changed, 12 insertions(+), 17 deletions(-)

diff --git a/fs/ocfs2/alloc.c b/fs/ocfs2/alloc.c
index 619ebaf..54324a0 100644
--- a/fs/ocfs2/alloc.c
+++ b/fs/ocfs2/alloc.c
@@ -4519,13 +4519,11 @@ out:
 }
 
 /*
- * Insert an extent into an inode btree.
+ * Insert an extent into a btree.
  *
- * The caller needs to update fe->i_clusters
+ * The caller needs to update the owning btree's cluster count.
  */
-int ocfs2_insert_extent(struct ocfs2_super *osb,
-			handle_t *handle,
-			struct inode *inode,
+int ocfs2_insert_extent(handle_t *handle,
 			struct ocfs2_extent_tree *et,
 			u32 cpos,
 			u64 start_blk,
@@ -4539,8 +4537,9 @@ int ocfs2_insert_extent(struct ocfs2_super *osb,
 	struct ocfs2_insert_type insert = {0, };
 	struct ocfs2_extent_rec rec;
 
-	mlog(0, "add %u clusters at position %u to inode %llu\n",
-	     new_clusters, cpos, (unsigned long long)OCFS2_I(inode)->ip_blkno);
+	mlog(0, "add %u clusters at position %u to owner %llu\n",
+	     new_clusters, cpos,
+	     (unsigned long long)ocfs2_metadata_cache_owner(et->et_ci));
 
 	memset(&rec, 0, sizeof(rec));
 	rec.e_cpos = cpu_to_le32(cpos);
@@ -4667,8 +4666,7 @@ int ocfs2_add_clusters_in_btree(struct ocfs2_super *osb,
 	block = ocfs2_clusters_to_blocks(osb->sb, bit_off);
 	mlog(0, "Allocating %u clusters at block %u for inode %llu\n",
 	     num_bits, bit_off, (unsigned long long)OCFS2_I(inode)->ip_blkno);
-	status = ocfs2_insert_extent(osb, handle, inode, et,
-				     *logical_offset, block,
+	status = ocfs2_insert_extent(handle, et, *logical_offset, block,
 				     num_bits, flags, meta_ac);
 	if (status < 0) {
 		mlog_errno(status);
@@ -7057,8 +7055,7 @@ int ocfs2_convert_inline_data_to_extents(struct inode *inode,
 		 * the in-inode data from our pages.
 		 */
 		ocfs2_init_dinode_extent_tree(&et, inode, di_bh);
-		ret = ocfs2_insert_extent(osb, handle, inode, &et,
-					  0, block, 1, 0, NULL);
+		ret = ocfs2_insert_extent(handle, &et, 0, block, 1, 0, NULL);
 		if (ret) {
 			mlog_errno(ret);
 			goto out_commit;
diff --git a/fs/ocfs2/alloc.h b/fs/ocfs2/alloc.h
index 480e332..bd6fa7a 100644
--- a/fs/ocfs2/alloc.h
+++ b/fs/ocfs2/alloc.h
@@ -87,9 +87,7 @@ int ocfs2_read_extent_block(struct ocfs2_caching_info *ci, u64 eb_blkno,
 			    struct buffer_head **bh);
 
 struct ocfs2_alloc_context;
-int ocfs2_insert_extent(struct ocfs2_super *osb,
-			handle_t *handle,
-			struct inode *inode,
+int ocfs2_insert_extent(handle_t *handle,
 			struct ocfs2_extent_tree *et,
 			u32 cpos,
 			u64 start_blk,
diff --git a/fs/ocfs2/dir.c b/fs/ocfs2/dir.c
index 801e47c..2684c99 100644
--- a/fs/ocfs2/dir.c
+++ b/fs/ocfs2/dir.c
@@ -1535,7 +1535,7 @@ static int ocfs2_expand_inline_dir(struct inode *dir, struct buffer_head *di_bh,
 	 * This should never fail as our extent list is empty and all
 	 * related blocks have been journaled already.
 	 */
-	ret = ocfs2_insert_extent(osb, handle, dir, &et, 0, blkno, len,
+	ret = ocfs2_insert_extent(handle, &et, 0, blkno, len,
 				  0, NULL);
 	if (ret) {
 		mlog_errno(ret);
@@ -1567,7 +1567,7 @@ static int ocfs2_expand_inline_dir(struct inode *dir, struct buffer_head *di_bh,
 		}
 		blkno = ocfs2_clusters_to_blocks(dir->i_sb, bit_off);
 
-		ret = ocfs2_insert_extent(osb, handle, dir, &et, 1,
+		ret = ocfs2_insert_extent(handle, &et, 1,
 					  blkno, len, 0, NULL);
 		if (ret) {
 			mlog_errno(ret);
diff --git a/fs/ocfs2/xattr.c b/fs/ocfs2/xattr.c
index d65742e..c1833b4 100644
--- a/fs/ocfs2/xattr.c
+++ b/fs/ocfs2/xattr.c
@@ -4318,7 +4318,7 @@ static int ocfs2_add_new_xattr_cluster(struct inode *inode,
 
 	mlog(0, "Insert %u clusters at block %llu for xattr at %u\n",
 	     num_bits, (unsigned long long)block, v_start);
-	ret = ocfs2_insert_extent(osb, handle, inode, &et, v_start, block,
+	ret = ocfs2_insert_extent(handle, &et, v_start, block,
 				  num_bits, 0, ctxt->meta_ac);
 	if (ret < 0) {
 		mlog_errno(ret);
-- 
1.5.6.5
