From: akpm at linux-foundation.org <akpm@linux-foundation.org>
Date: Wed, 23 Mar 2016 13:12:00 -0700
Subject: [Ocfs2-devel] [patch 06/25] ocfs2: record UNWRITTEN extents when
	populate write desc
Message-ID: <56f2f890.GEUicU67tA5O5abI%akpm@linux-foundation.org>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

From: Ryan Ding <ryan.ding@oracle.com>
Subject: ocfs2: record UNWRITTEN extents when populate write desc

To support direct io in ocfs2_write_begin_nolock & ocfs2_write_end_nolock.

There is still one issue in the direct write procedure.

phase 1: alloc extent with UNWRITTEN flag
phase 2: submit direct data to disk, add zero page to page cache
phase 3: clear UNWRITTEN flag when data has been written to disk

When there are 2 direct write A(0~3KB),B(4~7KB) writing to the same
cluster 0~7KB (cluster size 8KB).  Write request A arrive phase 2 first,
it will zero the region (4~7KB).  Before request A enter to phase 3,
request B arrive phase 2, it will zero region (0~3KB).  This is just like
request B steps request A.

To resolve this issue, we should let request B knows this cluster is already
under zero, to prevent it from steps the previous write request.

This patch will add function ocfs2_unwritten_check() to do this job.  It
will record all clusters that are under direct write(it will be recorded
in the 'ip_unwritten_list' member of inode info), and prevent the later
direct write writing to the same cluster to do the zero work again.

Signed-off-by: Ryan Ding <ryan.ding@oracle.com>
Reviewed-by: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Joseph Qi <joseph.qi@huawei.com>
Cc: Mark Fasheh <mfasheh@suse.de>
Cc: Joel Becker <jlbec@evilplan.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/aops.c  |  104 ++++++++++++++++++++++++++++++++++++++++++---
 fs/ocfs2/inode.c |    3 +
 fs/ocfs2/inode.h |    3 +
 fs/ocfs2/super.c |    1 
 4 files changed, 106 insertions(+), 5 deletions(-)

diff -puN fs/ocfs2/aops.c~ocfs2-record-unwritten-extents-when-populate-write-desc fs/ocfs2/aops.c
--- a/fs/ocfs2/aops.c~ocfs2-record-unwritten-extents-when-populate-write-desc
+++ a/fs/ocfs2/aops.c
@@ -1201,6 +1201,13 @@ next_bh:
 
 #define OCFS2_MAX_CLUSTERS_PER_PAGE	(PAGE_CACHE_SIZE / OCFS2_MIN_CLUSTERSIZE)
 
+struct ocfs2_unwritten_extent {
+	struct list_head	ue_node;
+	struct list_head	ue_ip_node;
+	u32			ue_cpos;
+	u32			ue_phys;
+};
+
 /*
  * Describe the state of a single cluster to be written to.
  */
@@ -1275,6 +1282,8 @@ struct ocfs2_write_ctxt {
 	struct buffer_head		*w_di_bh;
 
 	struct ocfs2_cached_dealloc_ctxt w_dealloc;
+
+	struct list_head		w_unwritten_list;
 };
 
 void ocfs2_unlock_and_free_pages(struct page **pages, int num_pages)
@@ -1313,8 +1322,25 @@ static void ocfs2_unlock_pages(struct oc
 	ocfs2_unlock_and_free_pages(wc->w_pages, wc->w_num_pages);
 }
 
