From: Mark Fasheh <mark.fasheh@oracle.com>
Date: Tue Mar  4 10:47:45 2008
Subject: [Ocfs2-devel] [git patches] ocfs2 fixes
Message-ID: <20080304184641.GK9349@ca-server1.us.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org, ocfs2-devel@oss.oracle.com

Hi Linus,

Here are some Ocfs2 fixes and minor cleanups for 2.6.24-rc4.

Full patch attached since this is all pretty small.
	--Mark


Please pull from 'upstream-linus' branch of
git://git.kernel.org/pub/scm/linux/kernel/git/mfasheh/ocfs2.git upstream-linus

to receive the following updates:

 fs/ocfs2/aops.c          |    2 +-
 fs/ocfs2/dir.c           |    5 ++---
 fs/ocfs2/dlm/dlmmaster.c |    6 +++---
 fs/ocfs2/dlmglue.c       |    8 ++++----
 fs/ocfs2/dlmglue.h       |    2 --
 fs/ocfs2/heartbeat.c     |   26 +++++++++++++-------------
 fs/ocfs2/heartbeat.h     |    5 -----
 fs/ocfs2/localalloc.c    |    6 +-----
 8 files changed, 24 insertions(+), 36 deletions(-)

Adrian Bunk (3):
      [2.6 patch] fs/ocfs2/: possible cleanups
      [2.6 patch] make ocfs2_downconvert_thread() static
      [2.6 patch] ocfs2: make dlm_do_assert_master() static

Julia Lawall (1):
      fs/ocfs2/aops.c: Correct use of ! and &

Marcin Slusarz (1):
      ocfs2: le*_add_cpu conversion

Mark Fasheh (1):
      ocfs2: Fix writeout in ocfs2_data_convert_worker()

Sunil Mushran (1):
      ocfs2: Enable localalloc for local mounts

diff --git a/fs/ocfs2/aops.c b/fs/ocfs2/aops.c
index 8224312..90383ed 100644
--- a/fs/ocfs2/aops.c
+++ b/fs/ocfs2/aops.c
@@ -257,7 +257,7 @@ static int ocfs2_readpage_inline(struct inode *inode, struct page *page)
 	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
 
 	BUG_ON(!PageLocked(page));
-	BUG_ON(!OCFS2_I(inode)->ip_dyn_features & OCFS2_INLINE_DATA_FL);
+	BUG_ON(!(OCFS2_I(inode)->ip_dyn_features & OCFS2_INLINE_DATA_FL));
 
 	ret = ocfs2_read_block(osb, OCFS2_I(inode)->ip_blkno, &di_bh,
 			       OCFS2_BH_CACHED, inode);
diff --git a/fs/ocfs2/dir.c b/fs/ocfs2/dir.c
index e280833..8a18758 100644
--- a/fs/ocfs2/dir.c
+++ b/fs/ocfs2/dir.c
@@ -390,9 +390,8 @@ static int __ocfs2_delete_entry(handle_t *handle, struct inode *dir,
 				goto bail;
 			}
 			if (pde)
-				pde->rec_len =
-					cpu_to_le16(le16_to_cpu(pde->rec_len) +
-						    le16_to_cpu(de->rec_len));
+				le16_add_cpu(&pde->rec_len,
+						le16_to_cpu(de->rec_len));
 			else
 				de->inode = 0;
 			dir->i_version++;
diff --git a/fs/ocfs2/dlm/dlmmaster.c b/fs/ocfs2/dlm/dlmmaster.c
index a54d33d..c92d1b1 100644
--- a/fs/ocfs2/dlm/dlmmaster.c
+++ b/fs/ocfs2/dlm/dlmmaster.c
@@ -1695,9 +1695,9 @@ send_response:
  * can periodically run all locks owned by this node
  * and re-assert across the cluster...
  */
-int dlm_do_assert_master(struct dlm_ctxt *dlm,
-			 struct dlm_lock_resource *res,
-			 void *nodemap, u32 flags)
+static int dlm_do_assert_master(struct dlm_ctxt *dlm,
+				struct dlm_lock_resource *res,
+				void *nodemap, u32 flags)
 {
 	struct dlm_assert_master assert;
 	int to, tmpret;
diff --git a/fs/ocfs2/dlmglue.c b/fs/ocfs2/dlmglue.c
index 351130c..f779430 100644
--- a/fs/ocfs2/dlmglue.c
+++ b/fs/ocfs2/dlmglue.c
@@ -3042,7 +3042,7 @@ static int ocfs2_data_convert_worker(struct ocfs2_lock_res *lockres,
        	inode = ocfs2_lock_res_inode(lockres);
 	mapping = inode->i_mapping;
 
-	if (S_ISREG(inode->i_mode))
+	if (!S_ISREG(inode->i_mode))
 		goto out;
 
 	/*
@@ -3219,8 +3219,8 @@ static int ocfs2_dentry_convert_worker(struct ocfs2_lock_res *lockres,
 	return UNBLOCK_CONTINUE_POST;
 }
 
-void ocfs2_process_blocked_lock(struct ocfs2_super *osb,
-				struct ocfs2_lock_res *lockres)
+static void ocfs2_process_blocked_lock(struct ocfs2_super *osb,
+				       struct ocfs2_lock_res *lockres)
 {
 	int status;
 	struct ocfs2_unblock_ctl ctl = {0, 0,};
@@ -3356,7 +3356,7 @@ static int ocfs2_downconvert_thread_should_wake(struct ocfs2_super *osb)
 	return should_wake;
 }
 
-int ocfs2_downconvert_thread(void *arg)
+static int ocfs2_downconvert_thread(void *arg)
 {
 	int status = 0;
 	struct ocfs2_super *osb = arg;
diff --git a/fs/ocfs2/dlmglue.h b/fs/ocfs2/dlmglue.h
index 1d5b069..e3cf902 100644
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
diff --git a/fs/ocfs2/localalloc.c b/fs/ocfs2/localalloc.c
index add1ffd..ab83fd5 100644
--- a/fs/ocfs2/localalloc.c
+++ b/fs/ocfs2/localalloc.c
@@ -120,9 +120,6 @@ int ocfs2_load_local_alloc(struct ocfs2_super *osb)
 
 	mlog_entry_void();
 
-	if (ocfs2_mount_local(osb))
-		goto bail;
-
 	if (osb->local_alloc_size == 0)
 		goto bail;
 
@@ -588,8 +585,7 @@ int ocfs2_claim_local_alloc_bits(struct ocfs2_super *osb,
 	while(bits_wanted--)
 		ocfs2_set_bit(start++, bitmap);
 
-	alloc->id1.bitmap1.i_used = cpu_to_le32(*num_bits +
-				le32_to_cpu(alloc->id1.bitmap1.i_used));
+	le32_add_cpu(&alloc->id1.bitmap1.i_used, *num_bits);
 
 	status = ocfs2_journal_dirty(handle, osb->local_alloc_bh);
 	if (status < 0) {
