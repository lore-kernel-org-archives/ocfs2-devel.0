From: Joel Becker <joel.becker@oracle.com>
Date: Thu, 12 Jun 2008 14:19:55 -0700
Subject: [Ocfs2-devel] [RFC] configfs: Allow ->make_item() and
	->make_group() to return detailed errors.
Message-ID: <1213305595-16805-1-git-send-email-joel.becker@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-fsdevel@vger.kernel.org
Cc: cluster-devel@redhat.com, Louis.Rilling@kerlabs.com, linux-kernel@vger.kernel.org, ocfs2-devel@oss.oracle.com

The configfs operations ->make_item() and ->make_group() currently
return a new item/group.  A return of NULL signifies an error.  Because
of this, -ENOMEM is the only return code bubbled up the stack.

Multiple folks have requested the ability to return specific error codes
when these operations fail.  This patch adds that ability by changing the
->make_item/group() ops to return an int.

Also updated are the in-kernel users of configfs.

Signed-off-by: Joel Becker <joel.becker@oracle.com>
---
 Documentation/filesystems/configfs/configfs.txt    |   10 +++--
 .../filesystems/configfs/configfs_example.c        |   14 ++++---
 drivers/net/netconsole.c                           |   10 +++--
 fs/configfs/dir.c                                  |   13 +++---
 fs/dlm/config.c                                    |   45 ++++++++++++-------
 fs/ocfs2/cluster/heartbeat.c                       |   17 ++++---
 fs/ocfs2/cluster/nodemanager.c                     |   45 ++++++++++++-------
 include/linux/configfs.h                           |    4 +-
 8 files changed, 94 insertions(+), 64 deletions(-)

