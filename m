From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Wed, 17 Jun 2009 18:52:26 -0700
Subject: [Ocfs2-devel] [PATCH 8/8] ocfs2/net: Use wait_event() in
	o2net_send_message_vec()
In-Reply-To: <1245289946-17136-1-git-send-email-sunil.mushran@oracle.com>
References: <1245289946-17136-1-git-send-email-sunil.mushran@oracle.com>
Message-ID: <1245289946-17136-9-git-send-email-sunil.mushran@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Mainline commit 9af0b38ff3f4f79c62dd909405b113bf7c1a23aa

Replace wait_event_interruptible() with wait_event() in o2net_send_message_vec().
This is because this function is called by the dlm that expects signals to be
blocked.

Fixes oss bugzilla#1126
http://oss.oracle.com/bugzilla/show_bug.cgi?id=1126

Signed-off-by: Sunil Mushran <sunil.mushran@oracle.com>
Signed-off-by: Joel Becker <joel.becker@oracle.com>
---
 fs/ocfs2/cluster/tcp.c |    7 ++-----
 1 files changed, 2 insertions(+), 5 deletions(-)

diff --git a/fs/ocfs2/cluster/tcp.c b/fs/ocfs2/cluster/tcp.c
index 7b24751..7ea88f7 100644
--- a/fs/ocfs2/cluster/tcp.c
+++ b/fs/ocfs2/cluster/tcp.c
@@ -982,7 +982,7 @@ static int o2net_tx_can_proceed(struct o2net_node *nn,
 int o2net_send_message_vec(u32 msg_type, u32 key, struct kvec *caller_vec,
 			   size_t caller_veclen, u8 target_node, int *status)
 {
-	int ret, error = 0;
+	int ret;
 	struct o2net_msg *msg = NULL;
 	size_t veclen, caller_bytes = 0;
 	struct kvec *vec = NULL;
@@ -1023,10 +1023,7 @@ int o2net_send_message_vec(u32 msg_type, u32 key, struct kvec *caller_vec,
 
 	o2net_set_nst_sock_time(&nst);
 
-	ret = wait_event_interruptible(nn->nn_sc_wq,
-				       o2net_tx_can_proceed(nn, &sc, &error));
-	if (!ret && error)
-		ret = error;
+	wait_event(nn->nn_sc_wq, o2net_tx_can_proceed(nn, &sc, &ret));
 	if (ret)
 		goto out;
 
-- 
1.6.0.4
