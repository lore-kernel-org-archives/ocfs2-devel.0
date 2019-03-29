From: Gang He <ghe@suse.com>
Date: Thu, 28 Mar 2019 22:31:17 -0600
Subject: [Ocfs2-devel] [PATCH] ocfs2: fix ocfs2 read inode data panic in
 ocfs2_iget
In-Reply-To: <e224f7e3-ad4e-b348-08dd-cf64993879c2@oracle.com>
References: <1553477217-2736-1-git-send-email-sunny.s.zhang@oracle.com>
	<01433584-44d5-5b27-a0c9-fff4bff74864@gmail.com>
	<ab0a6ca7-2f6a-b738-72ce-4ffb6787aad2@oracle.com>
	<5C9846C7020000F90005B029@prv1-mh.provo.novell.com>
	<4b7dee86-52fe-d383-296e-5ce1bb7ef178@oracle.com>
	<e224f7e3-ad4e-b348-08dd-cf64993879c2@oracle.com>
Message-ID: <5C9D9F95020000F90005C4E5@prv1-mh.provo.novell.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hello Sunny,

The bug description is OK for us.
But I feel the fix looks like a little hack.
Could we use a normal way to handle this problem?
e.g. use ocfs2_dentry_revalidate() function to check the related dentry in case from nfs related access paths.

Thanks
Gang 

