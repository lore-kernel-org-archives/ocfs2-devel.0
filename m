From: Eric Ren <zren@suse.com>
Date: Wed, 12 Oct 2016 18:54:03 +0800
Subject: [Ocfs2-devel] [Question] deadlock on chmod when running
 discontigous block group multiple node testing
In-Reply-To: <65773ae9-25b9-d5a7-f3e2-8c5339890ab7@oracle.com>
References: <66f1a48d-21e2-aeed-5d79-2ad2576760f5@suse.com>
	<a753e9d1-2f32-7675-7e22-1a4fdc8746a3@oracle.com>
	<85fdd83f-adb8-59be-2d32-df1e36c663d9@suse.com>
	<e830249c-8e41-74a0-321d-333d925b7ec2@suse.com>
	<a7e1cfc2-6f90-ef95-a57c-6d8397ca3d48@oracle.com>
	<3da9ca1f-058e-1af1-f660-29f51c5ad983@suse.com>
	<65773ae9-25b9-d5a7-f3e2-8c5339890ab7@oracle.com>
Message-ID: <807074f0-83ed-cbbb-7134-af410e8e7b57@suse.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi,

On 10/12/2016 05:45 PM, Junxiao Bi wrote:
> On 10/12/2016 05:34 PM, Eric Ren wrote:
>> Hi Junxiao,
>>
>> On 10/12/2016 02:47 PM, Junxiao Bi wrote:
>>> On 10/12/2016 10:36 AM, Eric Ren wrote:
>>>> Hi,
>>>>
>>>> When backporting those patches, I find that they are already in our
>>>> product kernel, maybe
>>>> via "stable kernel" policy, although our product kernel is 4.4 while the
>>>> patches were merged
>>>> into 4.6.
>>>>
>>>> Seems it's another deadlock that happens when doing `chmod -R 777
>>>> /mnt/ocfs2`
>>>> among mutilple nodes at the same time.
>>> Yes, but i just finish running ocfs2 full test on linux next-20161006
>>> and didn't find any issue.
>> Thanks a lot, really!
>>
>> 1. What's the size of your ocfs2 disk? My disk is 200G.
> 212G
>
>> 2. Did you run discontig block group test with multiple nodes? with this
>> option:
> Yes, but i don't know what that option is.
>
>>                  " -m ocfs2cts1,ocfs2cts2"

ocfs2ctsX is the host name of cluster nodes. Discontig bg testcase will run in local mode if 
without
this option.

Thanks
Eric

>>
>> 3. Then, I am using fs/dlm. That's a different point.
> Yes, that deserve a look since your issue is cluster locking hung.
>
> Thanks,
> Junxiao.
>> Thanks,
>> Eric
>>
>>> Thanks,
>>> Junxiao.
>>>
>>>> Thanks,
>>>> Eric
>>>> On 10/12/2016 09:23 AM, Eric Ren wrote:
>>>>> Hi Junxiao,
>>>>>
>>>>>> Hi Eric,
>>>>>>
>>>>>> On 10/11/2016 10:42 AM, Eric Ren wrote:
>>>>>>> Hi Junxiao,
>>>>>>>
>>>>>>> As the subject, the testing hung there on a kernel without your
>>>>>>> patches:
>>>>>>>
>>>>>>> "ocfs2: revert using ocfs2_acl_chmod to avoid inode cluster lock
>>>>>>> hang"
>>>>>>> and
>>>>>>> "ocfs2: fix posix_acl_create deadlock"
>>>>>>>
>>>>>>> The stack trace is:
>>>>>>> ```
>>>>>>> ocfs2cts1:~ # pstree -pl 24133
>>>>>>> discontig_runne(24133)???activate_discon(21156)???mpirun(15146)???fillup_contig_b(15149)???sudo(15231)???chmod(15232)
>>>>>>>
>>>>>>>
>>>>>>>
>>>>>>> ocfs2cts1:~ # pgrep -a chmod
>>>>>>> 15232 /bin/chmod -R 777 /mnt/ocfs2
>>>>>>>
>>>>>>> ocfs2cts1:~ # cat /proc/15232/stack
>>>>>>> [<ffffffffa05377ef>] __ocfs2_cluster_lock.isra.39+0x1bf/0x620 [ocfs2]
>>>>>>> [<ffffffffa053856d>] ocfs2_inode_lock_full_nested+0x12d/0x840 [ocfs2]
>>>>>>> [<ffffffffa0538dbb>] ocfs2_inode_lock_atime+0xcb/0x170 [ocfs2]
>>>>>>> [<ffffffffa0531e61>] ocfs2_readdir+0x41/0x1b0 [ocfs2]
>>>>>>> [<ffffffff8120d03c>] iterate_dir+0x9c/0x110
>>>>>>> [<ffffffff8120d453>] SyS_getdents+0x83/0xf0
>>>>>>> [<ffffffff815e126e>] entry_SYSCALL_64_fastpath+0x12/0x6d
>>>>>>> [<ffffffffffffffff>] 0xffffffffffffffff
>>>>>>> ```
>>>>>>>
>>>>>>> Do you think this issue can be fixed by your patches?
>>>>>> Looks not. Those two patches are to fix recursive locking deadlock.
>>>>>> But
>>>>>> from above call trace, there is no recursive lock.
>>>>> Sorry, the call trace on another node was missing.  Here it is:
>>>>>
>>>>> ocfs2cts2:~ # pstree -lp
>>>>> sshd(4292)???sshd(4745)???sshd(4753)???bash(4754)???orted(4781)???fillup_contig_b(4782)???sudo(4864)???chmod(4865)
>>>>>
>>>>>
>>>>>
>>>>> ocfs2cts2:~ # cat /proc/4865/stack
>>>>> [<ffffffffa053e7ef>] __ocfs2_cluster_lock.isra.39+0x1bf/0x620 [ocfs2]
>>>>> [<ffffffffa053f56d>] ocfs2_inode_lock_full_nested+0x12d/0x840 [ocfs2]
>>>>> [<ffffffffa059c860>] ocfs2_iop_get_acl+0x40/0xf0 [ocfs2]
>>>>> [<ffffffff812044e6>] generic_permission+0x166/0x1c0
>>>>> [<ffffffffa0542aca>] ocfs2_permission+0xaa/0xd0 [ocfs2]
>>>>> [<ffffffff81204596>] __inode_permission+0x56/0xb0
>>>>> [<ffffffff812068fa>] link_path_walk+0x29a/0x560
>>>>> [<ffffffff81206cbf>] path_lookupat+0x7f/0x110
>>>>> [<ffffffff8120929c>] filename_lookup+0x9c/0x150
>>>>> [<ffffffff811f96c3>] SyS_fchmodat+0x33/0x90
>>>>> [<ffffffff815e126e>] entry_SYSCALL_64_fastpath+0x12/0x6d
>>>>> [<ffffffffffffffff>] 0xffffffffffffffff
>>>>>
>>>>> Thanks,
>>>>> Eric
>>>>>
>>>>>
>>>>>> Thanks,
>>>>>> Junxiao.
>>>>>>> I will try your patches later, but I am little worried the
>>>>>>> possibility
>>>>>>> of reproduction may not be 100%.
>>>>>>> So ask you to confirm;-)
>>>>>>>
>>>>>>> Eric
>>>>> _______________________________________________
>>>>> Ocfs2-devel mailing list
>>>>> Ocfs2-devel at oss.oracle.com
>>>>> https://oss.oracle.com/mailman/listinfo/ocfs2-devel
>
