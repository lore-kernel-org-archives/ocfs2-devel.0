From: Mark Fasheh <mfasheh@suse.de>
Date: Sun, 3 Nov 2013 14:16:44 -0800
Subject: [Ocfs2-devel] [PATCH 2/6] Add DLM recovery callbacks
In-Reply-To: <20131018144520.GA4579@shrek.lan>
References: <20131018144520.GA4579@shrek.lan>
Message-ID: <20131103221644.GH29346@wotan.suse.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

This also looks good in that I don't see anything wrong with the way the
actual code functions. The extra description you put about the callbacks
helps in understanding this too. Question - can you explain why oc_this_node
is an atomic? That is to say I'd like to understand that race that you're
protecting against :)
	--Mark

On Fri, Oct 18, 2013 at 09:45:25AM -0500, Goldwyn Rodrigues wrote:
> These are the callbacks called by the fs/dlm code in case the membership
> changes. If there is a failure while/during calling any of these, the
> DLM creates a new membership and relays to the rest of the nodes.
> 
> recover_prep() is called when DLM understands a node is down.
> recover_slot() is called once all nodes have acknowledged recover_prep
> and recovery can begin.
> recover_done() is called once the recovery is complete. It returns the
> new membership.
> 
> Signed-off-by: Goldwyn Rodrigues <rgoldwyn@suse.com>
> ---
>  fs/ocfs2/stack_user.c | 38 ++++++++++++++++++++++++++++++++++++++
>  1 file changed, 38 insertions(+)
> 
> diff --git a/fs/ocfs2/stack_user.c b/fs/ocfs2/stack_user.c
> index 286edf1..4111855 100644
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
> @@ -799,6 +801,42 @@ static int fs_protocol_compare(struct ocfs2_protocol_version *existing,
>  	return 0;
>  }
>  
> +static void user_recover_prep(void *arg)
> +{
> +}
> +
> +static void user_recover_slot(void *arg, struct dlm_slot *slot)
> +{
> +	struct ocfs2_cluster_connection *conn = arg;
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
> +	struct ocfs2_cluster_connection *conn = arg;
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
> +const struct dlm_lockspace_ops ocfs2_ls_ops = {
> +	.recover_prep = user_recover_prep,
> +	.recover_slot = user_recover_slot,
> +	.recover_done = user_recover_done,
> +};
> +
>  static int user_cluster_connect(struct ocfs2_cluster_connection *conn)
>  {
>  	dlm_lockspace_t *fsdlm;
> -- 
> 1.8.1.4
> 
> 
> -- 
> Goldwyn
--
Mark Fasheh
