From: Tao Ma <tao.ma@oracle.com>
Date: Wed Feb 27 23:01:12 2008
Subject: [Ocfs2-devel] [PATCH 3/3] Add inode stealing for
	ocfs2_reserve_new_inode.V2
In-Reply-To: <20080228063438.GA27318@tma-pc1.cn.oracle.com>
Message-ID: <20080228070026.GA29377@tma-pc1.cn.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Add inode stealing for ocfs2_reserve_new_inode. Now the whole process is:
1. Allocate from its own inode_alloc:000X
   1) If we can reserve, OK.
   2) If fails, try to allocate a large chunk and reserve once again.
2. If 1 fails, try to allocate from the ocfs2_super->inode_steal_slot.
   This time, Just try to reserve, we don't go for global_bitmap if
   this inode also can't allocate the inode.
3. If 2 fails, try the node next until we reach that steal slot again.

ocfs2_super->inode_steal_slot is initalized as the node next to our own
slot. And once the inode stealing successes, we will refresh it with
the slot we steal inode from. It will also be reinitalized when the local
truncate log or local alloc recovery is flushed in which case the global
bitmap may be refreshed.

Signed-off-by: Tao Ma <tao.ma@oracle.com>
---
 fs/ocfs2/alloc.c      |    2 +
 fs/ocfs2/localalloc.c |    2 +
 fs/ocfs2/namei.c      |    2 +-
 fs/ocfs2/ocfs2.h      |   36 +++++++++++++++++++++++++++++++++-
 fs/ocfs2/suballoc.c   |   50 +++++++++++++++++++++++++++++++++++++++++++++++-
 fs/ocfs2/super.c      |    1 +
 6 files changed, 88 insertions(+), 5 deletions(-)

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
index 250b4bc..1965162 100644
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
index 6546cef..75b7fe0 100644
--- a/fs/ocfs2/ocfs2.h
+++ b/fs/ocfs2/ocfs2.h
@@ -206,11 +206,13 @@ struct ocfs2_super
 	u32 s_feature_incompat;
 	u32 s_feature_ro_compat;
 
-	/* Protects s_next_generaion, osb_flags. Could protect more on
-	 * osb as it's very short lived. */
+	/* Protects s_next_generation, osb_flags and inode_steal_slot.
+	 * Could protect more on osb as it's very short lived.
+	 */
 	spinlock_t osb_lock;
 	u32 s_next_generation;
 	unsigned long osb_flags;
+	s16 inode_steal_slot;
 
 	unsigned long s_mount_opt;
 	unsigned int s_atime_quantum;
@@ -522,6 +524,36 @@ static inline unsigned int ocfs2_pages_per_cluster(struct super_block *sb)
 	return pages_per_cluster;
 }
 
+static inline void ocfs2_init_inode_steal_slot(struct ocfs2_super *osb)
+{
+	BUG_ON(osb->slot_num == OCFS2_INVALID_SLOT);
+
+	spin_lock(&osb->osb_lock);
+	osb->inode_steal_slot = osb->slot_num + 1;
+	if (osb->inode_steal_slot == osb->max_slots)
+		osb->inode_steal_slot = 0;
+	spin_unlock(&osb->osb_lock);
+}
+
+static inline void ocfs2_set_inode_steal_slot(struct ocfs2_super *osb,
+					      u16 slot)
+{
+	spin_lock(&osb->osb_lock);
+	osb->inode_steal_slot = slot;
+	spin_unlock(&osb->osb_lock);
+}
+
+static inline u16 ocfs2_get_inode_steal_slot(struct ocfs2_super *osb)
+{
+	s16 slot;
+
+	spin_lock(&osb->osb_lock);
+	slot = osb->inode_steal_slot;
+	spin_unlock(&osb->osb_lock);
+
+	return slot;
+}
+
 #define ocfs2_set_bit ext2_set_bit
 #define ocfs2_clear_bit ext2_clear_bit
 #define ocfs2_test_bit ext2_test_bit
diff --git a/fs/ocfs2/suballoc.c b/fs/ocfs2/suballoc.c
index 33d5573..1657b7f 100644
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
 
@@ -522,6 +530,33 @@ bail:
 	return status;
 }
 
+static int ocfs2_steal_inode_from_other_nodes(struct ocfs2_super *osb,
+					      struct ocfs2_alloc_context *ac)
+{
+	int status = -ENOSPC, i;
+	s16 slot = ocfs2_get_inode_steal_slot(osb);
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
@@ -542,6 +577,17 @@ int ocfs2_reserve_new_inode(struct ocfs2_super *osb,
 	status = ocfs2_reserve_suballoc_bits(osb, *ac,
 					     INODE_ALLOC_SYSTEM_INODE,
 					     osb->slot_num, ALLOC_NEW_GROUP);
+	if (status >= 0) {
+		status = 0;
+		goto bail;
+	} else if (status < 0 && status != -ENOSPC) {
+		mlog_errno(status);
+		goto bail;
+	}
+
+	ocfs2_free_ac_resource(*ac);
+
+	status = ocfs2_steal_inode_from_other_nodes(osb, *ac);
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
