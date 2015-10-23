From: Joseph Qi <joseph.qi@huawei.com>
Date: Fri, 23 Oct 2015 17:18:42 +0800
Subject: [Ocfs2-devel] [PATCH] ocfs2: avoid occurring deadlock by
 changing ocfs2_wq from global to local.
In-Reply-To: <56124AFB.2090000@huawei.com>
References: <56124AFB.2090000@huawei.com>
Message-ID: <5629FB72.9080305@huawei.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Initialize osb->ocfs2_wq can be moved up and it should be checked if it
is NULL when flush work queue. Because it may fail in
ocfs2_initialize_super before osb->ocfs2_wq is initialized.

On 2015/10/5 18:03, jiangyiwen wrote:
> This patch is solving a scene of deadlock, as follows:
>   Node 1                Node 2                  Node 3
> 1)volume a and b are    only mount vol a        only mount vol b
>   mounted
> 
> 2)                      start to mount b        start to mount a
> 
> 3)                      check hb of Node 3      check hb of Node 2
>                         in vol a, qs_holds++    in vol b, qs_holds++
> 
> 4) -------------------- all nodes' network down --------------------
> 
> 5)                      progress of mount b     the same situation as
>                         failed, and then call   Node 2
>                         ocfs2_dismount_volume.
>                         but the process is hung,
>                         since there is a work
>                         in ocfs2_wq cannot beo
>                         completed. This work is
>                         about vol a, because
>                         ocfs2_wq is global wq.
>                         BTW, this work which is
>                         scheduled in ocfs2_wq is
>                         ocfs2_orphan_scan_work,
>                         and the context in this work
>                         needs to take inode lock
>                         of orphan_dir, because
>                         lockres owner are Node 1 and
>                         all nodes' nework has been down
>                         at the same time, so it can't
>                         get the inode lock.
> 
> 6)                      Why can't this node be fenced
>                         when network disconnected?
>                         Because the process of
>                         mount is hung what caused qs_holds
>                         is not equal 0.
> 
> Because all works in the ocfs2_wq are relative to the super block,
> so the solution is to change the ocfs2_wq from global to local,
> in other words, moving it into the structure of ocfs2 super.
> 
> Signed-off-by: Yiwen Jiang <jiangyiwen@huawei.com>
> ---
>  fs/ocfs2/alloc.c        |  4 ++--
>  fs/ocfs2/journal.c      |  8 ++++----
>  fs/ocfs2/localalloc.c   |  4 ++--
>  fs/ocfs2/ocfs2.h        |  6 ++++++
>  fs/ocfs2/quota_global.c |  2 +-
>  fs/ocfs2/super.c        | 37 +++++++++++++++----------------------
>  fs/ocfs2/super.h        |  2 --
>  7 files changed, 30 insertions(+), 33 deletions(-)
> 
> diff --git a/fs/ocfs2/alloc.c b/fs/ocfs2/alloc.c
> index 86181d6..f9e0ae7 100644
> --- a/fs/ocfs2/alloc.c
> +++ b/fs/ocfs2/alloc.c
> @@ -6079,7 +6079,7 @@ void ocfs2_schedule_truncate_log_flush(struct ocfs2_super *osb,
>  		if (cancel)
>  			cancel_delayed_work(&osb->osb_truncate_log_wq);
> 
> -		queue_delayed_work(ocfs2_wq, &osb->osb_truncate_log_wq,
> +		queue_delayed_work(osb->ocfs2_wq, &osb->osb_truncate_log_wq,
>  				   OCFS2_TRUNCATE_LOG_FLUSH_INTERVAL);
>  	}
>  }
> @@ -6254,7 +6254,7 @@ void ocfs2_truncate_log_shutdown(struct ocfs2_super *osb)
> 
>  	if (tl_inode) {
>  		cancel_delayed_work(&osb->osb_truncate_log_wq);
> -		flush_workqueue(ocfs2_wq);
> +		flush_workqueue(osb->ocfs2_wq);
> 
>  		status = ocfs2_flush_truncate_log(osb);
>  		if (status < 0)
> diff --git a/fs/ocfs2/journal.c b/fs/ocfs2/journal.c
> index ff82b28..93acf2d 100644
> --- a/fs/ocfs2/journal.c
> +++ b/fs/ocfs2/journal.c
> @@ -231,7 +231,7 @@ void ocfs2_recovery_exit(struct ocfs2_super *osb)
>  	/* At this point, we know that no more recovery threads can be
>  	 * launched, so wait for any recovery completion work to
>  	 * complete. */
> -	flush_workqueue(ocfs2_wq);
> +	flush_workqueue(osb->ocfs2_wq);
> 
>  	/*
>  	 * Now that recovery is shut down, and the osb is about to be
> @@ -1327,7 +1327,7 @@ static void ocfs2_queue_recovery_completion(struct ocfs2_journal *journal,
> 
>  	spin_lock(&journal->j_lock);
>  	list_add_tail(&item->lri_list, &journal->j_la_cleanups);
> -	queue_work(ocfs2_wq, &journal->j_recovery_work);
> +	queue_work(journal->j_osb->ocfs2_wq, &journal->j_recovery_work);
>  	spin_unlock(&journal->j_lock);
>  }
> 
> @@ -1972,7 +1972,7 @@ static void ocfs2_orphan_scan_work(struct work_struct *work)
>  	mutex_lock(&os->os_lock);
>  	ocfs2_queue_orphan_scan(osb);
>  	if (atomic_read(&os->os_state) == ORPHAN_SCAN_ACTIVE)
> -		queue_delayed_work(ocfs2_wq, &os->os_orphan_scan_work,
> +		queue_delayed_work(osb->ocfs2_wq, &os->os_orphan_scan_work,
>  				      ocfs2_orphan_scan_timeout());
>  	mutex_unlock(&os->os_lock);
>  }
> @@ -2012,7 +2012,7 @@ void ocfs2_orphan_scan_start(struct ocfs2_super *osb)
>  		atomic_set(&os->os_state, ORPHAN_SCAN_INACTIVE);
>  	else {
>  		atomic_set(&os->os_state, ORPHAN_SCAN_ACTIVE);
> -		queue_delayed_work(ocfs2_wq, &os->os_orphan_scan_work,
> +		queue_delayed_work(osb->ocfs2_wq, &os->os_orphan_scan_work,
>  				   ocfs2_orphan_scan_timeout());
>  	}
>  }
> diff --git a/fs/ocfs2/localalloc.c b/fs/ocfs2/localalloc.c
> index 0a4457f..3e19312 100644
> --- a/fs/ocfs2/localalloc.c
> +++ b/fs/ocfs2/localalloc.c
> @@ -387,7 +387,7 @@ void ocfs2_shutdown_local_alloc(struct ocfs2_super *osb)
>  	struct ocfs2_dinode *alloc = NULL;
> 
>  	cancel_delayed_work(&osb->la_enable_wq);
> -	flush_workqueue(ocfs2_wq);
> +	flush_workqueue(osb->ocfs2_wq);
> 
>  	if (osb->local_alloc_state == OCFS2_LA_UNUSED)
>  		goto out;
> @@ -1087,7 +1087,7 @@ static int ocfs2_recalc_la_window(struct ocfs2_super *osb,
>  		} else {
>  			osb->local_alloc_state = OCFS2_LA_DISABLED;
>  		}
> -		queue_delayed_work(ocfs2_wq, &osb->la_enable_wq,
> +		queue_delayed_work(osb->ocfs2_wq, &osb->la_enable_wq,
>  				   OCFS2_LA_ENABLE_INTERVAL);
>  		goto out_unlock;
>  	}
> diff --git a/fs/ocfs2/ocfs2.h b/fs/ocfs2/ocfs2.h
> index 7a01262..2ce47bf 100644
> --- a/fs/ocfs2/ocfs2.h
> +++ b/fs/ocfs2/ocfs2.h
> @@ -464,6 +464,12 @@ struct ocfs2_super
>  	struct ocfs2_refcount_tree *osb_ref_tree_lru;
> 
>  	struct mutex system_file_mutex;
> +
> +	/* OCFS2 needs to schedule several different types of work which
> +	 * require cluster locking, disk I/O, recovery waits, etc. Since these
> +	 * types of work tend to be heavy we avoid using the kernel events
> +	 * workqueue and schedule on our own. */
> +	struct workqueue_struct *ocfs2_wq;
>  };
> 
>  #define OCFS2_SB(sb)	    ((struct ocfs2_super *)(sb)->s_fs_info)
> diff --git a/fs/ocfs2/quota_global.c b/fs/ocfs2/quota_global.c
> index c93d672..44df24b 100644
> --- a/fs/ocfs2/quota_global.c
> +++ b/fs/ocfs2/quota_global.c
> @@ -726,7 +726,7 @@ static int ocfs2_release_dquot(struct dquot *dquot)
>  		dqgrab(dquot);
>  		/* First entry on list -> queue work */
>  		if (llist_add(&OCFS2_DQUOT(dquot)->list, &osb->dquot_drop_list))
> -			queue_work(ocfs2_wq, &osb->dquot_drop_work);
> +			queue_work(osb->ocfs2_wq, &osb->dquot_drop_work);
>  		goto out;
>  	}
>  	status = ocfs2_lock_global_qf(oinfo, 1);
> diff --git a/fs/ocfs2/super.c b/fs/ocfs2/super.c
> index 2de4c8a..130a17f 100644
> --- a/fs/ocfs2/super.c
> +++ b/fs/ocfs2/super.c
> @@ -79,12 +79,6 @@ static struct kmem_cache *ocfs2_inode_cachep;
>  struct kmem_cache *ocfs2_dquot_cachep;
>  struct kmem_cache *ocfs2_qf_chunk_cachep;
> 
> -/* OCFS2 needs to schedule several different types of work which
> - * require cluster locking, disk I/O, recovery waits, etc. Since these
> - * types of work tend to be heavy we avoid using the kernel events
> - * workqueue and schedule on our own. */
> -struct workqueue_struct *ocfs2_wq = NULL;
> -
>  static struct dentry *ocfs2_debugfs_root;
> 
>  MODULE_AUTHOR("Oracle");
> @@ -1612,33 +1606,25 @@ static int __init ocfs2_init(void)
>  	if (status < 0)
>  		goto out2;
> 
> -	ocfs2_wq = create_singlethread_workqueue("ocfs2_wq");
> -	if (!ocfs2_wq) {
> -		status = -ENOMEM;
> -		goto out3;
> -	}
> -
>  	ocfs2_debugfs_root = debugfs_create_dir("ocfs2", NULL);
>  	if (!ocfs2_debugfs_root) {
>  		status = -ENOMEM;
>  		mlog(ML_ERROR, "Unable to create ocfs2 debugfs root.\n");
> -		goto out4;
> +		goto out3;
>  	}
> 
>  	ocfs2_set_locking_protocol();
> 
>  	status = register_quota_format(&ocfs2_quota_format);
>  	if (status < 0)
> -		goto out4;
> +		goto out3;
>  	status = register_filesystem(&ocfs2_fs_type);
>  	if (!status)
>  		return 0;
> 
>  	unregister_quota_format(&ocfs2_quota_format);
> -out4:
> -	destroy_workqueue(ocfs2_wq);
> -	debugfs_remove(ocfs2_debugfs_root);
>  out3:
> +	debugfs_remove(ocfs2_debugfs_root);
>  	ocfs2_free_mem_caches();
>  out2:
>  	exit_ocfs2_uptodate_cache();
> @@ -1649,11 +1635,6 @@ out1:
> 
>  static void __exit ocfs2_exit(void)
>  {
> -	if (ocfs2_wq) {
> -		flush_workqueue(ocfs2_wq);
> -		destroy_workqueue(ocfs2_wq);
> -	}
> -
>  	unregister_quota_format(&ocfs2_quota_format);
> 
>  	debugfs_remove(ocfs2_debugfs_root);
> @@ -2348,6 +2329,12 @@ static int ocfs2_initialize_super(struct super_block *sb,
>  	}
>  	cleancache_init_shared_fs(sb);
> 
> +	osb->ocfs2_wq = create_singlethread_workqueue("ocfs2_wq");
> +	if (!osb->ocfs2_wq) {
> +		status = -ENOMEM;
> +		mlog_errno(status);
> +	}
> +
>  bail:
>  	return status;
>  }
> @@ -2535,6 +2522,12 @@ static void ocfs2_delete_osb(struct ocfs2_super *osb)
>  {
>  	/* This function assumes that the caller has the main osb resource */
> 
> +	/* ocfs2_initializer_super have already created this workqueue */
> +	if (osb->ocfs2_wq) {
> +		flush_workqueue(osb->ocfs2_wq);
> +		destroy_workqueue(osb->ocfs2_wq);
> +	}
> +
>  	ocfs2_free_slot_info(osb);
> 
>  	kfree(osb->osb_orphan_wipes);
> diff --git a/fs/ocfs2/super.h b/fs/ocfs2/super.h
> index b477d0b..b023e4f 100644
> --- a/fs/ocfs2/super.h
> +++ b/fs/ocfs2/super.h
> @@ -26,8 +26,6 @@
>  #ifndef OCFS2_SUPER_H
>  #define OCFS2_SUPER_H
> 
> -extern struct workqueue_struct *ocfs2_wq;
> -
>  int ocfs2_publish_get_mount_state(struct ocfs2_super *osb,
>  				  int node_num);
> 
