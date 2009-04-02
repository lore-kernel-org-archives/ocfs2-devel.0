From: Tao Ma <tao.ma@oracle.com>
Date: Fri,  3 Apr 2009 07:46:05 +0800
Subject: [Ocfs2-devel] [PATCH 26/42] ocfs2: lock refcount tree if needed.
In-Reply-To: <49D5CAC2.4010201@oracle.com>
References: <49D5CAC2.4010201@oracle.com>
Message-ID: <1238715981-21488-26-git-send-email-tao.ma@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Signed-off-by: Tao Ma <tao.ma@oracle.com>
---
 fs/ocfs2/alloc.c        |   17 ++++++++++-
 fs/ocfs2/refcounttree.c |   71 +++++++++++++++++++++++++++++------------------
 2 files changed, 60 insertions(+), 28 deletions(-)

diff --git a/fs/ocfs2/alloc.c b/fs/ocfs2/alloc.c
index 5a88705..a09bfb5 100644
--- a/fs/ocfs2/alloc.c
+++ b/fs/ocfs2/alloc.c
@@ -7496,6 +7496,7 @@ int ocfs2_commit_truncate(struct ocfs2_super *osb,
 	struct ocfs2_path *path = NULL;
 	struct ocfs2_dinode *di = (struct ocfs2_dinode *)fe_bh->b_data;
 	struct ocfs2_alloc_context *meta_ac = NULL;
+	struct ocfs2_refcount_tree *ref_tree = NULL;
 
 	mlog_entry_void();
 
@@ -7507,11 +7508,21 @@ int ocfs2_commit_truncate(struct ocfs2_super *osb,
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
@@ -7636,6 +7647,9 @@ start:
 	goto start;
 
 bail:
+	if (ref_tree)
+		ocfs2_unlock_refcount_tree(osb, ref_tree, 1);
+
 	if (!status && OCFS2_I(inode)->ip_clusters == 0) {
 		/* remove the refcount tree. */
 		status = ocfs2_remove_refcount_tree(inode, fe_bh);
@@ -7654,6 +7668,7 @@ bail:
 
 	ocfs2_run_deallocs(osb, &tc->tc_dealloc);
 
+free:
 	ocfs2_free_path(path);
 
 	/* This will drop the ext_alloc cluster lock for us */
diff --git a/fs/ocfs2/refcounttree.c b/fs/ocfs2/refcounttree.c
index f0ed496..9b460db 100644
--- a/fs/ocfs2/refcounttree.c
+++ b/fs/ocfs2/refcounttree.c
@@ -52,6 +52,9 @@ struct ocfs2_cow_context {
 	u32 cow_len;
 };
 
+static void ocfs2_delete_refcount_tree(struct ocfs2_super *osb,
+				       struct ocfs2_refcount_tree *tree);
+
 static int ocfs2_validate_refcount_block(struct super_block *sb,
 					 struct buffer_head *bh)
 {
@@ -228,15 +231,16 @@ int ocfs2_set_refcount_tree(struct inode *inode,
 	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
 	struct buffer_head *ref_bh = NULL;
 	struct ocfs2_refcount_block *rb;
+	struct ocfs2_refcount_tree *ref_tree;
 
 	BUG_ON(oi->ip_dyn_features & OCFS2_HAS_REFCOUNT_FL);
 	BUG_ON(di->i_refcount_loc);
 
-	ret = ocfs2_read_refcount_block(INODE_CACHE(inode),
-					refcount_loc, &ref_bh);
+	ret = ocfs2_lock_refcount_tree(osb, refcount_loc, 1,
+				       &ref_tree, &ref_bh);
 	if (ret) {
 		mlog_errno(ret);
-		goto out;
+		return ret;
 	}
 
 	handle = ocfs2_start_trans(osb, OCFS2_REFCOUNT_TREE_SET_CREDITS);
@@ -271,9 +275,11 @@ int ocfs2_set_refcount_tree(struct inode *inode,
 	di->i_refcount_loc = cpu_to_le64(refcount_loc);
 	spin_unlock(&oi->ip_lock);
 	ocfs2_journal_dirty(handle, di_bh);
+
 out_commit:
 	ocfs2_commit_trans(osb, handle);
 out:
+	ocfs2_unlock_refcount_tree(osb, ref_tree, 1);
 	brelse(ref_bh);
 
 	return ret;
@@ -281,7 +287,7 @@ out:
 
 int ocfs2_remove_refcount_tree(struct inode *inode, struct buffer_head *di_bh)
 {
-	int ret;
+	int ret, delete_tree = 0;
 	handle_t *handle = NULL;
 	struct ocfs2_dinode *di = (struct ocfs2_dinode *)di_bh->b_data;
 	struct ocfs2_inode_info *oi = OCFS2_I(inode);
@@ -290,19 +296,19 @@ int ocfs2_remove_refcount_tree(struct inode *inode, struct buffer_head *di_bh)
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
@@ -367,6 +373,7 @@ int ocfs2_remove_refcount_tree(struct inode *inode, struct buffer_head *di_bh)
 	ocfs2_journal_dirty(handle, blk_bh);
 
 	if (!rb->rf_count) {
+		delete_tree = 1;
 		ret = ocfs2_free_suballoc_bits(handle, alloc_inode,
 					       alloc_bh, bit, bg_blkno, 1);
 		if (ret)
@@ -386,6 +393,9 @@ out_mutex:
 		iput(alloc_inode);
 	}
 out:
+	ocfs2_unlock_refcount_tree(osb, ref_tree, 1);
+	if (delete_tree)
+		ocfs2_delete_refcount_tree(osb, ref_tree);
 	brelse(blk_bh);
 
 	return ret;
@@ -1436,9 +1446,11 @@ int ocfs2_refcount_cow(struct inode *inode,
 	int ret, num_recs = 0, has_data = 0, num_pages = 0;
 	u32 cow_start = 0, cow_len = 0;
 	struct ocfs2_inode_info *oi = OCFS2_I(inode);
+	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
 	struct ocfs2_dinode *di = (struct ocfs2_dinode *)di_bh->b_data;
 	struct buffer_head *ref_bh = NULL;
 	struct page **pages = NULL;
+	struct ocfs2_refcount_tree *ref_tree;
 	loff_t start, end;
 
 	BUG_ON(!(oi->ip_dyn_features & OCFS2_HAS_REFCOUNT_FL));
@@ -1449,7 +1461,7 @@ int ocfs2_refcount_cow(struct inode *inode,
 					       &num_recs, &has_data);
 	if (ret) {
 		mlog_errno(ret);
-		goto out;
+		return ret;
 	}
 	mlog(0, "CoW inode %lu, cpos %u, write_len %u, cow_start %u, "
 	     "cow_len %u, num_recs %d\n", inode->i_ino,
@@ -1476,10 +1488,9 @@ int ocfs2_refcount_cow(struct inode *inode,
 		}
 	}
 
-	ret = ocfs2_read_refcount_block(INODE_CACHE(inode),
-					le64_to_cpu(di->i_refcount_loc),
-					&ref_bh);
-	if (ret < 0) {
+	ret = ocfs2_lock_refcount_tree(osb, le64_to_cpu(di->i_refcount_loc),
+				       1, &ref_tree, &ref_bh);
+	if (ret) {
 		mlog_errno(ret);
 		goto out;
 	}
@@ -1490,12 +1501,13 @@ int ocfs2_refcount_cow(struct inode *inode,
 	if (ret)
 		mlog_errno(ret);
 
+	ocfs2_unlock_refcount_tree(osb, ref_tree, 1);
+	brelse(ref_bh);
 out:
 	if (pages) {
 		ocfs2_unlock_and_free_pages(pages, num_pages);
 		kfree(pages);
 	}
-	brelse(ref_bh);
 	return ret;
 }
 
@@ -1560,6 +1572,8 @@ static int ocfs2_attach_refcount_tree(struct inode *inode,
 	struct buffer_head *ref_bh = NULL;
 	struct ocfs2_inode_info *oi = OCFS2_I(inode);
 	struct ocfs2_dinode *di = (struct ocfs2_dinode *)fe_bh->b_data;
+	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
+	struct ocfs2_refcount_tree *ref_tree;
 	unsigned int ext_flags;
 	loff_t size;
 	u32 cpos, num_clusters, clusters, p_cluster;
@@ -1578,9 +1592,9 @@ static int ocfs2_attach_refcount_tree(struct inode *inode,
 	}
 
 	BUG_ON(!di->i_refcount_loc);
-	ret = ocfs2_read_refcount_block(INODE_CACHE(inode),
-					le64_to_cpu(di->i_refcount_loc),
-					&ref_bh);
+	ret = ocfs2_lock_refcount_tree(osb,
+				       le64_to_cpu(di->i_refcount_loc), 1,
+				       &ref_tree, &ref_bh);
 	if (ret) {
 		mlog_errno(ret);
 		goto out;
@@ -1616,13 +1630,15 @@ static int ocfs2_attach_refcount_tree(struct inode *inode,
 	 * record from the disk.
 	 */
 	ocfs2_extent_map_trunc(inode, 0);
+
+	ocfs2_unlock_refcount_tree(osb, ref_tree, 1);
 	brelse(ref_bh);
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
 
@@ -1756,6 +1772,7 @@ static int ocfs2_create_reflink_node(struct inode *s_inode,
 	struct ocfs2_super *osb = OCFS2_SB(s_inode->i_sb);
 	struct ocfs2_refcount_block *rb;
 	struct ocfs2_dinode *di = (struct ocfs2_dinode *)s_bh->b_data;
+	struct ocfs2_refcount_tree *ref_tree;
 	struct ocfs2_extent_list *el;
 	struct ocfs2_extent_tree ref_et;
 
@@ -1768,9 +1785,8 @@ static int ocfs2_create_reflink_node(struct inode *s_inode,
 		goto out;
 	}
 
-	ret = ocfs2_read_refcount_block(INODE_CACHE(t_inode),
-					le64_to_cpu(di->i_refcount_loc),
-					&ref_bh);
+	ret = ocfs2_lock_refcount_tree(osb, le64_to_cpu(di->i_refcount_loc),
+				       1, &ref_tree, &ref_bh);
 	if (ret) {
 		mlog_errno(ret);
 		goto out;
@@ -1799,7 +1815,7 @@ static int ocfs2_create_reflink_node(struct inode *s_inode,
 							meta_add, &meta_ac);
 		if (ret) {
 			mlog_errno(ret);
-			goto out;
+			goto out_unlock_refcount;
 		}
 	}
 
@@ -1820,14 +1836,15 @@ static int ocfs2_create_reflink_node(struct inode *s_inode,
 out_free_resource:
 	if (meta_ac)
 		ocfs2_free_alloc_context(meta_ac);
+out_unlock_refcount:
+	ocfs2_unlock_refcount_tree(osb, ref_tree, 1);
+	brelse(ref_bh);
 out:
 	if (ocfs2_dealloc_has_cluster(&dealloc)) {
 		ocfs2_schedule_truncate_log_flush(osb, 1);
 		ocfs2_run_deallocs(osb, &dealloc);
 	}
 
-	brelse(ref_bh);
-
 	return ret;
 }
 
-- 
1.6.2.rc2.16.gf474c
