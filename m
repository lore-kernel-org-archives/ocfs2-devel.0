From: Srinivas Eeda <srinivas.eeda@oracle.com>
Date: Tue, 18 Sep 2012 17:11:00 -0700
Subject: [Ocfs2-devel] [PATCH 2/5] ocfs2: move ocfs2-local-alloc-inode to
	ocfs2-super
In-Reply-To: <1348013463-23980-1-git-send-email-srinivas.eeda@oracle.com>
References: <1348013463-23980-1-git-send-email-srinivas.eeda@oracle.com>
Message-ID: <1348013463-23980-3-git-send-email-srinivas.eeda@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

ocfs2_local_alloc_inode is used in multiple functions. It is convenient if we
move ocfs2_local_alloc_inode to ocfs2 super.

Signed-off-by: Srinivas Eeda <srinivas.eeda@oracle.com>
---
 fs/ocfs2/localalloc.c |   53 ++++++++++++-------------------------------------
 fs/ocfs2/ocfs2.h      |    1 +
 2 files changed, 14 insertions(+), 40 deletions(-)

diff --git a/fs/ocfs2/localalloc.c b/fs/ocfs2/localalloc.c
index 53a162f..45818df 100644
--- a/fs/ocfs2/localalloc.c
+++ b/fs/ocfs2/localalloc.c
@@ -72,8 +72,7 @@ static int ocfs2_local_alloc_new_window(struct ocfs2_super *osb,
 					handle_t *handle,
 					struct ocfs2_alloc_context *ac);
 
-static int ocfs2_local_alloc_slide_window(struct ocfs2_super *osb,
-					  struct inode *local_alloc_inode);
+static int ocfs2_local_alloc_slide_window(struct ocfs2_super *osb);
 
 /*
  * ocfs2_la_default_mb() - determine a default size, in megabytes of
@@ -352,7 +351,8 @@ int ocfs2_load_local_alloc(struct ocfs2_super *osb)
 		     le32_to_cpu(alloc->id1.bitmap1.i_total),
 		     OCFS2_LOCAL_ALLOC(alloc)->la_bm_off);
 
-	osb->local_alloc_bh = alloc_bh;
+	osb->local_alloc_bh    = alloc_bh;
+	osb->local_alloc_inode = inode;
 	osb->local_alloc_state = OCFS2_LA_ENABLED;
 
 bail:
@@ -379,7 +379,6 @@ void ocfs2_shutdown_local_alloc(struct ocfs2_super *osb)
 {
 	int status;
 	handle_t *handle;
-	struct inode *local_alloc_inode = NULL;
 	struct buffer_head *bh = NULL;
 	struct buffer_head *main_bm_bh = NULL;
 	struct inode *main_bm_inode = NULL;
@@ -392,16 +391,6 @@ void ocfs2_shutdown_local_alloc(struct ocfs2_super *osb)
 	if (osb->local_alloc_state == OCFS2_LA_UNUSED)
 		goto out;
 
-	local_alloc_inode =
-		ocfs2_get_system_file_inode(osb,
-					    LOCAL_ALLOC_SYSTEM_INODE,
-					    osb->slot_num);
-	if (!local_alloc_inode) {
-		status = -ENOENT;
-		mlog_errno(status);
-		goto out;
-	}
-
 	osb->local_alloc_state = OCFS2_LA_DISABLED;
 
 	ocfs2_resmap_uninit(&osb->osb_la_resmap);
@@ -441,7 +430,8 @@ void ocfs2_shutdown_local_alloc(struct ocfs2_super *osb)
 	}
 	memcpy(alloc_copy, alloc, bh->b_size);
 
-	status = ocfs2_journal_access_di(handle, INODE_CACHE(local_alloc_inode),
+	status = ocfs2_journal_access_di(handle,
+					 INODE_CACHE(osb->local_alloc_inode),
 					 bh, OCFS2_JOURNAL_ACCESS_WRITE);
 	if (status < 0) {
 		mlog_errno(status);
@@ -473,9 +463,6 @@ out_mutex:
 	iput(main_bm_inode);
 
 out:
-	if (local_alloc_inode)
-		iput(local_alloc_inode);
-
 	if (alloc_copy)
 		kfree(alloc_copy);
 }
@@ -631,22 +618,11 @@ int ocfs2_reserve_local_alloc_bits(struct ocfs2_super *osb,
 {
 	int status;
 	struct ocfs2_dinode *alloc;
-	struct inode *local_alloc_inode;
 	unsigned int free_bits;
 
 	BUG_ON(!ac);
 
-	local_alloc_inode =
-		ocfs2_get_system_file_inode(osb,
-					    LOCAL_ALLOC_SYSTEM_INODE,
-					    osb->slot_num);
-	if (!local_alloc_inode) {
-		status = -ENOENT;
-		mlog_errno(status);
-		goto bail;
-	}
-
-	mutex_lock(&local_alloc_inode->i_mutex);
+	mutex_lock(&osb->local_alloc_inode->i_mutex);
 
 	/*
 	 * We must double check state and allocator bits because
@@ -680,8 +656,7 @@ int ocfs2_reserve_local_alloc_bits(struct ocfs2_super *osb,
 		le32_to_cpu(alloc->id1.bitmap1.i_used);
 	if (bits_wanted > free_bits) {
 		/* uhoh, window change time. */
