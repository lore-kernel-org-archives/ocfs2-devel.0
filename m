From: tristan <tristan.ye@oracle.com>
Date: Wed, 04 Aug 2010 18:53:09 +0800
Subject: [Ocfs2-devel] [PATCH 1/1] ocfs2-1.4: Disallow o2net accept
	connection.
In-Reply-To: <1280918040-10569-1-git-send-email-tristan.ye@oracle.com>
References: <1280918040-10569-1-git-send-email-tristan.ye@oracle.com>
Message-ID: <4C594695.2030607@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Oops, the subject of patch was incomplete...

Re-send a complete one later.


Tristan Ye wrote:
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
> Signed-off-by: Tristan Ye <tristan.ye@oracle.com>
> Acked-by: Sunil Mushran <sunil.mushran@oracle.com>
> ---
>  fs/ocfs2/cluster/tcp.c |   17 ++++++++++++-----
>  1 files changed, 12 insertions(+), 5 deletions(-)
>
> diff --git a/fs/ocfs2/cluster/tcp.c b/fs/ocfs2/cluster/tcp.c
> index 10a02a4..021e4db 100644
> --- a/fs/ocfs2/cluster/tcp.c
> +++ b/fs/ocfs2/cluster/tcp.c
> @@ -1764,6 +1764,7 @@ static int o2net_accept_one(struct socket *sock)
>  	struct sockaddr_in sin;
>  	struct socket *new_sock = NULL;
>  	struct o2nm_node *node = NULL;
> +	struct o2nm_node *local_node = NULL;
>  	struct o2net_sock_container *sc = NULL;
>  	struct o2net_node *nn;
>  
> @@ -1802,11 +1803,15 @@ static int o2net_accept_one(struct socket *sock)
>  		goto out;
>  	}
>  
> -	if (o2nm_this_node() > node->nd_num) {
> -		mlog(ML_NOTICE, "unexpected connect attempted from a lower "
> -		     "numbered node '%s' at " "%u.%u.%u.%u:%d with num %u\n",
> -		     node->nd_name, NIPQUAD(sin.sin_addr.s_addr),
> -		     ntohs((__force __be16)sin.sin_port), node->nd_num);
> +	if (o2nm_this_node() >= node->nd_num) {
> +		local_node = o2nm_get_node_by_num(o2nm_this_node());
> +		mlog(ML_NOTICE, "unexpected connect attempt seen at node '%s' ("
> +		     "%u,%u.%u.%u.%u:%d) from node '%s' (%u,%u.%u.%u.%u:%d)\n",
> +		     local_node->nd_name, local_node->nd_num,
> +		     NIPQUAD(local_node->nd_ipv4_address),
> +		     ntohs((__force __be16)local_node->nd_ipv4_port),
> +		     node->nd_name, node->nd_num, NIPQUAD(sin.sin_addr.s_addr),
> +		     ntohs((__force __be16)sin.sin_port));
>  		ret = -EINVAL;
>  		goto out;
>  	}
> @@ -1863,6 +1868,8 @@ out:
>  		sock_release(new_sock);
>  	if (node)
>  		o2nm_node_put(node);
> +	if (local_node)
> +		o2nm_node_put(local_node);
>  	if (sc)
>  		sc_put(sc);
>  	return ret;
>   
