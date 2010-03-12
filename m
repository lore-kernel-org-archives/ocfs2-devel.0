From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Fri, 12 Mar 2010 10:27:14 -0800
Subject: [Ocfs2-devel] [PATCH] ocfs2: prints peer node number when
 sending tcp msg failed -v2
In-Reply-To: <201003120730.o2C7UFZi008464@rcsinet15.oracle.com>
References: <201003120730.o2C7UFZi008464@rcsinet15.oracle.com>
Message-ID: <4B9A8782.1030706@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Comments inline.

Wengang Wang wrote:
> diff --git a/fs/ocfs2/dlm/dlmmaster.c b/fs/ocfs2/dlm/dlmmaster.c
> index a659606..be24a13 100644
> --- a/fs/ocfs2/dlm/dlmmaster.c
> +++ b/fs/ocfs2/dlm/dlmmaster.c
> @@ -1309,6 +1309,8 @@ again:
>  	ret = o2net_send_message(DLM_MASTER_REQUEST_MSG, dlm->key, &request,
>  				 sizeof(request), to, &response);
>  	if (ret < 0)  {
> +		mlog(ML_ERROR, "Error %d when sending message %u (key 0x%x) to "
> +		     "node %u\n", ret, DLM_MASTER_REQUEST_MSG, dlm->key, to);
>  		if (ret == -ESRCH) {
>  			/* should never happen */
>  			mlog(ML_ERROR, "TCP stack not ready!\n");

Remove this one. The error messages below handle this.

> @@ -2637,14 +2643,16 @@ retry:
>  		/* negative status is handled ok by caller here */
>  		if (ret >= 0)
>  			ret = status;
> -		if (dlm_is_host_down(ret)) {
> -			/* node is down.  not involved in recovery
> -			 * so just keep going */
> -			mlog(0, "%s: node %u was down when sending "
> -			     "begin reco msg (%d)\n", dlm->name, nodenum, ret);
> -			ret = 0;
> +		else {
> +			mlog(ML_ERROR, "Error %d when sending message %u (key "
> +			     "0x%x) to node %u\n", ret, DLM_BEGIN_RECO_MSG,
> +			     dlm->key, nodenum);
> +			if (dlm_is_host_down(ret)) {
> +				/* node is down.  not involved in recovery
> +				 * so just keep going */
> +				ret = 0;
> +			}
>  		}

You are changing the logic here. Please remove this code.
Maybe change 0 to ML_NOTICE in the original code.

> -
>  		/*
>  		 * Prior to commit aad1b15310b9bcd59fa81ab8f2b1513b59553ea8,
>  		 * dlm_begin_reco_handler() returned EAGAIN and not -EAGAIN.
> @@ -2662,9 +2670,6 @@ retry:
>  			struct dlm_lock_resource *res;
>  			/* this is now a serious problem, possibly ENOMEM
>  			 * in the network stack.  must retry */
> -			mlog_errno(ret);
> -			mlog(ML_ERROR, "begin reco of dlm %s to node %u "
> -			    " returned %d\n", dlm->name, nodenum, ret);

Again, leave the original code in.
