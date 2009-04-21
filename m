From: Joel Becker <Joel.Becker@oracle.com>
Date: Tue, 21 Apr 2009 16:37:53 -0700
Subject: [Ocfs2-devel] [PATCH] ocfs2: Fix some printk() warnings.
Message-ID: <20090421233753.GF10294@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

The old %llu vs u64 battle.  Cast them correctly.

Signed-off-by: Joel Becker <joel.becker@oracle.com>
---
 fs/ocfs2/export.c   |    9 +++++----
 fs/ocfs2/suballoc.c |   19 ++++++++++++-------
 2 files changed, 17 insertions(+), 11 deletions(-)

diff --git a/fs/ocfs2/export.c b/fs/ocfs2/export.c
index de3da8e..15713cb 100644
--- a/fs/ocfs2/export.c
+++ b/fs/ocfs2/export.c
@@ -100,7 +100,8 @@ static struct dentry *ocfs2_get_dentry(struct super_block *sb,
 
 	/* If the inode allocator bit is clear, this inode must be stale */
 	if (!set) {
-		mlog(0, "inode %llu suballoc bit is clear\n", blkno);
+		mlog(0, "inode %llu suballoc bit is clear\n",
+		     (unsigned long long)blkno);
 		status = -ESTALE;
 		goto unlock_nfs_sync;
 	}
@@ -114,7 +115,7 @@ check_err:
 	if (status < 0) {
 		if (status == -ESTALE) {
 			mlog(0, "stale inode ino: %llu generation: %u\n",
-			     blkno, handle->ih_generation);
+			     (unsigned long long)blkno, handle->ih_generation);
 		}
 		result = ERR_PTR(status);
 		goto bail;
@@ -129,8 +130,8 @@ check_err:
 check_gen:
 	if (handle->ih_generation != inode->i_generation) {
 		iput(inode);
-		mlog(0, "stale inode ino: %llu generation: %u\n", blkno,
-		     handle->ih_generation);
+		mlog(0, "stale inode ino: %llu generation: %u\n",
+		     (unsigned long long)blkno, handle->ih_generation);
 		result = ERR_PTR(-ESTALE);
 		goto bail;
 	}
diff --git a/fs/ocfs2/suballoc.c b/fs/ocfs2/suballoc.c
index eb21dbb..8439f6b 100644
--- a/fs/ocfs2/suballoc.c
+++ b/fs/ocfs2/suballoc.c
@@ -2197,18 +2197,20 @@ static int ocfs2_get_suballoc_slot_bit(struct ocfs2_super *osb, u64 blkno,
 	struct buffer_head *inode_bh = NULL;
 	struct ocfs2_dinode *inode_fe;
 
-	mlog_entry("blkno: %llu\n", blkno);
+	mlog_entry("blkno: %llu\n", (unsigned long long)blkno);
 
 	/* dirty read disk */
 	status = ocfs2_read_blocks_sync(osb, blkno, 1, &inode_bh);
 	if (status < 0) {
-		mlog(ML_ERROR, "read block %llu failed %d\n", blkno, status);
+		mlog(ML_ERROR, "read block %llu failed %d\n",
+		     (unsigned long long)blkno, status);
 		goto bail;
 	}
 
 	inode_fe = (struct ocfs2_dinode *) inode_bh->b_data;
 	if (!OCFS2_IS_VALID_DINODE(inode_fe)) {
-		mlog(ML_ERROR, "invalid inode %llu requested\n", blkno);
+		mlog(ML_ERROR, "invalid inode %llu requested\n",
+		     (unsigned long long)blkno);
 		status = -EINVAL;
 		goto bail;
 	}
@@ -2216,7 +2218,8 @@ static int ocfs2_get_suballoc_slot_bit(struct ocfs2_super *osb, u64 blkno,
 	if (le16_to_cpu(inode_fe->i_suballoc_slot) != (u16)OCFS2_INVALID_SLOT &&
 	    (u32)le16_to_cpu(inode_fe->i_suballoc_slot) > osb->max_slots - 1) {
 		mlog(ML_ERROR, "inode %llu has invalid suballoc slot %u\n",
-		     blkno, (u32)le16_to_cpu(inode_fe->i_suballoc_slot));
+		     (unsigned long long)blkno,
+		     (u32)le16_to_cpu(inode_fe->i_suballoc_slot));
 		status = -EINVAL;
 		goto bail;
 	}
@@ -2251,7 +2254,8 @@ static int ocfs2_test_suballoc_bit(struct ocfs2_super *osb,
 	u64 bg_blkno;
 	int status;
 
-	mlog_entry("blkno: %llu bit: %u\n", blkno, (unsigned int)bit);
+	mlog_entry("blkno: %llu bit: %u\n", (unsigned long long)blkno,
+		   (unsigned int)bit);
 
 	alloc_fe = (struct ocfs2_dinode *)alloc_bh->b_data;
 	if ((bit + 1) > ocfs2_bits_per_group(&alloc_fe->id2.i_chain)) {
@@ -2266,7 +2270,8 @@ static int ocfs2_test_suballoc_bit(struct ocfs2_super *osb,
 	status = ocfs2_read_group_descriptor(suballoc, alloc_fe, bg_blkno,
 					     &group_bh);
 	if (status < 0) {
-		mlog(ML_ERROR, "read group %llu failed %d\n", bg_blkno, status);
+		mlog(ML_ERROR, "read group %llu failed %d\n",
+		     (unsigned long long)bg_blkno, status);
 		goto bail;
 	}
 
@@ -2300,7 +2305,7 @@ int ocfs2_test_inode_bit(struct ocfs2_super *osb, u64 blkno, int *res)
 	struct inode *inode_alloc_inode;
 	struct buffer_head *alloc_bh = NULL;
 
-	mlog_entry("blkno: %llu", blkno);
+	mlog_entry("blkno: %llu", (unsigned long long)blkno);
 
 	status = ocfs2_get_suballoc_slot_bit(osb, blkno, &suballoc_slot,
 					     &suballoc_bit);
-- 
1.6.1.3


-- 

You can use a screwdriver to screw in screws or to clean your ears,
however, the latter needs real skill, determination and a lack of fear
of injuring yourself.  It is much the same with JavaScript.
	- Chris Heilmann

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker@oracle.com
Phone: (650) 506-8127
