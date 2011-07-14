From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Thu, 14 Jul 2011 15:50:26 -0700
Subject: [Ocfs2-devel] [PATCH 15/16] ocfs2: Add comment about orphan scanning
In-Reply-To: <1310683827-19157-1-git-send-email-sunil.mushran@oracle.com>
References: <1310683827-19157-1-git-send-email-sunil.mushran@oracle.com>
Message-ID: <1310683827-19157-16-git-send-email-sunil.mushran@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Add a comment that explains the reason as to why orphan scan scans all the slots.

Signed-off-by: Sunil Mushran <sunil.mushran@oracle.com>
---
 fs/ocfs2/journal.c |   14 ++++++++++++++
 1 files changed, 14 insertions(+), 0 deletions(-)

diff --git a/fs/ocfs2/journal.c b/fs/ocfs2/journal.c
index 8eaaa78..0a42ae9 100644
--- a/fs/ocfs2/journal.c
+++ b/fs/ocfs2/journal.c
@@ -1811,6 +1811,20 @@ static inline unsigned long ocfs2_orphan_scan_timeout(void)
  * every slot, queuing a recovery of the slot on the ocfs2_wq thread. This
  * is done to catch any orphans that are left over in orphan directories.
  *
+ * It scans all slots, even ones that are in use. It does so to handle the
+ * case described below:
+ *
+ *   Node 1 has an inode it was using. The dentry went away due to memory
+ *   pressure.  Node 1 closes the inode, but it's on the free list. The node
+ *   has the open lock.
+ *   Node 2 unlinks the inode. It grabs the dentry lock to notify others,
+ *   but node 1 has no dentry and doesn't get the message. It trylocks the
+ *   open lock, sees that another node has a PR, and does nothing.
+ *   Later node 2 runs its orphan dir. It igets the inode, trylocks the
+ *   open lock, sees the PR still, and does nothing.
+ *   Basically, we have to trigger an orphan iput on node 1. The only way
+ *   for this to happen is if node 1 runs node 2's orphan dir.
+ *
  * ocfs2_queue_orphan_scan gets called every ORPHAN_SCAN_SCHEDULE_TIMEOUT
  * seconds.  It gets an EX lock on os_lockres and checks sequence number
  * stored in LVB. If the sequence number has changed, it means some other
-- 
1.7.4.1
