From: Gang He <ghe@suse.com>
Date: Tue, 11 Jun 2019 09:54:12 +0800
Subject: [Ocfs2-devel] [PATCH V4 1/3] ocfs2: add last unlock times in
	locking_state
Message-ID: <20190611015414.27754-1-ghe@suse.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: mark@fasheh.com, jlbec@evilplan.org, joseph.qi@linux.alibaba.com
Cc: Gang He <ghe@suse.com>, linux-kernel@vger.kernel.org, ocfs2-devel@oss.oracle.com, akpm@linux-foundation.org

ocfs2 file system uses locking_state file under debugfs to dump
each ocfs2 file system's dlm lock resources, but the dlm lock
resources in memory are becoming more and more after the files
were touched by the user. it will become a bit difficult to analyze
these dlm lock resource records in locking_state file by the upper
scripts, though some files are not active for now, which were
accessed long time ago.
Then, I'd like to add last pr/ex unlock times in locking_state file
for each dlm lock resource record, the the upper scripts can use
last unlock time to filter inactive dlm lock resource record.

Compared with v1, the main change is to use wall time in
microsecond for last pr/ex unlock time.

Signed-off-by: Gang He <ghe@suse.com>
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
---
 fs/ocfs2/dlmglue.c | 18 +++++++++++++++---
 fs/ocfs2/ocfs2.h   |  1 +
 2 files changed, 16 insertions(+), 3 deletions(-)

diff --git a/fs/ocfs2/dlmglue.c b/fs/ocfs2/dlmglue.c
index af405586c5b1..3b0e7d399df2 100644
--- a/fs/ocfs2/dlmglue.c
+++ b/fs/ocfs2/dlmglue.c
@@ -474,6 +474,8 @@ static void ocfs2_update_lock_stats(struct ocfs2_lock_res *res, int level,
 
 	if (ret)
 		stats->ls_fail++;
+
+	stats->ls_last = ktime_to_us(ktime_get_real());
 }
 
 static inline void ocfs2_track_lock_refresh(struct ocfs2_lock_res *lockres)
@@ -3093,8 +3095,10 @@ static void *ocfs2_dlm_seq_next(struct seq_file *m, void *v, loff_t *pos)
  *	- Lock stats printed
  * New in version 3
  *	- Max time in lock stats is in usecs (instead of nsecs)
+ * New in version 4
+ *	- Add last pr/ex unlock times in usecs
  */
-#define OCFS2_DLM_DEBUG_STR_VERSION 3
+#define OCFS2_DLM_DEBUG_STR_VERSION 4
 static int ocfs2_dlm_seq_show(struct seq_file *m, void *v)
 {
 	int i;
@@ -3145,6 +3149,8 @@ static int ocfs2_dlm_seq_show(struct seq_file *m, void *v)
 # define lock_max_prmode(_l)		((_l)->l_lock_prmode.ls_max)
 # define lock_max_exmode(_l)		((_l)->l_lock_exmode.ls_max)
 # define lock_refresh(_l)		((_l)->l_lock_refresh)
+# define lock_last_prmode(_l)		((_l)->l_lock_prmode.ls_last)
+# define lock_last_exmode(_l)		((_l)->l_lock_exmode.ls_last)
 #else
 # define lock_num_prmode(_l)		(0)
 # define lock_num_exmode(_l)		(0)
@@ -3155,6 +3161,8 @@ static int ocfs2_dlm_seq_show(struct seq_file *m, void *v)
 # define lock_max_prmode(_l)		(0)
 # define lock_max_exmode(_l)		(0)
 # define lock_refresh(_l)		(0)
+# define lock_last_prmode(_l)		(0ULL)
+# define lock_last_exmode(_l)		(0ULL)
 #endif
 	/* The following seq_print was added in version 2 of this output */
 	seq_printf(m, "%u\t"
@@ -3165,7 +3173,9 @@ static int ocfs2_dlm_seq_show(struct seq_file *m, void *v)
 		   "%llu\t"
 		   "%u\t"
 		   "%u\t"
-		   "%u\t",
+		   "%u\t"
+		   "%llu\t"
+		   "%llu\t",
 		   lock_num_prmode(lockres),
 		   lock_num_exmode(lockres),
 		   lock_num_prmode_failed(lockres),
@@ -3174,7 +3184,9 @@ static int ocfs2_dlm_seq_show(struct seq_file *m, void *v)
 		   lock_total_exmode(lockres),
 		   lock_max_prmode(lockres),
 		   lock_max_exmode(lockres),
-		   lock_refresh(lockres));
+		   lock_refresh(lockres),
+		   lock_last_prmode(lockres),
+		   lock_last_exmode(lockres));
 
 	/* End the line */
 	seq_printf(m, "\n");
diff --git a/fs/ocfs2/ocfs2.h b/fs/ocfs2/ocfs2.h
index 1f029fbe8b8d..6f43651f01b3 100644
--- a/fs/ocfs2/ocfs2.h
+++ b/fs/ocfs2/ocfs2.h
@@ -164,6 +164,7 @@ struct ocfs2_lock_stats {
 
 	/* Storing max wait in usecs saves 24 bytes per inode */
 	u32		ls_max;		/* Max wait in USEC */
+	u64		ls_last;	/* Last unlock time in USEC */
 };
 #endif
 
-- 
2.21.0
