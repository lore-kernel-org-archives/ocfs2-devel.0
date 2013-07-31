From: Joseph Qi <joseph.qi@huawei.com>
Date: Wed, 31 Jul 2013 17:33:31 +0800
Subject: [Ocfs2-devel] [PATCH] ocfs2: add the missing return value check of
	ocfs2_xattr_get_clusters
Message-ID: <51F8D9EB.9060607@huawei.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

In ocfs2_xattr_value_attach_refcount(), if error occurs when calling
ocfs2_xattr_get_clusters(), it will go with unexpected behavior since
local variables p_cluster, num_clusters and ext_flags are declared
without initialization.

Signed-off-by: Joseph Qi <joseph.qi@huawei.com>
---
 fs/ocfs2/xattr.c |    4 ++++
 1 file changed, 4 insertions(+)

diff --git a/fs/ocfs2/xattr.c b/fs/ocfs2/xattr.c
index 2e3ea30..87daa44 100644
--- a/fs/ocfs2/xattr.c
+++ b/fs/ocfs2/xattr.c
@@ -5889,6 +5889,10 @@ static int ocfs2_xattr_value_attach_refcount(struct inode *inode,
 	while (cpos < clusters) {
 		ret = ocfs2_xattr_get_clusters(inode, cpos, &p_cluster,
 					       &num_clusters, el, &ext_flags);
+		if (ret) {
+			mlog_errno(ret);
+			break;
+		}
 
 		cpos += num_clusters;
 		if ((ext_flags & OCFS2_EXT_REFCOUNTED))
-- 
1.7.9.7
