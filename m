From: Tristan Ye <tristan.ye@oracle.com>
Date: Thu, 13 Jan 2011 18:20:20 +0800
Subject: [Ocfs2-devel] [PATCH 8/8] Ocfs2: move/defrag extents within a
	certain range.
In-Reply-To: <1294914020-21628-1-git-send-email-tristan.ye@oracle.com>
References: <1294914020-21628-1-git-send-email-tristan.ye@oracle.com>
Message-ID: <1294914020-21628-9-git-send-email-tristan.ye@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

The basic logic of moving extents for a file is pretty like punching-hole
sequence, walk the extents within the range as user specified, calculating
an appropriate len to defrag/move, then let ocfs2_defrag/move_extent() to
do the actual moving.

This func ends up setting 'OCFS2_MOVE_EXT_FL_COMPLETE' to userpace if operation
gets done successfully.

Signed-off-by: Tristan Ye <tristan.ye@oracle.com>
---
 fs/ocfs2/move_extents.c |  169 +++++++++++++++++++++++++++++++++++++++++++++--
 1 files changed, 164 insertions(+), 5 deletions(-)

diff --git a/fs/ocfs2/move_extents.c b/fs/ocfs2/move_extents.c
index ce97c76..dd5b995 100644
--- a/fs/ocfs2/move_extents.c
+++ b/fs/ocfs2/move_extents.c
@@ -817,6 +817,167 @@ out:
 	return ret;
 }
 
+/*
+ * Helper to calculate the defraging length in one run according to threshold.
+ */
+static void ocfs2_calc_extent_defrag_len(u32 *alloc_size, u32 *len_defraged,
+					 u32 threshold, int *skip)
+{
+	if ((*alloc_size + *len_defraged) < threshold) {
+		/*
+		 * proceed defragmentation until we meet the thresh
+		 */
+		*len_defraged += *alloc_size;
+	} else if (*len_defraged == 0) {
+		/*
+		 * XXX: skip a large extent.
+		 */
+		*skip = 1;
+	} else {
+		/*
+		 * split this extent to coalesce with former pieces as
+		 * to reach the threshold.
+		 *
+		 * we're done here with one cycle of defragmentation
+		 * in a size of 'thresh', resetting 'len_defraged'
+		 * forces a new defragmentation.
+		 */
+		*alloc_size = threshold - *len_defraged;
+		*len_defraged = 0;
+	}
+}
+
+static int __ocfs2_move_extents_range(struct buffer_head *di_bh,
+				struct ocfs2_move_extents_context *context)
+{
+	int ret, flags, do_defrag, skip = 0;
+	u32 cpos, phys_cpos, move_start, len_to_move, alloc_size;
+	u32 len_defraged = 0, defrag_thresh, new_phys_cpos = 0;
+
+	struct inode *inode = context->inode;
+	struct ocfs2_move_extents *range = context->range;
+	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
+
+	if ((inode->i_size == 0) || (range->me_len == 0))
+		return 0;
+
+	if (OCFS2_I(inode)->ip_dyn_features & OCFS2_INLINE_DATA_FL)
+		return 0;
+
+	ocfs2_init_dinode_extent_tree(&context->et, INODE_CACHE(inode), di_bh);
+	ocfs2_init_dealloc_ctxt(&context->dealloc);
+
+	/*
+	 * TO-DO XXX:
+	 *
+	 * - refcount tree.
+	 * - xattr extents.
+	 */
+
+	do_defrag = context->auto_defrag;
+
+	/*
+	 * extents moving happens in unit of clusters, for the sake
+	 * of simplicity, we may ignore two clusters where 'byte_start'
+	 * and 'byte_start + len' were within.
+	 */
+	move_start = ocfs2_clusters_for_bytes(osb->sb, range->me_start);
+	len_to_move = (range->me_start + range->me_len) >>
+						osb->s_clustersize_bits;
+	if (len_to_move >= move_start)
+		len_to_move -= move_start;
+	else
+		len_to_move = 0;
+
+	if (do_defrag)
+		defrag_thresh = range->me_thresh >> osb->s_clustersize_bits;
+	else
+		new_phys_cpos = ocfs2_blocks_to_clusters(inode->i_sb,
+							 range->me_goal);
+
+	mlog(0, "Inode: %llu, start: %llu, len: %llu, cstart: %u, clen: %u, "
+	     "thresh: %u\n",
+	     (unsigned long long)OCFS2_I(inode)->ip_blkno,
+	     (unsigned long long)range->me_start,
+	     (unsigned long long)range->me_len,
+	     move_start, len_to_move, defrag_thresh);
+
+	cpos = move_start;
+	while (len_to_move) {
+		ret = ocfs2_get_clusters(inode, cpos, &phys_cpos, &alloc_size,
+					 &flags);
+		if (ret) {
+			mlog_errno(ret);
+			goto out;
+		}
+
+		if (alloc_size > len_to_move)
+			alloc_size = len_to_move;
+
+		/*
+		 * XXX: how to deal with a hole:
+		 *
+		 * - skip the hole of course
+		 * - force a new defragmentation
+		 */
+		if (!phys_cpos) {
+			if (do_defrag)
+				len_defraged = 0;
+
+			goto next;
+		}
+
+		if (do_defrag) {
+			ocfs2_calc_extent_defrag_len(&alloc_size, &len_defraged,
+						     defrag_thresh, &skip);
+			/*
+			 * skip large extents
+			 */
+			if (skip) {
+				skip = 0;
+				goto next;
+			}
+
+			mlog(0, "#Defrag: cpos: %u, phys_cpos: %u, "
+			     "alloc_size: %u, len_defraged: %u\n",
+			     cpos, phys_cpos, alloc_size, len_defraged);
+
+			ret = ocfs2_defrag_extent(context, cpos, phys_cpos,
+						  alloc_size, flags);
+		} else {
+			ret = ocfs2_move_extent(context, cpos, phys_cpos,
+						&new_phys_cpos, alloc_size,
+						flags);
+
+			new_phys_cpos += alloc_size;
+		}
+
+		if (ret < 0) {
+			mlog_errno(ret);
+			goto out;
+		}
+
+		context->clusters_moved += alloc_size;
+next:
+		cpos += alloc_size;
+		len_to_move -= alloc_size;
+	}
+
+	range->me_flags |= OCFS2_MOVE_EXT_FL_COMPLETE;
+
+out:
+	range->me_moved_len = ocfs2_clusters_to_bytes(osb->sb,
+						      context->clusters_moved);
+	range->me_new_offset = ocfs2_clusters_to_bytes(osb->sb,
+						       context->new_phys_cpos);
+
+	ocfs2_schedule_truncate_log_flush(osb, 1);
+	ocfs2_run_deallocs(osb, &context->dealloc);
+
+	return ret;
+}
+
+
 static int ocfs2_move_extents(struct ocfs2_move_extents_context *context)
 {
 	int status;
@@ -853,11 +1014,9 @@ static int ocfs2_move_extents(struct ocfs2_move_extents_context *context)
 	 * rememer ip_xattr_sem also needs to be held if necessary
 	 */
 	down_write(&OCFS2_I(inode)->ip_alloc_sem);
-	/*
-	 * real extents moving codes will be fulfilled later.
-	 * 
-	 * status = __ocfs2_move_extents_range(di_bh, context);
-	 */
+
+	status = __ocfs2_move_extents_range(di_bh, context);
+
 	up_write(&OCFS2_I(inode)->ip_alloc_sem);
 	if (status) {
 		mlog_errno(status);
-- 
1.5.5
