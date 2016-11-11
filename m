From: Eric Ren <zren@suse.com>
Date: Fri, 11 Nov 2016 09:56:12 +0800
Subject: [Ocfs2-devel] [DRAFT 2/2] ocfs2: fix deadlock caused by
 recursive cluster locking
In-Reply-To: <582450CF.4030705@huawei.com>
References: <1476854382-28101-1-git-send-email-zren@suse.com>
	<1476854382-28101-3-git-send-email-zren@suse.com>
	<5817233C.4060703@huawei.com>
	<27420c84-c2db-ea00-dbce-33036674de9b@suse.com>
	<582450CF.4030705@huawei.com>
Message-ID: <968237e5-b308-84cc-2c99-637cdd13bd4c@suse.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi,

On 11/10/2016 06:49 PM, piaojun wrote:
> Hi Eric,
>
> On 2016-11-1 9:45, Eric Ren wrote:
>> Hi,
>>
>> On 10/31/2016 06:55 PM, piaojun wrote:
>>> Hi Eric,
>>>
>>> On 2016-10-19 13:19, Eric Ren wrote:
>>>> The deadlock issue happens when running discontiguous block
>>>> group testing on multiple nodes. The easier way to reproduce
>>>> is to do "chmod -R 777 /mnt/ocfs2" things like this on multiple
>>>> nodes at the same time by pssh.
>>>>
>>>> This is indeed another deadlock caused by: commit 743b5f1434f5
>>>> ("ocfs2: take inode lock in ocfs2_iop_set/get_acl()"). The reason
>>>> had been explained well by Tariq Saeed in this thread:
>>>>
>>>> https://oss.oracle.com/pipermail/ocfs2-devel/2015-September/011085.html
>>>>
>>>> For this case, the ocfs2_inode_lock() is misused recursively as below:
>>>>
>>>> do_sys_open
>>>>    do_filp_open
>>>>     path_openat
>>>>      may_open
>>>>       inode_permission
>>>>        __inode_permission
>>>>         ocfs2_permission  <====== ocfs2_inode_lock()
>>>>          generic_permission
>>>>           get_acl
>>>>            ocfs2_iop_get_acl  <====== ocfs2_inode_lock()
>>>>             ocfs2_inode_lock_full_nested <===== deadlock if a remote EX request
>>> Do you mean another node wants to get ex of the inode? or another process?
>> Remote EX request means "another node wants to get ex of the inode";-)
>>
>> Eric
> If another node wants to get ex, it will get blocked as this node has
> got pr. Why will the ex request make this node get blocked? Expect your
> detailed description.
Did you look at this link I mentioned above?

OCFS2_LOCK_BLOCKED flag of this lockres is set in BAST (ocfs2_generic_handle_bast) when 
downconvert is needed
on behalf of remote lock request.

The recursive cluster lock (the second one) will be blocked in __ocfs2_cluster_lock() 
because of OCFS2_LOCK_BLOCKED.
But the downconvert cannot be done, why? because there is no chance for the first cluster 
lock on this node to be unlocked -
we blocked ourselves in the code path.

Eric
>
> thanks,
> Jun
>>>> comes between two ocfs2_inode_lock()
>>>>
>>>> Fix by checking if the cluster lock has been acquired aready in the call-chain
>>>> path.
>>>>
>>>> Fixes: commit 743b5f1434f5 ("ocfs2: take inode lock in ocfs2_iop_set/get_acl()")
>>>> Signed-off-by: Eric Ren <zren@suse.com>
>>>> ---
>>>>    fs/ocfs2/acl.c | 39 +++++++++++++++++++++++++++------------
>>>>    1 file changed, 27 insertions(+), 12 deletions(-)
>>>>
>>>> diff --git a/fs/ocfs2/acl.c b/fs/ocfs2/acl.c
>>>> index bed1fcb..7e3544e 100644
>>>> --- a/fs/ocfs2/acl.c
>>>> +++ b/fs/ocfs2/acl.c
>>>> @@ -283,16 +283,24 @@ int ocfs2_set_acl(handle_t *handle,
>>>>    int ocfs2_iop_set_acl(struct inode *inode, struct posix_acl *acl, int type)
>>>>    {
>>>>        struct buffer_head *bh = NULL;
>>>> +    struct ocfs2_holder *oh;
>>>> +    struct ocfs2_lock_res *lockres = &OCFS2_I(inode)->ip_inode_lockres;
>>>>        int status = 0;
>>>>    -    status = ocfs2_inode_lock(inode, &bh, 1);
>>>> -    if (status < 0) {
>>>> -        if (status != -ENOENT)
>>>> -            mlog_errno(status);
>>>> -        return status;
>>>> +    oh = ocfs2_is_locked_by_me(lockres);
>>>> +    if (!oh) {
>>>> +        status = ocfs2_inode_lock(inode, &bh, 1);
>>>> +        if (status < 0) {
>>>> +            if (status != -ENOENT)
>>>> +                mlog_errno(status);
>>>> +            return status;
>>>> +        }
>>>>        }
>>>> +
>>>>        status = ocfs2_set_acl(NULL, inode, bh, type, acl, NULL, NULL);
>>>> -    ocfs2_inode_unlock(inode, 1);
>>>> +
>>>> +    if (!oh)
>>>> +        ocfs2_inode_unlock(inode, 1);
>>>>        brelse(bh);
>>>>        return status;
>>>>    }
>>>> @@ -302,21 +310,28 @@ struct posix_acl *ocfs2_iop_get_acl(struct inode *inode, int type)
>>>>        struct ocfs2_super *osb;
>>>>        struct buffer_head *di_bh = NULL;
>>>>        struct posix_acl *acl;
>>>> +    struct ocfs2_holder *oh;
>>>> +    struct ocfs2_lock_res *lockres = &OCFS2_I(inode)->ip_inode_lockres;
>>>>        int ret;
>>>>          osb = OCFS2_SB(inode->i_sb);
>>>>        if (!(osb->s_mount_opt & OCFS2_MOUNT_POSIX_ACL))
>>>>            return NULL;
>>>> -    ret = ocfs2_inode_lock(inode, &di_bh, 0);
>>>> -    if (ret < 0) {
>>>> -        if (ret != -ENOENT)
>>>> -            mlog_errno(ret);
>>>> -        return ERR_PTR(ret);
>>>> +
>>>> +    oh = ocfs2_is_locked_by_me(lockres);
>>>> +    if (!oh) {
>>>> +        ret = ocfs2_inode_lock(inode, &di_bh, 0);
>>>> +        if (ret < 0) {
>>>> +            if (ret != -ENOENT)
>>>> +                mlog_errno(ret);
>>>> +            return ERR_PTR(ret);
>>>> +        }
>>>>        }
>>>>          acl = ocfs2_get_acl_nolock(inode, type, di_bh);
>>>>    -    ocfs2_inode_unlock(inode, 0);
>>>> +    if (!oh)
>>>> +        ocfs2_inode_unlock(inode, 0);
>>>>        brelse(di_bh);
>>>>        return acl;
>>>>    }
>>>>
>>
>> .
>>
>
