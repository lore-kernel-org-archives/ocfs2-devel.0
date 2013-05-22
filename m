From: xiaowei.hu at oracle.com <xiaowei.hu@oracle.com>
Date: Wed, 22 May 2013 09:43:16 +0800
Subject: [Ocfs2-devel] [PATCH] ocfs2_prep_new_orphaned_file should return ret
Message-ID: <1369186996-7127-1-git-send-email-xiaowei.hu@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

From: "Xiaowei.Hu" <xiaowei.hu@oracle.com>

---
 fs/ocfs2/namei.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ocfs2/namei.c b/fs/ocfs2/namei.c
index 50c93a8..422cbe0 100644
--- a/fs/ocfs2/namei.c
+++ b/fs/ocfs2/namei.c
@@ -2216,7 +2216,7 @@ out:
 
 	brelse(orphan_dir_bh);
 
-	return 0;
+	return ret;
 }
 
 int ocfs2_create_inode_in_orphan(struct inode *dir,
-- 
1.7.11.7
