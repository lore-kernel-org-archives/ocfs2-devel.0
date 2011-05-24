From: Tristan Ye <tristan.ye@oracle.com>
Date: Tue, 24 May 2011 18:53:44 +0800
Subject: [Ocfs2-devel] [PATCH 10/15] Ocfs2/move_extents: helpers to update
	the group descriptor and global bitmap inode.
In-Reply-To: <1306234429-28078-1-git-send-email-tristan.ye@oracle.com>
References: <1306234429-28078-1-git-send-email-tristan.ye@oracle.com>
Message-ID: <1306234429-28078-11-git-send-email-tristan.ye@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

These helpers were actually borrowed from alloc.c, which may be publicated
later.

Signed-off-by: Tristan Ye <tristan.ye@oracle.com>
---
 fs/ocfs2/move_extents.c |   77 +++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 77 insertions(+), 0 deletions(-)

diff --git a/fs/ocfs2/move_extents.c b/fs/ocfs2/move_extents.c
index 6895318..20822ef 100644
--- a/fs/ocfs2/move_extents.c
+++ b/fs/ocfs2/move_extents.c
@@ -555,3 +555,80 @@ static void ocfs2_probe_alloc_group(struct inode *inode, struct buffer_head *bh,
 
 	mlog(0, "found phys_cpos: %u to fit the wanted moving.\n", *phys_cpos);
 }
+
+static int ocfs2_alloc_dinode_update_counts(struct inode *inode,
+				       handle_t *handle,
+				       struct buffer_head *di_bh,
+				       u32 num_bits,
+				       u16 chain)
+{
+	int ret;
+	u32 tmp_used;
+	struct ocfs2_dinode *di = (struct ocfs2_dinode *) di_bh->b_data;
+	struct ocfs2_chain_list *cl =
+				(struct ocfs2_chain_list *) &di->id2.i_chain;
+
+	ret = ocfs2_journal_access_di(handle, INODE_CACHE(inode), di_bh,
+				      OCFS2_JOURNAL_ACCESS_WRITE);
+	if (ret < 0) {
+		mlog_errno(ret);
+		goto out;
+	}
+
+	tmp_used = le32_to_cpu(di->id1.bitmap1.i_used);
+	di->id1.bitmap1.i_used = cpu_to_le32(num_bits + tmp_used);
+	le32_add_cpu(&cl->cl_recs[chain].c_free, -num_bits);
+	ocfs2_journal_dirty(handle, di_bh);
+
+out:
+	return ret;
+}
+
+static inline int ocfs2_block_group_set_bits(handle_t *handle,
+					     struct inode *alloc_inode,
+					     struct ocfs2_group_desc *bg,
+					     struct buffer_head *group_bh,
+					     unsigned int bit_off,
+					     unsigned int num_bits)
+{
+	int status;
+	void *bitmap = bg->bg_bitmap;
+	int journal_type = OCFS2_JOURNAL_ACCESS_WRITE;
+
+	/* All callers get the descriptor via
+	 * ocfs2_read_group_descriptor().  Any corruption is a code bug. */
+	BUG_ON(!OCFS2_IS_VALID_GROUP_DESC(bg));
+	BUG_ON(le16_to_cpu(bg->bg_free_bits_count) < num_bits);
+
+	mlog(0, "block_group_set_bits: off = %u, num = %u\n", bit_off,
+	     num_bits);
+
+	if (ocfs2_is_cluster_bitmap(alloc_inode))
+		journal_type = OCFS2_JOURNAL_ACCESS_UNDO;
+
+	status = ocfs2_journal_access_gd(handle,
+					 INODE_CACHE(alloc_inode),
+					 group_bh,
+					 journal_type);
+	if (status < 0) {
+		mlog_errno(status);
+		goto bail;
+	}
+
+	le16_add_cpu(&bg->bg_free_bits_count, -num_bits);
+	if (le16_to_cpu(bg->bg_free_bits_count) > le16_to_cpu(bg->bg_bits)) {
+		ocfs2_error(alloc_inode->i_sb, "Group descriptor # %llu has bit"
+			    " count %u but claims %u are freed. num_bits %d",
+			    (unsigned long long)le64_to_cpu(bg->bg_blkno),
+			    le16_to_cpu(bg->bg_bits),
+			    le16_to_cpu(bg->bg_free_bits_count), num_bits);
+		return -EROFS;
+	}
+	while (num_bits--)
+		ocfs2_set_bit(bit_off++, bitmap);
+
+	ocfs2_journal_dirty(handle, group_bh);
+
+bail:
+	return status;
+}
-- 
1.5.5
