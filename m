From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Wed, 22 Dec 2010 12:39:38 -0800
Subject: [Ocfs2-devel] [PATCH 2/6] ocfs2/cluster: Replace timeval with ktime
	in struct o2net_send_tracking
In-Reply-To: <1293050382-3636-1-git-send-email-sunil.mushran@oracle.com>
References: <1293050382-3636-1-git-send-email-sunil.mushran@oracle.com>
Message-ID: <1293050382-3636-3-git-send-email-sunil.mushran@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Replace time trackers in struct o2net_send_tracking from struct timeval to
union ktime.

Signed-off-by: Sunil Mushran <sunil.mushran@oracle.com>
---
 fs/ocfs2/cluster/netdebug.c     |   22 +++++++++++++---------
 fs/ocfs2/cluster/tcp.c          |    6 +++---
 fs/ocfs2/cluster/tcp_internal.h |    6 +++---
 3 files changed, 19 insertions(+), 15 deletions(-)

diff --git a/fs/ocfs2/cluster/netdebug.c b/fs/ocfs2/cluster/netdebug.c
index 0edf836..2b986aa 100644
--- a/fs/ocfs2/cluster/netdebug.c
+++ b/fs/ocfs2/cluster/netdebug.c
@@ -123,10 +123,17 @@ static void *nst_seq_next(struct seq_file *seq, void *v, loff_t *pos)
 static int nst_seq_show(struct seq_file *seq, void *v)
 {
 	struct o2net_send_tracking *nst, *dummy_nst = seq->private;
+	ktime_t now;
+	s64 sock, send, status;
 
 	spin_lock(&o2net_debug_lock);
 	nst = next_nst(dummy_nst);
 
+	now = ktime_get();
+	sock = ktime_to_us(ktime_sub(now, nst->st_sock_time));
+	send = ktime_to_us(ktime_sub(now, nst->st_send_time));
+	status = ktime_to_us(ktime_sub(now, nst->st_status_time));
+
 	if (nst != NULL) {
 		/* get_task_comm isn't exported.  oh well. */
 		seq_printf(seq, "%p:\n"
@@ -138,20 +145,17 @@ static int nst_seq_show(struct seq_file *seq, void *v)
 			   "  message id:   %d\n"
 			   "  message type: %u\n"
 			   "  message key:  0x%08x\n"
-			   "  sock acquiry: %lu.%ld\n"
-			   "  send start:   %lu.%ld\n"
-			   "  wait start:   %lu.%ld\n",
+			   "  sock acquiry: %lld usecs ago\n"
+			   "  send start:   %lld usecs ago\n"
+			   "  wait start:   %lld usecs ago\n",
 			   nst, (unsigned long)task_pid_nr(nst->st_task),
 			   (unsigned long)nst->st_task->tgid,
 			   nst->st_task->comm, nst->st_node,
 			   nst->st_sc, nst->st_id, nst->st_msg_type,
 			   nst->st_msg_key,
-			   nst->st_sock_time.tv_sec,
-			   (long)nst->st_sock_time.tv_usec,
-			   nst->st_send_time.tv_sec,
-			   (long)nst->st_send_time.tv_usec,
-			   nst->st_status_time.tv_sec,
-			   (long)nst->st_status_time.tv_usec);
+			   (long long)sock,
+			   (long long)send,
+			   (long long)status);
 	}
 
 	spin_unlock(&o2net_debug_lock);
diff --git a/fs/ocfs2/cluster/tcp.c b/fs/ocfs2/cluster/tcp.c
index 9aa426e..5996158 100644
--- a/fs/ocfs2/cluster/tcp.c
+++ b/fs/ocfs2/cluster/tcp.c
@@ -155,17 +155,17 @@ static void o2net_init_nst(struct o2net_send_tracking *nst, u32 msgtype,
 
 static void o2net_set_nst_sock_time(struct o2net_send_tracking *nst)
 {
-	do_gettimeofday(&nst->st_sock_time);
+	nst->st_sock_time = ktime_get();
 }
 
 static void o2net_set_nst_send_time(struct o2net_send_tracking *nst)
 {
-	do_gettimeofday(&nst->st_send_time);
+	nst->st_send_time = ktime_get();
 }
 
 static void o2net_set_nst_status_time(struct o2net_send_tracking *nst)
 {
-	do_gettimeofday(&nst->st_status_time);
+	nst->st_status_time = ktime_get();
 }
 
 static void o2net_set_nst_sock_container(struct o2net_send_tracking *nst,
diff --git a/fs/ocfs2/cluster/tcp_internal.h b/fs/ocfs2/cluster/tcp_internal.h
index 15fdbdf..b613aaa 100644
--- a/fs/ocfs2/cluster/tcp_internal.h
+++ b/fs/ocfs2/cluster/tcp_internal.h
@@ -220,9 +220,9 @@ struct o2net_send_tracking {
 	u32				st_msg_type;
 	u32				st_msg_key;
 	u8				st_node;
-	struct timeval			st_sock_time;
-	struct timeval			st_send_time;
-	struct timeval			st_status_time;
+	ktime_t				st_sock_time;
+	ktime_t				st_send_time;
+	ktime_t				st_status_time;
 };
 #else
 struct o2net_send_tracking {
-- 
1.7.1
