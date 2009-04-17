From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Fri, 17 Apr 2009 13:37:25 -0700
Subject: [Ocfs2-devel] [PATCH 12/26] ocfs2: Optimize inode group allocation
	by recording last used group.
In-Reply-To: <1240000659-6201-1-git-send-email-sunil.mushran@oracle.com>
References: <1240000659-6201-1-git-send-email-sunil.mushran@oracle.com>
Message-ID: <1240000659-6201-13-git-send-email-sunil.mushran@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

From: Tao Ma <tao.ma@oracle.com>

Mainline commit feb473a6e8bd19297d0f3bb377b25055c0228c0a

In ocfs2, the block group search looks for the "emptiest" group
to allocate from. So if the allocator has many equally(or almost
equally) empty groups, new block group will tend to get spread
out amongst them.

So we add osb_inode_alloc_group in ocfs2_super to record the last
used inode allocation group.
For more details, please see
http://oss.oracle.com/osswiki/OCFS2/DesignDocs/InodeAllocationStrategy.

Signed-off-by: Tao Ma <tao.ma@oracle.com>
---
 fs/ocfs2/ocfs2.h    |    3 +++
 fs/ocfs2/suballoc.c |   32 ++++++++++++++++++++++++++++----
 2 files changed, 31 insertions(+), 4 deletions(-)

diff --git a/fs/ocfs2/ocfs2.h b/fs/ocfs2/ocfs2.h
index aa4fa41..7c79c84 100644
--- a/fs/ocfs2/ocfs2.h
+++ b/fs/ocfs2/ocfs2.h
@@ -317,6 +317,9 @@ struct ocfs2_super
 	struct ocfs2_node_map		osb_recovering_orphan_dirs;
 	unsigned int			*osb_orphan_wipes;
 	wait_queue_head_t		osb_wipe_event;
+
+	/* the group we used to allocate inodes. */
+	u64				osb_inode_alloc_group;
 };
 
 #define OCFS2_SB(sb)	    ((struct ocfs2_super *)(sb)->s_fs_info)
