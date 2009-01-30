From: Mark Fasheh <mfasheh@suse.com>
Date: Fri, 30 Jan 2009 13:42:28 -0800
Subject: [Ocfs2-devel] [PATCH 2/7] ocfs2: Add a name indexed b-tree to
	directory inodes
In-Reply-To: <1233351753-14640-1-git-send-email-mfasheh@suse.com>
References: <1233351753-14640-1-git-send-email-mfasheh@suse.com>
Message-ID: <1233351753-14640-3-git-send-email-mfasheh@suse.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

This patch makes use of Ocfs2's flexible btree code to add an additional
tree to directory inodes. The new tree stores an array of small,
fixed-length records in each leaf block. Each record stores a hash value,
and pointer to a block in the traditional (unindexed) directory tree where a
dirent with the given name hash resides. Lookup exclusively uses this tree
to find dirents, thus providing us with constant time name lookups.

Some of the hashing code was copied from ext3. Unfortunately, it has lots of
unfixed checkpatch errors. I left that as-is so that tracking changes would
be easier.

Signed-off-by: Mark Fasheh <mfasheh@suse.com>
---
 fs/ocfs2/alloc.c    |   57 ++
 fs/ocfs2/alloc.h    |    3 +
 fs/ocfs2/dir.c      | 1906 +++++++++++++++++++++++++++++++++++++++++++++++++--
 fs/ocfs2/dir.h      |   21 +-
 fs/ocfs2/inode.c    |   12 +-
 fs/ocfs2/journal.c  |   30 +
 fs/ocfs2/journal.h  |   51 +-
 fs/ocfs2/namei.c    |   45 +-
 fs/ocfs2/ocfs2.h    |   16 +
 fs/ocfs2/ocfs2_fs.h |  102 +++-
 fs/ocfs2/super.c    |    6 +
 fs/ocfs2/xattr.c    |    8 +-
 fs/ocfs2/xattr.h    |    2 +-
 13 files changed, 2155 insertions(+), 104 deletions(-)

diff --git a/fs/ocfs2/alloc.c b/fs/ocfs2/alloc.c
index d861096..cf96a05 100644
--- a/fs/ocfs2/alloc.c
+++ b/fs/ocfs2/alloc.c
@@ -293,6 +293,55 @@ static struct ocfs2_extent_tree_operations ocfs2_xattr_tree_et_ops = {
 	.eo_fill_max_leaf_clusters = ocfs2_xattr_tree_fill_max_leaf_clusters,
 };
 
+static void ocfs2_dx_root_set_last_eb_blk(struct ocfs2_extent_tree *et,
+					  u64 blkno)
+{
+	struct ocfs2_dx_root_block *dx_root = et->et_object;
+
+	dx_root->dr_last_eb_blk = cpu_to_le64(blkno);
+}
+
+static u64 ocfs2_dx_root_get_last_eb_blk(struct ocfs2_extent_tree *et)
+{
+	struct ocfs2_dx_root_block *dx_root = et->et_object;
+
+	return le64_to_cpu(dx_root->dr_last_eb_blk);
+}
+
+static void ocfs2_dx_root_update_clusters(struct inode *inode,
+					  struct ocfs2_extent_tree *et,
+					  u32 clusters)
+{
+	struct ocfs2_dx_root_block *dx_root = et->et_object;
+
+	le32_add_cpu(&dx_root->dr_clusters, clusters);
+}
+
+static int ocfs2_dx_root_sanity_check(struct inode *inode,
+				      struct ocfs2_extent_tree *et)
+{
+	struct ocfs2_dx_root_block *dx_root = et->et_object;
+
+	BUG_ON(!OCFS2_IS_VALID_DX_ROOT(dx_root));
+
+	return 0;
+}
+
+static void ocfs2_dx_root_fill_root_el(struct ocfs2_extent_tree *et)
+{
+	struct ocfs2_dx_root_block *dx_root = et->et_object;
+
+	et->et_root_el = &dx_root->dr_list;
+}
+
+static struct ocfs2_extent_tree_operations ocfs2_dx_root_et_ops = {
+	.eo_set_last_eb_blk	= ocfs2_dx_root_set_last_eb_blk,
+	.eo_get_last_eb_blk	= ocfs2_dx_root_get_last_eb_blk,
+	.eo_update_clusters	= ocfs2_dx_root_update_clusters,
+	.eo_sanity_check	= ocfs2_dx_root_sanity_check,
+	.eo_fill_root_el	= ocfs2_dx_root_fill_root_el,
+};
+
 static void __ocfs2_init_extent_tree(struct ocfs2_extent_tree *et,
 				     struct inode *inode,
 				     struct buffer_head *bh,
@@ -338,6 +387,14 @@ void ocfs2_init_xattr_value_extent_tree(struct ocfs2_extent_tree *et,
 				 &ocfs2_xattr_value_et_ops);
 }
 