-static void ocfs2_free_write_ctxt(struct ocfs2_write_ctxt *wc)
+static void ocfs2_free_unwritten_list(struct inode *inode,
+				 struct list_head *head)
+{
+	struct ocfs2_inode_info *oi = OCFS2_I(inode);
+	struct ocfs2_unwritten_extent *dz = NULL, *tmp = NULL;
+
+	list_for_each_entry_safe(dz, tmp, head, ue_node) {
+		list_del(&dz->ue_node);
+		spin_lock(&oi->ip_lock);
+		list_del(&dz->ue_ip_node);
+		spin_unlock(&oi->ip_lock);
+		kfree(dz);
+	}
+}
+
+static void ocfs2_free_write_ctxt(struct inode *inode,
+				  struct ocfs2_write_ctxt *wc)
 {
+	ocfs2_free_unwritten_list(inode, &wc->w_unwritten_list);
 	ocfs2_unlock_pages(wc);
 	brelse(wc->w_di_bh);
 	kfree(wc);
@@ -1346,6 +1372,7 @@ static int ocfs2_alloc_write_ctxt(struct
 		wc->w_large_pages = 0;
 
 	ocfs2_init_dealloc_ctxt(&wc->w_dealloc);
+	INIT_LIST_HEAD(&wc->w_unwritten_list);
 
 	*wcp = wc;
 
@@ -1796,6 +1823,66 @@ static void ocfs2_set_target_boundaries(
 }
 
 /*
+ * Check if this extent is marked UNWRITTEN by direct io. If so, we need not to
+ * do the zero work. And should not to clear UNWRITTEN since it will be cleared
+ * by the direct io procedure.
+ * If this is a new extent that allocated by direct io, we should mark it in
+ * the ip_unwritten_list.
+ */
+static int ocfs2_unwritten_check(struct inode *inode,
+				 struct ocfs2_write_ctxt *wc,
+				 struct ocfs2_write_cluster_desc *desc)
+{
+	struct ocfs2_inode_info *oi = OCFS2_I(inode);
+	struct ocfs2_unwritten_extent *dz = NULL, *new = NULL;
+	int ret = 0;
+
+	if (!desc->c_needs_zero)
+		return 0;
+
+retry:
+	spin_lock(&oi->ip_lock);
+	/* Needs not to zero no metter buffer or direct. The one who is zero
+	 * the cluster is doing zero. And he will clear unwritten after all
+	 * cluster io finished. */
+	list_for_each_entry(dz, &oi->ip_unwritten_list, ue_ip_node) {
+		if (desc->c_cpos == dz->ue_cpos) {
+			BUG_ON(desc->c_new);
+			desc->c_needs_zero = 0;
+			desc->c_clear_unwritten = 0;
+			goto unlock;
+		}
+	}
+
+	if (wc->w_type != OCFS2_WRITE_DIRECT)
+		goto unlock;
+
+	if (new == NULL) {
+		spin_unlock(&oi->ip_lock);
+		new = kmalloc(sizeof(struct ocfs2_unwritten_extent),
+			     GFP_NOFS);
+		if (new == NULL) {
+			ret = -ENOMEM;
+			goto out;
+		}
+		goto retry;
+	}
+	/* This direct write will doing zero. */
+	new->ue_cpos = desc->c_cpos;
+	new->ue_phys = desc->c_phys;
+	desc->c_clear_unwritten = 0;
+	list_add_tail(&new->ue_ip_node, &oi->ip_unwritten_list);
+	list_add_tail(&new->ue_node, &wc->w_unwritten_list);
+	new = NULL;
+unlock:
+	spin_unlock(&oi->ip_lock);
+out:
+	if (new)
+		kfree(new);
+	return ret;
+}
+
+/*
  * Populate each single-cluster write descriptor in the write context
  * with information about the i/o to be done.
  *
@@ -1879,6 +1966,12 @@ static int ocfs2_populate_write_desc(str
 			desc->c_needs_zero = 1;
 		}
 
+		ret = ocfs2_unwritten_check(inode, wc, desc);
+		if (ret) {
+			mlog_errno(ret);
+			goto out;
+		}
+
 		num_clusters--;
 	}
 
@@ -2215,9 +2308,8 @@ try_again:
 	 * and non-sparse clusters we just extended.  For non-sparse writes,
 	 * we know zeros will only be needed in the first and/or last cluster.
 	 */
-	if (clusters_to_alloc || extents_to_split ||
-	    (wc->w_clen && (wc->w_desc[0].c_needs_zero ||
-			    wc->w_desc[wc->w_clen - 1].c_needs_zero)))
+	if (wc->w_clen && (wc->w_desc[0].c_needs_zero ||
+			   wc->w_desc[wc->w_clen - 1].c_needs_zero))
 		cluster_of_pages = 1;
 	else
 		cluster_of_pages = 0;
@@ -2296,7 +2388,7 @@ out_commit:
 	ocfs2_commit_trans(osb, handle);
 
 out:
-	ocfs2_free_write_ctxt(wc);
+	ocfs2_free_write_ctxt(inode, wc);
 
 	if (data_ac) {
 		ocfs2_free_alloc_context(data_ac);
@@ -2406,6 +2498,8 @@ int ocfs2_write_end_nolock(struct addres
 	handle_t *handle = wc->w_handle;
 	struct page *tmppage;
 
+	BUG_ON(!list_empty(&wc->w_unwritten_list));
+
 	if (handle) {
 		ret = ocfs2_journal_access_di(handle, INODE_CACHE(inode),
 				wc->w_di_bh, OCFS2_JOURNAL_ACCESS_WRITE);
diff -puN fs/ocfs2/inode.c~ocfs2-record-unwritten-extents-when-populate-write-desc fs/ocfs2/inode.c
--- a/fs/ocfs2/inode.c~ocfs2-record-unwritten-extents-when-populate-write-desc
+++ a/fs/ocfs2/inode.c
@@ -1170,6 +1170,9 @@ static void ocfs2_clear_inode(struct ino
 	mlog_bug_on_msg(!list_empty(&oi->ip_io_markers),
 			"Clear inode of %llu, inode has io markers\n",
 			(unsigned long long)oi->ip_blkno);
+	mlog_bug_on_msg(!list_empty(&oi->ip_unwritten_list),
+			"Clear inode of %llu, inode has unwritten extents\n",
+			(unsigned long long)oi->ip_blkno);
 
 	ocfs2_extent_map_trunc(inode, 0);
 
diff -puN fs/ocfs2/inode.h~ocfs2-record-unwritten-extents-when-populate-write-desc fs/ocfs2/inode.h
--- a/fs/ocfs2/inode.h~ocfs2-record-unwritten-extents-when-populate-write-desc
+++ a/fs/ocfs2/inode.h
@@ -57,6 +57,9 @@ struct ocfs2_inode_info
 	u32				ip_flags; /* see below */
 	u32				ip_attr; /* inode attributes */
 
+	/* Record unwritten extents during direct io. */
+	struct list_head		ip_unwritten_list;
+
 	/* protected by recovery_lock. */
 	struct inode			*ip_next_orphan;
 
diff -puN fs/ocfs2/super.c~ocfs2-record-unwritten-extents-when-populate-write-desc fs/ocfs2/super.c
--- a/fs/ocfs2/super.c~ocfs2-record-unwritten-extents-when-populate-write-desc
+++ a/fs/ocfs2/super.c
@@ -1745,6 +1745,7 @@ static void ocfs2_inode_init_once(void *
 	spin_lock_init(&oi->ip_lock);
 	ocfs2_extent_map_init(&oi->vfs_inode);
 	INIT_LIST_HEAD(&oi->ip_io_markers);
+	INIT_LIST_HEAD(&oi->ip_unwritten_list);
 	oi->ip_dir_start_lookup = 0;
 	mutex_init(&oi->ip_unaligned_aio);
 	init_rwsem(&oi->ip_alloc_sem);
_
