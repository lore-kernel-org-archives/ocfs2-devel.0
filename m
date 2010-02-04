From: Wengang Wang <wen.gang.wang@oracle.com>
Date: Thu, 4 Feb 2010 16:20:18 -0500
Subject: [Ocfs2-devel] [PATCH] ocfs2: fix a refcount condition checking
Message-ID: <201002041330.o145sMME005597@acsinet15.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi Joel/Tao,

I don't know the reflink very well, so please ignore this patch if I am wrong.

I think in ocfs2_prepare_inode_for_write(), we disable DIO write if the inode
has reflink.
If am right, the way we determine if the inode has reflink is wrong in case
(!has_refcount && direct_io).

Signed-off-by: Wengang Wang <wen.gang.wang@oracle.com>
---
 fs/ocfs2/file.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/fs/ocfs2/file.c b/fs/ocfs2/file.c
index 06ccf6a..77ebb6e 100644
--- a/fs/ocfs2/file.c
+++ b/fs/ocfs2/file.c
@@ -1775,7 +1775,7 @@ static int ocfs2_prepare_inode_for_write(struct dentry *dentry,
 					 int *direct_io,
 					 int *has_refcount)
 {
-	int ret = 0, meta_level = 0;
+	int ret = 0, meta_level = 0, refcount = 0;
 	struct inode *inode = dentry->d_inode;
 	loff_t saved_pos, end;
 
@@ -1834,6 +1834,7 @@ static int ocfs2_prepare_inode_for_write(struct dentry *dentry,
 							       saved_pos,
 							       count,
 							       &meta_level);
+			refcount = 1;
 			if (has_refcount)
 				*has_refcount = 1;
 		}
@@ -1859,7 +1860,7 @@ static int ocfs2_prepare_inode_for_write(struct dentry *dentry,
 			break;
 		}
 
-		if (has_refcount && *has_refcount == 1) {
+		if (refcount) {
 			*direct_io = 0;
 			break;
 		}
-- 
1.6.6
