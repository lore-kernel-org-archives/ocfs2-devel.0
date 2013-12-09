From: Goldwyn Rodrigues <rgoldwyn@suse.de>
Date: Mon, 9 Dec 2013 13:41:02 -0600
Subject: [Ocfs2-devel] [PATCH 2/6] Add DLM recovery callbacks
Message-ID: <20131209194057.GA5268@shrek.lan>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

These are the callbacks called by the fs/dlm code in case the membership
changes. If there is a failure while/during calling any of these, the
DLM creates a new membership and relays to the rest of the nodes.

recover_prep() is called when DLM understands a node is down.
recover_slot() is called once all nodes have acknowledged recover_prep
and recovery can begin.
recover_done() is called once the recovery is complete. It returns the
new membership.

Reviewed-by: Mark Fasheh <mfasheh@suse.de>
Signed-off-by: Goldwyn Rodrigues <rgoldwyn@suse.com>
---
 fs/ocfs2/stack_user.c | 38 ++++++++++++++++++++++++++++++++++++++
 1 file changed, 38 insertions(+)

diff --git a/fs/ocfs2/stack_user.c b/fs/ocfs2/stack_user.c
index 286edf1..4111855 100644
--- a/fs/ocfs2/stack_user.c
+++ b/fs/ocfs2/stack_user.c
@@ -110,6 +110,8 @@
 struct ocfs2_live_connection {
 	struct list_head		oc_list;
 	struct ocfs2_cluster_connection	*oc_conn;
+	atomic_t                        oc_this_node;
+	int                             oc_our_slot;
 };
 
 struct ocfs2_control_private {
@@ -799,6 +801,42 @@ static int fs_protocol_compare(struct ocfs2_protocol_version *existing,
 	return 0;
 }
 
+static void user_recover_prep(void *arg)
+{
+}
+
+static void user_recover_slot(void *arg, struct dlm_slot *slot)
+{
+	struct ocfs2_cluster_connection *conn = arg;
+	printk(KERN_INFO "ocfs2: Node %d/%d down. Initiating recovery.\n",
+			slot->nodeid, slot->slot);
+	conn->cc_recovery_handler(slot->nodeid, conn->cc_recovery_data);
+
+}
+
+static void user_recover_done(void *arg, struct dlm_slot *slots,
+		int num_slots, int our_slot,
+		uint32_t generation)
+{
+	struct ocfs2_cluster_connection *conn = arg;
+	struct ocfs2_live_connection *lc = conn->cc_private;
+	int i;
+
+	for (i = 0; i < num_slots; i++)
+		if (slots[i].slot == our_slot) {
+			atomic_set(&lc->oc_this_node, slots[i].nodeid);
+			break;
+		}
+
+	lc->oc_our_slot = our_slot;
+}
+
+const struct dlm_lockspace_ops ocfs2_ls_ops = {
+	.recover_prep = user_recover_prep,
+	.recover_slot = user_recover_slot,
+	.recover_done = user_recover_done,
+};
+
 static int user_cluster_connect(struct ocfs2_cluster_connection *conn)
 {
 	dlm_lockspace_t *fsdlm;
-- 
1.8.4


-- 
Goldwyn
