From: Tao Ma <tm@tao.ma>
Date: Thu, 23 Dec 2010 15:30:51 +0800
Subject: [Ocfs2-devel] [PATCH 08/34] ocfs2: Remove mlog(0) from
	fs/ocfs2/suballoc.c
In-Reply-To: <4D12F7E7.1090204@tao.ma>
References: <4D12F7E7.1090204@tao.ma>
Message-ID: <1293089477-5019-8-git-send-email-tm@tao.ma>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

From: Tao Ma <tao.ma@oracle.com>

This is the 4th step to remove the debug info of DISK_ALLOC.

Signed-off-by: Tao Ma <tao.ma@oracle.com>
---
 fs/ocfs2/ocfs2_trace.h |   25 +++++++++++++++++++++++++
 fs/ocfs2/resize.c      |   12 +++++++-----
 2 files changed, 32 insertions(+), 5 deletions(-)

diff --git a/fs/ocfs2/ocfs2_trace.h b/fs/ocfs2/ocfs2_trace.h
index 196a995..1d518d5 100644
--- a/fs/ocfs2/ocfs2_trace.h
+++ b/fs/ocfs2/ocfs2_trace.h
@@ -784,6 +784,31 @@ DEFINE_EVENT(ocfs2__ull_uint, ocfs2_local_alloc_new_window_result,
 );
 /* End of trace events for fs/ocfs2/localalloc.c. */
 
+/* Trace events for fs/ocfs2/resize.c. */
+DEFINE_EVENT(ocfs2__uint_uint, ocfs2_update_last_group_and_inode,
+
+	TP_PROTO(unsigned int new_clusters, unsigned int first_new_cluster),
+
+	TP_ARGS(new_clusters, first_new_cluster)
+);
+
+DEFINE_EVENT(ocfs2__ull_uint, ocfs2_group_extend,
+
+	TP_PROTO(unsigned long long bg_blkno, unsigned int new_clusters),
+
+	TP_ARGS(bg_blkno, new_clusters)
+);
+
+DEFINE_EVENT(ocfs2__ull_uint_uint_uint, ocfs2_group_add,
+
+	TP_PROTO(unsigned long long bg_blkno, unsigned int chain,
+		 unsigned int clusters, unsigned int frees),
+
+	TP_ARGS(bg_blkno, chain, clusters, frees)
+);
+
+/* End of trace events for fs/ocfs2/resize.c. */
+
 /* Trace events for fs/ocfs2/suballoc.c. */
 DEFINE_EVENT(ocfs2__ull, ocfs2_validate_group_descriptor,
 
diff --git a/fs/ocfs2/resize.c b/fs/ocfs2/resize.c
index 76b3790..761d20d 100644
--- a/fs/ocfs2/resize.c
+++ b/fs/ocfs2/resize.c
@@ -39,6 +39,7 @@
 #include "super.h"
 #include "sysfile.h"
 #include "uptodate.h"
+#include "ocfs2_trace.h"
 
 #include "buffer_head_io.h"
 #include "suballoc.h"
@@ -102,8 +103,8 @@ static int ocfs2_update_last_group_and_inode(handle_t *handle,
 	u16 cl_bpc = le16_to_cpu(cl->cl_bpc);
 	u16 cl_cpg = le16_to_cpu(cl->cl_cpg);
 
-	mlog(0, "(new_clusters=%d, first_new_cluster = %u)\n",
-	     new_clusters, first_new_cluster);
+	trace_ocfs2_update_last_group_and_inode(new_clusters,
+						first_new_cluster);
 
 	ret = ocfs2_journal_access_gd(handle, INODE_CACHE(bm_inode),
 				      group_bh, OCFS2_JOURNAL_ACCESS_WRITE);
@@ -340,7 +341,8 @@ int ocfs2_group_extend(struct inode * inode, int new_clusters)
 		goto out_unlock;
 	}
 
-	mlog(0, "extend the last group at %llu, new clusters = %d\n",
+
+	trace_ocfs2_group_extend(
 	     (unsigned long long)le64_to_cpu(group->bg_blkno), new_clusters);
 
 	handle = ocfs2_start_trans(osb, OCFS2_GROUP_EXTEND_CREDITS);
@@ -515,8 +517,8 @@ int ocfs2_group_add(struct inode *inode, struct ocfs2_new_group_input *input)
 		goto out_unlock;
 	}
 
-	mlog(0, "Add a new group  %llu in chain = %u, length = %u\n",
-	     (unsigned long long)input->group, input->chain, input->clusters);
+	trace_ocfs2_group_add((unsigned long long)input->group,
+			       input->chain, input->clusters, input->frees);
 
 	handle = ocfs2_start_trans(osb, OCFS2_GROUP_ADD_CREDITS);
 	if (IS_ERR(handle)) {
-- 
1.7.0.4
