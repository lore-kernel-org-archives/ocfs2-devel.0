From: Joseph Qi <joseph.qi@huawei.com>
Date: Wed, 28 Oct 2015 13:47:08 +0800
Subject: [Ocfs2-devel] [PATCH] ocfs2: cleanup unused variable in
	ocfs2_duplicate_clusters_by_page
Message-ID: <5630615C.4000205@huawei.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

readahead_pages in ocfs2_duplicate_clusters_by_page is defined but not
used, so clean it up.

Signed-off-by: Joseph Qi <joseph.qi@huawei.com>
---
 fs/ocfs2/refcounttree.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/fs/ocfs2/refcounttree.c b/fs/ocfs2/refcounttree.c
index b69dd14..cc4676d 100644
--- a/fs/ocfs2/refcounttree.c
+++ b/fs/ocfs2/refcounttree.c
@@ -2929,16 +2929,13 @@ int ocfs2_duplicate_clusters_by_page(handle_t *handle,
 	u64 new_block = ocfs2_clusters_to_blocks(sb, new_cluster);
 	struct page *page;
 	pgoff_t page_index;
-	unsigned int from, to, readahead_pages;
+	unsigned int from, to;
 	loff_t offset, end, map_end;
 	struct address_space *mapping = inode->i_mapping;

 	trace_ocfs2_duplicate_clusters_by_page(cpos, old_cluster,
 					       new_cluster, new_len);

-	readahead_pages =
-		(ocfs2_cow_contig_clusters(sb) <<
-		 OCFS2_SB(sb)->s_clustersize_bits) >> PAGE_CACHE_SHIFT;
 	offset = ((loff_t)cpos) << OCFS2_SB(sb)->s_clustersize_bits;
 	end = offset + (new_len << OCFS2_SB(sb)->s_clustersize_bits);
 	/*
-- 
1.8.4.3
