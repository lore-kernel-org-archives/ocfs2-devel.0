From: alex chen <alex.chen@huawei.com>
Date: Fri, 24 Nov 2017 13:57:56 +0800
Subject: [Ocfs2-devel] [PATCH] ocfs2/dlm: clean dead code up
In-Reply-To: <63ADC13FD55D6546B7DECE290D39E373CED7EF9E@H3CMLB14-EX.srv.huawei-3com.com>
References: <63ADC13FD55D6546B7DECE290D39E373CED7EF9E@H3CMLB14-EX.srv.huawei-3com.com>
Message-ID: <5A17B4E4.4060703@huawei.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

It looks good to me.

On 2017/11/24 13:30, Changwei Ge wrote:
> This code snippet is no longer used. So trim it, thus to make code neat.
> 
> Signed-off-by: Changwei Ge <ge.changwei@h3c.com>
Reviewed-by: Alex Chen <alex.chen@huawei.com>
> ---
>   fs/ocfs2/dlm/dlmmaster.c | 7 -------
>   1 file changed, 7 deletions(-)
> 
> diff --git a/fs/ocfs2/dlm/dlmmaster.c b/fs/ocfs2/dlm/dlmmaster.c
> index 3e04279446e8..93b61c6c409e 100644
> --- a/fs/ocfs2/dlm/dlmmaster.c
> +++ b/fs/ocfs2/dlm/dlmmaster.c
> @@ -1122,13 +1122,6 @@ static int dlm_wait_for_lock_mastery(struct 
> dlm_ctxt *dlm,
>   	/* sleep if we haven't finished voting yet */
>   	if (sleep) {
>   		unsigned long timeo = msecs_to_jiffies(DLM_MASTERY_TIMEOUT_MS);
> -
> -		/*
> -		if (kref_read(&mle->mle_refs) < 2)
> -			mlog(ML_ERROR, "mle (%p) refs=%d, name=%.*s\n", mle,
> -			kref_read(&mle->mle_refs),
> -			res->lockname.len, res->lockname.name);
> -		*/
>   		atomic_set(&mle->woken, 0);
>   		(void)wait_event_timeout(mle->wq,
>   					 (atomic_read(&mle->woken) == 1),
> 
