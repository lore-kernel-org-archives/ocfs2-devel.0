From: Joel Becker <Joel.Becker@oracle.com>
Date: Mon, 6 Apr 2009 16:43:42 -0700
Subject: [Ocfs2-devel] [PATCH] ocfs2: Use nd_set_link().
Message-ID: <20090406234341.GB30246@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

ocfs2 was hand-calling vfs_follow_link(), but there's no point to that.
Let's use page_follow_link_light() and nd_set_link().

Signed-off-by: Joel Becker <joel.becker@oracle.com>
---
 fs/ocfs2/symlink.c |   77 +++++++++++++++++++++++++---------------------------
 1 files changed, 37 insertions(+), 40 deletions(-)

diff --git a/fs/ocfs2/symlink.c b/fs/ocfs2/symlink.c
index ed0a0cf..579dd1b 100644
--- a/fs/ocfs2/symlink.c
+++ b/fs/ocfs2/symlink.c
@@ -39,6 +39,7 @@
 #include <linux/slab.h>
 #include <linux/pagemap.h>
 #include <linux/utsname.h>
+#include <linux/namei.h>
 
 #define MLOG_MASK_PREFIX ML_NAMEI
 #include <cluster/masklog.h>
@@ -54,26 +55,6 @@
 
 #include "buffer_head_io.h"
 
-static char *ocfs2_page_getlink(struct dentry * dentry,
-				struct page **ppage);
-static char *ocfs2_fast_symlink_getlink(struct inode *inode,
-					struct buffer_head **bh);
-
-/* get the link contents into pagecache */
-static char *ocfs2_page_getlink(struct dentry * dentry,
-				struct page **ppage)
-{
-	struct page * page;
-	struct address_space *mapping = dentry->d_inode->i_mapping;
-	page = read_mapping_page(mapping, 0, NULL);
-	if (IS_ERR(page))
-		goto sync_fail;
-	*ppage = page;
-	return kmap(page);
-
-sync_fail:
-	return (char*)page;
-}
 
 static char *ocfs2_fast_symlink_getlink(struct inode *inode,
 					struct buffer_head **bh)
@@ -128,40 +109,55 @@ out:
 	return ret;
 }
 
-static void *ocfs2_follow_link(struct dentry *dentry,
-			       struct nameidata *nd)
+static void *ocfs2_fast_follow_link(struct dentry *dentry,
+				    struct nameidata *nd)
 {
-	int status;
-	char *link;
+	int status = 0;
+	int len;
+	char *target, *link = ERR_PTR(-ENOMEM);
 	struct inode *inode = dentry->d_inode;
-	struct page *page = NULL;
 	struct buffer_head *bh = NULL;
-	
-	if (ocfs2_inode_is_fast_symlink(inode))
-		link = ocfs2_fast_symlink_getlink(inode, &bh);
-	else
-		link = ocfs2_page_getlink(dentry, &page);
-	if (IS_ERR(link)) {
-		status = PTR_ERR(link);
+
+	mlog_entry_void();
+
+	BUG_ON(!ocfs2_inode_is_fast_symlink(inode));
+	target = ocfs2_fast_symlink_getlink(inode, &bh);
+	if (IS_ERR(target)) {
+		status = PTR_ERR(target);
 		mlog_errno(status);
 		goto bail;
 	}
 
-	status = vfs_follow_link(nd, link);
+	/* Fast symlinks can't be large */
+	len = strlen(target);
+	link = kzalloc(len + 1, GFP_NOFS);
+	if (!link) {
+		status = -ENOMEM;
+		mlog_errno(status);
+		goto bail;
+	}
+
+	memcpy(link, target, len);
+	nd_set_link(nd, link);
 
 bail:
-	if (page) {
-		kunmap(page);
-		page_cache_release(page);
-	}
 	brelse(bh);
 
-	return ERR_PTR(status);
+	mlog_exit(status);
+	return status ? ERR_PTR(status) : link;
+}
+
+static void ocfs2_fast_put_link(struct dentry *dentry, struct nameidata *nd, void *cookie)
+{
+	char *link = cookie;
+
+	kfree(link);
 }
 
 const struct inode_operations ocfs2_symlink_inode_operations = {
 	.readlink	= page_readlink,
-	.follow_link	= ocfs2_follow_link,
+	.follow_link	= page_follow_link_light,
+	.put_link	= page_put_link,
 	.getattr	= ocfs2_getattr,
 	.setattr	= ocfs2_setattr,
 	.setxattr	= generic_setxattr,
@@ -171,7 +167,8 @@ const struct inode_operations ocfs2_symlink_inode_operations = {
 };
 const struct inode_operations ocfs2_fast_symlink_inode_operations = {
 	.readlink	= ocfs2_readlink,
-	.follow_link	= ocfs2_follow_link,
+	.follow_link	= ocfs2_fast_follow_link,
+	.put_link	= ocfs2_fast_put_link,
 	.getattr	= ocfs2_getattr,
 	.setattr	= ocfs2_setattr,
 	.setxattr	= generic_setxattr,
-- 
1.6.1.3


-- 

Life's Little Instruction Book #444

	"Never underestimate the power of a kind word or deed."

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
