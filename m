From: Joel Becker <jlbec@evilplan.org>
Date: Fri, 27 Sep 2013 11:59:37 -0700
Subject: [Ocfs2-devel] [PATCH 1/7] Add dlm operations placeholders
In-Reply-To: <20130927170642.GA11701@shrek.lan>
References: <20130927170642.GA11701@shrek.lan>
Message-ID: <20130927185937.GC26517@localhost>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Fri, Sep 27, 2013 at 12:06:47PM -0500, Goldwyn Rodrigues wrote:
> Try locking with the new DLM semantics with the dlm operations.
> If operation fails with EOPNOTSUPP, try the old semantics.
> This would ensure that filesystems are mounted for those who
> are upgrading the kernel but not the tools.
> Users using old tools will be presented with a notice message
> to upgrade the tools.
> 
> recover_prep() is called when DLM understands a node is down.
> recover_slot() is called once all nodes have acknowledged recover_prep and
> recovery can begin.
> recover_done() is called once the recovery is complete. It returns the
> new membership.

	Can recover_prep() pause?  What does the cluster do when not all
nodes acknowledge the prep?  When they die during recover_slot()?  Which
node recovers the slot?

> ---
>  fs/ocfs2/stack_user.c | 70 +++++++++++++++++++++++++++++++++++++--------------
>  1 file changed, 51 insertions(+), 19 deletions(-)
> 
> diff --git a/fs/ocfs2/stack_user.c b/fs/ocfs2/stack_user.c
> index 286edf1..b44490b 100644
> --- a/fs/ocfs2/stack_user.c
> +++ b/fs/ocfs2/stack_user.c
> @@ -799,14 +799,63 @@ static int fs_protocol_compare(struct ocfs2_protocol_version *existing,
>  	return 0;
>  }
>  
> +static void user_recover_prep(void *arg)
> +{
> +}
> +
> +static void user_recover_slot(void *arg, struct dlm_slot *slot)
> +{
> +}
> +
> +static void user_recover_done(void *arg, struct dlm_slot *slots,
> +			      int num_slots, int our_slot,
> +			      uint32_t generation)
> +{
> +}
> +
> +const struct dlm_lockspace_ops ocfs2_ls_ops = {
> +	.recover_prep = user_recover_prep,
> +	.recover_slot = user_recover_slot,
> +	.recover_done = user_recover_done,
> +};
> +
> +static int user_cluster_disconnect(struct ocfs2_cluster_connection *conn)
> +{
> +	dlm_release_lockspace(conn->cc_lockspace, 2);
> +	conn->cc_lockspace = NULL;
> +	ocfs2_live_connection_drop(conn->cc_private);
> +	conn->cc_private = NULL;
> +	return 0;
> +}
> +
>  static int user_cluster_connect(struct ocfs2_cluster_connection *conn)
>  {
>  	dlm_lockspace_t *fsdlm;
>  	struct ocfs2_live_connection *uninitialized_var(control);
> -	int rc = 0;
> +	int rc = 0, ops_rv;
>  
>  	BUG_ON(conn == NULL);
>  
> +	rc = dlm_new_lockspace(conn->cc_name, NULL, DLM_LSFL_FS, DLM_LVB_LEN,
> +				&ocfs2_ls_ops, conn, &ops_rv, &fsdlm);
> +
> +	if (rc)
> +		goto out;
> +
> +	if (!ops_rv) {
> +		/* DLM lockspace creation with newer new_lockspace successful */
> +		goto out;
> +	} else if (ops_rv != -EOPNOTSUPP) {
> +		rc = ops_rv;
> +		goto out;
> +	}
> +
> +	conn->cc_lockspace = fsdlm;

This code returns from !ops_rv before setting cc_lockspace, yet tries to
reference it out in user_cluster_disconnect().  That looks like a
crashing bug.

Also, it looks like you call the new form of dlm_new_lockspace() before
the callbacks are even implemented.  If I just apply this patch, the
code does not work.  Please reorder the patch so that ocfs2 works at
each patch.

Joel


> +
> +	printk(KERN_NOTICE "ocfs2: You seem to be using an older version "
> +			"of dlm_controld and/or ocfs2-tools. Please consider "
> +			"upgrading.\n");
> +
>  	rc = ocfs2_live_connection_new(conn, &control);
>  	if (rc)
>  		goto out;
> @@ -823,32 +872,15 @@ static int user_cluster_connect(struct ocfs2_cluster_connection *conn)
>  		       conn->cc_version.pv_major, conn->cc_version.pv_minor,
>  		       running_proto.pv_major, running_proto.pv_minor);
>  		rc = -EPROTO;
> -		ocfs2_live_connection_drop(control);
> -		goto out;
> -	}
> -
> -	rc = dlm_new_lockspace(conn->cc_name, NULL, DLM_LSFL_FS, DLM_LVB_LEN,
> -			       NULL, NULL, NULL, &fsdlm);
> -	if (rc) {
> -		ocfs2_live_connection_drop(control);
> +		user_cluster_disconnect(conn);
>  		goto out;
>  	}
>  
>  	conn->cc_private = control;
> -	conn->cc_lockspace = fsdlm;
>  out:
>  	return rc;
>  }
>  
> -static int user_cluster_disconnect(struct ocfs2_cluster_connection *conn)
> -{
> -	dlm_release_lockspace(conn->cc_lockspace, 2);
> -	conn->cc_lockspace = NULL;
> -	ocfs2_live_connection_drop(conn->cc_private);
> -	conn->cc_private = NULL;
> -	return 0;
> -}
> -
>  static int user_cluster_this_node(unsigned int *this_node)
>  {
>  	int rc;
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

"But all my words come back to me
 In shades of mediocrity.
 Like emptiness in harmony
 I need someone to comfort me."

			http://www.jlbec.org/
			jlbec at evilplan.org
