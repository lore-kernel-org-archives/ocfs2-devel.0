From: piaojun <piaojun@huawei.com>
Date: Fri, 13 Oct 2017 11:04:05 +0800
Subject: [Ocfs2-devel] [PATCH] ocfs2: no need flush workqueue before
	destroying it
Message-ID: <59E02D25.7010307@huawei.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

1. delete redundant flush_workqueue();
2. delete some unused func declaration and assignment.

Signed-off-by: Jun Piao <piaojun@huawei.com>
---
 fs/ocfs2/alloc.c             | 2 --
 fs/ocfs2/cluster/heartbeat.h | 2 --
 fs/ocfs2/dlm/dlmdomain.c     | 1 -
 fs/ocfs2/dlmfs/dlmfs.c       | 1 -
 fs/ocfs2/super.c             | 4 +---
 5 files changed, 1 insertion(+), 9 deletions(-)

diff --git a/fs/ocfs2/alloc.c b/fs/ocfs2/alloc.c
index a177eae..31a416d 100644
--- a/fs/ocfs2/alloc.c
+++ b/fs/ocfs2/alloc.c
@@ -3585,8 +3585,6 @@ static int ocfs2_merge_rec_left(struct ocfs2_path *right_path,
 		 * The easy case - we can just plop the record right in.
 		 */
 		*left_rec = *split_rec;
-
-		has_empty_extent = 0;
 	} else
 		le16_add_cpu(&left_rec->e_leaf_clusters, split_clusters);

diff --git a/fs/ocfs2/cluster/heartbeat.h b/fs/ocfs2/cluster/heartbeat.h
index 3ef5137..a9e67ef 100644
--- a/fs/ocfs2/cluster/heartbeat.h
+++ b/fs/ocfs2/cluster/heartbeat.h
@@ -79,10 +79,8 @@ void o2hb_fill_node_map(unsigned long *map,
 			unsigned bytes);
 void o2hb_exit(void);
 int o2hb_init(void);
-int o2hb_check_node_heartbeating(u8 node_num);
 int o2hb_check_node_heartbeating_no_sem(u8 node_num);
 int o2hb_check_node_heartbeating_from_callback(u8 node_num);
-int o2hb_check_local_node_heartbeating(void);
 void o2hb_stop_all_regions(void);
 int o2hb_get_all_regions(char *region_uuids, u8 numregions);
 int o2hb_global_heartbeat_active(void);
diff --git a/fs/ocfs2/dlm/dlmdomain.c b/fs/ocfs2/dlm/dlmdomain.c
index a2b19fb..e1fea14 100644
--- a/fs/ocfs2/dlm/dlmdomain.c
+++ b/fs/ocfs2/dlm/dlmdomain.c
@@ -394,7 +394,6 @@ int dlm_domain_fully_joined(struct dlm_ctxt *dlm)
 static void dlm_destroy_dlm_worker(struct dlm_ctxt *dlm)
 {
 	if (dlm->dlm_worker) {
-		flush_workqueue(dlm->dlm_worker);
 		destroy_workqueue(dlm->dlm_worker);
 		dlm->dlm_worker = NULL;
 	}
diff --git a/fs/ocfs2/dlmfs/dlmfs.c b/fs/ocfs2/dlmfs/dlmfs.c
index 9ab9e18..edce7b5 100644
--- a/fs/ocfs2/dlmfs/dlmfs.c
+++ b/fs/ocfs2/dlmfs/dlmfs.c
@@ -670,7 +670,6 @@ static void __exit exit_dlmfs_fs(void)
 {
 	unregister_filesystem(&dlmfs_fs_type);

-	flush_workqueue(user_dlm_worker);
 	destroy_workqueue(user_dlm_worker);

 	/*
diff --git a/fs/ocfs2/super.c b/fs/ocfs2/super.c
index 8073349..040bbb6 100644
--- a/fs/ocfs2/super.c
+++ b/fs/ocfs2/super.c
@@ -2521,10 +2521,8 @@ static void ocfs2_delete_osb(struct ocfs2_super *osb)
 	/* This function assumes that the caller has the main osb resource */

 	/* ocfs2_initializer_super have already created this workqueue */
-	if (osb->ocfs2_wq) {
-		flush_workqueue(osb->ocfs2_wq);
+	if (osb->ocfs2_wq)
 		destroy_workqueue(osb->ocfs2_wq);
-	}

 	ocfs2_free_slot_info(osb);

-- 
