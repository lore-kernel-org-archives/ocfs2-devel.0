From: Jeff Liu <jeff.liu@oracle.com>
Date: Thu, 09 Feb 2012 14:42:22 +0800
Subject: [Ocfs2-devel] [PATCH] ocfs2: for SEEK_DATA/SEEK_HOLE,
 return internal error unchanged if ocfs2_get_clusters_nocache() or
 ocfs2_inode_lock() call failed.
Message-ID: <4F336ACE.3010803@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hello,

Since ENXIO only means "offset beyond EOF" for SEEK_DATA/SEEK_HOLE,
Hence we should return the internal error unchanged if ocfs2_inode_lock() or
ocfs2_get_clusters_nocache() call failed rather than ENXIO.
Otherwise, it will confuse the user applications when they trying to understand the root cause.

Thanks Dave for pointing this out.

Thanks,
-Jeff


Cc: Dave Chinner <david@fromorbit.com>
Signed-off-by: Jie Liu <jeff.liu@oracle.com>

---
 fs/ocfs2/extent_map.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/fs/ocfs2/extent_map.c b/fs/ocfs2/extent_map.c
index 2f5b92e..70b5863 100644
--- a/fs/ocfs2/extent_map.c
+++ b/fs/ocfs2/extent_map.c
@@ -923,8 +923,6 @@ out_unlock:
 
 	ocfs2_inode_unlock(inode, 0);
 out:
-	if (ret && ret != -ENXIO)
-		ret = -ENXIO;
 	return ret;
 }
 
-- 
1.7.9
