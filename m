From: Andrew Morton <akpm@linux-foundation.org>
Date: Thu, 3 Oct 2013 13:28:18 -0700
Subject: [Ocfs2-devel] [PATCH 3/5] Shift allocation
 ocfs2_live_connection to user_connect()
In-Reply-To: <20131003054954.GA12895@shrek.lan>
References: <20131003054954.GA12895@shrek.lan>
Message-ID: <20131003132818.73c922c63a4b9404fd8b1ffa@linux-foundation.org>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Thu, 3 Oct 2013 00:49:59 -0500 Goldwyn Rodrigues <rgoldwyn@suse.de> wrote:

> We perform this because the DLM recovery callbacks will require
> the ocfs2_live_connection structure to record the node information
> when dlm_new_lockspace() is updated.
> 
> ...
>
>  static int user_cluster_connect(struct ocfs2_cluster_connection *conn)
>  {
>  	dlm_lockspace_t *fsdlm;
> -	struct ocfs2_live_connection *uninitialized_var(control);
> +	struct ocfs2_live_connection *lc = NULL;
>  	int rc = 0;

Neither of the above initializations are needed.  Presumably trhe
compiler will jsut remove the code, but it's a bit strange.


>  	BUG_ON(conn == NULL);
>  
> -	rc = ocfs2_live_connection_new(conn, &control);
> +	lc = kzalloc(sizeof(struct ocfs2_live_connection), GFP_KERNEL);
> +	if (!lc) {
> +		rc = -ENOMEM;
> +		goto out;
> +	}
> +
> +	rc = ocfs2_live_connection_new(conn, lc);
>  	if (rc)
>  		goto out;
>   ...
>
