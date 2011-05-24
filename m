From: Tristan Ye <tristan.ye@oracle.com>
Date: Tue, 24 May 2011 18:53:49 +0800
Subject: [Ocfs2-devel] [PATCH 15/15] Ocfs2/move_extents: Set several trivial
	constraints for threshold.
In-Reply-To: <1306234429-28078-1-git-send-email-tristan.ye@oracle.com>
References: <1306234429-28078-1-git-send-email-tristan.ye@oracle.com>
Message-ID: <1306234429-28078-16-git-send-email-tristan.ye@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Signed-off-by: Tristan Ye <tristan.ye@oracle.com>
---
 fs/ocfs2/move_extents.c |   24 +++++++++++++++++-------
 1 files changed, 17 insertions(+), 7 deletions(-)

diff --git a/fs/ocfs2/move_extents.c b/fs/ocfs2/move_extents.c
index 53fba28..64446c7 100644
--- a/fs/ocfs2/move_extents.c
+++ b/fs/ocfs2/move_extents.c
@@ -219,6 +219,9 @@ out:
 /*
  * Using one journal handle to guarantee the data consistency in case
  * crash happens anywhere.
+ *
+ * XXX: defrag can end up with finishing partial extent as requested,
+ * 	due to not enough contiguous clusters can be found in allocator.
  */
 static int ocfs2_defrag_extent(struct ocfs2_move_extents_context *context,
 			       u32 cpos, u32 phys_cpos, u32 *len, int ext_flags)
@@ -862,9 +865,11 @@ static int __ocfs2_move_extents_range(struct buffer_head *di_bh,
 	else
 		len_to_move = 0;
 
-	if (do_defrag)
+	if (do_defrag) {
 		defrag_thresh = range->me_thresh >> osb->s_clustersize_bits;
-	else
+		if (defrag_thresh <= 1)
+			goto done;
+	} else
 		new_phys_cpos = ocfs2_blocks_to_clusters(inode->i_sb,
 							 range->me_goal);
 
@@ -936,6 +941,7 @@ next:
 		len_to_move -= alloc_size;
 	}
 
+done:
 	range->me_flags |= OCFS2_MOVE_EXT_FL_COMPLETE;
 
 out:
@@ -1088,13 +1094,17 @@ int ocfs2_ioctl_move_extents(struct file *filp, void __user *argp)
 
 	if (range.me_flags & OCFS2_MOVE_EXT_FL_AUTO_DEFRAG) {
 		context->auto_defrag = 1;
+		/*
+		 * ok, the default theshold for the defragmentation
+		 * is 1M, since our maximum clustersize was 1M also.
+		 * any thought?
+		 */
 		if (!range.me_thresh)
-			/*
-			 * ok, the default theshold for the defragmentation
-			 * is 1M, since our maximum clustersize was 1M also.
-			 * any thought?
-			 */
 			range.me_thresh = 1024 * 1024;
+
+		if (range.me_thresh > i_size_read(inode))
+			range.me_thresh = i_size_read(inode);
+
 	} else {
 		/*
 		 * first best-effort attempt to validate and adjust the goal
-- 
1.5.5
