From: wengang wang <wen.gang.wang@oracle.com>
Date: Tue,  7 Apr 2009 22:14:33 +0800
Subject: [Ocfs2-devel] [PATCH 1/1] OCFS2: use i_size_read() instead of
	direct accessing inode->i_size
Message-ID: <200904071416.n37EG5tq025916@acsinet13.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

use i_size_read() instead of accessing inode->i_size directly.

Signed-off-by: Wengang Wang <wen.gang.wang@oracle.com>
--
diff --git a/fs/ocfs2/aops.c b/fs/ocfs2/aops.c
index b2c52b3..4491851 100644
--- a/fs/ocfs2/aops.c
+++ b/fs/ocfs2/aops.c
@@ -1920,7 +1920,7 @@ int ocfs2_write_end_nolock(struct address_space *mapping,
 
 out_write_size:
 	pos += copied;
-	if (pos > inode->i_size) {
+	if (pos > i_size_read(inode)) {
 		i_size_write(inode, pos);
 		mark_inode_dirty(inode);
 	}
diff --git a/fs/ocfs2/file.c b/fs/ocfs2/file.c
index a5887df..eabfe65 100644
--- a/fs/ocfs2/file.c
+++ b/fs/ocfs2/file.c
@@ -1854,8 +1854,8 @@ relock:
 			 * blocks outside i_size. Trim these off again.
 			 * Don't need i_size_read because we hold i_mutex.
 			 */
-			if (*ppos + count > inode->i_size)
-				vmtruncate(inode, inode->i_size);
+			if (*ppos + count > i_size_read(inode))
+				vmtruncate(inode, i_size_read(inode));
 			ret = written;
 			goto out_dio;
 		}
diff --git a/fs/ocfs2/journal.c b/fs/ocfs2/journal.c
index a20a0f1..1337ea6 100644
--- a/fs/ocfs2/journal.c
+++ b/fs/ocfs2/journal.c
@@ -805,14 +805,14 @@ int ocfs2_journal_init(struct ocfs2_journal *journal, int *dirty)
 	inode_lock = 1;
 	di = (struct ocfs2_dinode *)bh->b_data;
 
-	if (inode->i_size <  OCFS2_MIN_JOURNAL_SIZE) {
+	if (i_size_read(inode) <  OCFS2_MIN_JOURNAL_SIZE) {
 		mlog(ML_ERROR, "Journal file size (%lld) is too small!\n",
-		     inode->i_size);
+		     i_size_read(inode));
 		status = -EINVAL;
 		goto done;
 	}
 
-	mlog(0, "inode->i_size = %lld\n", inode->i_size);
+	mlog(0, "inode->i_size = %lld\n", i_size_read(inode));
 	mlog(0, "inode->i_blocks = %llu\n",
 			(unsigned long long)inode->i_blocks);
 	mlog(0, "inode->ip_clusters = %u\n", OCFS2_I(inode)->ip_clusters);
@@ -1120,7 +1120,7 @@ static int ocfs2_force_read_journal(struct inode *inode)
 
 	memset(bhs, 0, sizeof(struct buffer_head *) * CONCURRENT_JOURNAL_FILL);
 
-	num_blocks = ocfs2_blocks_for_bytes(inode->i_sb, inode->i_size);
+	num_blocks = ocfs2_blocks_for_bytes(inode->i_sb, i_size_read(inode));
 	v_blkno = 0;
 	while (v_blkno < num_blocks) {
 		status = ocfs2_extent_map_get_blocks(inode, v_blkno,
diff --git a/fs/ocfs2/quota_global.c b/fs/ocfs2/quota_global.c
index 1ed0f7c..df46418 100644
--- a/fs/ocfs2/quota_global.c
+++ b/fs/ocfs2/quota_global.c
@@ -210,7 +210,7 @@ ssize_t ocfs2_quota_write(struct super_block *sb, int type,
 	}
 
 	mutex_lock_nested(&gqinode->i_mutex, I_MUTEX_QUOTA);
-	if (gqinode->i_size < off + len) {
+	if (i_size_read(gqinode) < off + len) {
 		down_write(&OCFS2_I(gqinode)->ip_alloc_sem);
 		err = ocfs2_extend_no_holes(gqinode, off + len, off);
 		up_write(&OCFS2_I(gqinode)->ip_alloc_sem);
diff --git a/fs/ocfs2/quota_local.c b/fs/ocfs2/quota_local.c
index 07deec5..cf9deab 100644
--- a/fs/ocfs2/quota_local.c
+++ b/fs/ocfs2/quota_local.c
@@ -938,14 +938,14 @@ static struct ocfs2_quota_chunk *ocfs2_local_quota_add_chunk(
 
 	/* We are protected by dqio_sem so no locking needed */
 	status = ocfs2_extend_no_holes(lqinode,
-				       lqinode->i_size + 2 * sb->s_blocksize,
-				       lqinode->i_size);
+				       i_size_read(lqinode) + 2 * sb->s_blocksize,
+				       i_size_read(lqinode));
 	if (status < 0) {
 		mlog_errno(status);
 		goto out;
 	}
 	status = ocfs2_simple_size_update(lqinode, oinfo->dqi_lqi_bh,
-					  lqinode->i_size + 2 * sb->s_blocksize);
+					  i_size_read(lqinode) + 2 * sb->s_blocksize);
 	if (status < 0) {
 		mlog_errno(status);
 		goto out;
@@ -1056,14 +1056,14 @@ static struct ocfs2_quota_chunk *ocfs2_extend_local_quota_file(
 
 	/* We are protected by dqio_sem so no locking needed */
 	status = ocfs2_extend_no_holes(lqinode,
-				       lqinode->i_size + sb->s_blocksize,
-				       lqinode->i_size);
+				       i_size_read(lqinode) + sb->s_blocksize,
+				       i_size_read(lqinode));
 	if (status < 0) {
 		mlog_errno(status);
 		goto out;
 	}
 	status = ocfs2_simple_size_update(lqinode, oinfo->dqi_lqi_bh,
-					  lqinode->i_size + sb->s_blocksize);
+					  i_size_read(lqinode) + sb->s_blocksize);
 	if (status < 0) {
 		mlog_errno(status);
 		goto out;
