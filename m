From: Junxiao Bi <junxiao.bi@oracle.com>
Date: Fri, 31 Oct 2014 14:08:03 +0800
Subject: [Ocfs2-devel] [PATCH v2] ocfs2: o2net: fix connect expired
Message-ID: <1414735683-26646-1-git-send-email-junxiao.bi@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Set nn_persistent_error to -ENOTCONN will stop reconnect since the
"stop" condition in o2net_start_connect() will be true.

stop = (nn->nn_sc ||
		(nn->nn_persistent_error &&
		(nn->nn_persistent_error != -ENOTCONN || timeout == 0)));

This will make connection never be established if the first connection request
is lost.

Set nn_persistent_error to 0 when connect expired to fix this. With this
changes, dlm will not be waken up when connect expired, this is OK since
dlm depends on network, dlm can do nothing in this case if waken up. Let
it wait there for network recover and connect built again to continue.

Signed-off-by: Junxiao Bi <junxiao.bi@oracle.com>
---
 fs/ocfs2/cluster/tcp.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ocfs2/cluster/tcp.c b/fs/ocfs2/cluster/tcp.c
index 97de0fb..4d6b645 100644
--- a/fs/ocfs2/cluster/tcp.c
+++ b/fs/ocfs2/cluster/tcp.c
@@ -1736,7 +1736,7 @@ static void o2net_connect_expired(struct work_struct *work)
 		     o2net_idle_timeout() / 1000,
 		     o2net_idle_timeout() % 1000);
 
-		o2net_set_nn_state(nn, NULL, 0, -ENOTCONN);
+		o2net_set_nn_state(nn, NULL, 0, 0);
 	}
 	spin_unlock(&nn->nn_lock);
 }
-- 
1.7.9.5
