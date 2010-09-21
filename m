From: Wengang Wang <wen.gang.wang@oracle.com>
Date: Tue, 21 Sep 2010 15:25:13 +0800
Subject: [Ocfs2-devel] [PATCH] ocfs2/dlm: allocate lvb for dlm_lock_resource
	which needs it -drop2
Message-ID: <201009210726.o8L7QxnB023011@rcsinet13.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

#reposting with trivial changes

Changes to drop1:
1) adds unsigned reserve_lvb:1 to dlm_lock_resource indicating lvb should be
reserved or not. This flag doesn't make sense to this patch its self, but it
helps the coming patch that allocates lvb for dlm_lock which needs it. The 1
bit flag doesn't take extra memory space, so putting it here is fine.

2) adds a new parameter to dlm_new_lockres() indicating if lvb memory should be
reserved. Determining method by checking name in v1 is discarded.

3) adds u8 reserve_lvb:1 to dlm_migratable_lockres indicating if the migration
target should reserve lvb for the dlm_lock_resouce in case of needing to create
a new dlm_lock_resouce.

4) increment dlm_protocol major version because of 3).

small changes:
1) moves the real allocation from dlm_init_lockres() to dlm_new_lockres().
since we have the new-added parameter, we know if we should do the allocation
in dlm_new_lockres(). And it's better we do allocations at the same space.

2) adds DLM_LKF_VALBLK to dlm_flags in ocfs2_lock_create.
We are missing the flag. But since it's adding a new lockres(no race), so no
problem running current codes.

3) adds some asserts on res->lvb.

Signed-off-by: Wengang Wang <wen.gang.wang@oracle.com>
---
 fs/ocfs2/dlm/dlmast.c      |    2 ++
 fs/ocfs2/dlm/dlmcommon.h   |    9 +++++++--
 fs/ocfs2/dlm/dlmconvert.c  |    5 ++++-
 fs/ocfs2/dlm/dlmdebug.c    |    6 ++++--
 fs/ocfs2/dlm/dlmdomain.c   |    6 +++++-
 fs/ocfs2/dlm/dlmmaster.c   |   16 +++++++++++++---
 fs/ocfs2/dlm/dlmrecovery.c |   34 +++++++++++++++++++++++++++-------
 fs/ocfs2/dlm/dlmunlock.c   |    2 ++
 fs/ocfs2/dlmglue.c         |    3 +++
 9 files changed, 67 insertions(+), 16 deletions(-)

