From: Joel Becker <joel.becker@oracle.com>
Date: Tue,  9 Dec 2008 17:09:41 -0800
Subject: [Ocfs2-devel] [PATCH 04/18] ocfs2: Add a validation hook for quota
	block reads.
In-Reply-To: <1228871395-10273-1-git-send-email-joel.becker@oracle.com>
References: <1228871395-10273-1-git-send-email-joel.becker@oracle.com>
Message-ID: <1228871395-10273-5-git-send-email-joel.becker@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Add a currently-returns-success hook for quota block reads.  We'll be
adding checks to this.

Signed-off-by: Joel Becker <joel.becker@oracle.com>
---
 fs/ocfs2/quota_global.c |   14 +++++++++++++-
 1 files changed, 13 insertions(+), 1 deletions(-)

diff --git a/fs/ocfs2/quota_global.c b/fs/ocfs2/quota_global.c
index 4b38a2e..5b05f94 100644
--- a/fs/ocfs2/quota_global.c
+++ b/fs/ocfs2/quota_global.c
@@ -85,13 +85,25 @@ struct qtree_fmt_operations ocfs2_global_ops = {
 	.is_id = ocfs2_global_is_id,
 };
 
+static int ocfs2_validate_quota_block(struct super_block *sb,
+				      struct buffer_head *bh)
+{
+	struct ocfs2_disk_dqtrailer *dqt = ocfs2_dq_trailer(sb, bh->b_data);
+
+	mlog(0, "Validating quota block %llu\n",
+	     (unsigned long long)bh->b_blocknr);
+
+	return 0;
+}
+
 int ocfs2_read_quota_block(struct inode *inode, u64 v_block,
 			   struct buffer_head **bh)
 {
 	int rc = 0;
 	struct buffer_head *tmp = *bh;
 
-	rc = ocfs2_read_virt_blocks(inode, v_block, 1, &tmp, 0, NULL);
+	rc = ocfs2_read_virt_blocks(inode, v_block, 1, &tmp, 0,
+				    ocfs2_validate_quota_block);
 	if (rc)
 		mlog_errno(rc);
 
-- 
1.5.6.5
