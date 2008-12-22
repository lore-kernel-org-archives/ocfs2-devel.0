From: Mark Fasheh <mfasheh@suse.com>
Date: Mon, 22 Dec 2008 13:48:05 -0800
Subject: [Ocfs2-devel] [PATCH 24/56] ocfs2: Add quota calls for allocation
	and freeing of inodes and space
In-Reply-To: <1229982517-3455-1-git-send-email-mfasheh@suse.com>
References: <1229982517-3455-1-git-send-email-mfasheh@suse.com>
Message-ID: <1229982517-3455-25-git-send-email-mfasheh@suse.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-kernel@vger.kernel.org
Cc: ocfs2-devel@oss.oracle.com, Joel Becker <joel.becker@oracle.com>, Jan Kara <jack@suse.cz>, Mark Fasheh <mfasheh@suse.com>

From: Jan Kara <jack@suse.cz>

Add quota calls for allocation and freeing of inodes and space, also update
estimates on number of needed credits for a transaction. Move out inode
allocation from ocfs2_mknod_locked() because vfs_dq_init() must be called
outside of a transaction.

Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Mark Fasheh <mfasheh@suse.com>
---
 fs/ocfs2/alloc.c   |   20 +++++++++++-
 fs/ocfs2/aops.c    |   16 ++++++++--
 fs/ocfs2/dir.c     |   24 +++++++++++++-
 fs/ocfs2/file.c    |   72 +++++++++++++++++++++++++++++++++++++++++---
 fs/ocfs2/inode.c   |   10 +++++-
 fs/ocfs2/journal.h |   84 ++++++++++++++++++++++++++++++++++++++++++---------
 fs/ocfs2/namei.c   |   44 ++++++++++++++++++++++++--
 fs/ocfs2/xattr.c   |   14 +++++----
 8 files changed, 245 insertions(+), 39 deletions(-)

diff --git a/fs/ocfs2/alloc.c b/fs/ocfs2/alloc.c
index 69d67ab..84a7bd4 100644
--- a/fs/ocfs2/alloc.c
+++ b/fs/ocfs2/alloc.c
@@ -28,6 +28,7 @@
 #include <linux/slab.h>
 #include <linux/highmem.h>
 #include <linux/swap.h>
+#include <linux/quotaops.h>
 
 #define MLOG_MASK_PREFIX ML_DISK_ALLOC
 #include <cluster/masklog.h>
@@ -5322,7 +5323,7 @@ int ocfs2_remove_btree_range(struct inode *inode,
 		}
 	}
 
