From: Younger Liu <younger.liucn@gmail.com>
Date: Mon, 31 Mar 2014 21:07:40 +0800
Subject: [Ocfs2-devel] [PATCH] Ocfs2: Rollback alloc_dinode counts when
 ocfs2_block_group_set_bits() failed
Message-ID: <5339689C.1060807@gmail.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

  After updating alloc_dinode counts in ocfs2_alloc_dinode_update_counts(),
if ocfs2_alloc_dinode_update_bitmap() failed, there is a rare case that some
space may be lost.
  So, we rollback alloc_dinode counts when ocfs2_block_group_set_bits() failed.

Signed-off-by: Younger Liu <younger.liucn@gmail.com>
Cc: Mark Fasheh <mfasheh@suse.de>
---
 fs/ocfs2/move_extents.c |    5 ++++-
 fs/ocfs2/suballoc.c     |   24 +++++++++++++++++++++++-
 fs/ocfs2/suballoc.h     |    4 ++++
 3 files changed, 31 insertions(+), 2 deletions(-)

diff --git a/fs/ocfs2/move_extents.c b/fs/ocfs2/move_extents.c
index 64c304d..65483d0 100644
--- a/fs/ocfs2/move_extents.c
+++ b/fs/ocfs2/move_extents.c
@@ -690,8 +690,11 @@ static int ocfs2_move_extent(struct ocfs2_move_extents_context *context,
 
 	ret = ocfs2_block_group_set_bits(handle, gb_inode, gd, gd_bh,
 					 goal_bit, len);
-	if (ret)
+	if (ret) {
+		ocfs2_rollback_alloc_dinode_counts(gb_inode, gb_bh, len,
+					       le16_to_cpu(gd->bg_chain));
 		mlog_errno(ret);
+	}
 
 	/*
 	 * Here we should write the new page out first if we are
diff --git a/fs/ocfs2/suballoc.c b/fs/ocfs2/suballoc.c
index 47ae266..150d94f 100644
--- a/fs/ocfs2/suballoc.c
+++ b/fs/ocfs2/suballoc.c
@@ -1607,6 +1607,20 @@ out:
 	return ret;
 }
 
+void ocfs2_rollback_alloc_dinode_counts(struct inode *inode,
+				       struct buffer_head *di_bh,
+				       u32 num_bits,
+				       u16 chain)
+{
+	u32 tmp_used;
+	struct ocfs2_dinode *di = (struct ocfs2_dinode *) di_bh->b_data;
+	struct ocfs2_chain_list *cl = (struct ocfs2_chain_list *) &di->id2.i_chain;
+
+	tmp_used = le32_to_cpu(di->id1.bitmap1.i_used);
+	di->id1.bitmap1.i_used = cpu_to_le32(tmp_used - num_bits);
+	le32_add_cpu(&cl->cl_recs[chain].c_free, num_bits);
+}
+
 static int ocfs2_bg_discontig_fix_by_rec(struct ocfs2_suballoc_result *res,
 					 struct ocfs2_extent_rec *rec,
 					 struct ocfs2_chain_list *cl)
@@ -1707,8 +1721,12 @@ static int ocfs2_search_one_group(struct ocfs2_alloc_context *ac,
 
 	ret = ocfs2_block_group_set_bits(handle, alloc_inode, gd, group_bh,
 					 res->sr_bit_offset, res->sr_bits);
-	if (ret < 0)
+	if (ret < 0) {
+		ocfs2_rollback_alloc_dinode_counts(alloc_inode, ac->ac_bh,
+					       res->sr_bits,
+					       le16_to_cpu(gd->bg_chain));
 		mlog_errno(ret);
+	}
 
 out_loc_only:
 	*bits_left = le16_to_cpu(gd->bg_free_bits_count);
@@ -1838,6 +1856,8 @@ static int ocfs2_search_chain(struct ocfs2_alloc_context *ac,
 					    res->sr_bit_offset,
 					    res->sr_bits);
 	if (status < 0) {
+		ocfs2_rollback_alloc_dinode_counts(alloc_inode,
+					ac->ac_bh, res->sr_bits, chain);
 		mlog_errno(status);
 		goto bail;
 	}
@@ -2149,6 +2169,8 @@ int ocfs2_claim_new_inode_at_loc(handle_t *handle,
 					 res->sr_bit_offset,
 					 res->sr_bits);
 	if (ret < 0) {
+		ocfs2_rollback_alloc_dinode_counts(ac->ac_inode,
+					       ac->ac_bh, res->sr_bits, chain);
 		mlog_errno(ret);
 		goto out;
 	}
diff --git a/fs/ocfs2/suballoc.h b/fs/ocfs2/suballoc.h
index 218d803..2d25017 100644
--- a/fs/ocfs2/suballoc.h
+++ b/fs/ocfs2/suballoc.h
@@ -91,6 +91,10 @@ int ocfs2_alloc_dinode_update_counts(struct inode *inode,
 			 struct buffer_head *di_bh,
 			 u32 num_bits,
 			 u16 chain);
+void ocfs2_rollback_alloc_dinode_counts(struct inode *inode,
+			 struct buffer_head *di_bh,
+			 u32 num_bits,
+			 u16 chain);
 int ocfs2_block_group_set_bits(handle_t *handle,
 			 struct inode *alloc_inode,
 			 struct ocfs2_group_desc *bg,
-- 
1.7.9.5
