From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Thu, 17 Jun 2010 19:11:37 -0700
Subject: [Ocfs2-devel] [PATCH 2/2] ocfs2: o2dlm fix race in purge
 lockres and newlock (orabug 9094491)
In-Reply-To: <1276663383-8238-2-git-send-email-srinivas.eeda@oracle.com>
References: <1276663383-8238-1-git-send-email-srinivas.eeda@oracle.com>
	<1276663383-8238-2-git-send-email-srinivas.eeda@oracle.com>
Message-ID: <4C1AD5D9.8010204@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

This patch looks ok on the surface. Should be usable. But checking into
the repo is another matter.

My problem is that this flag is very much like inflight_locks but
is not the same. inflight_locks are taken only on lockres' that are
mastered by the node. This new flag does the same but for non
mastered locks too. A better solution will be to merge the two.
And that means cleaning up inflight_locks.

The reason for the NAK for check in is that the code is adding
more messiness to an area that is already very messy.

Sunil

On 06/15/2010 09:43 PM, Srinivas Eeda wrote:
> This patch fixes the following hole.
> dlmlock tries to create a new lock on a lockres that is on purge list. It calls
> dlm_get_lockresource and later adds a lock to blocked list. But in this window,
> dlm_thread can purge the lockres and unhash it. This will cause a BUG, as when
> the AST comes back from the master lockres is not found
>
> This patch marks the lockres with a new state DLM_LOCK_RES_IN_USE which would
> protect lockres from dlm_thread purging it.
>
> Signed-off-by: Srinivas Eeda<srinivas.eeda@oracle.com>
> ---
>   fs/ocfs2/dlm/dlmcommon.h |    1 +
>   fs/ocfs2/dlm/dlmlock.c   |    4 ++++
>   fs/ocfs2/dlm/dlmmaster.c |    5 ++++-
>   fs/ocfs2/dlm/dlmthread.c |    1 +
>   4 files changed, 10 insertions(+), 1 deletions(-)
>
> diff --git a/fs/ocfs2/dlm/dlmcommon.h b/fs/ocfs2/dlm/dlmcommon.h
> index 0102be3..6cf3c08 100644
> --- a/fs/ocfs2/dlm/dlmcommon.h
> +++ b/fs/ocfs2/dlm/dlmcommon.h
> @@ -279,6 +279,7 @@ static inline void __dlm_set_joining_node(struct dlm_ctxt *dlm,
>   #define DLM_LOCK_RES_DIRTY                0x00000008
>   #define DLM_LOCK_RES_IN_PROGRESS          0x00000010
>   #define DLM_LOCK_RES_MIGRATING            0x00000020
> +#define DLM_LOCK_RES_IN_USE               0x00000100
>   #define DLM_LOCK_RES_DROPPING_REF         0x00000040
>   #define DLM_LOCK_RES_BLOCK_DIRTY          0x00001000
>   #define DLM_LOCK_RES_SETREF_INPROG        0x00002000
> diff --git a/fs/ocfs2/dlm/dlmlock.c b/fs/ocfs2/dlm/dlmlock.c
> index 7333377..501ac40 100644
> --- a/fs/ocfs2/dlm/dlmlock.c
> +++ b/fs/ocfs2/dlm/dlmlock.c
> @@ -134,6 +134,8 @@ static enum dlm_status dlmlock_master(struct dlm_ctxt *dlm,
>   	if (status != DLM_NORMAL&&
>   	lock->ml.node != dlm->node_num) {
>   		/* erf.  state changed after lock was dropped. */
> +		/* DLM_LOCK_RES_IN_USE is set in dlm_get_lock_resource */
> +		res->state&= ~DLM_LOCK_RES_IN_USE;
>   		spin_unlock(&res->spinlock);
>   		dlm_error(status);
>   		return status;
> @@ -180,6 +182,7 @@ static enum dlm_status dlmlock_master(struct dlm_ctxt *dlm,
>   			kick_thread = 1;
>   		}
>   	}
> +	res->state&= ~DLM_LOCK_RES_IN_USE;
>   	/* reduce the inflight count, this may result in the lockres
>   	 * being purged below during calc_usage */
>   	if (lock->ml.node == dlm->node_num)
> @@ -246,6 +249,7 @@ static enum dlm_status dlmlock_remote(struct dlm_ctxt *dlm,
>
>   	spin_lock(&res->spinlock);
>   	res->state&= ~DLM_LOCK_RES_IN_PROGRESS;
> +	res->state&= ~DLM_LOCK_RES_IN_USE;
>   	lock->lock_pending = 0;
>   	if (status != DLM_NORMAL) {
>   		if (status == DLM_RECOVERING&&
> diff --git a/fs/ocfs2/dlm/dlmmaster.c b/fs/ocfs2/dlm/dlmmaster.c
> index 9289b43..f0f2d97 100644
> --- a/fs/ocfs2/dlm/dlmmaster.c
> +++ b/fs/ocfs2/dlm/dlmmaster.c
> @@ -719,6 +719,7 @@ lookup:
>   	if (tmpres) {
>   		int dropping_ref = 0;
>
> +		tmpres->state |= DLM_LOCK_RES_IN_USE;
>   		spin_unlock(&dlm->spinlock);
>
>   		spin_lock(&tmpres->spinlock);
> @@ -731,8 +732,10 @@ lookup:
>   		if (tmpres->owner == dlm->node_num) {
>   			BUG_ON(tmpres->state&  DLM_LOCK_RES_DROPPING_REF);
>   			dlm_lockres_grab_inflight_ref(dlm, tmpres);
> -		} else if (tmpres->state&  DLM_LOCK_RES_DROPPING_REF)
> +		} else if (tmpres->state&  DLM_LOCK_RES_DROPPING_REF) {
> +			tmpres->state&= ~DLM_LOCK_RES_IN_USE;
>   			dropping_ref = 1;
> +		}
>   		spin_unlock(&tmpres->spinlock);
>
>   		/* wait until done messaging the master, drop our ref to allow
> diff --git a/fs/ocfs2/dlm/dlmthread.c b/fs/ocfs2/dlm/dlmthread.c
> index fb0be6c..2b82e0b 100644
> --- a/fs/ocfs2/dlm/dlmthread.c
> +++ b/fs/ocfs2/dlm/dlmthread.c
> @@ -93,6 +93,7 @@ int __dlm_lockres_has_locks(struct dlm_lock_resource *res)
>   int __dlm_lockres_unused(struct dlm_lock_resource *res)
>   {
>   	if (!__dlm_lockres_has_locks(res)&&
> +	    !(res->state&  DLM_LOCK_RES_IN_USE)&&
>   	(list_empty(&res->dirty)&&  !(res->state&  DLM_LOCK_RES_DIRTY))) {
>   		/* try not to scan the bitmap unless the first two
>   		 * conditions are already true */
>    
