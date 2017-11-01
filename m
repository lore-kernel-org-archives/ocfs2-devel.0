From: piaojun <piaojun@huawei.com>
Date: Wed, 1 Nov 2017 09:14:23 +0800
Subject: [Ocfs2-devel] [PATCH] ocfs2/dlm: wait for dlm recovery done when
 migrating all lockres
Message-ID: <59F91FEF.5020609@huawei.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

wait for dlm recovery done when migrating all lockres in case of new
lockres to be left after leaving dlm domain.

      NodeA                       NodeB                NodeC

umount and migrate
all lockres

                                 node down

do recovery for NodeB
and collect a new lockres
form other live nodes

leave domain but the
new lockres remains

                                                  mount and join domain

                                                  request for the owner
                                                  of the new lockres, but
                                                  all the other nodes said
                                                  'NO', so NodeC decide to
                                                  the owner, and send do
                                                  assert msg to other nodes.

                                                  other nodes receive the msg
                                                  and found two masters exist.
                                                  at last cause BUG in
                                                  dlm_assert_master_handler()
                                                  -->BUG();

Fixes: bc9838c4d44a ("dlm: allow dlm do recovery during shutdown")

Signed-off-by: Jun Piao <piaojun@huawei.com>
Reviewed-by: Alex Chen <alex.chen@huawei.com>
Reviewed-by: Yiwen Jiang <jiangyiwen@huawei.com>
---
 fs/ocfs2/dlm/dlmcommon.h   |  1 +
 fs/ocfs2/dlm/dlmdomain.c   | 14 ++++++++++++++
 fs/ocfs2/dlm/dlmrecovery.c | 12 +++++++++---
 3 files changed, 24 insertions(+), 3 deletions(-)

diff --git a/fs/ocfs2/dlm/dlmcommon.h b/fs/ocfs2/dlm/dlmcommon.h
index e9f3705..999ab7d 100644
--- a/fs/ocfs2/dlm/dlmcommon.h
+++ b/fs/ocfs2/dlm/dlmcommon.h
@@ -140,6 +140,7 @@ struct dlm_ctxt
 	u8 node_num;
 	u32 key;
 	u8  joining_node;
+	u8 migrate_done; /* set to 1 means node has migrated all lockres */
 	wait_queue_head_t dlm_join_events;
 	unsigned long live_nodes_map[BITS_TO_LONGS(O2NM_MAX_NODES)];
 	unsigned long domain_map[BITS_TO_LONGS(O2NM_MAX_NODES)];
diff --git a/fs/ocfs2/dlm/dlmdomain.c b/fs/ocfs2/dlm/dlmdomain.c
index e1fea14..98a8f56 100644
--- a/fs/ocfs2/dlm/dlmdomain.c
+++ b/fs/ocfs2/dlm/dlmdomain.c
@@ -461,6 +461,18 @@ static int dlm_migrate_all_locks(struct dlm_ctxt *dlm)
 		cond_resched_lock(&dlm->spinlock);
 		num += n;
 	}
+
+	if (!num) {
+		if (dlm->reco.state & DLM_RECO_STATE_ACTIVE) {
+			mlog(0, "%s: perhaps there are more lock resources need to "
+					"be migrated after dlm recovery\n", dlm->name);
+			ret = -EAGAIN;
+		} else {
+			mlog(0, "%s: we won't do dlm recovery after migrating all lockres",
+					dlm->name);
+			dlm->migrate_done = 1;
+		}
+	}
 	spin_unlock(&dlm->spinlock);
 	wake_up(&dlm->dlm_thread_wq);

@@ -2052,6 +2064,8 @@ static struct dlm_ctxt *dlm_alloc_ctxt(const char *domain,
 	dlm->joining_node = DLM_LOCK_RES_OWNER_UNKNOWN;
 	init_waitqueue_head(&dlm->dlm_join_events);

+	dlm->migrate_done = 0;
+
 	dlm->reco.new_master = O2NM_INVALID_NODE_NUM;
 	dlm->reco.dead_node = O2NM_INVALID_NODE_NUM;

diff --git a/fs/ocfs2/dlm/dlmrecovery.c b/fs/ocfs2/dlm/dlmrecovery.c
index 74407c6..3106332 100644
--- a/fs/ocfs2/dlm/dlmrecovery.c
+++ b/fs/ocfs2/dlm/dlmrecovery.c
@@ -423,12 +423,11 @@ void dlm_wait_for_recovery(struct dlm_ctxt *dlm)

 static void dlm_begin_recovery(struct dlm_ctxt *dlm)
 {
-	spin_lock(&dlm->spinlock);
+	assert_spin_locked(&dlm->spinlock);
 	BUG_ON(dlm->reco.state & DLM_RECO_STATE_ACTIVE);
 	printk(KERN_NOTICE "o2dlm: Begin recovery on domain %s for node %u\n",
 	       dlm->name, dlm->reco.dead_node);
 	dlm->reco.state |= DLM_RECO_STATE_ACTIVE;
-	spin_unlock(&dlm->spinlock);
 }

 static void dlm_end_recovery(struct dlm_ctxt *dlm)
@@ -456,6 +455,12 @@ static int dlm_do_recovery(struct dlm_ctxt *dlm)

 	spin_lock(&dlm->spinlock);

+	if (dlm->migrate_done) {
+		mlog(0, "%s: no need do recovery after migrating all lockres\n",
+				dlm->name);
+		return 0;
+	}
+
 	/* check to see if the new master has died */
 	if (dlm->reco.new_master != O2NM_INVALID_NODE_NUM &&
 	    test_bit(dlm->reco.new_master, dlm->recovery_map)) {
@@ -490,12 +495,13 @@ static int dlm_do_recovery(struct dlm_ctxt *dlm)
 	mlog(0, "%s(%d):recovery thread found node %u in the recovery map!\n",
 	     dlm->name, task_pid_nr(dlm->dlm_reco_thread_task),
 	     dlm->reco.dead_node);
-	spin_unlock(&dlm->spinlock);

 	/* take write barrier */
 	/* (stops the list reshuffling thread, proxy ast handling) */
 	dlm_begin_recovery(dlm);

+	spin_unlock(&dlm->spinlock);
+
 	if (dlm->reco.new_master == dlm->node_num)
 		goto master_here;

-- 
