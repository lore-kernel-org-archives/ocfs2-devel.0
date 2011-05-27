From: Tiger Yang <tiger.yang@oracle.com>
Date: Sat, 28 May 2011 00:34:52 +0800
Subject: [Ocfs2-devel] [PATCH 1/1] ocfs2: remove redundant and incorrect
	mlog_error
Message-ID: <1306514092-22962-1-git-send-email-tiger.yang@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

We have already mlog all error and positive status is not error.

Signed-off-by: Tiger Yang <tiger.yang@oracle.com>
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
1.7.4.4
