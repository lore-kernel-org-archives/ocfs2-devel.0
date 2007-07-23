From: Adrian Bunk <bunk@stusta.de>
Date: Mon Jul 23 01:01:59 2007
Subject: [Ocfs2-devel] [2.6 patch] ocfs2_insert_extent(): remove dead code
Message-ID: <20070723080121.GC26212@stusta.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: mark.fasheh@oracle.com, kurt.hackel@oracle.com
Cc: ocfs2-devel@oss.oracle.com, linux-kernel@vger.kernel.org

This patch removes some now dead code.

Spotted by the Coverity checker.

Signed-off-by: Adrian Bunk <bunk@stusta.de>

---

 fs/ocfs2/alloc.c |    4 ----
 1 file changed, 4 deletions(-)

--- linux-2.6.22-rc6-mm1/fs/ocfs2/alloc.c.old	2007-07-23 01:29:25.000000000 +0200
+++ linux-2.6.22-rc6-mm1/fs/ocfs2/alloc.c	2007-07-23 01:29:52.000000000 +0200
@@ -3500,7 +3500,6 @@ int ocfs2_insert_extent(struct ocfs2_sup
 {
 	int status;
 	struct buffer_head *last_eb_bh = NULL;
-	struct buffer_head *bh = NULL;
 	struct ocfs2_insert_type insert = {0, };
 	struct ocfs2_extent_rec rec;
 
@@ -3552,9 +3551,6 @@ int ocfs2_insert_extent(struct ocfs2_sup
 		ocfs2_extent_map_insert_rec(inode, &rec);
 
 bail:
-	if (bh)
-		brelse(bh);
-
 	if (last_eb_bh)
 		brelse(last_eb_bh);
 
