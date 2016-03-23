From: akpm at linux-foundation.org <akpm@linux-foundation.org>
Date: Wed, 23 Mar 2016 13:12:31 -0700
Subject: [Ocfs2-devel] [patch 17/25] ocfs2: fix occurring deadlock by
 changing ocfs2_wq from global to local
Message-ID: <56f2f8af.YI4IOv3l6WL6zRYL%akpm@linux-foundation.org>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

From: jiangyiwen <jiangyiwen@huawei.com>
Subject: ocfs2: fix occurring deadlock by changing ocfs2_wq from global to local

This patch fixes a deadlock, as follows:

  Node 1                Node 2                  Node 3
1)volume a and b are    only mount vol a        only mount vol b
  mounted

2)                      start to mount b        start to mount a

3)                      check hb of Node 3      check hb of Node 2
                        in vol a, qs_holds++    in vol b, qs_holds++

4) -------------------- all nodes' network down --------------------

5)                      progress of mount b     the same situation as
                        failed, and then call   Node 2
                        ocfs2_dismount_volume.
                        but the process is hung,
                        since there is a work
                        in ocfs2_wq cannot beo
                        completed. This work is
                        about vol a, because
                        ocfs2_wq is global wq.
                        BTW, this work which is
                        scheduled in ocfs2_wq is
                        ocfs2_orphan_scan_work,
                        and the context in this work
                        needs to take inode lock
                        of orphan_dir, because
                        lockres owner are Node 1 and
                        all nodes' nework has been down
                        at the same time, so it can't
                        get the inode lock.

6)                      Why can't this node be fenced
                        when network disconnected?
                        Because the process of
                        mount is hung what caused qs_holds
                        is not equal 0.

Because all works in the ocfs2_wq are relative to the super block.

The solution is to change the ocfs2_wq from global to local.  In other
words, move it into struct ocfs2_super.

Signed-off-by: Yiwen Jiang <jiangyiwen@huawei.com>
Reviewed-by: Joseph Qi <joseph.qi@huawei.com>
Cc: Xue jiufei <xuejiufei@huawei.com>
Cc: Mark Fasheh <mfasheh@suse.de>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Cc: Junxiao Bi <junxiao.bi@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/alloc.c        |    4 ++--
 fs/ocfs2/journal.c      |    8 ++++----
 fs/ocfs2/localalloc.c   |    4 ++--
 fs/ocfs2/ocfs2.h        |    8 ++++++++
 fs/ocfs2/quota_global.c |    2 +-
 fs/ocfs2/super.c        |   37 +++++++++++++++----------------------
 fs/ocfs2/super.h        |    2 --
 7 files changed, 32 insertions(+), 33 deletions(-)

diff -puN fs/ocfs2/alloc.c~ocfs2-avoid-occurring-deadlock-by-changing-ocfs2_wq-from-global-to-local fs/ocfs2/alloc.c
--- a/fs/ocfs2/alloc.c~ocfs2-avoid-occurring-deadlock-by-changing-ocfs2_wq-from-global-to-local
+++ a/fs/ocfs2/alloc.c
@@ -6102,7 +6102,7 @@ void ocfs2_schedule_truncate_log_flush(s
 		if (cancel)
 			cancel_delayed_work(&osb->osb_truncate_log_wq);
 
-		queue_delayed_work(ocfs2_wq, &osb->osb_truncate_log_wq,
+		queue_delayed_work(osb->ocfs2_wq, &osb->osb_truncate_log_wq,
 				   OCFS2_TRUNCATE_LOG_FLUSH_INTERVAL);
 	}
 }
