From: Joel Becker <joel.becker@oracle.com>
Date: Thu, 13 Nov 2008 14:49:21 -0800
Subject: [Ocfs2-devel] [PATCH 11/11] ocfs2: Convert ocfs2_read_dir_block()
	to ocfs2_read_virt_blocks()
In-Reply-To: <1226616561-29942-1-git-send-email-joel.becker@oracle.com>
References: <1226616561-29942-1-git-send-email-joel.becker@oracle.com>
Message-ID: <1226616561-29942-12-git-send-email-joel.becker@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Now that we've centralized the ocfs2_read_virt_blocks() code, let's use
it in ocfs2_read_dir_block().

Signed-off-by: Joel Becker <joel.becker@oracle.com>
---
 fs/ocfs2/dir.c |   38 +++++---------------------------------
 1 files changed, 5 insertions(+), 33 deletions(-)

diff --git a/fs/ocfs2/dir.c b/fs/ocfs2/dir.c
index 7e863d4..d83cff9 100644
--- a/fs/ocfs2/dir.c
+++ b/fs/ocfs2/dir.c
@@ -231,44 +231,16 @@ static int ocfs2_read_dir_block(struct inode *inode, u64 v_block,
 {
 	int rc = 0;
 	struct buffer_head *tmp = *bh;
-	u64 p_blkno;
 
-	if (((u64)v_block << inode->i_sb->s_blocksize_bits) >=
-	    i_size_read(inode)) {
-		BUG_ON(!(flags & OCFS2_BH_READAHEAD));
-		goto out;
-	}
-
-	down_read(&OCFS2_I(inode)->ip_alloc_sem);
-	rc = ocfs2_extent_map_get_blocks(inode, v_block, &p_blkno, NULL,
-					 NULL);
-	up_read(&OCFS2_I(inode)->ip_alloc_sem);
-	if (rc) {
+	rc = ocfs2_read_virt_blocks(inode, v_block, 1, &tmp, flags,
+				    ocfs2_validate_dir_block);
+	if (rc)
 		mlog_errno(rc);
-		goto out;
-	}
 
-	if (!p_blkno) {
-		rc = -EIO;
-		mlog(ML_ERROR,
-		     "Directory #%llu contains a hole at offset %llu\n",
-		     (unsigned long long)OCFS2_I(inode)->ip_blkno,
-		     (unsigned long long)v_block << inode->i_sb->s_blocksize_bits);
-		goto out;
-	}
-
-	rc = ocfs2_read_blocks(inode, p_blkno, 1, &tmp, flags,
-			       ocfs2_validate_dir_block);
-	if (rc) {
-		mlog_errno(rc);
-		goto out;
-	}
-
-	/* If ocfs2_read_blocks() got us a new bh, pass it up.  */
-	if (!*bh)
+	/* If ocfs2_read_virt_blocks() got us a new bh, pass it up. */
+	if (!rc && !*bh)
 		*bh = tmp;
 
-out:
 	return rc ? -EIO : 0;
 }
 
-- 
1.5.6.5
