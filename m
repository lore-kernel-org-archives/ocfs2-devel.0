From: Tao Ma <tao.ma@oracle.com>
Date: Tue, 26 Jan 2010 12:24:11 +0800
Subject: [Ocfs2-devel] [PATCH] ocfs2: Fix memory overflow in cow_by_page.
In-Reply-To: <20100126031956.GC15982@mail.oracle.com>
References: <20100126031956.GC15982@mail.oracle.com>
Message-ID: <1264479851-8124-1-git-send-email-tao.ma@oracle.com>
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
 fs/ocfs2/refcounttree.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/ocfs2/refcounttree.c b/fs/ocfs2/refcounttree.c
index 74db2be..7687bf1 100644
--- a/fs/ocfs2/refcounttree.c
+++ b/fs/ocfs2/refcounttree.c
@@ -2945,7 +2945,7 @@ static int ocfs2_duplicate_clusters_by_page(handle_t *handle,
 
 	while (offset < end) {
 		page_index = offset >> PAGE_CACHE_SHIFT;
-		map_end = (page_index + 1) << PAGE_CACHE_SHIFT;
+		map_end = ((loff_t)page_index + 1) << PAGE_CACHE_SHIFT;
 		if (map_end > end)
 			map_end = end;
 
-- 
1.6.3.3
