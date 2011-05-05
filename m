From: Mark Fasheh <mfasheh@suse.com>
Date: Thu, 5 May 2011 15:24:17 -0700
Subject: [Ocfs2-devel] [PATCH 3/3] ocfs2/dlm: Do not migrate resource to
	a node that is leaving the domain
In-Reply-To: <1303859005-29529-3-git-send-email-sunil.mushran@oracle.com>
References: <1303859005-29529-1-git-send-email-sunil.mushran@oracle.com>
	<1303859005-29529-3-git-send-email-sunil.mushran@oracle.com>
Message-ID: <20110505222417.GF17822@wotan.suse.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Tue, Apr 26, 2011 at 04:03:25PM -0700, Sunil Mushran wrote:
> During dlm domain shutdown, o2dlm has to free all the lock resources. Ones that
> have no locks and references are freed. Ones that have locks and/or references
> are migrated to another node.
> 
> The first task in migration is finding a target. Currently we scan the lock
> resource and find one node that either has a lock or a reference. This is not
> very efficient in a parallel umount case as we might end up migrating the
> lock resource to a node which itself may have to migrate it to a third node.
> 
> The patch scans the dlm->exit_domain_map to ensure the target node is not
> leaving the domain. If no valid target node is found, o2dlm does not migrate
> the resource but instead waits for the unlock and deref messages that will
> allow it to free the resource.
> 
> Signed-off-by: Sunil Mushran <sunil.mushran@oracle.com>
> ---
>  fs/ocfs2/dlm/dlmdomain.c |   10 ++-
>  fs/ocfs2/dlm/dlmmaster.c |  139 ++++++++++++++++-----------------------------
>  2 files changed, 57 insertions(+), 92 deletions(-)
> 
> diff --git a/fs/ocfs2/dlm/dlmdomain.c b/fs/ocfs2/dlm/dlmdomain.c
> index 3aff23f..6ed6b95 100644
> --- a/fs/ocfs2/dlm/dlmdomain.c
> +++ b/fs/ocfs2/dlm/dlmdomain.c
> @@ -451,14 +451,18 @@ redo_bucket:
>  			dropped = dlm_empty_lockres(dlm, res);
>  
>  			spin_lock(&res->spinlock);
> -			__dlm_lockres_calc_usage(dlm, res);
> -			iter = res->hash_node.next;
> +			if (dropped)
> +				__dlm_lockres_calc_usage(dlm, res);
> +			else
> +				iter = res->hash_node.next;
>  			spin_unlock(&res->spinlock);
>  
>  			dlm_lockres_put(res);
>  
> -			if (dropped)
> +			if (dropped) {
> +				cond_resched_lock(&dlm->spinlock);
>  				goto redo_bucket;
> +			}
>  		}
>  		cond_resched_lock(&dlm->spinlock);
>  		num += n;
> diff --git a/fs/ocfs2/dlm/dlmmaster.c b/fs/ocfs2/dlm/dlmmaster.c
> index 3e59ff9..4499d86 100644
> --- a/fs/ocfs2/dlm/dlmmaster.c
> +++ b/fs/ocfs2/dlm/dlmmaster.c
> @@ -2396,8 +2396,7 @@ static int dlm_is_lockres_migrateable(struct dlm_ctxt *dlm,
>  
>  
>  static int dlm_migrate_lockres(struct dlm_ctxt *dlm,
> -			       struct dlm_lock_resource *res,
> -			       u8 target)
> +			       struct dlm_lock_resource *res, u8 target)
>  {
>  	struct dlm_master_list_entry *mle = NULL;
>  	struct dlm_master_list_entry *oldmle = NULL;
> @@ -2411,25 +2410,15 @@ static int dlm_migrate_lockres(struct dlm_ctxt *dlm,
>  	if (!dlm_grab(dlm))
>  		return -EINVAL;
>  
> +	BUG_ON(target == O2NM_MAX_NODES);
> +
>  	name = res->lockname.name;
>  	namelen = res->lockname.len;
>  
> -	mlog(0, "%s: Migrating %.*s to %u\n", dlm->name, namelen, name, target);
> -
> -	/* Ensure this lockres is a proper candidate for migration */
> -	spin_lock(&res->spinlock);
> -	ret = dlm_is_lockres_migrateable(dlm, res);
> -	spin_unlock(&res->spinlock);
> -
> -	/* No work to do */
> -	if (!ret)
> -		goto leave;
> -
> -	/*
> -	 * preallocate up front
> -	 * if this fails, abort
> -	 */
> +	mlog(0, "%s: Migrating %.*s to node %u\n", dlm->name, namelen, name,
> +	     target);
>  
> +	/* preallocate up front. if this fails, abort */
>  	ret = -ENOMEM;
>  	mres = (struct dlm_migratable_lockres *) __get_free_page(GFP_NOFS);
>  	if (!mres) {
> @@ -2445,35 +2434,10 @@ static int dlm_migrate_lockres(struct dlm_ctxt *dlm,
>  	ret = 0;
>  
>  	/*
> -	 * find a node to migrate the lockres to
> -	 */
> -
> -	spin_lock(&dlm->spinlock);
> -	/* pick a new node */
> -	if (!test_bit(target, dlm->domain_map) ||
> -	    target >= O2NM_MAX_NODES) {
> -		target = dlm_pick_migration_target(dlm, res);
> -	}
> -	mlog(0, "%s: res %.*s, Node %u chosen for migration\n", dlm->name,
> -	     namelen, name, target);
> -
> -	if (target >= O2NM_MAX_NODES ||
> -	    !test_bit(target, dlm->domain_map)) {
> -		/* target chosen is not alive */
> -		ret = -EINVAL;
> -	}
> -
> -	if (ret) {
> -		spin_unlock(&dlm->spinlock);
> -		goto fail;
> -	}
> -
> -	mlog(0, "continuing with target = %u\n", target);
> -
> -	/*
>  	 * clear any existing master requests and
>  	 * add the migration mle to the list
>  	 */
> +	spin_lock(&dlm->spinlock);
>  	spin_lock(&dlm->master_lock);
>  	ret = dlm_add_migration_mle(dlm, res, mle, &oldmle, name,
>  				    namelen, target, dlm->node_num);
> @@ -2514,6 +2478,7 @@ fail:
>  			dlm_put_mle(mle);
>  		} else if (mle) {
>  			kmem_cache_free(dlm_mle_cache, mle);
> +			mle = NULL;
>  		}
>  		goto leave;
>  	}
> @@ -2632,7 +2597,6 @@ leave:
>  	if (wake)
>  		wake_up(&res->wq);
>  
> -	/* TODO: cleanup */
>  	if (mres)
>  		free_page((unsigned long)mres);
>  
> @@ -2657,28 +2621,28 @@ leave:
>   */
>  int dlm_empty_lockres(struct dlm_ctxt *dlm, struct dlm_lock_resource *res)
>  {
> -	int mig, ret;
> +	int ret;
>  	int lock_dropped = 0;
> +	u8 target = O2NM_MAX_NODES;
>  
>  	assert_spin_locked(&dlm->spinlock);
>  
>  	spin_lock(&res->spinlock);
> -	mig = dlm_is_lockres_migrateable(dlm, res);
> +	if (dlm_is_lockres_migrateable(dlm, res))
> +		target = dlm_pick_migration_target(dlm, res);
>  	spin_unlock(&res->spinlock);
> -	if (!mig)
> +
> +	if (target == O2NM_MAX_NODES)
>  		goto leave;
>  
>  	/* Wheee! Migrate lockres here! Will sleep so drop spinlock. */
>  	spin_unlock(&dlm->spinlock);
>  	lock_dropped = 1;
> -	while (1) {
> -		ret = dlm_migrate_lockres(dlm, res, O2NM_MAX_NODES);
> -		if (ret >= 0)
> -			break;
> -		mlog(0, "%s: res %.*s, Migrate failed, retrying\n", dlm->name,
> -		     res->lockname.len, res->lockname.name);
> -		msleep(DLM_MIGRATION_RETRY_MS);
> -	}
> +	ret = dlm_migrate_lockres(dlm, res, target);
> +	if (ret)
> +		mlog(0, "%s: res %.*s, Migrate to node %u failed with %d\n",
> +		     dlm->name, res->lockname.len, res->lockname.name,
> +		     target, ret);
>  	spin_lock(&dlm->spinlock);
>  leave:
>  	return lock_dropped;
> @@ -2862,61 +2826,58 @@ static void dlm_remove_nonlocal_locks(struct dlm_ctxt *dlm,
>  	}
>  }
>  
> -/* for now this is not too intelligent.  we will
> - * need stats to make this do the right thing.
> - * this just finds the first lock on one of the
> - * queues and uses that node as the target. */
> +/*
> + * Pick a node to migrate the lock resource to. This function selects a
> + * potential target based first on the locks and then on refmap. It skips
> + * nodes that are in the process of exiting the domain.
> + */
>  static u8 dlm_pick_migration_target(struct dlm_ctxt *dlm,
>  				    struct dlm_lock_resource *res)
>  {
> -	int i;
> +	enum dlm_lockres_list idx;
>  	struct list_head *queue = &res->granted;
>  	struct dlm_lock *lock;
>  	int nodenum;
>  
>  	assert_spin_locked(&dlm->spinlock);
> +	assert_spin_locked(&res->spinlock);
>  
> -	spin_lock(&res->spinlock);
> -	for (i=0; i<3; i++) {
> +	/* Go through all the locks */
> +	for (idx = DLM_GRANTED_LIST; idx <= DLM_BLOCKED_LIST; idx++) {
> +		queue = dlm_list_idx_to_ptr(res, idx);
>  		list_for_each_entry(lock, queue, list) {
> -			/* up to the caller to make sure this node
> -			 * is alive */
> -			if (lock->ml.node != dlm->node_num) {
> -				spin_unlock(&res->spinlock);
> -				return lock->ml.node;
> -			}
> +			if (lock->ml.node == dlm->node_num)
> +				continue;
> +			if (test_bit(lock->ml.node, dlm->exit_domain_map))
> +				continue;
> +			if (!test_bit(lock->ml.node, dlm->domain_map))
> +				continue;
> +			nodenum = lock->ml.node;
> +			goto bail;
>  		}
> -		queue++;
> -	}
> -
> -	nodenum = find_next_bit(res->refmap, O2NM_MAX_NODES, 0);
> -	if (nodenum < O2NM_MAX_NODES) {
> -		spin_unlock(&res->spinlock);
> -		return nodenum;
>  	}
> -	spin_unlock(&res->spinlock);
> -	mlog(0, "have not found a suitable target yet! checking domain map\n");
>  
> -	/* ok now we're getting desperate.  pick anyone alive. */
> +	/* Go thru the refmap */
>  	nodenum = -1;
>  	while (1) {
> -		nodenum = find_next_bit(dlm->domain_map,
> -					O2NM_MAX_NODES, nodenum+1);
> -		mlog(0, "found %d in domain map\n", nodenum);
> +		nodenum = find_next_bit(res->refmap, O2NM_MAX_NODES,
> +					nodenum + 1);
>  		if (nodenum >= O2NM_MAX_NODES)
>  			break;
> -		if (nodenum != dlm->node_num) {
> -			mlog(0, "picking %d\n", nodenum);
> -			return nodenum;
> -		}
> +		if (nodenum == dlm->node_num)
> +			continue;
> +		if (test_bit(nodenum, dlm->exit_domain_map))
> +			continue;
> +		if (!test_bit(lock->ml.node, dlm->domain_map))
> +			continue;

If the lock's owning node isn't in the domain map, we're just ignoring it? I
guess I'm not following what the last 'if (!test_bit(lock->ml.node,
dlm->domain_map))' line is trying to do.
	--Mark

PS: I'm rusty on fs/ocfs2/dlm stuff as you can tell :)

--
Mark Fasheh
