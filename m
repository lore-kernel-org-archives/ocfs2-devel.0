From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Wed Jan 16 11:33:05 2008
Subject: [Ocfs2-devel] [PATCH 07/20] ocfs2: fix rename vs unlink race
In-Reply-To: <1200511977-19513-1-git-send-email-sunil.mushran@oracle.com>
References: <1200511977-19513-1-git-send-email-sunil.mushran@oracle.com>
Message-ID: <1200511977-19513-8-git-send-email-sunil.mushran@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Mainline commit e325a88f17196f18888f6e1426eb9fe3b4346d28
Author: Srinivas Eeda <srinivas.eeda@oracle.com>
Date: Wed, 31 Oct 2007 16:49:43 -0700

If another node unlinks the destination while ocfs2_rename() is waiting on a
cluster lock, ocfs2_rename() simply logs an error and continues. This causes
a crash because the renaming node is now trying to delete a non-existent
inode. The correct solution is to return -ENOENT.

Signed-off-by: Srinivas Eeda <srinivas.eeda@oracle.com>
Signed-off-by: Mark Fasheh <mark.fasheh@oracle.com>
---
 fs/ocfs2/namei.c |   13 ++++++++++---
 1 files changed, 10 insertions(+), 3 deletions(-)

diff --git a/fs/ocfs2/namei.c b/fs/ocfs2/namei.c
index 6d822b7..f9533f7 100644
--- a/fs/ocfs2/namei.c
+++ b/fs/ocfs2/namei.c
@@ -1105,9 +1105,16 @@ static int ocfs2_rename(struct inode *old_dir,
 		goto bail;
 	}
 
-	if (!new_de && new_inode)
-		mlog(ML_ERROR, "inode %lu does not exist in it's parent "
-		     "directory!", new_inode->i_ino);
+	if (!new_de && new_inode) {
+		/*
+		 * Target was unlinked by another node while we were
+		 * waiting to get to ocfs2_rename(). There isn't
+		 * anything we can do here to help the situation, so
+		 * bubble up the appropriate error.
+		 */
+		status = -ENOENT;
+		goto bail;
+	}
 
 	/* In case we need to overwrite an existing file, we blow it
 	 * away first */
-- 
1.5.3.4
