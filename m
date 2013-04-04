From: Dan Carpenter <dan.carpenter@oracle.com>
Date: Thu, 04 Apr 2013 06:41:34 -0000
Subject: [Ocfs2-devel] [patch 2/2] Ocfs2/move_extents: NULL dereference
	moving extents
Message-ID: <20130404063940.GF6494@longonot.mountain>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

We can't dereference "bg" before it has been assigned.

GCC should have warned about this but "bg" was initialized to NULL.
I've fixed that as well.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
Static analysis stuff.  Compile tested only.

diff --git a/fs/ocfs2/move_extents.c b/fs/ocfs2/move_extents.c
index 995d1b4..f81d23c 100644
--- a/fs/ocfs2/move_extents.c
+++ b/fs/ocfs2/move_extents.c
@@ -471,7 +471,7 @@ static int ocfs2_validate_and_adjust_move_goal(struct inode *inode,
 	int ret, goal_bit = 0;
 
 	struct buffer_head *gd_bh = NULL;
-	struct ocfs2_group_desc *bg = NULL;
+	struct ocfs2_group_desc *bg;
 	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
 	int c_to_b = 1 << (osb->s_clustersize_bits -
 					inode->i_sb->s_blocksize_bits);
@@ -482,13 +482,6 @@ static int ocfs2_validate_and_adjust_move_goal(struct inode *inode,
 	range->me_goal = ocfs2_block_to_cluster_start(inode->i_sb,
 						      range->me_goal);
 	/*
-	 * moving goal is not allowd to start with a group desc blok(#0 blk)
-	 * let's compromise to the latter cluster.
-	 */
-	if (range->me_goal == le64_to_cpu(bg->bg_blkno))
-		range->me_goal += c_to_b;
-
-	/*
 	 * validate goal sits within global_bitmap, and return the victim
 	 * group desc
 	 */
@@ -502,6 +495,13 @@ static int ocfs2_validate_and_adjust_move_goal(struct inode *inode,
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
