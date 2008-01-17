From: Mark Fasheh <mark.fasheh@oracle.com>
Date: Thu Jan 17 14:37:01 2008
Subject: [Ocfs2-devel] [PATCH 02/30] ocfs2: Remove fs dependency on
	ocfs2_heartbeat module
In-Reply-To: <1200609356-17788-1-git-send-email-mark.fasheh@oracle.com>
References: <1200609356-17788-1-git-send-email-mark.fasheh@oracle.com>
Message-ID: <1200609356-17788-3-git-send-email-mark.fasheh@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-kernel@vger.kernel.org
Cc: ocfs2-devel@oss.oracle.com, Mark Fasheh <mark.fasheh@oracle.com>

Now that the dlm exposes domain information to us, we don't need generic
node up / node down callbacks. And since the DLM is only telling us when a
node goes down unexpectedly, we no longer need to optimize away node down
callbacks via the umount map.

Signed-off-by: Mark Fasheh <mark.fasheh@oracle.com>
---
 fs/ocfs2/heartbeat.c |   73 --------------------------------------------------
 fs/ocfs2/heartbeat.h |    2 -
 fs/ocfs2/super.c     |    8 -----
 3 files changed, 0 insertions(+), 83 deletions(-)

diff --git a/fs/ocfs2/heartbeat.c b/fs/ocfs2/heartbeat.c
index c4c3617..6239fc5 100644
--- a/fs/ocfs2/heartbeat.c
+++ b/fs/ocfs2/heartbeat.c
@@ -30,9 +30,6 @@
 #include <linux/highmem.h>
 #include <linux/kmod.h>
 
-#include <cluster/heartbeat.h>
-#include <cluster/nodemanager.h>
-
 #include <dlm/dlmapi.h>
 
 #define MLOG_MASK_PREFIX ML_SUPER
@@ -48,9 +45,6 @@
 
 #include "buffer_head_io.h"
 
-#define OCFS2_HB_NODE_DOWN_PRI     (0x0000002)
-#define OCFS2_HB_NODE_UP_PRI	   OCFS2_HB_NODE_DOWN_PRI
-
 static inline void __ocfs2_node_map_set_bit(struct ocfs2_node_map *map,
 					    int bit);
 static inline void __ocfs2_node_map_clear_bit(struct ocfs2_node_map *map,
@@ -87,26 +81,11 @@ static void ocfs2_do_node_down(int node_num,
 		return;
 	}
 
-	if (ocfs2_node_map_test_bit(osb, &osb->umount_map, node_num)) {
-		/* If a node is in the umount map, then we've been
-		 * expecting him to go down and we know ahead of time
-		 * that recovery is not necessary. */
-		ocfs2_node_map_clear_bit(osb, &osb->umount_map, node_num);
-		return;
-	}
-
 	ocfs2_recovery_thread(osb, node_num);
 
 	ocfs2_remove_node_from_vote_queues(osb, node_num);
 }
 
-static void ocfs2_hb_node_down_cb(struct o2nm_node *node,
-				  int node_num,
-				  void *data)
-{
-	ocfs2_do_node_down(node_num, (struct ocfs2_super *) data);
-}
-
 /* Called from the dlm when it's about to evict a node. We may also
  * get a heartbeat callback later. */
 static void ocfs2_dlm_eviction_cb(int node_num,
@@ -121,27 +100,8 @@ static void ocfs2_dlm_eviction_cb(int node_num,
 	ocfs2_do_node_down(node_num, osb);
 }
 
-static void ocfs2_hb_node_up_cb(struct o2nm_node *node,
-				int node_num,
-				void *data)
-{
-	struct ocfs2_super *osb = data;
-
-	BUG_ON(osb->node_num == node_num);
-
-	mlog(0, "node up event for %d\n", node_num);
-	ocfs2_node_map_clear_bit(osb, &osb->umount_map, node_num);
-}
-
 void ocfs2_setup_hb_callbacks(struct ocfs2_super *osb)
 {
-	o2hb_setup_callback(&osb->osb_hb_down, O2HB_NODE_DOWN_CB,
-			    ocfs2_hb_node_down_cb, osb,
-			    OCFS2_HB_NODE_DOWN_PRI);
-
-	o2hb_setup_callback(&osb->osb_hb_up, O2HB_NODE_UP_CB,
-			    ocfs2_hb_node_up_cb, osb, OCFS2_HB_NODE_UP_PRI);
-
 	/* Not exactly a heartbeat callback, but leads to essentially
 	 * the same path so we set it up here. */
 	dlm_setup_eviction_cb(&osb->osb_eviction_cb,
@@ -149,39 +109,6 @@ void ocfs2_setup_hb_callbacks(struct ocfs2_super *osb)
 			      osb);
 }
 
-/* Most functions here are just stubs for now... */
-int ocfs2_register_hb_callbacks(struct ocfs2_super *osb)
-{
-	int status;
-
-	if (ocfs2_mount_local(osb))
-		return 0;
-
-	status = o2hb_register_callback(osb->uuid_str, &osb->osb_hb_down);
-	if (status < 0) {
-		mlog_errno(status);
-		goto bail;
-	}
-
-	status = o2hb_register_callback(osb->uuid_str, &osb->osb_hb_up);
-	if (status < 0) {
-		mlog_errno(status);
-		o2hb_unregister_callback(osb->uuid_str, &osb->osb_hb_down);
-	}
-
-bail:
-	return status;
-}
-
-void ocfs2_clear_hb_callbacks(struct ocfs2_super *osb)
-{
-	if (ocfs2_mount_local(osb))
-		return;
-
-	o2hb_unregister_callback(osb->uuid_str, &osb->osb_hb_down);
-	o2hb_unregister_callback(osb->uuid_str, &osb->osb_hb_up);
-}
-
 void ocfs2_stop_heartbeat(struct ocfs2_super *osb)
 {
 	int ret;
diff --git a/fs/ocfs2/heartbeat.h b/fs/ocfs2/heartbeat.h
index e8fb079..5685921 100644
--- a/fs/ocfs2/heartbeat.h
+++ b/fs/ocfs2/heartbeat.h
@@ -29,8 +29,6 @@
 void ocfs2_init_node_maps(struct ocfs2_super *osb);
 
 void ocfs2_setup_hb_callbacks(struct ocfs2_super *osb);
-int ocfs2_register_hb_callbacks(struct ocfs2_super *osb);
-void ocfs2_clear_hb_callbacks(struct ocfs2_super *osb);
 void ocfs2_stop_heartbeat(struct ocfs2_super *osb);
 
 /* node map functions - used to keep track of mounted and in-recovery
diff --git a/fs/ocfs2/super.c b/fs/ocfs2/super.c
index 5ee7754..64b81b3 100644
--- a/fs/ocfs2/super.c
+++ b/fs/ocfs2/super.c
@@ -1117,12 +1117,6 @@ static int ocfs2_mount_volume(struct super_block *sb)
 		goto leave;
 	}
 
-	status = ocfs2_register_hb_callbacks(osb);
-	if (status < 0) {
-		mlog_errno(status);
-		goto leave;
-	}
-
 	status = ocfs2_dlm_init(osb);
 	if (status < 0) {
 		mlog_errno(status);
@@ -1260,8 +1254,6 @@ static void ocfs2_dismount_volume(struct super_block *sb, int mnt_err)
 		ocfs2_dlm_shutdown(osb);
 	}
 
-	ocfs2_clear_hb_callbacks(osb);
-
 	debugfs_remove(osb->osb_debug_root);
 
 	if (!mnt_err)
-- 
1.5.3.6