diff --git a/fs/ocfs2/suballoc.c b/fs/ocfs2/suballoc.c
index 13e7b88..ca91445 100644
--- a/fs/ocfs2/suballoc.c
+++ b/fs/ocfs2/suballoc.c
@@ -64,6 +64,7 @@ static int ocfs2_block_group_fill(handle_t *handle,
 static int ocfs2_block_group_alloc(struct ocfs2_super *osb,
 				   struct inode *alloc_inode,
 				   struct buffer_head *bh,
+				   u64 *last_alloc_group,
 				   int flags);
 
 static int ocfs2_cluster_group_search(struct inode *inode,
@@ -281,6 +282,7 @@ static inline u16 ocfs2_find_smallest_chain(struct ocfs2_chain_list *cl)
 static int ocfs2_block_group_alloc(struct ocfs2_super *osb,
 				   struct inode *alloc_inode,
 				   struct buffer_head *bh,
+				   u64 *last_alloc_group,
 				   int flags)
 {
 	int status, credits;
@@ -318,6 +320,11 @@ static int ocfs2_block_group_alloc(struct ocfs2_super *osb,
 		goto bail;
 	}
 
+	if (last_alloc_group && *last_alloc_group != 0) {
+		mlog(0, "use old allocation group %llu for block group alloc\n",
+		     (unsigned long long)*last_alloc_group);
+		ac->ac_last_group = *last_alloc_group;
+	}
 	status = ocfs2_claim_clusters(osb,
 				      handle,
 				      ac,
@@ -392,6 +399,11 @@ static int ocfs2_block_group_alloc(struct ocfs2_super *osb,
 	alloc_inode->i_blocks = ocfs2_inode_sector_count(alloc_inode);
 
 	status = 0;
+
+	/* save the new last alloc group so that the caller can cache it. */
+	if (last_alloc_group)
+		*last_alloc_group = ac->ac_last_group;
+
 bail:
 	if (handle)
 		ocfs2_commit_trans(osb, handle);
@@ -409,6 +421,7 @@ static int ocfs2_reserve_suballoc_bits(struct ocfs2_super *osb,
 				       struct ocfs2_alloc_context *ac,
 				       int type,
 				       u32 slot,
+				       u64 *last_alloc_group,
 				       int flags)
 {
 	int status;
@@ -473,7 +486,8 @@ static int ocfs2_reserve_suballoc_bits(struct ocfs2_super *osb,
 			goto bail;
 		}
 
-		status = ocfs2_block_group_alloc(osb, alloc_inode, bh, flags);
+		status = ocfs2_block_group_alloc(osb, alloc_inode, bh,
+						 last_alloc_group, flags);
 		if (status < 0) {
 			if (status != -ENOSPC)
 				mlog_errno(status);
@@ -517,7 +531,7 @@ int ocfs2_reserve_new_metadata(struct ocfs2_super *osb,
 
 	status = ocfs2_reserve_suballoc_bits(osb, (*ac),
 					     EXTENT_ALLOC_SYSTEM_INODE,
-					     slot, ALLOC_NEW_GROUP);
+					     slot, NULL, ALLOC_NEW_GROUP);
 	if (status < 0) {
 		if (status != -ENOSPC)
 			mlog_errno(status);
@@ -554,7 +568,8 @@ static int ocfs2_steal_inode_from_other_nodes(struct ocfs2_super *osb,
 
 		status = ocfs2_reserve_suballoc_bits(osb, ac,
 						     INODE_ALLOC_SYSTEM_INODE,
-						     slot, NOT_ALLOC_NEW_GROUP);
+						     slot, NULL,
+						     NOT_ALLOC_NEW_GROUP);
 		if (status >= 0) {
 			ocfs2_set_inode_steal_slot(osb, slot);
 			break;
@@ -571,6 +586,7 @@ int ocfs2_reserve_new_inode(struct ocfs2_super *osb,
 {
 	int status;
 	s16 slot = ocfs2_get_inode_steal_slot(osb);
+	u64 alloc_group;
 
 	*ac = kzalloc(sizeof(struct ocfs2_alloc_context), GFP_KERNEL);
 	if (!(*ac)) {
@@ -598,14 +614,22 @@ int ocfs2_reserve_new_inode(struct ocfs2_super *osb,
 		goto inode_steal;
 
 	atomic_set(&osb->s_num_inodes_stolen, 0);
+	alloc_group = osb->osb_inode_alloc_group;
 	status = ocfs2_reserve_suballoc_bits(osb, *ac,
 					     INODE_ALLOC_SYSTEM_INODE,
 					     osb->slot_num,
+					     &alloc_group,
 					     ALLOC_NEW_GROUP |
 					     ALLOC_GROUPS_FROM_GLOBAL);
 	if (status >= 0) {
 		status = 0;
 
+		spin_lock(&osb->osb_lock);
+		osb->osb_inode_alloc_group = alloc_group;
+		spin_unlock(&osb->osb_lock);
+		mlog(0, "after reservation, new allocation group is "
+		     "%llu\n", (unsigned long long)alloc_group);
+
 		/*
 		 * Some inodes must be freed by us, so try to allocate
 		 * from our own next time.
@@ -652,7 +676,7 @@ int ocfs2_reserve_cluster_bitmap_bits(struct ocfs2_super *osb,
 
 	status = ocfs2_reserve_suballoc_bits(osb, ac,
 					     GLOBAL_BITMAP_SYSTEM_INODE,
-					     OCFS2_INVALID_SLOT,
+					     OCFS2_INVALID_SLOT, NULL,
 					     ALLOC_NEW_GROUP);
 	if (status < 0 && status != -ENOSPC) {
 		mlog_errno(status);
-- 
1.5.6.3
