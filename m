From: Junxiao Bi <junxiao.bi@oracle.com>
Date: Fri, 13 Jun 2014 09:48:23 +0800
Subject: [Ocfs2-devel] [PATCH 2/3] ocfs2: o2net: set tcp user timeout to max
	value
In-Reply-To: <1402624104-17841-1-git-send-email-junxiao.bi@oracle.com>
References: <1402624104-17841-1-git-send-email-junxiao.bi@oracle.com>
Message-ID: <1402624104-17841-3-git-send-email-junxiao.bi@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

When tcp retransmit timeout(15mins), the connection will be closed.
Pending messages may be lost during this time. So we set tcp user
timeout to override the retransmit timeout to the max value.
This is OK for ocfs2 since we have disk heartbeat, if peer crash,
the disk heartbeat will timeout and it will be evicted, if disk
heartbeat not timeout and connection idle for a long time, then
this means the cluster enters split-brain state, since fence can't
happen, we'd better keep the connection and wait network recover.

Reviewed-by: Srinivas Eeda <srinivas.eeda@oracle.com>
Signed-off-by: Junxiao Bi <junxiao.bi@oracle.com>
---
 fs/ocfs2/cluster/tcp.c |   20 ++++++++++++++++++++
 fs/ocfs2/cluster/tcp.h |    1 +
 2 files changed, 21 insertions(+)

diff --git a/fs/ocfs2/cluster/tcp.c b/fs/ocfs2/cluster/tcp.c
index 76ef3d8..eae58d8 100644
--- a/fs/ocfs2/cluster/tcp.c
+++ b/fs/ocfs2/cluster/tcp.c
@@ -1480,6 +1480,14 @@ static int o2net_set_nodelay(struct socket *sock)
 	return ret;
 }
 
+static int o2net_set_usertimeout(struct socket *sock)
+{
+	int user_timeout = O2NET_TCP_USER_TIMEOUT;
+
+	return kernel_setsockopt(sock, SOL_TCP, TCP_USER_TIMEOUT,
+				(char *)&user_timeout, sizeof(user_timeout));
+}
+
 static void o2net_initialize_handshake(void)
 {
 	o2net_hand->o2hb_heartbeat_timeout_ms = cpu_to_be32(
@@ -1663,6 +1671,12 @@ static void o2net_start_connect(struct work_struct *work)
 		goto out;
 	}
 
+	ret = o2net_set_usertimeout(sock);
+	if (ret) {
+		mlog(ML_ERROR, "set TCP_USER_TIMEOUT failed with %d\n", ret);
+		goto out;
+	}
+
 	o2net_register_callbacks(sc->sc_sock->sk, sc);
 
 	spin_lock(&nn->nn_lock);
@@ -1842,6 +1856,12 @@ static int o2net_accept_one(struct socket *sock)
 		goto out;
 	}
 
+	ret = o2net_set_usertimeout(new_sock);
+	if (ret) {
+		mlog(ML_ERROR, "set TCP_USER_TIMEOUT failed with %d\n", ret);
+		goto out;
+	}
+
 	slen = sizeof(sin);
 	ret = new_sock->ops->getname(new_sock, (struct sockaddr *) &sin,
 				       &slen, 1);
diff --git a/fs/ocfs2/cluster/tcp.h b/fs/ocfs2/cluster/tcp.h
index 5bada2a..c571e84 100644
--- a/fs/ocfs2/cluster/tcp.h
+++ b/fs/ocfs2/cluster/tcp.h
@@ -63,6 +63,7 @@ typedef void (o2net_post_msg_handler_func)(int status, void *data,
 #define O2NET_KEEPALIVE_DELAY_MS_DEFAULT	2000
 #define O2NET_IDLE_TIMEOUT_MS_DEFAULT		30000
 
+#define O2NET_TCP_USER_TIMEOUT			0x7fffffff
 
 /* TODO: figure this out.... */
 static inline int o2net_link_down(int err, struct socket *sock)
-- 
1.7.9.5
