From: Mark Fasheh <mfasheh@suse.com>
Date: Tue, 17 Mar 2009 13:00:57 -0700
Subject: [Ocfs2-devel] [PATCH 07/32] ocfs2: Store dir index records inline
In-Reply-To: <1237320082-12921-1-git-send-email-mfasheh@suse.com>
References: <1237320082-12921-1-git-send-email-mfasheh@suse.com>
Message-ID: <1237320082-12921-8-git-send-email-mfasheh@suse.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-kernel@vger.kernel.org
Cc: ocfs2-devel@oss.oracle.com, Joel Becker <joel.becker@oracle.com>, Mark Fasheh <mfasheh@suse.com>

Allow us to store a small number of directory index records in the
ocfs2_dx_root_block. This saves us a disk read on small to medium sized
directories (less than about 250 entries). The inline root is automatically
turned into a root block with extents if the directory size increases beyond
it's capacity.

Signed-off-by: Mark Fasheh <mfasheh@suse.com>
Acked-by: Joel Becker <joel.becker@oracle.com>
---
 fs/ocfs2/dir.c      |  572 ++++++++++++++++++++++++++++++++++++++------------
 fs/ocfs2/dir.h      |    2 +
 fs/ocfs2/journal.h  |   10 +
 fs/ocfs2/namei.c    |    4 +-
 fs/ocfs2/ocfs2_fs.h |   28 +++-
 5 files changed, 471 insertions(+), 145 deletions(-)

diff --git a/fs/ocfs2/dir.c b/fs/ocfs2/dir.c
index 0b8c88b..47de649 100644
--- a/fs/ocfs2/dir.c
+++ b/fs/ocfs2/dir.c
@@ -151,6 +151,7 @@ static void ocfs2_init_dir_trailer(struct inode *inode,
 
 void ocfs2_free_dir_lookup_result(struct ocfs2_dir_lookup_result *res)
 {
+	brelse(res->dl_dx_root_bh);
 	brelse(res->dl_leaf_bh);
 	brelse(res->dl_dx_leaf_bh);
 }
@@ -162,6 +163,11 @@ static int ocfs2_dir_indexed(struct inode *inode)
 	return 0;
 }
 
+static inline int ocfs2_dx_root_inline(struct ocfs2_dx_root_block *dx_root)
+{
+	return dx_root->dr_flags & OCFS2_DX_FLAG_INLINE;
+}
+
 /*
  * Hashing code adapted from ext3
  */
@@ -799,13 +805,18 @@ out:
  * Returns the block index, from the start of the cluster which this
  * hash belongs too.
  */
-static unsigned int ocfs2_dx_dir_hash_idx(struct ocfs2_super *osb,
-					  struct ocfs2_dx_hinfo *hinfo)
+static inline unsigned int __ocfs2_dx_dir_hash_idx(struct ocfs2_super *osb,
+						   u32 minor_hash)
 {
-	u32 minor_hash = hinfo->minor_hash;
 	return minor_hash & osb->osb_dx_mask;
 }
 
