From: Joseph Qi <joseph.qi@huawei.com>
Date: Thu, 2 May 2013 20:56:50 +0800
Subject: [Ocfs2-devel] [PATCH v2] ocfs2: fix possible memory leak in
	dlm_process_recovery_data
Message-ID: <51826292.2000001@huawei.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

We found a possible memory leak in dlm_process_recovery_data when doing
code review. In dlm_process_recovery_data, it creates newlock each time,
but don't free when it is bad, and then it will lead to memory leak.

Cc: stable at vger.kernel.org
Signed-off-by: Joseph Qi <joseph.qi@huawei.com>
Reviewed-by: Jie Liu <jeff.liu@oracle.com>

---
 fs/ocfs2/dlm/dlmrecovery.c |    4 ++++
 1 file changed, 4 insertions(+)

diff --git a/fs/ocfs2/dlm/dlmrecovery.c b/fs/ocfs2/dlm/dlmrecovery.c
index eeac97b..9f08523 100644
--- a/fs/ocfs2/dlm/dlmrecovery.c
+++ b/fs/ocfs2/dlm/dlmrecovery.c
@@ -1974,6 +1974,10 @@ skip_lvb:
 			     res->lockname.len, res->lockname.name, ml->node);
 			dlm_lockres_set_refmap_bit(dlm, res, ml->node);
 			added++;
+		} else {
+			/* Free the new lock if it is bad */
+			dlm_lock_put(newlock);
+			newlock = NULL;
 		}
 		spin_unlock(&res->spinlock);
 	}
-- 
1.7.9.7

-------------- next part --------------
An HTML attachment was scrubbed...
URL: http://oss.oracle.com/pipermail/ocfs2-devel/attachments/20130502/a288dc6b/attachment.html 
