From: Joel Becker <Joel.Becker@oracle.com>
Date: Mon Mar 10 15:58:51 2008
Subject: [Ocfs2-devel] [PATCH 11/11] ocfs2/dlm: Fix lockname in lockres
	print function
In-Reply-To: <1205187389-3563-12-git-send-email-sunil.mushran@oracle.com>
References: <1205187389-3563-1-git-send-email-sunil.mushran@oracle.com>
	<1205187389-3563-12-git-send-email-sunil.mushran@oracle.com>
Message-ID: <20080310225824.GE31998@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Mon, Mar 10, 2008 at 03:16:29PM -0700, Sunil Mushran wrote:
> __dlm_print_one_lock_resource was printing lockname incorrectly.
> Also, we now use printk directly instead of mlog as the latter prints
> the line context which is not useful for this print.
> 
> Signed-off-by: Sunil Mushran <sunil.mushran@oracle.com>
Signed-off-by: Joel Becker <joel.becker@oracle.com>

> ---
>  fs/ocfs2/dlm/dlmdebug.c |  126 +++++++++++++++++++----------------------------
>  1 files changed, 51 insertions(+), 75 deletions(-)
> 
> diff --git a/fs/ocfs2/dlm/dlmdebug.c b/fs/ocfs2/dlm/dlmdebug.c
> index 58e4579..53a9e60 100644
> --- a/fs/ocfs2/dlm/dlmdebug.c
> +++ b/fs/ocfs2/dlm/dlmdebug.c
> @@ -5,7 +5,7 @@
>   *
>   * debug functionality for the dlm
>   *
> - * Copyright (C) 2004 Oracle.  All rights reserved.
> + * Copyright (C) 2004, 2008 Oracle.  All rights reserved.
>   *
>   * This program is free software; you can redistribute it and/or
>   * modify it under the terms of the GNU General Public
> @@ -44,11 +44,10 @@
>  #define MLOG_MASK_PREFIX ML_DLM
>  #include "cluster/masklog.h"
>  
> +int stringify_lockname(const char *lockname, int locklen, char *buf, int len);
> +
>  void dlm_print_one_lock_resource(struct dlm_lock_resource *res)
>  {
> -	mlog(ML_NOTICE, "lockres: %.*s, owner=%u, state=%u\n",
> -	       res->lockname.len, res->lockname.name,
> -	       res->owner, res->state);
>  	spin_lock(&res->spinlock);
>  	__dlm_print_one_lock_resource(res);
>  	spin_unlock(&res->spinlock);
> @@ -59,75 +58,78 @@ static void dlm_print_lockres_refmap(struct dlm_lock_resource *res)
>  	int bit;
>  	assert_spin_locked(&res->spinlock);
>  
> -	mlog(ML_NOTICE, "  refmap nodes: [ ");
> +	printk(KERN_NOTICE "  refmap nodes: [ ");
>  	bit = 0;
>  	while (1) {
>  		bit = find_next_bit(res->refmap, O2NM_MAX_NODES, bit);
>  		if (bit >= O2NM_MAX_NODES)
>  			break;
> -		printk("%u ", bit);
> +		printk(KERN_NOTICE "%u ", bit);
>  		bit++;
>  	}
> -	printk("], inflight=%u\n", res->inflight_locks);
> +	printk(KERN_NOTICE "], inflight=%u\n", res->inflight_locks);
> +}
> +
> +static void __dlm_print_lock(struct dlm_lock *lock)
> +{
> +	spin_lock(&lock->spinlock);
> +
> +	printk(KERN_NOTICE "    type=%d, conv=%d, node=%u, cookie=%u:%llu, "
> +	       "ref=%u, ast=(empty=%c,pend=%c), bast=(empty=%c,pend=%c), "
> +	       "pending=(conv=%c,lock=%c,cancel=%c,unlock=%c)\n",
> +	       lock->ml.type, lock->ml.convert_type, lock->ml.node,
> +	       dlm_get_lock_cookie_node(be64_to_cpu(lock->ml.cookie)),
> +	       dlm_get_lock_cookie_seq(be64_to_cpu(lock->ml.cookie)),
> +	       atomic_read(&lock->lock_refs.refcount),
> +	       (list_empty(&lock->ast_list) ? 'y' : 'n'),
> +	       (lock->ast_pending ? 'y' : 'n'),
> +	       (list_empty(&lock->bast_list) ? 'y' : 'n'),
> +	       (lock->bast_pending ? 'y' : 'n'),
> +	       (lock->convert_pending ? 'y' : 'n'),
> +	       (lock->lock_pending ? 'y' : 'n'),
> +	       (lock->cancel_pending ? 'y' : 'n'),
> +	       (lock->unlock_pending ? 'y' : 'n'));
> +
> +	spin_unlock(&lock->spinlock);
>  }
>  
>  void __dlm_print_one_lock_resource(struct dlm_lock_resource *res)
>  {
>  	struct list_head *iter2;
>  	struct dlm_lock *lock;
> +	char buf[DLM_LOCKID_NAME_MAX];
>  
>  	assert_spin_locked(&res->spinlock);
>  
> -	mlog(ML_NOTICE, "lockres: %.*s, owner=%u, state=%u\n",
> -	       res->lockname.len, res->lockname.name,
> -	       res->owner, res->state);
> -	mlog(ML_NOTICE, "  last used: %lu, on purge list: %s\n",
> -	     res->last_used, list_empty(&res->purge) ? "no" : "yes");
> +	stringify_lockname(res->lockname.name, res->lockname.len,
> +			   buf, sizeof(buf) - 1);
> +	printk(KERN_NOTICE "lockres: %s, owner=%u, state=%u\n",
> +	       buf, res->owner, res->state);
> +	printk(KERN_NOTICE "  last used: %lu, refcnt: %u, on purge list: %s\n",
> +	       res->last_used, atomic_read(&res->refs.refcount),
> +	       list_empty(&res->purge) ? "no" : "yes");
> +	printk(KERN_NOTICE "  on dirty list: %s, on reco list: %s, "
> +	       "migrating pending: %s\n",
> +	       list_empty(&res->dirty) ? "no" : "yes",
> +	       list_empty(&res->recovering) ? "no" : "yes",
> +	       res->migration_pending ? "yes" : "no");
> +	printk(KERN_NOTICE "  inflight locks: %d, asts reserved: %d\n",
> +	       res->inflight_locks, atomic_read(&res->asts_reserved));
>  	dlm_print_lockres_refmap(res);
> -	mlog(ML_NOTICE, "  granted queue: \n");
> +	printk(KERN_NOTICE "  granted queue:\n");
>  	list_for_each(iter2, &res->granted) {
>  		lock = list_entry(iter2, struct dlm_lock, list);
> -		spin_lock(&lock->spinlock);
> -		mlog(ML_NOTICE, "    type=%d, conv=%d, node=%u, "
> -		       "cookie=%u:%llu, ast=(empty=%c,pend=%c), bast=(empty=%c,pend=%c)\n", 
> -		       lock->ml.type, lock->ml.convert_type, lock->ml.node, 
> -		     dlm_get_lock_cookie_node(be64_to_cpu(lock->ml.cookie)),
> -		     dlm_get_lock_cookie_seq(be64_to_cpu(lock->ml.cookie)),
> -		       list_empty(&lock->ast_list) ? 'y' : 'n',
> -		       lock->ast_pending ? 'y' : 'n',
> -		       list_empty(&lock->bast_list) ? 'y' : 'n',
> -		       lock->bast_pending ? 'y' : 'n');
> -		spin_unlock(&lock->spinlock);
> +		__dlm_print_lock(lock);
>  	}
> -	mlog(ML_NOTICE, "  converting queue: \n");
> +	printk(KERN_NOTICE "  converting queue:\n");
>  	list_for_each(iter2, &res->converting) {
>  		lock = list_entry(iter2, struct dlm_lock, list);
> -		spin_lock(&lock->spinlock);
> -		mlog(ML_NOTICE, "    type=%d, conv=%d, node=%u, "
> -		       "cookie=%u:%llu, ast=(empty=%c,pend=%c), bast=(empty=%c,pend=%c)\n", 
> -		       lock->ml.type, lock->ml.convert_type, lock->ml.node, 
> -		     dlm_get_lock_cookie_node(be64_to_cpu(lock->ml.cookie)),
> -		     dlm_get_lock_cookie_seq(be64_to_cpu(lock->ml.cookie)),
> -		       list_empty(&lock->ast_list) ? 'y' : 'n',
> -		       lock->ast_pending ? 'y' : 'n',
> -		       list_empty(&lock->bast_list) ? 'y' : 'n',
> -		       lock->bast_pending ? 'y' : 'n');
> -		spin_unlock(&lock->spinlock);
> +		__dlm_print_lock(lock);
>  	}
> -	mlog(ML_NOTICE, "  blocked queue: \n");
> +	printk(KERN_NOTICE "  blocked queue:\n");
>  	list_for_each(iter2, &res->blocked) {
>  		lock = list_entry(iter2, struct dlm_lock, list);
> -		spin_lock(&lock->spinlock);
> -		mlog(ML_NOTICE, "    type=%d, conv=%d, node=%u, "
> -		       "cookie=%u:%llu, ast=(empty=%c,pend=%c), bast=(empty=%c,pend=%c)\n", 
> -		       lock->ml.type, lock->ml.convert_type, lock->ml.node, 
> -		     dlm_get_lock_cookie_node(be64_to_cpu(lock->ml.cookie)),
> -		     dlm_get_lock_cookie_seq(be64_to_cpu(lock->ml.cookie)),
> -		       list_empty(&lock->ast_list) ? 'y' : 'n',
> -		       lock->ast_pending ? 'y' : 'n',
> -		       list_empty(&lock->bast_list) ? 'y' : 'n',
> -		       lock->bast_pending ? 'y' : 'n');
> -		spin_unlock(&lock->spinlock);
> +		__dlm_print_lock(lock);
>  	}
>  }
>  
> @@ -137,31 +139,6 @@ void dlm_print_one_lock(struct dlm_lock *lockid)
>  }
>  EXPORT_SYMBOL_GPL(dlm_print_one_lock);
>  
> -#if 0
> -void dlm_dump_lock_resources(struct dlm_ctxt *dlm)
> -{
> -	struct dlm_lock_resource *res;
> -	struct hlist_node *iter;
> -	struct hlist_head *bucket;
> -	int i;
> -
> -	mlog(ML_NOTICE, "struct dlm_ctxt: %s, node=%u, key=%u\n",
> -		  dlm->name, dlm->node_num, dlm->key);
> -	if (!dlm || !dlm->name) {
> -		mlog(ML_ERROR, "dlm=%p\n", dlm);
> -		return;
> -	}
> -
> -	spin_lock(&dlm->spinlock);
> -	for (i=0; i<DLM_HASH_BUCKETS; i++) {
> -		bucket = dlm_lockres_hash(dlm, i);
> -		hlist_for_each_entry(res, iter, bucket, hash_node)
> -			dlm_print_one_lock_resource(res);
> -	}
> -	spin_unlock(&dlm->spinlock);
> -}
> -#endif  /*  0  */
> -
>  static const char *dlm_errnames[] = {
>  	[DLM_NORMAL] =			"DLM_NORMAL",
>  	[DLM_GRANTED] =			"DLM_GRANTED",
> @@ -274,8 +251,7 @@ EXPORT_SYMBOL_GPL(dlm_errname);
>   *
>   * For more on lockname formats, please refer to dlmglue.c and ocfs2_lockid.h.
>   */
> -static int stringify_lockname(const char *lockname, int locklen,
> -			      char *buf, int len)
> +int stringify_lockname(const char *lockname, int locklen, char *buf, int len)
>  {
>  	int out = 0;
>  	__be64 inode_blkno_be;
> -- 
> 1.5.3.6
> 
> 
> _______________________________________________
> Ocfs2-devel mailing list
> Ocfs2-devel@oss.oracle.com
> http://oss.oracle.com/mailman/listinfo/ocfs2-devel

-- 

"Gone to plant a weeping willow
 On the bank's green edge it will roll, roll, roll.
 Sing a lulaby beside the waters.
 Lovers come and go, the river roll, roll, rolls."

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker@oracle.com
Phone: (650) 506-8127
