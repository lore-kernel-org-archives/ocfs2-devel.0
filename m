From: Mark Fasheh <mfasheh@suse.com>
Date: Wed,  2 Apr 2008 13:14:23 -0700
Subject: [Ocfs2-devel] [PATCH 13/62] ocfs2: Abstract out node number queries.
In-Reply-To: <1207167343926-git-send-email-mfasheh@suse.com>
References: <12071673121124-git-send-email-mfasheh@suse.com>
	<1207167318479-git-send-email-mfasheh@suse.com>
	<12071673203909-git-send-email-mfasheh@suse.com>
	<12071673232465-git-send-email-mfasheh@suse.com>
	<12071673263948-git-send-email-mfasheh@suse.com>
	<12071673282579-git-send-email-mfasheh@suse.com>
	<1207167330482-git-send-email-mfasheh@suse.com>
	<12071673321172-git-send-email-mfasheh@suse.com>
	<12071673341888-git-send-email-mfasheh@suse.com>
	<12071673362069-git-send-email-mfasheh@suse.com>
	<12071673391031-git-send-email-mfasheh@suse.com>
	<12071673413492-git-send-email-mfasheh@suse.com>
	<1207167343926-git-send-email-mfasheh@suse.com>
Message-ID: <12071673461268-git-send-email-mfasheh@suse.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-kernel@vger.kernel.org
Cc: ocfs2-devel@oss.oracle.com, Joel Becker <joel.becker@oracle.com>

From: Joel Becker <joel.becker@oracle.com>

ocfs2 asks the cluster stack for the local node's node number for two
reasons; to fill the slot map and to print it. While the slot map isn't
necessary for userspace cluster stacks, the printing is very nice for
debugging. Thus we add ocfs2_cluster_this_node() as a generic API to get
this value. It is anticipated that the slot map will not be used under a
userspace cluster stack, so validity checks of the node num only need to
exist in the slot map code. Otherwise, it just gets used and printed as an
opaque value.

[ Fixed up some "int" versus "unsigned int" issues and made osb->node_num
  truly opaque. --Mark ]

Signed-off-by: Joel Becker <joel.becker@oracle.com>
Signed-off-by: Mark Fasheh <mfasheh@suse.com>
---
 fs/ocfs2/ocfs2.h     |    2 +-
 fs/ocfs2/slot_map.c  |    2 --
 fs/ocfs2/stackglue.c |   17 +++++++++++++++++
 fs/ocfs2/stackglue.h |    1 +
 fs/ocfs2/super.c     |   22 +++++++++++-----------
 5 files changed, 30 insertions(+), 14 deletions(-)

diff --git a/fs/ocfs2/ocfs2.h b/fs/ocfs2/ocfs2.h
index 664e4fe..7006aba 100644
--- a/fs/ocfs2/ocfs2.h
+++ b/fs/ocfs2/ocfs2.h
@@ -218,7 +218,7 @@ struct ocfs2_super
 	unsigned int s_atime_quantum;
 
 	unsigned int max_slots;
-	s16 node_num;
+	unsigned int node_num;
 	int slot_num;
 	int preferred_slot;
 	int s_sectsize_bits;
diff --git a/fs/ocfs2/slot_map.c b/fs/ocfs2/slot_map.c
index 63fb1b2..bb5ff89 100644
--- a/fs/ocfs2/slot_map.c
+++ b/fs/ocfs2/slot_map.c
@@ -73,8 +73,6 @@ static void ocfs2_set_slot(struct ocfs2_slot_info *si,
 			   int slot_num, unsigned int node_num)
 {
 	BUG_ON((slot_num < 0) || (slot_num >= si->si_num_slots));
-	BUG_ON((node_num == O2NM_INVALID_NODE_NUM) ||
-	       (node_num >= O2NM_MAX_NODES));
 
 	si->si_slots[slot_num].sl_valid = 1;
 	si->si_slots[slot_num].sl_node_num = node_num;
diff --git a/fs/ocfs2/stackglue.c b/fs/ocfs2/stackglue.c
index f6f309a..8146863 100644
--- a/fs/ocfs2/stackglue.c
+++ b/fs/ocfs2/stackglue.c
@@ -25,6 +25,8 @@
 #include <linux/fs.h>
 
 #include "cluster/masklog.h"
+#include "cluster/nodemanager.h"
+
 #include "stackglue.h"
 
 static struct ocfs2_locking_protocol *lproto;
@@ -371,6 +373,21 @@ int ocfs2_cluster_disconnect(struct ocfs2_cluster_connection *conn)
 	return 0;
 }
 
