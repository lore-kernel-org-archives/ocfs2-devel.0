From: Coly Li <coly.li@suse.de>
Date: Wed, 24 Dec 2008 05:05:33 +0800
Subject: [Ocfs2-devel] [PATCH 9/9] ocfs2/dlm: Fix race during lockres
 mastery
In-Reply-To: <1229471363-15887-10-git-send-email-sunil.mushran@oracle.com>
References: <1229471363-15887-1-git-send-email-sunil.mushran@oracle.com>
	<1229471363-15887-10-git-send-email-sunil.mushran@oracle.com>
Message-ID: <4951529D.2030803@suse.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi Sunil,

I do not find this patch in upstream yet. Do we have a recent plan to push this patch into upstream
? Once this patch get merged into linus tree, I can add it into sles10 sp2 kernel.

Thanks.

Sunil Mushran Wrote:
> dlm_get_lock_resource() is supposed to return a lock resource with a proper
> master. If multiple concurrent threads attempt to lookup the lockres for the
> same lockid while the lock mastery in underway, one or more threads are likely
> to return a lockres without a proper master.
> 
> This patch makes the threads wait in dlm_get_lock_resource() while the mastery
> is underway, ensuring all threads return the lockres with a proper master.
> 
> This issue is known to be limited to users using the flock() syscall. For all
> other fs operations, the ocfs2 dlmglue layer serializes the dlm op for each
> lockid.
> 
> Patch fixes Novell bz#425491
> https://bugzilla.novell.com/show_bug.cgi?id=425491
> 
> Users encountering this bug will see flock() return EINVAL and dmesg have the
> following error:
> ERROR: Dlm error "DLM_BADARGS" while calling dlmlock on resource <LOCKID>: bad api args
> 
> Reported-by: Coly Li <coyli@suse.de>
> Signed-off-by: Sunil Mushran <sunil.mushran@oracle.com>
> ---
>  fs/ocfs2/dlm/dlmmaster.c |    9 ++++++++-
>  1 files changed, 8 insertions(+), 1 deletions(-)
> 
> diff --git a/fs/ocfs2/dlm/dlmmaster.c b/fs/ocfs2/dlm/dlmmaster.c
> index cbf3abe..54e182a 100644
> --- a/fs/ocfs2/dlm/dlmmaster.c
> +++ b/fs/ocfs2/dlm/dlmmaster.c
> @@ -732,14 +732,21 @@ lookup:
>  	if (tmpres) {
>  		int dropping_ref = 0;
>  
> +		spin_unlock(&dlm->spinlock);
> +
>  		spin_lock(&tmpres->spinlock);
> +		/* We wait for the other thread that is mastering the resource */
> +		if (tmpres->owner == DLM_LOCK_RES_OWNER_UNKNOWN) {
> +			__dlm_wait_on_lockres(tmpres);
> +			BUG_ON(tmpres->owner == DLM_LOCK_RES_OWNER_UNKNOWN);
> +		}
> +
>  		if (tmpres->owner == dlm->node_num) {
>  			BUG_ON(tmpres->state & DLM_LOCK_RES_DROPPING_REF);
>  			dlm_lockres_grab_inflight_ref(dlm, tmpres);
>  		} else if (tmpres->state & DLM_LOCK_RES_DROPPING_REF)
>  			dropping_ref = 1;
>  		spin_unlock(&tmpres->spinlock);
> -		spin_unlock(&dlm->spinlock);
>  
>  		/* wait until done messaging the master, drop our ref to allow
>  		 * the lockres to be purged, start over. */

-- 
Coly Li
SuSE PRC Labs
