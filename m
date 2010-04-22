From: Tao Ma <tao.ma@oracle.com>
Date: Thu, 22 Apr 2010 14:40:30 +0800
Subject: [Ocfs2-devel] [PATCH 16/17] ocfs2: Set ac_last_group properly with
	discontig group.
In-Reply-To: <4BCFEF22.7080607@oracle.com>
References: <4BCFEF22.7080607@oracle.com>
Message-ID: <1271918431-8135-16-git-send-email-tao.ma@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

ac_last_group is used to record the last block group we
used during allocation. But the initialization process
only calls ocfs2_which_suballoc_group and fails to
use suballoc_loc properly. So let us do it.
Another function ocfs2_test_suballoc_bit also needs fix.

I have searched all the callers of ocfs2_which_suballoc_group,
and all the callers notices suballoc_loc now.

Signed-off-by: Tao Ma <tao.ma@oracle.com>
---
 fs/ocfs2/suballoc.c |   31 +++++++++++++++++++------------
 1 files changed, 19 insertions(+), 12 deletions(-)

diff --git a/fs/ocfs2/suballoc.c b/fs/ocfs2/suballoc.c
index a971ec6..693656d 100644
--- a/fs/ocfs2/suballoc.c
+++ b/fs/ocfs2/suballoc.c
@@ -1986,10 +1986,10 @@ bail:
 }
 
 static void ocfs2_init_inode_ac_group(struct inode *dir,
-				      struct buffer_head *parent_fe_bh,
+				      struct buffer_head *parent_di_bh,
 				      struct ocfs2_alloc_context *ac)
 {
-	struct ocfs2_dinode *fe = (struct ocfs2_dinode *)parent_fe_bh->b_data;
+	struct ocfs2_dinode *di = (struct ocfs2_dinode *)parent_di_bh->b_data;
 	/*
 	 * Try to allocate inodes from some specific group.
 	 *
@@ -2003,10 +2003,14 @@ static void ocfs2_init_inode_ac_group(struct inode *dir,
 	if (OCFS2_I(dir)->ip_last_used_group &&
 	    OCFS2_I(dir)->ip_last_used_slot == ac->ac_alloc_slot)
 		ac->ac_last_group = OCFS2_I(dir)->ip_last_used_group;
-	else if (le16_to_cpu(fe->i_suballoc_slot) == ac->ac_alloc_slot)
-		ac->ac_last_group = ocfs2_which_suballoc_group(
-					le64_to_cpu(fe->i_blkno),
-					le16_to_cpu(fe->i_suballoc_bit));
+	else if (le16_to_cpu(di->i_suballoc_slot) == ac->ac_alloc_slot) {
+		if (di->i_suballoc_loc)
+			ac->ac_last_group = le64_to_cpu(di->i_suballoc_loc);
+		else
+			ac->ac_last_group = ocfs2_which_suballoc_group(
+					le64_to_cpu(di->i_blkno),
+					le16_to_cpu(di->i_suballoc_bit));
+	}
 }
 
 static inline void ocfs2_save_inode_ac_group(struct inode *dir,
@@ -2585,7 +2589,7 @@ static int ocfs2_test_suballoc_bit(struct ocfs2_super *osb,
 				   struct buffer_head *alloc_bh, u64 blkno,
 				   u16 bit, int *res)
 {
-	struct ocfs2_dinode *alloc_fe;
+	struct ocfs2_dinode *alloc_di;
 	struct ocfs2_group_desc *group;
 	struct buffer_head *group_bh = NULL;
 	u64 bg_blkno;
@@ -2594,17 +2598,20 @@ static int ocfs2_test_suballoc_bit(struct ocfs2_super *osb,
 	mlog_entry("blkno: %llu bit: %u\n", (unsigned long long)blkno,
 		   (unsigned int)bit);
 
-	alloc_fe = (struct ocfs2_dinode *)alloc_bh->b_data;
-	if ((bit + 1) > ocfs2_bits_per_group(&alloc_fe->id2.i_chain)) {
+	alloc_di = (struct ocfs2_dinode *)alloc_bh->b_data;
+	if ((bit + 1) > ocfs2_bits_per_group(&alloc_di->id2.i_chain)) {
 		mlog(ML_ERROR, "suballoc bit %u out of range of %u\n",
 		     (unsigned int)bit,
-		     ocfs2_bits_per_group(&alloc_fe->id2.i_chain));
+		     ocfs2_bits_per_group(&alloc_di->id2.i_chain));
 		status = -EINVAL;
 		goto bail;
 	}
 
-	bg_blkno = ocfs2_which_suballoc_group(blkno, bit);
-	status = ocfs2_read_group_descriptor(suballoc, alloc_fe, bg_blkno,
+	if (alloc_di->i_suballoc_loc)
+		bg_blkno = le64_to_cpu(alloc_di->i_suballoc_loc);
+	else
+		bg_blkno = ocfs2_which_suballoc_group(blkno, bit);
+	status = ocfs2_read_group_descriptor(suballoc, alloc_di, bg_blkno,
 					     &group_bh);
 	if (status < 0) {
 		mlog(ML_ERROR, "read group %llu failed %d\n",
-- 
1.5.5
