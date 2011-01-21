From: Tristan Ye <tristan.ye@oracle.com>
Date: Fri, 21 Jan 2011 18:20:18 +0800
Subject: [Ocfs2-devel] [PATCH 01/14] Ocfs2/refcounttree: Fix a bug for
	refcounttree to writeback clusters in a right number.
In-Reply-To: <1295605231-15991-1-git-send-email-tristan.ye@oracle.com>
References: <1295605231-15991-1-git-send-email-tristan.ye@oracle.com>
Message-ID: <1295605231-15991-2-git-send-email-tristan.ye@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Current refcounttree codes actually didn't writeback the new pages out in
write-back mode, due to a bug of always passing a ZERO number of clusters
to 'ocfs2_cow_sync_writeback', the patch tries to pass a proper one in.

Signed-off-by: Tristan Ye <tristan.ye@oracle.com>
---
 fs/ocfs2/refcounttree.c |    7 +++++--
 1 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/fs/ocfs2/refcounttree.c b/fs/ocfs2/refcounttree.c
index b5f9160..19ebc5a 100644
--- a/fs/ocfs2/refcounttree.c
+++ b/fs/ocfs2/refcounttree.c
@@ -3228,7 +3228,7 @@ static int ocfs2_make_clusters_writable(struct super_block *sb,
 					u32 num_clusters, unsigned int e_flags)
 {
 	int ret, delete, index, credits =  0;
-	u32 new_bit, new_len;
+	u32 new_bit, new_len, orig_num_clusters;
 	unsigned int set_len;
 	struct ocfs2_super *osb = OCFS2_SB(sb);
 	handle_t *handle;
@@ -3261,6 +3261,8 @@ static int ocfs2_make_clusters_writable(struct super_block *sb,
 		goto out;
 	}
 
+	orig_num_clusters = num_clusters;
+
 	while (num_clusters) {
 		ret = ocfs2_get_refcount_rec(ref_ci, context->ref_root_bh,
 					     p_cluster, num_clusters,
@@ -3348,7 +3350,8 @@ static int ocfs2_make_clusters_writable(struct super_block *sb,
 	 * in write-back mode.
 	 */
 	if (context->get_clusters == ocfs2_di_get_clusters) {
-		ret = ocfs2_cow_sync_writeback(sb, context, cpos, num_clusters);
+		ret = ocfs2_cow_sync_writeback(sb, context, cpos,
+					       orig_num_clusters);
 		if (ret)
 			mlog_errno(ret);
 	}
-- 
1.5.5
