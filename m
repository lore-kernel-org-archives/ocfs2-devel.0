From: Tao Ma <tao.ma@oracle.com>
Date: Wed Mar  5 00:13:03 2008
Subject: [Ocfs2-devel] [PATCH 3/3] Add inode stealing for
	ocfs2_reserve_new_inode.V5
In-Reply-To: <20080305004412.GO9349@ca-server1.us.oracle.com>
Message-ID: <20080305081146.GA26700@tma-pc1.cn.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Modification from V4 to V5:
1) Restore the function ocfs2_steal_inode_from_other_nodes.
2) Move ocfs2_init_inode_steal_slot from ocfs2_mount_volume to
   ocfs2_initialize_super.
3) Rename CFS2_NUM_INODES_STOLEN to OCFS2_MAX_INODES_TO_STEAL and move
   it to fs/ocfs2/suballoc.c.

2 new variables are added. They are:
1) ocfs2_super->s_inode_steal_slot. It is initalized as invalid and only
   set valid when we steal inode from other slots successfully. When we
   flush the truncate log, complete local alloc recovery or allocate
   from our own slot successfully, it will be reset to invalid.
2) ocfs2_super->s_num_inodes_stolen. It is used to record the times we try
   to steal inode from other nodes. And it is increased no matter whether
   our steal succeed or not. It is reset to zero when we try to allocate
   from our own slot or reset the s_inode_steal_slot.

So with this 2 new variables, now the whole inode allocation process is:
1. Check whether the s_inode_steal_slot is valid. If it is invalid, goto
   step 2, that is to try to allocate from our own. If it is valid, then
   we must have stealed inode successfully just now, so verify whether we
   have steal "s_num_inodes_stolen". If yes, goto step 2 since now we need
   to try own slot in case there is some space for us. If not, goto step 3
   and steal from other nodes directly.
2. Allocate from its own inode_alloc:000X and zero s_num_inodes_stolen.
   1) If we can reserve, OK.
   2) If fails, try to allocate a large chunk and reserve once again.
   3) If OK, clear s_inode_steal_slot and exit directly.
3. Try to allocate from other nodes.
   1) If s_inode_steal_slot is valid, start from that node, otherwise
      start from the node next to us. This time, Just try to reserve in
      inode_alloc, we don't go for global_bitmap if this node also can't
      allocate the inode.
   3) Try the node next to it until we reach the first steal slot again.
   4) If we succeed in one node's inode_alloc, set s_inode_steal_slot to it.
   5) increase s_num_inodes_stolen.

Signed-off-by: Tao Ma <tao.ma@oracle.com>
---
 fs/ocfs2/alloc.c      |    2 +
 fs/ocfs2/localalloc.c |    2 +
 fs/ocfs2/namei.c      |    2 +-
 fs/ocfs2/ocfs2.h      |   34 +++++++++++++++++++-
 fs/ocfs2/suballoc.c   |   80 +++++++++++++++++++++++++++++++++++++++++++++++-
 fs/ocfs2/super.c      |    1 +
 6 files changed, 116 insertions(+), 5 deletions(-)

diff --git a/fs/ocfs2/alloc.c b/fs/ocfs2/alloc.c
index 447206e..f333cdc 100644
--- a/fs/ocfs2/alloc.c
+++ b/fs/ocfs2/alloc.c
@@ -4788,6 +4788,8 @@ static void ocfs2_truncate_log_worker(struct work_struct *work)
 	status = ocfs2_flush_truncate_log(osb);
 	if (status < 0)
 		mlog_errno(status);
+	else
+		ocfs2_init_inode_steal_slot(osb);
 
 	mlog_exit(status);
 }
diff --git a/fs/ocfs2/localalloc.c b/fs/ocfs2/localalloc.c
index 80d1c75..ca3bf0c 100644
--- a/fs/ocfs2/localalloc.c
+++ b/fs/ocfs2/localalloc.c
@@ -450,6 +450,8 @@ out_mutex:
 	iput(main_bm_inode);
 
 out:
+	if (!status)
+		ocfs2_init_inode_steal_slot(osb);
 	mlog_exit(status);
 	return status;
 }
