From: Zach Brown <zach.brown@oracle.com>
Date: Wed Nov 29 15:30:58 2006
Subject: [Ocfs2-devel] [patch 1/1] ocfs2-timeout-protocol.patch
In-Reply-To: <20061129090355.473139000@suse.de>
References: <20061129085130.004252000@suse.de>
	<20061129090355.473139000@suse.de>
Message-ID: <456E1831.6010401@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com


> Only allow changes when there are no connected peers

I think we can do this differently.

>  	if (ret > 0) {
> +		if (cluster->cl_idle_timeout_ms != val) {
> +			spin_lock(&connected_lock);
> +			if(o2net_num_connected_peers()) {
> +				mlog(ML_NOTICE,
> +				     "o2net: cannot change idle timeout after "
> +				     "the first peer has agreed to it."
> +				     "  %d connected peers\n",
> +				     o2net_num_connected_peers());
> +				ret = -EINVAL;
> +			}
> +			spin_unlock(&connected_lock);
> +		}

Lose the locking here so this just becomes (paraphrasing) :

  if (cluster != val && connected()) {
   ...
  }

> +static int o2net_connected_peers = 0;
> +spinlock_t connected_lock;
> +
> +int o2net_num_connected_peers(void)
> +{
> +	return o2net_connected_peers;
> +}

Make this an "atomic_t o2net_connected_peers = ATOMIC_INIT(0);" and then
"return atomic_read();".  We probably don't really need a heavy-weight
atomic_t, but it's trivial and this isn't a fast path.

>  void o2net_disconnect_node(struct o2nm_node *node)
>  {
>  	struct o2net_node *nn = o2net_nn_from_num(node->nd_num);
>  
>  	/* don't reconnect until it's heartbeating again */
> +	spin_lock(&connected_lock);
> +	o2net_connected_peers--;
> +	spin_unlock(&connected_lock);
> +

Then don't do this work here and in other places, do it once in
o2net_set_nn_state().  something like:

if (old_sc != sc) {
	if (old_sc)
		atomic_dec(&o2net_connected_peers);
	else
		atomic_inc(&o2net_connected_peers);
}

That's less confusing and catches the place where sockets are in use by
a node.

- z
