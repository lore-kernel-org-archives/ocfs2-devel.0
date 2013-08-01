From: Dan Carpenter <dan.carpenter@oracle.com>
Date: Thu, 1 Aug 2013 17:02:59 +0300
Subject: [Ocfs2-devel] [patch v2] ocfs2: fix recent memory corruption bug
In-Reply-To: <20130801135830.GA5102@mwanda>
Message-ID: <20130801140259.GA18952@elgon.mountain>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

The pointer math in 6fdf3af1d2 "ocfs2: fix null pointer dereference in
ocfs2_dir_foreach_blk_id()" isn't correct so it will zero out the wrong
memory.  In fact, the memset isn't needed because the initializer will
set all these values to zero.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
v2: remove the memset

diff --git a/fs/ocfs2/dir.c b/fs/ocfs2/dir.c
index c91d986..b1748cd 100644
--- a/fs/ocfs2/dir.c
+++ b/fs/ocfs2/dir.c
@@ -2157,9 +2157,6 @@ int ocfs2_empty_dir(struct inode *inode)
 		.ctx.pos = 0,
 	};
 
-	memset(&priv + sizeof(struct dir_context), 0,
-	       sizeof(priv) - sizeof(struct dir_context));
-
 	if (ocfs2_dir_indexed(inode)) {
 		ret = ocfs2_empty_dir_dx(inode, &priv);
 		if (ret)
