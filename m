From: Tao Ma <tm@tao.ma>
Date: Mon, 30 Jan 2012 10:21:27 +0800
Subject: [Ocfs2-devel] [PATCH 1/1] ocfs2: use spinlock irqsave
 for	downconvert lock.patch
In-Reply-To: <4F25D9D8.3070803@oracle.com>
References: <1327803237-21777-1-git-send-email-srinivas.eeda@oracle.com>
	<4F24AF9F.7050801@tao.ma> <4F25D9D8.3070803@oracle.com>
Message-ID: <4F25FEA7.10600@tao.ma>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On 01/30/2012 07:44 AM, srinivas eeda wrote:
> Hi Tao,
> thanks for reviewing.
> 
>>> When ocfs2dc thread holds dc_task_lock spinlock and receives soft IRQ
>>> for
>>> I/O completion it deadlock itself trying to get same spinlock in
>>> ocfs2_wake_downconvert_thread
>> could you please describe it in more detail?
> When ocfs2dc thread is running on a cpu and acquired dc_task_lock spin
> lock, an interrupt came in for i/o completion. Interrupt handler then
> tries to acquire same spinlock and ends up in deadlock. Below is the
> stack that gives more details.
> 
> [<ffffffff814fd509>] default_do_nmi+0x39/0x200
> [<ffffffff814fd750>] do_nmi+0x80/0xa0
> [<ffffffff814fced0>] nmi+0x20/0x30
> [<ffffffff8103ee83>] ? __ticket_spin_lock+0x13/0x20
> <<EOE>> <IRQ>  [<ffffffff814fc41e>] _raw_spin_lock+0xe/0x20
> [<ffffffffa04e32e8>] ocfs2_wake_downconvert_thread+0x28/0x60 [ocfs2]
> [<ffffffffa04eb388>] ocfs2_rw_unlock+0xe8/0x1a0 [ocfs2]
> [<ffffffff8110c635>] ? mempool_free+0x95/0xa0
> [<ffffffffa04d18c1>] ocfs2_dio_end_io+0x61/0xb0 [ocfs2]
> [<ffffffff8119ebdb>] dio_complete+0xbb/0xe0
> [<ffffffff8119ec6d>] dio_bio_end_aio+0x6d/0xc0
> [<ffffffff8119a1bd>] bio_endio+0x1d/0x40
> [<ffffffff81234643>] req_bio_endio+0xa3/0xe0
> [<ffffffff8123589f>] blk_update_request+0xff/0x490
> [<ffffffff8119bec4>] ? bio_free+0x64/0x70
> [<ffffffffa000193a>] end_clone_bio+0x5a/0x90 [dm_mod]
> [<ffffffff8119a1bd>] bio_endio+0x1d/0x40
> [<ffffffff81234643>] req_bio_endio+0xa3/0xe0
> [<ffffffff813558a6>] ? scsi_done+0x26/0x60
> [<ffffffff8123589f>] blk_update_request+0xff/0x490
> [<ffffffffa01ee77a>] ? qla2x00_process_completed_request+0x5a/0xe0
> [qla2xxx]
> [<ffffffff81235c57>] blk_update_bidi_request+0x27/0xb0
> [<ffffffff81236d8f>] blk_end_bidi_request+0x2f/0x80
> [<ffffffff81236e30>] blk_end_request+0x10/0x20
> [<ffffffff8135d600>] scsi_end_request+0x40/0xb0
> [<ffffffff8135d96f>] scsi_io_completion+0x9f/0x5c0
> [<ffffffff8103ef19>] ? default_spin_lock_flags+0x9/0x10
> [<ffffffff81354a59>] scsi_finish_command+0xc9/0x130
> [<ffffffff8135dff7>] scsi_softirq_done+0x147/0x170
> [<ffffffff8123ca32>] blk_done_softirq+0x82/0xa0
> [<ffffffff8106f987>] __do_softirq+0xb7/0x210
> [<ffffffff814fc41e>] ? _raw_spin_lock+0xe/0x20
> [<ffffffff8150599c>] call_softirq+0x1c/0x30
> [<ffffffff81016365>] do_softirq+0x65/0xa0
> [<ffffffff8106f78d>] irq_exit+0xbd/0xe0
> [<ffffffff815061f6>] do_IRQ+0x66/0xe0
> @ [<ffffffff814fc953>] common_interrupt+0x13/0x13
> <EOI>  [<ffffffff81261625>] ? __list_del_entry+0x35/0xd0
> [<ffffffffa04e9d53>] ocfs2_downconvert_thread+0x133/0x2a0 [ocfs2]
> [<ffffffff814f9d10>] ? __schedule+0x3f0/0x800
> [<ffffffff8108b930>] ? wake_up_bit+0x40/0x40
> [<ffffffffa04e9c20>] ? ocfs2_process_blocked_lock+0x270/0x270 [ocfs2]
> [<ffffffff8108b346>] kthread+0x96/0xa0
> [<ffffffff815058a4>] kernel_thread_helper+0x4/0x10
> [<ffffffff8108b2b0>] ? kthread_worker_fn+0x1a0/0x1a0
> [<ffffffff815058a0>] ? gs_change+0x13/0x13
> @ ---[ end trace 628bf423ee0bc8a8 ]---
Thanks for the perfect stack. :)
>> btw, if you are afraid of deadlocking in soft IRQ, I guess we should use
>> spin_lock_bh not spin_lock_irqsave?
> Yes, looks like we could, but I am not 100% sure if it will be safe?
oh, I just went through the whole path and it sees that we also call
spin_lock_irqsave in __ocfs2_cluster_unlock, but can we ever use
lock->l_lock in a hard irq context?
Mark and Joel,
	do you ever know whey we need this irqsave lock?

