From: Shuning Zhang <sunny.s.zhang@oracle.com>
Date: Mon, 30 Sep 2019 11:17:39 +0800
Subject: [Ocfs2-devel] [PATCH] ocfs2: move the mlog from the spinlock to
	outside
Message-ID: <1569813459-8601-1-git-send-email-sunny.s.zhang@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

There is a potential task of deadlock. Because the mask
is 0, the deadlock does not occur now. But There is a
potential task. If someone change the mask of mlog, but
forget to modify the order of the mlog and spin_unlock,
There will be a potential deadlock.So I move the mlog
from the spinlock to outsize.

Signed-off-by: Shuning Zhang <sunny.s.zhang@oracle.com>
---
 fs/ocfs2/dlmglue.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ocfs2/dlmglue.c b/fs/ocfs2/dlmglue.c
index 1420723..9960e61 100644
--- a/fs/ocfs2/dlmglue.c
+++ b/fs/ocfs2/dlmglue.c
@@ -2315,10 +2315,10 @@ static int ocfs2_inode_lock_update(struct inode *inode,
 
 	spin_lock(&oi->ip_lock);
 	if (oi->ip_flags & OCFS2_INODE_DELETED) {
+		spin_unlock(&oi->ip_lock);
 		mlog(0, "Orphaned inode %llu was deleted while we "
 		     "were waiting on a lock. ip_flags = 0x%x\n",
 		     (unsigned long long)oi->ip_blkno, oi->ip_flags);
-		spin_unlock(&oi->ip_lock);
 		status = -ENOENT;
 		goto bail;
 	}
-- 
2.7.4
