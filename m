From: Mark Fasheh <mfasheh@suse.com>
Date: Wed,  2 Apr 2008 13:15:06 -0700
Subject: [Ocfs2-devel] [PATCH 56/62] ocfs2: Add inode stealing for
	ocfs2_reserve_new_inode
In-Reply-To: <12071674333467-git-send-email-mfasheh@suse.com>
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
	<12071673571757-git-send-email-mfasheh@suse.com>
	<12071673591158-git-send-email-mfasheh@suse.com>
	<12071673613757-git-send-email-mfasheh@suse.com>
	<1207167363119-git-send-email-mfasheh@suse.com>
	<12071673661674-git-send-email-mfasheh@suse.com>
	<12071673681650-git-send-email-mfasheh@suse.com>
	<12071673701937-git-send-email-mfasheh@suse.com>
	<12071673722691-git-send-email-mfasheh@suse.com>
	<12071673731276-git-send-email-mfasheh@suse.com>
	<12071673753788-git-send-email-mfasheh@suse.com>
	<12071673772233-git-send-email-mfasheh@suse.com>
	<1207167379283-git-send-email-mfasheh@suse.com>
	<12071673821008-git-send-email-mfasheh@suse.com>
	<12071673843208-git-send-email-mfasheh@suse.com>
	<12071673872568-git-send-email-mfasheh@suse.com>
	<12071673882492-git-send-email-mfasheh@suse.com>
	<1207167390414-git-send-email-mfasheh@suse.com>
	<1207167392537-git-send-email-mfasheh@suse.com>
	<12071673941659-git-send-email-mfasheh@suse.com>
	<12071673964014-git-send-email-mfasheh@suse.com>
	<1207167398684-git-send-email-mfasheh@suse.com>
	<12071674013954-git-send-email-mfasheh@suse.com>
	<12071674033903-git-send-email-mfasheh@suse.com>
	<12071674061934-git-send-email-mfasheh@suse.com>
	<12071674083120-git-send-email-mfasheh@suse.com>
	<12071674103432-git-send-email-mfasheh@suse.com>
	<1207167413855-git-send-email-mfasheh@suse.com>
	<12071674151752-git-send-email-mfasheh@suse.com>
	<12071674171596-git-send-email-mfasheh@suse.com>
	<12071674193441-git-send-email-mfasheh@suse.com>
	<12071674213882-git-send-email-mfasheh@suse.com>
	<12071674242631-git-send-email-mfasheh@suse.com>
	<1207167425415-git-send-email-mfasheh@suse.com>
	<1207167427753-git-send-email-mfasheh@suse.com>
	<12071674291040-git-send-email-mfasheh@suse.com>
	<12071674312495-git-send-email-mfasheh@suse.com>
	<12071674333467-git-send-email-mfasheh@suse.com>
Message-ID: <12071674361985-git-send-email-mfasheh@suse.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-kernel@vger.kernel.org
Cc: ocfs2-devel@oss.oracle.com, Joel Becker <joel.becker@oracle.com>, Tao Ma <tao.ma@oracle.com>

From: Tao Ma <tao.ma@oracle.com>

Inode allocation is modified to look in other nodes allocators during
extreme out of space situations. We retry our own slot when space is freed
back to the global bitmap, or whenever we've allocated more than 1024 inodes
from another slot.

Signed-off-by: Tao Ma <tao.ma@oracle.com>
Signed-off-by: Mark Fasheh <mfasheh@suse.com>
---
 fs/ocfs2/alloc.c      |    2 +
 fs/ocfs2/localalloc.c |    2 +
 fs/ocfs2/namei.c      |    2 +-
 fs/ocfs2/ocfs2.h      |   34 +++++++++++++++++++-
 fs/ocfs2/suballoc.c   |   80 +++++++++++++++++++++++++++++++++++++++++++++++-
 fs/ocfs2/super.c      |    1 +
 6 files changed, 116 insertions(+), 5 deletions(-)

diff --git a/fs/ocfs2/alloc.c b/fs/ocfs2/alloc.c
index 7d81aa6..a268821 100644
--- a/fs/ocfs2/alloc.c
+++ b/fs/ocfs2/alloc.c
@@ -5150,6 +5150,8 @@ static void ocfs2_truncate_log_worker(struct work_struct *work)
 	status = ocfs2_flush_truncate_log(osb);
 	if (status < 0)
 		mlog_errno(status);
+	else
+		ocfs2_init_inode_steal_slot(osb);
 
 	mlog_exit(status);
 }
diff --git a/fs/ocfs2/localalloc.c b/fs/ocfs2/localalloc.c
index b6d0719..ce0dc14 100644
--- a/fs/ocfs2/localalloc.c
+++ b/fs/ocfs2/localalloc.c
@@ -447,6 +447,8 @@ out_mutex:
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
index 9ff5811..3169237 100644
--- a/fs/ocfs2/ocfs2.h
+++ b/fs/ocfs2/ocfs2.h
@@ -208,11 +208,14 @@ struct ocfs2_super
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
@@ -537,6 +540,33 @@ static inline unsigned int ocfs2_pages_per_cluster(struct super_block *sb)
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
index 96ebe36..df63ba2 100644
--- a/fs/ocfs2/super.c
+++ b/fs/ocfs2/super.c
@@ -1394,6 +1394,7 @@ static int ocfs2_initialize_super(struct super_block *sb,
 	INIT_LIST_HEAD(&osb->blocked_lock_list);
 	osb->blocked_lock_count = 0;
 	spin_lock_init(&osb->osb_lock);
+	ocfs2_init_inode_steal_slot(osb);
 
 	atomic_set(&osb->alloc_stats.moves, 0);
 	atomic_set(&osb->alloc_stats.local_data, 0);
-- 
1.5.4.1
