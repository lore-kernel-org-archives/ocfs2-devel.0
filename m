From: Mark Fasheh <mark.fasheh@oracle.com>
Date: Tue Nov 20 12:09:59 2007
Subject: [Ocfs2-devel] [PATCH] ocfs2: reverse inline-data truncate args
Message-ID: <20071120200806.GE28607@ca-server1.us.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

ocfs2_truncate() and ocfs2_remove_inode_range() had reversed their "set
i_size" arguments to ocfs2_truncate_inline(). Fix things so that truncate
sets i_size, and punching a hole ignores it.

This exposed a problem where punching a hole in an inline-data file wasn't
updating the page cache, so fix that too.

Signed-off-by: Mark Fasheh <mark.fasheh@oracle.com>
---
 fs/ocfs2/file.c |   19 +++++++++++++++----
 1 files changed, 15 insertions(+), 4 deletions(-)

diff --git a/fs/ocfs2/file.c b/fs/ocfs2/file.c
index bbac7cd..b75b2e1 100644
--- a/fs/ocfs2/file.c
+++ b/fs/ocfs2/file.c
@@ -399,7 +399,7 @@ static int ocfs2_truncate_file(struct inode *inode,
 
 	if (OCFS2_I(inode)->ip_dyn_features & OCFS2_INLINE_DATA_FL) {
 		status = ocfs2_truncate_inline(inode, di_bh, new_i_size,
-					       i_size_read(inode), 0);
+					       i_size_read(inode), 1);
 		if (status)
 			mlog_errno(status);
 
@@ -1521,6 +1521,7 @@ static int ocfs2_remove_inode_range(struct inode *inode,
 	u32 trunc_start, trunc_len, cpos, phys_cpos, alloc_size;
 	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
 	struct ocfs2_cached_dealloc_ctxt dealloc;
+	struct address_space *mapping = inode->i_mapping;
 
 	ocfs2_init_dealloc_ctxt(&dealloc);
 
@@ -1529,10 +1530,20 @@ static int ocfs2_remove_inode_range(struct inode *inode,
 
 	if (OCFS2_I(inode)->ip_dyn_features & OCFS2_INLINE_DATA_FL) {
 		ret = ocfs2_truncate_inline(inode, di_bh, byte_start,
-					    byte_start + byte_len, 1);
-		if (ret)
+					    byte_start + byte_len, 0);
+		if (ret) {
 			mlog_errno(ret);
-		return ret;
+			goto out;
+		}
+		/*
+		 * There's no need to get fancy with the page cache
+		 * truncate of an inline-data inode. We're talking
+		 * about less than a page here, which will be cached
+		 * in the dinode buffer anyway.
+		 */
+		unmap_mapping_range(mapping, 0, 0, 0);
+		truncate_inode_pages(mapping, 0);
+		goto out;
 	}
 
 	trunc_start = ocfs2_clusters_for_bytes(osb->sb, byte_start);
-- 
1.5.3.4
