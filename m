From: Ryan Ding <ryan.ding@oracle.com>
Date: Mon, 21 Dec 2015 10:32:19 +0800
Subject: [Ocfs2-devel] [PATCH] ocfs2: call ocfs2_abort when journal abort
In-Reply-To: <20151218155035.7b82a3a4f1b555ed1106acfa@linux-foundation.org>
References: <1450423165-14695-1-git-send-email-ryan.ding@oracle.com>
	<20151218155035.7b82a3a4f1b555ed1106acfa@linux-foundation.org>
Message-ID: <567764B3.8040308@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi Andrew,

Thanks for you comments, please see my reply:

On 12/19/2015 07:50 AM, Andrew Morton wrote:
> On Fri, 18 Dec 2015 15:19:25 +0800 Ryan Ding <ryan.ding@oracle.com> wrote:
>
>> orabug: 22293201
>>
>> journal can not recover from abort state, so we should take following action to
>> prevent file system from corruption:
>>
>> 1. change to readonly filesystem when local mount. We can not afford further
>>     write, so change to RO state is reasonable.
>>
>> 2. panic when cluster mount. Because we can not release lock resource in this
>>     state, other node will hung when it require a lock owned by this node. So
>>     panic and remaster is a reasonable choise.
>>
>> ocfs2_abort() will do all the above work.
>>
>> ...
>>
>> --- a/fs/ocfs2/journal.c
>> +++ b/fs/ocfs2/journal.c
>> @@ -30,7 +30,6 @@
>>   #include <linux/kthread.h>
>>   #include <linux/time.h>
>>   #include <linux/random.h>
>> -#include <linux/delay.h>
>>   
>>   #include <cluster/masklog.h>
>>   
>> @@ -2265,7 +2264,7 @@ static int __ocfs2_wait_on_mount(struct ocfs2_super *osb, int quota)
>>   
>>   static int ocfs2_commit_thread(void *arg)
>>   {
>> -	int status;
>> +	int status = 0;
>>   	struct ocfs2_super *osb = arg;
>>   	struct ocfs2_journal *journal = osb->journal;
>>   
>> @@ -2279,22 +2278,18 @@ static int ocfs2_commit_thread(void *arg)
>>   		wait_event_interruptible(osb->checkpoint_event,
>>   					 atomic_read(&journal->j_num_trans)
>>   					 || kthread_should_stop());
>> +		if (status < 0)
>> +			/* As we can not terminate by myself, just enter an
>> +			 * empty loop to wait for stop. */
>> +			continue;
> This is a busy-wait loop, isn't it?  That's going to chew lots of CPU
> and in some situations (eg, SMP=n, PREEMPT=n) it will lock up the
> kernel because kjournald will never run.
This will not be a busy loop, because j_num_trans will be 0 here (when 
cluster mount, system will panic to prevent further corruption of ocfs2 
file system; when local mount, this value will be 0 all the time), so 
this thread will always wait on above wait wait_event_interruptible().
But to make code more clearer, I will add code to set j_num_trans to 0in 
this function.
>
>>   		status = ocfs2_commit_cache(osb);
>> -		if (status < 0) {
>> -			static unsigned long abort_warn_time;
>> -
>> -			/* Warn about this once per minute */
>> -			if (printk_timed_ratelimit(&abort_warn_time, 60*HZ))
>> -				mlog(ML_ERROR, "status = %d, journal is "
>> -						"already aborted.\n", status);
>> -			/*
>> -			 * After ocfs2_commit_cache() fails, j_num_trans has a
>> -			 * non-zero value.  Sleep here to avoid a busy-wait
>> -			 * loop.
>> -			 */
>> -			msleep_interruptible(1000);
>> -		}
>> +		if (status < 0)
>> +			/* journal can not recover from abort state, there is
>> +			 * no need to keep commit cache. So we should either
>> +			 * change to readonly(local mount) or just panic
>> +			 * (cluster mount). */
>> +			ocfs2_abort(osb->sb, "Detected aborted journal");
> Coding-style issues:
>
> It would be more conventional to add braces for the comment:
>
> 		if (status < 0) {
> 			/* journal can not recover from abort state, there is
> 			 * no need to keep commit cache. So we should either
> 			 * change to readonly(local mount) or just panic
> 			 * (cluster mount). */
> 			ocfs2_abort(osb->sb, "Detected aborted journal");
> 		}
>
> And to lay out the comment like this:
>
> 			/*
> 			 * journal can not recover from abort state, there is
> 			 * no need to keep commit cache. So we should either
> 			 * change to readonly(local mount) or just panic
> 			 * (cluster mount).
> 			 */
OK

I will resend v2 patch later.

Thanks,
Ryan
