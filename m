From: Joseph Qi <joseph.qi@huawei.com>
Date: Fri, 5 Sep 2014 16:56:58 +0800
Subject: [Ocfs2-devel] [PATCH] ocfs2/dlm: refactor error handling in
	dlm_alloc_ctxt
Message-ID: <54097ADA.80505@huawei.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Refactoring error handling in dlm_alloc_ctxt to simplify code.

Signed-off-by: Joseph Qi <joseph.qi@huawei.com>
Reviewed-by: Alex Chen <alex.chen@huawei.com>
---
 fs/ocfs2/dlm/dlmdomain.c | 42 ++++++++++++++++++++++--------------------
 1 file changed, 22 insertions(+), 20 deletions(-)

diff --git a/fs/ocfs2/dlm/dlmdomain.c b/fs/ocfs2/dlm/dlmdomain.c
index bf86ed4..5f6199d 100644
--- a/fs/ocfs2/dlm/dlmdomain.c
+++ b/fs/ocfs2/dlm/dlmdomain.c
@@ -1976,24 +1976,22 @@ static struct dlm_ctxt *dlm_alloc_ctxt(const char *domain,

 	dlm = kzalloc(sizeof(*dlm), GFP_KERNEL);
 	if (!dlm) {
-		mlog_errno(-ENOMEM);
+		ret = -ENOMEM;
+		mlog_errno(ret);
 		goto leave;
 	}

 	dlm->name = kstrdup(domain, GFP_KERNEL);
 	if (dlm->name == NULL) {
-		mlog_errno(-ENOMEM);
-		kfree(dlm);
-		dlm = NULL;
+		ret = -ENOMEM;
+		mlog_errno(ret);
 		goto leave;
 	}

 	dlm->lockres_hash = (struct hlist_head **)dlm_alloc_pagevec(DLM_HASH_PAGES);
 	if (!dlm->lockres_hash) {
-		mlog_errno(-ENOMEM);
-		kfree(dlm->name);
-		kfree(dlm);
-		dlm = NULL;
+		ret = -ENOMEM;
+		mlog_errno(ret);
 		goto leave;
 	}

@@ -2003,11 +2001,8 @@ static struct dlm_ctxt *dlm_alloc_ctxt(const char *domain,
 	dlm->master_hash = (struct hlist_head **)
 				dlm_alloc_pagevec(DLM_HASH_PAGES);
 	if (!dlm->master_hash) {
-		mlog_errno(-ENOMEM);
-		dlm_free_pagevec((void **)dlm->lockres_hash, DLM_HASH_PAGES);
-		kfree(dlm->name);
-		kfree(dlm);
-		dlm = NULL;
+		ret = -ENOMEM;
+		mlog_errno(ret);
 		goto leave;
 	}

@@ -2018,14 +2013,8 @@ static struct dlm_ctxt *dlm_alloc_ctxt(const char *domain,
 	dlm->node_num = o2nm_this_node();

 	ret = dlm_create_debugfs_subroot(dlm);
-	if (ret < 0) {
-		dlm_free_pagevec((void **)dlm->master_hash, DLM_HASH_PAGES);
-		dlm_free_pagevec((void **)dlm->lockres_hash, DLM_HASH_PAGES);
-		kfree(dlm->name);
-		kfree(dlm);
-		dlm = NULL;
+	if (ret < 0)
 		goto leave;
-	}

 	spin_lock_init(&dlm->spinlock);
 	spin_lock_init(&dlm->master_lock);
@@ -2086,6 +2075,19 @@ static struct dlm_ctxt *dlm_alloc_ctxt(const char *domain,
 		  atomic_read(&dlm->dlm_refs.refcount));

 leave:
+	if (ret < 0 && dlm) {
+		if (dlm->master_hash)
+			dlm_free_pagevec((void **)dlm->master_hash,
+					DLM_HASH_PAGES);
+
+		if (dlm->lockres_hash)
+			dlm_free_pagevec((void **)dlm->lockres_hash,
+					DLM_HASH_PAGES);
+
+		kfree(dlm->name);
+		kfree(dlm);
+		dlm = NULL;
+	}
 	return dlm;
 }

-- 
1.8.4.3
