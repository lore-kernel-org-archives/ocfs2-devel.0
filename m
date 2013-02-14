From: Joel Becker <jlbec@evilplan.org>
Date: Wed, 13 Feb 2013 18:09:57 -0800
Subject: [Ocfs2-devel] + ocfs2-remove-kfree-redundant-null-checks.patch
 added to -mm tree
In-Reply-To: <20130213235506.60CB45A41B5@corp2gmr1-2.hot.corp.google.com>
References: <20130213235506.60CB45A41B5@corp2gmr1-2.hot.corp.google.com>
Message-ID: <20130214020954.GA18408@localhost>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Wed, Feb 13, 2013 at 03:55:05PM -0800, akpm at linux-foundation.org wrote:
> 
> The patch titled
>      Subject: ocfs2: remove kfree() redundant null checks
> has been added to the -mm tree.  Its filename is
>      ocfs2-remove-kfree-redundant-null-checks.patch
> 
> Before you just go and hit "reply", please:
>    a) Consider who else should be cc'ed
>    b) Prefer to cc a suitable mailing list as well
>    c) Ideally: find the original patch on the mailing list and do a
>       reply-to-all to that, adding suitable additional cc's
> 
> *** Remember to use Documentation/SubmitChecklist when testing your code ***
> 
> The -mm tree is included into linux-next and is updated
> there every 3-4 working days
> 
> ------------------------------------------------------
> From: Tim Gardner <tim.gardner@canonical.com>
> Subject: ocfs2: remove kfree() redundant null checks
> 
> smatch analysis indicates a number of redundant NULL checks before
> calling kfree(), e.g.,
> 
> fs/ocfs2/alloc.c:6138 ocfs2_begin_truncate_log_recovery() info:
>  redundant null check on *tl_copy calling kfree()
> 
> fs/ocfs2/alloc.c:6755 ocfs2_zero_range_for_truncate() info:
>  redundant null check on pages calling kfree()
> 
> etc....
> 
> Signed-off-by: Tim Gardner <tim.gardner@canonical.com>
> Cc: Mark Fasheh <mfasheh@suse.com>
> Cc: Joel Becker <jlbec@evilplan.org>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>

Acked-by: Joel Becker <jlbec@evilplan.org>

