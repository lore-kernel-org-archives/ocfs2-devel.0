From: Wengang Wang <wen.gang.wang@oracle.com>
Date: Sat, 26 Jun 2010 19:32:37 +0800
Subject: [Ocfs2-devel] [PATCH 2/2] ocfs2: o2dlm fix race in purge lockres
	and newlock (orabug 9094491) -backport to 1.2
Message-ID: <201006261134.o5QBKSZP015884@acsinet15.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

This patch fixes the following hole.
dlmlock tries to create a new lock on a lockres that is on purge list. It calls
dlm_get_lockresource and later adds a lock to blocked list. But in this window,
dlm_thread can purge the lockres and unhash it. This will cause a BUG, as when
the AST comes back from the master lockres is not found

This patch marks the lockres with a new state DLM_LOCK_RES_IN_USE which would
protect lockres from dlm_thread purging it.

Signed-off-by: Srinivas Eeda <srinivas.eeda@oracle.com>
Signed-off-by: Sunil Mushran <sunil.mushran@oracle.com>
---
 dlmcommon.h |    1 +
 dlmlock.c   |    4 ++++
 dlmmaster.c |    5 ++++-
 dlmthread.c |    1 +
 4 files changed, 10 insertions(+), 1 deletion(-)

diff -upr ocfs2-1.2.9-8-test/fs/ocfs2/dlm/dlmcommon.h ocfs2-1.2.9-8.2/fs/ocfs2/dlm/dlmcommon.h
--- ocfs2-1.2.9-8-test/fs/ocfs2/dlm/dlmcommon.h	2010-06-26 19:04:32.000000000 +0800
+++ ocfs2-1.2.9-8.2/fs/ocfs2/dlm/dlmcommon.h	2010-06-26 19:18:33.000000000 +0800
@@ -218,6 +218,7 @@ static inline void __dlm_set_joining_nod
 #define DLM_LOCK_RES_IN_PROGRESS          0x00000010
 #define DLM_LOCK_RES_MIGRATING            0x00000020
 #define DLM_LOCK_RES_DROPPING_REF         0x00000040
+#define DLM_LOCK_RES_IN_USE               0x00000100
 #define DLM_LOCK_RES_BLOCK_DIRTY          0x00001000
 #define DLM_LOCK_RES_SETREF_INPROG        0x00002000
 
diff -upr ocfs2-1.2.9-8-test/fs/ocfs2/dlm/dlmlock.c ocfs2-1.2.9-8.2/fs/ocfs2/dlm/dlmlock.c
--- ocfs2-1.2.9-8-test/fs/ocfs2/dlm/dlmlock.c	2010-06-26 19:04:22.000000000 +0800
+++ ocfs2-1.2.9-8.2/fs/ocfs2/dlm/dlmlock.c	2010-06-26 19:21:06.000000000 +0800
@@ -116,6 +116,8 @@ static enum dlm_status dlmlock_master(st
 	if (status != DLM_NORMAL &&
 	    lock->ml.node != dlm->node_num) {
 		/* erf.  state changed after lock was dropped. */
+		/* DLM_LOCK_RES_IN_USE is set in dlm_get_lock_resource */
+		res->state &= ~DLM_LOCK_RES_IN_USE;
 		spin_unlock(&res->spinlock);
 		dlm_error(status);
 		return status;
@@ -162,6 +164,7 @@ static enum dlm_status dlmlock_master(st
 			kick_thread = 1;
 		}
 	}
+	res->state &= ~DLM_LOCK_RES_IN_USE;
 	/* reduce the inflight count, this may result in the lockres
 	 * being purged below during calc_usage */
 	if (lock->ml.node == dlm->node_num)
@@ -228,6 +231,7 @@ static enum dlm_status dlmlock_remote(st
 
 	spin_lock(&res->spinlock);
 	res->state &= ~DLM_LOCK_RES_IN_PROGRESS;
+	res->state &= ~DLM_LOCK_RES_IN_USE;
 	lock->lock_pending = 0;
 	if (status != DLM_NORMAL) {
 		if (status == DLM_RECOVERING &&
diff -upr ocfs2-1.2.9-8-test/fs/ocfs2/dlm/dlmmaster.c ocfs2-1.2.9-8.2/fs/ocfs2/dlm/dlmmaster.c
--- ocfs2-1.2.9-8-test/fs/ocfs2/dlm/dlmmaster.c	2010-06-26 19:04:22.000000000 +0800
+++ ocfs2-1.2.9-8.2/fs/ocfs2/dlm/dlmmaster.c	2010-06-26 19:23:57.000000000 +0800
@@ -804,12 +804,15 @@ lookup:
 	if (tmpres) {
 		int dropping_ref = 0;
 
+		tmpres->state |= DLM_LOCK_RES_IN_USE;
 		spin_lock(&tmpres->spinlock);
 		if (tmpres->owner == dlm->node_num) {
 			BUG_ON(tmpres->state & DLM_LOCK_RES_DROPPING_REF);
 			dlm_lockres_grab_inflight_ref(dlm, tmpres);
-		} else if (tmpres->state & DLM_LOCK_RES_DROPPING_REF)
+		} else if (tmpres->state & DLM_LOCK_RES_DROPPING_REF) {
+			tmpres->state &= ~DLM_LOCK_RES_IN_USE;
 			dropping_ref = 1;
+		}
 		spin_unlock(&tmpres->spinlock);
 		spin_unlock(&dlm->spinlock);
 
diff -upr ocfs2-1.2.9-8-test/fs/ocfs2/dlm/dlmthread.c ocfs2-1.2.9-8.2/fs/ocfs2/dlm/dlmthread.c
--- ocfs2-1.2.9-8-test/fs/ocfs2/dlm/dlmthread.c	2010-06-26 19:04:32.000000000 +0800
+++ ocfs2-1.2.9-8.2/fs/ocfs2/dlm/dlmthread.c	2010-06-26 19:25:06.000000000 +0800
@@ -97,6 +97,7 @@ int __dlm_lockres_has_locks(struct dlm_l
 int __dlm_lockres_unused(struct dlm_lock_resource *res)
 {
 	if (!__dlm_lockres_has_locks(res) &&
+	    !(res->state & DLM_LOCK_RES_IN_USE) &&
 	    (list_empty(&res->dirty) && !(res->state & DLM_LOCK_RES_DIRTY))) {
 		/* try not to scan the bitmap unless the first two
 		 * conditions are already true */
