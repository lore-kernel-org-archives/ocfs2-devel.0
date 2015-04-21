From: alex chen <alex.chen@huawei.com>
Date: Tue, 21 Apr 2015 10:54:00 +0800
Subject: [Ocfs2-devel] [PATCH] ocfs2: check if the ocfs2 lock resource
 be initialized before calling ocfs2_dlm_lock
In-Reply-To: <552F6487.4020707@oracle.com>
References: <5518C165.10106@huawei.com> <552F6487.4020707@oracle.com>
Message-ID: <5535BBC8.5030007@huawei.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi Junxiao,

On 2015/4/16 15:28, Junxiao Bi wrote:
> Hi Alex,
> 
> On 03/30/2015 11:22 AM, alex chen wrote:
>> If ocfs2 lockres has not been initialized before calling ocfs2_dlm_lock,
>> the lock won't be dropped and then will lead umount hung. The case is
>> described below:
>>
>> ocfs2_mknod
>>     ocfs2_mknod_locked
>>         __ocfs2_mknod_locked
>>             ocfs2_journal_access_di
>>             Failed because of -ENOMEM or other reasons, the inode lockres
>>             has not been initialized yet.
> 
> If failed here, is OCFS2_I(inode)->ip_inode_lockres initialized?  If not

The OCFS2_I(inode)->ip_inode_lockres is initialized as follows:
__ocfs2_mknod_locked
    ocfs2_populate_inode
        ocfs2_inode_lock_res_init
            ocfs2_lock_res_init_common
So if ocfs2_journal_access_di is failed, the ip_inode_lockres will not be
initialized.
In this situation, we should not allocate a new dlm lockres through calling
ocfs2_dlm_lock() in __ocfs2_cluster_lock(), otherwise it will lead umount
hung. So we need bread __ocfs2_cluster_lock() if the inode lockres is not
be initialized, that is the condition
(!(lockres->l_flags & OCFS2_LOCK_INITIALIZED)) is TRUE.

> how can you break __ocfs2_cluster_lock with the following condition?
> 
> if (!(lockres->l_flags & OCFS2_LOCK_INITIALIZED))
> 
> Thanks,
> Junxiao.
> 
>>
>>     iput(inode)
>>         ocfs2_evict_inode
>>             ocfs2_delete_inode
>>                 ocfs2_inode_lock
>>                     ocfs2_inode_lock_full_nested
>>                         __ocfs2_cluster_lock
>>                         Succeeds and allocates a new dlm lockres.
>>             ocfs2_clear_inode
>>                 ocfs2_open_unlock
>>                     ocfs2_drop_inode_locks
>>                         ocfs2_drop_lock
>>                         Since lockres has not been initialized, the lock
>>                         can't be dropped and the lockres can't be
>>                         migrated, thus umount will hang forever.
>>
>> Signed-off-by: Alex Chen <alex.chen@huawei.com>
>> Reviewed-by: Joseph Qi <joseph.qi@huawei.com>
>> Reviewed-by: joyce.xue <xuejiufei@huawei.com>
>>
>> ---
>>  fs/ocfs2/dlmglue.c | 5 +++++
>>  1 file changed, 5 insertions(+)
>>
>> diff --git a/fs/ocfs2/dlmglue.c b/fs/ocfs2/dlmglue.c
>> index 11849a4..8b23aa2 100644
>> --- a/fs/ocfs2/dlmglue.c
>> +++ b/fs/ocfs2/dlmglue.c
>> @@ -1391,6 +1391,11 @@ static int __ocfs2_cluster_lock(struct ocfs2_super *osb,
>>  	int noqueue_attempted = 0;
>>  	int dlm_locked = 0;
>>
>> +	if (!(lockres->l_flags & OCFS2_LOCK_INITIALIZED)) {
>> +		mlog_errno(-EINVAL);
>> +		return -EINVAL;
>> +	}
>> +
>>  	ocfs2_init_mask_waiter(&mw);
>>
>>  	if (lockres->l_ops->flags & LOCK_TYPE_USES_LVB)
>>
> 
> 
> .
> 
