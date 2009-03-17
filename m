From: Mark Fasheh <mfasheh@suse.com>
Date: Tue, 17 Mar 2009 13:01:04 -0700
Subject: [Ocfs2-devel] [PATCH 14/32] ocfs2: Optimize inode allocation by
	remembering last group
In-Reply-To: <1237320082-12921-1-git-send-email-mfasheh@suse.com>
References: <1237320082-12921-1-git-send-email-mfasheh@suse.com>
Message-ID: <1237320082-12921-15-git-send-email-mfasheh@suse.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-kernel@vger.kernel.org
Cc: ocfs2-devel@oss.oracle.com, Joel Becker <joel.becker@oracle.com>, Tao Ma <tao.ma@oracle.com>, Mark Fasheh <mfasheh@suse.com>

From: Tao Ma <tao.ma@oracle.com>

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
Signed-off-by: Mark Fasheh <mfasheh@suse.com>
---
 fs/ocfs2/inode.c    |    2 ++
 fs/ocfs2/inode.h    |    4 ++++
 fs/ocfs2/namei.c    |    4 ++--
 fs/ocfs2/suballoc.c |   36 ++++++++++++++++++++++++++++++++++++
 fs/ocfs2/suballoc.h |    2 ++
 5 files changed, 46 insertions(+), 2 deletions(-)

diff --git a/fs/ocfs2/inode.c b/fs/ocfs2/inode.c
index f1f77b2..4a88bce 100644
--- a/fs/ocfs2/inode.c
+++ b/fs/ocfs2/inode.c
@@ -352,6 +352,8 @@ void ocfs2_populate_inode(struct inode *inode, struct ocfs2_dinode *fe,
 
 	ocfs2_set_inode_flags(inode);
 
+	OCFS2_I(inode)->ip_last_used_slot = 0;
+	OCFS2_I(inode)->ip_last_used_group = 0;
 	mlog_exit_void();
 }
 
diff --git a/fs/ocfs2/inode.h b/fs/ocfs2/inode.h
index eb3c302..e1978ac 100644
--- a/fs/ocfs2/inode.h
+++ b/fs/ocfs2/inode.h
@@ -72,6 +72,10 @@ struct ocfs2_inode_info
 
 	struct inode			vfs_inode;
 	struct jbd2_inode		ip_jinode;
+
+	/* Only valid if the inode is the dir. */
+	u32				ip_last_used_slot;
+	u64				ip_last_used_group;
 };
 
 /*
diff --git a/fs/ocfs2/namei.c b/fs/ocfs2/namei.c
index 58c318d..2220f93 100644
--- a/fs/ocfs2/namei.c
+++ b/fs/ocfs2/namei.c
@@ -485,8 +485,8 @@ static int ocfs2_mknod_locked(struct ocfs2_super *osb,
 
 	*new_fe_bh = NULL;
 
-	status = ocfs2_claim_new_inode(osb, handle, inode_ac, &suballoc_bit,
-				       &fe_blkno);
+	status = ocfs2_claim_new_inode(osb, handle, dir, parent_fe_bh,
+				       inode_ac, &suballoc_bit, &fe_blkno);
 	if (status < 0) {
 		mlog_errno(status);
 		goto leave;
diff --git a/fs/ocfs2/suballoc.c b/fs/ocfs2/suballoc.c
index a696286..487f00c 100644
--- a/fs/ocfs2/suballoc.c
+++ b/fs/ocfs2/suballoc.c
@@ -1618,8 +1618,41 @@ bail:
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
@@ -1635,6 +1668,8 @@ int ocfs2_claim_new_inode(struct ocfs2_super *osb,
 	BUG_ON(ac->ac_bits_wanted != 1);
 	BUG_ON(ac->ac_which != OCFS2_AC_USE_INODE);
 
+	ocfs2_init_inode_ac_group(dir, parent_fe_bh, ac);
+
 	status = ocfs2_claim_suballoc_bits(osb,
 					   ac,
 					   handle,
@@ -1653,6 +1688,7 @@ int ocfs2_claim_new_inode(struct ocfs2_super *osb,
 
 	*fe_blkno = bg_blkno + (u64) (*suballoc_bit);
 	ac->ac_bits_given++;
+	ocfs2_save_inode_ac_group(dir, ac);
 	status = 0;
 bail:
 	mlog_exit(status);
diff --git a/fs/ocfs2/suballoc.h b/fs/ocfs2/suballoc.h
index e3c13c7..ea85a4c 100644
--- a/fs/ocfs2/suballoc.h
+++ b/fs/ocfs2/suballoc.h
@@ -88,6 +88,8 @@ int ocfs2_claim_metadata(struct ocfs2_super *osb,
 			 u64 *blkno_start);
 int ocfs2_claim_new_inode(struct ocfs2_super *osb,
 			  handle_t *handle,
+			  struct inode *dir,
+			  struct buffer_head *parent_fe_bh,
 			  struct ocfs2_alloc_context *ac,
 			  u16 *suballoc_bit,
 			  u64 *fe_blkno);
-- 
1.5.6
