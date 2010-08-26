From: Wengang Wang <wen.gang.wang@oracle.com>
Date: Thu, 26 Aug 2010 21:06:55 +0800
Subject: [Ocfs2-devel] [PATCH 1/5] ocfs2/dlm: dynamically allocate lvb for
	dlm_lock_resource
Message-ID: <201008261310.o7PGMqsi009165@acsinet15.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

This patch tries to dynamically allocate lvb for dlm_lock_resource which needs to access lvb.

Without the patch applied,
[wwg at cool linux-2.6]$ egrep "o2dlm_lockres" /proc/slabinfo
o2dlm_lockres         42     42    256   32    2 : tunables    0    0    0 : slabdata      2      2      0

After patch applied,
[wwg at cool linux-2.6]$ egrep "o2dlm_lockres" /proc/slabinfo
o2dlm_lockres         42     42    192   21    1 : tunables    0    0    0 : slabdata      2      2      0

#the result is taken on i686

Signed-off-by: Wengang Wang <wen.gang.wang@oracle.com>
---
 fs/ocfs2/dlm/dlmast.c    |    2 ++
 fs/ocfs2/dlm/dlmcommon.h |    3 ++-
 fs/ocfs2/dlm/dlmdebug.c  |    6 ++++--
 fs/ocfs2/dlm/dlmlock.c   |    6 ++++++
 fs/ocfs2/dlm/dlmmaster.c |   31 ++++++++++++++++++++++++++++---
 5 files changed, 42 insertions(+), 6 deletions(-)

diff --git a/fs/ocfs2/dlm/dlmast.c b/fs/ocfs2/dlm/dlmast.c
index f449991..fe272b1 100644
--- a/fs/ocfs2/dlm/dlmast.c
+++ b/fs/ocfs2/dlm/dlmast.c
@@ -191,6 +191,8 @@ static void dlm_update_lvb(struct dlm_ctxt *dlm, struct dlm_lock_resource *res,
 			mlog(0, "getting lvb from lockres for %s node\n",
 				  lock->ml.node == dlm->node_num ? "master" :
 				  "remote");
+			mlog_bug_on_msg(!res->lvb, "lockname : %.*s\n",
+					res->lockname.len, res->lockname.name);
 			memcpy(lksb->lvb, res->lvb, DLM_LVB_LEN);
 		}
 		/* Do nothing for lvb put requests - they should be done in
diff --git a/fs/ocfs2/dlm/dlmcommon.h b/fs/ocfs2/dlm/dlmcommon.h
index 4b6ae2c..49e6492 100644
--- a/fs/ocfs2/dlm/dlmcommon.h
+++ b/fs/ocfs2/dlm/dlmcommon.h
@@ -329,7 +329,7 @@ struct dlm_lock_resource
 	wait_queue_head_t wq;
 	u8  owner;              //node which owns the lock resource, or unknown
 	u16 state;
-	char lvb[DLM_LVB_LEN];
+	char *lvb;
 	unsigned int inflight_locks;
 	unsigned long refmap[BITS_TO_LONGS(O2NM_MAX_NODES)];
 };
@@ -1033,6 +1033,7 @@ void dlm_clean_master_list(struct dlm_ctxt *dlm,
 int dlm_lock_basts_flushed(struct dlm_ctxt *dlm, struct dlm_lock *lock);
 int __dlm_lockres_has_locks(struct dlm_lock_resource *res);
 int __dlm_lockres_unused(struct dlm_lock_resource *res);
+char *dlm_alloc_lvb(char **lvb);
 
 static inline const char * dlm_lock_mode_name(int mode)
 {
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
diff --git a/fs/ocfs2/dlm/dlmlock.c b/fs/ocfs2/dlm/dlmlock.c
index 69cf369..5c7ece7 100644
--- a/fs/ocfs2/dlm/dlmlock.c
+++ b/fs/ocfs2/dlm/dlmlock.c
@@ -425,6 +425,12 @@ static void dlm_init_lock(struct dlm_lock *newlock, int type,
 	kref_init(&newlock->lock_refs);
 }
 
+char *dlm_alloc_lvb(char **lvb)
+{
+	*lvb = kzalloc(DLM_LVB_LEN, GFP_NOFS);
+	return *lvb;
+}
+
 struct dlm_lock * dlm_new_lock(int type, u8 node, u64 cookie,
 			       struct dlm_lockstatus *lksb)
 {
diff --git a/fs/ocfs2/dlm/dlmmaster.c b/fs/ocfs2/dlm/dlmmaster.c
index ffb4c68..77315a4 100644
--- a/fs/ocfs2/dlm/dlmmaster.c
+++ b/fs/ocfs2/dlm/dlmmaster.c
@@ -545,6 +545,7 @@ static void dlm_lockres_release(struct kref *kref)
 
 	kmem_cache_free(dlm_lockname_cache, (void *)res->lockname.name);
 
+	kfree(res->lvb);
 	kmem_cache_free(dlm_lockres_cache, res);
 }
 
@@ -553,7 +554,20 @@ void dlm_lockres_put(struct dlm_lock_resource *res)
 	kref_put(&res->refs, dlm_lockres_release);
 }
 
-static void dlm_init_lockres(struct dlm_ctxt *dlm,
+static int dlm_lockres_uses_lvb(struct dlm_lock_resource *res)
+{
+	switch (res->lockname.name[0]) {
+	case 'M':
+	case 'Q':
+	case 'R':
+	case 'P':
+		return 1;
+	default:
+		return 0;
+	}
+}
+
+static int dlm_init_lockres(struct dlm_ctxt *dlm,
 			     struct dlm_lock_resource *res,
 			     const char *name, unsigned int namelen)
 {
@@ -603,8 +617,16 @@ static void dlm_init_lockres(struct dlm_ctxt *dlm,
 	list_add_tail(&res->tracking, &dlm->tracking_list);
 	spin_unlock(&dlm->spinlock);
 
-	memset(res->lvb, 0, DLM_LVB_LEN);
+	if (dlm_lockres_uses_lvb(res)) {
+		if (!dlm_alloc_lvb(&res->lvb)) {
+			mlog(ML_ERROR, "no memory for lvb\n");
+			return -ENOMEM;
+		}
+	} else {
+		res->lvb = NULL;
+	}
 	memset(res->refmap, 0, sizeof(res->refmap));
+	return 0;
 }
 
 struct dlm_lock_resource *dlm_new_lockres(struct dlm_ctxt *dlm,
@@ -612,6 +634,7 @@ struct dlm_lock_resource *dlm_new_lockres(struct dlm_ctxt *dlm,
 				   unsigned int namelen)
 {
 	struct dlm_lock_resource *res = NULL;
+	int ret;
 
 	res = kmem_cache_zalloc(dlm_lockres_cache, GFP_NOFS);
 	if (!res)
@@ -621,7 +644,9 @@ struct dlm_lock_resource *dlm_new_lockres(struct dlm_ctxt *dlm,
 	if (!res->lockname.name)
 		goto error;
 
-	dlm_init_lockres(dlm, res, name, namelen);
+	ret = dlm_init_lockres(dlm, res, name, namelen);
+	if (ret) 
+		goto error;
 	return res;
 
 error:
-- 
1.7.2.1
