From: Tao Ma <tao.ma@oracle.com>
Date: Tue, 25 Nov 2008 07:21:35 +0800
Subject: [Ocfs2-devel] [PATCH 1/2] ocfs2/quota: Initialized status to 0 in
	ocfs2_dquot_drop_slow.
In-Reply-To: <492BA5B1.20005@oracle.com>
References: <492BA5B1.20005@oracle.com>
Message-ID: <1227568896-6724-1-git-send-email-tao.ma@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

In ocfs2_dquot_drop_slow, get a build warning that "status" may
be used uninitalized, so initialize it to "0".

Signed-off-by: Tao Ma <tao.ma@oracle.com>
---
 fs/ocfs2/quota_global.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/ocfs2/quota_global.c b/fs/ocfs2/quota_global.c
index d2a5bfa..e5f3906 100644
--- a/fs/ocfs2/quota_global.c
+++ b/fs/ocfs2/quota_global.c
@@ -873,7 +873,7 @@ out:
 
 static int ocfs2_dquot_drop_slow(struct inode *inode)
 {
-	int status;
+	int status = 0;
 	int cnt;
 	int got_lock[MAXQUOTAS] = {0, 0};
 	handle_t *handle;
@@ -895,7 +895,7 @@ static int ocfs2_dquot_drop_slow(struct inode *inode)
 	if (IS_ERR(handle)) {
 		status = PTR_ERR(handle);
 		mlog_errno(status);
-				goto out;
+		goto out;
 	}
 	dquot_drop(inode);
 	ocfs2_commit_trans(OCFS2_SB(sb), handle);
-- 
1.5.4.GIT
