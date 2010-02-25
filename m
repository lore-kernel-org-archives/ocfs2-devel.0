From: Tristan Ye <tristan.ye@oracle.com>
Date: Thu, 25 Feb 2010 17:49:08 +0800
Subject: [Ocfs2-devel] [PATCH 1/1] Ocfs2: Optimize punching-hole codes v2.
Message-ID: <1267091348-26923-1-git-send-email-tristan.ye@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Changes from v1 to v2:

1. Patch was rebased on Joel's fixes kernel branch.

2. Fix a bug when punching hole in the range where a old hole
   exists already.

V2 patch has survived with fill_verify_holes testcase in ocfs2-test,
it also passed my manual sanity check and stress tests with enormous
extent records, besides, corner testcases also succeeded.

Currently punching hole on a file with 3+ extent tree depth was
really a performance disaster, it even caused several hours to
go, though we may not hit this in real life with such a huge extent
number.

One simple way to improve the performance is quite straightforward,
by learning the logic of truncating codes, means we'd punch hole from
hole_end to hole_start, which reduce the overhead of btree operation
in a significant way, such as tree rotation and moving.

Following is the testing result when punching hole from 0 to file end
in bytes, on a 1G file, 1G file consists of 256k extent records, each record
cover 4k data(just one cluster, clustersize is 4k):

#time ./punch_hole /storage/testfile  0 1073741824

===========================================================================
 * Former punching-hole mechanism:
===========================================================================

   I waited 1 hour for its completion, unfortunately it's still ongoing.

===========================================================================
 * Patched punching-hode mechanism:
===========================================================================

   real	0m2.518s
   user	0m0.000s
   sys	0m2.445s

That means we've gained up to 1000 times improvement on performance in this
case, whee! It's fairly cool. and it looks like that performance gain will
be raising when extent records grow.

The patch was based on my former 2 patches, which were about truncating
codes optimization and fixup to handle CoW on punching hole.

Signed-off-by: Tristan Ye <tristan.ye@oracle.com>
---
 fs/ocfs2/file.c |  146 +++++++++++++++++++++++++++++++++++++++++++------------
 1 files changed, 114 insertions(+), 32 deletions(-)

