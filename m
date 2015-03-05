From: Dan Carpenter <dan.carpenter@oracle.com>
Date: Thu, 5 Mar 2015 20:47:59 +0300
Subject: [Ocfs2-devel] [patch 2/2 v2] posix_acl: make posix_acl_create()
	safer and cleaner
In-Reply-To: <20150124193124.GA18322@mwanda>
Message-ID: <20150305174759.GB13294@mwanda>
List-Id: <ocfs2-devel.oss.oracle.com>
References: <20150124193124.GA18322@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: linux-fsdevel@vger.kernel.org, ocfs2-devel@oss.oracle.com, kernel-janitors@vger.kernel.org

If posix_acl_create() returns an error code then "*acl" and
"*default_acl" can be uninitialized or point to freed memory.  This is a
dangerous thing to do.  For example, it causes a problem in
ocfs2_reflink():

	fs/ocfs2/refcounttree.c:4327 ocfs2_reflink()
	error: potentially using uninitialized 'default_acl'.

I've re-written this so we set the pointers to NULL at the start.
I've added a temporary "clone" variable to hold the value of "*acl"
until end.  Setting them to NULL means means we don't need the "no_acl"
label.  We may as well remove the "apply_umask" stuff forward and remove
that label as well.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
v2: Update to latest kernel.

diff --git a/fs/posix_acl.c b/fs/posix_acl.c
index 3a48bb7..a327300 100644
--- a/fs/posix_acl.c
+++ b/fs/posix_acl.c
@@ -547,51 +547,45 @@ posix_acl_create(struct inode *dir, umode_t *mode,
 		struct posix_acl **default_acl, struct posix_acl **acl)
 {
 	struct posix_acl *p;
+	struct posix_acl *clone;
 	int ret;
 
+	*acl = NULL;
+	*default_acl = NULL;
+
 	if (S_ISLNK(*mode) || !IS_POSIXACL(dir))
-		goto no_acl;
+		return 0;
 
 	p = get_acl(dir, ACL_TYPE_DEFAULT);
-	if (IS_ERR(p)) {
-		if (p == ERR_PTR(-EOPNOTSUPP))
-			goto apply_umask;
-		return PTR_ERR(p);
+	if (!p || p == ERR_PTR(-EOPNOTSUPP)) {
+		*mode &= ~current_umask();
+		return 0;
 	}
+	if (IS_ERR(p))
+		return PTR_ERR(p);
 
-	if (!p)
-		goto apply_umask;
-
-	*acl = posix_acl_clone(p, GFP_NOFS);
-	if (!*acl)
+	clone = posix_acl_clone(p, GFP_NOFS);
+	if (!clone)
 		goto no_mem;
 
-	ret = posix_acl_create_masq(*acl, mode);
+	ret = posix_acl_create_masq(clone, mode);
 	if (ret < 0)
 		goto no_mem_clone;
 
-	if (ret == 0) {
-		posix_acl_release(*acl);
-		*acl = NULL;
-	}
+	if (ret == 0)
+		posix_acl_release(clone);
+	else
+		*acl = clone;
 
-	if (!S_ISDIR(*mode)) {
+	if (!S_ISDIR(*mode))
 		posix_acl_release(p);
-		*default_acl = NULL;
-	} else {
+	else
 		*default_acl = p;
-	}
-	return 0;
 
-apply_umask:
-	*mode &= ~current_umask();
-no_acl:
-	*default_acl = NULL;
-	*acl = NULL;
 	return 0;
 
 no_mem_clone:
-	posix_acl_release(*acl);
+	posix_acl_release(clone);
 no_mem:
 	posix_acl_release(p);
 	return -ENOMEM;
