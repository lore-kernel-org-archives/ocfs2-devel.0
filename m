From: Mark Fasheh <mfasheh@suse.de>
Date: Mon, 9 Sep 2013 14:38:39 -0700
Subject: [Ocfs2-devel] [PATCH 1/6] Add dlm operations placeholders
In-Reply-To: <20130906032717.GA4153@shrek.lan>
References: <20130906032717.GA4153@shrek.lan>
Message-ID: <20130909213839.GC31381@wotan.suse.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

This looks good, other than the backwards compatibility issue I mention
below.

I see we're goign to get some recovery calllbacks node? Any chance you can
give a short description of what their purpose is?
	--Mark

On Thu, Sep 05, 2013 at 10:27:21PM -0500, Goldwyn Rodrigues wrote:
> 
> Signed-off-by: Goldwyn Rodrigues <rgoldwyn@suse.com>
> ---
>  fs/ocfs2/stack_user.c | 30 ++++++++++++++++++++++++++++--
>  1 file changed, 28 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/ocfs2/stack_user.c b/fs/ocfs2/stack_user.c
> index 286edf1..1b18193 100644
> --- a/fs/ocfs2/stack_user.c
> +++ b/fs/ocfs2/stack_user.c
> @@ -799,11 +799,31 @@ static int fs_protocol_compare(struct ocfs2_protocol_version *existing,
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
>  static int user_cluster_connect(struct ocfs2_cluster_connection *conn)
>  {
>  	dlm_lockspace_t *fsdlm;
>  	struct ocfs2_live_connection *uninitialized_var(control);
> -	int rc = 0;
> +	int rc = 0, ops_rv;
>  
>  	BUG_ON(conn == NULL);
>  
> @@ -828,12 +848,18 @@ static int user_cluster_connect(struct ocfs2_cluster_connection *conn)
>  	}
>  
>  	rc = dlm_new_lockspace(conn->cc_name, NULL, DLM_LSFL_FS, DLM_LVB_LEN,
> -			       NULL, NULL, NULL, &fsdlm);
> +			       &ocfs2_ls_ops, conn, &ops_rv, &fsdlm);
>  	if (rc) {
>  		ocfs2_live_connection_drop(control);
>  		goto out;
>  	}
>  
> +	if (ops_rv < 0) {
> +		printk(KERN_ERR "ocfs2: dlm lockspace ops could not be used. You may be using an older dlm_controld\n");
> +		rc = -EINVAL;
> +		goto out;
> +	}

Presumably we're going to figure out how to support all versions of
userspace, so this would go?
	--Mark

--
Mark Fasheh
