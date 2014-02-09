From: Rashika Kheria <rashika.kheria@gmail.com>
Date: Sun, 09 Feb 2014 13:15:28 -0000
Subject: [Ocfs2-devel] [PATCH 14/21] fs: Mark functions as static in
	ocfs2/journal.c
In-Reply-To: <b572932c3e016c55e596686283036316a1aacd2f.1391949868.git.rashika.kheria@gmail.com>
References: <b572932c3e016c55e596686283036316a1aacd2f.1391949868.git.rashika.kheria@gmail.com>
Message-ID: <1507e63dfdff4ed521f0ee255a04a3cb3db300bf.1391949868.git.rashika.kheria@gmail.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-kernel@vger.kernel.org
Cc: Mark Fasheh <mfasheh@suse.com>, Joel Becker <jlbec@evilplan.org>, ocfs2-devel@oss.oracle.com, josh@joshtriplett.org

Mark functions as static in ocfs2/journal.c because they are not used
outside this file.

This eliminates the following warning in ocfs2/journal.c:
fs/ocfs2/journal.c:106:6: warning: no previous prototype for ?ocfs2_replay_map_set_state? [-Wmissing-prototypes]
fs/ocfs2/journal.c:151:6: warning: no previous prototype for ?ocfs2_queue_replay_slots? [-Wmissing-prototypes]
fs/ocfs2/journal.c:169:6: warning: no previous prototype for ?ocfs2_free_replay_slots? [-Wmissing-prototypes]
fs/ocfs2/journal.c:1872:6: warning: no previous prototype for ?ocfs2_queue_orphan_scan? [-Wmissing-prototypes]
fs/ocfs2/journal.c:1921:6: warning: no previous prototype for?ocfs2_orphan_scan_work? [-Wmissing-prototypes]

Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>
Reviewed-by: Josh Triplett <josh@joshtriplett.org>
---
 fs/ocfs2/journal.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/fs/ocfs2/journal.c b/fs/ocfs2/journal.c
index 44fc3e5..3aa941a 100644
--- a/fs/ocfs2/journal.c
+++ b/fs/ocfs2/journal.c
@@ -103,7 +103,7 @@ struct ocfs2_replay_map {
 	unsigned char rm_replay_slots[0];
 };
 
-void ocfs2_replay_map_set_state(struct ocfs2_super *osb, int state)
+static void ocfs2_replay_map_set_state(struct ocfs2_super *osb, int state)
 {
 	if (!osb->replay_map)
 		return;
@@ -148,7 +148,7 @@ int ocfs2_compute_replay_slots(struct ocfs2_super *osb)
 	return 0;
 }
 
-void ocfs2_queue_replay_slots(struct ocfs2_super *osb)
+static void ocfs2_queue_replay_slots(struct ocfs2_super *osb)
 {
 	struct ocfs2_replay_map *replay_map = osb->replay_map;
 	int i;
@@ -166,7 +166,7 @@ void ocfs2_queue_replay_slots(struct ocfs2_super *osb)
 	replay_map->rm_state = REPLAY_DONE;
 }
 
-void ocfs2_free_replay_slots(struct ocfs2_super *osb)
+static void ocfs2_free_replay_slots(struct ocfs2_super *osb)
 {
 	struct ocfs2_replay_map *replay_map = osb->replay_map;
 
@@ -1869,7 +1869,7 @@ static inline unsigned long ocfs2_orphan_scan_timeout(void)
  * hasn't happened.  The node queues a scan and increments the
  * sequence number in the LVB.
  */
-void ocfs2_queue_orphan_scan(struct ocfs2_super *osb)
+static void ocfs2_queue_orphan_scan(struct ocfs2_super *osb)
 {
 	struct ocfs2_orphan_scan *os;
 	int status, i;
@@ -1918,7 +1918,7 @@ out:
 }
 
 /* Worker task that gets fired every ORPHAN_SCAN_SCHEDULE_TIMEOUT millsec */
-void ocfs2_orphan_scan_work(struct work_struct *work)
+static void ocfs2_orphan_scan_work(struct work_struct *work)
 {
 	struct ocfs2_orphan_scan *os;
 	struct ocfs2_super *osb;
-- 
1.7.9.5
