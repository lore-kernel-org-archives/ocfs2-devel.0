From: Louis Rilling <louis.rilling@kerlabs.com>
Date: Wed, 18 Jun 2008 20:30:51 +0200
Subject: [Ocfs2-devel] [RFC][PATCH] configfs: Report errors in
	config_*_init_type_name()
Message-ID: <1213813851-7359-1-git-send-email-louis.rilling@kerlabs.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Joel.Becker@oracle.com
Cc: linux-kernel@vger.kernel.org, ocfs2-devel@oss.oracle.com, Louis Rilling <louis.rilling@kerlabs.com>

 [ applies on top of http://lkml.org/lkml/2008/6/12/427 ]

config_item_set_name() may fail but its error code is not checked in
config_*_init_type_name().

This patch adds the missing error checking and make config_*_init_type_name()
report errors. In-tree users are updated to report errors as well.

Signed-off-by: Louis Rilling <louis.rilling@kerlabs.com>
---
 drivers/net/netconsole.c       |    8 +++++-
 fs/configfs/item.c             |   18 +++++++++++---
 fs/dlm/config.c                |   48 ++++++++++++++++++++++++++++++++-------
 fs/ocfs2/cluster/heartbeat.c   |   10 +++++--
 fs/ocfs2/cluster/nodemanager.c |   18 ++++++++++----
 include/linux/configfs.h       |    8 +++---
 6 files changed, 84 insertions(+), 26 deletions(-)

diff --git a/drivers/net/netconsole.c b/drivers/net/netconsole.c
index 387a133..9f74746 100644
--- a/drivers/net/netconsole.c
+++ b/drivers/net/netconsole.c
@@ -591,6 +591,7 @@ static int make_netconsole_target(struct config_group *group,
 {
 	unsigned long flags;
 	struct netconsole_target *nt;
+	int err;
 
 	/*
 	 * Allocate and initialize with defaults.
@@ -609,7 +610,12 @@ static int make_netconsole_target(struct config_group *group,
 	memset(nt->np.remote_mac, 0xff, ETH_ALEN);
 
 	/* Initialize the config_item member */
-	config_item_init_type_name(&nt->item, name, &netconsole_target_type);
+	err = config_item_init_type_name(&nt->item, name,
+					 &netconsole_target_type);
+	if (err) {
+		kfree(nt);
+		return err;
+	}
 
 	/* Adding, but it is disabled */
 	spin_lock_irqsave(&target_list_lock, flags);
diff --git a/fs/configfs/item.c b/fs/configfs/item.c
index 76dc4c3..adccddd 100644
--- a/fs/configfs/item.c
+++ b/fs/configfs/item.c
@@ -112,22 +112,32 @@ int config_item_set_name(struct config_item * item, const char * fmt, ...)
 
 EXPORT_SYMBOL(config_item_set_name);
 
-void config_item_init_type_name(struct config_item *item,
+int config_item_init_type_name(struct config_item *item,
 				const char *name,
 				struct config_item_type *type)
 {
-	config_item_set_name(item, name);
+	int error;
+
+	error = config_item_set_name(item, name);
+	if (error)
+		return error;
 	item->ci_type = type;
 	config_item_init(item);
+	return 0;
 }
 EXPORT_SYMBOL(config_item_init_type_name);
 
-void config_group_init_type_name(struct config_group *group, const char *name,
+int config_group_init_type_name(struct config_group *group, const char *name,
 			 struct config_item_type *type)
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
 }
 EXPORT_SYMBOL(config_group_init_type_name);
 
diff --git a/fs/dlm/config.c b/fs/dlm/config.c
index 492d8ca..dff563f 100644
--- a/fs/dlm/config.c
+++ b/fs/dlm/config.c
@@ -403,6 +403,7 @@ static int make_cluster(struct config_group *g, const char *name,
 	struct spaces *sps = NULL;
 	struct comms *cms = NULL;
 	void *gps = NULL;
+	int ret = -ENOMEM;
 
 	cl = kzalloc(sizeof(struct cluster), GFP_KERNEL);
 	gps = kcalloc(3, sizeof(struct config_group *), GFP_KERNEL);
@@ -412,9 +413,16 @@ static int make_cluster(struct config_group *g, const char *name,
 	if (!cl || !gps || !sps || !cms)
 		goto fail;
 
-	config_group_init_type_name(&cl->group, name, &cluster_type);
-	config_group_init_type_name(&sps->ss_group, "spaces", &spaces_type);
-	config_group_init_type_name(&cms->cs_group, "comms", &comms_type);
+	ret = config_group_init_type_name(&cl->group, name, &cluster_type);
+	if (ret)
+		goto fail;
+	ret = config_group_init_type_name(&sps->ss_group,
+					  "spaces", &spaces_type);
+	if (ret)
+		goto fail_sps;
+	ret = config_group_init_type_name(&cms->cs_group, "comms", &comms_type);
+	if (ret)
+		goto fail_cms;
 
 	cl->group.default_groups = gps;
 	cl->group.default_groups[0] = &sps->ss_group;
@@ -438,12 +446,16 @@ static int make_cluster(struct config_group *g, const char *name,
 	*new_g = &cl->group;
 	return 0;
 
+ fail_cms:
+	config_group_put(&sps->ss_group);
+ fail_sps:
+	config_group_put(&cl->group);
  fail:
 	kfree(cl);
 	kfree(gps);
 	kfree(sps);
 	kfree(cms);
-	return -ENOMEM;
+	return ret;
 }
 
 static void drop_cluster(struct config_group *g, struct config_item *i)
@@ -477,6 +489,7 @@ static int make_space(struct config_group *g, const char *name,
 	struct space *sp = NULL;
 	struct nodes *nds = NULL;
 	void *gps = NULL;
+	int ret = -ENOMEM;
 
 	sp = kzalloc(sizeof(struct space), GFP_KERNEL);
 	gps = kcalloc(2, sizeof(struct config_group *), GFP_KERNEL);
@@ -485,8 +498,14 @@ static int make_space(struct config_group *g, const char *name,
 	if (!sp || !gps || !nds)
 		goto fail;
 
-	config_group_init_type_name(&sp->group, name, &space_type);
-	config_group_init_type_name(&nds->ns_group, "nodes", &nodes_type);
+	ret = config_group_init_type_name(&sp->group, name, &space_type);
+	if (ret)
+		goto fail;
+	ret = config_group_init_type_name(&nds->ns_group, "nodes", &nodes_type);
+	if (ret) {
+		config_group_put(&sp->group);
+		goto fail;
+	}
 
 	sp->group.default_groups = gps;
 	sp->group.default_groups[0] = &nds->ns_group;
@@ -502,7 +521,7 @@ static int make_space(struct config_group *g, const char *name,
 	kfree(sp);
 	kfree(gps);
 	kfree(nds);
-	return -ENOMEM;
+	return ret;
 }
 
 static void drop_space(struct config_group *g, struct config_item *i)
@@ -533,12 +552,17 @@ static int make_comm(struct config_group *g, const char *name,
 		     struct config_item **new_i)
 {
 	struct comm *cm;
+	int ret;
 
 	cm = kzalloc(sizeof(struct comm), GFP_KERNEL);
 	if (!cm)
 		return -ENOMEM;
 
-	config_item_init_type_name(&cm->item, name, &comm_type);
+	ret = config_item_init_type_name(&cm->item, name, &comm_type);
+	if (ret) {
+		kfree(cm);
+		return ret;
+	}
 	cm->nodeid = -1;
 	cm->local = 0;
 	cm->addr_count = 0;
@@ -568,12 +592,18 @@ static int make_node(struct config_group *g, const char *name,
 {
 	struct space *sp = to_space(g->cg_item.ci_parent);
 	struct node *nd;
+	int ret;
 
 	nd = kzalloc(sizeof(struct node), GFP_KERNEL);
 	if (!nd)
 		return -ENOMEM;
 
-	config_item_init_type_name(&nd->item, name, &node_type);
+	ret = config_item_init_type_name(&nd->item, name, &node_type);
+	if (ret)??{
+		kfree(nd);
+		return ret;
+	}
+
 	nd->nodeid = -1;
 	nd->weight = 1;  /* default weight of 1 if none is set */
 	nd->new = 1;     /* set to 0 once it's been read by dlm_nodeid_list() */
diff --git a/fs/ocfs2/cluster/heartbeat.c b/fs/ocfs2/cluster/heartbeat.c
index 443d108..564d000 100644
--- a/fs/ocfs2/cluster/heartbeat.c
+++ b/fs/ocfs2/cluster/heartbeat.c
@@ -1502,7 +1502,10 @@ static int o2hb_heartbeat_group_make_item(struct config_group *group,
 		goto out;
 	}
 
-	config_item_init_type_name(&reg->hr_item, name, &o2hb_region_type);
+	ret = config_item_init_type_name(&reg->hr_item, name,
+					 &o2hb_region_type);
+	if (ret)
+		goto out;
 
 	*new_item = &reg->hr_item;
 
@@ -1641,8 +1644,9 @@ struct config_group *o2hb_alloc_hb_set(void)
 	if (hs == NULL)
 		goto out;
 
-	config_group_init_type_name(&hs->hs_group, "heartbeat",
-				    &o2hb_heartbeat_group_type);
+	if (config_group_init_type_name(&hs->hs_group, "heartbeat",
+					&o2hb_heartbeat_group_type))
+		goto out;
 
 	ret = &hs->hs_group;
 out:
diff --git a/fs/ocfs2/cluster/nodemanager.c b/fs/ocfs2/cluster/nodemanager.c
index fe09cc3..ed97c04 100644
--- a/fs/ocfs2/cluster/nodemanager.c
+++ b/fs/ocfs2/cluster/nodemanager.c
@@ -723,7 +723,9 @@ static int o2nm_node_group_make_item(struct config_group *group,
 	}
 
 	strcpy(node->nd_name, name); /* use item.ci_namebuf instead? */
-	config_item_init_type_name(&node->nd_item, name, &o2nm_node_type);
+	ret = config_item_init_type_name(&node->nd_item, name, &o2nm_node_type);
+	if (ret)
+		goto out;
 	spin_lock_init(&node->nd_lock);
 
 	*new_item = &node->nd_item;
@@ -842,10 +844,16 @@ static int o2nm_cluster_group_make_group(struct config_group *group,
 		goto out;
 	}
 
-	config_group_init_type_name(&cluster->cl_group, name,
-				    &o2nm_cluster_type);
-	config_group_init_type_name(&ns->ns_group, "node",
-				    &o2nm_node_group_type);
+	ret = config_group_init_type_name(&cluster->cl_group, name,
+					  &o2nm_cluster_type);
+	if (ret)
+		goto out;
+	ret = config_group_init_type_name(&ns->ns_group, "node",
+					  &o2nm_node_group_type);
+	if (ret) {
+		config_group_put(&cluster->cl_group);
+		goto out;
+	}
 
 	cluster->cl_group.default_groups = defs;
 	cluster->cl_group.default_groups[0] = &ns->ns_group;
diff --git a/include/linux/configfs.h b/include/linux/configfs.h
index 0488f93..a6e13f7 100644
--- a/include/linux/configfs.h
+++ b/include/linux/configfs.h
@@ -71,9 +71,9 @@ static inline char *config_item_name(struct config_item * item)
 }
 
 extern void config_item_init(struct config_item *);
-extern void config_item_init_type_name(struct config_item *item,
-				       const char *name,
-				       struct config_item_type *type);
+extern int config_item_init_type_name(struct config_item *item,
+				      const char *name,
+				      struct config_item_type *type);
 
 extern struct config_item * config_item_get(struct config_item *);
 extern void config_item_put(struct config_item *);
@@ -97,7 +97,7 @@ struct config_group {
 };
 
 extern void config_group_init(struct config_group *group);
-extern void config_group_init_type_name(struct config_group *group,
+extern int config_group_init_type_name(struct config_group *group,
 					const char *name,
 					struct config_item_type *type);
 
-- 
1.5.5.3
