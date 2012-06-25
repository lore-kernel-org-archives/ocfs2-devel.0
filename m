From: Tiger Yang <tiger.yang@oracle.com>
Date: Mon, 25 Jun 2012 16:03:24 +0800
Subject: [Ocfs2-devel] [PATCH 1/1] ocfs2: remove redundant and incorrect
	mlog_error
In-Reply-To: <4FE81A93.6010200@oracle.com>
References: <4FE81A93.6010200@oracle.com>
Message-ID: <1340611404-17808-1-git-send-email-tiger.yang@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

out_err already logged all the negative status, so remove mlog_errno
before goto there. If quota_read succeed, positive (non zero)
status should be return and it's not a error.

Signed-off-by: Tiger Yang <tiger.yang@oracle.com>
---
 fs/ocfs2/quota_global.c |   11 +++--------
 1 files changed, 3 insertions(+), 8 deletions(-)

diff --git a/fs/ocfs2/quota_global.c b/fs/ocfs2/quota_global.c
index 92fcd57..cb0f017 100644
--- a/fs/ocfs2/quota_global.c
+++ b/fs/ocfs2/quota_global.c
@@ -358,10 +358,8 @@ int ocfs2_global_read_info(struct super_block *sb, int type)
 	oinfo->dqi_gqi_count = 0;
 	oinfo->dqi_gqinode = gqinode;
 	status = ocfs2_lock_global_qf(oinfo, 0);
-	if (status < 0) {
-		mlog_errno(status);
+	if (status < 0)
 		goto out_err;
-	}
 
 	status = ocfs2_extent_map_get_blocks(gqinode, 0, &oinfo->dqi_giblk,
 					     &pcount, NULL);
@@ -381,7 +379,6 @@ int ocfs2_global_read_info(struct super_block *sb, int type)
 		     status);
 		if (status >= 0)
 			status = -EIO;
-		mlog_errno(status);
 		goto out_err;
 	}
 	info->dqi_bgrace = le32_to_cpu(dinfo.dqi_bgrace);
@@ -398,14 +395,12 @@ int ocfs2_global_read_info(struct super_block *sb, int type)
 	schedule_delayed_work(&oinfo->dqi_sync_work,
 			      msecs_to_jiffies(oinfo->dqi_syncms));
 
-out_err:
-	if (status)
-		mlog_errno(status);
 	return status;
 out_unlock:
 	ocfs2_unlock_global_qf(oinfo, 0);
+out_err:
 	mlog_errno(status);
-	goto out_err;
+	return status;
 }
 
 /* Write information to global quota file. Expects exlusive lock on quota
-- 
1.7.4.4
