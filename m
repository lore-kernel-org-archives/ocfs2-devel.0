From: Tao Ma <tao.ma@oracle.com>
Date: Thu, 16 Sep 2010 14:22:00 +0800
Subject: [Ocfs2-devel] [PATCH 3/3] ocfs2: Start journal checkpoint if we
	have too many truncated clusters.
In-Reply-To: <4C91B707.8030502@oracle.com>
References: <4C91B707.8030502@oracle.com>
Message-ID: <1284618120-7989-3-git-send-email-tao.ma@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Add a new para 'checkpoint' in ocfs2_truncate_log_needs_flush,
if it finds we need to checkpoint the journal, start it.

For xattr truncate, I don't pass the parameter now since the value
now has a limit of 64K, so I don't think we need a checkpoint there.

Signed-off-by: Tao Ma <tao.ma@oracle.com>
---
 fs/ocfs2/alloc.c |   25 ++++++++++++++++++-------
 fs/ocfs2/alloc.h |    2 +-
 fs/ocfs2/xattr.c |    4 ++--
 3 files changed, 21 insertions(+), 10 deletions(-)

diff --git a/fs/ocfs2/alloc.c b/fs/ocfs2/alloc.c
index c765447..218bc2b 100644
--- a/fs/ocfs2/alloc.c
+++ b/fs/ocfs2/alloc.c
@@ -5646,7 +5646,7 @@ int ocfs2_remove_btree_range(struct inode *inode,
 			     struct ocfs2_cached_dealloc_ctxt *dealloc,
 			     u64 refcount_loc)
 {
-	int ret, credits = 0, extra_blocks = 0;
+	int ret, credits = 0, extra_blocks = 0, checkpoint = 0;
 	u64 phys_blkno = ocfs2_clusters_to_blocks(inode->i_sb, phys_cpos);
 	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
 	struct inode *tl_inode = osb->osb_tl_inode;
@@ -5686,7 +5686,7 @@ int ocfs2_remove_btree_range(struct inode *inode,
 
 	mutex_lock(&tl_inode->i_mutex);
 
-	if (ocfs2_truncate_log_needs_flush(osb)) {
+	if (ocfs2_truncate_log_needs_flush(osb, &checkpoint)) {
 		ret = __ocfs2_flush_truncate_log(osb);
 		if (ret < 0) {
 			mlog_errno(ret);
@@ -5748,11 +5748,14 @@ out:
 	if (ref_tree)
 		ocfs2_unlock_refcount_tree(osb, ref_tree, 1);
 
+	if (!ret && checkpoint)
+		ocfs2_start_checkpoint(osb);
+
 	return ret;
 }
 
 #define FLUSH_TRUNCATE_LOG_RATIO	10
-int ocfs2_truncate_log_needs_flush(struct ocfs2_super *osb)
+int ocfs2_truncate_log_needs_flush(struct ocfs2_super *osb, int *checkpoint)
 {
 	struct buffer_head *tl_bh = osb->osb_tl_bh;
 	struct ocfs2_dinode *di;
@@ -5781,6 +5784,9 @@ int ocfs2_truncate_log_needs_flush(struct ocfs2_super *osb)
 			     " we have %u clusters truncated\n",
 			     watermark, osb->truncated_clusters);
 			flush = 1;
+
+			if (checkpoint)
+				*checkpoint = 1;
 		}
 	}
 
@@ -6187,7 +6193,7 @@ bail:
 int ocfs2_complete_truncate_log_recovery(struct ocfs2_super *osb,
 					 struct ocfs2_dinode *tl_copy)
 {
-	int status = 0;
+	int status = 0, checkpoint = 0;
 	int i;
 	unsigned int clusters, num_recs, start_cluster;
 	u64 start_blk;
@@ -6209,7 +6215,7 @@ int ocfs2_complete_truncate_log_recovery(struct ocfs2_super *osb,
 
 	mutex_lock(&tl_inode->i_mutex);
 	for(i = 0; i < num_recs; i++) {
-		if (ocfs2_truncate_log_needs_flush(osb)) {
+		if (ocfs2_truncate_log_needs_flush(osb, &checkpoint)) {
 			status = __ocfs2_flush_truncate_log(osb);
 			if (status < 0) {
 				mlog_errno(status);
@@ -6240,6 +6246,9 @@ int ocfs2_complete_truncate_log_recovery(struct ocfs2_super *osb,
 bail_up:
 	mutex_unlock(&tl_inode->i_mutex);
 
+	if (!status && checkpoint)
+		ocfs2_start_checkpoint(osb);
+
 	mlog_exit(status);
 	return status;
 }
@@ -6442,12 +6451,12 @@ static int ocfs2_free_cached_clusters(struct ocfs2_super *osb,
 	struct ocfs2_cached_block_free *tmp;
 	struct inode *tl_inode = osb->osb_tl_inode;
 	handle_t *handle;
-	int ret = 0;
+	int ret = 0, checkpoint = 0;
 
 	mutex_lock(&tl_inode->i_mutex);
 
 	while (head) {
-		if (ocfs2_truncate_log_needs_flush(osb)) {
+		if (ocfs2_truncate_log_needs_flush(osb, &checkpoint)) {
 			ret = __ocfs2_flush_truncate_log(osb);
 			if (ret < 0) {
 				mlog_errno(ret);
@@ -6485,6 +6494,8 @@ static int ocfs2_free_cached_clusters(struct ocfs2_super *osb,
 		kfree(tmp);
 	}
 
+	if (!ret && checkpoint)
+		ocfs2_start_checkpoint(osb);
 	return ret;
 }
 
diff --git a/fs/ocfs2/alloc.h b/fs/ocfs2/alloc.h
index 55762b5..967ee21 100644
--- a/fs/ocfs2/alloc.h
+++ b/fs/ocfs2/alloc.h
@@ -182,7 +182,7 @@ int ocfs2_begin_truncate_log_recovery(struct ocfs2_super *osb,
 				      struct ocfs2_dinode **tl_copy);
 int ocfs2_complete_truncate_log_recovery(struct ocfs2_super *osb,
 					 struct ocfs2_dinode *tl_copy);
-int ocfs2_truncate_log_needs_flush(struct ocfs2_super *osb);
+int ocfs2_truncate_log_needs_flush(struct ocfs2_super *osb, int *checkpoint);
 int ocfs2_truncate_log_append(struct ocfs2_super *osb,
 			      handle_t *handle,
 			      u64 start_blk,
diff --git a/fs/ocfs2/xattr.c b/fs/ocfs2/xattr.c
index d03469f..82f1fa2 100644
--- a/fs/ocfs2/xattr.c
+++ b/fs/ocfs2/xattr.c
@@ -3595,7 +3595,7 @@ int ocfs2_xattr_set(struct inode *inode,
 
 	mutex_lock(&tl_inode->i_mutex);
 
-	if (ocfs2_truncate_log_needs_flush(osb)) {
+	if (ocfs2_truncate_log_needs_flush(osb, NULL)) {
 		ret = __ocfs2_flush_truncate_log(osb);
 		if (ret < 0) {
 			mutex_unlock(&tl_inode->i_mutex);
@@ -5447,7 +5447,7 @@ static int ocfs2_rm_xattr_cluster(struct inode *inode,
 
 	mutex_lock(&tl_inode->i_mutex);
 
-	if (ocfs2_truncate_log_needs_flush(osb)) {
+	if (ocfs2_truncate_log_needs_flush(osb, NULL)) {
 		ret = __ocfs2_flush_truncate_log(osb);
 		if (ret < 0) {
 			mlog_errno(ret);
-- 
1.7.1.571.gba4d01
