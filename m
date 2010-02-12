From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Fri, 12 Feb 2010 15:59:18 -0800
Subject: [Ocfs2-devel] [PATCH 06/11] ocfs2: Hang the locking proto on
 the cluster conn and use it in asts.
In-Reply-To: <1265794074-19539-7-git-send-email-joel.becker@oracle.com>
References: <1265794074-19539-1-git-send-email-joel.becker@oracle.com>
	<1265794074-19539-7-git-send-email-joel.becker@oracle.com>
Message-ID: <4B75EB56.9030708@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Joel Becker <joel.becker@oracle.com>
Cc: ocfs2-devel@oss.oracle.com, mfasheh@suse.com, linux-kernel@vger.kernel.org

Acked-by: Sunil Mushran <sunil.mushran@oracle.com>

Joel Becker wrote:
> With the ocfs2_cluster_connection hanging off of the ocfs2_dlm_lksb, we
> have access to it in the ast and bast wrapper functions.  Attach the
> ocfs2_locking_protocol to the conn.
>
> Now, instead of refering to a static variable for ast/bast pointers, the
> wrappers can look at the connection.  This means different connections
> can have different ast/bast pointers, and it reduces the need for the
> static pointer.
>
> Signed-off-by: Joel Becker <joel.becker@oracle.com>
> ---
>  fs/ocfs2/stack_o2cb.c |   15 ++++-----------
>  fs/ocfs2/stack_user.c |   10 +++-------
>  fs/ocfs2/stackglue.c  |    1 +
>  fs/ocfs2/stackglue.h  |    1 +
>  4 files changed, 9 insertions(+), 18 deletions(-)
>
> diff --git a/fs/ocfs2/stack_o2cb.c b/fs/ocfs2/stack_o2cb.c
> index 41e6bad..abf696a 100644
> --- a/fs/ocfs2/stack_o2cb.c
> +++ b/fs/ocfs2/stack_o2cb.c
> @@ -163,28 +163,21 @@ static void o2dlm_lock_ast_wrapper(void *astarg)
>  {
>  	struct ocfs2_dlm_lksb *lksb = astarg;
>  
> -	BUG_ON(o2cb_stack.sp_proto == NULL);
> -
> -	o2cb_stack.sp_proto->lp_lock_ast(lksb);
> +	lksb->lksb_conn->cc_proto->lp_lock_ast(lksb);
>  }
>  
>  static void o2dlm_blocking_ast_wrapper(void *astarg, int level)
>  {
>  	struct ocfs2_dlm_lksb *lksb = astarg;
>  
> -	BUG_ON(o2cb_stack.sp_proto == NULL);
> -
> -	o2cb_stack.sp_proto->lp_blocking_ast(lksb, level);
> +	lksb->lksb_conn->cc_proto->lp_blocking_ast(lksb, level);
>  }
>  
>  static void o2dlm_unlock_ast_wrapper(void *astarg, enum dlm_status status)
>  {
>  	struct ocfs2_dlm_lksb *lksb = astarg;
> -
>  	int error = dlm_status_to_errno(status);
>  
> -	BUG_ON(o2cb_stack.sp_proto == NULL);
> -
>  	/*
>  	 * In o2dlm, you can get both the lock_ast() for the lock being
>  	 * granted and the unlock_ast() for the CANCEL failing.  A
> @@ -199,7 +192,7 @@ static void o2dlm_unlock_ast_wrapper(void *astarg, enum dlm_status status)
>  	if (status == DLM_CANCELGRANT)
>  		return;
>  
> -	o2cb_stack.sp_proto->lp_unlock_ast(lksb, error);
> +	lksb->lksb_conn->cc_proto->lp_unlock_ast(lksb, error);
>  }
>  
>  static int o2cb_dlm_lock(struct ocfs2_cluster_connection *conn,
> @@ -284,7 +277,7 @@ static int o2cb_cluster_connect(struct ocfs2_cluster_connection *conn)
>  	struct dlm_protocol_version dlm_version;
>  
>  	BUG_ON(conn == NULL);
> -	BUG_ON(o2cb_stack.sp_proto == NULL);
> +	BUG_ON(conn->cc_proto == NULL);
>  
>  	/* for now we only have one cluster/node, make sure we see it
>  	 * in the heartbeat universe */
> diff --git a/fs/ocfs2/stack_user.c b/fs/ocfs2/stack_user.c
> index 31276ba..b4cf616 100644
> --- a/fs/ocfs2/stack_user.c
> +++ b/fs/ocfs2/stack_user.c
> @@ -668,8 +668,6 @@ static void fsdlm_lock_ast_wrapper(void *astarg)
>  	struct ocfs2_dlm_lksb *lksb = astarg;
>  	int status = lksb->lksb_fsdlm.sb_status;
>  
> -	BUG_ON(ocfs2_user_plugin.sp_proto == NULL);
> -
>  	/*
>  	 * For now we're punting on the issue of other non-standard errors
>  	 * where we can't tell if the unlock_ast or lock_ast should be called.
> @@ -681,18 +679,16 @@ static void fsdlm_lock_ast_wrapper(void *astarg)
>  	 */
>  
>  	if (status == -DLM_EUNLOCK || status == -DLM_ECANCEL)
> -		ocfs2_user_plugin.sp_proto->lp_unlock_ast(lksb, 0);
> +		lksb->lksb_conn->cc_proto->lp_unlock_ast(lksb, 0);
>  	else
> -		ocfs2_user_plugin.sp_proto->lp_lock_ast(lksb);
> +		lksb->lksb_conn->cc_proto->lp_lock_ast(lksb);
>  }
>  
>  static void fsdlm_blocking_ast_wrapper(void *astarg, int level)
>  {
>  	struct ocfs2_dlm_lksb *lksb = astarg;
>  
> -	BUG_ON(ocfs2_user_plugin.sp_proto == NULL);
> -
> -	ocfs2_user_plugin.sp_proto->lp_blocking_ast(lksb, level);
> +	lksb->lksb_conn->cc_proto->lp_blocking_ast(lksb, level);
>  }
>  
>  static int user_dlm_lock(struct ocfs2_cluster_connection *conn,
> diff --git a/fs/ocfs2/stackglue.c b/fs/ocfs2/stackglue.c
> index 8ef9a57..010ecab 100644
> --- a/fs/ocfs2/stackglue.c
> +++ b/fs/ocfs2/stackglue.c
> @@ -343,6 +343,7 @@ int ocfs2_cluster_connect(const char *stack_name,
>  	new_conn->cc_recovery_handler = recovery_handler;
>  	new_conn->cc_recovery_data = recovery_data;
>  
> +	new_conn->cc_proto = lproto;
>  	/* Start the new connection at our maximum compatibility level */
>  	new_conn->cc_version = lproto->lp_max_version;
>  
> diff --git a/fs/ocfs2/stackglue.h b/fs/ocfs2/stackglue.h
> index bb32926..cf8bac2 100644
> --- a/fs/ocfs2/stackglue.h
> +++ b/fs/ocfs2/stackglue.h
> @@ -100,6 +100,7 @@ struct ocfs2_cluster_connection {
>  	char cc_name[GROUP_NAME_MAX];
>  	int cc_namelen;
>  	struct ocfs2_protocol_version cc_version;
> +	struct ocfs2_locking_protocol *cc_proto;
>  	void (*cc_recovery_handler)(int node_num, void *recovery_data);
>  	void *cc_recovery_data;
>  	void *cc_lockspace;
>   
