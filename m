From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Fri, 14 May 2010 11:30:31 -0700
Subject: [Ocfs2-devel] Deadlock in DLM code still there
In-Reply-To: <20100514145054.GA3431@laptop.oracle.com>
References: <20100513194320.GA28367@quack.suse.cz>
	<20100514145054.GA3431@laptop.oracle.com>
Message-ID: <4BED96C7.2090302@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Excellent patch Wengang. I think that should take care of the problem.
Please can you send a formal patch to the list. I'll include it in our test
queue.

Thanks
Sunil

On 05/14/2010 07:50 AM, Wengang Wang wrote:
> Hi,
>
> On 10-05-13 21:43, Jan Kara wrote:
>    
>>    Hi,
>>
>>    in http://www.mail-archive.com/ocfs2-devel at oss.oracle.com/msg03188.html
>> (more than an year ago) I've reported a lock inversion between dlm->ast_lock
>> and res->spinlock. The deadlock seems to be still there in 2.6.34-rc7:
>>
>> =======================================================
>> [ INFO: possible circular locking dependency detected ]
>> 2.6.34-rc7-xen #4
>> -------------------------------------------------------
>> dlm_thread/2001 is trying to acquire lock:
>>   (&(&dlm->ast_lock)->rlock){+.+...}, at: [<ffffffffa0119785>] dlm_queue_bast+0x55/0x1e0 [ocfs2_dlm]
>>
>> but task is already holding lock:
>>   (&(&res->spinlock)->rlock){+.+...}, at: [<ffffffffa010452d>] dlm_thread+0x7cd/0x17f0 [ocfs2_dlm]
>>
>> which lock already depends on the new lock.
>>
>>
>> the existing dependency chain (in reverse order) is:
>>
>> ->  #1 (&(&res->spinlock)->rlock){+.+...}:
>>         [<ffffffff810746bf>] __lock_acquire+0x109f/0x1720
>>         [<ffffffff81074da9>] lock_acquire+0x69/0x90
>>         [<ffffffff81328c6c>] _raw_spin_lock+0x2c/0x40
>>         [<ffffffff8117e158>] _atomic_dec_and_lock+0x78/0xa0
>>         [<ffffffffa010ebb9>] dlm_lockres_release_ast+0x29/0xb0 [ocfs2_dlm]
>>         [<ffffffffa0104e41>] dlm_thread+0x10e1/0x17f0 [ocfs2_dlm]
>>         [<ffffffff81060e1e>] kthread+0x8e/0xa0
>>         [<ffffffff8100bda4>] kernel_thread_helper+0x4/0x10
>>
>> ->  #0 (&(&dlm->ast_lock)->rlock){+.+...}:
>>         [<ffffffff81074b18>] __lock_acquire+0x14f8/0x1720
>>         [<ffffffff81074da9>] lock_acquire+0x69/0x90
>>         [<ffffffff81328c6c>] _raw_spin_lock+0x2c/0x40
>>         [<ffffffffa0119785>] dlm_queue_bast+0x55/0x1e0 [ocfs2_dlm]
>>         [<ffffffffa010494f>] dlm_thread+0xbef/0x17f0 [ocfs2_dlm]
>>         [<ffffffff81060e1e>] kthread+0x8e/0xa0
>>         [<ffffffff8100bda4>] kernel_thread_helper+0x4/0x10
>>      
> The code path is simple:
> in dlm_thread()
> 677                         spin_lock(&res->spinlock);
> 			    .......
> 714                         /* called while holding lockres lock */
> 715                         dlm_shuffle_lists(dlm, res);	
> 716                         res->state&= ~DLM_LOCK_RES_DIRTY;
> 717                         spin_unlock(&res->spinlock);
>
> In dlm_shuffle_lists(), dlm_queue_bast()/dlm_queue_ast() are called.
> In the later two functions, dlm->ast_lock is required.
> Since we can't release res->spinlock, we have to take dlm->ast_lock
> just before taking the res->spinlock(line 677) and release it after
> res->spinlock is released. And use __dlm_queue_bast()/__dlm_queue_ast(),
> the nolock version, in dlm_shuffle_lists().
> There are no too many locks on a lockres, I think there is no performance
> harm.
> Comments?
>
> Attached the patch(not well tested yet, will be tested if this approach is good).
> At least with this patch Jan can continue with his test :P
>
> Regards,
> wengang.
>    
