From: Tiger Yang <tiger.yang@oracle.com>
Date: Thu, 23 Oct 2008 16:34:13 +0800
Subject: [Ocfs2-devel] [PATCH 3/4] ocfs2: remove duplicate definition in
	xattr
In-Reply-To: <49003524.3090405@oracle.com>
References: <49003524.3090405@oracle.com>
Message-ID: <1224750853-10922-1-git-send-email-tiger.yang@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Include/linux/xattr.h already has the definition about xattr prefix,
so remove the duplicate definitions in xattr.c.

Signed-off-by: Tiger Yang <tiger.yang@oracle.com>
---
 fs/ocfs2/xattr.c |   11 ++---------
 1 files changed, 2 insertions(+), 9 deletions(-)

diff --git a/fs/ocfs2/xattr.c b/fs/ocfs2/xattr.c
index 667525b..754e5fa 100644
--- a/fs/ocfs2/xattr.c
+++ b/fs/ocfs2/xattr.c
@@ -4830,14 +4830,11 @@ out:
 /*
  * 'trusted' attributes support
  */
-
-#define XATTR_TRUSTED_PREFIX "trusted."
-
 static size_t ocfs2_xattr_trusted_list(struct inode *inode, char *list,
 				       size_t list_size, const char *name,
 				       size_t name_len)
 {
-	const size_t prefix_len = sizeof(XATTR_TRUSTED_PREFIX) - 1;
+	const size_t prefix_len = XATTR_TRUSTED_PREFIX_LEN;
 	const size_t total_len = prefix_len + name_len + 1;
 
 	if (list && total_len <= list_size) {
@@ -4874,18 +4871,14 @@ struct xattr_handler ocfs2_xattr_trusted_handler = {
 	.set	= ocfs2_xattr_trusted_set,
 };
 
-
 /*
  * 'user' attributes support
  */
-
-#define XATTR_USER_PREFIX "user."
-
 static size_t ocfs2_xattr_user_list(struct inode *inode, char *list,
 				    size_t list_size, const char *name,
 				    size_t name_len)
 {
-	const size_t prefix_len = sizeof(XATTR_USER_PREFIX) - 1;
+	const size_t prefix_len = XATTR_USER_PREFIX_LEN;
 	const size_t total_len = prefix_len + name_len + 1;
 	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
 
-- 
1.5.4.1
