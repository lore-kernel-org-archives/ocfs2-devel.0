From: Tao Ma <tao.ma@oracle.com>
Date: Mon,  1 Feb 2010 17:05:33 +0800
Subject: [Ocfs2-devel] [PATCH] ocfs2: Only bug out when page size is larger
	than cluster size.
Message-ID: <1265015133-12775-1-git-send-email-tao.ma@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

In CoW, we have to make sure that the page is already written
out to the disk. So we have a BUG_ON(PageDirty(page)).

In ppc platform we have pagesize=64K, so if the cs=4K, if the
file have fragmented clusters, we will map the page many times.
See this file as an example.
Tree Depth: 0   Count: 19   Next Free Rec: 14
	## Offset        Clusters       Block#          Flags
	0  0             4              2164864         0x2 Refcounted
	1  4             2              9302792         0x2 Refcounted
...

We have to replace the extent recs one by one, so the page with index 0
will be mapped and dirtied twice.

I'd like to leave the BUG_ON there while adding a check so that in
case we meet with an error in other platforms, we can find it easily.

Signed-off-by: Tao Ma <tao.ma@oracle.com>
---
 fs/ocfs2/refcounttree.c |    8 ++++++--
 1 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/fs/ocfs2/refcounttree.c b/fs/ocfs2/refcounttree.c
index 5b64468..8ae65c9 100644
--- a/fs/ocfs2/refcounttree.c
+++ b/fs/ocfs2/refcounttree.c
@@ -2957,8 +2957,12 @@ static int ocfs2_duplicate_clusters_by_page(handle_t *handle,
 
 		page = grab_cache_page(mapping, page_index);
 
-		/* This page can't be dirtied before we CoW it out. */
-		BUG_ON(PageDirty(page));
+		/*
+		 * In case PAGE_CACHE_SIZE <= CLUSTER_SIZE, This page
+		 * can't be dirtied before we CoW it out.
+		 */
+		if (PAGE_CACHE_SIZE <= OCFS2_SB(sb)->s_clustersize)
+			BUG_ON(PageDirty(page));
 
 		if (!PageUptodate(page)) {
 			ret = block_read_full_page(page, ocfs2_get_block);
-- 
1.6.3.3
