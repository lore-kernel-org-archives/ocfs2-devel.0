From: Joel Becker <joel.becker@oracle.com>
Date: Fri, 13 Feb 2009 14:16:23 -0800
Subject: [Ocfs2-devel] [PATCH 36/40] ocfs2: ocfs2_add_clusters_in_btree() no
	longer needs struct inode.
In-Reply-To: <1234563387-17101-1-git-send-email-joel.becker@oracle.com>
References: <1234563387-17101-1-git-send-email-joel.becker@oracle.com>
Message-ID: <1234563387-17101-37-git-send-email-joel.becker@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

One more function that doesn't need a struct inode to pass to its
children.

Signed-off-by: Joel Becker <joel.becker@oracle.com>
---
 fs/ocfs2/alloc.c |   13 +++++++------
 fs/ocfs2/alloc.h |    6 ++----
 fs/ocfs2/file.c  |    7 +++----
 fs/ocfs2/xattr.c |    7 ++-----
 4 files changed, 14 insertions(+), 19 deletions(-)

diff --git a/fs/ocfs2/alloc.c b/fs/ocfs2/alloc.c
index 54324a0..0f513af 100644
--- a/fs/ocfs2/alloc.c
+++ b/fs/ocfs2/alloc.c
@@ -4596,13 +4596,11 @@ bail:
  * it is not limited to the file storage. Any extent tree can use this
  * function if it implements the proper ocfs2_extent_tree.
  */
-int ocfs2_add_clusters_in_btree(struct ocfs2_super *osb,
-				struct inode *inode,
+int ocfs2_add_clusters_in_btree(handle_t *handle,
+				struct ocfs2_extent_tree *et,
 				u32 *logical_offset,
 				u32 clusters_to_add,
 				int mark_unwritten,
-				struct ocfs2_extent_tree *et,
-				handle_t *handle,
 				struct ocfs2_alloc_context *data_ac,
 				struct ocfs2_alloc_context *meta_ac,
 				enum ocfs2_alloc_restarted *reason_ret)
@@ -4613,6 +4611,8 @@ int ocfs2_add_clusters_in_btree(struct ocfs2_super *osb,
 	u32 bit_off, num_bits;
 	u64 block;
 	u8 flags = 0;
+	struct ocfs2_super *osb =
+		OCFS2_SB(ocfs2_metadata_cache_get_super(et->et_ci));
 
 	BUG_ON(!clusters_to_add);
 
@@ -4664,8 +4664,9 @@ int ocfs2_add_clusters_in_btree(struct ocfs2_super *osb,
 	}
 
 	block = ocfs2_clusters_to_blocks(osb->sb, bit_off);
-	mlog(0, "Allocating %u clusters at block %u for inode %llu\n",
-	     num_bits, bit_off, (unsigned long long)OCFS2_I(inode)->ip_blkno);
+	mlog(0, "Allocating %u clusters at block %u for owner %llu\n",
+	     num_bits, bit_off,
+	     (unsigned long long)ocfs2_metadata_cache_owner(et->et_ci));
 	status = ocfs2_insert_extent(handle, et, *logical_offset, block,
 				     num_bits, flags, meta_ac);
 	if (status < 0) {
diff --git a/fs/ocfs2/alloc.h b/fs/ocfs2/alloc.h
index bd6fa7a..380670f 100644
--- a/fs/ocfs2/alloc.h
+++ b/fs/ocfs2/alloc.h
@@ -100,13 +100,11 @@ enum ocfs2_alloc_restarted {
 	RESTART_TRANS,
 	RESTART_META
 };
-int ocfs2_add_clusters_in_btree(struct ocfs2_super *osb,
-				struct inode *inode,
+int ocfs2_add_clusters_in_btree(handle_t *handle,
+				struct ocfs2_extent_tree *et,
 				u32 *logical_offset,
 				u32 clusters_to_add,
 				int mark_unwritten,
-				struct ocfs2_extent_tree *et,
-				handle_t *handle,
 				struct ocfs2_alloc_context *data_ac,
 				struct ocfs2_alloc_context *meta_ac,
 				enum ocfs2_alloc_restarted *reason_ret);
diff --git a/fs/ocfs2/file.c b/fs/ocfs2/file.c
index 67acf0b..1d0de23 100644
--- a/fs/ocfs2/file.c
+++ b/fs/ocfs2/file.c
@@ -513,10 +513,9 @@ int ocfs2_add_inode_data(struct ocfs2_super *osb,
 	struct ocfs2_extent_tree et;
 
 	ocfs2_init_dinode_extent_tree(&et, inode, fe_bh);
-	ret = ocfs2_add_clusters_in_btree(osb, inode, logical_offset,
-					   clusters_to_add, mark_unwritten,
-					   &et, handle,
-					   data_ac, meta_ac, reason_ret);
+	ret = ocfs2_add_clusters_in_btree(handle, &et, logical_offset,
+					  clusters_to_add, mark_unwritten,
+					  data_ac, meta_ac, reason_ret);
 
 	return ret;
 }
diff --git a/fs/ocfs2/xattr.c b/fs/ocfs2/xattr.c
index c1833b4..dba7d45 100644
--- a/fs/ocfs2/xattr.c
+++ b/fs/ocfs2/xattr.c
@@ -592,7 +592,6 @@ static int ocfs2_xattr_extend_allocation(struct inode *inode,
 	int status = 0;
 	handle_t *handle = ctxt->handle;
 	enum ocfs2_alloc_restarted why;
-	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
 	u32 prev_clusters, logical_start = le32_to_cpu(vb->vb_xv->xr_clusters);
 	struct ocfs2_extent_tree et;
 
@@ -608,13 +607,11 @@ static int ocfs2_xattr_extend_allocation(struct inode *inode,
 	}
 
 	prev_clusters = le32_to_cpu(vb->vb_xv->xr_clusters);
-	status = ocfs2_add_clusters_in_btree(osb,
-					     inode,
+	status = ocfs2_add_clusters_in_btree(handle,
+					     &et,
 					     &logical_start,
 					     clusters_to_add,
 					     0,
-					     &et,
-					     handle,
 					     ctxt->data_ac,
 					     ctxt->meta_ac,
 					     &why);
-- 
1.5.6.5
