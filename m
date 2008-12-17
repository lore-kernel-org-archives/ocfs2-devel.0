From: Tiger Yang <tiger.yang@oracle.com>
Date: Wed, 17 Dec 2008 10:22:56 +0800
Subject: [Ocfs2-devel] [PATCH 1/1] ocfs2: Add xattr support checking in
	init_security
Message-ID: <1229480576-3397-1-git-send-email-tiger.yang@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

We must check whether ocfs2 volume support xattr in init_security,
if not support xattr and security is enable, would cause failure of mknod.

Signed-off-by: Tiger Yang <tiger.yang@oracle.com>
---
 fs/ocfs2/xattr.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/fs/ocfs2/xattr.c b/fs/ocfs2/xattr.c
index a24cf88..bde9d6d 100644
--- a/fs/ocfs2/xattr.c
+++ b/fs/ocfs2/xattr.c
@@ -5273,6 +5273,9 @@ int ocfs2_init_security_get(struct inode *inode,
 			    struct inode *dir,
 			    struct ocfs2_security_xattr_info *si)
 {
+	/* check whether ocfs2 support feature xattr */
+	if (!ocfs2_supports_xattr(OCFS2_SB(dir->i_sb)))
+		return -EOPNOTSUPP;
 	return security_inode_init_security(inode, dir, &si->name, &si->value,
 					    &si->value_len);
 }
-- 
1.5.4.1
