From: Mark Fasheh <mfasheh@suse.de>
Date: Sun, 3 Nov 2013 17:12:09 -0800
Subject: [Ocfs2-devel] [PATCH 6/6] Use the new DLM operation callbacks
	while	requesting new lockspace
In-Reply-To: <20131018144626.GA4598@shrek.lan>
References: <20131018144626.GA4598@shrek.lan>
Message-ID: <20131104011209.GN29346@wotan.suse.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Fri, Oct 18, 2013 at 09:46:31AM -0500, Goldwyn Rodrigues wrote:
> Attempt to use the new DLM operations. If it is not supported,
> use the traditional ocfs2_controld.
> 
> To exchange ocfs2 versioning, we use the LVB of the version dlm lock.
> It first attempts to take the lock in EX mode (non-blocking). If
> successful (which means it is the first mount), it writes the
> version number and downconverts to PR lock. If it is unsuccessful,
> it reads the version from the lock.
> 
> If this becomes the standard (wit o2cb as well), it could
> simplify userspace tools to check if the filesystem is mounted
> on other nodes.
> 
> Signed-off-by: Goldwyn Rodrigues <rgoldwyn@suse.com>
> ---
>  fs/ocfs2/stack_user.c | 97 ++++++++++++++++++++++++++++++++++++++-------------
>  1 file changed, 73 insertions(+), 24 deletions(-)


> @@ -948,12 +961,65 @@ static int user_cluster_connect(struct ocfs2_cluster_connection *conn)
>  		goto out;
>  	}
>  
> -	lc->oc_type = WITH_CONTROLD;
> +	init_waitqueue_head(&lc->oc_wait);
> +	init_completion(&lc->oc_sync_wait);
> +	atomic_set(&lc->oc_this_node, 0);
> +	conn->cc_private = lc;
> +	lc->oc_type = NO_CONTROLD;
> +
> +	rc = dlm_new_lockspace(conn->cc_name, conn->cc_cluster_name,
> +			       DLM_LSFL_FS, DLM_LVB_LEN,
> +			       &ocfs2_ls_ops, conn, &ops_rv, &fsdlm);
> +	if (rc)
> +		goto out;
> +
> +	if (ops_rv == -EOPNOTSUPP) {
> +		lc->oc_type = WITH_CONTROLD;
> +		printk(KERN_NOTICE "ocfs2: You seem to be using an older "
> +				"version of dlm_controld and/or ocfs2-tools."
> +				" Please consider upgrading.\n");
> +	} else if (ops_rv) {
> +		rc = ops_rv;
> +		goto out;
> +	}
> +	conn->cc_lockspace = fsdlm;
>  
>  	rc = ocfs2_live_connection_new(conn, lc);
>  	if (rc)
>  		goto out;
>  
> +	if (lc->oc_type == NO_CONTROLD) {
> +		int ret;
> +		lc->oc_version_lksb.sb_lvbptr = lc->oc_lvb;
> +		ret = version_lock(conn, DLM_LOCK_EX,
> +				DLM_LKF_VALBLK|DLM_LKF_NOQUEUE);
> +		running_proto.pv_major = 
> +			ocfs2_user_plugin.sp_max_proto.pv_major;
> +		running_proto.pv_minor =
> +			ocfs2_user_plugin.sp_max_proto.pv_minor;
> +		if (!ret) {
> +			conn->cc_version.pv_major = running_proto.pv_major;
> +			conn->cc_version.pv_minor = running_proto.pv_minor;
> +			version_to_lvb(&running_proto, lc->oc_lvb);
> +			version_lock(conn, DLM_LOCK_PR, DLM_LKF_CONVERT|DLM_LKF_VALBLK);
> +		} else if (ret == -EAGAIN) {
> +			version_lock(conn, DLM_LOCK_PR, DLM_LKF_VALBLK);
> +			ret = lvb_to_version(lc->oc_lvb, &conn->cc_version);
> +			if (ret) {
> +				rc = ret;
> +				user_cluster_disconnect(conn);
> +				goto out;
> +			}
> +		} else {
> +			printk(KERN_ERR "ocfs2: Could not determine"
> +					" locking version\n");
> +			rc = ret;
> +			user_cluster_disconnect(conn);
> +			goto out;
> +		}
> +		wait_event(lc->oc_wait, (atomic_read(&lc->oc_this_node) > 0));
> +	}
> +

Can we put this block in it's own function?
	--Mark


--
Mark Fasheh
