From: Tao Ma <tao.ma@oracle.com>
Date: Sun, 19 Sep 2010 15:20:28 +0800
Subject: [Ocfs2-devel] [PATCH 1/2] ocfs2: flush truncate log in case it
	contains too many clusters.
In-Reply-To: <4C95B999.1080307@oracle.com>
References: <4C95B999.1080307@oracle.com>
Message-ID: <1284880829-3795-1-git-send-email-tao.ma@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

When we test whether we need to flush truncate log in
ocfs2_truncate_log_needs_flush, we only take care of
whether the truncate log is full. But if the volume is
small and  we have large block size(in this case truncate
log can store too many records), we may be too late
for flushing if the user create/write/delete files quickly.

So I add a new FLUSH_TRUNCATE_LOG_RATIO so that we will also
check whether the number of truncated clusters has reached
a watermark, if yes, flush the truncate log.
It resolves the ossbug #1288 somehow.

Signed-off-by: Tao Ma <tao.ma@oracle.com>
---
 fs/ocfs2/alloc.c |   25 ++++++++++++++++++++++++-
 fs/ocfs2/ocfs2.h |    2 ++
 2 files changed, 26 insertions(+), 1 deletions(-)

diff --git a/fs/ocfs2/alloc.c b/fs/ocfs2/alloc.c
index 592fae5..c765447 100644
--- a/fs/ocfs2/alloc.c
+++ b/fs/ocfs2/alloc.c
@@ -5751,11 +5751,13 @@ out:
 	return ret;
 }
 
+#define FLUSH_TRUNCATE_LOG_RATIO	10
 int ocfs2_truncate_log_needs_flush(struct ocfs2_super *osb)
 {
 	struct buffer_head *tl_bh = osb->osb_tl_bh;
 	struct ocfs2_dinode *di;
 	struct ocfs2_truncate_log *tl;
+	int flush = 0;
 
 	di = (struct ocfs2_dinode *) tl_bh->b_data;
 	tl = &di->id2.i_dealloc;
@@ -5764,7 +5766,25 @@ int ocfs2_truncate_log_needs_flush(struct ocfs2_super *osb)
 			"slot %d, invalid truncate log parameters: used = "
 			"%u, count = %u\n", osb->slot_num,
 			le16_to_cpu(tl->tl_used), le16_to_cpu(tl->tl_count));
-	return le16_to_cpu(tl->tl_used) == le16_to_cpu(tl->tl_count);
+	if (le16_to_cpu(tl->tl_used) == le16_to_cpu(tl->tl_count))
+		flush = 1;
+	else {
+		/*
+		 * Check whether we have reserved enough clusters
+		 * to flush.
+		 */
+		u32 watermark = osb->osb_clusters_at_boot / 100 *
+				FLUSH_TRUNCATE_LOG_RATIO;
+
+		if (watermark < osb->truncated_clusters) {
+			mlog(0, "flush truncate log: watermark %u,"
+			     " we have %u clusters truncated\n",
+			     watermark, osb->truncated_clusters);
+			flush = 1;
+		}
+	}
+
+	return flush;
 }
 
 static int ocfs2_truncate_log_can_coalesce(struct ocfs2_truncate_log *tl,
@@ -5858,6 +5878,7 @@ int ocfs2_truncate_log_append(struct ocfs2_super *osb,
 
 	ocfs2_journal_dirty(handle, tl_bh);
 
+	osb->truncated_clusters += num_clusters;
 bail:
 	mlog_exit(status);
 	return status;
@@ -5929,6 +5950,8 @@ static int ocfs2_replay_truncate_records(struct ocfs2_super *osb,
 		i--;
 	}
 
+	osb->truncated_clusters = 0;
+
 bail:
 	mlog_exit(status);
 	return status;
diff --git a/fs/ocfs2/ocfs2.h b/fs/ocfs2/ocfs2.h
index c67003b..5f47883 100644
--- a/fs/ocfs2/ocfs2.h
+++ b/fs/ocfs2/ocfs2.h
@@ -425,6 +425,8 @@ struct ocfs2_super
 	/* rb tree root for refcount lock. */
 	struct rb_root	osb_rf_lock_tree;
 	struct ocfs2_refcount_tree *osb_ref_tree_lru;
+
+	unsigned int truncated_clusters;
 };
 
 #define OCFS2_SB(sb)	    ((struct ocfs2_super *)(sb)->s_fs_info)
-- 
1.7.1.571.gba4d01
