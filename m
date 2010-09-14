From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Tue, 14 Sep 2010 15:50:43 -0700
Subject: [Ocfs2-devel] [PATCH 07/20] ocfs2: Print message if user mounts
	without starting global heartbeat
In-Reply-To: <1284504656-2434-1-git-send-email-sunil.mushran@oracle.com>
References: <1284504656-2434-1-git-send-email-sunil.mushran@oracle.com>
Message-ID: <1284504656-2434-8-git-send-email-sunil.mushran@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

In global heartbeat mode, the heartbeat is started by the user. This patch
prints an error if the user attempts to mount a volume without starting the
heartbeat.

Signed-off-by: Sunil Mushran <sunil.mushran@oracle.com>
---
 fs/ocfs2/stack_o2cb.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/fs/ocfs2/stack_o2cb.c b/fs/ocfs2/stack_o2cb.c
index 0d3049f..19965b0 100644
--- a/fs/ocfs2/stack_o2cb.c
+++ b/fs/ocfs2/stack_o2cb.c
@@ -283,6 +283,8 @@ static int o2cb_cluster_connect(struct ocfs2_cluster_connection *conn)
 	/* for now we only have one cluster/node, make sure we see it
 	 * in the heartbeat universe */
 	if (!o2hb_check_local_node_heartbeating()) {
+		if (o2hb_global_heartbeat_active())
+			mlog(ML_ERROR, "Global heartbeat not started\n");
 		rc = -EINVAL;
 		goto out;
 	}
-- 
1.7.0.4
