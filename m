From: Tao Ma <tm@tao.ma>
Date: Fri,  6 May 2011 17:27:38 +0800
Subject: [Ocfs2-devel] [PATCH 3/3] ocfs2: Add trace event for trim.
In-Reply-To: <4DC3BDFD.6090004@tao.ma>
References: <4DC3BDFD.6090004@tao.ma>
Message-ID: <1304674058-18350-3-git-send-email-tm@tao.ma>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

From: Tao Ma <boyu.mt@taobao.com>

Add the corresponding trace event for trim.

Signed-off-by: Tao Ma <boyu.mt@taobao.com>
---
 fs/ocfs2/alloc.c       |    7 +++++++
 fs/ocfs2/ocfs2_trace.h |   25 +++++++++++++++++++++++++
 2 files changed, 32 insertions(+), 0 deletions(-)

diff --git a/fs/ocfs2/alloc.c b/fs/ocfs2/alloc.c
index 93a3f92..12f1c33 100644
--- a/fs/ocfs2/alloc.c
+++ b/fs/ocfs2/alloc.c
@@ -7196,6 +7196,8 @@ static int ocfs2_trim_extent(struct super_block *sb,
 	discard = le64_to_cpu(gd->bg_blkno) +
 			ocfs2_clusters_to_blocks(sb, start);
 
+	trace_ocfs2_trim_extent(sb, (unsigned long long)discard, count);
+
 	return sb_issue_discard(sb, discard, count, GFP_NOFS, 0);
 }
 
@@ -7206,6 +7208,9 @@ static int ocfs2_trim_group(struct super_block *sb,
 	int ret = 0, count = 0, next;
 	void *bitmap = gd->bg_bitmap;
 
+	trace_ocfs2_trim_group((unsigned long long)le64_to_cpu(gd->bg_blkno),
+			       start, max, minbits);
+
 	while (start < max) {
 		start = ocfs2_find_next_zero_bit(bitmap, max, start);
 		if (start >= max)
@@ -7289,6 +7294,8 @@ int ocfs2_trim_fs(struct super_block *sb, struct fstrim_range *range)
 	if (start + len > le32_to_cpu(main_bm->i_clusters))
 		len = le32_to_cpu(main_bm->i_clusters) - start;
 
+	trace_ocfs2_trim_fs(start, len, minlen);
+
 	/* Determine first and last group to examine based on start and len */
 	first_group = ocfs2_which_cluster_group(main_bm_inode, start);
 	if (first_group == osb->first_cluster_group_blkno)
diff --git a/fs/ocfs2/ocfs2_trace.h b/fs/ocfs2/ocfs2_trace.h
index a1dae5b..9ab22a1 100644
--- a/fs/ocfs2/ocfs2_trace.h
+++ b/fs/ocfs2/ocfs2_trace.h
@@ -688,6 +688,31 @@ TRACE_EVENT(ocfs2_cache_block_dealloc,
 		  __entry->blkno, __entry->bit)
 );
 
+TRACE_EVENT(ocfs2_trim_extent,
+	TP_PROTO(struct super_block *sb, unsigned long long blk,
+		 unsigned long long count),
+	TP_ARGS(sb, blk, count),
+	TP_STRUCT__entry(
+		__field(int, dev_major)
+		__field(int, dev_minor)
+		__field(unsigned long long, blk)
+		__field(__u64,	count)
+	),
+	TP_fast_assign(
+		__entry->dev_major = MAJOR(sb->s_dev);
+		__entry->dev_minor = MINOR(sb->s_dev);
+		__entry->blk = blk;
+		__entry->count = count;
+	),
+	TP_printk("%d %d %llu %llu",
+		  __entry->dev_major, __entry->dev_minor,
+		  __entry->blk, __entry->count)
+);
+
+DEFINE_OCFS2_ULL_INT_INT_INT_EVENT(ocfs2_trim_group);
+
+DEFINE_OCFS2_ULL_ULL_ULL_EVENT(ocfs2_trim_fs);
+
 /* End of trace events for fs/ocfs2/alloc.c. */
 
 /* Trace events for fs/ocfs2/localalloc.c. */
-- 
1.6.3.GIT
