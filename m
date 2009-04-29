From: Tao Ma <tao.ma@oracle.com>
Date: Thu, 30 Apr 2009 06:58:35 +0800
Subject: [Ocfs2-devel] [PATCH 23/39] ocfs2: lock refcount tree if needed.
In-Reply-To: <49F95A79.6040806@oracle.com>
References: <49F95A79.6040806@oracle.com>
Message-ID: <1241045931-24607-23-git-send-email-tao.ma@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Signed-off-by: Tao Ma <tao.ma@oracle.com>
---
 fs/ocfs2/alloc.c        |   17 +++++++++++-
 fs/ocfs2/refcounttree.c |   68 +++++++++++++++++++++++++++++------------------
 2 files changed, 58 insertions(+), 27 deletions(-)

diff --git a/fs/ocfs2/alloc.c b/fs/ocfs2/alloc.c
index 09f47f8..013e600 100644
--- a/fs/ocfs2/alloc.c
+++ b/fs/ocfs2/alloc.c
@@ -7283,6 +7283,7 @@ int ocfs2_commit_truncate(struct ocfs2_super *osb,
 	struct ocfs2_path *path = NULL;
 	struct ocfs2_dinode *di = (struct ocfs2_dinode *)fe_bh->b_data;
 	struct ocfs2_alloc_context *meta_ac = NULL;
+	struct ocfs2_refcount_tree *ref_tree = NULL;
 
 	mlog_entry_void();
 
@@ -7294,11 +7295,21 @@ int ocfs2_commit_truncate(struct ocfs2_super *osb,
 	if (!path) {
 		status = -ENOMEM;
 		mlog_errno(status);
-		goto bail;
+		goto free;
 	}
 
 	ocfs2_extent_map_trunc(inode, new_highest_cpos);
 
+	if (OCFS2_I(inode)->ip_dyn_features & OCFS2_HAS_REFCOUNT_FL) {
+		status = ocfs2_lock_refcount_tree(osb,
+						le64_to_cpu(di->i_refcount_loc),
+						1, &ref_tree, NULL);
+		if (status) {
+			mlog_errno(status);
+			goto free;
+		}
+	}
+
 start:
 	/*
 	 * Check that we still have allocation to delete.
@@ -7446,8 +7457,12 @@ bail:
 	if (meta_ac)
 		ocfs2_free_alloc_context(meta_ac);
 
+	if (ref_tree)
+		ocfs2_unlock_refcount_tree(osb, ref_tree, 1);
+
 	ocfs2_run_deallocs(osb, &tc->tc_dealloc);
 
+free:
 	ocfs2_free_path(path);
 
 	/* This will drop the ext_alloc cluster lock for us */
diff --git a/fs/ocfs2/refcounttree.c b/fs/ocfs2/refcounttree.c
index ec9ee66..56c8c52 100644
--- a/fs/ocfs2/refcounttree.c
+++ b/fs/ocfs2/refcounttree.c
@@ -54,6 +54,9 @@ struct ocfs2_cow_context {
 	u32 cow_len;
 };
 
+static void ocfs2_delete_refcount_tree(struct ocfs2_super *osb,
+				       struct ocfs2_refcount_tree *tree);
+
 static int ocfs2_validate_refcount_block(struct super_block *sb,
 					 struct buffer_head *bh)
 {
@@ -232,15 +235,16 @@ int ocfs2_set_refcount_tree(struct inode *inode,
 	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
 	struct buffer_head *ref_root_bh = NULL;
 	struct ocfs2_refcount_block *rb;
+	struct ocfs2_refcount_tree *ref_tree;
 
 	BUG_ON(oi->ip_dyn_features & OCFS2_HAS_REFCOUNT_FL);
 	BUG_ON(di->i_refcount_loc);
 
-	ret = ocfs2_read_refcount_block(INODE_CACHE(inode),
-					refcount_loc, &ref_root_bh);
+	ret = ocfs2_lock_refcount_tree(osb, refcount_loc, 1,
+				       &ref_tree, &ref_root_bh);
 	if (ret) {
 		mlog_errno(ret);
-		goto out;
+		return ret;
 	}
 
 	handle = ocfs2_start_trans(osb, OCFS2_REFCOUNT_TREE_SET_CREDITS);
@@ -275,9 +279,11 @@ int ocfs2_set_refcount_tree(struct inode *inode,
 	di->i_refcount_loc = cpu_to_le64(refcount_loc);
 	spin_unlock(&oi->ip_lock);
 	ocfs2_journal_dirty(handle, di_bh);
+
 out_commit:
 	ocfs2_commit_trans(osb, handle);
 out:
+	ocfs2_unlock_refcount_tree(osb, ref_tree, 1);
 	brelse(ref_root_bh);
 
 	return ret;
@@ -285,7 +291,7 @@ out:
 
 int ocfs2_remove_refcount_tree(struct inode *inode, struct buffer_head *di_bh)
 {
-	int ret;
+	int ret, delete_tree = 0;
 	handle_t *handle = NULL;
 	struct ocfs2_dinode *di = (struct ocfs2_dinode *)di_bh->b_data;
 	struct ocfs2_inode_info *oi = OCFS2_I(inode);
@@ -294,19 +300,19 @@ int ocfs2_remove_refcount_tree(struct inode *inode, struct buffer_head *di_bh)
 	struct inode *alloc_inode = NULL;
 	struct buffer_head *alloc_bh = NULL;
 	struct buffer_head *blk_bh = NULL;
+	struct ocfs2_refcount_tree *ref_tree;
 	int credits = OCFS2_INODE_UPDATE_CREDITS + 1;
-	u64 blk = 0, bg_blkno = 0;
+	u64 blk = 0, bg_blkno = 0, ref_blkno = le64_to_cpu(di->i_refcount_loc);
 	u16 bit = 0;
 
 	if (!(oi->ip_dyn_features & OCFS2_HAS_REFCOUNT_FL))
 		return 0;
 
-	ret = ocfs2_read_refcount_block(INODE_CACHE(inode),
-					le64_to_cpu(di->i_refcount_loc),
-					&blk_bh);
+	BUG_ON(!ref_blkno);
+	ret = ocfs2_lock_refcount_tree(osb, ref_blkno, 1, &ref_tree, &blk_bh);
 	if (ret) {
 		mlog_errno(ret);
-		goto out;
+		return ret;
 	}
 
 	rb = (struct ocfs2_refcount_block *)blk_bh->b_data;
@@ -371,6 +377,7 @@ int ocfs2_remove_refcount_tree(struct inode *inode, struct buffer_head *di_bh)
 	ocfs2_journal_dirty(handle, blk_bh);
 
 	if (!rb->rf_count) {
+		delete_tree = 1;
 		ret = ocfs2_free_suballoc_bits(handle, alloc_inode,
 					       alloc_bh, bit, bg_blkno, 1);
 		if (ret)
@@ -390,6 +397,9 @@ out_mutex:
 		iput(alloc_inode);
 	}
 out:
+	ocfs2_unlock_refcount_tree(osb, ref_tree, 1);
+	if (delete_tree)
+		ocfs2_delete_refcount_tree(osb, ref_tree);
 	brelse(blk_bh);
 
 	return ret;
@@ -2422,9 +2432,11 @@ int ocfs2_refcount_cow(struct inode *inode,
 	int ret, has_data = 0, num_pages = 0;
 	u32 cow_start = 0, cow_len = 0;
 	struct ocfs2_inode_info *oi = OCFS2_I(inode);
+	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
 	struct ocfs2_dinode *di = (struct ocfs2_dinode *)di_bh->b_data;
 	struct buffer_head *ref_root_bh = NULL;
 	struct page **pages = NULL;
+	struct ocfs2_refcount_tree *ref_tree;
 	loff_t start, end;
 
 	BUG_ON(!(oi->ip_dyn_features & OCFS2_HAS_REFCOUNT_FL));
@@ -2434,7 +2446,7 @@ int ocfs2_refcount_cow(struct inode *inode,
 					      &cow_start, &cow_len, &has_data);
 	if (ret) {
 		mlog_errno(ret);
-		goto out;
+		return ret;
 	}
 	mlog(0, "CoW inode %lu, cpos %u, write_len %u, cow_start %u, "
 	     "cow_len %u\n", inode->i_ino,
@@ -2461,9 +2473,8 @@ int ocfs2_refcount_cow(struct inode *inode,
 		}
 	}
 
-	ret = ocfs2_read_refcount_block(INODE_CACHE(inode),
-					le64_to_cpu(di->i_refcount_loc),
-					&ref_root_bh);
+	ret = ocfs2_lock_refcount_tree(osb, le64_to_cpu(di->i_refcount_loc),
+				       1, &ref_tree, &ref_root_bh);
 	if (ret) {
 		mlog_errno(ret);
 		goto out;
@@ -2474,12 +2485,13 @@ int ocfs2_refcount_cow(struct inode *inode,
 	if (ret)
 		mlog_errno(ret);
 
+	ocfs2_unlock_refcount_tree(osb, ref_tree, 1);
+	brelse(ref_root_bh);
 out:
 	if (pages) {
 		ocfs2_unlock_and_free_pages(pages, num_pages);
 		kfree(pages);
 	}
-	brelse(ref_root_bh);
 	return ret;
 }
 
@@ -2557,6 +2569,8 @@ static int ocfs2_attach_refcount_tree(struct inode *inode,
 	struct buffer_head *ref_root_bh = NULL;
 	struct ocfs2_inode_info *oi = OCFS2_I(inode);
 	struct ocfs2_dinode *di = (struct ocfs2_dinode *)fe_bh->b_data;
+	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
+	struct ocfs2_refcount_tree *ref_tree;
 	unsigned int ext_flags;
 	loff_t size;
 	u32 cpos, num_clusters, clusters, p_cluster;
@@ -2574,9 +2588,9 @@ static int ocfs2_attach_refcount_tree(struct inode *inode,
 	}
 
 	BUG_ON(!di->i_refcount_loc);
-	ret = ocfs2_read_refcount_block(INODE_CACHE(inode),
-					le64_to_cpu(di->i_refcount_loc),
-					&ref_root_bh);
+	ret = ocfs2_lock_refcount_tree(osb,
+				       le64_to_cpu(di->i_refcount_loc), 1,
+				       &ref_tree, &ref_root_bh);
 	if (ret) {
 		mlog_errno(ret);
 		goto out;
@@ -2612,13 +2626,14 @@ static int ocfs2_attach_refcount_tree(struct inode *inode,
 	 * record from the disk.
 	 */
 	ocfs2_extent_map_trunc(inode, 0);
+	ocfs2_unlock_refcount_tree(osb, ref_tree, 1);
 	brelse(ref_root_bh);
-out:
 
 	if (!ret && ocfs2_dealloc_has_cluster(&dealloc)) {
-		ocfs2_schedule_truncate_log_flush(OCFS2_SB(inode->i_sb), 1);
-		ocfs2_run_deallocs(OCFS2_SB(inode->i_sb), &dealloc);
+		ocfs2_schedule_truncate_log_flush(osb, 1);
+		ocfs2_run_deallocs(osb, &dealloc);
 	}
+out:
 	return ret;
 }
 
@@ -2768,6 +2783,7 @@ static int ocfs2_create_reflink_node(struct inode *s_inode,
 	struct ocfs2_super *osb = OCFS2_SB(s_inode->i_sb);
 	struct ocfs2_refcount_block *rb;
 	struct ocfs2_dinode *di = (struct ocfs2_dinode *)s_bh->b_data;
+	struct ocfs2_refcount_tree *ref_tree;
 	struct ocfs2_extent_list *el;
 
 	ocfs2_init_dealloc_ctxt(&dealloc);
@@ -2779,9 +2795,8 @@ static int ocfs2_create_reflink_node(struct inode *s_inode,
 		goto out;
 	}
 
-	ret = ocfs2_read_refcount_block(INODE_CACHE(t_inode),
-					le64_to_cpu(di->i_refcount_loc),
-					&ref_root_bh);
+	ret = ocfs2_lock_refcount_tree(osb, le64_to_cpu(di->i_refcount_loc),
+				       1, &ref_tree, &ref_root_bh);
 	if (ret) {
 		mlog_errno(ret);
 		goto out;
@@ -2794,21 +2809,22 @@ static int ocfs2_create_reflink_node(struct inode *s_inode,
 					  ref_root_bh, &dealloc);
 	if (ret) {
 		mlog_errno(ret);
-		goto out;
+		goto out_unlock_refcount;
 	}
 
 	ret = ocfs2_complete_reflink(s_inode, t_inode, t_bh);
 	if (ret)
 		mlog_errno(ret);
 
+out_unlock_refcount:
+	ocfs2_unlock_refcount_tree(osb, ref_tree, 1);
+	brelse(ref_root_bh);
 out:
 	if (ocfs2_dealloc_has_cluster(&dealloc)) {
 		ocfs2_schedule_truncate_log_flush(osb, 1);
 		ocfs2_run_deallocs(osb, &dealloc);
 	}
 
-	brelse(ref_root_bh);
-
 	return ret;
 }
 
-- 
1.6.2.rc2.16.gf474c
