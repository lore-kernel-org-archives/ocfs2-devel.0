From: Eric Ren <zren@suse.com>
Date: Mon, 9 Jan 2017 10:13:10 +0800
Subject: [Ocfs2-devel] [PATCH 2/2] ocfs2: fix deadlocks when taking
 inode lock at vfs entry points
In-Reply-To: <5c114d4b-8d6b-a26c-be05-ea2604f0b37c@gmail.com>
References: <1483630262-22227-1-git-send-email-zren@suse.com>
	<1483630262-22227-3-git-send-email-zren@suse.com>
	<dbf37786-9620-77fe-c500-881fdd455964@gmail.com>
	<2bfda278-6d7f-87c1-a053-8cbb9fb2463e@suse.com>
	<6450d035-1eec-88a0-57c2-cc3dcc115a46@gmail.com>
	<1dbd531e-39c3-d352-1052-bdbcb771a2c0@suse.com>
	<e8fb854e-14eb-4e14-0329-0807f0c43177@gmail.com>
	<2cc2b35f-9c93-0093-2365-e3fb02d46078@suse.com>
	<d1c38a46-f721-8f29-d395-9d8b67dc1330@gmail.com>
	<f983a441-68b9-c793-c7e6-30ad02c40136@suse.com>
	<5c114d4b-8d6b-a26c-be05-ea2604f0b37c@gmail.com>
Message-ID: <8789b9ff-b951-2569-8e80-2aabd503215d@suse.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Joseph Qi <jiangqi903@gmail.com>, ocfs2-devel@oss.oracle.com
Cc: akpm@linux-foundation.org, mfasheh@versity.com, jlbec@evilplan.org, ghe@suse.com, junxiao.bi@oracle.com, linux-kernel@vger.kernel.org

Hi,

On 01/09/2017 09:13 AM, Joseph Qi wrote:
> ...
>>
>>> The issue case you are trying to fix is:
>>> Process A
>>> take inode lock (phase1)
>>> ...
>>> <<< race window (phase2, Process B)
>>
>> The deadlock only happens if process B is on a remote node and request EX lock.
>>
>> Quote the patch[1/2]'s commit message:
>>
>> A deadlock will occur if a remote EX request comes in between two of
>> ocfs2_inode_lock().  Briefly describe how the deadlock is formed:
>>
>> On one hand, OCFS2_LOCK_BLOCKED flag of this lockres is set in
>> BAST(ocfs2_generic_handle_bast) when downconvert is started on behalf of
>> the remote EX lock request.  Another hand, the recursive cluster lock (the
>> second one) will be blocked in in __ocfs2_cluster_lock() because of
>> OCFS2_LOCK_BLOCKED.  But, the downconvert never complete, why? because
>> there is no chance for the first cluster lock on this node to be unlocked
>> - we block ourselves in the code path.
>> ---
>>
>>> ...
>>> take inode lock again (phase3)
>>>
>>> Deadlock happens because Process B in phase2 and Process A in phase3
>>> are waiting for each other.
>> It's local lock's (like i_mutex) responsibility to protect critical section from racing
>> among processes on the same node.
> I know we are talking a cluster lock issue. And the Process B I described is
> downconvert thread.

That's fine!

>>
>>> So you are trying to fix it by making phase3 finish without really doing
>>
>> Phase3 can go ahead because this node is already under protection of cluster lock.
> You said it was blocked...

Oh, sorry, I meant phase3 can go ahead if this patch set is applied;-)

> "Another hand, the recursive cluster lock (the second one) will be blocked in
> __ocfs2_cluster_lock() because of OCFS2_LOCK_BLOCKED."
>>
>>> __ocfs2_cluster_lock, then Process B can continue either.
>>> Let us bear in mind that phase1 and phase3 are in the same context and
>>> executed in order. That's why I think there is no need to check if locked
>>> by myself in phase1.
Sorry, I still cannot see it. Without keeping track of the first cluster lock, how can we 
know if
we are under a context that has already been in the protecting of cluster lock? How can we 
handle
the recursive locking (the second cluster lock) if we don't have this information?
>>> If phase1 finds it is already locked by myself, that means the holder
>>> is left by last operation without dec holder. That's why I think it is a bug
>>> instead of a recursive lock case.
I think I got your point here. Do you mean that we should just add the lock holder at the 
first locking position
without checking before that? Unfortunately, it's tricky here to know exactly which ocfs2 
routine will be the first vfs
entry point, such as ocfs2_get_acl() which can be both the first vfs entry point and the 
second vfs entry point after
ocfs2_permission(), right?

