From: Alexander Beregalov <a.beregalov@gmail.com>
Date: Tue, 05 Aug 2008 20:51:43 -0000
Subject: [Ocfs2-devel] [PATCH] ocfs2/cluster/netdebug.c: fix warning
In-Reply-To: <20080805202948.GL22600@mail.oracle.com>
References: <20080805201036.GC17320@orion>
	<20080805202948.GL22600@mail.oracle.com>
Message-ID: <20080805205041.GD17320@orion>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: mfasheh@suse.com, ocfs2-devel@oss.oracle.com, linux-kernel@vger.kernel.org

On Tue, Aug 05, 2008 at 01:29:48PM -0700, Joel Becker wrote:
> 	suseconds_t is a signed long.  Can you change the format to %ld
> and cast to long?  Unfortunately, we need the cast, as sparc64 and
> parisc treat it as int.

Then we should change cast from unsigned long to long for every tv_usec, right?


From: Alexander Beregalov <a.beregalov@gmail.com>

ocfs2/cluster/netdebug.c: fix warning

fs/ocfs2/cluster/netdebug.c:154: warning: format '%lu' expects
     type 'long unsigned int', but argument 17 has type 'suseconds_t'

Joel Becker wrote:
>       suseconds_t is a signed long.  Can you change the format to %ld
> and cast to long?  Unfortunately, we need the cast, as sparc64 and
> parisc treat it as int.

Signed-off-by: Alexander Beregalov <a.beregalov@gmail.com>
---
 
 fs/ocfs2/cluster/netdebug.c |   26 +++++++++++++-------------
 1 files changed, 13 insertions(+), 13 deletions(-)

diff --git a/fs/ocfs2/cluster/netdebug.c b/fs/ocfs2/cluster/netdebug.c
index d8bfa0e..52276c0 100644
--- a/fs/ocfs2/cluster/netdebug.c
+++ b/fs/ocfs2/cluster/netdebug.c
@@ -138,20 +138,20 @@ static int nst_seq_show(struct seq_file *seq, void *v)
 			   "  message id:   %d\n"
 			   "  message type: %u\n"
 			   "  message key:  0x%08x\n"
-			   "  sock acquiry: %lu.%lu\n"
-			   "  send start:   %lu.%lu\n"
-			   "  wait start:   %lu.%lu\n",
+			   "  sock acquiry: %lu.%ld\n"
+			   "  send start:   %lu.%ld\n"
+			   "  wait start:   %lu.%ld\n",
 			   nst, (unsigned long)nst->st_task->pid,
 			   (unsigned long)nst->st_task->tgid,
 			   nst->st_task->comm, nst->st_node,
 			   nst->st_sc, nst->st_id, nst->st_msg_type,
 			   nst->st_msg_key,
 			   nst->st_sock_time.tv_sec,
-			   (unsigned long)nst->st_sock_time.tv_usec,
+			   (long)nst->st_sock_time.tv_usec,
 			   nst->st_send_time.tv_sec,
-			   (unsigned long)nst->st_send_time.tv_usec,
+			   (long)nst->st_send_time.tv_usec,
 			   nst->st_status_time.tv_sec,
-			   nst->st_status_time.tv_usec);
+			   (long)nst->st_status_time.tv_usec);
 	}
 
 	spin_unlock(&o2net_debug_lock);
@@ -276,7 +276,7 @@ static void *sc_seq_next(struct seq_file *seq, void *v, loff_t *pos)
 	return sc; /* unused, just needs to be null when done */
 }
 
-#define TV_SEC_USEC(TV) TV.tv_sec, (unsigned long)TV.tv_usec
+#define TV_SEC_USEC(TV) TV.tv_sec, (long)TV.tv_usec
 
 static int sc_seq_show(struct seq_file *seq, void *v)
 {
@@ -309,12 +309,12 @@ static int sc_seq_show(struct seq_file *seq, void *v)
 			   "  remote node:     %s\n"
 			   "  page off:        %zu\n"
 			   "  handshake ok:    %u\n"
-			   "  timer:           %lu.%lu\n"
-			   "  data ready:      %lu.%lu\n"
-			   "  advance start:   %lu.%lu\n"
-			   "  advance stop:    %lu.%lu\n"
-			   "  func start:      %lu.%lu\n"
-			   "  func stop:       %lu.%lu\n"
+			   "  timer:           %lu.%ld\n"
+			   "  data ready:      %lu.%ld\n"
+			   "  advance start:   %lu.%ld\n"
+			   "  advance stop:    %lu.%ld\n"
+			   "  func start:      %lu.%ld\n"
+			   "  func stop:       %lu.%ld\n"
 			   "  func key:        %u\n"
 			   "  func type:       %u\n",
 			   sc,
