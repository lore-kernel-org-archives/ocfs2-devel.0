From: Tao Ma <tao.ma@oracle.com>
Date: Thu,  4 Nov 2010 15:14:11 +0800
Subject: [Ocfs2-devel] [PATCH v2] ocfs2: Try to free truncate log when
	meeting ENOSPC in write.
In-Reply-To: <1288078148-6343-1-git-send-email-tao.ma@oracle.com>
References: <1288078148-6343-1-git-send-email-tao.ma@oracle.com>
Message-ID: <1288854851-25989-1-git-send-email-tao.ma@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Recently, one of our colleagues meet with a problem that if we
write/delete a 32mb files repeatly, we will get an ENOSPC in
the end. And the corresponding bug is 1288.
http://oss.oracle.com/bugzilla/show_bug.cgi?id=1288

The real problem is that although we have freed the clusters,
they are in truncate log and they will be summed up so that
we can free them once in a whole.

So this patch just try to resolve it. In case we see -ENOSPC
in ocfs2_write_begin_no_lock, we will check whether the truncate
log has enough clusters for our need, if yes, we will try to
flush the truncate log at that point and try again. This method
is inspired by Mark Fasheh <mfasheh@suse.com>. Thanks.

Cc: Mark Fasheh <mfasheh@suse.com>
Signed-off-by: Tao Ma <tao.ma@oracle.com>
---
 fs/ocfs2/alloc.c |    3 ++
 fs/ocfs2/aops.c  |   59 +++++++++++++++++++++++++++++++++++++++++++++++++++++-
 fs/ocfs2/ocfs2.h |    5 ++++
 3 files changed, 66 insertions(+), 1 deletions(-)

diff --git a/fs/ocfs2/alloc.c b/fs/ocfs2/alloc.c
index 592fae5..8ec418d 100644
--- a/fs/ocfs2/alloc.c
+++ b/fs/ocfs2/alloc.c
@@ -5858,6 +5858,7 @@ int ocfs2_truncate_log_append(struct ocfs2_super *osb,
 
 	ocfs2_journal_dirty(handle, tl_bh);
 
+	osb->truncated_clusters += num_clusters;
 bail:
 	mlog_exit(status);
 	return status;
@@ -5929,6 +5930,8 @@ static int ocfs2_replay_truncate_records(struct ocfs2_super *osb,
 		i--;
 	}
 
+	osb->truncated_clusters = 0;
+
 bail:
 	mlog_exit(status);
 	return status;
diff --git a/fs/ocfs2/aops.c b/fs/ocfs2/aops.c
index 5cfeee1..108743f 100644
--- a/fs/ocfs2/aops.c
+++ b/fs/ocfs2/aops.c
@@ -1642,6 +1642,43 @@ static int ocfs2_zero_tail(struct inode *inode, struct buffer_head *di_bh,
 	return ret;
 }
 
+/*
+ * Try to flush truncate logs if we can free enough clusters from it.
+ * As for return value, "< 0" means error, "0" no space and "1" means
+ * we have freed enough spaces and let the caller try to allocate again.
+ */
+static int ocfs2_try_to_free_truncate_log(struct ocfs2_super *osb,
+					  unsigned int needed)
+{
+	tid_t target;
+	int ret = 0;
+	unsigned int truncated_clusters;
+
+	mutex_lock(&osb->osb_tl_inode->i_mutex);
+	truncated_clusters = osb->truncated_clusters;
+	mutex_unlock(&osb->osb_tl_inode->i_mutex);
+
+	/*
+	 * Check whether we can succeed in allocating if we free
+	 * the truncate log.
+	 */
+	if (truncated_clusters < needed)
+		goto out;
+
+	ret = ocfs2_flush_truncate_log(osb);
+	if (ret) {
+		mlog_errno(ret);
+		goto out;
+	}
+
+	if (jbd2_journal_start_commit(osb->journal->j_journal, &target)) {
+		jbd2_log_wait_commit(osb->journal->j_journal, target);
+		ret = 1;
+	}
+out:
+	return ret;
+}
+
 int ocfs2_write_begin_nolock(struct file *filp,
 			     struct address_space *mapping,
 			     loff_t pos, unsigned len, unsigned flags,
@@ -1649,7 +1686,7 @@ int ocfs2_write_begin_nolock(struct file *filp,
 			     struct buffer_head *di_bh, struct page *mmap_page)
 {
 	int ret, cluster_of_pages, credits = OCFS2_INODE_UPDATE_CREDITS;
-	unsigned int clusters_to_alloc, extents_to_split;
+	unsigned int clusters_to_alloc, extents_to_split, clusters_need = 0;
 	struct ocfs2_write_ctxt *wc;
 	struct inode *inode = mapping->host;
 	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
@@ -1658,7 +1695,9 @@ int ocfs2_write_begin_nolock(struct file *filp,
 	struct ocfs2_alloc_context *meta_ac = NULL;
 	handle_t *handle;
 	struct ocfs2_extent_tree et;
+	int try_free = 1, ret1;
 
+try_again:
 	ret = ocfs2_alloc_write_ctxt(&wc, osb, pos, len, di_bh);
 	if (ret) {
 		mlog_errno(ret);
@@ -1693,6 +1732,7 @@ int ocfs2_write_begin_nolock(struct file *filp,
 		mlog_errno(ret);
 		goto out;
 	} else if (ret == 1) {
+		clusters_need = wc->w_clen;
 		ret = ocfs2_refcount_cow(inode, filp, di_bh,
 					 wc->w_cpos, wc->w_clen, UINT_MAX);
 		if (ret) {
@@ -1707,6 +1747,7 @@ int ocfs2_write_begin_nolock(struct file *filp,
 		mlog_errno(ret);
 		goto out;
 	}
+	clusters_need += clusters_to_alloc;
 
 	di = (struct ocfs2_dinode *)wc->w_di_bh->b_data;
 
@@ -1829,6 +1870,22 @@ out:
 		ocfs2_free_alloc_context(data_ac);
 	if (meta_ac)
 		ocfs2_free_alloc_context(meta_ac);
+
+	if (ret == -ENOSPC && try_free) {
+		/*
+		 * Try to free some truncate log so that we can have enough
+		 * clusters to allocate.
+		 */
+		try_free = 0;
+
+		ret1 = ocfs2_try_to_free_truncate_log(osb, clusters_need);
+		if (ret1 == 1)
+			goto try_again;
+
+		if (ret1 < 0)
+			mlog_errno(ret1);
+	}
+
 	return ret;
 }
 
diff --git a/fs/ocfs2/ocfs2.h b/fs/ocfs2/ocfs2.h
index d840821..f641b27 100644
--- a/fs/ocfs2/ocfs2.h
+++ b/fs/ocfs2/ocfs2.h
@@ -420,6 +420,11 @@ struct ocfs2_super
 	struct inode			*osb_tl_inode;
 	struct buffer_head		*osb_tl_bh;
 	struct delayed_work		osb_truncate_log_wq;
+	/*
+	 * How many clusters in our truncate log.
+	 * It must be protected by osb_tl_inode->i_mutex.
+	 */
+	unsigned int truncated_clusters;
 
 	struct ocfs2_node_map		osb_recovering_orphan_dirs;
 	unsigned int			*osb_orphan_wipes;
-- 
1.7.1.571.gba4d01
