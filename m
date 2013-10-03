From: Andrew Morton <akpm@linux-foundation.org>
Date: Thu, 3 Oct 2013 13:26:19 -0700
Subject: [Ocfs2-devel] [PATCH 2/5] Add DLM recovery callbacks
In-Reply-To: <20131003054929.GA12891@shrek.lan>
References: <20131003054929.GA12891@shrek.lan>
Message-ID: <20131003132619.582375c2cb7398f8fbe51db2@linux-foundation.org>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Thu, 3 Oct 2013 00:49:37 -0500 Goldwyn Rodrigues <rgoldwyn@suse.de> wrote:

> recover_prep() is called when DLM understands a node is down.
> recover_slot() is called once all nodes have acknowledged recover_prep
> and recovery can begin.
> recover_done() is called once the recovery is complete. It returns the
> new membership.
> 
> ...
>
> --- a/fs/ocfs2/stack_user.c
> +++ b/fs/ocfs2/stack_user.c
> @@ -110,6 +110,8 @@
>  struct ocfs2_live_connection {
>  	struct list_head		oc_list;
>  	struct ocfs2_cluster_connection	*oc_conn;
> +	atomic_t                        oc_this_node;
> +	int                             oc_our_slot;
>  };
>  
>  struct ocfs2_control_private {
> @@ -799,6 +801,44 @@ static int fs_protocol_compare(struct ocfs2_protocol_version *existing,
>  	return 0;
>  }
>  
> +static void user_recover_prep(void *arg)
> +{
> +}
> +
> +static void user_recover_slot(void *arg, struct dlm_slot *slot)
> +{
> +	struct ocfs2_cluster_connection *conn =
> +		(struct ocfs2_cluster_connection  *) arg;

A cast of void* is unneeded.  And it's somewhat undesirable, because if
someone stupidly goes and changes that void* to a long or a
task_struct* or whatever, the cast will suppress the warning which we'd
like to get.


> +	printk(KERN_INFO "ocfs2: Node %d/%d down. Initiating recovery.\n",
> +			slot->nodeid, slot->slot);
> +	conn->cc_recovery_handler(slot->nodeid, conn->cc_recovery_data);
> +
> +}
> +
> +static void user_recover_done(void *arg, struct dlm_slot *slots,
> +		int num_slots, int our_slot,
> +		uint32_t generation)
> +{
> +	struct ocfs2_cluster_connection *conn =
> +		(struct ocfs2_cluster_connection *)arg;

etc.

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
> +}
> +
