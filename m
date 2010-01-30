From: Tao Ma <tao.ma@oracle.com>
Date: Sat, 30 Jan 2010 23:32:19 +0800
Subject: [Ocfs2-devel] [PATCH] ocfs2: Fix memory overflow in cow_by_page.v2
Message-ID: <1264865539-2824-1-git-send-email-tao.ma@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

In ocfs2_duplicate_clusters_by_page, we calculate map_end
by shifting page_index. But actually in case we meet with
a large offset(say in a i686 box, poff_t is only 32 bits
and page_index=2056240), we will overflow. So change the
type of page_index to loff_t.

Signed-off-by: Tao Ma <tao.ma@oracle.com>
---
 fs/ocfs2/refcounttree.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/ocfs2/refcounttree.c b/fs/ocfs2/refcounttree.c
index 74db2be..5b64468 100644
--- a/fs/ocfs2/refcounttree.c
+++ b/fs/ocfs2/refcounttree.c
@@ -2945,7 +2945,7 @@ static int ocfs2_duplicate_clusters_by_page(handle_t *handle,
 
 	while (offset < end) {
 		page_index = offset >> PAGE_CACHE_SHIFT;
-		map_end = (page_index + 1) << PAGE_CACHE_SHIFT;
+		map_end = ((loff_t)page_index + 1) << PAGE_CACHE_SHIFT;
 		if (map_end > end)
 			map_end = end;
 
@@ -3170,7 +3170,7 @@ static int ocfs2_cow_sync_writeback(struct super_block *sb,
 
 	while (offset < end) {
 		page_index = offset >> PAGE_CACHE_SHIFT;
-		map_end = (page_index + 1) << PAGE_CACHE_SHIFT;
+		map_end = ((loff_t)page_index + 1) << PAGE_CACHE_SHIFT;
 		if (map_end > end)
 			map_end = end;
 
-- 
1.6.3.3
