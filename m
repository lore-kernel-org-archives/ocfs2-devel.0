From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Fri,  4 Sep 2009 11:12:01 -0700
Subject: [Ocfs2-devel] [PATCH 1/1] ocfs2: ocfs2_write_begin_nolock() should
	handle len=0
Message-ID: <1252087921-24123-1-git-send-email-sunil.mushran@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Bug introduced by mainline commit e7432675f8ca868a4af365759a8d4c3779a3d922
The bug causes ocfs2_write_begin_nolock() to oops when len=0.

Signed-off-by: Sunil Mushran <sunil.mushran@oracle.com>
---
 fs/ocfs2/aops.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/ocfs2/aops.c b/fs/ocfs2/aops.c
index b401654..8a1e615 100644
--- a/fs/ocfs2/aops.c
+++ b/fs/ocfs2/aops.c
@@ -1747,8 +1747,8 @@ int ocfs2_write_begin_nolock(struct address_space *mapping,
 	 * we know zeros will only be needed in the first and/or last cluster.
 	 */
 	if (clusters_to_alloc || extents_to_split ||
-	    wc->w_desc[0].c_needs_zero ||
-	    wc->w_desc[wc->w_clen - 1].c_needs_zero)
+	    (wc->w_clen && (wc->w_desc[0].c_needs_zero ||
+			    wc->w_desc[wc->w_clen - 1].c_needs_zero)))
 		cluster_of_pages = 1;
 	else
 		cluster_of_pages = 0;
-- 
1.6.0.4
