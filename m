From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Thu, 23 Jun 2011 15:31:00 -0700
Subject: [Ocfs2-devel] [PATCH 06/13] ocfs2/dlm: Clean up refmap helpers
In-Reply-To: <1308868267-5981-1-git-send-email-sunil.mushran@oracle.com>
References: <1308868267-5981-1-git-send-email-sunil.mushran@oracle.com>
Message-ID: <1308868267-5981-7-git-send-email-sunil.mushran@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Patch cleans up helpers that set/clear refmap bits and grab/drop inflight lock
ref counts.

Signed-off-by: Sunil Mushran <sunil.mushran@oracle.com>
---
 fs/ocfs2/dlm/dlmcommon.h   |   49 ++++--------------------
 fs/ocfs2/dlm/dlmmaster.c   |   88 ++++++++++++++++++++++++++-----------------
 fs/ocfs2/dlm/dlmrecovery.c |    8 ++--
 3 files changed, 66 insertions(+), 79 deletions(-)

diff --git a/fs/ocfs2/dlm/dlmcommon.h b/fs/ocfs2/dlm/dlmcommon.h
index d602abb..4a5d580 100644
--- a/fs/ocfs2/dlm/dlmcommon.h
+++ b/fs/ocfs2/dlm/dlmcommon.h
@@ -902,46 +902,15 @@ struct dlm_lock_resource *dlm_new_lockres(struct dlm_ctxt *dlm,
 					  const char *name,
 					  unsigned int namelen);
 
-#define dlm_lockres_set_refmap_bit(bit,res)  \
-	__dlm_lockres_set_refmap_bit(bit,res,__FILE__,__LINE__)
-#define dlm_lockres_clear_refmap_bit(bit,res)  \
-	__dlm_lockres_clear_refmap_bit(bit,res,__FILE__,__LINE__)
-
-static inline void __dlm_lockres_set_refmap_bit(int bit,
-						struct dlm_lock_resource *res,
-						const char *file,
-						int line)
-{
-	//printk("%s:%d:%.*s: setting bit %d\n", file, line,
-	//     res->lockname.len, res->lockname.name, bit);
-	set_bit(bit, res->refmap);
-}
-
-static inline void __dlm_lockres_clear_refmap_bit(int bit,
-						  struct dlm_lock_resource *res,
-						  const char *file,
-						  int line)
-{
-	//printk("%s:%d:%.*s: clearing bit %d\n", file, line,
-	//     res->lockname.len, res->lockname.name, bit);
-	clear_bit(bit, res->refmap);
-}
-
-void __dlm_lockres_drop_inflight_ref(struct dlm_ctxt *dlm,
-				   struct dlm_lock_resource *res,
-				   const char *file,
-				   int line);
-void __dlm_lockres_grab_inflight_ref(struct dlm_ctxt *dlm,
-				   struct dlm_lock_resource *res,
-				   int new_lockres,
-				   const char *file,
-				   int line);
-#define dlm_lockres_drop_inflight_ref(d,r)  \
-	__dlm_lockres_drop_inflight_ref(d,r,__FILE__,__LINE__)
-#define dlm_lockres_grab_inflight_ref(d,r)  \
-	__dlm_lockres_grab_inflight_ref(d,r,0,__FILE__,__LINE__)
-#define dlm_lockres_grab_inflight_ref_new(d,r)  \
-	__dlm_lockres_grab_inflight_ref(d,r,1,__FILE__,__LINE__)
+void dlm_lockres_set_refmap_bit(struct dlm_ctxt *dlm,
+				struct dlm_lock_resource *res, int bit);
+void dlm_lockres_clear_refmap_bit(struct dlm_ctxt *dlm,
+				  struct dlm_lock_resource *res, int bit);
+
+void dlm_lockres_drop_inflight_ref(struct dlm_ctxt *dlm,
+				   struct dlm_lock_resource *res);
+void dlm_lockres_grab_inflight_ref(struct dlm_ctxt *dlm,
+				   struct dlm_lock_resource *res);
 
 void dlm_queue_ast(struct dlm_ctxt *dlm, struct dlm_lock *lock);
 void dlm_queue_bast(struct dlm_ctxt *dlm, struct dlm_lock *lock);
diff --git a/fs/ocfs2/dlm/dlmmaster.c b/fs/ocfs2/dlm/dlmmaster.c
index 9f3b093..11e446f 100644
--- a/fs/ocfs2/dlm/dlmmaster.c
+++ b/fs/ocfs2/dlm/dlmmaster.c
@@ -631,39 +631,58 @@ error:
 	return NULL;
 }
 
