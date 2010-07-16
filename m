From: Tiger Yang <tiger.yang@oracle.com>
Date: Fri, 16 Jul 2010 11:23:16 +0800
Subject: [Ocfs2-devel] [PATCH 1/1 v2] ocfs2: do not overwrite error codes in
	ocfs2_init_acl
Message-ID: <12792505961843-git-send-email-tiger.yang@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Setting the acl while creating a new inode depends on
the error codes of posix_acl_create_masq. This patch fix
a issue of overwriting the error codes of it.

Reported-by: Pawel Zawora <pzawora@gmail.com>
Cc: <stable@kernel.org> [ .33, .34 ]
Signed-off-by: Tiger Yang <tiger.yang@oracle.com>
---
 fs/ocfs2/acl.c |    9 +++++++--
 1 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/fs/ocfs2/acl.c b/fs/ocfs2/acl.c
index da70229..5a21778 100644
--- a/fs/ocfs2/acl.c
+++ b/fs/ocfs2/acl.c
@@ -344,7 +344,7 @@ int ocfs2_init_acl(handle_t *handle,
 {
 	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
 	struct posix_acl *acl = NULL;
-	int ret = 0;
+	int ret = 0, ret2;
 	mode_t mode;
 
 	if (!S_ISLNK(inode->i_mode)) {
@@ -381,7 +381,12 @@ int ocfs2_init_acl(handle_t *handle,
 		mode = inode->i_mode;
 		ret = posix_acl_create_masq(clone, &mode);
 		if (ret >= 0) {
-			ret = ocfs2_acl_set_mode(inode, di_bh, handle, mode);
+			ret2 = ocfs2_acl_set_mode(inode, di_bh, handle, mode);
+			if (ret2) {
+				mlog_errno(ret2);
+				ret = ret2;
+				goto cleanup;
+			}
 			if (ret > 0) {
 				ret = ocfs2_set_acl(handle, inode,
 						    di_bh, ACL_TYPE_ACCESS,
-- 
1.5.2.3
