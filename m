From: Joel Becker <jlbec@evilplan.org>
Date: Sat, 5 Mar 2016 13:40:50 -0800
Subject: [Ocfs2-devel] [PATCH] configfs: switch ->default groups to a
	linked list
In-Reply-To: <1456490031-7132-1-git-send-email-hch@lst.de>
References: <1456490031-7132-1-git-send-email-hch@lst.de>
Message-ID: <20160305214045.GG32432@noexit.roam.corp.google.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Cc: balbi-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, laurent.pinchart-ryLnwIuWjnjg/C1BVhZhaw@public.gmane.org, target-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cluster-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, ocfs2-devel-N0ozoZBvEnrZJqsBc5GL+g@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Acked-by: Joel Becker <jlbec@evilplan.org>

On Fri, Feb 26, 2016 at 01:33:51PM +0100, Christoph Hellwig wrote:
> Replace the current NULL-terminated array of default groups with a linked
> list.  This gets rid of lots of nasty code to size and/or dynamically
> allocate the array.
> 
> While we're at it also provide a conveniant helper to remove the default
> groups.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  Documentation/filesystems/configfs/configfs.txt |  11 +-
>  drivers/infiniband/core/cma_configfs.c          |  31 ++--
>  drivers/target/iscsi/iscsi_target_configfs.c    |  75 +++------
>  drivers/target/target_core_configfs.c           | 203 +++++-------------------
>  drivers/target/target_core_fabric_configfs.c    | 194 ++++++----------------
>  drivers/target/target_core_internal.h           |   1 -
>  drivers/target/target_core_stat.c               |  41 ++---
>  drivers/usb/gadget/configfs.c                   |  36 ++---
>  drivers/usb/gadget/function/f_mass_storage.c    |   6 +-
>  drivers/usb/gadget/function/f_rndis.c           |   1 -
>  drivers/usb/gadget/function/uvc_configfs.c      | 198 +++++++++--------------
>  fs/configfs/dir.c                               |  44 +++--
>  fs/configfs/item.c                              |   1 +
>  fs/dlm/config.c                                 |  38 +----
>  fs/ocfs2/cluster/nodemanager.c                  |  22 +--
>  include/linux/configfs.h                        |  11 +-
>  include/target/target_core_base.h               |   3 -
>  17 files changed, 284 insertions(+), 632 deletions(-)
> 
> diff --git a/Documentation/filesystems/configfs/configfs.txt b/Documentation/filesystems/configfs/configfs.txt
> index e5fe521..8ec9136 100644
> --- a/Documentation/filesystems/configfs/configfs.txt
> +++ b/Documentation/filesystems/configfs/configfs.txt
> @@ -250,7 +250,8 @@ child item.
>  		struct config_item		cg_item;
>  		struct list_head		cg_children;
>  		struct configfs_subsystem 	*cg_subsys;
> -		struct config_group		**default_groups;
> +		struct list_head		default_groups;
> +		struct list_head		group_entry;
>  	};
>  
>  	void config_group_init(struct config_group *group);
> @@ -420,15 +421,15 @@ These automatic subgroups, or default groups, do not preclude other
>  children of the parent group.  If ct_group_ops->make_group() exists,
>  other child groups can be created on the parent group directly.
>  
> -A configfs subsystem specifies default groups by filling in the
> -NULL-terminated array default_groups on the config_group structure.
> -Each group in that array is populated in the configfs tree at the same
> +A configfs subsystem specifies default groups by adding them using the
> +configfs_add_default_group() function to the parent config_group
> +structure.  Each added group is populated in the configfs tree at the same
>  time as the parent group.  Similarly, they are removed at the same time
>  as the parent.  No extra notification is provided.  When a ->drop_item()
>  method call notifies the subsystem the parent group is going away, it
>  also means every default group child associated with that parent group.
>  
> -As a consequence of this, default_groups cannot be removed directly via
> +As a consequence of this, default groups cannot be removed directly via
>  rmdir(2).  They also are not considered when rmdir(2) on the parent
>  group is checking for children.
>  
> diff --git a/drivers/infiniband/core/cma_configfs.c b/drivers/infiniband/core/cma_configfs.c
> index 18b112a..41573df 100644
> --- a/drivers/infiniband/core/cma_configfs.c
> +++ b/drivers/infiniband/core/cma_configfs.c
> @@ -49,8 +49,6 @@ struct cma_dev_group {
>  	char				name[IB_DEVICE_NAME_MAX];
>  	struct config_group		device_group;
>  	struct config_group		ports_group;
> -	struct config_group		*default_dev_group[2];
> -	struct config_group		**default_ports_group;
>  	struct cma_dev_port_group	*ports;
>  };
>  
> @@ -158,7 +156,6 @@ static int make_cma_ports(struct cma_dev_group *cma_dev_group,
>  	unsigned int i;
>  	unsigned int ports_num;
>  	struct cma_dev_port_group *ports;
> -	struct config_group **ports_group;
>  	int err;
>  
>  	ibdev = cma_get_ib_dev(cma_dev);
> @@ -169,9 +166,8 @@ static int make_cma_ports(struct cma_dev_group *cma_dev_group,
>  	ports_num = ibdev->phys_port_cnt;
>  	ports = kcalloc(ports_num, sizeof(*cma_dev_group->ports),
>  			GFP_KERNEL);
> -	ports_group = kcalloc(ports_num + 1, sizeof(*ports_group), GFP_KERNEL);
>  
> -	if (!ports || !ports_group) {
> +	if (!ports) {
>  		err = -ENOMEM;
>  		goto free;
>  	}
> @@ -185,18 +181,16 @@ static int make_cma_ports(struct cma_dev_group *cma_dev_group,
>  		config_group_init_type_name(&ports[i].group,
>  					    port_str,
>  					    &cma_port_group_type);
> -		ports_group[i] = &ports[i].group;
> +		configfs_add_default_group(&ports[i].group,
> +				&cma_dev_group->ports_group);
> +
>  	}
> -	ports_group[i] = NULL;
> -	cma_dev_group->default_ports_group = ports_group;
>  	cma_dev_group->ports = ports;
>  
>  	return 0;
>  free:
>  	kfree(ports);
> -	kfree(ports_group);
>  	cma_dev_group->ports = NULL;
> -	cma_dev_group->default_ports_group = NULL;
>  	return err;
>  }
>  
> @@ -220,9 +214,7 @@ static void release_cma_ports_group(struct config_item  *item)
>  							   ports_group);
>  
>  	kfree(cma_dev_group->ports);
> -	kfree(cma_dev_group->default_ports_group);
>  	cma_dev_group->ports = NULL;
> -	cma_dev_group->default_ports_group = NULL;
>  };
>  
>  static struct configfs_item_operations cma_ports_item_ops = {
> @@ -263,22 +255,17 @@ static struct config_group *make_cma_dev(struct config_group *group,
>  
>  	strncpy(cma_dev_group->name, name, sizeof(cma_dev_group->name));
>  
> -	err = make_cma_ports(cma_dev_group, cma_dev);
> -	if (err)
> -		goto fail;
> -
> -	cma_dev_group->ports_group.default_groups =
> -		cma_dev_group->default_ports_group;
>  	config_group_init_type_name(&cma_dev_group->ports_group, "ports",
>  				    &cma_ports_group_type);
>  
> -	cma_dev_group->device_group.default_groups
> -		= cma_dev_group->default_dev_group;
> -	cma_dev_group->default_dev_group[0] = &cma_dev_group->ports_group;
> -	cma_dev_group->default_dev_group[1] = NULL;
> +	err = make_cma_ports(cma_dev_group, cma_dev);
> +	if (err)
> +		goto fail;
>  
>  	config_group_init_type_name(&cma_dev_group->device_group, name,
>  				    &cma_device_group_type);
> +	configfs_add_default_group(&cma_dev_group->ports_group,
> +			&cma_dev_group->device_group);
>  
>  	cma_deref_dev(cma_dev);
>  	return &cma_dev_group->device_group;
> diff --git a/drivers/target/iscsi/iscsi_target_configfs.c b/drivers/target/iscsi/iscsi_target_configfs.c
> index 2f821de..a24443b 100644
> --- a/drivers/target/iscsi/iscsi_target_configfs.c
> +++ b/drivers/target/iscsi/iscsi_target_configfs.c
> @@ -771,21 +771,11 @@ static int lio_target_init_nodeacl(struct se_node_acl *se_nacl,
>  {
>  	struct iscsi_node_acl *acl =
>  		container_of(se_nacl, struct iscsi_node_acl, se_node_acl);
> -	struct config_group *stats_cg = &se_nacl->acl_fabric_stat_group;
> -
> -	stats_cg->default_groups = kmalloc(sizeof(struct config_group *) * 2,
> -				GFP_KERNEL);
> -	if (!stats_cg->default_groups) {
> -		pr_err("Unable to allocate memory for"
> -				" stats_cg->default_groups\n");
> -		return -ENOMEM;
> -	}
>  
> -	stats_cg->default_groups[0] = &acl->node_stat_grps.iscsi_sess_stats_group;
> -	stats_cg->default_groups[1] = NULL;
>  	config_group_init_type_name(&acl->node_stat_grps.iscsi_sess_stats_group,
>  			"iscsi_sess_stats", &iscsi_stat_sess_cit);
> -
> +	configfs_add_default_group(&acl->node_stat_grps.iscsi_sess_stats_group,
> +			&se_nacl->acl_fabric_stat_group);
>  	return 0;
>  }
>  
> @@ -793,17 +783,8 @@ static void lio_target_cleanup_nodeacl( struct se_node_acl *se_nacl)
>  {
>  	struct iscsi_node_acl *acl = container_of(se_nacl,
>  			struct iscsi_node_acl, se_node_acl);
> -	struct config_item *df_item;
> -	struct config_group *stats_cg;
> -	int i;
> -
> -	stats_cg = &acl->se_node_acl.acl_fabric_stat_group;
> -	for (i = 0; stats_cg->default_groups[i]; i++) {
> -		df_item = &stats_cg->default_groups[i]->cg_item;
> -		stats_cg->default_groups[i] = NULL;
> -		config_item_put(df_item);
> -	}
> -	kfree(stats_cg->default_groups);
> +
> +	configfs_remove_default_groups(&acl->se_node_acl.acl_fabric_stat_group);
>  }
>  
>  /* End items for lio_target_acl_cit */
> @@ -1260,42 +1241,37 @@ static struct se_wwn *lio_target_call_coreaddtiqn(
>  	struct config_group *group,
>  	const char *name)
>  {
> -	struct config_group *stats_cg;
>  	struct iscsi_tiqn *tiqn;
>  
>  	tiqn = iscsit_add_tiqn((unsigned char *)name);
>  	if (IS_ERR(tiqn))
>  		return ERR_CAST(tiqn);
> -	/*
> -	 * Setup struct iscsi_wwn_stat_grps for se_wwn->fabric_stat_group.
> -	 */
> -	stats_cg = &tiqn->tiqn_wwn.fabric_stat_group;
> -
> -	stats_cg->default_groups = kmalloc(sizeof(struct config_group *) * 6,
> -				GFP_KERNEL);
> -	if (!stats_cg->default_groups) {
> -		pr_err("Unable to allocate memory for"
> -				" stats_cg->default_groups\n");
> -		iscsit_del_tiqn(tiqn);
> -		return ERR_PTR(-ENOMEM);
> -	}
>  
> -	stats_cg->default_groups[0] = &tiqn->tiqn_stat_grps.iscsi_instance_group;
> -	stats_cg->default_groups[1] = &tiqn->tiqn_stat_grps.iscsi_sess_err_group;
> -	stats_cg->default_groups[2] = &tiqn->tiqn_stat_grps.iscsi_tgt_attr_group;
> -	stats_cg->default_groups[3] = &tiqn->tiqn_stat_grps.iscsi_login_stats_group;
> -	stats_cg->default_groups[4] = &tiqn->tiqn_stat_grps.iscsi_logout_stats_group;
> -	stats_cg->default_groups[5] = NULL;
>  	config_group_init_type_name(&tiqn->tiqn_stat_grps.iscsi_instance_group,
>  			"iscsi_instance", &iscsi_stat_instance_cit);
> +	configfs_add_default_group(&tiqn->tiqn_stat_grps.iscsi_instance_group,
> +			&tiqn->tiqn_wwn.fabric_stat_group);
> +
>  	config_group_init_type_name(&tiqn->tiqn_stat_grps.iscsi_sess_err_group,
>  			"iscsi_sess_err", &iscsi_stat_sess_err_cit);
> +	configfs_add_default_group(&tiqn->tiqn_stat_grps.iscsi_sess_err_group,
> +			&tiqn->tiqn_wwn.fabric_stat_group);
> +
>  	config_group_init_type_name(&tiqn->tiqn_stat_grps.iscsi_tgt_attr_group,
>  			"iscsi_tgt_attr", &iscsi_stat_tgt_attr_cit);
> +	configfs_add_default_group(&tiqn->tiqn_stat_grps.iscsi_tgt_attr_group,
> +			&tiqn->tiqn_wwn.fabric_stat_group);
> +
>  	config_group_init_type_name(&tiqn->tiqn_stat_grps.iscsi_login_stats_group,
>  			"iscsi_login_stats", &iscsi_stat_login_cit);
> +	configfs_add_default_group(&tiqn->tiqn_stat_grps.iscsi_login_stats_group,
> +			&tiqn->tiqn_wwn.fabric_stat_group);
> +
>  	config_group_init_type_name(&tiqn->tiqn_stat_grps.iscsi_logout_stats_group,
>  			"iscsi_logout_stats", &iscsi_stat_logout_cit);
> +	configfs_add_default_group(&tiqn->tiqn_stat_grps.iscsi_logout_stats_group,
> +			&tiqn->tiqn_wwn.fabric_stat_group);
> +
>  
>  	pr_debug("LIO_Target_ConfigFS: REGISTER -> %s\n", tiqn->tiqn);
>  	pr_debug("LIO_Target_ConfigFS: REGISTER -> Allocated Node:"
> @@ -1307,17 +1283,8 @@ static void lio_target_call_coredeltiqn(
>  	struct se_wwn *wwn)
>  {
>  	struct iscsi_tiqn *tiqn = container_of(wwn, struct iscsi_tiqn, tiqn_wwn);
> -	struct config_item *df_item;
> -	struct config_group *stats_cg;
> -	int i;
> -
> -	stats_cg = &tiqn->tiqn_wwn.fabric_stat_group;
> -	for (i = 0; stats_cg->default_groups[i]; i++) {
> -		df_item = &stats_cg->default_groups[i]->cg_item;
> -		stats_cg->default_groups[i] = NULL;
> -		config_item_put(df_item);
> -	}
> -	kfree(stats_cg->default_groups);
> +
> +	configfs_remove_default_groups(&tiqn->tiqn_wwn.fabric_stat_group);
>  
>  	pr_debug("LIO_Target_ConfigFS: DEREGISTER -> %s\n",
>  			tiqn->tiqn);
> diff --git a/drivers/target/target_core_configfs.c b/drivers/target/target_core_configfs.c
> index 713c63d9..d498533 100644
> --- a/drivers/target/target_core_configfs.c
> +++ b/drivers/target/target_core_configfs.c
> @@ -194,13 +194,11 @@ static struct config_group *target_core_register_fabric(
>  	pr_debug("Target_Core_ConfigFS: REGISTER tfc_wwn_cit -> %p\n",
>  			&tf->tf_wwn_cit);
>  
> -	tf->tf_group.default_groups = tf->tf_default_groups;
> -	tf->tf_group.default_groups[0] = &tf->tf_disc_group;
> -	tf->tf_group.default_groups[1] = NULL;
> -
>  	config_group_init_type_name(&tf->tf_group, name, &tf->tf_wwn_cit);
> +
>  	config_group_init_type_name(&tf->tf_disc_group, "discovery_auth",
>  			&tf->tf_discovery_cit);
> +	configfs_add_default_group(&tf->tf_disc_group, &tf->tf_group);
>  
>  	pr_debug("Target_Core_ConfigFS: REGISTER -> Allocated Fabric:"
>  			" %s\n", tf->tf_group.cg_item.ci_name);
> @@ -216,9 +214,6 @@ static void target_core_deregister_fabric(
>  {
>  	struct target_fabric_configfs *tf = container_of(
>  		to_config_group(item), struct target_fabric_configfs, tf_group);
> -	struct config_group *tf_group;
> -	struct config_item *df_item;
> -	int i;
>  
>  	pr_debug("Target_Core_ConfigFS: DEREGISTER -> Looking up %s in"
>  		" tf list\n", config_item_name(item));
> @@ -230,12 +225,7 @@ static void target_core_deregister_fabric(
>  	pr_debug("Target_Core_ConfigFS: DEREGISTER -> Releasing ci"
>  			" %s\n", config_item_name(item));
>  
> -	tf_group = &tf->tf_group;
> -	for (i = 0; tf_group->default_groups[i]; i++) {
> -		df_item = &tf_group->default_groups[i]->cg_item;
> -		tf_group->default_groups[i] = NULL;
> -		config_item_put(df_item);
> -	}
> +	configfs_remove_default_groups(&tf->tf_group);
>  	config_item_put(item);
>  }
>  
> @@ -2151,7 +2141,6 @@ static void target_core_dev_release(struct config_item *item)
>  	struct se_device *dev =
>  		container_of(dev_cg, struct se_device, dev_group);
>  
> -	kfree(dev_cg->default_groups);
>  	target_free_device(dev);
>  }
>  
> @@ -2819,8 +2808,6 @@ static struct config_group *target_core_make_subdev(
>  	struct se_hba *hba = item_to_hba(hba_ci);
>  	struct target_backend *tb = hba->backend;
>  	struct se_device *dev;
> -	struct config_group *dev_cg = NULL, *tg_pt_gp_cg = NULL;
> -	struct config_group *dev_stat_grp = NULL;
>  	int errno = -ENOMEM, ret;
>  
>  	ret = mutex_lock_interruptible(&hba->hba_access_mutex);
> @@ -2831,73 +2818,52 @@ static struct config_group *target_core_make_subdev(
>  	if (!dev)
>  		goto out_unlock;
>  
> -	dev_cg = &dev->dev_group;
> -
> -	dev_cg->default_groups = kmalloc(sizeof(struct config_group *) * 6,
> -			GFP_KERNEL);
> -	if (!dev_cg->default_groups)
> -		goto out_free_device;
> +	config_group_init_type_name(&dev->dev_group, name, &tb->tb_dev_cit);
>  
> -	config_group_init_type_name(dev_cg, name, &tb->tb_dev_cit);
>  	config_group_init_type_name(&dev->dev_attrib.da_group, "attrib",
>  			&tb->tb_dev_attrib_cit);
> +	configfs_add_default_group(&dev->dev_attrib.da_group, &dev->dev_group);
> +
>  	config_group_init_type_name(&dev->dev_pr_group, "pr",
>  			&tb->tb_dev_pr_cit);
> +	configfs_add_default_group(&dev->dev_pr_group, &dev->dev_group);
> +
>  	config_group_init_type_name(&dev->t10_wwn.t10_wwn_group, "wwn",
>  			&tb->tb_dev_wwn_cit);
> +	configfs_add_default_group(&dev->t10_wwn.t10_wwn_group,
> +			&dev->dev_group);
> +
>  	config_group_init_type_name(&dev->t10_alua.alua_tg_pt_gps_group,
>  			"alua", &tb->tb_dev_alua_tg_pt_gps_cit);
> +	configfs_add_default_group(&dev->t10_alua.alua_tg_pt_gps_group,
> +			&dev->dev_group);
> +
>  	config_group_init_type_name(&dev->dev_stat_grps.stat_group,
>  			"statistics", &tb->tb_dev_stat_cit);
> +	configfs_add_default_group(&dev->dev_stat_grps.stat_group,
> +			&dev->dev_group);
>  
> -	dev_cg->default_groups[0] = &dev->dev_attrib.da_group;
> -	dev_cg->default_groups[1] = &dev->dev_pr_group;
> -	dev_cg->default_groups[2] = &dev->t10_wwn.t10_wwn_group;
> -	dev_cg->default_groups[3] = &dev->t10_alua.alua_tg_pt_gps_group;
> -	dev_cg->default_groups[4] = &dev->dev_stat_grps.stat_group;
> -	dev_cg->default_groups[5] = NULL;
>  	/*
>  	 * Add core/$HBA/$DEV/alua/default_tg_pt_gp
>  	 */
>  	tg_pt_gp = core_alua_allocate_tg_pt_gp(dev, "default_tg_pt_gp", 1);
>  	if (!tg_pt_gp)
> -		goto out_free_dev_cg_default_groups;
> +		goto out_free_device;
>  	dev->t10_alua.default_tg_pt_gp = tg_pt_gp;
>  
> -	tg_pt_gp_cg = &dev->t10_alua.alua_tg_pt_gps_group;
> -	tg_pt_gp_cg->default_groups = kmalloc(sizeof(struct config_group *) * 2,
> -				GFP_KERNEL);
> -	if (!tg_pt_gp_cg->default_groups) {
> -		pr_err("Unable to allocate tg_pt_gp_cg->"
> -				"default_groups\n");
> -		goto out_free_tg_pt_gp;
> -	}
> -
>  	config_group_init_type_name(&tg_pt_gp->tg_pt_gp_group,
>  			"default_tg_pt_gp", &target_core_alua_tg_pt_gp_cit);
> -	tg_pt_gp_cg->default_groups[0] = &tg_pt_gp->tg_pt_gp_group;
> -	tg_pt_gp_cg->default_groups[1] = NULL;
> +	configfs_add_default_group(&tg_pt_gp->tg_pt_gp_group,
> +			&dev->t10_alua.alua_tg_pt_gps_group);
> +
>  	/*
>  	 * Add core/$HBA/$DEV/statistics/ default groups
>  	 */
> -	dev_stat_grp = &dev->dev_stat_grps.stat_group;
> -	dev_stat_grp->default_groups = kmalloc(sizeof(struct config_group *) * 4,
> -				GFP_KERNEL);
> -	if (!dev_stat_grp->default_groups) {
> -		pr_err("Unable to allocate dev_stat_grp->default_groups\n");
> -		goto out_free_tg_pt_gp_cg_default_groups;
> -	}
>  	target_stat_setup_dev_default_groups(dev);
>  
>  	mutex_unlock(&hba->hba_access_mutex);
> -	return dev_cg;
> +	return &dev->dev_group;
>  
> -out_free_tg_pt_gp_cg_default_groups:
> -	kfree(tg_pt_gp_cg->default_groups);
> -out_free_tg_pt_gp:
> -	core_alua_free_tg_pt_gp(tg_pt_gp);
> -out_free_dev_cg_default_groups:
> -	kfree(dev_cg->default_groups);
>  out_free_device:
>  	target_free_device(dev);
>  out_unlock:
> @@ -2913,40 +2879,22 @@ static void target_core_drop_subdev(
>  	struct se_device *dev =
>  		container_of(dev_cg, struct se_device, dev_group);
>  	struct se_hba *hba;
> -	struct config_item *df_item;
> -	struct config_group *tg_pt_gp_cg, *dev_stat_grp;
> -	int i;
>  
>  	hba = item_to_hba(&dev->se_hba->hba_group.cg_item);
>  
>  	mutex_lock(&hba->hba_access_mutex);
>  
> -	dev_stat_grp = &dev->dev_stat_grps.stat_group;
> -	for (i = 0; dev_stat_grp->default_groups[i]; i++) {
> -		df_item = &dev_stat_grp->default_groups[i]->cg_item;
> -		dev_stat_grp->default_groups[i] = NULL;
> -		config_item_put(df_item);
> -	}
> -	kfree(dev_stat_grp->default_groups);
> +	configfs_remove_default_groups(&dev->dev_stat_grps.stat_group);
> +	configfs_remove_default_groups(&dev->t10_alua.alua_tg_pt_gps_group);
>  
> -	tg_pt_gp_cg = &dev->t10_alua.alua_tg_pt_gps_group;
> -	for (i = 0; tg_pt_gp_cg->default_groups[i]; i++) {
> -		df_item = &tg_pt_gp_cg->default_groups[i]->cg_item;
> -		tg_pt_gp_cg->default_groups[i] = NULL;
> -		config_item_put(df_item);
> -	}
> -	kfree(tg_pt_gp_cg->default_groups);
>  	/*
>  	 * core_alua_free_tg_pt_gp() is called from ->default_tg_pt_gp
>  	 * directly from target_core_alua_tg_pt_gp_release().
>  	 */
>  	dev->t10_alua.default_tg_pt_gp = NULL;
>  
> -	for (i = 0; dev_cg->default_groups[i]; i++) {
> -		df_item = &dev_cg->default_groups[i]->cg_item;
> -		dev_cg->default_groups[i] = NULL;
> -		config_item_put(df_item);
> -	}
> +	configfs_remove_default_groups(dev_cg);
> +
>  	/*
>  	 * se_dev is released from target_core_dev_item_ops->release()
>  	 */
> @@ -3141,8 +3089,6 @@ void target_setup_backend_cits(struct target_backend *tb)
>  
>  static int __init target_core_init_configfs(void)
>  {
> -	struct config_group *target_cg, *hba_cg = NULL, *alua_cg = NULL;
> -	struct config_group *lu_gp_cg = NULL;
>  	struct configfs_subsystem *subsys = &target_core_fabrics;
>  	struct t10_alua_lu_gp *lu_gp;
>  	int ret;
> @@ -3161,51 +3107,24 @@ static int __init target_core_init_configfs(void)
>  	 * Create $CONFIGFS/target/core default group for HBA <-> Storage Object
>  	 * and ALUA Logical Unit Group and Target Port Group infrastructure.
>  	 */
> -	target_cg = &subsys->su_group;
> -	target_cg->default_groups = kmalloc(sizeof(struct config_group *) * 2,
> -				GFP_KERNEL);
> -	if (!target_cg->default_groups) {
> -		pr_err("Unable to allocate target_cg->default_groups\n");
> -		ret = -ENOMEM;
> -		goto out_global;
> -	}
> +	config_group_init_type_name(&target_core_hbagroup, "core",
> +			&target_core_cit);
> +	configfs_add_default_group(&target_core_hbagroup, &subsys->su_group);
>  
> -	config_group_init_type_name(&target_core_hbagroup,
> -			"core", &target_core_cit);
> -	target_cg->default_groups[0] = &target_core_hbagroup;
> -	target_cg->default_groups[1] = NULL;
>  	/*
>  	 * Create ALUA infrastructure under /sys/kernel/config/target/core/alua/
>  	 */
> -	hba_cg = &target_core_hbagroup;
> -	hba_cg->default_groups = kmalloc(sizeof(struct config_group *) * 2,
> -				GFP_KERNEL);
> -	if (!hba_cg->default_groups) {
> -		pr_err("Unable to allocate hba_cg->default_groups\n");
> -		ret = -ENOMEM;
> -		goto out_global;
> -	}
> -	config_group_init_type_name(&alua_group,
> -			"alua", &target_core_alua_cit);
> -	hba_cg->default_groups[0] = &alua_group;
> -	hba_cg->default_groups[1] = NULL;
> +	config_group_init_type_name(&alua_group, "alua", &target_core_alua_cit);
> +	configfs_add_default_group(&alua_group, &target_core_hbagroup);
> +
>  	/*
>  	 * Add ALUA Logical Unit Group and Target Port Group ConfigFS
>  	 * groups under /sys/kernel/config/target/core/alua/
>  	 */
> -	alua_cg = &alua_group;
> -	alua_cg->default_groups = kmalloc(sizeof(struct config_group *) * 2,
> -			GFP_KERNEL);
> -	if (!alua_cg->default_groups) {
> -		pr_err("Unable to allocate alua_cg->default_groups\n");
> -		ret = -ENOMEM;
> -		goto out_global;
> -	}
> +	config_group_init_type_name(&alua_lu_gps_group, "lu_gps",
> +			&target_core_alua_lu_gps_cit);
> +	configfs_add_default_group(&alua_lu_gps_group, &alua_group);
>  
> -	config_group_init_type_name(&alua_lu_gps_group,
> -			"lu_gps", &target_core_alua_lu_gps_cit);
> -	alua_cg->default_groups[0] = &alua_lu_gps_group;
> -	alua_cg->default_groups[1] = NULL;
>  	/*
>  	 * Add core/alua/lu_gps/default_lu_gp
>  	 */
> @@ -3215,20 +3134,12 @@ static int __init target_core_init_configfs(void)
>  		goto out_global;
>  	}
>  
> -	lu_gp_cg = &alua_lu_gps_group;
> -	lu_gp_cg->default_groups = kmalloc(sizeof(struct config_group *) * 2,
> -			GFP_KERNEL);
> -	if (!lu_gp_cg->default_groups) {
> -		pr_err("Unable to allocate lu_gp_cg->default_groups\n");
> -		ret = -ENOMEM;
> -		goto out_global;
> -	}
> -
>  	config_group_init_type_name(&lu_gp->lu_gp_group, "default_lu_gp",
>  				&target_core_alua_lu_gp_cit);
> -	lu_gp_cg->default_groups[0] = &lu_gp->lu_gp_group;
> -	lu_gp_cg->default_groups[1] = NULL;
> +	configfs_add_default_group(&lu_gp->lu_gp_group, &alua_lu_gps_group);
> +
>  	default_lu_gp = lu_gp;
> +
>  	/*
>  	 * Register the target_core_mod subsystem with configfs.
>  	 */
> @@ -3267,55 +3178,21 @@ out_global:
>  		core_alua_free_lu_gp(default_lu_gp);
>  		default_lu_gp = NULL;
>  	}
> -	if (lu_gp_cg)
> -		kfree(lu_gp_cg->default_groups);
> -	if (alua_cg)
> -		kfree(alua_cg->default_groups);
> -	if (hba_cg)
> -		kfree(hba_cg->default_groups);
> -	kfree(target_cg->default_groups);
>  	release_se_kmem_caches();
>  	return ret;
>  }
>  
>  static void __exit target_core_exit_configfs(void)
>  {
> -	struct config_group *hba_cg, *alua_cg, *lu_gp_cg;
> -	struct config_item *item;
> -	int i;
> +	configfs_remove_default_groups(&alua_lu_gps_group);
> +	configfs_remove_default_groups(&alua_group);
> +	configfs_remove_default_groups(&target_core_hbagroup);
>  
> -	lu_gp_cg = &alua_lu_gps_group;
> -	for (i = 0; lu_gp_cg->default_groups[i]; i++) {
> -		item = &lu_gp_cg->default_groups[i]->cg_item;
> -		lu_gp_cg->default_groups[i] = NULL;
> -		config_item_put(item);
> -	}
> -	kfree(lu_gp_cg->default_groups);
> -	lu_gp_cg->default_groups = NULL;
> -
> -	alua_cg = &alua_group;
> -	for (i = 0; alua_cg->default_groups[i]; i++) {
> -		item = &alua_cg->default_groups[i]->cg_item;
> -		alua_cg->default_groups[i] = NULL;
> -		config_item_put(item);
> -	}
> -	kfree(alua_cg->default_groups);
> -	alua_cg->default_groups = NULL;
> -
> -	hba_cg = &target_core_hbagroup;
> -	for (i = 0; hba_cg->default_groups[i]; i++) {
> -		item = &hba_cg->default_groups[i]->cg_item;
> -		hba_cg->default_groups[i] = NULL;
> -		config_item_put(item);
> -	}
> -	kfree(hba_cg->default_groups);
> -	hba_cg->default_groups = NULL;
>  	/*
>  	 * We expect subsys->su_group.default_groups to be released
>  	 * by configfs subsystem provider logic..
>  	 */
>  	configfs_unregister_subsystem(&target_core_fabrics);
> -	kfree(target_core_fabrics.su_group.default_groups);
>  
>  	core_alua_free_lu_gp(default_lu_gp);
>  	default_lu_gp = NULL;
> diff --git a/drivers/target/target_core_fabric_configfs.c b/drivers/target/target_core_fabric_configfs.c
> index f916d18..8caef31 100644
> --- a/drivers/target/target_core_fabric_configfs.c
> +++ b/drivers/target/target_core_fabric_configfs.c
> @@ -273,18 +273,10 @@ static struct config_group *target_fabric_make_mappedlun(
>  	struct se_portal_group *se_tpg = se_nacl->se_tpg;
>  	struct target_fabric_configfs *tf = se_tpg->se_tpg_wwn->wwn_tf;
>  	struct se_lun_acl *lacl = NULL;
> -	struct config_item *acl_ci;
> -	struct config_group *lacl_cg = NULL, *ml_stat_grp = NULL;
>  	char *buf;
>  	unsigned long long mapped_lun;
>  	int ret = 0;
>  
> -	acl_ci = &group->cg_item;
> -	if (!acl_ci) {
> -		pr_err("Unable to locatel acl_ci\n");
> -		return NULL;
> -	}
> -
>  	buf = kzalloc(strlen(name) + 1, GFP_KERNEL);
>  	if (!buf) {
>  		pr_err("Unable to allocate memory for name buf\n");
> @@ -315,37 +307,19 @@ static struct config_group *target_fabric_make_mappedlun(
>  		goto out;
>  	}
>  
> -	lacl_cg = &lacl->se_lun_group;
> -	lacl_cg->default_groups = kmalloc(sizeof(struct config_group *) * 2,
> -				GFP_KERNEL);
> -	if (!lacl_cg->default_groups) {
> -		pr_err("Unable to allocate lacl_cg->default_groups\n");
> -		ret = -ENOMEM;
> -		goto out;
> -	}
> -
>  	config_group_init_type_name(&lacl->se_lun_group, name,
>  			&tf->tf_tpg_mappedlun_cit);
> +
>  	config_group_init_type_name(&lacl->ml_stat_grps.stat_group,
>  			"statistics", &tf->tf_tpg_mappedlun_stat_cit);
> -	lacl_cg->default_groups[0] = &lacl->ml_stat_grps.stat_group;
> -	lacl_cg->default_groups[1] = NULL;
> -
> -	ml_stat_grp = &lacl->ml_stat_grps.stat_group;
> -	ml_stat_grp->default_groups = kmalloc(sizeof(struct config_group *) * 3,
> -				GFP_KERNEL);
> -	if (!ml_stat_grp->default_groups) {
> -		pr_err("Unable to allocate ml_stat_grp->default_groups\n");
> -		ret = -ENOMEM;
> -		goto out;
> -	}
> +	configfs_add_default_group(&lacl->ml_stat_grps.stat_group,
> +			&lacl->se_lun_group);
> +
>  	target_stat_setup_mappedlun_default_groups(lacl);
>  
>  	kfree(buf);
>  	return &lacl->se_lun_group;
>  out:
> -	if (lacl_cg)
> -		kfree(lacl_cg->default_groups);
>  	kfree(lacl);
>  	kfree(buf);
>  	return ERR_PTR(ret);
> @@ -357,25 +331,9 @@ static void target_fabric_drop_mappedlun(
>  {
>  	struct se_lun_acl *lacl = container_of(to_config_group(item),
>  			struct se_lun_acl, se_lun_group);
> -	struct config_item *df_item;
> -	struct config_group *lacl_cg = NULL, *ml_stat_grp = NULL;
> -	int i;
> -
> -	ml_stat_grp = &lacl->ml_stat_grps.stat_group;
> -	for (i = 0; ml_stat_grp->default_groups[i]; i++) {
> -		df_item = &ml_stat_grp->default_groups[i]->cg_item;
> -		ml_stat_grp->default_groups[i] = NULL;
> -		config_item_put(df_item);
> -	}
> -	kfree(ml_stat_grp->default_groups);
>  
> -	lacl_cg = &lacl->se_lun_group;
> -	for (i = 0; lacl_cg->default_groups[i]; i++) {
> -		df_item = &lacl_cg->default_groups[i]->cg_item;
> -		lacl_cg->default_groups[i] = NULL;
> -		config_item_put(df_item);
> -	}
> -	kfree(lacl_cg->default_groups);
> +	configfs_remove_default_groups(&lacl->ml_stat_grps.stat_group);
> +	configfs_remove_default_groups(&lacl->se_lun_group);
>  
>  	config_item_put(item);
>  }
> @@ -424,7 +382,6 @@ static struct config_group *target_fabric_make_nodeacl(
>  			struct se_portal_group, tpg_acl_group);
>  	struct target_fabric_configfs *tf = se_tpg->se_tpg_wwn->wwn_tf;
>  	struct se_node_acl *se_nacl;
> -	struct config_group *nacl_cg;
>  
>  	se_nacl = core_tpg_add_initiator_node_acl(se_tpg, name);
>  	if (IS_ERR(se_nacl))
> @@ -438,24 +395,28 @@ static struct config_group *target_fabric_make_nodeacl(
>  		}
>  	}
>  
> -	nacl_cg = &se_nacl->acl_group;
> -	nacl_cg->default_groups = se_nacl->acl_default_groups;
> -	nacl_cg->default_groups[0] = &se_nacl->acl_attrib_group;
> -	nacl_cg->default_groups[1] = &se_nacl->acl_auth_group;
> -	nacl_cg->default_groups[2] = &se_nacl->acl_param_group;
> -	nacl_cg->default_groups[3] = &se_nacl->acl_fabric_stat_group;
> -	nacl_cg->default_groups[4] = NULL;
> -
>  	config_group_init_type_name(&se_nacl->acl_group, name,
>  			&tf->tf_tpg_nacl_base_cit);
> +
>  	config_group_init_type_name(&se_nacl->acl_attrib_group, "attrib",
>  			&tf->tf_tpg_nacl_attrib_cit);
> +	configfs_add_default_group(&se_nacl->acl_attrib_group,
> +			&se_nacl->acl_group);
> +
>  	config_group_init_type_name(&se_nacl->acl_auth_group, "auth",
>  			&tf->tf_tpg_nacl_auth_cit);
> +	configfs_add_default_group(&se_nacl->acl_auth_group,
> +			&se_nacl->acl_group);
> +
>  	config_group_init_type_name(&se_nacl->acl_param_group, "param",
>  			&tf->tf_tpg_nacl_param_cit);
> +	configfs_add_default_group(&se_nacl->acl_param_group,
> +			&se_nacl->acl_group);
> +
>  	config_group_init_type_name(&se_nacl->acl_fabric_stat_group,
>  			"fabric_statistics", &tf->tf_tpg_nacl_stat_cit);
> +	configfs_add_default_group(&se_nacl->acl_fabric_stat_group,
> +			&se_nacl->acl_group);
>  
>  	return &se_nacl->acl_group;
>  }
> @@ -466,16 +427,9 @@ static void target_fabric_drop_nodeacl(
>  {
>  	struct se_node_acl *se_nacl = container_of(to_config_group(item),
>  			struct se_node_acl, acl_group);
> -	struct config_item *df_item;
> -	struct config_group *nacl_cg;
> -	int i;
> -
> -	nacl_cg = &se_nacl->acl_group;
> -	for (i = 0; nacl_cg->default_groups[i]; i++) {
> -		df_item = &nacl_cg->default_groups[i]->cg_item;
> -		nacl_cg->default_groups[i] = NULL;
> -		config_item_put(df_item);
> -	}
> +
> +	configfs_remove_default_groups(&se_nacl->acl_group);
> +
>  	/*
>  	 * struct se_node_acl free is done in target_fabric_nacl_base_release()
>  	 */
> @@ -795,7 +749,6 @@ static struct config_group *target_fabric_make_lun(
>  	struct se_portal_group *se_tpg = container_of(group,
>  			struct se_portal_group, tpg_lun_group);
>  	struct target_fabric_configfs *tf = se_tpg->se_tpg_wwn->wwn_tf;
> -	struct config_group *lun_cg = NULL, *port_stat_grp = NULL;
>  	unsigned long long unpacked_lun;
>  	int errno;
>  
> @@ -812,31 +765,14 @@ static struct config_group *target_fabric_make_lun(
>  	if (IS_ERR(lun))
>  		return ERR_CAST(lun);
>  
> -	lun_cg = &lun->lun_group;
> -	lun_cg->default_groups = kmalloc(sizeof(struct config_group *) * 2,
> -				GFP_KERNEL);
> -	if (!lun_cg->default_groups) {
> -		pr_err("Unable to allocate lun_cg->default_groups\n");
> -		kfree(lun);
> -		return ERR_PTR(-ENOMEM);
> -	}
> -
>  	config_group_init_type_name(&lun->lun_group, name,
>  			&tf->tf_tpg_port_cit);
> +
>  	config_group_init_type_name(&lun->port_stat_grps.stat_group,
>  			"statistics", &tf->tf_tpg_port_stat_cit);
> -	lun_cg->default_groups[0] = &lun->port_stat_grps.stat_group;
> -	lun_cg->default_groups[1] = NULL;
> -
> -	port_stat_grp = &lun->port_stat_grps.stat_group;
> -	port_stat_grp->default_groups =  kzalloc(sizeof(struct config_group *) * 4,
> -				GFP_KERNEL);
> -	if (!port_stat_grp->default_groups) {
> -		pr_err("Unable to allocate port_stat_grp->default_groups\n");
> -		kfree(lun_cg->default_groups);
> -		kfree(lun);
> -		return ERR_PTR(-ENOMEM);
> -	}
> +	configfs_add_default_group(&lun->port_stat_grps.stat_group,
> +			&lun->lun_group);
> +
>  	target_stat_setup_port_default_groups(lun);
>  
>  	return &lun->lun_group;
> @@ -848,25 +784,9 @@ static void target_fabric_drop_lun(
>  {
>  	struct se_lun *lun = container_of(to_config_group(item),
>  				struct se_lun, lun_group);
> -	struct config_item *df_item;
> -	struct config_group *lun_cg, *port_stat_grp;
> -	int i;
> -
> -	port_stat_grp = &lun->port_stat_grps.stat_group;
> -	for (i = 0; port_stat_grp->default_groups[i]; i++) {
> -		df_item = &port_stat_grp->default_groups[i]->cg_item;
> -		port_stat_grp->default_groups[i] = NULL;
> -		config_item_put(df_item);
> -	}
> -	kfree(port_stat_grp->default_groups);
>  
> -	lun_cg = &lun->lun_group;
> -	for (i = 0; lun_cg->default_groups[i]; i++) {
> -		df_item = &lun_cg->default_groups[i]->cg_item;
> -		lun_cg->default_groups[i] = NULL;
> -		config_item_put(df_item);
> -	}
> -	kfree(lun_cg->default_groups);
> +	configfs_remove_default_groups(&lun->port_stat_grps.stat_group);
> +	configfs_remove_default_groups(&lun->lun_group);
>  
>  	config_item_put(item);
>  }
> @@ -922,32 +842,39 @@ static struct config_group *target_fabric_make_tpg(
>  	se_tpg = tf->tf_ops->fabric_make_tpg(wwn, group, name);
>  	if (!se_tpg || IS_ERR(se_tpg))
>  		return ERR_PTR(-EINVAL);
> -	/*
> -	 * Setup default groups from pre-allocated se_tpg->tpg_default_groups
> -	 */
> -	se_tpg->tpg_group.default_groups = se_tpg->tpg_default_groups;
> -	se_tpg->tpg_group.default_groups[0] = &se_tpg->tpg_lun_group;
> -	se_tpg->tpg_group.default_groups[1] = &se_tpg->tpg_np_group;
> -	se_tpg->tpg_group.default_groups[2] = &se_tpg->tpg_acl_group;
> -	se_tpg->tpg_group.default_groups[3] = &se_tpg->tpg_attrib_group;
> -	se_tpg->tpg_group.default_groups[4] = &se_tpg->tpg_auth_group;
> -	se_tpg->tpg_group.default_groups[5] = &se_tpg->tpg_param_group;
> -	se_tpg->tpg_group.default_groups[6] = NULL;
>  
>  	config_group_init_type_name(&se_tpg->tpg_group, name,
>  			&tf->tf_tpg_base_cit);
> +
>  	config_group_init_type_name(&se_tpg->tpg_lun_group, "lun",
>  			&tf->tf_tpg_lun_cit);
> +	configfs_add_default_group(&se_tpg->tpg_lun_group,
> +			&se_tpg->tpg_group);
> +
>  	config_group_init_type_name(&se_tpg->tpg_np_group, "np",
>  			&tf->tf_tpg_np_cit);
> +	configfs_add_default_group(&se_tpg->tpg_np_group,
> +			&se_tpg->tpg_group);
> +
>  	config_group_init_type_name(&se_tpg->tpg_acl_group, "acls",
>  			&tf->tf_tpg_nacl_cit);
> +	configfs_add_default_group(&se_tpg->tpg_acl_group,
> +			&se_tpg->tpg_group);
> +
>  	config_group_init_type_name(&se_tpg->tpg_attrib_group, "attrib",
>  			&tf->tf_tpg_attrib_cit);
> +	configfs_add_default_group(&se_tpg->tpg_attrib_group,
> +			&se_tpg->tpg_group);
> +
>  	config_group_init_type_name(&se_tpg->tpg_auth_group, "auth",
>  			&tf->tf_tpg_auth_cit);
> +	configfs_add_default_group(&se_tpg->tpg_auth_group,
> +			&se_tpg->tpg_group);
> +
>  	config_group_init_type_name(&se_tpg->tpg_param_group, "param",
>  			&tf->tf_tpg_param_cit);
> +	configfs_add_default_group(&se_tpg->tpg_param_group,
> +			&se_tpg->tpg_group);
>  
>  	return &se_tpg->tpg_group;
>  }
> @@ -958,19 +885,8 @@ static void target_fabric_drop_tpg(
>  {
>  	struct se_portal_group *se_tpg = container_of(to_config_group(item),
>  				struct se_portal_group, tpg_group);
> -	struct config_group *tpg_cg = &se_tpg->tpg_group;
> -	struct config_item *df_item;
> -	int i;
> -	/*
> -	 * Release default groups, but do not release tpg_cg->default_groups
> -	 * memory as it is statically allocated at se_tpg->tpg_default_groups.
> -	 */
> -	for (i = 0; tpg_cg->default_groups[i]; i++) {
> -		df_item = &tpg_cg->default_groups[i]->cg_item;
> -		tpg_cg->default_groups[i] = NULL;
> -		config_item_put(df_item);
> -	}
>  
> +	configfs_remove_default_groups(&se_tpg->tpg_group);
>  	config_item_put(item);
>  }
>  
> @@ -1026,16 +942,12 @@ static struct config_group *target_fabric_make_wwn(
>  		return ERR_PTR(-EINVAL);
>  
>  	wwn->wwn_tf = tf;
> -	/*
> -	 * Setup default groups from pre-allocated wwn->wwn_default_groups
> -	 */
> -	wwn->wwn_group.default_groups = wwn->wwn_default_groups;
> -	wwn->wwn_group.default_groups[0] = &wwn->fabric_stat_group;
> -	wwn->wwn_group.default_groups[1] = NULL;
>  
>  	config_group_init_type_name(&wwn->wwn_group, name, &tf->tf_tpg_cit);
> +
>  	config_group_init_type_name(&wwn->fabric_stat_group, "fabric_statistics",
>  			&tf->tf_wwn_fabric_stats_cit);
> +	configfs_add_default_group(&wwn->fabric_stat_group, &wwn->wwn_group);
>  
>  	return &wwn->wwn_group;
>  }
> @@ -1046,16 +958,8 @@ static void target_fabric_drop_wwn(
>  {
>  	struct se_wwn *wwn = container_of(to_config_group(item),
>  				struct se_wwn, wwn_group);
> -	struct config_item *df_item;
> -	struct config_group *cg = &wwn->wwn_group;
> -	int i;
> -
> -	for (i = 0; cg->default_groups[i]; i++) {
> -		df_item = &cg->default_groups[i]->cg_item;
> -		cg->default_groups[i] = NULL;
> -		config_item_put(df_item);
> -	}
>  
> +	configfs_remove_default_groups(&wwn->wwn_group);
>  	config_item_put(item);
>  }
>  
> diff --git a/drivers/target/target_core_internal.h b/drivers/target/target_core_internal.h
> index db4412f..4a7cf49 100644
> --- a/drivers/target/target_core_internal.h
> +++ b/drivers/target/target_core_internal.h
> @@ -22,7 +22,6 @@ struct target_fabric_configfs {
>  	struct list_head	tf_list;
>  	struct config_group	tf_group;
>  	struct config_group	tf_disc_group;
> -	struct config_group	*tf_default_groups[2];
>  	const struct target_core_fabric_ops *tf_ops;
>  
>  	struct config_item_type tf_discovery_cit;
> diff --git a/drivers/target/target_core_stat.c b/drivers/target/target_core_stat.c
> index 81a6b3e..1a39033 100644
> --- a/drivers/target/target_core_stat.c
> +++ b/drivers/target/target_core_stat.c
> @@ -407,19 +407,20 @@ static struct config_item_type target_stat_scsi_lu_cit = {
>   */
>  void target_stat_setup_dev_default_groups(struct se_device *dev)
>  {
> -	struct config_group *dev_stat_grp = &dev->dev_stat_grps.stat_group;
> -
>  	config_group_init_type_name(&dev->dev_stat_grps.scsi_dev_group,
>  			"scsi_dev", &target_stat_scsi_dev_cit);
> +	configfs_add_default_group(&dev->dev_stat_grps.scsi_dev_group,
> +			&dev->dev_stat_grps.stat_group);
> +
>  	config_group_init_type_name(&dev->dev_stat_grps.scsi_tgt_dev_group,
>  			"scsi_tgt_dev", &target_stat_scsi_tgt_dev_cit);
> +	configfs_add_default_group(&dev->dev_stat_grps.scsi_tgt_dev_group,
> +			&dev->dev_stat_grps.stat_group);
> +
>  	config_group_init_type_name(&dev->dev_stat_grps.scsi_lu_group,
>  			"scsi_lu", &target_stat_scsi_lu_cit);
> -
> -	dev_stat_grp->default_groups[0] = &dev->dev_stat_grps.scsi_dev_group;
> -	dev_stat_grp->default_groups[1] = &dev->dev_stat_grps.scsi_tgt_dev_group;
> -	dev_stat_grp->default_groups[2] = &dev->dev_stat_grps.scsi_lu_group;
> -	dev_stat_grp->default_groups[3] = NULL;
> +	configfs_add_default_group(&dev->dev_stat_grps.scsi_lu_group,
> +			&dev->dev_stat_grps.stat_group);
>  }
>  
>  /*
> @@ -818,19 +819,20 @@ static struct config_item_type target_stat_scsi_transport_cit = {
>   */
>  void target_stat_setup_port_default_groups(struct se_lun *lun)
>  {
> -	struct config_group *port_stat_grp = &lun->port_stat_grps.stat_group;
> -
>  	config_group_init_type_name(&lun->port_stat_grps.scsi_port_group,
>  			"scsi_port", &target_stat_scsi_port_cit);
> +	configfs_add_default_group(&lun->port_stat_grps.scsi_port_group,
> +			&lun->port_stat_grps.stat_group);
> +
>  	config_group_init_type_name(&lun->port_stat_grps.scsi_tgt_port_group,
>  			"scsi_tgt_port", &target_stat_scsi_tgt_port_cit);
> +	configfs_add_default_group(&lun->port_stat_grps.scsi_tgt_port_group,
> +			&lun->port_stat_grps.stat_group);
> +
>  	config_group_init_type_name(&lun->port_stat_grps.scsi_transport_group,
>  			"scsi_transport", &target_stat_scsi_transport_cit);
> -
> -	port_stat_grp->default_groups[0] = &lun->port_stat_grps.scsi_port_group;
> -	port_stat_grp->default_groups[1] = &lun->port_stat_grps.scsi_tgt_port_group;
> -	port_stat_grp->default_groups[2] = &lun->port_stat_grps.scsi_transport_group;
> -	port_stat_grp->default_groups[3] = NULL;
> +	configfs_add_default_group(&lun->port_stat_grps.scsi_transport_group,
> +			&lun->port_stat_grps.stat_group);
>  }
>  
>  /*
> @@ -1351,14 +1353,13 @@ static struct config_item_type target_stat_scsi_att_intr_port_cit = {
>   */
>  void target_stat_setup_mappedlun_default_groups(struct se_lun_acl *lacl)
>  {
> -	struct config_group *ml_stat_grp = &lacl->ml_stat_grps.stat_group;
> -
>  	config_group_init_type_name(&lacl->ml_stat_grps.scsi_auth_intr_group,
>  			"scsi_auth_intr", &target_stat_scsi_auth_intr_cit);
> +	configfs_add_default_group(&lacl->ml_stat_grps.scsi_auth_intr_group,
> +			&lacl->ml_stat_grps.stat_group);
> +
>  	config_group_init_type_name(&lacl->ml_stat_grps.scsi_att_intr_port_group,
>  			"scsi_att_intr_port", &target_stat_scsi_att_intr_port_cit);
> -
> -	ml_stat_grp->default_groups[0] = &lacl->ml_stat_grps.scsi_auth_intr_group;
> -	ml_stat_grp->default_groups[1] = &lacl->ml_stat_grps.scsi_att_intr_port_group;
> -	ml_stat_grp->default_groups[2] = NULL;
> +	configfs_add_default_group(&lacl->ml_stat_grps.scsi_att_intr_port_group,
> +			&lacl->ml_stat_grps.stat_group);
>  }
> diff --git a/drivers/usb/gadget/configfs.c b/drivers/usb/gadget/configfs.c
> index 590c449..2f8081f 100644
> --- a/drivers/usb/gadget/configfs.c
> +++ b/drivers/usb/gadget/configfs.c
> @@ -49,7 +49,6 @@ struct gadget_info {
>  	struct config_group configs_group;
>  	struct config_group strings_group;
>  	struct config_group os_desc_group;
> -	struct config_group *default_groups[5];
>  
>  	struct mutex lock;
>  	struct usb_gadget_strings *gstrings[MAX_USB_STRING_LANGS + 1];
> @@ -71,7 +70,6 @@ static inline struct gadget_info *to_gadget_info(struct config_item *item)
>  struct config_usb_cfg {
>  	struct config_group group;
>  	struct config_group strings_group;
> -	struct config_group *default_groups[2];
>  	struct list_head string_list;
>  	struct usb_configuration c;
>  	struct list_head func_list;
> @@ -666,13 +664,12 @@ static struct config_group *config_desc_make(
>  	INIT_LIST_HEAD(&cfg->string_list);
>  	INIT_LIST_HEAD(&cfg->func_list);
>  
> -	cfg->group.default_groups = cfg->default_groups;
> -	cfg->default_groups[0] = &cfg->strings_group;
> -
>  	config_group_init_type_name(&cfg->group, name,
>  				&gadget_config_type);
> +
>  	config_group_init_type_name(&cfg->strings_group, "strings",
>  			&gadget_config_name_strings_type);
> +	configfs_add_default_group(&cfg->strings_group, &cfg->group);
>  
>  	ret = usb_add_config_only(&gi->cdev, &cfg->c);
>  	if (ret)
> @@ -1149,15 +1146,11 @@ int usb_os_desc_prepare_interf_dir(struct config_group *parent,
>  				   char **names,
>  				   struct module *owner)
>  {
> -	struct config_group **f_default_groups, *os_desc_group,
> -				**interface_groups;
> +	struct config_group *os_desc_group;
>  	struct config_item_type *os_desc_type, *interface_type;
>  
>  	vla_group(data_chunk);
> -	vla_item(data_chunk, struct config_group *, f_default_groups, 2);
>  	vla_item(data_chunk, struct config_group, os_desc_group, 1);
> -	vla_item(data_chunk, struct config_group *, interface_groups,
> -		 n_interf + 1);
>  	vla_item(data_chunk, struct config_item_type, os_desc_type, 1);
>  	vla_item(data_chunk, struct config_item_type, interface_type, 1);
>  
> @@ -1165,18 +1158,14 @@ int usb_os_desc_prepare_interf_dir(struct config_group *parent,
>  	if (!vlabuf)
>  		return -ENOMEM;
>  
> -	f_default_groups = vla_ptr(vlabuf, data_chunk, f_default_groups);
>  	os_desc_group = vla_ptr(vlabuf, data_chunk, os_desc_group);
>  	os_desc_type = vla_ptr(vlabuf, data_chunk, os_desc_type);
> -	interface_groups = vla_ptr(vlabuf, data_chunk, interface_groups);
>  	interface_type = vla_ptr(vlabuf, data_chunk, interface_type);
>  
> -	parent->default_groups = f_default_groups;
>  	os_desc_type->ct_owner = owner;
>  	config_group_init_type_name(os_desc_group, "os_desc", os_desc_type);
> -	f_default_groups[0] = os_desc_group;
> +	configfs_add_default_group(os_desc_group, parent);
>  
> -	os_desc_group->default_groups = interface_groups;
>  	interface_type->ct_group_ops = &interf_grp_ops;
>  	interface_type->ct_attrs = interf_grp_attrs;
>  	interface_type->ct_owner = owner;
> @@ -1189,7 +1178,7 @@ int usb_os_desc_prepare_interf_dir(struct config_group *parent,
>  		config_group_init_type_name(&d->group, "", interface_type);
>  		config_item_set_name(&d->group.cg_item, "interface.%s",
>  				     names[n_interf]);
> -		interface_groups[n_interf] = &d->group;
> +		configfs_add_default_group(&d->group, os_desc_group);
>  	}
>  
>  	return 0;
> @@ -1423,20 +1412,23 @@ static struct config_group *gadgets_make(
>  	if (!gi)
>  		return ERR_PTR(-ENOMEM);
>  
> -	gi->group.default_groups = gi->default_groups;
> -	gi->group.default_groups[0] = &gi->functions_group;
> -	gi->group.default_groups[1] = &gi->configs_group;
> -	gi->group.default_groups[2] = &gi->strings_group;
> -	gi->group.default_groups[3] = &gi->os_desc_group;
> +	config_group_init_type_name(&gi->group, name, &gadget_root_type);
>  
>  	config_group_init_type_name(&gi->functions_group, "functions",
>  			&functions_type);
> +	configfs_add_default_group(&gi->functions_group, &gi->group);
> +
>  	config_group_init_type_name(&gi->configs_group, "configs",
>  			&config_desc_type);
> +	configfs_add_default_group(&gi->configs_group, &gi->group);
> +
>  	config_group_init_type_name(&gi->strings_group, "strings",
>  			&gadget_strings_strings_type);
> +	configfs_add_default_group(&gi->strings_group, &gi->group);
> +
>  	config_group_init_type_name(&gi->os_desc_group, "os_desc",
>  			&os_desc_type);
> +	configfs_add_default_group(&gi->os_desc_group, &gi->group);
>  
>  	gi->composite.bind = configfs_do_nothing;
>  	gi->composite.unbind = configfs_do_nothing;
> @@ -1461,8 +1453,6 @@ static struct config_group *gadgets_make(
>  	if (!gi->composite.gadget_driver.function)
>  		goto err;
>  
> -	config_group_init_type_name(&gi->group, name,
> -				&gadget_root_type);
>  	return &gi->group;
>  err:
>  	kfree(gi);
> diff --git a/drivers/usb/gadget/function/f_mass_storage.c b/drivers/usb/gadget/function/f_mass_storage.c
> index 223ccf8..142bb77 100644
> --- a/drivers/usb/gadget/function/f_mass_storage.c
> +++ b/drivers/usb/gadget/function/f_mass_storage.c
> @@ -3484,12 +3484,12 @@ static struct usb_function_instance *fsg_alloc_inst(void)
>  
>  	opts->lun0.lun = opts->common->luns[0];
>  	opts->lun0.lun_id = 0;
> -	config_group_init_type_name(&opts->lun0.group, "lun.0", &fsg_lun_type);
> -	opts->default_groups[0] = &opts->lun0.group;
> -	opts->func_inst.group.default_groups = opts->default_groups;
>  
>  	config_group_init_type_name(&opts->func_inst.group, "", &fsg_func_type);
>  
> +	config_group_init_type_name(&opts->lun0.group, "lun.0", &fsg_lun_type);
> +	configfs_add_default_group(&opts->lun0.group, &opts->func_inst.group);
> +
>  	return &opts->func_inst;
>  
>  release_buffers:
> diff --git a/drivers/usb/gadget/function/f_rndis.c b/drivers/usb/gadget/function/f_rndis.c
> index e587767..931953e 100644
> --- a/drivers/usb/gadget/function/f_rndis.c
> +++ b/drivers/usb/gadget/function/f_rndis.c
> @@ -889,7 +889,6 @@ static void rndis_free_inst(struct usb_function_instance *f)
>  			free_netdev(opts->net);
>  	}
>  
> -	kfree(opts->rndis_os_desc.group.default_groups); /* single VLA chunk */
>  	kfree(opts);
>  }
>  
> diff --git a/drivers/usb/gadget/function/uvc_configfs.c b/drivers/usb/gadget/function/uvc_configfs.c
> index ad8c9b0..66753ba 100644
> --- a/drivers/usb/gadget/function/uvc_configfs.c
> +++ b/drivers/usb/gadget/function/uvc_configfs.c
> @@ -272,11 +272,6 @@ static struct config_item_type uvcg_default_processing_type = {
>  
>  /* struct uvcg_processing {}; */
>  
> -static struct config_group *uvcg_processing_default_groups[] = {
> -	&uvcg_default_processing.group,
> -	NULL,
> -};
> -
>  /* control/processing */
>  static struct uvcg_processing_grp {
>  	struct config_group	group;
> @@ -394,11 +389,6 @@ static struct config_item_type uvcg_default_camera_type = {
>  
>  /* struct uvcg_camera {}; */
>  
> -static struct config_group *uvcg_camera_default_groups[] = {
> -	&uvcg_default_camera.group,
> -	NULL,
> -};
> -
>  /* control/terminal/camera */
>  static struct uvcg_camera_grp {
>  	struct config_group	group;
> @@ -477,11 +467,6 @@ static struct config_item_type uvcg_default_output_type = {
>  
>  /* struct uvcg_output {}; */
>  
> -static struct config_group *uvcg_output_default_groups[] = {
> -	&uvcg_default_output.group,
> -	NULL,
> -};
> -
>  /* control/terminal/output */
>  static struct uvcg_output_grp {
>  	struct config_group	group;
> @@ -491,12 +476,6 @@ static struct config_item_type uvcg_output_grp_type = {
>  	.ct_owner = THIS_MODULE,
>  };
>  
> -static struct config_group *uvcg_terminal_default_groups[] = {
> -	&uvcg_camera_grp.group,
> -	&uvcg_output_grp.group,
> -	NULL,
> -};
> -
>  /* control/terminal */
>  static struct uvcg_terminal_grp {
>  	struct config_group	group;
> @@ -619,12 +598,6 @@ static struct config_item_type uvcg_control_class_type = {
>  	.ct_owner	= THIS_MODULE,
>  };
>  
> -static struct config_group *uvcg_control_class_default_groups[] = {
> -	&uvcg_control_class_fs.group,
> -	&uvcg_control_class_ss.group,
> -	NULL,
> -};
> -
>  /* control/class */
>  static struct uvcg_control_class_grp {
>  	struct config_group	group;
> @@ -634,14 +607,6 @@ static struct config_item_type uvcg_control_class_grp_type = {
>  	.ct_owner = THIS_MODULE,
>  };
>  
> -static struct config_group *uvcg_control_default_groups[] = {
> -	&uvcg_control_header_grp.group,
> -	&uvcg_processing_grp.group,
> -	&uvcg_terminal_grp.group,
> -	&uvcg_control_class_grp.group,
> -	NULL,
> -};
> -
>  /* control */
>  static struct uvcg_control_grp {
>  	struct config_group	group;
> @@ -1780,11 +1745,6 @@ static struct config_item_type uvcg_default_color_matching_type = {
>  
>  /* struct uvcg_color_matching {}; */
>  
> -static struct config_group *uvcg_color_matching_default_groups[] = {
> -	&uvcg_default_color_matching.group,
> -	NULL,
> -};
> -
>  /* streaming/color_matching */
>  static struct uvcg_color_matching_grp {
>  	struct config_group	group;
> @@ -2145,13 +2105,6 @@ static struct config_item_type uvcg_streaming_class_type = {
>  	.ct_owner	= THIS_MODULE,
>  };
>  
> -static struct config_group *uvcg_streaming_class_default_groups[] = {
> -	&uvcg_streaming_class_fs.group,
> -	&uvcg_streaming_class_hs.group,
> -	&uvcg_streaming_class_ss.group,
> -	NULL,
> -};
> -
>  /* streaming/class */
>  static struct uvcg_streaming_class_grp {
>  	struct config_group	group;
> @@ -2161,15 +2114,6 @@ static struct config_item_type uvcg_streaming_class_grp_type = {
>  	.ct_owner = THIS_MODULE,
>  };
>  
> -static struct config_group *uvcg_streaming_default_groups[] = {
> -	&uvcg_streaming_header_grp.group,
> -	&uvcg_uncompressed_grp.group,
> -	&uvcg_mjpeg_grp.group,
> -	&uvcg_color_matching_grp.group,
> -	&uvcg_streaming_class_grp.group,
> -	NULL,
> -};
> -
>  /* streaming */
>  static struct uvcg_streaming_grp {
>  	struct config_group	group;
> @@ -2179,12 +2123,6 @@ static struct config_item_type uvcg_streaming_grp_type = {
>  	.ct_owner = THIS_MODULE,
>  };
>  
> -static struct config_group *uvcg_default_groups[] = {
> -	&uvcg_control_grp.group,
> -	&uvcg_streaming_grp.group,
> -	NULL,
> -};
> -
>  static inline struct f_uvc_opts *to_f_uvc_opts(struct config_item *item)
>  {
>  	return container_of(to_config_group(item), struct f_uvc_opts,
> @@ -2273,59 +2211,64 @@ static struct config_item_type uvc_func_type = {
>  	.ct_owner	= THIS_MODULE,
>  };
>  
> -static inline void uvcg_init_group(struct config_group *g,
> -				   struct config_group **default_groups,
> -				   const char *name,
> -				   struct config_item_type *type)
> -{
> -	g->default_groups = default_groups;
> -	config_group_init_type_name(g, name, type);
> -}
> -
>  int uvcg_attach_configfs(struct f_uvc_opts *opts)
>  {
>  	config_group_init_type_name(&uvcg_control_header_grp.group,
>  				    "header",
>  				    &uvcg_control_header_grp_type);
> +
>  	config_group_init_type_name(&uvcg_default_processing.group,
> -				    "default",
> -				    &uvcg_default_processing_type);
> -	uvcg_init_group(&uvcg_processing_grp.group,
> -			uvcg_processing_default_groups,
> -			"processing",
> -			&uvcg_processing_grp_type);
> +			"default", &uvcg_default_processing_type);
> +	config_group_init_type_name(&uvcg_processing_grp.group,
> +			"processing", &uvcg_processing_grp_type);
> +	configfs_add_default_group(&uvcg_default_processing.group,
> +			&uvcg_processing_grp.group);
> +
>  	config_group_init_type_name(&uvcg_default_camera.group,
> -				    "default",
> -				    &uvcg_default_camera_type);
> -	uvcg_init_group(&uvcg_camera_grp.group,
> -			uvcg_camera_default_groups,
> -			"camera",
> -			&uvcg_camera_grp_type);
> +			"default", &uvcg_default_camera_type);
> +	config_group_init_type_name(&uvcg_camera_grp.group,
> +			"camera", &uvcg_camera_grp_type);
> +	configfs_add_default_group(&uvcg_default_camera.group,
> +			&uvcg_camera_grp.group);
> +
>  	config_group_init_type_name(&uvcg_default_output.group,
> -				    "default",
> -				    &uvcg_default_output_type);
> -	uvcg_init_group(&uvcg_output_grp.group,
> -			uvcg_output_default_groups,
> -			"output",
> -			&uvcg_output_grp_type);
> -	uvcg_init_group(&uvcg_terminal_grp.group,
> -			uvcg_terminal_default_groups,
> -			"terminal",
> -			&uvcg_terminal_grp_type);
> +			"default", &uvcg_default_output_type);
> +	config_group_init_type_name(&uvcg_output_grp.group,
> +			"output", &uvcg_output_grp_type);
> +	configfs_add_default_group(&uvcg_default_output.group,
> +			&uvcg_output_grp.group);
> +
> +	config_group_init_type_name(&uvcg_terminal_grp.group,
> +			"terminal", &uvcg_terminal_grp_type);
> +	configfs_add_default_group(&uvcg_camera_grp.group,
> +			&uvcg_terminal_grp.group);
> +	configfs_add_default_group(&uvcg_output_grp.group,
> +			&uvcg_terminal_grp.group);
> +
>  	config_group_init_type_name(&uvcg_control_class_fs.group,
> -				    "fs",
> -				    &uvcg_control_class_type);
> +			"fs", &uvcg_control_class_type);
>  	config_group_init_type_name(&uvcg_control_class_ss.group,
> -				    "ss",
> -				    &uvcg_control_class_type);
> -	uvcg_init_group(&uvcg_control_class_grp.group,
> -			uvcg_control_class_default_groups,
> +			"ss", &uvcg_control_class_type);
> +	config_group_init_type_name(&uvcg_control_class_grp.group,
>  			"class",
>  			&uvcg_control_class_grp_type);
> -	uvcg_init_group(&uvcg_control_grp.group,
> -			uvcg_control_default_groups,
> +	configfs_add_default_group(&uvcg_control_class_fs.group,
> +			&uvcg_control_class_grp.group);
> +	configfs_add_default_group(&uvcg_control_class_ss.group,
> +			&uvcg_control_class_grp.group);
> +
> +	config_group_init_type_name(&uvcg_control_grp.group,
>  			"control",
>  			&uvcg_control_grp_type);
> +	configfs_add_default_group(&uvcg_control_header_grp.group,
> +			&uvcg_control_grp.group);
> +	configfs_add_default_group(&uvcg_processing_grp.group,
> +			&uvcg_control_grp.group);
> +	configfs_add_default_group(&uvcg_terminal_grp.group,
> +			&uvcg_control_grp.group);
> +	configfs_add_default_group(&uvcg_control_class_grp.group,
> +			&uvcg_control_grp.group);
> +
>  	config_group_init_type_name(&uvcg_streaming_header_grp.group,
>  				    "header",
>  				    &uvcg_streaming_header_grp_type);
> @@ -2338,30 +2281,47 @@ int uvcg_attach_configfs(struct f_uvc_opts *opts)
>  	config_group_init_type_name(&uvcg_default_color_matching.group,
>  				    "default",
>  				    &uvcg_default_color_matching_type);
> -	uvcg_init_group(&uvcg_color_matching_grp.group,
> -			uvcg_color_matching_default_groups,
> +	config_group_init_type_name(&uvcg_color_matching_grp.group,
>  			"color_matching",
>  			&uvcg_color_matching_grp_type);
> +	configfs_add_default_group(&uvcg_default_color_matching.group,
> +			&uvcg_color_matching_grp.group);
> +
>  	config_group_init_type_name(&uvcg_streaming_class_fs.group,
> -				    "fs",
> -				    &uvcg_streaming_class_type);
> +			"fs", &uvcg_streaming_class_type);
>  	config_group_init_type_name(&uvcg_streaming_class_hs.group,
> -				    "hs",
> -				    &uvcg_streaming_class_type);
> +			"hs", &uvcg_streaming_class_type);
>  	config_group_init_type_name(&uvcg_streaming_class_ss.group,
> -				    "ss",
> -				    &uvcg_streaming_class_type);
> -	uvcg_init_group(&uvcg_streaming_class_grp.group,
> -			uvcg_streaming_class_default_groups,
> -			"class",
> -			&uvcg_streaming_class_grp_type);
> -	uvcg_init_group(&uvcg_streaming_grp.group,
> -			uvcg_streaming_default_groups,
> -			"streaming",
> -			&uvcg_streaming_grp_type);
> -	uvcg_init_group(&opts->func_inst.group,
> -			uvcg_default_groups,
> +			"ss", &uvcg_streaming_class_type);
> +	config_group_init_type_name(&uvcg_streaming_class_grp.group,
> +			"class", &uvcg_streaming_class_grp_type);
> +	configfs_add_default_group(&uvcg_streaming_class_fs.group,
> +			&uvcg_streaming_class_grp.group);
> +	configfs_add_default_group(&uvcg_streaming_class_hs.group,
> +			&uvcg_streaming_class_grp.group);
> +	configfs_add_default_group(&uvcg_streaming_class_ss.group,
> +			&uvcg_streaming_class_grp.group);
> +
> +	config_group_init_type_name(&uvcg_streaming_grp.group,
> +			"streaming", &uvcg_streaming_grp_type);
> +	configfs_add_default_group(&uvcg_streaming_header_grp.group,
> +			&uvcg_streaming_grp.group);
> +	configfs_add_default_group(&uvcg_uncompressed_grp.group,
> +			&uvcg_streaming_grp.group);
> +	configfs_add_default_group(&uvcg_mjpeg_grp.group,
> +			&uvcg_streaming_grp.group);
> +	configfs_add_default_group(&uvcg_color_matching_grp.group,
> +			&uvcg_streaming_grp.group);
> +	configfs_add_default_group(&uvcg_streaming_class_grp.group,
> +			&uvcg_streaming_grp.group);
> +
> +	config_group_init_type_name(&opts->func_inst.group,
>  			"",
>  			&uvc_func_type);
> +	configfs_add_default_group(&uvcg_control_grp.group,
> +			&opts->func_inst.group);
> +	configfs_add_default_group(&uvcg_streaming_grp.group,
> +			&opts->func_inst.group);
> +
>  	return 0;
>  }
> diff --git a/fs/configfs/dir.c b/fs/configfs/dir.c
> index f419519..b51ce67 100644
> --- a/fs/configfs/dir.c
> +++ b/fs/configfs/dir.c
> @@ -701,23 +701,29 @@ static int populate_groups(struct config_group *group)
>  {
>  	struct config_group *new_group;
>  	int ret = 0;
> -	int i;
> -
> -	if (group->default_groups) {
> -		for (i = 0; group->default_groups[i]; i++) {
> -			new_group = group->default_groups[i];
>  
> -			ret = create_default_group(group, new_group);
> -			if (ret) {
> -				detach_groups(group);
> -				break;
> -			}
> +	list_for_each_entry(new_group, &group->default_groups, group_entry) {
> +		ret = create_default_group(group, new_group);
> +		if (ret) {
> +			detach_groups(group);
> +			break;
>  		}
>  	}
>  
>  	return ret;
>  }
>  
> +void configfs_remove_default_groups(struct config_group *group)
> +{
> +	struct config_group *g, *n;
> +
> +	list_for_each_entry_safe(g, n, &group->default_groups, group_entry) {
> +		list_del(&g->group_entry);
> +		config_item_put(&g->cg_item);
> +	}
> +}
> +EXPORT_SYMBOL(configfs_remove_default_groups);
> +
>  /*
>   * All of link_obj/unlink_obj/link_group/unlink_group require that
>   * subsys->su_mutex is held.
> @@ -766,15 +772,10 @@ static void link_obj(struct config_item *parent_item, struct config_item *item)
>  
>  static void unlink_group(struct config_group *group)
>  {
> -	int i;
>  	struct config_group *new_group;
>  
> -	if (group->default_groups) {
> -		for (i = 0; group->default_groups[i]; i++) {
> -			new_group = group->default_groups[i];
> -			unlink_group(new_group);
> -		}
> -	}
> +	list_for_each_entry(new_group, &group->default_groups, group_entry)
> +		unlink_group(new_group);
>  
>  	group->cg_subsys = NULL;
>  	unlink_obj(&group->cg_item);
> @@ -782,7 +783,6 @@ static void unlink_group(struct config_group *group)
>  
>  static void link_group(struct config_group *parent_group, struct config_group *group)
>  {
> -	int i;
>  	struct config_group *new_group;
>  	struct configfs_subsystem *subsys = NULL; /* gcc is a turd */
>  
> @@ -796,12 +796,8 @@ static void link_group(struct config_group *parent_group, struct config_group *g
>  		BUG();
>  	group->cg_subsys = subsys;
>  
> -	if (group->default_groups) {
> -		for (i = 0; group->default_groups[i]; i++) {
> -			new_group = group->default_groups[i];
> -			link_group(group, new_group);
> -		}
> -	}
> +	list_for_each_entry(new_group, &group->default_groups, group_entry)
> +		link_group(group, new_group);
>  }
>  
>  /*
> diff --git a/fs/configfs/item.c b/fs/configfs/item.c
> index b863a09..8b2a994 100644
> --- a/fs/configfs/item.c
> +++ b/fs/configfs/item.c
> @@ -182,6 +182,7 @@ void config_group_init(struct config_group *group)
>  {
>  	config_item_init(&group->cg_item);
>  	INIT_LIST_HEAD(&group->cg_children);
> +	INIT_LIST_HEAD(&group->default_groups);
>  }
>  EXPORT_SYMBOL(config_group_init);
>  
> diff --git a/fs/dlm/config.c b/fs/dlm/config.c
> index 8e294fb..5191121 100644
> --- a/fs/dlm/config.c
> +++ b/fs/dlm/config.c
> @@ -346,7 +346,6 @@ static struct config_group *make_cluster(struct config_group *g,
>  	void *gps = NULL;
>  
>  	cl = kzalloc(sizeof(struct dlm_cluster), GFP_NOFS);
> -	gps = kcalloc(3, sizeof(struct config_group *), GFP_NOFS);
>  	sps = kzalloc(sizeof(struct dlm_spaces), GFP_NOFS);
>  	cms = kzalloc(sizeof(struct dlm_comms), GFP_NOFS);
>  
> @@ -357,10 +356,8 @@ static struct config_group *make_cluster(struct config_group *g,
>  	config_group_init_type_name(&sps->ss_group, "spaces", &spaces_type);
>  	config_group_init_type_name(&cms->cs_group, "comms", &comms_type);
>  
> -	cl->group.default_groups = gps;
> -	cl->group.default_groups[0] = &sps->ss_group;
> -	cl->group.default_groups[1] = &cms->cs_group;
> -	cl->group.default_groups[2] = NULL;
> +	configfs_add_default_group(&sps->ss_group, &cl->group);
> +	configfs_add_default_group(&cms->cs_group, &cl->group);
>  
>  	cl->cl_tcp_port = dlm_config.ci_tcp_port;
>  	cl->cl_buffer_size = dlm_config.ci_buffer_size;
> @@ -383,7 +380,6 @@ static struct config_group *make_cluster(struct config_group *g,
>  
>   fail:
>  	kfree(cl);
> -	kfree(gps);
>  	kfree(sps);
>  	kfree(cms);
>  	return ERR_PTR(-ENOMEM);
> @@ -392,14 +388,8 @@ static struct config_group *make_cluster(struct config_group *g,
>  static void drop_cluster(struct config_group *g, struct config_item *i)
>  {
>  	struct dlm_cluster *cl = config_item_to_cluster(i);
> -	struct config_item *tmp;
> -	int j;
>  
> -	for (j = 0; cl->group.default_groups[j]; j++) {
> -		tmp = &cl->group.default_groups[j]->cg_item;
> -		cl->group.default_groups[j] = NULL;
> -		config_item_put(tmp);
> -	}
> +	configfs_remove_default_groups(&cl->group);
>  
>  	space_list = NULL;
>  	comm_list = NULL;
> @@ -410,7 +400,6 @@ static void drop_cluster(struct config_group *g, struct config_item *i)
>  static void release_cluster(struct config_item *i)
>  {
>  	struct dlm_cluster *cl = config_item_to_cluster(i);
> -	kfree(cl->group.default_groups);
>  	kfree(cl);
>  }
>  
> @@ -418,21 +407,17 @@ static struct config_group *make_space(struct config_group *g, const char *name)
>  {
>  	struct dlm_space *sp = NULL;
>  	struct dlm_nodes *nds = NULL;
> -	void *gps = NULL;
>  
>  	sp = kzalloc(sizeof(struct dlm_space), GFP_NOFS);
> -	gps = kcalloc(2, sizeof(struct config_group *), GFP_NOFS);
>  	nds = kzalloc(sizeof(struct dlm_nodes), GFP_NOFS);
>  
> -	if (!sp || !gps || !nds)
> +	if (!sp || !nds)
>  		goto fail;
>  
>  	config_group_init_type_name(&sp->group, name, &space_type);
> -	config_group_init_type_name(&nds->ns_group, "nodes", &nodes_type);
>  
> -	sp->group.default_groups = gps;
> -	sp->group.default_groups[0] = &nds->ns_group;
> -	sp->group.default_groups[1] = NULL;
> +	config_group_init_type_name(&nds->ns_group, "nodes", &nodes_type);
> +	configfs_add_default_group(&nds->ns_group, &sp->group);
>  
>  	INIT_LIST_HEAD(&sp->members);
>  	mutex_init(&sp->members_lock);
> @@ -441,7 +426,6 @@ static struct config_group *make_space(struct config_group *g, const char *name)
>  
>   fail:
>  	kfree(sp);
> -	kfree(gps);
>  	kfree(nds);
>  	return ERR_PTR(-ENOMEM);
>  }
> @@ -449,24 +433,16 @@ static struct config_group *make_space(struct config_group *g, const char *name)
>  static void drop_space(struct config_group *g, struct config_item *i)
>  {
>  	struct dlm_space *sp = config_item_to_space(i);
> -	struct config_item *tmp;
> -	int j;
>  
>  	/* assert list_empty(&sp->members) */
>  
> -	for (j = 0; sp->group.default_groups[j]; j++) {
> -		tmp = &sp->group.default_groups[j]->cg_item;
> -		sp->group.default_groups[j] = NULL;
> -		config_item_put(tmp);
> -	}
> -
> +	configfs_remove_default_groups(&sp->group);
>  	config_item_put(i);
>  }
>  
>  static void release_space(struct config_item *i)
>  {
>  	struct dlm_space *sp = config_item_to_space(i);
> -	kfree(sp->group.default_groups);
>  	kfree(sp);
>  }
>  
> diff --git a/fs/ocfs2/cluster/nodemanager.c b/fs/ocfs2/cluster/nodemanager.c
> index ebe5438..b17d180 100644
> --- a/fs/ocfs2/cluster/nodemanager.c
> +++ b/fs/ocfs2/cluster/nodemanager.c
> @@ -630,7 +630,6 @@ static void o2nm_cluster_release(struct config_item *item)
>  {
>  	struct o2nm_cluster *cluster = to_o2nm_cluster(item);
>  
> -	kfree(cluster->cl_group.default_groups);
>  	kfree(cluster);
>  }
>  
> @@ -666,7 +665,6 @@ static struct config_group *o2nm_cluster_group_make_group(struct config_group *g
>  	struct o2nm_cluster *cluster = NULL;
>  	struct o2nm_node_group *ns = NULL;
>  	struct config_group *o2hb_group = NULL, *ret = NULL;
> -	void *defs = NULL;
>  
>  	/* this runs under the parent dir's i_mutex; there can be only
>  	 * one caller in here at a time */
> @@ -675,20 +673,18 @@ static struct config_group *o2nm_cluster_group_make_group(struct config_group *g
>  
>  	cluster = kzalloc(sizeof(struct o2nm_cluster), GFP_KERNEL);
>  	ns = kzalloc(sizeof(struct o2nm_node_group), GFP_KERNEL);
> -	defs = kcalloc(3, sizeof(struct config_group *), GFP_KERNEL);
>  	o2hb_group = o2hb_alloc_hb_set();
> -	if (cluster == NULL || ns == NULL || o2hb_group == NULL || defs == NULL)
> +	if (cluster == NULL || ns == NULL || o2hb_group == NULL)
>  		goto out;
>  
>  	config_group_init_type_name(&cluster->cl_group, name,
>  				    &o2nm_cluster_type);
> +	configfs_add_default_group(&ns->ns_group, &cluster->cl_group);
> +
>  	config_group_init_type_name(&ns->ns_group, "node",
>  				    &o2nm_node_group_type);
> +	configfs_add_default_group(o2hb_group, &cluster->cl_group);
>  
> -	cluster->cl_group.default_groups = defs;
> -	cluster->cl_group.default_groups[0] = &ns->ns_group;
> -	cluster->cl_group.default_groups[1] = o2hb_group;
> -	cluster->cl_group.default_groups[2] = NULL;
>  	rwlock_init(&cluster->cl_nodes_lock);
>  	cluster->cl_node_ip_tree = RB_ROOT;
>  	cluster->cl_reconnect_delay_ms = O2NET_RECONNECT_DELAY_MS_DEFAULT;
> @@ -704,7 +700,6 @@ out:
>  		kfree(cluster);
>  		kfree(ns);
>  		o2hb_free_hb_set(o2hb_group);
> -		kfree(defs);
>  		ret = ERR_PTR(-ENOMEM);
>  	}
>  
> @@ -714,18 +709,11 @@ out:
>  static void o2nm_cluster_group_drop_item(struct config_group *group, struct config_item *item)
>  {
>  	struct o2nm_cluster *cluster = to_o2nm_cluster(item);
> -	int i;
> -	struct config_item *killme;
>  
>  	BUG_ON(o2nm_single_cluster != cluster);
>  	o2nm_single_cluster = NULL;
>  
> -	for (i = 0; cluster->cl_group.default_groups[i]; i++) {
> -		killme = &cluster->cl_group.default_groups[i]->cg_item;
> -		cluster->cl_group.default_groups[i] = NULL;
> -		config_item_put(killme);
> -	}
> -
> +	configfs_remove_default_groups(&cluster->cl_group);
>  	config_item_put(item);
>  }
>  
> diff --git a/include/linux/configfs.h b/include/linux/configfs.h
> index f8165c1..485fe55 100644
> --- a/include/linux/configfs.h
> +++ b/include/linux/configfs.h
> @@ -96,7 +96,8 @@ struct config_group {
>  	struct config_item		cg_item;
>  	struct list_head		cg_children;
>  	struct configfs_subsystem 	*cg_subsys;
> -	struct config_group		**default_groups;
> +	struct list_head		default_groups;
> +	struct list_head		group_entry;
>  };
>  
>  extern void config_group_init(struct config_group *group);
> @@ -123,6 +124,12 @@ extern struct config_item *config_group_find_item(struct config_group *,
>  						  const char *);
>  
>  
> +static inline void configfs_add_default_group(struct config_group *new_group,
> +		struct config_group *group)
> +{
> +	list_add_tail(&new_group->group_entry, &group->default_groups);
> +}
> +
>  struct configfs_attribute {
>  	const char		*ca_name;
>  	struct module 		*ca_owner;
> @@ -251,6 +258,8 @@ int configfs_register_group(struct config_group *parent_group,
>  			    struct config_group *group);
>  void configfs_unregister_group(struct config_group *group);
>  
> +void configfs_remove_default_groups(struct config_group *group);
> +
>  struct config_group *
>  configfs_register_default_group(struct config_group *parent_group,
>  				const char *name,
> diff --git a/include/target/target_core_base.h b/include/target/target_core_base.h
> index e8c8c08..1b09cac 100644
> --- a/include/target/target_core_base.h
> +++ b/include/target/target_core_base.h
> @@ -560,7 +560,6 @@ struct se_node_acl {
>  	struct config_group	acl_auth_group;
>  	struct config_group	acl_param_group;
>  	struct config_group	acl_fabric_stat_group;
> -	struct config_group	*acl_default_groups[5];
>  	struct list_head	acl_list;
>  	struct list_head	acl_sess_list;
>  	struct completion	acl_free_comp;
> @@ -887,7 +886,6 @@ struct se_portal_group {
>  	const struct target_core_fabric_ops *se_tpg_tfo;
>  	struct se_wwn		*se_tpg_wwn;
>  	struct config_group	tpg_group;
> -	struct config_group	*tpg_default_groups[7];
>  	struct config_group	tpg_lun_group;
>  	struct config_group	tpg_np_group;
>  	struct config_group	tpg_acl_group;
> @@ -923,7 +921,6 @@ static inline struct se_portal_group *param_to_tpg(struct config_item *item)
>  struct se_wwn {
>  	struct target_fabric_configfs *wwn_tf;
>  	struct config_group	wwn_group;
> -	struct config_group	*wwn_default_groups[2];
>  	struct config_group	fabric_stat_group;
>  };
>  
> -- 
> 2.1.4
> 

-- 

 The zen have a saying:
 "When you learn how to listen, ANYONE can be your teacher."

			http://www.jlbec.org/
			jlbec at evilplan.org
