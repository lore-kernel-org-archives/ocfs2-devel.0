From: Adrian Bunk <bunk@kernel.org>
Date: Mon Jan 28 14:11:29 2008
Subject: [Ocfs2-devel] [2.6 patch] fs/ocfs2/: possible cleanups
Message-ID: <20080128221141.GA8767@does.not.exist>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: mark.fasheh@oracle.com, kurt.hackel@oracle.com
Cc: ocfs2-devel@oss.oracle.com, linux-kernel@vger.kernel.org

This patch contains the following cleanups that are now possible:
- make the following needlessly global functions static:
  - dlmglue.c:ocfs2_process_blocked_lock()
  - heartbeat.c:ocfs2_node_map_init()
- #if 0 the following unused global function plus support functions:
  - heartbeat.c:ocfs2_node_map_is_only()

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---

 fs/ocfs2/dlmglue.c   |    4 ++--
 fs/ocfs2/dlmglue.h   |    2 --
 fs/ocfs2/heartbeat.c |   26 +++++++++++++-------------
 fs/ocfs2/heartbeat.h |    5 -----
 4 files changed, 15 insertions(+), 22 deletions(-)

72b647cdcd7b46c525bebfe915d52955bbb0f4ab 
diff --git a/fs/ocfs2/dlmglue.c b/fs/ocfs2/dlmglue.c
index 3867244..debf8ba 100644
--- a/fs/ocfs2/dlmglue.c
+++ b/fs/ocfs2/dlmglue.c
@@ -3192,8 +3192,8 @@ static int ocfs2_dentry_convert_worker(struct ocfs2_lock_res *lockres,
 	return UNBLOCK_CONTINUE_POST;
 }
 
-void ocfs2_process_blocked_lock(struct ocfs2_super *osb,
-				struct ocfs2_lock_res *lockres)
+static void ocfs2_process_blocked_lock(struct ocfs2_super *osb,
+				       struct ocfs2_lock_res *lockres)
 {
 	int status;
 	struct ocfs2_unblock_ctl ctl = {0, 0,};
diff --git a/fs/ocfs2/dlmglue.h b/fs/ocfs2/dlmglue.h
index 5f17243..1caac53 100644
--- a/fs/ocfs2/dlmglue.h
+++ b/fs/ocfs2/dlmglue.h
@@ -109,8 +109,6 @@ void ocfs2_simple_drop_lockres(struct ocfs2_super *osb,
 			       struct ocfs2_lock_res *lockres);
 
 /* for the downconvert thread */
-void ocfs2_process_blocked_lock(struct ocfs2_super *osb,
-				struct ocfs2_lock_res *lockres);
 void ocfs2_wake_downconvert_thread(struct ocfs2_super *osb);
 
 struct ocfs2_dlm_debug *ocfs2_new_dlm_debug(void);
diff --git a/fs/ocfs2/heartbeat.c b/fs/ocfs2/heartbeat.c
index c0efd94..0758daf 100644
--- a/fs/ocfs2/heartbeat.c
+++ b/fs/ocfs2/heartbeat.c
@@ -49,10 +49,15 @@ static inline void __ocfs2_node_map_set_bit(struct ocfs2_node_map *map,
 static inline void __ocfs2_node_map_clear_bit(struct ocfs2_node_map *map,
 					      int bit);
 static inline int __ocfs2_node_map_is_empty(struct ocfs2_node_map *map);
-static void __ocfs2_node_map_dup(struct ocfs2_node_map *target,
-				 struct ocfs2_node_map *from);
-static void __ocfs2_node_map_set(struct ocfs2_node_map *target,
-				 struct ocfs2_node_map *from);
+
+/* special case -1 for now
+ * TODO: should *really* make sure the calling func never passes -1!!  */
+static void ocfs2_node_map_init(struct ocfs2_node_map *map)
+{
+	map->num_nodes = OCFS2_NODE_MAP_MAX_NODES;
+	memset(map->map, 0, BITS_TO_LONGS(OCFS2_NODE_MAP_MAX_NODES) *
+	       sizeof(unsigned long));
+}
 
 void ocfs2_init_node_maps(struct ocfs2_super *osb)
 {
@@ -136,15 +141,6 @@ void ocfs2_stop_heartbeat(struct ocfs2_super *osb)
 		mlog_errno(ret);
 }
 
-/* special case -1 for now
- * TODO: should *really* make sure the calling func never passes -1!!  */
-void ocfs2_node_map_init(struct ocfs2_node_map *map)
-{
-	map->num_nodes = OCFS2_NODE_MAP_MAX_NODES;
-	memset(map->map, 0, BITS_TO_LONGS(OCFS2_NODE_MAP_MAX_NODES) *
-	       sizeof(unsigned long));
-}
-
 static inline void __ocfs2_node_map_set_bit(struct ocfs2_node_map *map,
 					    int bit)
 {
@@ -216,6 +212,8 @@ int ocfs2_node_map_is_empty(struct ocfs2_super *osb,
 	return ret;
 }
 
+#if 0
+
 static void __ocfs2_node_map_dup(struct ocfs2_node_map *target,
 				 struct ocfs2_node_map *from)
 {
@@ -254,6 +252,8 @@ static void __ocfs2_node_map_set(struct ocfs2_node_map *target,
 		target->map[i] = from->map[i];
 }
 
+#endif  /*  0  */
+
 /* Returns whether the recovery bit was actually set - it may not be
  * if a node is still marked as needing recovery */
 int ocfs2_recovery_map_set(struct ocfs2_super *osb,
diff --git a/fs/ocfs2/heartbeat.h b/fs/ocfs2/heartbeat.h
index 5685921..eac63ae 100644
--- a/fs/ocfs2/heartbeat.h
+++ b/fs/ocfs2/heartbeat.h
@@ -33,7 +33,6 @@ void ocfs2_stop_heartbeat(struct ocfs2_super *osb);
 
 /* node map functions - used to keep track of mounted and in-recovery
  * nodes. */
-void ocfs2_node_map_init(struct ocfs2_node_map *map);
 int ocfs2_node_map_is_empty(struct ocfs2_super *osb,
 			    struct ocfs2_node_map *map);
 void ocfs2_node_map_set_bit(struct ocfs2_super *osb,
@@ -57,9 +56,5 @@ int ocfs2_recovery_map_set(struct ocfs2_super *osb,
 			   int num);
 void ocfs2_recovery_map_clear(struct ocfs2_super *osb,
 			      int num);
-/* returns 1 if bit is the only bit set in target, 0 otherwise */
-int ocfs2_node_map_is_only(struct ocfs2_super *osb,
-			   struct ocfs2_node_map *target,
-			   int bit);
 
 #endif /* OCFS2_HEARTBEAT_H */