-void __dlm_lockres_grab_inflight_ref(struct dlm_ctxt *dlm,
-				   struct dlm_lock_resource *res,
-				   int new_lockres,
-				   const char *file,
-				   int line)
+void dlm_lockres_set_refmap_bit(struct dlm_ctxt *dlm,
+				struct dlm_lock_resource *res, int bit)
 {
-	if (!new_lockres)
-		assert_spin_locked(&res->spinlock);
+	assert_spin_locked(&res->spinlock);
+
+	mlog(0, "res %.*s, set node %u, %ps()\n", res->lockname.len,
+	     res->lockname.name, bit, __builtin_return_address(0));
+
+	set_bit(bit, res->refmap);
+}
+
+void dlm_lockres_clear_refmap_bit(struct dlm_ctxt *dlm,
+				  struct dlm_lock_resource *res, int bit)
+{
+	assert_spin_locked(&res->spinlock);
+
+	mlog(0, "res %.*s, clr node %u, %ps()\n", res->lockname.len,
+	     res->lockname.name, bit, __builtin_return_address(0));
+
+	clear_bit(bit, res->refmap);
+}
+
+
+void dlm_lockres_grab_inflight_ref(struct dlm_ctxt *dlm,
+				   struct dlm_lock_resource *res)
+{
+	assert_spin_locked(&res->spinlock);
 
 	if (!test_bit(dlm->node_num, res->refmap)) {
 		BUG_ON(res->inflight_locks != 0);
-		dlm_lockres_set_refmap_bit(dlm->node_num, res);
+		dlm_lockres_set_refmap_bit(dlm, res, dlm->node_num);
 	}
 	res->inflight_locks++;
-	mlog(0, "%s:%.*s: inflight++: now %u\n",
-	     dlm->name, res->lockname.len, res->lockname.name,
-	     res->inflight_locks);
+	mlog(0, "%s: res %.*s, inflight++: now %u, %ps()\n", dlm->name,
+	     res->lockname.len, res->lockname.name, res->inflight_locks,
+	     __builtin_return_address(0));
 }
 
-void __dlm_lockres_drop_inflight_ref(struct dlm_ctxt *dlm,
-				   struct dlm_lock_resource *res,
-				   const char *file,
-				   int line)
+void dlm_lockres_drop_inflight_ref(struct dlm_ctxt *dlm,
+				   struct dlm_lock_resource *res)
 {
 	assert_spin_locked(&res->spinlock);
 
 	BUG_ON(res->inflight_locks == 0);
+
 	res->inflight_locks--;
-	mlog(0, "%s:%.*s: inflight--: now %u\n",
-	     dlm->name, res->lockname.len, res->lockname.name,
-	     res->inflight_locks);
+	mlog(0, "%s: res %.*s, inflight--: now %u, %ps()\n", dlm->name,
+	     res->lockname.len, res->lockname.name, res->inflight_locks,
+	     __builtin_return_address(0));
+
 	if (res->inflight_locks == 0)
-		dlm_lockres_clear_refmap_bit(dlm->node_num, res);
+		dlm_lockres_clear_refmap_bit(dlm, res, dlm->node_num);
 	wake_up(&res->wq);
 }
 
@@ -843,8 +862,10 @@ lookup:
 
 	/* finally add the lockres to its hash bucket */
 	__dlm_insert_lockres(dlm, res);
-	/* since this lockres is new it doesn't not require the spinlock */
-	dlm_lockres_grab_inflight_ref_new(dlm, res);
+
+	spin_lock(&res->spinlock);
+	dlm_lockres_grab_inflight_ref(dlm, res);
+	spin_unlock(&res->spinlock);
 
 	/* if this node does not become the master make sure to drop
 	 * this inflight reference below */
@@ -1426,9 +1447,7 @@ way_up_top:
 		}
 
 		if (res->owner == dlm->node_num) {
-			mlog(0, "%s:%.*s: setting bit %u in refmap\n",
-			     dlm->name, namelen, name, request->node_idx);
-			dlm_lockres_set_refmap_bit(request->node_idx, res);
+			dlm_lockres_set_refmap_bit(dlm, res, request->node_idx);
 			spin_unlock(&res->spinlock);
 			response = DLM_MASTER_RESP_YES;
 			if (mle)
@@ -1493,10 +1512,8 @@ way_up_top:
 				 * go back and clean the mles on any
 				 * other nodes */
 				dispatch_assert = 1;
-				dlm_lockres_set_refmap_bit(request->node_idx, res);
-				mlog(0, "%s:%.*s: setting bit %u in refmap\n",
-				     dlm->name, namelen, name,
-				     request->node_idx);
+				dlm_lockres_set_refmap_bit(dlm, res,
+							   request->node_idx);
 			} else
 				response = DLM_MASTER_RESP_NO;
 		} else {
@@ -1702,7 +1719,7 @@ again:
 			     "lockres, set the bit in the refmap\n",
 			     namelen, lockname, to);
 			spin_lock(&res->spinlock);
-			dlm_lockres_set_refmap_bit(to, res);
+			dlm_lockres_set_refmap_bit(dlm, res, to);
 			spin_unlock(&res->spinlock);
 		}
 	}
