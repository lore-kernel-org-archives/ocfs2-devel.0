From: Sunil Mushran <Sunil.Mushran@oracle.com>
Date: Tue Mar  4 18:33:40 2008
Subject: [Ocfs2-devel] Re: [PATCH] Dynamic lockres hash table
In-Reply-To: <20080304102448.GB24335@duck.suse.cz>
References: <20080304102448.GB24335@duck.suse.cz>
Message-ID: <47CE065F.6080707@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

My main problem with a mount option is that it is not dynamic.

I was thinking along lines of having a sysfs param that will
allow users to dynamically resize the number of pages alloted
to the hash. This will definitely require us running tests to see
how long it takes to rehash with 500K lockres under the
dlm_spinlock.

I guess as a first step, we should add a avg lookup time stat.

But all this will take time.

How about we increase the defaults in 1.4 from 4 pages to 16 or
even 32 pages. This will be for Enterprise Kernels only and we
should be able to assume that they will have 128K per mount to
spare.

Comments?

Sunil

Jan Kara wrote:
>   Hello,
>
>   because SLES10 SP2 is closer than I thought, I've written the patch to
> dynamically size the hash table with locks in DLM. First, there's new mount
> option hash_buckets which allows you to set number of hash buckets
> explicitely. Then there is also code which tries to estimate reasonable
> hash size when mounting the filesystem - what I put there is:
>  1) we estimate the number of possible files a device_size / max(64KB,
> 4*cluster_size) - this is used as the number of buckets (number of locks
> we need to store in memory is roughly twice the number of cached files in
> memory).
>  2) we never take more than 1/2048 of total ram
>
>   If you think the estimates should be different, please speak up.
>
> 									Honza
>
>   
> ------------------------------------------------------------------------
>
> From: Jan Kara <jack@suse.cz>
> Subject: Allow setting of size of lockres hash
>
> Hash table with cluster locks had a fixed size of 2048 entries on 64-bit archs.
> This is too few when used for a larger filesystem. Add the possibility to set
> the size of the hash table as a mount option and also introduce some better
> estimation on the needed table size.
>
> Signed-off-by: Jan Kara <jack@suse.cz>
>
> Index: linux-2.6.16-SLES10_SP2_BRANCH/fs/ocfs2/dlm/dlmapi.h
> ===================================================================
> --- linux-2.6.16-SLES10_SP2_BRANCH.orig/fs/ocfs2/dlm/dlmapi.h
> +++ linux-2.6.16-SLES10_SP2_BRANCH/fs/ocfs2/dlm/dlmapi.h
> @@ -193,7 +193,8 @@ enum dlm_status dlmunlock(struct dlm_ctx
>  			  dlm_astunlockfunc_t *unlockast,
>  			  void *data);
>  
> -struct dlm_ctxt * dlm_register_domain(const char *domain, u32 key);
> +struct dlm_ctxt * dlm_register_domain(const char *domain, u32 key,
> +	unsigned int buckets);
>  
>  void dlm_unregister_domain(struct dlm_ctxt *dlm);
>  
> Index: linux-2.6.16-SLES10_SP2_BRANCH/fs/ocfs2/dlm/dlmcommon.h
> ===================================================================
> --- linux-2.6.16-SLES10_SP2_BRANCH.orig/fs/ocfs2/dlm/dlmcommon.h
> +++ linux-2.6.16-SLES10_SP2_BRANCH/fs/ocfs2/dlm/dlmcommon.h
> @@ -37,14 +37,8 @@
>  #define DLM_THREAD_SHUFFLE_INTERVAL    5     // flush everything every 5 passes
>  #define DLM_THREAD_MS                  200   // flush at least every 200 ms
>  
> -#define DLM_HASH_SIZE_DEFAULT	(1 << 14)
> -#if DLM_HASH_SIZE_DEFAULT < PAGE_SIZE
> -# define DLM_HASH_PAGES		1
> -#else
> -# define DLM_HASH_PAGES		(DLM_HASH_SIZE_DEFAULT / PAGE_SIZE)
> -#endif
> +#define DLM_DEFAULT_HASH_BUCKETS (1 << 14)
>  #define DLM_BUCKETS_PER_PAGE	(PAGE_SIZE / sizeof(struct hlist_head))
> -#define DLM_HASH_BUCKETS	(DLM_HASH_PAGES * DLM_BUCKETS_PER_PAGE)
>  
>  /* Intended to make it easier for us to switch out hash functions */
>  #define dlm_lockid_hash(_n, _l) full_name_hash(_n, _l)
> @@ -96,6 +90,7 @@ enum dlm_ctxt_state {
>  struct dlm_ctxt
>  {
>  	struct list_head list;
> +	unsigned int lockres_hash_buckets;
>  	struct hlist_head **lockres_hash;
>  	struct list_head dirty_list;
>  	struct list_head purge_list;
> @@ -148,7 +143,7 @@ struct dlm_ctxt
>  
>  static inline struct hlist_head *dlm_lockres_hash(struct dlm_ctxt *dlm, unsigned i)
>  {
> -	return dlm->lockres_hash[(i / DLM_BUCKETS_PER_PAGE) % DLM_HASH_PAGES] + (i % DLM_BUCKETS_PER_PAGE);
> +	return dlm->lockres_hash[(i % dlm->lockres_hash_buckets) / DLM_BUCKETS_PER_PAGE] + (i % DLM_BUCKETS_PER_PAGE);
>  }
>  
>  /* these keventd work queue items are for less-frequently
> Index: linux-2.6.16-SLES10_SP2_BRANCH/fs/ocfs2/dlm/dlmdebug.c
> ===================================================================
> --- linux-2.6.16-SLES10_SP2_BRANCH.orig/fs/ocfs2/dlm/dlmdebug.c
> +++ linux-2.6.16-SLES10_SP2_BRANCH/fs/ocfs2/dlm/dlmdebug.c
> @@ -381,7 +381,7 @@ void dlm_dump_lock_resources(struct dlm_
>  	}
>  
>  	spin_lock(&dlm->spinlock);
> -	for (i=0; i<DLM_HASH_BUCKETS; i++) {
> +	for (i=0; i<dlm->lockres_hash_buckets; i++) {
>  		bucket = dlm_lockres_hash(dlm, i);
>  		hlist_for_each_entry(res, iter, bucket, hash_node)
>  			dlm_print_one_lock_resource(res);
> Index: linux-2.6.16-SLES10_SP2_BRANCH/fs/ocfs2/dlm/dlmdomain.c
> ===================================================================
> --- linux-2.6.16-SLES10_SP2_BRANCH.orig/fs/ocfs2/dlm/dlmdomain.c
> +++ linux-2.6.16-SLES10_SP2_BRANCH/fs/ocfs2/dlm/dlmdomain.c
> @@ -98,9 +98,8 @@ static void **dlm_alloc_pagevec(int page
>  		if (!(vec[i] = (void *)__get_free_page(GFP_KERNEL)))
>  			goto out_free;
>  
> -	mlog(0, "Allocated DLM hash pagevec; %d pages (%lu expected), %lu buckets per page\n",
> -	     pages, (unsigned long)DLM_HASH_PAGES,
> -	     (unsigned long)DLM_BUCKETS_PER_PAGE);
> +	mlog(0, "Allocated DLM hash pagevec; %d pages, %lu buckets per page\n",
> +	     pages, (unsigned long)DLM_BUCKETS_PER_PAGE);
>  	return vec;
>  out_free:
>  	dlm_free_pagevec(vec, i);
> @@ -289,7 +288,8 @@ static void dlm_free_ctxt_mem(struct dlm
>  	dlm_proc_del_domain(dlm);
>  
>  	if (dlm->lockres_hash)
> -		dlm_free_pagevec((void **)dlm->lockres_hash, DLM_HASH_PAGES);
> +		dlm_free_pagevec((void **)dlm->lockres_hash,
> +			dlm->lockres_hash_buckets / DLM_BUCKETS_PER_PAGE);
>  
>  	if (dlm->name)
>  		kfree(dlm->name);
> @@ -412,7 +412,7 @@ static int dlm_migrate_all_locks(struct 
>  
>  	num = 0;
>  	spin_lock(&dlm->spinlock);
> -	for (i = 0; i < DLM_HASH_BUCKETS; i++) {
> +	for (i = 0; i < dlm->lockres_hash_buckets; i++) {
>  redo_bucket:
>  		n = 0;
>  		bucket = dlm_lockres_hash(dlm, i);
> @@ -1360,8 +1360,8 @@ bail:
>  	return status;
>  }
>  
> -static struct dlm_ctxt *dlm_alloc_ctxt(const char *domain,
> -				u32 key)
> +static struct dlm_ctxt *dlm_alloc_ctxt(const char *domain, u32 key,
> +				unsigned int buckets)
>  {
>  	int i;
>  	struct dlm_ctxt *dlm = NULL;
> @@ -1380,7 +1380,14 @@ static struct dlm_ctxt *dlm_alloc_ctxt(c
>  		goto leave;
>  	}
>  
> -	dlm->lockres_hash = (struct hlist_head **)dlm_alloc_pagevec(DLM_HASH_PAGES);
> +	if (!buckets)
> +		buckets = DLM_DEFAULT_HASH_BUCKETS;
> +	buckets = (buckets + DLM_BUCKETS_PER_PAGE - 1) / DLM_BUCKETS_PER_PAGE
> +		  * DLM_BUCKETS_PER_PAGE;
> +	dlm->lockres_hash_buckets = buckets;
> +
> +	dlm->lockres_hash = (struct hlist_head **)dlm_alloc_pagevec(buckets
> +				/ DLM_BUCKETS_PER_PAGE);
>  	if (!dlm->lockres_hash) {
>  		mlog_errno(-ENOMEM);
>  		kfree(dlm->name);
> @@ -1389,7 +1396,7 @@ static struct dlm_ctxt *dlm_alloc_ctxt(c
>  		goto leave;
>  	}
>  
> -	for (i = 0; i < DLM_HASH_BUCKETS; i++)
> +	for (i = 0; i < dlm->lockres_hash_buckets; i++)
>  		INIT_HLIST_HEAD(dlm_lockres_hash(dlm, i));
>  
>  	strcpy(dlm->name, domain);
> @@ -1458,8 +1465,8 @@ leave:
>  /*
>   * dlm_register_domain: one-time setup per "domain"
>   */
> -struct dlm_ctxt * dlm_register_domain(const char *domain,
> -			       u32 key)
> +struct dlm_ctxt * dlm_register_domain(const char *domain, u32 key,
> +			unsigned int buckets)
>  {
>  	int ret;
>  	struct dlm_ctxt *dlm = NULL;
> @@ -1515,7 +1522,7 @@ retry:
>  	if (!new_ctxt) {
>  		spin_unlock(&dlm_domain_lock);
>  
> -		new_ctxt = dlm_alloc_ctxt(domain, key);
> +		new_ctxt = dlm_alloc_ctxt(domain, key, buckets);
>  		if (new_ctxt)
>  			goto retry;
>  
> Index: linux-2.6.16-SLES10_SP2_BRANCH/fs/ocfs2/dlm/dlmrecovery.c
> ===================================================================
> --- linux-2.6.16-SLES10_SP2_BRANCH.orig/fs/ocfs2/dlm/dlmrecovery.c
> +++ linux-2.6.16-SLES10_SP2_BRANCH/fs/ocfs2/dlm/dlmrecovery.c
> @@ -2020,7 +2020,7 @@ static void dlm_finish_local_lockres_rec
>  	 * for now we need to run the whole hash, clear
>  	 * the RECOVERING state and set the owner
>  	 * if necessary */
> -	for (i = 0; i < DLM_HASH_BUCKETS; i++) {
> +	for (i = 0; i < dlm->lockres_hash_buckets; i++) {
>  		bucket = dlm_lockres_hash(dlm, i);
>  		hlist_for_each_entry(res, hash_iter, bucket, hash_node) {
>  			if (res->state & DLM_LOCK_RES_RECOVERING) {
> @@ -2201,7 +2201,7 @@ static void dlm_do_local_recovery_cleanu
>  	 *    can be kicked again to see if any ASTs or BASTs
>  	 *    need to be fired as a result.
>  	 */
> -	for (i = 0; i < DLM_HASH_BUCKETS; i++) {
> +	for (i = 0; i < dlm->lockres_hash_buckets; i++) {
>  		bucket = dlm_lockres_hash(dlm, i);
>  		hlist_for_each_entry(res, iter, bucket, hash_node) {
>   			/* always prune any $RECOVERY entries for dead nodes,
> Index: linux-2.6.16-SLES10_SP2_BRANCH/fs/ocfs2/dlm/userdlm.c
> ===================================================================
> --- linux-2.6.16-SLES10_SP2_BRANCH.orig/fs/ocfs2/dlm/userdlm.c
> +++ linux-2.6.16-SLES10_SP2_BRANCH/fs/ocfs2/dlm/userdlm.c
> @@ -661,7 +661,7 @@ struct dlm_ctxt *user_dlm_register_conte
>  
>  	snprintf(domain, name->len + 1, "%.*s", name->len, name->name);
>  
> -	dlm = dlm_register_domain(domain, dlm_key);
> +	dlm = dlm_register_domain(domain, dlm_key, 0);
>  	if (IS_ERR(dlm))
>  		mlog_errno(PTR_ERR(dlm));
>  
> Index: linux-2.6.16-SLES10_SP2_BRANCH/fs/ocfs2/dlmglue.c
> ===================================================================
> --- linux-2.6.16-SLES10_SP2_BRANCH.orig/fs/ocfs2/dlmglue.c
> +++ linux-2.6.16-SLES10_SP2_BRANCH/fs/ocfs2/dlmglue.c
> @@ -2514,7 +2514,8 @@ int ocfs2_dlm_init(struct ocfs2_super *o
>  	dlm_key = crc32_le(0, osb->uuid_str, strlen(osb->uuid_str));
>  
>  	/* for now, uuid == domain */
> -	dlm = dlm_register_domain(osb->uuid_str, dlm_key);
> +	dlm = dlm_register_domain(osb->uuid_str, dlm_key,
> +			osb->dlm_hash_buckets);
>  	if (IS_ERR(dlm)) {
>  		status = PTR_ERR(dlm);
>  		mlog_errno(status);
> Index: linux-2.6.16-SLES10_SP2_BRANCH/fs/ocfs2/ocfs2.h
> ===================================================================
> --- linux-2.6.16-SLES10_SP2_BRANCH.orig/fs/ocfs2/ocfs2.h
> +++ linux-2.6.16-SLES10_SP2_BRANCH/fs/ocfs2/ocfs2.h
> @@ -218,6 +218,7 @@ struct ocfs2_super
>  
>  	unsigned long s_mount_opt;
>  	unsigned int s_atime_quantum;
> +	unsigned int dlm_hash_buckets;
>  
>  	u16 max_slots;
>  	s16 node_num;
> Index: linux-2.6.16-SLES10_SP2_BRANCH/fs/ocfs2/super.c
> ===================================================================
> --- linux-2.6.16-SLES10_SP2_BRANCH.orig/fs/ocfs2/super.c
> +++ linux-2.6.16-SLES10_SP2_BRANCH/fs/ocfs2/super.c
> @@ -40,6 +40,7 @@
>  #include <linux/crc32.h>
>  #include <linux/debugfs.h>
>  #include <linux/mount.h>
> +#include <linux/mm.h>
>  
>  #include <cluster/nodemanager.h>
>  
> @@ -88,6 +89,7 @@ struct mount_options
>  	unsigned int	atime_quantum;
>  	signed short	slot;
>  	unsigned int	localalloc_opt;
> +	unsigned int	dlm_hash_buckets;
>  };
>  
>  static int ocfs2_parse_options(struct super_block *sb, char *options,
> @@ -169,6 +171,7 @@ enum {
>  	Opt_commit,
>  	Opt_localalloc,
>  	Opt_localflocks,
> +	Opt_dlm_hash_buckets,
>  #ifdef OCFS2_ORACORE_WORKAROUNDS
>  	Opt_datavolume,
>  #endif
> @@ -190,6 +193,7 @@ static match_table_t tokens = {
>  	{Opt_commit, "commit=%u"},
>  	{Opt_localalloc, "localalloc=%d"},
>  	{Opt_localflocks, "localflocks"},
> +	{Opt_dlm_hash_buckets, "hash_buckets=%u"},
>  #ifdef OCFS2_ORACORE_WORKAROUNDS
>  	{Opt_datavolume, "datavolume"},
>  #endif
> @@ -633,6 +637,22 @@ static int ocfs2_fill_super(struct super
>  	osb->preferred_slot = parsed_options.slot;
>  	osb->osb_commit_interval = parsed_options.commit_interval;
>  	osb->local_alloc_size = parsed_options.localalloc_opt;
> +	if (parsed_options.dlm_hash_buckets)
> +		osb->dlm_hash_buckets = parsed_options.dlm_hash_buckets;
> +	else {
> +		/* Let's count 4 clusters per file, 64 KB at least */
> +		unsigned int exp_file_size_shift =
> +				max(16, osb->s_clustersize_bits + 2);
> +		struct sysinfo i;
> +
> +		si_meminfo(&i);
> +		/* Estimate number of files on FS and limit space used by
> +		 * hash table by 1/2048 of kernel memory */
> +		osb->dlm_hash_buckets = min_t(unsigned long long,
> +			sb->s_bdev->bd_inode->i_size >> exp_file_size_shift,
> +			(i.totalram >> 11) * (PAGE_SIZE /
> +					sizeof(struct hlist_head)));
> +	}
>  
>  #ifdef OCFS2_ORACORE_WORKAROUNDS
>  	if (osb->s_mount_opt & OCFS2_MOUNT_COMPAT_OCFS)
> @@ -807,6 +827,7 @@ static int ocfs2_parse_options(struct su
>  	mopt->atime_quantum = OCFS2_DEFAULT_ATIME_QUANTUM;
>  	mopt->slot = OCFS2_INVALID_SLOT;
>  	mopt->localalloc_opt = OCFS2_DEFAULT_LOCAL_ALLOC_SIZE;
> +	mopt->dlm_hash_buckets = 0;
>  
>  	if (!options) {
>  		status = 1;
> @@ -919,6 +940,19 @@ static int ocfs2_parse_options(struct su
>  			if (!is_remount)
>  				mopt->mount_opt |= OCFS2_MOUNT_LOCALFLOCKS;
>  			break;
> +		case Opt_dlm_hash_buckets:
> +			if (is_remount) {
> +				mlog(ML_ERROR, "Changing number of hash buckets"
> +					" during remount is not supported.\n");
> +				status = 0;
> +				goto bail;
> +			}
> +			if (match_int(&args[0], &option) || option <= 0) {
> +				status = 0;
> +				goto bail;
> +			}
> +			mopt->dlm_hash_buckets = option;
> +			break;
>  		default:
>  			mlog(ML_ERROR,
>  			     "Unrecognized mount option \"%s\" "
>   
