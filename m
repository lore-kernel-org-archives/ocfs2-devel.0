From: tao.ma <tao.ma@oracle.com>
Date: Thu Mar 29 00:01:21 2007
Subject: [Ocfs2-devel] Remove the printing of harmless ERRORS like
	ECONNRESET, EPIPE
Message-ID: <460B6434.7020401@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Remove the printing of harmless ERRORS like ECONNRESET, EPIPE.
For more details, see
http://oss.oracle.com/bugzilla/show_bug.cgi?id=865

The ocfs2 kernel source code in git tree don't have function
"ocfs2_file_sendfile", so this bug only exists in ocfs2-1.2 branch.


-------------- next part --------------
Index: fs/ocfs2/file.c
===================================================================
--- fs/ocfs2/file.c	(revision 3001)
+++ fs/ocfs2/file.c	(working copy)
@@ -368,8 +368,6 @@ static ssize_t ocfs2_file_sendfile(struc
 	down_read(&OCFS2_I(inode)->ip_alloc_sem);
 
 	ret = generic_file_sendfile(in_file, ppos, count, actor, target);
-	if (ret < 0)
-		mlog_errno(ret);
 
 	up_read(&OCFS2_I(inode)->ip_alloc_sem);
 
