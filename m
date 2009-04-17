From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Fri, 17 Apr 2009 13:37:27 -0700
Subject: [Ocfs2-devel] [PATCH 14/26] ocfs2/dlm: Clean up struct dlm_lock_name
In-Reply-To: <1240000659-6201-1-git-send-email-sunil.mushran@oracle.com>
References: <1240000659-6201-1-git-send-email-sunil.mushran@oracle.com>
Message-ID: <1240000659-6201-15-git-send-email-sunil.mushran@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Mainline commit f77a9a78c3a1d995b3bf948dbcad5c4a1b2302d5

For master mle, the name it stored in the attached lockres in struct qstr.
For block and migration mle, the name is stored inline in struct dlm_lock_name.
This patch attempts to make struct dlm_lock_name look like a struct qstr. While
we could use struct qstr, we don't because we want to avoid having to malloc
and free the lockname string as the mle's lifetime is fairly short.

Signed-off-by: Sunil Mushran <sunil.mushran@oracle.com>
Signed-off-by: Mark Fasheh <mfasheh@suse.com>
---
 fs/ocfs2/dlm/dlmcommon.h |    8 ++--
 fs/ocfs2/dlm/dlmdebug.c  |   10 +++---
 fs/ocfs2/dlm/dlmmaster.c |   79 +++++++++++++++++++++++++--------------------
 3 files changed, 53 insertions(+), 44 deletions(-)

diff --git a/fs/ocfs2/dlm/dlmcommon.h b/fs/ocfs2/dlm/dlmcommon.h
index 036b671..00c1dd1 100644
--- a/fs/ocfs2/dlm/dlmcommon.h
+++ b/fs/ocfs2/dlm/dlmcommon.h
@@ -56,8 +56,8 @@ enum dlm_mle_type {
 };
 
 struct dlm_lock_name {
-	u8 len;
-	u8 name[DLM_LOCKID_NAME_MAX];
+	unsigned int len;
+	unsigned char name[DLM_LOCKID_NAME_MAX];
 };
 
 struct dlm_master_list_entry {
@@ -79,8 +79,8 @@ struct dlm_master_list_entry {
 	struct o2hb_callback_func mle_hb_up;
 	struct o2hb_callback_func mle_hb_down;
 	union {
-		struct dlm_lock_resource *res;
-		struct dlm_lock_name name;
+		struct dlm_lock_resource *mleres;
+		struct dlm_lock_name mlename;
 	} u;
 };
 
diff --git a/fs/ocfs2/dlm/dlmdebug.c b/fs/ocfs2/dlm/dlmdebug.c
index b32f60a..c82feb7 100644
--- a/fs/ocfs2/dlm/dlmdebug.c
+++ b/fs/ocfs2/dlm/dlmdebug.c
@@ -288,15 +288,15 @@ static int dump_mle(struct dlm_master_list_entry *mle, char *buf, int len)
 {
 	int out = 0;
 	unsigned int namelen;
-	const char *name;
+	unsigned char *name;
 	char *mle_type;
 
 	if (mle->type != DLM_MLE_MASTER) {
-		namelen = mle->u.name.len;
-		name = mle->u.name.name;
+		name = mle->u.mlename.name;
+		namelen = mle->u.mlename.len;
 	} else {
-		namelen = mle->u.res->lockname.len;
-		name = mle->u.res->lockname.name;
+		name  = (unsigned char *)mle->u.mleres->lockname.name;
+		namelen = mle->u.mleres->lockname.len;
 	}
 
 	if (mle->type == DLM_MLE_BLOCK)
diff --git a/fs/ocfs2/dlm/dlmmaster.c b/fs/ocfs2/dlm/dlmmaster.c
index 0510f70..c388d21 100644
--- a/fs/ocfs2/dlm/dlmmaster.c
+++ b/fs/ocfs2/dlm/dlmmaster.c
@@ -68,27 +68,38 @@ static int dlm_do_assert_master(struct dlm_ctxt *dlm,
 				void *nodemap, u32 flags);
 static void dlm_deref_lockres_worker(struct dlm_work_item *item, void *data);
 
+static inline void __dlm_mle_name(struct dlm_master_list_entry *mle,
+				  unsigned char **name, unsigned int *namelen)
+{
+	BUG_ON(mle->type != DLM_MLE_BLOCK &&
+	       mle->type != DLM_MLE_MASTER &&
+	       mle->type != DLM_MLE_MIGRATION);
+
+	if (mle->type != DLM_MLE_MASTER) {
+		*name = mle->u.mlename.name;
+		*namelen = mle->u.mlename.len;
+	} else {
+		*name  = (unsigned char *)mle->u.mleres->lockname.name;
+		*namelen = mle->u.mleres->lockname.len;
+	}
+}
+
 static inline int dlm_mle_equal(struct dlm_ctxt *dlm,
 				struct dlm_master_list_entry *mle,
 				const char *name,
 				unsigned int namelen)
 {
-	struct dlm_lock_resource *res;
+	unsigned char *mlename;
+	unsigned int mlelen;
 
 	if (dlm != mle->dlm)
 		return 0;
 
-	if (mle->type == DLM_MLE_BLOCK ||
-	    mle->type == DLM_MLE_MIGRATION) {
-		if (namelen != mle->u.name.len ||
-    	    	    memcmp(name, mle->u.name.name, namelen)!=0)
-			return 0;
-	} else {
-		res = mle->u.res;
-		if (namelen != res->lockname.len ||
-		    memcmp(res->lockname.name, name, namelen) != 0)
-			return 0;
-	}
+	__dlm_mle_name(mle, &mlename, &mlelen);
+
+	if (namelen != mlelen || memcmp(name, mlename, namelen) != 0)
+		return 0;
+
 	return 1;
 }
 
@@ -295,17 +306,17 @@ static void dlm_init_mle(struct dlm_master_list_entry *mle,
 	mle->new_master = O2NM_MAX_NODES;
 	mle->inuse = 0;
 
+	BUG_ON(mle->type != DLM_MLE_BLOCK &&
+	       mle->type != DLM_MLE_MASTER &&
+	       mle->type != DLM_MLE_MIGRATION);
+
 	if (mle->type == DLM_MLE_MASTER) {
 		BUG_ON(!res);
-		mle->u.res = res;
-	} else if (mle->type == DLM_MLE_BLOCK) {
-		BUG_ON(!name);
-		memcpy(mle->u.name.name, name, namelen);
-		mle->u.name.len = namelen;
-	} else /* DLM_MLE_MIGRATION */ {
+		mle->u.mleres = res;
+	} else {
 		BUG_ON(!name);
-		memcpy(mle->u.name.name, name, namelen);
-		mle->u.name.len = namelen;
+		memcpy(mle->u.mlename.name, name, namelen);
+		mle->u.mlename.len = namelen;
 	}
 
 	/* copy off the node_map and register hb callbacks on our copy */
@@ -425,11 +436,11 @@ static void dlm_mle_release(struct kref *kref)
 
 	if (mle->type != DLM_MLE_MASTER) {
 		mlog(0, "calling mle_release for %.*s, type %d\n",
-		     mle->u.name.len, mle->u.name.name, mle->type);
+		     mle->u.mlename.len, mle->u.mlename.name, mle->type);
 	} else {
 		mlog(0, "calling mle_release for %.*s, type %d\n",
-		     mle->u.res->lockname.len,
-		     mle->u.res->lockname.name, mle->type);
+		     mle->u.mleres->lockname.len,
+		     mle->u.mleres->lockname.name, mle->type);
 	}
 	assert_spin_locked(&dlm->spinlock);
 	assert_spin_locked(&dlm->master_lock);
@@ -1284,7 +1295,7 @@ static int dlm_restart_lock_mastery(struct dlm_ctxt *dlm,
 						     res->lockname.len,
 						     res->lockname.name);
 						mle->type = DLM_MLE_MASTER;
-						mle->u.res = res;
+						mle->u.mleres = res;
 					}
 				}
 			}
