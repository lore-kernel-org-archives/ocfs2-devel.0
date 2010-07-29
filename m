From: Tristan Ye <tristan.ye@oracle.com>
Date: Thu, 29 Jul 2010 19:04:43 +0800
Subject: [Ocfs2-devel] [PATCH 1/1] O2net: Disallow o2net accept connection
	request from itself.
Message-ID: <1280401483-4756-1-git-send-email-tristan.ye@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Currently, o2net_accept_one() is allowed to accept a connection from
listening node itself, such a fake connection will not be successfully
established due to no handshake detected afterwards, and later end up
with triggering connecting worker in a loop.

We're going to fix this by treating such connection request as 'invalid',
since we've got no chance of requesting connection from a node to itself
in a OCFS2 cluster.

The fix doesn't hurt user's scan for o2net-listener, it always gets a
successful connection from userpace.

Signed-off-by: Tristan Ye <tristan.ye@oracle.com>
---
 fs/ocfs2/cluster/tcp.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/ocfs2/cluster/tcp.c b/fs/ocfs2/cluster/tcp.c
index aa75ca3..7e4e451 100644
--- a/fs/ocfs2/cluster/tcp.c
+++ b/fs/ocfs2/cluster/tcp.c
@@ -1796,9 +1796,9 @@ static int o2net_accept_one(struct socket *sock)
 		goto out;
 	}
 
-	if (o2nm_this_node() > node->nd_num) {
+	if (o2nm_this_node() >= node->nd_num) {
 		mlog(ML_NOTICE, "unexpected connect attempted from a lower "
-		     "numbered node '%s' at " "%pI4:%d with num %u\n",
+		     "or same numbered node '%s' at " "%pI4:%d with num %u\n",
 		     node->nd_name, &sin.sin_addr.s_addr,
 		     ntohs(sin.sin_port), node->nd_num);
 		ret = -EINVAL;
-- 
1.5.5
