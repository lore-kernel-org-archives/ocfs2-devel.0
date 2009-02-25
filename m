From: Tao Ma <tao.ma@oracle.com>
Date: Thu, 26 Feb 2009 05:33:59 +0800
Subject: [Ocfs2-devel] [PATCH 1/3] ocfs2-1.4: Optimize inode allocation by
	remembering last group.
In-Reply-To: <49A6369F.5030208@oracle.com>
References: <49A6369F.5030208@oracle.com>
Message-ID: <1235597641-5840-1-git-send-email-tao.ma@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

In ocfs2, the inode block search looks for the "emptiest" inode
group to allocate from. So if an inode alloc file has many equally
(or almost equally) empty groups, new inodes will tend to get
spread out amongst them, which in turn can put them all over the
disk. This is undesirable because directory operations on conceptually
"nearby" inodes force a large number of seeks.

So we add ip_last_used_group in core directory inodes which records
the last used allocation group. Another field named ip_last_used_slot
is also added in case inode stealing happens. When claiming new inode,
we passed in directory's inode so that the allocation can use this
information.
For more details, please see
http://oss.oracle.com/osswiki/OCFS2/DesignDocs/InodeAllocationStrategy.

Signed-off-by: Tao Ma <tao.ma@oracle.com>
---
 fs/ocfs2/inode.c    |    2 ++
 fs/ocfs2/inode.h    |    4 ++++
 fs/ocfs2/namei.c    |    4 ++--
 fs/ocfs2/suballoc.c |   36 ++++++++++++++++++++++++++++++++++++
 fs/ocfs2/suballoc.h |    2 ++
 5 files changed, 46 insertions(+), 2 deletions(-)

diff --git a/fs/ocfs2/inode.c b/fs/ocfs2/inode.c
index ee6bf13..784761c 100644
--- a/fs/ocfs2/inode.c
+++ b/fs/ocfs2/inode.c
@@ -346,6 +346,8 @@ int ocfs2_populate_inode(struct inode *inode, struct ocfs2_dinode *fe,
 
 	ocfs2_set_inode_flags(inode);
 
+	OCFS2_I(inode)->ip_last_used_slot = 0;
+	OCFS2_I(inode)->ip_last_used_group = 0;
 	status = 0;
 bail:
 	mlog_exit(status);
diff --git a/fs/ocfs2/inode.h b/fs/ocfs2/inode.h
index 01437ca..077eb59 100644
--- a/fs/ocfs2/inode.h
+++ b/fs/ocfs2/inode.h
@@ -68,6 +68,10 @@ struct ocfs2_inode_info
 	struct ocfs2_extent_map		ip_extent_map;
 
 	struct inode			vfs_inode;
+
+	/* Only valid if the inode is the dir. */
+	u32				ip_last_used_slot;
+	u64				ip_last_used_group;
 };
 
 /*
diff --git a/fs/ocfs2/namei.c b/fs/ocfs2/namei.c
index c8206f9..eba1148 100644
--- a/fs/ocfs2/namei.c
+++ b/fs/ocfs2/namei.c
@@ -369,8 +369,8 @@ static int ocfs2_mknod_locked(struct ocfs2_super *osb,
 	*new_fe_bh = NULL;
 	*ret_inode = NULL;
 
-	status = ocfs2_claim_new_inode(osb, handle, inode_ac, &suballoc_bit,
-				       &fe_blkno);
+	status = ocfs2_claim_new_inode(osb, handle, dir, parent_fe_bh,
+				       inode_ac, &suballoc_bit, &fe_blkno);
 	if (status < 0) {
 		mlog_errno(status);
 		goto leave;
diff --git a/fs/ocfs2/suballoc.c b/fs/ocfs2/suballoc.c
index 228bf1c..0f1f2e9 100644
--- a/fs/ocfs2/suballoc.c
+++ b/fs/ocfs2/suballoc.c
@@ -1462,8 +1462,41 @@ bail:
 	return status;
 }
 
+static void ocfs2_init_inode_ac_group(struct inode *dir,
+				      struct buffer_head *parent_fe_bh,
+				      struct ocfs2_alloc_context *ac)
+{
+	struct ocfs2_dinode *fe = (struct ocfs2_dinode *)parent_fe_bh->b_data;
+	/*
+	 * Try to allocate inodes from some specific group.
+	 *
+	 * If the parent dir has recorded the last group used in allocation,
+	 * cool, use it. Otherwise if we try to allocate new inode from the
+	 * same slot the parent dir belongs to, use the same chunk.
+	 *
+	 * We are very careful here to avoid the mistake of setting
+	 * ac_last_group to a group descriptor from a different (unlocked) slot.
+	 */
+	if (OCFS2_I(dir)->ip_last_used_group &&
+	    OCFS2_I(dir)->ip_last_used_slot == ac->ac_alloc_slot)
+		ac->ac_last_group = OCFS2_I(dir)->ip_last_used_group;
+	else if (le16_to_cpu(fe->i_suballoc_slot) == ac->ac_alloc_slot)
+		ac->ac_last_group = ocfs2_which_suballoc_group(
+					le64_to_cpu(fe->i_blkno),
+					le16_to_cpu(fe->i_suballoc_bit));
+}
+
+static inline void ocfs2_save_inode_ac_group(struct inode *dir,
+					     struct ocfs2_alloc_context *ac)
+{
+	OCFS2_I(dir)->ip_last_used_group = ac->ac_last_group;
+	OCFS2_I(dir)->ip_last_used_slot = ac->ac_alloc_slot;
+}
+
 int ocfs2_claim_new_inode(struct ocfs2_super *osb,
 			  handle_t *handle,
+			  struct inode *dir,
+			  struct buffer_head *parent_fe_bh,
 			  struct ocfs2_alloc_context *ac,
 			  u16 *suballoc_bit,
 			  u64 *fe_blkno)
@@ -1479,6 +1512,8 @@ int ocfs2_claim_new_inode(struct ocfs2_super *osb,
 	BUG_ON(ac->ac_bits_wanted != 1);
 	BUG_ON(ac->ac_which != OCFS2_AC_USE_INODE);
 
+	ocfs2_init_inode_ac_group(dir, parent_fe_bh, ac);
+
 	status = ocfs2_claim_suballoc_bits(osb,
 					   ac,
 					   handle,
@@ -1497,6 +1532,7 @@ int ocfs2_claim_new_inode(struct ocfs2_super *osb,
 
 	*fe_blkno = bg_blkno + (u64) (*suballoc_bit);
 	ac->ac_bits_given++;
+	ocfs2_save_inode_ac_group(dir, ac);
 	status = 0;
 bail:
 	mlog_exit(status);
diff --git a/fs/ocfs2/suballoc.h b/fs/ocfs2/suballoc.h
index 40d51da..16f9c9c 100644
--- a/fs/ocfs2/suballoc.h
+++ b/fs/ocfs2/suballoc.h
@@ -77,6 +77,8 @@ int ocfs2_claim_metadata(struct ocfs2_super *osb,
 			 u64 *blkno_start);
 int ocfs2_claim_new_inode(struct ocfs2_super *osb,
 			  handle_t *handle,
+			  struct inode *dir,
+			  struct buffer_head *parent_fe_bh,
 			  struct ocfs2_alloc_context *ac,
 			  u16 *suballoc_bit,
 			  u64 *fe_blkno);
-- 
1.5.5
