From: Joseph Qi <joseph.qi@huawei.com>
Date: Thu, 18 Jun 2015 15:44:03 +0800
Subject: [Ocfs2-devel] [PATCH] ocfs2: mark local functions as static
Message-ID: <558276C3.3080207@huawei.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Some functions are only used locally, so mark them as static.

Signed-off-by: Joseph Qi <joseph.qi@huawei.com>
---
 fs/ocfs2/journal.c | 10 +++++-----
 fs/ocfs2/xattr.c   |  2 +-
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/fs/ocfs2/journal.c b/fs/ocfs2/journal.c
index be77f3c..8017032 100644
--- a/fs/ocfs2/journal.c
+++ b/fs/ocfs2/journal.c
@@ -108,7 +108,7 @@ struct ocfs2_replay_map {
 	unsigned char rm_replay_slots[0];
 };

-void ocfs2_replay_map_set_state(struct ocfs2_super *osb, int state)
+static void ocfs2_replay_map_set_state(struct ocfs2_super *osb, int state)
 {
 	if (!osb->replay_map)
 		return;
@@ -153,7 +153,7 @@ int ocfs2_compute_replay_slots(struct ocfs2_super *osb)
 	return 0;
 }

-void ocfs2_queue_replay_slots(struct ocfs2_super *osb,
+static void ocfs2_queue_replay_slots(struct ocfs2_super *osb,
 		enum ocfs2_orphan_reco_type orphan_reco_type)
 {
 	struct ocfs2_replay_map *replay_map = osb->replay_map;
@@ -173,7 +173,7 @@ void ocfs2_queue_replay_slots(struct ocfs2_super *osb,
 	replay_map->rm_state = REPLAY_DONE;
 }

-void ocfs2_free_replay_slots(struct ocfs2_super *osb)
+static void ocfs2_free_replay_slots(struct ocfs2_super *osb)
 {
 	struct ocfs2_replay_map *replay_map = osb->replay_map;

@@ -1897,7 +1897,7 @@ static inline unsigned long ocfs2_orphan_scan_timeout(void)
  * hasn't happened.  The node queues a scan and increments the
  * sequence number in the LVB.
  */
-void ocfs2_queue_orphan_scan(struct ocfs2_super *osb)
+static void ocfs2_queue_orphan_scan(struct ocfs2_super *osb)
 {
 	struct ocfs2_orphan_scan *os;
 	int status, i;
@@ -1946,7 +1946,7 @@ out:
 }

 /* Worker task that gets fired every ORPHAN_SCAN_SCHEDULE_TIMEOUT millsec */
-void ocfs2_orphan_scan_work(struct work_struct *work)
+static void ocfs2_orphan_scan_work(struct work_struct *work)
 {
 	struct ocfs2_orphan_scan *os;
 	struct ocfs2_super *osb;
diff --git a/fs/ocfs2/xattr.c b/fs/ocfs2/xattr.c
index d03bfbf..889f379 100644
--- a/fs/ocfs2/xattr.c
+++ b/fs/ocfs2/xattr.c
@@ -7271,7 +7271,7 @@ static int ocfs2_xattr_security_set(struct dentry *dentry, const char *name,
 			       name, value, size, flags);
 }

-int ocfs2_initxattrs(struct inode *inode, const struct xattr *xattr_array,
+static int ocfs2_initxattrs(struct inode *inode, const struct xattr *xattr_array,
 		     void *fs_info)
 {
 	const struct xattr *xattr;
-- 
1.8.4.3