anyway, in a softirq context, it should be safe to use a
spin_lock_irqsave, so the code itself should be fine.

Thanks
Tao
>> Thanks
>> Tao
>>> The patch disables interrupts when acquiring dc_task_lock spinlock
>>>
>>> Signed-off-by: Srinivas Eeda<srinivas.eeda@oracle.com>
>>> ---
>>>   fs/ocfs2/dlmglue.c |   30 ++++++++++++++++++------------
>>>   1 files changed, 18 insertions(+), 12 deletions(-)
>>>
>>> diff --git a/fs/ocfs2/dlmglue.c b/fs/ocfs2/dlmglue.c
>>> index 81a4cd2..d8552a5 100644
>>> --- a/fs/ocfs2/dlmglue.c
>>> +++ b/fs/ocfs2/dlmglue.c
>>> @@ -3932,6 +3932,8 @@ unqueue:
>>>   static void ocfs2_schedule_blocked_lock(struct ocfs2_super *osb,
>>>                       struct ocfs2_lock_res *lockres)
>>>   {
>>> +    unsigned long flags;
>>> +
>>>       assert_spin_locked(&lockres->l_lock);
>>>
>>>       if (lockres->l_flags&  OCFS2_LOCK_FREEING) {
>>> @@ -3945,21 +3947,22 @@ static void
>>> ocfs2_schedule_blocked_lock(struct ocfs2_super *osb,
>>>
>>>       lockres_or_flags(lockres, OCFS2_LOCK_QUEUED);
>>>
>>> -    spin_lock(&osb->dc_task_lock);
>>> +    spin_lock_irqsave(&osb->dc_task_lock, flags);
>>>       if (list_empty(&lockres->l_blocked_list)) {
>>>           list_add_tail(&lockres->l_blocked_list,
>>>               &osb->blocked_lock_list);
>>>           osb->blocked_lock_count++;
>>>       }
>>> -    spin_unlock(&osb->dc_task_lock);
>>> +    spin_unlock_irqrestore(&osb->dc_task_lock, flags);
>>>   }
>>>
>>>   static void ocfs2_downconvert_thread_do_work(struct ocfs2_super *osb)
>>>   {
>>>       unsigned long processed;
>>> +    unsigned long flags;
>>>       struct ocfs2_lock_res *lockres;
>>>
>>> -    spin_lock(&osb->dc_task_lock);
>>> +    spin_lock_irqsave(&osb->dc_task_lock, flags);
>>>       /* grab this early so we know to try again if a state change and
>>>        * wake happens part-way through our work  */
>>>       osb->dc_work_sequence = osb->dc_wake_sequence;
>>> @@ -3972,38 +3975,40 @@ static void
>>> ocfs2_downconvert_thread_do_work(struct ocfs2_super *osb)
>>>                        struct ocfs2_lock_res, l_blocked_list);
>>>           list_del_init(&lockres->l_blocked_list);
>>>           osb->blocked_lock_count--;
>>> -        spin_unlock(&osb->dc_task_lock);
>>> +        spin_unlock_irqrestore(&osb->dc_task_lock, flags);
>>>
>>>           BUG_ON(!processed);
>>>           processed--;
>>>
>>>           ocfs2_process_blocked_lock(osb, lockres);
>>>
>>> -        spin_lock(&osb->dc_task_lock);
>>> +        spin_lock_irqsave(&osb->dc_task_lock, flags);
>>>       }
>>> -    spin_unlock(&osb->dc_task_lock);
>>> +    spin_unlock_irqrestore(&osb->dc_task_lock, flags);
>>>   }
>>>
>>>   static int ocfs2_downconvert_thread_lists_empty(struct ocfs2_super
>>> *osb)
>>>   {
>>>       int empty = 0;
>>> +    unsigned long flags;
>>>
>>> -    spin_lock(&osb->dc_task_lock);
>>> +    spin_lock_irqsave(&osb->dc_task_lock, flags);
>>>       if (list_empty(&osb->blocked_lock_list))
>>>           empty = 1;
>>>
>>> -    spin_unlock(&osb->dc_task_lock);
>>> +    spin_unlock_irqrestore(&osb->dc_task_lock, flags);
>>>       return empty;
>>>   }
>>>
>>>   static int ocfs2_downconvert_thread_should_wake(struct ocfs2_super
>>> *osb)
>>>   {
>>>       int should_wake = 0;
>>> +    unsigned long flags;
>>>
>>> -    spin_lock(&osb->dc_task_lock);
>>> +    spin_lock_irqsave(&osb->dc_task_lock, flags);
>>>       if (osb->dc_work_sequence != osb->dc_wake_sequence)
>>>           should_wake = 1;
>>> -    spin_unlock(&osb->dc_task_lock);
>>> +    spin_unlock_irqrestore(&osb->dc_task_lock, flags);
>>>
>>>       return should_wake;
>>>   }
>>> @@ -4033,10 +4038,11 @@ static int ocfs2_downconvert_thread(void *arg)
>>>
>>>   void ocfs2_wake_downconvert_thread(struct ocfs2_super *osb)
>>>   {
>>> -    spin_lock(&osb->dc_task_lock);
>>> +    unsigned long flags;
>>> +    spin_lock_irqsave(&osb->dc_task_lock, flags);
>>>       /* make sure the voting thread gets a swipe at whatever changes
>>>        * the caller may have made to the voting state */
>>>       osb->dc_wake_sequence++;
>>> -    spin_unlock(&osb->dc_task_lock);
>>> +    spin_unlock_irqrestore(&osb->dc_task_lock, flags);
>>>       wake_up(&osb->dc_event);
>>>   }
