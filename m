From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Wed, 22 Apr 2009 19:27:05 -0700
Subject: [Ocfs2-devel] [PATCH 1/1] OCFS2: fasten dlm_lock_resource
 hash_table lookups
In-Reply-To: <200904220605.n3M657YN028817@rgminet15.oracle.com>
References: <200904220605.n3M657YN028817@rgminet15.oracle.com>
Message-ID: <49EFD1F9.1020009@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Wengang,

When we backport, we like to add bread crumbs so that we can track back
to the original patch. This helps us in cases where we, say, forget to
include a patch. Also, we want to retain original authorship.

For example:
http://oss.oracle.com/git/?p=ocfs2-1.4.git;a=commitdiff;h=174f54db9af7c67a1afaa947aed934b9c80f588c

So don't merge the patches. Add the mainline commit at the top of the
patch. As 1.2 is svn, ensure the authors name is included in an Authored-by
tag.

Has it been tested in 1.2?

Thanks
Sunil

wengang wang wrote:
> #backporting the 3 patches at http://kernel.us.oracle.com/~smushran/srini/ to 1.2.
>
> enlarge hash_table capacity to fasten hash_table lookups.
>
> Signed-off-by: Wengang wang <wen.gang.wang@oracle.com>
> --
> diff -up ./svnocfs2-1.2/fs/ocfs2/dlm/dlmdebug.c.orig ./svnocfs2-1.2/fs/ocfs2/dlm/dlmdebug.c
> --- ./svnocfs2-1.2/fs/ocfs2/dlm/dlmdebug.c.orig	2009-04-22 11:00:37.000000000 +0800
> +++ ./svnocfs2-1.2/fs/ocfs2/dlm/dlmdebug.c	2009-04-22 11:08:27.000000000 +0800
> @@ -547,7 +547,7 @@ void dlm_dump_lock_resources(struct dlm_
>  
>  	spin_lock(&dlm->spinlock);
>  	for (i=0; i<DLM_HASH_BUCKETS; i++) {
> -		bucket = &(dlm->lockres_hash[i]);
> +		bucket = dlm_lockres_hash(dlm, i);
>  		hlist_for_each_entry(res, iter, bucket, hash_node)
>  			dlm_print_one_lock_resource(res);
>  	}
> diff -up ./svnocfs2-1.2/fs/ocfs2/dlm/dlmrecovery.c.orig ./svnocfs2-1.2/fs/ocfs2/dlm/dlmrecovery.c
> --- ./svnocfs2-1.2/fs/ocfs2/dlm/dlmrecovery.c.orig	2009-04-22 11:01:18.000000000 +0800
> +++ ./svnocfs2-1.2/fs/ocfs2/dlm/dlmrecovery.c	2009-04-22 11:21:12.000000000 +0800
> @@ -2064,7 +2064,7 @@ static void dlm_finish_local_lockres_rec
>  	 * the RECOVERING state and set the owner
>  	 * if necessary */
>  	for (i = 0; i < DLM_HASH_BUCKETS; i++) {
> -		bucket = &(dlm->lockres_hash[i]);
> +		bucket = dlm_lockres_hash(dlm, i);
>  		hlist_for_each_entry(res, hash_iter, bucket, hash_node) {
>  			if (res->state & DLM_LOCK_RES_RECOVERING) {
>  				if (res->owner == dead_node) {
> @@ -2259,7 +2259,7 @@ static void dlm_do_local_recovery_cleanu
>  	 *    need to be fired as a result.
>  	 */
>   	for (i = 0; i < DLM_HASH_BUCKETS; i++) {
> - 		bucket = &(dlm->lockres_hash[i]);
> +		bucket = dlm_lockres_hash(dlm, i);
>   		hlist_for_each_entry(res, iter, bucket, hash_node) {
>  			/* always prune any $RECOVERY entries for dead nodes,
>  			 * otherwise hangs can occur during later recovery */
> diff -up ./svnocfs2-1.2/fs/ocfs2/dlm/dlmdomain.c.orig ./svnocfs2-1.2/fs/ocfs2/dlm/dlmdomain.c
> --- ./svnocfs2-1.2/fs/ocfs2/dlm/dlmdomain.c.orig	2009-04-22 11:00:47.000000000 +0800
> +++ ./svnocfs2-1.2/fs/ocfs2/dlm/dlmdomain.c	2009-04-22 11:33:26.000000000 +0800
> @@ -49,6 +49,34 @@
>  #define MLOG_MASK_PREFIX (ML_DLM|ML_DLM_DOMAIN)
>  #include "cluster/masklog.h"
>  
> +static void dlm_free_pagevec(void **vec, int pages)
> +{
> +	while (pages--)
> +		free_page((unsigned long)vec[pages]);
> +	kfree(vec);
> +}
> +
> +static void **dlm_alloc_pagevec(int pages)
> +{
> +	void **vec = kmalloc(pages * sizeof(void *), GFP_KERNEL);
> +	int i;
> +
> +	if (!vec)
> +		return NULL;
> +
> +	for (i = 0; i < pages; i++) {
> +		vec[i] = (void *)__get_free_page(GFP_KERNEL);
> +		if (!vec[i])
> +			goto out_free;
> +	}
> +	mlog(0, "Allocated DLM hash pagevec; %d pages (%lu expected), %Zd "
> +	     "buckets per page\n", pages, DLM_HASH_PAGES, DLM_BUCKETS_PER_PAGE);
> +	return vec;
> +out_free:
> +	dlm_free_pagevec(vec, i);
> +	return NULL;
> +}
> +
>  /*
>   * ocfs2 node maps are array of long int, which limits to send them freely
>   * across the wire due to endianness issues. To workaround this, we convert
> @@ -127,7 +155,7 @@ void __dlm_insert_lockres(struct dlm_ctx
>  
>  	q = &res->lockname;
>  	q->hash = full_name_hash(q->name, q->len);
> -	bucket = &(dlm->lockres_hash[q->hash % DLM_HASH_BUCKETS]);
> +	bucket = dlm_lockres_hash(dlm, q->hash);
>  
>  	/* get a reference for our hashtable */
>  	dlm_lockres_get(res);
> @@ -151,7 +179,7 @@ struct dlm_lock_resource * __dlm_lookup_
>  
>  	hash = full_name_hash(name, len);
>  
> -	bucket = &(dlm->lockres_hash[hash % DLM_HASH_BUCKETS]);
> +	bucket = dlm_lockres_hash(dlm, hash);
>  
>  	/* check for pre-existing lock */
>  	hlist_for_each(iter, bucket) {
> @@ -394,7 +422,7 @@ static int dlm_migrate_all_locks(struct 
>  	for (i = 0; i < DLM_HASH_BUCKETS; i++) {
>  redo_bucket:
>  		n = 0;
> -		bucket = &dlm->lockres_hash[i];
> +		bucket = dlm_lockres_hash(dlm, i);
>  		iter = bucket->first;
>  		while (iter) {
>  			n++;
> @@ -1356,7 +1384,8 @@ static struct dlm_ctxt *dlm_alloc_ctxt(c
>  		goto leave;
>  	}
>  
> -	dlm->lockres_hash = (struct hlist_head *) __get_free_page(GFP_KERNEL);
> +	dlm->lockres_hash = (struct hlist_head **)
> +				dlm_alloc_pagevec(DLM_HASH_PAGES);
>  	if (!dlm->lockres_hash) {
>  		mlog_errno(-ENOMEM);
>  		kfree(dlm->name);
> @@ -1366,7 +1395,7 @@ static struct dlm_ctxt *dlm_alloc_ctxt(c
>  	}
>  
>  	for (i=0; i<DLM_HASH_BUCKETS; i++)
> -		INIT_HLIST_HEAD(&dlm->lockres_hash[i]);
> +		INIT_HLIST_HEAD(dlm_lockres_hash(dlm, i));
>  
>  	strcpy(dlm->name, domain);
>  	dlm->key = key;
> diff -up ./svnocfs2-1.2/fs/ocfs2/dlm/dlmcommon.h.orig ./svnocfs2-1.2/fs/ocfs2/dlm/dlmcommon.h
> --- ./svnocfs2-1.2/fs/ocfs2/dlm/dlmcommon.h.orig	2009-04-22 10:59:51.000000000 +0800
> +++ ./svnocfs2-1.2/fs/ocfs2/dlm/dlmcommon.h	2009-04-22 11:26:06.000000000 +0800
> @@ -37,7 +37,14 @@
>  #define DLM_THREAD_SHUFFLE_INTERVAL    5     // flush everything every 5 passes
>  #define DLM_THREAD_MS                  200   // flush at least every 200 ms
>  
> -#define DLM_HASH_BUCKETS     (PAGE_SIZE / sizeof(struct hlist_head))
> +#define DLM_HASH_SIZE_DEFAULT	(1 << 17)
> +#if DLM_HASH_SIZE_DEFAULT < PAGE_SIZE
> +# define DLM_HASH_PAGES		1
> +#else
> +# define DLM_HASH_PAGES		(DLM_HASH_SIZE_DEFAULT / PAGE_SIZE)
> +#endif
> +#define DLM_BUCKETS_PER_PAGE	(PAGE_SIZE / sizeof(struct hlist_head))
> +#define DLM_HASH_BUCKETS	(DLM_HASH_PAGES * DLM_BUCKETS_PER_PAGE)
>  
>  enum dlm_ast_type {
>  	DLM_AST = 0,
> @@ -86,7 +93,7 @@ enum dlm_ctxt_state {
>  struct dlm_ctxt
>  {
>  	struct list_head list;
> -	struct hlist_head *lockres_hash;
> +	struct hlist_head **lockres_hash;
>  	struct list_head dirty_list;
>  	struct list_head purge_list;
>  	struct list_head pending_asts;
> @@ -136,6 +143,13 @@ struct dlm_ctxt
>  	struct list_head	dlm_eviction_callbacks;
>  };
>  
> +static inline
> +struct hlist_head *dlm_lockres_hash(struct dlm_ctxt *dlm, unsigned i)
> +{
> +	return dlm->lockres_hash[(i / DLM_BUCKETS_PER_PAGE) % DLM_HASH_PAGES]
> +		+ (i % DLM_BUCKETS_PER_PAGE);
> +}
> +
>  /* these keventd work queue items are for less-frequently
>   * called functions that cannot be directly called from the
>   * net message handlers for some reason, usually because
>
> _______________________________________________
> Ocfs2-devel mailing list
> Ocfs2-devel at oss.oracle.com
> http://oss.oracle.com/mailman/listinfo/ocfs2-devel
>   
