From: Tao Ma <tao.ma@oracle.com>
Date: Mon,  9 Feb 2009 05:56:29 +0800
Subject: [Ocfs2-devel] [PATCH] ocfs2/security: Check xattr support in
	security_init.
Message-ID: <1234130189-8091-1-git-send-email-tao.ma@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

If the system supports selinux, we will return sucessfully from
ocfs2_init_security_get if it is called for the mount point.
And in that case if the volume doesn't have xattr support, we
will not be able to create a new inode in the mount dir because
ocfs2_mknod will try to set security attributes for a new created
inode. This patch check xattr support in ocfs2_init_security_get,
so it will let ocfs2_mknod knows that we don't support xattr and
it don't need to init security for the new inode in that case.

Signed-off-by: Tao Ma <tao.ma@oracle.com>
---
 fs/ocfs2/xattr.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/fs/ocfs2/xattr.c b/fs/ocfs2/xattr.c
index 5aec833..8a7db21 100644
--- a/fs/ocfs2/xattr.c
+++ b/fs/ocfs2/xattr.c
@@ -5289,6 +5289,9 @@ int ocfs2_init_security_get(struct inode *inode,
 			    struct inode *dir,
 			    struct ocfs2_security_xattr_info *si)
 {
+	if (!ocfs2_supports_xattr(OCFS2_SB(inode->i_sb)))
+		return -EOPNOTSUPP;
+
 	return security_inode_init_security(inode, dir, &si->name, &si->value,
 					    &si->value_len);
 }
-- 
1.5.4.4
