From: Guozhonghua <guozhonghua@h3c.com>
Date: Wed, 15 Nov 2017 12:02:16 +0000
Subject: [Ocfs2-devel] [PATCH] ocfs2: The goto is not useful in the function
 ocfs2_reserve_cluster_bitmap_bits, so remove it.
Message-ID: <71604351584F6A4EBAE558C676F37CA4F3CDE3A9@H3CMLB14-EX.srv.huawei-3com.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

The goto is not useful anymore, removed from the context.

Signed-off-by: guozhonghua <guozhonghua@h3c.com>
---
 fs/ocfs2/suballoc.c |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/fs/ocfs2/suballoc.c b/fs/ocfs2/suballoc.c
index 71f22c8..9f0b95a 100644
--- a/fs/ocfs2/suballoc.c
+++ b/fs/ocfs2/suballoc.c
@@ -1147,12 +1147,9 @@ int ocfs2_reserve_cluster_bitmap_bits(struct ocfs2_super *osb,
 					     GLOBAL_BITMAP_SYSTEM_INODE,
 					     OCFS2_INVALID_SLOT, NULL,
 					     ALLOC_NEW_GROUP);
-	if (status < 0 && status != -ENOSPC) {
+	if (status < 0 && status != -ENOSPC)
 		mlog_errno(status);
-		goto bail;
-	}
 
-bail:
 	return status;
 }
 
-- 
1.7.9.5
