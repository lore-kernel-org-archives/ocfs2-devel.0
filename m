From: Jeff Liu <jeff.liu@oracle.com>
Date: Sat, 29 Jun 2013 12:00:53 +0800
Subject: [Ocfs2-devel] [RESNET PATCH 1/4] ocfs2: submit disk heartbeat bio
	using WRITE_SYNC
Message-ID: <51CE5BF5.10307@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

From: Noboru Iwamatsu <n_iwamatsu@jp.fujitsu.com>

Under heavy I/O load, writing the disk heartbeat can be
forced to wait for minutes, and this causes the node to
be fenced.

This patch tries to use WRITE_SYNC in submitting the heartbeat
bio, so that writing the heartbeat will have a priority over
other requests.

Signed-off-by: Noboru Iwamatsu <n_iwamatsu@jp.fujitsu.com>
Acked-by: Tao Ma <tm@tao.ma>
Acked-by: Sunil Mushran <sunil.mushran@gmail.com>
CC: Srinivas Eeeda <srinivas.eeda@oracle.com>
Reviewed-by: Jie Liu <jeff.liu@oracle.com>
Tested-by: Gurudas Pai <gurudas.pai@oracle.com>
---
 fs/ocfs2/cluster/heartbeat.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ocfs2/cluster/heartbeat.c b/fs/ocfs2/cluster/heartbeat.c
index 42252bf..f89b46b 100644
--- a/fs/ocfs2/cluster/heartbeat.c
+++ b/fs/ocfs2/cluster/heartbeat.c
@@ -500,7 +500,7 @@ static int o2hb_issue_node_write(struct o2hb_region *reg,
 	}
 
 	atomic_inc(&write_wc->wc_num_reqs);
-	submit_bio(WRITE, bio);
+	submit_bio(WRITE_SYNC, bio);
 
 	status = 0;
 bail:
-- 
1.7.9.5
