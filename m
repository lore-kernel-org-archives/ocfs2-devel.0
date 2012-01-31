From: srinivas eeda <srinivas.eeda@oracle.com>
Date: Mon, 30 Jan 2012 21:52:13 -0800
Subject: [Ocfs2-devel] [PATCH 1/1] ocfs2: use spinlock irqsave for
 downconvert lock.patch
In-Reply-To: <1327988845-31676-1-git-send-email-srinivas.eeda@oracle.com>
References: <1327988845-31676-1-git-send-email-srinivas.eeda@oracle.com>
Message-ID: <4F27818D.2000309@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

sorry ignore this patch, resent another one after adding the new line.

On 1/30/2012 9:47 PM, Srinivas Eeda wrote:
> When ocfs2dc thread holds dc_task_lock spinlock and receives soft IRQ it
> deadlock itself trying to get same spinlock in ocfs2_wake_downconvert_thread.
> Below is the stack snippet.
>
> The patch disables interrupts when acquiring dc_task_lock spinlock.
>
> 	ocfs2_wake_downconvert_thread
> 	ocfs2_rw_unlock
> 	ocfs2_dio_end_io
> 	dio_complete
> 	.....
> 	bio_endio
> 	req_bio_endio
> 	....
> 	scsi_io_completion
> 	blk_done_softirq
> 	__do_softirq
> 	do_softirq
> 	irq_exit
> 	do_IRQ
> 	ocfs2_downconvert_thread
> 	[kthread]
>
> Signed-off-by: Srinivas Eeda<srinivas.eeda@oracle.com>
> ---
>   fs/ocfs2/dlmglue.c |   30 ++++++++++++++++++------------
>   1 files changed, 18 insertions(+), 12 deletions(-)
>
> diff --git a/fs/ocfs2/dlmglue.c b/fs/ocfs2/dlmglue.c
> index 81a4cd2..d8552a5 100644
> --- a/fs/ocfs2/dlmglue.c
> +++ b/fs/ocfs2/dlmglue.c
> @@ -3932,6 +3932,8 @@ unqueue:
>   static void ocfs2_schedule_blocked_lock(struct ocfs2_super *osb,
>   					struct ocfs2_lock_res *lockres)
>   {
> +	unsigned long flags;
> +
>   	assert_spin_locked(&lockres->l_lock);
>
>   	if (lockres->l_flags&  OCFS2_LOCK_FREEING) {
> @@ -3945,21 +3947,22 @@ static void ocfs2_schedule_blocked_lock(struct ocfs2_super *osb,
>
>   	lockres_or_flags(lockres, OCFS2_LOCK_QUEUED);
>
> -	spin_lock(&osb->dc_task_lock);
> +	spin_lock_irqsave(&osb->dc_task_lock, flags);
>   	if (list_empty(&lockres->l_blocked_list)) {
>   		list_add_tail(&lockres->l_blocked_list,
>   			&osb->blocked_lock_list);
>   		osb->blocked_lock_count++;
>   	}
> -	spin_unlock(&osb->dc_task_lock);
> +	spin_unlock_irqrestore(&osb->dc_task_lock, flags);
>   }
>
>   static void ocfs2_downconvert_thread_do_work(struct ocfs2_super *osb)
>   {
>   	unsigned long processed;
> +	unsigned long flags;
>   	struct ocfs2_lock_res *lockres;
>
> -	spin_lock(&osb->dc_task_lock);
> +	spin_lock_irqsave(&osb->dc_task_lock, flags);
>   	/* grab this early so we know to try again if a state change and
>   	 * wake happens part-way through our work  */
>   	osb->dc_work_sequence = osb->dc_wake_sequence;
> @@ -3972,38 +3975,40 @@ static void ocfs2_downconvert_thread_do_work(struct ocfs2_super *osb)
>   				     struct ocfs2_lock_res, l_blocked_list);
>   		list_del_init(&lockres->l_blocked_list);
>   		osb->blocked_lock_count--;
> -		spin_unlock(&osb->dc_task_lock);
> +		spin_unlock_irqrestore(&osb->dc_task_lock, flags);
>
>   		BUG_ON(!processed);
>   		processed--;
>
>   		ocfs2_process_blocked_lock(osb, lockres);
>
> -		spin_lock(&osb->dc_task_lock);
> +		spin_lock_irqsave(&osb->dc_task_lock, flags);
>   	}
> -	spin_unlock(&osb->dc_task_lock);
> +	spin_unlock_irqrestore(&osb->dc_task_lock, flags);
>   }
>
>   static int ocfs2_downconvert_thread_lists_empty(struct ocfs2_super *osb)
>   {
>   	int empty = 0;
> +	unsigned long flags;
>
> -	spin_lock(&osb->dc_task_lock);
> +	spin_lock_irqsave(&osb->dc_task_lock, flags);
>   	if (list_empty(&osb->blocked_lock_list))
>   		empty = 1;
>
> -	spin_unlock(&osb->dc_task_lock);
> +	spin_unlock_irqrestore(&osb->dc_task_lock, flags);
>   	return empty;
>   }
>
>   static int ocfs2_downconvert_thread_should_wake(struct ocfs2_super *osb)
>   {
>   	int should_wake = 0;
> +	unsigned long flags;
>
> -	spin_lock(&osb->dc_task_lock);
> +	spin_lock_irqsave(&osb->dc_task_lock, flags);
>   	if (osb->dc_work_sequence != osb->dc_wake_sequence)
>   		should_wake = 1;
> -	spin_unlock(&osb->dc_task_lock);
> +	spin_unlock_irqrestore(&osb->dc_task_lock, flags);
>
>   	return should_wake;
>   }
> @@ -4033,10 +4038,11 @@ static int ocfs2_downconvert_thread(void *arg)
>
>   void ocfs2_wake_downconvert_thread(struct ocfs2_super *osb)
>   {
> -	spin_lock(&osb->dc_task_lock);
> +	unsigned long flags;
> +	spin_lock_irqsave(&osb->dc_task_lock, flags);
>   	/* make sure the voting thread gets a swipe at whatever changes
>   	 * the caller may have made to the voting state */
>   	osb->dc_wake_sequence++;
> -	spin_unlock(&osb->dc_task_lock);
> +	spin_unlock_irqrestore(&osb->dc_task_lock, flags);
>   	wake_up(&osb->dc_event);
>   }
