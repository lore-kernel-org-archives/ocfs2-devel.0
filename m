From: Joseph Qi <jiangqi903@gmail.com>
Date: Mon, 28 Nov 2016 14:17:06 +0800
Subject: [Ocfs2-devel] [PATCH] ocfs2: Optimization of code while free
 dead locks.
In-Reply-To: <b3e2b00d-94fb-4d51-1073-15047eb60b0b@suse.com>
References: <71604351584F6A4EBAE558C676F37CA4C4AE0278@H3CMLB12-EX.srv.huawei-3com.com>
	<b3e2b00d-94fb-4d51-1073-15047eb60b0b@suse.com>
Message-ID: <f9f03096-3d17-38f0-6ebd-16f7fe68d595@gmail.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com



On 16/11/28 14:06, Eric Ren wrote:
> Hi,
>
> On 11/26/2016 08:15 PM, Guozhonghua wrote:
>> The three loops can be optimized into one loop and its sub loops, so as small code can do the same work.
>> The patch is based on the linux-4.9-rc6.
>>
>> Signed-off-by: Guozhonghua <guozhonghua@h3c.com>
>>
>>
>> --- ocfs2.orig/dlm/dlmrecovery.c        2016-11-26 19:13:04.833023242 +0800
>> +++ ocfs2/dlm/dlmrecovery.c     2016-11-26 19:24:03.982552497 +0800
> I don't think this patch could be applied cleanly:
> ------
> zhen at desktop:~/linux> git am ~/patches/temp/\[PATCH\]\ ocfs2\:\ Optimization\ of\ code\
> while\ free\ dead\ locks..eml
> Applying: ocfs2: Optimization of code while free dead locks.
> .git/rebase-apply/patch:7: trailing whitespace.
>          struct list_head *queue = NULL;
> .git/rebase-apply/patch:8: trailing whitespace.
>          int i;
> fatal: corrupt patch at line 9
> Patch failed at 0001 ocfs2: Optimization of code while free dead locks.
> ------
>
> Please go through the docs below:
> [1] https://kernelnewbies.org/FirstKernelPatch
>
> The file path (ocfs2/dlm/dlmrecovery.c ) is weird.  It should be like:
>
>                     diff --git a/fs/ocfs2/file.c b/fs/ocfs2/file.c
>
>> @@ -2268,6 +2268,8 @@ static void dlm_free_dead_locks(struct d
>>    {
>>           struct dlm_lock *lock, *next;
>>           unsigned int freed = 0;
>> +       struct list_head *queue = NULL;
>> +       int i;
>>
>>           /* this node is the lockres master:
>>            * 1) remove any stale locks for the dead node
>> @@ -2280,33 +2282,19 @@ static void dlm_free_dead_locks(struct d
>>            * to force the DLM_UNLOCK_FREE_LOCK action so as to free the locks */
>>
>>           /* TODO: check pending_asts, pending_basts here */
>> -       list_for_each_entry_safe(lock, next, &res->granted, list) {
>> -               if (lock->ml.node == dead_node) {
>> -                       list_del_init(&lock->list);
>> -                       dlm_lock_put(lock);
>> -                       /* Can't schedule DLM_UNLOCK_FREE_LOCK - do manually */
>> -                       dlm_lock_put(lock);
>> -                       freed++;
>> +       for (i = DLM_BLOCKED_LIST; i >= DLM_GRANTED_LIST; i--) {
> Is it right to loop the lists in a reversed order to the original?
>
> Eric
We have to keep the traverse order from granted to blocked.

Thanks,
Joseph
>> +               queue = dlm_list_idx_to_ptr(res, i);
>> +               list_for_each_entry_safe(lock, next, queue, list) {
>> +                       if (lock->ml.node == dead_node) {
>> +                               list_del_init(&lock->list);
>> +                               dlm_lock_put(lock);
>> +
>> +                               /* Can't schedule DLM_UNLOCK_FREE_LOCK - do manually */
>> +                               dlm_lock_put(lock);
>> +                               freed++;
>> +                       }
>>                   }
>> -       }
>> -       list_for_each_entry_safe(lock, next, &res->converting, list) {
>> -               if (lock->ml.node == dead_node) {
>> -                       list_del_init(&lock->list);
>> -                       dlm_lock_put(lock);
>> -                       /* Can't schedule DLM_UNLOCK_FREE_LOCK - do manually */
>> -                       dlm_lock_put(lock);
>> -                       freed++;
>> -               }
>> -       }
>> -       list_for_each_entry_safe(lock, next, &res->blocked, list) {
>> -               if (lock->ml.node == dead_node) {
>> -                       list_del_init(&lock->list);
>> -                       dlm_lock_put(lock);
>> -                       /* Can't schedule DLM_UNLOCK_FREE_LOCK - do manually */
>> -                       dlm_lock_put(lock);
>> -                       freed++;
>> -               }
>> -       }
>> +       }
>>
>>           if (freed) {
>>                   mlog(0, "%s:%.*s: freed %u locks for dead node %u, "
>>
>> -------------------------------------------------------------------------------------------------------------------------------------
>> ????????????????????????????????????????
>> ????????????????????????????????????????
>> ????????????????????????????????????????
>> ???
>> This e-mail and its attachments contain confidential information from H3C, which is
>> intended only for the person or entity whose address is listed above. Any use of the
>> information contained herein in any way (including, but not limited to, total or partial
>> disclosure, reproduction, or dissemination) by persons other than the intended
>> recipient(s) is prohibited. If you receive this e-mail in error, please notify the sender
>> by phone or email immediately and delete it!
>
>
> _______________________________________________
> Ocfs2-devel mailing list
> Ocfs2-devel at oss.oracle.com
> https://oss.oracle.com/mailman/listinfo/ocfs2-devel
