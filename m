From: Tristan Ye <tristan.ye@oracle.com>
Date: Fri, 27 May 2011 14:32:26 +0800
Subject: [Ocfs2-devel] [PATCH 1/2] Ocfs2/move_extents: Avoid doing division
	in extent moving.
Message-ID: <1306477947-21609-1-git-send-email-tristan.ye@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

It's not wise enough to do a 64bits division anywhere in kernside, replace it
with a decent helper or proper shifts.

Signed-off-by: Tristan Ye <tristan.ye@oracle.com>
---
 fs/ocfs2/move_extents.c |   19 +++++++++----------
 1 files changed, 9 insertions(+), 10 deletions(-)

diff --git a/fs/ocfs2/move_extents.c b/fs/ocfs2/move_extents.c
index 4c54884..d184e0b 100644
--- a/fs/ocfs2/move_extents.c
+++ b/fs/ocfs2/move_extents.c
@@ -368,7 +368,7 @@ static int ocfs2_find_victim_alloc_group(struct inode *inode,
 					 int *vict_bit,
 					 struct buffer_head **ret_bh)
 {
-	int ret, i, blocks_per_unit = 1;
+	int ret, i, bits_per_unit = 0;
 	u64 blkno;
 	char namebuf[40];
 
@@ -398,14 +398,14 @@ static int ocfs2_find_victim_alloc_group(struct inode *inode,
 	rec = &(cl->cl_recs[0]);
 
 	if (type == GLOBAL_BITMAP_SYSTEM_INODE)
-		blocks_per_unit <<= (osb->s_clustersize_bits -
-						inode->i_sb->s_blocksize_bits);
+		bits_per_unit = osb->s_clustersize_bits -
+					inode->i_sb->s_blocksize_bits;
 	/*
 	 * 'vict_blkno' was out of the valid range.
 	 */
 	if ((vict_blkno < le64_to_cpu(rec->c_blkno)) ||
-	    (vict_blkno >= (le32_to_cpu(ac_dinode->id1.bitmap1.i_total) *
-				blocks_per_unit))) {
+	    (vict_blkno >= (le32_to_cpu(ac_dinode->id1.bitmap1.i_total) <<
+				bits_per_unit))) {
 		ret = -EINVAL;
 		goto out;
 	}
@@ -441,8 +441,8 @@ static int ocfs2_find_victim_alloc_group(struct inode *inode,
 						le16_to_cpu(bg->bg_bits))) {
 
 				*ret_bh = gd_bh;
-				*vict_bit = (vict_blkno - blkno) /
-							blocks_per_unit;
+				*vict_bit = (vict_blkno - blkno) >>
+							bits_per_unit;
 				mlog(0, "find the victim group: #%llu, "
 				     "total_bits: %u, vict_bit: %u\n",
 				     blkno, le16_to_cpu(bg->bg_bits),
@@ -493,9 +493,8 @@ static int ocfs2_validate_and_adjust_move_goal(struct inode *inode,
 	/*
 	 * make goal become cluster aligned.
 	 */
-	if (range->me_goal % c_to_b)
-		range->me_goal = range->me_goal / c_to_b * c_to_b;
-
+	range->me_goal = ocfs2_block_to_cluster_start(inode->i_sb,
+						      range->me_goal);
 	/*
 	 * moving goal is not allowd to start with a group desc blok(#0 blk)
 	 * let's compromise to the latter cluster.
-- 
1.5.5
