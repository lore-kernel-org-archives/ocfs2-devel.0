From: Wengang Wang <wen.gang.wang@oracle.com>
Date: Fri, 10 Jul 2009 13:26:04 +0800
Subject: [Ocfs2-devel] [PATCH 1/1] a fix of logging return value.
Message-ID: <200907100528.n6A5Sv4J030693@acsinet15.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

	in ocfs2_file_aio_write(), log_exit() could don't log the value
which is really returned. this patch fixes it.

Signed-off-by: Wengang Wang <wen.gang.wang@oracle.com>
---
 fs/ocfs2/file.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/fs/ocfs2/file.c b/fs/ocfs2/file.c
index 62442e4..a49fa44 100644
--- a/fs/ocfs2/file.c
+++ b/fs/ocfs2/file.c
@@ -1918,8 +1918,10 @@ out_sems:
 
 	mutex_unlock(&inode->i_mutex);
 
+	if (written)
+		ret = written;
 	mlog_exit(ret);
-	return written ? written : ret;
+	return ret;
 }
 
 static int ocfs2_splice_to_file(struct pipe_inode_info *pipe,
-- 
1.6.2.5
