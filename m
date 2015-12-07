From: Junxiao Bi <junxiao.bi@oracle.com>
Date: Mon,  7 Dec 2015 12:09:06 +0800
Subject: [Ocfs2-devel] [PATCH] ocfs2: fix SGID not inherited issue
Message-ID: <1449461346-21864-1-git-send-email-junxiao.bi@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

commit 8f1eb48758aa ("ocfs2: fix umask ignored issue") introduced an issue,
SGID of sub dir was not inherited from its parents dir. It is because SGID
is set into "inode->i_mode" in ocfs2_get_init_inode(), but is overwritten
by "mode" which don't have SGID set later.

Fixes: 8f1eb48758aa ("ocfs2: fix umask ignored issue")
Signed-off-by: Junxiao Bi <junxiao.bi@oracle.com>
Cc: <stable@vger.kernel.org>
---
 fs/ocfs2/namei.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/fs/ocfs2/namei.c b/fs/ocfs2/namei.c
index a03f6f4..3123408 100644
--- a/fs/ocfs2/namei.c
+++ b/fs/ocfs2/namei.c
@@ -367,13 +367,11 @@ static int ocfs2_mknod(struct inode *dir,
 		goto leave;
 	}
 
-	status = posix_acl_create(dir, &mode, &default_acl, &acl);
+	status = posix_acl_create(dir, &inode->i_mode, &default_acl, &acl);
 	if (status) {
 		mlog_errno(status);
 		goto leave;
 	}
-	/* update inode->i_mode after mask with "umask". */
-	inode->i_mode = mode;
 
 	handle = ocfs2_start_trans(osb, ocfs2_mknod_credits(osb->sb,
 							    S_ISDIR(mode),
-- 
1.7.9.5
