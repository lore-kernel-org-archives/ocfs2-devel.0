From: akpm at linux-foundation.org <akpm@linux-foundation.org>
Date: Wed, 23 Mar 2016 13:12:23 -0700
Subject: [Ocfs2-devel] [patch 14/25] ocfs2/dlm: fix BUG in
 dlm_move_lockres_to_recovery_list
Message-ID: <56f2f8a7.iq7Lv4ZelSHUyEqe%akpm@linux-foundation.org>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: mfasheh@suse.de, jlbec@evilplan.org, junxiao.bi@oracle.com, joseph.qi@huawei.com, ocfs2-devel@oss.oracle.com, akpm@linux-foundation.org, jiangyiwen@huawei.com, stable@vger.kernel.org, tariq.x.saeed@oracle.com

From: Joseph Qi <joseph.qi@huawei.com>
Subject: ocfs2/dlm: fix BUG in dlm_move_lockres_to_recovery_list

When master handles convert request, it queues ast first and then returns
status.  This may happen that the ast is sent before the request status
because the above two messages are sent by two threads.  And right after
the ast is sent, if master down, it may trigger BUG in
dlm_move_lockres_to_recovery_list in the requested node because ast
handler moves it to grant list without clear lock->convert_pending.  So
remove BUG_ON statement and check if the ast is processed in
dlmconvert_remote.

Signed-off-by: Joseph Qi <joseph.qi@huawei.com>
Reported-by: Yiwen Jiang <jiangyiwen@huawei.com>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Mark Fasheh <mfasheh@suse.de>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Tariq Saeed <tariq.x.saeed@oracle.com>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/dlm/dlmconvert.c  |   13 +++++++++++++
 fs/ocfs2/dlm/dlmrecovery.c |    1 -
 2 files changed, 13 insertions(+), 1 deletion(-)

diff -puN fs/ocfs2/dlm/dlmconvert.c~ocfs2-dlm-fix-bug-in-dlm_move_lockres_to_recovery_list fs/ocfs2/dlm/dlmconvert.c
--- a/fs/ocfs2/dlm/dlmconvert.c~ocfs2-dlm-fix-bug-in-dlm_move_lockres_to_recovery_list
+++ a/fs/ocfs2/dlm/dlmconvert.c
@@ -288,6 +288,19 @@ enum dlm_status dlmconvert_remote(struct
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
diff -puN fs/ocfs2/dlm/dlmrecovery.c~ocfs2-dlm-fix-bug-in-dlm_move_lockres_to_recovery_list fs/ocfs2/dlm/dlmrecovery.c
--- a/fs/ocfs2/dlm/dlmrecovery.c~ocfs2-dlm-fix-bug-in-dlm_move_lockres_to_recovery_list
+++ a/fs/ocfs2/dlm/dlmrecovery.c
@@ -2083,7 +2083,6 @@ void dlm_move_lockres_to_recovery_list(s
 			dlm_lock_get(lock);
 			if (lock->convert_pending) {
 				/* move converting lock back to granted */
-				BUG_ON(i != DLM_CONVERTING_LIST);
 				mlog(0, "node died with convert pending "
 				     "on %.*s. move back to granted list.\n",
 				     res->lockname.len, res->lockname.name);
_
