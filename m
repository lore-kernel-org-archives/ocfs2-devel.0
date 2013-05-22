From: Joseph Qi <joseph.qi@huawei.com>
Date: Wed, 22 May 2013 23:50:19 +0800
Subject: [Ocfs2-devel] [PATCH] ret should be int instead of enum in
	dlm_request_all_locks
Message-ID: <519CE93B.20005@huawei.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

In dlm_request_all_locks, ret is type enum. But o2net_send_message
returns a type int value. Then it will never run into the following
error branch. So we should change the ret type from enum to int.

Signed-off-by: Joseph Qi <joseph.qi@huawei.com>

---
 fs/ocfs2/dlm/dlmrecovery.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/fs/ocfs2/dlm/dlmrecovery.c b/fs/ocfs2/dlm/dlmrecovery.c
index 060af11..a83e378 100644
--- a/fs/ocfs2/dlm/dlmrecovery.c
+++ b/fs/ocfs2/dlm/dlmrecovery.c
@@ -786,7 +786,7 @@ static int dlm_request_all_locks(struct dlm_ctxt
*dlm, u8 request_from,
 				 u8 dead_node)
 {
 	struct dlm_lock_request lr;
-	enum dlm_status ret;
+	int ret;

 	mlog(0, "\n");

@@ -799,7 +799,6 @@ static int dlm_request_all_locks(struct dlm_ctxt
*dlm, u8 request_from,
 	lr.dead_node = dead_node;

 	// send message
-	ret = DLM_NOLOCKMGR;
 	ret = o2net_send_message(DLM_LOCK_REQUEST_MSG, dlm->key,
 				 &lr, sizeof(lr), request_from, NULL);

-- 
1.7.9.7
