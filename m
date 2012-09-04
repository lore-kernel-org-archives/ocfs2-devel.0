From: Xue jiufei <xuejiufei@huawei.com>
Date: Tue, 04 Sep 2012 10:31:15 +0800
Subject: [Ocfs2-devel] [PATCH] ocfs2: cancel nn_still_up work when
	connection came up
Message-ID: <504567F3.4080406@huawei.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

We found that ocfs2 doesn't cancel the nn_still_up delayed work when
connection comes up. So if a node lost its connectivity and after a
while (more than idle time) the connection came up, it would still
make the quorum decision which we don't expect. And worse still, it
may result in an error of judgment if node detected another
connectivity lost just before the decision.

Signed-off-by: Xuejiufei <xuejiufei@huawei.com>
---
 fs/ocfs2/cluster/tcp.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/fs/ocfs2/cluster/tcp.c b/fs/ocfs2/cluster/tcp.c
index 1bfe880..8689f36 100644
--- a/fs/ocfs2/cluster/tcp.c
+++ b/fs/ocfs2/cluster/tcp.c
@@ -553,6 +553,7 @@ static void o2net_set_nn_state(struct o2net_node *nn,
 
 	if (!was_valid && valid) {
 		o2quo_conn_up(o2net_num_from_nn(nn));
+		cancel_deleyed_work(&nn->nn_still_up);
 		cancel_delayed_work(&nn->nn_connect_expired);
 		printk(KERN_NOTICE "o2net: %s " SC_NODEF_FMT "\n",
 		       o2nm_this_node() > sc->sc_node->nd_num ?
-- 
1.7.8.6
