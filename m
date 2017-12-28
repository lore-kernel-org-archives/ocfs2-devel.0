From: Gang He <ghe@suse.com>
Date: Wed, 27 Dec 2017 19:58:13 -0700
Subject: [Ocfs2-devel] [PATCH] ocfs2: try a blocking lock before return
 AOP_TRUNCATED_PAGE
In-Reply-To: <5A445AAD.6090406@huawei.com>
References: <1514366960-10588-1-git-send-email-ghe@suse.com>
	<5A4372AA.1080007@huawei.com>
	<5A43E86D020000F9000A0683@prv-mh.provo.novell.com>
	<5A444942.7040901@huawei.com>
	<5A44C34A020000F9000A0736@prv-mh.provo.novell.com>
	<5A445AAD.6090406@huawei.com>
Message-ID: <5A44CE45020000F9000A076E@prv-mh.provo.novell.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: jlbec@evilplan.org, piaojun@huawei.com, mfasheh@versity.com
Cc: ocfs2-devel@oss.oracle.com, linux-kernel@vger.kernel.org




>>> 
> Hi Gang,
> 
> You cleared my doubt. Should we handle the errno of ocfs2_inode_lock()
> or just use mlog_errno()?
Hi Jun, I think it is not necessary, since we just want to hold a while before get the DLM lock,
we do not care about the result, since we will unlock immediately here.
In fact, this patch does NOT add new code, just revert the old patch 1cce4df04f37, and add 
more clear comments in the front of these two lines code.

Thanks
Gang

