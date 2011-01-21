From: Tristan Ye <tristan.ye@oracle.com>
Date: Fri, 21 Jan 2011 18:20:22 +0800
Subject: [Ocfs2-devel] [PATCH 05/14] Ocfs2/move_extents: lock allocators and
	reserve metadata blocks and data clusters for extents moving.
In-Reply-To: <1295605231-15991-1-git-send-email-tristan.ye@oracle.com>
References: <1295605231-15991-1-git-send-email-tristan.ye@oracle.com>
Message-ID: <1295605231-15991-6-git-send-email-tristan.ye@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

ocfs2_lock_allocators_move_extents() was like the common ocfs2_lock_allocators(),
to lock metadata and data alloctors during extents moving, reserve appropriate
metadata blocks and data clusters, also performa a best- effort to calculate the
credits for journal transaction in one run of movement.

Signed-off-by: Tristan Ye <tristan.ye@oracle.com>
---
 fs/ocfs2/move_extents.c |   61 +++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 61 insertions(+), 0 deletions(-)

diff --git a/fs/ocfs2/move_extents.c b/fs/ocfs2/move_extents.c
index b79c2d3..9b30636 100644
--- a/fs/ocfs2/move_extents.c
+++ b/fs/ocfs2/move_extents.c
@@ -55,3 +55,64 @@ struct ocfs2_move_extents_context {
 	struct ocfs2_alloc_context *data_ac;
 	struct ocfs2_cached_dealloc_ctxt dealloc;
 };
+
+/*
+ * lock allocators, and reserving appropriate number of bits for
+ * meta blocks and data clusters.
+ *
+ * in some cases, we don't need to reserve clusters, just let data_ac
+ * be NULL.
+ */
+static int ocfs2_lock_allocators_move_extents(struct inode *inode,
+					struct ocfs2_extent_tree *et,
+					u32 clusters_to_move,
+					u32 extents_to_split,
+					struct ocfs2_alloc_context **meta_ac,
+					struct ocfs2_alloc_context **data_ac,
+					int extra_blocks,
+					int *credits)
+{
+	int ret, num_free_extents;
+	unsigned int max_recs_needed = 2 * extents_to_split + clusters_to_move;
+	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
+
+	num_free_extents = ocfs2_num_free_extents(osb, et);
+	if (num_free_extents < 0) {
+		ret = num_free_extents;
+		mlog_errno(ret);
+		goto out;
+	}
+
+	if (!num_free_extents ||
+	    (ocfs2_sparse_alloc(osb) && num_free_extents < max_recs_needed))
+		extra_blocks += ocfs2_extend_meta_needed(et->et_root_el);
+
+	ret = ocfs2_reserve_new_metadata_blocks(osb, extra_blocks, meta_ac);
+	if (ret) {
+		mlog_errno(ret);
+		goto out;
+	}
+
+	if (data_ac) {
+		ret = ocfs2_reserve_clusters(osb, clusters_to_move, data_ac);
+		if (ret) {
+			mlog_errno(ret);
+			goto out;
+		}
+	}
+
+	*credits += ocfs2_calc_extend_credits(osb->sb, et->et_root_el,
+					      clusters_to_move + 2);
+
+	mlog(0, "reserve metadata_blocks: %d, data_clusters: %u, credits: %d\n",
+	     extra_blocks, clusters_to_move, *credits);
+out:
+	if (ret) {
+		if (*meta_ac) {
+			ocfs2_free_alloc_context(*meta_ac);
+			*meta_ac = NULL;
+		}
+	}
+
+	return ret;
+}
-- 
1.5.5
