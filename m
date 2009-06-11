From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Thu, 11 Jun 2009 11:02:03 -0700
Subject: [Ocfs2-devel] [PATCH 1/1] ocfs2/net: Use wait_event() in
	o2net_send_message_vec()
Message-ID: <1244743323-6949-1-git-send-email-sunil.mushran@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Replace wait_event_interruptible() with wait_event() in o2net_send_message_vec().
This is because this function is called by the dlm that expects signals to be
blocked.

Fixes oss bugzilla#1126
http://oss.oracle.com/bugzilla/show_bug.cgi?id=1126

Signed-off-by: Sunil Mushran <sunil.mushran@oracle.com>
---
 fs/ocfs2/cluster/tcp.c |    7 ++-----
 1 files changed, 2 insertions(+), 5 deletions(-)

diff --git a/fs/ocfs2/cluster/tcp.c b/fs/ocfs2/cluster/tcp.c
index 9fbe849..334f231 100644
--- a/fs/ocfs2/cluster/tcp.c
+++ b/fs/ocfs2/cluster/tcp.c
@@ -974,7 +974,7 @@ static int o2net_tx_can_proceed(struct o2net_node *nn,
 int o2net_send_message_vec(u32 msg_type, u32 key, struct kvec *caller_vec,
 			   size_t caller_veclen, u8 target_node, int *status)
 {
-	int ret, error = 0;
+	int ret;
 	struct o2net_msg *msg = NULL;
 	size_t veclen, caller_bytes = 0;
 	struct kvec *vec = NULL;
@@ -1015,10 +1015,7 @@ int o2net_send_message_vec(u32 msg_type, u32 key, struct kvec *caller_vec,
 
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
