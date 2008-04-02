From: Mark Fasheh <mfasheh@suse.com>
Date: Wed,  2 Apr 2008 13:14:58 -0700
Subject: [Ocfs2-devel] [PATCH 48/62] ocfs2/dlm: Cleanup lockres print
In-Reply-To: <12071674171596-git-send-email-mfasheh@suse.com>
References: <12071673121124-git-send-email-mfasheh@suse.com>
	<1207167318479-git-send-email-mfasheh@suse.com>
	<12071673203909-git-send-email-mfasheh@suse.com>
	<12071673232465-git-send-email-mfasheh@suse.com>
	<12071673263948-git-send-email-mfasheh@suse.com>
	<12071673282579-git-send-email-mfasheh@suse.com>
	<1207167330482-git-send-email-mfasheh@suse.com>
	<12071673321172-git-send-email-mfasheh@suse.com>
	<12071673341888-git-send-email-mfasheh@suse.com>
	<12071673362069-git-send-email-mfasheh@suse.com>
	<12071673391031-git-send-email-mfasheh@suse.com>
	<12071673413492-git-send-email-mfasheh@suse.com>
	<1207167343926-git-send-email-mfasheh@suse.com>
	<12071673461268-git-send-email-mfasheh@suse.com>
	<12071673481928-git-send-email-mfasheh@suse.com>
	<12071673492775-git-send-email-mfasheh@suse.com>
	<12071673511262-git-send-email-mfasheh@suse.com>
	<12071673543752-git-send-email-mfasheh@suse.com>
	<1207167355295-git-send-email-mfasheh@suse.com>
	<12071673571757-git-send-email-mfasheh@suse.com>
	<12071673591158-git-send-email-mfasheh@suse.com>
	<12071673613757-git-send-email-mfasheh@suse.com>
	<1207167363119-git-send-email-mfasheh@suse.com>
	<12071673661674-git-send-email-mfasheh@suse.com>
	<12071673681650-git-send-email-mfasheh@suse.com>
	<12071673701937-git-send-email-mfasheh@suse.com>
	<12071673722691-git-send-email-mfasheh@suse.com>
	<12071673731276-git-send-email-mfasheh@suse.com>
	<12071673753788-git-send-email-mfasheh@suse.com>
	<12071673772233-git-send-email-mfasheh@suse.com>
	<1207167379283-git-send-email-mfasheh@suse.com>
	<12071673821008-git-send-email-mfasheh@suse.com>
	<12071673843208-git-send-email-mfasheh@suse.com>
	<12071673872568-git-send-email-mfasheh@suse.com>
	<12071673882492-git-send-email-mfasheh@suse.com>
	<1207167390414-git-send-email-mfasheh@suse.com>
	<1207167392537-git-send-email-mfasheh@suse.com>
	<12071673941659-git-send-email-mfasheh@suse.com>
	<12071673964014-git-send-email-mfasheh@suse.com>
	<1207167398684-git-send-email-mfasheh@suse.com>
	<12071674013954-git-send-email-mfasheh@suse.com>
	<12071674033903-git-send-email-mfasheh@suse.com>
	<12071674061934-git-send-email-mfasheh@suse.com>
	<12071674083120-git-send-email-mfasheh@suse.com>
	<12071674103432-git-send-email-mfasheh@suse.com>
	<1207167413855-git-send-email-mfasheh@suse.com>
	<12071674151752-git-send-email-mfasheh@suse.com>
	<12071674171596-git-send-email-mfasheh@suse.com>
Message-ID: <12071674193441-git-send-email-mfasheh@suse.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-kernel@vger.kernel.org
Cc: ocfs2-devel@oss.oracle.com, Joel Becker <joel.becker@oracle.com>, Sunil Mushran <sunil.mushran@oracle.com>

From: Sunil Mushran <sunil.mushran@oracle.com>

A previous patch added KERN_NOTICE to printks printing the lockres that
cluttered the output. This patch removes the log level. For people concerned
with syslog clutter, please note we now use this facility to print lockres
only during an error.

Signed-off-by: Sunil Mushran <sunil.mushran@oracle.com>
Signed-off-by: Mark Fasheh <mfasheh@suse.com>
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
1.5.4.1