It will be a coding bug if the problem you concern about happens. I think we don't need to 
worry about this much because
the code logic here is quite simple;-)

Thanks for your patience!
Eric

>>
>> Did I answer your question?
>>
>> Thanks!
>> Eric
>>
>>>
>>> Thanks,
>>> Joseph
>>>>
>>>> Thanks,
>>>> Eric
>>>>
>>>>>
>>>>> Thanks,
>>>>> Joseph
>>>>>>
>>>>>> Thanks,
>>>>>> Eric
>>>>>>>
>>>>>>> Thanks,
>>>>>>> Joseph
>>>>>>>>
>>>>>>>> Thanks for your review;-)
>>>>>>>> Eric
>>>>>>>>
>>>>>>>>>
>>>>>>>>> Thanks,
>>>>>>>>> Joseph
>>>>>>>>>>
>>>>>>>>>> Signed-off-by: Eric Ren <zren@suse.com>
>>>>>>>>>> ---
>>>>>>>>>>   fs/ocfs2/acl.c  | 39 ++++++++++++++++++++++++++++++++++-----
>>>>>>>>>>   fs/ocfs2/file.c | 44 ++++++++++++++++++++++++++++++++++----------
>>>>>>>>>>   2 files changed, 68 insertions(+), 15 deletions(-)
>>>>>>>>>>
>>>>>>>>>> diff --git a/fs/ocfs2/acl.c b/fs/ocfs2/acl.c
>>>>>>>>>> index bed1fcb..c539890 100644
>>>>>>>>>> --- a/fs/ocfs2/acl.c
>>>>>>>>>> +++ b/fs/ocfs2/acl.c
>>>>>>>>>> @@ -284,16 +284,31 @@ int ocfs2_iop_set_acl(struct inode *inode, struct posix_acl 
>>>>>>>>>> *acl, int type)
>>>>>>>>>>   {
>>>>>>>>>>       struct buffer_head *bh = NULL;
>>>>>>>>>>       int status = 0;
>>>>>>>>>> -
>>>>>>>>>> -    status = ocfs2_inode_lock(inode, &bh, 1);
>>>>>>>>>> +    int arg_flags = 0, has_locked;
>>>>>>>>>> +    struct ocfs2_holder oh;
>>>>>>>>>> +    struct ocfs2_lock_res *lockres;
>>>>>>>>>> +
>>>>>>>>>> +    lockres = &OCFS2_I(inode)->ip_inode_lockres;
>>>>>>>>>> +    has_locked = (ocfs2_is_locked_by_me(lockres) != NULL);
>>>>>>>>>> +    if (has_locked)
>>>>>>>>>> +        arg_flags = OCFS2_META_LOCK_GETBH;
>>>>>>>>>> +    status = ocfs2_inode_lock_full(inode, &bh, 1, arg_flags);
>>>>>>>>>>       if (status < 0) {
>>>>>>>>>>           if (status != -ENOENT)
>>>>>>>>>>               mlog_errno(status);
>>>>>>>>>>           return status;
>>>>>>>>>>       }
>>>>>>>>>> +    if (!has_locked)
>>>>>>>>>> +        ocfs2_add_holder(lockres, &oh);
>>>>>>>>>> +
>>>>>>>>>>       status = ocfs2_set_acl(NULL, inode, bh, type, acl, NULL, NULL);
>>>>>>>>>> -    ocfs2_inode_unlock(inode, 1);
>>>>>>>>>> +
>>>>>>>>>> +    if (!has_locked) {
>>>>>>>>>> +        ocfs2_remove_holder(lockres, &oh);
>>>>>>>>>> +        ocfs2_inode_unlock(inode, 1);
>>>>>>>>>> +    }
>>>>>>>>>>       brelse(bh);
>>>>>>>>>> +
>>>>>>>>>>       return status;
>>>>>>>>>>   }
>>>>>>>>>>   @@ -303,21 +318,35 @@ struct posix_acl *ocfs2_iop_get_acl(struct inode *inode, 
>>>>>>>>>> int type)
>>>>>>>>>>       struct buffer_head *di_bh = NULL;
>>>>>>>>>>       struct posix_acl *acl;
>>>>>>>>>>       int ret;
>>>>>>>>>> +    int arg_flags = 0, has_locked;
>>>>>>>>>> +    struct ocfs2_holder oh;
>>>>>>>>>> +    struct ocfs2_lock_res *lockres;
>>>>>>>>>>         osb = OCFS2_SB(inode->i_sb);
>>>>>>>>>>       if (!(osb->s_mount_opt & OCFS2_MOUNT_POSIX_ACL))
>>>>>>>>>>           return NULL;
>>>>>>>>>> -    ret = ocfs2_inode_lock(inode, &di_bh, 0);
>>>>>>>>>> +
>>>>>>>>>> +    lockres = &OCFS2_I(inode)->ip_inode_lockres;
>>>>>>>>>> +    has_locked = (ocfs2_is_locked_by_me(lockres) != NULL);
>>>>>>>>>> +    if (has_locked)
>>>>>>>>>> +        arg_flags = OCFS2_META_LOCK_GETBH;
>>>>>>>>>> +    ret = ocfs2_inode_lock_full(inode, &di_bh, 0, arg_flags);
>>>>>>>>>>       if (ret < 0) {
>>>>>>>>>>           if (ret != -ENOENT)
>>>>>>>>>>               mlog_errno(ret);
>>>>>>>>>>           return ERR_PTR(ret);
>>>>>>>>>>       }
>>>>>>>>>> +    if (!has_locked)
>>>>>>>>>> +        ocfs2_add_holder(lockres, &oh);
>>>>>>>>>>         acl = ocfs2_get_acl_nolock(inode, type, di_bh);
>>>>>>>>>>   -    ocfs2_inode_unlock(inode, 0);
>>>>>>>>>> +    if (!has_locked) {
>>>>>>>>>> +        ocfs2_remove_holder(lockres, &oh);
>>>>>>>>>> +        ocfs2_inode_unlock(inode, 0);
>>>>>>>>>> +    }
>>>>>>>>>>       brelse(di_bh);
>>>>>>>>>> +
>>>>>>>>>>       return acl;
>>>>>>>>>>   }
>>>>>>>>>>   diff --git a/fs/ocfs2/file.c b/fs/ocfs2/file.c
>>>>>>>>>> index c488965..62be75d 100644
>>>>>>>>>> --- a/fs/ocfs2/file.c
>>>>>>>>>> +++ b/fs/ocfs2/file.c
>>>>>>>>>> @@ -1138,6 +1138,9 @@ int ocfs2_setattr(struct dentry *dentry, struct iattr *attr)
>>>>>>>>>>       handle_t *handle = NULL;
>>>>>>>>>>       struct dquot *transfer_to[MAXQUOTAS] = { };
>>>>>>>>>>       int qtype;
>>>>>>>>>> +    int arg_flags = 0, had_lock;
>>>>>>>>>> +    struct ocfs2_holder oh;
>>>>>>>>>> +    struct ocfs2_lock_res *lockres;
>>>>>>>>>>         trace_ocfs2_setattr(inode, dentry,
>>>>>>>>>>                   (unsigned long long)OCFS2_I(inode)->ip_blkno,
>>>>>>>>>> @@ -1173,13 +1176,20 @@ int ocfs2_setattr(struct dentry *dentry, struct iattr *attr)
>>>>>>>>>>           }
>>>>>>>>>>       }
>>>>>>>>>>   -    status = ocfs2_inode_lock(inode, &bh, 1);
>>>>>>>>>> +    lockres = &OCFS2_I(inode)->ip_inode_lockres;
>>>>>>>>>> +    had_lock = (ocfs2_is_locked_by_me(lockres) != NULL);
>>>>>>>>>> +    if (had_lock)
>>>>>>>>>> +        arg_flags = OCFS2_META_LOCK_GETBH;
>>>>>>>>>> +    status = ocfs2_inode_lock_full(inode, &bh, 1, arg_flags);
>>>>>>>>>>       if (status < 0) {
>>>>>>>>>>           if (status != -ENOENT)
>>>>>>>>>>               mlog_errno(status);
>>>>>>>>>>           goto bail_unlock_rw;
>>>>>>>>>>       }
>>>>>>>>>> -    inode_locked = 1;
>>>>>>>>>> +    if (!had_lock) {
>>>>>>>>>> +        ocfs2_add_holder(lockres, &oh);
>>>>>>>>>> +        inode_locked = 1;
>>>>>>>>>> +    }
>>>>>>>>>>         if (size_change) {
>>>>>>>>>>           status = inode_newsize_ok(inode, attr->ia_size);
>>>>>>>>>> @@ -1260,7 +1270,8 @@ int ocfs2_setattr(struct dentry *dentry, struct iattr *attr)
>>>>>>>>>>   bail_commit:
>>>>>>>>>>       ocfs2_commit_trans(osb, handle);
>>>>>>>>>>   bail_unlock:
>>>>>>>>>> -    if (status) {
>>>>>>>>>> +    if (status && inode_locked) {
>>>>>>>>>> +        ocfs2_remove_holder(lockres, &oh);
>>>>>>>>>>           ocfs2_inode_unlock(inode, 1);
>>>>>>>>>>           inode_locked = 0;
>>>>>>>>>>       }
>>>>>>>>>> @@ -1278,8 +1289,10 @@ int ocfs2_setattr(struct dentry *dentry, struct iattr *attr)
>>>>>>>>>>           if (status < 0)
>>>>>>>>>>               mlog_errno(status);
>>>>>>>>>>       }
>>>>>>>>>> -    if (inode_locked)
>>>>>>>>>> +    if (inode_locked) {
>>>>>>>>>> +        ocfs2_remove_holder(lockres, &oh);
>>>>>>>>>>           ocfs2_inode_unlock(inode, 1);
>>>>>>>>>> +    }
>>>>>>>>>>         brelse(bh);
>>>>>>>>>>       return status;
>>>>>>>>>> @@ -1321,20 +1334,31 @@ int ocfs2_getattr(struct vfsmount *mnt,
>>>>>>>>>>   int ocfs2_permission(struct inode *inode, int mask)
>>>>>>>>>>   {
>>>>>>>>>>       int ret;
>>>>>>>>>> +    int has_locked;
>>>>>>>>>> +    struct ocfs2_holder oh;
>>>>>>>>>> +    struct ocfs2_lock_res *lockres;
>>>>>>>>>>         if (mask & MAY_NOT_BLOCK)
>>>>>>>>>>           return -ECHILD;
>>>>>>>>>>   -    ret = ocfs2_inode_lock(inode, NULL, 0);
>>>>>>>>>> -    if (ret) {
>>>>>>>>>> -        if (ret != -ENOENT)
>>>>>>>>>> -            mlog_errno(ret);
>>>>>>>>>> -        goto out;
>>>>>>>>>> +    lockres = &OCFS2_I(inode)->ip_inode_lockres;
>>>>>>>>>> +    has_locked = (ocfs2_is_locked_by_me(lockres) != NULL);
>>>>>>>>>> +    if (!has_locked) {
>>>>>>>>>> +        ret = ocfs2_inode_lock(inode, NULL, 0);
>>>>>>>>>> +        if (ret) {
>>>>>>>>>> +            if (ret != -ENOENT)
>>>>>>>>>> +                mlog_errno(ret);
>>>>>>>>>> +            goto out;
>>>>>>>>>> +        }
>>>>>>>>>> +        ocfs2_add_holder(lockres, &oh);
>>>>>>>>>>       }
>>>>>>>>>>         ret = generic_permission(inode, mask);
>>>>>>>>>>   -    ocfs2_inode_unlock(inode, 0);
>>>>>>>>>> +    if (!has_locked) {
>>>>>>>>>> +        ocfs2_remove_holder(lockres, &oh);
>>>>>>>>>> +        ocfs2_inode_unlock(inode, 0);
>>>>>>>>>> +    }
>>>>>>>>>>   out:
>>>>>>>>>>       return ret;
>>>>>>>>>>   }
>>>>>>>>>
>>>>>>>>>
>>>>>>>>
>>>>>>>
>>>>>>>
>>>>>>
>>>>>
>>>>>
>>>>
>>>
>>>
>>
>
>
