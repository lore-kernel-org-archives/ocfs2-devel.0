From: Jan Kara <jack@suse.cz>
Date: Thu, 26 Feb 2009 21:14:59 +0100
Subject: [Ocfs2-devel] [PATCH 1/7] ocfs2: Fix possible deadlock in
	ocfs2_global_read_dquot()
In-Reply-To: <1235679305-3920-1-git-send-email-jack@suse.cz>
References: <y>
 <1235679305-3920-1-git-send-email-jack@suse.cz>
Message-ID: <1235679305-3920-2-git-send-email-jack@suse.cz>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

It is not possible to get a read lock and then try to get the same write lock
in one thread as that can block on downconvert being requested by other node
leading to deadlock. So first drop the quota lock for reading and only after
that get it for writing.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/ocfs2/quota_global.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/fs/ocfs2/quota_global.c b/fs/ocfs2/quota_global.c
index 1ed0f7c..edfa60c 100644
--- a/fs/ocfs2/quota_global.c
+++ b/fs/ocfs2/quota_global.c
@@ -421,6 +421,7 @@ int ocfs2_global_read_dquot(struct dquot *dquot)
 	OCFS2_DQUOT(dquot)->dq_originodes = dquot->dq_dqb.dqb_curinodes;
 	if (!dquot->dq_off) {	/* No real quota entry? */
 		/* Upgrade to exclusive lock for allocation */
+		ocfs2_qinfo_unlock(info, 0);
 		err = ocfs2_qinfo_lock(info, 1);
 		if (err < 0)
 			goto out_qlock;
@@ -435,7 +436,8 @@ int ocfs2_global_read_dquot(struct dquot *dquot)
 out_qlock:
 	if (ex)
 		ocfs2_qinfo_unlock(info, 1);
-	ocfs2_qinfo_unlock(info, 0);
+	else
+		ocfs2_qinfo_unlock(info, 0);
 out:
 	if (err < 0)
 		mlog_errno(err);
-- 
1.6.0.2
