From: Wengang Wang <wen.gang.wang@oracle.com>
Date: Thu, 26 Aug 2010 21:07:15 +0800
Subject: [Ocfs2-devel] [PATCH 2/5] ocfs2/dlm: add lockres as parameter to
	dlm_new_lock()
Message-ID: <201008261310.o7PHoc69015692@acsinet15.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Wether the dlm_lock needs to access lvb or not depends on dlm_lock_resource it belongs to. So a new parameter "struct dlm_lock_resource *res" is added to dlm_new_lock() so that we can know if we need to allocate lvb for the dlm_lock. And we have to make the lockres availale for calling dlm_new_lock().

Signed-off-by: Wengang Wang <wen.gang.wang@oracle.com>
---
 fs/ocfs2/dlm/dlmcommon.h   |    3 +-
 fs/ocfs2/dlm/dlmlock.c     |   55 ++++++++++++++++++++++---------------------
 fs/ocfs2/dlm/dlmrecovery.c |    2 +-
 3 files changed, 31 insertions(+), 29 deletions(-)

diff --git a/fs/ocfs2/dlm/dlmcommon.h b/fs/ocfs2/dlm/dlmcommon.h
index 49e6492..4e10aa6 100644
--- a/fs/ocfs2/dlm/dlmcommon.h
+++ b/fs/ocfs2/dlm/dlmcommon.h
@@ -785,7 +785,8 @@ static inline unsigned long long dlm_get_lock_cookie_seq(u64 cookie)
 }
 
 struct dlm_lock * dlm_new_lock(int type, u8 node, u64 cookie,
-			       struct dlm_lockstatus *lksb);
+			       struct dlm_lockstatus *lksb,
+			       struct dlm_lock_resource *res);
 void dlm_lock_get(struct dlm_lock *lock);
 void dlm_lock_put(struct dlm_lock *lock);
 
diff --git a/fs/ocfs2/dlm/dlmlock.c b/fs/ocfs2/dlm/dlmlock.c
index 5c7ece7..7d0bef2 100644
--- a/fs/ocfs2/dlm/dlmlock.c
+++ b/fs/ocfs2/dlm/dlmlock.c
@@ -432,7 +432,8 @@ char *dlm_alloc_lvb(char **lvb)
 }
 
 struct dlm_lock * dlm_new_lock(int type, u8 node, u64 cookie,
-			       struct dlm_lockstatus *lksb)
+			       struct dlm_lockstatus *lksb,
+			       struct dlm_lock_resource *res)
 {
 	struct dlm_lock *lock;
 	int kernel_allocated = 0;
@@ -502,22 +503,6 @@ int dlm_create_lock_handler(struct o2net_msg *msg, u32 len, void *data,
 		goto leave;
 	}
 
-	status = DLM_SYSERR;
-	newlock = dlm_new_lock(create->requested_type,
-			       create->node_idx,
-			       be64_to_cpu(create->cookie), NULL);
-	if (!newlock) {
-		dlm_error(status);
-		goto leave;
-	}
-
-	lksb = newlock->lksb;
-
-	if (be32_to_cpu(create->flags) & LKM_GET_LVB) {
-		lksb->flags |= DLM_LKSB_GET_LVB;
-		mlog(0, "set DLM_LKSB_GET_LVB flag\n");
-	}
-
 	status = DLM_IVLOCKID;
 	res = dlm_lookup_lockres(dlm, name, namelen);
 	if (!res) {
@@ -534,6 +519,22 @@ int dlm_create_lock_handler(struct o2net_msg *msg, u32 len, void *data,
 		goto leave;
 	}
 
+	status = DLM_SYSERR;
+	newlock = dlm_new_lock(create->requested_type,
+			       create->node_idx,
+			       be64_to_cpu(create->cookie), NULL, res);
+	if (!newlock) {
+		dlm_error(status);
+		goto leave;
+	}
+
+	lksb = newlock->lksb;
+
+	if (be32_to_cpu(create->flags) & LKM_GET_LVB) {
+		lksb->flags |= DLM_LKSB_GET_LVB;
+		mlog(0, "set DLM_LKSB_GET_LVB flag\n");
+	}
+
 	dlm_lock_attach_lockres(newlock, res);
 
 	status = dlmlock_master(dlm, res, newlock, be32_to_cpu(create->flags));
@@ -678,16 +679,6 @@ retry_convert:
 			goto error;
 		}
 
-		dlm_get_next_cookie(dlm->node_num, &tmpcookie);
-		lock = dlm_new_lock(mode, dlm->node_num, tmpcookie, lksb);
-		if (!lock) {
-			dlm_error(status);
-			goto error;
-		}
-
-		if (!recovery)
-			dlm_wait_for_recovery(dlm);
-
 		/* find or create the lock resource */
 		res = dlm_get_lock_resource(dlm, name, namelen, flags);
 		if (!res) {
@@ -699,6 +690,16 @@ retry_convert:
 		mlog(0, "type=%d, flags = 0x%x\n", mode, flags);
 		mlog(0, "creating lock: lock=%p res=%p\n", lock, res);
 
+		dlm_get_next_cookie(dlm->node_num, &tmpcookie);
+		lock = dlm_new_lock(mode, dlm->node_num, tmpcookie, lksb, res);
+		if (!lock) {
+			dlm_error(status);
+			goto error;
+		}
+
+		if (!recovery)
+			dlm_wait_for_recovery(dlm);
+
 		dlm_lock_attach_lockres(lock, res);
 		lock->ast = ast;
 		lock->bast = bast;
diff --git a/fs/ocfs2/dlm/dlmrecovery.c b/fs/ocfs2/dlm/dlmrecovery.c
index aaaffbc..e41780c 100644
--- a/fs/ocfs2/dlm/dlmrecovery.c
+++ b/fs/ocfs2/dlm/dlmrecovery.c
@@ -1865,7 +1865,7 @@ static int dlm_process_recovery_data(struct dlm_ctxt *dlm,
 
 		/* lock is for another node. */
 		newlock = dlm_new_lock(ml->type, ml->node,
-				       be64_to_cpu(ml->cookie), NULL);
+				       be64_to_cpu(ml->cookie), NULL, res);
 		if (!newlock) {
 			ret = -ENOMEM;
 			goto leave;
-- 
1.7.2.1
