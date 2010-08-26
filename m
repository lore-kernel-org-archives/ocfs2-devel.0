From: Wengang Wang <wen.gang.wang@oracle.com>
Date: Thu, 26 Aug 2010 21:07:34 +0800
Subject: [Ocfs2-devel] [PATCH 3/5] ocfs2/dlm: add assertion on lksb->lvb
Message-ID: <201008261309.o7QCjRqn006028@acsinet15.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Add assertions on lksb->lvb before we access it.

Signed-off-by: Wengang Wang <wen.gang.wang@oracle.com>
---
 fs/ocfs2/dlm/dlmast.c      |    2 ++
 fs/ocfs2/dlm/dlmrecovery.c |    5 +++++
 2 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/fs/ocfs2/dlm/dlmast.c b/fs/ocfs2/dlm/dlmast.c
index fe272b1..b4287c6 100644
--- a/fs/ocfs2/dlm/dlmast.c
+++ b/fs/ocfs2/dlm/dlmast.c
@@ -193,6 +193,8 @@ static void dlm_update_lvb(struct dlm_ctxt *dlm, struct dlm_lock_resource *res,
 				  "remote");
 			mlog_bug_on_msg(!res->lvb, "lockname : %.*s\n",
 					res->lockname.len, res->lockname.name);
+			mlog_bug_on_msg(!lksb->lvb, "lockname : %.*s\n",
+					res->lockname.len, res->lockname.name);
 			memcpy(lksb->lvb, res->lvb, DLM_LVB_LEN);
 		}
 		/* Do nothing for lvb put requests - they should be done in
diff --git a/fs/ocfs2/dlm/dlmrecovery.c b/fs/ocfs2/dlm/dlmrecovery.c
index e41780c..fa6e5ae 100644
--- a/fs/ocfs2/dlm/dlmrecovery.c
+++ b/fs/ocfs2/dlm/dlmrecovery.c
@@ -1189,6 +1189,7 @@ static void dlm_prepare_lvb_for_migration(struct dlm_lock *lock,
 	}
 
 	/* Ensure the lvb copied for migration matches in other valid locks */
+	BUG_ON(!lock->lksb->lvb);
 	if (!memcmp(mres->lvb, lock->lksb->lvb, DLM_LVB_LEN))
 		return;
 
@@ -1884,6 +1885,10 @@ static int dlm_process_recovery_data(struct dlm_ctxt *dlm,
 			goto skip_lvb;
 
 		if (!dlm_lvb_is_empty(mres->lvb)) {
+			if (!lksb->lvb) {
+				dlm_print_one_lock_resource(res);
+				BUG();
+			}
 			if (lksb->flags & DLM_LKSB_PUT_LVB) {
 				/* other node was trying to update
 				 * lvb when node died.  recreate the
-- 
1.7.2.1
