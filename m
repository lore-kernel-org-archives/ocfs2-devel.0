From: Liuwenyi <qingshenlwy@gmail.com>
Date: Mon, 21 Dec 2009 20:01:00 +0800
Subject: [Ocfs2-devel] [PATCHv2 10/12]posix_acl: Add the check items
Message-ID: <4B2F637C.2080506@gmail.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: mfasheh@suse.com, joel.becker@oracle.com, tiger.yang@oracle.com, viro@zeniv.linux.org.uk, jmorris@namei.org, ocfs2-devel@oss.oracle.com, linux-kernel@vger.kernel.org, strongzgy@gmail.com, onlyflyer@gmail.com

move the ACL validation check in to fs/posix_acl.c.
Including nullpointer check and PTR_ERR check.

---
Signed-off-by: Liuwenyi <qingshenlwy@gmail.com>
Cc: Mark Fasheh <mfasheh@suse.com>
Cc: Joel Becker <joel.becker@oracle.com>
Cc: Tiger Yang <tiger.yang@oracle.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: James Morris <jmorris@namei.org>
Cc: ocfs2-devel at oss.oracle.com
Cc: linux-kernel at vger.kernel.org

---
diff --git a/fs/ocfs2/acl.c b/fs/ocfs2/acl.c
index e3e4741..b11c72c 100644
--- a/fs/ocfs2/acl.c
+++ b/fs/ocfs2/acl.c
@@ -408,13 +408,9 @@ static int ocfs2_xattr_set_acl(struct dentry
*dentry, const char *name,

if (value) {
acl = posix_acl_from_xattr(value, size);
- if (IS_ERR(acl))
- return PTR_ERR(acl);
- else if (acl) {
- ret = posix_acl_valid(acl);
- if (ret)
- goto cleanup;
- }
+ ret = posix_acl_valid(acl);
+ if (ret)
+ goto cleanup;
} else
acl = NULL;


-- 
Best Regards,
Liuwenyi
