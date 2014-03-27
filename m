From: Xue jiufei <xuejiufei@huawei.com>
Date: Thu, 27 Mar 2014 16:52:28 +0800
Subject: [Ocfs2-devel] [PATCH] ocfs2: __ocfs2_mknod_locked should return
 error when ocfs2_create_new_inode_locks() failed
In-Reply-To: <20140327042827.GB5215@localhost>
References: <53328061.30804@huawei.com> <20140327042827.GB5215@localhost>
Message-ID: <5333E6CC.1080500@huawei.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On 2014/3/27 12:28, Joel Becker wrote:
> On Wed, Mar 26, 2014 at 03:23:13PM +0800, Xue jiufei wrote:
>> When ocfs2_create_new_inode_locks() return error, inode open lock may
>> not be obtainted for this inode. So other nodes can remove this file
>> and free dinode when inode still remain in memory on this node,
>> which is not correct and may trigger BUG. So __ocfs2_mknod_locked
>> should return error when ocfs2_create_new_inode_locks() failed.
>>
>>               Node_1                              Node_2
>> create fileA, call ocfs2_mknod()
>>   -> ocfs2_get_init_inode(), allocate inodeA
>>   -> ocfs2_claim_new_inode(), claim dinode(dinodeA)
>>   -> call ocfs2_create_new_inode_locks(),
>>      create open lock failed, return error
>>   -> __ocfs2_mknod_locked return success
>>             
>>                                                 unlink fileA
>>                                                 try open lock succeed,
>>                                                 and free dinodeA
>>
>> create another file, call ocfs2_mknod()
>>   -> ocfs2_get_init_inode(), allocate inodeB
>>   -> ocfs2_claim_new_inode(), as Node_2 had freed dinodeA,
>>      so claim dinodeA and update generation for dinodeA
>>
>> call __ocfs2_drop_dl_inodes()->ocfs2_delete_inode()
>> to free inodeA, and finally triggers BUG
>> on(inode->i_generation != le32_to_cpu(fe->i_generation))
>> in function ocfs2_inode_lock_update().
> 
> Wow, that's a deep race, and it's some salty old code.  I think I buy
> your description of the problem.  I'm trying to figure out why we didn't
> hit this before.
> 
> What workload or tests triggered this?  Do you know why
> ocfs2_create_new_inode_locks() failed in the first place?  I suspect it
> almost never fails, which is why we haven't seen this issue.  Also,
> which cluster stack was involved?
> 
> Finally, have you tested the result?  I believe that the iput()
> machinery will do the right thing, but tests are better than my
> intuition.
> 
> Joel
> 
We triggered this BUG while running racer.sh, but no helpful messages remained
and it can not be reproduced. So we analyzed function ocfs2_mknod() and found
this situation. To reproduce this bug, we force ocfs2_create_new_inode_locks()
to return error without abtaining open lock, and insert some delay before
__ocfs2_drop_dl_inodes(). So I am sorry that I don't known why
ocfs2_create_new_inode_locks() failed.

>>
>> Signed-off-by: joyce.xue <xuejiufei@huawei.com>
>> ---
>>  fs/ocfs2/namei.c | 3 ---
>>  1 file changed, 3 deletions(-)
>>
>> diff --git a/fs/ocfs2/namei.c b/fs/ocfs2/namei.c
>> index 3683643..63f9692 100644
>> --- a/fs/ocfs2/namei.c
>> +++ b/fs/ocfs2/namei.c
>> @@ -576,9 +576,6 @@ static int __ocfs2_mknod_locked(struct inode *dir,
>>  			mlog_errno(status);
>>  	}
>>  
>> -	status = 0; /* error in ocfs2_create_new_inode_locks is not
>> -		     * critical */
>> -
>>  leave:
>>  	if (status < 0) {
>>  		if (*new_fe_bh) {
>> -- 
>> 1.8.4.3
>>
>>
>> _______________________________________________
>> Ocfs2-devel mailing list
>> Ocfs2-devel at oss.oracle.com
>> https://oss.oracle.com/mailman/listinfo/ocfs2-devel
> 
