From: Joseph Qi <joseph.qi@huawei.com>
Date: Thu, 16 Jun 2016 10:49:55 +0800
Subject: [Ocfs2-devel] [PATCH] ocfs2: cleanup unneeded goto in
	ocfs2_create_new_inode_locks
Message-ID: <576213D3.6080002@huawei.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

The last goto is unneeded, so remove it.

Signed-off-by: Joseph Qi <joseph.qi@huawei.com>
---
 fs/ocfs2/dlmglue.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/fs/ocfs2/dlmglue.c b/fs/ocfs2/dlmglue.c
index 474e57f..1cfa1b6bf 100644
--- a/fs/ocfs2/dlmglue.c
+++ b/fs/ocfs2/dlmglue.c
@@ -1664,10 +1664,8 @@ int ocfs2_create_new_inode_locks(struct inode *inode)
 	}

 	ret = ocfs2_create_new_lock(osb, &OCFS2_I(inode)->ip_open_lockres, 0, 0);
-	if (ret) {
+	if (ret)
 		mlog_errno(ret);
-		goto bail;
-	}

 bail:
 	return ret;
-- 
1.8.4.3
