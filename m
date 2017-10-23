From: Joseph Qi <jiangqi903@gmail.com>
Date: Mon, 23 Oct 2017 10:59:08 +0800
Subject: [Ocfs2-devel] [PATCH] ocfs2: subsystem.su_mutex is required
 while accessing the item->ci_parent
In-Reply-To: <59E9B36A.10700@huawei.com>
References: <59E8A6FA.4000902@huawei.com> <59E9B36A.10700@huawei.com>
Message-ID: <e8db29df-ec9c-9ac2-bf7a-1ecf784148fc@gmail.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi Alex,

On 17/10/20 16:27, alex chen wrote:
> The subsystem.su_mutex is required while accessing the item->ci_parent,
> otherwise, NULL pointer dereference to the item->ci_parent will be
> triggered in the following situation:
> add node                     delete node
> sys_write
>  vfs_write
>   configfs_write_file
>    o2nm_node_store
>     o2nm_node_local_write
>                              do_rmdir
>                               vfs_rmdir
>                                configfs_rmdir
>                                 mutex_lock(&subsys->su_mutex);
>                                 unlink_obj
>                                  item->ci_group = NULL;
>                                  item->ci_parent = NULL;			
> 	 to_o2nm_cluster_from_node
> 	  node->nd_item.ci_parent->ci_parent
> 	  BUG since of NULL pointer dereference to nd_item.ci_parent
> 
> Moreover, the o2nm_cluster also should be protected by the subsystem.su_mutex.
> 
Looks good to me. One suggestion is, we'd better add some blank lines
for code readability.

