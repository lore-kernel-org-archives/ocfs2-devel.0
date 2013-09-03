From: Junxiao Bi <junxiao.bi@oracle.com>
Date: Tue,  3 Sep 2013 09:48:57 +0800
Subject: [Ocfs2-devel] [PATCH] ocfs2: fix wrong comment
Message-ID: <1378172937-25767-1-git-send-email-junxiao.bi@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Unwritten extent only exists for file systems which
support holes. But the comment said was opposite
meaning and also the comment is not very clear,
so rephase it.

Signed-off-by: Junxiao Bi <junxiao.bi@oracle.com>
---
 fs/ocfs2/file.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ocfs2/file.c b/fs/ocfs2/file.c
index 3261d71..91876ad 100644
--- a/fs/ocfs2/file.c
+++ b/fs/ocfs2/file.c
@@ -580,7 +580,7 @@ static int __ocfs2_extend_allocation(struct inode *inode, u32 logical_start,
 	int did_quota = 0;
 
 	/*
-	 * This function only exists for file systems which don't
+	 * Unwritten extent only exists for file systems which
 	 * support holes.
 	 */
 	BUG_ON(mark_unwritten && !ocfs2_sparse_alloc(osb));
-- 
1.7.9.5
