From: Tristan Ye <tristan.ye@oracle.com>
Date: Thu,  6 May 2010 14:50:16 +0800
Subject: [Ocfs2-devel] [PATCH 2/4] Ocfs2: Fix punching hole codes to
	correctly do CoW during cluster zeroing.
In-Reply-To: <1273128618-4184-1-git-send-email-tristan.ye@oracle.com>
References: <1273128618-4184-1-git-send-email-tristan.ye@oracle.com>
Message-ID: <1273128618-4184-2-git-send-email-tristan.ye@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Based on the former patch of truncating optimization, bugfix for refcount on
punching holes can be fairly easy and straightforward since most of work we
should take into account for refcounting have been completed already in func
ocfs2_remove_btree_range(), which is also being used by our truncating codes.

The patch just did CoW for reflinks when a hole is being punched whose start
and end offset were within one cluster, which means partial zeroing for a cluster
will be performed soon.

The patch has been tested fixing the following bug:

http://oss.oracle.com/bugzilla/show_bug.cgi?id=1216

Signed-off-by: Tristan Ye <tristan.ye@oracle.com>
---
 fs/ocfs2/file.c |   30 +++++++++++++++++++++++++++---
 1 files changed, 27 insertions(+), 3 deletions(-)

diff --git a/fs/ocfs2/file.c b/fs/ocfs2/file.c
index 491341a..b8358e4 100644
--- a/fs/ocfs2/file.c
+++ b/fs/ocfs2/file.c
@@ -1422,12 +1422,14 @@ static int ocfs2_remove_inode_range(struct inode *inode,
 				    struct buffer_head *di_bh, u64 byte_start,
 				    u64 byte_len)
 {
-	int ret = 0;
+	int ret = 0, flags = 0;
 	u32 trunc_start, trunc_len, cpos, phys_cpos, alloc_size;
 	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
 	struct ocfs2_cached_dealloc_ctxt dealloc;
 	struct address_space *mapping = inode->i_mapping;
 	struct ocfs2_extent_tree et;
+	struct ocfs2_dinode *di = (struct ocfs2_dinode *)di_bh->b_data;
+	u64 refcount_loc = le64_to_cpu(di->i_refcount_loc);
 
 	ocfs2_init_dinode_extent_tree(&et, INODE_CACHE(inode), di_bh);
 	ocfs2_init_dealloc_ctxt(&dealloc);
@@ -1453,6 +1455,27 @@ static int ocfs2_remove_inode_range(struct inode *inode,
 		goto out;
 	}
 
+	/*
+	 * For reflinks, we may need to CoW 2 clusters which might be
+	 * partially zero'd later, if hole's start and end offset were
+	 * within one cluster(means is not exactly aligned to clustersize).
+	 */
+
+	if (OCFS2_I(inode)->ip_dyn_features & OCFS2_HAS_REFCOUNT_FL) {
+
+		ret = ocfs2_cow_file_pos(inode, di_bh, byte_start);
+		if (ret) {
+			mlog_errno(ret);
+			goto out;
+		}
+
+		ret = ocfs2_cow_file_pos(inode, di_bh, byte_start + byte_len);
+		if (ret) {
+			mlog_errno(ret);
+			goto out;
+		}
+	}
+
 	trunc_start = ocfs2_clusters_for_bytes(osb->sb, byte_start);
 	trunc_len = (byte_start + byte_len) >> osb->s_clustersize_bits;
 	if (trunc_len >= trunc_start)
@@ -1474,7 +1497,7 @@ static int ocfs2_remove_inode_range(struct inode *inode,
 	cpos = trunc_start;
 	while (trunc_len) {
 		ret = ocfs2_get_clusters(inode, cpos, &phys_cpos,
-					 &alloc_size, NULL);
+					 &alloc_size, &flags);
 		if (ret) {
 			mlog_errno(ret);
 			goto out;
@@ -1487,7 +1510,8 @@ static int ocfs2_remove_inode_range(struct inode *inode,
 		if (phys_cpos != 0) {
 			ret = ocfs2_remove_btree_range(inode, &et, cpos,
 						       phys_cpos, alloc_size,
-						       &dealloc, 0 , 0);
+						       &dealloc, refcount_loc,
+						       flags);
 			if (ret) {
 				mlog_errno(ret);
 				goto out;
-- 
1.5.5
