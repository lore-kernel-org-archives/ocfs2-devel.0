From: Xiaowei <xiaowei.hu@oracle.com>
Date: Tue, 24 Jul 2012 13:27:49 +0800
Subject: [Ocfs2-devel] Race condition between OCFS2 downconvert thread
 and ocfs2 cluster lock.
In-Reply-To: <4F44476D.5010609@oracle.com>
References: <xiaowei.hu@oracle.com>
	<1329804728-6146-1-git-send-email-xiaowei.hu@oracle.com>
	<4F43D90B.8040802@oracle.com> <4F44387E.7040502@oracle.com>
	<4F443AC6.1070909@oracle.com> <4F443DB2.5060207@oracle.com>
	<4F44476D.5010609@oracle.com>
Message-ID: <500E3255.2010609@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi,

Could you please review this patch again? If this could be accepted? 
 From CT's testing , this indeed could avoid their crash.
Or should this problem be fixed in other way?

Thanks,
Xiaowei


On 02/22/2012 09:39 AM, Sunil Mushran wrote:
> New lockres.... requested at PR. It has not received the AST.
> But still has blocking set?
>
> This is pretty whacked. What patches are on this tree?
>
> Srini, Have you verified the patches?
>
> Sunil
>
> On 02/21/2012 04:58 PM, Xiaowei.hu wrote:
>> here is the whole lockres and backtrace:
>>
>> KERNEL: vmlinux
>> DUMPFILE: vmcore1
>> CPUS: 16
>> DATE: Tue Jan 17 20:48:22 2012
>> UPTIME: 100 days, 21:11:24
>> LOAD AVERAGE: 7.11, 7.46, 7.85
>> TASKS: 1210
>> NODENAME: sgi-not-efped05
>> RELEASE: 2.6.18-92.el5
>> VERSION: #1 SMP Tue Apr 29 13:16:15 EDT 2008
>> MACHINE: x86_64 (2400 Mhz)
>> MEMORY: 63.1 GB
>> PANIC: ""
>> PID: 6252
>> COMMAND: "ocfs2dc"
>> TASK: ffff810c7de5b860 [THREAD_INFO: ffff810c53928000]
>> CPU: 6
>> STATE: TASK_RUNNING (PANIC)
>>
>> crash64> bt
>> PID: 6252 TASK: ffff810c7de5b860 CPU: 6 COMMAND: "ocfs2dc"
>> #0 [ffff810c53929bb0] crash_kexec at ffffffff800aa977
>> #1 [ffff810c53929c70] __die at ffffffff800650af
>> #2 [ffff810c53929cb0] die at ffffffff8006b6ae
>> #3 [ffff810c53929ce0] do_invalid_op at ffffffff8006bc6e
>> #4 [ffff810c53929da0] error_exit at ffffffff8005dde9
>> [exception RIP: ocfs2_prepare_cancel_convert+263]
>> RIP: ffffffff8840649f RSP: ffff810c53929e50 RFLAGS: 00010082
>> RAX: 00000000ffffffff RBX: ffff8105d2a28280 RCX: ffff8105d2a28298
>> RDX: ffff810c3f1526a8 RSI: ffff8105d2a28280 RDI: ffff810c3f152000
>> RBP: ffff8105d2a28290 R8: ffff810c53928000 R9: 000000000000003a
>> R10: ffff81102fd84038 R11: ffff81102fb0c860 R12: 0000000000000246
>> R13: ffff810c3f152000 R14: 0000000000000000 R15: 0000000000000246
>> ORIG_RAX: ffffffffffffffff CS: 0010 SS: 0018
>> #5 [ffff810c53929ee8] kthread at ffffffff8003253d
>> #6 [ffff810c53929f48] kernel_thread at ffffffff8005dfb1
>> crash64> mod -s ocfs2
>> /home/xiaowhu/usr/lib/debug/lib/modules/2.6.18-92.el5/kernel/fs/ocfs2/ocfs2.ko.debug 
>>
>>
>> MODULE NAME SIZE OBJECT FILE
>> ffffffff8845bb80 ocfs2 492072
>> /home/xiaowhu/usr/lib/debug/lib/modules/2.6.18-92.el5/kernel/fs/ocfs2/ocfs2.ko.debug 
>>
>>
>>
>>
>> crash64> struct ocfs2_lock_res ffff8105d2a28280
>> struct ocfs2_lock_res {
>> l_priv = 0xffff8105d2a285a0,
>> l_ops = 0xffffffff8845b360,
>> l_lock = {
>> raw_lock = {
>> slock = 4294967295
>> }
>> },
>> l_blocked_list = {
>> next = 0xffff8105d2a28298,
>> prev = 0xffff8105d2a28298
>> },
>> l_mask_waiters = {
>> next = 0xffff8104b2979a98,
>> prev = 0xffff8104b2979a98
>> },
>> l_type = OCFS2_LOCK_TYPE_META,
>> l_flags = 326,
>> l_name = "M0000000000000000a1faac00000000",
>> l_level = -1,
>> l_ro_holders = 0,
>> l_ex_holders = 0,
>> l_lksb = {
>> status = DLM_NORMAL,
>> flags = 0,
>> lockid = 0xffff810a606c0740,
>> lvb =
>> "\005\000\000\001\000\000\000\000\000\000)\v\000\000\000e\023?\253\224\207i\023\022\333i\204\312\001@\277\021f\373\316\000\000\000\000\000\000\000\000\000\000\017\070A\355\000\002\000\000\000\000\257L\302\331\000\000\000" 
>>
>>
>> },
>> l_action = OCFS2_AST_ATTACH,
>> l_unlock_action = OCFS2_UNLOCK_INVALID,
>> l_requested = 3,
>> l_blocking = 5,
>> l_event = {
>> lock = {
>> raw_lock = {
>> slock = 1
>> }
>> },
>> task_list = {
>> next = 0xffff8105d2a28360,
>> prev = 0xffff8105d2a28360
>> }
>> },
>> l_debug_list = {
>> next = 0xffff81033cabad08,
>> prev = 0xffff8105d2a284a8
>> },
>> l_lock_num_prmode = 0,
>> l_lock_num_exmode = 0,
>> l_lock_num_prmode_failed = 0,
>> l_lock_num_exmode_failed = 0,
>> l_lock_total_prmode = 0,
>> l_lock_total_exmode = 0,
>> l_lock_max_prmode = 0,
>> l_lock_max_exmode = 0,
>> l_lock_refresh = 0
>> }
>>
>>
>>
>>
>> On 02/22/2012 08:45 AM, Sunil Mushran wrote:
>>> Both AST and BAST can only be sent by the master. And we ensure the
>>> master sends the ASTs before BAST.
>>>
>>> Do you have the full lockres dump?
>>>
>>> On 02/21/2012 04:36 PM, Xiaowei.hu wrote:
>>>> Hi Sunil,
>>>>
>>>> I mean it execute in this way:
>>>>
>>>> nodeA ocfs2_dlm_lock() and released the res spin lock,here A doesn't
>>>> hold spin locks,
>>>> then it start to execute the proxy ast handler , process bast request
>>>> from nodeB,
>>>> then dlmthread flushed the bast, after this node A start to queue its
>>>> ast in ocfs2_dlm_lock() function.
>>>>
>>>> Thanks,
>>>> Xiaowei
>>>> On 02/22/2012 01:48 AM, Sunil Mushran wrote:
>>>>> > bast queued and flushed,before the ast was queued
>>>>>
>>>>> Unlikely with o2dlm. dlmthread always sends ASTs before BASTs.
>>>>>
>>>>> Can you recreate the entire lockres? A full dump may yield more
>>>>> information.
>>>>>
>>>>> Sunil
>>>>>
>>>>> On 02/20/2012 10:12 PM, xiaowei.hu at oracle.com wrote:
>>>>>> I am trying to fix bug13611997,CT's machine run into BUG in ocfs2dc
>>>>>> thread, BUG_ON(lockres->l_action != OCFS2_AST_CONVERT&&
>>>>>> lockres->l_action != OCFS2_AST_DOWNCONVERT); I analysized the vmcore
>>>>>> , the lockres->l_action = OCFS2_AST_ATTACH and l_flags=326(which
>>>>>> means
>>>>>> OCFS2_LOCK_BUSY|OCFS2_LOCK_BLOCKED|OCFS2_LOCK_INITIALIZED|OCFS2_LOCK_QUEUED), 
>>>>>>
>>>>>>
>>>>>> after compared with the code , this status could be only possible
>>>>>> during ocfs2_cluster_lock,here is the race situation:
>>>>>>
>>>>>> NodeA NodeB
>>>>>> ocfs2_cluster_lock on a new lockres M
>>>>>> spin_lock_irqsave(&lockres->l_lock, flags);
>>>>>> gen = lockres_set_pending(lockres);
>>>>>> lockres->l_action = OCFS2_AST_ATTACH;
>>>>>> lockres_or_flags(lockres, OCFS2_LOCK_BUSY);
>>>>>> spin_unlock_irqrestore(&lockres->l_lock, flags);
>>>>>>
>>>>>> ocfs2_dlm_lock() finished and returned.
>>>>>> **and lockres_clear_pending(lockres, gen, osb);
>>>>>> request a lock on the same lockres M
>>>>>> It's blocked by nodeA, and a ast proxy was send to A
>>>>>>
>>>>>> bast queued and flushed,before the ast was queued
>>>>>> then the ocfs2dc was scheduled
>>>>>> there is a chance to execute this code path:
>>>>>> ocfs2_downconvert_thread()
>>>>>> ocfs2_downconvert_thread_do_work()
>>>>>> ocfs2_blocking_ast()
>>>>>> ocfs2_process_blocked_lock()
>>>>>> ocfs2_unblock_lock()
>>>>>> spin_lock_irqsave(&lockres->l_lock, flags);
>>>>>> if (lockres->l_flags& OCFS2_LOCK_BUSY)
>>>>>> ret = ocfs2_prepare_cancel_convert(osb, lockres);
>>>>>> BUG_ON(lockres->l_action != OCFS2_AST_CONVERT&&
>>>>>> lockres->l_action != OCFS2_AST_DOWNCONVERT);
>>>>>> here trigger the BUG()
>>>>>>
>>>>>> Solution:
>>>>>> One possible solution for this is to remove the 
>>>>>> lockres_clear_pending
>>>>>> marked by 2 stars, and left this clear work to the ast function.In
>>>>>> this way could make sure the bast function wait for ast , let it
>>>>>> clear OCFS2_LOCK_BUSY and set OCFS2_LOCK_ATTACHED first, before 
>>>>>> enter
>>>>>> downconvert process.
>>>>>>
>>>>>>
>>>>>
>>>>
>>>
>>
>
