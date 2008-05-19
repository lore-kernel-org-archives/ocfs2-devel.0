From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Mon, 19 May 2008 16:23:37 -0700
Subject: [Ocfs2-devel] [PATCH 1/1] ocfs2/net: Silence build warnings on
	sparc64
Message-ID: <1211239417-32337-1-git-send-email-sunil.mushran@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

suseconds_t is type long on most arches except sparc64 where it is type int.
This patch silences the following warnings that are generated when building
on it.

netdebug.c: In function 'nst_seq_show':
netdebug.c:152: warning: format '%lu' expects type 'long unsigned int', but argument 13 has type 'suseconds_t'
netdebug.c:152: warning: format '%lu' expects type 'long unsigned int', but argument 15 has type 'suseconds_t'
netdebug.c:152: warning: format '%lu' expects type 'long unsigned int', but argument 17 has type 'suseconds_t'
netdebug.c: In function 'sc_seq_show':
netdebug.c:332: warning: format '%lu' expects type 'long unsigned int', but argument 19 has type 'suseconds_t'
netdebug.c:332: warning: format '%lu' expects type 'long unsigned int', but argument 21 has type 'suseconds_t'
netdebug.c:332: warning: format '%lu' expects type 'long unsigned int', but argument 23 has type 'suseconds_t'
netdebug.c:332: warning: format '%lu' expects type 'long unsigned int', but argument 25 has type 'suseconds_t'
netdebug.c:332: warning: format '%lu' expects type 'long unsigned int', but argument 27 has type 'suseconds_t'
netdebug.c:332: warning: format '%lu' expects type 'long unsigned int', but argument 29 has type 'suseconds_t'

Signed-off-by: Sunil Mushran <sunil.mushran@oracle.com>
---
 fs/ocfs2/cluster/netdebug.c |    8 +++++---
 1 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/fs/ocfs2/cluster/netdebug.c b/fs/ocfs2/cluster/netdebug.c
index 7bf3c0e..d8bfa0e 100644
--- a/fs/ocfs2/cluster/netdebug.c
+++ b/fs/ocfs2/cluster/netdebug.c
@@ -146,8 +146,10 @@ static int nst_seq_show(struct seq_file *seq, void *v)
 			   nst->st_task->comm, nst->st_node,
 			   nst->st_sc, nst->st_id, nst->st_msg_type,
 			   nst->st_msg_key,
-			   nst->st_sock_time.tv_sec, nst->st_sock_time.tv_usec,
-			   nst->st_send_time.tv_sec, nst->st_send_time.tv_usec,
+			   nst->st_sock_time.tv_sec,
+			   (unsigned long)nst->st_sock_time.tv_usec,
+			   nst->st_send_time.tv_sec,
+			   (unsigned long)nst->st_send_time.tv_usec,
 			   nst->st_status_time.tv_sec,
 			   nst->st_status_time.tv_usec);
 	}
@@ -274,7 +276,7 @@ static void *sc_seq_next(struct seq_file *seq, void *v, loff_t *pos)
 	return sc; /* unused, just needs to be null when done */
 }
 
-#define TV_SEC_USEC(TV) TV.tv_sec, TV.tv_usec
+#define TV_SEC_USEC(TV) TV.tv_sec, (unsigned long)TV.tv_usec
 
 static int sc_seq_show(struct seq_file *seq, void *v)
 {
-- 
1.5.3.6
