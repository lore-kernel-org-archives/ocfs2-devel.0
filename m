From: Tao Ma <tao.ma@oracle.com>
Date: Tue,  9 Mar 2010 13:12:59 +0800
Subject: [Ocfs2-devel] [PATCH] ocfs2: Update i_blocks in reflink operations.
Message-ID: <1268111579-8600-1-git-send-email-tao.ma@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

In reflink, we need to upate i_blocks for the target inode.

Reported-by: Jie Liu <jeff.liu@oracle.com>
Signed-off-by: Tao Ma <tao.ma@oracle.com>
---
 fs/ocfs2/refcounttree.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/fs/ocfs2/refcounttree.c b/fs/ocfs2/refcounttree.c
index 9e96921..f4aad88 100644
--- a/fs/ocfs2/refcounttree.c
+++ b/fs/ocfs2/refcounttree.c
@@ -4075,6 +4075,7 @@ static int ocfs2_complete_reflink(struct inode *s_inode,
 	OCFS2_I(t_inode)->ip_dyn_features = OCFS2_I(s_inode)->ip_dyn_features;
 	spin_unlock(&OCFS2_I(t_inode)->ip_lock);
 	i_size_write(t_inode, size);
+	t_inode->i_blocks = ocfs2_inode_sector_count(t_inode);
 
 	di->i_xattr_inline_size = s_di->i_xattr_inline_size;
 	di->i_clusters = s_di->i_clusters;
-- 
1.5.5
