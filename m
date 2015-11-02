From: Joseph Qi <joseph.qi@huawei.com>
Date: Mon, 2 Nov 2015 08:55:51 +0800
Subject: [Ocfs2-devel] [PATCH v2 RESEND] ocfs2: add uuid to ocfs2 thread
 name for problem analysis
Message-ID: <5636B497.1080705@huawei.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

A node can mount multiple ocfs2 volumes. And if thread names are same
for each volume/domain, it will bring inconvenience when analyzing
problems because we have to identify which volume/domain the messages
belong to.
Since thread name will be printed to messages, so add volume uuid or dlm
name to thread name can benefit problem analysis.

Signed-off-by: Joseph Qi <joseph.qi@huawei.com>
---
 fs/ocfs2/dlm/dlmdomain.c   | 4 +++-
 fs/ocfs2/dlm/dlmrecovery.c | 2 +-
 fs/ocfs2/dlm/dlmthread.c   | 3 ++-
 fs/ocfs2/dlmglue.c         | 3 ++-
 fs/ocfs2/journal.c         | 4 ++--
 5 files changed, 10 insertions(+), 6 deletions(-)

diff --git a/fs/ocfs2/dlm/dlmdomain.c b/fs/ocfs2/dlm/dlmdomain.c
index 7df88a6..cc794b5 100644
--- a/fs/ocfs2/dlm/dlmdomain.c
+++ b/fs/ocfs2/dlm/dlmdomain.c
@@ -1860,6 +1860,7 @@ static int dlm_join_domain(struct dlm_ctxt *dlm)
 	int status;
 	unsigned int backoff;
 	unsigned int total_backoff = 0;
+	char wq_name[O2NM_MAX_NAME_LEN];

 	BUG_ON(!dlm);

@@ -1889,7 +1890,8 @@ static int dlm_join_domain(struct dlm_ctxt *dlm)
 		goto bail;
 	}

-	dlm->dlm_worker = create_singlethread_workqueue("dlm_wq");
+	snprintf(wq_name, O2NM_MAX_NAME_LEN, "dlm_wq-%s", dlm->name);
+	dlm->dlm_worker = create_singlethread_workqueue(wq_name);
 	if (!dlm->dlm_worker) {
 		status = -ENOMEM;
 		mlog_errno(status);
diff --git a/fs/ocfs2/dlm/dlmrecovery.c b/fs/ocfs2/dlm/dlmrecovery.c
index a43f9ef..8caf881 100644
--- a/fs/ocfs2/dlm/dlmrecovery.c
+++ b/fs/ocfs2/dlm/dlmrecovery.c
@@ -205,7 +205,7 @@ int dlm_launch_recovery_thread(struct dlm_ctxt *dlm)
 	mlog(0, "starting dlm recovery thread...\n");

 	dlm->dlm_reco_thread_task = kthread_run(dlm_recovery_thread, dlm,
-						"dlm_reco_thread");
+			"dlm_reco-%s", dlm->name);
 	if (IS_ERR(dlm->dlm_reco_thread_task)) {
 		mlog_errno(PTR_ERR(dlm->dlm_reco_thread_task));
 		dlm->dlm_reco_thread_task = NULL;
diff --git a/fs/ocfs2/dlm/dlmthread.c b/fs/ocfs2/dlm/dlmthread.c
index 69aac6f..a1b6c34 100644
--- a/fs/ocfs2/dlm/dlmthread.c
+++ b/fs/ocfs2/dlm/dlmthread.c
@@ -483,7 +483,8 @@ int dlm_launch_thread(struct dlm_ctxt *dlm)
 {
 	mlog(0, "Starting dlm_thread...\n");

-	dlm->dlm_thread_task = kthread_run(dlm_thread, dlm, "dlm_thread");
+	dlm->dlm_thread_task = kthread_run(dlm_thread, dlm, "dlm-%s",
+			dlm->name);
 	if (IS_ERR(dlm->dlm_thread_task)) {
 		mlog_errno(PTR_ERR(dlm->dlm_thread_task));
 		dlm->dlm_thread_task = NULL;
diff --git a/fs/ocfs2/dlmglue.c b/fs/ocfs2/dlmglue.c
index 23157e4..fd4f536 100644
--- a/fs/ocfs2/dlmglue.c
+++ b/fs/ocfs2/dlmglue.c
@@ -2998,7 +2998,8 @@ int ocfs2_dlm_init(struct ocfs2_super *osb)
 	}

 	/* launch downconvert thread */
-	osb->dc_task = kthread_run(ocfs2_downconvert_thread, osb, "ocfs2dc");
+	osb->dc_task = kthread_run(ocfs2_downconvert_thread, osb, "ocfs2dc-%s",
+			osb->uuid_str);
 	if (IS_ERR(osb->dc_task)) {
 		status = PTR_ERR(osb->dc_task);
 		osb->dc_task = NULL;
diff --git a/fs/ocfs2/journal.c b/fs/ocfs2/journal.c
index 627d88c..86b9a93 100644
--- a/fs/ocfs2/journal.c
+++ b/fs/ocfs2/journal.c
@@ -1074,7 +1074,7 @@ int ocfs2_journal_load(struct ocfs2_journal *journal, int local, int replayed)
 	/* Launch the commit thread */
 	if (!local) {
 		osb->commit_task = kthread_run(ocfs2_commit_thread, osb,
-					       "ocfs2cmt");
+				"ocfs2cmt-%s", osb->uuid_str);
 		if (IS_ERR(osb->commit_task)) {
 			status = PTR_ERR(osb->commit_task);
 			osb->commit_task = NULL;
@@ -1491,7 +1491,7 @@ void ocfs2_recovery_thread(struct ocfs2_super *osb, int node_num)
 		goto out;

 	osb->recovery_thread_task =  kthread_run(__ocfs2_recovery_thread, osb,
-						 "ocfs2rec");
+			"ocfs2rec-%s", osb->uuid_str);
 	if (IS_ERR(osb->recovery_thread_task)) {
 		mlog_errno((int)PTR_ERR(osb->recovery_thread_task));
 		osb->recovery_thread_task = NULL;
-- 
1.8.4.3
