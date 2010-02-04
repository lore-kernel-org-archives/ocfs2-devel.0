From: Tristan Ye <tristan.ye@oracle.com>
Date: Thu,  4 Feb 2010 19:21:22 +0800
Subject: [Ocfs2-devel] [PATCH 3/3] Ocfs2: Optimize punching-hole codes v1.
In-Reply-To: <1265282482-4915-1-git-send-email-tristan.ye@oracle.com>
References: <1265282482-4915-1-git-send-email-tristan.ye@oracle.com>
Message-ID: <1265282482-4915-3-git-send-email-tristan.ye@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Currently punching hole on a file with 3+ extent tree depth was
really a performance disaster, it even caused several hours to
go, though we may not hit this in real life with such a huge extent
number.

One simple way to improve the performance is quite straightforward,
by learning the logic of truncating codes, means we'd punch hole from
hole_end to hole_start, which reduce the overhead of btree operation
in a significant way, such as tree rotation and moving.

Following is the testing result when punching hole from 10 to 1073741804
in bytes, on a 1G file, 1G file consists of 256k extent records, each record
cover 4k data(just one cluster, clustersize is 4k):

===================================
 * Former punching-hole mechanism:
===================================

   I waited it 3 hours for completion, unfortunately it's still ongoing.

===================================
 * Patched punching-hode mechanism:
===================================

   real	0m8.468s
   user	0m0.000s
   sys	0m3.315s

That means we've gained up to 1000 times improvement on performance, whee!
It's fairly cool.

The patch was based on my former 2 patches, which were about truncating
codes optimization and fixup to handle CoW on punching hole.

Signed-off-by: Tristan Ye <tristan.ye@oracle.com>
---
 fs/ocfs2/file.c |  127 +++++++++++++++++++++++++++++++++++-------------------
 1 files changed, 82 insertions(+), 45 deletions(-)

diff --git a/fs/ocfs2/file.c b/fs/ocfs2/file.c
index 85911a9..ed3865b 100644
--- a/fs/ocfs2/file.c
+++ b/fs/ocfs2/file.c
@@ -1428,7 +1428,8 @@ static int ocfs2_remove_inode_range(struct inode *inode,
 				    u64 byte_len)
 {
 	int ret = 0, flags = 0, i;
-	u32 trunc_start, trunc_len, cpos, phys_cpos, alloc_size;
+	u32 trunc_start, trunc_len, trunc_end, trunc_cpos, phys_cpos;
+	u32 range, coff, cluster_within_list;
 	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
 	struct ocfs2_cached_dealloc_ctxt dealloc;
 	struct address_space *mapping = inode->i_mapping;
@@ -1437,7 +1438,7 @@ static int ocfs2_remove_inode_range(struct inode *inode,
 	struct ocfs2_extent_list *el = NULL;
 	struct ocfs2_extent_rec *rec = NULL;
 	struct ocfs2_dinode *di = (struct ocfs2_dinode *)di_bh->b_data;
-	u64 refcount_loc = le64_to_cpu(di->i_refcount_loc);
+	u64 blkno, refcount_loc = le64_to_cpu(di->i_refcount_loc);
 
 	ocfs2_init_dinode_extent_tree(&et, INODE_CACHE(inode), di_bh);
 	ocfs2_init_dealloc_ctxt(&dealloc);
@@ -1485,16 +1486,13 @@ static int ocfs2_remove_inode_range(struct inode *inode,
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
@@ -1509,52 +1507,91 @@ static int ocfs2_remove_inode_range(struct inode *inode,
 		goto out;
 	}
 
-	cpos = trunc_start;
-	while (trunc_len) {
-		ret = ocfs2_get_clusters(inode, cpos, &phys_cpos,
-					 &alloc_size, NULL);
-		if (ret) {
-			mlog_errno(ret);
-			goto out;
-		}
-
-		if (alloc_size > trunc_len)
-			alloc_size = trunc_len;
+start:
+	if (trunc_end == 0) {
+		ret = 0;
+		goto out;
+	}
 
-		ret = ocfs2_find_path(INODE_CACHE(inode), path, cpos);
-		if (ret) {
-			mlog_errno(ret);
-			goto out;
-		}
+	/*
+	 * Unlike truncating codes, here we want to find a path which contains
+	 * (trunc_end - 1) cpos, and trunc_end will be decreased after each
+	 * removal of a record range.
+	 *
+	 * Why didn't use trunc_end to search the path?
+	 * The reason is simple, think about the situation when we cross  the
+	 * extent block, we need to find the adjacent block by decreasing one
+	 * cluster, otherwise, it will run into loop.
+	 */
+	ret = ocfs2_find_path(INODE_CACHE(inode), path, cluster_within_list);
+	if (ret) {
+		mlog_errno(ret);
+		goto out;
+	}
 
-		el = path_leaf_el(path);
+	el = path_leaf_el(path);
 
-		for (i = le16_to_cpu(el->l_next_free_rec) - 1; i >= 0; i--) {
-			rec = &el->l_recs[i];
-			if (le32_to_cpu(rec->e_cpos) <= cpos)
-				break;
+	for (i = le16_to_cpu(el->l_next_free_rec) - 1; i >= 0; i--) {
+		rec = &el->l_recs[i];
+		/*
+		 * Find the right record which contains 'trunc_end' cpos,
+		 * and we just simply jump to next if the trunc_end is
+		 * the start of a record.
+		 */
+		if (le32_to_cpu(rec->e_cpos) < trunc_end)
+			break;
+		if (le32_to_cpu(rec->e_cpos) == trunc_end) {
+			i--;
+			break;
 		}
+	}
 
-		flags = rec->e_flags;
+	rec = &el->l_recs[i];
+	flags = rec->e_flags;
+	range = le32_to_cpu(rec->e_cpos) + ocfs2_rec_clusters(el, rec);
 
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
-		}
+	/*
+	 * Similar with the truncating codes, we also handle the
+	 * following three cases in order:
+	 *
+	 * - remove the entire record
+	 * - remove a partial record
+	 * - no record needs to be removed (hole-punching  has completed)
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
+		ret = 0;
+		goto out;
+	}
 
-		cpos += alloc_size;
-		trunc_len -= alloc_size;
+	phys_cpos = ocfs2_blocks_to_clusters(inode->i_sb, blkno);
 
-		ocfs2_reinit_path(path, 1);
+	ret = ocfs2_remove_btree_range(inode, &et, trunc_cpos,
+				       phys_cpos, trunc_len, &dealloc,
+				       refcount_loc, flags);
+	if (ret < 0) {
+		mlog_errno(ret);
+		goto out;
 	}
 
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
1.5.5
