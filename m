From: Xue jiufei <xuejiufei@huawei.com>
Date: Tue, 14 Aug 2012 10:03:17 +0800
Subject: [Ocfs2-devel] [PATCH] ocfs2: skip locks in the blocked list
Message-ID: <5029B1E5.4030509@huawei.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

  A parallel umount on 4 nodes triggered a bug in dlm_process_recovery_date(). Here?s the situation:
  Receiving MIG_LOCKRES message, A node processes the locks in migratable lockres. It copys lvb from migratable lockres when processing the first valid lock. 
If there is a lock in the blocked list with the EX level, it triggers the BUG. Since valid lvbs are set when locks are granted with EX or PR levels, locks in 
the blocked list cannot have valid lvbs. Therefore I think we should skip the locks in the blocked list.

Signed-off-by: Xuejiufei <xuejiufei@huawei.com>
---
 fs/ocfs2/dlm/dlmrecovery.c |    7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/fs/ocfs2/dlm/dlmrecovery.c b/fs/ocfs2/dlm/dlmrecovery.c
index 01ebfd0..15d81ad 100644
--- a/fs/ocfs2/dlm/dlmrecovery.c
+++ b/fs/ocfs2/dlm/dlmrecovery.c
@@ -1887,6 +1887,13 @@ static int dlm_process_recovery_data(struct dlm_ctxt *dlm,
 
 		if (ml->type == LKM_NLMODE)
 			goto skip_lvb;
+		
+		/*
+		 * If the lock is in the blocked list it can't have a valid lvb,
+		 * so skip it
+		 */
+		if (ml->list == DLM_BLOCKED_LIST)
+			goto skip_lvb;
 
 		if (!dlm_lvb_is_empty(mres->lvb)) {
 			if (lksb->flags & DLM_LKSB_PUT_LVB) {
-- 
1.7.9.7
