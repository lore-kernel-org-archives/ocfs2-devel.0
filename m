From: Jeff Liu <jeff.liu@oracle.com>
Date: Fri, 22 Feb 2013 19:15:46 +0800
Subject: [Ocfs2-devel] [PATCH] ocfs2: fix ocfs2_init_security_and_acl() to
 initialize acl correctly
Message-ID: <51275362.8020104@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

We need to re-initialize the security if it isn't preserved for ocfs2_reflink().
however, the code logic is broken at ocfs2_init_security_and_acl() although
ocfs2_init_security_get() succeed, as a result, ocfs2_acl_init() does not involked.

Note this was introduced by commit:
commit 9d8f13ba3f4833219e50767b022b82cd0da930eb
  security: new security_inode_init_security API adds function callback

Signed-off-by: Jie Liu <jeff.liu@oracle.com>
Reviewed-by: Tao Ma <boyu.mt@taobao.com>

---
 fs/ocfs2/xattr.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ocfs2/xattr.c b/fs/ocfs2/xattr.c
index 0ba9ea1..2e3ea30 100644
--- a/fs/ocfs2/xattr.c
+++ b/fs/ocfs2/xattr.c
@@ -7189,7 +7189,7 @@ int ocfs2_init_security_and_acl(struct inode *dir,
 	struct buffer_head *dir_bh = NULL;
 
 	ret = ocfs2_init_security_get(inode, dir, qstr, NULL);
-	if (!ret) {
+	if (ret) {
 		mlog_errno(ret);
 		goto leave;
 	}
-- 
1.7.9.5
