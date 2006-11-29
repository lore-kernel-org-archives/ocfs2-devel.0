From: Mark Fasheh <mark.fasheh@oracle.com>
Date: Wed Nov 29 15:31:50 2006
Subject: [Ocfs2-devel] [patch 1/1] ocfs2-timeout-protocol.patch
In-Reply-To: <20061129090355.473139000@suse.de>
References: <20061129085130.004252000@suse.de>
	<20061129090355.473139000@suse.de>
Message-ID: <20061129233145.GP30647@ca-server1.us.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi Andrew,
	Things are looking much better, but there's still a few issues that
I found while reviewing the patch. I got Zach to look at it too (he's the
original author of the ocfs2 network code) which has generated some good
comments.

On Wed, Nov 29, 2006 at 09:51:31AM +0100, abeekhof@suse.de wrote:
> 
> From: Andrew Beekhof <abeekhof@suse.de>
> Subject: [patch 1/1] OCFS2 Configurable timeouts - Protocol changes
> 
> Modify the OCFS2 handshake to ensure essential timeouts are configured
>   identically on all nodes.
> Only allow changes when there are no connected peers
> Improves the logic in o2net_advance_rx() which broke now that
>   sizeof(struct o2net_handshake) is greater than sizeof(struct o2net_msg)
> Included is the field for userspace-heartbeat timeout to avoid the need for
>   further protocol changes.
> Uses a global spinlock to ensure the decisions to update configfs entries
>   are made on the correct value.  The region covered by the spinlock when
>   incrimenting the counter is much larger as this is the more critical case.
Nitpick: Can you format that commit log to be a bit more in line with
standard kernel commits (the indenting is weird)


> Index: fs/ocfs2/cluster/nodemanager.c
> ===================================================================
> --- fs/ocfs2/cluster/nodemanager.c.orig	2006-11-20 16:25:58.000000000 +0100
> +++ fs/ocfs2/cluster/nodemanager.c	2006-11-27 09:57:56.000000000 +0100
> @@ -558,15 +558,14 @@ static ssize_t o2nm_cluster_attr_write(c
>  	return count;
>  }
>  
> -static ssize_t o2nm_cluster_attr_idle_timeout_ms_read(struct o2nm_cluster *cluster,
> -                                                 char *page)
> +static ssize_t o2nm_cluster_attr_idle_timeout_ms_read(
> +	struct o2nm_cluster *cluster, char *page)
>  {
>  	return sprintf(page, "%u\n", cluster->cl_idle_timeout_ms);
>  }
Can you not re-write the function prototypes unless they're actually
changing please? It clutters up the patch and makes it harder to find the
actual code to check (see below).


> @@ -574,10 +573,22 @@ static ssize_t o2nm_cluster_attr_idle_ti
>  	ret =  o2nm_cluster_attr_write(page, count, &val);
>  
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
>  		if (val <= cluster->cl_keepalive_delay_ms) {
>  			mlog(ML_NOTICE, "o2net: idle timeout must be larger "
>  			     "than keepalive delay\n");
> -			return -EINVAL;
> +			ret = -EINVAL;
>  		}
>  		cluster->cl_idle_timeout_ms = val;
I don't know how I missed this before, but you're erroring with a negative return
value, yet continuing with the work of setting cluster->cl_idle_timeout_ms
anyway. I think we're missing some goto's here and in the similar blocks
below.


> @@ -1121,6 +1121,44 @@ static int o2net_check_handshake(struct 
>  		return -1;
>  	}
>  
> +	/*
> +	 * Ensure timeouts are consistent with other nodes, otherwise
> +	 * we can end up with one node thinking that the other must be down,
> +	 * but isn't. This can ultimately cause corruption.
> +	 */
> +	if (be32_to_cpu(hand->o2net_idle_timeout_ms) !=
> +				o2net_idle_timeout(sc->sc_node)) {
> +		mlog(ML_NOTICE, SC_NODEF_FMT " uses a network idle timeout of "
> +		     "%u ms, but we use %u ms locally.  disconnecting\n",
> +		     SC_NODEF_ARGS(sc),
> +		     be32_to_cpu(hand->o2net_idle_timeout_ms),
> +		     o2net_idle_timeout(sc->sc_node));
> +		o2net_ensure_shutdown(nn, sc, -ENOTCONN);
> +		return -1;
> +	}
> +
> +	if (be32_to_cpu(hand->o2net_keepalive_delay_ms) !=
> +			o2net_keepalive_delay(sc->sc_node)) {
> +		mlog(ML_NOTICE, SC_NODEF_FMT " uses a keepalive delay of "
> +		     "%u ms, but we use %u ms locally.  disconnecting\n",
> +		     SC_NODEF_ARGS(sc),
> +		     be32_to_cpu(hand->o2net_keepalive_delay_ms),
> +		     o2net_keepalive_delay(sc->sc_node));
> +		o2net_ensure_shutdown(nn, sc, -ENOTCONN);
> +		return -1;
> +	}
> +
> +	if (be32_to_cpu(hand->o2hb_heartbeat_timeout_ms) !=
> +			O2HB_MAX_WRITE_TIMEOUT_MS) {
> +		mlog(ML_NOTICE, SC_NODEF_FMT " uses a heartbeat timeout of "
> +		     "%u ms, but we use %u ms locally.  disconnecting\n",
> +		     SC_NODEF_ARGS(sc),
> +		     be32_to_cpu(hand->o2net_keepalive_delay_ms),
We check hearbeat timeout here, but print keepalive delay...


> @@ -1153,6 +1191,26 @@ static int o2net_advance_rx(struct o2net
>  	sclog(sc, "receiving\n");
>  	do_gettimeofday(&sc->sc_tv_advance_start);
>  
> +	if(unlikely(sc->sc_handshake_ok == 0)) {
> +		if(sc->sc_page_off < sizeof(struct o2net_handshake)) {
> +			data = page_address(sc->sc_page) + sc->sc_page_off;
> +			datalen = sizeof(struct o2net_handshake) - sc->sc_page_off;
> +			ret = o2net_recv_tcp_msg(sc->sc_sock, data, datalen);
> +			if (ret > 0)
> +				sc->sc_page_off += ret;
> +		}
> +
> +		if (sc->sc_page_off == sizeof(struct o2net_handshake)) {
> +			o2net_check_handshake(sc);
> +			if(sc->sc_handshake_ok == 0) {
> +				BUG_ON(sizeof(struct o2net_handshake)
> +				       == sizeof(struct o2net_msg));
Is this necessary? Didn't we fix the logic such that the relative sizes
don't matter any more? If it _is_ necessary, then it should be a
BUILD_BUG_ON() in a more visible place, with a nice fat comment explaining
why...


> +				ret = -EPROTO;
> +			}
> +			goto out;
Do you mean to move that goto within the

if (sc->sc_handshake_ok == 0) {

block? I _think_ it's ok for us to continue otherwise...


> @@ -1178,8 +1227,7 @@ static int o2net_advance_rx(struct o2net
>  				    O2NET_MAX_PAYLOAD_BYTES)
>  					ret = -EOVERFLOW;
>  			}
> -		}
> -		if (ret <= 0)
> +		} else
>  			goto out;
>  	}
Why are you doing that? We'll continue now if we want to return -EOVERFLOW
where we would error out before.

Thanks,
	--Mark

--
Mark Fasheh
Senior Software Developer, Oracle
mark.fasheh@oracle.com
