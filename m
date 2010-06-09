From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Wed, 09 Jun 2010 16:46:48 -0700
Subject: [Ocfs2-devel] [PATCH] Reoganize data elements to reduce memory
 footprint
In-Reply-To: <AANLkTinTCrwXLiCjOm4l7uIzjRSz-17vJLLhNaCMDFJa@mail.gmail.com>
References: <AANLkTinTCrwXLiCjOm4l7uIzjRSz-17vJLLhNaCMDFJa@mail.gmail.com>
Message-ID: <4C1027E8.3090405@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

comments inlined.

On 06/09/2010 02:57 PM, Goldwyn Rodrigues wrote:
> This is the re-arrangement of the data elements of ocfs2 data structures
> to reduce memory consumption as shown by pahole on an x86_64 box.
> I have tried to keep the context as close as possible, though I was
> pretty agressive to get the numbers down.
>
> Statistics in bytes: (before - after = reduction)
> ocfs2_write_ctxt: 2144 - 2136 = 8
> ocfs2_inode_info: 1960 - 1896 = 64
> ocfs2_journal: 168 - 160 = 8
> ocfs2_lock_res: 336 - 320 = 16
> ocfs2_refcount_tree: 512 - 488 = 24
>
> Signed-off-by: Goldwyn Rodrigues<rgoldwyn@suse.de>
> ---
> diff --git a/fs/ocfs2/aops.c b/fs/ocfs2/aops.c
> index 3623ca2..1b5e284 100644
> --- a/fs/ocfs2/aops.c
> +++ b/fs/ocfs2/aops.c
> @@ -910,8 +910,8 @@ struct ocfs2_write_ctxt {
>   	 * out in so that future reads from that region will get
>   	 * zero's.
>   	 */
> -	struct page			*w_pages[OCFS2_MAX_CTXT_PAGES];
>   	unsigned int			w_num_pages;
> +	struct page			*w_pages[OCFS2_MAX_CTXT_PAGES];
>   	struct page			*w_target_page;
>    

looks good.

>   	/*
> diff --git a/fs/ocfs2/inode.h b/fs/ocfs2/inode.h
> index 9f5f5fc..e2b0053 100644
> --- a/fs/ocfs2/inode.h
> +++ b/fs/ocfs2/inode.h
> @@ -46,26 +46,21 @@ struct ocfs2_inode_info
>   	/* These fields are protected by ip_lock */
>   	spinlock_t			ip_lock;
>   	u32				ip_open_count;
> -	u32				ip_clusters;
>   	struct list_head		ip_io_markers;
> +	u32				ip_clusters;
>    

ok.

> +	u16				ip_dyn_features;
>   	struct mutex			ip_io_mutex;
> -
>   	u32				ip_flags; /* see below */
>   	u32				ip_attr; /* inode attributes */
> -	u16				ip_dyn_features;
>    

ok.

>   	/* protected by recovery_lock. */
>   	struct inode			*ip_next_orphan;
> -
> -	u32				ip_dir_start_lookup;
> -
>   	struct ocfs2_caching_info	ip_metadata_cache;
> -
>   	struct ocfs2_extent_map		ip_extent_map;
> -
>   	struct inode			vfs_inode;
>   	struct jbd2_inode		ip_jinode;
> +	u32				ip_dir_start_lookup;
>    

reinstate the empty line after ip_next_orphan so that it does
not give the impression that the other fields are also protected
by recovery_lock. Also add empty lines around ip_dir_start_lookup.

>   	/* Only valid if the inode is the dir. */
>   	u32				ip_last_used_slot;
> diff --git a/fs/ocfs2/journal.h b/fs/ocfs2/journal.h
> index b5baaa8..ed05ac3 100644
> --- a/fs/ocfs2/journal.h
> +++ b/fs/ocfs2/journal.h
> @@ -67,11 +67,11 @@ struct ocfs2_journal {
>   	struct buffer_head        *j_bh;      /* Journal disk inode block */
>   	atomic_t                  j_num_trans; /* Number of transactions
>   					        * currently in the system. */
> +	spinlock_t                j_lock;
>   	unsigned long             j_trans_id;
>   	struct rw_semaphore       j_trans_barrier;
>   	wait_queue_head_t         j_checkpointed;
>
> -	spinlock_t                j_lock;
>   	struct list_head          j_la_cleanups;
>   	struct work_struct        j_recovery_work;
>   };
>    

add a comment before j_la_cleanups saying "both protected by j_lock".

> diff --git a/fs/ocfs2/ocfs2.h b/fs/ocfs2/ocfs2.h
> index c67003b..34b9c79 100644
> --- a/fs/ocfs2/ocfs2.h
> +++ b/fs/ocfs2/ocfs2.h
> @@ -151,17 +151,16 @@ struct ocfs2_lock_res {
>   	void                    *l_priv;
>   	struct ocfs2_lock_res_ops *l_ops;
>   	spinlock_t               l_lock;
> +	enum ocfs2_lock_type     l_type;
>
>   	struct list_head         l_blocked_list;
>   	struct list_head         l_mask_waiters;
>
> -	enum ocfs2_lock_type     l_type;
>   	unsigned long		 l_flags;
>   	char                     l_name[OCFS2_LOCK_ID_MAX_LEN];
>   	int                      l_level;
>   	unsigned int             l_ro_holders;
>   	unsigned int             l_ex_holders;
> -	struct ocfs2_dlm_lksb    l_lksb;
>
>   	/* used from AST/BAST funcs. */
>   	enum ocfs2_ast_action    l_action;
> @@ -170,6 +169,7 @@ struct ocfs2_lock_res {
>   	int                      l_blocking;
>   	unsigned int             l_pending_gen;
>
> +	struct ocfs2_dlm_lksb    l_lksb;
>   	wait_queue_head_t        l_event;
>
>   	struct list_head         l_debug_list;
>    

add empty lines around both l_lksb and l_type

> diff --git a/fs/ocfs2/refcounttree.h b/fs/ocfs2/refcounttree.h
> index 9983ba1..67a89e4 100644
> --- a/fs/ocfs2/refcounttree.h
> +++ b/fs/ocfs2/refcounttree.h
> @@ -21,14 +21,14 @@ struct ocfs2_refcount_tree {
>   	struct rb_node rf_node;
>   	u64 rf_blkno;
>   	u32 rf_generation;
> +	struct kref rf_getcnt;
>   	struct rw_semaphore rf_sem;
>   	struct ocfs2_lock_res rf_lockres;
> -	struct kref rf_getcnt;
>   	int rf_removed;
> +	spinlock_t rf_lock;
>
>   	/* the following 4 fields are used by caching_info. */
>   	struct ocfs2_caching_info rf_ci;
> -	spinlock_t rf_lock;
>   	struct mutex rf_io_mutex;
>   	struct super_block *rf_sb;
>   };
>    

Move rf_lock below the comment.
