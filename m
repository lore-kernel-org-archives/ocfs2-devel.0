From: piaojun <piaojun@huawei.com>
Date: Fri, 19 Jan 2018 15:03:30 +0800
Subject: [Ocfs2-devel] [Ocfs2-dev] BUG: deadlock with umount and ocfs2
 workqueue triggered by ocfs2rec thread
In-Reply-To: <63ADC13FD55D6546B7DECE290D39E373F2912A22@H3CMLB12-EX.srv.huawei-3com.com>
References: <D1E4D02760513D4B90DC3B40FF32AF35E22EC390@H3CMLB14-EX.srv.huawei-3com.com>
	<0044cc89-5cda-c4a9-5eb0-1e5d85416805@suse.com>
	<20180117152135.nhiho7agzxige6xl@quack2.suse.cz>
	<20180117155734.ntkwdbvbkikh6dcl@quack2.suse.cz>
	<63ADC13FD55D6546B7DECE290D39E373F2912842@H3CMLB12-EX.srv.huawei-3com.com>
	<5A616313.4070403@huawei.com>
	<63ADC13FD55D6546B7DECE290D39E373F2912961@H3CMLB12-EX.srv.huawei-3com.com>
	<5A616D15.3060101@huawei.com>
	<63ADC13FD55D6546B7DECE290D39E373F2912A22@H3CMLB12-EX.srv.huawei-3com.com>
Message-ID: <5A619842.3090108@huawei.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi Changwei,

On 2018/1/19 13:42, Changwei Ge wrote:
> Hi Jun,
> 
> On 2018/1/19 11:59, piaojun wrote:
>> Hi Changwei,
>>
>> On 2018/1/19 11:38, Changwei Ge wrote:
>>> Hi Jun,
>>>
>>> On 2018/1/19 11:17, piaojun wrote:
>>>> Hi Jan, Eric and Changwei,
>>>>
>>>> Could we use another mutex lock to protect quota recovery? Sharing the
>>>> lock with VFS-layer probably seems a little weird.
>>>
>>> I am afraid that we can't since quota need ::s_umount and we indeed need
>>> ::s_umount to get rid of race that quota has freed structs that will be
>>> used by quota recovery in ocfs2.
>>>
>> Could you explain which 'structs' used by quota recovery? Do you mean
>> 'struct super_block'?
> I am not pointing to super_block.
> 
> Sure.
> You can refer to
> ocfs2_finish_quota_recovery
>    ocfs2_recover_local_quota_file -> here, operations on quota happens
> 
> Thanks,
> Changwei
> 
I looked through the code in deactivate_locked_super(), and did not
find any *structs* needed to be protected except 'sb'. In addition I
still could not figure out why 'dqonoff_mutex' was relaced by
's_umount'. At least, the patch 5f530de63cfc did not mention that. I
will appreciate for detailed explaination.

""
ocfs2: Use s_umount for quota recovery protection

Currently we use dqonoff_mutex to serialize quota recovery protection
and turning of quotas on / off. Use s_umount semaphore instead.
""

thanks,
Jun

