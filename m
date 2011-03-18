From: Tristan Ye <tristan.ye@oracle.com>
Date: Fri, 18 Mar 2011 14:35:36 +0800
Subject: [Ocfs2-devel] [PATCH 09/16] Ocfs2/move_extents: helper to validate
	and adjust moving goal.
In-Reply-To: <1300430143-23909-1-git-send-email-tristan.ye@oracle.com>
References: <1300430143-23909-1-git-send-email-tristan.ye@oracle.com>
Message-ID: <1300430143-23909-10-git-send-email-tristan.ye@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

First best-effort attempt to validate and adjust the goal (physical address in
block), while it can't guarantee later operation can succeed all the time since
global_bitmap may change a bit over time.

Signed-off-by: Tristan Ye <tristan.ye@oracle.com>
---
 fs/ocfs2/move_extents.c |   61 +++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 61 insertions(+), 0 deletions(-)

diff --git a/fs/ocfs2/move_extents.c b/fs/ocfs2/move_extents.c
index f40eb9f..06f587b 100644
--- a/fs/ocfs2/move_extents.c
+++ b/fs/ocfs2/move_extents.c
@@ -456,3 +456,64 @@ out:
 	 */
 	return ret;
 }
+
+/*
+ * XXX: helper to validate and adjust moving goal.
+ */
+static int ocfs2_validate_and_adjust_move_goal(struct inode *inode,
+					       struct ocfs2_move_extents *range)
+{
+	int ret, goal_bit = 0;
+
+	struct buffer_head *gd_bh = NULL;
+	struct ocfs2_group_desc *bg;
+	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
+	int c_to_b = 1 << (osb->s_clustersize_bits -
+					inode->i_sb->s_blocksize_bits);
+
+	/*
+	 * validate goal sits within global_bitmap, and return the victim
+	 * group desc
+	 */
+	ret = ocfs2_find_victim_alloc_group(inode, range->me_goal,
+					    GLOBAL_BITMAP_SYSTEM_INODE,
+					    OCFS2_INVALID_SLOT,
+					    &goal_bit, &gd_bh);
+	if (ret)
+		goto out;
+
+	bg = (struct ocfs2_group_desc *)gd_bh->b_data;
+
+	/*
+	 * make goal become cluster aligned.
+	 */
+	if (range->me_goal % c_to_b)
+		range->me_goal = range->me_goal / c_to_b * c_to_b;
+
+	/*
+	 * moving goal is not allowd to start with a group desc blok(#0 blk)
+	 * let's compromise to the latter cluster.
+	 */
+	if (range->me_goal == le64_to_cpu(bg->bg_blkno))
+		range->me_goal += c_to_b;
+
+	/*
+	 * movement is not gonna cross two groups.
+	 */
+	if ((le16_to_cpu(bg->bg_bits) - goal_bit) * osb->s_clustersize <
+								range->me_len) {
+		ret = -EINVAL;
+		goto out;
+	}
+	/*
+	 * more exact validations/adjustments will be performed later during
+	 * moving operation for each extent range.
+	 */
+	mlog(0, "extents get ready to be moved to #%llu block\n",
+	     range->me_goal);
+
+out:
+	brelse(gd_bh);
+
+	return ret;
+}
-- 
1.5.5
