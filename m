From: Dan Carpenter <error27@gmail.com>
Date: Wed, 8 Apr 2009 13:48:23 +0300 (EAT)
Subject: [Ocfs2-devel] [patch] unlock i_mutex in error path
Message-ID: <alpine.DEB.2.00.0904071935520.26512@bicker>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

There is an error path in ocfs2_quota_write() that doesn't unlock 
&gqinode->i_mutex().  That seems unintentional.

Found by smatch (http://repo.or.cz/w/smatch.git).  Compile tested.

regards,
dan carpenter

Signed-off-by: Dan Carpenter <error27@gmail.com>

--- orig/fs/ocfs2/quota_global.c	2009-04-07 19:34:22.000000000 +0300
+++ devel/fs/ocfs2/quota_global.c	2009-04-07 19:34:25.000000000 +0300
@@ -232,10 +232,8 @@
 		err = ocfs2_get_quota_block(gqinode, blk, &bh);
 		ja_type = OCFS2_JOURNAL_ACCESS_CREATE;
 	}
-	if (err) {
-		mlog_errno(err);
-		return err;
-	}
+	if (err) 
+		goto out;
 	lock_buffer(bh);
 	if (new)
 		memset(bh->b_data, 0, sb->s_blocksize);
