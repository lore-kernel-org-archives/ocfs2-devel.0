From: Srinivas Eeda <srinivas.eeda@oracle.com>
Date: Thu, 17 Jun 2010 01:32:59 -0700
Subject: [Ocfs2-devel] [PATCH 1/2] ocfs2 fix o2dlm dlm run purgelist
In-Reply-To: <20100617013930.GA14014@mail.oracle.com>
References: <1276663383-8238-1-git-send-email-srinivas.eeda@oracle.com>
	<20100617013930.GA14014@mail.oracle.com>
Message-ID: <4C19DDBB.7060704@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On 6/16/2010 6:39 PM, Joel Becker wrote:
> On Tue, Jun 15, 2010 at 09:43:02PM -0700, Srinivas Eeda wrote:
>   
>> There are two problems in dlm_run_purgelist
>>
>> 1. If a lockres is found to be in use, dlm_run_purgelist keeps trying to purge
>> the same lockres instead of trying the next lockres.
>>
>> 2. When a lockres is found unused, dlm_run_purgelist releases lockres spinlock
>> before setting DLM_LOCK_RES_DROPPING_REF and calls dlm_purge_lockres.
>> spinlock is reacquired but in this window lockres can get reused. This leads
>> to BUG.
>>
>> This patch modifies dlm_run_purgelist to skip lockres if it's in use and purge
>>  next lockres. It also sets DLM_LOCK_RES_DROPPING_REF before releasing the
>> lockres spinlock protecting it from getting reused.
>>
>> Signed-off-by: Srinivas Eeda <srinivas.eeda@oracle.com>
>>     
>
> 	I don't really like the way you did this.  You're absolutely
> right that we need to hold the spinlock while setting DROPPING REF.  But
> there's no need to lift the lockres check logic into run_purge_list.
>   
As of today, we always get the lockres from the head of the 
dlm->purge_list. If it is in use, we keep trying. If that gets purged, 
we move to next res which again would be on the head of the 
dlm->purge_list. But with my change that won't be the case. If first 
(few) lockres are in use, we will try the one we could purge. So we 
should get the next lockres before list_del_init(&res->purge) happens 
and hence I moved the code. If you didn't like the delete code in 
dlm_run_purge_list, then we have to make dlm_purge_lockres to return the 
next lockres that should get purged.

If you are suggesting that we move the lockres to the tail if we found 
it in use, then the code will be lot more readable. The current code 
doesn't move the unused lockres to tail, so wanted to preserve that 
logic as I am not sure what was the original intent. If move used 
lockres to tail, would you suggest we also update lockres->last_used?
>> @@ -257,15 +224,12 @@ static void dlm_run_purge_list(struct dlm_ctxt *dlm,
>>  		 * refs on it -- there's no need to keep the lockres
>>  		 * spinlock. */
>>  		spin_lock(&lockres->spinlock);
>> -		unused = __dlm_lockres_unused(lockres);
>> -		spin_unlock(&lockres->spinlock);
>> -
>> -		if (!unused)
>> -			continue;
>>  
>>  		purge_jiffies = lockres->last_used +
>>  			msecs_to_jiffies(DLM_PURGE_INTERVAL_MS);
>>  
>> +		mlog(0, "purging lockres %.*s\n", lockres->lockname.len,
>> +		     lockres->lockname.name);
>>  		/* Make sure that we want to be processing this guy at
>>  		 * this time. */
>>  		if (!purge_now && time_after(purge_jiffies, jiffies)) {
>>     
>
> 	In fact, I'd move the __dlm_lockres_unused() and
> purge_now||time_after() checks into dlm_purge_lockres().  It can return
> -EBUSY if the lockres is in use.  It can return -ETIME if purge_now==0
> and time_after hits.  Then inside run_purge_list() you just do:
>
> 		spin_lock(&lockres->spinlock);
> 		ret = dlm_purge_lockres(dlm, res, purge_now);
> 		spin_unlock(&lockres->spinlock);
> 		if (ret == -EAGAIN)
> 			break;
> 		else if (ret == -EBUSY) {
> 			lockres = list_entry(lockres->next);
> 			continue;
> 		else if (ret)
> 			BUG();
>   
what would list_entry return, if the lockres was the last on the list. I 
was thinking it would return something random ..
> 	What about the dlm_lockres_get()?  That's only held while we
> drop the dlm spinlock in dlm_purge_lockres(), so you can move it there.
> You take the kref only after the _unused() and time_after() checks.
> 	This actually would make run_purge_list() more readable, not
> less.
>   
I agree that it is less readable now, but didn't find a better way as I 
am not sure how to get to the next lockres if the current lockres that 
got dropped is the middle one. :)
> Joel
>
>   
-------------- next part --------------
An HTML attachment was scrubbed...
URL: http://oss.oracle.com/pipermail/ocfs2-devel/attachments/20100617/bb534bfc/attachment-0001.html 
