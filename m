From: Dan Carpenter <dan.carpenter@oracle.com>
Date: Thu, 1 Aug 2013 18:36:38 +0300
Subject: [Ocfs2-devel] [patch v3] ocfs2: ocfs2: fix recent memory corruption
	bug
In-Reply-To: <51FA6C7A.9050407@oracle.com>
Message-ID: <20130801153638.GA4887@elgon.mountain>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

The pointer math in 6fdf3af1d2 "ocfs2: fix null pointer dereference in
ocfs2_dir_foreach_blk_id()" isn't correct so it will zero out the wrong
memory.  In fact, the memset isn't needed because the initializer will
set all these values to zero.

This patch also removes the "ctx.pos = 0" initialization because that
will be zeroed automatically as well.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
v2: remove the memset
v3: remove the ctx.pos = 0.

diff --git a/fs/ocfs2/dir.c b/fs/ocfs2/dir.c
index c91d986..30544ce 100644
--- a/fs/ocfs2/dir.c
+++ b/fs/ocfs2/dir.c
@@ -2154,12 +2154,8 @@ int ocfs2_empty_dir(struct inode *inode)
 	int ret;
 	struct ocfs2_empty_dir_priv priv = {
 		.ctx.actor = ocfs2_empty_dir_filldir,
-		.ctx.pos = 0,
 	};
 
-	memset(&priv + sizeof(struct dir_context), 0,
-	       sizeof(priv) - sizeof(struct dir_context));
-
 	if (ocfs2_dir_indexed(inode)) {
 		ret = ocfs2_empty_dir_dx(inode, &priv);
 		if (ret)