@@ -2256,7 +2273,7 @@ int dlm_deref_lockres_handler(struct o2net_msg *msg, u32 len, void *data,
 	else {
 		BUG_ON(res->state & DLM_LOCK_RES_DROPPING_REF);
 		if (test_bit(node, res->refmap)) {
-			dlm_lockres_clear_refmap_bit(node, res);
+			dlm_lockres_clear_refmap_bit(dlm, res, node);
 			cleared = 1;
 		}
 	}
@@ -2316,7 +2333,7 @@ static void dlm_deref_lockres_worker(struct dlm_work_item *item, void *data)
 	BUG_ON(res->state & DLM_LOCK_RES_DROPPING_REF);
 	if (test_bit(node, res->refmap)) {
 		__dlm_wait_on_lockres_flags(res, DLM_LOCK_RES_SETREF_INPROG);
-		dlm_lockres_clear_refmap_bit(node, res);
+		dlm_lockres_clear_refmap_bit(dlm, res, node);
 		cleared = 1;
 	}
 	spin_unlock(&res->spinlock);
@@ -2798,7 +2815,8 @@ static void dlm_remove_nonlocal_locks(struct dlm_ctxt *dlm,
 				BUG_ON(!list_empty(&lock->bast_list));
 				BUG_ON(lock->ast_pending);
 				BUG_ON(lock->bast_pending);
-				dlm_lockres_clear_refmap_bit(lock->ml.node, res);
+				dlm_lockres_clear_refmap_bit(dlm, res,
+							     lock->ml.node);
 				list_del_init(&lock->list);
 				dlm_lock_put(lock);
 				/* In a normal unlock, we would have added a
@@ -2819,7 +2837,7 @@ static void dlm_remove_nonlocal_locks(struct dlm_ctxt *dlm,
 			mlog(0, "%s:%.*s: node %u had a ref to this "
 			     "migrating lockres, clearing\n", dlm->name,
 			     res->lockname.len, res->lockname.name, bit);
-			dlm_lockres_clear_refmap_bit(bit, res);
+			dlm_lockres_clear_refmap_bit(dlm, res, bit);
 		}
 		bit++;
 	}
@@ -2933,7 +2951,7 @@ static int dlm_do_migrate_request(struct dlm_ctxt *dlm,
 			     dlm->name, res->lockname.len, res->lockname.name,
 			     nodenum);
 			spin_lock(&res->spinlock);
-			dlm_lockres_set_refmap_bit(nodenum, res);
+			dlm_lockres_set_refmap_bit(dlm, res, nodenum);
 			spin_unlock(&res->spinlock);
 		}
 	}
@@ -3267,7 +3285,7 @@ int dlm_finish_migration(struct dlm_ctxt *dlm, struct dlm_lock_resource *res,
 	 * mastery reference here since old_master will briefly have
 	 * a reference after the migration completes */
 	spin_lock(&res->spinlock);
-	dlm_lockres_set_refmap_bit(old_master, res);
+	dlm_lockres_set_refmap_bit(dlm, res, old_master);
 	spin_unlock(&res->spinlock);
 
 	mlog(0, "now time to do a migrate request to other nodes\n");
diff --git a/fs/ocfs2/dlm/dlmrecovery.c b/fs/ocfs2/dlm/dlmrecovery.c
index 41e74f0..f1a3aa8 100644
--- a/fs/ocfs2/dlm/dlmrecovery.c
+++ b/fs/ocfs2/dlm/dlmrecovery.c
@@ -1776,7 +1776,7 @@ static int dlm_process_recovery_data(struct dlm_ctxt *dlm,
 			     dlm->name, mres->lockname_len, mres->lockname,
 			     from);
 			spin_lock(&res->spinlock);
-			dlm_lockres_set_refmap_bit(from, res);
+			dlm_lockres_set_refmap_bit(dlm, res, from);
 			spin_unlock(&res->spinlock);
 			added++;
 			break;
@@ -1974,7 +1974,7 @@ skip_lvb:
 			mlog(0, "%s:%.*s: added lock for node %u, "
 			     "setting refmap bit\n", dlm->name,
 			     res->lockname.len, res->lockname.name, ml->node);
-			dlm_lockres_set_refmap_bit(ml->node, res);
+			dlm_lockres_set_refmap_bit(dlm, res, ml->node);
 			added++;
 		}
 		spin_unlock(&res->spinlock);
@@ -2254,12 +2254,12 @@ static void dlm_free_dead_locks(struct dlm_ctxt *dlm,
 			     res->lockname.len, res->lockname.name, freed, dead_node);
 			__dlm_print_one_lock_resource(res);
 		}
-		dlm_lockres_clear_refmap_bit(dead_node, res);
+		dlm_lockres_clear_refmap_bit(dlm, res, dead_node);
 	} else if (test_bit(dead_node, res->refmap)) {
 		mlog(0, "%s:%.*s: dead node %u had a ref, but had "
 		     "no locks and had not purged before dying\n", dlm->name,
 		     res->lockname.len, res->lockname.name, dead_node);
-		dlm_lockres_clear_refmap_bit(dead_node, res);
+		dlm_lockres_clear_refmap_bit(dlm, res, dead_node);
 	}
 
 	/* do not kick thread yet */
-- 
1.7.4.1
