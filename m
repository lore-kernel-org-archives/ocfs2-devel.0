From: Joel Becker <joel.becker@oracle.com>
Date: Fri, 13 Feb 2009 14:15:57 -0800
Subject: [Ocfs2-devel] [PATCH 10/40] ocfs2: ocfs2_create_new_meta_bhs()
	doesn't need struct inode.
In-Reply-To: <1234563387-17101-1-git-send-email-joel.becker@oracle.com>
References: <1234563387-17101-1-git-send-email-joel.becker@oracle.com>
Message-ID: <1234563387-17101-11-git-send-email-joel.becker@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Pass struct ocfs2_extent_tree into ocfs2_create_new_meta_bhs().  It no
longer needs struct inode or ocfs2_super.

Signed-off-by: Joel Becker <joel.becker@oracle.com>
---
 fs/ocfs2/alloc.c |   17 +++++++++--------
 1 files changed, 9 insertions(+), 8 deletions(-)

diff --git a/fs/ocfs2/alloc.c b/fs/ocfs2/alloc.c
index 40fa2d9..cf6c7e4 100644
--- a/fs/ocfs2/alloc.c
+++ b/fs/ocfs2/alloc.c
@@ -850,9 +850,8 @@ bail:
  * sets h_signature, h_blkno, h_suballoc_bit, h_suballoc_slot, and
  * l_count for you
  */
-static int ocfs2_create_new_meta_bhs(struct ocfs2_super *osb,
-				     handle_t *handle,
-				     struct inode *inode,
+static int ocfs2_create_new_meta_bhs(handle_t *handle,
+				     struct ocfs2_extent_tree *et,
 				     int wanted,
 				     struct ocfs2_alloc_context *meta_ac,
 				     struct buffer_head *bhs[])
@@ -861,6 +860,8 @@ static int ocfs2_create_new_meta_bhs(struct ocfs2_super *osb,
 	u16 suballoc_bit_start;
 	u32 num_got;
 	u64 first_blkno;
+	struct ocfs2_super *osb =
+		OCFS2_SB(ocfs2_metadata_cache_get_super(et->et_ci));
 	struct ocfs2_extent_block *eb;
 
 	mlog_entry_void();
@@ -886,10 +887,10 @@ static int ocfs2_create_new_meta_bhs(struct ocfs2_super *osb,
 				mlog_errno(status);
 				goto bail;
 			}
-			ocfs2_set_new_buffer_uptodate(INODE_CACHE(inode),
-						      bhs[i]);
+			ocfs2_set_new_buffer_uptodate(et->et_ci, bhs[i]);
 
-			status = ocfs2_journal_access_eb(handle, INODE_CACHE(inode), bhs[i],
+			status = ocfs2_journal_access_eb(handle, et->et_ci,
+							 bhs[i],
 							 OCFS2_JOURNAL_ACCESS_CREATE);
 			if (status < 0) {
 				mlog_errno(status);
@@ -1008,7 +1009,7 @@ static int ocfs2_add_branch(struct ocfs2_super *osb,
 		goto bail;
 	}
 
-	status = ocfs2_create_new_meta_bhs(osb, handle, inode, new_blocks,
+	status = ocfs2_create_new_meta_bhs(handle, et, new_blocks,
 					   meta_ac, new_eb_bhs);
 	if (status < 0) {
 		mlog_errno(status);
@@ -1162,7 +1163,7 @@ static int ocfs2_shift_tree_depth(struct ocfs2_super *osb,
 
 	mlog_entry_void();
 
-	status = ocfs2_create_new_meta_bhs(osb, handle, inode, 1, meta_ac,
+	status = ocfs2_create_new_meta_bhs(handle, et, 1, meta_ac,
 					   &new_eb_bh);
 	if (status < 0) {
 		mlog_errno(status);
-- 
1.5.6.5
