From: Mark Fasheh <mark@fasheh.com>
Date: Sat Mar 22 08:36:11 2008
Subject: [Ocfs2-devel] [PATCH] o2nm: Get rid of arguments to the timeout
	routines
In-Reply-To: <47DEB30E.8060605@suse.com>
References: <47DEB30E.8060605@suse.com>
Message-ID: <20080322153551.GG27205@ZenIV.linux.org.uk>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Mon, Mar 17, 2008 at 02:06:06PM -0400, Jeff Mahoney wrote:
> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA1
> 
> 
>  We keep seeing bug reports related to NULL pointer derefs in
>  o2net_set_nn_state(). When I originally wrote up the configurable timeout
>  patch, I had tried to plan for multiple clusters. This was silly.
> 
>  The timeout routines all use o2nm_single_cluster so there's no point
>  in passing an argument at all. This patch removes the arguments and kills
>  those bugs dead.
> 
> Signed-off-by: Jeff Mahoney <jeffm@suse.com>
> - ---
>  fs/ocfs2/cluster/tcp.c |   45 +++++++++++++++++++--------------------------
>  1 file changed, 19 insertions(+), 26 deletions(-)
> 
> - --- a/fs/ocfs2/cluster/tcp.c
> +++ b/fs/ocfs2/cluster/tcp.c
> @@ -149,23 +149,17 @@ static void o2net_idle_timer(unsigned lo
>  static void o2net_sc_postpone_idle(struct o2net_sock_container *sc);
>  static void o2net_sc_reset_idle_timer(struct o2net_sock_container *sc);
>  
> - -/*
> - - * FIXME: These should use to_o2nm_cluster_from_node(), but we end up
> - - * losing our parent link to the cluster during shutdown. This can be
> - - * solved by adding a pre-removal callback to configfs, or passing
> - - * around the cluster with the node. -jeffm
> - - */
> - -static inline int o2net_reconnect_delay(struct o2nm_node *node)
> +static inline int o2net_reconnect_delay(void)
>  {
>  	return o2nm_single_cluster->cl_reconnect_delay_ms;
>  }


That all looks fine, but it seems that the patch is a diff of a diff. Was
that intentional? Neither git nor I have any idea how to handle something like this
:)
	--Mark

-- 
"There's nothing like a cantankerous old man who takes a 'hey you kids, get
off my lawn!' approach to foreign policy" -Jon Stewart on the subject of
Donald Rumsfeld
