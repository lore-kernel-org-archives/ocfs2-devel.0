From: Zhang, Sonic <sonic.zhang@intel.com>
Date: Wed Jul 28 02:08:42 2004
Subject: [Ocfs2-devel] 
	A patch to fix a typo error in ocfs_file_read(), which causes
	performance drop.
Message-ID: <37FBBA5F3A361C41AB7CE44558C3448E04C6FCE0@pdsmsx403>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi,

	I found a typo error in ocfs_file_read(), which causes
performance drop.
	See my patch. 

	Thanks.


--------------------------------------
--- file.c.old	2004-07-28 14:58:00.018535576 +0800
+++ file.c	2004-07-28 14:58:32.835546632 +0800
@@ -853,11 +853,9 @@
 			filp->f_flags |= O_DIRECT;
 		else
 			filp->f_flags &= ~O_DIRECT;
-		ret = generic_file_write (filp, buf, count, ppos);
+		ret = generic_file_read (filp, buf, count, ppos);
 		filp->f_flags = savedflags;
 	}
-
-	ret = generic_file_read (filp, buf, count, ppos);
 #else
 	if (do_direct_io) 
 		ret = ocfs_rw_direct (READ, filp, buf, count, ppos);
