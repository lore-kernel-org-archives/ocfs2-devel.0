From: Mark Fasheh <mfasheh@suse.de>
Date: Mon, 9 Sep 2013 14:50:33 -0700
Subject: [Ocfs2-devel] [PATCH 3/6] Remove control handling
	from	cluster_connect
In-Reply-To: <20130906032748.GA4163@shrek.lan>
References: <20130906032748.GA4163@shrek.lan>
Message-ID: <20130909215033.GE31381@wotan.suse.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Thu, Sep 05, 2013 at 10:27:53PM -0500, Goldwyn Rodrigues wrote:
> 
> Signed-off-by: Goldwyn Rodrigues <rgoldwyn@suse.com>
> ---
>  fs/ocfs2/stack_user.c | 24 ------------------------
>  1 file changed, 24 deletions(-)
> 
> diff --git a/fs/ocfs2/stack_user.c b/fs/ocfs2/stack_user.c
> index 2ef6ad5..d604a36 100644
> --- a/fs/ocfs2/stack_user.c
> +++ b/fs/ocfs2/stack_user.c
> @@ -822,36 +822,14 @@ const struct dlm_lockspace_ops ocfs2_ls_ops = {
>  static int user_cluster_connect(struct ocfs2_cluster_connection *conn)
>  {
>  	dlm_lockspace_t *fsdlm;
> -	struct ocfs2_live_connection *uninitialized_var(control);
>  	int rc = 0, ops_rv;
>  
>  	BUG_ON(conn == NULL);
>  
> -	rc = ocfs2_live_connection_new(conn, &control);
> -	if (rc)
> -		goto out;
> -
> -	/*
> -	 * running_proto must have been set before we allowed any mounts
> -	 * to proceed.
> -	 */
> -	if (fs_protocol_compare(&running_proto, &conn->cc_version)) {
> -		printk(KERN_ERR
> -		       "Unable to mount with fs locking protocol version "
> -		       "%u.%u because the userspace control daemon has "
> -		       "negotiated %u.%u\n",
> -		       conn->cc_version.pv_major, conn->cc_version.pv_minor,
> -		       running_proto.pv_major, running_proto.pv_minor);
> -		rc = -EPROTO;
> -		ocfs2_live_connection_drop(control);
> -		goto out;
> -	}
> -
>  	rc = dlm_new_lockspace(conn->cc_name, conn->cc_cluster_name,
>  			       DLM_LSFL_FS, DLM_LVB_LEN,
>  			       &ocfs2_ls_ops, conn, &ops_rv, &fsdlm);
>  	if (rc) {
> -		ocfs2_live_connection_drop(control);
>  		goto out;
>  	}

If it helps, you can put this stuff in it's own function for handling older
versions of the userspace stack.
	--Mark

--
Mark Fasheh
