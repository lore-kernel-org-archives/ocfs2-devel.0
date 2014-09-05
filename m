From: Joseph Qi <joseph.qi@huawei.com>
Date: Fri, 5 Sep 2014 16:47:30 +0800
Subject: [Ocfs2-devel] [PATCH] ocfs2: fix shift left operations overflow
Message-ID: <540978A2.5010706@huawei.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

ocfs2_inode_info->ip_clusters and ocfs2_dinode->id1.bitmap1.i_total are
defined as type u32, so the shift left operations may overflow if
volume size is large, for example, 2TB and cluster size is 1MB.

Signed-off-by: Joseph Qi <joseph.qi@huawei.com>
Reviewed-by: Alex Chen <alex.chen@huawei.com>
---
 fs/ocfs2/inode.h        | 2 +-
 fs/ocfs2/move_extents.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/ocfs2/inode.h b/fs/ocfs2/inode.h
index a6c991c..a9b76de 100644
--- a/fs/ocfs2/inode.h
+++ b/fs/ocfs2/inode.h
@@ -162,7 +162,7 @@ static inline blkcnt_t ocfs2_inode_sector_count(struct inode *inode)
 {
 	int c_to_s_bits = OCFS2_SB(inode->i_sb)->s_clustersize_bits - 9;

-	return (blkcnt_t)(OCFS2_I(inode)->ip_clusters << c_to_s_bits);
+	return (blkcnt_t)OCFS2_I(inode)->ip_clusters << c_to_s_bits;
 }

 /* Validate that a bh contains a valid inode */
diff --git a/fs/ocfs2/move_extents.c b/fs/ocfs2/move_extents.c
index 599eb4c..bb9cc7e 100644
--- a/fs/ocfs2/move_extents.c
+++ b/fs/ocfs2/move_extents.c
@@ -404,7 +404,7 @@ static int ocfs2_find_victim_alloc_group(struct inode *inode,
 	 * 'vict_blkno' was out of the valid range.
 	 */
 	if ((vict_blkno < le64_to_cpu(rec->c_blkno)) ||
-	    (vict_blkno >= (le32_to_cpu(ac_dinode->id1.bitmap1.i_total) <<
+	    (vict_blkno >= ((u64)le32_to_cpu(ac_dinode->id1.bitmap1.i_total) <<
 				bits_per_unit))) {
 		ret = -EINVAL;
 		goto out;
-- 
1.8.4.3
