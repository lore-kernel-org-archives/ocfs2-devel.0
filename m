From: wengang wang <wen.gang.wang@oracle.com>
Date: Fri, 20 Feb 2009 23:05:14 +0800
Subject: [Ocfs2-devel] [PATCH 1/1] OCFS2: add error check for
	ocfs2_read_locked_inode() call
Message-ID: <200902201506.n1KF6GQp004110@rgminet15.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

(resend if my first attemp not failed)
add error check for ocfs2_read_locked_inode() call.

Signed-off-by: Wengang Wang <wen.gang.wang@oracle.com>
--
Index: inode.c
===================================================================
--- inode.c	(revision 149)
+++ inode.c	(working copy)
@@ -118,6 +118,7 @@ struct inode *ocfs2_iget(struct ocfs2_su
 	struct inode *inode = NULL;
 	struct super_block *sb = osb->sb;
 	struct ocfs2_find_inode_args args;
+	int status;
 
 	mlog_entry("(blkno = %llu)\n", (unsigned long long)blkno);
 
@@ -142,7 +143,12 @@ struct inode *ocfs2_iget(struct ocfs2_su
 	 * afterwards. */
 	if (inode && inode->i_state & I_NEW) {
 		mlog(0, "Inode was not in inode cache, reading it.\n");
-		ocfs2_read_locked_inode(inode, &args);
+		status = ocfs2_read_locked_inode(inode, &args);
+		if (status) {
+			iput(inode);
+			inode = ERR_PTR(status);
+			goto bail;
+		}
 		unlock_new_inode(inode);
 	}
 	if (inode == NULL) {
