From: Jan Kara <jack@suse.cz>
Date: Mon, 20 Oct 2008 19:23:58 +0200
Subject: [Ocfs2-devel] [PATCH] ocfs2: Add quota calls for allocation and
	freeing of inodes and space
In-Reply-To: y
References: y
Message-ID: <1224523443806-git-send-email-jack@suse.cz>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Add quota calls for allocation and freeing of inodes and space, also update
estimates on number of needed credits for a transaction. Move out inode
allocation from ocfs2_mknod_locked() because vfs_dq_init() must be called
outside of a transaction.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/ocfs2/alloc.c   |   18 ++++++-
 fs/ocfs2/aops.c    |   16 +++++-
 fs/ocfs2/dir.c     |   24 ++++++++-
 fs/ocfs2/file.c    |   74 +++++++++++++++++++++++--
 fs/ocfs2/inode.c   |    8 ++-
 fs/ocfs2/journal.h |   99 ++++++++++++++++++++++++----------
 fs/ocfs2/namei.c   |  151 +++++++++++++++++++++++++++++++++++----------------
 7 files changed, 298 insertions(+), 92 deletions(-)

diff --git a/fs/ocfs2/alloc.c b/fs/ocfs2/alloc.c
index 10bfb46..776dd95 100644
--- a/fs/ocfs2/alloc.c
+++ b/fs/ocfs2/alloc.c
@@ -28,6 +28,7 @@
 #include <linux/slab.h>
 #include <linux/highmem.h>
 #include <linux/swap.h>
+#include <linux/quotaops.h>
 
 #define MLOG_MASK_PREFIX ML_DISK_ALLOC
 #include <cluster/masklog.h>
@@ -5954,6 +5955,8 @@ static int ocfs2_do_truncate(struct ocfs2_super *osb,
 		goto bail;
 	}
 
+	vfs_dq_free_space_nodirty(inode,
+			ocfs2_clusters_to_bytes(osb->sb, clusters_to_del));
 	spin_lock(&OCFS2_I(inode)->ip_lock);
 	OCFS2_I(inode)->ip_clusters = le32_to_cpu(fe->i_clusters) -
 				      clusters_to_del;
@@ -6262,6 +6265,7 @@ int ocfs2_convert_inline_data_to_extents(struct inode *inode,
 	struct ocfs2_alloc_context *data_ac = NULL;
 	struct page **pages = NULL;
 	loff_t end = osb->s_clustersize;
+	int did_quota = 0;
 
 	has_data = i_size_read(inode) ? 1 : 0;
 
@@ -6281,7 +6285,8 @@ int ocfs2_convert_inline_data_to_extents(struct inode *inode,
 		}
 	}
 
