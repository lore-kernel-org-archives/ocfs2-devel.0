From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Tue Mar 11 16:32:19 2008
Subject: [Ocfs2-devel] [PATCH 14/18] ocfs2/dlm: Add missing
	dlm_lockres_put()s in migration path
In-Reply-To: <1205278329-11111-1-git-send-email-sunil.mushran@oracle.com>
References: <1205278329-11111-1-git-send-email-sunil.mushran@oracle.com>
Message-ID: <1205278329-11111-15-git-send-email-sunil.mushran@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Mainline commit 52987e2ab456c1a828046494aac53819b1454341
Author: Sunil Mushran <sunil.mushran@oracle.com>
Date: Sat, 1 Mar 2008 14:04:21 -0800

During migration, the recovery master node may be asked to master a lockres
it may not know about. In that case, it would not only have to create a
lockres and add it to the hash, but also remember to to do the _put_
corresponding to the kref_init in dlm_init_lockres(), as soon as the migration
is completed. Yes, we don't wait for the dlm_purge_lockres() to do that
matching put. Note the ref added for it being in the hash protects the lockres
from being freed prematurely.

This patch adds that missing put, as described above, to plug a memleak.

Signed-off-by: Sunil Mushran <sunil.mushran@oracle.com>
Signed-off-by: Joel Becker <joel.becker@oracle.com>
Signed-off-by: Mark Fasheh <mark.fasheh@oracle.com>
---
 fs/ocfs2/dlm/dlmcommon.h   |    1 +
 fs/ocfs2/dlm/dlmrecovery.c |   40 ++++++++++++++++++++++++++++++++++------
 2 files changed, 35 insertions(+), 6 deletions(-)

diff --git a/fs/ocfs2/dlm/dlmcommon.h b/fs/ocfs2/dlm/dlmcommon.h
index b90ee17..57c0a08 100644
--- a/fs/ocfs2/dlm/dlmcommon.h
+++ b/fs/ocfs2/dlm/dlmcommon.h
@@ -176,6 +176,7 @@ struct dlm_mig_lockres_priv
 {
 	struct dlm_lock_resource *lockres;
 	u8 real_master;
+	u8 extra_ref;
 };
 
 struct dlm_assert_master_priv
diff --git a/fs/ocfs2/dlm/dlmrecovery.c b/fs/ocfs2/dlm/dlmrecovery.c
index 4a0e7aa..7843ec1 100644
--- a/fs/ocfs2/dlm/dlmrecovery.c
+++ b/fs/ocfs2/dlm/dlmrecovery.c
@@ -1327,6 +1327,7 @@ int dlm_mig_lockres_handler(struct o2net_msg *msg, u32 len, void *data,
 		(struct dlm_migratable_lockres *)msg->buf;
 	int ret = 0;
 	u8 real_master;
+	u8 extra_refs = 0;
 	char *buf = NULL;
 	struct dlm_work_item *item = NULL;
 	struct dlm_lock_resource *res = NULL;
@@ -1404,16 +1405,28 @@ int dlm_mig_lockres_handler(struct o2net_msg *msg, u32 len, void *data,
 		__dlm_insert_lockres(dlm, res);
 		spin_unlock(&dlm->spinlock);
 
+		/* Add an extra ref for this lock-less lockres lest the
+		 * dlm_thread purges it before we get the chance to add
+		 * locks to it */
+		dlm_lockres_get(res);
+
+		/* There are three refs that need to be put.
+		 * 1. Taken above.
+		 * 2. kref_init in dlm_new_lockres()->dlm_init_lockres().
+		 * 3. dlm_lookup_lockres()
+		 * The first one is handled at the end of this function. The
+		 * other two are handled in the worker thread after locks have
+		 * been attached. Yes, we don't wait for purge time to match
+		 * kref_init. The lockres will still have atleast one ref
+		 * added because it is in the hash __dlm_insert_lockres() */
+		extra_refs++;
+
 		/* now that the new lockres is inserted,
 		 * make it usable by other processes */
 		spin_lock(&res->spinlock);
 		res->state &= ~DLM_LOCK_RES_IN_PROGRESS;
 		spin_unlock(&res->spinlock);
 		wake_up(&res->wq);
-
-		/* add an extra ref for just-allocated lockres 
-		 * otherwise the lockres will be purged immediately */
-		dlm_lockres_get(res);
 	}
 
 	/* at this point we have allocated everything we need,
@@ -1443,12 +1456,17 @@ int dlm_mig_lockres_handler(struct o2net_msg *msg, u32 len, void *data,
 	dlm_init_work_item(dlm, item, dlm_mig_lockres_worker, buf);
 	item->u.ml.lockres = res; /* already have a ref */
 	item->u.ml.real_master = real_master;
+	item->u.ml.extra_ref = extra_refs;
 	spin_lock(&dlm->work_lock);
 	list_add_tail(&item->list, &dlm->work_list);
 	spin_unlock(&dlm->work_lock);
 	queue_work(dlm->dlm_worker, &dlm->dispatched_work);
 
 leave:
+	/* One extra ref taken needs to be put here */
+	if (extra_refs)
+		dlm_lockres_put(res);
+
 	dlm_put(dlm);
 	if (ret < 0) {
 		if (buf)
@@ -1464,17 +1482,19 @@ leave:
 
 static void dlm_mig_lockres_worker(struct dlm_work_item *item, void *data)
 {
-	struct dlm_ctxt *dlm = data;
+	struct dlm_ctxt *dlm;
 	struct dlm_migratable_lockres *mres;
 	int ret = 0;
 	struct dlm_lock_resource *res;
 	u8 real_master;
+	u8 extra_ref;
 
 	dlm = item->dlm;
 	mres = (struct dlm_migratable_lockres *)data;
 
 	res = item->u.ml.lockres;
 	real_master = item->u.ml.real_master;
+	extra_ref = item->u.ml.extra_ref;
 
 	if (real_master == DLM_LOCK_RES_OWNER_UNKNOWN) {
 		/* this case is super-rare. only occurs if
@@ -1517,6 +1537,12 @@ again:
 	}
 
 leave:
+	/* See comment in dlm_mig_lockres_handler() */
+	if (res) {
+		if (extra_ref)
+			dlm_lockres_put(res);
+		dlm_lockres_put(res);
+	}
 	kfree(data);
 	mlog_exit(ret);
 }
@@ -1644,7 +1670,8 @@ int dlm_master_requery_handler(struct o2net_msg *msg, u32 len, void *data,
 				/* retry!? */
 				BUG();
 			}
-		}
+		} else /* put.. incase we are not the master */
+			dlm_lockres_put(res);
 		spin_unlock(&res->spinlock);
 	}
 	spin_unlock(&dlm->spinlock);
@@ -1921,6 +1948,7 @@ void dlm_move_lockres_to_recovery_list(struct dlm_ctxt *dlm,
 		     "Recovering res %s:%.*s, is already on recovery list!\n",
 		     dlm->name, res->lockname.len, res->lockname.name);
 		list_del_init(&res->recovering);
+		dlm_lockres_put(res);
 	}
 	/* We need to hold a reference while on the recovery list */
 	dlm_lockres_get(res);
-- 
1.5.3.4
