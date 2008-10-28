From: Joel Becker <joel.becker@oracle.com>
Date: Mon, 27 Oct 2008 18:20:23 -0700
Subject: [Ocfs2-devel] [PATCH 08/13] ocfs2: Copy xattr buckets with a
	dedicated function.
In-Reply-To: <1225156828-32189-1-git-send-email-joel.becker@oracle.com>
References: <1225156828-32189-1-git-send-email-joel.becker@oracle.com>
Message-ID: <1225156828-32189-9-git-send-email-joel.becker@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Now that the places that copy whole buckets are using struct
ocfs2_xattr_bucket, we can do the copy in a dedicated function.

Signed-off-by: Joel Becker <joel.becker@oracle.com>
---
 fs/ocfs2/xattr.c |   28 ++++++++++++++++------------
 1 files changed, 16 insertions(+), 12 deletions(-)

diff --git a/fs/ocfs2/xattr.c b/fs/ocfs2/xattr.c
index 55e2c1a..cf84a67 100644
--- a/fs/ocfs2/xattr.c
+++ b/fs/ocfs2/xattr.c
@@ -240,6 +240,19 @@ static void ocfs2_xattr_bucket_journal_dirty(handle_t *handle,
 		ocfs2_journal_dirty(handle, bucket->bu_bhs[i]);
 }
 
+static void ocfs2_xattr_bucket_copy_data(struct inode *inode,
+					 struct ocfs2_xattr_bucket *dest,
+					 struct ocfs2_xattr_bucket *src)
+{
+	int i;
+	int blocksize = inode->i_sb->s_blocksize;
+	int blks = ocfs2_blocks_per_xattr_bucket(inode->i_sb);
+
+	for (i = 0; i < blks; i++) {
+		memcpy(bucket_block(dest, i), bucket_block(src, i),
+		       blocksize);
+	}
+}
 
 static inline const char *ocfs2_xattr_prefix(int name_index)
 {
@@ -3175,11 +3188,9 @@ static int ocfs2_half_xattr_bucket(struct inode *inode,
 {
 	int ret, i;
 	u16 count, start, len, name_value_len, xe_len, name_offset;
-	u16 blk_per_bucket = ocfs2_blocks_per_xattr_bucket(inode->i_sb);
 	struct ocfs2_xattr_bucket s_bucket, t_bucket;
 	struct ocfs2_xattr_header *xh;
 	struct ocfs2_xattr_entry *xe;
-	int blocksize = inode->i_sb->s_blocksize;
 
 	mlog(0, "move half of xattrs from bucket %llu to %llu\n",
 	     blk, new_blk);
@@ -3220,9 +3231,7 @@ static int ocfs2_half_xattr_bucket(struct inode *inode,
 	}
 
 	/* copy the whole bucket to the new first. */
-	for (i = 0; i < blk_per_bucket; i++)
-		memcpy(bucket_block(&t_bucket, i), bucket_block(&s_bucket, i),
-		       blocksize);
+	ocfs2_xattr_bucket_copy_data(inode, &t_bucket, &s_bucket);
 
 	/* update the new bucket. */
 	xh = bucket_xh(&t_bucket);
@@ -3328,9 +3337,7 @@ static int ocfs2_cp_xattr_bucket(struct inode *inode,
 				 u64 t_blkno,
 				 int t_is_new)
 {
-	int ret, i;
-	int blk_per_bucket = ocfs2_blocks_per_xattr_bucket(inode->i_sb);
-	int blocksize = inode->i_sb->s_blocksize;
+	int ret;
 	struct ocfs2_xattr_bucket s_bucket, t_bucket;
 
 	BUG_ON(s_blkno == t_blkno);
@@ -3360,10 +3367,7 @@ static int ocfs2_cp_xattr_bucket(struct inode *inode,
 	if (ret)
 		goto out;
 
-	for (i = 0; i < blk_per_bucket; i++) {
-		memcpy(bucket_block(&t_bucket, i), bucket_block(&s_bucket, i),
-		       blocksize);
-	}
+	ocfs2_xattr_bucket_copy_data(inode, &t_bucket, &s_bucket);
 	ocfs2_xattr_bucket_journal_dirty(handle, inode, &t_bucket);
 
 out:
-- 
1.5.6.5
