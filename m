From: tao.ma at oracle.com <tao.ma@oracle.com>
Date: Wed, 30 Apr 2008 15:35:07 +0800
Subject: [Ocfs2-devel] [patch 2/2] ocfs2-1.2: Add inode stealing
	for	ocfs2_reserve_new_inode
References: <20080430065128.592723569@oracle.com>
Message-ID: <20080430073507.GB11325@dhcp-beijing-cdc-10-182-121-54.cn.oracle
	.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Inode allocation is modified to look in other nodes allocators during
extreme out of space situations. We retry our own slot when space is freed
back to the global bitmap, or whenever we've allocated more than 1024 inode
from another slot.

Index: ocfs2-1.2/fs/ocfs2/alloc.c
===================================================================
--- ocfs2-1.2.orig/fs/ocfs2/alloc.c	2008-04-30 13:59:12.000000000 +0800
+++ ocfs2-1.2/fs/ocfs2/alloc.c	2008-04-30 14:15:09.000000000 +0800
@@ -1213,6 +1213,8 @@ static void ocfs2_truncate_log_worker(vo
 	status = ocfs2_flush_truncate_log(osb);
 	if (status < 0)
 		mlog_errno(status);
+	else
+		ocfs2_init_inode_steal_slot(osb);
 
 	mlog_exit(status);
 }
Index: ocfs2-1.2/fs/ocfs2/localalloc.c
===================================================================
--- ocfs2-1.2.orig/fs/ocfs2/localalloc.c	2008-04-30 13:59:12.000000000 +0800
+++ ocfs2-1.2/fs/ocfs2/localalloc.c	2008-04-30 14:14:08.000000000 +0800
@@ -440,6 +440,9 @@ bail:
 	if (main_bm_inode)
 		iput(main_bm_inode);
 
+	if (!status)
+		ocfs2_init_inode_steal_slot(osb);
+
 	mlog_exit(status);
 	return status;
 }
