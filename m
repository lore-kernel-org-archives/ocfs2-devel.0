From: Joseph Qi <joseph.qi@huawei.com>
Date: Wed, 29 Apr 2015 08:51:10 +0800
Subject: [Ocfs2-devel] [PATCH] ocfs2/dlm: fix race between purge and get
	lock resource
In-Reply-To: <20150428133204.142f01cf1fa14e41ae39a943@linux-foundation.org>
References: <553B3CAB.9020102@huawei.com>
	<20150428133204.142f01cf1fa14e41ae39a943@linux-foundation.org>
Message-ID: <55402AFE.7080808@huawei.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Mark Fasheh <mfasheh@suse.com>, Joel Becker <jlbec@evilplan.org>, Sunil Mushran <sunil.mushran@gmail.com>, Xuejiufei <xuejiufei@huawei.com>, "ocfs2-devel@oss.oracle.com" <ocfs2-devel@oss.oracle.com>, stable@vger.kernel.org

Hi Andrew,

On 2015/4/29 4:32, Andrew Morton wrote:
> On Sat, 25 Apr 2015 15:05:15 +0800 Joseph Qi <joseph.qi@huawei.com> wrote:
> 
>> There is a race between purge and get lock resource, which will lead to
>> ast unfinished and system hung. The case is described below:
>>
>> mkdir                                  dlm_thread
>> -----------------------------------------------------------------------
>> o2cb_dlm_lock                        |
>> -> dlmlock                           |
>>   -> dlm_get_lock_resource           |
>>     -> __dlm_lookup_lockres_full     |
>>       -> spin_unlock(&dlm->spinlock) |
>>                                      | dlm_run_purge_list
>>                                      | -> dlm_purge_lockres
>>                                      |   -> dlm_drop_lockres_ref
>>                                      |   -> spin_lock(&dlm->spinlock)
>>                                      |   -> spin_lock(&res->spinlock)
>>                                      |   -> ~DLM_LOCK_RES_DROPPING_REF
>>                                      |   -> spin_unlock(&res->spinlock)
>>                                      |   -> spin_unlock(&dlm->spinlock)
>>       -> spin_lock(&tmpres->spinlock)|
>>       DLM_LOCK_RES_DROPPING_REF cleared |
>>       -> spin_unlock(&tmpres->spinlock) |
>>       return the purged lockres         |
>>
>> So after this, once ast comes, it will ingore the ast because the
>> lockres cannot be found anymore. Thus the OCFS2_LOCK_BUSY won't be
>> cleared and corresponding thread hangs.
>> The &dlm->spinlock was hold when checking DLM_LOCK_RES_DROPPING_REF at
>> the very begining. And commit 7b791d6856 (ocfs2/dlm: Fix race during
>> lockres mastery) moved it up because of the possible wait.
>> So take the &dlm->spinlock and introduce a new wait function to fix the
>> race.
>>
>> ...
>>
>> --- a/fs/ocfs2/dlm/dlmthread.c
>> +++ b/fs/ocfs2/dlm/dlmthread.c
>> @@ -77,6 +77,29 @@ repeat:
>>  	__set_current_state(TASK_RUNNING);
>>  }
>>
>> +void __dlm_wait_on_lockres_flags_new(struct dlm_ctxt *dlm,
>> +		struct dlm_lock_resource *res, int flags)
>> +{
>> +	DECLARE_WAITQUEUE(wait, current);
>> +
>> +	assert_spin_locked(&dlm->spinlock);
>> +	assert_spin_locked(&res->spinlock);
> 
> Not strictly needed - lockdep will catch this.   A minor thing.
> 
>> +	add_wait_queue(&res->wq, &wait);
>> +repeat:
>> +	set_current_state(TASK_UNINTERRUPTIBLE);
>> +	if (res->state & flags) {
>> +		spin_unlock(&res->spinlock);
>> +		spin_unlock(&dlm->spinlock);
>> +		schedule();
>> +		spin_lock(&dlm->spinlock);
>> +		spin_lock(&res->spinlock);
>> +		goto repeat;
>> +	}
>> +	remove_wait_queue(&res->wq, &wait);
>> +	__set_current_state(TASK_RUNNING);
>> +}
> 
> This is pretty nasty.  Theoretically this could spin forever, if other
> tasks are setting the flag in a suitably synchronized fashion.
> 
> Is there no clean approach?  A reorganization of the locking?
> 
Do you mean the flag won't be cleared forever? If so, only taking
&res->spinlock also has the same risk. But we haven't found this in our
test/production environments so far.
To fix the race case above, I don't have another approach besides taking
&dlm->spinlock.

> .
> 
