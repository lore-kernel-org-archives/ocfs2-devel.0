From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Tue, 14 Dec 2010 14:14:31 -0800
Subject: [Ocfs2-devel] [PATCH 5/5] ocfs2/cluster: Pin the local node when
	o2hb thread starts
In-Reply-To: <1292364871-18461-1-git-send-email-sunil.mushran@oracle.com>
References: <1292364871-18461-1-git-send-email-sunil.mushran@oracle.com>
Message-ID: <1292364871-18461-6-git-send-email-sunil.mushran@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

The patch pins the node item of the local node when the o2hb thread
starts and unpins on stop.

An earlier patch pinned the node item of the remote node on o2net
connect and unpinned on disconnect.

Signed-off-by Sunil Mushran <sunil.mushran@oracle.com>
---
 fs/ocfs2/cluster/heartbeat.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/fs/ocfs2/cluster/heartbeat.c b/fs/ocfs2/cluster/heartbeat.c
index 199a98e..508a279 100644
--- a/fs/ocfs2/cluster/heartbeat.c
+++ b/fs/ocfs2/cluster/heartbeat.c
@@ -1083,6 +1083,9 @@ static int o2hb_thread(void *data)
 
 	set_user_nice(current, -20);
 
+	/* Pin node */
+	o2nm_depend_this_node();
+
 	while (!kthread_should_stop() && !reg->hr_unclean_stop) {
 		/* We track the time spent inside
 		 * o2hb_do_disk_heartbeat so that we avoid more than
@@ -1132,6 +1135,9 @@ static int o2hb_thread(void *data)
 		mlog_errno(ret);
 	}
 
+	/* Unpin node */
+	o2nm_undepend_this_node();
+
 	mlog(ML_HEARTBEAT|ML_KTHREAD, "hb thread exiting\n");
 
 	return 0;
-- 
1.7.1