> ---
> 
>  fs/ocfs2/alloc.c             |    5 ++---
>  fs/ocfs2/cluster/heartbeat.c |    6 ++----
>  fs/ocfs2/cluster/tcp.c       |    6 ++----
>  fs/ocfs2/dlm/dlmdomain.c     |    4 +---
>  fs/ocfs2/extent_map.c        |    3 +--
>  fs/ocfs2/journal.c           |   10 +++-------
>  fs/ocfs2/localalloc.c        |    8 +++-----
>  fs/ocfs2/stack_o2cb.c        |    2 +-
>  fs/ocfs2/super.c             |    6 ++----
>  fs/ocfs2/sysfile.c           |    3 +--
>  10 files changed, 18 insertions(+), 35 deletions(-)
> 
> diff -puN fs/ocfs2/alloc.c~ocfs2-remove-kfree-redundant-null-checks fs/ocfs2/alloc.c
> --- a/fs/ocfs2/alloc.c~ocfs2-remove-kfree-redundant-null-checks
> +++ a/fs/ocfs2/alloc.c
> @@ -6134,7 +6134,7 @@ bail:
>  		iput(tl_inode);
>  	brelse(tl_bh);
>  
> -	if (status < 0 && (*tl_copy)) {
> +	if (status < 0) {
>  		kfree(*tl_copy);
>  		*tl_copy = NULL;
>  		mlog_errno(status);
> @@ -6751,8 +6751,7 @@ int ocfs2_zero_range_for_truncate(struct
>  		mlog_errno(ret);
>  
>  out:
> -	if (pages)
> -		kfree(pages);
> +	kfree(pages);
>  
>  	return ret;
>  }
> diff -puN fs/ocfs2/cluster/heartbeat.c~ocfs2-remove-kfree-redundant-null-checks fs/ocfs2/cluster/heartbeat.c
> --- a/fs/ocfs2/cluster/heartbeat.c~ocfs2-remove-kfree-redundant-null-checks
> +++ a/fs/ocfs2/cluster/heartbeat.c
> @@ -1449,8 +1449,7 @@ static void o2hb_region_release(struct c
>  
>  	mlog(ML_HEARTBEAT, "hb region release (%s)\n", reg->hr_dev_name);
>  
> -	if (reg->hr_tmp_block)
> -		kfree(reg->hr_tmp_block);
> +	kfree(reg->hr_tmp_block);
>  
>  	if (reg->hr_slot_data) {
>  		for (i = 0; i < reg->hr_num_pages; i++) {
> @@ -1464,8 +1463,7 @@ static void o2hb_region_release(struct c
>  	if (reg->hr_bdev)
>  		blkdev_put(reg->hr_bdev, FMODE_READ|FMODE_WRITE);
>  
> -	if (reg->hr_slots)
> -		kfree(reg->hr_slots);
> +	kfree(reg->hr_slots);
>  
>  	kfree(reg->hr_db_regnum);
>  	kfree(reg->hr_db_livenodes);
> diff -puN fs/ocfs2/cluster/tcp.c~ocfs2-remove-kfree-redundant-null-checks fs/ocfs2/cluster/tcp.c
> --- a/fs/ocfs2/cluster/tcp.c~ocfs2-remove-kfree-redundant-null-checks
> +++ a/fs/ocfs2/cluster/tcp.c
> @@ -1165,10 +1165,8 @@ out:
>  	o2net_debug_del_nst(&nst); /* must be before dropping sc and node */
>  	if (sc)
>  		sc_put(sc);
> -	if (vec)
> -		kfree(vec);
> -	if (msg)
> -		kfree(msg);
> +	kfree(vec);
> +	kfree(msg);
>  	o2net_complete_nsw(nn, &nsw, 0, 0, 0);
>  	return ret;
>  }
> diff -puN fs/ocfs2/dlm/dlmdomain.c~ocfs2-remove-kfree-redundant-null-checks fs/ocfs2/dlm/dlmdomain.c
> --- a/fs/ocfs2/dlm/dlmdomain.c~ocfs2-remove-kfree-redundant-null-checks
> +++ a/fs/ocfs2/dlm/dlmdomain.c
> @@ -319,9 +319,7 @@ static void dlm_free_ctxt_mem(struct dlm
>  	if (dlm->master_hash)
>  		dlm_free_pagevec((void **)dlm->master_hash, DLM_HASH_PAGES);
>  
> -	if (dlm->name)
> -		kfree(dlm->name);
> -
> +	kfree(dlm->name);
>  	kfree(dlm);
>  }
>  
> diff -puN fs/ocfs2/extent_map.c~ocfs2-remove-kfree-redundant-null-checks fs/ocfs2/extent_map.c
> --- a/fs/ocfs2/extent_map.c~ocfs2-remove-kfree-redundant-null-checks
> +++ a/fs/ocfs2/extent_map.c
> @@ -282,8 +282,7 @@ search:
>  	spin_unlock(&oi->ip_lock);
>  
>  out:
> -	if (new_emi)
> -		kfree(new_emi);
> +	kfree(new_emi);
>  }
>  
>  static int ocfs2_last_eb_is_empty(struct inode *inode,
> diff -puN fs/ocfs2/journal.c~ocfs2-remove-kfree-redundant-null-checks fs/ocfs2/journal.c
> --- a/fs/ocfs2/journal.c~ocfs2-remove-kfree-redundant-null-checks
> +++ a/fs/ocfs2/journal.c
> @@ -1234,11 +1234,8 @@ static void ocfs2_queue_recovery_complet
>  		/* Though we wish to avoid it, we are in fact safe in
>  		 * skipping local alloc cleanup as fsck.ocfs2 is more
>  		 * than capable of reclaiming unused space. */
> -		if (la_dinode)
> -			kfree(la_dinode);
> -
> -		if (tl_dinode)
> -			kfree(tl_dinode);
> +		kfree(la_dinode);
> +		kfree(tl_dinode);
>  
>  		if (qrec)
>  			ocfs2_free_quota_recovery(qrec);
> @@ -1408,8 +1405,7 @@ bail:
>  
>  	mutex_unlock(&osb->recovery_lock);
>  
> -	if (rm_quota)
> -		kfree(rm_quota);
> +	kfree(rm_quota);
>  
>  	/* no one is callint kthread_stop() for us so the kthread() api
>  	 * requires that we call do_exit().  And it isn't exported, but
> diff -puN fs/ocfs2/localalloc.c~ocfs2-remove-kfree-redundant-null-checks fs/ocfs2/localalloc.c
> --- a/fs/ocfs2/localalloc.c~ocfs2-remove-kfree-redundant-null-checks
> +++ a/fs/ocfs2/localalloc.c
> @@ -476,8 +476,7 @@ out:
>  	if (local_alloc_inode)
>  		iput(local_alloc_inode);
>  
> -	if (alloc_copy)
> -		kfree(alloc_copy);
> +	kfree(alloc_copy);
>  }
>  
>  /*
> @@ -534,7 +533,7 @@ int ocfs2_begin_local_alloc_recovery(str
>  		mlog_errno(status);
>  
>  bail:
> -	if ((status < 0) && (*alloc_copy)) {
> +	if (status < 0) {
>  		kfree(*alloc_copy);
>  		*alloc_copy = NULL;
>  	}
> @@ -1290,8 +1289,7 @@ bail:
>  	if (main_bm_inode)
>  		iput(main_bm_inode);
>  
> -	if (alloc_copy)
> -		kfree(alloc_copy);
> +	kfree(alloc_copy);
>  
>  	if (ac)
>  		ocfs2_free_alloc_context(ac);
> diff -puN fs/ocfs2/stack_o2cb.c~ocfs2-remove-kfree-redundant-null-checks fs/ocfs2/stack_o2cb.c
> --- a/fs/ocfs2/stack_o2cb.c~ocfs2-remove-kfree-redundant-null-checks
> +++ a/fs/ocfs2/stack_o2cb.c
> @@ -376,7 +376,7 @@ static int o2cb_cluster_connect(struct o
>  	dlm_register_eviction_cb(dlm, &priv->op_eviction_cb);
>  
>  out_free:
> -	if (rc && conn->cc_private)
> +	if (rc)
>  		kfree(conn->cc_private);
>  
>  out:
> diff -puN fs/ocfs2/super.c~ocfs2-remove-kfree-redundant-null-checks fs/ocfs2/super.c
> --- a/fs/ocfs2/super.c~ocfs2-remove-kfree-redundant-null-checks
> +++ a/fs/ocfs2/super.c
> @@ -2525,8 +2525,7 @@ static int ocfs2_check_volume(struct ocf
>  		mlog_errno(status);
>  
>  finally:
> -	if (local_alloc)
> -		kfree(local_alloc);
> +	kfree(local_alloc);
>  
>  	if (status)
>  		mlog_errno(status);
> @@ -2553,8 +2552,7 @@ static void ocfs2_delete_osb(struct ocfs
>  	 * we free it here.
>  	 */
>  	kfree(osb->journal);
> -	if (osb->local_alloc_copy)
> -		kfree(osb->local_alloc_copy);
> +	kfree(osb->local_alloc_copy);
>  	kfree(osb->uuid_str);
>  	ocfs2_put_dlm_debug(osb->osb_dlm_debug);
>  	memset(osb, 0, sizeof(struct ocfs2_super));
> diff -puN fs/ocfs2/sysfile.c~ocfs2-remove-kfree-redundant-null-checks fs/ocfs2/sysfile.c
> --- a/fs/ocfs2/sysfile.c~ocfs2-remove-kfree-redundant-null-checks
> +++ a/fs/ocfs2/sysfile.c
> @@ -91,8 +91,7 @@ static struct inode **get_local_system_i
>  		} else
>  			osb->local_system_inodes = local_system_inodes;
>  		spin_unlock(&osb->osb_lock);
> -		if (unlikely(free))
> -			kfree(free);
> +		kfree(free);
>  	}
>  
>  	index = (slot * NUM_LOCAL_SYSTEM_INODES) +
> _
> 
> Patches currently in -mm which might be from tim.gardner at canonical.com are
> 
> linux-next.patch
> ocfs2-remove-kfree-redundant-null-checks.patch
> ocfs2-remove-kfree-redundant-null-checks-fix.patch
> 

-- 

"I am working for the time when unqualified blacks, browns, and
 women join the unqualified men in running our overnment."
	- Sissy Farenthold

			http://www.jlbec.org/
			jlbec at evilplan.org
