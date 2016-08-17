From: Junxiao Bi <junxiao.bi@oracle.com>
Date: Wed, 17 Aug 2016 09:22:03 +0800
Subject: [Ocfs2-devel] [PATCH] Revert "ocfs2: bump up o2cb network protocol
	version"
Message-ID: <1471396924-10375-1-git-send-email-junxiao.bi@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

This reverts commit 38b52efd218bf2a11a5b4a8f56052cee6684cfec.

This commit made rolling upgrade fail. When one node is upgraded
to new version with this commit, the remaining nodes will fail to
establish connections to it, then the application like VMs on the
remaining nodes can't be live migrated to the upgraded one. This
will cause an outage. Since negotiate hb timeout behavior didn't
change without this commit, so revert it.

Signed-off-by: Junxiao Bi <junxiao.bi@oracle.com>
---
 fs/ocfs2/cluster/tcp_internal.h |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/fs/ocfs2/cluster/tcp_internal.h b/fs/ocfs2/cluster/tcp_internal.h
index 94b18369b1cc..b95e7df5b76a 100644
--- a/fs/ocfs2/cluster/tcp_internal.h
+++ b/fs/ocfs2/cluster/tcp_internal.h
@@ -44,9 +44,6 @@
  * version here in tcp_internal.h should not need to be bumped for
  * filesystem locking changes.
  *
- * New in version 12
- *	- Negotiate hb timeout when storage is down.
- *
  * New in version 11
  * 	- Negotiation of filesystem locking in the dlm join.
  *
@@ -78,7 +75,7 @@
  * 	- full 64 bit i_size in the metadata lock lvbs
  * 	- introduction of "rw" lock and pushing meta/data locking down
  */
-#define O2NET_PROTOCOL_VERSION 12ULL
+#define O2NET_PROTOCOL_VERSION 11ULL
 struct o2net_handshake {
 	__be64	protocol_version;
 	__be64	connector_id;
-- 
1.7.9.5
