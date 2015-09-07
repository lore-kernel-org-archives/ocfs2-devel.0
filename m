From: Norton.Zhu <norton.zhu@huawei.com>
Date: Mon, 7 Sep 2015 14:32:31 +0800
Subject: [Ocfs2-devel] [PATCH v2] ocfs2_direct_IO_write misses
 ocfs2_is_overwrite error code
Message-ID: <55ED2F7F.80109@huawei.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

If ocfs2_is_overwrite failed, ocfs2_direct_IO_write may still return success to the caller.
changelog:
Using mlog_errno(ret) looks better than mlog_errno(is_overwrite)

Signed-off-by: Norton.Zhu <norton.zhu@huawei.com>
---
 aops.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/aops.c b/aops.c
index 0f5fd9d..01bbc56 100644
--- a/aops.c
+++ b/aops.c
@@ -846,7 +846,8 @@ static ssize_t ocfs2_direct_IO_write(struct kiocb *iocb,

 		is_overwrite = ocfs2_is_overwrite(osb, inode, offset);
 		if (is_overwrite < 0) {
-			mlog_errno(is_overwrite);
+			ret = is_overwrite;
+			mlog_errno(ret);
 			ocfs2_inode_unlock(inode, 1);
 			goto clean_orphan;
 		}
-- 
1.8.4.3