-		status =
-			ocfs2_local_alloc_slide_window(osb, local_alloc_inode);
+		status = ocfs2_local_alloc_slide_window(osb);
 		if (status < 0) {
 			if (status != -ENOSPC)
 				mlog_errno(status);
@@ -704,7 +679,8 @@ int ocfs2_reserve_local_alloc_bits(struct ocfs2_super *osb,
 			goto bail;
 	}
 
-	ac->ac_inode = local_alloc_inode;
+	ac->ac_inode = osb->local_alloc_inode;
+	igrab(ac->ac_inode);
 	/* We should never use localalloc from another slot */
 	ac->ac_alloc_slot = osb->slot_num;
 	ac->ac_which = OCFS2_AC_USE_LOCAL;
@@ -712,10 +688,8 @@ int ocfs2_reserve_local_alloc_bits(struct ocfs2_super *osb,
 	ac->ac_bh = osb->local_alloc_bh;
 	status = 0;
 bail:
-	if (status < 0 && local_alloc_inode) {
-		mutex_unlock(&local_alloc_inode->i_mutex);
-		iput(local_alloc_inode);
-	}
+	if (status < 0)
+		mutex_unlock(&osb->local_alloc_inode->i_mutex);
 
 	trace_ocfs2_reserve_local_alloc_bits(
 		(unsigned long long)ac->ac_max_block,
@@ -1208,8 +1182,7 @@ bail:
 
 /* Note that we do *NOT* lock the local alloc inode here as
  * it's been locked already for us. */
-static int ocfs2_local_alloc_slide_window(struct ocfs2_super *osb,
-					  struct inode *local_alloc_inode)
+static int ocfs2_local_alloc_slide_window(struct ocfs2_super *osb)
 {
 	int status = 0;
 	struct buffer_head *main_bm_bh = NULL;
@@ -1256,7 +1229,7 @@ static int ocfs2_local_alloc_slide_window(struct ocfs2_super *osb,
 	memcpy(alloc_copy, alloc, osb->local_alloc_bh->b_size);
 
 	status = ocfs2_journal_access_di(handle,
-					 INODE_CACHE(local_alloc_inode),
+					 INODE_CACHE(osb->local_alloc_inode),
 					 osb->local_alloc_bh,
 					 OCFS2_JOURNAL_ACCESS_WRITE);
 	if (status < 0) {
diff --git a/fs/ocfs2/ocfs2.h b/fs/ocfs2/ocfs2.h
index d355e6e..836a647 100644
--- a/fs/ocfs2/ocfs2.h
+++ b/fs/ocfs2/ocfs2.h
@@ -367,6 +367,7 @@ struct ocfs2_super
 							 * by osb_lock */
 
 	struct buffer_head *local_alloc_bh;
+	struct inode       *local_alloc_inode;
 
 	u64 la_last_gd;
 
-- 
1.5.4.3
