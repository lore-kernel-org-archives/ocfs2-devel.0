From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Mon Feb 25 12:21:24 2008
Subject: [Ocfs2-devel] [PATCH 17/18] ocfs2_dlm: Fix lockname in lockres
	print function
In-Reply-To: <1203970862-8790-1-git-send-email-sunil.mushran@oracle.com>
References: <1203970862-8790-1-git-send-email-sunil.mushran@oracle.com>
Message-ID: <1203970862-8790-18-git-send-email-sunil.mushran@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

__dlm_print_one_lock_resource was printing lockname incorrectly.
This patch fixes that among other small printk cleanups.

Signed-off-by: Sunil Mushran <sunil.mushran@oracle.com>
---
 fs/ocfs2/dlm/dlmdebug.c |   26 ++++++++++++++++++--------
 1 files changed, 18 insertions(+), 8 deletions(-)

diff --git a/fs/ocfs2/dlm/dlmdebug.c b/fs/ocfs2/dlm/dlmdebug.c
index 2a1c27c..3e16e91 100644
--- a/fs/ocfs2/dlm/dlmdebug.c
+++ b/fs/ocfs2/dlm/dlmdebug.c
@@ -47,6 +47,7 @@
 static struct dentry *dlm_debugfs_root = NULL;
 
 int dump_mle(struct dlm_master_list_entry *mle, char *buf, int len);
+int stringify_lockname(const char *lockname, int locklen, char *buf, int len);
 
 static void dlm_print_lockres_refmap(struct dlm_lock_resource *res)
 {
@@ -76,14 +77,23 @@ void __dlm_print_one_lock_resource(struct dlm_lock_resource *res)
 {
 	struct list_head *iter2;
 	struct dlm_lock *lock;
+	char buf[DLM_LOCKID_NAME_MAX];
 
 	assert_spin_locked(&res->spinlock);
 
-	mlog(ML_NOTICE, "lockres: %.*s, owner=%u, state=%u\n",
-	       res->lockname.len, res->lockname.name,
-	       res->owner, res->state);
-	mlog(ML_NOTICE, "  last used: %lu, on purge list: %s\n",
-	     res->last_used, list_empty(&res->purge) ? "no" : "yes");
+	stringify_lockname(res->lockname.name, res->lockname.len,
+			   buf, sizeof(buf) - 1);
+	mlog(ML_NOTICE, "lockres: %s, owner=%u, state=%u\n", buf, res->owner,
+	     res->state);
+	mlog(ML_NOTICE, "  last used: %lu, refcnt: %u, on purge list: %s\n",
+	     res->last_used, atomic_read(&res->refs.refcount),
+	     list_empty(&res->purge) ? "no" : "yes");
+	mlog(ML_NOTICE, "  on dirty list: %s, on reco list: %s, migrating pending: %s\n",
+	     list_empty(&res->dirty) ? "no" : "yes",
+	     list_empty(&res->recovering) ? "no" : "yes",
+	     res->migration_pending ? "yes" : "no");
+	mlog(ML_NOTICE, "  inflight locks: %d, asts reserved: %d\n",
+	     res->inflight_locks, atomic_read(&res->asts_reserved));
 	dlm_print_lockres_refmap(res);
 	mlog(ML_NOTICE, "  granted queue: \n");
 	list_for_each(iter2, &res->granted) {
@@ -105,10 +115,11 @@ void __dlm_print_one_lock_resource(struct dlm_lock_resource *res)
 		lock = list_entry(iter2, struct dlm_lock, list);
 		spin_lock(&lock->spinlock);
 		mlog(ML_NOTICE, "    type=%d, conv=%d, node=%u, "
-		       "cookie=%u:%llu, ast=(empty=%c,pend=%c), bast=(empty=%c,pend=%c)\n",
+		       "cookie=%u:%llu, ref=%u, ast=(empty=%c,pend=%c), bast=(empty=%c,pend=%c)\n",
 		       lock->ml.type, lock->ml.convert_type, lock->ml.node,
 		       dlm_get_lock_cookie_node(be64_to_cpu(lock->ml.cookie)),
 		       dlm_get_lock_cookie_seq(be64_to_cpu(lock->ml.cookie)),
+		       atomic_read(&lock->lock_refs.refcount),
 		       list_empty(&lock->ast_list) ? 'y' : 'n',
 		       lock->ast_pending ? 'y' : 'n',
 		       list_empty(&lock->bast_list) ? 'y' : 'n',
@@ -268,8 +279,7 @@ EXPORT_SYMBOL_GPL(dlm_errname);
  *
  * For more on lockname formats, please refer to dlmglue.c and ocfs2_lockid.h.
  */
-static int stringify_lockname(const char *lockname, int locklen,
-			      char *buf, int len)
+int stringify_lockname(const char *lockname, int locklen, char *buf, int len)
 {
 	int out = 0;
 	__be64 inode_blkno_be;
-- 
1.5.2.5
