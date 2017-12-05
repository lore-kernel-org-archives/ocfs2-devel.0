From: Arnd Bergmann <arnd@arndb.de>
Date: Tue,  5 Dec 2017 16:20:50 +0100
Subject: [Ocfs2-devel] [PATCH] ocfs2: use get_task_comm
Message-ID: <20171205152110.2050975-1-arnd@arndb.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Mark Fasheh <mfasheh@versity.com>, Joel Becker <jlbec@evilplan.org>
Cc: Kees Cook <keescook@chromium.org>, Arnd Bergmann <arnd@arndb.de>, Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>, Joseph Qi <jiangqi903@gmail.com>, piaojun <piaojun@huawei.com>, ocfs2-devel@oss.oracle.com, linux-kernel@vger.kernel.org

While reviewing all callers of get_task_comm(), I stumbled
over this one that claimed it was not exported, when in fact
it is. Accessing task->comm directly is not safe, so better
convert this one to using get_task_comm as well.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 fs/ocfs2/cluster/netdebug.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/fs/ocfs2/cluster/netdebug.c b/fs/ocfs2/cluster/netdebug.c
index 74a21f6695c8..a51d001b89b1 100644
--- a/fs/ocfs2/cluster/netdebug.c
+++ b/fs/ocfs2/cluster/netdebug.c
@@ -130,6 +130,7 @@ static void *nst_seq_next(struct seq_file *seq, void *v, loff_t *pos)
 static int nst_seq_show(struct seq_file *seq, void *v)
 {
 	struct o2net_send_tracking *nst, *dummy_nst = seq->private;
+	char comm[TASK_COMM_LEN];
 	ktime_t now;
 	s64 sock, send, status;
 
@@ -142,8 +143,8 @@ static int nst_seq_show(struct seq_file *seq, void *v)
 	sock = ktime_to_us(ktime_sub(now, nst->st_sock_time));
 	send = ktime_to_us(ktime_sub(now, nst->st_send_time));
 	status = ktime_to_us(ktime_sub(now, nst->st_status_time));
+	get_task_comm(comm, nst->st_task);
 
-	/* get_task_comm isn't exported.  oh well. */
 	seq_printf(seq, "%p:\n"
 		   "  pid:          %lu\n"
 		   "  tgid:         %lu\n"
@@ -158,7 +159,7 @@ static int nst_seq_show(struct seq_file *seq, void *v)
 		   "  wait start:   %lld usecs ago\n",
 		   nst, (unsigned long)task_pid_nr(nst->st_task),
 		   (unsigned long)nst->st_task->tgid,
-		   nst->st_task->comm, nst->st_node,
+		   comm, nst->st_node,
 		   nst->st_sc, nst->st_id, nst->st_msg_type,
 		   nst->st_msg_key,
 		   (long long)sock,
-- 
2.9.0