> 
> thanks,
> Jun
> 
> On 2017/12/28 10:11, Gang He wrote:
>> Hi Jun,
>> 
>> 
>>>>>
>>> Hi Gang,
>>>
>>> Thanks for your explaination, and I just have one more question. Could
>>> we use 'ocfs2_inode_lock' instead of 'ocfs2_inode_lock_full' to avoid
>>> -EAGAIN circularly?
>> No, please see the comments above the function  
> ocfs2_inode_lock_with_page(),
>> there will be probably a deadlock between tasks acquiring DLM
>> locks while holding a page lock and the downconvert thread which
>> blocks dlm lock acquiry while acquiring page locks.
>> Then, the OCFS2_LOCK_NONBLOCK flag was introduced as a workaround to
>> avoid this case.
>> 
>> Thanks
>> Gang
>> 
>>>
>>> thanks,
>>> Jun
>>>
>>> On 2017/12/27 18:37, Gang He wrote:
>>>> Hi Jun,
>>>>
>>>>
>>>>>>>
>>>>> Hi Gang,
>>>>>
>>>>> Do you mean that too many retrys in loop cast losts of CPU-time and
>>>>> block page-fault interrupt? We should not add any delay in
>>>>> ocfs2_fault(), right? And I still feel a little confused why your
>>>>> method can solve this problem.
>>>> You can see the related code in function filemap_fault(), if ocfs2 fails to 
>>> read a page since 
>>>> it can not get a inode lock with non-block mode, the VFS layer code will 
>>> invoke ocfs2
>>>> read page call back function circularly, this will lead to a softlockup 
>>> problem (like the below back trace).
>>>> So, we should get a blocking lock to let the dlm lock to this node and also 
>>> can avoid CPU loop,
>>>> second, base on my testing, the patch also can improve the efficiency in 
>>> case modifying the same
>>>> file frequently from multiple nodes, since the lock acquisition chance is 
>>> more fair.
>>>> In fact, the code was modified by a patch 1cce4df04f37 ("ocfs2: do not 
>>> lock/unlock() inode DLM lock"),
>>>> before that patch, the code is the same, this patch can be considered to 
>>> revert that patch, except adding more
>>>> clear comments.
>>>>  
>>>> Thanks
>>>> Gang
>>>>
>>>>
>>>>>
>>>>> thanks,
>>>>> Jun
>>>>>
>>>>> On 2017/12/27 17:29, Gang He wrote:
>>>>>> If we can't get inode lock immediately in the function
>>>>>> ocfs2_inode_lock_with_page() when reading a page, we should not
>>>>>> return directly here, since this will lead to a softlockup problem.
>>>>>> The method is to get a blocking lock and immediately unlock before
>>>>>> returning, this can avoid CPU resource waste due to lots of retries,
>>>>>> and benefits fairness in getting lock among multiple nodes, increase
>>>>>> efficiency in case modifying the same file frequently from multiple
>>>>>> nodes.
>>>>>> The softlockup problem looks like,
>>>>>> Kernel panic - not syncing: softlockup: hung tasks
>>>>>> CPU: 0 PID: 885 Comm: multi_mmap Tainted: G L 4.12.14-6.1-default #1
>>>>>> Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
>>>>>> Call Trace:
>>>>>>   <IRQ>
>>>>>>   dump_stack+0x5c/0x82
>>>>>>   panic+0xd5/0x21e
>>>>>>   watchdog_timer_fn+0x208/0x210
>>>>>>   ? watchdog_park_threads+0x70/0x70
>>>>>>   __hrtimer_run_queues+0xcc/0x200
>>>>>>   hrtimer_interrupt+0xa6/0x1f0
>>>>>>   smp_apic_timer_interrupt+0x34/0x50
>>>>>>   apic_timer_interrupt+0x96/0xa0
>>>>>>   </IRQ>
>>>>>>  RIP: 0010:unlock_page+0x17/0x30
>>>>>>  RSP: 0000:ffffaf154080bc88 EFLAGS: 00000246 ORIG_RAX: ffffffffffffff10
>>>>>>  RAX: dead000000000100 RBX: fffff21e009f5300 RCX: 0000000000000004
>>>>>>  RDX: dead0000000000ff RSI: 0000000000000202 RDI: fffff21e009f5300
>>>>>>  RBP: 0000000000000000 R08: 0000000000000000 R09: ffffaf154080bb00
>>>>>>  R10: ffffaf154080bc30 R11: 0000000000000040 R12: ffff993749a39518
>>>>>>  R13: 0000000000000000 R14: fffff21e009f5300 R15: fffff21e009f5300
>>>>>>   ocfs2_inode_lock_with_page+0x25/0x30 [ocfs2]
>>>>>>   ocfs2_readpage+0x41/0x2d0 [ocfs2]
>>>>>>   ? pagecache_get_page+0x30/0x200
>>>>>>   filemap_fault+0x12b/0x5c0
>>>>>>   ? recalc_sigpending+0x17/0x50
>>>>>>   ? __set_task_blocked+0x28/0x70
>>>>>>   ? __set_current_blocked+0x3d/0x60
>>>>>>   ocfs2_fault+0x29/0xb0 [ocfs2]
>>>>>>   __do_fault+0x1a/0xa0
>>>>>>   __handle_mm_fault+0xbe8/0x1090
>>>>>>   handle_mm_fault+0xaa/0x1f0
>>>>>>   __do_page_fault+0x235/0x4b0
>>>>>>   trace_do_page_fault+0x3c/0x110
>>>>>>   async_page_fault+0x28/0x30
>>>>>>  RIP: 0033:0x7fa75ded638e
>>>>>>  RSP: 002b:00007ffd6657db18 EFLAGS: 00010287
>>>>>>  RAX: 000055c7662fb700 RBX: 0000000000000001 RCX: 000055c7662fb700
>>>>>>  RDX: 0000000000001770 RSI: 00007fa75e909000 RDI: 000055c7662fb700
>>>>>>  RBP: 0000000000000003 R08: 000000000000000e R09: 0000000000000000
>>>>>>  R10: 0000000000000483 R11: 00007fa75ded61b0 R12: 00007fa75e90a770
>>>>>>  R13: 000000000000000e R14: 0000000000001770 R15: 0000000000000000
>>>>>>
>>>>>> Fixes: 1cce4df04f37 ("ocfs2: do not lock/unlock() inode DLM lock")
>>>>>> Signed-off-by: Gang He <ghe@suse.com>
>>>>>> ---
>>>>>>  fs/ocfs2/dlmglue.c | 9 +++++++++
>>>>>>  1 file changed, 9 insertions(+)
>>>>>>
>>>>>> diff --git a/fs/ocfs2/dlmglue.c b/fs/ocfs2/dlmglue.c
>>>>>> index 4689940..5193218 100644
>>>>>> --- a/fs/ocfs2/dlmglue.c
>>>>>> +++ b/fs/ocfs2/dlmglue.c
>>>>>> @@ -2486,6 +2486,15 @@ int ocfs2_inode_lock_with_page(struct inode *inode,
>>>>>>  	ret = ocfs2_inode_lock_full(inode, ret_bh, ex, OCFS2_LOCK_NONBLOCK);
>>>>>>  	if (ret == -EAGAIN) {
>>>>>>  		unlock_page(page);
>>>>>> +		/*
>>>>>> +		 * If we can't get inode lock immediately, we should not return
>>>>>> +		 * directly here, since this will lead to a softlockup problem.
>>>>>> +		 * The method is to get a blocking lock and immediately unlock
>>>>>> +		 * before returning, this can avoid CPU resource waste due to
>>>>>> +		 * lots of retries, and benefits fairness in getting lock.
>>>>>> +		 */
>>>>>> +		if (ocfs2_inode_lock(inode, ret_bh, ex) == 0)
>>>>>> +			ocfs2_inode_unlock(inode, ex);
>>>>>>  		ret = AOP_TRUNCATED_PAGE;
>>>>>>  	}
>>>>>>  
>>>>>>
>>>> .
>>>>
>> .
>> 
