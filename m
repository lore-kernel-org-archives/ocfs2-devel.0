From: Wengang Wang <wen.gang.wang@oracle.com>
Date: Fri, 26 Feb 2010 18:18:25 +0800
Subject: [Ocfs2-devel] [PATCH] ocfs2: send SIGXFSZ if new filesize exceeds
	limit -v2
Message-ID: <201002261020.o1Q7k5dF028352@acsinet15.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

This patch makes ocfs2 send SIGXFSZ if new file size exceeds limit and abort the
operation.
No suprise that processes get SIGXFSZ on one node(in the cluster) while they
don't on another if file size limits are different on the two nodes.

Signed-off-by: Wengang Wang <wen.gang.wang@oracle.com>
---
 fs/ocfs2/file.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)
diff --git a/fs/ocfs2/file.c b/fs/ocfs2/file.c
index 558ce03..a118cb0 100644
--- a/fs/ocfs2/file.c
+++ b/fs/ocfs2/file.c
@@ -993,10 +993,9 @@ int ocfs2_setattr(struct dentry *dentry, struct iattr *attr)
 	}
 
 	if (size_change && attr->ia_size != i_size_read(inode)) {
-		if (attr->ia_size > sb->s_maxbytes) {
-			status = -EFBIG;
+		status = inode_newsize_ok(inode, attr->ia_size);
+		if (status)
 			goto bail_unlock;
-		}
 
 		if (i_size_read(inode) > attr->ia_size) {
 			if (ocfs2_should_order_data(inode)) {
-- 
1.6.6