@@ -6276,7 +6276,7 @@ void ocfs2_truncate_log_shutdown(struct
 
 	if (tl_inode) {
 		cancel_delayed_work(&osb->osb_truncate_log_wq);
-		flush_workqueue(ocfs2_wq);
+		flush_workqueue(osb->ocfs2_wq);
 
 		status = ocfs2_flush_truncate_log(osb);
 		if (status < 0)
diff -puN fs/ocfs2/journal.c~ocfs2-avoid-occurring-deadlock-by-changing-ocfs2_wq-from-global-to-local fs/ocfs2/journal.c
--- a/fs/ocfs2/journal.c~ocfs2-avoid-occurring-deadlock-by-changing-ocfs2_wq-from-global-to-local
+++ a/fs/ocfs2/journal.c
@@ -231,7 +231,7 @@ void ocfs2_recovery_exit(struct ocfs2_su
 	/* At this point, we know that no more recovery threads can be
 	 * launched, so wait for any recovery completion work to
 	 * complete. */
-	flush_workqueue(ocfs2_wq);
+	flush_workqueue(osb->ocfs2_wq);
 
 	/*
 	 * Now that recovery is shut down, and the osb is about to be
@@ -1326,7 +1326,7 @@ static void ocfs2_queue_recovery_complet
 
 	spin_lock(&journal->j_lock);
 	list_add_tail(&item->lri_list, &journal->j_la_cleanups);
-	queue_work(ocfs2_wq, &journal->j_recovery_work);
+	queue_work(journal->j_osb->ocfs2_wq, &journal->j_recovery_work);
 	spin_unlock(&journal->j_lock);
 }
 
@@ -1968,7 +1968,7 @@ static void ocfs2_orphan_scan_work(struc
 	mutex_lock(&os->os_lock);
 	ocfs2_queue_orphan_scan(osb);
 	if (atomic_read(&os->os_state) == ORPHAN_SCAN_ACTIVE)
-		queue_delayed_work(ocfs2_wq, &os->os_orphan_scan_work,
+		queue_delayed_work(osb->ocfs2_wq, &os->os_orphan_scan_work,
 				      ocfs2_orphan_scan_timeout());
 	mutex_unlock(&os->os_lock);
 }
@@ -2008,7 +2008,7 @@ void ocfs2_orphan_scan_start(struct ocfs
 		atomic_set(&os->os_state, ORPHAN_SCAN_INACTIVE);
 	else {
 		atomic_set(&os->os_state, ORPHAN_SCAN_ACTIVE);
-		queue_delayed_work(ocfs2_wq, &os->os_orphan_scan_work,
+		queue_delayed_work(osb->ocfs2_wq, &os->os_orphan_scan_work,
 				   ocfs2_orphan_scan_timeout());
 	}
 }
diff -puN fs/ocfs2/localalloc.c~ocfs2-avoid-occurring-deadlock-by-changing-ocfs2_wq-from-global-to-local fs/ocfs2/localalloc.c
--- a/fs/ocfs2/localalloc.c~ocfs2-avoid-occurring-deadlock-by-changing-ocfs2_wq-from-global-to-local
+++ a/fs/ocfs2/localalloc.c
@@ -386,7 +386,7 @@ void ocfs2_shutdown_local_alloc(struct o
 	struct ocfs2_dinode *alloc = NULL;
 
 	cancel_delayed_work(&osb->la_enable_wq);
-	flush_workqueue(ocfs2_wq);
+	flush_workqueue(osb->ocfs2_wq);
 
 	if (osb->local_alloc_state == OCFS2_LA_UNUSED)
 		goto out;
@@ -1085,7 +1085,7 @@ static int ocfs2_recalc_la_window(struct
 		} else {
 			osb->local_alloc_state = OCFS2_LA_DISABLED;
 		}
-		queue_delayed_work(ocfs2_wq, &osb->la_enable_wq,
+		queue_delayed_work(osb->ocfs2_wq, &osb->la_enable_wq,
 				   OCFS2_LA_ENABLE_INTERVAL);
 		goto out_unlock;
 	}
diff -puN fs/ocfs2/ocfs2.h~ocfs2-avoid-occurring-deadlock-by-changing-ocfs2_wq-from-global-to-local fs/ocfs2/ocfs2.h
--- a/fs/ocfs2/ocfs2.h~ocfs2-avoid-occurring-deadlock-by-changing-ocfs2_wq-from-global-to-local
+++ a/fs/ocfs2/ocfs2.h
@@ -464,6 +464,14 @@ struct ocfs2_super
 	struct ocfs2_refcount_tree *osb_ref_tree_lru;
 
 	struct mutex system_file_mutex;
+
+	/*
+	 * OCFS2 needs to schedule several different types of work which
+	 * require cluster locking, disk I/O, recovery waits, etc. Since these
+	 * types of work tend to be heavy we avoid using the kernel events
+	 * workqueue and schedule on our own.
+	 */
+	struct workqueue_struct *ocfs2_wq;
 };
 
 #define OCFS2_SB(sb)	    ((struct ocfs2_super *)(sb)->s_fs_info)
diff -puN fs/ocfs2/quota_global.c~ocfs2-avoid-occurring-deadlock-by-changing-ocfs2_wq-from-global-to-local fs/ocfs2/quota_global.c
--- a/fs/ocfs2/quota_global.c~ocfs2-avoid-occurring-deadlock-by-changing-ocfs2_wq-from-global-to-local
+++ a/fs/ocfs2/quota_global.c
@@ -726,7 +726,7 @@ static int ocfs2_release_dquot(struct dq
 		dqgrab(dquot);
 		/* First entry on list -> queue work */
 		if (llist_add(&OCFS2_DQUOT(dquot)->list, &osb->dquot_drop_list))
-			queue_work(ocfs2_wq, &osb->dquot_drop_work);
+			queue_work(osb->ocfs2_wq, &osb->dquot_drop_work);
 		goto out;
 	}
 	status = ocfs2_lock_global_qf(oinfo, 1);
diff -puN fs/ocfs2/super.c~ocfs2-avoid-occurring-deadlock-by-changing-ocfs2_wq-from-global-to-local fs/ocfs2/super.c
--- a/fs/ocfs2/super.c~ocfs2-avoid-occurring-deadlock-by-changing-ocfs2_wq-from-global-to-local
+++ a/fs/ocfs2/super.c
@@ -80,12 +80,6 @@ static struct kmem_cache *ocfs2_inode_ca
 struct kmem_cache *ocfs2_dquot_cachep;
 struct kmem_cache *ocfs2_qf_chunk_cachep;
 
-/* OCFS2 needs to schedule several different types of work which
- * require cluster locking, disk I/O, recovery waits, etc. Since these
- * types of work tend to be heavy we avoid using the kernel events
- * workqueue and schedule on our own. */
-struct workqueue_struct *ocfs2_wq = NULL;
-
 static struct dentry *ocfs2_debugfs_root;
 
 MODULE_AUTHOR("Oracle");
@@ -1613,33 +1607,25 @@ static int __init ocfs2_init(void)
 	if (status < 0)
 		goto out2;
 
-	ocfs2_wq = create_singlethread_workqueue("ocfs2_wq");
-	if (!ocfs2_wq) {
-		status = -ENOMEM;
-		goto out3;
-	}
-
 	ocfs2_debugfs_root = debugfs_create_dir("ocfs2", NULL);
 	if (!ocfs2_debugfs_root) {
 		status = -ENOMEM;
 		mlog(ML_ERROR, "Unable to create ocfs2 debugfs root.\n");
-		goto out4;
+		goto out3;
 	}
 
 	ocfs2_set_locking_protocol();
 
 	status = register_quota_format(&ocfs2_quota_format);
 	if (status < 0)
-		goto out4;
+		goto out3;
 	status = register_filesystem(&ocfs2_fs_type);
 	if (!status)
 		return 0;
 
 	unregister_quota_format(&ocfs2_quota_format);
-out4:
-	destroy_workqueue(ocfs2_wq);
-	debugfs_remove(ocfs2_debugfs_root);
 out3:
+	debugfs_remove(ocfs2_debugfs_root);
 	ocfs2_free_mem_caches();
 out2:
 	exit_ocfs2_uptodate_cache();
@@ -1650,11 +1636,6 @@ out1:
 
 static void __exit ocfs2_exit(void)
 {
-	if (ocfs2_wq) {
-		flush_workqueue(ocfs2_wq);
-		destroy_workqueue(ocfs2_wq);
-	}
-
 	unregister_quota_format(&ocfs2_quota_format);
 
 	debugfs_remove(ocfs2_debugfs_root);
@@ -2349,6 +2330,12 @@ static int ocfs2_initialize_super(struct
 	}
 	cleancache_init_shared_fs(sb);
 
+	osb->ocfs2_wq = create_singlethread_workqueue("ocfs2_wq");
+	if (!osb->ocfs2_wq) {
+		status = -ENOMEM;
+		mlog_errno(status);
+	}
+
 bail:
 	return status;
 }
@@ -2536,6 +2523,12 @@ static void ocfs2_delete_osb(struct ocfs
 {
 	/* This function assumes that the caller has the main osb resource */
 
+	/* ocfs2_initializer_super have already created this workqueue */
+	if (osb->ocfs2_wq) {
+		flush_workqueue(osb->ocfs2_wq);
+		destroy_workqueue(osb->ocfs2_wq);
+	}
+
 	ocfs2_free_slot_info(osb);
 
 	kfree(osb->osb_orphan_wipes);
diff -puN fs/ocfs2/super.h~ocfs2-avoid-occurring-deadlock-by-changing-ocfs2_wq-from-global-to-local fs/ocfs2/super.h
--- a/fs/ocfs2/super.h~ocfs2-avoid-occurring-deadlock-by-changing-ocfs2_wq-from-global-to-local
+++ a/fs/ocfs2/super.h
@@ -26,8 +26,6 @@
 #ifndef OCFS2_SUPER_H
 #define OCFS2_SUPER_H
 
-extern struct workqueue_struct *ocfs2_wq;
-
 int ocfs2_publish_get_mount_state(struct ocfs2_super *osb,
 				  int node_num);
 
_
