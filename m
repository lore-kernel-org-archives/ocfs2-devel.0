From: Mark Fasheh <mfasheh@suse.com>
Date: Tue, 17 Mar 2009 13:00:54 -0700
Subject: [Ocfs2-devel] [PATCH 04/32] ocfs2: Remove debugfs file
	local_alloc_stats
In-Reply-To: <1237320082-12921-1-git-send-email-mfasheh@suse.com>
References: <1237320082-12921-1-git-send-email-mfasheh@suse.com>
Message-ID: <1237320082-12921-5-git-send-email-mfasheh@suse.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-kernel@vger.kernel.org
Cc: ocfs2-devel@oss.oracle.com, Joel Becker <joel.becker@oracle.com>, Sunil Mushran <sunil.mushran@oracle.com>, Mark Fasheh <mfasheh@suse.com>

From: Sunil Mushran <sunil.mushran@oracle.com>

This patch removes the debugfs file local_alloc_stats as that information
is now included in the fs_state debugfs file.

Signed-off-by: Sunil Mushran <sunil.mushran@oracle.com>
Signed-off-by: Mark Fasheh <mfasheh@suse.com>
---
 fs/ocfs2/localalloc.c |   86 -------------------------------------------------
 fs/ocfs2/ocfs2.h      |    5 ---
 2 files changed, 0 insertions(+), 91 deletions(-)

diff --git a/fs/ocfs2/localalloc.c b/fs/ocfs2/localalloc.c
index ec70cdb..bac7e6a 100644
--- a/fs/ocfs2/localalloc.c
+++ b/fs/ocfs2/localalloc.c
@@ -28,7 +28,6 @@
 #include <linux/slab.h>
 #include <linux/highmem.h>
 #include <linux/bitops.h>
-#include <linux/debugfs.h>
 
 #define MLOG_MASK_PREFIX ML_DISK_ALLOC
 #include <cluster/masklog.h>
@@ -75,84 +74,6 @@ static int ocfs2_local_alloc_new_window(struct ocfs2_super *osb,
 static int ocfs2_local_alloc_slide_window(struct ocfs2_super *osb,
 					  struct inode *local_alloc_inode);
 
-#ifdef CONFIG_OCFS2_FS_STATS
-
-static int ocfs2_la_debug_open(struct inode *inode, struct file *file)
-{
-	file->private_data = inode->i_private;
-	return 0;
-}
-
-#define LA_DEBUG_BUF_SZ	PAGE_CACHE_SIZE
-#define LA_DEBUG_VER	1
-static ssize_t ocfs2_la_debug_read(struct file *file, char __user *userbuf,
-				   size_t count, loff_t *ppos)
-{
-	static DEFINE_MUTEX(la_debug_mutex);
-	struct ocfs2_super *osb = file->private_data;
-	int written, ret;
-	char *buf = osb->local_alloc_debug_buf;
-
-	mutex_lock(&la_debug_mutex);
-	memset(buf, 0, LA_DEBUG_BUF_SZ);
-
-	written = snprintf(buf, LA_DEBUG_BUF_SZ,
-			   "0x%x\t0x%llx\t%u\t%u\t0x%x\n",
-			   LA_DEBUG_VER,
-			   (unsigned long long)osb->la_last_gd,
-			   osb->local_alloc_default_bits,
-			   osb->local_alloc_bits, osb->local_alloc_state);
-
-	ret = simple_read_from_buffer(userbuf, count, ppos, buf, written);
-
-	mutex_unlock(&la_debug_mutex);
-	return ret;
-}
-
-static const struct file_operations ocfs2_la_debug_fops = {
-	.open =		ocfs2_la_debug_open,
-	.read =		ocfs2_la_debug_read,
-};
-
-static void ocfs2_init_la_debug(struct ocfs2_super *osb)
-{
-	osb->local_alloc_debug_buf = kmalloc(LA_DEBUG_BUF_SZ, GFP_NOFS);
-	if (!osb->local_alloc_debug_buf)
-		return;
-
-	osb->local_alloc_debug = debugfs_create_file("local_alloc_stats",
-						     S_IFREG|S_IRUSR,
-						     osb->osb_debug_root,
-						     osb,
-						     &ocfs2_la_debug_fops);
-	if (!osb->local_alloc_debug) {
-		kfree(osb->local_alloc_debug_buf);
-		osb->local_alloc_debug_buf = NULL;
-	}
-}
-
-static void ocfs2_shutdown_la_debug(struct ocfs2_super *osb)
-{
-	if (osb->local_alloc_debug)
-		debugfs_remove(osb->local_alloc_debug);
-
-	if (osb->local_alloc_debug_buf)
-		kfree(osb->local_alloc_debug_buf);
-
-	osb->local_alloc_debug_buf = NULL;
-	osb->local_alloc_debug = NULL;
-}
-#else	/* CONFIG_OCFS2_FS_STATS */
-static void ocfs2_init_la_debug(struct ocfs2_super *osb)
-{
-	return;
-}
-static void ocfs2_shutdown_la_debug(struct ocfs2_super *osb)
-{
-	return;
-}
-#endif
-
 static inline int ocfs2_la_state_enabled(struct ocfs2_super *osb)
 {
 	return (osb->local_alloc_state == OCFS2_LA_THROTTLED ||
@@ -226,8 +147,6 @@ int ocfs2_load_local_alloc(struct ocfs2_super *osb)
 
 	mlog_entry_void();
 
-	ocfs2_init_la_debug(osb);
-
 	if (osb->local_alloc_bits == 0)
 		goto bail;
 
@@ -299,9 +218,6 @@ bail:
 	if (inode)
 		iput(inode);
 
-	if (status < 0)
-		ocfs2_shutdown_la_debug(osb);
-
 	mlog(0, "Local alloc window bits = %d\n", osb->local_alloc_bits);
 
 	mlog_exit(status);
@@ -331,8 +247,6 @@ void ocfs2_shutdown_local_alloc(struct ocfs2_super *osb)
 	cancel_delayed_work(&osb->la_enable_wq);
 	flush_workqueue(ocfs2_wq);
 
-	ocfs2_shutdown_la_debug(osb);
-
 	if (osb->local_alloc_state == OCFS2_LA_UNUSED)
 		goto out;
 
diff --git a/fs/ocfs2/ocfs2.h b/fs/ocfs2/ocfs2.h
index 18d8542..a7c8369 100644
--- a/fs/ocfs2/ocfs2.h
+++ b/fs/ocfs2/ocfs2.h
@@ -287,11 +287,6 @@ struct ocfs2_super
 
 	u64 la_last_gd;
 
-#ifdef CONFIG_OCFS2_FS_STATS
-	struct dentry *local_alloc_debug;
-	char *local_alloc_debug_buf;
-#endif
-
 	/* Next three fields are for local node slot recovery during
 	 * mount. */
 	int dirty;
-- 
1.5.6
