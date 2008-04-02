From: Mark Fasheh <mfasheh@suse.com>
Date: Wed,  2 Apr 2008 13:14:29 -0700
Subject: [Ocfs2-devel] [PATCH 19/62] ocfs2: Clean up stackglue initialization
In-Reply-To: <1207167355295-git-send-email-mfasheh@suse.com>
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
Message-ID: <12071673571757-git-send-email-mfasheh@suse.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-kernel@vger.kernel.org
Cc: ocfs2-devel@oss.oracle.com, Joel Becker <joel.becker@oracle.com>

From: Joel Becker <joel.becker@oracle.com>

The stack glue initialization function needs a better name so that it can be
used cleanly when stackglue becomes a module.

Signed-off-by: Joel Becker <joel.becker@oracle.com>
Signed-off-by: Mark Fasheh <mfasheh@suse.com>
---
 fs/ocfs2/dlmglue.c   |    9 ++-------
 fs/ocfs2/dlmglue.h   |    5 ++---
 fs/ocfs2/stackglue.c |    8 ++------
 fs/ocfs2/stackglue.h |    3 +--
 fs/ocfs2/super.c     |    6 ++----
 5 files changed, 9 insertions(+), 22 deletions(-)

diff --git a/fs/ocfs2/dlmglue.c b/fs/ocfs2/dlmglue.c
index f41ff1c..8a9c849 100644
--- a/fs/ocfs2/dlmglue.c
+++ b/fs/ocfs2/dlmglue.c
@@ -3366,16 +3366,11 @@ static struct ocfs2_locking_protocol lproto = {
 	.lp_unlock_ast		= ocfs2_unlock_ast,
 };
 
-/* This interface isn't the final one, hence the less-than-perfect names */
-void dlmglue_init_stack(void)
+void ocfs2_set_locking_protocol(void)
 {
-	o2cb_get_stack(&lproto);
+	ocfs2_stack_glue_set_locking_protocol(&lproto);
 }
 
-void dlmglue_exit_stack(void)
-{
-	o2cb_put_stack();
-}
 
 static void ocfs2_process_blocked_lock(struct ocfs2_super *osb,
 				       struct ocfs2_lock_res *lockres)
diff --git a/fs/ocfs2/dlmglue.h b/fs/ocfs2/dlmglue.h
index 2d0a8a0..34b7598 100644
--- a/fs/ocfs2/dlmglue.h
+++ b/fs/ocfs2/dlmglue.h
@@ -114,7 +114,6 @@ void ocfs2_wake_downconvert_thread(struct ocfs2_super *osb);
 struct ocfs2_dlm_debug *ocfs2_new_dlm_debug(void);
 void ocfs2_put_dlm_debug(struct ocfs2_dlm_debug *dlm_debug);
 
-void dlmglue_init_stack(void);
-void dlmglue_exit_stack(void);
-
+/* To set the locking protocol on module initialization */
+void ocfs2_set_locking_protocol(void);
 #endif	/* DLMGLUE_H */
diff --git a/fs/ocfs2/stackglue.c b/fs/ocfs2/stackglue.c
index bd80541..51c2546 100644
--- a/fs/ocfs2/stackglue.c
+++ b/fs/ocfs2/stackglue.c
@@ -429,14 +429,10 @@ int ocfs2_cluster_this_node(unsigned int *node)
 	return 0;
 }
 
-void o2cb_get_stack(struct ocfs2_locking_protocol *proto)
+void ocfs2_stack_glue_set_locking_protocol(struct ocfs2_locking_protocol *proto)
 {
-	BUG_ON(proto == NULL);
+	BUG_ON(proto != NULL);
 
 	lproto = proto;
 }
 
-void o2cb_put_stack(void)
-{
-	lproto = NULL;
-}
diff --git a/fs/ocfs2/stackglue.h b/fs/ocfs2/stackglue.h
index 01e3c9b..decb147 100644
--- a/fs/ocfs2/stackglue.h
+++ b/fs/ocfs2/stackglue.h
@@ -93,7 +93,6 @@ int ocfs2_dlm_lock_status(union ocfs2_dlm_lksb *lksb);
 void *ocfs2_dlm_lvb(union ocfs2_dlm_lksb *lksb);
 void ocfs2_dlm_dump_lksb(union ocfs2_dlm_lksb *lksb);
 
-void o2cb_get_stack(struct ocfs2_locking_protocol *proto);
-void o2cb_put_stack(void);
+void ocfs2_stack_glue_set_locking_protocol(struct ocfs2_locking_protocol *proto);
 
 #endif  /* STACKGLUE_H */
diff --git a/fs/ocfs2/super.c b/fs/ocfs2/super.c
index fa9c46e..b4a02a0 100644
--- a/fs/ocfs2/super.c
+++ b/fs/ocfs2/super.c
@@ -922,8 +922,6 @@ static int __init ocfs2_init(void)
 
 	ocfs2_print_version();
 
-	dlmglue_init_stack();
-
 	status = init_ocfs2_uptodate_cache();
 	if (status < 0) {
 		mlog_errno(status);
@@ -948,6 +946,8 @@ static int __init ocfs2_init(void)
 		mlog(ML_ERROR, "Unable to create ocfs2 debugfs root.\n");
 	}
 
+	ocfs2_set_locking_protocol();
+
 leave:
 	if (status < 0) {
 		ocfs2_free_mem_caches();
@@ -979,8 +979,6 @@ static void __exit ocfs2_exit(void)
 
 	exit_ocfs2_uptodate_cache();
 
-	dlmglue_exit_stack();
-
 	mlog_exit_void();
 }
 
-- 
1.5.4.1
