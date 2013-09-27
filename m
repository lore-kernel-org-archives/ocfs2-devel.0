From: Joel Becker <jlbec@evilplan.org>
Date: Fri, 27 Sep 2013 12:03:43 -0700
Subject: [Ocfs2-devel] [PATCH 5/7] Record this node's information
In-Reply-To: <20130927170855.GA11732@shrek.lan>
References: <20130927170855.GA11732@shrek.lan>
Message-ID: <20130927190342.GF26517@localhost>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

See, this patch needs to be applied before we ever try to call the new
lockspace code.

Joel

On Fri, Sep 27, 2013 at 12:09:00PM -0500, Goldwyn Rodrigues wrote:
> ---
>  fs/ocfs2/stack_user.c | 44 ++++++++++++++++++++++++++++++++++----------
>  1 file changed, 34 insertions(+), 10 deletions(-)
> 
> diff --git a/fs/ocfs2/stack_user.c b/fs/ocfs2/stack_user.c
> index ffefbb5..cccc1e1 100644
> --- a/fs/ocfs2/stack_user.c
> +++ b/fs/ocfs2/stack_user.c
> @@ -23,6 +23,7 @@
>  #include <linux/mutex.h>
>  #include <linux/slab.h>
>  #include <linux/reboot.h>
> +#include <linux/sched.h>
>  #include <asm/uaccess.h>
>  
>  #include "stackglue.h"
> @@ -116,6 +117,9 @@ struct ocfs2_live_connection {
>  	struct list_head		oc_list;
>  	struct ocfs2_cluster_connection	*oc_conn;
>  	enum ocfs2_connection_type	oc_type;
> +	atomic_t			oc_this_node;
> +	int				oc_our_slot;
> +	wait_queue_head_t		oc_wait;
>  };
>  
>  struct ocfs2_control_private {
> @@ -205,15 +209,13 @@ static struct ocfs2_live_connection *ocfs2_connection_find(const char *name)
>   * fill_super(), we can't get dupes here.
>   */
>  static int ocfs2_live_connection_new(struct ocfs2_cluster_connection *conn,
> -				     struct ocfs2_live_connection *c,
> -				     enum ocfs2_connection_type type)
> +				     struct ocfs2_live_connection *c)
>  {
>  	int rc = 0;
>  	mutex_lock(&ocfs2_control_lock);
>  	c->oc_conn = conn;
> -	c->oc_type = type;
>  
> -	if ((type == NO_CONTROLD) || atomic_read(&ocfs2_control_opened))
> +	if ((c->oc_type == NO_CONTROLD) || atomic_read(&ocfs2_control_opened))
>  		list_add(&c->oc_list, &ocfs2_live_connection_list);
>  	else {
>  		printk(KERN_ERR
> @@ -802,12 +804,30 @@ static void user_recover_prep(void *arg)
>  
>  static void user_recover_slot(void *arg, struct dlm_slot *slot)
>  {
> +	struct ocfs2_cluster_connection *conn =
> +		(struct ocfs2_cluster_connection  *) arg;
> +	printk(KERN_INFO "ocfs2: Node %d/%d down. Initiating recovery.\n",
> +			slot->nodeid, slot->slot);
> +	conn->cc_recovery_handler(slot->nodeid, conn->cc_recovery_data);
>  }
>  
>  static void user_recover_done(void *arg, struct dlm_slot *slots,
>  			      int num_slots, int our_slot,
>  			      uint32_t generation)
>  {
> +	struct ocfs2_cluster_connection *conn =
> +		(struct ocfs2_cluster_connection *)arg;
> +	struct ocfs2_live_connection *lc = conn->cc_private;
> +	int i;
> +
> +	for (i = 0; i < num_slots; i++)
> +		if (slots[i].slot == our_slot) {
> +			atomic_set(&lc->oc_this_node, slots[i].nodeid);
> +			break;
> +		}
> +
> +	lc->oc_our_slot = our_slot;
> +	wake_up(&lc->oc_wait);
>  }
>  
>  const struct dlm_lockspace_ops ocfs2_ls_ops = {
> @@ -830,7 +850,6 @@ static int user_cluster_connect(struct ocfs2_cluster_connection *conn)
>  	dlm_lockspace_t *fsdlm;
>  	struct ocfs2_live_connection *lc = NULL;
>  	int rc = 0, ops_rv;
> -	enum ocfs2_connection_type type = NO_CONTROLD;
>  
>  	BUG_ON(conn == NULL);
>  
> @@ -840,6 +859,11 @@ static int user_cluster_connect(struct ocfs2_cluster_connection *conn)
>  		goto out;
>  	}
>  
> +	init_waitqueue_head(&lc->oc_wait);
> +	atomic_set(&lc->oc_this_node, 0);
> +	conn->cc_private = lc;
> +	lc->oc_type = NO_CONTROLD;
> +
>  	rc = dlm_new_lockspace(conn->cc_name, conn->cc_cluster_name,
>  			       DLM_LSFL_FS, DLM_LVB_LEN,
>  				&ocfs2_ls_ops, conn, &ops_rv, &fsdlm);
> @@ -848,7 +872,7 @@ static int user_cluster_connect(struct ocfs2_cluster_connection *conn)
>  		goto out;
>  
>  	if (ops_rv == -EOPNOTSUPP) {
> -		type = WITH_CONTROLD;
> +		lc->oc_type = WITH_CONTROLD;
>  		printk(KERN_NOTICE "ocfs2: You seem to be using an older "
>  				"version of dlm_controld and/or ocfs2-tools."
>  				" Please consider upgrading.\n");
> @@ -858,11 +882,11 @@ static int user_cluster_connect(struct ocfs2_cluster_connection *conn)
>  	}
>  	conn->cc_lockspace = fsdlm;
>  
> -	rc = ocfs2_live_connection_new(conn, lc, type);
> +	rc = ocfs2_live_connection_new(conn, lc);
>  	if (rc)
>  		goto out;
>  
> -	if (type == WITH_CONTROLD) {
> +	if (lc->oc_type == WITH_CONTROLD) {
>  		/*
>  		 * running_proto must have been set before we allowed any mounts
>  		 * to proceed.
> @@ -890,9 +914,9 @@ static int user_cluster_connect(struct ocfs2_cluster_connection *conn)
>  			lc = NULL;
>  			goto out;
>  		}
> -	}
> +	} else if (lc->oc_type == NO_CONTROLD)
> +		wait_event(lc->oc_wait, (atomic_read(&lc->oc_this_node) > 0));
>  
> -	conn->cc_private = lc;
>  out:
>  	if (rc && lc)
>  		kfree(lc);
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

"Lately I've been talking in my sleep.
 Can't imagine what I'd have to say.
 Except my world will be right
 When love comes back my way."

			http://www.jlbec.org/
			jlbec at evilplan.org
