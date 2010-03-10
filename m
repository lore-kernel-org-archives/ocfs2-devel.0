From: Tao Ma <tao.ma@oracle.com>
Date: Wed, 10 Mar 2010 09:56:52 +0800
Subject: [Ocfs2-devel] [PATCH] ocfs2: Update i_blocks in reflink
	operations.
Message-ID: <1268186212-11949-1-git-send-email-tao.ma@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi Joel,
>> +	t_inode->i_blocks = ocfs2_inode_sector_count(t_inode);
>	Curiously, why wouldn't it just be s_inode->i_blocks?
	yeah, using i_blocks looks more natural. Here is the updated one.

Regards,
Tao

From 08c37fec54533cf3a04285caceda908eccab9d57 Mon Sep 17 00:00:00 2001
From: Tao Ma <tao.ma@oracle.com>
Date: Wed, 10 Mar 2010 09:45:00 +0800
Subject: [PATCH] ocfs2: Update i_blocks in reflink operations.

In reflink, we need to upate i_blocks for the target inode.

Reported-by: Jie Liu <jeff.liu@oracle.com>
Signed-off-by: Tao Ma <tao.ma@oracle.com>
---
 fs/ocfs2/refcounttree.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/fs/ocfs2/refcounttree.c b/fs/ocfs2/refcounttree.c
index 9e96921..29405f2 100644
--- a/fs/ocfs2/refcounttree.c
+++ b/fs/ocfs2/refcounttree.c
@@ -4075,6 +4075,7 @@ static int ocfs2_complete_reflink(struct inode *s_inode,
 	OCFS2_I(t_inode)->ip_dyn_features = OCFS2_I(s_inode)->ip_dyn_features;
 	spin_unlock(&OCFS2_I(t_inode)->ip_lock);
 	i_size_write(t_inode, size);
+	t_inode->i_blocks = s_inode->i_blocks;
 
 	di->i_xattr_inline_size = s_di->i_xattr_inline_size;
 	di->i_clusters = s_di->i_clusters;
-- 
1.5.5
