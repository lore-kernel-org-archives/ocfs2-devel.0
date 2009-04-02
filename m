From: Tao Ma <tao.ma@oracle.com>
Date: Fri,  3 Apr 2009 07:45:40 +0800
Subject: [Ocfs2-devel] [PATCH 01/42] ocfs2: Reused freed extent block in
	b-tree operation.
In-Reply-To: <49D5CAC2.4010201@oracle.com>
References: <49D5CAC2.4010201@oracle.com>
Message-ID: <1238715981-21488-1-git-send-email-tao.ma@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

In some b-tree operations we may have the chance that we haven't
reserved any metadata at the beginning because we think we don't
need. While the 1st operation free a extent block while the 2nd
operation need one. Our current code can't handle this. So this
patch try to re-use the freed extent block so that we can pass
the scenario above. For more details about the bug, see

[RFC] metadata alloc fix in machines which has PAGE_SIZE > CLUSTER_SIZE
http://oss.oracle.com/pipermail/ocfs2-devel/2009-March/004185.html.

Signed-off-by: Tao Ma <tao.ma@oracle.com>
---
 fs/ocfs2/alloc.c    |   49 +++++++++++++++++++++++++++++++++++++++++++++++--
 fs/ocfs2/alloc.h    |    7 +++++++
 fs/ocfs2/suballoc.c |   23 +++++++++++++++++++++++
 fs/ocfs2/suballoc.h |    3 +++
 fs/ocfs2/xattr.c    |    6 +++---
 5 files changed, 83 insertions(+), 5 deletions(-)

