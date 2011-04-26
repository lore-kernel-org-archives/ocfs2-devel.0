From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Mon, 25 Apr 2011 19:20:28 -0700
Subject: [Ocfs2-devel] [PATCH] ocfs2: Implement own llseek()
Message-ID: <1303784428-16516-1-git-send-email-sunil.mushran@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, ocfs2-devel@oss.oracle.com, jlbec@evilplan.org, hch@infradead.org

ocfs2 implements its own llseek() to provide the SEEK_HOLE/SEEK_DATA
functionality.

As SEEK_DATA is used to detect regions having non-zero data, the patch
opts to treat unwritten extents as holes.

Signed-off-by: Sunil Mushran <sunil.mushran@oracle.com>
---
 fs/ocfs2/extent_map.c |   79 +++++++++++++++++++++++++++++++++++++++++++++++++
 fs/ocfs2/extent_map.h |    2 +
 fs/ocfs2/file.c       |   58 ++++++++++++++++++++++++++++++++++-
 3 files changed, 137 insertions(+), 2 deletions(-)

diff --git a/fs/ocfs2/extent_map.c b/fs/ocfs2/extent_map.c
index 23457b4..4f6cf92 100644
--- a/fs/ocfs2/extent_map.c
+++ b/fs/ocfs2/extent_map.c
@@ -832,6 +832,85 @@ out:
 	return ret;
 }
 
