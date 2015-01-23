From: Dan Carpenter <dan.carpenter@oracle.com>
Date: Fri, 23 Jan 2015 14:24:21 +0300
Subject: [Ocfs2-devel] [patch] ocfs2: o2net: silence uninitialized variable
	warning
Message-ID: <20150123112421.GA14552@mwanda>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Smatch complains that, if o2net_tx_can_proceed() returns false, then
"sc" and "ret" are uninialized or maybe we are re-using the data from
previous iteration.  I do not know if we can hit this bug in real life
but checking the return value is harmless and we may as well silence the
static checker warning.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/fs/ocfs2/cluster/tcp.c b/fs/ocfs2/cluster/tcp.c
index 2e355e0..56c403a 100644
--- a/fs/ocfs2/cluster/tcp.c
+++ b/fs/ocfs2/cluster/tcp.c
@@ -1016,7 +1016,8 @@ void o2net_fill_node_map(unsigned long *map, unsigned bytes)
 
 	memset(map, 0, bytes);
 	for (node = 0; node < O2NM_MAX_NODES; ++node) {
-		o2net_tx_can_proceed(o2net_nn_from_num(node), &sc, &ret);
+		if (!o2net_tx_can_proceed(o2net_nn_from_num(node), &sc, &ret))
+			continue;
 		if (!ret) {
 			set_bit(node, map);
 			sc_put(sc);
