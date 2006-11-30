From: abeekhof@suse.de <abeekhof@suse.de>
Date: Thu Nov 30 10:22:25 2006
Subject: [Ocfs2-devel] [patch 1/3] ocfs2-expose-o2nm_cluster.patch
References: <20061130181128.860671000@suse.de>
Message-ID: <20061130182215.711929000@suse.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com


From: Andrew Beekhof <abeekhof@suse.de>
Subject: [patch 1/3] OCFS2 - Expose struct o2nm_cluster 

Subsequent patches (namely userspace heartbeat and configurable timeouts)
require access to the o2nm_cluster struct.  This patch does the necessary
shuffling.

Signed-off-by: Andrew Beekhof <abeekhof@suse.de>
---
 fs/ocfs2/cluster/nodemanager.c |   13 +------------
 fs/ocfs2/cluster/nodemanager.h |   14 ++++++++++++++
 2 files changed, 15 insertions(+), 12 deletions(-)

Index: fs/ocfs2/cluster/nodemanager.c
===================================================================
--- fs/ocfs2/cluster/nodemanager.c.orig	2006-11-15 11:58:34.000000000 +0100
+++ fs/ocfs2/cluster/nodemanager.c	2006-11-15 12:02:57.000000000 +0100
@@ -35,7 +35,7 @@
 /* for now we operate under the assertion that there can be only one
  * cluster active at a time.  Changing this will require trickling
  * cluster references throughout where nodes are looked up */
-static struct o2nm_cluster *o2nm_single_cluster = NULL;
+struct o2nm_cluster *o2nm_single_cluster = NULL;
 
 #define OCFS2_MAX_HB_CTL_PATH 256
 static char ocfs2_hb_ctl_path[OCFS2_MAX_HB_CTL_PATH] = "/sbin/ocfs2_hb_ctl";
@@ -97,17 +97,6 @@ const char *o2nm_get_hb_ctl_path(void)
 }
 EXPORT_SYMBOL_GPL(o2nm_get_hb_ctl_path);
 
-struct o2nm_cluster {
-	struct config_group	cl_group;
-	unsigned		cl_has_local:1;
-	u8			cl_local_node;
-	rwlock_t		cl_nodes_lock;
-	struct o2nm_node  	*cl_nodes[O2NM_MAX_NODES];
-	struct rb_root		cl_node_ip_tree;
-	/* this bitmap is part of a hack for disk bitmap.. will go eventually. - zab */
-	unsigned long	cl_nodes_bitmap[BITS_TO_LONGS(O2NM_MAX_NODES)];
-};
-
 struct o2nm_node *o2nm_get_node_by_num(u8 node_num)
 {
 	struct o2nm_node *node = NULL;
Index: fs/ocfs2/cluster/nodemanager.h
===================================================================
--- fs/ocfs2/cluster/nodemanager.h.orig	2006-11-15 12:01:55.000000000 +0100
+++ fs/ocfs2/cluster/nodemanager.h	2006-11-15 12:03:25.000000000 +0100
@@ -53,6 +53,20 @@ struct o2nm_node {
 	unsigned long		nd_set_attributes;
 };
 
+struct o2nm_cluster {
+	struct config_group	cl_group;
+	unsigned		cl_has_local:1;
+	u8			cl_local_node;
+	rwlock_t		cl_nodes_lock;
+	struct o2nm_node  	*cl_nodes[O2NM_MAX_NODES];
+	struct rb_root		cl_node_ip_tree;
+
+	/* this bitmap is part of a hack for disk bitmap.. will go eventually. - zab */
+	unsigned long	cl_nodes_bitmap[BITS_TO_LONGS(O2NM_MAX_NODES)];
+};
+
+extern struct o2nm_cluster *o2nm_single_cluster;
+
 u8 o2nm_this_node(void);
 
 int o2nm_configured_node_map(unsigned long *map, unsigned bytes);

--