+int ocfs2_cluster_this_node(unsigned int *node)
+{
+	int node_num;
+
+	node_num = o2nm_this_node();
+	if (node_num == O2NM_INVALID_NODE_NUM)
+		return -ENOENT;
+
+	if (node_num >= O2NM_MAX_NODES)
+		return -EOVERFLOW;
+
+	*node = node_num;
+	return 0;
+}
+
 void o2cb_get_stack(struct ocfs2_locking_protocol *proto)
 {
 	BUG_ON(proto == NULL);
diff --git a/fs/ocfs2/stackglue.h b/fs/ocfs2/stackglue.h
index 3900b5c..ccb0399 100644
--- a/fs/ocfs2/stackglue.h
+++ b/fs/ocfs2/stackglue.h
@@ -74,6 +74,7 @@ int ocfs2_cluster_connect(const char *group,
 			  void *recovery_data,
 			  struct ocfs2_cluster_connection **conn);
 int ocfs2_cluster_disconnect(struct ocfs2_cluster_connection *conn);
+int ocfs2_cluster_this_node(unsigned int *node);
 
 int ocfs2_dlm_lock(struct ocfs2_cluster_connection *conn,
 		   int mode,
diff --git a/fs/ocfs2/super.c b/fs/ocfs2/super.c
index 0ee4975..d3c4d32 100644
--- a/fs/ocfs2/super.c
+++ b/fs/ocfs2/super.c
@@ -694,7 +694,7 @@ static int ocfs2_fill_super(struct super_block *sb, void *data, int silent)
 	if (ocfs2_mount_local(osb))
 		snprintf(nodestr, sizeof(nodestr), "local");
 	else
-		snprintf(nodestr, sizeof(nodestr), "%d", osb->node_num);
+		snprintf(nodestr, sizeof(nodestr), "%u", osb->node_num);
 
 	printk(KERN_INFO "ocfs2: Mounting device (%s) on (node %s, slot %d) "
 	       "with %s data mode.\n",
@@ -1145,16 +1145,17 @@ static int ocfs2_fill_local_node_info(struct ocfs2_super *osb)
 	 * desirable. */
 	if (ocfs2_mount_local(osb))
 		osb->node_num = 0;
-	else
-		osb->node_num = o2nm_this_node();
-
-	if (osb->node_num == O2NM_MAX_NODES) {
-		mlog(ML_ERROR, "could not find this host's node number\n");
-		status = -ENOENT;
-		goto bail;
+	else {
+		status = ocfs2_cluster_this_node(&osb->node_num);
+		if (status < 0) {
+			mlog_errno(status);
+			mlog(ML_ERROR,
+			     "could not find this host's node number\n");
+			goto bail;
+		}
 	}
 
-	mlog(0, "I am node %d\n", osb->node_num);
+	mlog(0, "I am node %u\n", osb->node_num);
 
 	status = 0;
 bail:
@@ -1282,7 +1283,7 @@ static void ocfs2_dismount_volume(struct super_block *sb, int mnt_err)
 	if (ocfs2_mount_local(osb))
 		snprintf(nodestr, sizeof(nodestr), "local");
 	else
-		snprintf(nodestr, sizeof(nodestr), "%d", osb->node_num);
+		snprintf(nodestr, sizeof(nodestr), "%u", osb->node_num);
 
 	printk(KERN_INFO "ocfs2: Unmounting device (%s) on (node %s)\n",
 	       osb->dev_str, nodestr);
@@ -1384,7 +1385,6 @@ static int ocfs2_initialize_super(struct super_block *sb,
 
 	osb->s_atime_quantum = OCFS2_DEFAULT_ATIME_QUANTUM;
 
-	osb->node_num = O2NM_INVALID_NODE_NUM;
 	osb->slot_num = OCFS2_INVALID_SLOT;
 
 	osb->local_alloc_state = OCFS2_LA_UNUSED;
-- 
1.5.4.1
