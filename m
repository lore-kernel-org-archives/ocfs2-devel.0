From: Dan Carpenter <dan.carpenter@oracle.com>
Date: Thu, 1 Aug 2013 16:55:26 +0300
Subject: [Ocfs2-devel] [patch] ocfs2: fix recent memory corruption bug
Message-ID: <20130801135526.GA17153@elgon.mountain>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

The pointer math in 6fdf3af1d2 "ocfs2: fix null pointer dereference in
ocfs2_dir_foreach_blk_id()" isn't correct so it will zero out the wrong
memory.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
Static checker stuff.

diff --git a/fs/ocfs2/dir.c b/fs/ocfs2/dir.c
index c91d986..6942c22 100644
--- a/fs/ocfs2/dir.c
+++ b/fs/ocfs2/dir.c
@@ -2157,8 +2157,7 @@ int ocfs2_empty_dir(struct inode *inode)
 		.ctx.pos = 0,
 	};
 
-	memset(&priv + sizeof(struct dir_context), 0,
-	       sizeof(priv) - sizeof(struct dir_context));
+	memset(&priv.seen_dot, 0, sizeof(priv) - sizeof(struct dir_context));
 
 	if (ocfs2_dir_indexed(inode)) {
 		ret = ocfs2_empty_dir_dx(inode, &priv);
