From: Joel Becker <joel.becker@oracle.com>
Date: Wed Mar  5 16:28:20 2008
Subject: [Ocfs2-devel] [PATCH 07/18] ocfs2: Move o2hb functionality into the
	stack glue.
In-Reply-To: <1204763261-28025-1-git-send-email-joel.becker@oracle.com>
References: <1204763261-28025-1-git-send-email-joel.becker@oracle.com>
Message-ID: <1204763261-28025-8-git-send-email-joel.becker@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, mark.fasheh@oracle.com

The last bit of classic stack used directly in ocfs2 code is o2hb.
Specifically, the check for heartbeat during mount and the call to
ocfs2_hb_ctl during unmount.

We create an extra API, ocfs2_cluster_hangup(), to encapsulate the call
to ocfs2_hb_ctl.  Other stacks will just leave hangup() empty.

The check for heartbeat is moved into ocfs2_cluster_connect().  It will
be matched by a similar check for other stacks.

With this change, only stackglue.c includes cluster/ headers.

Signed-off-by: Joel Becker <joel.becker@oracle.com>
Signed-off-by: Mark Fasheh <mark.fasheh@oracle.com>
---
 fs/ocfs2/dlmglue.c   |    4 ----
 fs/ocfs2/heartbeat.c |   33 ---------------------------------
 fs/ocfs2/heartbeat.h |    1 -
 fs/ocfs2/ioctl.c     |    1 +
 fs/ocfs2/ocfs2.h     |    4 ----
 fs/ocfs2/stackglue.c |   50 ++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/ocfs2/stackglue.h |    1 +
 fs/ocfs2/super.c     |   23 ++++++++++-------------
 8 files changed, 62 insertions(+), 55 deletions(-)

diff --git a/fs/ocfs2/dlmglue.c b/fs/ocfs2/dlmglue.c
index 9e13d4b..aa13d15 100644
--- a/fs/ocfs2/dlmglue.c
+++ b/fs/ocfs2/dlmglue.c
@@ -32,10 +32,6 @@
 #include <linux/debugfs.h>
 #include <linux/seq_file.h>
 
-#include <cluster/heartbeat.h>
-#include <cluster/nodemanager.h>
-#include <cluster/tcp.h>
-
 #define MLOG_MASK_PREFIX ML_DLM_GLUE
 #include <cluster/masklog.h>
 
diff --git a/fs/ocfs2/heartbeat.c b/fs/ocfs2/heartbeat.c
index dcac1a4..c6e7213 100644
--- a/fs/ocfs2/heartbeat.c
+++ b/fs/ocfs2/heartbeat.c
@@ -28,7 +28,6 @@
 #include <linux/types.h>
 #include <linux/slab.h>
 #include <linux/highmem.h>
-#include <linux/kmod.h>
 
 #define MLOG_MASK_PREFIX ML_SUPER
 #include <cluster/masklog.h>
@@ -83,38 +82,6 @@ void ocfs2_do_node_down(int node_num, void *data)
 	ocfs2_recovery_thread(osb, node_num);
 }
 
