From: Dan Carpenter <dan.carpenter@oracle.com>
Date: Tue, 25 Nov 2014 19:43:47 +0300
Subject: [Ocfs2-devel] [patch] ocfs2: remove bogus NULL check in
	ocfs2_move_extents()
Message-ID: <20141125164347.GD19894@mwanda>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

"inode" isn't NULL here, and also we dereference it on the previous line
so static checkers get annoyed.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/fs/ocfs2/move_extents.c b/fs/ocfs2/move_extents.c
index 74caffe..56a768d 100644
--- a/fs/ocfs2/move_extents.c
+++ b/fs/ocfs2/move_extents.c
@@ -904,9 +904,6 @@ static int ocfs2_move_extents(struct ocfs2_move_extents_context *context)
 	struct buffer_head *di_bh = NULL;
 	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
 
-	if (!inode)
-		return -ENOENT;
-
 	if (ocfs2_is_hard_readonly(osb) || ocfs2_is_soft_readonly(osb))
 		return -EROFS;
 
