From: Tao Ma <tao.ma@oracle.com>
Date: Thu, 30 Oct 2008 13:42:12 +0800
Subject: [Ocfs2-devel] [PATCH 02/15] ocfs2: Add clusters free in
	dealloc_ctxt.
In-Reply-To: <49099B13.9030802@oracle.com>
References: <49099B13.9030802@oracle.com>
Message-ID: <1225345335-11527-2-git-send-email-tao.ma@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Now in ocfs2 xattr set, the whole process are divided into many small
parts and they are wrapped into diffrent transactions and it make the
set doesn't look like a real transaction. So we want to integrate it
into a real one.

In some cases we will allocate some clusters and free some in just one
transaction. e.g, one xattr is larger than inline size, so it and its
value root is stored within the inode while the value is outside in a
cluster. Then we try to update it with a smaller value(larger than the
size of root but smaller than inline size), we may need to free the
outside cluster while allocate a new bucket(one cluster) since now the
inode may be full. The old solution will lock the global_bitmap(if the
local alloc failed in stress test) and then the truncate log. This will
cause a ABBA lock with truncate log flush.

This patch add the clusters free in dealloc_ctxt, so that we can record
the free clusters during the transaction and then free it after we
release the global_bitmap in xattr set.

Signed-off-by: Tao Ma <tao.ma@oracle.com>
---
 fs/ocfs2/alloc.c |   80 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/ocfs2/alloc.h |    4 +++
 2 files changed, 84 insertions(+), 0 deletions(-)

diff --git a/fs/ocfs2/alloc.c b/fs/ocfs2/alloc.c
index 0cc2deb..3c54572 100644
--- a/fs/ocfs2/alloc.c
+++ b/fs/ocfs2/alloc.c
@@ -5801,6 +5801,11 @@ int ocfs2_truncate_log_init(struct ocfs2_super *osb)
 
 /*
  * Describes a single block free from a suballocator
+ *
+ * XXX:
+ * This structure is reused when we free a number of clusters
+ * during xattr set. In that case, free_bit indicates the number
+ * of the free clusters.
  */
 struct ocfs2_cached_block_free {
 	struct ocfs2_cached_block_free		*free_next;
@@ -5893,6 +5898,73 @@ out:
 	return ret;
 }
 
+int ocfs2_cache_clusters_dealloc(struct ocfs2_cached_dealloc_ctxt *ctxt,
+				 u64 blkno, unsigned int bit)
+{
+	int ret = 0;
+	struct ocfs2_cached_block_free *item;
+
+	item = kmalloc(sizeof(*item), GFP_NOFS);
+	if (item == NULL) {
+		ret = -ENOMEM;
+		mlog_errno(ret);
+		return ret;
+	}
+
+	mlog(0, "Insert clusters: (bit %u, blk %llu)\n",
+	     bit, (unsigned long long)blkno);
+
+	item->free_blk = blkno;
+	item->free_bit = bit;
+	item->free_next = ctxt->c_clusters_list;
+
+	return ret;
+}
+
+static int ocfs2_free_clusters_list(struct ocfs2_super *osb,
+				    struct ocfs2_cached_block_free *head)
+{
+	struct ocfs2_cached_block_free *tmp;
+	struct inode *tl_inode = osb->osb_tl_inode;
+	handle_t *handle;
+	int ret = 0;
+
+	mutex_lock(&tl_inode->i_mutex);
+
+	handle = ocfs2_start_trans(osb, OCFS2_TRUNCATE_LOG_UPDATE);
+	if (IS_ERR(handle)) {
+		ret = PTR_ERR(handle);
+		mlog_errno(ret);
+		goto out_mutex;
+	}
+
+	while (head) {
+		ret = ocfs2_truncate_log_append(osb, handle, head->free_blk,
+						head->free_bit);
+		if (ret) {
+			mlog_errno(ret);
+			break;
+		}
+		tmp = head;
+		head = head->free_next;
+		kfree(tmp);
+	}
+
+	ocfs2_commit_trans(osb, handle);
+
+out_mutex:
+	mutex_unlock(&tl_inode->i_mutex);
+
+	while (head) {
+		/* Premature exit may have left some dangling items. */
+		tmp = head;
+		head = head->free_next;
+		kfree(tmp);
+	}
+
+	return ret;
+}
+
 int ocfs2_run_deallocs(struct ocfs2_super *osb,
 		       struct ocfs2_cached_dealloc_ctxt *ctxt)
 {
@@ -5920,6 +5992,14 @@ int ocfs2_run_deallocs(struct ocfs2_super *osb,
 		kfree(fl);
 	}
 
+	if (ctxt->c_clusters_list) {
+		ret2 = ocfs2_free_clusters_list(osb, ctxt->c_clusters_list);
+		if (ret2)
+			mlog_errno(ret2);
+		if (!ret)
+			ret = ret2;
+	}
+
 	return ret;
 }
 
diff --git a/fs/ocfs2/alloc.h b/fs/ocfs2/alloc.h
index 70257c8..1333a92 100644
--- a/fs/ocfs2/alloc.h
+++ b/fs/ocfs2/alloc.h
@@ -167,11 +167,15 @@ int __ocfs2_flush_truncate_log(struct ocfs2_super *osb);
  */
 struct ocfs2_cached_dealloc_ctxt {
 	struct ocfs2_per_slot_free_list		*c_first_suballocator;
+	struct ocfs2_cached_block_free 		*c_clusters_list;
 };
 static inline void ocfs2_init_dealloc_ctxt(struct ocfs2_cached_dealloc_ctxt *c)
 {
 	c->c_first_suballocator = NULL;
+	c->c_clusters_list = NULL;
 }
+int ocfs2_cache_clusters_dealloc(struct ocfs2_cached_dealloc_ctxt *ctxt,
+				 u64 blkno, unsigned int bit);
 int ocfs2_run_deallocs(struct ocfs2_super *osb,
 		       struct ocfs2_cached_dealloc_ctxt *ctxt);
 
-- 
1.5.4.GIT
