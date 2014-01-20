From: Goldwyn Rodrigues <rgoldwyn@suse.de>
Date: Mon, 20 Jan 2014 09:31:40 -0600
Subject: [Ocfs2-devel] [PATCH 5/5] ocfs2: Implement delayed dropping of
	last dquot reference
In-Reply-To: <20140116225858.GA25384@quack.suse.cz>
References: <1389911329-25523-1-git-send-email-jack@suse.cz>
	<1389911329-25523-6-git-send-email-jack@suse.cz>
	<20140116225858.GA25384@quack.suse.cz>
Message-ID: <52DD415C.6010901@suse.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On 01/16/2014 04:58 PM, Jan Kara wrote:
> On Thu 16-01-14 23:28:49, Jan Kara wrote:
>> We cannot drop last dquot reference from downconvert thread as that
>> creates the following deadlock:
>>
>> NODE 1                                  NODE2
>> holds dentry lock for 'foo'
>> holds inode lock for GLOBAL_BITMAP_SYSTEM_INODE
>>                                          dquot_initialize(bar)
>>                                            ocfs2_dquot_acquire()
>>                                              ocfs2_inode_lock(USER_QUOTA_SYSTEM_INODE)
>>                                              ...
>> downconvert thread (triggered from another
>> node or a different process from NODE2)
>>    ocfs2_dentry_post_unlock()
>>      ...
>>      iput(foo)
>>        ocfs2_evict_inode(foo)
>>          ocfs2_clear_inode(foo)
>>            dquot_drop(inode)
>>              ...
>> 	    ocfs2_dquot_release()
>>                ocfs2_inode_lock(USER_QUOTA_SYSTEM_INODE)
>>                 - blocks
>>                                              finds we need more space in
>>                                              quota file
>>                                              ...
>>                                              ocfs2_extend_no_holes()
>>                                                ocfs2_inode_lock(GLOBAL_BITMAP_SYSTEM_INODE)
>>                                                  - deadlocks waiting for
>>                                                    downconvert thread
>>
>> We solve the problem by postponing dropping of the last dquot reference
>> to a workqueue if it happens from the downconvert thread.
>    Hum, now looking again into ocfs2_clear_inode() there are more problems
> than I originally thought. Look for example at
> ocfs2_mark_lockres_freeing(). That will block on rw/inode/open lock if
> there is downconvert pending waiting for that downconvert to finish.
> However that never happens when ocfs2_clear_inode() is called from the
> downconvert thread.
>
> So we are back to square one - I don't see a way how to fix these deadlocks
> without postponing dropping of inode reference to a workqueue :(.
>

Since the reason of the unlink performance is the delay in calling 
ocfs2_open_unlock(), and the ocfs2_mark_lockres_freeing() comes after 
ocfs2_open_unlock(): can we move the call to ocfs2_open_unlock() to 
ocfs2_evict_inode() and then perform ocfs2_clear_inode() in a deferred way?


> 								Honza
>
>
>>
>> Signed-off-by: Jan Kara <jack@suse.cz>
>> ---
>>   fs/ocfs2/ocfs2.h        |  5 +++++
>>   fs/ocfs2/quota.h        |  2 ++
>>   fs/ocfs2/quota_global.c | 35 +++++++++++++++++++++++++++++++++++
>>   fs/ocfs2/super.c        |  8 ++++++++
>>   4 files changed, 50 insertions(+)
>>
>> diff --git a/fs/ocfs2/ocfs2.h b/fs/ocfs2/ocfs2.h
>> index ca81f6b49236..f6134345fe42 100644
>> --- a/fs/ocfs2/ocfs2.h
>> +++ b/fs/ocfs2/ocfs2.h
>> @@ -30,6 +30,7 @@
>>   #include <linux/sched.h>
>>   #include <linux/wait.h>
>>   #include <linux/list.h>
>> +#include <linux/llist.h>
>>   #include <linux/rbtree.h>
>>   #include <linux/workqueue.h>
>>   #include <linux/kref.h>
>> @@ -410,6 +411,10 @@ struct ocfs2_super
>>   	struct list_head blocked_lock_list;
>>   	unsigned long blocked_lock_count;
>>
>> +	/* List of dquot structures to drop last reference to */
>> +	struct llist_head dquot_drop_list;
>> +	struct work_struct dquot_drop_work;
>> +
>>   	wait_queue_head_t		osb_mount_event;
>>
>>   	/* Truncate log info */
>> diff --git a/fs/ocfs2/quota.h b/fs/ocfs2/quota.h
>> index d5ab56cbe5c5..f266d67df3c6 100644
>> --- a/fs/ocfs2/quota.h
>> +++ b/fs/ocfs2/quota.h
>> @@ -28,6 +28,7 @@ struct ocfs2_dquot {
>>   	unsigned int dq_use_count;	/* Number of nodes having reference to this entry in global quota file */
>>   	s64 dq_origspace;	/* Last globally synced space usage */
>>   	s64 dq_originodes;	/* Last globally synced inode usage */
>> +	struct llist_node list;	/* Member of list of dquots to drop */
>>   };
>>
>>   /* Description of one chunk to recover in memory */
>> @@ -110,6 +111,7 @@ int ocfs2_read_quota_phys_block(struct inode *inode, u64 p_block,
>>   int ocfs2_create_local_dquot(struct dquot *dquot);
>>   int ocfs2_local_release_dquot(handle_t *handle, struct dquot *dquot);
>>   int ocfs2_local_write_dquot(struct dquot *dquot);
>> +void ocfs2_drop_dquot_refs(struct work_struct *work);
>>
>>   extern const struct dquot_operations ocfs2_quota_operations;
>>   extern struct quota_format_type ocfs2_quota_format;
>> diff --git a/fs/ocfs2/quota_global.c b/fs/ocfs2/quota_global.c
>> index aaa50611ec66..7921e209c64b 100644
>> --- a/fs/ocfs2/quota_global.c
>> +++ b/fs/ocfs2/quota_global.c
>> @@ -10,6 +10,7 @@
>>   #include <linux/jiffies.h>
>>   #include <linux/writeback.h>
>>   #include <linux/workqueue.h>
>> +#include <linux/llist.h>
>>
>>   #include <cluster/masklog.h>
>>
>> @@ -679,6 +680,27 @@ static int ocfs2_calc_qdel_credits(struct super_block *sb, int type)
>>   	       OCFS2_INODE_UPDATE_CREDITS;
>>   }
>>
>> +void ocfs2_drop_dquot_refs(struct work_struct *work)
>> +{
>> +	struct ocfs2_super *osb = container_of(work, struct ocfs2_super,
>> +					       dquot_drop_work);
>> +	struct llist_node *list;
>> +	struct ocfs2_dquot *odquot, *next_odquot;
>> +
>> +	list = llist_del_all(&osb->dquot_drop_list);
>> +	llist_for_each_entry_safe(odquot, next_odquot, list, list) {
>> +		/* Drop the reference we acquired in ocfs2_dquot_release() */
>> +		dqput(&odquot->dq_dquot);
>> +	}
>> +}
>> +
>> +/*
>> + * Called when the last reference to dquot is dropped. If we are called from
>> + * downconvert thread, we cannot do all the handling here because grabbing
>> + * quota lock could deadlock (the node holding the quota lock could need some
>> + * other cluster lock to proceed but with blocked downconvert thread we cannot
>> + * release any lock).
>> + */
>>   static int ocfs2_release_dquot(struct dquot *dquot)
>>   {
>>   	handle_t *handle;
>> @@ -694,6 +716,19 @@ static int ocfs2_release_dquot(struct dquot *dquot)
>>   	/* Check whether we are not racing with some other dqget() */
>>   	if (atomic_read(&dquot->dq_count) > 1)
>>   		goto out;
>> +	/* Running from downconvert thread? Postpone quota processing to wq */
>> +	if (current == osb->dc_task) {
>> +		/*
>> +		 * Grab our own reference to dquot and queue it for delayed
>> +		 * dropping.  Quota code rechecks after calling
>> +		 * ->release_dquot() and won't free dquot structure.
>> +		 */
>> +		dqgrab(dquot);
>> +		/* First entry on list -> queue work */
>> +		if (llist_add(&OCFS2_DQUOT(dquot)->list, &osb->dquot_drop_list))
>> +			queue_work(ocfs2_wq, &osb->dquot_drop_work);
>> +		goto out;
>> +	}
>>   	status = ocfs2_lock_global_qf(oinfo, 1);
>>   	if (status < 0)
>>   		goto out;
>> diff --git a/fs/ocfs2/super.c b/fs/ocfs2/super.c
>> index c7f71360666f..0c5ea9454967 100644
>> --- a/fs/ocfs2/super.c
>> +++ b/fs/ocfs2/super.c
>> @@ -1920,6 +1920,11 @@ static void ocfs2_dismount_volume(struct super_block *sb, int mnt_err)
>>
>>   	ocfs2_disable_quotas(osb);
>>
>> +	/* All dquots should be freed by now */
>> +	WARN_ON(!llist_empty(&osb->dquot_drop_list));
>> +	/* Wait for worker to be done with the work structure in osb */
>> +	cancel_work_sync(&osb->dquot_drop_work);
>> +
>>   	ocfs2_shutdown_local_alloc(osb);
>>
>>   	ocfs2_truncate_log_shutdown(osb);
>> @@ -2247,6 +2252,9 @@ static int ocfs2_initialize_super(struct super_block *sb,
>>   	INIT_WORK(&journal->j_recovery_work, ocfs2_complete_recovery);
>>   	journal->j_state = OCFS2_JOURNAL_FREE;
>>
>> +	INIT_WORK(&osb->dquot_drop_work, ocfs2_drop_dquot_refs);
>> +	init_llist_head(&osb->dquot_drop_list);
>> +
>>   	/* get some pseudo constants for clustersize bits */
>>   	osb->s_clustersize_bits =
>>   		le32_to_cpu(di->id2.i_super.s_clustersize_bits);
>> --
>> 1.8.1.4
>>


-- 
Goldwyn