-	handle = ocfs2_start_trans(osb, OCFS2_REMOVE_EXTENT_CREDITS);
+	handle = ocfs2_start_trans(osb, ocfs2_remove_extent_credits(osb->sb));
 	if (IS_ERR(handle)) {
 		ret = PTR_ERR(handle);
 		mlog_errno(ret);
@@ -6552,6 +6553,8 @@ static int ocfs2_do_truncate(struct ocfs2_super *osb,
 		goto bail;
 	}
 
+	vfs_dq_free_space_nodirty(inode,
+			ocfs2_clusters_to_bytes(osb->sb, clusters_to_del));
 	spin_lock(&OCFS2_I(inode)->ip_lock);
 	OCFS2_I(inode)->ip_clusters = le32_to_cpu(fe->i_clusters) -
 				      clusters_to_del;
@@ -6860,6 +6863,7 @@ int ocfs2_convert_inline_data_to_extents(struct inode *inode,
 	struct page **pages = NULL;
 	loff_t end = osb->s_clustersize;
 	struct ocfs2_extent_tree et;
+	int did_quota = 0;
 
 	has_data = i_size_read(inode) ? 1 : 0;
 
@@ -6879,7 +6883,8 @@ int ocfs2_convert_inline_data_to_extents(struct inode *inode,
 		}
 	}
 
-	handle = ocfs2_start_trans(osb, OCFS2_INLINE_TO_EXTENTS_CREDITS);
+	handle = ocfs2_start_trans(osb,
+				   ocfs2_inline_to_extents_credits(osb->sb));
 	if (IS_ERR(handle)) {
 		ret = PTR_ERR(handle);
 		mlog_errno(ret);
@@ -6898,6 +6903,13 @@ int ocfs2_convert_inline_data_to_extents(struct inode *inode,
 		unsigned int page_end;
 		u64 phys;
 
+		if (vfs_dq_alloc_space_nodirty(inode,
+				       ocfs2_clusters_to_bytes(osb->sb, 1))) {
+			ret = -EDQUOT;
+			goto out_commit;
+		}
+		did_quota = 1;
+
 		ret = ocfs2_claim_clusters(osb, handle, data_ac, 1, &bit_off,
 					   &num);
 		if (ret) {
@@ -6971,6 +6983,10 @@ int ocfs2_convert_inline_data_to_extents(struct inode *inode,
 	}
 
 out_commit:
+	if (ret < 0 && did_quota)
+		vfs_dq_free_space_nodirty(inode,
+					  ocfs2_clusters_to_bytes(osb->sb, 1));
+
 	ocfs2_commit_trans(osb, handle);
 
 out_unlock:
diff --git a/fs/ocfs2/aops.c b/fs/ocfs2/aops.c
index 6af79ad..6b647ec 100644
--- a/fs/ocfs2/aops.c
+++ b/fs/ocfs2/aops.c
@@ -27,6 +27,7 @@
 #include <linux/swap.h>
 #include <linux/pipe_fs_i.h>
 #include <linux/mpage.h>
+#include <linux/quotaops.h>
 
 #define MLOG_MASK_PREFIX ML_FILE_IO
 #include <cluster/masklog.h>
@@ -1730,6 +1731,11 @@ int ocfs2_write_begin_nolock(struct address_space *mapping,
 
 	wc->w_handle = handle;
 
+	if (clusters_to_alloc && vfs_dq_alloc_space_nodirty(inode,
+			ocfs2_clusters_to_bytes(osb->sb, clusters_to_alloc))) {
+		ret = -EDQUOT;
+		goto out_commit;
+	}
 	/*
 	 * We don't want this to fail in ocfs2_write_end(), so do it
 	 * here.
@@ -1738,7 +1744,7 @@ int ocfs2_write_begin_nolock(struct address_space *mapping,
 				   OCFS2_JOURNAL_ACCESS_WRITE);
 	if (ret) {
 		mlog_errno(ret);
-		goto out_commit;
+		goto out_quota;
 	}
 
 	/*
@@ -1751,14 +1757,14 @@ int ocfs2_write_begin_nolock(struct address_space *mapping,
 					 mmap_page);
 	if (ret) {
 		mlog_errno(ret);
-		goto out_commit;
+		goto out_quota;
 	}
 
 	ret = ocfs2_write_cluster_by_desc(mapping, data_ac, meta_ac, wc, pos,
 					  len);
 	if (ret) {
 		mlog_errno(ret);
-		goto out_commit;
+		goto out_quota;
 	}
 
 	if (data_ac)
@@ -1770,6 +1776,10 @@ success:
 	*pagep = wc->w_target_page;
 	*fsdata = wc;
 	return 0;
+out_quota:
+	if (clusters_to_alloc)
+		vfs_dq_free_space(inode,
+			  ocfs2_clusters_to_bytes(osb->sb, clusters_to_alloc));
 out_commit:
 	ocfs2_commit_trans(osb, handle);
 
diff --git a/fs/ocfs2/dir.c b/fs/ocfs2/dir.c
index d83cff9..3708fe4 100644
--- a/fs/ocfs2/dir.c
+++ b/fs/ocfs2/dir.c
@@ -40,6 +40,7 @@
 #include <linux/types.h>
 #include <linux/slab.h>
 #include <linux/highmem.h>
+#include <linux/quotaops.h>
 
 #define MLOG_MASK_PREFIX ML_NAMEI
 #include <cluster/masklog.h>
@@ -1210,9 +1211,9 @@ static int ocfs2_expand_inline_dir(struct inode *dir, struct buffer_head *di_bh,
 				   unsigned int blocks_wanted,
 				   struct buffer_head **first_block_bh)
 {
-	int ret, credits = OCFS2_INLINE_TO_EXTENTS_CREDITS;
 	u32 alloc, bit_off, len;
 	struct super_block *sb = dir->i_sb;
+	int ret, credits = ocfs2_inline_to_extents_credits(sb);
 	u64 blkno, bytes = blocks_wanted << sb->s_blocksize_bits;
 	struct ocfs2_super *osb = OCFS2_SB(dir->i_sb);
 	struct ocfs2_inode_info *oi = OCFS2_I(dir);
@@ -1221,6 +1222,7 @@ static int ocfs2_expand_inline_dir(struct inode *dir, struct buffer_head *di_bh,
 	struct ocfs2_dinode *di = (struct ocfs2_dinode *)di_bh->b_data;
 	handle_t *handle;
 	struct ocfs2_extent_tree et;
+	int did_quota = 0;
 
 	ocfs2_init_dinode_extent_tree(&et, dir, di_bh);
 
@@ -1258,6 +1260,12 @@ static int ocfs2_expand_inline_dir(struct inode *dir, struct buffer_head *di_bh,
 		goto out_sem;
 	}
 
+	if (vfs_dq_alloc_space_nodirty(dir,
+				ocfs2_clusters_to_bytes(osb->sb, alloc))) {
+		ret = -EDQUOT;
+		goto out_commit;
+	}
+	did_quota = 1;
 	/*
 	 * Try to claim as many clusters as the bitmap can give though
 	 * if we only get one now, that's enough to continue. The rest
@@ -1380,6 +1388,9 @@ static int ocfs2_expand_inline_dir(struct inode *dir, struct buffer_head *di_bh,
 	dirdata_bh = NULL;
 
 out_commit:
+	if (ret < 0 && did_quota)
+		vfs_dq_free_space_nodirty(dir,
+			ocfs2_clusters_to_bytes(osb->sb, 2));
 	ocfs2_commit_trans(osb, handle);
 
 out_sem:
@@ -1404,7 +1415,7 @@ static int ocfs2_do_extend_dir(struct super_block *sb,
 			       struct buffer_head **new_bh)
 {
 	int status;
-	int extend;
+	int extend, did_quota = 0;
 	u64 p_blkno, v_blkno;
 
 	spin_lock(&OCFS2_I(dir)->ip_lock);
@@ -1414,6 +1425,13 @@ static int ocfs2_do_extend_dir(struct super_block *sb,
 	if (extend) {
 		u32 offset = OCFS2_I(dir)->ip_clusters;
 
+		if (vfs_dq_alloc_space_nodirty(dir,
+					ocfs2_clusters_to_bytes(sb, 1))) {
+			status = -EDQUOT;
+			goto bail;
+		}
+		did_quota = 1;
+
 		status = ocfs2_add_inode_data(OCFS2_SB(sb), dir, &offset,
 					      1, 0, parent_fe_bh, handle,
 					      data_ac, meta_ac, NULL);
@@ -1439,6 +1457,8 @@ static int ocfs2_do_extend_dir(struct super_block *sb,
 	}
 	status = 0;
 bail:
+	if (did_quota && status < 0)
+		vfs_dq_free_space_nodirty(dir, ocfs2_clusters_to_bytes(sb, 1));
 	mlog_exit(status);
 	return status;
 }
diff --git a/fs/ocfs2/file.c b/fs/ocfs2/file.c
index 372d965..9374d37 100644
--- a/fs/ocfs2/file.c
+++ b/fs/ocfs2/file.c
@@ -35,6 +35,7 @@
 #include <linux/mount.h>
 #include <linux/writeback.h>
 #include <linux/falloc.h>
+#include <linux/quotaops.h>
 
 #define MLOG_MASK_PREFIX ML_INODE
 #include <cluster/masklog.h>
@@ -57,6 +58,7 @@
 #include "super.h"
 #include "xattr.h"
 #include "acl.h"
+#include "quota.h"
 
 #include "buffer_head_io.h"
 
@@ -534,6 +536,7 @@ static int __ocfs2_extend_allocation(struct inode *inode, u32 logical_start,
 	enum ocfs2_alloc_restarted why;
 	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
 	struct ocfs2_extent_tree et;
+	int did_quota = 0;
 
 	mlog_entry("(clusters_to_add = %u)\n", clusters_to_add);
 
@@ -577,6 +580,13 @@ restart_all:
 	}
 
 restarted_transaction:
+	if (vfs_dq_alloc_space_nodirty(inode, ocfs2_clusters_to_bytes(osb->sb,
+	    clusters_to_add))) {
+		status = -EDQUOT;
+		goto leave;
+	}
+	did_quota = 1;
+
 	/* reserve a write to the file entry early on - that we if we
 	 * run out of credits in the allocation path, we can still
 	 * update i_size. */
@@ -614,6 +624,10 @@ restarted_transaction:
 	spin_lock(&OCFS2_I(inode)->ip_lock);
 	clusters_to_add -= (OCFS2_I(inode)->ip_clusters - prev_clusters);
 	spin_unlock(&OCFS2_I(inode)->ip_lock);
+	/* Release unused quota reservation */
+	vfs_dq_free_space(inode,
+			ocfs2_clusters_to_bytes(osb->sb, clusters_to_add));
+	did_quota = 0;
 
 	if (why != RESTART_NONE && clusters_to_add) {
 		if (why == RESTART_META) {
@@ -646,6 +660,9 @@ restarted_transaction:
 	     OCFS2_I(inode)->ip_clusters, (long long)i_size_read(inode));
 
 leave:
+	if (status < 0 && did_quota)
+		vfs_dq_free_space(inode,
+			ocfs2_clusters_to_bytes(osb->sb, clusters_to_add));
 	if (handle) {
 		ocfs2_commit_trans(osb, handle);
 		handle = NULL;
@@ -877,6 +894,9 @@ int ocfs2_setattr(struct dentry *dentry, struct iattr *attr)
 	struct ocfs2_super *osb = OCFS2_SB(sb);
 	struct buffer_head *bh = NULL;
 	handle_t *handle = NULL;
+	int locked[MAXQUOTAS] = {0, 0};
+	int credits, qtype;
+	struct ocfs2_mem_dqinfo *oinfo;
 
 	mlog_entry("(0x%p, '%.*s')\n", dentry,
 	           dentry->d_name.len, dentry->d_name.name);
@@ -947,11 +967,47 @@ int ocfs2_setattr(struct dentry *dentry, struct iattr *attr)
 		}
 	}
 
-	handle = ocfs2_start_trans(osb, OCFS2_INODE_UPDATE_CREDITS);
-	if (IS_ERR(handle)) {
-		status = PTR_ERR(handle);
-		mlog_errno(status);
-		goto bail_unlock;
+	if ((attr->ia_valid & ATTR_UID && attr->ia_uid != inode->i_uid) ||
+	    (attr->ia_valid & ATTR_GID && attr->ia_gid != inode->i_gid)) {
+		credits = OCFS2_INODE_UPDATE_CREDITS;
+		if (attr->ia_valid & ATTR_UID && attr->ia_uid != inode->i_uid
+		    && OCFS2_HAS_RO_COMPAT_FEATURE(sb,
+		    OCFS2_FEATURE_RO_COMPAT_USRQUOTA)) {
+			oinfo = sb_dqinfo(sb, USRQUOTA)->dqi_priv;
+			status = ocfs2_lock_global_qf(oinfo, 1);
+			if (status < 0)
+				goto bail_unlock;
+			credits += ocfs2_calc_qinit_credits(sb, USRQUOTA) +
+				ocfs2_calc_qdel_credits(sb, USRQUOTA);
+			locked[USRQUOTA] = 1;
+		}
+		if (attr->ia_valid & ATTR_GID && attr->ia_gid != inode->i_gid
+		    && OCFS2_HAS_RO_COMPAT_FEATURE(sb,
+		    OCFS2_FEATURE_RO_COMPAT_GRPQUOTA)) {
+			oinfo = sb_dqinfo(sb, GRPQUOTA)->dqi_priv;
+			status = ocfs2_lock_global_qf(oinfo, 1);
+			if (status < 0)
+				goto bail_unlock;
+			credits += ocfs2_calc_qinit_credits(sb, GRPQUOTA) +
+				   ocfs2_calc_qdel_credits(sb, GRPQUOTA);
+			locked[GRPQUOTA] = 1;
+		}
+		handle = ocfs2_start_trans(osb, credits);
+		if (IS_ERR(handle)) {
+			status = PTR_ERR(handle);
+			mlog_errno(status);
+			goto bail_unlock;
+		}
+		status = vfs_dq_transfer(inode, attr) ? -EDQUOT : 0;
+		if (status < 0)
+			goto bail_commit;
+	} else {
+		handle = ocfs2_start_trans(osb, OCFS2_INODE_UPDATE_CREDITS);
+		if (IS_ERR(handle)) {
+			status = PTR_ERR(handle);
+			mlog_errno(status);
+			goto bail_unlock;
+		}
 	}
 
 	/*
@@ -974,6 +1030,12 @@ int ocfs2_setattr(struct dentry *dentry, struct iattr *attr)
 bail_commit:
 	ocfs2_commit_trans(osb, handle);
 bail_unlock:
+	for (qtype = 0; qtype < MAXQUOTAS; qtype++) {
+		if (!locked[qtype])
+			continue;
+		oinfo = sb_dqinfo(sb, qtype)->dqi_priv;
+		ocfs2_unlock_global_qf(oinfo, 1);
+	}
 	ocfs2_inode_unlock(inode, 1);
 bail_unlock_rw:
 	if (size_change)
diff --git a/fs/ocfs2/inode.c b/fs/ocfs2/inode.c
index 50dbc48..288512c 100644
--- a/fs/ocfs2/inode.c
+++ b/fs/ocfs2/inode.c
@@ -28,6 +28,7 @@
 #include <linux/slab.h>
 #include <linux/highmem.h>
 #include <linux/pagemap.h>
+#include <linux/quotaops.h>
 
 #include <asm/byteorder.h>
 
@@ -603,7 +604,8 @@ static int ocfs2_remove_inode(struct inode *inode,
 		goto bail;
 	}
 
-	handle = ocfs2_start_trans(osb, OCFS2_DELETE_INODE_CREDITS);
+	handle = ocfs2_start_trans(osb, OCFS2_DELETE_INODE_CREDITS +
+					ocfs2_quota_trans_credits(inode->i_sb));
 	if (IS_ERR(handle)) {
 		status = PTR_ERR(handle);
 		mlog_errno(status);
@@ -635,6 +637,7 @@ static int ocfs2_remove_inode(struct inode *inode,
 	}
 
 	ocfs2_remove_from_cache(inode, di_bh);
+	vfs_dq_free_inode(inode);
 
 	status = ocfs2_free_dinode(handle, inode_alloc_inode,
 				   inode_alloc_bh, di);
@@ -917,7 +920,10 @@ void ocfs2_delete_inode(struct inode *inode)
 
 	mlog_entry("(inode->i_ino = %lu)\n", inode->i_ino);
 
-	if (is_bad_inode(inode)) {
+	/* When we fail in read_inode() we mark inode as bad. The second test
+	 * catches the case when inode allocation fails before allocating
+	 * a block for inode. */
+	if (is_bad_inode(inode) || !OCFS2_I(inode)->ip_blkno) {
 		mlog(0, "Skipping delete of bad inode\n");
 		goto bail;
 	}
diff --git a/fs/ocfs2/journal.h b/fs/ocfs2/journal.h
index 8203980..ee08e9c 100644
--- a/fs/ocfs2/journal.h
+++ b/fs/ocfs2/journal.h
@@ -284,6 +284,37 @@ int                  ocfs2_journal_dirty(handle_t *handle,
 /* extended attribute block update */
 #define OCFS2_XATTR_BLOCK_UPDATE_CREDITS 1
 
+/* global quotafile inode update, data block */
+#define OCFS2_QINFO_WRITE_CREDITS (OCFS2_INODE_UPDATE_CREDITS + 1)
+
+/*
+ * The two writes below can accidentally see global info dirty due
+ * to set_info() quotactl so make them prepared for the writes.
+ */
+/* quota data block, global info */
+/* Write to local quota file */
+#define OCFS2_QWRITE_CREDITS (OCFS2_QINFO_WRITE_CREDITS + 1)
+
+/* global quota data block, local quota data block, global quota inode,
+ * global quota info */
+#define OCFS2_QSYNC_CREDITS (OCFS2_INODE_UPDATE_CREDITS + 3)
+
+static inline int ocfs2_quota_trans_credits(struct super_block *sb)
+{
+	int credits = 0;
+
+	if (OCFS2_HAS_RO_COMPAT_FEATURE(sb, OCFS2_FEATURE_RO_COMPAT_USRQUOTA))
+		credits += OCFS2_QWRITE_CREDITS;
+	if (OCFS2_HAS_RO_COMPAT_FEATURE(sb, OCFS2_FEATURE_RO_COMPAT_GRPQUOTA))
+		credits += OCFS2_QWRITE_CREDITS;
+	return credits;
+}
+
+/* Number of credits needed for removing quota structure from file */
+int ocfs2_calc_qdel_credits(struct super_block *sb, int type);
+/* Number of credits needed for initialization of new quota structure */
+int ocfs2_calc_qinit_credits(struct super_block *sb, int type);
+
 /* group extend. inode update and last group update. */
 #define OCFS2_GROUP_EXTEND_CREDITS	(OCFS2_INODE_UPDATE_CREDITS + 1)
 
@@ -294,8 +325,11 @@ int                  ocfs2_journal_dirty(handle_t *handle,
  * prev. group desc. if we relink. */
 #define OCFS2_SUBALLOC_ALLOC (3)
 
-#define OCFS2_INLINE_TO_EXTENTS_CREDITS (OCFS2_SUBALLOC_ALLOC		\
-					 + OCFS2_INODE_UPDATE_CREDITS)
+static inline int ocfs2_inline_to_extents_credits(struct super_block *sb)
+{
+	return OCFS2_SUBALLOC_ALLOC + OCFS2_INODE_UPDATE_CREDITS +
+	       ocfs2_quota_trans_credits(sb);
+}
 
 /* dinode + group descriptor update. We don't relink on free yet. */
 #define OCFS2_SUBALLOC_FREE  (2)
@@ -304,16 +338,23 @@ int                  ocfs2_journal_dirty(handle_t *handle,
 #define OCFS2_TRUNCATE_LOG_FLUSH_ONE_REC (OCFS2_SUBALLOC_FREE 		      \
 					 + OCFS2_TRUNCATE_LOG_UPDATE)
 
-#define OCFS2_REMOVE_EXTENT_CREDITS (OCFS2_TRUNCATE_LOG_UPDATE + OCFS2_INODE_UPDATE_CREDITS)
+static inline int ocfs2_remove_extent_credits(struct super_block *sb)
+{
+	return OCFS2_TRUNCATE_LOG_UPDATE + OCFS2_INODE_UPDATE_CREDITS +
+	       ocfs2_quota_trans_credits(sb);
+}
 
 /* data block for new dir/symlink, 2 for bitmap updates (bitmap fe +
  * bitmap block for the new bit) */
 #define OCFS2_DIR_LINK_ADDITIONAL_CREDITS (1 + 2)
 
 /* parent fe, parent block, new file entry, inode alloc fe, inode alloc
- * group descriptor + mkdir/symlink blocks */
-#define OCFS2_MKNOD_CREDITS (3 + OCFS2_SUBALLOC_ALLOC                         \
-			    + OCFS2_DIR_LINK_ADDITIONAL_CREDITS)
+ * group descriptor + mkdir/symlink blocks + quota update */
+static inline int ocfs2_mknod_credits(struct super_block *sb)
+{
+	return 3 + OCFS2_SUBALLOC_ALLOC + OCFS2_DIR_LINK_ADDITIONAL_CREDITS +
+	       ocfs2_quota_trans_credits(sb);
+}
 
 /* local alloc metadata change + main bitmap updates */
 #define OCFS2_WINDOW_MOVE_CREDITS (OCFS2_INODE_UPDATE_CREDITS                 \
@@ -323,13 +364,21 @@ int                  ocfs2_journal_dirty(handle_t *handle,
  * for the dinode, one for the new block. */
 #define OCFS2_SIMPLE_DIR_EXTEND_CREDITS (2)
 
-/* file update (nlink, etc) + directory mtime/ctime + dir entry block */
-#define OCFS2_LINK_CREDITS  (2*OCFS2_INODE_UPDATE_CREDITS + 1)
+/* file update (nlink, etc) + directory mtime/ctime + dir entry block + quota
+ * update on dir */
+static inline int ocfs2_link_credits(struct super_block *sb)
+{
+	return 2*OCFS2_INODE_UPDATE_CREDITS + 1 +
+	       ocfs2_quota_trans_credits(sb);
+}
 
 /* inode + dir inode (if we unlink a dir), + dir entry block + orphan
  * dir inode link */
-#define OCFS2_UNLINK_CREDITS  (2 * OCFS2_INODE_UPDATE_CREDITS + 1             \
-			      + OCFS2_LINK_CREDITS)
+static inline int ocfs2_unlink_credits(struct super_block *sb)
+{
+	/* The quota update from ocfs2_link_credits is unused here... */
+	return 2 * OCFS2_INODE_UPDATE_CREDITS + 1 + ocfs2_link_credits(sb);
+}
 
 /* dinode + orphan dir dinode + inode alloc dinode + orphan dir entry +
  * inode alloc group descriptor */
@@ -338,8 +387,10 @@ int                  ocfs2_journal_dirty(handle_t *handle,
 /* dinode update, old dir dinode update, new dir dinode update, old
  * dir dir entry, new dir dir entry, dir entry update for renaming
  * directory + target unlink */
-#define OCFS2_RENAME_CREDITS (3 * OCFS2_INODE_UPDATE_CREDITS + 3              \
-			     + OCFS2_UNLINK_CREDITS)
+static inline int ocfs2_rename_credits(struct super_block *sb)
+{
+	return 3 * OCFS2_INODE_UPDATE_CREDITS + 3 + ocfs2_unlink_credits(sb);
+}
 
 /* global bitmap dinode, group desc., relinked group,
  * suballocator dinode, group desc., relinked group,
@@ -377,18 +428,19 @@ static inline int ocfs2_calc_extend_credits(struct super_block *sb,
 	 * credit for the dinode there. */
 	extent_blocks = 1 + 1 + le16_to_cpu(root_el->l_tree_depth);
 
-	return bitmap_blocks + sysfile_bitmap_blocks + extent_blocks;
+	return bitmap_blocks + sysfile_bitmap_blocks + extent_blocks +
+	       ocfs2_quota_trans_credits(sb);
 }
 
 static inline int ocfs2_calc_symlink_credits(struct super_block *sb)
 {
-	int blocks = OCFS2_MKNOD_CREDITS;
+	int blocks = ocfs2_mknod_credits(sb);
 
 	/* links can be longer than one block so we may update many
 	 * within our single allocated extent. */
 	blocks += ocfs2_clusters_to_blocks(sb, 1);
 
-	return blocks;
+	return blocks + ocfs2_quota_trans_credits(sb);
 }
 
 static inline int ocfs2_calc_group_alloc_credits(struct super_block *sb,
@@ -425,6 +477,8 @@ static inline int ocfs2_calc_tree_trunc_credits(struct super_block *sb,
 	/* update to the truncate log. */
 	credits += OCFS2_TRUNCATE_LOG_UPDATE;
 
+	credits += ocfs2_quota_trans_credits(sb);
+
 	return credits;
 }
 
diff --git a/fs/ocfs2/namei.c b/fs/ocfs2/namei.c
index 98fd325..02c8026 100644
--- a/fs/ocfs2/namei.c
+++ b/fs/ocfs2/namei.c
@@ -40,6 +40,7 @@
 #include <linux/types.h>
 #include <linux/slab.h>
 #include <linux/highmem.h>
+#include <linux/quotaops.h>
 
 #define MLOG_MASK_PREFIX ML_NAMEI
 #include <cluster/masklog.h>
@@ -212,6 +213,7 @@ static struct inode *ocfs2_get_init_inode(struct inode *dir, int mode)
 	} else
 		inode->i_gid = current->fsgid;
 	inode->i_mode = mode;
+	vfs_dq_init(inode);
 	return inode;
 }
 
@@ -236,6 +238,7 @@ static int ocfs2_mknod(struct inode *dir,
 	struct ocfs2_security_xattr_info si = {
 		.enable = 1,
 	};
+	int did_quota_inode = 0;
 
 	mlog_entry("(0x%p, 0x%p, %d, %lu, '%.*s')\n", dir, dentry, mode,
 		   (unsigned long)dev, dentry->d_name.len,
@@ -323,7 +326,8 @@ static int ocfs2_mknod(struct inode *dir,
 		goto leave;
 	}
 
-	handle = ocfs2_start_trans(osb, OCFS2_MKNOD_CREDITS + xattr_credits);
+	handle = ocfs2_start_trans(osb, ocfs2_mknod_credits(osb->sb) +
+				   xattr_credits);
 	if (IS_ERR(handle)) {
 		status = PTR_ERR(handle);
 		handle = NULL;
@@ -331,6 +335,15 @@ static int ocfs2_mknod(struct inode *dir,
 		goto leave;
 	}
 
+	/* We don't use standard VFS wrapper because we don't want vfs_dq_init
+	 * to be called. */
+	if (sb_any_quota_active(osb->sb) &&
+	    osb->sb->dq_op->alloc_inode(inode, 1) == NO_QUOTA) {
+		status = -EDQUOT;
+		goto leave;
+	}
+	did_quota_inode = 1;
+
 	/* do the real work now. */
 	status = ocfs2_mknod_locked(osb, dir, inode, dentry, dev,
 				    &new_fe_bh, parent_fe_bh, handle,
@@ -399,6 +412,8 @@ static int ocfs2_mknod(struct inode *dir,
 	d_instantiate(dentry, inode);
 	status = 0;
 leave:
+	if (status < 0 && did_quota_inode)
+		vfs_dq_free_inode(inode);
 	if (handle)
 		ocfs2_commit_trans(osb, handle);
 
@@ -641,7 +656,7 @@ static int ocfs2_link(struct dentry *old_dentry,
 		goto out_unlock_inode;
 	}
 
-	handle = ocfs2_start_trans(osb, OCFS2_LINK_CREDITS);
+	handle = ocfs2_start_trans(osb, ocfs2_link_credits(osb->sb));
 	if (IS_ERR(handle)) {
 		err = PTR_ERR(handle);
 		handle = NULL;
@@ -828,7 +843,7 @@ static int ocfs2_unlink(struct inode *dir,
 		}
 	}
 
-	handle = ocfs2_start_trans(osb, OCFS2_UNLINK_CREDITS);
+	handle = ocfs2_start_trans(osb, ocfs2_unlink_credits(osb->sb));
 	if (IS_ERR(handle)) {
 		status = PTR_ERR(handle);
 		handle = NULL;
@@ -1234,7 +1249,7 @@ static int ocfs2_rename(struct inode *old_dir,
 		}
 	}
 
-	handle = ocfs2_start_trans(osb, OCFS2_RENAME_CREDITS);
+	handle = ocfs2_start_trans(osb, ocfs2_rename_credits(osb->sb));
 	if (IS_ERR(handle)) {
 		status = PTR_ERR(handle);
 		handle = NULL;
@@ -1555,6 +1570,7 @@ static int ocfs2_symlink(struct inode *dir,
 	struct ocfs2_security_xattr_info si = {
 		.enable = 1,
 	};
+	int did_quota = 0, did_quota_inode = 0;
 
 	mlog_entry("(0x%p, 0x%p, symname='%s' actual='%.*s')\n", dir,
 		   dentry, symname, dentry->d_name.len, dentry->d_name.name);
@@ -1648,6 +1664,15 @@ static int ocfs2_symlink(struct inode *dir,
 		goto bail;
 	}
 
+	/* We don't use standard VFS wrapper because we don't want vfs_dq_init
+	 * to be called. */
+	if (sb_any_quota_active(osb->sb) &&
+	    osb->sb->dq_op->alloc_inode(inode, 1) == NO_QUOTA) {
+		status = -EDQUOT;
+		goto bail;
+	}
+	did_quota_inode = 1;
+
 	status = ocfs2_mknod_locked(osb, dir, inode, dentry,
 				    0, &new_fe_bh, parent_fe_bh, handle,
 				    inode_ac);
@@ -1663,6 +1688,12 @@ static int ocfs2_symlink(struct inode *dir,
 		u32 offset = 0;
 
 		inode->i_op = &ocfs2_symlink_inode_operations;
+		if (vfs_dq_alloc_space_nodirty(inode,
+		    ocfs2_clusters_to_bytes(osb->sb, 1))) {
+			status = -EDQUOT;
+			goto bail;
+		}
+		did_quota = 1;
 		status = ocfs2_add_inode_data(osb, inode, &offset, 1, 0,
 					      new_fe_bh,
 					      handle, data_ac, NULL,
@@ -1728,6 +1759,11 @@ static int ocfs2_symlink(struct inode *dir,
 	dentry->d_op = &ocfs2_dentry_ops;
 	d_instantiate(dentry, inode);
 bail:
+	if (status < 0 && did_quota)
+		vfs_dq_free_space_nodirty(inode,
+					ocfs2_clusters_to_bytes(osb->sb, 1));
+	if (status < 0 && did_quota_inode)
+		vfs_dq_free_inode(inode);
 	if (handle)
 		ocfs2_commit_trans(osb, handle);
 
diff --git a/fs/ocfs2/xattr.c b/fs/ocfs2/xattr.c
index 9cb71e1..3b9634c 100644
--- a/fs/ocfs2/xattr.c
+++ b/fs/ocfs2/xattr.c
@@ -1665,7 +1665,8 @@ static int ocfs2_remove_value_outside(struct inode*inode,
 
 	ocfs2_init_dealloc_ctxt(&ctxt.dealloc);
 
-	ctxt.handle = ocfs2_start_trans(osb, OCFS2_REMOVE_EXTENT_CREDITS);
+	ctxt.handle = ocfs2_start_trans(osb,
+					ocfs2_remove_extent_credits(osb->sb));
 	if (IS_ERR(ctxt.handle)) {
 		ret = PTR_ERR(ctxt.handle);
 		mlog_errno(ret);
@@ -2233,7 +2234,7 @@ static int ocfs2_calc_xattr_set_need(struct inode *inode,
 	 */
 	if (!xi->value) {
 		if (!ocfs2_xattr_is_local(xe))
-			credits += OCFS2_REMOVE_EXTENT_CREDITS;
+			credits += ocfs2_remove_extent_credits(inode->i_sb);
 
 		goto out;
 	}
@@ -2250,7 +2251,7 @@ static int ocfs2_calc_xattr_set_need(struct inode *inode,
 		 */
 		if (ocfs2_xattr_can_be_in_inode(inode, xi, xis)) {
 			clusters_add += new_clusters;
-			credits += OCFS2_REMOVE_EXTENT_CREDITS +
+			credits += ocfs2_remove_extent_credits(inode->i_sb) +
 				    OCFS2_INODE_UPDATE_CREDITS;
 			if (!ocfs2_xattr_is_local(xe))
 				credits += ocfs2_calc_extend_credits(
@@ -2275,7 +2276,7 @@ static int ocfs2_calc_xattr_set_need(struct inode *inode,
 			xv = &def_xv.xv;
 
 		if (old_clusters >= new_clusters) {
-			credits += OCFS2_REMOVE_EXTENT_CREDITS;
+			credits += ocfs2_remove_extent_credits(inode->i_sb);
 			goto out;
 		} else {
 			meta_add += ocfs2_extend_meta_needed(&xv->xr_list);
@@ -4750,7 +4751,7 @@ static int ocfs2_rm_xattr_cluster(struct inode *inode,
 		}
 	}
 
-	handle = ocfs2_start_trans(osb, OCFS2_REMOVE_EXTENT_CREDITS);
+	handle = ocfs2_start_trans(osb, ocfs2_remove_extent_credits(osb->sb));
 	if (IS_ERR(handle)) {
 		ret = -ENOMEM;
 		mlog_errno(ret);
@@ -5109,7 +5110,8 @@ static int ocfs2_delete_xattr_in_bucket(struct inode *inode,
 
 	ocfs2_init_dealloc_ctxt(&ctxt.dealloc);
 
-	ctxt.handle = ocfs2_start_trans(osb, OCFS2_REMOVE_EXTENT_CREDITS);
+	ctxt.handle = ocfs2_start_trans(osb,
+					ocfs2_remove_extent_credits(osb->sb));
 	if (IS_ERR(ctxt.handle)) {
 		ret = PTR_ERR(ctxt.handle);
 		mlog_errno(ret);
-- 
1.5.6
