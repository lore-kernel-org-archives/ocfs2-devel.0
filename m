From: Rashika Kheria <rashika.kheria@gmail.com>
Date: Sun, 09 Feb 2014 13:16:24 -0000
Subject: [Ocfs2-devel] [PATCH 15/21] fs: Mark function as static in
	ocfs2/xattr.c
In-Reply-To: <b572932c3e016c55e596686283036316a1aacd2f.1391949868.git.rashika.kheria@gmail.com>
References: <b572932c3e016c55e596686283036316a1aacd2f.1391949868.git.rashika.kheria@gmail.com>
Message-ID: <4c4a91b6cb44627906572e2beae874160a470362.1391949868.git.rashika.kheria@gmail.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-kernel@vger.kernel.org
Cc: Mark Fasheh <mfasheh@suse.com>, Joel Becker <jlbec@evilplan.org>, ocfs2-devel@oss.oracle.com, josh@joshtriplett.org

Mark functions as static in ocfs2/xattr.c because it is not used outside
this file.

This eliminates the following warning in ocfs2/xattr.c:
fs/ocfs2/xattr.c:7256:5: warning: no previous prototype for ?ocfs2_initxattrs? [-Wmissing-prototypes]

Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>
Reviewed-by: Josh Triplett <josh@joshtriplett.org>
---
 fs/ocfs2/xattr.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/ocfs2/xattr.c b/fs/ocfs2/xattr.c
index 185fa3b7..7041df5 100644
--- a/fs/ocfs2/xattr.c
+++ b/fs/ocfs2/xattr.c
@@ -7256,8 +7256,8 @@ static int ocfs2_xattr_security_set(struct dentry *dentry, const char *name,
 			       name, value, size, flags);
 }
 
-int ocfs2_initxattrs(struct inode *inode, const struct xattr *xattr_array,
-		     void *fs_info)
+static int ocfs2_initxattrs(struct inode *inode, const struct xattr *xattr_array,
+			    void *fs_info)
 {
 	const struct xattr *xattr;
 	int err = 0;
-- 
1.7.9.5
