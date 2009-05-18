From: Tao Ma <tao.ma@oracle.com>
Date: Tue, 19 May 2009 06:47:20 +0800
Subject: [Ocfs2-devel] [PATCH] ocfs2/trivial: Code cleanup of
	ocfs2_mount_volume.
Message-ID: <1242686840-19116-1-git-send-email-tao.ma@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

No need for nonsense "goto leave" in the end of ocfs2_mount_volume.

Signed-off-by: Tao Ma <tao.ma@oracle.com>
---
 fs/ocfs2/super.c |    7 +------
 1 files changed, 1 insertions(+), 6 deletions(-)

diff --git a/fs/ocfs2/super.c b/fs/ocfs2/super.c
index 79ff8d9..4601a57 100644
--- a/fs/ocfs2/super.c
+++ b/fs/ocfs2/super.c
@@ -1766,13 +1766,8 @@ static int ocfs2_mount_volume(struct super_block *sb)
 	}
 
 	status = ocfs2_truncate_log_init(osb);
-	if (status < 0) {
+	if (status < 0)
 		mlog_errno(status);
-		goto leave;
-	}
-
-	if (ocfs2_mount_local(osb))
-		goto leave;
 
 leave:
 	if (unlock_super)
-- 
1.6.1.40.g8ea6a
