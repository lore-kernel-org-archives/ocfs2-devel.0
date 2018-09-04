From: Larry Chen <lchen@suse.com>
Date: Tue,  4 Sep 2018 12:16:21 +0800
Subject: [Ocfs2-devel] [PATCH 2/2] fix clusters leak in ocfs2_defrag_extent
In-Reply-To: <20180904041621.16874-1-lchen@suse.com>
References: <20180904041621.16874-1-lchen@suse.com>
Message-ID: <20180904041621.16874-3-lchen@suse.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: mark@fasheh.com, jlbec@evilplan.org
Cc: linux-kernel@vger.kernel.org, ocfs2-devel@oss.oracle.com, akpm@linux-foundation.org

Signed-off-by: Larry Chen <lchen@suse.com>
---
 fs/ocfs2/move_extents.c | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/fs/ocfs2/move_extents.c b/fs/ocfs2/move_extents.c
index d85dc8a02bd6..4f2ad054b419 100644
--- a/fs/ocfs2/move_extents.c
+++ b/fs/ocfs2/move_extents.c
@@ -226,6 +226,8 @@ static int ocfs2_defrag_extent(struct ocfs2_move_extents_context *context,
 	struct ocfs2_refcount_tree *ref_tree = NULL;
 	u32 new_phys_cpos, new_len;
 	u64 phys_blkno = ocfs2_clusters_to_blocks(inode->i_sb, phys_cpos);
+	int need_free = 0;
+	struct ocfs2_alloc_context *data_ac;
 
 	if ((ext_flags & OCFS2_EXT_REFCOUNTED) && *len) {
 		BUG_ON(!ocfs2_is_refcount_inode(inode));
@@ -317,6 +319,7 @@ static int ocfs2_defrag_extent(struct ocfs2_move_extents_context *context,
 		if (!partial) {
 			context->range->me_flags &= ~OCFS2_MOVE_EXT_FL_COMPLETE;
 			ret = -ENOSPC;
+			need_free = 1;
 			goto out_commit;
 		}
 	}
@@ -341,6 +344,19 @@ static int ocfs2_defrag_extent(struct ocfs2_move_extents_context *context,
 		mlog_errno(ret);
 
 out_commit:
+	if (need_free && context->data_ac) {
+		data_ac = context->data_ac;
+		if (context->data_ac->ac_which == OCFS2_AC_USE_LOCAL)
+			ocfs2_free_local_alloc_bits(osb, handle, data_ac,
+					new_phys_cpos, new_len);
+		else
+			ocfs2_free_clusters(handle,
+					data_ac->ac_inode,
+					data_ac->ac_bh,
+					ocfs2_clusters_to_blocks(osb->sb, new_phys_cpos),
+					new_len);
+	}
+
 	ocfs2_commit_trans(osb, handle);
 
 out_unlock_mutex:
-- 
2.13.7
