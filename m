From: Joel Becker <Joel.Becker@oracle.com>
Date: Thu, 9 Dec 2010 17:44:51 -0800
Subject: [Ocfs2-devel] [PATCH 2/2] ocfs2/dlm: Migrate lockres with no
 locks if it has a reference
In-Reply-To: <1290208010-2603-2-git-send-email-sunil.mushran@oracle.com>
References: <1290208010-2603-1-git-send-email-sunil.mushran@oracle.com>
	<1290208010-2603-2-git-send-email-sunil.mushran@oracle.com>
Message-ID: <20101210014451.GK11104@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Fri, Nov 19, 2010 at 03:06:50PM -0800, Sunil Mushran wrote:
> o2dlm was not migrating resources with zero locks because it assumed that that
> resource would get purged by dlm_thread. However, some usage patterns involve
> creating and dropping locks at a high rate leading to the migrate thread seeing
> zero locks but the purge thread seeing an active reference. When this happens,
> the dlm_thread cannot purge the resource and the migrate thread sees no reason
> to migrate that resource. The spell is broken when the migrate thread catches
> the resource with a lock.
> 
> The fix is to make the migrate thread also consider the reference map.
> 
> This usage pattern can be triggered by userspace on userdlm locks and flocks.
> 
> Signed-off-by: Sunil Mushran <sunil.mushran@oracle.com>

This patch is now in the 'fixes' branch of ocfs2.git.

Joel

