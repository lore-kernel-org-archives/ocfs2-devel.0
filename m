From: Younger Liu <younger.liu@huawei.com>
Date: Wed, 18 Sep 2013 16:33:13 +0800
Subject: [Ocfs2-devel] [PATCH] ocfs2: Add missing errno in
	ocfs2_ioctl_move_extents()
Message-ID: <52396549.6040906@huawei.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

If the file is not regular or writeable, it should return errno(-EPERM).

This patch is based on commit 85a258b70d4891a443583530f48ab734a31e2d8d.

Signed-off-by: Younger Liu <younger.liu@huawei.com>
Cc: Jie Liu <jeff.liu@oracle.com>
Cc: Dan Carpenter <dan.carpenter@oracle.com>
---
 fs/ocfs2/move_extents.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/ocfs2/move_extents.c b/fs/ocfs2/move_extents.c
index 3d3f3c8..0ef308d 100644
--- a/fs/ocfs2/move_extents.c
+++ b/fs/ocfs2/move_extents.c
@@ -1067,8 +1067,10 @@ int ocfs2_ioctl_move_extents(struct file *filp, void __user *argp)
 	if (status)
 		return status;
 
-	if ((!S_ISREG(inode->i_mode)) || !(filp->f_mode & FMODE_WRITE))
+	if ((!S_ISREG(inode->i_mode)) || !(filp->f_mode & FMODE_WRITE)) {
+		status = -EPERM;
 		goto out_drop;
+	}
 
 	if (inode->i_flags & (S_IMMUTABLE|S_APPEND)) {
 		status = -EPERM;
-- 
1.7.9.7
