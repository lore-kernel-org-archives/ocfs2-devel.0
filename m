From: Joseph Qi <joseph.qi@huawei.com>
Date: Wed, 14 Sep 2016 17:32:41 +0800
Subject: [Ocfs2-devel] [PATCH v2 RESEND] ocfs2: fix double unlock in case
 retry after free truncate log
Message-ID: <57D91939.6030809@huawei.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

If ocfs2_reserve_cluster_bitmap_bits fails with ENOSPC, it will try to
free truncate log and then retry. Since ocfs2_try_to_free_truncate_log
will lock/unlock global bitmap inode, we have to unlock it before
calling this function. But when retry reserve and it fails with no
global bitmap inode lock taken, it will unlock again in error handling
branch and BUG.
This issue also exists if no need retry and then ocfs2_inode_lock fails.
So fix it.

Changes since v1:
Use ret instead of status to avoid return value overwritten issue.

Fixes: 2070ad1aebff ("ocfs2: retry on ENOSPC if sufficient space in
truncate log"
Signed-off-by: Joseph Qi <joseph.qi@huawei.com>
Signed-off-by: Jiufei Xue <xuejiufei@huawei.com>
---
 fs/ocfs2/suballoc.c | 14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff --git a/fs/ocfs2/suballoc.c b/fs/ocfs2/suballoc.c
index ea47120..6ad3533 100644
--- a/fs/ocfs2/suballoc.c
+++ b/fs/ocfs2/suballoc.c
@@ -1199,14 +1199,24 @@ retry:
 			inode_unlock((*ac)->ac_inode);

 			ret = ocfs2_try_to_free_truncate_log(osb, bits_wanted);
-			if (ret == 1)
+			if (ret == 1) {
+				iput((*ac)->ac_inode);
+				(*ac)->ac_inode = NULL;
 				goto retry;
+			}

 			if (ret < 0)
 				mlog_errno(ret);

 			inode_lock((*ac)->ac_inode);
-			ocfs2_inode_lock((*ac)->ac_inode, NULL, 1);
+			ret = ocfs2_inode_lock((*ac)->ac_inode, NULL, 1);
+			if (ret < 0) {
+				mlog_errno(ret);
+				inode_unlock((*ac)->ac_inode);
+				iput((*ac)->ac_inode);
+				(*ac)->ac_inode = NULL;
+				goto bail;
+			}
 		}
 		if (status < 0) {
 			if (status != -ENOSPC)
-- 
1.8.4.3