-void ocfs2_stop_heartbeat(struct ocfs2_super *osb)
-{
-	int ret;
-	char *argv[5], *envp[3];
-
-	if (ocfs2_mount_local(osb))
-		return;
-
-	if (!osb->uuid_str) {
-		/* This can happen if we don't get far enough in mount... */
-		mlog(0, "No UUID with which to stop heartbeat!\n\n");
-		return;
-	}
-
-	argv[0] = (char *)o2nm_get_hb_ctl_path();
-	argv[1] = "-K";
-	argv[2] = "-u";
-	argv[3] = osb->uuid_str;
-	argv[4] = NULL;
-
-	mlog(0, "Run: %s %s %s %s\n", argv[0], argv[1], argv[2], argv[3]);
-
-	/* minimal command environment taken from cpu_run_sbin_hotplug */
-	envp[0] = "HOME=/";
-	envp[1] = "PATH=/sbin:/bin:/usr/sbin:/usr/bin";
-	envp[2] = NULL;
-
-	ret = call_usermodehelper(argv[0], argv, envp, UMH_WAIT_PROC);
-	if (ret < 0)
-		mlog_errno(ret);
-}
-
 static inline void __ocfs2_node_map_set_bit(struct ocfs2_node_map *map,
 					    int bit)
 {
diff --git a/fs/ocfs2/heartbeat.h b/fs/ocfs2/heartbeat.h
index 38e2450..74b9c5d 100644
--- a/fs/ocfs2/heartbeat.h
+++ b/fs/ocfs2/heartbeat.h
@@ -29,7 +29,6 @@
 void ocfs2_init_node_maps(struct ocfs2_super *osb);
 
 void ocfs2_do_node_down(int node_num, void *data);
-void ocfs2_stop_heartbeat(struct ocfs2_super *osb);
 
 /* node map functions - used to keep track of mounted and in-recovery
  * nodes. */
diff --git a/fs/ocfs2/ioctl.c b/fs/ocfs2/ioctl.c
index 5177fba..ab1c216 100644
--- a/fs/ocfs2/ioctl.c
+++ b/fs/ocfs2/ioctl.c
@@ -7,6 +7,7 @@
 
 #include <linux/fs.h>
 #include <linux/mount.h>
+#include <linux/smp_lock.h>
 
 #define MLOG_MASK_PREFIX ML_INODE
 #include <cluster/masklog.h>
diff --git a/fs/ocfs2/ocfs2.h b/fs/ocfs2/ocfs2.h
index 7006aba..31dc28b 100644
--- a/fs/ocfs2/ocfs2.h
+++ b/fs/ocfs2/ocfs2.h
@@ -36,10 +36,6 @@
 #include <linux/mutex.h>
 #include <linux/jbd.h>
 
-#include "cluster/nodemanager.h"
-#include "cluster/heartbeat.h"
-#include "cluster/tcp.h"
-
 /* For union ocfs2_dlm_lksb */
 #include "stackglue.h"
 
diff --git a/fs/ocfs2/stackglue.c b/fs/ocfs2/stackglue.c
index 8146863..670fa94 100644
--- a/fs/ocfs2/stackglue.c
+++ b/fs/ocfs2/stackglue.c
@@ -20,12 +20,14 @@
 
 #include <linux/slab.h>
 #include <linux/crc32.h>
+#include <linux/kmod.h>
 
 /* Needed for AOP_TRUNCATED_PAGE in mlog_errno() */
 #include <linux/fs.h>
 
 #include "cluster/masklog.h"
 #include "cluster/nodemanager.h"
+#include "cluster/heartbeat.h"
 
 #include "stackglue.h"
 
@@ -301,6 +303,13 @@ int ocfs2_cluster_connect(const char *group,
 		goto out;
 	}
 
+	/* for now we only have one cluster/node, make sure we see it
+	 * in the heartbeat universe */
+	if (!o2hb_check_local_node_heartbeating()) {
+		rc = -EINVAL;
+		goto out;
+	}
+
 	new_conn = kzalloc(sizeof(struct ocfs2_cluster_connection),
 			   GFP_KERNEL);
 	if (!new_conn) {
@@ -359,6 +368,7 @@ out:
 	return rc;
 }
 
+
 int ocfs2_cluster_disconnect(struct ocfs2_cluster_connection *conn)
 {
 	struct dlm_ctxt *dlm = conn->cc_lockspace;
@@ -373,6 +383,46 @@ int ocfs2_cluster_disconnect(struct ocfs2_cluster_connection *conn)
 	return 0;
 }
 
+static void o2hb_stop(const char *group)
+{
+	int ret;
+	char *argv[5], *envp[3];
+
+	argv[0] = (char *)o2nm_get_hb_ctl_path();
+	argv[1] = "-K";
+	argv[2] = "-u";
+	argv[3] = (char *)group;
+	argv[4] = NULL;
+
+	mlog(0, "Run: %s %s %s %s\n", argv[0], argv[1], argv[2], argv[3]);
+
+	/* minimal command environment taken from cpu_run_sbin_hotplug */
+	envp[0] = "HOME=/";
+	envp[1] = "PATH=/sbin:/bin:/usr/sbin:/usr/bin";
+	envp[2] = NULL;
+
+	ret = call_usermodehelper(argv[0], argv, envp, UMH_WAIT_PROC);
+	if (ret < 0)
+		mlog_errno(ret);
+}
+
+/*
+ * Hangup is a hack for tools compatibility.  Older ocfs2-tools software
+ * expects the filesystem to call "ocfs2_hb_ctl" during unmount.  This
+ * happens regardless of whether the DLM got started, so we can't do it
+ * in ocfs2_cluster_disconnect().  We bring the o2hb_stop() function into
+ * the glue and provide a "hangup" API for super.c to call.
+ *
+ * Other stacks will eventually provide a NULL ->hangup() pointer.
+ */
+void ocfs2_cluster_hangup(const char *group, int grouplen)
+{
+	BUG_ON(group == NULL);
+	BUG_ON(group[grouplen] != '\0');
+
+	o2hb_stop(group);
+}
+
 int ocfs2_cluster_this_node(unsigned int *node)
 {
 	int node_num;
diff --git a/fs/ocfs2/stackglue.h b/fs/ocfs2/stackglue.h
index ccb0399..22af77b 100644
--- a/fs/ocfs2/stackglue.h
+++ b/fs/ocfs2/stackglue.h
@@ -74,6 +74,7 @@ int ocfs2_cluster_connect(const char *group,
 			  void *recovery_data,
 			  struct ocfs2_cluster_connection **conn);
 int ocfs2_cluster_disconnect(struct ocfs2_cluster_connection *conn);
+void ocfs2_cluster_hangup(const char *group, int grouplen);
 int ocfs2_cluster_this_node(unsigned int *node);
 
 int ocfs2_dlm_lock(struct ocfs2_cluster_connection *conn,
diff --git a/fs/ocfs2/super.c b/fs/ocfs2/super.c
index d3c4d32..8f536b3 100644
--- a/fs/ocfs2/super.c
+++ b/fs/ocfs2/super.c
@@ -40,8 +40,7 @@
 #include <linux/crc32.h>
 #include <linux/debugfs.h>
 #include <linux/mount.h>
-
-#include <cluster/nodemanager.h>
+#include <linux/seq_file.h>
 
 #define MLOG_MASK_PREFIX ML_SUPER
 #include <cluster/masklog.h>
@@ -579,15 +578,6 @@ static int ocfs2_fill_super(struct super_block *sb, void *data, int silent)
 		goto read_super_error;
 	}
 
-	/* for now we only have one cluster/node, make sure we see it
-	 * in the heartbeat universe */
-	if (parsed_options.mount_opt & OCFS2_MOUNT_HB_LOCAL) {
-		if (!o2hb_check_local_node_heartbeating()) {
-			status = -EINVAL;
-			goto read_super_error;
-		}
-	}
-
 	/* probe for superblock */
 	status = ocfs2_sb_probe(sb, &bh, &sector_size);
 	if (status < 0) {
@@ -1275,8 +1265,15 @@ static void ocfs2_dismount_volume(struct super_block *sb, int mnt_err)
 
 	debugfs_remove(osb->osb_debug_root);
 
-	if (!mnt_err)
-		ocfs2_stop_heartbeat(osb);
+	/*
+	 * This is a small hack to move ocfs2_hb_ctl into stackglue.
+	 * If we're dismounting due to mount error, mount.ocfs2 will clean
+	 * up heartbeat.  If we're a local mount, there is no heartbeat.
+	 * If we failed before we got a uuid_str yet, we can't stop
+	 * heartbeat.  Otherwise, do it.
+	 */
+	if (!mnt_err && !ocfs2_mount_local(osb) && osb->uuid_str)
+		ocfs2_cluster_hangup(osb->uuid_str, strlen(osb->uuid_str));
 
 	atomic_set(&osb->vol_state, VOLUME_DISMOUNTED);
 
-- 
1.5.3.8