Index: ocfs2-1.2/fs/ocfs2/namei.c
===================================================================
--- ocfs2-1.2.orig/fs/ocfs2/namei.c	2008-04-30 13:59:12.000000000 +0800
+++ ocfs2-1.2/fs/ocfs2/namei.c	2008-04-30 14:12:58.000000000 +0800
@@ -527,7 +527,7 @@ static int ocfs2_mknod_locked(struct ocf
 	fe->i_fs_generation = cpu_to_le32(osb->fs_generation);
 	fe->i_blkno = cpu_to_le64(fe_blkno);
 	fe->i_suballoc_bit = cpu_to_le16(suballoc_bit);
-	fe->i_suballoc_slot = cpu_to_le16(osb->slot_num);
+	fe->i_suballoc_slot = cpu_to_le16(inode_ac->ac_alloc_slot);
 	fe->i_uid = cpu_to_le32(current->fsuid);
 	if (dir->i_mode & S_ISGID) {
 		fe->i_gid = cpu_to_le32(dir->i_gid);
Index: ocfs2-1.2/fs/ocfs2/ocfs2.h
===================================================================
--- ocfs2-1.2.orig/fs/ocfs2/ocfs2.h	2008-04-30 13:59:12.000000000 +0800
+++ ocfs2-1.2/fs/ocfs2/ocfs2.h	2008-04-30 14:14:48.000000000 +0800
@@ -224,11 +224,14 @@ struct ocfs2_super
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
 
@@ -456,6 +459,33 @@ static inline unsigned long ocfs2_align_
 	return (unsigned long)((bytes + 511) >> 9);
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
Index: ocfs2-1.2/fs/ocfs2/suballoc.c
===================================================================
--- ocfs2-1.2.orig/fs/ocfs2/suballoc.c	2008-04-30 13:59:12.000000000 +0800
+++ ocfs2-1.2/fs/ocfs2/suballoc.c	2008-04-30 14:22:43.000000000 +0800
@@ -46,6 +46,11 @@
 
 #include "buffer_head_io.h"
 
+#define NOT_ALLOC_NEW_GROUP		0
+#define ALLOC_NEW_GROUP			1
+
+#define OCFS2_MAX_INODES_TO_STEAL	1024
+
 static inline void ocfs2_debug_bg(struct ocfs2_group_desc *bg);
 static inline void ocfs2_debug_suballoc_inode(struct ocfs2_dinode *fe);
 static inline u16 ocfs2_find_victim_chain(struct ocfs2_chain_list *cl);
@@ -60,7 +65,8 @@ static int ocfs2_block_group_alloc(struc
 				   struct buffer_head *bh);
 
 static int ocfs2_reserve_suballoc_bits(struct ocfs2_super *osb,
-				       struct ocfs2_alloc_context *ac);
+				       struct ocfs2_alloc_context *ac,
+				       int alloc_new_group);
 
 static int ocfs2_cluster_group_search(struct inode *inode,
 				      struct buffer_head *group_bh,
@@ -124,12 +130,21 @@ static inline void ocfs2_block_to_cluste
 						u64 *bg_blkno,
 						u16 *bg_bit_off);
 
-void ocfs2_free_alloc_context(struct ocfs2_alloc_context *ac)
+static void ocfs2_free_ac_resource(struct ocfs2_alloc_context *ac)
 {
-	if (ac->ac_inode)
+	if (ac->ac_inode) {
 		iput(ac->ac_inode);
-	if (ac->ac_bh)
+		ac->ac_inode = NULL;
+	}
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
 
@@ -407,7 +422,8 @@ bail:
 }
 
 static int ocfs2_reserve_suballoc_bits(struct ocfs2_super *osb,
-				       struct ocfs2_alloc_context *ac)
+				       struct ocfs2_alloc_context *ac,
+				       int alloc_new_group)
 {
 	int status;
 	u32 bits_wanted = ac->ac_bits_wanted;
@@ -453,6 +469,14 @@ static int ocfs2_reserve_suballoc_bits(s
 			goto bail;
 		}
 
+		if (alloc_new_group != ALLOC_NEW_GROUP) {
+			mlog(0, "Inode %llu Full: wanted=%u, free_bits=%u, "
+			     "and we don't alloc a new group for it.\n",
+			     le64_to_cpu(fe->i_blkno), bits_wanted, free_bits);
+			status = -ENOSPC;
+			goto bail;
+		}
+
 		status = ocfs2_block_group_alloc(osb, alloc_inode, bh);
 		if (status < 0) {
 			if (status != -ENOSPC)
@@ -514,7 +538,8 @@ int ocfs2_reserve_new_metadata(struct oc
 	(*ac)->ac_inode = igrab(alloc_inode);
 	(*ac)->ac_group_search = ocfs2_block_group_search;
 
-	status = ocfs2_reserve_suballoc_bits(osb, (*ac));
+	status = ocfs2_reserve_suballoc_bits(osb, (*ac),
+					     ALLOC_NEW_GROUP);
 	if (status < 0) {
 		if (status != -ENOSPC)
 			mlog_errno(status);
@@ -535,12 +560,64 @@ bail:
 	return status;
 }
 
+static int ocfs2_steal_inode_from_other_nodes(struct ocfs2_super *osb,
+					      struct ocfs2_alloc_context *ac)
+{
+	int i, status = -ENOSPC;
+	struct inode *alloc_inode;
+	s16 slot = ocfs2_get_inode_steal_slot(osb);
+
+	/* Start to steal inodes from the first slot after us. */
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
+		alloc_inode = ocfs2_get_system_file_inode(osb,
+						INODE_ALLOC_SYSTEM_INODE,
+						slot);
+		if (!alloc_inode) {
+			status = -ENOMEM;
+			mlog_errno(status);
+			break;
+		}
+
+		ac->ac_inode = alloc_inode;
+		ac->ac_alloc_slot = slot;
+
+		status = ocfs2_reserve_suballoc_bits(osb, ac,
+						     NOT_ALLOC_NEW_GROUP);
+		if (status >= 0) {
+			ocfs2_set_inode_steal_slot(osb, slot);
+			break;
+		}
+
+		/*
+		 * If we ran here, it means that the inode allcation fails.
+		 * Since the alloc inode is locked during the allocation,
+		 * we have to unlock it and remove it from our transaction.
+		 * Otherwise we may encounter a dead lock when other nodes
+		 * try to allocate inodes from out inode_alloc.
+		 */
+		ocfs2_handle_remove_alloc_inode(ac->ac_handle, alloc_inode);
+		ocfs2_free_ac_resource(ac);
+	}
+
+	return status;
+}
+
 int ocfs2_reserve_new_inode(struct ocfs2_super *osb,
 			    struct ocfs2_journal_handle *handle,
 			    struct ocfs2_alloc_context **ac)
 {
 	int status;
 	struct inode *alloc_inode = NULL;
+	s16 slot = ocfs2_get_inode_steal_slot(osb);
 
 	*ac = kcalloc(1, sizeof(struct ocfs2_alloc_context), GFP_KERNEL);
 	if (!(*ac)) {
@@ -552,6 +629,23 @@ int ocfs2_reserve_new_inode(struct ocfs2
 	(*ac)->ac_bits_wanted = 1;
 	(*ac)->ac_handle = handle;
 	(*ac)->ac_which = OCFS2_AC_USE_INODE;
+	(*ac)->ac_group_search = ocfs2_block_group_search;
+	(*ac)->ac_inode = NULL;
+
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
 
 	alloc_inode = ocfs2_get_system_file_inode(osb,
 						  INODE_ALLOC_SYSTEM_INODE,
@@ -562,10 +656,39 @@ int ocfs2_reserve_new_inode(struct ocfs2
 		goto bail;
 	}
 
-	(*ac)->ac_inode = igrab(alloc_inode);
-	(*ac)->ac_group_search = ocfs2_block_group_search;
+	(*ac)->ac_inode = alloc_inode;
+	(*ac)->ac_alloc_slot = osb->slot_num;
+
+	status = ocfs2_reserve_suballoc_bits(osb, *ac,
+					     ALLOC_NEW_GROUP);
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
 
-	status = ocfs2_reserve_suballoc_bits(osb, *ac);
+	/*
+	 * If we ran here, it means that the inode allcation fails.
+	 * Since the alloc inode is locked during the allocation,
+	 * we have to unlock it and remove it from our transaction.
+	 * Otherwise we may encounter a dead lock when other nodes
+	 * try to allocate inodes from out inode_alloc.
+	 */
+	ocfs2_handle_remove_alloc_inode((*ac)->ac_handle, alloc_inode);
+	ocfs2_free_ac_resource(*ac);
+
+inode_steal:
+	status = ocfs2_steal_inode_from_other_nodes(osb, *ac);
+	atomic_inc(&osb->s_num_inodes_stolen);
 	if (status < 0) {
 		if (status != -ENOSPC)
 			mlog_errno(status);
@@ -579,9 +702,6 @@ bail:
 		*ac = NULL;
 	}
 
-	if (alloc_inode)
-		iput(alloc_inode);
-
 	mlog_exit(status);
 	return status;
 }
@@ -604,7 +724,8 @@ int ocfs2_reserve_cluster_bitmap_bits(st
 	ac->ac_which = OCFS2_AC_USE_MAIN;
 	ac->ac_group_search = ocfs2_cluster_group_search;
 
-	status = ocfs2_reserve_suballoc_bits(osb, ac);
+	status = ocfs2_reserve_suballoc_bits(osb, ac,
+					     ALLOC_NEW_GROUP);
 	if (status < 0 && status != -ENOSPC)
 		mlog_errno(status);
 bail:
Index: ocfs2-1.2/fs/ocfs2/suballoc.h
===================================================================
--- ocfs2-1.2.orig/fs/ocfs2/suballoc.h	2008-04-30 13:59:12.000000000 +0800
+++ ocfs2-1.2/fs/ocfs2/suballoc.h	2008-04-30 14:13:45.000000000 +0800
@@ -36,6 +36,7 @@ typedef int (group_search_t)(struct inod
 struct ocfs2_alloc_context {
 	struct inode *ac_inode;    /* which bitmap are we allocating from? */
 	struct buffer_head *ac_bh; /* file entry bh */
+	u32    ac_alloc_slot;   /* which slot are we allocating from? */
 	u32    ac_bits_wanted;
 	u32    ac_bits_given;
 #define OCFS2_AC_USE_LOCAL 1
Index: ocfs2-1.2/fs/ocfs2/super.c
===================================================================
--- ocfs2-1.2.orig/fs/ocfs2/super.c	2008-04-30 13:59:12.000000000 +0800
+++ ocfs2-1.2/fs/ocfs2/super.c	2008-04-30 14:12:36.000000000 +0800
@@ -1371,6 +1371,7 @@ static int ocfs2_initialize_super(struct
 	osb->blocked_lock_count = 0;
 	INIT_LIST_HEAD(&osb->vote_list);
 	spin_lock_init(&osb->osb_lock);
+	ocfs2_init_inode_steal_slot(osb);
 
 	osb->osb_okp_teardown_next = NULL;
 	atomic_set(&osb->osb_okp_pending, 0);

-- 
