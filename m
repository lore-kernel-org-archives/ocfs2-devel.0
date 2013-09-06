From: Goldwyn Rodrigues <rgoldwyn@suse.de>
Date: Thu, 5 Sep 2013 22:29:37 -0500
Subject: [Ocfs2-devel] [PATCH 6/6] Disallow cluster_stack changes if fs are
	mounted
Message-ID: <20130906032932.GA4192@shrek.lan>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com


Signed-off-by: Goldwyn Rodrigues <rgoldwyn@suse.com>
---
 fs/ocfs2/stackglue.c | 18 ++++++++++++++++++
 fs/ocfs2/stackglue.h |  3 +++
 fs/ocfs2/super.c     |  2 ++
 3 files changed, 23 insertions(+)

diff --git a/fs/ocfs2/stackglue.c b/fs/ocfs2/stackglue.c
index 4dd732b..e352a2e 100644
--- a/fs/ocfs2/stackglue.c
+++ b/fs/ocfs2/stackglue.c
@@ -41,6 +41,7 @@ static DEFINE_SPINLOCK(ocfs2_stack_lock);
 static LIST_HEAD(ocfs2_stack_list);
 static char cluster_stack_name[OCFS2_STACK_LABEL_LEN + 1];
 static char ocfs2_hb_ctl_path[OCFS2_MAX_HB_CTL_PATH] = "/sbin/ocfs2_hb_ctl";
+static atomic_t mount_count = ATOMIC_INIT(0);
 
 /*
  * The stack currently in use.  If not null, active_stack->sp_count > 0,
@@ -417,6 +418,18 @@ int ocfs2_cluster_disconnect(struct ocfs2_cluster_connection *conn,
 }
 EXPORT_SYMBOL_GPL(ocfs2_cluster_disconnect);
 
+void ocfs2_inc_mount_count()
+{
+	atomic_inc(&mount_count);
+}
+EXPORT_SYMBOL_GPL(ocfs2_inc_mount_count);
+
+void ocfs2_dec_mount_count()
+{
+	atomic_dec(&mount_count);
+}
+EXPORT_SYMBOL_GPL(ocfs2_dec_mount_count);
+
 /*
  * Leave the group for this filesystem.  This is executed by a userspace
  * program (stored in ocfs2_hb_ctl_path).
@@ -569,6 +582,11 @@ static ssize_t ocfs2_cluster_stack_store(struct kobject *kobj,
 	size_t len = count;
 	ssize_t ret;
 
+	if (atomic_read(&mount_count) > 0) {
+		printk(KERN_NOTICE "ocfs2_stackglue: Cannot set cluster_stack when filesystems are mounted.\n");
+		return -EINVAL;
+	}
+
 	if (len == 0)
 		return len;
 
diff --git a/fs/ocfs2/stackglue.h b/fs/ocfs2/stackglue.h
index c953290..9eeeff03 100644
--- a/fs/ocfs2/stackglue.h
+++ b/fs/ocfs2/stackglue.h
@@ -291,6 +291,9 @@ int ocfs2_plock(struct ocfs2_cluster_connection *conn, u64 ino,
 
 void ocfs2_stack_glue_set_max_proto_version(struct ocfs2_protocol_version *max_proto);
 
+void ocfs2_inc_mount_count(void);
+void ocfs2_dec_mount_count(void);
+
 
 /* Used by stack plugins */
 int ocfs2_stack_glue_register(struct ocfs2_stack_plugin *plugin);
diff --git a/fs/ocfs2/super.c b/fs/ocfs2/super.c
index 60f3d8e..c91087c 100644
--- a/fs/ocfs2/super.c
+++ b/fs/ocfs2/super.c
@@ -1214,6 +1214,7 @@ static int ocfs2_fill_super(struct super_block *sb, void *data, int silent)
 
 	/* Start this when the mount is almost sure of being successful */
 	ocfs2_orphan_scan_start(osb);
+	ocfs2_inc_mount_count();
 
 	return status;
 
@@ -1253,6 +1254,7 @@ static void ocfs2_kill_sb(struct super_block *sb)
 	spin_unlock(&dentry_list_lock);
 	/* Wait for work to finish and/or remove it */
 	cancel_work_sync(&osb->dentry_lock_work);
+	ocfs2_dec_mount_count();
 out:
 	kill_block_super(sb);
 }
-- 
1.8.1.4


-- 
Goldwyn