diff --git a/fs/ocfs2/alloc.c b/fs/ocfs2/alloc.c
index cb23d12..c63a7c5 100644
--- a/fs/ocfs2/alloc.c
+++ b/fs/ocfs2/alloc.c
@@ -893,7 +893,7 @@ static int ocfs2_create_new_meta_bhs(handle_t *handle,
 				     struct buffer_head *bhs[])
 {
 	int count, status, i;
-	u16 suballoc_bit_start;
+	u16 slot, suballoc_bit_start;
 	u32 num_got;
 	u64 first_blkno;
 	struct ocfs2_super *osb =
@@ -908,6 +908,7 @@ static int ocfs2_create_new_meta_bhs(handle_t *handle,
 					      handle,
 					      meta_ac,
 					      wanted - count,
+					      &slot,
 					      &suballoc_bit_start,
 					      &num_got,
 					      &first_blkno);
@@ -939,7 +940,7 @@ static int ocfs2_create_new_meta_bhs(handle_t *handle,
 			strcpy(eb->h_signature, OCFS2_EXTENT_BLOCK_SIGNATURE);
 			eb->h_blkno = cpu_to_le64(first_blkno);
 			eb->h_fs_generation = cpu_to_le32(osb->fs_generation);
-			eb->h_suballoc_slot = cpu_to_le16(osb->slot_num);
+			eb->h_suballoc_slot = cpu_to_le16(slot);
 			eb->h_suballoc_bit = cpu_to_le16(suballoc_bit_start);
 			eb->h_list.l_count =
 				cpu_to_le16(ocfs2_extent_recs_per_eb(osb->sb));
@@ -4878,6 +4879,7 @@ static int __ocfs2_mark_extent_written(handle_t *handle,
 	struct ocfs2_extent_rec *rec = &el->l_recs[split_index];
 	struct ocfs2_merge_ctxt ctxt;
 	struct ocfs2_extent_list *rightmost_el;
+	struct ocfs2_alloc_context local_meta_ac;
 
 	if (!(rec->e_flags & OCFS2_EXT_UNWRITTEN)) {
 		ret = -EIO;
@@ -4930,6 +4932,17 @@ static int __ocfs2_mark_extent_written(handle_t *handle,
 	     split_index, ctxt.c_contig_type, ctxt.c_has_empty_extent,
 	     ctxt.c_split_covers_rec);
 
+	/*
+	 * init dealloc in meta_ac here so that we can reuse the freed extent
+	 * block in case.
+	 * If the caller doesn't give us a meta_ac, we just fake one and add
+	 * dealloc in it.
+	 */
+	if (!meta_ac) {
+		memset(&local_meta_ac, 0, sizeof(local_meta_ac));
+		meta_ac = &local_meta_ac;
+	}
+	meta_ac->dealloc = dealloc;
 	if (ctxt.c_contig_type == CONTIG_NONE) {
 		if (ctxt.c_split_covers_rec)
 			ret = ocfs2_replace_extent_rec(handle, et, path, el,
@@ -6140,6 +6153,38 @@ int ocfs2_cache_cluster_dealloc(struct ocfs2_cached_dealloc_ctxt *ctxt,
 	return ret;
 }
 
+int ocfs2_claim_bit_from_dealloc(struct ocfs2_cached_dealloc_ctxt *ctxt,
+				 u16 *slot, u16 *suballoc_bit,
+				 unsigned int *num_bits, u64 *blkno)
+{
+	struct ocfs2_per_slot_free_list *fl = ctxt->c_first_suballocator;
+	struct ocfs2_cached_block_free *tmp;
+
+	if (!fl || !fl->f_first)
+		return -ENOMEM;
+
+	tmp = fl->f_first->free_next;
+
+	*slot = fl->f_slot;
+	*suballoc_bit = fl->f_first->free_bit;
+	*blkno = fl->f_first->free_blk;
+	*num_bits = 1;
+
+	mlog(0, "claim blkno %llu suballoc_bit %u, slot %u\n",
+	     (unsigned long long)*blkno, *suballoc_bit, *slot);
+
+	kfree(fl->f_first);
+	fl->f_first = tmp;
+
+	/* Free the suballocator if there is none. */
+	if (!fl->f_first) {
+		ctxt->c_first_suballocator = fl->f_next_suballocator;
+		kfree(fl);
+	}
+
+	return 0;
+}
+
 static int ocfs2_free_cached_clusters(struct ocfs2_super *osb,
 				      struct ocfs2_cached_block_free *head)
 {
diff --git a/fs/ocfs2/alloc.h b/fs/ocfs2/alloc.h
index 07f6315..cd80410 100644
--- a/fs/ocfs2/alloc.h
+++ b/fs/ocfs2/alloc.h
@@ -188,10 +188,17 @@ static inline void ocfs2_init_dealloc_ctxt(struct ocfs2_cached_dealloc_ctxt *c)
 }
 int ocfs2_cache_cluster_dealloc(struct ocfs2_cached_dealloc_ctxt *ctxt,
 				u64 blkno, unsigned int bit);
+static inline int ocfs2_dealloc_has_block(struct ocfs2_cached_dealloc_ctxt *c)
+{
+	return c->c_first_suballocator != NULL;
+}
 static inline int ocfs2_dealloc_has_cluster(struct ocfs2_cached_dealloc_ctxt *c)
 {
 	return c->c_global_allocator != NULL;
 }
+int ocfs2_claim_bit_from_dealloc(struct ocfs2_cached_dealloc_ctxt *ctxt,
+				 u16 *slot, u16 *suballoc_bit,
+				 unsigned int *num_bits, u64 *blkno);
 int ocfs2_run_deallocs(struct ocfs2_super *osb,
 		       struct ocfs2_cached_dealloc_ctxt *ctxt);
 
diff --git a/fs/ocfs2/suballoc.c b/fs/ocfs2/suballoc.c
index f6712ab..0cee488 100644
--- a/fs/ocfs2/suballoc.c
+++ b/fs/ocfs2/suballoc.c
@@ -1586,6 +1586,7 @@ int ocfs2_claim_metadata(struct ocfs2_super *osb,
 			 handle_t *handle,
 			 struct ocfs2_alloc_context *ac,
 			 u32 bits_wanted,
+			 u16 *slot,
 			 u16 *suballoc_bit_start,
 			 unsigned int *num_bits,
 			 u64 *blkno_start)
@@ -1594,6 +1595,27 @@ int ocfs2_claim_metadata(struct ocfs2_super *osb,
 	u64 bg_blkno;
 
 	BUG_ON(!ac);
+
+	/*
+	 * If there is no space reserved in ac, check whether we have
+	 * free some before in dealloc. If yes, allocate one form it.
+	 */
+	if (ac->ac_bits_wanted < (ac->ac_bits_given + bits_wanted)) {
+		mlog(0, "alloc context doesn't have enough meta data reserved. "
+		     "It has %d, we need %u\n",
+		     ac->ac_bits_given - ac->ac_bits_given, bits_wanted);
+		if (ac->dealloc && ocfs2_dealloc_has_block(ac->dealloc)) {
+			status = ocfs2_claim_bit_from_dealloc(ac->dealloc,
+							slot,
+							suballoc_bit_start,
+							num_bits,
+							blkno_start);
+			if (!status)
+				goto bail;
+			/*fail through, so that it will BUG out. */
+		}
+	}
+
 	BUG_ON(ac->ac_bits_wanted < (ac->ac_bits_given + bits_wanted));
 	BUG_ON(ac->ac_which != OCFS2_AC_USE_META);
 
@@ -1611,6 +1633,7 @@ int ocfs2_claim_metadata(struct ocfs2_super *osb,
 	}
 	atomic_inc(&osb->alloc_stats.bg_allocs);
 
+	*slot = ac->ac_alloc_slot;
 	*blkno_start = bg_blkno + (u64) *suballoc_bit_start;
 	ac->ac_bits_given += (*num_bits);
 	status = 0;
diff --git a/fs/ocfs2/suballoc.h b/fs/ocfs2/suballoc.h
index e3c13c7..d271a12 100644
--- a/fs/ocfs2/suballoc.h
+++ b/fs/ocfs2/suballoc.h
@@ -34,6 +34,7 @@ typedef int (group_search_t)(struct inode *,
 			     u16 *,			/* *bit_off */
 			     u16 *);			/* *bits_found */
 
+struct ocfs2_cached_dealloc_ctxt;
 struct ocfs2_alloc_context {
 	struct inode *ac_inode;    /* which bitmap are we allocating from? */
 	struct buffer_head *ac_bh; /* file entry bh */
@@ -54,6 +55,7 @@ struct ocfs2_alloc_context {
 	u64    ac_last_group;
 	u64    ac_max_block;  /* Highest block number to allocate. 0 is
 				 is the same as ~0 - unlimited */
+	struct ocfs2_cached_dealloc_ctxt *dealloc;
 };
 
 void ocfs2_free_alloc_context(struct ocfs2_alloc_context *ac);
@@ -83,6 +85,7 @@ int ocfs2_claim_metadata(struct ocfs2_super *osb,
 			 handle_t *handle,
 			 struct ocfs2_alloc_context *ac,
 			 u32 bits_wanted,
+			 u16 *slot,
 			 u16 *suballoc_bit_start,
 			 u32 *num_bits,
 			 u64 *blkno_start);
diff --git a/fs/ocfs2/xattr.c b/fs/ocfs2/xattr.c
index 127e9d2..f324c65 100644
--- a/fs/ocfs2/xattr.c
+++ b/fs/ocfs2/xattr.c
@@ -2093,7 +2093,7 @@ static int ocfs2_xattr_block_set(struct inode *inode,
 	struct ocfs2_dinode *di =  (struct ocfs2_dinode *)xs->inode_bh->b_data;
 	handle_t *handle = ctxt->handle;
 	struct ocfs2_xattr_block *xblk = NULL;
-	u16 suballoc_bit_start;
+	u16 slot, suballoc_bit_start;
 	u32 num_got;
 	u64 first_blkno;
 	int ret;
@@ -2108,7 +2108,7 @@ static int ocfs2_xattr_block_set(struct inode *inode,
 		}
 
 		ret = ocfs2_claim_metadata(osb, handle, ctxt->meta_ac, 1,
-					   &suballoc_bit_start, &num_got,
+					   &slot, &suballoc_bit_start, &num_got,
 					   &first_blkno);
 		if (ret < 0) {
 			mlog_errno(ret);
@@ -2131,7 +2131,7 @@ static int ocfs2_xattr_block_set(struct inode *inode,
 		xblk = (struct ocfs2_xattr_block *)new_bh->b_data;
 		memset(xblk, 0, inode->i_sb->s_blocksize);
 		strcpy((void *)xblk, OCFS2_XATTR_BLOCK_SIGNATURE);
-		xblk->xb_suballoc_slot = cpu_to_le16(osb->slot_num);
+		xblk->xb_suballoc_slot = cpu_to_le16(slot);
 		xblk->xb_suballoc_bit = cpu_to_le16(suballoc_bit_start);
 		xblk->xb_fs_generation = cpu_to_le32(osb->fs_generation);
 		xblk->xb_blkno = cpu_to_le64(first_blkno);
-- 
1.6.2.rc2.16.gf474c