diff --git a/fs/ocfs2/dlm/dlmast.c b/fs/ocfs2/dlm/dlmast.c
index f449991..cbe56c5 100644
--- a/fs/ocfs2/dlm/dlmast.c
+++ b/fs/ocfs2/dlm/dlmast.c
@@ -191,6 +191,8 @@ static void dlm_update_lvb(struct dlm_ctxt *dlm, struct dlm_lock_resource *res,
 			mlog(0, "getting lvb from lockres for %s node\n",
 				  lock->ml.node == dlm->node_num ? "master" :
 				  "remote");
+			mlog_bug_on_msg(!res->lvb, "lockname: %.*s\n",
+					res->lockname.len, res->lockname.name);
 			memcpy(lksb->lvb, res->lvb, DLM_LVB_LEN);
 		}
 		/* Do nothing for lvb put requests - they should be done in
diff --git a/fs/ocfs2/dlm/dlmcommon.h b/fs/ocfs2/dlm/dlmcommon.h
index 4b6ae2c..4b94ede 100644
--- a/fs/ocfs2/dlm/dlmcommon.h
+++ b/fs/ocfs2/dlm/dlmcommon.h
@@ -324,12 +324,13 @@ struct dlm_lock_resource
 	struct dlm_ctxt *dlm;
 
 	unsigned migration_pending:1;
+	unsigned reserve_lvb:1;
 	atomic_t asts_reserved;
 	spinlock_t spinlock;
 	wait_queue_head_t wq;
 	u8  owner;              //node which owns the lock resource, or unknown
 	u16 state;
-	char lvb[DLM_LVB_LEN];
+	char *lvb;
 	unsigned int inflight_locks;
 	unsigned long refmap[BITS_TO_LONGS(O2NM_MAX_NODES)];
 };
@@ -395,6 +396,8 @@ enum dlm_lockres_list {
 static inline int dlm_lvb_is_empty(char *lvb)
 {
 	int i;
+
+	BUG_ON(!lvb);
 	for (i=0; i<DLM_LVB_LEN; i++)
 		if (lvb[i])
 			return 0;
@@ -564,6 +567,7 @@ struct dlm_migratable_lockres
 	u8 lockname_len;
 	u8 num_locks;    // locks sent in this structure
 	u8 flags;
+	u8 reserve_lvb:1;
 	__be32 total_locks; // locks to be sent for this migration cookie
 	__be64 mig_cookie;  // cookie for this lockres migration
 			 // or zero if not needed
@@ -859,7 +863,8 @@ struct dlm_lock_resource * dlm_get_lock_resource(struct dlm_ctxt *dlm,
 						 int flags);
 struct dlm_lock_resource *dlm_new_lockres(struct dlm_ctxt *dlm,
 					  const char *name,
-					  unsigned int namelen);
+					  unsigned int namelen,
+					  unsigned int reserve_lvb);
 
 #define dlm_lockres_set_refmap_bit(bit,res)  \
 	__dlm_lockres_set_refmap_bit(bit,res,__FILE__,__LINE__)
diff --git a/fs/ocfs2/dlm/dlmconvert.c b/fs/ocfs2/dlm/dlmconvert.c
index 9f30491..93bb76b 100644
--- a/fs/ocfs2/dlm/dlmconvert.c
+++ b/fs/ocfs2/dlm/dlmconvert.c
@@ -212,8 +212,11 @@ grant:
 	if (lock->ml.node == dlm->node_num)
 		mlog(0, "doing in-place convert for nonlocal lock\n");
 	lock->ml.type = type;
-	if (lock->lksb->flags & DLM_LKSB_PUT_LVB)
+	if (lock->lksb->flags & DLM_LKSB_PUT_LVB) {
+		mlog_bug_on_msg(!res->lvb, "lockname: %*s\n", res->lockname.len,
+				res->lockname.name);
 		memcpy(res->lvb, lock->lksb->lvb, DLM_LVB_LEN);
+	}
 
 	status = DLM_NORMAL;
 	*call_ast = 1;
diff --git a/fs/ocfs2/dlm/dlmdebug.c b/fs/ocfs2/dlm/dlmdebug.c
index 5efdd37..15a4ca2 100644
--- a/fs/ocfs2/dlm/dlmdebug.c
+++ b/fs/ocfs2/dlm/dlmdebug.c
@@ -603,9 +603,11 @@ static int dump_lockres(struct dlm_lock_resource *res, char *buf, int len)
 
 	/* lvb */
 	out += snprintf(buf + out, len - out, "LVBX:");
-	for (i = 0; i < DLM_LVB_LEN; i++)
-		out += snprintf(buf + out, len - out,
+	if (res->lvb) {
+		for (i = 0; i < DLM_LVB_LEN; i++)
+			out += snprintf(buf + out, len - out,
 					"%02x", (unsigned char)res->lvb[i]);
+	}
 	out += snprintf(buf + out, len - out, "\n");
 
 	/* granted */
diff --git a/fs/ocfs2/dlm/dlmdomain.c b/fs/ocfs2/dlm/dlmdomain.c
index 153abb5..ecadf78 100644
--- a/fs/ocfs2/dlm/dlmdomain.c
+++ b/fs/ocfs2/dlm/dlmdomain.c
@@ -128,9 +128,13 @@ static DECLARE_WAIT_QUEUE_HEAD(dlm_domain_events);
  * will have a negotiated version with the same major number and a minor
  * number equal or smaller.  The dlm_ctxt->dlm_locking_proto field should
  * be used to determine what a running domain is actually using.
+ *
+ * history:
+ * 1.0	base
+ * 2.0	changes dlm_migratable_lockres struct for DLM_MIG_LOCKRES_MSG
  */
 static const struct dlm_protocol_version dlm_protocol = {
-	.pv_major = 1,
+	.pv_major = 2,
 	.pv_minor = 0,
 };
 
diff --git a/fs/ocfs2/dlm/dlmmaster.c b/fs/ocfs2/dlm/dlmmaster.c
index ffb4c68..090f896 100644
--- a/fs/ocfs2/dlm/dlmmaster.c
+++ b/fs/ocfs2/dlm/dlmmaster.c
@@ -545,6 +545,7 @@ static void dlm_lockres_release(struct kref *kref)
 
 	kmem_cache_free(dlm_lockname_cache, (void *)res->lockname.name);
 
+	kfree(res->lvb);
 	kmem_cache_free(dlm_lockres_cache, res);
 }
 
