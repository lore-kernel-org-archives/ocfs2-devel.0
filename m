From: Junxiao Bi <junxiao.bi@oracle.com>
Date: Thu, 20 Jun 2013 14:17:37 +0800
Subject: [Ocfs2-devel] [PATCH 2/2] ocfs2: xattr: remove useless free space
	checking
In-Reply-To: <1371709057-11469-1-git-send-email-junxiao.bi@oracle.com>
References: <1371709057-11469-1-git-send-email-junxiao.bi@oracle.com>
Message-ID: <1371709057-11469-2-git-send-email-junxiao.bi@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

free space checking will be done in ocfs2_xattr_ibody_init().
So remove here.

Signed-off-by: Junxiao Bi <junxiao.bi@oracle.com>
---
 fs/ocfs2/xattr.c |    7 -------
 1 file changed, 7 deletions(-)

diff --git a/fs/ocfs2/xattr.c b/fs/ocfs2/xattr.c
index 3bb0708..7de1a78 100644
--- a/fs/ocfs2/xattr.c
+++ b/fs/ocfs2/xattr.c
@@ -2759,13 +2759,6 @@ static int ocfs2_xattr_ibody_set(struct inode *inode,
 
 	down_write(&oi->ip_alloc_sem);
 	if (!(oi->ip_dyn_features & OCFS2_INLINE_XATTR_FL)) {
-		if (!ocfs2_xattr_has_space_inline(inode, di)) {
-			ret = -ENOSPC;
-			goto out;
-		}
-	}
-
-	if (!(oi->ip_dyn_features & OCFS2_INLINE_XATTR_FL)) {
 		ret = ocfs2_xattr_ibody_init(inode, xs->inode_bh, ctxt);
 		if (ret) {
 			if (ret != -ENOSPC)
-- 
1.7.9.5
