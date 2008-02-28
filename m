From: Joel Becker <Joel.Becker@oracle.com>
Date: Thu Feb 28 14:50:09 2008
Subject: [Ocfs2-devel] [PATCH 05/18] ocfs2_dlm: Add missing
	dlm_lockres_put()s
In-Reply-To: <1203970862-8790-6-git-send-email-sunil.mushran@oracle.com>
References: <1203970862-8790-1-git-send-email-sunil.mushran@oracle.com>
	<1203970862-8790-6-git-send-email-sunil.mushran@oracle.com>
Message-ID: <20080228224821.GH23975@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Mon, Feb 25, 2008 at 12:20:49PM -0800, Sunil Mushran wrote:
> This patch adds few missing puts in dlm_master_request_handler().

dlm_master_request_handler() forgot to put a lockres when 
dlm_assert_master_worker() failed or was skipped.

> --- a/fs/ocfs2/dlm/dlmmaster.c
> +++ b/fs/ocfs2/dlm/dlmmaster.c
> @@ -1718,7 +1718,13 @@ send_response:
>  		if (ret < 0) {
>  			mlog(ML_ERROR, "failed to dispatch assert master work\n");
>  			response = DLM_MASTER_RESP_ERROR;
> +			/* incase dlm_assert_master_worker() was not called */
> +			dlm_lockres_put(res);
>  		}
> +	} else {
> +		/* match the put in dlm_assert_master_worker() */
> +		if (res)
> +			dlm_lockres_put(res);

	The put()s are correct, but I'd remove those comments and place
a comment above the whole if() block.  The comments you have assume more
knowledge of the flow than is obvious.

+	/*
+	 * __dlm_lookup_lockres() grabbed a reference to this lockres.
+ 	 * The reference is released by dlm_assert_master_worker() under
+	 * the call to dlm_dispatch_assert_master().  If
+	 * dlm_assert_master_worker() isn't called, we drop it here.
+	 */
	if (dispatch_assert) {

Joel

-- 

Life's Little Instruction Book #252

	"Take good care of those you love."

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker@oracle.com
Phone: (650) 506-8127
