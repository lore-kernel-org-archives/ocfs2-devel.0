From: Mark Fasheh <mfasheh@suse.com>
Date: Thu, 5 May 2011 15:09:30 -0700
Subject: [Ocfs2-devel] [PATCH 1/3] ocfs2/dlm:
	dlm_is_lockres_migrateable() returns boolean
In-Reply-To: <1303859005-29529-1-git-send-email-sunil.mushran@oracle.com>
References: <1303859005-29529-1-git-send-email-sunil.mushran@oracle.com>
Message-ID: <20110505220930.GD17822@wotan.suse.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Tue, Apr 26, 2011 at 04:03:23PM -0700, Sunil Mushran wrote:
> Patch cleans up the gunk added by commit 388c4bcb4e63e88fb1f312a2f5f9eb2623afcf5b.
> dlm_is_lockres_migrateable() now returns 1 if lockresource is deemed
> migrateable and 0 if not.
> 
> Signed-off-by: Sunil Mushran <sunil.mushran@oracle.com>
> ---
>  fs/ocfs2/dlm/dlmcommon.h |   12 ++++
>  fs/ocfs2/dlm/dlmmaster.c |  135 +++++++++++++++++----------------------------
>  2 files changed, 63 insertions(+), 84 deletions(-)
> 
> diff --git a/fs/ocfs2/dlm/dlmcommon.h b/fs/ocfs2/dlm/dlmcommon.h
> index 4bdf7ba..1aac42a 100644
> --- a/fs/ocfs2/dlm/dlmcommon.h
> +++ b/fs/ocfs2/dlm/dlmcommon.h
> @@ -401,6 +401,18 @@ static inline int dlm_lvb_is_empty(char *lvb)
>  	return 1;
>  }
>  
> +static inline char *dlm_list_in_text(enum dlm_lockres_list idx)
> +{
> +	if (idx == DLM_GRANTED_LIST)
> +		return "granted";
> +	else if (idx == DLM_CONVERTING_LIST)
> +		return "converting";
> +	else if (idx == DLM_BLOCKED_LIST)
> +		return "blocked";
> +	else
> +		return "unknown";
> +}
> +
>  static inline struct list_head *
>  dlm_list_idx_to_ptr(struct dlm_lock_resource *res, enum dlm_lockres_list idx)
>  {
> diff --git a/fs/ocfs2/dlm/dlmmaster.c b/fs/ocfs2/dlm/dlmmaster.c
> index 9d67610..3e59ff9 100644
> --- a/fs/ocfs2/dlm/dlmmaster.c
> +++ b/fs/ocfs2/dlm/dlmmaster.c
> @@ -2339,65 +2339,55 @@ static void dlm_deref_lockres_worker(struct dlm_work_item *item, void *data)
>  	dlm_lockres_put(res);
>  }
>  
> -/* Checks whether the lockres can be migrated. Returns 0 if yes, < 0
> - * if not. If 0, numlocks is set to the number of locks in the lockres.
> +/*
> + * A migrateable resource is one that is :
> + * 1. locally mastered, and,
> + * 2. zero local locks, and,
> + * 3. one or more non-local locks, or, one or more references
> + * Returns 1 if yes, 0 if not.
>   */
>  static int dlm_is_lockres_migrateable(struct dlm_ctxt *dlm,
> -				      struct dlm_lock_resource *res,
> -				      int *numlocks,
> -				      int *hasrefs)
> +				      struct dlm_lock_resource *res)
>  {
> -	int ret;
> -	int i;
> -	int count = 0;
> +	enum dlm_lockres_list idx;
> +	int nonlocal = 0;
>  	struct list_head *queue;
>  	struct dlm_lock *lock;
> +	u64 cookie;
>  
>  	assert_spin_locked(&res->spinlock);
>  
> -	*numlocks = 0;
> -	*hasrefs = 0;
> -
> -	ret = -EINVAL;
> -	if (res->owner == DLM_LOCK_RES_OWNER_UNKNOWN) {
> -		mlog(0, "cannot migrate lockres with unknown owner!\n");
> -		goto leave;
> -	}
> -
> -	if (res->owner != dlm->node_num) {
> -		mlog(0, "cannot migrate lockres this node doesn't own!\n");
> -		goto leave;
> -	}
> +	if (res->owner != dlm->node_num)
> +		return 0;
>  
> -	ret = 0;
> -	queue = &res->granted;
> -	for (i = 0; i < 3; i++) {
> +        for (idx = DLM_GRANTED_LIST; idx <= DLM_BLOCKED_LIST; idx++) {
> +		queue = dlm_list_idx_to_ptr(res, idx);
>  		list_for_each_entry(lock, queue, list) {
> -			++count;
> -			if (lock->ml.node == dlm->node_num) {
> -				mlog(0, "found a lock owned by this node still "
> -				     "on the %s queue!  will not migrate this "
> -				     "lockres\n", (i == 0 ? "granted" :
> -						   (i == 1 ? "converting" :
> -						    "blocked")));
> -				ret = -ENOTEMPTY;
> -				goto leave;
> +			if (lock->ml.node != dlm->node_num) {
> +				nonlocal++;
> +				continue;
>  			}
> +			cookie = be64_to_cpu(lock->ml.cookie);
> +			mlog(0, "%s: Not migrateable res %.*s, lock %u:%llu on "
> +			     "%s list\n", dlm->name, res->lockname.len,
> +			     res->lockname.name,
> +			     dlm_get_lock_cookie_node(cookie),
> +			     dlm_get_lock_cookie_seq(cookie),
> +			     dlm_list_in_text(idx));
> +			return 0;
>  		}
> -		queue++;
>  	}
>  
> -	*numlocks = count;
> -
> -	count = find_next_bit(res->refmap, O2NM_MAX_NODES, 0);
> -	if (count < O2NM_MAX_NODES)
> -		*hasrefs = 1;
> +	if (!nonlocal) {
> +		nonlocal = find_next_bit(res->refmap, O2NM_MAX_NODES, 0);
> +		if (nonlocal >= O2NM_MAX_NODES)
> +			return 0;

Minor quibble, but can you use a new variable for these two lines? It took
me a minute to realize that what you were doing was gettting a refcount on
the lockres. Maybe:

if (!nonlocal) {
	/*
	 * We have no locks on the resource (local or remote). Check for
	 * references now.
	 */
	node_ref = find_next_bit(res->refmap, O2NM_MAX_NODES, 0);
	if (node_ref >= O2NM_MAX_NODES)
		return 0;
	}
}

Otherwise this looks much nicer than before, thanks.
	--Mark

--
Mark Fasheh
