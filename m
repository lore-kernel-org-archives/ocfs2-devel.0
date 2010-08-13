From: mfasheh at suse.com <mfasheh@suse.com>
Date: Fri, 13 Aug 2010 15:15:17 -0700
Subject: [Ocfs2-devel] [PATCH 3/5] ocfs2: allow return of new inode block
	location before allocation of the inode
In-Reply-To: <1281737719-27008-3-git-send-email-mfasheh@suse.com>
References: <1281737719-27008-1-git-send-email-mfasheh@suse.com>
	<1281737719-27008-2-git-send-email-mfasheh@suse.com>
	<1281737719-27008-3-git-send-email-mfasheh@suse.com>
Message-ID: <1281737719-27008-4-git-send-email-mfasheh@suse.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

From: Mark Fasheh <mfasheh@suse.com>

This allows code which needs to know the eventual block number of an inode
but can't allocate it yet due to transaction or lock ordering. For example,
ocfs2_create_inode_in_orphan() currently gives a junk blkno for preparation
of the orphan dir because it can't yet know where the actual inode is placed
- that code is actually in ocfs2_mknod_locked. This is a problem when the
orphan dirs are indexed as the junk inode number will create an index entry
which goes unused (and fails the later removal from the orphan dir).  Now
with these interfaces, ocfs2_create_inode_in_orphan() can run the block
group search (and get back the inode block number) *before* any actual
allocation occurs.

Signed-off-by: Mark Fasheh <mfasheh@suse.com>
---
 fs/ocfs2/suballoc.c |  159 +++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/ocfs2/suballoc.h |   21 +++++++
 2 files changed, 180 insertions(+), 0 deletions(-)

diff --git a/fs/ocfs2/suballoc.c b/fs/ocfs2/suballoc.c
index 75f43ed..e569636 100644
--- a/fs/ocfs2/suballoc.c
+++ b/fs/ocfs2/suballoc.c
@@ -57,6 +57,12 @@ struct ocfs2_suballoc_result {
 	u64		sr_bg_blkno;	/* The bg we allocated from.  Set
 					   to 0 when a block group is
 					   contiguous. */
+	u64		sr_bg_stable_blkno; /*
+					     * Doesn't change, always
+					     * set to target block
+					     * group descriptor
+					     * block.
+					     */
 	u64		sr_blkno;	/* The first allocated block */
 	unsigned int	sr_bit_offset;	/* The bit in the bg */
 	unsigned int	sr_bits;	/* How many bits we claimed */
@@ -138,6 +144,10 @@ void ocfs2_free_ac_resource(struct ocfs2_alloc_context *ac)
 	brelse(ac->ac_bh);
 	ac->ac_bh = NULL;
 	ac->ac_resv = NULL;
+	if (ac->ac_find_loc_priv) {
+		kfree(ac->ac_find_loc_priv);
+		ac->ac_find_loc_priv = NULL;
+	}
 }
 
 void ocfs2_free_alloc_context(struct ocfs2_alloc_context *ac)
