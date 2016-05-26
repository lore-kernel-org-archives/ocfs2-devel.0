From: Junxiao Bi <junxiao.bi@oracle.com>
Date: Thu, 26 May 2016 11:00:15 +0800
Subject: [Ocfs2-devel] [PATCH] ocfs2: bump up o2cb network protocol version
Message-ID: <1464231615-27939-1-git-send-email-junxiao.bi@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Two new messages are added to support negotiating hb timeout. Stopping
nodes talking old version to mount as they will cause the negotiation
fail.

Signed-off-by: Junxiao Bi <junxiao.bi@oracle.com>
---
 fs/ocfs2/cluster/tcp_internal.h |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/fs/ocfs2/cluster/tcp_internal.h b/fs/ocfs2/cluster/tcp_internal.h
index b95e7df5b76a..94b18369b1cc 100644
--- a/fs/ocfs2/cluster/tcp_internal.h
+++ b/fs/ocfs2/cluster/tcp_internal.h
@@ -44,6 +44,9 @@
  * version here in tcp_internal.h should not need to be bumped for
  * filesystem locking changes.
  *
+ * New in version 12
+ *	- Negotiate hb timeout when storage is down.
+ *
  * New in version 11
  * 	- Negotiation of filesystem locking in the dlm join.
  *
@@ -75,7 +78,7 @@
  * 	- full 64 bit i_size in the metadata lock lvbs
  * 	- introduction of "rw" lock and pushing meta/data locking down
  */
-#define O2NET_PROTOCOL_VERSION 11ULL
+#define O2NET_PROTOCOL_VERSION 12ULL
 struct o2net_handshake {
 	__be64	protocol_version;
 	__be64	connector_id;
-- 
1.7.9.5
