From: Wengang Wang <wen.gang.wang@oracle.com>
Date: Thu, 10 Sep 2009 00:58:03 +0800
Subject: [Ocfs2-devel] [PATCH] ocfs2: remove DIR check in ocfs2_link
Message-ID: <200909090901.n8991eUh011394@rgminet15.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

  there is check on the inode whether it is a DIR in ocfs2_link().
the same check is done in vfs_link already, so remove it from ocfs2_link().

Signed-off-by: Wengang Wang <wen.gang.wang@oracle.com>
---
 fs/ocfs2/namei.c |    3 ---
 1 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/fs/ocfs2/namei.c b/fs/ocfs2/namei.c
index 33464c6..35809c0 100644
--- a/fs/ocfs2/namei.c
+++ b/fs/ocfs2/namei.c
@@ -633,9 +633,6 @@ static int ocfs2_link(struct dentry *old_dentry,
 		   old_dentry->d_name.len, old_dentry->d_name.name,
 		   dentry->d_name.len, dentry->d_name.name);
 
-	if (S_ISDIR(inode->i_mode))
-		return -EPERM;
-
 	err = ocfs2_inode_lock(dir, &parent_fe_bh, 1);
 	if (err < 0) {
 		if (err != -ENOENT)
-- 
1.6.2.5
