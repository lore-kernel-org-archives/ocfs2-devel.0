From: Jan Kara <jack@suse.cz>
Date: Thu, 26 Feb 2009 21:15:00 +0100
Subject: [Ocfs2-devel] [PATCH 2/7] ocfs2: Fix lock inversion in
	ocfs2_local_read_info()
In-Reply-To: <1235679305-3920-2-git-send-email-jack@suse.cz>
References: <y> <1235679305-3920-1-git-send-email-jack@suse.cz>
	<1235679305-3920-2-git-send-email-jack@suse.cz>
Message-ID: <1235679305-3920-3-git-send-email-jack@suse.cz>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

This function is called with dqio_mutex held but it has to acquire lock
from global quota file which ranks above this lock. This is not deadlockable
lock inversion since this code path is take only during mount when noone
else can race with us but let's clean this up to silence lockdep.

We just drop the dqio_mutex in the beginning of the function and reacquire
it in the end since we don't need it - noone can race with us at this moment.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/ocfs2/quota_local.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/fs/ocfs2/quota_local.c b/fs/ocfs2/quota_local.c
index 07deec5..71cf410 100644
--- a/fs/ocfs2/quota_local.c
+++ b/fs/ocfs2/quota_local.c
@@ -655,6 +655,9 @@ static int ocfs2_local_read_info(struct super_block *sb, int type)
 	struct ocfs2_quota_recovery *rec;
 	int locked = 0;
 
+	/* We don't need the lock and we have to acquire quota file locks
+	 * which will later depend on this lock */
+	mutex_unlock(&sb_dqopt(sb)->dqio_mutex);
 	info->dqi_maxblimit = 0x7fffffffffffffffLL;
 	info->dqi_maxilimit = 0x7fffffffffffffffLL;
 	oinfo = kmalloc(sizeof(struct ocfs2_mem_dqinfo), GFP_NOFS);
@@ -733,6 +736,7 @@ static int ocfs2_local_read_info(struct super_block *sb, int type)
 		goto out_err;
 	}
 
+	mutex_lock(&sb_dqopt(sb)->dqio_mutex);
 	return 0;
 out_err:
 	if (oinfo) {
@@ -746,6 +750,7 @@ out_err:
 		kfree(oinfo);
 	}
 	brelse(bh);
+	mutex_lock(&sb_dqopt(sb)->dqio_mutex);
 	return -1;
 }
 
-- 
1.6.0.2
