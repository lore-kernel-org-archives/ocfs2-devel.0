From: Tiger Yang <tiger.yang@oracle.com>
Date: Tue,  9 Dec 2008 16:43:08 +0800
Subject: [Ocfs2-devel] [PATCH 2/2] ocfs2: alloc xattr bucket in
	ocfs2_xattr_set_handle
In-Reply-To: <493E2ED0.6040105@oracle.com>
References: <493E2ED0.6040105@oracle.com>
Message-ID: <1228812188-8504-1-git-send-email-tiger.yang@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

In extreme situation, may need xattr bucket for setting
security entry and acl entries during mknod. This only
happens when block size is too small.

Signed-off-by: Tiger Yang <tiger.yang@oracle.com>
---
 fs/ocfs2/xattr.c |   18 +++++++++++++++---
 1 files changed, 15 insertions(+), 3 deletions(-)

diff --git a/fs/ocfs2/xattr.c b/fs/ocfs2/xattr.c
index 510c413..a24cf88 100644
--- a/fs/ocfs2/xattr.c
+++ b/fs/ocfs2/xattr.c
@@ -2562,9 +2562,7 @@ out:
 /*
  * This function only called duing creating inode
  * for init security/acl xattrs of the new inode.
- * The xattrs could be put into ibody or extent block,
- * xattr bucket would not be use in this case.
- * transanction credits also be reserved in here.
+ * All transanction credits have been reserved in mknod.
  */
 int ocfs2_xattr_set_handle(handle_t *handle,
 			   struct inode *inode,
@@ -2604,6 +2602,19 @@ int ocfs2_xattr_set_handle(handle_t *handle,
 	if (!ocfs2_supports_xattr(OCFS2_SB(inode->i_sb)))
 		return -EOPNOTSUPP;
 
+	/*
+	 * In extreme situation, may need xattr bucket when
+	 * block size is too small. And we have already reserved
+	 * the credits for bucket in mknod.
+	 */
+	if (inode->i_sb->s_blocksize == OCFS2_MIN_BLOCKSIZE) {
+		xbs.bucket = ocfs2_xattr_bucket_new(inode);
+		if (!xbs.bucket) {
+			mlog_errno(-ENOMEM);
+			return -ENOMEM;
+		}
+	}
+
 	xis.inode_bh = xbs.inode_bh = di_bh;
 	di = (struct ocfs2_dinode *)di_bh->b_data;
 
@@ -2623,6 +2634,7 @@ int ocfs2_xattr_set_handle(handle_t *handle,
 cleanup:
 	up_write(&OCFS2_I(inode)->ip_xattr_sem);
 	brelse(xbs.xattr_bh);
+	ocfs2_xattr_bucket_free(xbs.bucket);
 
 	return ret;
 }
-- 
1.5.4.1
