From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Fri Mar 14 11:18:36 2008
Subject: [Ocfs2-devel] [PATCH 1/1] ocfs2/dlm: Cleanup lockres print
Message-ID: <1205518704-1196-1-git-send-email-sunil.mushran@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

A previous patch added KERN_NOTICE to printks printing the lockres that
cluttered the output. This patch removes the log level. For people concerned
with syslog clutter, please note we now use this facility to print lockres
only during an error.

Signed-off-by: Sunil Mushran <sunil.mushran@oracle.com>
---
 fs/ocfs2/dlm/dlmdebug.c |   22 +++++++++++-----------
 1 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/fs/ocfs2/dlm/dlmdebug.c b/fs/ocfs2/dlm/dlmdebug.c
index 53a9e60..5f6d858 100644
--- a/fs/ocfs2/dlm/dlmdebug.c
+++ b/fs/ocfs2/dlm/dlmdebug.c
@@ -58,23 +58,23 @@ static void dlm_print_lockres_refmap(struct dlm_lock_resource *res)
 	int bit;
 	assert_spin_locked(&res->spinlock);
 
-	printk(KERN_NOTICE "  refmap nodes: [ ");
+	printk("  refmap nodes: [ ");
 	bit = 0;
 	while (1) {
 		bit = find_next_bit(res->refmap, O2NM_MAX_NODES, bit);
 		if (bit >= O2NM_MAX_NODES)
 			break;
-		printk(KERN_NOTICE "%u ", bit);
+		printk("%u ", bit);
 		bit++;
 	}
-	printk(KERN_NOTICE "], inflight=%u\n", res->inflight_locks);
+	printk("], inflight=%u\n", res->inflight_locks);
 }
 
 static void __dlm_print_lock(struct dlm_lock *lock)
 {
 	spin_lock(&lock->spinlock);
 
-	printk(KERN_NOTICE "    type=%d, conv=%d, node=%u, cookie=%u:%llu, "
+	printk("    type=%d, conv=%d, node=%u, cookie=%u:%llu, "
 	       "ref=%u, ast=(empty=%c,pend=%c), bast=(empty=%c,pend=%c), "
 	       "pending=(conv=%c,lock=%c,cancel=%c,unlock=%c)\n",
 	       lock->ml.type, lock->ml.convert_type, lock->ml.node,
@@ -103,30 +103,30 @@ void __dlm_print_one_lock_resource(struct dlm_lock_resource *res)
 
 	stringify_lockname(res->lockname.name, res->lockname.len,
 			   buf, sizeof(buf) - 1);
-	printk(KERN_NOTICE "lockres: %s, owner=%u, state=%u\n",
+	printk("lockres: %s, owner=%u, state=%u\n",
 	       buf, res->owner, res->state);
-	printk(KERN_NOTICE "  last used: %lu, refcnt: %u, on purge list: %s\n",
+	printk("  last used: %lu, refcnt: %u, on purge list: %s\n",
 	       res->last_used, atomic_read(&res->refs.refcount),
 	       list_empty(&res->purge) ? "no" : "yes");
-	printk(KERN_NOTICE "  on dirty list: %s, on reco list: %s, "
+	printk("  on dirty list: %s, on reco list: %s, "
 	       "migrating pending: %s\n",
 	       list_empty(&res->dirty) ? "no" : "yes",
 	       list_empty(&res->recovering) ? "no" : "yes",
 	       res->migration_pending ? "yes" : "no");
-	printk(KERN_NOTICE "  inflight locks: %d, asts reserved: %d\n",
+	printk("  inflight locks: %d, asts reserved: %d\n",
 	       res->inflight_locks, atomic_read(&res->asts_reserved));
 	dlm_print_lockres_refmap(res);
-	printk(KERN_NOTICE "  granted queue:\n");
+	printk("  granted queue:\n");
 	list_for_each(iter2, &res->granted) {
 		lock = list_entry(iter2, struct dlm_lock, list);
 		__dlm_print_lock(lock);
 	}
-	printk(KERN_NOTICE "  converting queue:\n");
+	printk("  converting queue:\n");
 	list_for_each(iter2, &res->converting) {
 		lock = list_entry(iter2, struct dlm_lock, list);
 		__dlm_print_lock(lock);
 	}
-	printk(KERN_NOTICE "  blocked queue:\n");
+	printk("  blocked queue:\n");
 	list_for_each(iter2, &res->blocked) {
 		lock = list_entry(iter2, struct dlm_lock, list);
 		__dlm_print_lock(lock);
-- 
1.5.3.6
