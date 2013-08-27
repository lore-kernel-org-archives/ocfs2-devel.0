From: akpm at linux-foundation.org <akpm@linux-foundation.org>
Date: Tue, 27 Aug 2013 14:05:04 -0700
Subject: [Ocfs2-devel] [patch 11/22] ocfs2: clean up dead code in
	ocfs2_acl_from_xattr()
Message-ID: <20130827210504.96F7031C1D6@corp2gmr1-1.hot.corp.google.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

From: Joseph Qi <joseph.qi@huawei.com>
Subject: ocfs2: clean up dead code in ocfs2_acl_from_xattr()

In ocfs2_acl_from_xattr(), if size is less than sizeof(struct
posix_acl_entry), it returns ERR_PTR(-EINVAL) directly.  Then assign (size
/ sizeof(struct posix_acl_entry)) to count which will be at least 1, that
means the following branch (count < 0) and (count == 0) will never be
true.

Signed-off-by: Joseph Qi <joseph.qi@huawei.com>
Cc: Mark Fasheh <mfasheh@suse.com>
Acked-by: Joel Becker <jlbec@evilplan.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/acl.c |    4 ----
 1 file changed, 4 deletions(-)

diff -puN fs/ocfs2/acl.c~ocfs2-clean-up-dead-code-in-ocfs2_acl_from_xattr fs/ocfs2/acl.c
--- a/fs/ocfs2/acl.c~ocfs2-clean-up-dead-code-in-ocfs2_acl_from_xattr
+++ a/fs/ocfs2/acl.c
@@ -51,10 +51,6 @@ static struct posix_acl *ocfs2_acl_from_
 		return ERR_PTR(-EINVAL);
 
 	count = size / sizeof(struct posix_acl_entry);
-	if (count < 0)
-		return ERR_PTR(-EINVAL);
-	if (count == 0)
-		return NULL;
 
 	acl = posix_acl_alloc(count, GFP_NOFS);
 	if (!acl)
_
