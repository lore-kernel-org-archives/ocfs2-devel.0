From: Joseph Qi <joseph.qi@huawei.com>
Date: Mon, 20 May 2013 17:36:12 +0800
Subject: [Ocfs2-devel] [PATCH] clean up duplicate declaration in
	dlmrecovery.c
Message-ID: <5199EE8C.5050808@huawei.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Below 3 functions have already been declared in dlmcommon.h, so we have
no need to declare them again in dlmrecovery.c.
dlm_complete_recovery_thread
dlm_launch_recovery_thread
dlm_kick_recovery_thread

Signed-off-by: Joseph Qi <joseph.qi@huawei.com>

---
 fs/ocfs2/dlm/dlmrecovery.c |    3 ---
 1 file changed, 3 deletions(-)

diff --git a/fs/ocfs2/dlm/dlmrecovery.c b/fs/ocfs2/dlm/dlmrecovery.c
index 93de2e0..1741c33 100644
--- a/fs/ocfs2/dlm/dlmrecovery.c
+++ b/fs/ocfs2/dlm/dlmrecovery.c
@@ -55,9 +55,6 @@
 static void dlm_do_local_recovery_cleanup(struct dlm_ctxt *dlm, u8
dead_node);

 static int dlm_recovery_thread(void *data);
-void dlm_complete_recovery_thread(struct dlm_ctxt *dlm);
-int dlm_launch_recovery_thread(struct dlm_ctxt *dlm);
-void dlm_kick_recovery_thread(struct dlm_ctxt *dlm);
 static int dlm_do_recovery(struct dlm_ctxt *dlm);

 static int dlm_pick_recovery_master(struct dlm_ctxt *dlm);
--
1.7.9.7