+static inline unsigned int ocfs2_dx_dir_hash_idx(struct ocfs2_super *osb,
+					  struct ocfs2_dx_hinfo *hinfo)
+{
+	return __ocfs2_dx_dir_hash_idx(osb, hinfo->minor_hash);
+}
+
 static int ocfs2_dx_dir_lookup(struct inode *inode,
 			       struct ocfs2_extent_list *el,
 			       struct ocfs2_dx_hinfo *hinfo,
@@ -855,7 +866,7 @@ out:
 
 static int ocfs2_dx_dir_search(const char *name, int namelen,
 			       struct inode *dir,
-			       struct ocfs2_extent_list *dr_el,
+			       struct ocfs2_dx_root_block *dx_root,
 			       struct ocfs2_dir_lookup_result *res)
 {
 	int ret, i, found;
@@ -866,9 +877,18 @@ static int ocfs2_dx_dir_search(const char *name, int namelen,
 	struct buffer_head *dir_ent_bh = NULL;
 	struct ocfs2_dir_entry *dir_ent = NULL;
 	struct ocfs2_dx_hinfo *hinfo = &res->dl_hinfo;
+	struct ocfs2_extent_list *dr_el;
+	struct ocfs2_dx_entry_list *entry_list;
 
 	ocfs2_dx_dir_name_hash(dir, name, namelen, &res->dl_hinfo);
 
+	if (ocfs2_dx_root_inline(dx_root)) {
+		entry_list = &dx_root->dr_entries;
+		goto search;
+	}
+
+	dr_el = &dx_root->dr_list;
+
 	ret = ocfs2_dx_dir_lookup(dir, dr_el, hinfo, NULL, &phys);
 	if (ret) {
 		mlog_errno(ret);
@@ -893,12 +913,15 @@ static int ocfs2_dx_dir_search(const char *name, int namelen,
 	     le16_to_cpu(dx_leaf->dl_list.de_num_used),
 	     le16_to_cpu(dx_leaf->dl_list.de_count));
 
+	entry_list = &dx_leaf->dl_list;
+
+search:
 	/*
 	 * Empty leaf is legal, so no need to check for that.
 	 */
 	found = 0;
-	for (i = 0; i < le16_to_cpu(dx_leaf->dl_list.de_num_used); i++) {
-		dx_entry = &dx_leaf->dl_list.de_entries[i];
+	for (i = 0; i < le16_to_cpu(entry_list->de_num_used); i++) {
+		dx_entry = &entry_list->de_entries[i];
 
 		if (hinfo->major_hash != le32_to_cpu(dx_entry->dx_major_hash)
 		    || hinfo->minor_hash != le32_to_cpu(dx_entry->dx_minor_hash))
@@ -982,14 +1005,15 @@ static int ocfs2_find_entry_dx(const char *name, int namelen,
 	}
 	dx_root = (struct ocfs2_dx_root_block *) dx_root_bh->b_data;
 
-	ret = ocfs2_dx_dir_search(name, namelen, dir, &dx_root->dr_list,
-				  lookup);
+	ret = ocfs2_dx_dir_search(name, namelen, dir, dx_root, lookup);
 	if (ret) {
 		if (ret != -ENOENT)
 			mlog_errno(ret);
 		goto out;
 	}
 
+	lookup->dl_dx_root_bh = dx_root_bh;
+	dx_root_bh = NULL;
 out:
 	brelse(di_bh);
 	brelse(dx_root_bh);
@@ -1126,64 +1150,88 @@ bail:
 	return status;
 }
 
-static void ocfs2_dx_leaf_remove_entry(struct ocfs2_dx_leaf *dx_leaf, int index)
+static void ocfs2_dx_list_remove_entry(struct ocfs2_dx_entry_list *entry_list,
+				       int index)
 {
-	struct ocfs2_dx_entry_list *dl_list = &dx_leaf->dl_list;
-	int num_used = le16_to_cpu(dl_list->de_num_used);
+	int num_used = le16_to_cpu(entry_list->de_num_used);
 
 	if (num_used == 1 || index == (num_used - 1))
 		goto clear;
 
-	memmove(&dl_list->de_entries[index], &dl_list->de_entries[index + 1],
+	memmove(&entry_list->de_entries[index],
+		&entry_list->de_entries[index + 1],
 		(num_used - index - 1)*sizeof(struct ocfs2_dx_entry));
 clear:
 	num_used--;
-	memset(&dl_list->de_entries[num_used], 0,
+	memset(&entry_list->de_entries[num_used], 0,
 	       sizeof(struct ocfs2_dx_entry));
-	dl_list->de_num_used = cpu_to_le16(num_used);
+	entry_list->de_num_used = cpu_to_le16(num_used);
 }
 
 static int ocfs2_delete_entry_dx(handle_t *handle, struct inode *dir,
 				 struct ocfs2_dir_lookup_result *lookup)
 {
 	int ret, index;
+	struct buffer_head *dx_root_bh = lookup->dl_dx_root_bh;
 	struct buffer_head *leaf_bh = lookup->dl_leaf_bh;
 	struct ocfs2_dx_leaf *dx_leaf;
 	struct ocfs2_dx_entry *dx_entry = lookup->dl_dx_entry;
+	struct ocfs2_dx_root_block *dx_root;
+	struct ocfs2_dx_entry_list *entry_list;
+
+	dx_root = (struct ocfs2_dx_root_block *)dx_root_bh->b_data;
+	if (ocfs2_dx_root_inline(dx_root)) {
+		entry_list = &dx_root->dr_entries;
+	} else {
+		dx_leaf = (struct ocfs2_dx_leaf *) lookup->dl_dx_leaf_bh->b_data;
+		entry_list = &dx_leaf->dl_list;
+	}
 
-	dx_leaf = (struct ocfs2_dx_leaf *) lookup->dl_dx_leaf_bh->b_data;
 	/* Neither of these are a disk corruption - that should have
 	 * been caught by lookup, before we got here. */
-	BUG_ON(le16_to_cpu(dx_leaf->dl_list.de_count) <= 0);
-	BUG_ON(le16_to_cpu(dx_leaf->dl_list.de_num_used) <= 0);
+	BUG_ON(le16_to_cpu(entry_list->de_count) <= 0);
+	BUG_ON(le16_to_cpu(entry_list->de_num_used) <= 0);
 
-	index = (char *)dx_entry - (char *)dx_leaf->dl_list.de_entries;
+	index = (char *)dx_entry - (char *)entry_list->de_entries;
 	index /= sizeof(*dx_entry);
 
-	if (index >= le16_to_cpu(dx_leaf->dl_list.de_num_used)) {
+	if (index >= le16_to_cpu(entry_list->de_num_used)) {
 		mlog(ML_ERROR, "Dir %llu: Bad dx_entry ptr idx %d, (%p, %p)\n",
-		     (unsigned long long)OCFS2_I(dir)->ip_blkno, index, dx_leaf,
-		     dx_entry);
+		     (unsigned long long)OCFS2_I(dir)->ip_blkno, index,
+		     entry_list, dx_entry);
 		return -EIO;
 	}
 
-	mlog(0, "Dir %llu: delete entry at index: %d\n",
-	     (unsigned long long)OCFS2_I(dir)->ip_blkno, index);
-
 	/*
-	 * Add the index leaf into the journal before removing the
-	 * unindexed entry. If we get an error return from
-	 * __ocfs2_delete_entry(), then it hasn't removed the entry
-	 * yet. Likewise, successful return means we *must* remove the
-	 * indexed entry.
+	 * Add the block holding our index into the journal before
+	 * removing the unindexed entry. If we get an error return
+	 * from __ocfs2_delete_entry(), then it hasn't removed the
+	 * entry yet. Likewise, successful return means we *must*
+	 * remove the indexed entry.
+	 *
+	 * We're also careful to journal the root tree block here if
+	 * we're going to be adding to the start of the free list.
 	 */
-	ret = ocfs2_journal_access_dl(handle, dir, lookup->dl_dx_leaf_bh,
-				      OCFS2_JOURNAL_ACCESS_WRITE);
-	if (ret) {
-		mlog_errno(ret);
-		goto out;
+	if (ocfs2_dx_root_inline(dx_root)) {
+		ret = ocfs2_journal_access_dr(handle, dir, dx_root_bh,
+					      OCFS2_JOURNAL_ACCESS_WRITE);
+		if (ret) {
+			mlog_errno(ret);
+			goto out;
+		}
+	} else {
+		ret = ocfs2_journal_access_dl(handle, dir,
+					      lookup->dl_dx_leaf_bh,
+					      OCFS2_JOURNAL_ACCESS_WRITE);
+		if (ret) {
+			mlog_errno(ret);
+			goto out;
+		}
 	}
 
+	mlog(0, "Dir %llu: delete entry at index: %d\n",
+	     (unsigned long long)OCFS2_I(dir)->ip_blkno, index);
+
 	ret = __ocfs2_delete_entry(handle, dir, lookup->dl_entry,
 				   leaf_bh, leaf_bh->b_data, leaf_bh->b_size);
 	if (ret) {
@@ -1191,9 +1239,12 @@ static int ocfs2_delete_entry_dx(handle_t *handle, struct inode *dir,
 		goto out;
 	}
 
-	ocfs2_dx_leaf_remove_entry(dx_leaf, index);
+	ocfs2_dx_list_remove_entry(entry_list, index);
 
-	ocfs2_journal_dirty(handle, lookup->dl_dx_leaf_bh);
+	if (ocfs2_dx_root_inline(dx_root))
+		ocfs2_journal_dirty(handle, dx_root_bh);
+	else
+		ocfs2_journal_dirty(handle, lookup->dl_dx_leaf_bh);
 
 out:
 	return ret;
@@ -1290,13 +1341,30 @@ static void ocfs2_dx_dir_leaf_insert_tail(struct ocfs2_dx_leaf *dx_leaf,
 	le16_add_cpu(&dx_leaf->dl_list.de_num_used, 1);
 }
 
+static void ocfs2_dx_entry_list_insert(struct ocfs2_dx_entry_list *entry_list,
+				       struct ocfs2_dx_hinfo *hinfo,
+				       u64 dirent_blk)
+{
+	int i;
+	struct ocfs2_dx_entry *dx_entry;
+
+	i = le16_to_cpu(entry_list->de_num_used);
+	dx_entry = &entry_list->de_entries[i];
+
+	memset(dx_entry, 0, sizeof(*dx_entry));
+	dx_entry->dx_major_hash = cpu_to_le32(hinfo->major_hash);
+	dx_entry->dx_minor_hash = cpu_to_le32(hinfo->minor_hash);
+	dx_entry->dx_dirent_blk = cpu_to_le64(dirent_blk);
+
+	le16_add_cpu(&entry_list->de_num_used, 1);
+}
+
 static int __ocfs2_dx_dir_leaf_insert(struct inode *dir, handle_t *handle,
 				      struct ocfs2_dx_hinfo *hinfo,
 				      u64 dirent_blk,
 				      struct buffer_head *dx_leaf_bh)
 {
-	int ret, i;
-	struct ocfs2_dx_entry *dx_entry;
+	int ret;
 	struct ocfs2_dx_leaf *dx_leaf;
 
 	ret = ocfs2_journal_access_dl(handle, dir, dx_leaf_bh,
@@ -1307,25 +1375,48 @@ static int __ocfs2_dx_dir_leaf_insert(struct inode *dir, handle_t *handle,
 	}
 
 	dx_leaf = (struct ocfs2_dx_leaf *)dx_leaf_bh->b_data;
-	i = le16_to_cpu(dx_leaf->dl_list.de_num_used);
-	dx_entry = &dx_leaf->dl_list.de_entries[i];
+	ocfs2_dx_entry_list_insert(&dx_leaf->dl_list, hinfo, dirent_blk);
+	ocfs2_journal_dirty(handle, dx_leaf_bh);
 
-	memset(dx_entry, 0, sizeof(*dx_entry));
-	dx_entry->dx_major_hash = cpu_to_le32(hinfo->major_hash);
-	dx_entry->dx_minor_hash = cpu_to_le32(hinfo->minor_hash);
-	dx_entry->dx_dirent_blk = cpu_to_le64(dirent_blk);
+out:
+	return ret;
+}
 
-	le16_add_cpu(&dx_leaf->dl_list.de_num_used, 1);
+static int ocfs2_dx_inline_root_insert(struct inode *dir, handle_t *handle,
+				       struct ocfs2_dx_hinfo *hinfo,
+				       u64 dirent_blk,
+				       struct buffer_head *dx_root_bh)
+{
+	int ret;
+	struct ocfs2_dx_root_block *dx_root;
 
-	ocfs2_journal_dirty(handle, dx_leaf_bh);
+	ret = ocfs2_journal_access_dr(handle, dir, dx_root_bh,
+				      OCFS2_JOURNAL_ACCESS_WRITE);
+	if (ret) {
+		mlog_errno(ret);
+		goto out;
+	}
+
+	dx_root = (struct ocfs2_dx_root_block *)dx_root_bh->b_data;
+	ocfs2_dx_entry_list_insert(&dx_root->dr_entries, hinfo, dirent_blk);
+	ocfs2_journal_dirty(handle, dx_root_bh);
 
 out:
 	return ret;
 }
 
-static int ocfs2_dx_dir_leaf_insert(struct inode *dir, handle_t *handle,
-				    struct ocfs2_dir_lookup_result *lookup)
+static int ocfs2_dx_dir_insert(struct inode *dir, handle_t *handle,
+			       struct ocfs2_dir_lookup_result *lookup)
 {
+	struct ocfs2_dx_root_block *dx_root;
+
+	dx_root = (struct ocfs2_dx_root_block *)lookup->dl_dx_root_bh->b_data;
+	if (ocfs2_dx_root_inline(dx_root))
+		return ocfs2_dx_inline_root_insert(dir, handle,
+						   &lookup->dl_hinfo,
+						   lookup->dl_leaf_bh->b_blocknr,
+						   lookup->dl_dx_root_bh);
+
 	return __ocfs2_dx_dir_leaf_insert(dir, handle, &lookup->dl_hinfo,
 					  lookup->dl_leaf_bh->b_blocknr,
 					  lookup->dl_dx_leaf_bh);
@@ -1409,11 +1500,12 @@ int __ocfs2_add_entry(handle_t *handle,
 			else {
 				status = ocfs2_journal_access_db(handle, dir,
 								 insert_bh,
-								 OCFS2_JOURNAL_ACCESS_WRITE);
+					      OCFS2_JOURNAL_ACCESS_WRITE);
+
 				if (ocfs2_dir_indexed(dir)) {
-					status = ocfs2_dx_dir_leaf_insert(dir,
-									handle,
-									lookup);
+					status = ocfs2_dx_dir_insert(dir,
+								handle,
+								lookup);
 					if (status) {
 						mlog_errno(status);
 						goto bail;
@@ -2019,6 +2111,7 @@ static int ocfs2_dx_dir_attach_index(struct ocfs2_super *osb,
 				     handle_t *handle, struct inode *dir,
 				     struct buffer_head *di_bh,
 				     struct ocfs2_alloc_context *meta_ac,
+				     int dx_inline,
 				     struct buffer_head **ret_dx_root_bh)
 {
 	int ret;
@@ -2062,8 +2155,15 @@ static int ocfs2_dx_dir_attach_index(struct ocfs2_super *osb,
 	dx_root->dr_fs_generation = cpu_to_le32(osb->fs_generation);
 	dx_root->dr_blkno = cpu_to_le64(dr_blkno);
 	dx_root->dr_dir_blkno = cpu_to_le64(OCFS2_I(dir)->ip_blkno);
-	dx_root->dr_list.l_count =
-		cpu_to_le16(ocfs2_extent_recs_per_dx_root(osb->sb));
+
+	if (dx_inline) {
+		dx_root->dr_flags |= OCFS2_DX_FLAG_INLINE;
+		dx_root->dr_entries.de_count =
+			cpu_to_le16(ocfs2_dx_entries_per_root(osb->sb));
+	} else {
+		dx_root->dr_list.l_count =
+			cpu_to_le16(ocfs2_extent_recs_per_dx_root(osb->sb));
+	}
 
 	ret = ocfs2_journal_dirty(handle, dx_root_bh);
 	if (ret)
@@ -2236,20 +2336,12 @@ static int ocfs2_fill_new_dir_dx(struct ocfs2_super *osb,
 				 struct ocfs2_alloc_context *data_ac,
 				 struct ocfs2_alloc_context *meta_ac)
 {
-	int ret, num_dx_leaves, i;
+	int ret;
 	struct buffer_head *leaf_bh = NULL;
 	struct buffer_head *dx_root_bh = NULL;
-	struct buffer_head **dx_leaves = NULL;
-	struct ocfs2_extent_tree et;
 	struct ocfs2_dx_hinfo hinfo;
-	u64 insert_blkno;
-
-	dx_leaves = ocfs2_dx_dir_kmalloc_leaves(osb->sb, &num_dx_leaves);
-	if (!dx_leaves) {
-		ret = -ENOMEM;
-		mlog_errno(ret);
-		goto out;
-	}
+	struct ocfs2_dx_root_block *dx_root;
+	struct ocfs2_dx_entry_list *entry_list;
 
 	/*
 	 * Our strategy is to create the directory as though it were
@@ -2258,7 +2350,8 @@ static int ocfs2_fill_new_dir_dx(struct ocfs2_super *osb,
 	 * very well known quantity.
 	 *
 	 * Essentially, we have two dirents ("." and ".."), in the 1st
-	 * block which need indexing.
+	 * block which need indexing. These are easily inserted into
+	 * the index block.
 	 */
 
 	ret = ocfs2_fill_new_dir_el(osb, handle, parent, inode, di_bh,
@@ -2268,61 +2361,22 @@ static int ocfs2_fill_new_dir_dx(struct ocfs2_super *osb,
 		goto out;
 	}
 
-	/*
-	 * Allocate and format the index leaf first, before attaching
-	 * the index root. That way we're sure that the main bitmap
-	 * won't -enospc on us with a half-created dir index.
-	 *
-	 * The meta data allocation for our index block will not
-	 * -enospc on us unless there is a disk corruption.
-	 */
-
-	ret = __ocfs2_dx_dir_new_cluster(inode, 0, handle, data_ac, dx_leaves,
-					 num_dx_leaves, &insert_blkno);
+	ret = ocfs2_dx_dir_attach_index(osb, handle, inode, di_bh,
+					meta_ac, 1, &dx_root_bh);
 	if (ret) {
 		mlog_errno(ret);
 		goto out;
 	}
+	dx_root = (struct ocfs2_dx_root_block *)dx_root_bh->b_data;
+	entry_list = &dx_root->dr_entries;
 
-	ocfs2_dx_dir_name_hash(inode, ".", 1, &hinfo);
-	i = ocfs2_dx_dir_hash_idx(osb, &hinfo);
-	ret = __ocfs2_dx_dir_leaf_insert(inode, handle, &hinfo,
-					 leaf_bh->b_blocknr, dx_leaves[i]);
-	if (ret) {
-		mlog_errno(ret);
-		goto out;
-	}
+	/* Buffer has been journaled for us by ocfs2_dx_dir_attach_index */
+	ocfs2_dx_entry_list_insert(entry_list, &hinfo, leaf_bh->b_blocknr);
 
 	ocfs2_dx_dir_name_hash(inode, "..", 2, &hinfo);
-	i = ocfs2_dx_dir_hash_idx(osb, &hinfo);
-	ret = __ocfs2_dx_dir_leaf_insert(inode, handle, &hinfo,
-					 leaf_bh->b_blocknr, dx_leaves[i]);
-	if (ret) {
-		mlog_errno(ret);
-		goto out;
-	}
-
-	ret = ocfs2_dx_dir_attach_index(osb, handle, inode, di_bh, meta_ac,
-					&dx_root_bh);
-	if (ret) {
-		mlog_errno(ret);
-		goto out;
-	}
-
-	/* This should never fail considering we start with an empty
-	 * dx_root. */
-	ocfs2_init_dx_root_extent_tree(&et, inode, dx_root_bh);
-	ret = ocfs2_insert_extent(osb, handle, inode, &et, 0,
-				  insert_blkno, 1, 0, NULL);
-	if (ret)
-		mlog_errno(ret);
+	ocfs2_dx_entry_list_insert(entry_list, &hinfo, leaf_bh->b_blocknr);
 
 out:
-	if (dx_leaves) {
-		for (i = 0; i < num_dx_leaves; i++)
-			brelse(dx_leaves[i]);
-		kfree(dx_leaves);
-	}
 	brelse(dx_root_bh);
 	brelse(leaf_bh);
 	return ret;
@@ -2392,6 +2446,74 @@ inc:
 out:
 	return ret;
 }
+ /*
+ * XXX: This expects dx_root_bh to already be part of the transaction.
+ */
+static void ocfs2_dx_dir_index_root_block(struct inode *dir,
+					 struct buffer_head *dx_root_bh,
+					 struct buffer_head *dirent_bh)
+{
+	char *de_buf, *limit;
+	struct ocfs2_dx_root_block *dx_root;
+	struct ocfs2_dir_entry *de;
+	struct ocfs2_dx_hinfo hinfo;
+	u64 dirent_blk = dirent_bh->b_blocknr;
+
+	dx_root = (struct ocfs2_dx_root_block *)dx_root_bh->b_data;
+
+	de_buf = dirent_bh->b_data;
+	limit = de_buf + dir->i_sb->s_blocksize;
+
+	while (de_buf < limit) {
+		de = (struct ocfs2_dir_entry *)de_buf;
+
+		if (!de->name_len || !de->inode)
+			goto inc;
+
+		ocfs2_dx_dir_name_hash(dir, de->name, de->name_len, &hinfo);
+
+		mlog(0,
+		     "dir: %llu, major: 0x%x minor: 0x%x, index: %u, name: %.*s\n",
+		     (unsigned long long)dir->i_ino, hinfo.major_hash,
+		     hinfo.minor_hash,
+		     le16_to_cpu(dx_root->dr_entries.de_num_used),
+		     de->name_len, de->name);
+
+		ocfs2_dx_entry_list_insert(&dx_root->dr_entries, &hinfo,
+					   dirent_blk);
+inc:
+		de_buf += le16_to_cpu(de->rec_len);
+	}
+}
+
+/*
+ * Count the number of inline directory entries in di_bh and compare
+ * them against the number of entries we can hold in an inline dx root
+ * block.
+ */
+static int ocfs2_new_dx_should_be_inline(struct inode *dir,
+					 struct buffer_head *di_bh)
+{
+	int dirent_count = 0;
+	char *de_buf, *limit;
+	struct ocfs2_dir_entry *de;
+	struct ocfs2_dinode *di = (struct ocfs2_dinode *)di_bh->b_data;
+
+	de_buf = di->id2.i_data.id_data;
+	limit = de_buf + i_size_read(dir);
+
+	while (de_buf < limit) {
+		de = (struct ocfs2_dir_entry *)de_buf;
+
+		if (de->name_len && de->inode)
+			dirent_count++;
+
+		de_buf += le16_to_cpu(de->rec_len);
+	}
+
+	/* We are careful to leave room for one extra record. */
+	return dirent_count < ocfs2_dx_entries_per_root(dir->i_sb);
+}
 
 /*
  * Expand rec_len of the rightmost dirent in a directory block so that it
@@ -2442,7 +2564,7 @@ static int ocfs2_expand_inline_dir(struct inode *dir, struct buffer_head *di_bh,
 {
 	u32 alloc, dx_alloc, bit_off, len;
 	struct super_block *sb = dir->i_sb;
-	int ret, i, num_dx_leaves = 0,
+	int ret, i, num_dx_leaves = 0, dx_inline = 0,
 		credits = ocfs2_inline_to_extents_credits(sb);
 	u64 dx_insert_blkno, blkno,
 		bytes = blocks_wanted << sb->s_blocksize_bits;
@@ -2465,15 +2587,19 @@ static int ocfs2_expand_inline_dir(struct inode *dir, struct buffer_head *di_bh,
 	dx_alloc = 0;
 
 	if (ocfs2_supports_indexed_dirs(osb)) {
-		/* Add one more cluster for an index leaf */
-		dx_alloc++;
 		credits += ocfs2_add_dir_index_credits(sb);
 
-		dx_leaves = ocfs2_dx_dir_kmalloc_leaves(sb, &num_dx_leaves);
-		if (!dx_leaves) {
-			ret = -ENOMEM;
-			mlog_errno(ret);
-			goto out;
+		dx_inline = ocfs2_new_dx_should_be_inline(dir, di_bh);
+		if (!dx_inline) {
+			/* Add one more cluster for an index leaf */
+			dx_alloc++;
+			dx_leaves = ocfs2_dx_dir_kmalloc_leaves(sb,
+								&num_dx_leaves);
+			if (!dx_leaves) {
+				ret = -ENOMEM;
+				mlog_errno(ret);
+				goto out;
+			}
 		}
 
 		/* This gets us the dx_root */
@@ -2524,7 +2650,7 @@ static int ocfs2_expand_inline_dir(struct inode *dir, struct buffer_head *di_bh,
 	}
 	did_quota = 1;
 
-	if (ocfs2_supports_indexed_dirs(osb)) {
+	if (ocfs2_supports_indexed_dirs(osb) && !dx_inline) {
 		/*
 		 * Allocate our index cluster first, to maximize the
 		 * possibility that unindexed leaves grow
@@ -2587,7 +2713,12 @@ static int ocfs2_expand_inline_dir(struct inode *dir, struct buffer_head *di_bh,
 		goto out_commit;
 	}
 
-	if (ocfs2_supports_indexed_dirs(osb)) {
+	if (ocfs2_supports_indexed_dirs(osb) && !dx_inline) {
+		/*
+		 * Dx dirs with an external cluster need to do this up
+		 * front. Inline dx root's get handled later, after
+		 * we've allocated our root block.
+		 */
 		ret = ocfs2_dx_dir_index_block(dir, handle, dx_leaves,
 					       num_dx_leaves, dirdata_bh);
 		if (ret) {
@@ -2650,17 +2781,23 @@ static int ocfs2_expand_inline_dir(struct inode *dir, struct buffer_head *di_bh,
 
 	if (ocfs2_supports_indexed_dirs(osb)) {
 		ret = ocfs2_dx_dir_attach_index(osb, handle, dir, di_bh,
-						meta_ac, &dx_root_bh);
+						meta_ac, dx_inline,
+						&dx_root_bh);
 		if (ret) {
 			mlog_errno(ret);
 			goto out_commit;
 		}
 
-		ocfs2_init_dx_root_extent_tree(&dx_et, dir, dx_root_bh);
-		ret = ocfs2_insert_extent(osb, handle, dir, &dx_et, 0,
-					  dx_insert_blkno, 1, 0, NULL);
-		if (ret)
-			mlog_errno(ret);
+		if (dx_inline) {
+			ocfs2_dx_dir_index_root_block(dir, dx_root_bh,
+						      dirdata_bh);
+		} else {
+			ocfs2_init_dx_root_extent_tree(&dx_et, dir, dx_root_bh);
+			ret = ocfs2_insert_extent(osb, handle, dir, &dx_et, 0,
+						  dx_insert_blkno, 1, 0, NULL);
+			if (ret)
+				mlog_errno(ret);
+		}
 	}
 
 	/*
@@ -2690,14 +2827,18 @@ static int ocfs2_expand_inline_dir(struct inode *dir, struct buffer_head *di_bh,
 	if (ocfs2_supports_indexed_dirs(osb)) {
 		unsigned int off;
 
-		/*
-		 * We need to return the correct block within the
-		 * cluster which should hold our entry.
-		 */
-		off = ocfs2_dx_dir_hash_idx(OCFS2_SB(dir->i_sb),
-					    &lookup->dl_hinfo);
-		get_bh(dx_leaves[off]);
-		lookup->dl_dx_leaf_bh = dx_leaves[off];
+		if (!dx_inline) {
+			/*
+			 * We need to return the correct block within the
+			 * cluster which should hold our entry.
+			 */
+			off = ocfs2_dx_dir_hash_idx(OCFS2_SB(dir->i_sb),
+						    &lookup->dl_hinfo);
+			get_bh(dx_leaves[off]);
+			lookup->dl_dx_leaf_bh = dx_leaves[off];
+		}
+		lookup->dl_dx_root_bh = dx_root_bh;
+		dx_root_bh = NULL;
 	}
 
 out_commit:
@@ -3506,6 +3647,138 @@ out:
 	return ret;
 }
 
+static int ocfs2_expand_inline_dx_root(struct inode *dir,
+				       struct buffer_head *dx_root_bh)
+{
+	int ret, num_dx_leaves, i, j, did_quota = 0;
+	struct buffer_head **dx_leaves = NULL;
+	struct ocfs2_extent_tree et;
+	u64 insert_blkno;
+	struct ocfs2_alloc_context *data_ac = NULL;
+	struct ocfs2_super *osb = OCFS2_SB(dir->i_sb);
+	handle_t *handle = NULL;
+	struct ocfs2_dx_root_block *dx_root;
+	struct ocfs2_dx_entry_list *entry_list;
+	struct ocfs2_dx_entry *dx_entry;
+	struct ocfs2_dx_leaf *target_leaf;
+
+	ret = ocfs2_reserve_clusters(osb, 1, &data_ac);
+	if (ret) {
+		mlog_errno(ret);
+		goto out;
+	}
+
+	dx_leaves = ocfs2_dx_dir_kmalloc_leaves(osb->sb, &num_dx_leaves);
+	if (!dx_leaves) {
+		ret = -ENOMEM;
+		mlog_errno(ret);
+		goto out;
+	}
+
+	handle = ocfs2_start_trans(osb, ocfs2_calc_dxi_expand_credits(osb->sb));
+	if (IS_ERR(handle)) {
+		ret = PTR_ERR(handle);
+		mlog_errno(ret);
+		goto out;
+	}
+
+	if (vfs_dq_alloc_space_nodirty(dir,
+				       ocfs2_clusters_to_bytes(osb->sb, 1))) {
+		ret = -EDQUOT;
+		goto out_commit;
+	}
+	did_quota = 1;
+
+	/*
+	 * We do this up front, before the allocation, so that a
+	 * failure to add the dx_root_bh to the journal won't result
+	 * us losing clusters.
+	 */
+	ret = ocfs2_journal_access_dr(handle, dir, dx_root_bh,
+				      OCFS2_JOURNAL_ACCESS_WRITE);
+	if (ret) {
+		mlog_errno(ret);
+		goto out_commit;
+	}
+
+	ret = __ocfs2_dx_dir_new_cluster(dir, 0, handle, data_ac, dx_leaves,
+					 num_dx_leaves, &insert_blkno);
+	if (ret) {
+		mlog_errno(ret);
+		goto out_commit;
+	}
+
+	/*
+	 * Transfer the entries from our dx_root into the appropriate
+	 * block
+	 */
+	dx_root = (struct ocfs2_dx_root_block *) dx_root_bh->b_data;
+	entry_list = &dx_root->dr_entries;
+
+	for (i = 0; i < le16_to_cpu(entry_list->de_num_used); i++) {
+		dx_entry = &entry_list->de_entries[i];
+
+		j = __ocfs2_dx_dir_hash_idx(osb,
+					    le32_to_cpu(dx_entry->dx_minor_hash));
+		target_leaf = (struct ocfs2_dx_leaf *)dx_leaves[j]->b_data;
+
+		ocfs2_dx_dir_leaf_insert_tail(target_leaf, dx_entry);
+
+		/* Each leaf has been passed to the journal already
+		 * via __ocfs2_dx_dir_new_cluster() */
+	}
+
+	dx_root->dr_flags &= ~OCFS2_DX_FLAG_INLINE;
+	memset(&dx_root->dr_list, 0, osb->sb->s_blocksize -
+	       offsetof(struct ocfs2_dx_root_block, dr_list));
+	dx_root->dr_list.l_count =
+		cpu_to_le16(ocfs2_extent_recs_per_dx_root(osb->sb));
+
+	/* This should never fail considering we start with an empty
+	 * dx_root. */
+	ocfs2_init_dx_root_extent_tree(&et, dir, dx_root_bh);
+	ret = ocfs2_insert_extent(osb, handle, dir, &et, 0,
+				  insert_blkno, 1, 0, NULL);
+	if (ret)
+		mlog_errno(ret);
+	did_quota = 0;
+
+	ocfs2_journal_dirty(handle, dx_root_bh);
+
+out_commit:
+	if (ret < 0 && did_quota)
+		vfs_dq_free_space_nodirty(dir,
+					  ocfs2_clusters_to_bytes(dir->i_sb, 1));
+
+	ocfs2_commit_trans(osb, handle);
+
+out:
+	if (data_ac)
+		ocfs2_free_alloc_context(data_ac);
+
+	if (dx_leaves) {
+		for (i = 0; i < num_dx_leaves; i++)
+			brelse(dx_leaves[i]);
+		kfree(dx_leaves);
+	}
+	return ret;
+}
+
+static int ocfs2_inline_dx_has_space(struct buffer_head *dx_root_bh)
+{
+	struct ocfs2_dx_root_block *dx_root;
+	struct ocfs2_dx_entry_list *entry_list;
+
+	dx_root = (struct ocfs2_dx_root_block *) dx_root_bh->b_data;
+	entry_list = &dx_root->dr_entries;
+
+	if (le16_to_cpu(entry_list->de_num_used) >=
+	    le16_to_cpu(entry_list->de_count))
+		return -ENOSPC;
+
+	return 0;
+}
+
 static int ocfs2_find_dir_space_dx(struct ocfs2_super *osb, struct inode *dir,
 				   struct buffer_head *di_bh, const char *name,
 				   int namelen,
@@ -3527,6 +3800,23 @@ static int ocfs2_find_dir_space_dx(struct ocfs2_super *osb, struct inode *dir,
 	}
 
 	dx_root = (struct ocfs2_dx_root_block *)dx_root_bh->b_data;
+	if (ocfs2_dx_root_inline(dx_root)) {
+		ret = ocfs2_inline_dx_has_space(dx_root_bh);
+
+		if (ret == 0)
+			goto search_el;
+
+		/*
+		 * We ran out of room in the root block. Expand it to
+		 * an extent, then allow ocfs2_find_dir_space_dx to do
+		 * the rest.
+		 */
+		ret = ocfs2_expand_inline_dx_root(dir, dx_root_bh);
+		if (ret) {
+			mlog_errno(ret);
+			goto out;
+		}
+	}
 
 restart_search:
 	ret = ocfs2_dx_dir_lookup(dir, &dx_root->dr_list, &lookup->dl_hinfo,
@@ -3578,8 +3868,11 @@ restart_search:
 		goto restart_search;
 	}
 
+search_el:
 	lookup->dl_dx_leaf_bh = dx_leaf_bh;
 	dx_leaf_bh = NULL;
+	lookup->dl_dx_root_bh = dx_root_bh;
+	dx_root_bh = NULL;
 
 out:
 	brelse(dx_leaf_bh);
@@ -3774,10 +4067,12 @@ int ocfs2_dx_dir_truncate(struct inode *dir, struct buffer_head *di_bh)
 		mlog_errno(ret);
 		goto out;
 	}
+	dx_root = (struct ocfs2_dx_root_block *)dx_root_bh->b_data;
 
-	ocfs2_init_dx_root_extent_tree(&et, dir, dx_root_bh);
+	if (ocfs2_dx_root_inline(dx_root))
+		goto remove_index;
 
-	dx_root = (struct ocfs2_dx_root_block *)dx_root_bh->b_data;
+	ocfs2_init_dx_root_extent_tree(&et, dir, dx_root_bh);
 
 	/* XXX: What if dr_clusters is too large? */
 	while (le32_to_cpu(dx_root->dr_clusters)) {
@@ -3803,6 +4098,7 @@ int ocfs2_dx_dir_truncate(struct inode *dir, struct buffer_head *di_bh)
 		major_hash = cpos - 1;
 	}
 
+remove_index:
 	ret = ocfs2_dx_dir_remove_index(dir, di_bh, dx_root_bh);
 	if (ret) {
 		mlog_errno(ret);
diff --git a/fs/ocfs2/dir.h b/fs/ocfs2/dir.h
index d273aae..07b0416 100644
--- a/fs/ocfs2/dir.h
+++ b/fs/ocfs2/dir.h
@@ -37,6 +37,8 @@ struct ocfs2_dir_lookup_result {
 	struct ocfs2_dir_entry		*dl_entry;	/* Target dirent in
 							 * unindexed leaf */
 
+	struct buffer_head		*dl_dx_root_bh;	/* Root of indexed
+							 * tree */
 	struct buffer_head		*dl_dx_leaf_bh;	/* Indexed leaf block */
 	struct ocfs2_dx_entry		*dl_dx_entry;	/* Target dx_entry in
 							 * indexed leaf */
diff --git a/fs/ocfs2/journal.h b/fs/ocfs2/journal.h
index 4939c04..5585dde 100644
--- a/fs/ocfs2/journal.h
+++ b/fs/ocfs2/journal.h
@@ -458,6 +458,16 @@ static inline int ocfs2_rename_credits(struct super_block *sb)
 #define OCFS2_DX_ROOT_REMOVE_CREDITS (OCFS2_INODE_UPDATE_CREDITS +	\
 				      OCFS2_SUBALLOC_FREE)
 
+static inline int ocfs2_calc_dxi_expand_credits(struct super_block *sb)
+{
+	int credits = 1 + OCFS2_SUBALLOC_ALLOC;
+
+	credits += ocfs2_clusters_to_blocks(sb, 1);
+	credits += ocfs2_quota_trans_credits(sb);
+
+	return credits;
+}
+
 /*
  * Please note that the caller must make sure that root_el is the root
  * of extent tree. So for an inode, it should be &fe->id2.i_list. Otherwise
diff --git a/fs/ocfs2/namei.c b/fs/ocfs2/namei.c
index 0c55071..f911edc 100644
--- a/fs/ocfs2/namei.c
+++ b/fs/ocfs2/namei.c
@@ -321,10 +321,8 @@ static int ocfs2_mknod(struct inode *dir,
 		want_clusters += 1;
 
 		/* Dir indexing requires extra space as well */
-		if (ocfs2_supports_indexed_dirs(osb)) {
-			want_clusters++;
+		if (ocfs2_supports_indexed_dirs(osb))
 			want_meta++;
-		}
 	}
 
 	status = ocfs2_reserve_new_metadata_blocks(osb, want_meta, &meta_ac);
diff --git a/fs/ocfs2/ocfs2_fs.h b/fs/ocfs2/ocfs2_fs.h
index 036eb03..1d1c54e 100644
--- a/fs/ocfs2/ocfs2_fs.h
+++ b/fs/ocfs2/ocfs2_fs.h
@@ -815,6 +815,8 @@ struct ocfs2_dx_entry_list {
 							 * length de_num_used */
 };
 
+#define OCFS2_DX_FLAG_INLINE	0x01
+
 /*
  * A directory indexing block. Each indexed directory has one of these,
  * pointed to by ocfs2_dinode.
@@ -835,13 +837,21 @@ struct ocfs2_dx_root_block {
 						 * extent block */
 	__le32		dr_clusters;		/* Clusters allocated
 						 * to the indexed tree. */
-	__le32		dr_reserved1;
+	__u8		dr_flags;		/* OCFS2_DX_FLAG_* flags */
+	__u8		dr_reserved0;
+	__le16		dr_reserved1;
 	__le64		dr_dir_blkno;		/* Pointer to parent inode */
 	__le64		dr_reserved2;
 	__le64		dr_reserved3[16];
-	struct ocfs2_extent_list	dr_list; /* Keep this aligned to 128
-						  * bits for maximum space
-						  * efficiency. */
+	union {
+		struct ocfs2_extent_list dr_list; /* Keep this aligned to 128
+						   * bits for maximum space
+						   * efficiency. */
+		struct ocfs2_dx_entry_list dr_entries; /* In-root-block list of
+							* entries. We grow out
+							* to extents if this
+							* gets too big. */
+	};
 };
 
 /*
@@ -1228,6 +1238,16 @@ static inline int ocfs2_dx_entries_per_leaf(struct super_block *sb)
 	return size / sizeof(struct ocfs2_dx_entry);
 }
 
+static inline int ocfs2_dx_entries_per_root(struct super_block *sb)
+{
+	int size;
+
+	size = sb->s_blocksize -
+		offsetof(struct ocfs2_dx_root_block, dr_entries.de_entries);
+
+	return size / sizeof(struct ocfs2_dx_entry);
+}
+
 static inline u16 ocfs2_local_alloc_size(struct super_block *sb)
 {
 	u16 size;
-- 
1.5.6