>>> On 3/29/2019 at  9:05 am, in message
<e224f7e3-ad4e-b348-08dd-cf64993879c2@oracle.com>, "sunny.s.zhang"
<sunny.s.zhang@oracle.com> wrote:
> Hi Gang,  Jiang Qi,  Joseph,
> 
> Is my description clear?
> Are there any other suggestions?
> In addition, it works fine on ext4.
> 
> ? 2019?03?25? 14:15, sunny.s.zhang ??:
>> Hi Gang,
>>
>>
>> ? 2019?03?25? 11:11, Gang He ??:
>>> Hi Sunny,
>>>
>>>
>>>>>> On 2019/3/25 at 10:18, in message
>>> <ab0a6ca7-2f6a-b738-72ce-4ffb6787aad2@oracle.com>, "sunny.s.zhang"
>>> <sunny.s.zhang@oracle.com> wrote:
>>>
>>>> ? 2019?03?25? 09:31, Joseph Qi ??:
>>>>> On 19/3/25 09:26, Shuning Zhang wrote:
>>>>>> In some cases, the function ocfs2_iget read the data of inode, 
>>>>>> which has
>>>>>> been deleted for some reason. That will make the system panic. So We
>>>>>> should judge whether this inode has been deleted, and tell the caller
>>>>>> that the inode is a bad inode.
>>>>>>
>>>>>> [283465.542049] OCFS2: ERROR (device sdp): 
>>>>>> ocfs2_validate_inode_block:
>>>>>> Invalid dinode #580640: OCFS2_VALID_FL not set
>>>>>>
>>>>> Looks like it is a filesystem corruption bug.
>>>>> So we'd better find where it is introduced and try to fix it there.
>>>> Thank you for reviewing
>>>> In that case, the ocfs2 was used as rear end of NFS(V3), which is
>>>> stateless as we know.  NFS can't protect parent
>>>> directory from being deleted, when child is being accessed. We can find
>>>> the description at Documentation/filesystems/nfs/Exporting.
>>>> I have reproduced this issue by adding some delay codes.  This issue 
>>>> can
>>>> be reproduced in the production environment in case of heavy load .
>>>> Of course this is a defect of NFS(V3),  But I think ocfs2 should have
>>>> some fault tolerance. ocfs2 should not panic, if it try to get a
>>>> nonexistent inode.
>>> I feel ocfs2_test_inode_bit() can avoid the problem, but why do we 
>>> still encounter this problem?
>>> Maybe there are some potential logic(or race condition) problem.
>> ocfs2_test_inode_bit() can test whether the inode have been deleted, 
>> but can't avoid this issue.
>> The key of this issue is ocfs2_get_parent() calls ocfs2_iget(inode) , 
>> but does not check if the inode exists.
>> I think this issue alse can be fixed, If ocfs2_get_parent() call 
>> ocfs2_test_inode_bit before  calling ocfs2_iget().
>> But this will have a little impact on performance.
>>
>> This issue can be reproduce by the following steps.
>> on the nfs server side,
>> ..../patha/pathb
>>
>> Step 1: The process A was scheduled before calling the function 
>> fh_verify.
>>
>> Step 2: The process B is removing the 'pathb', and just completed the 
>> call to
>> function dput.
>> Then the dentry of 'pathb' has been deleted from the dcache, and all
>> ancestors have been deleted also.
>> The relationship of dentry and inode was deleted through the function
>> hlist_del_init. The following is the call stack.
>> dentry_iput->hlist_del_init(&dentry->d_u.d_alias)
>>
>> At this time, the inode is still in the dcache.
>>
>> Step 3: The process A call the function ocfs2_get_dentry, which get 
>> the inode
>> from dcache. Then the refcount of inode is 1. The following is the call
>> stack.
>> nfsd3_proc_getacl->fh_verify->exportfs_decode_fh->fh_to_dentry(ocfs2_get_dentr 
>>
>> y)
>>
>> Step 4: Dirty pages are flushed by bdi threads. So the inode of 
>> 'patha' is
>> evicted, and this directory was deleted.
>> But the inode of 'pathb' can't be evicted, because the refcount of the 
>> inode
>> was 1.
>>
>> Step 5: The process A keep running, and call the function 
>> reconnect_path(in exportfs_decode_fh),
>> which call function ocfs2_get_parent of ocfs2. Get the block number of 
>> parent
>> directory(patha) by the name of "..". Then read the data from disk by the
>> block number. Bug this inode has been deleted, so the system panic.
>>
>>
>> Process A                                                  Process B
>> 1. in nfsd3_proc_getacl                      |
>> 2. |        dput
>> 3. fh_to_dentry(ocfs2_get_dentry)  |
>> 4. bdi flush dirty cache                       |
>> 5. ocfs2_iget                                          |
>>
>> Thanks,
>> Sunny
>>> Thanks
>>> Gang
>>>
>>>
>>>> Thanks,
>>>> Sunny
>>>>> Thanks,
>>>>> Joseph
>>>>>
>>>>>> [283465.545490] Kernel panic - not syncing: OCFS2: (device sdp): 
>>>>>> panic
>>>> forced
>>>>>> after error
>>>>>>
>>>>>> [283465.546889] CPU: 5 PID: 12416 Comm: nfsd Tainted: G        W
>>>>>> 4.1.12-124.18.6.el6uek.bug28762940v3.x86_64 #2
>>>>>> [283465.548382] Hardware name: VMware, Inc. VMware Virtual 
>>>>>> Platform/440BX
>>>>>> Desktop Reference Platform, BIOS 6.00 09/21/2015
>>>>>> [283465.549657]  0000000000000000 ffff8800a56fb7b8 ffffffff816e839c
>>>>>> ffffffffa0514758
>>>>>> [283465.550392]  000000000008dc20 ffff8800a56fb838 ffffffff816e62d3
>>>>>> 0000000000000008
>>>>>> [283465.551056]  ffff880000000010 ffff8800a56fb848 ffff8800a56fb7e8
>>>>>> ffff88005df9f000
>>>>>> [283465.551710] Call Trace:
>>>>>> [283465.552516]  [<ffffffff816e839c>] dump_stack+0x63/0x81
>>>>>> [283465.553291]  [<ffffffff816e62d3>] panic+0xcb/0x21b
>>>>>> [283465.554037]  [<ffffffffa04e66b0>] ocfs2_handle_error+0xf0/0xf0 
>>>>>> [ocfs2]
>>>>>> [283465.554882]  [<ffffffffa04e7737>] __ocfs2_error+0x67/0x70 [ocfs2]
>>>>>> [283465.555768]  [<ffffffffa049c0f9>] 
>>>>>> ocfs2_validate_inode_block+0x229/0x230
>>>>>> [ocfs2]
>>>>>> [283465.556683]  [<ffffffffa047bcbc>] 
>>>>>> ocfs2_read_blocks+0x46c/0x7b0 [ocfs2]
>>>>>> [283465.557408]  [<ffffffffa049bed0>] ? 
>>>>>> ocfs2_inode_cache_io_unlock+0x20/0x20
>>>>>> [ocfs2]
>>>>>> [283465.557973]  [<ffffffffa049f0eb>] 
>>>>>> ocfs2_read_inode_block_full+0x3b/0x60
>>>>>> [ocfs2]
>>>>>> [283465.558525]  [<ffffffffa049f5ba>] ocfs2_iget+0x4aa/0x880 [ocfs2]
>>>>>> [283465.559082]  [<ffffffffa049146e>] ocfs2_get_parent+0x9e/0x220 
>>>>>> [ocfs2]
>>>>>> [283465.559622]  [<ffffffff81297c05>] reconnect_path+0xb5/0x300
>>>>>> [283465.560156]  [<ffffffff81297f46>] exportfs_decode_fh+0xf6/0x2b0
>>>>>> [283465.560708]  [<ffffffffa062faf0>] ? 
>>>>>> nfsd_proc_getattr+0xa0/0xa0 [nfsd]
>>>>>> [283465.561262]  [<ffffffff810a8196>] ? prepare_creds+0x26/0x110
>>>>>> [283465.561932]  [<ffffffffa0630860>] fh_verify+0x350/0x660 [nfsd]
>>>>>> [283465.562862]  [<ffffffffa0637804>] ? 
>>>>>> nfsd_cache_lookup+0x44/0x630 [nfsd]
>>>>>> [283465.563697]  [<ffffffffa063a8b9>] nfsd3_proc_getattr+0x69/0xf0 
>>>>>> [nfsd]
>>>>>> [283465.564510]  [<ffffffffa062cf60>] nfsd_dispatch+0xe0/0x290 [nfsd]
>>>>>> [283465.565358]  [<ffffffffa05eb892>] ? 
>>>>>> svc_tcp_adjust_wspace+0x12/0x30
>>>>>> [sunrpc]
>>>>>> [283465.566272]  [<ffffffffa05ea652>] 
>>>>>> svc_process_common+0x412/0x6a0 [sunrpc]
>>>>>> [283465.567155]  [<ffffffffa05eaa03>] svc_process+0x123/0x210 
>>>>>> [sunrpc]
>>>>>> [283465.568020]  [<ffffffffa062c90f>] nfsd+0xff/0x170 [nfsd]
>>>>>> [283465.568962]  [<ffffffffa062c810>] ? nfsd_destroy+0x80/0x80 [nfsd]
>>>>>> [283465.570112]  [<ffffffff810a622b>] kthread+0xcb/0xf0
>>>>>> [283465.571099]  [<ffffffff810a6160>] ? 
>>>>>> kthread_create_on_node+0x180/0x180
>>>>>> [283465.572114]  [<ffffffff816f11b8>] ret_from_fork+0x58/0x90
>>>>>> [283465.573156]  [<ffffffff810a6160>] ? 
>>>>>> kthread_create_on_node+0x180/0x180
>>>>>> ---
>>>>>>    fs/ocfs2/inode.c |   22 ++++++++++++++++++++++
>>>>>>    1 files changed, 22 insertions(+), 0 deletions(-)
>>>>>>
>>>>>> diff --git a/fs/ocfs2/inode.c b/fs/ocfs2/inode.c
>>>>>> index b254416..a7f8160 100644
>>>>>> --- a/fs/ocfs2/inode.c
>>>>>> +++ b/fs/ocfs2/inode.c
>>>>>> @@ -513,6 +513,16 @@ static int ocfs2_read_locked_inode(struct 
>>>>>> inode *inode,
>>>>>>        status = -EINVAL;
>>>>>>        fe = (struct ocfs2_dinode *) bh->b_data;
>>>>>>    +    /*
>>>>>> +     * In some cases, this inode has been deleted, but the data of
>>>>>> +     * inode is read directly. So We should judge whether this inode
>>>>>> +     * has been deleted.
>>>>>> +     * */
>>>>>> +    if (unlikely(fe->i_dtime != 0)) {
>>>>>> +        mlog(ML_NOTICE, "The inode %llu has been deleted\n",
>>>>>> +             le64_to_cpu(fe->i_blkno));
>>>>>> +            goto bail;
>>>>>> +    }
>>>>>>        /*
>>>>>>         * This is a code bug. Right now the caller needs to
>>>>>>         * understand whether it is asking for a system file inode or
>>>>>> @@ -1331,6 +1341,18 @@ int ocfs2_validate_inode_block(struct 
>>>>>> super_block
>>>> *sb,
>>>>>> BUG_ON(!buffer_uptodate(bh));
>>>>>>    +    /*
>>>>>> +     * In some cases, this inode has been deleted, but the data of
>>>>>> +     * inode is read directly. This is not a data corruption.So
>>>>>> +     * We should judge whether this inode has been deleted.
>>>>>> +     * */
>>>>>> +    if (unlikely(di->i_dtime != 0)) {
>>>>>> +        rc = -EINVAL;
>>>>>> +        mlog(ML_NOTICE, "The inode %llu has been deleted\n",
>>>>>> +             le64_to_cpu(di->i_blkno));
>>>>>> +            goto bail;
>>>>>> +    }
>>>>>> +
>>>>>>        /*
>>>>>>         * If the ecc fails, we return the error but otherwise
>>>>>>         * leave the filesystem running.  We know any error is
>>>>>>
>>>>
>>>> _______________________________________________
>>>> Ocfs2-devel mailing list
>>>> Ocfs2-devel at oss.oracle.com 
>>>> https://oss.oracle.com/mailman/listinfo/ocfs2-devel 
>>
