From: Junxiao Bi <junxiao.bi@oracle.com>
Date: Thu, 12 Nov 2015 09:57:13 +0800
Subject: [Ocfs2-devel] [PATCH] ocfs2: fix umask ignored issue
Message-ID: <1447293433-23973-1-git-send-email-junxiao.bi@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

New created file's mode is not masked with umask, and this makes
umask not work for ocfs2 volume.

Fixes: 702e5bc ("ocfs2: use generic posix ACL infrastructure")
Signed-off-by: Junxiao Bi <junxiao.bi@oracle.com>
---
 fs/ocfs2/namei.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/ocfs2/namei.c b/fs/ocfs2/namei.c
index 3b48ac2..a03f6f4 100644
--- a/fs/ocfs2/namei.c
+++ b/fs/ocfs2/namei.c
@@ -372,6 +372,8 @@ static int ocfs2_mknod(struct inode *dir,
 		mlog_errno(status);
 		goto leave;
 	}
+	/* update inode->i_mode after mask with "umask". */
+	inode->i_mode = mode;
 
 	handle = ocfs2_start_trans(osb, ocfs2_mknod_credits(osb->sb,
 							    S_ISDIR(mode),
-- 
1.7.9.5
