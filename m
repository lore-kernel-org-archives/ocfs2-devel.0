From: Xue jiufei <xuejiufei@huawei.com>
Date: Fri, 23 May 2014 10:21:18 +0800
Subject: [Ocfs2-devel] [PATCH] ocfs2: remove some unused codes
Message-ID: <537EB09E.7080004@huawei.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Signed-off-by: joyce.xue <xuejiufei@huawei.com>
---
 fs/ocfs2/dlm/dlmcommon.h | 1 -
 fs/ocfs2/dlm/dlmdomain.c | 1 -
 fs/ocfs2/dlmglue.c       | 5 -----
 3 files changed, 7 deletions(-)

diff --git a/fs/ocfs2/dlm/dlmcommon.h b/fs/ocfs2/dlm/dlmcommon.h
index fa2bd21..fae17c6 100644
--- a/fs/ocfs2/dlm/dlmcommon.h
+++ b/fs/ocfs2/dlm/dlmcommon.h
@@ -108,7 +108,6 @@ static inline int dlm_is_recovery_lock(const char *lock_name, int name_len)
 struct dlm_recovery_ctxt
 {
 	struct list_head resources;
-	struct list_head received;
 	struct list_head node_data;
 	u8  new_master;
 	u8  dead_node;
diff --git a/fs/ocfs2/dlm/dlmdomain.c b/fs/ocfs2/dlm/dlmdomain.c
index c973690..34fbbe5 100644
--- a/fs/ocfs2/dlm/dlmdomain.c
+++ b/fs/ocfs2/dlm/dlmdomain.c
@@ -2023,7 +2023,6 @@ static struct dlm_ctxt *dlm_alloc_ctxt(const char *domain,
 	INIT_LIST_HEAD(&dlm->list);
 	INIT_LIST_HEAD(&dlm->dirty_list);
 	INIT_LIST_HEAD(&dlm->reco.resources);
-	INIT_LIST_HEAD(&dlm->reco.received);
 	INIT_LIST_HEAD(&dlm->reco.node_data);
 	INIT_LIST_HEAD(&dlm->purge_list);
 	INIT_LIST_HEAD(&dlm->dlm_domain_handlers);
diff --git a/fs/ocfs2/dlmglue.c b/fs/ocfs2/dlmglue.c
index 6bd690b..52cfe99 100644
--- a/fs/ocfs2/dlmglue.c
+++ b/fs/ocfs2/dlmglue.c
@@ -2544,11 +2544,6 @@ int ocfs2_super_lock(struct ocfs2_super *osb,
 	 * refreshed, so we do it here. Of course, making sense of
 	 * everything is up to the caller :) */
 	status = ocfs2_should_refresh_lock_res(lockres);
-	if (status < 0) {
-		ocfs2_cluster_unlock(osb, lockres, level);
-		mlog_errno(status);
-		goto bail;
-	}
 	if (status) {
 		status = ocfs2_refresh_slot_info(osb);
 
-- 
1.8.3.4
