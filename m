From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Thu,  1 Mar 2012 11:34:17 -0800
Subject: [Ocfs2-devel] [PATCH 3/9] ocfs2: Silence message in
	ocfs2_global_read_info()
In-Reply-To: <1330630463-30305-1-git-send-email-sunil.mushran@oracle.com>
References: <1330630463-30305-1-git-send-email-sunil.mushran@oracle.com>
Message-ID: <1330630463-30305-3-git-send-email-sunil.mushran@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Mainline commit c1e8d35ef5ffb393b94a192034b5e3541e005d75 removed mlog_exit()
and replaced it with mlog_errno() in some cases.

This change in ocfs2_global_read_info() caused it to spew the following during mount.
[   38.745584] (mount.ocfs2,3315,4):ocfs2_global_read_info:403 ERROR: status = 24

This patch silences this message.

Signed-off-by: Sunil Mushran <sunil.mushran@oracle.com>
---
 fs/ocfs2/quota_global.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/ocfs2/quota_global.c b/fs/ocfs2/quota_global.c
index b24eab3..2a3f12c 100644
--- a/fs/ocfs2/quota_global.c
+++ b/fs/ocfs2/quota_global.c
@@ -413,7 +413,7 @@ int ocfs2_global_read_info(struct super_block *sb, int type)
 	INIT_DELAYED_WORK(&oinfo->dqi_sync_work, qsync_work_fn);
 	schedule_delayed_work(&oinfo->dqi_sync_work,
 			      msecs_to_jiffies(oinfo->dqi_syncms));
-
+	status = 0;
 out_err:
 	if (status)
 		mlog_errno(status);
-- 
1.7.7.6
