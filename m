From: Mark Fasheh <mfasheh@suse.com>
Date: Wed, 12 Nov 2008 18:24:07 -0800
Subject: [Ocfs2-devel] [PATCH 3/4] ocfs2: Add a name indexed b-tree to
	directory inodes
In-Reply-To: <1226543048-911-1-git-send-email-mfasheh@suse.com>
References: <1226543048-911-1-git-send-email-mfasheh@suse.com>
Message-ID: <1226543048-911-4-git-send-email-mfasheh@suse.com>
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
 fs/ocfs2/alloc.c    |   65 ++
 fs/ocfs2/alloc.h    |    3 +
 fs/ocfs2/dir.c      | 1683 ++++++++++++++++++++++++++++++++++++++++++++++++++-
 fs/ocfs2/dir.h      |   14 +-
 fs/ocfs2/inode.c    |    9 +
 fs/ocfs2/journal.h  |   53 ++-
 fs/ocfs2/namei.c    |   34 +-
 fs/ocfs2/ocfs2.h    |   31 +
 fs/ocfs2/ocfs2_fs.h |   95 +++-
 fs/ocfs2/super.c    |    6 +
 10 files changed, 1940 insertions(+), 53 deletions(-)

diff --git a/fs/ocfs2/alloc.c b/fs/ocfs2/alloc.c
index 5592a2f..d10580d 100644
--- a/fs/ocfs2/alloc.c
+++ b/fs/ocfs2/alloc.c
@@ -301,6 +301,62 @@ static struct ocfs2_extent_tree_operations ocfs2_xattr_tree_et_ops = {
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
+	int ret = 0;
+	struct ocfs2_dx_root_block *dx_root = et->et_object;
+
+	dx_root = et->et_object;
+	if (!OCFS2_IS_VALID_DX_ROOT(dx_root)) {
+		ret = -EIO;
+		ocfs2_error(inode->i_sb,
+			"Directory %llu has invalid dx root",
+			(unsigned long long)OCFS2_I(inode)->ip_blkno);
+	}
+
+	return ret;
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
@@ -344,6 +400,15 @@ void ocfs2_init_xattr_value_extent_tree(struct ocfs2_extent_tree *et,
 				 &ocfs2_xattr_value_et_ops);
 }
 
