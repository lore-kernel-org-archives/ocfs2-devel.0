From: Eric Ren <zren@suse.com>
Date: Tue, 17 Jan 2017 17:47:56 +0800
Subject: [Ocfs2-devel] [PATCH v3 1/2] ocfs2/dlmglue: prepare tracking
 logic to avoid recursive cluster lock
In-Reply-To: <8773427e-34d4-7880-e027-4e9330f73a3a@gmail.com>
References: <20170117063054.30519-1-zren@suse.com>
	<20170117063054.30519-2-zren@suse.com>
	<32cc4980-baa2-8b58-129d-8c7abc11cb87@gmail.com>
	<2d740f33-825d-bd32-a6bc-68ded55ab621@suse.com>
	<8773427e-34d4-7880-e027-4e9330f73a3a@gmail.com>
Message-ID: <c2352cf8-0a59-bff3-a460-7a4e82a70597@suse.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Joseph Qi <jiangqi903@gmail.com>, ocfs2-devel@oss.oracle.com
Cc: akpm@linux-foundation.org, mfasheh@versity.com, jlbec@evilplan.org, ghe@suse.com, junxiao.bi@oracle.com, sfr@canb.auug.org.au, hch@lst.de, linux-kernel@vger.kernel.org

Hi!

On 01/17/2017 04:43 PM, Joseph Qi wrote:
> On 17/1/17 15:55, Eric Ren wrote:
>> Hi!
>>
>> On 01/17/2017 03:39 PM, Joseph Qi wrote:
>>>
>>> On 17/1/17 14:30, Eric Ren wrote:
>>>> We are in the situation that we have to avoid recursive cluster locking,
>>>> but there is no way to check if a cluster lock has been taken by a
>>>> precess already.
>>>>
>>>> Mostly, we can avoid recursive locking by writing code carefully.
>>>> However, we found that it's very hard to handle the routines that
>>>> are invoked directly by vfs code. For instance:
>>>>
>>>> const struct inode_operations ocfs2_file_iops = {
>>>>      .permission     = ocfs2_permission,
>>>>      .get_acl        = ocfs2_iop_get_acl,
>>>>      .set_acl        = ocfs2_iop_set_acl,
>>>> };
>>>>
>>>> Both ocfs2_permission() and ocfs2_iop_get_acl() call ocfs2_inode_lock(PR):
>>>> do_sys_open
>>>>   may_open
>>>>    inode_permission
>>>>     ocfs2_permission
>>>>      ocfs2_inode_lock() <=== first time
>>>>       generic_permission
>>>>        get_acl
>>>>         ocfs2_iop_get_acl
>>>>     ocfs2_inode_lock() <=== recursive one
>>>>
>>>> A deadlock will occur if a remote EX request comes in between two
>>>> of ocfs2_inode_lock(). Briefly describe how the deadlock is formed:
>>>>
>>>> On one hand, OCFS2_LOCK_BLOCKED flag of this lockres is set in
>>>> BAST(ocfs2_generic_handle_bast) when downconvert is started
>>>> on behalf of the remote EX lock request. Another hand, the recursive
>>>> cluster lock (the second one) will be blocked in in __ocfs2_cluster_lock()
>>>> because of OCFS2_LOCK_BLOCKED. But, the downconvert never complete, why?
>>>> because there is no chance for the first cluster lock on this node to be
>>>> unlocked - we block ourselves in the code path.
>>>>
>>>> The idea to fix this issue is mostly taken from gfs2 code.
>>>> 1. introduce a new field: struct ocfs2_lock_res.l_holders, to
>>>> keep track of the processes' pid  who has taken the cluster lock
>>>> of this lock resource;
>>>> 2. introduce a new flag for ocfs2_inode_lock_full: OCFS2_META_LOCK_GETBH;
>>>> it means just getting back disk inode bh for us if we've got cluster lock.
>>>> 3. export a helper: ocfs2_is_locked_by_me() is used to check if we
>>>> have got the cluster lock in the upper code path.
>>>>
>>>> The tracking logic should be used by some of the ocfs2 vfs's callbacks,
>>>> to solve the recursive locking issue cuased by the fact that vfs routines
>>>> can call into each other.
>>>>
>>>> The performance penalty of processing the holder list should only be seen
>>>> at a few cases where the tracking logic is used, such as get/set acl.
>>>>
>>>> You may ask what if the first time we got a PR lock, and the second time
>>>> we want a EX lock? fortunately, this case never happens in the real world,
>>>> as far as I can see, including permission check, (get|set)_(acl|attr), and
>>>> the gfs2 code also do so.
>>>>
>>>> Changes since v1:
>>>> - Let ocfs2_is_locked_by_me() just return true/false to indicate if the
>>>> process gets the cluster lock - suggested by: Joseph Qi <jiangqi903@gmail.com>
>>>> and Junxiao Bi <junxiao.bi@oracle.com>.
>>>>
>>>> - Change "struct ocfs2_holder" to a more meaningful name "ocfs2_lock_holder",
>>>> suggested by: Junxiao Bi.
>>>>
>>>> - Do not inline functions whose bodies are not in scope, changed by:
>>>> Stephen Rothwell <sfr@canb.auug.org.au>.
>>>>
>>>> Changes since v2:
>>>> - Wrap the tracking logic code of recursive locking into functions,
>>>> ocfs2_inode_lock_tracker() and ocfs2_inode_unlock_tracker(),
>>>> suggested by: Junxiao Bi.
>>>>
>>>> [sfr at canb.auug.org.au remove some inlines]
>>>> Signed-off-by: Eric Ren <zren@suse.com>
>>>> ---
>>>>   fs/ocfs2/dlmglue.c | 105 +++++++++++++++++++++++++++++++++++++++++++++++++++--
>>>>   fs/ocfs2/dlmglue.h |  18 +++++++++
>>>>   fs/ocfs2/ocfs2.h   |   1 +
>>>>   3 files changed, 121 insertions(+), 3 deletions(-)
>>>>
>>>> diff --git a/fs/ocfs2/dlmglue.c b/fs/ocfs2/dlmglue.c
>>>> index 77d1632..c75b9e9 100644
>>>> --- a/fs/ocfs2/dlmglue.c
>>>> +++ b/fs/ocfs2/dlmglue.c
>>>> @@ -532,6 +532,7 @@ void ocfs2_lock_res_init_once(struct ocfs2_lock_res *res)
>>>>       init_waitqueue_head(&res->l_event);
>>>>       INIT_LIST_HEAD(&res->l_blocked_list);
>>>>       INIT_LIST_HEAD(&res->l_mask_waiters);
>>>> +    INIT_LIST_HEAD(&res->l_holders);
>>>>   }
>>>>     void ocfs2_inode_lock_res_init(struct ocfs2_lock_res *res,
>>>> @@ -749,6 +750,50 @@ void ocfs2_lock_res_free(struct ocfs2_lock_res *res)
>>>>       res->l_flags = 0UL;
>>>>   }
>>>>   +/*
>>>> + * Keep a list of processes who have interest in a lockres.
>>>> + * Note: this is now only uesed for check recursive cluster locking.
>>>> + */
>>>> +static inline void ocfs2_add_holder(struct ocfs2_lock_res *lockres,
>>>> +                   struct ocfs2_lock_holder *oh)
>>>> +{
>>>> +    INIT_LIST_HEAD(&oh->oh_list);
>>>> +    oh->oh_owner_pid =  get_pid(task_pid(current));
>>> Trim the redundant space here.
>>
>> You mean the blank line here? If so, I am OK to make the change. But,
>> I'm little worried about people may feel annoyed if I send the v4 patch set,
>> hah.
>>
> oh->oh_owner_pid =  get_pid(task_pid(current));
>                                  ^
> Here you put one more space.
> You can check your patches using checkpatch.pl then decide if need send
> a new version.
I double checked with checkpatch.pl, no warning here.

But, I can locate it by vim;-)

