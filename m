From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Wed, 01 Dec 2010 20:49:37 -0800
Subject: [Ocfs2-devel] [PATCH 1/2] Introduce ocfs2_recover_node
In-Reply-To: <AANLkTikcDcWTXPqPMKxySo9CDOKBfgqHxHcoXj0UO66B@mail.gmail.com>
References: <AANLkTikcDcWTXPqPMKxySo9CDOKBfgqHxHcoXj0UO66B@mail.gmail.com>
Message-ID: <4CF72561.5000202@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On 11/17/2010 07:50 AM, Goldwyn Rodrigues wrote:
> Review comments by Wengang incorporated.
>
> ocfs2_recover_node is a new data structure to include all information required
> to recover one node. The structure is maintainer as a list in the super block.

ocfs2_recover_node suggests action. How about calling it 
ocfs2_recovery_list.

> recovery_map is no longer required with ocfs2_recover_node.
>
> Signed-off-by: Goldwyn Rodrigues<rgoldwyn@suse.de>
> ---
>   fs/ocfs2/journal.c |  171 ++++++++++++++++++++++++----------------------------
>   fs/ocfs2/journal.h |    9 ++-
>   fs/ocfs2/ocfs2.h   |    3 +-
>   fs/ocfs2/super.c   |   16 -----
>   4 files changed, 88 insertions(+), 111 deletions(-)
>
> diff --git a/fs/ocfs2/journal.c b/fs/ocfs2/journal.c
> index faa2303..277b810 100644
> --- a/fs/ocfs2/journal.c
> +++ b/fs/ocfs2/journal.c
> @@ -58,8 +58,7 @@ DEFINE_SPINLOCK(trans_inc_lock);
>   #define ORPHAN_SCAN_SCHEDULE_TIMEOUT 300000
>
>   static int ocfs2_force_read_journal(struct inode *inode);
> -static int ocfs2_recover_node(struct ocfs2_super *osb,
> -			      int node_num, int slot_num);
> +static int ocfs2_recover_one_node(struct ocfs2_recover_node *rn);
>   static int __ocfs2_recovery_thread(void *arg);
>   static int ocfs2_commit_cache(struct ocfs2_super *osb);
>   static int __ocfs2_wait_on_mount(struct ocfs2_super *osb, int quota);
> @@ -179,24 +178,11 @@ void ocfs2_free_replay_slots(struct ocfs2_super *osb)
>
>   int ocfs2_recovery_init(struct ocfs2_super *osb)
>   {
> -	struct ocfs2_recovery_map *rm;
> -
>   	mutex_init(&osb->recovery_lock);
>   	osb->disable_recovery = 0;
>   	osb->recovery_thread_task = NULL;
>   	init_waitqueue_head(&osb->recovery_event);
> -
> -	rm = kzalloc(sizeof(struct ocfs2_recovery_map) +
> -		     osb->max_slots * sizeof(unsigned int),
> -		     GFP_KERNEL);
> -	if (!rm) {
> -		mlog_errno(-ENOMEM);
> -		return -ENOMEM;
> -	}
> -
> -	rm->rm_entries = (unsigned int *)((char *)rm +
> -					  sizeof(struct ocfs2_recovery_map));
> -	osb->recovery_map = rm;
> +	INIT_LIST_HEAD(&osb->s_recovery_nodes);
>
>   	return 0;
>   }
> @@ -212,8 +198,8 @@ static int ocfs2_recovery_thread_running(struct
> ocfs2_super *osb)
>
>   void ocfs2_recovery_exit(struct ocfs2_super *osb)
>   {
> -	struct ocfs2_recovery_map *rm;
> -
> +	struct list_head *iter, *next;
> +	struct ocfs2_recover_node *rn;
>   	/* disable any new recovery threads and wait for any currently
>   	 * running ones to exit. Do this before setting the vol_state. */
>   	mutex_lock(&osb->recovery_lock);
> @@ -226,75 +212,67 @@ void ocfs2_recovery_exit(struct ocfs2_super *osb)
>   	 * complete. */
>   	flush_workqueue(ocfs2_wq);
>
> -	/*
> -	 * Now that recovery is shut down, and the osb is about to be
> -	 * freed,  the osb_lock is not taken here.
> -	 */
> -	rm = osb->recovery_map;
> -	/* XXX: Should we bug if there are dirty entries? */

This comment is still relevant.

> -
> -	kfree(rm);
> +	spin_lock(&osb->osb_lock);
> +	list_for_each_safe(iter, next,&osb->s_recovery_nodes) {
> +			rn = list_entry(iter, struct ocfs2_recover_node,
> +					rn_list);
> +			list_del(&rn->rn_list);
> +			kfree(rn);
> +	}
> +	spin_unlock(&osb->osb_lock);

extra indentation

>   }
>
> -static int __ocfs2_recovery_map_test(struct ocfs2_super *osb,
> +static int __ocfs2_recovery_node_test(struct ocfs2_super *osb,
>   				     unsigned int node_num)
>   {
> -	int i;
> -	struct ocfs2_recovery_map *rm = osb->recovery_map;
> +	struct ocfs2_recover_node *rn;
> +	struct list_head *iter;
>
>   	assert_spin_locked(&osb->osb_lock);
> -
> -	for (i = 0; i<  rm->rm_used; i++) {
> -		if (rm->rm_entries[i] == node_num)
> +	list_for_each(iter,&osb->s_recovery_nodes) {
> +		rn = list_entry(iter, struct ocfs2_recover_node, rn_list);
> +		if (rn->rn_node_num == node_num)
>   			return 1;
>   	}
> -
>   	return 0;
>   }
>
>   /* Behaves like test-and-set.  Returns the previous value */
> -static int ocfs2_recovery_map_set(struct ocfs2_super *osb,
> +static int ocfs2_recovery_node_set(struct ocfs2_super *osb,
>   				  unsigned int node_num)
>   {
> -	struct ocfs2_recovery_map *rm = osb->recovery_map;
> -
> -	spin_lock(&osb->osb_lock);
> -	if (__ocfs2_recovery_map_test(osb, node_num)) {
> -		spin_unlock(&osb->osb_lock);
> -		return 1;
> -	}
> +	struct list_head *iter;
> +	struct ocfs2_recover_node *rn = NULL, *trn;
>
> -	/* XXX: Can this be exploited? Not from o2dlm... */
> -	BUG_ON(rm->rm_used>= osb->max_slots);
> +	trn = kzalloc(sizeof(struct ocfs2_recover_node), GFP_NOFS);
> +	if (!trn)
> +		return -ENOMEM;

Is this enomem case handled properly up the stack? This is new.
Previously we allocated memory upfront. Wondering why we cannot
so the same here.

> -	rm->rm_entries[rm->rm_used] = node_num;
> -	rm->rm_used++;
> +	spin_lock(&osb->osb_lock);
> +	list_for_each(iter,&osb->s_recovery_nodes) {
> +			rn = list_entry(iter, struct ocfs2_recover_node,
> +					rn_list);
> +			if (rn->rn_node_num == node_num) {
> +				spin_unlock(&osb->osb_lock);
> +				kfree(trn);
> +				return 1;
> +			}
> +	}

extra indentation

> +	trn->rn_node_num = node_num;
> +	trn->rn_osb = osb;
> +	list_add_tail(&trn->rn_list,&osb->s_recovery_nodes);
>   	spin_unlock(&osb->osb_lock);
>
>   	return 0;
>   }
>
> -static void ocfs2_recovery_map_clear(struct ocfs2_super *osb,
> -				     unsigned int node_num)
> +static void ocfs2_recovery_node_clear(struct ocfs2_super *osb,
> +			struct ocfs2_recover_node *rn)
>   {
> -	int i;
> -	struct ocfs2_recovery_map *rm = osb->recovery_map;
> -
>   	spin_lock(&osb->osb_lock);
> -
> -	for (i = 0; i<  rm->rm_used; i++) {
> -		if (rm->rm_entries[i] == node_num)
> -			break;
> -	}
> -
> -	if (i<  rm->rm_used) {
> -		/* XXX: be careful with the pointer math */
> -		memmove(&(rm->rm_entries[i]),&(rm->rm_entries[i + 1]),
> -			(rm->rm_used - i - 1) * sizeof(unsigned int));
> -		rm->rm_used--;
> -	}
> -
> +	list_del(&rn->rn_list);
>   	spin_unlock(&osb->osb_lock);
> +	kfree(rn);

Aah...we did memmove. That won't work here. So list manipulation it is.

>   }
>
>   static int ocfs2_commit_cache(struct ocfs2_super *osb)
> @@ -1092,10 +1070,9 @@ bail:
>   static int ocfs2_recovery_completed(struct ocfs2_super *osb)
>   {
>   	int empty;
> -	struct ocfs2_recovery_map *rm = osb->recovery_map;
>
>   	spin_lock(&osb->osb_lock);
> -	empty = (rm->rm_used == 0);
> +	empty = list_empty(&osb->s_recovery_nodes);
>   	spin_unlock(&osb->osb_lock);
>
>   	return empty;
> @@ -1332,12 +1309,13 @@ void ocfs2_complete_quota_recovery(struct
> ocfs2_super *osb)
>
>   static int __ocfs2_recovery_thread(void *arg)
>   {
> -	int status, node_num, slot_num;
> +	int status;
>   	struct ocfs2_super *osb = arg;
> -	struct ocfs2_recovery_map *rm = osb->recovery_map;
>   	int *rm_quota = NULL;
>   	int rm_quota_used = 0, i;
>   	struct ocfs2_quota_recovery *qrec;
> +	struct list_head *iter;
> +	struct ocfs2_recover_node *rn = NULL;
>
>   	mlog_entry_void();
>
> @@ -1367,20 +1345,21 @@ restart:
>   					NULL, NULL);
>
>   	spin_lock(&osb->osb_lock);
> -	while (rm->rm_used) {
> +	list_for_each(iter,&osb->s_recovery_nodes) {
> +		rn = list_entry(iter, struct ocfs2_recover_node, rn_list);
>   		/* It's always safe to remove entry zero, as we won't
>   		 * clear it until ocfs2_recover_node() has succeeded. */
> -		node_num = rm->rm_entries[0];
>   		spin_unlock(&osb->osb_lock);
> -		mlog(0, "checking node %d\n", node_num);
> -		slot_num = ocfs2_node_num_to_slot(osb, node_num);
> -		if (slot_num == -ENOENT) {
> +		mlog(0, "checking node %d\n", rn->rn_node_num);
> +		rn->rn_slot_num = ocfs2_node_num_to_slot(osb, rn->rn_node_num);
> +		if (rn->rn_slot_num == -ENOENT) {
>   			status = 0;
>   			mlog(0, "no slot for this node, so no recovery"
>   			     "required.\n");
>   			goto skip_recovery;
>   		}
> -		mlog(0, "node %d was using slot %d\n", node_num, slot_num);
> +		mlog(0, "node %d was using slot %d\n",
> +				rn->rn_node_num, rn->rn_slot_num);
>
>   		/* It is a bit subtle with quota recovery. We cannot do it
>   		 * immediately because we have to obtain cluster locks from
> @@ -1388,18 +1367,19 @@ restart:
>   		 * then quota usage would be out of sync until some node takes
>   		 * the slot. So we remember which nodes need quota recovery
>   		 * and when everything else is done, we recover quotas. */
> -		for (i = 0; i<  rm_quota_used&&  rm_quota[i] != slot_num; i++);
> +		for (i = 0; i<  rm_quota_used&&  rm_quota[i] != rn->rn_slot_num;
> +					i++);
>   		if (i == rm_quota_used)
> -			rm_quota[rm_quota_used++] = slot_num;
> +			rm_quota[rm_quota_used++] = rn->rn_slot_num;
>
> -		status = ocfs2_recover_node(osb, node_num, slot_num);
> +		status = ocfs2_recover_one_node(rn);
>   skip_recovery:
>   		if (!status) {
> -			ocfs2_recovery_map_clear(osb, node_num);
> +			ocfs2_recovery_node_clear(osb, rn);
>   		} else {
>   			mlog(ML_ERROR,
>   			     "Error %d recovering node %d on device (%u,%u)!\n",
> -			     status, node_num,
> +			     status, rn->rn_node_num,
>   			     MAJOR(osb->sb->s_dev), MINOR(osb->sb->s_dev));
>   			mlog(ML_ERROR, "Volume requires unmount.\n");

Hmm... this mlog could do with some clean up. But that can be
a separate change.

>   		}
> @@ -1461,6 +1441,7 @@ bail:
>
>   void ocfs2_recovery_thread(struct ocfs2_super *osb, int node_num)
>   {
> +	int ret = 0;
>   	mlog_entry("(node_num=%d, osb->node_num = %d)\n",
>   		   node_num, osb->node_num);
>
> @@ -1470,7 +1451,11 @@ void ocfs2_recovery_thread(struct ocfs2_super
> *osb, int node_num)
>
>   	/* People waiting on recovery will wait on
>   	 * the recovery map to empty. */
> -	if (ocfs2_recovery_map_set(osb, node_num))
> +	ret = ocfs2_recovery_node_set(osb, node_num);
> +	if (ret == -ENOMEM) {
> +		mlog_errno(ret);
> +		goto out;
> +	} else if (ret)
>   		mlog(0, "node %d already in recovery map.\n", node_num);
>
>   	mlog(0, "starting recovery thread...\n");
> @@ -1681,26 +1666,27 @@ done:
>    * second part of a nodes recovery process (local alloc recovery) is
>    * far less concerning.
>    */
> -static int ocfs2_recover_node(struct ocfs2_super *osb,
> -			      int node_num, int slot_num)
> +static int ocfs2_recover_one_node(struct ocfs2_recover_node *rn)
>   {
>   	int status = 0;
>   	struct ocfs2_dinode *la_copy = NULL;
>   	struct ocfs2_dinode *tl_copy = NULL;
> +	struct ocfs2_super *osb = rn->rn_osb;
>
>   	mlog_entry("(node_num=%d, slot_num=%d, osb->node_num = %d)\n",
> -		   node_num, slot_num, osb->node_num);
> +		   rn->rn_node_num, rn->rn_slot_num, osb->node_num);
>
>   	/* Should not ever be called to recover ourselves -- in that
>   	 * case we should've called ocfs2_journal_load instead. */
> -	BUG_ON(osb->node_num == node_num);
> +	BUG_ON(osb->node_num == rn->rn_node_num);
>
> -	status = ocfs2_replay_journal(osb, node_num, slot_num);
> +	status = ocfs2_replay_journal(osb, rn->rn_node_num,
> +			rn->rn_slot_num);
>   	if (status<  0) {
>   		if (status == -EBUSY) {
>   			mlog(0, "Skipping recovery for slot %u (node %u) "
> -			     "as another node has recovered it\n", slot_num,
> -			     node_num);
> +			     "as another node has recovered it\n",
> +			     rn->rn_slot_num, rn->rn_node_num);
>   			status = 0;
>   			goto done;
>   		}
> @@ -1709,7 +1695,8 @@ static int ocfs2_recover_node(struct ocfs2_super *osb,
>   	}
>
>   	/* Stamp a clean local alloc file AFTER recovering the journal... */
> -	status = ocfs2_begin_local_alloc_recovery(osb, slot_num,&la_copy);
> +	status = ocfs2_begin_local_alloc_recovery(osb, rn->rn_slot_num,
> +			&la_copy);
>   	if (status<  0) {
>   		mlog_errno(status);
>   		goto done;
> @@ -1718,22 +1705,24 @@ static int ocfs2_recover_node(struct ocfs2_super *osb,
>   	/* An error from begin_truncate_log_recovery is not
>   	 * serious enough to warrant halting the rest of
>   	 * recovery. */
> -	status = ocfs2_begin_truncate_log_recovery(osb, slot_num,&tl_copy);
> +	status = ocfs2_begin_truncate_log_recovery(osb,
> +			rn->rn_slot_num,&tl_copy);
>   	if (status<  0)
>   		mlog_errno(status);
>
>   	/* Likewise, this would be a strange but ultimately not so
>   	 * harmful place to get an error... */
> -	status = ocfs2_clear_slot(osb, slot_num);
> +	status = ocfs2_clear_slot(osb, rn->rn_slot_num);
>   	if (status<  0)
>   		mlog_errno(status);
>
>   	/* This will kfree the memory pointed to by la_copy and tl_copy */
> -	ocfs2_queue_recovery_completion(osb->journal, slot_num, la_copy,
> -					tl_copy, NULL);
> +	ocfs2_queue_recovery_completion(osb->journal, rn->rn_slot_num,
> +				la_copy, tl_copy, NULL);
>
>   	status = 0;
>   done:
> +	rn->rn_status = status;
>
>   	mlog_exit(status);
>   	return status;
> @@ -1822,7 +1811,7 @@ int ocfs2_mark_dead_nodes(struct ocfs2_super *osb)
>   			continue;
>   		}
>
> -		if (__ocfs2_recovery_map_test(osb, node_num)) {
> +		if (__ocfs2_recovery_node_test(osb, node_num)) {
>   			spin_unlock(&osb->osb_lock);
>   			continue;
>   		}
> diff --git a/fs/ocfs2/journal.h b/fs/ocfs2/journal.h
> index 43e56b9..0325d81 100644
> --- a/fs/ocfs2/journal.h
> +++ b/fs/ocfs2/journal.h
> @@ -43,9 +43,12 @@ struct ocfs2_dinode;
>    * It is protected by the recovery_lock.
>    */
>
> -struct ocfs2_recovery_map {
> -	unsigned int rm_used;
> -	unsigned int *rm_entries;
> +struct ocfs2_recover_node {
> +	struct ocfs2_super *rn_osb;
> +	int rn_node_num;
> +	int rn_slot_num;
> +	int rn_status;
> +	struct list_head rn_list;
>   };

See comment above.

>
> diff --git a/fs/ocfs2/ocfs2.h b/fs/ocfs2/ocfs2.h
> index 1efea36..f70c25a 100644
> --- a/fs/ocfs2/ocfs2.h
> +++ b/fs/ocfs2/ocfs2.h
> @@ -337,7 +337,8 @@ struct ocfs2_super
>
>   	atomic_t vol_state;
>   	struct mutex recovery_lock;
> -	struct ocfs2_recovery_map *recovery_map;
> +	struct list_head s_recovery_nodes;

s_recovery_list will fit better.

> +
>   	struct ocfs2_replay_map *replay_map;
>   	struct task_struct *recovery_thread_task;
>   	int disable_recovery;
> diff --git a/fs/ocfs2/super.c b/fs/ocfs2/super.c
> index f02c0ef..478715b 100644
> --- a/fs/ocfs2/super.c
> +++ b/fs/ocfs2/super.c
> @@ -220,7 +220,6 @@ static const match_table_t tokens = {
>   static int ocfs2_osb_dump(struct ocfs2_super *osb, char *buf, int len)
>   {
>   	struct ocfs2_cluster_connection *cconn = osb->cconn;
> -	struct ocfs2_recovery_map *rm = osb->recovery_map;
>   	struct ocfs2_orphan_scan *os =&osb->osb_orphan_scan;
>   	int i, out = 0;
>
> @@ -267,21 +266,6 @@ static int ocfs2_osb_dump(struct ocfs2_super
> *osb, char *buf, int len)
>   			osb->dc_work_sequence);
>   	spin_unlock(&osb->dc_task_lock);
>
> -	spin_lock(&osb->osb_lock);
> -	out += snprintf(buf + out, len - out, "%10s =>  Pid: %d  Nodes:",
> -			"Recovery",
> -			(osb->recovery_thread_task ?
> -			 task_pid_nr(osb->recovery_thread_task) : -1));
> -	if (rm->rm_used == 0)
> -		out += snprintf(buf + out, len - out, " None\n");
> -	else {
> -		for (i = 0; i<  rm->rm_used; i++)
> -			out += snprintf(buf + out, len - out, " %d",
> -					rm->rm_entries[i]);
> -		out += snprintf(buf + out, len - out, "\n");
> -	}
> -	spin_unlock(&osb->osb_lock);
> -
>   	out += snprintf(buf + out, len - out,
>   			"%10s =>  Pid: %d  Interval: %lu  Needs: %d\n", "Commit",
>   			(osb->commit_task ? task_pid_nr(osb->commit_task) : -1),
