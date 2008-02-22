From: Tao Ma <tao.ma@oracle.com>
Date: Fri Feb 22 00:49:49 2008
Subject: [Ocfs2-devel] [PATCH 3/3] Add inode stealing for
	ocfs2_reserve_new_inode.V1
In-Reply-To: <20080222084149.GA29738@tma-pc1.cn.oracle.com>
Message-ID: <20080222084909.GA29825@tma-pc1.cn.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Add inode stealing for ocfs2_reserve_new_inode. Now the whole process is:
1. Allocate from its own inode_alloc:000X
   1) If we can reserve, OK.
   2) If fails, try to allocate a large chunk and reserve once again.
2. If 1 fails, try to allocate from the last node's inode_alloc. This time,
   Just try to reserve, we don't go for global_bitmap if this inode also
   can't allocate the inode.
3. If 2 fails, try the node before it until we reach inode_alloc:0000.
   In the process, we will skip its own inode_alloc.
4. If 3 fails, try to allocate from its own inode_alloc:000X once again. Here
   is a chance that the global_bitmap may has a large enough chunk now during
   the inode iteration process.

Signed-off-by: Tao Ma <tao.ma@oracle.com>
---
 fs/ocfs2/namei.c    |    2 +-
 fs/ocfs2/suballoc.c |   57 +++++++++++++++++++++++++++++++++++++++++++++++++-
 2 files changed, 56 insertions(+), 3 deletions(-)

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
diff --git a/fs/ocfs2/suballoc.c b/fs/ocfs2/suballoc.c
index 33d5573..cf89ce3 100644
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
 
@@ -522,6 +530,28 @@ bail:
 	return status;
 }
 
+static int ocfs2_steal_inode_from_other_nodes(struct ocfs2_super *osb,
+					      struct ocfs2_alloc_context *ac,
+					      int slot)
+{
+	int status = -ENOSPC, i;
+
+	for (i = osb->max_slots - 1; i >= 0; i--) {
+		if (i == slot)
+			continue;
+
+		status = ocfs2_reserve_suballoc_bits(osb, ac,
+						     INODE_ALLOC_SYSTEM_INODE,
+						     i, NOT_ALLOC_NEW_GROUP);
+		if (status >= 0)
+			break;
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
@@ -542,6 +572,29 @@ int ocfs2_reserve_new_inode(struct ocfs2_super *osb,
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
+	status = ocfs2_steal_inode_from_other_nodes(osb, *ac, osb->slot_num);
+	if (status >= 0) {
+		status = 0;
+		goto bail;
+	}
+
+	/*
+	 * We can't steal inode from other nodes, so try to allocate it from
+	 * our own once again.
+	 */
+	status = ocfs2_reserve_suballoc_bits(osb, *ac,
+					     INODE_ALLOC_SYSTEM_INODE,
+					     osb->slot_num, ALLOC_NEW_GROUP);
 	if (status < 0) {
 		if (status != -ENOSPC)
 			mlog_errno(status);
-- 
1.5.3.GIT
