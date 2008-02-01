From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Fri Feb  1 16:50:02 2008
Subject: [Ocfs2-devel] [PATCH 04/12] ocfs2_dlm: Link all lockres' to a
	tracking list
In-Reply-To: <1201913371-1522-1-git-send-email-sunil.mushran@oracle.com>
References: <1201913371-1522-1-git-send-email-sunil.mushran@oracle.com>
Message-ID: <1201913371-1522-5-git-send-email-sunil.mushran@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

This patch links all the lockres' to a tracking list in dlm_ctxt.
We will use this in the upcoming patch that will walk the entire
list and to dump the lockres states to a debugfs file.

Signed-off-by: Sunil Mushran <sunil.mushran@oracle.com>
---
 fs/ocfs2/dlm/dlmcommon.h |    6 ++++--
 fs/ocfs2/dlm/dlmdomain.c |    1 +
 fs/ocfs2/dlm/dlmmaster.c |   12 +++++++++---
 fs/ocfs2/dlm/dlmthread.c |    5 +++++
 4 files changed, 19 insertions(+), 5 deletions(-)

diff --git a/fs/ocfs2/dlm/dlmcommon.h b/fs/ocfs2/dlm/dlmcommon.h
index 041ec68..d782b41 100644
--- a/fs/ocfs2/dlm/dlmcommon.h
+++ b/fs/ocfs2/dlm/dlmcommon.h
@@ -101,6 +101,7 @@ struct dlm_ctxt
 	struct list_head purge_list;
 	struct list_head pending_asts;
 	struct list_head pending_basts;
+	struct list_head tracking_list;
 	unsigned int purge_count;
 	spinlock_t spinlock;
 	spinlock_t ast_lock;
@@ -259,11 +260,12 @@ struct dlm_lock_resource
 	struct list_head purge;
 
 	/*
-	 * These two lists require you to hold an additional reference
+	 * These three lists require you to hold an additional reference
 	 * while they are on the list.
 	 */
 	struct list_head dirty;
-	struct list_head recovering; // dlm_recovery_ctxt.resources list
+	struct list_head recovering;	/* dlm->dlm_recovery_ctxt.resources */
+	struct list_head tracking;	/* dlm->tracking_list */
 
 	/* unused lock resources have their last_used stamped and are
 	 * put on a list for the dlm thread to run. */
diff --git a/fs/ocfs2/dlm/dlmdomain.c b/fs/ocfs2/dlm/dlmdomain.c
index 6d02ef5..71d3946 100644
--- a/fs/ocfs2/dlm/dlmdomain.c
+++ b/fs/ocfs2/dlm/dlmdomain.c
@@ -1404,6 +1404,7 @@ static struct dlm_ctxt *dlm_alloc_ctxt(const char *domain,
 	INIT_LIST_HEAD(&dlm->reco.node_data);
 	INIT_LIST_HEAD(&dlm->purge_list);
 	INIT_LIST_HEAD(&dlm->dlm_domain_handlers);
+	INIT_LIST_HEAD(&dlm->tracking_list);
 	dlm->reco.state = 0;
 
 	INIT_LIST_HEAD(&dlm->pending_asts);
diff --git a/fs/ocfs2/dlm/dlmmaster.c b/fs/ocfs2/dlm/dlmmaster.c
index e469e49..4f2bf7c 100644
--- a/fs/ocfs2/dlm/dlmmaster.c
+++ b/fs/ocfs2/dlm/dlmmaster.c
@@ -648,10 +648,11 @@ static void dlm_lockres_release(struct kref *kref)
 	    !list_empty(&res->blocked) ||
 	    !list_empty(&res->dirty) ||
 	    !list_empty(&res->recovering) ||
-	    !list_empty(&res->purge)) {
+	    !list_empty(&res->purge) ||
+	    !list_empty(&res->tracking)) {
 		mlog(ML_ERROR,
 		     "Going to BUG for resource %.*s."
-		     "  We're on a list! [%c%c%c%c%c%c%c]\n",
+		     "  We're on a list! [%c%c%c%c%c%c%c%c]\n",
 		     res->lockname.len, res->lockname.name,
 		     !hlist_unhashed(&res->hash_node) ? 'H' : ' ',
 		     !list_empty(&res->granted) ? 'G' : ' ',
@@ -659,7 +660,8 @@ static void dlm_lockres_release(struct kref *kref)
 		     !list_empty(&res->blocked) ? 'B' : ' ',
 		     !list_empty(&res->dirty) ? 'D' : ' ',
 		     !list_empty(&res->recovering) ? 'R' : ' ',
-		     !list_empty(&res->purge) ? 'P' : ' ');
+		     !list_empty(&res->purge) ? 'P' : ' ',
+		     !list_empty(&res->tracking) ? 'T' : ' ');
 
 		dlm_print_one_lock_resource(res);
 	}
@@ -709,6 +711,7 @@ static void dlm_init_lockres(struct dlm_ctxt *dlm,
 	INIT_LIST_HEAD(&res->dirty);
 	INIT_LIST_HEAD(&res->recovering);
 	INIT_LIST_HEAD(&res->purge);
+	INIT_LIST_HEAD(&res->tracking);
 	atomic_set(&res->asts_reserved, 0);
 	res->migration_pending = 0;
 	res->inflight_locks = 0;
@@ -724,6 +727,9 @@ static void dlm_init_lockres(struct dlm_ctxt *dlm,
 
 	res->last_used = 0;
 
+	dlm_lockres_get(res);
+	list_add_tail(&res->tracking, &dlm->tracking_list);
+
 	memset(res->lvb, 0, DLM_LVB_LEN);
 	memset(res->refmap, 0, sizeof(res->refmap));
 }
diff --git a/fs/ocfs2/dlm/dlmthread.c b/fs/ocfs2/dlm/dlmthread.c
index cebd089..620d6a3 100644
--- a/fs/ocfs2/dlm/dlmthread.c
+++ b/fs/ocfs2/dlm/dlmthread.c
@@ -204,6 +204,11 @@ static int dlm_purge_lockres(struct dlm_ctxt *dlm,
 	}
 	__dlm_unhash_lockres(res);
 
+	if (!list_empty(&res->tracking)) {
+		list_del_init(&res->tracking);
+		dlm_lockres_put(res);
+	}
+
 	/* lockres is not in the hash now.  drop the flag and wake up
 	 * any processes waiting in dlm_get_lock_resource. */
 	if (!master) {
-- 
1.5.2.5
