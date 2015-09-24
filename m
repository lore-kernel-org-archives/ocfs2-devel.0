From: Joseph Qi <joseph.qi@huawei.com>
Date: Thu, 24 Sep 2015 11:19:15 +0800
Subject: [Ocfs2-devel] [PATCH 2/2] ocfs2/dlm: fix BUG in
	dlm_move_lockres_to_recovery_list
Message-ID: <56036BB3.9020302@huawei.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

When master handles convert request, it queues ast first and then
returns status. This may happen that the ast is sent before the request
status because the above two messages are sent by two threads.
And right after the ast is sent, if master down, it may trigger BUG in
dlm_move_lockres_to_recovery_list in the requested node because ast
handler moves it to grant list without clear lock->convert_pending.
So remove BUG_ON statement and check if the ast is processed in
dlmconvert_remote.

Signed-off-by: Joseph Qi <joseph.qi@huawei.com>
Cc: <stable@vger.kernel.org>
---
 fs/ocfs2/dlm/dlmconvert.c  | 13 +++++++++++++
 fs/ocfs2/dlm/dlmrecovery.c |  1 -
 2 files changed, 13 insertions(+), 1 deletion(-)

diff --git a/fs/ocfs2/dlm/dlmconvert.c b/fs/ocfs2/dlm/dlmconvert.c
index 9e6116e..a338715 100644
--- a/fs/ocfs2/dlm/dlmconvert.c
+++ b/fs/ocfs2/dlm/dlmconvert.c
@@ -288,6 +288,19 @@ enum dlm_status dlmconvert_remote(struct dlm_ctxt *dlm,
 		status = DLM_DENIED;
 		goto bail;
 	}
+
+	if (lock->ml.type == type && lock->ml.convert_type == LKM_IVMODE) {
+		mlog(0, "last convert request returned DLM_RECOVERING, but "
+		     "owner has already queued and sent ast to me. res %.*s, "
+		     "(cookie=%u:%llu, type=%d, conv=%d)\n",
+		     res->lockname.len, res->lockname.name,
+		     dlm_get_lock_cookie_node(be64_to_cpu(lock->ml.cookie)),
+		     dlm_get_lock_cookie_seq(be64_to_cpu(lock->ml.cookie)),
+		     lock->ml.type, lock->ml.convert_type);
+		status = DLM_NORMAL;
+		goto bail;
+	}
+
 	res->state |= DLM_LOCK_RES_IN_PROGRESS;
 	/* move lock to local convert queue */
 	/* do not alter lock refcount.  switching lists. */
diff --git a/fs/ocfs2/dlm/dlmrecovery.c b/fs/ocfs2/dlm/dlmrecovery.c
index 3d90ad7..5c0f761 100644
--- a/fs/ocfs2/dlm/dlmrecovery.c
+++ b/fs/ocfs2/dlm/dlmrecovery.c
@@ -2064,7 +2064,6 @@ void dlm_move_lockres_to_recovery_list(struct dlm_ctxt *dlm,
 			dlm_lock_get(lock);
 			if (lock->convert_pending) {
 				/* move converting lock back to granted */
-				BUG_ON(i != DLM_CONVERTING_LIST);
 				mlog(0, "node died with convert pending "
 				     "on %.*s. move back to granted list.\n",
 				     res->lockname.len, res->lockname.name);
-- 
1.8.4.3
