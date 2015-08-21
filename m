From: Joseph Qi <joseph.qi@huawei.com>
Date: Fri, 21 Aug 2015 16:21:09 +0800
Subject: [Ocfs2-devel] [PATCH] ocfs2/dlm: use list_for_each_entry instead of
	list_for_each
Message-ID: <55D6DF75.3070503@huawei.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Use list_for_each_entry instead of list_for_each to simplify code.

Signed-off-by: Joseph Qi <joseph.qi@huawei.com>
---
 fs/ocfs2/dlm/dlmrecovery.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/fs/ocfs2/dlm/dlmrecovery.c b/fs/ocfs2/dlm/dlmrecovery.c
index ce12e0b..d0e436d 100644
--- a/fs/ocfs2/dlm/dlmrecovery.c
+++ b/fs/ocfs2/dlm/dlmrecovery.c
@@ -1776,7 +1776,7 @@ static int dlm_process_recovery_data(struct dlm_ctxt *dlm,
 				     struct dlm_migratable_lockres *mres)
 {
 	struct dlm_migratable_lock *ml;
-	struct list_head *queue, *iter;
+	struct list_head *queue;
 	struct list_head *tmpq = NULL;
 	struct dlm_lock *newlock = NULL;
 	struct dlm_lockstatus *lksb = NULL;
@@ -1821,9 +1821,7 @@ static int dlm_process_recovery_data(struct dlm_ctxt *dlm,
 			spin_lock(&res->spinlock);
 			for (j = DLM_GRANTED_LIST; j <= DLM_BLOCKED_LIST; j++) {
 				tmpq = dlm_list_idx_to_ptr(res, j);
-				list_for_each(iter, tmpq) {
-					lock = list_entry(iter,
-						  struct dlm_lock, list);
+				list_for_each_entry(lock, tmpq, list) {
 					if (lock->ml.cookie == ml->cookie)
 						break;
 					lock = NULL;
-- 
1.8.4.3
