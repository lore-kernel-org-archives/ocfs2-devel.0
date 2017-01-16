From: Eric Ren <zren@suse.com>
Date: Mon, 16 Jan 2017 11:17:41 +0800
Subject: [Ocfs2-devel] [PATCH 2/2] ocfs2: fix deadlocks when taking
 inode lock at vfs entry points
In-Reply-To: <d0585955-51fa-653d-94f3-51ca59e29453@oracle.com>
References: <1483630262-22227-1-git-send-email-zren@suse.com>
	<1483630262-22227-3-git-send-email-zren@suse.com>
	<eceaf0b9-e233-0424-5b91-8b4da6ffb85f@oracle.com>
	<31cc0413-6aa2-2493-fce6-f8f8ab9aaa16@suse.com>
	<6b3f4c7c-9276-321b-4e75-33c87a855757@oracle.com>
	<1d56b79c-1c2b-b988-7861-6b80df1d0a20@suse.com>
	<d0585955-51fa-653d-94f3-51ca59e29453@oracle.com>
Message-ID: <7db68770-0e1f-65f6-5b7a-c9ad47c43d3a@suse.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Junxiao Bi <junxiao.bi@oracle.com>, ocfs2-devel@oss.oracle.com
Cc: akpm@linux-foundation.org, mfasheh@versity.com, jlbec@evilplan.org, ghe@suse.com, jiangqi903@gmail.com, linux-kernel@vger.kernel.org

On 01/16/2017 11:13 AM, Junxiao Bi wrote:
> On 01/16/2017 11:06 AM, Eric Ren wrote:
>> Hi Junxiao,
>>
>> On 01/16/2017 10:46 AM, Junxiao Bi wrote:
>>>>> If had_lock==true, it is a bug? I think we should BUG_ON for it, that
>>>>> can help us catch bug at the first time.
>>>> Good idea! But I'm not sure if "ocfs2_setattr" is always the first one
>>>> who takes the cluster lock.
>>>> It's harder for me to name all the possible paths;-/
>>> The BUG_ON() can help catch the path where ocfs2_setattr is not the
>>> first one.
>> Yes, I understand. But, the problem is that the vfs entries calling
>> order is out of our control.
>> I don't want to place an assertion where I'm not 100% sure it's
>> absolutely right;-)
> If it is not the first one, is it another recursive locking bug? In this
> case, if you don't like BUG_ON(), you can dump the call trace and print
> some warning message.

Yes! I like this idea, will add it in next version, thanks!

Eric

>
> Thanks,
> Junxiao.
>> Thanks,
>> Eric
>>
>>> Thanks,
>>> Junxiao.
>>>
>>>>>> +    if (had_lock)
>>>>>> +        arg_flags = OCFS2_META_LOCK_GETBH;
>>>>>> +    status = ocfs2_inode_lock_full(inode, &bh, 1, arg_flags);
>>>>>>         if (status < 0) {
>>>>>>             if (status != -ENOENT)
>>>>>>                 mlog_errno(status);
>>>>>>             goto bail_unlock_rw;
>>>>>>         }
>>>>>> -    inode_locked = 1;
>>>>>> +    if (!had_lock) {
>>>>>> +        ocfs2_add_holder(lockres, &oh);
>>>>>> +        inode_locked = 1;
>>>>>> +    }
>>>>>>           if (size_change) {
>>>>>>             status = inode_newsize_ok(inode, attr->ia_size);
>>>>>> @@ -1260,7 +1270,8 @@ int ocfs2_setattr(struct dentry *dentry, struct
>>>>>> iattr *attr)
>>>>>>     bail_commit:
>>>>>>         ocfs2_commit_trans(osb, handle);
>>>>>>     bail_unlock:
>>>>>> -    if (status) {
>>>>>> +    if (status && inode_locked) {
>>>>>> +        ocfs2_remove_holder(lockres, &oh);
>>>>>>             ocfs2_inode_unlock(inode, 1);
>>>>>>             inode_locked = 0;
>>>>>>         }
>>>>>> @@ -1278,8 +1289,10 @@ int ocfs2_setattr(struct dentry *dentry,
>>>>>> struct iattr *attr)
>>>>>>             if (status < 0)
>>>>>>                 mlog_errno(status);
>>>>>>         }
>>>>>> -    if (inode_locked)
>>>>>> +    if (inode_locked) {
>>>>>> +        ocfs2_remove_holder(lockres, &oh);
>>>>>>             ocfs2_inode_unlock(inode, 1);
>>>>>> +    }
>>>>>>           brelse(bh);
>>>>>>         return status;
>>>>>> @@ -1321,20 +1334,31 @@ int ocfs2_getattr(struct vfsmount *mnt,
>>>>>>     int ocfs2_permission(struct inode *inode, int mask)
>>>>>>     {
>>>>>>         int ret;
>>>>>> +    int has_locked;
>>>>>> +    struct ocfs2_holder oh;
>>>>>> +    struct ocfs2_lock_res *lockres;
>>>>>>           if (mask & MAY_NOT_BLOCK)
>>>>>>             return -ECHILD;
>>>>>>     -    ret = ocfs2_inode_lock(inode, NULL, 0);
>>>>>> -    if (ret) {
>>>>>> -        if (ret != -ENOENT)
>>>>>> -            mlog_errno(ret);
>>>>>> -        goto out;
>>>>>> +    lockres = &OCFS2_I(inode)->ip_inode_lockres;
>>>>>> +    has_locked = (ocfs2_is_locked_by_me(lockres) != NULL);
>>>>> The same thing as ocfs2_setattr.
>>>> OK. I will think over your suggestions!
>>>>
>>>> Thanks,
>>>> Eric
>>>>
>>>>> Thanks,
>>>>> Junxiao.
>>>>>> +    if (!has_locked) {
>>>>>> +        ret = ocfs2_inode_lock(inode, NULL, 0);
>>>>>> +        if (ret) {
>>>>>> +            if (ret != -ENOENT)
>>>>>> +                mlog_errno(ret);
>>>>>> +            goto out;
>>>>>> +        }
>>>>>> +        ocfs2_add_holder(lockres, &oh);
>>>>>>         }
>>>>>>           ret = generic_permission(inode, mask);
>>>>>>     -    ocfs2_inode_unlock(inode, 0);
>>>>>> +    if (!has_locked) {
>>>>>> +        ocfs2_remove_holder(lockres, &oh);
>>>>>> +        ocfs2_inode_unlock(inode, 0);
>>>>>> +    }
>>>>>>     out:
>>>>>>         return ret;
>>>>>>     }
>>>>>>
>
