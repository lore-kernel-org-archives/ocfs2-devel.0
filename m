From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Fri, 30 Jul 2010 10:27:48 -0700
Subject: [Ocfs2-devel] [PATCH 1/1] O2net: Disallow o2net accept
 connection request from itself.
In-Reply-To: <1280478317-11374-1-git-send-email-tristan.ye@oracle.com>
References: <1280478317-11374-1-git-send-email-tristan.ye@oracle.com>
Message-ID: <4C530B94.8030802@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

You can tighten it a little more. You can add my Acked-by
to the next patch.

On 07/30/2010 01:25 AM, Tristan Ye wrote:
> Currently, o2net_accept_one() is allowed to accept a connection from
> listening node itself, such a fake connection will not be successfully
> established due to no handshake detected afterwards, and later end up
> with triggering connecting worker in a loop.
>
> We're going to fix this by treating such connection request as 'invalid',
> since we've got no chance of requesting connection from a node to itself
> in a OCFS2 cluster.
>
> The fix doesn't hurt user's scan for o2net-listener, it always gets a
> successful connection from userpace.
>
> Signed-off-by: Tristan Ye<tristan.ye@oracle.com>
> ---
>   fs/ocfs2/cluster/tcp.c |   16 +++++++++++-----
>   1 files changed, 11 insertions(+), 5 deletions(-)
>
> diff --git a/fs/ocfs2/cluster/tcp.c b/fs/ocfs2/cluster/tcp.c
> index aa75ca3..7a17e91 100644
> --- a/fs/ocfs2/cluster/tcp.c
> +++ b/fs/ocfs2/cluster/tcp.c
> @@ -1759,6 +1759,7 @@ static int o2net_accept_one(struct socket *sock)
>   	struct sockaddr_in sin;
>   	struct socket *new_sock = NULL;
>   	struct o2nm_node *node = NULL;
> +	struct o2nm_node *local_node = o2nm_get_node_by_num(o2nm_this_node());
>    
+	struct o2nm_node *local_node = NULL;


>   	struct o2net_sock_container *sc = NULL;
>   	struct o2net_node *nn;
>
> @@ -1796,11 +1797,14 @@ static int o2net_accept_one(struct socket *sock)
>   		goto out;
>   	}
>
> -	if (o2nm_this_node()>  node->nd_num) {
> -		mlog(ML_NOTICE, "unexpected connect attempted from a lower "
> -		     "numbered node '%s' at " "%pI4:%d with num %u\n",
> -		     node->nd_name,&sin.sin_addr.s_addr,
> -		     ntohs(sin.sin_port), node->nd_num);
> +	if (o2nm_this_node()>= node->nd_num) {
>    

+		   local_node = o2nm_get_node_by_num(o2nm_this_node());


> +		mlog(ML_NOTICE, "unexpected connect attempt seen at node '%s' ("
> +		     "%u, %pI4:%d) from node '%s' (%u, %pI4:%d)\n",
> +		     local_node->nd_name, local_node->nd_num,
> +		&(local_node->nd_ipv4_address),
> +		     ntohs(local_node->nd_ipv4_port),
> +		     node->nd_name, node->nd_num,&sin.sin_addr.s_addr,
> +		     ntohs(sin.sin_port));
>   		ret = -EINVAL;
>   		goto out;
>   	}
> @@ -1857,6 +1861,8 @@ out:
>   		sock_release(new_sock);
>   	if (node)
>   		o2nm_node_put(node);
> +	if (local_node)
> +		o2nm_node_put(local_node);
>   	if (sc)
>   		sc_put(sc);
>   	return ret;
>    
