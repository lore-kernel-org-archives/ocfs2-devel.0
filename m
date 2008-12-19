From: Mark Fasheh <mfasheh@suse.com>
Date: Fri, 19 Dec 2008 13:53:27 -0800
Subject: [Ocfs2-devel] [PATCH 08/45] ocfs2: Copy xattr buckets with a
	dedicated function.
In-Reply-To: <1229723644-13630-1-git-send-email-mfasheh@suse.com>
References: <1229723644-13630-1-git-send-email-mfasheh@suse.com>
Message-ID: <1229723644-13630-9-git-send-email-mfasheh@suse.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-kernel@vger.kernel.org
Cc: ocfs2-devel@oss.oracle.com, Joel Becker <joel.becker@oracle.com>, Mark Fasheh <mfasheh@suse.com>

From: Joel Becker <joel.becker@oracle.com>

Now that the places that copy whole buckets are using struct
ocfs2_xattr_bucket, we can do the copy in a dedicated function.

Signed-off-by: Joel Becker <joel.becker@oracle.com>
Signed-off-by: Mark Fasheh <mfasheh@suse.com>
---
 fs/ocfs2/xattr.c |   26 ++++++++++++++++----------
 1 files changed, 16 insertions(+), 10 deletions(-)

diff --git a/fs/ocfs2/xattr.c b/fs/ocfs2/xattr.c
index 99aefe4..71d9e7b 100644
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
@@ -3299,9 +3312,7 @@ static int ocfs2_divide_xattr_bucket(struct inode *inode,
 	}
 
 	/* copy the whole bucket to the new first. */
-	for (i = 0; i < blk_per_bucket; i++)
-		memcpy(bucket_block(&t_bucket, i), bucket_block(&s_bucket, i),
-		       blocksize);
+	ocfs2_xattr_bucket_copy_data(inode, &t_bucket, &s_bucket);
 
 	/* update the new bucket. */
 	xh = bucket_xh(&t_bucket);
@@ -3410,9 +3421,7 @@ static int ocfs2_cp_xattr_bucket(struct inode *inode,
 				 u64 t_blkno,
 				 int t_is_new)
 {
-	int ret, i;
-	int blk_per_bucket = ocfs2_blocks_per_xattr_bucket(inode->i_sb);
-	int blocksize = inode->i_sb->s_blocksize;
+	int ret;
 	struct ocfs2_xattr_bucket s_bucket, t_bucket;
 
 	BUG_ON(s_blkno == t_blkno);
@@ -3443,10 +3452,7 @@ static int ocfs2_cp_xattr_bucket(struct inode *inode,
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
1.5.6
