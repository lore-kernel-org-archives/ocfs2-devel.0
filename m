From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Wed Jan 16 11:33:09 2008
Subject: [Ocfs2-devel] [PATCH 15/20] ocfs2: reverse inline-data truncate args
In-Reply-To: <1200511977-19513-1-git-send-email-sunil.mushran@oracle.com>
References: <1200511977-19513-1-git-send-email-sunil.mushran@oracle.com>
Message-ID: <1200511977-19513-16-git-send-email-sunil.mushran@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Mainline commit b1967d0eddeef4869ee283e692735cb994f3745a
Author: Mark Fasheh <mark.fasheh@oracle.com>
Date: Tue, 20 Nov 2007 11:56:39 -0800

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
index a6a93b1..6d1ef46 100644
--- a/fs/ocfs2/file.c
+++ b/fs/ocfs2/file.c
@@ -403,7 +403,7 @@ static int ocfs2_truncate_file(struct inode *inode,
 
 	if (OCFS2_I(inode)->ip_dyn_features & OCFS2_INLINE_DATA_FL) {
 		status = ocfs2_truncate_inline(inode, di_bh, new_i_size,
-					       i_size_read(inode), 0);
+					       i_size_read(inode), 1);
 		if (status)
 			mlog_errno(status);
 
@@ -1525,6 +1525,7 @@ static int ocfs2_remove_inode_range(struct inode *inode,
 	u32 trunc_start, trunc_len, cpos, phys_cpos, alloc_size;
 	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
 	struct ocfs2_cached_dealloc_ctxt dealloc;
+	struct address_space *mapping = inode->i_mapping;
 
 	ocfs2_init_dealloc_ctxt(&dealloc);
 
@@ -1533,10 +1534,20 @@ static int ocfs2_remove_inode_range(struct inode *inode,
 
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