diff --git a/fs/ocfs2/namei.c b/fs/ocfs2/namei.c
index ae9ad95..ab5a227 100644
--- a/fs/ocfs2/namei.c
+++ b/fs/ocfs2/namei.c
@@ -424,7 +424,7 @@ static int ocfs2_mknod_locked(struct ocfs2_super *osb,
 	fe->i_fs_generation = cpu_to_le32(osb->fs_generation);
 	fe->i_blkno = cpu_to_le64(fe_blkno);
 	fe->i_suballoc_bit = cpu_to_le16(suballoc_bit);
-	fe->i_suballoc_slot = cpu_to_le16(osb->slot_num);
+	fe->i_suballoc_slot = cpu_to_le16(inode_ac->ac_alloc_slot);
 	fe->i_uid = cpu_to_le32(current->fsuid);
 	if (dir->i_mode & S_ISGID) {
 		fe->i_gid = cpu_to_le32(dir->i_gid);
diff --git a/fs/ocfs2/ocfs2.h b/fs/ocfs2/ocfs2.h
index 6546cef..0273a55 100644
--- a/fs/ocfs2/ocfs2.h
+++ b/fs/ocfs2/ocfs2.h
@@ -206,11 +206,14 @@ struct ocfs2_super
 	u32 s_feature_incompat;
 	u32 s_feature_ro_compat;
 
-	/* Protects s_next_generaion, osb_flags. Could protect more on
-	 * osb as it's very short lived. */
+	/* Protects s_next_generation, osb_flags and s_inode_steal_slot.
+	 * Could protect more on osb as it's very short lived.
+	 */
 	spinlock_t osb_lock;
 	u32 s_next_generation;
 	unsigned long osb_flags;
+	s16 s_inode_steal_slot;
+	atomic_t s_num_inodes_stolen;
 
 	unsigned long s_mount_opt;
 	unsigned int s_atime_quantum;
@@ -522,6 +525,33 @@ static inline unsigned int ocfs2_pages_per_cluster(struct super_block *sb)
 	return pages_per_cluster;
 }
 
+static inline void ocfs2_init_inode_steal_slot(struct ocfs2_super *osb)
+{
+	spin_lock(&osb->osb_lock);
+	osb->s_inode_steal_slot = OCFS2_INVALID_SLOT;
+	spin_unlock(&osb->osb_lock);
+	atomic_set(&osb->s_num_inodes_stolen, 0);
+}
+
+static inline void ocfs2_set_inode_steal_slot(struct ocfs2_super *osb,
+					      s16 slot)
+{
+	spin_lock(&osb->osb_lock);
+	osb->s_inode_steal_slot = slot;
+	spin_unlock(&osb->osb_lock);
+}
+
+static inline s16 ocfs2_get_inode_steal_slot(struct ocfs2_super *osb)
+{
+	s16 slot;
+
+	spin_lock(&osb->osb_lock);
+	slot = osb->s_inode_steal_slot;
+	spin_unlock(&osb->osb_lock);
+
+	return slot;
+}
+
 #define ocfs2_set_bit ext2_set_bit
 #define ocfs2_clear_bit ext2_clear_bit
 #define ocfs2_test_bit ext2_test_bit
diff --git a/fs/ocfs2/suballoc.c b/fs/ocfs2/suballoc.c
index 33d5573..d2d278f 100644
--- a/fs/ocfs2/suballoc.c
+++ b/fs/ocfs2/suballoc.c
@@ -49,6 +49,8 @@
 #define NOT_ALLOC_NEW_GROUP		0
 #define ALLOC_NEW_GROUP			1
 
+#define OCFS2_MAX_INODES_TO_STEAL	1024
+
 static inline void ocfs2_debug_bg(struct ocfs2_group_desc *bg);
 static inline void ocfs2_debug_suballoc_inode(struct ocfs2_dinode *fe);
 static inline u16 ocfs2_find_victim_chain(struct ocfs2_chain_list *cl);
@@ -109,7 +111,7 @@ static inline void ocfs2_block_to_cluster_group(struct inode *inode,
 						u64 *bg_blkno,
 						u16 *bg_bit_off);
 
-void ocfs2_free_alloc_context(struct ocfs2_alloc_context *ac)
+static void ocfs2_free_ac_resource(struct ocfs2_alloc_context *ac)
 {
 	struct inode *inode = ac->ac_inode;
 
@@ -120,9 +122,17 @@ void ocfs2_free_alloc_context(struct ocfs2_alloc_context *ac)
 		mutex_unlock(&inode->i_mutex);
 
 		iput(inode);
+		ac->ac_inode = NULL;
 	}
-	if (ac->ac_bh)
+	if (ac->ac_bh) {
 		brelse(ac->ac_bh);
+		ac->ac_bh = NULL;
+	}
+}
+
+void ocfs2_free_alloc_context(struct ocfs2_alloc_context *ac)
+{
+	ocfs2_free_ac_resource(ac);
 	kfree(ac);
 }
 
