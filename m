From: Dmitry Monakhov <dmonakhov@openvz.org>
Date: Wed, 17 Feb 2010 21:43:26 +0300
Subject: [Ocfs2-devel] [PATCH 12/19] ocfs2: replace inode uid, gid,
	mode initialization with helper function
In-Reply-To: <1266431353-8549-1-git-send-email-dmonakhov@openvz.org>
References: <1266431353-8549-1-git-send-email-dmonakhov@openvz.org>
Message-ID: <1266432206-9512-1-git-send-email-dmonakhov@openvz.org>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-fsdevel@vger.kernel.org
Cc: ocfs2-devel@oss.oracle.com, Dmitry Monakhov <dmonakhov@openvz.org>


Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
---
 fs/ocfs2/dlm/dlmfs.c |   11 +----------
 fs/ocfs2/namei.c     |    9 +--------
 2 files changed, 2 insertions(+), 18 deletions(-)

diff --git a/fs/ocfs2/dlm/dlmfs.c b/fs/ocfs2/dlm/dlmfs.c
index 02bf178..248df45 100644
--- a/fs/ocfs2/dlm/dlmfs.c
+++ b/fs/ocfs2/dlm/dlmfs.c
@@ -364,9 +364,7 @@ static struct inode *dlmfs_get_inode(struct inode *parent,
 	if (!inode)
 		return NULL;
 
-	inode->i_mode = mode;
-	inode->i_uid = current_fsuid();
-	inode->i_gid = current_fsgid();
+	inode_init_owner(inode, parent, mode);
 	inode->i_mapping->backing_dev_info = &dlmfs_backing_dev_info;
 	inode->i_atime = inode->i_mtime = inode->i_ctime = CURRENT_TIME;
 
@@ -403,13 +401,6 @@ static struct inode *dlmfs_get_inode(struct inode *parent,
 		inc_nlink(inode);
 		break;
 	}
-
-	if (parent->i_mode & S_ISGID) {
-		inode->i_gid = parent->i_gid;
-		if (S_ISDIR(mode))
-			inode->i_mode |= S_ISGID;
-	}
-
 	return inode;
 }
 
diff --git a/fs/ocfs2/namei.c b/fs/ocfs2/namei.c
index 50fb26a..2877404 100644
--- a/fs/ocfs2/namei.c
+++ b/fs/ocfs2/namei.c
@@ -204,14 +204,7 @@ static struct inode *ocfs2_get_init_inode(struct inode *dir, int mode)
 		inode->i_nlink = 2;
 	else
 		inode->i_nlink = 1;
-	inode->i_uid = current_fsuid();
-	if (dir->i_mode & S_ISGID) {
-		inode->i_gid = dir->i_gid;
-		if (S_ISDIR(mode))
-			mode |= S_ISGID;
-	} else
-		inode->i_gid = current_fsgid();
-	inode->i_mode = mode;
+	inode_init_owner(inode, dir, mode);
 	vfs_dq_init(inode);
 	return inode;
 }
-- 
1.6.6
