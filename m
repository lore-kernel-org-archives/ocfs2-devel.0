From: Wengang Wang <wen.gang.wang@oracle.com>
Date: Tue, 13 Sep 2011 17:13:45 +0800
Subject: [Ocfs2-devel] [PATCH] Wake up down-convert thread when clearing
	OCFS2_LOCK_UPCONVERT_FINISHING from ocfs2_lock_res.l_flags
Message-ID: <201109130913.p8D9DehZ013352@acsmt357.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

In down convert thread, when the ocfs2_lock_res is in OCFS2_LOCK_UPCONVERT_FINISHING
state, it is requeued for next run of ocfs2_downconvert_thread_do_work(). If not
waked up, the DC thread just sleep there without even there are ocfs2_lock_res' left
in the list.

So when clearing the OCFS2_LOCK_UPCONVERT_FINISHING flag, we need also to wake up dc
thread accordingly.

Signed-off-by: Wengang Wang <wen.gang.wang@oracle.com>
---
 fs/ocfs2/dlmglue.c |   18 +++++++++++-------
 1 files changed, 11 insertions(+), 7 deletions(-)

diff --git a/fs/ocfs2/dlmglue.c b/fs/ocfs2/dlmglue.c
index 7642d7c..9e86d79 100644
--- a/fs/ocfs2/dlmglue.c
+++ b/fs/ocfs2/dlmglue.c
@@ -359,7 +359,8 @@ static inline void ocfs2_generic_handle_attach_action(struct ocfs2_lock_res *loc
 static int ocfs2_generic_handle_bast(struct ocfs2_lock_res *lockres, int level);
 static void ocfs2_schedule_blocked_lock(struct ocfs2_super *osb,
 					struct ocfs2_lock_res *lockres);
-static inline void ocfs2_recover_from_dlm_error(struct ocfs2_lock_res *lockres,
+static inline void ocfs2_recover_from_dlm_error(struct ocfs2_super *osb,
+						struct ocfs2_lock_res *lockres,
 						int convert);
 #define ocfs2_log_dlm_error(_func, _err, _lockres) do {					\
 	if ((_lockres)->l_type != OCFS2_LOCK_TYPE_DENTRY)				\
@@ -1191,7 +1192,8 @@ void ocfs2_set_locking_protocol(void)
 	ocfs2_stack_glue_set_max_proto_version(&lproto.lp_max_version);
 }
 
-static inline void ocfs2_recover_from_dlm_error(struct ocfs2_lock_res *lockres,
+static inline void ocfs2_recover_from_dlm_error(struct ocfs2_super *osb,
+						struct ocfs2_lock_res *lockres,
 						int convert)
 {
 	unsigned long flags;
@@ -1206,6 +1208,7 @@ static inline void ocfs2_recover_from_dlm_error(struct ocfs2_lock_res *lockres,
 	spin_unlock_irqrestore(&lockres->l_lock, flags);
 
 	wake_up(&lockres->l_event);
+	ocfs2_wake_downconvert_thread(osb);
 }
 
 /* Note: If we detect another process working on the lock (i.e.,
@@ -1246,7 +1249,7 @@ static int ocfs2_lock_create(struct ocfs2_super *osb,
 	lockres_clear_pending(lockres, gen, osb);
 	if (ret) {
 		ocfs2_log_dlm_error("ocfs2_dlm_lock", ret, lockres);
-		ocfs2_recover_from_dlm_error(lockres, 1);
+		ocfs2_recover_from_dlm_error(osb, lockres, 1);
 	}
 
 	mlog(0, "lock %s, return from ocfs2_dlm_lock\n", lockres->l_name);
@@ -1478,7 +1481,7 @@ again:
 				ocfs2_log_dlm_error("ocfs2_dlm_lock",
 						    ret, lockres);
 			}
-			ocfs2_recover_from_dlm_error(lockres, 1);
+			ocfs2_recover_from_dlm_error(osb, lockres, 1);
 			goto out;
 		}
 
@@ -1502,6 +1505,7 @@ unlock:
 	lockres_clear_flags(lockres, OCFS2_LOCK_UPCONVERT_FINISHING);
 
 	spin_unlock_irqrestore(&lockres->l_lock, flags);
+	ocfs2_wake_downconvert_thread(osb);
 out:
 	/*
 	 * This is helping work around a lock inversion between the page lock
@@ -1891,7 +1895,7 @@ int ocfs2_file_lock(struct file *file, int ex, int trylock)
 			ret = -EINVAL;
 		}
 
-		ocfs2_recover_from_dlm_error(lockres, 1);
+		ocfs2_recover_from_dlm_error(osb, lockres, 1);
 		lockres_remove_mask_waiter(lockres, &mw);
 		goto out;
 	}
@@ -3264,7 +3268,7 @@ static int ocfs2_downconvert_lock(struct ocfs2_super *osb,
 	lockres_clear_pending(lockres, generation, osb);
 	if (ret) {
 		ocfs2_log_dlm_error("ocfs2_dlm_lock", ret, lockres);
-		ocfs2_recover_from_dlm_error(lockres, 1);
+		ocfs2_recover_from_dlm_error(osb, lockres, 1);
 		goto bail;
 	}
 
@@ -3312,7 +3316,7 @@ static int ocfs2_cancel_convert(struct ocfs2_super *osb,
 			       DLM_LKF_CANCEL);
 	if (ret) {
 		ocfs2_log_dlm_error("ocfs2_dlm_unlock", ret, lockres);
-		ocfs2_recover_from_dlm_error(lockres, 0);
+		ocfs2_recover_from_dlm_error(osb, lockres, 0);
 	}
 
 	mlog(ML_BASTS, "lockres %s\n", lockres->l_name);
-- 
1.7.6.1
