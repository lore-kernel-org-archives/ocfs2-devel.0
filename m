From: Srinivas Eeda <srinivas.eeda@oracle.com>
Date: Tue, 18 Sep 2012 17:11:03 -0700
Subject: [Ocfs2-devel] [PATCH 5/5] ocfs2 set min default contig localalloc
	size
In-Reply-To: <1348013463-23980-1-git-send-email-srinivas.eeda@oracle.com>
References: <1348013463-23980-1-git-send-email-srinivas.eeda@oracle.com>
Message-ID: <1348013463-23980-6-git-send-email-srinivas.eeda@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

When discontiguous localalloc is enabled, localalloc should just try for a
minimum smaller contiguous chunk. This will improve performance when the
file system is fragmented. This setting doesn't stop localalloc from getting
bigger chunk.

The default chunk size is set to fill 128Kb. localalloc will try to look for
atleast that big of chunk. If it's not available then it reduces the size by
half and retries.

#define OCFS2_DEFAULT_LOCALALLOC_CHUNK_SIZE (128*1024) /* 128kb */

Signed-off-by: Srinivas Eeda <srinivas.eeda@oracle.com>
---
 fs/ocfs2/localalloc.c |   28 +++++++++++++++++++++-------
 1 files changed, 21 insertions(+), 7 deletions(-)

diff --git a/fs/ocfs2/localalloc.c b/fs/ocfs2/localalloc.c
index 82653f2..569e131 100644
--- a/fs/ocfs2/localalloc.c
+++ b/fs/ocfs2/localalloc.c
@@ -271,6 +271,19 @@ ocfs2_local_alloc_adjust_bits_wanted(struct ocfs2_dinode *alloc,
 	return wanted;
 }
 
+#define OCFS2_DEFAULT_LOCALALLOC_CHUNK_SIZE (128*1024) /* 128kb */
+
+void ocfs2_set_default_min_alloc_size(struct ocfs2_super *osb)
+{
+	if (ocfs2_supports_discontig_la(osb)) {
+		osb->local_alloc_bits = OCFS2_DEFAULT_LOCALALLOC_CHUNK_SIZE /
+			osb->s_clustersize;
+		if (!osb->local_alloc_bits)
+			osb->local_alloc_bits = 1;
+	} else
+		osb->local_alloc_bits = osb->local_alloc_default_bits;
+}
+
 void ocfs2_la_set_sizes(struct ocfs2_super *osb, int requested_mb)
 {
 	struct super_block *sb = osb->sb;
@@ -294,8 +307,7 @@ void ocfs2_la_set_sizes(struct ocfs2_super *osb, int requested_mb)
 		osb->local_alloc_default_bits =
 			ocfs2_megabytes_to_clusters(sb, requested_mb);
 	}
-
-	osb->local_alloc_bits = osb->local_alloc_default_bits;
+	ocfs2_set_default_min_alloc_size(osb);
 }
 
 static inline int ocfs2_la_state_enabled(struct ocfs2_super *osb)
@@ -1219,7 +1231,7 @@ static int ocfs2_recalc_la_window(struct ocfs2_super *osb,
 	 * low space.
 	 */
 	if (osb->local_alloc_state != OCFS2_LA_THROTTLED)
-		osb->local_alloc_bits = osb->local_alloc_default_bits;
+		ocfs2_set_default_min_alloc_size(osb);
 
 out_unlock:
 	state = osb->local_alloc_state;
@@ -1369,10 +1381,12 @@ static int ocfs2_local_alloc_new_window(struct ocfs2_super *osb,
 	if (!alloc->id1.bitmap1.i_total)
 		goto bail;
 
-	spin_lock(&osb->osb_lock);
-	if (cluster_count > osb->local_alloc_bits)
-		osb->local_alloc_bits = cluster_count;
-	spin_unlock(&osb->osb_lock);
+	if (!ocfs2_supports_discontig_la(osb)) {
+		spin_lock(&osb->osb_lock);
+		if (cluster_count > osb->local_alloc_bits)
+			osb->local_alloc_bits = cluster_count;
+		spin_unlock(&osb->osb_lock);
+	}
 	osb->la_last_gd = ac->ac_last_group;
 
 	bitmap = ocfs2_local_alloc_bitmap(osb, la);
-- 
1.5.4.3
