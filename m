From: Jeff Liu <jeff.liu@oracle.com>
Date: Tue, 06 Aug 2013 14:24:10 +0800
Subject: [Ocfs2-devel] [PATCH] ocfs2: fix a memory leak at
	__ocfs2_move_extents()
Message-ID: <5200968A.1050403@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

From: Jie Liu <jeff.liu@oracle.com>

The ocfs2 path is not properly freed which leads to a
memory leak at __ocfs2_move_extents().

This patch stops the leaks of the ocfs2_path structure.

Cc: Younger Liu <younger.liu@huawei.com>
Signed-off-by: Jie Liu <jeff.liu@oracle.com>
---
 fs/ocfs2/move_extents.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/ocfs2/move_extents.c b/fs/ocfs2/move_extents.c
index f1fc172..37231d1 100644
--- a/fs/ocfs2/move_extents.c
+++ b/fs/ocfs2/move_extents.c
@@ -152,6 +152,7 @@ static int __ocfs2_move_extent(handle_t *handle,
 	}
 
 out:
+	ocfs2_free_path(path);
 	return ret;
 }
 
-- 
1.7.9.5
