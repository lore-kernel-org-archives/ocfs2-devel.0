From: Tao Ma <tao.ma@oracle.com>
Date: Fri,  3 Apr 2009 07:45:44 +0800
Subject: [Ocfs2-devel] [PATCH 05/42] ocfs2: Basic tree root operation.
In-Reply-To: <49D5CAC2.4010201@oracle.com>
References: <49D5CAC2.4010201@oracle.com>
Message-ID: <1238715981-21488-5-git-send-email-tao.ma@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Add basic refcount tree root operation.

Signed-off-by: Tao Ma <tao.ma@oracle.com>
---
 fs/ocfs2/journal.h      |    3 +
 fs/ocfs2/refcounttree.c |  271 +++++++++++++++++++++++++++++++++++++++++++++++
 fs/ocfs2/refcounttree.h |   26 +++++
 3 files changed, 300 insertions(+), 0 deletions(-)
 create mode 100644 fs/ocfs2/refcounttree.h

diff --git a/fs/ocfs2/journal.h b/fs/ocfs2/journal.h
index 0eef436..bae77f4 100644
--- a/fs/ocfs2/journal.h
+++ b/fs/ocfs2/journal.h
@@ -435,6 +435,9 @@ static inline int ocfs2_rename_credits(struct super_block *sb)
 					  + OCFS2_INODE_UPDATE_CREDITS \
 					  + OCFS2_XATTR_BLOCK_UPDATE_CREDITS)
 