@@ -603,13 +604,13 @@ static void dlm_init_lockres(struct dlm_ctxt *dlm,
 	list_add_tail(&res->tracking, &dlm->tracking_list);
 	spin_unlock(&dlm->spinlock);
 
-	memset(res->lvb, 0, DLM_LVB_LEN);
 	memset(res->refmap, 0, sizeof(res->refmap));
 }
 
 struct dlm_lock_resource *dlm_new_lockres(struct dlm_ctxt *dlm,
 				   const char *name,
-				   unsigned int namelen)
+				   unsigned int namelen,
+				   unsigned int reserve_lvb)
 {
 	struct dlm_lock_resource *res = NULL;
 
@@ -621,6 +622,15 @@ struct dlm_lock_resource *dlm_new_lockres(struct dlm_ctxt *dlm,
 	if (!res->lockname.name)
 		goto error;
 
+	res->reserve_lvb = !!reserve_lvb;
+	if (res->reserve_lvb) {
+		res->lvb = kzalloc(DLM_LVB_LEN, GFP_NOFS);
+		if (!res->lvb)
+			goto error;
+	} else {
+		res->lvb = NULL;
+	}
+
 	dlm_init_lockres(dlm, res, name, namelen);
 	return res;
 
@@ -754,7 +764,7 @@ lookup:
 		alloc_mle = kmem_cache_alloc(dlm_mle_cache, GFP_NOFS);
 		if (!alloc_mle)
 			goto leave;
-		res = dlm_new_lockres(dlm, lockid, namelen);
+		res = dlm_new_lockres(dlm, lockid, namelen, flags & LKM_VALBLK);
 		if (!res)
 			goto leave;
 		goto lookup;
diff --git a/fs/ocfs2/dlm/dlmrecovery.c b/fs/ocfs2/dlm/dlmrecovery.c
index aaaffbc..bb0fade 100644
--- a/fs/ocfs2/dlm/dlmrecovery.c
+++ b/fs/ocfs2/dlm/dlmrecovery.c
@@ -71,7 +71,7 @@ static inline int dlm_num_locks_in_lockres(struct dlm_lock_resource *res);
 static void dlm_init_migratable_lockres(struct dlm_migratable_lockres *mres,
 					const char *lockname, int namelen,
 					int total_locks, u64 cookie,
-					u8 flags, u8 master);
+					u8 flags, u8 master, u8 reserve_lvb);
 static int dlm_send_mig_lockres_msg(struct dlm_ctxt *dlm,
 				    struct dlm_migratable_lockres *mres,
 				    u8 send_to,
@@ -1148,14 +1148,20 @@ static int dlm_send_mig_lockres_msg(struct dlm_ctxt *dlm,
 	/* zero and reinit the message buffer */
 	dlm_init_migratable_lockres(mres, res->lockname.name,
 				    res->lockname.len, mres_total_locks,
-				    mig_cookie, orig_flags, orig_master);
+				    mig_cookie, orig_flags, orig_master,
+				    res->reserve_lvb);
 	return ret;
 }
 
 static void dlm_init_migratable_lockres(struct dlm_migratable_lockres *mres,
-					const char *lockname, int namelen,
-					int total_locks, u64 cookie,
-					u8 flags, u8 master)
+					const char *lockname,
+					int namelen,
+					int total_locks,
+					u64 cookie,
+					u8 flags,
+					u8 master,
+					u8 reserve_lvb
+					)
 {
 	/* mres here is one full page */
 	clear_page(mres);
@@ -1166,6 +1172,7 @@ static void dlm_init_migratable_lockres(struct dlm_migratable_lockres *mres,
 	mres->mig_cookie = cpu_to_be64(cookie);
 	mres->flags = flags;
 	mres->master = master;
+	mres->reserve_lvb = !!reserve_lvb;
 }
 
 static void dlm_prepare_lvb_for_migration(struct dlm_lock *lock,
@@ -1183,6 +1190,9 @@ static void dlm_prepare_lvb_for_migration(struct dlm_lock *lock,
 	if (lock->ml.type != LKM_EXMODE && lock->ml.type != LKM_PRMODE)
 		return;
 
+	if (!mres->reserve_lvb)
+		return;
+
 	if (dlm_lvb_is_empty(mres->lvb)) {
 		memcpy(mres->lvb, lock->lksb->lvb, DLM_LVB_LEN);
 		return;
@@ -1282,7 +1292,8 @@ int dlm_send_one_lockres(struct dlm_ctxt *dlm, struct dlm_lock_resource *res,
 
 	dlm_init_migratable_lockres(mres, res->lockname.name,
 				    res->lockname.len, total_locks,
-				    mig_cookie, flags, res->owner);
+				    mig_cookie, flags, res->owner,
+				    res->reserve_lvb);
 
 	total_locks = 0;
 	for (i=DLM_GRANTED_LIST; i<=DLM_BLOCKED_LIST; i++) {
@@ -1410,7 +1421,8 @@ int dlm_mig_lockres_handler(struct o2net_msg *msg, u32 len, void *data,
 	} else {
 		/* need to allocate, just like if it was
 		 * mastered here normally  */
-		res = dlm_new_lockres(dlm, mres->lockname, mres->lockname_len);
+		res = dlm_new_lockres(dlm, mres->lockname, mres->lockname_len,
+				      mres->reserve_lvb);
 		if (!res)
 			goto leave;
 
@@ -1883,6 +1895,14 @@ static int dlm_process_recovery_data(struct dlm_ctxt *dlm,
 		if (ml->type == LKM_NLMODE)
 			goto skip_lvb;
 
+		if (!mres->reserve_lvb) {
+			mlog_bug_on_msg(res->lvb, "lockname: %.*s\n",
+					res->lockname.len, res->lockname.name);
+			goto skip_lvb;
+		}
+
+		mlog_bug_on_msg(!res->lvb, "lockname: %.*s\n",
+				res->lockname.len, res->lockname.name);
 		if (!dlm_lvb_is_empty(mres->lvb)) {
 			if (lksb->flags & DLM_LKSB_PUT_LVB) {
 				/* other node was trying to update
diff --git a/fs/ocfs2/dlm/dlmunlock.c b/fs/ocfs2/dlm/dlmunlock.c
index 817287c..9de2e4e 100644
--- a/fs/ocfs2/dlm/dlmunlock.c
+++ b/fs/ocfs2/dlm/dlmunlock.c
@@ -163,6 +163,8 @@ static enum dlm_status dlmunlock_common(struct dlm_ctxt *dlm,
 	/* By now this has been masked out of cancel requests. */
 	if (flags & LKM_VALBLK) {
 		/* make the final update to the lvb */
+		mlog_bug_on_msg(!res->lvb, "lockname: %.*s\n",
+				res->lockname.len, res->lockname.name);
 		if (master_node)
 			memcpy(res->lvb, lksb->lvb, DLM_LVB_LEN);
 		else
diff --git a/fs/ocfs2/dlmglue.c b/fs/ocfs2/dlmglue.c
index 5e02a89..089cb9b 100644
--- a/fs/ocfs2/dlmglue.c
+++ b/fs/ocfs2/dlmglue.c
@@ -1265,6 +1265,9 @@ static int ocfs2_lock_create(struct ocfs2_super *osb,
 	mlog(0, "lock %s, level = %d, flags = %u\n", lockres->l_name, level,
 	     dlm_flags);
 
+	if (lockres->l_ops->flags & LOCK_TYPE_USES_LVB)
+		dlm_flags |= DLM_LKF_VALBLK;
+
 	spin_lock_irqsave(&lockres->l_lock, flags);
 	if ((lockres->l_flags & OCFS2_LOCK_ATTACHED) ||
 	    (lockres->l_flags & OCFS2_LOCK_BUSY)) {
-- 
1.7.2.2