+void ocfs2_init_dx_root_extent_tree(struct ocfs2_extent_tree *et,
+				    struct inode *inode,
+				    struct buffer_head *bh)
+{
+	__ocfs2_init_extent_tree(et, inode, bh, ocfs2_journal_access_dr,
+				 NULL, &ocfs2_dx_root_et_ops);
+}
+
 static inline void ocfs2_et_set_last_eb_blk(struct ocfs2_extent_tree *et,
 					    u64 new_last_eb_blk)
 {
diff --git a/fs/ocfs2/alloc.h b/fs/ocfs2/alloc.h
index cceff5c..353254b 100644
--- a/fs/ocfs2/alloc.h
+++ b/fs/ocfs2/alloc.h
@@ -75,6 +75,9 @@ struct ocfs2_xattr_value_buf;
 void ocfs2_init_xattr_value_extent_tree(struct ocfs2_extent_tree *et,
 					struct inode *inode,
 					struct ocfs2_xattr_value_buf *vb);
+void ocfs2_init_dx_root_extent_tree(struct ocfs2_extent_tree *et,
+				    struct inode *inode,
+				    struct buffer_head *bh);
 
 /*
  * Read an extent block into *bh.  If *bh is NULL, a bh will be
diff --git a/fs/ocfs2/dir.c b/fs/ocfs2/dir.c
index 76ffb5c..b442d7a 100644
--- a/fs/ocfs2/dir.c
+++ b/fs/ocfs2/dir.c
@@ -41,6 +41,7 @@
 #include <linux/slab.h>
 #include <linux/highmem.h>
 #include <linux/quotaops.h>
+#include <linux/sort.h>
 
 #define MLOG_MASK_PREFIX ML_NAMEI
 #include <cluster/masklog.h>
@@ -58,6 +59,7 @@
 #include "namei.h"
 #include "suballoc.h"
 #include "super.h"
+#include "sysfile.h"
 #include "uptodate.h"
 
 #include "buffer_head_io.h"
@@ -71,11 +73,6 @@ static unsigned char ocfs2_filetype_table[] = {
 	DT_UNKNOWN, DT_REG, DT_DIR, DT_CHR, DT_BLK, DT_FIFO, DT_SOCK, DT_LNK
 };
 
-static int ocfs2_extend_dir(struct ocfs2_super *osb,
-			    struct inode *dir,
-			    struct buffer_head *parent_fe_bh,
-			    unsigned int blocks_wanted,
-			    struct buffer_head **new_de_bh);
 static int ocfs2_do_extend_dir(struct super_block *sb,
 			       handle_t *handle,
 			       struct inode *dir,
@@ -155,6 +152,105 @@ static void ocfs2_init_dir_trailer(struct inode *inode,
 void ocfs2_free_dir_lookup_result(struct ocfs2_dir_lookup_result *res)
 {
 	brelse(res->dl_leaf_bh);
+	brelse(res->dl_dx_leaf_bh);
+}
+
+static int ocfs2_dir_indexed(struct inode *inode)
+{
+	if (OCFS2_I(inode)->ip_dyn_features & OCFS2_INDEXED_DIR_FL)
+		return 1;
+	return 0;
+}
+
+/*
+ * Hashing code adapted from ext3
+ */
+#define DELTA 0x9E3779B9
+
+static void TEA_transform(__u32 buf[4], __u32 const in[])
+{
+	__u32	sum = 0;
+	__u32	b0 = buf[0], b1 = buf[1];
+	__u32	a = in[0], b = in[1], c = in[2], d = in[3];
+	int	n = 16;
+
+	do {
+		sum += DELTA;
+		b0 += ((b1 << 4)+a) ^ (b1+sum) ^ ((b1 >> 5)+b);
+		b1 += ((b0 << 4)+c) ^ (b0+sum) ^ ((b0 >> 5)+d);
+	} while (--n);
+
+	buf[0] += b0;
+	buf[1] += b1;
+}
+
+static void str2hashbuf(const char *msg, int len, __u32 *buf, int num)
+{
+	__u32	pad, val;
+	int	i;
+
+	pad = (__u32)len | ((__u32)len << 8);
+	pad |= pad << 16;
+
+	val = pad;
+	if (len > num*4)
+		len = num * 4;
+	for (i = 0; i < len; i++) {
+		if ((i % 4) == 0)
+			val = pad;
+		val = msg[i] + (val << 8);
+		if ((i % 4) == 3) {
+			*buf++ = val;
+			val = pad;
+			num--;
+		}
+	}
+	if (--num >= 0)
+		*buf++ = val;
+	while (--num >= 0)
+		*buf++ = pad;
+}
+
+static void ocfs2_dx_dir_name_hash(struct inode *dir, const char *name, int len,
+				   struct ocfs2_dx_hinfo *hinfo)
+{
+	struct ocfs2_super *osb = OCFS2_SB(dir->i_sb);
+	const char	*p;
+	__u32		in[8], buf[4];
+
+	/*
+	 * XXX: Is this really necessary, if the index is never looked
+	 * at by readdir? Is a hash value of '0' a bad idea?
+	 */
+	if ((len == 1 && !strncmp(".", name, 1)) ||
+	    (len == 2 && !strncmp("..", name, 2))) {
+		buf[0] = buf[1] = 0;
+		goto out;
+	}
+
+#ifdef OCFS2_DEBUG_DX_DIRS
+	/*
+	 * This makes it very easy to debug indexing problems. We
+	 * should never allow this to be selected without hand editing
+	 * this file though.
+	 */
+	buf[0] = buf[1] = len;
+	goto out;
+#endif
+
+	memcpy(buf, osb->osb_dx_seed, sizeof(buf));
+
+	p = name;
+	while (len > 0) {
+		str2hashbuf(p, len, in, 4);
+		TEA_transform(buf, in);
+		len -= 16;
+		p += 16;
+	}
+
+out:
+	hinfo->major_hash = buf[0];
+	hinfo->minor_hash = buf[1];
 }
 
 /*
@@ -317,6 +413,52 @@ static int ocfs2_validate_dir_block(struct super_block *sb,
 }
 
 /*
+ * Validate a directory trailer.
+ *
+ * We check the trailer here rather than in ocfs2_validate_dir_block()
+ * because that function doesn't have the inode to test.
+ */
+static int ocfs2_check_dir_trailer(struct inode *dir, struct buffer_head *bh)
+{
+	int rc = 0;
+	struct ocfs2_dir_block_trailer *trailer;
+
+	trailer = ocfs2_trailer_from_bh(bh, dir->i_sb);
+	if (!OCFS2_IS_VALID_DIR_TRAILER(trailer)) {
+		rc = -EINVAL;
+		ocfs2_error(dir->i_sb,
+			    "Invalid dirblock #%llu: "
+			    "signature = %.*s\n",
+			    (unsigned long long)bh->b_blocknr, 7,
+			    trailer->db_signature);
+		goto out;
+	}
+	if (le64_to_cpu(trailer->db_blkno) != bh->b_blocknr) {
+		rc = -EINVAL;
+		ocfs2_error(dir->i_sb,
+			    "Directory block #%llu has an invalid "
+			    "db_blkno of %llu",
+			    (unsigned long long)bh->b_blocknr,
+			    (unsigned long long)le64_to_cpu(trailer->db_blkno));
+		goto out;
+	}
+	if (le64_to_cpu(trailer->db_parent_dinode) !=
+	    OCFS2_I(dir)->ip_blkno) {
+		rc = -EINVAL;
+		ocfs2_error(dir->i_sb,
+			    "Directory block #%llu on dinode "
+			    "#%llu has an invalid parent_dinode "
+			    "of %llu",
+			    (unsigned long long)bh->b_blocknr,
+			    (unsigned long long)OCFS2_I(dir)->ip_blkno,
+			    (unsigned long long)le64_to_cpu(trailer->db_blkno));
+		goto out;
+	}
+out:
+	return rc;
+}
+
+/*
  * This function forces all errors to -EIO for consistency with its
  * predecessor, ocfs2_bread().  We haven't audited what returning the
  * real error codes would do to callers.  We log the real codes with
@@ -327,7 +469,6 @@ static int ocfs2_read_dir_block(struct inode *inode, u64 v_block,
 {
 	int rc = 0;
 	struct buffer_head *tmp = *bh;
-	struct ocfs2_dir_block_trailer *trailer;
 
 	rc = ocfs2_read_virt_blocks(inode, v_block, 1, &tmp, flags,
 				    ocfs2_validate_dir_block);
@@ -336,42 +477,13 @@ static int ocfs2_read_dir_block(struct inode *inode, u64 v_block,
 		goto out;
 	}
 
-	/*
-	 * We check the trailer here rather than in
-	 * ocfs2_validate_dir_block() because that function doesn't have
-	 * the inode to test.
-	 */
 	if (!(flags & OCFS2_BH_READAHEAD) &&
 	    ocfs2_dir_has_trailer(inode)) {
-		trailer = ocfs2_trailer_from_bh(tmp, inode->i_sb);
-		if (!OCFS2_IS_VALID_DIR_TRAILER(trailer)) {
-			rc = -EINVAL;
-			ocfs2_error(inode->i_sb,
-				    "Invalid dirblock #%llu: "
-				    "signature = %.*s\n",
-				    (unsigned long long)tmp->b_blocknr, 7,
-				    trailer->db_signature);
-			goto out;
-		}
-		if (le64_to_cpu(trailer->db_blkno) != tmp->b_blocknr) {
-			rc = -EINVAL;
-			ocfs2_error(inode->i_sb,
-				    "Directory block #%llu has an invalid "
-				    "db_blkno of %llu",
-				    (unsigned long long)tmp->b_blocknr,
-				    (unsigned long long)le64_to_cpu(trailer->db_blkno));
-			goto out;
-		}
-		if (le64_to_cpu(trailer->db_parent_dinode) !=
-		    OCFS2_I(inode)->ip_blkno) {
-			rc = -EINVAL;
-			ocfs2_error(inode->i_sb,
-				    "Directory block #%llu on dinode "
-				    "#%llu has an invalid parent_dinode "
-				    "of %llu",
-				    (unsigned long long)tmp->b_blocknr,
-				    (unsigned long long)OCFS2_I(inode)->ip_blkno,
-				    (unsigned long long)le64_to_cpu(trailer->db_blkno));
+		rc = ocfs2_check_dir_trailer(inode, tmp);
+		if (rc) {
+			if (!*bh)
+				brelse(tmp);
+			mlog_errno(rc);
 			goto out;
 		}
 	}
@@ -384,6 +496,139 @@ out:
 	return rc ? -EIO : 0;
 }
 
+/*
+ * Read the block at 'phys' which belongs to this directory
+ * inode. This function does no virtual->physical block translation -
+ * what's passed in is assumed to be a valid directory block.
+ */
+static int ocfs2_read_dir_block_direct(struct inode *dir, u64 phys,
+				       struct buffer_head **bh)
+{
+	int ret;
+	struct buffer_head *tmp = *bh;
+
+	ret = ocfs2_read_block(dir, phys, &tmp, ocfs2_validate_dir_block);
+	if (ret) {
+		mlog_errno(ret);
+		goto out;
+	}
+
+	ret = ocfs2_check_dir_trailer(dir, tmp);
+	if (ret) {
+		if (!*bh)
+			brelse(tmp);
+		mlog_errno(ret);
+		goto out;
+	}
+
+	if (!ret && !*bh)
+		*bh = tmp;
+out:
+	return ret;
+}
+
+static int ocfs2_validate_dx_root(struct super_block *sb,
+				  struct buffer_head *bh)
+{
+	int ret;
+	struct ocfs2_dx_root_block *dx_root;
+
+	BUG_ON(!buffer_uptodate(bh));
+
+	dx_root = (struct ocfs2_dx_root_block *) bh->b_data;
+
+	ret = ocfs2_validate_meta_ecc(sb, bh->b_data, &dx_root->dr_check);
+	if (ret) {
+		mlog(ML_ERROR,
+		     "Checksum failed for dir index root block %llu\n",
+		     (unsigned long long)bh->b_blocknr);
+		return ret;
+	}
+
+	if (!OCFS2_IS_VALID_DX_ROOT(dx_root)) {
+		ocfs2_error(sb,
+			    "Dir Index Root # %llu has bad signature %.*s",
+			    (unsigned long long)le64_to_cpu(dx_root->dr_blkno),
+			    7, dx_root->dr_signature);
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+static int ocfs2_read_dx_root(struct inode *dir, struct ocfs2_dinode *di,
+			      struct buffer_head **dx_root_bh)
+{
+	int ret;
+	u64 blkno = le64_to_cpu(di->i_dx_root);
+	struct buffer_head *tmp = *dx_root_bh;
+
+	ret = ocfs2_read_block(dir, blkno, &tmp, ocfs2_validate_dx_root);
+
+	/* If ocfs2_read_block() got us a new bh, pass it up. */
+	if (!ret && !*dx_root_bh)
+		*dx_root_bh = tmp;
+
+	return ret;
+}
+
+static int ocfs2_validate_dx_leaf(struct super_block *sb,
+				  struct buffer_head *bh)
+{
+	int ret;
+	struct ocfs2_dx_leaf *dx_leaf = (struct ocfs2_dx_leaf *)bh->b_data;
+
+	BUG_ON(!buffer_uptodate(bh));
+
+	ret = ocfs2_validate_meta_ecc(sb, bh->b_data, &dx_leaf->dl_check);
+	if (ret) {
+		mlog(ML_ERROR,
+		     "Checksum failed for dir index leaf block %llu\n",
+		     (unsigned long long)bh->b_blocknr);
+		return ret;
+	}
+
+	if (!OCFS2_IS_VALID_DX_LEAF(dx_leaf)) {
+		ocfs2_error(sb, "Dir Index Leaf has bad signature %.*s",
+			    7, dx_leaf->dl_signature);
+		return -EROFS;
+	}
+
+	return 0;
+}
+
+static int ocfs2_read_dx_leaf(struct inode *dir, u64 blkno,
+			      struct buffer_head **dx_leaf_bh)
+{
+	int ret;
+	struct buffer_head *tmp = *dx_leaf_bh;
+
+	ret = ocfs2_read_block(dir, blkno, &tmp, ocfs2_validate_dx_leaf);
+
+	/* If ocfs2_read_block() got us a new bh, pass it up. */
+	if (!ret && !*dx_leaf_bh)
+		*dx_leaf_bh = tmp;
+
+	return ret;
+}
+
+/*
+ * Read a series of dx_leaf blocks. This expects all buffer_head
+ * pointers to be NULL on function entry.
+ */
+static int ocfs2_read_dx_leaves(struct inode *dir, u64 start, int num,
+				struct buffer_head **dx_leaf_bhs)
+{
+	int ret;
+
+	ret = ocfs2_read_blocks(dir, start, num, dx_leaf_bhs, 0,
+				ocfs2_validate_dx_leaf);
+	if (ret)
+		mlog_errno(ret);
+
+	return ret;
+}
+
 static struct buffer_head *ocfs2_find_entry_el(const char *name, int namelen,
 					       struct inode *dir,
 					       struct ocfs2_dir_entry **res_dir)
@@ -485,6 +730,270 @@ cleanup_and_exit:
 	return ret;
 }
 
+static int ocfs2_dx_dir_lookup_rec(struct inode *inode,
+				   struct ocfs2_extent_list *el,
+				   u32 major_hash,
+				   u32 *ret_cpos,
+				   u64 *ret_phys_blkno,
+				   unsigned int *ret_clen)
+{
+	int ret = 0, i, found;
+	struct buffer_head *eb_bh = NULL;
+	struct ocfs2_extent_block *eb;
+	struct ocfs2_extent_rec *rec = NULL;
+
+	if (el->l_tree_depth) {
+		ret = ocfs2_find_leaf(inode, el, major_hash, &eb_bh);
+		if (ret) {
+			mlog_errno(ret);
+			goto out;
+		}
+
+		eb = (struct ocfs2_extent_block *) eb_bh->b_data;
+		el = &eb->h_list;
+
+		if (el->l_tree_depth) {
+			ocfs2_error(inode->i_sb,
+				    "Inode %lu has non zero tree depth in "
+				    "btree tree block %llu\n", inode->i_ino,
+				    (unsigned long long)eb_bh->b_blocknr);
+			ret = -EROFS;
+			goto out;
+		}
+	}
+
+	found = 0;
+	for (i = le16_to_cpu(el->l_next_free_rec) - 1; i >= 0; i--) {
+		rec = &el->l_recs[i];
+
+		if (le32_to_cpu(rec->e_cpos) <= major_hash) {
+			found = 1;
+			break;
+		}
+	}
+
+	if (!found) {
+		ocfs2_error(inode->i_sb, "Inode %lu has bad extent "
+			    "record (%u, %u, 0) in btree", inode->i_ino,
+			    le32_to_cpu(rec->e_cpos),
+			    ocfs2_rec_clusters(el, rec));
+		ret = -EROFS;
+		goto out;
+	}
+
+	if (ret_phys_blkno)
+		*ret_phys_blkno = le64_to_cpu(rec->e_blkno);
+	if (ret_cpos)
+		*ret_cpos = le32_to_cpu(rec->e_cpos);
+	if (ret_clen)
+		*ret_clen = le16_to_cpu(rec->e_leaf_clusters);
+
+out:
+	brelse(eb_bh);
+	return ret;
+}
+
+/*
+ * Returns the block index, from the start of the cluster which this
+ * hash belongs too.
+ */
+static unsigned int ocfs2_dx_dir_hash_idx(struct ocfs2_super *osb,
+					  struct ocfs2_dx_hinfo *hinfo)
+{
+	u32 minor_hash = hinfo->minor_hash;
+	return minor_hash & osb->osb_dx_mask;
+}
+
+static int ocfs2_dx_dir_lookup(struct inode *inode,
+			       struct ocfs2_extent_list *el,
+			       struct ocfs2_dx_hinfo *hinfo,
+			       u32 *ret_cpos,
+			       u64 *ret_phys_blkno)
+{
+	int ret = 0;
+	unsigned int cend, uninitialized_var(clen);
+	u32 uninitialized_var(cpos);
+	u64 uninitialized_var(blkno);
+	u32 name_hash = hinfo->major_hash;
+
+	ret = ocfs2_dx_dir_lookup_rec(inode, el, name_hash, &cpos, &blkno,
+				      &clen);
+	if (ret) {
+		mlog_errno(ret);
+		goto out;
+	}
+
+	cend = cpos + clen;
+	if (name_hash >= cend) {
+		/* We want the last cluster */
+		blkno += ocfs2_clusters_to_blocks(inode->i_sb, clen - 1);
+		cpos += clen - 1;
+	} else {
+		blkno += ocfs2_clusters_to_blocks(inode->i_sb,
+						  name_hash - cpos);
+		cpos = name_hash;
+	}
+
+	/*
+	 * We now have the cluster which should hold our entry. To
+	 * find the exact block from the start of the cluster to
+	 * search, we take the lower bits of the hash.
+	 */
+	blkno += ocfs2_dx_dir_hash_idx(OCFS2_SB(inode->i_sb), hinfo);
+
+	if (ret_phys_blkno)
+		*ret_phys_blkno = blkno;
+	if (ret_cpos)
+		*ret_cpos = cpos;
+
+out:
+
+	return ret;
+}
+
+static int ocfs2_dx_dir_search(const char *name, int namelen,
+			       struct inode *dir,
+			       struct ocfs2_extent_list *dr_el,
+			       struct ocfs2_dir_lookup_result *res)
+{
+	int ret, i, found;
+	u64 uninitialized_var(phys);
+	struct buffer_head *dx_leaf_bh = NULL;
+	struct ocfs2_dx_leaf *dx_leaf;
+	struct ocfs2_dx_entry *dx_entry = NULL;
+	struct buffer_head *dir_ent_bh = NULL;
+	struct ocfs2_dir_entry *dir_ent = NULL;
+	struct ocfs2_dx_hinfo *hinfo = &res->dl_hinfo;
+
+	ocfs2_dx_dir_name_hash(dir, name, namelen, &res->dl_hinfo);
+
+	ret = ocfs2_dx_dir_lookup(dir, dr_el, hinfo, NULL, &phys);
+	if (ret) {
+		mlog_errno(ret);
+		goto out;
+	}
+
+	mlog(0, "Dir %llu: name: \"%.*s\", lookup of hash: %u.0x%x "
+	     "returns: %llu\n",
+	     (unsigned long long)OCFS2_I(dir)->ip_blkno,
+	     namelen, name, hinfo->major_hash, hinfo->minor_hash,
+	     (unsigned long long)phys);
+
+	ret = ocfs2_read_dx_leaf(dir, phys, &dx_leaf_bh);
+	if (ret) {
+		mlog_errno(ret);
+		goto out;
+	}
+
+	dx_leaf = (struct ocfs2_dx_leaf *) dx_leaf_bh->b_data;
+
+	mlog(0, "leaf info: num_used: %d, count: %d\n",
+	     le16_to_cpu(dx_leaf->dl_list.de_num_used),
+	     le16_to_cpu(dx_leaf->dl_list.de_count));
+
+	/*
+	 * Empty leaf is legal, so no need to check for that.
+	 */
+	found = 0;
+	for (i = 0; i < le16_to_cpu(dx_leaf->dl_list.de_num_used); i++) {
+		dx_entry = &dx_leaf->dl_list.de_entries[i];
+
+		if (hinfo->major_hash != le32_to_cpu(dx_entry->dx_major_hash)
+		    || hinfo->minor_hash != le32_to_cpu(dx_entry->dx_minor_hash))
+			continue;
+
+		/*
+		 * Search unindexed leaf block now. We're not
+		 * guaranteed to find anything.
+		 */
+		ret = ocfs2_read_dir_block_direct(dir,
+					  le64_to_cpu(dx_entry->dx_dirent_blk),
+					  &dir_ent_bh);
+		if (ret) {
+			mlog_errno(ret);
+			goto out;
+		}
+
+		/*
+		 * XXX: We should check the unindexed block here,
+		 * before using it.
+		 */
+
+		found = ocfs2_search_dirblock(dir_ent_bh, dir, name, namelen,
+					      0, dir_ent_bh->b_data,
+					      dir->i_sb->s_blocksize, &dir_ent);
+		if (found == 1)
+			break;
+
+		if (found == -1) {
+			/* This means we found a bad directory entry. */
+			ret = -EIO;
+			mlog_errno(ret);
+			goto out;
+		}
+
+		brelse(dir_ent_bh);
+		dir_ent_bh = NULL;
+	}
+
+	if (found <= 0) {
+		ret = -ENOENT;
+		goto out;
+	}
+
+	res->dl_leaf_bh = dir_ent_bh;
+	res->dl_entry = dir_ent;
+	res->dl_dx_leaf_bh = dx_leaf_bh;
+	res->dl_dx_entry = dx_entry;
+
+	ret = 0;
+out:
+	if (ret) {
+		brelse(dx_leaf_bh);
+		brelse(dir_ent_bh);
+	}
+	return ret;
+}
+
+static int ocfs2_find_entry_dx(const char *name, int namelen,
+			       struct inode *dir,
+			       struct ocfs2_dir_lookup_result *lookup)
+{
+	int ret;
+	struct buffer_head *di_bh = NULL;
+	struct ocfs2_dinode *di;
+	struct buffer_head *dx_root_bh = NULL;
+	struct ocfs2_dx_root_block *dx_root;
+
+	ret = ocfs2_read_inode_block(dir, &di_bh);
+	if (ret) {
+		mlog_errno(ret);
+		goto out;
+	}
+
+	di = (struct ocfs2_dinode *)di_bh->b_data;
+
+	ret = ocfs2_read_dx_root(dir, di, &dx_root_bh);
+	if (ret) {
+		mlog_errno(ret);
+		goto out;
+	}
+	dx_root = (struct ocfs2_dx_root_block *) dx_root_bh->b_data;
+
+	ret = ocfs2_dx_dir_search(name, namelen, dir, &dx_root->dr_list,
+				  lookup);
+	if (ret) {
+		if (ret != -ENOENT)
+			mlog_errno(ret);
+		goto out;
+	}
+
+out:
+	brelse(di_bh);
+	brelse(dx_root_bh);
+	return ret;
+}
+
 /*
  * Try to find an entry of the provided name within 'dir'.
  *
@@ -493,10 +1002,11 @@ cleanup_and_exit:
  * other directory manipulation functions.
  *
  * Caller can NOT assume anything about the contents of the
- * buffer_heads - they are passed back only so that it can be passed into
- * any one of the manipulation functions (add entry, delete entry,
- * etc). As an example, bh in the extent directory case is a data
- * block, in the inline-data case it actually points to an inode.
+ * buffer_heads - they are passed back only so that it can be passed
+ * into any one of the manipulation functions (add entry, delete
+ * entry, etc). As an example, bh in the extent directory case is a
+ * data block, in the inline-data case it actually points to an inode,
+ * in the indexed directory case, multiple buffers are involved.
  */
 int ocfs2_find_entry(const char *name, int namelen,
 		     struct inode *dir, struct ocfs2_dir_lookup_result *lookup)
@@ -504,6 +1014,14 @@ int ocfs2_find_entry(const char *name, int namelen,
 	struct buffer_head *bh;
 	struct ocfs2_dir_entry *res_dir = NULL;
 
+	if (ocfs2_dir_indexed(dir))
+		return ocfs2_find_entry_dx(name, namelen, dir, lookup);
+
+	/*
+	 * The unindexed dir code only uses part of the lookup
+	 * structure, so there's no reason to push it down further
+	 * than this.
+	 */
 	if (OCFS2_I(dir)->ip_dyn_features & OCFS2_INLINE_DATA_FL)
 		bh = ocfs2_find_entry_id(name, namelen, dir, &res_dir);
 	else
@@ -553,6 +1071,10 @@ out:
 	return ret;
 }
 
+/*
+ * __ocfs2_delete_entry deletes a directory entry by merging it with the
+ * previous entry
+ */
 static int __ocfs2_delete_entry(handle_t *handle, struct inode *dir,
 				struct ocfs2_dir_entry *de_del,
 				struct buffer_head *bh, char *first_de,
@@ -602,6 +1124,79 @@ bail:
 	return status;
 }
 
+static void ocfs2_dx_leaf_remove_entry(struct ocfs2_dx_leaf *dx_leaf, int index)
+{
+	struct ocfs2_dx_entry_list *dl_list = &dx_leaf->dl_list;
+	int num_used = le16_to_cpu(dl_list->de_num_used);
+
+	if (num_used == 1 || index == (num_used - 1))
+		goto clear;
+
+	memmove(&dl_list->de_entries[index], &dl_list->de_entries[index + 1],
+		(num_used - index - 1)*sizeof(struct ocfs2_dx_entry));
+clear:
+	num_used--;
+	memset(&dl_list->de_entries[num_used], 0,
+	       sizeof(struct ocfs2_dx_entry));
+	dl_list->de_num_used = cpu_to_le16(num_used);
+}
+
+static int ocfs2_delete_entry_dx(handle_t *handle, struct inode *dir,
+				 struct ocfs2_dir_lookup_result *lookup)
+{
+	int ret, index;
+	struct buffer_head *leaf_bh = lookup->dl_leaf_bh;
+	struct ocfs2_dx_leaf *dx_leaf;
+	struct ocfs2_dx_entry *dx_entry = lookup->dl_dx_entry;
+
+	dx_leaf = (struct ocfs2_dx_leaf *) lookup->dl_dx_leaf_bh->b_data;
+	/* Neither of these are a disk corruption - that should have
+	 * been caught by lookup, before we got here. */
+	BUG_ON(le16_to_cpu(dx_leaf->dl_list.de_count) <= 0);
+	BUG_ON(le16_to_cpu(dx_leaf->dl_list.de_num_used) <= 0);
+
+	index = (char *)dx_entry - (char *)dx_leaf->dl_list.de_entries;
+	index /= sizeof(*dx_entry);
+
+	if (index >= le16_to_cpu(dx_leaf->dl_list.de_num_used)) {
+		mlog(ML_ERROR, "Dir %llu: Bad dx_entry ptr idx %d, (%p, %p)\n",
+		     (unsigned long long)OCFS2_I(dir)->ip_blkno, index, dx_leaf,
+		     dx_entry);
+		return -EIO;
+	}
+
+	mlog(0, "Dir %llu: delete entry at index: %d\n",
+	     (unsigned long long)OCFS2_I(dir)->ip_blkno, index);
+
+	/*
+	 * Add the index leaf into the journal before removing the
+	 * unindexed entry. If we get an error return from
+	 * __ocfs2_delete_entry(), then it hasn't removed the entry
+	 * yet. Likewise, successful return means we *must* remove the
+	 * indexed entry.
+	 */
+	ret = ocfs2_journal_access_dl(handle, dir, lookup->dl_dx_leaf_bh,
+				      OCFS2_JOURNAL_ACCESS_WRITE);
+	if (ret) {
+		mlog_errno(ret);
+		goto out;
+	}
+
+	ret = __ocfs2_delete_entry(handle, dir, lookup->dl_entry,
+				   leaf_bh, leaf_bh->b_data, leaf_bh->b_size);
+	if (ret) {
+		mlog_errno(ret);
+		goto out;
+	}
+
+	ocfs2_dx_leaf_remove_entry(dx_leaf, index);
+
+	ocfs2_journal_dirty(handle, lookup->dl_dx_leaf_bh);
+
+out:
+	return ret;
+}
+
 static inline int ocfs2_delete_entry_id(handle_t *handle,
 					struct inode *dir,
 					struct ocfs2_dir_entry *de_del,
@@ -639,13 +1234,16 @@ static inline int ocfs2_delete_entry_el(handle_t *handle,
 }
 
 /*
- * ocfs2_delete_entry deletes a directory entry by merging it with the
- * previous entry
+ * Delete a directory entry. Hide the details of directory
+ * implementation from the caller.
  */
 int ocfs2_delete_entry(handle_t *handle,
 		       struct inode *dir,
 		       struct ocfs2_dir_lookup_result *res)
 {
+	if (ocfs2_dir_indexed(dir))
+		return ocfs2_delete_entry_dx(handle, dir, res);
+
 	if (OCFS2_I(dir)->ip_dyn_features & OCFS2_INLINE_DATA_FL)
 		return ocfs2_delete_entry_id(handle, dir, res->dl_entry,
 					     res->dl_leaf_bh);
@@ -679,6 +1277,58 @@ static inline int ocfs2_dirent_would_fit(struct ocfs2_dir_entry *de,
 	return 0;
 }
 
+static void ocfs2_dx_dir_leaf_insert_tail(struct ocfs2_dx_leaf *dx_leaf,
+					  struct ocfs2_dx_entry *dx_new_entry)
+{
+	int i;
+
+	i = le16_to_cpu(dx_leaf->dl_list.de_num_used);
+	dx_leaf->dl_list.de_entries[i] = *dx_new_entry;
+
+	le16_add_cpu(&dx_leaf->dl_list.de_num_used, 1);
+}
+
+static int __ocfs2_dx_dir_leaf_insert(struct inode *dir, handle_t *handle,
+				      struct ocfs2_dx_hinfo *hinfo,
+				      u64 dirent_blk,
+				      struct buffer_head *dx_leaf_bh)
+{
+	int ret, i;
+	struct ocfs2_dx_entry *dx_entry;
+	struct ocfs2_dx_leaf *dx_leaf;
+
+	ret = ocfs2_journal_access_dl(handle, dir, dx_leaf_bh,
+				      OCFS2_JOURNAL_ACCESS_WRITE);
+	if (ret) {
+		mlog_errno(ret);
+		goto out;
+	}
+
+	dx_leaf = (struct ocfs2_dx_leaf *)dx_leaf_bh->b_data;
+	i = le16_to_cpu(dx_leaf->dl_list.de_num_used);
+	dx_entry = &dx_leaf->dl_list.de_entries[i];
+
+	memset(dx_entry, 0, sizeof(*dx_entry));
+	dx_entry->dx_major_hash = cpu_to_le32(hinfo->major_hash);
+	dx_entry->dx_minor_hash = cpu_to_le32(hinfo->minor_hash);
+	dx_entry->dx_dirent_blk = cpu_to_le64(dirent_blk);
+
+	le16_add_cpu(&dx_leaf->dl_list.de_num_used, 1);
+
+	ocfs2_journal_dirty(handle, dx_leaf_bh);
+
+out:
+	return ret;
+}
+
+static int ocfs2_dx_dir_leaf_insert(struct inode *dir, handle_t *handle,
+				    struct ocfs2_dir_lookup_result *lookup)
+{
+	return __ocfs2_dx_dir_leaf_insert(dir, handle, &lookup->dl_hinfo,
+					  lookup->dl_leaf_bh->b_blocknr,
+					  lookup->dl_dx_leaf_bh);
+}
+
 /* we don't always have a dentry for what we want to add, so people
  * like orphan dir can call this instead.
  *
@@ -754,10 +1404,21 @@ int __ocfs2_add_entry(handle_t *handle,
 				status = ocfs2_journal_access_di(handle, dir,
 								 insert_bh,
 								 OCFS2_JOURNAL_ACCESS_WRITE);
-			else
+			else {
 				status = ocfs2_journal_access_db(handle, dir,
 								 insert_bh,
 								 OCFS2_JOURNAL_ACCESS_WRITE);
+				if (ocfs2_dir_indexed(dir)) {
+					status = ocfs2_dx_dir_leaf_insert(dir,
+									handle,
+									lookup);
+					if (status) {
+						mlog_errno(status);
+						goto bail;
+					}
+				}
+			}
+
 			/* By now the buffer is marked for journaling */
 			offset += le16_to_cpu(de->rec_len);
 			if (le64_to_cpu(de->inode)) {
@@ -887,6 +1548,10 @@ out:
 	return 0;
 }
 
+/*
+ * NOTE: This function can be called against unindexed directories,
+ * and indexed ones.
+ */
 static int ocfs2_dir_foreach_blk_el(struct inode *inode,
 				    u64 *f_version,
 				    loff_t *f_pos, void *priv,
@@ -1184,6 +1849,8 @@ static int ocfs2_empty_dir_filldir(void *priv, const char *name, int name_len,
  * routine to check that the specified directory is empty (for rmdir)
  *
  * Returns 1 if dir is empty, zero otherwise.
+ *
+ * XXX: This is a performance problem
  */
 int ocfs2_empty_dir(struct inode *inode)
 {
@@ -1285,7 +1952,8 @@ static int ocfs2_fill_new_dir_el(struct ocfs2_super *osb,
 				 struct inode *parent,
 				 struct inode *inode,
 				 struct buffer_head *fe_bh,
-				 struct ocfs2_alloc_context *data_ac)
+				 struct ocfs2_alloc_context *data_ac,
+				 struct buffer_head **ret_new_bh)
 {
 	int status;
 	unsigned int size = osb->sb->s_blocksize;
@@ -1334,6 +2002,10 @@ static int ocfs2_fill_new_dir_el(struct ocfs2_super *osb,
 	}
 
 	status = 0;
+	if (ret_new_bh) {
+		*ret_new_bh = new_bh;
+		new_bh = NULL;
+	}
 bail:
 	brelse(new_bh);
 
@@ -1341,20 +2013,382 @@ bail:
 	return status;
 }
 
+static int ocfs2_dx_dir_attach_index(struct ocfs2_super *osb,
+				     handle_t *handle, struct inode *dir,
+				     struct buffer_head *di_bh,
+				     struct ocfs2_alloc_context *meta_ac,
+				     struct buffer_head **ret_dx_root_bh)
+{
+	int ret;
+	struct ocfs2_dinode *di = (struct ocfs2_dinode *) di_bh->b_data;
+	u16 dr_suballoc_bit;
+	u64 dr_blkno;
+	unsigned int num_bits;
+	struct buffer_head *dx_root_bh = NULL;
+	struct ocfs2_dx_root_block *dx_root;
+
+	ret = ocfs2_claim_metadata(osb, handle, meta_ac, 1, &dr_suballoc_bit,
+				   &num_bits, &dr_blkno);
+	if (ret) {
+		mlog_errno(ret);
+		goto out;
+	}
+
+	mlog(0, "Dir %llu, attach new index block: %llu\n",
+	     (unsigned long long)OCFS2_I(dir)->ip_blkno,
+	     (unsigned long long)dr_blkno);
+
+	dx_root_bh = sb_getblk(osb->sb, dr_blkno);
+	if (dx_root_bh == NULL) {
+		ret = -EIO;
+		goto out;
+	}
+	ocfs2_set_new_buffer_uptodate(dir, dx_root_bh);
+
+	ret = ocfs2_journal_access_dr(handle, dir, dx_root_bh,
+				      OCFS2_JOURNAL_ACCESS_CREATE);
+	if (ret < 0) {
+		mlog_errno(ret);
+		goto out;
+	}
+
+	dx_root = (struct ocfs2_dx_root_block *)dx_root_bh->b_data;
+	memset(dx_root, 0, osb->sb->s_blocksize);
+	strcpy(dx_root->dr_signature, OCFS2_DX_ROOT_SIGNATURE);
+	dx_root->dr_suballoc_slot = cpu_to_le16(osb->slot_num);
+	dx_root->dr_suballoc_bit = cpu_to_le16(dr_suballoc_bit);
+	dx_root->dr_fs_generation = cpu_to_le32(osb->fs_generation);
+	dx_root->dr_blkno = cpu_to_le64(dr_blkno);
+	dx_root->dr_dir_blkno = cpu_to_le64(OCFS2_I(dir)->ip_blkno);
+	dx_root->dr_list.l_count =
+		cpu_to_le16(ocfs2_extent_recs_per_dx_root(osb->sb));
+
+	ret = ocfs2_journal_dirty(handle, dx_root_bh);
+	if (ret)
+		mlog_errno(ret);
+
+	ret = ocfs2_journal_access_di(handle, dir, di_bh,
+				      OCFS2_JOURNAL_ACCESS_CREATE);
+	if (ret) {
+		mlog_errno(ret);
+		goto out;
+	}
+
+	di->i_dx_root = cpu_to_le64(dr_blkno);
+
+	OCFS2_I(dir)->ip_dyn_features |= OCFS2_INDEXED_DIR_FL;
+	di->i_dyn_features = cpu_to_le16(OCFS2_I(dir)->ip_dyn_features);
+
+	ret = ocfs2_journal_dirty(handle, di_bh);
+	if (ret)
+		mlog_errno(ret);
+
+	*ret_dx_root_bh = dx_root_bh;
+	dx_root_bh = NULL;
+
+out:
+	brelse(dx_root_bh);
+	return ret;
+}
+
+static int ocfs2_dx_dir_format_cluster(struct ocfs2_super *osb,
+				       handle_t *handle, struct inode *dir,
+				       struct buffer_head **dx_leaves,
+				       int num_dx_leaves, u64 start_blk)
+{
+	int ret, i;
+	struct ocfs2_dx_leaf *dx_leaf;
+	struct buffer_head *bh;
+
+	for (i = 0; i < num_dx_leaves; i++) {
+		bh = sb_getblk(osb->sb, start_blk + i);
+		if (bh == NULL) {
+			ret = -EIO;
+			goto out;
+		}
+		dx_leaves[i] = bh;
+
+		ocfs2_set_new_buffer_uptodate(dir, bh);
+
+		ret = ocfs2_journal_access_dl(handle, dir, bh,
+					      OCFS2_JOURNAL_ACCESS_CREATE);
+		if (ret < 0) {
+			mlog_errno(ret);
+			goto out;
+		}
+
+		dx_leaf = (struct ocfs2_dx_leaf *) bh->b_data;
+
+		memset(dx_leaf, 0, osb->sb->s_blocksize);
+		strcpy(dx_leaf->dl_signature, OCFS2_DX_LEAF_SIGNATURE);
+		dx_leaf->dl_fs_generation = cpu_to_le32(osb->fs_generation);
+		dx_leaf->dl_blkno = cpu_to_le64(bh->b_blocknr);
+		dx_leaf->dl_list.de_count =
+			cpu_to_le16(ocfs2_dx_entries_per_leaf(osb->sb));
+
+		mlog(0,
+		     "Dir %llu, format dx_leaf: %llu, entry count: %u\n",
+		     (unsigned long long)OCFS2_I(dir)->ip_blkno,
+		     (unsigned long long)bh->b_blocknr,
+		     le16_to_cpu(dx_leaf->dl_list.de_count));
+
+		ocfs2_journal_dirty(handle, bh);
+	}
+
+	ret = 0;
+out:
+	return ret;
+}
+
+/*
+ * Allocates and formats a new cluster for use in an indexed dir
+ * leaf. This version will not do the extent insert, so that it can be
+ * used by operations which need careful ordering.
+ */
+static int __ocfs2_dx_dir_new_cluster(struct inode *dir,
+				      u32 cpos, handle_t *handle,
+				      struct ocfs2_alloc_context *data_ac,
+				      struct buffer_head **dx_leaves,
+				      int num_dx_leaves, u64 *ret_phys_blkno)
+{
+	int ret;
+	u32 phys, num;
+	u64 phys_blkno;
+	struct ocfs2_super *osb = OCFS2_SB(dir->i_sb);
+
+	/*
+	 * XXX: For create, this should claim cluster for the index
+	 * *before* the unindexed insert so that we have a better
+	 * chance of contiguousness as the directory grows in number
+	 * of entries.
+	 */
+	ret = __ocfs2_claim_clusters(osb, handle, data_ac, 1, 1, &phys, &num);
+	if (ret) {
+		mlog_errno(ret);
+		goto out;
+	}
+
+	/*
+	 * Format the new cluster first. That way, we're inserting
+	 * valid data.
+	 */
+	phys_blkno = ocfs2_clusters_to_blocks(osb->sb, phys);
+	ret = ocfs2_dx_dir_format_cluster(osb, handle, dir, dx_leaves,
+					  num_dx_leaves, phys_blkno);
+	if (ret) {
+		mlog_errno(ret);
+		goto out;
+	}
+
+	*ret_phys_blkno = phys_blkno;
+out:
+	return ret;
+}
+
+static int ocfs2_dx_dir_new_cluster(struct inode *dir,
+				    struct ocfs2_extent_tree *et,
+				    u32 cpos, handle_t *handle,
+				    struct ocfs2_alloc_context *data_ac,
+				    struct ocfs2_alloc_context *meta_ac,
+				    struct buffer_head **dx_leaves,
+				    int num_dx_leaves)
+{
+	int ret;
+	u64 phys_blkno;
+	struct ocfs2_super *osb = OCFS2_SB(dir->i_sb);
+
+	ret = __ocfs2_dx_dir_new_cluster(dir, cpos, handle, data_ac, dx_leaves,
+					 num_dx_leaves, &phys_blkno);
+	if (ret) {
+		mlog_errno(ret);
+		goto out;
+	}
+
+	ret = ocfs2_insert_extent(osb, handle, dir, et, cpos, phys_blkno, 1, 0,
+				  meta_ac);
+	if (ret)
+		mlog_errno(ret);
+out:
+	return ret;
+}
+
+static struct buffer_head **ocfs2_dx_dir_kmalloc_leaves(struct super_block *sb,
+							int *ret_num_leaves)
+{
+	int num_dx_leaves = ocfs2_clusters_to_blocks(sb, 1);
+	struct buffer_head **dx_leaves;
+
+	dx_leaves = kcalloc(num_dx_leaves, sizeof(struct buffer_head *),
+			    GFP_NOFS);
+	if (dx_leaves && ret_num_leaves)
+		*ret_num_leaves = num_dx_leaves;
+
+	return dx_leaves;
+}
+
+static int ocfs2_fill_new_dir_dx(struct ocfs2_super *osb,
+				 handle_t *handle,
+				 struct inode *parent,
+				 struct inode *inode,
+				 struct buffer_head *di_bh,
+				 struct ocfs2_alloc_context *data_ac,
+				 struct ocfs2_alloc_context *meta_ac)
+{
+	int ret, num_dx_leaves, i;
+	struct buffer_head *leaf_bh = NULL;
+	struct buffer_head *dx_root_bh = NULL;
+	struct buffer_head **dx_leaves = NULL;
+	struct ocfs2_extent_tree et;
+	struct ocfs2_dx_hinfo hinfo;
+	u64 insert_blkno;
+
+	dx_leaves = ocfs2_dx_dir_kmalloc_leaves(osb->sb, &num_dx_leaves);
+	if (!dx_leaves) {
+		ret = -ENOMEM;
+		mlog_errno(ret);
+		goto out;
+	}
+
+	/*
+	 * Our strategy is to create the directory as though it were
+	 * unindexed, then add the index block. This works with very
+	 * little complication since the state of a new directory is a
+	 * very well known quantity.
+	 *
+	 * Essentially, we have two dirents ("." and ".."), in the 1st
+	 * block which need indexing.
+	 */
+
+	ret = ocfs2_fill_new_dir_el(osb, handle, parent, inode, di_bh,
+				    data_ac, &leaf_bh);
+	if (ret) {
+		mlog_errno(ret);
+		goto out;
+	}
+
+	/*
+	 * Allocate and format the index leaf first, before attaching
+	 * the index root. That way we're sure that the main bitmap
+	 * won't -enospc on us with a half-created dir index.
+	 *
+	 * The meta data allocation for our index block will not
+	 * -enospc on us unless there is a disk corruption.
+	 */
+
+	ret = __ocfs2_dx_dir_new_cluster(inode, 0, handle, data_ac, dx_leaves,
+					 num_dx_leaves, &insert_blkno);
+	if (ret) {
+		mlog_errno(ret);
+		goto out;
+	}
+
+	ocfs2_dx_dir_name_hash(inode, ".", 1, &hinfo);
+	i = ocfs2_dx_dir_hash_idx(osb, &hinfo);
+	ret = __ocfs2_dx_dir_leaf_insert(inode, handle, &hinfo,
+					 leaf_bh->b_blocknr, dx_leaves[i]);
+	if (ret) {
+		mlog_errno(ret);
+		goto out;
+	}
+
+	ocfs2_dx_dir_name_hash(inode, "..", 2, &hinfo);
+	i = ocfs2_dx_dir_hash_idx(osb, &hinfo);
+	ret = __ocfs2_dx_dir_leaf_insert(inode, handle, &hinfo,
+					 leaf_bh->b_blocknr, dx_leaves[i]);
+	if (ret) {
+		mlog_errno(ret);
+		goto out;
+	}
+
+	ret = ocfs2_dx_dir_attach_index(osb, handle, inode, di_bh, meta_ac,
+					&dx_root_bh);
+	if (ret) {
+		mlog_errno(ret);
+		goto out;
+	}
+
+	/* This should never fail considering we start with an empty
+	 * dx_root. */
+	ocfs2_init_dx_root_extent_tree(&et, inode, dx_root_bh);
+	ret = ocfs2_insert_extent(osb, handle, inode, &et, 0,
+				  insert_blkno, 1, 0, NULL);
+	if (ret)
+		mlog_errno(ret);
+
+out:
+	if (dx_leaves) {
+		for (i = 0; i < num_dx_leaves; i++)
+			brelse(dx_leaves[i]);
+		kfree(dx_leaves);
+	}
+	brelse(dx_root_bh);
+	brelse(leaf_bh);
+	return ret;
+}
+
 int ocfs2_fill_new_dir(struct ocfs2_super *osb,
 		       handle_t *handle,
 		       struct inode *parent,
 		       struct inode *inode,
 		       struct buffer_head *fe_bh,
-		       struct ocfs2_alloc_context *data_ac)
+		       struct ocfs2_alloc_context *data_ac,
+		       struct ocfs2_alloc_context *meta_ac)
+
 {
 	BUG_ON(!ocfs2_supports_inline_data(osb) && data_ac == NULL);
 
 	if (OCFS2_I(inode)->ip_dyn_features & OCFS2_INLINE_DATA_FL)
 		return ocfs2_fill_new_dir_id(osb, handle, parent, inode, fe_bh);
 
+	if (ocfs2_supports_indexed_dirs(osb))
+		return ocfs2_fill_new_dir_dx(osb, handle, parent, inode, fe_bh,
+					     data_ac, meta_ac);
+
 	return ocfs2_fill_new_dir_el(osb, handle, parent, inode, fe_bh,
-				     data_ac);
+				     data_ac, NULL);
+}
+
+static int ocfs2_dx_dir_index_block(struct inode *dir,
+				    handle_t *handle,
+				    struct buffer_head **dx_leaves,
+				    int num_dx_leaves,
+				    struct buffer_head *dirent_bh)
+{
+	int ret, namelen, i;
+	char *de_buf, *limit;
+	struct ocfs2_dir_entry *de;
+	struct buffer_head *dx_leaf_bh;
+	struct ocfs2_dx_hinfo hinfo;
+	u64 dirent_blk = dirent_bh->b_blocknr;
+
+	de_buf = dirent_bh->b_data;
+	limit = de_buf + dir->i_sb->s_blocksize;
+
+	while (de_buf < limit) {
+		de = (struct ocfs2_dir_entry *)de_buf;
+
+		namelen = de->name_len;
+		if (!namelen || !de->inode)
+			goto inc;
+
+		ocfs2_dx_dir_name_hash(dir, de->name, namelen, &hinfo);
+
+		i = ocfs2_dx_dir_hash_idx(OCFS2_SB(dir->i_sb), &hinfo);
+		dx_leaf_bh = dx_leaves[i];
+
+		ret = __ocfs2_dx_dir_leaf_insert(dir, handle, &hinfo,
+						 dirent_blk, dx_leaf_bh);
+		if (ret) {
+			mlog_errno(ret);
+			goto out;
+		}
+
+inc:
+		de_buf += le16_to_cpu(de->rec_len);
+	}
+
+out:
+	return ret;
 }
 
 /*
@@ -1401,29 +2435,57 @@ static void ocfs2_expand_last_dirent(char *start, unsigned int old_size,
  */
 static int ocfs2_expand_inline_dir(struct inode *dir, struct buffer_head *di_bh,
 				   unsigned int blocks_wanted,
+				   struct ocfs2_dir_lookup_result *lookup,
 				   struct buffer_head **first_block_bh)
 {
-	u32 alloc, bit_off, len;
+	u32 alloc, dx_alloc, bit_off, len;
 	struct super_block *sb = dir->i_sb;
-	int ret, credits = ocfs2_inline_to_extents_credits(sb);
-	u64 blkno, bytes = blocks_wanted << sb->s_blocksize_bits;
+	int ret, i, num_dx_leaves = 0,
+		credits = ocfs2_inline_to_extents_credits(sb);
+	u64 dx_insert_blkno, blkno,
+		bytes = blocks_wanted << sb->s_blocksize_bits;
 	struct ocfs2_super *osb = OCFS2_SB(dir->i_sb);
 	struct ocfs2_inode_info *oi = OCFS2_I(dir);
 	struct ocfs2_alloc_context *data_ac;
+	struct ocfs2_alloc_context *meta_ac = NULL;
 	struct buffer_head *dirdata_bh = NULL;
+	struct buffer_head *dx_root_bh = NULL;
+	struct buffer_head **dx_leaves = NULL;
 	struct ocfs2_dinode *di = (struct ocfs2_dinode *)di_bh->b_data;
 	handle_t *handle;
 	struct ocfs2_extent_tree et;
-	int did_quota = 0;
+	struct ocfs2_extent_tree dx_et;
+	int did_quota = 0, bytes_allocated = 0;
 
 	ocfs2_init_dinode_extent_tree(&et, dir, di_bh);
 
 	alloc = ocfs2_clusters_for_bytes(sb, bytes);
+	dx_alloc = 0;
+
+	if (ocfs2_supports_indexed_dirs(osb)) {
+		/* Add one more cluster for an index leaf */
+		dx_alloc++;
+		credits += ocfs2_add_dir_index_credits(sb);
+
+		dx_leaves = ocfs2_dx_dir_kmalloc_leaves(sb, &num_dx_leaves);
+		if (!dx_leaves) {
+			ret = -ENOMEM;
+			mlog_errno(ret);
+			goto out;
+		}
+
+		/* This gets us the dx_root */
+		ret = ocfs2_reserve_new_metadata_blocks(osb, 1, &meta_ac);
+		if (ret) {
+			mlog_errno(ret);
+			goto out;
+		}
+	}
 
 	/*
-	 * We should never need more than 2 clusters for this -
-	 * maximum dirent size is far less than one block. In fact,
-	 * the only time we'd need more than one cluster is if
+	 * We should never need more than 2 clusters for the unindexed
+	 * tree - maximum dirent size is far less than one block. In
+	 * fact, the only time we'd need more than one cluster is if
 	 * blocksize == clustersize and the dirent won't fit in the
 	 * extra space that the expansion to a single block gives. As
 	 * of today, that only happens on 4k/4k file systems.
@@ -1440,7 +2502,7 @@ static int ocfs2_expand_inline_dir(struct inode *dir, struct buffer_head *di_bh,
 
 	/*
 	 * Prepare for worst case allocation scenario of two separate
-	 * extents.
+	 * extents in the unindexed tree.
 	 */
 	if (alloc == 2)
 		credits += OCFS2_SUBALLOC_ALLOC;
@@ -1453,11 +2515,29 @@ static int ocfs2_expand_inline_dir(struct inode *dir, struct buffer_head *di_bh,
 	}
 
 	if (vfs_dq_alloc_space_nodirty(dir,
-				ocfs2_clusters_to_bytes(osb->sb, alloc))) {
+				ocfs2_clusters_to_bytes(osb->sb,
+							alloc + dx_alloc))) {
 		ret = -EDQUOT;
 		goto out_commit;
 	}
 	did_quota = 1;
+
+	if (ocfs2_supports_indexed_dirs(osb)) {
+		/*
+		 * Allocate our index cluster first, to maximize the
+		 * possibility that unindexed leaves grow
+		 * contiguously.
+		 */
+		ret = __ocfs2_dx_dir_new_cluster(dir, 0, handle, data_ac,
+						 dx_leaves, num_dx_leaves,
+						 &dx_insert_blkno);
+		if (ret) {
+			mlog_errno(ret);
+			goto out_commit;
+		}
+		bytes_allocated += ocfs2_clusters_to_bytes(dir->i_sb, 1);
+	}
+
 	/*
 	 * Try to claim as many clusters as the bitmap can give though
 	 * if we only get one now, that's enough to continue. The rest
@@ -1468,6 +2548,7 @@ static int ocfs2_expand_inline_dir(struct inode *dir, struct buffer_head *di_bh,
 		mlog_errno(ret);
 		goto out_commit;
 	}
+	bytes_allocated += ocfs2_clusters_to_bytes(dir->i_sb, 1);
 
 	/*
 	 * Operations are carefully ordered so that we set up the new
@@ -1504,6 +2585,15 @@ static int ocfs2_expand_inline_dir(struct inode *dir, struct buffer_head *di_bh,
 		goto out_commit;
 	}
 
+	if (ocfs2_supports_indexed_dirs(osb)) {
+		ret = ocfs2_dx_dir_index_block(dir, handle, dx_leaves,
+					       num_dx_leaves, dirdata_bh);
+		if (ret) {
+			mlog_errno(ret);
+			goto out_commit;
+		}
+	}
+
 	/*
 	 * Set extent, i_size, etc on the directory. After this, the
 	 * inode should contain the same exact dirents as before and
@@ -1556,6 +2646,21 @@ static int ocfs2_expand_inline_dir(struct inode *dir, struct buffer_head *di_bh,
 		goto out_commit;
 	}
 
+	if (ocfs2_supports_indexed_dirs(osb)) {
+		ret = ocfs2_dx_dir_attach_index(osb, handle, dir, di_bh,
+						meta_ac, &dx_root_bh);
+		if (ret) {
+			mlog_errno(ret);
+			goto out_commit;
+		}
+
+		ocfs2_init_dx_root_extent_tree(&dx_et, dir, dx_root_bh);
+		ret = ocfs2_insert_extent(osb, handle, dir, &dx_et, 0,
+					  dx_insert_blkno, 1, 0, NULL);
+		if (ret)
+			mlog_errno(ret);
+	}
+
 	/*
 	 * We asked for two clusters, but only got one in the 1st
 	 * pass. Claim the 2nd cluster as a separate extent.
@@ -1575,15 +2680,28 @@ static int ocfs2_expand_inline_dir(struct inode *dir, struct buffer_head *di_bh,
 			mlog_errno(ret);
 			goto out_commit;
 		}
+		bytes_allocated += ocfs2_clusters_to_bytes(dir->i_sb, 1);
 	}
 
 	*first_block_bh = dirdata_bh;
 	dirdata_bh = NULL;
+	if (ocfs2_supports_indexed_dirs(osb)) {
+		unsigned int off;
+
+		/*
+		 * We need to return the correct block within the
+		 * cluster which should hold our entry.
+		 */
+		off = ocfs2_dx_dir_hash_idx(OCFS2_SB(dir->i_sb),
+					    &lookup->dl_hinfo);
+		get_bh(dx_leaves[off]);
+		lookup->dl_dx_leaf_bh = dx_leaves[off];
+	}
 
 out_commit:
 	if (ret < 0 && did_quota)
-		vfs_dq_free_space_nodirty(dir,
-			ocfs2_clusters_to_bytes(osb->sb, 2));
+		vfs_dq_free_space_nodirty(dir, bytes_allocated);
+
 	ocfs2_commit_trans(osb, handle);
 
 out_sem:
@@ -1592,8 +2710,17 @@ out_sem:
 out:
 	if (data_ac)
 		ocfs2_free_alloc_context(data_ac);
+	if (meta_ac)
+		ocfs2_free_alloc_context(meta_ac);
+
+	if (dx_leaves) {
+		for (i = 0; i < num_dx_leaves; i++)
+			brelse(dx_leaves[i]);
+		kfree(dx_leaves);
+	}
 
 	brelse(dirdata_bh);
+	brelse(dx_root_bh);
 
 	return ret;
 }
@@ -1668,6 +2795,7 @@ static int ocfs2_extend_dir(struct ocfs2_super *osb,
 			    struct inode *dir,
 			    struct buffer_head *parent_fe_bh,
 			    unsigned int blocks_wanted,
+			    struct ocfs2_dir_lookup_result *lookup,
 			    struct buffer_head **new_de_bh)
 {
 	int status = 0;
@@ -1687,7 +2815,8 @@ static int ocfs2_extend_dir(struct ocfs2_super *osb,
 
 	if (OCFS2_I(dir)->ip_dyn_features & OCFS2_INLINE_DATA_FL) {
 		status = ocfs2_expand_inline_dir(dir, parent_fe_bh,
-						 blocks_wanted, &new_bh);
+						 blocks_wanted, lookup,
+						 &new_bh);
 		if (status) {
 			mlog_errno(status);
 			goto bail;
@@ -1975,6 +3104,487 @@ bail:
 	return status;
 }
 
+static int dx_leaf_sort_cmp(const void *a, const void *b)
+{
+	const struct ocfs2_dx_entry *entry1 = a;
+	const struct ocfs2_dx_entry *entry2 = b;
+	u32 major_hash1 = le32_to_cpu(entry1->dx_major_hash);
+	u32 major_hash2 = le32_to_cpu(entry2->dx_major_hash);
+	u32 minor_hash1 = le32_to_cpu(entry1->dx_minor_hash);
+	u32 minor_hash2 = le32_to_cpu(entry2->dx_minor_hash);
+
+	if (major_hash1 > major_hash2)
+		return 1;
+	if (major_hash1 < major_hash2)
+		return -1;
+
+	/*
+	 * It is not strictly necessary to sort by minor
+	 */
+	if (minor_hash1 > minor_hash2)
+		return 1;
+	if (minor_hash1 < minor_hash2)
+		return -1;
+	return 0;
+}
+
+static void dx_leaf_sort_swap(void *a, void *b, int size)
+{
+	struct ocfs2_dx_entry *entry1 = a;
+	struct ocfs2_dx_entry *entry2 = b;
+	struct ocfs2_dx_entry tmp;
+
+	BUG_ON(size != sizeof(*entry1));
+
+	tmp = *entry1;
+	*entry1 = *entry2;
+	*entry2 = tmp;
+}
+
+static int ocfs2_dx_leaf_same_major(struct ocfs2_dx_leaf *dx_leaf)
+{
+	struct ocfs2_dx_entry_list *dl_list = &dx_leaf->dl_list;
+	int i, num = le16_to_cpu(dl_list->de_num_used);
+
+	for (i = 0; i < (num - 1); i++) {
+		if (le32_to_cpu(dl_list->de_entries[i].dx_major_hash) !=
+		    le32_to_cpu(dl_list->de_entries[i + 1].dx_major_hash))
+			return 0;
+	}
+
+	return 1;
+}
+
+/*
+ * Find the optimal value to split this leaf on. This expects the leaf
+ * entries to be in sorted order.
+ *
+ * leaf_cpos is the cpos of the leaf we're splitting. insert_hash is
+ * the hash we want to insert.
+ *
+ * This function is only concerned with the major hash - that which
+ * determines which cluster an item belongs to.
+ */
+static int ocfs2_dx_dir_find_leaf_split(struct ocfs2_dx_leaf *dx_leaf,
+					u32 leaf_cpos, u32 insert_hash,
+					u32 *split_hash)
+{
+	struct ocfs2_dx_entry_list *dl_list = &dx_leaf->dl_list;
+	int i, num_used = le16_to_cpu(dl_list->de_num_used);
+	int allsame;
+
+	/*
+	 * There's a couple rare, but nasty corner cases we have to
+	 * check for here. All of them involve a leaf where all value
+	 * have the same hash, which is what we look for first.
+	 *
+	 * Most of the time, all of the above is false, and we simply
+	 * pick the median value for a split.
+	 */
+	allsame = ocfs2_dx_leaf_same_major(dx_leaf);
+	if (allsame) {
+		u32 val = le32_to_cpu(dl_list->de_entries[0].dx_major_hash);
+
+		if (val == insert_hash) {
+			/*
+			 * No matter where we would choose to split,
+			 * the new entry would want to occupy the same
+			 * block as these. Since there's no space left
+			 * in their existing block, we know there
+			 * won't be space after the split.
+			 */
+			return -ENOSPC;
+		}
+
+		if (val == leaf_cpos) {
+			/*
+			 * Because val is the same as leaf_cpos (which
+			 * is the smallest value this leaf can have),
+			 * yet is not equal to insert_hash, then we
+			 * know that insert_hash *must* be larger than
+			 * val (and leaf_cpos). At least cpos+1 in value.
+			 *
+			 * We also know then, that there cannot be an
+			 * adjacent extent (otherwise we'd be looking
+			 * at it). Choosing this value gives us a
+			 * chance to get some contiguousness.
+			 */
+			*split_hash = leaf_cpos + 1;
+			return 0;
+		}
+
+		if (val > insert_hash) {
+			/*
+			 * val can not be the same as insert hash, and
+			 * also must be larger than leaf_cpos. Also,
+			 * we know that there can't be a leaf between
+			 * cpos and val, otherwise the entries with
+			 * hash 'val' would be there.
+			 */
+			*split_hash = val;
+			return 0;
+		}
+
+		*split_hash = insert_hash;
+		return 0;
+	}
+
+	/*
+	 * Since the records are sorted and the checks above
+	 * guaranteed that not all records in this block are the same,
+	 * we simple travel forward, from the median, and pick the 1st
+	 * record whose value is larger than leaf_cpos.
+	 */
+	for (i = (num_used / 2); i < num_used; i++)
+		if (le32_to_cpu(dl_list->de_entries[i].dx_major_hash) >
+		    leaf_cpos)
+			break;
+
+	BUG_ON(i == num_used); /* Should be impossible */
+	*split_hash = le32_to_cpu(dl_list->de_entries[i].dx_major_hash);
+	return 0;
+}
+
+/*
+ * Transfer all entries in orig_dx_leaves whose major hash is equal to or
+ * larger than split_hash into new_dx_leaves. We use a temporary
+ * buffer (tmp_dx_leaf) to make the changes to the original leaf blocks.
+ *
+ * Since the block offset inside a leaf (cluster) is a constant mask
+ * of minor_hash, we can optimize - an item at block offset X within
+ * the original cluster, will be at offset X within the new cluster.
+ */
+static void ocfs2_dx_dir_transfer_leaf(struct inode *dir, u32 split_hash,
+				       handle_t *handle,
+				       struct ocfs2_dx_leaf *tmp_dx_leaf,
+				       struct buffer_head **orig_dx_leaves,
+				       struct buffer_head **new_dx_leaves,
+				       int num_dx_leaves)
+{
+	int i, j, num_used;
+	u32 major_hash;
+	struct ocfs2_dx_leaf *orig_dx_leaf, *new_dx_leaf;
+	struct ocfs2_dx_entry_list *orig_list, *new_list, *tmp_list;
+	struct ocfs2_dx_entry *dx_entry;
+
+	tmp_list = &tmp_dx_leaf->dl_list;
+
+	for (i = 0; i < num_dx_leaves; i++) {
+		orig_dx_leaf = (struct ocfs2_dx_leaf *) orig_dx_leaves[i]->b_data;
+		orig_list = &orig_dx_leaf->dl_list;
+		new_dx_leaf = (struct ocfs2_dx_leaf *) new_dx_leaves[i]->b_data;
+		new_list = &new_dx_leaf->dl_list;
+
+		num_used = le16_to_cpu(orig_list->de_num_used);
+
+		memcpy(tmp_dx_leaf, orig_dx_leaf, dir->i_sb->s_blocksize);
+		tmp_list->de_num_used = cpu_to_le16(0);
+		memset(&tmp_list->de_entries, 0, sizeof(*dx_entry)*num_used);
+
+		for (j = 0; j < num_used; j++) {
+			dx_entry = &orig_list->de_entries[j];
+			major_hash = le32_to_cpu(dx_entry->dx_major_hash);
+			if (major_hash >= split_hash)
+				ocfs2_dx_dir_leaf_insert_tail(new_dx_leaf,
+							      dx_entry);
+			else
+				ocfs2_dx_dir_leaf_insert_tail(tmp_dx_leaf,
+							      dx_entry);
+		}
+		memcpy(orig_dx_leaf, tmp_dx_leaf, dir->i_sb->s_blocksize);
+
+		ocfs2_journal_dirty(handle, orig_dx_leaves[i]);
+		ocfs2_journal_dirty(handle, new_dx_leaves[i]);
+	}
+}
+
+static int ocfs2_dx_dir_rebalance_credits(struct ocfs2_super *osb,
+					  struct ocfs2_dx_root_block *dx_root)
+{
+	int credits = ocfs2_clusters_to_blocks(osb->sb, 2);
+
+	credits += ocfs2_calc_extend_credits(osb->sb, &dx_root->dr_list, 1);
+	credits += ocfs2_quota_trans_credits(osb->sb);
+	return credits;
+}
+
+/*
+ * Find the median value in dx_leaf_bh and allocate a new leaf to move
+ * half our entries into.
+ */
+static int ocfs2_dx_dir_rebalance(struct ocfs2_super *osb, struct inode *dir,
+				  struct buffer_head *dx_root_bh,
+				  struct buffer_head *dx_leaf_bh,
+				  struct ocfs2_dx_hinfo *hinfo, u32 leaf_cpos,
+				  u64 leaf_blkno)
+{
+	struct ocfs2_dx_leaf *dx_leaf = (struct ocfs2_dx_leaf *)dx_leaf_bh->b_data;
+	int credits, ret, i, num_used, did_quota = 0;
+	u32 cpos, split_hash, insert_hash = hinfo->major_hash;
+	u64 orig_leaves_start;
+	int num_dx_leaves;
+	struct buffer_head **orig_dx_leaves = NULL;
+	struct buffer_head **new_dx_leaves = NULL;
+	struct ocfs2_alloc_context *data_ac = NULL, *meta_ac = NULL;
+	struct ocfs2_extent_tree et;
+	handle_t *handle = NULL;
+	struct ocfs2_dx_root_block *dx_root;
+	struct ocfs2_dx_leaf *tmp_dx_leaf = NULL;
+
+	mlog(0, "DX Dir: %llu, rebalance leaf leaf_blkno: %llu insert: %u\n",
+	     (unsigned long long)OCFS2_I(dir)->ip_blkno,
+	     (unsigned long long)leaf_blkno, insert_hash);
+
+	ocfs2_init_dx_root_extent_tree(&et, dir, dx_root_bh);
+
+	dx_root = (struct ocfs2_dx_root_block *)dx_root_bh->b_data;
+	/*
+	 * XXX: This is a rather large limit. We should use a more
+	 * realistic value.
+	 */
+	if (le32_to_cpu(dx_root->dr_clusters) == UINT_MAX)
+		return -ENOSPC;
+
+	num_used = le16_to_cpu(dx_leaf->dl_list.de_num_used);
+	if (num_used < le16_to_cpu(dx_leaf->dl_list.de_count)) {
+		mlog(ML_ERROR, "DX Dir: %llu, Asked to rebalance empty leaf: "
+		     "%llu, %d\n", (unsigned long long)OCFS2_I(dir)->ip_blkno,
+		     (unsigned long long)leaf_blkno, num_used);
+		ret = -EIO;
+		goto out;
+	}
+
+	orig_dx_leaves = ocfs2_dx_dir_kmalloc_leaves(osb->sb, &num_dx_leaves);
+	if (!orig_dx_leaves) {
+		ret = -ENOMEM;
+		mlog_errno(ret);
+		goto out;
+	}
+
+	new_dx_leaves = ocfs2_dx_dir_kmalloc_leaves(osb->sb, NULL);
+	if (!new_dx_leaves) {
+		ret = -ENOMEM;
+		mlog_errno(ret);
+		goto out;
+	}
+
+	ret = ocfs2_lock_allocators(dir, &et, 1, 0, &data_ac, &meta_ac);
+	if (ret) {
+		if (ret != -ENOSPC)
+			mlog_errno(ret);
+		goto out;
+	}
+
+	credits = ocfs2_dx_dir_rebalance_credits(osb, dx_root);
+	handle = ocfs2_start_trans(osb, credits);
+	if (IS_ERR(handle)) {
+		ret = PTR_ERR(handle);
+		handle = NULL;
+		mlog_errno(ret);
+		goto out;
+	}
+
+	if (vfs_dq_alloc_space_nodirty(dir,
+				       ocfs2_clusters_to_bytes(dir->i_sb, 1))) {
+		ret = -EDQUOT;
+		goto out_commit;
+	}
+	did_quota = 1;
+
+	ret = ocfs2_journal_access_dl(handle, dir, dx_leaf_bh,
+				      OCFS2_JOURNAL_ACCESS_WRITE);
+	if (ret) {
+		mlog_errno(ret);
+		goto out_commit;
+	}
+
+	/*
+	 * This block is changing anyway, so we can sort it in place.
+	 */
+	sort(dx_leaf->dl_list.de_entries, num_used,
+	     sizeof(struct ocfs2_dx_entry), dx_leaf_sort_cmp,
+	     dx_leaf_sort_swap);
+
+	ret = ocfs2_journal_dirty(handle, dx_leaf_bh);
+	if (ret) {
+		mlog_errno(ret);
+		goto out_commit;
+	}
+
+	ret = ocfs2_dx_dir_find_leaf_split(dx_leaf, leaf_cpos, insert_hash,
+					   &split_hash);
+	if (ret) {
+		mlog_errno(ret);
+		goto  out_commit;
+	}
+
+	mlog(0, "Split leaf (%u) at %u, insert major hash is %u\n",
+	     leaf_cpos, split_hash, insert_hash);
+
+	/*
+	 * We have to carefully order operations here. There are items
+	 * which want to be in the new cluster before insert, but in
+	 * order to put those items in the new cluster, we alter the
+	 * old cluster. A failure to insert gets nasty.
+	 *
+	 * So, start by reserving writes to the old
+	 * cluster. ocfs2_dx_dir_new_cluster will reserve writes on
+	 * the new cluster for us, before inserting it. The insert
+	 * won't happen if there's an error before that. Once the
+	 * insert is done then, we can transfer from one leaf into the
+	 * other without fear of hitting any error.
+	 */
+
+	/*
+	 * The leaf transfer wants some scratch space so that we don't
+	 * wind up doing a bunch of expensive memmove().
+	 */
+	tmp_dx_leaf = kmalloc(osb->sb->s_blocksize, GFP_NOFS);
+	if (!tmp_dx_leaf) {
+		ret = -ENOMEM;
+		mlog_errno(ret);
+		goto out_commit;
+	}
+
+	orig_leaves_start = leaf_blkno & ~(osb->s_clustersize_bits -
+				      osb->sb->s_blocksize_bits);
+	ret = ocfs2_read_dx_leaves(dir, orig_leaves_start, num_dx_leaves,
+				   orig_dx_leaves);
+	if (ret) {
+		mlog_errno(ret);
+		goto out_commit;
+	}
+
+	for (i = 0; i < num_dx_leaves; i++) {
+		ret = ocfs2_journal_access_dl(handle, dir, orig_dx_leaves[i],
+					      OCFS2_JOURNAL_ACCESS_WRITE);
+		if (ret) {
+			mlog_errno(ret);
+			goto out_commit;
+		}
+	}
+
+	cpos = split_hash;
+	ret = ocfs2_dx_dir_new_cluster(dir, &et, cpos, handle,
+				       data_ac, meta_ac, new_dx_leaves,
+				       num_dx_leaves);
+	if (ret) {
+		mlog_errno(ret);
+		goto out_commit;
+	}
+
+	ocfs2_dx_dir_transfer_leaf(dir, split_hash, handle, tmp_dx_leaf,
+				   orig_dx_leaves, new_dx_leaves, num_dx_leaves);
+
+out_commit:
+	if (ret < 0 && did_quota)
+		vfs_dq_free_space_nodirty(dir,
+				ocfs2_clusters_to_bytes(dir->i_sb, 1));
+
+	ocfs2_commit_trans(osb, handle);
+
+out:
+	if (orig_dx_leaves || new_dx_leaves) {
+		for (i = 0; i < num_dx_leaves; i++) {
+			if (orig_dx_leaves)
+				brelse(orig_dx_leaves[i]);
+			if (new_dx_leaves)
+				brelse(new_dx_leaves[i]);
+		}
+		kfree(orig_dx_leaves);
+		kfree(new_dx_leaves);
+	}
+
+	if (meta_ac)
+		ocfs2_free_alloc_context(meta_ac);
+	if (data_ac)
+		ocfs2_free_alloc_context(data_ac);
+
+	kfree(tmp_dx_leaf);
+	return ret;
+}
+
+static int ocfs2_find_dir_space_dx(struct ocfs2_super *osb, struct inode *dir,
+				   struct buffer_head *di_bh, const char *name,
+				   int namelen,
+				   struct ocfs2_dir_lookup_result *lookup)
+{
+	int ret, rebalanced = 0;
+	struct buffer_head *dx_root_bh = NULL;
+	struct ocfs2_dx_root_block *dx_root;
+	struct buffer_head *dx_leaf_bh = NULL;
+	struct ocfs2_dx_leaf *dx_leaf;
+	struct ocfs2_dinode *di = (struct ocfs2_dinode *)di_bh->b_data;
+	u64 blkno;
+	u32 leaf_cpos;
+
+	ret = ocfs2_read_dx_root(dir, di, &dx_root_bh);
+	if (ret) {
+		mlog_errno(ret);
+		goto out;
+	}
+
+	dx_root = (struct ocfs2_dx_root_block *)dx_root_bh->b_data;
+
+restart_search:
+	ret = ocfs2_dx_dir_lookup(dir, &dx_root->dr_list, &lookup->dl_hinfo,
+				  &leaf_cpos, &blkno);
+	if (ret) {
+		mlog_errno(ret);
+		goto out;
+	}
+
+	ret = ocfs2_read_dx_leaf(dir, blkno, &dx_leaf_bh);
+	if (ret) {
+		mlog_errno(ret);
+		goto out;
+	}
+
+	dx_leaf = (struct ocfs2_dx_leaf *)dx_leaf_bh->b_data;
+
+	if (le16_to_cpu(dx_leaf->dl_list.de_num_used) >=
+	    le16_to_cpu(dx_leaf->dl_list.de_count)) {
+		if (rebalanced) {
+			/*
+			 * Rebalancing should have provided us with
+			 * space in an appropriate leaf.
+			 *
+			 * XXX: Is this an abnormal condition then?
+			 * Should we print a message here?
+			 */
+			ret = -ENOSPC;
+			goto out;
+		}
+
+		ret = ocfs2_dx_dir_rebalance(osb, dir, dx_root_bh, dx_leaf_bh,
+					     &lookup->dl_hinfo, leaf_cpos,
+					     blkno);
+		if (ret) {
+			if (ret != -ENOSPC)
+				mlog_errno(ret);
+			goto out;
+		}
+
+		/*
+		 * Restart the lookup. The rebalance might have
+		 * changed which block our item fits into. Mark our
+		 * progress, so we only execute this once.
+		 */
+		brelse(dx_leaf_bh);
+		dx_leaf_bh = NULL;
+		rebalanced = 1;
+		goto restart_search;
+	}
+
+	lookup->dl_dx_leaf_bh = dx_leaf_bh;
+	dx_leaf_bh = NULL;
+
+out:
+	brelse(dx_leaf_bh);
+	brelse(dx_root_bh);
+	return ret;
+}
+
 /*
  * Get a directory ready for insert. Any directory allocation required
  * happens here. Success returns zero, and enough context in the dir
@@ -2001,6 +3611,34 @@ int ocfs2_prepare_dir_for_insert(struct ocfs2_super *osb,
 		goto out;
 	}
 
+	/*
+	 * Do this up front to reduce confusion.
+	 *
+	 * The directory might start inline, then be turned into an
+	 * indexed one, in which case we'd need to hash deep inside
+	 * ocfs2_find_dir_space_id(). Since
+	 * ocfs2_prepare_dx_dir_for_insert() also needs this hash
+	 * done, there seems no point in spreading out the calls. We
+	 * can optimize away the case where the file system doesn't
+	 * support indexing.
+	 */
+	if (ocfs2_supports_indexed_dirs(osb))
+		ocfs2_dx_dir_name_hash(dir, name, namelen, &lookup->dl_hinfo);
+
+	if (ocfs2_dir_indexed(dir)) {
+		ret = ocfs2_find_dir_space_dx(osb, dir, parent_fe_bh, name,
+					      namelen, lookup);
+		if (ret) {
+			mlog_errno(ret);
+			goto out;
+		}
+
+		/*
+		 * We intentionally fall through so that the unindexed
+		 * tree can also be prepared.
+		 */
+	}
+
 	if (OCFS2_I(dir)->ip_dyn_features & OCFS2_INLINE_DATA_FL) {
 		ret = ocfs2_find_dir_space_id(dir, parent_fe_bh, name,
 					      namelen, &bh, &blocks_wanted);
@@ -2019,7 +3657,7 @@ int ocfs2_prepare_dir_for_insert(struct ocfs2_super *osb,
 		BUG_ON(bh);
 
 		ret = ocfs2_extend_dir(osb, dir, parent_fe_bh, blocks_wanted,
-				       &bh);
+				       lookup, &bh);
 		if (ret) {
 			if (ret != -ENOSPC)
 				mlog_errno(ret);
@@ -2035,3 +3673,145 @@ out:
 	brelse(bh);
 	return ret;
 }
+
+static int ocfs2_dx_dir_remove_index(struct inode *dir,
+				     struct buffer_head *di_bh,
+				     struct buffer_head *dx_root_bh)
+{
+	int ret;
+	struct ocfs2_super *osb = OCFS2_SB(dir->i_sb);
+	struct ocfs2_dinode *di = (struct ocfs2_dinode *)di_bh->b_data;
+	struct ocfs2_dx_root_block *dx_root;
+	struct inode *dx_alloc_inode = NULL;
+	struct buffer_head *dx_alloc_bh = NULL;
+	handle_t *handle;
+	u64 blk;
+	u16 bit;
+	u64 bg_blkno;
+
+	dx_root = (struct ocfs2_dx_root_block *) dx_root_bh->b_data;
+
+	dx_alloc_inode = ocfs2_get_system_file_inode(osb,
+					EXTENT_ALLOC_SYSTEM_INODE,
+					le16_to_cpu(dx_root->dr_suballoc_slot));
+	if (!dx_alloc_inode) {
+		ret = -ENOMEM;
+		mlog_errno(ret);
+		goto out;
+	}
+	mutex_lock(&dx_alloc_inode->i_mutex);
+
+	ret = ocfs2_inode_lock(dx_alloc_inode, &dx_alloc_bh, 1);
+	if (ret) {
+		mlog_errno(ret);
+		goto out_mutex;
+	}
+
+	handle = ocfs2_start_trans(osb, OCFS2_DX_ROOT_REMOVE_CREDITS);
+	if (IS_ERR(handle)) {
+		ret = PTR_ERR(handle);
+		mlog_errno(ret);
+		goto out_unlock;
+	}
+
+	ret = ocfs2_journal_access_di(handle, dir, di_bh,
+				      OCFS2_JOURNAL_ACCESS_WRITE);
+	if (ret) {
+		mlog_errno(ret);
+		goto out_commit;
+	}
+
+	OCFS2_I(dir)->ip_dyn_features &= ~OCFS2_INDEXED_DIR_FL;
+	di->i_dyn_features = cpu_to_le16(OCFS2_I(dir)->ip_dyn_features);
+	di->i_dx_root = cpu_to_le64(0ULL);
+
+	ocfs2_journal_dirty(handle, di_bh);
+
+	blk = le64_to_cpu(dx_root->dr_blkno);
+	bit = le16_to_cpu(dx_root->dr_suballoc_bit);
+	bg_blkno = ocfs2_which_suballoc_group(blk, bit);
+	ret = ocfs2_free_suballoc_bits(handle, dx_alloc_inode, dx_alloc_bh,
+				       bit, bg_blkno, 1);
+	if (ret)
+		mlog_errno(ret);
+
+out_commit:
+	ocfs2_commit_trans(osb, handle);
+
+out_unlock:
+	ocfs2_inode_unlock(dx_alloc_inode, 1);
+
+out_mutex:
+	mutex_unlock(&dx_alloc_inode->i_mutex);
+	brelse(dx_alloc_bh);
+out:
+	iput(dx_alloc_inode);
+	return ret;
+}
+
+int ocfs2_dx_dir_truncate(struct inode *dir, struct buffer_head *di_bh)
+{
+	int ret;
+	unsigned int uninitialized_var(clen);
+	u32 major_hash = UINT_MAX, p_cpos, uninitialized_var(cpos);
+	u64 uninitialized_var(blkno);
+	struct ocfs2_super *osb = OCFS2_SB(dir->i_sb);
+	struct buffer_head *dx_root_bh = NULL;
+	struct ocfs2_dx_root_block *dx_root;
+	struct ocfs2_dinode *di = (struct ocfs2_dinode *)di_bh->b_data;
+	struct ocfs2_cached_dealloc_ctxt dealloc;
+	struct ocfs2_extent_tree et;
+
+	ocfs2_init_dealloc_ctxt(&dealloc);
+
+	if (!ocfs2_dir_indexed(dir))
+		return 0;
+
+	ret = ocfs2_read_dx_root(dir, di, &dx_root_bh);
+	if (ret) {
+		mlog_errno(ret);
+		goto out;
+	}
+
+	ocfs2_init_dx_root_extent_tree(&et, dir, dx_root_bh);
+
+	dx_root = (struct ocfs2_dx_root_block *)dx_root_bh->b_data;
+
+	/* XXX: What if dr_clusters is too large? */
+	while (le32_to_cpu(dx_root->dr_clusters)) {
+		ret = ocfs2_dx_dir_lookup_rec(dir, &dx_root->dr_list,
+					      major_hash, &cpos, &blkno, &clen);
+		if (ret) {
+			mlog_errno(ret);
+			goto out;
+		}
+
+		p_cpos = ocfs2_blocks_to_clusters(dir->i_sb, blkno);
+
+		ret = ocfs2_remove_btree_range(dir, &et, cpos, p_cpos, clen,
+					       &dealloc);
+		if (ret) {
+			mlog_errno(ret);
+			goto out;
+		}
+
+		if (cpos == 0)
+			break;
+
+		major_hash = cpos - 1;
+	}
+
+	ret = ocfs2_dx_dir_remove_index(dir, di_bh, dx_root_bh);
+	if (ret) {
+		mlog_errno(ret);
+		goto out;
+	}
+
+	ocfs2_remove_from_cache(dir, dx_root_bh);
+out:
+	ocfs2_schedule_truncate_log_flush(osb, 1);
+	ocfs2_run_deallocs(osb, &dealloc);
+
+	brelse(dx_root_bh);
+	return ret;
+}
diff --git a/fs/ocfs2/dir.h b/fs/ocfs2/dir.h
index 505d3af..d273aae 100644
--- a/fs/ocfs2/dir.h
+++ b/fs/ocfs2/dir.h
@@ -26,9 +26,21 @@
 #ifndef OCFS2_DIR_H
 #define OCFS2_DIR_H
 
+struct ocfs2_dx_hinfo {
+	u32	major_hash;
+	u32	minor_hash;
+};
+
 struct ocfs2_dir_lookup_result {
-	struct buffer_head		*dl_leaf_bh;
-	struct ocfs2_dir_entry		*dl_entry;
+	struct buffer_head		*dl_leaf_bh;	/* Unindexed leaf
+							 * block */
+	struct ocfs2_dir_entry		*dl_entry;	/* Target dirent in
+							 * unindexed leaf */
+
+	struct buffer_head		*dl_dx_leaf_bh;	/* Indexed leaf block */
+	struct ocfs2_dx_entry		*dl_dx_entry;	/* Target dx_entry in
+							 * indexed leaf */
+	struct ocfs2_dx_hinfo		dl_hinfo;	/* Name hash results */
 };
 void ocfs2_free_dir_lookup_result(struct ocfs2_dir_lookup_result *res);
 
@@ -85,7 +97,10 @@ int ocfs2_fill_new_dir(struct ocfs2_super *osb,
 		       struct inode *parent,
 		       struct inode *inode,
 		       struct buffer_head *fe_bh,
-		       struct ocfs2_alloc_context *data_ac);
+		       struct ocfs2_alloc_context *data_ac,
+		       struct ocfs2_alloc_context *meta_ac);
+
+int ocfs2_dx_dir_truncate(struct inode *dir, struct buffer_head *di_bh);
 
 struct ocfs2_dir_block_trailer *ocfs2_dir_trailer_from_size(int blocksize,
 							    void *data);
diff --git a/fs/ocfs2/inode.c b/fs/ocfs2/inode.c
index 229e707..d273c4a 100644
--- a/fs/ocfs2/inode.c
+++ b/fs/ocfs2/inode.c
@@ -38,6 +38,7 @@
 #include "ocfs2.h"
 
 #include "alloc.h"
+#include "dir.h"
 #include "blockcheck.h"
 #include "dlmglue.h"
 #include "extent_map.h"
@@ -606,7 +607,7 @@ static int ocfs2_remove_inode(struct inode *inode,
 	}
 
 	handle = ocfs2_start_trans(osb, OCFS2_DELETE_INODE_CREDITS +
-					ocfs2_quota_trans_credits(inode->i_sb));
+				   ocfs2_quota_trans_credits(inode->i_sb));
 	if (IS_ERR(handle)) {
 		status = PTR_ERR(handle);
 		mlog_errno(status);
@@ -740,6 +741,15 @@ static int ocfs2_wipe_inode(struct inode *inode,
 		goto bail_unlock_dir;
 	}
 
+	/* Remove any dir index tree */
+	if (S_ISDIR(inode->i_mode)) {
+		status = ocfs2_dx_dir_truncate(inode, di_bh);
+		if (status) {
+			mlog_errno(status);
+			goto bail_unlock_dir;
+		}
+	}
+
 	/*Free extended attribute resources associated with this inode.*/
 	status = ocfs2_xattr_remove(inode, di_bh);
 	if (status < 0) {
diff --git a/fs/ocfs2/journal.c b/fs/ocfs2/journal.c
index 57d7d25..33e836e 100644
--- a/fs/ocfs2/journal.c
+++ b/fs/ocfs2/journal.c
@@ -496,6 +496,22 @@ static struct ocfs2_triggers dq_triggers = {
 	},
 };
 
+static struct ocfs2_triggers dr_triggers = {
+	.ot_triggers = {
+		.t_commit = ocfs2_commit_trigger,
+		.t_abort = ocfs2_abort_trigger,
+	},
+	.ot_offset	= offsetof(struct ocfs2_dx_root_block, dr_check),
+};
+
+static struct ocfs2_triggers dl_triggers = {
+	.ot_triggers = {
+		.t_commit = ocfs2_commit_trigger,
+		.t_abort = ocfs2_abort_trigger,
+	},
+	.ot_offset	= offsetof(struct ocfs2_dx_leaf, dl_check),
+};
+
 static int __ocfs2_journal_access(handle_t *handle,
 				  struct inode *inode,
 				  struct buffer_head *bh,
@@ -600,6 +616,20 @@ int ocfs2_journal_access_dq(handle_t *handle, struct inode *inode,
 				      type);
 }
 
+int ocfs2_journal_access_dr(handle_t *handle, struct inode *inode,
+			    struct buffer_head *bh, int type)
+{
+	return __ocfs2_journal_access(handle, inode, bh, &dr_triggers,
+				      type);
+}
+
+int ocfs2_journal_access_dl(handle_t *handle, struct inode *inode,
+			    struct buffer_head *bh, int type)
+{
+	return __ocfs2_journal_access(handle, inode, bh, &dl_triggers,
+				      type);
+}
+
 int ocfs2_journal_access(handle_t *handle, struct inode *inode,
 			 struct buffer_head *bh, int type)
 {
diff --git a/fs/ocfs2/journal.h b/fs/ocfs2/journal.h
index 3c3532e..1d7c5ec 100644
--- a/fs/ocfs2/journal.h
+++ b/fs/ocfs2/journal.h
@@ -266,6 +266,12 @@ int ocfs2_journal_access_dq(handle_t *handle, struct inode *inode,
 /* dirblock */
 int ocfs2_journal_access_db(handle_t *handle, struct inode *inode,
 			    struct buffer_head *bh, int type);
+/* ocfs2_dx_root_block */
+int ocfs2_journal_access_dr(handle_t *handle, struct inode *inode,
+			    struct buffer_head *bh, int type);
+/* ocfs2_dx_leaf */
+int ocfs2_journal_access_dl(handle_t *handle, struct inode *inode,
+			    struct buffer_head *bh, int type);
 /* Anything that has no ecc */
 int ocfs2_journal_access(handle_t *handle, struct inode *inode,
 			 struct buffer_head *bh, int type);
@@ -371,11 +377,26 @@ static inline int ocfs2_remove_extent_credits(struct super_block *sb)
  * bitmap block for the new bit) */
 #define OCFS2_DIR_LINK_ADDITIONAL_CREDITS (1 + 2)
 
-/* parent fe, parent block, new file entry, inode alloc fe, inode alloc
- * group descriptor + mkdir/symlink blocks + quota update */
-static inline int ocfs2_mknod_credits(struct super_block *sb)
+static inline int ocfs2_add_dir_index_credits(struct super_block *sb)
+{
+	/* 1 block for index, 2 allocs (data, metadata), 1 clusters
+	 * worth of blocks for initial extent. */
+	return 1 + 2 * OCFS2_SUBALLOC_ALLOC +
+		ocfs2_clusters_to_blocks(sb, 1);
+}
+
+/* parent fe, parent block, new file entry, index leaf, inode alloc fe, inode
+ * alloc group descriptor + mkdir/symlink blocks + dir blocks + xattr
+ * blocks + quota update */
+static inline int ocfs2_mknod_credits(struct super_block *sb, int is_dir,
+				      int xattr_credits)
 {
-	return 3 + OCFS2_SUBALLOC_ALLOC + OCFS2_DIR_LINK_ADDITIONAL_CREDITS +
+	int dir_credits = OCFS2_DIR_LINK_ADDITIONAL_CREDITS;
+
+	if (is_dir)
+		dir_credits += ocfs2_add_dir_index_credits(sb);
+
+	return 4 + OCFS2_SUBALLOC_ALLOC + dir_credits + xattr_credits +
 	       ocfs2_quota_trans_credits(sb);
 }
 
@@ -388,31 +409,31 @@ static inline int ocfs2_mknod_credits(struct super_block *sb)
 #define OCFS2_SIMPLE_DIR_EXTEND_CREDITS (2)
 
 /* file update (nlink, etc) + directory mtime/ctime + dir entry block + quota
- * update on dir */
+ * update on dir + index leaf */
 static inline int ocfs2_link_credits(struct super_block *sb)
 {
-	return 2*OCFS2_INODE_UPDATE_CREDITS + 1 +
+	return 2*OCFS2_INODE_UPDATE_CREDITS + 2 +
 	       ocfs2_quota_trans_credits(sb);
 }
 
 /* inode + dir inode (if we unlink a dir), + dir entry block + orphan
- * dir inode link */
+ * dir inode link + dir inode index leaf */
 static inline int ocfs2_unlink_credits(struct super_block *sb)
 {
 	/* The quota update from ocfs2_link_credits is unused here... */
-	return 2 * OCFS2_INODE_UPDATE_CREDITS + 1 + ocfs2_link_credits(sb);
+	return 2 * OCFS2_INODE_UPDATE_CREDITS + 2 + ocfs2_link_credits(sb);
 }
 
 /* dinode + orphan dir dinode + inode alloc dinode + orphan dir entry +
- * inode alloc group descriptor */
-#define OCFS2_DELETE_INODE_CREDITS (3 * OCFS2_INODE_UPDATE_CREDITS + 1 + 1)
+ * inode alloc group descriptor + orphan dir index leaf */
+#define OCFS2_DELETE_INODE_CREDITS (3 * OCFS2_INODE_UPDATE_CREDITS + 3)
 
 /* dinode update, old dir dinode update, new dir dinode update, old
  * dir dir entry, new dir dir entry, dir entry update for renaming
- * directory + target unlink */
+ * directory + target unlink + 3 x dir index leaves */
 static inline int ocfs2_rename_credits(struct super_block *sb)
 {
-	return 3 * OCFS2_INODE_UPDATE_CREDITS + 3 + ocfs2_unlink_credits(sb);
+	return 3 * OCFS2_INODE_UPDATE_CREDITS + 6 + ocfs2_unlink_credits(sb);
 }
 
 /* global bitmap dinode, group desc., relinked group,
@@ -422,6 +443,10 @@ static inline int ocfs2_rename_credits(struct super_block *sb)
 					  + OCFS2_INODE_UPDATE_CREDITS \
 					  + OCFS2_XATTR_BLOCK_UPDATE_CREDITS)
 
+/* inode update, removal of dx root block from allocator */
+#define OCFS2_DX_ROOT_REMOVE_CREDITS (OCFS2_INODE_UPDATE_CREDITS +	\
+				      OCFS2_SUBALLOC_FREE)
+
 /*
  * Please note that the caller must make sure that root_el is the root
  * of extent tree. So for an inode, it should be &fe->id2.i_list. Otherwise
@@ -457,7 +482,7 @@ static inline int ocfs2_calc_extend_credits(struct super_block *sb,
 
 static inline int ocfs2_calc_symlink_credits(struct super_block *sb)
 {
-	int blocks = ocfs2_mknod_credits(sb);
+	int blocks = ocfs2_mknod_credits(sb, 0, 0);
 
 	/* links can be longer than one block so we may update many
 	 * within our single allocated extent. */
diff --git a/fs/ocfs2/namei.c b/fs/ocfs2/namei.c
index ffebb88..bd31222 100644
--- a/fs/ocfs2/namei.c
+++ b/fs/ocfs2/namei.c
@@ -231,8 +231,9 @@ static int ocfs2_mknod(struct inode *dir,
 	struct inode *inode = NULL;
 	struct ocfs2_alloc_context *inode_ac = NULL;
 	struct ocfs2_alloc_context *data_ac = NULL;
-	struct ocfs2_alloc_context *xattr_ac = NULL;
+	struct ocfs2_alloc_context *meta_ac = NULL;
 	int want_clusters = 0;
+	int want_meta = 0;
 	int xattr_credits = 0;
 	struct ocfs2_security_xattr_info si = {
 		.enable = 1,
@@ -308,17 +309,31 @@ static int ocfs2_mknod(struct inode *dir,
 
 	/* calculate meta data/clusters for setting security and acl xattr */
 	status = ocfs2_calc_xattr_init(dir, parent_fe_bh, mode,
-					&si, &want_clusters,
-					&xattr_credits, &xattr_ac);
+				       &si, &want_clusters,
+				       &xattr_credits, &want_meta);
 	if (status < 0) {
 		mlog_errno(status);
 		goto leave;
 	}
 
 	/* Reserve a cluster if creating an extent based directory. */
-	if (S_ISDIR(mode) && !ocfs2_supports_inline_data(osb))
+	if (S_ISDIR(mode) && !ocfs2_supports_inline_data(osb)) {
 		want_clusters += 1;
 
+		/* Dir indexing requires extra space as well */
+		if (ocfs2_supports_indexed_dirs(osb)) {
+			want_clusters++;
+			want_meta++;
+		}
+	}
+
+	status = ocfs2_reserve_new_metadata_blocks(osb, want_meta, &meta_ac);
+	if (status < 0) {
+		if (status != -ENOSPC)
+			mlog_errno(status);
+		goto leave;
+	}
+
 	status = ocfs2_reserve_clusters(osb, want_clusters, &data_ac);
 	if (status < 0) {
 		if (status != -ENOSPC)
@@ -326,8 +341,9 @@ static int ocfs2_mknod(struct inode *dir,
 		goto leave;
 	}
 
-	handle = ocfs2_start_trans(osb, ocfs2_mknod_credits(osb->sb) +
-				   xattr_credits);
+	handle = ocfs2_start_trans(osb, ocfs2_mknod_credits(osb->sb,
+							    S_ISDIR(mode),
+							    xattr_credits));
 	if (IS_ERR(handle)) {
 		status = PTR_ERR(handle);
 		handle = NULL;
@@ -355,7 +371,7 @@ static int ocfs2_mknod(struct inode *dir,
 
 	if (S_ISDIR(mode)) {
 		status = ocfs2_fill_new_dir(osb, handle, dir, inode,
-					    new_fe_bh, data_ac);
+					    new_fe_bh, data_ac, meta_ac);
 		if (status < 0) {
 			mlog_errno(status);
 			goto leave;
@@ -377,7 +393,7 @@ static int ocfs2_mknod(struct inode *dir,
 	}
 
 	status = ocfs2_init_acl(handle, inode, dir, new_fe_bh, parent_fe_bh,
-				xattr_ac, data_ac);
+				meta_ac, data_ac);
 	if (status < 0) {
 		mlog_errno(status);
 		goto leave;
@@ -385,7 +401,7 @@ static int ocfs2_mknod(struct inode *dir,
 
 	if (si.enable) {
 		status = ocfs2_init_security_set(handle, inode, new_fe_bh, &si,
-						 xattr_ac, data_ac);
+						 meta_ac, data_ac);
 		if (status < 0) {
 			mlog_errno(status);
 			goto leave;
@@ -440,8 +456,8 @@ leave:
 	if (data_ac)
 		ocfs2_free_alloc_context(data_ac);
 
-	if (xattr_ac)
-		ocfs2_free_alloc_context(xattr_ac);
+	if (meta_ac)
+		ocfs2_free_alloc_context(meta_ac);
 
 	mlog_exit(status);
 
@@ -463,6 +479,7 @@ static int ocfs2_mknod_locked(struct ocfs2_super *osb,
 	struct ocfs2_extent_list *fel;
 	u64 fe_blkno = 0;
 	u16 suballoc_bit;
+	u16 feat;
 
 	mlog_entry("(0x%p, 0x%p, %d, %lu, '%.*s')\n", dir, dentry,
 		   inode->i_mode, (unsigned long)dev, dentry->d_name.len,
@@ -526,11 +543,11 @@ static int ocfs2_mknod_locked(struct ocfs2_super *osb,
 	fe->i_dtime = 0;
 
 	/*
-	 * If supported, directories start with inline data.
+	 * If supported, directories start with inline data. If inline
+	 * isn't supported, but indexing is, we start them as indexed.
 	 */
+	feat = le16_to_cpu(fe->i_dyn_features);
 	if (S_ISDIR(inode->i_mode) && ocfs2_supports_inline_data(osb)) {
-		u16 feat = le16_to_cpu(fe->i_dyn_features);
-
 		fe->i_dyn_features = cpu_to_le16(feat | OCFS2_INLINE_DATA_FL);
 
 		fe->id2.i_data.id_count = cpu_to_le16(ocfs2_max_inline_data(osb->sb));
diff --git a/fs/ocfs2/ocfs2.h b/fs/ocfs2/ocfs2.h
index ad5c24a..0b05fc8 100644
--- a/fs/ocfs2/ocfs2.h
+++ b/fs/ocfs2/ocfs2.h
@@ -335,6 +335,9 @@ struct ocfs2_super
 	struct ocfs2_node_map		osb_recovering_orphan_dirs;
 	unsigned int			*osb_orphan_wipes;
 	wait_queue_head_t		osb_wipe_event;
+
+	unsigned int			osb_dx_mask;
+	u32				osb_dx_seed[4];
 };
 
 #define OCFS2_SB(sb)	    ((struct ocfs2_super *)(sb)->s_fs_info)
@@ -393,6 +396,13 @@ static inline int ocfs2_meta_ecc(struct ocfs2_super *osb)
 	return 0;
 }
 
+static inline int ocfs2_supports_indexed_dirs(struct ocfs2_super *osb)
+{
+	if (osb->s_feature_incompat & OCFS2_FEATURE_INCOMPAT_INDEXED_DIRS)
+		return 1;
+	return 0;
+}
+
 /* set / clear functions because cluster events can make these happen
  * in parallel so we want the transitions to be atomic. this also
  * means that any future flags osb_flags must be protected by spinlock
@@ -473,6 +483,12 @@ static inline int ocfs2_uses_extended_slot_map(struct ocfs2_super *osb)
 #define OCFS2_IS_VALID_DIR_TRAILER(ptr)					\
 	(!strcmp((ptr)->db_signature, OCFS2_DIR_TRAILER_SIGNATURE))
 
+#define OCFS2_IS_VALID_DX_ROOT(ptr)					\
+	(!strcmp((ptr)->dr_signature, OCFS2_DX_ROOT_SIGNATURE))
+
+#define OCFS2_IS_VALID_DX_LEAF(ptr)					\
+	(!strcmp((ptr)->dl_signature, OCFS2_DX_LEAF_SIGNATURE))
+
 static inline unsigned long ino_from_blkno(struct super_block *sb,
 					   u64 blkno)
 {
diff --git a/fs/ocfs2/ocfs2_fs.h b/fs/ocfs2/ocfs2_fs.h
index c7ae45a..77b532c 100644
--- a/fs/ocfs2/ocfs2_fs.h
+++ b/fs/ocfs2/ocfs2_fs.h
@@ -66,6 +66,8 @@
 #define OCFS2_GROUP_DESC_SIGNATURE      "GROUP01"
 #define OCFS2_XATTR_BLOCK_SIGNATURE	"XATTR01"
 #define OCFS2_DIR_TRAILER_SIGNATURE	"DIRTRL1"
+#define OCFS2_DX_ROOT_SIGNATURE		"DXDIR01"
+#define OCFS2_DX_LEAF_SIGNATURE		"DXLEAF1"
 
 /* Compatibility flags */
 #define OCFS2_HAS_COMPAT_FEATURE(sb,mask)			\
@@ -151,6 +153,9 @@
 /* Support for extended attributes */
 #define OCFS2_FEATURE_INCOMPAT_XATTR		0x0200
 
+/* Support for indexed directores */
+#define OCFS2_FEATURE_INCOMPAT_INDEXED_DIRS	0x0400
+
 /* Metadata checksum and error correction */
 #define OCFS2_FEATURE_INCOMPAT_META_ECC		0x0800
 
@@ -628,8 +633,9 @@ struct ocfs2_super_block {
 /*B8*/	__le16 s_xattr_inline_size;	/* extended attribute inline size
 					   for this fs*/
 	__le16 s_reserved0;
-	__le32 s_reserved1;
-/*C0*/  __le64 s_reserved2[16];		/* Fill out superblock */
+	__le32 s_dx_seed[3];		/* seed[0-2] for dx dir hash.
+					 * s_uuid_hash serves as seed[3]. */
+/*C0*/  __le64 s_reserved2[15];		/* Fill out superblock */
 /*140*/
 
 	/*
@@ -705,7 +711,8 @@ struct ocfs2_dinode {
 	__le16 i_dyn_features;
 	__le64 i_xattr_loc;
 /*80*/	struct ocfs2_block_check i_check;	/* Error checking */
-/*88*/	__le64 i_reserved2[6];
+/*88*/	__le64 i_dx_root;		/* Pointer to dir index root block */
+	__le64 i_reserved2[5];
 /*B8*/	union {
 		__le64 i_pad1;		/* Generic way to refer to this
 					   64bit union */
@@ -781,6 +788,75 @@ struct ocfs2_dir_block_trailer {
 /*40*/
 };
 
+ /*
+ * A directory entry in the indexed tree. We don't store the full name here,
+ * but instead provide a pointer to the full dirent in the unindexed tree.
+ *
+ * We also store name_len here so as to reduce the number of leaf blocks we
+ * need to search in case of collisions.
+ */
+struct ocfs2_dx_entry {
+	__le32		dx_major_hash;	/* Used to find logical
+					 * cluster in index */
+	__le32		dx_minor_hash;	/* Lower bits used to find
+					 * block in cluster */
+	__le64		dx_dirent_blk;	/* Physical block in unindexed
+					 * tree holding this dirent. */
+};
+
+struct ocfs2_dx_entry_list {
+	__le32		de_reserved;
+	__le16		de_count;	/* Maximum number of entries
+					 * possible in de_entries */
+	__le16		de_num_used;	/* Current number of
+					 * de_entries entries */
+	struct	ocfs2_dx_entry		de_entries[0];	/* Indexed dir entries
+							 * in a packed array of
+							 * length de_num_used */
+};
+
+/*
+ * A directory indexing block. Each indexed directory has one of these,
+ * pointed to by ocfs2_dinode.
+ *
+ * This block stores an indexed btree root, and a set of free space
+ * start-of-list pointers.
+ */
+struct ocfs2_dx_root_block {
+	__u8		dr_signature[8];	/* Signature for verification */
+	struct ocfs2_block_check dr_check;	/* Error checking */
+	__le16		dr_suballoc_slot;	/* Slot suballocator this
+						 * block belongs to. */
+	__le16		dr_suballoc_bit;	/* Bit offset in suballocator
+						 * block group */
+	__le32		dr_fs_generation;	/* Must match super block */
+	__le64		dr_blkno;		/* Offset on disk, in blocks */
+	__le64		dr_last_eb_blk;		/* Pointer to last
+						 * extent block */
+	__le32		dr_clusters;		/* Clusters allocated
+						 * to the indexed tree. */
+	__le32		dr_reserved1;
+	__le64		dr_dir_blkno;		/* Pointer to parent inode */
+	__le64		dr_reserved2;
+	__le64		dr_reserved3[16];
+	struct ocfs2_extent_list	dr_list; /* Keep this aligned to 128
+						  * bits for maximum space
+						  * efficiency. */
+};
+
+/*
+ * The header of a leaf block in the indexed tree.
+ */
+struct ocfs2_dx_leaf {
+	__u8		dl_signature[8];/* Signature for verification */
+	struct ocfs2_block_check dl_check;	/* Error checking */
+	__le64		dl_blkno;	/* Offset on disk, in blocks */
+	__le32		dl_fs_generation;/* Must match super block */
+	__le32		dl_reserved0;
+	__le64		dl_reserved1;
+	struct ocfs2_dx_entry_list	dl_list;
+};
+
 /*
  * On disk allocator group structure for OCFS2
  */
@@ -1118,6 +1194,16 @@ static inline int ocfs2_extent_recs_per_inode_with_xattr(
 	return size / sizeof(struct ocfs2_extent_rec);
 }
 
+static inline int ocfs2_extent_recs_per_dx_root(struct super_block *sb)
+{
+	int size;
+
+	size = sb->s_blocksize -
+		offsetof(struct ocfs2_dx_root_block, dr_list.l_recs);
+
+	return size / sizeof(struct ocfs2_extent_rec);
+}
+
 static inline int ocfs2_chain_recs_per_inode(struct super_block *sb)
 {
 	int size;
@@ -1138,6 +1224,16 @@ static inline u16 ocfs2_extent_recs_per_eb(struct super_block *sb)
 	return size / sizeof(struct ocfs2_extent_rec);
 }
 
+static inline int ocfs2_dx_entries_per_leaf(struct super_block *sb)
+{
+	int size;
+
+	size = sb->s_blocksize -
+		offsetof(struct ocfs2_dx_leaf, dl_list.de_entries);
+
+	return size / sizeof(struct ocfs2_dx_entry);
+}
+
 static inline u16 ocfs2_local_alloc_size(struct super_block *sb)
 {
 	u16 size;
diff --git a/fs/ocfs2/super.c b/fs/ocfs2/super.c
index 43ed113..c15ad0f 100644
--- a/fs/ocfs2/super.c
+++ b/fs/ocfs2/super.c
@@ -1735,6 +1735,12 @@ static int ocfs2_initialize_super(struct super_block *sb,
 	bbits = le32_to_cpu(di->id2.i_super.s_blocksize_bits);
 	sb->s_maxbytes = ocfs2_max_file_offset(bbits, cbits);
 
+	osb->osb_dx_mask = (1 << (cbits - bbits)) - 1;
+
+	for (i = 0; i < 3; i++)
+		osb->osb_dx_seed[i] = le32_to_cpu(di->id2.i_super.s_dx_seed[i]);
+	osb->osb_dx_seed[3] = le32_to_cpu(di->id2.i_super.s_uuid_hash);
+
 	osb->sb = sb;
 	/* Save off for ocfs2_rw_direct */
 	osb->s_sectsize_bits = blksize_bits(sector_size);
diff --git a/fs/ocfs2/xattr.c b/fs/ocfs2/xattr.c
index e1d638a..254133a 100644
--- a/fs/ocfs2/xattr.c
+++ b/fs/ocfs2/xattr.c
@@ -507,7 +507,7 @@ int ocfs2_calc_xattr_init(struct inode *dir,
 			  struct ocfs2_security_xattr_info *si,
 			  int *want_clusters,
 			  int *xattr_credits,
-			  struct ocfs2_alloc_context **xattr_ac)
+			  int *want_meta)
 {
 	int ret = 0;
 	struct ocfs2_super *osb = OCFS2_SB(dir->i_sb);
@@ -545,11 +545,7 @@ int ocfs2_calc_xattr_init(struct inode *dir,
 	 */
 	if (dir->i_sb->s_blocksize == OCFS2_MIN_BLOCKSIZE ||
 	    (s_size + a_size) > OCFS2_XATTR_FREE_IN_IBODY) {
-		ret = ocfs2_reserve_new_metadata_blocks(osb, 1, xattr_ac);
-		if (ret) {
-			mlog_errno(ret);
-			return ret;
-		}
+		*want_meta = *want_meta + 1;
 		*xattr_credits += OCFS2_XATTR_BLOCK_CREATE_CREDITS;
 	}
 
diff --git a/fs/ocfs2/xattr.h b/fs/ocfs2/xattr.h
index 5a1ebc7..1ca7e9a 100644
--- a/fs/ocfs2/xattr.h
+++ b/fs/ocfs2/xattr.h
@@ -68,7 +68,7 @@ int ocfs2_calc_security_init(struct inode *,
 			     int *, int *, struct ocfs2_alloc_context **);
 int ocfs2_calc_xattr_init(struct inode *, struct buffer_head *,
 			  int, struct ocfs2_security_xattr_info *,
-			  int *, int *, struct ocfs2_alloc_context **);
+			  int *, int *, int *);
 
 /*
  * xattrs can live inside an inode, as part of an external xattr block,
-- 
1.5.6
