From: Jan Kara <jack@suse.cz>
Date: Thu, 13 May 2010 21:57:58 +0200
Subject: [Ocfs2-devel] [PATCH 2/7] ocfs2: Do not map blocks from local quota
	file on each write
In-Reply-To: <1273780683-3638-1-git-send-email-jack@suse.cz>
References: <1273780683-3638-1-git-send-email-jack@suse.cz>
Message-ID: <1273780683-3638-3-git-send-email-jack@suse.cz>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

There is no need to map offset of local dquot structure to on disk block
in each quota write. It is enough to map it just once and store the physical
block number in quota structure in memory. Moreover this simplifies locking
as we do not have to take ip_alloc_sem from quota write path.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/ocfs2/quota.h        |    3 +++
 fs/ocfs2/quota_global.c |   14 ++++++++++++++
 fs/ocfs2/quota_local.c  |   28 +++++++++++++++++++---------
 3 files changed, 36 insertions(+), 9 deletions(-)

diff --git a/fs/ocfs2/quota.h b/fs/ocfs2/quota.h
index 123bc52..e22d293 100644
--- a/fs/ocfs2/quota.h
+++ b/fs/ocfs2/quota.h
@@ -23,6 +23,7 @@
 struct ocfs2_dquot {
 	struct dquot dq_dquot;	/* Generic VFS dquot */
 	loff_t dq_local_off;	/* Offset in the local quota file */
+	u64 dq_local_phys_blk;	/* Physical block carrying quota structure */
 	struct ocfs2_quota_chunk *dq_chunk;	/* Chunk dquot is in */
 	unsigned int dq_use_count;	/* Number of nodes having reference to this entry in global quota file */
 	s64 dq_origspace;	/* Last globally synced space usage */
@@ -104,6 +105,8 @@ int ocfs2_lock_global_qf(struct ocfs2_mem_dqinfo *oinfo, int ex);
 void ocfs2_unlock_global_qf(struct ocfs2_mem_dqinfo *oinfo, int ex);
 int ocfs2_read_quota_block(struct inode *inode, u64 v_block,
 			   struct buffer_head **bh);
+int ocfs2_read_quota_phys_block(struct inode *inode, u64 p_block,
+				struct buffer_head **bh);
 
 extern const struct dquot_operations ocfs2_quota_operations;
 extern struct quota_format_type ocfs2_quota_format;
diff --git a/fs/ocfs2/quota_global.c b/fs/ocfs2/quota_global.c
index ab42a74..e37833b 100644
--- a/fs/ocfs2/quota_global.c
+++ b/fs/ocfs2/quota_global.c
@@ -25,6 +25,7 @@
 #include "dlmglue.h"
 #include "uptodate.h"
 #include "super.h"
+#include "buffer_head_io.h"
 #include "quota.h"
 
 static struct workqueue_struct *ocfs2_quota_wq = NULL;
@@ -137,6 +138,19 @@ int ocfs2_read_quota_block(struct inode *inode, u64 v_block,
 	return rc;
 }
 
+int ocfs2_read_quota_phys_block(struct inode *inode, u64 p_block,
+				struct buffer_head **bhp)
+{
+	int rc;
+
+	*bhp = NULL;
+	rc = ocfs2_read_blocks(INODE_CACHE(inode), p_block, 1, bhp, 0,
+			       ocfs2_validate_quota_block);
+	if (rc)
+		mlog_errno(rc);
+	return rc;
+}
+
 static int ocfs2_get_quota_block(struct inode *inode, int block,
 				 struct buffer_head **bh)
 {
diff --git a/fs/ocfs2/quota_local.c b/fs/ocfs2/quota_local.c
index 9ad4930..dbfc8e3 100644
--- a/fs/ocfs2/quota_local.c
+++ b/fs/ocfs2/quota_local.c
@@ -870,18 +870,17 @@ static int ocfs2_local_write_dquot(struct dquot *dquot)
 {
 	struct super_block *sb = dquot->dq_sb;
 	struct ocfs2_dquot *od = OCFS2_DQUOT(dquot);
-	struct buffer_head *bh = NULL;
+	struct buffer_head *bh;
+	struct inode *lqinode = sb_dqopt(sb)->files[dquot->dq_type];
 	int status;
 
-	status = ocfs2_read_quota_block(sb_dqopt(sb)->files[dquot->dq_type],
-				    ol_dqblk_file_block(sb, od->dq_local_off),
-				    &bh);
+	status = ocfs2_read_quota_phys_block(lqinode, od->dq_local_phys_blk,
+					     &bh);
 	if (status) {
 		mlog_errno(status);
 		goto out;
 	}
-	status = ocfs2_modify_bh(sb_dqopt(sb)->files[dquot->dq_type], bh,
-				 olq_set_dquot, od);
+	status = ocfs2_modify_bh(lqinode, bh, olq_set_dquot, od);
 	if (status < 0) {
 		mlog_errno(status);
 		goto out;
@@ -1219,17 +1218,27 @@ static int ocfs2_create_local_dquot(struct dquot *dquot)
 	struct ocfs2_dquot *od = OCFS2_DQUOT(dquot);
 	int offset;
 	int status;
+	u64 pcount;
 
+	down_write(&OCFS2_I(lqinode)->ip_alloc_sem);
 	chunk = ocfs2_find_free_entry(sb, type, &offset);
 	if (!chunk) {
 		chunk = ocfs2_extend_local_quota_file(sb, type, &offset);
-		if (IS_ERR(chunk))
-			return PTR_ERR(chunk);
+		if (IS_ERR(chunk)) {
+			status = PTR_ERR(chunk);
+			goto out;
+		}
 	} else if (IS_ERR(chunk)) {
-		return PTR_ERR(chunk);
+		status = PTR_ERR(chunk);
+		goto out;
 	}
 	od->dq_local_off = ol_dqblk_off(sb, chunk->qc_num, offset);
 	od->dq_chunk = chunk;
+	status = ocfs2_extent_map_get_blocks(lqinode,
+				     ol_dqblk_block(sb, chunk->qc_num, offset),
+				     &od->dq_local_phys_blk,
+				     &pcount,
+				     NULL);
 
 	/* Initialize dquot structure on disk */
 	status = ocfs2_local_write_dquot(dquot);
@@ -1246,6 +1255,7 @@ static int ocfs2_create_local_dquot(struct dquot *dquot)
 		goto out;
 	}
 out:
+	up_write(&OCFS2_I(lqinode)->ip_alloc_sem);
 	return status;
 }
 
-- 
1.6.4.2
