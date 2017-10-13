From: piaojun <piaojun@huawei.com>
Date: Fri, 13 Oct 2017 15:00:06 +0800
Subject: [Ocfs2-devel] [PATCH 1/2] ocfs2: no need flush workqueue before
	destroying it
Message-ID: <59E06476.3090502@huawei.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

destroy_workqueue() will do flushing work for us.

Signed-off-by: Jun Piao <piaojun@huawei.com>
---
 fs/ocfs2/dlm/dlmdomain.c | 1 -
 fs/ocfs2/dlmfs/dlmfs.c   | 1 -
 fs/ocfs2/super.c         | 4 +---
 3 files changed, 1 insertion(+), 5 deletions(-)

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
