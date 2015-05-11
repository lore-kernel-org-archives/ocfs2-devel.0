From: Joseph Qi <joseph.qi@huawei.com>
Date: Mon, 11 May 2015 09:29:56 +0800
Subject: [Ocfs2-devel] [PATCH] ocfs2: fix BUG in
	ocfs2_downconvert_thread_do_work
In-Reply-To: <20150508223713.GA25729@wotan.suse.de>
References: <5549F736.7000405@huawei.com>
	<20150508223713.GA25729@wotan.suse.de>
Message-ID: <55500614.2080206@huawei.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi Mark,

On 2015/5/9 6:37, Mark Fasheh wrote:
> Thanks Joseph,
> 
> This seems like a convoluted way of fixing the problem. The reason
> downconvert_thread_do_work is saving the # of blocked locks is so it doesn't
> spin forever while another process continually adds them - basically we want
> to do a certain amount of work and then move on. Instead why not just change
> the while loop condition (and add a nice comment explaining it):
> 
> 	/*
> 	 * blocked lock processing in this loop might call iput which can
> 	 * remove items off osb->blocked_lock_list. Downconvert up to
> 	 * 'processed' number of locks, but stop short if we had some
> 	 * removed by another thread.
> 	 */
> 	while (processed && !list_empty(&osb->blocked_lock_list)) {
> 		...
> 	}
> 
> As a bonus, we can remove the now-useless BUG_ON().
> 	--Mark
> 
Thanks for your advice.
Introducing the blocked_lock_processed is trying to retain the batch
processing logic. And I only synchronize it on decreasing, but not adding.
If we use !list_empty(&osb->blocked_lock_list) as the loop condition, once
the list is corrupted, we may also treat it as normal.
BTW, in the case described, the lockres is removed from the blocked list
by the same downconvert thread.

> On Wed, May 06, 2015 at 07:12:54PM +0800, Joseph Qi wrote:
>> BUG_ON(list_empty(&osb->blocked_lock_list)) in
>> ocfs2_downconvert_thread_do_work can be triggered in the following case:
>> ocfs2dc has firstly saved osb->blocked_lock_count to local varibale
>> processed, and then processes the dentry lockres.
>> During the dentry put, it calls iput and then deletes rw, inode and
>> open lockres from blocked list in ocfs2_mark_lockres_freeing.
>> And this casues the variable processed is not the number of blocked
>> lockres to be processed and then triggers the BUG.
>>
>> Signed-off-by: Joseph Qi <joseph.qi@huawei.com>
>> Cc: <stable@vger.kernel.org>
>> ---
>>  fs/ocfs2/dlmglue.c | 10 ++++------
>>  fs/ocfs2/ocfs2.h   |  1 +
>>  fs/ocfs2/super.c   |  1 +
>>  3 files changed, 6 insertions(+), 6 deletions(-)
>>
>> diff --git a/fs/ocfs2/dlmglue.c b/fs/ocfs2/dlmglue.c
>> index 8b23aa2..846547c 100644
>> --- a/fs/ocfs2/dlmglue.c
>> +++ b/fs/ocfs2/dlmglue.c
>> @@ -3198,6 +3198,7 @@ void ocfs2_mark_lockres_freeing(struct ocfs2_super *osb,
>>  		spin_lock_irqsave(&osb->dc_task_lock, flags2);
>>  		list_del_init(&lockres->l_blocked_list);
>>  		osb->blocked_lock_count--;
>> +		osb->blocked_lock_processed--;
>>  		spin_unlock_irqrestore(&osb->dc_task_lock, flags2);
>>  		/*
>>  		 * Warn if we recurse into another post_unlock call.  Strictly
>> @@ -4015,7 +4016,6 @@ static void ocfs2_schedule_blocked_lock(struct ocfs2_super *osb,
>>
>>  static void ocfs2_downconvert_thread_do_work(struct ocfs2_super *osb)
>>  {
>> -	unsigned long processed;
>>  	unsigned long flags;
>>  	struct ocfs2_lock_res *lockres;
>>
>> @@ -4024,19 +4024,17 @@ static void ocfs2_downconvert_thread_do_work(struct ocfs2_super *osb)
>>  	 * wake happens part-way through our work  */
>>  	osb->dc_work_sequence = osb->dc_wake_sequence;
>>
>> -	processed = osb->blocked_lock_count;
>> -	while (processed) {
>> +	osb->blocked_lock_processed = osb->blocked_lock_count;
>> +	while (osb->blocked_lock_processed) {
>>  		BUG_ON(list_empty(&osb->blocked_lock_list));
>>
>>  		lockres = list_entry(osb->blocked_lock_list.next,
>>  				     struct ocfs2_lock_res, l_blocked_list);
>>  		list_del_init(&lockres->l_blocked_list);
>>  		osb->blocked_lock_count--;
>> +		osb->blocked_lock_processed--;
>>  		spin_unlock_irqrestore(&osb->dc_task_lock, flags);
>>
>> -		BUG_ON(!processed);
>> -		processed--;
>> -
>>  		ocfs2_process_blocked_lock(osb, lockres);
>>
>>  		spin_lock_irqsave(&osb->dc_task_lock, flags);
>> diff --git a/fs/ocfs2/ocfs2.h b/fs/ocfs2/ocfs2.h
>> index 460c6c3..2aebe94 100644
>> --- a/fs/ocfs2/ocfs2.h
>> +++ b/fs/ocfs2/ocfs2.h
>> @@ -424,6 +424,7 @@ struct ocfs2_super
>>  	 */
>>  	struct list_head blocked_lock_list;
>>  	unsigned long blocked_lock_count;
>> +	unsigned long blocked_lock_processed;
>>
>>  	/* List of dquot structures to drop last reference to */
>>  	struct llist_head dquot_drop_list;
>> diff --git a/fs/ocfs2/super.c b/fs/ocfs2/super.c
>> index 403c566..914ce8b 100644
>> --- a/fs/ocfs2/super.c
>> +++ b/fs/ocfs2/super.c
>> @@ -2089,6 +2089,7 @@ static int ocfs2_initialize_super(struct super_block *sb,
>>  	osb->dc_wake_sequence = 0;
>>  	INIT_LIST_HEAD(&osb->blocked_lock_list);
>>  	osb->blocked_lock_count = 0;
>> +	osb->blocked_lock_processed = 0;
>>  	spin_lock_init(&osb->osb_lock);
>>  	spin_lock_init(&osb->osb_xattr_lock);
>>  	ocfs2_init_steal_slots(osb);
>> -- 
>> 1.8.4.3
>>
> --
> Mark Fasheh
> 
> .
> 