>>
>> thanks,
>> Jun
>>
>>>>
>>>> On 2018/1/19 9:48, Changwei Ge wrote:
>>>>> Hi Jan,
>>>>>
>>>>> On 2018/1/18 0:03, Jan Kara wrote:
>>>>>> On Wed 17-01-18 16:21:35, Jan Kara wrote:
>>>>>>> Hello,
>>>>>>>
>>>>>>> On Fri 12-01-18 16:25:56, Eric Ren wrote:
>>>>>>>> On 01/12/2018 11:43 AM, Shichangkuo wrote:
>>>>>>>>> Hi all,
>>>>>>>>> ??Now we are testing ocfs2 with 4.14 kernel, and we finding a deadlock with umount and ocfs2 workqueue triggered by ocfs2rec thread. The stack as follows:
>>>>>>>>> journal recovery work:
>>>>>>>>> [<ffffffff8a8c0694>] call_rwsem_down_read_failed+0x14/0x30
>>>>>>>>> [<ffffffffc0d5d652>] ocfs2_finish_quota_recovery+0x62/0x450 [ocfs2]
>>>>>>>>> [<ffffffffc0d21221>] ocfs2_complete_recovery+0xc1/0x440 [ocfs2]
>>>>>>>>> [<ffffffff8a09a1f0>] process_one_work+0x130/0x350
>>>>>>>>> [<ffffffff8a09a946>] worker_thread+0x46/0x3b0
>>>>>>>>> [<ffffffff8a0a0e51>] kthread+0x101/0x140
>>>>>>>>> [<ffffffff8aa002ff>] ret_from_fork+0x1f/0x30
>>>>>>>>> [<ffffffffffffffff>] 0xffffffffffffffff
>>>>>>>>>
>>>>>>>>> /bin/umount:
>>>>>>>>> [<ffffffff8a099b24>] flush_workqueue+0x104/0x3e0
>>>>>>>>> [<ffffffffc0cf18db>] ocfs2_truncate_log_shutdown+0x3b/0xc0 [ocfs2]
>>>>>>>>> [<ffffffffc0d4fd6c>] ocfs2_dismount_volume+0x8c/0x3d0 [ocfs2]
>>>>>>>>> [<ffffffffc0d500e1>] ocfs2_put_super+0x31/0xa0 [ocfs2]
>>>>>>>>> [<ffffffff8a2445bd>] generic_shutdown_super+0x6d/0x120
>>>>>>>>> [<ffffffff8a24469d>] kill_block_super+0x2d/0x60
>>>>>>>>> [<ffffffff8a244e71>] deactivate_locked_super+0x51/0x90
>>>>>>>>> [<ffffffff8a263a1b>] cleanup_mnt+0x3b/0x70
>>>>>>>>> [<ffffffff8a09e9c6>] task_work_run+0x86/0xa0
>>>>>>>>> [<ffffffff8a003d70>] exit_to_usermode_loop+0x6d/0xa9
>>>>>>>>> [<ffffffff8a003a2d>] do_syscall_64+0x11d/0x130
>>>>>>>>> [<ffffffff8aa00113>] entry_SYSCALL64_slow_path+0x25/0x25
>>>>>>>>> [<ffffffffffffffff>] 0xffffffffffffffff
>>>>>>>>> ??
>>>>>>>>> Function ocfs2_finish_quota_recovery try to get sb->s_umount, which was already locked by umount thread, then get a deadlock.
>>>>>>>>
>>>>>>>> Good catch, thanks for reporting.  Is it reproducible? Can you please share
>>>>>>>> the steps for reproducing this issue?
>>>>>>>>> This issue was introduced by c3b004460d77bf3f980d877be539016f2df4df12 and 5f530de63cfc6ca8571cbdf58af63fb166cc6517.
>>>>>>>>> I think we cannot use :: s_umount, but the mutex ::dqonoff_mutex was already removed.
>>>>>>>>> Shall we add a new mutex?
>>>>>>>>
>>>>>>>> @Jan, I don't look into the code yet, could you help me understand why we
>>>>>>>> need to get sb->s_umount in ocfs2_finish_quota_recovery?
>>>>>>>> Is it because that the quota recovery process will start at umounting? or
>>>>>>>> some where else?
>>>>>>>
>>>>>>> I was refreshing my memory wrt how ocfs2 quota recovery works. The problem
>>>>>>> is the following: We load information about all quota information that
>>>>>>> needs recovering (this is possibly for other nodes) in
>>>>>>> ocfs2_begin_quota_recovery() that gets called during mount. Real quota
>>>>>>> recovery happens from the recovery thread in ocfs2_finish_quota_recovery().
>>>>>>> We need to protect code running there from dquot_disable() calls as that
>>>>>>> will free structures we use for updating quota information etc. Currently
>>>>>>> we use sb->s_umount for that protection.
>>>>>>>
>>>>>>> The problem above apparently happens when someone calls umount before the
>>>>>>> recovery thread can finish quota recovery. I will think more about how to
>>>>>>> fix the locking so that this lock inversion does not happen...
>>>>>>
>>>>>> So could we move ocfs2_recovery_exit() call in ocfs2_dismount_volume() up
>>>>>> before ocfs2_disable_quotas()? It seems possible to me, I'm just not sure
>>>>>> if there are not some hidden dependencies on recovery being shut down only
>>>>>> after truncate log / local alloc. If we can do that, we could remove
>>>>>> s_umount protection from ocfs2_finish_quota_recovery() and thus resolve the
>>>>>> race.
>>>>>>
>>>>>> 								Honza
>>>>>
>>>>> Thanks for looking into this.
>>>>> I am not quite familiar with quota part.:)
>>>>>
>>>>> Or can we move ocfs2_disable_quotas() in ocfs2_dismount_volume down
>>>>> after ocfs2_recovery_exit() with ::invoking down_read(&sb->s_umount)
>>>>> eliminated?
>>>>>
>>>>> Another way I can figure out is:
>>>>> I think we might get inspired from qsync_work_fn().
>>>>> In that function if current work is under running context of umount with
>>>>> ::s_umount held, it just delays current work to next time.
>>>>>
>>>>> So can we also _try lock_ in ocfs2_finish_quota_recovery() and recover
>>>>> quota by other ocfs2 cluster member nodes or local node's next time of
>>>>> mount?
>>>>>
>>>> I guess we need analyse the impact of _try lock_. Such as no other node
>>>> will help recovering quota when I'm the only node in cluster.
>>>
>>> I don't see any risk for now. I will think about it more, later.
>>>
>>> Thanks,
>>> Changwei
>>>>
>>>> thanks,
>>>> Jun
>>>>
>>>>> Thanks,
>>>>> Changwei
>>>>>
>>>>>
>>>>>>
>>>>> _______________________________________________
>>>>> Ocfs2-devel mailing list
>>>>> Ocfs2-devel at oss.oracle.com
>>>>> https://oss.oracle.com/mailman/listinfo/ocfs2-devel
>>>>>
>>>>
>>> .
>>>
>>
> .
> 