@@ -1323,20 +1334,18 @@ static int dlm_do_master_request(struct dlm_lock_resource *res,
 	struct dlm_ctxt *dlm = mle->dlm;
 	struct dlm_master_request request;
 	int ret, response=0, resend;
+	unsigned char *mlename;
+	unsigned int mlenamelen;
 
 	memset(&request, 0, sizeof(request));
 	request.node_idx = dlm->node_num;
 
 	BUG_ON(mle->type == DLM_MLE_MIGRATION);
 
-	if (mle->type != DLM_MLE_MASTER) {
-		request.namelen = mle->u.name.len;
-		memcpy(request.name, mle->u.name.name, request.namelen);
-	} else {
-		request.namelen = mle->u.res->lockname.len;
-		memcpy(request.name, mle->u.res->lockname.name,
-			request.namelen);
-	}
+	__dlm_mle_name(mle, &mlename, &mlenamelen);
+
+	request.namelen = (u8)mlenamelen;
+	memcpy(request.name, mlename, request.namelen);
 
 again:
 	ret = o2net_send_message(DLM_MASTER_REQUEST_MSG, dlm->key, &request,
@@ -3286,9 +3295,9 @@ top:
 		     mle->master, mle->new_master);
 		/* if there is a lockres associated with this
 	 	 * mle, find it and set its owner to UNKNOWN */
-		hash = dlm_lockid_hash(mle->u.name.name, mle->u.name.len);
-		res = __dlm_lookup_lockres(dlm, mle->u.name.name,
-					   mle->u.name.len, hash);
+		hash = dlm_lockid_hash(mle->u.mlename.name, mle->u.mlename.len);
+		res = __dlm_lookup_lockres(dlm, mle->u.mlename.name,
+					   mle->u.mlename.len, hash);
 		if (res) {
 			/* unfortunately if we hit this rare case, our
 		 	 * lock ordering is messed.  we need to drop
-- 
1.5.6.3
