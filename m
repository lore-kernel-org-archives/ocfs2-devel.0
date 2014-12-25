From: Junxiao Bi <junxiao.bi@oracle.com>
Date: Thu, 25 Dec 2014 13:52:16 +0800
Subject: [Ocfs2-devel] [PATCH 1/2] ocfs2: fix uninitialized variable access
Message-ID: <1419486737-16102-1-git-send-email-junxiao.bi@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Variable "why" is not yet initialized at line 615, fix it.

Signed-off-by: Junxiao Bi <junxiao.bi@oracle.com>
---
 fs/ocfs2/file.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ocfs2/file.c b/fs/ocfs2/file.c
index 3950693..245db4f 100644
--- a/fs/ocfs2/file.c
+++ b/fs/ocfs2/file.c
@@ -569,7 +569,7 @@ static int __ocfs2_extend_allocation(struct inode *inode, u32 logical_start,
 	handle_t *handle = NULL;
 	struct ocfs2_alloc_context *data_ac = NULL;
 	struct ocfs2_alloc_context *meta_ac = NULL;
-	enum ocfs2_alloc_restarted why;
+	enum ocfs2_alloc_restarted why = RESTART_NONE;
 	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
 	struct ocfs2_extent_tree et;
 	int did_quota = 0;
-- 
1.7.9.5
