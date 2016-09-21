From: Joseph Qi <joseph.qi@huawei.com>
Date: Wed, 21 Sep 2016 09:38:37 +0800
Subject: [Ocfs2-devel] [PATCH] ocfs2: fix undefined struct variable in
	inode.h
Message-ID: <57E1E49D.8050503@huawei.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

The extern struct variable ocfs2_inode_cache is not defined. It meant to
use ocfs2_inode_cachep defined in super.c, I think. Fortunately it is
not used anywhere now, so no impact actually. Clean it up to fix this
mistake.

Signed-off-by: Joseph Qi <joseph.qi@huawei.com>
---
 fs/ocfs2/inode.h | 2 --
 1 file changed, 2 deletions(-)

diff --git a/fs/ocfs2/inode.h b/fs/ocfs2/inode.h
index 50cc550..5af68fc 100644
--- a/fs/ocfs2/inode.h
+++ b/fs/ocfs2/inode.h
@@ -123,8 +123,6 @@ static inline struct ocfs2_inode_info *OCFS2_I(struct inode *inode)
 #define INODE_JOURNAL(i) (OCFS2_I(i)->ip_flags & OCFS2_INODE_JOURNAL)
 #define SET_INODE_JOURNAL(i) (OCFS2_I(i)->ip_flags |= OCFS2_INODE_JOURNAL)

-extern struct kmem_cache *ocfs2_inode_cache;
-
 extern const struct address_space_operations ocfs2_aops;
 extern const struct ocfs2_caching_operations ocfs2_inode_caching_ops;

-- 
1.8.4.3