+#define OCFS2_REFCOUNT_TREE_CREATE_CREDITS (OCFS2_INODE_UPDATE_CREDITS + \
+					    + OCFS2_SUBALLOC_ALLOC + 1)
+#define OCFS2_REFCOUNT_TREE_SET_CREDITS (OCFS2_INODE_UPDATE_CREDITS + 1)
 /*
  * Please note that the caller must make sure that root_el is the root
  * of extent tree. So for an inode, it should be &fe->id2.i_list. Otherwise
diff --git a/fs/ocfs2/refcounttree.c b/fs/ocfs2/refcounttree.c
index 9790032..ced1050 100644
--- a/fs/ocfs2/refcounttree.c
+++ b/fs/ocfs2/refcounttree.c
@@ -26,6 +26,9 @@
 #include "super.h"
 #include "buffer_head_io.h"
 #include "blockcheck.h"
+#include "refcounttree.h"
+#include "sysfile.h"
+#include "dlmglue.h"
 
 static int ocfs2_validate_refcount_block(struct super_block *sb,
 					 struct buffer_head *bh)
@@ -97,3 +100,271 @@ static int ocfs2_read_refcount_block(struct ocfs2_caching_info *ci,
 
 	return rc;
 }
+
+/*
+ * Create a refcount tree for an inode.
+ * We take for granted that the inode is already locked.
+ */
+int ocfs2_create_refcount_tree(struct inode *inode, struct buffer_head *di_bh)
+{
+	int ret;
+	handle_t *handle = NULL;
+	struct ocfs2_alloc_context *meta_ac = NULL;
+	struct ocfs2_dinode *di = (struct ocfs2_dinode *)di_bh->b_data;
+	struct ocfs2_inode_info *oi = OCFS2_I(inode);
+	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
+	struct buffer_head *new_bh = NULL;
+	struct ocfs2_refcount_block *rb;
+	u16 slot, suballoc_bit_start;
+	u32 num_got;
+	u64 first_blkno;
+
+	BUG_ON(oi->ip_dyn_features & OCFS2_HAS_REFCOUNT_FL);
+	BUG_ON(di->i_refcount_loc);
+
+	mlog(0, "create tree for inode %lu\n", inode->i_ino);
+
+	ret = ocfs2_reserve_new_metadata_blocks(osb, 1, &meta_ac);
+	if (ret) {
+		mlog_errno(ret);
+		goto out;
+	}
+
+	handle = ocfs2_start_trans(osb, OCFS2_REFCOUNT_TREE_CREATE_CREDITS);
+	if (IS_ERR(handle)) {
+		ret = PTR_ERR(handle);
+		mlog_errno(ret);
+		goto out;
+	}
+
+	ret = ocfs2_journal_access_di(handle, INODE_CACHE(inode), di_bh,
+				      OCFS2_JOURNAL_ACCESS_WRITE);
+	if (ret) {
+		mlog_errno(ret);
+		goto out_commit;
+	}
+
+	ret = ocfs2_claim_metadata(osb, handle, meta_ac, 1,
+				   &slot, &suballoc_bit_start, &num_got,
+				   &first_blkno);
+	if (ret) {
+		mlog_errno(ret);
+		goto out_commit;
+	}
+
+	new_bh = sb_getblk(inode->i_sb, first_blkno);
+	ocfs2_set_new_buffer_uptodate(INODE_CACHE(inode), new_bh);
+
+	ret = ocfs2_journal_access_rb(handle, INODE_CACHE(inode), new_bh,
+				      OCFS2_JOURNAL_ACCESS_CREATE);
+	if (ret) {
+		mlog_errno(ret);
+		goto out_commit;
+	}
+
+	/* Initialize ocfs2_refcount_block. */
+	rb = (struct ocfs2_refcount_block *)new_bh->b_data;
+	memset(rb, 0, inode->i_sb->s_blocksize);
+	strcpy((void *)rb, OCFS2_REFCOUNT_BLOCK_SIGNATURE);
+	rb->rf_suballoc_slot = cpu_to_le16(slot);
+	rb->rf_suballoc_bit = cpu_to_le16(suballoc_bit_start);
+	rb->rf_fs_generation = cpu_to_le32(osb->fs_generation);
+	rb->rf_blkno = cpu_to_le64(first_blkno);
+	rb->rf_count = cpu_to_le32(1);
+	rb->rf_list.l_count = cpu_to_le16(ocfs2_extent_recs_per_rb(osb->sb));
+
+	ocfs2_journal_dirty(handle, new_bh);
+
+	spin_lock(&oi->ip_lock);
+	oi->ip_dyn_features |= OCFS2_HAS_REFCOUNT_FL;
+	di->i_dyn_features = cpu_to_le16(oi->ip_dyn_features);
+	di->i_refcount_loc = cpu_to_le64(first_blkno);
+	spin_unlock(&oi->ip_lock);
+
+	mlog(0, "created tree for inode %lu, refblock %llu\n",
+	     inode->i_ino, (unsigned long long)first_blkno);
+
+	ocfs2_journal_dirty(handle, di_bh);
+out_commit:
+	ocfs2_commit_trans(osb, handle);
+out:
+	brelse(new_bh);
+	if (meta_ac)
+		ocfs2_free_alloc_context(meta_ac);
+
+	return ret;
+}
+
+int ocfs2_set_refcount_tree(struct inode *inode,
+			    struct buffer_head *di_bh,
+			    u64 refcount_loc)
+{
+	int ret;
+	handle_t *handle = NULL;
+	struct ocfs2_dinode *di = (struct ocfs2_dinode *)di_bh->b_data;
+	struct ocfs2_inode_info *oi = OCFS2_I(inode);
+	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
+	struct buffer_head *ref_bh = NULL;
+	struct ocfs2_refcount_block *rb;
+
+	BUG_ON(oi->ip_dyn_features & OCFS2_HAS_REFCOUNT_FL);
+	BUG_ON(di->i_refcount_loc);
+
+	ret = ocfs2_read_refcount_block(INODE_CACHE(inode),
+					refcount_loc, &ref_bh);
+	if (ret) {
+		mlog_errno(ret);
+		goto out;
+	}
+
+	handle = ocfs2_start_trans(osb, OCFS2_REFCOUNT_TREE_SET_CREDITS);
+	if (IS_ERR(handle)) {
+		ret = PTR_ERR(handle);
+		mlog_errno(ret);
+		goto out;
+	}
+
+	ret = ocfs2_journal_access_di(handle, INODE_CACHE(inode), di_bh,
+				      OCFS2_JOURNAL_ACCESS_WRITE);
+	if (ret) {
+		mlog_errno(ret);
+		goto out_commit;
+	}
+
+	ret = ocfs2_journal_access_rb(handle, INODE_CACHE(inode), ref_bh,
+				      OCFS2_JOURNAL_ACCESS_WRITE);
+	if (ret) {
+		mlog_errno(ret);
+		goto out_commit;
+	}
+
+	rb = (struct ocfs2_refcount_block *)ref_bh->b_data;
+	le32_add_cpu(&rb->rf_count, 1);
+
+	ocfs2_journal_dirty(handle, ref_bh);
+
+	spin_lock(&oi->ip_lock);
+	oi->ip_dyn_features |= OCFS2_HAS_REFCOUNT_FL;
+	di->i_dyn_features = cpu_to_le16(oi->ip_dyn_features);
+	di->i_refcount_loc = cpu_to_le64(refcount_loc);
+	spin_unlock(&oi->ip_lock);
+	ocfs2_journal_dirty(handle, di_bh);
+out_commit:
+	ocfs2_commit_trans(osb, handle);
+out:
+	brelse(ref_bh);
+
+	return ret;
+}
+
+int ocfs2_remove_refcount_tree(struct inode *inode, struct buffer_head *di_bh)
+{
+	int ret;
+	handle_t *handle = NULL;
+	struct ocfs2_dinode *di = (struct ocfs2_dinode *)di_bh->b_data;
+	struct ocfs2_inode_info *oi = OCFS2_I(inode);
+	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
+	struct ocfs2_refcount_block *rb;
+	struct inode *alloc_inode = NULL;
+	struct buffer_head *alloc_bh = NULL;
+	struct buffer_head *blk_bh = NULL;
+	int credits = OCFS2_INODE_UPDATE_CREDITS + 1;
+	u64 blk = 0, bg_blkno = 0;
+	u16 bit = 0;
+
+	if (!(oi->ip_dyn_features & OCFS2_HAS_REFCOUNT_FL))
+		return 0;
+
+	ret = ocfs2_read_refcount_block(INODE_CACHE(inode),
+					le64_to_cpu(di->i_refcount_loc),
+					&blk_bh);
+	if (ret) {
+		mlog_errno(ret);
+		goto out;
+	}
+
+	rb = (struct ocfs2_refcount_block *)blk_bh->b_data;
+
+	/*
+	 * If we are the last user, we need to free the block.
+	 * So lock the allocator ahead.
+	 */
+	if (le32_to_cpu(rb->rf_count) == 1) {
+		blk = le64_to_cpu(rb->rf_blkno);
+		bit = le16_to_cpu(rb->rf_suballoc_bit);
+		bg_blkno = ocfs2_which_suballoc_group(blk, bit);
+
+		alloc_inode = ocfs2_get_system_file_inode(osb,
+					EXTENT_ALLOC_SYSTEM_INODE,
+					le16_to_cpu(rb->rf_suballoc_slot));
+		if (!alloc_inode) {
+			ret = -ENOMEM;
+			mlog_errno(ret);
+			goto out;
+		}
+		mutex_lock(&alloc_inode->i_mutex);
+
+		ret = ocfs2_inode_lock(alloc_inode, &alloc_bh, 1);
+		if (ret) {
+			mlog_errno(ret);
+			goto out_mutex;
+		}
+
+		credits += OCFS2_SUBALLOC_FREE;
+	}
+
+	handle = ocfs2_start_trans(osb, credits);
+	if (IS_ERR(handle)) {
+		ret = PTR_ERR(handle);
+		mlog_errno(ret);
+		goto out_unlock;
+	}
+
+	ret = ocfs2_journal_access_di(handle, INODE_CACHE(inode), di_bh,
+				      OCFS2_JOURNAL_ACCESS_WRITE);
+	if (ret) {
+		mlog_errno(ret);
+		goto out_commit;
+	}
+
+	ret = ocfs2_journal_access_rb(handle, INODE_CACHE(inode), blk_bh,
+				      OCFS2_JOURNAL_ACCESS_WRITE);
+	if (ret) {
+		mlog_errno(ret);
+		goto out_commit;
+	}
+
+	spin_lock(&oi->ip_lock);
+	oi->ip_dyn_features &= ~OCFS2_HAS_REFCOUNT_FL;
+	di->i_dyn_features = cpu_to_le16(oi->ip_dyn_features);
+	di->i_refcount_loc = 0;
+	spin_unlock(&oi->ip_lock);
+	ocfs2_journal_dirty(handle, di_bh);
+
+	le32_add_cpu(&rb->rf_count , -1);
+	ocfs2_journal_dirty(handle, blk_bh);
+
+	if (!rb->rf_count) {
+		ret = ocfs2_free_suballoc_bits(handle, alloc_inode,
+					       alloc_bh, bit, bg_blkno, 1);
+		if (ret)
+			mlog_errno(ret);
+	}
+
+out_commit:
+	ocfs2_commit_trans(osb, handle);
+out_unlock:
+	if (alloc_inode) {
+		ocfs2_inode_unlock(alloc_inode, 1);
+		brelse(alloc_bh);
+	}
+out_mutex:
+	if (alloc_inode) {
+		mutex_unlock(&alloc_inode->i_mutex);
+		iput(alloc_inode);
+	}
+out:
+	brelse(blk_bh);
+
+	return ret;
+}
diff --git a/fs/ocfs2/refcounttree.h b/fs/ocfs2/refcounttree.h
new file mode 100644
index 0000000..9f4bdac
--- /dev/null
+++ b/fs/ocfs2/refcounttree.h
@@ -0,0 +1,26 @@
+/* -*- mode: c; c-basic-offset: 8; -*-
+ * vim: noexpandtab sw=8 ts=8 sts=0:
+ *
+ * refcounttree.h
+ *
+ * Copyright (C) 2004, 2009 Oracle.  All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public
+ * License version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ */
+#ifndef OCFS2_REFCOUNTTREE_H
+#define OCFS2_REFCOUNTTREE_H
+
+int ocfs2_create_refcount_tree(struct inode *inode, struct buffer_head *di_bh);
+int ocfs2_set_refcount_tree(struct inode *inode,
+			    struct buffer_head *di_bh,
+			    u64 blkno);
+int ocfs2_remove_refcount_tree(struct inode *inode, struct buffer_head *di_bh);
+
+#endif /* OCFS2_REFCOUNTTREE_H */
-- 
1.6.2.rc2.16.gf474c
