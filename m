From: Wengang Wang <wen.gang.wang@oracle.com>
Date: Fri, 29 Jul 2011 18:06:06 +0800
Subject: [Ocfs2-devel] [PATCH 2/4] ocfs2: ocfs2_dir_foreach returns the
 error turned by filldir
Message-ID: <201107291006.p6TA6J1Z010639@acsmt358.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

try to return the error turned by filldir in ocfs2_dir_foreach.

Signed-off-by: Wengang Wang <wen.gang.wang@oracle.com>
---
 fs/ocfs2/dir.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/fs/ocfs2/dir.c b/fs/ocfs2/dir.c
index 3302088..4b365a1 100644
--- a/fs/ocfs2/dir.c
+++ b/fs/ocfs2/dir.c
@@ -2004,8 +2004,10 @@ int ocfs2_dir_foreach(struct inode *inode, loff_t *f_pos, void *priv,
 
 	if (ret > 0)
 		ret = -EIO;
+	if (!ret)
+		ret = filldir_err;
 
-	return 0;
+	return ret;
 }
 
 /*
-- 
1.7.5.2
