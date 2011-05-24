From: Tristan Ye <tristan.ye@oracle.com>
Date: Tue, 24 May 2011 18:53:41 +0800
Subject: [Ocfs2-devel] [PATCH 07/15] Ocfs2/move_extents: find the victim
	alloc group, where the given #blk fits.
In-Reply-To: <1306234429-28078-1-git-send-email-tristan.ye@oracle.com>
References: <1306234429-28078-1-git-send-email-tristan.ye@oracle.com>
Message-ID: <1306234429-28078-8-git-send-email-tristan.ye@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

This function tries locate the right alloc group, where a given physical block
resides, it returns the caller a buffer_head of victim group descriptor, and also
the offset of block in this group, by passing the block number.

Signed-off-by: Tristan Ye <tristan.ye@oracle.com>
---
 fs/ocfs2/move_extents.c |  104 +++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 104 insertions(+), 0 deletions(-)

diff --git a/fs/ocfs2/move_extents.c b/fs/ocfs2/move_extents.c
index 200151f..f814850 100644
--- a/fs/ocfs2/move_extents.c
+++ b/fs/ocfs2/move_extents.c
@@ -351,3 +351,107 @@ out:
 
 	return ret;
 }
+
+/*
+ * find the victim alloc group, where #blkno fits.
+ */
+static int ocfs2_find_victim_alloc_group(struct inode *inode,
+					 u64 vict_blkno,
+					 int type, int slot,
+					 int *vict_bit,
+					 struct buffer_head **ret_bh)
+{
+	int ret, i, blocks_per_unit = 1;
+	u64 blkno;
+	char namebuf[40];
+
+	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
+	struct buffer_head *ac_bh = NULL, *gd_bh = NULL;
+	struct ocfs2_chain_list *cl;
+	struct ocfs2_chain_rec *rec;
+	struct ocfs2_dinode *ac_dinode;
+	struct ocfs2_group_desc *bg;
+
+	ocfs2_sprintf_system_inode_name(namebuf, sizeof(namebuf), type, slot);
+	ret = ocfs2_lookup_ino_from_name(osb->sys_root_inode, namebuf,
+					 strlen(namebuf), &blkno);
+	if (ret) {
+		ret = -ENOENT;
+		goto out;
+	}
+
+	ret = ocfs2_read_blocks_sync(osb, blkno, 1, &ac_bh);
+	if (ret) {
+		mlog_errno(ret);
+		goto out;
+	}
+
+	ac_dinode = (struct ocfs2_dinode *)ac_bh->b_data;
+	cl = &(ac_dinode->id2.i_chain);
+	rec = &(cl->cl_recs[0]);
+
+	if (type == GLOBAL_BITMAP_SYSTEM_INODE)
+		blocks_per_unit <<= (osb->s_clustersize_bits -
+						inode->i_sb->s_blocksize_bits);
+	/*
+	 * 'vict_blkno' was out of the valid range.
+	 */
+	if ((vict_blkno < le64_to_cpu(rec->c_blkno)) ||
+	    (vict_blkno >= (le32_to_cpu(ac_dinode->id1.bitmap1.i_total) *
+				blocks_per_unit))) {
+		ret = -EINVAL;
+		goto out;
+	}
+
+	for (i = 0; i < le16_to_cpu(cl->cl_next_free_rec); i++) {
+
+		rec = &(cl->cl_recs[i]);
+		if (!rec)
+			continue;
+
+		bg = NULL;
+
+		do {
+			if (!bg)
+				blkno = le64_to_cpu(rec->c_blkno);
+			else
+				blkno = le64_to_cpu(bg->bg_next_group);
+
+			if (gd_bh) {
+				brelse(gd_bh);
+				gd_bh = NULL;
+			}
+
+			ret = ocfs2_read_blocks_sync(osb, blkno, 1, &gd_bh);
+			if (ret) {
+				mlog_errno(ret);
+				goto out;
+			}
+
+			bg = (struct ocfs2_group_desc *)gd_bh->b_data;
+
+			if (vict_blkno < (le64_to_cpu(bg->bg_blkno) +
+						le16_to_cpu(bg->bg_bits))) {
+
+				*ret_bh = gd_bh;
+				*vict_bit = (vict_blkno - blkno) /
+							blocks_per_unit;
+				mlog(0, "find the victim group: #%llu, "
+				     "total_bits: %u, vict_bit: %u\n",
+				     blkno, le16_to_cpu(bg->bg_bits),
+				     *vict_bit);
+				goto out;
+			}
+
+		} while (le64_to_cpu(bg->bg_next_group));
+	}
+
+	ret = -EINVAL;
+out:
+	brelse(ac_bh);
+
+	/*
+	 * caller has to release the gd_bh properly.
+	 */
+	return ret;
+}
-- 
1.5.5