@@ -1678,6 +1688,15 @@ static int ocfs2_search_one_group(struct ocfs2_alloc_context *ac,
 	if (!ret)
 		ocfs2_bg_discontig_fix_result(ac, gd, res);
 
+	/*
+	 * sr_bg_blkno might have been changed by
+	 * ocfs2_bg_discontig_fix_result
+	 */
+	res->sr_bg_stable_blkno = group_bh->b_blocknr;
+
+	if (ac->ac_find_loc_only)
+		goto out_loc_only;
+
 	ret = ocfs2_alloc_dinode_update_counts(alloc_inode, handle, ac->ac_bh,
 					       res->sr_bits,
 					       le16_to_cpu(gd->bg_chain));
@@ -1691,6 +1710,7 @@ static int ocfs2_search_one_group(struct ocfs2_alloc_context *ac,
 	if (ret < 0)
 		mlog_errno(ret);
 
+out_loc_only:
 	*bits_left = le16_to_cpu(gd->bg_free_bits_count);
 
 out:
@@ -1769,6 +1789,11 @@ static int ocfs2_search_chain(struct ocfs2_alloc_context *ac,
 	if (!status)
 		ocfs2_bg_discontig_fix_result(ac, bg, res);
 
+	/*
+	 * sr_bg_blkno might have been changed by
+	 * ocfs2_bg_discontig_fix_result
+	 */
+	res->sr_bg_stable_blkno = group_bh->b_blocknr;
 
 	/*
 	 * Keep track of previous block descriptor read. When
@@ -1795,6 +1820,9 @@ static int ocfs2_search_chain(struct ocfs2_alloc_context *ac,
 		}
 	}
 
+	if (ac->ac_find_loc_only)
+		goto out_loc_only;
+
 	status = ocfs2_alloc_dinode_update_counts(alloc_inode, handle,
 						  ac->ac_bh, res->sr_bits,
 						  chain);
@@ -1817,6 +1845,7 @@ static int ocfs2_search_chain(struct ocfs2_alloc_context *ac,
 	mlog(0, "Allocated %u bits from suballocator %llu\n", res->sr_bits,
 	     (unsigned long long)le64_to_cpu(fe->i_blkno));
 
+out_loc_only:
 	*bits_left = le16_to_cpu(bg->bg_free_bits_count);
 bail:
 	brelse(group_bh);
@@ -2007,6 +2036,136 @@ static inline void ocfs2_save_inode_ac_group(struct inode *dir,
 	OCFS2_I(dir)->ip_last_used_slot = ac->ac_alloc_slot;
 }
 
+int ocfs2_find_new_inode_loc(struct inode *dir,
+			     struct buffer_head *parent_fe_bh,
+			     struct ocfs2_alloc_context *ac,
+			     u64 *fe_blkno)
+{
+	int ret;
+	handle_t *handle = NULL;
+	struct ocfs2_suballoc_result *res;
+
+	BUG_ON(!ac);
+	BUG_ON(ac->ac_bits_given != 0);
+	BUG_ON(ac->ac_bits_wanted != 1);
+	BUG_ON(ac->ac_which != OCFS2_AC_USE_INODE);
+
+	res = kzalloc(sizeof(*res), GFP_NOFS);
+	if (res == NULL) {
+		ret = -ENOMEM;
+		mlog_errno(ret);
+		goto out;
+	}
+
+	ocfs2_init_inode_ac_group(dir, parent_fe_bh, ac);
+
+	/*
+	 * The handle started here is for chain relink. Alternatively,
+	 * we could just disable relink for these calls.
+	 */
+	handle = ocfs2_start_trans(OCFS2_SB(dir->i_sb), OCFS2_SUBALLOC_ALLOC);
+	if (IS_ERR(handle)) {
+		ret = PTR_ERR(handle);
+		handle = NULL;
+		mlog_errno(ret);
+		goto out;
+	}
+
+	/*
+	 * This will instruct ocfs2_claim_suballoc_bits and
+	 * ocfs2_search_one_group to search but save actual allocation
+	 * for later.
+	 */
+	ac->ac_find_loc_only = 1;
+
+	ret = ocfs2_claim_suballoc_bits(ac, handle, 1, 1, res);
+	if (ret < 0) {
+		mlog_errno(ret);
+		goto out;
+	}
+
+	ac->ac_find_loc_priv = res;
+	*fe_blkno = res->sr_blkno;
+
+out:
+	if (handle)
+		ocfs2_commit_trans(OCFS2_SB(dir->i_sb), handle);
+
+	if (ret)
+		kfree(res);
+
+	return ret;
+}
+
+int ocfs2_claim_new_inode_at_loc(handle_t *handle,
+				 struct inode *dir,
+				 struct ocfs2_alloc_context *ac,
+				 u64 *suballoc_loc,
+				 u16 *suballoc_bit,
+				 u64 di_blkno)
+{
+	int ret;
+	u16 chain;
+	struct ocfs2_suballoc_result *res = ac->ac_find_loc_priv;
+	struct buffer_head *bg_bh = NULL;
+	struct ocfs2_group_desc *bg;
+	struct ocfs2_dinode *di = (struct ocfs2_dinode *) ac->ac_bh->b_data;
+
+	/*
+	 * Since di_blkno is being passed back in, we check for any
+	 * inconsistencies which may have happened between
+	 * calls. These are code bugs as di_blkno is not expected to
+	 * change once returned from ocfs2_find_new_inode_loc()
+	 */
+	BUG_ON(res->sr_blkno != di_blkno);
+
+	ret = ocfs2_read_group_descriptor(ac->ac_inode, di,
+					  res->sr_bg_stable_blkno, &bg_bh);
+	if (ret) {
+		mlog_errno(ret);
+		goto out;
+	}
+
+	bg = (struct ocfs2_group_desc *) bg_bh->b_data;
+	chain = le16_to_cpu(bg->bg_chain);
+
+	ret = ocfs2_alloc_dinode_update_counts(ac->ac_inode, handle,
+					       ac->ac_bh, res->sr_bits,
+					       chain);
+	if (ret) {
+		mlog_errno(ret);
+		goto out;
+	}
+
+	ret = ocfs2_block_group_set_bits(handle,
+					 ac->ac_inode,
+					 bg,
+					 bg_bh,
+					 res->sr_bit_offset,
+					 res->sr_bits);
+	if (ret < 0) {
+		mlog_errno(ret);
+		goto out;
+	}
+
+	mlog(0, "Allocated %u bits from suballocator %llu\n", res->sr_bits,
+	     (unsigned long long)di_blkno);
+
+	atomic_inc(&OCFS2_SB(ac->ac_inode->i_sb)->alloc_stats.bg_allocs);
+
+	BUG_ON(res->sr_bits != 1);
+
+	*suballoc_loc = res->sr_bg_blkno;
+	*suballoc_bit = res->sr_bit_offset;
+	ac->ac_bits_given++;
+	ocfs2_save_inode_ac_group(dir, ac);
+
+out:
+	brelse(bg_bh);
+
+	return ret;
+}
+
 int ocfs2_claim_new_inode(handle_t *handle,
 			  struct inode *dir,
 			  struct buffer_head *parent_fe_bh,
diff --git a/fs/ocfs2/suballoc.h b/fs/ocfs2/suballoc.h
index a017dd3..b8afabf 100644
--- a/fs/ocfs2/suballoc.h
+++ b/fs/ocfs2/suballoc.h
@@ -56,6 +56,9 @@ struct ocfs2_alloc_context {
 	u64    ac_max_block;  /* Highest block number to allocate. 0 is
 				 is the same as ~0 - unlimited */
 
+	int    ac_find_loc_only;  /* hack for reflink operation ordering */
+	struct ocfs2_suballoc_result *ac_find_loc_priv; /* */
+
 	struct ocfs2_alloc_reservation	*ac_resv;
 };
 
@@ -197,4 +200,22 @@ int ocfs2_lock_allocators(struct inode *inode, struct ocfs2_extent_tree *et,
 			  struct ocfs2_alloc_context **meta_ac);
 
 int ocfs2_test_inode_bit(struct ocfs2_super *osb, u64 blkno, int *res);
+
+
+
+/*
+ * The following two interfaces are for ocfs2_create_inode_in_orphan().
+ */
+int ocfs2_find_new_inode_loc(struct inode *dir,
+			     struct buffer_head *parent_fe_bh,
+			     struct ocfs2_alloc_context *ac,
+			     u64 *fe_blkno);
+
+int ocfs2_claim_new_inode_at_loc(handle_t *handle,
+				 struct inode *dir,
+				 struct ocfs2_alloc_context *ac,
+				 u64 *suballoc_loc,
+				 u16 *suballoc_bit,
+				 u64 di_blkno);
+
 #endif /* _CHAINALLOC_H_ */
-- 
1.6.4.2
