From: Jiaju Zhang <jjzhang.linux@gmail.com>
Date: Thu, 1 Sep 2011 23:28:18 +0800
Subject: [Ocfs2-devel] [PATCH] ocfs2: handle ocfs2 node down event more
	correctly
Message-ID: <20110901152818.GA29472@linux-jjzhang.prod.bej.apac.novell.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

In the scenario that ocfs2 is used with in-kernel fs/dlm and user-space
cluster stack, osb->node_num == node_num in ocfs2_do_node_down doesn't
mean it is a bug any more. This is because ocfs2_controld might receive
the node down information first, in the normal case, dlm_controld should
receive that node down information soon then osb->node_num != node_num.
But a rare case is before dlm_controld receive the node down information,
that node is up again and dlm_controld won't receive node down any more,
which results in osb->node_num == node_num here, this case can happen and
it should not be a bug. Just return here and won't trigger the recovery
thread should be the right way to go. Also, it won't introduce other side
effect when using o2cb stack.

Signed-off-by: Jiaju Zhang <jjzhang@suse.de>
---
 fs/ocfs2/heartbeat.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/fs/ocfs2/heartbeat.c b/fs/ocfs2/heartbeat.c
index d8208b2..632e855 100644
--- a/fs/ocfs2/heartbeat.c
+++ b/fs/ocfs2/heartbeat.c
@@ -64,10 +64,11 @@ void ocfs2_do_node_down(int node_num, void *data)
 {
 	struct ocfs2_super *osb = data;
 
-	BUG_ON(osb->node_num == node_num);
-
 	trace_ocfs2_do_node_down(node_num);
 
+	if (osb->node_num == node_num)
+		return;
+
 	if (!osb->cconn) {
 		/*
 		 * No cluster connection means we're not even ready to
