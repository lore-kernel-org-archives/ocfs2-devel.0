From: Adrian Bunk <bunk@stusta.de>
Date: Fri, 31 Mar 2006 16:53:55 +0200
Subject: [Ocfs2-devel] [2.6 patch] fs/ocfs2/dlm/dlmrecovery.c: make
	dlm_lockres_master_requery() static
Message-ID: <20060331145355.GF3893@stusta.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: mark.fasheh@oracle.com, kurt.hackel@oracle.com
Cc: ocfs2-devel@oss.oracle.com, linux-kernel@vger.kernel.org

dlm_lockres_master_requery() became global without any external usage.


Signed-off-by: Adrian Bunk <bunk@stusta.de>

---

 fs/ocfs2/dlm/dlmcommon.h   |    2 --
 fs/ocfs2/dlm/dlmrecovery.c |    8 ++++++--
 2 files changed, 6 insertions(+), 4 deletions(-)

--- linux-2.6.16-mm2-full/fs/ocfs2/dlm/dlmcommon.h.old	2006-03-31 15:46:51.000000000 +0200
+++ linux-2.6.16-mm2-full/fs/ocfs2/dlm/dlmcommon.h	2006-03-31 15:46:58.000000000 +0200
@@ -801,8 +801,6 @@
 int dlm_finalize_reco_handler(struct o2net_msg *msg, u32 len, void *data);
 int dlm_do_master_requery(struct dlm_ctxt *dlm, struct dlm_lock_resource *res,
 			  u8 nodenum, u8 *real_master);
-int dlm_lockres_master_requery(struct dlm_ctxt *dlm,
-			       struct dlm_lock_resource *res, u8 *real_master);
 
 
 int dlm_dispatch_assert_master(struct dlm_ctxt *dlm,
--- linux-2.6.16-mm2-full/fs/ocfs2/dlm/dlmrecovery.c.old	2006-03-31 15:47:07.000000000 +0200
+++ linux-2.6.16-mm2-full/fs/ocfs2/dlm/dlmrecovery.c	2006-03-31 15:47:49.000000000 +0200
@@ -95,6 +95,9 @@
 static void dlm_request_all_locks_worker(struct dlm_work_item *item,
 					 void *data);
 static void dlm_mig_lockres_worker(struct dlm_work_item *item, void *data);
+static int dlm_lockres_master_requery(struct dlm_ctxt *dlm,
+				      struct dlm_lock_resource *res,
+				      u8 *real_master);
 
 static u64 dlm_get_next_mig_cookie(void);
 
@@ -1312,8 +1315,9 @@
 
 
 
-int dlm_lockres_master_requery(struct dlm_ctxt *dlm,
-			       struct dlm_lock_resource *res, u8 *real_master)
+static int dlm_lockres_master_requery(struct dlm_ctxt *dlm,
+				      struct dlm_lock_resource *res,
+				      u8 *real_master)
 {
 	struct dlm_node_iter iter;
 	int nodenum;
