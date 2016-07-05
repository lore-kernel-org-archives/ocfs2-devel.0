From: Joseph Qi <joseph.qi@huawei.com>
Date: Tue, 5 Jul 2016 21:34:13 +0800
Subject: [Ocfs2-devel] ocfs2/dlm: fix memory leak of dlm_debug_ctxt
Message-ID: <577BB755.4030900@huawei.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

dlm_debug_ctxt->debug_refcnt is initialized to 1 and then increased to 2
by dlm_debug_get in dlm_debug_init. But dlm_debug_put is called only
once in dlm_debug_shutdown during unregister dlm, which leads to
dlm_debug_ctxt leaked.

Signed-off-by: Joseph Qi <joseph.qi@huawei.com>
Reviewed-by: Jiufei Xue <xuejiufei@huawei.com>
---
 fs/ocfs2/dlm/dlmdebug.c | 26 ++------------------------
 fs/ocfs2/dlm/dlmdebug.h |  1 -
 2 files changed, 2 insertions(+), 25 deletions(-)

diff --git a/fs/ocfs2/dlm/dlmdebug.c b/fs/ocfs2/dlm/dlmdebug.c
index 8251360..e7b760d 100644
--- a/fs/ocfs2/dlm/dlmdebug.c
+++ b/fs/ocfs2/dlm/dlmdebug.c
@@ -347,26 +347,6 @@ static struct dentry *dlm_debugfs_root;
 #define DLM_DEBUGFS_PURGE_LIST			"purge_list"

 /* begin - utils funcs */
-static void dlm_debug_free(struct kref *kref)
-{
-	struct dlm_debug_ctxt *dc;
-
-	dc = container_of(kref, struct dlm_debug_ctxt, debug_refcnt);
-
-	kfree(dc);
-}
-
-static void dlm_debug_put(struct dlm_debug_ctxt *dc)
-{
-	if (dc)
-		kref_put(&dc->debug_refcnt, dlm_debug_free);
-}
-
-static void dlm_debug_get(struct dlm_debug_ctxt *dc)
-{
-	kref_get(&dc->debug_refcnt);
-}
-
 static int debug_release(struct inode *inode, struct file *file)
 {
 	free_page((unsigned long)file->private_data);
@@ -932,11 +912,9 @@ int dlm_debug_init(struct dlm_ctxt *dlm)
 		goto bail;
 	}

-	dlm_debug_get(dc);
 	return 0;

 bail:
-	dlm_debug_shutdown(dlm);
 	return -ENOMEM;
 }

@@ -949,7 +927,8 @@ void dlm_debug_shutdown(struct dlm_ctxt *dlm)
 		debugfs_remove(dc->debug_mle_dentry);
 		debugfs_remove(dc->debug_lockres_dentry);
 		debugfs_remove(dc->debug_state_dentry);
-		dlm_debug_put(dc);
+		kfree(dc);
+		dc = NULL;
 	}
 }

@@ -969,7 +948,6 @@ int dlm_create_debugfs_subroot(struct dlm_ctxt *dlm)
 		mlog_errno(-ENOMEM);
 		goto bail;
 	}
-	kref_init(&dlm->dlm_debug_ctxt->debug_refcnt);

 	return 0;
 bail:
diff --git a/fs/ocfs2/dlm/dlmdebug.h b/fs/ocfs2/dlm/dlmdebug.h
index 1f27c48..5ced548 100644
--- a/fs/ocfs2/dlm/dlmdebug.h
+++ b/fs/ocfs2/dlm/dlmdebug.h
@@ -30,7 +30,6 @@ void dlm_print_one_mle(struct dlm_master_list_entry *mle);
 #ifdef CONFIG_DEBUG_FS

 struct dlm_debug_ctxt {
-	struct kref debug_refcnt;
 	struct dentry *debug_state_dentry;
 	struct dentry *debug_lockres_dentry;
 	struct dentry *debug_mle_dentry;
-- 
1.8.4.3