diff --git a/Documentation/filesystems/configfs/configfs.txt b/Documentation/filesystems/configfs/configfs.txt
index 44c97e6..15838d7 100644
--- a/Documentation/filesystems/configfs/configfs.txt
+++ b/Documentation/filesystems/configfs/configfs.txt
@@ -233,10 +233,12 @@ accomplished via the group operations specified on the group's
 config_item_type.
 
 	struct configfs_group_operations {
-		struct config_item *(*make_item)(struct config_group *group,
-						 const char *name);
-		struct config_group *(*make_group)(struct config_group *group,
-						   const char *name);
+		int (*make_item)(struct config_group *group,
+				 const char *name,
+				 struct config_item **new_item);
+		int (*make_group)(struct config_group *group,
+				  const char *name,
+				  struct config_group **new_group);
 		int (*commit_item)(struct config_item *item);
 		void (*disconnect_notify)(struct config_group *group,
 					  struct config_item *item);
diff --git a/Documentation/filesystems/configfs/configfs_example.c b/Documentation/filesystems/configfs/configfs_example.c
index 25151fd..0b422ac 100644
--- a/Documentation/filesystems/configfs/configfs_example.c
+++ b/Documentation/filesystems/configfs/configfs_example.c
@@ -273,13 +273,13 @@ static inline struct simple_children *to_simple_children(struct config_item *ite
 	return item ? container_of(to_config_group(item), struct simple_children, group) : NULL;
 }
 
-static struct config_item *simple_children_make_item(struct config_group *group, const char *name)
+static int simple_children_make_item(struct config_group *group, const char *name, struct config_item **new_item)
 {
 	struct simple_child *simple_child;
 
 	simple_child = kzalloc(sizeof(struct simple_child), GFP_KERNEL);
 	if (!simple_child)
-		return NULL;
+		return -ENOMEM;
 
 
 	config_item_init_type_name(&simple_child->item, name,
@@ -287,7 +287,8 @@ static struct config_item *simple_children_make_item(struct config_group *group,
 
 	simple_child->storeme = 0;
 
-	return &simple_child->item;
+	*new_item = &simple_child->item;
+	return 0;
 }
 
 static struct configfs_attribute simple_children_attr_description = {
@@ -359,20 +360,21 @@ static struct configfs_subsystem simple_children_subsys = {
  * children of its own.
  */
 
-static struct config_group *group_children_make_group(struct config_group *group, const char *name)
+static int group_children_make_group(struct config_group *group, const char *name, struct config_group **new_group)
 {
 	struct simple_children *simple_children;
 
 	simple_children = kzalloc(sizeof(struct simple_children),
 				  GFP_KERNEL);
 	if (!simple_children)
-		return NULL;
+		return -ENOMEM;
 
 
 	config_group_init_type_name(&simple_children->group, name,
 				    &simple_children_type);
 
-	return &simple_children->group;
+	*new_group = &simple_children->group;
+	return 0;
 }
 
 static struct configfs_attribute group_children_attr_description = {
diff --git a/drivers/net/netconsole.c b/drivers/net/netconsole.c
index 665341e..387a133 100644
--- a/drivers/net/netconsole.c
+++ b/drivers/net/netconsole.c
@@ -585,8 +585,9 @@ static struct config_item_type netconsole_target_type = {
  * Group operations and type for netconsole_subsys.
  */
 
-static struct config_item *make_netconsole_target(struct config_group *group,
-						  const char *name)
+static int make_netconsole_target(struct config_group *group,
+				  const char *name,
+				  struct config_item **new_item)
 {
 	unsigned long flags;
 	struct netconsole_target *nt;
@@ -598,7 +599,7 @@ static struct config_item *make_netconsole_target(struct config_group *group,
 	nt = kzalloc(sizeof(*nt), GFP_KERNEL);
 	if (!nt) {
 		printk(KERN_ERR "netconsole: failed to allocate memory\n");
-		return NULL;
+		return -ENOMEM;
 	}
 
 	nt->np.name = "netconsole";
@@ -615,7 +616,8 @@ static struct config_item *make_netconsole_target(struct config_group *group,
 	list_add(&nt->list, &target_list);
 	spin_unlock_irqrestore(&target_list_lock, flags);
 
-	return &nt->item;
+	*new_item = &nt->item;
+	return 0;
 }
 
 static void drop_netconsole_target(struct config_group *group,
diff --git a/fs/configfs/dir.c b/fs/configfs/dir.c
index a48dc7d..4773201 100644
--- a/fs/configfs/dir.c
+++ b/fs/configfs/dir.c
@@ -1047,25 +1047,24 @@ static int configfs_mkdir(struct inode *dir, struct dentry *dentry, int mode)
 	group = NULL;
 	item = NULL;
 	if (type->ct_group_ops->make_group) {
-		group = type->ct_group_ops->make_group(to_config_group(parent_item), name);
-		if (group) {
+		ret = type->ct_group_ops->make_group(to_config_group(parent_item), name, &group);
+		if (!ret) {
 			link_group(to_config_group(parent_item), group);
 			item = &group->cg_item;
 		}
 	} else {
-		item = type->ct_group_ops->make_item(to_config_group(parent_item), name);
-		if (item)
+		ret = type->ct_group_ops->make_item(to_config_group(parent_item), name, &item);
+		if (!ret)
 			link_obj(parent_item, item);
 	}
 	mutex_unlock(&subsys->su_mutex);
 
 	kfree(name);
-	if (!item) {
+	if (ret) {
 		/*
-		 * If item == NULL, then link_obj() was never called.
+		 * If ret != 0, then link_obj() was never called.
 		 * There are no extra references to clean up.
 		 */
-		ret = -ENOMEM;
 		goto out_put;
 	}
 
diff --git a/fs/dlm/config.c b/fs/dlm/config.c
index eac23bd..492d8ca 100644
--- a/fs/dlm/config.c
+++ b/fs/dlm/config.c
@@ -41,16 +41,20 @@ struct comm;
 struct nodes;
 struct node;
 
-static struct config_group *make_cluster(struct config_group *, const char *);
+static int make_cluster(struct config_group *, const char *,
+			struct config_group **);
 static void drop_cluster(struct config_group *, struct config_item *);
 static void release_cluster(struct config_item *);
-static struct config_group *make_space(struct config_group *, const char *);
+static int make_space(struct config_group *, const char *,
+		      struct config_group **);
 static void drop_space(struct config_group *, struct config_item *);
 static void release_space(struct config_item *);
-static struct config_item *make_comm(struct config_group *, const char *);
+static int make_comm(struct config_group *, const char *,
+		     struct config_item **);
 static void drop_comm(struct config_group *, struct config_item *);
 static void release_comm(struct config_item *);
-static struct config_item *make_node(struct config_group *, const char *);
+static int make_node(struct config_group *, const char *,
+		     struct config_item **);
 static void drop_node(struct config_group *, struct config_item *);
 static void release_node(struct config_item *);
 
@@ -392,8 +396,8 @@ static struct node *to_node(struct config_item *i)
 	return i ? container_of(i, struct node, item) : NULL;
 }
 
-static struct config_group *make_cluster(struct config_group *g,
-					 const char *name)
+static int make_cluster(struct config_group *g, const char *name,
+			struct config_group **new_g)
 {
 	struct cluster *cl = NULL;
 	struct spaces *sps = NULL;
@@ -431,14 +435,15 @@ static struct config_group *make_cluster(struct config_group *g,
 
 	space_list = &sps->ss_group;
 	comm_list = &cms->cs_group;
-	return &cl->group;
+	*new_g = &cl->group;
+	return 0;
 
  fail:
 	kfree(cl);
 	kfree(gps);
 	kfree(sps);
 	kfree(cms);
-	return NULL;
+	return -ENOMEM;
 }
 
 static void drop_cluster(struct config_group *g, struct config_item *i)
@@ -466,7 +471,8 @@ static void release_cluster(struct config_item *i)
 	kfree(cl);
 }
 
-static struct config_group *make_space(struct config_group *g, const char *name)
+static int make_space(struct config_group *g, const char *name,
+		      struct config_group **new_g)
 {
 	struct space *sp = NULL;
 	struct nodes *nds = NULL;
@@ -489,13 +495,14 @@ static struct config_group *make_space(struct config_group *g, const char *name)
 	INIT_LIST_HEAD(&sp->members);
 	mutex_init(&sp->members_lock);
 	sp->members_count = 0;
-	return &sp->group;
+	*new_g = &sp->group;
+	return 0;
 
  fail:
 	kfree(sp);
 	kfree(gps);
 	kfree(nds);
-	return NULL;
+	return -ENOMEM;
 }
 
 static void drop_space(struct config_group *g, struct config_item *i)
@@ -522,19 +529,21 @@ static void release_space(struct config_item *i)
 	kfree(sp);
 }
 
-static struct config_item *make_comm(struct config_group *g, const char *name)
+static int make_comm(struct config_group *g, const char *name,
+		     struct config_item **new_i)
 {
 	struct comm *cm;
 
 	cm = kzalloc(sizeof(struct comm), GFP_KERNEL);
 	if (!cm)
-		return NULL;
+		return -ENOMEM;
 
 	config_item_init_type_name(&cm->item, name, &comm_type);
 	cm->nodeid = -1;
 	cm->local = 0;
 	cm->addr_count = 0;
-	return &cm->item;
+	*new_i = &cm->item;
+	return 0;
 }
 
 static void drop_comm(struct config_group *g, struct config_item *i)
@@ -554,14 +563,15 @@ static void release_comm(struct config_item *i)
 	kfree(cm);
 }
 
-static struct config_item *make_node(struct config_group *g, const char *name)
+static int make_node(struct config_group *g, const char *name,
+		     struct config_item **new_i)
 {
 	struct space *sp = to_space(g->cg_item.ci_parent);
 	struct node *nd;
 
 	nd = kzalloc(sizeof(struct node), GFP_KERNEL);
 	if (!nd)
-		return NULL;
+		return -ENOMEM;
 
 	config_item_init_type_name(&nd->item, name, &node_type);
 	nd->nodeid = -1;
@@ -573,7 +583,8 @@ static struct config_item *make_node(struct config_group *g, const char *name)
 	sp->members_count++;
 	mutex_unlock(&sp->members_lock);
 
-	return &nd->item;
+	*new_i = &nd->item;
+	return 0;
 }
 
 static void drop_node(struct config_group *g, struct config_item *i)
diff --git a/fs/ocfs2/cluster/heartbeat.c b/fs/ocfs2/cluster/heartbeat.c
index f02ccb3..443d108 100644
--- a/fs/ocfs2/cluster/heartbeat.c
+++ b/fs/ocfs2/cluster/heartbeat.c
@@ -1489,25 +1489,28 @@ static struct o2hb_heartbeat_group *to_o2hb_heartbeat_group(struct config_group
 		: NULL;
 }
 
-static struct config_item *o2hb_heartbeat_group_make_item(struct config_group *group,
-							  const char *name)
+static int o2hb_heartbeat_group_make_item(struct config_group *group,
+					  const char *name,
+					  struct config_item **new_item)
 {
 	struct o2hb_region *reg = NULL;
-	struct config_item *ret = NULL;
+	int ret = 0;
 
 	reg = kzalloc(sizeof(struct o2hb_region), GFP_KERNEL);
-	if (reg == NULL)
-		goto out; /* ENOMEM */
+	if (reg == NULL) {
+		ret = -ENOMEM;
+		goto out;
+	}
 
 	config_item_init_type_name(&reg->hr_item, name, &o2hb_region_type);
 
-	ret = &reg->hr_item;
+	*new_item = &reg->hr_item;
 
 	spin_lock(&o2hb_live_lock);
 	list_add_tail(&reg->hr_all_item, &o2hb_all_regions);
 	spin_unlock(&o2hb_live_lock);
 out:
-	if (ret == NULL)
+	if (ret)
 		kfree(reg);
 
 	return ret;
diff --git a/fs/ocfs2/cluster/nodemanager.c b/fs/ocfs2/cluster/nodemanager.c
index cf9401e..fe09cc3 100644
--- a/fs/ocfs2/cluster/nodemanager.c
+++ b/fs/ocfs2/cluster/nodemanager.c
@@ -704,27 +704,32 @@ out:
 	return ret;
 }
 
-static struct config_item *o2nm_node_group_make_item(struct config_group *group,
-						     const char *name)
+static int o2nm_node_group_make_item(struct config_group *group,
+				     const char *name,
+				     struct config_item **new_item)
 {
 	struct o2nm_node *node = NULL;
-	struct config_item *ret = NULL;
+	int ret = 0;
 
-	if (strlen(name) > O2NM_MAX_NAME_LEN)
-		goto out; /* ENAMETOOLONG */
+	if (strlen(name) > O2NM_MAX_NAME_LEN) {
+		ret = -ENAMETOOLONG;
+		goto out;
+	}
 
 	node = kzalloc(sizeof(struct o2nm_node), GFP_KERNEL);
-	if (node == NULL)
-		goto out; /* ENOMEM */
+	if (node == NULL) {
+		ret = -ENOMEM;
+		goto out;
+	}
 
 	strcpy(node->nd_name, name); /* use item.ci_namebuf instead? */
 	config_item_init_type_name(&node->nd_item, name, &o2nm_node_type);
 	spin_lock_init(&node->nd_lock);
 
-	ret = &node->nd_item;
+	*new_item = &node->nd_item;
 
 out:
-	if (ret == NULL)
+	if (ret)
 		kfree(node);
 
 	return ret;
@@ -811,25 +816,31 @@ static struct o2nm_cluster_group *to_o2nm_cluster_group(struct config_group *gro
 }
 #endif
 
-static struct config_group *o2nm_cluster_group_make_group(struct config_group *group,
-							  const char *name)
+static int o2nm_cluster_group_make_group(struct config_group *group,
+					 const char *name,
+					 struct config_group **new_group)
 {
 	struct o2nm_cluster *cluster = NULL;
 	struct o2nm_node_group *ns = NULL;
-	struct config_group *o2hb_group = NULL, *ret = NULL;
+	struct config_group *o2hb_group = NULL;
 	void *defs = NULL;
+	int ret = 0;
 
 	/* this runs under the parent dir's i_mutex; there can be only
 	 * one caller in here at a time */
-	if (o2nm_single_cluster)
-		goto out; /* ENOSPC */
+	if (o2nm_single_cluster) {
+		ret = -ENOSPC;
+		goto out;
+	}
 
 	cluster = kzalloc(sizeof(struct o2nm_cluster), GFP_KERNEL);
 	ns = kzalloc(sizeof(struct o2nm_node_group), GFP_KERNEL);
 	defs = kcalloc(3, sizeof(struct config_group *), GFP_KERNEL);
 	o2hb_group = o2hb_alloc_hb_set();
-	if (cluster == NULL || ns == NULL || o2hb_group == NULL || defs == NULL)
+	if (cluster == NULL || ns == NULL || o2hb_group == NULL || defs == NULL) {
+		ret = -ENOMEM;
 		goto out;
+	}
 
 	config_group_init_type_name(&cluster->cl_group, name,
 				    &o2nm_cluster_type);
@@ -846,11 +857,11 @@ static struct config_group *o2nm_cluster_group_make_group(struct config_group *g
 	cluster->cl_idle_timeout_ms    = O2NET_IDLE_TIMEOUT_MS_DEFAULT;
 	cluster->cl_keepalive_delay_ms = O2NET_KEEPALIVE_DELAY_MS_DEFAULT;
 
-	ret = &cluster->cl_group;
+	*new_group = &cluster->cl_group;
 	o2nm_single_cluster = cluster;
 
 out:
-	if (ret == NULL) {
+	if (ret) {
 		kfree(cluster);
 		kfree(ns);
 		o2hb_free_hb_set(o2hb_group);
diff --git a/include/linux/configfs.h b/include/linux/configfs.h
index 3ae65b1..0488f93 100644
--- a/include/linux/configfs.h
+++ b/include/linux/configfs.h
@@ -165,8 +165,8 @@ struct configfs_item_operations {
 };
 
 struct configfs_group_operations {
-	struct config_item *(*make_item)(struct config_group *group, const char *name);
-	struct config_group *(*make_group)(struct config_group *group, const char *name);
+	int (*make_item)(struct config_group *group, const char *name, struct config_item **new_item);
+	int (*make_group)(struct config_group *group, const char *name, struct config_group **new_group);
 	int (*commit_item)(struct config_item *item);
 	void (*disconnect_notify)(struct config_group *group, struct config_item *item);
 	void (*drop_item)(struct config_group *group, struct config_item *item);
-- 
1.5.5.4
