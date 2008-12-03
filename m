From: Coly Li <coyli@suse.de>
Date: Wed, 03 Dec 2008 10:23:48 +0800
Subject: [Ocfs2-devel] [PATCH] ocfs2: fix DLM_BADARGS error in
 concurrent file locking
In-Reply-To: <4935B20B.9040309@oracle.com>
References: <493524C0.4090506@suse.de> <4935B20B.9040309@oracle.com>
Message-ID: <4935EDB4.7020405@suse.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com



Sunil Mushran Wrote:
> Coly Li wrote:
>> diff --git a/fs/ocfs2/dlm/dlmmaster.c b/fs/ocfs2/dlm/dlmmaster.c
>> index 44f87ca..c777844 100644
>> --- a/fs/ocfs2/dlm/dlmmaster.c
>> +++ b/fs/ocfs2/dlm/dlmmaster.c
>> @@ -742,6 +742,19 @@ lookup:
>>              goto lookup;
>>          }
>>
>> +        /* tmpres might be initiating by another process, in this case
>> +         * we should wait until the initiation done  */
>> +        spin_lock(&tmpres->spinlock);
>> +        if (tmpres->owner == DLM_LOCK_RES_OWNER_UNKNOWN ||
>> +            (tmpres->state & DLM_LOCK_RES_IN_PROGRESS)) {
>> +            __dlm_wait_on_lockres_flags(tmpres,
>> DLM_LOCK_RES_IN_PROGRESS);
>> +            spin_unlock(&tmpres->spinlock);
>> +            dlm_lockres_put(tmpres);
>> +            tmpres = NULL;
>> +            goto lookup;
>> +        }
>> +        spin_unlock(&tmpres->spinlock);
>> +
>>          mlog(0, "found in hash!\n");
>>          if (res)
>>              dlm_lockres_put(res);
> 
> This will work but we are wasting cycles as we are looking up the same
> lockres again. How about the following? The mlog is for testing.
> 
> --- a/fs/ocfs2/dlm/dlmmaster.c
> +++ b/fs/ocfs2/dlm/dlmmaster.c
> @@ -742,6 +742,17 @@ lookup:
>                        goto lookup;
>                }
> 
> +               /* wait if lock resource is being mastered by another
> thread */
> +               spin_lock(&tmpres->spinlock);
> +               if (tmpres->owner == DLM_LOCK_RES_OWNER_UNKNOWN) {
> +                       mlog(ML_NOTICE, "%s:%.*s Another thread is
> mastering "
> +                            "this resource\n", dlm->name, namelen,
> lockid);
> +                       __dlm_wait_on_lockres_flags(tmpres,
> +                                                  
> DLM_LOCK_RES_IN_PROGRESS);
> +                       BUG_ON(tmpres->owner ==
> DLM_LOCK_RES_OWNER_UNKNOWN);
> +               }
> +               spin_unlock(&tmpres->spinlock);
This is the way I tried firstly, didn't not work well. When I tested with more than 20 forks on 1
node, user space process got segmentation fault and kernel got oops. The kernel oops was triggered
on BUG_ON(res->inflight_locks == 0) in __dlm_lockres_drop_inflight_ref() IIRC.

Also, BUG_ON(tmpres->owner == DLM_LOCK_RES_OWNER_UNKNOWN) might not always be correct IMHO. Even we
return from __dlm_wait_on_lockres_flags(), there still is chance to set tmpres->owner to
DLM_LOCK_RES_OWNER_UNKNOWN before BUG_ON is tested (in theory), especially when dlm->spinlock is not
held.

> +
>                mlog(0, "found in hash!\n");
>                if (res)
>                        dlm_lockres_put(res);
> 
> Secondly, the patch comments are more than required. We should prune it
> down a bit. Like:
> 
> =========================================================================
> ocfs2/dlm: Fix lockres mastery race
Cool. Since I was not sure this was a race error, you can see, I did not mention race anywhere.
I like this title more ;-)

> 
> dlm_get_lock_resource() is supposed to return a lock resource with a proper
> master. If multiple concurrent threads attempt to lookup the lockres for
> the
> same lockid, one or more threads are likely to return a lockres without a
> proper master, if the lock mastery is underway.
> 
> This patch makes the threads wait in dlm_get_lock_resource() while the
> mastery
> is underway, ensuring all threads return the lockres with a proper master.
> 
> This issue is limited to users using the flock() syscall. For all other fs
> operations, dlmglue ensures that only one thread is performing dlm
> operations
> for a given lockid at any one time.
> 
> Signed-off-by: Coly Li <...>
> =========================================================================
> 
> Corrections welcome.
The comment is perfect IMHO.

> 
> Lastly, test the patch not only with the flock() test but also otherwise.
> Say, with recovery. Part of fixing bugs is ensuring the fix does not break
> existing functionality. Run all multinode tests in ocfs2-test.
Sure, thanks for the suggestion. I will test the patch will all multinode tests, and submit a patch
to ocfs2 test-suite for this fix.

-- 
Coly Li
SuSE PRC Labs
