From: Mark Fasheh <mfasheh@suse.com>
Date: Fri, 19 Dec 2008 13:53:52 -0800
Subject: [Ocfs2-devel] [PATCH 33/45] ocfs2: Morph the haphazard
	OCFS2_IS_VALID_DINODE() checks.
In-Reply-To: <1229723644-13630-1-git-send-email-mfasheh@suse.com>
References: <1229723644-13630-1-git-send-email-mfasheh@suse.com>
Message-ID: <1229723644-13630-34-git-send-email-mfasheh@suse.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-kernel@vger.kernel.org
Cc: ocfs2-devel@oss.oracle.com, Joel Becker <joel.becker@oracle.com>, Mark Fasheh <mfasheh@suse.com>

From: Joel Becker <joel.becker@oracle.com>

Random places in the code would check a dinode bh to see if it was
valid.  Not only did they do different levels of validation, they
handled errors in different ways.

The previous commit unified inode block reads, validating all block
reads in the same place.  Thus, these haphazard checks are no longer
necessary.  Rather than eliminate them, however, we change them to
BUG_ON() checks.  This ensures the assumptions remain true.  All of the
code paths to these checks have been audited to ensure they come from a
validated inode read.

Signed-off-by: Joel Becker <joel.becker@oracle.com>
Signed-off-by: Mark Fasheh <mfasheh@suse.com>
---
 fs/ocfs2/alloc.c    |   50 +++++++++++++++++++++-----------------------------
 fs/ocfs2/journal.c  |   17 +++++------------
 fs/ocfs2/ocfs2.h    |    8 --------
 fs/ocfs2/resize.c   |   10 ++++------
 fs/ocfs2/suballoc.c |   36 ++++++++++++++++--------------------
 5 files changed, 46 insertions(+), 75 deletions(-)

