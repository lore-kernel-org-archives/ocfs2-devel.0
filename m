From: Joel Becker <Joel.Becker@oracle.com>
Date: Thu, 16 Dec 2010 00:51:30 -0800
Subject: [Ocfs2-devel] [PATCH 1/2] ocfs2/dlm: Cleanup mlogs in
 dlmthread.c, dlmast.c and dlmdomain.c
In-Reply-To: <1290208010-2603-1-git-send-email-sunil.mushran@oracle.com>
References: <1290208010-2603-1-git-send-email-sunil.mushran@oracle.com>
Message-ID: <20101216085129.GM15545@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Fri, Nov 19, 2010 at 03:06:49PM -0800, Sunil Mushran wrote:
> Add the domain name and the resource name in the mlogs.
> 
> Signed-off-by: Sunil Mushran <sunil.mushran@oracle.com>

This is now in the merge-window branch of ocfs2.git.

Joel

> ---
>  fs/ocfs2/dlm/dlmast.c    |   76 ++++++++++++++++++--------
>  fs/ocfs2/dlm/dlmdomain.c |    2 -
>  fs/ocfs2/dlm/dlmthread.c |  132 ++++++++++++++++++++++++----------------------
>  3 files changed, 120 insertions(+), 90 deletions(-)
> 
> diff --git a/fs/ocfs2/dlm/dlmast.c b/fs/ocfs2/dlm/dlmast.c
> index f449991..3a3ed4b 100644
> --- a/fs/ocfs2/dlm/dlmast.c
> +++ b/fs/ocfs2/dlm/dlmast.c
> @@ -90,19 +90,29 @@ static int dlm_should_cancel_bast(struct dlm_ctxt *dlm, struct dlm_lock *lock)
>  
>  void __dlm_queue_ast(struct dlm_ctxt *dlm, struct dlm_lock *lock)
>  {
> -	mlog_entry_void();
> +	struct dlm_lock_resource *res;
>  
>  	BUG_ON(!dlm);
>  	BUG_ON(!lock);
>  
> +	res = lock->lockres;
> +
>  	assert_spin_locked(&dlm->ast_lock);
> +
>  	if (!list_empty(&lock->ast_list)) {
> -		mlog(ML_ERROR, "ast list not empty!!  pending=%d, newlevel=%d\n",
> +		mlog(ML_ERROR, "%s: res %.*s, lock %u:%llu, "
> +		     "AST list not empty, pending %d, newlevel %d\n",
> +		     dlm->name, res->lockname.len, res->lockname.name,
> +		     dlm_get_lock_cookie_node(be64_to_cpu(lock->ml.cookie)),
> +		     dlm_get_lock_cookie_seq(be64_to_cpu(lock->ml.cookie)),
>  		     lock->ast_pending, lock->ml.type);
>  		BUG();
>  	}
>  	if (lock->ast_pending)
> -		mlog(0, "lock has an ast getting flushed right now\n");
> +		mlog(0, "%s: res %.*s, lock %u:%llu, AST getting flushed\n",
> +		     dlm->name, res->lockname.len, res->lockname.name,
> +		     dlm_get_lock_cookie_node(be64_to_cpu(lock->ml.cookie)),
> +		     dlm_get_lock_cookie_seq(be64_to_cpu(lock->ml.cookie)));
>  
>  	/* putting lock on list, add a ref */
>  	dlm_lock_get(lock);
> @@ -110,9 +120,10 @@ void __dlm_queue_ast(struct dlm_ctxt *dlm, struct dlm_lock *lock)
>  
>  	/* check to see if this ast obsoletes the bast */
>  	if (dlm_should_cancel_bast(dlm, lock)) {
> -		struct dlm_lock_resource *res = lock->lockres;
> -		mlog(0, "%s: cancelling bast for %.*s\n",
> -		     dlm->name, res->lockname.len, res->lockname.name);
> +		mlog(0, "%s: res %.*s, lock %u:%llu, Cancelling BAST\n",
> +		     dlm->name, res->lockname.len, res->lockname.name,
> +		     dlm_get_lock_cookie_node(be64_to_cpu(lock->ml.cookie)),
> +		     dlm_get_lock_cookie_seq(be64_to_cpu(lock->ml.cookie)));
>  		lock->bast_pending = 0;
>  		list_del_init(&lock->bast_list);
>  		lock->ml.highest_blocked = LKM_IVMODE;
> @@ -134,8 +145,6 @@ void __dlm_queue_ast(struct dlm_ctxt *dlm, struct dlm_lock *lock)
>  
>  void dlm_queue_ast(struct dlm_ctxt *dlm, struct dlm_lock *lock)
>  {
> -	mlog_entry_void();
> -
>  	BUG_ON(!dlm);
>  	BUG_ON(!lock);
>  
> @@ -147,15 +156,21 @@ void dlm_queue_ast(struct dlm_ctxt *dlm, struct dlm_lock *lock)
>  
>  void __dlm_queue_bast(struct dlm_ctxt *dlm, struct dlm_lock *lock)
>  {
> -	mlog_entry_void();
> +	struct dlm_lock_resource *res;
>  
>  	BUG_ON(!dlm);
>  	BUG_ON(!lock);
> +
>  	assert_spin_locked(&dlm->ast_lock);
>  
> +	res = lock->lockres;
> +
>  	BUG_ON(!list_empty(&lock->bast_list));
>  	if (lock->bast_pending)
> -		mlog(0, "lock has a bast getting flushed right now\n");
> +		mlog(0, "%s: res %.*s, lock %u:%llu, BAST getting flushed\n",
> +		     dlm->name, res->lockname.len, res->lockname.name,
> +		     dlm_get_lock_cookie_node(be64_to_cpu(lock->ml.cookie)),
> +		     dlm_get_lock_cookie_seq(be64_to_cpu(lock->ml.cookie)));
>  
>  	/* putting lock on list, add a ref */
>  	dlm_lock_get(lock);
> @@ -167,8 +182,6 @@ void __dlm_queue_bast(struct dlm_ctxt *dlm, struct dlm_lock *lock)
>  
>  void dlm_queue_bast(struct dlm_ctxt *dlm, struct dlm_lock *lock)
>  {
> -	mlog_entry_void();
> -
>  	BUG_ON(!dlm);
>  	BUG_ON(!lock);
>  
> @@ -213,7 +226,10 @@ void dlm_do_local_ast(struct dlm_ctxt *dlm, struct dlm_lock_resource *res,
>  	dlm_astlockfunc_t *fn;
>  	struct dlm_lockstatus *lksb;
>  
> -	mlog_entry_void();
> +	mlog(0, "%s: res %.*s, lock %u:%llu, Local AST\n", dlm->name,
> +	     res->lockname.len, res->lockname.name,
> +	     dlm_get_lock_cookie_node(be64_to_cpu(lock->ml.cookie)),
> +	     dlm_get_lock_cookie_seq(be64_to_cpu(lock->ml.cookie)));
>  
>  	lksb = lock->lksb;
>  	fn = lock->ast;
> @@ -231,7 +247,10 @@ int dlm_do_remote_ast(struct dlm_ctxt *dlm, struct dlm_lock_resource *res,
>  	struct dlm_lockstatus *lksb;
>  	int lksbflags;
>  
> -	mlog_entry_void();
> +	mlog(0, "%s: res %.*s, lock %u:%llu, Remote AST\n", dlm->name,
> +	     res->lockname.len, res->lockname.name,
> +	     dlm_get_lock_cookie_node(be64_to_cpu(lock->ml.cookie)),
> +	     dlm_get_lock_cookie_seq(be64_to_cpu(lock->ml.cookie)));
>  
>  	lksb = lock->lksb;
>  	BUG_ON(lock->ml.node == dlm->node_num);
> @@ -250,9 +269,14 @@ void dlm_do_local_bast(struct dlm_ctxt *dlm, struct dlm_lock_resource *res,
>  {
>  	dlm_bastlockfunc_t *fn = lock->bast;
>  
> -	mlog_entry_void();
>  	BUG_ON(lock->ml.node != dlm->node_num);
>  
> +	mlog(0, "%s: res %.*s, lock %u:%llu, Local BAST, blocked %d\n",
> +	     dlm->name, res->lockname.len, res->lockname.name,
> +	     dlm_get_lock_cookie_node(be64_to_cpu(lock->ml.cookie)),
> +	     dlm_get_lock_cookie_seq(be64_to_cpu(lock->ml.cookie)),
> +	     blocked_type);
> +
>  	(*fn)(lock->astdata, blocked_type);
>  }
>  
> @@ -332,7 +356,8 @@ int dlm_proxy_ast_handler(struct o2net_msg *msg, u32 len, void *data,
>  	/* cannot get a proxy ast message if this node owns it */
>  	BUG_ON(res->owner == dlm->node_num);
>  
> -	mlog(0, "lockres %.*s\n", res->lockname.len, res->lockname.name);
> +	mlog(0, "%s: res %.*s\n", dlm->name, res->lockname.len,
> +	     res->lockname.name);
>  
>  	spin_lock(&res->spinlock);
>  	if (res->state & DLM_LOCK_RES_RECOVERING) {
> @@ -382,8 +407,12 @@ do_ast:
>  	if (past->type == DLM_AST) {
>  		/* do not alter lock refcount.  switching lists. */
>  		list_move_tail(&lock->list, &res->granted);
> -		mlog(0, "ast: Adding to granted list... type=%d, "
> -		     "convert_type=%d\n", lock->ml.type, lock->ml.convert_type);
> +		mlog(0, "%s: res %.*s, lock %u:%llu, Granted type %d => %d\n",
> +		     dlm->name, res->lockname.len, res->lockname.name,
> +		     dlm_get_lock_cookie_node(be64_to_cpu(cookie)),
> +		     dlm_get_lock_cookie_seq(be64_to_cpu(cookie)),
> +		     lock->ml.type, lock->ml.convert_type);
> +
>  		if (lock->ml.convert_type != LKM_IVMODE) {
>  			lock->ml.type = lock->ml.convert_type;
>  			lock->ml.convert_type = LKM_IVMODE;
> @@ -426,9 +455,9 @@ int dlm_send_proxy_ast_msg(struct dlm_ctxt *dlm, struct dlm_lock_resource *res,
>  	size_t veclen = 1;
>  	int status;
>  
> -	mlog_entry("res %.*s, to=%u, type=%d, blocked_type=%d\n",
> -		   res->lockname.len, res->lockname.name, lock->ml.node,
> -		   msg_type, blocked_type);
> +	mlog(0, "%s: res %.*s, to %u, type %d, blocked_type %d\n", dlm->name,
> +	     res->lockname.len, res->lockname.name, lock->ml.node, msg_type,
> +	     blocked_type);
>  
>  	memset(&past, 0, sizeof(struct dlm_proxy_ast));
>  	past.node_idx = dlm->node_num;
> @@ -441,7 +470,6 @@ int dlm_send_proxy_ast_msg(struct dlm_ctxt *dlm, struct dlm_lock_resource *res,
>  	vec[0].iov_len = sizeof(struct dlm_proxy_ast);
>  	vec[0].iov_base = &past;
>  	if (flags & DLM_LKSB_GET_LVB) {
> -		mlog(0, "returning requested LVB data\n");
>  		be32_add_cpu(&past.flags, LKM_GET_LVB);
>  		vec[1].iov_len = DLM_LVB_LEN;
>  		vec[1].iov_base = lock->lksb->lvb;
> @@ -451,8 +479,8 @@ int dlm_send_proxy_ast_msg(struct dlm_ctxt *dlm, struct dlm_lock_resource *res,
>  	ret = o2net_send_message_vec(DLM_PROXY_AST_MSG, dlm->key, vec, veclen,
>  				     lock->ml.node, &status);
>  	if (ret < 0)
> -		mlog(ML_ERROR, "Error %d when sending message %u (key 0x%x) to "
> -		     "node %u\n", ret, DLM_PROXY_AST_MSG, dlm->key,
> +		mlog(ML_ERROR, "%s: res %.*s, error %d send AST to node %u\n",
> +		     dlm->name, res->lockname.len, res->lockname.name, ret,
>  		     lock->ml.node);
>  	else {
>  		if (status == DLM_RECOVERING) {
> diff --git a/fs/ocfs2/dlm/dlmdomain.c b/fs/ocfs2/dlm/dlmdomain.c
> index 58a93b9..044b4e9 100644
> --- a/fs/ocfs2/dlm/dlmdomain.c
> +++ b/fs/ocfs2/dlm/dlmdomain.c
> @@ -460,8 +460,6 @@ redo_bucket:
>  		}
>  		cond_resched_lock(&dlm->spinlock);
>  		num += n;
> -		mlog(0, "%s: touched %d lockreses in bucket %d "
> -		     "(tot=%d)\n", dlm->name, n, i, num);
>  	}
>  	spin_unlock(&dlm->spinlock);
>  	wake_up(&dlm->dlm_thread_wq);
> diff --git a/fs/ocfs2/dlm/dlmthread.c b/fs/ocfs2/dlm/dlmthread.c
> index 2211acf..1d6d1d2 100644
> --- a/fs/ocfs2/dlm/dlmthread.c
> +++ b/fs/ocfs2/dlm/dlmthread.c
> @@ -122,15 +122,13 @@ int __dlm_lockres_unused(struct dlm_lock_resource *res)
>  void __dlm_lockres_calc_usage(struct dlm_ctxt *dlm,
>  			      struct dlm_lock_resource *res)
>  {
> -	mlog_entry("%.*s\n", res->lockname.len, res->lockname.name);
> -
>  	assert_spin_locked(&dlm->spinlock);
>  	assert_spin_locked(&res->spinlock);
>  
>  	if (__dlm_lockres_unused(res)){
>  		if (list_empty(&res->purge)) {
> -			mlog(0, "putting lockres %.*s:%p onto purge list\n",
> -			     res->lockname.len, res->lockname.name, res);
> +			mlog(0, "%s: Adding res %.*s to purge list\n",
> +			     dlm->name, res->lockname.len, res->lockname.name);
>  
>  			res->last_used = jiffies;
>  			dlm_lockres_get(res);
> @@ -138,8 +136,8 @@ void __dlm_lockres_calc_usage(struct dlm_ctxt *dlm,
>  			dlm->purge_count++;
>  		}
>  	} else if (!list_empty(&res->purge)) {
> -		mlog(0, "removing lockres %.*s:%p from purge list, owner=%u\n",
> -		     res->lockname.len, res->lockname.name, res, res->owner);
> +		mlog(0, "%s: Removing res %.*s from purge list\n",
> +		     dlm->name, res->lockname.len, res->lockname.name);
>  
>  		list_del_init(&res->purge);
>  		dlm_lockres_put(res);
> @@ -150,7 +148,6 @@ void __dlm_lockres_calc_usage(struct dlm_ctxt *dlm,
>  void dlm_lockres_calc_usage(struct dlm_ctxt *dlm,
>  			    struct dlm_lock_resource *res)
>  {
> -	mlog_entry("%.*s\n", res->lockname.len, res->lockname.name);
>  	spin_lock(&dlm->spinlock);
>  	spin_lock(&res->spinlock);
>  
> @@ -171,9 +168,8 @@ static void dlm_purge_lockres(struct dlm_ctxt *dlm,
>  
>  	master = (res->owner == dlm->node_num);
>  
> -
> -	mlog(0, "purging lockres %.*s, master = %d\n", res->lockname.len,
> -	     res->lockname.name, master);
> +	mlog(0, "%s: Purging res %.*s, master %d\n", dlm->name,
> +	     res->lockname.len, res->lockname.name, master);
>  
>  	if (!master) {
>  		res->state |= DLM_LOCK_RES_DROPPING_REF;
> @@ -189,27 +185,25 @@ static void dlm_purge_lockres(struct dlm_ctxt *dlm,
>  		/* clear our bit from the master's refmap, ignore errors */
>  		ret = dlm_drop_lockres_ref(dlm, res);
>  		if (ret < 0) {
> -			mlog_errno(ret);
> +			mlog(ML_ERROR, "%s: deref %.*s failed %d\n", dlm->name,
> +			     res->lockname.len, res->lockname.name, ret);
>  			if (!dlm_is_host_down(ret))
>  				BUG();
>  		}
> -		mlog(0, "%s:%.*s: dlm_deref_lockres returned %d\n",
> -		     dlm->name, res->lockname.len, res->lockname.name, ret);
>  		spin_lock(&dlm->spinlock);
>  		spin_lock(&res->spinlock);
>  	}
>  
>  	if (!list_empty(&res->purge)) {
> -		mlog(0, "removing lockres %.*s:%p from purgelist, "
> -		     "master = %d\n", res->lockname.len, res->lockname.name,
> -		     res, master);
> +		mlog(0, "%s: Removing res %.*s from purgelist, master %d\n",
> +		     dlm->name, res->lockname.len, res->lockname.name, master);
>  		list_del_init(&res->purge);
>  		dlm_lockres_put(res);
>  		dlm->purge_count--;
>  	}
>  
>  	if (!__dlm_lockres_unused(res)) {
> -		mlog(ML_ERROR, "found lockres %s:%.*s: in use after deref\n",
> +		mlog(ML_ERROR, "%s: res %.*s in use after deref\n",
>  		     dlm->name, res->lockname.len, res->lockname.name);
>  		__dlm_print_one_lock_resource(res);
>  		BUG();
> @@ -266,10 +260,10 @@ static void dlm_run_purge_list(struct dlm_ctxt *dlm,
>  		unused = __dlm_lockres_unused(lockres);
>  		if (!unused ||
>  		    (lockres->state & DLM_LOCK_RES_MIGRATING)) {
> -			mlog(0, "lockres %s:%.*s: is in use or "
> -			     "being remastered, used %d, state %d\n",
> -			     dlm->name, lockres->lockname.len,
> -			     lockres->lockname.name, !unused, lockres->state);
> +			mlog(0, "%s: res %.*s is in use or being remastered, "
> +			     "used %d, state %d\n", dlm->name,
> +			     lockres->lockname.len, lockres->lockname.name,
> +			     !unused, lockres->state);
>  			list_move_tail(&dlm->purge_list, &lockres->purge);
>  			spin_unlock(&lockres->spinlock);
>  			continue;
> @@ -296,15 +290,12 @@ static void dlm_shuffle_lists(struct dlm_ctxt *dlm,
>  	struct list_head *head;
>  	int can_grant = 1;
>  
> -	//mlog(0, "res->lockname.len=%d\n", res->lockname.len);
> -	//mlog(0, "res->lockname.name=%p\n", res->lockname.name);
> -	//mlog(0, "shuffle res %.*s\n", res->lockname.len,
> -	//	  res->lockname.name);
> -
> -	/* because this function is called with the lockres
> +	/*
> +	 * Because this function is called with the lockres
>  	 * spinlock, and because we know that it is not migrating/
>  	 * recovering/in-progress, it is fine to reserve asts and
> -	 * basts right before queueing them all throughout */
> +	 * basts right before queueing them all throughout
> +	 */
>  	assert_spin_locked(&dlm->ast_lock);
>  	assert_spin_locked(&res->spinlock);
>  	BUG_ON((res->state & (DLM_LOCK_RES_MIGRATING|
> @@ -314,13 +305,13 @@ static void dlm_shuffle_lists(struct dlm_ctxt *dlm,
>  converting:
>  	if (list_empty(&res->converting))
>  		goto blocked;
> -	mlog(0, "res %.*s has locks on a convert queue\n", res->lockname.len,
> -	     res->lockname.name);
> +	mlog(0, "%s: res %.*s has locks on the convert queue\n", dlm->name,
> +	     res->lockname.len, res->lockname.name);
>  
>  	target = list_entry(res->converting.next, struct dlm_lock, list);
>  	if (target->ml.convert_type == LKM_IVMODE) {
> -		mlog(ML_ERROR, "%.*s: converting a lock with no "
> -		     "convert_type!\n", res->lockname.len, res->lockname.name);
> +		mlog(ML_ERROR, "%s: res %.*s converting lock to invalid mode\n",
> +		     dlm->name, res->lockname.len, res->lockname.name);
>  		BUG();
>  	}
>  	head = &res->granted;
> @@ -365,9 +356,12 @@ converting:
>  		spin_lock(&target->spinlock);
>  		BUG_ON(target->ml.highest_blocked != LKM_IVMODE);
>  
> -		mlog(0, "calling ast for converting lock: %.*s, have: %d, "
> -		     "granting: %d, node: %u\n", res->lockname.len,
> -		     res->lockname.name, target->ml.type,
> +		mlog(0, "%s: res %.*s, AST for Converting lock %u:%llu, type "
> +		     "%d => %d, node %u\n", dlm->name, res->lockname.len,
> +		     res->lockname.name,
> +		     dlm_get_lock_cookie_node(be64_to_cpu(target->ml.cookie)),
> +		     dlm_get_lock_cookie_seq(be64_to_cpu(target->ml.cookie)),
> +		     target->ml.type,
>  		     target->ml.convert_type, target->ml.node);
>  
>  		target->ml.type = target->ml.convert_type;
> @@ -428,11 +422,14 @@ blocked:
>  		spin_lock(&target->spinlock);
>  		BUG_ON(target->ml.highest_blocked != LKM_IVMODE);
>  
> -		mlog(0, "calling ast for blocked lock: %.*s, granting: %d, "
> -		     "node: %u\n", res->lockname.len, res->lockname.name,
> +		mlog(0, "%s: res %.*s, AST for Blocked lock %u:%llu, type %d, "
> +		     "node %u\n", dlm->name, res->lockname.len,
> +		     res->lockname.name,
> +		     dlm_get_lock_cookie_node(be64_to_cpu(target->ml.cookie)),
> +		     dlm_get_lock_cookie_seq(be64_to_cpu(target->ml.cookie)),
>  		     target->ml.type, target->ml.node);
>  
> -		// target->ml.type is already correct
> +		/* target->ml.type is already correct */
>  		list_move_tail(&target->list, &res->granted);
>  
>  		BUG_ON(!target->lksb);
> @@ -453,7 +450,6 @@ leave:
>  /* must have NO locks when calling this with res !=NULL * */
>  void dlm_kick_thread(struct dlm_ctxt *dlm, struct dlm_lock_resource *res)
>  {
> -	mlog_entry("dlm=%p, res=%p\n", dlm, res);
>  	if (res) {
>  		spin_lock(&dlm->spinlock);
>  		spin_lock(&res->spinlock);
> @@ -466,8 +462,6 @@ void dlm_kick_thread(struct dlm_ctxt *dlm, struct dlm_lock_resource *res)
>  
>  void __dlm_dirty_lockres(struct dlm_ctxt *dlm, struct dlm_lock_resource *res)
>  {
> -	mlog_entry("dlm=%p, res=%p\n", dlm, res);
> -
>  	assert_spin_locked(&dlm->spinlock);
>  	assert_spin_locked(&res->spinlock);
>  
> @@ -484,13 +478,16 @@ void __dlm_dirty_lockres(struct dlm_ctxt *dlm, struct dlm_lock_resource *res)
>  			res->state |= DLM_LOCK_RES_DIRTY;
>  		}
>  	}
> +
> +	mlog(0, "%s: res %.*s\n", dlm->name, res->lockname.len,
> +	     res->lockname.name);
>  }
>  
>  
>  /* Launch the NM thread for the mounted volume */
>  int dlm_launch_thread(struct dlm_ctxt *dlm)
>  {
> -	mlog(0, "starting dlm thread...\n");
> +	mlog(0, "Starting dlm_thread...\n");
>  
>  	dlm->dlm_thread_task = kthread_run(dlm_thread, dlm, "dlm_thread");
>  	if (IS_ERR(dlm->dlm_thread_task)) {
> @@ -505,7 +502,7 @@ int dlm_launch_thread(struct dlm_ctxt *dlm)
>  void dlm_complete_thread(struct dlm_ctxt *dlm)
>  {
>  	if (dlm->dlm_thread_task) {
> -		mlog(ML_KTHREAD, "waiting for dlm thread to exit\n");
> +		mlog(ML_KTHREAD, "Waiting for dlm thread to exit\n");
>  		kthread_stop(dlm->dlm_thread_task);
>  		dlm->dlm_thread_task = NULL;
>  	}
> @@ -536,7 +533,12 @@ static void dlm_flush_asts(struct dlm_ctxt *dlm)
>  		/* get an extra ref on lock */
>  		dlm_lock_get(lock);
>  		res = lock->lockres;
> -		mlog(0, "delivering an ast for this lockres\n");
> +		mlog(0, "%s: res %.*s, Flush AST for lock %u:%llu, type %d, "
> +		     "node %u\n", dlm->name, res->lockname.len,
> +		     res->lockname.name,
> +		     dlm_get_lock_cookie_node(be64_to_cpu(lock->ml.cookie)),
> +		     dlm_get_lock_cookie_seq(be64_to_cpu(lock->ml.cookie)),
> +		     lock->ml.type, lock->ml.node);
>  
>  		BUG_ON(!lock->ast_pending);
>  
> @@ -557,9 +559,9 @@ static void dlm_flush_asts(struct dlm_ctxt *dlm)
>  		/* possible that another ast was queued while
>  		 * we were delivering the last one */
>  		if (!list_empty(&lock->ast_list)) {
> -			mlog(0, "aha another ast got queued while "
> -			     "we were finishing the last one.  will "
> -			     "keep the ast_pending flag set.\n");
> +			mlog(0, "%s: res %.*s, AST queued while flushing last "
> +			     "one\n", dlm->name, res->lockname.len,
> +			     res->lockname.name);
>  		} else
>  			lock->ast_pending = 0;
>  
> @@ -590,8 +592,12 @@ static void dlm_flush_asts(struct dlm_ctxt *dlm)
>  		dlm_lock_put(lock);
>  		spin_unlock(&dlm->ast_lock);
>  
> -		mlog(0, "delivering a bast for this lockres "
> -		     "(blocked = %d\n", hi);
> +		mlog(0, "%s: res %.*s, Flush BAST for lock %u:%llu, "
> +		     "blocked %d, node %u\n",
> +		     dlm->name, res->lockname.len, res->lockname.name,
> +		     dlm_get_lock_cookie_node(be64_to_cpu(lock->ml.cookie)),
> +		     dlm_get_lock_cookie_seq(be64_to_cpu(lock->ml.cookie)),
> +		     hi, lock->ml.node);
>  
>  		if (lock->ml.node != dlm->node_num) {
>  			ret = dlm_send_proxy_bast(dlm, res, lock, hi);
> @@ -605,9 +611,9 @@ static void dlm_flush_asts(struct dlm_ctxt *dlm)
>  		/* possible that another bast was queued while
>  		 * we were delivering the last one */
>  		if (!list_empty(&lock->bast_list)) {
> -			mlog(0, "aha another bast got queued while "
> -			     "we were finishing the last one.  will "
> -			     "keep the bast_pending flag set.\n");
> +			mlog(0, "%s: res %.*s, BAST queued while flushing last "
> +			     "one\n", dlm->name, res->lockname.len,
> +			     res->lockname.name);
>  		} else
>  			lock->bast_pending = 0;
>  
> @@ -675,11 +681,12 @@ static int dlm_thread(void *data)
>  			spin_lock(&res->spinlock);
>  			if (res->owner != dlm->node_num) {
>  				__dlm_print_one_lock_resource(res);
> -				mlog(ML_ERROR, "inprog:%s, mig:%s, reco:%s, dirty:%s\n",
> -				     res->state & DLM_LOCK_RES_IN_PROGRESS ? "yes" : "no",
> -				     res->state & DLM_LOCK_RES_MIGRATING ? "yes" : "no",
> -				     res->state & DLM_LOCK_RES_RECOVERING ? "yes" : "no",
> -				     res->state & DLM_LOCK_RES_DIRTY ? "yes" : "no");
> +				mlog(ML_ERROR, "%s: inprog %d, mig %d, reco %d,"
> +				     " dirty %d\n", dlm->name,
> +				     !!(res->state & DLM_LOCK_RES_IN_PROGRESS),
> +				     !!(res->state & DLM_LOCK_RES_MIGRATING),
> +				     !!(res->state & DLM_LOCK_RES_RECOVERING),
> +				     !!(res->state & DLM_LOCK_RES_DIRTY));
>  			}
>  			BUG_ON(res->owner != dlm->node_num);
>  
> @@ -693,8 +700,8 @@ static int dlm_thread(void *data)
>  				res->state &= ~DLM_LOCK_RES_DIRTY;
>  				spin_unlock(&res->spinlock);
>  				spin_unlock(&dlm->ast_lock);
> -				mlog(0, "delaying list shuffling for in-"
> -				     "progress lockres %.*s, state=%d\n",
> +				mlog(0, "%s: res %.*s, inprogress, delay list "
> +				     "shuffle, state %d\n", dlm->name,
>  				     res->lockname.len, res->lockname.name,
>  				     res->state);
>  				delay = 1;
> @@ -706,10 +713,6 @@ static int dlm_thread(void *data)
>  			 * spinlock and do NOT have the dlm lock.
>  			 * safe to reserve/queue asts and run the lists. */
>  
> -			mlog(0, "calling dlm_shuffle_lists with dlm=%s, "
> -			     "res=%.*s\n", dlm->name,
> -			     res->lockname.len, res->lockname.name);
> -
>  			/* called while holding lockres lock */
>  			dlm_shuffle_lists(dlm, res);
>  			res->state &= ~DLM_LOCK_RES_DIRTY;
> @@ -733,7 +736,8 @@ in_progress:
>  			/* unlikely, but we may need to give time to
>  			 * other tasks */
>  			if (!--n) {
> -				mlog(0, "throttling dlm_thread\n");
> +				mlog(0, "%s: Throttling dlm thread\n",
> +				     dlm->name);
>  				break;
>  			}
>  		}
> -- 
> 1.5.6.5
> 

-- 

"In the beginning, the universe was created. This has made a lot 
 of people very angry, and is generally considered to have been a 
 bad move."
        - Douglas Adams

Joel Becker
Senior Development Manager
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
