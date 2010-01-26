From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Mon, 25 Jan 2010 16:57:40 -0800
Subject: [Ocfs2-devel] [PATCH 3/4] ocfs2/dlm: Print more messages during
	lock migration
In-Reply-To: <1264467461-1881-1-git-send-email-sunil.mushran@oracle.com>
References: <1264467461-1881-1-git-send-email-sunil.mushran@oracle.com>
Message-ID: <1264467461-1881-3-git-send-email-sunil.mushran@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

When a lock resource is migrated, the dlm compares the migrated
locks with that that was already existing on the new node. If the
comparison fails, it BUGs. This patch prints more messages when the
comparison fails inorder to help with the root cause analyis.

http://oss.oracle.com/bugzilla/show_bug.cgi?id=1206
This does not fix bz1206. However, if we run into it again, we will
have more information to chew on.

Signed-off-by: Sunil Mushran <sunil.mushran@oracle.com>
---
 fs/ocfs2/dlm/dlmrecovery.c |   46 ++++++++++++++++++++++++++++++++++++-------
 1 files changed, 38 insertions(+), 8 deletions(-)

diff --git a/fs/ocfs2/dlm/dlmrecovery.c b/fs/ocfs2/dlm/dlmrecovery.c
index 9d67894..cfb2ae9 100644
--- a/fs/ocfs2/dlm/dlmrecovery.c
+++ b/fs/ocfs2/dlm/dlmrecovery.c
@@ -1750,6 +1750,7 @@ static int dlm_process_recovery_data(struct dlm_ctxt *dlm,
 	struct dlm_lock *lock = NULL;
 	u8 from = O2NM_MAX_NODES;
 	unsigned int added = 0;
+	__be64 c;
 
 	mlog(0, "running %d locks for this lockres\n", mres->num_locks);
 	for (i=0; i<mres->num_locks; i++) {
@@ -1797,19 +1798,48 @@ static int dlm_process_recovery_data(struct dlm_ctxt *dlm,
 			/* lock is always created locally first, and
 			 * destroyed locally last.  it must be on the list */
 			if (!lock) {
-				__be64 c = ml->cookie;
-				mlog(ML_ERROR, "could not find local lock "
-					       "with cookie %u:%llu!\n",
+				c = ml->cookie;
+				mlog(ML_ERROR, "Could not find local lock "
+					       "with cookie %u:%llu, node %u, "
+					       "list %u, flags 0x%x, type %d, "
+					       "conv %d, highest blocked %d\n",
 				     dlm_get_lock_cookie_node(be64_to_cpu(c)),
-				     dlm_get_lock_cookie_seq(be64_to_cpu(c)));
+				     dlm_get_lock_cookie_seq(be64_to_cpu(c)),
+				     ml->node, ml->list, ml->flags, ml->type,
+				     ml->convert_type, ml->highest_blocked);
+				__dlm_print_one_lock_resource(res);
+				BUG();
+			}
+
+			if (lock->ml.node != ml->node) {
+				c = lock->ml.cookie;
+				mlog(ML_ERROR, "Mismatched node# in lock "
+				     "cookie %u:%llu, name %.*s, node %u\n",
+				     dlm_get_lock_cookie_node(be64_to_cpu(c)),
+				     dlm_get_lock_cookie_seq(be64_to_cpu(c)),
+				     res->lockname.len, res->lockname.name,
+				     lock->ml.node);
+				c = ml->cookie;
+				mlog(ML_ERROR, "Migrate lock cookie %u:%llu, "
+				     "node %u, list %u, flags 0x%x, type %d, "
+				     "conv %d, highest blocked %d\n",
+				     dlm_get_lock_cookie_node(be64_to_cpu(c)),
+				     dlm_get_lock_cookie_seq(be64_to_cpu(c)),
+				     ml->node, ml->list, ml->flags, ml->type,
+				     ml->convert_type, ml->highest_blocked);
 				__dlm_print_one_lock_resource(res);
 				BUG();
 			}
-			BUG_ON(lock->ml.node != ml->node);
 
 			if (tmpq != queue) {
-				mlog(0, "lock was on %u instead of %u for %.*s\n",
-				     j, ml->list, res->lockname.len, res->lockname.name);
+				c = ml->cookie;
+				mlog(0, "Lock cookie %u:%llu was on list %u "
+				     "instead of list %u for %.*s\n",
+				     dlm_get_lock_cookie_node(be64_to_cpu(c)),
+				     dlm_get_lock_cookie_seq(be64_to_cpu(c)),
+				     j, ml->list, res->lockname.len,
+				     res->lockname.name);
+				__dlm_print_one_lock_resource(res);
 				spin_unlock(&res->spinlock);
 				continue;
 			}
@@ -1906,7 +1936,7 @@ skip_lvb:
 		spin_lock(&res->spinlock);
 		list_for_each_entry(lock, queue, list) {
 			if (lock->ml.cookie == ml->cookie) {
-				__be64 c = lock->ml.cookie;
+				c = lock->ml.cookie;
 				mlog(ML_ERROR, "%s:%.*s: %u:%llu: lock already "
 				     "exists on this lockres!\n", dlm->name,
 				     res->lockname.len, res->lockname.name,
-- 
1.5.6.5
