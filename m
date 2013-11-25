From: Mark Fasheh <mfasheh@suse.de>
Date: Mon, 25 Nov 2013 15:21:32 -0800
Subject: [Ocfs2-devel] [PATCH 4/6] Pass ocfs2_cluster_connection
	to	ocfs2_this_node
In-Reply-To: <20131112140722.GA3946@shrek.lan>
References: <20131112140722.GA3946@shrek.lan>
Message-ID: <20131125232132.GA29346@wotan.suse.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

I reviewed and ack'd this one last time so you can leave:

Reviewed-by: Mark Fasheh <mfasheh@suse.de>

With the patch next time you post it.
	--Mark

On Tue, Nov 12, 2013 at 08:07:27AM -0600, Goldwyn Rodrigues wrote:
> This is done to differentiate between using and not using controld
> and use the connection information accordingly.
> We need to be backward compatible. So, we use a new enum
> ocfs2_connection_type to identify when controld is used and when
> it is not.
> 
> Signed-off-by: Goldwyn Rodrigues <rgoldwyn@suse.com>
> ---
>  fs/ocfs2/dlmglue.c    |  2 +-
>  fs/ocfs2/stack_o2cb.c |  3 ++-
>  fs/ocfs2/stack_user.c | 16 ++++++++++++++--
>  fs/ocfs2/stackglue.c  |  5 +++--
>  fs/ocfs2/stackglue.h  |  6 ++++--
>  5 files changed, 24 insertions(+), 8 deletions(-)
> 
> diff --git a/fs/ocfs2/dlmglue.c b/fs/ocfs2/dlmglue.c
> index 7c57de3..f2d48c8 100644
> --- a/fs/ocfs2/dlmglue.c
> +++ b/fs/ocfs2/dlmglue.c
> @@ -3007,7 +3007,7 @@ int ocfs2_dlm_init(struct ocfs2_super *osb)
>  		goto bail;
>  	}
>  
> -	status = ocfs2_cluster_this_node(&osb->node_num);
> +	status = ocfs2_cluster_this_node(conn, &osb->node_num);
>  	if (status < 0) {
>  		mlog_errno(status);
>  		mlog(ML_ERROR,
> diff --git a/fs/ocfs2/stack_o2cb.c b/fs/ocfs2/stack_o2cb.c
> index bf1f893..1724d43 100644
> --- a/fs/ocfs2/stack_o2cb.c
> +++ b/fs/ocfs2/stack_o2cb.c
> @@ -398,7 +398,8 @@ static int o2cb_cluster_disconnect(struct ocfs2_cluster_connection *conn)
>  	return 0;
>  }
>  
> -static int o2cb_cluster_this_node(unsigned int *node)
> +static int o2cb_cluster_this_node(struct ocfs2_cluster_connection *conn,
> +				  unsigned int *node)
>  {
>  	int node_num;
>  
> diff --git a/fs/ocfs2/stack_user.c b/fs/ocfs2/stack_user.c
> index 0afb86d..22b95ac 100644
> --- a/fs/ocfs2/stack_user.c
> +++ b/fs/ocfs2/stack_user.c
> @@ -103,6 +103,11 @@
>  #define OCFS2_CONTROL_MESSAGE_VERNUM_LEN	2
>  #define OCFS2_CONTROL_MESSAGE_NODENUM_LEN	8
>  
> +enum ocfs2_connection_type {
> +	WITH_CONTROLD,
> +	NO_CONTROLD
> +};
> +
>  /*
>   * ocfs2_live_connection is refcounted because the filesystem and
>   * miscdevice sides can detach in different order.  Let's just be safe.
> @@ -110,6 +115,7 @@
>  struct ocfs2_live_connection {
>  	struct list_head		oc_list;
>  	struct ocfs2_cluster_connection	*oc_conn;
> +	enum ocfs2_connection_type	oc_type;
>  	atomic_t                        oc_this_node;
>  	int                             oc_our_slot;
>  };
> @@ -840,6 +846,7 @@ static int user_cluster_connect(struct ocfs2_cluster_connection *conn)
>  		goto out;
>  	}
>  
> +	lc->oc_type = WITH_CONTROLD;
>  	rc = ocfs2_live_connection_attach(conn, lc);
>  	if (rc)
>  		goto out;
> @@ -886,11 +893,16 @@ static int user_cluster_disconnect(struct ocfs2_cluster_connection *conn)
>  	return 0;
>  }
>  
> -static int user_cluster_this_node(unsigned int *this_node)
> +static int user_cluster_this_node(struct ocfs2_cluster_connection *conn,
> +				  unsigned int *this_node)
>  {
>  	int rc;
> +	struct ocfs2_live_connection *lc = conn->cc_private;
>  
> -	rc = ocfs2_control_get_this_node();
> +	if (lc->oc_type == WITH_CONTROLD)
> +		rc = ocfs2_control_get_this_node();
> +	else
> +		rc = -EINVAL;
>  	if (rc < 0)
>  		return rc;
>  
> diff --git a/fs/ocfs2/stackglue.c b/fs/ocfs2/stackglue.c
> index 58b53f9..ffece04 100644
> --- a/fs/ocfs2/stackglue.c
> +++ b/fs/ocfs2/stackglue.c
> @@ -465,9 +465,10 @@ void ocfs2_cluster_hangup(const char *group, int grouplen)
>  }
>  EXPORT_SYMBOL_GPL(ocfs2_cluster_hangup);
>  
> -int ocfs2_cluster_this_node(unsigned int *node)
> +int ocfs2_cluster_this_node(struct ocfs2_cluster_connection *conn,
> +			    unsigned int *node)
>  {
> -	return active_stack->sp_ops->this_node(node);
> +	return active_stack->sp_ops->this_node(conn, node);
>  }
>  EXPORT_SYMBOL_GPL(ocfs2_cluster_this_node);
>  
> diff --git a/fs/ocfs2/stackglue.h b/fs/ocfs2/stackglue.h
> index b46fd51..d7bc4d0 100644
> --- a/fs/ocfs2/stackglue.h
> +++ b/fs/ocfs2/stackglue.h
> @@ -157,7 +157,8 @@ struct ocfs2_stack_operations {
>  	 * ->this_node() returns the cluster's unique identifier for the
>  	 * local node.
>  	 */
> -	int (*this_node)(unsigned int *node);
> +	int (*this_node)(struct ocfs2_cluster_connection *conn,
> +			 unsigned int *node);
>  
>  	/*
>  	 * Call the underlying dlm lock function.  The ->dlm_lock()
> @@ -267,7 +268,8 @@ int ocfs2_cluster_connect_agnostic(const char *group,
>  int ocfs2_cluster_disconnect(struct ocfs2_cluster_connection *conn,
>  			     int hangup_pending);
>  void ocfs2_cluster_hangup(const char *group, int grouplen);
> -int ocfs2_cluster_this_node(unsigned int *node);
> +int ocfs2_cluster_this_node(struct ocfs2_cluster_connection *conn,
> +			    unsigned int *node);
>  
>  struct ocfs2_lock_res;
>  int ocfs2_dlm_lock(struct ocfs2_cluster_connection *conn,
> -- 
> 1.8.1.4
> 
> 
> -- 
> Goldwyn
> 
> _______________________________________________
> Ocfs2-devel mailing list
> Ocfs2-devel at oss.oracle.com
> https://oss.oracle.com/mailman/listinfo/ocfs2-devel
--
Mark Fasheh
