From: Mark Fasheh <mfasheh@suse.com>
Date: Fri, 4 Dec 2009 14:08:57 -0800
Subject: [Ocfs2-devel] [PATCH] ocfs2-1.4: fix sendfile locking
Message-ID: <20091204220857.GT11402@wotan.suse.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

ocfs2_sendfile() was duplicating locking which happens later on in
ocfs2_readpage(). The double locking would sometimes cause a lockup in nfsd,
which uses ->sendfile() for fast read support. An easy way to see this is to
mount an exported ocfs2 fs on a client and initiate two parallel read/write
dd commands to the same file when there is low memory on the server.

Fix ocfs2_sendfile() so that it only takes and immediately drops the cluster
lock. This is consistent with the locking in ocfs2_file_splice_read().

Signed-off-by: Mark Fasheh <mfasheh@suse.com>

Index: linux/fs/ocfs2/file.c
===================================================================
--- linux.orig/fs/ocfs2/file.c
+++ linux/fs/ocfs2/file.c
@@ -2511,15 +2511,14 @@ static ssize_t ocfs2_file_sendfile(struc
 		mlog_errno(ret);
 		goto bail;
 	}
+	ocfs2_inode_unlock(inode, 0);
 
-	down_read(&OCFS2_I(inode)->ip_alloc_sem);
-
+	/*
+	 * This uses ->readpage, so we don't want to hold any cluster
+	 * locks before the call.
+	 */
 	ret = generic_file_sendfile(in_file, ppos, count, actor, target);
 
-	up_read(&OCFS2_I(inode)->ip_alloc_sem);
-
-	ocfs2_inode_unlock(inode, 0);
-
 bail:
 	mlog_exit(ret);
 	return ret;