+int ocfs2_seek_data_hole_offset(struct file *file, loff_t *offset, int origin)
+{
+	struct inode *inode = file->f_mapping->host;
+	int ret, is_last;
+	u32 cpos, cend, cs_bits = OCFS2_SB(inode->i_sb)->s_clustersize_bits;
+	loff_t bpos;
+	unsigned int hole_size;
+	struct buffer_head *di_bh = NULL;
+	struct ocfs2_extent_rec rec;
+
+	BUG_ON(origin != SEEK_DATA && origin != SEEK_HOLE);
+
+	ret = ocfs2_inode_lock(inode, &di_bh, 0);
+	if (ret) {
+		mlog_errno(ret);
+		goto out;
+	}
+
+	down_read(&OCFS2_I(inode)->ip_alloc_sem);
+
+	if (OCFS2_I(inode)->ip_dyn_features & OCFS2_INLINE_DATA_FL)
+		goto out_unlock;
+
+	cpos = *offset >> cs_bits;
+	cend = ocfs2_clusters_for_bytes(inode->i_sb, inode->i_size);
+	is_last = 0;
+
+	while (cpos < cend && !is_last) {
+		ret = ocfs2_get_clusters_nocache(inode, di_bh, cpos, &hole_size,
+						 &rec, &is_last);
+		if (ret) {
+			mlog_errno(ret);
+			goto out_unlock;
+		}
+
+		/* unwritten extent is treated as a hole */
+		if (rec.e_blkno == 0ULL || rec.e_flags & OCFS2_EXT_UNWRITTEN) {
+			if (origin == SEEK_HOLE) {
+				bpos = cpos << cs_bits;
+				if (bpos > *offset)
+					*offset = bpos;
+				goto out_unlock;
+			}
+			if (rec.e_blkno == 0ULL) {
+				cpos += hole_size;
+				continue;
+			}
+			cpos = le32_to_cpu(rec.e_cpos) +
+				le16_to_cpu(rec.e_leaf_clusters);
+			continue;
+		}
+
+		if (origin == SEEK_DATA) {
+			bpos = cpos << cs_bits;
+			if (bpos > *offset)
+				*offset = bpos;
+			goto out_unlock;
+		}
+
+		cpos = le32_to_cpu(rec.e_cpos) +
+			le16_to_cpu(rec.e_leaf_clusters);
+	}
+
+	if (origin == SEEK_HOLE && *offset < inode->i_size)
+		*offset = inode->i_size;
+
+	if (ret > 0)
+		ret = 0;
+
+out_unlock:
+	brelse(di_bh);
+
+	up_read(&OCFS2_I(inode)->ip_alloc_sem);
+
+	ocfs2_inode_unlock(inode, 0);
+out:
+	return ret;
+}
+
 int ocfs2_read_virt_blocks(struct inode *inode, u64 v_block, int nr,
 			   struct buffer_head *bhs[], int flags,
 			   int (*validate)(struct super_block *sb,
diff --git a/fs/ocfs2/extent_map.h b/fs/ocfs2/extent_map.h
index e79d41c..67ea57d 100644
--- a/fs/ocfs2/extent_map.h
+++ b/fs/ocfs2/extent_map.h
@@ -53,6 +53,8 @@ int ocfs2_extent_map_get_blocks(struct inode *inode, u64 v_blkno, u64 *p_blkno,
 int ocfs2_fiemap(struct inode *inode, struct fiemap_extent_info *fieinfo,
 		 u64 map_start, u64 map_len);
 
+int ocfs2_seek_data_hole_offset(struct file *file, loff_t *offset, int origin);
+
 int ocfs2_xattr_get_clusters(struct inode *inode, u32 v_cluster,
 			     u32 *p_cluster, u32 *num_clusters,
 			     struct ocfs2_extent_list *el,
diff --git a/fs/ocfs2/file.c b/fs/ocfs2/file.c
index 41565ae..48340f3 100644
--- a/fs/ocfs2/file.c
+++ b/fs/ocfs2/file.c
@@ -2572,6 +2572,60 @@ bail:
 	return ret;
 }
 
+/* Refer generic_file_llseek_unlocked() */
+static loff_t ocfs2_file_llseek(struct file *file, loff_t offset, int origin)
+{
+	struct inode *inode = file->f_mapping->host;
+	int ret = 0;
+
+	mutex_lock(&inode->i_mutex);
+	switch (origin) {
+	case SEEK_END:
+		offset += inode->i_size;
+		break;
+	case SEEK_CUR:
+		/*
+		 * Here we special-case the lseek(fd, 0, SEEK_CUR)
+		 * position-querying operation.  Avoid rewriting the "same"
+		 * f_pos value back to the file because a concurrent read(),
+		 * write() or lseek() might have altered it
+		 */
+		if (offset == 0) {
+			offset = file->f_pos;
+			goto out;
+		}
+		offset += file->f_pos;
+		break;
+	case SEEK_DATA:
+	case SEEK_HOLE:
+		ret = ocfs2_seek_data_hole_offset(file, &offset, origin);
+		if (ret)
+			goto out;
+	}
+
+	ret = -EINVAL;
+	if (offset < 0 && !(file->f_mode & FMODE_UNSIGNED_OFFSET))
+		goto out;
+	if (offset > inode->i_sb->s_maxbytes)
+		goto out;
+	if (origin == SEEK_DATA && offset >= inode->i_size)
+		goto out;
+	if (origin == SEEK_HOLE && offset > inode->i_size)
+		goto out;
+
+	/* Special lock needed here? */
+	if (offset != file->f_pos) {
+		file->f_pos = offset;
+		file->f_version = 0;
+	}
+	ret = 0;
+out:
+	mutex_unlock(&inode->i_mutex);
+	if (ret)
+		return ret;
+	return offset;
+}
+
 const struct inode_operations ocfs2_file_iops = {
 	.setattr	= ocfs2_setattr,
 	.getattr	= ocfs2_getattr,
@@ -2594,7 +2648,7 @@ const struct inode_operations ocfs2_special_file_iops = {
  * ocfs2_fops_no_plocks and ocfs2_dops_no_plocks!
  */
 const struct file_operations ocfs2_fops = {
-	.llseek		= generic_file_llseek,
+	.llseek		= ocfs2_file_llseek,
 	.read		= do_sync_read,
 	.write		= do_sync_write,
 	.mmap		= ocfs2_mmap,
@@ -2642,7 +2696,7 @@ const struct file_operations ocfs2_dops = {
  * the cluster.
  */
 const struct file_operations ocfs2_fops_no_plocks = {
-	.llseek		= generic_file_llseek,
+	.llseek		= ocfs2_file_llseek,
 	.read		= do_sync_read,
 	.write		= do_sync_write,
 	.mmap		= ocfs2_mmap,
-- 
1.7.1
