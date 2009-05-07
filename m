From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Thu, 07 May 2009 11:50:37 -0700
Subject: [Ocfs2-devel] [PATCH] ocfs2_cluster_lock: code cleanup for
 redundant assignment
In-Reply-To: <4A0328DC.6050702@suse.de>
References: <4A0328DC.6050702@suse.de>
Message-ID: <4A032D7D.5040600@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

While this patch may be correct, we have to take into consideration
that we have to backport patches to 1.4, etc. In that light, is this
patch worth it?

Coly Li wrote:
> In fs/ocfs2/dlmglue.c:ocfs2_cluster_lock(), after label 'out:' the code is:
>
> 1373         if (wait && arg_flags & OCFS2_LOCK_NONBLOCK &&
> 1374             mw.mw_mask & (OCFS2_LOCK_BUSY|OCFS2_LOCK_BLOCKED)) {
> 1375                 wait = 0;
> 1376                 if (lockres_remove_mask_waiter(lockres, &mw))
> 1377                         ret = -EAGAIN;
> 1378                 else
> 1379                         goto again;
> 1380         }
>
> On L1375 variable 'wait' is assigned to 0. But if execution path goes to L1379
> and jumps to label 'again:' on L1262, there is already an assignment to 'wait'
> on L1263:
>
> 1262 again:
> 1263         wait = 0;
> 1264
>
> The previous 'wait = 0' on L1375 is redundant in this case. This patch removes
> such a redundant variable assignment.
>
> Signed-off-by: Coly Li <coly.li@suse.de>
> ---
>  fs/ocfs2/dlmglue.c |    6 +++---
>  1 files changed, 3 insertions(+), 3 deletions(-)
>
> diff --git a/fs/ocfs2/dlmglue.c b/fs/ocfs2/dlmglue.c
> index e15fc7d..b6060e3 100644
> --- a/fs/ocfs2/dlmglue.c
> +++ b/fs/ocfs2/dlmglue.c
> @@ -1372,10 +1372,10 @@ out:
>  	 */
>  	if (wait && arg_flags & OCFS2_LOCK_NONBLOCK &&
>  	    mw.mw_mask & (OCFS2_LOCK_BUSY|OCFS2_LOCK_BLOCKED)) {
> -		wait = 0;
> -		if (lockres_remove_mask_waiter(lockres, &mw))
> +		if (lockres_remove_mask_waiter(lockres, &mw)) {
> +			wait = 0;
>  			ret = -EAGAIN;
> -		else
> +		} else
>  			goto again;
>  	}
>  	if (wait) {
>   
