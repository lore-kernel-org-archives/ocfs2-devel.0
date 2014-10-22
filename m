From: Jan Kara <jack@suse.cz>
Date: Wed, 22 Oct 2014 08:57:13 +0200
Subject: [Ocfs2-devel] [PATCH] ocfs2: Fix xattr check in
	ocfs2_get_xattr_nolock()
Message-ID: <1413961033-24871-1-git-send-email-jack@suse.cz>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

ocfs2_get_xattr_nolock() checks whether inode as any extended attributes
(OCFS2_HAS_XATTR_FL). If not, it just sets 'ret' to -ENODATA but
continues with checking inline and external attributes anyway (which is
pointless although it does not harm). Just return immediately when we know
there are not extended attributes in the inode.

Coverity-id: 1226906
CC: Mark Fasheh <mfasheh@suse.com>
CC: Joel Becker <jlbec@evilplan.org>
Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/ocfs2/xattr.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ocfs2/xattr.c b/fs/ocfs2/xattr.c
index 016f01df3825..662f8dee149f 100644
--- a/fs/ocfs2/xattr.c
+++ b/fs/ocfs2/xattr.c
@@ -1284,7 +1284,7 @@ int ocfs2_xattr_get_nolock(struct inode *inode,
 		return -EOPNOTSUPP;
 
 	if (!(oi->ip_dyn_features & OCFS2_HAS_XATTR_FL))
-		ret = -ENODATA;
+		return -ENODATA;
 
 	xis.inode_bh = xbs.inode_bh = di_bh;
 	di = (struct ocfs2_dinode *)di_bh->b_data;
-- 
1.8.1.4
