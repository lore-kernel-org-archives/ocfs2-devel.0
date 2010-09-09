From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Thu, 09 Sep 2010 09:59:01 -0700
Subject: [Ocfs2-devel] [PATCH 1/1] Ocfs2: Handle invalid lock_res in
 lockres_seq_start() for dlmdebug.c
In-Reply-To: <1284023819-3883-1-git-send-email-tristan.ye@oracle.com>
References: <1284023819-3883-1-git-send-email-tristan.ye@oracle.com>
Message-ID: <4C891255.8060307@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On 09/09/2010 02:16 AM, Tristan Ye wrote:
> In lockres_seq_start() of dlmdebug.c, when you looking at following
> piece of codes:
>
> list_for_each_entry(res, track_list, tracking) {
> 	if (&res->tracking ==&dlm->tracking_list)
> 		res = NULL;
> 	else
> 		dlm_lockres_get(res);
> 	break;
> }
>
> ...
>
> if (res) {
> 	spin_lock(&res->spinlock);
> 	dump_lockres(res, dl->dl_buf, dl->dl_len - 1);
> 	spin_unlock(&res->spinlock);
> } else
> 	dl = NULL;
>
> One thought can come to you that, in the case of 'an-empty-list', cursor 'res'
> here is not an INVALID pointer for real dlm_lock_resource object, it is nothing
> than a fake address figured out by arbitary 'container_of()' way, the patch tries
> to check track_list, and avoid accessing an invalid pointer if the list is empty,
> it fixes following oops:
>
> http://oss.oracle.com/bugzilla/show_bug.cgi?id=1287
>
> Signed-off-by: Tristan Ye<tristan.ye@oracle.com>
> ---
>    

Such a detailed description is only required if the bug fix
is complicated. This is a simple fix. Just say that this handles
the case in which the dlm->tracking_list is empty and mention
the bz.

>   fs/ocfs2/dlm/dlmdebug.c |    7 +++++++
>   1 files changed, 7 insertions(+), 0 deletions(-)
>
> diff --git a/fs/ocfs2/dlm/dlmdebug.c b/fs/ocfs2/dlm/dlmdebug.c
> index 5efdd37..06d668a 100644
> --- a/fs/ocfs2/dlm/dlmdebug.c
> +++ b/fs/ocfs2/dlm/dlmdebug.c
> @@ -639,6 +639,12 @@ static void *lockres_seq_start(struct seq_file *m, loff_t *pos)
>   	else
>   		track_list =&dlm->tracking_list;
>
> +	if (list_empty(track_list)) {
> +		dl = NULL;
> +		spin_unlock(&dlm->track_lock);
> +		goto bail;
> +	}
> +
>    

You should add this check as part of the else block above so
that we check for empty list only at the start.

>   	list_for_each_entry(res, track_list, tracking) {
>   		if (&res->tracking ==&dlm->tracking_list)
>   			res = NULL;
> @@ -660,6 +666,7 @@ static void *lockres_seq_start(struct seq_file *m, loff_t *pos)
>   	} else
>   		dl = NULL;
>
> +bail:
>   	/* passed to seq_show */
>   	return dl;
>   }
>    
