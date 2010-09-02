From: Tao Ma <tao.ma@oracle.com>
Date: Thu,  2 Sep 2010 14:03:54 +0800
Subject: [Ocfs2-devel] [PATCH] ocfs2: Use the right group in nfs sync check.
Message-ID: <1283407434-6031-1-git-send-email-tao.ma@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

We have added discontig block group now, and now an inode
can be allocated in an discontig block group. So get
it in ocfs2_get_suballoc_slot_bit.

The old ocfs2_test_suballoc_bit gets group block no
from the allocation inode which is wrong. Fix it by
passing the right group.

Signed-off-by: Tao Ma <tao.ma@oracle.com>
---
 fs/ocfs2/suballoc.c |   19 +++++++++++--------
 1 files changed, 11 insertions(+), 8 deletions(-)

diff --git a/fs/ocfs2/suballoc.c b/fs/ocfs2/suballoc.c
index c567b9c..8ec56d3 100644
--- a/fs/ocfs2/suballoc.c
+++ b/fs/ocfs2/suballoc.c
@@ -2581,7 +2581,8 @@ out:
  * suballoc_bit.
  */
 static int ocfs2_get_suballoc_slot_bit(struct ocfs2_super *osb, u64 blkno,
-				       u16 *suballoc_slot, u16 *suballoc_bit)
+				       u16 *suballoc_slot, u64 *group_blkno,
+				       u16 *suballoc_bit)
 {
 	int status;
 	struct buffer_head *inode_bh = NULL;
@@ -2618,6 +2619,8 @@ static int ocfs2_get_suballoc_slot_bit(struct ocfs2_super *osb, u64 blkno,
 		*suballoc_slot = le16_to_cpu(inode_fe->i_suballoc_slot);
 	if (suballoc_bit)
 		*suballoc_bit = le16_to_cpu(inode_fe->i_suballoc_bit);
+	if (group_blkno)
+		*group_blkno = le64_to_cpu(inode_fe->i_suballoc_loc);
 
 bail:
 	brelse(inode_bh);
@@ -2635,7 +2638,8 @@ bail:
  */
 static int ocfs2_test_suballoc_bit(struct ocfs2_super *osb,
 				   struct inode *suballoc,
-				   struct buffer_head *alloc_bh, u64 blkno,
+				   struct buffer_head *alloc_bh,
+				   u64 group_blkno, u64 blkno,
 				   u16 bit, int *res)
 {
 	struct ocfs2_dinode *alloc_di;
@@ -2656,10 +2660,8 @@ static int ocfs2_test_suballoc_bit(struct ocfs2_super *osb,
 		goto bail;
 	}
 
-	if (alloc_di->i_suballoc_loc)
-		bg_blkno = le64_to_cpu(alloc_di->i_suballoc_loc);
-	else
-		bg_blkno = ocfs2_which_suballoc_group(blkno, bit);
+	bg_blkno = group_blkno ? group_blkno :
+		   ocfs2_which_suballoc_group(blkno, bit);
 	status = ocfs2_read_group_descriptor(suballoc, alloc_di, bg_blkno,
 					     &group_bh);
 	if (status < 0) {
@@ -2694,6 +2696,7 @@ bail:
 int ocfs2_test_inode_bit(struct ocfs2_super *osb, u64 blkno, int *res)
 {
 	int status;
+	u64 group_blkno = 0;
 	u16 suballoc_bit = 0, suballoc_slot = 0;
 	struct inode *inode_alloc_inode;
 	struct buffer_head *alloc_bh = NULL;
@@ -2701,7 +2704,7 @@ int ocfs2_test_inode_bit(struct ocfs2_super *osb, u64 blkno, int *res)
 	mlog_entry("blkno: %llu", (unsigned long long)blkno);
 
 	status = ocfs2_get_suballoc_slot_bit(osb, blkno, &suballoc_slot,
-					     &suballoc_bit);
+					     &group_blkno, &suballoc_bit);
 	if (status < 0) {
 		mlog(ML_ERROR, "get alloc slot and bit failed %d\n", status);
 		goto bail;
@@ -2729,7 +2732,7 @@ int ocfs2_test_inode_bit(struct ocfs2_super *osb, u64 blkno, int *res)
 	}
 
 	status = ocfs2_test_suballoc_bit(osb, inode_alloc_inode, alloc_bh,
-					 blkno, suballoc_bit, res);
+					 group_blkno, blkno, suballoc_bit, res);
 	if (status < 0)
 		mlog(ML_ERROR, "test suballoc bit failed %d\n", status);
 
-- 
1.7.1.GIT