@@ -522,10 +532,42 @@ bail:
 	return status;
 }
 
+static int ocfs2_steal_inode_from_other_nodes(struct ocfs2_super *osb,
+					      struct ocfs2_alloc_context *ac)
+{
+	int i, status = -ENOSPC;
+	s16 slot = ocfs2_get_inode_steal_slot(osb);
+
+	/* Start to steal inodes from the first slot after ours. */
+	if (slot == OCFS2_INVALID_SLOT)
+		slot = osb->slot_num + 1;
+
+	for (i = 0; i < osb->max_slots; i++, slot++) {
+		if (slot == osb->max_slots)
+			slot = 0;
+
+		if (slot == osb->slot_num)
+			continue;
+
+		status = ocfs2_reserve_suballoc_bits(osb, ac,
+						     INODE_ALLOC_SYSTEM_INODE,
+						     slot, NOT_ALLOC_NEW_GROUP);
+		if (status >= 0) {
+			ocfs2_set_inode_steal_slot(osb, slot);
+			break;
+		}
+
+		ocfs2_free_ac_resource(ac);
+	}
+
+	return status;
+}
+
 int ocfs2_reserve_new_inode(struct ocfs2_super *osb,
 			    struct ocfs2_alloc_context **ac)
 {
 	int status;
+	s16 slot = ocfs2_get_inode_steal_slot(osb);
 
 	*ac = kzalloc(sizeof(struct ocfs2_alloc_context), GFP_KERNEL);
 	if (!(*ac)) {
@@ -539,9 +581,43 @@ int ocfs2_reserve_new_inode(struct ocfs2_super *osb,
 
 	(*ac)->ac_group_search = ocfs2_block_group_search;
 
+	/*
+	 * slot is set when we successfully steal inode from other nodes.
+	 * It is reset in 3 places:
+	 * 1. when we flush the truncate log
+	 * 2. when we complete local alloc recovery.
+	 * 3. when we successfully allocate from our own slot.
+	 * After it is set, we will go on stealing inodes until we find the
+	 * need to check our slots to see whether there is some space for us.
+	 */
+	if (slot != OCFS2_INVALID_SLOT &&
+	    atomic_read(&osb->s_num_inodes_stolen) < OCFS2_MAX_INODES_TO_STEAL)
+		goto inode_steal;
+
+	atomic_set(&osb->s_num_inodes_stolen, 0);
 	status = ocfs2_reserve_suballoc_bits(osb, *ac,
 					     INODE_ALLOC_SYSTEM_INODE,
 					     osb->slot_num, ALLOC_NEW_GROUP);
+	if (status >= 0) {
+		status = 0;
+
+		/*
+		 * Some inodes must be freed by us, so try to allocate
+		 * from our own next time.
+		 */
+		if (slot != OCFS2_INVALID_SLOT)
+			ocfs2_init_inode_steal_slot(osb);
+		goto bail;
+	} else if (status < 0 && status != -ENOSPC) {
+		mlog_errno(status);
+		goto bail;
+	}
+
+	ocfs2_free_ac_resource(*ac);
+
+inode_steal:
+	status = ocfs2_steal_inode_from_other_nodes(osb, *ac);
+	atomic_inc(&osb->s_num_inodes_stolen);
 	if (status < 0) {
 		if (status != -ENOSPC)
 			mlog_errno(status);
diff --git a/fs/ocfs2/super.c b/fs/ocfs2/super.c
index bec75af..94c7a69 100644
--- a/fs/ocfs2/super.c
+++ b/fs/ocfs2/super.c
@@ -1376,6 +1376,7 @@ static int ocfs2_initialize_super(struct super_block *sb,
 	INIT_LIST_HEAD(&osb->blocked_lock_list);
 	osb->blocked_lock_count = 0;
 	spin_lock_init(&osb->osb_lock);
+	ocfs2_init_inode_steal_slot(osb);
 
 	atomic_set(&osb->alloc_stats.moves, 0);
 	atomic_set(&osb->alloc_stats.local_data, 0);
-- 
1.5.3.GIT
