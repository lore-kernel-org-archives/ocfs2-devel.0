From: Wengang Wang <wen.gang.wang@oracle.com>
Date: Fri, 12 Nov 2010 10:24:00 +0800
Subject: [Ocfs2-devel] [PATCH 2/2] Thread recovery
In-Reply-To: <AANLkTi=4134YmXfqDO008gPzjZPCzxn6fnf3Hac55RV6@mail.gmail.com>
References: <AANLkTi=4134YmXfqDO008gPzjZPCzxn6fnf3Hac55RV6@mail.gmail.com>
Message-ID: <20101112022400.GB2316@laptop.jp.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On 10-11-11 19:01, Goldwyn Rodrigues wrote:
> This threads the recovery procedure so recovery of different nodes can be done
> in parallel.
> 
> osb->num_recovery_threads keeps a track of recovery threads in flight.
> 
> Signed-off-by: Goldwyn Rodrigues <rgoldwyn@suse.de>
> 
> ---
>  fs/ocfs2/journal.c |   37 ++++++++++++++++++++++++-------------
>  fs/ocfs2/journal.h |    2 ++
>  fs/ocfs2/ocfs2.h   |    2 ++
>  fs/ocfs2/super.c   |   12 ++++++++++++
>  4 files changed, 40 insertions(+), 13 deletions(-)
> 
> diff --git a/fs/ocfs2/journal.c b/fs/ocfs2/journal.c
> index 6c378d6..e9360c7 100644
> --- a/fs/ocfs2/journal.c
> +++ b/fs/ocfs2/journal.c
> @@ -58,7 +58,7 @@ DEFINE_SPINLOCK(trans_inc_lock);
>  #define ORPHAN_SCAN_SCHEDULE_TIMEOUT 300000
> 
>  static int ocfs2_force_read_journal(struct inode *inode);
> -static int ocfs2_recover_one_node(struct ocfs2_recover_node *rn);
> +static int ocfs2_recover_one_node(void *);
>  static int __ocfs2_recovery_thread(void *arg);
>  static int ocfs2_commit_cache(struct ocfs2_super *osb);
>  static int __ocfs2_wait_on_mount(struct ocfs2_super *osb, int quota);
> @@ -183,6 +183,8 @@ int ocfs2_recovery_init(struct ocfs2_super *osb)
>  	osb->recovery_thread_task = NULL;
>  	init_waitqueue_head(&osb->recovery_event);
>  	INIT_LIST_HEAD(&osb->s_recovery_nodes);
> +	init_waitqueue_head(&osb->recovery_wait);
> +	atomic_set(&osb->num_recovery_threads, 0);
> 
>  	return 0;
>  }
> @@ -1360,21 +1362,17 @@ restart:
>  		if (i == rm_quota_used)
>  			rm_quota[rm_quota_used++] = rn->rn_slot_num;
> 
> -		status = ocfs2_recover_one_node(rn);
> -skip_recovery:
> -		if (!status) {
> -			ocfs2_recovery_map_clear(osb, rn);
> -		} else {
> -			mlog(ML_ERROR,
> -			     "Error %d recovering node %d on device (%u,%u)!\n",
> -			     status, rn->rn_node_num,
> -			     MAJOR(osb->sb->s_dev), MINOR(osb->sb->s_dev));
> -			mlog(ML_ERROR, "Volume requires unmount.\n");
> -		}
> +		sprintf(rn->rn_str, "ocfs2rec%d", rn->rn_slot_num);
> +		rn->rn_thread = kthread_run(ocfs2_recover_one_node,
> +					(void *)rn, rn->rn_str);
> +		atomic_inc(&osb->num_recovery_threads);
> 
> +skip_recovery:
>  		spin_lock(&osb->osb_lock);
>  	}
>  	spin_unlock(&osb->osb_lock);
> +	wait_event(osb->recovery_wait,
> +			!atomic_read(&osb->num_recovery_threads));
>  	mlog(0, "All nodes recovered\n");
> 
>  	/* Refresh all journal recovery generations from disk */
> @@ -1649,8 +1647,9 @@ done:
>   * second part of a nodes recovery process (local alloc recovery) is
>   * far less concerning.
>   */
> -static int ocfs2_recover_one_node(struct ocfs2_recover_node *rn)
> +static int ocfs2_recover_one_node(void *arg)
>  {
> +	struct ocfs2_recover_node *rn = (struct ocfs2_recover_node *)arg;
>  	struct ocfs2_dinode *la_copy = NULL;
>  	struct ocfs2_dinode *tl_copy = NULL;
>  	struct ocfs2_super *osb = rn->rn_osb;
> @@ -1705,6 +1704,18 @@ static int ocfs2_recover_one_node(struct
> ocfs2_recover_node *rn)
>  	rn->rn_status = 0;
>  done:
> 
> +	if (!rn->rn_status) {
> +		ocfs2_recovery_map_clear(osb, rn);
> +	} else {
> +		mlog(ML_ERROR,
> +		     "Error %d recovering node %d on device (%u,%u)!\n",
> +		     rn->rn_status, rn->rn_node_num,
> +		     MAJOR(osb->sb->s_dev), MINOR(osb->sb->s_dev));
> +		mlog(ML_ERROR, "Volume requires unmount.\n");
> +	}
> +	if (atomic_dec_and_test(&osb->num_recovery_threads))
> +		wake_up(&osb->recovery_wait);
> +
>  	mlog_exit(rn->rn_status);
>  	return rn->rn_status;

using after free.
rn can be freed in ocfs2_recovery_map_clear().
>  }
> diff --git a/fs/ocfs2/journal.h b/fs/ocfs2/journal.h
> index 0325d81..247f3b1 100644
> --- a/fs/ocfs2/journal.h
> +++ b/fs/ocfs2/journal.h
> @@ -49,6 +49,8 @@ struct ocfs2_recover_node {
>  	int rn_slot_num;
>  	int rn_status;
>  	struct list_head rn_list;
> +	struct task_struct *rn_thread;
> +	char rn_str[13];
>  };
> 
> 
> diff --git a/fs/ocfs2/ocfs2.h b/fs/ocfs2/ocfs2.h
> index 318caac..ce625d8 100644
> --- a/fs/ocfs2/ocfs2.h
> +++ b/fs/ocfs2/ocfs2.h
> @@ -338,6 +338,8 @@ struct ocfs2_super
>  	atomic_t vol_state;
>  	struct mutex recovery_lock;
>  	struct list_head s_recovery_nodes;
> +	atomic_t num_recovery_threads;
> +	wait_queue_head_t recovery_wait;
> 
>  	struct ocfs2_replay_map *replay_map;
>  	struct task_struct *recovery_thread_task;
> diff --git a/fs/ocfs2/super.c b/fs/ocfs2/super.c
> index 478715b..a881032 100644
> --- a/fs/ocfs2/super.c
> +++ b/fs/ocfs2/super.c
> @@ -222,6 +222,8 @@ static int ocfs2_osb_dump(struct ocfs2_super *osb,
> char *buf, int len)
>  	struct ocfs2_cluster_connection *cconn = osb->cconn;
>  	struct ocfs2_orphan_scan *os = &osb->osb_orphan_scan;
>  	int i, out = 0;
> +	struct list_head *iter;
> +	struct ocfs2_recover_node *rn;
> 
>  	out += snprintf(buf + out, len - out,
>  			"%10s => Id: %-s  Uuid: %-s  Gen: 0x%X  Label: %-s\n",
> @@ -266,6 +268,16 @@ static int ocfs2_osb_dump(struct ocfs2_super
> *osb, char *buf, int len)
>  			osb->dc_work_sequence);
>  	spin_unlock(&osb->dc_task_lock);
> 
> +	spin_lock(&osb->osb_lock);
> +	list_for_each(iter, &osb->s_recovery_nodes) {
> +		rn = list_entry(iter, struct ocfs2_recover_node, rn_list);
> +		out += snprintf(buf + out, len - out,
> +				"Recovery => Pid: %d Node:%d\n",
> +				task_pid_nr(rn->rn_thread), rn->rn_node_num);
> +	}
> +	spin_unlock(&osb->osb_lock);
> +
> +
>  	out += snprintf(buf + out, len - out,
>  			"%10s => Pid: %d  Interval: %lu  Needs: %d\n", "Commit",
>  			(osb->commit_task ? task_pid_nr(osb->commit_task) : -1),
> -- 
> 1.7.1
> 
> 
> -- 
> Goldwyn
> 
> _______________________________________________
> Ocfs2-devel mailing list
> Ocfs2-devel at oss.oracle.com
> http://oss.oracle.com/mailman/listinfo/ocfs2-devel