> ---
>  fs/ocfs2/dlm/dlmmaster.c |   40 +++++++++++++++++++++++++++-------------
>  1 files changed, 27 insertions(+), 13 deletions(-)
> 
> diff --git a/fs/ocfs2/dlm/dlmmaster.c b/fs/ocfs2/dlm/dlmmaster.c
> index f564b0e..59f0f6b 100644
> --- a/fs/ocfs2/dlm/dlmmaster.c
> +++ b/fs/ocfs2/dlm/dlmmaster.c
> @@ -2346,7 +2346,8 @@ static void dlm_deref_lockres_worker(struct dlm_work_item *item, void *data)
>   */
>  static int dlm_is_lockres_migrateable(struct dlm_ctxt *dlm,
>  				      struct dlm_lock_resource *res,
> -				      int *numlocks)
> +				      int *numlocks,
> +				      int *hasrefs)
>  {
>  	int ret;
>  	int i;
> @@ -2356,6 +2357,9 @@ static int dlm_is_lockres_migrateable(struct dlm_ctxt *dlm,
>  
>  	assert_spin_locked(&res->spinlock);
>  
> +	*numlocks = 0;
> +	*hasrefs = 0;
> +
>  	ret = -EINVAL;
>  	if (res->owner == DLM_LOCK_RES_OWNER_UNKNOWN) {
>  		mlog(0, "cannot migrate lockres with unknown owner!\n");
> @@ -2386,7 +2390,13 @@ static int dlm_is_lockres_migrateable(struct dlm_ctxt *dlm,
>  	}
>  
>  	*numlocks = count;
> -	mlog(0, "migrateable lockres having %d locks\n", *numlocks);
> +
> +	count = find_next_bit(res->refmap, O2NM_MAX_NODES, 0);
> +	if (count < O2NM_MAX_NODES)
> +		*hasrefs = 1;
> +
> +	mlog(0, "%s: res %.*s, Migrateable, locks %d, refs %d\n", dlm->name,
> +	     res->lockname.len, res->lockname.name, *numlocks, *hasrefs);
>  
>  leave:
>  	return ret;
> @@ -2408,7 +2418,7 @@ static int dlm_migrate_lockres(struct dlm_ctxt *dlm,
>  	const char *name;
>  	unsigned int namelen;
>  	int mle_added = 0;
> -	int numlocks;
> +	int numlocks, hasrefs;
>  	int wake = 0;
>  
>  	if (!dlm_grab(dlm))
> @@ -2417,13 +2427,13 @@ static int dlm_migrate_lockres(struct dlm_ctxt *dlm,
>  	name = res->lockname.name;
>  	namelen = res->lockname.len;
>  
> -	mlog(0, "migrating %.*s to %u\n", namelen, name, target);
> +	mlog(0, "%s: Migrating %.*s to %u\n", dlm->name, namelen, name, target);
>  
>  	/*
>  	 * ensure this lockres is a proper candidate for migration
>  	 */
>  	spin_lock(&res->spinlock);
> -	ret = dlm_is_lockres_migrateable(dlm, res, &numlocks);
> +	ret = dlm_is_lockres_migrateable(dlm, res, &numlocks, &hasrefs);
>  	if (ret < 0) {
>  		spin_unlock(&res->spinlock);
>  		goto leave;
> @@ -2431,10 +2441,8 @@ static int dlm_migrate_lockres(struct dlm_ctxt *dlm,
>  	spin_unlock(&res->spinlock);
>  
>  	/* no work to do */
> -	if (numlocks == 0) {
> -		mlog(0, "no locks were found on this lockres! done!\n");
> +	if (numlocks == 0 && !hasrefs)
>  		goto leave;
> -	}
>  
>  	/*
>  	 * preallocate up front
> @@ -2459,14 +2467,14 @@ static int dlm_migrate_lockres(struct dlm_ctxt *dlm,
>  	 * find a node to migrate the lockres to
>  	 */
>  
> -	mlog(0, "picking a migration node\n");
>  	spin_lock(&dlm->spinlock);
>  	/* pick a new node */
>  	if (!test_bit(target, dlm->domain_map) ||
>  	    target >= O2NM_MAX_NODES) {
>  		target = dlm_pick_migration_target(dlm, res);
>  	}
> -	mlog(0, "node %u chosen for migration\n", target);
> +	mlog(0, "%s: res %.*s, Node %u chosen for migration\n", dlm->name,
> +	     namelen, name, target);
>  
>  	if (target >= O2NM_MAX_NODES ||
>  	    !test_bit(target, dlm->domain_map)) {
> @@ -2667,7 +2675,7 @@ int dlm_empty_lockres(struct dlm_ctxt *dlm, struct dlm_lock_resource *res)
>  {
>  	int ret;
>  	int lock_dropped = 0;
> -	int numlocks;
> +	int numlocks, hasrefs;
>  
>  	spin_lock(&res->spinlock);
>  	if (res->owner != dlm->node_num) {
> @@ -2681,8 +2689,8 @@ int dlm_empty_lockres(struct dlm_ctxt *dlm, struct dlm_lock_resource *res)
>  	}
>  
>  	/* No need to migrate a lockres having no locks */
> -	ret = dlm_is_lockres_migrateable(dlm, res, &numlocks);
> -	if (ret >= 0 && numlocks == 0) {
> +	ret = dlm_is_lockres_migrateable(dlm, res, &numlocks, &hasrefs);
> +	if (ret >= 0 && numlocks == 0 && !hasrefs) {
>  		spin_unlock(&res->spinlock);
>  		goto leave;
>  	}
> @@ -2915,6 +2923,12 @@ static u8 dlm_pick_migration_target(struct dlm_ctxt *dlm,
>  		}
>  		queue++;
>  	}
> +
> +	nodenum = find_next_bit(res->refmap, O2NM_MAX_NODES, 0);
> +	if (nodenum < O2NM_MAX_NODES) {
> +		spin_unlock(&res->spinlock);
> +		return nodenum;
> +	}
>  	spin_unlock(&res->spinlock);
>  	mlog(0, "have not found a suitable target yet! checking domain map\n");
>  
> -- 
> 1.5.6.5
> 

-- 

"Sometimes one pays most for the things one gets for nothing."
        - Albert Einstein

Joel Becker
Senior Development Manager
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