diff --git a/fs/ocfs2/alloc.c b/fs/ocfs2/alloc.c
index 9c598ad..320545b 100644
--- a/fs/ocfs2/alloc.c
+++ b/fs/ocfs2/alloc.c
@@ -187,20 +187,12 @@ static int ocfs2_dinode_insert_check(struct inode *inode,
 static int ocfs2_dinode_sanity_check(struct inode *inode,
 				     struct ocfs2_extent_tree *et)
 {
-	int ret = 0;
-	struct ocfs2_dinode *di;
+	struct ocfs2_dinode *di = et->et_object;
 
 	BUG_ON(et->et_ops != &ocfs2_dinode_et_ops);
+	BUG_ON(!OCFS2_IS_VALID_DINODE(di));
 
-	di = et->et_object;
-	if (!OCFS2_IS_VALID_DINODE(di)) {
-		ret = -EIO;
-		ocfs2_error(inode->i_sb,
-			"Inode %llu has invalid path root",
-			(unsigned long long)OCFS2_I(inode)->ip_blkno);
-	}
-
-	return ret;
+	return 0;
 }
 
 static void ocfs2_dinode_fill_root_el(struct ocfs2_extent_tree *et)
@@ -5380,13 +5372,13 @@ int ocfs2_truncate_log_append(struct ocfs2_super *osb,
 	start_cluster = ocfs2_blocks_to_clusters(osb->sb, start_blk);
 
 	di = (struct ocfs2_dinode *) tl_bh->b_data;
-	tl = &di->id2.i_dealloc;
-	if (!OCFS2_IS_VALID_DINODE(di)) {
-		OCFS2_RO_ON_INVALID_DINODE(osb->sb, di);
-		status = -EIO;
-		goto bail;
-	}
 
+	/* tl_bh is loaded from ocfs2_truncate_log_init().  It's validated
+	 * by the underlying call to ocfs2_read_inode_block(), so any
+	 * corruption is a code bug */
+	BUG_ON(!OCFS2_IS_VALID_DINODE(di));
+
+	tl = &di->id2.i_dealloc;
 	tl_count = le16_to_cpu(tl->tl_count);
 	mlog_bug_on_msg(tl_count > ocfs2_truncate_recs_per_inode(osb->sb) ||
 			tl_count == 0,
@@ -5536,13 +5528,13 @@ int __ocfs2_flush_truncate_log(struct ocfs2_super *osb)
 	BUG_ON(mutex_trylock(&tl_inode->i_mutex));
 
 	di = (struct ocfs2_dinode *) tl_bh->b_data;
-	tl = &di->id2.i_dealloc;
-	if (!OCFS2_IS_VALID_DINODE(di)) {
-		OCFS2_RO_ON_INVALID_DINODE(osb->sb, di);
-		status = -EIO;
-		goto out;
-	}
 
+	/* tl_bh is loaded from ocfs2_truncate_log_init().  It's validated
+	 * by the underlying call to ocfs2_read_inode_block(), so any
+	 * corruption is a code bug */
+	BUG_ON(!OCFS2_IS_VALID_DINODE(di));
+
+	tl = &di->id2.i_dealloc;
 	num_to_flush = le16_to_cpu(tl->tl_used);
 	mlog(0, "Flush %u records from truncate log #%llu\n",
 	     num_to_flush, (unsigned long long)OCFS2_I(tl_inode)->ip_blkno);
@@ -5697,13 +5689,13 @@ int ocfs2_begin_truncate_log_recovery(struct ocfs2_super *osb,
 	}
 
 	di = (struct ocfs2_dinode *) tl_bh->b_data;
-	tl = &di->id2.i_dealloc;
-	if (!OCFS2_IS_VALID_DINODE(di)) {
-		OCFS2_RO_ON_INVALID_DINODE(tl_inode->i_sb, di);
-		status = -EIO;
-		goto bail;
-	}
 
+	/* tl_bh is loaded from ocfs2_get_truncate_log_info().  It's
+	 * validated by the underlying call to ocfs2_read_inode_block(),
+	 * so any corruption is a code bug */
+	BUG_ON(!OCFS2_IS_VALID_DINODE(di));
+
+	tl = &di->id2.i_dealloc;
 	if (le16_to_cpu(tl->tl_used)) {
 		mlog(0, "We'll have %u logs to recover\n",
 		     le16_to_cpu(tl->tl_used));
diff --git a/fs/ocfs2/journal.c b/fs/ocfs2/journal.c
index 877aaa0..9223bfc 100644
--- a/fs/ocfs2/journal.c
+++ b/fs/ocfs2/journal.c
@@ -587,17 +587,11 @@ static int ocfs2_journal_toggle_dirty(struct ocfs2_super *osb,
 	mlog_entry_void();
 
 	fe = (struct ocfs2_dinode *)bh->b_data;
-	if (!OCFS2_IS_VALID_DINODE(fe)) {
-		/* This is called from startup/shutdown which will
-		 * handle the errors in a specific manner, so no need
-		 * to call ocfs2_error() here. */
-		mlog(ML_ERROR, "Journal dinode %llu  has invalid "
-		     "signature: %.*s",
-		     (unsigned long long)le64_to_cpu(fe->i_blkno), 7,
-		     fe->i_signature);
-		status = -EIO;
-		goto out;
-	}
+
+	/* The journal bh on the osb always comes from ocfs2_journal_init()
+	 * and was validated there inside ocfs2_inode_lock_full().  It's a
+	 * code bug if we mess it up. */
+	BUG_ON(!OCFS2_IS_VALID_DINODE(fe));
 
 	flags = le32_to_cpu(fe->id1.journal1.ij_flags);
 	if (dirty)
@@ -613,7 +607,6 @@ static int ocfs2_journal_toggle_dirty(struct ocfs2_super *osb,
 	if (status < 0)
 		mlog_errno(status);
 
-out:
 	mlog_exit(status);
 	return status;
 }
diff --git a/fs/ocfs2/ocfs2.h b/fs/ocfs2/ocfs2.h
index 25d07ff..467bdb6 100644
--- a/fs/ocfs2/ocfs2.h
+++ b/fs/ocfs2/ocfs2.h
@@ -444,14 +444,6 @@ static inline int ocfs2_uses_extended_slot_map(struct ocfs2_super *osb)
 #define OCFS2_IS_VALID_DINODE(ptr)					\
 	(!strcmp((ptr)->i_signature, OCFS2_INODE_SIGNATURE))
 
-#define OCFS2_RO_ON_INVALID_DINODE(__sb, __di)	do {			\
-	typeof(__di) ____di = (__di);					\
-	ocfs2_error((__sb), 						\
-		"Dinode # %llu has bad signature %.*s",			\
-		(unsigned long long)le64_to_cpu((____di)->i_blkno), 7, 	\
-		(____di)->i_signature);					\
-} while (0)
-
 #define OCFS2_IS_VALID_EXTENT_BLOCK(ptr)				\
 	(!strcmp((ptr)->h_signature, OCFS2_EXTENT_BLOCK_SIGNATURE))
 
diff --git a/fs/ocfs2/resize.c b/fs/ocfs2/resize.c
index ffd48db..739d452 100644
--- a/fs/ocfs2/resize.c
+++ b/fs/ocfs2/resize.c
@@ -314,6 +314,10 @@ int ocfs2_group_extend(struct inode * inode, int new_clusters)
 
 	fe = (struct ocfs2_dinode *)main_bm_bh->b_data;
 
+	/* main_bm_bh is validated by inode read inside ocfs2_inode_lock(),
+	 * so any corruption is a code bug. */
+	BUG_ON(!OCFS2_IS_VALID_DINODE(fe));
+
 	if (le16_to_cpu(fe->id2.i_chain.cl_cpg) !=
 				 ocfs2_group_bitmap_size(osb->sb) * 8) {
 		mlog(ML_ERROR, "The disk is too old and small. "
@@ -322,12 +326,6 @@ int ocfs2_group_extend(struct inode * inode, int new_clusters)
 		goto out_unlock;
 	}
 
-	if (!OCFS2_IS_VALID_DINODE(fe)) {
-		OCFS2_RO_ON_INVALID_DINODE(main_bm_inode->i_sb, fe);
-		ret = -EIO;
-		goto out_unlock;
-	}
-
 	first_new_cluster = le32_to_cpu(fe->i_clusters);
 	lgd_blkno = ocfs2_which_cluster_group(main_bm_inode,
 					      first_new_cluster - 1);
diff --git a/fs/ocfs2/suballoc.c b/fs/ocfs2/suballoc.c
index c5ff18b..95d432b 100644
--- a/fs/ocfs2/suballoc.c
+++ b/fs/ocfs2/suballoc.c
@@ -441,11 +441,11 @@ static int ocfs2_reserve_suballoc_bits(struct ocfs2_super *osb,
 	ac->ac_alloc_slot = slot;
 
 	fe = (struct ocfs2_dinode *) bh->b_data;
-	if (!OCFS2_IS_VALID_DINODE(fe)) {
-		OCFS2_RO_ON_INVALID_DINODE(alloc_inode->i_sb, fe);
-		status = -EIO;
-		goto bail;
-	}
+
+	/* The bh was validated by the inode read inside
+	 * ocfs2_inode_lock().  Any corruption is a code bug. */
+	BUG_ON(!OCFS2_IS_VALID_DINODE(fe));
+
 	if (!(fe->i_flags & cpu_to_le32(OCFS2_CHAIN_FL))) {
 		ocfs2_error(alloc_inode->i_sb, "Invalid chain allocator %llu",
 			    (unsigned long long)le64_to_cpu(fe->i_blkno));
@@ -931,11 +931,6 @@ static int ocfs2_relink_block_group(handle_t *handle,
 	struct ocfs2_group_desc *bg = (struct ocfs2_group_desc *) bg_bh->b_data;
 	struct ocfs2_group_desc *prev_bg = (struct ocfs2_group_desc *) prev_bg_bh->b_data;
 
-	if (!OCFS2_IS_VALID_DINODE(fe)) {
-		OCFS2_RO_ON_INVALID_DINODE(alloc_inode->i_sb, fe);
-		status = -EIO;
-		goto out;
-	}
 	if (!OCFS2_IS_VALID_GROUP_DESC(bg)) {
 		OCFS2_RO_ON_INVALID_GROUP_DESC(alloc_inode->i_sb, bg);
 		status = -EIO;
@@ -1392,11 +1387,11 @@ static int ocfs2_claim_suballoc_bits(struct ocfs2_super *osb,
 	BUG_ON(!ac->ac_bh);
 
 	fe = (struct ocfs2_dinode *) ac->ac_bh->b_data;
-	if (!OCFS2_IS_VALID_DINODE(fe)) {
-		OCFS2_RO_ON_INVALID_DINODE(osb->sb, fe);
-		status = -EIO;
-		goto bail;
-	}
+
+	/* The bh was validated by the inode read during
+	 * ocfs2_reserve_suballoc_bits().  Any corruption is a code bug. */
+	BUG_ON(!OCFS2_IS_VALID_DINODE(fe));
+
 	if (le32_to_cpu(fe->id1.bitmap1.i_used) >=
 	    le32_to_cpu(fe->id1.bitmap1.i_total)) {
 		ocfs2_error(osb->sb, "Chain allocator dinode %llu has %u used "
@@ -1782,11 +1777,12 @@ int ocfs2_free_suballoc_bits(handle_t *handle,
 
 	mlog_entry_void();
 
-	if (!OCFS2_IS_VALID_DINODE(fe)) {
-		OCFS2_RO_ON_INVALID_DINODE(alloc_inode->i_sb, fe);
-		status = -EIO;
-		goto bail;
-	}
+	/* The alloc_bh comes from ocfs2_free_dinode() or
+	 * ocfs2_free_clusters().  The callers have all locked the
+	 * allocator and gotten alloc_bh from the lock call.  This
+	 * validates the dinode buffer.  Any corruption that has happended
+	 * is a code bug. */
+	BUG_ON(!OCFS2_IS_VALID_DINODE(fe));
 	BUG_ON((count + start_bit) > ocfs2_bits_per_group(cl));
 
 	mlog(0, "%llu: freeing %u bits from group %llu, starting at %u\n",
-- 
1.5.6
