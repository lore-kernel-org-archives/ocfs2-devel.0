From: piaojun <piaojun@huawei.com>
Date: Mon, 18 Jul 2016 12:58:30 +0800
Subject: [Ocfs2-devel] [PATCH] ocfs2/cluster: clean up unnecessary
	assignment for 'ret'
Message-ID: <578C61F6.4080403@huawei.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

clean up unnecessary assignment for 'ret'.

Signed-off-by: Jun Piao <piaojun@huawei.com>
Reviewed-by: Joseph Qi <joseph.qi@huawei.com>
---
 fs/ocfs2/cluster/tcp.c | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/fs/ocfs2/cluster/tcp.c b/fs/ocfs2/cluster/tcp.c
index 2d0acd6..9aea996 100644
--- a/fs/ocfs2/cluster/tcp.c
+++ b/fs/ocfs2/cluster/tcp.c
@@ -1617,16 +1617,12 @@ static void o2net_start_connect(struct work_struct *work)
 
 	/* watch for racing with tearing a node down */
 	node = o2nm_get_node_by_num(o2net_num_from_nn(nn));
-	if (node == NULL) {
-		ret = 0;
+	if (node == NULL)
 		goto out;
-	}
 
 	mynode = o2nm_get_node_by_num(o2nm_this_node());
-	if (mynode == NULL) {
-		ret = 0;
+	if (mynode == NULL)
 		goto out;
-	}
 
 	spin_lock(&nn->nn_lock);
 	/*
-- 
1.8.4.3