diff --git a/fs/ocfs2/file.c b/fs/ocfs2/file.c
index db2e0c9..0f00c15 100644
--- a/fs/ocfs2/file.c
+++ b/fs/ocfs2/file.c
@@ -1427,14 +1427,18 @@ static int ocfs2_remove_inode_range(struct inode *inode,
 				    struct buffer_head *di_bh, u64 byte_start,
 				    u64 byte_len)
 {
-	int ret = 0, flags = 0;
-	u32 trunc_start, trunc_len, cpos, phys_cpos, alloc_size;
+	int ret = 0, flags = 0, i;
+	u32 trunc_start, trunc_len, trunc_end, trunc_cpos, phys_cpos;
+	u32 range, coff, cluster_within_list;
 	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
 	struct ocfs2_cached_dealloc_ctxt dealloc;
 	struct address_space *mapping = inode->i_mapping;
 	struct ocfs2_extent_tree et;
+	struct ocfs2_path *path = NULL;
+	struct ocfs2_extent_list *el = NULL;
+	struct ocfs2_extent_rec *rec = NULL;
 	struct ocfs2_dinode *di = (struct ocfs2_dinode *)di_bh->b_data;
-	u64 refcount_loc = le64_to_cpu(di->i_refcount_loc);
+	u64 blkno, refcount_loc = le64_to_cpu(di->i_refcount_loc);
 
 	ocfs2_init_dinode_extent_tree(&et, INODE_CACHE(inode), di_bh);
 	ocfs2_init_dealloc_ctxt(&dealloc);
@@ -1482,16 +1486,13 @@ static int ocfs2_remove_inode_range(struct inode *inode,
 	}
 
 	trunc_start = ocfs2_clusters_for_bytes(osb->sb, byte_start);
-	trunc_len = (byte_start + byte_len) >> osb->s_clustersize_bits;
-	if (trunc_len >= trunc_start)
-		trunc_len -= trunc_start;
-	else
-		trunc_len = 0;
+	trunc_end = (byte_start + byte_len) >> osb->s_clustersize_bits;
+	cluster_within_list = trunc_end;
 
-	mlog(0, "Inode: %llu, start: %llu, len: %llu, cstart: %u, clen: %u\n",
+	mlog(0, "Inode: %llu, start: %llu, len: %llu, cstart: %u, cend: %u\n",
 	     (unsigned long long)OCFS2_I(inode)->ip_blkno,
 	     (unsigned long long)byte_start,
-	     (unsigned long long)byte_len, trunc_start, trunc_len);
+	     (unsigned long long)byte_len, trunc_start, trunc_end);
 
 	ret = ocfs2_zero_partial_clusters(inode, byte_start, byte_len);
 	if (ret) {
@@ -1499,34 +1500,115 @@ static int ocfs2_remove_inode_range(struct inode *inode,
 		goto out;
 	}
 
-	cpos = trunc_start;
-	while (trunc_len) {
-		ret = ocfs2_get_clusters(inode, cpos, &phys_cpos,
-					 &alloc_size, &flags);
-		if (ret) {
-			mlog_errno(ret);
-			goto out;
-		}
+	path = ocfs2_new_path_from_et(&et);
+	if (!path) {
+		ret = -ENOMEM;
+		mlog_errno(ret);
+		goto out;
+	}
+
+start:
+	if (trunc_end == 0) {
+		ret = 0;
+		goto out;
+	}
 
-		if (alloc_size > trunc_len)
-			alloc_size = trunc_len;
+	/*
+	 * Unlike truncating codes, here we want to find a path which contains
+	 * (trunc_end - 1) cpos, and trunc_end will be decreased after each
+	 * removal of a record range.
+	 *
+	 * Why didn't use trunc_end to search the path?
+	 * The reason is simple, think about the situation when we cross the
+	 * extent block, we need to find the adjacent block by decreasing one
+	 * cluster, otherwise, it will run into loop.
+	 */
+	ret = ocfs2_find_path(INODE_CACHE(inode), path, cluster_within_list);
+	if (ret) {
+		mlog_errno(ret);
+		goto out;
+	}
 
-		/* Only do work for non-holes */
-		if (phys_cpos != 0) {
-			ret = ocfs2_remove_btree_range(inode, &et, cpos,
-						       phys_cpos, alloc_size,
-						       &dealloc, refcount_loc,
-						       flags);
-			if (ret) {
-				mlog_errno(ret);
-				goto out;
-			}
+	el = path_leaf_el(path);
+
+	for (i = le16_to_cpu(el->l_next_free_rec) - 1; i >= 0; i--) {
+		rec = &el->l_recs[i];
+		/*
+		 * Find the rightmost record which contains 'trunc_end' cpos,
+		 * and we just simply jump to previous record if the trunc_end
+		 * is the start of a record.
+		 */
+		if (le32_to_cpu(rec->e_cpos) < trunc_end) {
+			/*
+			 * Skip a hole.
+			 */
+			if ((le32_to_cpu(rec->e_cpos) +
+			     ocfs2_rec_clusters(el, rec)) < trunc_end)
+				trunc_end = le32_to_cpu(rec->e_cpos) +
+					ocfs2_rec_clusters(el, rec);
+			break;
 		}
 
-		cpos += alloc_size;
-		trunc_len -= alloc_size;
+		if (le32_to_cpu(rec->e_cpos) == trunc_end) {
+			i--;
+			break;
+		}
+	}
+
+	rec = &el->l_recs[i];
+	flags = rec->e_flags;
+	range = le32_to_cpu(rec->e_cpos) + ocfs2_rec_clusters(el, rec);
+
+	/*
+	 * Similar with the truncating codes, we also handle the
+	 * following three cases in order:
+	 *
+	 * - remove the entire record
+	 * - remove a partial record
+	 * - no record needs to be removed
+	 */
+	if (le32_to_cpu(rec->e_cpos) >= trunc_start) {
+		trunc_cpos = le32_to_cpu(rec->e_cpos);
+		trunc_len = trunc_end - le32_to_cpu(rec->e_cpos);
+		blkno = le64_to_cpu(rec->e_blkno);
+		trunc_end = le32_to_cpu(rec->e_cpos);
+	} else if (range > trunc_start) {
+		trunc_cpos = trunc_start;
+		trunc_len = range - trunc_start;
+		coff = trunc_start - le32_to_cpu(rec->e_cpos);
+		blkno = le64_to_cpu(rec->e_blkno) +
+				ocfs2_clusters_to_blocks(inode->i_sb, coff);
+		trunc_end = trunc_start;
+	} else {
+		/*
+		 * It may have two following possibilities:
+		 *
+		 * - last record has been removed
+		 * - trunc_start was within a hole
+		 *
+		 * both two cases mean the completion of hole punching.
+		 */
+		ret = 0;
+		goto out;
 	}
 
+	phys_cpos = ocfs2_blocks_to_clusters(inode->i_sb, blkno);
+
+	ret = ocfs2_remove_btree_range(inode, &et, trunc_cpos,
+				       phys_cpos, trunc_len, &dealloc,
+				       refcount_loc, flags);
+	if (ret < 0) {
+		mlog_errno(ret);
+		goto out;
+	}
+
+	if (trunc_end > 0)
+		cluster_within_list = trunc_end - 1;
+
+	ocfs2_reinit_path(path, 1);
+
+	goto start;
+
 	ocfs2_truncate_cluster_pages(inode, byte_start, byte_len);
 
 out:
-- 
1.5.4.4
