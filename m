From: Joseph Qi <joseph.qi@huawei.com>
Date: Tue, 11 Feb 2014 20:15:02 +0800
Subject: [Ocfs2-devel] [PATCH] ocfs2: fix null pointer dereference when
 access dlm_state before launching dlm thread
Message-ID: <52FA1446.7030704@huawei.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

From: Zongxun Wang <wangzongxun@huawei.com>

When mounting an ocfs2 volume, it will firstly generate a file
/sys/kernel/debug/o2dlm/<uuid>/dlm_state, and then launch the dlm thread.
So the following situation will cause a null pointer dereference.
dlm_debug_init -> access file dlm_state which will call dlm_state_print
-> dlm_launch_thread
Move dlm_debug_init after dlm_launch_thread and
dlm_launch_recovery_thread can fix this issue.

Signed-off-by: Zongxun Wang <wangzongxun@huawei.com>
Signed-off-by: Joseph Qi <joseph.qi@huawei.com>
---
 fs/ocfs2/dlm/dlmdomain.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/ocfs2/dlm/dlmdomain.c b/fs/ocfs2/dlm/dlmdomain.c
index 33660a4..1307a8c 100644
--- a/fs/ocfs2/dlm/dlmdomain.c
+++ b/fs/ocfs2/dlm/dlmdomain.c
@@ -1877,19 +1877,19 @@ static int dlm_join_domain(struct dlm_ctxt *dlm)
 		goto bail;
 	}

-	status = dlm_debug_init(dlm);
+	status = dlm_launch_thread(dlm);
 	if (status < 0) {
 		mlog_errno(status);
 		goto bail;
 	}

-	status = dlm_launch_thread(dlm);
+	status = dlm_launch_recovery_thread(dlm);
 	if (status < 0) {
 		mlog_errno(status);
 		goto bail;
 	}

-	status = dlm_launch_recovery_thread(dlm);
+	status = dlm_debug_init(dlm);
 	if (status < 0) {
 		mlog_errno(status);
 		goto bail;
-- 
1.8.4.3
