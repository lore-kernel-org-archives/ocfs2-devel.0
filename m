From: Tristan Ye <tristan.ye@oracle.com>
Date: Fri, 27 May 2011 14:32:27 +0800
Subject: [Ocfs2-devel] [PATCH 2/2] Ocfs2/move_extents: Validate moving goal
	after the adjustment.
In-Reply-To: <1306477947-21609-1-git-send-email-tristan.ye@oracle.com>
References: <1306477947-21609-1-git-send-email-tristan.ye@oracle.com>
Message-ID: <1306477947-21609-2-git-send-email-tristan.ye@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

though the goal_to_be_moved will be validated again in following moving, it's
still a good idea to validate it after adjustment at the very beginning, instead
of validating it before adjustment.

Signed-off-by: Tristan Ye <tristan.ye@oracle.com>
---
 fs/ocfs2/move_extents.c |   26 +++++++++++++-------------
 1 files changed, 13 insertions(+), 13 deletions(-)

diff --git a/fs/ocfs2/move_extents.c b/fs/ocfs2/move_extents.c
index d184e0b..cd94270 100644
--- a/fs/ocfs2/move_extents.c
+++ b/fs/ocfs2/move_extents.c
@@ -472,12 +472,24 @@ static int ocfs2_validate_and_adjust_move_goal(struct inode *inode,
 	int ret, goal_bit = 0;
 
 	struct buffer_head *gd_bh = NULL;
-	struct ocfs2_group_desc *bg;
+	struct ocfs2_group_desc *bg = NULL;
 	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
 	int c_to_b = 1 << (osb->s_clustersize_bits -
 					inode->i_sb->s_blocksize_bits);
 
 	/*
+	 * make goal become cluster aligned.
+	 */
+	range->me_goal = ocfs2_block_to_cluster_start(inode->i_sb,
+						      range->me_goal);
+	/*
+	 * moving goal is not allowd to start with a group desc blok(#0 blk)
+	 * let's compromise to the latter cluster.
+	 */
+	if (range->me_goal == le64_to_cpu(bg->bg_blkno))
+		range->me_goal += c_to_b;
+
+	/*
 	 * validate goal sits within global_bitmap, and return the victim
 	 * group desc
 	 */
@@ -491,18 +503,6 @@ static int ocfs2_validate_and_adjust_move_goal(struct inode *inode,
 	bg = (struct ocfs2_group_desc *)gd_bh->b_data;
 
 	/*
-	 * make goal become cluster aligned.
-	 */
-	range->me_goal = ocfs2_block_to_cluster_start(inode->i_sb,
-						      range->me_goal);
-	/*
-	 * moving goal is not allowd to start with a group desc blok(#0 blk)
-	 * let's compromise to the latter cluster.
-	 */
-	if (range->me_goal == le64_to_cpu(bg->bg_blkno))
-		range->me_goal += c_to_b;
-
-	/*
 	 * movement is not gonna cross two groups.
 	 */
 	if ((le16_to_cpu(bg->bg_bits) - goal_bit) * osb->s_clustersize <
-- 
1.5.5
