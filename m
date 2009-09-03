From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Wed, 02 Sep 2009 19:14:15 -0700
Subject: [Ocfs2-devel] [PATCH] add assertions to stuffs with
 purge/unused lockres
In-Reply-To: <200908280821.n7S8L8ut026709@rgminet15.oracle.com>
References: <200908280821.n7S8L8ut026709@rgminet15.oracle.com>
Message-ID: <4A9F2677.4030406@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

How about we narrow down the issue by dumping the lockres?

Look in 1.4. We dump the lockres in dlm_purge_lockres().
__dlm_print_one_lock_resource(res);

In this case, it appears the user has encountered it more than
once. Work with Srini to give them a package with the above.

The idea here is to figure out as to "how" the lockres is in use.
Is t because of a refmap. Or a new lock. etc.

Wengang Wang wrote:
> this is more a discusion than a patch.
>
> I had an ocfs2 bug(8801298). the problem is that with dlm->spinlock hold,
> dlm_run_purge_list() think the status of "unuse" of a lockres shouldn't change
> from unused to in-use. it checks the status twice(by calling __dlm_lockres_unused())
> and found the status changed from unused to in-use then calls a BUG() to panic.
> the only avaible info is just the BUG() info. however there are serveral possibility
> casing the status change. so I stuck there -- I am not able to go any further..
>
> If we can detect the problem in each possibility, it will be better. so I wrote
> the patch. the patch does:
> 1) removes the lockres from purge list(if it's in the list) in __dlm_lookup_lockres_full().
>    --if found in __dlm_lookup_lockres_full(), the lockres is going to be in-use
>      very soon, so remove it from purge list.
>
> 2) encapsulates operations that adds/removes/moves dlm_lock to/from granted/
>    converting/blocked lists of a lockres into functions. in the functions, there
>    are assertions that check mainly if the lockres is not in purge list.
>    --it can detect the 8801298 BUG ealier.
>
> 3) encapsulates operations that clear/set refmap_bit into functions which does
>    same assertion as in 2).
>    --it can detect the 8801298 BUG ealier.
>
> 4) encapsulates operations that adds/removes/re-adds lockres to/from dlm->purge_list
>    into functions that does assertions as in 2)
>    --it can detect the 8801298 BUG ealier.
>
> 5) encapsulates operations that adds/removes lockres to/from dlm->dirty_list.
>    into functions that does assertions as in 2)
>    --it can detect the 8801298 BUG ealier.
>
> 6) what I think they could be bugs
>    6.1) adds spinlock protection on the operation that remove lockres from purgelist.
>    6.2) moves the two operation
>                a) removes lockres from dirty list;
>                b) remove DLM_LOCK_RES_DIRTY flag from the lockres
>         into one atomic operation(in protection of res->spinlock).
>         --I think both checking list_emtry(&res->dirty) and DLM_LOCK_RES_DIRTY
>           is ugly. if the above is reasonable, maybe we can remove the DLM_LOCK_RES_DIRTY
>           flag later..
>
> for 2), 4) and 5), I don't know if it's a good idea --developers maybe still
> using the original list_add_tail()/list_del_init ..
> for 6), maybe I should make separate patches..
>
> Signed-off-by: Wengang Wang <wen.gang.wang@oracle.com>
> ---
>  fs/ocfs2/dlm/dlmast.c      |    6 ++-
>  fs/ocfs2/dlm/dlmcommon.h   |   18 ++++++--
>  fs/ocfs2/dlm/dlmconvert.c  |   23 ++++++++-
>  fs/ocfs2/dlm/dlmdomain.c   |    6 ++
>  fs/ocfs2/dlm/dlmlock.c     |   52 ++++++++++++++++++--
>  fs/ocfs2/dlm/dlmmaster.c   |   27 ++++++-----
>  fs/ocfs2/dlm/dlmrecovery.c |   24 ++++++----
>  fs/ocfs2/dlm/dlmthread.c   |  111 ++++++++++++++++++++++++++++++++++----------
>  fs/ocfs2/dlm/dlmunlock.c   |   21 +++++++--
>  9 files changed, 225 insertions(+), 63 deletions(-)
>
> diff --git a/fs/ocfs2/dlm/dlmast.c b/fs/ocfs2/dlm/dlmast.c
> index d07ddbe..0e357a2 100644
> --- a/fs/ocfs2/dlm/dlmast.c
> +++ b/fs/ocfs2/dlm/dlmast.c
> @@ -54,6 +54,10 @@ static void dlm_update_lvb(struct dlm_ctxt *dlm, struct dlm_lock_resource *res,
>  			   struct dlm_lock *lock);
>  static int dlm_should_cancel_bast(struct dlm_ctxt *dlm, struct dlm_lock *lock);
>  
> +extern
> +void move_lock_to_grantedlist(struct dlm_lock *lock,
> +			      struct dlm_lock_resource *res);
> +
>  /* Should be called as an ast gets queued to see if the new
>   * lock level will obsolete a pending bast.
>   * For example, if dlm_thread queued a bast for an EX lock that
> @@ -385,7 +389,7 @@ do_ast:
>  	ret = DLM_NORMAL;
>  	if (past->type == DLM_AST) {
>  		/* do not alter lock refcount.  switching lists. */
> -		list_move_tail(&lock->list, &res->granted);
> +		move_lock_to_grantedlist(lock, res);
>  		mlog(0, "ast: Adding to granted list... type=%d, "
>  		     "convert_type=%d\n", lock->ml.type, lock->ml.convert_type);
>  		if (lock->ml.convert_type != LKM_IVMODE) {
> diff --git a/fs/ocfs2/dlm/dlmcommon.h b/fs/ocfs2/dlm/dlmcommon.h
> index 0102be3..8c3cd5b 100644
> --- a/fs/ocfs2/dlm/dlmcommon.h
> +++ b/fs/ocfs2/dlm/dlmcommon.h
> @@ -861,28 +861,38 @@ struct dlm_lock_resource *dlm_new_lockres(struct dlm_ctxt *dlm,
>  					  const char *name,
>  					  unsigned int namelen);
>  
> -#define dlm_lockres_set_refmap_bit(bit,res)  \
> -	__dlm_lockres_set_refmap_bit(bit,res,__FILE__,__LINE__)
> -#define dlm_lockres_clear_refmap_bit(bit,res)  \
> -	__dlm_lockres_clear_refmap_bit(bit,res,__FILE__,__LINE__)
> +#define dlm_lockres_set_refmap_bit(bit,res,new_lockres)  \
> +	__dlm_lockres_set_refmap_bit(bit,res,new_lockres,__FILE__,__LINE__)
> +#define dlm_lockres_clear_refmap_bit(bit,res,new_lockres)  \
> +	__dlm_lockres_clear_refmap_bit(bit,res,new_lockres,__FILE__,__LINE__)
>  
>  static inline void __dlm_lockres_set_refmap_bit(int bit,
>  						struct dlm_lock_resource *res,
> +						int new_lockres,
>  						const char *file,
>  						int line)
>  {
>  	//printk("%s:%d:%.*s: setting bit %d\n", file, line,
>  	//     res->lockname.len, res->lockname.name, bit);
> +	if (!new_lockres) {
> +		assert_spin_locked(&res->spinlock);
> +		BUG_ON(!list_empty(&res->purge));
> +	}
>  	set_bit(bit, res->refmap);
>  }
>  
>  static inline void __dlm_lockres_clear_refmap_bit(int bit,
>  						  struct dlm_lock_resource *res,
> +						  int new_lockres,
>  						  const char *file,
>  						  int line)
>  {
>  	//printk("%s:%d:%.*s: clearing bit %d\n", file, line,
>  	//     res->lockname.len, res->lockname.name, bit);
> +	if (!new_lockres) {
> +		assert_spin_locked(&res->spinlock);
> +		BUG_ON(!list_empty(&res->purge));
> +	}
>  	clear_bit(bit, res->refmap);
>  }
>  
> diff --git a/fs/ocfs2/dlm/dlmconvert.c b/fs/ocfs2/dlm/dlmconvert.c
> index 75997b4..84b2b80 100644
> --- a/fs/ocfs2/dlm/dlmconvert.c
> +++ b/fs/ocfs2/dlm/dlmconvert.c
> @@ -66,6 +66,23 @@ static enum dlm_status dlm_send_remote_convert_request(struct dlm_ctxt *dlm,
>  					   struct dlm_lock_resource *res,
>  					   struct dlm_lock *lock, int flags, int type);
>  
> +
> +static void move_lock_to_convertinglist(struct dlm_lock *lock,
> +					struct dlm_lock_resource *res)
> +{
> +	assert_spin_locked(&res->spinlock);
> +
> +	BUG_ON(lock->lockres != res);
> +	BUG_ON(!list_empty(&res->purge));
> +	BUG_ON(list_empty(&lock->list));
> +
> +	list_move_tail(&lock->list, &res->converting);
> +}
> +
> +extern
> +void move_lock_to_grantedlist(struct dlm_lock *lock,
> +			      struct dlm_lock_resource *res);
> +
>  /*
>   * this is only called directly by dlmlock(), and only when the
>   * local node is the owner of the lockres
> @@ -234,7 +251,7 @@ switch_queues:
>  
>  	lock->ml.convert_type = type;
>  	/* do not alter lock refcount.  switching lists. */
> -	list_move_tail(&lock->list, &res->converting);
> +	move_lock_to_convertinglist(lock, res);
>  
>  unlock_exit:
>  	spin_unlock(&lock->spinlock);
> @@ -250,7 +267,7 @@ void dlm_revert_pending_convert(struct dlm_lock_resource *res,
>  				struct dlm_lock *lock)
>  {
>  	/* do not alter lock refcount.  switching lists. */
> -	list_move_tail(&lock->list, &res->granted);
> +	move_lock_to_grantedlist(lock, res);
>  	lock->ml.convert_type = LKM_IVMODE;
>  	lock->lksb->flags &= ~(DLM_LKSB_GET_LVB|DLM_LKSB_PUT_LVB);
>  }
> @@ -295,7 +312,7 @@ enum dlm_status dlmconvert_remote(struct dlm_ctxt *dlm,
>  	res->state |= DLM_LOCK_RES_IN_PROGRESS;
>  	/* move lock to local convert queue */
>  	/* do not alter lock refcount.  switching lists. */
> -	list_move_tail(&lock->list, &res->converting);
> +	move_lock_to_convertinglist(lock, res);
>  	lock->convert_pending = 1;
>  	lock->ml.convert_type = type;
>  
> diff --git a/fs/ocfs2/dlm/dlmdomain.c b/fs/ocfs2/dlm/dlmdomain.c
> index 4d9e6b2..7f41e6e 100644
> --- a/fs/ocfs2/dlm/dlmdomain.c
> +++ b/fs/ocfs2/dlm/dlmdomain.c
> @@ -49,6 +49,8 @@
>  #define MLOG_MASK_PREFIX (ML_DLM|ML_DLM_DOMAIN)
>  #include "cluster/masklog.h"
>  
> +extern
> +void rm_lockres_from_purgelist(struct dlm_lock_resource *res);
>  /*
>   * ocfs2 node maps are array of long int, which limits to send them freely
>   * across the wire due to endianness issues. To workaround this, we convert
> @@ -199,6 +201,10 @@ struct dlm_lock_resource * __dlm_lookup_lockres_full(struct dlm_ctxt *dlm,
>  		if (memcmp(res->lockname.name + 1, name + 1, len - 1))
>  			continue;
>  		dlm_lockres_get(res);
> +		spin_lock(&res->spinlock);
> +		if (!list_empty(&res->purge))
> +			rm_lockres_from_purgelist(res);
> +		spin_unlock(&res->spinlock);
>  		return res;
>  	}
>  	return NULL;
> diff --git a/fs/ocfs2/dlm/dlmlock.c b/fs/ocfs2/dlm/dlmlock.c
> index 83a9f29..c254f08 100644
> --- a/fs/ocfs2/dlm/dlmlock.c
> +++ b/fs/ocfs2/dlm/dlmlock.c
> @@ -66,6 +66,48 @@ static void dlm_init_lock(struct dlm_lock *newlock, int type,
>  static void dlm_lock_release(struct kref *kref);
>  static void dlm_lock_detach_lockres(struct dlm_lock *lock);
>  
> +void add_lock_to_grantedlist(struct dlm_lock *lock,
> +			     struct dlm_lock_resource *res)
> +{
> +	assert_spin_locked(&res->spinlock);
> +
> +	BUG_ON(!list_empty(&res->purge));
> +	BUG_ON(!list_empty(&lock->list));
> +
> +	list_add_tail(&lock->list, &res->granted);
> +}
> +
> +void move_lock_to_grantedlist(struct dlm_lock *lock,
> +			      struct dlm_lock_resource *res)
> +{
> +	assert_spin_locked(&res->spinlock);
> +
> +	BUG_ON(lock->lockres != res);
> +	BUG_ON(!list_empty(&res->purge));
> +	BUG_ON(list_empty(&lock->list));
> +
> +	list_move_tail(&lock->list, &res->granted);
> +}
> +
> +void add_lock_to_blockedlist(struct dlm_lock *lock,
> +			     struct dlm_lock_resource *res)
> +{
> +	assert_spin_locked(&res->spinlock);
> +
> +	BUG_ON(!list_empty(&res->purge));
> +	BUG_ON(!list_empty(&lock->list));
> +	list_add_tail(&lock->list, &res->blocked);
> +}
> +
> +void rm_lock_from_list(struct dlm_lock *lock)
> +{
> +	BUG_ON(list_empty(&lock->list));
> +	BUG_ON(!lock->lockres);
> +	assert_spin_locked(&lock->lockres->spinlock);
> +
> +	list_del_init(&lock->list);
> +}
> +
>  int dlm_init_lock_cache(void)
>  {
>  	dlm_lock_cache = kmem_cache_create("o2dlm_lock",
> @@ -148,7 +190,7 @@ static enum dlm_status dlmlock_master(struct dlm_ctxt *dlm,
>  		lock->lksb->status = DLM_NORMAL;
>  		status = DLM_NORMAL;
>  		dlm_lock_get(lock);
> -		list_add_tail(&lock->list, &res->granted);
> +		add_lock_to_grantedlist(lock, res);
>  
>  		/* for the recovery lock, we can't allow the ast
>  		 * to be queued since the dlmthread is already
> @@ -177,7 +219,7 @@ static enum dlm_status dlmlock_master(struct dlm_ctxt *dlm,
>  			}
>  		} else {
>  			dlm_lock_get(lock);
> -			list_add_tail(&lock->list, &res->blocked);
> +			add_lock_to_blockedlist(lock, res);
>  			kick_thread = 1;
>  		}
>  	}
> @@ -206,7 +248,7 @@ void dlm_revert_pending_lock(struct dlm_lock_resource *res,
>  			     struct dlm_lock *lock)
>  {
>  	/* remove from local queue if it failed */
> -	list_del_init(&lock->list);
> +	rm_lock_from_list(lock);
>  	lock->lksb->flags &= ~DLM_LKSB_GET_LVB;
>  }
>  
> @@ -237,7 +279,7 @@ static enum dlm_status dlmlock_remote(struct dlm_ctxt *dlm,
>  
>  	/* add lock to local (secondary) queue */
>  	dlm_lock_get(lock);
> -	list_add_tail(&lock->list, &res->blocked);
> +	add_lock_to_blockedlist(lock, res);
>  	lock->lock_pending = 1;
>  	spin_unlock(&res->spinlock);
>  
> @@ -279,7 +321,7 @@ static enum dlm_status dlmlock_remote(struct dlm_ctxt *dlm,
>  		mlog(0, "%s: $RECOVERY lock for this node (%u) is "
>  		     "mastered by %u; got lock, manually granting (no ast)\n",
>  		     dlm->name, dlm->node_num, res->owner);
> -		list_move_tail(&lock->list, &res->granted);
> +		move_lock_to_grantedlist(lock, res);
>  	}
>  	spin_unlock(&res->spinlock);
>  
> diff --git a/fs/ocfs2/dlm/dlmmaster.c b/fs/ocfs2/dlm/dlmmaster.c
> index f8b653f..93cdc77 100644
> --- a/fs/ocfs2/dlm/dlmmaster.c
> +++ b/fs/ocfs2/dlm/dlmmaster.c
> @@ -129,6 +129,8 @@ static int dlm_mark_lockres_migrating(struct dlm_ctxt *dlm,
>  static int dlm_pre_master_reco_lockres(struct dlm_ctxt *dlm,
>  				       struct dlm_lock_resource *res);
>  
> +extern
> +void rm_lock_from_list(struct dlm_lock *lock);
>  
>  int dlm_is_host_down(int errno)
>  {
> @@ -651,7 +653,7 @@ void __dlm_lockres_grab_inflight_ref(struct dlm_ctxt *dlm,
>  
>  	if (!test_bit(dlm->node_num, res->refmap)) {
>  		BUG_ON(res->inflight_locks != 0);
> -		dlm_lockres_set_refmap_bit(dlm->node_num, res);
> +		dlm_lockres_set_refmap_bit(dlm->node_num, res, new_lockres);
>  	}
>  	res->inflight_locks++;
>  	mlog(0, "%s:%.*s: inflight++: now %u\n",
> @@ -672,7 +674,7 @@ void __dlm_lockres_drop_inflight_ref(struct dlm_ctxt *dlm,
>  	     dlm->name, res->lockname.len, res->lockname.name,
>  	     res->inflight_locks);
>  	if (res->inflight_locks == 0)
> -		dlm_lockres_clear_refmap_bit(dlm->node_num, res);
> +		dlm_lockres_clear_refmap_bit(dlm->node_num, res, 0);
>  	wake_up(&res->wq);
>  }
>  
> @@ -1438,7 +1440,7 @@ way_up_top:
>  		if (res->owner == dlm->node_num) {
>  			mlog(0, "%s:%.*s: setting bit %u in refmap\n",
>  			     dlm->name, namelen, name, request->node_idx);
> -			dlm_lockres_set_refmap_bit(request->node_idx, res);
> +			dlm_lockres_set_refmap_bit(request->node_idx, res, 0);
>  			spin_unlock(&res->spinlock);
>  			response = DLM_MASTER_RESP_YES;
>  			if (mle)
> @@ -1503,7 +1505,7 @@ way_up_top:
>  				 * go back and clean the mles on any
>  				 * other nodes */
>  				dispatch_assert = 1;
> -				dlm_lockres_set_refmap_bit(request->node_idx, res);
> +				dlm_lockres_set_refmap_bit(request->node_idx, res, 0);
>  				mlog(0, "%s:%.*s: setting bit %u in refmap\n",
>  				     dlm->name, namelen, name,
>  				     request->node_idx);
> @@ -1711,7 +1713,7 @@ again:
>  			     "lockres, set the bit in the refmap\n",
>  			     namelen, lockname, to);
>  			spin_lock(&res->spinlock);
> -			dlm_lockres_set_refmap_bit(to, res);
> +			dlm_lockres_set_refmap_bit(to, res, 0);
>  			spin_unlock(&res->spinlock);
>  		}
>  	}
> @@ -2269,7 +2271,7 @@ int dlm_deref_lockres_handler(struct o2net_msg *msg, u32 len, void *data,
>  	else {
>  		BUG_ON(res->state & DLM_LOCK_RES_DROPPING_REF);
>  		if (test_bit(node, res->refmap)) {
> -			dlm_lockres_clear_refmap_bit(node, res);
> +			dlm_lockres_clear_refmap_bit(node, res, 0);
>  			cleared = 1;
>  		}
>  	}
> @@ -2329,7 +2331,7 @@ static void dlm_deref_lockres_worker(struct dlm_work_item *item, void *data)
>  	BUG_ON(res->state & DLM_LOCK_RES_DROPPING_REF);
>  	if (test_bit(node, res->refmap)) {
>  		__dlm_wait_on_lockres_flags(res, DLM_LOCK_RES_SETREF_INPROG);
> -		dlm_lockres_clear_refmap_bit(node, res);
> +		dlm_lockres_clear_refmap_bit(node, res, 0);
>  		cleared = 1;
>  	}
>  	spin_unlock(&res->spinlock);
> @@ -2864,8 +2866,9 @@ static void dlm_remove_nonlocal_locks(struct dlm_ctxt *dlm,
>  				BUG_ON(!list_empty(&lock->bast_list));
>  				BUG_ON(lock->ast_pending);
>  				BUG_ON(lock->bast_pending);
> -				dlm_lockres_clear_refmap_bit(lock->ml.node, res);
> -				list_del_init(&lock->list);
> +				dlm_lockres_clear_refmap_bit(lock->ml.node, res,
> +							     0);
> +				rm_lock_from_list(lock);
>  				dlm_lock_put(lock);
>  				/* In a normal unlock, we would have added a
>  				 * DLM_UNLOCK_FREE_LOCK action. Force it. */
> @@ -2885,7 +2888,7 @@ static void dlm_remove_nonlocal_locks(struct dlm_ctxt *dlm,
>  			mlog(0, "%s:%.*s: node %u had a ref to this "
>  			     "migrating lockres, clearing\n", dlm->name,
>  			     res->lockname.len, res->lockname.name, bit);
> -			dlm_lockres_clear_refmap_bit(bit, res);
> +			dlm_lockres_clear_refmap_bit(bit, res, 0);
>  		}
>  		bit++;
>  	}
> @@ -2997,7 +3000,7 @@ static int dlm_do_migrate_request(struct dlm_ctxt *dlm,
>  			     dlm->name, res->lockname.len, res->lockname.name,
>  			     nodenum);
>  			spin_lock(&res->spinlock);
> -			dlm_lockres_set_refmap_bit(nodenum, res);
> +			dlm_lockres_set_refmap_bit(nodenum, res, 0);
>  			spin_unlock(&res->spinlock);
>  		}
>  	}
> @@ -3335,7 +3338,7 @@ int dlm_finish_migration(struct dlm_ctxt *dlm, struct dlm_lock_resource *res,
>  	 * mastery reference here since old_master will briefly have
>  	 * a reference after the migration completes */
>  	spin_lock(&res->spinlock);
> -	dlm_lockres_set_refmap_bit(old_master, res);
> +	dlm_lockres_set_refmap_bit(old_master, res, 0);
>  	spin_unlock(&res->spinlock);
>  
>  	mlog(0, "now time to do a migrate request to other nodes\n");
> diff --git a/fs/ocfs2/dlm/dlmrecovery.c b/fs/ocfs2/dlm/dlmrecovery.c
> index bcb9260..086bf6c 100644
> --- a/fs/ocfs2/dlm/dlmrecovery.c
> +++ b/fs/ocfs2/dlm/dlmrecovery.c
> @@ -105,6 +105,12 @@ static DEFINE_SPINLOCK(dlm_reco_state_lock);
>  static DEFINE_SPINLOCK(dlm_mig_cookie_lock);
>  static u64 dlm_mig_cookie = 1;
>  
> +extern
> +void rm_lock_from_list(struct dlm_lock *lock);
> +extern
> +void move_lock_to_grantedlist(struct dlm_lock *lock,
> +			      struct dlm_lock_resource *res);
> +
>  static u64 dlm_get_next_mig_cookie(void)
>  {
>  	u64 c;
> @@ -1053,7 +1059,7 @@ static void dlm_move_reco_locks_to_list(struct dlm_ctxt *dlm,
>  					     "a $RECOVERY lock for dead "
>  					     "node %u (%s)!\n", 
>  					     dead_node, dlm->name);
> -					list_del_init(&lock->list);
> +					rm_lock_from_list(lock);
>  					dlm_lock_put(lock);
>  					break;
>  				}
> @@ -1743,7 +1749,7 @@ static int dlm_process_recovery_data(struct dlm_ctxt *dlm,
>  			     dlm->name, mres->lockname_len, mres->lockname,
>  			     from);
>  			spin_lock(&res->spinlock);
> -			dlm_lockres_set_refmap_bit(from, res);
> +			dlm_lockres_set_refmap_bit(from, res, 0);
>  			spin_unlock(&res->spinlock);
>  			added++;
>  			break;
> @@ -1912,7 +1918,7 @@ skip_lvb:
>  			mlog(0, "%s:%.*s: added lock for node %u, "
>  			     "setting refmap bit\n", dlm->name,
>  			     res->lockname.len, res->lockname.name, ml->node);
> -			dlm_lockres_set_refmap_bit(ml->node, res);
> +			dlm_lockres_set_refmap_bit(ml->node, res, 0);
>  			added++;
>  		}
>  		spin_unlock(&res->spinlock);
> @@ -2164,7 +2170,7 @@ static void dlm_free_dead_locks(struct dlm_ctxt *dlm,
>  	/* TODO: check pending_asts, pending_basts here */
>  	list_for_each_entry_safe(lock, next, &res->granted, list) {
>  		if (lock->ml.node == dead_node) {
> -			list_del_init(&lock->list);
> +			rm_lock_from_list(lock);
>  			dlm_lock_put(lock);
>  			/* Can't schedule DLM_UNLOCK_FREE_LOCK - do manually */
>  			dlm_lock_put(lock);
> @@ -2173,7 +2179,7 @@ static void dlm_free_dead_locks(struct dlm_ctxt *dlm,
>  	}
>  	list_for_each_entry_safe(lock, next, &res->converting, list) {
>  		if (lock->ml.node == dead_node) {
> -			list_del_init(&lock->list);
> +			rm_lock_from_list(lock);
>  			dlm_lock_put(lock);
>  			/* Can't schedule DLM_UNLOCK_FREE_LOCK - do manually */
>  			dlm_lock_put(lock);
> @@ -2182,7 +2188,7 @@ static void dlm_free_dead_locks(struct dlm_ctxt *dlm,
>  	}
>  	list_for_each_entry_safe(lock, next, &res->blocked, list) {
>  		if (lock->ml.node == dead_node) {
> -			list_del_init(&lock->list);
> +			rm_lock_from_list(lock);
>  			dlm_lock_put(lock);
>  			/* Can't schedule DLM_UNLOCK_FREE_LOCK - do manually */
>  			dlm_lock_put(lock);
> @@ -2195,12 +2201,12 @@ static void dlm_free_dead_locks(struct dlm_ctxt *dlm,
>  		     "dropping ref from lockres\n", dlm->name,
>  		     res->lockname.len, res->lockname.name, freed, dead_node);
>  		BUG_ON(!test_bit(dead_node, res->refmap));
> -		dlm_lockres_clear_refmap_bit(dead_node, res);
> +		dlm_lockres_clear_refmap_bit(dead_node, res, 0);
>  	} else if (test_bit(dead_node, res->refmap)) {
>  		mlog(0, "%s:%.*s: dead node %u had a ref, but had "
>  		     "no locks and had not purged before dying\n", dlm->name,
>  		     res->lockname.len, res->lockname.name, dead_node);
> -		dlm_lockres_clear_refmap_bit(dead_node, res);
> +		dlm_lockres_clear_refmap_bit(dead_node, res, 0);
>  	}
>  
>  	/* do not kick thread yet */
> @@ -2254,7 +2260,7 @@ static void dlm_do_local_recovery_cleanup(struct dlm_ctxt *dlm, u8 dead_node)
>  						     "a $RECOVERY lock for dead "
>  						     "node %u (%s)!\n",
>  						     dead_node, dlm->name);
> -						list_del_init(&lock->list);
> +						rm_lock_from_list(lock);
>  						dlm_lock_put(lock);
>  						break;
>  					}
> diff --git a/fs/ocfs2/dlm/dlmthread.c b/fs/ocfs2/dlm/dlmthread.c
> index d490b66..72fd7de 100644
> --- a/fs/ocfs2/dlm/dlmthread.c
> +++ b/fs/ocfs2/dlm/dlmthread.c
> @@ -58,6 +58,73 @@ static void dlm_flush_asts(struct dlm_ctxt *dlm);
>  
>  #define dlm_lock_is_remote(dlm, lock)     ((lock)->ml.node != (dlm)->node_num)
>  
> +static void add_lockres_to_purgelist(struct dlm_ctxt *dlm,
> +				     struct dlm_lock_resource *res)
> +{
> +	assert_spin_locked(&dlm->spinlock);
> +	assert_spin_locked(&res->spinlock);
> +
> +	BUG_ON(!list_empty(&res->purge));
> +
> +	list_add_tail(&res->purge, &dlm->purge_list);
> +	dlm->purge_count++;
> +}
> +
> +void rm_lockres_from_purgelist(struct dlm_lock_resource *res)
> +{
> +	BUG_ON(!res->dlm);
> +	assert_spin_locked(&res->dlm->spinlock);
> +	assert_spin_locked(&res->spinlock);
> +	BUG_ON(list_empty(&res->purge));
> +
> +	list_del_init(&res->purge);
> +	res->dlm->purge_count--;
> +}
> +
> +static void readd_lockres_to_purgelist(struct dlm_ctxt *dlm,
> +				       struct dlm_lock_resource *res)
> +{
> +	assert_spin_locked(&dlm->spinlock);
> +	assert_spin_locked(&res->spinlock);
> +
> +	BUG_ON(list_empty(&res->purge));
> +	BUG_ON(res->dlm != dlm);
> +
> +	list_del_init(&res->purge);
> +	list_add_tail(&res->purge, &dlm->purge_list);
> +}
> +
> +static void add_lockres_to_dirtylist(struct dlm_lock_resource *res,
> +				     struct dlm_ctxt *dlm)
> +{
> +	assert_spin_locked(&dlm->spinlock);
> +	assert_spin_locked(&res->spinlock);
> +
> +	BUG_ON(!list_empty(&res->purge));
> +	BUG_ON(!list_empty(&res->dirty));
> +
> +	list_add_tail(&res->dirty, &dlm->dirty_list);
> +	res->state |= DLM_LOCK_RES_DIRTY;
> +}
> +
> +static void rm_lockres_from_dirtylist(struct dlm_lock_resource *res)
> +{
> +	BUG_ON(!res->dlm);
> +
> +	assert_spin_locked(&res->dlm->spinlock);
> +	assert_spin_locked(&res->spinlock);
> +
> +	BUG_ON(!list_empty(&res->purge));
> +	BUG_ON(list_empty(&res->dirty));
> +
> +	list_del_init(&res->dirty);
> +	res->state &= ~DLM_LOCK_RES_DIRTY;
> +}
> +
> +extern
> +void move_lock_to_grantedlist(struct dlm_lock *lock,
> +			      struct dlm_lock_resource *res);
> +
>  /* will exit holding res->spinlock, but may drop in function */
>  /* waits until flags are cleared on res->state */
>  void __dlm_wait_on_lockres_flags(struct dlm_lock_resource *res, int flags)
> @@ -128,16 +195,13 @@ void __dlm_lockres_calc_usage(struct dlm_ctxt *dlm,
>  
>  			res->last_used = jiffies;
>  			dlm_lockres_get(res);
> -			list_add_tail(&res->purge, &dlm->purge_list);
> -			dlm->purge_count++;
> +			add_lockres_to_purgelist(dlm, res);
>  		}
>  	} else if (!list_empty(&res->purge)) {
>  		mlog(0, "removing lockres %.*s:%p from purge list, owner=%u\n",
>  		     res->lockname.len, res->lockname.name, res, res->owner);
> -
> -		list_del_init(&res->purge);
> +		rm_lockres_from_purgelist(res);
>  		dlm_lockres_put(res);
> -		dlm->purge_count--;
>  	}
>  }
>  
> @@ -175,8 +239,7 @@ static int dlm_purge_lockres(struct dlm_ctxt *dlm,
>  		     res->lockname.name);
>  		/* Re-add the lockres to the end of the purge list */
>  		if (!list_empty(&res->purge)) {
> -			list_del_init(&res->purge);
> -			list_add_tail(&res->purge, &dlm->purge_list);
> +			readd_lockres_to_purgelist(dlm, res);
>  		}
>  		spin_unlock(&res->spinlock);
>  		return 0;
> @@ -212,14 +275,15 @@ static int dlm_purge_lockres(struct dlm_ctxt *dlm,
>  		spin_lock(&dlm->spinlock);
>  	}
>  
> +	spin_lock(&res->spinlock);
>  	if (!list_empty(&res->purge)) {
>  		mlog(0, "removing lockres %.*s:%p from purgelist, "
>  		     "master = %d\n", res->lockname.len, res->lockname.name,
>  		     res, master);
> -		list_del_init(&res->purge);
> +		rm_lockres_from_purgelist(res);
>  		dlm_lockres_put(res);
> -		dlm->purge_count--;
>  	}
> +	spin_unlock(&res->spinlock);
>  	__dlm_unhash_lockres(res);
>  
>  	/* lockres is not in the hash now.  drop the flag and wake up
> @@ -373,7 +437,7 @@ converting:
>  
>  		target->ml.type = target->ml.convert_type;
>  		target->ml.convert_type = LKM_IVMODE;
> -		list_move_tail(&target->list, &res->granted);
> +		move_lock_to_grantedlist(target, res);
>  
>  		BUG_ON(!target->lksb);
>  		target->lksb->status = DLM_NORMAL;
> @@ -434,7 +498,7 @@ blocked:
>  		     target->ml.type, target->ml.node);
>  
>  		// target->ml.type is already correct
> -		list_move_tail(&target->list, &res->granted);
> +		move_lock_to_grantedlist(target, res);
>  
>  		BUG_ON(!target->lksb);
>  		target->lksb->status = DLM_NORMAL;
> @@ -481,8 +545,7 @@ void __dlm_dirty_lockres(struct dlm_ctxt *dlm, struct dlm_lock_resource *res)
>  		if (list_empty(&res->dirty)) {
>  			/* ref for dirty_list */
>  			dlm_lockres_get(res);
> -			list_add_tail(&res->dirty, &dlm->dirty_list);
> -			res->state |= DLM_LOCK_RES_DIRTY;
> +			add_lockres_to_dirtylist(res, dlm);
>  		}
>  	}
>  }
> @@ -661,14 +724,6 @@ static int dlm_thread(void *data)
>  			BUG_ON(!res);
>  			dlm_lockres_get(res);
>  
> -			spin_lock(&res->spinlock);
> -			/* We clear the DLM_LOCK_RES_DIRTY state once we shuffle lists below */
> -			list_del_init(&res->dirty);
> -			spin_unlock(&res->spinlock);
> -			spin_unlock(&dlm->spinlock);
> -			/* Drop dirty_list ref */
> -			dlm_lockres_put(res);
> -
>  		 	/* lockres can be re-dirtied/re-added to the
>  			 * dirty_list in this gap, but that is ok */
>  
> @@ -690,12 +745,15 @@ static int dlm_thread(void *data)
>  			if (res->state & (DLM_LOCK_RES_IN_PROGRESS |
>  					  DLM_LOCK_RES_RECOVERING)) {
>  				/* move it to the tail and keep going */
> -				res->state &= ~DLM_LOCK_RES_DIRTY;
> -				spin_unlock(&res->spinlock);
> +				rm_lockres_from_dirtylist(res);
>  				mlog(0, "delaying list shuffling for in-"
>  				     "progress lockres %.*s, state=%d\n",
>  				     res->lockname.len, res->lockname.name,
>  				     res->state);
> +				spin_unlock(&res->spinlock);
> +				spin_unlock(&dlm->spinlock);
> +				/* Drop dirty_list ref */
> +				dlm_lockres_put(res);
>  				delay = 1;
>  				goto in_progress;
>  			}
> @@ -711,11 +769,14 @@ static int dlm_thread(void *data)
>  
>  			/* called while holding lockres lock */
>  			dlm_shuffle_lists(dlm, res);
> -			res->state &= ~DLM_LOCK_RES_DIRTY;
> +			rm_lockres_from_dirtylist(res);
>  			spin_unlock(&res->spinlock);
> +			spin_unlock(&dlm->spinlock);
> +			/* Drop dirty_list ref */
> +			dlm_lockres_put(res);
> +			
>  
>  			dlm_lockres_calc_usage(dlm, res);
> -
>  in_progress:
>  
>  			spin_lock(&dlm->spinlock);
> diff --git a/fs/ocfs2/dlm/dlmunlock.c b/fs/ocfs2/dlm/dlmunlock.c
> index fcf879e..044b181 100644
> --- a/fs/ocfs2/dlm/dlmunlock.c
> +++ b/fs/ocfs2/dlm/dlmunlock.c
> @@ -76,6 +76,19 @@ static enum dlm_status dlm_send_remote_unlock_request(struct dlm_ctxt *dlm,
>  						 u8 owner);
>  
>  
> +extern
> +void add_lock_to_grantedlist(struct dlm_lock *lock,
> +			     struct dlm_lock_resource *res);
> +extern
> +void add_lock_to_blockedlist(struct dlm_lock *lock,
> +			     struct dlm_lock_resource *res);
> +
> +extern
> +void rm_lock_from_list(struct dlm_lock *lock);
> +
> +extern
> +void move_lock_to_grantedlist(struct dlm_lock *lock,
> +			      struct dlm_lock_resource *res);
>  /*
>   * according to the spec:
>   * http://opendlm.sourceforge.net/cvsmirror/opendlm/docs/dlmbook_final.pdf
> @@ -217,12 +230,12 @@ static enum dlm_status dlmunlock_common(struct dlm_ctxt *dlm,
>  	dlm_lock_get(lock);
>  
>  	if (actions & DLM_UNLOCK_REMOVE_LOCK) {
> -		list_del_init(&lock->list);
> +		rm_lock_from_list(lock);
>  		dlm_lock_put(lock);
>  	}
>  	if (actions & DLM_UNLOCK_REGRANT_LOCK) {
>  		dlm_lock_get(lock);
> -		list_add_tail(&lock->list, &res->granted);
> +		add_lock_to_grantedlist(lock, res);
>  	}
>  	if (actions & DLM_UNLOCK_CLEAR_CONVERT_TYPE) {
>  		mlog(0, "clearing convert_type at %smaster node\n",
> @@ -268,13 +281,13 @@ void dlm_commit_pending_unlock(struct dlm_lock_resource *res,
>  {
>  	/* leave DLM_LKSB_PUT_LVB on the lksb so any final
>  	 * update of the lvb will be sent to the new master */
> -	list_del_init(&lock->list);
> +	rm_lock_from_list(lock);
>  }
>  
>  void dlm_commit_pending_cancel(struct dlm_lock_resource *res,
>  			       struct dlm_lock *lock)
>  {
> -	list_move_tail(&lock->list, &res->granted);
> +	move_lock_to_grantedlist(lock, res);
>  	lock->ml.convert_type = LKM_IVMODE;
>  }
>  
>   
