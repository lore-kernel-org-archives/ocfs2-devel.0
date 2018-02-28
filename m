From: Larry Chen <lchen@suse.com>
Date: Wed, 28 Feb 2018 18:17:20 +0800
Subject: [Ocfs2-devel] [PATCH] Correct a comment error
Message-ID: <20180228101720.20725-1-lchen@suse.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

The function ocfs2_double_lock tries to lock the inode with lower
blockid first, not lockid.

Signed-off-by: Larry Chen <lchen@suse.com>
---
 fs/ocfs2/namei.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ocfs2/namei.c b/fs/ocfs2/namei.c
index c801eddc4bf3..30d454de35a8 100644
--- a/fs/ocfs2/namei.c
+++ b/fs/ocfs2/namei.c
@@ -1133,7 +1133,7 @@ static int ocfs2_double_lock(struct ocfs2_super *osb,
 	if (*bh2)
 		*bh2 = NULL;
 
-	/* we always want to lock the one with the lower lockid first.
+	/* we always want to lock the one with the lower blockid first.
 	 * and if they are nested, we lock ancestor first */
 	if (oi1->ip_blkno != oi2->ip_blkno) {
 		inode1_is_ancestor = ocfs2_check_if_ancestor(osb, oi2->ip_blkno,
-- 
2.13.6
