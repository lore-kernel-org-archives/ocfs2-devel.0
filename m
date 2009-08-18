From: Tao Ma <tao.ma@oracle.com>
Date: Tue, 18 Aug 2009 14:19:20 +0800
Subject: [Ocfs2-devel] [PATCH 19/41] ocfs2: Integrate CoW in file write.
In-Reply-To: <4A8A47DF.8020707@oracle.com>
References: <4A8A47DF.8020707@oracle.com>
Message-ID: <1250576382-27080-19-git-send-email-tao.ma@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

In ocfs2_write_begin_nolock, when we find the cluster we
want to write is a reflinked cluster, do CoW first.

Signed-off-by: Tao Ma <tao.ma@oracle.com>
---
 fs/ocfs2/aops.c |   49 ++++++++++++++++++++++++++++++++++++++++++++++---
 1 files changed, 46 insertions(+), 3 deletions(-)

diff --git a/fs/ocfs2/aops.c b/fs/ocfs2/aops.c
index 65e17b3..02244bb 100644
--- a/fs/ocfs2/aops.c
+++ b/fs/ocfs2/aops.c
@@ -44,6 +44,7 @@
 #include "suballoc.h"
 #include "super.h"
 #include "symlink.h"
+#include "refcounttree.h"
 
 #include "buffer_head_io.h"
 
@@ -1411,18 +1412,29 @@ static void ocfs2_set_target_boundaries(struct ocfs2_super *osb,
 	}
 }
 
+static inline void ocfs2_clear_write_desc(struct ocfs2_write_ctxt *wc)
+{
+	memset(&wc->w_desc, 0,
+	       sizeof(struct ocfs2_write_cluster_desc) * wc->w_clen);
+}
 /*
  * Populate each single-cluster write descriptor in the write context
  * with information about the i/o to be done.
+ * If we encountered a refcounted cluster, break the process and return
+ * the refcounted start cpos.
  *
  * Returns the number of clusters that will have to be allocated, as
  * well as a worst case estimate of the number of extent records that
  * would have to be created during a write to an unwritten region.
+ *
+ * If we find a refcounted record, return directly with refcounted_cpos
+ * set as the position.
  */
 static int ocfs2_populate_write_desc(struct inode *inode,
 				     struct ocfs2_write_ctxt *wc,
 				     unsigned int *clusters_to_alloc,
-				     unsigned int *extents_to_split)
+				     unsigned int *extents_to_split,
+				     unsigned int *refcounted_cpos)
 {
 	int ret;
 	struct ocfs2_write_cluster_desc *desc;
@@ -1433,6 +1445,7 @@ static int ocfs2_populate_write_desc(struct inode *inode,
 
 	*clusters_to_alloc = 0;
 	*extents_to_split = 0;
+	*refcounted_cpos = UINT_MAX;
 
 	for (i = 0; i < wc->w_clen; i++) {
 		desc = &wc->w_desc[i];
@@ -1449,6 +1462,11 @@ static int ocfs2_populate_write_desc(struct inode *inode,
 				goto out;
 			}
 
+			if (ext_flags & OCFS2_EXT_REFCOUNTED) {
+				*refcounted_cpos = desc->c_cpos;
+				ret = -ETXTBSY;
+				goto out;
+			}
 			/*
 			 * Assume worst case - that we're writing in
 			 * the middle of the extent.
@@ -1674,6 +1692,7 @@ int ocfs2_write_begin_nolock(struct address_space *mapping,
 	struct ocfs2_alloc_context *meta_ac = NULL;
 	handle_t *handle;
 	struct ocfs2_extent_tree et;
+	unsigned int refcounted_cpos, cow_len;
 
 	ret = ocfs2_alloc_write_ctxt(&wc, osb, pos, len, di_bh);
 	if (ret) {
@@ -1701,12 +1720,36 @@ int ocfs2_write_begin_nolock(struct address_space *mapping,
 	}
 
 	ret = ocfs2_populate_write_desc(inode, wc, &clusters_to_alloc,
-					&extents_to_split);
-	if (ret) {
+					&extents_to_split, &refcounted_cpos);
+	if (ret && ret != -ETXTBSY) {
 		mlog_errno(ret);
 		goto out;
 	}
 
+	if (ret == -ETXTBSY) {
+		BUG_ON(refcounted_cpos == UINT_MAX);
+		cow_len = wc->w_clen - (refcounted_cpos - wc->w_cpos);
+
+		ret = ocfs2_refcount_cow(inode, di_bh,
+					 refcounted_cpos, cow_len);
+		if (ret) {
+			mlog_errno(ret);
+			goto out;
+		}
+
+		/* reinitialize write_desc and populate it again. */
+		ocfs2_clear_write_desc(wc);
+		ret = ocfs2_populate_write_desc(inode, wc, &clusters_to_alloc,
+						&extents_to_split,
+						&refcounted_cpos);
+		if (ret) {
+			mlog_errno(ret);
+			goto out;
+		}
+
+		BUG_ON(refcounted_cpos != UINT_MAX);
+	}
+
 	di = (struct ocfs2_dinode *)wc->w_di_bh->b_data;
 
 	/*
-- 
1.6.2.rc2.16.gf474c
