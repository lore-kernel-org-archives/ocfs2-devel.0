From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Thu,  1 Mar 2012 11:34:19 -0800
Subject: [Ocfs2-devel] [PATCH 5/9] ocfs2/dlm: Fix list traversal in
	dlm_process_recovery_data()
In-Reply-To: <1330630463-30305-1-git-send-email-sunil.mushran@oracle.com>
References: <1330630463-30305-1-git-send-email-sunil.mushran@oracle.com>
Message-ID: <1330630463-30305-5-git-send-email-sunil.mushran@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

This bug, detected via static analysis, was introduced by commit 800deef3
that replaced the existing list_for_each() with list_for_each_entry(). We
have no record of it hitting users during runtime. This could be because
this lock list is supposed to have only one lock that is owned by that node
averting the case in which lock is set to NULL.

Reported-by: Julia Lawall <julia@diku.dk>
Signed-off-by: Sunil Mushran <sunil.mushran@oracle.com>
---
 fs/ocfs2/dlm/dlmrecovery.c |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/fs/ocfs2/dlm/dlmrecovery.c b/fs/ocfs2/dlm/dlmrecovery.c
index 01ebfd0..c881be6 100644
--- a/fs/ocfs2/dlm/dlmrecovery.c
+++ b/fs/ocfs2/dlm/dlmrecovery.c
@@ -1752,7 +1752,7 @@ static int dlm_process_recovery_data(struct dlm_ctxt *dlm,
 				     struct dlm_migratable_lockres *mres)
 {
 	struct dlm_migratable_lock *ml;
-	struct list_head *queue;
+	struct list_head *queue, *iter;
 	struct list_head *tmpq = NULL;
 	struct dlm_lock *newlock = NULL;
 	struct dlm_lockstatus *lksb = NULL;
@@ -1796,11 +1796,11 @@ static int dlm_process_recovery_data(struct dlm_ctxt *dlm,
 			spin_lock(&res->spinlock);
 			for (j = DLM_GRANTED_LIST; j <= DLM_BLOCKED_LIST; j++) {
 				tmpq = dlm_list_idx_to_ptr(res, j);
-				list_for_each_entry(lock, tmpq, list) {
-					if (lock->ml.cookie != ml->cookie)
-						lock = NULL;
-					else
+				list_for_each(iter, tmpq) {
+					lock = list_entry(iter, struct dlm_lock, list);
+					if (lock->ml.cookie == ml->cookie)
 						break;
+					lock = NULL;
 				}
 				if (lock)
 					break;
-- 
1.7.7.6
