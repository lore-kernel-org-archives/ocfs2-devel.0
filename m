From: Wengang <wen.gang.wang@oracle.com>
Date: Fri, 11 Apr 2014 09:32:40 +0800
Subject: [Ocfs2-devel] [PATCH v2] ocfs2: retry once
 dlm_dispatch_assert_master failed with ENOMEM
In-Reply-To: <20140410151423.2e8280458f6f5564dcc2aa0a@linux-foundation.org>
References: <5343D3A8.1080302@huawei.com>	<20140409144459.ffbb36cc9e6c15382d5a2674@linux-foundation.org>	<5345F0DD.3050800@oracle.com>
	<20140410151423.2e8280458f6f5564dcc2aa0a@linux-foundation.org>
Message-ID: <53474638.4010308@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

? 2014?04?11? 06:14, Andrew Morton ??:
> On Thu, 10 Apr 2014 09:16:13 +0800 Wengang <wen.gang.wang@oracle.com> wrote:
>
>>>> @@ -1685,18 +1688,30 @@ int dlm_master_requery_handler(struct o2net_msg *msg, u32 len, void *data,
>>>>    
>>>>    	hash = dlm_lockid_hash(req->name, req->namelen);
>>>>    
>>>> +retry:
>>>>    	spin_lock(&dlm->spinlock);
>>>>    	res = __dlm_lookup_lockres(dlm, req->name, req->namelen, hash);
>>>>    	if (res) {
>>>>    		spin_lock(&res->spinlock);
>>>>    		master = res->owner;
>>>>    		if (master == dlm->node_num) {
>>>> -			int ret = dlm_dispatch_assert_master(dlm, res,
>>>> -							     0, 0, flags);
>>>> +			ret = dlm_dispatch_assert_master(dlm, res,
>>>> +					0, 0, flags);
>>>>    			if (ret < 0) {
>>>> -				mlog_errno(-ENOMEM);
>>>> -				/* retry!? */
>>>> -				BUG();
>>>> +				mlog_errno(ret);
>>>> +
>>>> +				/* ENOMEM returns, retry until
>>>> +				 * DISPATCH_ASSERT_RETRY_TIMES reached */
>>>> +				if (retries < DISPATCH_ASSERT_RETRY_TIMES) {
>>>> +					spin_unlock(&res->spinlock);
>>>> +					dlm_lockres_put(res);
>>>> +					spin_unlock(&dlm->spinlock);
>>>> +					msleep(50);
>>>> +					retries++;
>>>> +					goto retry;
>>>> +				} else {
>>>> +					BUG();
>>>> +				}
>>> urgh, this is not good.  dlm_dispatch_assert_master() uses GFP_ATOMIC
>>> and the chances of that failing are relatively high.  The msleep()
>>> might save us, but what happens if we cannot get more memory until some
>>> writeback occurs to this filesystem?
>>>
>>> It would be much better to use GFP_KERNEL in
>>> dlm_dispatch_assert_master().  That means preallocating the
>>> dlm_work_item in the caller before taking the spinlock.
>>>
>> Though to use GFP_KERNEL is safe, it may block the whole o2cb network
>> message processing(I detailed this in a separated thread).
> The code you're proposing can stall for 100ms.  Does GFP_KERNEL ever
> take longer than that?
>

I not sure about the time allocation with GFP_KERNEL would take, but for 
a heavy loaded system, taking more than 100ms is not possible?

>> I think the original GFP_ATOMIC is for that purpose.
> Well.  We shouldn't "think" - we should know.  And the way we know is
> by adding code comments.  The comments in your proposed patch don't
> improve things because they describe "what" the code is doing (which
> was obvious anyway) but they do not explain "why".

This patch is not my patch, I just said my opinion. Neither did I ACK on 
this patch. I am thinking without making peer retry, this patch doesn't 
look that meaningful.

>> So I still persist we find a
>> way to return a EAGAIN-like error code to peer in case of no-mem, and
>> peer retries on receiving the EAGAIN-like error.
> There are all sorts of ways around this.  For example, try the
> allocation with GFP_ATOMIC|__GFP_NOWARN.  In the very rare case where
> this fails, fall back to GFP_KERNEL.  This is probably equivalent to
> using GFP_KERNEL|__GFP_HIGH.
>
>
Sure, I was suggesting the patch owner. If we are sure with GFP_KERNEL 
won't take longer than 100ms(or 200ms or something like this, not very 
long), I agree with GFP_KERNEL; If not, we'd better let peer node retry.

I am wondering if there can be a timeout version of kzalloc families, 
but cheap. So that we can try this when failed with NOFS.

thanks,
wengang
