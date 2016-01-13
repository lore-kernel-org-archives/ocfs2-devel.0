From: Guozhonghua <guozhonghua@h3c.com>
Date: Wed, 13 Jan 2016 11:33:17 +0000
Subject: [Ocfs2-devel] Patch's talk
Message-ID: <71604351584F6A4EBAE558C676F37CA48292043B@H3CMLB14-EX.srv.huawei-3com.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi, Junxiao, Jiufei,

Before the function dlm_drop_lockres_ref called, the dlm spinlock is unlocked.
As the master node responded, the node will lock the dlm spinlock again and determine whether the res is used. In this window, the master of the res may down and recovered.
So res state may be recovering. So BUG may be occurred in the dlm_purge_lockres.

Thanks.
Guozhonghua.


Date: Mon, 14 Dec 2015 10:56:18 +0800
From: Junxiao Bi <junxiao.bi@oracle.com>
Subject: Re: [Ocfs2-devel] [PATCH V2] ocfs2/dlm: fix a race between
        purge and migration
To: xuejiufei at huawei.com, Andrew Morton <akpm@linux-foundation.org>,
        Mark Fasheh <mfasheh@suse.com>
Cc: "ocfs2-devel at oss.oracle.com" <ocfs2-devel@oss.oracle.com>
Message-ID: <566E2FD2.7050402@oracle.com>
Content-Type: text/plain; charset=windows-1252

On 12/11/2015 11:09 AM, Xue jiufei wrote:
> We found a race between purge and migration when doing code review.  Node
> A put lockres to purgelist before receiving the migrate message from node
> B which is the master. Node A call dlm_mig_lockres_handler to handle
> this message.
>
> dlm_mig_lockres_handler
>   dlm_lookup_lockres
>   >>>>>> race window, dlm_run_purge_list may run and send
>          deref message to master, waiting the response
>   spin_lock(&res->spinlock);
>   res->state |= DLM_LOCK_RES_MIGRATING;
>   spin_unlock(&res->spinlock);
>   dlm_mig_lockres_handler returns
>
>   >>>>>> dlm_thread receives the response from master for the deref
>   message and triggers the BUG because the lockres has the state
>   DLM_LOCK_RES_MIGRATING with the following message:
>
> dlm_purge_lockres:209 ERROR: 6633EB681FA7474A9C280A4E1A836F0F:
> res M0000000000000000030c0300000000 in use after deref
>
> Signed-off-by: Jiufei Xue <xuejiufei@huawei.com>
> Reviewed-by: Joseph Qi <joseph.qi@huawei.com>
Looks good.
Reviewed-by: Junxiao Bi <junxiao.bi@oracle.com>
> ---
>  fs/ocfs2/dlm/dlmrecovery.c | 9 ++++++++-
>  1 file changed, 8 insertions(+), 1 deletion(-)
>
> diff --git a/fs/ocfs2/dlm/dlmrecovery.c b/fs/ocfs2/dlm/dlmrecovery.c
> index 58eaa5c..4055909 100644
> --- a/fs/ocfs2/dlm/dlmrecovery.c
> +++ b/fs/ocfs2/dlm/dlmrecovery.c
> @@ -1373,6 +1373,7 @@ int dlm_mig_lockres_handler(struct o2net_msg *msg, u32 len, void *data,
>       char *buf = NULL;
>       struct dlm_work_item *item = NULL;
>       struct dlm_lock_resource *res = NULL;
> +     unsigned int hash;
>
>       if (!dlm_grab(dlm))
>               return -EINVAL;
> @@ -1400,7 +1401,10 @@ int dlm_mig_lockres_handler(struct o2net_msg *msg, u32 len, void *data,
>       /* lookup the lock to see if we have a secondary queue for this
>        * already...  just add the locks in and this will have its owner
>        * and RECOVERY flag changed when it completes. */
> -     res = dlm_lookup_lockres(dlm, mres->lockname, mres->lockname_len);
> +     hash = dlm_lockid_hash(mres->lockname, mres->lockname_len);
> +     spin_lock(&dlm->spinlock);
> +     res = __dlm_lookup_lockres(dlm, mres->lockname, mres->lockname_len,
> +                     hash);
>       if (res) {
>               /* this will get a ref on res */
>               /* mark it as recovering/migrating and hash it */
> @@ -1421,13 +1425,16 @@ int dlm_mig_lockres_handler(struct o2net_msg *msg, u32 len, void *data,
>                                    mres->lockname_len, mres->lockname);
>                               ret = -EFAULT;
>                               spin_unlock(&res->spinlock);
> +                             spin_unlock(&dlm->spinlock);
>                               dlm_lockres_put(res);
>                               goto leave;
>                       }
>                       res->state |= DLM_LOCK_RES_MIGRATING;
>               }
>               spin_unlock(&res->spinlock);
> +             spin_unlock(&dlm->spinlock);
>       } else {
> +             spin_unlock(&dlm->spinlock);
>               /* need to allocate, just like if it was
>                * mastered here normally  */
>               res = dlm_new_lockres(dlm, mres->lockname, mres->lockname_len);
>
-------------------------------------------------------------------------------------------------------------------------------------
????????????????????????????????????????
????????????????????????????????????????
????????????????????????????????????????
???
This e-mail and its attachments contain confidential information from H3C, which is
intended only for the person or entity whose address is listed above. Any use of the
information contained herein in any way (including, but not limited to, total or partial
disclosure, reproduction, or dissemination) by persons other than the intended
recipient(s) is prohibited. If you receive this e-mail in error, please notify the sender
by phone or email immediately and delete it!