-	handle = ocfs2_start_trans(osb, OCFS2_INLINE_TO_EXTENTS_CREDITS);
+	handle = ocfs2_start_trans(osb,
+				   ocfs2_inline_to_extents_credits(osb->sb));
 	if (IS_ERR(handle)) {
 		ret = PTR_ERR(handle);
 		mlog_errno(ret);
@@ -6300,6 +6305,13 @@ int ocfs2_convert_inline_data_to_extents(struct inode *inode,
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
@@ -6372,6 +6384,10 @@ int ocfs2_convert_inline_data_to_extents(struct inode *inode,
 	}
 
 out_commit:
+	if (ret < 0 && did_quota)
+		vfs_dq_free_space_nodirty(inode,
+					  ocfs2_clusters_to_bytes(osb->sb, 1));
+
 	ocfs2_commit_trans(osb, handle);
 
 out_unlock:
diff --git a/fs/ocfs2/aops.c b/fs/ocfs2/aops.c
index a53da14..6f0f8c5 100644
--- a/fs/ocfs2/aops.c
+++ b/fs/ocfs2/aops.c
@@ -27,6 +27,7 @@
 #include <linux/swap.h>
 #include <linux/pipe_fs_i.h>
 #include <linux/mpage.h>
+#include <linux/quotaops.h>
 
 #define MLOG_MASK_PREFIX ML_FILE_IO
 #include <cluster/masklog.h>
@@ -1736,6 +1737,11 @@ int ocfs2_write_begin_nolock(struct address_space *mapping,
 
 	wc->w_handle = handle;
 
+	if (clusters_to_alloc && vfs_dq_alloc_space_nodirty(inode,
+			ocfs2_clusters_to_bytes(osb->sb, clusters_to_alloc))) {
+		ret = -EDQUOT;
+		goto out_commit;
+	}
 	/*
 	 * We don't want this to fail in ocfs2_write_end(), so do it
 	 * here.
@@ -1744,7 +1750,7 @@ int ocfs2_write_begin_nolock(struct address_space *mapping,
 				   OCFS2_JOURNAL_ACCESS_WRITE);
 	if (ret) {
 		mlog_errno(ret);
-		goto out_commit;
+		goto out_quota;
 	}
 
 	/*
@@ -1757,14 +1763,14 @@ int ocfs2_write_begin_nolock(struct address_space *mapping,
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
@@ -1776,6 +1782,10 @@ success:
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
index 9cce563..c679083 100644
--- a/fs/ocfs2/dir.c
+++ b/fs/ocfs2/dir.c
@@ -40,6 +40,7 @@
 #include <linux/types.h>
 #include <linux/slab.h>
 #include <linux/highmem.h>
+#include <linux/quotaops.h>
 
 #define MLOG_MASK_PREFIX ML_NAMEI
 #include <cluster/masklog.h>
@@ -1182,9 +1183,9 @@ static int ocfs2_expand_inline_dir(struct inode *dir, struct buffer_head *di_bh,
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
@@ -1192,6 +1193,7 @@ static int ocfs2_expand_inline_dir(struct inode *dir, struct buffer_head *di_bh,
 	struct buffer_head *dirdata_bh = NULL;
 	struct ocfs2_dinode *di = (struct ocfs2_dinode *)di_bh->b_data;
 	handle_t *handle;
+	int did_quota = 0;
 
 	alloc = ocfs2_clusters_for_bytes(sb, bytes);
 
@@ -1227,6 +1229,12 @@ static int ocfs2_expand_inline_dir(struct inode *dir, struct buffer_head *di_bh,
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
@@ -1349,6 +1357,9 @@ static int ocfs2_expand_inline_dir(struct inode *dir, struct buffer_head *di_bh,
 	dirdata_bh = NULL;
 
 out_commit:
+	if (ret < 0 && did_quota)
+		vfs_dq_free_space_nodirty(dir,
+			ocfs2_clusters_to_bytes(osb->sb, 2));
 	ocfs2_commit_trans(osb, handle);
 
 out_sem:
@@ -1373,7 +1384,7 @@ static int ocfs2_do_extend_dir(struct super_block *sb,
 			       struct buffer_head **new_bh)
 {
 	int status;
-	int extend;
+	int extend, did_quota = 0;
 	u64 p_blkno, v_blkno;
 
 	spin_lock(&OCFS2_I(dir)->ip_lock);
@@ -1383,6 +1394,13 @@ static int ocfs2_do_extend_dir(struct super_block *sb,
 	if (extend) {
 		u32 offset = OCFS2_I(dir)->ip_clusters;
 
+		if (vfs_dq_alloc_space_nodirty(dir,
+					ocfs2_clusters_to_bytes(sb, 1))) {
+			status = -EDQUOT;
+			goto bail;
+		}
+		did_quota = 1;
+
 		status = ocfs2_do_extend_allocation(OCFS2_SB(sb), dir, &offset,
 						    1, 0, parent_fe_bh, handle,
 						    data_ac, meta_ac, NULL);
@@ -1408,6 +1426,8 @@ static int ocfs2_do_extend_dir(struct super_block *sb,
 	}
 	status = 0;
 bail:
+	if (did_quota && status < 0)
+		vfs_dq_free_space_nodirty(dir, ocfs2_clusters_to_bytes(sb, 1));
 	mlog_exit(status);
 	return status;
 }
diff --git a/fs/ocfs2/file.c b/fs/ocfs2/file.c
index 0667dde..9ad4367 100644
--- a/fs/ocfs2/file.c
+++ b/fs/ocfs2/file.c
@@ -35,6 +35,7 @@
 #include <linux/mount.h>
 #include <linux/writeback.h>
 #include <linux/falloc.h>
+#include <linux/quotaops.h>
 
 #define MLOG_MASK_PREFIX ML_INODE
 #include <cluster/masklog.h>
@@ -55,6 +56,7 @@
 #include "mmap.h"
 #include "suballoc.h"
 #include "super.h"
+#include "quota.h"
 
 #include "buffer_head_io.h"
 
@@ -698,6 +700,8 @@ static int __ocfs2_extend_allocation(struct inode *inode, u32 logical_start,
 	struct ocfs2_alloc_context *meta_ac = NULL;
 	enum ocfs2_alloc_restarted why;
 	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
+	u32 total_clusters = clusters_to_add;
+	int did_quota = 0;
 
 	mlog_entry("(clusters_to_add = %u)\n", clusters_to_add);
 
@@ -740,6 +744,12 @@ restart_all:
 		goto leave;
 	}
 
+	if (!did_quota && vfs_dq_alloc_space_nodirty(inode,
+	    ocfs2_clusters_to_bytes(osb->sb, total_clusters))) {
+		status = -EDQUOT;
+		goto leave;
+	}
+	did_quota = 1;
 restarted_transaction:
 	/* reserve a write to the file entry early on - that we if we
 	 * run out of credits in the allocation path, we can still
@@ -810,6 +820,9 @@ restarted_transaction:
 	     OCFS2_I(inode)->ip_clusters, (long long)i_size_read(inode));
 
 leave:
+	if (status < 0 && did_quota)
+		vfs_dq_free_space(inode,
+			ocfs2_clusters_to_bytes(osb->sb, total_clusters));
 	if (handle) {
 		ocfs2_commit_trans(osb, handle);
 		handle = NULL;
@@ -1044,6 +1057,9 @@ int ocfs2_setattr(struct dentry *dentry, struct iattr *attr)
 	struct ocfs2_super *osb = OCFS2_SB(sb);
 	struct buffer_head *bh = NULL;
 	handle_t *handle = NULL;
+	int locked[MAXQUOTAS] = {0, 0};
+	int credits, qtype;
+	struct ocfs2_mem_dqinfo *oinfo;
 
 	mlog_entry("(0x%p, '%.*s')\n", dentry,
 	           dentry->d_name.len, dentry->d_name.name);
@@ -1108,11 +1124,49 @@ int ocfs2_setattr(struct dentry *dentry, struct iattr *attr)
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
+			status = ocfs2_inode_lock(oinfo->dqi_gqinode,
+						  &oinfo->dqi_gqi_bh, 1);
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
+			status = ocfs2_inode_lock(oinfo->dqi_gqinode,
+						  &oinfo->dqi_gqi_bh, 1);
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
@@ -1135,6 +1189,14 @@ int ocfs2_setattr(struct dentry *dentry, struct iattr *attr)
 bail_commit:
 	ocfs2_commit_trans(osb, handle);
 bail_unlock:
+	for (qtype = 0; qtype < MAXQUOTAS; qtype++) {
+		if (!locked[qtype])
+			continue;
+		oinfo = sb_dqinfo(sb, qtype)->dqi_priv;
+		ocfs2_inode_unlock(oinfo->dqi_gqinode, 1);
+		brelse(oinfo->dqi_gqi_bh);
+		oinfo->dqi_gqi_bh = NULL;
+	}
 	ocfs2_inode_unlock(inode, 1);
 bail_unlock_rw:
 	if (size_change)
@@ -1411,7 +1473,7 @@ static int __ocfs2_remove_inode_range(struct inode *inode,
 		}
 	}
 
-	handle = ocfs2_start_trans(osb, OCFS2_REMOVE_EXTENT_CREDITS);
+	handle = ocfs2_start_trans(osb, ocfs2_remove_extent_credits(osb->sb));
 	if (IS_ERR(handle)) {
 		ret = PTR_ERR(handle);
 		mlog_errno(ret);
diff --git a/fs/ocfs2/inode.c b/fs/ocfs2/inode.c
index c3d76d6..4a12238 100644
--- a/fs/ocfs2/inode.c
+++ b/fs/ocfs2/inode.c
@@ -28,6 +28,7 @@
 #include <linux/slab.h>
 #include <linux/highmem.h>
 #include <linux/pagemap.h>
+#include <linux/quotaops.h>
 
 #include <asm/byteorder.h>
 
@@ -601,7 +602,8 @@ static int ocfs2_remove_inode(struct inode *inode,
 		goto bail;
 	}
 
-	handle = ocfs2_start_trans(osb, OCFS2_DELETE_INODE_CREDITS);
+	handle = ocfs2_start_trans(osb, OCFS2_DELETE_INODE_CREDITS +
+					ocfs2_quota_trans_credits(inode->i_sb));
 	if (IS_ERR(handle)) {
 		status = PTR_ERR(handle);
 		mlog_errno(status);
@@ -633,6 +635,7 @@ static int ocfs2_remove_inode(struct inode *inode,
 	}
 
 	ocfs2_remove_from_cache(inode, di_bh);
+	vfs_dq_free_inode(inode);
 
 	status = ocfs2_free_dinode(handle, inode_alloc_inode,
 				   inode_alloc_bh, di);
@@ -908,7 +911,8 @@ void ocfs2_delete_inode(struct inode *inode)
 
 	mlog_entry("(inode->i_ino = %lu)\n", inode->i_ino);
 
-	if (is_bad_inode(inode)) {
+	/* Inode left after unsuccessful inode allocation? */
+	if (is_bad_inode(inode) || !OCFS2_I(inode)->ip_blkno) {
 		mlog(0, "Skipping delete of bad inode\n");
 		goto bail;
 	}
diff --git a/fs/ocfs2/journal.h b/fs/ocfs2/journal.h
index 271170a..96afdbe 100644
--- a/fs/ocfs2/journal.h
+++ b/fs/ocfs2/journal.h
@@ -283,6 +283,37 @@ int                  ocfs2_journal_dirty_data(handle_t *handle,
 /* simple file updates like chmod, etc. */
 #define OCFS2_INODE_UPDATE_CREDITS 1
 
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
 
@@ -293,8 +324,11 @@ int                  ocfs2_journal_dirty_data(handle_t *handle,
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
@@ -303,16 +337,23 @@ int                  ocfs2_journal_dirty_data(handle_t *handle,
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
@@ -322,13 +363,21 @@ int                  ocfs2_journal_dirty_data(handle_t *handle,
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
@@ -337,23 +386,10 @@ int                  ocfs2_journal_dirty_data(handle_t *handle,
 /* dinode update, old dir dinode update, new dir dinode update, old
  * dir dir entry, new dir dir entry, dir entry update for renaming
  * directory + target unlink */
-#define OCFS2_RENAME_CREDITS (3 * OCFS2_INODE_UPDATE_CREDITS + 3              \
-			     + OCFS2_UNLINK_CREDITS)
-
-/* global quotafile inode update, data block */
-#define OCFS2_QINFO_WRITE_CREDITS (OCFS2_INODE_UPDATE_CREDITS + 1)
-
-/*
- * The two writes below can accidentally see global info dirty due
- * to set_info() quotactl so make them prepared for the writes.
- */
-/* quota data block, global info */
-/* Write to local quota file */
-#define OCFS2_QWRITE_CREDITS (OCFS2_QINFO_WRITE_CREDITS + 1)
-
-/* global quota data block, local quota data block, global quota inode,
- * global quota info */
-#define OCFS2_QSYNC_CREDITS (OCFS2_INODE_UPDATE_CREDITS + 3)
+static inline int ocfs2_rename_credits(struct super_block *sb)
+{
+	return 3 * OCFS2_INODE_UPDATE_CREDITS + 3 + ocfs2_unlink_credits(sb);
+}
 
 static inline int ocfs2_calc_extend_credits(struct super_block *sb,
 					    struct ocfs2_dinode *fe,
@@ -379,18 +415,19 @@ static inline int ocfs2_calc_extend_credits(struct super_block *sb,
 	 * credit for the dinode there. */
 	dinode_blocks = 1 + 1 + le16_to_cpu(fe->id2.i_list.l_tree_depth);
 
-	return bitmap_blocks + sysfile_bitmap_blocks + dinode_blocks;
+	return bitmap_blocks + sysfile_bitmap_blocks + dinode_blocks +
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
@@ -427,6 +464,8 @@ static inline int ocfs2_calc_tree_trunc_credits(struct super_block *sb,
 	/* update to the truncate log. */
 	credits += OCFS2_TRUNCATE_LOG_UPDATE;
 
+	credits += ocfs2_quota_trans_credits(sb);
+
 	return credits;
 }
 
diff --git a/fs/ocfs2/namei.c b/fs/ocfs2/namei.c
index ff1a56d..677f6fa 100644
--- a/fs/ocfs2/namei.c
+++ b/fs/ocfs2/namei.c
@@ -40,6 +40,7 @@
 #include <linux/types.h>
 #include <linux/slab.h>
 #include <linux/highmem.h>
+#include <linux/quotaops.h>
 
 #define MLOG_MASK_PREFIX ML_NAMEI
 #include <cluster/masklog.h>
@@ -65,12 +66,12 @@
 
 static int ocfs2_mknod_locked(struct ocfs2_super *osb,
 			      struct inode *dir,
-			      struct dentry *dentry, int mode,
+			      struct inode *inode,
+			      struct dentry *dentry,
 			      dev_t dev,
 			      struct buffer_head **new_fe_bh,
 			      struct buffer_head *parent_fe_bh,
 			      handle_t *handle,
-			      struct inode **ret_inode,
 			      struct ocfs2_alloc_context *inode_ac);
 
 static int ocfs2_prepare_orphan_dir(struct ocfs2_super *osb,
@@ -185,6 +186,35 @@ bail:
 	return ret;
 }
 
+static struct inode *ocfs2_get_init_inode(struct inode *dir, int mode)
+{
+	struct inode *inode;
+
+	inode = new_inode(dir->i_sb);
+	if (!inode) {
+		mlog(ML_ERROR, "new_inode failed!\n");
+		return NULL;
+	}
+
+	/* populate as many fields early on as possible - many of
+	 * these are used by the support functions here and in
+	 * callers. */
+	if (S_ISDIR(mode))
+		inode->i_nlink = 2;
+	else
+		inode->i_nlink = 1;
+	inode->i_uid = current->fsuid;
+	if (dir->i_mode & S_ISGID) {
+		inode->i_gid = dir->i_gid;
+		if (S_ISDIR(mode))
+			mode |= S_ISGID;
+	} else
+		inode->i_gid = current->fsgid;
+	inode->i_mode = mode;
+	vfs_dq_init(inode);
+	return inode;
+}
+
 static int ocfs2_mknod(struct inode *dir,
 		       struct dentry *dentry,
 		       int mode,
@@ -200,6 +230,7 @@ static int ocfs2_mknod(struct inode *dir,
 	struct inode *inode = NULL;
 	struct ocfs2_alloc_context *inode_ac = NULL;
 	struct ocfs2_alloc_context *data_ac = NULL;
+	int did_quota_inode = 0;
 
 	mlog_entry("(0x%p, 0x%p, %d, %lu, '%.*s')\n", dir, dentry, mode,
 		   (unsigned long)dev, dentry->d_name.len,
@@ -259,7 +290,14 @@ static int ocfs2_mknod(struct inode *dir,
 		}
 	}
 
-	handle = ocfs2_start_trans(osb, OCFS2_MKNOD_CREDITS);
+	inode = ocfs2_get_init_inode(dir, mode);
+	if (!inode) {
+		status = -ENOMEM;
+		mlog_errno(status);
+		goto leave;
+	}
+
+	handle = ocfs2_start_trans(osb, ocfs2_mknod_credits(dir->i_sb));
 	if (IS_ERR(handle)) {
 		status = PTR_ERR(handle);
 		handle = NULL;
@@ -267,10 +305,19 @@ static int ocfs2_mknod(struct inode *dir,
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
-	status = ocfs2_mknod_locked(osb, dir, dentry, mode, dev,
+	status = ocfs2_mknod_locked(osb, dir, inode, dentry, dev,
 				    &new_fe_bh, parent_fe_bh, handle,
-				    &inode, inode_ac);
+				    inode_ac);
 	if (status < 0) {
 		mlog_errno(status);
 		goto leave;
@@ -319,6 +366,8 @@ static int ocfs2_mknod(struct inode *dir,
 	d_instantiate(dentry, inode);
 	status = 0;
 leave:
+	if (status < 0 && did_quota_inode)
+		vfs_dq_free_inode(inode);
 	if (handle)
 		ocfs2_commit_trans(osb, handle);
 
@@ -336,8 +385,10 @@ leave:
 	if (parent_fe_bh)
 		brelse(parent_fe_bh);
 
-	if ((status < 0) && inode)
+	if ((status < 0) && inode) {
+		clear_nlink(inode);
 		iput(inode);
+	}
 
 	if (inode_ac)
 		ocfs2_free_alloc_context(inode_ac);
@@ -352,12 +403,12 @@ leave:
 
 static int ocfs2_mknod_locked(struct ocfs2_super *osb,
 			      struct inode *dir,
-			      struct dentry *dentry, int mode,
+			      struct inode *inode,
+			      struct dentry *dentry,
 			      dev_t dev,
 			      struct buffer_head **new_fe_bh,
 			      struct buffer_head *parent_fe_bh,
 			      handle_t *handle,
-			      struct inode **ret_inode,
 			      struct ocfs2_alloc_context *inode_ac)
 {
 	int status = 0;
@@ -365,14 +416,12 @@ static int ocfs2_mknod_locked(struct ocfs2_super *osb,
 	struct ocfs2_extent_list *fel;
 	u64 fe_blkno = 0;
 	u16 suballoc_bit;
-	struct inode *inode = NULL;
 
-	mlog_entry("(0x%p, 0x%p, %d, %lu, '%.*s')\n", dir, dentry, mode,
-		   (unsigned long)dev, dentry->d_name.len,
+	mlog_entry("(0x%p, 0x%p, %d, %lu, '%.*s')\n", dir, dentry,
+		   inode->i_mode, (unsigned long)dev, dentry->d_name.len,
 		   dentry->d_name.name);
 
 	*new_fe_bh = NULL;
-	*ret_inode = NULL;
 
 	status = ocfs2_claim_new_inode(osb, handle, inode_ac, &suballoc_bit,
 				       &fe_blkno);
@@ -381,23 +430,11 @@ static int ocfs2_mknod_locked(struct ocfs2_super *osb,
 		goto leave;
 	}
 
-	inode = new_inode(dir->i_sb);
-	if (!inode) {
-		status = -ENOMEM;
-		mlog(ML_ERROR, "new_inode failed!\n");
-		goto leave;
-	}
-
 	/* populate as many fields early on as possible - many of
 	 * these are used by the support functions here and in
 	 * callers. */
 	inode->i_ino = ino_from_blkno(osb->sb, fe_blkno);
 	OCFS2_I(inode)->ip_blkno = fe_blkno;
-	if (S_ISDIR(mode))
-		inode->i_nlink = 2;
-	else
-		inode->i_nlink = 1;
-	inode->i_mode = mode;
 	spin_lock(&osb->osb_lock);
 	inode->i_generation = osb->s_next_generation++;
 	spin_unlock(&osb->osb_lock);
@@ -425,17 +462,11 @@ static int ocfs2_mknod_locked(struct ocfs2_super *osb,
 	fe->i_blkno = cpu_to_le64(fe_blkno);
 	fe->i_suballoc_bit = cpu_to_le16(suballoc_bit);
 	fe->i_suballoc_slot = cpu_to_le16(inode_ac->ac_alloc_slot);
-	fe->i_uid = cpu_to_le32(current->fsuid);
-	if (dir->i_mode & S_ISGID) {
-		fe->i_gid = cpu_to_le32(dir->i_gid);
-		if (S_ISDIR(mode))
-			mode |= S_ISGID;
-	} else
-		fe->i_gid = cpu_to_le32(current->fsgid);
-	fe->i_mode = cpu_to_le16(mode);
-	if (S_ISCHR(mode) || S_ISBLK(mode))
+	fe->i_uid = cpu_to_le32(inode->i_uid);
+	fe->i_gid = cpu_to_le32(inode->i_gid);
+	fe->i_mode = cpu_to_le16(inode->i_mode);
+	if (S_ISCHR(inode->i_mode) || S_ISBLK(inode->i_mode))
 		fe->id1.dev1.i_rdev = cpu_to_le64(huge_encode_dev(dev));
-
 	fe->i_links_count = cpu_to_le16(inode->i_nlink);
 
 	fe->i_last_eb_blk = 0;
@@ -450,7 +481,7 @@ static int ocfs2_mknod_locked(struct ocfs2_super *osb,
 	/*
 	 * If supported, directories start with inline data.
 	 */
-	if (S_ISDIR(mode) && ocfs2_supports_inline_data(osb)) {
+	if (S_ISDIR(inode->i_mode) && ocfs2_supports_inline_data(osb)) {
 		u16 feat = le16_to_cpu(fe->i_dyn_features);
 
 		fe->i_dyn_features = cpu_to_le16(feat | OCFS2_INLINE_DATA_FL);
@@ -488,17 +519,12 @@ static int ocfs2_mknod_locked(struct ocfs2_super *osb,
 	status = 0; /* error in ocfs2_create_new_inode_locks is not
 		     * critical */
 
-	*ret_inode = inode;
 leave:
 	if (status < 0) {
 		if (*new_fe_bh) {
 			brelse(*new_fe_bh);
 			*new_fe_bh = NULL;
 		}
-		if (inode) {
-			clear_nlink(inode);
-			iput(inode);
-		}
 	}
 
 	mlog_exit(status);
@@ -592,7 +618,7 @@ static int ocfs2_link(struct dentry *old_dentry,
 		goto out_unlock_inode;
 	}
 
-	handle = ocfs2_start_trans(osb, OCFS2_LINK_CREDITS);
+	handle = ocfs2_start_trans(osb, ocfs2_link_credits(osb->sb));
 	if (IS_ERR(handle)) {
 		err = PTR_ERR(handle);
 		handle = NULL;
@@ -782,7 +808,7 @@ static int ocfs2_unlink(struct inode *dir,
 		}
 	}
 
-	handle = ocfs2_start_trans(osb, OCFS2_UNLINK_CREDITS);
+	handle = ocfs2_start_trans(osb, ocfs2_unlink_credits(osb->sb));
 	if (IS_ERR(handle)) {
 		status = PTR_ERR(handle);
 		handle = NULL;
@@ -1195,7 +1221,7 @@ static int ocfs2_rename(struct inode *old_dir,
 		}
 	}
 
-	handle = ocfs2_start_trans(osb, OCFS2_RENAME_CREDITS);
+	handle = ocfs2_start_trans(osb, ocfs2_rename_credits(osb->sb));
 	if (IS_ERR(handle)) {
 		status = PTR_ERR(handle);
 		handle = NULL;
@@ -1520,6 +1546,7 @@ static int ocfs2_symlink(struct inode *dir,
 	handle_t *handle = NULL;
 	struct ocfs2_alloc_context *inode_ac = NULL;
 	struct ocfs2_alloc_context *data_ac = NULL;
+	int did_quota = 0, did_quota_inode = 0;
 
 	mlog_entry("(0x%p, 0x%p, symname='%s' actual='%.*s')\n", dir,
 		   dentry, symname, dentry->d_name.len, dentry->d_name.name);
@@ -1576,6 +1603,13 @@ static int ocfs2_symlink(struct inode *dir,
 		}
 	}
 
+	inode = ocfs2_get_init_inode(dir, S_IFLNK | S_IRWXUGO);
+	if (!inode) {
+		status = -ENOMEM;
+		mlog_errno(status);
+		goto bail;
+	}
+
 	handle = ocfs2_start_trans(osb, credits);
 	if (IS_ERR(handle)) {
 		status = PTR_ERR(handle);
@@ -1584,10 +1618,18 @@ static int ocfs2_symlink(struct inode *dir,
 		goto bail;
 	}
 
-	status = ocfs2_mknod_locked(osb, dir, dentry,
-				    S_IFLNK | S_IRWXUGO, 0,
-				    &new_fe_bh, parent_fe_bh, handle,
-				    &inode, inode_ac);
+	/* We don't use standard VFS wrapper because we don't want vfs_dq_init
+	 * to be called. */
+	if (sb_any_quota_active(osb->sb) &&
+	    osb->sb->dq_op->alloc_inode(inode, 1) == NO_QUOTA) {
+		status = -EDQUOT;
+		goto bail;
+	}
+	did_quota_inode = 1;
+
+	status = ocfs2_mknod_locked(osb, dir, inode, dentry,
+				    0, &new_fe_bh, parent_fe_bh, handle,
+				    inode_ac);
 	if (status < 0) {
 		mlog_errno(status);
 		goto bail;
@@ -1600,6 +1642,12 @@ static int ocfs2_symlink(struct inode *dir,
 		u32 offset = 0;
 
 		inode->i_op = &ocfs2_symlink_inode_operations;
+		if (vfs_dq_alloc_space_nodirty(inode,
+		    ocfs2_clusters_to_bytes(osb->sb, 1))) {
+			status = -EDQUOT;
+			goto bail;
+		}
+		did_quota = 1;
 		status = ocfs2_do_extend_allocation(osb, inode, &offset, 1, 0,
 						    new_fe_bh,
 						    handle, data_ac, NULL,
@@ -1656,6 +1704,11 @@ static int ocfs2_symlink(struct inode *dir,
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
 
@@ -1671,8 +1724,10 @@ bail:
 		ocfs2_free_alloc_context(inode_ac);
 	if (data_ac)
 		ocfs2_free_alloc_context(data_ac);
-	if ((status < 0) && inode)
+	if ((status < 0) && inode) {
+		clear_nlink(inode);
 		iput(inode);
+	}
 
 	mlog_exit(status);
 
-- 
1.5.2.4
