From: Louis Rilling <louis.rilling@kerlabs.com>
Date: Fri, 20 Jun 2008 17:04:11 +0200
Subject: [Ocfs2-devel] [RFC][PATCH v2] configfs: Provide variants of
	config_*_init_type_name() that report errors
Message-ID: <1213974251-21603-1-git-send-email-louis.rilling@kerlabs.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Joel.Becker@oracle.com
Cc: linux-kernel@vger.kernel.org, ocfs2-devel@oracle.com, Louis Rilling <louis.rilling@kerlabs.com>

 [ applies on top of http://lkml.org/lkml/2008/6/12/427 ]

config_item_set_name() may fail but its error code is not checked in
config_*_init_type_name(). Such uses of config_*_init_type_name() are still
valid as long as the new name is shorter than CONFIGFS_ITEM_NAME_LEN, but as
soon as the new name is provided by userspace, the name length is not
controlled.

This patch implements config_*_init_type_long_name() variants that report errors
and that must be used in place of config_*_init_type_name() for names of unknown
length. config_*_init_type_name() now BUG_ON() if they are used with names too
long. In-tree users and documentation examples are updated to report errors as
well.

Signed-off-by: Louis Rilling <louis.rilling@kerlabs.com>
---
 .../filesystems/configfs/configfs_example.c        |   18 ++++++--
 drivers/net/netconsole.c                           |    8 +++-
 fs/configfs/item.c                                 |   44 +++++++++++++++++---
 fs/dlm/config.c                                    |   28 ++++++++++---
 fs/ocfs2/cluster/heartbeat.c                       |    5 ++-
 fs/ocfs2/cluster/nodemanager.c                     |   11 ++++-
 include/linux/configfs.h                           |    6 +++
 7 files changed, 99 insertions(+), 21 deletions(-)

diff --git a/Documentation/filesystems/configfs/configfs_example.c b/Documentation/filesystems/configfs/configfs_example.c
index 0b422ac..e3f407c 100644
--- a/Documentation/filesystems/configfs/configfs_example.c
+++ b/Documentation/filesystems/configfs/configfs_example.c
@@ -276,14 +276,19 @@ static inline struct simple_children *to_simple_children(struct config_item *ite
 static int simple_children_make_item(struct config_group *group, const char *name, struct config_item **new_item)
 {
 	struct simple_child *simple_child;
+	int ret;
 
 	simple_child = kzalloc(sizeof(struct simple_child), GFP_KERNEL);
 	if (!simple_child)
 		return -ENOMEM;
 
 
-	config_item_init_type_name(&simple_child->item, name,
-				   &simple_child_type);
+	ret = config_item_init_type_long_name(&simple_child->item, name,
+					      &simple_child_type);
+	if (ret) {
+		kfree(simple_child);
+		return ret;
+	}
 
 	simple_child->storeme = 0;
 
@@ -363,6 +368,7 @@ static struct configfs_subsystem simple_children_subsys = {
 static int group_children_make_group(struct config_group *group, const char *name, struct config_group **new_group)
 {
 	struct simple_children *simple_children;
+	int ret;
 
 	simple_children = kzalloc(sizeof(struct simple_children),
 				  GFP_KERNEL);
@@ -370,8 +376,12 @@ static int group_children_make_group(struct config_group *group, const char *nam
 		return -ENOMEM;
 
 
-	config_group_init_type_name(&simple_children->group, name,
-				    &simple_children_type);
+	ret = config_group_init_type_long_name(&simple_children->group, name,
+					       &simple_children_type);
+	if (ret) {
+		kfree(simple_children);
+		return ret;
+	}
 
 	*new_group = &simple_children->group;
 	return 0;
diff --git a/drivers/net/netconsole.c b/drivers/net/netconsole.c
index 387a133..7208c4a 100644
--- a/drivers/net/netconsole.c
+++ b/drivers/net/netconsole.c
@@ -591,6 +591,7 @@ static int make_netconsole_target(struct config_group *group,
 {
 	unsigned long flags;
 	struct netconsole_target *nt;
+	int ret;
 
 	/*
 	 * Allocate and initialize with defaults.
@@ -609,7 +610,12 @@ static int make_netconsole_target(struct config_group *group,
 	memset(nt->np.remote_mac, 0xff, ETH_ALEN);
 
 	/* Initialize the config_item member */
-	config_item_init_type_name(&nt->item, name, &netconsole_target_type);
+	ret = config_item_init_type_long_name(&nt->item, name,
+					      &netconsole_target_type);
+	if (ret) {
+		kfree(nt);
+		return ret;
+	}
 
 	/* Adding, but it is disabled */
 	spin_lock_irqsave(&target_list_lock, flags);
diff --git a/fs/configfs/item.c b/fs/configfs/item.c
index 76dc4c3..4c3a002 100644
--- a/fs/configfs/item.c
+++ b/fs/configfs/item.c
@@ -112,22 +112,54 @@ int config_item_set_name(struct config_item * item, const char * fmt, ...)
 
 EXPORT_SYMBOL(config_item_set_name);
 
+int config_item_init_type_long_name(struct config_item *item,
+				    const char *name,
+				    struct config_item_type *type)
+{
+	int error;
+
+	error = config_item_set_name(item, name);
+	if (error)
+		return error;
+	item->ci_type = type;
+	config_item_init(item);
+	return 0;
+}
+EXPORT_SYMBOL(config_item_init_type_long_name);
+
 void config_item_init_type_name(struct config_item *item,
 				const char *name,
 				struct config_item_type *type)
 {
-	config_item_set_name(item, name);
-	item->ci_type = type;
-	config_item_init(item);
+	int error;
+
+	error = config_item_init_type_long_name(item, name, type);
+	BUG_ON(error);
 }
 EXPORT_SYMBOL(config_item_init_type_name);
 
-void config_group_init_type_name(struct config_group *group, const char *name,
-			 struct config_item_type *type)
+int config_group_init_type_long_name(struct config_group *group,
+				     const char *name,
+				     struct config_item_type *type)
 {
-	config_item_set_name(&group->cg_item, name);
+	int error;
+
+	error = config_item_set_name(&group->cg_item, name);
+	if (error)
+		return error;
 	group->cg_item.ci_type = type;
 	config_group_init(group);
+	return 0;
+}
+EXPORT_SYMBOL(config_group_init_type_long_name);
+
+void config_group_init_type_name(struct config_group *group, const char *name,
+			 struct config_item_type *type)
+{
+	int error;
+
+	error = config_group_init_type_long_name(group, name, type);
+	BUG_ON(error);
 }
 EXPORT_SYMBOL(config_group_init_type_name);
 
diff --git a/fs/dlm/config.c b/fs/dlm/config.c
index 492d8ca..1f61b71 100644
--- a/fs/dlm/config.c
+++ b/fs/dlm/config.c
@@ -403,6 +403,7 @@ static int make_cluster(struct config_group *g, const char *name,
 	struct spaces *sps = NULL;
 	struct comms *cms = NULL;
 	void *gps = NULL;
+	int ret = -ENOMEM;
 
 	cl = kzalloc(sizeof(struct cluster), GFP_KERNEL);
 	gps = kcalloc(3, sizeof(struct config_group *), GFP_KERNEL);
@@ -412,7 +413,9 @@ static int make_cluster(struct config_group *g, const char *name,
 	if (!cl || !gps || !sps || !cms)
 		goto fail;
 
-	config_group_init_type_name(&cl->group, name, &cluster_type);
+	ret = config_group_init_type_long_name(&cl->group, name, &cluster_type);
+	if (ret)
+		goto fail;
 	config_group_init_type_name(&sps->ss_group, "spaces", &spaces_type);
 	config_group_init_type_name(&cms->cs_group, "comms", &comms_type);
 
@@ -443,7 +446,7 @@ static int make_cluster(struct config_group *g, const char *name,
 	kfree(gps);
 	kfree(sps);
 	kfree(cms);
-	return -ENOMEM;
+	return ret;
 }
 
 static void drop_cluster(struct config_group *g, struct config_item *i)
@@ -477,6 +480,7 @@ static int make_space(struct config_group *g, const char *name,
 	struct space *sp = NULL;
 	struct nodes *nds = NULL;
 	void *gps = NULL;
+	int ret = -ENOMEM;
 
 	sp = kzalloc(sizeof(struct space), GFP_KERNEL);
 	gps = kcalloc(2, sizeof(struct config_group *), GFP_KERNEL);
@@ -485,7 +489,9 @@ static int make_space(struct config_group *g, const char *name,
 	if (!sp || !gps || !nds)
 		goto fail;
 
-	config_group_init_type_name(&sp->group, name, &space_type);
+	ret = config_group_init_type_long_name(&sp->group, name, &space_type);
+	if (ret)
+		goto fail;
 	config_group_init_type_name(&nds->ns_group, "nodes", &nodes_type);
 
 	sp->group.default_groups = gps;
@@ -502,7 +508,7 @@ static int make_space(struct config_group *g, const char *name,
 	kfree(sp);
 	kfree(gps);
 	kfree(nds);
-	return -ENOMEM;
+	return ret;
 }
 
 static void drop_space(struct config_group *g, struct config_item *i)
@@ -533,12 +539,17 @@ static int make_comm(struct config_group *g, const char *name,
 		     struct config_item **new_i)
 {
 	struct comm *cm;
+	int ret;
 
 	cm = kzalloc(sizeof(struct comm), GFP_KERNEL);
 	if (!cm)
 		return -ENOMEM;
 
-	config_item_init_type_name(&cm->item, name, &comm_type);
+	ret = config_item_init_type_long_name(&cm->item, name, &comm_type);
+	if (ret) {
+		kfree(cm);
+		return ret;
+	}
 	cm->nodeid = -1;
 	cm->local = 0;
 	cm->addr_count = 0;
@@ -568,12 +579,17 @@ static int make_node(struct config_group *g, const char *name,
 {
 	struct space *sp = to_space(g->cg_item.ci_parent);
 	struct node *nd;
+	int ret;
 
 	nd = kzalloc(sizeof(struct node), GFP_KERNEL);
 	if (!nd)
 		return -ENOMEM;
 
-	config_item_init_type_name(&nd->item, name, &node_type);
+	ret = config_item_init_type_long_name(&nd->item, name, &node_type);
+	if (ret) {
+		kfree(nd);
+		return ret;
+	}
 	nd->nodeid = -1;
 	nd->weight = 1;  /* default weight of 1 if none is set */
 	nd->new = 1;     /* set to 0 once it's been read by dlm_nodeid_list() */
diff --git a/fs/ocfs2/cluster/heartbeat.c b/fs/ocfs2/cluster/heartbeat.c
index 443d108..99bb6ca 100644
--- a/fs/ocfs2/cluster/heartbeat.c
+++ b/fs/ocfs2/cluster/heartbeat.c
@@ -1502,7 +1502,10 @@ static int o2hb_heartbeat_group_make_item(struct config_group *group,
 		goto out;
 	}
 
-	config_item_init_type_name(&reg->hr_item, name, &o2hb_region_type);
+	ret = config_item_init_type_long_name(&reg->hr_item, name,
+					      &o2hb_region_type);
+	if (ret)
+		goto out;
 
 	*new_item = &reg->hr_item;
 
diff --git a/fs/ocfs2/cluster/nodemanager.c b/fs/ocfs2/cluster/nodemanager.c
index fe09cc3..82909e3 100644
--- a/fs/ocfs2/cluster/nodemanager.c
+++ b/fs/ocfs2/cluster/nodemanager.c
@@ -723,7 +723,10 @@ static int o2nm_node_group_make_item(struct config_group *group,
 	}
 
 	strcpy(node->nd_name, name); /* use item.ci_namebuf instead? */
-	config_item_init_type_name(&node->nd_item, name, &o2nm_node_type);
+	ret = config_item_init_type_long_name(&node->nd_item, name,
+					      &o2nm_node_type);
+	if (ret)
+		goto out;
 	spin_lock_init(&node->nd_lock);
 
 	*new_item = &node->nd_item;
@@ -842,8 +845,10 @@ static int o2nm_cluster_group_make_group(struct config_group *group,
 		goto out;
 	}
 
-	config_group_init_type_name(&cluster->cl_group, name,
-				    &o2nm_cluster_type);
+	ret = config_group_init_type_long_name(&cluster->cl_group, name,
+					       &o2nm_cluster_type);
+	if (ret)
+		goto out;
 	config_group_init_type_name(&ns->ns_group, "node",
 				    &o2nm_node_group_type);
 
diff --git a/include/linux/configfs.h b/include/linux/configfs.h
index 0488f93..bf1aac8 100644
--- a/include/linux/configfs.h
+++ b/include/linux/configfs.h
@@ -74,6 +74,9 @@ extern void config_item_init(struct config_item *);
 extern void config_item_init_type_name(struct config_item *item,
 				       const char *name,
 				       struct config_item_type *type);
+extern int config_item_init_type_long_name(struct config_item *item,
+					   const char *name,
+					   struct config_item_type *type);
 
 extern struct config_item * config_item_get(struct config_item *);
 extern void config_item_put(struct config_item *);
@@ -100,6 +103,9 @@ extern void config_group_init(struct config_group *group);
 extern void config_group_init_type_name(struct config_group *group,
 					const char *name,
 					struct config_item_type *type);
+extern int config_group_init_type_long_name(struct config_group *group,
+					    const char *name,
+					    struct config_item_type *type);
 
 static inline struct config_group *to_config_group(struct config_item *item)
 {
-- 
1.5.5.3
