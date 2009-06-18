From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Wed, 17 Jun 2009 18:52:24 -0700
Subject: [Ocfs2-devel] [PATCH 6/8] ocfs2: Remove redundant gotos in
	ocfs2_mount_volume()
In-Reply-To: <1245289946-17136-1-git-send-email-sunil.mushran@oracle.com>
References: <1245289946-17136-1-git-send-email-sunil.mushran@oracle.com>
Message-ID: <1245289946-17136-7-git-send-email-sunil.mushran@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

From: Tao Ma <tao.ma@oracle.com>

Mainline commit 06c59bb896ce23c56829f6acf667faebd51dd3b8

Signed-off-by: Tao Ma <tao.ma@oracle.com>
Signed-off-by: Joel Becker <joel.becker@oracle.com>
---
 fs/ocfs2/super.c |    7 +------
 1 files changed, 1 insertions(+), 6 deletions(-)

diff --git a/fs/ocfs2/super.c b/fs/ocfs2/super.c
index 374063a..d1cd7df 100644
--- a/fs/ocfs2/super.c
+++ b/fs/ocfs2/super.c
@@ -1459,13 +1459,8 @@ static int ocfs2_mount_volume(struct super_block *sb)
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
1.6.0.4
