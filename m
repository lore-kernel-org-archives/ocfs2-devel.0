From: Tao Ma <tao.ma@oracle.com>
Date: Wed, 10 Nov 2010 10:52:19 +0800
Subject: [Ocfs2-devel] [PATCH 1/5] ocfs2: Remove unused truncate function
	from alloc.c
In-Reply-To: <4CDA08B6.2070002@oracle.com>
References: <4CDA08B6.2070002@oracle.com>
Message-ID: <1289357543-2538-1-git-send-email-tao.ma@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Tristan Ye has done some refactoring against our truncate
process, so some functions like ocfs2_prepare_truncate and
ocfs2_free_truncate_context are no use and we'd better
remove them.

Signed-off-by: Tao Ma <tao.ma@oracle.com>
---
 fs/ocfs2/alloc.c |   74 ------------------------------------------------------
 fs/ocfs2/alloc.h |    4 ---
 2 files changed, 0 insertions(+), 78 deletions(-)

diff --git a/fs/ocfs2/alloc.c b/fs/ocfs2/alloc.c
index 592fae5..cd9d1bc 100644
--- a/fs/ocfs2/alloc.c
+++ b/fs/ocfs2/alloc.c
@@ -565,7 +565,6 @@ static inline int ocfs2_et_sanity_check(struct ocfs2_extent_tree *et)
 	return ret;
 }
 
-static void ocfs2_free_truncate_context(struct ocfs2_truncate_context *tc);
 static int ocfs2_cache_extent_block_free(struct ocfs2_cached_dealloc_ctxt *ctxt,
 					 struct ocfs2_extent_block *eb);
 static void ocfs2_adjust_rightmost_records(handle_t *handle,
@@ -7139,64 +7138,6 @@ bail:
 }
 
 /*
- * Expects the inode to already be locked.
- */
-int ocfs2_prepare_truncate(struct ocfs2_super *osb,
-			   struct inode *inode,
-			   struct buffer_head *fe_bh,
-			   struct ocfs2_truncate_context **tc)
-{
-	int status;
-	unsigned int new_i_clusters;
-	struct ocfs2_dinode *fe;
-	struct ocfs2_extent_block *eb;
-	struct buffer_head *last_eb_bh = NULL;
-
-	mlog_entry_void();
-
-	*tc = NULL;
-
-	new_i_clusters = ocfs2_clusters_for_bytes(osb->sb,
-						  i_size_read(inode));
-	fe = (struct ocfs2_dinode *) fe_bh->b_data;
-
-	mlog(0, "fe->i_clusters = %u, new_i_clusters = %u, fe->i_size ="
-	     "%llu\n", le32_to_cpu(fe->i_clusters), new_i_clusters,
-	     (unsigned long long)le64_to_cpu(fe->i_size));
-
-	*tc = kzalloc(sizeof(struct ocfs2_truncate_context), GFP_KERNEL);
-	if (!(*tc)) {
-		status = -ENOMEM;
-		mlog_errno(status);
-		goto bail;
-	}
-	ocfs2_init_dealloc_ctxt(&(*tc)->tc_dealloc);
-
-	if (fe->id2.i_list.l_tree_depth) {
-		status = ocfs2_read_extent_block(INODE_CACHE(inode),
-						 le64_to_cpu(fe->i_last_eb_blk),
-						 &last_eb_bh);
-		if (status < 0) {
-			mlog_errno(status);
-			goto bail;
-		}
-		eb = (struct ocfs2_extent_block *) last_eb_bh->b_data;
-	}
-
-	(*tc)->tc_last_eb_bh = last_eb_bh;
-
-	status = 0;
-bail:
-	if (status < 0) {
-		if (*tc)
-			ocfs2_free_truncate_context(*tc);
-		*tc = NULL;
-	}
-	mlog_exit_void();
-	return status;
-}
-
-/*
  * 'start' is inclusive, 'end' is not.
  */
 int ocfs2_truncate_inline(struct inode *inode, struct buffer_head *di_bh,
@@ -7270,18 +7211,3 @@ out_commit:
 out:
 	return ret;
 }
-
-static void ocfs2_free_truncate_context(struct ocfs2_truncate_context *tc)
-{
-	/*
-	 * The caller is responsible for completing deallocation
-	 * before freeing the context.
-	 */
-	if (tc->tc_dealloc.c_first_suballocator != NULL)
-		mlog(ML_NOTICE,
-		     "Truncate completion has non-empty dealloc context\n");
-
-	brelse(tc->tc_last_eb_bh);
-
-	kfree(tc);
-}
diff --git a/fs/ocfs2/alloc.h b/fs/ocfs2/alloc.h
index 55762b5..3bd08a0 100644
--- a/fs/ocfs2/alloc.h
+++ b/fs/ocfs2/alloc.h
@@ -228,10 +228,6 @@ struct ocfs2_truncate_context {
 
 int ocfs2_zero_range_for_truncate(struct inode *inode, handle_t *handle,
 				  u64 range_start, u64 range_end);
-int ocfs2_prepare_truncate(struct ocfs2_super *osb,
-			   struct inode *inode,
-			   struct buffer_head *fe_bh,
-			   struct ocfs2_truncate_context **tc);
 int ocfs2_commit_truncate(struct ocfs2_super *osb,
 			  struct inode *inode,
 			  struct buffer_head *di_bh);
-- 
1.7.1.GIT
