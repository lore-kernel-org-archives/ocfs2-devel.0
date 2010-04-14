From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Tue, 13 Apr 2010 18:00:30 -0700
Subject: [Ocfs2-devel] [PATCH 1/2] ocfs2/dlm: Make o2dlm domain join/leave
	messages KERN_NOTICE
Message-ID: <1271206831-3203-1-git-send-email-sunil.mushran@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

o2dlm join and leave messages are more than informational as they are required
is debugging locking issues. This patch changes them from KERN_INFO to KERN_NOTICE.

Signed-off-by: Sunil Mushran <sunil.mushran@oracle.com>
---
 fs/ocfs2/dlm/dlmdomain.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/ocfs2/dlm/dlmdomain.c b/fs/ocfs2/dlm/dlmdomain.c
index 988c905..bcbbe56 100644
--- a/fs/ocfs2/dlm/dlmdomain.c
+++ b/fs/ocfs2/dlm/dlmdomain.c
@@ -511,7 +511,7 @@ static void __dlm_print_nodes(struct dlm_ctxt *dlm)
 
 	assert_spin_locked(&dlm->spinlock);
 
-	printk(KERN_INFO "ocfs2_dlm: Nodes in domain (\"%s\"): ", dlm->name);
+	printk(KERN_NOTICE "o2dlm: Nodes in domain %s: ", dlm->name);
 
 	while ((node = find_next_bit(dlm->domain_map, O2NM_MAX_NODES,
 				     node + 1)) < O2NM_MAX_NODES) {
@@ -534,7 +534,7 @@ static int dlm_exit_domain_handler(struct o2net_msg *msg, u32 len, void *data,
 
 	node = exit_msg->node_idx;
 
-	printk(KERN_INFO "ocfs2_dlm: Node %u leaves domain %s\n", node, dlm->name);
+	printk(KERN_NOTICE "o2dlm: Node %u leaves domain %s\n", node, dlm->name);
 
 	spin_lock(&dlm->spinlock);
 	clear_bit(node, dlm->domain_map);
@@ -904,7 +904,7 @@ static int dlm_assert_joined_handler(struct o2net_msg *msg, u32 len, void *data,
 		set_bit(assert->node_idx, dlm->domain_map);
 		__dlm_set_joining_node(dlm, DLM_LOCK_RES_OWNER_UNKNOWN);
 
-		printk(KERN_INFO "ocfs2_dlm: Node %u joins domain %s\n",
+		printk(KERN_NOTICE "o2dlm: Node %u joins domain %s\n",
 		       assert->node_idx, dlm->name);
 		__dlm_print_nodes(dlm);
 
-- 
1.6.3.3
