From: Jan Kara <jack@suse.cz>
Date: Fri, 10 Feb 2012 10:50:07 +0100
Subject: [Ocfs2-devel] [PATCH] ocfs2: Fix bogus error message from
	ocfs2_global_read_info
Message-ID: <1328867407-11557-1-git-send-email-jack@suse.cz>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

'status' variable in ocfs2_global_read_info() is always != 0 when leaving the
function because it happens to contain number of read bytes. Thus we always log
error message although everything is OK. Since all error cases properly call
mlog_errno() before jumping to out_err, there's no reason to call mlog_errno()
on exit at all. This is a fallout of c1e8d35e (conversion of mlog_exit()
calls).

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/ocfs2/quota_global.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/fs/ocfs2/quota_global.c b/fs/ocfs2/quota_global.c
index 92fcd57..0a86e30 100644
--- a/fs/ocfs2/quota_global.c
+++ b/fs/ocfs2/quota_global.c
@@ -399,8 +399,6 @@ int ocfs2_global_read_info(struct super_block *sb, int type)
 			      msecs_to_jiffies(oinfo->dqi_syncms));
 
 out_err:
-	if (status)
-		mlog_errno(status);
 	return status;
 out_unlock:
 	ocfs2_unlock_global_qf(oinfo, 0);
-- 
1.7.1
