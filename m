From: Tao Ma <tao.ma@oracle.com>
Date: Fri,  3 Apr 2009 07:45:54 +0800
Subject: [Ocfs2-devel] [PATCH 15/42] ocfs2: Add functions for extents
	refcounted.
In-Reply-To: <49D5CAC2.4010201@oracle.com>
References: <49D5CAC2.4010201@oracle.com>
Message-ID: <1238715981-21488-15-git-send-email-tao.ma@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Add function ocfs2_mark_extent_refcounted which can mark
an extent refcounted.

Signed-off-by: Tao Ma <tao.ma@oracle.com>
---
 fs/ocfs2/alloc.c        |   12 ++++++------
 fs/ocfs2/alloc.h        |    6 ++++++
 fs/ocfs2/ocfs2.h        |    7 +++++++
 fs/ocfs2/refcounttree.c |   39 +++++++++++++++++++++++++++++++++++++++
 4 files changed, 58 insertions(+), 6 deletions(-)

diff --git a/fs/ocfs2/alloc.c b/fs/ocfs2/alloc.c
index 7221073..bbfb15a 100644
--- a/fs/ocfs2/alloc.c
+++ b/fs/ocfs2/alloc.c
@@ -5067,12 +5067,12 @@ out:
 	return ret;
 }
 
-static int ocfs2_change_extent_flag(handle_t *handle,
-				    struct ocfs2_extent_tree *et,
-				    u32 cpos, u32 len, u32 phys,
-				    struct ocfs2_alloc_context *meta_ac,
-				    struct ocfs2_cached_dealloc_ctxt *dealloc,
-				    int new_flags, int clear_flags)
+int ocfs2_change_extent_flag(handle_t *handle,
+			     struct ocfs2_extent_tree *et,
+			     u32 cpos, u32 len, u32 phys,
+			     struct ocfs2_alloc_context *meta_ac,
+			     struct ocfs2_cached_dealloc_ctxt *dealloc,
+			     int new_flags, int clear_flags)
 {
 	int ret, index;
 	struct super_block *sb = ocfs2_metadata_cache_get_super(et->et_ci);
diff --git a/fs/ocfs2/alloc.h b/fs/ocfs2/alloc.h
index c89197a..6ea9ecf 100644
--- a/fs/ocfs2/alloc.h
+++ b/fs/ocfs2/alloc.h
@@ -122,6 +122,12 @@ int ocfs2_mark_extent_written(struct inode *inode,
 			      handle_t *handle, u32 cpos, u32 len, u32 phys,
 			      struct ocfs2_alloc_context *meta_ac,
 			      struct ocfs2_cached_dealloc_ctxt *dealloc);
+int ocfs2_change_extent_flag(handle_t *handle,
+			     struct ocfs2_extent_tree *et,
+			     u32 cpos, u32 len, u32 phys,
+			     struct ocfs2_alloc_context *meta_ac,
+			     struct ocfs2_cached_dealloc_ctxt *dealloc,
+			     int new_flags, int clear_flags);
 int ocfs2_remove_extent(handle_t *handle, struct ocfs2_extent_tree *et,
 			u32 cpos, u32 len,
 			struct ocfs2_alloc_context *meta_ac,
diff --git a/fs/ocfs2/ocfs2.h b/fs/ocfs2/ocfs2.h
index fb2d092..74db43f 100644
--- a/fs/ocfs2/ocfs2.h
+++ b/fs/ocfs2/ocfs2.h
@@ -431,6 +431,13 @@ static inline int ocfs2_meta_ecc(struct ocfs2_super *osb)
 	return 0;
 }
 
+static inline int ocfs2_refcount_tree(struct ocfs2_super *osb)
+{
+	if (osb->s_feature_incompat & OCFS2_FEATURE_INCOMPAT_REFCOUNT_TREE)
+		return 1;
+	return 0;
+}
+
 /* set / clear functions because cluster events can make these happen
  * in parallel so we want the transitions to be atomic. this also
  * means that any future flags osb_flags must be protected by spinlock
diff --git a/fs/ocfs2/refcounttree.c b/fs/ocfs2/refcounttree.c
index 6b42ce8..73b49cd 100644
--- a/fs/ocfs2/refcounttree.c
+++ b/fs/ocfs2/refcounttree.c
@@ -678,3 +678,42 @@ out:
 	brelse(ref_bh);
 	return ret;
 }
+
+/*
+ * Mark the already-existing extent at cpos as refcounted for len clusters.
+ * This adds the refcount extent flag.
+ *
+ * If the existing extent is larger than the request, initiate a
+ * split. An attempt will be made at merging with adjacent extents.
+ *
+ * The caller is responsible for passing down meta_ac if we'll need it.
+ */
+static int ocfs2_mark_extent_refcounted(struct inode *inode,
+				struct ocfs2_extent_tree *et,
+				handle_t *handle, u32 cpos,
+				u32 len, u32 phys,
+				struct ocfs2_alloc_context *meta_ac,
+				struct ocfs2_cached_dealloc_ctxt *dealloc)
+{
+	int ret;
+
+	mlog(0, "Inode %lu refcount tree cpos %u, len %u, phys cluster %u\n",
+	     inode->i_ino, cpos, len, phys);
+
+	if (!ocfs2_refcount_tree(OCFS2_SB(inode->i_sb))) {
+		ocfs2_error(inode->i_sb, "Inode %lu want to use refcount "
+			    "tree, but the feature bit is not set in the "
+			    "super block.", inode->i_ino);
+		ret = -EROFS;
+		goto out;
+	}
+
+	ret = ocfs2_change_extent_flag(handle, et, cpos,
+				       len, phys, meta_ac, dealloc,
+				       OCFS2_EXT_REFCOUNTED, 0);
+	if (ret)
+		mlog_errno(ret);
+
+out:
+	return ret;
+}
-- 
1.6.2.rc2.16.gf474c
