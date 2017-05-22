From: Gang He <ghe@suse.com>
Date: Mon, 22 May 2017 16:17:59 +0800
Subject: [Ocfs2-devel] [PATCH] ocfs2: get rid of ocfs2_is_o2cb_active
	function
Message-ID: <1495441079-11708-1-git-send-email-ghe@suse.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: mfasheh@versity.com, jlbec@evilplan.org
Cc: Gang He <ghe@suse.com>, linux-kernel@vger.kernel.org, ocfs2-devel@oss.oracle.com, akpm@linux-foundation.org

This patch is used to get rid of ocfs2_is_o2cb_active() function,
Why? First, we had the similar functions to identify which cluster
stack is being used via osb->osb_cluster_stack. Second, the current
implementation of ocfs2_is_o2cb_active() function is not total safe,
base on the design of stackglue, we need to get ocfs2_stack_lock lock
before using ocfs2_stack related data structures, and that
active_stack pointer can be NULL in case mount failure.

Signed-off-by: Gang He <ghe@suse.com>
---
 fs/ocfs2/dlmglue.c   | 2 +-
 fs/ocfs2/stackglue.c | 6 ------
 fs/ocfs2/stackglue.h | 3 ---
 3 files changed, 1 insertion(+), 10 deletions(-)

diff --git a/fs/ocfs2/dlmglue.c b/fs/ocfs2/dlmglue.c
index 3b7c937..a54196a 100644
--- a/fs/ocfs2/dlmglue.c
+++ b/fs/ocfs2/dlmglue.c
@@ -3409,7 +3409,7 @@ static int ocfs2_downconvert_lock(struct ocfs2_super *osb,
 	 * we can recover correctly from node failure. Otherwise, we may get
 	 * invalid LVB in LKB, but without DLM_SBF_VALNOTVALID?being set.
 	 */
-	if (!ocfs2_is_o2cb_active() &&
+	if (ocfs2_userspace_stack(osb) &&
 	    lockres->l_ops->flags & LOCK_TYPE_USES_LVB)
 		lvb = 1;
 
diff --git a/fs/ocfs2/stackglue.c b/fs/ocfs2/stackglue.c
index 8203590..52c07346b 100644
--- a/fs/ocfs2/stackglue.c
+++ b/fs/ocfs2/stackglue.c
@@ -48,12 +48,6 @@
  */
 static struct ocfs2_stack_plugin *active_stack;
 
-inline int ocfs2_is_o2cb_active(void)
-{
-	return !strcmp(active_stack->sp_name, OCFS2_STACK_PLUGIN_O2CB);
-}
-EXPORT_SYMBOL_GPL(ocfs2_is_o2cb_active);
-
 static struct ocfs2_stack_plugin *ocfs2_stack_lookup(const char *name)
 {
 	struct ocfs2_stack_plugin *p;
diff --git a/fs/ocfs2/stackglue.h b/fs/ocfs2/stackglue.h
index e3036e1..f2dce10 100644
--- a/fs/ocfs2/stackglue.h
+++ b/fs/ocfs2/stackglue.h
@@ -298,9 +298,6 @@ int ocfs2_plock(struct ocfs2_cluster_connection *conn, u64 ino,
 int ocfs2_stack_glue_register(struct ocfs2_stack_plugin *plugin);
 void ocfs2_stack_glue_unregister(struct ocfs2_stack_plugin *plugin);
 
-/* In ocfs2_downconvert_lock(), we need to know which stack we are using */
-int ocfs2_is_o2cb_active(void);
-
 extern struct kset *ocfs2_kset;
 
 #endif  /* STACKGLUE_H */
-- 
1.8.5.6
