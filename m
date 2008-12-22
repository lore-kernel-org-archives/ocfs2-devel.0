From: Mark Fasheh <mfasheh@suse.com>
Date: Mon, 22 Dec 2008 13:48:14 -0800
Subject: [Ocfs2-devel] [PATCH 33/56] ocfs2: Make ocfs2_get_quota_block()
	consistent with ocfs2_read_quota_block()
In-Reply-To: <1229982517-3455-1-git-send-email-mfasheh@suse.com>
References: <1229982517-3455-1-git-send-email-mfasheh@suse.com>
Message-ID: <1229982517-3455-34-git-send-email-mfasheh@suse.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-kernel@vger.kernel.org
Cc: ocfs2-devel@oss.oracle.com, Joel Becker <joel.becker@oracle.com>, Jan Kara <jack@suse.cz>, Mark Fasheh <mfasheh@suse.com>

From: Jan Kara <jack@suse.cz>

Make function return error status and not buffer pointer so that it's
consistent with ocfs2_read_quota_block().

Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Mark Fasheh <mfasheh@suse.com>
---
 fs/ocfs2/quota_global.c |   27 +++++++++++++--------------
 1 files changed, 13 insertions(+), 14 deletions(-)

diff --git a/fs/ocfs2/quota_global.c b/fs/ocfs2/quota_global.c
index 339c98a..27a8123 100644
--- a/fs/ocfs2/quota_global.c
+++ b/fs/ocfs2/quota_global.c
@@ -102,26 +102,25 @@ int ocfs2_read_quota_block(struct inode *inode, u64 v_block,
 	return rc;
 }
 
-static struct buffer_head *ocfs2_get_quota_block(struct inode *inode,
-						 int block, int *err)
+static int ocfs2_get_quota_block(struct inode *inode, int block,
+				 struct buffer_head **bh)
 {
 	u64 pblock, pcount;
-	struct buffer_head *bh;
+	int err;
 
 	down_read(&OCFS2_I(inode)->ip_alloc_sem);
-	*err = ocfs2_extent_map_get_blocks(inode, block, &pblock, &pcount,
-					   NULL);
+	err = ocfs2_extent_map_get_blocks(inode, block, &pblock, &pcount, NULL);
 	up_read(&OCFS2_I(inode)->ip_alloc_sem);
-	if (*err) {
-		mlog_errno(*err);
-		return NULL;
+	if (err) {
+		mlog_errno(err);
+		return err;
 	}
-	bh = sb_getblk(inode->i_sb, pblock);
-	if (!bh) {
-		*err = -EIO;
-		mlog_errno(*err);
+	*bh = sb_getblk(inode->i_sb, pblock);
+	if (!*bh) {
+		err = -EIO;
+		mlog_errno(err);
 	}
-	return bh;
+	return err;;
 }
 
 /* Read data from global quotafile - avoid pagecache and such because we cannot
@@ -207,7 +206,7 @@ ssize_t ocfs2_quota_write(struct super_block *sb, int type,
 		err = ocfs2_read_quota_block(gqinode, blk, &bh);
 		ja_type = OCFS2_JOURNAL_ACCESS_WRITE;
 	} else {
-		bh = ocfs2_get_quota_block(gqinode, blk, &err);
+		err = ocfs2_get_quota_block(gqinode, blk, &bh);
 		ja_type = OCFS2_JOURNAL_ACCESS_CREATE;
 	}
 	if (err) {
-- 
1.5.6
