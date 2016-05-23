From: Eric Ren <zren@suse.com>
Date: Mon, 23 May 2016 10:30:56 +0800
Subject: [Ocfs2-devel] [PATCH] ocfs2: fix improper handling of return errno
Message-ID: <1463970656-18413-1-git-send-email-zren@suse.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Previously, if bad inode was found in ocfs2_iget(), -ESTALE?was
returned back to the caller anyway. Since commit d2b9d71a2da7
("ocfs2: check/fix inode block for online file check") can handle
with return value from ocfs2_read_locked_inode() now, we know the
exact errno returned for us.

Signed-off-by: Eric Ren <zren@suse.com>
---
 fs/ocfs2/inode.c | 7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

diff --git a/fs/ocfs2/inode.c b/fs/ocfs2/inode.c
index ba495be..fee5ec6 100644
--- a/fs/ocfs2/inode.c
+++ b/fs/ocfs2/inode.c
@@ -176,12 +176,7 @@ struct inode *ocfs2_iget(struct ocfs2_super *osb, u64 blkno, unsigned flags,
 	}
 	if (is_bad_inode(inode)) {
 		iput(inode);
-		if ((flags & OCFS2_FI_FLAG_FILECHECK_CHK) ||
-		    (flags & OCFS2_FI_FLAG_FILECHECK_FIX))
-			/* Return OCFS2_FILECHECK_ERR_XXX related errno */
-			inode = ERR_PTR(rc);
-		else
-			inode = ERR_PTR(-ESTALE);
+		inode = ERR_PTR(rc);
 		goto bail;
 	}
 
-- 
2.6.6
