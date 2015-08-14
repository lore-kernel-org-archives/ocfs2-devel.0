From: Joseph Qi <joseph.qi@huawei.com>
Date: Fri, 14 Aug 2015 17:11:49 +0800
Subject: [Ocfs2-devel] [PATCH] ocfs2: remove unneeded code in ocfs2_dlm_init
Message-ID: <55CDB0D5.1030408@huawei.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

status is already initialized and it will only be 0 or negatives in the
code flow. So remove the unneeded assignment after the lable 'local'.

Signed-off-by: Joseph Qi <joseph.qi@huawei.com>
---
 fs/ocfs2/dlmglue.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/fs/ocfs2/dlmglue.c b/fs/ocfs2/dlmglue.c
index 8b23aa2..87eee70 100644
--- a/fs/ocfs2/dlmglue.c
+++ b/fs/ocfs2/dlmglue.c
@@ -3035,8 +3035,6 @@ local:
 	ocfs2_orphan_scan_lock_res_init(&osb->osb_orphan_scan.os_lockres, osb);

 	osb->cconn = conn;
-
-	status = 0;
 bail:
 	if (status < 0) {
 		ocfs2_dlm_shutdown_debug(osb);
-- 
1.8.4.3
