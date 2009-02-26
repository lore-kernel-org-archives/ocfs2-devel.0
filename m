From: Jan Kara <jack@suse.cz>
Date: Thu, 26 Feb 2009 21:15:02 +0100
Subject: [Ocfs2-devel] [PATCH 4/7] ocfs2: Fix possible deadlock in quota
	recovery
In-Reply-To: <1235679305-3920-4-git-send-email-jack@suse.cz>
References: <y> <1235679305-3920-1-git-send-email-jack@suse.cz>
	<1235679305-3920-2-git-send-email-jack@suse.cz>
	<1235679305-3920-3-git-send-email-jack@suse.cz>
	<1235679305-3920-4-git-send-email-jack@suse.cz>
Message-ID: <1235679305-3920-5-git-send-email-jack@suse.cz>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

In ocfs2_finish_quota_recovery() we acquired global quota file lock and started
recovering local quota file. During this process we need to get quota
structures, which calls ocfs2_dquot_acquire() which gets global quota file lock
again. This second lock can block in case some other node has requested the
quota file lock in the mean time. Fix the problem by moving quota file locking
down into the function where it is really needed.  Then dqget() or dqput()
won't be called with the lock held.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/ocfs2/quota_local.c |   16 +++++++++-------
 1 files changed, 9 insertions(+), 7 deletions(-)

diff --git a/fs/ocfs2/quota_local.c b/fs/ocfs2/quota_local.c
index 71cf410..5a460fa 100644
--- a/fs/ocfs2/quota_local.c
+++ b/fs/ocfs2/quota_local.c
@@ -444,10 +444,6 @@ static int ocfs2_recover_local_quota_file(struct inode *lqinode,
 
 	mlog_entry("ino=%lu type=%u", (unsigned long)lqinode->i_ino, type);
 
-	status = ocfs2_lock_global_qf(oinfo, 1);
-	if (status < 0)
-		goto out;
-
 	list_for_each_entry_safe(rchunk, next, &(rec->r_list[type]), rc_list) {
 		chunk = rchunk->rc_chunk;
 		hbh = NULL;
@@ -480,12 +476,18 @@ static int ocfs2_recover_local_quota_file(struct inode *lqinode,
 				     type);
 				goto out_put_bh;
 			}
+			status = ocfs2_lock_global_qf(oinfo, 1);
+			if (status < 0) {
+				mlog_errno(status);
+				goto out_put_dquot;
+			}
+
 			handle = ocfs2_start_trans(OCFS2_SB(sb),
 						   OCFS2_QSYNC_CREDITS);
 			if (IS_ERR(handle)) {
 				status = PTR_ERR(handle);
 				mlog_errno(status);
-				goto out_put_dquot;
+				goto out_drop_lock;
 			}
 			mutex_lock(&sb_dqopt(sb)->dqio_mutex);
 			spin_lock(&dq_data_lock);
@@ -523,6 +525,8 @@ static int ocfs2_recover_local_quota_file(struct inode *lqinode,
 out_commit:
 			mutex_unlock(&sb_dqopt(sb)->dqio_mutex);
 			ocfs2_commit_trans(OCFS2_SB(sb), handle);
+out_drop_lock:
+			ocfs2_unlock_global_qf(oinfo, 1);
 out_put_dquot:
 			dqput(dquot);
 out_put_bh:
@@ -537,8 +541,6 @@ out_put_bh:
 		if (status < 0)
 			break;
 	}
-	ocfs2_unlock_global_qf(oinfo, 1);
-out:
 	if (status < 0)
 		free_recovery_list(&(rec->r_list[type]));
 	mlog_exit(status);
-- 
1.6.0.2
