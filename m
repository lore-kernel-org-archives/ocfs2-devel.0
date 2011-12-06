From: Noboru Iwamatsu <n_iwamatsu@jp.fujitsu.com>
Date: Tue,  6 Dec 2011 13:57:10 +0900
Subject: [Ocfs2-devel] [PATCH] ocfs2: submit disk heartbeat bio using
	WRITE_SYNC
Message-ID: <1323147430-16691-1-git-send-email-n_iwamatsu@jp.fujitsu.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Under heavy I/O load, writing the disk heartbeat can be forced
to wait for minutes, and this causes the node to be fenced.

This patch tries to use WRITE_SYNC in submitting the heartbeat
bio, so that writing the heartbeat will have a priority over
other requests.

Signed-off-by: Noboru Iwamatsu <n_iwamatsu@jp.fujitsu.com>
---
 fs/ocfs2/cluster/heartbeat.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/ocfs2/cluster/heartbeat.c b/fs/ocfs2/cluster/heartbeat.c
index 9a3e6bb..6b0c1e4 100644
--- a/fs/ocfs2/cluster/heartbeat.c
+++ b/fs/ocfs2/cluster/heartbeat.c
@@ -491,7 +491,7 @@ static int o2hb_issue_node_write(struct o2hb_region *reg,
 	}
 
 	atomic_inc(&write_wc->wc_num_reqs);
-	submit_bio(WRITE, bio);
+	submit_bio(WRITE_SYNC, bio);
 
 	status = 0;
 bail:
-- 
1.7.6.4
