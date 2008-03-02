From: Joel Becker <Joel.Becker@oracle.com>
Date: Sun Mar  2 18:16:35 2008
Subject: [Ocfs2-devel] [PATCH 3/6] ocfs2/dlm: Add missing
	dlm_lockres_put()s
In-Reply-To: <1204409065-10953-4-git-send-email-sunil.mushran@oracle.com>
References: <1204409065-10953-1-git-send-email-sunil.mushran@oracle.com>
	<1204409065-10953-4-git-send-email-sunil.mushran@oracle.com>
Message-ID: <20080303021521.GD6897@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Sat, Mar 01, 2008 at 02:04:22PM -0800, Sunil Mushran wrote:
> dlm_master_request_handler() forgot to put a lockres when
> dlm_assert_master_worker() failed or was skipped.
> 
> Signed-off-by: Sunil Mushran <sunil.mushran@oracle.com>
Signed-off-by: Joel Becker <joel.becker@oracle.com>

> ---
>  fs/ocfs2/dlm/dlmmaster.c |   11 ++++++++++-
>  1 files changed, 10 insertions(+), 1 deletions(-)
> 
> diff --git a/fs/ocfs2/dlm/dlmmaster.c b/fs/ocfs2/dlm/dlmmaster.c
> index eadf9bf..b6629bb 100644
> --- a/fs/ocfs2/dlm/dlmmaster.c
> +++ b/fs/ocfs2/dlm/dlmmaster.c
> @@ -1663,7 +1663,12 @@ way_up_top:
>  		dlm_put_mle(tmpmle);
>  	}
>  send_response:
> -
> +	/*
> +	 * __dlm_lookup_lockres() grabbed a reference to this lockres.
> +	 * The reference is released by dlm_assert_master_worker() under
> +	 * the call to dlm_dispatch_assert_master().  If
> +	 * dlm_assert_master_worker() isn't called, we drop it here.
> +	 */
>  	if (dispatch_assert) {
>  		if (response != DLM_MASTER_RESP_YES)
>  			mlog(ML_ERROR, "invalid response %d\n", response);
> @@ -1678,7 +1683,11 @@ send_response:
>  		if (ret < 0) {
>  			mlog(ML_ERROR, "failed to dispatch assert master work\n");
>  			response = DLM_MASTER_RESP_ERROR;
> +			dlm_lockres_put(res);
>  		}
> +	} else {
> +		if (res)
> +			dlm_lockres_put(res);
>  	}
>  
>  	dlm_put(dlm);
> -- 
> 1.5.3.6
> 
> 
> _______________________________________________
> Ocfs2-devel mailing list
> Ocfs2-devel@oss.oracle.com
> http://oss.oracle.com/mailman/listinfo/ocfs2-devel

-- 

"Anything that is too stupid to be spoken is sung."  
        - Voltaire

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker@oracle.com
Phone: (650) 506-8127
