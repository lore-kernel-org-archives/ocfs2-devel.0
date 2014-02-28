From: Wengang Wang <wen.gang.wang@oracle.com>
Date: Fri, 28 Feb 2014 15:41:08 +0800
Subject: [Ocfs2-devel] [PATCH] [ocfs2]: flock: drop cross-node lock when
	failed locally
Message-ID: <1393573268-21342-1-git-send-email-wen.gang.wang@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

ocfs2_do_flock() calls ocfs2_file_lock() to get the cross-node clock and then
call flock_lock_file_wait() to compete with local processes. In case
flock_lock_file_wait() failed, say -ENOMEM, clean up work is not done.
This patch adds the cleanup --drop the cross-node lock which was just granted.

Signed-off-by: Wengang Wang <wen.gang.wang@oracle.com>
---
 fs/ocfs2/locks.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/ocfs2/locks.c b/fs/ocfs2/locks.c
index e57c804..4dc89ab 100644
--- a/fs/ocfs2/locks.c
+++ b/fs/ocfs2/locks.c
@@ -82,6 +82,9 @@ static int ocfs2_do_flock(struct file *file, struct inode *inode,
 	}
 
 	ret = flock_lock_file_wait(file, fl);
+	if (ret) {
+		ocfs2_file_unlock(file);
+	}
 
 out:
 	mutex_unlock(&fp->fp_mutex);
-- 
1.8.3.1
