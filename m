From: Joseph Qi <joseph.qi@huawei.com>
Date: Wed, 17 Dec 2014 08:50:31 +0800
Subject: [Ocfs2-devel] [PATCH] ocfs2: remove bogus check in
	dlm_process_recovery_data
Message-ID: <5490D357.1080506@huawei.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

In dlm_process_recovery_data, only when dlm_new_lock failed the ret
will be set to -ENOMEM. And in this case, newlock is definitely NULL.
So test newlock is meaningless, remove it.

Signed-off-by: Joseph Qi <joseph.qi@huawei.com>
Reviewed-by: Alex Chen <alex.chen@huawei.com>
---
 fs/ocfs2/dlm/dlmrecovery.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/fs/ocfs2/dlm/dlmrecovery.c b/fs/ocfs2/dlm/dlmrecovery.c
index 3365839..a239010 100644
--- a/fs/ocfs2/dlm/dlmrecovery.c
+++ b/fs/ocfs2/dlm/dlmrecovery.c
@@ -2015,11 +2015,8 @@ leave:
 	dlm_lockres_drop_inflight_ref(dlm, res);
 	spin_unlock(&res->spinlock);

-	if (ret < 0) {
+	if (ret < 0)
 		mlog_errno(ret);
-		if (newlock)
-			dlm_lock_put(newlock);
-	}

 	return ret;
 }
-- 
1.8.4.3
