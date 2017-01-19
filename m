From: Eric Ren <zren@suse.com>
Date: Thu, 19 Jan 2017 10:37:44 +0800
Subject: [Ocfs2-devel] [PATCH v3] ocfs2/dlm: Optimization of code while
 free dead node locks.
In-Reply-To: <71604351584F6A4EBAE558C676F37CA4C4AF898E@H3CMLB12-EX.srv.huawei-3com.com>
References: <71604351584F6A4EBAE558C676F37CA4C4AF898E@H3CMLB12-EX.srv.huawei-3com.com>
Message-ID: <9b58aba6-1094-1df8-ecc6-9111de208d06@suse.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi,

On 01/17/2017 07:22 PM, Guozhonghua wrote:
> Three loops can be optimized into one and its sub loops, so as small code can do the same work.  ===> (1)
>
>  From 8a1e682503f4e5a5299fe8316cbf559f9b9701f1 Mon Sep 17 00:00:00 2001
> From: Guozhonghua <guozhonghua@h3c.com>
> Date: Fri, 13 Jan 2017 11:27:32 +0800
> Subject: [PATCH] Optimization of code while free dead locks, changed for
>   reviews.
>                                                                                                  ===> (2)
>
> Signed-off-by: Guozhonghua <guozhonghua@h3c.com>
The patch looks good to me, except some formatting issues:
1. The commit message at (1) should be placed at (2);
2. Change log is still missing;

I think it's not a big deal, though. The fix is quite simple. Wish your patch has good
formatting next time;-)

Reviewed-by: Eric Ren <zren@suse.com>

Eric

> ---
>   fs/ocfs2/dlm/dlmrecovery.c |   39 ++++++++++++++-------------------------
>   1 file changed, 14 insertions(+), 25 deletions(-)
>
> diff --git a/fs/ocfs2/dlm/dlmrecovery.c b/fs/ocfs2/dlm/dlmrecovery.c
> index dd5cb8b..93b71dd 100644
> --- a/fs/ocfs2/dlm/dlmrecovery.c
> +++ b/fs/ocfs2/dlm/dlmrecovery.c
> @@ -2268,6 +2268,8 @@ static void dlm_free_dead_locks(struct dlm_ctxt *dlm,
>   {
>          struct dlm_lock *lock, *next;
>          unsigned int freed = 0;
> +       struct list_head *queue = NULL;
> +       int i;
>
>          /* this node is the lockres master:
>           * 1) remove any stale locks for the dead node
> @@ -2280,31 +2282,18 @@ static void dlm_free_dead_locks(struct dlm_ctxt *dlm,
>           * to force the DLM_UNLOCK_FREE_LOCK action so as to free the locks */
>
>          /* TODO: check pending_asts, pending_basts here */
> -       list_for_each_entry_safe(lock, next, &res->granted, list) {
> -               if (lock->ml.node == dead_node) {
> -                       list_del_init(&lock->list);
> -                       dlm_lock_put(lock);
> -                       /* Can't schedule DLM_UNLOCK_FREE_LOCK - do manually */
> -                       dlm_lock_put(lock);
> -                       freed++;
> -               }
> -       }
> -       list_for_each_entry_safe(lock, next, &res->converting, list) {
> -               if (lock->ml.node == dead_node) {
> -                       list_del_init(&lock->list);
> -                       dlm_lock_put(lock);
> -                       /* Can't schedule DLM_UNLOCK_FREE_LOCK - do manually */
> -                       dlm_lock_put(lock);
> -                       freed++;
> -               }
> -       }
> -       list_for_each_entry_safe(lock, next, &res->blocked, list) {
> -               if (lock->ml.node == dead_node) {
> -                       list_del_init(&lock->list);
> -                       dlm_lock_put(lock);
> -                       /* Can't schedule DLM_UNLOCK_FREE_LOCK - do manually */
> -                       dlm_lock_put(lock);
> -                       freed++;
> +       for (i = DLM_GRANTED_LIST; i <= DLM_BLOCKED_LIST; i++) {
> +               queue = dlm_list_idx_to_ptr(res, i);
> +               list_for_each_entry_safe(lock, next, queue, list) {
> +                       if (lock->ml.node == dead_node) {
> +                               list_del_init(&lock->list);
> +                               dlm_lock_put(lock);
> +                               /* Can't schedule DLM_UNLOCK_FREE_LOCK
> +                                * do manually
> +                                */
> +                               dlm_lock_put(lock);
> +                               freed++;
> +                       }
>                  }
>          }
>
> --
> 1.7.9.5
> -------------------------------------------------------------------------------------------------------------------------------------
> ????????????????????????????????????????
> ????????????????????????????????????????
> ????????????????????????????????????????
> ???
> This e-mail and its attachments contain confidential information from H3C, which is
> intended only for the person or entity whose address is listed above. Any use of the
> information contained herein in any way (including, but not limited to, total or partial
> disclosure, reproduction, or dissemination) by persons other than the intended
> recipient(s) is prohibited. If you receive this e-mail in error, please notify the sender
> by phone or email immediately and delete it!
> _______________________________________________
> Ocfs2-devel mailing list
> Ocfs2-devel at oss.oracle.com
> https://oss.oracle.com/mailman/listinfo/ocfs2-devel
