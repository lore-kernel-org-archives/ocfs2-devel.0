From: Jeff Liu <jeff.liu@oracle.com>
Date: Sun, 23 Jun 2013 18:39:16 +0800
Subject: [Ocfs2-devel] [PATCH] ocfs2: dlmlock_master should return
 DLM_NORMAL after adding lock to blocked list
In-Reply-To: <51C2E3F1.5020605@huawei.com>
References: <51C2E3F1.5020605@huawei.com>
Message-ID: <51C6D054.40100@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi Jiufei,

On 06/20/2013 07:13 PM, Xue jiufei wrote:

> Function dlmlock_master() returns DLM_RECOVERING/DLM_MIGRATING/
> DLM_FORWAR after adding lock to blocked list if lockres has the state
> DLM_LOCK_RES_RECOVERING/DLM_LOCK_RES_MIGRATING/
> DLM_LOCK_RES_IN_PROGRESS. so it will retry in dlmlock(). And this may
> cause dlm_thread fall into an infinite loop
> 
> 	Thread1                                  dlm_thread
> calls dlm_lock->dlmlock_master,				     
> if lockresA is in state
> DLM_LOCK_RES_RECOVERING, calls
> __dlm_wait_on_lockres() and waits
> until others threads clear this
> state; 
> 
> If cannot grant this lock,
> adding lock to blocked list,
> and return DLM_RECOVERING;	
> 
>                                         Grant this lock and move it to
>                                         grant list;
> 
> After a while, retry and 
> calls list_add_tail(), adding lock
> to blocked list again. 
> 
> Granted and blocked list of this lockres will become the following
> conditions:
>     lock_res->granted.next = dlm_lock->list_head;
>     lock_res->blocked.next = dlm_lock->list_head;
>     dlm_lock->list_head.next = dlm_lock_resource->blocked;
> When dlm_thread traverses the granted list, it will fall into an
> endless loop, checking dlm_lock.list_head, dlm_lock->list_head.next
> (i.e.lock_res->blocked), lock_res->blocked.next(i.e.dlm_lock.list_head
> again) .....

Thanks for your nice description of this problem and this fix looks good.
Let's waiting for an ACK from either Sunil, Mark or Joel.

-Jeff

> 
> Signed-off-by: joyce <xuejiufei@huawei.com>
> ---
>  fs/ocfs2/dlm/dlmlock.c |    1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/fs/ocfs2/dlm/dlmlock.c b/fs/ocfs2/dlm/dlmlock.c
> index 975810b..47e67c2 100644
> --- a/fs/ocfs2/dlm/dlmlock.c
> +++ b/fs/ocfs2/dlm/dlmlock.c
> @@ -178,6 +178,7 @@ static enum dlm_status dlmlock_master(struct dlm_ctxt *dlm,
>  				     lock->ml.node);
>  			}
>  		} else {
> +			status = DLM_NORMAL;
>  			dlm_lock_get(lock);
>  			list_add_tail(&lock->list, &res->blocked);
>  			kick_thread = 1;
