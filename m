From: Tao Ma <tao.ma@oracle.com>
Date: Mon Mar  3 01:13:16 2008
Subject: [Ocfs2-devel] [PATCH 3/3] Add inode stealing for
	ocfs2_reserve_new_inode.V3
In-Reply-To: <20080303090022.GA18049@tma-pc1.cn.oracle.com>
Message-ID: <20080303091251.GA18140@tma-pc1.cn.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

2 new variables are added. They are:
1) ocfs2_super->inode_steal_slot. It is initalized as invalid and only
   set valid when we steal inode from other slots successfully. When we
   flush the truncate log, complete local alloc recovery or allocate
   from our own slot successfully, it will be reset to invalid.
2) inode_steal_times. It is used to record the times we try to steal
   inode from other nodes. And it is increased no matter whether our steal
   succeed or not. It is reset to zero when we try to allocate from our
   own slot.

So with this 2 new variables, now the whole inode allocation process is:
1. Check whether the ocfs2_super->inode_steal_slot is valid. If it is
   invalid, goto step 2, that is to try to allocate from our own. If it
   is valid, then we must have stealed inode successfully just now, so
   verify whether we have steal "inode_steal_times". If yes, goto step 2
   since now we need to try own slot in case there is some space for us.
   If not, goto step 3 and steal from other nodes directly.
2. Allocate from its own inode_alloc:000X and zero inode_steal_times.
   1) If we can reserve, OK.
   2) If fails, try to allocate a large chunk and reserve once again.
   3) If OK, clear ocfs2_super->inode_steal_slot and exit directly.
3. Try to allocate from other nodes.
   1) If ocfs2_super->inode_steal_slot is valid, start from that node,
      otherwise start from the node next to us. This time, Just try to
      reserve in inode_alloc, we don't go for global_bitmap if this
      node also can't allocate the inode.
   3) Try the node next until we reach the first steal slot again.
   4) If we succeed in one node's inode_alloc, set
      ocfs2_super->inode_steal_slot to it.
   5) increase inode_steal_times.

Signed-off-by: Tao Ma <tao.ma@oracle.com>
---
 fs/ocfs2/alloc.c      |    2 +
 fs/ocfs2/localalloc.c |    2 +
 fs/ocfs2/namei.c      |    2 +-
 fs/ocfs2/ocfs2.h      |   32 +++++++++++++++++-
 fs/ocfs2/suballoc.c   |   83 +++++++++++++++++++++++++++++++++++++++++++++++-
 fs/ocfs2/super.c      |    1 +
 6 files changed, 117 insertions(+), 5 deletions(-)

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
index 6546cef..2278ec0 100644
--- a/fs/ocfs2/ocfs2.h
+++ b/fs/ocfs2/ocfs2.h
@@ -206,11 +206,13 @@ struct ocfs2_super
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
 
 	unsigned long s_mount_opt;
 	unsigned int s_atime_quantum;
@@ -522,6 +524,32 @@ static inline unsigned int ocfs2_pages_per_cluster(struct super_block *sb)
 	return pages_per_cluster;
 }
 
+static inline void ocfs2_init_inode_steal_slot(struct ocfs2_super *osb)
+{
+	spin_lock(&osb->osb_lock);
+	osb->s_inode_steal_slot = OCFS2_INVALID_SLOT;
+	spin_unlock(&osb->osb_lock);
+}
+
+static inline void ocfs2_set_inode_steal_slot(struct ocfs2_super *osb,
+					      u16 slot)
+{
+	spin_lock(&osb->osb_lock);
+	osb->s_inode_steal_slot = slot;
+	spin_unlock(&osb->osb_lock);
+}
+
+static inline u16 ocfs2_get_inode_steal_slot(struct ocfs2_super *osb)
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
index 33d5573..dad4b70 100644
--- a/fs/ocfs2/suballoc.c
+++ b/fs/ocfs2/suballoc.c
@@ -109,7 +109,7 @@ static inline void ocfs2_block_to_cluster_group(struct inode *inode,
 						u64 *bg_blkno,
 						u16 *bg_bit_off);
 
-void ocfs2_free_alloc_context(struct ocfs2_alloc_context *ac)
+static void ocfs2_free_ac_resource(struct ocfs2_alloc_context *ac)
 {
 	struct inode *inode = ac->ac_inode;
 
@@ -120,9 +120,17 @@ void ocfs2_free_alloc_context(struct ocfs2_alloc_context *ac)
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
 
@@ -522,10 +530,47 @@ bail:
 	return status;
 }
 
+static int ocfs2_steal_inode_from_other_nodes(struct ocfs2_super *osb,
+					      struct ocfs2_alloc_context *ac)
+{
+	int status = -ENOSPC, i;
+	s16 slot = ocfs2_get_inode_steal_slot(osb);
+
+	/*
+	 * This is the first time we try to steal inodes, so begin
+	 * with the node next to us first.
+	 */
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
+#define OCFS2_INODE_STEAL_TIMES 10
+	static atomic_t inode_steal_times = ATOMIC_INIT(0);
 
 	*ac = kzalloc(sizeof(struct ocfs2_alloc_context), GFP_KERNEL);
 	if (!(*ac)) {
@@ -539,9 +584,43 @@ int ocfs2_reserve_new_inode(struct ocfs2_super *osb,
 
 	(*ac)->ac_group_search = ocfs2_block_group_search;
 
+	/*
+	 * slot is set when we successfully steal inode from other nodes.
+	 * It is reset in 3 places:
+	 * 1. when we flush the turncate log
+	 * 2. when we complete local alloc recovery.
+	 * 3. when we successfully allocate from our own slot.
+	 * After it is set, we will go on stealing inodes until we find the
+	 * need to check our slots to see wether there is some space for us.
+	 */
+	if (slot != OCFS2_INVALID_SLOT &&
+	    atomic_read(&inode_steal_times) < OCFS2_INODE_STEAL_TIMES)
+		goto inode_steal;
+
+	atomic_set(&inode_steal_times, 0);
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
+	atomic_inc(&inode_steal_times);
 	if (status < 0) {
 		if (status != -ENOSPC)
 			mlog_errno(status);
diff --git a/fs/ocfs2/super.c b/fs/ocfs2/super.c
index bec75af..c4e82c7 100644
--- a/fs/ocfs2/super.c
+++ b/fs/ocfs2/super.c
@@ -1193,6 +1193,7 @@ static int ocfs2_mount_volume(struct super_block *sb)
 		mlog_errno(status);
 		goto leave;
 	}
+	ocfs2_init_inode_steal_slot(osb);
 
 	/* load all node-local system inodes */
 	status = ocfs2_init_local_system_inodes(osb);
-- 
1.5.3.GIT