> Signed-off-by: Alex Chen <alex.chen@huawei.com>
> Reviewed-by: Jun Piao <piaojun@huawei.com>
> 
> ---
>  fs/ocfs2/cluster/nodemanager.c | 58 ++++++++++++++++++++++++++++++++++--------
>  1 file changed, 48 insertions(+), 10 deletions(-)
> 
> diff --git a/fs/ocfs2/cluster/nodemanager.c b/fs/ocfs2/cluster/nodemanager.c
> index b17d180..9b1859a 100644
> --- a/fs/ocfs2/cluster/nodemanager.c
> +++ b/fs/ocfs2/cluster/nodemanager.c
> @@ -39,6 +39,8 @@
>  		"reset",	/* O2NM_FENCE_RESET */
>  		"panic",	/* O2NM_FENCE_PANIC */
>  };
> +static inline void o2nm_lock_subsystem(void);
> +static inline void o2nm_unlock_subsystem(void);
> 
>  struct o2nm_node *o2nm_get_node_by_num(u8 node_num)
>  {
> @@ -181,7 +183,10 @@ static struct o2nm_cluster *to_o2nm_cluster_from_node(struct o2nm_node *node)
>  {
>  	/* through the first node_set .parent
>  	 * mycluster/nodes/mynode == o2nm_cluster->o2nm_node_group->o2nm_node */
> -	return to_o2nm_cluster(node->nd_item.ci_parent->ci_parent);
> +	if (node->nd_item.ci_parent)
> +		return to_o2nm_cluster(node->nd_item.ci_parent->ci_parent);
> +	else
> +		return NULL;
>  }
> 
>  enum {
> @@ -194,7 +199,7 @@ static ssize_t o2nm_node_num_store(struct config_item *item, const char *page,
>  				   size_t count)
>  {
>  	struct o2nm_node *node = to_o2nm_node(item);
> -	struct o2nm_cluster *cluster = to_o2nm_cluster_from_node(node);
> +	struct o2nm_cluster *cluster;
>  	unsigned long tmp;
>  	char *p = (char *)page;
>  	int ret = 0;
> @@ -213,6 +218,12 @@ static ssize_t o2nm_node_num_store(struct config_item *item, const char *page,
>  	if (!test_bit(O2NM_NODE_ATTR_ADDRESS, &node->nd_set_attributes) ||
>  	    !test_bit(O2NM_NODE_ATTR_PORT, &node->nd_set_attributes))
>  		return -EINVAL; /* XXX */
<<< A blank line here may be better.

> +	o2nm_lock_subsystem();
> +	cluster = to_o2nm_cluster_from_node(node);
> +	if (!cluster) {
> +		o2nm_unlock_subsystem();
> +		return -EINVAL;
> +	}
> 
>  	write_lock(&cluster->cl_nodes_lock);
>  	if (cluster->cl_nodes[tmp])
> @@ -226,6 +237,7 @@ static ssize_t o2nm_node_num_store(struct config_item *item, const char *page,
>  		set_bit(tmp, cluster->cl_nodes_bitmap);
>  	}
>  	write_unlock(&cluster->cl_nodes_lock);
> +	o2nm_unlock_subsystem();
>  	if (ret)
>  		return ret;
> 
> @@ -269,7 +281,7 @@ static ssize_t o2nm_node_ipv4_address_store(struct config_item *item,
>  					    size_t count)
>  {
>  	struct o2nm_node *node = to_o2nm_node(item);
> -	struct o2nm_cluster *cluster = to_o2nm_cluster_from_node(node);
> +	struct o2nm_cluster *cluster;
>  	int ret, i;
>  	struct rb_node **p, *parent;
>  	unsigned int octets[4];
> @@ -285,7 +297,12 @@ static ssize_t o2nm_node_ipv4_address_store(struct config_item *item,
>  			return -ERANGE;
>  		be32_add_cpu(&ipv4_addr, octets[i] << (i * 8));
>  	}
> -
<<< Also here.

> +	o2nm_lock_subsystem();
> +	cluster = to_o2nm_cluster_from_node(node);
> +	if (!cluster) {
> +		o2nm_unlock_subsystem();
> +		return -EINVAL;
> +	}
>  	ret = 0;
>  	write_lock(&cluster->cl_nodes_lock);
>  	if (o2nm_node_ip_tree_lookup(cluster, ipv4_addr, &p, &parent))
> @@ -298,6 +315,7 @@ static ssize_t o2nm_node_ipv4_address_store(struct config_item *item,
>  		rb_insert_color(&node->nd_ip_node, &cluster->cl_node_ip_tree);
>  	}
>  	write_unlock(&cluster->cl_nodes_lock);
> +	o2nm_unlock_subsystem();
>  	if (ret)
>  		return ret;
> 
> @@ -315,7 +333,7 @@ static ssize_t o2nm_node_local_store(struct config_item *item, const char *page,
>  				     size_t count)
>  {
>  	struct o2nm_node *node = to_o2nm_node(item);
> -	struct o2nm_cluster *cluster = to_o2nm_cluster_from_node(node);
> +	struct o2nm_cluster *cluster;
>  	unsigned long tmp;
>  	char *p = (char *)page;
>  	ssize_t ret;
> @@ -333,17 +351,24 @@ static ssize_t o2nm_node_local_store(struct config_item *item, const char *page,
>  	    !test_bit(O2NM_NODE_ATTR_PORT, &node->nd_set_attributes))
>  		return -EINVAL; /* XXX */
> 
> +	o2nm_lock_subsystem();
> +	cluster = to_o2nm_cluster_from_node(node);
> +	if (!cluster) {
> +		ret = -EINVAL;
> +		goto out;
> +	}
<<< Also here.

>  	/* the only failure case is trying to set a new local node
>  	 * when a different one is already set */
>  	if (tmp && tmp == cluster->cl_has_local &&
> -	    cluster->cl_local_node != node->nd_num)
> -		return -EBUSY;
> -
> +	    cluster->cl_local_node != node->nd_num) {
> +		ret = -EBUSY;
> +		goto out;
> +	}
<<< Also here.

>  	/* bring up the rx thread if we're setting the new local node. */
>  	if (tmp && !cluster->cl_has_local) {
>  		ret = o2net_start_listening(node);
>  		if (ret)
> -			return ret;
> +			goto out;
>  	}
> 
>  	if (!tmp && cluster->cl_has_local &&
> @@ -357,8 +382,11 @@ static ssize_t o2nm_node_local_store(struct config_item *item, const char *page,
>  		cluster->cl_has_local = tmp;
>  		cluster->cl_local_node = node->nd_num;
>  	}
> +	ret = count;
> 
> -	return count;
> +out:
> +	o2nm_unlock_subsystem();
> +	return ret;
>  }
> 
>  CONFIGFS_ATTR(o2nm_node_, num);
> @@ -738,6 +766,16 @@ static void o2nm_cluster_group_drop_item(struct config_group *group, struct conf
>  	},
>  };
> 
> +static inline void o2nm_lock_subsystem(void)
> +{
> +	mutex_lock(&o2nm_cluster_group.cs_subsys.su_mutex);
> +}
> +
> +static inline void o2nm_unlock_subsystem(void)
> +{
> +	mutex_unlock(&o2nm_cluster_group.cs_subsys.su_mutex);
> +}
> +
>  int o2nm_depend_item(struct config_item *item)
>  {
>  	return configfs_depend_item(&o2nm_cluster_group.cs_subsys, item);
> 
