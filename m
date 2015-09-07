From: Norton.Zhu <norton.zhu@huawei.com>
Date: Mon, 7 Sep 2015 10:11:56 +0800
Subject: [Ocfs2-devel] [PATCH] ocfs2_direct_IO_write misses
 ocfs2_is_overwrite error code
Message-ID: <55ECF26C.4000100@huawei.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

If ocfs2_is_overwrite failed, ocfs2_direct_IO_write mays till return success to the caller.

Signed-off-by: Norton.Zhu <norton.zhu@huawei.com>
---
 aops.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/aops.c b/aops.c
index 0f5fd9d..4107279 100644
--- a/aops.c
+++ b/aops.c
@@ -847,6 +847,7 @@ static ssize_t ocfs2_direct_IO_write(struct kiocb *iocb,
 		is_overwrite = ocfs2_is_overwrite(osb, inode, offset);
 		if (is_overwrite < 0) {
 			mlog_errno(is_overwrite);
+			ret = is_overwrite;
 			ocfs2_inode_unlock(inode, 1);
 			goto clean_orphan;
 		}
-- 
1.8.4.3