Thanks! I will resend v4, with all the received "reviewed-by" to Andrew.
Eric

>
> Thanks,
> Joseph
>>> Others look good to me.
>>> Reviewed-by: Joseph Qi <jiangqi903@gmail.com>
>>
>> Thanks for your guys' review!
>> Eric
>>>> +
>>>> +    spin_lock(&lockres->l_lock);
>>>> +    list_add_tail(&oh->oh_list, &lockres->l_holders);
>>>> +    spin_unlock(&lockres->l_lock);
>>>> +}
>>>> +
>>>> +static inline void ocfs2_remove_holder(struct ocfs2_lock_res *lockres,
>>>> +                       struct ocfs2_lock_holder *oh)
>>>> +{
>>>> +    spin_lock(&lockres->l_lock);
>>>> +    list_del(&oh->oh_list);
>>>> +    spin_unlock(&lockres->l_lock);
>>>> +
>>>> +    put_pid(oh->oh_owner_pid);
>>>> +}
>>>> +
>>>> +static inline int ocfs2_is_locked_by_me(struct ocfs2_lock_res *lockres)
>>>> +{
>>>> +    struct ocfs2_lock_holder *oh;
>>>> +    struct pid *pid;
>>>> +
>>>> +    /* look in the list of holders for one with the current task as owner */
>>>> +    spin_lock(&lockres->l_lock);
>>>> +    pid = task_pid(current);
>>>> +    list_for_each_entry(oh, &lockres->l_holders, oh_list) {
>>>> +        if (oh->oh_owner_pid == pid) {
>>>> +            spin_unlock(&lockres->l_lock);
>>>> +            return 1;
>>>> +        }
>>>> +    }
>>>> +    spin_unlock(&lockres->l_lock);
>>>> +
>>>> +    return 0;
>>>> +}
>>>> +
>>>>   static inline void ocfs2_inc_holders(struct ocfs2_lock_res *lockres,
>>>>                        int level)
>>>>   {
>>>> @@ -2333,8 +2378,9 @@ int ocfs2_inode_lock_full_nested(struct inode *inode,
>>>>           goto getbh;
>>>>       }
>>>>   -    if (ocfs2_mount_local(osb))
>>>> -        goto local;
>>>> +    if ((arg_flags & OCFS2_META_LOCK_GETBH) ||
>>>> +        ocfs2_mount_local(osb))
>>>> +        goto update;
>>>>         if (!(arg_flags & OCFS2_META_LOCK_RECOVERY))
>>>>           ocfs2_wait_for_recovery(osb);
>>>> @@ -2363,7 +2409,7 @@ int ocfs2_inode_lock_full_nested(struct inode *inode,
>>>>       if (!(arg_flags & OCFS2_META_LOCK_RECOVERY))
>>>>           ocfs2_wait_for_recovery(osb);
>>>>   -local:
>>>> +update:
>>>>       /*
>>>>        * We only see this flag if we're being called from
>>>>        * ocfs2_read_locked_inode(). It means we're locking an inode
>>>> @@ -2497,6 +2543,59 @@ void ocfs2_inode_unlock(struct inode *inode,
>>>>           ocfs2_cluster_unlock(OCFS2_SB(inode->i_sb), lockres, level);
>>>>   }
>>>>   +/*
>>>> + * This _tracker variantes are introduced to deal with the recursive cluster
>>>> + * locking issue. The idea is to keep track of a lock holder on the stack of
>>>> + * the current process. If there's a lock holder on the stack, we know the
>>>> + * task context is already protected by cluster locking. Currently, they're
>>>> + * used in some VFS entry routines.
>>>> + *
>>>> + * return < 0 on error, return == 0 if there's no lock holder on the stack
>>>> + * before this call, return == 1 if this call would be a recursive locking.
>>>> + */
>>>> +int ocfs2_inode_lock_tracker(struct inode *inode,
>>>> +                 struct buffer_head **ret_bh,
>>>> +                 int ex,
>>>> +                 struct ocfs2_lock_holder *oh)
>>>> +{
>>>> +    int status;
>>>> +    int arg_flags = 0, has_locked;
>>>> +    struct ocfs2_lock_res *lockres;
>>>> +
>>>> +    lockres = &OCFS2_I(inode)->ip_inode_lockres;
>>>> +    has_locked = ocfs2_is_locked_by_me(lockres);
>>>> +    /* Just get buffer head if the cluster lock has been taken */
>>>> +    if (has_locked)
>>>> +        arg_flags = OCFS2_META_LOCK_GETBH;
>>>> +
>>>> +    if (likely(!has_locked || ret_bh)) {
>>>> +        status = ocfs2_inode_lock_full(inode, ret_bh, ex, arg_flags);
>>>> +        if (status < 0) {
>>>> +            if (status != -ENOENT)
>>>> +                mlog_errno(status);
>>>> +            return status;
>>>> +        }
>>>> +    }
>>>> +    if (!has_locked)
>>>> +        ocfs2_add_holder(lockres, oh);
>>>> +
>>>> +    return has_locked;
>>>> +}
>>>> +
>>>> +void ocfs2_inode_unlock_tracker(struct inode *inode,
>>>> +                int ex,
>>>> +                struct ocfs2_lock_holder *oh,
>>>> +                int had_lock)
>>>> +{
>>>> +    struct ocfs2_lock_res *lockres;
>>>> +
>>>> +    lockres = &OCFS2_I(inode)->ip_inode_lockres;
>>>> +    if (!had_lock) {
>>>> +        ocfs2_remove_holder(lockres, oh);
>>>> +        ocfs2_inode_unlock(inode, ex);
>>>> +    }
>>>> +}
>>>> +
>>>>   int ocfs2_orphan_scan_lock(struct ocfs2_super *osb, u32 *seqno)
>>>>   {
>>>>       struct ocfs2_lock_res *lockres;
>>>> diff --git a/fs/ocfs2/dlmglue.h b/fs/ocfs2/dlmglue.h
>>>> index d293a22..a7fc18b 100644
>>>> --- a/fs/ocfs2/dlmglue.h
>>>> +++ b/fs/ocfs2/dlmglue.h
>>>> @@ -70,6 +70,11 @@ struct ocfs2_orphan_scan_lvb {
>>>>       __be32    lvb_os_seqno;
>>>>   };
>>>>   +struct ocfs2_lock_holder {
>>>> +    struct list_head oh_list;
>>>> +    struct pid *oh_owner_pid;
>>>> +};
>>>> +
>>>>   /* ocfs2_inode_lock_full() 'arg_flags' flags */
>>>>   /* don't wait on recovery. */
>>>>   #define OCFS2_META_LOCK_RECOVERY    (0x01)
>>>> @@ -77,6 +82,8 @@ struct ocfs2_orphan_scan_lvb {
>>>>   #define OCFS2_META_LOCK_NOQUEUE        (0x02)
>>>>   /* don't block waiting for the downconvert thread, instead return -EAGAIN */
>>>>   #define OCFS2_LOCK_NONBLOCK        (0x04)
>>>> +/* just get back disk inode bh if we've got cluster lock. */
>>>> +#define OCFS2_META_LOCK_GETBH        (0x08)
>>>>     /* Locking subclasses of inode cluster lock */
>>>>   enum {
>>>> @@ -170,4 +177,15 @@ void ocfs2_put_dlm_debug(struct ocfs2_dlm_debug *dlm_debug);
>>>>     /* To set the locking protocol on module initialization */
>>>>   void ocfs2_set_locking_protocol(void);
>>>> +
>>>> +/* The _tracker pair is used to avoid cluster recursive locking */
>>>> +int ocfs2_inode_lock_tracker(struct inode *inode,
>>>> +                 struct buffer_head **ret_bh,
>>>> +                 int ex,
>>>> +                 struct ocfs2_lock_holder *oh);
>>>> +void ocfs2_inode_unlock_tracker(struct inode *inode,
>>>> +                int ex,
>>>> +                struct ocfs2_lock_holder *oh,
>>>> +                int had_lock);
>>>> +
>>>>   #endif    /* DLMGLUE_H */
>>>> diff --git a/fs/ocfs2/ocfs2.h b/fs/ocfs2/ocfs2.h
>>>> index 7e5958b..0c39d71 100644
>>>> --- a/fs/ocfs2/ocfs2.h
>>>> +++ b/fs/ocfs2/ocfs2.h
>>>> @@ -172,6 +172,7 @@ struct ocfs2_lock_res {
>>>>         struct list_head         l_blocked_list;
>>>>       struct list_head         l_mask_waiters;
>>>> +    struct list_head     l_holders;
>>>>         unsigned long         l_flags;
>>>>       char l_name[OCFS2_LOCK_ID_MAX_LEN];
>>>
>>>
>>
>
>
