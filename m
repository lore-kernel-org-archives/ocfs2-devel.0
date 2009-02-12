From: wengang wang <wen.gang.wang@oracle.com>
Date: Thu, 12 Feb 2009 15:47:26 +0800
Subject: [Ocfs2-devel] [PATCH 1/1] OCFS2: add IO error check in
	ocfs2_get_sector() -v2
Message-ID: <200902120748.n1C7mVqx020705@acsinet13.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

checks IO error in ocfs2_get_sector().

this patch is based on 1.4 git.

Signed-off-by: Wengang wang <wen.gang.wang@oracle.com>
--
Index: fs/ocfs2/super.c
===================================================================
--- fs/ocfs2/super.c	(revision 128)
+++ fs/ocfs2/super.c	(working copy)
@@ -1203,6 +1203,12 @@ static int ocfs2_get_sector(struct super
 	unlock_buffer(*bh);
 	ll_rw_block(READ, 1, bh);
 	wait_on_buffer(*bh);
+	if (!buffer_uptodate(*bh)) {
+		mlog_errno(-EIO);
+		brelse(*bh);
+		return -EIO;
+	}
+
 	return 0;
 }
 