+void ocfs2_init_dx_root_extent_tree(struct ocfs2_extent_tree *et,
+				    struct inode *inode,
+				    struct buffer_head *bh)
+{
+	__ocfs2_init_extent_tree(et, inode, bh, NULL, &ocfs2_dx_root_et_ops);
+}
+
+
+
 static inline void ocfs2_et_set_last_eb_blk(struct ocfs2_extent_tree *et,
 					    u64 new_last_eb_blk)
 {
diff --git a/fs/ocfs2/alloc.h b/fs/ocfs2/alloc.h
index 0fbf8fc..e1763cc 100644
--- a/fs/ocfs2/alloc.h
+++ b/fs/ocfs2/alloc.h
@@ -72,6 +72,9 @@ void ocfs2_init_xattr_value_extent_tree(struct ocfs2_extent_tree *et,
 					struct inode *inode,
 					struct buffer_head *bh,
 					struct ocfs2_xattr_value_root *xv);
+void ocfs2_init_dx_root_extent_tree(struct ocfs2_extent_tree *et,
+				    struct inode *inode,
+				    struct buffer_head *bh);
 
 struct ocfs2_alloc_context;
 int ocfs2_insert_extent(struct ocfs2_super *osb,
diff --git a/fs/ocfs2/dir.c b/fs/ocfs2/dir.c
index fa7870a..f113704 100644
--- a/fs/ocfs2/dir.c
+++ b/fs/ocfs2/dir.c
@@ -40,6 +40,7 @@
 #include <linux/types.h>
 #include <linux/slab.h>
 #include <linux/highmem.h>
+#include <linux/sort.h>
 
 #define MLOG_MASK_PREFIX ML_NAMEI
 #include <cluster/masklog.h>
@@ -56,6 +57,7 @@
 #include "namei.h"
 #include "suballoc.h"
 #include "super.h"
+#include "sysfile.h"
 #include "uptodate.h"
 
 #include "buffer_head_io.h"
@@ -69,11 +71,6 @@ static unsigned char ocfs2_filetype_table[] = {
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
@@ -125,9 +122,108 @@ fail:
 	return NULL;
 }
 
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
+}
+
 void ocfs2_free_dir_lookup_result(struct ocfs2_dir_lookup_result *res)
 {
 	brelse(res->dl_leaf_bh);
+	brelse(res->dl_dx_leaf_bh);
 }
 
 /*
@@ -354,6 +450,308 @@ cleanup_and_exit:
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
+	ret = ocfs2_read_block(dir, phys, &dx_leaf_bh);
+	if (ret) {
+		mlog_errno(ret);
+		goto out;
+	}
+
+	dx_leaf = (struct ocfs2_dx_leaf *) dx_leaf_bh->b_data;
+	if (!(OCFS2_IS_VALID_DX_LEAF(dx_leaf))) {
+		OCFS2_RO_ON_INVALID_DX_LEAF(dir->i_sb, dx_leaf);
+		ret = -EROFS;
+		goto out;
+	}
+
+	mlog(0, "leaf info: num_used: %d, count: %d\n",
+	     le16_to_cpu(dx_leaf->dl_num_used), le16_to_cpu(dx_leaf->dl_count));
+
+	/*
+	 * Empty leaf is legal, so no need to check for that.
+	 */
+	found = 0;
+	for (i = 0; i < le16_to_cpu(dx_leaf->dl_num_used); i++) {
+		dx_entry = &dx_leaf->dl_entries[i];
+
+		if (hinfo->major_hash != le32_to_cpu(dx_entry->dx_major_hash)
+		    || hinfo->minor_hash != le32_to_cpu(dx_entry->dx_minor_hash))
+			continue;
+
+		/*
+		 * Search unindexed leaf block now. We're not
+		 * guaranteed to find anything.
+		 */
+		ret = ocfs2_read_block(dir,
+				       le64_to_cpu(dx_entry->dx_dirent_blk),
+				       &dir_ent_bh);
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
+/*
+ * Convenience function for pulling in the root of the dir index
+ * tree. This checks for validity as well.
+ */
+static int ocfs2_dx_dir_read_root(struct inode *dir, struct ocfs2_dinode *di,
+				  struct buffer_head **dx_root_bh)
+{
+	int ret;
+	struct ocfs2_dx_root_block *dx_root;
+
+	*dx_root_bh = NULL;
+
+	ret = ocfs2_read_block(dir, le64_to_cpu(di->i_dx_root), dx_root_bh);
+	if (ret) {
+		mlog_errno(ret);
+		goto out;
+	}
+	dx_root = (struct ocfs2_dx_root_block *) (*dx_root_bh)->b_data;
+
+	if (!OCFS2_IS_VALID_DX_ROOT(dx_root)) {
+		OCFS2_RO_ON_INVALID_DX_ROOT(dir->i_sb, dx_root);
+		ret = -EROFS;
+		goto out;
+	}
+
+out:
+	if (ret) {
+		brelse(*dx_root_bh);
+		*dx_root_bh = NULL;
+	}
+
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
+	ret = ocfs2_read_block(dir, OCFS2_I(dir)->ip_blkno, &di_bh);
+	if (ret) {
+		mlog_errno(ret);
+		goto out;
+	}
+
+	di = (struct ocfs2_dinode *)di_bh->b_data;
+
+	ret = ocfs2_dx_dir_read_root(dir, di, &dx_root_bh);
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
@@ -365,7 +763,8 @@ cleanup_and_exit:
  * buffer_heads - they are passed back only so that it can be passed into
  * any one of the manipulation functions (add entry, delete entry,
  * etc). As an example, bh in the extent directory case is a data
- * block, in the inline-data case it actually points to an inode.
+ * block, in the inline-data case it actually points to an inode, in
+ * the indexed directory case, multiple buffers are involved.
  */
 int ocfs2_find_entry(const char *name, int namelen,
 		     struct inode *dir,
@@ -374,6 +773,14 @@ int ocfs2_find_entry(const char *name, int namelen,
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
@@ -418,6 +825,10 @@ out:
 	return ret;
 }
 
+/*
+ * __ocfs2_delete_entry deletes a directory entry by merging it with the
+ * previous entry
+ */
 static int __ocfs2_delete_entry(handle_t *handle, struct inode *dir,
 				struct ocfs2_dir_entry *de_del,
 				struct buffer_head *bh, char *first_de,
@@ -463,6 +874,78 @@ bail:
 	return status;
 }
 
+static void ocfs2_dx_leaf_remove_entry(struct ocfs2_dx_leaf *dx_leaf, int index)
+{
+	int num_used = le16_to_cpu(dx_leaf->dl_num_used);
+
+	if (num_used == 1 || index == (num_used - 1))
+		goto clear;
+
+	memmove(&dx_leaf->dl_entries[index], &dx_leaf->dl_entries[index + 1],
+		(num_used - index - 1)*sizeof(struct ocfs2_dx_entry));
+clear:
+	num_used--;
+	memset(&dx_leaf->dl_entries[num_used], 0,
+	       sizeof(struct ocfs2_dx_entry));
+	dx_leaf->dl_num_used = cpu_to_le16(num_used);
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
+	BUG_ON(le16_to_cpu(dx_leaf->dl_count) <= 0);
+	BUG_ON(le16_to_cpu(dx_leaf->dl_num_used) <= 0);
+
+	index = (char *)dx_entry - (char *)dx_leaf->dl_entries;
+	index /= sizeof(*dx_entry);
+
+	if (index >= le16_to_cpu(dx_leaf->dl_num_used)) {
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
+	ret = ocfs2_journal_access(handle, dir, lookup->dl_dx_leaf_bh,
+				   OCFS2_JOURNAL_ACCESS_WRITE);
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
@@ -500,19 +983,22 @@ static inline int ocfs2_delete_entry_el(handle_t *handle,
 }
 
 /*
- * ocfs2_delete_entry deletes a directory entry by merging it with the
- * previous entry
+ * Delete a directory entry. Hide the details of directory
+ * implementation from the caller.
  */
 int ocfs2_delete_entry(handle_t *handle,
 		       struct inode *dir,
-		       struct ocfs2_dir_lookup_result *res)
+		       struct ocfs2_dir_lookup_result *lookup)
 {
+	if (ocfs2_dir_indexed(dir))
+		return ocfs2_delete_entry_dx(handle, dir, lookup);
+
 	if (OCFS2_I(dir)->ip_dyn_features & OCFS2_INLINE_DATA_FL)
-		return ocfs2_delete_entry_id(handle, dir, res->dl_entry,
-					     res->dl_leaf_bh);
+		return ocfs2_delete_entry_id(handle, dir, lookup->dl_entry,
+					     lookup->dl_leaf_bh);
 
-	return ocfs2_delete_entry_el(handle, dir, res->dl_entry,
-				     res->dl_leaf_bh);
+	return ocfs2_delete_entry_el(handle, dir, lookup->dl_entry,
+				     lookup->dl_leaf_bh);
 }
 
 /*
@@ -540,6 +1026,58 @@ static inline int ocfs2_dirent_would_fit(struct ocfs2_dir_entry *de,
 	return 0;
 }
 
+static void ocfs2_dx_dir_leaf_insert_tail(struct ocfs2_dx_leaf *dx_leaf,
+					  struct ocfs2_dx_entry *dx_new_entry)
+{
+	int i;
+
+	i = le16_to_cpu(dx_leaf->dl_num_used);
+	dx_leaf->dl_entries[i] = *dx_new_entry;
+
+	le16_add_cpu(&dx_leaf->dl_num_used, 1);
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
+	ret = ocfs2_journal_access(handle, dir, dx_leaf_bh,
+				   OCFS2_JOURNAL_ACCESS_WRITE);
+	if (ret) {
+		mlog_errno(ret);
+		goto out;
+	}
+
+	dx_leaf = (struct ocfs2_dx_leaf *)dx_leaf_bh->b_data;
+	i = le16_to_cpu(dx_leaf->dl_num_used);
+	dx_entry = &dx_leaf->dl_entries[i];
+
+	memset(dx_entry, 0, sizeof(*dx_entry));
+	dx_entry->dx_major_hash = cpu_to_le32(hinfo->major_hash);
+	dx_entry->dx_minor_hash = cpu_to_le32(hinfo->minor_hash);
+	dx_entry->dx_dirent_blk = cpu_to_le64(dirent_blk);
+
+	le16_add_cpu(&dx_leaf->dl_num_used, 1);
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
@@ -602,7 +1140,17 @@ int __ocfs2_add_entry(handle_t *handle,
 			}
 
 			status = ocfs2_journal_access(handle, dir, insert_bh,
-						      OCFS2_JOURNAL_ACCESS_WRITE);
+					      OCFS2_JOURNAL_ACCESS_WRITE);
+
+			if (ocfs2_dir_indexed(dir)) {
+				status = ocfs2_dx_dir_leaf_insert(dir, handle,
+								  lookup);
+				if (status) {
+					mlog_errno(status);
+					goto bail;
+				}
+			}
+
 			/* By now the buffer is marked for journaling */
 			offset += le16_to_cpu(de->rec_len);
 			if (le64_to_cpu(de->inode)) {
@@ -731,6 +1279,10 @@ out:
 	return 0;
 }
 
+/*
+ * NOTE: This function can be called against unindexed directories,
+ * and indexed ones.
+ */
 static int ocfs2_dir_foreach_blk_el(struct inode *inode,
 				    u64 *f_version,
 				    loff_t *f_pos, void *priv,
@@ -1030,6 +1582,8 @@ static int ocfs2_empty_dir_filldir(void *priv, const char *name, int name_len,
  * routine to check that the specified directory is empty (for rmdir)
  *
  * Returns 1 if dir is empty, zero otherwise.
+ *
+ * XXX: This is a performance problem
  */
 int ocfs2_empty_dir(struct inode *inode)
 {
@@ -1123,7 +1677,8 @@ static int ocfs2_fill_new_dir_el(struct ocfs2_super *osb,
 				 struct inode *parent,
 				 struct inode *inode,
 				 struct buffer_head *fe_bh,
-				 struct ocfs2_alloc_context *data_ac)
+				 struct ocfs2_alloc_context *data_ac,
+				 struct buffer_head **ret_new_bh)
 {
 	int status;
 	struct buffer_head *new_bh = NULL;
@@ -1166,6 +1721,10 @@ static int ocfs2_fill_new_dir_el(struct ocfs2_super *osb,
 	}
 
 	status = 0;
+	if (ret_new_bh) {
+		*ret_new_bh = new_bh;
+		new_bh = NULL;
+	}
 bail:
 	brelse(new_bh);
 
@@ -1173,20 +1732,376 @@ bail:
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
+	ret = ocfs2_journal_access(handle, dir, dx_root_bh,
+				   OCFS2_JOURNAL_ACCESS_CREATE);
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
+	ret = ocfs2_journal_access(handle, dir, di_bh,
+				   OCFS2_JOURNAL_ACCESS_CREATE);
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
+		ret = ocfs2_journal_access(handle, dir, bh,
+					   OCFS2_JOURNAL_ACCESS_CREATE);
+		if (ret < 0) {
+			mlog_errno(ret);
+			goto out;
+		}
+
+		dx_leaf = (struct ocfs2_dx_leaf *) bh->b_data;
+
+		memset(dx_leaf, 0, osb->sb->s_blocksize);
+		strcpy(dx_leaf->dl_signature, OCFS2_DX_LEAF_SIGNATURE);
+		dx_leaf->dl_count =
+			cpu_to_le16(ocfs2_dx_entries_per_leaf(osb->sb));
+
+		mlog(0,
+		     "Dir %llu, format dx_leaf: %llu, entry count: %u\n",
+		     (unsigned long long)OCFS2_I(dir)->ip_blkno,
+		     (unsigned long long)bh->b_blocknr,
+		     le16_to_cpu(dx_leaf->dl_count));
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
+		de_buf += le16_to_cpu(de->rec_len);
+	}
+
+out:
+	return ret;
 }
 
 static void ocfs2_expand_last_dirent(char *start, unsigned int old_size,
@@ -1219,35 +2134,62 @@ static void ocfs2_expand_last_dirent(char *start, unsigned int old_size,
  */
 static int ocfs2_expand_inline_dir(struct inode *dir, struct buffer_head *di_bh,
 				   unsigned int blocks_wanted,
+				   struct ocfs2_dir_lookup_result *lookup,
 				   struct buffer_head **first_block_bh)
 {
-	int ret, credits = OCFS2_INLINE_TO_EXTENTS_CREDITS;
-	u32 alloc, bit_off, len;
+	int ret, i, num_dx_leaves = 0, credits = OCFS2_INLINE_TO_EXTENTS_CREDITS;
+	u32 alloc, dx_alloc, bit_off, len;
 	struct super_block *sb = dir->i_sb;
-	u64 blkno, bytes = blocks_wanted << sb->s_blocksize_bits;
+	u64 dx_insert_blkno, blkno,
+		bytes = blocks_wanted << sb->s_blocksize_bits;
 	struct ocfs2_super *osb = OCFS2_SB(dir->i_sb);
 	struct ocfs2_inode_info *oi = OCFS2_I(dir);
 	struct ocfs2_alloc_context *data_ac;
 	struct buffer_head *dirdata_bh = NULL;
+	struct buffer_head *dx_root_bh = NULL;
+	struct buffer_head **dx_leaves = NULL;
 	struct ocfs2_dinode *di = (struct ocfs2_dinode *)di_bh->b_data;
 	handle_t *handle;
 	struct ocfs2_extent_tree et;
+	struct ocfs2_extent_tree dx_et;
+	struct ocfs2_alloc_context *meta_ac = NULL;
 
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
 	 */
 	BUG_ON(alloc > 2);
 
-	ret = ocfs2_reserve_clusters(osb, alloc, &data_ac);
+	ret = ocfs2_reserve_clusters(osb, dx_alloc + alloc, &data_ac);
 	if (ret) {
 		mlog_errno(ret);
 		goto out;
@@ -1257,7 +2199,7 @@ static int ocfs2_expand_inline_dir(struct inode *dir, struct buffer_head *di_bh,
 
 	/*
 	 * Prepare for worst case allocation scenario of two separate
-	 * extents.
+	 * extents in the unindexed tree.
 	 */
 	if (alloc == 2)
 		credits += OCFS2_SUBALLOC_ALLOC;
@@ -1269,6 +2211,21 @@ static int ocfs2_expand_inline_dir(struct inode *dir, struct buffer_head *di_bh,
 		goto out_sem;
 	}
 
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
+	}
+
 	/*
 	 * Try to claim as many clusters as the bitmap can give though
 	 * if we only get one now, that's enough to continue. The rest
@@ -1314,6 +2271,15 @@ static int ocfs2_expand_inline_dir(struct inode *dir, struct buffer_head *di_bh,
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
@@ -1366,6 +2332,21 @@ static int ocfs2_expand_inline_dir(struct inode *dir, struct buffer_head *di_bh,
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
@@ -1389,6 +2370,18 @@ static int ocfs2_expand_inline_dir(struct inode *dir, struct buffer_head *di_bh,
 
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
 	ocfs2_commit_trans(osb, handle);
@@ -1399,8 +2392,17 @@ out_sem:
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
@@ -1466,6 +2468,7 @@ static int ocfs2_extend_dir(struct ocfs2_super *osb,
 			    struct inode *dir,
 			    struct buffer_head *parent_fe_bh,
 			    unsigned int blocks_wanted,
+			    struct ocfs2_dir_lookup_result *lookup,
 			    struct buffer_head **new_de_bh)
 {
 	int status = 0;
@@ -1485,7 +2488,8 @@ static int ocfs2_extend_dir(struct ocfs2_super *osb,
 
 	if (OCFS2_I(dir)->ip_dyn_features & OCFS2_INLINE_DATA_FL) {
 		status = ocfs2_expand_inline_dir(dir, parent_fe_bh,
-						 blocks_wanted, &new_bh);
+						 blocks_wanted, lookup,
+						 &new_bh);
 		if (status) {
 			mlog_errno(status);
 			goto bail;
@@ -1746,6 +2750,471 @@ bail:
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
+	int i, num = le16_to_cpu(dx_leaf->dl_num_used);
+
+	for (i = 0; i < (num - 1); i++) {
+		if (le32_to_cpu(dx_leaf->dl_entries[i].dx_major_hash) !=
+		    le32_to_cpu(dx_leaf->dl_entries[i + 1].dx_major_hash))
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
+	int i, num_used = le16_to_cpu(dx_leaf->dl_num_used);
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
+		u32 val = le32_to_cpu(dx_leaf->dl_entries[0].dx_major_hash);
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
+		if (le32_to_cpu(dx_leaf->dl_entries[i].dx_major_hash) >
+		    leaf_cpos)
+			break;
+
+	BUG_ON(i == num_used); /* Should be impossible */
+	*split_hash = le32_to_cpu(dx_leaf->dl_entries[i].dx_major_hash);
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
+	struct ocfs2_dx_entry *dx_entry;
+
+	for (i = 0; i < num_dx_leaves; i++) {
+		orig_dx_leaf = (struct ocfs2_dx_leaf *) orig_dx_leaves[i]->b_data;
+		new_dx_leaf = (struct ocfs2_dx_leaf *) new_dx_leaves[i]->b_data;
+
+		num_used = le16_to_cpu(orig_dx_leaf->dl_num_used);
+
+		memcpy(tmp_dx_leaf, orig_dx_leaf, dir->i_sb->s_blocksize);
+		tmp_dx_leaf->dl_num_used = cpu_to_le16(0);
+		memset(&tmp_dx_leaf->dl_entries, 0, sizeof(*dx_entry)*num_used);
+
+		for (j = 0; j < num_used; j++) {
+			dx_entry = &orig_dx_leaf->dl_entries[j];
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
+	int credits, ret, i, num_used = le16_to_cpu(dx_leaf->dl_num_used);
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
+	if (num_used < le16_to_cpu(dx_leaf->dl_count)) {
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
+	ret = ocfs2_journal_access(handle, dir, dx_leaf_bh,
+				   OCFS2_JOURNAL_ACCESS_WRITE);
+	if (ret) {
+		mlog_errno(ret);
+		goto out_commit;
+	}
+
+	/*
+	 * This block is changing anyway, so we can sort it in place.
+	 */
+	sort(dx_leaf->dl_entries, num_used, sizeof(struct ocfs2_dx_entry),
+	     dx_leaf_sort_cmp, dx_leaf_sort_swap);
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
+	ret = ocfs2_read_blocks(dir, orig_leaves_start, num_dx_leaves,
+				orig_dx_leaves, 0);
+	if (ret) {
+		mlog_errno(ret);
+		goto out_commit;
+	}
+
+	for (i = 0; i < num_dx_leaves; i++) {
+		ret = ocfs2_journal_access(handle, dir, orig_dx_leaves[i],
+					   OCFS2_JOURNAL_ACCESS_WRITE);
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
+	ret = ocfs2_dx_dir_read_root(dir, di, &dx_root_bh);
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
+	ret = ocfs2_read_block(dir, blkno, &dx_leaf_bh);
+	if (ret) {
+		mlog_errno(ret);
+		goto out;
+	}
+
+	dx_leaf = (struct ocfs2_dx_leaf *)dx_leaf_bh->b_data;
+	if (!OCFS2_IS_VALID_DX_LEAF(dx_leaf)) {
+		OCFS2_RO_ON_INVALID_DX_LEAF(osb->sb, dx_leaf);
+		ret = -EROFS;
+		goto out;
+	}
+
+	if (le16_to_cpu(dx_leaf->dl_num_used) >=
+	    le16_to_cpu(dx_leaf->dl_count)) {
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
@@ -1772,6 +3241,22 @@ int ocfs2_prepare_dir_for_insert(struct ocfs2_super *osb,
 		goto out;
 	}
 
+	ocfs2_dx_dir_name_hash(dir, name, namelen, &lookup->dl_hinfo);
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
@@ -1790,7 +3275,7 @@ int ocfs2_prepare_dir_for_insert(struct ocfs2_super *osb,
 		BUG_ON(bh);
 
 		ret = ocfs2_extend_dir(osb, dir, parent_fe_bh, blocks_wanted,
-				       &bh);
+				       lookup, &bh);
 		if (ret) {
 			if (ret != -ENOSPC)
 				mlog_errno(ret);
@@ -1803,6 +3288,148 @@ int ocfs2_prepare_dir_for_insert(struct ocfs2_super *osb,
 	lookup->dl_leaf_bh = bh;
 	bh = NULL;
 out:
-	brelse(bh);
+		brelse(bh);
+	return ret;
+}
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
+	ret = ocfs2_journal_access(handle, dir, di_bh,
+				   OCFS2_JOURNAL_ACCESS_WRITE);
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
+	ret = ocfs2_dx_dir_read_root(dir, di, &dx_root_bh);
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
 	return ret;
 }
diff --git a/fs/ocfs2/dir.h b/fs/ocfs2/dir.h
index 768ee9f..d035b75 100644
--- a/fs/ocfs2/dir.h
+++ b/fs/ocfs2/dir.h
@@ -26,9 +26,18 @@
 #ifndef OCFS2_DIR_H
 #define OCFS2_DIR_H
 
+struct ocfs2_dx_hinfo {
+	u32	major_hash;
+	u32	minor_hash;
+};
+
 struct ocfs2_dir_lookup_result {
 	struct buffer_head		*dl_leaf_bh;
 	struct ocfs2_dir_entry		*dl_entry;
+
+	struct buffer_head		*dl_dx_leaf_bh;
+	struct ocfs2_dx_entry		*dl_dx_entry;
+	struct ocfs2_dx_hinfo		dl_hinfo;
 };
 void ocfs2_free_dir_lookup_result(struct ocfs2_dir_lookup_result *res);
 
@@ -85,6 +94,9 @@ int ocfs2_fill_new_dir(struct ocfs2_super *osb,
 		       struct inode *parent,
 		       struct inode *inode,
 		       struct buffer_head *fe_bh,
-		       struct ocfs2_alloc_context *data_ac);
+		       struct ocfs2_alloc_context *data_ac,
+		       struct ocfs2_alloc_context *meta_ac);
+
+int ocfs2_dx_dir_truncate(struct inode *dir, struct buffer_head *di_bh);
 
 #endif /* OCFS2_DIR_H */
diff --git a/fs/ocfs2/inode.c b/fs/ocfs2/inode.c
index 7aa00d5..bdfe09f 100644
--- a/fs/ocfs2/inode.c
+++ b/fs/ocfs2/inode.c
@@ -37,6 +37,7 @@
 #include "ocfs2.h"
 
 #include "alloc.h"
+#include "dir.h"
 #include "dlmglue.h"
 #include "extent_map.h"
 #include "file.h"
@@ -748,6 +749,14 @@ static int ocfs2_wipe_inode(struct inode *inode,
 		goto bail_unlock_dir;
 	}
 
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
diff --git a/fs/ocfs2/journal.h b/fs/ocfs2/journal.h
index d4d14e9..354fd24 100644
--- a/fs/ocfs2/journal.h
+++ b/fs/ocfs2/journal.h
@@ -319,36 +319,37 @@ int                  ocfs2_journal_dirty_data(handle_t *handle,
  * bitmap block for the new bit) */
 #define OCFS2_DIR_LINK_ADDITIONAL_CREDITS (1 + 2)
 
-/* parent fe, parent block, new file entry, inode alloc fe, inode alloc
- * group descriptor + mkdir/symlink blocks */
-#define OCFS2_MKNOD_CREDITS (3 + OCFS2_SUBALLOC_ALLOC                         \
-			    + OCFS2_DIR_LINK_ADDITIONAL_CREDITS)
+/* parent fe, parent block, new file entry, index leaf, inode
+ * alloc fe, inode alloc group descriptor + mkdir/symlink blocks */
+#define OCFS2_BASE_MKNOD_CREDITS (4 + OCFS2_SUBALLOC_ALLOC                     \
+				  + OCFS2_DIR_LINK_ADDITIONAL_CREDITS)
 
 /* local alloc metadata change + main bitmap updates */
 #define OCFS2_WINDOW_MOVE_CREDITS (OCFS2_INODE_UPDATE_CREDITS                 \
 				  + OCFS2_SUBALLOC_ALLOC + OCFS2_SUBALLOC_FREE)
 
 /* used when we don't need an allocation change for a dir extend. One
- * for the dinode, one for the new block. */
+ * for the dinode, one for the new block */
 #define OCFS2_SIMPLE_DIR_EXTEND_CREDITS (2)
 
-/* file update (nlink, etc) + directory mtime/ctime + dir entry block */
-#define OCFS2_LINK_CREDITS  (2*OCFS2_INODE_UPDATE_CREDITS + 1)
+/* file update (nlink, etc) + directory mtime/ctime + dir entry block
+ * + index leaf */
+#define OCFS2_LINK_CREDITS  (2*OCFS2_INODE_UPDATE_CREDITS + 2)
 
 /* inode + dir inode (if we unlink a dir), + dir entry block + orphan
- * dir inode link */
+ * dir inode link + dir inode index leaf */
 #define OCFS2_UNLINK_CREDITS  (2 * OCFS2_INODE_UPDATE_CREDITS + 1             \
-			      + OCFS2_LINK_CREDITS)
+			      + OCFS2_LINK_CREDITS + 1)
 
 /* dinode + orphan dir dinode + inode alloc dinode + orphan dir entry +
- * inode alloc group descriptor */
-#define OCFS2_DELETE_INODE_CREDITS (3 * OCFS2_INODE_UPDATE_CREDITS + 1 + 1)
+ * inode alloc group descriptor + orphan dir index leaf */
+#define OCFS2_DELETE_INODE_CREDITS (3 * OCFS2_INODE_UPDATE_CREDITS + 1 + 1 + 1)
 
 /* dinode update, old dir dinode update, new dir dinode update, old
  * dir dir entry, new dir dir entry, dir entry update for renaming
- * directory + target unlink */
+ * directory + target unlink + 3 x dir index leaves */
 #define OCFS2_RENAME_CREDITS (3 * OCFS2_INODE_UPDATE_CREDITS + 3              \
-			     + OCFS2_UNLINK_CREDITS)
+			     + OCFS2_UNLINK_CREDITS + 3)
 
 /* global bitmap dinode, group desc., relinked group,
  * suballocator dinode, group desc., relinked group,
@@ -357,6 +358,10 @@ int                  ocfs2_journal_dirty_data(handle_t *handle,
 					  + OCFS2_INODE_UPDATE_CREDITS \
 					  + OCFS2_XATTR_BLOCK_UPDATE_CREDITS)
 
+/* inode update, removal of dx root block from allocator */
+#define OCFS2_DX_ROOT_REMOVE_CREDITS (OCFS2_INODE_UPDATE_CREDITS +	\
+				      OCFS2_SUBALLOC_FREE)
+
 /*
  * Please note that the caller must make sure that root_el is the root
  * of extent tree. So for an inode, it should be &fe->id2.i_list. Otherwise
@@ -389,9 +394,29 @@ static inline int ocfs2_calc_extend_credits(struct super_block *sb,
 	return bitmap_blocks + sysfile_bitmap_blocks + extent_blocks;
 }
 
+static inline int ocfs2_add_dir_index_credits(struct super_block *sb)
+{
+	/* 1 block for index, 2 allocs (data, metadata), 1 clusters
+	 * worth of blocks for initial extent. */
+	return 1 + 2 * OCFS2_SUBALLOC_ALLOC +
+		ocfs2_clusters_to_blocks(sb, 1);
+}
+
+static inline int ocfs2_mknod_credits(struct super_block *sb, int is_dir)
+{
+	int credits = OCFS2_BASE_MKNOD_CREDITS;
+
+	if (is_dir
+	    && ocfs2_supports_indexed_dirs(OCFS2_SB(sb))
+	    && !ocfs2_supports_inline_data(OCFS2_SB(sb)))
+		credits += ocfs2_add_dir_index_credits(sb);
+
+	return credits;
+}
+
 static inline int ocfs2_calc_symlink_credits(struct super_block *sb)
 {
-	int blocks = OCFS2_MKNOD_CREDITS;
+	int blocks = ocfs2_mknod_credits(sb, 0);
 
 	/* links can be longer than one block so we may update many
 	 * within our single allocated extent. */
diff --git a/fs/ocfs2/namei.c b/fs/ocfs2/namei.c
index d136bdf..862c576 100644
--- a/fs/ocfs2/namei.c
+++ b/fs/ocfs2/namei.c
@@ -191,7 +191,7 @@ static int ocfs2_mknod(struct inode *dir,
 		       int mode,
 		       dev_t dev)
 {
-	int status = 0;
+	int status = 0, newdir_clusters;
 	struct buffer_head *parent_fe_bh = NULL;
 	handle_t *handle = NULL;
 	struct ocfs2_super *osb;
@@ -199,6 +199,7 @@ static int ocfs2_mknod(struct inode *dir,
 	struct buffer_head *new_fe_bh = NULL;
 	struct inode *inode = NULL;
 	struct ocfs2_alloc_context *inode_ac = NULL;
+	struct ocfs2_alloc_context *meta_ac = NULL;
 	struct ocfs2_alloc_context *data_ac = NULL;
 	struct ocfs2_dir_lookup_result lookup = { NULL, };
 
@@ -252,7 +253,21 @@ static int ocfs2_mknod(struct inode *dir,
 
 	/* Reserve a cluster if creating an extent based directory. */
 	if (S_ISDIR(mode) && !ocfs2_supports_inline_data(osb)) {
-		status = ocfs2_reserve_clusters(osb, 1, &data_ac);
+		newdir_clusters = 1;
+
+		if (ocfs2_supports_indexed_dirs(osb)) {
+			newdir_clusters++;
+
+			status = ocfs2_reserve_new_metadata_blocks(osb, 1,
+								   &meta_ac);
+			if (status < 0) {
+				if (status != -ENOSPC)
+					mlog_errno(status);
+				goto leave;
+			}
+		}
+
+		status = ocfs2_reserve_clusters(osb, newdir_clusters, &data_ac);
 		if (status < 0) {
 			if (status != -ENOSPC)
 				mlog_errno(status);
@@ -260,7 +275,8 @@ static int ocfs2_mknod(struct inode *dir,
 		}
 	}
 
-	handle = ocfs2_start_trans(osb, OCFS2_MKNOD_CREDITS);
+	handle = ocfs2_start_trans(osb, ocfs2_mknod_credits(osb->sb,
+							    S_ISDIR(mode)));
 	if (IS_ERR(handle)) {
 		status = PTR_ERR(handle);
 		handle = NULL;
@@ -279,7 +295,7 @@ static int ocfs2_mknod(struct inode *dir,
 
 	if (S_ISDIR(mode)) {
 		status = ocfs2_fill_new_dir(osb, handle, dir, inode,
-					    new_fe_bh, data_ac);
+					    new_fe_bh, data_ac, meta_ac);
 		if (status < 0) {
 			mlog_errno(status);
 			goto leave;
@@ -339,6 +355,9 @@ leave:
 	if (inode_ac)
 		ocfs2_free_alloc_context(inode_ac);
 
+	if (meta_ac)
+		ocfs2_free_alloc_context(meta_ac);
+
 	if (data_ac)
 		ocfs2_free_alloc_context(data_ac);
 
@@ -362,6 +381,7 @@ static int ocfs2_mknod_locked(struct ocfs2_super *osb,
 	struct ocfs2_extent_list *fel;
 	u64 fe_blkno = 0;
 	u16 suballoc_bit;
+	u16 feat;
 	struct inode *inode = NULL;
 
 	mlog_entry("(0x%p, 0x%p, %d, %lu, '%.*s')\n", dir, dentry, mode,
@@ -445,11 +465,11 @@ static int ocfs2_mknod_locked(struct ocfs2_super *osb,
 	fe->i_dtime = 0;
 
 	/*
-	 * If supported, directories start with inline data.
+	 * If supported, directories start with inline data. If inline
+	 * isn't supported, but indexing is, we start them as indexed.
 	 */
+	feat = le16_to_cpu(fe->i_dyn_features);
 	if (S_ISDIR(mode) && ocfs2_supports_inline_data(osb)) {
-		u16 feat = le16_to_cpu(fe->i_dyn_features);
-
 		fe->i_dyn_features = cpu_to_le16(feat | OCFS2_INLINE_DATA_FL);
 
 		fe->id2.i_data.id_count = cpu_to_le16(ocfs2_max_inline_data(osb->sb));
diff --git a/fs/ocfs2/ocfs2.h b/fs/ocfs2/ocfs2.h
index 3fed9e3..e87fedd 100644
--- a/fs/ocfs2/ocfs2.h
+++ b/fs/ocfs2/ocfs2.h
@@ -329,6 +329,9 @@ struct ocfs2_super
 	struct ocfs2_node_map		osb_recovering_orphan_dirs;
 	unsigned int			*osb_orphan_wipes;
 	wait_queue_head_t		osb_wipe_event;
+
+	unsigned int			osb_dx_mask;
+	u32				osb_dx_seed[4];
 };
 
 #define OCFS2_SB(sb)	    ((struct ocfs2_super *)(sb)->s_fs_info)
@@ -376,6 +379,13 @@ static inline int ocfs2_supports_xattr(struct ocfs2_super *osb)
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
@@ -476,6 +486,27 @@ static inline int ocfs2_uses_extended_slot_map(struct ocfs2_super *osb)
 #define OCFS2_IS_VALID_XATTR_BLOCK(ptr)					\
 	(!strcmp((ptr)->xb_signature, OCFS2_XATTR_BLOCK_SIGNATURE))
 
+#define OCFS2_IS_VALID_DX_ROOT(ptr)					\
+	(!strcmp((ptr)->dr_signature, OCFS2_DX_ROOT_SIGNATURE))
+
+#define OCFS2_RO_ON_INVALID_DX_ROOT(__sb, __ir)	do {			\
+	typeof(__ir) ____ir = (__ir);					\
+		ocfs2_error((__sb),					\
+		"Dir Index Root # %llu has bad signature %.*s",		\
+		(unsigned long long)le64_to_cpu((____ir)->dr_blkno), 7,	\
+		(____ir)->dr_signature);				\
+} while (0)
+
+#define OCFS2_IS_VALID_DX_LEAF(ptr)					\
+	(!strcmp((ptr)->dl_signature, OCFS2_DX_LEAF_SIGNATURE))
+
+#define OCFS2_RO_ON_INVALID_DX_LEAF(__sb, __ir)	do {			\
+	typeof(__ir) ____ir = (__ir);					\
+		ocfs2_error((__sb),					\
+		"Dir Index Leaf has bad signature %.*s",		\
+		7, (____ir)->dl_signature);				\
+} while (0)
+
 static inline unsigned long ino_from_blkno(struct super_block *sb,
 					   u64 blkno)
 {
diff --git a/fs/ocfs2/ocfs2_fs.h b/fs/ocfs2/ocfs2_fs.h
index 5f180cf..c723d5e 100644
--- a/fs/ocfs2/ocfs2_fs.h
+++ b/fs/ocfs2/ocfs2_fs.h
@@ -65,6 +65,8 @@
 #define OCFS2_EXTENT_BLOCK_SIGNATURE	"EXBLK01"
 #define OCFS2_GROUP_DESC_SIGNATURE      "GROUP01"
 #define OCFS2_XATTR_BLOCK_SIGNATURE	"XATTR01"
+#define OCFS2_DX_ROOT_SIGNATURE		"DXDIR01"
+#define OCFS2_DX_LEAF_SIGNATURE		"DXLEAF1"
 
 /* Compatibility flags */
 #define OCFS2_HAS_COMPAT_FEATURE(sb,mask)			\
@@ -146,6 +148,9 @@
 /* Support for extended attributes */
 #define OCFS2_FEATURE_INCOMPAT_XATTR		0x0200
 
+/* Support for indexed directores */
+#define OCFS2_FEATURE_INCOMPAT_INDEXED_DIRS	0x0400
+
 /*
  * backup superblock flag is used to indicate that this volume
  * has backup superblocks.
@@ -584,8 +589,9 @@ struct ocfs2_super_block {
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
@@ -660,7 +666,8 @@ struct ocfs2_dinode {
 					   was set in i_flags */
 	__le16 i_dyn_features;
 	__le64 i_xattr_loc;
-/*80*/	__le64 i_reserved2[7];
+/*80*/	__le64 i_dx_root;
+	__le64 i_reserved2[6];
 /*B8*/	union {
 		__le64 i_pad1;		/* Generic way to refer to this
 					   64bit union */
@@ -709,6 +716,68 @@ struct ocfs2_dir_entry {
 } __attribute__ ((packed));
 
 /*
+ * A directory indexing block. Each indexed directory has one of these,
+ * pointed to by ocfs2_dinode.
+ *
+ * This block stores an indexed btree root, and a set of free space
+ * start-of-list pointers.
+ */
+struct ocfs2_dx_root_block {
+	__u8		dr_signature[8];	/* Signature for verification */
+	__le64		dr_csum;		/* Checksum (unused) */
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
+/*
+ * The header of a leaf block in the indexed tree.
+ */
+struct ocfs2_dx_leaf {
+	__u8		dl_signature[8];/* Signature for verification */
+	__le64		dl_csum;	/* Checksum (unused) */
+	__le64		dl_reserved1;
+	__le32		dl_reserved2;
+	__le16		dl_count;	/* Maximum number of entries
+					 * possible in ih_entries */
+	__le16		dl_num_used;	/* Current number of
+					 * ih_entries entries */
+	struct	ocfs2_dx_entry		dl_entries[0];	/* Indexed dir entries
+							 * in a packed array of
+							 * length ih_num_used */
+};
+
+/*
  * On disk allocator group structure for OCFS2
  */
 struct ocfs2_group_desc
@@ -917,6 +986,16 @@ static inline int ocfs2_extent_recs_per_inode_with_xattr(
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
@@ -937,6 +1016,16 @@ static inline u16 ocfs2_extent_recs_per_eb(struct super_block *sb)
 	return size / sizeof(struct ocfs2_extent_rec);
 }
 
+static inline int ocfs2_dx_entries_per_leaf(struct super_block *sb)
+{
+	int size;
+
+	size = sb->s_blocksize -
+		offsetof(struct ocfs2_dx_leaf, dl_entries);
+
+	return size / sizeof(struct ocfs2_dx_entry);
+}
+
 static inline u16 ocfs2_local_alloc_size(struct super_block *sb)
 {
 	u16 size;
diff --git a/fs/ocfs2/super.c b/fs/ocfs2/super.c
index 304b63a..ccbb438 100644
--- a/fs/ocfs2/super.c
+++ b/fs/ocfs2/super.c
@@ -1421,6 +1421,12 @@ static int ocfs2_initialize_super(struct super_block *sb,
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
-- 
1.5.4.1
