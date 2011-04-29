From: Tristan Ye <tristan.ye@oracle.com>
Date: Fri, 29 Apr 2011 01:51:06 -0000
Subject: [Ocfs2-devel] [PATCH 1/1] Ocfs2: Fix a NULL pointer reference
	somewhere in move_extents.c
Message-ID: <1307947558-23552-1-git-send-email-tristan.ye@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

That's really bad to deference the pointer 'bg' before it gets initialized.

Signed-off-by: Tristan Ye <tristan.ye@oracle.com>
---
 fs/ocfs2/move_extents.c |   13 +++++++------
 1 files changed, 7 insertions(+), 6 deletions(-)

diff --git a/fs/ocfs2/move_extents.c b/fs/ocfs2/move_extents.c
index cd94270..3f9797f 100644
--- a/fs/ocfs2/move_extents.c
+++ b/fs/ocfs2/move_extents.c
@@ -482,12 +482,6 @@ static int ocfs2_validate_and_adjust_move_goal(struct inode *inode,
 	 */
 	range->me_goal = ocfs2_block_to_cluster_start(inode->i_sb,
 						      range->me_goal);
-	/*
-	 * moving goal is not allowd to start with a group desc blok(#0 blk)
-	 * let's compromise to the latter cluster.
-	 */
-	if (range->me_goal == le64_to_cpu(bg->bg_blkno))
-		range->me_goal += c_to_b;
 
 	/*
 	 * validate goal sits within global_bitmap, and return the victim
@@ -503,6 +497,13 @@ static int ocfs2_validate_and_adjust_move_goal(struct inode *inode,
 	bg = (struct ocfs2_group_desc *)gd_bh->b_data;
 
 	/*
+	 * moving goal is not allowd to start with a group desc blok(#0 blk)
+	 * let's compromise to the latter cluster.
+	 */
+	if (range->me_goal == le64_to_cpu(bg->bg_blkno))
+		range->me_goal += c_to_b;
+
+	/*
 	 * movement is not gonna cross two groups.
 	 */
 	if ((le16_to_cpu(bg->bg_bits) - goal_bit) * osb->s_clustersize <
-- 
1.5.5
