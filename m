From: Junxiao Bi <junxiao.bi@oracle.com>
Date: Fri,  8 Jun 2012 14:08:05 +0800
Subject: [Ocfs2-devel] [PATCH v3 2/2] ocfs2: clear unaligned io flag when
	dio fails
In-Reply-To: <1339135685-28797-1-git-send-email-junxiao.bi@oracle.com>
References: <1339135685-28797-1-git-send-email-junxiao.bi@oracle.com>
Message-ID: <1339135685-28797-3-git-send-email-junxiao.bi@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

The unaligned io flag is set in the kiocb when an unaligned
dio is issued, it should be cleared even when the dio fails,
or it may affect the following io which are using the same
kiocb.

Signed-off-by: Junxiao Bi <junxiao.bi@oracle.com>
Cc: stable at vger.kernel.org
---
 fs/ocfs2/file.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/ocfs2/file.c b/fs/ocfs2/file.c
index 061591a..98513c8 100644
--- a/fs/ocfs2/file.c
+++ b/fs/ocfs2/file.c
@@ -2422,8 +2422,10 @@ out_dio:
 		unaligned_dio = 0;
 	}
 
-	if (unaligned_dio)
+	if (unaligned_dio) {
+		ocfs2_iocb_clear_unaligned_aio(iocb);
 		atomic_dec(&OCFS2_I(inode)->ip_unaligned_aio);
+	}
 
 out:
 	if (rw_level != -1)
-- 
1.7.9.5
